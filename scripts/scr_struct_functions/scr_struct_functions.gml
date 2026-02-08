function struct_empty(_struct) {
    return array_length(variable_struct_get_names(_struct)) == 0;
}

function move_data_to_current_scope(move_struct, overide = true) {
    if (!is_struct(move_struct)) {
        global.logger.debug(move_struct);
    } else {
        try {
            var _data_names = struct_get_names(move_struct);
            for (var i = 0; i < array_length(_data_names); i++) {
                if (overide) {
                    self[$ _data_names[i]] = move_struct[$ _data_names[i]];
                } else {
                    if (!struct_exists(self, _data_names[i])) {
                        self[$ _data_names[i]] = move_struct[$ _data_names[i]];
                    }
                }
            }
        } catch (_exception) {
            handle_exception(_exception);
        }
    }
}

function gc_struct(vari) {
    var _keys = struct_get_names(vari);
    var _key_length = array_length(_keys);
    for (var i = 0; i < _key_length; i++) {
        var _key = _keys[i];
        var _data = vari[$ _key];
        if (is_struct(_data)) {
            gc_struct(_data);
        } else if (is_array(_data)) {
            // Traverse arrays for embedded structs
            for (var j = 0; j < array_length(_data); j++) {
                var _e = _data[j];
                if (is_struct(_e)) {
                    gc_struct(_e);
                }
            }
        }
        delete _data;
        delete vari[$ _key];
        struct_remove(vari, _key);
    }

    delete vari;
}

function CountingMap() constructor {
    map = {};

    static add = function(_key, number = 1) {
        if (_key == "") {
            return;
        }

        if (struct_exists(map, _key)) {
            map[$ _key] += number;
        } else {
            map[$ _key] = number;
        }

        if (map[$ _key] == 0) {
            struct_remove(map, _key);
        }
    };

    static get_total_string = function() {
        var result = "";
        var keys = struct_get_names(map);

        for (var i = 0; i < array_length(keys); i++) {
            var key = keys[i];
            result += $"{map[$ key]}x {key}{smart_delimeter_sign(keys, i, false)}";
        }

        return result;
    };

    static get_string = function(_key) {
        return struct_exists(map, _key) ? string(map[$ _key]) + "x " + _key : "";
    };

    static get = function(_key) {
        return struct_exists(map, _key) ? map[$ _key] : 0;
    };
}

/// @description Copies a key from source to target if it exists in the source
/// @param {struct} source - The struct to read from
/// @param {struct} target - The struct to write to
/// @param {string} key - The key to check and copy
function struct_copy_if_exists(source, target, key) {
    if (struct_exists(source, key)) {
        target[$ key] = source[$ key];
    }
}
