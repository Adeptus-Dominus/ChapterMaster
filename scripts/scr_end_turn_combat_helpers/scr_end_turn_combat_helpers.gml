

enum EndTurnBattleTypes {
    Ground,
    Fleet,
}
function EndTurnBattle (battle_type, system)constructor{
    type = battle_type;
    self.system = system;
    planet = 1;
    special = "";
    opponent = 7;
    player_object = -1;
    slate = new DataSlate();
    slate.inside_method = function(){
        var xxx=slate.XX;
        var yyy=slate.YY;
        var i=current_battle;
        
        // if (battle_world[i]>0) then draw_sprite(spr_attacked,0,xxx+12,yyy+54);
        var _img = type;

        scr_image("attacked",_img,xxx+12,yyy+54,254,174);
        
        draw_set_font(fnt_40k_14);
        draw_set_halign(fa_left);
        draw_set_color(c_gray);
        draw_text(xxx+8,yyy+13,$"{current_battle}/{battles}");
        
        draw_set_halign(fa_center);
        draw_set_font(fnt_40k_30b);
        
        if (type == EndTurnBattleTypes.Ground){
            draw_text_transformed(xxx+265,yyy+11,$"Forces Attacked! ({pdata.name()})",0.7,0.7,0);
        } else {
            draw_text_transformed(xxx+265,yyy+11,$"Fleet Attacked! ({location} System)",0.7,0.7,0);
        }
        
        scr_image("ui/force",1,xxx+378-32,yyy+86-32,64,64);
        // draw_sprite(spr_force_icon,1,xxx+378,yyy+86);
        
        draw_set_font(fnt_40k_14);
        draw_set_halign(fa_left);
        if (type == EndTurnBattleTypes.Fleet){
            draw_player_fleet_combat_options();
        } else if (type == EndTurnBattleTypes.Ground){
           draw_player_ground_combat_options();
        }        
    }

    static add_to_stack = function(){
        var _new_battle = self;
        location = system.name;
        if (type == EndTurnBattleTypes.Ground){
            pdata = new PlanetData(planet,system);
        }
        with (obj_turn_end){
            if (_new_battle.type == Fleet){
                _new_battle.collect_fleet_battle_variables();
                //final check that there definatly are infact enemy ships to fight
                if (array_length(_new_battle.enemy_fleets)){
                    array_insert(battles, _new_battle, 0);
                }
            } else {
                array_push(battles,_new_battle);
            }
        }        
    }

    static new_ship_class_tracker = function(){
        return {
            capital : 0,
            frigate : 0,
            escort : 0,
        };
    }
    static collect_fleet_battle_variables = function(){
        var _fleets = scr_orbiting_fleets_all(system);
        enemy_fleets = [];
        allied_fleets = [];

        for (var i=0;i<array_length(_fleets);i++){
            var _cur_ships = new_ship_class_tracker()
            var _fleet = _fleets[i];
            _cur_ships.capital += _fleet.capital_number;
            _cur_ships.frigate += _fleet.frigate_number;
            _cur_ships.escort += _fleet.escort_number;
            _cur_ships.owner = _fleet.owner;
            var _status = fleet_faction_status(_fleet);
            if (_status == "War"){
                array_push(enemy_fleets, _cur_ships);
            } else {
                array_push(allied_fleets, _cur_ships);               
            }
        }

        caps = array_length(player_object.capital_num);
        frigs = array_length(player_object.frigate_num);
        escorts = array_length(player_object.escort_num);

        var capital_percentage = 0;

        for (var i = 0;i<caps;i++){
            var _ship = fetch_ship(player_object.capital_num[i]);
            capital_percentage += _ship.ship_hp_percentage();
        }
        capital_percentage /= caps

        var frigs_percentage = 0;

        for (var i = 0;i<frigs;i++){
            var _ship = fetch_ship(player_object.frigate_num[i]);
            frigs_percentage += _ship.ship_hp_percentage();
        }
        frigs_percentage /= frigs

        var escorts_percentage = 0;

        for (var i = 0;i<escorts;i++){
            var _ship = fetch_ship(player_object.escort_num[i]);
            escorts_percentage += _ship.ship_hp_percentage();
        }
        escorts_percentage /= escorts
          
    }

    static draw = function(){
        add_draw_return_values();
        slate.draw_with_dimensions(535, 200, 530, 400);
        pop_draw_return_values();
    }
}


