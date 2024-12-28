
function apothecary_simple(){
	var company, v, unit, mar_loc, array_slot, is_healer, is_tech, key_val,veh_location;
	var tech_spread = {};
	var apoth_spread = {};
	var unit_spread = {};
 	obj_controller.command=0;
 	obj_controller.marines=0;
    marines-=1;
    for(company=0;company<11;company++){
    	for (v=0;v<500;v++){
    		key_val = "";
    		if (obj_ini.name[company][v]=="") then continue;
    		unit = fetch_unit([company, v]);
    		mar_loc = unit.marine_location();
    		if (unit.base_group=="astartes"){
	    		if (unit.IsSpecialist()){
	    			obj_controller.command++;
	    		} else {
	    			obj_controller.marines++;
	    		}
	    	}
	                
		    is_tech = (unit.IsSpecialist("forge") && unit.hp()>=10);
		    is_healer = (((unit.IsSpecialist("apoth",true) && unit.gear()=="Narthecium") || (unit.role()=="Sister Hospitaler")) && unit.hp()>=10);
		  	if (mar_loc[2]!="warp"){
  	    		if (mar_loc[0]=location_types.planet){
  	    			array_slot = mar_loc[1];
  	    		} else if (mar_loc[0] == location_types.ship){
  	    			array_slot=0;
  	    		}
  	    		key_val = mar_loc[2];
  	    	} else if (mar_loc[0] == location_types.ship){
  	    		if instance_exists(obj_p_fleet){
  	    			with (obj_p_fleet){
  	    				if (array_contains(capital_num, mar_loc[1]) ||
  	    					array_contains(frigate_num, mar_loc[1])||
  	    					array_contains(escort_num, mar_loc[1])
  	    				){
  	    					key_val=string(id);
  	    					array_slot=0;
  	    					break;
  	    				}
  	    			}
  	    		}
  	    	}
  	    	if (key_val!=""){
				if (! struct_exists(unit_spread, key_val)){
					unit_spread[$key_val] = [[],[],[],[],[]];
					tech_spread[$key_val]  = [[],[],[],[],[]];
					apoth_spread[$key_val]  = [[],[],[],[],[]];
				}
				array_push(unit_spread[$key_val][array_slot] ,unit);
				if (is_tech){
					array_push(tech_spread[$key_val][array_slot] ,unit);
				}
				if (is_healer)	{
					array_push(apoth_spread[$key_val][array_slot] ,unit);
				}		
			}
			key_val="";
            if (v<array_length(obj_ini.veh_hp[company]) && company>0){
            	if (obj_ini.veh_race[company][v]!=0){
            		if(obj_ini.veh_lid[company][v]>0){
	            		veh_location = obj_ini.veh_lid[company][v];
	            		if (obj_ini.ship_location[veh_location] == "warp"){
			  	    		if instance_exists(obj_p_fleet){
			  	    			with (obj_p_fleet){
			  	    				if (array_contains(capital_num, veh_location) ||
			  	    					array_contains(frigate_num, veh_location)||
			  	    					array_contains(escort_num, veh_location)
			  	    				){
			  	    					key_val=string(id);
			  	    					array_slot=0;
			  	    					break;
			  	    				}
			  	    			}
			  	    		}
			  	    	} else if (obj_ini.ship_location[veh_location] != ""){
			  	    		array_slot=0;
			  	    		key_val=obj_ini.ship_location[veh_location];
			  	    	}
		            }            	
	            	if (obj_ini.veh_wid[company][v]>0){
	            		key_val = obj_ini.veh_loc[company][v];
	            		if (key_val!=""){
		            		array_slot = obj_ini.veh_wid[company][v];
						}     		
	            	}
	  	    		if (key_val!=""){
						if (! struct_exists(unit_spread, key_val)){
							unit_spread[$key_val] = [[],[],[],[],[]];
							tech_spread[$key_val]  = [[],[],[],[],[]];
							apoth_spread[$key_val]  = [[],[],[],[],[]];
						}
						array_push(unit_spread[$key_val][array_slot] ,[company,v]);	  	    		
	            	}
	            }           	
            }			
	    }
	}
	var locations = struct_get_names(unit_spread);
	with (obj_star){
		for (i=0;i<array_length(locations);i++){
			if (locations[i] == name){
				array_push(unit_spread[$ locations[i]], self)
			}
		}
	}
	var cur_units, cur_apoths, cur_techs, total_heal_points, total_tech_points, veh_health, points_spent, cur_system, features;
	var p, i, a;
	var total_bionics = scr_item_count("Bionics");
	for (i=0;i<array_length(locations);i++){
		cur_system="";
		if (array_length(unit_spread[$locations[i]]) == 6){
			cur_system = unit_spread[$locations[i]][5];
		}		
		for (p=0;p<5;p++){
			total_heal_points=0;
			total_tech_points=0;
			if (array_length(unit_spread[$locations[i]][p]) == 0) then continue;
			cur_units = unit_spread[$locations[i]][p];
			cur_apoths = apoth_spread[$locations[i]][p];
			cur_techs = tech_spread[$locations[i]][p];
			for (a=0;a<array_length(cur_apoths);a++){
				unit = cur_apoths[a];
				total_heal_points+=((unit.technology/2)+(unit.wisdom/2)+unit.intelligence)/8;
			}
			for (a=0;a<array_length(cur_techs);a++){
				unit = cur_techs[a];
				total_tech_points += unit.forge_point_generation()[0];
			}
			for (a=0;a<array_length(cur_units);a++){
				points_spent = 0;
				unit = cur_units[a];
				if (is_array(unit) && total_tech_points>0){
					if (array_length(unit)>1){
						while (points_spent<10 && obj_ini.veh_hp[unit[0]][unit[1]]<100 && total_tech_points>0){
							points_spent++;
							obj_ini.veh_hp[unit[0]][unit[1]]++;
							total_tech_points--;
						}
					}
				} else if (is_struct(unit)){
					if  (unit.hp() < unit.max_health()){
						if (unit.armour() != "Dreadnought"){
							if (unit.hp()>0){
			        			if (total_heal_points >0){
			        				unit.healing(true);
			        				total_heal_points--;
			        			} else {
			        				unit.healing(false);
			        			}	
							} else if (total_heal_points>0 && total_tech_points>=3 && unit.bionics<10){
								unit.add_bionics();
								total_heal_points--;
								total_tech_points-=3;
							}			
						} else {
							if (total_heal_points>0 && total_tech_points>=3 && unit.hp()>0){
								unit.healing(true);
								total_heal_points--;
								total_tech_points-=3;							
							}
						}
					}
				}
			}
			if (cur_system!="" && p>0){
				with (cur_system){
		 			if (array_length(p_feature[p])!=0){
			        	var engineer_count=array_length(cur_techs);
						if (planet_feature_bool(p_feature[p],P_features.Starship)==1 && engineer_count>0){
		
			                var starship = p_feature[p][search_planet_features(p_feature[p],P_features.Starship)[0]];
			                var engineer_score_start = starship.engineer_score;
		                	if (starship.engineer_score<2000){
			                	for (var v=0;v<engineer_count;v++){
			                		starship.engineer_score += (cur_techs[v].technology/2);
			                	}
			                	scr_alert("green","owner",$"Ancient ship repairs {min((starship.engineer_score/2000)*100, 100)}% complete",x,y);
		                	}
		            
			                var maxr=0,requisition_spend=0,target_spend=10000;
		
			                maxr=floor(obj_controller.requisition/50);
			                requisition_spend=min(maxr*50,array_length(cur_techs)*50,target_spend-starship.funds_spent);
			                obj_controller.requisition-=requisition_spend;
			                starship.funds_spent+=requisition_spend;
		                
			                if (requisition_spend>0) and (starship.funds_spent<target_spend){
			                    scr_alert("green","owner",$"{requisition_spend} Requision spent on Ancient Ship repairs in materials and outfitting (outfitting {(starship.funds_spent/target_spend)*100}%)",x,y);
			                }
			                if (starship.funds_spent>=target_spend) and(starship.engineer_score>=2000){// u2=tar;
			                    delete_features(cur_system.p_feature[p],P_features.Starship);
		                    
			                    var locy=$"{name} {scr_roman_numerals()[p-1]}";
		                    
			                    var flit=instance_create(cur_system.x+24,cur_system.y-24,obj_p_fleet);
			                    var s=0,ship_names="",new_name="",last_ship=0;
			                    for(s=1;s<=40;s++){
			                        if (last_ship=0) and (obj_ini.ship[s]="") then last_ship=s;
			                    };
		                    
			                    new_name="Slaughtersong";
		                    
			                    obj_ini.ship[last_ship]=new_name;
			                    obj_ini.ship_uid[last_ship]=floor(random(99999999))+1;
			                    obj_ini.ship_owner[last_ship]=1;
			                    obj_ini.ship_size[last_ship]=3;
			                    obj_ini.ship_location[last_ship]=name;
			                    obj_ini.ship_leadership[last_ship]=100;
		                    
			                    obj_ini.ship_class[last_ship]="Slaughtersong";
		                    
			                    obj_ini.ship_hp[last_ship]=2400;
			                    obj_ini.ship_maxhp[last_ship]=2400;
			                    obj_ini.ship_conditions[last_ship]="";
			                    obj_ini.ship_speed[last_ship]=25;
			                    obj_ini.ship_turning[last_ship]=60;
			                    obj_ini.ship_front_armour[last_ship]=8;
			                    obj_ini.ship_other_armour[last_ship]=8;
			                    obj_ini.ship_weapons[last_ship]=4;
			                    obj_ini.ship_shields[last_ship]=24;
			                    obj_ini.ship_wep[last_ship,1]="Lance Battery";
			                    ship_wep_facing[last_ship,1]="most";
			                    obj_ini.ship_wep_condition[last_ship,1]="";
			                    obj_ini.ship_wep[last_ship,2]="Lance Battery";
								ship_wep_facing[last_ship,2]="most";
			                    obj_ini.ship_wep_condition[last_ship,2]="";
			                    obj_ini.ship_wep[last_ship,3]="Lance Battery";
			                    ship_wep_facing[last_ship,3]="most";
			                    obj_ini.ship_wep_condition[last_ship,3]="";
			                    obj_ini.ship_wep[last_ship,4]="Plasma Cannon";
			                    ship_wep_facing[last_ship,4]="front";
			                    obj_ini.ship_wep_condition[last_ship,4]="";
			                    obj_ini.ship_capacity[last_ship]=800;
			                    obj_ini.ship_carrying[last_ship]=0;
			                    obj_ini.ship_contents[last_ship]="";
			                    obj_ini.ship_turrets[last_ship]=8;
		                    
			                    flit.capital[1]=obj_ini.ship[last_ship];
			                    flit.capital_number=1;
			                    flit.capital_num[1]=last_ship;
			                    flit.capital_uid[1]=obj_ini.ship_uid[last_ship];
			                    flit.oribiting = cur_system.id;
		                    
			                    scr_popup($"Ancient Ship Restored",$"The ancient ship within the ruins of {locy} has been fully repaired.  It is determined to be a Slaughtersong vessel and is bristling with golden age weaponry and armour.  Your {string(obj_ini.role[100][16])}s are excited; the Slaughtersong is ready for it's maiden voyage, at your command.","","");                
			                }
			            }
			        }
			    }
		    }		
		}
	}
}




