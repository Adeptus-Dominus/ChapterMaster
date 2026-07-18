// Final Screen
var part10 = "";
battle_over = 1;

alarm[8] = 999999;
var line_break = "------------------------------------------------------------------------------";

if (turn_count >= 50) {
    part1 = "Your forces make a fighting retreat \n";
}

var p_data = battle_object.get_planet_data(battle_id);
// check for wounded marines here to finish off, if defeated defending
var roles = obj_ini.role[100];
var ground_mission = instance_exists(obj_ground_mission);

with (obj_pnunit) {
    after_battle_part1();
}

if (defeat == 0) {
    marines_to_recover = ds_priority_create();
    vehicles_to_recover = ds_priority_create();

    with (obj_pnunit) {
        add_marines_to_recovery();
        add_vehicles_to_recovery();
    }

    while (!ds_priority_empty(marines_to_recover)) {
        var _candidate = ds_priority_delete_max(marines_to_recover);
        var _column_id = _candidate.column_id;
        var _unit_id = _candidate.id;
        var _unit = _candidate.unit;
        var _unit_role = _unit.role();
        var _constitution_test_mod = _unit.hp() * -1;
        var _constitution_test = global.character_tester.standard_test(_unit, "constitution", _constitution_test_mod);

        if (unit_recovery_score > 0) {
            _unit.update_health(_constitution_test[1]);
            _column_id.marine_dead[_unit_id] = false;
            unit_recovery_score--;
            units_saved_count++;

            if (!struct_exists(units_saved_counts, _unit_role)) {
                units_saved_counts[$ _unit_role] = 1;
            } else {
                units_saved_counts[$ _unit_role]++;
            }
            continue;
        }

        if (_unit.base_group == "astartes") {
            if (!_unit.gene_seed_mutations[$ "membrane"]) {
                var survival_mod = _unit.luck * -1;
                survival_mod += _unit.hp() * -1;

                var survival_test = global.character_tester.standard_test(_unit, "constitution", survival_mod);
                if (survival_test[0]) {
                    _column_id.marine_dead[_unit_id] = false;
                    injured++;
                }
            }
        }
    }
    ds_priority_destroy(marines_to_recover);

    while (!ds_priority_empty(vehicles_to_recover)) {
        var _candidate = ds_priority_delete_max(vehicles_to_recover);
        var _column_id = _candidate.column_id;
        var _vehicle_id = _candidate.id;
        var _vehicle_type = _column_id.veh_type[_vehicle_id];

        if (obj_controller.stc_bonus[3] == 4) {
            var _survival_roll = 70 + _candidate.priority;
            var _dice_roll = roll_dice_chapter(1, 100, "high");
            if ((_dice_roll >= _survival_roll) && (_column_id.veh_dead[_vehicle_id] != 2)) {
                _column_id.veh_hp[_vehicle_id] = roll_dice_chapter(1, 10, "high");
                _column_id.veh_dead[_vehicle_id] = false;
                vehicles_saved_count++;

                if (!struct_exists(vehicles_saved_counts, _vehicle_type)) {
                    vehicles_saved_counts[$ _vehicle_type] = 1;
                } else {
                    vehicles_saved_counts[$ _vehicle_type]++;
                }
                continue;
            }
        }

        if (vehicle_recovery_score > 0) {
            _column_id.veh_hp[_vehicle_id] = roll_dice_chapter(1, 10, "high");
            _column_id.veh_dead[_vehicle_id] = false;
            vehicle_recovery_score -= _candidate.priority;
            vehicles_saved_count++;

            if (!struct_exists(vehicles_saved_counts, _vehicle_type)) {
                vehicles_saved_counts[$ _vehicle_type] = 1;
            } else {
                vehicles_saved_counts[$ _vehicle_type]++;
            }
        }
    }
    ds_priority_destroy(vehicles_to_recover);
}

with (obj_pnunit) {
    after_battle_part2();
}

var _newline = "";