function check_for_finished_end_turn_battles(){
    if (!array_length(battle)) or (current_battle>battles){
        setup_audience_and_popup_timer();
    }
}
function end_turn_battle_next_sequence(next_battle = true, wait_time = 1){
    if (next_battle){
        obj_turn_end.current_battle++;
    }
    obj_controller.force_scroll=0;
    static _main_func = function(){
        instance_activate_object(obj_star);
        combating=0;

        collect_next_end_turn_battle();

        instance_activate_object(obj_star);

        check_for_finished_end_turn_battles();
    }

    wait_and_execute(wait_time,_main_func,[],obj_turn_end)

    /* */
}


function next_end_turn_battle_variables(){
    var battle_o=0;
    current_battle+=1;
    combating=0;

    instance_activate_object(obj_star);

    if (battles>0) and (current_battle<=battles){

        var  ii=0,good=0;
        var battle_star = star_by_name(battle_location[current_battle]);
        obj_controller.temp[1060]=battle_location[current_battle];
        
        if (battle_star!="none"){
            obj_controller.x=battle_star.x;
            obj_controller.y=battle_star.y;
            show=current_battle;

            if (battle_world[current_battle]>=1){
                var _p_data = new PlanetData(battle_world[current_battle], battle_object[current_battle]);
            
                scr_count_forces(string(battle_location[current_battle]),battle_world[current_battle],true);
                
                strin[1]=info_mahreens;
                strin[2]=info_vehicles;
                
                if (info_mahreens+info_vehicles=0){
                    end_turn_battle_next_sequence();
                }
                
                strin[3]="";
                
                var tempy=0;
                tempy=battle_object[current_battle].p_owner[battle_world[current_battle]];
                
                if ((tempy>=1) || (tempy=2) || (tempy=3)){
                    strin[3] = FORTIFICATION_GRADES_DESCRIPTIONS[clamp(_p_data.fortification_level, 0, 6)];
                }
                
                tempy=0;
                if (battle_opponent[current_battle]=7) then tempy=battle_object[current_battle].p_orks[battle_world[current_battle]];
                if (battle_opponent[current_battle]=8) then tempy=battle_object[current_battle].p_tau[battle_world[current_battle]];
                if (battle_opponent[current_battle]=9) then tempy=battle_object[current_battle].p_tyranids[battle_world[current_battle]];
                if (battle_opponent[current_battle]=10) then tempy=battle_object[current_battle].p_traitors[battle_world[current_battle]];
                if (battle_opponent[current_battle]=30){
                    tempy=1;
                    strin[4]="Master Spyrer";
                }
                
                if (battle_opponent[current_battle]<=20){
                    tempy = clamp(tempy, 0, 6);
                    strin[4] = AUTO_BATTLE_FORCES_GRADE[tempy];
                }
            }
            
            if (obj_controller.zoomed=1){
                scr_zoom()
            };
        }
        instance_activate_object(obj_star);
        
    }

    instance_activate_object(obj_star);

    end_turn_battle_next_sequence();

}

