/// @self Struct.TTRPG_stats
function scr_marine_spawn_age() {
    var _minimum_age = 0;
    var _maximum_age = 0;
    var _apply_gauss = false;
    var _gauss_sd_mod = 2; // The smaller this mod, the bigger is the spread;

    switch (company) {
        case 1:
            _minimum_age += 75;
            _maximum_age += 105;
            _apply_gauss = true;
            break;
        case 2:
        case 3:
        case 4:
        case 5:
            _minimum_age += 45;
            _maximum_age += 75;
            _apply_gauss = true;
            break;
        case 6:
        case 7:
            _minimum_age += 25;
            _maximum_age += 35;
            break;
        case 8:
            _minimum_age += 15;
            _maximum_age += 15;
            break;
        case 9:
            _minimum_age += 5;
            _maximum_age += 5;
            break;
        case 10:
        default:
            break;
    }

    var _venerable_dred = string_concat("Venerable ", obj_ini.player_role_data[eROLE.DREADNOUGHT].role);
    var _roles = active_roles();
    switch (role()) {
        case _roles[eROLE.DREADNOUGHT]:
            _minimum_age = 400;
            _maximum_age = 600;
            _apply_gauss = true;
            break;
        case _venerable_dred:
            _minimum_age = 650;
            _maximum_age = 0;
            _apply_gauss = true;
            break;
        // HQ only
        case _roles[eROLE.CHAPTERMASTER]:
            _minimum_age = 250;
            _maximum_age = 350;
            _apply_gauss = true;
            break;
        case "Chief Librarian":
        case "Forge Master":
        case "Master of Sanctity":
        case "Master of the Apothecarion":
        case _roles[eROLE.HONOURGUARD]:
            _minimum_age = 200;
            _maximum_age = 300;
            _apply_gauss = true;
            break;
        // Command Squads and HQ
        case _roles[eROLE.CHAPLAIN]:
        case _roles[eROLE.APOTHECARY]:
        case _roles[eROLE.TECHMARINE]:
        case _roles[eROLE.LIBRARIAN]:
            _minimum_age += 80;
            _maximum_age += 150;
            _apply_gauss = true;
            break;
        case _roles[eROLE.CODICIERY]:
            _minimum_age = 40;
            _maximum_age = 60;
            break;
        case _roles[eROLE.LEXICANUM]:
            _minimum_age = 20;
            _maximum_age = 40;
            break;
        // 1st company only
        case _roles[eROLE.VETERAN]:
            _minimum_age = 100;
            _maximum_age = 140;
            break;
        case _roles[eROLE.TERMINATOR]:
            _minimum_age = 120;
            _maximum_age = 160;
            break;
        case _roles[eROLE.VETERANSERGEANT]:
            _minimum_age = 160;
            _maximum_age = 180;
            break;
        // Command Squads
        case _roles[eROLE.ANCIENT]:
            _minimum_age += 100;
            _maximum_age += 110;
            break;
        case [_roleseROLE.CAPTAIN]:
            _minimum_age += 80;
            _maximum_age += 90;
            break;
        case obj_ini.player_role_data[eROLE.CHAMPION].role:
            _minimum_age += 50;
            _maximum_age += 60;
            break;
        // Company marines
        case obj_ini.player_role_data[eROLE.SERGEANT].role:
            _minimum_age += 30;
            _maximum_age += 40;
            break;
        case obj_ini.player_role_data[eROLE.TACTICAL].role:
        case obj_ini.player_role_data[eROLE.DEVASTATOR].role:
        case obj_ini.player_role_data[eROLE.ASSAULT].role:
            _minimum_age += 20;
            _maximum_age += 30;
            break;
        case obj_ini.player_role_data[eROLE.SCOUT].role:
        default:
            _minimum_age = 18;
            _maximum_age = 25;
            break;
    }

    var _age;
    if (_apply_gauss == true) {
        if (_maximum_age != 0) {
            _gauss_sd_mod = (_maximum_age - _minimum_age) / _gauss_sd_mod;
            _age = round(gauss_positive(_minimum_age, _gauss_sd_mod));
        } else {
            _age = round(gauss_positive(_minimum_age, _minimum_age / _gauss_sd_mod));
        }
    } else {
        _age = irandom_range(_minimum_age, _maximum_age);
    }

    born = obj_ini.sector_handler.get_creation_year(_age);

    marine_ascension = born + 17;
}

