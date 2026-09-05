function scr_civil_roster(_unit_location, _target_location, _is_planet) {
    // Determines who all will be present for the battle
    // Only used on the Chaos Space Marines(?) meeting battle (not sure if its implemented)

    // argument 0 : planet or ship name
    // argument 1 : world number (wid)
    // argument 2 : is it a planet?  boolean

    //--------------------------------------------------------------------------------------------------------------------
    // Global objects used.
    //--------------------------------------------------------------------------------------------------------------------
    var new_combat = obj_ncombat;
    //???=obj_drop_select;
    //???=obj_controller
    //???=obj_pnunit
    //???=obj_enunit
    //???=obj_centerline
    //--------------------------------------------------------------------------------------------------------------------

    var stop, okay, sofar;
    stop = 0;
    okay = 0;
    sofar = 0;

    // Formation here

    obj_controller.bat_devastator_column = obj_controller.bat_deva_for[new_combat.formation_set];
    obj_controller.bat_assault_column = obj_controller.bat_assa_for[new_combat.formation_set];
    obj_controller.bat_tactical_column = obj_controller.bat_tact_for[new_combat.formation_set];
    obj_controller.bat_veteran_column = obj_controller.bat_vete_for[new_combat.formation_set];
    obj_controller.bat_hire_column = obj_controller.bat_hire_for[new_combat.formation_set];
    obj_controller.bat_librarian_column = obj_controller.bat_libr_for[new_combat.formation_set];
    obj_controller.bat_command_column = obj_controller.bat_comm_for[new_combat.formation_set];
    obj_controller.bat_techmarine_column = obj_controller.bat_tech_for[new_combat.formation_set];
    obj_controller.bat_terminator_column = obj_controller.bat_term_for[new_combat.formation_set];
    obj_controller.bat_honor_column = obj_controller.bat_hono_for[new_combat.formation_set];
    obj_controller.bat_dreadnought_column = obj_controller.bat_drea_for[new_combat.formation_set];
    obj_controller.bat_rhino_column = obj_controller.bat_rhin_for[new_combat.formation_set];
    obj_controller.bat_predator_column = obj_controller.bat_pred_for[new_combat.formation_set];
    obj_controller.bat_landraider_column = obj_controller.bat_landraid_for[new_combat.formation_set];
    obj_controller.bat_landspeeder_column = obj_controller.bat_landspee_for[new_combat.formation_set];
    obj_controller.bat_whirlwind_column = obj_controller.bat_whirl_for[new_combat.formation_set];
    obj_controller.bat_scout_column = obj_controller.bat_scou_for[new_combat.formation_set];

    var co, v, meeting, he_good, _unit;
    co = 0;
    v = 0;
    meeting = true;
    he_good = false;

    instance_activate_object(obj_pnunit);
    instance_activate_object(obj_enunit);
    instance_activate_object(obj_centerline);

    if (new_combat.enemy == 1) {
        var i, u;
        i = 11;
        repeat (10) {
            i -= 1; // This creates the objects to then be filled in
            u = instance_create(110 + (i * 10), 240, obj_enunit);
        }
    }

    instance_activate_object(obj_enunit);

    repeat (300) {
        v += 1;
        he_good = 0;

        if (instance_exists(obj_temp_meeting)) {
            if (v > obj_temp_meeting.dudes) {
                stop = 1;
            }
        }

        if (stop == 0) {
            if ((!instance_exists(obj_drop_select)) && instance_exists(obj_temp_meeting)) {
                meeting = true;
                if ((co == 0) && (v <= obj_temp_meeting.dudes)) {
                    if (obj_temp_meeting.present[v] == 1) {
                        okay = 1;
                    }
                }
                if (co > 0) {
                    okay = 0;
                }
                if (v > obj_temp_meeting.dudes) {
                    okay = 0;
                }
            }

            if (okay >= 1) {
                var cooh, va;
                cooh = 0;
                va = 0;

                if (meeting == false) {
                    cooh = co;
                    va = v;
                }
                if (meeting == true) {
                    if (v <= obj_temp_meeting.dudes) {
                        cooh = obj_temp_meeting.co[v];
                        va = obj_temp_meeting.ide[v];
                    }
                }
                _unit = fetch_unit([cooh, va]);
                if (!is_struct(_unit)) {
                    continue;
                }

                // Chaos corruption check here
                if (new_combat.battle_special == "cs_meeting_battle1") {
                    if (_unit.corruption >= 30) {
                        new_combat.fighting[cooh][va] = 1;
                    }
                    if (_unit.corruption < 30) {
                        new_combat.fighting[cooh][va] = -5;
                    }
                    if (_unit.role() == "Master of Sanctity") {
                        new_combat.fighting[cooh][va] = -5;
                    }
                }
                if (new_combat.battle_special == "cs_meeting_battle2") {
                    if (_unit.corruption >= 3) {
                        new_combat.fighting[cooh][va] = 0;
                    }
                    if (_unit.corruption < 3) {
                        new_combat.fighting[cooh][va] = -5;
                    }
                    if (_unit.role() == "Master of Sanctity") {
                        new_combat.fighting[cooh][va] = -5;
                    }
                }
                if (new_combat.battle_special == "cs_meeting_battle5") {
                    new_combat.fighting[cooh][va] = 1;
                }
                if (new_combat.battle_special == "cs_meeting_battle6") {
                    new_combat.fighting[cooh][va] = 1;
                }
                if (new_combat.battle_special == "cs_meeting_battle7") {
                    if (_unit.role() != obj_ini.player_role_data[eROLE.CHAPTERMASTER].role) {
                        new_combat.fighting[cooh][va] = -5;
                    }
                }

                if (_unit.role() == obj_ini.player_role_data[eROLE.CHAPTERMASTER].role) {
                    new_combat.fighting[cooh][va] = 1;
                }
                if (new_combat.fighting[cooh][va] == 1) {
                    he_good = 1;
                }
                if (new_combat.fighting[cooh][va] == -5) {
                    he_good = -1;
                }

                if (he_good == -1) {
                    // show_message("enemy marine found");

                    var col, moov, targ;
                    col = 0;
                    targ = 0;
                    moov = 0;

                    if (_unit.role() == obj_ini.player_role_data[eROLE.SCOUT].role) {
                        col = 22 - obj_controller.bat_scout_column;
                        new_combat.en_scouts += 1;
                    }
                    if (_unit.role() == obj_ini.player_role_data[eROLE.TACTICAL].role) {
                        col = 22 - obj_controller.bat_tactical_column;
                        new_combat.en_tacticals += 1;
                    }
                    if (_unit.role() == obj_ini.player_role_data[eROLE.VETERAN].role) {
                        col = 22 - obj_controller.bat_veteran_column;
                        new_combat.en_veterans += 1;
                    }
                    if (_unit.role() == obj_ini.player_role_data[eROLE.DEVASTATOR].role) {
                        col = 22 - obj_controller.bat_devastator_column;
                        new_combat.en_devastators += 1;
                    }
                    if (_unit.role() == obj_ini.player_role_data[eROLE.ASSAULT].role) {
                        col = 22 - obj_controller.bat_assault_column;
                        new_combat.en_assaults += 1;
                    }
                    if (_unit.role() == obj_ini.player_role_data[eROLE.LIBRARIAN].role) {
                        col = 22 - obj_controller.bat_librarian_column;
                        new_combat.en_librarians += 1;
                        moov = 1;
                    }
                    if (_unit.role() == string(obj_ini.player_role_data[eROLE.LIBRARIAN].role) + " Aspirant") {
                        col = 22 - obj_controller.bat_librarian_column;
                        new_combat.en_librarians += 1;
                        moov = 1;
                    }

                    if (_unit.role() == "Codiciery") {
                        col = 22 - obj_controller.bat_librarian_column;
                        new_combat.en_librarians += 1;
                        moov = 1;
                    }
                    if (_unit.role() == "Epistolary") {
                        col = 22 - obj_controller.bat_librarian_column;
                        new_combat.en_librarians += 1;
                        moov = 1;
                    }
                    if (_unit.role() == "Lexicanum") {
                        col = 22 - obj_controller.bat_librarian_column;
                        new_combat.en_librarians += 1;
                        moov = 1;
                    }
                    if (_unit.role() == obj_ini.player_role_data[eROLE.TECHMARINE].role) {
                        col = 22 - obj_controller.bat_techmarine_column;
                        new_combat.en_techmarines += 1;
                        moov = 2;
                    }

                    if (_unit.role() == obj_ini.player_role_data[eROLE.HONOURGUARD].role) {
                        col = 22 - obj_controller.bat_honor_column;
                        new_combat.en_honors += 1;
                    }
                    if (_unit.role() == obj_ini.player_role_data[eROLE.DREADNOUGHT].role) {
                        col = 22 - obj_controller.bat_dreadnought_column;
                        new_combat.en_dreadnoughts += 1;
                    }
                    if (_unit.role() == "Venerable " + string(obj_ini.player_role_data[eROLE.DREADNOUGHT].role)) {
                        col = 22 - obj_controller.bat_dreadnought_column;
                        new_combat.en_dreadnoughts += 1;
                    }
                    if (_unit.role() == obj_ini.player_role_data[eROLE.TERMINATOR].role) {
                        col = 22 - obj_controller.bat_terminator_column;
                        new_combat.en_terminators += 1;
                    }

                    if (moov > 0) {
                        if (((moov == 1) && (obj_controller.command_set[8] == 1)) || ((moov == 2) && (obj_controller.command_set[9] == 1))) {
                            if (co >= 2) {
                                col = 22 - obj_controller.bat_tactical_column;
                            }
                            if (co == 10) {
                                col = 22 - obj_controller.bat_scout_column;
                            }
                            if (_unit.mobility_item() == "Jump Pack") {
                                col = 22 - obj_controller.bat_assault_column;
                            }
                        }
                    }

                    if ((_unit.role() == obj_ini.player_role_data[eROLE.APOTHECARY].role) || (_unit.role() == obj_ini.player_role_data[eROLE.CHAPLAIN].role) || (string_count("Aspirant", _unit.role()) > 0)) {
                        if (_unit.role() == string(obj_ini.player_role_data[eROLE.APOTHECARY].role) + " Aspirant") {
                            col = 22 - obj_controller.bat_tactical_column;
                            new_combat.en_tacticals += 1;
                        }
                        if (_unit.role() == string(obj_ini.player_role_data[eROLE.CHAPLAIN].role) + " Aspirant") {
                            col = 22 - obj_controller.bat_tactical_column;
                            new_combat.en_tacticals += 1;
                        }

                        if (_unit.role() == obj_ini.player_role_data[eROLE.APOTHECARY].role) {
                            new_combat.en_apothecaries += 1;
                        }
                        if (_unit.role() == obj_ini.player_role_data[eROLE.CHAPLAIN].role) {
                            new_combat.en_chaplains += 1;
                            if (new_combat.en_big_mofo > 5) {
                                new_combat.en_big_mofo = 5;
                            }
                        }

                        col = 22 - obj_controller.bat_tactical_column;

                        if (_unit.armour() == "Terminator Armour") {
                            col = 22 - obj_controller.bat_terminator_column;
                        }
                        if (_unit.armour() == "Tartaros Armour") {
                            col = 22 - obj_controller.bat_terminator_column;
                        }

                        if (co == 10) {
                            col = 22 - obj_controller.bat_scout_column;
                        }
                    }

                    if ((_unit.role() == obj_ini.player_role_data[eROLE.CAPTAIN].role) || (_unit.role() == obj_ini.player_role_data[eROLE.ANCIENT].role) || (_unit.role() == obj_ini.player_role_data[eROLE.CHAMPION].role)) {
                        if (_unit.role() == obj_ini.player_role_data[eROLE.CAPTAIN].role) {
                            new_combat.en_captains += 1;
                            if (new_combat.en_big_mofo > 5) {
                                new_combat.en_big_mofo = 5;
                            }
                        }
                        if (_unit.role() == obj_ini.player_role_data[eROLE.ANCIENT].role) {
                            new_combat.en_standard_bearers += 1;
                        }
                        if (_unit.role() == obj_ini.player_role_data[eROLE.CHAMPION].role) {
                            new_combat.champions += 1;
                        }

                        if (co == 1) {
                            col = 22 - obj_controller.bat_veteran_column;

                            if (_unit.armour() == "Terminator Armour") {
                                col = 22 - obj_controller.bat_terminator_column;
                            }
                            if (_unit.armour() == "Tartaros Armour") {
                                col = 22 - obj_controller.bat_terminator_column;
                            }
                        }
                        if (co >= 2) {
                            col = 22 - obj_controller.bat_tactical_column;
                        }
                        if (co == 10) {
                            col = 22 - obj_controller.bat_scout_column;
                        }
                        if (_unit.mobility_item() == "Jump Pack") {
                            col = 22 - obj_controller.bat_assault_column;
                        }
                    }

                    if (_unit.role() == "Forge Master") {
                        col = 22 - obj_controller.bat_command_column;
                    }
                    if (_unit.role() == "Master of Sanctity") {
                        col = 22 - obj_controller.bat_command_column;
                        if (new_combat.en_big_mofo > 2) {
                            new_combat.en_big_mofo = 2;
                        }
                    }
                    if (_unit.role() == "Master of the Apothecarion") {
                        col = 22 - obj_controller.bat_command_column;
                    }
                    if (_unit.role() == "Chief " + string(obj_ini.player_role_data[eROLE.LIBRARIAN].role)) {
                        col = 22 - obj_controller.bat_command_column;
                        if (new_combat.en_big_mofo > 3) {
                            new_combat.en_big_mofo = 3;
                        }
                    }

                    if (col == 0) {
                        col = 22 - obj_controller.bat_hire_column;
                    }

                    // show_message("enemy marine being placed in column "+string(col));

                    /// @type {Asset.GMObject.obj_enunit}
                    targ = instance_nearest(col * 10, 240, obj_enunit);

                    var t, first_openz;
                    t = 0;
                    first_openz = 0;
                    repeat (700) {
                        t += 1;
                        if (first_openz == 0) {
                            if ((targ.dudes[t] == "") && (first_openz == 0)) {
                                first_openz = t;
                            }
                        }
                    }

                    targ.men += 1;
                    targ.dude_co[targ.men] = cooh;
                    targ.dude_id[targ.men] = va;
                    targ.dudes[targ.men] = _unit.role();
                    targ.dudes_num[targ.men] = 1;
                    targ.dudes_hp[targ.men] = _unit.hp();
                    targ.dudes_exp[targ.men] = _unit.experience;
                    targ.dudes_powers[targ.men] = _unit.specials;
                    targ.dudes_wep1[targ.men] = _unit.weapon_one();
                    targ.dudes_wep2[targ.men] = _unit.weapon_two();
                    targ.dudes_gear[targ.men] = _unit.gear();
                    targ.dudges_mobi[targ.men] = _unit.mobility_item();

                    new_combat.enemy_forces += 1;
                    new_combat.enemy_max += 1;

                    var dr;
                    dr = 0;
                    dr = 0.7 - ((targ.dudes_exp[targ.men] * targ.dudes_exp[targ.men]) / 40000);
                    if (targ.dudes_gear[targ.men] == "Rosarius") {
                        dr -= 0.33;
                    }
                    if (targ.dudes_gear[targ.men] == "Iron Halo") {
                        dr -= 0.33;
                    }
                    if (targ.dudges_mobi[targ.men] == "Jump Pack") {
                        dr -= 0.1;
                    }
                    if (dr < 0.25) {
                        dr = 0.25;
                    }
                    targ.dudes_dr[targ.men] = dr;

                    if (_unit.role() == "Death Company") {
                        // Ahahahahah
                        var really;
                        really = false;

                        really = _unit.is_dreadnought();
                        col = min(22 - obj_controller.bat_assault_column, 22 - obj_controller.bat_command_column, 22 - obj_controller.bat_honor_column, 22 - obj_controller.bat_dreadnought_column, 22 - obj_controller.bat_veteran_column);
                    }

                    // todo find out what more targ.dudes does, relevant to targ.men?
                    var _armour_data = _unit.get_armour_data();
                    if (is_struct(_armour_data)) {
                        targ.dudes_ac += _armour_data.armour_value;
                        arg.dudes_ranged += _armour_data.ranged_mod / 100;
                        arg.dudes_attack += _armour_data.melee_mod / 100;
                    }

                    if (_unit.weapon_one() == "Boarding Shield") {
                        targ.dudes_ac[targ.men] += 4;
                    }
                    if (_unit.weapon_two() == "Boarding Shield") {
                        targ.dudes_ac[targ.men] += 4;
                    }
                    if (_unit.weapon_one() == "Storm Shield") {
                        targ.dudes_ac[targ.men] += 8;
                    }
                    if (_unit.weapon_two() == "Storm Shield") {
                        targ.dudes_ac[targ.men] += 8;
                    }

                    if (string_count("&", _unit.armour()) > 0) {
                        // Artifact armour
                        if (string_count("Power", _unit.armour()) > 0) {
                            targ.dudes_ac[targ.men] = 30;
                        }
                        if (string_count("Artificer", _unit.armour()) > 0) {
                            targ.dudes_ac[targ.men] = 37;
                            targ.dudes_attack[targ.men] += 0.1;
                        }
                        if (string_count("Terminator", _unit.armour()) > 0) {
                            targ.dudes_ac[targ.men] = 46;
                            targ.dudes_ranged[targ.men] -= 0.1;
                            targ.dudes_attack[targ.men] += 0.2;
                        }
                        if (string_count("Dreadnought", _unit.armour()) > 0) {
                            targ.dudes_ac[targ.men] = 44;
                        }
                    }
                    if (_unit.armour() != "") {
                        // STC Bonuses

                        if (obj_controller.stc_bonus[1] == 5) {
                            if (targ.dudes_ac[targ.men] >= 40) {
                                targ.dudes_ac[targ.men] += 2;
                            }
                            if (targ.dudes_ac[targ.men] < 40) {
                                targ.dudes_ac[targ.men] += 1;
                            }
                        }
                        if (obj_controller.stc_bonus[2] == 3) {
                            if (targ.dudes_ac[targ.men] >= 40) {
                                targ.dudes_ac[targ.men] += 2;
                            }
                            if (targ.dudes_ac[targ.men] < 40) {
                                targ.dudes_ac[targ.men] += 1;
                            }
                        }
                    }

                    if ((_unit.role() == obj_ini.player_role_data[eROLE.DREADNOUGHT].role) || (_unit.role() == "Venerable " + string(obj_ini.player_role_data[eROLE.DREADNOUGHT].role))) {
                        targ.dudes_hp[targ.men] = targ.dudes_hp[targ.men] * 2;
                        targ.dreads += 1;
                    }
                    if (_unit.mobility_item() == "Bike") {
                        targ.dudes_hp[targ.men] += 25;
                    }
                    if (_unit.weapon_one() == "Boarding Shield") {
                        targ.dudes_hp[targ.men] += 20;
                    }
                    if (_unit.weapon_two() == "Boarding Shield") {
                        targ.dudes_hp[targ.men] += 20;
                    }
                    if (_unit.weapon_one() == "Storm Shield") {
                        targ.dudes_hp[targ.men] += 30;
                    }
                    if (_unit.weapon_two() == "Storm Shield") {
                        targ.dudes_hp[targ.men] += 30;
                    }
                    if (_unit.weapon_two() == "Iron Halo") {
                        targ.dudes_hp[targ.men] += 20;
                    }

                    // show_message("target block now has "+string(targ.men)+" men, dudes1:"+string(targ.dudes[1]));
                }

                if (he_good == 1) {
                    sofar += 1;
                    var col, moov, targ;
                    col = 0;
                    targ = 0;
                    moov = 0;

                    if (new_combat.battle_special == "space_hulk") {
                        new_combat.player_starting_dudes += 1;
                    }

                    if (_unit.role() == obj_ini.player_role_data[eROLE.SCOUT].role) {
                        col = obj_controller.bat_scout_column;
                        new_combat.scouts += 1;
                    }
                    if (_unit.role() == obj_ini.player_role_data[eROLE.TACTICAL].role) {
                        col = obj_controller.bat_tactical_column;
                        new_combat.tacticals += 1;
                    }
                    if (_unit.role() == obj_ini.player_role_data[eROLE.VETERAN].role) {
                        col = obj_controller.bat_veteran_column;
                        new_combat.veterans += 1;
                    }
                    if (_unit.role() == obj_ini.player_role_data[eROLE.DEVASTATOR].role) {
                        col = obj_controller.bat_devastator_column;
                        new_combat.devastators += 1;
                    }
                    if (_unit.role() == obj_ini.player_role_data[eROLE.ASSAULT].role) {
                        col = obj_controller.bat_assault_column;
                        new_combat.assaults += 1;
                    }
                    if (_unit.role() == obj_ini.player_role_data[eROLE.LIBRARIAN].role) {
                        col = obj_controller.bat_librarian_column;
                        new_combat.librarians += 1;
                        moov = 1;
                    }
                    if (_unit.role() == string(obj_ini.player_role_data[eROLE.LIBRARIAN].role) + " Aspirant") {
                        col = obj_controller.bat_librarian_column;
                        new_combat.librarians += 1;
                        moov = 1;
                    }

                    if (_unit.role() == "Codiciery") {
                        col = obj_controller.bat_librarian_column;
                        new_combat.librarians += 1;
                        moov = 1;
                    }
                    if (_unit.role() == "Epistolary") {
                        col = obj_controller.bat_librarian_column;
                        new_combat.librarians += 1;
                        moov = 1;
                    }
                    if (_unit.role() == "Lexicanum") {
                        col = obj_controller.bat_librarian_column;
                        new_combat.librarians += 1;
                        moov = 1;
                    }
                    if (_unit.role() == obj_ini.player_role_data[eROLE.TECHMARINE].role) {
                        col = obj_controller.bat_techmarine_column;
                        new_combat.techmarines += 1;
                        moov = 2;
                    }

                    if (_unit.role() == obj_ini.player_role_data[eROLE.HONOURGUARD].role) {
                        col = obj_controller.bat_honor_column;
                        new_combat.honors += 1;
                    }
                    if (_unit.role() == obj_ini.player_role_data[eROLE.DREADNOUGHT].role) {
                        col = obj_controller.bat_dreadnought_column;
                        new_combat.dreadnoughts += 1;
                    }
                    if (_unit.role() == "Venerable " + string(obj_ini.player_role_data[eROLE.DREADNOUGHT].role)) {
                        col = obj_controller.bat_dreadnought_column;
                        new_combat.dreadnoughts += 1;
                    }
                    if (_unit.role() == obj_ini.player_role_data[eROLE.TERMINATOR].role) {
                        col = obj_controller.bat_terminator_column;
                        new_combat.terminators += 1;
                    }

                    if (moov > 0) {
                        if (((moov == 1) && (obj_controller.command_set[8] == 1)) || ((moov == 2) && (obj_controller.command_set[9] == 1))) {
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
                    }

                    if ((_unit.role() == obj_ini.player_role_data[eROLE.APOTHECARY].role) || (_unit.role() == obj_ini.player_role_data[eROLE.CHAPLAIN].role) || (string_count("Aspirant", _unit.role()) > 0)) {
                        if (_unit.role() == string(obj_ini.player_role_data[eROLE.APOTHECARY].role) + " Aspirant") {
                            col = obj_controller.bat_tactical_column;
                            new_combat.tacticals += 1;
                        }
                        if (_unit.role() == string(obj_ini.player_role_data[eROLE.CHAPLAIN].role) + " Aspirant") {
                            col = obj_controller.bat_tactical_column;
                            new_combat.tacticals += 1;
                        }

                        if (_unit.role() == obj_ini.player_role_data[eROLE.APOTHECARY].role) {
                            new_combat.apothecaries += 1;
                        }
                        if (_unit.role() == obj_ini.player_role_data[eROLE.CHAPLAIN].role) {
                            new_combat.chaplains += 1;

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
                            new_combat.captains += 1;
 
                        }
                        if (_unit.role() == obj_ini.player_role_data[eROLE.ANCIENT].role) {
                            new_combat.standard_bearers += 1;
                        }
                        if (_unit.role() == obj_ini.player_role_data[eROLE.CHAMPION].role) {
                            new_combat.champions += 1;
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
                        if (string_count("0", _unit.specials) > 0) {
                            new_combat.chapter_master_psyker = 1;
                        } else {
                            new_combat.chapter_master_psyker = 0;
                        }
                    }
                    if (_unit.role() == "Forge Master") {
                        col = obj_controller.bat_command_column;
                    }
                    if (_unit.role() == "Master of Sanctity") {
                        col = obj_controller.bat_command_column;

                    }
                    if (_unit.role() == "Master of the Apothecarion") {
                        col = obj_controller.bat_command_column;
                    }
                    if (_unit.role() == "Chief " + string(obj_ini.player_role_data[eROLE.LIBRARIAN].role)) {
                        col = obj_controller.bat_command_column;
                    }

                    if (col == 0) {
                        col = obj_controller.bat_hire_column;
                    }

                    /// @type {Asset.GMObject.obj_pnunit}
                    targ = instance_nearest(col * 10, 240, obj_pnunit);
                    targ.men += 1;
                    targ.unit_struct[targ.men] = _unit;
                    targ.marine_co[targ.men] = _unit.company;
                    targ.marine_id[targ.men] = v;
                    targ.marine_type[targ.men] = _unit.role();
                    targ.marine_wep1[targ.men] = _unit.weapon_one();
                    targ.marine_wep2[targ.men] = _unit.weapon_two();
                    targ.marine_armour[targ.men] = _unit.armour();
                    targ.marine_gear[targ.men] = _unit.gear();
                    targ.marine_mobi[targ.men] = _unit.mobility_item();
                    targ.marine_hp[targ.men] = _unit.hp();
                    targ.marine_exp[targ.men] = _unit.experience;
                    targ.marine_powers[targ.men] = _unit.specials;
                    targ.marine_ranged[targ.men] = _unit.ranged_attack();
                    targ.marine_ac[targ.men] = _unit.armour_calc();
                    targ.marine_attack[targ.men] = _unit.melee_attack();

                    if (okay == 2) {
                        targ.marine_local[targ.men] = 1;
                    }

                    if (_unit.role() == "Death Company") {
                        // Ahahahahah
                        var really = false;

                        if (string_count("Dreadnought", targ.marine_armour[targ.men]) > 0) {
                            really = true;
                        }
                        if (really == false) {
                            obj_ncombat.thirsty++;
                        }
                        if (really == true) {
                            obj_ncombat.really_thirsty++;
                        }

                        col = max(obj_controller.bat_assault_column, obj_controller.bat_command_column, obj_controller.bat_honor_column, obj_controller.bat_dreadnought_column, obj_controller.bat_veteran_column);
                    }
                }
            }
        }
    }

    instance_activate_object(obj_enunit);
    if (instance_exists(obj_enunit) && instance_exists(obj_pnunit)) {
        var leftest_en, rightest_pla;
        leftest_en = instance_nearest(0, 240, obj_enunit);
        rightest_pla = instance_nearest(5000, 240, obj_pnunit);
        repeat (30) {
            if (leftest_en.x > rightest_pla.x + 10) {
                with (obj_enunit) {
                    x -= 10;
                }
            }
        }
    }
    if (_is_planet == 1) {
        // Small chance of ship going critical if loyalists are loosing
        // Boosted chance if shitty luck
    }
}
