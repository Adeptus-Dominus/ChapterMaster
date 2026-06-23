/// @function instance_create
/// @description Creates an instance of a given object at a given position.
/// @param {Real} _x The x position the object will be created at.
/// @param {Real} _y The y position the object will be created at.
/// @param {Asset.GMObject} _obj The object to create an instance of.
/// @returns {Id.Instance}
function instance_create(_x, _y, _obj) {
    var myDepth = object_get_depth(_obj);
    return instance_create_depth(_x, _y, myDepth, _obj);
}

/// @function instances_exist_any
/// @description Checks if any of the provided instances exist
/// @param {Array<Id.Instance>} instance_set Array of instances to check for existence
/// @returns {Bool}
function instances_exist_any(instance_set = []) {
    var _exists = false;
    for (var i = 0; i < array_length(instance_set); i++) {
        _exists = instance_exists(instance_set[i]);
        if (_exists) {
            break;
        }
    }
    return _exists;
}
