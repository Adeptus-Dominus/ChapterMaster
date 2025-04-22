function struct_empty(_struct) {
    return array_length(variable_struct_get_names(_struct)) == 0;
}

///! DELETE THIS AT SOME POINT!
/// @desc Deprecated. Use `variable_clone()` instead.
function DeepCloneStruct(clone_struct) {
    return variable_clone(clone_struct);
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
    }

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

function Set(_array = []) constructor {
    data = ds_map_create();

    for (var i = 0, l = array_length(_array); i < l; i++) {
        ds_map_add(data, _array[i], true);
    }

    static add = function(_key) {
        return ds_map_add(data, _key, true);
    }

    static remove = function(_key) {
        ds_map_delete(data, _key);
    }

    static clear = function() {
        ds_map_clear(data);
    }

    static has = function(_key) {
        return ds_map_exists(data, _key);
    }

    static foreach = function(_callback) {
        var _keys = keys();
        for (var i = 0, l = array_length(_keys); i < l; i++) {
            var _key = _keys[i];
            _callback(_key);
        }
    }

    static size = function() {
        return ds_map_size(data);
    }

    static empty = function() {
        return ds_map_empty(data);
    }

    static keys = function() {
        return ds_map_keys_to_array(data);
    }

    static copy = function(_ds_set) {
        ds_map_copy(_ds_set, data);
    }

    static destroy = function() {
        ds_map_destroy(data);
    }
}
