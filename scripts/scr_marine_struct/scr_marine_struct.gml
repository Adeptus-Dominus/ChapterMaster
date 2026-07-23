global.unit_body_parts = [
    "left_leg",
    "right_leg",
    "torso",
    "right_arm",
    "left_arm",
    "left_eye",
    "right_eye",
    "throat",
    "jaw",
    "head",
];
global.unit_body_parts_display = [
    "Left Leg",
    "Right Leg",
    "Torso",
    "Right Arm",
    "Left Arm",
    "Left Eye",
    "Right Eye",
    "Throat",
    "Jaw",
    "Head",
];

global.religions = {
    "imperial_cult": {
        "name": "Imperial Cult",
    },
    "cult_mechanicus": {
        "name": "Cult Mechanicus",
    },
    "eight_fold_path": {
        "name": "The Eight Fold Path",
    },
};

enum eLOCATION_TYPES {
    PLANET,
    SHIP,
    SPACE_HULK,
    ANCIENT_RUINS,
    WARP,
}

global.arr_psy_levels = [
    "Rho",
    "Pi",
    "Omicron",
    "Xi",
    "Nu",
    "Mu",
    "Lambda",
    "Kappa",
    "Iota",
    "Theta",
    "Eta",
    "Zeta",
    "Epsilon",
    "Delta",
    "Gamma",
    "Beta",
    "Alpha",
    "Alpha Plus",
    "Beta Plus",
    "Gamma Plus",
];
global.arr_negative_psy_levels = [
    "Rho",
    "Sigma",
    "Tau",
    "Upsilon",
    "Phi",
    "Chi",
    "Psi",
    "Omega",
];

enum eEQUIPMENT_SLOT {
    WEAPON_ONE,
    WEAPON_TWO,
    ARMOUR,
    GEAR,
    MOBILITY,
    ALL,
}

enum eROLE_TAG {
    Techmarine = 0,
    Librarian = 1,
    Chaplain = 2,
    Apothecary = 3,
}

