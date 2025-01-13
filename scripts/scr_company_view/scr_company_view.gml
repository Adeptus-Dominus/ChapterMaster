function reset_ship_manage_arrays() {
    with (obj_controller) {
        array_resize(sh_ide, 0);
        array_resize(sh_uid, 0);
        array_resize(sh_name, 0);
        array_resize(sh_class, 0);
        array_resize(sh_loc, 0);
        array_resize(sh_hp, 0);
        array_resize(sh_cargo, 0);
        array_resize(sh_cargo_max, 0);
    }
}

function reset_manage_arrays() {
    with (obj_controller) {
        display_unit=[];
        man=[];
        ide=[];
        man_sel=[];
        ma_lid=[];
        ma_wid=[];
        ma_race=[];
        ma_loc=[];
        ma_name=[];
        ma_role=[];
        ma_gear=[];
        ma_mobi=[];
        ma_wep1=[];
        ma_wep2=[];
        ma_armour=[];
        ma_health=[];
        ma_chaos=[];
        ma_exp=[];
        ma_promote=[];
        ma_god=[];
        ma_view = [];
        squad = [];
    }
    reset_ship_manage_arrays();
}

function find_company_open_slot(target_company){
	good = -1;
	for (var i = 0;i<array_length(obj_ini.name[target_company]);i++){
        if (obj_ini.name[target_company][i]=="") or (obj_ini.role[target_company][i]==""){
        	good=i;
        	break;
        }
	}
	return good;
}

function add_man_to_manage_arrays(unit){
	with (obj_controller){
       	var unit_location = unit.marine_location();
        array_push(man,"man");
        array_push(ide,unit.marine_number);
        array_push(man_sel,0);
        array_push(ma_lid,unit.ship_location);
        array_push(ma_wid,unit.planet_location);
        array_push(ma_race ,unit.race());
        array_push(ma_loc,unit_location[2]);
        array_push(ma_name ,unit.name());
        array_push(ma_role,unit.role());
        array_push(ma_wep1,unit.weapon_one());
        array_push(ma_wep2,unit.weapon_two());
        array_push(ma_armour,unit.armour());
        array_push(ma_gear,unit.gear());
        array_push(ma_health,unit.hp());
        array_push(ma_mobi,unit.mobility_item());
        array_push(ma_chaos,unit.corruption);
        array_push(ma_exp,unit.experience);
        array_push(ma_promote,0);
        array_push(display_unit,unit);
        array_push(ma_god,0);
        array_push(ma_view,true);
        array_push(squad, -1);
	}
}

function update_man_manage_array(index){
		with (obj_controller){
			var unit = display_unit[index];
			ma_lid[index]=unit.ship_location;
			ma_wid[index]=unit.planet_location;
			ma_loc[index]=unit.marine_location()[2];
			ma_role[index]=unit.role();
			ma_gear[index]=unit.gear();
			ma_mobi[index]=unit.mobility_item();
			ma_wep1[index]=unit.weapon_one();
		    ma_wep2[index]=unit.weapon_two();
			ma_armour[index]=unit.armour();
		}
}

function add_vehicle_to_manage_arrays(unit){
	with (obj_controller){
		array_push(display_unit,unit);
		array_push(man,"vehicle");
		array_push(ide,unit[1]);
		array_push(man_sel,0);
		array_push(ma_lid,obj_ini.veh_lid[unit[0]][unit[1]]);
		array_push(ma_wid,obj_ini.veh_wid[unit[0]][unit[1]]);
		array_push(ma_race,obj_ini.veh_race[unit[0]][unit[1]]);
		if (obj_ini.veh_lid[unit[0]][unit[1]]>-1){
			array_push(ma_loc,obj_ini.ship_location[obj_ini.veh_lid[unit[0]][unit[1]]]);
		} else {
			array_push(ma_loc,obj_ini.veh_loc[unit[0]][unit[1]]);
		}
		array_push(ma_name ,"");
		array_push(ma_role,obj_ini.veh_role[unit[0]][unit[1]]);
		array_push(ma_wep1,obj_ini.veh_wep1[unit[0]][unit[1]]);
		array_push(ma_wep2,obj_ini.veh_wep2[unit[0]][unit[1]]);
		array_push(ma_armour,obj_ini.veh_wep3[unit[0]][unit[1]]);
		array_push(ma_gear,obj_ini.veh_upgrade[unit[0]][unit[1]]);
		array_push(ma_health,obj_ini.veh_hp[unit[0]][unit[1]]);
		array_push(ma_mobi,obj_ini.veh_acc[unit[0]][unit[1]]);
		array_push(ma_chaos,0);
		array_push(ma_exp,0);
		array_push(ma_promote,0);
		array_push(ma_god,0);
		array_push(ma_view,true);
		array_push(squad, -1);
	}
}


