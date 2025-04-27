/// @description Constructor for loading Chapter data from JSON and providing type completion
/// see the actual json files for extended documentation on each property
function ChapterData() constructor {
	id = eCHAPTERS.UNKNOWN;
	name = "";
	points = 0;
	flavor = "";
	origin = eCHAPTER_ORIGINS.NONE;
	founding = ePROGENITOR.NONE;
	successors = 0;
	splash = 0;
	icon_name = "unknown";
	aspirant_trial = eTrials.BLOODDUEL;
	fleet_type = ePlayerBase.none;
	strength = 0;
	purity = 0;
	stability = 0;
	cooperation = 0;
	homeworld = "Hive"; //e.g. "Death"
	homeworld_name = global.name_generator.generate_star_name(); // e.g. "The Rock"
	homeworld_exists = 0;
	recruiting_exists = 0;
	recruiting = "Death"; 
	recruiting_name = global.name_generator.generate_star_name();
	homeworld_rule = eHOMEWORLD_RULE.NONE;
	home_spawn_loc = 1;
	recruit_home_relationship = 1;
	home_warp = 1;
	culture_styles = [];
	home_planets = 1;

	flagship_name = global.name_generator.generate_imperial_ship_name();
	monastary_name = "";
	advantages = array_create(9);
	disadvantages = array_create(9);
	discipline = "librarius"; // todo convert to enum

	full_liveries = "";
	company_liveries = "";
	complex_livery_data = complex_livery_default();


	colors = {
		main: "Grey",
		secondary: "Grey",
		pauldron_r: "Grey",
		pauldron_l: "Grey",
		trim: "Grey",
		lens: "Grey",
		weapon: "Grey",
		/// 0 - normal, 1 - Breastplate, 2 - Vertical, 3 - Quadrant
		special: 0,
		/// 0 no, 1 yes for special trim colours
		//trim_on: 0,
	};
	names = {
		hchaplain: global.name_generator.generate_space_marine_name(),
		clibrarian: global.name_generator.generate_space_marine_name(),
		fmaster: global.name_generator.generate_space_marine_name(),
		hapothecary: global.name_generator.generate_space_marine_name(),
		recruiter: global.name_generator.generate_space_marine_name(),
		admiral: global.name_generator.generate_space_marine_name(),
		honorcapt: global.name_generator.generate_space_marine_name(),
		watchmaster: global.name_generator.generate_space_marine_name(),
		arsenalmaster: global.name_generator.generate_space_marine_name(),
		marchmaster: global.name_generator.generate_space_marine_name(),
		ritesmaster: global.name_generator.generate_space_marine_name(),
		victualler: global.name_generator.generate_space_marine_name(),
		lordexec: global.name_generator.generate_space_marine_name(),
		relmaster: global.name_generator.generate_space_marine_name(),
	};
	mutations = {
		preomnor: 0,
		voice: 0,
		doomed: 0,
		lyman: 0,
		omophagea: 0,
		ossmodula: 0,
		membrane: 0,
		zygote: 0,
		betchers: 0,
		catalepsean: 0,
		secretions: 0,
		occulobe: 0,
		mucranoid: 0,
	};
	battle_cry = "For the Emperor";
	equal_specialists = 0;
	load_to_ships = {
		escort_load: 2,
		split_scouts: 0,
		split_vets: 0,
	};
	/// @type {Array<Real>} 
	disposition = array_create(10, 0);
	/// @type {Array<String>} 
	company_titles = array_create(11, "");
	chapter_master = {
		name: global.name_generator.generate_space_marine_name(),
		melee: 0,
		ranged: 0,
		specialty: eCM_SPECIALTY.NONE,
		/// @type {Array<String>}
		traits: [],
		gear: "",
		mobi: "",
		armour: "",
	};
	extra_ships = {
		battle_barges: 0,
		gladius: 0,
		strike_cruisers: 0,
		hunters: 0
	};
	extra_specialists = {
		chaplains: 0,
		techmarines: 0,
		apothecary: 0,
		epistolary: 0,
		codiciery: 0,
		lexicanum: 0,
		terminator: 0,
		assault: 0,
		veteran: 0,
		devastator: 0,
	};
	extra_marines = {
		second: 0,
		third: 0,
		fourth: 0,
		fifth: 0,
		sixth: 0,
		seventh: 0,
		eighth: 0,
		ninth: 0,
		tenth: 0,
	};
	extra_vehicles = {
		rhino: 0,
		whirlwind: 0,
		predator: 0,
		land_raider: 0,
		land_speeder: 0,
	}
	extra_equipment = [];
	custom_roles = {};
	squad_name = "Squad";
	custom_squads = {};


	custom_advisors = {};


	/// @desc Returns true if loaded successfully, false if not.
	/// @param {Enum.eCHAPTERS} chapter_id 
	/// @param {Bool} use_app_data if set to true will read from %AppData%/Local/ChapterMaster instead of /datafiles
	/// @returns {Bool} 
	function load_from_json(chapter_id, use_app_data = false){
		var file_loader = new JsonFileListLoader();
		var load_result;
		if(use_app_data){
			load_result = file_loader.load_struct_from_json_file($"chaptersave#{chapter_id}.json", "chapter", true);
		} else {
			 load_result = file_loader.load_struct_from_json_file($"main\\chapters\\{chapter_id}.json", "chapter", false);
		}
		if(!load_result.is_success){
			// log_error($"No chapter json exits for chapter_id {chapter_id}");
			return false;
		}
		var json_chapter = load_result.value.chapter;
		var keys = struct_get_names(json_chapter);
		for(var i = 0; i < array_length(keys); i++){
			var key = keys[i];
			var val = struct_get(json_chapter, key);

			// Treat incoming empty vals as 'use default' and don't overwrite
			// a value if it was already set in the chapter constructor
			if (struct_exists(self, key)){
				if(self[$key] != "" && val == ""){
					continue;
				}
			}
			struct_set(self, key, val);
		}
		return true;
	}
}

