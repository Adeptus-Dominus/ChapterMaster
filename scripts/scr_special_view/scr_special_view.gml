function scr_special_view(command_group) {
    // Works as COMPANY VIEW but for the subsections of HQ

    var mans = 0, onceh, company = 0, bad = 0, oth = 0, unit;
    gogogo = 0;
    vehicles = 0;
    last_man = 0;
    last_vehicle = 0;

    var squads = 0, squad_typ = "", squad_loc = 0, squad_members = 0;

    for (var i = 0; i < 20; i++) {
        sel_uni[i] = "";
        sel_veh[i] = "";
    }
    for (var i = 0; i < 501; i++) {
        if (i <= 50) {
            penit_co[i] = 0;
            penit_id[i] = 0;
        }
    }
    reset_manage_arrays();

    mans = 0;
    vehicles = 0;
    b = 0;

    // v: check number
    // mans: number of mans that a hit has gotten

    b = 0;

    var _already_used = [];
    if ((command_group == 12) || (command_group == 0)) {
        // Apothecarion
        var apothecaries = collect_role_group([SPECIALISTS_APOTHECARIES, true]);
        for (var i = 0; i < array_length(apothecaries); i++) {
            unit = apothecaries[i];
            array_push(_already_used, unit.marine_number);
            add_man_to_manage_arrays(apothecaries[i]);
        }
    }

    if ((command_group == 13) || (command_group == 0)) {
        // Librarium
        var libs = collect_role_group([SPECIALISTS_LIBRARIANS, true]);
        for (var i = 0; i < array_length(libs); i++) {
            unit = libs[i];
            array_push(_already_used, unit.marine_number);
            add_man_to_manage_arrays(libs[i]);
        }
    }

    if ((command_group == 14) || (command_group == 0)) {
        // Reclusium
        var chaps = collect_role_group([SPECIALISTS_CHAPLAINS, true]);
        for (var i = 0; i < array_length(chaps); i++) {
            unit = chaps[i];
            array_push(_already_used, unit.marine_number);
            add_man_to_manage_arrays(chaps[i]);
        }
    }

    squads = 0;
    if ((command_group == 15) || (command_group == 0)) {
        // Armamentarium
        var techs = collect_role_group([SPECIALISTS_TECHS, true]);
        for (var i = 0; i < array_length(techs); i++) {
            unit = techs[i];
            array_push(_already_used, unit.marine_number);
            add_man_to_manage_arrays(techs[i]);
        }
    }

    if ((command_group == 16) || (command_group == 0)) {
        // Auxilia (Guardsmen and other auxiliary mercs). Gathered by role, not specialist
        // group, since they are mustered into company 0 with race IMPERIUM but are not Astartes
        // specialists. auxilia_roles() is the single source of truth shared with the HQ exclusion.
        var auxilia = collect_role_group("all", "", false, {roles: auxilia_roles()});
        for (var i = 0; i < array_length(auxilia); i++) {
            unit = auxilia[i];
            array_push(_already_used, unit.marine_number);
            add_man_to_manage_arrays(auxilia[i]);
        }
    }

    if ((command_group == 11) || (command_group == 0)) {
        //HQ units
        for (var v = 0; v < array_length(obj_ini.TTRPG[0]); v++) {
            bad = 0;
            if (obj_ini.name[0][v] == "") {
                continue;
            }
            var _unit = fetch_unit([0, v]);
            if (_unit.ship_location > -1) {
                var ham = _unit.ship_location;
                if (obj_ini.ship_location[ham] == "Lost") {
                    continue;
                }
            }

            yep = !(_unit.IsSpecialist(SPECIALISTS_TECHS) || _unit.IsSpecialist(SPECIALISTS_CHAPLAINS) || _unit.IsSpecialist(SPECIALISTS_LIBRARIANS) || _unit.IsSpecialist(SPECIALISTS_APOTHECARIES));
            // Auxilia mercs live in company 0 but belong to the Auxilia screen, not Headquarters.
            yep = yep && !array_contains(auxilia_roles(), _unit.role());
            if (yep) {
                add_man_to_manage_arrays(_unit);
            }
        }
    }

    // b=last_man;
    last_man = b;
    last_vehicle = 0;

    for (var i = 0; i < array_length(obj_ini.veh_race[company]); i++) {
        // 100
        if (obj_ini.veh_race[company][i] != 0) {
            add_vehicle_to_manage_arrays([company, i]);
        }
    }

    squads = 0;
    //TODO unify this data with other_manage_data() method
    for (var i = 0; i < array_length(display_unit); i++) {
        onceh = 0;
        var ahuh = 0;
        if (man[i] == "man") {
            if (ma_role[i] != "") {
                ahuh = 1;
            }
        }
        // Guardsman veterancy: a basic Guardsman with GUARD_VETERAN_XP banked is eligible
        // for promotion to Veteran Guard (promote_auxilia_to_veteran), so flag the row the
        // way other_manage_data does for marines: the EXP readout glows yellow with the
        // Promotion Recommended tooltip and the Promote button accepts the selection.
        // Sergeants, weapons teams, existing Veterans, and green troopers stay unflagged.
        if (man[i] == "man" && ma_role[i] == "Guardsman" && ma_exp[i] >= GUARD_VETERAN_XP) {
            ma_promote[i] = 1;
        }
        if (man[i] == "vehicle") {
            if (ma_role[i] != "") {
                ahuh = 1;
            }
        }

        if (ahuh == 1) {
            // Select All
            var go = 0, op = 0, w = 0;
            if (man[i] == "man") {
                for (w = 0; w < 20; w++) {
                    if ((sel_uni[w] == "") && (op == 0)) {
                        op = w;
                    }
                    if (sel_uni[w] == ma_role[i]) {
                        go = 1;
                    }
                }
                if (go == 0) {
                    sel_uni[op] = ma_role[i];
                }
            }
            go = 0;
            op = 0;
            if (man[i] == "vehicle") {
                for (w = 0; w < 20; w++) {
                    if ((sel_veh[w] == "") && (op == 0)) {
                        op = w;
                    }
                    if (sel_veh[w] == ma_role[i]) {
                        go = 1;
                    }
                }
                if (go == 0) {
                    sel_veh[op] = ma_role[i];
                }
            }

            // Squads
            if (squads > 0) {
                var n = 1;
                if (squad_typ == obj_ini.role[100][15]) {
                    n = 0;
                }
                if (squad_typ == obj_ini.role[100][14]) {
                    n = 0;
                }
                if (squad_typ == obj_ini.role[100][17]) {
                    n = 0;
                }
                if (squad_typ == obj_ini.role[100][16]) {
                    n = 0;
                }
                if (squad_typ == "Codiciery") {
                    n = 0;
                }
                if (squad_typ == "Lexicanum") {
                    n = 0;
                }
                if (squad_typ == ma_role[i]) {
                    n = 0;
                }
                if ((squad_typ == obj_ini.role[100][eROLE.LIBRARIAN]) && (ma_role[i] == "Codiciery")) {
                    n = 1;
                }
                if ((squad_typ == "Codiciery") && (ma_role[i] == "Lexicanum")) {
                    n = 1;
                }

                if (squad_typ == "Master of Sanctity") {
                    n = 1;
                }
                if (squad_typ == "Chief " + string(obj_ini.role[100][eROLE.LIBRARIAN])) {
                    n = 1;
                }
                if (squad_typ == "Forge Master") {
                    n = 1;
                }
                if (squad_typ == obj_ini.role[100][eROLE.CHAPTERMASTER]) {
                    n = 1;
                }
                if (squad_typ == "Master of the Apothecarion") {
                    n = 1;
                }

                if (squad_members + 1 > 10) {
                    n = 1;
                }
                if ((ma_wid[i] + (ma_lid[i] / 100)) != squad_loc) {
                    n = 1;
                }
                if (squad_typ == obj_ini.role[100][6]) {
                    n = 2;
                }

                if (n == 0) {
                    squad_members += 1;
                    squad_typ = ma_role[i];
                    squad[i] = squads;
                } else if (n == 1) {
                    squads += 1;
                    squad_members = 1;
                    squad_typ = ma_role[i];
                    squad[i] = squads;
                    squad_loc = ma_wid[i] + (ma_lid[i] / 100);
                } else if (n == 2) {
                    squad[i] = 0;
                }
            } else if (squads == 0) {
                squads += 1;
                squad_members = 1;
                squad_typ = ma_role[i];
                squad[i] = squads;
                squad_loc = ma_wid[i] + (ma_lid[i] / 100);
            }
        }
    }

    man_current = 0;
    man_max = MANAGE_MAN_MAX;
    // if (command_group=13) then man_max+=2;

    // Now have the maximum (man_last + vehicle last), the types of each of those slots, and the relevant ID
    // Should be enough to display everything else
}
