// Restarts variables, ensuring loaded saves are properly initialized
function scr_restart_variables(saved_game) {
    try {
        if (saved_game == 1) {
            with (obj_ini) {
                var _restart_vars_instance = instance_nearest(x, y, obj_restart_vars);
                var _creation_instance = instance_nearest(x, y, obj_creation);
                _restart_vars_instance.restart_name = _creation_instance.chapter_name;
                _restart_vars_instance.restart_founding = global.founding;

                _restart_vars_instance.restart_secret = global.founding_secret;
                _restart_vars_instance.restart_title[0] = "";

                for (var i = 1; i < array_length(_restart_vars_instance.restart_title); i++) {
                    _restart_vars_instance.restart_title[i] = self.company_title[i];
                }

                _restart_vars_instance.restart_icon = global.chapter_icon.name;
                _restart_vars_instance.restart_powers = psy_powers;

                for (var ad = 0; ad < 5; ad++) {
                    if (ad == 0) {
                        _restart_vars_instance.restart_adv[ad] = "";
                        _restart_vars_instance.restart_dis[ad] = "";
                    }
                    if (ad > 0) {
                        _restart_vars_instance.restart_adv[ad] = adv[ad];
                        _restart_vars_instance.restart_dis[ad] = dis[ad];
                    }
                }

                _restart_vars_instance.restart_recruiting_type = recruiting_type;
                _restart_vars_instance.restart_trial = 0;
                _restart_vars_instance.restart_recruiting_name = recruiting_name;
                _restart_vars_instance.restart_home_type = home_type;
                _restart_vars_instance.restart_home_name = home_name;
                _restart_vars_instance.restart_fleet_type = fleet_type;
                _restart_vars_instance.restart_flagship_name = _creation_instance.flagship_name;

                _restart_vars_instance.restart_recruiting_exists = _creation_instance.recruiting_exists;
                _restart_vars_instance.restart_homeworld_exists = _creation_instance.homeworld_exists;
                _restart_vars_instance.restart_homeworld_rule = _creation_instance.homeworld_rule;

                _restart_vars_instance.restart_battle_cry = _creation_instance.battle_cry;

                _restart_vars_instance.restart_main_color = _creation_instance.main_color;
                _restart_vars_instance.restart_secondary_color = _creation_instance.secondary_color;
                _restart_vars_instance.restart_trim_color = _creation_instance.main_trim;
                _restart_vars_instance.restart_pauldron2_color = _creation_instance.left_pauldron;
                _restart_vars_instance.restart_pauldron_color = _creation_instance.right_pauldron;
                _restart_vars_instance.restart_lens_color = _creation_instance.lens_color;
                _restart_vars_instance.restart_weapon_color = _creation_instance.weapon_color;
                _restart_vars_instance.restart_col_special = _creation_instance.col_special;
                _restart_vars_instance.restart_trim = _creation_instance.trim;
                _restart_vars_instance.restart_skin_color = _creation_instance.skin_color;

                _restart_vars_instance.restart_hapothecary = _creation_instance.hapothecary;
                _restart_vars_instance.restart_hchaplain = _creation_instance.hchaplain;
                _restart_vars_instance.restart_clibrarian = _creation_instance.clibrarian;
                _restart_vars_instance.restart_fmaster = _creation_instance.fmaster;
                _restart_vars_instance.restart_recruiter = _creation_instance.recruiter;
                _restart_vars_instance.restart_admiral = _creation_instance.admiral;

                _restart_vars_instance.restart_squad_distribution = _creation_instance.squad_distribution;
                _restart_vars_instance.restart_load_to_ships = _creation_instance.load_to_ships;
                _restart_vars_instance.restart_successors = _creation_instance.successors;

                _restart_vars_instance.restart_mutations = _creation_instance.mutations;
                _restart_vars_instance.restart_preomnor = _creation_instance.preomnor;
                _restart_vars_instance.restart_voice = _creation_instance.voice;
                _restart_vars_instance.restart_doomed = _creation_instance.doomed;
                _restart_vars_instance.restart_lyman = _creation_instance.lyman;
                _restart_vars_instance.restart_omophagea = _creation_instance.omophagea;
                _restart_vars_instance.restart_ossmodula = _creation_instance.ossmodula;
                _restart_vars_instance.restart_membrane = _creation_instance.membrane;
                _restart_vars_instance.restart_zygote = _creation_instance.zygote;
                _restart_vars_instance.restart_betchers = _creation_instance.betchers;
                _restart_vars_instance.restart_catalepsean = _creation_instance.catalepsean;
                _restart_vars_instance.restart_secretions = _creation_instance.secretions;
                _restart_vars_instance.restart_occulobe = _creation_instance.occulobe;
                _restart_vars_instance.restart_mucranoid = _creation_instance.mucranoid;

                _restart_vars_instance.restart_master_name = _creation_instance.chapter_master_name;
                _restart_vars_instance.restart_master_melee = _creation_instance.chapter_master_melee;
                _restart_vars_instance.restart_master_ranged = _creation_instance.chapter_master_ranged;
                _restart_vars_instance.restart_master_specialty = _creation_instance.chapter_master_specialty;

                _restart_vars_instance.restart_strength = _creation_instance.strength;
                _restart_vars_instance.restart_cooperation = _creation_instance.cooperation;
                _restart_vars_instance.restart_purity = _creation_instance.purity;
                _restart_vars_instance.restart_stability = _creation_instance.stability;

                // 100 is defaults, 101 is the allowable starting equipment
                for (var i = 100; i < 103; i++) {
                    _restart_vars_instance.r_race[i][2] = 1;
                    _restart_vars_instance.r_role[i][2] = "Honour Guard";
                    _restart_vars_instance.r_wep1[i][2] = "Power Sword";
                    _restart_vars_instance.r_wep2[i][2] = "Bolter";
                    _restart_vars_instance.r_armour[i][2] = "Artificer Armour";
                    _restart_vars_instance.r_mobi[i][2] = "";
                    _restart_vars_instance.r_gear[i][2] = "";

                    _restart_vars_instance.r_race[i][3] = 1;
                    _restart_vars_instance.r_role[i][3] = "Veteran";
                    _restart_vars_instance.r_wep1[i][3] = "Chainsword";
                    _restart_vars_instance.r_wep2[i][3] = "Bolter";
                    _restart_vars_instance.r_armour[i][3] = STR_ANY_POWER_ARMOUR;
                    _restart_vars_instance.r_mobi[i][3] = "";
                    _restart_vars_instance.r_gear[i][3] = "";

                    _restart_vars_instance.r_race[i][4] = 1;
                    _restart_vars_instance.r_role[i][4] = "Terminator";
                    _restart_vars_instance.r_wep1[i][4] = "Power Fist";
                    _restart_vars_instance.r_wep2[i][4] = "Storm Bolter";
                    _restart_vars_instance.r_armour[i][4] = "Terminator Armour";
                    _restart_vars_instance.r_mobi[i][4] = "";
                    _restart_vars_instance.r_gear[i][4] = "";

                    _restart_vars_instance.r_race[i][5] = 1;
                    _restart_vars_instance.r_role[i][5] = "Captain";
                    _restart_vars_instance.r_wep1[i][5] = "Power Sword";
                    _restart_vars_instance.r_wep2[i][5] = "Bolt Pistol";
                    _restart_vars_instance.r_armour[i][5] = STR_ANY_POWER_ARMOUR;
                    _restart_vars_instance.r_mobi[i][5] = "";
                    _restart_vars_instance.r_gear[i][5] = "Iron Halo";

                    _restart_vars_instance.r_race[i][6] = 1;
                    _restart_vars_instance.r_role[i][6] = "Dreadnought";
                    _restart_vars_instance.r_wep1[i][6] = "Close Combat Weapon";
                    _restart_vars_instance.r_wep2[i][6] = "Twin Linked Lascannon";
                    _restart_vars_instance.r_armour[i][6] = "Dreadnought";
                    _restart_vars_instance.r_mobi[i][6] = "";
                    _restart_vars_instance.r_gear[i][6] = "";

                    _restart_vars_instance.r_race[i][7] = 1;
                    _restart_vars_instance.r_role[i][7] = "Champion";
                    _restart_vars_instance.r_wep1[i][7] = "Power Sword";
                    _restart_vars_instance.r_wep2[i][7] = "Bolt Pistol";
                    _restart_vars_instance.r_armour[i][7] = STR_ANY_POWER_ARMOUR;
                    _restart_vars_instance.r_mobi[i][7] = "";
                    _restart_vars_instance.r_gear[i][7] = "Combat Shield";

                    _restart_vars_instance.r_race[i][8] = 1;
                    _restart_vars_instance.r_role[i][8] = "Tactical Marine";
                    _restart_vars_instance.r_wep1[i][8] = "Bolter";
                    _restart_vars_instance.r_wep2[i][8] = "Combat Knife";
                    _restart_vars_instance.r_armour[i][8] = STR_ANY_POWER_ARMOUR;
                    _restart_vars_instance.r_mobi[i][8] = "";
                    _restart_vars_instance.r_gear[i][8] = "";

                    _restart_vars_instance.r_race[i][9] = 1;
                    _restart_vars_instance.r_role[i][9] = "Devastator Marine";
                    _restart_vars_instance.r_wep1[i][9] = "";
                    _restart_vars_instance.r_wep2[i][9] = "Combat Knife";
                    _restart_vars_instance.r_armour[i][9] = STR_ANY_POWER_ARMOUR;
                    _restart_vars_instance.r_mobi[i][9] = "";
                    _restart_vars_instance.r_gear[i][9] = "";

                    _restart_vars_instance.r_race[i][10] = 1;
                    _restart_vars_instance.r_role[i][10] = "Assault Marine";
                    _restart_vars_instance.r_wep1[i][10] = "Chainsword";
                    _restart_vars_instance.r_wep2[i][10] = "Bolt Pistol";
                    _restart_vars_instance.r_armour[i][10] = STR_ANY_POWER_ARMOUR;
                    _restart_vars_instance.r_mobi[i][10] = "Jump Pack";
                    _restart_vars_instance.r_gear[i][10] = "";

                    _restart_vars_instance.r_role[i][11] = "Ancient";
                    _restart_vars_instance.r_wep1[i][11] = "Company Standard";
                    _restart_vars_instance.r_wep2[i][11] = "Power Sword";
                    _restart_vars_instance.r_armour[i][11] = STR_ANY_POWER_ARMOUR;
                    _restart_vars_instance.r_mobi[i][11] = "";
                    _restart_vars_instance.r_gear[i][11] = "";

                    _restart_vars_instance.r_race[i][12] = 1;
                    _restart_vars_instance.r_role[i][12] = "Scout";
                    _restart_vars_instance.r_wep1[i][12] = "Sniper Rifle";
                    _restart_vars_instance.r_wep2[i][12] = "Combat Knife";
                    _restart_vars_instance.r_armour[i][12] = "Scout Armour";
                    _restart_vars_instance.r_mobi[i][12] = "";
                    _restart_vars_instance.r_gear[i][12] = "";

                    _restart_vars_instance.r_race[i][14] = 1;
                    _restart_vars_instance.r_role[i][14] = "Chaplain";
                    _restart_vars_instance.r_wep1[i][14] = "Power Sword";
                    _restart_vars_instance.r_wep2[i][14] = "Bolt Pistol";
                    _restart_vars_instance.r_armour[i][14] = STR_ANY_POWER_ARMOUR;
                    _restart_vars_instance.r_gear[i][14] = "Rosarius";
                    _restart_vars_instance.r_mobi[i][14] = "";

                    _restart_vars_instance.r_race[i][15] = 1;
                    _restart_vars_instance.r_role[i][15] = "Apothecary";
                    _restart_vars_instance.r_wep1[i][15] = "Chainsword";
                    _restart_vars_instance.r_wep2[i][15] = "Bolt Pistol";
                    _restart_vars_instance.r_armour[i][15] = STR_ANY_POWER_ARMOUR;
                    _restart_vars_instance.r_gear[i][15] = "Narthecium";
                    _restart_vars_instance.r_mobi[i][15] = "";

                    _restart_vars_instance.r_race[i][16] = 1;
                    _restart_vars_instance.r_role[i][16] = "Techmarine";
                    _restart_vars_instance.r_wep1[i][16] = "Power Axe";
                    _restart_vars_instance.r_wep2[i][16] = "Storm Bolter";
                    _restart_vars_instance.r_armour[i][16] = "Artificer Armour";
                    _restart_vars_instance.r_gear[i][16] = "";
                    _restart_vars_instance.r_mobi[i][16] = "Servo-arm";

                    _restart_vars_instance.r_race[i][17] = 1;
                    _restart_vars_instance.r_role[i][17] = "Librarian";
                    _restart_vars_instance.r_wep1[i][17] = "Force Staff";
                    _restart_vars_instance.r_wep2[i][17] = "Bolt Pistol";
                    _restart_vars_instance.r_armour[i][17] = STR_ANY_POWER_ARMOUR;
                    _restart_vars_instance.r_gear[i][17] = "Psychic Hood";
                    _restart_vars_instance.r_mobi[i][17] = "";

                    _restart_vars_instance.r_race[i][18] = 1;
                    _restart_vars_instance.r_role[i][18] = "Sergeant";
                    _restart_vars_instance.r_wep1[i][18] = "Chainsword";
                    _restart_vars_instance.r_wep2[i][18] = "Storm Bolter";
                    _restart_vars_instance.r_armour[i][18] = STR_ANY_POWER_ARMOUR;
                    _restart_vars_instance.r_gear[i][18] = "";
                    _restart_vars_instance.r_mobi[i][18] = "";

                    _restart_vars_instance.r_race[i][19] = 1;
                    _restart_vars_instance.r_role[i][19] = "Veteran Sergeant";
                    _restart_vars_instance.r_wep1[i][19] = "Chainsword";
                    _restart_vars_instance.r_wep2[i][19] = "Storm Bolter";
                    _restart_vars_instance.r_armour[i][19] = STR_ANY_POWER_ARMOUR;
                    _restart_vars_instance.r_gear[i][19] = "";
                    _restart_vars_instance.r_mobi[i][19] = "";
                }

                for (var i = 0; i < 21; i++) {
                    _restart_vars_instance.r_race[100][i] = race[100][i];
                    _restart_vars_instance.r_role[100][i] = role[100][i];
                    _restart_vars_instance.r_wep1[100][i] = wep1[100][i];
                    _restart_vars_instance.r_wep2[100][i] = wep2[100][i];
                    _restart_vars_instance.r_armour[100][i] = armour[100][i];
                    _restart_vars_instance.r_gear[100][i] = gear[100][i];
                    _restart_vars_instance.r_mobi[100][i] = mobi[100][i];
                }
            }
        }

        if (saved_game == 2) {
            var _restart_vars_instance = instance_nearest(x, y, obj_restart_vars);
            var _controller_instance = instance_nearest(x, y, obj_controller);
            _controller_instance.restart_name = _restart_vars_instance.restart_name;
            _controller_instance.restart_founding = _restart_vars_instance.restart_founding;

            _controller_instance.restart_secret = _restart_vars_instance.restart_secret;
            _controller_instance.restart_title[0] = "";

            for (var i = 1; i < array_length(_restart_vars_instance.restart_title); i++) {
                _controller_instance.restart_title[i] = _restart_vars_instance.restart_title[i];
            }

            _controller_instance.restart_icon = _restart_vars_instance.restart_icon;
            _controller_instance.restart_powers = _restart_vars_instance.restart_powers;

            for (var ad = 0; ad < 5; ad++) {
                if (ad == 0) {
                    _controller_instance.restart_adv[ad] = "";
                    _controller_instance.restart_dis[ad] = "";
                }
                if (ad > 0) {
                    _controller_instance.restart_adv[ad] = _restart_vars_instance.restart_adv[ad];
                    _controller_instance.restart_dis[ad] = _restart_vars_instance.restart_dis[ad];
                }
            }

            _controller_instance.restart_recruiting_type = _restart_vars_instance.restart_recruiting_type;
            _controller_instance.restart_trial = _restart_vars_instance.restart_trial;
            _controller_instance.restart_recruiting_name = _restart_vars_instance.restart_recruiting_name;
            _controller_instance.restart_home_type = _restart_vars_instance.restart_home_type;
            _controller_instance.restart_home_name = _restart_vars_instance.restart_home_name;
            _controller_instance.restart_fleet_type = _restart_vars_instance.restart_fleet_type;
            _controller_instance.restart_flagship_name = _restart_vars_instance.restart_flagship_name;

            _controller_instance.restart_recruiting_exists = _restart_vars_instance.restart_recruiting_exists;
            _controller_instance.restart_homeworld_exists = _restart_vars_instance.restart_homeworld_exists;
            _controller_instance.restart_homeworld_rule = _restart_vars_instance.restart_homeworld_rule;

            _controller_instance.restart_battle_cry = _restart_vars_instance.restart_battle_cry;

            _controller_instance.restart_main_color = _restart_vars_instance.restart_main_color;
            _controller_instance.restart_secondary_color = _restart_vars_instance.restart_secondary_color;
            _controller_instance.restart_trim_color = _restart_vars_instance.restart_trim_color;
            _controller_instance.restart_pauldron2_color = _restart_vars_instance.restart_pauldron2_color;
            _controller_instance.restart_pauldron_color = _restart_vars_instance.restart_pauldron_color;
            _controller_instance.restart_lens_color = _restart_vars_instance.restart_lens_color;
            _controller_instance.restart_weapon_color = _restart_vars_instance.restart_weapon_color;
            _controller_instance.restart_col_special = _restart_vars_instance.restart_col_special;
            _controller_instance.restart_trim = _restart_vars_instance.restart_trim;
            _controller_instance.restart_skin_color = _restart_vars_instance.restart_skin_color;

            _controller_instance.restart_hapothecary = _restart_vars_instance.restart_hapothecary;
            _controller_instance.restart_hchaplain = _restart_vars_instance.restart_hchaplain;
            _controller_instance.restart_clibrarian = _restart_vars_instance.restart_clibrarian;
            _controller_instance.restart_fmaster = _restart_vars_instance.restart_fmaster;
            _controller_instance.restart_recruiter = _restart_vars_instance.restart_recruiter;
            _controller_instance.restart_admiral = _restart_vars_instance.restart_admiral;

            if (variable_instance_exists(_restart_vars_instance, "restart_squad_distribution")) {
                _controller_instance.restart_squad_distribution = _restart_vars_instance.restart_squad_distribution;
            } else if (variable_instance_exists(_restart_vars_instance, "restart_equal_specialists")) {
                // migrate old saves
                _controller_instance.restart_squad_distribution = _restart_vars_instance.restart_equal_specialists;
            } else {
                _controller_instance.restart_squad_distribution = 0;
            }
            _controller_instance.restart_load_to_ships = _restart_vars_instance.restart_load_to_ships;
            _controller_instance.restart_successors = _restart_vars_instance.restart_successors;

            _controller_instance.restart_mutations = _restart_vars_instance.restart_mutations;
            _controller_instance.restart_preomnor = _restart_vars_instance.restart_preomnor;
            _controller_instance.restart_voice = _restart_vars_instance.restart_voice;
            _controller_instance.restart_doomed = _restart_vars_instance.restart_doomed;
            _controller_instance.restart_lyman = _restart_vars_instance.restart_lyman;
            _controller_instance.restart_omophagea = _restart_vars_instance.restart_omophagea;
            _controller_instance.restart_ossmodula = _restart_vars_instance.restart_ossmodula;
            _controller_instance.restart_membrane = _restart_vars_instance.restart_membrane;
            _controller_instance.restart_zygote = _restart_vars_instance.restart_zygote;
            _controller_instance.restart_betchers = _restart_vars_instance.restart_betchers;
            _controller_instance.restart_catalepsean = _restart_vars_instance.restart_catalepsean;
            _controller_instance.restart_secretions = _restart_vars_instance.restart_secretions;
            _controller_instance.restart_occulobe = _restart_vars_instance.restart_occulobe;
            _controller_instance.restart_mucranoid = _restart_vars_instance.restart_mucranoid;

            _controller_instance.restart_master_name = _restart_vars_instance.restart_master_name;
            _controller_instance.restart_master_melee = _restart_vars_instance.restart_master_melee;
            _controller_instance.restart_master_ranged = _restart_vars_instance.restart_master_ranged;
            _controller_instance.restart_master_specialty = _restart_vars_instance.restart_master_specialty;

            _controller_instance.restart_strength = _restart_vars_instance.restart_strength;
            _controller_instance.restart_cooperation = _restart_vars_instance.restart_cooperation;
            _controller_instance.restart_purity = _restart_vars_instance.restart_purity;
            _controller_instance.restart_stability = _restart_vars_instance.restart_stability;

            // 100 is defaults, 101 is the allowable starting equipment
            for (var i = 100; i < 103; i++) {
                _controller_instance.r_race[i][2] = 1;
                _controller_instance.r_role[i][2] = "Honour Guard";
                _controller_instance.r_wep1[i][2] = "Power Sword";
                _controller_instance.r_wep2[i][2] = "Bolter";
                _controller_instance.r_armour[i][2] = "Artificer Armour";
                _controller_instance.r_mobi[i][2] = "";
                _controller_instance.r_gear[i][2] = "";

                _controller_instance.r_race[i][3] = 1;
                _controller_instance.r_role[i][3] = "Veteran";
                _controller_instance.r_wep1[i][3] = "Chainsword";
                _controller_instance.r_wep2[i][3] = "Bolter";
                _controller_instance.r_armour[i][3] = STR_ANY_POWER_ARMOUR;
                _controller_instance.r_mobi[i][3] = "";
                _controller_instance.r_gear[i][3] = "";

                _controller_instance.r_race[i][4] = 1;
                _controller_instance.r_role[i][4] = "Terminator";
                _controller_instance.r_wep1[i][4] = "Power Fist";
                _controller_instance.r_wep2[i][4] = "Storm Bolter";
                _controller_instance.r_armour[i][4] = "Terminator Armour";
                _controller_instance.r_mobi[i][4] = "";
                _controller_instance.r_gear[i][4] = "";

                _controller_instance.r_race[i][5] = 1;
                _controller_instance.r_role[i][5] = "Captain";
                _controller_instance.r_wep1[i][5] = "Power Sword";
                _controller_instance.r_wep2[i][5] = "Bolt Pistol";
                _controller_instance.r_armour[i][5] = STR_ANY_POWER_ARMOUR;
                _controller_instance.r_mobi[i][5] = "";
                _controller_instance.r_gear[i][5] = "";

                _controller_instance.r_race[i][6] = 1;
                _controller_instance.r_role[i][6] = "Dreadnought";
                _controller_instance.r_wep1[i][6] = "Close Combat Weapon";
                _controller_instance.r_wep2[i][6] = "Twin Linked Lascannon";
                _controller_instance.r_armour[i][6] = "Dreadnought";
                _controller_instance.r_mobi[i][6] = "";
                _controller_instance.r_gear[i][6] = "";

                _controller_instance.r_race[i][7] = 1;
                _controller_instance.r_role[i][7] = "Champion";
                _controller_instance.r_wep1[i][7] = "Power Sword";
                _controller_instance.r_wep2[i][7] = "Bolt Pistol";
                _controller_instance.r_armour[i][7] = STR_ANY_POWER_ARMOUR;
                _controller_instance.r_mobi[i][7] = "";
                _controller_instance.r_gear[i][7] = "Combat Shield";

                _controller_instance.r_race[i][8] = 1;
                _controller_instance.r_role[i][8] = "Tactical Marine";
                _controller_instance.r_wep1[i][8] = "Bolter";
                _controller_instance.r_wep2[i][8] = "Combat Knife";
                _controller_instance.r_armour[i][8] = STR_ANY_POWER_ARMOUR;
                _controller_instance.r_mobi[i][8] = "";
                _controller_instance.r_gear[i][8] = "";

                _controller_instance.r_race[i][9] = 1;
                _controller_instance.r_role[i][9] = "Devastator Marine";
                _controller_instance.r_wep1[i][9] = "";
                _controller_instance.r_wep2[i][9] = "Combat Knife";
                _controller_instance.r_armour[i][9] = STR_ANY_POWER_ARMOUR;
                _controller_instance.r_mobi[i][9] = "";
                _controller_instance.r_gear[i][9] = "";

                _controller_instance.r_race[i][10] = 1;
                _controller_instance.r_role[i][10] = "Assault Marine";
                _controller_instance.r_wep1[i][10] = "Chainsword";
                _controller_instance.r_wep2[i][10] = "Bolt Pistol";
                _controller_instance.r_armour[i][10] = STR_ANY_POWER_ARMOUR;
                _controller_instance.r_mobi[i][10] = "Jump Pack";
                _controller_instance.r_gear[i][10] = "";

                _controller_instance.r_race[i][12] = 1;
                _controller_instance.r_role[i][12] = "Scout";
                _controller_instance.r_wep1[i][12] = "Sniper Rifle";
                _controller_instance.r_wep2[i][12] = "Combat Knife";
                _controller_instance.r_armour[i][12] = "Scout Armour";
                _controller_instance.r_mobi[i][12] = "";
                _controller_instance.r_gear[i][12] = "";

                _controller_instance.r_race[i][14] = 1;
                _controller_instance.r_role[i][14] = "Chaplain";
                _controller_instance.r_wep1[i][14] = "Power Sword";
                _controller_instance.r_wep2[i][14] = "Bolt Pistol";
                _controller_instance.r_armour[i][14] = STR_ANY_POWER_ARMOUR;
                _controller_instance.r_gear[i][14] = "Rosarius";
                _controller_instance.r_mobi[i][14] = "";

                _controller_instance.r_race[i][15] = 1;
                _controller_instance.r_role[i][15] = "Apothecary";
                _controller_instance.r_wep1[i][15] = "Chainsword";
                _controller_instance.r_wep2[i][15] = "Bolt Pistol";
                _controller_instance.r_armour[i][15] = STR_ANY_POWER_ARMOUR;
                _controller_instance.r_gear[i][15] = "Narthecium";
                _controller_instance.r_mobi[i][15] = "";

                _controller_instance.r_race[i][16] = 1;
                _controller_instance.r_role[i][16] = "Techmarine";
                _controller_instance.r_wep1[i][16] = "Power Axe";
                _controller_instance.r_wep2[i][16] = "Storm Bolter";
                _controller_instance.r_armour[i][16] = "Artificer Armour";
                _controller_instance.r_gear[i][16] = "";
                _controller_instance.r_mobi[i][16] = "Servo-arm";

                _controller_instance.r_race[i][17] = 1;
                _controller_instance.r_role[i][17] = "Librarian";
                _controller_instance.r_wep1[i][17] = "Force Staff";
                _controller_instance.r_wep2[i][17] = "Bolt Pistol";
                _controller_instance.r_armour[i][17] = STR_ANY_POWER_ARMOUR;
                _controller_instance.r_gear[i][17] = "Psychic Hood";
                _controller_instance.r_mobi[i][17] = "";

                _controller_instance.r_race[i][18] = 1;
                _controller_instance.r_role[i][18] = "Sergeant";
                _controller_instance.r_wep1[i][18] = "Chainsword";
                _controller_instance.r_wep2[i][18] = "Storm Bolter";
                _controller_instance.r_armour[i][18] = STR_ANY_POWER_ARMOUR;
                _controller_instance.r_gear[i][18] = "";
                _controller_instance.r_mobi[i][18] = "";

                _controller_instance.r_race[i][19] = 1;
                _controller_instance.r_role[i][19] = "Veteran Sergeant";
                _controller_instance.r_wep1[i][19] = "Chainsword";
                _controller_instance.r_wep2[i][19] = "Storm Bolter";
                _controller_instance.r_armour[i][19] = STR_ANY_POWER_ARMOUR;
                _controller_instance.r_gear[i][19] = "";
                _controller_instance.r_mobi[i][19] = "";
            }

            for (var i = 0; i < 21; i++) {
                _controller_instance.r_race[100][i] = _restart_vars_instance.r_race[100][i];
                _controller_instance.r_race[101][i] = _restart_vars_instance.r_race[100][i];
                _controller_instance.r_race[102][i] = _restart_vars_instance.r_race[100][i];

                _controller_instance.r_role[100][i] = _restart_vars_instance.r_role[100][i];
                _controller_instance.r_wep1[100][i] = _restart_vars_instance.r_wep1[100][i];
                _controller_instance.r_wep2[100][i] = _restart_vars_instance.r_wep2[100][i];
                _controller_instance.r_armour[100][i] = _restart_vars_instance.r_armour[100][i];
                _controller_instance.r_gear[100][i] = _restart_vars_instance.r_gear[100][i];
                _controller_instance.r_mobi[100][i] = _restart_vars_instance.r_mobi[100][i];
            }
        }

        // Controller to restart vars
        if (saved_game == 3) {
            var _restart_vars_instance = instance_nearest(x, y, obj_restart_vars);
            var _controller_instance = instance_nearest(x, y, obj_controller);
            _restart_vars_instance.restart_name = _controller_instance.restart_name;
            _restart_vars_instance.restart_founding = _controller_instance.restart_founding;

            _restart_vars_instance.restart_secret = _controller_instance.restart_secret;
            _restart_vars_instance.restart_title[0] = _controller_instance.restart_title[0];

            for (var i = 1; i < array_length(_restart_vars_instance.restart_title); i++) {
                _restart_vars_instance.restart_title[i] = _controller_instance.restart_title[i];
            }

            _restart_vars_instance.restart_icon = _controller_instance.restart_icon;
            _restart_vars_instance.restart_powers = _controller_instance.restart_powers;

            for (var ad = 0; ad < 5; ad++) {
                if (ad == 0) {
                    _restart_vars_instance.restart_adv[ad] = "";
                    _restart_vars_instance.restart_dis[ad] = "";
                }
                if (ad > 0) {
                    _restart_vars_instance.restart_adv[ad] = _controller_instance.restart_adv[ad];
                    _restart_vars_instance.restart_dis[ad] = _controller_instance.restart_dis[ad];
                }
            }

            _restart_vars_instance.restart_recruiting_type = _controller_instance.restart_recruiting_type;
            _restart_vars_instance.restart_trial = _controller_instance.restart_trial;
            _restart_vars_instance.restart_recruiting_name = _controller_instance.restart_recruiting_name;
            _restart_vars_instance.restart_home_type = _controller_instance.restart_home_type; // Good here
            _restart_vars_instance.restart_home_name = _controller_instance.restart_home_name;
            _restart_vars_instance.restart_fleet_type = _controller_instance.restart_fleet_type;
            _restart_vars_instance.restart_flagship_name = _controller_instance.restart_flagship_name;

            _restart_vars_instance.restart_recruiting_exists = _controller_instance.restart_recruiting_exists;
            _restart_vars_instance.restart_homeworld_exists = _controller_instance.restart_homeworld_exists;
            _restart_vars_instance.restart_homeworld_rule = _controller_instance.restart_homeworld_rule;

            _restart_vars_instance.restart_battle_cry = _controller_instance.restart_battle_cry;

            _restart_vars_instance.restart_main_color = _controller_instance.restart_main_color;
            _restart_vars_instance.restart_secondary_color = _controller_instance.restart_secondary_color;
            _restart_vars_instance.restart_trim_color = _controller_instance.restart_trim_color;
            _restart_vars_instance.restart_pauldron2_color = _controller_instance.restart_pauldron2_color;
            _restart_vars_instance.restart_pauldron_color = _controller_instance.restart_pauldron_color;
            _restart_vars_instance.restart_lens_color = _controller_instance.restart_lens_color;
            _restart_vars_instance.restart_weapon_color = _controller_instance.restart_weapon_color;
            _restart_vars_instance.restart_col_special = _controller_instance.restart_col_special;
            _restart_vars_instance.restart_trim = _controller_instance.restart_trim;
            _restart_vars_instance.restart_skin_color = _controller_instance.restart_skin_color;

            _restart_vars_instance.restart_hapothecary = _controller_instance.restart_hapothecary;
            _restart_vars_instance.restart_hchaplain = _controller_instance.restart_hchaplain;
            _restart_vars_instance.restart_clibrarian = _controller_instance.restart_clibrarian;
            _restart_vars_instance.restart_fmaster = _controller_instance.restart_fmaster;
            _restart_vars_instance.restart_recruiter = _controller_instance.restart_recruiter;
            _restart_vars_instance.restart_admiral = _controller_instance.restart_admiral;

            _restart_vars_instance.restart_squad_distribution = _controller_instance.restart_squad_distribution;
            _restart_vars_instance.restart_load_to_ships = _controller_instance.restart_load_to_ships;
            _restart_vars_instance.restart_successors = _controller_instance.restart_successors;

            _restart_vars_instance.restart_mutations = _controller_instance.restart_mutations;
            _restart_vars_instance.restart_preomnor = _controller_instance.restart_preomnor;
            _restart_vars_instance.restart_voice = _controller_instance.restart_voice;
            _restart_vars_instance.restart_doomed = _controller_instance.restart_doomed;
            _restart_vars_instance.restart_lyman = _controller_instance.restart_lyman;
            _restart_vars_instance.restart_omophagea = _controller_instance.restart_omophagea;
            _restart_vars_instance.restart_ossmodula = _controller_instance.restart_ossmodula;
            _restart_vars_instance.restart_membrane = _controller_instance.restart_membrane;
            _restart_vars_instance.restart_zygote = _controller_instance.restart_zygote;
            _restart_vars_instance.restart_betchers = _controller_instance.restart_betchers;
            _restart_vars_instance.restart_catalepsean = _controller_instance.restart_catalepsean;
            _restart_vars_instance.restart_secretions = _controller_instance.restart_secretions;
            _restart_vars_instance.restart_occulobe = _controller_instance.restart_occulobe;
            _restart_vars_instance.restart_mucranoid = _controller_instance.restart_mucranoid;

            _restart_vars_instance.restart_master_name = _controller_instance.restart_master_name;
            _restart_vars_instance.restart_master_melee = _controller_instance.restart_master_melee;
            _restart_vars_instance.restart_master_ranged = _controller_instance.restart_master_ranged;
            _restart_vars_instance.restart_master_specialty = _controller_instance.restart_master_specialty;

            _restart_vars_instance.restart_strength = _controller_instance.restart_strength;
            _restart_vars_instance.restart_cooperation = _controller_instance.restart_cooperation;
            _restart_vars_instance.restart_purity = _controller_instance.restart_purity;
            _restart_vars_instance.restart_stability = _controller_instance.restart_stability;

            for (var i = 0; i < 21; i++) {
                _restart_vars_instance.r_race[100][i] = _controller_instance.r_race[100][i];
                _restart_vars_instance.r_race[101][i] = _controller_instance.r_race[100][i];
                _restart_vars_instance.r_race[102][i] = _controller_instance.r_race[100][i];

                _restart_vars_instance.r_role[100][i] = _controller_instance.r_role[100][i];
                _restart_vars_instance.r_wep1[100][i] = _controller_instance.r_wep1[100][i];
                _restart_vars_instance.r_wep2[100][i] = _controller_instance.r_wep2[100][i];
                _restart_vars_instance.r_armour[100][i] = _controller_instance.r_armour[100][i];
                _restart_vars_instance.r_gear[100][i] = _controller_instance.r_gear[100][i];
                _restart_vars_instance.r_mobi[100][i] = _controller_instance.r_mobi[100][i];
            }
        }
    } catch (_exception) {
        ERROR_HANDLER.handle_exception(_exception);
    }
}

