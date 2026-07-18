function MissionHandler(planet, system) : PlanetData(planet, system) constructor {}

function location_out_of_player_control(unit_loc) {
    static _locs = [
        "Terra",
        "Mechanicus Vessel",
        "Lost",
        "Mars",
    ];
    return array_contains(_locs, unit_loc);
}

global.planet_problem_keys = [
    "meeting_trap",
    "meeting",
    "succession",
    "mech_raider",
    "mech_bionics",
    "mech_mars",
    "mech_tomb1",
    "fallen",
    "great_crusade",
    "harlequins",
    "fund_elder",
    "provide_garrison",
    "hunt_beast",
    "protect_raiders",
    "join_communion",
    "join_parade",
    "recover_artifacts",
    "train_forces",
    "spyrer",
    "inquisitor",
    "recon",
    "cleanse",
    "purge",
    "tyranid_org",
    "artifact_loan",
    "necron",
    "ethereal",
    "demon_world",
];

function mission_name_key(mission) {
    var mission_key = {
        "meeting_trap": "Chaos Lord Meeting",
        "meeting": "Chaos Lord Meeting",
        "succession": "War of succession",
        "mech_raider": "Provide Land Raider to Mechanicus",
        "mech_bionics": "Provide Bionic Augmented marines to study",
        "mech_mars": "Send Techmarines to mars",
        "mech_tomb1": "Explore Mechanicus Tomb",
        "fallen": "Find Chapter Fallen",
        "great_crusade": "Answer Crusade Muster Call",
        "harlequins": "Harlequin presence Report",
        "fund_elder": "provide assistance to Eldar",
        "provide_garrison": "Provision Garrison",
        "hunt_beast": "Hunt Beasts",
        "protect_raiders": "Protect From Raiders",
        "join_communion": "Join Planetary Religious Celebration",
        "join_parade": "Join Parade on Planet Surface",
        "recover_artifacts": "Recover Artifacts",
        "train_forces": "Train Planet Forces",
        // Inquisition missions
        "spyrer": "Kill Spyrer for Inquisitor",
        "inquisitor": "Radical Inquisitor Arriving",
        "recon": "Recon Mission for Inquisitor",
        "cleanse": "Cleanse Planet for Inquisitor",
        "purge": "Purge Leadership for Inquisitor",
        "tyranid_org": "Capture Tyranid for Inquisitor",
        // "bomb" : "Bombard World for Inquisitor",
        "artifact_loan": "Safeguard Artifact for the Inquisition",
        "necron": "Bomb Necron Tomb for Inquisitor",
        "ethereal": "Capture Ethereal for Inquisitor",
        "demon_world": "Clear Demon World for Inquisitor",
    };
    if (struct_exists(mission_key, mission)) {
        return mission_key[$ mission];
    } else {
        return "none";
    }
}