function scr_company_view(company) {
    if (company < 0 || company > 10){
        var error_message = $"scr_company_view passed bad company:\n{company}";
        show_error(error_message, true);
    };

    var mans, squads, squad_type, squad_loc, squad_members, unit, unit_loc;
    mans = 0;
    squads = 0;
    squad_type = "";
    squad_loc = 0;
    squad_members = 0;
    reset_manage_arrays();
    sel_uni = array_create(20, "");
    sel_veh = array_create(20, "");

    sel_uni[1] = "Command";

    // Processing marines
    var company_length = array_length(obj_ini.TTRPG[company]);

    for (var v = 0; v < company_length; v++) {
        unit = obj_ini.TTRPG[company][v];

        if (unit.name() != "") {
            unit_loc = unit.marine_location();

            // Check if unit is on a lost ship
            if (
                unit_loc[0] == location_types.ship &&
                obj_ini.ship_location[unit_loc[1]] == "Lost"
            ) {
                continue;
            }

            mans += 1;
            add_man_to_manage_arrays(unit);
            var go = 0, op = 0;
            if (!unit.IsSpecialist()) {
                for (var j = 0; j < 20; j++) {
                    if (sel_uni[j] == "" && op == 0) {
                        op = j;
                        break;
                    }
                    if (sel_uni[j] == unit.role()) {
                        go = 1;
                    }
                }
                if (go == 0) {
                    sel_uni[op] = unit.role();
                }
            }
        }
    }

    // Processing vehicles
    var veh_race_length = array_length(obj_ini.veh_race[company]);

    for (var i = 0; i < veh_race_length; i++) {
        // Check if vehicle race is valid
        if (obj_ini.veh_race[company][i] == 0) {
            continue;
        }

        // Check if unit is on a lost ship
        if (
            obj_ini.veh_lid[company][i] > -1 &&
            obj_ini.ship_location[obj_ini.veh_lid[company][i]] == "Lost"
        ) {
            continue
        }

        add_vehicle_to_manage_arrays([company, i]);

        // Select All Vehicle Setup
        var go = 0, op = 0;
        for (var p = 0; p < 20; p++){
            if (sel_veh[p] == "" && op == 0){
                op = p;
            }
            if (sel_veh[p] == obj_ini.veh_role[company][i]){
                go = 1;
            }
        }
        if (go == 0){
            sel_veh[op] = obj_ini.veh_role[company][i];
        }
    }

    man_current = 0;
    man_max = array_length(display_unit) + 2;
    man_see = 38 - 4;
    other_manage_data();
}

