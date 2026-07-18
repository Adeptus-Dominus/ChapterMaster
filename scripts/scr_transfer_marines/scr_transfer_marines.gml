function draw_popup_transfer() {
    main_slate.draw_with_dimensions();
    draw_set_color(CM_GREEN_COLOR);
    draw_text(1292, 145, "Transferring");
    draw_set_font(fnt_40k_12);

    companies_select.draw();

    if (companies_select.changed) {
        target_comp = companies_select.selection_val("val");
    }

    if (cancel_button.draw()) {
        instance_destroy();
    }

    if (transfer_button.draw(target_comp != company && target_comp != -1)) {
        transfer_marines();
    }
}

function transfer_marines() {
    var vehi = 0;

    var mahreens = find_company_open_slot(target_comp);

    for (var w = 1; w < 101; w++) {
        // Gets the number of vehicles in the target company
        if (obj_ini.veh_role[target_comp][w] == "") {
            vehi = w;
            break;
        }
    }

    // The MAHREENS and TARGET/FROM seems to check out
    for (var w = 0; w < array_length(obj_controller.display_unit); w++) {
        if (obj_controller.man_sel[w] == 1) {
            if (obj_controller.man[w] == "man" && is_struct(obj_controller.display_unit[w])) {
                var moveable = true;
                var unit = obj_controller.display_unit[w];
                if (unit.squad != "none") {
                    // this evaluates if you are tryin to move a whole squad and if so moves teh squad to a new company
                    var move_squad = unit.squad;
                    var squad = fetch_squad(move_squad);
                    var move_members = squad.members;
                    for (var mem = 0; mem < array_length(move_members); mem++) {
                        //check all members have been selected and are in the same company
                        if (w + mem < array_length(obj_controller.display_unit)) {
                            if (!is_struct(obj_controller.display_unit[w + mem])) {
                                continue;
                            }
                            if (obj_controller.man_sel[w + mem] != 1 || obj_controller.display_unit[w + mem].squad != move_squad) {
                                moveable = false;
                                break;
                            }
                        } else {
                            moveable = false;
                            break;
                        }
                    }
                    //move squad
                    if (moveable) {
                        for (var mem = 0; mem < array_length(move_members); mem++) {
                            obj_controller.man_sel[w + mem] = 0;
                            var member_unit = fetch_unit(move_members[mem]);
                            scr_move_unit_info(member_unit.company, target_comp, member_unit.marine_number, mahreens, false);
                            var _unit = fetch_unit([target_comp, mahreens]);
                            _unit.squad = move_squad;
                            squad.members[mem][0] = target_comp;
                            squad.members[mem][1] = mahreens;
                            mahreens++;
                        }
                        squad.base_company = target_comp;
                    }
                } else {
                    moveable = false;
                }
                //move individual
                if (!moveable) {
                    scr_move_unit_info(unit.company, target_comp, unit.marine_number, mahreens, true);
                    mahreens++;
                }
                var check = 0;
            } else if (obj_controller.man[w] == "vehicle" && is_array(obj_controller.display_unit[w])) {
                // This seems to execute the correct number of times
                var check = 0;
                var veh_data = obj_controller.display_unit[w];
                // Check if the target company is within the allowed range
                if ((target_comp >= 1) && (target_comp <= 10)) {
                    obj_ini.veh_race[target_comp][vehi] = obj_ini.veh_race[veh_data[0]][veh_data[1]];
                    obj_ini.veh_loc[target_comp][vehi] = obj_ini.veh_loc[veh_data[0]][veh_data[1]];
                    obj_ini.veh_role[target_comp][vehi] = obj_ini.veh_role[veh_data[0]][veh_data[1]];
                    obj_ini.veh_wep1[target_comp][vehi] = obj_ini.veh_wep1[veh_data[0]][veh_data[1]];
                    obj_ini.veh_wep2[target_comp][vehi] = obj_ini.veh_wep2[veh_data[0]][veh_data[1]];
                    obj_ini.veh_wep3[target_comp][vehi] = obj_ini.veh_wep3[veh_data[0]][veh_data[1]];
                    obj_ini.veh_upgrade[target_comp][vehi] = obj_ini.veh_upgrade[veh_data[0]][veh_data[1]];
                    obj_ini.veh_acc[target_comp][vehi] = obj_ini.veh_acc[veh_data[0]][veh_data[1]];
                    obj_ini.veh_hp[target_comp][vehi] = obj_ini.veh_hp[veh_data[0]][veh_data[1]];
                    obj_ini.veh_chaos[target_comp][vehi] = obj_ini.veh_chaos[veh_data[0]][veh_data[1]];
                    obj_ini.veh_lid[target_comp][vehi] = obj_ini.veh_lid[veh_data[0]][veh_data[1]];
                    obj_ini.veh_wid[target_comp][vehi] = obj_ini.veh_wid[veh_data[0]][veh_data[1]];

                    destroy_vehicle(veh_data[0], veh_data[1]);

                    vehi++;
                }
            }
        }
    }

    // Check this

    if (obj_controller.managing > 0) {
        with (obj_controller) {
            scr_management(1);
        }
    }
    obj_ini.selected_company = company;
    obj_ini.temp_target_company = target_comp;
    with (obj_ini) {
        for (var co = 0; co < 11; co++) {
            scr_company_order(co);
            scr_vehicle_order(co);
        }
    }

    with (obj_controller) {
        // man_current=0;
        var i = -1;
        man_size = 0;
        selecting_location = "";
        selecting_types = "";
        selecting_ship = -1;

        if (obj_controller.managing > 0) {
            reset_manage_arrays();
            alll = 0;
            update_general_manage_view();
        }
    }

    with (obj_managment_panel) {
        instance_destroy();
    }

    obj_controller.cooldown = 10;
    instance_destroy();
}

