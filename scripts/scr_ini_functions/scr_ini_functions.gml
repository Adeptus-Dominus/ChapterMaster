/// @description This function converts a single struct or a hierarchy of nested structs and arrays into a valid JSON string, then into a base64 format encoded string, and then write into an ini. If the input is big, consider using ini_encode_and_json_advanced() to avoid stack overflow.
/// @param {string} ini_area
/// @param {string} ini_code
/// @param {struct|array} value
function ini_encode_and_json(ini_area, ini_code, value) {
    ini_write_string(ini_area, ini_code, base64_encode(json_stringify(value)));
}

/// @description This function converts a single struct or a hierarchy of nested structs and arrays into a valid JSON string, then into a base64 format encoded string, using an intermediate buffer, to prevent stack overflow due to big input strings, and then write into an ini.
/// @param {string} ini_area
/// @param {string} ini_code
/// @param {struct|array} value
function ini_encode_and_json_advanced(ini_area, ini_code, value) {
    ini_write_string(ini_area, ini_code, jsonify_encode_advanced(value));
}