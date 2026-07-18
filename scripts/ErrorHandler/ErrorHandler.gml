#macro ERROR_HANDLER global.error_handler
#macro STR_ERROR_MESSAGE_HEAD $"Your game just encountered and caught an error!"
#macro STR_ERROR_MESSAGE_HEAD2 $"Your game just encountered a critical error! :("
#macro STR_ERROR_MESSAGE_PS $"P.S. You can ALT-TAB and try to continue playing, though it's recommended to wait for a response in the bug-report forum."

function GameError(_header, _message, _stacktrace = "", _critical = false, _report_title = "") constructor {
    var _context = ERROR_HANDLER._get_context();

    header = _header;
    message = _message;
    stacktrace = _stacktrace;
    critical = _critical;
    report_title = _report_title;

    chapter = _context.chapter;
    turn = _context.turn;
    seed = _context.seed;

    date_time = DATE_TIME_3;
    game_version = global.game_version;
    build_date = global.build_date;
    commit_hash = global.commit_hash;
    username = global.settings.username ?? "";

    // feather ignore once GM2043
    full_log = build_full_log();
    // feather ignore once GM2043
    error_file_text = build_error_file_text();
    // feather ignore once GM2043
    player_message = build_player_message();

    /// @description Builds the full log content
    static build_full_log = function() {
        var _sections = [
            header,
            "",
            "### System Details:",
            $"- Date-Time: {date_time}",
            $"- Game Version: {game_version}",
            $"- Build Date: {build_date}",
            $"- Commit Hash: {commit_hash}",
            "",
            "### Save Details:",
            $"- Chapter Name: {chapter}",
            $"- Current Turn: {turn}",
            $"- Game Seed: {seed}",
            "",
            "### Error Details:",
            message,
            "",
            "### Stacktrace:",
            stacktrace,
        ];

        var _full = "";
        for (var i = 0, _len = array_length(_sections); i < _len; i++) {
            _full += $"{_sections[i]}\n";
        }
        return _full;
    };

    /// @description Builds error file text
    static build_error_file_text = function() {
        return (report_title != "") ? $"{report_title}\n{full_log}" : full_log;
    };

    /// @description Builds clipboard text with markdown formatting
    static build_clipboard_text = function() {
        var _clip = (report_title != "") ? $"{report_title}\n" : "";
        _clip += format_codeblock(full_log, "log");
        return _clip;
    };

    /// @description Builds player-facing error message
    static build_player_message = function() {
        var _path_hint = (os_type == os_windows) ? string_replace_all(game_save_id, "/", "\\") : game_save_id;
        var _msg = $"{header}\n\n{message}\n\n";

        _msg += (os_type == os_windows) ? $"The error log was saved at:\n{_path_hint}Logs\\\n\n" : $"The error log was saved at:\n{_path_hint}Logs/\n\n";

        if (UPDATE_CHECKER.compiled) {
            _msg += "You are using a debug build. Automated bug reports disabled.\n\n";
        } else if (UPDATE_CHECKER.update_available) {
            _msg += "You are using an outdated build. Automated bug reports are only accepted for the latest version.\n\n";
            _msg += "Do you want to open the latest release page in your browser?";
        } else if (critical) {
            _msg += "Do you want to send the error log, debug log, and your last autosave to our Discord as a bug report? The process is automated and takes a few seconds, you won't notice anything.";
        } else {
            _msg += "After closing this message, you will be prompted to describe what you were doing.\n";
            _msg += "Your message and the error log will be sent to our Discord automatically. You can decline by pressing 'cancel'.\n\n";
            _msg += $"{STR_ERROR_MESSAGE_PS}";
        }
        return _msg;
    };
}