function other_manage_data(){
	var mans, bad, squads, squad_type, squad_loc, squad_members, unit, unit_loc;
	mans=0;
	bad=0;
	squads=0;
	squad_type="";
	squad_loc=0;
	squad_members=0;
	for (var v = 0; v < array_length(display_unit); v++){
		if (!is_struct(display_unit[v])) then continue;
		unit = display_unit[v];
		unit_loc = unit.marine_location();
		if (unit_loc[0]==location_types.ship){
			if (unit_loc[2]=="Lost") then ma_loc[v]="Lost";
		}					
	    // Select All Infantry Setup
	    go=0;
		op=0;
	    // Squad setup
	    // 137 ;
	    // Should have this be only ran for MAN, somehow run it a second time for VEHICLE
	    if (squads>0){
	    	var n=1;
			if (is_specialist(squad_type)) or (squad_type=ma_role[v]) then n=0;
	        // if units are not in a squad
	        if (unit.squad == "none"){


	            if (is_specialist(squad_type,"heads")) then n=1;
	            if (squad_type==obj_ini.role[100][6]) and (squad_type!=ma_role[v]) and (squad_type!="Venerable "+string(ma_role[v])) then n=2;
	            if (squad_type==obj_ini.role[100][6]) and (ma_role[v]=obj_ini.role[100][6]) then n=0;
	            if (squad_type==obj_ini.role[100][6]) and (ma_role[v]="Venerable "+string(obj_ini.role[100][6])) then n=0;
	            if (squad_type="Venerable "+string(obj_ini.role[100][6])) and (ma_role[v]=obj_ini.role[100][6]) then n=0;

				
					//if units are on different ships but the ships are in the same location group them together
					//else split units up in selection area
	 			if (squad_loc[0]==location_types.ship){
	            	if (unit_loc[0]==squad_loc[0]) and (unit_loc[2]==squad_loc[2]){
	            		n=0;
	            	}else n=1;
	        	} else if (unit_loc[0]!=squad_loc[0]) or(unit_loc[1]!=squad_loc[1]) or(unit_loc[2]!=squad_loc[2]) then n=1;

	            if (squad_members+1>10) then n=1;

	            switch (n){
	            	case 0:
	            		squad_members+=1;
	            		squad_type=ma_role[v];
	            		squad[v]=squads;
	            		break;
	            	case 1:
	            		squads+=1;
	            		squad_members=1;
	            		squad_type=ma_role[v];
	            		squad[v]=squads;
	            		squad_loc=unit_loc;
	            		break;
	            	case 2:
	            		squad[v]=0;
	            		break
	            }    	                    
				//if units are in a squad
	       	} else{
	       		///if units are on different ships but the ships are in the same location group them together
	       		if (squad_type == unit.squad) and (unit_loc[0]==squad_loc[0]) and (unit_loc[2]==squad_loc[2]) and ((squad_loc[0] == location_types.ship) or (unit_loc[1]==squad_loc[1]) ){
	       			squad_members+=1;
	       			squad[v]=squads;
	       		} else {
	       			squads+=1;
	       			squad_members=1;
	       			squad_type = unit.squad;
	       			squad[v]=squads;
	       			squad_loc=unit_loc;
	       		}
	       	}
	    }
	    if (squads=0){
	        squads+=1;
	        squad_members=1;
	        if (unit.squad == "none"){
	        	squad_type=ma_role[v];
	        } else {
	        	squad_type = unit.squad;
	        }
	        squad[v]=squads;
	        squad_loc=unit_loc;
	    }
        // TODO: connect this logic with the get_unit_promotion_options() to reduce verboseness;
	    //requirements to be promoted through companies index 0 = command company requirement
	    var company_promotion_limits = [0,100,65,65,65,65,45,45,35,25,0];
	    // Right here is where the promotion check will go
	    // If EXP is enough for that company then ma_promote[i]=1
	    if (ma_role[v]==obj_ini.role[100][3]) or (ma_role[v]==obj_ini.role[100][4]){
	        if (unit.company==1) and (ma_exp[v]>=140) then ma_promote[v]=1;
	        if (ma_health[v]<=10) then ma_promote[v]=10;
	    }
	    if (unit.role()=obj_ini.role[100][6]) and (ma_exp[v]>=400) then ma_promote[v]=1;
	    if (unit.role()=obj_ini.role[100][15]) or (ma_role[v]=obj_ini.role[100][14]) then ma_promote[v]=1;
	    if (unit.role()=obj_ini.role[100][16]) then ma_promote[v]=1;

		var target_company = 0;
	    if (unit.IsSpecialist("rank_and_file")){
			if (unit.company >= 8) then target_company = unit.company - 1;
			else if (unit.company >= 6) then target_company = 5;
			else if (unit.company >= 2) then target_company = 1;
	    	var promotion_limit = company_promotion_limits[target_company]
			if (unit.experience>=promotion_limit && promotion_limit>0){
	    		ma_promote[v]=1;
	    	}
	    	if (ma_health[v]<=10) then ma_promote[v]=10;	                	
	    } else if  (ma_role[v]=obj_ini.role[100][5]){
	    	var promotion_limit = company_promotion_limits[unit.company - 1]
	    	if (unit.experience>=promotion_limit+25 && promotion_limit>0){

	    	}
	    }

	    if (!obj_controller.command_set[2]) and (!ma_promote[v]) then ma_promote[v]=1;
	}
}

