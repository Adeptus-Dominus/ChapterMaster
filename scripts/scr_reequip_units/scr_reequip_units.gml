function set_up_equip_popup(){
	if (instance_number(obj_popup)==0){
	    var f=0,god=0,nuuum=0;
	    var o_wep1="",o_wep2="",o_armour="",o_gear="",o_mobi="";
	    var b_wep1=0,b_wep2=0,b_armour=0,b_gear=0,b_mobi=0;
	    var vih=0, _unit;
	    var company = managing<=10 ? managing :10;
	    var prev_role;
	    var allow = true;

	    // Need to make sure that group selected is all the same type
	    for(var f=0; f<array_length(display_unit); f++){

	        // Set different vih depending on _unit type
	        if (man_sel[f]!=1) then continue;
	        if (vih==0){
	            if (man[f]=="man" && is_struct(display_unit[f])){
	                _unit=display_unit[f];
	                if (_unit.armour()!="Dreadnought"){
	                    vih=1;
	                } else {
	                    vih=6;
	                }
	            } else if (man[f]=="vehicle"){
	                if (ma_role[f]=="Land Raider") { vih=50;}
	                else if (ma_role[f]=="Rhino") { vih=51;}
	                else if (ma_role[f]=="Predator") {vih=52;}
	                else if (ma_role[f]=="Land Speeder") { vih=53;}
	                else if (ma_role[f]=="Whirlwind") {vih=54;}
	                prev_role = ma_role[f]=="Whirlwind";
	            }
	        } else {
	            if (vih==1 || vih==6){
	                if (man[f]=="vehicle"){
	                    allow=false;
	                    break;
	                } else if (man[f]=="man" && is_struct(display_unit[f])){
	                    _unit=display_unit[f];
	                    if (_unit.armour()=="Dreadnought" && vih==1){
	                        allow=false;
	                        break;
	                    } else if (_unit.armour()!="Dreadnought" && vih==6){
	                        allow=false;
	                        break;
	                    }
	                }
	            } else if (vih>=50){
	                if (man[f]=="man"){
	                    allow=false;
	                    break;
	                } else if(man[f]=="vehicle"){
	                    if (prev_role != ma_role[f]){
	                        allow=false;
	                        break;
	                    }
	                }
	            }
	        }

	        if (vih>0){
	            nuuum+=1;
	            if (o_wep1=="") and (ma_wep1[f]!="") then o_wep1=ma_wep1[f];
	            if (o_wep2=="") and (ma_wep2[f]!="") then o_wep2=ma_wep2[f];
	            if (o_armour=="") and (ma_armour[f]!="") then o_armour=ma_armour[f];
	            if (o_gear=="") and (ma_gear[f]!="") then o_gear=ma_gear[f];
	            if (o_mobi=="") and (ma_mobi[f]!="") then o_mobi=ma_mobi[f];

	            if (ma_wep1[f]=="") then b_wep1+=1;
	            if (ma_wep2[f]=="") then b_wep2+=1;
	            if (ma_armour[f]=="") then b_armour+=1;
	            if (ma_gear[f]=="") then b_gear+=1;
	            if (ma_mobi[f]=="") then b_mobi+=1;

	            if ((o_wep1!="") and (ma_wep1[f]!=o_wep1)) or (b_wep1==1) then o_wep1="Assortment";
	            if ((o_wep2!="") and (ma_wep2[f]!=o_wep2)) or (b_wep2==1) then o_wep2="Assortment";
	            if ((o_armour!="") and (ma_armour[f]!=o_armour)) or (b_armour==1) then o_armour="Assortment";
	            if ((o_gear!="") and (ma_gear[f]!=o_gear)) or (b_gear==1) then o_gear="Assortment";
	            if ((o_mobi!="") and (ma_mobi[f]!=o_mobi)) or (b_mobi==1) then o_mobi="Assortment";
	        }
	    }

	    if (b_wep1==nuuum) then o_wep1="";
	    if (b_wep2==nuuum) then o_wep2="";
	    if (b_armour==nuuum) then o_armour="";
	    if (b_gear==nuuum) then o_gear="";
	    if (b_mobi==nuuum) then o_mobi="";

	    if (vih>0 && man_size>0 && allow){

	        var pip=instance_create(0,0,obj_popup);
	        pip.type=6;
	        pip.o_wep1=o_wep1;
	        pip.o_wep2=o_wep2;
	        pip.o_armour=o_armour;
	        pip.o_gear=o_gear;
	        pip.n_wep1=o_wep1;
	        pip.n_wep2=o_wep2;
	        pip.n_armour=o_armour;
	        pip.n_gear=o_gear;
	        pip.o_mobi=o_mobi;
	        pip.n_mobi=o_mobi;
	        pip.company=managing;
	        pip.units=nuuum;

	        //Forwards vih selection to the vehicle_equipment variable used in mouse_50 obj_popup and weapons_equip script
	        pip.vehicle_equipment=vih;
	        with (pip){
	        	cancel_button = new UnitButtonObject(
		        	{
		        		x1: 1061, 
				        y1: 491, 
				        style : "pixel",
				        label : "Cancel"
		        	}
		        );
		        equip_button = new UnitButtonObject(
		        	{
		        		x1: 1450, 
				        y1: 491,
				        style : "pixel",
						label : "Equip"
		        	}
		        );

		        main_slate = new DataSlate({
		        	style : "decorated",
		        	XX : 1006,
		        	YY : 143,
		        	set_width : true,
		        	width : 571,
		        	height : 350,
		        });

		        var _quality_options = [
		        	{
						str1 : "Standard",
						font : fnt_40k_14b,
						val : 0
					},
		        	{
						str1 : "Master Crafted",
						font : fnt_40k_14b,
						val : 1
					},
		        	{
						str1 : "Artificer",
						font : fnt_40k_14b,
						val : 2
					}										
		        ];
		        quality_radio = new radio_set(_quality_options, "Target Company", {max_width : 500, x1:1292, y1:308});

		        range_melee_radio = new radio_set([
		        	{
						str1 : "Ranged",
						font : fnt_40k_14b,
						val : eENGAGEMENT.Ranged
					},
		        	{
						str1 : "Melee",
						font : fnt_40k_14b,
						val : eENGAGEMENT.Melee
					}], "Target Company", {max_width : 500, x1:1292, y1:328});
	        }
	    }
	}
}


