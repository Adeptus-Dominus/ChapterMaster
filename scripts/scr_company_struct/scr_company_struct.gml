
function new_company_struct(){
	with (obj_controller){
		if (struct_exists(company_data,"company")){
			company_data.garbage_collect();
			delete company_data;
		}
		company_data = new CompanyStruct(managing);

	}
}
function CompanyStruct(comp) constructor{
	company = comp;
	company_squads = [];
	static garbage_collect = function(){
		reset_squad_surface();
		delete next_squad_button;
		delete mass_equip_toggle;
		delete previous_squad_button;
		delete reset_loadout_button;
		delete sabotage_button;
		delete garrison_button;
	}
	static squad_search = function(){
		var _squads = obj_ini.squads;
		if (company>=0){
			company_squads = [];
			var cur_squad;
			for (var i=0;i<array_length(_squads);i++){
				cur_squad = _squads[i];
				if (cur_squad.base_company != company) then continue;
				cur_squad.update_fulfilment();
				if (array_length(_squads[i].members)>0 && _squads[i].base_company == company){
					array_push(company_squads,i);
				}
			}
		} else if (company == -1){
			var _disp_units = obj_controller.display_unit;
			for (var i=0; i<array_length(_disp_units); i++){
				var unit = _disp_units[i];
				if (!is_array(unit)){
					if (unit.squad != "none"){
						if (array_contains(company_squads, unit.squad)) then continue;
						if (unit.squad < array_length(_squads)){
							var cur_squad = _squads[unit.squad];
							cur_squad.update_fulfilment();
							if (array_length(cur_squad.members)>0){
								array_push(company_squads,unit.squad);
							}
						} else {
							unit.squad = "none";
						}
					}
				}
			}
		}
	}
	var xx=__view_get( e__VW.XView, 0 )+0;
	var yy=__view_get( e__VW.YView, 0 )+0;	
	center_width = [580,1005];
	center_height = [144,957];

	previous_squad_button = new UnitButtonObject({
		x1 : xx+center_width[0],
		y1 : yy+center_height[0]+6,
		color:c_red,
		label : "<--",
                tooltip : "Press Left arrow to toggle"
	});

	next_squad_button = new UnitButtonObject({
		x1 : xx+center_width[1]-44,
		y1 : yy+center_height[0]+6,
		color:c_red,
		label : "-->",
                tooltip : "Press tab to toggle"
	});

	garrison_button = new UnitButtonObject({
		x1 : xx+center_width[0]+5, 
		y1 : yy+center_height[0]+150,
		color:c_red,
		label : "Garrison Duty",
		tooltip : "Having squads assigned to Garrison Duty will increase relations with a planet over time, it will also bolster planet defence forces in case of attack, and reduce corruption growth. Press G to toggle"
	});

	sabotage_button = new UnitButtonObject({
		x1 : garrison_button.x2+5, 
		y1 : yy+center_height[0]+150,
		color:c_red,
		label : "Sabotage",
		tooltip : "Sabotage missions can reduce enemy growth while avoiding direct enemy contact however they are not without risk."
	});

	reset_loadout_button = new UnitButtonObject({
		x1 : xx+center_width[0]+5, 
		y1 : yy+center_height[0]+330,
		color:c_green,
		label : "Reset Squad Loadout",
	});

	mass_equip_toggle = new ToggleButton({
		x1 : xx+center_width[0]+5, 
		y1 : yy+center_height[0]+380,
		button_color:c_green,
		text_color : c_green,
		str1 : "Allow mass equip",
	});
	mass_equip_toggle.update();


	static send_squad_on_mission  = function(mission_type, star){
		with (star){

			var unload_squad=instance_create(x,y,obj_star_select);
			unload_squad.target=self;
			unload_squad.loading=1;
			unload_squad.loading_name=name;
			//unload_squad.loading_name=name;
			unload_squad.depth=-10000;
			unload_squad.mission=mission_type;
			scr_company_load(name);
			break;
		}
		
	}

	next_squad = function(up = true){
		if (up){
			cur_squad = cur_squad+1>=array_length(company_squads) ? 0 : cur_squad+1;
		} else {
			cur_squad = (cur_squad-1<0) ? array_length(company_squads)-1 : cur_squad-1;
		}
		member = grab_current_squad().members[0];
		obj_controller.temp[120] = fetch_unit(member);			
	}
	squad_search();

	cur_squad = 0;
	exit_period=false;
	unit_rollover=false;
	rollover_sequence=0;
	selected_unit=obj_controller.temp[120];
	drop_down_open=false;
	captain = "none";
	champion = "none";
	ancient = "none";
    chaplain = "none";
    apothecary = "none";
	tech_marine = "none";
	lib = "none";

	static reset_squad_surface = function(){
		if (is_array(squad_draw_surfaces)){
			for (var i=0;i<array_length(squad_draw_surfaces);i++){
				if (is_array(squad_draw_surfaces[i])){
					if (is_struct(squad_draw_surfaces[i][1])){
						squad_draw_surfaces[i][1].destroy_image();
					}
				}
			}
		}
		squad_draw_surfaces = array_create(15, []);		
		for (var i=0;i<15;i++){
			squad_draw_surfaces[i]=[[-1,-1],false];
		}
	}
	squad_draw_surfaces=[];
	reset_squad_surface();

	if (company>0 && company<11){
		var unit;
		var company_units = obj_controller.display_unit;
		var role_set = obj_ini.role[100];
		for (var i=0;i<array_length(company_units);i++){
			if (is_struct(company_units[i])){
				unit = company_units[i];
				if (unit.role() == role_set[eROLE.Captain]){
					captain = unit;
				} else if (unit.role() == role_set[eROLE.Ancient]){
					ancient = unit;
				} else if (unit.role() == role_set[eROLE.Champion]){
					champion = unit;
				} else {
					if (unit.IsSpecialist(SPECIALISTS_CHAPLAINS)) {
						chaplain = unit;
					}
					if (unit.IsSpecialist(SPECIALISTS_APOTHECARIES)) {
						apothecary = unit;
					}
					if (unit.IsSpecialist(SPECIALISTS_TECHS)) {
						tech_marine = unit;
					}
					if (unit.IsSpecialist(SPECIALISTS_LIBRARIANS)) {
						lib = unit;
					}
				}
			}
		}
	}
	static grab_current_squad = function(){
		return obj_ini.squads[company_squads[cur_squad]];
	}

	static default_member = function(){
		var member = obj_ini.squads[company_squads[0]].members[0];
		obj_controller.temp[120] = fetch_unit(member);
		selected_unit = obj_controller.temp[120];		
	}

	static draw_squad_view = function(){
		center_width = [580,1005];
		center_height = [144,957];
		var xx=__view_get( e__VW.XView, 0 )+0;
		var yy=__view_get( e__VW.YView, 0 )+0;
    	var member;
    	selected_unit=obj_controller.temp[120];
		if (array_length(company_squads) > 0){
			if (selected_unit.company == company || company ==-1){
    			if (company_squads[cur_squad] != selected_unit.squad){
    				var squad_found =false
    				for (var i =0;i<array_length(company_squads);i++){
    					if (company_squads[i] == selected_unit.squad){
    						cur_squad = i;
    						squad_found = true;
    						break;
    					}
    				}
    				if (!squad_found){
    					default_member();
    				}
    			}
    		} else {
    			default_member();
    		}
		} else if (obj_controller.view_squad){
			obj_controller.view_squad = false;
			obj_controller.unit_profile =false;
		}
		if (selected_unit.squad=="none"){
			default_member();
		}
    	if (selected_unit.squad!="none"){			        	
			current_squad = obj_ini.squads[selected_unit.squad];
			var x_mod=0,y_mod=0;
			var member_width=0, member_height=0;
			var x_overlap_mod =0;
			var bound_width = center_width;
			var bound_height = center_height;
			draw_set_halign(fa_left);

			if (array_length(company_squads) > 0){
				if (previous_squad_button.draw()){
					next_squad(false);
				}
				if (next_squad_button.draw()){
					next_squad();				
				}
			}
					
			draw_set_color(c_gray);
			draw_set_alpha(1);				
			draw_set_halign(fa_center);
			draw_text_transformed(xx+bound_width[0]+((bound_width[1]-bound_width[0])/2)-6, yy+bound_height[0]+6,$"{selected_unit.squad} {current_squad.display_name}",1.5,1.5,0);
			if (current_squad.nickname!=""){
				draw_text_transformed(xx+bound_width[0]+((bound_width[1]-bound_width[0])/2), yy+bound_height[0]+30,$"{current_squad.display_name}",1.5,1.5,0);
			}

			draw_set_halign(fa_left);
			//should be moved elsewhere for efficiency
			var squad_leader = current_squad.determine_leader();
			if (squad_leader != "none"){
				var leader_text = $"Squad Leader : {fetch_unit(squad_leader).name_role()}"
				draw_text_transformed(xx+bound_width[0]+5, yy+bound_height[0]+50, leader_text,1,1,0);
			}
			var squad_loc = current_squad.squad_loci();
			draw_text_transformed(xx+bound_width[0]+5, yy+bound_height[0]+75, $"Squad Members : {current_squad.life_members}",1,1,0);
			draw_text_transformed(xx+bound_width[0]+5, yy+bound_height[0]+100, $"Squad Location : {squad_loc.text}",1,1,0);
			var send_on_mission=false, mission_type;
			if (current_squad.assignment == "none"){

				draw_text_transformed(xx+bound_width[0]+5, yy+bound_height[0]+125, $"Squad has no current assignments",1,1,0);

				var _squad_sys = squad_loc.system;
				if (squad_loc.same_system) and (_squad_sys!="Warp" && _squad_sys!="Lost"){
					if (garrison_button.draw()){
						send_on_mission=true;
						mission_type="garrison";
					}

		garrison_button.keystroke = press_exclusive(ord("G"));
					if (array_contains(current_squad.class, "scout")) || (array_contains(current_squad.class, "bike")){
						if (sabotage_button.draw()){
							send_on_mission=true;
							mission_type="sabotage";
						}
					}
				}
				if (send_on_mission){
					send_squad_on_mission(mission_type,star_by_name(squad_loc.system));					
				}
				bound_height[0] += 180;
			} else {
				if (is_struct(current_squad.assignment)){
					var cur_assignment = current_squad.assignment
					draw_text_transformed(xx+bound_width[0]+5, yy+bound_height[0]+125, $"Assignment : {cur_assignment.type}",1,1,0);
					var tooltip_text =  "Cancel Assignment"
					var cancel_but = draw_unit_buttons([xx+bound_width[0]+5, yy+bound_height[0]+150],tooltip_text,[1,1],c_red,,,,true);
					if(point_and_click(cancel_but) || keyboard_check_pressed(ord("C"))){
						var cancel_system=noone;
						with (obj_star){
							if (name == squad_loc.system){
								cancel_system=self;
							}
						}
						if (cancel_system!=noone){
							var planet = current_squad.assignment.ident;
							var operation;
							for (var i=0;i<array_length(cancel_system.p_operatives[planet]);i++){
								operation = cancel_system.p_operatives[planet][i];
								if (operation.type=="squad" && operation.reference ==company_squads[cur_squad]){
									array_delete(cancel_system.p_operatives[planet], i, 1);
								}
							}
						}
						current_squad.assignment = "none";
					}
					bound_height[0] += 180;
					if (cur_assignment.type == "garrison"){
						var garrison_but = draw_unit_buttons([cancel_but[2]+10, cancel_but[1]],"View Garrison",[1,1],c_red,,,,true);
						if (point_and_click(garrison_but)){
							var garrrison_star =  star_by_name(cur_assignment.location);
							obj_controller.view_squad = false;
							if (garrrison_star!="none"){
								scr_toggle_manage();
				                obj_controller.x = garrrison_star.x;
				                obj_controller.y = garrrison_star.y;
				                obj_controller.selection_data =  {
				                	system : garrrison_star.id,
				                	planet:cur_assignment.ident,
				                	feature:"",
				                }
				                garrrison_star.alarm[3] = 4;
				            }
						}
					}
				}
			}
		previous_squad_button.keystroke = press_exclusive(vk_left);
		next_squad_button.keystroke = press_exclusive(vk_tab);
			//TODO compartmentalise drop down option logic
			var deploy_text = "Squad will deploy in the";
			if (current_squad.formation_place!=""){
				draw_set_font(fnt_40k_14b)
				draw_text_transformed(xx+bound_width[0]+5, yy+bound_height[0], deploy_text,1,1,0);
				button = draw_unit_buttons([xx+bound_width[0]+5 + string_width(deploy_text), yy+bound_height[0]-2],current_squad.formation_place,[1,1],c_green,,,,true);
				draw_set_color(c_red);
				draw_text_transformed(xx+bound_width[0]+5+ string_width(deploy_text) + string_width(current_squad.formation_place)+9, yy+bound_height[0], "column",1,1,0);
				draw_set_color(c_gray);
				if (array_length(current_squad.formation_options)>1){
					if (scr_hit(button)){
						drop_down_open = true;
					}
					if (drop_down_open){
						var roll_down_offset=8+string_height(current_squad.formation_place);
						for (var col = 0;col<array_length(current_squad.formation_options);col++){
							if (current_squad.formation_options[col]==current_squad.formation_place) then continue;
							button = draw_unit_buttons([button[0], button[3] + 2],current_squad.formation_options[col],[1,1],c_red,,,,true);
							if (point_and_click(button)){
								current_squad.formation_place = current_squad.formation_options[col];
								drop_down_open = false;
							}
							roll_down_offset += string_height(current_squad.formation_options[col])+4;

						}
						if (!scr_hit(
								xx+bound_width[0]+5+string_width(deploy_text),
								yy+bound_height[0],
								xx+bound_width[0]+13+ string_width(deploy_text) +string_width(current_squad.formation_place),
								yy+bound_height[0]+roll_down_offset,
							)
						){
							drop_down_open = false;
						}
					}
				}
				bound_height[0] += button[3] - button[1];
			}

			if (reset_loadout_button.draw()){
				current_squad.sort_squad_loadout();
				reset_squad_surface();
			}

			mass_equip_toggle.active = current_squad.allow_bulk_swap;
			mass_equip_toggle.clicked();
			mass_equip_toggle.draw();
			current_squad.allow_bulk_swap = mass_equip_toggle.active;
		
			
			if (unit_rollover){
				if (scr_hit(xx+25, yy+144, xx+925, yy+981)){
					x_overlap_mod =180;
				} else {
					unit_rollover = !unit_rollover;
				}
			} else {
				x_overlap_mod =90+(9*rollover_sequence);							
			}
			var sprite_draw_delay="none"
			var unit_sprite_coords=[];
			for (var i=0;i<array_length(current_squad.members);i++){
				member = fetch_unit(current_squad.members[i]);
				if (!array_equals(squad_draw_surfaces[i][0], current_squad.members[i])){
					squad_draw_surfaces[i][0] = [member.company, member.marine_number];
					squad_draw_surfaces[i][1] = member.draw_unit_image();
				}
				var cur_member_surface = squad_draw_surfaces[i][1];
				if (member.name()!=""){
					if (member_width==5){
						member_width=0;
						x_mod=0;
						member_height++;
						y_mod += 231;
					}
					member_width++;
					unit_sprite_coords = [xx+25+x_mod, yy+144+y_mod, xx+25+x_mod+166, yy+144+y_mod+231];
					cur_member_surface.draw_part(unit_sprite_coords[0],unit_sprite_coords[1], 0,0, 166, 231,true);
					if (scr_hit(unit_sprite_coords) && !exit_period && unit_rollover){
						sprite_draw_delay = [member,unit_sprite_coords, cur_member_surface];
						obj_controller.temp[120] = member;									
					}else {
						if (obj_controller.temp[120].company==member.company && obj_controller.temp[120].marine_number==member.marine_number && !is_array(sprite_draw_delay)){
							sprite_draw_delay = [member,unit_sprite_coords, cur_member_surface];
							obj_controller.temp[120] = member;
						}								
					}
					x_mod+=x_overlap_mod;
				}
			}
			if (is_array(sprite_draw_delay)){
				member = sprite_draw_delay[0];
				unit_sprite_coords=sprite_draw_delay[1]
				sprite_draw_delay[2].draw_part(unit_sprite_coords[0],unit_sprite_coords[1], 0,0, 166, 231, true);
				draw_set_color(c_red);
				draw_rectangle(unit_sprite_coords[0], unit_sprite_coords[1], unit_sprite_coords[2], unit_sprite_coords[3], 1);
				draw_set_color(c_gray);
				if (mouse_check_button_pressed(mb_left)){
					unit_rollover = false;
					exit_period = true;
				}
			}						
			if (!unit_rollover && !instance_exists(obj_star_select)){
				if (scr_hit(xx+25, yy+144, xx+525, yy+981) && !exit_period){
					if (rollover_sequence<10){
						rollover_sequence++;
					} else {
						unit_rollover=true;
					}
				} else{
					if (rollover_sequence>0){
						rollover_sequence--;
					}
				}
			}
			if (exit_period and !scr_hit(xx+25, yy+144, xx+525, yy+981)){
				exit_period=false;
			}
		}
	}
}
