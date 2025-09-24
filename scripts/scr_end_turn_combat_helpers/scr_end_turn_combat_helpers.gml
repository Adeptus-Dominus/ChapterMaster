


function draw_player_fleet_combat_options(){
    var xxx=main_slate.XX;
    var yyy=main_slate.YY;
	draw_set_font(fnt_40k_14b);
    draw_set_halign(fa_left);
    
    draw_text(xxx+12,yyy+237,"Enemy Fleets:");
    draw_text(xxx+332,yyy+237,"Allied Fleets:");
    
	draw_text(xxx+310,yyy+118,$"{strin[1]} {string_plural("Battleship",strin[1])} ({strin[4]}% HP)");
	draw_text(xxx+310,yyy+138,$"{strin[2]} {string_plural("Frigate",strin[2])} ({strin[5]}% HP)");
	draw_text(xxx+310,yyy+158,$"{strin[3]} {string_plural("Escort",strin[3])} ({strin[6]}% HP)");

    
    draw_set_halign(fa_center);
    
    for (var i=1;i<array_length(enemy_fleet);i++){
        // draw_sprite(spr_force_icon,enemy_fleet[1],xxx+44,yyy+269);
    	if (i>1){
        	xxx+=110;
        }
        if (enemy_fleet[i]!=0){
	        scr_image("ui/force",enemy_fleet[i],xxx+44-32,yyy+269-32,64,64);
	        var shw="";
	        shw += $"{ecap[i]} :"+string_plural( "Battleship",ecap[i]) + "\n";
	        shw += $"{efri[i]} :"+string_plural("Frigate",efri[i]) + "\n";
	        shw +=$"{eesc[i]} :"+string_plural( "Escort",eesc[i]) + "\n";
	        
	        draw_text_transformed(xxx+44,yyy+286,shw,0.7,1,0);
	        draw_set_halign(fa_center);
	        draw_set_font(fnt_40k_14b);
    	}
        if (array_length(allied_fleet)<i){
        	var _ali_mod = 330;
	        if (allied_fleet[i]!=0){
	            // draw_sprite(spr_force_icon,allied_fleet[1],xxx+374,yyy+269);
	            scr_image("ui/force",allied_fleet[i],xxx + 44+ _ali_mod -32,yyy+269-32,64,64);
	            var shw="";
		        shw += $"{acap[i]} : {string_plural( "Battleship",acap[i])} \n";
		        shw += $"{afri[i]} :{string_plural( "Frigate",afri[i])} \n";
		        shw +=$"{aesc[i]} :{string_plural( "Escort",aesc[i])} \n";	            
	            
	            draw_text_transformed(xxx+44+_ali_mod,yyy+286,shw,0.7,1,0);
	            draw_set_halign(fa_center);
	            draw_set_font(fnt_40k_14b);
	        }            	
        }

    }
    var xxx=main_slate.XX;

    var _retreat_button = draw_unit_buttons([xxx+180,yyy+350],"Retreat");
    var _battle_sys = battle_pobject[current_battle];
    if (point_and_click(_retreat_button)){
        with(obj_fleet_select){
        	instance_destroy();
        }
        var that=instance_nearest(_battle_sys.x,_battle_sys.y,obj_p_fleet);
        that.alarm[3]=1;
        var that2=instance_create(0,0,obj_popup);
        that2.type=99;
        obj_controller.force_scroll=1;        	
    }

    var _fight_button = draw_unit_buttons([xxx+272,yyy+350],"Fight");
    if (point_and_click(_fight_button) && enemy_fleet[1]!=0){
        instance_activate_all();

        var _star =  star_by_name(battle_location[current_battle]);
        setup_fleet_battle(enemy_fleet[1], _star);

        ready_set = 0;
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