/// @self Struct.PlanetData
function problem_end_turn_checks() {
    /// @self Struct.PlanetData
    static problem_functions = {
        "succession": function(problem_index) {
            if (problem_timers[problem_index] > 0) {
                return;
            }
            var result, _alert_text;
            var dice1 = roll_dice(1, 100);
            var dice2 = roll_dice(1, 100);

            result = eFACTION.IMPERIUM;
            _alert_text = "";
            if (dice1 <= (corruption * 2)) {
                result = eFACTION.CHAOS;
            }
            if (dice2 <= (population_influences[eFACTION.TAU] * 2)) {
                result = eFACTION.TAU;
            }

            if (current_owner == eFACTION.IMPERIUM && result != eFACTION.IMPERIUM) {
                edit_pdf(guardsmen);
                edit_guardsmen(-guardsmen);
                set_new_owner(result);
            }

            _alert_text = $"War of Succession on {name()} has ended";

            if (result == eFACTION.CHAOS) {
                _alert_text += " with Chaos in control.";
                set_player_disposition(0);
                scr_alert("red", "succession", _alert_text, x, y);
                scr_event_log("purple", _alert_text);
            } else if (result == eFACTION.TAU) {
                _alert_text += " with a Tau sympathizer in control.";
                set_player_disposition(10 + choose(1, 2, 3, 4, 5, 6));
                add_forces(eFACTION.TAU, 2);
                scr_alert("red", "succession", _alert_text, x, y);
                scr_event_log("red", _alert_text);
            } else if (result == eFACTION.IMPERIUM) {
                _alert_text += " The resultant governor is the most staunch pillar of the imperium.";
                _alert_text += ".";
                scr_alert("green", "succession", _alert_text, x, y);
                scr_event_log("", _alert_text);
            } else {
                //At the moment does not fire but a worty flavour option for down the line
                _alert_text += " Word is the new Governor has Heretical leanings and sympathises with xenos.";
            }

            delete_feature(eP_FEATURES.SUCCESSION_WAR);
            remove_problem("succession");
        },
        "recon": function(problem_index) {
            if (problem_timers[problem_index] > 0) {
                return;
            }
            var _alert_text = "Inquisition Mission Failed: Investigate ";
            alter_disposition(eFACTION.INQUISITION, -5);
            _alert_text += $"{name()}.";
            scr_alert("red", "mission_failed", _alert_text, 0, 0);
            scr_event_log("red", _alert_text);
            remove_problem("recon");
        },
        "great_crusade": function(problem_index) {
            if (problem_timers[problem_index] > 0) {
                return;
            }
            var _crusade_direction;
            var _join_crusade = false;
            var _player_fleet = instance_nearest(system.x, system.y, obj_p_fleet);

            if (_player_fleet.action == "") {
                if (point_distance(system.x, system.y, _player_fleet.x, _player_fleet.y) < 10) {
                    _join_crusade = true;
                }
            }

            if (_join_crusade) {
                _crusade_direction = point_direction(room_width / 2, room_height / 2, x, y);
                with (_player_fleet) {
                    action_x = x + lengthdir_x(1200, _crusade_direction);
                    action_y = y + lengthdir_y(1200, _crusade_direction);
                    set_fleet_movement(false, "crusade1");
                }

                scr_alert("green", "crusade", "Fleet embarks upon Crusade.", x, y);
                scr_event_log("", "Fleet embarks upon Crusade.");
            } else {
                // hit loyalty here
                alter_dispositions([[eFACTION.INQUISITION, -10], [eFACTION.IMPERIUM, -5]]);
                var _string = $"No ships designated for Crusade.";
                if (obj_controller.penitent == 1) {
                    obj_controller.penitent_current = 0;
                    _string += "Your penitence crusade has been lengthened for your failings";
                }

                scr_alert("red", "crusade", _string, system.x, system.y);
                scr_loyalty("Refusing to Crusade", "+");
                scr_event_log("red", "No ships designated for Crusade.");
            }
            remove_problem("great_crusade");
        },
        "necron": function(problem_index) {
            if (problem_timers[problem_index] > 0) {
                return;
            }

            alter_disposition(eFACTION.INQUISITION, -8);
            var _alert_text = $"The Necron Tomb of planet {name()} has not been deactivated in time.  It has awakened, rank upon rank of Necrons pouring out to the planet's surface.  The Inquisition is not pleased with your failure.";
            scr_popup("Inquisition Mission Failed", _alert_text, "necron_army", "");
            scr_event_log("red", $"Inquisition Mission Failed: Bombing run failed; the Necron Tomb on {name()} has become active.");

            add_forces(eFACTION.NECRONS, 4);
            if (awake_tomb_world(features) == 0) {
                awaken_tomb_world(features);
            }
            remove_problem("necron");
        },
        "spyrer": function(problem_index) {
            if (problem_timers[problem_index] > 0) {
                return;
            }
            var _planet_name = name();
            alter_disposition(eFACTION.INQUISITION, -3);
            var _alert_text = $"The Spyrer on {_planet_name} has been left unchecked.  In the ensuing carnage some high-ranking officials have been killed, along with several Nobles.  Panic is running amock in several parts of the hives and the Inquisition is less than pleased.";
            var _text = "Inquisition Mission Failed: The Spyrer on {_planet_name} was not removed.";
            scr_popup("Inquisition Mission Failed", _alert_text, "spyrer", "");
            scr_event_log("red", _text);
            remove_problem("spyrer");
        },
        "fallen": function(problem_index) {
            //TODO marker point for cohesion mechanics
            if (problem_timers[problem_index] > 0) {
                return;
            }
            var alert_text = "";
            var _unit;
            if (irandom(100) > 33) {
                // Give all marines +3d6 corruption and reduce loyalty by 20*/
                var me = 0;
                for (var co = 0; co <= obj_ini.companies; co++) {
                    me = 0;
                    for (me = 0; me < array_length(obj_ini.role[co]); me++) {
                        if ((obj_ini.race[co][me] == 1) && (obj_ini.role[co][me] != "")) {
                            _unit = fetch_unit([co, me]);
                            _unit.edit_corruption(irandom_range(3, 6));
                            _unit.alter_loyalty(-10);
                        }
                    }
                }
            }
            alert_text = $"Any Fallen that may have been on {name()} ";
            alert_text += "have been given sufficient time to escape.  Morale within your chapter has plummeted; some of your battle brothers have become restless and speak among eachother in hushed tones.";
            scr_popup("Hunt the Fallen Failed", alert_text + "\n\n(Chapter wide loyalty: -10)\nChaplains note marked changes in behaviour of some brothers", "fallen", "");
            obj_controller.loyalty -= 10;
            obj_controller.loyalty_hidden -= 10;
            remove_problem("fallen");
            scr_event_log("red", $"Mission Failed: Any Fallen within the {system.name} system have been given time to escape.");
        },
        "provide_garrison": complete_garrison_mission,
    };

    for (var i = 0; i < array_length(problems); i++) {
        var _problem = problems[i];
        if (_problem == "") {
            continue;
        }

        if (struct_exists(problem_functions, _problem)) {
            try {
                var _problem_action = method(self, problem_functions[$ _problem]);
                _problem_action(i);
            } catch (_exception) {
                ERROR_HANDLER.handle_exception(_exception);
            }
        }
    }
}

