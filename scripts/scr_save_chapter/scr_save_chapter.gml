/// @mixin obj_creation
function scr_save_chapter(chapter_id){
	//saves a player made chapter into json file in AppData for use later
	var chaptersave  = $"chaptersave#{chapter_id}.json";
	var custom_splash = 97;
	var chap = new ChapterData();
	chap.id = chapter_id;
	chap.splash = custom_splash;
	chap.name = chapter_name;
	chap.flavor = "Your Chapter";
	chap.founding = founding;
	chap.origin = eCHAPTER_ORIGINS.CUSTOM;
	chap.icon = icon;

	chap.icon_name = obj_creation.icon_name;

	chap.aspirant_trial = aspirant_trial;
	chap.fleet_type = fleet_type;
	chap.strength = strength;
	chap.purity = purity;
	chap.stability = stability;
	chap.cooperation = cooperation;
	chap.homeworld = homeworld;
	chap.homeworld_exists = homeworld_exists;
	chap.homeworld_name = homeworld_name;
	chap.homeworld_rule = homeworld_rule;
	chap.recruiting = recruiting;
	chap.recruiting_exists = recruiting_exists;
	
	chap.home_spawn_loc = buttons.home_spawn_loc_options.current_selection;
	chap.recruit_home_relationship = buttons.recruit_home_relationship.current_selection;
	chap.home_warp = buttons.home_warp.current_selection;
	chap.home_planets = buttons.home_planets.current_selection;

	chap.advantages = adv;
	chap.disadvantages = dis;

	chap.culture_styles = buttons.culture_styles.selections();
	chap.colors = {
		main: col[main_color],
		secondary: col[secondary_color],
		pauldron_l: col[left_pauldron],
		pauldron_r: col[right_pauldron],
		trim: col[main_trim],
		//trim_on: trim,
		lens: col[lens_color],
		weapon: col[weapon_color],
		special: col_special
	};
	chap.full_liveries = full_liveries;
	chap.company_liveries = company_liveries;
	chap.complex_livery_data = complex_livery_data;
	chap.names = {
		hapothecary: hapothecary,
		hchaplain: hchaplain,
		admiral: admiral,
		clibrarian: clibrarian,
		recruiter: recruiter,
		fmaster: fmaster,
		honorcapt: global.name_generator.generate_imperial_name(),
		watchmaster: global.name_generator.generate_imperial_name(),
		arsenalmaster: global.name_generator.generate_imperial_name(),
		marchmaster: global.name_generator.generate_imperial_name(),
		ritesmaster: global.name_generator.generate_imperial_name(),
		victualler: global.name_generator.generate_imperial_name(),
		lordexec: global.name_generator.generate_imperial_name(),
		relmaster: global.name_generator.generate_imperial_name(),
	}
	chap.mutations = {
		preomnor: preomnor,
		voice: voice,
		doomed: doomed,
		lyman: lyman,
		omophagea: omophagea,
		ossmodula: ossmodula,
		membrane: membrane,
		zygote: zygote,
		betchers: betchers,
		catalepsean: catalepsean,
		secretions: secretions,
		occulobe: occulobe,
		mucranoid: mucranoid,
	}
	chap.battle_cry = battle_cry;
	chap.equal_specialists = equal_specialists;
	chap.load_to_ships = {
		escort_load: load_to_ships[0],
		split_scouts: load_to_ships[1],
		split_vets: load_to_ships[2],
	};

	chap.disposition = disposition;
	if(variable_instance_exists(self.id, "monastery_name")){
		chap.monastary_name = monastery_name;
	}
	chap.chapter_master = {
		name: chapter_master_name,
		melee: chapter_master_melee,
		ranged: chapter_master_ranged,
		specialty: chapter_master_specialty,
		traits: [],
	}

	chap.custom_roles = custom_roles;
	
	
	global.chapter_creation_object = chap;

	var data_json = json_stringify({chapter: global.chapter_creation_object}, true);
	if(file_exists(chaptersave)){
		file_delete(chaptersave);
	}
	var fileid = file_text_open_write(chaptersave);
	file_text_write_string(fileid, data_json);
	file_text_close(fileid)
	

}