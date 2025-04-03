// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_manage_task_selector(){
	if (exit_button.draw_shutter(xx+400,yy+70, "Exit", 0.5, true)){
			if (is_real(selection_data.system) && selection_data.system <= 10 && selection_data.system >= 0){
		        managing = selection_data.system;
				update_general_manage_view();
			} else {
				exit_adhoc_manage();
				exit;
			}
		}
		man_count = array_sum(man_sel);
		if (selection_data.purpose_code!="manage"){
			if ((man_count==0 || man_count>selection_data.number)){
				proceed_button.draw_shutter(xx+1110,yy+70, "Proceed", 0.5, false);
			} else {
				if (proceed_button.draw_shutter(xx+1110,yy+70, "Proceed", 0.5, true)){
	                selections = [];
	                var unit;
	                for (var i=0; i<array_length(display_unit);i++){
	                	if (ma_name[i]== "") then continue;
	                	if (man_sel[i]){
	                		switch(selection_data.purpose_code){
	                			case "forge_assignment":
					                var forge = selection_data.feature;
					                forge.techs_working = 0;		                			
		                			forge.techs_working++;
		                			unit = display_unit[i];
		                			unit.unload(selection_data.planet, selection_data.system);
		                			unit.job = {
		                				type:"forge", 
		                				planet:selection_data.planet, 
		                				location:selection_data.system.name
		                			};
	                				break;
								case "captain_promote":
		                			unit = display_unit[i];
		                			unit.update_role(obj_ini.role[100][eROLE.Captain]);
		                			unit.squad="none";
		                			var start_company = unit.company;
		                			var end_company =  selection_data.system;
		                			var endslot = 0;
		                			for (i=0;i<array_length(obj_ini.name[end_company]);i++){
		                				if (obj_ini.name[end_company][i]==""){
		                					endslot=i;
		                					break;
		                				}
		                			}
		                			scr_move_unit_info(start_company, end_company, unit.marine_number,endslot);
		                			with (obj_ini){
		                				scr_company_order(start_company);
		                				scr_company_order(end_company);
		                			}
		                			managing = end_company;
		                			update_general_manage_view();
		                			exit;
	                				break;
								case "champion_promote":
		                			unit = display_unit[i];
		                			unit.update_role(obj_ini.role[100][eROLE.Champion]);
		                			unit.squad="none";

									with (obj_ini){
		                				scr_company_order(unit.company);
		                			}

		                			managing = selection_data.system;
		                			update_general_manage_view();
		                			exit;
	                				break;
								case "ancient_promote":
		                			unit = display_unit[i];
		                			unit.update_role(obj_ini.role[100][eROLE.Ancient]);
		                			unit.squad="none";


									with (obj_ini){
		                				scr_company_order(unit.company);
		                			}

		                			managing = selection_data.system;
		                			update_general_manage_view();
		                			exit;
	                				break;
								case "chaplain_promote":
		                			unit = display_unit[i];
		                			unit.squad="none";
		                			var start_company = unit.company;
		                			var end_company =  selection_data.system;
		                			var endslot = 0;
		                			for (i=0;i<array_length(obj_ini.name[end_company]);i++){
		                				if (obj_ini.name[end_company][i]==""){
		                					endslot=i;
		                					break;
		                				}
		                			}
		                			scr_move_unit_info(start_company, end_company, unit.marine_number,endslot);
		                			with (obj_ini){
		                				scr_company_order(start_company);
		                				scr_company_order(end_company);
		                			}
		                			managing = end_company;
		                			update_general_manage_view();
		                			exit;
	                				break;
								case "apothecary_promote":
		                			unit = display_unit[i];
		                			unit.squad="none";
		                			var start_company = unit.company;
		                			var end_company =  selection_data.system;
		                			var endslot = 0;
		                			for (i=0;i<array_length(obj_ini.name[end_company]);i++){
		                				if (obj_ini.name[end_company][i]==""){
		                					endslot=i;
		                					break;
		                				}
		                			}
		                			scr_move_unit_info(start_company, end_company, unit.marine_number,endslot);
		                			with (obj_ini){
		                				scr_company_order(start_company);
		                				scr_company_order(end_company);
		                			}
		                			managing = end_company;
		                			update_general_manage_view();
		                			exit;
	                				break;
								case "tech_marine_promote":
		                			unit = display_unit[i];
		                			unit.squad="none";
		                			var start_company = unit.company;
		                			var end_company =  selection_data.system;
		                			var endslot = 0;
		                			for (i=0;i<array_length(obj_ini.name[end_company]);i++){
		                				if (obj_ini.name[end_company][i]==""){
		                					endslot=i;
		                					break;
		                				}
		                			}
		                			scr_move_unit_info(start_company, end_company, unit.marine_number,endslot);
		                			with (obj_ini){
		                				scr_company_order(start_company);
		                				scr_company_order(end_company);
		                			}
		                			managing = end_company;
		                			update_general_manage_view();
		                			exit;
	                				break;
								case "librarian_promote":
		                			unit = display_unit[i];
		                			unit.squad="none";
		                			var start_company = unit.company;
		                			var end_company =  selection_data.system;
		                			var endslot = 0;
		                			for (i=0;i<array_length(obj_ini.name[end_company]);i++){
		                				if (obj_ini.name[end_company][i]==""){
		                					endslot=i;
		                					break;
		                				}
		                			}
		                			scr_move_unit_info(start_company, end_company, unit.marine_number,endslot);
		                			with (obj_ini){
		                				scr_company_order(start_company);
		                				scr_company_order(end_company);
		                			}
		                			managing = end_company;
		                			update_general_manage_view();
		                			exit;
	                				break;
	                			case "hunt_beast":
	                			case "train_forces":
	                				unit = display_unit[i];
	                				unit.job = {
	                					type:selection_data.purpose_code, 
	                					planet:selection_data.planet, 
	                					location:selection_data.system.name
	                				};
	                				unit.unload(selection_data.planet, selection_data.system);
	            					break;										
	                		}		                		
	                	} else {
	                		switch(selection_data.purpose_code){
	                			case "forge_assignment":
					                var forge = selection_data.feature;
					                forge.techs_working = false;		                			
			                		unit = display_unit[i];
			                		var job = unit.job;
			                		if (job!="none"){
				                		if (job.type=="forge" && job.planet == selection_data.planet){
											unit.job = "none";
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
							break;                		                		
	                }
	                exit_adhoc_manage();
	                exit;			
				}
			}
		}
}
