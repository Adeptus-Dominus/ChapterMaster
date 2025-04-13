/// @function json_to_gamemaker
/// @description Converts a json file to usable GameMaker data type.
/// @param {string} _json_path full path to the file.
/// @param {function} _func json_parse or json_decode, to get a struct or a dslist.
function json_to_gamemaker(_json_path, _func) {
    try {
        if (file_exists(_json_path)){
            var _file = file_text_open_read(_json_path);
            var _json_string = "";
            var _parsed_json = {};
    
            while (!file_text_eof(_file)) {
                _json_string += file_text_read_string(_file);
                file_text_readln(_file);
            }
            file_text_close(_file);

            _parsed_json = _func(_json_string);
    
            return _parsed_json;
        }
    } catch (_exception) {
        handle_exception(_exception);
    }

    return undefined;
}