
function setup_promotion_popup(){
    if ((sel_promoting == 1) && (instance_number(obj_popup) == 0)) {
        var pip = instance_create(0, 0, obj_popup);
        pip.type = 5;
        pip.company = managing;

        var god = 0, nuuum = 0;
        for (var f = 0; f < array_length(display_unit); f++) {
            if ((ma_promote[f] >= 1 || is_specialist(ma_role[f], SPECIALISTS_RANK_AND_FILE) || is_specialist(ma_role[f], SPECIALISTS_SQUAD_LEADERS)) && man_sel[f] == 1) {
                nuuum += 1;
                if (pip.min_exp == 0) {
                    pip.min_exp = ma_exp[f];
                }
                pip.min_exp = min(ma_exp[f], pip.min_exp);
            }
            if ((god == 0) && (ma_promote[f] >= 1) && (man_sel[f] == 1)) {
                god = 1;
                pip.unit_role = ma_role[f];
            }
        }
        if (nuuum > 1) {
            pip.unit_role = "Marines";
        }
	    with (pip){
	        units = nuuum;
	        promote_button = new UnitButtonObject(
	        	{
	        		x1: 1450, 
			        y1: 491,
			        style : "pixel",
					label : "Promote"
	        	}
	        );
	        promote_button.bind_method = function(){

		        var mahreens=0,i=-1;

		        if (target_comp>10){
		        	target_comp=0;
		        }

		        for(i=0;i<498;i++){
		            if (obj_ini.name[target_comp][i]=="" and obj_ini.name[target_comp][i+1]=="") {
		                mahreens=i;
		                break;
		            }
		        }
		        // Gets the number of marines in the target company
		        var unit, squad_mover,moveable;
		        var role_squad_equivilances = {};//this is the only way to set variables as keys in gml
		        variable_struct_set(role_squad_equivilances,obj_ini.role[100][8],"tactical_squad");
		        variable_struct_set(role_squad_equivilances,obj_ini.role[100][9],"devastator_squad");
		        variable_struct_set(role_squad_equivilances,obj_ini.role[100][10],"assault_squad");
		        variable_struct_set(role_squad_equivilances,obj_ini.role[100][12],"scout_squad");
		        variable_struct_set(role_squad_equivilances,obj_ini.role[100][3],"sternguard_veteran_squad");
		        variable_struct_set(role_squad_equivilances,obj_ini.role[100][4],"terminator_squad");

		        for(i=0;i<array_length(obj_controller.display_unit) && mahreens<500;i++){
		            if (obj_controller.man[i]=="man") and (obj_controller.man_sel[i]==1) and (obj_controller.ma_exp[i]>=min_exp){
		                moveable=true;
		                unit = obj_controller.display_unit[i];
		                if (unit.squad != "none"){   // this evaluates if you are trying promote a whole squad
		                    move_squad = unit.squad;
		                    squad = obj_ini.squads[move_squad];
		                    squad.update_fulfilment();
		                    move_members = squad.members;
		                    if (array_length(move_members)==1){
		                        unit.squad = "none";
		                        moveable = false;
		                    }                  
		                    for (var mem = 0;mem<array_length(move_members);mem++){//check all members have been selected and are in the same company
		                        if (i+mem<array_length(obj_controller.display_unit)){
		                            if (!is_struct(obj_controller.display_unit[i+mem])) then continue;
		                            if (obj_controller.man_sel[i+mem]!=1 || obj_controller.display_unit[i+mem].squad != move_squad){
		                                moveable = false;
		                                break;
		                            }
		                        } else{
		                            moveable = false;
		                            break;                                    
		                        }
		                    }
		                    //move squad
		                    if (moveable){
		                        var mem_unit;
		                        for (var mem = 0;mem<array_length(move_members);mem++){
		                            var mem_unit = fetch_unit(move_members[mem]);
		                            if (mem_unit.company!=target_comp){
		                                scr_move_unit_info(mem_unit.company,target_comp,mem_unit.marine_number,mahreens, false);
		                                squad.members[mem][0] = target_comp;
		                                squad.members[mem][1] = mahreens;
		                            }
		                            mem_unit=obj_ini.TTRPG[target_comp][mahreens];
		                            mem_unit.squad = move_squad; 
		                            if (!mem_unit.IsSpecialist(SPECIALISTS_SQUAD_LEADERS)){
		                                mem_unit.update_role(role_name[target_role]);
		                                mem_unit.alter_equipment({
		                                    "wep1":req_wep1,
		                                    "wep2":req_wep2,
		                                    "mobi":req_mobi,
		                                    "armour":req_armour,
		                                    "gear":req_gear,
		                                });                                     
		                            }                           
		                            mahreens++;
		                        }
		                        i+=mem-2;
		                        if (squad.base_company!=target_comp){
		                            squad.base_company = target_comp;
		                        }
		                        if (struct_exists(role_squad_equivilances,role_name[target_role])){
		                            squad.change_type(role_squad_equivilances[$ role_name[target_role]]);
		                        }
		                    }
		                } else {moveable=false}
		                //move individual
		                if (!moveable){
		                    if (unit.company!=target_comp){
		                        scr_move_unit_info(unit.company,target_comp,unit.marine_number,mahreens);
		                        unit = obj_ini.TTRPG[target_comp][mahreens]; 
		                    }
		                    unit.update_role(role_name[target_role]);
		                    unit.alter_equipment({
		                        "wep1":req_wep1,
		                        "wep2":req_wep2,
		                        "mobi":req_mobi,
		                        "armour":req_armour,
		                        "gear":req_gear,
		                    }); 
		                    mahreens++;
		                }                                           	
		            }// End that [i]

		        }// End repeat


		        with(obj_controller){scr_management(1);}

		        with(obj_ini){
		            scr_company_order(obj_popup.manag);
		            scr_company_order(obj_popup.target_comp);
		        }


		        with(obj_controller){
		            // man_current=0;
		            var man_size=0;selecting_location="";
		            selecting_types="";
		            selecting_ship=-1;
		            reset_manage_arrays();
		            alll=0;
		            update_general_manage_view();
		        }

		        with(obj_managment_panel){instance_destroy();}

		        obj_controller.cooldown=10;
		        instance_destroy();        	
	        };

			promote_button.bind_scope = pip;
	        cancel_button = new UnitButtonObject(
	        	{
	        		x1: 1061, 
			        y1: 491, 
			        style : "pixel",
			        label : "Cancel"
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
	        target_company_radio();
	    }
    }
}

function target_company_radio(min_exp=0){
    var _company_options = [{
            str1 : "HQ",
            font : fnt_40k_14b,
            val : 0
        },
    ];
    for (var i=1;i<=obj_ini.companies;i++){
    	var _dont_add = false;
		if (obj_controller.command_set[2] == 1) {
			//cecks if exp requirements are activated
			if (min_exp < company_promote_data[i].exp) {
				var _dont_add = true;
			}
		}
		if (!_dont_add){
			array_push(_company_options,{
				str1 : int_to_roman(i),
				font : fnt_40k_14b,
				val : i
			});
		}
    }
	companies_select = new radio_set(_company_options, "Target Company", {max_width : 500, x1:1040, y1:210});

	companies_select.current_selection = 0;	
}


function draw_popup_promotion(){
    manag=obj_controller.managing;
    if (manag>10) then manag=0;
    var company=manag;
	draw_set_color(0);
	main_slate.draw_with_dimensions();

	draw_set_font(fnt_40k_14b);
	draw_set_halign(fa_center);
	draw_set_color(CM_GREEN_COLOR);
	draw_text(1292, 150, "Promoting");
	var romanNumerals = scr_roman_numerals();

	draw_set_font(fnt_40k_12);
	var comp = "";
	if (company <= 10 && company > 0) {
		comp = romanNumerals[company - 1];
	} else if (company > 10) {
		comp = "HQ";
	}
	draw_text(1292, 175, $"{comp} Company {unit_role}");

	companies_select.draw();
	if (companies_select.changed){
		target_comp = companies_select.selection_val("val");
		target_role = 0;
		get_unit_promotion_options();
	}
	// }

	draw_text(1020, 290, "Target Role:"); //choose new role
	var role_x = 0;
	role_y = 0;
	if (target_comp != -1) {
		
		for (var r = 1; r <= 11; r++) {
			if (role_name[r] != "") {
				draw_set_alpha(1);
				check = " ";
				if (target_role == r) {
					check = "x";
				}
				if (min_exp < role_exp[r]) {
					draw_set_alpha(0.25);
				}
				draw_text(1030 + role_x, 310 + role_y, $"{role_name[r]} [{check}]");
				if (point_and_click([1030 + role_x, 310 + role_y, 1180 + role_x, 330 + role_y])) {
					if (min_exp >= role_exp[r]) {
						target_role = r;
						all_good = calculate_equipment_needs();
					}
				}
				if (r % 3 == 0) {
					role_y += 20;
					role_x = 0;
				} else {
					role_x += 170;
				}
			}
		}
	}

	draw_set_alpha(1);

	draw_text(1020, 370, string_hash_to_newline("Required Gear:"));
	var gr = 0, tox = "";

	if (target_role > 0) {
		if (req_armour != "") {
			gr = req_armour_num - have_armour_num;
			tox = "";
			if (gr > 0) {
				draw_set_color(c_red);
			} else {
				draw_set_color(CM_GREEN_COLOR);
			}
			draw_text(1030, 390, $"{req_armour_num} {req_armour} (Have {have_armour_num})");
		}
		if (req_gear != "") {
			gr = req_gear_num - have_gear_num;
			tox = "";
			if (gr > 0) {
				draw_set_color(c_red);
			} else {
				draw_set_color(CM_GREEN_COLOR);
			}
			draw_text(1030, 410, $"{req_gear_num} {req_gear} (Have {have_gear_num})");
		}
		if (req_mobi != "") {
			gr = req_mobi_num - have_mobi_num;
			tox = "";
			if (gr > 0) {
				draw_set_color(c_red);
			} else {
				draw_set_color(CM_GREEN_COLOR);
			}
			draw_text(1030, 430, $"{req_mobi_num} {req_mobi} (Have {have_mobi_num})");
		}
		if (req_wep1 != "") {
			gr = req_wep1_num - have_wep1_num;
			tox = "";
			if (gr > 0) {
				draw_set_color(c_red);
			} else {
				draw_set_color(CM_GREEN_COLOR);
			}
			draw_text(1280, 390, $"{req_wep1_num} {req_wep1} (Have {have_wep1_num})");
		}
		if (req_wep2 != "") {
			gr = req_wep2_num - have_wep2_num;
			tox = "";
			if (gr > 0) {
				draw_set_color(c_red);
			} else {
				draw_set_color(CM_GREEN_COLOR);
			}
			draw_text(1280, 410, $"{req_wep2_num} {req_wep2} (Have {have_wep2_num})");
		}
	}

	if(cancel_button.draw()){
		instance_destroy();
	}

	promote_button.draw(all_good);
}