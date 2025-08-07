function Roster() constructor{
    full_roster_units = [];
    selected_units = [];
    full_roster = {};
    selected_roster = {};
    ships = [];
    roster_location = "";
    roster_planet = 0;
    roster_string = "";
    squad_buttons = [];
    company_buttons = [];
    roster_local_string = "";
    local_button = new ToggleButton();
        local_button.str1 = "Local Forces";
        local_button.text_halign = fa_center;
        local_button.text_color = CM_GREEN_COLOR;
        local_button.button_color = CM_GREEN_COLOR;
        local_button.width = string_width(local_button.str1)+10;
        local_button.active = false;

    select_all_ships = new UnitButtonObject();
        select_all_ships.x1 = 700;
        select_all_ships.y1 = 299;
        select_all_ships.x2 = select_all_ships.x1 + select_all_ships.w;
        select_all_ships.y2 = select_all_ships.y1 + select_all_ships.h;
        select_all_ships.label = "All Ships";
        select_all_ships.color = CM_GREEN_COLOR;

    static only_locals = function(){
        for (var i=0;i<array_length(ships);i++){
            var _button = ships[i];
            _button.active = false;
        }
        local_button.active = true;
    }

    static format_roster_string = function(){
        roster_string = "";
        var _roster_types = struct_get_names(selected_roster);
        for (var i=0;i<array_length(_roster_types);i++){
            var _roster_type_name = _roster_types[i];
            var _roster_type_count = selected_roster[$_roster_type_name];

            roster_string += $"{string_plural_count(_roster_type_name, _roster_type_count)}";
            roster_string += smart_delimeter_sign(_roster_types, i, false);
        }
    }
     static add_role_to_roster = function(role){
        if (struct_exists(full_roster, role)){
            full_roster[$role]++;
        } else {
            full_roster[$role] = 1;
        }
    }
     static add_role_to_selected_roster = function(role){
        if (struct_exists(selected_roster, role)){
            selected_roster[$role]++;
        } else {
            selected_roster[$role] = 1;
        }
    }
    static is_roster_unit_local = function(unit){
        if (is_struct(unit)){
            return (unit.ship_location==-1);
        } else {
            return obj_ini.veh_lid[unit[0]][unit[1]];
        }
    }
    static update_roster = function(){
    	selected_roster = {};
        var _allow_dreadnoughts = false;
    	for (var i=0;i<array_length(selected_units);i++){
    		array_push(full_roster_units, selected_units[i]);
    	}
    	selected_units = [];
    	var _valid_ship = [];
    	for (var i=0;i<array_length(ships);i++){
    		if (ships[i].active){
    			array_push(_valid_ship, ships[i].ship_id);
    		}
    	}	
    	var _valid_squad_types = [];
    	for (var i=0;i<array_length(squad_buttons);i++){
    		if (squad_buttons[i].active){
    			array_push(_valid_squad_types, squad_buttons[i].squad);
                if (squad_buttons[i].squad == "dreadnought"){
                    _allow_dreadnoughts = true;
                }
    		}
    	}
        var _valid_vehicles = [];
        for (var i=0;i<array_length(vehicle_buttons);i++){
            if (vehicle_buttons[i].active){
                array_push(_valid_vehicles, vehicle_buttons[i].vehic_id);
            }
        } 

        var _valid_companies = [];
        for (var i=0;i<array_length(company_buttons);i++){
            if (company_buttons[i].active){
                array_push(_valid_companies, company_buttons[i].company_id);
            }
        }        
    	for (var i=array_length(full_roster_units)-1;i>=0;i--){
    		var _add = false;
    		var _unit = full_roster_units[i];
    		var _valid_type = true;
    		var is_unit = is_struct(_unit);
    		if (is_unit){
                if (!array_contains(_valid_companies, _unit.company)) then continue;
	    		if (_unit.squad_type()!= "none"){
	    			var _valid_type = array_contains(_valid_squad_types,_unit.squad_type());
	    		} else {
                    var _armour_data = _unit.get_armour_data();
                    if (is_struct(_armour_data)){
                        if (_armour_data.has_tag("dreadnought")){
                            _valid_type = _allow_dreadnoughts;
                        }
                    }
                }

	    		if (_unit.ship_location>-1){
		    	 	if (array_contains(_valid_ship ,_unit.ship_location) && _valid_type){
		    	 		_add = true;  	 		
		    	 	}
		    	 } else if (local_button.active && _valid_type){
		    	 	_add = true;
		    	 }
		   	} else {
                if (!array_contains(_valid_companies, _unit[0])) then continue;
                var _role = obj_ini.veh_role[_unit[0]][_unit[1]];
		   		var _vehic_lid = obj_ini.veh_lid[_unit[0]][_unit[1]];
                if (array_contains(_valid_vehicles, _role)){
    		   		if (_vehic_lid>-1){
    		    	 	if (array_contains(_valid_ship ,_vehic_lid)){
    		    	 		_add = true;  	 		
    		    	 	}
    		   		}else if (local_button.active){
                        _add = true;
                    }
                }
		   	}


			 if (_add){
			    array_push(selected_units,_unit);
			    array_delete(full_roster_units, i, 1);
			    if (is_unit){
			    	add_role_to_selected_roster(_unit.role());
			    } else {
			    	add_role_to_selected_roster(obj_ini.veh_role[_unit[0]][_unit[1]]);
			    }
			 }

    	 }

    	format_roster_string();
    }

    static new_squad_button = function(display, squad_id){
        var _button = new ToggleButton();
        display = string_replace(display, " Squad", "");
        if (display != "Command"){
        	display = string_plural(display);
        }
        _button.str1 = display;
        _button.text_halign = fa_center;
        _button.text_color = CM_GREEN_COLOR;
        _button.button_color = CM_GREEN_COLOR;
        _button.width = string_width(display) + 10;
        _button.active = true;
        _button.squad = squad_id;
        array_push(squad_buttons, _button);
    }
    static new_ship_button = function(display, ship_id){
        var _button = new ToggleButton();
        _button.str1 = display;
        _button.text_halign = fa_center;
        _button.text_color = CM_GREEN_COLOR;
        _button.button_color = CM_GREEN_COLOR;
        _button.width = string_width(display)+10;
        _button.active = false;
        _button.ship_id = ship_id;
        array_push(ships, _button);
    }

    static update_local_string  = function(ship_id){
    	var selected_local_roster = {};
    	var possible_local_roster = {};
    	for (var i=0;i<array_length(selected_units);i++){
    		var _unit = selected_units[i];
    		var _ship_loc = (is_struct(_unit)) ? _unit.ship_location : obj_ini.veh_lid[_unit[0]][_unit[1]];
    		if (_ship_loc == ship_id){
	    		var _role =  (is_struct(_unit)) ? _unit.role() : obj_ini.veh_role[_unit[0]][_unit[1]];
		        if (struct_exists(selected_local_roster, _role)){
		            selected_local_roster[$_role]++;
		        } else {
		            selected_local_roster[$_role] = 1;
		        }
		    }  		
    	}
    	for (var i=0;i<array_length(full_roster_units);i++){
    		var _unit = full_roster_units[i];
    		var _ship_loc = (is_struct(_unit)) ? _unit.ship_location : obj_ini.veh_lid[_unit[0]][_unit[1]];
    		if (_ship_loc == ship_id){
	    		var _role =  (is_struct(_unit)) ? _unit.role() : obj_ini.veh_role[_unit[0]][_unit[1]];
		        if (struct_exists(possible_local_roster, _role)){
		            possible_local_roster[$_role]++;
		        } else {
		            possible_local_roster[$_role] = 1;
		        }
		    } 		
    	} 
        roster_local_string = "Selected\n";
        var _roster_types = struct_get_names(selected_local_roster);
        for (var i=0;i<array_length(_roster_types);i++){
            var _roster_type_name = _roster_types[i];
            var _roster_type_count = selected_roster[$_roster_type_name];

            roster_local_string += $"{string_plural_count(_roster_type_name, _roster_type_count)}";
            roster_local_string += smart_delimeter_sign(_roster_types, i, false);
        }

        roster_local_string+="\n"
        roster_local_string += "Remaining\n";
        var _roster_types = struct_get_names(possible_local_roster);
        for (var i=0;i<array_length(_roster_types);i++){
            var _roster_type_name = _roster_types[i];
            var _roster_type_count = possible_local_roster[$_roster_type_name];

            roster_local_string += $"{string_plural_count(_roster_type_name, _roster_type_count)}";
            roster_local_string += smart_delimeter_sign(_roster_types, i, false);
        }          	
    }

    vehicle_buttons = [];

    static new_vehicle_button = function(display, vehicle_type){
        var _button = new ToggleButton();
        _button.str1 = display;
        _button.text_halign = fa_center;
        _button.text_color = CM_GREEN_COLOR;
        _button.button_color = CM_GREEN_COLOR;
        _button.width = string_width(display)+10;
        _button.active = true;
        _button.vehic_id = vehicle_type;
        array_push(vehicle_buttons, _button);
    }
    static determine_full_roster  = function(){
        var _squads = [];
        var _vehicles = [];
        var _company_present = false;
        for (var co=0;co<=obj_ini.companies;co++){
            _company_present = false;
            for (var i=0;i<array_length(obj_ini.role[co]);i++){
                var _allow = false;
                var _unit = fetch_unit([co, i]);
                if (_unit.name() == "" || _unit.role() == "") then continue;
                if (_unit.hp()<=0 || _unit.in_jail()) then continue;
                if (_unit.is_at_location(roster_location)){
                    _allow = true;
                    if (_unit.planet_location>0){
                    	_allow = _unit.planet_location ==roster_planet;
                    }
               
                }
                if (_allow){
                    _company_present = true;
                    array_push(full_roster_units, _unit);
                    add_role_to_roster(_unit.role());
                    if (_unit.squad!="none"){
                        var _squad_type = _unit.squad_type();
                        if (_squad_type!="none"){
                            if (!array_contains(_squads, _squad_type)){
                                array_push(_squads, _squad_type);
                                new_squad_button(obj_ini.squads[_unit.squad].display_name, _squad_type);
                            }
                         }
                    } else {
                        if (!array_contains(_squads, "dreadnought")){
                            var _armour_data = _unit.get_armour_data();
                            if (is_struct(_armour_data)){
                                if (_armour_data.has_tag("dreadnought")){
                                    array_push(_squads, "dreadnought");
                                    new_squad_button("Dreadnought", "dreadnought");
                                }
                            }
                        }                      
                    }
                }
            }

            var _raid_allowable = ["Land Speeder"];
            for (var i=0;i<array_length(obj_ini.veh_race[co]);i++){
            	var _allow = false;
            	 if (obj_ini.veh_race[co][i] == 0) then continue;
                 var _v_role = obj_ini.veh_role[co][i];
            	 if (obj_ini.veh_loc[co][i] == roster_location){
            	 	 if (obj_ini.veh_wid[co][i]>0){
            	 	 	 if (obj_ini.veh_wid[co][i] ==roster_planet){
            	 	 	 	_allow=true;
            	 	 	 }
            	 	 }
            	 }
				if (obj_ini.veh_lid[co][i]>-1){
        	 	 	if (obj_ini.veh_lid[co][i]>= array_length(obj_ini.ship_location)){
        	 	 		obj_ini.veh_lid[co][i] = -1;
        	 	 	}
        	 	 	if (obj_ini.ship_location[obj_ini.veh_lid[co][i]] == roster_location){
        	 	 		_allow=true;
        	 	 	}
        	 	}
                if (_allow){
                    if (instance_exists(obj_drop_select)){
                        if (!obj_drop_select.attack){
        
                            _allow = array_contains(_raid_allowable, _v_role);
                        }
                    }
                }
        	 	if (_allow){
                    _company_present = true;
        	 		array_push(full_roster_units, [co, i]);
        	 		if (!array_contains(_vehicles, obj_ini.veh_role[co][i])){
                        array_push(_vehicles, obj_ini.veh_role[co][i]);
        	 			new_vehicle_button(obj_ini.veh_role[co][i],obj_ini.veh_role[co][i]);
        	 		}
        	 	}
            }

            var _button = new ToggleButton();
            var _col = _company_present ? CM_GREEN_COLOR : c_red;
            var _display = co ? scr_roman_numerals()[co-1] : "HQ";
            _button.str1 = _display;
            _button.text_halign = fa_center;
            _button.text_color = _col;
            _button.button_color = _col;
            _button.width = string_width(_display)+10;
            _button.active = _company_present;
            _button.company_id = co;
            _button.company_present = _company_present    
            array_push(company_buttons,_button);
        }
        var _ships = get_player_ships(roster_location);
        var _ship_index;
        for (var s=0;s<array_length(_ships);s++){
            _ship_index = _ships[s];
            if (obj_ini.ship_carrying[_ship_index]>0){
                new_ship_button(obj_ini.ship[_ship_index],_ship_index);
            }
        }
    }

    static add_to_battle = function(){
        var meeting = false;
        if (instance_exists(obj_temp_meeting)) {
            meeting = true;
            if (company == 0) and(v <= obj_temp_meeting.dudes) and(obj_temp_meeting.present[v] == 1) then okay = 1;
            else if (company > 0) or(v > obj_temp_meeting.dudes) then okay = 0;
        }
        var size_count = 0;
        var _limit = obj_ncombat.man_size_limit;
        var _has_limit = _limit>0;
        var _add;
        var _unit, _size;
        for (var i=0; i<array_length(selected_units);i++){
            if (_has_limit && _limit == size_count) then break;
            _add = true;

            if (is_struct(selected_units[i])){
                var _unit = selected_units[i];
                if (_has_limit){
                    var _size = _unit.get_unit_size()
                    _add = (_size+size_count)<=_limit;
                    if (_add){
                        size_count+=_size;
                    }
                }
                if (_add){
                    add_unit_to_battle(_unit, meeting);
                }
            } else {
                var _vehic = selected_units[i];
                var _type = obj_ini.veh_role[_vehic[0]][_vehic[1]];
                if (_has_limit){
                    var _size = scr_unit_size("",_type, true);
                    _add = _size+size_count<=_limit;
                    if (_add){
                        size_count+=_size;
                    }
                }
                if (_add){          
                    add_vehicle_to_battle(_vehic[0], _vehic[1], is_roster_unit_local(_vehic));
                }
            }
        }
    }


    static marines_total = function(){
        var _marines = 0;
        for (var i=0;i<array_length(full_roster_units);i++){
            _marines += is_struct(full_roster_units[i]);
        }
        for (var i=0;i<array_length(selected_units);i++){
            _marines += is_struct(selected_units[i]);
        }
        return _marines;
    }
    static purge_bombard_score = function(){
        var _purge_score = 0;
        for (var i=0;i<array_length(ships);i++){
            if (ships[i].active){
                var _id = ships[i].ship_id;
                var _class = player_ships_class(ship_id);
                if (obj_ini.ship_class[_id] == "Gloriana"){
                    _purge_score += 4;
                } else if (_class=="capital"){
                    _purge_score += 3;
                } else if( _class=="frigate"){
                    _purge_score += 1;
                }                      
            }
        }  
        return _purge_score;       
    }

}