function TTRPG_stats(faction, comp, mar, class = "marine", other_spawn_data = {}) constructor {
    // Metadata
    uid = scr_uuid_generate();
    company = comp; //marine company
    marine_number = mar; //marine number in company
    squad = "none";
    base_group = "none";
    job = "none";
    manage_tags = [];
    spawn_data = other_spawn_data;

    // Core RPG Stats
    constitution = 0;
    strength = 0;
    luck = 0;
    dexterity = 0;
    wisdom = 0;
    piety = 0;
    charisma = 0;
    technology = 0;
    intelligence = 0;
    weapon_skill = 0;
    ballistic_skill = 0;

    // Location Data
    planet_location = 0;
    location_string = "";
    ship_location = -1;
    last_ship = {
        uid: "",
        name: "",
    };

    // Lore
    allegiance = faction; //faction alligience defaults to the chapter
    loyalty = 0;
    epithets = [];
    role_history = [];
    role_tag = [
        0,
        0,
        0,
        0,
    ]; // [Techmarine, Librarian, Chaplain, Apothecary] maybe add to list instead?

    // Psy and religion
    religion = "none";
    religion_sub_cult = "none";
    corruption = 0;
    psionic = 0;
    powers_known = [];

    // Health
    body = generate_marine_body();
    unit_health = 0;
    bionics = 0;
    size = 0;

    // Progression
    experience = 0;
    stat_point_exp_marker = 0;
    turn_stat_gains = {};
    traits = []; //marine trait list
    feats = [];

    // Customization
    personal_livery = {};

    // Equipment
    gear_quality = "standard";
    armour_quality = "standard";
    mobility_item_quality = "standard";
    weapon_one_quality = "standard";
    weapon_two_quality = "standard";
    weapon_one_data = {
        quality: "standard",
    };

    // Combat States
    encumbered_ranged = false;
    encumbered_melee = false;
    is_boarder = false;

    if (!instance_exists(obj_controller) && class != "blank") {
        //game start unit planet location
        planet_location = obj_ini.home_planet;
    }

    if (faction == "chapter" && !struct_exists(spawn_data, "recruit_data")) {
        spawn_data.recruit_data = {
            recruit_world: obj_ini.recruiting_type,
            aspirant_trial: obj_ini.recruit_trial,
        };
    }

    //takes dict and plumbs dict values into unit struct
    if (array_contains(variable_struct_get_names(global.base_stats), class)) {
        load_json_data(global.base_stats[$ class]);
    }

    var stats = [
        "constitution",
        "strength",
        "luck",
        "dexterity",
        "wisdom",
        "piety",
        "charisma",
        "technology",
        "intelligence",
        "weapon_skill",
        "ballistic_skill",
    ];

    for (var stat_iter = 0; stat_iter < array_length(stats); stat_iter++) {
        if (struct_exists(self, stats[stat_iter])) {
            if (is_array(variable_struct_get(self, stats[stat_iter]))) {
                var edit_stat = variable_struct_get(self, stats[stat_iter]);
                var stat_mod = floor(gauss(edit_stat[0], edit_stat[1]));
                if (array_length(edit_stat) > 2) {
                    if (edit_stat[2] == "max") {
                        variable_struct_set(self, stats[stat_iter], max(stat_mod, edit_stat[0]));
                    } else if (edit_stat[2] == "min") {
                        variable_struct_set(self, stats[stat_iter], min(stat_mod, edit_stat[0]));
                    } else {
                        variable_struct_set(self, stats[stat_iter], stat_mod);
                    }
                } else {
                    variable_struct_set(self, stats[stat_iter], stat_mod);
                }
            }
        }
    }

    if (struct_exists(self, "start_gear")) {
        if (base_group != "marine") {
            alter_equipment(start_gear, false, false);
        } else {
            alter_equipment(start_gear, true, true);
        }
    }

    /*ey so i got this concept where basically take away luck, ballistic_skill and weapon_skill
    there are 8 other stats each of which will have more attached aspects and game play elements
    they effect as time goes on, so that means between the 8 other stats if you had a choice of two
    there are 64 (or 56 if you exclude double counts) variations of a choice of two, this means each
    chapter could have two "values" maybe in terms of recruitment maybe in terms of just general chapter stuff.
    that could be chosen to give boostes to the other stats
    so as an example salamanders could have the chapter values as  */

    switch (base_group) {
        case "astartes": //basic marine class //adds specific mechanics not releveant to most units
            loyalty = 100;

            var _astartes_trait_dist = global.astartes_trait_dist;
            distribute_traits(_astartes_trait_dist);

            if (instance_exists(obj_controller)) {
                role_history = [
                    [
                        obj_ini.role[company][marine_number],
                        obj_controller.turn,
                    ],
                ]; //marines_promotion and demotion history
                marine_ascension = (obj_controller.millenium * 1000) + obj_controller.year; // on what day did this marine begin to exist
            } else {
                role_history = [];
                marine_ascension = 0; // on what turn did this marine begin to exist
            }

            roll_psionics();

            alter_body("torso", "black_carapace", true);
            if (class == "scout" && global.chapter_name != "Space Wolves") {
                alter_body("torso", "black_carapace", false);
            }
            if (faction == "chapter") {
                allegiance = global.chapter_name;
            }

            static assign_inherent_mutations = function() {
                gene_seed_mutations = {
                    "preomnor": obj_ini.preomnor,
                    "lyman": obj_ini.lyman,
                    "omophagea": obj_ini.omophagea,
                    "ossmodula": obj_ini.ossmodula,
                    "zygote": obj_ini.zygote,
                    "betchers": obj_ini.betchers,
                    "catalepsean": obj_ini.catalepsean,
                    "occulobe": obj_ini.occulobe,
                    "mucranoid": obj_ini.mucranoid,
                    "membrane": obj_ini.membrane,
                    "voice": obj_ini.voice,
                };
            };

            static assign_random_mutations = function() {
                var _mutation_roll = roll_dice_unit(self, 1, 100, "high");
                var _mutation_threshold = 100 - obj_ini.stability;
                if (_mutation_roll <= _mutation_threshold) {
                    var _mutation_names = struct_get_names(gene_seed_mutations);
                    var _possible_mutations = [];
                    for (var i = 0; i < array_length(_mutation_names); i++) {
                        var _mutation = _mutation_names[i];
                        if (gene_seed_mutations[$ _mutation] == 0) {
                            array_push(_possible_mutations, _mutation);
                        }
                    }

                    var _mutations_assigned = 0;
                    repeat (array_length(_possible_mutations)) {
                        if (array_length(_possible_mutations) > 0) {
                            var _picked_mutation = array_random_index(_possible_mutations);
                            gene_seed_mutations[$ _possible_mutations[_picked_mutation]] = 1;
                            array_delete(_possible_mutations, _picked_mutation, 1);
                            _mutations_assigned++;
                            _mutation_threshold = max(_mutation_threshold - 5 * _mutations_assigned, 0);
                            if (_mutation_roll <= _mutation_threshold) {
                                continue;
                            } else {
                                break;
                            }
                        } else {
                            break;
                        }
                    }
                }
            };

            assign_inherent_mutations();
            assign_random_mutations();

            if (gene_seed_mutations[$ "voice"] == 1) {
                charisma -= 2;
            }

            if ((global.chapter_name == "Space Wolves") || (obj_ini.progenitor == ePROGENITOR.SPACE_WOLVES)) {
                religion_sub_cult = "The Allfather";
            } else if ((global.chapter_name == "Salamanders") || (obj_ini.progenitor == ePROGENITOR.SALAMANDERS)) {
                religion_sub_cult = "The Promethean Cult";
            } else if (global.chapter_name == "Iron Hands" || obj_ini.progenitor == ePROGENITOR.IRON_HANDS) {
                religion_sub_cult = "The Cult of Iron";
            }

            if (global.chapter_name == "Deathwatch") {
                personal_livery.right_pauldron = irandom(30);
            }

            var _robe_chance = 5;
            if (global.chapter_name == "Black Templars") {
                _robe_chance += 70;
            } else if (scr_has_style("Knightly")) {
                _robe_chance += 50;
            }
            if (irandom(100) <= _robe_chance) {
                body.torso.robes = irandom(2);
                if (body[$ "torso"].robes == 0 && irandom(1) == 0) {
                    body[$ "head"].hood = 1;
                }
            }

            var _cloak_chance = 5;
            if (role() == obj_ini.role[100][eROLE.CHAPLAIN]) {
                _cloak_chance += 25;
            } else if (IsSpecialist(SPECIALISTS_LIBRARIANS)) {
                _cloak_chance += 75;
            }
            if (irandom(100) <= _cloak_chance) {
                if (global.chapter_name == "Salamanders") {
                    body.cloak.type = "scale";
                } else if (global.chapter_name == "Space Wolves") {
                    body.cloak.type = "pelt";
                } else {
                    body.cloak.type = "cloth";
                    body.cloak.variation = irandom(100);
                    body.cloak.image_0 = irandom(100);
                    body.cloak.image_1 = irandom(100);
                }
            }
            break;
        case "tech_priest":
            loyalty = obj_controller.disposition[eFACTION.MECHANICUS] - 10;
            religion = "cult_mechanicus";
            bionics = irandom(5) + 4;
            add_trait("flesh_is_weak");
            psionic = irandom(4);
            break;
    }

    if (base_group != "none") {
        update_health(max_health()); //set marine unit_health to max
    }

    static set_exp = function(new_val) {
        experience = new_val;
        var _powers_learned = 0;

        if (IsSpecialist(SPECIALISTS_LIBRARIANS)) {
            _powers_learned = update_powers();
        }

        // 0 is returned to have the same return format as in add_exp, to avoid confusion;
        return [
            0,
            _powers_learned,
        ];
    }; //change exp

    static handle_stat_growth = unit_stat_growth;

    static armour = function(raw = false) {
        var wep = obj_ini.armour[company][marine_number];
        if (is_string(wep) || raw) {
            return wep;
        }
        return obj_ini.artifact[wep];
    };

    static role = function() {
        return obj_ini.role[company][marine_number];
    };

    static squad_role = function() {
        var temp_role = role();
        if (squad != "none") {
            var _squad = fetch_squad(squad);
            if (struct_exists(obj_ini.squad_types[$ _squad.type], temp_role)) {
                var role_info = obj_ini.squad_types[$ _squad.type][$ temp_role];
                if (struct_exists(role_info, "role")) {
                    temp_role = role_info[$ "role"];
                }
            }
        }
        return string(temp_role);
    };

    static IsSpecialist = function(search_type = "standard", include_trainee = false, include_heads = true) {
        return is_specialist(role(), search_type, include_trainee, include_heads);
    };

    static update_role = function(new_role) {
        if (role() == new_role) {
            return "no change";
        }
        if (base_group == "astartes") {
            if (role() == obj_ini.role[100][12] && new_role != obj_ini.role[100][12]) {
                if (!get_body_data("black_carapace", "torso")) {
                    alter_body("torso", "black_carapace", true);
                    stat_boosts({strength: 4, constitution: 4, dexterity: 4}); //will decide on if these are needed
                }
            }
            if (!is_specialist(role())) {
                //logs changes too and from specialist status
                if (is_specialist(new_role)) {
                    obj_controller.marines -= 1;
                    obj_controller.command += 1;
                }
            } else {
                if (!is_specialist(new_role)) {
                    obj_controller.marines += 1;
                    obj_controller.command -= 1;
                }
            }
        }
        obj_ini.role[company][marine_number] = new_role;
        if (instance_exists(obj_controller)) {
            array_push(role_history, [role(), obj_controller.turn]);
        }
        if (new_role == obj_ini.role[100][5]) {
            if (company == 2) {
                obj_ini.watch_master_name = name();
            }
            if (company == 3) {
                obj_ini.arsenal_master_name = name();
            }
            if (company == 4) {
                obj_ini.lord_admiral_name = name();
            }
            if (company == 5) {
                obj_ini.march_master_name = name();
            }
            if (company == 6) {
                obj_ini.rites_master_name = name();
            }
            if (company == 7) {
                obj_ini.chief_victualler_name = name();
            }
            if (company == 8) {
                obj_ini.lord_executioner_name = name();
            }
            if (company == 9) {
                obj_ini.relic_master_name = name();
            }
            if (company == 10) {
                obj_ini.recruiter_name = name();
            }
            scr_recent("captain_promote", name(), company);
        } else if (new_role == obj_ini.role[100][4]) {
            scr_recent("terminator_promote", name(), company);
        } else if (new_role == obj_ini.role[100][2]) {
            scr_recent("honor_promote", name(), company);
        } else if (new_role == obj_ini.role[100][6]) {
            var dread_weapons = [
                "Close Combat Weapon",
                "Force Staff",
                "Twin Linked Lascannon",
                "Assault Cannon",
                "Missile Launcher",
                "Plasma Cannon",
                "Multi-Melta",
                "Twin Linked Heavy Bolter",
            ];

            if (!array_contains(dread_weapons, weapon_one())) {
                update_weapon_one("");
            }
            if (!array_contains(dread_weapons, weapon_two())) {
                update_weapon_two("");
            }
        }
    };

    static mobility_item = function(raw = false) {
        var wep = obj_ini.mobi[company][marine_number];
        if (is_string(wep) || raw) {
            return wep;
        }
        return obj_ini.artifact[wep];
    };

    static hp = function() {
        return unit_health; //return current unit_health
    };

    static add_or_sub_health = function(health_augment) {
        unit_health += health_augment;
        unit_health = min(unit_health, max_health());
    };

    static healing = function(apoth) {
        if (hp() <= 0) {
            exit;
        }
        var health_portion = 20;
        var m_health = max_health();
        var new_health;
        if (apoth) {
            if (base_group == "astartes") {
                if (gene_seed_mutations[$ "ossmodula"]) {
                    health_portion = 6;
                } else {
                    health_portion = 4;
                }
            } else {
                health_portion = 10;
            }
        } else {
            if (base_group == "astartes") {
                health_portion = 8;
                if (gene_seed_mutations[$ "ossmodula"]) {
                    health_portion = 10;
                }
            }
        }
        new_health = hp() + (m_health / health_portion);
        if (new_health > m_health) {
            new_health = m_health;
        }
        update_health(new_health);
    };

    static update_health = function(new_health) {
        unit_health = min(new_health, max_health());
    };

    static hp_portion = function() {
        return hp() / max_health();
    };

    static get_unit_size = function() {
        var unit_role = role();
        var arm = armour();
        var sz = 1;
        if (string_count("Dread", arm) > 0) {
            sz += 5;
        } else if (array_contains(global.list_terminator_armour, arm)) {
            sz += 1;
        }
        if (unit_role == obj_ini.role[100][eROLE.CHAPTERMASTER]) {
            sz++;
        }
        size = sz;
        return size;
    };

    //Unit update equip slot functions held in sscr_unit_equip_functions
    static update_armour = scr_update_unit_armour;
    static update_weapon_one = scr_update_unit_weapon_one;
    static update_weapon_two = scr_update_unit_weapon_two;
    static update_gear = scr_update_unit_gear;
    static update_mobility_item = scr_update_unit_mobility_item;

    static max_health = function(base = false) {
        var _max_h = max(1, constitution * 3);

        if (!base) {
            var _gear_mod = 100;
            _gear_mod += get_armour_data("hp_mod");
            _gear_mod += get_gear_data("hp_mod");
            _gear_mod += get_mobility_data("hp_mod");
            _gear_mod += get_weapon_one_data("hp_mod");
            _gear_mod += get_weapon_two_data("hp_mod");
            _gear_mod /= 100;
            _max_h *= _gear_mod;
        }

        return round(_max_h);
    };

    // used both to load unit data from save and to add preset base_stats
    static load_json_data = function(data) {
        //this also allows us to create a pre set of anysort for a marine
        try {
            var names = variable_struct_get_names(data);
            for (var i = 0; i < array_length(names); i++) {
                variable_struct_set(self, names[i], variable_struct_get(data, names[i]));
            }
        } catch (_exception) {
            ERROR_HANDLER.handle_exception(_exception);
        }
    };

    static stat_boosts = function(stat_boosters) {
        var stats = global.stat_list;
        var edits = struct_get_names(stat_boosters);
        var edit_stat, random_stat, stat_mod;
        for (var stat_iter = 0; stat_iter < array_length(stats); stat_iter++) {
            if (array_contains(edits, stats[stat_iter])) {
                edit_stat = variable_struct_get(stat_boosters, stats[stat_iter]);
                if (is_array(edit_stat)) {
                    stat_mod = floor(gauss(edit_stat[0], edit_stat[1]));
                    if (array_length(edit_stat) > 2) {
                        if (edit_stat[2] == "max") {
                            stat_mod = max(stat_mod, edit_stat[0]);
                        } else if (edit_stat[2] == "min") {
                            stat_mod = min(stat_mod, edit_stat[0]);
                        }
                    }
                } else {
                    stat_mod = edit_stat;
                }
                if (stats[stat_iter] == "constitution") {
                    balance_value = hp() / max_health();
                }
                variable_struct_set(self, stats[stat_iter], (variable_struct_get(self, stats[stat_iter]) + stat_mod));
                if (stats[stat_iter] == "constitution") {
                    update_health(max_health() * balance_value);
                }
            }
        }
    };

    //adds a trait to a marines trait list
    static add_trait = function(trait, return_stat_diff = false, return_description = false) {
        var _start_stats = {};
        var _return_string = "";
        if (return_stat_diff) {
            _start_stats = get_stat_line();
        }
        if (struct_exists(global.trait_list, trait)) {
            if (!array_contains(traits, trait)) {
                var _stat_diff = {};
                var selec_trait = global.trait_list[$ trait];
                stat_boosts(selec_trait);
                array_push(traits, trait);

                if (return_stat_diff) {
                    var _end_stats = get_stat_line();

                    _stat_diff = compare_stats(_end_stats, _start_stats);
                }

                if (return_description) {
                    _return_string += $"{name_role()} Has gained the trait {selec_trait.display_name}";
                }

                if (return_stat_diff) {
                    _return_string += $", {print_stat_diffs(_stat_diff)}";
                }
            }
        }

        return _return_string;
    };

    static has_trait = function (_wanted_trait, _any = true) {
        if (is_array(_wanted_trait)) {
            var _len = array_length(_wanted_trait);

            if (_any) {
                for (var i = 0; i < _len; i++) {
                    if (array_contains(traits, _wanted_trait[i])) {
                        return true;
                    }
                }

                return false;
            } else {
                for (var i = 0; i < _len; i++) {
                    if (!array_contains(traits, _wanted_trait[i])) {
                        return false;
                    }
                }

                return true;
            }
        }

        return array_contains(traits, _wanted_trait);
    };

    static add_feat = function(feat) {
        feat_data = {};
        if (struct_exists(global.trait_list, feat.ident)) {
            feat_data = global.trait_list[$ feat.ident];
            var feat_name_set = struct_get_names(feat);
            for (var i = 0; i < array_length(feat_name_set); i++) {
                feat_data[$ feat_name_set[i]] = feat[$ feat_name_set[i]];
            }
        } else {
            feat_data = feat;
        }
        stat_boosts(feat_data);
        array_push(feats, feat_data);
    };

    static distribute_traits = scr_marine_trait_spawning;

    static alter_equipment = alter_unit_equipment;
    static stat_display = scr_draw_unit_stat_data;
    static draw_unit_image = scr_draw_unit_image;
    static display_wepaons = scr_ui_display_weapons;
    static unit_profile_text = scr_unit_detail_text;
    static has_equipped = unit_has_equipped;

    static unit_equipment_data = scr_get_unit_equipment;

    //body parts list can be extended as much as people want

    static alter_body = function(body_slot, body_item_key, new_body_data, overwrite = true) {
        //overwrite means it will replace any existing data
        if (struct_exists(body, body_slot)) {
            if (!struct_exists(body[$ body_slot], body_item_key) || overwrite) {
                body[$ body_slot][$ body_item_key] = new_body_data;
            }
        } else {
            return "invalid body area";
        }
    };

    static get_body_data = scr_get_body_data;

    static equipment_has_tag = function(tag, area) {
        var _tags = [];
        switch (area) {
            case "wep1":
                _tags = get_weapon_one_data("tags");
                break;
            case "wep2":
                _tags = get_weapon_two_data("tags");
                break;
            case "mobi":
                _tags = get_mobility_data("tags");
                break;
            case "armour":
                _tags = get_armour_data("tags");
                break;
            case "gear":
                _tags = get_gear_data("tags");
                break;
        }
        if (!is_array(_tags) || array_length(_tags) == 0) {
            return false;
        } else {
            return array_contains(_tags, tag);
        }
    };

    static equipment_maintenance_burden = function() {
        var burden = 0.0;
        burden += get_armour_data("maintenance");
        burden += get_gear_data("maintenance");
        burden += get_mobility_data("maintenance");
        burden += get_weapon_one_data("maintenance");
        burden += get_weapon_two_data("maintenance");
        if (has_trait("tinkerer")) {
            burden *= 0.33;
        }
        burden /= 1 / (technology / 35);
        return burden;
    };

    static race = function() {
        return obj_ini.race[company][marine_number];
    };

    static alter_loyalty = function(alt_val) {
        if (alt_val < 0) {
            if (has_trait("honorable")) {
                alt_val /= 2;
            }
            if (has_trait("jaded")) {
                alt_val *= 2;
            }
        }
        if (has_trait("old_guard")) {
            alt_val /= 2;
        }
        loyalty = clamp(loyalty + alt_val, 0, 100);
    };

    static update_loyalty = function(change_value) {
        loyalty = clamp(loyalty + change_value, 0, 100);
    };

    static calculate_death = function(death_threshold = 25, death_random = 50, apothecary = true, death_type = "normal") {
        dies = false;
        death_random += luck;
        death_threshold += luck;
        if (death_type == "normal") {
            death_threshold += constitution / 10;
            if (has_trait("very_hard_to_kill")) {
                death_threshold += 3;
            }
        }
        var chance = irandom(death_random);
        if (death_random > death_threshold) {
            dies = true;
        }
        return false;
    };

    /// @param {string} _area
    /// @param {string} _quality
    /// @param {bool} _from_armoury
    static add_bionics = function(_area = "none", _quality = "any", _from_armoury = true) {
        if (bionics >= 10) {
            return false;
        }

        // Identify eligible parts
        var _eligible_parts = [];
        var _body_parts = global.unit_body_parts;
        for (var i = 0, _len = array_length(_body_parts); i < _len; i++) {
            var _part_name = _body_parts[i];
            if (!get_body_data("bionic", _part_name)) {
                array_push(_eligible_parts, _part_name);
            }
        }

        if (array_length(_eligible_parts) == 0) {
            return false;
        }

        // Determine target part
        var _target_part = _area;
        if (_target_part == "none") {
            _target_part = _eligible_parts[irandom(array_length(_eligible_parts) - 1)];
        } else if (!array_contains(_eligible_parts, _target_part)) {
            return false;
        }

        // Consume from armoury
        if (_from_armoury) {
            if (scr_item_count("Bionics", _quality) < 1) {
                return false;
            }
            scr_add_item("Bionics", -1, _quality);
        }

        // Apply Health Bonus
        var _hp_gain = has_trait("flesh_is_weak") ? 40 : 30;
        add_or_sub_health(_hp_gain);

        // Apply Bionic
        var _bionic_data = {
            quality: _quality,
            variant: irandom(100),
        };

        alter_body(_target_part, "bionic", _bionic_data);
        bionics++;

        // Stat Modifications
        switch (_target_part) {
            case "left_leg":
            case "right_leg":
                constitution += 2;
                strength += 1;
                dexterity -= 2;
                break;
            case "left_eye":
            case "right_eye":
                constitution += 1;
                wisdom += 1;
                dexterity += 1;
                break;
            case "left_arm":
            case "right_arm":
                constitution += 2;
                strength += 2;
                weapon_skill -= 1;
                break;
            case "torso":
                constitution += 4;
                strength += 1;
                dexterity -= 1;
                break;
            case "throat":
                charisma -= 1;
                break;
            default:
                constitution += 1;
                break;
        }

        if (has_trait("flesh_is_weak")) {
            piety++;
        }

        if (hp() > max_health()) {
            update_health(max_health());
        }

        return true;
    };

    static age = function() {
        var real_age = obj_ini.age[company][marine_number];
        return real_age;
    }; // age

    static update_age = function(new_val) {
        obj_ini.age[company][marine_number] = new_val;
    };

    //TODO build epithets in to marine profile
    static add_epithet = function(epithet) {
        if (is_string(epithet)) {
            epithet = {
                title: epithet,
                story: "",
            };
        }
        array_push(epithets, epithet);
    };

    static name = function() {
        return obj_ini.name[company][marine_number];
    }; // get marine name

    static set_name = function(new_name) {
        obj_ini.name[company][marine_number] = new_name;
        return new_name;
    };

    static gear = function(raw = false) {
        var wep = obj_ini.gear[company][marine_number];
        if (is_string(wep) || raw) {
            return wep;
        }
        return obj_ini.artifact[wep];
    };

    static weapon_one = function(raw = false) {
        var wep = obj_ini.wep1[company][marine_number];
        if (is_string(wep) || raw) {
            return wep;
        }
        return obj_ini.artifact[wep];
    };

    static equipments_qual_string = function(slot, art_only = false) {
        var item;
        var quality;
        switch (slot) {
            case "wep1":
                item = weapon_one(true);
                quality = weapon_one_quality;
                break;
            case "wep2":
                item = weapon_two(true);
                quality = weapon_two_quality;
                break;
            case "armour":
                item = armour(true);
                quality = armour_quality;
                break;
            case "gear":
                item = gear(true);
                quality = gear_quality;
                break;
            case "mobi":
                item = mobility_item(true);
                quality = mobility_item_quality;
                break;
        }

        var is_artifact = !is_string(item);
        if (!is_artifact && art_only == false) {
            return $"{item}";
        } else if (is_artifact) {
            if (obj_ini.artifact_struct[item].name == "") {
                return $"{obj_ini.artifact[item]}";
            } else {
                return obj_ini.artifact_struct[item].name;
            }
        } else {
            return $"{item}";
        }
    };

    static weapon_viable = function(new_weapon, quality) {
        viable = true;
        qual_string = quality;
        if (scr_item_count(new_weapon, quality) > 0) {
            var exp_require = gear_weapon_data("weapon", new_weapon, "req_exp", false, quality);
            if (exp_require > experience) {
                viable = false;
                qual_string = "exp_low";
            }
            quality = scr_add_item(new_weapon, -1, quality);
            if (quality == "no_item") {
                return [
                    false,
                    "no_items",
                ];
            }
            qual_string = quality != undefined ? quality : "standard";
        } else {
            viable = false;
            qual_string = "no_items";
        }
        if (new_weapon == "Company Standard") {
            if (role() != obj_ini.role[100][11]) {
                viable = false;
                qual_string = "wrong_role";
            }
        }
        return [
            viable,
            qual_string,
        ];
    };

    static weapon_two = function(raw = false) {
        var wep = obj_ini.wep2[company][marine_number];
        if (is_string(wep) || raw) {
            return wep;
        }
        return obj_ini.artifact[wep];
    };

    static specials = function() {
        return obj_ini.spe[company][marine_number];
    };

    static specials_array = function() {
        var _specials_array = string_split(obj_ini.spe[company][marine_number], "|", true);
        return _specials_array;
    };

    static psy_discipline = function() {
        var _specials_array = specials_array();
        var _first_power_prefix = string_letters(_specials_array[0]);
        var _discipline = match_power_prefix(_first_power_prefix);

        return _discipline ?? "";
    };

    static update_powers = function() {
        var _powers_limit = 0;
        var _powers_known_count = 0;
        var _discipline_powers_max = 0;
        var _powers_learned = 0;
        var _abilities_string = specials();

        var _discipline_prefix = get_discipline_data(obj_ini.psy_powers, "prefix");
        var _discipline_powers = get_discipline_data(obj_ini.psy_powers, "powers");
        _discipline_powers_max = array_length(_discipline_powers);

        _powers_limit = max(0, floor((intelligence - 26) / 2));
        _powers_known_count = string_count(string(_discipline_prefix), _abilities_string);

        while ((_powers_known_count < _powers_limit) && (_powers_known_count < _discipline_powers_max)) {
            var _power_index = _powers_known_count;
            if (string_count(string(_power_index), _abilities_string) == 0) {
                _powers_known_count++;
                _powers_learned++;
                obj_ini.spe[company][marine_number] += string(_discipline_prefix) + string(_power_index) + "|";
                array_push(powers_known, _discipline_powers[_power_index]);
            }
        }

        return _powers_learned;
    };

    static roll_dice = function(dices = 1, faces = 6, player_benefit_at = "none") {
        return roll_dice_unit(self, dices, faces, player_benefit_at);
    };

    static roll_psionics = function() {
        var _dice_count = 1;
        var _psionics_roll = roll_dice_chapter(_dice_count, 100);

        if (scr_has_adv("Warp Touched")) {
            if (_psionics_roll < 170) {
                var _second_roll = roll_dice_chapter(_dice_count, 100, "high");
                _psionics_roll = _second_roll > _psionics_roll ? _second_roll : _psionics_roll;
            }
        } else if (scr_has_disadv("Psyker Intolerant")) {
            if (_psionics_roll >= 170) {
                var _second_roll = roll_dice_chapter(_dice_count, 100, "low");
                _psionics_roll = _second_roll < _psionics_roll ? _second_roll : _psionics_roll;
            }
        }

        if (_psionics_roll == 200) {
            psionic = 12;
        } else if (_psionics_roll >= 199) {
            psionic = 11;
        } else if (_psionics_roll >= 198) {
            psionic = 10;
        } else if (_psionics_roll >= 196) {
            psionic = 9;
        } else if (_psionics_roll >= 194) {
            psionic = 8;
        } else if (_psionics_roll >= 190) {
            psionic = 7;
        } else if (_psionics_roll >= 186) {
            psionic = 6;
        } else if (_psionics_roll >= 182) {
            psionic = 5;
        } else if (_psionics_roll >= 178) {
            psionic = 4;
        } else if (_psionics_roll >= 174) {
            psionic = 3;
        } else if (_psionics_roll >= 170) {
            psionic = 2;
        } else if (_psionics_roll >= 22) {
            psionic = 1;
        } else if (_psionics_roll >= 17) {
            psionic = 0;
        } else if (_psionics_roll >= 12) {
            psionic = -1;
        } else if (_psionics_roll >= 8) {
            psionic = -2;
        } else if (_psionics_roll >= 5) {
            psionic = -3;
        } else if (_psionics_roll >= 3) {
            psionic = -4;
        } else if (_psionics_roll >= 2) {
            psionic = -5;
        } else {
            psionic = -6;
        }
    };

    static role_refresh = function() {
        if (role() == "Lexicanum" && psionic >= 5 && experience > 50) {
            update_role("Codiciery");
        } else if (role() == "Codiciery" && psionic >= 8 && experience > 100) {
            update_role(obj_ini.role[100][eROLE.LIBRARIAN]);
        }
    };

    static add_exp = function(add_val) {
        var instance_stat_point_gains = {};
        var _powers_learned = 0;

        stat_point_exp_marker += add_val;
        experience += add_val;

        if (stat_point_exp_marker >= 15) {
            instance_stat_point_gains = handle_stat_growth(true);
        }

        if (IsSpecialist(SPECIALISTS_LIBRARIANS)) {
            _powers_learned = update_powers();
        }

        role_refresh();

        return [
            instance_stat_point_gains,
            _powers_learned,
        ];
    };

    //get equipment data methods by deafult they garb all equipment data and return an equipment struct e.g new EquipmentStruct(item_data, core_type,quality="none")
    static get_armour_data = function(type = "all") {
        return gear_weapon_data("armour", armour(), type, false, armour_quality, armour(true));
    };

    static get_gear_data = function(type = "all") {
        return gear_weapon_data("gear", gear(), type, false, gear_quality, gear(true));
    };

    static get_mobility_data = function(type = "all") {
        return gear_weapon_data("mobility", mobility_item(), type, false, mobility_item_quality, mobility_item(true));
    };

    static get_weapon_one_data = function(type = "all") {
        return gear_weapon_data("weapon", weapon_one(), type, false, weapon_one_quality, weapon_one(true));
    };

    static get_weapon_two_data = function(type = "all") {
        return gear_weapon_data("weapon", weapon_two(), type, false, weapon_two_quality, weapon_two(true));
    };

    static damage_resistance = function() {
        damage_res = 0;
        damage_res += get_armour_data("damage_resistance_mod");
        damage_res += get_gear_data("damage_resistance_mod");
        damage_res += get_mobility_data("damage_resistance_mod");
        damage_res += get_weapon_one_data("damage_resistance_mod");
        damage_res += get_weapon_two_data("damage_resistance_mod");
        damage_res = min(75, damage_res + floor((constitution * 0.005) * 100));
        return damage_res;
    };

    /// @returns {Struct.EquipmentStruct}
    static __get_weapon_struct = function(_slot = 1) {
        var _wep_struct = _slot == 1 ? get_weapon_one_data() : get_weapon_two_data();

        if (!is_struct(_wep_struct)) {
            _wep_struct = new EquipmentStruct({}, "");
        }

        if (allegiance == global.chapter_name) {
            _wep_struct.owner_data("chapter");
        }

        return _wep_struct;
    };

    static __get_total_equip_stat = function(stat_name) {
        var _total = 0;
        var _all_data = [
            get_armour_data(),
            get_gear_data(),
            get_mobility_data(),
            get_weapon_one_data(),
            get_weapon_two_data(),
        ];

        var _len = array_length(_all_data);
        for (var i = 0; i < _len; i++) {
            var _data = _all_data[i];
            if (is_struct(_data)) {
                _total += _data[$ stat_name] ?? 0;
            }
        }

        return _total;
    };

    static hands_carrying = function(is_melee = false) {
        var _data_key = is_melee ? "melee_hands" : "ranged_hands";
        var _carrying = 0;
        var _tooltip = new TooltipBuilder()
            .set_header("- Carrying -");

        var _weapons = [
            {
                val: get_weapon_one_data(_data_key),
                name: weapon_one(),
            },
            {
                val: get_weapon_two_data(_data_key),
                name: weapon_two(),
            },
        ];

        var _len = array_length(_weapons);
        for (var i = 0; i < _len; i++) {
            var _w = _weapons[i];
            if (_w.val != 0) {
                _carrying += _w.val;
                _tooltip.add_entry_typed("items", _w.name, _w.val);
            }
        }

        var _string = (_carrying != 0) ? (_tooltip.build() + "\n") : "";
        return [
            _carrying,
            _string,
        ];
    };

    static hands_limit = function(is_melee = false) {
        var _data_key = is_melee ? "melee_hands" : "ranged_hands";

        // Dynamic group limits
        var _group_limits = {
            "astartes": 2,
            "tech_priest": 1 + (technology / 100),
            "human": 1,
        };
        var _limit = _group_limits[$ base_group] ?? 2;

        var _tooltip = new TooltipBuilder()
            .set_header("- Maximum -")
            .add_entry("base", "Base", _limit);

        // Strength Check
        if (strength >= 50) {
            var _str_bonus = is_melee ? 0.25 : 0.5;
            _limit += _str_bonus;
            _tooltip.add_entry_typed("primary_mods", "STR", _str_bonus, eTOOLTIP_VALUE_TYPE.SIGNED);
        }

        // Accuracy/Skill Check
        var _target_skill = is_melee ? weapon_skill : ballistic_skill;
        var _skill_label = is_melee ? "WS" : "BS";
        if (_target_skill >= 50) {
            var _skill_bonus = 0.25;
            _limit += _skill_bonus;
            _tooltip.add_entry_typed("primary_mods", _skill_label, _skill_bonus, eTOOLTIP_VALUE_TYPE.SIGNED);
        }

        // Traits Check
        var _trait_names = is_melee ? ["champion", "paragon"] : ["marksman", "paragon"];
        if (has_trait(_trait_names)) {
            var _trait_bonus = 0.25;
            _limit += _trait_bonus;
            _tooltip.add_entry_typed("traits", "Traits", _trait_bonus, eTOOLTIP_VALUE_TYPE.SIGNED);
        }

        // Gear Loop
        var _gear = [
            {
                val: get_armour_data(_data_key),
                name: armour(),
            },
            {
                val: get_gear_data(_data_key),
                name: gear(),
            },
            {
                val: get_mobility_data(_data_key),
                name: mobility_item(),
            },
        ];

        var _len = array_length(_gear);
        for (var i = 0; i < _len; i++) {
            var _item = _gear[i];
            if (_item.val != 0) {
                _limit += _item.val;
                _tooltip.add_entry_typed("gear", _item.name, _item.val, eTOOLTIP_VALUE_TYPE.SIGNED);
            }
        }

        return [
            _limit,
            _tooltip.build() + "\n",
        ];
    };

    static ranged_attack = function() {
        return __calculate_attack(true);
    };

    static melee_attack = function() {
        return __calculate_attack(false);
    };

    static __resolve_weapons = function(_is_ranged, _wep1, _wep2) {
        var _primary = new EquipmentStruct();
        var _secondary = new EquipmentStruct();

        if (_is_ranged) {
            if (_wep1.range > 1.1 && _wep2.range > 1.1) {
                var _is_w1_better = _wep1.attack > _wep2.attack;
                _primary = _is_w1_better ? _wep1 : _wep2;
                _secondary = _is_w1_better ? _wep2 : _wep1;
            } else if (_wep1.range > 1.1) {
                _primary = _wep1;
            } else if (_wep2.range > 1.1) {
                _primary = _wep2;
            }
        } else {
            var _valid_tags = [
                "pistol",
                "flame",
            ];
            var _valid1 = (_wep1.range <= 1.1 && _wep1.range != 0) || _wep1.has_tags(_valid_tags);
            var _valid2 = (_wep2.range <= 1.1 && _wep2.range != 0) || _wep2.has_tags(_valid_tags);

            if (_valid1 && _valid2) {
                var _highest = _wep1.attack > _wep2.attack ? _wep1 : _wep2;
                var _lowest = _wep1.attack <= _wep2.attack ? _wep1 : _wep2;

                if (!_highest.has_tags(_valid_tags)) {
                    _primary = _highest;
                    _secondary = _lowest;
                } else if (!_lowest.has_tags(_valid_tags)) {
                    _primary = _lowest;
                    _secondary = _highest;
                } else {
                    _primary = _highest;
                    _secondary = _lowest;
                    return {
                        primary: _primary,
                        secondary: _secondary,
                    };
                }
            } else if (_valid1) {
                _primary = _wep1;
            } else if (_valid2) {
                _primary = _wep2;
            }
        }

        return {
            primary: _primary,
            secondary: _secondary,
        };
    };

    static __calculate_attack = function(_is_ranged) {
        var _total_attack = 0;
        var _final_multiplier = 1;

        var _primary_attack = 0;
        var _primary_multiplier = 1;

        var _secondary_attack = 0;
        var _secondary_multiplier = _is_ranged ? 0 : 0.5;
        var _secondary_type = $"Default";

        var _wep1 = __get_weapon_struct(1);
        var _wep2 = __get_weapon_struct(2);
        var _primary_weapon = _wep1;
        var _secondary_weapon = _wep2;

        var _carrying_data = hands_carrying(!_is_ranged);
        var _carrying_value = _carrying_data[0];
        var _carrying_tooltip = _carrying_data[1];

        var _limit_data = hands_limit(!_is_ranged);
        var _limit_value = _limit_data[0];
        var _limit_tooltip = _limit_data[1];

        var _tooltip = new TooltipBuilder();

        _tooltip.add_section("primary_weapon", "- Primary Weapon -")
            .add_section("primary_mods", "- Primary Modifiers -")
            .add_section("primary_bonuses", "- Primary Bonuses -")
            .add_section("secondary_weapon", "- Secondary Weapon -")
            .add_section("secondary_mult", "- Secondary Multiplier -")
            .add_section("flat_bonuses", "- Bonuses -")
            .add_section("final_mult", "- Multipliers -");

        // Base Stat Multiplier

        var _exp_modifier = experience / 500;
        var _skill_modifier = _is_ranged ? (ballistic_skill / 100) : (weapon_skill / 100);

        if (_is_ranged) {
            var _dex_modifier = dexterity / 400;
            _primary_multiplier += _skill_modifier + _dex_modifier + _exp_modifier;
            _tooltip.add_entry_typed("primary_mods", "BS", _skill_modifier * 100, eTOOLTIP_VALUE_TYPE.SIGNED_PERCENTAGE);
            _tooltip.add_entry_typed("primary_mods", "DEX", _dex_modifier * 100, eTOOLTIP_VALUE_TYPE.SIGNED_PERCENTAGE);
            _tooltip.add_entry_typed("primary_mods", "EXP", _exp_modifier * 100, eTOOLTIP_VALUE_TYPE.SIGNED_PERCENTAGE);
        } else {
            _primary_multiplier += _skill_modifier + _exp_modifier;
            _tooltip.add_entry_typed("primary_mods", "WS", _skill_modifier * 100, eTOOLTIP_VALUE_TYPE.SIGNED_PERCENTAGE);
            _tooltip.add_entry_typed("primary_mods", "EXP", _exp_modifier * 100, eTOOLTIP_VALUE_TYPE.SIGNED_PERCENTAGE);
        }

        // Weapon Resolution

        var _resolved = __resolve_weapons(_is_ranged, _wep1, _wep2);
        var _primary_weapon = _resolved.primary;
        var _secondary_weapon = _resolved.secondary;

        if (_primary_weapon.name == "") {
            if (array_length(_wep1.second_profiles) + array_length(_wep2.second_profiles) == 0) {
                if (_is_ranged) {
                    return [
                        0,
                        _tooltip.build(true),
                        [
                            _carrying_value,
                            _limit_value,
                            _carrying_tooltip + _limit_tooltip,
                        ],
                        new EquipmentStruct(),
                        new EquipmentStruct(),
                    ];
                } else {
                    var _melee = new EquipmentStruct();
                    _melee.attack = strength / 3;
                    _melee.name = "Melee";
                    _melee.range = 1;
                    _primary_weapon = _melee;
                    _secondary_weapon = new EquipmentStruct();
                }
            } else {
                var _p1_count = array_length(_wep1.second_profiles);
                for (var sec = 0; sec < _p1_count; sec++) {
                    var sec_profile = gear_weapon_data("weapon", _wep1.second_profiles[sec], "all", false, weapon_one_quality);
                    if (is_struct(sec_profile) && sec_profile.range > 1.1 && sec_profile.attack > 0) {
                        _total_attack += sec_profile.attack;
                        _tooltip.add_entry_typed("flat_bonuses", sec_profile.name, sec_profile.attack, eTOOLTIP_VALUE_TYPE.SIGNED);
                    }
                }

                var _p2_count = array_length(_wep2.second_profiles);
                for (var sec = 0; sec < _p2_count; sec++) {
                    var sec_profile = gear_weapon_data("weapon", _wep2.second_profiles[sec], "all", false, weapon_two_quality);
                    if (is_struct(sec_profile) && sec_profile.range > 1.1 && sec_profile.attack > 0) {
                        _total_attack += sec_profile.attack;
                        _tooltip.add_entry_typed("flat_bonuses", sec_profile.name, sec_profile.attack, eTOOLTIP_VALUE_TYPE.SIGNED);
                    }
                }

                if (array_length(_wep1.second_profiles) > 0) {
                    _primary_weapon = gear_weapon_data("weapon", _wep1.second_profiles[0], "all", false, weapon_one_quality);
                }

                if (array_length(_wep2.second_profiles) > 0) {
                    _secondary_weapon = gear_weapon_data("weapon", _wep2.second_profiles[0], "all", false, weapon_two_quality);
                }

                _total_attack *= _primary_multiplier * _final_multiplier;

                return [
                    _total_attack,
                    _tooltip.build(true),
                    [
                        _carrying_value,
                        _limit_value,
                        _carrying_tooltip + _limit_tooltip,
                    ],
                    _primary_weapon,
                    _secondary_weapon,
                ];
            }
        }

        _tooltip.add_entry_typed("primary_weapon", _primary_weapon.name, _primary_weapon.attack);

        // Primary Attack Mods

        if (!_is_ranged) {
            if (_primary_weapon.has_tag("martial") || _primary_weapon.has_tag("savage")) {
                var martial_bonus = _primary_weapon.has_tag("martial") ? (dexterity / 100) : 0;
                var savage_bonus = _primary_weapon.has_tag("savage") ? (strength / 100) : 0;
                _primary_multiplier += martial_bonus + savage_bonus;
                if (martial_bonus != 0) {
                    _tooltip.add_entry_typed("primary_mods", "DEX (Martial)", martial_bonus * 100, eTOOLTIP_VALUE_TYPE.SIGNED_PERCENTAGE);
                }

                if (savage_bonus != 0) {
                    _tooltip.add_entry_typed("primary_mods", "STR (Savage)", savage_bonus * 100, eTOOLTIP_VALUE_TYPE.SIGNED_PERCENTAGE);
                }
            } else {
                var _str_bonus = strength / 200;
                var _dex_bonus = dexterity / 200;
                _primary_multiplier += _str_bonus + _dex_bonus;
                _tooltip.add_entry_typed("primary_mods", "STR", _str_bonus * 100, eTOOLTIP_VALUE_TYPE.SIGNED_PERCENTAGE);
                _tooltip.add_entry_typed("primary_mods", "DEX", _dex_bonus * 100, eTOOLTIP_VALUE_TYPE.SIGNED_PERCENTAGE);
            }

            if (_primary_weapon.has_tag("fist") && has_trait("brawler")) {
                var _brawler_mult = 0.1;
                _primary_multiplier += _brawler_mult;
                _tooltip.add_entry_typed("primary_mods", global.trait_list[$ "brawler"].display_name, _brawler_mult * 100, eTOOLTIP_VALUE_TYPE.SIGNED_PERCENTAGE);
            }

            if (_primary_weapon.has_tag("power") && has_trait("duelist")) {
                var _duelist_mult = 0.3;
                _primary_multiplier += _duelist_mult;
                _tooltip.add_entry_typed("primary_mods", global.trait_list[$ "duelist"].display_name, _duelist_mult * 100, eTOOLTIP_VALUE_TYPE.SIGNED_PERCENTAGE);
            }
        }

        // Primary Chapter Effects

        if (allegiance == global.chapter_name && base_group == "astartes" && array_length(_primary_weapon.tags) > 0) {
            var _chapter_effects = obj_ini.chapter_data.calc_equipment_tag_mods(_primary_weapon.tags, "attack");
            _primary_multiplier += _chapter_effects.mult;
            for (var _ce_i = 0; _ce_i < array_length(_chapter_effects.effects); _ce_i++) {
                var _e = _chapter_effects.effects[_ce_i];
                if (is_struct(_e) && struct_exists(_e, "mult")) {
                    _tooltip.add_entry_typed("primary_mods", _e.name, (_e.mult - 1) * 100, eTOOLTIP_VALUE_TYPE.SIGNED_PERCENTAGE);
                }
            }
        }

        // Primary Multiplier

        _tooltip.add_entry_typed("primary_mods", "Total", (_primary_multiplier - 1) * 100, eTOOLTIP_VALUE_TYPE.SIGNED_PERCENTAGE);
        _primary_attack = _primary_weapon.attack * _primary_multiplier;

        // Primary Melee Psychic Bonus

        if (!_is_ranged) {
            if (psionic > 0 && has_force_weapon()) {
                var psychic_bonus = psionic * 20;
                psychic_bonus *= 0.5 + (wisdom / 100);
                psychic_bonus *= 0.5 + (experience / 100);
                psychic_bonus *= IsSpecialist(SPECIALISTS_LIBRARIANS) ? 1 : 0.25;
                psychic_bonus = round(psychic_bonus);
                _primary_attack += psychic_bonus;
                _tooltip.add_entry_typed("primary_bonuses", "Psychic Power", psychic_bonus, eTOOLTIP_VALUE_TYPE.SIGNED);
            }
        }

        // Secondary Attack

        if (_secondary_weapon.name != "") {
            if (_is_ranged) {
                if (_primary_weapon.has_tag("pistol") && _secondary_weapon.has_tag("pistol")) {
                    _secondary_multiplier = 1;
                    _secondary_type = "Dual Pistols";
                }
            } else {
                if (_primary_weapon.has_tag("dual") && _secondary_weapon.has_tag("dual")) {
                    _secondary_multiplier = 1;
                    _secondary_type = "Dual";
                } else if (_secondary_weapon.has_tag("pistol")) {
                    _secondary_multiplier = 1;
                    _secondary_type = "Pistol";
                }
            }

            if (_secondary_multiplier > 0) {
                _secondary_attack = _secondary_weapon.attack * _secondary_multiplier;
                _tooltip.add_entry_typed("secondary_weapon", _secondary_weapon.name, _secondary_weapon.attack);
                _tooltip.add_entry_typed("secondary_mult", _secondary_type, _secondary_multiplier, eTOOLTIP_VALUE_TYPE.MULTIPLIER);
            }
        }

        // Gear Mod

        var _gear_mod = __get_total_equip_stat(_is_ranged ? "ranged_mod" : "melee_mod");
        if (_gear_mod != 0) {
            var _gear_multiplier = 1 + (_gear_mod / 100);
            _final_multiplier *= _gear_multiplier;
            _tooltip.add_entry_typed("final_mult", "Gear Mod", _gear_multiplier, eTOOLTIP_VALUE_TYPE.MULTIPLIER);
        }

        // Traits

        if (has_trait("feet_floor")) {
            var _feet_floor = mobility_item() == "" ? 1 : 0.9;
            _final_multiplier *= _feet_floor;
            var _feet_trait_data = global.trait_list[$ "feet_floor"];
            _tooltip.add_entry_typed("final_mult", _feet_trait_data.display_name, _feet_floor, eTOOLTIP_VALUE_TYPE.MULTIPLIER);
        }

        // Encumbrance

        var _encumbrance_mod = _carrying_value > 0 ? (_limit_value / _carrying_value) : 1;
        if (_encumbrance_mod < 1) {
            _tooltip.add_entry_typed("final_mult", "Encumbered", _encumbrance_mod, eTOOLTIP_VALUE_TYPE.MULTIPLIER);
            _final_multiplier *= _encumbrance_mod;
        }

        if (_is_ranged) {
            encumbered_ranged = _encumbrance_mod < 1;
        } else {
            encumbered_melee = _encumbrance_mod < 1;
        }

        // Totals

        _total_attack = floor((_primary_attack + _secondary_attack) * _final_multiplier);

        return [
            _total_attack,
            _tooltip.build(true),
            [
                _carrying_value,
                _limit_value,
                _carrying_tooltip + _limit_tooltip,
            ],
            _primary_weapon,
            _secondary_weapon,
        ];
    };

    static has_force_weapon = function() {
        var _wep1 = get_weapon_one_data();
        var _wep2 = get_weapon_two_data();

        if (is_struct(_wep1) && _wep1.has_tag("force")) {
            return true;
        }

        if (is_struct(_wep2) && _wep2.has_tag("force")) {
            return true;
        }

        return false;
    };

    //TODO just did this so that we're not loosing featuring but this porbably needs a rethink
    static hammer_of_wrath = function(_melee_damage_data = melee_attack()) {
        var _melee_attack = _melee_damage_data[0];
        var _melee_weapon = _melee_damage_data[3];

        var wrath = new EquipmentStruct(
            {
                attack: _melee_attack * 0.75,
                name: "Hammer of Wrath",
                range: 2,
                ammo: 6,
                spli: _melee_weapon.spli,
                arp: _melee_weapon.arp,
            },
            "weapon",
        );

        var wrath_melee = new EquipmentStruct(
            {
                attack: _melee_attack * 1.25,
                name: "Hammer of Wrath(M)",
                range: 1,
                ammo: 8,
                spli: _melee_weapon.spli,
                arp: _melee_weapon.arp,
            },
            "weapon",
        );

        wrath.second_profiles = [wrath_melee];

        return wrath;
    };

    static armour_calc = function() {
        var _armour_rating = 0;
        _armour_rating += get_armour_data("armour_value");
        _armour_rating += get_weapon_one_data("armour_value");
        _armour_rating += get_mobility_data("armour_value");
        _armour_rating += get_gear_data("armour_value");
        _armour_rating += get_weapon_two_data("armour_value");
        if (armour() != "" && allegiance == global.chapter_name) {
            // STC Bonuses
            if (obj_controller.stc_bonus[1] == 5) {
                _armour_rating *= 1.05;
            }
            if (obj_controller.stc_bonus[2] == 3) {
                _armour_rating *= 1.05;
            }
        }
        return _armour_rating;
    };

    static in_squad = function() {
        return squad != "none";
    };

    static get_squad = function() {
        return fetch_squad(squad);
    };

    static assignment = function() {
        if (squad != "none") {
            var _squad = get_squad();
            if (_squad.assignment != "none") {
                return _squad.assignment.type;
            }
        }
        if (job != "none") {
            return job.type;
        } else {
            return "none";
        }
    };

    static remove_from_squad = function() {
        if (squad != "none") {
            var _squad = get_squad();

            for (var r = 0; r < array_length(_squad.members); r++) {
                squad_member = _squad.members[r];
                if ((squad_member[0] == company) && (squad_member[1] == marine_number)) {
                    array_delete(_squad.members, r, 1);
                }
            }

            squad = "none";
        }
    };

    static squad_type = function() {
        var _type = "none";
        if (squad != "none") {
            if (struct_exists(obj_ini.squads, squad)) {
                return get_squad().type;
            }
        }
        return _type;
    };

    static add_to_squad = function(new_squad) {
        if (squad != "none") {
            if (new_squad == squad) {
                exit;
            }
            remove_from_squad();
        }
        squad = new_squad;
        var _squad = get_squad();
        _squad.add_member(company, marine_number);
    };

    static marine_location = function() {
        var location_id, location_name;
        var location_type = planet_location;
        if (location_type > 0) {
            //if marine is on planet
            location_id = location_type; //planet_number marine is on
            location_type = eLOCATION_TYPES.PLANET; //state marine is on planet
            if (location_string == "home") {
                location_string = obj_ini.home_name;
            }
            location_name = location_string; //system marine is in
        } else {
            location_type = eLOCATION_TYPES.SHIP; //marine is on ship
            location_id = ship_location > -1 ? ship_location : 0; //ship array position
            if (location_id < array_length(obj_ini.ship_location)) {
                location_name = obj_ini.ship_location[location_id]; //location of ship
            } else {
                location_name = location_string;
            }
        }
        return [
            location_type,
            location_id,
            location_name,
        ];
    };

    //quick way of getting name and role combined in string
    static name_role = function(include_epithet = true, include_role = true) {
        var _name = name();
        var _epithet = "";

        if (include_role) {
            var _temp_role = squad_role();
            _name = string("{0} {1}", _temp_role, _name);
        }

        if (include_epithet) {
            if (array_length(epithets)) {
                _epithet += $"{epithets[0].title}";
            }
        }

        if (include_epithet && _epithet != "") {
            return string("{0} {1}", _name, _epithet);
        }

        return _name;
    };

    static controllable = function() {
        return !location_out_of_player_control(location_string);
    };

    static full_title = function() {
        return $"{squad_role()} of the {company_roman} Company";
    };

    static company_roman = function() {
        return $"{scr_roman_numerals()[company - 1]}";
    };

    static load_marine = function(ship, star = noone) {
        get_unit_size(); // make sure marines size given it's current equipment is correct
        var current_location = marine_location();
        var system = current_location[2];
        var target_ship_location = obj_ini.ship_location[ship];
        set_last_ship();
        if (assignment() != "none") {
            return "on assignment";
        }
        if (target_ship_location == "home") {
            target_ship_location = obj_ini.home_name;
        }

        if (current_location[0] == eLOCATION_TYPES.PLANET) {
            //if marine is on a planet
            if (current_location[2] == "home") {
                system = obj_ini.home_name;
            }
            //check if ship is in the same location as marine and has enough space;
            if ((target_ship_location == system) && ((obj_ini.ship_carrying[ship] + size) <= obj_ini.ship_capacity[ship])) {
                planet_location = 0; //mark marine as no longer on planet
                ship_location = ship; //id of ship marine is now loaded on
                obj_ini.ship_carrying[ship] += size; //update ship capacity

                if (star == noone) {
                    star = find_star_by_name(system);
                }
                if (star != noone) {
                    if (star.p_player[current_location[1]] > 0) {
                        star.p_player[current_location[1]] -= size;
                    }
                }
            }
        } else if (current_location[0] == eLOCATION_TYPES.SHIP) {
            //with this addition marines can now be moved between ships freely as long as they are in the same system
            var off_loading_ship = current_location[1];
            if ((obj_ini.ship_location[ship] == obj_ini.ship_location[off_loading_ship]) && ((obj_ini.ship_carrying[ship] + size) <= obj_ini.ship_capacity[ship])) {
                obj_ini.ship_carrying[off_loading_ship] -= size; // remove from previous ship capacity
                ship_location = ship; // change marine location to new ship
                obj_ini.ship_carrying[ship] += size; //add marine capacity to new ship
            }
        }
    };

    static set_last_ship = function() {
        if (ship_location > -1) {
            last_ship.uid = obj_ini.ship_uid[ship_location];
            last_ship.name = obj_ini.ship[ship_location];
        } else {
            last_ship = {
                uid: "",
                name: "",
            };
        }
    };

    static unload = function(planet_number, system) {
        var current_location = marine_location();
        set_last_ship();
        if (!controllable()) {
            return;
        }
        if (current_location[0] == eLOCATION_TYPES.SHIP) {
            if (current_location[2] != "Warp" && current_location[2] == system.name) {
                location_string = obj_ini.ship_location[current_location[1]];
                planet_location = planet_number;
                ship_location = -1;
                get_unit_size();
                system.p_player[planet_number] += size;
                obj_ini.ship_carrying[current_location[1]] -= size;
            }
        } else {
            ship_location = -1;
            location_string = system.name;
            planet_location = planet_number;
            system.p_player[planet_number] += size;
        }
    };

    static allocate_unit_to_fresh_spawn = function(type = "default") {
        var homestar = noone;
        var spawn_location_chosen = false;
        if (((type == "home") || (type == "default")) && (obj_ini.fleet_type == ePLAYER_BASE.HOME_WORLD)) {
            homestar = find_star_by_name(obj_ini.home_name);
        } else if (type != "ship") {
            homestar = find_star_by_name(type);
        }
        if (homestar != noone) {
            for (var i = 1; i <= homestar.planets; i++) {
                if (homestar.p_owner[i] == eFACTION.PLAYER || (obj_controller.faction_status[eFACTION.IMPERIUM] != "War" && array_contains(obj_controller.imperial_factions, homestar.p_owner[i]))) {
                    planet_location = i;
                    location_string = obj_ini.home_name;
                    spawn_location_chosen = true;
                }
            }
        }
        if (!spawn_location_chosen) {
            var player_fleet = get_largest_player_fleet();
            if (player_fleet != noone) {
                get_unit_size();
                load_unit_to_fleet(player_fleet, self);
                spawn_location_chosen = true;
            }
            //TODO add more work arounds in case of no valid spawn point
            if (!spawn_location_chosen) {
                if (player_fleet != noone) {}
            }
        }
    };

    static specialist_tooltips = specialistfunct;

    static is_at_location = function(location = "", planet = 0, ship = -1) {
        var _is_at_loc = false;
        var _multi_ship = is_array(ship);
        var _multi_planet = is_array(planet);
        if ((_multi_planet || planet > 0) && location_string == location) {
            if (_multi_planet) {
                _is_at_loc = array_contains(planet, planet_location);
            } else {
                _is_at_loc = planet_location == planet;
            }
        } else if (_multi_ship) {
            _is_at_loc = array_contains(ship, ship_location);
        } else if (ship > -1) {
            _is_at_loc = ship_location == ship;
        } else if (ship == -1 && planet == 0) {
            if (ship_location > -1) {
                if (obj_ini.ship_location[ship_location] == location) {
                    _is_at_loc = true;
                }
            } else if (location_string == location) {
                _is_at_loc = true;
            }
        }
        return _is_at_loc;
    };

    static edit_corruption = function(edit) {
        corruption = edit > 0 ? min(100, corruption + edit) : max(0, corruption + edit);
    };

    static in_jail = function() {
        return god_status() >= 10;
    };

    static god_status = function() {
        return obj_ini.god[company][marine_number];
    };

    static forge_point_generation = unit_forge_point_generation;

    static apothecary_point_generation = unit_apothecary_points_gen;

    static marine_assembling = scr_marine_game_spawn_constructions;

    static random_update_armour = scr_marine_spawn_armour;

    static roll_age = scr_marine_spawn_age;

    static roll_experience = function() {
        var _age_bonus = age();
        var _gauss_sd_mod = 14;

        var _exp = _age_bonus;
        _exp = max(0, floor(gauss(_exp, _exp / _gauss_sd_mod)));
        add_exp(_exp);
    };

    static assign_reactionary_traits = function() {
        var _age = age();
        var _exp = experience;
        var _total_score = _age + _exp;

        if (_total_score > 280) {
            add_trait("ancient");
        } else if (_total_score > 180) {
            add_trait("old_guard");
        } else if (_total_score > 100) {
            add_trait("seasoned");
        }
    };

    static set_default_equipment = function(from_armoury = true, to_armoury = true, quality = "any") {
        var role_match = -1;
        for (var i = 0; i < 24; i++) {
            if (obj_ini.role[100][i] == role()) {
                role_match = i;
                break;
            }
        }
        if (role_match != -1) {
            alter_equipment({"wep1": obj_ini.wep1[100][role_match], "wep2": obj_ini.wep2[100][role_match], "mobi": obj_ini.mobi[100][role_match], "armour": obj_ini.armour[100][role_match], "gear": obj_ini.gear[100][role_match]}, from_armoury, to_armoury, quality);
        }
    };

    static equipped_artifacts = function() {
        artis = [
            weapon_one(true),
            weapon_two(true),
            gear(true),
            armour(true),
            mobility_item(true),
        ];
        var arti_length = array_length(artis);
        for (var i = 0; i < arti_length; i++) {
            if (is_string(artis[i])) {
                array_delete(artis, i, 1);
                i--;
                arti_length--;
            }
        }
        return artis;
    };

    static equipped_artifact_tag = function(tag) {
        var cur_artis = equipped_artifacts();
        var arti;
        var has_tag = false;
        for (var i = 0; i < array_length(cur_artis); i++) {
            arti = obj_ini.artifact_struct[cur_artis[i]];
            has_tag = arti.has_tag(tag);
            if (has_tag) {
                break;
            }
        }
        return has_tag;
    };

    static get_stat_line = function() {
        return {
            "constitution": constitution,
            "strength": strength,
            "luck": luck,
            "dexterity": dexterity,
            "wisdom": wisdom,
            "piety": piety,
            "charisma": charisma,
            "technology": technology,
            "intelligence": intelligence,
            "weapon_skill": weapon_skill,
            "ballistic_skill": ballistic_skill,
        };
    };

    //TODO: Make this into a universal stat gathering function from all gear, for any stat;
    static gear_special_value = function(special_id) {
        var _total_special_value = 0;

        var _all_data = [
            get_armour_data(),
            get_gear_data(),
            get_mobility_data(),
            get_weapon_one_data(),
            get_weapon_two_data(),
        ];

        for (var i = 0; i < array_length(_all_data); i++) {
            var _equipment_piece = _all_data[i];
            if (is_struct(_equipment_piece)) {
                _total_special_value += _equipment_piece.special_value(special_id);
            }
        }

        return _total_special_value;
    };

    static psychic_amplification = function() {
        return round((psionic - 2) + (experience * 0.01));
    };

    static psychic_focus = function() {
        return round((wisdom * 0.4) + (experience * 0.05));
    };

    static perils_threshold = function() {
        var _perils_threshold = PSY_PERILS_CHANCE_BASE;

        if (instance_exists(obj_ncombat)) {
            _perils_threshold += obj_ncombat.global_perils;
        }

        if (has_trait("warp_tainted")) {
            _perils_threshold -= 5;
        }

        if (has_trait("favoured_by_the_warp")) {
            _perils_threshold -= 5;
        }

        _perils_threshold = max(_perils_threshold, PSY_PERILS_CHANCE_MIN);

        return _perils_threshold;
    };

    static perils_strength = function() {
        var _perils_strength = roll_dice_unit(self, 1, 100, "low");

        // I hope you like demons
        if (has_trait("warp_tainted")) {
            var _second_roll = roll_dice_unit(self, 1, 100, "high");
            if (_second_roll > _perils_strength) {
                _perils_strength = _second_roll;
            }
        }

        _perils_strength = max(_perils_strength, PSY_PERILS_STR_BASE);

        return _perils_strength;
    };

    static perils_test = function() {
        var _roll = roll_dice_unit(self, 1, 1000, "high");
        var _perils_threshold = perils_threshold();

        return _roll <= _perils_threshold;
    };

    static psychic_focus_difficulty = function() {
        var _cast_difficulty = PSY_CAST_DIFFICULTY_BASE; //TODO: Make this more dynamic;
        _cast_difficulty -= gear_special_value("psychic_focus");
        _cast_difficulty -= psychic_focus();
        _cast_difficulty = max(_cast_difficulty, PSY_CAST_DIFFICULTY_MIN);

        return _cast_difficulty;
    };

    static psychic_focus_test = function() {
        var _cast_roll = roll_dice_unit(self, 1, 100, "high");
        var _cast_difficulty = psychic_focus_difficulty();
        var _test_successful = _cast_roll >= _cast_difficulty;

        if (_test_successful) {
            roll_psionic_increase();
            if (roll_dice_unit(self, 2, 10, "high") == 20) {
                add_exp(1 * (_cast_difficulty / 100));
            }
        }

        return _test_successful;
    };

    static roll_psionic_increase = function() {
        if (psionic < 12) {
            var _psionic_difficulty = max(1, (psionic * 50) - experience);

            var _dice_roll = roll_dice_unit(self, 1, _psionic_difficulty, "high");
            if (_dice_roll == _psionic_difficulty) {
                psionic++;
                add_battle_log_message($"{name_role()} was touched by the warp!", eMSG_COLOR.AQUA);
            }
        }
    };

    static movement_after_math = function(end_company = company, end_slot = marine_number, check_squads = true) {
        if (squad != "none" && check_squads) {
            var squad_data = get_squad();
            var squad_member;

            for (var r = 0; r < array_length(squad_data.members); r++) {
                squad_member = squad_data.members[r];
                if (squad_member[0] == company && squad_member[1] == marine_number) {
                    if (squad_data.base_company != end_company) {
                        array_delete(squad_data.members, r, 1);
                        squad = "none";
                        // if unit will no longer be same company as squad remove unit from squad
                    } else {
                        squad_data.members[r] = [
                            end_company,
                            end_slot,
                        ];
                    }
                    break;
                }
            }
        }

        var artifact_list = equipped_artifacts();
        for (var i = 0; i < array_length(artifact_list); i++) {
            var arti = obj_ini.artifact_struct[artifact_list[i]];
            arti.bearer = [
                end_company,
                end_slot,
            ];
        }
    };

    static is_dreadnought = function() {
        var _arm_data = get_armour_data();
        if (is_struct(_arm_data)) {
            if (_arm_data.has_tag("dreadnought")) {
                return true;
            }
        }
        return false;
    };

    /// @param {Enum.EquipmentSlot} _slot
    static add_equipment_repairs = function(_slot = eEQUIPMENT_SLOT.ALL) {
        var _slots = array_create(0);

        switch (_slot) {
            case eEQUIPMENT_SLOT.ARMOUR:
                _slots = [eEQUIPMENT_SLOT.ARMOUR];
                break;
            case eEQUIPMENT_SLOT.WEAPON_ONE:
                _slots = [eEQUIPMENT_SLOT.WEAPON_ONE];
                break;
            case eEQUIPMENT_SLOT.WEAPON_TWO:
                _slots = [eEQUIPMENT_SLOT.WEAPON_TWO];
                break;
            case eEQUIPMENT_SLOT.GEAR:
                _slots = [eEQUIPMENT_SLOT.GEAR];
                break;
            case eEQUIPMENT_SLOT.MOBILITY:
                _slots = [eEQUIPMENT_SLOT.MOBILITY];
                break;
            case eEQUIPMENT_SLOT.ALL:
                _slots = [
                    eEQUIPMENT_SLOT.ARMOUR,
                    eEQUIPMENT_SLOT.WEAPON_ONE,
                    eEQUIPMENT_SLOT.WEAPON_TWO,
                    eEQUIPMENT_SLOT.GEAR,
                    eEQUIPMENT_SLOT.MOBILITY,
                ];
                break;
        }

        for (var i = 0; i < array_length(_slots); i++) {
            var _cur_slot = _slots[i];
            switch (_cur_slot) {
                case eEQUIPMENT_SLOT.ARMOUR:
                    obj_controller.specialist_point_handler.add_to_armoury_repair(armour());
                    if (instance_exists(obj_ncombat)) {
                        obj_ncombat.slime += get_armour_data("maintenance");
                    }
                    break;

                case eEQUIPMENT_SLOT.WEAPON_ONE:
                    obj_controller.specialist_point_handler.add_to_armoury_repair(weapon_one());
                    if (instance_exists(obj_ncombat)) {
                        obj_ncombat.slime += get_weapon_one_data("maintenance");
                    }
                    break;

                case eEQUIPMENT_SLOT.WEAPON_TWO:
                    obj_controller.specialist_point_handler.add_to_armoury_repair(weapon_two());
                    if (instance_exists(obj_ncombat)) {
                        obj_ncombat.slime += get_weapon_two_data("maintenance");
                    }
                    break;

                case eEQUIPMENT_SLOT.GEAR:
                    obj_controller.specialist_point_handler.add_to_armoury_repair(gear());
                    if (instance_exists(obj_ncombat)) {
                        obj_ncombat.slime += get_gear_data("maintenance");
                    }
                    break;

                case eEQUIPMENT_SLOT.MOBILITY:
                    obj_controller.specialist_point_handler.add_to_armoury_repair(mobility_item());
                    if (instance_exists(obj_ncombat)) {
                        obj_ncombat.slime += get_mobility_data("maintenance");
                    }
                    break;
            }
        }
    };
}

