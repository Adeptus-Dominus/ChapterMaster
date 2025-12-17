function base_inquis_fleet(){
	owner=eFACTION.Inquisition;
    frigate_number=1;
    sprite_index=spr_fleet_inquisition;
    image_index=0;
    warp_able=true;
    var roll=irandom(100)+1;
    inquisitor = 0;
    trade_goods="Inqis";
    if (roll>60){
        var inquis_choice = choose(2,3,4,5);
        inquisitor = inquis_choice
    }
}


function hunt_player_serfs(planet, system){
    add_event({
        planet : planet,
        system : system,
        e_id : "remove_surf",
        duration : irandom_range(1,4),
    });
}


function radical_inquisitor_mission_ship_arrival(){

    //TODO make a centralised player_fleet present method
    var _p_fleet = instance_nearest(x,y, obj_p_fleet);
    var _intercept_fleet = -1;
    if (point_distance(x,y,_p_fleet.x, _p_fleet.y)<10 && is_orbiting(obj_p_fleet)){
        _intercept_fleet = _p_fleet;
    }


    var _radical_inquisitor = cargo_data.radical_inquisitor;
    if (!instance_exists(_intercept_fleet)){
        action_x=choose(room_width*-1,room_width*2);
        action_y=choose(room_height*-1,room_height*2);
        action_spd=256;
        action="";            
        set_fleet_movement();
        instance_destroy();
        alter_disposition(eFACTION.Inquisition,-15);
        scr_popup("Inquisitor Mission Failed","The radical Inquisitor has departed from the planned intercept coordinates.  They will now be nearly impossible to track- the mission is a failure.","inquisition","");
        scr_event_log("red","Inquisition Mission Failed: The radical Inquisitor has departed from the planned intercept coordinates.");
    }
    else {
        action="";
        var _gender = string_gender_third_person(_radical_inquisitor.inquisitor_gender);

        var _tixt=$"You have located the radical Inquisitor.  As you prepare to destroy their ship, and complete the mission, you recieve a hail- it appears as though {_gender} wishes to speak.";
        _radical_inquisitor.options = [
            {
                str1 : "Destroy their vessel",
                choice_func: mission_hunt_inquisitor_destroy_inquisitor_ship,
            },
            {
                str1 : "Hear them out",
                choice_func: mission_hunt_inquisitor_hear_out_radical_inquisitor,
            }
        ];
        _radical_inquisitor.inquisitor_ship = self.id;
        scr_popup("Inquisitor Located",_tixt,"inquisition",_radical_inquisitor);
    }
    //instance_destroy();
    exit;
}
function inquisition_fleet_inspection_chase(){
	var good=0,acty="";
	var reset = !instance_exists(target);
    if (!reset){
        reset = target.object_index != obj_p_fleet;
    }
	if (reset){// Reaquire target
        var target_player_fleet = get_largest_player_fleet();
        if (target_player_fleet != "none"){
            if (target_player_fleet.action == ""){
                set_fleet_target(target_player_fleet.x,target_player_fleet.y, target_player_fleet);
            } else {
                set_fleet_target(target_player_fleet.action_x,target_player_fleet.action_y, target_player_fleet);         
            }                        
        }
	}else {

        var at_star=instance_nearest(target.x,target.y,obj_star).id;
        var target_at_star=instance_nearest(x,y,obj_star).id;
        if (target.action!="") then at_star=555;
    
        if (at_star!=target_at_star){
            trade_goods+="!";
            acty="chase";
            scr_loyalty("Avoiding Inspections","+");
        }
    
        // if (string_count("!",trade_goods)>=3) then demand stop fleet
    
        
        //Inquisitor is pissed as hell
        if (string_count("!",trade_goods)=5){
            obj_controller.alarm[8]=10;
            instance_destroy();
            exit;
        }
    
    
        if (acty="chase"){
            instance_activate_object(obj_star);
            var goal_x,goal_y,target_meet=0;
        
            chase_fleet_target_set(target);
            target_meet=instance_nearest(action_x,action_y,obj_star);
            if (string_count("!",trade_goods)=4) and (instance_exists(obj_turn_end)){
        
            // color / type / text /x/y
        
                scr_alert("blank","blank","blank",target_meet.x,target_meet.y);
            
                var iq=0;
                
                if (inquisitor>0){
                    iq=inquisitor
                }

                var massa=$"Inquisitor {obj_controller.inquisitor[iq]}";
            
                if (target.action == ""){
                    massa+=$" DEMANDS that you keep your fleet at {target_meet.name} until ";
                }else if (target.action!=""){
                    massa+=$" DEMANDS that you station your fleet at {target_meet.name} until ";
                }
        
                scr_event_log("red",$"{massa} they may inspect it.");
                var _gender = string_gender_third_person(obj_controller.inquisitor_gender[iq]);

                massa+=$"{_gender} is able to complete the inspection.  Further avoidance will be met with harsh action.";

                scr_popup("Fleet Inspection",massa,"inquisition","");
        
            // scr_poup("
            }
        
            exit;
		}
    }
}
// TODO maybe have the inquisitor or his team as an actual entity that goes around and can die, which gives the player time to fix stuff 
// either kill the inquisitor or he dies in combat

