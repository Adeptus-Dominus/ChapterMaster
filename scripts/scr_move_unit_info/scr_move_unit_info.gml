
function scr_move_unit_info(start_company,end_company, start_slot, end_slot, eval_squad=true){

	//eval_squad : determine whether movement of units between companies should decide to check their squad coherency or not, defaults to true
	
			//this makes sure coherency of the unit's squad and the squads logging of the unit location are kept up to date
		var unit = obj_ini.TTRPG[start_company, start_slot];
		if (eval_squad){
			unit.movement_after_math(end_company,end_slot);
		}
		obj_ini.spe[end_company][end_slot]=obj_ini.spe[start_company][start_slot];	
		obj_ini.race[end_company][end_slot]=obj_ini.race[start_company][start_slot];
		obj_ini.name[end_company][end_slot]=obj_ini.name[start_company][start_slot];
		obj_ini.wep1[end_company][end_slot]=obj_ini.wep1[start_company][start_slot];
		obj_ini.role[end_company][end_slot]=obj_ini.role[start_company][start_slot];
		obj_ini.wep2[end_company][end_slot]=obj_ini.wep2[start_company][start_slot];
		obj_ini.gear[end_company][end_slot]=obj_ini.gear[start_company][start_slot];
		obj_ini.armour[end_company][end_slot]=obj_ini.armour[start_company][start_slot];
		obj_ini.god[end_company][end_slot]=obj_ini.god[start_company][start_slot];
		obj_ini.age[end_company][end_slot]=obj_ini.age[start_company][start_slot];
		obj_ini.mobi[end_company][end_slot]=obj_ini.mobi[start_company][start_slot];
		var temp_struct = jsonify_marine_struct(start_company,start_slot);			//jsonified for stransfer of struct (makes a deep copy)
		obj_ini.TTRPG[end_company][end_slot] = new TTRPG_stats("chapter", end_company,end_slot ,"blank"); // create new empty unit structure
		if (is_string(temp_struct)){
			obj_ini.TTRPG[end_company][end_slot].load_json_data(json_parse(temp_struct));				//load in originoal marine data
			obj_ini.TTRPG[end_company][end_slot].company = end_company;
			obj_ini.TTRPG[end_company][end_slot].marine_number = end_slot;
		}	else {
			obj_ini.TTRPG[end_company][end_slot] = new TTRPG_stats("chapter", end_company,end_slot ,"blank");
		}

		scr_wipe_unit(start_company,start_slot);
}