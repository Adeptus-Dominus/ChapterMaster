function scr_chapter_master() constructor{
	favours = {
		faction_leaders : array_create(15, 0),
		minor_characters : {},
	}

	static get_struct = function(){
		return fetch_unit([0,0]);
	}

}

function cm_obj(){
	return obj_controller.chapter_master;
}

function has_faction_favour(diplomacy_faction){
	return (cm_obj().favours.faction_leaders[diplomacy_faction] > 0);
}

function get_faction_favour(diplomacy_faction){

	return cm_obj().favours.faction_leaders[diplomacy_faction];
}

function edit_faction_favour(diplomacy_faction,edit_val){
	with (cm_obj().favours){
		var _val = faction_leaders[diplomacy_faction];
		faction_leaders[diplomacy_faction] = clamp(_val+edit_val, 0, 100000);
		return 	faction_leaders[diplomacy_faction];
	}
}