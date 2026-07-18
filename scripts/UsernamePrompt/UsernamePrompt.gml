#macro USERNAME_PROMPT global.username_prompt

/// @desc Prompts user for bug-report username if not set. Handles async dialog result.
function UsernamePrompt() constructor {
    prompt_id = -1;

    /// @desc Shows dialog if username not yet set.
    static prompt = function() {
        if (global.settings.username != "") {
            return;
        }

        var _suggestion = environment_get_variable("USERNAME");
        if (_suggestion == "") {
            _suggestion = "";
        }

        prompt_id = get_string_async("Enter a name (Discord username or any identifier) for bug reports:", _suggestion);
    };

    /// @desc Handles async dialog result. Call from Async-Dialog event.
    static handle_async = function() {
        if (prompt_id < 0) {
            return false;
        }
        if (async_load[? "id"] != prompt_id) {
            return false;
        }

        var _result = async_load[? "result"];
        if (string_length(_result) > 0 && _result != "") {
            global.settings.username = _result;
            global.settings.save();
        }

        prompt_id = -1;

        return true;
    };
}
