
function CompanyStruct(comp) constructor{
	company = comp;
	company_squads = [];

	static squad_search = function(){
		company_squads = [];
		var cur_squad;
		for (var i=0;i<array_length(obj_ini.squads);i++){
			cur_squad = obj_ini.squads[i];
			if (cur_squad.base_company != company) then continue;
			cur_squad.update_fulfilment();
			if (array_length(obj_ini.squads[i].members)>0 && obj_ini.squads[i].base_company == company){
				array_push(company_squads,i);
			}
		}
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
		var xx=__view_get( e__VW.XView, 0 )+0;
		var yy=__view_get( e__VW.YView, 0 )+0;
    	var member;
    	selected_unit=obj_controller.temp[120];
		if (array_length(company_squads) > 0){
			if (selected_unit.company == company){
    			if (company_squads[cur_squad] != selected_unit.squad){
    				var squad_found =false
    				for (var i =0;i<array_length(company_squads);i++){
    					if (company_squads[i] == selected_unit.squad){
    						cur_squad = i;
    						squad_found =true;
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
			var bound_width = [580,1005];
			var bound_height = [144,957];
			draw_set_halign(fa_left);
			var arrow="<--";
			var button = draw_unit_buttons([xx+bound_width[0], yy+bound_height[0]+6], arrow,[1.5,1.5],c_red,,,,true);
			if (point_and_click(button) && array_length(company_squads) > 0){
				cur_squad = (cur_squad-1<0) ? 0 : cur_squad-1;
				member = grab_current_squad().members[0];
				obj_controller.temp[120] = fetch_unit(member);
			}
			arrow="-->";
			draw_set_halign(fa_right);
			button = draw_unit_buttons([xx+bound_width[1]-44,yy+bound_height[0]+6], arrow,[1.5,1.5],c_red,,,,true);
			if (point_and_click(button) && array_length(company_squads) > 0){
				cur_squad = cur_squad+1>=array_length(company_squads) ? 0 : cur_squad+1;
				member = grab_current_squad().members[0];
				obj_controller.temp[120] = fetch_unit(member);
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
				var button_row_offset = 0;
				draw_text_transformed(xx+bound_width[0]+5, yy+bound_height[0]+125, $"Squad has no current assigments",1,1,0);
				tooltip_text="Guard Duty";
				var _squad_sys = squad_loc.system;
				if (squad_loc.same_system) and (_squad_sys!="Warp" && _squad_sys!="Lost"){
					button_row_offset+=string_width(tooltip_text)+6;
					button = draw_unit_buttons([xx+bound_width[0]+5, yy+bound_height[0]+150], tooltip_text,[1,1],c_red,,,,true);
					if(point_in_rectangle(mouse_x, mouse_y,xx+bound_width[0]+5, yy+bound_height[0]+150, xx+bound_width[0]+5+string_width(tooltip_text), yy+bound_height[0]+150+string_height(tooltip_text))){
						tooltip_text = "Having squads assigned to Guard Duty will increase relations with a planet over time, it will also bolster planet defence forces in case of attack, and reduce corruption growth.";
						tooltip_draw(tooltip_text, 150, [xx+bound_width[0]+5, yy+bound_height[0]+200]);
						if (mouse_check_button_pressed(mb_left)){
							send_on_mission=true;
							mission_type="garrison";
						}
					}
					if (array_contains(current_squad.class, "scout")) || (array_contains(current_squad.class, "bike")){
						tooltip_text="Sabotage";
						button = draw_unit_buttons([button[2] + 4, yy+bound_height[0]+150], tooltip_text,[1,1],c_red,,,,true);
						if(point_in_rectangle(mouse_x, mouse_y,xx+bound_width[0]+5+ button_row_offset, yy+bound_height[0]+150, xx+bound_width[0]+5+string_width(tooltip_text)+ button_row_offset, yy+bound_height[0]+150+string_height(tooltip_text))){
							tooltip_text = "Sabotage missions can reduce enemy growth while avoiding direct enemy contact however they are not without risk.";
							tooltip_draw(tooltip_text, 150, [xx+bound_width[0]+5+button_row_offset, yy+bound_height[0]+200]);
							if (mouse_check_button_pressed(mb_left)){
								send_on_mission=true;
								mission_type="sabotage";
							}
						}
					}
				}
				if (send_on_mission){
					with (obj_star){
						if (name == squad_loc.system){
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
				}
				bound_height[0] += 180;
			} else {
				if (is_struct(current_squad.assignment)){
					var cur_assignment = current_squad.assignment
					draw_text_transformed(xx+bound_width[0]+5, yy+bound_height[0]+125, $"Assignment : {cur_assignment.type}",1,1,0);
					var tooltip_text =  "Cancel Assignment"
					var cancel_but = draw_unit_buttons([xx+bound_width[0]+5, yy+bound_height[0]+150],tooltip_text,[1,1],c_red,,,,true);
					if(point_and_click(cancel_but)){
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
							if (garrrison_star!="none"){
								obj_controller.menu=0;
				                obj_controller.hide_banner=0;
				                obj_controller.x = garrrison_star.x;
				                obj_controller.y = garrrison_star.y;
				                obj_controller.selection_data =  {
				                	planet:cur_assignment.ident,
				                	feature:"",
				                }
				                garrrison_star.alarm[3] = 4;
				            }
						}
					}
				}
			}
			//TODO compartmentalise drop down option logic
			var deploy_text = "Squad will deploy in the";
			if (current_squad.formation_place!=""){
				draw_set_font(fnt_40k_14b)
				draw_text_transformed(xx+bound_width[0]+5, yy+bound_height[0], deploy_text,1,1,0);
				button = draw_unit_buttons([xx+bound_width[0]+5 + string_width(deploy_text), yy+bound_height[0]-2],current_squad.formation_place,[1,1],c_green,,,,true);
				draw_set_color(c_red);
				draw_text_transformed(xx+bound_width[0]+5+ string_width(deploy_text) + string_width(current_squad.formation_place)+9, yy+bound_height[0], "column",1,1,0);
				draw_set_color(c_gray);
				var point_in_button = (point_in_rectangle(
						mouse_x,
						mouse_y,
						button [0], 
						button[1], 
						button[2], 
						button[3]
					));
				if (array_length(current_squad.formation_options)>1){
					if (point_in_button){
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
						if (!point_in_rectangle(
								mouse_x,
								mouse_y,
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
			button = draw_unit_buttons([xx+bound_width[0]+5, yy+bound_height[0]+150],"Reset Squad Loadout",[1,1],c_green,,,,true);
			if (point_and_click(button)){
				current_squad.sort_squad_loadout();
				reset_squad_surface();
			}
			var _button_text = current_squad.allow_bulk_swap ? "Exclude from mass" : "Allow mass";
			button = draw_unit_buttons([xx+bound_width[0]+5, yy+bound_height[0]+200],_button_text,[1,1],c_green,,,,true);
			if (point_and_click(button)){
				current_squad.allow_bulk_swap = !current_squad.allow_bulk_swap;
			}
			if (scr_hit(button)){
				tooltip_draw("Enable to stop this squad from being included in mass equipment changes in chapter settings");
			}		
			
			if (unit_rollover){
				if (point_in_rectangle(mouse_x, mouse_y, xx+25, yy+144, xx+925, yy+981)){
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
					if (point_in_rectangle(mouse_x, mouse_y, unit_sprite_coords[0], unit_sprite_coords[1], unit_sprite_coords[2], unit_sprite_coords[3]) && !exit_period && unit_rollover){
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
				if (point_in_rectangle(mouse_x, mouse_y, xx+25, yy+144, xx+525, yy+981) && !exit_period){
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
			if (exit_period and !point_in_rectangle(mouse_x, mouse_y, xx+25, yy+144, xx+525, yy+981)){
				exit_period=false;
			}
		}
	}
}