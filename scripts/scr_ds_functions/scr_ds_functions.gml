function Set(_array = []) constructor {
    data = ds_map_create();

    for (var i = 0, l = array_length(_array); i < l; i++) {
        ds_map_add(data, _array[i], true);
    }

    static add = function(_key) {
        return ds_map_add(data, _key, true);
    };

    static remove = function(_key) {
        ds_map_delete(data, _key);
    };

    static clear = function() {
        ds_map_clear(data);
    };

    static has = function(_key) {
        return ds_map_exists(data, _key);
    };

    static foreach = function(_callback) {
        var _keys = keys();
        for (var i = 0, l = array_length(_keys); i < l; i++) {
            var _key = _keys[i];
            _callback(_key);
        }
    };

    static size = function() {
        return ds_map_size(data);
    };

    static empty = function() {
        return ds_map_empty(data);
    };

    static keys = function() {
        return ds_map_keys_to_array(data);
    };

    static destroy = function() {
        ds_map_destroy(data);
    };
}
