enum eROLE {
	None = 0,
	ChapterMaster = 1,
	HonourGuard = 2,
	Veteran = 3,
	Terminator = 4,
	Captain = 5,
	Dreadnought = 6,
	Champion = 7,
	Tactical = 8,
	Devastator = 9,
	Assault = 10,
	Ancient = 11,
	Scout = 12,
	Chaplain = 14,
	Apothecary = 15,
	Techmarine = 16,
	Librarian = 17,
	Sergeant = 18,
	VeteranSergeant = 19,
	LandRaider = 50,
    Rhino = 51,
    Predator = 52,
    LandSpeeder = 53,
    Whirlwind = 54
}

enum ePROGENITOR {
    NONE,
    DARK_ANGELS,
    WHITE_SCARS,
    SPACE_WOLVES,
    IMPERIAL_FISTS,
    BLOOD_ANGELS,
    IRON_HANDS,
    ULTRAMARINES,
    SALAMANDERS,
    RAVEN_GUARD,
    RANDOM,
}

enum eCHAPTER_TYPE {
    PREMADE,
	RANDOM,
    CUSTOM,
}

function progenitor_map(){
    var founding_chapters = [
        "",
        "Dark Angels",
        "White Scars",
        "Space Wolves",
        "Imperial Fists",
        "Blood Angels",
        "Iron Hands",
        "Ultramarines",
        "Salamanders",
        "Raven Guard",
    ]

    for (var i=1; i<10; i++){
        if (global.chapter_name == founding_chapters[i] || obj_ini.progenitor==i){
            return i;
        }
    }

    return 0;
}

function complex_livery_default() {
	return {
		sgt : {
			helm_pattern:3,
			helm_primary : 0,
			helm_secondary : 0,
			helm_detail : 0,
			helm_lens : 0,
		},
		vet_sgt : {
			helm_pattern:3,
			helm_primary : 0,
			helm_secondary : 0,
			helm_detail : 0,
			helm_lens : 0,
		},
		captain : {
			helm_pattern:3,
			helm_primary : 0,
			helm_secondary : 0,
			helm_detail : 0,
			helm_lens : 0,
		},
		veteran : {
			helm_pattern:3,
			helm_primary : 0,
			helm_secondary : 0,
			helm_detail : 0,
			helm_lens : 0,
		}
	};
}

function select_livery_data(livery_data, specific) {
    // Return specific livery data if requested
    if (specific == "none") {
        return livery_data;
    } else {
        return livery_data[$ specific];
    }
}

function helmet_livery(progenitor, specific = "none") {
    var livery_data;

	if ((obj_creation.custom == eCHAPTER_TYPE.PREMADE) && (global.chapter_creation_object.origin == 1)) {
		progenitor = progenitor_map();
	}

    var name_selected = true;
    switch (global.chapter_name) {
        case "Blood Ravens":
            livery_data = {
                sgt: {
                    helm_pattern: 0,
                    helm_primary: Colors.Black,
                    helm_secondary: Colors.Black,
                    helm_detail: Colors.Black,
                    helm_lens: Colors.Lime,
                },
                vet_sgt: {
                    helm_pattern: 1,
                    helm_primary: Colors.Black,
                    helm_secondary: Colors.White,
                    helm_detail: Colors.Black,
                    helm_lens: Colors.Lime,
                },
                captain: {
                    helm_pattern: 0,
                    helm_primary: Colors.Copper,
                    helm_secondary: Colors.Copper,
                    helm_detail: Colors.Copper,
                    helm_lens: Colors.Lime,
                },
                veteran: {
                    helm_pattern: 0,
                    helm_primary: Colors.White,
                    helm_secondary: Colors.White,
                    helm_detail: Colors.White,
                    helm_lens: Colors.Lime,
                },
            };
            break;

        case "Minotaurs":
            livery_data = {
                sgt: {
                    helm_pattern: 0,
                    helm_primary: Colors.Black,
                    helm_secondary: Colors.Black,
                    helm_detail: Colors.Black,
                    helm_lens: Colors.Red,
                },
                vet_sgt: {
                    helm_pattern: 1,
                    helm_primary: obj_creation.main_color,
                    helm_secondary: Colors.Black,
                    helm_detail: obj_creation.main_color,
                    helm_lens: Colors.Red,
                },
                captain: {
                    helm_pattern: 2,
                    helm_primary: obj_creation.main_color,
                    helm_secondary: Colors.Dark_Red,
                    helm_detail: obj_creation.main_color,
                    helm_lens: Colors.Red,
                },
                veteran: {
                    helm_pattern: 0,
                    helm_primary: obj_creation.main_color,
                    helm_secondary: obj_creation.main_color,
                    helm_detail: obj_creation.main_color,
                    helm_lens: Colors.Red,
                },
            };
            break;
		case "Lamenters":
			livery_data = {
				sgt : {
					helm_pattern:1,
					helm_primary : obj_creation.main_color,
					helm_secondary : Colors.Black,
					helm_detail : obj_creation.main_trim,
					helm_lens : obj_creation.lens_color,
				},
				vet_sgt : {
					helm_pattern:1,
					helm_primary : obj_creation.main_color,
					helm_secondary : Colors.Black,
					helm_detail : obj_creation.main_trim,
					helm_lens : obj_creation.lens_color,
				},
				captain : {
					helm_pattern:0,
					helm_primary : Colors.White,
					helm_secondary : Colors.White,
					helm_detail : obj_creation.main_trim,
					helm_lens : obj_creation.lens_color,
				},
				veteran : {
					helm_pattern:2,
					helm_primary : obj_creation.main_color,
					helm_secondary : Colors.Black,
					helm_detail : obj_creation.main_trim,
					helm_lens : obj_creation.lens_color,	
				}				
			}
			break;
			case "Tome Keepers":
				livery_data = {
					sgt : {
						helm_pattern:0,
						helm_primary : Colors.Sanguine_Red,
						helm_secondary : obj_creation.secondary_color,
						helm_detail : obj_creation.main_trim,
						helm_lens : Colors.Lime,
					},
					vet_sgt : {
						helm_pattern:2,
						helm_primary : Colors.Sanguine_Red,
						helm_secondary : Colors.Lighter_Black,
						helm_detail : obj_creation.main_trim,
						helm_lens : Colors.Lime,
					},
					captain : {
						helm_pattern:0,
						helm_primary : obj_creation.main_color,
						helm_secondary : obj_creation.secondary_color,
						helm_detail : obj_creation.main_trim,
						helm_lens : obj_creation.lens_color,
					},
					veteran : {
						helm_pattern:2,
						helm_primary : obj_creation.main_color,
						helm_secondary : Colors.Lighter_Black,
						helm_detail : obj_creation.main_trim,
						helm_lens : obj_creation.lens_color,	
					}				
				}
				break;
        default:
            name_selected = false;
            break;
    }

    if (name_selected) {
        return select_livery_data(livery_data, specific);
    }

    switch (progenitor) {
        case ePROGENITOR.SPACE_WOLVES:
            livery_data = {
                sgt: {
                    helm_pattern: 3,
                    helm_primary: Colors.Fenrisian_Grey,
                    helm_secondary: Colors.Red,
                    helm_detail: 0,
                    helm_lens: Colors.Red,
                },
                vet_sgt: {
                    helm_pattern: 3,
                    helm_primary: Colors.Fenrisian_Grey,
                    helm_secondary: Colors.Black,
                    helm_detail: 0,
                    helm_lens: Colors.Red,
                },
                captain: {
                    helm_pattern: 3,
                    helm_primary: Colors.Fenrisian_Grey,
                    helm_secondary: Colors.Black,
                    helm_detail: 0,
                    helm_lens: Colors.Red,
                },
                veteran: {
                    helm_pattern: 0,
                    helm_primary: Colors.White,
                    helm_secondary: Colors.White,
                    helm_detail: Colors.White,
                    helm_lens: Colors.Red,
                },
            };
            break;

        case ePROGENITOR.DARK_ANGELS:
            livery_data = {
                sgt: {
                    helm_pattern: 0,
                    helm_primary: obj_creation.main_color,
                    helm_secondary: obj_creation.main_color,
                    helm_detail: obj_creation.main_trim,
                    helm_lens: obj_creation.lens_color,
                },
                vet_sgt: {
                    helm_pattern: 1,
                    helm_primary: obj_creation.main_color,
                    helm_secondary: obj_creation.main_color,
                    helm_detail: obj_creation.main_trim,
                    helm_lens: obj_creation.lens_color,
                },
                captain: {
                    helm_pattern: 0,
                    helm_primary: obj_creation.main_color,
                    helm_secondary: obj_creation.main_color,
                    helm_detail: obj_creation.main_trim,
                    helm_lens: obj_creation.lens_color,
                },
                veteran: {
                    helm_pattern: 0,
                    helm_primary: obj_creation.main_color,
                    helm_secondary: obj_creation.main_color,
                    helm_detail: obj_creation.main_trim,
                    helm_lens: obj_creation.lens_color,
                },
            };
            break;

        case ePROGENITOR.RAVEN_GUARD:
            livery_data = {
                sgt: {
                    helm_pattern: 0,
                    helm_primary: Colors.White,
                    helm_secondary: Colors.White,
                    helm_detail: 0,
                    helm_lens: Colors.Red,
                },
                vet_sgt: {
                    helm_pattern: 1,
                    helm_primary: Colors.Black,
                    helm_secondary: Colors.White,
                    helm_detail: 0,
                    helm_lens: Colors.Red,
                },
                captain: {
                    helm_pattern: 0,
                    helm_primary: Colors.White,
                    helm_secondary: Colors.White,
                    helm_detail: 0,
                    helm_lens: Colors.Red,
                },
                veteran: {
                    helm_pattern: 0,
                    helm_primary: Colors.Black,
                    helm_secondary: Colors.Black,
                    helm_detail: Colors.Black,
                    helm_lens: Colors.Green,
                },
            };
            break;

        case ePROGENITOR.SALAMANDERS:
            livery_data = {
                sgt: {
                    helm_pattern: 0,
                    helm_primary: Colors.Black,
                    helm_secondary: Colors.Black,
                    helm_detail: 0,
                    helm_lens: Colors.Red,
                },
                vet_sgt: {
                    helm_pattern: 1,
                    helm_primary: Colors.Black,
                    helm_secondary: Colors.Red,
                    helm_detail: 0,
                    helm_lens: Colors.Red,
                },
                captain: {
                    helm_pattern: 0,
                    helm_primary: Colors.Firedrake_Green,
                    helm_secondary: Colors.Firedrake_Green,
                    helm_detail: 0,
                    helm_lens: Colors.Red,
                },
                veteran: {
                    helm_pattern: 0,
                    helm_primary: Colors.Black,
                    helm_secondary: Colors.Black,
                    helm_detail: Colors.Black,
                    helm_lens: Colors.Green,
                },
            };
            break;

        case ePROGENITOR.WHITE_SCARS:
            livery_data = {
                sgt: {
                    helm_pattern: 0,
                    helm_primary: Colors.White,
                    helm_secondary: Colors.White,
                    helm_detail: 0,
                    helm_lens: Colors.Red,
                },
                vet_sgt: {
                    helm_pattern: 1,
                    helm_primary: Colors.White,
                    helm_secondary: Colors.Red,
                    helm_detail: 0,
                    helm_lens: Colors.Red,
                },
                captain: {
                    helm_pattern: 0,
                    helm_primary: Colors.White,
                    helm_secondary: Colors.White,
                    helm_detail: 0,
                    helm_lens: Colors.Red,
                },
                veteran: {
                    helm_pattern: 0,
                    helm_primary: Colors.White,
                    helm_secondary: Colors.White,
                    helm_detail: Colors.White,
                    helm_lens: Colors.Green,
                },
            };
            break;

        case ePROGENITOR.IRON_HANDS:
            livery_data = {
                sgt: {
                    helm_pattern: 0,
                    helm_primary: Colors.White,
                    helm_secondary: Colors.White,
                    helm_detail: 0,
                    helm_lens: Colors.Red,
                },
                vet_sgt: {
                    helm_pattern: 1,
                    helm_primary: Colors.Black,
                    helm_secondary: Colors.White,
                    helm_detail: 0,
                    helm_lens: Colors.Red,
                },
                captain: {
                    helm_pattern: 0,
                    helm_primary: Colors.White,
                    helm_secondary: Colors.White,
                    helm_detail: 0,
                    helm_lens: Colors.Red,
                },
                veteran: {
                    helm_pattern: 0,
                    helm_primary: Colors.Black,
                    helm_secondary: Colors.Black,
                    helm_detail: Colors.Black,
                    helm_lens: Colors.Green,
                },
            };
            break;

        case ePROGENITOR.ULTRAMARINES:
            livery_data = {
                sgt: {
                    helm_pattern: 0,
                    helm_primary: Colors.Red,
                    helm_secondary: Colors.Red,
                    helm_detail: Colors.Red,
                    helm_lens: Colors.Lime,
                },
                vet_sgt: {
                    helm_pattern: 1,
                    helm_primary: Colors.Red,
                    helm_secondary: Colors.White,
                    helm_detail: Colors.Red,
                    helm_lens: Colors.Lime,
                },
                captain: {
                    helm_pattern: 0,
                    helm_primary: obj_creation.main_color,
                    helm_secondary: obj_creation.secondary_color,
                    helm_detail: obj_creation.main_trim,
                    helm_lens: obj_creation.lens_color,
                },
                veteran: {
                    helm_pattern: 0,
                    helm_primary: Colors.White,
                    helm_secondary: Colors.White,
                    helm_detail: Colors.White,
                    helm_lens: Colors.Red,
                },
            };
            break;

        case ePROGENITOR.IMPERIAL_FISTS:
            livery_data = {
                sgt: {
                    helm_pattern: 0,
                    helm_primary: Colors.Black,
                    helm_secondary: Colors.Black,
                    helm_detail: Colors.Red,
                    helm_lens: Colors.Green,
                },
                vet_sgt: {
                    helm_pattern: 1,
                    helm_primary: Colors.Black,
                    helm_secondary: Colors.White,
                    helm_detail: Colors.Red,
                    helm_lens: Colors.Green,
                },
                captain: {
                    helm_pattern: 0,
                    helm_primary: Colors.Dark_Gold,
                    helm_secondary: Colors.Dark_Gold,
                    helm_detail: Colors.Dark_Gold,
                    helm_lens: Colors.Red,
                },
                veteran: {
                    helm_pattern: 0,
                    helm_primary: Colors.Red,
                    helm_secondary: Colors.Red,
                    helm_detail: Colors.Red,
                    helm_lens: Colors.Green,
                },
            };
            break;

        case ePROGENITOR.BLOOD_ANGELS:
            livery_data = {
                sgt: {
					helm_pattern: 0,
					helm_primary: obj_creation.main_color,
					helm_secondary: obj_creation.secondary_color,
					helm_detail: Colors.Gold,
					helm_lens: obj_creation.lens_color,
                },
                vet_sgt: {
					helm_pattern: 0,
					helm_primary: Colors.Gold,
					helm_secondary: obj_creation.secondary_color,
					helm_detail: obj_creation.main_trim,
					helm_lens: obj_creation.lens_color,
                },
                captain: {
					helm_pattern: 0,
					helm_primary: obj_creation.main_color,
					helm_secondary: obj_creation.secondary_color,
					helm_detail: Colors.Gold,
					helm_lens: obj_creation.lens_color,
                },
                veteran: {
					helm_pattern: 0,
					helm_primary: Colors.Gold,
					helm_secondary: obj_creation.secondary_color,
					helm_detail: obj_creation.main_trim,
					helm_lens: obj_creation.lens_color,
                },
            };
            break;

        default:
            // Not a named chapter or progenitor we have data for.
            // before this refactor, this was the true default, not complex_livery_default
            livery_data = {
                sgt: {
                    helm_pattern: 0,
                    helm_primary: Colors.Sanguine_Red,
                    helm_secondary: Colors.Sanguine_Red,
                    helm_detail: Colors.Sanguine_Red,
                    helm_lens: Colors.Lime,
                },
                vet_sgt: {
                    helm_pattern: 1,
                    helm_primary: Colors.Sanguine_Red,
                    helm_secondary: Colors.White,
                    helm_detail: Colors.Sanguine_Red,
                    helm_lens: Colors.Lime,
                },
                captain: {
                    helm_pattern: 0,
                    helm_primary: obj_creation.main_color,
                    helm_secondary: obj_creation.secondary_color,
                    helm_detail: obj_creation.main_trim,
                    helm_lens: obj_creation.lens_color,
                },
                veteran: {
                    helm_pattern: 0,
                    helm_primary: Colors.White,
                    helm_secondary: Colors.White,
                    helm_detail: Colors.White,
                    helm_lens: Colors.Red,
                },
            };
            break;
    }
    return select_livery_data(livery_data, specific);
}

