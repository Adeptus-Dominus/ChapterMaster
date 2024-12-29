// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_update_unit_armour(new_armour, from_armoury=true, to_armoury=true, quality="any"){
  		var arti = !is_string(new_armour);
	  	var change_armour=armour();
	  	var require_carpace=false;
	  	var armour_list=[];
	  	var same_quality = quality == "any" || quality == armour_quality;
	  	var _new_armour_data = gear_weapon_data("armour", new_armour);
	  	var _old_armour_data = gear_weapon_data("armour", armour);

	  	if (!is_struct(_new_armour_data) && !arti && new_armour!= "") then return "invalid item";

	  	var _new_power_armour=false;
	  	var _old_power_armour = false;
	  	if (is_struct(_new_armour_data)){
	  		_new_power_armour = _new_armour_data.has_tag("power_armour");
	  	}

	  	if (is_struct(_old_armour_data)){
	  		_old_power_armour = _old_armour_data.has_tag("power_armour");
	  	}	  	

	   	if ((change_armour == new_armour || ((_old_power_armour && _new_power_armour) && new_armour=="Power Armour")) && same_quality){
	   		return "no change";
	   	}

	  	if (_new_power_armour){
	  		require_carpace=true;
	  		if (new_armour=="Power Armour"){
	  			armour_list = ARR_power_armour;
	  		}
	  	} else if (new_armour="Terminator Armour"){
	  		require_carpace=true;
	  		armour_list = ["Terminator Armour","Tartarus"];
	  	}
	  	if (require_carpace){
	  		if (!get_body_data("black_carapace","torso")){
	  			return "needs_carapace";
	  		}
	  	}//using this method this should be adaptable for a whole range of classes and archeotypes
	  	if (array_length(armour_list)>0){
	  		var armour_found=false;
            for (var pa=0;pa<array_length(armour_list);pa++){
            	if (scr_item_count(armour_list[pa])>0||!from_armoury){
            		new_armour = armour_list[pa];
            		armour_found=true;
            		break;
            	}
            }
            if (!armour_found){
            	return "no_items";
            } 
        }		
	   		
	  	if (from_armoury && new_armour!="" && !arti && is_struct(_new_armour_data)){
	  		if (scr_item_count(new_armour,quality)>0){
				var exp_require = _new_armour_data.req_exp;
	  			if (exp_require>experience){
	  				return "exp_low";
	  			} 	  			
		   		quality=scr_add_item(new_armour,-1,quality);
		   		if (quality == "no_item") then return "no_items";
		   		quality = quality!=undefined ? quality:"standard";
		    } else {
				return "no_items";
		    }
		} else {
			quality = quality=="any" ? "standard" : quality;
		}
		if (change_armour != ""){
			if (to_armoury){
				if (!is_string(armour(true))){
					obj_ini.artifact_equipped[armour(true)]=false;
				} else {	
					scr_add_item(change_armour,1,armour_quality, true);
				}
			} else {
				if (!is_string(armour(true))){
					delete_artifact(armour(true));
				}
			}
		}
		var portion = hp_portion();
	    obj_ini.armour[company][marine_number] = new_armour;
	    if (arti){
	    	obj_ini.artifact_equipped[new_armour] = true;
	    	armour_quality = obj_ini.artifact_quality[new_armour];
			var arti = obj_ini.artifact_struct[new_armour];
			arti.bearer=[company,marine_number]; 		    	
	    } else {
	    	armour_quality=quality;
	    }
	    var new_arm_data = get_armour_data();
	    if (is_struct(new_arm_data)){
	    	if (new_arm_data.has_tag("terminator")){
	    		update_mobility_item("");
	    	}
	    }
	    if (armour()=="Dreadnought"){
	    	is_boarder = false;
	    	update_gear("");
	    	update_mobility_item("");
	    }
	    update_health(portion*max_health());
		get_unit_size(); //every time armour is changed see if the marines size has changed
		return "complete";
	};