var _total_deaths = final_marine_deaths + final_command_deaths;
var _total_injured = _total_deaths + injured + units_saved_count;
if (_total_injured > 0) {
    _newline = $"{string_plural_count("unit", _total_injured)} {smart_verb("was", _total_injured)} critically injured.";
    combat_log.push(_newline, eMSG_COLOR.DEFAULT);

    if (units_saved_count > 0) {
        var _units_saved_string = "";
        var _unit_roles = struct_get_names(units_saved_counts);

        for (var i = 0; i < array_length(_unit_roles); i++) {
            var _unit_role = _unit_roles[i];
            var _saved_count = units_saved_counts[$ _unit_role];
            _units_saved_string += $"{string_plural_count(_unit_role, _saved_count)}";
            _units_saved_string += smart_delimeter_sign(_unit_roles, i, false);
        }

        _newline = $"{units_saved_count}x {smart_verb("was", units_saved_count)} saved by the {string_plural(roles[eROLE.APOTHECARY], apothecaries_alive)}. ({_units_saved_string})";
        combat_log.push(_newline, eMSG_COLOR.DEFAULT);
    }

    if (injured > 0) {
        _newline = $"{injured}x survived thanks to the Sus-an Membrane.";
        combat_log.push(_newline, eMSG_COLOR.DEFAULT);
    }

    if (_total_deaths > 0) {
        var _units_lost_string = "";
        var _unit_roles = struct_get_names(units_lost_counts);
        for (var i = 0; i < array_length(_unit_roles); i++) {
            var _unit_role = _unit_roles[i];
            var _lost_count = units_lost_counts[$ _unit_role];
            _units_lost_string += $"{string_plural_count(_unit_role, _lost_count)}";
            _units_lost_string += smart_delimeter_sign(_unit_roles, i, false);
        }
        _newline = $"{_total_deaths} units succumbed to their wounds! ({_units_lost_string})";
        combat_log.push(_newline, eMSG_COLOR.RED);
    }

    combat_log.push();
}

if (ground_mission) {
    if (apothecaries_alive < 0) {
        obj_ground_mission.apothecary_present = apothecaries_alive;
    }
}

if (seed_lost > 0) {
    if (obj_ini.doomed) {
        _newline = $"Chapter mutation prevents retrieving gene-seed. {seed_lost} gene-seed lost.";
    } else if (!apothecaries_alive) {
        _newline = $"No able-bodied {roles[eROLE.APOTHECARY]}. {seed_lost} gene-seed lost.";
    } else {
        seed_saved = min(seed_harvestable, apothecaries_alive * 40);
        _newline = $"{seed_saved} gene-seed was recovered; {seed_lost - seed_harvestable} was lost due damage; {seed_harvestable - seed_saved} was left to rot;";
    }

    combat_log.push(_newline, eMSG_COLOR.RED);

    if (seed_saved > 0) {
        obj_controller.gene_seed += seed_saved;
    }

    combat_log.push();
}

if (red_thirst > 2) {
    var voodoo = "";

    if (red_thirst == 3) {
        voodoo = "1 Battle Brother lost to the Red Thirst.";
    }
    if (red_thirst > 3) {
        voodoo = string(red_thirst - 2) + " Battle Brothers lost to the Red Thirst.";
    }

    _newline = voodoo;
    combat_log.push(_newline, eMSG_COLOR.RED);
    combat_log.push();
}

var _total_damaged_count = vehicle_deaths + vehicles_saved_count;
if (_total_damaged_count > 0) {
    _newline = $"{string_plural_count("vehicle", _total_damaged_count)} {smart_verb("was", _total_damaged_count)} disabled during battle.";
    combat_log.push(_newline, eMSG_COLOR.DEFAULT);

    if (vehicles_saved_count > 0) {
        var _vehicles_saved_string = "";
        var _vehicle_types = struct_get_names(vehicles_saved_counts);

        for (var i = 0; i < array_length(_vehicle_types); i++) {
            var _vehicle_type = _vehicle_types[i];
            var _saved_count = vehicles_saved_counts[$ _vehicle_type];
            _vehicles_saved_string += $"{string_plural_count(_vehicle_type, _saved_count)}";
            _vehicles_saved_string += smart_delimeter_sign(_vehicle_types, i, false);
        }

        _newline = $"{string_plural(roles[eROLE.TECHMARINE], techmarines_alive)} {smart_verb("was", techmarines_alive)} able to restore {vehicles_saved_count}. ({_vehicles_saved_string})";
        combat_log.push(_newline, eMSG_COLOR.DEFAULT);
    }

    if (vehicle_deaths > 0) {
        var _vehicles_lost_string = "";
        var _vehicle_types = struct_get_names(vehicles_lost_counts);

        for (var i = 0; i < array_length(_vehicle_types); i++) {
            var _vehicle_type = _vehicle_types[i];
            var _lost_count = vehicles_lost_counts[$ _vehicle_type];
            _vehicles_lost_string += $"{string_plural_count(_vehicle_type, _lost_count)}";
            _vehicles_lost_string += smart_delimeter_sign(_vehicle_types, i, false);
        }

        _newline = $"{vehicle_deaths} {smart_verb("was", vehicle_deaths)} lost forever. ({_vehicles_lost_string})";
        combat_log.push(_newline, eMSG_COLOR.RED);
    }

    combat_log.push();
}

if (post_equipment_lost.item_count()) {
    var _equip_text = "Equipment Lost: ";

    _equip_text += post_equipment_lost.item_description_string();
    if (ground_mission) {
        _equip_text += " Some may be recoverable.";
    }
    combat_log.push(_equip_text, eMSG_COLOR.RED);
    combat_log.push();
}

