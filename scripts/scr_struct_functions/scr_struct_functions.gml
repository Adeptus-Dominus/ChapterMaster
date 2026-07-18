function struct_empty(_struct) {
    return array_length(variable_struct_get_names(_struct)) == 0;
}

function struct_has_value(struct, key, value) {
    if (!struct_exists(struct, key)) {
        return false;
    }

    return struct[$ key] == value;
}

function move_data_to_current_scope(move_struct, overide = true) {
    if (!is_struct(move_struct)) {
        LOGGER.debug(move_struct);
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
            ERROR_HANDLER.handle_exception(_exception);
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

function CountingMap(_initial_array = undefined) constructor {
    map = {};

    if (_initial_array != undefined) {
        add_all(_initial_array);
    }

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

    static add_all = function(_array) {
        if (!is_array(_array)) {
            return;
        }
        var _len = array_length(_array);
        for (var _i = 0; _i < _len; _i++) {
            add(_array[_i]);
        }
    };

    static get_custom_string = function(_callback) {
        var _keys = struct_get_names(map);
        var _len = array_length(_keys);
        if (_len == 0) {
            return "";
        }

        var _parts = array_create(_len);
        for (var _i = 0; _i < _len; _i++) {
            var _key = _keys[_i];
            _parts[_i] = _callback(_key, map[$ _key], _i, _keys);
        }

        return string_join_ext("", _parts);
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
