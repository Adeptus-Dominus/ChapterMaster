/// @function instance_create
/// @description Creates an instance of a given object at a given position.
/// @param {real} _x The x position the object will be created at.
/// @param {real} _y The y position the object will be created at.
/// @param {Asset.GMObject} _obj The object to create an instance of.
/// @returns {Asset.GMObject}
function instance_create(_x, _y, _obj) {
	var myDepth = object_get_depth(_obj);
	return instance_create_depth(_x, _y, myDepth, _obj);
}

/// @function instances_exist
/// @param {real} _x The x position the object will be created at.
/// @returns {bool}
function instances_exist(instance_set = []){
	var _exists = false;
	for (var i=0;i<array_length(instance_set);i++){
		_exists = instance_exists(instance_set[i]);
		if (_exists){
			break;
		}
	}
	return _exists;
}