function scr_update_unit_weapon_one(new_weapon,from_armoury=true, to_armoury=true,quality="any"){
  	var arti = !is_string(new_weapon);
  	var change_wep = weapon_one();
  	var weapon_list = [];
  	var same_quality = quality == "any" || quality == weapon_one_quality;
    if (new_weapon == "Heavy Ranged"){
    	weapon_list=["Multi-Melta", "Heavy Bolter","Lascannon","Missile Launcher"];
    	if (array_contains(weapon_list, change_wep) && same_quality) {
    		return "no change";
    	}
    }else if (change_wep == new_weapon && same_quality){
   		return "no change";
   	}

  	if (array_length(weapon_list)>0){
  		var weapon_found=false;
  		var _wep_choice;
  		while (array_length(weapon_list)>0){//randomises heavy weapon choice
  			_wep_choice=irandom(array_length(weapon_list)-1);
  			if (scr_item_count(weapon_list[_wep_choice])>0){
  				weapon_found=true;
  				new_weapon=weapon_list[_wep_choice];
  				break;
  			}
  			array_delete(weapon_list,_wep_choice, 1)
  		}
        if (!weapon_found){
        	return "no_items";
        } 
    } 	
  	if (from_armoury && new_weapon!="" && !arti){
  		var viability = weapon_viable(new_weapon,quality);
  		if (viability[0]){
  			quality = viability[1];
  		} else {
  			return viability[1];
  		}
	}else {
		quality = quality=="any"?"standard":quality;
	}

	if (change_wep != ""){
		if(to_armoury){
			if (!is_string(weapon_one(true))){
				obj_ini.artifact_equipped[weapon_one(true)]=false;
			} else {			
				scr_add_item(change_wep,1, weapon_one_quality, true);
			}
		} else {
			if (!is_string(weapon_one(true))){
				delete_artifact(weapon_one(true));
			}
		}
	}       	
    obj_ini.wep1[company][marine_number] = new_weapon;
 	if (arti){
    	obj_ini.artifact_equipped[new_weapon] = true;
		var arti = obj_ini.artifact_struct[new_weapon];
		arti.bearer=[company,marine_number];    	
    	weapon_one_quality = obj_ini.artifact_quality[new_weapon];
    } else {
    	weapon_one_quality=quality;
    }
     return "complete";
};

function scr_update_unit_weapon_two(new_weapon,from_armoury=true, to_armoury=true, quality="any"){
  		var arti = !is_string(new_weapon);
	   	var change_wep = weapon_two();
	   	var same_quality = quality == "any" || quality == weapon_two_quality;
	  	if (change_wep == new_weapon && same_quality){
	   		return "no change";
	   	}     	
	  	if (from_armoury) and (new_weapon!="") && (!arti){
	  		var viability = weapon_viable(new_weapon,quality);
	  		if (viability[0]){
	  			quality = viability[1];
	  		} else {
	  			return viability[1];
	  		}
		} else {
			quality = quality=="any"?"standard":quality;
		}
		if (change_wep != ""){
			if (to_armoury){
				if (!is_string(weapon_two(true))){
					obj_ini.artifact_equipped[weapon_two(true)]=false;
				}else {
					scr_add_item(change_wep,1, weapon_two_quality, true);
				}
			} else {
				if (!is_string(weapon_two(true))){
					delete_artifact(weapon_two(true))
				}
			}	
		}      	
    	obj_ini.wep2[company][marine_number] = new_weapon;
	 	if (arti){
	    	obj_ini.artifact_equipped[new_weapon] = true;
	    	weapon_two_quality = obj_ini.artifact_quality[new_weapon];
			var arti = obj_ini.artifact_struct[new_weapon];
			arti.bearer=[company,marine_number]; 	    	
	    } else {
	    	weapon_two_quality=quality;
	    }
    	return "complete";
	};


function scr_update_unit_gear(new_gear,from_armoury=true, to_armoury=true, quality="any"){
	var arti = !is_string(new_gear);
	var change_gear = gear();
	var same_quality = quality == "any" || quality == gear_quality;
	if (change_gear == new_gear && same_quality){
 		return "no change";
 	}
  	if (from_armoury) and (new_gear!="") and (!arti){
  		if (scr_item_count(new_gear,quality)>0){
			var exp_require = gear_weapon_data("gear", new_gear, "req_exp", false, quality);
  			if (exp_require>experience){
  				return "exp_low";
  			}
	   		quality=scr_add_item(new_gear,-1, quality);
	   		if (quality == "no_item") then return "no_items";
	   		quality = quality!=undefined? quality:"standard";
	    } else {
	    	return "no_items";
	    }
	} else {
		quality = quality=="any"?"standard":quality;
	}

	var portion = hp_portion();
	if (change_gear != ""){
		if (to_armoury){
			if (!is_string(gear(true))){
				obj_ini.artifact_equipped[gear(true)]=false;
			} else {			
				scr_add_item(change_gear,1,gear_quality, true);
			}
		} else {
			if (!is_string(gear(true))){
				delete_artifact(gear(true));
			}
		}
	}  			
	obj_ini.gear[company][marine_number] = new_gear;
 	if (arti){
    	obj_ini.artifact_equipped[new_gear] = true;
    	gear_quality = obj_ini.artifact_quality[new_gear];
		var arti = obj_ini.artifact_struct[new_gear];
		arti.bearer=[company,marine_number]; 	    	
    } else {
    	gear_quality=quality;
    }	
	update_health(portion*max_health());
	 return "complete";
}