function set_up_transfer_popup() {
    if (instance_number(obj_popup) > 0) {
        exit;
    }

    with (obj_controller) {
        var _first = true;
        var _marine_count = 0;
        var _vehicle_count = 0;
        var _min_exp = 99999999;
        var _allowed = true;
        var _selected_role = "None";

        // I think command_set[1] is Allow Astartes Transfer chapter option;
        var _allow_transfers = command_set[1];

        for (var f = 0; f < array_length(display_unit); f++) {
            if (!(man_sel[f] == 1)) {
                continue;
            }

            var _type = man[f];
            var _role = ma_role[f];

            if (_first) {
                if (_type == "man") {
                    _first = false;
                    _selected_role = _role;
                } else if (_type == "vehicle") {
                    _first = false;
                    _selected_role = _role;
                }
            }

            if (_type == "man") {
                _min_exp = min(_min_exp, ma_exp[f]);
                _marine_count += 1;

                if (!_allow_transfers && _allowed && !is_specialist(_role, SPECIALISTS_BRANCHES, true, false)) {
                    _allowed = false;
                }
            } else if (_type == "vehicle") {
                _vehicle_count += 1;
            }
        }

        if (!_allowed) {
            exit;
        }

        if ((_marine_count > 0) && (_vehicle_count > 0)) {
            _selected_role = "Units";
        } else if (_vehicle_count > 1) {
            _selected_role = "Vehicles";
        } else if (_marine_count > 1) {
            _selected_role = "Marines";
        }

        if (_marine_count == 0) {
            _min_exp = -1;
        }

        var pip = instance_create(0, 0, obj_popup);
        with (pip) {
            type = 5.1;
            company = obj_controller.managing;
            unit_role = _selected_role;
            units = _marine_count + _vehicle_count;
            min_exp = _min_exp;
            cancel_button = new UnitButtonObject({
                x1: 1061,
                y1: 491,
                style: "pixel",
                label: "Cancel",
            });
            main_slate = new DataSlate({
                style: "decorated",
                XX: 1006,
                YY: 143,
                set_width: true,
                width: 571,
                height: 350,
            });
            target_comp = 0; // HQ button is selected from the start, this is needed so it actually works without deselection;
            target_company_radio(min_exp);
            transfer_button = new UnitButtonObject({
                x1: 1450,
                y1: 491,
                style: "pixel",
                label: "Transfer",
            });
        }
    }
}
