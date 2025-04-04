/// @description Checks if a variable is a simple data type (number, string, or boolean).
function is_basic_variable(_variable) {
    return is_numeric(_variable) || is_string(_variable) || is_bool(_variable);
}
