function scr_cheatcode(argument0) {
	try{
		if (argument0 == "") {
			return;
		}
		var input_string;
		var cheat_code;
		var cheat_arguments;
		var name;

		input_string = string_split(argument0, " ", 0, 1);
		cheat_code = string_lower(input_string[0]);
		
		if (array_length(input_string) > 1) {
			cheat_arguments = input_string[1];
			// Handle quotes and spaces for arguments
			if (string_count("\"", cheat_arguments) > 0) {
				// Split by quotes and trim spaces
				var temp_args = string_split(cheat_arguments, "\"", 1, 2);
				for (var i = 0; i < array_length(temp_args); i++) {
					temp_args[i] = string_trim(temp_args[i]);
				}
				name = temp_args[0];
				if (array_length(temp_args) > 1) {
					cheat_arguments = string_split(temp_args[1], " ", 1);
				} else {
					cheat_arguments = [];
				}
			} else {
				cheat_arguments = string_split(cheat_arguments, " ", 1);
			}
		} else {
			cheat_arguments = [];
		}
		
		// Default values for cheat_arguments
		while(array_length(cheat_arguments) < 3) {
			array_push(cheat_arguments, "1");
		}
		
		if (cheat_code!= "") {
			switch (cheat_code) {
				case "finishforge":
					with (obj_controller) {
						forge_points = 1000000;
						forge_queue_logic();
					}
					break;
				case "newapoth":
					obj_controller.apothecary_training_points = 50;
					break;
				case "newpsyk":
					obj_controller.psyker_points = 70;
					break;
				case "newtech":
					obj_controller.tech_points = 400;
					break;
				case "newchap":
					obj_controller.chaplain_points = 50;
					break;
				case "additem":
					var quantity = (array_length(cheat_arguments) > 0) ? real(cheat_arguments[0]) : 1;
					var quality = (array_length(cheat_arguments) > 1) ? string_lower(cheat_arguments[1]) : "normal";
					scr_add_item(name, quantity, quality);
					break;
				case "artifact":
					if (cheat_arguments[0] == "1") {
						scr_add_artifact("random", "", 6, obj_ini.ship[0], 501);
					} else {
						repeat(real(cheat_arguments[1])){
							scr_add_artifact(cheat_arguments[0], "", 6, obj_ini.ship[0], 501);
						}
					}
					break;
				case "sisterhospitaler":
					repeat(real(cheat_arguments[0])){
						scr_add_man("Sister Hospitaler", 0, "", "", 0, true, "default");
					}
					break;
				case "sisterofbattle":
					repeat(real(cheat_arguments[0])){
						scr_add_man("Sister of Battle", 0, "", "", 0, true, "default");
					}
					break;
				case "skitarii":
					repeat(real(cheat_arguments[0])){
						scr_add_man("Skitarii", 0, "", "", 0, true, "default");
					}
					break;
				case "techpriest":
					repeat(real(cheat_arguments[0])){
						scr_add_man("Techpriest", 0, "", "", 0, true, "default");
					}
					break;
				case "crusader":
					repeat(real(cheat_arguments[0])){
						scr_add_man("Crusader", 0, "", "", 0, true, "default");
					}
					break;
				case "flashgit":
					repeat(real(cheat_arguments[0])){
						scr_add_man("Flash Git", 0, "", "", 0, true, "default");
					}
					break;
				case "chaosfleetspawn":
					spawn_chaos_warlord();
					break;
				case "neworkfleet":
					var p_fleet = get_largest_player_fleet();
					with (instance_nearest(p_fleet.x, p_fleet.y, obj_star)) {
						new_ork_fleet(x, y);
					}
					break;
				case "inquisarti":
					scr_quest(0, "artifact_loan", 4, 10);
					var last_artifact = scr_add_artifact("good", "inquisition", 0, obj_ini.ship[0], 501);
					break;
				case "govmission":
					with (obj_star) {
						for (var i = 1; i <= planets; i++) {
							var existing_problem = false; //has_any_problem_planet(i);
							if (!existing_problem) {
								if (p_owner[i] == eFACTION.Imperium) {
									show_debug_message("mission");
									scr_new_governor_mission(i);
								}
							}
						}
					}
					break;
				case "artifactpopulate":
					with (obj_star) {
						for (var i = 1; i <= planets; i++) {
							array_push(p_feature[i], new NewPlanetFeature(P_features.Artifact));
						}
					}
					break;
				case "ruinspopulate":
					with (obj_star) {
						for (var i = 1; i <= planets; i++) {
							array_push(p_feature[i], new NewPlanetFeature(P_features.Ancient_Ruins));
						}
					}
					break;					
				case "event":
					if (cheat_arguments[0] == "crusade") {
						show_debug_message("crusading");
						with (obj_controller) {
							launch_crusade();
						}
					} else if (cheat_arguments[0] == "tomb") {
						show_debug_message("necron_tomb_awaken");
						with (obj_controller) {
							awaken_tomb_event();
						}
					} else if (cheat_arguments[0] == "techuprising") {
						var pip = instance_create(0, 0, obj_popup);
						pip.title = "Technical Differences!";
						pip.text = "You Recive an Urgent Transmision A serious breakdown in culture has coccured causing believers in tech heresy to demand that they are given preseidence and assurance to continue their practises";
						pip.image = "tech_uprising";
					} else if (cheat_arguments[0] == "inspection") {
						new_inquisitor_inspection();
					} else if (cheat_arguments[0] == "slaughtersong") {
						create_starship_event();
					} else {
						with (obj_controller) {
							scr_random_event(false);
						}
					}
					break;
				case "infreq":
					if (global.cheat_req == 0) {
						global.cheat_req = 1;
						cheatyface = 1;
						obj_controller.tempRequisition = obj_controller.requisition;
						obj_controller.requisition = 51234;
					} else {
						global.cheat_req = 0;
						cheatyface = 1;
						obj_controller.requisition = obj_controller.tempRequisition;
					}
					break;
				case "infseed":
					if (global.cheat_gene == 0) {
						global.cheat_gene = 1;
						cheatyface = 1;
						obj_controller.tempGene_seed = obj_controller.gene_seed;
						obj_controller.gene_seed = 9999;
					} else {
						global.cheat_gene = 0;
						cheatyface = 1;
						obj_controller.gene_seed = obj_controller.tempGene_seed;
					}
					break;
				case "debug":
					if (global.cheat_debug == 0) {
						global.cheat_debug = 1;
						cheatyface = 1;
					} else {
						global.cheat_debug = 0;
						cheatyface = 1;
					}
					break;
				case "test":
					cheatyface = 1;
					diplomacy = 10.5;
					scr_dialogue("test");
					break;
				case "req": 
					if (global.cheat_req == 0) {
						cheatyface = 1;
						obj_controller.requisition = real(cheat_arguments[0]);
					}
					break;
				case "seed":
					if (global.cheat_gene == 0) {
						cheatyface = 1;
						obj_controller.gene_seed = real(cheat_arguments[0]);
					}
					break;
				case "depimp":
					obj_controller.disposition[2] = real(cheat_arguments[0]);
					break;
				case "depmec":
					obj_controller.disposition[3] = real(cheat_arguments[0]);
					break;
				case "depinq":
					obj_controller.disposition[4] = real(cheat_arguments[0]);
					break;
				case "depecc":
					obj_controller.disposition[5] = real(cheat_arguments[0]);
					break;
				case "depeld":
					obj_controller.disposition[6] = real(cheat_arguments[0]);
					break;
				case "depork":
					obj_controller.disposition[7] = real(cheat_arguments[0]);
					break;
				case "deptau":
					obj_controller.disposition[8] = real(cheat_arguments[0]);
					break;
				case "deptyr":
					obj_controller.disposition[9] = real(cheat_arguments[0]);
					break;
				case "depcha":
					obj_controller.disposition[10] = real(cheat_arguments[0]);
					break;
				case "depall":
					global.cheat_disp = 1;
					cheatyface = 1;
					for (var i = 2; i <= 10; i++) {
						obj_controller.disposition[i] = real(cheat_arguments[0]);
					}
					break;
				case "stc":
					repeat(cheat_arguments[0]){
						scr_add_stc_fragment();
					}
					break;
				case "recruit":
					var _start_pos = 0
					var length = (array_length(obj_controller.recruit_name) - 1)
					var i = 0;
					while (i < length) {
						if (obj_controller.recruit_name[i] == "") {
							_start_pos = i
							break
						} else {
							i++
							continue
						}
					}
					for (i = _start_pos; i < (real(cheat_arguments[0]) + _start_pos); i++) {
						array_insert(obj_controller.recruit_corruption, i, 0);
						array_insert(obj_controller.recruit_distance, i, 0);
						array_insert(obj_controller.recruit_training, i, 1);
						array_insert(obj_controller.recruit_exp, i, 20);
						array_insert(obj_controller.recruit_data, i, {});
						array_insert(obj_controller.recruit_name, i, global.name_generator.generate_space_marine_name());
						scr_alert("green", "recruitment", (string(obj_controller.recruit_name[i]) + "has started training."), 0, 0)
					}
					break;
				case "shiplostevent":
					loose_ship_to_warp_event();
					break;
				case "recoverlostship":
					return_lost_ship();
					break;

			}
		}
	} catch(_exception) {
		show_debug_message(_exception.longMessage);
	}
}