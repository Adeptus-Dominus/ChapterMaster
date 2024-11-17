// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function imperial_navy_fleet_construction(){
	// ** Check number of navy fleets **

	var new_navy_fleets = [];
	with(obj_en_fleet){
	    if (owner==eFACTION.Imperium) and (navy==1) {
	    	array_push(new_navy_fleets, id);
	    }
	}
	//delete navy fleets if more than required
	var navy_fleet_count = array_length(new_navy_fleets);
	var cur_fleet;
	if (navy_fleet_count>target_navy_number) {
		for (var i=0;i<navy_fleet_count;i++){
			cur_fleet = new_navy_fleets[i];
			if (cur_fleet.guardsmen_unloaded){
				continue;
			} else {
				instance_destroy(cur_fleet);
				navy_fleet_count--;
				array_delete(new_navy_fleets, i, 1);
				i--;
				if (navy_fleet_count<=target_navy_number) then break;
			}
		} 

		//if system needs more navy fleets get forge world to make some
	} else if (navy_fleet_count<target_navy_number) {
		var forge_systems = [];
	    with(obj_star){
	        var good=false;
	        for(var o=1; o<=planets; o++) {
	            if (p_type[o]=="Forge") 
					and (p_owner[o]==eFACTION.Mechanicus) 
					and (p_orks[o]+p_tau[o]+p_tyranids[o]+p_chaos[o]+p_traitors[o]+p_necrons[o]==0) {
						
						var enemy_fleets = [
							eFACTION.Ork,
							eFACTION.Tau,
							eFACTION.Tyranids,
							eFACTION.Chaos,
							eFACTION.Necrons
						]
					
						var enemy_fleet_count = array_reduce(enemy_fleets, function(prev, curr) {
							return prev + present_fleet[curr]
						})
			            if (enemy_fleet_count == 0){
			                good=true;
			                if (instance_nearest(x,y,obj_en_fleet).navy) then good=false;
			            }
	            }
	        }
	        if (good){
	        	good = x<=room_width && y<=room_height;
	        }
	        if (good==true) then array_push(forge_systems, id);
	    }
	// After initial navy fleet construction fleet growth is handled in obj_en_fleet.alarm_5
		if (array_length(forge_systems)){
		    var construction_forge,new_navy_fleet;
		    construction_forge=choose_array(forge_systems);
		    new_navy_fleet=instance_create(construction_forge.x,construction_forge.y,obj_en_fleet);
		    new_navy_fleet.owner=eFACTION.Imperium;
		    
		    new_navy_fleet.capital_number=0;
		    new_navy_fleet.frigate_number=0;
		    new_navy_fleet.escort_number=1;
		    new_navy_fleet.home_x=x;
		    new_navy_fleet.home_y=y;
		    new_navy_fleet.warp_able = true;
		    with(construction_forge){present_fleet[2]+=1;}
		    new_navy_fleet.orbiting=construction_forge;
		    new_navy_fleet.navy=1;
		    
		    var total_ships=0;
		    total_ships+=new_navy_fleet.capital_number-1;
		    total_ships+=round((new_navy_fleet.frigate_number/2));
		    total_ships+=round((new_navy_fleet.escort_number/4));
		    if (total_ships<=1) and (new_navy_fleet.capital_number+new_navy_fleet.frigate_number+new_navy_fleet.escort_number>0) then total_ships=1;
		    new_navy_fleet.image_index=total_ships;
		    new_navy_fleet.image_speed=0;
		    
		    new_navy_fleet.trade_goods="building_ships";
		}
	}
}