function trial_map(trial_name){
	if(is_real(trial_name)){
		return trial_name;
	}
	switch(trial_name){
		case "BLOOD_DUEL":
		case "BLOODDUEL":
			return eTrials.BLOODDUEL;
		case "SURVIVAL":
			return eTrials.SURVIVAL;
		case "APPRENTICESHIP":
			return eTrials.APPRENTICESHIP;
		case "CHALLENGE":
			return eTrials.CHALLENGE;
		case "EXPOSURE":
			return eTrials.EXPOSURE;
		case "HUNTING":
			return eTrials.HUNTING;
		case "KNOWLEDGE":
			return eTrials.KNOWLEDGE;
		default: 
			return eTrials.BLOODDUEL;
	}
}

/// @mixin obj_ini
function scr_initialize_custom() {

	// show_debug_message("Executing scr_initialize_custom");
	
	progenitor = obj_creation.founding;
	successors = obj_creation.successors;
	homeworld_rule = obj_creation.homeworld_rule;

    homeworld_relative_loc = obj_creation.buttons.home_spawn_loc_options.current_selection;
    home_warp_position = obj_creation.buttons.home_warp.current_selection;
    home_planet_count = obj_creation.buttons.home_planets.current_selection;
    recruit_relative_loc = obj_creation.buttons.recruit_home_relationship.current_selection;
    culture_styles = obj_creation.buttons.culture_styles.selections();


	if(struct_exists(obj_creation, "custom_advisors")){
		obj_ini.custom_advisors = obj_creation.custom_advisors;
	}


	// Initializes all of the marine/vehicle/ship variables for the chapter.

	techmarines = 8;
	apothecary = 8;
	epistolary = 2;
	codiciery = 2;
	lexicanum = 4;
	terminator = 40;
	veteran = 70;
	second = 100;
	third = 100;
	fourth = 100;
	fifth = 100;
	sixth = 100;
	seventh = 100;
	eighth = 100;
	ninth = 100;
	tenth = 100;
	assault = 20;
	devastator = 20;
	siege = 0;
	
	recruit_trial = obj_creation.aspirant_trial;
	purity = obj_creation.purity;
	stability = obj_creation.stability;

	// show_message(instance_number(obj_controller));

	global.chapter_name = obj_creation.chapter_name;
	global.founding = obj_creation.founding;
	global.founding_secret = "";
	global.game_seed = floor(random(99999999)) + string_to_integer(global.chapter_name) + string_to_integer(obj_creation.chapter_master_name);


    if (progenitor == ePROGENITOR.RANDOM) {
        global.founding_secret = array_random_element([
            "Dark Angels",
            "Emperor's Children",
            "Iron Warriors",
            "White Scars",
            "Space Wolves",
            "Imperial Fists",
            "Night Lords",
            "Blood Angels",
            "Iron Hands",
            "World Eaters",
            "Ultramarines",
            "Death Guard",
            "Thousand Sons",
            "Black Legion",
            "Word Bearers",
            "Salamanders",
            "Raven Guard",
            "Alpha Legion"
        ]);
    }


	company_title = [
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
	]
	if(struct_exists(obj_creation, "company_title")){
		for(var ct = 0; ct < array_length(obj_creation.company_title); ct++){
			company_title[ct] = obj_creation.company_title[ct];
		}
	}




	home_name = obj_creation.homeworld_name;
	obj_creation.restart_home_name = home_name;
	chapter_name = obj_creation.chapter_name;
	// fortress_name="";
	flagship_name = obj_creation.flagship_name;
	obj_creation.restart_flagship_name = flagship_name;
	sector_name = global.name_generator.generate_sector_name();
	man_size = 0;
	psy_powers = obj_creation.discipline;

	progenitor_disposition = obj_creation.disposition[1];
	astartes_disposition = obj_creation.disposition[6];
	imperium_disposition = obj_creation.disposition[2];
	guard_disposition = obj_creation.disposition[2];
	inquisition_disposition = obj_creation.disposition[4];
	ecclesiarchy_disposition = obj_creation.disposition[5];
	mechanicus_disposition = obj_creation.disposition[3];
	other1_disposition = 0;
	other1 = "";

	preomnor = obj_creation.preomnor;
	voice = obj_creation.voice;
	doomed = obj_creation.doomed;
	lyman = obj_creation.lyman;
	omophagea = obj_creation.omophagea;
	ossmodula = obj_creation.ossmodula;
	membrane = obj_creation.membrane;
	zygote = obj_creation.zygote;
	betchers = obj_creation.betchers;
	catalepsean = obj_creation.catalepsean;
	secretions = obj_creation.secretions;
	occulobe = obj_creation.occulobe;
	mucranoid = obj_creation.mucranoid;


	
	adv = obj_creation.adv;
	dis = obj_creation.dis;



	recruiting_type = obj_creation.recruiting;
	recruit_trial = obj_creation.aspirant_trial;
	recruiting_name = obj_creation.recruiting_name;
	home_type = obj_creation.homeworld;
	home_name = obj_creation.homeworld_name;
	fleet_type = obj_creation.fleet_type;


	#region Ship Setup
	battle_barges = 0;
	strike_cruisers = 0;
	gladius = 0;
	hunters = 0;

	if (obj_creation.fleet_type == ePlayerBase.home_world) {
		strike_cruisers = 8;
		gladius = 7;
		hunters = 3;
	} else {
		battle_barges = 1;
		strike_cruisers = 6;
		gladius = 7;
		hunters = 3;
	}

	/**
	* * Default fleet composition
	* * Homeworld 
	* - 2 Battle Barges, 8 Strike cruisers, 7 Gladius, 3 Hunters
	* * Fleet based and Penitent 
	* - 4 Battle Barges, 3 Strike Cruisers, 7 Gladius, 3 Hunters
	*/
	if (obj_creation.custom == eCHAPTER_TYPE.PREMADE) {
		flagship_name = obj_creation.flagship_name;
		if (obj_creation.fleet_type == ePlayerBase.home_world) {
			battle_barges = 2;
			strike_cruisers = 8;
			gladius = 7;
			hunters = 3;
		} else {
			battle_barges = 4;
			strike_cruisers = 3;
			gladius = 7;
			hunters = 3;
		}
	}

	if (scr_has_adv ("Kings of Space")) {battle_barges += 1;}
	if (scr_has_adv("Boarders")){ strike_cruisers += 2;}
	if (scr_has_disadv("Obliterated")){ if (obj_creation.fleet_type == ePlayerBase.home_world) {
		battle_barges = 0;
		strike_cruisers = 2;
		gladius = 1;
		hunters = 0;
		} else {
		battle_barges = 1;
		strike_cruisers = 0;
		gladius = 2;
		hunters = 0;
		}
	}

	battle_barges = battle_barges + obj_creation.extra_ships.battle_barges;
	strike_cruisers = strike_cruisers + obj_creation.extra_ships.strike_cruisers;
	gladius = gladius + obj_creation.extra_ships.gladius;
	hunters = hunters + obj_creation.extra_ships.hunters;

	var ship_summary_str = $"Ships: bb: {battle_barges} sc: {strike_cruisers} g: {gladius} h: {hunters}"
	// log_message(ship_summary_str);
	// show_debug_message(ship_summary_str);

	if (battle_barges>=1){
	 	for (v=0;v<battle_barges;v++){
	 		var new_ship = new_player_ship("Battle Barge", "home");
		    if (flagship_name!="") and (v=0) then ship[new_ship]=flagship_name;
		}
	}

	for(var i=0;i<strike_cruisers;i++){
		new_player_ship("Strike Cruiser");
	}


	for(var i=0;i<gladius;i++){
		new_player_ship("Gladius");
	}

	for(var i=0;i<hunters;i++){
		new_player_ship("Hunter");
	}

	#endregion


	// :D :D :D
	master_tau = 0;
	master_battlesuits = 0;
	master_kroot = 0;
	master_tau_vehicles = 0;
	master_ork_boyz = 0;
	master_ork_nobz = 0;
	master_ork_warboss = 0;
	master_ork_vehicles = 0;
	master_heretics = 0;
	master_chaos_marines = 0;
	master_lesser_demons = 0;
	master_greater_demons = 0;
	master_chaos_vehicles = 0;
	master_gaunts = 0;
	master_warriors = 0;
	master_carnifex = 0;
	master_synapse = 0;
	master_tyrant = 0;
	master_gene = 0;
	master_avatar = 0;
	master_farseer = 0;
	master_autarch = 0;
	master_eldar = 0;
	master_aspect = 0;
	master_eldar_vehicles = 0;
	master_necron_overlord = 0;
	master_destroyer = 0;
	master_necron = 0;
	master_wraith = 0;
	master_necron_vehicles = 0;
	master_monolith = 0;
	master_special_killed = "";

	check_number = 5;
	year_fraction = 0; // 84 per turn
	if (obj_creation.chapter_year = 0) then year = 735;
	if (obj_creation.chapter_year != 0) then year = obj_creation.chapter_year;
	millenium = 41;

	#region Determine Total Number of Marines per Company and Role
	var company = 0;
	var second = 100,
		third = 100,
		fourth = 100,
		fifth = 100,
		sixth = 100,
		seventh = 100,
		eighth = 100,
		ninth = 100,
		tenth = 100;
	var siege = 0,
		temp1 = 0,
		intolerant = 0;
	var k, v;
	k = 0;
	v = 0;

	/* Default Specialists */
	var chaplains = 8,
		chaplains_per_company = 1,
	 	techmarines = 8,
		techmarines_per_company = 1,
		apothecary = 8,
		apothecary_per_company = 1,
		epistolary = 2,
		epistolary_per_company = 1,
		codiciery = 2,
		lexicanum = 4,
		terminator = 20,
		veteran = 85,
		assault = 20,
		devastator = 20,
		dreadnought = 1,
		rhino = 8,
		whirlwind = 4,
		landspeeder = 2,
		predator = 2,
		landraider = 6;


	/* Used for summing total count */
	specials = 0;
	firsts = 0;
	seconds = 0;
	thirds = 0;
	fourths = 0;
	fifths = 0;
	sixths = 0;
	sevenths = 0;
	eighths = 0;
	ninths = 0;
	tenths = 0;


	/*techs=20;epistolary=5;apothecary=6;codiciery=6;lexicanum=10;terminator=30;veteran=30;
	second=9;third=9;fourth=9;fifth=9;sixth=9;seventh=9;ei;
	ninth=9;tenth=10;
	assault=2;siege=0;devastator=2;*/

	var chapter_option, o; 
	if scr_has_adv("Lightning Warriors") {
		rhino -= 2;
		landspeeder += 2;
	}
	if scr_has_adv("Tech-Brothers") {
		techmarines += 5;
		tenth -= 5;
		predator += 2;
	}
	if scr_has_adv("Assault Doctrine") {
		assault += 10;
		devastator -= 10;
	}
	if scr_has_adv("Devastator Doctrine") {
		assault -= 10;
		devastator += 10;
	}
	if scr_has_adv("Siege Masters") {
		siege = 1;
	}
	if scr_has_adv("Crafters") {
		techmarines += 2;
		terminator += 5;
		tenth -= 5;
	}
	if scr_has_adv("Warp Touched") {
		tenth -= 5;
		epistolary += 1;
		codiciery += 2;
		lexicanum += 2;
	}
	if scr_has_disadv("Psyker Intolerant") {
		epistolary = 0;
		codiciery = 0;
		lexicanum = 0;
		epistolary_per_company = 0;
		veteran += 10;
		tenth += 10;
		intolerant = 1;
	}
	if scr_has_disadv("Fresh Blood") {
		epistolary -= 1;
		codiciery -= 1;
		lexicanum -= 2;
		tenth += 4;
	}
	if  scr_has_disadv("Sieged") {
		techmarines -= 4;
		epistolary -= 1;
		codiciery -= 1;
		lexicanum -= 2;
		apothecary -= 4;
		chaplains -= 4;
		terminator -= 10;
		veteran -= 50;
		second -= 30;
		third -= 30;
		fourth -= 30;
		fifth -= 60;
		sixth -= 60;
		seventh -= 60;
		eighth -= 70;
		ninth -= 70;
		tenth -= 70; // 370
		assault = 10;
		siege = 0;
		devastator = 10;
		dreadnought += 1;
	}
    if	scr_has_adv("Venerable Ancients") {
		veteran -= 10;
		second -= 10;
		third -= 10;
		fourth -= 10;
		fifth -= 10;
		sixth -= 10;
		seventh -= 10;
		eighth -= 10;
		ninth -= 10;
		tenth -= 10;
		dreadnought += 1;
	}
	if (obj_creation.equal_specialists < 2) and scr_has_disadv("Obliterated") {
		techmarines -= 7;
		epistolary -= 2;
		codiciery -= 1;
		lexicanum -= 4;
		apothecary -= 7;
		chaplains -= 7;
		terminator = 0;
		veteran = 0;
		second = 0;
		third = 0;
		fourth = 0;
		fifth = 0;
		sixth = 0;
		seventh = 0;
		eighth = 0;
		ninth = 0;
		tenth = 10; 
		assault = 0;
		devastator = 0;
		landraider = 0;
		landspeeder = 0;
		rhino = 0;
		whirlwind = 0;
		dreadnought = 0;

	}
	if  scr_has_disadv("Enduring Angels") {
		fifth = 0;
		sixth = 0;
		seventh = 0;
		eighth = 0;
		ninth = 0;
	}
	if  scr_has_disadv("Serpents Delight") {
		techmarines -= 5;
		epistolary -= 1;
		lexicanum -= 3;
		apothecary -= 5;
		chaplains -= 5;
		terminator = 0;
		veteran = 0;
		second = 0;
		third = 0;
		fourth = 0;
		tenth = 0;
	}
	if  scr_has_disadv ("Tech-Heresy") {
		techmarines -= 5;
		tenth += 5;
	}
	if  scr_has_disadv ("Small Apothecarion") {
		apothecary -= 5;
		tenth += 5;
	}
	if  scr_has_disadv ("Small Librarius") {
		epistolary -= 1;
		codiciery -= 1;
		lexicanum -= 2;
		tenth += 5;
	}
	if  scr_has_disadv ("Small Reclusiam") {
		chaplains -= 5;
		tenth += 5;
	}
	if scr_has_adv ("Reverent Guardians") {
		chaplains += 5;
		tenth -= 5;
	}
	if scr_has_adv("Medicae Primacy") {
		apothecary_per_company += 1;
		apothecary += 5;
	}

	if(global.chapter_name == "Lamenters"){
		predator = 0;
	}
	if(global.chapter_name == "Iron Hands"){
		predator += 1;
	}

	if (obj_creation.custom != eCHAPTER_TYPE.PREMADE) {
		if (obj_creation.strength <= 4) then ninth = 0;
		if (obj_creation.strength <= 3) then eighth = 0;
		if (obj_creation.strength <= 2) then seventh = 0;
		if (obj_creation.strength <= 1) then sixth = 0;

		var bonus_marines = 0;
		if (obj_creation.strength > 5) then bonus_marines = (obj_creation.strength - 5) * 50;
		if scr_has_disadv("Obliterated") then bonus_marines = (obj_creation.strength - 1) * 10;
		var i = 0;
		while (bonus_marines >= 5) {
			switch (i % 10) {
				case 0:
					if (veteran > 0) {
						bonus_marines -= 5;
						veteran += 5;
					}
					break;
				case 1:
					if (second > 0) {
						bonus_marines -= 5;
						second += 5;
					}
					break;
				case 2:
					if (third > 0) {
						bonus_marines -= 5;
						third += 5;
					}
					break;
				case 3:
					if (fourth > 0) {
						bonus_marines -= 5;
						fourth += 5;
					}
					break;
				case 4:
					if (fifth > 0) {
						bonus_marines -= 5;
						fifth += 5;
					}
					break;
				case 5:
					if (sixth > 0) {
						bonus_marines -= 5;
						sixth += 5;
					}
					break;
				case 6:
					if (seventh > 0) {
						bonus_marines -= 5;
						seventh += 5;
					}
					break;
				case 7:
					if (eighth > 0) {
						bonus_marines -= 5;
						eighth += 5;
					}
					break;
				case 8:
					if (ninth > 0) {
						bonus_marines -= 5;
						ninth += 5;
					}
					break;
				case 9:
					if (tenth > 0) {
						bonus_marines -= 5;
						tenth += 5;
					}
					break;
			}
			i++;
		}
	}

	if (struct_exists(obj_creation, "extra_specialists")) {
		var c_specialists = obj_creation.extra_specialists;
		var c_specialist_names = struct_get_names(c_specialists);
		for (var s = 0; s < array_length(c_specialist_names); s++) {
			var s_name = c_specialist_names[s];
			var s_val = struct_get(c_specialists, s_name);
			// show_debug_message($"updating specialist {s_name} with {s_val})");
			switch (s_name) {
				case "chaplains":
					chaplains = chaplains + real(s_val);
					break;
				case "chaplains_per_company":
					chaplains_per_company = chaplains_per_company + real(s_val);
					break;
				case "techmarines":
					techmarines = techmarines + real(s_val);
					break;
				case "techmarines_per_company":
					techmarines_per_company = techmarines_per_company + real(s_val);
					break;
				case "apothecary":
					apothecary = apothecary + real(s_val);
					break;
				case "apothecary_per_company":
					apothecary_per_company = apothecary_per_company + real(s_val);
					break;
				case "epistolary":
					epistolary = epistolary + real(s_val);
					break;
				case "epistolary_per_company":
					epistolary_per_company = epistolary_per_company + real(s_val);
					break;
				case "codiciery":
					codiciery = codiciery + real(s_val);
					break;
				case "lexicanum":
					lexicanum = lexicanum + real(s_val);
					break;
				case "terminator":
					terminator = terminator + real(s_val);
					break;
				case "assault":
					assault = assault + real(s_val);
					break;
				case "veteran":
					veteran = veteran + real(s_val);
					break;
				case "devastator":
					devastator = devastator + real(s_val);
					break;
			}
		}
	}

	if(struct_exists(obj_creation, "extra_marines")){
		var c_marines = obj_creation.extra_marines;
		var c_marines_names = struct_get_names(c_marines);
		for(var s = 0; s < array_length(c_marines_names); s++){
			var s_name = c_marines_names[s];
			var s_val = struct_get(c_marines, s_name);
			switch(s_name){
				case "second": second = second + real(s_val); break;
				case "third": third = third + real(s_val); break;
				case "fourth": fourth = fourth + real(s_val); break;
				case "fifth": fifth = fifth + real(s_val); break;
				case "sixth": sixth = sixth + real(s_val); break;
				case "seventh": seventh = seventh + real(s_val); break;
				case "eighth": eighth = eighth + real(s_val); break;
				case "ninth": ninth = ninth + real(s_val); break;
				case "tenth": tenth = tenth + real(s_val); break;
			}
		}
	}
	if(chaplains <= 0) {chaplains_per_company = 0};
	if(apothecary <= 0) {apothecary_per_company = 0};
	if(techmarines <= 0) {techmarines_per_company = 0};
	if(epistolary <= 0) {epistolary_per_company = 0};


	if (obj_creation.custom == eCHAPTER_TYPE.PREMADE) {
		if (veteran >= 20) and(global.founding = ePROGENITOR.NONE) {
			veteran -= 20;
			terminator += 20;
		}
		if (veteran >= 10) and(global.founding != ePROGENITOR.NONE) and(global.chapter_name != "Lamenters") {
			veteran -= 10;
			terminator += 10;
		}
	}

	#endregion



	battle_cry = obj_creation.battle_cry;
	home_name = obj_creation.homeworld_name;

	// This needs to be updated
	main_color = obj_creation.main_color;
	secondary_color = obj_creation.secondary_color;
	main_trim = obj_creation.main_trim;
	left_pauldron = obj_creation.left_pauldron;
	right_pauldron = obj_creation.right_pauldron;
	lens_color = obj_creation.lens_color;
	weapon_color = obj_creation.weapon_color;
	col_special = obj_creation.col_special;
	trim = obj_creation.trim;
	skin_color = obj_creation.skin_color;
	full_liveries = obj_creation.full_liveries;
    company_liveries = obj_creation.company_liveries;
	for (var i=1;i<array_length(full_liveries);i++){
		if (!full_liveries[i].is_changed){
			full_liveries[i] = variable_clone(full_liveries[0]);
		}
	}
	complex_livery_data = obj_creation.complex_livery_data;
    var complex_type = ["sgt", "vet_sgt", "captain", "veteran"];
    for (var i = 0; i < array_length(complex_type); i++) {
        with (complex_livery_data[$ complex_type[i]]) {
            if (helm_primary == 0 && helm_secondary == 0 && helm_lens == 0) {
                obj_ini.complex_livery_data[$ complex_type[i]] = helmet_livery(obj_ini.progenitor, complex_type[i]);
            }
        }
    }


	/*main_color=obj_creation.main_color;
	secondary_color=obj_creation.secondary_color;
	lens_color=obj_creation.lens_color;
	weapon_color=obj_creation.weapon_color;*/

	master_name=obj_creation.chapter_master_name;
	chief_librarian_name=obj_creation.clibrarian;
	high_chaplain_name=obj_creation.hchaplain;
	high_apothecary_name=obj_creation.hapothecary;
	forge_master_name=obj_creation.fmaster;
	honor_captain_name=obj_creation.honorcapt;		//1st
	watch_master_name=obj_creation.watchmaster;		//2nd
	arsenal_master_name=obj_creation.arsenalmaster;	//3rd
	lord_admiral_name=obj_creation.admiral;			//4th
	march_master_name=obj_creation.marchmaster;		//5th
	rites_master_name=obj_creation.ritesmaster;		//6th
	chief_victualler_name=obj_creation.victualler;	//7th
	lord_executioner_name=obj_creation.lordexec;	//8th
	relic_master_name=obj_creation.relmaster;		//9th
	recruiter_name=obj_creation.recruiter;			//10th

	master_melee = obj_creation.chapter_master_melee;
	master_ranged = obj_creation.chapter_master_ranged;


	#region Initialize Loadouts and 2d array garbage
	company = 0;
	// Initialize default marines for loadouts
	for (var i = 0; i <= 100; i++) {
		race[100, i] = 1;
		loc[100, i] = "";
		name[100, i] = "";
		role[100, i] = "";
		wep1[100, i] = "";
		spe[100, i] = "";
		wep2[100, i] = "";
		armour[100, i] = "";
		gear[100, i] = "";
		mobi[100, i] = "";
		age[100, i] = ((millenium * 1000) + year) - 10;
		god[100, i] = 0;
	}
	initialized = 500;
	// Initialize special marines
	for (var i = 0; i <= 500; i++) {
		race[0, i] = 1;
		loc[0, i] = "";
		name[0, i] = "";
		role[0, i] = "";
		wep1[0, i] = "";
		bio[0, i] = 0;
		spe[0, i] = "";
		wep2[0, i] = "";
		armour[0, i] = "";
		gear[0, i] = "";
		mobi[0, i] = "";
		age[0, i] = ((millenium * 1000) + year) - 10;
		god[0, i] = 0;
		/// @type {Array<Array<Struct.TTRPG_stats>>} 
		TTRPG[0, i] = new TTRPG_stats("chapter", 0, i, "blank");
	}
    for (var i = 0; i <= 100; i++) {
        role[100, i] = "";
        wep1[100, i] = "";
        wep2[100, i] = "";
        armour[100, i] = "";
        gear[100, i] = "";
        mobi[100, i] = ""; //hirelings??
        role[102, i] = "";
        wep1[102, i] = "";
        wep2[102, i] = "";
        armour[102, i] = "";
        gear[102, i] = "";
        mobi[102, i] = ""; //hirelings??
    }

	defaults_slot = 100;

	function load_default_gear(_role_id, _role_name, _wep1, _wep2, _armour, _mobi, _gear){
		role[defaults_slot, _role_id] = _role_name;
		wep1[defaults_slot, _role_id] = _wep1;
		wep2[defaults_slot, _role_id] = _wep2;
		armour[defaults_slot, _role_id] = _armour;
		mobi[defaults_slot, _role_id] = _mobi;
		gear[defaults_slot, _role_id] = _gear;
		race[defaults_slot, _role_id] = 1;
	}
	var _hi_qual_armour = "Artificer Armour";
	if(scr_has_disadv("Poor Equipment")){
		_hi_qual_armour = STR_ANY_POWER_ARMOUR;
	}

	load_default_gear(eROLE.ChapterMaster, "Chapter Master", "Power Sword", "Bolt Pistol", _hi_qual_armour, "","Iron Halo");
	load_default_gear(eROLE.HonourGuard, "Honour Guard", "Power Sword", "Bolter", _hi_qual_armour, "", "");
	load_default_gear(eROLE.Veteran, "Veteran", "Combiflamer", "Combat Knife",STR_ANY_POWER_ARMOUR, "", "");
	load_default_gear(eROLE.Terminator, "Terminator", "Power Fist", "Storm Bolter", "Terminator Armour", "", "");
	load_default_gear(eROLE.Captain, "Captain", "Power Sword", "Bolt Pistol", STR_ANY_POWER_ARMOUR, "", "Iron Halo");
	load_default_gear(eROLE.Dreadnought, "Dreadnought", "Close Combat Weapon", "Lascannon", "Dreadnought", "", "");
	load_default_gear(eROLE.Champion, "Champion", "Power Sword", "Bolt Pistol", STR_ANY_POWER_ARMOUR, "", "Combat Shield");
	load_default_gear(eROLE.Tactical, "Tactical", "Bolter", "Combat Knife", STR_ANY_POWER_ARMOUR, "", "");
	load_default_gear(eROLE.Devastator, "Devastator", "", "Combat Knife", STR_ANY_POWER_ARMOUR, "", "");
	load_default_gear(eROLE.Assault, "Assault", "Chainsword", "Bolt Pistol", STR_ANY_POWER_ARMOUR, "Jump Pack", "");
	load_default_gear(eROLE.Ancient, "Ancient", "Company Standard", "Bolt Pistol", STR_ANY_POWER_ARMOUR, "", "");
	load_default_gear(eROLE.Scout, "Scout", "Bolter", "Combat Knife", "Scout Armour", "", "");
	load_default_gear(eROLE.Chaplain, "Chaplain", "Crozius Arcanum", "Bolt Pistol", STR_ANY_POWER_ARMOUR, "", "Rosarius");
	load_default_gear(eROLE.Apothecary, "Apothecary", "Chainsword", "Bolt Pistol", STR_ANY_POWER_ARMOUR, "", "Narthecium");
	load_default_gear(eROLE.Techmarine, "Techmarine", "Power Axe", "Bolt Pistol", _hi_qual_armour, "Servo-arm", "");
	load_default_gear(eROLE.Librarian, "Librarian", "Force Staff", "Bolt Pistol", STR_ANY_POWER_ARMOUR, "", "Psychic Hood");
	load_default_gear(eROLE.Sergeant, "Sergeant", "Chainsword", "Bolt Pistol", STR_ANY_POWER_ARMOUR, "", "");
	load_default_gear(eROLE.VeteranSergeant, "Veteran Sergeant", "Chainsword", "Plasma Pistol", STR_ANY_POWER_ARMOUR, "", "");
 	

	if(struct_exists(obj_creation, "custom_roles")){
		var c_roles = obj_creation.custom_roles;
		var possible_custom_roles = [
			["chapter_master", eROLE.ChapterMaster],
			["honour_guard",eROLE.HonourGuard],
			["veteran",eROLE.Veteran],
			["terminator",eROLE.Terminator],
			["captain",eROLE.Captain],
			["dreadnought",eROLE.Dreadnought],
			["champion",eROLE.Champion],
			["tactical",eROLE.Tactical],
			["devastator",eROLE.Devastator],
			["assault",eROLE.Assault],
			["ancient",eROLE.Ancient],
			["scout",eROLE.Scout],
			["chaplain",eROLE.Chaplain],
			["apothecary",eROLE.Apothecary],
			["techmarine",eROLE.Techmarine],
			["librarian",eROLE.Librarian],
			["sergeant",eROLE.Sergeant],
			["veteran_sergeant",eROLE.VeteranSergeant],
		];
		var possible_custom_attributes = [
			"name", "wep1", "wep2", "mobi","gear","armour"
		]
		/**
		 * check whether the json structure exists to populate custom role names and 
		 * attributes then set them using the map above 
		 * role[100] is the 'default role name' storage spot, or something
		 */
		for(var c = 0; c < array_length(possible_custom_roles); c++){
			if(struct_exists(c_roles, possible_custom_roles[c][0])){
				var c_rolename = possible_custom_roles[c][0];
				var c_roleid = possible_custom_roles[c][1];
				for(var a = 0; a < array_length(possible_custom_attributes); a++){
					var attribute = possible_custom_attributes[a];
					if(struct_exists(c_roles[$ c_rolename], attribute)){
						var value = c_roles[$ c_rolename][$ attribute];
						// var dbg_m = $"role {c_roleid} {c_rolename} updated {attribute} to {typeof(value)} {value}";
						// log_message(dbg_m);
						// show_debug_message(dbg_m);
						switch (attribute){
							case "name": role[defaults_slot][c_roleid] = value; break;
							case "wep1": wep1[defaults_slot][c_roleid] = value; break;
							case "wep2": wep2[defaults_slot][c_roleid] = value; break;
							case "armour": armour[defaults_slot][c_roleid] = value; break;
							case "gear": gear[defaults_slot][c_roleid] = value; break;
							case "mobi": mobi[defaults_slot][c_roleid] = value; break;
						}
						// array_set_value(obj_ini[attribute][100][c_roleid], value);
						// [$attribute][100][c_roleid] = value;
					}
				}
			}
		}
	}

	var roles = {
		chapter_master: role[defaults_slot][eROLE.ChapterMaster],
		honour_guard: role[defaults_slot][eROLE.HonourGuard],
		veteran: role[defaults_slot][eROLE.Veteran],
		terminator: role[defaults_slot][eROLE.Terminator],
		captain: role[defaults_slot][eROLE.Captain],
		dreadnought: role[defaults_slot][eROLE.Dreadnought],
		champion: role[defaults_slot][eROLE.Champion],
		tactical: role[defaults_slot][eROLE.Tactical],
		devastator: role[defaults_slot][eROLE.Devastator],
		assault: role[defaults_slot][eROLE.Assault],
		ancient: role[defaults_slot][eROLE.Ancient],
		scout: role[defaults_slot][eROLE.Scout],
		chaplain: role[defaults_slot][eROLE.Chaplain],
		apothecary: role[defaults_slot][eROLE.Apothecary],
		techmarine: role[defaults_slot][eROLE.Techmarine],
		librarian: role[defaults_slot][eROLE.Librarian],
		sergeant: role[defaults_slot][eROLE.Sergeant],
		veteran_sergeant: role[defaults_slot][eROLE.VeteranSergeant],
	}
	// log_message($"roles: {json_stringify(roles, true)}")
	
	var weapon_lists = {
		heavy_weapons: ["Heavy Bolter", "Heavy Bolter", "Heavy Bolter", "Heavy Bolter", "Missile Launcher", "Missile Launcher", "Multi-Melta", "Lascannon"],
		special_weapons: ["Flamer", "Flamer", "Flamer", "Meltagun", "Meltagun", "Plasma Gun"],
		melee_weapons: ["Chainsword", "Chainsword", "Chainsword", "Chainsword", "Chainsword", "Chainsword", "Chainsword", "Chainsword", "Chainsword", "Power Sword", "Power Sword", "Power Sword", "Lightning Claw", "Lightning Claw", "Lightning Claw", "Power Fist", "Power Fist"],
		ranged_weapons: ["Bolter", "Bolter", "Bolter", "Bolter", "Bolter", "Bolter", "Storm Bolter", "Storm Bolter", "Storm Bolter", "Combiflamer", "Combiflamer", "Plasma Pistol"],
		pistols: ["Bolt Pistol", "Bolt Pistol", "Bolt Pistol", "Bolt Pistol", "Plasma Pistol"],
		one_hand_melee: ["Chainsword", "Chainsword", "Chainsword", "Chainsword", "Chainsword", "Chainsword", "Chainsword", "Chainsword", "Chainsword", "Power Sword", "Power Sword", "Power Sword", "Lightning Claw", "Lightning Claw", "Lightning Claw", "Power Fist", "Power Fist", "Thunder Hammer"],
	}

	var weapon_weighted_lists = {
		heavy_weapons: [["Heavy Bolter", 4], ["Missile Launcher", 3], ["Multi-Melta", 2], ["Lascannon", 1]],
		special_weapons: [["Flamer", 3], ["Meltagun", 2], ["Plasma Gun", 1]],
		melee_weapons: [["Chainsword", 5], ["Power Sword", 4], ["Lightning Claw", 3], ["Power Fist", 2], ["Thunder Hammer", 1]],
		ranged_weapons: [["Bolter", 10], ["Storm Bolter", 3], ["Combiflamer", 2], ["Plasma Pistol", 1]],
		pistols: [["Bolt Pistol", 5], ["Plasma Pistol", 1]],
	}
	#endregion

	#region Squad Loadouts
	/*
		squad guidance
			define a role that can exist in a squad by defining 
			[<role>, {
				"max":<maximum number of this role allowed in squad>
				"min":<minimum number of this role required in squad>
				}
			]
			by adding "loadout" as a key to the role struct e.g {"min":1,"max":1,"loadout":{}}
				a default or optional loadout can be created for the given role in the squad
			"loadout" has two possible keys "required" and "option"
			a required loadout always follows this syntax <loadout_slot>:[<loadout_item>,<required number>]
				so "wep1":["Bolter",4], will mean four marines are always equipped with 4 bolters in the wep1 slot

			option loadouts follow the following syntax <loudout_slot>:[[<loadout_item_list>],<allowed_number>]
				for example [["Flamer", "Meltagun"],1], means the role can have a max of one flamer or meltagun
					[["Plasma Pistol","Bolt Pistol"], 4] means the role can have a mix of 4 plasma pistols and bolt pistols on top
						of all required loadout options

	*/
	var squad_name = "Squad";
	if(obj_creation.custom != eCHAPTER_TYPE.PREMADE){
		if (obj_ini.progenitor == ePROGENITOR.SPACE_WOLVES) {
			squad_name = "Pack";
		}
		if (obj_ini.progenitor == ePROGENITOR.IRON_HANDS) {
			squad_name = "Clave";
		}
	}
	if(struct_exists(obj_creation, "squad_name")) {squad_name = obj_creation.squad_name;
	}
	squad_types = {};
	var st = {
		"command_squad": [
			[roles.captain, {
				"max": 1,
				"min": 1,
			}],
			[roles.champion, {
				"max": 1,
				"min": 0,
				"role": $"Company {roles.champion}"
			}],
			[roles.apothecary, {
				"max": 1,
				"min": 0,
				"role": $"Company {roles.apothecary}"
			}],
			[roles.chaplain, {
				"max": 1,
				"min": 0,
				"role": $"Company {roles.chaplain}"
			}],
			[roles.ancient, {
				"max": 1,
				"min": 1,
				"role": $"Company {roles.ancient}",
			}],
			[roles.veteran, {
				"max": 5,
				"min": 0,
				"loadout": {
					"required": {
						"wep1": [wep1[defaults_slot][eROLE.Veteran], 5],
						"wep2": [wep2[defaults_slot][eROLE.Veteran], 5],
					}
				},
				"role": $"Company {roles.veteran}"
			}],
			[roles.techmarine, {
				"max": 2,
				"min": 0,
				"role": $"Company {roles.techmarine}"
			}],
			[roles.librarian, {
				"max": 1,
				"min": 0,
				"role": $"Company {roles.librarian}"
			}],
			["type_data", {
				"display_data": $"Command {squad_name}",
				"formation_options": ["command", "terminator", "veteran", "assault", "devastator", "scout", "tactical"],
			}]
		],

		"terminator_squad": [
			// Terminator Sergeant
			[roles.veteran_sergeant, {
				"max": 1,
				"min": 1,
				"role": $"{roles.terminator} {roles.sergeant}",
				"loadout": {
					"required": {
						"wep1": [wep1[defaults_slot][eROLE.Terminator], 1],
						"wep2": [wep2[defaults_slot][eROLE.Terminator], 1],
					},
				}
			}],
			// Terminator
			[roles.terminator, {
				"max": 4,
				"min": 2,
				"loadout": {
					"required": {
						"wep1": ["", 0],
						"wep2": [wep2[100, 4], 3],
					},
					"option": {
						"wep1": [
							[
								["Power Fist", "Chainfist"], 4
							],
						],
						"wep2": [
							[
								["Assault Cannon", "Heavy Flamer"], 1
							],
						],
					}
				}
			}],
			["type_data", {
				"display_data": $"{roles.terminator} {squad_name}",
				"formation_options": ["terminator", "veteran", "assault", "devastator", "scout", "tactical"],
			}]
		],

		"terminator_assault_squad": [
			// Assault Terminator Sergeant
			[roles.veteran_sergeant, {
				"max": 1,
				"min": 1,
				"role": $"Assault {roles.terminator} {roles.sergeant}",
				"loadout": {
					"required": {
						"wep1": ["Thunder Hammer", 1],
						"wep2": ["Storm Shield", 1],
					},
				},
			}],
			// Assault Terminator
			[roles.terminator, {
				"max": 4,
				"min": 2,
				"role": $"Assault {roles.terminator}",
				"loadout": {
					"required": {
						"wep1": ["Thunder Hammer", 1],
						"wep2": ["Storm Shield", 1],
					},
					"option": {
						"wep1": [
							[
								["Lightning Claw"], 3, {
									"wep2":"Lightning Claw",
								}
							],
						],
					}
				},
			}, ],
			["type_data", {
				"display_data": $"{roles.terminator} Assault {squad_name}",
				"formation_options": ["terminator", "veteran", "assault", "devastator", "scout", "tactical"],
			}]
		],

		"sternguard_veteran_squad": [
			// Sternguard Veteran
			[roles.veteran, {
				"max": 9,
				"min": 4,
				"role": $"Sternguard {roles.veteran}",
				"loadout": {
					"required": {
						"wep1": ["", 0],
						"wep2": ["Combat Knife", max],
					},
					"option": {
						"wep1": [
							[
								["Bolter", "Stalker Pattern Bolter", "Storm Bolter"], 5
							],
							[
								["Combiflamer"], 2
							],
							[
								weapon_lists.special_weapons, 1
							],
							[
								weapon_lists.heavy_weapons, 1, {
									"wep2":"Combat Knife",
									"mobi":"Heavy Weapons Pack",
								}
							],
						]
					}
				}
			}],
			// Sternguard Veteran Sergeant
			[roles.veteran_sergeant, {
				"max": 1,
				"min": 1,
				"role": $"Sternguard {roles.veteran_sergeant}",
				"loadout": {
					"required": {
						"wep1": ["Stalker Pattern Bolter", 1],
						"wep2": [wep2[100][eROLE.Veteran], 1],
					},
				}
			}],
			["type_data", {
				"display_data": $"Sternguard {roles.veteran} {squad_name}",
				"formation_options": ["veteran", "assault", "devastator", "scout", "tactical"],
			}]
		],

		"vanguard_veteran_squad": [
			// Vanguard Veterans
			[roles.veteran, {
				"max": 9,
				"min": 4,
				"role": $"Vanguard {roles.veteran}",
				"loadout": {
					"required": {
						"wep1": ["", 0],
						"wep2": ["Bolt Pistol", 4],
						"mobi": ["Jump Pack", 9]
					},
					"option": {
						"wep1": [
							[
								["Chainsword", "Power Sword", "Power Axe", "Lightning Claw"], 6
							],
							[
								["Power Fist"], 2
							],
							[
								["Thunder Hammer"], 1
							],
						],
						"wep2": [
							[
								["Storm Shield"], 2,
							],
							[
								["Plasma Pistol"], 3
							],
						]
					}
				}
			}],
			// Vanguard Veteran Sergeant
			[roles.veteran_sergeant, {
				"max": 1,
				"min": 1,
				"role": $"Vanguard {roles.veteran_sergeant}",
				"loadout": {
					"required": {
						"wep1": ["Thunder Hammer", 1],
						"wep2": ["Storm Shield", 1],
						"mobi": ["Jump Pack", 1]
					},
				}
			}],
			["type_data", {
				"display_data": $"Vanguard {roles.veteran} {squad_name}",
				"formation_options": ["veteran", "assault", "devastator", "scout", "tactical"],
			}]
		],

		"devastator_squad": [
			[roles.devastator,
				{
					"max": 9,
					"min": 4,
					"loadout": {
						"required": {
							"wep1": ["Bolter", 5],
							"wep2": ["Combat Knife", 9],
							"mobi": ["", 5],
						},
						"option": {
							"wep1": [
								[
									weapon_lists.heavy_weapons, 4, {
										"mobi":"Heavy Weapons Pack",
									}
								],
							],
						}
					}
				}
			],
			[roles.sergeant, {
				"max": 1,
				"min": 1,
				"role": $"{roles.devastator} {roles.sergeant}",
				"loadout": {
					"required": {
						"mobi": ["", 1],
					},
					"option": {
						"wep1": [
							[
								weapon_lists.pistols, 1
							],
						],
						"wep2": [
							[
								weapon_lists.melee_weapons, 1
							],
						],
					}
				}
			}],
			["type_data", {
				"display_data": $"{roles.devastator} {squad_name}",
				"formation_options": ["devastator", "tactical", "assault", "scout"],
			}]
		],

		"tactical_squad": [
			[roles.tactical, {
				"max": 9,
				"min": 4,
				"loadout": {
					"required": {
						"wep1": [wep1[100, 8], 7],
						"wep2": [wep2[100, 8], 7]
					},
					"option": {
						"wep1": [
							[
								weapon_lists.special_weapons, 1
							],
							[
								weapon_lists.heavy_weapons, 1, {
									"wep2":"Combat Knife",
									"mobi":"Heavy Weapons Pack",
								}
							]
						],
					}
				}
			}],
			[roles.sergeant, {
				"max": 1,
				"min": 1,
				"role": $"{roles.tactical} {roles.sergeant}",
				"loadout": {
					"required": {
						"wep1": ["", 0],
						"wep2": ["Chainsword", 1]
					},
					"option": {
						"wep1": [
							[
								weapon_lists.pistols, 1
							],
						],
						"wep2": [
							[
								weapon_lists.melee_weapons, 1
							],
						],
					}
				}
			}],
			["type_data", {
				"display_data": $"{roles.tactical} {squad_name}",
				"formation_options": ["tactical", "assault", "devastator", "scout"],
				"class":["troop"]
			}],
			
			
		],

		"assault_squad": [
			[roles.assault, {
				"max": 9,
				"min": 4,
				"loadout": {
					"required": {
						"wep1": [wep1[100, 10], 5],
						"wep2": [wep2[100, 10], 5],
					},
					"option": {
						"wep1": [
							[
								["Eviscerator"], 2, {
									"wep2":"",
								}
							],
						],
						"wep2": [
							[
								["Plasma Pistol", "Flamer"], 2
							]
						]
					}
				}
			}],
			[roles.sergeant, {
				"max": 1,
				"min": 1,
				"role": $"{roles.assault} {roles.sergeant}",
				"loadout": {
					"required": {
						"wep1": ["", 0],
						"wep2": ["", 0],
						"gear": ["Combat Shield", 1]
					},
					"option": {
						"wep1": [
							[
								weapon_lists.pistols, 1
							],
						],
						"wep2": [
							[
								weapon_lists.melee_weapons, 1
							],
						],
					}
				}
			}],
			["type_data", {
				"display_data": $"{roles.assault} {squad_name}",
				"formation_options": ["assault", "tactical", "devastator", "scout"],
			}]
		],

		"scout_squad": [
			[roles.scout, {
					"max": 9,
					"min": 4,
					"loadout": {
						"required": {
							"wep1": [wep1[100][12], 6],
							"wep2": [wep2[100][12], 9]
						},
						"option": {
							"wep1": [
								[
									["Bolter", "Stalker Pattern Bolter"], 2
								],
								[
									["Missile Launcher", "Heavy Bolter"], 1
								]
							],
						}
					}
				}],
			[roles.sergeant, {
					"max": 1,
					"min": 1,
					"loadout": {
						"option": {
							"wep1": [
								[
									["Bolt Pistol", "Bolt Pistol", "Plasma Pistol", "Bolter", "Bolter", "Stalker Pattern Bolter"], 1
								]
							],
							"wep2": [
								[
									["Power Sword", "Chainsword", "Power Axe"], 1
								]
							]
						}
					},
					"role": $"{roles.scout} {roles.sergeant}",
				}],
			["type_data", {
				"display_data": $"{roles.scout} {squad_name}",
				"class": ["scout"],
				"formation_options": ["scout", "tactical", "assault", "devastator"],
			}],
		],

		"scout_sniper_squad": [
			[roles.scout,
				{
					"max": 9,
					"min": 4,
					"loadout": {
						"required": {
							"wep1": ["Sniper Rifle", 8],
							"wep2": ["Combat Knife", 9]
						},
						"option": {
							"wep1": [
								[
									["Missile Launcher"], 1
								]						
							],
						}
					},
					"role": $"{roles.scout} Sniper",
				}],
			[roles.sergeant, {
					"max": 1,
					"min": 1,
					"loadout": {
						"required": {
							"wep1": ["Sniper Rifle", 1],
							"wep2": ["Combat Knife", 1]
						},
					},
					"role": $"Sniper {roles.sergeant}",
				}
			],
			["type_data", {
				"display_data": $"{roles.scout} Sniper {squad_name}",
				"class": ["scout"],
				"formation_options": ["scout"],
			}],
		]
	};

	// show_debug_message($"squads object for chapter {chapter_name}");
	// show_debug_message($"{st}");


	if(struct_exists(obj_creation, "custom_squads")){
		var custom_squads = obj_creation.custom_squads;
		// show_debug_message($"custom roles {custom_squads}");
		if(array_length(struct_get_names(custom_squads)) != 0){
			var names = struct_get_names(st);
			// show_debug_message($"names {names}");
			for(var n = 0; n < array_length(names); n++){
				var squad_name = names[n];
				// show_debug_message($"matched squad name name {squad_name}");

				if(struct_exists(custom_squads, squad_name)){
					var custom_squad = struct_get(custom_squads, squad_name);
					// show_debug_message($"overwriting squad layout for {squad_name}");
					// show_debug_message($"{custom_squad}")
					variable_struct_set(st, squad_name, custom_squad);
				}
			}
		}
	}

	// show_debug_message($"roles object for chapter {chapter_name} after setting from obj");
	// show_debug_message($"{st}");

	if (scr_has_adv("Crafters")) { //salamanders squads
		variable_struct_set(st, "assault_squad", [
			[roles.assault, {
				"max": 9,
				"min": 4,
				"loadout": { //assault_marine
					"required": {
						"wep1": [wep1[100, 10], 4],
						"wep2": [wep2[100, 10], 4],
						"gear": ["Combat Shield", 4]
					},
					"option": {
						"wep1": [
							[
								["Power Sword", "Power Axe", "Eviscerator"], 2
							],
						],
						"wep2": [
							[
								["Flamer", "Meltagun", "Plasma Pistol", "Bolt Pistol"], 2
							],

						],
					}
				}
			}],
			[roles.sergeant, {
				"max": 1,
				"min": 1, //sergeant
				"loadout": {
					"required": {
						"wep1": ["Bolt Pistol", 0],
						"wep2": ["Chainsword", 0],
					},
					"option": {
						"wep1": [
							[
								["Power Sword", "Thunder Hammer", "Power Fist", "Chainsword"], 1
							]
						],
						"wep2": [
							[
								["Plasma Pistol", "Combiflamer", "Meltagun"], 1
							]
						]
					}
				},
				"role": $"{roles.sergeant} {roles.assault}"
			}],
			["type_data", {
				"display_data": $"{roles.assault} {squad_name}"
			}]
		])
	}
	if (scr_has_adv("Lightning Warriors")) {
		variable_struct_set(st, "bikers", [
			[roles.assault, {
				"max": 9,
				"min": 4,
				"loadout": { //tactical marine
						"required": {
						"wep1": ["", max],
						"wep2": ["Chainsword", max],
						"mobi": ["Bike", max]
					}
				},
				"role": $"Biker"
			}],
			[roles.sergeant, {
				"max": 1,
				"min": 1,
				"loadout": { //sergeant
					"required": {
						"wep1": ["", max],
						"wep2": ["Chainsword", max],
						"mobi": ["Bike", 1]
					}
				},
				"role": $"Biker {roles.sergeant}"
			}, ],
			["type_data", {
				"display_data": $"Bike {squad_name}",
				"class":["bike"],
				"formation_options": ["assault", "tactical"],
			}]
		])
	}
	if (scr_has_adv("Boarders")) {
		variable_struct_set(st, "breachers", [
			[roles.tactical, {
				"max": 9,
				"min": 4,
				"loadout": { //tactical breacher marine
					"required": {
						"wep1":[wep1[100, 8], 7],
						"wep2":["Boarding Shield", max],
						"armour":["MK3 Iron Armour", max],
						"gear":["Plasma Bomb", max],
						"mobi":["", max]
					},
					"option": {
						"wep1": [
							[
								["Flamer", "Grav-Gun", "Meltagun", "Lascutter"], 2,
							],
						]
								}
				},
				"role": $"Breacher"
			}],
			[roles.sergeant, {
				"max": 1,
				"min": 1,
				"loadout": { //sergeant 
					"required": {
						"wep2":["Boarding Shield", max],
						"armour":["MK3 Iron Armour", max],
						"mobi": ["", max],
						"gear": ["Plasma Bomb", max]
					},
					"option": {
						"wep1": [
							[
								["Bolter", "Bolter", "Bolter", "Combiflamer"], 1
							]
						],
					}
				},
				"role": $"Breacher {roles.sergeant}"
			}, ],
			["type_data", {
				"display_data": $"Breacher {squad_name}",
				"formation_options": ["tactical", "assault", "devastator", "scout" ],
			}]
		])
		variable_struct_set(st,"assault_squad", [
			[roles.assault, {
				"max": 9,
				"min": 4,
				"loadout": {
					"required": {
						"wep1": [wep1[100, 10], 7],
						"wep2": [wep2[100, 10], 7],
					},
					"option": {
						"wep1": [
							[
								weapon_lists.melee_weapons, 2
							],
						],
						"wep2": [
							[
								["Plasma Pistol", "Flamer"], 2
							]
						]
					}
				}
			}],
			[roles.sergeant, {
				"max": 1,
				"min": 1,
				"role": $"{roles.assault} {roles.sergeant}",
				"loadout": {
					"required": {
						"wep1": ["", 0],
						"wep2": ["", 0],
						"gear": ["Combat Shield", 1]
					},
					"option": {
						"wep1": [
							[
								weapon_lists.pistols, 1
							],
						],
						"wep2": [
							[
								weapon_lists.melee_weapons, 1
							],
						],
					}
				}
			}],
			["type_data", {
				"display_data": $"{roles.assault} {squad_name}",
				"formation_options": ["assault"],
			}]
		])
	}


	var squad_names = struct_get_names(st);
	// show_debug_message($" {squad_names}");
	// show_debug_message($"^^^ Squad names");
	

	for (var st_iter = 0; st_iter < array_length(squad_names); st_iter++) {
		var s_group = st[$squad_names[st_iter]];
		squad_types[$squad_names[st_iter]] = {};
		for (var iter_2 = 0; iter_2 < array_length(s_group); iter_2++) {
			squad_types[$squad_names[st_iter]][$s_group[iter_2][0]] = s_group[iter_2][1];
		}
	}
	if(scr_has_adv("Ambushers")){
		var _class_data = squad_types.tactical_squad.type_data.class;
		array_push(_class_data, "scout")
	}
	// show_debug_message("Squad types");
	// show_debug_message(squad_types);
	#endregion

	for (i = 0; i <= 20; i++) {
		if (role[defaults_slot, i] != "") {
			scr_start_allow(i, "wep1", wep1[defaults_slot, i]);
		}
		if (role[defaults_slot, i] != "") {
			scr_start_allow(i, "wep2", wep2[defaults_slot, i]);
		}
		if (role[defaults_slot, i] != "") {
			scr_start_allow(i, "mobi", mobi[defaults_slot, i]);
		}
		if (role[defaults_slot, i] != "") {
			scr_start_allow(i, "gear", gear[defaults_slot, i]);
		}
		// check for allowable starting equipment here
	}

	initialized = 500; // How many array variables have been prepared
	v = 0;
	company = 0;

	// TODO: When modding support is implemented, uncomment this init. Otherwise traits are initialized at compile.
    //loads up marine traits potential modding potential;
    // initialize_marine_traits();
	#region Chapter HQ
	for (var c = 0; c <11; c++){
		for (var i = 0; i < 501; i++) {
			race[c, i] = 1;
			loc[c, i] = "";
			name[c, i] = "";
			role[c, i] = "";
			wep1[c, i] = "";
			spe[c, i] = "";
			wep2[c, i] = "";
			armour[c, i] = "";
			chaos[c, i] = 0;
			gear[c, i] = "";
			mobi[c, i] = "";
			age[c, i] = ((millenium * 1000) + year) - 10;
			god[c, i] = 0;
			TTRPG[c, i] = new TTRPG_stats("chapter", c, i, "blank");
		}
	}

	// Chapter Master
	// This needs work
	name[company, 0] = obj_creation.chapter_master_name;
	var cm_equip = load_chapter_master_equipment();

	var chapter_master = add_unit_to_company("chapter_master", 0, 0 , roles.chapter_master, eROLE.ChapterMaster, cm_equip.wep1, cm_equip.wep2, cm_equip.gear, cm_equip.mobi, cm_equip.armour);
	repeat(cm_equip.bionics){
		chapter_master.add_bionics("none", "standard", false);
	}

	spe[company, 0] = "";
	chapter_master.add_trait("lead_example");

	//builds in which of the three chapter master types your CM is
	// all of this can now be handled in teh struct and no longer neades complex methods
	switch (obj_creation.chapter_master_specialty) {
		case 1:
			chapter_master.add_exp(550);
			spe[company, 0] += "$";
			break;
		case 2:
			chapter_master.add_exp(650);
			spe[company, 0] += "@";
			chapter_master.add_trait("champion");
			break;
		case 3:
			//TODO phychic powers need a redo but after weapon refactor
			chapter_master.add_exp(550);
			cm_equip.gear = "Psychic Hood";
			chapter_master.add_trait("favoured_by_the_warp");
			chapter_master.psionic = choose(13, 14);
			chapter_master.update_powers();
	}
	chapter_master.alter_equipment(cm_equip, false, false, "master_crafted")
	if(scr_has_adv("Paragon")){
		chapter_master.add_trait("paragon");
	}
	chapter_master.marine_assembling();

	var _hq_armour = "Artificer Armour";
	if(scr_has_disadv("Poor Equipment")){
		_hq_armour = "MK6 Corvus";
	}

	k+=1;
	commands = 1;

	// Forge Master
	name[company, 1] = obj_creation.fmaster;
	var _forge_master = add_unit_to_company("marine", company, 1, "Forge Master", eROLE.Techmarine, "Infernus Pistol", "Power Axe", "default", "Servo-harness", _hq_armour);
	if (_forge_master.technology < 40) {
		_forge_master.technology = 40;
	}
	_forge_master.add_trait("mars_trained");
	_forge_master.add_bionics("right_arm", "standard", false);
	_forge_master.marine_assembling();
	if (global.chapter_name = "Iron Hands") {
		repeat(9) {
			_forge_master.add_bionics("none", "standard", false);
		}
	} else {
		repeat(irandom(5) + 3) {
			_forge_master.add_bionics("none", "standard", false)
		};
	}
	k+=1;
	commands +=1;

	// Master of Sanctity (Chaplain)
	if (chaplains > 0){
		name[company, 2] = high_chaplain_name;
		var _hchap = add_unit_to_company("marine", company, 2, "Master of Sanctity", eROLE.Chaplain, "default", "Plasma Pistol", "default", "default", _hq_armour);
		_hchap.edit_corruption(-100);
		if (_hchap.piety < 45) {
			_hchap.piety = 45;
		}
		_hchap.add_trait("zealous_faith");
		k+=1;
		commands +=1;
	}

	// Maser of the Apothecarion (Apothecary)
	name[company, 3] = obj_creation.hapothecary;
	var _hapoth = add_unit_to_company("marine", company, 3, "Master of the Apothecarion", eROLE.Apothecary, "default", "Plasma Pistol", "default", "default", _hq_armour);
	_hapoth.edit_corruption(0);
	k+=1;
	commands +=1;

	// Chief Librarian
	if(!scr_has_disadv("Psyker Intolerant")){
		name[company, 4] = obj_creation.clibrarian;
		var _clibrarian = add_unit_to_company("marine", company, 4, string("Chief {0}", roles.librarian), eROLE.Librarian, "default", "Plasma Pistol", "default", "default", _hq_armour);
		_clibrarian.edit_corruption(0);
		_clibrarian.psionic = choose(11, 12);
		_clibrarian.update_powers();
		_clibrarian.add_trait("favoured_by_the_warp");
		k+=1;
		commands +=1;
	}
	man_size = k;

	// Techmarines in the armoury
	repeat(techmarines) {
		k += 1;
		commands += 1;
		man_size += 1;
		add_unit_to_company("marine", company, k, roles.techmarine, eROLE.Techmarine, "default", choose_weighted(weapon_weighted_lists.pistols));
	}

	// Librarians in the librarium
	repeat(epistolary) {
		k += 1;
		commands += 1;
		man_size += 1;
		var _epi = add_unit_to_company("marine", company, k, roles.librarian, eROLE.Librarian, "default", choose_weighted(weapon_weighted_lists.pistols));
	}
	// Codiciery
	repeat(codiciery) {
		k += 1;
		commands += 1;
		man_size += 1;
		var _codi = add_unit_to_company("marine", company, k, "Codiciery", eROLE.Librarian, "default", choose_weighted(weapon_weighted_lists.pistols));
	}

	// Lexicanum
	repeat(lexicanum) {
		k += 1;
		commands += 1;
		man_size += 1;
		var _lexi = add_unit_to_company("marine", company, k, "Lexicanum", eROLE.Librarian, "default", choose_weighted(weapon_weighted_lists.pistols));
	}

	// Apothecaries in Apothecarion
	repeat(apothecary) {
		k += 1;
		commands += 1;
		man_size += 1;
		add_unit_to_company("marine", company, k, roles.apothecary, eROLE.Apothecary,"Chainsword", choose_weighted(weapon_weighted_lists.pistols));
	}

	// Chaplains in Reclusium
	repeat(chaplains) {
		k += 1;
		commands += 1;
		man_size += 1;
		add_unit_to_company("marine", company, k, roles.chaplain, eROLE.Chaplain,"default", choose_weighted(weapon_weighted_lists.pistols));
	}

	// Honour Guard
	var _honour_guard_count = 0, unit;
	if (scr_has_adv("Retinue of Renown")){
		_honour_guard_count += 10;
	} 
	if (progenitor == ePROGENITOR.DARK_ANGELS && obj_creation.custom == eCHAPTER_TYPE.PREMADE) { 
		_honour_guard_count += 6; 
	}
	if (_honour_guard_count == 0) {
		_honour_guard_count = 3
	}
	for (var i = 0; i < min(_honour_guard_count, 10); i++) {
		k += 1;
		commands += 1;
		man_size += 1;
		add_unit_to_company("marine", company, k, roles.honour_guard, eROLE.HonourGuard);
	}

	specials = k;
	#endregion

	#region New Totals Per Company Adjusted
	var companies = {
		first: {
			coy: 1,
			total: veteran + terminator,
			veterans: veteran,
			terminators: terminator,
			tacticals: 0,
			assaults: 0,
			devastators: 0,
			dreadnoughts: dreadnought == 0 ? 0 : dreadnought+1, //handle obliterated
			predators: predator,
			landraiders: landraider
		},
		second: {
			coy: 2,
			total: second,
			rhinos: rhino,
			landspeeders: landspeeder,
			dreadnoughts: dreadnought,
			landraiders: landraider,
			whirlwinds: whirlwind,
		},
		third: {
			coy: 3,
			total: third,
			rhinos: rhino,
			landspeeders: landspeeder,
			dreadnoughts: dreadnought,
			whirlwinds: whirlwind,

		},
		fourth: {
			coy: 4,
			total: fourth,
			rhinos: rhino,
			landspeeders: landspeeder,
			dreadnoughts: dreadnought,
			whirlwinds: whirlwind,

		},
		fifth: {
			coy: 5,
			total: fifth,
			rhinos: rhino,
			landspeeders: landspeeder,
			dreadnoughts: dreadnought,
			whirlwinds: whirlwind,
		},
		sixth: {
			coy: 6,
			total: sixth,
			rhinos: rhino,
			landspeeders: landspeeder-2,
			dreadnoughts: dreadnought,
			whirlwinds: whirlwind,

		},
		seventh: {
			coy: 7,
			total: seventh,
			dreadnoughts: dreadnought,
			rhinos: rhino,
			landspeeders: landspeeder+6,
			whirlwinds: whirlwind-4
		},
		eighth: {
			coy: 8,
			total: eighth,
			dreadnoughts: dreadnought,
			rhinos: rhino-6,
			whirlwinds: whirlwind-4,
			landspeeders: landspeeder,

		},
		ninth: {
			coy: 9,
			total: ninth,
			dreadnoughts: dreadnought,

			rhinos: rhino-6,
			whirlwinds: whirlwind-4,
			landspeeders: landspeeder-2,
			predators: predator,

		},
		tenth: {
			coy: 10,
			total: tenth,
			dreadnoughts: 0,
			rhinos: rhino,
			whirlwinds: whirlwind-4,
			landspeeders: landspeeder-2,
			scouts: tenth -10, //should work out to 90
			predators:0,
			landraiders:0,
		}
	}

	log_message($"Pre balancing company totals: {json_stringify(companies,true)}")
	// Extra vehicles loaded from json files all get dumped into the 10th company for the player to sort out
	
	var vehicle_keys = ["rhino", "whirlwind", "predator", "land_raider", "land_speeder"];
	if(struct_exists(obj_creation, "extra_vehicles")){
		for (var v = 0; v < array_length(vehicle_keys); v++){
			var key = vehicle_keys[v];
			if(struct_exists(obj_creation.extra_vehicles, key) && real(obj_creation.extra_vehicles[$key]) > 0){
				var coy_key = "";
				switch(key){
					case "rhino": coy_key = "rhinos";break;
					case "whirlwind": coy_key = "whirlwinds";break;
					case "predator": coy_key = "predators";break;
					case "land_raider": coy_key = "landraiders"; break;
					case "land_speeder": coy_key = "landspeeders"; break;
				}
				companies.tenth[$coy_key] += obj_creation.extra_vehicles[$key];
			}
		}
	}


	var equal_specialists = obj_creation.equal_specialists;
	var scout_company_behaviour = 0;
	if(struct_exists(obj_creation, "scout_company_behaviour")){
		var scout_company_behaviour = obj_creation.scout_company_behaviour;
	}
	if(scout_company_behaviour == 1){
		load_default_gear(eROLE.Scout, "Neophyte", "Bolter", "", "Scout Armour", "","");
	}

	var equal_scouts = 0;
	if(struct_exists(obj_creation, "equal_scouts")){
		var equal_scouts = obj_creation.equal_scouts;
	}
	obj_ini.equal_scouts = equal_scouts; // for use in squad creation later

	var _moved_scouts = 0;

	var _coys = struct_get_names(companies);
	function _is_terminator (_armour) {
		return array_contains(["Terminator Armour", "Tartaros"], _armour);
	};
	for(var _c = 0, _clen =  array_length(_coys); _c < _clen; _c++ ){
		var k = 0, v = 0;//k = marine slot, v = vehicle slot
		
		var _name = _coys[_c];
		var _coy = companies[$_name];
		if(_coy.total <= 0){
			continue;
		}
		_coy.captains = 1;
		_coy.champions = 1;
		_coy.ancients = 1;
		_coy.tacticals = 0;// see equal specialists section
		_coy.assaults = 0;
		_coy.devastators = 0;
		_coy.chaplains = chaplains_per_company;
		_coy.apothecaries = apothecary_per_company;
		_coy.techmarines = techmarines_per_company;
		_coy.librarians = epistolary_per_company;



		///* Equal specialist behaviour: 
		/// if set to true, instead of having 8th and 9th be reserve companies of assaults and devastators,
		/// those marines are instead evenly distributed between 2nd and 9th companies
		/// the tacticals that they replace are distributed between 8th and 9th
		/// meaning the total number of each shouldn't change. 
		/// on a fresh standard chapter with normal scouts, rates should be: 
		/// equal spec: 
		/// comp 2 - 9: tac: 60, ass: 20, dev: 20
		/// non-equal spec:
		/// comp 2 - 5: tac 60, ass 20, dev: 20
		/// comp 6 - 7: tac 100
		/// comp 8: ass 100
		/// comp 9: dev 100

		/// equal spec with equal scout
		/// comp 2 - 9: tac 50: scout 10, ass 20, dev 20
		/// non-equal with equal scout
		/// comp 2 - 5: tac 40: scout 20, ass 20, dev 20,
		/// comp 8: ass 100
		/// comp 9: dev 100
		/// comp 10: tac 40: scout 50;
		if(equal_specialists){
			// log_message("balancing for equal specialists")
			// log_message($"equal_scouts? {equal_scouts}")

			if (_coy.coy >= 2 && _coy.coy <= 9){
				if(equal_scouts){
					if(companies.tenth.scouts > 10){ 
						//theoretically this keeps track of moving scouts from the bank of them in 10th
						_coy.scouts = 10;
						_coy.tacticals = max(0, (_coy.total - (assault + devastator + _coy.scouts)));
						_moved_scouts += _coy.scouts;
						companies.tenth.scouts -= _coy.scouts;
					} else {
						// if 10th is run out somehow, revert to normal behaviour
						_coy.tacticals = max(0, (_coy.total - (assault + devastator)));
					}
				} else {
					_coy.tacticals = max(0, (_coy.total - (assault + devastator)));
				}
				_coy.assaults = assault;
				_coy.devastators = devastator;
			}
			if(equal_scouts && _coy.coy == 10){
				// theoretically this swaps moved scouts with tacticals
				_coy.tacticals = _moved_scouts;
			}
		} else {
			// log_message("balancing for non-equal specialists")
			/// Default specialist behaviour, battle companies 2-7 have 90 tacticals each
			/// and the assaults go into the 8th and devastators into the 9th 
			if (_coy.coy >= 2 && _coy.coy <= 5){
				if(equal_scouts){
					if(companies.tenth.scouts > 10){ 
						_coy.scouts = 10;
						_moved_scouts += _coy.scouts;
						_coy.tacticals = max(0, (_coy.total - (assault + devastator + _coy.scouts)))
						companies.tenth.scouts -= _moved_scouts;
					} else {
						// if 10th is run out somehow, revert to normal behaviour
						_coy.tacticals = max(0, (_coy.total - (assault + devastator)));
					}
				} else {
					_coy.tacticals = max(0, (_coy.total - (assault + devastator)));
				}
				_coy.assaults = assault;
				_coy.devastators = devastator;
			}
			
			if (real(_coy.coy) >= 6 && real(_coy.coy) <= 7){
				if(equal_scouts){
					if(companies.tenth.scouts > 10){ 
						_coy.scouts = 10;
						_moved_scouts += _coy.scouts;
						_coy.tacticals = _coy.total - _coy.scouts;
						companies.tenth.scouts -= _coy.scouts;
					} else {
						// if 10th is run out somehow, revert to normal behaviour
						_coy.tacticals = _coy.total;
					}
				} else {
					_coy.tacticals = _coy.total;
				}
				_coy.assaults = 0;
				_coy.devastators = 0;

			}
			if(real(_coy.coy) == 8){
				_coy.tacticals = 0;
				_coy.assaults = _coy.total;
				_coy.devastators = 0;
			}
			if(real(_coy.coy) == 9){
				_coy.tacticals = 0;
				_coy.assaults = 0;
				_coy.devastators = _coy.total;
			}
			if(real(_coy.coy) == 10 && equal_scouts){
				_coy.tacticals = _moved_scouts;
				_coy.scouts = _coy.scouts - _coy.tacticals;
			}
		}

		log_message($"New Company Totals: eq specialists: {equal_specialists}: scout coy {scout_company_behaviour} equal_scouts: {equal_scouts}");
		log_message($"Company {_coy.coy}: {json_stringify(_coy,true)}");


		var attrs = struct_get_names(_coy);
		
		
		
		// log_message($"attrs {attrs}");

		for(var _a = 0, _alen =  array_length(attrs); _a < _alen; _a++ ){
			var _is_vehicle=false;
			var _rolename;
			var _erole;
			var _wep1="default";
			var _wep2="default"
			var _gear="default"
			var _mobi="default";
			var _armour="default";
			var _wep3="";
			var _upgrade="";
			var _accessory="";
			var _unit_type = "marine";
			var _role = attrs[_a];
			var _count = _coy[$_role];
	
			if(_role == "total" || _role == "coy") {
				continue;
			}

			// log_message($"processing: coy {_coy.coy} role {_role} count {_count}");
			switch (_role) {
				// MAINLINE
				case "tacticals":
					if(scr_has_adv("Elite Guard")){
						_rolename = roles.veteran;
						_erole = eROLE.Veteran;
					} else {
						_rolename = roles.tactical;
						_erole = eROLE.Tactical;
					}
					break;
				case "assaults":
					_rolename = roles.assault;
					_erole = eROLE.Assault;
					_mobi = "Jump Pack";
					break;
				case "devastators":
					_rolename = roles.devastator;
					_erole = eROLE.Devastator;
					if (wep1[defaults_slot, eROLE.Devastator] == "Heavy Ranged") {
						_wep1 = choose("Multi-Melta", "Lascannon", "Missile Launcher", "Heavy Bolter");
					}
					break;
				case "scouts":
                    _unit_type = "scout";                    
					_rolename = roles.scout;
					_erole = eROLE.Scout;
					break;
				case "dreadnoughts":
					_rolename = roles.dreadnought;
					_unit_type = "dreadnought";
					if (scr_has_adv("Venerable Ancients")) {
						_rolename = "Venerable " + roles.dreadnought;
					}
					_erole = eROLE.Dreadnought;

					if (_coy.coy == 9) {
						_wep1 = "Missile Launcher"; 
					}
					if (_coy.coy == 1) {
						_rolename = "Venerable " + roles.dreadnought;
						_wep2 = "Plasma Cannon";
					}
					break;
			
				// VETERANS
				case "veterans":
					_rolename = roles.veteran;
					_erole = eROLE.Veteran;
					break;
			
				case "terminators":
					_rolename = roles.terminator;
					_erole = eROLE.Terminator;
					break;

				// SPECIALISTS
				case "captains":
					switch (_coy.coy) {
						case 1:
							name[_coy.coy][k] = honor_captain_name != "" ? honor_captain_name : global.name_generator.generate_space_marine_name();
							break;
						case 2:
							name[_coy.coy][k] = watch_master_name != "" ? watch_master_name : global.name_generator.generate_space_marine_name();
							break;
						case 3:
							name[_coy.coy][k] = arsenal_master_name != "" ? arsenal_master_name : global.name_generator.generate_space_marine_name();
							break;
						case 4:
							name[_coy.coy][k] = lord_admiral_name != "" ? lord_admiral_name : global.name_generator.generate_space_marine_name();
							break;
						case 5:
							name[_coy.coy][k] = march_master_name != "" ? march_master_name : global.name_generator.generate_space_marine_name();
							break;
						case 6:
							name[_coy.coy][k] = rites_master_name != "" ? rites_master_name : global.name_generator.generate_space_marine_name();
							break;
						case 7:
							name[_coy.coy][k] = chief_victualler_name != "" ? chief_victualler_name : global.name_generator.generate_space_marine_name();
							break;
						case 8:
							name[_coy.coy][k] = lord_executioner_name != "" ? lord_executioner_name : global.name_generator.generate_space_marine_name();
							break;
						case 9:
							name[_coy.coy][k] = relic_master_name != "" ? relic_master_name : global.name_generator.generate_space_marine_name();
							break;
						case 10:
							name[_coy.coy][k] = recruiter_name != "" ? recruiter_name : global.name_generator.generate_space_marine_name();
							break;
					}
					commands++;
					_rolename = roles.captain;
					_erole = eROLE.Captain;
					_wep2 = choose_weighted(weapon_weighted_lists.pistols);
					if (equal_specialists == false && _coy.coy == 8) {
						_mobi = "Jump Pack";
					}
					if (_coy.coy == 1 && _coy.terminators > 0) {
						_wep1 = "Relic Blade";
						_wep2 = choose("Storm Shield", "Storm Bolter");
						_armour = scr_has_adv("Crafters") ? "Tartaros" : "Terminator Armour";
					}
					break;
				case "chaplains":
					commands++;
					_rolename = roles.chaplain;
					_erole = eROLE.Chaplain;
					_wep2 = choose_weighted(weapon_weighted_lists.pistols);
					if (equal_specialists == false && _coy.coy == 8) {
						_mobi = "Jump Pack";
					}
					if(_coy.coy == 1 && _coy.terminators > 0){
						_armour = scr_has_adv("Crafters") ? "Tartaros" : "Terminator Armour";
						_wep2 = wep2[defaults_slot][eROLE.Terminator];
					}
					break;
				case "apothecaries":
					commands++;
					_rolename = roles.apothecary;
					_erole = eROLE.Apothecary;
					if (equal_specialists == false && _coy.coy == 8) {
						_mobi = "Jump Pack";
					}
					if(_coy.coy == 1 && _coy.terminators > 0){
						_armour = scr_has_adv("Crafters") ? "Tartaros" : "Terminator Armour";
						_wep1 = wep1[defaults_slot][eROLE.Terminator];
						_wep2 = wep2[defaults_slot][eROLE.Terminator];
					}
					break;
				case "techmarines":
					commands++;
					_rolename = roles.techmarine;
					_erole = eROLE.Techmarine;
					if (_coy.coy == 1) {
						if(_coy.terminators > 0){
							_armour = scr_has_adv("Crafters") ? "Tartaros" : "Terminator Armour";
							_wep2 = wep2[defaults_slot][eROLE.Terminator];
						}
						if (!_is_terminator(_armour)) {
							if (scr_has_disadv("Poor Equipment")) {
								_armour = "MK6 Corvus";
							} else {
								_armour = "Artificer Armour";
							}
						}
					}
					break;
				case "librarians":
					commands++;
					_rolename = roles.librarian;
					_erole = eROLE.Librarian;
					if (equal_specialists == false && _coy.coy == 8) {
						_mobi = "Jump Pack";
					}
					if(_coy.coy == 1 && _coy.terminators > 0){
						_armour = scr_has_adv("Crafters") ? "Tartaros" : "Terminator Armour";
						_wep2 = wep2[defaults_slot][eROLE.Terminator];
					}
					break;
				case "champions":
					_rolename = roles.champion;
					_erole = eROLE.Champion;
					if(_coy.coy == 1 && _coy.terminators > 0){
						_armour = scr_has_adv("Crafters") ? "Tartaros" : "Terminator Armour";
							_wep1 = "Thunder Hammer";
						_wep2 = wep2[defaults_slot][eROLE.Terminator];
						if (global.chapter_name == "Dark Angels") {
								_wep1 = "Heavy Thunder Hammer";
								_wep2 = "";
						}
					}
					break;
				case "ancients":
					_rolename = roles.ancient;
					_erole = eROLE.Ancient;
					if(_coy.coy == 1 && _coy.terminators > 0){
						_armour = scr_has_adv("Crafters") ? "Tartaros" : "Terminator Armour";
						_wep2 = wep2[defaults_slot][eROLE.Terminator];
					}
					break;

			
				// VEHICLES
				case "rhinos":
					_is_vehicle = true;
					_rolename = "Rhino";
					_erole = eROLE.Rhino;
					_wep1 = "Storm Bolter";
					_wep2 = "HK Missile";
					_accessory = "Dozer Blades";
					if (_coy.coy == 1) {
						_upgrade = "Artificer Hull";
					}
					break;
				case "landspeeders":
					_is_vehicle = true;
					_rolename = "Land Speeder";
					_erole = eROLE.LandSpeeder;
					_wep1 = "Heavy Bolter";
					break;
				case "whirlwinds":
					_is_vehicle = true;
					_rolename = "Whirlwind";
					_erole = eROLE.Whirlwind;
					_wep1 = "Whirlwind Missiles";
					_wep2 = "HK Missile";
					break;
				case "landraiders":
					_is_vehicle = true;
					_rolename = "Land Raider";
					_erole = eROLE.LandRaider;
					_upgrade = "Heavy Armour";
					var variant = choose(1, 1, 2, 3);
					// 50%
					if (variant == 1) {
						_wep1 = "Twin Linked Heavy Bolter Mount";
						_wep2 = "Twin Linked Lascannon Sponsons";
						_wep3 = "HK Missile";
						_accessory = "Searchlight";
					}
					// 25%
					if (variant == 2) {
						_wep1 = "Twin Linked Assault Cannon Mount";
						_wep2 = "Hurricane Bolter Sponsons";
						_wep3 = "Storm Bolter";
						_accessory = "Frag Assault Launchers";
					}
					//25%
					if (variant == 3) {
						_wep1 = "Twin Linked Assault Cannon Mount";
						_wep2 = "Flamestorm Cannon Sponsons";
						_wep3 = "Storm Bolter";
						_accessory = "Frag Assault Launchers";
					}
					break;
				case "predators":
					_is_vehicle = true;
					_rolename = "Predator";
					_erole = eROLE.Predator;
					var variant = choose(1, 1, 2, 3);
					// 1st company relic predators
					if (_coy.coy == 1) {
						_upgrade = "Artificer Hull";
						var predtype = choose(1, 2, 3, 4);
						switch (predtype) {
							case 1:
								_wep1 = "Plasma Destroyer Turret";
								_wep2 = "Lascannon Sponsons";
								_wep3 = "HK Missile";
								_accessory = "Searchlight";
								break;
							case 2:
								_wep1 = "Heavy Conversion Beamer Turret";
								_wep2 = "Lascannon Sponsons";
								_wep3 = "HK Missile";
								_accessory = "Searchlight";
								break;
							case 3:
								_wep1 = "Flamestorm Cannon Turret";
								_wep2 = "Heavy Flamer Sponsons";
								_wep3 = "Storm Bolter";
								_accessory = "Dozer Blades";
								break;
							case 4:
								_wep1 = "Magna-Melta Turret";
								_wep2 = "Heavy Flamer Sponsons";
								_wep3 = "Storm Bolter";
								_accessory = "Dozer Blades";
								break;
						}
					} else {
						//9th company and extras
						var _variant = choose(1, 2);
						if (_variant == 1) {
							_wep1 = "Twin Linked Lascannon Turret";
							_wep2 = "Lascannon Sponsons";
							_wep3 = "HK Missile";
							_accessory = "Searchlight";
						}
						if (_variant == 2) {
							_wep1 = "Autocannon Turret";
							_wep2 = "Heavy Bolter Sponsons";
							_wep3 = "Storm Bolter";
							_accessory = "Dozer Blades";
						}
					}
					break;
			}			
			repeat(_count){
				if(_is_vehicle){
					add_veh_to_company(_rolename, _coy.coy, v, _wep1, _wep2, _wep3, _upgrade, _accessory);
					v++;
					man_size += 10;
				} else {
					add_unit_to_company(_unit_type, _coy.coy, k, _rolename, _erole, _wep1,_wep2, _gear,_mobi,_armour);
					k++;
					man_size++;
					if(_is_terminator(_armour)){
						man_size++;
					}
				}
			}
			switch(_coy.coy){
				case 1: firsts = k; break;
				case 2: seconds = k; break;
				case 3: thirds = k; break;
				case 4: fourths = k; break;
				case 5: fifths = k; break;
				case 6: sixths = k; break;
				case 7: sevenths = k; break;
				case 8: eighths = k; break;
				case 9: ninths = k; break;
				case 10: tenths = k; break;
			}
		}
	}

	#endregion


	var c;
	c = 0;
	k = 0;
	company = 0;
	repeat(200) {
		c += 1;
		if (k = 0) {
			if (role[0, c] != "") and(role[0, c + 1] = "") then k = c;
		}
	}


	// obj_controller.marines-=commands;


	scr_add_item("Bolter", 20);
	scr_add_item("Chainsword", 20);
	scr_add_item("Bolt Pistol", 5);
	scr_add_item("Heavy Weapons Pack", 10);
	scr_add_item(wep1[defaults_slot, eROLE.Scout ], 20);
	scr_add_item(wep2[defaults_slot, eROLE.Scout ], 20);

	scr_add_item("Scout Armour", 20);
	scr_add_item("MK8 Errant", 1);
	scr_add_item("MK7 Aquila", 10);

	scr_add_item("Jump Pack", 10);

	scr_add_item("Lascannon", 5);
	scr_add_item("Heavy Bolter", 5);
	
	scr_add_item("Bike", 40);

	if(struct_exists(obj_creation, "extra_equipment") ){
		for(var e = 0; e < array_length(obj_creation.extra_equipment); e++){
			var e_name = obj_creation.extra_equipment[e][0];
			var e_qty = obj_creation.extra_equipment[e][1];
			scr_add_item(e_name, e_qty);
		}
	}

	if(scr_has_disadv("Sieged")){
		scr_add_item("Narthecium", 4);
		scr_add_item(wep1[defaults_slot, eROLE.Apothecary], 4);
		scr_add_item(wep2[defaults_slot,  eROLE.Apothecary], 4);
		scr_add_item("Psychic Hood", 4);
		scr_add_item("Force Staff", 4);
		scr_add_item("Plasma Pistol", 4);
		scr_add_item("Company Standard", 4);

		if(scr_has_adv("Crafters")){
			scr_add_item("Tartaros", 10);
		} else {
			scr_add_item("Terminator Armour", 10);
		}

		scr_add_item("MK7 Aquila", 200);
		scr_add_item("Bolter", 200);
		scr_add_item("Chainsword", 200);
		scr_add_item("Jump Pack", 80);
		scr_add_item("Bolt Pistol", 80);
		scr_add_item("Heavy Bolter", 40);
		scr_add_item("Lascannon", 40);
		scr_add_item("Power Sword", 12);
		scr_add_item("Rosarius", 4);
	}
	if (!scr_has_disadv("Sieged")) {
		scr_add_item("Dreadnought", 6);
		scr_add_item("Close Combat Weapon", 6);
	}
	if (scr_has_adv("Venerable Ancients")) {
		scr_add_item("Dreadnought", 4);
		scr_add_item("Close Combat Weapon", 4);
	}

	// man_size+=80;// bikes


	if (scr_has_adv("Crafters")) && (scr_has_adv("Melee Enthusiasts")) {
        scr_add_item("MK3 Iron Armour", irandom_range(2, 12));
	}

	if (scr_has_adv("Crafters")) && (!scr_has_adv("Melee Enthusiasts")) {
        scr_add_item("MK4 Maximus", irandom_range(3, 18));
	}

	if(scr_has_adv("Ancient Armoury")){
		scr_add_item("MK4 Maximus", irandom_range(5, 10));
		scr_add_item("MK5 Heresy", irandom_range(5, 10));
		scr_add_item("MK3 Iron Armour", irandom_range(1, 5));
		scr_add_item("MK6 Corvus", irandom_range(10, 15));
		scr_add_item("MK7 Aquila", -10);
		scr_add_item("MK8 Errant", -1);
	}

    gene_slaves = [];
    
	var bloo = 0,
		o = 0;
	if (scr_has_disadv("Blood Debt")) {
		bloo = 1;
		if (instance_exists(obj_controller)) {
			obj_controller.blood_debt = 1;
			penitent = 1;
			penitent_max = (obj_creation.strength * 1000) + 300;
			penitent_current = 300;
			penitent_end = obj_creation.strength * 48;
		}
	} else {
		if (fleet_type == ePlayerBase.penitent) {
			penitent = 1;
			penitent_max = (obj_creation.strength * 60);
			penitent_current = 1;
			penitent_end = obj_creation.strength * 5;

			if (obj_creation.chapter_name = "Lamenters") {
				penitent_max = 600;
				penitent_end = 600;
				// obj_controller.loyalty=50;obj_controller.loyalty_hidden=50;
			}
		}
	}
}