function collect_next_end_turn_battle(){
    if (battles<=0) || (current_battle>battles){
        exit;
    }
    var ii, xx, yy, good;
    ii=0;
    good=0;
    
    var battle_star = star_by_name(battle_location[current_battle]);
    
    if (battle_star != "none"){// trying to find the star
        obj_controller.x=battle_star.x;
        obj_controller.y=battle_star.y;

        show=current_battle;
    
        
        if (battle_world[current_battle]>=1){
            scr_count_forces(string(battle_location[current_battle]),battle_world[current_battle],true);
            
            strin[1]=info_mahreens;
            strin[2]=info_vehicles;
            
            if (info_mahreens+info_vehicles=0){
                end_turn_battle_next_sequence();
                exit;
            }
            
            strin[3]="";
            
            var tempy=0;
            tempy=battle_object[current_battle].p_owner[battle_world[current_battle]];
            
            if (tempy=1) or (tempy=2) or (tempy=3){
                var array_string = FORTIFICATION_GRADES_DESCRIPTIONS;
                var battle_fortification = battle_object[current_battle].p_fortified[battle_world[current_battle]];
                strin[3] = array_string[clamp(battle_fortification, 1, 6)];
            }
            
            tempy=0;
            if (battle_opponent[current_battle]=7) then tempy=battle_object[current_battle].p_orks[battle_world[current_battle]];
            if (battle_opponent[current_battle]=8) then tempy=battle_object[current_battle].p_tau[battle_world[current_battle]];
            if (battle_opponent[current_battle]=9) then tempy=battle_object[current_battle].p_tyranids[battle_world[current_battle]];
            if (battle_opponent[current_battle]=10) then tempy=battle_object[current_battle].p_traitors[battle_world[current_battle]];
            if (battle_opponent[current_battle]=13) then tempy=battle_object[current_battle].p_necrons[battle_world[current_battle]];
            
            if (tempy=1) then strin[4]="Minimal Forces";
            if (tempy=2) then strin[4]="Sparse Forces";
            if (tempy=3) then strin[4]="Moderate Forces";
            if (tempy=4) then strin[4]="Numerous Forces";
            if (tempy=5) then strin[4]="Very Numerous";
            if (tempy=6) then strin[4]="Overwhelming";
            
            // if (battle_opponent[current_battle]=2) then obj_controller.alarm[7]=1;
            obj_controller.cooldown=9999;
        }
        
        if (obj_controller.zoomed=1) then with(obj_controller){scr_zoom();}
    }
    instance_activate_object(obj_star);   
}

function draw_player_fleet_combat_options(){
    var xxx=main_slate.XX;
    var yyy=main_slate.YY;
	draw_set_font(fnt_40k_14b);
    draw_set_halign(fa_left);
    
    draw_text(xxx+12,yyy+237,"Enemy Fleets:");
    draw_text(xxx+332,yyy+237,"Allied Fleets:");

	draw_text(xxx+310,yyy+118,$"{caps} {string_plural("Battleship",caps)} ({capital_percentage}% HP)");
	draw_text(xxx+310,yyy+138,$"{frigs} {string_plural("Frigate",frigs)} ({frigs_percentage}% HP)");
	draw_text(xxx+310,yyy+158,$"{escorts} {string_plural("Escort",escorts)} ({escorts_percentage}% HP)");

    
    draw_set_halign(fa_center);
    
    for (var i=0;i<array_length(enemy_fleets);i++){
        // draw_sprite(spr_force_icon,enemy_fleet[1],xxx+44,yyy+269);
    	if (i>0){
        	xxx+=110;
        }
        var _fleet = enemy_fleets[i];

        scr_image("ui/force",_fleet.owner,xxx+44-32,yyy+269-32,64,64);
        var shw="";

        shw += $"{_fleet.capital} :"+string_plural( "Battleship",_fleet.capital) + "\n";
        shw += $"{_fleet.frigate} :"+string_plural("Frigate",_fleet.frigate) + "\n";
        shw +=$"{_fleet.escort} :"+string_plural( "Escort",_fleet.escort) + "\n";
        
        draw_text_transformed(xxx+44,yyy+286,shw,0.7,1,0);
        draw_set_halign(fa_center);
        draw_set_font(fnt_40k_14b);

    }
    var xxx=main_slate.XX;
    for (var i=0;i<array_length(allied_fleets);i++){
        // draw_sprite(spr_force_icon,enemy_fleet[1],xxx+44,yyy+269);
        var _ali_mod = 330;
        if (i>0){
            xxx+=110;
        }
        var _fleet = allied_fleets[i];

        scr_image("ui/force",_fleet.owner,xxx+44-32+_ali_mod,yyy+269-32,64,64);
        var shw="";
        shw += $"{_fleet.capital} :"+string_plural( "Battleship",_fleet.capital) + "\n";
        shw += $"{_fleet.frigate} :"+string_plural("Frigate",_fleet.frigate) + "\n";
        shw +=$"{_fleet.escort} :"+string_plural( "Escort",_fleet.escort) + "\n";
        
        draw_text_transformed(xxx+44+_ali_mod,yyy+286,shw,0.7,1,0);
        draw_set_halign(fa_center);
        draw_set_font(fnt_40k_14b);

    }

    var xxx=main_slate.XX;

    var _retreat_button = draw_unit_buttons([xxx+180,yyy+350],"Retreat");
    if (point_and_click(_retreat_button)){
        with(obj_fleet_select){
        	instance_destroy();
        }
        
        player_object.alarm[3]=1;
        var that2=instance_create(0,0,obj_popup);
        that2.type=99;
        obj_controller.force_scroll=1;        	
    }

    var _fight_button = draw_unit_buttons([xxx+272,yyy+350],"Fight");
    if (point_and_click(_fight_button)){
        instance_activate_all();

        setup_fleet_battle(opponent, system);

        if (instance_exists(obj_fleet)){
            wait_and_execute(20, start_fleet_battle,[] , obj_turn_end);
        }
        // Start battle here
    }
	
}


