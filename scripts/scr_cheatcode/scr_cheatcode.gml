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
						scr_add_artifact("random", "", 6, obj_ini.ship_data[0].name, 501);
					} else {
						repeat(real(cheat_arguments[1])){
							scr_add_artifact(cheat_arguments[0], "", 6, obj_ini.ship_data[0].name, 501);
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
				case "waaagh":

					init_ork_waagh(true);
					break;
				case "neworkfleet":
					var p_fleet = get_largest_player_fleet();
					with (instance_nearest(p_fleet.x, p_fleet.y, obj_star)) {
						new_ork_fleet(x, y);
					}
					break;
				case "inquisarti":
					scr_quest(0, "artifact_loan", 4, 10);
					var last_artifact = scr_add_artifact("good", "inquisition", 0, obj_ini.ship_data[0].name, 501);
					break;
				case "govmission":
					var problem = "";
					if (array_length(cheat_arguments)){
						if (cheat_arguments[0] != "1"){
							problem = cheat_arguments[0]
						}
					} 
					with (obj_star) {
						for (var i = 1; i <= planets; i++) {
							var existing_problem = false; //has_any_problem_planet(i);
							if (!existing_problem) {
								if (p_owner[i] == eFACTION.Imperium) {
									show_debug_message("mission");
									scr_new_governor_mission(i, problem);
								}
							}
						}
					}
					break;

				case "mechmission":
					show_debug_message("mech_mission");

					if (array_length(cheat_arguments)){
						spawn_mechanicus_mission(cheat_arguments[0]);
					} else {
						spawn_mechanicus_mission();
					}
         		 break;

				case "inquismission": 
					var mission = cheat_arguments[0];
					show_debug_message($"{mission},");
					switch (mission){
						case "1": //default 
							scr_inquisition_mission(EVENT.inquisition_mission);
						break;
						case "planet":
							scr_inquisition_mission(EVENT.inquisition_planet);
						break;
						case "spyrer": 
							scr_inquisition_mission(EVENT.inquisition_mission, INQUISITION_MISSION.spyrer);
						break;
						case "artifact": 
							scr_inquisition_mission(EVENT.inquisition_mission, INQUISITION_MISSION.artifact);
						break;
						case "inquisitor": 
							scr_inquisition_mission(EVENT.inquisition_mission, INQUISITION_MISSION.inquisitor);
						break;
						case "purge": 
							scr_inquisition_mission(EVENT.inquisition_mission, INQUISITION_MISSION.purge);
						break;
						case "tomb_world": 
							scr_inquisition_mission(EVENT.inquisition_mission, INQUISITION_MISSION.tomb_world);
						break;
						case "tyranid_organism": 
							scr_inquisition_mission(EVENT.inquisition_mission, INQUISITION_MISSION.tyranid_organism);
						break;
						case "demon": 
							scr_inquisition_mission(EVENT.inquisition_mission, INQUISITION_MISSION.demon_world);
						break;
						default: 
							scr_inquisition_mission(EVENT.inquisition_mission);
						break;
					}
					show_debug_message("inquisitor mission initiated");
					obj_controller.location_viewer.update_mission_log();
					break;
				case "artifactpopulate":
					with (obj_star) {
						for (var i = 1; i <= planets; i++) {
							array_push(p_feature[i], new PlanetFeature(P_features.Artifact));
						}
					}
					break;
				case "ruinspopulate":
					with (obj_star) {
						for (var i = 1; i <= planets; i++) {
							array_push(p_feature[i], new PlanetFeature(P_features.AncientRuins));
						}
					}
					break;		
				case "stcpopulate":
					with (obj_star) {
						for (var i = 1; i <= planets; i++) {
							array_push(p_feature[i], new NewPlanetFeature(P_features.STCFragment));
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
						tech_uprising_event();
					} else if (cheat_arguments[0] == "inspection") {
						new_inquisitor_inspection();
					} else if (cheat_arguments[0] == "slaughtersong") {
						create_starship_event();
					} else if (cheat_arguments[0] == "fallen"){
						event_fallen();
					}else if (cheat_arguments[0] == "surfremove"){
						var _star_id = scr_random_find(0,true,"","");
			            add_event({
			                duration : 2,
			                e_id : "governor_assassination",
			                variant : 2,
			                system : _star_id.name,
			                planet : irandom_range(1, _star_id.planets),
			            });						
					} else if (cheat_arguments[0] == "strangebuild"){
						show_debug_message("strange build");
						strange_build_event();
					}else if (cheat_arguments[0] == "factionenemy"){
						make_faction_enemy_event();
					}else if (cheat_arguments[0] == "stopall"){
						obj_controller.last_event = 1000000;
						show_debug_message($"last event : {obj_controller.last_event}")
					}else if (cheat_arguments[0] == "startevents"){
						obj_controller.last_event = 0;
						show_debug_message($"last event : {obj_controller.last_event}")
					}else {
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
				case "gloriana":
					var _fleet = get_nearest_player_fleet(0,0);
					add_ship_to_fleet(new_player_ship("Gloriana"),_fleet);
					break;
        		case "nidinvasion":
		            with (obj_star){
		                if (system_feature_bool(p_feature,P_features.GeneStealerCult)){
		                    summon_new_hive_fleet();
		                }
		            }
		            break;
				case "zoom":
					set_zoom_to_default();
					break;
				case "orkinvasion":
					out_of_system_warboss();
					break;
				case "forgemastermeet":
					var _forge_master = scr_role_count("Forge Master", "", "units");
					if (array_length(_forge_master)>0){
						show_debug_message("meet forge master");
						obj_controller.menu_lock = false;
						instance_destroy(obj_popup_dialogue);
						scr_toggle_diplomacy();
						obj_controller.diplomacy = -1;
						obj_controller.character_diplomacy = _forge_master[0];
						diplo_txt="Greetings chapter master";
					} else {
						show_debug_message("no forge master");
					}
					break;
			}
		}
	} catch(_exception) {
		show_debug_message(_exception.longMessage);
	}
}