function filter_and_sort_company(type, specific){
	var i ,j, limit;
	function switchy(a, b){
        var tempman = man[a];
        var tempide =ide[a];
        var tempsel =man_sel[a];
        var templid =ma_lid[a];
        var tempwid =ma_wid[a];
        var temprace =ma_race[a];
        var temploc =ma_loc[a];
        var tempname =ma_name[a];
        var temprole =ma_role[a];
        var tempwep =ma_wep1[a];
        var tempwep2 =ma_wep2[a];
        var temparm =ma_armour[a];
        var temphealth =ma_health[a];
        var tempcha =ma_chaos[a];
        var tempexp =ma_exp[a];
        var tempprom =ma_promote[a];
        var tempdis =display_unit[a];
        var tempview = ma_view[a];
        var temp_squad = squad[a]

        man[a]=man[b];
        ide[a]=ide[b];
        man_sel[a]=man_sel[b];
        ma_lid[a]=ma_lid[b];
        ma_wid[a]= ma_wid[b];
        ma_race[a]=ma_race[b];
        ma_loc[a]=ma_loc[b];
        ma_name[a]= ma_name[b];
        ma_role[a]=ma_role[b];
        ma_wep1[a]= ma_wep1[b];
        ma_wep2[a]= ma_wep2[b];
        ma_armour[a]=ma_armour[b];
        ma_health[a]=ma_health[b];
        ma_chaos[a]=ma_chaos[b];
        ma_exp[a]=ma_exp[b];
        ma_promote[a]=ma_promote[b];
        display_unit[a] =display_unit[b];
        ma_view[a] =ma_view[b];
        squad[a] = squad[b]

        man[b]=tempman;
        ide[b]=tempide;
        man_sel[b]=tempsel;
        ma_lid[b]=templid;
        ma_wid[b]= tempwid;
        ma_race[b]=temprace;
        ma_loc[b]= temploc;
        ma_name[b]= tempname;
        ma_role[b]=temprole;
        ma_wep1[b]= tempwep;
        ma_wep2[b]= tempwep2;
        ma_armour[b]= temparm;
        ma_health[b]= temphealth;
        ma_chaos[b]= tempcha;
        ma_exp[b]= tempexp;
        ma_promote[b]= tempprom;
        display_unit[b] = tempdis;  
        ma_view[b] = tempview;
        squad[b] = temp_squad;
	}
	if (type=="stat"){
		var swapped;
		with (obj_controller){
			for (i = 0; i<array_length(display_unit);i++){
				//if (man[i] != "man") continue;
				swapped=false;
				limit = array_length(display_unit)-i;
				for (j=0; j<limit-1;j++){
					if (man[j] != "man"){
						if (man[j+1] == "man"){
							switchy(j,j+1);
							swapped=true;
						}
					} else {
						if (man[j+1] == "man"){
							if (display_unit[j][$specific]<display_unit[j+1][$specific]){
								switchy(j,j+1);
								swapped = true;
							}
						}
					}
				}
				//if (swapped == false) then break;
			}
		}
	}
}

function switch_view_company(new_view){

	with (obj_controller){
		if (new_view<1) then exit;	
		filter_mode = false;
		text_bar=0;
		if (managing<=10 && managing>=0){
			if (struct_exists(company_data, "reset_squad_surface")){
				company_data.reset_squad_surface();
			}
		}
		scr_ui_refresh();

		managing = new_view;
		if (new_view != 0 ){
			with(obj_managment_panel){instance_destroy();}
		}
		if (new_view>10){
			view_squad=false;
			company_data={};
			scr_special_view(new_view);
		} else {
			with (obj_ini){
				scr_company_order(new_view);
			}
			scr_company_view(new_view);		
			company_data = new CompanyStruct(managing);
		}
	}
}
function company_manage_actions(){
	var onceh=0;
	var xx=__view_get( e__VW.XView, 0 );
	var yy=__view_get( e__VW.YView, 0 );

    // Back out from company
    if (point_and_click([xx+23,yy+80,xx+95,yy+128])){
        managing=0;
        cooldown=8000;
        scr_ui_refresh();
        scr_management(1);
        cooldown=8000;
        click=1;
        popup=0;
        selected=0;
        hide_banner=1;
        view_squad=false;
        unit_profile=false;
    }
    // Previous company
    if (point_and_click([xx+424, yy+80,xx+496,yy+128]) || keyboard_check_pressed(ord(string("N")))){
    	var new_view = managing == 1 ? 15 : managing-1;
    	switch_view_company(new_view)
    }

    // Next company
    if (point_and_click([xx+1105, yy+80,xx+1178,yy+128]) || keyboard_check_pressed(ord(string("M")))){
    	var new_view = managing == 15 ? 1 : managing+1;
    	switch_view_company(new_view)
    } 	 	 
}

function ui_manage_hotkeys(){
	if (managing >=0){
	    for (var i=1;i<10;i++){ 
	    	if (press_exclusive(ord(string(i)))){
	    		switch_view_company(i);
	    	}
	    }
		if (press_exclusive(ord("0"))){
			switch_view_company(10);
		}
		else if (press_exclusive(ord("Q"))){
			switch_view_company(11);
		} 
		else if (press_exclusive(ord("E"))){
			switch_view_company(12);
		}
		else if (press_exclusive(ord("R"))){
			switch_view_company(13);
		}
		else if (press_exclusive(ord("T"))){
			switch_view_company(14);
		}
		else if (press_exclusive(ord("Y"))){
			switch_view_company(15);
		}    		
	}	
}