function draw_player_ground_combat_options(){
    var xxx=main_slate.XX;
    var yyy=main_slate.YY;
    if (battle_opponent[current_battle]<=20){
        draw_text(xxx+310,yyy+118, $"{string(strin[1])} Marines");
        draw_text(xxx+310,yyy+138, $"{string(strin[2])} Vehicles");
        if (strin[3]!="") then draw_text(xxx+310,yyy+158,string(strin[3])+" Fortified");// Not / Barely / Lightly / Moderately / Highly / Maximally
    }
    
    draw_set_font(fnt_40k_14b);
    draw_set_halign(fa_left);
    
    draw_text(xxx+12,yyy+237,"Enemy Factions:");
    draw_text(xxx+332,yyy+237,"Allies:");
    
    
    
    draw_set_halign(fa_center);
    // draw_sprite(spr_force_icon,battle_opponent[current_battle],xxx+44,yyy+289);
    scr_image("ui/force",battle_opponent[current_battle],xxx+44-32,yyy+289-32,64,64);
    draw_text_transformed(xxx+44,yyy+316,string(strin[4]),0.75,1,0);
    draw_set_halign(fa_center);draw_set_font(fnt_40k_14b);
    

    var _init_battle = false;
    if (point_and_click(draw_unit_buttons([xxx+195,yyy+362],"Offensive"))){
        _init_battle = true;
        var _battle_stance = "offensive"
    }

    if (point_and_click(draw_unit_buttons([xxx+335,yyy+362],"Defensive"))){
        _init_battle = true;
        var _battle_stance = "defensive"
    }

    if (_init_battle){
        var _loc = battle_location[current_battle]
        var _planet = battle_world[current_battle]                                                   // Fight fight fight, ground
        obj_controller.cooldown=8;

        // Start battle here

        combating=1;

        instance_deactivate_all(true);
        instance_activate_object(obj_controller);
        instance_activate_object(obj_ini);
        instance_activate_object(battle_object[current_battle]);

        var _battle_obj = battle_object[current_battle];
        
        instance_create(0,0,obj_ncombat);
        obj_ncombat.enemy=battle_opponent[current_battle];
        obj_ncombat.battle_object=_battle_obj;
        obj_ncombat.battle_loc=_loc;
        obj_ncombat.battle_id=_planet;

        var _enemy = obj_ncombat.enemy;
        
        var _planet_data = new PlanetData(_planet, _battle_obj);
        if (_battle_stance="offensive"){
            obj_ncombat.formation_set=1;
        } else if (_battle_stance="defensive"){
            obj_ncombat.formation_set=2;
        }


        var _allow_fortifications=false;
        var _fort_factions = [eFACTION.Player, eFACTION.Tyranids,eFACTION.Ork];
        _allow_fortifications =  (array_contains(_fort_factions, _planet_data.current_owner))

        if (!_allow_fortifications){
            var owner_fac_status
            _allow_fortifications =  (_planet_data.owner_status() != "War");
        }

        if (_allow_fortifications) then obj_ncombat.fortified=_planet_data.fortification_level;

        if (obj_ncombat.enemy==13) then obj_ncombat.fortified=0;

        obj_ncombat.battle_special=battle_special[current_battle];
        obj_ncombat.battle_climate=_planet_data.planet_type;

        // show_message(string(battle_object[current_battle].p_feature[battle_world[current_battle]]));
        /*if (scr_planetary_feature.plant_feature_bool(battle_object[current_battle].p_feature[battle_world[current_battle]], P_features.Monastery)==1){
            // show_message(string(battle_object[current_battle].p_defenses[battle_world[current_battle]]));
            // show_message(string(battle_object[current_battle].p_silo[battle_world[current_battle]]));
            obj_ncombat.player_defenses+=battle_object[current_battle].p_defenses[battle_world[current_battle]];
            obj_ncombat.player_silos+=battle_object[current_battle].p_silo[battle_world[current_battle]];
        }*/

        if (_enemy == eFACTION.Imperium){
            obj_ncombat.threat=min(1000000,_planet_data.guardsmen);
        } else if (obj_ncombat.enemy<14 && _enemy>5){
            obj_ncombat.threat = _planet_data.planet_forces[_enemy];
        }
        else if (_enemy=30){
            obj_ncombat.threat=1;
        }

        //
        _roster = new Roster();
        with (_roster){
            roster_location = _loc;
            roster_planet = _planet;
            determine_full_roster();
            only_locals();
            update_roster();
            if (array_length(selected_units)){  
                setup_battle_formations();
                add_to_battle();
            }              
        }
        delete _roster;
        instance_deactivate_object(battle_object[current_battle]);
    }
    
}

