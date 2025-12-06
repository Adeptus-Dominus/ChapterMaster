function draw_popup_transfer(){
	main_slate.draw_with_dimensions();
	draw_set_color(CM_GREEN_COLOR);
	draw_text(1292, 145, "Transferring");

	draw_set_font(fnt_40k_12);
	if (((unit_role != obj_ini.role[100, 17]) || (obj_controller.command_set[1] != 0)) && (unit_role != "Lexicanum") && (unit_role != "Codiciery")) {
		companies_select.draw();
	}
	if (companies_select.changed){
		target_comp = companies_select.selection_val("val");
	}
	if (cancel_button.draw()){
		instance_destroy();
	}

	if (transfer_button.draw(target_comp != company && target_comp!=-1)){
		transfer_marines();
	}
}

function transfer_marines(){
    var mahreens=0,w=0,god=0,vehi=0,god2=0;


    mahreens = find_company_open_slot(target_comp);

    for (w=1;w<101;w++){// Gets the number of vehicles in the target company
		if (god2==0 and obj_ini.veh_role[target_comp,w]=""){
			god2=1;
			vehi=w;
			break;
		}
	}

    // The MAHREENS and TARGET/FROM seems to check out
    var unit, move_squad, move_members, moveable, squad;
    for (w=0;w<array_length(obj_controller.display_unit);w++){
        if (obj_controller.man_sel[w]==1){
            if (obj_controller.man[w]=="man"&& is_struct(obj_controller.display_unit[w])){
                moveable=true;
                unit = obj_controller.display_unit[w];
                if (unit.squad != "none"){   // this evaluates if you are tryin to move a whole squad and if so moves teh squad to a new company
                    var move_squad = unit.squad;
                    squad = obj_ini.squads[move_squad];
                    move_members = squad.members;
                    for (var mem = 0;mem<array_length(move_members);mem++){//check all members have been selected and are in the same company
                        if (w+mem<array_length(obj_controller.display_unit)){
                            if (!is_struct(obj_controller.display_unit[w+mem])) then continue;
                            if (obj_controller.man_sel[w+mem]!=1 || obj_controller.display_unit[w+mem].squad != move_squad){
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
                        for (var mem = 0;mem<array_length(move_members);mem++){
                            obj_controller.man_sel[w+mem] = 0;
                            var member_unit = fetch_unit(move_members[mem]);
                            scr_move_unit_info(member_unit.company,target_comp,member_unit.marine_number,mahreens, false);
                            obj_ini.TTRPG[target_comp][mahreens].squad = move_squad;
                            squad.members[mem][0] = target_comp;
                            squad.members[mem][1] = mahreens;
                            mahreens++;
                        }
                        squad.base_company = target_comp;
                    }
                } else {moveable=false}
                //move individual
                if (!moveable){
                    scr_move_unit_info(unit.company,target_comp,unit.marine_number,mahreens, true);
                    mahreens++;
                }
                var check=0;
            }else if(obj_controller.man[w]=="vehicle" && is_array(obj_controller.display_unit[w])){ // This seems to execute the correct number of times
                var check=0;
                var veh_data = obj_controller.display_unit[w];
				// Check if the target company is within the allowed range
                if (target_comp >= 1) and (target_comp <= 10) {
                    obj_ini.veh_race[target_comp][vehi]=obj_ini.veh_race[veh_data[0]][veh_data[1]];
                    obj_ini.veh_loc[target_comp][vehi]=obj_ini.veh_loc[veh_data[0]][veh_data[1]];
                    obj_ini.veh_role[target_comp][vehi]=obj_ini.veh_role[veh_data[0]][veh_data[1]];
                    obj_ini.veh_wep1[target_comp][vehi]=obj_ini.veh_wep1[veh_data[0]][veh_data[1]];
                    obj_ini.veh_wep2[target_comp][vehi]=obj_ini.veh_wep2[veh_data[0]][veh_data[1]];
                    obj_ini.veh_wep3[target_comp][vehi]=obj_ini.veh_wep3[veh_data[0]][veh_data[1]];
                    obj_ini.veh_upgrade[target_comp][vehi]=obj_ini.veh_upgrade[veh_data[0]][veh_data[1]];
                    obj_ini.veh_acc[target_comp][vehi]=obj_ini.veh_acc[veh_data[0]][veh_data[1]];
                    obj_ini.veh_hp[target_comp][vehi]=obj_ini.veh_hp[veh_data[0]][veh_data[1]];
                    obj_ini.veh_chaos[target_comp][vehi]=obj_ini.veh_chaos[veh_data[0]][veh_data[1]];
                    obj_ini.veh_pilots[target_comp][vehi]=0;
                    obj_ini.veh_lid[target_comp][vehi]=obj_ini.veh_lid[veh_data[0]][veh_data[1]];
                    obj_ini.veh_wid[target_comp][vehi]=obj_ini.veh_wid[veh_data[0]][veh_data[1]];

                    destroy_vehicle(veh_data[0],veh_data[1]);

                    vehi++;
                }

            }
        }
	
    }

    // Check this

    if (obj_controller.managing>0){
        with(obj_controller){scr_management(1);}
    }
        obj_ini.selected_company=company;
        obj_ini.temp_target_company=target_comp;
    with(obj_ini){
        for (var co=0;co<11;co++){
            scr_company_order(co);
            scr_vehicle_order(co);
        }
    }

    with(obj_controller){
        // man_current=0;
        var i=-1;
        man_size=0;
        selecting_location="";
        selecting_types="";
        selecting_ship=-1;
        
        if (obj_controller.managing>0){
            reset_manage_arrays();
            alll=0;
            update_general_manage_view();
        }
    }

    with(obj_managment_panel){instance_destroy();}

    obj_controller.cooldown=10;
    instance_destroy();
}


function set_up_transfer_popup(){
	if (instance_number(obj_popup)==0){
        var pip=instance_create(0,0,obj_popup);
        pip.type=5.1;
        pip.company=managing;

        var god=0,_marine_count=0,_vehicle_count=0,checky=0,check_number=0;
        var _min_exp = 0;
        for (var f=0; f<array_length(display_unit); f++){

            if (! (man_sel[f]==1)){
                continue;
            }
            if (god==1) then break;
            if (god==0) and (man[f]=="man"){
                god=1;
                pip.unit_role=ma_role[f];
                _min_exp = min(_min_exp, ma_exp[f]);
            }
            if (god==0) and (man[f]=="vehicle"){
                god=1;
                pip.unit_role = ma_role[f];
            }

            if (man[f] == "man"){
                _marine_count+=1;
                checky=1;
                if (ma_role[f]==obj_ini.role[100][7]) then checky=0;
                if (ma_role[f]==obj_ini.role[100][14]) then checky=0;
                if (ma_role[f]==obj_ini.role[100][15]) then checky=0;
                if (ma_role[f]==obj_ini.role[100][16]) then checky=0;
                if (ma_role[f]==obj_ini.role[100][17]) then checky=0;
                if (checky==1) then check_number+=1;
            }
            else if (man[f] == "vehicle"){
                _vehicle_count+=1;
            }

        }
        if (_vehicle_count>1) then pip.unit_role="Vehicles";        
        if (_marine_count>1) then pip.unit_role="Marines";
        if (_marine_count>0) and (_vehicle_count>0) then pip.unit_role="Units";
        pip.units=_marine_count+_vehicle_count;
        if (_marine_count>0 && check_number>0 && !command_set[1]){
            cooldown=8000;
            with(pip){
            	instance_destroy();
            }
        } else {
            with (pip){
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
                // Inside with(pip), 'min_exp' refers to pip.min_exp
                if (unit_role == "Vehicles"){
                    min_exp = -1; // sentinel to bypass gating only for vehicles
                }
                target_company_radio(min_exp);
                transfer_button = new UnitButtonObject(
                    {
                        x1: 1450, 
                        y1: 491,
                        style : "pixel",
                        label : "Transfer"
                    }
                );               
            }
        }
    }
}