/// @self Asset.GMObject.obj_star
function scr_new_governor_mission(planet, problem = "") {
    if (p_owner[planet] != eFACTION.IMPERIUM) {
        exit;
    }
    var planet_type = p_type[planet];
    if (problem == "") {
        if (planet_type == "Death") {
            problem = choose("hunt_beast", "provide_garrison");
        } else if (planet_type == "Hive") {
            problem = choose("show_of_power", "provide_garrison", "purge_enemies", "raid_black_market");
        } else if (planet_type == "Temperate") {
            problem = choose("provide_garrison", "train_forces", "join_parade");
        } else if (planet_type == "Shrine") {
            problem = choose("provide_garrison", "join_communion");
        } else if (planet_type == "Ice") {
            problem = choose("provide_garrison", "hunt_beast");
        } else if (planet_type == "Lava") {
            problem = choose("provide_garrison", "protect_raiders");
        } else if (planet_type == "Agri") {
            problem = choose("provide_garrison", "protect_raiders", "recover_artifacts");
        } else if (planet_type == "Desert") {
            problem = choose("provide_garrison", "protect_raiders", "recover_artifacts");
        } else if (planet_type == "Feudal") {
            problem = choose("hunt_beast", "protect_raiders");
        }
    }
    var mission_data = {
        stage: "preliminary",
        applicant: "Governor",
    };
    if (problem != "") {
        if (problem == "provide_garrison") {
            if (get_garrison(planet).garrison_force) {
                exit;
            }
            mission_data.reason = choose("stability", "importance");
        } else if (problem == "purge_enemies") {
            var enemy = 0;
            if (planets > 1) {
                for (var i = 1; i <= planets; i++) {
                    if (i == planet) {
                        continue;
                    }
                    if (p_owner[i] == eFACTION.IMPERIUM) {
                        enemy = i;
                        break;
                    }
                }
            }
            mission_data.target = enemy;
            if (!enemy) {
                exit;
            }
        }
        add_new_problem(planet, problem, 20 + irandom(20),, mission_data);
    }
}

function init_marine_acting_strange() {
    var marine_and_company = scr_random_marine("", 0);
    if (marine_and_company == "none") {
        LOGGER.error("RE: Strange Behavior, couldn't pick a space marine");
        exit;
    }

    var unit = fetch_unit(marine_and_company);
    var role = unit.role();
    var text = unit.name_role();
    var company_text = scr_convert_company_to_string(unit.company);
    if (company_text != "") {
        company_text = $"({company_text})";
        text += company_text;
    }
    text += " is behaving strangely.";
    scr_alert("color", "lol", text, 0, 0);
    scr_event_log("color", text);
}

function init_garrison_mission(planet, star, mission_slot) {
    var problems_data = star.p_problem_other_data[planet];
    var mission_data = problems_data[mission_slot];
    if (mission_data.stage == "preliminary") {
        var numeral_name = planet_numeral_name(planet, star);
        mission_data.stage = "active";
        var garrison_length = 10 + irandom(6);
        star.p_timer[planet][mission_slot] = garrison_length;
        var gar_pop = instance_create(0, 0, obj_popup);
        //TODO some new universal methods for popups
        gar_pop.title = $"Requested Garrison Provided to {numeral_name}";
        gar_pop.text = $"The governor of {numeral_name} Thanks you for considering his request for a garrison, you agree that the garrison will remain for at least {garrison_length} months.";
        gar_pop.add_option("Commence Garrison");
        gar_pop.image = "";
        gar_pop.cooldown = 8;
        obj_controller.cooldown = 8;
        scr_event_log("", $"Garrison committed to {numeral_name} for {garrison_length} months.", star.name);
    }
}

function init_beast_hunt_mission(planet, star, mission_slot) {
    var problems_data = star.p_problem_other_data[planet];
    var mission_data = problems_data[mission_slot];
    if (mission_data.stage == "preliminary") {
        var numeral_name = planet_numeral_name(planet, star);
        mission_data.stage = "active";
        var _mission_length = irandom_range(2, 5);
        star.p_timer[planet][mission_slot] = _mission_length;
        var gar_pop = instance_create(0, 0, obj_popup);
        //TODO some new universal methods for popups
        gar_pop.title = $"Marines assigned to hunt beasts around {numeral_name}";
        gar_pop.text = $"The govornor of {numeral_name} Thanks you for the participation of your elite warriors in your execution of such a menial task.";
        gar_pop.add_option("Happy Hunting");
        gar_pop.image = "";
        gar_pop.cooldown = 8;
        obj_controller.cooldown = 20;
        scr_event_log("", $"Beast hunters deployed to {numeral_name} for {_mission_length} months.", star.name);
    }
}

