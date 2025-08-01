function disposition_description_chart(dispo) {
    if (global.cheat_debug) {
        return $"{dispo}"
    } else if (dispo < -4000) {
    	return "Ruled";
    }else if (dispo < -100) {
        return "DEBUG: Numbers lower than -100 detected, this shouldn't happen!";
    } else if (dispo <= 0) {
        return "Extremely Hostile";
    } else if (dispo < 10) {
        return "Very Hostile";
    } else if (dispo < 30) {
        return "Hostile";
    } else if (dispo < 50) {
        return "Uneasy";
    } else if (dispo < 60) {
        return "Neutral";
    } else if (dispo < 70) {
        return "Friendly";
    } else if (dispo < 80) {
        return "Very Friendly";
    } else if (dispo < 90) {
        return "Excellent";
    } else if (dispo <= 100) {
        return "Unquestionable";
    } else {
        return "DEBUG: Numbers higher than 100, this shouldn't happen!";
    }
}

function GarrisonForce(planet_operatives, turn_end=false, type="garrison") constructor{
	garrison_squads=[];
	total_garrison = 0;
	garrison_leader=false;
	garrison_force=false;
	members = [];
	time_on_planet = 0;
	viable_garrison = 0;
	var operative, unit, member;
	 for (var ops=0;ops<array_length(planet_operatives);ops++){
      	if(planet_operatives[ops].type=="squad"){
      		if (planet_operatives[ops].job == type){//marine garrison on planet
      			if (array_length(obj_ini.squads[planet_operatives[ops].reference].members)>0){
      				operative = obj_ini.squads[planet_operatives[ops].reference];
	      			array_push(garrison_squads, operative)
	      			total_garrison += array_length(operative.members);
	      			garrison_force=true;
	      			for (var i = 0; i<array_length(operative.members);i++){
	      				member = operative.members[i];
	      				unit = fetch_unit([member[0], member[1]]);
	      				if (!is_struct(unit)) then continue;
	      				if (unit.name() =="") then continue;
	      				array_push(members, unit);
	      				if (unit.hp()>0) then  viable_garrison++;
	      			}
	      			if (turn_end) then planet_operatives[ops].task_time++;
	      			if (planet_operatives[ops].task_time>time_on_planet){
	      				time_on_planet=planet_operatives[ops].task_time;
	      			}
	      		} else {
	      			array_delete(planet_operatives, ops,1);
	      			ops--;
	      		}
      		}
      	}		 	
	 } 

	static garrison_sustain_damages = function(win_or_loss){
		var unit;
		var member_count = array_length(members);
		var members_lost = 0;
		for (var i=0;i<member_count;i++){
			unit = members[i];
			if (unit.hp()>0){
				if (win_or_loss=="win"){
					if (irandom(1)==0){
						unit.add_or_sub_health(-40);
					}
					if (unit.hp()<0){
						if (unit.calculate_death()){
							kill_and_recover(unit.company, unit.marine_number);
							members_lost++;
							array_delete(members, i, 1);
							i--;
							member_count--;
						}
					}
				}
				else if (win_or_loss=="loose"){
					unit.add_or_sub_health(-50);
					if (unit.hp()<0){
						if (unit.calculate_death()){
							kill_and_recover(unit.company, unit.marine_number);
							array_delete(members, i, 1);
							i--;
							members--;
							members_lost++;
						}
					}				
				}
			}
		}
		return members_lost;
	}

	static find_leader = function(){//find leader of garrison by finding most senior squad leader
		garrison_leader="none";
		var hierarchy = role_hierarchy();
		var leader_hier_pos=array_length(hierarchy);
		var unit;
		for (var _squad=0;_squad<array_length(garrison_squads);_squad++){
			var _leader = garrison_squads[_squad].determine_leader();
			unit = obj_ini.TTRPG[_leader[0]][_leader[1]];
			if (garrison_leader=="none"){
				garrison_leader=unit;
				for (var r=0;r<array_length(hierarchy);r++){
					if (hierarchy[r]==unit.role()){
						leader_hier_pos=r;
						break;
					}
				}				
			}else if (hierarchy[leader_hier_pos]==unit.role()){
				if (garrison_leader.experience<unit.experience){
					garrison_leader=unit;
				}
			}else{
				for (var r=0;r<leader_hier_pos;r++){
					if (hierarchy[r]==unit.role()){
						leader_hier_pos=r;
						garrison_leader=unit;
						break;
					}
				}
			}
		}
	};

	static exp_rewards =  function(){
		var m;
		var unit;
		for (var s=0;s<array_length(garrison_squads);s++){
			_squad = garrison_squads[s];
			for (m=0; m<array_length(_squad.members);m++){
				unit = fetch_unit(_squad.members[m]);
			}
		}
	}

	static garrison_report = function(){
		var system = obj_star_select.target;
		var planet = obj_controller.selecting_planet;
		var report_string = "Hail My lord.##";
		report_string+=$"Report for garrison on {system.name} {scr_roman_numerals()[planet-1]} is as follows#";
		if ((array_length(garrison_squads)) > 1){
			report_string+= $"The garrison is comprised of {array_length(garrison_squads)} squads,"
		} else {report_string+="The garrison is comprised of a single _squad,"}

		report_string+= $" with a total man count of {total_garrison}.#"
        if (system.p_owner[planet] != eFACTION.Player && system.dispo[planet] >=-100) {
            var disposition = disposition_description_chart(system.dispo[planet]);
            report_string += $"Our Relationship with the Rulers of the planet is {disposition}#";
        } else if (system.dispo[planet] < -1000) {
        	if (system.p_owner[planet] == eFACTION.Player){
            	report_string += $"Rule of the planet is going well";
        	} else {
        		report_string += $"Your rule of the the planet is being undermined by hostile forces";
        	}
        } else {
            report_string += $"DEBUG: planet owner check failed";
            //report_string+=$"There is no clear chain of command on the planet we suspect the existence of Xenos or Heretic Forces"; // TODO LOW GARRISON_XENO // Readd when this actually gets implented
        }

		return report_string;
	}

	static garrison_disposition_change = function(star, planet, up_or_down = false){
		dispo_change = 0;
		var _pdata = new PlanetData(planet, star);
		if (array_contains(obj_controller.imperial_factions, _pdata.current_owner)){
			var _planet_disposition = _pdata.player_disposition;

			var _main_faction_disp = _pdata.owner_faction_disposition();

			//basivally it is easier to increase dispositioon the nearer you are to 50 but becomminig greatly hated or greaty liked is much harder
			var _disposition_modifier = _planet_disposition<=50 ? (_planet_disposition/10) :((_planet_disposition-50)/10)%5;

			_disposition_modifier /= 10;

			var _time_modifier = max(time_on_planet/2.5, 10);

			if (!garrison_leader){
		    	find_leader();
		    }
		    var _diplomatic_leader = false;
            if (is_struct(garrison_leader)) {
                _diplomatic_leader = garrison_leader.has_trait("honorable");
            } else {
                scr_alert("yellow", "DEBUG", $"DEBUG: Garrison _Leader on {star.name} {planet} couldn't be found!", 0, 0);
                scr_event_log("yellow", $"DEBUG: Garrison _Leader on {star.name} {planet} couldn't be found!");
                log_error($"DEBUG: Garrison _Leader on {star.name} {planet} couldn't be found!");
            }
            var _garrison_size_mod = total_garrison/10;

			var final_modifier = 5 + _garrison_size_mod - _disposition_modifier + _time_modifier;

			if (up_or_down){
				dispo_change =  garrison_leader.charisma + final_modifier;
				if (dispo_change<50 && ((_planet_disposition < _main_faction_disp) || _diplomatic_leader)){
					dispo_change = 50;
				}
			} else {
				var charisma_test = global.character_tester.standard_test(garrison_leader, "charisma", final_modifier);
                if (!charisma_test[0]) {
                    if (_diplomatic_leader) {
                        dispo_change = "none";
                    } else {
                        if (_planet_disposition > _main_faction_disp) {
                            _pdata.add_disposition(dispo_change);
                        } else {
                            dispo_change = 0;
                        }
                    }
                } else {
                    dispo_change = charisma_test[1] / 10;
                    _pdata.add_disposition(dispo_change);
                }
			}
		} else {
			dispo_change = "none";
		}
		return dispo_change;
	}

	/* this is probably going to become infinatly complex with many different functions and far more complex inputs
	but for now i'm just trying to set up a concept with some simple examples*/
	static determine_battle = function(attack_defend, win, margin, enemy, location, planet=0, ship=0){
		var _sim = global.character_tester;
		if (win){

		}else{
			//var squad_positions;
			var _leader;
			var m;
			var unit;
			var effort="failed";
			switch(enemy){
				case eFACTION.Ork://trying to come up with how we might auto evaluate a squads fate in a battle
					for (var s=0;s<array_length(garrison_squads);s++){//loop squads in the garrison
						_squad = garrison_squads[s];
						_leader = fetch_unit(_squad.squad_leader);
						/*here we decide if a _squad had favourable positioning for the coming battle
						   take a random of their wisdom plus their luck minus how bad the combat loss was
						*/
						var _squad_wisdom_test = _sim.standard_test(_leader, "wisdom",-1*margin);//maybe modify this by the overall garrison commander value
						//under 20 unlucky, over 20 standard over 30 good, over 40 great
						if (_squad_wisdom_test[0]){
							combat_type = choose(1,2,3);//1= close combat 2=fire fight 3=both
							switch(combat_type){
								case 1:
									for (m=0; m<array_length(_squad.members);m++){//see how _squad members faired in their circumstances
										unit = _squad.fetch_member(m);
										if (irandom(unit.weapon_skill)>margin){//if unit "wins" in combat test against weapon skill as this is a cc enagement
											if (irandom(4999)<sqr(unit.weapon_skill-35)+unit.luck){//chance unit does something heroic
												//wonder if luck should be renamed to fate ??
												var alligience="imperial";
												switch (choose("still_standing","slay_champion", "hold_breach")){
													//feats and traits are stored seperatly but use very similar mechanics
													//this is because i am not linking feats to indepth mecanics theyre just logs of unit deeps
													//however a unit that collects a couple of slay_champion feats may earn the warlord_slayer trait with built in mechanics
													//think of it as a more story lead skill tree
													//equally a feat does not be stored anywhere you can just makeem up on the fly where as a trait has to be stored in teh global trait list
													//this may all be subject to change but in my head it's coming together
													case "hold_breach":
														unit.add_feat({
															ident:"hold_breach",
															title : "Held breach",
															planet:planet,
															grade : 5,
															location:"location",
															text : $"Single Handedly held a breach in the {alligience} during the {effort} {attack_defend} of {location} {scr_roman_numeral[planet-1]} from the Orks"
														});
														break;
													case "still_standing":
														unit.add_feat({
															ident:"still_standing",
															planet:planet,
															location:"location",
															text : $"Was pullled from beneath the carcesses of his slain {alligience} during the {effort} {attack_defend} of {location} {scr_roman_numeral[planet-1]} from the Orks"
														});														
												}
											}
										} else {//unit "looses combat"
											var toughness_check = irandom(99)-(floor(unit.constitution)/8);//we can build some static test functions for these sorts of things
											//now we need some sort of toughness to chart to check against
											//then take a roll against a seperate injury chart or some such thing
											//roll against piett??? chance or a miracle ??
										}
									}
									break;
							}
						}
					}
					scr_popup("Garrison Report", "Garrison forces on......", "imperial", "");
					break;
			}
		}
	}
}