/// @mixin obj_Star_Select
function draw_planet_debug_options(){
	try{
	add_draw_return_values();
	draw_set_halign(fa_left);
	draw_set_color(c_white);
	draw_set_alpha(1);
	if (debug) {
		debug_slate.inside_method = function(){
			debug_options.draw()
		    if (debug_options.current_selection == 0){
		    	draw_planet_debug_forces();
		    } else if (debug_options.current_selection == 1){
		    	draw_planet_debug_problems();
		    } else if (debug_options.current_selection == 2){
		    	draw_planet_debug_features();
		    }
		}
		debug_slate.draw()
	}
    if (debug_button.draw()){
        debug = !debug;
        //scroll_problems = new ScrollableContainer()
    }
    pop_draw_return_values();
	}catch(_exception){
		handle_exception(_exception);
	}
}

function draw_planet_debug_features(){
	static _addable_features = [
		{
			e_num : P_features.GeneStealerCult,
			name : "GeneStealer Cult"
		},
		{
			e_num : P_features.AncientRuins,
			name : "Ancient Ruins"
		},
		{
			e_num : P_features.Artifact,
			name : "Artefact"
		},
		{
			e_num : P_features.STCFragment,
			name : "STC Fragment"
		},
		{
			e_num : P_features.SororitasCathedral,
			name : "Sororitas Cathedral"
		},
		{
			e_num : P_features.OrkWarboss,
			name : "Ork Warboss"
		},
		{
			e_num : P_features.OrkStronghold,
			name : "Ork stronghold"
		},
		{
			e_num : P_features.Monastery,
			name : "Fortress Monastery"
		},
		{
			e_num : P_features.Starship,
			name : "Ancient Starship"
		},

	]

	var base_y = 220;
	base_y += 2;


	for (var i=0;i<array_length(_addable_features);i++){
		var _y = base_y + i * 20;
		var _feat = _addable_features[i];
		draw_text(38, _y, _feat.name);
		if (point_and_click([38, _y, 337,_y+20])){
			var _new_feat = new NewPlanetFeature(_feat.e_num);
			array_push(target.p_feature[obj_controller.selecting_planet], _new_feat);
		}
	}
}