/// @mixin obj_creation
/// @description called when a chapter's icon is clicked on the first page after the main menu.
/// used to set up initialise the data that is later fed into `scr_initialize_custom` when the game starts
function scr_chapter_new(argument0) {

	full_liveries = ""; // until chapter objects are in full use kicks off livery propogation

	company_liveries = "";

	// argument0 = chapter
	obj_creation.use_chapter_object = false; // for the new json testing
	var chapter_id = eCHAPTERS.UNKNOWN;

	//1st captain =	honor_captain_name	
	//2nd captain =	watch_master_name	
	//3rd captain = arsenal_master_name	
	//4th captain =	lord_admiral_name
	//5th captain =	march_master_name
	//6th captain =	rites_master_name
	//7th captain =	chief_victualler_name
	//8th captain =	lord_executioner_name
	//9th captain =	relic_master_name
	//10th captain = recruiter_name

	var i = 0;
	world = array_create(20, "");
	world_type = array_create(20, "");
	world_feature = array_create(20, "");
	

	points=100;maxpoints=100;
	
	function load_default_gear(_role_id, _role_name, _wep1, _wep2, _armour, _mobi, _gear){
		for(var i = 100; i <=102; i++){
			obj_creation.role[i][_role_id] = _role_name;
			obj_creation.wep1[i][_role_id] = _wep1;
			obj_creation.wep2[i][_role_id] = _wep2;
			obj_creation.armour[i][_role_id] = _armour;
			obj_creation.mobi[i][_role_id] = _mobi;
			obj_creation.gear[i][_role_id] = _gear;
			obj_creation.race[i][_role_id] = 1;
		}
	}
	load_default_gear(eROLE.HonourGuard, "Honour Guard", "Power Sword", "Bolter", "Artificer Armour", "", "");
	load_default_gear(eROLE.Veteran, "Veteran", "Combiflamer", "Combat Knife", STR_ANY_POWER_ARMOUR, "", "");
	load_default_gear(eROLE.Terminator, "Terminator", "Power Fist", "Storm Bolter", "Terminator Armour", "", "");
	load_default_gear(eROLE.Captain, "Captain", "Power Sword", "Bolt Pistol", STR_ANY_POWER_ARMOUR, "", "Iron Halo");
	load_default_gear(eROLE.Dreadnought, "Dreadnought", "Dreadnought Lightning Claw", "Lascannon", "Dreadnought", "", "");
	load_default_gear(eROLE.Champion, "Champion", "Power Sword", STR_ANY_POWER_ARMOUR, STR_ANY_POWER_ARMOUR, "", "Combat Shield");
	load_default_gear(eROLE.Tactical, "Tactical", "Bolter", "Combat Knife", STR_ANY_POWER_ARMOUR, "", "");
	load_default_gear(eROLE.Devastator, "Devastator", "", "Combat Knife", STR_ANY_POWER_ARMOUR, "", "");
	load_default_gear(eROLE.Assault, "Assault", "Chainsword", "Bolt Pistol", STR_ANY_POWER_ARMOUR, "Jump Pack", "");
	load_default_gear(eROLE.Ancient, "Ancient", "Company Standard", "Bolt Pistol", STR_ANY_POWER_ARMOUR, "", "");
	load_default_gear(eROLE.Scout, "Scout", "Bolter", "Combat Knife", "Scout Armour", "", "");
	load_default_gear(eROLE.Chaplain, "Chaplain", "Crozius Arcanum", "Bolt Pistol", STR_ANY_POWER_ARMOUR, "", "Rosarius");
	load_default_gear(eROLE.Apothecary, "Apothecary", "Chainsword", "Bolt Pistol", STR_ANY_POWER_ARMOUR, "", "Narthecium");
	load_default_gear(eROLE.Techmarine, "Techmarine", "Power Axe", "Bolt Pistol", "Artificer Armour", "Servo-arm", "");
	load_default_gear(eROLE.Librarian, "Librarian", "Force Staff", "Bolt Pistol", STR_ANY_POWER_ARMOUR, "", "Psychic Hood");
	load_default_gear(eROLE.Sergeant, "Sergeant", "Chainsword", "Bolt Pistol", STR_ANY_POWER_ARMOUR, "", "");
	load_default_gear(eROLE.VeteranSergeant, "Veteran Sergeant", "Chainsword", "Plasma Pistol", STR_ANY_POWER_ARMOUR, "", "");


	for(var c = 0; c < array_length(obj_creation.all_chapters); c++){
		if(argument0 == obj_creation.all_chapters[c].name && obj_creation.all_chapters[c].json == true){
			obj_creation.use_chapter_object = true;
			chapter_id = obj_creation.all_chapters[c].id;
		}
	}

	if(obj_creation.use_chapter_object){

		var chapter_obj = new ChapterData();
		var successfully_loaded = chapter_obj.load_from_json(chapter_id);
		if(!successfully_loaded){
			var issue = $"No json file exists for chapter id {chapter_id} and name {argument0}";
			// log_error(issue);
			scr_popup("Error Loading Chapter", issue, "debug");
			return false;
		}

		global.chapter_creation_object = chapter_obj;


	}

	#region Custom Chapter
	//generates custom chapter if it exists
	if (is_real(argument0) && argument0 >= eCHAPTERS.CUSTOM_1 && argument0 <= eCHAPTERS.CUSTOM_10){
		obj_creation.use_chapter_object = true;
		var chapter_obj = new ChapterData();
		var successfully_loaded = chapter_obj.load_from_json(argument0, true);
		if(!successfully_loaded){
			var issue = $"No json file exists for chapter id {argument0} and name {argument0}";
			log_error(issue);
			scr_popup("Error Loading Chapter", issue, "debug");
			return false;
		}
		global.chapter_creation_object = chapter_obj;
	}
	#endregion



	if(obj_creation.use_chapter_object){
				
		var chapter_object = global.chapter_creation_object;
		
		// * All of this obj_creation setting is just to keep things working 
		obj_creation.founding = chapter_object.founding;
		obj_creation.successors = chapter_object.successors;
		obj_creation.homeworld_rule = chapter_object.homeworld_rule;
		obj_creation.chapter_name = chapter_object.name;

		global.chapter_icon.name = chapter_object.icon_name;
		obj_creation.fleet_type = chapter_object.fleet_type;
		obj_creation.strength = chapter_object.strength;
		obj_creation.purity = chapter_object.purity;
		obj_creation.stability = chapter_object.stability;
		obj_creation.cooperation = chapter_object.cooperation;
		
		obj_creation.homeworld_exists = chapter_object.homeworld_exists;
		obj_creation.homeworld = chapter_object.homeworld;
		obj_creation.homeworld_rule = chapter_object.homeworld_rule;
		obj_creation.homeworld_name = chapter_object.homeworld_name;

		obj_creation.recruiting_exists = chapter_object.recruiting_exists;
		obj_creation.recruiting = chapter_object.recruiting;
		obj_creation.recruiting_name = chapter_object.recruiting_name;

		obj_creation.buttons.home_spawn_loc_options.current_selection = chapter_object.home_spawn_loc ?? 1;
		obj_creation.buttons.recruit_home_relationship.current_selection = chapter_object.recruit_home_relationship ?? 1;
		obj_creation.buttons.home_warp.current_selection = chapter_object.home_warp ?? 1;
		obj_creation.buttons.home_planets.current_selection =   chapter_object.home_planets ??1;

		obj_creation.aspirant_trial = trial_map(chapter_object.aspirant_trial);
		obj_creation.adv = chapter_object.advantages;
		obj_creation.dis = chapter_object.disadvantages;

		obj_creation.buttons.culture_styles.set(chapter_object.culture_styles);
		obj_creation.full_liveries = chapter_object.full_liveries;
		obj_creation.company_liveries = chapter_object.company_liveries;
		obj_creation.complex_livery_data = chapter_object.complex_livery_data;
		if (obj_creation.full_liveries!=""){
			obj_creation.livery_picker.map_colour = full_liveries[0];
			obj_creation.livery_picker.role_set = 0;   		
		}

		obj_creation.color_to_main = chapter_object.colors.main;
		obj_creation.color_to_secondary = chapter_object.colors.secondary;
		obj_creation.color_to_pauldron = chapter_object.colors.pauldron_l;
		obj_creation.color_to_pauldron2 = chapter_object.colors.pauldron_r;
		obj_creation.color_to_trim = chapter_object.colors.trim;
		obj_creation.color_to_lens = chapter_object.colors.lens;
		obj_creation.color_to_weapon = chapter_object.colors.weapon;
		obj_creation.col_special = chapter_object.colors.special;
		//obj_creation.trim = chapter_object.colors.trim_on;
		with (obj_creation){
			if (array_length(col)>0){
			    if (color_to_main!=""){
			        main_color = max(array_find_value(col,color_to_main),0);
			        color_to_main = "";
			    }
			    if (color_to_secondary!=""){
			        secondary_color = max(array_find_value(col,color_to_secondary),0);
			        color_to_secondary = "";
			    }
			    if (color_to_trim!=""){
			        main_trim = max(array_find_value(col,color_to_trim),0);
			        color_to_trim = "";
			    }
			    if (color_to_pauldron2!=""){
			        right_pauldron = max(array_find_value(col,color_to_pauldron2),0);
			        color_to_pauldron2 = "";  
			    }
			    if (color_to_pauldron!=""){
			        left_pauldron = max(array_find_value(col,color_to_pauldron),0);
			        color_to_pauldron = "";
			    }
			    if (color_to_lens!=""){
			        lens_color = max(array_find_value(col,color_to_lens),0);
			        color_to_lens = ""; 
			    }
			    if (color_to_weapon!=""){
			        weapon_color = max(array_find_value(col,color_to_weapon),0);
			        color_to_weapon = "";
			    }
			}
			var struct_cols = {
		        main_color :main_color,
		        secondary_color:secondary_color,
		        main_trim:main_trim,
		        right_pauldron:right_pauldron,
		        left_pauldron:left_pauldron,
		        lens_color:lens_color,
		        weapon_color:weapon_color
		    }
		    livery_picker = new ColourItem(100,230);
			if (company_liveries == ""){
			    livery_picker.scr_unit_draw_data(-1);
			    company_liveries = array_create(11,variable_clone(livery_picker.map_colour));
			} else {
				livery_picker.scr_unit_draw_data(-1);
				var _all_maps = struct_get_names(livery_picker.map_colour);
				for (var i=0;i<array_length(company_liveries);i++){
					var _comp_data = company_liveries[i];
					for (var s=0;s<array_length(_all_maps);s++){
						var _name = _all_maps[s];
						if !(struct_exists(_comp_data,_name )){
							_comp_data[$ _name] = livery_picker.map_colour[$ _name];
						}
					}
				}
			}  
			livery_picker.scr_unit_draw_data();
			if (full_liveries==""){
			    livery_picker.scr_unit_draw_data();
			    livery_picker.set_default_armour(struct_cols,col_special);
			    full_liveries = array_create(21,variable_clone(livery_picker.map_colour)); 			    
			    full_liveries[eROLE.Librarian] = livery_picker.set_default_librarian(struct_cols);

			    full_liveries[eROLE.Chaplain] = livery_picker.set_default_chaplain(struct_cols);

			    full_liveries[eROLE.Apothecary] = livery_picker.set_default_apothecary(struct_cols);

			    full_liveries[eROLE.Techmarine] = livery_picker.set_default_techmarines(struct_cols);
			    livery_picker.scr_unit_draw_data();
			    livery_picker.set_default_armour(struct_cols,col_special); 			
			} else {
				if (array_length(full_liveries) != 21){
					full_liveries = array_create(21,variable_clone(full_liveries[0])); 
					struct_cols.left_pauldron = full_liveries[0].left_pauldron;
				    full_liveries[eROLE.Librarian] = livery_picker.set_default_librarian(struct_cols);

				    full_liveries[eROLE.Chaplain] = livery_picker.set_default_chaplain(struct_cols);

				    full_liveries[eROLE.Apothecary] = livery_picker.set_default_apothecary(struct_cols);

				    full_liveries[eROLE.Techmarine] = livery_picker.set_default_techmarines(struct_cols);					
				}
			}
			livery_picker.map_colour = full_liveries[0];
			livery_picker.role_set = 0;  			 			
		}
		// handles making sure blank names are generated properly and only 
		// actual values being set in the json will overwrite them
		struct_foreach(chapter_object.names, function(key, val){
			if(val != ""){
				struct_set(obj_creation, key, val);
			}
		});

		obj_creation.battle_cry = chapter_object.battle_cry;
		obj_creation.discipline = chapter_object.discipline;

		var load = chapter_object.load_to_ships;
		obj_creation.load_to_ships = [load.escort_load, load.split_scouts, load.split_vets];
		obj_creation.equal_specialists = chapter_object.equal_specialists;
		if(struct_exists(chapter_object, "scout_company_behaviour")){
			obj_creation.scout_company_behaviour = chapter_object.scout_company_behaviour;
		} else {
			obj_creation.scout_company_behaviour = 0; //default
		}
		if(struct_exists(chapter_object, "equal_scouts")){
			obj_creation.equal_scouts = chapter_object.equal_scouts;
		} else {
			obj_creation.equal_scouts = 0;
		}
		
		obj_creation.mutations = 0;
		struct_foreach(chapter_object.mutations, function(key, val){
			struct_set(obj_creation, key, val);
			if(val == 1) {
				obj_creation.mutations += 1;
			}
		});

		obj_creation.disposition = chapter_object.disposition;

		obj_creation.chapter_master = chapter_object.chapter_master;

		if(chapter_object.chapter_master.name != ""){
			obj_creation.chapter_master_name = chapter_object.chapter_master.name;
		}
		obj_creation.chapter_master_melee = chapter_object.chapter_master.melee;
		obj_creation.chapter_master_ranged = chapter_object.chapter_master.ranged;
		obj_creation.chapter_master_specialty = chapter_object.chapter_master.specialty;
		if(struct_exists(chapter_object, "company_titles")){
			obj_creation.company_title = chapter_object.company_titles;
		}

		if(struct_exists(chapter_object, "artifact")){
			obj_creation.artifact = chapter_object.artifact;
		}
		
		obj_creation.flagship_name = chapter_object.flagship_name;
		obj_creation.extra_ships = chapter_object.extra_ships;
		obj_creation.extra_specialists = chapter_object.extra_specialists;
		obj_creation.extra_marines = chapter_object.extra_marines;
		obj_creation.extra_vehicles = chapter_object.extra_vehicles;
		obj_creation.extra_equipment = chapter_object.extra_equipment;

		obj_creation.squad_name = chapter_object.squad_name;
		if(struct_exists(chapter_object, "custom_roles")){
			obj_creation.custom_roles = chapter_object.custom_roles;
		}
		if(struct_exists(chapter_object, "custom_squads")){
			obj_creation.custom_squads = chapter_object.custom_squads;
		}

		if(struct_exists(chapter_object, "custom_advisors")){
			obj_creation.custom_advisors = chapter_object.custom_advisors;
		}
		
		


		points = chapter_object.points;
		maxpoints=chapter_object.points;	

	}






	
	for(var a = 0; a < array_length(adv); a++){
	    for(var k = 0; k < array_length(obj_creation.all_advantages); k++){
			if(adv[a]!="" && obj_creation.all_advantages[k].name=adv[a]){
				adv_num[a] = k;
			}
		}
		for(var j = 0; j < array_length(obj_creation.all_disadvantages); j++){
			if (dis[a]!="" && obj_creation.all_disadvantages[j].name=dis[a]){
				dis_num[a]=j;
			}
		}
	}



	maxpoints=points;
	return true;
}

enum eHOMEWORLD_RULE {
	NONE = 0,
	GOVERNOR = 1,
	COUNTRY,
	PERSONAL,
}

enum eCM_SPECIALTY {
	NONE = 0,
	LEADER = 1,
	CHAMPION,
	PSYKER,
}
enum eRecruitHomeRelationship{
	SAMEPLANET,
	SAMESYSTEM,
	DIFFERENTSYSTEM,
}