/// @self Struct.TTRPG_stats
function scr_marine_spawn_armour() {
    /// @self Struct.TTRPG_stats
    var _terminator_armour_roll = function(_score) {
        if (_score > 270) {
            update_armour(choose("Tartaros", "Terminator Armour", "Terminator Armour"), false, false);
        } else if (_score > 250) {
            update_armour(choose("Tartaros", "Terminator Armour", "Terminator Armour", "Terminator Armour"), false, false);
        } else {
            update_armour("Terminator Armour", false, false);
        }
    };

    var _role = role();
    var _exp = experience;
    var _total_score = age() + _exp + (scr_has_adv("Crafters") ? 50 : 0);
    var _company = company;

    var _armour_weighted_lists = {
        normal_armour: [
            [
                "MK7 Aquila",
                95,
            ],
            [
                "MK6 Corvus",
                5,
            ],
        ],
        rare_armour: [
            [
                "MK7 Aquila",
                100,
            ],
            [
                "MK6 Corvus",
                30,
            ],
            [
                "MK8 Errant",
                2,
            ],
            [
                "MK5 Heresy",
                2,
            ],
            [
                "MK4 Maximus",
                1,
            ],
            [
                "MK3 Iron Armour",
                1,
            ],
        ],
        quality_armour: [
            [
                "MK7 Aquila",
                30,
            ],
            [
                "MK6 Corvus",
                5,
            ],
            [
                "MK8 Errant",
                5,
            ],
            [
                "MK4 Maximus",
                5,
            ],
        ],
        old_armour: [
            [
                "MK6 Corvus",
                4,
            ],
            [
                "MK8 Errant",
                2,
            ],
            [
                "MK5 Heresy",
                2,
            ],
            [
                "MK4 Maximus",
                1,
            ],
            [
                "MK3 Iron Armour",
                1,
            ],
        ],
        ancient_armour: [
            [
                "MK6 Corvus",
                5,
            ],
            [
                "MK5 Heresy",
                3,
            ],
            [
                "MK4 Maximus",
                1,
            ],
            [
                "MK3 Iron Armour",
                1,
            ],
        ],
    };

    var _terminator_roles_array = [
        obj_ini.player_role_data[eROLE.CAPTAIN].role,
        obj_ini.player_role_data[eROLE.CHAMPION].role,
        obj_ini.player_role_data[eROLE.ANCIENT].role,
        obj_ini.player_role_data[eROLE.CHAPLAIN].role,
        obj_ini.player_role_data[eROLE.APOTHECARY].role,
        obj_ini.player_role_data[eROLE.LIBRARIAN].role,
        obj_ini.player_role_data[eROLE.TECHMARINE].role,
    ];

    // terminator/tartaros should be decided in scr_initialize_custom
    if (_company == 1 && array_contains(_terminator_roles_array, _role) && armour() == "Terminator Armour") {
        _terminator_armour_roll(_total_score);
    } else {
        switch (_role) {
            // HQ
            // case obj_ini.player_role_data[eROLE.CHAPTERMASTER].role:
            // case "Chief Librarian":
            // case "Forge Master":
            // case "Master of Sanctity":
            // case "Master of the Apothecarion":
            // case obj_ini.player_role_data[eROLE.HONOURGUARD].role:
            case "Codiciery":
            case "Lexicanum":
            // 1st company only
            case obj_ini.player_role_data[eROLE.VETERAN].role:
            case obj_ini.player_role_data[eROLE.VETERANSERGEANT].role:
            // Command Squads
            case obj_ini.player_role_data[eROLE.CAPTAIN].role:
            case obj_ini.player_role_data[eROLE.CHAMPION].role:
            case obj_ini.player_role_data[eROLE.ANCIENT].role:
            // Command Squads and HQ
            case obj_ini.player_role_data[eROLE.CHAPLAIN].role:
            case obj_ini.player_role_data[eROLE.APOTHECARY].role:
            case obj_ini.player_role_data[eROLE.LIBRARIAN].role:
            // Company marines
            // case obj_ini.player_role_data[eROLE.SCOUT].role:
            case obj_ini.player_role_data[eROLE.TACTICAL].role:
            case obj_ini.player_role_data[eROLE.DEVASTATOR].role:
            case obj_ini.player_role_data[eROLE.ASSAULT].role:
            case obj_ini.player_role_data[eROLE.SERGEANT].role:
                if (scr_has_adv("Ancient Armoury")) {
                    update_armour(choose_weighted(_armour_weighted_lists.ancient_armour), false, false);
                } else if (_total_score > 280) {
                    update_armour(choose_weighted(_armour_weighted_lists.old_armour), false, false);
                } else if (_total_score > 180) {
                    update_armour(choose_weighted(_armour_weighted_lists.quality_armour), false, false);
                } else if (_total_score > 100) {
                    update_armour(choose_weighted(_armour_weighted_lists.rare_armour), false, false);
                } else {
                    update_armour(choose_weighted(_armour_weighted_lists.normal_armour), false, false);
                }
                break;
            case obj_ini.player_role_data[eROLE.TECHMARINE].role:
                if (_total_score > 280) {
                    update_armour("Artificer Armour", false, false);
                } else if (scr_has_adv("Ancient Armoury")) {
                    update_armour(choose_weighted(_armour_weighted_lists.ancient_armour), false, false);
                } else if (_total_score > 180) {
                    update_armour(choose_weighted(_armour_weighted_lists.quality_armour), false, false);
                } else if (_total_score > 100) {
                    update_armour(choose_weighted(_armour_weighted_lists.rare_armour), false, false);
                } else {
                    update_armour(choose_weighted(_armour_weighted_lists.normal_armour), false, false);
                }
                break;
            case obj_ini.player_role_data[eROLE.TERMINATOR].role:
                _terminator_armour_roll(_total_score);
                break;
        }
    }
}

