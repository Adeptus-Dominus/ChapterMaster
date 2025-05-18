function load_marine_struct(company, marine, struct){

	obj_ini.TTRPG[company, marine] = new TTRPG_stats("chapter", company, marine, "blank");
	obj_ini.TTRPG[company, marine].load_json_data(struct);
			
};

function scr_load(save_part, save_id) {
	var t1 = get_timer();
	var filename = string(PATH_save_files, save_id);
	if(save_id == 0){
		filename = string(PATH_autosave_file);
		log_message("Loading from Autosave");
	}
	if(file_exists(filename)){
		var _gamesave_buffer = buffer_load(filename);
		var _gamesave_string = buffer_read(_gamesave_buffer, buffer_string);
		buffer_delete(_gamesave_buffer);
		var json_game_save = json_parse(_gamesave_string);
	}

	if(!struct_exists(obj_saveload.GameSave, "Save")){
		obj_saveload.GameSave = json_game_save;
	}


	if (save_part=1) or (save_part=0){
		log_message("Loading GLOBALS");
		// Globals
		var globals = obj_saveload.GameSave.Save;
		scr_load_chapter_icon(globals.icon_name, true);
		global.chapter_name = globals.chapter_name;
		global.custom = globals.custom;
		
	}


	if (save_part=2) or (save_part=0){
		log_message("Loading STARS");

	    // Stars
		var star_array = obj_saveload.GameSave.Stars;
		for(var i = 0; i < array_length(star_array); i++){
			var star_save_data = star_array[i];
    		var star_instance = instance_create(0,0, obj_star);
			with(star_instance){
				deserialize(star_save_data);
			}
		}
	}

	if (save_part=3) or (save_part=0){
		log_message("Loading INI");
		// Ini
		var ini_save_data = obj_saveload.GameSave.Ini;
		obj_ini.deserialize(ini_save_data);
		log_message("INI loaded");

		// Controller
		log_message("Loading CONTROLLER");
		var save_data = obj_saveload.GameSave.Controller;
		/// for some reason, obj_controller having it's deserialize as part of 
		/// the object doesnt want to work
		with(obj_controller){
			var exclusions = ["specialist_point_handler", "location_viewer", "id",
			 "techs","apoths","forge_queue","point_breakdown","apothecary_points", "forge_points"]; // skip automatic setting of certain vars, handle explicitly later

			// Automatic var setting
			var all_names = struct_get_names(save_data);
			var _len = array_length(all_names);
			for(var i = 0; i < _len; i++){
				var var_name = all_names[i];
				if(array_contains(exclusions, var_name)){
					continue;
				}
				var loaded_value = struct_get(save_data, var_name);
				// show_debug_message($"obj_controller var: {var_name}  -  val: {loaded_value}");
				try {
					variable_struct_set(obj_controller, var_name, loaded_value);	
				} catch (e){
					show_debug_message(e);
				}
			}
			specialist_point_handler = new SpecialistPointHandler();
			// Transfer properties from save data to handler with null-checking
			var properties = ["forge_queue"];
			for (var i = 0; i < array_length(properties); i++) {
				var prop = properties[i];
				if (struct_exists(save_data, prop)) {
					variable_struct_set(specialist_point_handler, prop, variable_struct_get(save_data, prop));
				}
			}
			specialist_point_handler.calculate_research_points();
			location_viewer = new UnitQuickFindPanel();
			scr_colors_initialize();
			scr_shader_initialize();
			
			global.star_name_colors[1] = make_color_rgb(body_colour_replace[0],body_colour_replace[1],body_colour_replace[2]);

		}
		log_message("CONTROLLER loaded");

	}



	if (save_part=4) or (save_part=0){
		log_message("Loading PLAYER FLEET OBJECTS");// PLAYER FLEET OBJECTS
	    var p_fleet = obj_saveload.GameSave.PlayerFleet;
		for(var i = 0; i < array_length(p_fleet); i++){
			var deserialized = p_fleet[i];
    		var p_fleet_instance = instance_create(0,0, obj_p_fleet);
			with(p_fleet_instance){
				deserialize(deserialized);
			}
			
		}
		log_message("PLAYER FLEET OBJECTS loaded");
	}

	if (save_part=5) or (save_part=0){
		log_message("Loading ENEMY FLEET OBJECTS");

	    var en_fleet = obj_saveload.GameSave.EnemyFleet;
		for(var i = 0; i < array_length(en_fleet); i++){
			var deserialized = en_fleet[i];
    		var en_fleet_instance = instance_create(0,0, obj_en_fleet);
			with(en_fleet_instance){
				deserialize(deserialized);
			}		

		}
		log_message("ENEMY FLEET OBJECTS loaded");

		log_message("Loading EVENT LOG");
		if(!instance_exists(obj_event_log)){
			instance_create(0,0,obj_event_log);
		}
		instance_activate_object(obj_event_log);
		obj_event_log.event = obj_saveload.GameSave.EventLog
		log_message("EVENT LOG Loaded");

	    obj_saveload.alarm[1]=5;
	    obj_controller.invis=false;
	    global.load=-1;
	    scr_image("force",-50,0,0,0,0);
	    log_message("Loading completed");
		// room_goto(Game);
	}

	var t2 = get_timer();
	var diff = (t2 - t1) / 1000000;
	log_message($"Loading part {save_part} took {diff} seconds!");
}