function role_compare(unit, role) {
    return unit.role() == obj_ini.role[100][role];
}

function init_protect_raider_mission(squad) {
    var _squad_units = squad.get_squad_structs();
    var _squad_wisdom = stat_average(_squad_units, "wisdom");
    var _squad_dex = stat_average(_squad_units, "dexterity");
    var _tester = global.character_tester;

    var _pdata = selection_data.system.get_planet_data(selection_data.planet);
    var _mod = _squad_wisdom + _squad_dex / 20;
    if (scr_has_adv("Ambushers")) {
        _mod += 10;
    }

    var _leader = fetch_unit(squad.determine_leader());

    var _wis_test = _tester.standard_test(_leader, "wisdom", _mod, ["ambush"]);

    if (!_wis_test[0]) {
        if (_wis_test[1] < -25) {
            scr_toggle_manage();
            var gar_pop = instance_create(0, 0, obj_popup);
            gar_pop.title = $"Strange Disappearance";
            gar_pop.pdata = _pdata;
            gar_pop.text = $"Your Marines make planet fall and are directed to report to the governor for the duration of the operation after a period of reconnaissance dig in for their ambush. After a two weeks have passed A message from the governor reaches your astropaths that your marines have not been heard of for some time, The raiders also were not noted to have arrived onor left the planet";
            var _dead_marine = array_random_index(_squad_units);
            for (var i = 0; i < array_length(_dead_marine); i++) {
                if (i == _dead_marine) {
                    continue;
                }

                var _marine = _dead_marine[i];

                _marine.location_string = "Lost";
                _marine.ship_location = -1;
                _marine.planet_location = 0;
            }
            gar_pop.text += $"After eventual investigation it appears the eldar anticipated the would be ambushers and turned the tides. {_squad_units[_dead_marine].name_role()}s body is eventually discovered some way off from the main battle his rent armour and body showing the extent of combat that must have occured";

            gar_pop.text += "\nThe total loss of a squad in what was meant to be a routine operation is bad for moral and your chapters reputation you must now decide how to proceed";

            gar_pop.add_option({str1: "Suppress the Information", choice_func: protect_raiders_suppress_information});

            gar_pop.add_option({str1: "Hold a Memorial", choice_func: protect_raiders_hold_memorial});
        } else {
            scr_toggle_manage();
            var gar_pop = instance_create(0, 0, obj_popup);
            gar_pop.title = $"Ineffective Ambush";
            gar_pop.text = $"Your Marines Are ineffective at setting up an ambush the assailants clearly got wind of the operation or the plan was otherwise so ill thought out that by the time your forces arrived there was little that could be done to intercept them";
            gar_pop.text += $"";
            gar_pop.pathway = "protect_raiders_ineffective";
            gar_pop.pdata = _pdata;
            _pdata.add_disposition(-10);
            gar_pop.text += "\nThe governor is unhappy and it has done little to improve your reputation with the planets populace but otherwise very little harm has been done. It is likely the raiders will choose better targets without the possible threat of space marine presence for the foreseeable future\nGovernor Disposition : -10";

            gar_pop.add_option("continue");
        }
    } else {
        instance_create(0, 0, obj_ncombat);
        obj_ncombat.enemy = eFACTION.ELDAR;
        obj_ncombat.battle_object = selection_data.system;
        obj_ncombat.battle_loc = selection_data.system.name;
        obj_ncombat.battle_id = selection_data.planet;
        obj_ncombat.battle_special = "protect_raiders";
        _roster = new Roster();
        with (_roster) {
            selected_units = _squad_units;
            setup_battle_formations();
            add_to_battle();
        }
        exit_adhoc_manage();
        delete _roster;
    }
}

/// @self Asset.GMObject.obj_popup
function protect_raiders_suppress_information() {
    title = "Captains Disgruntled";
    options1 = "continue";
    pathway = "";
    var _caps = scr_role_count(obj_ini.roles[100][eROLE.CAPTAIN]);
    var _worst = -1;
    var _worst_hit = -1;
    for (var i = 0; i < array_length(_caps); i++) {
        if (!irandom(2)) {
            var _cap = _caps[i];
            var _loyalty_hit = irandom(6);
            if (_loyalty_hit > _worst_hit) {
                _worst_hit = _loyalty_hit;
                _worst = i;
            }
        }
    }

    if (_worst == -1) {
        text = $"You are able to convince your captains of the strategic need to cover up the incidence, various excuses are made and fake logs that cover up the disaster of the mission";
    } else {
        text = $"Not all of your captains are convinced of the need to use deceit and a none have breached the order but it has soured your relations with a few namely {_caps[_worst].name_role()}";
    }
}

/// @self Asset.GMObject.obj_popup
function protect_raiders_hold_memorial() {
    reset_popup_options();
    options1 = "continue";
    _pdata.add_disposition(-30);
    text = $"You prepare to have a large public memorial for your fallen marines on the planet surface as a show of defiance. The chapter are pleased by such an act and the population of the planet are mesmerized by the spectacle. The governor is furious not only has his incompetence to deal with the planets xenos issue been made public in such a way that the sector commander has now heard about it but he perceives his failures are being paraded in font of him\n nGovernor Disposition : -30";
}

