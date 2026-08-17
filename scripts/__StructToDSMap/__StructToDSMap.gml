// Feather disable all

/// @func __StructToDSMap(struct)
/// @desc Convert a struct to a DS Map. Only converts the root layer.
/// @ignore
function __StructToDSMap(_struct) {
    if (is_struct(_struct)) {
        var _map = ds_map_create();

        var _structKeys = variable_struct_get_names(_struct);
        var _structKeyCount = array_length(_structKeys);

        repeat (_structKeyCount) {
            var _key = array_pop(_structKeys);
            var _val = _struct[$ _key];

            ds_map_add(_map, _key, _val);
        }

        return _map;
    } else {
        __GitHubError("Wrong datatype passed into __StructToDSMap(). Expected a struct.");
    }
}
