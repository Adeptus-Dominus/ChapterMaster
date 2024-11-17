function JsonFileListLoader() constructor {

    load_list_from_json_file = function(relative_file_path, properties_to_read) {
        var file_buffer = undefined;
        var result = {
            is_success: false,
            values: {}
        };

        if (is_array(properties_to_read) == false || array_length(properties_to_read) == 0) {
            debugl("Received invalid property name list");
            return result;
        }

        for (var i = 0; i < array_length(properties_to_read); i++) {
            struct_set(result.values, properties_to_read[i], []);
        };

        try {
			var item_total = 0;
            var file_path = working_directory + relative_file_path;
            file_buffer = buffer_load(file_path);

            if (file_buffer == -1) {
                throw ("Could not open file");
            }

            var json_string = buffer_read(file_buffer, buffer_string);
            var raw_data = json_parse(json_string);

            for (var i = 0; i < array_length(properties_to_read); i++) {
                var property = properties_to_read[i];
                var property_value = raw_data[$ property]

                if (is_array(property_value) == false) {
                    throw ($"No string array named '{property}' found");
                }

                var filtered_data_array = array_unique(property_value);

			    var property_data_count = array_length(filtered_data_array);
                if (property_data_count == 0) {
                    throw ($"No (unique) values found for '{property}'");
                }

				item_total += property_data_count;
                result.values[$ property] = array_shuffle(filtered_data_array);
            }

            result.is_success = true;

            debugl($"Successfully loaded {item_total} values from {relative_file_path}");
        } catch (_exception) {
            handle_exception(_exception);
            result.values = {}; // do not return incomplete/invalid data
        } finally {
            if (is_undefined(file_buffer) == false) {
                buffer_delete(file_buffer);
            }
        }

        return result;
    }

}