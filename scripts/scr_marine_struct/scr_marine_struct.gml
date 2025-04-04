//in future would be better to store old guard data in a struct like this but for now while working out kinks have left hardcoded
/*old_guard_equipment :{
	role[100][5]:{"armour":[["MK3 Iron Armour",25]]},
	role[100][14]:{"armour":[["MK3 Iron Armour",25]],
	role[100][15]:{"armour":[["MK3 Iron Armour", 10]]}, //apothecary
	role[100][16]:{"armour":},
	obj_ini.role[100][11]:{"armour":[["MK3 Iron Armour", 3]]},
	role[100][7]:{"armour":[]},  //company champion
	role[100][8]:{"armour":[["MK8 Errant", 3],["MK3 Iron Armour", 3],["MK4 Maximus", 3],["MK5 Heresy", 3]]},     //tacticals
	role[100][10]:{"armour":},		
	role[100][9]:{"armour":},
	role[100][12]:{"armour":},
}*/

/*
		where the notation is[int,int, "string"] e.g [1,2,"max"]
		the first int is a base or mean value the second int is a sd number to be passed to the gauss() function
		the string (usually max) is guidance so in the instance of max it will pick the larger value of the mean and the gauss function return
*/
// will swap these out for enums or some better method as i develop where this is going
#macro ARR_body_parts ["left_leg", "right_leg", "torso", "right_arm", "left_arm", "left_eye", "right_eye", "throat", "jaw", "head"]
#macro ARR_body_parts_display ["Left Leg", "Right Leg", "Torso", "Right Arm", "Left Arm", "Left Eye", "Right Eye", "Throat", "Jaw", "Head"]
global.religions = {
    "imperial_cult": {
        "name": "Imperial Cult"
    },
    "cult_mechanicus": {
        "name": "Cult Mechanicus"
    },
    "eight_fold_path": {
        "name": "The Eight Fold Path"
    }
};
#macro ARR_power_armour ["MK7 Aquila", "MK6 Corvus", "MK5 Heresy", "MK3 Iron Armour", "MK4 Maximus", "Power Armour"]
enum location_types {
    planet,
    ship,
    space_hulk,
    ancient_ruins,
    warp,
}

#macro ARR_psy_levels ["Rho", "Pi", "Omicron", "Xi", "Nu", "Mu", "Lambda", "Kappa", "Iota", "Theta", "Eta", "Zeta", "Epsilon", "Delta", "Gamma", "Beta", "Alpha", "Alpha Plus", "Beta", "Gamma Plus"]
#macro ARR_negative_psy_levels ["Rho", "Sigma", "Tau", "Upsilon", "Phi", "Chi", "Psi", "Omega"]