if (post_equipment_recovered.item_count()) {
    var _equip_text = $"Equipment Recovered: {post_equipment_recovered.item_description_string()}";
    combat_log.push(_equip_text, eMSG_COLOR.DEFAULT);
    combat_log.push();
}

if (total_battle_exp_gain > 0) {
    with (obj_pnunit) {
        assemble_alive_units();
    }
    average_battle_exp_gain = distribute_experience(end_alive_units, total_battle_exp_gain); // Due to cool alarm timer shitshow, I couldn't think of anything but to put it here.
    _newline = $"Each marine gained {average_battle_exp_gain} experience, reduced by their total experience.";
    combat_log.push(_newline, eMSG_COLOR.DEFAULT);

    var _upgraded_librarians_count = array_length(upgraded_librarians);
    if (_upgraded_librarians_count > 0) {
        for (var i = 0; i < _upgraded_librarians_count; i++) {
            if (i > 0) {
                _newline += ", ";
            }
            _newline += $"{upgraded_librarians[i].name_role()}";
        }
        _newline += " learned new psychic powers after gaining enough experience.";
        combat_log.push(_newline, eMSG_COLOR.DEFAULT);
    }

    combat_log.push();
}

if (ground_mission) {
    obj_ground_mission.post_equipment_lost = post_equipment_lost;
}

if (slime > 0) {
    var slime_string = $"Faulty Mucranoid and other afflictions have caused damage to the equipment. {slime} Forge Points will be allocated for repairs.";
    combat_log.push(slime_string, eMSG_COLOR.RED);
    combat_log.push();
}

instance_activate_object(obj_star);

var reduce_fortification = true;
if (battle_special == "tyranid_org") {
    reduce_fortification = false;
}
if (string_count("_attack", battle_special) > 0) {
    reduce_fortification = false;
}
if (battle_special == "ship_demon") {
    reduce_fortification = false;
}
if (enemy == eFACTION.CHAOS && threat == 7) {
    reduce_fortification = false;
}
if (battle_special == "ruins") {
    reduce_fortification = false;
}
if (battle_special == "ruins_eldar") {
    reduce_fortification = false;
}
if (battle_special == "fallen1") {
    reduce_fortification = false;
}
if (battle_special == "fallen2") {
    reduce_fortification = false;
}
if (battle_special == "study2a") {
    reduce_fortification = false;
}
if (battle_special == "study2b") {
    reduce_fortification = false;
}

if ((fortified > 0) && (!instance_exists(obj_nfort)) && (reduce_fortification == true)) {
    var _fortification_text = $"Fortification level of {p_data.name()}";
    _fortification_text += $" has decreased to {fortified - 1} ({fortified}-1)";

    combat_log.push(_fortification_text, eMSG_COLOR.DEFAULT);
    battle_object.p_fortified[battle_id] -= 1;
}

if ((!defeat) && (battle_special == "space_hulk")) {
    var enemy_power = 0, loot = 0, dicey = roll_dice_chapter(1, 100, "low");

    if (enemy == eFACTION.ORK || enemy == eFACTION.TYRANIDS || enemy == eFACTION.HERETICS) {
        enemy_power = p_data.add_forces(enemy, -1);
    }

    part10 = "Space Hulk Exploration at ";
    var ex = min(100, 100 - ((enemy_power - 1) * 20));
    part10 += string(ex) + "%";
    _newline = part10;
    combat_log.push(_newline, eMSG_COLOR.YELLOW);

    if (dicey <= (enemy_power * 10)) {
        loot = choose(1, 2, 3, 4);
        if (enemy != eFACTION.CHAOS) {
            loot = choose(1, 1, 2, 3);
        }
        hulk_treasure = loot;
        if (loot > 1) {
            _newline = "Valuable items recovered.";
        }
        if (loot == 1) {
            _newline = "Resources have been recovered.";
        }
        combat_log.push(_newline, eMSG_COLOR.YELLOW);
    }
}

if (string_count("ruins", battle_special) > 0) {
    if (defeat == 0) {
        _newline = "Ancient Ruins cleared.";
    }
    if (defeat == 1) {
        _newline = "Failed to clear Ancient Ruins.";
    }
    combat_log.push(_newline, eMSG_COLOR.YELLOW);
}

var _reduce_power = true;

// Events that should *not* reduce power
var _non_power_reduce_events = [
    "tyranid_org",
    "ship_demon",
    "space_hulk",
    "fallen1",
    "fallen2",
    "study2a",
    "study2b",
    "protect_raiders",
];