/// @self Asset.GMObject.obj_creation
function reset_creation_variables() {
    world = array_create(21, "");
    world_type = array_create(21, "");
    world_feature = array_create(21, "");

    points = 100;
    maxpoints = 100;
    custom = eCHAPTER_TYPE.PREMADE;

    hapothecary = global.name_generator.GenerateFromSet("space_marine");
    hchaplain = global.name_generator.GenerateFromSet("space_marine");
    clibrarian = global.name_generator.GenerateFromSet("space_marine");
    fmaster = global.name_generator.GenerateFromSet("space_marine");
    recruiter = global.name_generator.GenerateFromSet("space_marine");
    admiral = global.name_generator.GenerateFromSet("space_marine");

    // First is for the correct slot, second is for default info
    for (var i = 100; i < 103; i++) {
        race[i][2] = 1;
        role[i][2] = "Honour Guard";
        wep1[i][2] = "Power Sword";
        wep2[i][2] = "Bolter";
        armour[i][2] = "Artificer Armour";

        race[i][3] = 1;
        role[i][3] = "Veteran";
        wep1[i][3] = "Chainsword";
        wep2[i][3] = "Bolter";
        armour[i][3] = STR_ANY_POWER_ARMOUR;

        race[i][4] = 1;
        role[i][4] = "Terminator";
        wep1[i][4] = "Power Fist";
        wep2[i][4] = "Storm Bolter";
        armour[i][4] = "Terminator Armour";

        race[i][5] = 1;
        role[i][5] = "Captain";
        wep1[i][5] = "Power Sword";
        wep2[i][5] = "Bolt Pistol";
        armour[i][5] = STR_ANY_POWER_ARMOUR;
        gear[i][5] = "Iron Halo";

        race[i][6] = 1;
        role[i][6] = "Dreadnought";
        wep1[i][6] = "Close Combat Weapon";
        wep2[i][6] = "Twin Linked Lascannon";
        armour[i][6] = "Dreadnought";

        race[i][8] = 1;
        role[i][8] = "Tactical Marine";
        wep1[i][8] = "Bolter";
        wep2[i][8] = "Combat Knife";
        armour[i][8] = STR_ANY_POWER_ARMOUR;

        race[i][9] = 1;
        role[i][9] = "Devastator Marine";
        wep1[i][9] = "";
        wep2[i][9] = "Combat Knife";
        armour[i][9] = STR_ANY_POWER_ARMOUR;

        race[i][10] = 1;
        role[i][10] = "Assault Marine";
        wep1[i][10] = "Chainsword";
        wep2[i][10] = "Bolt Pistol";
        armour[i][10] = STR_ANY_POWER_ARMOUR;
        mobi[i][10] = "Jump Pack";

        race[i][11] = 1;
        role[i][11] = "Ancient";
        wep1[i][11] = "Company Standard";
        wep2[i][11] = "Power Sword";
        armour[i][11] = STR_ANY_POWER_ARMOUR;

        race[i][12] = 1;
        role[i][12] = "Scout";
        wep1[i][12] = "Sniper Rifle";
        wep2[i][12] = "Combat Knife";
        armour[i][12] = "Scout Armour";

        race[i][14] = 1;
        role[i][14] = "Chaplain";
        wep1[i][14] = "Power Sword";
        wep2[i][14] = "Bolt Pistol";
        armour[i][14] = STR_ANY_POWER_ARMOUR;
        gear[i][14] = "Rosarius";

        race[i][15] = 1;
        role[i][15] = "Apothecary";
        wep1[i][15] = "Chainsword";
        wep2[i][15] = "Bolt Pistol";
        armour[i][15] = STR_ANY_POWER_ARMOUR;
        gear[i][15] = "Narthecium";

        race[i][16] = 1;
        role[i][16] = "Techmarine";
        wep1[i][16] = "Power Axe";
        wep2[i][16] = "Storm Bolter";
        armour[i][16] = "Artificer Armour";
        gear[i][16] = "";
        mobi[i][16] = "Servo-arm";

        race[i][17] = 1;
        role[i][17] = "Librarian";
        wep1[i][17] = "Force Staff";
        wep2[i][17] = "Bolt Pistol";
        armour[i][17] = STR_ANY_POWER_ARMOUR;
        gear[i][17] = "Psychic Hood";

        race[i][18] = 1;
        role[i][18] = "Sergeant";
        wep1[i][18] = "Chainsword";
        wep2[i][18] = "Storm Bolter";
        armour[i][18] = STR_ANY_POWER_ARMOUR;
        gear[i][18] = "";

        race[i][19] = 1;
        role[i][19] = "Veteran Sergeant";
        wep1[i][19] = "Chainsword";
        wep2[i][19] = "Storm Bolter";
        armour[i][19] = STR_ANY_POWER_ARMOUR;
        gear[i][19] = "";
    }

    points = 100;
    selected_chapter = 999;

    var _restart_vars_instance = instance_nearest(x, y, obj_restart_vars);

    chapter = _restart_vars_instance.restart_name;
    founding = _restart_vars_instance.restart_founding;
    founding_secret = _restart_vars_instance.restart_secret;

    company_title[0] = "";

    for (var i = 1; i <= 11; i++) {
        company_title[i] = _restart_vars_instance.restart_title[i];
    }

    global.chapter_icon.name = _restart_vars_instance.restart_icon;
    discipline = _restart_vars_instance.restart_powers;

    // Need disposition here

    recruiting = _restart_vars_instance.restart_recruiting_type;
    aspirant_trial = _restart_vars_instance.restart_trial;
    recruiting_name = _restart_vars_instance.restart_recruiting_name;
    homeworld = _restart_vars_instance.restart_home_type;
    homeworld_name = _restart_vars_instance.restart_home_name;
    fleet_type = _restart_vars_instance.restart_fleet_type;
    flagship_name = _restart_vars_instance.restart_flagship_name;

    recruiting_exists = _restart_vars_instance.restart_recruiting_exists;
    homeworld_exists = _restart_vars_instance.restart_homeworld_exists;
    homeworld_rule = _restart_vars_instance.restart_homeworld_rule;

    battle_cry = _restart_vars_instance.restart_battle_cry;

    main_color = _restart_vars_instance.restart_main_color;
    secondary_color = _restart_vars_instance.restart_secondary_color;
    main_trim = _restart_vars_instance.restart_trim_color;
    left_pauldron = _restart_vars_instance.restart_pauldron2_color;
    right_pauldron = _restart_vars_instance.restart_pauldron_color;
    lens_color = _restart_vars_instance.restart_lens_color;
    weapon_color = _restart_vars_instance.restart_weapon_color;
    col_special = _restart_vars_instance.restart_col_special;
    trim = _restart_vars_instance.restart_trim;
    skin_color = _restart_vars_instance.restart_skin_color;

    hapothecary = _restart_vars_instance.restart_hapothecary;
    hchaplain = _restart_vars_instance.restart_hchaplain;
    clibrarian = _restart_vars_instance.restart_clibrarian;
    fmaster = _restart_vars_instance.restart_fmaster;
    recruiter = _restart_vars_instance.restart_recruiter;
    admiral = _restart_vars_instance.restart_admiral;

    if (variable_instance_exists(_restart_vars_instance, "restart_squad_distribution")) {
        squad_distribution = _restart_vars_instance.restart_squad_distribution;
    } else if (variable_instance_exists(_restart_vars_instance, "restart_equal_specialists")) {
        // migrate old saves
        squad_distribution = _restart_vars_instance.restart_equal_specialists;
    } else {
        squad_distribution = 0;
    }
    load_to_ships = _restart_vars_instance.restart_load_to_ships;
    successors = _restart_vars_instance.restart_successors;

    mutations = _restart_vars_instance.restart_mutations;
    preomnor = _restart_vars_instance.restart_preomnor;
    voice = _restart_vars_instance.restart_voice;
    doomed = _restart_vars_instance.restart_doomed;
    lyman = _restart_vars_instance.restart_lyman;
    omophagea = _restart_vars_instance.restart_omophagea;
    ossmodula = _restart_vars_instance.restart_ossmodula;
    membrane = _restart_vars_instance.restart_membrane;
    zygote = _restart_vars_instance.restart_zygote;
    betchers = _restart_vars_instance.restart_betchers;
    catalepsean = _restart_vars_instance.restart_catalepsean;
    secretions = _restart_vars_instance.restart_secretions;
    occulobe = _restart_vars_instance.restart_occulobe;
    mucranoid = _restart_vars_instance.restart_mucranoid;

    chapter_master_name = _restart_vars_instance.restart_master_name;
    chapter_master_melee = _restart_vars_instance.restart_master_melee;
    chapter_master_ranged = _restart_vars_instance.restart_master_ranged;
    chapter_master_specialty = _restart_vars_instance.restart_master_specialty;

    strength = _restart_vars_instance.restart_strength;
    cooperation = _restart_vars_instance.restart_cooperation;
    purity = _restart_vars_instance.restart_purity;
    stability = _restart_vars_instance.restart_stability;

    for (var i = 0; i < 21; i++) {
        race[100][i] = _restart_vars_instance.r_race[100][i];

        role[100][i] = _restart_vars_instance.r_role[100][i];
        wep1[100][i] = _restart_vars_instance.r_wep1[100][i];
        wep2[100][i] = _restart_vars_instance.r_wep2[100][i];
        armour[100][i] = _restart_vars_instance.r_armour[100][i];
        gear[100][i] = _restart_vars_instance.r_gear[100][i];
        mobi[100][i] = _restart_vars_instance.r_mobi[100][i];
    }

    custom = eCHAPTER_TYPE.RANDOM;
    restarted = 1;
    mutations_selected = mutations;
}
