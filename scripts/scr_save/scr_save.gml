/// @description This function converts a single struct or a hierarchy of nested structs and arrays into a valid JSON string, then into a base64 format encoded string, and then write into an ini. If the input is big, consider using ini_encode_and_json_advanced() to avoid stack overflow.
/// @param {string} ini_area
/// @param {string} ini_code
/// @param {struct|array} value
function ini_encode_and_json(ini_area, ini_code, value){
	ini_write_string(ini_area, ini_code, base64_encode(json_stringify(value)));
}

/// @description This function converts a single struct or a hierarchy of nested structs and arrays into a valid JSON string, then into a base64 format encoded string, using an intermediate buffer, to prevent stack overflow due to big input strings, and then write into an ini.
/// @param {string} ini_area
/// @param {string} ini_code
/// @param {struct|array} value
function ini_encode_and_json_advanced(ini_area, ini_code, value){
	ini_write_string(ini_area, ini_code, jsonify_encode_advanced(value));
}

function scr_save(save_part,save_id, autosaving = false) {
	if(autosaving){
		obj_saveload.hide=true;
	}
	var t1 = get_timer();
	try{
		log_message($"Saving to slot {save_id} - started! Autosave? {autosaving}");
		if (save_part== 1 || autosaving){
			log_message($"Saving to slot {save_id} - part {save_part} started!");
			var t=date_current_datetime();
			var month=date_get_month(t);
			var day=date_get_day(t);
			var year=date_get_year(t);
			var hour=date_get_hour(t);
			var minute=date_get_minute(t);
			var pm=(hour>=12 && hour<24) ? "PM":"AM";
			if (hour=0) then hour=12;
			var mahg=minute;
			if (mahg<10) then minute=$"0{mahg}";
			log_message($"Saving to slot {save_id} - vars are assigned!");
			
			obj_saveload.GameSave.Save = {
				chapter_name: global.chapter_name,
				sector_name: obj_ini.sector_name,
				version: global.game_version,
				play_time: play_time,
				game_seed: global.game_seed,
				use_custom_icon: obj_ini.use_custom_icon,
				chapter_icon_id: global.chapter_icon.icon_id,
				chapter_icon_type: global.chapter_icon.type,
				// chapter_icon_sprite: global.chapter_icon_sprite,
				// chapter_icon_frame: global.chapter_icon_frame,
				// chapter_icon_path: global.chapter_icon_path,
				// icon_name: global.icon_name,
				date: string(month)+"/"+string(day)+"/"+string(year)+" ("+string(hour)+":"+string(minute)+" "+string(pm)+")",
				founding: obj_ini.progenitor,
				custom: global.custom,
				stars: instance_number(obj_star),
				p_fleets: instance_number(obj_p_fleet),
				en_fleets: instance_number(obj_en_fleet),
				sod: random_get_seed(),
			}

			log_message($"Saving to slot {save_id} - GameSave struct created!");
			
			/// STARS
			var num=instance_number(obj_star);
			for (var i=0; i<num; i+=1){
				var star_obj = instance_find(obj_star,i);
				var star_json = star_obj.serialize();
				array_push(obj_saveload.GameSave.Stars, star_json);
			}
			log_message($"Saving to slot {save_id} - stars are serialized and stored!");
		}


		if (save_part== 2 || autosaving){
			log_message($"Saving to slot {save_id} - part {save_part} started!");
			// PLAYER FLEET OBJECTS
			var num = instance_number(obj_p_fleet);
			for (var i=0; i<num; i+=1){
				var fleet_obj = instance_find(obj_p_fleet,i);
				var obj_p_fleet_json = fleet_obj.serialize();
				array_push(obj_saveload.GameSave.PlayerFleet, obj_p_fleet_json);
			}
			log_message($"Saving to slot {save_id} - player fleets are serialized and stored!");

			// ENEMY FLEET OBJECTS
			obj_saveload.GameSave.EnemyFleet = [];
			num = instance_number(obj_en_fleet);
			for (var i=0; i<num; i+=1){
				var fleet_obj = instance_find(obj_en_fleet,i);
				var obj_en_fleet_json = fleet_obj.serialize();
				array_push(obj_saveload.GameSave.EnemyFleet, obj_en_fleet_json);
			}
			log_message($"Saving to slot {save_id} - enemy fleets are serialized and stored!");
		}


		if (save_part== 3 || autosaving){
			log_message($"Saving to slot {save_id} - part {save_part} started!");
			var obj_controller_json = obj_controller.serialize();
			obj_saveload.GameSave.Controller = obj_controller_json;
			log_message($"Saving to slot {save_id} - obj_controller is serialized and stored!");
		}

		if (save_part==4 || autosaving){
			log_message($"Saving to slot {save_id} - part {save_part} started!");
			var obj_ini_json = obj_ini.serialize();
			obj_saveload.GameSave.Ini = obj_ini_json;
			log_message($"Saving to slot {save_id} - obj_ini is serialized and stored!");
		}

		if (save_part==5 || autosaving){
			log_message($"Saving to slot {save_id} - part {save_part} started!");
			instance_activate_object(obj_event_log);
			obj_saveload.GameSave.EventLog = obj_event_log.event;
			if(!autosaving){
				obj_saveload.hide=true;
				obj_controller.invis=true;
				obj_saveload.alarm[2]=2; //handles screenshot and reactivting the main UI
			}

			var svt=0,svc="",svm="",smr=0,svd="";
			svt=obj_controller.turn; 
			svc=obj_saveload.GameSave.Save.chapter_name;
			svm=obj_ini.master_name;
			smr=obj_controller.marines;
			svd=obj_saveload.GameSave.Save.date

			ini_open("saves.ini");
			ini_write_real(string(save_id),"turn",svt);
			ini_write_string(string(save_id),"chapter_name",svc);
			ini_write_string(string(save_id),"master_name",svm); 
			ini_write_real(string(save_id),"marines",smr);
			ini_write_string(string(save_id),"date",svd);
			ini_write_real(string(save_id),"time",obj_controller.play_time);
			ini_write_real(string(save_id),"seed",global.game_seed);
			ini_close();
			log_message($"Saving to slot {save_id} - saves.ini saving complete!");

			obj_saveload.save[save_id]=1;

			var _gamesave_string = json_stringify(obj_saveload.GameSave, !autosaving);
			var _gamesave_buffer = buffer_create(string_byte_length(_gamesave_string) + 1, buffer_fixed, 1);

			
			var filename;
			if(!autosaving){
				filename = string(PATH_save_files, save_id);
			} else {
				filename = string(PATH_autosave_file);
			}

			buffer_write(_gamesave_buffer, buffer_string, _gamesave_string);
			buffer_save(_gamesave_buffer, filename);
			buffer_delete(_gamesave_buffer);
			if(!autosaving){
				log_message($"Saving to slot {save_id} - GameSave struct conversion complete!");
			} else {
				log_message($"Saving to autosave slot - GameSave struct conversion complete!");
			}
		}

	} catch(_exception){
        handle_exception(_exception);
    }

	var t2 = get_timer();
	var diff = (t2 - t1) / 1000000;
	if(!autosaving){	
		log_message($"Saving part {save_part} took {diff} seconds!");
	} else {
		log_message($"Autosaving took {diff} seconds!");
	}
}
