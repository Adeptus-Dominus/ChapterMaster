// Restarts variables, ensuring loaded saves are properly initialized
/// @mixin
function scr_restart_variables(saved_game) {
	try {
		if (saved_game == 1) {
			with (obj_ini) {
				// show_message(instance_number(obj_restart_vars));

				obj_restart_vars.restart_name = obj_creation.chapter_name;
				obj_restart_vars.restart_founding = global.founding;

				obj_restart_vars.restart_secret = global.founding_secret;
				obj_restart_vars.restart_title[0] = "";

				for (var i = 1; i < array_length(obj_restart_vars.restart_title); i++) {
					obj_restart_vars.restart_title[i] = obj_ini.company_title[i];
				}

				obj_restart_vars.restart_icon = global.chapter_icon.name;
				obj_restart_vars.restart_powers = psy_powers;

				for (var ad = 0; ad < 5; ad++) {
					if (ad == 0) {
						obj_restart_vars.restart_adv[ad] = "";
						obj_restart_vars.restart_dis[ad] = "";
					}
					if (ad > 0) {
						obj_restart_vars.restart_adv[ad] = adv[ad];
						obj_restart_vars.restart_dis[ad] = dis[ad];
					}
				}
				// show_message("A: "+string(obj_restart_vars.restart_dis[1]));

				obj_restart_vars.restart_recruiting_type = recruiting_type;
				obj_restart_vars.restart_trial = 0;
				obj_restart_vars.restart_recruiting_name = recruiting_name;
				obj_restart_vars.restart_home_type = home_type;
				obj_restart_vars.restart_home_name = home_name;
				obj_restart_vars.restart_fleet_type = fleet_type;
				obj_restart_vars.restart_flagship_name = obj_creation.flagship_name;

				obj_restart_vars.restart_recruiting_exists = obj_creation.recruiting_exists;
				obj_restart_vars.restart_homeworld_exists = obj_creation.homeworld_exists;
				obj_restart_vars.restart_homeworld_rule = obj_creation.homeworld_rule;

				obj_restart_vars.restart_battle_cry = obj_creation.battle_cry;

				obj_restart_vars.restart_main_color = obj_creation.main_color;
				obj_restart_vars.restart_secondary_color = obj_creation.secondary_color;
				obj_restart_vars.restart_trim_color = obj_creation.main_trim;
				obj_restart_vars.restart_pauldron2_color = obj_creation.left_pauldron;
				obj_restart_vars.restart_pauldron_color = obj_creation.right_pauldron;
				obj_restart_vars.restart_lens_color = obj_creation.lens_color;
				obj_restart_vars.restart_weapon_color = obj_creation.weapon_color;
				obj_restart_vars.restart_col_special = obj_creation.col_special;
				obj_restart_vars.restart_trim = obj_creation.trim;
				obj_restart_vars.restart_skin_color = obj_creation.skin_color;

				obj_restart_vars.restart_hapothecary = obj_creation.hapothecary;
				obj_restart_vars.restart_hchaplain = obj_creation.hchaplain;
				obj_restart_vars.restart_clibrarian = obj_creation.clibrarian;
				obj_restart_vars.restart_fmaster = obj_creation.fmaster;
				obj_restart_vars.restart_recruiter = obj_creation.recruiter;
				obj_restart_vars.restart_admiral = obj_creation.admiral;

				obj_restart_vars.restart_equal_specialists = obj_creation.equal_specialists;
				obj_restart_vars.restart_load_to_ships = obj_creation.load_to_ships;
				obj_restart_vars.restart_successors = obj_creation.successors;

				obj_restart_vars.restart_mutations = obj_creation.mutations;
				obj_restart_vars.restart_preomnor = obj_creation.preomnor;
				obj_restart_vars.restart_voice = obj_creation.voice;
				obj_restart_vars.restart_doomed = obj_creation.doomed;
				obj_restart_vars.restart_lyman = obj_creation.lyman;
				obj_restart_vars.restart_omophagea = obj_creation.omophagea;
				obj_restart_vars.restart_ossmodula = obj_creation.ossmodula;
				obj_restart_vars.restart_membrane = obj_creation.membrane;
				obj_restart_vars.restart_zygote = obj_creation.zygote;
				obj_restart_vars.restart_betchers = obj_creation.betchers;
				obj_restart_vars.restart_catalepsean = obj_creation.catalepsean;
				obj_restart_vars.restart_secretions = obj_creation.secretions;
				obj_restart_vars.restart_occulobe = obj_creation.occulobe;
				obj_restart_vars.restart_mucranoid = obj_creation.mucranoid;

				obj_restart_vars.restart_master_name = obj_creation.chapter_master_name;
				obj_restart_vars.restart_master_melee = obj_creation.chapter_master_melee;
				obj_restart_vars.restart_master_ranged = obj_creation.chapter_master_ranged;
				obj_restart_vars.restart_master_specialty = obj_creation.chapter_master_specialty;

				obj_restart_vars.restart_strength = obj_creation.strength;
				obj_restart_vars.restart_cooperation = obj_creation.cooperation;
				obj_restart_vars.restart_purity = obj_creation.purity;
				obj_restart_vars.restart_stability = obj_creation.stability;

				// 100 is defaults, 101 is the allowable starting equipment
				for (var i = 100; i < 103; i++) {
					obj_restart_vars.r_race[i, 2] = 1;
					obj_restart_vars.r_role[i, 2] = "Honour Guard";
					obj_restart_vars.r_wep1[i, 2] = "Power Sword";
					obj_restart_vars.r_wep2[i, 2] = "Bolter";
					obj_restart_vars.r_armour[i, 2] = "Artificer Armour";
					obj_restart_vars.r_mobi[i, 2] = "";
					obj_restart_vars.r_gear[i, 2] = "";

					obj_restart_vars.r_race[i, 3] = 1;
					obj_restart_vars.r_role[i, 3] = "Veteran";
					obj_restart_vars.r_wep1[i, 3] = "Chainsword";
					obj_restart_vars.r_wep2[i, 3] = "Bolter";
					obj_restart_vars.r_armour[i, 3] = STR_ANY_POWER_ARMOUR;
					obj_restart_vars.r_mobi[i, 3] = "";
					obj_restart_vars.r_gear[i, 3] = "";

					obj_restart_vars.r_race[i, 4] = 1;
					obj_restart_vars.r_role[i, 4] = "Terminator";
					obj_restart_vars.r_wep1[i, 4] = "Power Fist";
					obj_restart_vars.r_wep2[i, 4] = "Storm Bolter";
					obj_restart_vars.r_armour[i, 4] = "Terminator Armour";
					obj_restart_vars.r_mobi[i, 4] = "";
					obj_restart_vars.r_gear[i, 4] = "";

					obj_restart_vars.r_race[i, 5] = 1;
					obj_restart_vars.r_role[i, 5] = "Captain";
					obj_restart_vars.r_wep1[i, 5] = "Power Sword";
					obj_restart_vars.r_wep2[i, 5] = "Bolt Pistol";
					obj_restart_vars.r_armour[i, 5] = STR_ANY_POWER_ARMOUR;
					obj_restart_vars.r_mobi[i, 5] = "";
					obj_restart_vars.r_gear[i, 5] = "Iron Halo";

					obj_restart_vars.r_race[i, 6] = 1;
					obj_restart_vars.r_role[i, 6] = "Dreadnought";
					obj_restart_vars.r_wep1[i, 6] = "Close Combat Weapon";
					obj_restart_vars.r_wep2[i, 6] = "Twin Linked Lascannon";
					obj_restart_vars.r_armour[i, 6] = "Dreadnought";
					obj_restart_vars.r_mobi[i, 6] = "";
					obj_restart_vars.r_gear[i, 6] = "";

					obj_restart_vars.r_race[i, 7] = 1;
					obj_restart_vars.r_role[i, 7] = "Champion";
					obj_restart_vars.r_wep1[i, 7] = "Power Sword";
					obj_restart_vars.r_wep2[i, 7] = "Bolt Pistol";
					obj_restart_vars.r_armour[i, 7] = STR_ANY_POWER_ARMOUR;
					obj_restart_vars.r_mobi[i, 7] = "";
					obj_restart_vars.r_gear[i, 7] = "Combat Shield";

					obj_restart_vars.r_race[i, 8] = 1;
					obj_restart_vars.r_role[i, 8] = "Tactical Marine";
					obj_restart_vars.r_wep1[i, 8] = "Bolter";
					obj_restart_vars.r_wep2[i, 8] = "Combat Knife";
					obj_restart_vars.r_armour[i, 8] = STR_ANY_POWER_ARMOUR;
					obj_restart_vars.r_mobi[i, 8] = "";
					obj_restart_vars.r_gear[i, 8] = "";

					obj_restart_vars.r_race[i, 9] = 1;
					obj_restart_vars.r_role[i, 9] = "Devastator Marine";
					obj_restart_vars.r_wep1[i, 9] = "";
					obj_restart_vars.r_wep2[i, 9] = "Combat Knife";
					obj_restart_vars.r_armour[i, 9] = STR_ANY_POWER_ARMOUR;
					obj_restart_vars.r_mobi[i, 9] = "";
					obj_restart_vars.r_gear[i, 9] = "";

					obj_restart_vars.r_race[i, 10] = 1;
					obj_restart_vars.r_role[i, 10] = "Assault Marine";
					obj_restart_vars.r_wep1[i, 10] = "Chainsword";
					obj_restart_vars.r_wep2[i, 10] = "Bolt Pistol";
					obj_restart_vars.r_armour[i, 10] = STR_ANY_POWER_ARMOUR;
					obj_restart_vars.r_mobi[i, 10] = "Jump Pack";
					obj_restart_vars.r_gear[i, 10] = "";

					obj_restart_vars.r_role[i, 11] = "Ancient";
					obj_restart_vars.r_wep1[i, 11] = "Company Standard";
					obj_restart_vars.r_wep2[i, 11] = "Power Sword";
					obj_restart_vars.r_armour[i, 11] = STR_ANY_POWER_ARMOUR;
					obj_restart_vars.r_mobi[i, 11] = "";
					obj_restart_vars.r_gear[i, 11] = "";

					obj_restart_vars.r_race[i, 12] = 1;
					obj_restart_vars.r_role[i, 12] = "Scout";
					obj_restart_vars.r_wep1[i, 12] = "Sniper Rifle";
					obj_restart_vars.r_wep2[i, 12] = "Combat Knife";
					obj_restart_vars.r_armour[i, 12] = "Scout Armour";
					obj_restart_vars.r_mobi[i, 12] = "";
					obj_restart_vars.r_gear[i, 12] = "";

					obj_restart_vars.r_race[i, 14] = 1;
					obj_restart_vars.r_role[i, 14] = "Chaplain";
					obj_restart_vars.r_wep1[i, 14] = "Power Sword";
					obj_restart_vars.r_wep2[i, 14] = "Bolt Pistol";
					obj_restart_vars.r_armour[i, 14] = STR_ANY_POWER_ARMOUR;
					obj_restart_vars.r_gear[i, 14] = "Rosarius";
					obj_restart_vars.r_mobi[i, 14] = "";

					obj_restart_vars.r_race[i, 15] = 1;
					obj_restart_vars.r_role[i, 15] = "Apothecary";
					obj_restart_vars.r_wep1[i, 15] = "Chainsword";
					obj_restart_vars.r_wep2[i, 15] = "Bolt Pistol";
					obj_restart_vars.r_armour[i, 15] = STR_ANY_POWER_ARMOUR;
					obj_restart_vars.r_gear[i, 15] = "Narthecium";
					obj_restart_vars.r_mobi[i, 15] = "";

					obj_restart_vars.r_race[i, 16] = 1;
					obj_restart_vars.r_role[i, 16] = "Techmarine";
					obj_restart_vars.r_wep1[i, 16] = "Power Axe";
					obj_restart_vars.r_wep2[i, 16] = "Storm Bolter";
					obj_restart_vars.r_armour[i, 16] = "Artificer Armour";
					obj_restart_vars.r_gear[i, 16] = "";
					obj_restart_vars.r_mobi[i, 16] = "Servo-arm";

					obj_restart_vars.r_race[i, 17] = 1;
					obj_restart_vars.r_role[i, 17] = "Librarian";
					obj_restart_vars.r_wep1[i, 17] = "Force Staff";
					obj_restart_vars.r_wep2[i, 17] = "Bolt Pistol";
					obj_restart_vars.r_armour[i, 17] = STR_ANY_POWER_ARMOUR;
					obj_restart_vars.r_gear[i, 17] = "Psychic Hood";
					obj_restart_vars.r_mobi[i, 17] = "";

					obj_restart_vars.r_race[i, 18] = 1;
					obj_restart_vars.r_role[i, 18] = "Sergeant";
					obj_restart_vars.r_wep1[i, 18] = "Chainsword";
					obj_restart_vars.r_wep2[i, 18] = "Storm Bolter";
					obj_restart_vars.r_armour[i, 18] = STR_ANY_POWER_ARMOUR;
					obj_restart_vars.r_gear[i, 18] = "";
					obj_restart_vars.r_mobi[i, 18] = "";

					obj_restart_vars.r_race[i, 19] = 1;
					obj_restart_vars.r_role[i, 19] = "Veteran Sergeant";
					obj_restart_vars.r_wep1[i, 19] = "Chainsword";
					obj_restart_vars.r_wep2[i, 19] = "Storm Bolter";
					obj_restart_vars.r_armour[i, 19] = STR_ANY_POWER_ARMOUR;
					obj_restart_vars.r_gear[i, 19] = "";
					obj_restart_vars.r_mobi[i, 19] = "";
				}

				for (var i = 0; i < 21; i++) {
					obj_restart_vars.r_race[100, i] = race[100, i];
					obj_restart_vars.r_role[100, i] = role[100, i];
					obj_restart_vars.r_wep1[100, i] = wep1[100, i];
					obj_restart_vars.r_wep2[100, i] = wep2[100, i];
					obj_restart_vars.r_armour[100, i] = armour[100, i];
					obj_restart_vars.r_gear[100, i] = gear[100, i];
					obj_restart_vars.r_mobi[100, i] = mobi[100, i];
				}
			}
		}

		if (saved_game == 2) {
			obj_controller.restart_name = obj_restart_vars.restart_name;
			obj_controller.restart_founding = obj_restart_vars.restart_founding;

			obj_controller.restart_secret = obj_restart_vars.restart_secret;
			obj_controller.restart_title[0] = "";

			for (var i = 1; i < array_length(obj_restart_vars.restart_title); i++) {
				obj_controller.restart_title[i] = obj_restart_vars.restart_title[i];
			}

			obj_controller.restart_icon = obj_restart_vars.restart_icon;
			obj_controller.restart_powers = obj_restart_vars.restart_powers;

			for (var ad = 0; ad < 5; ad++) {
				if (ad == 0) {
					obj_controller.restart_adv[ad] = "";
					obj_controller.restart_dis[ad] = "";
				}
				if (ad > 0) {
					obj_controller.restart_adv[ad] = obj_restart_vars.restart_adv[ad];
					obj_controller.restart_dis[ad] = obj_restart_vars.restart_dis[ad];
				}
			}
			// show_message("B: "+string(obj_controller.restart_dis[1]));

			obj_controller.restart_recruiting_type = obj_restart_vars.restart_recruiting_type;
			obj_controller.restart_trial = obj_restart_vars.restart_trial;
			obj_controller.restart_recruiting_name = obj_restart_vars.restart_recruiting_name;
			obj_controller.restart_home_type = obj_restart_vars.restart_home_type;
			obj_controller.restart_home_name = obj_restart_vars.restart_home_name;
			obj_controller.restart_fleet_type = obj_restart_vars.restart_fleet_type;
			obj_controller.restart_flagship_name = obj_restart_vars.restart_flagship_name;

			obj_controller.restart_recruiting_exists = obj_restart_vars.restart_recruiting_exists;
			obj_controller.restart_homeworld_exists = obj_restart_vars.restart_homeworld_exists;
			obj_controller.restart_homeworld_rule = obj_restart_vars.restart_homeworld_rule;

			obj_controller.restart_battle_cry = obj_restart_vars.restart_battle_cry;

			obj_controller.restart_main_color = obj_restart_vars.restart_main_color;
			obj_controller.restart_secondary_color = obj_restart_vars.restart_secondary_color;
			obj_controller.restart_trim_color = obj_restart_vars.restart_trim_color;
			obj_controller.restart_pauldron2_color = obj_restart_vars.restart_pauldron2_color;
			obj_controller.restart_pauldron_color = obj_restart_vars.restart_pauldron_color;
			obj_controller.restart_lens_color = obj_restart_vars.restart_lens_color;
			obj_controller.restart_weapon_color = obj_restart_vars.restart_weapon_color;
			obj_controller.restart_col_special = obj_restart_vars.restart_col_special;
			obj_controller.restart_trim = obj_restart_vars.restart_trim;
			obj_controller.restart_skin_color = obj_restart_vars.restart_skin_color;

			obj_controller.restart_hapothecary = obj_restart_vars.restart_hapothecary;
			obj_controller.restart_hchaplain = obj_restart_vars.restart_hchaplain;
			obj_controller.restart_clibrarian = obj_restart_vars.restart_clibrarian;
			obj_controller.restart_fmaster = obj_restart_vars.restart_fmaster;
			obj_controller.restart_recruiter = obj_restart_vars.restart_recruiter;
			obj_controller.restart_admiral = obj_restart_vars.restart_admiral;

			obj_controller.restart_equal_specialists = obj_restart_vars.restart_equal_specialists;
			obj_controller.restart_load_to_ships = obj_restart_vars.restart_load_to_ships;
			obj_controller.restart_successors = obj_restart_vars.restart_successors;

			obj_controller.restart_mutations = obj_restart_vars.restart_mutations;
			obj_controller.restart_preomnor = obj_restart_vars.restart_preomnor;
			obj_controller.restart_voice = obj_restart_vars.restart_voice;
			obj_controller.restart_doomed = obj_restart_vars.restart_doomed;
			obj_controller.restart_lyman = obj_restart_vars.restart_lyman;
			obj_controller.restart_omophagea = obj_restart_vars.restart_omophagea;
			obj_controller.restart_ossmodula = obj_restart_vars.restart_ossmodula;
			obj_controller.restart_membrane = obj_restart_vars.restart_membrane;
			obj_controller.restart_zygote = obj_restart_vars.restart_zygote;
			obj_controller.restart_betchers = obj_restart_vars.restart_betchers;
			obj_controller.restart_catalepsean = obj_restart_vars.restart_catalepsean;
			obj_controller.restart_secretions = obj_restart_vars.restart_secretions;
			obj_controller.restart_occulobe = obj_restart_vars.restart_occulobe;
			obj_controller.restart_mucranoid = obj_restart_vars.restart_mucranoid;

			obj_controller.restart_master_name = obj_restart_vars.restart_master_name;
			obj_controller.restart_master_melee = obj_restart_vars.restart_master_melee;
			obj_controller.restart_master_ranged = obj_restart_vars.restart_master_ranged;
			obj_controller.restart_master_specialty = obj_restart_vars.restart_master_specialty;

			obj_controller.restart_strength = obj_restart_vars.restart_strength;
			obj_controller.restart_cooperation = obj_restart_vars.restart_cooperation;
			obj_controller.restart_purity = obj_restart_vars.restart_purity;
			obj_controller.restart_stability = obj_restart_vars.restart_stability;

			// 100 is defaults, 101 is the allowable starting equipment
			for (var i = 100; i < 103; i++) {
				obj_controller.r_race[i, 2] = 1;
				obj_controller.r_role[i, 2] = "Honour Guard";
				obj_controller.r_wep1[i, 2] = "Power Sword";
				obj_controller.r_wep2[i, 2] = "Bolter";
				obj_controller.r_armour[i, 2] = "Artificer Armour";
				obj_controller.r_mobi[i, 2] = "";
				obj_controller.r_gear[i, 2] = "";

				obj_controller.r_race[i, 3] = 1;
				obj_controller.r_role[i, 3] = "Veteran";
				obj_controller.r_wep1[i, 3] = "Chainsword";
				obj_controller.r_wep2[i, 3] = "Bolter";
				obj_controller.r_armour[i, 3] = STR_ANY_POWER_ARMOUR;
				obj_controller.r_mobi[i, 3] = "";
				obj_controller.r_gear[i, 3] = "";

				obj_controller.r_race[i, 4] = 1;
				obj_controller.r_role[i, 4] = "Terminator";
				obj_controller.r_wep1[i, 4] = "Power Fist";
				obj_controller.r_wep2[i, 4] = "Storm Bolter";
				obj_controller.r_armour[i, 4] = "Terminator Armour";
				obj_controller.r_mobi[i, 4] = "";
				obj_controller.r_gear[i, 4] = "";

				obj_controller.r_race[i, 5] = 1;
				obj_controller.r_role[i, 5] = "Captain";
				obj_controller.r_wep1[i, 5] = "Power Sword";
				obj_controller.r_wep2[i, 5] = "Bolt Pistol";
				obj_controller.r_armour[i, 5] = STR_ANY_POWER_ARMOUR;
				obj_controller.r_mobi[i, 5] = "";
				obj_controller.r_gear[i, 5] = "";

				obj_controller.r_race[i, 6] = 1;
				obj_controller.r_role[i, 6] = "Dreadnought";
				obj_controller.r_wep1[i, 6] = "Close Combat Weapon";
				obj_controller.r_wep2[i, 6] = "Twin Linked Lascannon";
				obj_controller.r_armour[i, 6] = "Dreadnought";
				obj_controller.r_mobi[i, 6] = "";
				obj_controller.r_gear[i, 6] = "";

				obj_controller.r_race[i, 7] = 1;
				obj_controller.r_role[i, 7] = "Champion";
				obj_controller.r_wep1[i, 7] = "Power Sword";
				obj_controller.r_wep2[i, 7] = "Bolt Pistol";
				obj_controller.r_armour[i, 7] = STR_ANY_POWER_ARMOUR;
				obj_controller.r_mobi[i, 7] = "";
				obj_controller.r_gear[i, 7] = "Combat Shield";

				obj_controller.r_race[i, 8] = 1;
				obj_controller.r_role[i, 8] = "Tactical Marine";
				obj_controller.r_wep1[i, 8] = "Bolter";
				obj_controller.r_wep2[i, 8] = "Combat Knife";
				obj_controller.r_armour[i, 8] = STR_ANY_POWER_ARMOUR;
				obj_controller.r_mobi[i, 8] = "";
				obj_controller.r_gear[i, 8] = "";

				obj_controller.r_race[i, 9] = 1;
				obj_controller.r_role[i, 9] = "Devastator Marine";
				obj_controller.r_wep1[i, 9] = "";
				obj_controller.r_wep2[i, 9] = "Combat Knife";
				obj_controller.r_armour[i, 9] = STR_ANY_POWER_ARMOUR;
				obj_controller.r_mobi[i, 9] = "";
				obj_controller.r_gear[i, 9] = "";

				obj_controller.r_race[i, 10] = 1;
				obj_controller.r_role[i, 10] = "Assault Marine";
				obj_controller.r_wep1[i, 10] = "Chainsword";
				obj_controller.r_wep2[i, 10] = "Bolt Pistol";
				obj_controller.r_armour[i, 10] = STR_ANY_POWER_ARMOUR;
				obj_controller.r_mobi[i, 10] = "Jump Pack";
				obj_controller.r_gear[i, 10] = "";

				obj_controller.r_race[i, 12] = 1;
				obj_controller.r_role[i, 12] = "Scout";
				obj_controller.r_wep1[i, 12] = "Sniper Rifle";
				obj_controller.r_wep2[i, 12] = "Combat Knife";
				obj_controller.r_armour[i, 12] = "Scout Armour";
				obj_controller.r_mobi[i, 12] = "";
				obj_controller.r_gear[i, 12] = "";

				obj_controller.r_race[i, 14] = 1;
				obj_controller.r_role[i, 14] = "Chaplain";
				obj_controller.r_wep1[i, 14] = "Power Sword";
				obj_controller.r_wep2[i, 14] = "Bolt Pistol";
				obj_controller.r_armour[i, 14] = STR_ANY_POWER_ARMOUR;
				obj_controller.r_gear[i, 14] = "Rosarius";
				obj_controller.r_mobi[i, 14] = "";

				obj_controller.r_race[i, 15] = 1;
				obj_controller.r_role[i, 15] = "Apothecary";
				obj_controller.r_wep1[i, 15] = "Chainsword";
				obj_controller.r_wep2[i, 15] = "Bolt Pistol";
				obj_controller.r_armour[i, 15] = STR_ANY_POWER_ARMOUR;
				obj_controller.r_gear[i, 15] = "Narthecium";
				obj_controller.r_mobi[i, 15] = "";

				obj_controller.r_race[i, 16] = 1;
				obj_controller.r_role[i, 16] = "Techmarine";
				obj_controller.r_wep1[i, 16] = "Power Axe";
				obj_controller.r_wep2[i, 16] = "Storm Bolter";
				obj_controller.r_armour[i, 16] = "Artificer Armour";
				obj_controller.r_gear[i, 16] = "";
				obj_controller.r_mobi[i, 16] = "Servo-arm";

				obj_controller.r_race[i, 17] = 1;
				obj_controller.r_role[i, 17] = "Librarian";
				obj_controller.r_wep1[i, 17] = "Force Staff";
				obj_controller.r_wep2[i, 17] = "Bolt Pistol";
				obj_controller.r_armour[i, 17] = STR_ANY_POWER_ARMOUR;
				obj_controller.r_gear[i, 17] = "Psychic Hood";
				obj_controller.r_mobi[i, 17] = "";

				obj_controller.r_race[i, 18] = 1;
				obj_controller.r_role[i, 18] = "Sergeant";
				obj_controller.r_wep1[i, 18] = "Chainsword";
				obj_controller.r_wep2[i, 18] = "Storm Bolter";
				obj_controller.r_armour[i, 18] = STR_ANY_POWER_ARMOUR;
				obj_controller.r_gear[i, 18] = "";
				obj_controller.r_mobi[i, 18] = "";

				obj_controller.r_race[i, 19] = 1;
				obj_controller.r_role[i, 19] = "Veteran Sergeant";
				obj_controller.r_wep1[i, 19] = "Chainsword";
				obj_controller.r_wep2[i, 19] = "Storm Bolter";
				obj_controller.r_armour[i, 19] = STR_ANY_POWER_ARMOUR;
				obj_controller.r_gear[i, 19] = "";
				obj_controller.r_mobi[i, 19] = "";
			}

			for (var i = 0; i < 21; i++) {
				obj_controller.r_race[100, i] = obj_restart_vars.r_race[100, i];
				obj_controller.r_race[101, i] = obj_restart_vars.r_race[100, i];
				obj_controller.r_race[102, i] = obj_restart_vars.r_race[100, i];

				obj_controller.r_role[100, i] = obj_restart_vars.r_role[100, i];
				obj_controller.r_wep1[100, i] = obj_restart_vars.r_wep1[100, i];
				obj_controller.r_wep2[100, i] = obj_restart_vars.r_wep2[100, i];
				obj_controller.r_armour[100, i] = obj_restart_vars.r_armour[100, i];
				obj_controller.r_gear[100, i] = obj_restart_vars.r_gear[100, i];
				obj_controller.r_mobi[100, i] = obj_restart_vars.r_mobi[100, i];
			}
		}

		// Controller to restart vars
		if (saved_game == 3) {
			obj_restart_vars.restart_name = obj_controller.restart_name;
			obj_restart_vars.restart_founding = obj_controller.restart_founding;

			obj_restart_vars.restart_secret = obj_controller.restart_secret;
			obj_restart_vars.restart_title[0] = obj_controller.restart_title[0];

			for (var i = 1; i < array_length(obj_restart_vars.restart_title); i++) {
				obj_restart_vars.restart_title[i] = obj_controller.restart_title[i];
			}

			obj_restart_vars.restart_icon = obj_controller.restart_icon;
			obj_restart_vars.restart_powers = obj_controller.restart_powers;

			for (var ad = 0; ad < 5; ad++) {
				if (ad == 0) {
					obj_restart_vars.restart_adv[ad] = "";
					obj_restart_vars.restart_dis[ad] = "";
				}
				if (ad > 0) {
					obj_restart_vars.restart_adv[ad] = obj_controller.restart_adv[ad];
					obj_restart_vars.restart_dis[ad] = obj_controller.restart_dis[ad];
				}
			}

			// show_message("C: "+string(obj_restart_vars.restart_dis[1]));

			obj_restart_vars.restart_recruiting_type = obj_controller.restart_recruiting_type;
			obj_restart_vars.restart_trial = obj_controller.restart_trial;
			obj_restart_vars.restart_recruiting_name = obj_controller.restart_recruiting_name;
			obj_restart_vars.restart_home_type = obj_controller.restart_home_type; // Good here
			obj_restart_vars.restart_home_name = obj_controller.restart_home_name;
			obj_restart_vars.restart_fleet_type = obj_controller.restart_fleet_type;
			obj_restart_vars.restart_flagship_name = obj_controller.restart_flagship_name;

			obj_restart_vars.restart_recruiting_exists = obj_controller.restart_recruiting_exists;
			obj_restart_vars.restart_homeworld_exists = obj_controller.restart_homeworld_exists;
			obj_restart_vars.restart_homeworld_rule = obj_controller.restart_homeworld_rule;

			obj_restart_vars.restart_battle_cry = obj_controller.restart_battle_cry;

			obj_restart_vars.restart_main_color = obj_controller.restart_main_color;
			obj_restart_vars.restart_secondary_color = obj_controller.restart_secondary_color;
			obj_restart_vars.restart_trim_color = obj_controller.restart_trim_color;
			obj_restart_vars.restart_pauldron2_color = obj_controller.restart_pauldron2_color;
			obj_restart_vars.restart_pauldron_color = obj_controller.restart_pauldron_color;
			obj_restart_vars.restart_lens_color = obj_controller.restart_lens_color;
			obj_restart_vars.restart_weapon_color = obj_controller.restart_weapon_color;
			obj_restart_vars.restart_col_special = obj_controller.restart_col_special;
			obj_restart_vars.restart_trim = obj_controller.restart_trim;
			obj_restart_vars.restart_skin_color = obj_controller.restart_skin_color;

			obj_restart_vars.restart_hapothecary = obj_controller.restart_hapothecary;
			obj_restart_vars.restart_hchaplain = obj_controller.restart_hchaplain;
			obj_restart_vars.restart_clibrarian = obj_controller.restart_clibrarian;
			obj_restart_vars.restart_fmaster = obj_controller.restart_fmaster;
			obj_restart_vars.restart_recruiter = obj_controller.restart_recruiter;
			obj_restart_vars.restart_admiral = obj_controller.restart_admiral;

			obj_restart_vars.restart_equal_specialists = obj_controller.restart_equal_specialists;
			obj_restart_vars.restart_load_to_ships = obj_controller.restart_load_to_ships;
			obj_restart_vars.restart_successors = obj_controller.restart_successors;

			obj_restart_vars.restart_mutations = obj_controller.restart_mutations;
			obj_restart_vars.restart_preomnor = obj_controller.restart_preomnor;
			obj_restart_vars.restart_voice = obj_controller.restart_voice;
			obj_restart_vars.restart_doomed = obj_controller.restart_doomed;
			obj_restart_vars.restart_lyman = obj_controller.restart_lyman;
			obj_restart_vars.restart_omophagea = obj_controller.restart_omophagea;
			obj_restart_vars.restart_ossmodula = obj_controller.restart_ossmodula;
			obj_restart_vars.restart_membrane = obj_controller.restart_membrane;
			obj_restart_vars.restart_zygote = obj_controller.restart_zygote;
			obj_restart_vars.restart_betchers = obj_controller.restart_betchers;
			obj_restart_vars.restart_catalepsean = obj_controller.restart_catalepsean;
			obj_restart_vars.restart_secretions = obj_controller.restart_secretions;
			obj_restart_vars.restart_occulobe = obj_controller.restart_occulobe;
			obj_restart_vars.restart_mucranoid = obj_controller.restart_mucranoid;

			obj_restart_vars.restart_master_name = obj_controller.restart_master_name;
			obj_restart_vars.restart_master_melee = obj_controller.restart_master_melee;
			obj_restart_vars.restart_master_ranged = obj_controller.restart_master_ranged;
			obj_restart_vars.restart_master_specialty = obj_controller.restart_master_specialty;

			obj_restart_vars.restart_strength = obj_controller.restart_strength;
			obj_restart_vars.restart_cooperation = obj_controller.restart_cooperation;
			obj_restart_vars.restart_purity = obj_controller.restart_purity;
			obj_restart_vars.restart_stability = obj_controller.restart_stability;

			for (var i = 0; i < 21; i++) {
				obj_restart_vars.r_race[100, i] = obj_controller.r_race[100, i];
				obj_restart_vars.r_race[101, i] = obj_controller.r_race[100, i];
				obj_restart_vars.r_race[102, i] = obj_controller.r_race[100, i];

				obj_restart_vars.r_role[100, i] = obj_controller.r_role[100, i];
				obj_restart_vars.r_wep1[100, i] = obj_controller.r_wep1[100, i];
				obj_restart_vars.r_wep2[100, i] = obj_controller.r_wep2[100, i];
				obj_restart_vars.r_armour[100, i] = obj_controller.r_armour[100, i];
				obj_restart_vars.r_gear[100, i] = obj_controller.r_gear[100, i];
				obj_restart_vars.r_mobi[100, i] = obj_controller.r_mobi[100, i];
			}
		}

		if (saved_game == 4) {

		}
	} catch (_exception) {
		handle_exception(_exception);
	}
}

