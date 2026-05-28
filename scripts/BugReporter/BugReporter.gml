function GameError() constructor {
    header = "";
    message = "";
    stacktrace = "";
    critical = false;
    report_title = "";
    
    chapter = "";
    turn = 0;
    seed = "";
    
    date_time = "";
    game_version = "";
    build_date = "";
    commit_hash = "";
    
    full_log = "";
    error_file_text = "";
    clipboard_text = "";
    player_message = "";

    /// @description Initializes error with all data
    /// @param {string} _header
    /// @param {string} _message
    /// @param {string} _stacktrace
    /// @param {bool} _critical
    /// @param {string} _report_title
    static init = function(_header, _message, _stacktrace = "", _critical = false, _report_title = "") {
        var _context = error_get_context();
        
        // Store all properties
        header = _header;
        message = _message;
        stacktrace = _stacktrace;
        critical = _critical;
        report_title = _report_title;
        
        // Store context
        chapter = _context.chapter;
        turn = _context.turn;
        seed = _context.seed;
        
        // Store system info
        date_time = DATE_TIME_3;
        game_version = global.game_version;
        build_date = global.build_date;
        commit_hash = global.commit_hash;
        
        // Build the log
        full_log = build_full_log();
        error_file_text = build_error_file_text();
        clipboard_text = build_clipboard_text();
        player_message = build_player_message();
        
        return self;
    }
    
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
    }
    
    /// @description Builds error file text
    static build_error_file_text = function() {
        return (report_title != "") ? $"{report_title}\n{full_log}" : full_log;
    }
    
    /// @description Builds clipboard text with markdown formatting
    static build_clipboard_text = function() {
        var _clip = (report_title != "") ? $"{report_title}\n" : "";
        _clip += markdown_codeblock(full_log, "log");
        return _clip;
    }
    
    /// @description Builds player-facing error message
    static build_player_message = function() {
        var _path_hint = string_replace_all(game_save_id, "/", "\\");
        var _msg = $"{header}\n\n{message}\n\n";

        _msg += $"The error log was saved at:\n{_path_hint}Logs\\\n\n";

        if (critical) {            
            _msg += "Do you want to send the error log, debug log, and your last autosave to our Discord as a bug report? The process is automated and takes a few seconds, you won't notice anything.";
        } else {
            _msg += "After closing this message, you will be prompted to describe what you were doing.\n";
            _msg += "Your message and the error log will be sent to our Discord automatically. You can decline by pressing 'cancel'.\n\n";
            _msg += $"{STR_ERROR_MESSAGE_PS}";
        }
        return _msg;
    }
}

function BugReporter() constructor {
    async_id = -1;
    /// @type {Struct.GameError}
    pending_error = undefined;

    /// @desc Opens the dialog for the user
    static start = function() {
        async_id = get_string_async("Describe your actions before the error:", "");
        // Store reference so Async Event can find it
        global.active_bug_report = self; 
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

        try {
            var embed = new DiscordEmbed();
            embed.SetTitle("Error Details")
                .SetDescription(pending_error.full_log)
                .SetColor(0x00ff00);

            if (_user_text != "") {
                embed.AddField("User Message:", _user_text);
            }

            var _hook = new DiscordWebhook(_url);
            _hook.SetUser("Bug Reporter")
                .SetThread(pending_error.report_title)
                .AddEmbed(embed);

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
}