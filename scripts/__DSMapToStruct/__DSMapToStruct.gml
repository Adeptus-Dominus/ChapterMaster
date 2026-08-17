// Feather disable all

/// @func __DSMapToStruct(map)
/// @desc Convert a DS Map to a struct. Only converts the root layer.
/// @ignore
function __DSMapToStruct(_dsMap) {
    if (ds_exists(_dsMap, ds_type_map)) {
        var _struct = {};

        var _mapKeys = ds_map_keys_to_array(_dsMap);
        var _mapKeyCount = array_length(_mapKeys);

        repeat (_mapKeyCount) {
            var _key = array_pop(_mapKeys);
            var _val = _dsMap[? _key];

            _struct[$ _key] = _val;
        }

        return _struct;
    } else {
        __GitHubError("Wrong datatype passed into __DSMapToStruct(). Expected a DSMap.");
    }
}
