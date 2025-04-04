/// @desc Copies simple (serializable) variables from one struct to another, excluding specified names and prefixes. Useful for building save-data structs.
/// @param {struct} _source - The struct to copy variables from.
/// @param {struct} _destination - The struct to copy variables into.
/// @param {array<string>} _exclude - List of variable names to exclude.
/// @param {array<string>} _exclude_start - List of string prefixes; variables starting with any of these will be excluded.
function copy_serializable_fields(_source, _destination, _exclude = [], _exclude_start = []) {
    /// Check all object variable values types and save the simple ones dynamically. 
    /// simple types are numbers, strings, bools. arrays of only simple types are also considered simple. 
    /// non-simple types are structs, functions, methods
    /// functions and methods will be ignored completely, structs to be manually serialized/deserialised.
    var all_names = struct_get_names(_source);
    var _len = array_length(all_names);
    for(var i = 0; i < _len; i++){
        var var_name = all_names[i];
        if(array_contains(_exclude, var_name)){
            continue;
        }
        if(string_starts_with_any(var_name, _exclude_start)){
            continue; //handled in planet_data above
        }
        if(struct_exists(_destination, var_name)){
            continue; //already added above
        }
        if(is_basic_variable(_source[$var_name])){
            variable_struct_set(_destination, var_name, _source[$var_name]);
        }
        if(is_array(_source[$var_name])){
            var _check_arr = _source[$var_name];
            var _ok_array = true;
            var _ok_array = is_basic_array(_check_arr, 2);
            if(!_ok_array){
                log_warning($"Bad array save: '{var_name}' internal type found was not a simple type and should probably have it's own serialize functino - _source");
            } else {
                variable_struct_set(_destination, var_name, _source[$var_name]);
            }
        }
        if(is_struct(_source[$var_name])){
            if(!struct_exists(_destination, var_name)){
                var obj_name = struct_exists(_source, "object_index") ? object_get_name(_source.object_index) : "<non-instance>";
                log_warning($"obj_ini.serialze() - {obj_name} - object contains struct variable '{var_name}' which has not been serialized. \n\tEnsure that serialization is written into the serialize and deserialization function if it is needed for this value, or that the variable is added to the ignore list to suppress this warning");
            }
        }
    }
}
