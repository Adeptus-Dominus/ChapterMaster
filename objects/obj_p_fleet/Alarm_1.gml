try_and_report_loop("player alarm 1",function(){
    var spid, dir;spid=0;dir=0;

    acted=0;

    if (action=="Lost"){
        set_fleet_location("Lost");
        exit;

    }else if (action==""){
        spid=instance_nearest(x,y,obj_star);
        // spid.present_fleets+=1;
        spid.present_fleet[1]+=1;
        if (spid.vision=0) then spid.vision=1;
        orbiting=spid;
        
        if (orbiting!=0) and (instance_exists(orbiting)){
            if ((orbiting.visited == 0)){
                for (var planet_num = 1; planet_num < orbiting.planets; planet_num += 1){
                    if (array_length(orbiting.p_feature[planet_num])!=0) then with(orbiting){scr_planetary_feature(planet_num);}
                }
                orbiting.visited = 1;
            }
            
    		meet_system_governors(orbiting);
        }
    }


    else if (array_contains(FLEET_MOVE_OPTIONS, action)){
        
        var i;
        set_fleet_location("Warp");

        if (instance_nearest(action_x,action_y,obj_star).storm>0) then exit;

        spid=point_distance(x,y,action_x,action_y);
        spid=spid/(action_eta);
        dir=point_direction(x,y,action_x,action_y);
        
        x=x+lengthdir_x(spid,dir);
        y=y+lengthdir_y(spid,dir);

        action_eta-=1;
        just_left=false;       
        
        if (action_eta=0) and (action="crusade1"){
            var dr=point_direction(room_width/2,room_height/2,x,y);
            action_x=x+lengthdir_x(600,dr);
            action_y=y+lengthdir_y(600,dr);
            action="crusade2";
            set_fleet_movement(false, "crusade2");
        }
        if (action_eta=0) and (action="crusade2"){
            with(obj_star){
                if (owner>5) then instance_deactivate_object(id);
                var enemies = false;
                for(var i=6;i<13;i++){
                    if (scr_orbiting_fleet(i)!="none"){
                        enemies = true;
                        break;
                    }
                }
                if (enemies) then instance_deactivate_object(id);
            }
            var ret=instance_nearest(x,y,obj_star);
            action_x=ret.x;
            action_y=ret.y;
            action="crusade3";
            set_fleet_movement(false, "crusade3");
            instance_activate_object(obj_star);
        }
        if (action_eta=0) and (action="crusade3"){
            // Popup here
            scr_crusade();
            action="";
        }
        
        
        if (action_eta=0) and (action!="crusade1") and (action!="crusade2"){
            // Check to see if there are already player ships in the spot where this object will move to
            // If yes, combine the two of them
            
            var steh=instance_nearest(action_x,action_y,obj_star);
            if (steh.vision=0) then steh.vision=1;
            steh.present_fleet[1]+=1;
            orbiting=steh;
            // show_message("Present Fleets at alarm[1]: "+string(steh.present_fleets));
            
            meet_system_governors(steh);

            if (steh.p_owner[1]=5) or (steh.p_owner[2]=5) or (steh.p_owner[3]=5) or (steh.p_owner[4]=5){
                if (obj_controller.faction_defeated[5]=0) and (obj_controller.known[eFACTION.Ecclesiarchy]=0) then obj_controller.known[eFACTION.Ecclesiarchy]=1;
            }
            if (steh.owner = eFACTION.Eldar) and (obj_controller.faction_defeated[6]=0) and (obj_controller.known[eFACTION.Eldar]=0) then obj_controller.known[eFACTION.Eldar]=1;
            if (steh.owner = eFACTION.Tau) and (obj_controller.faction_defeated[8]=0) and (obj_controller.known[eFACTION.Tau]=0) then obj_controller.known[eFACTION.Tau]=1;
            
            action="";
            x=action_x;
            y=action_y;
            action_x=0;
            action_y=0;
            
            
            var i;
            set_fleet_location(steh.name);
            if (steh.visited == 0){
    			for (var plan_num =1; plan_num < 5; plan_num++){
    		        if (array_length(steh.p_feature[plan_num])!=0)then with(steh){scr_planetary_feature(plan_num);}
    			}
    			steh.visited = 1
    		}
            if (array_length(complex_route)>0){
                set_new_player_fleet_course(complex_route);
            }        
        }
        
    }

    if (action="") and (obj_controller.known[eFACTION.Eldar]=0){
        instance_activate_object(obj_star);// Kind of half-ass band-aiding that bug, might need to remove this later; this might cause problems later
        
        
        with(obj_star){
            if (p_type[1]!="Craftworld") then instance_deactivate_object(id);
        }

        var steh;steh=instance_nearest(x,y,obj_star);
        if (instance_exists(steh)) and (steh!=0){
        
        if (steh.p_type[1]="Craftworld"){
            var target_distance, rando;
            target_distance=999;rando=floor(random(100))+1;
            target_distance=point_distance(x,y,steh.old_x,steh.old_y);
            
            // show_message("target_distance: "+string(target_distance)+", Rando: "+string(rando));
            
            if (rando>=95) and (target_distance<=300){
                obj_controller.known[eFACTION.Eldar]=1;
                scr_alert("green","elfs","Eldar Craftworld discovered.",steh.old_x,steh.old_y);
                with(obj_en_fleet){if (owner = eFACTION.Eldar) then image_alpha=1;}
            }
            // Quene eldar introduction
            // if (rando>=95) and (target_distance<=300) then show_message("MON'KEIGH");
        }
        }
        
        instance_activate_object(obj_star);

    }
});