global.base_stats = {
    //tempory stats subject to change by anyone that wishes to try their luck
    "chapter_master": {
        // TODO consider allowing the player to change the starting stats of the chapter master, and closest advisors, especially for custom chapters
        title: "Adeptus Astartes",
        strength: [42, 5],
        constitution: [44, 3],
        dexterity: [44, 3],
        weapon_skill: [50, 5, "max"],
        ballistic_skill: [50, 5, "max"],
        intelligence: [44, 3],
        wisdom: [44, 3],
        charisma: [40, 3],
        religion: "imperial_cult",
        piety: [30, 3],
        luck: 10,
        technology: [30, 3],
        base_group: "astartes",
    },
    "marine": {
        title: "Adeptus Astartes",
        strength: [40, 4],
        constitution: [40, 3],
        weapon_skill: [40, 5],
        ballistic_skill: [40, 5],
        dexterity: [40, 3],
        intelligence: [40, 3],
        wisdom: [40, 3],
        charisma: [30, 5],
        religion: "imperial_cult",
        piety: [30, 3],
        luck: 10,
        technology: [30, 3],
        skills: {
            weapons: {
                "bolter": 3,
                "chainsword": 3,
                "ccw": 3,
                "bolt_pistol": 3
            }
        },
        start_gear: {
            "armour": "Power Armour",
            "wep1": "Chainsword",
            "wep2": "Chainsword"
        },
        base_group: "astartes"
    },
    "scout": {
        title: "Adeptus Astartes",
        strength: [36, 4],
        constitution: [36, 3],
        weapon_skill: [30, 2, "max"],
        ballistic_skill: [30, 2, "max"],
        dexterity: [36, 3],
        intelligence: [38, 3],
        wisdom: [35, 3],
        charisma: [30, 5],
        religion: "imperial_cult",
        piety: [28, 3],
        luck: 10,
        technology: [28, 3],
        skills: {
            weapons: {
                "bolter": 3,
                "chainsword": 3,
                "ccw": 3,
                "bolt_pistol": 3
            }
        },
        start_gear: {
            "armour": "Power Armour",
            "wep1": "Bolter",
            "wep2": "Chainsword"
        }, // Scouts should probably have access only to scout armour, and perhaps some stuff from hirelings
        base_group: "astartes",
    },
    "dreadnought": {
        title: "Adeptus Astartes",
        strength: [70, 4],
        constitution: [75, 3],
        weapon_skill: [55, 5],
        ballistic_skill: [55, 5],
        dexterity: [30, 3],
        intelligence: [45, 3],
        wisdom: [50, 3],
        charisma: [35, 3],
        religion: "imperial_cult",
        piety: [32, 3],
        luck: 10,
        technology: [30, 3],
        skills: {
            weapons: {
                "bolter": 3,
                "chainsword": 3,
                "ccw": 3,
                "bolt_pistol": 3
            }
        },
        start_gear: {
            "armour": "Power Armour",
            "wep1": "Bolter",
            "wep2": "Chainsword"
        },
        base_group: "astartes",
        traits: ["ancient", "slow_and_purposeful", "lead_example", "zealous_faith", choose("still_standing", "beast_slayer", "lone_survivor")]
    },
    /* TODO - check and tweak if necessary
	"chapter_servitor":{
			title : "Chapter Servitor",
			strength:[36,4],
			constitution:[36,3],
			weapon_skill : [30,2,"max"],
			ballistic_skill : [30,2,"max"],
			dexterity:[36,3],
			intelligence:0,
			wisdom:0,
			charisma :[10,1],
			religion : "imperial_cult",
			piety : [28,3],
			luck : 10,
			technology :[30,3],
			skills: {weapons:{"Bolter":1, "Chainsword":1, "Combat Knife":1, "Bolt Pistol":1}},
			start_gear:{"armour":"power_armour", "wep1":"Combat Knife", "gear":"Servo-arm"}, TODO - tweak and check if correct
			base_group : "astartes",
			traits:["lobotomized"],
	},
	*/
    // TODO - add more hirelings on the imperial side...
    "skitarii": {
        title: "Skitarii",
        strength: [12, 1], // I don't think skitarii are particularly strong
        constitution: [15, 1],
        weapon_skill: [12, 1],
        ballistic_skill: [20, 1],
        dexterity: [25, 1],
        intelligence: [25, 1],
        wisdom: [10, 1], // Hm, no, very unwise...
        charisma: [5, 1], // Talking in binary does not help to make many friends
        religion: "cult_mechanicus",
        piety: [20, 1],
        luck: 10, // I don't see the point to make them less lucky than space marines
        technology: [30, 1],
        skills: {
            weapons: {
                "Hellgun": 1
            }
        },
        start_gear: {
            wep2: "",
            wep1: "Hellgun",
            armour: "Skitarii Armour",
            gear: "",
            mobi: ""
        },
        base_group: "skitarii",
    },
    "tech_priest": {
        title: "Tech Priest",
        strength: [15, 1],
        constitution: [30, 1],
        weapon_skill: [15, 1],
        ballistic_skill: [25, 3],
        dexterity: [25, 3],
        intelligence: [30, 3],
        wisdom: [20, 2],
        charisma: [30, 2], // Considering their voicelines in DoW:DC and SS, I'd say they can have charisma
        religion: "cult_mechanicus",
        piety: [45, 3],
        luck: 10,
        technology: [55, 3],
        skills: {
            weapons: {
                "Power Axe": 2,
                "Laspistol": 2,
                "Hellgun": 1
            }, // TODO - add skills for Servo-arm(m)
        },
        start_gear: {
            "armour": "Dragon Scales",
            "wep1": "Power Axe",
            "wep2": "Laspistol",
            "mobi": "Servo-arm"
        },
        base_group: "tech_priest",
    },
    "eldar_ranger": {
        // TODO rename this
        title: "Eldar Ranger", // TODO - that should be Eldar
        strength: [25, 1],
        constitution: [30, 2],
        weapon_skill: [45, 4],
        ballistic_skill: [45, 4],
        dexterity: [50, 5], // Dexterity should be eldar 'specialization'
        intelligence: [35, 3],
        wisdom: [50, 3],
        charisma: [20, 2], // Arrogance from cultural stuff, supposedly
        religion: "cult_mechanicus", // TODO - add eldar faith
        piety: [30, 5], // I think eldar rangers can be either - faithful to the path or more cynical
        luck: 10,
        technology: [20, 1], // Elves in most fiction tend to be kind of bad at technology, right?
        skills: {
            weapons: {
                "Ranger Long Rifle": 3,
                "Shuriken Pistol": 3,
                "Eldar Power Sword": 3
            }
        }, // TODO - check if these actually work
        start_gear: {
            "armour": "Ranger Armour",
            "wep1": "Ranger Long Rifle",
            "wep2": "Eldar Power Sword"
        }, // TODO - add Eldar Armour
        base_group: "skitarii", // Might want to rename this
    },
    "inquisition_crusader": {
        title: "Inquisition Crusader",
        strength: [10, 1], // 10 is considered standard for a chad-like Imperial Guardsman
        constitution: [10, 1],
        weapon_skill: [10, 1],
        ballistic_skill: [10, 1],
        dexterity: [10, 1],
        intelligence: [10, 1],
        wisdom: [12, 1], // They may know a bit more than average imperial
        charisma: [10, 1],
        religion: "imperial_cult",
        piety: [30, 5], // Supposedly, they can be radical or puritan...
        luck: 10,
        technology: [8, 1],
        skills: {}, // TODO consider what skills are needed for this bloke
        start_gear: {
            "armour": "Light Power Armour",
            "wep1": "Power Sword",
            "wep2": "Combat Shield"
        }, // TODO - add Light variant of Power Armour
        base_group: "human",
    },
    /* TODO - add psychic capabilities
	"sanctioned_psyker":{
			title: "Sanctioned Psyker",
	}
	*/
    "sister_of_battle": {
        title: "Sister of Battle",
        strength: [12, 1],
        constitution: [12, 1], // TODO - consider making it that hireling armour boosts constitution, and possibly other stats
        weapon_skill: [15, 1],
        ballistic_skill: [15, 1],
        dexterity: [22, 1],
        intelligence: [10, 1],
        wisdom: [10, 1],
        charisma: [10, 1],
        religion: "imperial_cult",
        piety: [50, 2], // Fanatics, for most part
        luck: 10,
        technology: [8, 1],
        skills: {
            weapons: {
                "Light Bolter": 1,
                "Bolt Pistol": 1,
                "Chainsword": 1,
                "Sarissa": 1
            }
        },
        start_gear: {
            "armour": "Sororitas Power Armour",
            "wep1": "Light Bolter",
            "wep2": ""
        },
        base_group: "human", // traits:["zealous_faith"],
    },
    "sister_hospitaler": {
        title: "Sister Hospitaler",
        strength: [11, 1],
        constitution: [12, 1], // TODO - consider making it that hireling armour boosts constitution
        weapon_skill: [13, 1],
        ballistic_skill: [13, 1],
        dexterity: [11, 1],
        intelligence: [12, 1],
        wisdom: [11, 1],
        charisma: [10, 1],
        religion: "imperial_cult",
        piety: [50, 2], // Fanatics, for most part
        luck: 10,
        technology: [12, 1], // They probably know a bit more, due to medical studies
        skills: {
            weapons: {
                "Light Bolter": 2,
                "Bolt Pistol": 2,
                "Chainsword": 2,
                "Sarissa": 2
            }
        },
        start_gear: {
            "armour": "Sororitas Power Armour",
            "wep1": "Light Bolter",
            "wep2": "",
            "gear": "Sororitas Medkit"
        },
        base_group: "human", // traits:["zealous_faith"],
    },
    "ork_sniper": {
        // I'm gonna make the stats basically the same as the shoota boy in the stat calculator
        title: "Ork Sniper",
        strength: [20, 2],
        constitution: [20, 2],
        weapon_skill: [9, 1],
        ballistic_skill: [20, 2],
        dexterity: [6, 1],
        intelligence: [10, 1],
        wisdom: [10, 1],
        charisma: [10, 1],
        religion: "gorkamorka",
        piety: [20, 2], // I'm not sure how would one even properly value this... how attached the ork is to the WAAAGH energy field?
        luck: 10,
        technology: [20, 2],
        skills: {
            weapons: {
                "Sniper Rifle": 1,
                "Choppa": 1
            }
        },
        start_gear: {
            "armour": "Ork Armour",
            "wep1": "Sniper Rifle",
            "wep2": "Choppa"
        },
        base_group: "ork",
    },
    "flash_git": {
        // For this one, Big shoota ork will be used
        title: "Flash Git",
        strength: [40, 3],
        constitution: [40, 3],
        weapon_skill: [25, 2],
        ballistic_skill: [40, 3],
        dexterity: [8, 1],
        intelligence: [20, 2],
        wisdom: [20, 2],
        charisma: [14, 1],
        religion: "gorkamorka",
        piety: [20, 2],
        luck: 10,
        technology: [30, 3],
        skills: {
            weapons: {
                "Sniper Rifle": 1,
                "Snazzgun": 2,
                "Choppa": 2
            }
        },
        start_gear: {
            "armour": "Ork Armour",
            "wep1": "Snazzgun",
            "wep2": "Choppa"
        }, // Consider giving a "Power Klaw" instead of Choppa, and better armour
        base_group: "ork",
    }, // TODO - add more hireling types
};

