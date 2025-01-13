function scr_enemy_ai_b() {
	// Imperial Repleneshes numbers
	// If no enemies and guard < pop /470 then increase guardsman
	// If no enemies and population < max_pop then increase by like 1%
	var rando=0,success=false,i=0, is_garrison_force=false, total_garrison=0, sabotage_force=false;


	i=0;
	for (i=1;i<=planets;i++){
		var cur_garrison =  system_garrison[i-1];
		var cur_sabatours =  system_sabatours[i-1];
		
		sabotage_force=cur_sabatours.garrison_force;
		total_garrison = cur_garrison.total_garrison;
		is_garrison_force=cur_garrison.garrison_force;

		var planet_string = $"{string(name)} {scr_roman_numerals()[i-1]}";	
				// Orks grow in number
		var ork_growth=floor(random(100))+1;
		success=false;// This part handles the increasing in numbers
	    if (p_owner[i]=7) and (p_orks[i]<5) and (p_traitors[i]=0) and (p_player[i]<=0 || !is_garrison_force){
	        if (p_orks[i]>0) and (p_orks[i]<5) and (ork_growth<=15){
	        	if(sabotage_force){
	        		if (irandom(3)<2){
	        			 scr_event_log("green", $"sabotage force on {planet_string} disrupts ork forces", name);
	        		}else {
	        			p_orks[i]+=1;
	        		}
	        	} else {
	        		p_orks[i]+=1;
	        	}
	        }
	    }
	    if (p_population[i]<p_max_population[i]) and (p_type[i]!="Dead") and (p_type[i]!="Craftworld") and (p_owner[i]<=5)
	    	and (p_traitors[i]=0) and (p_tau[i]=0) and (p_orks[i]=0) and (p_necrons[i]=0) and (p_tyranids[i]=0){
	        if (p_large[i]=0){
	        	p_population[i]=round(p_population[i]*1.0008);
	      	}else if (p_large[i]=1){
	      		p_population[i]+=choose(0,0.01);
	      	}
	    }
    

    	// increasing necrons
	    if (array_length(p_feature[i])!=0){
	    	var has_awake_tomb=false,nfleet=0;
	        if (awake_tomb_world(p_feature[i])==1) then has_awake_tomb=true;
	        if (has_awake_tomb) {
	        	if (p_necrons[i]<3){
	        			p_necrons[i]+=2;
	        	}else if (p_necrons[i]<6){
	        		p_necrons[i]+=1;
	        	}
	        }
	        if (sabotage_force && irandom(2)<2){
	        	p_necrons[i]--;
	        	scr_event_log("green", $"sabotage force on {planet_string} disrupts necron forces", name);
	        }
        
	        if (has_awake_tomb){// Necron fleets, woooo
	        		//necrons kill populatin
	            if (p_population[i]>0) and (p_player[i]+p_pdf[i]+p_guardsmen[i]+p_tyranids[i]=0){
	                p_population[i]=p_population[i]*0.75;
	                if (p_large[i]=0) and (p_population[i]<=5000) then p_population[i]=0;
	            }
            
	            var fleet_spawn_chance=irandom(99)+1
	            onceh=0;
	            if (scr_has_disadv("Shitty Luck")) then fleet_spawn_chance-=5;

	            if (fleet_spawn_chance<=15){
	                if (present_fleet[eFACTION.Necrons] > 0) {//if necron fleet
						    necron_fleet = instance_nearest(x , y , obj_en_fleet);

						    if (necron_fleet.owner == eFACTION.Necrons) {
						        if (necron_fleet.escort_number < necron_fleet.capital_number * 1.5) {
						            necron_fleet.escort_number += 2;
						        } else if (necron_fleet.frigate_number < necron_fleet.capital_number * 3) {
						            necron_fleet.frigate_number += 1;
						        } else {
						            necron_fleet.capital_number += 1;
						        }
						    }
						}else if (present_fleet[eFACTION.Necrons]==0){
	                    necron_fleet=instance_create(x,y,obj_en_fleet);
	                    necron_fleet.owner=eFACTION.Necrons;
	                    necron_fleet.capital_number=1;
	                    necron_fleet.sprite_index=spr_fleet_necron;necron_fleet.image_speed=0;
	                    necron_fleet.image_index=1;
	                    present_fleet[eFACTION.Necrons]+=1;
	                }
                	var enemy_fleets = 0;
	                with(necron_fleet){
	                    if (owner=eFACTION.Necrons){
	                        var ii=0;
	                        ii+=capital_number;
	                        ii+=round((frigate_number/2));
	                        ii+=round((escort_number/4));
	                        if (ii<=1) then ii=1;// image_index=max(8,round(ii));
                        
	                        if (ii>=7) and (capital_number>1){
	                        	for (var fleet_n =1;fleet_n<=10;fleet_n++){
	                        		if (orbiting.present_fleet[fleet_n]>0) then enemy_fleets++;
	                        	}
	                        }
	                    }
	                }                
	                if (enemy_fleets>0){
	                    var necron_fleet2;
	                    necron_fleet2=instance_create(x,y,obj_en_fleet);
	                    necron_fleet2.owner=eFACTION.Necrons;
	                    necron_fleet2.sprite_index=spr_fleet_necron;
	                    // necron_fleet2.image_index=0;
	                    necron_fleet.image_speed=0;
	                    necron_fleet2.capital_number=1;
	                    necron_fleet2.frigate_number=round(necron_fleet.frigate_number/2);
	                    necron_fleet2.escort_number=round(necron_fleet.escort_number/2);
	                    present_fleet[eFACTION.Necrons]+=1;
                    
	                    necron_fleet.capital_number-=1;
	                    necron_fleet.frigate_number-=necron_fleet2.frigate_number;
	                    necron_fleet.escort_number-=necron_fleet2.escort_number;
                    	var nearest_planet_coords = [0,0]
                    	var found_near_planet = false;
	                    with(obj_star){
	                        if (present_fleet[eFACTION.Necrons]=0){
	                        	if (!array_contains(p_type,"Dead")){
	                        		for (var plan=1; plan<=planets;plan++){
	                        			if (p_owner[plan]<=5){
	                        				found_near_planet=true;
	                        				nearest_planet_coords =[x,y];
	                        				break;
	                        			}
	                        		}
	                        	}
	                        }
	                    }
                    
	                    if (found_near_planet){
	                        var tgt1,tgt2;
                        
                          necron_fleet2.action_x=nearest_planet_coords[0];
                          necron_fleet2.action_y=nearest_planet_coords[1];
                          necron_fleet2.alarm[4]=1;
	                    }
	                }
	            }
            
	        }
	    }
			// traitors cults
		var notixt;
		var is_ork;
		notixt = false;

		rando = irandom(99) + 1;

		if (p_owner[i] == eFACTION.Chaos) and (p_heresy[i] < 80) then
		    p_heresy[i] += 1;

		if (p_owner[i] != eFACTION.Chaos)&& (p_owner[i] != eFACTION.Heretics) and (p_owner[i] != eFACTION.Eldar) and (planets >= i) and (p_type[i] != "Dead") and (p_type[i] != "Craftworld") {
		    success = false;
		    is_ork = p_owner[i] == eFACTION.Ork;
		


		    if (!is_ork) {
		        //made a linear function for this while here...now the minimum for the roll is a bit higher, but
		        var score_to_beat = (3 / 4) * (p_heresy[i] + p_heresy_secret[i]) - 27.5;

		        //if (p_heresy[i]+p_heresy_secret[i]>=25) and (rando<=3) then success=true;
		        //if (p_heresy[i]+p_heresy_secret[i]>=50) and (rando<=10) then success=true;
		        //if (p_heresy[i]+p_heresy_secret[i]>=70) and (rando<=25) then success=true;
		        //if (p_heresy[i]+p_heresy_secret[i]>=90) and (rando<=40) then success=true;
		        if (rando < score_to_beat) then success=true;
		    }

		    if (success) and (p_pdf[i] = 0) and (p_guardsmen[i] = 0) and (p_tau[i] = 0) and (p_orks[i] = 0) {
		        p_owner[i] = 10;
		        scr_alert("red", "owner", string(name) + " " + string(i) + " has fallen to heretics!", x, y);

		        if (visited == 1) { //visited variable check whether the star has been visited or not 1 for true 0 for false
		            if (p_type[i] == "Forge") {
		                dispo[i] -= 10; // 10 disposition decreases for the respective planet
		                obj_controller.disposition[3] -= 3; // 10 disposition decrease for the toaster Fetishest since they aren't that numerous
		            } else if (planet_feature_bool(p_feature[i], P_features.Sororitas_Cathedral) or (p_type[i] == "Shrine")) {
		                dispo[i] -= 4; // similarly 10 disposition decrease, note those nurses are a bit pissy and
		                // and you can't easily gain their favor because you cannot ask them to "step down" from office.
		                obj_controller.disposition[5] -= 5;
		            } else {
		                // the missus diplomacy 0 is when they cringe when you enter the office and cannot ask them for a date.
		            }
		        }
		    }

		    if (success) and (p_type[i] != "Space Hulk") {
		        rando=floor(random(100))+1;
		        // // // obj_controller.x=self.x;obj_controller.y=self.y;
		        if (is_garrison_force) {
		            rando -= total_garrison;
		        }

		        var tixt = "";

		        // controls losing pdf due to heretic cults
		        var traitor_mod = 0;

		        if (rando <= 40) {
		        	notixt = true;
		            var garrison_mod = choose(0.05, 0.1, 0.15, 0.2);

		            if (is_garrison_force) {
		                garrison_mod -= 0.01 * total_garrison;
		            }

		            if (garrison_mod > 0) {
		                var lost = floor(p_pdf[i] * garrison_mod);

		                if (p_pdf[i] <= 500) {
		                    lost = p_pdf[i];
		                    p_traitors[i] = 1;
		                }

		                p_pdf[i] -= lost;

		                if (p_traitors[i] = 0) {
		                    if (p_pdf[i] > 0) {
		                        tixt = $"{string(scr_display_number(lost))} PDF killed in a rebellion on {planet_string}.";
		                    } else if (p_pdf[i] = 0) then
		                        tixt = $"Heretic cults have appeared in {planet_string}.";

		                    scr_alert("purple", "owner", tixt, x, y);
		                    scr_event_log("purple", tixt, name);
		                }
		            } else {
		                tixt = $"Marine garrison prevents rebellion on {planet_string}"
		                scr_alert("green", "owner", tixt, x, y);
		                scr_event_log("green", tixt, name);
		                p_heresy[i]-=irandom(5);
		            }
		            // Cult crushed; don't bother showing if there's already fighting going on over there
		        } else if (rando >= 41) and (rando < 81) and (p_traitors[i] < 2) {
		            if (is_garrison_force) {
		                traitor_mod = choose(1, 2);
		            } else {
		                traitor_mod = 2;
		            }

		            p_traitors[i] = traitor_mod;
		            tixt = $"Heretic cults have appeared in {planet_string}."
		        } else if (rando >= 81) and (rando < 91) and (p_traitors[i] < 3) { // Minor uprising
		            if (is_garrison_force) {
		                traitor_mod = choose(2, 3);
		            } else {
		                traitor_mod = 3;
		            }
		            p_traitors[i] = traitor_mod;
		            tixt = $"Heretic cults have spread around {planet_string}.";
		        } // Major uprising

		        // major and huge uprisings are impossible as long as a garrison of at least 10 marines is present
		        if (rando >= 91) and (rando < 100) and (p_traitors[i] < 4) {
		            notixt = true;
		            p_traitors[i] = 4;

		            if (obj_controller.faction_defeated[10] = 0) and (obj_controller.faction_gender[10] = 1) then
		                p_traitors[i] = 5;

		            var n_name = planet_numeral_name(i);
		            scr_popup("Heretic Revolt", $"A massive heretic uprising on {n_name} threatens to plunge the star system into chaos.", "chaos_cultist", "");
		            scr_alert("red", "owner", $"Massive heretic uprising on {n_name}.", x, y);
		            scr_event_log("purple", $"Massive heretic uprising on {n_name}.", name);
		        } // Huge uprising

		        if (rando >= 100) and (p_traitors[i] < 5) {
		            p_traitors[i] = 6;
		            p_owner[i] = 10;
		            array_push(p_feature[i], new NewPlanetFeature(P_features.Daemonic_Incursion));

		            if (p_heresy[i] >= 80){
		            	p_heresy[i] = 95;
		            }else if (p_heresy[i] < 80) {
		            	p_heresy[i] = 80;
		            }

		            tixt = $"Daemonic incursion on {planet_numeral_name(i)}!";
		        } // Oh god what

		        if ((rando >= 41) and (!notixt) && tixt!="") {
		            scr_alert("red", "owner", tixt, x, y);
		            scr_event_log("purple", tixt, name);
		        }
		        // if (p_traitors[i]>2){obj_controller.x=self.x;obj_controller.y=self.y;}
		    } // End traitors cult

		}
		// Genestealer cults grow in number
		if (planet_feature_bool(p_feature[i], P_features.Gene_Stealer_Cult)){
			var cult = return_planet_features(p_feature[i], P_features.Gene_Stealer_Cult)[0];
			cult.cult_age++;
			adjust_influence(eFACTION.Tyranids, cult.cult_age/100, i)
			var planet_garrison = system_garrison[i-1];
			if (cult.hiding){
				var find_nid_chance = 50 - planet_garrison.total_garrison;
				if (p_influence[i][eFACTION.Tyranids]>50){
					var find_cult_chance = irandom(50);
					var alert_text = $"A hidden Genestealer Cult in {name} Has suddenly burst forth from hiding!"
					if (planet_garrison.garrison_force){
						var alert_text = $"A hidden Genestealer Cult in {name} Has been discovered by marine garrison!"
						find_cult_chance-=25;
					}
					if(find_cult_chance<1){
						cult.hiding=false;
	                    scr_popup("System Lost",alert_text,"Genestealer Cult","");
	                    owner = eFACTION.Tyranids;
	                    scr_event_log("red",$"A hidden Genestealer Cult in {name} {i} has Started a revolt.", name);		
	                    p_tyranids[i]+=1;				
					}
				}
			}
		    if (!cult.hiding) and (p_tyranids[i]<=3) and (p_type[i]!="Space Hulk") && (p_influence[i][eFACTION.Tyranids]>10){
		        var spread=0;
		        rando=irandom(150);
		      	rando-=p_influence[i][eFACTION.Tyranids];
		        if (rando<=15) then spread=1;
		      
		        if (p_type[i]="Lava") and (p_tyranids[i]=2) then spread=0;
		        if ((p_type[i]="Ice") or (p_type[i]="Desert")) and (p_tyranids[i]=3) then spread=0;
		      
		        if (spread=1) then p_tyranids[i]+=1;
		    }
		    if (p_influence[i][eFACTION.Tyranids]>55){
		    	p_owner[i] = eFACTION.Tyranids;
		    }
		} else if (p_influence[i][eFACTION.Tyranids]>5){
			adjust_influence(eFACTION.Tyranids, -1, i);
			if ((irandom(200)+(p_influence[i][eFACTION.Tyranids]/10)) > 195){
				array_push(p_feature[i], new NewPlanetFeature(P_features.Gene_Stealer_Cult));
			}
		}

// Spread influence on controlled sector
		if ((p_type[i]!="Space Hulk") and (p_type[i]!="Dead")){
		    if (p_heresy[i]<70) and (owner=10)  then p_heresy[i]+=2;
		    if (p_heresy[i]<70) and (owner=8) {
		        var doggy=floor(random(100))+1;
		        if (doggy<=5) and (p_heresy[i]>=20) then p_heresy[i]+=1;
		    }
		}
    
	    if (p_type[i]=="Daemon") and (p_type[i]!="Space Hulk"){
	        if (p_pdf[i]>0) then p_pdf[i]=0;
	        if (p_guardsmen[i]>0) then p_guardsmen[i]=0;
	    }
	    // if (p_heresy[i]>0) and (owner != eFACTION.Chaos) then p_heresy[i]-=2;
	}
	// Tau rebellions
	if (present_fleet[8]>=1) and (owner != eFACTION.Tau){
	    var flit, ran1, ran2, tau_chance;
	    flit=scr_orbiting_fleet(eFACTION.Tau);
	    ran1=0;
	    ran2=floor(random(planets))+1;
    
    
	    if (flit!="none"){
	        ran1=floor(random(100))+1;
        	var tau_influence = p_influence[ran2][eFACTION.Tau];
        	if (tau_influence<90 && (p_type[ran2]!="Dead")){
		        if (flit.image_index=1) and (ran1<=90){
		           adjust_influence(eFACTION.Tau, choose(2,3), ran2);
		            if (p_type[ran2]=="Forge") and (tau_influence>=3) then adjust_influence(eFACTION.Tau, -3, ran2);
		        }else if (flit.image_index>1) and (flit.image_index<4) and (ran1<=90){
		            adjust_influence(eFACTION.Tau, choose(7,9,11,13), ran2);
		            if (p_type[ran2]=="Forge") and (tau_influence>=10) then adjust_influence(eFACTION.Tau, -10, ran2);
		        }else if (flit.image_index>=4){
		            adjust_influence(eFACTION.Tau, choose(9,11,13,15,17), ran2);
		            if (p_type[ran2]=="Forge") and (tau_influence>=13) then adjust_influence(eFACTION.Tau, -13, ran2);
		        }
		    }
	        if (p_type[ran2]="Lava") and (tau_influence<90) then tau_influence+=10;
	    }
    
    
		for (i=1;i<=planets;i++){
			var tau_influence = p_influence[i][eFACTION.Tau];
	        tau_chance=floor(random(100))+1;
        
	        if (i<=planets) and (tau_influence>=70) and (p_owner[i]!=8) and (p_owner[i]!=10) and (p_owner[i]!=7) and (p_owner[i]!=9) and (p_type[i]!="Space Hulk"){
	        	for (var s=1;s<=planets;s++){
	        		 if (p_owner[s]=8) then tau_chance+=5;
	        	}
				
	            if (flit.owner = eFACTION.Tau){tau_chance+=(flit.image_index*5)-5;}
            
            
	            if (tau_chance>=95){/*obj_controller.x=self.x;obj_controller.y=self.y;show_message(string(tau_chance)+" |"+string(p_orks[i])+"|"+string(p_traitors[i]));*/}
            
	            if (tau_chance>=95) and (p_orks[i]=0) and (p_traitors[i]=0) and (p_necrons[i]=0) and (p_demons[i]=0) and (p_chaos[i]=0){
	                p_owner[i]=8;
	                if (p_guardsmen[i]>0){
	                	p_pdf[i]+=p_guardsmen[i];
	                	p_guardsmen[i]=0;
	                }
                
	                var targ=0,have=0,badd=1;
                
	                targ=planets;
	                for (var s=1;s<=planets;s++){
	                	if (p_type[s]="Dead") then targ-=1;
	                	if (p_owner[s]=8) then have+=1;
	                }
                
	                if (have=targ) then badd=2;
                
	                if (badd=1){ 
						scr_alert("red","owner","Planet "+planet_string+" has succeeded to the Tau Empire!",x,y);
						if (visited==1) {  //visited variable checks whether the star has been visited by the chapter or not 1 for true 0 for false
							if(p_type[i]=="Forge") { 
								dispo[i]-=10; // 10 disposition decreases for the respective planet
								obj_controller.disposition[eFACTION.Mechanicus]-=10; // 10 disposition decrease for the toaster Fetishest since they aren't that many toasters in 41 millennia
							}  
							else if(planet_feature_bool(p_feature[i], P_features.Sororitas_Cathedral) or (p_type[i]=="Shrine")) { 
								dispo[i]-=10; // 10 disposition decreases for the respective planet
								obj_controller.disposition[5]-=5;
							} 
							else dispo[i]-=10; // you had only 1 job.
						} 
					}

	                if (badd=2){
	                    scr_popup("System Lost",$"The {name} system has been taken by the Tau Empire!","tau","");
	                    owner = eFACTION.Tau;
	                    scr_event_log("red",$"System {name} has been taken by the Tau Empire.", name);
	                }
                
	                if (p_pdf[i]!=0) then p_pdf[i]=round(p_pdf[i]*0.75);
	                if (p_guardsmen[i]!=0) then p_guardsmen[i]=round(p_guardsmen[i]*0.75);
	            }
	        }
		    if (p_owner[i]=8) and (tau_influence<80){
		    	if ((p_type[i]!="Forge") and (p_type[i]!="Shrine")){tau_influence+=2;}
		    	else if ((p_type[i]="Forge") or (p_type[i]="Shrine")) then tau_influence+=choose(0,1);
		    }        
	    }// End repeat
       
	}

}
