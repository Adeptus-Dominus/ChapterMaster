function scr_check_equip(search_item, system, planet_or_ship_id, remove_item) {

	// search_item: the item in question
	// system: planet name, or "" for space
	// planet_or_ship_id: planet or SID
	// remove_item: remove?

	// Checks if an item is equip to a marine at the location



	var man_c=0,man_i=0,have=0, unit, marine_present;

	for (var c=0;c<=10;c++){
	    for (var i=1;i<=500;i++){
    		if (obj_ini.name[c][i]=="") then continue;
    		marine_present=false;
	    	if (!instance_exists(obj_ncombat)){ 
				unit = obj_ini.TTRPG[c][i];
		        if (system!="") and (planet_or_ship_id>0){
		            if (unit.is_at_location(system,planet_or_ship_id,-1)){
		            	marine_present=true;
		            }
		        }
		        if (system="") and (planet_or_ship_id>0){
		            if (unit.is_at_location("",0,planet_or_ship_id)){
		            	marine_present=true;
		            }
		        }
	    	} else {
				try {
					if (obj_ncombat.fighting[c][i]==1){
						marine_present=true;
					} 
				} catch (_){}
	    	}
	    	if (marine_present){
	    		if (unit.weapon_one()==search_item){
	    			if (remove_item>0){
	    				unit.update_weapon_one("",false,false);
	    				remove_item-=1
	    			}
					have++;
	    		}
	    		if (unit.weapon_two()==search_item){
	    			if (remove_item>0){
	    				unit.update_weapon_two("",false,false);
	    				remove_item-=1
	    			}
					have++;
	    		} else if (unit.armour()==search_item){
	    			if (remove_item>0){
	    				unit.update_armour("",false,false);
	    				remove_item-=1
	    			}
					have++;
	    		} else if(unit.mobility_item()==search_item){
	    			if (remove_item>0){
	    				unit.update_mobility_item("",false,false);
	    				remove_item-=1
	    			}
					have++;
	    		}else if(unit.gear()==search_item){
	    			if (remove_item>0){
	    				unit.update_gear("",false,false);
	    				remove_item-=1
	    			}
					have++;
	    		}  	    		
	    	}
	    }
    
	}
	return have;


}
