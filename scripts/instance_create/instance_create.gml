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
