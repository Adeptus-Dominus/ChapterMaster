
function scr_ui_manage() {
	if (combat!=0) then exit;
	// This is the draw script for showing the main management screen or individual company screens


    if (zoomed==0) and (menu==1) and (managing>=0) {
    	if((managing>0)){
    		company_manage_actions();
    	}
    	if (!text_bar){
    		ui_manage_hotkeys();
    	};
    }
    
	if (menu==1) and (managing>0 || managing <0){
		if (!mouse_check_button(mb_left)){
			drag_square=[];
			rectangle_action = -1;
		}		
		if (squad_sel_count>0){
			squad_sel_count--;
		}
		if (squad_sel_count==0){
			squad_sel=-1;
			squad_sel_action=-1;
		}
		if (man_size<1){
	        selecting_location="";
	        selecting_ship=-1;
	        selecting_planet=0;
	        man_size=0;
		}	
		var unit,x1,x2,y1,y2, var_text;
		var romanNumerals=scr_roman_numerals();	
		var tooltip_text="",bionic_tooltip="",tooltip_drawing=[];
			var invalid_locations = ["Mechanicus Vessel", "Terra"];

	    var xx=__view_get( e__VW.XView, 0 )+0, yy=__view_get( e__VW.YView, 0 )+0, bb="", img=0;

	    // Draw BG
	    draw_set_alpha(1);
	    draw_sprite(spr_rock_bg,0,xx,yy);
	    draw_set_font(fnt_40k_30b);
	    draw_set_halign(fa_center);
	    draw_set_color(c_gray);// 38144
    
		// Var declarations
	    var c=0,fx="",skin=obj_ini.skin_color;
		static stats_displayed = false;
		
		if (managing>0){
		    if (managing>20){
		    	c=managing-10;
		    }else if (managing >= 1) and (managing <=10) {
				fx= romanNumerals[managing - 1] + " Company";
				c=managing;
			} else if (managing>10) {
				switch(managing){
					case 11:
						fx="Headquarters"
						break;
					case 12:
						fx="Apothecarion";
						break;
					case 13:
						fx="Librarium";
						break;
					case 14:
						fx="Reclusium";
						break;
					case 15:
						fx="Armamentarium";
						break;
				}
			}
		// Draw the company followed by chapters name
	    	draw_text(xx+800,yy+74,string_hash_to_newline(string(fx)+", "+string(global.chapter_name)));			
		} else if (managing<0){
			if (struct_exists(selection_data, "purpose")){
				draw_text(xx+800,yy+74,$"{selection_data.purpose}");			
			}
		}
		
	    if (managing<=10 && managing>0){
	        var bar_wid=0,click_check, string_h;
	        draw_set_alpha(0.25);
	        if (obj_ini.company_title[managing]!="") then bar_wid=max(400,string_width(obj_ini.company_title[managing]));
	        if (obj_ini.company_title[managing]="") then bar_wid=400;
        	string_h = string_height(string_hash_to_newline("LOL"));
	        draw_rectangle(xx+800-(bar_wid/2),yy+108,xx+800+(bar_wid/2),yy+100+string_h,1);
	        click_check = scr_hit(xx+800-(bar_wid/2),yy+108,xx+800+(bar_wid/2),yy+100+string_h);
	        obj_cursor.image_index=0;
	        if (!click_check) and (mouse_left==1) and (!cooldown){
	         text_bar=false;
	        }else if(click_check){
	            obj_cursor.image_index=2;

	            if (!cooldown) and (mouse_left==1) and (!text_bar){
	                cooldown=8000;
	                text_bar=true;
	                keyboard_string=obj_ini.company_title[managing];
	            }
            
	        }
	        draw_set_alpha(1);
        
	        if (obj_ini.company_title[managing]!="") or (text_bar>0){
	        	draw_set_font(fnt_fancy);
	            if (text_bar=0) or (text_bar>31) then draw_text(xx+800,yy+110,$"''{obj_ini.company_title[managing]} {(text_bar>0 && text_bar<=31)?"|":""}'' ");
	        }
	    }
    
	    // var we;we=string_width(string(global.chapter_name)+" "+string(fx))/2;
    	
    	if (managing>0){
			// Draw arrows
		    draw_sprite_ext(spr_arrow,0,xx+25,yy+70,2,2,0,c_white,1);// Back
		    draw_sprite_ext(spr_arrow,0,xx+429,yy+70,2,2,0,c_white,1);// Left
		    draw_sprite_ext(spr_arrow,1,xx+1110,yy+70,2,2,0,c_white,1);// Right
	    } else {
			scr_manage_task_selector();
	    }
		var right_ui_block = {
			x1: xx + 1008,
			y1: yy + 141,
			w: 568,
			h: 681,
		};
		right_ui_block.x2 = right_ui_block.x1 + right_ui_block.w;
		right_ui_block.y2 = right_ui_block.y1 + right_ui_block.h;

		var actions_block = {
			x1: right_ui_block.x1,
			y1: yy + 520,
			w: 569,
			h: 302,
		};
		actions_block.x2 = actions_block.x1 + actions_block.w;
		actions_block.y2 = actions_block.y1 + actions_block.h;

		draw_sprite_stretched(spr_data_slate_back, 0, actions_block.x1, actions_block.y1, actions_block.w, actions_block.h);
		draw_rectangle_color_simple(actions_block.x1, actions_block.y1, actions_block.x2, actions_block.y2, 1, c_gray);
		draw_rectangle_color_simple(actions_block.x1 + 1, actions_block.y1 + 1, actions_block.x2 - 1, actions_block.y2 - 1, 1, c_black);
		draw_rectangle_color_simple(actions_block.x1 + 2, actions_block.y1 + 2, actions_block.x2 - 2, actions_block.y2 - 2, 1, c_gray);

		//TODO remove if no longer needed
		/*var unit_view_block = {
			x1: right_ui_block.x1,
			y1: yy + 140,
			w: 571,
			h: 380,
		};
		unit_view_block.x2 = unit_view_block.x1 + unit_view_block.w;
		unit_view_block.y2 = unit_view_block.y1 + unit_view_block.h;*/

		draw_set_color(c_white);
		draw_sprite_stretched(spr_data_slate_back, 0, xx+1007-1, yy+140, 572, 378);
		draw_sprite_stretched(spr_data_slate_border, 0, xx+1007-1, yy+140, 572, 378);
		// draw_rectangle_color_simple(xx+1007, yy+140, xx+1579, yy+519, 0, c_white, 0.05);
		draw_rectangle_color_simple(xx+1007, yy+140, xx+1579, yy+519, 0, 5998382, 0.05);
		// Swap between squad view and normal view
	    draw_set_color(c_gray);
	    // draw_line(xx+1005,yy+519,xx+1576,yy+519);
	    draw_set_font(fnt_40k_14b);
	    var cn=obj_controller;
	    if (instance_exists(cn)) and (is_struct(temp[120])){
	    	var selected_unit = temp[120];				//unit struct
	    	///tooltip_text stacks hover over type tooltips into an array and draws them last so as not to create drawing order issues
		    draw_set_color(c_red);
			var no_other_instances =  !instance_exists(obj_temp3) && !instance_exists(obj_popup);
		    var stat_tool_tip_text;
			var button_coords;
		    if (!obj_controller.view_squad && !obj_controller.company_report){
			    stat_tool_tip_text = "Squad View";
			} else {
				stat_tool_tip_text = "Company View"; 
			}
		    var x5=right_ui_block.x1+15;//this should be relational with the unit area tab
			var y5=right_ui_block.y1+8;
			var x6=x5+string_width("Company View")+8;
			var y6=y5+string_height("Company View")+2;
			button_coords = draw_unit_buttons([x5, y5, x6, y6], stat_tool_tip_text,[1,1],#50a076);
			if (managing>0 && managing<11){
				array_push(tooltip_drawing, ["Click here or press S to toggle Squad View.", [x5,y5,x6,y6]]);
				if ((point_in_rectangle(mouse_x, mouse_y,x5,y5,x6,y6) && mouse_check_button_pressed(mb_left)) || (keyboard_check_pressed(ord("S")) && !text_bar)){
					obj_controller.view_squad = !obj_controller.view_squad;
					if (stat_tool_tip_text=="Squad View"){
						obj_controller.company_data = new CompanyStruct(obj_controller.managing);
						obj_controller.unit_profile = true;
					} else {
						obj_controller.unit_profile = false;
					}
				}	
			} else{
				draw_set_alpha(0.5);
				draw_set_color(c_black);
				draw_rectangle(x5, y5, x6, y6, 0);
				draw_set_alpha(1);
			}
			if (!view_squad){
				if (!unit_profile){
					stat_tool_tip_text = "Show Profile";
				} else {
					stat_tool_tip_text = "Hide Profile"; 
				}
				x5=x6+4;
				x6=x5+string_width("Show Profile")+8;
				array_push(tooltip_drawing, ["Click here or press P to show unit profile.", [x5,y5,x6,y6]]);
				button_coords = draw_unit_buttons([x5, y5, x6, y6], stat_tool_tip_text,[1,1],#50a076)
				if (((keyboard_check_pressed(ord("P"))&& !text_bar)|| (point_and_click(button_coords))) && no_other_instances){
					unit_profile = !unit_profile;
				}
				x5=x6+4;
			}
		
		    if (unit_profile && !view_squad){
				if (!unit_bio){
					stat_tool_tip_text = "Show Bio"
				} else {
					stat_tool_tip_text = "Hide Bio"; 
				}
				x6=x5+string_width("Hide Bio")+8;
				button_coords = draw_unit_buttons([x5, y5, x6, y6], stat_tool_tip_text,[1,1],#50a076);
				array_push(tooltip_drawing, ["Click here or press B to Toggle Unit Biography.", button_coords]);
				if (((keyboard_check_pressed(ord("B"))&& !text_bar)|| (point_and_click(button_coords))) && no_other_instances){
					unit_bio = !unit_bio;
				}
		    }


			if (managing<0 && selection_data.purpose_code!="manage") then unit_profile=true;
			//TODO Implement company report
			/*var x6=x5+string_width(stat_tool_tip_text)+4;
			var y6=y5+string_height(stat_tool_tip_text)+2;	    
		    draw_unit_buttons([x5,y5,x6,y6], stat_tool_tip_text,[1,1],c_red);
		    if (company_data!={}){
    		    array_push(tooltip_drawing, ["click or press R to show Company Report", [x5,y5,x6,y6]]);
    			if ((keyboard_check_pressed(ord("R"))|| (point_in_rectangle(mouse_x, mouse_y,x5,y5,x6,y6) && mouse_check_button_pressed(mb_left))) && !instance_exists(obj_temp3) && !instance_exists(obj_popup)){
    				view_squad =false;
    				unit_profile=false;
    				company_report = !company_report;
    			}
    		}else{
				draw_set_alpha(0.5);
				draw_set_color(c_black);
				draw_rectangle(x5,y5,x6,y6,0);
				draw_set_alpha(1);
			}
			*/			    

			// Draw unit image
			draw_set_color(c_white);
			if (is_struct(temp[121])){
				temp[121].draw(xx+1208, yy+240)
			}

			//TODO implement tooltip explaining potential loyalty hit of demoting a sgt
			if (view_squad &&  company_data!={}){
				if (company_data.cur_squad!=0){
					var cur_squad = company_data.grab_current_squad();
					var sgt_possible = cur_squad.type!="command_squad" && !selected_unit.IsSpecialist("squad_leaders");
					if (selected_unit != cur_squad.squad_leader){
						if (point_and_click(draw_unit_buttons([xx+1208+50,yy+210+260], "Make Sgt", [1,1],#50a076,,,sgt_possible?1:0.5)) && sgt_possible){
							cur_squad.change_sgt(selected_unit);
						}
					}
				}
			}

			// Unit window entries start
			var line_color = #50a076;
			draw_set_color(line_color);

			// Draw unit name and role
			draw_set_halign(fa_center);
			draw_set_font(fnt_40k_30b);
			draw_text_transformed_outline(xx+1290,yy+177,string_hash_to_newline(selected_unit.name_role()),0.7,0.7,0);

			// Draw unit info
			draw_set_font(fnt_40k_14);
			// Left side of the screen
			draw_set_halign(fa_left);
			var x_left = xx+1030;

			// Equipment
        	var armour = selected_unit.armour();
	        if (armour!=""){
				var_text= string_hash_to_newline(selected_unit.equipments_qual_string("armour", true));
                tooltip_text = cn.temp[103];
	        	x1 = x_left;
	        	y1 = yy+216;
	        	x2 = x1+string_width_ext(var_text, -1,187);
	        	y2 = y1+string_height_ext(var_text, -1,187);
				draw_set_alpha(1);
	        	draw_text_ext_outline(x1,y1,var_text,-1,187, 0, quality_color(selected_unit.armour_quality));
	        	array_push(tooltip_drawing, [tooltip_text, [x1,y1,x2,y2]]); 
	        } 

	        var gear = selected_unit.gear();
	        if (selected_unit.gear()!=""){
				var_text= string_hash_to_newline(selected_unit.equipments_qual_string("gear", true));
	        	tooltip_text = cn.temp[105];
	        	x1 = x_left;
	        	y1 = yy+260;
	        	x2 = x1+string_width_ext(var_text, -1,187);
	        	y2 = y1+string_height_ext(var_text, -1,187);	 
	        	draw_text_ext_outline(x1,y1,var_text,-1,187, 0, quality_color(selected_unit.gear_quality));
	        	array_push(tooltip_drawing, [tooltip_text, [x1,y1,x2,y2]]);
	        }

	        var mobi = selected_unit.mobility_item();
	        if (mobi!=""){
				var_text= string_hash_to_newline(selected_unit.equipments_qual_string("mobi", true));
	        	tooltip_text = cn.temp[107];
	        	x1 = x_left;
	        	y1 = yy+304;
	        	x2 = x1+string_width_ext(var_text, -1,187);
	        	y2 = y1+string_height_ext(var_text, -1,187);	  
	        	draw_text_ext_outline(x1,y1,var_text,-1,187, 0, quality_color(selected_unit.mobility_item_quality));
	        	array_push(tooltip_drawing, [tooltip_text, [x1,y1,x2,y2]]);
	        }

			// Stats
    		var_text = string_hash_to_newline(string("Bionics: {0}",selected_unit.bionics));
        	x1 = x_left;
        	y1 = yy+444;
        	x2 = x1+string_width(var_text);
        	y2 = y1+string_height(var_text);
	        draw_text_outline(x1,y1,var_text);
			var _body_parts = ARR_body_parts;
			var _body_parts_display = ARR_body_parts_display;
	        for (var part = 0; part<array_length(_body_parts);part++){
				if (struct_exists(selected_unit.body[$ _body_parts[part]], "bionic")){
					var part_display = _body_parts_display[part];
					bionic_tooltip += $"Bionic {part_display}";
					switch (part_display) {
						case "Left Leg":
						case "Right Leg":
							bionic_tooltip += $" (CON: +2 STR: +1 DEX: -2)#";
							break;
						case "Left Eye":
						case "Right Eye":
							bionic_tooltip += $" (CON: +1 WIS: +1 DEX: +1)#";
							break;
						case "Left Arm":
						case "Right Arm":
							bionic_tooltip += $" (CON: +2 STR: +2 WS: -1)#";
							break;
						case "Torso":
							bionic_tooltip += $" (CON: +4 STR: +1 DEX: -1)#";
							break;
						case "Throat":
							bionic_tooltip += $" (CHA: -1)#";
							break;
						case "Jaw":
						case "Head":
							bionic_tooltip += $" (CON: +1)#";
							break;
					}
				}				
			}
	        if (bionic_tooltip !=""){
	        	array_push(tooltip_drawing, [bionic_tooltip, [x1,y1,x2,y2]]);
	    	} else{
	    		array_push(tooltip_drawing, ["No Bionic Augmentations", [x1,y1,x2,y2]]);
	    	}

        var_text = string_hash_to_newline($"Armour Rating: {selected_unit.armour_calc()}")
          var tooltip_text = "";
          var equipment_types = ["armour", "weapon_one", "weapon_two", "mobility", "gear"];
          for (var i = 0; i < array_length(equipment_types); i++) {
            var equipment_type = equipment_types[i];
            var ac = 0;
            var name = "";
            switch(equipment_type) {
                case "armour":
                    ac = selected_unit.get_armour_data("armour_value");
                    name = selected_unit.get_armour_data("name");
                    break;
                case "weapon_one":
                    ac = selected_unit.get_weapon_one_data("armour_value");
                    name = selected_unit.get_weapon_one_data("name");
                    break;
                case "weapon_two":
                    ac = selected_unit.get_weapon_two_data("armour_value");
                    name = selected_unit.get_weapon_two_data("name");
                    break;
                case "mobility":
                    ac = selected_unit.get_mobility_data("armour_value");
                    name = selected_unit.get_mobility_data("name");
                    break;
                case "gear":
                    ac = selected_unit.get_gear_data("armour_value");
                    name = selected_unit.get_gear_data("name");
                    break;
            }
            if (ac != 0) {
                tooltip_text += string_hash_to_newline($"{name}: {ac}#");
            }
          }
			if (obj_controller.stc_bonus[1] == 5 || obj_controller.stc_bonus[2] == 3){
                tooltip_text += string_hash_to_newline($"STC Bonus: x1.05#");
			}
        	x1 = x_left;
        	y1 = yy+400;
        	x2 = x1+string_width(var_text);
        	y2 = y1+string_height(var_text);
	        draw_text_outline(x1,y1,var_text);
	        array_push(tooltip_drawing, [tooltip_text, [x1,y1,x2,y2]]); 

    		var_text = string_hash_to_newline($"Health: {round(selected_unit.hp())}/{round(selected_unit.max_health())}")
        	tooltip_text = string_hash_to_newline(string("CON: {0}#", round(100*(1+((selected_unit.constitution-40)*0.025)))));
            for (var i = 0; i < array_length(equipment_types); i++) {
                var equipment_type = equipment_types[i];
                var hp_mod = 0;
                var name = "";
                switch(equipment_type) {
                    case "armour":
                        hp_mod = selected_unit.get_armour_data("hp_mod");
                        name = selected_unit.get_armour_data("name");
                        break;
                    case "weapon_one":
                        hp_mod = selected_unit.get_weapon_one_data("hp_mod");
                        name = selected_unit.get_weapon_one_data("name");
                        break;
                    case "weapon_two":
                        hp_mod = selected_unit.get_weapon_two_data("hp_mod");
                        name = selected_unit.get_weapon_two_data("name");
                        break;
                    case "mobility":
                        hp_mod = selected_unit.get_mobility_data("hp_mod");
                        name = selected_unit.get_mobility_data("name");
                        break;
                    case "gear":
                        hp_mod = selected_unit.get_gear_data("hp_mod");
                        name = selected_unit.get_gear_data("name");
                        break;
                }
                if (hp_mod != 0) {
                    tooltip_text += string_hash_to_newline($"{name}: {format_number_with_sign(hp_mod)}%#");
                }
            }
        	x1 = x_left;
        	y1 = yy+422;
        	x2 = x1+string_width(var_text);
        	y2 = y1+string_height(var_text);
	        draw_text_outline(x1,y1,var_text);
	        array_push(tooltip_drawing, [tooltip_text, [x1,y1,x2,y2]]); 

	        if (cn.temp[113]!="") then draw_text_outline(x_left, yy+466, string_hash_to_newline($"Experience: {cn.temp[113]}"));

       
        		 
        	if (cn.temp[118]!=""){
						tooltip_text = "";
						for (var i = 0; i < array_length(equipment_types); i++){
							var equipment_type = equipment_types[i];
							var dr = 0;
							var name = "";
							switch(equipment_type) {
									case "armour":
											dr = selected_unit.get_armour_data("damage_resistance_mod");
											name = selected_unit.get_armour_data("name");
											break;
									case "weapon_one":
											dr = selected_unit.get_weapon_one_data("damage_resistance_mod");
											name = selected_unit.get_weapon_one_data("name");
											break;
									case "weapon_two":
											dr = selected_unit.get_weapon_two_data("damage_resistance_mod");
											name = selected_unit.get_weapon_two_data("name");
											break;
									case "mobility":
											dr = selected_unit.get_mobility_data("damage_resistance_mod");
											name = selected_unit.get_mobility_data("name");
											break;
									case "gear":
											dr = selected_unit.get_gear_data("damage_resistance_mod");
											name = selected_unit.get_gear_data("name");
											break;
							}
							if (dr != 0) {
									tooltip_text += string_hash_to_newline($"{name}: {dr}%#");
							}
						}
        		var_text = string_hash_to_newline(string("Damage Resistance: {0}",cn.temp[118]))
	        	tooltip_text += string_hash_to_newline(string("CON: {0}%#EXP: {1}%", round(selected_unit.constitution/2), round(selected_unit.experience/10)));
	        	x1 = x_left;
	        	y1 = yy+378;
	        	x2 = x1+string_width(var_text);
	        	y2 = y1+string_height(var_text);
		        draw_text_outline(x1,y1,var_text);
		        array_push(tooltip_drawing, [tooltip_text, [x1,y1,x2,y2]]);
	    	}

	        if (cn.temp[119]!="") then draw_text_outline(x_left,yy+488,cn.temp[119]);

		// Right side of the screen
		draw_set_halign(fa_right);
		var x_right = xx+1576-24;

		// Equipment
		var wep1= selected_unit.weapon_one();
		if (wep1!=""){
			var_text= string_hash_to_newline(selected_unit.equipments_qual_string("wep1", true));
			tooltip_text = cn.temp[109];
			x1 = x_right;
			y1 = yy+216;
			x2 = x1-string_width_ext(var_text, -1,187);
			y2 = y1+string_height_ext(var_text, -1,187);	 	 
			draw_text_ext_outline(x1,y1,var_text,-1,187, 0, quality_color(selected_unit.weapon_one_quality));
			array_push(tooltip_drawing, [tooltip_text, [x2,y1,x1,y2]]);
		}
	
		var wep2 = selected_unit.weapon_two();
		if (wep2!=""){
			var_text= string_hash_to_newline(selected_unit.equipments_qual_string("wep2", true));
			tooltip_text = cn.temp[111];
			x1 = x_right;
			y1 = yy+260;
			x2 = x1-string_width_ext(var_text, -1,187);
			y2 = y1+string_height_ext(var_text, -1,187);	 
			draw_text_ext_outline(x1,y1,var_text,-1,187, 0, quality_color(selected_unit.weapon_two_quality)); 
			array_push(tooltip_drawing, [tooltip_text, [x2,y1,x1,y2]]);
		}

		// Stats
		if (is_array(cn.temp[117])){
			var_text = string_hash_to_newline(string("Melee Attack: {0}",round(cn.temp[116][0])))
			tooltip_text = string_hash_to_newline(string(cn.temp[116][1]));
			x1 = x_right;
			y1 = yy+378;
			x2 = x1-string_width(var_text);
			y2 = y1+string_height(var_text);
			if (selected_unit.encumbered_melee){
				draw_set_color(#bf4040);
				//tooltip_text+="#encumbered"
			}
			draw_text_outline(x1,y1,var_text);
			draw_set_color(line_color);
			array_push(tooltip_drawing, [tooltip_text, [x2,y1,x1,y2]]);
		}

		if (is_array(cn.temp[117])){
			var_text = string_hash_to_newline(string("Ranged Attack: {0}",round(cn.temp[117][0])))
			tooltip_text = string_hash_to_newline(string(cn.temp[117][1]));
			x1 = x_right;
			y1 = yy+400;
			x2 = x1-string_width(var_text);
			y2 = y1+string_height(var_text);
			if (selected_unit.encumbered_ranged){
				draw_set_color(#bf4040);
			}
			draw_text_outline(x1,y1,var_text);
			array_push(tooltip_drawing, [tooltip_text, [x2,y1,x1,y2]]);
			draw_set_color(line_color);
		}

		if (is_array(cn.temp[116])){
			carry_data = cn.temp[116][2];
			var carry_string = $"Melee Burden: {carry_data[0]}/{carry_data[1]}"
			x1 = x_right;
			y1 = yy+444;
			x2 = x1-string_width(carry_string);
			y2 = y1+string_height(carry_string);
			if (selected_unit.encumbered_melee){
				draw_set_color(#bf4040);
			}
			draw_text_outline(x1,y1,string_hash_to_newline(carry_string));
			tooltip_text = string_hash_to_newline(carry_data[2]);
			array_push(tooltip_drawing, [tooltip_text, [x2,y1,x1,y2]]);
			draw_set_color(line_color);
		}

		if (is_array(cn.temp[117])){
			carry_data = cn.temp[117][2];
			var carry_string = $"Ranged Burden: {carry_data[0]}/{carry_data[1]}"
			x1 = x_right;
			y1 = yy+466;
			x2 = x1-string_width(carry_string);
			y2 = y1+string_height(carry_string);
			if (selected_unit.encumbered_ranged){
				draw_set_color(#bf4040);
			}
			draw_text_outline(x1,y1,string_hash_to_newline(carry_string));
			tooltip_text = string_hash_to_newline(carry_data[2]);
			array_push(tooltip_drawing, [tooltip_text, [x2,y1,x1,y2]]);
			draw_set_color(line_color);
		}

		// Animated scanline
		draw_animated_scanline(xx+1007+18, yy+140+4, 530, 368);
	}	

	    draw_set_font(fnt_40k_14);draw_set_halign(fa_left);

	    // Back
	    var top=man_current,sel=top,temp1="",temp2="",temp3="",temp4="",temp5="";
    
		// Var creation
	    var ma_ar="",ma_we1="",ma_we2="",ma_ge="",ma_mb="",ttt=0;
	    var ar_ar=0,ar_we1=0,ar_we2=0,ar_ge=0,ar_mb=0,eventing=false;
	        
	    yy+=77;
		
	    var unit_specialism_option=false, spec_tip="";
	    //TODO store these in global tooltip storage
		potential_tooltip=[];
		health_tooltip=[];
		promotion_tooltip=[];
		var repetitions=min(man_max,man_see);

		//tooltip text to tell you if a unit is eligible for special roles
	    
	    if (!obj_controller.view_squad){
	        man_count = 0;
	        if (managing>0 && managing<=10){
		        var cap_slot=company_data.captain!="none";
		        var champ_slot=company_data.champion!="none";
		        var ancient_slot=company_data.ancient!="none";
	    	}
		    for(var i=0; i<repetitions;i++){
		    	if (managing>0 && managing<=10 && (!cap_slot || !champ_slot || !ancient_slot)){
		    		if (!cap_slot){
		    			draw_set_color(c_black);
		    			draw_rectangle(xx+25,yy+64,xx+974,yy+85,0);
						draw_set_color(c_gray);
						draw_rectangle(xx+25,yy+64,xx+974,yy+85,1);	
						draw_set_halign(fa_center); 
						draw_set_color(c_yellow);
						draw_text(xx+500,yy+66,"++New Captain Required++")
						draw_set_halign(fa_left);
						draw_set_color(c_gray);
						if (point_and_click([xx+25,yy+64,xx+974,yy+85])){
							var candidates = collect_role_group("captain_candidates");
							group_selection(candidates,{
								purpose:$"{scr_roman_numerals()[managing-1]} Company Captain Candidates",
								purpose_code : "captain_promote",
								number:1,
								system:managing,
								feature:"none",
								planet : 0,
								selections : [],
							});
							exit;						
						}
						yy+=20;
						cap_slot=true;
						continue;
		    		}
		    		if (!champ_slot){
		    			draw_set_color(c_black);
		    			draw_rectangle(xx+25,yy+64,xx+974,yy+85,0);
						draw_set_color(c_gray);
						draw_rectangle(xx+25,yy+64,xx+974,yy+85,1);	
						draw_set_halign(fa_center); 
						draw_set_color(c_yellow);
						draw_text(xx+500,yy+66,"++New Champion Required++")
						draw_set_halign(fa_left);
						draw_set_color(c_gray);
						if (point_and_click([xx+25,yy+64,xx+974,yy+85])){
							var search_params = {
								companies:managing,
								"stat":[["weapon_skill", 44, "more"]]
							};
							var candidates = collect_role_group("standard", "", true,search_params);
							group_selection(candidates,{
								purpose:$"{scr_roman_numerals()[managing-1]} Champion Candidates",
								purpose_code : "champion_promote",
								number:1,
								system:managing,
								feature:"none",
								planet : 0,
								selections : [],
							});
							exit;						
						}
						yy+=20;
						champ_slot=true;
						continue;
		    		}
		    		if (!ancient_slot){
		    			draw_set_color(c_black);
		    			draw_rectangle(xx+25,yy+64,xx+974,yy+85,0);
						draw_set_color(c_gray);
						draw_rectangle(xx+25,yy+64,xx+974,yy+85,1);	
						draw_set_halign(fa_center); 
						draw_set_color(c_yellow);
						draw_text(xx+500,yy+66,"++New Ancient Required++")
						draw_set_halign(fa_left);
						draw_set_color(c_gray);
						if (point_and_click([xx+25,yy+64,xx+974,yy+85])){
							var search_params = {
								companies:managing,
							};							
							var candidates = collect_role_group("standard", "", true,search_params);
							group_selection(candidates,{
								purpose:$"{scr_roman_numerals()[managing-1]} Company Ancient Candidates",
								purpose_code : "ancient_promote",
								number:1,
								system:managing,
								feature:"none",
								planet : 0,
								selections : [],
							});
							exit;						
						}
						yy+=20;
						ancient_slot=true;
						continue;
		    		}		    				    		
		    	}
		    	if (sel>=array_length(display_unit)) then break;
		    	while (man[sel]=="hide") and (sel<array_length(display_unit)-1){
		    		sel+=1;
		    	}
		    	if (scr_draw_management_unit(sel, yy, xx) == "continue"){
		    		sel++
		    		i--;
		    		continue;
		    	}
		    	if (i==0){
		    		if (point_in_rectangle(mouse_x, mouse_y,xx+25+8,yy+64,xx+974,yy+85) && mouse_check_button(mb_left)){
		    			man_current = man_current >0 ?man_current-1:0;
		    		}
		    	} else if (i==repetitions-1){
		    		if (point_in_rectangle(mouse_x, mouse_y,xx+25+8,yy+64,xx+974,yy+85) && mouse_check_button(mb_left)){
		    			man_current = man_current<man_max-man_see ? man_current+1 : man_current=(man_max-man_see);
		    			man_current++;
		    		}
		    	}

		        yy+=20;
		        sel+=1;
		    }
		    if (sel_all!="" || squad_sel_count>0){
		    	for(var i=0; i<top;i++){
		    		scr_draw_management_unit(i, yy, xx, false);
		    	}
		    	for(var i=sel; i<array_length(display_unit);i++){
		    		scr_draw_management_unit(i, yy, xx, false);
		    	}		    	
		    }
		    sel_all = "";

		    draw_set_color(c_black);
		    xx=__view_get( e__VW.XView, 0 )+0;yy=__view_get( e__VW.YView, 0 )+0;
		    draw_rectangle(xx+974,yy+165,xx+1005,yy+822,0);
		    draw_set_color(c_gray);
		    draw_rectangle(xx+974,yy+165,xx+1005,yy+822,1);

			// Squad outline
		    draw_rectangle(xx+25,yy+142,xx+14+8,yy+822,1);
		    // draw_rectangle(xx+577,yy+64,xx+600,yy+85,1);
		    // draw_rectangle(xx+577,yy+379,xx+600,yy+400,1);

		    draw_set_color(0);
		    draw_rectangle(xx+974,yy+141,xx+1005,yy+172,0);
		    draw_rectangle(xx+974,yy+790,xx+1005,yy+822,0);
		    draw_set_color(c_gray);
		    draw_rectangle(xx+974,yy+141,xx+1005,yy+172,1);
		    draw_rectangle(xx+974,yy+790,xx+1005,yy+822,1);

		    draw_sprite_stretched(spr_arrow,2,xx+974,yy+141,31,30);
		    draw_sprite_stretched(spr_arrow,3,xx+974,yy+791,31,30);

		    /*
		    draw_set_color(c_black);draw_rectangle(xx+25,yy+400,xx+600,yy+417,0);
		    draw_set_color(38144);draw_rectangle(xx+25,yy+400,xx+600,yy+417,1);
		    draw_line(xx+160,yy+400,xx+160,yy+417);
		    draw_line(xx+304,yy+400,xx+304,yy+417);
		    draw_line(xx+448,yy+400,xx+448,yy+417);

		    draw_set_font(fnt_menu);
		    draw_set_halign(fa_center);
		    */
			
		    yy+=8;
		     //TODO handle recursively
		    if (!obj_controller.unit_profile) && (!stats_displayed){
		    	var sel_loading=obj_controller.selecting_ship;
			    //draws hover over tooltips
				function gen_tooltip(tooltip_array) {
					for (var i = 0; i < array_length(tooltip_array); i++) {
						var tooltip = tooltip_array[i];
						if (point_in_rectangle(mouse_x, mouse_y, tooltip[1][0], tooltip[1][1], tooltip[1][2], tooltip[1][3])) {
							tooltip_draw(tooltip[0]);
						}
					}
				}
				gen_tooltip(potential_tooltip);
				gen_tooltip(promotion_tooltip);
				gen_tooltip(health_tooltip);

				// Draw interaction and selection buttons
				yy-=8;
				draw_set_font(fnt_40k_14b);
				draw_set_color(#50a076);
				var button = new UnitButtonObject();
				
				button.x1 = right_ui_block.x1+26;
				button.y1 = right_ui_block.y2-6-30;
				button.x2 = button.x1 + button.w;
				button.y2 = button.y1 + button.h;
				// Load/Unload to ship button
				button.label = "Load";
				var load_unload_possible = man_size>0;
				
				button.keystroke = (keyboard_check(vk_shift) && (keyboard_check_pressed(ord("L"))));
				button.tooltip = "Press Shift L";
				if (load_unload_possible){
					button.alpha = 1;
					if (sel_loading==-1){
						if (button.draw()){
							load_selection();						
						}
					} else if (sel_loading!=-1){
						button.label = "Unload";
						if (button.draw()){
							unload_selection();   // Unload - ask for planet confirmation					
						}				
					}
				} else {
					button.alpha = 0.5;
					button.draw(false);
				}

				button.move("right", true);

				// // Re equip button
				button.label = "Re-equip";
				var equip_possible=!array_contains(invalid_locations, selecting_location) && 
								man_size>0;

				button.alpha = equip_possible? 1 : 0.5;
				button.keystroke = (keyboard_check(vk_shift) && (keyboard_check_pressed(ord("E"))));
				button.tooltip = "Press Shift E";

				if (button.draw() && equip_possible){
					equip_selection();
				}
				
				button.move("right");

				// // Promote button
				button.label = "Promote";

				button.keystroke = (keyboard_check(vk_shift) && (keyboard_check_pressed(ord("P"))));
				button.tooltip = "Press Shift P";

				var promote_possible = sel_promoting > 0 && !array_contains(invalid_locations, selecting_location) && man_size>0;
				button.alpha = promote_possible? 1 : 0.5;
				if (button.draw()){
					if (promote_possible){
		                if (sel_promoting==1) and (instance_number(obj_popup)==0){
		                    var pip=instance_create(0,0,obj_popup);
		                    pip.type=5;
		                    pip.company=managing;

		                    var god=0,nuuum=0;
		                    for(var f=0; f<array_length(display_unit); f++){
		                        if ((ma_promote[f]>=1 || is_specialist(ma_role[f], "rank_and_file")  || is_specialist(ma_role[f], "squad_leaders")) && man_sel[f]==1){
		                            nuuum+=1;
		                            if (pip.min_exp==0) then pip.min_exp=ma_exp[f];
		                            pip.min_exp=min(ma_exp[f],pip.min_exp);
		                        }
		                        if (god==0) and (ma_promote[f]>=1) and (man_sel[f]==1){
		                            god=1;
		                            pip.unit_role=ma_role[f];
		                        }
		                    }
		                    if (nuuum>1) then pip.unit_role="Marines";
		                    pip.units=nuuum;
		                }						
					}
				}
				button.move("right", true);

				// // Put in jail button
				button.label = "Jail";
				button.keystroke = (keyboard_check(vk_shift) && (keyboard_check_pressed(ord("J"))));
				button.tooltip = "Press Shift J";	

				var jail_possible = man_size>0;
				button.alpha =  jail_possible ? 1 : 0.5;
				if (button.draw()){
					if (jail_possible) then jail_selection();
				}
				button.x1 += button.w + button.h_gap;
				button.x2 += button.w + button.h_gap;
				// // Add bionics button
				button.label = "Add Bionics";
				button.keystroke = (keyboard_check(vk_shift) && (keyboard_check_pressed(ord("B"))));
				button.tooltip = "Press Shift B";				
				var bionics_possible = man_size>0;
				button.alpha = bionics_possible ? 1 : 0.5;
				if (button.draw()){
					if (bionics_possible) then add_bionics_selection();
				}

				button.move("up", true);

				button.move("left", true, 4)


				// // Designate as boarder unit
				button.label = "Set Boarder";
				button.keystroke = (keyboard_check(vk_shift) && (keyboard_check_pressed(ord("Q"))));
				button.tooltip = "Press Shift Q";					
				var boarder_possible = sel_loading!=-1  && man_size>0;
				button.alpha = boarder_possible ? 1 : 0.5;
				if (button.draw() && boarder_possible){
					if (boarder_possible) then toggle_selection_borders();
				}
				button.move("right", true);

				// // Reset changes button
				button.label = "Reset";
				button.keystroke = (keyboard_check(vk_shift) && (keyboard_check_pressed(ord("R"))));
				button.tooltip = "Press Shift R";					
				var reset_possible = !array_contains(invalid_locations, selecting_location) && man_size>0;
				if reset_possible{
					button.alpha = 1;
					if (button.draw()){
						reset_selection_equipment();
					}
				} else {
					button.alpha = 0.5;
					button.draw(false);
				}

				button.move("right", true);

				// // Transfer to another company button
				button.label = "Transfer";
				button.keystroke = (keyboard_check(vk_shift) && (keyboard_check_pressed(ord("T"))));
				button.tooltip = "Press Shift T";				
				var transfer_possible = !array_contains(invalid_locations, selecting_location) && man_size>0;
				if (transfer_possible){
					button.alpha = 1;
					if (button.draw()){
						transfer_selection();
					}
				} else {
					button.alpha = 0.5;
					button.draw(false);
				}

				button.move("right", true);
				button.label = "Move Ship";
				button.keystroke = (keyboard_check(vk_shift) && (keyboard_check_pressed(ord("M"))));
				button.tooltip = "Press Shift M";					
				var moveship_possible = !array_contains(invalid_locations, selecting_location) && man_size>0 && selecting_ship>-1;	
				if (moveship_possible){
					button.alpha = 1;
					if (button.draw()){
						load_selection();
					}
				} else {
					button.alpha = 0.5;
					button.draw(false);
				}


				button.move("right", true);

				button.label = "Add Tag";
				button.keystroke = (keyboard_check(vk_shift) && (keyboard_check_pressed(ord("F"))));
				button.tooltip = "Coming soon"//Press Shift F";					
				tag_possible = man_size>0;
				tag_possible = false;
				button.alpha = 0.5;
				if (tag_possible){
					button.alpha = 1;
					if (button.draw()){
						load_selection();
					}
				} else {
					button.alpha = 0.5;
					button.draw(false);
				}

				if (sel_uni[1] != "") {
					// How much space the selected unit takes
					draw_set_font(fnt_40k_30b);
					draw_text_transformed(actions_block.x1 + 26, actions_block.y1 + 6,$"Selection: {man_size} space",0.5,0.5,0);
					// List of selected units
					draw_set_font(fnt_40k_14);
					draw_text_ext(actions_block.x1 + 26, actions_block.y1 + 30,selecting_dudes,-1,550);
					// Options for the selected unit
					// draw_set_font(fnt_40k_30b);
					// draw_text_transformed(actions_block.x1 + 4, actions_block.x1 + 64,"Options:",0.5,0.5,0);

					// Select all units button

					button.move("up", true, 4.15);

					button.move("left", true, 4);

					button.label = "Select All";
					button.tooltip = "";
					button.keystroke = false;
					button.alpha = 1;
					if (button.draw()){
						cooldown=8;
						// scr_load_all(loading); //not sure whether loading was intentional or not
						sel_all = "all";
					}

					button.move("right", true, 1);
					button.label = "Filter Mode";
					button.alpha = filter_mode ? 1 : 0.5;
					if (button.draw()){
						filter_mode = !filter_mode;
					}

					button.move("left", true, 1);
					// Select all infantry button
					button.y1 += button.h + button.v_gap + 4;
					button.h /= 1.4;
					button.w = 128;
					button.x2 = button.x1 + button.w;
					button.y2 = button.y1 + button.h;
					var inf_button_pos = [button.x1, button.y1, button.x2, button.y2];
					button.label = "All Infantry";
					button.alpha = 1;
					button.font = fnt_40k_12;
					draw_set_font(fnt_40k_12);
					if (button.draw()) {
						sel_all = "man";
					}
					// Select infantry type buttons
					for (var i = 1; i <= 8; i++) {
						if (sel_uni[i] != "") {
							button.move("right", true);
							if (i == 4){
								button.move("left", true, 4);
								button.move("down", true);
							}
							button.label = string_truncate(sel_uni[i], 126);
							button.alpha = 1;
							if (button.draw()){
								sel_all = sel_uni[i];
							}
						}
					}
				}

				// Select all vehicles button
				if (sel_veh[1]!=""){
					button.x1 = inf_button_pos[0];
					button.x2 = inf_button_pos[2];
					button.y1 = inf_button_pos[1] + (button.h + button.v_gap) * 2 + 4;
					button.y2 = button.y1 + button.h;
					button.label = "All Vehicles";
					button.alpha = 1;
					if (button.draw()){
						sel_all="vehicle";
					}
					// Select vehicle type buttons
					for (var i = 1; i <= 8; i++) {
						if (sel_veh[i] != "") {
							button.move("right", true);
							if i == 4{
								button.move("left", true, 4);
								button.move("down", true);
							}
							button.label = string_truncate(sel_veh[i], 126);
							button.alpha = 1;
							if (button.draw()) {
								sel_all = sel_veh[i];
							}
						}
					}
				}
			}

			draw_set_color(#3f7e5d);
			scr_scrollbar(974,172,1005,790,34,man_max,man_current);
		}	
		if (is_struct(cn.temp[120])){
			if (cn.temp[120].name()!="") and (cn.temp[120].race()!=0){
				draw_set_alpha(1);
				var xx=__view_get( e__VW.XView, 0 )+0, yy=__view_get( e__VW.YView, 0 )+0
		        if (scr_hit(xx+1208, yy+210, xx+1374, yy+210+272) || obj_controller.unit_profile) && !instance_exists(obj_temp3) && !instance_exists(obj_popup) {
					stats_displayed = true;
		        	selected_unit.stat_display(true);
		       		//tooltip_draw(stat_x, stat_y+string_height(stat_display),0,0,100,17);
		        } else {
					stats_displayed = false;
				}
		        with (obj_controller){
    		        if (view_squad && !instance_exists(obj_popup)){
    		        	if (managing>10){
    		        		view_squad=false;
    		        		unit_profile=false;
    		        	} else if (company_data!={}){
    		        		company_data.draw_squad_view();
    		        	}
    				}
    			}
			}
		}
	    var tip, coords;
		for (var i=0;i < array_length(tooltip_drawing); i++){
			tip = tooltip_drawing[i];
			coords=tip[1];
			if (point_in_rectangle(mouse_x, mouse_y, coords[0],coords[1],coords[2],coords[3])){
		        	tooltip_draw(tip[0], 350);
			}
		}		
	}
    else if (menu == 30 && (managing > 0 || managing == -1)) { // Load to ships

        var xx, yy, bb, img;
        bb = ""; img = 0;

        xx = __view_get(e__VW.XView, 0) + 0;
        yy = __view_get(e__VW.YView, 0) + 0;

        // BG
        draw_set_alpha(1);
        draw_sprite(spr_rock_bg, 0, xx, yy);
        draw_set_font(fnt_40k_30b);
        draw_set_halign(fa_center);
        draw_set_color(c_gray); // 38144

        // Draw Title
        var c = 0, fx = "";
        if (managing <= 10) {
            c = managing;
        }
        if (managing > 20) {
            c = managing - 10;
        }

        // Draw companies
        if (managing > 0) {
            if (managing >= 1 && managing <= 10) {
                fx = scr_roman_numerals()[managing - 1] + " Company";
            } else if (managing > 10) {
                switch (managing) {
                    case 11:
                        fx = "Headquarters";
                        break;
                    case 12:
                        fx = "Apothecarion";
                        break;
                    case 13:
                        fx = "Librarium";
                        break;
                    case 14:
                        fx = "Reclusium";
                        break;
                    case 15:
                        fx = "Armamentarium";
                        break;
                    default:
                        fx = "Unknown";
                        break;
                }
            }
        }

        draw_text(xx + 800, yy + 74, $"{global.chapter_name} {fx}");

        if (managing >= 0 && managing <= 10) {
            if (obj_ini.company_title[managing] != "") {
                draw_set_font(fnt_fancy);
                draw_text(xx + 800, yy + 110, string_hash_to_newline($"''{obj_ini.company_title[managing]}''"));
            }
        }

        // Back
        draw_sprite_ext(spr_arrow, 0, xx + 25, yy + 70, 2, 2, 0, c_white, 1);

        if (point_and_click([xx + 25, yy + 70, xx + 70, yy + 140])) {
            man_size = 0;
            man_current = 0;
            menu = 1;
        }

        var top, temp1 = "", temp2 = "", temp3 = "", temp4 = "", temp5 = "";
        top = ship_current;

        draw_set_font(fnt_40k_14);
        draw_set_halign(fa_left);
        yy += 77;
        var main_rect;
        var repetitions = min(ship_max, ship_see);

        for (var sel = top; sel < repetitions && sel<array_length(sh_name); sel++) {

            if (sh_name[sel] != "") {
                temp1 = string(sh_name[sel]) + " (" + string(sh_class[sel]) + ")";
                temp2 = string(sh_loc[sel]);
                temp3 = sh_hp[sel];
                temp4 = string(sh_cargo[sel]) + " / " + string(sh_cargo_max[sel]) + " Space Used";

                main_rect = [xx + 25, yy + 64, xx + 974, yy + 85];

                draw_set_color(c_black);
                draw_rectangle(main_rect[0], main_rect[1], main_rect[2], main_rect[3], 0);
                draw_set_color(c_gray);
                draw_rectangle(xx + 25, yy + 64, xx + 974, yy + 85, 1);
                draw_text_transformed(xx + 27, yy + 66, string_hash_to_newline(string(temp1)), 1, 1, 0);
                draw_text_transformed(xx + 27.5, yy + 66.5, string_hash_to_newline(string(temp1)), 1, 1, 0);
                draw_text_transformed(xx + 364, yy + 66, string_hash_to_newline(string(temp2)), 1, 1, 0);
                draw_text_transformed(xx + 580, yy + 66, string_hash_to_newline(string(temp3)), 1, 1, 0);
                draw_text_transformed(xx + 730, yy + 66, string_hash_to_newline(string(temp4)), 1, 1, 0);
                if (point_and_click(main_rect)) {
                    if ((sh_cargo[sel] + man_size) <= sh_cargo_max[sel]) {

                        var load_from_star = star_by_name(selecting_location);
                        var onceh = 0;
                        stop = 0;
                        for (var q = 0; q < array_length(display_unit); q++) {
                            if (man_sel[q] == 1) {
                                if (is_struct(display_unit[q])) {
                                    unit = display_unit[q];
                                    unit.load_marine(sh_ide[sel], load_from_star);
                                    ma_loc[q] = sh_loc[sel];
                                    ma_lid[q] = sh_ide[sel];
                                    ma_wid[q] = 0;
                                }
                                else if (is_array(display_unit[q]) && ma_loc[q] == selecting_location && sh_loc[sel] == selecting_location) {
                                    var vehicle = display_unit[q];
                                    var vehic_size = scr_unit_size("", ma_role[q], true);

                                    if ((sh_cargo[sel] + vehic_size) <= sh_cargo_max[sel] && man_sel[q] != 0) {
                                        var start_ship = obj_ini.veh_lid[vehicle[0]][vehicle[1]];
                                        var start_planet = obj_ini.veh_wid[vehicle[0]][vehicle[1]];
                                        ma_loc[q] = sh_loc[sel];
                                        ma_lid[q] = sh_ide[sel];
                                        ma_wid[q] = 0;
                                        obj_ini.veh_loc[vehicle[0]][vehicle[1]] = sh_name[sel];
                                        obj_ini.veh_lid[vehicle[0]][vehicle[1]] = sh_ide[sel];
                                        obj_ini.veh_wid[vehicle[0]][vehicle[1]] = 0;
                                        obj_ini.veh_uid[vehicle[0]][vehicle[1]] = sh_uid[sel];
                                        obj_ini.ship_carrying[sh_ide[sel]] += vehic_size;
                                        if (start_planet) {
                                            load_from_star.p_player[start_planet] -= vehic_size;
                                        } else if (start_ship) {
                                            obj_ini.ship_carrying[start_ship] -= vehic_size;
                                        }
                                    }
                                }
                            }
                        }
                        selecting_location = "";
                        man_size = 0;
                        man_current = 0;
                        menu = 1;
                        cooldown = 8;
                        selecting_ship = -1;
                        for (var k = 0; k < array_length(display_unit); k++) {
                            man_sel[k] = 0;
                        }
                    }
                    if (managing == -1) {
                        update_garrison_manage();
                    }
                }
                yy += 20;
            }
        }

        // Load to selected
        draw_set_font(fnt_40k_14b);
        draw_text_transformed(xx + 320, yy + 402, string_hash_to_newline($"Click a Ship to Load Selection (Req. {man_size} Space)"), 1, 1, 0);

        xx = __view_get(e__VW.XView, 0) + 0;
        yy = __view_get(e__VW.YView, 0) + 0;

        // draw_text_transformed(xx + 488, yy + 426, "Selection Size: " + string(man_size), 0.4, 0.4, 0);
        scr_scrollbar(974, 172, 1005, 790, 34, ship_max, ship_current);
    }

}