function init_train_forces_mission(planet, star, mission_slot, marine) {
    var _pdata = star.get_planet_data(planet);
    var mission_data = _pdata.problems_data[mission_slot];
    if (mission_data.stage == "preliminary") {
        var numeral_name = _pdata.name();
        mission_data.stage = "active";
        var _mission_length = irandom_range(3, 12);
        star.p_timer[planet][mission_slot] = _mission_length;
        //pop.image="ancient_ruins";
        var gar_pop = instance_create(0, 0, obj_popup);
        //TODO some new universal methods for popups
        gar_pop.title = $"Training forces on {numeral_name} begins";
        gar_pop.text = $"{marine.name_role()} Has taken leave of his current post in order to aid the governor of {numeral_name} and his pdf commanders with training local forces and bolstering defences.";
        var _is_cap = role_compare(marine, eROLE.CAPTAIN);

        if (_is_cap) {
            gar_pop.text += "the governor seems to be impressed that such a high ranking officer has been assigned to his request (disp +3)";
            _pdata.add_disposition(3);
        }

        //pip.image="event_march"
        gar_pop.add_option($"Good luck {marine.name()}");
        gar_pop.image = "";
        gar_pop.cooldown = 500;
        obj_controller.cooldown = 500;
        scr_event_log("", $"{marine.name_role()} deployed to {numeral_name} for {_mission_length} months.", star.name);
    }
}

/// @self Asset.GMObject.obj_star
function complete_garrison_mission(problem_index) {
    if (problem_timers[problem_index] > 0) {
        return;
    }
    var _problem_data = problems_data[problem_index];
    if (!struct_has_value(_problem_data, "stage", "active")) {
        remove_problem("provide_garrison");
        return;
    }

    garrisons.update();
    if (current_owner != eFACTION.IMPERIUM || !garrisons.garrison_force) {
        remove_problem("provide_garrison");
        add_disposition(-20);
        scr_popup($"Agreed Garrison of {name()}", $"your agreed garrison of  {name()} was cut short by your chapter the planetary governor has expressed his displeasure (disposition -20)", "", "");
        return;
    }

    var _mission_string = $"The garrison on {name()} has finished the period of garrison support agreed with the planetary governor.";
    var _result = garrisons.garrison_disposition_change();
    if (!garrisons.garrison_leader) {
        garrisons.find_leader();
    }

    var _effect = 0;
    if (_result == "none") {
        //TODO make a dedicated plus minus string function if there isn't one already
    } else if (_result < 0) {
        _effect = _result * irandom_range(1, 5);
        _mission_string += $"A number of diplomatic incidents occured over the period which had considerable negative effects on our disposition with the planetary governor (disposition -{_effect})";
    } else {
        _effect = _result * irandom_range(1, 5);
        _mission_string += $"As a diplomatic mission the duration of the stay was a success with our political position with the planet being enhanced greatly (disposition +{_effect})";
    }

    add_disposition(_effect);
    var tester = global.character_tester;
    var widom_test = tester.standard_test(garrisons.garrison_leader, "wisdom", 0, ["siege"]);

    if (widom_test[0]) {
        alter_fortification(1);
        _mission_string += $"while stationed {garrisons.garrison_leader.name_role()} makes several notable observations and is able to instruct the planets defense core leaving the world better defended (fortifications+1).";
    }
    //TODO just generall apply this each turn with a garrison to see if a cult is found
    if (has_feature(eP_FEATURES.GENE_STEALER_CULT)) {
        var cult = get_features(eP_FEATURES.GENE_STEALER_CULT)[0];
        if (cult.hiding) {
            widom_test = tester.standard_test(garrisons.garrison_leader, "wisdom", 0, ["tyranids"]);
            if (widom_test[0]) {
                cult.hiding = false;
                _mission_string += "Most alarmingly signs of a genestealer cult are noted by the garrison. how far the rot has gone will now need to be investigated and the xenos taint purged.";
            }
        }
    }
    scr_popup($"Agreed Garrison of {name()} complete", _mission_string, "", "");

    remove_problem("provide_garrison");
}

