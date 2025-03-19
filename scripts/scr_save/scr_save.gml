

function ini_encode_and_json(ini_area, ini_code,value){
	return ini_write_string(ini_area,ini_code,base64_encode(json_stringify(value)));
}
function scr_save(save_part,save_id) {

	obj_saveload.GameSave = {};
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

	obj_saveload.GameSave.Save = {
        chapter_name: global.chapter_name,
        sector_name: obj_ini.sector_name,
        version: global.game_version,
        play_time: play_time,
        game_seed: global.game_seed,
        use_custom_icon: obj_ini.use_custom_icon,
        chapter_icon_sprite: global.chapter_icon_sprite,
        chapter_icon_frame: global.chapter_icon_frame,
        chapter_icon_path: global.chapter_icon_path,
		icon_name: global.icon_name,
		chapter_icon_filename: global.chapter_icon_filename,
		date: string(month)+"/"+string(day)+"/"+string(year)+" ("+string(hour)+":"+string(minute)+" "+string(pm)+")",
		founding: obj_ini.progenitor,
		custom: global.custom,
		stars: instance_number(obj_star),
		p_fleets: instance_number(obj_p_fleet),
		en_fleets: instance_number(obj_en_fleet),
		sod: random_get_seed(),
    }


	
	try{
	var num=0,tot=0;
	num=0;tot=0;

	num=instance_number(obj_star);
	instance_array[tot]=0;
	
	// if (file_exists("save1.ini")) then file_delete("save1.ini");
	// argument 0 = the part of the save to do
	//save_id = the save ID

	if (save_part=1) or (save_part=0){
		var fileid = file_text_open_append($"save{save_id}.json");
		file_text_write_string(fileid, "{\"GameSave\":{");

		file_text_write_string(fileid, $"\"Save\":{json_stringify(obj_saveload.GameSave.Save)},");
		file_text_close(fileid);

		// scr_save_controller(save_id);
		
	}


	if (save_part=2) or (save_part=0){
		show_debug_message("Saving to slot "+string(save_id)+" part 2");
		var fileid = file_text_open_append($"save{save_id}.json");
		
	    var num=instance_number(obj_star);
	    instance_array=0; 
		file_text_writeln(fileid);
		file_text_write_string(fileid, "\"Stars\":[");
	    for (var i=0; i<num; i+=1){
	        instance_array[i] = instance_find(obj_star,i);
			var star_json = instance_array[i].serialize();
			file_text_writeln(fileid);
			file_text_write_string(fileid, $"{json_stringify(star_json)},");
	    }
		file_text_write_string(fileid,"],")
		file_text_writeln(fileid);

	    // PLAYER FLEET OBJECTS
	    num=0;tot=0;num=instance_number(obj_p_fleet);
	    instance_array[tot]=0;

		obj_saveload.GameSave.PlayerFleet = [];


	    for (var i=0; i<num; i+=1){
	        instance_array[i] = instance_find(obj_p_fleet,i);
			var obj_p_fleet_json = instance_array[i].serialize();
			array_push(obj_saveload.GameSave.PlayerFleet, obj_p_fleet_json);
	    }
		file_text_writeln(fileid);
		file_text_write_string(fileid, "\"PlayerFleet\":");
		file_text_write_string(fileid, $"{json_stringify(obj_saveload.GameSave.PlayerFleet)},");

	    // ENEMY FLEET OBJECTS
	    num=0;tot=0;num=instance_number(obj_en_fleet);
	    instance_array[tot]=0;

		obj_saveload.GameSave.EnemyFleet = [];

	    for (var i=0; i<num; i+=1){
	        instance_array[i] = instance_find(obj_en_fleet,i);
			var obj_en_fleet_json = instance_array[i].serialize();
			array_push(obj_saveload.GameSave.EnemyFleet, obj_en_fleet_json);
	    }
		file_text_writeln(fileid);
		file_text_write_string(fileid, "\"EnemyFleet\":");
		file_text_write_string(fileid, $"{json_stringify(obj_saveload.GameSave.EnemyFleet)},");
		file_text_close(fileid);

	}


	if (save_part=3) or (save_part=0){
		var fileid = file_text_open_append($"save{save_id}.json");
		var obj_controller_json = obj_controller.serialize();
		obj_saveload.GameSave.Controller = obj_controller_json;
		file_text_writeln(fileid);
		file_text_write_string(fileid, "\"Controller\":");
		file_text_write_string(fileid, $"{json_stringify(obj_saveload.GameSave.Controller)},");
		file_text_close(fileid);
	}

	if (save_part=4) or (save_part=0){
		var obj_ini_json = obj_ini.serialize();
		obj_saveload.GameSave.Ini = obj_ini_json;
		var fileid = file_text_open_append($"save{save_id}.json");
		file_text_writeln(fileid);
		file_text_write_string(fileid, "\"Ini\":");
		file_text_write_string(fileid, $"{json_stringify(obj_saveload.GameSave.Ini)},");
		file_text_close(fileid);
	}

	if (save_part=5) or (save_part=0){
	    var fileid = file_text_open_append($"save{save_id}.json");
		file_text_writeln(fileid);
	    instance_activate_object(obj_event_log);
		file_text_write_string(fileid, $"\"Event\": {json_stringify(obj_event_log.event)}");
		file_text_close(fileid);
	    obj_saveload.hide=true;
	    obj_controller.invis=true;
	    obj_saveload.alarm[2]=2;

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

	    obj_saveload.save[save_id]=1;

	    debugl("Saving to slot "+string(save_id)+" complete");

		var fileid = file_text_open_append($"save{save_id}.json");
		file_text_writeln(fileid);
		file_text_write_string(fileid, "}}");
		file_text_writeln(fileid);
		file_text_close(fileid);
	}


	// Finish here



	// scr_load();


	/*

	probably need to add something like

	comp1_marines
	comp1_vehicles

	these will be loaded into a temporary variable and determine how many times the checks need to repeat








	////////////////////////////////
	////////Loading////////////////////////
	//////////////////////////////////
	ini_open(saveFile);
	num = ini_read_real("Save", "count", 0); //get the number of instances

	for ( i = 0; i < num; i += 1)
	{
	     myID = ini_read_real( "Save", "object" + string(i), 0); //loads id from file
	     myX = ini_read_real( "Save", "object" + string(i) + "x", 0); //loads x from file
	     myY = ini_read_real( "Save", "object" + string(i) + "y", 0); //loads y from file

	     instance_create( myX, myY, myID);
	}
	ini_close();




	1. Make it so that save files are named 'Save1', 'Save2', etc, then store the name of the save file that appears in the game as part of the save file.

	2. Check if 'Save1' exists, 'Save2', etc, and display them accordingly by reading their names from the file

	3. When clicked, load the file by its FILENAME. When the user deletes a file, remove it and rename all the files with names AFTER it (for example, if Save3 was deleted, rename Save4 to Save3, and Save5 to Save4). This way, the structure stays tidy.


	file_exists(fname) Returns whether the file with the given name exists (true) or not (false).




	Use Splash Webpage(from d&d) ! (hehe) Usually you want to open in browser not in game (splash_show_web(url,delay) shows only in game )

	Note: You can use working_directory to point the folder where the game is



	*/
	} catch(_exception){
        handle_exception(_exception);
    }


}
