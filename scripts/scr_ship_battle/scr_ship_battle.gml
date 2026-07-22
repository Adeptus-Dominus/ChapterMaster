function scr_ship_battle(target_ship_id, cooridor_width) {
    // determine occupants
    // determine who is fighting
    // set maximum attacks due to hallway?
    // set battle special

    // if (argument2=true){
    var co, v, stop, okay, sofar, unit;
    co = 0;
    v = 0;
    stop = 0;
    okay = 0;
    sofar = 0;

    repeat (3600) {
        if (co < 11) {
            v += 1;
            okay = 0;

            if (v > 300) {
                co += 1;
                v = 1;
            }

            if (co > 10) {
                stop = 1;
            }

            if (stop == 0) {
                if (obj_ini.name[co][v] == "") {
                    continue;
                }
                unit = obj_ini.TTRPG[co][v];
                if ((unit.ship_location == target_ship_id) && unit.hp()) {
                    okay = 1;
                }
                if ((unit.ship_location == cooridor_width) && (cooridor_width == cooridor_width) && unit.hp()) {
                    okay = 1;
                }

                if ((string_count("spyrer", obj_ncombat.battle_special) > 0) && ((obj_ini.role[co][v] == obj_ini.role[100][6]) || (unit.role() == "Venerable " + string(obj_ini.role[100][6])))) {
                    okay = 0;
                }
                if (string_count("spyrer", obj_ncombat.battle_special) > 0) {
                    if ((okay == 1) && (sofar > 2)) {
                        okay = 0;
                    }
                }
                if (string_count("Aspirant", obj_ini.role[co][v]) > 0) {
                    okay = 0;
                }

                if (okay == 0) {
                    obj_ncombat.fighting[co][v] = 0;
                }
                if (okay == 1) {
                    obj_ncombat.fighting[co][v] = 1;
                    sofar += 1;

                    var col = 0, targ = 0;
                    var ftype = "";

                    if (unit.role() == obj_ini.role[100][12]) {
                        col = obj_controller.bat_scout_column;
                        ftype = "scout";
                        obj_ncombat.scouts += 1;
                    }
                    if (unit.role() == obj_ini.role[100][8]) {
                        col = obj_controller.bat_tactical_column;
                        ftype = "tactical";
                        obj_ncombat.tacticals += 1;
                    }
                    if (unit.role() == obj_ini.role[100][3]) {
                        col = obj_controller.bat_veteran_column;
                        ftype = "veteran";
                        obj_ncombat.veterans += 1;
                    }
                    if (unit.role() == obj_ini.role[100][9]) {
                        col = obj_controller.bat_devastator_column;
                        ftype = "devastator";
                        obj_ncombat.devastators += 1;
                    }
                    if (unit.role() == obj_ini.role[100][10]) {
                        col = obj_controller.bat_assault_column;
                        ftype = "assault";
                        obj_ncombat.assaults += 1;
                    }
                    if (unit.role() == obj_ini.role[100][17]) {
                        col = obj_controller.bat_librarian_column;
                        ftype = "librarian";
                        obj_ncombat.librarians += 1;
                    }
                    if (unit.role() == "Codiciery") {
                        col = obj_controller.bat_librarian_column;
                        ftype = "librarian";
                        obj_ncombat.librarians += 1;
                    }
                    if (unit.role() == "Epistolary") {
                        col = obj_controller.bat_librarian_column;
                        ftype = "librarian";
                        obj_ncombat.librarians += 1;
                    }
                    if (unit.role() == "Lexicanum") {
                        col = obj_controller.bat_librarian_column;
                        ftype = "librarian";
                        obj_ncombat.librarians += 1;
                    }
                    if (unit.role() == obj_ini.role[100][16]) {
                        col = obj_controller.bat_techmarine_column;
                        ftype = "techmarine";
                        obj_ncombat.techmarines += 1;
                    }
                    if (unit.role() == obj_ini.role[100][2]) {
                        col = obj_controller.bat_honor_column;
                        ftype = "honor";
                        obj_ncombat.honors += 1;
                    }
                    if (unit.role() == obj_ini.role[100][6]) {
                        col = obj_controller.bat_dreadnought_column;
                        ftype = "dreadnought";
                        obj_ncombat.dreadnoughts += 1;
                    }
                    if (unit.role() == "Venerable " + string(obj_ini.role[100][6])) {
                        col = obj_controller.bat_dreadnought_column;
                        ftype = "dreadnought";
                        obj_ncombat.dreadnoughts += 1;
                    }
                    if (unit.role() == obj_ini.role[100][4]) {
                        col = obj_controller.bat_terminator_column;
                        ftype = "terminator";
                        obj_ncombat.terminators += 1;
                    }

                    if ((unit.role() == obj_ini.role[100][15]) || (unit.role() == obj_ini.role[100][14])) {
                        if (unit.role() == obj_ini.role[100][15]) {
                            obj_ncombat.apothecaries += 1;
                        }
                        if (unit.role() == obj_ini.role[100][14]) {
                            obj_ncombat.chaplains += 1;
                            if (obj_ncombat.big_mofo > 5) {
                                obj_ncombat.big_mofo = 5;
                            }
                        }

                        col = obj_controller.bat_tactical_column;
                        ftype = "tactical";
                        if (obj_ini.armour[co][v] == "Terminator Armour") {
                            col = obj_controller.bat_terminator_column;
                            ftype = "terminator";
                        }
                        if (obj_ini.armour[co][v] == "Tartaros Armour") {
                            col = obj_controller.bat_terminator_column;
                            ftype = "terminator";
                        }
                        if (co == 10) {
                            col = obj_controller.bat_scout_column;
                            ftype = "scout";
                        }
                    }

                    if ((unit.role() == obj_ini.role[100][5]) || (unit.role() == obj_ini.role[100][11]) || (unit.role() == obj_ini.role[100][7])) {
                        if (unit.role() == obj_ini.role[100][5]) {
                            obj_ncombat.captains += 1;
                            if (obj_ncombat.big_mofo > 5) {
                                obj_ncombat.big_mofo = 5;
                            }
                        }
                        if (unit.role() == obj_ini.role[100][11]) {
                            obj_ncombat.standard_bearers += 1;
                        }
                        if (unit.role() == obj_ini.role[100][7]) {
                            obj_ncombat.champions += 1;
                        }

                        if (co == 1) {
                            col = obj_controller.bat_veteran_column;
                            ftype = "veteran";
                            if (obj_ini.armour[co][v] == "Terminator Armour") {
                                col = obj_controller.bat_terminator_column;
                                ftype = "terminator";
                            }
                            if (obj_ini.armour[co][v] == "Tartaros Armour") {
                                col = obj_controller.bat_terminator_column;
                                ftype = "terminator";
                            }
                        }
                        if (co >= 2) {
                            col = obj_controller.bat_tactical_column;
                            ftype = "tactical";
                        }
                        if (co == 10) {
                            col = obj_controller.bat_scout_column;
                            ftype = "scout";
                        }
                        if (obj_ini.mobi[co][v] == "Jump Pack") {
                            col = obj_controller.bat_assault_column;
                            ftype = "assault";
                        }
                    }

                    if (unit.role() == obj_ini.role[100][eROLE.CHAPTERMASTER]) {
                        col = obj_controller.bat_command_column;
                        ftype = "command";
                        obj_ncombat.important_dudes += 1;
                        obj_ncombat.big_mofo = 1;
                    }
                    if (unit.role() == "Forge Master") {
                        col = obj_controller.bat_command_column;
                        ftype = "command";
                        obj_ncombat.important_dudes += 1;
                    }
                    if (unit.role() == "Master of Sanctity") {
                        col = obj_controller.bat_command_column;
                        ftype = "command";
                        obj_ncombat.important_dudes += 1;
                        if (obj_ncombat.big_mofo > 2) {
                            obj_ncombat.big_mofo = 2;
                        }
                    }
                    if (unit.role() == "Master of the Apothecarion") {
                        col = obj_controller.bat_command_column;
                        ftype = "command";
                        obj_ncombat.important_dudes += 1;
                    }
                    if (unit.role() == "Chief " + string(obj_ini.role[100][17])) {
                        col = obj_controller.bat_command_column;
                        ftype = "command";
                        obj_ncombat.important_dudes += 1;
                        if (obj_ncombat.big_mofo > 3) {
                            obj_ncombat.big_mofo = 3;
                        }
                    }

                    if (unit.role() == "Death Company") {
                        // Ahahahahah
                        col = max(obj_controller.bat_assault_column, obj_controller.bat_command_column, obj_controller.bat_honor_column, obj_controller.bat_dreadnought_column, obj_controller.bat_veteran_column);
                        ftype = "deathco";
                    }

                    if (col == 0) {
                        col = obj_controller.bat_hire_column;
                        ftype = "hire";
                    }

                    targ = formation_block(ftype, col);
                    with (targ) {
                        scr_add_unit_to_roster(unit);
                    }
                }
            }
        }
    }

    // }
}