function ErrorHandler() constructor {
    static _error_queue = [];
    static _active_dialogs = {};
    static _pending_async_id = -1;

    // Instance state for ongoing report flow
    async_id = -1;
    /// @type {Struct.GameError}
    pending_error = undefined;

    /// @desc Provides game-specific state data to the error handler.
    /// @returns {Struct}
    static _get_context = function() {
        var _context = {
            chapter: global.chapter_name ?? "???",
            seed: global.game_seed ?? "???",
            turn: "???",
        };

        if (instance_exists(obj_controller)) {
            _context.turn = obj_controller.turn;
        }

        return _context;
    };

    /// @desc Writes error log file and copies last messages.
    /// @param {string} _file_text The full error text to write.
    static _write_error_log = function(_file_text) {
        if (string_length(_file_text) == 0) {
            return;
        }

        if (!directory_exists(PATH_LOG_DIRECTORY)) {
            directory_create(PATH_LOG_DIRECTORY);
        }

        var _log_file = file_text_open_write($"{PATH_LOG_DIRECTORY}{DATE_TIME_1}_error.log");
        file_text_write_string(_log_file, _file_text);
        file_text_close(_log_file);

        if (file_exists(PATH_LAST_MESSAGES)) {
            if (!directory_exists(PATH_LOG_DIRECTORY)) {
                directory_create(PATH_LOG_DIRECTORY);
            }
            file_copy(PATH_LAST_MESSAGES, $"{PATH_LOG_DIRECTORY}{DATE_TIME_1}_messages.log");
        }
    };

    /// @desc Shows the dialog for one error.
    /// @param {Struct.GameError} _error
    static _show_dialog = function(_error) {
        var _msg_id = show_message_async(_error.player_message);
        _active_dialogs[$ _msg_id] = _error;
    };

    /// @desc Pops the next queued error, if any.
    static _process_next = function() {
        var _len = array_length(_error_queue);
        if (_len > 0) {
            var _next = array_shift(_error_queue);
            _show_dialog(_next);
        }
    };

    /// @desc Singleton entry point. Shows or queues an error dialog.
    /// @param {Struct.GameError} _error
    static show = function(_error) {
        var _keys = variable_struct_get_names(_active_dialogs);
        var _count = array_length(_keys);

        if (_count == 0) {
            _show_dialog(_error);
        } else {
            array_push(_error_queue, _error);
        }
    };

    /// @desc Dispatches async results to the right handler inside the singleton.
    /// @returns {bool} True if this was a bug-reporter related event, false otherwise.
    static handle_async = function() {
        var _id = ds_map_find_value(async_load, "id");
        var _status = ds_map_find_value(async_load, "status");
        var _result = ds_map_find_value(async_load, "result");

        // Check dialog responses (show_message_async)
        if (struct_exists(_active_dialogs, _id)) {
            var _error = _active_dialogs[$ _id];
            variable_struct_remove(_active_dialogs, _id);

            if (is_instanceof(_error, GameError)) {
                ERROR_HANDLER.pending_error = _error;
                ERROR_HANDLER.start();
            }
            return true;
        }

        if (_id == _pending_async_id) {
            if (_status && _result != "") {
                ERROR_HANDLER.send(_result);
                show_message_async("Report sent to the Administratum.");
            }
            _pending_async_id = -1;

            _process_next();
            return true;
        }

        return false;
    };

    /// @desc Opens the dialog for the user
    static start = function() {
        async_id = get_string_async("Describe your actions before the error:", "");
        _pending_async_id = async_id;
    };

    /// @desc Sends the report to Discord with optional user notes.
    /// @param {string} _user_text Optional user description text.
    static send = function(_user_text = "") {
        var _url = "__DISCORD_WEBHOOK_URL__";

        if (_url == "" || string_pos("__", _url) == 1) {
            LOGGER.error("No Webhook URL found. Build is likely local/dev.");
            return;
        }

        if (!is_instanceof(pending_error, GameError)) {
            LOGGER.error("Not a valid GameError");
            return;
        }

        if (UPDATE_CHECKER.update_available) {
            LOGGER.debug("Outdated version, report skipped.");
            return;
        }

        try {
            var embed = new DiscordEmbed();
            embed.SetTitle("Error Details").SetDescription(pending_error.full_log).SetColor(0x00ff00).AddField("Username:", pending_error.username);

            if (_user_text != "") {
                embed.AddField("User Message:", _user_text);
            }

            var _hook = new DiscordWebhook(_url);
            _hook.SetUser("Bug Reporter").SetThread(pending_error.report_title).AddEmbed(embed);

            if (file_exists(PATH_LAST_MESSAGES)) {
                _hook.AddFile(PATH_LAST_MESSAGES);
            }

            if (file_exists(PATH_AUTOSAVE_FILE)) {
                var _save = json_to_gamemaker(PATH_AUTOSAVE_FILE, json_parse);
                var _save_data = is_struct(_save) ? _save[$ "Save"] : undefined;
                if (is_struct(_save_data)) {
                    var _seed = _save_data[$ "game_seed"];
                    if (!is_undefined(_seed) && _seed == pending_error.seed) {
                        _hook.AddFile(PATH_AUTOSAVE_FILE);
                    }
                }
            }

            _hook.Execute();

            LOGGER.debug("Payload dispatched to Discord.");
        } catch (_ex) {
            LOGGER.error("Failed to package report: " + _ex.message);
        } finally {}
    };

    /// @description Entry point for error handling. Creates GameError, logs it, routes to dialog queue or sends directly.
    /// @param {string} _header
    /// @param {string} _message
    /// @param {string} _stacktrace
    /// @param {bool} _critical
    /// @param {string} _report_title
    static handle = function(_header, _message, _stacktrace = "", _critical = false, _report_title = "") {
        var _error = new GameError(_header, _message, _stacktrace, _critical, _report_title);

        _write_error_log(_error.error_file_text);

        show_debug_message(LB_92);
        show_debug_message(_message);
        show_debug_message(_stacktrace);
        show_debug_message(LB_92);

        // Outdated version. Intercept, offer update link, skip report
        if (UPDATE_CHECKER.update_available) {
            var _open_update = show_question(_error.player_message);
            if (_open_update && UPDATE_CHECKER.latest_release_url != "") {
                url_open(UPDATE_CHECKER.latest_release_url);
            }
            return;
        }

        if (_critical) {
            var _send_report = show_question(_error.player_message);

            if (!_send_report) {
                return;
            }

            ERROR_HANDLER.pending_error = _error;
            ERROR_HANDLER.send();

            return;
        }

        show(_error);
    };

    /// @description Handles an exception object from GameMaker's exception system.
    /// @param {exception} _exception
    /// @param {string} custom_title
    /// @param {bool} critical
    /// @param {string} error_marker
    static handle_exception = function(_exception, custom_title = STR_ERROR_MESSAGE_HEAD, critical = false, error_marker = "") {
        var _header = critical ? STR_ERROR_MESSAGE_HEAD2 : custom_title;
        var _message = _exception.longMessage;
        var _stacktrace = _exception.stacktrace;
        clean_stacktrace(_stacktrace);

        var _critical = critical ? "CRASH! " : "";
        var _build_date = global.build_date == "unknown build" ? "" : $"/{global.build_date}";
        var _problem_line = (array_length(_stacktrace) > 0) ? _stacktrace[0] : "unknown";
        var _report_title = $"{_critical}[{global.game_version}{_build_date}] {_problem_line}";

        _stacktrace = array_to_string_list(_stacktrace);

        handle(_header, _message, _stacktrace, critical, _report_title);
    };

    /// @description Shows a popup for errors triggered by unexpected conditions.
    /// @param {string} _message
    /// @param {string} _header
    static assert_popup = function(_message, _header = "Your game just encountered an error!") {
        var _stacktrace_array = debug_get_callstack();

        array_shift(_stacktrace_array); // throw away the first line, it's this function
        array_pop(_stacktrace_array); // and the last line, it's the `0` debug_get_callstack returns for the top of the stack
        clean_stacktrace(_stacktrace_array);

        var _stacktrace = array_to_string_list(_stacktrace_array);

        handle(_header, _message, _stacktrace);
    };
}
