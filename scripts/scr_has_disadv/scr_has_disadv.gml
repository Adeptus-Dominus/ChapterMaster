/**
 * @arg {String} disadvantage disadvantage name e.g. "Shitty Luck"
 * @return {Bool}
 */
function scr_has_disadv(disadvantage){
	try {
		var result;
		if (instance_exists(obj_creation)) {
			result = array_contains(obj_creation.dis, disadvantage);
		} else {
			result = array_contains(obj_ini.dis, disadvantage);
		}
	} catch (_exception){
		handle_exception(_exception);
		result = false;
	}
	return result;
	// var disadv_count = array_length(obj_ini.dis);
	// for(var i = 0; i < disadv_count; i++){
	// 	if(obj_ini.dis[i] == disadvantage){
	// 		return true;
	// 	}
	// }
	// return false;
}