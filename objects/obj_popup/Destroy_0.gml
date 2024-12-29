
if (image="debug_banshee") then obj_controller.cooldown=8;
if (image="chaos_symbol") and (title="Concealed Heresy") and (instance_exists(obj_drop_select)){
    with (obj_drop_select){
        obj_controller.cooldown=30;
        // ** Starts the battle **
        is_in_combat=true;

        instance_deactivate_all(true);
        instance_activate_object(obj_controller);
        instance_activate_object(obj_ini);
        instance_activate_object(obj_drop_select);

        instance_create(0,0,obj_ncombat);
        obj_ncombat.battle_object=p_target;
        obj_ncombat.battle_loc=p_target.name;
        obj_ncombat.battle_id=obj_controller.selecting_planet;
        obj_ncombat.dropping=0;
        obj_ncombat.attacking=10;
        obj_ncombat.enemy=10;
        obj_ncombat.formation_set=2;
        obj_ncombat.leader=1;
        obj_ncombat.threat=5;
        obj_ncombat.battle_special="WL10_reveal";    
        scr_battle_allies();
        setup_battle_formations();
        roster.add_to_battle();        
    }
}

if (instance_exists(obj_controller)){
    if (obj_controller.current_eventing="chaos_meeting_1"){
        obj_controller.menu=20;
        obj_controller.diplomacy=10;
        obj_controller.cooldown=5000;
        with(obj_controller){scr_dialogue("cs_meeting1");}
    }
    
    if (obj_controller.current_eventing="chaos_trap"){
        instance_create(0,0,obj_ncombat);
        obj_ncombat.battle_special="cs_meeting_battle10";
        
        var meeting_star ="none";
        var meeting_planet;
        with(obj_star){
            var meeting = has_problem_star("meeting");
            var trap = has_problem_star("meeting");
            if (meeting || trap){
                meeting_star=self.id;
                if (meeting!=0){
                    meeting_planet=meeting;
                } else if (trap!=0){
                    meeting_planet=meeting;
                }
            }
        }
        if (meeting_star=="none"){
            instance_activate_object(obj_star);
            with(obj_star){
                if (string_count(name,scr_master_loc())>0){
                    meeting_star=self.id;
                    meeting_planet = obj_ini.TTRPG[0][1].planet_location;
                }
            }
        }
        if (meeting_star!="none"){
            obj_ncombat.battle_object=meeting_star;
            obj_ncombat.battle_loc=meeting_star.name;
            obj_ncombat.battle_id=meeting_planet;
        }

        obj_ncombat.dropping=0;
        obj_ncombat.attacking=1;
        obj_ncombat.local_forces=0;
        obj_ncombat.enemy=10;
        obj_ncombat.threat=3;
        
        with(obj_star){
            remove_star_problem("meeting");
            remove_star_problem("meeting_trap");
        }
        
        obj_controller.useful_info+="CHTRP|";
        
        var v;v=0;
        repeat(obj_temp_meeting.dudes){v+=1;
            if (obj_temp_meeting.present[v]=1){
                obj_ncombat.fighting[obj_temp_meeting.co[v],obj_temp_meeting.ide[v]]=1;
            }
        }
        
        
        scr_civil_roster(obj_ncombat.battle_loc,obj_ncombat.battle_id,true);
        
        instance_deactivate_all(true);
        instance_activate_object(obj_controller);
        instance_activate_object(obj_ini);
        instance_activate_object(obj_temp_meeting);
        instance_activate_object(obj_ncombat);
        instance_activate_object(obj_centerline);
        instance_activate_object(obj_pnunit);
        instance_activate_object(obj_enunit);
        
        exit;
    }
    
    
    if (obj_controller.current_eventing="chaos_meeting_end") and (instance_exists(obj_turn_end)){
        obj_turn_end.alarm[1]=1;obj_controller.current_eventing="";
    }
}