/// @description helper function to streamline code inside of scr_initialize_custom, should only be used as part of
/// game setup and not during normal gameplay
function add_veh_to_company(name, company, slot, wep1, wep2, wep3, upgrade, accessory) {
	// log_message($"adding vehicle name {name} company {company} slot {slot} ")
	obj_ini.veh_race[company, slot] = 1;
	obj_ini.veh_loc[company, slot] = obj_ini.home_name;
	obj_ini.veh_role[company, slot] = name;
	obj_ini.veh_wep1[company, slot] = wep1;
	obj_ini.veh_wep2[company, slot] = wep2;
	obj_ini.veh_wep3[company, slot] = wep3;
	obj_ini.veh_upgrade[company, slot] = upgrade;
	obj_ini.veh_acc[company, slot] = accessory;
	obj_ini.veh_hp[company, slot] = 100;
	obj_ini.veh_chaos[company, slot] = 0;
	obj_ini.veh_pilots[company, slot] = 0;
	obj_ini.veh_lid[company, slot] = -1;
	obj_ini.veh_wid[company, slot] = 2;
}

/// @description helper function to streamline code inside of scr_initialize_custom, should only be used as part of
/// game setup and not during normal gameplay.
/// each item slot can be "" or "default" or a named item. "" will assign items from the available item pool. 
/// Use "" if you want to set weapons and gear via squad layouts.
/// "default" will set it to the value in the default slot for the given role, see `load_default_gear`
function add_unit_to_company(ttrpg_name, company, slot, role_name, role_id, wep1="default", wep2="default", gear="default", mobi="default", armour="default"){
	// log_message($"adding unit to company ttrpg_name {ttrpg_name}, company {company}, slot {slot}, role_name {role_name}, role_id {role_id}")
	obj_ini.TTRPG[company][slot] = new TTRPG_stats("chapter", company, slot, ttrpg_name);
	obj_ini.race[company][slot] = 1;
	obj_ini.loc[company][slot] = obj_ini.home_name;
	obj_ini.role[company][slot] = role_name;
	
	if(obj_ini.name[company][slot] == ""){
		obj_ini.name[company][slot] = global.name_generator.generate_space_marine_name();
	}
	var spawn_unit = fetch_unit([company,slot]);

	if(wep1 != ""){
		if(wep1 == "default"){
			spawn_unit.update_weapon_one(obj_ini.wep1[obj_ini.defaults_slot][role_id], false, false);
		} else {
			spawn_unit.update_weapon_one(wep1, false, false);
		}
	}
	if(wep2 != ""){
		if(wep2 == "default"){
			spawn_unit.update_weapon_two(obj_ini.wep2[obj_ini.defaults_slot][role_id], false, false);
		} else {
			spawn_unit.update_weapon_two(wep2, false, false);
		}
	}
	if(armour != ""){
		if(armour == "default"){
			spawn_unit.update_armour(obj_ini.armour[obj_ini.defaults_slot][role_id], false, false);
		} else {
			spawn_unit.update_armour(armour, false, false);
		}
		
		// show_debug_message($"updating coy {company}:{slot} {role_name} armour to {armour}: {_msg} : {spawn_unit.armour()} : {obj_ini.armour[company][slot]}");
	}
	if(gear != ""){
		if(gear == "default"){
			spawn_unit.update_gear(obj_ini.gear[obj_ini.defaults_slot][role_id], false, false);
		} else {
			spawn_unit.update_gear(gear, false, false);
		}
	}
	if(mobi != ""){
		if(mobi == "default"){
			spawn_unit.update_mobility_item(obj_ini.mobi[obj_ini.defaults_slot][role_id], false, false);
		} else {
			spawn_unit.update_mobility_item(mobi, false, false);
		}
	}
    if(ttrpg_name == "marine" || ttrpg_name == "scout"){
        spawn_unit.marine_assembling();
    } else {
        spawn_unit.roll_age();
        spawn_unit.roll_experience();
    }   
	if(role_id == eROLE.HonourGuard){
		spawn_unit.add_trait(choose("guardian", "champion", "observant", "perfectionist","natural_leader"));
	}
	if(role_id == eROLE.Champion){
		spawn_unit.add_trait("champion");
	}
	if(role_id == eROLE.Apothecary){
		spawn_unit.add_trait("soft_target");
	}
	if(role_id == eROLE.Librarian){
		if (scr_has_adv("Favoured By The Warp") && (roll_dice_unit(1, 6, "high", spawn_unit) >= 4)) {
			spawn_unit.add_trait("favoured_by_the_warp");
		} else if (roll_dice_unit(1, 10, "high", spawn_unit) == 10) {
			spawn_unit.add_trait("favoured_by_the_warp");
		}

		if (role_name == obj_ini.role[100][eROLE.Librarian]) {
			spawn_unit.psionic = irandom_range(8, 10);
		} else if (role_name == "Codiciery") {
			spawn_unit.psionic = irandom_range(5, 7);
			if (roll_dice_unit(1, 6, "high", spawn_unit) < 4) {
				spawn_unit.update_gear(obj_ini.gear[obj_ini.defaults_slot][eROLE.Tactical], false, false);
			}
			if (roll_dice_unit(1, 6, "high", spawn_unit) < 4) {
				spawn_unit.update_weapon_one(choose("Force Axe", "Force Sword"), false, false);
			}
		} else if (role_name == "Lexicanum") {
			spawn_unit.psionic = irandom_range(2, 4);
			spawn_unit.update_weapon_one(choose("Force Axe", "Force Sword"), false, false);
			spawn_unit.update_gear(obj_ini.gear[obj_ini.defaults_slot][eROLE.Tactical], false, false);
		}
		spawn_unit.update_powers();
	}
	
	return spawn_unit;
}

