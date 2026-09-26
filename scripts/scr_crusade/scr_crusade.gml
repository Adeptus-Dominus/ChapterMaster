/// @self Id.Instance.obj_fleet
function scr_crusade() {
    // Executed to kill the fuck out of the player's marines
    // Think it is ran in the obj_p_fleet object when arriving back from crusade

    var _unit;
    var co = 0, i = 0, apoth = 0, death_determination = 0, death_determination_2 = 0, roll3 = 0, type = "", artifacts = 0, clean = 0;
    seed = 0;
    marines_lost = 0;
    var heroics_strings = [];

    //index 1: death_determine 1 //index 2: death_determine 2 /index 3: apoth_recovery
    //index 3 exp_gains irandom + static
    var death_sets = {
        normal: [
            80,
            90,
            40,
            [
                5,
                10,
            ],
        ],
        hard: [
            60,
            80,
            30,
            [
                20,
                20,
            ],
        ],
        brutal: [
            20,
            65,
            20,
            [
                40,
                20,
            ],
        ],
    };

    death_determination = floor(random(100)) + 1;
    roll3 = irandom(99) + 1;

    if (death_determination <= 50) {
        type = "normal";
        artifacts = choose(0, 0, 0, 0, 0, 1);
    } else if (death_determination > 50 && death_determination <= 80) {
        type = "hard";
        artifacts = choose(0, 0, 1);
    } else if (death_determination > 80) {
        type = "brutal";
        artifacts = choose(1, 2, 3);
    }

    var death_data = death_sets[$ type];

    for (co = 0; co <= obj_ini.companies; co++) {
        clean[co] = 0;
    }
    var total_ship_id = array_concat(capital_num, frigate_num, escort_num);

    for (co = 0; co <= obj_ini.companies; co++) {
        for (i = 0; i < company_length(co); i++) {
            dead = false;
            _unit = fetch_unit([co, i]);
            if (!is_struct(_unit)) {
                continue;
            }
            if (_unit.ship_location == -1) {
                continue;
            }
            if (array_contains(total_ship_id, _unit.ship_location)) {
                death_determination = floor(random(100)) + 1;
                //specialist trait greatly reduces death risk
                //TODO figure out how to quantify and present these risks so the player knows to protect dudes with trait
                if (_unit.has_trait("very_hard_to_kill")) {
                    death_determination -= 20;
                }
                death_determination_2 = death_determination;
                death_determination -= _unit.experience / 2;

                //more generalised trait bonus mainly linked to chapter advantage of same name
                if (_unit.has_trait("slow_and_purposeful")) {
                    death_determination -= 10;
                }

                var _dead = false;
                if (death_determination > death_data[0] || death_determination_2 > death_data[1]) {
                    _dead = true;
                    if (_unit.role() == obj_ini.player_role_data[eROLE.CAPTAIN].role) {
                        if (irandom(20) < _unit.luck) {
                            _dead = false;
                        } else {
                            if (irandom(100) < _unit.weapon_skill) {
                                var heroic_deed = choose("holding a breach in imperial defenses allowing allied forces to regroup,", "slaying the enemy leader in glorious combat, while victorious he ultimately succumbed to his wounds,", "leading an imortant boarding mission,");
                                //TODO figure out a blance in reward for captains or high rnaking death on crusade
                                //adds dynamacism as itt creates reward for the potential loss of men and talent during crusades
                                //var consolations = ["ship", "req",""]
                                //var consolation_prize = irandom(2)
                                var heroic_death = $"{_unit.full_title()} died {heroic_deed} {_unit.name()} dies a hero of the {global.chapter_name}";
                                array_push(heroics_strings, heroic_death);
                            }
                        }
                    } else if (_unit.role() == obj_ini.player_role_data[eROLE.ANCIENT].role || _unit.role() == obj_ini.player_role_data[eROLE.CHAPTERMASTER].role) {
                        _dead = false;
                    }
                }
                if (_dead) {
                    var man_size = 0;
                    obj_ini.ship_carrying[_unit.ship_location] -= _unit.get_unit_size();
                    if (_unit.IsSpecialist(SPECIALISTS_STANDARD, true)) {
                        obj_controller.command--;
                    } else {
                        obj_controller.marines--;
                    }

                    clean[co] = 1;
                    marines_lost++;
                    _unit.kill(false, true);
                } else {
                    if (_unit.IsSpecialist(SPECIALISTS_APOTHECARIES) && (_unit.gear() == "Narthecium")) {
                        apoth++;
                    }
                    _unit.add_exp(irandom(death_data[3][0]) + death_data[3][1]);

                    if (irandom(99) == 1 && irandom(20) < _unit.luck) {
                        var heroic_deed = choose("still_standing", "lone_survivor", "beast_slayer");
                        _unit.add_trait(heroic_deed);
                        array_push(heroics_strings, string(global.trait_list[$ heroic_deed].flavour_text, _unit.full_title()));
                    }
                }
            }
        }
    }

    if (obj_ini.doomed == 0) {
        if (apoth > 0) {
            seed = min(seed, apoth * death_data[2]);
        }
        if (apoth == 0) {
            seed = floor(seed * 0.2);
        }
        obj_controller.gene_seed += seed;
    }

    with (obj_ini) {
        for (i = 0; i <= 10; i++) {
            scr_company_order(i);
        }
    }

    if (roll3 <= 10) {
        artifacts += 1;
    }
    if (artifacts > 0) {
        repeat (artifacts) {
            if (obj_ini.fleet_type == ePLAYER_BASE.HOME_WORLD) {
                scr_add_artifact("random", "", 4, obj_ini.home_name, -1);
            }
            if (obj_ini.fleet_type != ePLAYER_BASE.HOME_WORLD) {
                scr_add_artifact("random", "", 4, obj_ini.ship[0], 0);
            }
        }
    }

    var tixt = "Your ships have returned from the Crusade.  ";
    if (type == "normal") {
        tixt += "The combat was as could be expected- ";
    }
    if (type == "hard") {
        tixt += "The combat was fairly grueling- ";
    }
    if (type == "brutal") {
        tixt += "The combat was absolutely brutal- your marines were the first into the fray, and as a result ";
    }

    tixt += string(marines_lost) + " of your battle brothers fell in combat.";

    if (obj_ini.doomed == 0) {
        if ((apoth > 0) && (seed > 0)) {
            tixt += "  The " + string(apoth) + " surviving " + string(obj_ini.player_role_data[eROLE.APOTHECARY].role) + " were able to recover " + string(seed) + " Gene-Seed.";
        }
        if ((apoth == 0) && (seed > 0)) {
            tixt += "  You had no able-bodied " + string(obj_ini.player_role_data[eROLE.APOTHECARY].role) + ", or all of them perished in the Crusade.  Foreign Apothecaries were able to recover " + string(seed) + " of your Gene-Seed.";
        }
    }
    if (obj_ini.doomed == 1) {
        tixt += "  Due to fatal mutations in your marines none of the fallen Gene-Seed was recoverable.";
    }

    if (artifacts > 0) {
        tixt += "  " + string(artifacts) + " Artifacts were granted to your Chapter or looted.";
    }
    if ((roll3 <= 10) && (artifacts > 1)) {
        tixt += "  One of them were given as a bonus for exceptional valor.";
    }

    if (array_length(heroics_strings) == 1) {
        tixt += " A heroic deed was recorded";
    } else if (array_length(heroics_strings) > 1) {
        tixt += " Several deeds were recorded";
    }
    // title / text / image / speshul
    scr_popup("Crusade Results", tixt, "crusade", "");
    for (i = 0; i < array_length(heroics_strings); i++) {
        scr_popup("Heroic Deed", heroics_strings[i], "crusade", "");
    }
}

//TODO never place the star out of reach of a player fleet, eiter increase allowed response time or find nearer planet
function launch_crusade() {
    var _star_id = scr_random_find(2, true, "", "");
    if (_star_id == noone) {
        LOGGER.error("RE: Crusade, couldn't find a star for the crusade");
        return false;
    } else {
        var _nearest_player_fleet = get_nearest_player_fleet(_star_id.x, _star_id.y);
        if (_nearest_player_fleet == noone) {
            return false;
        }
        _star_id.add_problem("great_crusade", {nearest_player_fleet:_nearest_player_fleet})
        return true;
    }
}
