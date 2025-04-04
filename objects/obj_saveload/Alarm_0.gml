if (save_part == 6) {
	txt = "Praise to the Machine God";

	with (obj_controller) {
		scr_save(5, obj_saveload.save_number);
	}
	trickle = 2;
}

if (save_part == 5) {
	txt = "Astartes Registry";

	with (obj_controller) {
		scr_save(4, obj_saveload.save_number);
	}
	trickle = 2;
	save_part = 6;
}

if (save_part == 4) {
	txt = "Sacred Anointing of Oil";

	with (obj_controller) {
		scr_save(3, obj_saveload.save_number);
	}
	trickle = 2;
	save_part = 5;
}

if (save_part == 3) {
	txt = "Charting Sector";

	with (obj_controller) {
		scr_save(2, obj_saveload.save_number);
	}
	trickle = 2;
	save_part = 4;
}

if (save_part == 2) {
	txt = "Finding Servo Skulls";

	with (obj_controller) {
		scr_save(1, obj_saveload.save_number);
	}
	trickle = 2;
	save_part = 3;
}

if (save_part == 1) {
	if (file_exists("save" + string(save_number) + ".json")) {
	if (file_exists($"save{save_number}.json")) {
		file_delete($"save{save_number}.json");
	}
	if (file_exists($"screen{save_number}.png")) {
		file_delete($"screen{save_number}.png");
	}
	obj_saveload.save[save_number] = 0;
	save_part += 1;
	trickle = 2;
	txt = "Preparing";
}
if (load_part==6){
    txt="Praise to the Machine God";
    if (global.restart>0) then txt="Praise be to the Emperor";
    with(obj_controller){
		// show_debug_message($"load section 5");
        scr_load(5,global.load);
        
    }
    trickle=2;
    if (instance_exists(obj_cuicons)){
        obj_cuicons.alarm[1]=30;
    }
}

if (load_part == 5) {
	txt = "Sacred Anointing of Oil";
	if (global.restart > 0) {
		txt = "Speed Dialing Howling Banshee";
	}

	with (obj_controller) {
		// show_debug_message($"load section 4");
		scr_load(4, global.load);
	}
	trickle = 2;
	load_part = 6;
}

if (load_part == 4) {
	txt = "Astartes Registry";
	if (global.restart > 0) {
		txt = "Donning Power Armour";
	}
	with (obj_controller) {
		// show_debug_message($"load section 3");
		scr_load(3, global.load);
	}
	trickle = 2;
	load_part = 5;
}

if (load_part == 3) {
	txt = "Charting Sector";
	if (global.restart > 0) {
		txt = "Rousing the Machine Spirit";
	}
	with (obj_controller) {
		// show_debug_message($"load section 2");
		scr_load(2, global.load);
	}
	trickle = 2;
	load_part = 4;
}

if (load_part == 2) {
	txt = "Finding Servo Skulls";
	if (global.restart > 0) {
		txt = "Turtle Waxing Scalp";
	}
	with (obj_controller) {
		// show_debug_message($"load section 1");
		scr_load(1, global.load);
	}
	trickle = 2;
	load_part = 3;
}

if (load_part == 1) {
	if (file_exists($"save{global.load}.json")) {
		load_part += 1;
		trickle = 2;
		txt = "Preparing";
	}
}