function jsonify_marine_struct(company, marine, stringify = true) {
    var copy_marine_struct = obj_ini.TTRPG[company][marine]; //grab marine structure
    var new_marine = {};
    var copy_part;
    var names = variable_struct_get_names(copy_marine_struct); // get all keys within structure
    for (var name = 0; name < array_length(names); name++) {
        //loop through keys to find which ones are methods as they can't be saved as a json string
        if (!is_method(copy_marine_struct[$ names[name]])) {
            copy_part = variable_clone(copy_marine_struct[$ names[name]]);
            variable_struct_set(new_marine, names[name], copy_part); //if key value is not a method add to copy structure
            delete copy_part;
        }
    }
    if (stringify) {
        return json_stringify(new_marine, true);
    } else {
        return new_marine;
    }
}

/// @param {Array<Real>} unit where unit[0] is company and unit[1] is the position
/// @returns {Struct.TTRPG_stats} unit
function fetch_unit(unit) {
    try {
        return obj_ini.TTRPG[unit[0]][unit[1]];
    } catch (_exception) {
        ERROR_HANDLER.assert_popup(_exception);
    }
}

function fetch_unit_uid(uuid) {
    for (var i = 0; i < obj_ini.companies; i++) {
        var _comp_length = array_length(obj_ini.TTRPG[i]);
        for (var s = 0; s < _comp_length; s++) {
            var _unit = fetch_unit([i, s]);
            if (_unit.uid == uuid) {
                return _unit;
            }
        }
    }

    return "none";
}
