/// @function instances_exist_any
/// @description Checks if any of the provided instances exist
/// @param {array} instance_set Array of instances to check for existence
/// @returns {bool}
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