function reload_items(){
    item_name = [];
    scr_get_item_names(
        item_name,
        vehicle_equipment, // eROLE
        equipmet_area, // slot
        range_melee_radio.selection_val("val"),
        false, // include company standard
        true, // limit to available equipment
        quality_options.selection_val("val"),
    );	
}
function draw_popup_equip(){
	main_slate.draw_with_dimensions();
	draw_set_color(CM_GREEN_COLOR);
	draw_text(1302, 145, "Change Equipment");

	draw_set_font(fnt_40k_12);
	var comp = "";
	if (company <= 10 && company > 0) {
		comp = romanNumerals[company - 1];
	} else if (company > 10) {
		comp = "HQ";
	}

	if (vehicle_equipment == 0) {
		draw_text(1292, 170, $"{comp} Company, {units} Marines");
	}
	if (vehicle_equipment == 1) {
		draw_text(1292, 170, $"{comp} Company, {units} Vehicles");
	}

	draw_set_halign(fa_left);
	draw_set_color(c_gray);

	draw_rectangle(1010, 215, 1288, 315, 1);
	draw_rectangle(1574, 215, 1296, 315, 1);

	var show_name = "";
	// Need to not show the artifact tags here somehow

	draw_text(1010, 195, "Before");
	draw_text(1010.5, 195.5, "Before");

	show_name = o_wep1;
	if (a_wep1 != "") {
		show_name = a_wep1;
	}
	if (o_wep1 != "") {
		draw_text(1014, 215, string_hash_to_newline(show_name));
	} else {
		draw_text(1014, 215, ITEM_NAME_NONE);
	}

	show_name = o_wep2;
	if (a_wep2 != "") {
		show_name = a_wep2;
	}
	if (o_wep2 != "") {
		draw_text(1014, 235, string_hash_to_newline(string(show_name)));
	} else {
		draw_text(1014, 235, ITEM_NAME_NONE);
	}

	show_name = o_armour;
	if (a_armour != "") {
		show_name = a_armour;
	}
	if (o_armour != "") {
		draw_text(1014, 255, string_hash_to_newline(string(show_name)));
	} else {
		draw_text(1014, 255, ITEM_NAME_NONE);
	}

	show_name = o_gear;
	if (a_gear != "") {
		show_name = a_gear;
	}
	if (o_gear != "") {
		draw_text(1014, 275, string_hash_to_newline(string(show_name)));
	} else {
		draw_text(1014, 275, ITEM_NAME_NONE);
	}

	show_name = o_mobi;
	if (a_mobi != "") {
		show_name = a_mobi;
	}
	if (o_mobi != "") {
		draw_text(1014, 295, string_hash_to_newline(string(show_name)));
	} else {
		draw_text(1014, 295, ITEM_NAME_NONE);
	}

	draw_text(1296, 195, string_hash_to_newline("After"));
	draw_text(1296.5, 195.5, "After");

	draw_set_color(c_gray);
	if (n_good1 == 0) {
		draw_set_color(255);
	}
	show_name = n_wep1;
	if ((a_wep1 != "") && (n_wep1 == o_wep1)) {
		show_name = a_wep1;
	}
	if (n_wep1 != "") {
		draw_text(1300, 215, string_hash_to_newline(string(show_name)));
	} else {
		draw_text(1300, 215, string_hash_to_newline(ITEM_NAME_NONE));
	}

	draw_set_color(c_gray);
	if (n_good2 == 0) {
		draw_set_color(255);
	}
	show_name = n_wep2;
	if ((a_wep2 != "") && (n_wep2 == o_wep2)) {
		show_name = a_wep2;
	}
	if (n_wep2 != "") {
		draw_text(1300, 235, string_hash_to_newline(string(show_name)));
	} else {
		draw_text(1300, 235, string_hash_to_newline(ITEM_NAME_NONE));
	}

	draw_set_color(c_gray);
	if (n_good3 == 0) {
		draw_set_color(255);
	}
	show_name = n_armour;
	if ((a_armour != "") && (n_armour == o_armour)) {
		show_name = a_armour;
	}
	if (n_armour != "") {
		draw_text(1300, 255, string_hash_to_newline(string(show_name)));
	} else {
		draw_text(1300, 255, string_hash_to_newline(ITEM_NAME_NONE));
	}

	draw_set_color(c_gray);
	if (n_good4 == 0) {
		draw_set_color(255);
	}
	show_name = n_gear;
	if ((a_gear != "") && (n_gear == o_gear)) {
		show_name = a_gear;
	}
	if (n_gear != "") {
		draw_text(1300, 275, string_hash_to_newline(string(show_name)));
	} else {
		draw_text(1300, 275, string_hash_to_newline(ITEM_NAME_NONE));
	}

	draw_set_color(c_gray);
	if (n_good5 == 0) {
		draw_set_color(255);
	}
	show_name = n_mobi;
	if ((a_mobi != "") && (n_mobi == o_mobi)) {
		show_name = a_mobi;
	}
	if (n_mobi != "") {
		draw_text(1300, 295, string_hash_to_newline(string(show_name)));
	} else {
		draw_text(1300, 295, string_hash_to_newline(ITEM_NAME_NONE));
	}

	draw_set_color(c_gray);

	for (var i = 0; i <= 4; i++) {
		if (equipmet_area == i) {
			draw_text(1292, 195 + (20 * i), "->");
			break;
		}
	}

	if ((mouse_x >= 1296) && (mouse_x < 1574)) {
		if ((mouse_y >= 215) && (mouse_y < 235)) {
			draw_set_alpha(0.5);
			draw_line(1296, 230, 1574, 230);
		}
		if ((mouse_y >= 235) && (mouse_y < 255)) {
			draw_set_alpha(0.5);
			draw_line(1296, 250, 1574, 250);
		}
		if ((mouse_y >= 255) && (mouse_y < 275)) {
			draw_set_alpha(0.5);
			draw_line(1296, 270, 1574, 270);
		}
		if ((mouse_y >= 275) && (mouse_y < 295)) {
			draw_set_alpha(0.5);
			draw_line(1296, 290, 1574, 290);
		}
		if ((mouse_y >= 295) && (mouse_y < 315)) {
			draw_set_alpha(0.5);
			draw_line(1296, 310, 1574, 310);
		}
	}
	draw_set_alpha(1);

	if (equipmet_area != -1) {
		var check = " ";
		var mct = master_crafted == 1 ? 0.7 : 1;
		var column = 0;
		var row = 0;
		var item_string;
		var box = [];
		var box_x;
		var box_y;
		var top = -1;

		var selected_item_name = [n_wep1, n_wep2, n_armour, n_gear, n_mobi];
		selected_item_name = selected_item_name[equipmet_area];

		for (var o = 0; o < array_length(item_name); o++) {
			box_x = 1016 + (row * 154);
			box_y = 355 + (column * 20);
			box = [box_x, box_y, box_x + 144, box_y + 20];
			check = selected_item_name == item_name[o] ? "x" : " ";
			item_string = $"[{check}] {item_name[o]}";
			draw_text_transformed(box_x, box_y, item_string, mct, 1, 0);

			if (point_and_click(box)) {
				top = o;
			}
			column++;
			if (column > 6) {
				column = 0;
				row++;
			}
		}

		if (top != -1) {
			warning = "";
			switch (equipmet_area) {
				case 0:
					n_wep1 = item_name[top];
					sel1 = top;
					break;
				case 1:
					n_wep2 = item_name[top];
					sel2 = top;
					break;
				case 2:
					n_armour = item_name[top];
					sel3 = top;
					break;
				case 3:
					n_gear = item_name[top];
					sel4 = top;
					break;
				case 4:
					n_mobi = item_name[top];
					sel5 = top;
					break;
			}
		}

		if (equipmet_area == EquipmentSlot.WEAPON_ONE && (n_wep1 == ITEM_NAME_NONE || n_wep1 == "")) {
			n_good1 = 1;
		}
		if (equipmet_area == EquipmentSlot.WEAPON_TWO && (n_wep2 == ITEM_NAME_NONE || n_wep2 == "")) {
			n_good2 = 1;
		}
		if (equipmet_area == EquipmentSlot.ARMOUR && (n_armour == ITEM_NAME_NONE || n_armour == "")) {
			n_good3 = 1;
		}
		if (equipmet_area == EquipmentSlot.GEAR && (n_gear == ITEM_NAME_NONE || n_gear == "")) {
			n_good4 = 1;
		}
		if (equipmet_area == EquipmentSlot.MOBILITY && (n_mobi == ITEM_NAME_NONE || n_mobi == "")) {
			n_good5 = 1;
		}

		var weapon_one_data = gear_weapon_data("weapon", n_wep1);
		var weapon_two_data = gear_weapon_data("weapon", n_wep2);
		var armour_data = gear_weapon_data("armour", n_armour);

		if ((equipmet_area == EquipmentSlot.WEAPON_ONE) && is_struct(weapon_one_data)) {
			// Check numbers
			req_wep1_num = units;
			have_wep1_num = 0;
			var i = -1;
			repeat (array_length(obj_controller.display_unit)) {
				i += 1;
				if ((vehicle_equipment != -1) && (obj_controller.ma_wep1[i] == n_wep1)) {
					have_wep1_num += 1;
				}
			}
			have_wep1_num += scr_item_count(n_wep1);
			if (have_wep1_num >= req_wep1_num || n_wep1 == ITEM_NAME_NONE) {
				n_good1 = 1;
			}
			if (have_wep1_num < req_wep1_num && (n_wep1 != ITEM_NAME_ANY && n_wep1 != ITEM_NAME_NONE)) {
				n_good1 = 0;
				warning = "Not enough " + string(n_wep1) + "; " + string(req_wep1_num - have_wep1_num) + " more are required.";
			}

			//TODO wrap this up in a function
			if (weapon_one_data.req_exp > 0) {
				var g = -1, exp_check = 0;
				for (var g = 0; g < array_length(obj_controller.display_unit); g++) {
					if (obj_controller.man_sel[g] == 1 && is_struct(obj_controller.display_unit[g])) {
						if (obj_controller.display_unit[g].experience < weapon_one_data.req_exp) {
							exp_check = 1;
							n_good1 = 0;
							warning = $"A unit must have {weapon_one_data.req_exp}+ EXP to use a {weapon_one_data.name}.";
							break;
						}
					}
				}
			}
			if (is_struct(armour_data)) {
				if (((!array_contains(armour_data.tags, "terminator")) && (!array_contains(armour_data.tags, "dreadnought"))) && (n_wep1 == "Assault Cannon")) {
					n_good1 = 0;
					warning = "Cannot use Assault Cannons without Terminator/Dreadnought Armour.";
				}
				if ((!array_contains(armour_data.tags, "dreadnought")) && (n_wep1 == "Close Combat Weapon")) {
					n_good1 = 0;
					warning = "Only " + string(obj_ini.role[100][6]) + " can use Close Combat Weapons.";
				}
			}
		}
		if ((equipmet_area == EquipmentSlot.WEAPON_TWO) && is_struct(weapon_two_data)) {
			// Check numbers
			req_wep2_num = units;
			have_wep2_num = 0;
			var i = -1;
			repeat (array_length(obj_controller.display_unit)) {
				i += 1;
				if ((vehicle_equipment != -1) && (obj_controller.ma_wep2[i] == n_wep2)) {
					have_wep2_num += 1;
				}
			}
			// req_wep2_num+=scr_item_count(n_wep2);
			have_wep2_num += scr_item_count(n_wep2);
			// req_wep2_num=units;

			if (have_wep2_num >= req_wep2_num || n_wep2 == ITEM_NAME_NONE) {
				n_good2 = 1;
			}
			if (have_wep2_num < req_wep2_num && (n_wep2 != ITEM_NAME_ANY && n_wep2 != ITEM_NAME_NONE)) {
				n_good2 = 0;
				warning = $"Not enough {n_wep2}; {req_wep2_num - have_wep2_num} more are required.";
			}
			//TODO standardise exp check
			if (weapon_two_data.req_exp > 0) {
				var g, exp_check;
				g = -1;
				exp_check = 0;
				for (var g = 0; g < array_length(obj_controller.display_unit); g++) {
					if (obj_controller.man_sel[g] == 1 && is_struct(obj_controller.display_unit[g])) {
						if (obj_controller.display_unit[g].experience < weapon_two_data.req_exp) {
							exp_check = 1;
							n_good1 = 0;
							warning = $"A unit must have {weapon_two_data.req_exp}+ EXP to use a {weapon_two_data.name}.";
							break;
						}
					}
				}
			}
			if (is_struct(armour_data)) {
				if (((!array_contains(armour_data.tags, "terminator")) && (!array_contains(armour_data.tags, "dreadnought"))) && (n_wep2 == "Assault Cannon")) {
					n_good2 = 0;
					warning = "Cannot use Assault Cannons without Terminator/Dreadnought Armour.";
				}
				if ((!array_contains(armour_data.tags, "dreadnought")) && (n_wep2 == "Close Combat Weapon")) {
					n_good2 = 0;
					warning = "Only " + string(obj_ini.role[100][6]) + " can use Close Combat Weapons.";
				}
				if (((string_count("Terminator", n_armour) > 0) || (string_count("Tartaros", n_armour) > 0) || (string_count("Dreadnought", n_armour) > 0)) && (n_mobi != "")) {
					n_good2 = 0;
				}
				if (((string_count("Terminator", o_armour) > 0) || (string_count("Tartaros", o_armour) > 0) || (string_count("Dreadnought", o_armour) > 0)) && (n_mobi != "")) {
					n_good2 = 0;
				}
			}
		}
		if ((equipmet_area == EquipmentSlot.ARMOUR) && is_struct(armour_data)) {
			// Check numbers
			req_armour_num = units;
			have_armour_num = 0;
			var i;
			i = -1;
			repeat (array_length(obj_controller.display_unit)) {
				i += 1;
				if ((vehicle_equipment != -1) && (obj_controller.man_sel[i] == 1) && (obj_controller.ma_armour[i] == n_armour)) {
					have_armour_num += 1;
				}
			}
			have_armour_num += scr_item_count(n_armour);

			if (have_armour_num >= req_armour_num || n_armour == ITEM_NAME_NONE) {
				n_good3 = 1;
			}
			if (have_armour_num < req_armour_num && (n_armour != ITEM_NAME_ANY && n_armour != ITEM_NAME_NONE)) {
				n_good3 = 0;
				warning = $"Not enough {n_armour} : {units - have_armour_num} more are required.";
			}

			var g = -1, exp_check = 0;
			if (armour_data.has_tag("terminator")) {
				if (armour_data.req_exp > 0) {
					var g, exp_check;
					g = -1;
					exp_check = 0;
					for (var g = 0; g < array_length(obj_controller.display_unit); g++) {
						if (obj_controller.man_sel[g] == 1 && is_struct(obj_controller.display_unit[g])) {
							if (obj_controller.display_unit[g].experience < armour_data.req_exp) {
								exp_check = 1;
								n_good1 = 0;
								warning = $"A unit must have {armour_data.req_exp}+ EXP to use a {armour_data.name}.";
								break;
							}
						}
					}
				}
			}

			if ((string_count("Dread", o_armour) > 0) && (string_count("Dread", n_armour) == 0)) {
				n_good4 = 0;
				warning = "Marines may not exit Dreadnoughts.";
			}
		}
		if ((equipmet_area == EquipmentSlot.GEAR) && (n_gear != "Assortment") && (n_gear != ITEM_NAME_NONE)) {
			// Check numbers
			req_gear_num = units;
			have_gear_num = 0;
			var i;
			i = -1;
			repeat (array_length(obj_controller.display_unit)) {
				i += 1;
				if ((vehicle_equipment != -1) && (obj_controller.man_sel[i] == 1) && (obj_controller.ma_gear[i] == n_gear)) {
					have_gear_num += 1;
				}
			}
			have_gear_num += scr_item_count(n_gear);

			if (have_gear_num >= req_gear_num || n_gear == ITEM_NAME_NONE) {
				n_good4 = 1;
			}
			if (have_gear_num < req_gear_num && (n_gear != ITEM_NAME_ANY && n_gear != ITEM_NAME_NONE)) {
				n_good4 = 0;
				warning = "Not enough " + string(n_gear) + "; " + string(units - req_gear_num) + " more are required.";
			}

			if ((n_gear != ITEM_NAME_NONE) && (n_gear != "") && (string_count("Dreadnought", n_armour) > 0)) {
				n_good4 = 0;
				warning = "Dreadnoughts may not use infantry equipment.";
			}
		}
		if ((equipmet_area == EquipmentSlot.MOBILITY) && (n_mobi != "Assortment") && (n_mobi != ITEM_NAME_NONE)) {
			// Check numbers
			req_mobi_num = units;
			have_mobi_num = 0;
			var i;
			i = -1;
			repeat (array_length(obj_controller.display_unit)) {
				i += 1;
				if ((vehicle_equipment != -1) && (obj_controller.man_sel[i] == 1) && (obj_controller.ma_mobi[i] == n_mobi)) {
					have_mobi_num += 1;
				}
			}
			have_mobi_num += scr_item_count(n_mobi);

			if (have_mobi_num >= req_mobi_num || n_mobi == ITEM_NAME_NONE) {
				n_good5 = 1;
			}
			if (have_mobi_num < req_mobi_num && (n_mobi != ITEM_NAME_ANY && n_mobi != ITEM_NAME_NONE)) {
				n_good5 = 0;
				warning = "Not enough " + string(n_mobi) + "; " + string(units - req_mobi_num) + " more are required.";
			}

			var terminator_mobi = ["", "Servo-arm", "Servo-harness", "Conversion Beamer Pack"];
			if ((!array_contains(terminator_mobi, n_mobi)) && ((n_armour == "Terminator Armour") || (n_armour == "Tartaros"))) {
				n_good5 = 0;
				warning = "Cannot use this gear with Terminator Armour.";
			}

			if ((n_mobi != ITEM_NAME_NONE) && (n_mobi != "") && (n_armour == "Dreadnought")) {
				n_good5 = 0;
				warning = string(obj_ini.role[100][6]) + "s may not use mobility gear.";
			}
		}
	}

	//draw_set_halign(fa_center);
	if ((equipmet_area == EquipmentSlot.WEAPON_ONE) || (equipmet_area == EquipmentSlot.WEAPON_TWO)) {
		range_melee_radio.draw();
	}
	quality_radio.draw();

	if (quality_radio.changed || range_melee_radio.changed){
		reload_items();
	}

	draw_set_color(255);
	draw_set_halign(fa_center);
	draw_text(1292, 476, string_hash_to_newline(warning));

	cancel_button.draw();

	var _valid = ((n_good1 + n_good2 + n_good3 + n_good4) == 4);

	if (reequip_selection){
			equip_button.draw(_valid);
	}
}


