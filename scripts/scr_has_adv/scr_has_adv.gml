/**
 * @arg {String} advantage advantage name e.g. "Tech-Scavengers"
 * @return {Bool}
 */
function scr_has_adv(advantage){
	try {
		var result;
		if (instance_exists(obj_creation)) {
			result = array_contains(obj_creation.adv, advantage);
		} else {
			result = array_contains(obj_ini.adv, advantage);
		}
	} catch (_exception){
		handle_exception(_exception);
		result = false;
	}
	return result;

	// var adv_count = array_length(obj_ini.adv);
	// for(var i = 0; i < adv_count; i++){
	// 	if(obj_ini.adv[i] == advantage){
	// 		return true;
	// 	}
	// }
	// return false;
}