function PurgeButton(purge_image,xx,yy, purge_type) constructor{
    x1=xx;
    y1=yy;
    x1=0;
    y2=0;
    width = 351;
    height = 63;
    active = 0;
    bright_shader = 0.8;
    self.purge_type = purge_type;
    self.purge_image = purge_image;

    static hover = function(){
        return scr_hit(x1, y1, x1+width, y1+height);
    }

    static draw = function(){
        if (active){
            if (hover()){
                bright_shader = min (1.2, bright_shader+0.02);     
            } else {
                bright_shader = max (0.8, bright_shader-0.02);     
            }
        } else {
            bright_shader=0.35;
        }
        shader_set(light_dark_shader);
        shader_set_uniform_f(shader_get_uniform(light_dark_shader, "highlight"), bright_shader);   
        scr_image("purge", purge_image, x1, y1 , width, height);
        shader_reset();
    }

    static clicked = function(){
        if (active){
            return point_and_click([x1, y1, x1+width, y1+height]);
        }
        return false;
    }
}

function setup_battle_formations(){
          // Formation here
    var new_combat = obj_ncombat;
    obj_controller.bat_devastator_column = obj_controller.bat_deva_for[new_combat.formation_set];
    obj_controller.bat_assault_column = obj_controller.bat_assa_for[new_combat.formation_set];
    obj_controller.bat_tactical_column = obj_controller.bat_tact_for[new_combat.formation_set];
    obj_controller.bat_veteran_column = obj_controller.bat_vete_for[new_combat.formation_set];
    obj_controller.bat_hire_column = obj_controller.bat_hire_for[new_combat.formation_set];
    obj_controller.bat_librarian_column = obj_controller.bat_libr_for[new_combat.formation_set];
    obj_controller.bat_command_column = obj_controller.bat_comm_for[new_combat.formation_set];
    obj_controller.bat_techmarine_column = obj_controller.bat_tech_for[new_combat.formation_set];
    obj_controller.bat_terminator_column = obj_controller.bat_term_for[new_combat.formation_set];
    obj_controller.bat_honor_column = obj_controller.bat_hono_for[new_combat.formation_set];
    obj_controller.bat_dreadnought_column = obj_controller.bat_drea_for[new_combat.formation_set];
    obj_controller.bat_rhino_column = obj_controller.bat_rhin_for[new_combat.formation_set];
    obj_controller.bat_predator_column = obj_controller.bat_pred_for[new_combat.formation_set];
    obj_controller.bat_landraider_column = obj_controller.bat_landraid_for[new_combat.formation_set];
    obj_controller.bat_landspeeder_column = obj_controller.bat_landspee_for[new_combat.formation_set];
    obj_controller.bat_whirlwind_column = obj_controller.bat_whirl_for[new_combat.formation_set];
    obj_controller.bat_scout_column = obj_controller.bat_scou_for[new_combat.formation_set];  
}