function complete_train_forces_mission(targ_planet, problem_index) {
    var planet = get_planet_data(targ_planet);
    if (problem_has_key_and_value(targ_planet, problem_index, "stage", "active")) {
        var man_conditions = {
            "job": "train_forces",
            "max": 1,
        };
        var _mission_string = "";
        var _trainer = collect_role_group("all", [planet.system.name, targ_planet, 0], false, man_conditions);
        if (array_length(_trainer)) {
            var _unit_report_string = "";
            var _tester = global.character_tester;
            var _wis_test_difficulty = -20;
            _trainer = _trainer[0];
            var _tyannic_vet = _trainer.has_trait("tyrannic_vet");
            if (_tyannic_vet) {
                _wis_test_difficulty += 10;
                if (planet.has_feature(eP_FEATURES.GENE_STEALER_CULT)) {
                    var _cult = planet.get_features(eP_FEATURES.GENE_STEALER_CULT)[0];
                    if (_cult.hiding) {
                        planet.delete_feature(eP_FEATURES.GENE_STEALER_CULT);
                        _mission_string += $"Fortune has smiled on this mission, {_trainer.name_role()}'s abilities as a Veteran of dealing with the Tyranids came in handy and in a short period was able to discern the existencee of a cult. He was able to organise those  he considered to be still loyal to rally an extermiation of the cult, reeports suggest he was so successful as to have completely wiped the genestealer presence from the planet";
                    }
                }
            }
            var _siege_master = _trainer.has_trait("siege_master");
            if (_siege_master) {
                _wis_test_difficulty += 10;
            }
            var _brute = _trainer.has_trait("brute");
            if (_brute) {
                _wis_test_difficulty -= 10;
            }

            var _leader = _trainer.has_trait("natural_leader");
            if (_leader) {
                _wis_test_difficulty += 10;
            }

            var _unit_pass = _tester.standard_test(_trainer, "wisdom", _wis_test_difficulty);
            if (_unit_pass[0]) {
                var _new_pdf = planet.recruit_pdf((_unit_pass[1] / 10)); //this will approximate podf improvement for the time being
                _mission_string += $"Training of the Pdf went well and improved the quality of the pdf as well as providing sizeable big recruitment improvement for the planet {_new_pdf} new pdf were recruited";
                if (_leader) {
                    var _disp_gain = 10;
                    planet.add_disposition(_disp_gain);
                    _mission_string += $"\n{_trainer.name_role()}s reputation a natural and confident leader proved well earned as he also made excellent diplomatic headway with the governor and his generals (disposition +{_disp_gain})";
                }
                if (_siege_master) {
                    _mission_string += $"{_trainer.name()}s trained eye as a Siege Master also allowed him to make several improvements to the planets fortifications (fortification +1)";
                    planet.alter_fortification(1);
                } else {
                    if (roll_dice(1, 100) > 75 && _trainer.intelligence > 45) {
                        _mission_string += $"{_trainer.name()} has proven themselves a great strategist when it comes to defensive structures beyond previousy known ";
                        var _start_stats = variable_clone(_trainer.get_stat_line());
                        _trainer.add_trait("siege_master");
                        var end_stat = _trainer.get_stat_line();
                        var _stat_diff = compare_stats(end_stat, _start_stats);
                        _unit_report_string += $"{_trainer.name_role()} Has gained the trait {global.trait_list.siege_master.display_name}, {print_stat_diffs(_stat_diff)}\n";
                        _mission_string += "The new insights have allowed for minor improvements to planetary fortifications (fortification +1)";
                        planet.alter_fortification(1);
                    }
                }
            } else {
                disp_loss = -5;
                _mission_string += "The orgional training mission was a failiure";
                if (_brute) {
                    _mission_string += "in no short part due to his brutish nature";
                }
                _mission_string += ".";

                _mission_string += "He failed to work effectively with the existing chain of command";

                if (_unit_pass[1] < -20) {
                    var _hard_loss_traits = [
                        "harshborn",
                        "feral",
                        "zealous_faith",
                        "blood_for_blood",
                        "blunt",
                        "brute",
                        "brawler",
                    ];
                    var _hard_loss = false;
                    for (var i = 0; i < array_length(_hard_loss_traits); i++) {
                        if (array_contains(_trainer.traits, _hard_loss_traits[i])) {
                            _hard_loss = true;
                        }
                    }
                    if (_hard_loss) {
                        _mission_string += $"His particularly grueling regimes and standards imposed upon the senior officers of the pdf caused friction with physical injury being caused to one officer";
                        disp_loss = -25;
                        _mission_string += "(disposition -25)";
                    }
                }
                planet.add_disposition(disp_loss);
            }
            _mission_string += $"\n{_unit_report_string}";
            scr_popup($"Training Forces on {planet.name()}", _mission_string, "", "");
            remove_planet_problem(targ_planet, "train_forces");
            _trainer.job = "none";
        }
    }
}

