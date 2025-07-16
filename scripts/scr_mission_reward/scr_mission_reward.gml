function scr_mission_reward(mission, star, planet) {

	// mission: mission designation
	// star: target star system
	// planet: planet number

	// "mech_bionics",id,i
	// "mech_raider",id,i

	var cleanup,i;cleanup=0;i=-1;
	repeat(11){i+=1;cleanup[i]=0;}




	if (mission="mars_spelunk"){


	    var roll1=roll_dice_chapter(1, 100, "high");;// For the first STC
	    var found_stc=0,found_artifact=0,found_requisition=0;
	    var techs_lost=0, techs_alive=0;

	    var _conditions = {job : "mecanicus mission"}
	    var _techs = collect_role_group(SPECIALISTS_TECHS, star.name, false, _conditions);

	    var _tech_point_gain = 0;


	    for (var i=0;i<array_length(_techs);i++){
	    	var _tech = _techs[i];
	    	var _tech_roll = global.character_tester.standard_test(_tech, "technology", -10)[1];
	    	var _wep_test = global.character_tester.standard_test(_tech, "weapon_skill", 10);
            if (!_wep_test[0]){
                kill_and_recover(unit.company, unit.marine_number, true, false);
                techs_lost++;
                cleanup[i] = true;
            }
            else {
            	var unit = obj_ini.TTRPG[com][i];
                star.p_player[planet]+=unit.get_unit_size();
                obj_ini.loc[com][i]=star.name;
                unit.planet_location=planet;
                unit.ship_location = -1;
                unit.job = "none";
                techs_alive+=1;
                unit.add_experience(irandom_range(3,18));
                var gain = irandom(2);
                unit.technology += gain;
                _tech_point_gain += gain;
                if (_tech_roll<10 && _tech_roll>0){
                	found_requisition+=irandom_range(5,40);
                }
            }
            if (_tech_roll>=10) and (_tech_roll<15){
            	found_requisition+=100;
            }
            if (_tech_roll>=15) and (_tech_roll<25){
            	var last_artifact = scr_add_artifact("random", "", 4);
                found_artifact+=1;
            }
            if (_tech_roll>=25){
                scr_add_stc_fragment();// STC here
                found_stc+=1;
            }	    	
	    }


	    obj_controller.requisition+=found_requisition;
	    if (techs_alive+techs_lost>=2) and (techs_alive>0){
	        if (roll1>=(40+(techs_alive+techs_lost)*5)){
	            scr_add_stc_fragment();// STC here
	            found_stc+=1;
	        }
	    }

	    var tixt=$"The journey into the Mars Catacombs was a success.  Your {techs_alive} remaining {obj_ini.role[100][16]}s were useful to the Mechanicus force and return with a bounty.  They await retrieval at {star.name} {scr_roman(planet)}.\n";
	    tixt+=$"\n{found_requisition} Requisition from salvage";
	    if (found_artifact > 0){
	    	tixt+=$"\n{string_plural("Unidentified Artifacts" found_artifact)}  recovered";
	    }
	    if (found_stc > 0){
	    	tixt+=$"\n{string_plural("STC Fragment" found_stc)}  recovered";
	    }

	    if (_tech_point_gain){
	    	tixt+=$"\n{string_plural("Tech Point" _tech_point_gain)}  recovered";
	    }

	    scr_popup("Mechanicus Mission Completed",tixt,"mechanicus","");
	    tixt="Mechanicus Mission Completed: {techs_alive}/{techs_alive+techs_lost} of your {obj_ini.role[100][16]}s return with ";
	    tixt+=string(found_requisition)+" Requisition, ";
	    if (found_artifact > 0){
	    	tixt+=$"\n{found_artifact} : {string_plural("Unidentified Artifacts" found_artifact)}  recovered";
	    }
	    if (found_stc > 0){
	    	tixt+=$"\n{found_stc} : {string_plural("STC Fragment" found_stc)}  recovered";
	    }
	    if (_tech_point_gain){
	    	tixt+=$"\n{_tech_point_gain} {string_plural("Tech Point" _tech_point_gain)}  gained";
	    }
	    // scr_alert("green","mission",tixt,star.x,star.y,);
	    scr_event_log("green",tixt);

	    /*if (found_artifact=1) then scr_event_log("","Artifact recovered from Mars Catacombs.");
	    if (found_artifact>1) then scr_event_log("",string(found_artifact)+" Artifacts recovered from Mars Catacombs.");
	    if (found_stc=1) then scr_event_log("","STC Fragment recovered from Mars Catacombs.");
	    if (found_stc>1) then scr_event_log("",string(found_artifact)+" STC Fragments recovered from Mars Catacombs.");*/
		sort_all_companies_to_map(cleanup);
	}





	if (mission="mech_raider"){
	    var roll1,result;
	    roll1=roll_dice_chapter(1, 100, "low")
		result="";

	    if (roll1<=33) then result="New";
	    if (roll1>33) and (roll1<=66) then result="Land Raider";
	    if (roll1>66) then result="Requisition";

	    if (result="New"){
	        scr_popup("Mechanicus Mission Completed",$"Your {obj_ini.role[100][16]} have worked with the Adeptus Mechanicus in a satisfactory manor.  The testing and training went well, but your Land Raider was ultimately lost.  300 Requisition has been given to your Chapter and relations are better than before.","mechanicus","");
	        obj_controller.requisition+=300;obj_controller.disposition[3]+=2;
	        var com,i,onceh;onceh=0;com=-1;i=0;
	        repeat(11){
	            if (onceh=0){com+=1;i=0;
	                repeat(100){i+=1;
	                    if (obj_ini.veh_role[com][i]="Land Raider") and (obj_ini.veh_loc[com][i]=star.name) and (obj_ini.veh_wid[com][i]=planet){
	                        onceh=1;
	                        obj_ini.veh_race[com][i]=0;
	                        obj_ini.veh_loc[com][i]="";obj_ini.veh_name[com][i]="";
	                        obj_ini.veh_role[com][i]="";
	                        obj_ini.veh_lid[com][i]=-1;
	                        obj_ini.veh_wid[com][i]=0;
	                        obj_ini.veh_wep1[com][i]="";
	                        obj_ini.veh_wep2[com][i]="";
	                        obj_ini.veh_wep3[com][i]="";
	                        obj_ini.veh_upgrade[com][i]="";
	                        obj_ini.veh_acc[com][i]="";
	                        obj_ini.veh_hp[com][i]=0;obj_ini.veh_chaos[com][i]=0;
	                        obj_ini.veh_uid[com][i]=0;cleanup[com]=1;
	                        star.p_player[planet]-=20;
	                    }
	                }
	            }
	        }
	    }
	    if (result="Land Raider"){
	        scr_popup("Mechanicus Mission Completed","Your "+string(obj_ini.role[100][16])+" have worked with the Adeptus Mechanicus in a satisfactory manor.  The testing and training went well, but your Land Raider was ultimately lost.  A new Land Raider has been provided in return.","mechanicus","");
	        var com,i,onceh;onceh=0;com=-1;i=0;obj_controller.disposition[3]+=1;
	        repeat(11){
	            if (onceh=0){com+=1;i=0;
	                repeat(100){i+=1;
	                    if (obj_ini.veh_role[com][i]="Land Raider") and (obj_ini.veh_loc[com][i]=star.name) and (obj_ini.veh_wid[com][i]=planet){
	                        onceh=1;obj_ini.veh_hp[com][i]=100;
	                    }
	                }
	            }
	        }
	    }
	    if (result="Requisition"){
	        scr_popup("Mechanicus Mission Completed","Your "+string(obj_ini.role[100][16])+" have worked with the Adeptus Mechanicus in a satisfactory manor.  The testing and training went well, but your Land Raider was ultimately lost.  600 Requisition has been given to your Chapter as compensation.","mechanicus","");
	        obj_controller.requisition+=600;obj_controller.disposition[3]+=1;
	    }

	    i=-1;repeat(11){i+=1;if (cleanup[i]=1){obj_controller.temp[3000]=real(i);with(obj_ini){scr_vehicle_order(obj_controller.temp[3000]);}}}
	}

	i=-1;repeat(11){i+=1;cleanup[i]=0;}

	if (mission="mech_bionics"){
	    var roll1,result;
	    roll1=roll_dice_chapter(1, 100, "low")
		result="";

	    if (roll1<=33) then result="Requisition";
	    if (roll1>33) and (roll1<=66) then result="Bionics";
	    if (roll1>66) then result="Marines Lost";
	    mech_disp_change = 0;
	    var _text = "The Adeptus Mechanicus have finished experimenting on your marines"
	    var _marines  = collect_role_group("all", [star.name, planet, -1]);
	    if (result="Marines Lost"){
	        _text+="- unfortunantly none of them have survived.  150 Requisition has provided as weregild for each Astartes lost.";
	        mech_disp_change = 2;

			for (var i=0;i<array_length(_marines);i++){
	        	var _unit = _marines[i];
                obj_controller.requisition+=150;

                star.p_player[planet]-=_unit.get_unit_size();

                kill_and_recover(_unit.company, _unit.marine_number,true, true);

                cleanup[_unit.company]=1;
	        }	        
	    }
	    var unit;
	    if (result=="Bionics" || result=="Requisition"){
	    	var _new_bionics = irandom_range(40,100);
	    	obj_controller.disposition[3]+=1;
	    	mech_disp_change = 1;

	        if (result=="Bionics"){
	        	var _new_bionics = irandom_range(40,100);
	        	scr_add_item("Bionics",_new_bionics);
	        	_text += $" A large amount of additional Bionics have been provided by the Mechanicus as a reward ( X{_new_bionics} Bionics added to stocks)";
	        }
	        else if (result == "Requisition"){
	        	req_gain = irandom_range(200, 650);
	        	_text += $"{req_gain} Requisition has been provided by the Mechanicus as a reward.";
	        	obj_controller.requisition+=req_gain;
	        }
	        var _limit = 0;
	        for (var i=0;i<array_length(_marines);i++){
	        	var _unit = _marines[i];
	        	if (_unit.bionics > 0){
		        	_unit.update_health(irandom_range(2,80));

		        	if (!_unit.has_trait("flesh_is_weak")){
		        		_unit.update_loyalty(-20);
		        	}

		        	repeat(choose(2,3,4)){
		        		_unit.add_bionics()
		        	}
		        	_limit++
		        }
		        if (_limit >= 10){
		        	break;
		        }
	        }
	    }
	    _text += $"\n mechanics Disposition {mech_disp_change>0 ? "+" : "-"}{mech_disp_change}";
	    scr_popup("Mechanicus Mission Completed", _text,"mechanicus");
	    sort_all_companies_to_map(cleanup);
	}


}