function draw_planet_debug_problems(){
	var base_y = 220;
	var _keys = planet_problem_keys;
	base_y += 2;
	for (var i=0;i<array_length(_keys);i++){
		var _y = base_y + i * 20;
		draw_text(38, _y, _keys[i]);
		if (scr_hit(38, _y, 337,_y+20)){
			tooltip_draw(mission_name_key(_keys[i]));
			if (scr_click_left()){
				switch(_keys[i]){
					case "inquisitor":
						mission_inquistion_hunt_inquisitor(target.id);
						break;
					case "necron":
						mission_inquisition_tomb_world(target.id);
						break;
					case "mech_raider":
						spawn_mechanicus_mission("mech_raider");
						break;
					case "mech_mars":
						spawn_mechanicus_mission("mech_mars");
						break;
					case "mech_bionics":
						spawn_mechanicus_mission("mech_bionics");
						break;
																		
					default:
						scr_popup("error","no specific debug action created please consider helping to make one","");
						break;
				}
			}
		}
	}
}

function draw_planet_debug_forces(){
	add_draw_return_values();
    var current_planet = obj_controller.selecting_planet;
    var base_y = 220;
    // Close window if clicked outside
    if (!scr_hit([36,base_y,337,base_y+281]) && scr_click_left()) {
        debug = 0;
        exit;
    }

    // Define factions and their struct keys
    var faction_names = [
        "Orks", "Tau", "Tyranids", "Traitors",
        "CSM", "Daemons", "Necrons", "Sisters"
    ];
    var faction_keys = [
        "p_orks", "p_tau", "p_tyranids", "p_traitors",
        "p_chaos", "p_demons", "p_necrons", "p_sisters"
    ];

    // Loop through each faction row
    base_y += 2;
    for (var i = 0; i < array_length(faction_names); i++) {
        var _y = base_y + i * 20;
        var key = faction_keys[i];

        // Draw faction name and value
        draw_text(38, _y, faction_names[i] + ": " + string(target[$ key][current_planet]));

        // Draw [-] [+] controls
        draw_text(147, _y, "[-] [+]");

        // Handle minus click
        if (point_and_click([147, _y, 167, _y + 20])) {
            target[$ key][current_planet] = clamp(target[$key][current_planet] - 1, 0, 6);
        }
        // Handle plus click
        else if (point_and_click([177, _y, 197, _y + 20])) {
            target[$ key][current_planet] = clamp(target[$key][current_planet] + 1, 0, 6);
        }
    }
    pop_draw_return_values();
}


function new_system_debug_popup(){
    var pop = instance_create(0, 0, obj_popup)
    pop.image = "debug_banshee";
    pop.title = "DEBUG";
    pop.planet = 1;
    pop.star = instance_nearest(mouse_x, mouse_y,obj_star);
    pop.text = $"What would you like to do at {pop.star.name}?";

    pop.add_option(
    	[
    		{
    			str1 : "Enemy invasion",
    			choice_func : system_debug_enemy_invasion,
    		},
    		{
    			str1 : "Spawn Fleet",
    			choice_func : system_debug_spawn_fleet,
    		},
    		{
    			str1 : "Delete Fleet",
    			choice_func :system_debug_remove_fleet
    		}, 
    		{
    			str1 : "Cancel",
				choice_func : popup_default_close,
    		}
    	]
    );
}

function system_debug_enemy_invasion(){
	text = "Select a faction";
	replace_options([
		{
			str1: "Orks",
			choice_func : function(){
				invasion_faction = eFACTION.Ork;
				system_debug_enemy_invasion_spawn();
			}
		},
		{
			str1: "Chaos",
			choice_func : function(){
				invasion_faction = 9;
				system_debug_enemy_invasion_spawn();
			}
		},
		{
			str1: "Tyranids",
			choice_func : function(){
				invasion_faction = eFACTION.Tyranids;
				system_debug_enemy_invasion_spawn();
			}
		},
	]);
}


