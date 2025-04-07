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

	var _all_names = struct_get_names(_source);
	var _len = array_length(_all_names);

	for (var i = 0; i < _len; i++) {
		var _field_name = _all_names[i];
		var _field_value = _source[$ _field_name];

		if (is_method(_field_value)) {
			continue;
		}

		if (array_contains(_exclude, _field_name)) {
			continue; // excluded by the full name
		}

		if (string_starts_with_any(_field_name, _exclude_start)) {
			continue; // excluded by the prefix
		}

		if (struct_exists(_destination, _field_name)) {
			continue; // already added
		}

		if (is_basic_variable(_field_value)) {
			variable_struct_set(_destination, _field_name, _field_value);
			continue;
		}
		
		if (is_array(_field_value)) {
			if (!is_basic_array(_field_value, 2)) {
				var _source_obj_name = struct_exists(_source, "object_index") ? object_get_name(_source.object_index) : "<non-instance>";
				log_warning($"Bad array save: '{_field_name}' internal type found was not a simple type and should probably have it's own serialize function - {_source_obj_name}!");
			} else {
				variable_struct_set(_destination, _field_name, _field_value);
			}
			continue;
		}

		var _source_obj_name = struct_exists(_source, "object_index") ? object_get_name(_source.object_index) : "<non-instance>";
		log_warning($"{_source_obj_name} - '{_field_name}' key contains a {typeof(_field_value)} variable which has not been serialized. \n\tEnsure that serialization is written into the serialize and deserialization function if it is needed for this value, or that the variable is added to the ignore list to suppress this warning!");
	}
}
