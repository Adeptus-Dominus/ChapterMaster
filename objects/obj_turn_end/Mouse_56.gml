var __b__;

//so this only runs if there aren't these types of instances
__b__ = action_if_number(obj_saveload, 0, 0);
if __b__
{
__b__ = action_if_number(obj_popup, 0, 0);
	if __b__
	{
	__b__ = action_if_number(obj_ncombat, 0, 0);
		if __b__
		{
		__b__ = action_if_number(obj_fleet, 0, 0);
			if __b__
			{

			if (obj_controller.complex_event=true) or (instance_exists(obj_temp_meeting)) then exit;



			var xxx,yyy;
			xxx=__view_get( e__VW.XView, 0 )+535;
			yyy=__view_get( e__VW.YView, 0 )+200;

			



				if (cooldown<=0) and (battle_world[current_battle]>0) and (combating=0){

				    var tip;tip="";
    
				    if (mouse_x>=xxx+132) and (mouse_y>=yyy+354) and (mouse_x<xxx+259) and (mouse_y<yyy+389){
				        tip="offensive";
				    }
    
				    if (mouse_x>=xxx+272) and (mouse_y>=yyy+354) and (mouse_x<xxx+399) and (mouse_y<yyy+389){
				        tip="defensive";
				    }
    
    
    
    
    
				    if (tip!=""){
				        var _loc = battle_location[current_battle]
				        var _planet = battle_world[current_battle]				                                     // Fight fight fight, ground
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
				        if (tip="offensive"){
				        	obj_ncombat.formation_set=1;
				        } else if (tip="defensive"){
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
					    delete _roster
				        instance_deactivate_object(battle_object[current_battle]);
				    }
				}
			}
		}
	}
}