function scr_update_unit_mobility_item(new_mobility_item, from_armoury = true, to_armoury=true, quality="any"){
	var arti = !is_string(new_mobility_item);
	var _old_mobility_item=mobility_item();
	new_mobility_item = arti ? obj_ini.artifact[new_mobility_item] : new_mobility_item;

	if (new_mobility_item != ""){
		var _armour_data = get_armour_data();
		if (is_struct(_armour_data)){
			if (_armour_data.has_tag("terminator")){
				if (!array_contains(["Servo-arm", "Servo-harness", "Conversion Beamer Pack"], new_mobility_item)) {
					return "incompatible with terminator";
				}
			}

			//can probably condense the next 10 lines at some point
			//TODO move to tag system
			if (new_mobility_item=="Jump Pack" && !_armour_data.has_tag("power_armour")){
				return "requires power armour";
			}
		} else {
			if (new_mobility_item=="Jump Pack"){
				return "requires power armour";
			}			
		}
	}
	var same_quality = quality == "any" || quality == mobility_item_quality;
	if (_old_mobility_item == new_mobility_item && same_quality){
		return "no change";
	}
  	if (from_armoury && new_mobility_item!="" && !arti){
  		if (scr_item_count(new_mobility_item, quality)>0){
			var exp_require = gear_weapon_data("weapon", new_mobility_item, "req_exp", false, quality);
  			if (exp_require>experience){
  				return "exp_low";
  			} 	  				  			
	   		quality=scr_add_item(new_mobility_item,-1, quality);
	   		quality = quality!=undefined? quality:"standard";
	    } else {
	    	return "no_items";
	    }
	} else {
		quality= quality=="any"?"standard":quality;
	}
	var portion = hp_portion();
	if (_old_mobility_item != ""){
		if(to_armoury){
			if (!is_string(mobility_item(true))){
				obj_ini.artifact_equipped[mobility_item(true)]=false;
			} else {
				scr_add_item(_old_mobility_item,1,mobility_item_quality, true );
			}
		} else if (!is_string(mobility_item(true))){
			delete_artifact(mobility_item(true));
		}
	}
	obj_ini.mobi[company][marine_number] = new_mobility_item;
 	if (arti){
    	obj_ini.artifact_equipped[new_mobility_item] = true;
    	mobility_item_quality = obj_ini.artifact_quality[new_mobility_item];
    	var arti = obj_ini.artifact_struct[new_mobility_item];
		arti.bearer=[company,marine_number]; 	
    } else {
    	mobility_item_quality=quality;
    }		
	update_health(portion*max_health());
	get_unit_size(); //every time mobility_item is changed see if the marines size has changed
	return "complete";
}


function alter_unit_equipment(update_equipment, from_armoury=true, to_armoury=true, quality="any"){
	var equip_areas = struct_get_names(update_equipment);
	for (var i=0;i<array_length(equip_areas);i++){
		switch(equip_areas[i]){
			case "wep1":
				update_weapon_one(update_equipment[$ equip_areas[i]],from_armoury,to_armoury,quality);
				break;
			case "wep2":
				update_weapon_two(update_equipment[$ equip_areas[i]],from_armoury,to_armoury,quality);
				break;
			case "mobi":
				update_mobility_item(update_equipment[$ equip_areas[i]],from_armoury,to_armoury,quality);
				break;
			case "armour":
				update_armour(update_equipment[$ equip_areas[i]],from_armoury,to_armoury,quality);
				break;
			case "gear":
				update_gear(update_equipment[$ equip_areas[i]],from_armoury,to_armoury,quality);
				break;								
		}
	}
}