// Disable power reduction for matching events
if (array_contains(_non_power_reduce_events, battle_special)) {
    _reduce_power = false;
} else if (string_count("_attack", battle_special) > 0) {
    _reduce_power = false;
} else if (string_count("ruins", battle_special) > 0) {
    _reduce_power = false;
}

if (defeat == 0 && _reduce_power) {
    var enemy_power = 0, new_power = 0, power_reduction = 0, requisition_reward = 0;

    if (enemy == eFACTION.IMPERIUM) {
        enemy_power = battle_object.p_guardsmen[battle_id];
        battle_object.p_guardsmen[battle_id] -= threat;
    }

    if (enemy == eFACTION.ECCLESIARCHY) {
        enemy_power = battle_object.p_sisters[battle_id];
        part10 = "Ecclesiarchy";
    } else if (enemy == eFACTION.ELDAR) {
        enemy_power = battle_object.p_eldar[battle_id];
        part10 = "Eldar";
    } else if (enemy == eFACTION.ORK) {
        enemy_power = battle_object.p_orks[battle_id];
        part10 = "Ork";
    } else if (enemy == eFACTION.TAU) {
        enemy_power = battle_object.p_tau[battle_id];
        part10 = "Tau";
    } else if (enemy == eFACTION.TYRANIDS) {
        enemy_power = battle_object.p_tyranids[battle_id];
        part10 = "Tyranid";
    } else if (enemy == eFACTION.CHAOS) {
        enemy_power = battle_object.p_chaos[battle_id];
        part10 = "Heretic";
        if (threat == 7) {
            part10 = "Daemon";
        }
    } else if (enemy == eFACTION.HERETICS) {
        enemy_power = battle_object.p_traitors[battle_id];
        part10 = "Chaos Space Marine";
    } else if (enemy == eFACTION.NECRONS) {
        enemy_power = battle_object.p_necrons[battle_id];
        part10 = "Necrons";
    }

    if (instance_exists(battle_object) && (enemy_power > 2)) {
        if (awake_tomb_world(battle_object.p_feature[battle_id]) != 0) {
            scr_gov_disp(battle_object.name, battle_id, floor(enemy_power / 2));
        }
    }

    if (enemy != eFACTION.IMPERIUM) {
        if (dropping || defending) {
            power_reduction = 1;
        } else {
            power_reduction = 2;
        }
        new_power = enemy_power - power_reduction;
        new_power = max(new_power, 0);

        // Give some money for killing enemies?
        var _quad_factor = 6;
        requisition_reward = _quad_factor * sqr(threat);
        obj_controller.requisition += requisition_reward;

        //(¿?) Ramps up threat/enemy presence in case enemy Type == "Daemon" (¿?)
        //Does the inverse check/var assignment 10 lines above
        if (part10 == "Daemon") {
            new_power = 7;
        }
        if ((enemy == eFACTION.TYRANIDS) && (new_power == 0)) {
            var battle_planet = battle_id;
            with (battle_object) {
                var who_cleansed = "Tyranids";
                var who_return = "";
                var make_alert = true;
                var planet_string = $"{name} {scr_roman(battle_planet)}";
                if (planet_feature_bool(p_feature[battle_planet], eP_FEATURES.GENE_STEALER_CULT) == 1) {
                    who_cleansed = "Gene Stealer Cult";
                    make_alert = true;
                    delete_features(p_feature[battle_planet], eP_FEATURES.GENE_STEALER_CULT);
                    adjust_influence(eFACTION.TYRANIDS, -25, battle_planet, id);
                }
                if (make_alert) {
                    if (p_first[battle_planet] == eFACTION.PLAYER) {
                        who_return = "your";
                        p_owner[battle_planet] = eFACTION.PLAYER;
                    } else if (p_first[battle_planet] == eFACTION.MECHANICUS || p_type[battle_planet] == "Forge") {
                        who_return = "mechanicus";
                        obj_controller.disposition[3] += 10;
                        p_owner[battle_planet] = eFACTION.MECHANICUS;
                    } else if (p_type[battle_planet] != "Dead") {
                        who_return = "the governor";
                        if (who_cleansed == "tau") {
                            who_return = "a more suitable governer";
                        }
                        p_owner[battle_planet] = eFACTION.IMPERIUM;
                    }
                    scr_gov_disp(name, battle_planet, 10);
                    scr_event_log("", $"{who_cleansed} cleansed from {planet_string}", name);
                    scr_alert("green", "owner", $"{who_cleansed} cleansed from {planet_string}. Control returned to {who_return}", x, y);
                }
            }
        }
        if ((enemy == eFACTION.HERETICS) && (enemy_power != floor(enemy_power))) {
            enemy_power = floor(enemy_power);
        }
    }

    if ((obj_controller.blood_debt == 1) && (defeat == 0) && enemy_power > 0) {
        final_pow = min(enemy_power, 6) - 1;
        if ((enemy == eFACTION.ELDAR) || (enemy == eFACTION.TYRANIDS) || (enemy == eFACTION.HERETICS) || (enemy == eFACTION.NECRONS)) {
            obj_controller.penitent_turn = 0;
            obj_controller.penitent_turnly = 0;
            var penitent_crusade_chart = [
                25,
                62,
                95,
                190,
                375,
                750,
            ];

            final_pow = min(enemy_power, 6) - 1;
            obj_controller.penitent_current += penitent_crusade_chart[final_pow];
        } else if ((enemy == eFACTION.ORK) || (enemy == eFACTION.TAU) || (enemy == eFACTION.CHAOS)) {
            obj_controller.penitent_turn = 0;
            obj_controller.penitent_turnly = 0;
            final_pow = min(enemy_power, 7) - 1;
            var penitent_crusade_chart = [
                25,
                50,
                75,
                150,
                300,
                600,
                1500,
            ];
            obj_controller.penitent_current += penitent_crusade_chart[final_pow];
        }
    }

    if (enemy >= eFACTION.ECCLESIARCHY) {
        p_data.edit_forces(enemy, new_power);
    }

    if ((enemy != eFACTION.IMPERIUM) && (string_count("cs_meeting_battle", battle_special) == 0)) {
        part10 += $" forces on {p_data.name()}";
        if (new_power == 0) {
            part10 += $" were completely wiped out. Previous power: {enemy_power}. Reduction: {power_reduction}.";
        } else {
            part10 += $" were reduced to {new_power} after this battle. Previous power: {enemy_power}. Reduction: {power_reduction}.";
        }
        _newline = part10;
        combat_log.push(_newline, eMSG_COLOR.DEFAULT);
        part10 = $"Received {requisition_reward} requisition points as a reward for slaying enemies of the Imperium.";
        _newline = part10;
        combat_log.push(_newline, eMSG_COLOR.DEFAULT);

        if ((new_power <= 0) && (enemy_power > 0)) {
            battle_object.p_raided[battle_id] = 1;
        }
    }
    if (enemy == eFACTION.IMPERIUM) {
        part10 += $" Imperial Guard Forces on {p_data.name()}";
        part10 += " were reduced to " + string(battle_object.p_guardsmen[battle_id]) + " (" + string(enemy_power) + "-" + string(threat) + ")";
        _newline = part10;
        combat_log.push(_newline, eMSG_COLOR.DEFAULT);
    }

    if ((enemy == eFACTION.TAU) && (ethereal > 0) && (defeat == 0)) {
        _newline = "Tau Ethereal Captured";
        combat_log.push(_newline, eMSG_COLOR.YELLOW);
    }

    if (enemy == eFACTION.NECRONS && p_data.planet_forces[eFACTION.NECRONS] < 3 && awake_tomb_world(p_data.features) == 1) {
        if (plasma_bomb > 0) {
            _newline = "Plasma Bomb used to seal the Necron Tomb.";
            combat_log.push(_newline, eMSG_COLOR.YELLOW);
            seal_tomb_world(p_data.features);
        } else if (plasma_bomb <= 0) {
            p_data.edit_forces(enemy, 3);
            if (dropping) {
                _newline = "Deep Strike Ineffective; Plasma Bomb required";
            }
            if (!dropping) {
                _newline = "Attack Ineffective; Plasma Bomb required";
            }
            combat_log.push(_newline, eMSG_COLOR.RED);
        }
    }
}

