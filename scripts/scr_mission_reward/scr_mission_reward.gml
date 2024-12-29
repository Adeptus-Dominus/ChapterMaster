function scr_mission_reward(argument0, argument1, argument2) {

	// argument0: mission designation
	// argument1: target star system
	// argument2: planet number

	// "mech_bionics",id,i
	// "mech_raider",id,i

	var cleanup,i;cleanup=0;i=-1;
	repeat(11){i+=1;cleanup[i]=0;}




	if (argument0="mars_spelunk"){
	    var roll1,roll2,techs_lost,techs_alive,found_stc,found_artifact,found_requisition;
	    var com,i,onceh;onceh=0;com=-1;i=0;
	    roll1=floor(random(100))+1;// For the first STC
	    found_stc=0;found_artifact=0;found_requisition=0;techs_lost=0;techs_alive=0;

	    repeat(11){com+=1;i=0;
	        repeat(300){i+=1;
	            if (obj_ini.role[com][i]=obj_ini.role[100][16]) and (obj_ini.loc[com][i]="Mechanicus Vessel"){
	                roll2=floor(random(100))+1;
					
					if(scr_has_disadv("Shitty Luck")) then roll2-=10; 

	                if (roll2<=50){obj_controller.command-=1;techs_lost+=1;
	                    kill_and_recover(com, i, true, false);
	                    cleanup[com]=1;
	                }
	                if (roll2>50){
	                	var unit = obj_ini.TTRPG[com][i];
	                    argument1.p_player[argument2]+=unit.get_unit_size();
	                    obj_ini.loc[com][i]=argument1.name;
	                    unit.planet_location=argument2;
	                    techs_alive+=1;
	                    unit.add_experience(irandom_range(3,18));
	                    if (roll2<80) then found_requisition+=floor(random_range(5,40))+1;
	                }
	                if (roll2>=80) and (roll2<88) then found_requisition+=100;
	                if (roll2>=88) and (roll2<96){
	                    if (obj_ini.fleet_type=ePlayerBase.home_world) then scr_add_artifact("random","",4,obj_ini.home_name,2);
	                    if (obj_ini.fleet_type != ePlayerBase.home_world) then scr_add_artifact("random","",4,obj_ini.ship[0],501);
	                    found_artifact+=1;
	                }
	                if (roll2>=96){
	                    scr_add_stc_fragment();// STC here
	                    found_stc+=1;
	                }
	            }
	        }
	    }

	    obj_controller.requisition+=found_requisition;
	    if (techs_alive+techs_lost>=2) and (techs_alive>0){
	        if (roll1>=(40+(techs_alive+techs_lost)*5)){
	            scr_add_stc_fragment();// STC here
	            found_stc+=1;
	        }
	    }

	    var tixt;tixt="The journey into the Mars Catacombs was a success.  Your "+string(techs_alive)+" remaining "+string(obj_ini.role[100][16])+"s were useful to the Mechanicus force and return with a bounty.  They await retrieval at "+string(argument1.name)+" "+scr_roman(argument2)+".#";
	    tixt+="#"+string(found_requisition)+" Requisition from salvage";
	    if (found_artifact!=1) then tixt+="#"+string(found_artifact)+" Unidentified Artifacts recovered";
	    if (found_artifact=1) then tixt+="#"+string(found_artifact)+" Unidentified Artifact recovered";
	    if (found_stc!=1) then tixt+="#"+string(found_stc)+" STC Fragments recovered";
	    if (found_stc=1) then tixt+="#"+string(found_stc)+" STC Fragment recovered";

	    scr_popup("Mechanicus Mission Completed",tixt,"mechanicus","");
	    tixt="Mechanicus Mission Completed: "+string(techs_alive)+"/"+string(techs_alive+techs_lost)+" of your "+string(obj_ini.role[100][16])+"s return with ";
	    tixt+=string(found_requisition)+" Requisition, ";
	    if (found_artifact!=1) then tixt+=string(found_artifact)+" Unidentified Artifacts, ";
	    if (found_artifact=1) then tixt+=string(found_artifact)+" Unidentified Artifact, ";
	    if (found_stc!=1) then tixt+=" and "+string(found_stc)+" STC Fragments.";
	    if (found_stc=1) then tixt+=" and "+string(found_stc)+" STC Fragment.";

	    // scr_alert("green","mission",tixt,argument1.x,argument1.y,);
	    scr_event_log("green",tixt);

	    /*if (found_artifact=1) then scr_event_log("","Artifact recovered from Mars Catacombs.");
	    if (found_artifact>1) then scr_event_log("",string(found_artifact)+" Artifacts recovered from Mars Catacombs.");
	    if (found_stc=1) then scr_event_log("","STC Fragment recovered from Mars Catacombs.");
	    if (found_stc>1) then scr_event_log("",string(found_artifact)+" STC Fragments recovered from Mars Catacombs.");*/

	    i=-1;repeat(11){i+=1;if (cleanup[i]=1){obj_controller.temp[3000]=real(i);with(obj_ini){scr_vehicle_order(obj_controller.temp[3000]);}}}
	}





	if (argument0="mech_raider"){
	    var roll1,result;
	    roll1=floor(random(100))+1;result="";
	    if (scr_has_disadv("Shitty Luck")) then roll1+=20;

	    if (roll1<=33) then result="New";
	    if (roll1>33) and (roll1<=66) then result="Land Raider";
	    if (roll1>66) then result="Requisition";

	    if (result="New"){
	        scr_popup("Mechanicus Mission Completed","Your "+string(obj_ini.role[100][16])+" have worked with the Adeptus Mechanicus in a satisfactory manor.  The testing and training went well, but your Land Raider was ultimately lost.  300 Requisition has been given to your Chapter and relations are better than before.","mechanicus","");
	        obj_controller.requisition+=300;obj_controller.disposition[3]+=2;
	        var com,i,onceh;onceh=0;com=-1;i=0;
	        repeat(11){
	            if (onceh=0){com+=1;i=0;
	                repeat(100){i+=1;
	                    if (obj_ini.veh_role[com][i]="Land Raider") and (obj_ini.veh_loc[com][i]=argument1.name) and (obj_ini.veh_wid[com][i]=argument2){
	                        onceh=1;
	                        obj_ini.veh_race[com][i]=0;
	                        obj_ini.veh_loc[com][i]="";obj_ini.veh_name[com][i]="";obj_ini.veh_role[com][i]="";
	                        obj_ini.veh_lid[com][i]=-1;
	                        obj_ini.veh_wid[com][i]=0;
	                        obj_ini.veh_wep1[com][i]="";
	                        obj_ini.veh_wep2[com][i]="";
	                        obj_ini.veh_wep3[com][i]="";
	                        obj_ini.veh_upgrade[com][i]="";
	                        obj_ini.veh_acc[com][i]="";
	                        obj_ini.veh_hp[com][i]=0;obj_ini.veh_chaos[com][i]=0;
	                        obj_ini.veh_uid[com][i]=0;cleanup[com]=1;
	                        argument1.p_player[argument2]-=20;
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
	                    if (obj_ini.veh_role[com][i]="Land Raider") and (obj_ini.veh_loc[com][i]=argument1.name) and (obj_ini.veh_wid[com][i]=argument2){
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

	if (argument0="mech_bionics"){
	    var roll1,result;
	    roll1=floor(random(100))+1;result="";
	    if (scr_has_disadv("Shitty Luck")) then roll1+=20;

	    if (roll1<=33) then result="Requisition";
	    if (roll1>33) and (roll1<=66) then result="Bionics";
	    if (roll1>66) then result="Marines Lost";

	    if (result="Marines Lost"){
	        scr_popup("Mechanicus Mission Completed","The Adeptus Mechanicus have finished experimenting on your marines- unfortunantly none of them have survived.  150 Requisition has provided as weregild for each Astartes lost.","mechanicus","");
	        obj_controller.disposition[3]+=2;var com,i,onceh;onceh=0;com=-1;i=0;
	        var unit;
	        repeat(11){
	            if (onceh<10){com+=1;i=0;
	                repeat(300){i+=1;
	                    if (obj_ini.race[com][i]=1) and (obj_ini.loc[com][i]=argument1.name) and (obj_ini.TTRPG[com][i].planet_location=argument2){onceh+=1;
	                        obj_controller.requisition+=150;

	                        argument1.p_player[argument2]-=scr_unit_size(obj_ini.armour[com][i],obj_ini.role[com][i],true);

	                        kill_and_recover(com, i, true, true);

	                        cleanup[com]=1;
	                    }
	                }
	            }
	        }
	    }
	    var unit;
	    if (result="Bionics"){
	        scr_popup("Mechanicus Mission Completed","The Adeptus Mechanicus have finished experimenting on your marines.  All of your astartes have survived, though they refuse to speak of the experience.  A large amount of additional Bionics have been provided by the Mechanicus as a reward.","mechanicus","");
	        obj_controller.disposition[3]+=1;var com,i,onceh;onceh=0;com=-1;i=0;
	        scr_add_item("Bionics",floor(random_range(40,100))+1);
	        repeat(11){
	            if (onceh<10){com+=1;i=0;
	                repeat(300){i+=1;
	                	unit = fetch_unit([com,i]);
	                    if (obj_ini.race[com][i]=1) and (obj_ini.loc[com][i]=argument1.name) and (obj_ini.TTRPG[com][i].planet_location=argument2){onceh+=1;
	                        unit.update_health(irandom_range(2,80));
	                        repeat(choose(2,3,4)){obj_ini.TTRPG[com][i].add_bionics()}
	                    }
	                }
	            }
	        }
	    }
	    if (result="Requisition"){
	        scr_popup("Mechanicus Mission Completed","The Adeptus Mechanicus have finished experimenting on your marines.  All of your astartes have survived, though they refuse to speak of the experience.  200 Requisition has been provided by the Mechanicus as a reward.","mechanicus","");
	        obj_controller.disposition[3]+=1;
	        obj_controller.requisition+=200;
	        var found=0,i=0,unit;
	        for (var com=0;com<=10;com++){
	            if (found<10){
	                for (i=0;i<=array_length(obj_ini.TTRPG[com]);i++){
	                	unit = fetch_unit([com,i]);
	                    if (unit.race()=1) and (obj_ini.loc[com][i]=argument1.name) and (unit.planet_location=argument2){
	                    	found++;
	                    	unit.update_loyalty(-30);
	                        unit.update_health(irandom_range(2,80));
	                        repeat(choose(2,3,4)){
	                        	unit.add_bionics();
	                        }
	                    }
	                    if (found>=10) then break;
	                }
	            } else {
	            	break;
	            }
	        }
	    }

	    i=-1;repeat(11){i+=1;if (cleanup[i]=1){obj_controller.temp[3000]=real(i);with(obj_ini){scr_company_order(obj_controller.temp[3000]);}}}
	}


}
