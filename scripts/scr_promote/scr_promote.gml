/// @self Id.Instance.obj_controller
function setup_promotion_popup() {
    if ((sel_promoting == 1) && (!instance_exists(obj_popup))) {
        /// @self Id.Instance.obj_popup
        var pip = instance_create(0, 0, obj_popup);
        pip.type = 5;
        pip.company = managing;
        pip.selected_for_promotion = new UnitGroup([]);

        var god = 0, nuuum = 0;
        for (var f = 0; f < array_length(display_unit); f++) {
            if (!man_sel[f] || ma_promote[f] < 1 || obj_controller.man[f] != "man"){
                continue;
            }
            var _unit = obj_controller.display_unit[f];
            if (_unit.IsSpecialist(SPECIALISTS_RANK_AND_FILE) || _unit.IsSpecialist(SPECIALISTS_SQUAD_LEADERS) ) {
                if (pip.min_exp == 0) {
                    pip.min_exp = _unit.experience;
                }
                pip.min_exp = min(_unit.experience, pip.min_exp);
            }
            if ((god == 0) ) {
                god = 1;
                pip.unit_role = ma_role[f];
            }
            pip.selected_for_promotion.push(_unit);
        }

        with (pip) {
            units = selected_for_promotion.number();
            if (units > 1){
                unit_role = "Marines";
            }
            promote_button = new UnitButtonObject({
                x1: 1450,
                y1: 491,
                style: "pixel",
                label: "Promote",
            });
            promote_button.bind_method = function() {
                units_to_move = selected_for_promotion.get_from({"stat" : [["experience", min_exp, "inmore"]]}, true, false);
                // Gets the number of marines in the target company
                var role_squad_equivilances = {}; //this is the only way to set variables as keys in gml
                variable_struct_set(role_squad_equivilances, obj_ini.player_role_data[eROLE.TACTICAL].role, "tactical_squad");
                variable_struct_set(role_squad_equivilances, obj_ini.player_role_data[eROLE.DEVASTATOR].role, "devastator_squad");
                variable_struct_set(role_squad_equivilances, obj_ini.player_role_data[eROLE.ASSAULT].role, "assault_squad");
                variable_struct_set(role_squad_equivilances, obj_ini.player_role_data[eROLE.SCOUT].role, "scout_squad");
                variable_struct_set(role_squad_equivilances, obj_ini.player_role_data[eROLE.VETERAN].role, "veteran_squad");
                variable_struct_set(role_squad_equivilances, obj_ini.player_role_data[eROLE.TERMINATOR].role, "terminator_squad");

                var _affected = {};
                for (var i = 0; i < units_to_move.number(); i++) {
                    _affected[$ string(units_to_move.units[i].company)] = true;
                }

                _affected[$ string(target_comp)] = true;

                var _squads = units_to_move.count_squads("all", true);
                units_to_move.move_to_company(target_comp, false);

                var _target_role = promote_roles[target_role].name

                for (var i = 0; i < units_to_move.number(); i++) {
                    var _unit = units_to_move.units[i];
                    _unit.update_role(_target_role);
                    _unit.alter_equipment({"wep1": req_wep1, "wep2": req_wep2, "mobi": req_mobi, "armour": req_armour, "gear": req_gear});
                }

                with (obj_controller) {
                    scr_management(1);
                }

                with (obj_ini) {
                    var _keys = struct_get_names(_affected);
                    for (var i = 0; i < array_length(_keys); i++) {
                        scr_company_order(real(_keys[i]));
                    }
                }

                with (obj_controller) {
                    // man_current=0;
                    var man_size = 0;
                    selecting_location = "";
                    selecting_types = "";
                    selecting_ship = -1;
                    reset_manage_arrays();
                    alll = 0;
                    update_general_manage_view();
                }

                with (obj_managment_panel) {
                    instance_destroy();
                }

                obj_controller.cooldown = 10;
                instance_destroy();
            };

            promote_button.bind_scope = pip;
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
            target_company_radio(min_exp);
            target_comp = 0;
            get_unit_promotion_options();
            equipment_set = {};
        }
    }
}