///@mixin obj_ini
function load_chapter_master_equipment(){
	var chapter_master_equip = {};
	switch (obj_ini.master_melee) {
		case 1:
			chapter_master_equip.wep1 = "Power Fist";
			chapter_master_equip.wep2 = "Power Fist";
			break;
		case 2:
			chapter_master_equip.wep1 = "Lightning Claw";
			chapter_master_equip.wep2 = "Lightning Claw";
			break;
		case 3:
			chapter_master_equip.wep1 = "Relic Blade";
			//wep1[0,1]="Relic Blade&MNR|";
			break;
		case 4:
			chapter_master_equip.wep1 = "Thunder Hammer";
			break;
		case 5:
			chapter_master_equip.wep1 = "Power Sword";
			break;
		case 6:
			chapter_master_equip.wep1 = "Power Axe";
			break;
		case 7:
			chapter_master_equip.wep1 = "Eviscerator";
			chapter_master_equip.wep2 = "";
			break;
		case 8:
			chapter_master_equip.wep1 = "Force Staff";
			break;
	}

	if (!array_contains([1,2,7], master_melee)){
		switch (master_ranged) {
			case 1:
				chapter_master_equip.wep2 = "Boltstorm Gauntlet";
				break;
			case 2:
				chapter_master_equip.wep2 = "Infernus Pistol";
				break;
			case 3:
				chapter_master_equip.wep2 = "Plasma Pistol";
				break;
			case 4:
				chapter_master_equip.wep2 = "Plasma Gun";
				break;
			case 5:
				chapter_master_equip.wep2 = "Heavy Bolter";
				break;
			case 6:
				chapter_master_equip.wep2 = "Meltagun";
				break;
			case 7:
				chapter_master_equip.wep2 = "Storm Shield";
				break;
		}
	}

	chapter_master_equip.armour = "Artificer Armour";
	chapter_master_equip.gear = "Iron Halo";
	chapter_master_equip.mobi = "";
	chapter_master_equip.bionics = 0;

	last_artifact = find_open_artifact_slot();
	var arti;

	// From json
	if(struct_exists(obj_creation, "artifact") ){
		if(is_struct(obj_creation.artifact) && struct_exists(obj_creation.artifact, "name")){
			arti = obj_ini.artifact_struct[last_artifact];
			arti.name = obj_creation.artifact.name;
			arti.custom_description = obj_creation.artifact.description;
			obj_ini.artifact[last_artifact] = obj_creation.artifact.base_weapon_type;
			arti.bearer = [0,1];
			obj_ini.artifact_identified[last_artifact] = 0;
			chapter_master_equip.wep1 = last_artifact;
		} else if(is_array(obj_creation.artifact) && array_length(obj_creation.artifact) > 0){
			for(var a = 0; a < array_length(obj_creation.artifact); a++){
				arti = obj_ini.artifact_struct[last_artifact];
				arti.name = obj_creation.artifact[a].name;
				arti.custom_description = obj_creation.artifact[a].description;
				obj_ini.artifact[last_artifact] = obj_creation.artifact[a].base_weapon_type;
				arti.bearer = [0,1];
				obj_ini.artifact_identified[last_artifact] = 0;
				switch (obj_creation.artifact[a].slot){
					case "wep1": chapter_master_equip.wep1 = last_artifact; break;
					case "wep2": chapter_master_equip.wep2 = last_artifact; break;
					case "armour": chapter_master_equip.armour = last_artifact; break;
					case "gear": chapter_master_equip.gear = last_artifact; break;
					case "mobi": chapter_master_equip.mobi = last_artifact; break;
				}
				last_artifact++;
			}
		}
	}

	if(struct_exists(obj_creation, "chapter_master")){
		if(struct_exists(obj_creation.chapter_master, "gear") && obj_creation.chapter_master.gear != ""){
			chapter_master_equip.gear = obj_creation.chapter_master.gear;
		}
		if(struct_exists(obj_creation.chapter_master, "mobi") && obj_creation.chapter_master.mobi != ""){
			chapter_master_equip.mobi = obj_creation.chapter_master.mobi;
		}
		if(struct_exists(obj_creation.chapter_master, "armour") && obj_creation.chapter_master.armour != ""){
			chapter_master_equip.armour = obj_creation.chapter_master.armour;
		}
		if(struct_exists(obj_creation.chapter_master, "bionics") && obj_creation.chapter_master.bionics != ""){
			for (var i = 0; i < real(obj_creation.chapter_master.bionics); i++) {
				chapter_master_equip.bionics += 1;
			}
		}
	}

	return chapter_master_equip;
}