function determine_pdf_defence(pdf, garrison="none", planet_forti=0, enemy=0){
	var explanations = "";
	var defence_mult = planet_forti*0.1;
	var pdf_score=0;
	explanations += $"Planet Defences:X{defence_mult+1}#"
	if (garrison!="none"){//if player supports give garrison bonus
    	var garrison_mult = garrison.viable_garrison*(0.008+(0.001*planet_forti))
    	var siege_masters =scr_has_adv("Siege Masters");
    	if (siege_masters) then garrison_mult*=2;
    	explanations += $"Garrison Bonus:X{garrison_mult+1}#";
    	if (siege_masters){
    		explanations += $"     Siege Masters:X2#";
    	}
    	if (!garrison.garrison_leader){
	    	garrison.find_leader();
	    }
    	defence_mult+=garrison_mult;
    	var leader_bonus = garrison.garrison_leader.wisdom/30;
    	defence_mult*=leader_bonus;//modified by how good a commander the garrison _leader is
    	explanations += $"     Garrison _Leader Bonus:X{leader_bonus}(WIS/30)#"
    	//makes pdf more effective if planet has defences or marines present
	}

    if (pdf >= 50000000){
	    pdf_score = 6;
	} else if (pdf < 50000000 && pdf >= 15000000) {
	    pdf_score = 5;
	} else if (pdf < 15000000 && pdf >= 6000000) {
	    pdf_score = 4;
	} else if (pdf< 6000000 && pdf >= 1000000) {
	    pdf_score = 3;
	} else if (pdf < 1000000 && pdf >= 100000) {
	    pdf_score = 2;
	} else if (pdf < 100000 && pdf >= 2000) {
	    pdf_score = 1;
	} else if (pdf < 2000 &&pdf >500) {
	    pdf_score = 0.5;
	} else if (pdf <= 500) {
	    pdf_score = 0.1;
	}
	explanations += $"PDF Defence: {pdf_score}#"
	pdf_score*=(1+defence_mult);
	return [pdf_score, explanations];
}