// Sets up an inquisitor ship to do an inspection on the HomeWorld
function new_inquisitor_inspection(){
	var target_system = "none";
	var new_inquis_fleet;
    if (obj_ini.fleet_type == ePlayerBase.home_world) {
    	var monestary_system = "none";
        // If player does not own their homeworld than do a fleet inspection instead
        var player_stars = [];
        with(obj_star) {
            if (owner == eFACTION.Player) {
                array_push(player_stars, id);
            }
            if (system_feature_bool(p_feature, P_features.Monastery)) {
            	monestary_system = self;
            }
        }
        if (monestary_system != "none"){
        	target_system = monestary_system;
        } else if (array_length(player_stars) > 0) {
        	target_system = player_stars[0];
        }

        if (target_system != "none") {
            var target_star = target_system;
            var tar, new_inquis_fleet;
            var xx = target_star.x;
            var yy = target_star.y;

              //get the second or third closest planet to launch inquisitor from
            var from_star = distance_removed_star(target_star.x, target_star.y);
            new_inquis_fleet = instance_create(from_star.x, from_star.y, obj_en_fleet);


            with (new_inquis_fleet) {
                base_inquis_fleet();
                action_x = xx;
                action_y = yy;
                set_fleet_movement();
            }
            var mess = $"Inquisitor {obj_controller.inquisitor[new_inquis_fleet.inquisitor]}";
            mess += " wishes to inspect your chapter base at " + string(target_star.name);
            scr_alert("green", "inspect", mess, target_star.x, target_star.y);
            obj_controller.last_world_inspection = obj_controller.turn;
            // we sent an inspection, we are done
            return;
        }
    }
    // otherwise, do a fleet inspection.

    var target_player_fleet = get_largest_player_fleet();
    if (target_player_fleet != "none") {

        //get the second or third closest planet to launch inquisitor from
        var from_star = distance_removed_star(target_player_fleet.x, target_player_fleet.y);

        new_inquis_fleet = instance_create(from_star.x, from_star.y, obj_en_fleet);
        var obj;
        with (new_inquis_fleet) {
            base_inquis_fleet();
            target = target_player_fleet;
            chase_fleet_target_set(target);
            obj = instance_nearest(action_x, action_y, obj_star);
            trade_goods += "_fleet";
        }

        var mess = $"Inquisitor {obj_controller.inquisitor[new_inquis_fleet.inquisitor]}";

        mess += " wishes to inspect your fleet at " + string(obj.name);
        scr_alert("green", "inspect", mess, obj.x, obj.y);

        obj_controller.last_fleet_inspection = obj_controller.turn;

        instance_activate_object(obj_star);
    }
}

