function scr_bomb_world(star_system, planet_number, bombard_target_faction, bombard_ment_power, target_strength) {

	var pop_before=0,pop_after=0,reduced_bombard_score=0,strength_reduction=0,txt2="",txt3="",txt4="",max_kill,overkill,roll,kill;
	var score_before=star_system.p_population[planet_number];

	// TODO - update descriptions below, once we get Surface to Orbit weaponry into the game

	var txt1=choose("Your cruiser and larger ship", "The heavens rumble and thunder as your ship"); // TODO - add more variation, for different planets, perhaps different ships, CMs positioning, planetary features and other factors
	if (ships_selected>1) then txt1+="s";
	txt1+=choose(" position themselves over the target in close orbit, and unleash", " unload");
	if (ships_selected=1) then txt1+="s";
	txt1+= $" annihilation upon {planet_numeral_name(planet_number, star_system)}. Even from space the explosions can be seen, {choose("tearing ground", "hammering", "battering", "thundering")} across the planet's surface.";

	if (star_system.p_large[planet_number]=0){
		kill=bombard_ment_power*15000000;// Population if normal, TODO consider making loses to be more percentage-wise, rather than flat, also in scr_purge_world
	}else if (star_system.p_large[planet_number]=1){
		kill=bombard_ment_power*0.15;// Population if large
	}

	pop_before=star_system.p_population[planet_number];
 
	// Minimum kills
	pop_after=max(0,pop_before-kill);
	if (pop_after<=0) and (pop_before>0) then heres_after=0;

	// We should also make the regular bombardment lower heresy, I'm gonna copy some bits of code from scr_purge_world 
	// heres_before=max(star.p_heresy[planet]+star.p_heresy_secret[planet],star.p_influence[planet][eFACTION.Tau]);
	// sci1=0;sci2=0;
	// if (pop_before>0) then sci1=(pop_after/pop_before)*100;
	// if (sci1>0) then sci2=min((sci1*2),action_score*2);
	// heres_after=heres_before-sci2;


	if (star_system.p_type[planet_number]!="Space Hulk"){
	    var bombard_protection=1;
	    switch(bombard_target_faction){
			// case 1:
				// txt2="##The Space Marine forces are difficult to bombard; ";
				// bombard_protection=3;
				// break;
	    	case 2:
	    		txt2="##The Imperial forces are suitably fortified; ";
				bombard_protection=2;
	    		break; // I'm not sure about IG, maybe they should be left at 2, or, maybe they should be at 1, like the PDF
	    	case 2.5:
	    		if (star_system.p_owner[planet_number]<=5){
	    			txt2="##The PDF forces are poorly fortified; ";
					bombard_protection=1;
	    		} else if (star_system.p_owner[planet_number]>5){
	    			txt2="##The renegade forces are poorly fortified; ";
					bombard_protection=1;
	    		}
	    		break; // I think PDF and renegades down there should be kind of poorly prepared for this
	    	case 3:
	    		txt2="##The Mechanicus forces are well fortified; ";
	    		bombard_protection=3; // If we get to Admech, I think they should be pretty capable with the hi-tech goodies they have
	    		break;
			// case 4:
	    		// txt2="##The Inquisition forces are difficult to bombard; ";
				// bombard_protection=3;
	    		// break;
	    	case 5:
	    		txt2="##The Ecclesiarchy forces are concentrated within their Cathedral; ";
				bombard_protection=1;
	    		break; // Maybe we should make it 0? Though, Cathedral does have a roof at least
	    	case 6:
	    		txt2="##The Eldar forces are challenging to pin down; ";
	    		bombard_protection=4; // Hi-tech faction
	    		break;
	    	case 7:
	    		txt2="##The Ork forces, for brutal savages, are well dug in; "; // TODO spice up descriptions with variable levels of protection
	    		bombard_protection=2; // TODO Make protection variable depending on leaders present
	    		break;
	    	case 8:
	    		txt2="##The Tau forces are well fortified; ";
				bombard_protection=3; // Hi-tech, but not as high as Eldar or Necrons
	    		break;
	    	case 9:
	    		txt2="##The Tyranid Swarm is a large target; ";
				bombard_protection=0; // TODO add considerations when it is a cult, and when it is bioforms out in the open
	    		break;
	    	case 10:
	    		if (star_system.p_type[planet_number]="Daemon"){
	    			bombard_protection=3; // Kind of irrelevant if the bombardment will be nulled later either way
	    			txt2="##Reality warps and twists within the planet; ";
	    		} else {
					txt2="##The Chaos forces are suitably fortified; ";
					bombard_protection=2;
	    		}
	    		break;
			// case 11:
				// txt2="##The Chaos Space Marine forces are difficult to bombard; ";
				// bombard_protection=3;
				// break;
			// case 12:
				// txt2="##The Daemonic forces are incredibly difficult to bombard; ";
				// bombard_protection=4;
				// break;
	    	case 13:
	    		txt2="##The Necron forces are incredibly difficult to bombard; ";
				bombard_protection=4; // They are a hi-tech faction, so bombing them should be difficult
	    		break;	    			    			    			    			    			    				    		    			    		
	    }
    
	    reduced_bombard_score=bombard_ment_power/3;
	    strength_reduction=0;

	    var i=reduced_bombard_score;
	    roll=0;
    	
	    if (bombard_protection==0){i=i*4;} // No protection, Nids out in the open use this
	    else if (bombard_protection==1){i=i*0.9;} // Poor protection, PDF/Renegades and Ecclesiarchy use it,
	    else if (bombard_protection==2){i=i*0.75;} // Competent protection - IG, standard chaos forces and Orks
	    else if (bombard_protection==3){i=i*0.5;} // Hi-tech, Admech, Tau and Daemons kind of
	    else if (bombard_protection==4){i=i*0.34;} // Figured I add a level 4 to this, Ultra hi-tech, Necrons and Eldar
    
	    for(var r=0;r<100;r++){
	    	if (i < 1) then break;
            i--;
            strength_reduction++;
	    }
	    if (i<1) and (i>=0.5){
	        i=i*100;
	        roll=irandom(100)=1;
	        if (roll<=i) then strength_reduction+=1;
	    }
    
	    strength_reduction=round(strength_reduction);
	    txt2+="they suffer";
    
	    if (bombard_target_faction==10) and (star_system.p_type[planet_number]=="Daemon") then strength_reduction=0;
    
	    var rel=0;
	    if (strength_reduction!=0) and (target_strength!=0){
	    	rel=((target_strength-strength_reduction)/target_strength)*100;
		}else if (strength_reduction==0){
			txt2+=" no losses from the bombardment.";
		}
 // Okay, I can see this needs tweaks, just, how can I make it that it checks for 3 conditions, instead of just 2?
	// Would this work:
	// if (rel>0 && rel<=20 && (target_strength-strength_reduction)>0){
		//	txt2+=" minor losses from the bombardment, decreasing "+string(strength_reduction)+" stages.";
	// ?
		if ((target_strength-strength_reduction)<=0){ 
			txt2+=" total annihilation from the bombardment and are wiped clean from the planet.";
		} else {
			var _losses_text = "";
			if (rel>0 && rel<=20) {
				_losses_text = "minor losses";
			} else if (rel>20 && rel<=40) { 
				_losses_text = "moderate losses";
			} else if (rel>40 && rel<=60) { 
				_losses_text = "heavy losses";
			} else if (rel>60 && (target_strength-strength_reduction)>0) { 
				_losses_text = "devastating losses";
			} else {
				_losses_text = "some losses";
			}
			txt2 += $" {_losses_text} from the bombardment, having presence decreased by {strength_reduction}.";
		}
    
	    // 135; ?
	    if (bombard_target_faction>=6){
	    	obj_controller.penitent_turn=0;
	    	obj_controller.penitent_turnly=0;
		}
    
	    if (strength_reduction>0){
 // Faction 2.5 being renegades, interesting
	        if (bombard_target_faction=2.5) and (star_system.p_owner[planet_number]=8){
	            var wib="",wob=0;
            
	            txt2="##The renegade forces are poorly fortified; ";
            
	            wob=bombard_ment_power*5000000+choose(floor(random(100000)),floor(random(100000))*-1);
            
	            if (wob>star_system.p_pdf[planet_number]) then wob=star_system.p_pdf[planet_number];
	            rel=(star_system.p_pdf[planet_number]/wob)*100;
	            star_system.p_pdf[planet_number]-=wob;
            
	            if (rel>0) and (rel<=20) then txt2+=" they suffer minor losses from the bombardment, "+string(scr_display_number(wob))+" purged.";
	            if (rel>20) and (rel<=40) then txt2+=" they suffer moderate losses from the bombardment, "+string(scr_display_number(wob))+" purged.";
	            if (rel>40) and (rel<=60) then txt2+=" they suffer heavy losses from the bombardment, "+string(scr_display_number(wob))+" purged.";
	            if (rel>60) and (star_system.p_pdf[planet_number]>0) then txt2+=" they suffer devastating losses from the bombardment, "+string(scr_display_number(wob))+" purged.";
	            if (wob>0) and (star_system.p_pdf[planet_number]=0) then txt2+=" they suffer total annihilation from the bombardment and are wiped clean from the planet.";
	        }
        
        	switch(bombard_target_faction){
				// case 1:
        			// star_system.p_marines[planet_number]-=strength_reduction;
        			// break;
				// case 2:
					// star_system.p_ig[planet_number]-=strength_reduction;
					// break;
				// case 3:
					// star_system.p_mechanicus[planet_number]-=strength_reduction;
					// break;
				// case 4:
					// star_system.p_inquisition[planet_number]-=strength_reduction;
					// break;
        		case 5:
        			star_system.p_sisters[planet_number]-=strength_reduction;
        			break;
        		case 6:
        			star_system.p_eldar[planet_number]-=strength_reduction;
        			break;
        		case 7:
        			star_system.p_orks[planet_number]-=strength_reduction;
        			break;
        		case 8:
        			star_system.p_tau[planet_number]-=strength_reduction;
        			break;
        		case 9:
        			star_system.p_tyranids[planet_number]-=strength_reduction;
        			break;
         		case 10:
        			star_system.p_traitors[planet_number]-=strength_reduction;
        			break;
				// case 11:
        			// star_system.p_csm[planet_number]-=strength_reduction;
        			// break;
				// case 12:
        			// star_system.p_demons[planet_number]-=strength_reduction;
        			// break;
         		case 13:
        			star_system.p_necrons[planet_number]-=strength_reduction;
        			break;        			       			        			        			        			       			
        	}
	    }
    
	    if (kill>0) then kill=min(star_system.p_population[planet_number],kill);
    
	    txt3=""; // Life is the Emperor's currency. Spend it well
	    if (pop_before > 0 && star_system.p_type[planet_number] != "Daemon") {
			var _displayed_population = star_system.p_large[planet_number] == 1 ? $"{pop_before} billion" : scr_display_number(floor(pop_before));
			var _displayed_killed = star_system.p_large[planet_number] == 1 ? $"{kill} billion" : scr_display_number(floor(kill));
			txt3 += $"##The world had {_displayed_population} Imperium subjects. {_displayed_killed} died over the duration of the bombardment.";
	    }
    
    
	    // DO EET
	    if (pop_before>0){
	    	star_system.p_population[planet_number]=pop_before-kill;
		}
    
	    var pip=instance_create(0,0,obj_popup);
	    pip.title="Bombard Results";
	    pip.text=txt1+txt2+txt3;
    
    
	    if (pop_after==0 && pop_before>0){
	        if (star_system.p_owner[planet_number]=2) and (obj_controller.faction_status[eFACTION.Imperium]!="War"){
	            if (star_system.p_type[planet_number]="Temperate") or (star_system.p_type[planet_number]="Hive") or (star_system.p_type[planet_number]="Desert"){
	                obj_controller.audiences+=1;obj_controller.audien[obj_controller.audiences]=2;
	                obj_controller.audien_topic[obj_controller.audiences]="bombard_angry";
	            }
	            if (star_system.p_type[planet_number]="Temperate"){ 
	            	obj_controller.disposition[2]-=5;
	            }else if (star_system.p_type[planet_number]="Desert"){ 
	            	obj_controller.disposition[2]-=3;
	            }else if (star_system.p_type[planet_number]="Hive"){ 
	            	obj_controller.disposition[2]-=10;
	            }
	        }else if (star_system.p_owner[planet_number]=3) and (obj_controller.faction_status[eFACTION.Mechanicus]!="War"){
	            obj_controller.audiences+=1;obj_controller.audien[obj_controller.audiences]=3;
	            obj_controller.audien_topic[obj_controller.audiences]="bombard_angry";
	            if (star_system.p_type[planet_number]="Forge"){
	            	obj_controller.disposition[3]-=15;
	        	}else if (star_system.p_type[planet_number]="Ice"){
	        		obj_controller.disposition[3]-=7;
	       		}
	        }
	        if (planet_feature_bool(star_system.p_feature[planet_number], P_features.Gene_Stealer_Cult)){
	        	delete_features(star_system.p_feature[planet_number], P_features.Gene_Stealer_Cult);
	        	adjust_influence(eFACTION.Tyranids, -100, planet_number,star_system);
	        }
	        pip.text+= " The xenos taint of the tyranids infecting the population has been completely eradicated with the planets cleansing";
	    }
	    if (bombard_target_faction=8) and (obj_controller.faction_status[eFACTION.Tau]!="War"){
	        obj_controller.audiences+=1;
	        obj_controller.audien[obj_controller.audiences]=8;
	        obj_controller.audien_topic[obj_controller.audiences]=choose("declare_war","bombard_angry");
	        obj_controller.disposition[8]-=15;
	    }
    
    
    
    
    
	}




	if (star_system.p_type[planet_number]="Space Hulk"){
	    var bombard_protection=1;
	    txt1="Torpedoes and Bombardment Cannons rain hell upon the space hulk; ";
    
	    reduced_bombard_score=bombard_ment_power/1.25;// fraction of bombardment score, TODO maybe we should make SHs more vulnerable to bombardment? They are out in space, and can be targeted with other weapons
	    strength_reduction=0;txt3="";
    
	    var rel=0;
    
	    if (reduced_bombard_score!=0) then rel=((star_system.p_fortified[planet_number]-reduced_bombard_score)/star_system.p_fortified[planet_number])*100;
    
	    if (strength_reduction==0) then txt2="it suffers minimal damage from the bombardment.";
	    if (rel>0) and (rel<=20) then txt2="it suffers minor damage from the bombardment, its integrity reduced by "+string(100-rel)+"%";
	    if (rel>20) and (rel<=40) then txt2="it suffers moderate damage from the bombardment, its integrity reduced by "+string(100-rel)+"%";
	    if (rel>40) and (rel<=60) then txt2="it suffers heavy damage from the bombardment, its integrity reduced by "+string(100-rel)+"%";
	    if (rel>60) and ((star_system.p_fortified[planet_number]-reduced_bombard_score)>0) then txt2="it suffers extensive damage from the bombardment, its integrity reduced by "+string(100-rel)+"%";
	    if ((star_system.p_fortified[planet_number]-reduced_bombard_score)<=0) then txt2="it crumbles apart from the onslaught. It is no more."; // Potential TODO Consider adding salvage from the bombed wreckage
    
	    // DO EET
	    if (reduced_bombard_score>0) then star_system.p_fortified[planet_number]-=reduced_bombard_score;
    
	    if (star_system.p_fortified[planet_number]<=0){
	        with(star_system){instance_destroy();}
	        instance_activate_object(obj_star_select);
	        with(obj_star_select){instance_destroy();}
	        obj_controller.sel_system_x=0;
	        obj_controller.sel_system_y=0;
	        obj_controller.popup=0;
	        obj_controller.cooldown=8;
	    }
    
	    var pip;
	    pip=instance_create(0,0,obj_popup);
	    pip.title="Bombard Results";
	    pip.text=txt1+txt2+txt3;
	}



	sh_target.acted=5;
	with(obj_bomb_select){instance_destroy();}
	instance_destroy();

	// show_message("Pop: "+string(pop_before)+" -> "+string(pop_after)+"#killed: "+string(kill)+"#Heresy: "+string(heres_before)+" -> "+string(heres_after));


}
