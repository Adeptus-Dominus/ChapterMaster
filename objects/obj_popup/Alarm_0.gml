if (battle_special=3.1){
    var that;
    
    
    // show_message(string(obj_popup.loc)+": planet name, "+string(loc)+", "+string(planet));
    
    
    with(obj_star){if (name!=obj_popup.loc) then instance_deactivate_object(id);}
    that=instance_nearest(room_width/2,room_height/2,obj_star);
    instance_activate_all();
    
    instance_create(0,0,obj_ncombat);
    obj_ncombat.enemy=3;
    obj_ncombat.battle_object=that;
    obj_ncombat.battle_loc=loc;
    obj_ncombat.battle_id=planet;
    obj_ncombat.fortified=5;
    obj_ncombat.battle_special="mech_stc";
    obj_ncombat.threat=4;
    obj_ncombat.player_formation=3;
    
    instance_deactivate_all(true);
    instance_activate_object(obj_ini);
    instance_activate_object(obj_controller);
    instance_activate_object(obj_ncombat);
    
    _roster = new Roster();
    with (_roster){
        roster_location = obj_ncombat.battle_loc;
        roster_planet = obj_ncombat.battle_id;
        determine_full_roster();
        only_locals();
        update_roster();
        if (array_length(selected_units)){  
            setup_battle_formations();
            // add_to_battle();
        } else {
            instance_destroy(obj_ncombat);
            instance_activate_all();
            delete _roster
        }               
    }
    delete _roster
}
instance_destroy();exit;