function reequip_selection(){
    if (n_wep1=ITEM_NAME_NONE) then n_wep1="";
    if (n_wep2=ITEM_NAME_NONE) then n_wep2="";
    if (n_armour=ITEM_NAME_NONE) then n_armour="";
    if (n_gear=ITEM_NAME_NONE) then n_gear="";
    if (n_mobi=ITEM_NAME_NONE) then n_mobi="";


    for (var i=0;i<array_length(obj_controller.display_unit);i++){

        var endcount=0;

        if (obj_controller.man[i]!="") and (obj_controller.man_sel[i]) and (vehicle_equipment!=-1){
            var check=0,scout_check=0;
            unit = obj_controller.display_unit[i];
            var standard = master_crafted==1?"master_crafted":"any";
            if (is_struct(unit)){
                unit.update_armour(n_armour, true, true, standard);
                unit.update_mobility_item(n_mobi, true, true, standard);
                unit.update_weapon_one(n_wep1, true, true, standard);
                unit.update_weapon_two(n_wep2, true, true, standard);
                unit.update_gear(n_gear, true, true, standard);

                update_man_manage_array(i);
                continue;
            } else if (is_array(unit)){

                // NOPE
                    if (check=0) and (n_armour!=obj_controller.ma_armour[i]) and (n_armour!="Assortment") and (vehicle_equipment!=1) and (vehicle_equipment!=6){ //vehicle wep3
                        if (obj_controller.ma_armour[i]!="") then scr_add_item(obj_controller.ma_armour[i],1);
                        obj_controller.ma_armour[i]="";
                        obj_ini.veh_wep3[unit[0],unit[1]]="";

                        if (n_armour!=ITEM_NAME_NONE) and (n_armour!=""){
                            obj_controller.ma_armour[i]=n_armour;
                            obj_ini.veh_wep3[unit[0],unit[1]]=n_armour;
                            if (n_armour!="") then scr_add_item(n_armour,-1);
                        }
                    }
                    check=0;
                    if (n_wep1=obj_controller.ma_wep1[i]) or (n_wep1="Assortment") then check=1;

                    if (check==0){
                        if (n_wep1!=obj_controller.ma_wep1[i])  and (n_wep1!="Assortment") and (vehicle_equipment!=1) and (vehicle_equipment!=6){ // vehicle wep1
                            if (obj_controller.ma_wep1[i]!="") and (obj_controller.ma_wep1[i]!=n_wep1){
                                scr_add_item(obj_controller.ma_wep1[i],1);
                                obj_controller.ma_wep1[i]="";
                                obj_ini.veh_wep1[unit[0],unit[1]]="";
                            }
                            if (n_wep1!=""){
                                scr_add_item(n_wep1,-1);
                                obj_controller.ma_wep1[i]=n_wep1;
                                obj_ini.veh_wep1[unit[0],unit[1]]=n_wep1;
                            }
                        }
                    }
                    // End swap weapon1

                    check=0;

                    if (n_wep2=obj_controller.ma_wep2[i]) or (n_wep2="Assortment") then check=1;

                    if (check==0) and (n_wep2!=obj_controller.ma_wep2[i]) and (n_wep2!="Assortment") and (vehicle_equipment!=1) and (vehicle_equipment!=6){ // vehicle wep2
                        if (obj_controller.ma_wep2[i]!="") and (obj_controller.ma_wep2[i]!=n_wep2){
                            scr_add_item(obj_controller.ma_wep2[i],1);
                            obj_controller.ma_wep2[i]="";
                            obj_ini.veh_wep2[unit[0],unit[1]]="";
                        }
                        if (n_wep2!=""){
                            scr_add_item(n_wep2,-1);
                            obj_controller.ma_wep2[i]=n_wep2;
                            obj_ini.veh_wep2[unit[0],unit[1]]=n_wep2;
                        }
                    }
                    // End swap weapon2

                    check=0;

                    if (check=0) and (n_gear!=obj_controller.ma_gear[i]) and (n_gear!="Assortment") and (vehicle_equipment!=1) and (vehicle_equipment!=6){ //vehicle upgrade item
                        if (obj_controller.ma_gear[i]!="") then scr_add_item(obj_controller.ma_gear[i],1);
                        obj_controller.ma_gear[i]="";
                        obj_ini.veh_upgrade[unit[0],unit[1]]="";
                        if (n_gear!=ITEM_NAME_NONE) and (n_gear!=""){
                            obj_controller.ma_gear[i]=n_gear;
                            obj_ini.veh_upgrade[unit[0],unit[1]]=n_gear;
                        }
                        if (n_gear!="") then scr_add_item(n_gear,-1);
                    }
                    // End gear and upgrade

                    check=0;
                    if (check=0) and (n_mobi!=obj_controller.ma_mobi[i]) and (n_mobi!="Assortment") and (vehicle_equipment!=1) and (vehicle_equipment!=6){ //vehicle accessory item
                        if (obj_controller.ma_mobi[i]!="") then scr_add_item(obj_controller.ma_mobi[i],1);
                        obj_controller.ma_mobi[i]="";
                        obj_ini.veh_acc[unit[0],unit[1]]="";
                        obj_controller.ma_mobi[i]=n_mobi;
                        obj_ini.veh_acc[unit[0],unit[1]]=n_mobi;
                        if (n_mobi!="") then scr_add_item(n_mobi,-1);
                    }
                    // End mobility and accessory

            }

        }// End that [i]

    }// End repeat

    obj_controller.cooldown=10;
    instance_destroy();exit;	
}