function complete_beast_hunt_mission(targ_planet, problem_index) {
    var planet = get_planet_data(targ_planet);
    if (problem_has_key_and_value(targ_planet, problem_index, "stage", "active")) {
        var _mission_string = "";
        var man_conditions = {
            "job": "hunt_beast",
            "max": 3,
        };
        var _hunters = collect_role_group("all", [planet.system.name, targ_planet, 0], false, man_conditions);
        var _success = false;
        var _tester = global.character_tester;
        var _unit_pass;
        var _unit;
        var _unit_report_string = "";
        var _deaths = 0;
        var _successful_hunters = [];
        if (!array_length(_hunters)) {
            remove_planet_problem(targ_planet, "hunt_beast");
            return;
        }
        for (var i = 0; i < array_length(_hunters); i++) {
            _unit = _hunters[i];
            _unit_pass = _tester.standard_test(_unit, "weapon_skill", 10, ["beast"]);
            if (_unit_pass[0]) {
                if (!_success) {
                    _success = true;
                }
            }
            if (_unit_pass[0]) {
                _unit_report_string += _unit.add_trait("beast_slayer", true, true);
                array_push(_successful_hunters, _unit);
            } else {
                var _tough_check = _tester.standard_test(_unit, "constitution", _unit.luck);
                if (!_tough_check[0]) {
                    if (_tough_check[1] < -10) {
                        _unit_report_string += $"{_unit.name_role()} Was mauled to death\n";
                        scr_kill_unit(_unit.company, _unit.marine_number);
                        _deaths++;
                    } else if (_tough_check[1] >= -10) {
                        if (irandom(100) < _unit.luck) {
                            _unit.add_or_sub_health(-100);
                            _unit_report_string += $"{_unit.name_role()} Was injured (health - 100)\n";
                        } else {
                            _unit.add_or_sub_health(-250);
                            _unit_report_string += $"{_unit.name_role()} Was Badly injured, it is unknown if he will recover (health - 250)\n";
                        }
                    }
                }
            }
            _unit.job = "none";
        }
        if (_success) {
            _mission_string = $"The mission was a success and a great number of beasts rounded up and slain, your marines were able to gain great skills and the prestige of your chapter has increased greatly across the planets populace.";
            if (_deaths) {
                _mission_string += $"Unfortunatly {_deaths} of your marines died.";
            }
            _mission_string += $"\n{_unit_report_string}";
        } else {
            _mission_string = $"The mission was a failiure. The governor is disapointed and the legend of your chapter has undoubtedly been diminished";
            _mission_string += $"\n{_unit_report_string}";
        }
        scr_popup($"Beast Hunt on {planet_numeral_name(i)}", _mission_string, "", "");
        remove_planet_problem(targ_planet, "hunt_beast");
    } else {
        remove_planet_problem(targ_planet, "hunt_beast");
    }
}

//TODO allow most of these functions to be condensed and allow arrays of problems or planets and maybe increase filtering options
//filtering options could be done via universal methods that all the filters to be passed to many other game systems
/// @self Asset.GMObject.obj_star
function has_any_problem_planet(planet, star = noone) {
    if (star == noone) {
        for (var i = 0; i < array_length(p_problem[planet]); i++) {
            if (p_problem[planet][i] != "") {
                return true;
            }
        }
    } else {
        with (star) {
            return has_any_problem_planet(planet);
        }
    }
    return false;
}

/// @self Asset.GMObject.obj_star
function planet_problemless(planet, star = noone) {
    var _problemless = true;
    if (star == noone) {
        for (var i = 0; i < array_length(p_problem[planet]); i++) {
            if (p_problem[planet][i] != "") {
                _problemless = false;
                break;
            }
        }
    } else {
        with (star) {
            _problemless = planet_problemless(planet);
        }
    }
    return _problemless;
}

// returns a bool for if any planet on a given star has the given problem
/// @self Asset.GMObject.obj_star
function has_problem_star(problem, star = noone) {
    var has_problem = false;
    if (star == noone) {
        for (var i = 1; i <= planets; i++) {
            has_problem = has_problem_planet(i, problem);
            if (has_problem) {
                has_problem = true;
                break;
            }
        }
    } else {
        with (star) {
            has_problem = has_problem_star(problem);
        }
    }
    return has_problem;
}

//returns a bool for if a planet has a given problem
/// @self Asset.GMObject.obj_star
function has_problem_planet(planet, problem, star = noone) {
    if (star == noone) {
        return array_contains(p_problem[planet], problem);
    } else {
        with (star) {
            return has_problem_planet(planet, problem);
        }
    }
}

//returns the array position of a given problem on a given planet if the specfied time is given
/// @self Asset.GMObject.obj_star
function has_problem_planet_and_time(planet, problem, time, star = noone) {
    var _had_problem = -1;
    if (star == noone) {
        for (var i = 0; i < array_length(p_problem[planet]); i++) {
            if (p_problem[planet][i] == problem) {
                if (p_timer[planet][i] == time) {
                    _had_problem = i;
                }
            }
        }
    } else {
        with (star) {
            _had_problem = has_problem_planet_and_time(planet, problem, time);
        }
    }
    return _had_problem;
}

//returns the array position of a given problem on a given planet if the specfied time is above 0
/// @self Asset.GMObject.obj_star
function has_problem_planet_with_time(planet, problem, star = noone) {
    var _had_problem = -1;
    if (star == noone) {
        for (var i = 0; i < array_length(p_problem[planet]); i++) {
            if (p_problem[planet][i] == problem) {
                if (p_timer[planet][i] > 0) {
                    _had_problem = i;
                }
            }
        }
    } else {
        with (star) {
            _had_problem = has_problem_planet_with_time(planet, problem);
        }
    }
    return _had_problem;
}

