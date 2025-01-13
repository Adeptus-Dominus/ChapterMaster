function JsonFileListLoader() constructor {

    load_list_from_json_file = function(relative_file_path, properties_to_read, app_data_dir = false) {
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
            if(file_exists(file_path) == false){
                debugl($"File does not exist at path {file_path}");
                return result;
            }
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

    /// @param {String} relative_file_path the file path and file name e.g. "main/data/file.json"
    /// @param {String} property_to_read the key which is the struct to pull out
    /// @param {Bool} app_data_dir if set to true, will read from %AppData%/Local/ChapterMaster instead of %GameInstallDir%/datafiles
    load_struct_from_json_file = function(relative_file_path, property_to_read, app_data_dir = false){
        var file_buffer = undefined;
        var result = {
            is_success: false,
            value: {}
        };

        if (is_string(property_to_read) == false || string_length(property_to_read) == 0) {
            debugl("Received invalid property name, expected a string");
            return result;
        }

        struct_set(result.value, property_to_read, {});

        try {
			var item_total = 0;
            var file_path;
            if(app_data_dir == true){
                file_path = relative_file_path;
            } else {
                file_path = working_directory + relative_file_path;
            }
            if(file_exists(file_path) == false){
                result.value = $"File does not exist at path {file_path}";
                return result;
            }
            file_buffer = buffer_load(file_path);

            if (file_buffer == -1) {
                throw ("Could not open file");
            }

            var json_string = buffer_read(file_buffer, buffer_string);
            var raw_data = json_parse(json_string);

            var property = property_to_read;
            var property_value = raw_data[$ property]

            if (is_struct(property_value) == false) {
                throw ($"No struct named '{property}' found");
            }
            
            result.value[$ property] = property_value;

            result.is_success = true;

            // debugl($"Successfully loaded {property} value from {relative_file_path}");
        } catch (_ex) {
            debugl($"Could not properly parse file at {file_path}: {_ex}.");
            scr_popup("Error Parsing JSON File", $"Could not properly parse file: #{file_path}.# Please check this file for typos or formatting errors.# # Full error message:# {_ex}", "debug");
            result.value = {}; // do not return incomplete/invalid data
        } finally {
            if (is_undefined(file_buffer) == false && file_buffer != -1) {
                buffer_delete(file_buffer);
            }
        }

        return result;
    }

}