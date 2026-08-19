#macro GITHUB_BUG_REPORTER global.github_bug_reporter
#macro GITHUB_ISSUES_OWNER "Adeptus-Dominus"
#macro GITHUB_ISSUES_REPO "ChapterMaster"
#macro GITHUB_ISSUES_PAGE_SIZE 100
#macro GITHUB_ISSUES_MAX_PAGE 100
#macro GITHUB_ISSUES_MAX_PAGE_RETRIES 3
#macro GITHUB_ISSUES_MAX_DEDUP_RETRIES 1
#macro GITHUB_ISSUES_DEDUP_RETRY_DELAY 30
#macro GITHUB_ISSUES_BODY_MAX_CHARS 60000

/// @desc Reports errors to GitHub Issues with in-game dedup against open issue titles.
/// Creates a new issue, or comments the duplicate with full context.
/// Singleton, constructed in boot_sequence. Access via GITHUB_BUG_REPORTER.
function GitHubBugReporter() constructor {
    /// @desc Entry point. Dedup lookup, then create issue or comment.
    /// @param {Struct.GameError} _error The GameError to report.
    /// @param {String} _user_text Optional user description from the async dialog.
    static report = function(_error, _user_text = "") {
        var _token = "__GITHUB_ISSUES_TOKEN__";

        if (_token == "" || string_pos("__", _token) == 1) {
            LOGGER.debug("No GitHub token found. Build is likely local/dev.");
            return;
        }

        // GML methods do not capture local variables
        var _context = {
            client: new GitHub(_token),
            error: _error,
            body: __build_body(_error, _user_text),
            problem_line: __problem_line_from_title(_error.report_title),
            find_duplicate: __find_duplicate,
            lookup_page: 1,
            lookup_retries: 0,
            dedup_retries: 0,
            pages_loaded: 0,
            all_issues: [],
        };

        // Fetches the current lookup page, reusing the same handlers for every page
        _context.fetch_page = method(_context, function() {
            self.lookup = self.client.getIssues(GITHUB_ISSUES_OWNER, GITHUB_ISSUES_REPO, undefined, "open", undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, GITHUB_ISSUES_PAGE_SIZE, self.lookup_page);
            self.lookup.setCallback(self.lookup_handler)
                .setErrorback(self.lookup_error_handler);
        });

        // Shared one-shot retry timesource. GML methods cannot capture locals, so
        // _refetch is stored on the context until the timesource fires
        _context.schedule_retry = method(_context, function(_delay, _refetch) {
            self.__pending_retry = _refetch;
            self.retry_timesource = time_source_create(time_source_global, _delay, time_source_units_seconds, method(self, function() {
                time_source_destroy(self.retry_timesource);
                self.retry_timesource = undefined;
                self.__pending_retry();
                self.__pending_retry = undefined;
            }), [], 1, time_source_expire_after);
            time_source_start(self.retry_timesource);
        });

        // Appends a page of issues, then fetches the next one or finalizes the dedup
        _context.lookup_handler = method(_context, function(_result, _request) {
            // Append the current page
            var _page = is_array(_result) ? _result : [];
            if (is_array(_result)) {
                self.pages_loaded++;
            }
            for (var i = 0, _len = array_length(_page); i < _len; i++) {
                array_push(self.all_issues, _page[i]);
            }

            // Fetch the next page while the last one came back full and the client
            // page limit allows it (GitHub.getIssues clamps pages to 100)
            if (array_length(_page) == GITHUB_ISSUES_PAGE_SIZE && self.lookup_page < GITHUB_ISSUES_MAX_PAGE) {
                self.lookup_page++;
                self.lookup_retries = 0;
                self.fetch_page();
                return;
            }

            // All pages fetched - finalize the dedup
            self.finalize();
        });

        // Retries only transient page failures (server errors, rate limiting), then
        // finalizes with whatever was collected so the report is never silently dropped
        _context.lookup_error_handler = method(_context, function(_result, _request) {
            var _status = _request.httpStatus;
            var _retryable = is_real(_status) && (_status >= 500 || _status == 429 || _status == 403);

            if (self.lookup_retries < GITHUB_ISSUES_MAX_PAGE_RETRIES && _retryable) {
                self.lookup_retries++;

                // X-RateLimit-Reset is Unix epoch seconds - convert now to the same unit
                var _resetHeader = is_struct(_request.responseHeaders) ? _request.responseHeaders[$ "X-RateLimit-Reset"] : undefined;
                var _reset = (is_string(_resetHeader) && _resetHeader != "") ? real(_resetHeader) : 0;
                var _now_unix = date_second_span(date_create_datetime(1970, 1, 1, 0, 0, 0), date_current_datetime());
                var _delay = max(0, _reset - _now_unix);

                if (_delay > 0) {
                    self.schedule_retry(_delay, self.fetch_page);
                } else {
                    self.fetch_page();
                }
                return;
            }

            LOGGER.error($"Failed to fetch open issues for dedup: {_result}");

            if (self.pages_loaded > 0) {
                self.finalize(false);
            } else {
                // No page ever loaded - a transient outage would otherwise lose the
                // report; retry once, then create without dedup
                if (self.dedup_retries < GITHUB_ISSUES_MAX_DEDUP_RETRIES) {
                    self.dedup_retries++;
                    self.schedule_retry(GITHUB_ISSUES_DEDUP_RETRY_DELAY, method(self, function() {
                        self.lookup_retries = 0;
                        self.fetch_page();
                    }));
                    return;
                }

                // Create without dedup rather than drop the report - if GitHub is
                // unreachable the create fails too, so duplicates stay rare
                LOGGER.warn($"Open-issue lookup failed permanently; creating issue without dedup: {_result}");
                self.finalize(true);
            }
        });

        _context.finalize = method(_context, function(_create_allowed = true) {
            var _duplicate = self.find_duplicate(self.all_issues, self.problem_line);

            if (_duplicate != undefined) {
                // Duplicate already reported - attach full context as a comment.
                self.duplicate = _duplicate;
                var _comment = self.client.createIssueComment(GITHUB_ISSUES_OWNER, GITHUB_ISSUES_REPO, _duplicate.number, self.body);
                _comment.setCallback(method(self, function(_result2, _request2) {
                    LOGGER.debug($"Duplicate reported as comment on issue #{self.duplicate.number}.");
                    show_message_async("Report sent to the Administratum.");
                }))
                    .setErrorback(method(self, function(_result2, _request2) {
                        LOGGER.error($"Failed to post issue comment: {_result2}");
                    }));
            } else if (_create_allowed) {
                // No duplicate - create a new issue.
                var _issue = self.client.createIssue(GITHUB_ISSUES_OWNER, GITHUB_ISSUES_REPO, new GitHubIssue(self.error.report_title, self.body));
                _issue.setCallback(method(self, function(_result2, _request2) {
                    LOGGER.debug($"New issue created: #{_result2.number}.");
                    show_message_async("Report sent to the Administratum.");
                }))
                    .setErrorback(method(self, function(_result2, _request2) {
                        LOGGER.error($"Failed to create issue: {_result2}");
                    }));
            } else {
                LOGGER.error("No duplicate found and dedup data is incomplete; issue not created.");
            }
        });

        // Start the paginated lookup
        _context.fetch_page();
    };

    /// @desc Builds the report body shared by new issues and comments.
    /// @param {Struct.GameError} _error The GameError to report.
    /// @param {String} _user_text Optional user description from the async dialog.
    /// @returns {String} The markdown body.
    static __build_body = function(_error, _user_text = "") {
        var _reporter = (_error.username != "") ? _error.username : "anonymous";
        var _user_message = (_user_text != "") ? _user_text : "N/A";

        // GitHub caps issue/comment bodies near 64KB; a longer log would 422 and the report is lost silently. We don't expect such big logs, but just in case.
        var _log = _error.full_log;
        var _overhead = string_length(_reporter) + string_length(_user_message) + 120;
        var _max_log = max(GITHUB_ISSUES_BODY_MAX_CHARS - _overhead, 0);
        if (string_length(_log) > _max_log) {
            _log = string_copy(_log, 1, _max_log) + $"\n\n... [log truncated: {string_length(_error.full_log) - _max_log} chars omitted]";
        }

        var _sections = [
            _log,
            "",
            "### Reporter:",
            _reporter,
            "",
            "### User Message:",
            _user_message,
        ];

        var _body = "";
        for (var i = 0, _len = array_length(_sections); i < _len; i++) {
            _body += $"{_sections[i]}\n";
        }

        return _body;
    };

    /// @desc Extracts the problem line from a report title, stripping the CRASH!/version prefix.
    /// @param {String} _report_title The issue title format.
    /// @returns {String} The problem line used for dedup matching.
    static __problem_line_from_title = function(_report_title) {
        var _title = _report_title;
        if (string_starts_with(_title, "[CRASH! ]")) {
            _title = string_delete(_title, 1, string_length("[CRASH! ]"));
        }

        var _pos = string_pos("] ", _title);
        return (_pos > 0) ? string_delete(_title, 1, _pos + 1) : _title;
    };

    /// @desc Finds the first open issue whose title contains the problem line.
    /// @param {Array<Struct.GitHubIssue>} _issues The parsed getIssues response.
    /// @param {String} _problem_line The problem line to match against issue titles.
    /// @returns {Undefined|Struct.GitHubIssue} The matching issue struct, or undefined.
    static __find_duplicate = function(_issues, _problem_line) {
        if (!is_array(_issues) || _problem_line == "") {
            return undefined;
        }

        for (var i = 0, _len = array_length(_issues); i < _len; i++) {
            if (is_struct(_issues[i]) && !variable_struct_exists(_issues[i], "pull_request")) {
                var _title = _issues[i].title;
                if (is_string(_title) && string_pos(_problem_line, _title) > 0) {
                    return _issues[i];
                }
            }
        }

        return undefined;
    };
}