function add_unit_to_battle(unit,meeting, is_local){
    var new_combat = obj_ncombat;
     var man_size = 1;

    //Same as co/company and v, but with extra comprovations in case of a meeting (meeting?) 
    var _role = obj_ini.role[100];
    var cooh, va;
    cooh = 0;
    va = 0;
    var v = unit.marine_number;
    var company = unit.company;
    if (!meeting) {
        cooh = company;
        va = v;
    }else {
        if (v <= obj_temp_meeting.dudes) {
            cooh = obj_temp_meeting.company[v];
            va = obj_temp_meeting.ide[v];
        }
    }
    var _armour_data = unit.get_armour_data();
    var _wearing_armour = is_struct(_armour_data);

    var col = 0,targ = 0,moov = 0;
    _unit_role = unit.role();

    if (new_combat.battle_special == "space_hulk") then new_combat.player_starting_dudes++;

    if (_unit_role = obj_ini.role[100][18]) {
        col = obj_controller.bat_tactical_column;                   //sergeants
        new_combat.sgts++;
    }else if (_unit_role = _role[19]){
        col = obj_controller.bat_veteran_column;
        new_combat.vet_sgts++;                        
    }
    if (_unit_role = _role[12]) {              //scouts
        col = obj_controller.bat_scout_column;
        new_combat.scouts++;

    }else if (array_contains( [obj_ini.role[100][8], $"{_role[15]} Aspirant", $"{_role[14]} Aspirant"] , _unit_role)) {
        col = obj_controller.bat_tactical_column;                   //tactical_marines
        new_combat.tacticals++;
    }else if (_unit_role = _role[3]){          //veterans and veteran sergeants
        col = obj_controller.bat_veteran_column;
        new_combat.veterans++;
    }else if (_unit_role = _role[9]) {         //devastators
        col = obj_controller.bat_devastator_column;
        new_combat.devastators++;
    }else if(_unit_role = _role[10]){          //assualt marines
        col = obj_controller.bat_assault_column;
        new_combat.assaults++;

        //librarium roles

    }else if (unit.IsSpecialist(SPECIALISTS_LIBRARIANS,true)){
        col = obj_controller.bat_librarian_column;                  //librarium
        new_combat.librarians++;
        moov = 1;
    }else if (_unit_role = _role[16]) {            //techmarines
        col = obj_controller.bat_techmarine_column;
        new_combat.techmarines++;
        moov = 2;
    } else if (_unit_role = _role[2]) {            //honour guard
        col = obj_controller.bat_honor_column;
        new_combat.honors++;

    } else if (unit.IsSpecialist(SPECIALISTS_DREADNOUGHTS)){
        col = obj_controller.bat_dreadnought_column;                //dreadnoughts
        new_combat.dreadnoughts++;
    }else if (_unit_role = obj_ini.role[100][4]) {         //terminators
        col = obj_controller.bat_terminator_column;
        new_combat.terminators++;
    }

    if (moov > 0) {
        if ((moov = 1) and(obj_controller.command_set[8] = 1)) or((moov = 2) and(obj_controller.command_set[9] = 1)) {
            if (company >= 2) then col = obj_controller.bat_tactical_column;
            if (company == 10) then col = obj_controller.bat_scout_column;
            if (obj_ini.mobi[cooh][va] = "Jump Pack") {
                col = obj_controller.bat_assault_column;
            }
        }
    }

    if (_unit_role = _role[15]) or (_unit_role = _role[14]) or (unit.IsSpecialist(SPECIALISTS_TRAINEES)) {
        if (_unit_role = string(_role[14]) + " Aspirant") {
            col = obj_controller.bat_tactical_column;
            new_combat.tacticals++;
        }

        if (_unit_role = _role[15]) then new_combat.apothecaries++;
        if (_unit_role = _role[14]) {
            new_combat.chaplains++;
            if (new_combat.big_mofo > 5) then new_combat.big_mofo = 5;
        }

        col = obj_controller.bat_tactical_column;
        if (_wearing_armour){
            if (_armour_data.has_tag("terminator")){
                col = obj_controller.bat_terminator_column;
            }
        }
        if (company = 10) then col = obj_controller.bat_scout_column;
    }

    if (_unit_role = _role[5]) or(_unit_role = _role[11]) or(_unit_role = _role[7]) {
        if (_unit_role = _role[5]) {
            new_combat.captains++;
            if (new_combat.big_mofo > 5) then new_combat.big_mofo = 5;
        }
        if (_unit_role = _role[11]) then new_combat.standard_bearers++;
        if (_unit_role = _role[7]) then new_combat.champions++;

        //if (company = 1) {
        //    col = obj_controller.bat_veteran_column;
        //    if (obj_ini.armour[cooh][va] = "Terminator Armour") then col = obj_controller.bat_terminator_column;
        //    if (obj_ini.armour[cooh][va] = "Tartaros Armour") then col = obj_controller.bat_terminator_column;
        //}
        if (company >= 2) then col = obj_controller.bat_tactical_column;
        if (company = 10) then col = obj_controller.bat_scout_column;
        if (obj_ini.mobi[cooh][va] = "Jump Pack") then col = obj_controller.bat_assault_column;
    }

    if (_unit_role = obj_ini.role[100][eROLE.ChapterMaster]) {
        col = obj_controller.bat_command_column;
        new_combat.important_dudes++;
        new_combat.big_mofo = 1;
        if (string_count("0", obj_ini.spe[cooh][va]) > 0) then new_combat.chapter_master_psyker = 1;
        else {
            new_combat.chapter_master_psyker = 0;
        }
    }
    if (unit.IsSpecialist(SPECIALISTS_HEADS)){
        col = obj_controller.bat_command_column;
        new_combat.important_dudes++;                       
    };
    if (new_combat.big_mofo > 2) then new_combat.big_mofo = 2;
    if (new_combat.big_mofo > 3) then new_combat.big_mofo = 3;
    if (unit.squad!="none"){
        squad = obj_ini.squads[unit.squad];
        switch(squad.formation_place){
            case "assault":
                col = obj_controller.bat_assault_column;
                column_decided=true;
                break;
            case "veteran":
                col = obj_controller.bat_veteran_column;
                column_decided=true;
                break;
             case "tactical":
                col = obj_controller.bat_tactical_column;
                column_decided=true; 
                break;
             case "devastator":
                col = obj_controller.bat_devastator_column;
                column_decided=true; 
                break;
             case "terminator":
                col = obj_controller.bat_terminator_column;
                column_decided=true; 
                break;
            case "command":
                col = obj_controller.bat_command_column;
                column_decided=true; 
                break;                                                                                                                      
        }
    }
    if (col = 0) then col = obj_controller.bat_hire_column;
    if (_unit_role = "Death Company") { // Ahahahahah
        var really = false;
        if (_wearing_armour){
            really = _armour_data.has_tag("dreadnought");
        }

        if (!really){
            new_combat.thirsty++;
        } else {
            new_combat.really_thirsty++;
        }
        col = max(obj_controller.bat_assault_column, obj_controller.bat_command_column, obj_controller.bat_honor_column, obj_controller.bat_dreadnought_column, obj_controller.bat_veteran_column);
    }

    targ = instance_nearest(col * 10, 240, obj_pnunit);

    with (targ){
        scr_add_unit_to_roster(unit, is_local);
    }
}   