//returns the array position of a gien problem on a given planet
/// @self Asset.GMObject.obj_star
function find_problem_planet(planet, problem, star = noone) {
    if (star == noone) {
        for (var i = 0; i < array_length(p_problem[planet]); i++) {
            if (p_problem[planet][i] == problem) {
                return i;
            }
        }
    } else {
        with (star) {
            return find_problem_planet(planet, problem);
        }
    }
    return -1;
}

///removie all of a given problem from a planet
/// @self Asset.GMObject.obj_star
function remove_planet_problem(planet, problem, star = noone) {
    var _had_problem = false;
    if (star == noone) {
        for (var i = 0; i < array_length(p_problem[planet]); i++) {
            if (p_problem[planet][i] == problem) {
                p_problem[planet][i] = "";
                p_timer[planet][i] = -1;
                p_problem_other_data[planet][i] = {};
                _had_problem = true;
            }
        }
    } else {
        with (star) {
            _had_problem = remove_planet_problem(planet, problem);
        }
    }
    return _had_problem;
}

//find an open problem slot on a given planet
/// @self Asset.GMObject.obj_star
function open_problem_slot(planet, star = noone) {
    if (star == noone) {
        for (var i = 0; i < array_length(p_problem[planet]); i++) {
            if (p_problem[planet][i] == "") {
                return i;
            }
        }
    } else {
        with (star) {
            return open_problem_slot(planet);
        }
    }
    return -1;
}

//remove all of a given problem types from a star
/// @self Asset.GMObject.obj_star
function remove_star_problem(problem, star = noone) {
    if (star == noone) {
        for (var i = 1; i <= planets; i++) {
            remove_planet_problem(i, problem);
        }
    } else {
        with (star) {
            remove_star_problem(problem);
        }
    }
}

//count donw the p_timer on a given planet
/// @self Asset.GMObject.obj_star
function problem_count_down(planet, count_change = 1) {
    for (var i = 0; i < array_length(p_problem[planet]); i++) {
        if (p_problem[planet][i] != "") {
            p_timer[planet][i] -= count_change;
            if (p_timer[planet][i] == -5) {
                p_problem[planet][i] = "";
                p_timer[planet][i] = -1;
            }
        }
    }
}

//add a new problem
/// @self Asset.GMObject.obj_star
function add_new_problem(planet, problem, timer, star = noone, other_data = {}) {
    var problem_added = false;
    if (star == noone) {
        for (var i = 0; i < array_length(p_problem[planet]); i++) {
            if (p_problem[planet][i] == "") {
                p_problem[planet][i] = problem;
                p_problem_other_data[planet][i] = other_data;
                p_timer[planet][i] = timer;
                problem_added = true;
                break;
            }
        }
    } else {
        with (star) {
            problem_added = add_new_problem(planet, problem, timer, noone, other_data);
        }
    }
    return problem_added;
}

/// @self Asset.GMObject.obj_star
function increment_mission_completion(mission_data) {
    if (!struct_exists(mission_data, "completion")) {
        mission_data.completion = 0;
    }
    mission_data.completion++;
    if (!struct_exists(mission_data, "required_months") || mission_data.required_months <= 0) {
        LOGGER.error("Invalid required_months in mission_data");
        return 0;
    }
    return (mission_data.completion / mission_data.required_months) * 100;
}

//search problem data for a given and key and iff applicable value on that key
//TODO increase filtering and search options
/// @self Asset.GMObject.obj_star
function problem_has_key_and_value(planet, problem, key, value = "", star = noone) {
    var has_data = false;
    if (star == noone) {
        var problem_data = p_problem_other_data[planet][problem];
        if (struct_exists(problem_data, key)) {
            if (value == "") {
                has_data = true;
            } else if (problem_data[$ key] == value) {
                has_data = true;
            }
        }
    } else {
        with (star) {
            has_data = problem_has_key_and_value(planet, problem, key, value);
        }
    }
    return has_data;
}

/// @desc Compares two location arrays to determine if they represent the same place.
/// @param {array} _first_loc
/// @param {array} _second_loc
/// @returns {bool}
function locations_are_equal(_first_loc, _second_loc) {
    if (!is_array(_first_loc) || !is_array(_second_loc) || array_length(_first_loc) < 3 || array_length(_second_loc) < 3) {
        LOGGER.error("Attempted to compare non-array or broken location data.");
        return false;
    }

    var _first_type = _first_loc[2];
    var _second_type = _second_loc[2];
    var _not_lost = (_first_type != "Warp" && _first_type != "Lost") && (_second_type != "Warp" && _second_type != "Lost");

    if (_not_lost && (_first_type == _second_type)) {
        return true;
    }

    return (_first_loc[1] == _second_loc[1]) && (_first_loc[0] == _second_loc[0]);
}
