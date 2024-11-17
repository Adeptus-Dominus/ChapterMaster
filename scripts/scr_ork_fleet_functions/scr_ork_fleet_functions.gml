// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_ork_fleet_functions(){

}

function new_ork_fleet(xx,yy){
    fleet=instance_create(xx,yy,obj_en_fleet);
    fleet.owner = eFACTION.Ork;
    fleet.sprite_index=spr_fleet_ork;
    fleet.image_index=1;
    fleet.capital_number=1;
    present_fleet[7] = 1;
}

function build_new_ork_ships_to_fleet(star, planet){

    // Increase ship number for this object?
    var rando=irandom(101);
    if (obj_controller.known[eFACTION.Ork]>0) then rando-=10;
    if (star.p_type[planet]=="Forge"){
        rando-=20;
    } else if (star.p_type[planet]=="Hive"){
        rando-=10;
    }else if (star.p_type[planet]=="Shrine" || star.p_type[planet]=="Temperate"){
        rando-=5;
    }
    if (rando<=15){// was 25
        rando=choose(1,1,1,1,1,1,1,3,3,3,3);
        if (capital_number<=0) then rando = 3;
        if (rando=1) then capital_number+=1;
        // if (rando=2) then fleet.frigate_number+=1;
        if (rando=3) then escort_number+=1;
    }
    var ii=0;
    ii+=capital_number;
    ii+=round((frigate_number/2));
    ii+=round((escort_number/4));
    if (ii<=1) then ii=1;
    image_index=ii;	
	//if big enough flee bugger off to new star
    if (image_index>=5){
    	instance_deactivate_object(star);
        with(obj_star){
        	if (is_dead_star()){
        		instance_deactivate_object(id);
        	} else {
                if (owner == eFACTION.Ork || array_contains(p_owner, eFACTION.Ork)){
                    instance_deactivate_object(id);
                }            		
        	}
        }
    	var new_wagh_star = instance_nearest(x,y,obj_star);
        if (instance_exists(new_wagh_star)){
            action_x=new_wagh_star.x;
            action_y=new_wagh_star.y;
            action = "";
            set_fleet_movement();
        }
    
    }
	instance_activate_object(obj_star);
}



function ork_fleet_move(){
    var bad = is_dead_star(instance_nearest(x,y,obj_star));
    
    if (bad){
        var hides=choose(1,2,3);
        
        repeat(hides){
            instance_deactivate_object(instance_nearest(x,y,obj_star));
        }
        
        with(obj_star){
            if (is_dead_star() || owner=eFACTION.Ork || scr_orbiting_fleet(eFACTION.Ork) !="none") then instance_deactivate_object(id);
        }
        var nex=instance_nearest(x,y,obj_star);
        action_x=nex.x;
        action_y=nex.y;
        action="";
        set_fleet_movement();

        instance_activate_object(obj_star);
        exit;
    }    
}

function ork_fleet_arrive_target(){

    instance_activate_object(obj_en_fleet);
    var boat=instance_nearest(x,y,obj_en_fleet);

    var aler=0;

    if (present_fleet[1]+present_fleet[2]=0) and (present_fleet[7]>0) and (boat.owner = eFACTION.Ork) and (boat.action=="") and (planets>0){
        var landi=0,t1=0,l=0;
    
        repeat(planets){
            l+=1;
            if (t1=0) and (p_tyranids[l]>0) then t1=l;
        }
        if (t1>0) then p_tyranids[t1]-=boat.capital_number+(boat.frigate_number/2);
        if (p_tyranids[t1]<=0){
            if (planet_feature_bool(p_feature[t1], P_features.Gene_Stealer_Cult)==1){
                delete_features(p_feature[t1], P_features.Gene_Stealer_Cult);
                adjust_influence(eFACTION.Tyranids, -25, t1);
                var nearest_imperial = nearest_star_with_ownership(x,y,eFACTION.Imperium, self.id);
                if (nearest_imperial != "none"){
                    var targ_planet = scr_get_planet_with_owner(nearest_imperial,eFACTION.Imperium);
                    new_colony_fleet(self.id, t1, nearest_imperial.id, targ_planet, "refugee");
                }
            }
        }
        
        landi = !is_dead_star();
        if (!landi){
            for (var i=1;i<=planets;i++){
                if ((p_guardsmen[i]+p_pdf[i]+p_player[i]+p_traitors[i]+p_tau[i]>0) or ((p_owner[i]!=7) and (p_orks[i]<=0))){
                    if (p_type[i]!="Dead") and (p_orks[i]<4) and (i<=planets) and (instance_exists(boat)){
                        p_orks[i]+=max(2,floor(boat.image_index*0.8));
                    

                        if (fleet_has_cargo("ork_warboss",boat)){
                            array_push(p_feature[i], boat.carg_data.ork_warboss);
                            p_orks[i]=6;
                        }

                    
                        if (p_orks[i]>6) then p_orks[i]=6;
                        with(boat){instance_destroy();}
                        aler=1;
                    }                    
                } else {
                    var new_wagh_star = distance_removed_star(x,y, choose(2,3,4,5));
                    if (instance_exists(new_wagh_star)){
                        action_x=new_wagh_star.x;
                        action_y=new_wagh_star.y;
                        action = "";
                        set_fleet_movement();
                    }                    
                }
            }
        }
    
        if (aler>0) then scr_alert("green","owner",$"Ork ships have crashed across the {name} system.",x,y);


    }// End landing portion of code

}