/// @self Id.Instance.obj_popup
function target_company_radio(min_exp = 0) {
    var _company_options = [
        {
            str1: "HQ",
            font: fnt_40k_14b,
            val: 0,
        },
    ];
    for (var i = 1; i <= obj_ini.companies; i++) {
        var _dont_add = false;
        if (obj_controller.command_set[2] == 1) {
            //cecks if exp requirements are activated
            if (min_exp < company_promote_data[i].exp) {
                _dont_add = true;
            }
        }
        if (!_dont_add || min_exp == -1) {
            array_push(_company_options, {str1: int_to_roman(i), font: fnt_40k_14b, val: i});
        }
    }
    companies_select = new RadioSet(_company_options, localize("Target Company"), {
        max_width: 500,
        x1: 1040,
        y1: 210,
    });

    companies_select.current_selection = 0;
}

/// @self Id.Instance.obj_popup
function draw_popup_promotion() {
    add_draw_return_values();
    manag = obj_controller.managing;
    if (manag > 10) {
        manag = 0;
    }
    var company = manag;
    draw_set_color(0);
    main_slate.draw_with_dimensions();

    draw_set_font(cjk_font(fnt_40k_14b));
    draw_set_halign(fa_center);
    draw_set_color(CM_GREEN_COLOR);
    draw_text(1292, 150, localize("Promoting"));
    var romanNumerals = scr_roman_numerals();

    draw_set_font(cjk_font(fnt_40k_12));
    var comp = "";
    if (company <= 10 && company > 0) {
        comp = romanNumerals[company - 1];
    } else if (company > 10) {
        comp = localize("HQ");
    }
    draw_text(1292, 175, localize("{0} Company {1}", [comp, localize(unit_role)]));

    companies_select.draw();
    if (companies_select.changed) {
        target_comp = companies_select.selection_val("val");
        target_role = -1;
        get_unit_promotion_options();
    }
    draw_set_halign(fa_left);
    draw_text(1020, 290, localize("Target Role:")); //choose new role
    var role_x = 0;
    role_y = 0;
    if (target_comp != -1) {
        for (var r = 0; r < array_length(promote_roles); r++) {
            var _name = promote_roles[r].name;
            var _data = promote_roles[r];
            if (_name != "") {
                draw_set_alpha(1);
                check = " ";
                if (target_role == r) {
                    check = "x";
                }
                if (min_exp < _data.exp) {
                    draw_set_alpha(0.25);
                }
                draw_text(1030 + role_x, 310 + role_y, localize("{0} [{1}]", [localize(_name), check]));
                if (point_and_click([1030 + role_x, 310 + role_y, 1180 + role_x, 330 + role_y])) {
                    if (min_exp >= _data.exp) {
                        target_role = r;
                        var _r_data = variable_clone(obj_ini.player_role_data[_data.role_id])
                        equipment_set = convert_equipment_struct_into_array(_r_data);
                        var _equip_data = new UnitEquipment(equipment_set);
                        all_good = _equip_data.check_set_is_equipable(units);
                    }
                }
                if (r % 3 == 0) {
                    role_y += 20;
                    role_x = 0;
                } else {
                    role_x += 170;
                }
            }
        }
    }

    draw_set_alpha(1);

    draw_text(1020, 370, localize("Required Gear:"));
    var gr = 0, tox = "";

    if (target_role > -1) {
        var _draw_x = 1030;
        var _draw_y = 390;
        var _draw_step = 20;
        for (var i = 0; i < STANDARD_EQUIP_SLOT_COUNT; i++){
            if (equipment_set[i] == ""){
                continue;
            }
            draw_set_color(all_good.equipment_found_and_valid[i] ? CM_GREEN_COLOR : c_red);
            draw_text(1030, _draw_y + (i * _draw_step), equipment_set[i]);
        }

        if (all_good.warning != ""){
            draw_set_color(c_red);
            draw_text(1030, _draw_y + (STANDARD_EQUIP_SLOT_COUNT * _draw_step), all_good.warning);
        }
    }

    if (cancel_button.draw()) {
        instance_destroy();
    }

    var _promote_able = is_struct(all_good) && struct_exists(all_good, "equipment_found_and_valid") && all_good.allow_loudout;
    promote_button.draw(_promote_able && target_role > -1);
    pop_draw_return_values();
}
