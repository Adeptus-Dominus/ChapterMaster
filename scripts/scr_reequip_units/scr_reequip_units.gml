enum eEQUIP_TARGET_TYPE {
    NONE = 0,
    MARINE = 1,
    DREADNOUGHT,
    LAND_RAIDER = 50,
    RHINO = 51,
    PREDATOR = 52,
    LAND_SPEEDER = 53,
    WHIRLWIND = 54,
}

/// @self Asset.GMObject.obj_controller
function set_up_equip_popup() {
    static setup_UI_elements = function() {
        equipment_area = -1;
        cancel_button = new UnitButtonObject({
            x1: 1061,
            y1: 591,
            style: "pixel",
            label: "Cancel",
        });
        equip_button = new UnitButtonObject({
            x1: 1450,
            y1: 591,
            style: "pixel",
            label: "Equip",
        });

        main_slate = new DataSlate({
            style: "decorated",
            XX: 1006,
            YY: 143,
            set_width: true,
            width: 571,
            height: 450,
        });

        var _quality_options = [
            {
                str1: "Standard",
                font: fnt_40k_14b,
                val: 0,
            },
            {
                str1: "Master Crafted",
                font: fnt_40k_14b,
                val: 1,
            },
        ];
        quality_radio = new RadioSet(_quality_options, "", {
            max_width: 500,
            x1: 1040,
            y1: 318,
        });

        range_melee_radio = new RadioSet([
            {
                str1: "Ranged",
                font: fnt_40k_14b,
                val: eENGAGEMENT.RANGED,
            },
            {
                str1: "Melee",
                font: fnt_40k_14b,
                val: eENGAGEMENT.MELEE,
            },
        ], "", {
            max_width: 500,
            x1: 1040,
            y1: 343,
        });

        weapon1_select = new UnitButtonObject({
            x1: 1300,
            y1: 215,
            label: "",
            font: fnt_40k_12,
        });
        weapon2_select = new UnitButtonObject({
            x1: 1300,
            y1: 235,
            label: "",
            font: fnt_40k_12,
        });
        armour_select = new UnitButtonObject({
            x1: 1300,
            y1: 255,
            label: "",
            font: fnt_40k_12,
        });
        if (unchangeable_armour) {
            armour_select.inactive_col = CM_RED_COLOR;
            armour_select.tooltip = "One or more Marine has Dreadnought armour and cannot be changed";
            armour_select.active = false;
        }
        gear_select = new UnitButtonObject({
            x1: 1300,
            y1: 275,
            label: "",
            font: fnt_40k_12,
        });
        mobility_select = new UnitButtonObject({
            x1: 1300,
            y1: 295,
            label: "",
            font: fnt_40k_12,
        });
        selectors = [
            weapon1_select,
            weapon2_select,
            armour_select,
            gear_select,
            mobility_select,
        ];
    };

    if (instance_exists(obj_popup)) {
        return;
    }

    var _units_selected_for_change = 0;
    var equip_target_type = eEQUIP_TARGET_TYPE.NONE, _unit;
    var company = managing <= 10 ? managing : 10;
    var prev_role;
    var allow = true;

    var _current_equipment = [
        "",
        "",
        "",
        "",
        "",
    ];

    var _unchangeable_armour = false;
    // Need to make sure that group selected is all the same type
    for (var f = 0; f < array_length(display_unit); f++) {
        // Set different equip_target_type depending on _unit type
        if (!man_sel[f]) {
            continue;
        }
        if (equip_target_type == eEQUIP_TARGET_TYPE.NONE) {
            if (man[f] == "man" && is_struct(display_unit[f])) {
                _unit = display_unit[f];
                equip_target_type = _unit.is_dreadnought() ? eEQUIP_TARGET_TYPE.DREADNOUGHT : eEQUIP_TARGET_TYPE.MARINE;
                if (equip_target_type == eEQUIP_TARGET_TYPE.DREADNOUGHT) {
                    _unchangeable_armour = true;
                }
            } else if (man[f] == "vehicle") {
                if (ma_role[f] == "Land Raider") {
                    equip_target_type = eEQUIP_TARGET_TYPE.LAND_RAIDER;
                } else if (ma_role[f] == "Rhino") {
                    equip_target_type = eEQUIP_TARGET_TYPE.RHINO;
                } else if (ma_role[f] == "Predator") {
                    equip_target_type = eEQUIP_TARGET_TYPE.PREDATOR;
                } else if (ma_role[f] == "Land Speeder") {
                    equip_target_type = eEQUIP_TARGET_TYPE.LAND_SPEEDER;
                } else if (ma_role[f] == "Whirlwind") {
                    equip_target_type = eEQUIP_TARGET_TYPE.WHIRLWIND;
                }
                prev_role = ma_role[f];
            }
        } else {
            if (equip_target_type == eEQUIP_TARGET_TYPE.MARINE || equip_target_type == eEQUIP_TARGET_TYPE.DREADNOUGHT) {
                if (man[f] == "vehicle") {
                    allow = false;
                    break;
                } else if (man[f] == "man" && is_struct(display_unit[f])) {
                    _unit = display_unit[f];
                    var _is_dread = _unit.is_dreadnought();
                    if (_is_dread && equip_target_type == eEQUIP_TARGET_TYPE.MARINE) {
                        allow = false;
                        break;
                    } else if (!_is_dread && equip_target_type == eEQUIP_TARGET_TYPE.DREADNOUGHT) {
                        allow = false;
                        break;
                    }
                }
            } else if (equip_target_type >= 50) {
                if (man[f] == "man") {
                    allow = false;
                    break;
                } else if (man[f] == "vehicle") {
                    if (prev_role != ma_role[f]) {
                        allow = false;
                        break;
                    }
                }
            }
        }

        if (equip_target_type > 0) {
            _units_selected_for_change += 1;
            var _unit_equipment = new UnitEquipment([obj_controller.ma_wep1[f], obj_controller.ma_wep2[f], obj_controller.ma_armour[f], obj_controller.ma_gear[f], obj_controller.ma_mobi[f]]);

            for (var i = 0; i < STANDARD_EQUIP_SLOT_COUNT; i++) {
                var _item_name = _unit_equipment.item_names[i];

                var _no_item = _item_name == "";

                if (_no_item && _current_equipment[i] == "") {
                    continue;
                }

                var _is_assortment = _current_equipment[i] == "Assortment";

                if (_is_assortment) {
                    continue;
                }

                if (_current_equipment[i] == "") {
                    _current_equipment[i] = _item_name;
                } else if (_current_equipment[i] != _item_name) {
                    _current_equipment[i] = "Assortment";
                }
            }
        }
    }
    for (var i = 0; i < STANDARD_EQUIP_SLOT_COUNT; i++) {
        if (_current_equipment[i] == "" || _current_equipment[i] == 0) {
            _current_equipment[i] = ITEM_NAME_NONE;
        }
    }

    if (equip_target_type > 0 && man_size > 0 && allow) {
        var pip = instance_create(0, 0, obj_popup);
        pip.type = ePOPUP_TYPE.EQUIP;
        pip.current_equipment = _current_equipment;
        pip.needed_equipment = _current_equipment;
        pip.equipment_found_and_valid = array_create(5, true);
        pip.company = managing;
        pip.unit_count = _units_selected_for_change;
        pip.unchangeable_armour = _unchangeable_armour;
        pip.sprite_index = noone;

        //Forwards equip_target_type selection to the equipment_recipient_type variable used in mouse_50 obj_popup and weapons_equip script
        pip.equipment_recipient_type = equip_target_type;
        with (pip) {
            setup_UI_elements();
        }
    }
}