if ((defeat == 0) && (enemy == eFACTION.TYRANIDS) && (battle_special == "tyranid_org")) {
    _newline = $"{string_plural_count("Gaunt organism", captured_gaunt)} have been captured.";
    combat_log.push(_newline, eMSG_COLOR.YELLOW);

    if (captured_gaunt > 0) {
        var why = 0, thatta = 0;
        instance_activate_object(obj_star);
        with (obj_star) {
            remove_star_problem("tyranid_org");
        }
    }

    scr_event_log("", "Inquisition Mission Completed: A Gaunt organism has been captured for the Inquisition.");

    if (captured_gaunt > 1) {
        if (instance_exists(obj_turn_end)) {
            scr_popup("Inquisition Mission Completed", "You have captured several Gaunt organisms.  The Inquisitor is pleased with your work, though she notes that only one is needed- the rest are to be purged.  It will be stored until it may be retrieved.  The mission is a success.", "inquisition", "");
        }
    }
    if (captured_gaunt == 1) {
        if (instance_exists(obj_turn_end)) {
            scr_popup("Inquisition Mission Completed", "You have captured a Gaunt organism- the Inquisitor is pleased with your work.  The Tyranid will be stored until it may be retrieved.  The mission is a success.", "inquisition", "");
        }
    }
    instance_deactivate_object(obj_star);
}

