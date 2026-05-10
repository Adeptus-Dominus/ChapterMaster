/// @function json_to_gamemaker
/// @description Converts a json file to usable GameMaker data type.
/// @param {string} _json_path full path to the file.
/// @param {function} _func json_parse or json_decode, to get a struct or a dslist.
function json_to_gamemaker(_json_path, _func) {
    var file_buffer = undefined;
    try {
        if (file_exists(_json_path)) {
            var _json_string = "";
            var _parsed_json = {};

            file_buffer = buffer_load(_json_path);

            if (file_buffer == -1) {
                throw $"Could not open {_json_path} file";
            }

            var _json_string = buffer_read(file_buffer, buffer_string);
            var _parsed_json = _func(_json_string);

            return _parsed_json;
        } else {
            throw $"File {_json_path} not found!";
        }
    } catch (_exception) {
        handle_exception(_exception);
    } finally {
        if (is_undefined(file_buffer) == false) {
            buffer_delete(file_buffer);
        }
    }
    return "";
}

/// @description This function converts a single struct or a hierarchy of nested structs and arrays into a valid JSON string and then into a base64 format encoded string, using an intermediate buffer, to prevent stack overflow due to big input strings.
/// @param {struct|array} _input
/// @return {string}
function jsonify_encode_advanced(_input) {
    var _result = json_stringify(_input);
    _result = base64_encode_advanced(_result);

    return _result;
}


/// @desc Recursively walks a parsed JSON struct/array and replaces
///       placeholder strings with their actual weapon list arrays.
/// @param {Any}   _data    The parsed JSON value (struct, array, or primitive)
/// @param {Array} _swaps   The _swaps lookup array
/// @returns {Any} The resolved value
function json_inject_swaps(_data, _swaps) {

    // ── Array ─────────────────────────────────────────────────────
    if (is_array(_data)) {
        var _len = array_length(_data);
        for (var _i = 0; _i < _len; _i++) {
            _data[_i] = json_inject_swaps(_data[_i], _swaps);
        }
        return _data;
    }

    // ── Struct ────────────────────────────────────────────────────
    if (is_struct(_data)) {
        var _keys = struct_get_names(_data);
        var _klen = array_length(_keys);
        for (var _i = 0; _i < _klen; _i++) {
            var _key      = _keys[_i];
            var _key_swap = json_inject_swaps(_key, _swaps);
            if (!is_string(_key_swap)){
                _key_swap = _key; 
            }
            var _val      = json_inject_swaps(_data[$ _key], _swaps);

            if (_key_swap != _key) {
                struct_remove(_data, _key);
            }
            struct_set(_data, _key_swap, _val);
        }
        return _data;
    }

    // ── String — check against swap table ────────────────────────
    if (is_string(_data)) {
        var _slen = array_length(_swaps);
        for (var _i = 0; _i < _slen; _i++) {
            var _swap        = _swaps[_i];
            var _placeholder = struct_get_names(_swap)[0];
            var _val         = struct_get(_swap, _placeholder);

            if (is_string(_val)) {
                // partial match — replace all occurrences within the string
                _data = string_replace_all(_data, _placeholder, _val);
            } else if (_data == _placeholder) {
                // exact match only — return the non-string value (array, struct, etc.)
                return _val;
            }
        }
        return _data;
    }

    // ── Primitive (number, bool, undefined) — pass through ────────
    return _data;
}
