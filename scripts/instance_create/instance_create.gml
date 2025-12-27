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

/// @function instances_exist_any
/// @description Checks if any of the provided instances exist
/// @param {array} instance_set Array of instances to check for existence
/// @returns {bool}
function instances_exist_any(instance_set = []){
	var _exists = false;
	for (var i=0;i<array_length(instance_set);i++){
		_exists = instance_exists(instance_set[i]);
		if (_exists){
			break;
		}
	}
	return _exists;
}

function instance_at_location(xx,yy,obj_type){
	var _nearest = instance_nearest(xx, yy, obj_type);
	return (_nearest.x == xx && _nearest.y == yy) ? _nearest : noone;
}

function instance_distance(instance_1,instance_2){
	return point_distance(instance_1.x, instance_1.y, instance_2.x, instance_2.y)
}

function nearest_instance(instance_array,check_instance){
	var _inst = instance_array[0];
	var _inst_dist = instance_distance(_inst,check_instance);
	for (var i=1;i<array_length(instance_array);i++){
		var _cur_inst = instance_array[i];
		var _cur_inst_dist = instance_distance(_cur_inst,check_instance);
		if (_cur_inst_dist<_inst_dist){
			_inst_dist = _cur_inst_dist;
			_inst = _cur_inst;
		}
	}
}