_newline = line_break;
combat_log.push(_newline, eMSG_COLOR.DEFAULT);
_newline = line_break;
combat_log.push(_newline, eMSG_COLOR.DEFAULT);

if ((leader || ((battle_special == "ChaosWarband") && (!obj_controller.faction_defeated[10]))) && (!defeat)) {
    var nep = false;
    _newline = "The enemy Leader has been killed!";
    combat_log.push(_newline, eMSG_COLOR.YELLOW);
    _newline = line_break;
    combat_log.push(_newline, eMSG_COLOR.DEFAULT);
    _newline = line_break;
    combat_log.push(_newline, eMSG_COLOR.DEFAULT);
    instance_activate_object(obj_event_log);
    if (enemy == eFACTION.ECCLESIARCHY) {
        scr_event_log("", "Enemy Leader Assassinated: Ecclesiarchy Prioress");
    }
    if (enemy == eFACTION.ELDAR) {
        scr_event_log("", "Enemy Leader Assassinated: Eldar Farseer");
    }
    if (enemy == eFACTION.ORK) {
        scr_event_log("", "Enemy Leader Assassinated: Ork Warboss");
        if (instance_exists(Warlord)) {
            with (Warlord) {
                kill_warboss();
            }
        }
    }
    if (enemy == eFACTION.TAU) {
        scr_event_log("", "Enemy Leader Assassinated: Tau Diplomat");
    }
    if (enemy == eFACTION.CHAOS) {
        scr_event_log("", "Enemy Leader Assassinated: Chaos Lord");
    }
}

var endline = 1;
var inq_eated = false;

