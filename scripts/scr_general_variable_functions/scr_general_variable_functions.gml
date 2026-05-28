/// @description Checks if a variable is a simple data type (number, string, or boolean).
function is_basic_variable(_variable) {
    return is_numeric(_variable) || is_string(_variable) || is_bool(_variable);
}

/// @description Checks if a variable is a struct, then that it's not an instance of anything.
function is_simple_struct(_value) {
    if (!is_struct(_value)) {
        return false;
    }

    return instanceof(_value) == "struct";
}