function add_system_end_turn_fleet_battles(){

    //IF no valid enemy or player fleets just skip this step
    var _nearest_en_fleet = instance_nearest(x,y,obj_en_fleet);
    if (_nearest_en_fleet.x != x && _nearest_en_fleet.y != y) {
        exit;
    }

    var _nearest_p_fleet = instance_nearest(x,y,obj_p_fleet);

    if (_nearest_p_fleet.x != x || _nearest_p_fleet.y != y || _nearest_p_fleet.action == "move") {
        exit;
    }

    var _orbiting_fleets = scr_orbiting_fleets_all();

    if (!array_length(_orbiting_fleets)){
        exit;
    }
    var _largest_fleet = -1;
    var _largest_score = 0;

    for (var i=0;i<array_length(_orbiting_fleets);i++){
        var _cur_fleet = _orbiting_fleets[i];
        if (fleet_faction_status(_cur_fleet)!="War"){
            continue;
        }
        if (_cur_fleet.owner == 10 || _cur_fleet.owner == 11){
            if (has_problem_star("meeting")||has_problem_star("meeting_trap")){
                continue;
            }
        }
        var _cur_largest = standard_fleet_strength_calc(_cur_fleet);
        if (_cur_largest >  _largest_score){
            _largest_fleet = _cur_fleet.id;
            _largest_score = _cur_largest;
        }
    }

    if (_largest_score <=0 || !instance_exists(_largest_fleet)){
        exit;
    }

    var _fleet_battle = new EndTurnBattle(EndTurnBattleTypes.Fleet, self);

    _fleet_battle.opponent = _largest_fleet.owner;

    _fleet_battle.player_object = _nearest_p_fleet;

    if (fleet_has_cargo("warband", _largest_fleet)){
        _fleet_battle.special = "BLOOD";
    }

    if (fleet_has_cargo("csm", _largest_fleet)){
        _fleet_battle.special = "CSM";
    }

    _fleet_battle.add_to_stack();
    
}
