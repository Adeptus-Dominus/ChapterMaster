function scr_chapter_master(){
	favours = {
		faction_leaders : array_create(15, []),
		minor_characters : {},
	}

	static get_struct = function(){
		return fetch_unit([0,0]);
	}
}