if (obj_ini.omophagea) {
    var eatme = roll_dice_chapter(1, 100, "high");
    if ((enemy == eFACTION.NECRONS) || (enemy == eFACTION.TYRANIDS) || (battle_special == "ship_demon")) {
        eatme += 100;
    }
    if ((enemy == eFACTION.CHAOS) && (battle_object.p_chaos[battle_id] == 7)) {
        eatme += 200;
    }

    if (red_thirst == 3) {
        thirsty = 1;
    }
    if (red_thirst > 3) {
        thirsty = red_thirst - 2;
    }
    if (thirsty > 0) {
        eatme -= thirsty * 6;
    }
    if (really_thirsty > 0) {
        eatme -= really_thirsty * 15;
    }

    if (allies > 0) {
        alter_dispositions([[eFACTION.IMPERIUM, -choose(1, 0, 0)], [eFACTION.INQUISITION, -choose(0, 0, 1)], [eFACTION.ECCLESIARCHY, -choose(0, 0, 1)]]);
    }
    if (present_inquisitor > 0) {
        alter_disposition(eFACTION.INQUISITION, -4);
    }

    if (eatme <= 25) {
        endline = 0;
        if (!thirsty && !really_thirsty) {
            var ran;
            ran = choose(1, 2);
            _newline = "One of your marines slowly makes his way towards the fallen enemies, as if in a spell.  Once close enough the helmet is removed and he begins shoveling parts of their carcasses into his mouth.";
            _newline = "Two marines are sharing a quick discussion, and analysis of the battle, when one of the two suddenly drops down and begins shoveling parts of enemy corpses into his mouth.";
            _newline += choose("  Bone snaps and pops.", "  Strange-colored blood squirts from between his teeth.", "  Veins and tendons squish wetly.");
        }
        if ((thirsty > 0) && (really_thirsty == 0)) {
            var ran = choose(1, 2);
            _newline = "One of your Death Company marines slowly makes his way towards the fallen enemies, as if in a spell.  Once close enough the helmet is removed and he begins shoveling parts of their carcasses into his mouth.";
            _newline = "A marine is observing and communicating with a Death Company marine, to ensure they are responsive, when that Death Company marine drops down and suddenly begins shoveling parts of enemy corpses into his mouth.";
            _newline += choose("  Bone snaps and pops.", "  Strange-colored blood squirts from between his teeth.", "  Veins and tendons squish wetly.");
        }
        if (really_thirsty > 0) {
            _newline = $"One of your Death Company {roles[6]} blitzes to the fallen enemy lines.  Massive mechanical hands begin to rend and smash at the fallen corpses, trying to squeeze their flesh and blood through the sarcophogi opening.";
        }

        _newline += $"  Almost at once most of the present {global.chapter_name} follow suit, joining in and starting a massive feeding frenzy.  The sight is gruesome to behold.";
        combat_log.push(_newline, eMSG_COLOR.RED);

        // check for pdf/guardsmen
        eatme = roll_dice_chapter(1, 100, "high");
        if ((eatme <= 10) && (allies > 0)) {
            obj_controller.disposition[2] -= 2;
            if (allies == 1) {
                _newline = "Local PDF have been eaten!";
                combat_log.push(_newline, eMSG_COLOR.RED);
            } else if (allies == 2) {
                _newline = "Local Guardsmen have been eaten!";
                combat_log.push(_newline, eMSG_COLOR.RED);
            }
        }

        // check for inquisitor
        eatme = roll_dice_chapter(1, 100, "high");
        if ((eatme <= 40) && (present_inquisitor == 1)) {
            obj_controller.disposition[4] -= 10;
            inq_eated = true;
            instance_activate_object(obj_en_fleet);

            if (instance_exists(inquisitor_ship)) {
                repeat (2) {
                    scr_loyalty("Inquisitor Killer", "+");
                }
                if (obj_controller.loyalty >= 85) {
                    obj_controller.last_inquisitor_inspection -= 44;
                }
                if ((obj_controller.loyalty >= 70) && (obj_controller.loyalty < 85)) {
                    obj_controller.last_inquisitor_inspection -= 32;
                }
                if ((obj_controller.loyalty >= 50) && (obj_controller.loyalty < 70)) {
                    obj_controller.last_inquisitor_inspection -= 20;
                }
                if (obj_controller.loyalty < 50) {
                    scr_loyalty("Inquisitor Killer", "+");
                }

                var msg = "";
                var remove = 0;
                // if (string_count("Inqis",inquisitor_ship.trade_goods)>0) then show_message("B");
                if (inquisitor_ship.inquisitor > 0) {
                    var inquis_name = obj_controller.inquisitor[inquisitor_ship.inquisitor];
                    _newline = $"Inquisitor {inquis_name} has been eaten!";
                    msg = $"Inquisitor {inquis_name}";
                    remove = obj_controller.inquisitor[inquisitor_ship.inquisitor];
                    scr_event_log("red", $"Your Astartes consume {msg}.");
                }
                combat_log.push(_newline, eMSG_COLOR.RED);
                if (obj_controller.inquisitor_type[remove] == "Ordo Hereticus") {
                    scr_loyalty("Inquisitor Killer", "+");
                }

                var i = remove;
                repeat (10 - remove) {
                    if (i < 10) {
                        obj_controller.inquisitor_gender[i] = obj_controller.inquisitor_gender[i + 1];
                        obj_controller.inquisitor_type[i] = obj_controller.inquisitor_type[i + 1];
                        obj_controller.inquisitor[i] = obj_controller.inquisitor[i + 1];
                    }
                    if (i == 10) {
                        obj_controller.inquisitor_gender[i] = choose(0, 0, 0, 1, 1, 1, 1); // 4:3 chance of male Inquisitor
                        obj_controller.inquisitor_type[i] = choose("Ordo Malleus", "Ordo Xenos", "Ordo Hereticus", "Ordo Hereticus", "Ordo Hereticus", "Ordo Hereticus", "Ordo Hereticus", "Ordo Hereticus");
                        //TODO swap out for correctly gendered name gen
                        obj_controller.inquisitor[i] = global.name_generator.GenerateFromSet($"imperial_male"); // For 'random inquisitor wishes to inspect your fleet
                    }
                    i += 1;
                }

                instance_activate_object(obj_turn_end);
                if (obj_controller.known[eFACTION.INQUISITION] < 3) {
                    scr_event_log("red", "EXCOMMUNICATUS TRAITORUS");
                    obj_controller.alarm[8] = 1;
                    if (!instance_exists(obj_turn_end)) {
                        var pip = instance_create(0, 0, obj_popup);
                        pip.title = "Inquisitor Killed";
                        pip.text = msg;
                        pip.image = "inquisition";
                        pip.cooldown = 30;
                        pip.title = "EXCOMMUNICATUS TRAITORUS";
                        pip.text = $"The Inquisition has noticed your uncalled CONSUMPTION of {msg} and declared your chapter Excommunicatus Traitorus.";
                        instance_deactivate_object(obj_popup);
                    } else {
                        scr_popup("Inquisitor Killed", $"The Inquisition has noticed your uncalled CONSUMPTION of {msg} and declared your chapter Excommunicatus Traitorus.", "inquisition", "");
                    }
                }
                instance_deactivate_object(obj_turn_end);

                with (inquisitor_ship) {
                    instance_destroy();
                }
                with (obj_ground_mission) {
                    instance_destroy();
                }
            }
            instance_deactivate_object(obj_star);
            instance_deactivate_object(obj_en_fleet);
        }
    }
}

