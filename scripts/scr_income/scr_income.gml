function scr_income() {

	// Determines income


	income_base=32;income_tribute=0;income_controlled_planets=0;
	if (obj_ini.fleet_type != ePlayerBase.home_world) then income_base=40;

	income_home=0;
	if (obj_ini.fleet_type=ePlayerBase.home_world) then income_home=8;// Homeworld-based income

	income_fleet=0;
	with(obj_p_fleet){
	    obj_controller.income_fleet-=capital_number;
	    obj_controller.income_fleet-=frigate_number/2;
	    obj_controller.income_fleet-=escort_number/10;
	}
	if (obj_ini.fleet_type = ePlayerBase.home_world) then obj_controller.income_fleet=round(obj_controller.income_fleet/2);

	income_forge=0;
	income_agri=0;
	income_training=0;

    if (obj_controller.faction_status[eFACTION.Mechanicus] != "War") {
        var _chapter_tech_count = scr_role_count(obj_ini.role[100][eROLE.Techmarine], "");
        if (_chapter_tech_count >= ((disposition[3] / 2) + 5)) {
            training_techmarine = 0;
        }
    }

    static training_cost_chart = [0,1,2,3,4,6,12];

    var training_sets = [training_apothecary,training_chaplain,training_psyker,training_techmarine];
    for (var i=0;i<array_length(training_sets);i++){
    	if (training_sets[i] > 0 && training_sets[i] < 7){
    		income_training -=training_sets[training_sets[i]];
    	}
    }

	tau_stars=0;
	if (instance_exists(obj_turn_end)) then tau_messenger+=1;

	if (obj_ini.fleet_type=ePlayerBase.home_world){
	    with(obj_star){
	    	if (system_feature_bool(P_features.Monastery)){
	    		obj_controller.income+=10;
	    		var _joined = nearest_warp_joined(self);
	    		if (_joined!="none"){
	    			with (_joined){
				        for(var i=1; i<=planets; i++){
				            if (p_type[i]=="Forge") and (p_owner[i]==3) then obj_controller.income_forge+=6;
				            if (p_type[i]=="Agri") and (p_owner[i]==2) then obj_controller.income_agri+=3;
				        }	    				
	    			}
	    		} else {
	    			var _nearest = distance_removed_star(x, y, 1);
	    			if (point_distance(x,y,_nearest.x,_nearest.y) <= 180){
	    				with (nearest){
				            if (p_type[i]=="Forge") and (p_owner[i]==3) then obj_controller.income_forge+=6;
				            if (p_type[i]=="Agri") and (p_owner[i]==2) then obj_controller.income_agri+=3;	 
				        }   				
	    			}
	    		}
	    	}
	        if (owner = eFACTION.Tau){
	        	obj_controller.tau_stars+=1;
	        }
	    }
	}

	if (obj_ini.fleet_type != ePlayerBase.home_world){
	    with(obj_p_fleet){
	        if (action="") and (capital_number>0){
	            var mine;mine=instance_nearest(x,y,obj_star);
	            var i;i=0;
	            repeat(4){i+=1;
	                if (mine.p_owner[i]=eFACTION.Imperium) or (mine.p_owner[i]=eFACTION.Mechanicus){
	                    if (mine.p_type[i]="Desert") or (mine.p_type[i]="Temperate") then obj_controller.income_home+=2*capital_number;
	                    if (mine.p_type[i]="Forge") or (mine.p_type[i]="Hive") then obj_controller.income_home+=4*capital_number;
	                }
	            }
	        }
	    }
	}


	with(obj_star){
	    var o=0;
	    repeat(planets){
	    	o+=1;
	        if (dispo[o]>=100){
	            if (planet_feature_bool(p_feature[1], P_features.Monastery)==0){
	                obj_controller.income_controlled_planets+=1;obj_controller.income_tribute+=1;
	                if (p_type[o]="Feudal") then obj_controller.income_tribute+=1;
	                if (p_type[o]="Desert") or (p_type[o]="Temperate") then obj_controller.income_tribute+=2;
	                if (p_type[o]="Forge") or (p_type[o]="Hive") then obj_controller.income_tribute+=3;
	            }
	        }
	    }
	}




	obj_controller.alarm[4]=10;
	// This tells the controller to give moolah if it is the end of the turn


}
