enum Role {
	CHAPTER_MASTER = 1,
	HONOUR_GUARD = 2,
	VETERAN = 3,
	TERMINATOR = 4,
	CAPTAIN = 5,
	DREADNOUGHT = 6,
	CHAMPION = 7,
	TACTICAL = 8,
	DEVASTATOR = 9,
	ASSAULT = 10,
	ANCIENT = 11,
	SCOUT = 12,
	CHAPLAIN = 14,
	APOTHECARY = 15,
	TECHMARINE = 16,
	LIBRARIAN = 17,
	SERGEANT = 18,
	VETERAN_SERGEANT = 19
}

function complex_livery_default(){
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
function progenitor_livery(chapter, specific="none"){
	//default
	var livery_data = complex_livery_default();	
	//custom for chapters
	if (chapter=="Space Wolves"){
		livery_data = {
			sgt : {
				helm_pattern:3,
				helm_primary :Colors.Fenrisian_Grey,
				helm_secondary : Colors.Red,
				helm_detail : 0,
				helm_lens : Colors.Red,
			},
			vet_sgt : {
				helm_pattern:3,
				helm_primary : Colors.Fenrisian_Grey,
				helm_secondary : Colors.Black,
				helm_detail : 0,
				helm_lens : Colors.Red,
			},
			captain : {
				helm_pattern:3,
				helm_primary : Colors.Fenrisian_Grey,
				helm_secondary : Colors.Black,
				helm_detail : 0,
				helm_lens : Colors.Red,
			},
			veteran : {
				helm_pattern:0,
				helm_primary : Colors.White,
				helm_secondary : Colors.White,
				helm_detail : Colors.White,
				helm_lens : Colors.Red,			
			}		
		}
	}else if (chapter == "Dark Angels"){
		livery_data = {
			sgt: {
				helm_pattern: 0,
				helm_primary: obj_creation.main_color,
				helm_secondary: obj_creation.main_color,
				helm_detail: obj_creation.trim_color,
				helm_lens: obj_creation.lens_color,
			},
			vet_sgt: {
				helm_pattern: 1,
				helm_primary: obj_creation.main_color,
				helm_secondary: obj_creation.main_color,
				helm_detail: obj_creation.trim_color,
				helm_lens: obj_creation.lens_color,
			},
			captain: {
				helm_pattern: 0,
				helm_primary: obj_creation.main_color,
				helm_secondary: obj_creation.main_color,
				helm_detail: obj_creation.trim_color,
				helm_lens: obj_creation.lens_color,
			},
			veteran: {
				helm_pattern: 0,
				helm_primary: obj_creation.main_color,
				helm_secondary: obj_creation.main_color,
				helm_detail: obj_creation.trim_color,
				helm_lens: obj_creation.lens_color,
			}
		}
	}else if (chapter=="Raven Guard"){
		livery_data = {
			sgt : {
				helm_pattern:0,
				helm_primary :Colors.White,
				helm_secondary : Colors.White,
				helm_detail : 0,
				helm_lens : Colors.Red,
			},
			vet_sgt : {
				helm_pattern:1,
				helm_primary : Colors.Black,
				helm_secondary : Colors.White,
				helm_detail : 0,
				helm_lens : Colors.Red,
			},
			captain : {
				helm_pattern:0,
				helm_primary : Colors.White,
				helm_secondary : Colors.White,
				helm_detail : 0,
				helm_lens : Colors.Red,
			},
			veteran : {
				helm_pattern:0,
				helm_primary : Colors.Black,
				helm_secondary : Colors.Black,
				helm_detail : Colors.Black,
				helm_lens : Colors.Green,			
			}		
		}
	}else if (chapter=="Salamanders"){
		livery_data = {
			sgt : {
				helm_pattern:0,
				helm_primary :Colors.Black,
				helm_secondary : Colors.Black,
				helm_detail : 0,
				helm_lens : Colors.Red,
			},
			vet_sgt : {
				helm_pattern:1,
				helm_primary : Colors.Black,
				helm_secondary : Colors.Red,
				helm_detail : 0,
				helm_lens : Colors.Red,
			},
			captain : {
				helm_pattern:0,
				helm_primary : Colors.Firedrake_Green,
				helm_secondary : Colors.Firedrake_Green,
				helm_detail : 0,
				helm_lens : Colors.Red,
			},
			veteran : {
				helm_pattern:0,
				helm_primary : Colors.Black,
				helm_secondary : Colors.Black,
				helm_detail : Colors.Black,
				helm_lens : Colors.Green,			
			}		
		}
	}else if (chapter=="White Scars"){
		livery_data = {
			sgt : {
				helm_pattern:0,
				helm_primary :Colors.White,
				helm_secondary : Colors.White,
				helm_detail : 0,
				helm_lens : Colors.Red,
			},
			vet_sgt : {
				helm_pattern:1,
				helm_primary : Colors.White,
				helm_secondary : Colors.Red,
				helm_detail : 0,
				helm_lens : Colors.Red,
			},
			captain : {
				helm_pattern:0,
				helm_primary : Colors.White,
				helm_secondary : Colors.White,
				helm_detail : 0,
				helm_lens : Colors.Red,
			},
			veteran : {
				helm_pattern:0,
				helm_primary : Colors.White,
				helm_secondary : Colors.White,
				helm_detail : Colors.White,
				helm_lens : Colors.Green,			
			}		
		}
	}else if (chapter=="Iron Hands"){
		livery_data = {
			sgt : {
				helm_pattern:0,
				helm_primary :Colors.White,
				helm_secondary : Colors.White,
				helm_detail : 0,
				helm_lens : Colors.Red,
			},
			vet_sgt : {
				helm_pattern:1,
				helm_primary : Colors.Black,
				helm_secondary : Colors.White,
				helm_detail : 0,
				helm_lens : Colors.Red,
			},
			captain : {
				helm_pattern:0,
				helm_primary : Colors.White,
				helm_secondary : Colors.White,
				helm_detail : 0,
				helm_lens : Colors.Red,
			},
			veteran : {
				helm_pattern:0,
				helm_primary : Colors.Black,
				helm_secondary : Colors.Black,
				helm_detail : Colors.Black,
				helm_lens : Colors.Green,			
			}		
		}
	}else if (chapter=="Ultramarines"){
		livery_data = {
			sgt : {
				helm_pattern:0,
				helm_primary : Colors.Red,
				helm_secondary : Colors.Red,
				helm_detail : Colors.Red,
				helm_lens : Colors.Green,
			},
			vet_sgt : {
				helm_pattern:1,
				helm_primary : Colors.Red,
				helm_secondary : Colors.White,
				helm_detail : Colors.Red,
				helm_lens : Colors.Green,
			},
			captain : {
				helm_pattern:0,
				helm_primary : Colors.Dark_Ultramarine,
				helm_secondary : Colors.Dark_Ultramarine,
				helm_detail : Colors.Dark_Ultramarine,
				helm_lens : Colors.Red,
			},
			veteran : {
				helm_pattern:0,
				helm_primary : Colors.White,
				helm_secondary : Colors.White,
				helm_detail : Colors.White,
				helm_lens : Colors.Red,			
			}				
		}
	}else if (chapter=="Imperial Fists"){
		livery_data = {
			sgt : {
				helm_pattern:0,
				helm_primary : Colors.Black,
				helm_secondary : Colors.Black,
				helm_detail : Colors.Red,
				helm_lens : Colors.Green,
			},
			vet_sgt : {
				helm_pattern:1,
				helm_primary : Colors.Black,
				helm_secondary : Colors.White,
				helm_detail : Colors.Red,
				helm_lens : Colors.Green,
			},
			captain : {
				helm_pattern:0,
				helm_primary : Colors.Dark_Gold,
				helm_secondary : Colors.Dark_Gold,
				helm_detail : Colors.Dark_Gold,
				helm_lens : Colors.Red,
			},
			veteran : {
				helm_pattern:0,
				helm_primary : Colors.Red,
				helm_secondary : Colors.Red,
				helm_detail : Colors.Red,
				helm_lens : Colors.Green,			
			}				
		} 
	}else if (chapter=="Blood Angels"){
		livery_data = {
			sgt : {
				helm_pattern:1,
				helm_primary : Colors.Sanguine_Red,
				helm_secondary : Colors.Sanguine_Red,
				helm_detail : Colors.Lighter_Black,
				helm_lens : Colors.Lime,
			},
			vet_sgt : {
				helm_pattern:1,
				helm_primary : Colors.Gold,
				helm_secondary : Colors.Black,
				helm_detail : Colors.Gold,
				helm_lens : Colors.Lime,
			},
			captain : {
				helm_pattern:0,
				helm_primary : Colors.Sanguine_Red,
				helm_secondary : Colors.Sanguine_Red,
				helm_detail : Colors.Gold,
				helm_lens : Colors.Lime,
			},
			veteran : {
				helm_pattern:0,
				helm_primary : Colors.Gold,
				helm_secondary : Colors.Gold,
				helm_detail : Colors.Gold,
				helm_lens : Colors.Lime,			
			}				
		}
	}else if (global.chapter_name=="Blood Ravens"){
		livery_data = {
			sgt : {
				helm_pattern:0,
				helm_primary : Colors.Black,
				helm_secondary : Colors.Black,
				helm_detail : Colors.Black,
				helm_lens : Colors.Lime,
			},
			vet_sgt : {
				helm_pattern:1,
				helm_primary : Colors.Black,
				helm_secondary : Colors.White,
				helm_detail : Colors.Black,
				helm_lens : Colors.Lime,
			},
			captain : {
				helm_pattern:0,
				helm_primary : Colors.Copper,
				helm_secondary : Colors.Copper,
				helm_detail : Colors.Copper,
				helm_lens : Colors.Lime,
			},
			veteran : {
				helm_pattern:0,
				helm_primary : Colors.White,
				helm_secondary : Colors.White,
				helm_detail : Colors.White,
				helm_lens : Colors.Lime,			
			}				
		}
	}else if (global.chapter_name=="Minotaurs"){
		livery_data = {
			sgt : {
				helm_pattern:0,
				helm_primary : Colors.Black,
				helm_secondary : Colors.Black,
				helm_detail : Colors.Black,
				helm_lens : Colors.Red,
			},
			vet_sgt : {
				helm_pattern:1,
				helm_primary : obj_creation.main_color,
				helm_secondary : Colors.Black,
				helm_detail : obj_creation.main_color,
				helm_lens : Colors.Red,
			},
			captain : {
				helm_pattern:2,
				helm_primary : obj_creation.main_color,
				helm_secondary : Colors.Dark_Red,
				helm_detail : obj_creation.main_color,
				helm_lens : Colors.Red,
			},
			veteran : {
				helm_pattern:0,
				helm_primary : obj_creation.main_color,
				helm_secondary : obj_creation.main_color,
				helm_detail : obj_creation.main_color,
				helm_lens : Colors.Red,			
			}				
		}
	}else {
		livery_data =  {
			sgt : {
				helm_pattern:0,
				helm_primary : Colors.Red,
				helm_secondary : Colors.Red,
				helm_detail : Colors.Red,
				helm_lens : Colors.Green,
			},
			vet_sgt : {
				helm_pattern:1,
				helm_primary : Colors.Red,
				helm_secondary : Colors.White,
				helm_detail : Colors.Red,
				helm_lens : Colors.Green,
			},
			captain : {
				helm_pattern:0,
				helm_primary : obj_creation.main_color,
				helm_secondary : obj_creation.main_color,
				helm_detail : obj_creation.main_color,
				helm_lens : obj_creation.lens_color,
			},
			veteran : {
				helm_pattern:0,
				helm_primary : Colors.White,
				helm_secondary : Colors.White,
				helm_detail : Colors.White,
				helm_lens : Colors.Red,			
			}			
		}	
	}
	if (specific=="none"){
		return livery_data;
	} else {
		return livery_data[$ specific];
	}
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
		"Raven Guard"
	]
	for (i=1;i<10;i++){
		if (global.chapter_name==founding_chapters[i] || obj_ini.progenitor==i){
			return founding_chapters[i];
		}
	}
	return "";
}

