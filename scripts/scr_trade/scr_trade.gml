function scr_trade(argument0) {





	// argument0: true for trade, false for just tabulate score

	var my_worth, their_worth, rando4, rando5;
	my_worth=0;
	their_worth=0;
	rando4=floor(random(100))+1;
	rando5=floor(random(100))+1;





    for (var i = 1; i < 5; i++) {
	    if (trade_give[i]="Requisition") and (trade_mnum[i]>0) then my_worth+=trade_mnum[i];
    
	    if (trade_give[i]="Gene-Seed") and (trade_mnum[i]>0){
	        if (diplomacy=3) or (diplomacy=4) then my_worth+=trade_mnum[i]*30;
	        if (diplomacy=2) or (diplomacy=5) then my_worth+=trade_mnum[i]*20;
	        if (diplomacy=8) or (diplomacy=10) then my_worth+=trade_mnum[i]*50;
	    }
    
	    if (trade_give[i]="Info Chip") and (trade_mnum[i]>0) then my_worth+=trade_mnum[i]*80;
	    if (diplomacy=3) and (trade_give[i]="Info Chip") and (trade_mnum[i]>0) then my_worth+=trade_mnum[i]*10;// 20% bonus
    
	    if (trade_give[i]="STC Fragment") and (trade_mnum[i]>0){
	        if (diplomacy=2) then my_worth+=trade_mnum[i]*900;if (diplomacy=3) then my_worth+=trade_mnum[i]*1000;if (diplomacy=4) then my_worth+=trade_mnum[i]*1000;
	        if (diplomacy=5) then my_worth+=trade_mnum[i]*900;if (diplomacy=10) then my_worth+=trade_mnum[i]*900;
        
	        if (diplomacy=6) then my_worth+=trade_mnum[i]*500;if (diplomacy=7) then my_worth+=trade_mnum[i]*500;if (diplomacy=8) then my_worth+=trade_mnum[i]*1000;
	    }
    
    
	    if (trade_take[i]="Test") then their_worth+=trade_tnum[i]*5000;
    
	    if (trade_take[i]="Requisition") then their_worth+=trade_tnum[i];
    
	    // if (trade_take[i]="Storm Trooper") then their_worth+=trade_tnum[i]*20;
	    if (trade_take[i]="Recruiting Planet"){
	        if (disposition[2]<70) then their_worth+=trade_tnum[i]*4000;
	        if (disposition[2]>=70) then their_worth+=trade_tnum[i]*2000;
	    }
	    if (trade_take[i]="License: Repair") then their_worth+=trade_tnum[i]*750;
	    if (trade_take[i]="License: Crusade") then their_worth+=trade_tnum[i]*1500;
    
	    if (trade_take[i]="Terminator Armour") then their_worth+=trade_tnum[i]*400;
	    if (trade_take[i]="Tartaros") then their_worth+=trade_tnum[i]*900;
	    if (trade_take[i]="Land Raider") then their_worth+=trade_tnum[i]*600;
	    if (trade_take[i]="Castellax Battle Automata") then their_worth+=trade_tnum[i]*1200;
	    if (trade_take[i]="Minor Artifact") then their_worth+=trade_tnum[i]*450;
	    if (trade_take[i]="Skitarii") then their_worth+=trade_tnum[i]*15;
	    if (trade_take[i]="Techpriest") then their_worth+=trade_tnum[i]*150;
    
	    if (trade_take[i]="Condemnor Boltgun") then their_worth+=trade_tnum[i]*15;
	    if (trade_take[i]="Hellrifle") then their_worth+=trade_tnum[i]*20;
	    if (trade_take[i]="Incinerator") then their_worth+=trade_tnum[i]*20;
	    if (trade_take[i]="Crusader") then their_worth+=trade_tnum[i]*20;
	    if (trade_take[i]="Exterminatus") then their_worth+=trade_tnum[i]*1500;
	    if (trade_take[i]="Cyclonic Torpedo") then their_worth+=trade_tnum[i]*3000;
    
	    if (trade_take[i]="Eviscerator") then their_worth+=trade_tnum[i]*20;
	    if (trade_take[i]="Heavy Flamer") then their_worth+=trade_tnum[i]*12;
	    if (trade_take[i]="Inferno Bolts") then their_worth+=trade_tnum[i]*5;
	    if (trade_take[i]="Sister of Battle") then their_worth+=trade_tnum[i]*40;
	    if (trade_take[i]="Sister Hospitaler") then their_worth+=trade_tnum[i]*50;
    
	    if (trade_take[i]="Eldar Power Sword") then their_worth+=trade_tnum[i]*50;
	    if (trade_take[i]="Archeotech Laspistol") then their_worth+=trade_tnum[i]*150;
	    if (trade_take[i]="Ranger") then their_worth+=trade_tnum[i]*100;
	    if (trade_take[i]="Useful Information") then their_worth+=trade_tnum[i]*600;
    
	    if (trade_take[i]="Power Klaw") then their_worth+=trade_tnum[i]*50;
	    if (trade_take[i]="Ork Sniper") then their_worth+=trade_tnum[i]*30;
	    if (trade_take[i]="Flash Git") then their_worth+=trade_tnum[i]*60;
    
    
	    if (trade_take[i]="Artifact"){
	        if (diplomacy=2) then their_worth+=300;
	        if (diplomacy=3) then their_worth+=800;
	        if (diplomacy=4) then their_worth+=600;
	        if (diplomacy=5) then their_worth+=500;
	        if (diplomacy>5) then their_worth=1200;
	    }   
	}


	var ss1,ss2;
	ss1=string(trade_give[1])+string(trade_give[2])+string(trade_give[3])+string(trade_give[4]);
	ss2=string(trade_take[1])+string(trade_take[2])+string(trade_take[3])+string(trade_take[4]);
	if (ss1="Requisition") or (ss1="RequisitionRequisition") or (ss1="RequisitionRequisitionRequisition") or (string_count("Requisition",ss1)=4){
	    if (ss2="Requisition") or (ss2="RequisitionRequisition") or (ss2="RequisitionRequisitionRequisition") or (string_count("Requisition",ss2)=4){
	        my_worth=-10000;
	    }
	}
	if (ss1="Requisition") and (ss2="Requisition") then my_worth=-10000;
	if (ss1="") and (ss2="Requisition") then my_worth=-10000;
	// Modify their worth based on relationship




	// Chance to accept:  100-penalty -((their_score-my_score)*difference_penalty)
	// High difference penalty = less forgiving
	// High penalty: more schizo and harsh

	var dif_penalty, penalty, deal;
	def_penalty=0;penalty=0;deal=0;

	if (diplomacy=2){dif_penalty=.4;penalty=5;}
	if (diplomacy=3){dif_penalty=.6;penalty=5;}
	if (diplomacy=4){dif_penalty=1;penalty=15;}
	if (diplomacy=5){dif_penalty=.8;penalty=0;}
	if (diplomacy=6){dif_penalty=.6;penalty=10;}
	if (diplomacy=7){dif_penalty=.4;penalty=20;}
	if (diplomacy=8){dif_penalty=.4;penalty=0;}
	if (diplomacy=10){dif_penalty=1;penalty=0;}

	deal=(100-penalty)-((their_worth-my_worth)*dif_penalty);
	// if (trade_mnum[1]=0) and (trade_take[1]="Requisition") or (trade_take[2]="Requisition") or (trade_take[3]="Requisition") or (trade_take[4]="Requisition") then deal-=100;



	if (argument0=false){
	    if (deal<=20) then trade_likely="Very Unlikely";
	    if (deal<=0) then trade_likely="Impossible";
	    if (deal>20) and (deal<=40) then trade_likely="Unlikely";
	    if (deal>40) and (deal<=60) then trade_likely="Moderate Chance";
	    if (deal>60) and (deal<=80) then trade_likely="Likely";
	    if (deal>80) then trade_likely="Very Likely";
	    if (deal>100) then trade_likely="Unrefusable";
    
	    // show_message(string(deal)+" : "+string(trade_likely));
    
	    if (trade_mnum[1]+trade_mnum[2]+trade_mnum[3]+trade_mnum[4]<=0) and (trade_tnum[1]+trade_tnum[2]+trade_tnum[3]+trade_tnum[4]<=0) then trade_likely="";
	}







	    // show_message("A-1: "+string(liscensing));



	if (argument0=true){

	if (rando4<=deal) and (trading_artifact=0){

	    var step,lisc;step=0;lisc=0;
	    lisc=string_count("License",string(trade_take[1]+trade_take[2]+trade_take[3]+trade_take[4]));
	    lisc+=string_count("Recruiting",string(trade_take[1]+trade_take[2]+trade_take[3]+trade_take[4]));
	    lisc+=string_count("Useful Info",string(trade_take[1]+trade_take[2]+trade_take[3]+trade_take[4]));
	    if (trade_take[1]!="") and (trade_take[2]="") then step=1;
	    if (trade_take[2]!="") and (trade_take[3]="") then step=2;
	    if (trade_take[3]!="") and (trade_take[4]="") then step=3;
	    if (trade_take[4]!="") then step=4;

	    if (lisc>0) then obj_controller.liscensing=1;
	    if (trade_take[1]="Recruiting Planet") or (trade_take[2]="Recruiting Planet") or (trade_take[3]="Recruiting Planet") or (trade_take[4]="Recruiting Planet"){
	        obj_controller.liscensing=5;
        
	        if (trade_take[1]="Recruiting Planet") then recruiting_worlds_bought+=1;
	        if (trade_take[2]="Recruiting Planet") then recruiting_worlds_bought+=1;
	        if (trade_take[3]="Recruiting Planet") then recruiting_worlds_bought+=1;
	        if (trade_take[4]="Recruiting Planet") then recruiting_worlds_bought+=1;
	    }
	    if (trade_take[1]="License: Crusade") or (trade_take[2]="License: Crusade") or (trade_take[3]="License: Crusade") or (trade_take[4]="License: Crusade"){
	        obj_controller.liscensing=2;
	    }
	    if (trade_take[1]="Useful Information") or (trade_take[2]="Useful Information") or (trade_take[3]="Useful Information") or (trade_take[4]="Useful Information"){
	        obj_controller.liscensing=5;
	    }
	    if (trade_take[1]="License: Repair") or (trade_take[2]="License: Repair") or (trade_take[3]="License: Repair") or (trade_take[4]="License: Repair"){
	        repair_ships=1;
	    }
	    if (trade_take[1]="Exterminatus") or (trade_take[2]="Exterminatus") or (trade_take[3]="Exterminatus") or (trade_take[4]="Exterminatus"){
	        obj_controller.liscensing=0;
	        lisc=0;
	    }
    
	    // show_message("A: "+string(liscensing));
    
	    ;var goods;goods="";
	   
    
    
	    // Temporary work around
	    if (lisc>0){
            for (var i = 1; i <= 4; i += 1) {
	            if (trade_give[i]="Requisition") then requisition-=trade_mnum[i];
	            if (trade_give[i]="Gene-Seed") and (trade_mnum[i]>0){
	                gene_seed-=trade_mnum[i];
                
	                if (diplomacy<=5) and (diplomacy!=4) then gene_sold+=trade_mnum[i];
	                if (diplomacy>=6) then gene_xeno+=trade_mnum[i];
	            }
	            if (trade_give[i]="Info Chip") and (trade_mnum[i]>0) then info_chips-=trade_mnum[i];
	            if (trade_give[i]="STC Fragment") and (trade_mnum[i]>0){
                    for (var j = 0; j < 100; j += 1) {
                        var p = choose(1, 2, 3);
                        if (p == 1 && stc_wargear_un > 0) {
                            stc_wargear_un -= 1;
                            break;
                        }
                        if (p == 2 && stc_vehicles_un > 0) {
                            stc_vehicles_un -= 1;
                            break;
                        }
                        if (p == 3 && stc_ships_un > 0) {
                            stc_ships_un -= 1;
                            break;
                        }
                    }
	            }
	        }
        
        
	    }
    
    
    
	    if (lisc!=step) or (lisc=0){// Do not fly over licenses
    
	        if (obj_ini.fleet_type=ePlayerBase.home_world) then with(obj_star){
	            if ((p_owner[1]=1) or (p_owner[2]=1) or (p_owner[3]=1) or (p_owner[4]=1)){instance_create(x,y,obj_temp2);x-=10000;y-=10000;}
	        }
        
        
	        if (obj_ini.fleet_type != ePlayerBase.home_world){
	            // with(obj_star){if (present_fleet[1]>0){x-=10000;y-=10000;}}
	            with(obj_p_fleet){// Get the nearest star system that is viable for creating the trading fleet
	                if (capital_number>0) and (action="") then instance_create(instance_nearest(x,y,obj_star).x,instance_nearest(x,y,obj_star).y,obj_temp2);
	                if (frigate_number>0) and (action="") then instance_create(instance_nearest(x,y,obj_star).x,instance_nearest(x,y,obj_star).y,obj_ground_mission);
	            }
	        }
        
        
	        // temp2: ideal trade target
	        // temp3: origin
	        // temp4: possible trade target
        
        
	        with(obj_star){// Get origin star system for enemy fleet
	            /*var q;q=0;
	            repeat(4){q+=1;
	                if (p_owner[q]=1) or (string_count("Monastery",p_feature[q])>0) then instance_create(x,y,obj_temp3);
	            }*/
        
            
	            if /*(owner=obj_controller.diplomacy) and */((p_owner[1]=obj_controller.diplomacy) or (p_owner[2]=obj_controller.diplomacy) 
	            or (p_owner[3]=obj_controller.diplomacy) or (p_owner[4]=obj_controller.diplomacy)){
	                instance_create(x,y,obj_temp3);
	            }
            
	            if (obj_controller.diplomacy=4){
	                if (p_owner[1]=2) or (p_owner[2]=2) or (p_owner[3]=2) or (p_owner[4]=2) then instance_create(x,y,obj_temp3);
	            }
            
	            // if (obj_controller.diplomacy=4) and (owner = eFACTION.Imperium) then instance_create(x,y,obj_temp3);
	        }
	        if (diplomacy=5){
	            with(obj_star){var ahuh,q;ahuh=0;q=0;
	                repeat(4){q+=1;if (p_owner[q]=5) then ahuh=1;
	                    if (p_owner[q]<6) and (planet_feature_bool(p_feature[q],P_features.Sororitas_Cathedral )==1) then ahuh=1;
	                }
	                if (ahuh=1) then instance_create(x,y,obj_temp3);
	            }
	        }
        
        
	        // show_message("TG2:"+string(instance_number(obj_temp2))+", TG3:"+string(instance_number(obj_temp3))+", TG4:"+string(instance_number(obj_ground_mission)));
        
        
	        var targ, flit, chasing;chasing=0;targ=0;// Set target, chase
        
	        // if (obj_ini.fleet_type != ePlayerBase.home_world){
	            if (instance_exists(obj_temp2)) then targ=instance_nearest(obj_temp2.x,obj_temp2.y,obj_temp3);
	            if (!instance_exists(obj_temp2)) and (instance_exists(obj_ground_mission)) then targ=instance_nearest(obj_ground_mission.x,obj_ground_mission.y,obj_temp3);
            
	            if ((!instance_exists(obj_temp2)) and (!instance_exists(obj_ground_mission))) or (instance_number(obj_p_fleet)=1) and ((obj_p_fleet.x<=0) or (obj_p_fleet.x>room_width) or (obj_p_fleet.y<=0) or (obj_p_fleet.y>room_height)){
	                with(obj_star){
	                    if (x<-3500) and (y<-3500){x+=10000;y+=10000;}
	                    if (x<-3500) and (y<-3500){x+=10000;y+=10000;}
	                }
	                trading=0;scr_dialogue("trade_error_1");
                
	                if (trade_take[1]="Recruiting Planet") then recruiting_worlds_bought-=1;
	                if (trade_take[2]="Recruiting Planet") then recruiting_worlds_bought-=1;
	                if (trade_take[3]="Recruiting Planet") then recruiting_worlds_bought-=1;
	                if (trade_take[4]="Recruiting Planet") then recruiting_worlds_bought-=1;
	                if (trade_take[1]="License: Crusade") or (trade_take[2]="License: Crusade") or (trade_take[3]="License: Crusade") or (trade_take[4]="License: Crusade"){
	                    obj_controller.liscensing=0;
	                }
	                if (trade_take[1]="Useful Information") or (trade_take[2]="Useful Information") or (trade_take[3]="Useful Information") or (trade_take[4]="Useful Information"){
	                    obj_controller.liscensing=0;
	                }
	                if (trade_take[1]="License: Repair") or (trade_take[2]="License: Repair") or (trade_take[3]="License: Repair") or (trade_take[4]="License: Repair"){
	                    repair_ships=0;
	                }
                
	                instance_activate_all();exit;
	            }
            
	            // If player fleet is flying about then get their target for new target
	            if (!instance_exists(obj_temp2)) and (!instance_exists(obj_ground_mission)) and (instance_exists(obj_p_fleet)) and (obj_ini.fleet_type != ePlayerBase.home_world){
	                // show_message("no T2 or T4: chasing");
	                chasing=1;
	                with(obj_p_fleet){var pop;
	                    if (capital_number>0) and (action!=""){pop=instance_create(action_x,action_y,obj_temp2);pop.action_eta=action_eta;}
	                    if (frigate_number>0) and (action!=""){pop=instance_create(action_x,action_y,obj_ground_mission);pop.action_eta=action_eta;}
	                }
	            }
	            if (instance_exists(obj_temp2)) then targ=instance_nearest(obj_temp2.x,obj_temp2.y,obj_temp3);
	            if (!instance_exists(obj_temp2)) and (instance_exists(obj_ground_mission)) then targ=instance_nearest(obj_ground_mission.x,obj_ground_mission.y,obj_temp3);
	        // }

	        if (!instance_exists(obj_temp3)){
	            with(obj_star){
	                if (x<-3500) and (y<-3500){x+=10000;y+=10000;}
	                if (x<-3500) and (y<-3500){x+=10000;y+=10000;}
	            }
	            trading=0;scr_dialogue("trade_error_2");

	            for (var i=1;i<5;i++){
	            	if (trade_take[i]=="Recruiting Planet") then recruiting_worlds_bought-=1;
	            	if (trade_take[i]=="License: Crusade") then obj_controller.liscensing=0;
	            	if (trade_take[i]=="Useful Information") then obj_controller.liscensing=0;
	            	if (trade_take[i]=="License: Repair") then repair_ships=0;
	            }
            
	            instance_activate_all();
	            exit;
	        }
        
        
	        flit=instance_create(targ.x,targ.y,obj_en_fleet);
        
	        flit.owner=diplomacy;
	        flit.home_x=targ.x;
	        flit.home_y=targ.y;
        
	        if (diplomacy=5) then flit.owner = eFACTION.Imperium;
        
	        if (diplomacy=2) then flit.sprite_index=spr_fleet_imperial;
	        if (diplomacy=3) then flit.sprite_index=spr_fleet_mechanicus;
	        if (diplomacy=4){flit.sprite_index=spr_fleet_inquisition;flit.owner  = eFACTION.Inquisition;}
	        // if (diplomacy=4){flit.sprite_index=spr_fleet_imperial;flit.owner = eFACTION.Imperium;}
	        if (diplomacy=6){
	            flit.action_spd=6400;
	            flit.action_eta=1;
	            flit.sprite_index=spr_fleet_eldar;
	        }
	        if (diplomacy=7) then flit.sprite_index=spr_fleet_ork;
	        if (diplomacy=8) then flit.sprite_index=spr_fleet_tau;
        
	        flit.image_index=0;
	        flit.capital_number=1;
        
	        i=0;
	        repeat(4){i+=1;
	            if (trade_give[i]="Requisition") then requisition-=trade_mnum[i];
	            if (trade_give[i]="Gene-Seed") and (trade_mnum[i]>0){
	                gene_seed-=trade_mnum[i];
                
	                if (diplomacy<=5) and (diplomacy!=4) then gene_sold+=trade_mnum[i];
	                if (diplomacy>=6) then gene_xeno+=trade_mnum[i];
	            }
	            if (trade_give[i]="Info Chip") and (trade_mnum[i]>0) then info_chips-=trade_mnum[i];
	            if (trade_give[i]="STC Fragment") and (trade_mnum[i]>0){
	                var remov,p;remov=0;p=0;
	                repeat(100){
	                    if (remov=0){p=choose(1,2,3);
	                        if (p=1) and (stc_wargear_un>0){stc_wargear_un-=1;remov=1;}
	                        if (p=2) and (stc_vehicles_un>0){stc_vehicles_un-=1;remov=1;}
	                        if (p=3) and (stc_ships_un>0){stc_ships_un-=1;remov=1;}
	                    }
	                }
	            }
	            if (trade_take[i]!="") then goods+=string(trade_take[i])+"!"+string(trade_tnum[i])+"!|";
	        }
        
	        flit.trade_goods=goods;
	        if (flit.trade_goods="") then flit.trade_goods="none";
        
	        if (obj_ini.fleet_type != ePlayerBase.home_world){
	            if (instance_exists(obj_temp2)){flit.action_x=obj_temp2.x;flit.action_y=obj_temp2.y;flit.target=instance_nearest(flit.action_x,flit.action_y,obj_p_fleet);}
	            if (!instance_exists(obj_temp2)) and (instance_exists(obj_ground_mission)){flit.action_x=obj_ground_mission.x;flit.action_y=obj_ground_mission.y;flit.target=instance_nearest(flit.action_x,flit.action_y,obj_p_fleet);}
	        }
	        if (obj_ini.fleet_type=ePlayerBase.home_world){
	            targ=instance_nearest(flit.x,flit.y,obj_temp2);
	            flit.action_x=targ.x;
	            flit.action_y=targ.y;
	        }
        
	        if (chasing=1){flit.minimum_eta=flit.target.action_eta;}
	        flit.alarm[4]=1;
        
	        with(obj_temp2){instance_destroy();}
	        with(obj_temp3){instance_destroy();}
	        with(obj_ground_mission){instance_destroy();}
        
        
	    // show_message("D: "+string(liscensing));
        
	        if (flit.trade_goods="none"){// Elfdar mission 1 maybe
	            var got;got=0;
            
            
	    // show_message("E: "+string(liscensing));
            
	            if (trade_give[1]="Requisition") then got+=trade_mnum[1];
	            if (trade_give[2]="Requisition") then got+=trade_mnum[2];
	            if (trade_give[3]="Requisition") then got+=trade_mnum[3];
	            if (trade_give[4]="Requisition") then got+=trade_mnum[4];
            
	            if (trade_tnum[1]+trade_tnum[2]+trade_tnum[3]+trade_tnum[4]>0) then got=0;
            
	            if (got>=500) and (diplomacy=6){
	                var got2;got2=0;
	                repeat(10){if (got2<50){got2+=1;if (quest[got2]="fund_elder") and (quest_faction[got2]=6){
	                    scr_dialogue("mission1_thanks");scr_quest(2,"fund_elder",6,0);got2=50;trading=0;
	                    trade_take[0]="";trade_take[1]="";trade_take[2]="";trade_take[3]="";trade_take[4]="";trade_take[5]="";trade_tnum[0]=0;trade_tnum[1]=0;trade_tnum[2]=0;trade_tnum[3]=0;trade_tnum[4]=0;trade_tnum[5]=0;
	                    trade_give[0]="";trade_give[1]="";trade_give[2]="";trade_give[3]="";trade_give[4]="";trade_give[5]="";trade_mnum[0]=0;trade_mnum[1]=0;trade_mnum[2]=0;trade_mnum[3]=0;trade_mnum[4]=0;trade_mnum[5]=0;
	                    exit;
	                }}}
	            }
	        }
        
	    }
    
    
	    trading=0;
    
	    // show_message("F: "+string(liscensing));
    
	    // show_message("rando4: "+string(rando4)+"#deal: "+string(deal));
    
    
	    // show_message("Lisc: "+string(lisc)+" | Step: "+string(step));
    
	    if (trade_take[1]="Useful Information") or (trade_take[2]="Useful Information") or (trade_take[3]="Useful Information") or (trade_take[4]="Useful Information"){
	        scr_dialogue("useful_information");
	    }
	    else{
	        if (lisc!=step) or (lisc=0) then scr_dialogue("agree");
	        if (lisc=step) and (obj_controller.liscensing>0) then scr_dialogue("agree_lisc");
	    }

	    trade_take[0]="";trade_take[1]="";trade_take[2]="";trade_take[3]="";trade_take[4]="";trade_take[5]="";trade_tnum[0]=0;trade_tnum[1]=0;trade_tnum[2]=0;trade_tnum[3]=0;trade_tnum[4]=0;trade_tnum[5]=0;
	    trade_give[0]="";trade_give[1]="";trade_give[2]="";trade_give[3]="";trade_give[4]="";trade_give[5]="";trade_mnum[0]=0;trade_mnum[1]=0;trade_mnum[2]=0;trade_mnum[3]=0;trade_mnum[4]=0;trade_mnum[5]=0;
	    if (diplomacy=6) or (diplomacy=7) or (diplomacy=8) then scr_loyalty("Xeno Trade","+");
	}
	if (rando4>deal) and (trading_artifact=0){
	    trading=0;scr_dialogue("disagree");
	    trade_take[0]="";trade_take[1]="";trade_take[2]="";trade_take[3]="";trade_take[4]="";trade_take[5]="";trade_tnum[0]=0;trade_tnum[1]=0;trade_tnum[2]=0;trade_tnum[3]=0;trade_tnum[4]=0;trade_tnum[5]=0;
	    trade_give[0]="";trade_give[1]="";trade_give[2]="";trade_give[3]="";trade_give[4]="";trade_give[5]="";trade_mnum[0]=0;trade_mnum[1]=0;trade_mnum[2]=0;trade_mnum[3]=0;trade_mnum[4]=0;trade_mnum[5]=0;
	}


	    // show_message("G: "+string(liscensing));

	if (trading_artifact!=0){// Eheheheh, good space goy
	    if (rando4<=deal){
	        i=0;
	        repeat(4){i+=1;
	            if (trade_give[i]="Requisition") then requisition-=trade_mnum[i];
	            if (trade_give[i]="Gene-Seed") and (trade_mnum[i]>0){
	                gene_seed-=trade_mnum[i];
                
	                if (diplomacy<=5) and (diplomacy!=4) then gene_sold+=trade_mnum[i];
	                if (diplomacy>=6) then gene_xeno+=trade_mnum[i];
	            }
	            if (trade_give[i]="Info Chip") and (trade_mnum[i]>0) then info_chips-=trade_mnum[i];
	            if (trade_give[i]="STC Fragment") and (trade_mnum[i]>0){
	                var remov,p;remov=0;p=0;
	                repeat(100){
	                    if (remov=0){p=choose(1,2,3);
	                        if (p=1) and (stc_wargear_un>0){stc_wargear_un-=1;remov=1;}
	                        if (p=2) and (stc_vehicles_un>0){stc_vehicles_un-=1;remov=1;}
	                        if (p=3) and (stc_ships_un>0){stc_ships_un-=1;remov=1;}
	                    }
	                }
	            }
	        }
	        trading=0;scr_dialogue("agree");force_goodbye=1;trading_artifact=2;
	        trade_take[0]="";trade_take[1]="";trade_take[2]="";trade_take[3]="";trade_take[4]="";trade_take[5]="";trade_tnum[0]=0;trade_tnum[1]=0;trade_tnum[2]=0;trade_tnum[3]=0;trade_tnum[4]=0;trade_tnum[5]=0;
	        trade_give[0]="";trade_give[1]="";trade_give[2]="";trade_give[3]="";trade_give[4]="";trade_give[5]="";trade_mnum[0]=0;trade_mnum[1]=0;trade_mnum[2]=0;trade_mnum[3]=0;trade_mnum[4]=0;trade_mnum[5]=0;
	        if (diplomacy=6) or (diplomacy=7) or (diplomacy=8) then scr_loyalty("Xeno Trade","+");
	    }
	    if (rando4>deal){scr_dialogue("disagree");
	        trade_give[0]="";trade_give[1]="";trade_give[2]="";trade_give[3]="";trade_give[4]="";trade_give[5]="";trade_mnum[0]=0;trade_mnum[1]=0;trade_mnum[2]=0;trade_mnum[3]=0;trade_mnum[4]=0;trade_mnum[5]=0;
	    }
	}

	    // show_message("H: "+string(liscensing));

	}


	with(obj_star){
	    if (x<-3500) and (y<-3500){x+=10000;y+=10000;}
	    if (x<-3500) and (y<-3500){x+=10000;y+=10000;}
	}

	instance_activate_all();


}
