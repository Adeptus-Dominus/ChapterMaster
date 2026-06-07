exception_unhandled_handler(function(_exception) {
    ERROR_HANDLER.handle_exception(_exception,, true);
    return 0;
});

/// @desc Formats text as a code block.
/// @param {string} _message The message to format.
/// @param {string} _language (Optional) Code language prefix to add into the codeblock.
/// @returns {string} The formatted string.
function format_codeblock(_message, _language = "") {
    return string_length(_message) > 0 ? $"```{_language}\n{_message}\n```" : "";
}

/// @desc Converts to string and adds a 0 at the start, if input is less than 10.
/// @param {real} _time - Usually hours, minutes or seconds.
/// @returns {string}
function format_time(_time) {
    return (_time < 10) ? $"0{_time}" : string(_time);
}

/// @desc Removes all GM prefixes from a string.
/// @param {string} _string
/// @returns {string}
function clean_prefixes(_string) {
    _string = string_replace_all(_string, "gml_Object_", "");
    _string = string_replace_all(_string, "gml_Script_", "");
    _string = string_replace_all(_string, "gml_GlobalScript_", "");
    return _string;
}

/// @desc Reformats: "Location:[LineNum] > Method > Code Snippet"
/// @param {array} _stacktrace_array The array from debug_get_callstack()
function clean_stacktrace(_stacktrace_array) {
    for (var i = 0, l = array_length(_stacktrace_array); i < l; i++) {
        _stacktrace_array[@ i] = clean_stacktrace_line(_stacktrace_array[i]);
    }
}

/// @desc Reformats: "Location:[LineNum] > Method > Code Snippet"
/// @param {string} _line_string The raw string from debug_get_callstack()
/// @returns {string}
function clean_stacktrace_line(_line_string) {
    var _work_string = _line_string;
    var _final_callsite = "";

    // 1. Extract Code Snippet (Suffix after -)
    var _code_snippet = "";
    var _divider_pos = string_pos(") - ", _work_string);
    if (_divider_pos > 0) {
        _code_snippet = string_delete(_work_string, 1, _divider_pos + 3);
        _code_snippet = string_trim(_code_snippet);
        _work_string = string_copy(_work_string, 1, _divider_pos);
    }

    // 2. Extract Line Number
    var _line_number = "???";
    _divider_pos = string_last_pos("(line ", _work_string);
    if (_divider_pos == 0) {
        _divider_pos = string_last_pos(":", _work_string);
    }

    if (_divider_pos > 0) {
        var _full_len = string_length(_work_string);
        var _num_str = string_digits(string_copy(_work_string, _divider_pos, _full_len - _divider_pos + 1));
        _line_number = _num_str;
        _work_string = string_trim(string_copy(_work_string, 1, _divider_pos - 1));
    }

    // 3. Cleanup Prefixes
    _work_string = clean_prefixes(_work_string);

    // 4. Handle Method/Anonymous Chains (@ symbols)
    if (string_contains("@", _work_string)) {
        var _parts = string_split(_work_string, "@");
        var _method_name = _parts[0];
        var i = array_length(_parts) - 1;
        var _location = _parts[i];

        if (_method_name == "anon") {
            _method_name = "anonymous";
        }

        _final_callsite = $"{_location}:{_method_name}:{_line_number}";
    } else {
        _final_callsite = $"{_work_string}:{_line_number}";
    }

    // 5. Append Snippet
    if (_code_snippet != "") {
        _final_callsite += $" >> {_code_snippet}";
    }

    return _final_callsite;
}

/// @description Formats the GM constant to a readable OS name.
/// @param {string} _os_type - GM constant for the OS.
/// @returns {string}
function os_type_format(_os_type) {
    var _os_type_dictionary = {
        os_windows: "Windows OS",
        os_gxgames: "GX.games",
        os_linux: "Linux",
        os_macosx: "macOS X",
        os_ios: "iOS",
        os_tvos: "Apple tvOS",
        os_android: "Android",
        os_ps4: "Sony PlayStation 4",
        os_ps5: "Sony PlayStation 5",
        os_gdk: "Microsoft GDK",
        os_xboxseriesxs: "Xbox Series X/S",
        os_switch: "Nintendo Switch",
        os_unknown: "Unknown OS",
    };

    if (struct_exists(_os_type_dictionary, _os_type)) {
        return _os_type_dictionary[$ _os_type];
    } else {
        return _os_type_dictionary.os_unknown;
    }
}