function scr_initialize_custom() {


	progenitor = obj_creation.founding;
	successors = obj_creation.successors;
	homeworld_rule = obj_creation.homeworld_rule;


	// Initializes all of the marine/vehicle/ship variables for the chapter.

	techs = 8;
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
	siege = 0;
	devastator = 20;

	recruit_trial = obj_creation.aspirant_trial;
	purity = obj_creation.purity;
	stability = obj_creation.stability;

	// show_message(instance_number(obj_controller));

	global.chapter_name = obj_creation.chapter;
	global.founding = obj_creation.founding;
	global.founding_secret = "";
	global.game_seed = floor(random(99999999)) + string_to_integer(global.chapter_name) + string_to_integer(obj_creation.chapter_master_name);

	use_custom_icon = 0;
	if (string_count("custom", obj_creation.icon_name) > 0) {
		use_custom_icon = global.game_seed;

		var ta, na;
		ta = string(obj_creation.custom_icon) + ".png";
		na = string(global.game_seed) + ".png";

		/* if (file_exists(working_directory + "\icons_save\"+string(ta))){
		    file_copy(working_directory + "\icons\"+string(ta),working_directory + "\icons_save\"+string(na));
		}*/
	}

	if (progenitor = 10) { // Pretty sure that's random?
		var legions = ["Dark Angels",
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
		]
		global.founding_secret = legions[irandom(17)];
	}




	company_title[0] = "";
	array_copy(company_title, 1, obj_creation.company_title, 1, 40);




	home_name = obj_creation.homeworld_name;
	obj_creation.restart_home_name = home_name;
	chapter_name = obj_creation.chapter;
	// fortress_name="";
	flagship_name = obj_creation.flagship_name;
	obj_creation.restart_flagship_name = flagship_name;
	sector_name = global.name_generator.generate_sector_name();
	icon = obj_creation.icon;
	icon_name = obj_creation.icon_name;
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

	if (array_contains(obj_creation.dis, "Tolerant")) {
		tolerant = 1;
	}
	adv = obj_creation.adv;
	dis = obj_creation.dis;

	battle_barges = 0;
	strike_cruisers = 0;
	gladius = 0;
	hunters = 0;

	recruiting_type = obj_creation.recruiting;
	recruit_trial = obj_creation.aspirant_trial;
	recruiting_name = obj_creation.recruiting_name;
	home_type = obj_creation.homeworld;
	home_name = obj_creation.homeworld_name;
	fleet_type = obj_creation.fleet_type;

	if (obj_creation.fleet_type != 1) {
		battle_barges = 1;
		if (array_contains(obj_creation.adv, "Kings of Space")) battle_barges += 1;
		strike_cruisers = 6;
		if (array_contains(obj_creation.adv, "Boarders")) strike_cruisers += 2;
		gladius = 7;
		hunters = 3;
		// obj_controller.fleet_type="Fleet";
	}
	if (obj_creation.fleet_type = 1) {
		strike_cruisers = 8;
		if (array_contains(obj_creation.adv, "Boarders")) strike_cruisers += 2;
		gladius = 7;
		hunters = 3;
		if (array_contains(obj_creation.adv, "Kings of Space")) battle_barges += 1;
		// obj_controller.fleet_type="Homeworld";
	}

	if (obj_creation.custom = 0) {
		if (obj_creation.fleet_type != 1) {
			flagship_name = obj_creation.flagship_name;
			battle_barges = 1;
			strike_cruisers = 6;
			gladius = 7;
			hunters = 3;

			if (global.chapter_name = "Soul Drinkers") then gladius -= 4;
			strike_cruisers -= 3;
			battle_barges += 1;

		}
		if (obj_creation.fleet_type = 1) {
			strike_cruisers = 8;
			gladius = 7;
			hunters = 3;

			if (global.chapter_name = "Raven Guard") {
				flagship_name = "Avenger"
			}
			if (global.chapter_name = "Salamanders") {
				flagship_name = "Flamewrought";
			}

			if (global.chapter_name = "Ultramarines") {
				flagship_name = "Laurels of Victory";
			}

			if (global.chapter_name = "Imperial Fists") {
				flagship_name = "Spear of Vengeance";
				battle_barges += 1;
			}

			if (global.chapter_name = "Crimson Fists") {
				flagship_name = "Throne's Fury";
				battle_barges -= 1;
				gladius -= 3;
				strike_cruisers -= 4
			}

			if (global.chapter_name = "Dark Angels") {
				flagship_name = "Invincible Reason";
				battle_barges++;

			}
			if (global.chapter_name = "Black Templars") {
				flagship_name = "Eternal Crusader";

			}
			if (global.chapter_name = "Minotaurs") {
				flagship_name = "Daedelos Krata";

			}
		}
		if (obj_creation.fleet_type = 3) {
			if (global.chapter_name = "Lamenters") {
				strike_cruisers = 2;
				gladius = 2;
				hunters = 1;
				battle_barges = 0;
			}
			if (global.chapter_name = "Blood Ravens") {
				battle_barges = 1;
			}
		}
		if (global.chapter_name != "Lamenters") and(global.chapter_name != "Doom Benefactors") and(global.chapter_name != "Blood Ravens") then battle_barges += 2;
	}

	var i = -1;
	v = 0;
	/*repeat(110){i+=1;
	    ship[i]="";ship_owner[i]=0;ship_class[i]="";ship_size[i]=0;
	    ship_leadership[i]=0;ship_hp[i]=0;ship_maxhp[i]=0;ship_location[i]="";ship_shields[i]=0;
	    ship_conditions[i]="";ship_speed[i]=0;ship_turning[i]=0;
	    ship_front_armour[i]=0;ship_other_armour[i]=0;ship_weapons[i]=0;ship_shields[i]=0;
	    ship_wep[i,0]="";ship_wep_facing[i,0]="";ship_wep_condition[i,0]="";
	    ship_wep[i,1]="";ship_wep_facing[i,1]="";ship_wep_condition[i,1]="";
	    ship_wep[i,2]="";ship_wep_facing[i,2]="";ship_wep_condition[i,2]="";
	    ship_wep[i,3]="";ship_wep_facing[i,3]="";ship_wep_condition[i,3]="";
	    ship_wep[i,4]="";ship_wep_facing[i,4]="";ship_wep_condition[i,4]="";
	    ship_wep[i,5]="";ship_wep_facing[i,5]="";ship_wep_condition[i,5]="";
	    ship_capacity[i]=0;ship_carrying[i]=0;ship_contents[i]="";ship_turrets[i]=0;
	}*/

	if (battle_barges>=1){
	 	for (v=1;v<=battle_barges;v++){
	 		var new_ship = new_player_ship("Battle Barge", "home")
		    if (flagship_name!="") and (v=1) then ship[new_ship]=flagship_name;
		    if (flagship_name="") or (v>1) then ship[new_ship]=global.name_generator.generate_imperial_ship_name();
		}
	}

	for(i=0;i<strike_cruisers;i++){
		new_player_ship("Strike Cruiser");
	}


	for(i=0;i<gladius;i++){
		new_player_ship("Gladius");
	}

	for(i=0;i<hunters;i++){
		new_player_ship("Hunter");
	}

	var j = 0,
		f = 0;
	var total_ship_count = battle_barges + strike_cruisers + gladius + hunters;
	for (f = 1; f <= total_ship_count; f++) {
		for (j = 1; j <= 30; j++) {
			if (ship_uid[f] = ship_uid[j]) and(f != j) then ship_uid[j] = floor(random(99999999)) + 1;
		}
	}




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

	var company = 0;
	var chaap = 8,
		whirlwind;
	var second = 100,
		third = 100,
		fourth = 100,
		fifth = 100,
		sixth = 100,
		seventh = 100,
		eighth = 100,
		ninth = 100,
		tenth = 100;
	var assault = 20,
		siege = 0,
		temp1 = 0,
		intolerant = 0;
	var k, i, v;
	k = 0;
	i = 0;
	v = 0;
	var techs = 8,
		techmarines_per_company = 1,
		apothecary = 8,
		epistolary = 2,
		codiciery = 2,
		lexicanum = 4,
		terminator = 20,
		veteran = 85,
		devastator = 20;


	whirlwind = 4;

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

	/*techs=20;epistolary=5;apothecary=6;codiciery=6;lexicanum=10;terminator=30;veteran=30;
	second=9;third=9;fourth=9;fifth=9;sixth=9;seventh=9;ei;
	ninth=9;tenth=10;
	assault=2;siege=0;devastator=2;*/

	var chapter_option, o, psyky;
	psyky = 0;
	if scr_has_adv("Tech-Brothers") {
		techs += 6;
		tenth -= 6;
	}
	if scr_has_adv("Melee Enthusiasts") {
		assault += 10;
		devastator -= 10;
	}
	if scr_has_adv("Siege Masters") {
		siege = 1;
	}
	if scr_has_adv("Crafters") {
		techs += 2;
		terminator += 5;
		tenth -= 5;
	}
	if scr_has_adv("Psyker Abundance") {
		tenth -= 4;
		epistolary += 1;
		codiciery += 1;
		lexicanum += 2;
		psyky = 1;
	}
	if scr_has_disadv("Psyker Intolerant") {
		epistolary = 0;
		codiciery = 0;
		lexicanum = 0;
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
		techs -= 4;
		epistolary -= 1;
		codiciery -= 1;
		lexicanum -= 2;
		apothecary -= 4;
		chaap -= 4;
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
	}

	if  scr_has_adv ("Tech-Heresy") {
		techs -= 4;
		tenth += 4;
	}
	if scr_has_adv ("Reverent Guardians") {
		chaap += 4;
		tenth -= 4;
	}
	if scr_has_adv("Medicae Primacy") {
		apothecary += 7;
	}
	
	// if (obj_creation.custom>0) or ((global.chapter_name="Doom Benefactors") and (obj_creation.custom=0)){
	if ((progenitor >= 1) and(progenitor <= 10)) or((global.chapter_name = "Doom Benefactors") and(obj_creation.custom = 0)) {
		if (obj_creation.strength <= 4) then ninth = 0;
		if (obj_creation.strength <= 3) then eighth = 0;
		if (obj_creation.strength <= 2) then seventh = 0;
		if (obj_creation.strength <= 1) then sixth = 0;

		var bonus_marines = 0,
			o = 0;
		if (obj_creation.strength > 5) then bonus_marines = (obj_creation.strength - 5) * 50;

		/*repeat(20){
		    if (bonus_marines>=5) and (veteran>0){bonus_marines-=5;veteran+=5;}
		    if (bonus_marines>=5) and (second>0){bonus_marines-=5;second+=5;}
		    if (bonus_marines>=5) and (third>0){bonus_marines-=5;second+=5;}
		    if (bonus_marines>=5) and (fourth>0){bonus_marines-=5;second+=5;}
		    if (bonus_marines>=5) and (fifth>0){bonus_marines-=5;second+=5;}
		    if (bonus_marines>=5) and (sixth>0){bonus_marines-=5;second+=5;}
		    if (bonus_marines>=5) and (seventh>0){bonus_marines-=5;second+=5;}
		    if (bonus_marines>=5) and (eighth>0){bonus_marines-=5;second+=5;}
		    if (bonus_marines>=5) and (ninth>0){bonus_marines-=5;second+=5;}
		    if (bonus_marines>=5) and (tenth>0){bonus_marines-=5;second+=5;}
		}*/
	}

	if (obj_creation.custom != 0) {
		var bonus_marines = 0,
			o = 0;
		if (obj_creation.strength > 5) then bonus_marines = (obj_creation.strength - 5) * 50;
		i = 0
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



	switch (global.chapter_name) {
		case "Salamanders":
			veteran += 20;
			second += 20;
			third += 20;
			fourth += 20;
			fifth += 20;
			sixth += 20;
			seventh = 0;
			eighth = 0;
			ninth = 0;
			tenth -= 40;
			break;
		case "Blood Angels":
			chaap += 4;
			apothecary += 4;
			epistolary += 1;
			codiciery += 1;
			lexicanum += 2;
			break;
		case "Dark Angels":
			chaap += 4;
			veteran = 5;
			terminator = 100;
			break;
		case "Lamenters":
			tenth = 0;
			ninth = 0;
			eighth = 0;
			seventh = 0;
			sixth = 0;
			fifth = 0;
			techs = 4;
			chaap = 4;
			apothecary = 4;
			epistolary = 3;
			codiciery = 3;
			lexicanum = 6;
			terminator = 5;
			veteran += 10;
			break;
		case "Soul Drinkers":
			tenth -= 38;
			seventh = 0;
			sixth = 40;
			assault -= 10;
			fifth -= 20;
			fourth -= 20;
			third -= 20;
			second -= 20;
			terminator -= 5;
			veteran -= 20;
			break;
		case "Crimson Fists":
			veteran += 30;
			break;
		case "Space Wolves":
			veteran += 40;
			second += 40;
			third += 40;
			fourth += 40;
			fifth += 40;
			sixth += 40;
			seventh += 40;
			eighth += 40;
			ninth += 40;
			tenth += 60;
			break;
		case "Iron Hands":
			chaap = 0;
			techmarines_per_company += 1;
			break;
	}
	if (obj_creation.custom = 0) and(global.chapter_name != "Iron Hands") and(global.chapter_name != "Doom Benefactors") {
		if (veteran >= 20) and(global.founding = 0) {
			veteran -= 20;
			terminator += 20;
		}
		if (veteran >= 10) and(global.founding != 0) and(global.chapter_name != "Lamenters") {
			veteran -= 10;
			terminator += 10;
		}
		// if (global.chapter_name="Lamenters") then terminator=0;
		// tenth-=1;
	}




	icon = obj_creation.icon;
	icon_name = obj_creation.icon_name;
	battle_cry = obj_creation.battle_cry;
	home_name = obj_creation.homeworld_name;

	// This needs to be updated
	main_color = obj_creation.main_color;
	secondary_color = obj_creation.secondary_color;
	trim_color = obj_creation.trim_color;
	pauldron2_color = obj_creation.pauldron2_color;
	pauldron_color = obj_creation.pauldron_color;
	lens_color = obj_creation.lens_color;
	weapon_color = obj_creation.weapon_color;
	col_special = obj_creation.col_special;
	trim = obj_creation.trim;
	skin_color = obj_creation.skin_color;
	complex_livery_data = obj_creation.complex_livery_data;
	var complex_type = ["sgt", "vet_sgt", "captain", "veteran"];
	for (var i=0;i<array_length(complex_type);i++){
		with (complex_livery_data[$ complex_type[i]]){
			if (helm_primary==0 && helm_secondary==0 && helm_lens==0){
				obj_ini.complex_livery_data[$ complex_type[i]] = progenitor_livery(progenitor_map(), complex_type[i]);
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



	company = 0;
	// Initialize default marines for loadouts
	for (i = 0; i <= 100; i++) {
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
	for (i = 0; i <= 500; i++) {
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
		TTRPG[0, i] = new TTRPG_stats("chapter", 0, i, "blank");
	}
	for (i = 0; i <= 100; i++) {
		i += 1;
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

	for (i = 100; i < 103; i++) { // gear 
		role[i, 2] = "Honour Guard";
		wep1[i, 2] = "Power Sword";
		wep2[i, 2] = "Bolter";
		armour[i, 2] = "Artificer Armour";
		mobi[i, 2] = "";
		gear[i, 2] = "";

		role[i, 3] = "Veteran";
		wep1[i, 3] = "Chainsword";
		wep2[i, 3] = "Combiflamer";
		armour[i, 3] = "Power Armour";
		mobi[i, 3] = "";
		gear[i, 3] = "";

		role[i, 4] = "Terminator";
		wep1[i, 4] = "Power Fist";
		wep2[i, 4] = "Storm Bolter";
		armour[i, 4] = "Terminator Armour";
		mobi[i, 4] = "";
		gear[i, 4] = "";

		role[i, 5] = "Captain";
		wep1[i, 5] = "Power Sword";
		wep2[i, 5] = "Bolt Pistol";
		armour[i, 5] = "Power Armour";
		mobi[i, 5] = "";
		gear[i, 5] = "Iron Halo";

		role[i, 6] = "Dreadnought";
		wep1[i, 6] = "Dreadnought Lightning Claw";
		wep2[i, 6] = "Twin Linked Lascannon";
		armour[i, 6] = "Dreadnought";
		mobi[i, 6] = "";
		gear[i, 6] = "";

		role[i, 7] = "Champion";
		wep1[i, 7] = "Power Sword";
		wep2[i, 7] = "Bolt Pistol";
		armour[i, 7] = "Power Armour";
		mobi[i, 7] = "";
		gear[i, 7] = "Combat Shield";

		role[i, 8] = "Tactical";
		wep1[i, 8] = "Bolter";
		wep2[i, 8] = "Combat Knife";
		armour[i, 8] = "Power Armour";
		mobi[i, 8] = "";
		gear[i, 8] = "";

		role[i, 9] = "Devastator";
		wep1[i, 9] = "";
		wep2[i, 9] = "Combat Knife";
		armour[i, 9] = "Power Armour";
		mobi[i, 9] = "";
		gear[i, 9] = "";

		role[i, 10] = "Assault";
		wep1[i, 10] = "Chainsword";
		wep2[i, 10] = "Bolt Pistol";
		armour[i, 10] = "Power Armour";
		mobi[i, 10] = "Jump Pack";
		gear[i, 10] = "";

		role[i, 11] = "Ancient";
		wep1[i, 11] = "Company Standard";
		wep2[i, 11] = "Bolt Pistol";
		armour[i, 11] = "Power Armour";
		mobi[i, 11] = "";
		gear[i, 11] = "";

		role[i, 12] = "Scout";
		wep1[i, 12] = "Bolter";
		wep2[i, 12] = "Combat Knife";
		armour[i, 12] = "Scout Armour";
		mobi[i, 12] = "";
		gear[i, 12] = "";

		role[i, 14] = "Chaplain";
		wep1[i, 14] = "Crozius Arcanum";
		wep2[i, 14] = "Bolt Pistol";
		armour[i, 14] = "Power Armour";
		gear[i, 14] = "Rosarius";
		mobi[i, 14] = "";

		role[i, 15] = "Apothecary";
		wep1[i, 15] = "Chainsword";
		wep2[i, 15] = "Bolt Pistol";
		armour[i, 15] = "Power Armour";
		gear[i, 15] = "Narthecium";
		mobi[i, 15] = "";

		role[i, 16] = "Techmarine";
		wep1[i, 16] = "Power Axe";
		wep2[i, 16] = "Bolt Pistol";
		armour[i, 16] = "Artificer Armour";
		gear[i, 16] = "";
		mobi[i, 16] = "Servo-arm";

		role[i, 17] = "Librarian";
		wep1[i, 17] = "Force Staff";
		wep2[i, 17] = "Bolt Pistol";
		armour[i, 17] = "Power Armour";
		gear[i, 17] = "Psychic Hood";
		mobi[i, 17] = "";

		role[i, 18] = "Sergeant";
		wep1[i, 18] = "Chainsword";
		wep2[i, 18] = "Bolt Pistol";
		armour[i, 18] = "Power Armour";
		mobi[i, 18] = "";
		gear[i, 18] = "";

		role[i, 19] = "Veteran Sergeant";
		wep1[i, 19] = "Chainsword";
		wep2[i, 19] = "Plasma Pistol";
		armour[i, 19] = "Power Armour";
		mobi[i, 19] = "";
		gear[i, 19] = "";
	} // 100 is defaults, 101 is the allowable starting equipment // info
	for (i = 0; i <= 20; i++) {
		race[100, i] = obj_creation.race[100, i];
		role[100, i] = obj_creation.role[100, i];
		wep1[100, i] = obj_creation.wep1[100, i];
		wep2[100, i] = obj_creation.wep2[100, i];
		armour[100, i] = obj_creation.armour[100, i];
		gear[100, i] = obj_creation.gear[100, i];
		mobi[100, i] = obj_creation.mobi[100, i];
	}

	var roles = {
		chapter_master: role[100][1],
		honour_guard: role[100][2],
		veteran: role[100][3],
		terminator: role[100][4],
		captain: role[100][5],
		dreadnought: role[100][6],
		champion: role[100][7],
		tactical: role[100][8],
		devastator: role[100][9],
		assault: role[100][10],
		ancient: role[100][11],
		scout: role[100][12],
		chaplain: role[100][14],
		apothecary: role[100][15],
		techmarine: role[100][16],
		librarian: role[100][17],
		sergeant: role[100][18],
		veteran_sergeant: role[100][19],
	}

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
	/*
		squad guidance
			define a role that can exist in a squad by defining [<role>, {
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
	if (global.chapter_name == "Space Wolves" || obj_ini.progenitor == 3) {
		squad_name = "Pack";
	}
	if (global.chapter_name == "Iron Hands" || obj_ini.progenitor == 6) {
		squad_name = "Clave";
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
						"wep1": ["Power Sword", 1],
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
						"wep1": ["Combat Knife", 9],
						"wep2": ["", 0],
					},
					"option": {
						"wep2": [
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
								weapon_lists.heavy_weapons, 1
							],
						]
					}
				}
			}],
			// Sternguard Veteran Sergeant
			[roles.veteran_sergeant, {
				"max": 1,
				"min": 1,
				"role": $"Sternguard {roles.sergeant}",
				"loadout": {
					"required": {
						"wep1": [wep1[100, 3], 1],
						"wep2": ["Stalker Pattern Bolter", 1],
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
				"role": $"Vanguard {roles.sergeant}",
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
				"formation_options": ["devastator"],
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
			}]
		],

		"assault_squad": [
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
								["Eviscerator"], 2
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
				"formation_options": ["scout"],
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
	if (global.chapter_name == "Salamanders") or (array_contains(obj_creation.adv, "Crafters")) { //salamanders squads
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
	if (global.chapter_name == "White Scars") or (array_contains(obj_creation.adv, "Lightning Warriors")) {
		variable_struct_set(st, "bikers", [
			[roles.tactical, {
				"max": 9,
				"min": 4,
				"loadout": { //tactical marine
					"required": {
						"wep1": [wep1[100, 8], 4],
						"wep2": [wep2[100, 8], 4],
						"mobi": ["Bike", max]
					},
					"option": {
						"wep1": [
							[
								["Plasma Gun", "Storm Bolter", "Flamer", "Meltagun"], 3
							],
						],
						"wep2": [
							[
								["Power Sword", "Power Axe", "Chainsword"], 3
							],
						]
					}
				},
				"role": $"{roles.tactical} Biker"
			}],
			[roles.sergeant, {
				"max": 1,
				"min": 1,
				"loadout": { //sergeant
					"required": {
						"mobi": ["Bike", 1]
					},
					"option": {
						"wep1": [
							[
								["Power Sword", "Power Axe", "Power Fist", "Thunder Hammer", "Chainsword"], 1
							]
						],
						"wep2": [
							[
								["Plasma Pistol", "Storm Bolter", "Plasma Gun"], 1
							]
						]
					}
				},
				"role": $"{roles.tactical} Bike {roles.sergeant}"
			}, ],
			["type_data", {
				"display_data": $"{roles.tactical} Bike {squad_name}"
			}]
		])

		variable_struct_set(st, "tactical_squad", [
			[roles.tactical, {
				"max": 9,
				"min": 4,
				"loadout": { //tactical marine
					"required": {
						"wep1": [wep1[100, 8], 4],
						"wep2": [wep2[100, 8], 4],
					},
					"option": {
						"wep1": [
							[
								["Meltagun", "Flamer"], 2
							],
							[
								["Stalker Pattern Bolter", "Storm Bolter"], 2
							],
							[
								weapon_lists.heavy_weapons, 1
							]
						],
						"wep2": [
							[
								["Chainsword"], 3
							],
							[
								["Power Sword", "Power Axe"], 2
							],
						]
					}
				}
			}],

			[roles.sergeant, {
				"max": 1,
				"min": 1,
				"role": $"{roles.tactical} {roles.sergeant}"
			}], // sergeant
			["type_data", {
				"display_data": $"{roles.tactical} {squad_name}"
			}]
		])
	}
	if (global.chapter_name == "Imperial Fists") or (array_contains(obj_creation.adv, "Boarders")) {
		variable_struct_set(st, "breachers", [
				[roles.assault, {
					"max": 9,
					"min": 4,
					"loadout": { //assault breacher marine
						"required": {
							"wep1":["Chainaxe", 4],
							"wep2":["Boarding Shield", max],
							"armour":["MK3 Iron Armour", max],
							"gear":["Plasma Bomb", 2],
							"mobi":["", max]
						},
						"option": {
							"wep1": [
								[
									["Storm Bolter", "Combiflamer", "Meltagun"], 2,
								],
								[
									["Power Axe", "Power Fist"], 2
								]
								
							]
									}
					},
					"role": $"{roles.assault} Breacher"
				}],
				[roles.sergeant, {
					"max": 1,
					"min": 1,
					"loadout": { //sergeant 
						"required": {
						"armour":["MK3 Iron Armour", 1],
						"gear": ["Plasma Bomb", 1]
						},
						"option": {
							"wep1": [
								[
									["Power Sword", "Power Axe", "Power Fist", "Thunder Hammer", "Chainsword"], 1
								]
							],
							"wep2": [
								[
									["Boarding Shield", "Storm Bolter", "Meltagun"], 1
								]
							]
						}
					},
					"role": $"{roles.assault} Breacher {roles.sergeant}"
				}, ],
				["type_data", {
					"display_data": $"{roles.assault} Breacher {squad_name}"
				}]
			])
		}
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
								["Eviscerator"], 2
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

	if (global.chapter_name == "Dark Angels") {
		variable_struct_set(st, "terminator_squad", [
			// Terminator Sergeant
			[roles.veteran_sergeant, {
				"max": 1,
				"min": 1,
				"role": $"Deathwing {roles.sergeant}",
				"loadout": {
					"required": {
						"wep1": ["Power Sword", 1],
					},
				}
			}],
			// Terminator
			[roles.terminator, {
				"max": 4,
				"min": 2,
				"role": $"Deathwing {roles.terminator}",
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
								["Heavy Flamer", "Heavy Flamer", "Heavy Flamer", "Assault Cannon", "Assault Cannon", "Plasma Cannon", ], 1
							],
						],
					}
				}
			}],
			["type_data", {
				"display_data": $"Deathwing {roles.terminator} {squad_name}",
				"formation_options": ["terminator", "veteran", "assault", "devastator", "scout", "tactical"],
			}]
		])
		variable_struct_set(st, "terminator_assault_squad", [
			// Assault Terminator Sergeant
			[roles.veteran_sergeant, {
				"max": 1,
				"min": 1,
				"role": $"Deathwing {roles.sergeant}",
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
				"role": $"Deathwing {roles.terminator}",
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
				"display_data": $"Deathwing {roles.terminator} {squad_name}",
				"formation_options": ["terminator", "veteran", "assault", "devastator", "scout", "tactical"],
			}]
		])
	}

	var squad_names = struct_get_names(st);
	for (var st_iter = 0; st_iter < array_length(squad_names); st_iter++) {
		var s_group = st[$squad_names[st_iter]];
		squad_types[$squad_names[st_iter]] = {};
		for (var iter_2 = 0; iter_2 < array_length(s_group); iter_2++) {
			squad_types[$squad_names[st_iter]][$s_group[iter_2][0]] = s_group[iter_2][1];
		}
	}


	for (i = 0; i <= 20; i++;) {
		if (role[100, i] != "") then scr_start_allow(i, "wep1", wep1[100, i]);
		if (role[100, i] != "") then scr_start_allow(i, "wep2", wep2[100, i]);
		if (role[100, i] != "") then scr_start_allow(i, "mobi", mobi[100, i]);
		if (role[100, i] != "") then scr_start_allow(i, "gear", gear[100, i]);
		// check for allowable starting equipment here
	}

	initialized = 500; // How many array variables have been prepared
	v = 0;
	company = 0;



	// Chapter Master
	// This needs work
	race[company, 1] = 1;
	loc[company, 1] = home_name;
	name[company, 1] = obj_creation.chapter_master_name;
	role[company, 1] = "Chapter Master";
	TTRPG[company, 1] = new TTRPG_stats("chapter", company, 1, "chapter_master");
	var chapter_master = TTRPG[company, 1];
	var chapter_master_equip = {}
	switch (master_melee) {
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

	//TODO will refactor how traits are distributed to chapter masters along with a refactor of chapter data
	last_artifact = find_open_artifact_slot();
	var arti;
	switch (global.chapter_name) {
		case "Dark Angels":
			chapter_master.add_trait("old_guard");
			chapter_master.add_trait("melee_enthusiast");
			arti = obj_ini.artifact_struct[last_artifact];
			arti.name = "Sword of Secrets";
			arti.custom_description = "A master-crafted Power Sword of formidable potency created soon after the disappearance of Lion El'Jonson. It is the mightiest of the Heavenfall Blades,";
			obj_ini.artifact[last_artifact] = "Power Sword";
			arti.bearer = [0, 1];
			obj_ini.artifact_identified[last_artifact] = 0;
			chapter_master_equip.wep1 = last_artifact;
			break;
		case "Blood Angels":
			chapter_master.add_trait("ancient");
			chapter_master.add_trait("old_guard");
			chapter_master.add_trait("melee_enthusiast");
			arti = obj_ini.artifact_struct[last_artifact];
			arti.name = "Axe Mortalis";
			arti.custom_description = "An immensely powerful Power Axe, the Axe Mortalis, forged in the days immediately after the end of the Horus Heresy.";
			obj_ini.artifact[last_artifact] = "Power Axe";
			arti.bearer = [0, 1];
			obj_ini.artifact_identified[last_artifact] = 0;
			chapter_master_equip.wep1=last_artifact;
			chapter_master_equip.gear="Iron Halo";
			chapter_master_equip.mobi="Jump Pack";
			break;
		case "Iron Hands":
			chapter_master_equip.wep1 = "Power Axe";
			chapter_master.add_trait("flesh_is_weak");
			chapter_master.add_trait("zealous_faith");
			chapter_master.add_trait("tinkerer");
			for (i = 0; i < 10; i++) {
				chapter_master.add_bionics("none", "standard", false);
			}
			chapter_master.add_trait("old_guard");
			break;
		case "Doom Benefactors":
			for (i = 0; i < 4; i++) {
				chapter_master.add_bionics("none", "standard", false);
			}
			chapter_master.add_trait("old_guard");
			break;
		case "Ultramarines":
			for (i = 0; i < 4; i++) {
				chapter_master.add_bionics("none", "standard", false);
			}
			chapter_master.add_trait("still_standing");
			chapter_master.add_trait("tyrannic_vet");

			arti = obj_ini.artifact_struct[last_artifact];
			arti.name = "Gauntlet of Ultramar";
			arti.custom_description = "A mighty Power Fist with an Integrated Bolter that was reclaimed from a fallen Chaos champion, slain during the Gamalia Reclusiam Massacre by the Primarch of the Ultramarines, Roboute Guilliman himself";
			obj_ini.artifact[last_artifact] = "Boltstorm Gauntlet";
			obj_ini.artifact_identified[last_artifact] = 0;
			arti.bearer = [0, 1];
			chapter_master_equip.wep1 = last_artifact;
			last_artifact++;

			arti = obj_ini.artifact_struct[last_artifact];
			arti.name = "Gauntlet of Ultramar";
			arti.custom_description = "A mighty Power Fist with an Integrated Bolter that was reclaimed from a fallen Chaos champion, slain during the Gamalia Reclusiam Massacre by the Primarch of the Ultramarines, Roboute Guilliman himself";
			obj_ini.artifact[last_artifact] = "Boltstorm Gauntlet";
			obj_ini.artifact_identified[last_artifact] = 0;
			arti.bearer = [0, 1];
			chapter_master_equip.wep2 = last_artifact;
			last_artifact++;

			chapter_master_equip.armour = last_artifact;
			arti = obj_ini.artifact_struct[last_artifact];
			arti.name = "Armour of Antilochus";
			arti.custom_description = "A masterwork suit of the standard Indomitus pattern Terminator Armour. It incorporates a Teleport Homer, allowing Terminator squads of the veteran First Company to deploy next to their Chapter Master's side.";
			arti.bearer = [0, 1];
			obj_ini.artifact_identified[last_artifact] = 0;
			obj_ini.artifact[last_artifact] = "Terminator Armour";
			break;
		case "Space Wolves":
			chapter_master_equip.armour = "Terminator Armour";
			chapter_master.add_trait("ancient");
			chapter_master.add_trait("melee_enthusiast");
			chapter_master.add_trait("feet_floor");
			arti = obj_ini.artifact_struct[last_artifact];
			arti.name = "Axe of Morkai";
			arti.custom_description = "Once a Khornate axe of great power it was reforged in the image of the death wolf Morkai";
			obj_ini.artifact[last_artifact] = "Executioner Power Axe";
			arti.bearer = [0, 1];
			obj_ini.artifact_identified[last_artifact] = 0;
			chapter_master_equip.wep1 = last_artifact;
			break;
		case "Black Templars":
			chapter_master.add_trait("melee_enthusiast");
			chapter_master.add_trait("zealous_faith");
			chapter_master.add_trait("old_guard");
			arti = obj_ini.artifact_struct[last_artifact];
			arti.name = "Sword of the High Marshalls";
			arti.custom_description = "A relic blade forged from the shards of Rogal Dorn's shattered sword passed down by the High Marshalls as a sign of office";
			obj_ini.artifact[last_artifact] = "Relic Blade";
			arti.bearer = [0, 1];
			obj_ini.artifact_identified[last_artifact] = 0;
			chapter_master_equip.wep1 = last_artifact;
			break;
		case "Minotaurs":
			chapter_master.add_trait("very_hard_to_kill");
			chapter_master.add_trait("seasoned");
			chapter_master_equip.armour = "Tartaros";
			arti = obj_ini.artifact_struct[last_artifact];
			arti.name = "The Black Spear";
			arti.custom_description = "An ancient artefact that is steeped in blood and said to have once been used by the Legio Custodes.";
			obj_ini.artifact[last_artifact] = "Power Spear";
			arti.bearer = [0, 1];
			obj_ini.artifact_identified[last_artifact] = 0;
			chapter_master_equip.wep1 = last_artifact;
		case "Lamenters":
			chapter_master.add_trait("shitty_luck");
			chapter_master.add_trait("old_guard");
		case "Salamanders":
			chapter_master.add_trait("old_guard");
			chapter_master.add_trait("tinkerer");
			chapter_master.add_trait("slow_and_purposeful");
			arti = obj_ini.artifact_struct[last_artifact];
			arti.name = "Stormbearer";
			arti.custom_description = "A masterwork Thunder Hammer, Stormbearer is thought to be made from the same material as that used to create Thunderhead, the Thunder Hammer of Vulkan.";
			obj_ini.artifact[last_artifact] = "Thunder Hammer";
			arti.bearer = [0, 1];
			obj_ini.artifact_identified[last_artifact] = 0;
			chapter_master_equip.wep1 = last_artifact;
			break;
		case "Raven Guard":
			mobi[0, 1] = "Jump Pack&SIL|";
			chapter_master.add_trait("lightning_warriors");
			chapter_master.add_trait("still_standing");
			chapter_master.add_trait("seasoned");
			break;
			case "Carcharodons":
			
			chapter_master.add_trait("melee_enthusiast")
			chapter_master.add_trait("slow_and_purposeful");
			chapter_master.add_trait("ancient");			
			arti = obj_ini.artifact_struct[last_artifact];
			arti.name = "Hunger";
			arti.custom_description = "An artifact Lightning Claw of unknown origin that has an inner maw of adamantium toothed chainblades usually paired with Slake";
			obj_ini.artifact[last_artifact] = "Lightning Claw";
			obj_ini.artifact_identified[last_artifact] = 0;
			arti.bearer = [0, 1];
			chapter_master_equip.wep1 = last_artifact;
			
			arti.name = "Hunger & Slake";
			arti.custom_description = "An artifact Lightning Claw of unknown origin that has an inner maw of adamantium toothed chainblades usually paired with Hunger";
			obj_ini.artifact[last_artifact] = "Lightning Claw";
			obj_ini.artifact_identified[last_artifact] = 0;
			arti.bearer = [0, 1];
			chapter_master_equip.wep2 = last_artifact;
			
			chapter_master_equip.armour = "Terminator Armour"
			
			break;
		default:
			chapter_master.add_trait("old_guard");

	}
	spe[company, 1] = "";
	chapter_master.add_trait("lead_example");

	//builds in which of the three chapter master types your CM is
	// all of this can now be handled in teh struct and no longer neades complex methods
	switch (obj_creation.chapter_master_specialty) {
		case 1:
			chapter_master.add_exp(550);
			spe[company, 1] += "$";
			break;
		case 2:
			chapter_master.add_exp(650);
			spe[company, 1] += "@";
			chapter_master.add_trait("champion");
			break;
		case 3:
			//TODO phychic powers need a redo but after weapon refactor
			chapter_master.add_exp(550);
			gear[company, 1] = "Psychic Hood";
			var
			let = "";
			letmax = 5;
			chapter_master.add_trait("warp_touched");
			chapter_master.psionic = choose(15, 16);
			switch (obj_creation.discipline) {
				case "default":
					let = "D";
					letmax = 7;
					break;
				case "biomancy":
					let = "B";
					break;
				case "pyromancy":
					let = "P";
					break;
				case "telekinesis":
					let = "T";
					break;
				case "rune Magick":
					let = "R";
					break;
			}
			spe[company, 1] += string(let) + "0|";
			chapter_master.update_powers();
	}
	mobi[company, 1] = mobi[100, 2];
	chapter_master.alter_equipment(chapter_master_equip, false, false, "master_crafted")
	if (scr_has_adv("Paragon")) then chapter_master.add_trait("paragon")
	chapter_master.marine_assembling();

	//TODO All heads of specialties data should be in chapter data
	// Forge Master
	TTRPG[company, 2] = new TTRPG_stats("chapter", company, 2);
	race[company, 2] = 1;
	loc[company, 2] = home_name;
	role[company, 2] = "Forge Master";
	wep1[company, 2] = "Infernus Pistol";
	name[company, 2] = obj_creation.fmaster;
	wep2[company, 2] = "Power Axe";
	armour[company, 2] = "Artificer Armour";
	mobi[company, 2] = "Servo-harness";
	gear[company, 2] = "";
	chaos[company, 2] = 0;
	spawn_unit = TTRPG[company, 2];
	if (spawn_unit.technology < 40) {
		spawn_unit.technology = 40;
	}
	spawn_unit.add_trait("mars_trained");
	spawn_unit.add_bionics("right_arm", "standard", false);
	spawn_unit.marine_assembling();
	if (global.chapter_name = "Lamenters") then armour[company, 2] = "MK6 Corvus";
	if (global.chapter_name = "Iron Hands") {
		repeat(9) {
			spawn_unit.add_bionics("none", "standard", false);
		}
	} else {
		repeat(irandom(5) + 3) {
			spawn_unit.add_bionics("none", "standard", false)
		};
	}
	// Master of Sanctity (Chaplain)
	if (global.chapter_name != "Iron Hands"){
		TTRPG[company, 3] = new TTRPG_stats("chapter", company, 3);
		race[company, 3] = 1;
		loc[company, 3] = home_name;
		role[company, 3] = "Master of Sanctity";
		wep1[company, 3] = wep1[101, 14];
		name[company, 3] = obj_creation.hchaplain;
		wep2[company, 3] = "Plasma Pistol";
		armour[company, 3] = "Artificer Armour";
		gear[company, 3] = gear[101, 14];
		chaos[company, 3] = -100;
		if (global.chapter_name = "Lamenters") then armour[company, 3] = "MK6 Corvus";
		spawn_unit = TTRPG[company, 3];
		if (spawn_unit.piety < 45) {
			spawn_unit.piety = 45;
		}
		spawn_unit.marine_assembling();
		spawn_unit.add_trait("zealous_faith");
	}

	// Maser of the Apothecarion (Apothecary)
	TTRPG[company, 4] = new TTRPG_stats("chapter", company, 4);
	race[company, 4] = 1;
	loc[company, 4] = home_name;
	role[company, 4] = "Master of the Apothecarion";
	wep1[company, 4] = wep1[101, 15];
	name[company, 4] = obj_creation.hapothecary;
	wep2[company, 4] = "Plasma Pistol";
	armour[company, 4] = "Artificer Armour";
	gear[company, 4] = gear[101, 15];
	chaos[company, 4] = 0;
	spawn_unit = TTRPG[company][4];
	spawn_unit.marine_assembling();
	if (global.chapter_name = "Lamenters") then armour[company, 4] = "MK6 Corvus";

	// Chief Librarian
	TTRPG[company][5] = new TTRPG_stats("chapter", company, 5);
	var cheif_lib = TTRPG[company][5];
	race[company, 5] = 1;
	loc[company, 5] = home_name;
	role[company, 5] = string("Chief {0}", role[100, 17]);
	wep1[company, 5] = wep1[101, 17];
	name[company, 5] = obj_creation.clibrarian;
	wep2[company, 5] = "Plasma Pistol";
	armour[company, 5] = "Artificer Armour";
	gear[company, 5] = gear[101, 17];
	chaos[company, 5] = 0;
	spawn_unit = TTRPG[company][5];
	spawn_unit.marine_assembling();
	if (global.chapter_name = "Lamenters") then armour[company, 5] = "MK6 Corvus";
	if (obj_creation.discipline = "default") {
		let = "D";
		letmax = 7;
	}
	if (obj_creation.discipline = "biomancy") {
		let = "B";
		letmax = 5;
	}
	if (obj_creation.discipline = "pyromancy") {
		let = "P";
		letmax = 5;
	}
	if (obj_creation.discipline = "telekinesis") {
		let = "T";
		letmax = 5;
	}
	if (obj_creation.discipline = "rune Magick") {
		let = "R";
		letmax = 5;
	}
	spe[company, 5] = string(let) + "0|";
	cheif_lib.psionic = choose(13, 14, 15, 16);
	cheif_lib.update_powers();
	cheif_lib.add_trait("warp_touched");
	k = 0;
	commands += 5;
	k = 5;
	man_size = 5;

	if (intolerant == 1) {
		race[company, 5] = 0;
		loc[company, 5] = "";
		role[company, 5] = "";
		wep1[company, 5] = "";
		name[company, 5] = "";
		wep2[company, 5] = "";
		armour[company, 5] = "";
		gear[company, 5] = "";
		man_size -= 1;
		commands -= 1;
		TTRPG[company, 5] = new TTRPG_stats("chapter", company, 1, "blank");
	}

	// Techmarines in the armoury
	repeat(techs) {
		k += 1;
		commands += 1;
		man_size += 1;
		TTRPG[company][k] = new TTRPG_stats("chapter", company, k);
		race[company][k] = 1;
		loc[company][k] = home_name;
		role[company][k] = roles.techmarine;
		name[company][k] = global.name_generator.generate_space_marine_name();
		spawn_unit = TTRPG[company][k];
		spawn_unit.marine_assembling();
		wep1[company][k] = wep1[101, 16];
		wep2[company][k] = choose_weighted(weapon_weighted_lists.pistols);
		gear[company][k] = gear[101, 16];
		mobi[company][k] = mobi[101, 16];
	}

	// Librarians in the librarium
	repeat(epistolary) {
		k += 1;
		commands += 1;
		man_size += 1;
		TTRPG[company][k] = new TTRPG_stats("chapter", company, k);
		spawn_unit = TTRPG[company][k];
		race[company][k] = 1;
		loc[company][k] = home_name;
		role[company][k] = roles.librarian;
		name[company][k] = global.name_generator.generate_space_marine_name();
		wep1[company][k] = wep1[101, 17];
		wep2[company][k] = choose_weighted(weapon_weighted_lists.pistols);
		gear[company][k] = gear[101, 17];
		if (psyky = 1){
			spawn_unit.add_exp(10);
		}
		var
		let = "", letmax = 0;
		if (obj_creation.discipline = "default") {
			let = "D";
			letmax = 7;
		}
		if (obj_creation.discipline = "biomancy") {
			let = "B";
			letmax = 5;
		}
		if (obj_creation.discipline = "pyromancy") {
			let = "P";
			letmax = 5;
		}
		if (obj_creation.discipline = "telekinesis") {
			let = "T";
			letmax = 5;
		}
		if (obj_creation.discipline = "rune Magick") {
			let = "R";
			letmax = 5;
		}
		spe[company][k] += string(let) + "0|";
		spawn_unit.marine_assembling();
		spawn_unit.add_trait("warp_touched");
		spawn_unit.psionic = choose(13, 14, 15, 16);
		spawn_unit.update_powers();
	}
	// Codiciery
	repeat(codiciery) {
		k += 1;
		commands += 1;
		man_size += 1;
		TTRPG[company][k] = new TTRPG_stats("chapter", company, k);
		spawn_unit = TTRPG[company][k];
		race[company][k] = 1;
		loc[company][k] = home_name;
		role[company][k] = "Codiciery";
		name[company][k] = global.name_generator.generate_space_marine_name();
		wep1[company][k] = wep1[101, 17];
		wep2[company][k] = choose_weighted(weapon_weighted_lists.pistols);
		gear[company][k] = gear[101, 17];
		if (psyky = 1){
			spawn_unit.add_exp(10);
		}
		var
		let, letmax;
		let = "";
		letmax = 0;
		if (obj_creation.discipline = "default") {
			let = "D";
			letmax = 7;
		}
		if (obj_creation.discipline = "biomancy") {
			let = "B";
			letmax = 5;
		}
		if (obj_creation.discipline = "pyromancy") {
			let = "P";
			letmax = 5;
		}
		if (obj_creation.discipline = "telekinesis") {
			let = "T";
			letmax = 4;
		}
		if (obj_creation.discipline = "rune Magick") {
			let = "R";
			letmax = 5;
		}
		spe[company][k] += string(let) + "0|";
		spawn_unit = TTRPG[company][k];
		spawn_unit.marine_assembling();
		spawn_unit.add_trait("warp_touched");
		spawn_unit.psionic = choose(11, 12, 13, 14, 15);
		spawn_unit.update_powers();
	}

	// Lexicanum
	repeat(lexicanum) {
		k += 1;
		commands += 1;
		man_size += 1;
		TTRPG[company][k] = new TTRPG_stats("chapter", company, k);
		var spawn_unit = TTRPG[company][k];
		race[company][k] = 1;
		loc[company][k] = home_name;
		role[company][k] = "Lexicanum";
		name[company][k] = global.name_generator.generate_space_marine_name();
		wep1[company][k] = wep1[101, 17];
		wep2[company][k] = choose_weighted(weapon_weighted_lists.pistols);
		gear[company][k] = gear[101, 17];
		if (psyky = 1){
			spawn_unit.add_exp(10);
		}
		var
		let = "", letmax = 0;
		if (obj_creation.discipline = "default") {
			let = "D";
			letmax = 7;
		}
		if (obj_creation.discipline = "biomancy") {
			let = "B";
			letmax = 5;
		}
		if (obj_creation.discipline = "pyromancy") {
			let = "P";
			letmax = 5;
		}
		if (obj_creation.discipline = "telekinesis") {
			let = "T";
			letmax = 4;
		}
		if (obj_creation.discipline = "rune Magick") {
			let = "R";
			letmax = 5;
		}
		spe[company][k] += string(let) + "0|";
		spawn_unit = TTRPG[company][k];
		spawn_unit.marine_assembling();
		spawn_unit.add_trait("warp_touched");
		spawn_unit.psionic = choose(8, 9, 10, 11, 12, 13, 14);
	}

	// Apothecaries in Apothecarion
	repeat(apothecary) {
		k += 1;
		commands += 1;
		man_size += 1;
		TTRPG[company][k] = new TTRPG_stats("chapter", company, k);
		race[company][k] = 1;
		loc[company][k] = home_name;
		role[company][k] = roles.apothecary;
		name[company][k] = global.name_generator.generate_space_marine_name();
		wep1[company][k] = "Chainsword";
		wep2[company][k] = choose_weighted(weapon_weighted_lists.pistols);
		gear[company][k] = gear[101, 15];
		spawn_unit = TTRPG[company][k];
		spawn_unit.marine_assembling();
	}

	// Chaplains in Reclusium
	repeat(chaap) {
		k += 1;
		commands += 1;
		man_size += 1;
		TTRPG[company][k] = new TTRPG_stats("chapter", company, k);
		race[company][k] = 1;
		loc[company][k] = home_name;
		role[company][k] = roles.chaplain;
		name[company][k] = global.name_generator.generate_space_marine_name();
		wep1[company][k] = wep1[101, 14];
		wep2[company][k] = choose_weighted(weapon_weighted_lists.pistols);
		gear[company][k] = gear[101, 14];
		spawn_unit = TTRPG[company][k];
		spawn_unit.marine_assembling();
	}

	// Honour Guard
	var _honour_guard_count = 0,
		chapter_option, o, unit;
	o = 0;
	chapter_option = 0;
	repeat(4) {
		o += 1;
		if (obj_creation.adv[o] = "Brothers, All") then chapter_option = 1;
	}
	if (chapter_option = 1) then _honour_guard_count += 10;
	if (progenitor = 0) and (obj_creation.custom = 0) then _honour_guard_count += 6;
	if (_honour_guard_count == 0) {
		_honour_guard_count = 3
	}
	for (i = 0; i < min(_honour_guard_count, 10); i++) {
		k += 1;
		commands += 1;
		man_size += 1;
		TTRPG[company][k] = new TTRPG_stats("chapter", company, k);
		spawn_unit = TTRPG[company][k];
		race[company][k] = 1;
		loc[company][k] = home_name;
		role[company][k] = roles.honour_guard;
		name[company][k] = global.name_generator.generate_space_marine_name();
		spawn_unit.marine_assembling();
		spawn_unit.add_trait(choose("guardian", "champion", "observant", "perfectionist"));
		gear[company][k] = gear[100, 2];
		mobi[company][k] = mobi[100, 2];
		// wep1 power sword // wep2 storm bolter default
		wep1[company][k] = choose("Power Sword", "Power Axe", "Power Spear");
		wep2[company][k] = wep2[101, 2];
		armour[company][k] = armour[101, 2];
		if (global.chapter_name == "Dark Angels") {
			armour[company][k] = "Terminator Armour";
			wep1[company][k] = "Mace of Absolution";
			wep2[company][k] = "Storm Shield";
		}
	}

	specials = k;

	// First Company
	company = 1;
	for (i = 0; i < 501; i++) {
		race[company, i] = 1;
		loc[company, i] = "";
		name[company, i] = "";
		role[company, i] = "";
		wep1[company, i] = "";
		spe[company, i] = "";
		wep2[company, i] = "";
		armour[company, i] = "";
		chaos[company, i] = 0;
		gear[company, i] = "";
		mobi[company, i] = "";
		age[company, i] = ((millenium * 1000) + year) - 10;
		god[company, i] = 0;
		TTRPG[company, i] = new TTRPG_stats("chapter", company, i, "blank");
	}
	initialized = 200; // How many array variables have been prepared

	k = 0;

	if (veteran + terminator > 0) {
		k += 1;
		commands += 1; // Captain
		TTRPG[company][k] = new TTRPG_stats("chapter", company, k);
		race[company][k] = 1;
		loc[company][k] = home_name;
		role[company][k] = roles.captain;
		wep1[company][k] = "Relic Blade";
		name[company][k] = honor_captain_name;
		wep2[company][k] = choose("Storm Shield", "Storm Bolter");
		gear[company][k] = gear[101, 5];
		spawn_unit = TTRPG[company][k]
		spawn_unit.marine_assembling();
		armour[company][k] = "Terminator Armour";
		if (scr_has_adv("Crafters")) then armour[company][k] = "Tartaros";
		if (terminator <= 0) then armour[company][k] = "MK6 Corvus";
		if (mobi[101, 5] != "") then mobi[company][k] = mobi[101, 5];
		if (armour[company][k] = "Terminator Armour") or(armour[company][k] = "Tartaros") {
			man_size += 1;
		}

		if (global.chapter_name != "Space Wolves") and(global.chapter_name != "Iron Hands") {
			k += 1;
			commands += 1; // Chaplain
			TTRPG[company][k] = new TTRPG_stats("chapter", company, k);
			race[company][k] = 1;
			loc[company][k] = home_name;
			role[company][k] = roles.chaplain;
			name[company][k] = global.name_generator.generate_space_marine_name();
			spawn_unit = TTRPG[company][k]
			spawn_unit.marine_assembling();
			wep1[company][k] = wep1[101, 14];
			wep2[company][k] = "Storm Bolter";
			armour[company][k] = "Terminator Armour";
			gear[company][k] = gear[101, 14]
			if (scr_has_adv("Crafters")) then armour[company][k] = "Tartaros";
			if (terminator <= 0) then armour[company][k] = "MK6 Corvus";
			if (mobi[101, 14] != "") then mobi[company][k] = mobi[101, 14];
			if (armour[company][k] = "Terminator") or(armour[company][k] = "Tartaros") then man_size += 1;
		}

		k += 1;
		commands += 1; // Apothecary
		race[company][k] = 1;
		TTRPG[company][k] = new TTRPG_stats("chapter", company, k);
		loc[company][k] = home_name;
		role[company][k] = roles.apothecary;
		name[company][k] = global.name_generator.generate_space_marine_name();
		spawn_unit = TTRPG[company][k]
		spawn_unit.marine_assembling();
		wep1[company][k] = "Storm Bolter";
		wep2[company][k] = "";
		armour[company][k] = "Terminator Armour";
		gear[company][k] = gear[101, 15];
		if (scr_has_adv("Crafters")) then armour[company][k] = "Tartaros";
		if (terminator <= 0) then armour[company][k] = "MK6 Corvus";
		if (mobi[101, 15] != "") then mobi[company][k] = mobi[101, 15];
		if (armour[company][k] = "Terminator") or(armour[company][k] = "Tartaros") then man_size += 1;

		if (global.chapter_name = "Space Wolves") {
			k += 1;
			commands += 1; // Apothecary
			TTRPG[company][k] = new TTRPG_stats("chapter", company, k);
			race[company][k] = 1;
			loc[company][k] = home_name;
			role[company][k] = roles.apothecary;
			name[company][k] = global.name_generator.generate_space_marine_name();
			spawn_unit = TTRPG[company][k]
			spawn_unit.marine_assembling();
			wep1[company][k] = wep1[101, 15];
			wep2[company][k] = wep2[101, 15];
			armour[company][k] = "Terminator Armour";
			gear[company][k] = gear[101, 15];
			if (scr_has_adv("Crafters")) then armour[company][k] = "Tartaros";
			if (terminator <= 0) then armour[company][k] = "MK6 Corvus";
			if (mobi[101, 15] != "") then mobi[company][k] = mobi[101, 15];
			if (armour[company][k] = "Terminator") or(armour[company][k] = "Tartaros") then man_size += 1;
		}

		if (!array_contains(obj_creation.dis, "Psyker Intolerant")) {
			k += 1; // Company Librarian
			commands += 1;
			race[company][k] = 1;
			TTRPG[company][k] = new TTRPG_stats("chapter", company, k);
			loc[company][k] = home_name;
			role[company][k] = roles.librarian;
			name[company][k] = global.name_generator.generate_space_marine_name();
			if (mobi[101, 17] != "") then mobi[company][k] = mobi[101, 17];
			spawn_unit = TTRPG[company][k]
			spawn_unit.marine_assembling();
			gear[company][k] = gear[101, 17];
			wep1[company][k] = wep1[101, 17];
			wep2[company][k] = choose_weighted(weapon_weighted_lists.pistols);
			armour[company][k] = "Terminator Armour";
			if (scr_has_adv("Crafters")) then armour[company][k] = "Tartaros";
			if (terminator <= 0) then armour[company][k] = "MK6 Corvus";
			if (mobi[101, 15] != "") then mobi[company][k] = mobi[101, 15];
			if (armour[company][k] = "Terminator") or(armour[company][k] = "Tartaros") then man_size += 1;
			if (psyky){
				spawn_unit.add_exp(10);
			}
			var let = "";
			var letmax = 0;
			if (obj_creation.discipline = "default") {
				let = "D";
				letmax = 7;
			}
			if (obj_creation.discipline = "biomancy") {
				let = "B";
				letmax = 5;
			}
			if (obj_creation.discipline = "pyromancy") {
				let = "P";
				letmax = 5;
			}
			if (obj_creation.discipline = "telekinesis") {
				let = "T";
				letmax = 4;
			}
			if (obj_creation.discipline = "rune Magick") {
				let = "R";
				letmax = 5;
			}
			spe[company][k] += string(let) + "0|";
			TTRPG[company][k].add_trait("warp_touched");
			TTRPG[company][k].psionic = choose(8, 9, 10, 11, 12, 13, 14);
			TTRPG[company][k].update_powers();
		}

		repeat(techmarines_per_company){
			k += 1;
			commands += 1; // Techmarine
			race[company][k] = 1;
			TTRPG[company][k] = new TTRPG_stats("chapter", company, k);
			loc[company][k] = home_name;
			role[company][k] = roles.techmarine;
			name[company][k] = global.name_generator.generate_space_marine_name();
			spawn_unit = TTRPG[company][k]
			spawn_unit.marine_assembling();
			wep1[company][k] = wep1[101, 16];
			wep2[company][k] = "Storm Bolter";
			armour[company][k] = "Terminator Armour";
			gear[company][k] = gear[101, 16];
			if (scr_has_adv("Crafters")) then armour[company][k] = "Tartaros";
			if (terminator <= 0) then armour[company][k] = "Artificer Armour";
			if (mobi[101, 16] != "") then mobi[company][k] = mobi[101, 16];
			if (armour[company][k] = "Terminator") or(armour[company][k] = "Tartaros") then man_size += 1;
		}

		k += 1; // Standard bearer
		man_size += 1;
		race[company][k] = 1;
		TTRPG[company][k] = new TTRPG_stats("chapter", company, k);
		loc[company][k] = home_name;
		role[company][k] = roles.ancient;
		name[company][k] = global.name_generator.generate_space_marine_name();
		spawn_unit = TTRPG[company][k]
		spawn_unit.marine_assembling();
		wep1[company][k] = "Company Standard";
		wep2[company][k] = "Storm Bolter";
		armour[company][k] = "Terminator Armour";
		if (scr_has_adv("Crafters")) then armour[company][k] = "Tartaros";
		if (terminator <= 0) then armour[company][k] = "MK6 Corvus";
		if (mobi[101, 5] != "") then mobi[company][k] = mobi[101, 5];
		if (armour[company][k] = "Terminator Armour") or(armour[company][k] = "Tartaros") {
			man_size += 1;
		}

		k += 1;
		man_size += 1;
		TTRPG[company][k] = new TTRPG_stats("chapter", company, k); // Champion
		race[company][k] = 1;
		loc[company][k] = home_name;
		role[company][k] = roles.champion;
		name[company][k] = global.name_generator.generate_space_marine_name();
		spawn_unit = TTRPG[company][k]
		spawn_unit.marine_assembling();
		wep1[company][k] = "Thunder Hammer";
		wep2[company][k] = "Storm Bolter";
		gear[company][k] = gear[101, 7];
		armour[company][k] = "Terminator Armour";
		if (scr_has_adv("Crafters")) then armour[company][k] = "Tartaros";
		if (terminator <= 0) then armour[company][k] = "MK6 Corvus";
		if (global.chapter_name == "Dark Angels"){
			wep1[company][k] = "Heavy Thunder Hammer";
			wep2[company][k] = "";
		}
		if (armour[company][k] = "Terminator") or(armour[company][k] = "Tartaros") then man_size += 1;
	}

	// go 5 under the required xp amount 

	if (terminator > 0) then repeat(terminator) {
		k += 1;
		man_size += 2
		// repeat(max(terminator-4,0)){k+=1;man_size+=2;
		race[company][k] = 1;
		TTRPG[company][k] = new TTRPG_stats("chapter", company, k);
		loc[company][k] = home_name;
		role[company][k] = roles.terminator;
		wep1[company][k] = wep1[101, 4];
		name[company][k] = global.name_generator.generate_space_marine_name();
		wep2[company][k] = wep2[101, 4];
		spawn_unit = TTRPG[company][k]
		spawn_unit.marine_assembling();
	}
	repeat(veteran) {
		k += 1;
		man_size += 1;
		TTRPG[company][k] = new TTRPG_stats("chapter", company, k);
		race[company][k] = 1;
		loc[company][k] = home_name;
		role[company][k] = roles.veteran;
		name[company][k] = global.name_generator.generate_space_marine_name();
		spawn_unit = TTRPG[company][k]
		spawn_unit.marine_assembling();
		wep1[company][k] = wep1[101, 3];
		wep2[company][k] = wep2[101, 3];
		gear[company][k] = gear[101, 3];
		mobi[company][k] = mobi[101, 3];
	}

	repeat(scr_has_adv("Venerable Ancients") ? 3 : 2) {
		k += 1;
		commands += 1;
		TTRPG[company][k] = new TTRPG_stats("chapter", company, k, "dreadnought");
		race[company][k] = 1;
		loc[company][k] = home_name;
		role[company][k] = "Venerable " + string(roles.dreadnought);
		wep1[company][k] = wep1[101, 6];
		man_size += 8;
		wep2[company][k] = "Plasma Cannon";
		armour[company][k] = "Dreadnought";
		name[company][k] = global.name_generator.generate_space_marine_name();
		spawn_unit = TTRPG[company][k]
		spawn_unit.roll_age();
		spawn_unit.roll_experience();
	}

	for (i = 0; i < 4; i++) {
		v += 1;
		man_size += 10;
		veh_race[company, v] = 1;
		veh_loc[company, v] = home_name;
		veh_role[company, v] = "Rhino";
		veh_wep1[company, v] = "Storm Bolter";
		veh_wep2[company, v] = "HK Missile";
		veh_wep3[company, v] = "";
		veh_upgrade[company, v] = "Artificer Hull";
		veh_acc[company, v] = "Dozer Blades";
		veh_hp[company, v] = 100;
		veh_chaos[company, v] = 0;
		veh_pilots[company, v] = 0;
		veh_lid[company, v] = 0;
		veh_wid[company, v] = 2;
	}
	var predrelic = 2;
	if (global.chapter_name = "Iron Hands") then predrelic = 3;
	if (obj_creation.custom == 1) and (array_contains(obj_creation.adv, "Tech-Brothers")) then predrelic +=2;
	repeat(predrelic) {
		v += 1;
		man_size += 10;
		var predtype;
		predtype = choose(1, 2, 3, 4)
		veh_race[company, v] = 1;
		veh_loc[company, v] = home_name;
		veh_role[company, v] = "Predator";
		if (predtype = 1) {
			veh_wep1[company, v] = "Plasma Destroyer Turret";
			veh_wep2[company, v] = "Lascannon Sponsons";
			veh_wep3[company, v] = "HK Missile";
			veh_upgrade[company, v] = "Artificer Hull";
			veh_acc[company, v] = "Searchlight";
		}
		if (predtype = 2) {
			veh_wep1[company, v] = "Heavy Conversion Beamer Turret";
			veh_wep2[company, v] = "Lascannon Sponsons";
			veh_wep3[company, v] = "HK Missile";
			veh_upgrade[company, v] = "Artificer Hull";
			veh_acc[company, v] = "Searchlight";
		}
		if (predtype = 3) {
			veh_wep1[company, v] = "Flamestorm Cannon Turret";
			veh_wep2[company, v] = "Heavy Flamer Sponsons";
			veh_wep3[company, v] = "Storm Bolter";
			veh_upgrade[company, v] = "Artificer Hull";
			veh_acc[company, v] = "Dozer Blades";
		}
		if (predtype = 4) {
			veh_wep1[company, v] = "Magna-Melta Turret";
			veh_wep2[company, v] = "Heavy Flamer Sponsons";
			veh_wep3[company, v] = "Storm Bolter";
			veh_upgrade[company, v] = "Artificer Hull";
			veh_acc[company, v] = "Dozer Blades";
		}
		veh_hp[company, v] = 100;
		veh_chaos[company, v] = 0;
		veh_pilots[company, v] = 0;
		veh_lid[company, v] = 0;
	}
	if (global.chapter_name != "Lamenters") then repeat(6) {
		v += 1;
		man_size += 20;
		veh_race[company, v] = 1;
		veh_loc[company, v] = home_name;
		veh_role[company, v] = "Land Raider";
		veh_hp[company, v] = 100;
		veh_chaos[company, v] = 0;
		veh_pilots[company, v] = 0;
		veh_lid[company, v] = 0;
		veh_wid[company, v] = 2;
		if (floor(v mod 4) == 1) or(floor(v mod 4) == 2) {
			veh_wep1[company, v] = "Twin Linked Heavy Bolter Mount";
			veh_wep2[company, v] = "Twin Linked Lascannon Sponsons";
			veh_wep3[company, v] = "HK Missile";
			veh_upgrade[company, v] = "Heavy Armour";
			veh_acc[company, v] = "Searchlight";
		}
		if (floor(v mod 4) == 3) {
			veh_wep1[company, v] = "Twin Linked Assault Cannon Mount";
			veh_wep2[company, v] = "Hurricane Bolter Sponsons";
			veh_wep3[company, v] = "Storm Bolter";
			veh_upgrade[company, v] = "Heavy Armour";
			veh_acc[company, v] = "Frag Assault Launchers";
		}
		if (floor(v mod 4) == 0) {
			veh_wep1[company, v] = "Twin Linked Assault Cannon Mount";
			veh_wep2[company, v] = "Flamestorm Cannon Sponsons";
			veh_wep3[company, v] = "Storm Bolter";
			veh_upgrade[company, v] = "Heavy Armour";
			veh_acc[company, v] = "Frag Assault Launchers";
		}
	}
	v = 0;

	firsts = k;



	//non HQ and non firsst company initialised here
	for (company = 2; company < 11; company++) {
		// Initialize marines
		for (i = 0; i < 501; i++) {
			race[company, i] = 1;
			loc[company, i] = "";
			name[company, i] = "";
			role[company, i] = "";
			wep1[company, i] = "";
			spe[company, i] = "";
			wep2[company, i] = "";
			armour[company, i] = "";
			gear[company, i] = "";
			mobi[company, i] = "";
			chaos[company, i] = 0;
			age[company, i] = ((millenium * 1000) + year) - 21 - irandom(6);
			god[company, i] = 0;
			TTRPG[company, i] = new TTRPG_stats("chapter", company, i, "blank");
		}

		var company_experience = 0,
			company_unit2 = "",
			company_unit3 = "",
			dready = 0,
			rhinoy = 0,
			whirly = 0,
			speedy = 0,
			stahp = 0;

		v = 0;
		i = -1;
		k = 0;
		v = 0;


		if (obj_creation.equal_specialists = 1) {
			if (company = 2) then temp1 = max(0, (second - (assault + devastator)) - 1);
			if (company = 3) then temp1 = max(0, (third - (assault + devastator)) - 1);
			if (company = 4) then temp1 = max(0, (fourth - (assault + devastator)) - 1);
			if (company = 5) then temp1 = max(0, (fifth - (assault + devastator)) - 1);
			if (company = 6) then temp1 = max(0, (sixth - (assault + devastator)) - 1);
			if (company = 7) then temp1 = max(0, (seventh - (assault + devastator)) - 1);
			if (company = 8) then temp1 = max(0, (eighth - (assault + devastator)) - 1);
			if (company = 9) then temp1 = max(0, (ninth - (assault + devastator)) - 1);
			if (company = 10) then temp1 = max(0, tenth - 10);

			company_experience = (16 - company) * 5;

			// temp1=(100-(assault*devastator))*10;company_experience=(16-company)*5;
			// temp1-=1;

			// if (company=2){dready=1;
			dready = 1;
			if (scr_has_disadv("Sieged")) or (obj_creation.custom = 0) then dready =+ 1;
			if (scr_has_adv("Venerable Ancients")) then dready += 1;
			rhinoy = 8;
			whirly = whirlwind;
			speedy = 2;
		}

		// random xp for each marine company
		// this gives the entire company the same xp
		// figure it out later how to give individual ones different ones
		// repeat didn't work

		if (obj_creation.equal_specialists = 0) {
			if (company = 2) {
				temp1 = (second - (assault + devastator));
				company_unit2 = "assault";
				company_unit3 = "devastator";
				dready = 1;
				if scr_has_adv("Venerable Ancients") then dready += 1;
				if (scr_has_disadv("Sieged")) or (obj_creation.custom = 0) then dready += 1;
				rhinoy = 8;
				whirly = whirlwind;
				speedy = 2;
				if scr_has_adv("Lightning Warriors") then speedy += 2; rhinoy -= 2;
				if (second = 0) then stahp = 1;
			}
	
			if (company = 3) {
				temp1 = (third - (assault + devastator));
				company_unit2 = "assault";
				company_unit3 = "devastator";
				dready = 1;
				if scr_has_adv("Venerable Ancients") then dready += 1;
				if (scr_has_disadv("Sieged")) or (obj_creation.custom = 0) then dready += 1; 
				rhinoy = 8;
				whirly = whirlwind;
				speedy = 2;
				if (array_contains(obj_creation.adv, "Lightning Warriors")) then speedy += 2; rhinoy -= 2;
				if (third = 0) then stahp = 1;
			}

			if (company = 4) {
				temp1 = (fourth - (assault + devastator));
				company_unit2 = "assault";
				company_unit3 = "devastator";
				dready = 1;
				if scr_has_adv("Venerable Ancients") then dready += 1;
				if (scr_has_disadv("Sieged")) or (obj_creation.custom = 0) then dready += 1;
				rhinoy = 8;
				whirly = whirlwind;
				speedy = 2;
				if (array_contains(obj_creation.adv, "Lightning Warriors")) then speedy += 2; rhinoy -= 2;
				if (fourth = 0) then stahp = 1;
			}

			if (company = 5) {
				temp1 = (fifth - (assault + devastator));
				company_unit2 = "assault";
				company_unit3 = "devastator";
				dready = 1;
				if scr_has_adv("Venerable Ancients") then dready += 1;
				if (scr_has_disadv("Sieged")) or (obj_creation.custom = 0) then dready += 1;
				rhinoy = 8;
				whirly = whirlwind;
				speedy = 2;
				if (array_contains(obj_creation.adv, "Lightning Warriors")) then speedy += 2; rhinoy -= 2;
				if (fifth = 0) then stahp = 1;
			}

			if (company = 6) {
				temp1 = sixth;
				company_unit2 = "";
				company_unit3 = "";
				dready = 1;
				if scr_has_adv("Venerable Ancients") then dready += 1;
				if (obj_creation.custom = 0) then dready += 1;
				rhinoy = 8;
				whirly = whirlwind;
				speedy = 0;
				if (sixth = 0) then stahp = 1;
			}

			if (company = 7) {
				temp1 = seventh;
				company_unit2 = "";
				company_unit3 = "";
				dready = 1
				if scr_has_adv("Venerable Ancients") then dready += 1;
				if (obj_creation.custom = 0) then dready += 1;
				rhinoy = 8;
				whirly = 0;
				speedy = 8;
				if (seventh = 0) then stahp = 1;
			}

			if (company = 8) {
				temp1 = eighth;
				company_unit2 = "";
				company_unit3 = "";
				dready = 1
				if scr_has_adv("Venerable Ancients") then dready += 1;
				if (obj_creation.custom = 0) then dready += 1;
				rhinoy = 2;
				whirly = 0;
				speedy = 2;
				if (eighth = 0) then stahp = 1;
			}

			if (company = 9) {
				temp1 = ninth;
				company_unit2 = "";
				company_unit3 = "";
				dready = 1
				if scr_has_adv("Venerable Ancients") then dready += 1;
				if (obj_creation.custom = 0) then dready += 1;

				rhinoy = 2;
				whirly = 0;
				speedy = 0;
				if (ninth = 0) then stahp = 1;
			}
			if (company = 10) {
				temp1 = tenth;
				company_unit2 = "";
				company_unit3 = "";
				dready = 0;
				rhinoy = 8;
				whirly = 0;
				speedy = 0;

				// if (obj_creation.custom=0) then temp1-=5;

				if (tenth = 0) then stahp = 1;
			}
		}

		var spawn_unit;
		if (stahp = 0) {
			k += 1;
			commands += 1; // Captain
			TTRPG[company][k] = new TTRPG_stats("chapter", company, k);
			race[company][k] = 1;
			loc[company][k] = home_name;
			role[company][k] = roles.captain;
			name[company][k] = global.name_generator.generate_space_marine_name();

	        if (company==1){
     	        if (honor_captain_name!=""){
     	        	 name[company][k]=honor_captain_name;
     	        } else{
     	        	honor_captain_name = name[company][k];
     	        }
     	    }else if  (company==2){
     	        if (watch_master_name!=""){
     	        	 name[company][k]=watch_master_name;
     	        } else{
     	        	watch_master_name = name[company][k];
     	        }
			}else if  (company==3){
     	        if (arsenal_master_name!=""){
     	        	 name[company][k]=arsenal_master_name;
     	        } else{
     	        	arsenal_master_name = name[company][k];
     	        }
			}else if  (company==4){
     	        if (lord_admiral_name!=""){
     	        	 name[company][k]=lord_admiral_name;
     	        } else{
     	        	lord_admiral_name = name[company][k];
     	        }
			}else if  (company==5){
     	        if (march_master_name!=""){
     	        	 name[company][k]=march_master_name;
     	        } else{
     	        	march_master_name = name[company][k];
     	        }
     	    }else if  (company==6){
     	        if (rites_master_name!=""){
     	        	 name[company][k]=rites_master_name;
     	        } else{
     	        	rites_master_name = name[company][k];
     	        }
     	    }else if  (company==7){
     	        if (chief_victualler_name!=""){
     	        	 name[company][k]=chief_victualler_name;
     	        } else{
     	        	chief_victualler_name = name[company][k];
     	        }
     	    }else if  (company==8){
     	        if (lord_executioner_name!=""){
     	        	 name[company][k]=lord_executioner_name;
     	        } else{
     	        	lord_executioner_name = name[company][k];
     	        }
     	    }else if  (company==9){
     	        if (relic_master_name!=""){
     	        	 name[company][k]=relic_master_name;
     	        } else{
     	        	relic_master_name = name[company][k];
     	        }
     	    }else if  (company==10){
     	        if (recruiter_name!=""){
     	        	 name[company][k]=recruiter_name;
     	        } else{
     	        	recruiter_name = name[company][k];
     	        }
     	    }

			wep2[company][k] = wep2[101, 5];
			spawn_unit = TTRPG[company][k];
			// used to randomly make a marine an old guard of their company, giving a bit more xp (TODO) and fancier armor they've hanged onto all these years	
			spawn_unit.marine_assembling();
			wep1[company][k] = wep1[101, 5];
			wep2[company][k] = choose_weighted(weapon_weighted_lists.pistols);
			if (company = 8) and(obj_creation.equal_specialists = 0) then mobi[company][k] = "Jump Pack";
			if (mobi[101, 5] != "") then mobi[company][k] = mobi[101, 5];
			gear[company][k] = gear[101, 5];

			if (global.chapter_name != "Space Wolves") and(global.chapter_name != "Iron Hands") {
				k += 1;
				commands += 1; // Company Chaplain
				race[company][k] = 1;
				TTRPG[company][k] = new TTRPG_stats("chapter", company, k);
				loc[company][k] = home_name;
				role[company][k] = roles.chaplain;
				wep1[company][k] = wep1[101, 14];
				name[company][k] = global.name_generator.generate_space_marine_name();
				wep2[company][k] = choose_weighted(weapon_weighted_lists.pistols);
				gear[company][k] = gear[101, 14];
				if (company = 8) and(obj_creation.equal_specialists = 0) then mobi[company][k] = "Jump Pack";
				if (mobi[101, 14] != "") then mobi[company][k] = mobi[101, 14];
				spawn_unit = TTRPG[company][k]
				spawn_unit.marine_assembling();
			}

			k += 1;
			commands += 1; // Company Apothecary
			race[company][k] = 1;
			loc[company][k] = home_name;
			TTRPG[company][k] = new TTRPG_stats("chapter", company, k);
			role[company][k] = roles.apothecary;
			name[company][k] = global.name_generator.generate_space_marine_name();
			spawn_unit = TTRPG[company][k]
			spawn_unit.marine_assembling();
			wep1[company][k] = wep1[101, 15];
			wep2[company][k] = choose_weighted(weapon_weighted_lists.pistols);
			gear[company][k] = gear[101, 15];
			if (mobi[101, 15] != "") then mobi[company][k] = mobi[101, 15];

			if (global.chapter_name = "Space Wolves") {
				k += 1;
				commands += 1; // Company Apothecary
				race[company][k] = 1;
				TTRPG[company][k] = new TTRPG_stats("chapter", company, k);
				loc[company][k] = home_name;
				role[company][k] = roles.apothecary;
				wep1[company][k] = wep1[101, 15];
				name[company][k] = global.name_generator.generate_space_marine_name();
				wep2[company][k] = choose_weighted(weapon_weighted_lists.pistols);
				gear[company][k] = gear[101, 15];
				if (mobi[101, 15] != "") then mobi[company][k] = mobi[101, 15];
				spawn_unit = TTRPG[company][k]
				spawn_unit.marine_assembling();
			}

			repeat(techmarines_per_company) {
				k += 1; // Company Techmarine
				commands += 1;
				race[company][k] = 1;
				TTRPG[company][k] = new TTRPG_stats("chapter", company, k);
				loc[company][k] = home_name;
				role[company][k] = roles.techmarine;
				name[company][k] = global.name_generator.generate_space_marine_name();
				if (mobi[101, 16] != "") then mobi[company][k] = mobi[101, 16];
				spawn_unit = TTRPG[company][k]
				spawn_unit.marine_assembling();
				gear[company][k] = gear[101, 16];
				wep1[company][k] = wep1[101, 16];
				wep2[company][k] = choose_weighted(weapon_weighted_lists.pistols);
			}

			if (!array_contains(obj_creation.dis, "Psyker Intolerant")) {
				k += 1; // Company Librarian
				commands += 1;
				race[company][k] = 1;
				TTRPG[company][k] = new TTRPG_stats("chapter", company, k);
				loc[company][k] = home_name;
				role[company][k] = roles.librarian;
				name[company][k] = global.name_generator.generate_space_marine_name();
				if (mobi[101, 17] != "") then mobi[company][k] = mobi[101, 17];
				spawn_unit = TTRPG[company][k]
				spawn_unit.marine_assembling();
				gear[company][k] = gear[101, 17];
				wep1[company][k] = wep1[101, 17];
				wep2[company][k] = choose_weighted(weapon_weighted_lists.pistols);
				if (psyky = 1){
					spawn_unit.add_exp(10);
				}
				var let = "";
				var letmax = 0;
				if (obj_creation.discipline = "default") {
					let = "D";
					letmax = 7;
				}
				if (obj_creation.discipline = "biomancy") {
					let = "B";
					letmax = 5;
				}
				if (obj_creation.discipline = "pyromancy") {
					let = "P";
					letmax = 5;
				}
				if (obj_creation.discipline = "telekinesis") {
					let = "T";
					letmax = 4;
				}
				if (obj_creation.discipline = "rune Magick") {
					let = "R";
					letmax = 5;
				}
				spe[company][k] += string(let) + "0|";
				TTRPG[company][k].add_trait("warp_touched");
				TTRPG[company][k].psionic = choose(8, 9, 10, 11, 12, 13, 14);
				TTRPG[company][k].update_powers();
			}

			k += 1; // Standard Bearer
			race[company][k] = 1;
			loc[company][k] = home_name;
			TTRPG[company][k] = new TTRPG_stats("chapter", company, k);
			role[company][k] = roles.ancient;
			name[company][k] = global.name_generator.generate_space_marine_name();
			spawn_unit = TTRPG[company][k];
			spawn_unit.marine_assembling();
			wep1[company][k] = wep1[101, 11];
			wep2[company][k] = wep2[101, 11];

			k += 1;
			man_size += 1; // Champion
			race[company][k] = 1;
			TTRPG[company][k] = new TTRPG_stats("chapter", company, k);
			loc[company][k] = home_name;
			role[company][k] = roles.champion;
			name[company][k] = global.name_generator.generate_space_marine_name();
			wep1[company][k] = wep1[100, 7];
			wep2[company][k] = wep2[100, 7];
			gear[company][k] = gear[100, 7];
			if (company = 8) and(obj_creation.equal_specialists = 0) then mobi[company][k] = "Jump Pack";
			spawn_unit = TTRPG[company][k];
			spawn_unit.add_trait("champion");
			spawn_unit.marine_assembling();
			// have equal spec true or false have same old_guard chance
			// it doesn't fully make sense why new marines in reserve companies would have the same chance
			// but otherwise you'd always pick true so you'd have more shit
			// just making em the same to reduce meta/power gaming
			if (obj_creation.equal_specialists = 1) {
				if (company < 10) {
					repeat(temp1) {
						k += 1;
						man_size += 1;
						TTRPG[company][k] = new TTRPG_stats("chapter", company, k);
						race[company][k] = 1;
						loc[company][k] = home_name;
						role[company][k] = roles.tactical;
						wep1[company][k] = wep1[101, 8];
						wep2[company][k] = wep2[101, 8];
						name[company][k] = global.name_generator.generate_space_marine_name();
						spawn_unit = TTRPG[company][k];
						spawn_unit.marine_assembling();
					}
					repeat(assault) {
						k += 1;
						man_size += 1;
						TTRPG[company][k] = new TTRPG_stats("chapter", company, k);
						race[company][k] = 1;
						loc[company][k] = home_name;
						role[company][k] = roles.assault;
						wep1[company][k] = wep1[101, 10];
						name[company][k] = global.name_generator.generate_space_marine_name();
						mobi[company][k] = "Jump Pack";
						wep2[company][k] = wep2[101, 10];
						spawn_unit = TTRPG[company][k];
						spawn_unit.marine_assembling();
					}
					repeat(devastator) {
						k += 1;
						man_size += 1;
						race[company][k] = 1;
						loc[company][k] = home_name;
						role[company][k] = roles.devastator;
						wep2[company][k] = wep2[101][9];
						mobi[company][k] = mobi[100][9];
						name[company][k] = global.name_generator.generate_space_marine_name();
						TTRPG[company][k] = new TTRPG_stats("chapter", company, k);
						if (wep1[101, 9] == "Heavy Ranged") then wep1[company][k] = choose("Multi-Melta", "Lascannon", "Missile Launcher", "Heavy Bolter");
						if (wep1[101, 9] != "Heavy Ranged") then wep1[company][k] = wep1[101, 9];
						spawn_unit = TTRPG[company][k];
						spawn_unit.marine_assembling();
					}
				}
				if (company = 10) {

					repeat(temp1) {
						k += 1;
						man_size += 1;
						TTRPG[company][k] = new TTRPG_stats("chapter", company, k, "scout");
						race[company][k] = 1;
						loc[company][k] = home_name;
						role[company][k] = roles.scout;
						wep1[company][k] = wep1[101, 12];
						name[company][k] = global.name_generator.generate_space_marine_name();
						wep2[company][k] = wep2[101, 12];
						armour[company][k] = "Scout Armour";
						spawn_unit = TTRPG[company][k];
						spawn_unit.marine_assembling();
					}
				}
			}

			if (obj_creation.equal_specialists = 0) {
				if (company < 8) then repeat(temp1) {
					k += 1;
					man_size += 1;
					TTRPG[company][k] = new TTRPG_stats("chapter", company, k);

					race[company][k] = 1;
					loc[company][k] = home_name;
					role[company][k] = roles.tactical;
					wep1[company][k] = wep1[101, 8];
					wep2[company][k] = wep2[101, 8];
					name[company][k] = global.name_generator.generate_space_marine_name();
					spawn_unit = TTRPG[company][k];
					spawn_unit.marine_assembling();
				} 
				
				// reserve company only of assault
				if (company = 8) then repeat(temp1) {
					k += 1;
					man_size += 1; // assault reserve company
					TTRPG[company][k] = new TTRPG_stats("chapter", company, k);
					race[company][k] = 1;
					loc[company][k] = home_name;
					role[company][k] = roles.assault;
					wep1[company][k] = wep1[101, 10];
					wep2[company][k] = wep2[101, 10];
					name[company][k] = global.name_generator.generate_space_marine_name();
					mobi[company][k] = "Jump Pack";
					spawn_unit = TTRPG[company][k]
					spawn_unit.marine_assembling();
				} 
				
				// reserve company only devo
				if (company = 9) then repeat(temp1) {
					k += 1;
					man_size += 1;
					TTRPG[company][k] = new TTRPG_stats("chapter", company, k);
					race[company][k] = 1;
					loc[company][k] = home_name;
					role[company][k] = roles.devastator;
					name[company][k] = global.name_generator.generate_space_marine_name();
					wep2[company][k] = wep2[101, 9];
					mobi[company][k] = mobi[100][9];
					if (wep1[101, 9] = "Heavy Ranged") then wep1[company][k] = choose("Multi-Melta", "Lascannon", "Missile Launcher", "Heavy Bolter");
					if (wep1[101, 9] != "Heavy Ranged") then wep1[company][k] = wep1[101, 9];
					spawn_unit = TTRPG[company][k]
					spawn_unit.marine_assembling();
				}
	
				if (company = 10) then
				for (var i = 0; i < temp1; i++) {
					k += 1;
					man_size += 1;
					TTRPG[company][k] = new TTRPG_stats("chapter", company, k, "scout");
					race[company][k] = 1;
					loc[company][k] = home_name;
					role[company][k] = roles.scout;
					wep1[company][k] = wep1[101, 12];
					name[company][k] = global.name_generator.generate_space_marine_name();
					wep2[company][k] = wep2[101, 12];
					armour[company][k] = "Scout Armour";
					spawn_unit = TTRPG[company][k];
					spawn_unit.marine_assembling();
				}

				if (company_unit2 = "assault") then repeat(assault) {
					k += 1;
					man_size += 1;
					TTRPG[company][k] = new TTRPG_stats("chapter", company, k);
					race[company][k] = 1;
					loc[company][k] = home_name;
					role[company][k] = roles.assault;
					wep1[company][k] = wep1[101, 10];
					wep2[company][k] = wep2[101, 10];
					name[company][k] = global.name_generator.generate_space_marine_name();
					mobi[company][k] = mobi[101, 10];
					spawn_unit = TTRPG[company][k]
					spawn_unit.marine_assembling();
				}

				if (company_unit3 = "devastator") then repeat(devastator) {
					k += 1;
					man_size += 1;
					TTRPG[company][k] = new TTRPG_stats("chapter", company, k);
					race[company][k] = 1;
					loc[company][k] = home_name;
					role[company][k] = roles.devastator;
					name[company][k] = global.name_generator.generate_space_marine_name();
					wep2[company][k] = wep2[101, 9];
					mobi[company][k] = mobi[100][9];
					if (wep1[101, 9] = "Heavy Ranged") then wep1[company][k] = choose("Multi-Melta", "Lascannon", "Missile Launcher", "Heavy Bolter");
					if (wep1[101, 9] != "Heavy Ranged") then wep1[company][k] = wep1[101, 9];
					spawn_unit = TTRPG[company][k];
					spawn_unit.marine_assembling();
				}
			}

			if (dready > 0) {
				repeat(dready) {
					k += 1;
					man_size += 10;
					commands += 1;
					TTRPG[company][k] = new TTRPG_stats("chapter", company, k, "dreadnought");
					race[company][k] = 1;
					loc[company][k] = home_name;
					role[company][k] = roles.dreadnought;
					wep1[company][k] = "Close Combat Weapon";
					name[company][k] = global.name_generator.generate_space_marine_name();
					wep2[company][k] = wep2[101, 6];
					armour[company][k] = "Dreadnought";
					spawn_unit = TTRPG[company][k];
					spawn_unit.roll_age();
					spawn_unit.roll_experience();
					if (company = 9) then wep1[company][k] = "Missile Launcher";
				}
			}


			if (rhinoy > 0) then repeat(rhinoy) {
				v += 1;
				man_size += 10;
				veh_race[company, v] = 1;
				veh_loc[company, v] = home_name;
				veh_role[company, v] = "Rhino";
				veh_wep1[company, v] = "Storm Bolter";
				veh_wep2[company, v] = "HK Missile";
				veh_wep3[company, v] = "";
				veh_upgrade[company, v] = "";
				veh_acc[company, v] = "Dozer Blades";
				veh_hp[company, v] = 100;
				veh_chaos[company, v] = 0;
				veh_pilots[company, v] = 0;
				veh_lid[company, v] = 0;
				veh_wid[company, v] = 2;
			}
			if (whirly > 0) then repeat(whirly) {
				v += 1;
				man_size += 10;
				veh_race[company, v] = 1;
				veh_loc[company, v] = home_name;
				veh_role[company, v] = "Whirlwind";
				veh_wep1[company, v] = "Whirlwind Missiles";
				veh_wep2[company, v] = "HK Missile";
				veh_wep3[company, v] = "";
				veh_upgrade[company, v] = "";
				veh_acc[company, v] = "";
				veh_hp[company, v] = 100;
				veh_chaos[company, v] = 0;
				veh_pilots[company, v] = 0;
				veh_lid[company, v] = 0;
				veh_wid[company, v] = 2;
			}
			if (speedy > 0) then repeat(speedy) {
				v += 1;
				man_size += 6;
				veh_race[company, v] = 1;
				veh_loc[company, v] = home_name;
				veh_role[company, v] = "Land Speeder";
				veh_wep1[company, v] = "Heavy Bolter";
				veh_wep2[company, v] = "";
				veh_wep3[company, v] = "";
				veh_upgrade[company, v] = "";
				veh_acc[company, v] = "";
				veh_hp[company, v] = 100;
				veh_chaos[company, v] = 0;
				veh_pilots[company, v] = 0;
				veh_lid[company, v] = 0;
				veh_wid[company, v] = 2;
			}
			if (company = 9) or(global.chapter_name = "Iron Hands") {
				var predy;
				predy = 5;
				if (global.chapter_name = "Iron Hands") then predy = 2;

				if (obj_creation.custom == 1) and (array_contains(obj_creation.adv, "Tech-Brothers")) then predy -=2;

				repeat(predy) {
					v += 1;
					man_size += 10;
					veh_race[company, v] = 1;
					veh_loc[company, v] = home_name;
					veh_role[company, v] = "Predator";
					if (!floor(v mod 2) == 1) {
						veh_wep1[company, v] = "Twin Linked Lascannon Turret";
						veh_wep2[company, v] = "Lascannon Sponsons";
						veh_wep3[company, v] = "HK Missile";
						veh_upgrade[company, v] = "";
						veh_acc[company, v] = "Searchlight";
					}
					if (floor(v mod 2) == 1) {
						veh_wep1[company, v] = "Autocannon Turret";
						veh_wep2[company, v] = "Heavy Bolter Sponsons";
						veh_wep3[company, v] = "Storm Bolter";
						veh_upgrade[company, v] = "";
						veh_acc[company, v] = "Dozer Blades";
					}
					veh_wid[company, v] = 2;
					veh_hp[company, v] = 100;
					veh_chaos[company, v] = 0;
					veh_pilots[company, v] = 0;
					veh_lid[company, v] = 0;
				}
			}
			man_size += k;
		}

		if (company = 2) then seconds = k;
		if (company = 3) then thirds = k
		if (company = 4) then fourths = k;
		if (company = 5) then fifths = k;
		if (company = 6) then sixths = k;
		if (company = 7) then sevenths = k;
		if (company = 8) then eighths = k;
		if (company = 9) then ninths = k;
		if (company = 10) then tenths = k;

	}


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


	instance_create(0, 0, obj_restart_vars);
	scr_restart_variables(1);


	var eqi = 0;
	eqi += 1;
	equipment[eqi] = "MK7 Aquila";
	equipment_number[eqi] = 10;
	equipment_type[eqi] = "armour";
	eqi += 1;
	equipment[eqi] = "MK8 Errant";
	equipment_number[eqi] = 1;
	equipment_type[eqi] = "armour";
	eqi += 1;
	equipment[eqi] = "Scout Armour";
	equipment_number[eqi] = 20;
	equipment_type[eqi] = "armour";
	eqi += 1;
	equipment[eqi] = "Bolter";
	equipment_number[eqi] = 20;
	equipment_type[eqi] = "weapon";
	eqi += 1;
	equipment[eqi] = "Chainsword";
	equipment_number[eqi] = 20;
	equipment_type[eqi] = "weapon";
	eqi += 1;
	equipment[eqi] = "Lascannon";
	equipment_number[eqi] = 5;
	equipment_type[eqi] = "weapon";
	eqi += 1;
	equipment[eqi] = "Heavy Bolter";
	equipment_number[eqi] = 5;
	equipment_type[eqi] = "weapon";
	eqi += 1;
	equipment[eqi] = "Jump Pack";
	equipment_number[eqi] = 10;
	equipment_type[eqi] = "gear";
	eqi += 1;
	equipment[eqi] = "Bike";
	equipment_number[eqi] = 40;
	equipment_type[eqi] = "vehicle";
	scr_add_item("Bolt Pistol", 5);
	scr_add_item("Heavy Weapons Pack", 10);
	scr_add_item(wep1[101, 12], 20);
	scr_add_item(wep2[101, 12], 20);
	if (global.chapter_name = "Iron Hands") then scr_add_item("Bionics", 200);
	/*if (global.chapter_name="Black Templars") then 
			arti = obj_ini.artifact_struct[last_artifact];
			arti.name = "The Black Sword";
			arti.custom_description = "An all black two handed Power Sword bestowed upon the Chapter's father Sigismund by the Emperor ";
			obj_ini.artifact[last_artifact] = "Power Sword";
			obj_ini.artifact_identified[last_artifact] = 0;
			arti = obj_ini.artifact_struct[last_artifact];
			arti.name = "The Armor of Faith";
			arti.custom_description = "A Masterfully crafted suit of artificer armor bestowed upon the Emperor's Champion";
			obj_ini.artifact[last_artifact] = "Artificer Armor";
			obj_ini.artifact_identified[last_artifact] = 0;
			*/

	if (scr_has_disadv("Sieged")) {
		scr_add_item("Narthecium", 4);
		scr_add_item(wep1[101, 15], 4);
		scr_add_item(wep2[101, 15], 4);
		scr_add_item("Psychic Hood", 4);
		scr_add_item("Force Staff", 4);
		scr_add_item("Plasma Pistol", 4);

		o = 0;
		chapter_option = 0;
		repeat(4) {
			o += 1;
			if (obj_creation.adv[o] = "Crafters") then chapter_option = 1;
		}
		if (chapter_option = 1) then scr_add_item("Tartaros", 10);
		else {
			scr_add_item("Terminator Armour", 10);
		}

		scr_add_item("MK7 Aquila", 200);
		scr_add_item("Bolter", 200);
		scr_add_item("Chainsword", 200);
		scr_add_item("Jump Pack", 80);
		scr_add_item("Bolt Pistol", 80);
		scr_add_item("Heavy Bolter", 40);
		scr_add_item("Lascannon", 40);
		scr_add_item("Power Weapon", 12);
		scr_add_item("Rosarius", 4);
	}
	if (!scr_has_disadv("Sieged")) {
		scr_add_item("Dreadnought", 6);
		scr_add_item("Close Combat Weapon", 6);
	}
	if (array_contains(obj_creation.adv, "Venerable Ancients")) {
		scr_add_item("Dreadnought", 4);
		scr_add_item("Close Combat Weapon", 4);
	}

	// man_size+=80;// bikes

	// if (string_count("Crafter",strin)>0) and (string_count("Enthusi",strin)>0) then equipment_number[1]=20;
	// if (string_count("Crafter",strin)>0) and (string_count("Enthusi",strin)=0) then equipment_number[2]=20;

	if (scr_has_adv("Crafters")) && (scr_has_adv("Melee Enthusiasts")) {
		eqi += 1;
		equipment[eqi] = "MK3 Iron Armour";
		equipment_number[eqi] = round(random_range(2, 12));
		equipment_type[eqi] = "armour";
	}
	if (scr_has_adv("Crafters")) && (!scr_has_adv("Melee Enthusiasts")) {
		eqi += 1;
		equipment[eqi] = "MK4 Maximus";
		equipment_number[eqi] = round(random_range(3, 18));
		equipment_type[eqi] = "armour";
	}


	var i;
	i = -1;
	repeat(121) {
		i += 1;
		slave_batch_num[i] = 0;
		slave_batch_eta[i] = 0;
	}




	var bloo = 0,
		o = 0;
	if (array_contains(obj_creation.dis, "Blood Debt")) {
		bloo = 1;
		if (instance_exists(obj_controller)) {
			obj_controller.blood_debt = 1;
			penitent = 1;
			penitent_max = (obj_creation.strength * 1000) + 300;
			penitent_current = 300;
			penitent_end = obj_creation.strength * 48;
		}
	} else {
		if (fleet_type = 3) {
			penitent = 1;
			penitent_max = (obj_creation.strength * 60);
			penitent_current = 1;
			penitent_end = obj_creation.strength * 5;

			if (obj_creation.chapter = "Lamenters") {
				penitent_max = 600;
				penitent_end = 600;
				// obj_controller.loyalty=50;obj_controller.loyalty_hidden=50;
			}
		}
	}
}

//function for making deep copies of structs as gml has no function
function DeepCloneStruct(clone_struct) {
	if (is_array(clone_struct)) {
		var len = array_length(clone_struct);
		var arr = array_create(len);
		for (var i = 0; i < len; ++i) {
			arr[i] = DeepCloneStruct(clone_struct[i]);
		}
		return arr;
	} else if (is_struct(clone_struct)) {
		var stc = {};
		var nms = variable_struct_get_names(clone_struct);
		var len = array_length(nms);
		for (var i = 0; i < len; ++i) {
			var nm = nms[i];
			stc[$nm] = DeepCloneStruct(clone_struct[$nm]);
		}
		return stc;
	}
	return clone_struct;
}