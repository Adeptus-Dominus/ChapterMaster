/// @function json_to_gamemaker
/// @description Converts a json file to usable GameMaker data type.
/// @param {string} _json_path full path to the file.
/// @param {function} _func json_parse or json_decode, to get a struct or a dslist.
function json_to_gamemaker(_json_path, _func) {
    var file_buffer = undefined;
    try {
        if (file_exists(_json_path)){
            var _json_string = "";
            var _parsed_json = {};

            file_buffer = buffer_load(_json_path);

            if (file_buffer == -1) {
                throw ("Could not open file");
            }

            var _json_string = buffer_read(file_buffer, buffer_string);
            var _parsed_json = _func(_json_string);
    
            return _parsed_json;
        }
    } catch (_exception) {
        handle_exception(_exception);
    }finally {
        if (is_undefined(file_buffer) == false) {
            buffer_delete(file_buffer);
        }
    }
}

/// @description This function converts a single struct or a hierarchy of nested structs and arrays into a valid JSON string and then into a base64 format encoded string, using an intermediate buffer, to prevent stack overflow due to big input strings.
/// @param {struct|array} _input
/// @return {string}
function jsonify_encode_advanced(_input) {
    var _result = json_stringify(_input);
    _result = base64_encode_advanced(_result);

    return _result;
}