if ((inq_eated == false) && (sorcery_seen >= 2)) {
    scr_loyalty("Use of Sorcery", "+");
    _newline = "Inquisitor " + string(obj_controller.inquisitor[1]) + " witnessed your Chapter using sorcery.";
    scr_event_log("green", string(_newline));
    combat_log.push(_newline, eMSG_COLOR.RED);
}

if ((exterminatus > 0) && dropping) {
    _newline = "Exterminatus has been succesfully placed.";
    endline = 0;
    combat_log.push(_newline, eMSG_COLOR.YELLOW);
}

instance_activate_object(obj_star);
instance_activate_object(obj_turn_end);

//If not fleet based and...
if ((obj_ini.fleet_type != ePLAYER_BASE.HOME_WORLD) && (defeat == 1) && !dropping) {
    var monastery_list = search_planet_features(battle_object.p_feature[battle_id], eP_FEATURES.MONASTERY);
    var monastery_count = array_length(monastery_list);
    if (monastery_count > 0) {
        for (var mon = 0; mon < monastery_count; mon++) {
            battle_object.p_feature[battle_id][monastery_list[mon]].status = "destroyed";
        }

        if (obj_controller.und_gene_vaults == 0) {
            _newline = "Your Fortress Monastery has been raided.  " + string(obj_controller.gene_seed) + " Gene-Seed has been destroyed or stolen.";
        }
        if (obj_controller.und_gene_vaults > 0) {
            _newline = "Your Fortress Monastery has been raided.  " + string(floor(obj_controller.gene_seed / 10)) + " Gene-Seed has been destroyed or stolen.";
        }

        scr_event_log("red", _newline, battle_object.name);
        instance_activate_object(obj_event_log);
        combat_log.push(_newline, eMSG_COLOR.RED);

        var lasers_lost, defenses_lost, silos_lost;
        lasers_lost = 0;
        defenses_lost = 0;
        silos_lost = 0;

        if (player_defenses > 0) {
            defenses_lost = round(player_defenses * 0.75);
        }
        if (battle_object.p_silo[battle_id] > 0) {
            silos_lost = round(battle_object.p_silo[battle_id] * 0.75);
        }
        if (battle_object.p_lasers[battle_id] > 0) {
            lasers_lost = round(battle_object.p_lasers[battle_id] * 0.75);
        }

        if (player_defenses < 30) {
            defenses_lost = player_defenses;
        }
        if (battle_object.p_silo[battle_id] < 30) {
            silos_lost = battle_object.p_silo[battle_id];
        }
        if (battle_object.p_lasers[battle_id] < 8) {
            lasers_lost = battle_object.p_lasers[battle_id];
        }

        var percent = 0;
        _newline = "";
        if (defenses_lost > 0) {
            percent = round((defenses_lost / player_defenses) * 100);
            _newline = string(defenses_lost) + " Weapon Emplacements have been lost (" + string(percent) + "%).";
        }
        if (silos_lost > 0) {
            percent = round((silos_lost / battle_object.p_silo[battle_id]) * 100);
            if (defenses_lost > 0) {
                _newline += "  ";
            }
            _newline += string(silos_lost) + $" Missile Silos have been lost ({percent}%).";
        }
        if (lasers_lost > 0) {
            percent = round((lasers_lost / battle_object.p_lasers[battle_id]) * 100);
            if ((silos_lost > 0) || (defenses_lost > 0)) {
                _newline += "  ";
            }
            _newline += string(lasers_lost) + " Defense Lasers have been lost (" + string(percent) + "%).";
        }

        battle_object.p_defenses[battle_id] -= defenses_lost;
        battle_object.p_silo[battle_id] -= silos_lost;
        battle_object.p_lasers[battle_id] -= lasers_lost;
        if (defenses_lost + silos_lost + lasers_lost > 0) {
            combat_log.push(_newline, eMSG_COLOR.RED);
        }

        endline = 0;

        if (obj_controller.und_gene_vaults == 0) {
            //all Gene Pod Incubators and gene seed are lost
            destroy_all_gene_slaves(false);
        }
        if (obj_controller.und_gene_vaults > 0) {
            obj_controller.gene_seed -= floor(obj_controller.gene_seed / 10);
        }
    }
}
instance_deactivate_object(obj_star);
instance_deactivate_object(obj_turn_end);

if (endline == 0) {
    _newline = line_break;
    combat_log.push(_newline, eMSG_COLOR.DEFAULT);
    _newline = line_break;
    combat_log.push(_newline, eMSG_COLOR.DEFAULT);
}

if (defeat == 1) {
    player_forces = 0;
    if (ground_mission) {
        obj_ground_mission.recoverable_gene_seed = seed_lost;
    }
}

instance_deactivate_object(obj_star);
instance_deactivate_object(obj_ground_mission);

LOGGER.debug($"{started}");