/// @self Asset.GMObject.obj_popup
function reload_items() {
    item_name = [];
    scr_get_item_names(
        item_name,
        equipment_recipient_type, // eROLE
        equipment_area, // slot
        range_melee_radio.selection_val("val"),
        false, // include company standard
        true, // limit to available equipment
        quality_radio.selection_val("val"),
    );
}

/// @self Asset.GMObject.obj_popup
function draw_popup_equip() {
    main_slate.draw_with_dimensions();
    draw_set_color(CM_GREEN_COLOR);
    draw_text(1302, 150, "Change Equipment");

    draw_set_font(fnt_40k_12);
    var comp = "";
    if (company <= 10 && company > 0) {
        comp = int_to_roman(company);
    } else if (company > 10) {
        comp = "HQ";
    }

    //TODO calc once and store in reactive string
    var _descriptor = "Marines";
    if (equipment_recipient_type == eEQUIP_TARGET_TYPE.DREADNOUGHT) {
        _descriptor = "Dreadnoughts";
    } else if (equipment_recipient_type > eEQUIP_TARGET_TYPE.DREADNOUGHT) {
        _descriptor = "Vehicles";
    }
    draw_text(1292, 175, $"{comp} Company, {unit_count} {_descriptor}");

    draw_set_halign(fa_left);
    draw_set_color(CM_GREEN_COLOR);

    var show_name = "";
    // Need to not show the artifact tags here somehow

    draw_text_outline(1020, 195, "Before");

    for (var i = 0; i < STANDARD_EQUIP_SLOT_COUNT; i++) {
        var _current = current_equipment[i];
        if (_current == "") {
            _current = ITEM_NAME_NONE;
        }
        draw_text(1024, 215 + (i * 20), _current);
    }

    draw_text_outline(1296, 195, "After");

    for (var i = 0; i < STANDARD_EQUIP_SLOT_COUNT; i++) {
        var _selector = selectors[i];
        var _needed = needed_equipment[i];
        _needed = _needed != "" ? _needed : ITEM_NAME_NONE;
        var _colour = equipment_found_and_valid[i] ? CM_GREEN_COLOR : CM_RED_COLOR;
        _selector.update({label: _needed, color: _colour});
    }

    draw_set_color(CM_GREEN_COLOR);

    var _area_change = false;
    for (var i = 0; i < STANDARD_EQUIP_SLOT_COUNT; i++) {
        var _button = selectors[i];
        if (_button.draw(equipment_area != i)) {
            equipment_area = i;
            _area_change = true;
        }
        if (equipment_area == i) {
            draw_text(1292, 195 + (20 * (i + 1)), "->");
        }
    }

    draw_set_alpha(1);

    if (equipment_area != -1) {
        var check = " ";
        var mct = master_crafted == 1 ? 0.7 : 1;
        var column = 0;
        var row = 0;
        var item_string;
        var box = [];
        var box_x;
        var box_y;
        var top = -1;

        for (var o = 0; o < array_length(item_name); o++) {
            box_x = 1016 + (row * 154);
            box_y = 380 + (column * 20);
            box = [
                box_x,
                box_y,
                box_x + 144,
                box_y + 20,
            ];
            check = needed_equipment[equipment_area] == item_name[o] ? "x" : " ";
            item_string = $"[{check}] {item_name[o]}";
            draw_text_transformed(box_x, box_y, item_string, mct, 1, 0);
            if (scr_hit(box)) {
                tooltip_draw(gen_item_tooltip(item_name[o]));
                if (mouse_button_clicked()) {
                    top = o;
                }
            }
            column++;
            if (column > 7) {
                column = 0;
                row++;
            }
        }

        if (top != -1) {
            warning = "";
            needed_equipment[equipment_area] = item_name[top];
        }

        var _equip_data = new UnitEquipment(needed_equipment);
        var _results = _equip_data.check_set_is_equipable(unit_count);

        equipment_found_and_valid = _results.equipment_found_and_valid;
        warning = _results.warning;
    }

    //draw_set_halign(fa_center);
    if ((equipment_area == eEQUIPMENT_SLOT.WEAPON_ONE) || (equipment_area == eEQUIPMENT_SLOT.WEAPON_TWO)) {
        range_melee_radio.draw();
    }

    if (equipment_area != -1) {
        quality_radio.draw();
    }

    if (quality_radio.changed || range_melee_radio.changed || _area_change) {
        reload_items();
    }

    draw_set_color(255);
    draw_set_halign(fa_center);
    draw_text(1292, 570, warning);

    if (cancel_button.draw()) {
        instance_destroy();
    }

    var _valid = true;
    for (var i = 0; i < STANDARD_EQUIP_SLOT_COUNT; i++) {
        if (!equipment_found_and_valid[i]) {
            _valid = false;
            break;
        }
    }

    if (equip_button.draw(_valid)) {
        reequip_selection();
    }
}