/// @self Struct.TTRPG_stats
function scr_marine_game_spawn_constructions() {
    roll_age();
    roll_experience();
    assign_reactionary_traits();
    random_update_armour();

    var old_guard = irandom(100);
    var _chap_name = instance_exists(obj_creation) ? obj_creation.chapter_name : global.chapter_name;

    var bionic_count = choose(0, 0, 0, 0, 1, 2, 3);
    if (_chap_name == "Iron Hands") {
        bionic_count = choose(2, 3, 4, 5);
    }
    switch (role()) {
        case obj_ini.player_role_data[eROLE.CAPTAIN].role: //captain
            if (old_guard >= 80 || company == 1) {
                bionic_count = choose(0, 0, 1, 2, 3);
            } else {
                bionic_count = choose(0, 0, 0, 1, 2);
            }
            charisma += irandom(10);
            wisdom += irandom(10);
            piety += irandom(10);
            if (irandom(1) == 0) {
                add_trait("natural_leader");
            }
            if (scr_has_adv("Assault Doctrine")) {
                weapon_skill += irandom(5);
                if (irandom(1) == 0) {
                    add_trait("melee_enthusiast");
                }
            }
            if (scr_has_adv("Devastator Doctrine")) {
                constitution += irandom(5);
                if (irandom(1) == 0) {
                    add_trait("slow_and_purposeful");
                }
            }
            break;
        case obj_ini.player_role_data[eROLE.APOTHECARY].role: //apothecary
            if (company > 0) {
                if (old_guard >= 80 || company == 1) {
                    bionic_count = choose(0, 0, 1, 2, 3);
                } else {
                    bionic_count = choose(0, 0, 0, 1, 2);
                }
            } else {
                bionic_count = choose(0, 0, 0, 0, 1);
            }
            if (intelligence < 40) {
                intelligence = 40;
            }
            break;
        case obj_ini.player_role_data[eROLE.ANCIENT].role: // Ancient
            if (old_guard >= 50 || company == 1) {
                bionic_count = choose(0, 0, 1, 2, 3);
            } else {
                bionic_count = choose(0, 0, 0, 1, 2);
            }
            if (_chap_name == "Ultramarines" || scr_has_adv("Enemy: Tyranids")) {
                if (choose(true, false)) {
                    add_trait("tyrannic_vet");
                    bionic_count += irandom(1);
                }
            }
            break;
        case obj_ini.player_role_data[eROLE.TACTICAL].role: //tacticals
            break;
        case obj_ini.player_role_data[eROLE.DEVASTATOR].role: //devastators
            break;
        case obj_ini.player_role_data[eROLE.TERMINATOR].role:
        case obj_ini.player_role_data[eROLE.VETERAN].role: //veterans
            if (_chap_name == "Ultramarines" || scr_has_adv("Enemy: Tyranids")) {
                if (choose(true, false)) {
                    add_trait("tyrannic_vet");
                    bionic_count += irandom(1);
                }
            }

            break;
        case obj_ini.player_role_data[eROLE.TECHMARINE].role: //techmarines
            if ((old_guard >= 90 && company > 0 && company < 6) || company == 1) {
                bionic_count = choose(1, 2, 3, 4, 5);
            } else if (company > 0 && company < 6) {
                bionic_count = choose(1, 1, 2, 3, 4);
            } else {
                bionic_count = choose(1, 1, 1, 2, 3);
            }
            var tech_heresy = irandom(49);
            if ((_chap_name == "Iron Hands") || (obj_ini.progenitor == ePROGENITOR.IRON_HANDS) || scr_has_disadv("Tech-Heresy")) {
                add_bionics("right_arm", "standard", false);
                bionic_count = choose(6, 6, 7, 7, 7, 8, 9);
                add_trait("flesh_is_weak");
                tech_heresy = irandom(19);
            } else {
                bionic_count = irandom(5) + 1;
                if (irandom(2) == 0) {
                    add_trait("flesh_is_weak");
                }
            }
            if (scr_has_disadv("Tech-Heresy")) {
                tech_heresy = irandom(10);
                technology += 4;
            }
            if (tech_heresy == 0) {
                add_trait("tech_heretic");
                edit_corruption(30);
            }
            if (technology < 35) {
                technology = 35;
            }
            add_trait("mars_trained");
            if (irandom(1) == 0) {
                add_trait("tinkerer");
            }
            if (religion != "cult_mechanicus") {
                religion_sub_cult = "none";
            }
            if (scr_has_adv("Crafters")) {
                if (irandom(2) == 0) {
                    add_trait("crafter");
                }
            } else if (obj_ini.progenitor == ePROGENITOR.SALAMANDERS || obj_ini.progenitor == ePROGENITOR.IRON_HANDS) {
                technology += 2;
                if (irandom(4) == 0) {
                    add_trait("crafter");
                }
            }
            religion = "cult_mechanicus";
            break;
        case obj_ini.player_role_data[eROLE.SCOUT].role: //scouts
            bionic_count = choose(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1);
            break;
        case obj_ini.player_role_data[eROLE.CHAPLAIN].role: //chaplain
            if (company > 0) {
                if (old_guard >= 80 || company == 1) {
                    bionic_count = choose(0, 0, 1, 2, 3);
                } else {
                    bionic_count = choose(0, 0, 0, 1, 2);
                }
            } else {
                bionic_count = choose(0, 0, 0, 0, 1);
            }
            if (piety < 35) {
                piety = 35;
            }
            if (irandom(1) == 0) {
                add_trait("zealous_faith");
            }
            break;
        case "Codiciery":
            break;
        case "Lexicanum":
            break;
        case obj_ini.player_role_data[eROLE.LIBRARIAN].role:
            if ((old_guard >= 90 && company > 0 && company < 6) || company == 1) {
                bionic_count = choose(0, 0, 1, 2, 3);
            } else if (company > 0 && company < 6) {
                bionic_count = choose(0, 0, 0, 1, 2);
            } else {
                bionic_count = choose(0, 0, 0, 0, 1);
            }
            break;
        case obj_ini.player_role_data[eROLE.CHAMPION].role:
            if (old_guard >= 80 || company == 1) {
                bionic_count = choose(0, 0, 1, 2, 3);
            } else {
                bionic_count = choose(0, 0, 0, 1, 2);
            }
            break;
    }
    if (irandom(75) > 74) {
        add_trait("tyrannic_vet");
        bionic_count += irandom(2);
    }
    if (irandom(399 - experience) == 0) {
        add_trait("still_standing");
    }
    if (irandom(399 - experience) == 0) {
        add_trait("beast_slayer");
    }
    if (irandom(499 - experience) == 0) {
        add_trait("lone_survivor");
    }
    for (var i = 0; i < bionic_count; i++) {
        add_bionics("none", "standard", false);
    }
    add_purity_seal_markers();
}
