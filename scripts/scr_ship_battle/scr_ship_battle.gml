/// @desc Builds the player roster for a boarding battle aboard the target ship.
/// @param {Real} target_ship_id Index into obj_ini.ship of the ship the battle is fought over.
/// @param {Real} cooridor_width Second ship index whose occupants also count as present.
/// @returns {Undefined}
function scr_ship_battle(target_ship_id, cooridor_width) {
    // determine occupants
    // determine who is fighting
    // set maximum attacks due to hallway?
    // set battle special

    // if (argument2=true){
    var sofar = 0;

    for (var co = 0; co < array_length(obj_ini.TTRPG); co++) {
        var _company_length = company_length(co);

        for (var v = 0; v < _company_length; v++) {
            var okay = 0;
            var _unit = fetch_unit([co, v]);
            if (!is_struct(_unit)) {
                continue;
            }
            if ((_unit.ship_location == target_ship_id) && _unit.hp()) {
                okay = 1;
            }
            if ((_unit.ship_location == cooridor_width) && (cooridor_width == cooridor_width) && _unit.hp()) {
                okay = 1;
            }

            if ((string_count("spyrer", obj_ncombat.battle_special) > 0) && _unit.is_dreadnought()) {
                okay = 0;
            }
            if (string_count("spyrer", obj_ncombat.battle_special) > 0) {
                if ((okay == 1) && (sofar > 2)) {
                    okay = 0;
                }
            }
            if (string_count("Aspirant", _unit.role()) > 0) {
                okay = 0;
            }

            if (okay == 0) {
                obj_ncombat.fighting[co][v] = 0;
            }
            if (okay == 1) {
                obj_ncombat.fighting[co][v] = 1;
                sofar += 1;

                var col = 0, targ = 0;

                if (_unit.role() == obj_ini.player_role_data[eROLE.SCOUT].role) {
                    col = obj_controller.bat_scout_column;
                    obj_ncombat.scouts += 1;
                }
                if (_unit.role() == obj_ini.player_role_data[eROLE.TACTICAL].role) {
                    col = obj_controller.bat_tactical_column;
                    obj_ncombat.tacticals += 1;
                }
                if (_unit.role() == obj_ini.player_role_data[eROLE.VETERAN].role) {
                    col = obj_controller.bat_veteran_column;
                    obj_ncombat.veterans += 1;
                }
                if (_unit.role() == obj_ini.player_role_data[eROLE.DEVASTATOR].role) {
                    col = obj_controller.bat_devastator_column;
                    obj_ncombat.devastators += 1;
                }
                if (_unit.role() == obj_ini.player_role_data[eROLE.ASSAULT].role) {
                    col = obj_controller.bat_assault_column;
                    obj_ncombat.assaults += 1;
                }
                if (_unit.role() == obj_ini.player_role_data[eROLE.LIBRARIAN].role) {
                    col = obj_controller.bat_librarian_column;
                    obj_ncombat.librarians += 1;
                }
                if (_unit.role() == "Codiciery") {
                    col = obj_controller.bat_librarian_column;
                    obj_ncombat.librarians += 1;
                }
                if (_unit.role() == "Epistolary") {
                    col = obj_controller.bat_librarian_column;
                    obj_ncombat.librarians += 1;
                }
                if (_unit.role() == "Lexicanum") {
                    col = obj_controller.bat_librarian_column;
                    obj_ncombat.librarians += 1;
                }
                if (_unit.role() == obj_ini.player_role_data[eROLE.TECHMARINE].role) {
                    col = obj_controller.bat_techmarine_column;
                    obj_ncombat.techmarines += 1;
                }
                if (_unit.role() == obj_ini.player_role_data[eROLE.HONOURGUARD].role) {
                    col = obj_controller.bat_honor_column;
                    obj_ncombat.honors += 1;
                }
                if (_unit.role() == obj_ini.player_role_data[eROLE.DREADNOUGHT].role) {
                    col = obj_controller.bat_dreadnought_column;
                    obj_ncombat.dreadnoughts += 1;
                }
                if (_unit.role() == "Venerable " + string(obj_ini.player_role_data[eROLE.DREADNOUGHT].role)) {
                    col = obj_controller.bat_dreadnought_column;
                    obj_ncombat.dreadnoughts += 1;
                }
                if (_unit.role() == obj_ini.player_role_data[eROLE.TERMINATOR].role) {
                    col = obj_controller.bat_terminator_column;
                    obj_ncombat.terminators += 1;
                }

                if ((_unit.role() == obj_ini.player_role_data[eROLE.APOTHECARY].role) || (_unit.role() == obj_ini.player_role_data[eROLE.CHAPLAIN].role)) {
                    if (_unit.role() == obj_ini.player_role_data[eROLE.APOTHECARY].role) {
                        obj_ncombat.apothecaries += 1;
                    }
                    if (_unit.role() == obj_ini.player_role_data[eROLE.CHAPLAIN].role) {
                        obj_ncombat.chaplains += 1;
                        if (obj_ncombat.big_mofo > 5) {
                            obj_ncombat.big_mofo = 5;
                        }
                    }

                    col = obj_controller.bat_tactical_column;
                    if (_unit.armour() == "Terminator Armour") {
                        col = obj_controller.bat_terminator_column;
                    }
                    if (_unit.armour() == "Tartaros Armour") {
                        col = obj_controller.bat_terminator_column;
                    }
                    if (co == 10) {
                        col = obj_controller.bat_scout_column;
                    }
                }

                if ((_unit.role() == obj_ini.player_role_data[eROLE.CAPTAIN].role) || (_unit.role() == obj_ini.player_role_data[eROLE.ANCIENT].role) || (_unit.role() == obj_ini.player_role_data[eROLE.CHAMPION].role)) {
                    if (_unit.role() == obj_ini.player_role_data[eROLE.CAPTAIN].role) {
                        obj_ncombat.captains += 1;
                        if (obj_ncombat.big_mofo > 5) {
                            obj_ncombat.big_mofo = 5;
                        }
                    }
                    if (_unit.role() == obj_ini.player_role_data[eROLE.ANCIENT].role) {
                        obj_ncombat.standard_bearers += 1;
                    }
                    if (_unit.role() == obj_ini.player_role_data[eROLE.CHAMPION].role) {
                        obj_ncombat.champions += 1;
                    }

                    if (co == 1) {
                        col = obj_controller.bat_veteran_column;
                        if (_unit.armour() == "Terminator Armour") {
                            col = obj_controller.bat_terminator_column;
                        }
                        if (_unit.armour() == "Tartaros Armour") {
                            col = obj_controller.bat_terminator_column;
                        }
                    }
                    if (co >= 2) {
                        col = obj_controller.bat_tactical_column;
                    }
                    if (co == 10) {
                        col = obj_controller.bat_scout_column;
                    }
                    if (_unit.mobility_item() == "Jump Pack") {
                        col = obj_controller.bat_assault_column;
                    }
                }

                if (_unit.role() == obj_ini.player_role_data[eROLE.CHAPTERMASTER].role) {
                    col = obj_controller.bat_command_column;
                    obj_ncombat.important_dudes += 1;
                    obj_ncombat.big_mofo = 1;
                }
                if (_unit.role() == "Forge Master") {
                    col = obj_controller.bat_command_column;
                    obj_ncombat.important_dudes += 1;
                }
                if (_unit.role() == "Master of Sanctity") {
                    col = obj_controller.bat_command_column;
                    obj_ncombat.important_dudes += 1;
                    if (obj_ncombat.big_mofo > 2) {
                        obj_ncombat.big_mofo = 2;
                    }
                }
                if (_unit.role() == "Master of the Apothecarion") {
                    col = obj_controller.bat_command_column;
                    obj_ncombat.important_dudes += 1;
                }
                if (_unit.role() == "Chief " + string(obj_ini.player_role_data[eROLE.LIBRARIAN].role)) {
                    col = obj_controller.bat_command_column;
                    obj_ncombat.important_dudes += 1;
                    if (obj_ncombat.big_mofo > 3) {
                        obj_ncombat.big_mofo = 3;
                    }
                }

                if (_unit.role() == "Death Company") {
                    // Ahahahahah
                    col = max(obj_controller.bat_assault_column, obj_controller.bat_command_column, obj_controller.bat_honor_column, obj_controller.bat_dreadnought_column, obj_controller.bat_veteran_column);
                }

                if (col == 0) {
                    col = obj_controller.bat_hire_column;
                }

                targ = instance_nearest(col * 10, 240, obj_pnunit);
                with (targ) {
                    scr_add_unit_to_roster(_unit);
                }
            }
        }
    }

    // }
}