function add_vehicle_to_battle(company, veh_index, is_local){
    var new_combat = obj_ncombat;
    var v =veh_index;
    new_combat.veh_fighting[company][v] = 1;
    var col = 1, targ = 0;

    switch (obj_ini.veh_role[company][v]){
        case "Rhino":
            col = obj_controller.bat_rhino_column;
            new_combat.rhinos++;
            break;
        case "Predator":
            col = obj_controller.bat_predator_column;
            new_combat.predators++;
            break;
         case "Land Raider":
            col = obj_controller.bat_landraider_column;
            new_combat.land_raiders++;
            break;
            case "Land Speeder":
            col = obj_controller.bat_landspeeder_column;
            new_combat.land_speeders++;
            break;
         case "Whirlwind":
            col = obj_controller.bat_whirlwind_column;
            new_combat.whirlwinds++;
            break;                                    
    }

    targ = instance_nearest(col * 10, 240 / 2, obj_pnunit);
    targ.veh++;
    targ.veh_co[targ.veh] = company;
    targ.veh_id[targ.veh] = v;
    targ.veh_type[targ.veh] = obj_ini.veh_role[company][v];
    targ.veh_wep1[targ.veh] = obj_ini.veh_wep1[company][v];
    targ.veh_wep2[targ.veh] = obj_ini.veh_wep2[company][v];
    targ.veh_wep3[targ.veh] = obj_ini.veh_wep3[company][v];
    targ.veh_upgrade[targ.veh] = obj_ini.veh_upgrade[company][v];
    targ.veh_acc[targ.veh] = obj_ini.veh_acc[company][v];
    targ.veh_local[targ.veh] = is_local;


    if (obj_ini.veh_role[company][v] = "Land Speeder") {
    targ.veh_hp[targ.veh] = obj_ini.veh_hp[company][v] * 3;
        targ.veh_hp_multiplier[targ.veh] = 3;
        targ.veh_ac[targ.veh] = 30;
    }
    else if (obj_ini.veh_role[company][v] = "Rhino") or(obj_ini.veh_role[company][v] = "Whirlwind") {
        targ.veh_hp[targ.veh] = obj_ini.veh_hp[company][v] * 5;
        targ.veh_hp_multiplier[targ.veh] = 5;
        targ.veh_ac[targ.veh] = 40;
    }
    else if (obj_ini.veh_role[company][v] = "Predator") {
        targ.veh_hp[targ.veh] = obj_ini.veh_hp[company][v] * 6;
        targ.veh_hp_multiplier[targ.veh] = 6;
        targ.veh_ac[targ.veh] = 45;
    }
    else if (obj_ini.veh_role[company][v] = "Land Raider") {
        targ.veh_hp[targ.veh] = obj_ini.veh_hp[company][v] * 8;
        targ.veh_hp_multiplier[targ.veh] = 8;
        targ.veh_ac[targ.veh] = 50;
    }

    // STC Bonuses
    if (targ.veh_type[targ.veh] != "") {
        if (obj_controller.stc_bonus[3] = 1) {
            targ.veh_hp[targ.veh] = round(targ.veh_hp[targ.veh] * 1.1);
            targ.veh_hp_multiplier[targ.veh] = targ.veh_hp_multiplier[targ.veh] * 1.1;
        }
        if (obj_controller.stc_bonus[3] = 2) {
            //TODO reimplement STC bonus for ranged vehicle weapons
            //veh ranged isn't a thing sooooo.... oh well
            //targ.veh_ranged[targ.veh] = targ.veh_ranged[targ.veh] * 1.05;
        }
        if (obj_controller.stc_bonus[3] = 5) {
            targ.veh_ac[targ.veh] = round(targ.veh_ac[targ.veh] * 1.1);
        }
        if (obj_controller.stc_bonus[4] = 1) {
            targ.veh_hp[targ.veh] = round(targ.veh_hp[targ.veh] * 1.1);
            targ.veh_hp_multiplier[targ.veh] = targ.veh_hp_multiplier[targ.veh] * 1.1;
        }
        if (obj_controller.stc_bonus[4] = 2) {
            targ.veh_ac[targ.veh] = round(targ.veh_ac[targ.veh] * 1.1);
        }
    }
}



