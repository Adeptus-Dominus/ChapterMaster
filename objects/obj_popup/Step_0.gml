try {
	if (hide == true) {
		exit;
	}

	if ((cooldown >= 0) && (cooldown <= 40)) {
		cooldown -= 1;
	}
	if (instance_exists(obj_controller)) {
		if (obj_controller.zoomed == 1) {
			with (obj_controller) {
				scr_zoom();
			}
		}
	}

	for (var i=0;i<array_length(options);i++){
		if (keyboard_check_pressed(ord(string(i+1))) && (cooldown <= 0)){
			press = i;
		}
	}
	if (press > -1){
		if (options[press] == ""){
			press = -1;
		}
	}

	if ((type != 6) && (master_crafted == 1)) {
		master_crafted = 0;
	}

	if ((image == "fuklaw") && (save > 0)) {
		if (press == 0) {
			var del = obj_saveload.save[save];
			var _save_file = string(PATH_save_files, del);
			if (file_exists(_save_file)) {
				file_delete(_save_file);
				if (file_exists($"save{del}log.ini")) {
					file_delete($"save{del}log.ini");
				}
				with (obj_saveload) {
					instance_destroy();
				}
				var news = instance_create(0, 0, obj_saveload);
				news.menu = woopwoopwoop;
				news.top = owner;
				news.alarm[4] = 1;

				instance_destroy();
			}
		}
		if (press == 1) {
			instance_destroy();
		}
		exit;
	}

	if ((room_get_name(room) == "Main_Menu") && (title == "Tutorial")) {
		if (press == 1) {
			// 1: yes, 2: no (without disabling)
			obj_main_menu_buttons.fading = 1;
			obj_main_menu_buttons.crap = 3;
			obj_main_menu_buttons.cooldown = 9999;
			instance_destroy();
		}
		if (press == 2) {
			ini_open("saves.ini");
			ini_write_real("Data", "tutorial", 1);
			ini_close();
		}

		if (press >= 1) {
			obj_main_menu_buttons.fading = 1;
			obj_main_menu_buttons.crap = self.press;
			obj_main_menu_buttons.cooldown = 9999;
			instance_destroy();
		}
		exit;
	} else if (pathway == "protect_raiders_disappear"){
		if (press == 0){
			title = "Captains Disgruntled";
			options1 = "continue";
			pathway = "";
			var _caps = scr_role_count(obj_ini.roles[100][eROLE.Captain]);
			var _worst = -1;
			var _worst_hit  = -1;
			for (var i=0;i<array_length(_caps);i++){
				if (!irandom(2)){
					var _cap = _caps[i];
					var _loyalty_hit = irandom(6);
					if (_loyalty_hit>_worst_hit){
						_worst_hit = _loyalty_hit;
						_worst = i;
					}
				}
			}
			
			if (_worst == -1){
				text = $"You are able to convince your captains of the strategic need to cover up the incidence, various excuses are made and fake logs that cove up the disaster of the mission"
			} else {
				text = $"Not all of your captains are convinced of the need to use deceit and a none have breached the order but it has soured your relations with a few namely {_caps[_worst].name_role()}"
			}
		} else if (press == 1){
			reset_popup_options();
			options1 = "continue";
			_pdata.add_disposition(-30);
			text = $"You prepare to have a large public memorial for your fallen marines on the planet surface as a show of defiance. The chapter are pleased by such an act and the population of the planet are mesmerized by the spectacle. The governor is furious not only has his incompetence to deal with the planets xenos issue been made public in such a way that the sector commander has now heard about it but he perceives his failures are being paraded in font of him\n nGovernor Disposition : -30";
		}
	}

	if ((image == "debug_banshee") && (cooldown <= 0)) {
		if (planet == 2) {
			if ((press == 0) || (press == 2)) {
				if (press == 0) {
					amount = 7;
				}
				if (press == 2) {
					amount = 9;
				}
				with (obj_star) {
					if ((choose(0, 1, 1) == 1) && (owner != eFACTION.Eldar) && (owner != 1)) {
						var fleet;
						fleet = instance_create(x, y, obj_en_fleet);
						fleet.owner = obj_popup.amount;
						if (obj_popup.amount == 7) {
							fleet.sprite_index = spr_fleet_ork;
							fleet.capital_number = 3;
							present_fleet[7] += 1;
						}
						if (obj_popup.amount == 9) {
							if (present_fleet[1] == 0) {
								vision = 0;
							}
							fleet.sprite_index = spr_fleet_tyranid;
							fleet.capital_number = 3;
							fleet.frigate_number = 6;
							fleet.escort_number = 16;
							present_fleet[9] += 1;
						}
						fleet.image_index = 4;
						fleet.orbiting = id;
					}
				}
				instance_destroy();
			}
			if (press == 1) {
				with (obj_star) {
					if ((choose(0, 1, 1) == 1) && (owner != eFACTION.Eldar) && (owner != 1)) {
						var h;
						h = 0;
						repeat (4) {
							h += 1;
							if ((p_type[h] != "Dead") && (p_type[h] != "")) {
								p_traitors[h] = 5;
								p_chaos[h] = 4;
							}
						}
					}
				}
				instance_destroy();
			}
		}
		if (planet == 5) {
			if (press == 0) {
				var fleet, tar;
				tar = instance_nearest(x, y, obj_star);
				fleet = instance_create(tar.x, tar.y, obj_en_fleet);
				fleet.owner = eFACTION.Ork;
				fleet.sprite_index = spr_fleet_ork;
				fleet.capital_number = 2;
				fleet.frigate_number = 5;
				tar.present_fleet[7] += 1;
				fleet.image_index = 4;
				fleet.orbiting = id;
				instance_destroy();
			}
			if (press == 1) {
				var fleet, tar;
				tar = instance_nearest(x, y, obj_star);
				fleet = instance_create(tar.x, tar.y, obj_en_fleet);
				fleet.owner = eFACTION.Tau;
				fleet.sprite_index = spr_fleet_tau;
				fleet.capital_number = 2;
				fleet.frigate_number = 5;
				tar.present_fleet[8] += 1;
				fleet.image_index = 4;
				fleet.orbiting = id;
				instance_destroy();
			}
			if (press == 2) {
				instance_destroy();
			}
		}
		if (planet == 3) {
			if (press == 0) {
				var fleet, tar;
				tar = instance_nearest(x, y, obj_star);
				fleet = instance_create(tar.x, tar.y, obj_en_fleet);
				fleet.owner = eFACTION.Imperium;
				fleet.sprite_index = spr_fleet_imperial;
				fleet.capital_number = 2;
				fleet.frigate_number = 5;
				tar.present_fleet[2] += 1;
				fleet.image_index = 4;
				fleet.orbiting = id;
				instance_destroy();
			}
			if (press == 1) {
				var fleet, tar;
				tar = instance_nearest(x, y, obj_star);
				fleet = instance_create(tar.x, tar.y, obj_en_fleet);
				fleet.owner = eFACTION.Chaos;
				fleet.sprite_index = spr_fleet_chaos;
				fleet.capital_number = 2;
				fleet.frigate_number = 5;
				tar.present_fleet[10] += 1;
				fleet.image_index = 4;
				fleet.orbiting = id;
				instance_destroy();
			}
			if (press == 2) {
				planet = 5;
				cooldown = 30;
				add_option(["Ork",  "Tau", "Cancel"]);
				text = "Ork, Tau, Cancel?";
				press = 0;
				exit;
			}
		}
		if (planet == 1) {
			if (press == 0) {
				planet = 2;
				cooldown = 30;
				text = "Select a faction";
				add_option(["Orks",  "Chaos", "Tyranids"]);
				press = 0;
				exit;
			}
			if (press == 1) {
				planet = 3;
				cooldown = 30;
				add_option(["Imperium",  "Heretic", "Xeno"]);
				text = "Imperium, Heretic, or Xeno?";
				press = 0;
				exit;
			}
			if (press == 2) {
				var flit1, flit2, onceh;
				onceh = 0;
				flit1 = instance_nearest(x, y, obj_p_fleet);
				flit2 = instance_nearest(x, y, obj_en_fleet);

				if (instance_exists(flit1) && instance_exists(flit2)) {
					if (point_distance(x, y, flit1.x, flit1.y) > point_distance(x, y, flit2.x, flit2.y)) {
						with (flit2) {
							instance_destroy();
						}
					} else {
						with (flit1) {
							instance_destroy();
						}
					}
					onceh = 1;
				}
				if ((onceh == 0) && (!instance_exists(flit1)) && instance_exists(flit2)) {
					if (point_distance(x, y, flit2.x, flit2.y) <= 40) {
						with (flit2) {
							instance_destroy();
						}
					}
					onceh = 1;
				}
				if ((onceh == 0) && instance_exists(flit1) && (!instance_exists(flit2))) {
					if (point_distance(x, y, flit1.x, flit1.y) <= 40) {
						with (flit1) {
							instance_destroy();
						}
					}
					onceh = 1;
				}

				instance_destroy();
			}
		}
		exit;
	}

	if (((title == "Inquisition Mission") || (title == "Inquisition Recon")) && (title != "Artifact Located") && (obj_controller.demanding == 1)) {
		demand = 1;
	}

	if ((image == "chaos_messenger") && (title == "Chaos Meeting")) {
		if ((mission == "meeting_1") || (mission == "meeting_1t")) {
			if (array_length(options) == 0) {
				add_option([
					"Die, heretic!",
					"Very well.  Lead the way.", 
					"I must take care of an urgent matter first.  (Exit)"
				]);
				exit;
			}
			if (array_length(options)) {
				if (press == 0) {
					with (obj_star) {
						var i = 0;
						repeat (planets) {
							remove_planet_problem(i, "meeting");
							remove_planet_problem(i, "meeting_trap");
						}
					}
					obj_controller.disposition[10] -= 10;
					text = "The heretic is killed in a most violent fashion.  With a lack of go-between the meeting cannot proceed.";
					reset_popup_options();
					mission = ""; // image="";
					if (obj_controller.blood_debt == 1) {
						obj_controller.penitent_current += 1;
						obj_controller.penitent_turn = 0;
						obj_controller.penitent_turnly = 0;
					}
					with (obj_temp_meeting) {
						instance_destroy();
					}
					cooldown = 20;
					exit;
				} else if ((press == 1) && (mission == "meeting_1")) {
					obj_controller.complex_event = true;
					obj_controller.current_eventing = "chaos_meeting_1";
					text = $"{global.chapter_name} signal your readiness to the heretic.  Nearly twenty minutes of following the man passes before {global.chapter_name} all enter an ordinary-looking structure.  Down, within the basement, {global.chapter_name} then pass into the entrance of a tunnel.  As the trek downward continues more and more heretics appear- cultists, renegades that appear to be from the local garrison, and occasionally even the fallen of your kind.  Overall the heretics seem well supplied and equip.  This observation is interrupted as your group enters into a larger chamber, revealing a network of tunnels and what appears to be ancient catacombs.  Bones of the ancient dead, the forgotten, litter the walls and floor.  And the chamber seems to open up wider, and wider, until {global.chapter_name} find yourself within a hall.  Within this hall, waiting for {global.chapter_name}, are several dozen Chaos Terminators, a Greater Daemon of Tzeentch and Slaanesh, and Chaos Lord " + string(obj_controller.faction_leader[eFACTION.Chaos]) + ".";
					reset_popup_options();
					mission = "cslord1";
					image = "";
					img = 0;
					image_wid = 0;
					size = 3;
					cooldown = 20;
					exit;
				} else if ((press == 1) && (mission == "meeting_1t")) {
					with (obj_star) {
						remove_star_problem("meeting");
						remove_star_problem("meeting_trap");
					}
					obj_controller.complex_event = true;
					obj_controller.current_eventing = "chaos_trap";
					text = $"{global.chapter_name} signal your readiness to the heretic.  Nearly twenty minutes of following the man passes before {global.chapter_name} all enter an ordinary-looking structure.  Down, within the basement, {global.chapter_name} then pass into the entrance of a tunnel.  As the trek downward continues more and more heretics appear- cultists, renegades that appear to be from the local garrison, and occasionally even the fallen of your kind.  Overall the heretics seem well supplied and equip.  This observation is interrupted as your group enters into a larger chamber, revealing a network of tunnels and what appears to be ancient catacombs.  Bones of the ancient dead, the forgotten, litter the walls and floor.  And the chamber seems to open up wider, and wider, until {global.chapter_name} find yourself within a hall.  Within this hall, waiting for {global.chapter_name}, are several dozen Chaos Terminators, a handful of Helbrute, and many more Chaos Space Marines.  The Chaos Lord is nowhere to be seen.  It is a trap.";
					reset_popup_options();
					mission = "cslord1t";
					image = "";
					img = 0;
					image_wid = 0;
					size = 3;
					cooldown = 20;
					exit;
				}
				if ((press == 2) && instance_exists(obj_turn_end)) {
					if (number != 0) {
						obj_turn_end.alarm[1] = 4;
					}
					with (obj_temp_meeting) {
						instance_destroy();
					}
					instance_destroy();
				}
			}
		}
	}

	if (title == "Scheduled Event") {
		if (array_length(options) == 0) {
			add_option(["Yes",  "No"]);
			exit;
		}

		if ((press == 0) && (!instance_exists(obj_event))) {
			instance_create(0, 0, obj_event);
			if (obj_controller.fest_planet == 0) {
				obj_controller.fest_attend = scr_event_dudes(1, 0, "", obj_controller.fest_sid);
			}
			if (obj_controller.fest_planet == 1) {
				scr_event_dudes(1, 1, obj_controller.fest_star, obj_controller.fest_wid);
			}
			hide = true;
			cooldown = 6000;
			title = "Scheduled Event:2";
			exit;
		}
		if (press == 1) {
			obj_controller.fest_repeats -= 1;
			if (obj_controller.fest_repeats <= 0) {
				obj_controller.fest_scheduled = 0;

				instance_create(0, 0, obj_event);
				if (obj_controller.fest_planet == 0) {
					obj_controller.fest_attend = scr_event_dudes(1, 0, "", obj_controller.fest_sid);
				}
				if (obj_controller.fest_planet == 1) {
					scr_event_dudes(1, 1, obj_controller.fest_star, obj_controller.fest_wid);
				}

				with (obj_event) {
					var ide = 0;
					repeat (700) {
						ide += 1;
						if ((attend_corrupted[ide] == 0) && (attend_id[ide] > 0)) {
							if (string_count("chaos", obj_ini.artifact_tags[obj_controller.fest_display]) > 0) {
								obj_ini.TTRPG[attend_co[ide], attend_id[ide]].corruption += choose(1, 2, 3, 4);
							}
							if (string_count("daemonic", obj_ini.artifact_tags[obj_controller.fest_display]) > 0) {
								obj_ini.TTRPG[attend_co[ide], attend_id[ide]].corruption += choose(6, 7, 8, 9);
							}
							attend_corrupted[ide] = 1;
						}
					}
				}
				with (obj_event) {
					instance_destroy();
				}

				var p1, p2, p3;
				p1 = obj_controller.fest_type;
				p3 = "";
				p2 = obj_controller.fest_planet;

				if (p2 > 0) {
					p3 = string(obj_controller.fest_star) + " " + scr_roman(obj_controller.fest_wid);
				}
				if (p2 <= 0) {
					p3 = +" the vessel '" + string(obj_ini.ship[obj_controller.fest_sid]) + "'";
				}

				scr_alert("green", "event", string(p1) + " on " + string(p3) + " ends.", 0, 0);
				scr_event_log("green", string(p1) + " on " + string(p3) + " ends.");
			}
			obj_controller.cooldown = 10;
			if (number != 0 && instance_exists(obj_turn_end)) {
				obj_turn_end.alarm[1] = 4;
			}
			instance_destroy();
		}
	}
	if (title == "Scheduled Event:2") {
		exit;
	}

	if ((image == "inquisition") && (loc == "contraband")) {
		demand = 0;
		add_option(["Hand over all Chaos and Daemonic Artifacts",  "Over your dead body"], true);
		var arti;
		if (press == 0) {
			var contraband = [];
			for (var i = 0; i < array_length(obj_ini.artifact_struct); i++) {
				if (obj_ini.artifact != "") {
					arti = fetch_artifact(i);
					if (arti.inquisition_disaprove()) {
						array_push(contraband, i);
					}
				}
			}
			for (i = 0; i < array_length(contraband); i++) {
				delete_artifact(contraband[i]);
			}
			obj_controller.cooldown = 10;
			reset_popup_options();
			loc = "";
			text = $"All Chaos and Daemonic Artifacts present have been handed over to the Inquisitor.  They remain seething, but your destruction has been stalled.  Or so {global.chapter_name} imagine.";
			exit;
		}

		if (press == 1) {
			obj_controller.cooldown = 10;
			if (number != 0 && instance_exists(obj_turn_end)) {
				obj_turn_end.alarm[1] = 4;
			}
			instance_destroy();
		}
	}

	if (image == "ruins_fort") {
		if ((press == 0) && (obj_controller.requisition >= 1000)) {
			obj_controller.requisition -= 1000;
			text = "Resources have been spent on the planet to restore the fortress.  The planet's defense rating has increased to 5 (";
			reset_popup_options();
			text += string(star_system.p_fortified[planet]) + "+";
			text += string(5 - star_system.p_fortified[planet]) + ")";
			star_system.p_fortified[planet] = max(star_system.p_fortified[planet], 5);
			cooldown = 15;
			exit;
		}
		if (press == 1) {
			var req = floor(random_range(200, 500)) + 1;
			image = "";
			text = $"Much of the fortress is demolished in order to salvage adamantium and raw materials.  The opration has yielded {req} requisition.";
			reset_popup_options();
			obj_controller.requisition += req;
			cooldown = 15;
			exit;
		}

		/*
        if (loot="fortress"){// Fortress
        var gene,pop;gene=floor(random_range(20,40))+1;pop=instance_create(0,0,obj_popup);
        pop.image="ruins_fort";pop.title="Ancient Ruins: Fortress";
        pop.text="Your battle brothers have found a massive, ancient fortress that has fallen into disrepair.  Gun batteries rusted, and walls covered in moss and undergrowth, it is a pale shadow of its former glory.  It is possible to repair the structure.  What is thy will?";
        pop.add_option="Repair the fortress to boost planet defenses.  (1000 Req)";
        pop.add_option="Salvage raw materials from the fortress.";
        }
        */
	}

	if (image == "mechanicus" && (title == "Mechanicus Mission" || title == "Mechanicus Mission Accepted")){
		mechanicus_mission_procedures();
	}

	if (image == "geneseed_lab") {
		if (press == 0) {
			image = "";
			text = "{estimate} gene-seed has been added to the chapter vaults.";
			reset_popup_options();
			obj_controller.gene_seed += estimate;
			with (obj_ground_mission) {
				instance_destroy();
			}
			cooldown = 15;
			exit;
		}
		if (press == 1) {
			var req;
			req = floor(random_range(200, 500)) + 1;
			image = "";
			text = "Technological components have been salvaged, granting " + string(req) + " requisition.";
			reset_popup_options();
			obj_controller.requisition += req;
			with (obj_ground_mission) {
				instance_destroy();
			}
			cooldown = 15;
			exit;
		}
		if (press == 2) {
			with (obj_ground_mission) {
				instance_destroy();
			}
			obj_controller.cooldown = 15;
			cooldown = 15;
			instance_destroy();
			exit;
		}
	}

    if (image == "ancient_ruins" && woopwoopwoop && move_to_next_stage()) {
        instance_deactivate_all(true);
        instance_activate_object(obj_ground_mission);
        instance_activate_object(obj_popup);
        var _explore_feature = obj_ground_mission.explore_feature;
        _explore_feature.suprise_attack();
        woopwoopwoop = 0;
        instance_destroy(self.id);
        instance_destroy();
        exit;
    } else if (image == "ancient_ruins" && array_length(options) && instance_exists(obj_ground_mission)) {
        if (press == 0) {
            // Begin
            var _ruins = obj_ground_mission.explore_feature;
            var ruins_battle = 0, ruins_fact = 0, ruins_disp = 0, ruins_reward = 0, dice, battle_threat = 0;

            _ruins.determine_race();

            dice = roll_dice_chapter(1, 100, "high");
            ruins_battle = dice <= 50;

            // ruins_battle=1;

            if (ruins_battle == 1) {
                dice = roll_dice_chapter(1, 100, "low");

                if (dice >= 0 && dice <= 60) {
                    battle_threat = 1;
                } else if (dice > 60 && dice <= 90) {
                    battle_threat = 2;
                } else if (dice < 99) {
                    battle_threat = 3;
                } else {
                    battle_threat = 4;
                }

                switch (_ruins.ruins_race) {
                case eFACTION.Player:
                case eFACTION.Imperium:
                case eFACTION.Chaos:
                    ruins_battle = choose(10, 10, 10, 10, 11, 11, 12);
                    break;
                case eFACTION.Ecclesiarchy:
                    ruins_battle = 10;
                    break;
                case eFACTION.Eldar:
                    ruins_battle = choose(6, 6, 10, 10, 10, 12);
                    break;
                default:
                    ruins_battle = choose(6, 10, 12);
                    break;
                }

                obj_ground_mission.ruins_race = _ruins.ruins_race;
                obj_ground_mission.ruins_battle = ruins_battle;
                obj_ground_mission.battle_threat = battle_threat;

                reset_popup_options();
                text = "Your marines descended into the ancient ruins, mapping them out as they go.  They quickly determine the ruins were once ";
                switch (_ruins.ruins_race) {
                case eFACTION.Player:
                    text += "a Space Marine fortification from earlier times.";
                    break;
                case eFACTION.Imperium:
                    text += "golden-age Imperial ruins, lost to time.";
                    break;
                case eFACTION.Ecclesiarchy:
                    text += "a magnificent temple of the Imperial Cult.";
                    break;
                case eFACTION.Eldar:
                    text += "Eldar colonization structures from an unknown time.";
                    break;
                case eFACTION.Chaos:
                    text += "golden-age Imperial ruins, since decorated with spikes and bones.";
                    break;
                }

                if (_ruins.failed_exploration == 1) {
                    text += $"{global.chapter_name} see the scarring in the walls and round impacts where your brothers died to clense this place of it's foul inhabitants";
                }
                text += "  Unfortunantly, it's too late before your Battle Brothers discern the ruins are still inhabited.  Shapes begin to descend upon them from all directions, masked in the shadows.";

                cooldown = 15;
                woopwoopwoop = 1;
                exit;
            } else {
                var obj = obj_ground_mission.obj;
                instance_activate_object(obj_star);
                scr_ruins_reward(star_by_name(obj_ground_mission.battle_loc), obj_ground_mission.num, obj_ground_mission.explore_feature);
                instance_destroy();
                exit;
            }
        }
        if (press == 1) {
            // Nothing
            scr_toggle_manage();
            with (obj_ground_mission) {
                instance_destroy();
            }
            instance_destroy();
            exit;
        }
        if (press == 2) {
            // Return to ship, exit
            scr_return_ship(obj_ini.ship[obj_ground_mission.ship_id], obj_ground_mission, obj_ground_mission.num);
            var man_size, ship_id, comp, plan, i;
            ship_id = 0;
            man_size = 0;
            comp = 0;
            plan = 0;
            ship_id = obj_ground_mission.ship_id;
            obj_controller.menu = 0;
            obj_controller.managing = 0;
            obj_controller.cooldown = 10;
            with (obj_ground_mission) {
                instance_destroy();
            }
            instance_destroy();
            exit;
        }
    }

	else if (image == "gene_bad") {
		var _opt = "Dispose of ";
		if (obj_controller.gene_seed <= 30) {
			_opt += "100% of the gene-seed.";
		}
		if ((obj_controller.gene_seed > 30) && (obj_controller.gene_seed < 60)) {
			_opt += "50% of all gene-seed.";
		}
		if (obj_controller.gene_seed >= 60) {
			_opt += "33% of all gene-seed.";
		}
		option2 = "Tell the apothecaries to let it be.";
		add_option([_opt, option2], true);
	}

	else if (((title == "Inquisition Mission") || (title == "Inquisition Recon")) && (array_length(options) == 0)) {
		add_option(["Accept",  "Refuse"]);
	}
	else if (title == "Inquisitor Located") {
		add_option(["Destroy their vessel",  "Hear them out"]);
	}
	else if (title == "Necron Tomb Excursion") {
		add_option(["Begin the Mission",  "Not Yet"]);
	}
	else if (title == "Necron Tunnels : 1") {
		add_option(["Continue",  "Return to the surface"]);
	}
	else if (title == "Necron Tunnels : 2") {
		add_option(["Continue",  "Return to the surface"]);
	}
	else if (title == "Necron Tunnels : 3") {
		add_option(["Continue",  "Return to the surface"]);
	}

	if ((title == "He Built It") && (array_length(options) == 0) && (string_count("submerged", text) == 0)) {
		add_option(["Execute the heretic",  "Move him to the Penitorium", "I see no problem"]);
	}

	if ((press == 0) && (array_length(options)) || ((demand == 1) && (mission != "") && (string_count("Inquisition", title) > 0)) || ((demand == 1) && (title == "Inquisition Recon"))) {
		if (image == "gene_bad") {
			var onceh;
			onceh = 0;
			if ((obj_controller.gene_seed <= 30) && (onceh == 0)) {
				obj_controller.gene_seed = 0;
			}
			if ((obj_controller.gene_seed > 30) && (obj_controller.gene_seed < 60) && (onceh == 0)) {
				obj_controller.gene_seed = round(obj_controller.gene_seed * 0.5);
			}
			if ((obj_controller.gene_seed >= 60) && (onceh == 0)) {
				obj_controller.gene_seed = round(obj_controller.gene_seed * 0.66);
			}
		}

		if ((title == "Inquisitor Located") || (title == "Artifact Offered") || (title == "Mercy Plea")) {
			with (obj_en_fleet) {
				if ((trade_goods == "male_her") || (trade_goods == "female_her")) {
					instance_destroy();
				}
			}

			if (obj_controller.demanding == 0) {
				obj_controller.disposition[4] += 1;
			}
			if (obj_controller.demanding == 1) {
				obj_controller.disposition[4] += choose(0, 0, 1);
			}

			if ((title == "Artifact Offered") || (title == "Mercy Plea")) {
				obj_controller.disposition[4] -= choose(0, 1);
			}

			title = "Inquisition Mission Completed";
			image = "exploding_ship";
			text = "The Inquisitor's ship begans to bank and turn, to flee, but is immediately fired upon by your fleet.  The ship explodes, taking the Inquisitor with it.  The mission has been accomplished.";
			reset_popup_options();

			scr_event_log("", "Inquisition Mission Completed: The radical Inquisitor has been purged.");

			exit;
		}
		if (title == "He Built It") {
			scr_kill_unit(ma_co, ma_id);
			var company_to_order = ma_co;
			with (obj_ini) {
				scr_company_order(company_to_order);
			}
		}

		if (title == "Necron Tomb Excursion") {
			instance_activate_all();
			var player_forces, penalty, roll;
			player_forces = 0;
			penalty = 0;
			roll = floor(random(100)) + 1;
			with (obj_star) {
				if (name != obj_popup.loc) {
					instance_deactivate_object(id);
				}
			}
			if (!instance_exists(obj_temp8)) {
				instance_create(obj_star.x, obj_star.y, obj_temp8);
			}
			player_forces = obj_star.p_player[planet];
			instance_activate_object(obj_star);
			cooldown = 30;

			obj_temp8.stage += 1;
			obj_temp8.loc = loc;
			obj_temp8.wid = planet;

			title = $"Necron Tunnels : {obj_temp8.stage}";
			if (obj_temp8.stage == 1) {
				image = "necron_tunnels_1";
				text = "Your marines enter the massive tunnel complex, following the energy readings.  At first the walls are cramped and tiny, closing about them, but the tunnels widen at a rapid pace.";
				add_option([ "Continue","Return to the surface"],true);
			}
			exit;
		}

		if (string_count("Necron Tunnels", title) > 0 && instance_exists(obj_temp8)) {
			var player_forces, penalty, roll, battle;
			player_forces = 0;
			penalty = 0;
			roll = floor(random(100)) + 1;
			battle = 0;
			instance_activate_all();
			var mission_star = star_by_name(obj_temp8.loc);

			player_forces = obj_star.p_player[obj_temp8.wid];

			obj_temp8.popup = obj_turn_end.current_popup;

			// SMALL TEAM OF MARINES
			if (player_forces > 6) {
				penalty = 10;
			}
			if (player_forces > 10) {
				penalty = 20;
			}
			if (player_forces >= 20) {
				penalty = 30;
			}
			if (player_forces >= 40) {
				penalty = 50;
			}
			if (player_forces >= 60) {
				penalty = 100;
			}
			roll += penalty;

			// roll=30;if (string_count("3",title)>0) then roll=70;

			// Result
			if (roll <= 60) {
				obj_temp8.stage += 1;
				title = $"Necron Tunnels : {obj_temp8.stage}";

				if (obj_temp8.stage == 2) {
					image = "necron_tunnels_2";
					text = "The energy readings are much stronger, now that your marines are deep inside the tunnels.  What was once cramped is now luxuriously large, the tunnel ceiling far overhead decorated by stalactites.";
				} else if (obj_temp8.stage == 3) {
					image = "necron_tunnels_3";
					text = "After several hours of descent the entrance to the Necron Tomb finally looms ahead- dancing, sickly green light shining free.  Your marine confirms that the Plasma Bomb is ready.";
				} else if (obj_temp8.stage >= 4) {
					image = "";
					title = "Inquisition Mission Completed";
					text = "Your marines finally enter the deepest catacombs of the Necron Tomb.  There they place the Plasma Bomb and arm it.  All around are signs of increasing Necron activity.  With half an hour set, your men escape back to the surface.  There is a brief rumble as the charge goes off, your mission a success.";
					reset_popup_options();

					if (obj_controller.demanding == 0) {
						obj_controller.disposition[4] += 1;
					}
					if (obj_controller.demanding == 1) {
						obj_controller.disposition[4] += choose(0, 0, 1);
					}

					instance_activate_object(obj_star);
					mission_star = star_by_name(obj_temp8.loc);
					var ppp = 0;
					remove_planet_problem(planet, "necron", mission_star);
					seal_tomb_world(mission_star.p_feature[planet]);
					// mission_star.p_feature[planet][search_planet_features(mission_star.p_feature[planet], P_features.Necron_Tomb)[0]].sealed = 1;
					with (obj_temp8) {
						instance_destroy();
					}
					instance_activate_object(obj_star);

					scr_event_log("", $"Inquisition Mission Completed: Your Astartes have sealed the Necron Tomb on {mission_star.name} {scr_roman(planet)}.", mission_star.name);
					scr_gov_disp(mission_star.name, planet, choose(3, 4, 5, 6, 7));
					var have_bomb = scr_check_equip("Plasma Bomb", self.loc, self.planet, 1);
					exit;
				}
			}
			if ((roll > 60) && (roll <= 82)) {
				// Necron Wraith attack
				battle = 1;
			}
			if ((roll > 82) && (roll <= 92)) {
				// Tomb Spyder attack
				battle = 2;
			}
			if ((roll > 92) && (roll <= 97)) {
				// Tomb Stalker
				battle = 3;
			}
			if (roll > 97) {
				// Tomb World wakes up
				if (player_forces <= 30) {
					battle = 4;
				}
				if (player_forces > 30) {
					battle = 5;
				}
				if (player_forces > 100) {
					battle = 6;
				}
			}

			if (battle > 0) {
				var that_one;
				instance_deactivate_all(true);
				instance_activate_object(obj_controller);
				instance_activate_object(obj_ini);
				instance_activate_object(obj_temp8);

				instance_create(0, 0, obj_ncombat);
			    _roster = new Roster();
			    with (_roster){
			        roster_location = obj_temp8.loc;
			        roster_planet = obj_temp8.wid;
			        determine_full_roster();
			        only_locals();
			        update_roster();
			        if (array_length(selected_units)){  
			            setup_battle_formations();
			            add_to_battle();
			        }               
			    }
			    delete _roster;			


				instance_activate_object(obj_star);
				with (obj_star) {
					if (name != obj_temp8.loc) {
						instance_deactivate_object(id);
					}
				}

				that_one = instance_nearest(0, 0, obj_star);
				instance_activate_object(obj_star);

				obj_ncombat.battle_object = that_one;
				instance_deactivate_object(obj_star);
				obj_ncombat.battle_loc = loc;
				obj_ncombat.battle_id = planet;
				obj_ncombat.dropping = 0;
				obj_ncombat.attacking = 0;
				obj_ncombat.enemy = 13;
				obj_ncombat.threat = 1;
				obj_ncombat.formation_set = 1;

				if (battle == 1) {
					obj_ncombat.battle_special = "wraith_attack";
				} else if (battle == 2) {
					obj_ncombat.battle_special = "spyder_attack";
				} else if (battle == 3) {
					obj_ncombat.battle_special = "stalker_attack";
				} else if (battle == 4) {
					obj_ncombat.battle_special = "wake1_attack";
				} else if (battle == 5) {
					obj_ncombat.battle_special = "wake2_attack";
				} else if (battle == 6) {
					obj_ncombat.battle_special = "wake2_attack";
				}

				instance_destroy();
			}

			exit;
		}

		if (title == "Inquisition Recon") {
			var mission_star, onceh;
			onceh = 0;
			obj_controller.temp[200] = string(loc);
			var mission_star = star_by_name(obj_controller.temp[200]);
			if (add_new_problem(planet, "recon", estimate, mission_star)) {
				title = "Inquisition Mission Demand";
				text = $"The Inquisition demands that your Chapter demonstrate its loyalty to the Imperium of Mankind and the Emperor.  {global.chapter_name} are to land Astartes on {mission_star.name} {scr_roman(planet)} to investigate the planet within {estimate} months.";
				with (mission_star) {
					new_star_event_marker("green");
				}
				scr_event_log("", $"Inquisition Mission Accepted: The Inquisition wish for Astartes to land on and investigate {mission_star.name} {scr_roman(planet)} within {estimate} months.", mission_star.name);
			}
		}
		
		if ((mission != "") && (title == "Inquisition Mission")) {
			obj_controller.temp[200] = string(loc);
			var mission_star, onceh;
			mission_star = 0;
			onceh = 0;
			var mission_star = star_by_name(obj_controller.temp[200]);
			var mission_is_go = false;
			if (mission_star != "none" && planet > 0) {
				var _estimate = estimate;
				var _planet = planet;
				var _mission = mission;
				with (mission_star) {
					if (add_new_problem(_planet, _mission, _estimate)) {
						new_star_event_marker("green");
						mission_is_go = true;
					}
				}

				if (mission_is_go) {
					if (demand) {
						title = "Inquisition Mission Demand";
					}


					if (mission == "purge") {
						scr_event_log("", $"Inquisition Mission Accepted: The nobles of {mission_star.name} {scr_roman(planet)} must be selectively purged within {estimate} months.", mission_star.name);
						if (demand) {
							text = $"The Inquisition demands that your Chapter demonstrate its loyalty to the Imperium of Mankind and the Emperor.  {global.chapter_name} are to selectively purge the Nobles on {mission_star.name} {scr_roman(onceh)} within {estimate} months.";
						}
					} else if (mission == "cleanse") {
						scr_event_log("", $"Inquisition Mission Accepted: The mutants beneath {planet_numeral_name(planet, mission_star)} must be cleansed by fire within {estimate} months.", mission_star.name);
						if (demand) {
							text = $"The Inquisition demands that your Chapter demonstrate its loyalty to the Imperium of Mankind and the Emperor.  {global.chapter_name} are to cleanse by fire the mutants in Hive {planet_numeral_name(planet, mission_star)} within {estimate} months.";
						}
					} else if (mission == "inquisitor") {
						scr_event_log("", $"Inquisition Mission Accepted: A radical Inquisitor enroute to {mission_star.name} must be removed.  Estimated arrival in {estimate} months.", mission_star.name);
						if (demand) {
							text = $"The Inquisition demands that your Chapter demonstrate its loyalty to the Imperium of Mankind and the Emperor.  A radical inquisitor is enroute to {mission_star.name}, expected within {estimate} months.  They are to be silenced and removed.";
						}
					}

					if (mission == "spyrer") {
						scr_event_log("", $"Inquisition Mission Accepted: The Spyrer on {mission_star.name} {scr_roman(planet)} must be killed within {estimate} months.", mission_star.name);
						if (demand) {
							text = $"The Inquisition demands that your Chapter demonstrate its loyalty to the Imperium of Mankind and the Emperor.  An out of control Spyrer on Hive {mission_star.name} {scr_roman(onceh)} must be removed within {estimate} months.";
						}
					} else if (mission == "necron") {
						scr_event_log("", $"Inquisition Mission Accepted: {global.chapter_name} have been given a Bomb to seal the Necron Tomb on {mission_star.name} {scr_roman(planet)}.", mission_star.name);

						image = "necron_cave";
						title = "New Equipment";
						fancy_title = 0;
						text_center = 0;
						text = $"{global.chapter_name} have been provided with 1x Plasma Bomb in order to complete the mission.";

						if (demand) {
							text = $"The Inquisition demands that your Chapter demonstrate its loyalty.  {global.chapter_name} have been given a Plasma Bomb to seal the Necron Tomb on {mission_star.name} {scr_roman(onceh)}.  It is expected to be completed within {estimate} months.";
						}
						reset_popup_options();
						scr_add_item("Plasma Bomb", 1);
						obj_controller.cooldown = 10;
						if (demand) {
							demand = 0;
						}
						exit;
					} else if (mission == "tyranid_org") {
						image = "webber";
						title = "New Equipment";
						fancy_title = 0;
						text_center = 0;
						text = $"{global.chapter_name} have been provided with 4x Astartes Webbers in order to complete the mission.";

						if (demand) {
							text = $"The Inquisition demands that your Chapter demonstrate its loyalty to the Imperium of Mankind and the Emperor.  {global.chapter_name} are to capture a Gaunt organism and return it, unharmed- 4x Webbers have been provided for this purpose.";
						}

						reset_popup_options();
						scr_add_item("Webber", 4);
						obj_controller.cooldown = 10;
						scr_event_log("", $"Inquisition Mission Accepted: The Inquisition wishes for the capture of a particular strain Gaunt noticed on {mission_star.name} {scr_roman(planet)} is advisable.", mission_star.name);
						obj_controller.useful_info += "Tyr|";
						if (demand) {
							demand = 0;
						}
						exit;
					} else if (mission == "ethereal") {
						with (obj_star) {
							if ((p_tau[1] >= 4) || (p_tau[2] >= 4) || (p_tau[3] >= 4) || (p_tau[4] >= 4)) {
								new_star_event_marker("green");
							}
						}
						scr_quest(0, "ethereal_capture", 4, estimate);
						obj_controller.useful_info += "Tau|";

						if (demand) {
							title = "Inquisition Mission Demand";
							text = $"The Inquisition demands that your Chapter demonstrate its loyalty to the Imperium of Mankind and the Emperor.  {global.chapter_name} are to capture the Tau Ethereal somewhere within the {mission_star.name} system.";
						}
						if (has_problem_star("recon", mission_star)) {
							scr_event_log("", $"Inquisition Mission Accepted: The Inquisition wish for {global.chapter_name} to capture the Tau Ethereal somewhere within {mission_star.name}.", mission_star.name);
						}
					} else if (mission == "demon_world"){
						scr_event_log("", $"Inquisition Mission Accepted: The demon world of {mission_star.name} {scr_roman(planet)} will be purged by your hand.", mission_star.name);
						if (demand) {
							text = $"The Inquisition demands that your Chapter demonstrate its loyalty to the Imperium of Mankind and the Emperor.  An out of control Demon World {mission_star.name} {scr_roman(onceh)} must be cleansed within {estimate} months.";
						}
					}
				}
			}
			if (!mission_is_go) {
				if (mission == "artifact") {
					var last_artifact;
					scr_quest(0, "artifact_loan", 4, estimate);
					if (obj_ini.fleet_type == ePlayerBase.home_world) {
						image = "fortress";
						if (obj_ini.home_type == "Hive") {
							image = "fortress_hive";
						}
						if (obj_ini.home_type == "Death") {
							image = "fortress_death";
						}
						if (obj_ini.home_type == "Ice") {
							image = "fortress_ice";
						}
						if (obj_ini.home_type == "Lava") {
							image = "fortress_lava";
						}
						last_artifact = scr_add_artifact("good", "inquisition", 0, obj_ini.home_name, 2);
					} else if (obj_ini.fleet_type != ePlayerBase.home_world) {
						image = "artifact_given";
						last_artifact = scr_add_artifact("good", "inquisition", 0, obj_ini.ship[0], 501);
					}

					title = "New Artifact";
					fancy_title = 0;
					text_center = 0;
					text = "The Inquisition has left an Artifact in your care, until it may be retrieved.  It has been stored ";
					if (obj_ini.fleet_type == ePlayerBase.home_world) {
						text += "within your Fortress Monastery.";
					}
					if (obj_ini.fleet_type != ePlayerBase.home_world) {
						text += $"upon your ship '{obj_ini.ship[0]}'.";
					}
					scr_event_log("", "Inquisition Mission Accepted: The Inquisition has left an Artifact in your care.");

					text += $"  It is some form of {obj_ini.artifact[last_artifact]}.";
					reset_popup_options();
					obj_controller.cooldown = 10;
					exit;
				}
			}

			if (demand) {
				demand = 0;
				reset_popup_options();
				exit;
			} // Remove multi-choices
		}

		if ((image == "inquisition") && (title == "Investigation Completed")) {
			obj_temp7.alarm[1] = 1;
			instance_destroy();
		}

		if (image == "artifact2") {
			ground_forces_collect_artifact();
			obj_controller.cooldown = 10;
			instance_destroy();
		}

		obj_controller.cooldown = 10;
		if (obj_controller.complex_event == false) {
			if (number != 0 && instance_exists(obj_turn_end)) {
				obj_turn_end.alarm[1] = 4;
			}
			instance_destroy();
		}
	}

	if ((press == 1) && (option2 != "")) {
		if (image == "gene_bad") {
			scr_loyalty("Mutant Gene-Seed", "+");
		}

		if (mission == "spyrer") {
			obj_controller.disposition[4] -= 2;
		}
		if (title == "Inquisition Recon") {
			obj_controller.disposition[4] -= 2;
		}
		if ((image == "inquisition") && (title == "Investigation Completed")) {
			with (obj_temp7) {
				instance_destroy();
			}
			instance_destroy();
		}

		if (title == "Artifact Offered") {
			with (obj_en_fleet) {
				if ((trade_goods == "male_her") || (trade_goods == "female_her")) {
					instance_destroy();
				}
			}

			var last_artifact = scr_add_artifact("random", "", 4);

			reset_popup_options();
			title = "Inquisition Mission Completed";
			text = "Your ship sends over a boarding party, who retrieve the offered artifact- ";
			text += $" some form of {obj_ini.artifact[last_artifact]}.  Once it is safely stowed away your ship is then ordered to fire.  The Inquisitor's own seems to hesitate an instant before banking away, but is quickly destroyed.";
			image = "exploding_ship";
			reset_popup_options();
			scr_event_log("", "Artifact recovered from radical Inquisitor.");
			scr_event_log("", "Inquisition Mission Completed: The radical Inquisitor has been purged.");
			exit;
		}

		if (title == "He Built It") {
			obj_ini.god[ma_co, ma_id] += 10;
			reset_popup_options();
		}

		if (title == "Mercy Plea") {
			// If have any marines within the fleet on the ships

			var able, i;
			able = 0;
			i = 0;

			// Several things can happen when the ship is searched;
			// Full of demons, maybe remove a marine, fired upon and explodes

			exit;
		}

		if (title == "Inquisitor Located") {
			var offer, gender, gender2;
			offer = choose(1, 1, 2, 2, 3);
			if (planet == 1) {
				gender = "he";
			}
			if (planet == 2) {
				gender = "she";
			}
			if (planet == 1) {
				gender2 = "his";
			}
			if (planet == 2) {
				gender2 = "her";
			}

			if (offer == 1) {
				title = "Artifact Offered";
				text = "The Inquisitor claims that this is a massive misunderstanding, and " + string(gender) + " wishes to prove " + string(gender2) + $" innocence.  If {global.chapter_name} allow their ship to leave " + string(gender) + $" will give {global.chapter_name} an artifact.";
				add_option("Destroy their vessel");
				add_option("Take the artifact and then destroy them");
				add_option("Take the artifact and spare them");
				exit;
			}

			if (offer == 2) {
				title = "Mercy Plea";
				text = "The Inquisitor claims that " + string(gender) + $" has key knowledge that would grant the Imperium vital power over the forces of Chaos.  If {global.chapter_name} allow " + string(gender2) + " ship to leave the forces of Chaos within this sector will be weakened.";
				add_option("Destroy their vessel");
				add_option("Search their ship");
				add_option("Spare them");
				exit;
			}

			if (offer == 3) {
				var gender2;
				if (planet == 1) {
					gender2 = "his";
				}
				if (planet == 2) {
					gender2 = "her";
				}
				with (obj_en_fleet) {
					if ((trade_goods == "male_her") || (trade_goods == "female_her")) {
						with (obj_p_fleet) {
							if (action != "") {
								instance_deactivate_object(id);
							}
						}
						with (instance_nearest(x, y, obj_p_fleet)) {
							scr_add_corruption(true, "1d3");
						}
						instance_activate_object(obj_p_fleet);
						instance_destroy();
					}
				}
				title = "Inquisition Mission Completed";
				image = "exploding_ship";
				text = $"{global.chapter_name} allow communications.  As soon as the vox turns on {global.chapter_name} hear a sickly, hateful voice.  They begin to speak of the inevitable death of your marines, the fall of all that is and ever shall be, and " + string(gender2) + " Lord of Decay.  Their ship is fired upon and destroyed without hesitation.";
				reset_popup_options();
				scr_event_log("", "Inquisition Mission Completed: The radical Inquisitor has been purged.");
				exit;
			}
			exit;
		}
		if (image == "artifact2") {
			scr_return_ship(obj_ground_mission.loc, obj_ground_mission, obj_ground_mission.num);
			var man_size, ship_id, comp, plan, i;
			i = 0;
			ship_id = 0;
			man_size = 0;
			comp = 0;
			plan = 0;
			ship_id = array_get_index(obj_ini.ship, obj_ground_mission.loc);
			obj_controller.menu = 0;
			obj_controller.managing = 0;
			obj_controller.cooldown = 10;
			with (obj_ground_mission) {
				instance_destroy();
			}
			instance_destroy();
			exit;
		}

		obj_controller.cooldown = 10;

		if (obj_controller.complex_event == false) {
			if (number != 0 && instance_exists(obj_turn_end)) {
				obj_turn_end.alarm[1] = 4;
			}
			instance_destroy();
		}
	}

	if ((press == 2) && (option3 != "")) {
		if (title == "Artifact Offered") {
			with (obj_en_fleet) {
				if ((trade_goods == "male_her") || (trade_goods == "female_her")) {
					action_x = choose(room_width * -1, room_width * 2);
					action_y = choose(room_height * -1, room_height * 2);
					alarm[4] = 1;
					trade_goods = "|DELETE|";
					action_spd = 256;
					action = "";
				}
			}
			var last_artifact = scr_add_artifact("random", "", 4);
			
			reset_popup_options();
			title = "Inquisition Mission Completed";
			text = "Your ship sends over a boarding party, who retrieve the offered artifact- ";
			text += $" some form of {obj_ini.artifact[last_artifact]}.  As promised {global.chapter_name} allow the Inquisitor to leave, hoping for the best.  What's the worst that could happen?";
			image = "artifact_recovered";
			reset_popup_options();
			scr_event_log("", "Artifact Recovered from radical Inquisitor.");
			scr_event_log("", "Inquisition Mission Completed: The radical Inquisitor has been purged.");

	        add_event({
	        	e_id : "inquisitor_spared",
	        	duration : irandom_range(6, 18) + 1,
	        	variation : 1,
	        })

			exit;
		}
		if (title == "Mercy Plea") {
			with (obj_en_fleet) {
				if ((trade_goods == "male_her") || (trade_goods == "female_her")) {
					action_x = choose(room_width * -1, room_width * 2);
					action_y = choose(room_height * -1, room_height * 2);
					trade_goods = "|DELETE|";
					alarm[4] = 1;
					action_spd = 256;
					action = "";
				}
			}
			title = "Inquisition Mission Completed";
			text = $"{global.chapter_name} allow the Inquisitor to leave, trusting in their words.  If they truly do have key information it is a risk {global.chapter_name} are willing to take.  What's the worst that could happen?";
			image = "artifact_recovered";
			reset_popup_options();

			scr_event_log("", "Inquisition Mission Completed?: The radical Inquisitor has been allowed to flee in order to weaken the forces of Chaos, as they promised.");

	        add_event({
	        	e_id : "inquisitor_spared",
	        	duration : irandom_range(6, 18) + 1,
	        	variation : 2,
	        })

			exit;
		}

		obj_controller.cooldown = 10;
		if (obj_controller.complex_event == false) {
			if (number != 0 && instance_exists(obj_turn_end)) {
				obj_turn_end.alarm[1] = 4;
			}
			instance_destroy();
		}
	}
	if (image == "new_forge_master") {
		if (pathway == "") {
			obj_controller.complex_event = true;
			techs = collect_role_group(SPECIALISTS_TECHS);
			charisma_pick = 0;
			experience_pick = 0;
			talent_pick = 0;
			for (i = 1; i < array_length(techs); i++) {
				if (techs[charisma_pick].charisma < techs[i].charisma) {
					charisma_pick = i;
				}
				if (techs[experience_pick].experience < techs[i].experience) {
					experience_pick = i;
				}
				if (techs[talent_pick].technology < techs[i].technology) {
					talent_pick = i;
				}
			}
			pathway = "selection_options";
			add_option(["Popular Pick","Experience Pick" ,"Talent Pick"], true);
		} else if (pathway == "selection_options") {
			if (press > -1) {
				var cur_tech;
				var skill_lack = 0;
				var exp_lack = 0;
				var dislike = 0;
				var popularity_lack = 0;
				var pick = "none";
				var charisma_test = 0;
				if (press > -1 && press < 4) {
					if (press == 0) {
						pick = techs[charisma_pick];
					} else if (press == 1) {
						pick = techs[talent_pick];
					} else if (press == 2) {
						pick = techs[experience_pick];
					}
					for (i = 0; i < array_length(techs); i++) {
						if (i == charisma_pick) {
							continue;
						}
						cur_tech = techs[i];
						charisma_test = global.character_tester.oppposed_test(pick, cur_tech, "charisma", 10);
						if (charisma_test[0] != 1) {
							if (pick.technology < cur_tech.technology) {
								skill_lack++;
								cur_tech.loyalty -= cur_tech.technology - pick.technology;
							}
							if (pick.experience < cur_tech.experience) {
								exp_lack++;
								cur_tech.loyalty -= floor((cur_tech.experience - pick.experience) / 200);
							}
							if (charisma_test[0] == 2) {
								dislike++;
								cur_tech.loyalty -= charisma_test[1];
							}
						}
					}
				}
				if (pick != "none") {
					pick.update_role("Forge Master");

					var likability;
					if (dislike <= 5) {
						likability = "He is generally well liked";
					}
					if (dislike > 5) {
						likability = "He is not generally well liked";
					}
					if (dislike > 10) {
						likability = "He mostly disliked";
					}
					if (dislike == 0) {
						likability = "He is like by all of his tech brothers";
					}
					text = $"{pick.name()} is selected as the new {pick.role()} {likability}.";
					if (skill_lack > 0 && skill_lack < 6) {
						text += "There are some questions about his ability.";
					} else if (skill_lack > 6) {
						text += "Many Question his Technical Talents.";
					}
					if (exp_lack > 0 && exp_lack < 6) {
						text += "A few have raised questions over his experience.";
					} else if (exp_lack >= 6) {
						text += "There have been Many concerns over his experience.";
					}
					if (popularity_lack > 1 && popularity_lack < 6) {
						text += "He is not unanimously liked.";
					} else if (popularity_lack >= 6) {
						text += "He is disliked by many.";
					}
					var lacks = skill_lack + exp_lack + popularity_lack;
					if (lacks < ((array_length(techs) - 1) / 10)) {
						text += "Your choice Is almost unanimously respected";
					} else if (lacks < ((array_length(techs) - 1) / 4)) {
						text += "While a few may have preferred another there are no serious concerns";
					} else if (lacks < ((array_length(techs) - 1) / 2)) {
						text += "Your supporters are more than our detractors but many are unhappy";
					} else if (lacks < ((array_length(techs) - 1) * 0.65)) {
						text += "Most are unhappy with the decision but your word is final";
					}
					reset_popup_options();
					press = 0;
					pathway = "end_splash";
					if (pick.company > 0) {
						for (var i = 1; i < 500; i++) {
							if (obj_ini.name[0][i] == "") {
								break;
							}
						}
						scr_move_unit_info(pick.company, 0, pick.marine_number, i);
					}
				}
			}
		}
	} else if (image == "tech_uprising") {
		if (pathway == "") {
			obj_controller.complex_event = true;
			pathway = "heretic_choice";
			add_option([ "Do Nothing","Support the heretics","Support the Cult mechanicus faithfuls"],true);
		} else if (pathway == "heretic_choice") {
			if (press > -1) {
				pathway = "tech_aftermath";
			}
		}
		if (pathway == "tech_aftermath") {
			var tech, t, i, check_tech, location_techs, location_heretics, delete_positions, heretic_data = [0, 0, 0], loyal_data = [0, 0, 0];
			techs = collect_role_group(SPECIALISTS_TECHS);
			var tech_count = array_length(techs);
			for (i = 0; i < tech_count; i++) {
				delete_positions = [];
				location_techs = [];
				location_heretics = [];
				tech = techs[i];
				if (tech.has_trait("tech_heretic")) {
					array_push(location_heretics, tech);
				} else {
					array_push(location_techs, tech);
				}
				//loop techs to fins out which techs are in the same  location
				for (t = i + 1; t < tech_count; t++) {
					check_tech = techs[t].marine_location();
					if (same_locations(tech.marine_location(), check_tech)) {
						if (techs[t].has_trait("tech_heretic")) {
							array_push(location_heretics, techs[t]);
							heretic_data[0] += techs[t].weapon_skill;
							heretic_data[1] += techs[t].wisdom;
							heretic_data[2] += techs[t].ballistic_skill;
						} else {
							array_push(location_techs, techs[t]);
							loyal_data[0] += techs[t].weapon_skill;
							loyal_data[1] += techs[t].wisdom;
							loyal_data[2] += techs[t].ballistic_skill;
						}
						array_push(delete_positions, t);
					}
				}
				if (array_length(location_heretics) > 0 && array_length(location_techs) > 0) {
					var purge_target = "none";
					if (press == 0) {
						var tal;
						var heretic_tally = 0;
						var loyal_tally = 0;
						for (tal = 0; tal < 3; tal++) {
							if (heretic_data[tal] > loyal_data[0]) {
								heretic_tally++;
							} else if (heretic_data[tal] < loyal_data[0]) {
								loyal_tally++;
							}
						}
						if (heretic_tally > loyal_tally) {
							purge_target = location_techs;
						} else if (loyal_tally < heretic_tally) {
							purge_target = location_heretics;
						}
						if (purge_target == "none") {
							purge_target = choose(location_heretics, location_techs);
						}
					} else if (press == 1) {
						purge_target = location_techs;
					} else if (press == 2) {
						purge_target = location_heretics;
					}
					if (purge_target != "none") {
						for (tal = 0; tal < array_length(purge_target); tal++) {
							kill_and_recover(purge_target[tal].company, purge_target[tal].marine_number);
						}
					}
				}
				if (array_length(delete_positions) > 0) {
					for (t = 0; t < array_length(delete_positions); t++) {
						array_delete(techs, delete_positions[t], 1);
						tech_count--;
					}
				}
			}
			if (press == 0) {
				text = "With neither faction receiving your favor it is not long until the BloodLetting begins. Within a month a brutal civil war engulfs the Tech ranks with losses suffered on both sides";
			} else if (press == 1) {
				text = "With your full support the so called 'heretics' who have seen through the lies of the bureaucracy of Mars eliminate those who will not be swayed to see the truth.";
				obj_controller.tech_status = "heretics";
			} else if (press == 2) {
				text = "The extremists and heretics that have been allowed to grow like a cancer in the Armentarium are rooted out and disposed of.";
			}
			reset_popup_options();
			press = 0;
			pathway = "end_splash";
		}
	}
	if (pathway == "end_splash") {
		if (!array_length(options)){
			add_option(["Continue"]);
		}
		if (press == 0) {
			obj_controller.complex_event = false;
			if (instance_exists(obj_turn_end)) {
				if (number != 0) {
					obj_turn_end.alarm[1] = 4;
				}
				instance_destroy();
			}
			instance_destroy();
		}
	}
} catch (_exception) {
	handle_exception(_exception);
    instance_destroy();
}
