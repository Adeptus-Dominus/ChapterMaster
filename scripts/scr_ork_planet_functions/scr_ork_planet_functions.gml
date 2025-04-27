// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
    // Check for industrial facilities
    // Used to not have Ice either
function ork_ship_production(planet){
    if (array_contains(["dead", "lava", "ice"], p_type[planet])){
        exit;
    }
    // Have the proppa facilities and size
    if (p_orks[planet]>=4){
        var fleet=0;
        contin=2;
        if (instance_number(obj_en_fleet)==0) then contin=3;
        if (instance_number(obj_en_fleet)>0) then contin=2;
        
        if (instance_exists(obj_p_fleet)){
            var nearestPlayerFleet=instance_nearest(x,y,obj_p_fleet);
            if (point_distance(x,y,nearestPlayerFleet.x,nearestPlayerFleet.y)<50) and (nearestPlayerFleet.action==""){
                exit;
            }
        }
        if (contin==2){
            fleet=scr_orbiting_fleet(eFACTION.Ork);
            if (fleet=="none") then contin=3;
            if (fleet!="none") and (contin!=3){
                rando=choose(1,1,1,1,1,2,2,2,2);
                switch (rando) {
                    case 1:
                        fleet.capital_number += 1;
                        break;
                    case 2:
                        fleet.escort_number += 1;
                        break;
                }
                
                if (fleet.image_index>=5){
                    var nearestStar=0,targetStar=0;
                    var locationOk=false;
                    
                    with(obj_star){
                        if (planets==1) and (p_type[1]=="Dead") then instance_deactivate_object(instance_id_get( 0 ));
                    }
                    nearestStar=instance_nearest(fleet.x,fleet.y,obj_star);
                    instance_deactivate_object(nearestStar);
                    for(var j=0; j<10; j++){
                        if (!locationOk){
                            targetStar=instance_nearest(fleet.x+choose(random(400),random(400)*-1),fleet.y+choose(random(100),random(100)*-1),obj_star);
                            if (targetStar.owner != eFACTION.Ork) then locationOk=true;
                            // New code testing
                            if (nearestStar.owner == eFACTION.Ork) and (instance_exists(nearestStar)){
                                if (nearestStar.present_fleet[7]>0){
                                    var fli=instance_nearest(nearestStar.x,nearestStar.y,obj_en_fleet);
                                    if (fli.action=="") and (owner != eFACTION.Ork) and (point_distance(nearestStar.x,nearestStar.y,fli.x,fli.y)<60) then locationOk=true;
                                    if (fli.action=="") and (owner != eFACTION.Ork) and (point_distance(nearestStar.x,nearestStar.y,fli.x,fli.y)<60) then locationOk=true;
                                }
                            }// End new code testing
                            
                            if (targetStar.planets==0) then locationOk=false;
                            if (targetStar.planets==1) and (targetStar.p_type[1]=="Dead") then locationOk=false;
                        }
                    }
                    fleet.action_x=targetStar.x;
                    fleet.action_y=targetStar.y;
                    fleet.alarm[4]=1;// present_fleets-=1;
                    instance_activate_object(obj_star);
                }
            }
        }
        if (contin==3 && irandom_range(1,100)<=25){// Create a fleet
            // fleet=instance_create
            fleet=instance_create(x,y,obj_en_fleet);
            fleet.owner = eFACTION.Ork;
            fleet.sprite_index=spr_fleet_ork;
            fleet.image_index=1;
            fleet.capital_number=2;
            // present_fleets+=1;
        }
    }

}

function kill_warboss(){
	f_type = P_features.Victory_Shrine
	planet_display= $"{obj_controller.faction_leader[eFACTION.Ork]} Death Place";
	Warboss = "dead";
	parade = false;
}