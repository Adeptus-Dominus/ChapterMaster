function struct_empty(_struct) {
    return array_length(variable_struct_get_names(_struct)) == 0;
}

///! DELETE THIS AT SOME POINT!
/// @desc Deprecated. Use `variable_clone()` instead.
function DeepCloneStruct(clone_struct) {
    return variable_clone(clone_struct);
}

function move_data_to_current_scope(move_struct, overide=true){
    if (!is_struct(move_struct)){
        show_debug_message(move_struct);
    } else {
        try{
            var _data_names = struct_get_names(move_struct);
            for (var i=0;i<array_length(_data_names);i++){
                if (overide){
                    self[$_data_names[i]] = move_struct[$ _data_names[i]];
                } else {
                    if (!struct_exists(self, _data_names[i])){
                        self[$_data_names[i]] = move_struct[$ _data_names[i]];
                    }
                }
            }
        } catch(_exception){
            handle_exception(_exception);
        }
    }
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