function reset_creation_variables(){
	for (var i = 0; i < 21; i++) {
		world[i] = "";
		world_type[i] = "";
		world_feature[i] = "";
	}

	for (var i = 0; i < 6; i++) {
		adv[i] = "";
		adv_num[i] = 0;
		dis[i] = "";
		dis_num[i] = 0;
	}

	points = 100;
	maxpoints = 100;
	custom = 0;

	hapothecary = global.name_generator.generate_space_marine_name();
	hchaplain = global.name_generator.generate_space_marine_name();
	clibrarian = global.name_generator.generate_space_marine_name();
	fmaster = global.name_generator.generate_space_marine_name();
	recruiter = global.name_generator.generate_space_marine_name();
	admiral = global.name_generator.generate_space_marine_name();

	// First is for the correct slot, second is for default info
	for (var i = 100; i < 103; i++) {
		race[i, 2] = 1;
		role[i, 2] = "Honour Guard";
		wep1[i, 2] = "Power Sword";
		wep2[i, 2] = "Bolter";
		armour[i, 2] = "Artificer Armour";

		race[i, 3] = 1;
		role[i, 3] = "Veteran";
		wep1[i, 3] = "Chainsword";
		wep2[i, 3] = "Bolter";
		armour[i, 3] = STR_ANY_POWER_ARMOUR;

		race[i, 4] = 1;
		role[i, 4] = "Terminator";
		wep1[i, 4] = "Power Fist";
		wep2[i, 4] = "Storm Bolter";
		armour[i, 4] = "Terminator Armour";

		race[i, 5] = 1;
		role[i, 5] = "Captain";
		wep1[i, 5] = "Power Sword";
		wep2[i, 5] = "Bolt Pistol";
		armour[i, 5] = STR_ANY_POWER_ARMOUR;
		gear[i, 5] = "Iron Halo";

		race[i, 6] = 1;
		role[i, 6] = "Dreadnought";
		wep1[i, 6] = "Close Combat Weapon";
		wep2[i, 6] = "Twin Linked Lascannon";
		armour[i, 6] = "Dreadnought";

		race[i, 8] = 1;
		role[i, 8] = "Tactical Marine";
		wep1[i, 8] = "Bolter";
		wep2[i, 8] = "Combat Knife";
		armour[i, 8] = STR_ANY_POWER_ARMOUR;

		race[i, 9] = 1;
		role[i, 9] = "Devastator Marine";
		wep1[i, 9] = "";
		wep2[i, 9] = "Combat Knife";
		armour[i, 9] = STR_ANY_POWER_ARMOUR;

		race[i, 10] = 1;
		role[i, 10] = "Assault Marine";
		wep1[i, 10] = "Chainsword";
		wep2[i, 10] = "Bolt Pistol";
		armour[i, 10] = STR_ANY_POWER_ARMOUR;
		mobi[i, 10] = "Jump Pack";

		race[i, 11] = 1;
		role[i, 11] = "Ancient";
		wep1[i, 11] = "Company Standard";
		wep2[i, 11] = "Power Sword";
		armour[i, 11] = STR_ANY_POWER_ARMOUR;

		race[i, 12] = 1;
		role[i, 12] = "Scout";
		wep1[i, 12] = "Sniper Rifle";
		wep2[i, 12] = "Combat Knife";
		armour[i, 12] = "Scout Armour";

		race[i, 14] = 1;
		role[i, 14] = "Chaplain";
		wep1[i, 14] = "Power Sword";
		wep2[i, 14] = "Bolt Pistol";
		armour[i, 14] = STR_ANY_POWER_ARMOUR;
		gear[i, 14] = "Rosarius";

		race[i, 15] = 1;
		role[i, 15] = "Apothecary";
		wep1[i, 15] = "Chainsword";
		wep2[i, 15] = "Bolt Pistol";
		armour[i, 15] = STR_ANY_POWER_ARMOUR;
		gear[i, 15] = "Narthecium";

		race[i, 16] = 1;
		role[i, 16] = "Techmarine";
		wep1[i, 16] = "Power Axe";
		wep2[i, 16] = "Storm Bolter";
		armour[i, 16] = "Artificer Armour";
		gear[i, 16] = "";
		mobi[i, 16] = "Servo-arm";

		race[i, 17] = 1;
		role[i, 17] = "Librarian";
		wep1[i, 17] = "Force Staff";
		wep2[i, 17] = "Bolt Pistol";
		armour[i, 17] = STR_ANY_POWER_ARMOUR;
		gear[i, 17] = "Psychic Hood";

		race[i, 18] = 1;
		role[i, 18] = "Sergeant";
		wep1[i, 18] = "Chainsword";
		wep2[i, 18] = "Storm Bolter";
		armour[i, 18] = STR_ANY_POWER_ARMOUR;
		gear[i, 18] = "";

		race[i, 19] = 1;
		role[i, 19] = "Veteran Sergeant";
		wep1[i, 19] = "Chainsword";
		wep2[i, 19] = "Storm Bolter";
		armour[i, 19] = STR_ANY_POWER_ARMOUR;
		gear[i, 19] = "";
	}

	points = 100;
	selected_chapter = 999;
	chapter = obj_restart_vars.restart_name;
	founding = obj_restart_vars.restart_founding;
	founding_secret = obj_restart_vars.restart_secret;

	company_title[0] = "";

	for (var i = 1; i <= 11; i++) {
		company_title[i] = obj_restart_vars.restart_title[i];
	}

	global.chapter_icon.name = obj_restart_vars.restart_icon;
	discipline = obj_restart_vars.restart_powers;

	for (var ad = 0; ad < 5; ad++) {
		if (ad == 0) {
			adv[ad] = "";
			dis[ad] = "";
		}
		if (ad > 0) {
			adv[ad] = obj_restart_vars.restart_adv[ad];
			dis[ad] = obj_restart_vars.restart_dis[ad];
		}
	}
	// show_message("D: "+string(dis[1]));

	// Need disposition here

	recruiting = obj_restart_vars.restart_recruiting_type;
	aspirant_trial = obj_restart_vars.restart_trial;
	recruiting_name = obj_restart_vars.restart_recruiting_name;
	homeworld = obj_restart_vars.restart_home_type;
	homeworld_name = obj_restart_vars.restart_home_name;
	fleet_type = obj_restart_vars.restart_fleet_type;
	flagship_name = obj_restart_vars.restart_flagship_name;

	recruiting_exists = obj_restart_vars.restart_recruiting_exists;
	homeworld_exists = obj_restart_vars.restart_homeworld_exists;
	homeworld_rule = obj_restart_vars.restart_homeworld_rule;

	battle_cry = obj_restart_vars.restart_battle_cry;

	main_color = obj_restart_vars.restart_main_color;
	secondary_color = obj_restart_vars.restart_secondary_color;
	main_trim = obj_restart_vars.restart_trim_color;
	left_pauldron = obj_restart_vars.restart_pauldron2_color;
	right_pauldron = obj_restart_vars.restart_pauldron_color;
	lens_color = obj_restart_vars.restart_lens_color;
	weapon_color = obj_restart_vars.restart_weapon_color;
	col_special = obj_restart_vars.restart_col_special;
	trim = obj_restart_vars.restart_trim;
	skin_color = obj_restart_vars.restart_skin_color;

	hapothecary = obj_restart_vars.restart_hapothecary;
	hchaplain = obj_restart_vars.restart_hchaplain;
	clibrarian = obj_restart_vars.restart_clibrarian;
	fmaster = obj_restart_vars.restart_fmaster;
	recruiter = obj_restart_vars.restart_recruiter;
	admiral = obj_restart_vars.restart_admiral;

	equal_specialists = obj_restart_vars.restart_equal_specialists;
	load_to_ships = obj_restart_vars.restart_load_to_ships;
	successors = obj_restart_vars.restart_successors;

	mutations = obj_restart_vars.restart_mutations;
	preomnor = obj_restart_vars.restart_preomnor;
	voice = obj_restart_vars.restart_voice;
	doomed = obj_restart_vars.restart_doomed;
	lyman = obj_restart_vars.restart_lyman;
	omophagea = obj_restart_vars.restart_omophagea;
	ossmodula = obj_restart_vars.restart_ossmodula;
	membrane = obj_restart_vars.restart_membrane;
	zygote = obj_restart_vars.restart_zygote;
	betchers = obj_restart_vars.restart_betchers;
	catalepsean = obj_restart_vars.restart_catalepsean;
	secretions = obj_restart_vars.restart_secretions;
	occulobe = obj_restart_vars.restart_occulobe;
	mucranoid = obj_restart_vars.restart_mucranoid;

	chapter_master_name = obj_restart_vars.restart_master_name;
	chapter_master_melee = obj_restart_vars.restart_master_melee;
	chapter_master_ranged = obj_restart_vars.restart_master_ranged;
	chapter_master_specialty = obj_restart_vars.restart_master_specialty;

	strength = obj_restart_vars.restart_strength;
	cooperation = obj_restart_vars.restart_cooperation;
	purity = obj_restart_vars.restart_purity;
	stability = obj_restart_vars.restart_stability;

	for (var i = 0; i < 21; i++) {
		race[100, i] = obj_restart_vars.r_race[100, i];

		role[100, i] = obj_restart_vars.r_role[100, i];
		wep1[100, i] = obj_restart_vars.r_wep1[100, i];
		wep2[100, i] = obj_restart_vars.r_wep2[100, i];
		armour[100, i] = obj_restart_vars.r_armour[100, i];
		gear[100, i] = obj_restart_vars.r_gear[100, i];
		mobi[100, i] = obj_restart_vars.r_mobi[100, i];
	}

	custom = 1;
	restarted = 1;
	mutations_selected = mutations;

	for (var i = 1; i <= 4; i++) {
		if ((adv[i] != "") && (adv_num[i] == 0)) {
			for (var n = 1; n <= 40; n++) {
				if (obj_creation.all_advantages[n].name == adv[i]) {
					adv_num[i] = n;
				}
			}
		}
	}

	for (var i = 1; i <= 4; i++) {
		if ((dis[i] != "") && (dis_num[i] == 0)) {
			for (var n = 1; n <= 40; n++) {
				if (obj_creation.all_disadvantages[n].name[n] == dis[i]) {
					dis_num[i] = n;
				}
			}
		}
	}	
}
