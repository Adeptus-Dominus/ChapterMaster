function scr_bomb_world(bombard_target_faction, bombard_ment_power, target_strength) {

	var pop_after=0,reduced_bombard_score=0,strength_reduction=0,txt2="",txt3="",txt4="",max_kill,overkill,roll,kill;

	var score_before=population;

	// TODO - update descriptions below, once we get Surface to Orbit weaponry into the game

	var txt1=choose("Your cruiser and larger ship", "The heavens rumble and thunder as your ship"); // TODO - add more variation, for different planets, perhaps different ships, CMs positioning, planetary features and other factors
	if (obj_bomb_select.ships_selected>1) then txt1+="s";
	txt1+=choose(" position themselves over the target in close orbit, and unleash", " unload");
	if (obj_bomb_select.ships_selected=1) then txt1+="s";
	txt1+= $" annihilation upon {name()}. Even from space the explosions can be seen, {choose("tearing ground", "hammering", "battering", "thundering")} across the planet's surface.";

	kill = population_small_conversion(0.15);

	var pop_before=population;
 
	// Minimum kills
	pop_after=max(0,pop_before-kill);
	if (pop_after<=0) and (pop_before>0) then heres_after=0;

    // Code bits copied from scr_purge_world
    if (population > 0) {
        heres_before = max(corruption + secret_corruption, population_influences[eFACTION.Tau]);
        sci1 = 0;
        sci1 = (pop_after / pop_before) * irandom_range(1, 3); // Make bombard corruption reduction random to encourage other forms of purging // TODO MEDIUM BOMBARD_CORRUPTION // Tweak numbers
        heres_after = heres_before - sci1;
    }

	if (planet_type!="Space Hulk"){
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
	    		if (current_owner<=5){
	    			txt2="##The PDF forces are poorly fortified; ";
					bombard_protection=1;
	    		} else if (current_owner>5){
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
	    		bombard_protection=2;
	    		if (has_feature(P_features.OrkStronghold)){
	    			var _stronghold = get_features(P_features.OrkStronghold)[0];
	    			var _protection = floor(_stronghold.tier);
	    			bombard_protection += _protection;
	    			if (_protection){
	    				if (bombard_protection == 3){
	    					txt2 = "The Ork Stronghold on this planet is sizeable and provides the Orks with heavy protection"
	    				} else {
	    					txt2 = "The Ork Stronghold Provides near absolute protection for the greenskins within the vast shielding is impressivly effective despite it's seemingly primitive designs";
	    				}
	    			}
	    		}
	    		// TODO Make protection variable depending on leaders present
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
	    		if (planet_type="Daemon"){
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
    	var bombard_protect_scores = [4, 0.9, 0.75, 0.5, 0.34];
    	bombard_protection = clamp(bombard_protection, 0, 4);
    	i *= bombard_protect_scores[bombard_protection];
	    // 0 No protection, Nids out in the open use this
	     //1:  Poor protection, PDF/Renegades and Ecclesiarchy use it,
	    // 2: Competent protection - IG, standard chaos forces and Orks
	     // 3: Hi-tech, Admech, Tau and Daemons kind of
	    // 4: Figured I add a level 4 to this, Ultra hi-tech, Necrons and Eldar
    
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
    
	    if (bombard_target_faction==10) and (planet_type=="Daemon") then strength_reduction=0;
    
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
	        if (bombard_target_faction=2.5) and (current_owner=8){
	            var wib="",wob=0;
            
	            txt2="##The renegade forces are poorly fortified; ";
            
	            wob=bombard_ment_power*5000000+choose(floor(random(100000)),floor(random(100000))*-1);
            
	            if (wob>system.p_pdf[planet]) then wob=system.p_pdf[planet];
	            rel=(system.p_pdf[planet]/wob)*100;
	            system.p_pdf[planet]-=wob;
            
	            if (rel>0) and (rel<=20) then txt2+=" they suffer minor losses from the bombardment, "+string(scr_display_number(wob))+" purged.";
	            if (rel>20) and (rel<=40) then txt2+=" they suffer moderate losses from the bombardment, "+string(scr_display_number(wob))+" purged.";
	            if (rel>40) and (rel<=60) then txt2+=" they suffer heavy losses from the bombardment, "+string(scr_display_number(wob))+" purged.";
	            if (rel>60) and (system.p_pdf[planet]>0) then txt2+=" they suffer devastating losses from the bombardment, "+string(scr_display_number(wob))+" purged.";
	            if (wob>0) and (system.p_pdf[planet]=0) then txt2+=" they suffer total annihilation from the bombardment and are wiped clean from the planet.";
	        }
        
        	switch(bombard_target_faction){
				// case 1:
        			// system.p_marines[planet]-=strength_reduction;
        			// break;
				// case 2:
					// system.p_ig[planet]-=strength_reduction;
					// break;
				// case 3:
					// system.p_mechanicus[planet]-=strength_reduction;
					// break;
				// case 4:
					// system.p_inquisition[planet]-=strength_reduction;
					// break;
        		case 5:
        			system.p_sisters[planet]-=strength_reduction;
        			break;
        		case 6:
        			system.p_eldar[planet]-=strength_reduction;
        			break;
        		case 7:
        			system.p_orks[planet]-=strength_reduction;
        			break;
        		case 8:
        			system.p_tau[planet]-=strength_reduction;
        			break;
        		case 9:
        			system.p_tyranids[planet]-=strength_reduction;
        			break;
         		case 10:
        			system.p_traitors[planet]-=strength_reduction;
        			break;
				// case 11:
        			// system.p_csm[planet]-=strength_reduction;
        			// break;
				// case 12:
        			// system.p_demons[planet]-=strength_reduction;
        			// break;
         		case 13:
        			system.p_necrons[planet]-=strength_reduction;
        			break;        			       			        			        			        			       			
        	}
	    }
    
	    if (kill>0) then kill=min(system.p_population[planet],kill);
    
	    txt3=""; // Life is the Emperor's currency. Spend it well
        if (pop_before > 0 && planet_type != "Daemon") {
            var _displayed_population = system.p_large[planet] == 1 ? $"{pop_before} billion" : scr_display_number(floor(pop_before));
            var _displayed_killed = system.p_large[planet] == 1 ? $"{kill} billion" : scr_display_number(floor(kill));
            if (pop_after == 0) {
                heres_after = 0;
            }
            txt3 += $"##The world had {_displayed_population} Imperium subjects. {_displayed_killed} died over the duration of the bombardment,##Heresy has fallen down to {max(0, heres_after)}%.";
        }
    
        // DO EET
        if (pop_before > 0) {
            system.p_population[planet] = pop_before - kill;
            system.p_heresy[planet] -= sci1;
            system.p_influence[planet][eFACTION.Tau] -= sci1; // TODO LOW PURGE_INFLUENCE // Make this affect all influences
            if (system.p_heresy[planet] < 0) {
                system.p_heresy[planet] = 0;
            }
            if (system.p_influence[planet][eFACTION.Tau] < 0) {
                system.p_influence[planet][eFACTION.Tau] = 0;
            }
        }

	    var pip=instance_create(0,0,obj_popup);
	    pip.title="Bombard Results";
	    pip.text=txt1+txt2+txt3;
	    //pip.text=txt1+txt2+txt3+" "+string(sci1)+" "+string(heres_before)+" "+string(heres_after); // TODO LOW DEBUG_INFLUENCE // Put in debug code path and make it clearer
    
    
	    if (pop_after==0 && pop_before>0){
	        if (current_owner=2) and (obj_controller.faction_status[eFACTION.Imperium]!="War"){
	            if (planet_type="Temperate" || planet_type="Hive" || planet_type="Desert"){
	                obj_controller.audiences+=1;
	                obj_controller.audien[obj_controller.audiences]=2;
	                obj_controller.audien_topic[obj_controller.audiences]="bombard_angry";
	            }
	            if (planet_type="Temperate"){ 
	            	obj_controller.disposition[2]-=5;
	            }else if (planet_type="Desert"){ 
	            	obj_controller.disposition[2]-=3;
	            }else if (planet_type="Hive"){ 
	            	obj_controller.disposition[2]-=10;
	            }
	        }else if (current_owner=3) and (obj_controller.faction_status[eFACTION.Mechanicus]!="War"){
	            obj_controller.audiences+=1;obj_controller.audien[obj_controller.audiences]=3;
	            obj_controller.audien_topic[obj_controller.audiences]="bombard_angry";
	            if (planet_type="Forge"){
	            	obj_controller.disposition[3]-=15;
	        	}else if (planet_type="Ice"){
	        		obj_controller.disposition[3]-=7;
	       		}
	        }
            if (planet_feature_bool(system.p_feature[planet], P_features.Gene_Stealer_Cult)) {
                delete_features(system.p_feature[planet], P_features.Gene_Stealer_Cult);
                adjust_influence(eFACTION.Tyranids, -100, planet, system);
                pip.text += " The xeno taint of the tyranids that was infesting the population has been completely eradicated with the planets cleansing";
            } else {
                pip.text += " Any xeno taint that was infesting the population has been completely eradicated with the planets cleansing";
            }
	    }
	    if (bombard_target_faction=8) and (obj_controller.faction_status[eFACTION.Tau]!="War"){
	        obj_controller.audiences+=1;
	        obj_controller.audien[obj_controller.audiences]=8;
	        obj_controller.audien_topic[obj_controller.audiences]=choose("declare_war","bombard_angry");
	        obj_controller.disposition[8]-=15;
	    }
    
    
    
    
    
	}




	if (planet_type="Space Hulk"){
	    var bombard_protection=1;
	    txt1="Torpedoes and Bombardment Cannons rain hell upon the space hulk; ";
    
	    reduced_bombard_score=bombard_ment_power/1.25;// fraction of bombardment score, TODO maybe we should make SHs more vulnerable to bombardment? They are out in space, and can be targeted with other weapons
	    strength_reduction=0;txt3="";
    
	    var rel=0;
    
	    if (reduced_bombard_score!=0) then rel=((system.p_fortified[planet]-reduced_bombard_score)/system.p_fortified[planet])*100;
    
	    if (strength_reduction==0) then txt2="it suffers minimal damage from the bombardment.";
	    if (rel>0) and (rel<=20) then txt2="it suffers minor damage from the bombardment, its integrity reduced by "+string(100-rel)+"%";
	    if (rel>20) and (rel<=40) then txt2="it suffers moderate damage from the bombardment, its integrity reduced by "+string(100-rel)+"%";
	    if (rel>40) and (rel<=60) then txt2="it suffers heavy damage from the bombardment, its integrity reduced by "+string(100-rel)+"%";
	    if (rel>60) and ((system.p_fortified[planet]-reduced_bombard_score)>0) then txt2="it suffers extensive damage from the bombardment, its integrity reduced by "+string(100-rel)+"%";
	    if ((system.p_fortified[planet]-reduced_bombard_score)<=0) then txt2="it crumbles apart from the onslaught. It is no more."; // Potential TODO Consider adding salvage from the bombed wreckage
    
	    // DO EET
	    if (reduced_bombard_score>0) then system.p_fortified[planet]-=reduced_bombard_score;
    
	    if (system.p_fortified[planet]<=0){
	        with(system){instance_destroy();}
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



	obj_bomb_select.sh_target.acted=5;
	with(obj_bomb_select){
		instance_destroy();
	}
	// show_message("Pop: "+string(pop_before)+" -> "+string(pop_after)+"#killed: "+string(kill)+"#Heresy: "+string(heres_before)+" -> "+string(heres_after));


}