function TTRPG_stats(faction, comp, mar, class = "marine", other_spawn_data = {}) constructor {
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
    size = 0;
    planet_location = 0;
    if (!instance_exists(obj_controller) && class != "blank") {
        //game start unit planet location
        planet_location = obj_ini.home_planet;
    }
    ship_location = -1;
    last_ship = {
        uid: "",
        name: ""
    };
    religion = "none";
    master_loyalty = 0;
    job = "none";
    psionic = 0;
    corruption = 0;
    religion_sub_cult = "none";
    base_group = "none";
    role_history = [];
    enum eROLE_TAG {
        Techmarine = 0,
            Librarian = 1,
            Chaplain = 2,
            Apothecary = 3,
    }
    role_tag = [0, 0, 0, 0]; // [Techmarine, Librarian, Chaplain, Apothecary] // maybe add to list instead?
    encumbered_ranged = false;
    encumbered_melee = false;
    home_world = "";
    company = comp; //marine company
    marine_number = mar; //marine number in company
    squad = "none";
    stat_point_exp_marker = 0;
    bionics = 0;
    favorite = false;
    spawn_data = other_spawn_data;
    unit_health = 0;
    if (faction == "chapter" && !struct_exists(spawn_data, "recruit_data")) {
        spawn_data.recruit_data = {
            recruit_world: obj_ini.recruiting_type,
            aspirant_trial: obj_ini.recruit_trial
        };
    }
    experience = 0;
    turn_stat_gains = {};
    powers_known = [];

    static set_exp = function(new_val) {
        experience = new_val;
        var _powers_learned = 0;

        if (IsSpecialist(SPECIALISTS_LIBRARIANS)) {
            _powers_learned = update_powers();
        }

        // 0 is returned to have the same return format as in add_exp, to avoid confusion;
        return [0, _powers_learned];
    }; //change exp

    static handle_stat_growth = unit_stat_growth;

    static add_exp = add_unit_exp;

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
            if (struct_exists(obj_ini.squad_types[$ obj_ini.squads[squad].type], temp_role)) {
                var role_info = obj_ini.squad_types[$ obj_ini.squads[squad].type][$ temp_role];
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
                    stat_boosts({
                        strength: 4,
                        constitution: 4,
                        dexterity: 4
                    }); //will decide on if these are needed
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
            var dread_weapons = ["Close Combat Weapon", "Force Staff", "Twin Linked Lascannon", "Assault Cannon", "Missile Launcher", "Plasma Cannon", "Multi-Melta", "Twin Linked Heavy Bolter"];

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
        var sz = 0;
        sz = 1;
        var bulky_armour = ["Terminator Armour", "Tartaros"];
        if (string_count("Dread", arm) > 0) {
            sz += 5;
        } else if (array_contains(bulky_armour, arm)) {
            sz += 1;
        }
        //var mobi =  mobility_item();
        /*if (mobi == "Jump Pack"){
			sz++;
		}*/
        if (unit_role == "Chapter Master") {
            sz++;
        }
        size = sz;
        return size;
    };

    mobility_item_quality = "standard";
    armour_quality = "standard";

    //Unit update equip slot functions held in sscr_unit_equip_functions
    static update_armour = scr_update_unit_armour;
    static update_weapon_one = scr_update_unit_weapon_one;
    static update_weapon_two = scr_update_unit_weapon_two;
    static update_gear = scr_update_unit_gear;
    static update_mobility_item = scr_update_unit_mobility_item;

    static max_health = function(base = false) {
        var max_h = 100 * (1 + ((constitution - 40) * 0.025));
        if (!base) {
            max_h += gear_weapon_data("armour", armour(), "hp_mod");
            max_h += gear_weapon_data("gear", gear(), "hp_mod");
            max_h += gear_weapon_data("mobility", mobility_item(), "hp_mod");
            max_h += gear_weapon_data("weapon", weapon_one(), "hp_mod");
            max_h += gear_weapon_data("weapon", weapon_two(), "hp_mod");
        }
        return max_h;
    };

    static increase_max_health = function(increase) {
        return max_health() + (increase * (1 + ((constitution - 40) * 0.025))); //calculate the effect of unit_health buffs
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
            handle_exception(_exception);
        }
    };

    traits = []; //marine trait list
    feats = [];
    allegiance = faction; //faction alligience defaults to the chapter

    static stat_boosts = function(stat_boosters) {
        var stats = ARR_stat_list;
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
    static add_trait = function(trait) {
        var balance_value;
        if (struct_exists(global.trait_list, trait)) {
            if (!array_contains(traits, trait)) {
                var selec_trait = global.trait_list[$ trait];
                stat_boosts(selec_trait);
                array_push(traits, trait);
            }
        }
    };

    static has_trait = marine_has_trait;

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

    static unit_equipment_data = function() {
        var armour_data = get_armour_data();
        var gear_data = get_gear_data();
        var mobility_data = get_mobility_data();
        var weapon_one_data = get_weapon_one_data();
        var weapon_two_data = get_weapon_two_data();
        var equip_data = {
            armour_data: armour_data,
            gear_data: gear_data,
            mobility_data: mobility_data,
            weapon_one_data: weapon_one_data,
            weapon_two_data: weapon_two_data
        };
        return equip_data;
    };

    //takes dict and plumbs dict values into unit struct
    if (array_contains(variable_struct_get_names(global.base_stats), class)) {
        load_json_data(global.base_stats[$ class]);
    }
    var edit_stat, stat_mod;
    var stats = ["constitution", "strength", "luck", "dexterity", "wisdom", "piety", "charisma", "technology", "intelligence", "weapon_skill", "ballistic_skill"];
    for (var stat_iter = 0; stat_iter < array_length(stats); stat_iter++) {
        if (struct_exists(self, stats[stat_iter])) {
            if (is_array(variable_struct_get(self, stats[stat_iter]))) {
                edit_stat = variable_struct_get(self, stats[stat_iter]);
                stat_mod = floor(gauss(edit_stat[0], edit_stat[1]));
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
    body = generate_marine_body();

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

    if (struct_exists(self, "start_gear")) {
        if (base_group != "marine") {
            alter_equipment(start_gear, false, false);
        } else {
            alter_equipment(start_gear, true, true);
        }
    }

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
        return burden;
    };

    /*ey so i got this concept where basically take away luck, ballistic_skill and weapon_skill 
	there are 8 other stats each of which will have more attached aspects and game play elements 
	they effect as time goes on, so that means between the 8 other stats if you had a choice of two 
	there are 64 (or 56 if you exclude double counts) variations of a choice of two, this means each 
	chapter could have two "values" maybe in terms of recruitment maybe in terms of just general chapter stuff. 
	that could be chosen to give boostes to the other stats
	so as an example salamanders could have the chapter values as  */
    loyalty = 0;
    switch (base_group) {
        case "astartes": //basic marine class //adds specific mechanics not releveant to most units
            loyalty = 100;

            var _astartes_trait_dist = global.astartes_trait_dist;
            distribute_traits(_astartes_trait_dist);

            if (instance_exists(obj_controller)) {
                role_history = [
                    [obj_ini.role[company][marine_number], obj_controller.turn]
                ]; //marines_promotion and demotion history
                marine_ascension = (obj_controller.millenium * 1000) + obj_controller.year; // on what day did this marine begin to exist
            } else {
                role_history = [
                    [obj_ini.role[company][marine_number], "pre_game"]
                ];
                marine_ascension = "pre_game"; // on what day did turn did this marine begin to exist
            }

            roll_psionics();

            alter_body("torso", "black_carapace", true);
            if (class == "scout" && global.chapter_name != "Space Wolves") {
                alter_body("torso", "black_carapace", false);
            }
            if (faction == "chapter") {
                allegiance = global.chapter_name;
            }

            assign_inherent_mutations();
            assign_random_mutations();

            if (gene_seed_mutations[$ "voice"] == 1) {
                charisma -= 2;
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
                    "voice": obj_ini.voice
                };
            };

            static assign_random_mutations = function() {
                var _mutation_roll = roll_personal_dice(1, 100, "high", self);
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
                    repeat(array_length(_possible_mutations)) {
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

            //array index 0 == trait to add
            // array index 1 == probability e.g 99,98 == if (irandom(99)>98){add_trait}
            // array index 3 == probability modifiers

            if ((global.chapter_name == "Space Wolves") || (obj_ini.progenitor == ePROGENITOR.SPACE_WOLVES)) {
                religion_sub_cult = "The Allfather";
            } else if ((global.chapter_name == "Salamanders") || (obj_ini.progenitor == ePROGENITOR.SALAMANDERS)) {
                religion_sub_cult = "The Promethean Cult";
            } else if (global.chapter_name == "Iron Hands" || obj_ini.progenitor == ePROGENITOR.IRON_HANDS) {
                religion_sub_cult = "The Cult of Iron";
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
            if (role() == obj_ini.role[100][eROLE.Chaplain]) {
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
            loyalty = obj_controller.disposition[eFACTION.Mechanicus] - 10;
            religeon = "cult_mechanicus";
            bionics = irandom(5) + 4;
            add_trait("flesh_is_weak");
            psionic = irandom(4);
            break;
    }

    static race = function() {
        return obj_ini.race[company][marine_number];
    }; //get race

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

    static add_bionics = function(area = "none", bionic_quality = "any", from_armoury = true) {
        if (from_armoury && scr_item_count("Bionics", bionic_quality) < 1) {
            return "no bionics";
        } else if (from_armoury) {
            remove_quality = scr_add_item("Bionics", -1, bionic_quality);
        } else {
            remove_quality = choose("standard", "standard", "standard", "standard", "standard", "master_crafted", "artifact");
        }
        var new_bionic_pos, part, new_bionic = {
            quality: scr_add_item
        };
        if (bionics < 10) {
            if (has_trait("flesh_is_weak")) {
                add_or_sub_health(40);
            } else {
                add_or_sub_health(30);
            }
            var bionic_possible = [];
            var _body_parts = ARR_body_parts;
            for (var body_part = 0; body_part < array_length(_body_parts); body_part++) {
                part = _body_parts[body_part];
                if (!get_body_data("bionic", part)) {
                    array_push(bionic_possible, part);
                }
            }
            if (array_length(bionic_possible) > 0) {
                if (area != "none") {
                    if (array_contains(bionic_possible, area)) {
                        new_bionic_pos = area;
                    } else {
                        return 0;
                    }
                } else {
                    new_bionic_pos = bionic_possible[irandom(array_length(bionic_possible) - 1)];
                }
                bionics++;
                alter_body(new_bionic_pos, "bionic", new_bionic);
                if (array_contains(["left_leg", "right_leg"], new_bionic_pos)) {
                    constitution += 2;
                    strength++;
                    dexterity -= 2;
                    body[$ new_bionic_pos][$ "bionic"].variant = irandom(100);
                } else if (array_contains(["left_eye", "right_eye"], new_bionic_pos)) {
                    body[$ new_bionic_pos][$ "bionic"].variant = irandom(100);
                    constitution += 1;
                    wisdom += 1;
                    dexterity++;
                } else if (array_contains(["left_arm", "right_arm"], new_bionic_pos)) {
                    body[$ new_bionic_pos][$ "bionic"].variant = irandom(100);
                    constitution += 2;
                    strength += 2;
                    weapon_skill--;
                } else if (new_bionic_pos == "torso") {
                    constitution += 4;
                    strength++;
                    dexterity--;
                } else if (new_bionic_pos == "throat") {
                    charisma--;
                } else {
                    constitution++;
                }
                if (has_trait("flesh_is_weak")) {
                    piety++;
                }
            }
            if (hp() > max_health()) {
                update_health(max_health());
            }
        }
    };

    static age = function() {
        var real_age = obj_ini.age[company][marine_number];
        return real_age;
    }; // age

    static update_age = function(new_val) {
        obj_ini.age[company][marine_number] = new_val;
    };

    static name = function() {
        return obj_ini.name[company][marine_number];
    }; // get marine name

    static gear = function(raw = false) {
        var wep = obj_ini.gear[company][marine_number];
        if (is_string(wep) || raw) {
            return wep;
        }
        return obj_ini.artifact[wep];
    };

    is_boarder = false;

    gear_quality = "standard";
    static update_gear = scr_update_unit_gear;

    if (base_group != "none") {
        update_health(max_health()); //set marine unit_health to max
    }

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

    weapon_one_data = {
        quality: "standard"
    };
    weapon_one_quality = "standard";

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
                return [false, "no_items"];
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
        return [viable, qual_string];
    };

    static weapon_two = function(raw = false) {
        var wep = obj_ini.wep2[company][marine_number];
        if (is_string(wep) || raw) {
            return wep;
        }
        return obj_ini.artifact[wep];
    };

    weapon_two_quality = "standard";

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
                obj_ini.spe[company, marine_number] += string(_discipline_prefix) + string(_power_index) + "|";
                array_push(powers_known, _discipline_powers[_power_index]);
            }
        }

		return _powers_learned;
	};

    static roll_psionics = function() {
        var _dice_count = marine_ascension == "pre_game" ? 1 : 2;
        var _psionics_roll = roll_dice(_dice_count, 100);

        if (scr_has_adv("Warp Touched")) {
            if (_psionics_roll < 170) {
                var _second_roll = roll_personal_dice(_dice_count, 100, "high", self);
                _psionics_roll = _second_roll > _psionics_roll ? _second_roll : _psionics_roll;
            }
        } else if (scr_has_disadv("Psyker Intolerant")) {
            if (_psionics_roll >= 170) {
                var _second_roll = roll_personal_dice(_dice_count, 100, "low", self);
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
            update_role(obj_ini.role[100][eROLE.Librarian]);
        }
    };

    static race = function() {
        return obj_ini.race[company][marine_number];
    };

    //get equipment data methods by deafult they garb all equipment data and return an equipment struct e.g new EquipmentStruct(item_data, core_type,quality="none")
    static get_armour_data = function(type = "all") {
        return gear_weapon_data("armour", armour(), type, false, armour_quality);
    };

    static get_gear_data = function(type = "all") {
        return gear_weapon_data("gear", gear(), type, false, gear_quality);
    };

    static get_mobility_data = function(type = "all") {
        return gear_weapon_data("mobility", mobility_item(), type, false, mobility_item_quality);
    };

    static get_weapon_one_data = function(type = "all") {
        return gear_weapon_data("weapon", weapon_one(), type, false, weapon_one_quality);
    };

    static get_weapon_two_data = function(type = "all") {
        return gear_weapon_data("weapon", weapon_two(), type, false, weapon_two_quality);
    };

    static damage_resistance = function() {
        damage_res = 0;
        damage_res += get_armour_data("damage_resistance_mod");
        damage_res += get_gear_data("damage_resistance_mod");
        damage_res += get_mobility_data("damage_resistance_mod");
        damage_res += get_weapon_one_data("damage_resistance_mod");
        damage_res += get_weapon_two_data("damage_resistance_mod");
        damage_res = min(75, damage_res + floor(((constitution * 0.005) + (experience / 1000)) * 100));
        return damage_res;
    };

    static ranged_hands_limit = function() {
        var ranged_carrying = 0;
        var carry_string = "";
        var ranged_hands_limit = 2;

        var wep_one_carry = get_weapon_one_data("ranged_hands");
        if (wep_one_carry != 0) {
            ranged_carrying += wep_one_carry;
            carry_string += $"{weapon_one()}: {wep_one_carry}#";
        }
        var wep_two_carry = get_weapon_two_data("ranged_hands");
        if (wep_two_carry != 0) {
            ranged_carrying += wep_two_carry;
            carry_string += $"{weapon_two()}: {wep_two_carry}#";
        }
        if (ranged_carrying != 0) {
            carry_string = $"    =Carrying=#" + carry_string;
        }

        carry_string += $"    =Maximum=#";
        if (base_group == "astartes") {
            ranged_hands_limit = 2;
        } else if (base_group == "tech_priest") {
            ranged_hands_limit = 1 + (technology / 100);
        } else if (base_group == "human") {
            ranged_hands_limit = 1;
        }
        carry_string += $"Base: {ranged_hands_limit}#";
        if (strength >= 50) {
            ranged_hands_limit += 0.5;
            carry_string += "STR: +0.5#";
        }
        if (ballistic_skill >= 50) {
            ranged_hands_limit += 0.25;
            carry_string += "BS: +0.25#";
        }
        var armour_carry = get_armour_data("ranged_hands");
        if (armour_carry != 0) {
            ranged_hands_limit += armour_carry;
            carry_string += $"{armour()}: {format_number_with_sign(armour_carry)}#";
        }
        var gear_carry = get_gear_data("ranged_hands");
        if (gear_carry != 0) {
            ranged_hands_limit += gear_carry;
            carry_string += $"{gear()}: {format_number_with_sign(gear_carry)}#";
        }
        var mobility_carry = get_mobility_data("ranged_hands");
        if (mobility_carry != 0) {
            ranged_hands_limit += mobility_carry;
            carry_string += $"{mobility_item()}: {format_number_with_sign(mobility_carry)}#";
        }
        return [ranged_carrying, ranged_hands_limit, carry_string];
    };

    static ranged_attack = function(weapon_slot = 0) {
        encumbered_ranged = false;
        //base modifyer based on unit skill set
        ranged_att = 100 * ((ballistic_skill / 50) + (dexterity / 400) + (experience / 500));
        var final_range_attack = 0;
        var explanation_string = $"Stat Mod: x{ranged_att / 100}#  BS: x{ballistic_skill / 50}#  DEX: x{dexterity / 400}#  EXP: x{experience / 500}#";
        //determine capavbility to weild bulky weapons
        var carry_data = ranged_hands_limit();

        //base multiplyer
        var range_multiplyer = 1;

        //grab generic structs for weapons
        var _wep1 = get_weapon_one_data();
        var _wep2 = get_weapon_two_data();

        if (!is_struct(_wep1)) {
            _wep1 = new EquipmentStruct({}, "");
        }
        if (!is_struct(_wep2)) {
            _wep2 = new EquipmentStruct({}, "");
        }
        if (allegiance == global.chapter_name) {
            _wep1.owner_data("chapter");
            _wep2.owner_data("chapter");
        }
        var primary_weapon = new EquipmentStruct({}, "");
        var secondary_weapon = new EquipmentStruct({}, "");
        if (carry_data[0] > carry_data[1]) {
            encumbered_ranged = true;
            ranged_att *= 0.6;
            explanation_string += $"Encumbered:X0.6#";
        }
        if (weapon_slot == 0) {
            //decide if any weapons are ranged
            if (_wep1.range < 1.1 && _wep2.range < 1.1) {
                if (array_length(_wep1.second_profiles) + array_length(_wep2.second_profiles) == 0) {
                    ranged_damage_data = [final_range_attack, explanation_string, carry_data, primary_weapon, secondary_weapon];
                } else {
                    var other_profiles = array_concat(_wep1.second_profiles, _wep2.second_profiles);
                    for (var sec = 0; sec < array_length(other_profiles); sec++) {
                        var sec_profile = gear_weapon_data("weapon", other_profiles[sec], "all", false, weapon_one_quality);
                        if (is_struct(sec_profile)) {
                            if (sec_profile.range > 1.1 && sec_profile.attack > 0) {
                                final_range_attack += sec_profile.attack * (ranged_att / 100);
                                explanation_string += $"{sec_profile.name} +{sec_profile.attack}#";
                            }
                        }
                    }
                    if (array_length(_wep1.second_profiles) > 0) {
                        primary_weapon = gear_weapon_data("weapon", _wep1.second_profiles[0], "all", false, weapon_one_quality);
                    }
                    if (array_length(_wep2.second_profiles) > 0) {
                        primary_weapon = gear_weapon_data("weapon", _wep2.second_profiles[0], "all", false, weapon_two_quality);
                    }
                    ranged_damage_data = [final_range_attack, explanation_string, carry_data, primary_weapon, secondary_weapon];
                }
                return ranged_damage_data;
            } else {
                if (_wep1.range <= 1.1) {
                    primary_weapon = _wep2;
                } else if (_wep2.range <= 1.1) {
                    primary_weapon = _wep1;
                } else {
                    //if both weapons are ranged pick best
                    if (_wep1.attack > _wep2.attack) {
                        primary_weapon = _wep1;
                        secondary_weapon = _wep2;
                    } else {
                        secondary_weapon = _wep1;
                        primary_weapon = _wep2;
                    }
                }
            }
        } else {
            if (weapon_slot == 1) {
                primary_weapon = _wep1;
            } else if (weapon_slot == 2) {
                primary_weapon = _wep2;
            }
        }
        //calculate chapter specific bonus
        if (allegiance == global.chapter_name) {
            //calculate player specific bonuses
            if (primary_weapon.has_tag("bolt")) {
                if (scr_has_adv("Bolter Drilling") && base_group == "astartes") {
                    range_multiplyer += 0.15;
                    explanation_string += $"Bolter Drilling:X1.15#";
                }
            }
            if (primary_weapon.has_tag("energy")) {
                if (scr_has_adv("Ryzan Patronage") && base_group == "astartes") {
                    range_multiplyer += 0.15;
                    explanation_string += $"Ryzan Craftsmanship:X1.15#";
                }
            }
            if (primary_weapon.has_tag("heavy_ranged")) {
                if (scr_has_adv("Devastator Doctrine") && base_group == "astartes") {
                    range_multiplyer += 0.15;
                    explanation_string += $"Devastator Doctrine:X1.15#";
                }
            }
        }
        if (!encumbered_ranged) {
            var total_gear_mod = 0;
            total_gear_mod += get_armour_data("ranged_mod");
            total_gear_mod += get_gear_data("ranged_mod");
            total_gear_mod += get_mobility_data("ranged_mod");
            total_gear_mod += _wep1.ranged_mod;
            total_gear_mod += _wep2.ranged_mod;
            ranged_att += total_gear_mod;
            explanation_string += $"Gear Mod: x{(total_gear_mod / 100) + 1}#";
            if (has_trait("feet_floor") && mobility_item() != "") {
                ranged_att *= 0.9;
                explanation_string += $"{global.trait_list.feet_floor.display_name}:X0.9#";
            }
        }
        //return final ranged damage output
        final_range_attack = floor((ranged_att / 100) * primary_weapon.attack);
        explanation_string = $"{primary_weapon.name}: {primary_weapon.attack}#" + explanation_string;
        if (!encumbered_ranged) {
            if (primary_weapon.has_tag("pistol") && secondary_weapon.has_tag("pistol")) {
                final_range_attack += floor((ranged_att / 100) * secondary_weapon.attack);
                explanation_string += $"Dual Pistols: +{secondary_weapon.attack}#";
            } else if (secondary_weapon.attack > 0) {
                var second_attack = floor((ranged_att / 100) * secondary_weapon.attack) * 0.5;
                final_range_attack += second_attack;
                explanation_string += $"Secondary: +{second_attack}#";
            }
        }
        ranged_damage_data = [final_range_attack, explanation_string, carry_data, primary_weapon, secondary_weapon];
        return ranged_damage_data;
    };

    static melee_hands_limit = function() {
        var melee_carrying = 0;
        var carry_string = "";
        var melee_hands_limit = 2;

        var wep_one_carry = get_weapon_one_data("melee_hands");
        if (wep_one_carry != 0) {
            melee_carrying += wep_one_carry;
            carry_string += $"{weapon_one()}: {wep_one_carry}#";
        }
        var wep_two_carry = get_weapon_two_data("melee_hands");
        if (wep_two_carry != 0) {
            melee_carrying += wep_two_carry;
            carry_string += $"{weapon_two()}: {wep_two_carry}#";
        }
        if (melee_carrying != 0) {
            carry_string = $"    =Carrying=#" + carry_string;
        }

        carry_string += $"    =Maximum=#";
        if (base_group == "astartes") {
            melee_hands_limit = 2;
        } else if (base_group == "tech_priest") {
            melee_hands_limit = 1 + (technology / 100);
        } else if (base_group == "human") {
            melee_hands_limit = 1;
        }
        carry_string += "Base: 2#";
        if (strength >= 50) {
            melee_hands_limit += 0.25;
            carry_string += "STR: +0.25#";
        }
        if (weapon_skill >= 50) {
            melee_hands_limit += 0.25;
            carry_string += "WS: +0.25#";
        }
        if (has_trait("champion")) {
            melee_hands_limit += 0.25;
            carry_string += "Champion: +0.25#";
        }
        var armour_carry = get_armour_data("melee_hands");
        if (armour_carry != 0) {
            melee_hands_limit += armour_carry;
            carry_string += $"{armour()}: {format_number_with_sign(armour_carry)}#";
        }
        var gear_carry = get_gear_data("melee_hands");
        if (gear_carry != 0) {
            melee_hands_limit += gear_carry;
            carry_string += $"{gear()}: {format_number_with_sign(gear_carry)}#";
        }
        var mobility_carry = get_mobility_data("melee_hands");
        if (mobility_carry != 0) {
            melee_hands_limit += mobility_carry;
            carry_string += $"{mobility_item()}: {format_number_with_sign(mobility_carry)}#";
        }
        return [melee_carrying, melee_hands_limit, carry_string];
    };

    static melee_attack = function(weapon_slot = 0) {
        encumbered_melee = false;
        melee_att = 100 * (((weapon_skill / 100) * (strength / 20)) + (experience / 1000) + 0.1);
        var explanation_string = string_concat("#Stats: ", format_number_with_sign(round(((melee_att / 100) - 1) * 100)), "%#");
        explanation_string += "  Base: +10%#";
        explanation_string += string_concat("  WSxSTR: ", format_number_with_sign(round((((weapon_skill / 100) * (strength / 20)) - 1) * 100)), "%#");
        explanation_string += string_concat("  EXP: ", format_number_with_sign(round((experience / 1000) * 100)), "%#");

        melee_carrying = melee_hands_limit();
        var _wep1 = get_weapon_one_data();
        var _wep2 = get_weapon_two_data();
        if (!is_struct(_wep1)) {
            _wep1 = new EquipmentStruct({}, "");
        }
        if (!is_struct(_wep2)) {
            _wep2 = new EquipmentStruct({}, "");
        }
        if (allegiance == global.chapter_name) {
            _wep1.owner_data("chapter");
            _wep2.owner_data("chapter");
        }
        var primary_weapon;
        var secondary_weapon = "none";
        if (weapon_slot == 0) {
            //if player has not melee weapons
            var valid1 = (_wep1.range <= 1.1 && _wep1.range != 0) || _wep1.has_tags(["pistol", "flame"]);
            var valid2 = (_wep2.range <= 1.1 && _wep2.range != 0) || _wep2.has_tags(["pistol", "flame"]);
            if (!valid1 && !valid2) {
                primary_weapon = new EquipmentStruct({}, ""); //create blank weapon struct
                primary_weapon.attack = strength / 3; //calculate damage from player fists
                primary_weapon.name = "fists";
                primary_weapon.range = 1;
                primary_weapon.ammo = -1;
            } else {
                if (!valid1 && valid2) {
                    primary_weapon = _wep2;
                } else if (valid1 && !valid2) {
                    primary_weapon = _wep1;
                } else {
                    var highest = _wep1.attack > _wep2.attack ? _wep1 : _wep2;
                    var lowest = _wep1.attack <= _wep2.attack ? _wep1 : _wep2;
                    if (!highest.has_tags(["pistol", "flame"])) {
                        primary_weapon = highest;
                        secondary_weapon = lowest;
                    } else if (!lowest.has_tags(["pistol", "flame"])) {
                        primary_weapon = lowest;
                        secondary_weapon = highest;
                    } else {
                        primary_weapon = highest;
                        melee_att *= 0.5;
                        if (primary_weapon.has_tag("flame")) {
                            explanation_string += $"Primary is Flame: -50%#";
                        } else if (primary_weapon.has_tag("pistol")) {
                            explanation_string += $"Primary is Pistol: -50%#";
                        }
                        secondary_weapon = lowest;
                    }
                }
            }
        } else {
            if (weapon_slot == 1) {
                primary_weapon = _wep1;
            } else if (weapon_slot == 2) {
                primary_weapon = _wep2;
            }
        }

        var basic_wep_string = $"{primary_weapon.name}: {primary_weapon.attack}#";

        if (psionic > 0) {
            if (has_force_weapon()) {
                var psychic_bonus = psionic * 20;
                psychic_bonus *= 0.5 + (wisdom / 100);
                psychic_bonus *= 0.5 + (experience / 100);
                psychic_bonus *= IsSpecialist(SPECIALISTS_LIBRARIANS) ? 1 : 0.25;
                psychic_bonus = round(psychic_bonus);
                primary_weapon.attack += psychic_bonus;
                basic_wep_string += $"Psychic Power: +{psychic_bonus}#";
            }
        }

        explanation_string = basic_wep_string + explanation_string;

        if (melee_carrying[0] > melee_carrying[1]) {
            encumbered_melee = true;
            melee_att *= 0.6;
            explanation_string += $"Encumbered: x0.6#";
        }
        if (!encumbered_melee) {
            var total_gear_mod = 0;
            total_gear_mod += get_armour_data("melee_mod");
            total_gear_mod += get_gear_data("melee_mod");
            total_gear_mod += get_mobility_data("melee_mod");
            total_gear_mod += _wep1.melee_mod;
            total_gear_mod += _wep2.melee_mod;
            melee_att += total_gear_mod;
            explanation_string += $"#Gear Mod: {(total_gear_mod / 100) * 100}%#";
            //TODO make trait data like this more structured to be able to be moddable
            if (has_trait("feet_floor") && mobility_item() != "") {
                melee_att *= 0.9;
                explanation_string += $"{global.trait_list.feet_floor.display_name}: x0.9#";
            }
            if (primary_weapon.has_tag("fist") && has_trait("brawler")) {
                melee_att *= 1.1;
                explanation_string += $"{global.trait_list.brawler.display_name}: x1.1#";
            }
            if (primary_weapon.has_tag("power") && has_trait("duelist")) {
                melee_att *= 1.3;
                explanation_string += $"{global.trait_list.duelist.display_name}: x1.3#";
            }
        }
        var final_attack = floor((melee_att / 100) * primary_weapon.attack);
        if (secondary_weapon != "none" && !encumbered_melee) {
            var side_arm_data = "Standard: x0.5";
            var secondary_modifier = 0.5;
            if (primary_weapon.has_tag("dual") && secondary_weapon.has_tag("dual")) {
                secondary_modifier = 1;
                side_arm_data = "Dual: x1";
            } else if (secondary_weapon.has_tag("pistol")) {
                if (melee_carrying[0] + 0.8 >= melee_carrying[1]) {
                    secondary_modifier = 0;
                } else {
                    secondary_modifier = 0.6;
                    side_arm_data = "Pistol: x0.8";
                }
            } else if (secondary_weapon.has_tag("flame")) {
                secondary_modifier = 0.3;
                side_arm_data = "Flame: x0.3";
            }
            var side_arm = floor(secondary_modifier * ((melee_att / 100) * secondary_weapon.attack));
            if (side_arm > 0) {
                final_attack += side_arm;
                explanation_string += $"Side Arm: +{side_arm}({side_arm_data})#";
            }
        }
        melee_damage_data = [final_attack, explanation_string, melee_carrying, primary_weapon, secondary_weapon];
        return melee_damage_data;
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
    static hammer_of_wrath = function() {
        var _melee_attack = melee_damage_data[0];
        var _melee_weapon = melee_damage_data[3];

        var wrath = new EquipmentStruct({
            attack: _melee_attack * 0.75,
            name: "Hammer of Wrath",
            range: 2,
            ammo: 6,
            spli: _melee_weapon.spli,
            arp: _melee_weapon.arp
        }, "weapon");

        var wrath_melee = new EquipmentStruct({
            attack: _melee_attack * 1.25,
            name: "Hammer of Wrath(M)",
            range: 1,
            ammo: 8,
            spli: _melee_weapon.spli,
            arp: _melee_weapon.arp
        }, "weapon");

        wrath.second_profiles = [wrath_melee];

        return wrath;
    };

    static armour_calc = function() {
        armour_rating = 0;
        armour_rating += get_armour_data("armour_value");
        armour_rating += get_weapon_one_data("armour_value");
        armour_rating += get_mobility_data("armour_value");
        armour_rating += get_gear_data("armour_value");
        armour_rating += get_weapon_two_data("armour_value");
        if (armour() != "" && allegiance == global.chapter_name) {
            // STC Bonuses
            if (obj_controller.stc_bonus[1] == 5) {
                armour_rating *= 1.05;
            }
            if (obj_controller.stc_bonus[2] == 3) {
                armour_rating *= 1.05;
            }
        }
        return armour_rating;
    };

    static assignment = function() {
        if (squad != "none") {
            if (obj_ini.squads[squad].assignment != "none") {
                return obj_ini.squads[squad].assignment.type;
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
            if (squad < array_length(obj_ini.squads)) {
                for (var r = 0; r < array_length(obj_ini.squads[squad].members); r++) {
                    squad_member = obj_ini.squads[squad].members[r];
                    if ((squad_member[0] == company) && (squad_member[1] == marine_number)) {
                        array_delete(obj_ini.squads[squad].members, r, 1);
                    }
                }
            }
            squad = "none";
        }
    };

    static squad_type = function() {
        var _type = "none";
        if (squad != "none") {
            if (squad < array_length(obj_ini.squads)) {
                return obj_ini.squads[squad].type;
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
        var _squad = fetch_squad(squad);
        _squad.add_member(company, marine_number);
    };

    static marine_location = function() {
        var location_id, location_name;
        var location_type = planet_location;
        if (location_type > 0) {
            //if marine is on planet
            location_id = location_type; //planet_number marine is on
            location_type = location_types.planet; //state marine is on planet
            if (obj_ini.loc[company][marine_number] == "home") {
                obj_ini.loc[company][marine_number] = obj_ini.home_name;
            }
            location_name = obj_ini.loc[company][marine_number]; //system marine is in
        } else {
            location_type = location_types.ship; //marine is on ship
            location_id = ship_location; //ship array position
            if (location_id < array_length(obj_ini.ship_location)) {
                location_name = obj_ini.ship_location[location_id]; //location of ship
            } else {
                location_name = location_name == obj_ini.loc[company][marine_number];
            }
        }
        return [location_type, location_id, location_name];
    };

    //quick way of getting name and role combined in string
    static name_role = function() {
        var temp_role = role();
        if (squad != "none") {
            if (struct_exists(obj_ini.squad_types[$ obj_ini.squads[squad].type], temp_role)) {
                var role_info = obj_ini.squad_types[$ obj_ini.squads[squad].type][$ temp_role];
                if (struct_exists(role_info, "role")) {
                    temp_role = role_info[$ "role"];
                }
            }
        }
        return string("{0} {1}", temp_role, name());
    };

    static full_title = function() {
        return $"{squad_role()} of the {company_roman} Company";
    };

    static company_roman = function() {
        return $"{scr_roman_numerals()[company - 1]}";
    };

    static load_marine = function(ship, star = "none") {
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

        if (current_location[0] == location_types.planet) {
            //if marine is on a planet
            if (current_location[2] == "home") {
                system = obj_ini.home_name;
            }
            //check if ship is in the same location as marine and has enough space;
            if ((target_ship_location == system) && ((obj_ini.ship_carrying[ship] + size) <= obj_ini.ship_capacity[ship])) {
                planet_location = 0; //mark marine as no longer on planet
                ship_location = ship; //id of ship marine is now loaded on
                obj_ini.ship_carrying[ship] += size; //update ship capacity

                if (star == "none") {
                    star = star_by_name(system);
                }
                if (star != "none") {
                    if (star.p_player[current_location[1]] > 0) {
                        star.p_player[current_location[1]] -= size;
                    }
                }
            }
        } else if (current_location[0] == location_types.ship) {
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
                name: ""
            };
        }
    };

    static unload = function(planet_number, system) {
        var current_location = marine_location();
        set_last_ship();
        if (current_location[0] == location_types.ship) {
            if (!array_contains(["Warp", "Terra", "Mechanicus Vessel", "Lost"], current_location[2]) && current_location[2] == system.name) {
                obj_ini.loc[company][marine_number] = obj_ini.ship_location[current_location[1]];
                planet_location = planet_number;
                ship_location = -1;
                get_unit_size();
                system.p_player[planet_number] += size;
                obj_ini.ship_carrying[current_location[1]] -= size;
            }
        } else {
            ship_location = -1;
            obj_ini.loc[company][marine_number] = system.name;
            planet_location = planet_number;
            system.p_player[planet_number] += size;
        }
    };

    static allocate_unit_to_fresh_spawn = function(type = "default") {
        var homestar = "none";
        var spawn_location_chosen = false;
        if (((type == "home") || (type == "default")) && (obj_ini.fleet_type == ePlayerBase.home_world)) {
            var homestar = star_by_name(obj_ini.home_name);
        } else if (type != "ship") {
            var homestar = star_by_name(type);
        }
        /* if (!spawn_location_chosen){

	    }*/
        if (homestar != "none") {
            for (var i = 1; i <= homestar.planets; i++) {
                if (homestar.p_owner[i] == eFACTION.Player || (obj_controller.faction_status[eFACTION.Imperium] != "War" && array_contains(obj_controller.imperial_factions, homestar.p_owner[i]))) {
                    planet_location = i;
                    obj_ini.loc[company][marine_number] = obj_ini.home_name;
                    spawn_location_chosen = true;
                }
            }
        }
        if (!spawn_location_chosen) {
            var player_fleet = get_largest_player_fleet();
            if (player_fleet != "none") {
                get_unit_size();
                load_unit_to_fleet(player_fleet, self);
                spawn_location_chosen = true;
            }
            //TODO add more work arounds in case of no valid spawn point
            if (!spawn_location_chosen) {
                if (player_fleet != "none") {}
            }
        }
    };

    static specialist_tooltips = specialistfunct;

    static is_at_location = function(location = "", planet = 0, ship = -1) {
        var is_at_loc = false;
        if (planet > 0) {
            if (obj_ini.loc[company][marine_number] == location && planet_location == planet) {
                is_at_loc = true;
            }
        } else if (ship > -1) {
            if (ship_location == ship) {
                is_at_loc = true;
            }
        } else if (ship == -1 && planet == 0) {
            if (ship_location > -1) {
                if (obj_ini.ship_location[ship_location] == location) {
                    is_at_loc = true;
                }
            } else if (obj_ini.loc[company][marine_number] == location) {
                is_at_loc = true;
            }
        }
        return is_at_loc;
    };

    static edit_corruption = function(edit) {
        corruption = edit > 0 ? min(100, corruption + edit) : max(0, corruption + edit);
    };

    static in_jail = function() {
        return obj_ini.god[company, marine_number] >= 10;
    };

    static forge_point_generation = unit_forge_point_generation;

    static apothecary_point_generation = unit_apothecary_points_gen;

    static marine_assembling = scr_marine_game_spawn_constructions;

    static random_update_armour = scr_marine_spawn_armour;

    static roll_age = scr_marine_spawn_age;

    static roll_experience = function() {
        var _exp = 0;
        var _age_bonus = age();
        var _gauss_sd_mod = 14;

        _exp = _age_bonus;
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
            alter_equipment({
                "wep1": obj_ini.wep1[100][role_match],
                "wep2": obj_ini.wep2[100][role_match],
                "mobi": obj_ini.mobi[100][role_match],
                "armour": obj_ini.armour[100][role_match],
                "gear": obj_ini.gear[100][role_match]
            }, from_armoury, to_armoury, quality);
        }
    };

    static equipped_artifacts = function() {
        artis = [weapon_one(true), weapon_two(true), gear(true), armour(true), mobility_item(true)];
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
            "ballistic_skill": ballistic_skill
        };
    };

    //TODO: Make this into a universal stat gathering function from all gear, for any stat;
    static gear_special_value = function(special_id) {
        var _total_special_value = 0;

        var _all_data = [get_armour_data(), get_gear_data(), get_mobility_data(), get_weapon_one_data(), get_weapon_two_data()];

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
	}

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
		var _perils_strength = roll_personal_dice(1, 100, "low", self);
	
		// I hope you like demons
		if (has_trait("warp_tainted")) {
			var _second_roll = roll_personal_dice(1, 100, "high", self);
			if (_second_roll > _perils_strength) {
				_perils_strength = _second_roll;
			}
		}
	
		_perils_strength = max(_perils_strength, PSY_PERILS_STR_BASE);
	
		return _perils_strength;
	}

	static perils_test = function() {
		var _roll = roll_personal_dice(1, 1000, "high", self);
		var _perils_threshold = perils_threshold();
	
		return _roll <= _perils_threshold;
	}

	static psychic_focus_difficulty = function() {
		var _cast_difficulty = PSY_CAST_DIFFICULTY_BASE;  //TODO: Make this more dynamic;
		_cast_difficulty -= gear_special_value("psychic_focus");
		_cast_difficulty -= psychic_focus();
		_cast_difficulty = max(_cast_difficulty, PSY_CAST_DIFFICULTY_MIN);

		return _cast_difficulty;
	}

	static psychic_focus_test = function() {
		var _cast_roll = roll_personal_dice(1, 100, "high", self);
		var _cast_difficulty = psychic_focus_difficulty();
		var _test_successful = _cast_roll >= _cast_difficulty;

		if (_test_successful) {
			roll_psionic_increase();
			if (roll_personal_dice(2, 10, "high", self) == 20) {
				add_exp(1 * (_cast_difficulty / 100));
			}
		}

		return _test_successful;
	}

	static roll_psionic_increase = function() {
		if (psionic < 12) {
			var _psionic_difficulty = max(1, (psionic * 50) - experience);

			var _dice_roll = roll_personal_dice(1, _psionic_difficulty, "high", self);
			if (_dice_roll == _psionic_difficulty) {
				psionic++;
				add_battle_log_message($"{name_role()} was touched by the warp!", 999, 135);
			}
		}
	};

    static movement_after_math = function(end_company = company, end_slot = marine_number) {
        if (squad != "none") {
            var squad_data = obj_ini.squads[squad];
            var squad_member;

            for (var r = 0; r < array_length(squad_data.members); r++) {
                squad_member = squad_data.members[r];
                if (squad_member[0] == company && squad_member[1] == marine_number) {
                    if (squad_data.base_company != end_company) {
                        array_delete(squad_data.members, r, 1);
                        squad = "none";
                        // if unit will no longer be same company as squad remove unit from squad
                    } else {
                        squad_data.members[r] = [end_company, end_slot];
                    }
                }
            }
        }

        var arti, artifact_list = equipped_artifacts();
        for (var i = 0; i < array_length(artifact_list); i++) {
            arti = obj_ini.artifact_struct[artifact_list[i]];
            arti.bearer = [end_company, end_slot];
        }
    };
}

function jsonify_marine_struct(company, marine, stringify=true) {
    var copy_marine_struct = obj_ini.TTRPG[company, marine]; //grab marine structure
    var new_marine = {};
    var copy_part;
    var names = variable_struct_get_names(copy_marine_struct); // get all keys within structure
    for (var name = 0; name < array_length(names); name++) {
        //loop through keys to find which ones are methods as they can't be saved as a json string
        if (!is_method(copy_marine_struct[$ names[name]])) {
            copy_part = DeepCloneStruct(copy_marine_struct[$ names[name]]);
            variable_struct_set(new_marine, names[name], copy_part); //if key value is not a method add to copy structure
            delete copy_part;
        }
    }
    if(stringify){
        return json_stringify(new_marine);
    } else {
        return new_marine;
    }
}

/// @param {Array<Real>} unit where unit[0] is company and unit[1] is the position
/// @returns {Struct.TTRPG_stats} unit
function fetch_unit(unit) {
    return obj_ini.TTRPG[unit[0]][unit[1]];
}
