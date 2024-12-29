if (save_part == 6) {
	txt = "Praise to the Machine God";

	with (obj_controller) {
		scr_save(5, obj_saveload.save_number);
	}
	trickle = 50;
}

if (save_part == 5) {
	txt = "Astartes Registry";

	with (obj_controller) {
		scr_save(4, obj_saveload.save_number);
	}
	trickle = 40;
	save_part = 6;
}

if (save_part == 4) {
	txt = "Sacred Anointing of Oil";

	with (obj_controller) {
		scr_save(3, obj_saveload.save_number);
	}
	trickle = 10;
	save_part = 5;
}

if (save_part == 3) {
	txt = "Charting Sector";

	with (obj_controller) {
		scr_save(2, obj_saveload.save_number);
	}
	trickle = 10;
	save_part = 4;
}

if (save_part == 2) {
	txt = "Finding Servo Skulls";

	with (obj_controller) {
		scr_save(1, obj_saveload.save_number);
	}
	trickle = 10;
	save_part = 3;
}

if (save_part == 1) {
	if (file_exists("save" + string(save_number) + ".ini")) {
		file_delete("save" + string(save_number) + ".ini");
	}
	if (file_exists("screen" + string(save_number) + ".png")) {
		file_delete("screen" + string(save_number) + ".png");
	}
	ini_open("saves.ini");
	ini_section_delete(string(save_number));
	ini_close();
	obj_saveload.save[save_number] = 0;
	save_part += 1;
	trickle = 10;
	txt = "Preparing";
}
if (load_part==6){
    txt="Praise to the Machine God";
    if (global.restart>0) then txt="Praise be to the Emperor";
    with(obj_controller){
        scr_load(5,global.load);
        // **sets up starting forge_points
        location_viewer = new UnitQuickFindPanel();
        
        specialist_point_handler.calculate_research_points();

        //** sets up marine_by_location view
        with(obj_controller){
            global.star_name_colors[1] = make_color_rgb(body_colour_replace[0],body_colour_replace[1],body_colour_replace[2]);
        }
    }
    trickle=50;
    
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
		scr_load(4, global.load);
	}
	trickle = 10;
	load_part = 6;
}

if (load_part == 4) {
	txt = "Astartes Registry";
	if (global.restart > 0) {
		txt = "Donning Power Armour";
	}
	with (obj_controller) {
		scr_load(3, global.load);
	}
	trickle = 40;
	load_part = 5;
}

if (load_part == 3) {
	txt = "Charting Sector";
	if (global.restart > 0) {
		txt = "Rousing the Machine Spirit";
	}
	with (obj_controller) {
		scr_load(2, global.load);
	}
	trickle = 10;
	load_part = 4;
}

if (load_part == 2) {
	txt = "Finding Servo Skulls";
	if (global.restart > 0) {
		txt = "Turtle Waxing Scalp";
	}
	with (obj_controller) {
		scr_load(1, global.load);
	}
	trickle = 10;
	load_part = 3;
}

if (load_part == 1) {
	if (file_exists("save" + string(global.load) + ".ini")) {
		load_part += 1;
		trickle = 10;
		txt = "Preparing";
	}
}