function inquisitor_ship_approaches(){
    //TODO figure out the meaning of this line
    if ((string_count("eet",trade_goods)!=0) and (string_count("_her",trade_goods)!=0)) then exit;
    var approach_system = instance_nearest(action_x,action_y,obj_star);
    var inquis_string;
    var do_alert = false;
    if (string_count("fleet",trade_goods)>0 &&  scr_valid_fleet_target(target)){
        var player_fleet_location = fleets_next_location(target);
        if (player_fleet_location != "none"){
            if (approach_system.name==player_fleet_location.name){
                inquis_string = $"Our navigators report that an inquisitor's ship is currently warping towards our flagship. It is likely that the inquisitor on board (provided he/she makes it) will attempt to perform an inspection of our flagship.";
                do_alert = true;
                if (fleet_has_roles(target, ["Ork Sniper","Flash Git","Ranger"])){
                    inquis_string+=$"Currently, there are non-imperial hirelings within the fleet. It would be wise to at least unload them on a planet below, if we wish to remain in good graces with inquisition, and possibly imperium at large.";
                }
            }
        }
    } else if (approach_system.owner  == eFACTION.Player || system_feature_bool(approach_system.p_feature, P_features.Monastery)){
        do_alert = true;
        if (system_feature_bool(approach_system.p_feature, P_features.Monastery)){
            inquis_string = $"Our astropaths report that an inquisitor's ship is currently warping towards our Fortress Monastery. It is likely that theInquisitor {obj_controller.inquisitor[inquisitor]}  will attempt to perform inspection on our Fortress Monastery.";
        } else {
            inquis_string = $"Our astropaths report that an inquisitor's ship is currently warping towards our systems under chapter control. It is likely that Inquisitor {obj_controller.inquisitor[inquisitor]}  will want to make inspections of any chapter assets and fleets in the system.";
        }
    }
    if (do_alert){
        var approach_system = instance_nearest(action_x,action_y,obj_star).name;
        if (inquisitor==0){
            scr_alert("green","duhuhuhu",$"Inquisitor Ship approaches {approach_system}.",x,y);
        } else {
            scr_alert("green","duhuhuhu",$"Inquisitor {obj_controller.inquisitor[inquisitor]} approaches {approach_system}.",x,y);
        }
        scr_popup("Inquisition Inspection", inquis_string, "");
    }
}


///@Mixin obj_star
function inquisitor_inspect_base(){
    var chapter_asset_discovery,yep=0,stop=false;
   
    if (present_fleet[1]==0){
        chapter_asset_discovery = roll_dice_chapter(20, 100, "high");
    } else {
        chapter_asset_discovery = roll_dice_chapter(2, 100, "high");
    }

    // 137 ; chapter_asset_discovery=floor(random(20))+1;

    var cur_planet=0;
    if (chapter_asset_discovery<=5){
        repeat(planets){
            cur_planet+=1;
            if (p_first[cur_planet]==1) and (p_owner[cur_planet]==2){
                p_owner[cur_planet]=1;
            }
            if (p_type[cur_planet]=="Dead") and (array_length(p_upgrades[cur_planet])>0){
                if (planet_feature_bool(p_feature[cur_planet], [P_features.SecretBase,P_features.Arsenal,P_features.GeneVault])==0) /*and (string_count(".0|",p_upgrades[cur_planet])>0)*/{
                    yep=cur_planet;
                }
            }
        }
    }
    
    //if an inquis wants to check out a dead world with chapter assets
    if (yep>0){
        var planet_coords = [x,y];
        with(obj_en_fleet){
            //checks if there is already an inquis ship investigating planet
            if (owner==4){
                if (point_distance(action_x,action_y,planet_coords[0],planet_coords[1])<30 && 
                    string_count("investigate_dead",trade_goods)>0){
                    stop=true;
                }
            }
        }
        

        if (!stop){
            var plap=0,old_x=x,old_y=y,flee=0;
            var _current_planet_name = name;
            var launch_planet, launch_point_found=false;
            launch_planet = nearest_star_with_ownership(x,y, [eFACTION.Imperium, eFACTION.Mechanicus], self.id);
            if (launch_planet != "none"){
                if (instance_exists(launch_planet)){
                    flee=instance_create(launch_planet.x,launch_planet.y,obj_en_fleet);
                    with (flee){
                        base_inquis_fleet();
                    }
                    flee.action_x=x;
                    flee.action_y=y;
                    flee.trade_goods+="|investigate_dead|";
                    with (flee){
                        set_fleet_movement();
                    }
                }
            }
        }
    }
    
}

