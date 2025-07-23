// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_manage_task_selector(){
	if (exit_button.draw_shutter(400,70, "Exit", 0.5, true)){
		if (selection_data.purpose_code == "artifact_equip"){
			scr_toggle_lib();
			obj_controller.menu_artifact = selection_data.artifact;
			equip_artifact_popup_setup();
			exit;
		}

		if (struct_exists(selection_data, "target_company")){
			if (is_real(selection_data.target_company) && selection_data.target_company <= 10 && selection_data.target_company >= 0){
		        managing = selection_data.target_company;
				update_general_manage_view();
				exit;
			}
		} else {
			exit_adhoc_manage();
			exit;
		}
	}
	if (selection_data.select_type == MissionSelectType.Units){
		man_count = array_sum(man_sel);
	} else {
		man_count = array_length(company_data.selected_squads);
	}
	if (selection_data.purpose_code!="manage"){
		if ((man_count==0 || man_count>selection_data.number)){
			proceed_button.draw_shutter(1110,70, "Proceed", 0.5, false);
		}  else if (proceed_button.draw_shutter(1110,70, "Proceed", 0.5, true)){
			if (selection_data.select_type == MissionSelectType.Units){
				task_selector_man_manage();
			} else {
				task_selector_squad_manage();
			}
		}
	}
}
function task_selector_squad_manage(){
    for (var i=0; i<array_length(company_data.selected_squads);i++){
        var _squad = obj_ini.squads[company_data.selected_squads[i]];
        switch(selection_data.purpose_code){
            case "protect_raiders":
        		init_protect_raider_mission(_squad);
                break;
        }
    }
}

function task_selector_man_manage(){
	man_count = array_sum(man_sel);
    selections = [];
    var _unit;
	for (var i=0; i<array_length(display_unit);i++){
    	if (ma_name[i]== "") then continue;
    	if (man_sel[i]){
    		_unit =   display_unit[i];
    		switch(selection_data.purpose_code){
    			case "forge_assignment":
	                var _forge = selection_data.feature;
	                _forge.techs_working = 0;		                			
        			_forge.techs_working++;
        			_unit.unload(selection_data.planet, selection_data.system);
        			_unit.job = {
        				type:"forge", 
        				planet:selection_data.planet, 
        				location:selection_data.system.name
        			};
    				break;
				case "captain_promote":
        			_unit.update_role(obj_ini.role[100][eROLE.Captain]);
        			_unit.squad="none";
        			var _start_company = _unit.company;
        			var _end_company =  selection_data.target_company;
        			var _endslot = find_company_open_slot(end_company);
        			scr_move_unit_info(_start_company, _end_company, _unit.marine_number,_endslot);
        			with (obj_ini){
        				scr_company_order(start_company);
        				scr_company_order(_end_company);
        			}
        			managing = _end_company;
        			update_general_manage_view();
        			exit;
    				break;
				case "champion_promote":
        			_unit.update_role(obj_ini.role[100][eROLE.Champion]);
        			_unit.squad="none";

					with (obj_ini){
        				scr_company_order(_unit.company);
        			}

        			managing = selection_data.target_company;
        			update_general_manage_view();
        			exit;
    				break;
				case "ancient_promote":
        			_unit.update_role(obj_ini.role[100][eROLE.Ancient]);
        			_unit.squad="none";


					with (obj_ini){
        				scr_company_order(_unit.company);
        			}

        			managing = selection_data.target_company;
        			update_general_manage_view();
        			exit;
    				break;
				case "chaplain_promote":
        			_unit.squad="none";
        			var start_company = _unit.company;
        			var end_company =  selection_data.target_company;
        			var endslot = find_company_open_slot(end_company);
        			scr_move_unit_info(start_company, end_company, _unit.marine_number,endslot);
        			with (obj_ini){
        				scr_company_order(start_company);
        				scr_company_order(end_company);
        			}
        			managing = end_company;
        			update_general_manage_view();
        			exit;
    				break;
				case "apothecary_promote":
        			_unit.squad="none";
        			var start_company = _unit.company;
        			var end_company =  selection_data.target_company;
        			var endslot = find_company_open_slot(end_company);
        			scr_move_unit_info(start_company, end_company, _unit.marine_number,endslot);
        			with (obj_ini){
        				scr_company_order(start_company);
        				scr_company_order(end_company);
        			}
        			managing = end_company;
        			update_general_manage_view();
        			exit;
    				break;
				case "tech_marine_promote":
        			_unit.squad="none";
        			var start_company = _unit.company;
        			var end_company =  selection_data.target_company;
        			var endslot = find_company_open_slot(end_company);
        			scr_move_unit_info(start_company, end_company, _unit.marine_number,endslot);
        			with (obj_ini){
        				scr_company_order(start_company);
        				scr_company_order(end_company);
        			}
        			managing = end_company;
        			update_general_manage_view();
        			exit;
    				break;
				case "librarian_promote":
        			_unit.squad="none";
        			var start_company = _unit.company;
        			var end_company =  selection_data.target_company;
        			var endslot = find_company_open_slot(end_company);
        			scr_move_unit_info(start_company, end_company, _unit.marine_number,endslot);
        			with (obj_ini){
        				scr_company_order(start_company);
        				scr_company_order(end_company);
        			}
        			managing = end_company;
        			update_general_manage_view();
        			exit;
    				break;
    			case "hunt_beast":
    				_unit.job = {
    					type:selection_data.purpose_code, 
    					planet:selection_data.planet, 
    					location:selection_data.system.name
    				};
    				_unit.unload(selection_data.planet, selection_data.system);
					break;	
				case "train_forces":
    				_unit.job = {
    					type:selection_data.purpose_code, 
    					planet:selection_data.planet, 
    					location:selection_data.system.name
    				};
    				_unit.unload(selection_data.planet, selection_data.system);
    				init_train_forces_mission(selection_data.planet, selection_data.system,selection_data.array_slot, _unit); 
    				obj_controller.close_popups = false;
	                exit_adhoc_manage();
	                exit;
	               	break;
	            case "artifact_equip":
	               	scr_toggle_lib();
	               	var _arti = fetch_artifact(selection_data.artifact);
	               	_arti.equip_on_unit(_unit, selection_data.slot);
					scr_toggle_lib();
					obj_controller.menu_artifact = selection_data.artifact;	               	
	               	exit;
	               	break;
    		}		                		
    	} else {
    		switch(selection_data.purpose_code){
    			case "forge_assignment":
	                var forge = selection_data.feature;
	                forge.techs_working = false;		                			
            		_unit = display_unit[i];
            		var job = _unit.job;
            		if (job!="none"){
                		if (job.type=="forge" && job.planet == selection_data.planet){
							_unit.job = "none";
							forge.techs_working--;
                		}
                	};
                	break;
            }
    	}
    }
    switch(selection_data.purpose_code){
    	case "forge_assignment":
    		specialist_point_handler.calculate_research_points();
    		break;
    	case "hunt_beast":
			var problem_slot = selection_data.array_slot;
			init_beast_hunt_mission(selection_data.planet, selection_data.system,problem_slot);
			obj_controller.close_popups = false;
			break;  
    }
    exit_adhoc_manage();
    exit;			
}