/// @self Asset.GMObject.obj_popup
function reequip_selection() {
    for (var i = 0; i < STANDARD_EQUIP_SLOT_COUNT; i++) {
        if (needed_equipment[i] == ITEM_NAME_NONE) {
            needed_equipment[i] = "";
        }
    }

    for (var i = 0; i < array_length(obj_controller.display_unit); i++) {
        if (obj_controller.man[i] == "" || !obj_controller.man_sel[i]) {
            continue;
        }
        var _unit = obj_controller.display_unit[i];
        var standard = master_crafted == 1 ? "master_crafted" : "any";
        if (is_struct(_unit)) {
            _unit.alter_equipment(needed_equipment, true, true, standard);
            update_man_manage_array(i);
            continue;
        } else if (is_array(_unit) && (equipment_recipient_type > eEQUIP_TARGET_TYPE.DREADNOUGHT)) {
            var _veh_temp_arrays = [
                obj_controller.ma_wep1,
                obj_controller.ma_wep2,
                obj_controller.ma_armour,
                obj_controller.ma_gear,
                obj_controller.ma_mobi,
            ];

            var _company = _unit[0];
            var _slot = _unit[1];

            var _veh_equip_arrays = [
                obj_ini.veh_wep1[_company],
                obj_ini.veh_wep2[_company],
                obj_ini.veh_wep3[_company],
                obj_ini.veh_upgrade[_company],
                obj_ini.veh_acc[_company],
            ];

            for (var s = 0; s < STANDARD_EQUIP_SLOT_COUNT; s++) {
                var _temp_array = _veh_temp_arrays[s];
                var _equipment = needed_equipment[s];
                var _current_item = _temp_array[i];
                if (_equipment == "Assortment" || _equipment == _current_item) {
                    continue;
                }

                if (_current_item != "") {
                    scr_add_item(_current_item, 1);
                }
                _temp_array[@ i] = "";
                _veh_equip_arrays[@ s][@ _slot] = "";

                if (_equipment != ITEM_NAME_NONE && _equipment != "") {
                    _temp_array[@ i] = _equipment;
                    _veh_equip_arrays[@ s][@ _slot] = _equipment;
                    if (_equipment != "") {
                        scr_add_item(_equipment, -1);
                    }
                }
            }
        }
    } // End repeat

    obj_controller.cooldown = 10;
    instance_destroy();
    exit;
}