//TODO refactor and allow for greater range of factions
function system_debug_enemy_invasion_spawn(){
	if (invasion_faction != 9) {
		if (invasion_faction == 0) {
			amount = 7;
		}
		if (invasion_faction == 2) {
			amount = 9;
		}
		with (obj_star) {
			if ((choose(0, 1, 1) == 1) && (owner != eFACTION.Eldar) && (owner != 1)) {
				var fleet;
				fleet = instance_create(x, y, obj_en_fleet);
				fleet.owner = obj_popup.invasion_faction;
				if (obj_popup.invasion_faction == 7) {
					fleet.sprite_index = spr_fleet_ork;
					fleet.capital_number = 3;
					present_fleet[7] += 1;
				}
				if (obj_popup.invasion_faction == 9) {
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
	if (invasion_faction == 9) {
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



function system_debug_spawn_fleet() {
	text = "Imperium, Heretic, or Xeno?";
	replace_options([
		{
			str1: "Imperium",
			choice_func: debug_spawn_imperium_fleet,
		},
		{
			str1: "Heretic",
			choice_func: debug_spawn_heretic_fleet,
		},
		{
			str1: "Xeno",
			choice_func: debug_add_xenos_fleet_options,
		},
	]);
}

function debug_spawn_imperium_fleet() {
	var fleet = instance_create(star.x, star.y, obj_en_fleet);
	fleet.owner = eFACTION.Imperium;
	fleet.sprite_index = spr_fleet_imperial;
	fleet.capital_number = 2;
	fleet.frigate_number = 5;
	star.present_fleet[2] += 1;
	fleet.image_index = 4;
	fleet.orbiting = id;
	instance_destroy();
}

function debug_spawn_heretic_fleet() {
	var fleet = instance_create(star.x, star.y, obj_en_fleet);
	fleet.owner = eFACTION.Chaos;
	fleet.sprite_index = spr_fleet_chaos;
	fleet.capital_number = 2;
	fleet.frigate_number = 5;
	star.present_fleet[10] += 1;
	fleet.image_index = 4;
	fleet.orbiting = id;
	instance_destroy();
}


function debug_add_xenos_fleet_options() {
	text = "Select Xeno faction to spawn:";
	replace_options([
		{
			str1: "Ork",
			choice_func: debug_spawn_ork_fleet,
		},
		{
			str1: "Tau",
			choice_func: debug_spawn_tau_fleet,
		},
		{
			str1: "Cancel",
			choice_func: popup_default_close,
		},
	]);
}
function debug_spawn_ork_fleet() {
	var fleet = instance_create(star.x, star.y, obj_en_fleet);
	fleet.owner = eFACTION.Ork;
	fleet.sprite_index = spr_fleet_ork;
	fleet.capital_number = 2;
	fleet.frigate_number = 5;
	star.present_fleet[7] += 1;
	fleet.image_index = 4;
	fleet.orbiting = id;
	instance_destroy();
}

function debug_spawn_tau_fleet() {
	var fleet = instance_create(star.x, star.y, obj_en_fleet);
	fleet.owner = eFACTION.Tau;
	fleet.sprite_index = spr_fleet_tau;
	fleet.capital_number = 2;
	fleet.frigate_number = 5;
	star.present_fleet[8] += 1;
	fleet.image_index = 4;
	fleet.orbiting = id;
	instance_destroy();
}

function system_debug_remove_fleet(){
	var _opts = [];
	var _fleets = [];
	var _x = star.x;
	var _y = star.y;
	with(obj_en_fleet){
		if (_x == x && _y == y){
			array_push(_fleets, id);
		}
	}
	function DeleteFleetOption(fleet_id)constructor{
		str1 =  $"delete {obj_controller.faction[fleet_id.owner]} fleet {fleet_id.id}";
		self.fleet_id = fleet_id;
		static choice_func =  function(){
			show_debug_message($"destroy {current_option.fleet_id}")
			instance_destroy(current_option.fleet_id);
			popup_default_close();
		};
		static hover =  function(){
			draw_set_color(c_red);
			draw_circle(current_option.fleet_id.x,current_option.fleet_id.y, 20, true);
		}
	}

	for (var i=0;i<array_length(_fleets);i++){
		var _fleet = _fleets[i];

		var _opt = new DeleteFleetOption(_fleet);
		array_push(_opts,_opt)
	}
	array_push(_opts,{"str1" : "exit",choice_func:popup_default_close});

	replace_options(_opts,false,false);

	text = "Which fleet would you like to delete?";
}




