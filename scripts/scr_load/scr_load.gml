function return_json_from_ini(ini_area,ini_code, default_val=[]){
	var ini_fetch = ini_read_string(ini_area,ini_code,"");
	if (ini_fetch!=""){
		return json_parse(base64_decode(ini_fetch));
	} else {
		return default_val;
	}
}

function load_marine_struct(company, marine){
		var marStruct = ini_read_string("Mar","Struct"+string(company)+"."+string(marine),"");
		if (marStruct != ""){
			marStruct = json_parse(base64_decode(marStruct));
			obj_ini.TTRPG[company, marine] = new TTRPG_stats("chapter", company, marine, "blank");
			obj_ini.TTRPG[company, marine].load_json_data(marStruct);
			delete marStruct;
		} else {
			obj_ini.TTRPG[company, marine] = new TTRPG_stats("chapter", company, marine,"blank");
		}		
};

function scr_load(save_part, save_id) {
	var filename = $"save{save_id}.json";
	if(file_exists(filename)){
		var _gamesave_buffer = buffer_load(filename);
		var _gamesave_string = buffer_read(_gamesave_buffer, buffer_string);
		var json_game_save = json_parse(_gamesave_string);
	}

	if(!struct_exists(obj_saveload.GameSave, "Save")){
		obj_saveload.GameSave = json_game_save;
	}


	if (save_part=1) or (save_part=0){
		// Globals
		var globals = obj_saveload.GameSave.Save;
		global.chapter_icon_sprite = spr_icon_chapters;
		global.chapter_icon_frame = globals.chapter_icon_frame;
		global.chapter_icon_path = globals.chapter_icon_path;
		global.chapter_icon_filename = globals.chapter_icon_filename;
	    global.icon_name=globals.icon_name;
		global.chapter_name = globals.chapter_name;
		global.custom = globals.custom;
		// global.icon = globals.icon;
		

	}


	if (save_part=2) or (save_part=0){
		debugl("Loading slot "+string(save_id)+" part 2");

	    // Stars
		var star_array = obj_saveload.GameSave.Stars;
		for(var i = 0; i < array_length(star_array); i++){
			var deserialized = star_array[i];
			
    		var star_instance = instance_create_layer(0,0, deserialized.layer, asset_get_index(deserialized.obj))
			with(star_instance){
				var exclusions = ["id"]; // skip automatic setting of certain vars, handle explicitly later

				// Automatic var setting
				var all_names = struct_get_names(deserialized);
				var _len = array_length(all_names);
				for(var i = 0; i < _len; i++){
					var var_name = all_names[i];
					if(array_contains(exclusions, var_name)){
						continue;
					}
					var loaded_value =  struct_get(deserialized, var_name);
					variable_struct_set(star_instance, var_name, loaded_value);	
				}

				// Set explicit vars here
			}
		}
	}

	if (save_part=3) or (save_part=0){debugl("Loading slot "+string(save_id)+" part 3");
		// Ini
		var deserialized = obj_saveload.GameSave.Ini;
		with(obj_ini){
			var exclusions = ["complex_livery_data", "full_liveries", "squad_types", "id", "marine_structs", "squad_structs"]; // skip automatic setting of certain vars, handle explicitly later

			// Automatic var setting
			var all_names = struct_get_names(deserialized);
			var _len = array_length(all_names);
			for(var i = 0; i < _len; i++){
				var var_name = all_names[i];
				if(array_contains(exclusions, var_name)){
					continue;
				}
				
				var loaded_value = struct_get(deserialized, var_name);
				show_debug_message($"obj_ini var: {var_name}  -  val: {loaded_value}");
				try {
					variable_struct_set(obj_ini, var_name, loaded_value);	
				} catch (e){
					show_debug_message(e);
				}
			}

			// Set explicit vars here
			var livery_picker = new ColourItem(0,0);
			livery_picker.scr_unit_draw_data();
			if(struct_exists(deserialized, "full_liveries")){
				variable_struct_set(obj_ini, "full_liveries", base64_decode(deserialized.full_liveries));
			} else {
				variable_struct_set(obj_ini, "full_liveries", array_create(21,DeepCloneStruct(livery_picker.map_colour)));
			}

			if(struct_exists(deserialized, "complex_livery_data")){
				variable_struct_set(obj_ini, "complex_livery_data", base64_decode(deserialized.complex_livery_data));
			}
			if(struct_exists(deserialized, "squad_types")){
				variable_struct_set(obj_ini, "squad_types", base64_decode(deserialized.squad_types));
			}

			// variable_struct_set(obj_ini, "spe", deserialized.spe);
		}
		// debugl(obj_ini.spe);


		


		// Controller
		var deserialized_con = obj_saveload.GameSave.Controller;
		with(obj_controller){
			var exclusions = ["specialist_point_handler", "location_viewer", "id"]; // skip automatic setting of certain vars, handle explicitly later

			// Automatic var setting
			var all_names = struct_get_names(deserialized_con);
			var _len = array_length(all_names);
			for(var i = 0; i < _len; i++){
				var var_name = all_names[i];
				if(array_contains(exclusions, var_name)){
					continue;
				}
				var loaded_value = struct_get(deserialized_con, var_name);
				show_debug_message($"obj_controller var: {var_name}  -  val: {loaded_value}");
				try {
					variable_struct_set(obj_controller, var_name, loaded_value);	
				} catch (e){
					show_debug_message(e);
				}
			}
			specialist_point_handler = new SpecialistPointHandler();
			specialist_point_handler.calculate_research_points();
			location_viewer = new UnitQuickFindPanel();
			scr_colors_initialize();
			scr_shader_initialize();
			global.star_name_colors[1] = make_color_rgb(body_colour_replace[0],body_colour_replace[1],body_colour_replace[2]);

		}
	}



	if (save_part=4) or (save_part=0){
		debugl("Loading slot "+string(save_id)+" part 4");// PLAYER FLEET OBJECTS
	    var p_fleet = obj_saveload.GameSave.PlayerFleet;
		for(var i = 0; i < array_length(p_fleet); i++){
			var deserialized = p_fleet[i];
    		var p_fleet_instance = instance_create_layer(0,0, deserialized.layer, obj_p_fleet);
			with(p_fleet_instance){
				var exclusions = ["id"]; // skip automatic setting of certain vars, handle explicitly later

				// Automatic var setting
				var all_names = struct_get_names(p_fleet);
				var _len = array_length(all_names);
				for(var i = 0; i < _len; i++){
					var var_name = all_names[i];
					if(array_contains(exclusions, var_name)){
						continue;
					}
					var loaded_value = struct_get(deserialized_con, var_name);
					show_debug_message($"p_fleet {p_fleet_instance.id}  - var: {var_name}  -  val: {loaded_value}");
					try {
						variable_struct_set(p_fleet_instance, var_name, loaded_value);	
					} catch (e){
						show_debug_message(e);
					}
				}
			}
		}
	}

	if (save_part=5) or (save_part=0){
	    var en_fleet = obj_saveload.GameSave.EnemyFleet;
		for(var i = 0; i < array_length(en_fleet); i++){
			var deserialized = en_fleet[i];
    		var en_fleet_instance = instance_create_layer(0,0, deserialized.layer, obj_en_fleet);
			with(en_fleet_instance){
				var exclusions = ["id"]; // skip automatic setting of certain vars, handle explicitly later

				// Automatic var setting
				var all_names = struct_get_names(en_fleet);
				var _len = array_length(all_names);
				for(var i = 0; i < _len; i++){
					var var_name = all_names[i];
					if(array_contains(exclusions, var_name)){
						continue;
					}
					var loaded_value = struct_get(deserialized_con, var_name);
					show_debug_message($"en_fleet {en_fleet_instance.id}  - var: {var_name}  -  val: {loaded_value}");
					try {
						variable_struct_set(en_fleet_instance, var_name, loaded_value);	
					} catch (e){
						show_debug_message(e);
					}
				}
			}		
		}
	    obj_saveload.alarm[1]=30;
	    obj_controller.invis=false;
	    global.load=0;
	    scr_image("force",-50,0,0,0,0);
	    debugl("Loading slot "+string(save_id)+" completed");
	}


}
