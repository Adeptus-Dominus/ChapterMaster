function scr_purge_world(star, planet, action_type, action_score, bombard_target_faction = undefined, target_strength = undefined) {

	var pop_before,pop_after,sci1,sci2,txt1,txt2, max_kill, overkill, heres_before, heres_after, kill;
	var isquest,thequest,questnum;isquest=0;thequest="";questnum=0;pop_after=0;txt1="";txt2="";overkill=0;



	if ((action_type==DropType.PurgeFire) or (action_type==DropType.PurgeSelective)) and (star.p_traitors[planet]=0) and (star.p_chaos[planet]=0) and (obj_controller.turn>=obj_controller.chaos_turn){
	    if (planet_feature_bool(star.p_feature[planet],P_features.Warlord10) == 1) and (obj_controller.known[10]=0) and (obj_controller.faction_gender[10]=1) then with(obj_drop_select){
	        var pop=instance_create(0,0,obj_popup);
	        pop.image="chaos_symbol";
	        pop.title="Concealed Heresy";
	        pop.text=$"Your astartes set out and begin to cleanse {planet_numeral_name(planet, star)} of possible heresy.  The general populace appears to be devout in their faith, but a disturbing trend appears- the odd citizen cursing your forces, frothing at the mouth, and screaming out heresy most foul.  One week into the cleansing a large hostile force is detected approaching and encircling your forces.";        
	        exit;   
	    }
	    if (planet_feature_bool(star.p_feature[planet],P_features.Warlord10) == 1) and (obj_controller.known[10]>=2) and (obj_controller.faction_gender[10]=1) then with(obj_drop_select){

			attacking=10;
			obj_controller.cooldown=30;combating=1;// Start battle here

			instance_deactivate_all(true);
			instance_activate_object(obj_controller);
			instance_activate_object(obj_ini);
			instance_activate_object(obj_drop_select);

			instance_create(0,0,obj_ncombat);
			obj_ncombat.battle_object=p_target;
			obj_ncombat.battle_loc=p_target.name;
			obj_ncombat.battle_id=obj_controller.selecting_planet;
			obj_ncombat.dropping=0;
			obj_ncombat.attacking=10;
			obj_ncombat.enemy=10;
			obj_ncombat.formation_set=1;

			/*
			obj_ncombat.battle_object=p_target;
			obj_ncombat.battle_loc=p_target.name;
			obj_ncombat.battle_id=obj_controller.selecting_planet;
			obj_ncombat.dropping=1-attack;
			obj_ncombat.attacking=attack;
			obj_ncombat.enemy=attacking;
			obj_ncombat.formation_set=formation_possible[formation_current];
			*/

			obj_ncombat.leader=1;
			obj_ncombat.threat=5;
			obj_ncombat.battle_special="WL10_later";
            scr_battle_allies();
            setup_battle_formations();
            roster.add_to_battle();
	    }
	}


	// TODO - while I don't expect Surface to Orbit weapons retaliating against player's purge bombardment, it might still be worthwhile to consider possible situations

    if (action_type=DropType.PurgeBombard) { // Bombardment
        txt1 = "";
        txt2 = "";
        txt3 = "";

        txt1 = choose("Your cruiser and larger ship", "The heavens rumble and thunder as your ship");
        if (ships_selected > 1) { txt1 += "s" };
        txt1 += choose(" position themselves over the target in close orbit, and unleash", " unload");
        if (ships_selected == 1) { txt1 += "s" };
        txt1 += $" annihilation upon {planet_numeral_name(planet, star)}. Even from space the explosions can be seen, {choose("tearing ground", "hammering", "battering", "thundering")} across the planet's surface.";

        if (star.p_type[planet] != "Space Hulk") {
            if (star.p_large[planet] == false) {
                max_kill = action_score*15000000;
            } else {
                max_kill = action_score*0.015; // Population if large
            }

            pop_before = star.p_population[planet];

            heres_before = max(star.p_heresy[planet] + star.p_heresy_secret[planet], star.p_influence[planet][eFACTION.Tau]);// Starting heresy

            // Minimum kills
            if (pop_before > 0) {
                overkill = max(pop_before * 0.1, ((heres_before / 200) * pop_before));
            } else {
                overkill=0;
            }

            kill = min(max_kill, overkill, pop_before);// How many people ARE going to be killed

            pop_after = pop_before-kill;
            var sci1 = 0;
            var sci2 = 0;

            if (pop_before > 0) {
                sci1 = (pop_after / pop_before) * 100; // Relative % of people murderized
                if (sci1 > 0) {
                    sci2 = min((sci1 * 2), action_score * 2); // How much hurresy to get rid of
                }
            }

            if (star.p_large[planet] == false) {
                pop_after = round(pop_after);
            }

            heres_after = heres_before - sci2;
            if (pop_before > 0 && pop_after <= 0) {
                heres_after = 0;
            }

            var _displayed_population = star.p_large[planet] == 1 ? $"{pop_before} billion" : scr_display_number(floor(pop_before));
            var _displayed_killed = star.p_large[planet] == 1 ? $"{kill} billion" : scr_display_number(floor(kill));
            txt1 += $"##The world had {_displayed_population} Imperium subjects. {_displayed_killed} were purged over the duration of the bombardment.##Heresy has fallen down to {max(0, heres_after)}%.";

            if (pop_after == 0 && pop_before > 0) {
                if (star.p_owner[planet] == eFACTION.Imperium) && (obj_controller.faction_status[eFACTION.Imperium] != "War") {
                    if (star.p_type[planet] == "Temperate") || (star.p_type[planet] == "Hive") || (star.p_type[planet] == "Desert") {
                        obj_controller.audiences++;
                        obj_controller.audien[obj_controller.audiences] = 2;
                        obj_controller.audien_topic[obj_controller.audiences] = "bombard_angry";
                    }

                    switch (star.p_type[planet]) {
                    case "Temperate":
                        obj_controller.disposition[eFACTION.Imperium] -= 5;
                        break;
                    case "Desert":
                        obj_controller.disposition[eFACTION.Imperium] -= 3;
                        break;
                    case "Hive":
                        obj_controller.disposition[eFACTION.Imperium] -= 10;
                        break;
                    }
                } else if (star.p_owner[planet] == eFACTION.Mechanicus) && (obj_controller.faction_status[eFACTION.Mechanicus] != "War") {
                    obj_controller.audiences++;
                    obj_controller.audien[obj_controller.audiences] = 3;
                    obj_controller.audien_topic[obj_controller.audiences] = "bombard_angry";
                    switch (star.p_type[planet]) {
                    case "Forge":
                        obj_controller.disposition[eFACTION.Mechanicus] -= 15;
                        break;
                    case "Ice": // the fuck do the mechanicus want with a ice planet?
                        obj_controller.disposition[eFACTION.Mechanicus] -= 7;
                        break;
                    }
                }
            }

            if (bombard_target_faction == eFACTION.Tau) && (obj_controller.faction_status[eFACTION.Tau] != "War") {
                obj_controller.audiences += 1;
                obj_controller.audien[obj_controller.audiences] = eFACTION.Tau;
                obj_controller.audien_topic[obj_controller.audiences] = choose("declare_war", "bombard_angry");
                obj_controller.disposition[eFACTION.Tau] -= 15;
            }

            if (pop_after == 0) {
                if (planet_feature_bool(star.p_feature[planet], P_features.Gene_Stealer_Cult)) {
                    delete_features(star.p_feature[planet], P_features.Gene_Stealer_Cult);
                    adjust_influence(eFACTION.Tyranids, -100, planet, star);
                    pip.text += " The xeno taint of the tyranids that was infesting the population has been completely eradicated with the planets cleansing";
                } else {
                    pip.text += " Any xeno taint that was infesting the population has been completely eradicated with the planets cleansing";
                }
            }

            if (bombard_target_faction != undefined) {
                var bombard_protection = 1;
                switch (bombard_target_faction) {
                    // case eFACTION.Player:
                        // txt2="##The Space Marine forces are difficult to bombard; ";
                        // bombard_protection=3;
                        // break;
                    case eFACTION.Imperium:
                        txt2 = "##The Imperial forces are suitably fortified; ";
                        bombard_protection = 2;
                        break; // I'm not sure about IG, maybe they should be left at 2, or, maybe they should be at 1, like the PDF
                    case 2.5:
                        if (star.p_owner[planet] <= 5){
                            txt2 = "##The PDF forces are poorly fortified; ";
                            bombard_protection = 1;
                        } else if (star.p_owner[planet] > 5){
                            txt2 = "##The renegade forces are poorly fortified; ";
                            bombard_protection = 1;
                        }
                        break; // I think PDF and renegades down there should be kind of poorly prepared for this
                    case eFACTION.Mechanicus:
                        txt2 = "##The Mechanicus forces are well fortified; ";
                        bombard_protection = 3; // If we get to Admech, I think they should be pretty capable with the hi-tech goodies they have
                        break;
                    // case eFACTION.Inquisition:
                        // txt2="##The Inquisition forces are difficult to bombard; ";
                        // bombard_protection=3;
                        // break;
                    case eFACTION.Ecclesiarchy:
                        txt2 = "##The Ecclesiarchy forces are concentrated within their Cathedral; ";
                        bombard_protection = 1;
                        break; // Maybe we should make it 0? Though, Cathedral does have a roof at least
                    case eFACTION.Eldar:
                        txt2="##The Eldar forces are challenging to pin down; ";
                        bombard_protection = 4; // Hi-tech faction
                        break;
                    case eFACTION.Ork:
                        txt2 = "##The Ork forces, for brutal savages, are well dug in; "; // TODO spice up descriptions with variable levels of protection
                        bombard_protection = 2; // TODO Make protection variable depending on leaders present
                        break;
                    case eFACTION.Tau:
                        txt2 = "##The Tau forces are well fortified; ";
                        bombard_protection = 3; // Hi-tech, but not as high as Eldar or Necrons
                        break;
                    case eFACTION.Tyranids:
                        txt2 = "##The Tyranid Swarm is a large target; ";
                        bombard_protection = 0; // TODO add considerations when it is a cult, and when it is bioforms out in the open
                        break;
                    case eFACTION.Chaos:
                        if (star.p_type[planet] = "Daemon") {
                            bombard_protection = 3; // Kind of irrelevant if the bombardment will be nulled later either way
                            txt2 = "##Reality warps and twists within the planet; ";
                        } else {
                            txt2 = "##The Chaos forces are suitably fortified; ";
                            bombard_protection = 2;
                        }
                        break;
                    case eFACTION.Necrons:
                        txt2="##The Necron forces are incredibly difficult to bombard; ";
                        bombard_protection = 4; // They are a hi-tech faction, so bombing them should be difficult
                        break;
                }

                reduced_bombard_score = action_score / 3;
                strength_reduction = 0;

                var i = reduced_bombard_score;
                roll = 0;

                if (bombard_protection == 0) { // No protection, Nids out in the open use this
                    i=i*4;
                } else if (bombard_protection == 1) { // Poor protection, PDF/Renegades and Ecclesiarchy use it,
                    i = i * 0.9;
                } else if (bombard_protection == 2) { // Competent protection - IG, standard chaos forces and Orks
                    i = i * 0.75;
                } else if (bombard_protection == 3) { // Hi-tech, Admech, Tau and Daemons kind of
                    i = i * 0.5;
                } else if (bombard_protection == 4) { // Figured I add a level 4 to this, Ultra hi-tech, Necrons and Eldar
                    i = i * 0.34;
                }

                for(var r=0;r<100;r++) {
                    if (i < 1) {
                        break;
                    }
                    i--;
                    strength_reduction++;
                }

                if (i < 1) && (i >= 0.5) {
                    i=i * 100;
                    roll = irandom(100);
                    if (roll <= i) {
                        strength_reduction+=1;
                    }
                }

                strength_reduction = round(strength_reduction);
                txt2 += "they suffer";

                if (bombard_target_faction == 10) && (star.p_type[planet] == "Daemon") {
                    strength_reduction=0;
                }

                var rel = 0;
                if (strength_reduction != 0) && (target_strength != 0) {
                    rel = ((target_strength - strength_reduction) / target_strength) * 100;
                } else if (strength_reduction == 0){
                    txt2 += " no losses from the bombardment.";
                }
         // Okay, I can see this needs tweaks, just, how can I make it that it checks for 3 conditions, instead of just 2?
            // Would this work:
            // if (rel>0 && rel<=20 && (target_strength-strength_reduction)>0){
                //    txt2+=" minor losses from the bombardment, decreasing "+string(strength_reduction)+" stages.";
            // ?
                if ((target_strength - strength_reduction) <= 0){
                    txt2+=" total annihilation from the bombardment and are wiped clean from the planet.";
                } else {
                    var _losses_text = "";
                    if (rel > 0 && rel <= 20) {
                        _losses_text = "minor losses";
                    } else if (rel > 20 && rel <= 40) {
                        _losses_text = "moderate losses";
                    } else if (rel > 40 && rel <= 60) {
                        _losses_text = "heavy losses";
                    } else if (rel > 60 && (target_strength - strength_reduction) > 0) {
                        _losses_text = "devastating losses";
                    } else {
                        _losses_text = "some losses";
                    }
                    txt2 += $" {_losses_text} from the bombardment, having presence decreased by {strength_reduction}.";
                }

                // 135; ?
                if (bombard_target_faction >= 6){
                    obj_controller.penitent_turn = 0;
                    obj_controller.penitent_turnly = 0;
                }

                if (strength_reduction > 0) {
                    // Faction 2.5 being renegades, interesting
                    if (bombard_target_faction == 2.5) && (star.p_owner[planet] == eFACTION.Tau){
                        var wib = "", wob = 0;

                        txt2="##The renegade forces are poorly fortified; ";

                        wob = action_score * 5000000 + choose(irandom(100000), irandom(100000) * -1);

                        if (wob > star.p_pdf[planet]) {
                            wob = star.p_pdf[planet];
                        }

                        rel = (star.p_pdf[planet] / wob) * 100;
                        star.p_pdf[planet] -= wob;

                        if (rel > 0) && (rel <= 20) {
                            txt2+=" they suffer minor losses from the bombardment, "+string(scr_display_number(wob))+" purged.";
                        } else if (rel > 20) && (rel <= 40) {
                            txt2+=" they suffer moderate losses from the bombardment, "+string(scr_display_number(wob))+" purged.";
                        } else if (rel > 40) && (rel <= 60) {
                            txt2+=" they suffer heavy losses from the bombardment, "+string(scr_display_number(wob))+" purged.";
                        } else if (rel > 60) && (star.p_pdf[planet] > 0) {
                            txt2+=" they suffer devastating losses from the bombardment, "+string(scr_display_number(wob))+" purged.";
                        } else if (wob > 0) && (star.p_pdf[planet] == 0) {
                            txt2+=" they suffer total annihilation from the bombardment && are wiped clean from the planet.";
                        }
                    }

                    switch(bombard_target_faction) {
                        // case 1:
                            // star.p_marines[planet]-=strength_reduction;
                            // break;
                        // case 2:
                            // star.p_ig[planet]-=strength_reduction;
                            // break;
                        // case 3:
                            // star.p_mechanicus[planet]-=strength_reduction;
                            // break;
                        // case 4:
                            // star.p_inquisition[planet]-=strength_reduction;
                            // break;
                        case eFACTION.Ecclesiarchy:
                            star.p_sisters[planet] -= strength_reduction;
                            break;
                        case eFACTION.Eldar:
                            star.p_eldar[planet] -= strength_reduction;
                            break;
                        case eFACTION.Ork:
                            star.p_orks[planet] -= strength_reduction;
                            break;
                        case eFACTION.Tau:
                            star.p_tau[planet] -= strength_reduction;
                            break;
                        case eFACTION.Tyranids:
                            star.p_tyranids[planet] -= strength_reduction;
                            break;
                         case eFACTION.Chaos:
                            star.p_traitors[planet] -= strength_reduction;
                            break;
                        // case 11:
                            // star.p_csm[planet]-=strength_reduction;
                            // break;
                        // case 12:
                            // star.p_demons[planet]-=strength_reduction;
                            // break;
                         case eFACTION.Necrons:
                            star.p_necrons[planet] -= strength_reduction;
                            break;
                    }
                }
            }
        } else {
            var bombard_protection = 1;
            txt1 = "Torpedoes and Bombardment Cannons rain hell upon the space hulk";

            reduced_bombard_score = action_score / 1.25; // fraction of bombardment score, TODO maybe we should make SHs more vulnerable to bombardment? They are out in space, and can be targeted with other weapons
            strength_reduction = 0;
            txt3 = "";

            var rel = 0;

            if (reduced_bombard_score != 0) {
                rel = ((star.p_fortified[planet] - reduced_bombard_score) / star.p_fortified[planet]) * 100;
            }

            if (strength_reduction == 0) {
                txt2 = "it suffers minimal damage from the bombardment.";
            } else if (rel > 0) && (rel <= 20) {
                txt2 = "it suffers minor damage from the bombardment, its integrity reduced by {100-rel}%";
            } else if (rel > 20) && (rel <= 40) {
                txt2 = "it suffers moderate damage from the bombardment, its integrity reduced by {100-rel}%";
            } else if (rel > 40) && (rel <= 60) {
                txt2 = "it suffers heavy damage from the bombardment, its integrity reduced by {100-rel}%";
            } else if (rel > 60) && ((star.p_fortified[planet] - reduced_bombard_score) > 0) {
                txt2 = "it suffers extensive damage from the bombardment, its integrity reduced by {100-rel}%";
            } else if ((star.p_fortified[planet] - reduced_bombard_score) <= 0) {
                txt2 = "it crumbles apart from the onslaught. It is no more."; // Potential TODO Consider adding salvage from the bombed wreckage
            }

            // DO EET
            if (reduced_bombard_score > 0) {
                star.p_fortified[planet] -= reduced_bombard_score;
            }

            if (star.p_fortified[planet] <= 0){
                with(star) { instance_destroy(); }
                instance_activate_object(obj_star_select);
                with(obj_star_select) { instance_destroy(); }
                obj_controller.sel_system_x = 0;
                obj_controller.sel_system_y = 0;
                obj_controller.popup = 0;
                obj_controller.cooldown = 8;
            }
        }
        var pip;
        pip=instance_create(0, 0, obj_popup);
        pip.title = "Bombard Results";
        pip.text = txt1 + txt2 + txt3;
    }

	if (action_type=DropType.PurgeFire){// Burn baby burn
	    var i=0;
	    if (has_problem_planet(planet, "cleanse", star)){
        	isquest=1;
	        thequest="cleanse";
	        questnum=i;
	    }

	    if (isquest=1){
	        if (thequest="cleanse") and (action_score>=20){
	        	remove_planet_problem(planet,thequest,star);
            
	            if (obj_controller.demanding=0) then obj_controller.disposition[4]+=1;
	            if (obj_controller.demanding=1) then obj_controller.disposition[4]+=choose(0,0,1);
            
	            txt1="Your marines scour the underhive of "+string(star.name)+" "+string(planet)+", spraying mutants down with promethium as they go.  It takes several days but a sizeable dent is put in their numbers.";        
	            scr_event_log("","Inquisition Mission Completed: The mutants of "+string(star.name)+" "+string(scr_roman(planet))+" have been cleansed by promethium.");
	            scr_gov_disp(star.name,planet,choose(1,2,3));
	        }
	    }else if (isquest=0){ // TODO add more variation, with planets, features, marine equipment perhaps?
	        txt1=choose(
				$"Timing their visits right, Your forces scour {star.name} {planet} burning down whatever the local heretic communities call their homes. Their screams were quickly extinguished by fire, turning whatever it was before, into ash.",
				$"Your forces scour {star.name} {planet}, burning homes and towns that reek of heresy. The screams and wails of the damned carry through the air."
				);
     
	        if (star.p_large[planet]=0) then max_kill=action_score*12000;// Population if normal
	        if (star.p_large[planet]=1) then max_kill=action_score*0.0000012;// Population if large
        
	        pop_before=star.p_population[planet];
        
	        heres_before=max(star.p_heresy[planet]+star.p_heresy_secret[planet],star.p_influence[planet][eFACTION.Tau]);// Starting heresy
        
	        // Minimum kills
	        if (pop_before>0) then overkill=min(pop_before*0.01,((heres_before/200)*pop_before));
	        if (pop_before=0) then overkill=0;
        
	        kill=min(max_kill,overkill,pop_before);// How many people ARE going to be killed
        
	        if (star.p_large[planet]=0) then pop_after=pop_before-kill;
	        if (star.p_large[planet]=1) then pop_after=pop_before;
        
	        sci1=0;sci2=0;
	        if (pop_before>0) then sci1=(pop_after/pop_before)*100;// Relative % of people murderized
	        if (sci1>0) then sci2=min((sci1*2),round(action_score/25));// How much hurresy to get rid of
	        heres_after=heres_before-sci2;
	        if (pop_before>0) and (pop_after=0) then heres_after=0;

	        var nid_influence = star.p_influence[planet][eFACTION.Tyranids];
            if (planet_feature_bool(star.p_feature[planet], P_features.Gene_Stealer_Cult)) {
                var cult = return_planet_features(star.p_feature[planet], P_features.Gene_Stealer_Cult)[0];
                if (cult.hiding) {}
            } else {
                if (nid_influence > 25) {
                    txt1 += " Scores of mutant offspring from a genestealer infestation are burnt, while we have damaged their influence over this world, the mutants appear to lack the organisation of a true cult";
                    adjust_influence(eFACTION.Tyranids, -10, planet, star);
                } else if (nid_influence > 0) {
                    txt1 += " There are signs of a genestealer infestation but the cultists are too unorganized to do any real damage to their influence on this world";
                }
            }
	        if (star.p_large[planet]=0) then pop_after=round(pop_after);
	        if (pop_after<=0) and (pop_before>0) then heres_after=0;
	        if (star.p_large[planet]=0) then txt1+="##The planet had a population of "+string(scr_display_number(floor(pop_before)))+" and "+string(scr_display_number(floor(kill)))+" were purged over the duration of the cleansing.##Heresy has fallen down to "+string(max(0,heres_after))+"%.";
	        if (star.p_large[planet]=1) then txt1+="##The planet had a population of "+string(pop_before)+" billion and "+string(scr_display_number(action_score*12000))+" were purged over the duration of the cleansing.##Heresy has fallen down to "+string(max(0,heres_after))+"%.";
	    }
	}


	if (action_type=DropType.PurgeSelective){// Blam!
	    var i=0;
	    if (has_problem_planet(planet, "purge", star)){
        	isquest=1;
        	thequest="purge";
        	questnum=i;
	    }

	    if (isquest=1){
	        if (thequest="purge") and (action_score>=10){
	        	remove_planet_problem(planet, "purge", star);
            
	            if (obj_controller.demanding=0) then obj_controller.disposition[4]+=1;
	            if (obj_controller.demanding=1) then obj_controller.disposition[4]+=choose(0,0,1);
            
	            txt1="Your marines drop fast and hard, blowing through guards and mercenaries with minimal resistance.  Before ten minutes have passed all your targets are executed.";        
	            scr_event_log("","Inquisition Mission Completed: The unruly Nobles of "+string(star.name)+" "+string(scr_roman(planet))+" have been purged.");
	            scr_gov_disp(star.name,planet,choose(1,2,3));
	        }
	    }
	    else if (isquest=0){ // TODO add more variation, with planets, features, possibly marine equipment
	        txt1=choose(
				$"Your marines move across {star.name} {scr_roman(planet)}, searching for high profile targets. Once found, they are dragged outside from their lairs. Their execution would soon follow.",
				$"Your marines move across {star.name} {scr_roman(planet)}, rooting out sources of corruption. Heretics are dragged from their lairs and executed in the streets."
				);
    
	        if (star.p_large[planet]=0) then max_kill=action_score*30;// Population if normal
	        if (star.p_large[planet]=1) then max_kill=0;// Population if large
        
	        pop_before=star.p_population[planet];
        
	        heres_before=max(star.p_heresy[planet]+star.p_heresy_secret[planet],star.p_influence[planet][eFACTION.Tau]);// Starting heresy
        
	        // Minimum kills
	        kill=min(action_score*30,pop_before);// How many people ARE going to be killed
        
	        if (star.p_large[planet]=0) then pop_after=pop_before-kill;
	        sci2=round(action_score/50);
	        heres_after=heres_before-sci2;
	        if (pop_before>0) and (pop_after=0) then heres_after=0;
        
	        if (star.p_large[planet]=0) then pop_after=round(pop_after);    
	        if (pop_after<=0) and (pop_before>0) then heres_after=0;
	        if (star.p_large[planet]=0) then txt1+="##The planet had a population of "+string(scr_display_number(floor(pop_before)))+" and "+string(scr_display_number(floor(kill)))+" die over the duration of the search.##Heresy has fallen to "+string(max(0,heres_after))+"%.";
	        if (star.p_large[planet]=1) then txt1+="##The planet had a population of "+string(pop_before)+" billion and "+string(action_score*30)+" die over the duration of the search.##Heresy has fallen to "+string(max(0,heres_after))+"%.";
	    }
	}



	if (action_type=DropType.PurgeAssassinate){
	    var dis,chance,siz_penalty,aroll,o,yep,ambush;
	    aroll=floor(random(100))+1;dis=0;chance=0;siz_penalty=0;o=0;yep=0;ambush=false;
    
	    // Base
	    dis=star.dispo[planet];
	    if (dis<=20) then chance=75;
	    if (dis>20) and (dis<40) then chance=40;
	    if (dis>40) and (dis<70) then chance=15;
	    if (dis>70) then chance=0;
    
	    // Advantages
		if(scr_has_adv("Ambushers")) then ambush=true;
		if(scr_has_adv("Lightning Warriors")) then chance+=5;
		if(scr_has_disadv("Shitty Luck")) then chance+=20;

	    // Size
	    if ((action_score > 5) && (action_score <= 10)) { siz_penalty = 5; }
	    if ((action_score > 10) && (action_score <= 20)) { siz_penalty = 20; }
	    if ((action_score > 20) && (action_score <= 50)) { siz_penalty = 30; }
	    if ((action_score > 50) && (action_score <= 100)) { siz_penalty = 50; }
	    if ((action_score > 100) && (action_score <= 200)) { siz_penalty = 75; }
	    if (action_score > 200) { siz_penalty = 125; }

	    // Ambushers go!
	    if (ambush=true) then chance=round(chance/2);
    
	    var spec1=0,spec2=0,txt=""; // TODO consider making it a battle with Planetary governor's guards
	    txt="Your Astartes descend upon the surface of "+string(star.name)+" "+string(scr_roman(planet))+" and plot the movements and schedule of the governor.  ";    
	    txt+="Once the time is right their target is ambushed "+choose("in their home","in the streets","while driving","taking a piss")+" and tranquilized.  ";
    
		if(scr_has_disadv("Never Forgive")) then spec1=1;
	    if (global.chapter_name="Space Wolves" || obj_ini.progenitor == ePROGENITOR.SPACE_WOLVES) { spec1=3; }
	    if (global.chapter_name="Iron Hands" || obj_ini.progenitor == ePROGENITOR.IRON_HANDS) { spec1=6; }
	    if (obj_ini.omophagea=1) then spec1=choose(spec1,20);
    
	    if (spec1=1) then txt+="They are brought to the already-prepared facilities for Fallen, tortured to make "+string(choose("him","him","her"))+" appear a heretic, and then incinerated.  ";
	    if (spec1=3) then txt+=string(choose("He","He","She"))+" is tossed to the Fenrisian Wolves and viciously mauled, torn apart, and eaten.  The beasts leave nothing but bloody scraps.  ";
	    if (spec1=6) then txt+=string(choose("He","He","She"))+" is stuck in with the other criminals, and scum, to be turned into a servitor.  Soon nothing remains that could be likened to the former Governor.  ";
	    if (spec1=20){
	        if (action_score>1) then txt+="Things get out of hand, and the Governor is torn limb from limb and consumed.  "+string(choose("His","His","Her"))+" flesh is torn off and eaten, bone pulverized, and marrow sucked free.  ";
	        if (action_score=1) then txt+="Your battle brother chops apart the Governor and eats a sizeable portion of "+string(choose("his","his","her"))+" flesh, focusing upon the eyes, teeth, and fingers.  Once full the rest is disposed of.  ";
	    }
    
	    if (spec1=0){
	        spec2=choose(1,2,3,4,5,5,5);
	        if (spec2=1) then txt+="Their still-living body is disintegrated by acid.  ";
	        if (spec2=2) then txt+="The Governor is jettisoned into the local star at the first opporunity.  ";
	        if (spec2=3) then txt+=string(choose("He","He","She"))+" is burned as fuel for one of your vessels.  ";
	        if (spec2=4) then txt+="A few grenades is all it takes to blow "+string(choose("his","his","her"))+" body to smithereens.  ";
	        if (spec2=5) then txt+=string(choose("He","He","She"))+" is executed in a mundane fashion and buried.  ";
	    }
    
	    txt+="What is thy will?";
    
	    var he;he=instance_create(star.x,star.y,obj_temp6);
	    var pip;pip=instance_create(0,0,obj_popup);
	    pip.title="Planetary Governor Assassinated";
	    pip.text=txt;pip.planet=planet;
    
	    pip.option1="Allow the official successor to become Planetary Governor.";
	    pip.option2="Ensure that a sympathetic successor will be the one to rule.";
	    pip.option3="Remove all successors and install a loyal Chapter Serf.";
	    pip.cooldown=20;
    
	    // Result-  this is the multiplier for the chance of discovery with the inquisition, can also be used to determine
	    // the new Governor disposition if they are the official successor
	    if (aroll<=chance){// Discovered
	        pip.estimate=2;
	    }
	    if (aroll>chance){// Success
	        pip.estimate=1;
	    }
	    // If there are enemy non-chaos forces then they may be used as a cover
	    // Does not work with chaos because if the governor dies, with chaos present, the new governor would possibly be investigated
	    if (star.p_orks[planet]>=4) or (star.p_necrons[planet]>=3) or (star.p_tyranids[planet]>=5) then pip.estimate=pip.estimate*0.5;
	}









	if (action_type!=DropType.PurgeAssassinate){
	    if (isquest=0){// DO EET
	        txt2=txt1;
	        star.p_heresy[planet]-=sci2;
	        star.p_influence[planet][eFACTION.Tau]-=sci2;
	        if (action_type<DropType.PurgeSelective) then star.p_population[planet]=pop_after;
	        if (action_type=DropType.PurgeSelective) and (star.p_large[planet]=0) then star.p_population[planet]=pop_after;
        
	        if (star.p_heresy[planet]<0) then star.p_heresy[planet]=0;
	        if (star.p_influence[planet][eFACTION.Tau]<0) then star.p_influence[planet][eFACTION.Tau]=0;
        
	        var pip=instance_create(0,0,obj_popup);
	        pip.title="Purge Results";
	        pip.text=txt2;
	    }
	    /*if (isquest=1){// DO EET
	        var pip;pip=instance_create(0,0,obj_popup);
	        pip.title="Inquisition Mission Completed";
	        pip.text=txt1;pip.image="inquisition";
	        scr_event_log("","Inquisition Mission Completed: The unruly nobles of "+string(star.name)+" "+string(scr_roman(planet))+" have been silenced.");
	    }*/
	}


	if instance_exists(obj_drop_select){
		if (instance_exists(sh_target)){
			sh_target.acted=5;
		}
		with(obj_drop_select){
			instance_destroy();
		}
		instance_destroy();
	}


}
