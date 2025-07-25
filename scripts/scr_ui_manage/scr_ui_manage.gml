function load_marines_into_ship(system, ship, units, reload = false) {
    static _load_into_ship = function(system, ship, units, size, loop, reload) {
        var load_from_star = star_by_name(system);
        if (is_struct(units[loop])) {
            units[loop].load_marine(sh_ide[ship], load_from_star);
            ma_loc[loop] = sh_loc[ship];
            ma_lid[loop] = sh_ide[ship];
            ma_wid[loop] = 0;
        } else if (is_array(units[loop]) && ma_loc[loop] == system && sh_loc[ship] == system) {
            var vehicle = units[loop];
            var _get = fetch_deep_array;
            var _set = alter_deep_array;
            var start_ship = _get(obj_ini.veh_lid, vehicle);
            var start_planet = _get(obj_ini.veh_wid, vehicle);
            ma_loc[loop] = sh_loc[ship];
            ma_lid[loop] = sh_ide[ship];
            ma_wid[loop] = 0;
            _set(obj_ini.veh_loc, vehicle, sh_name[ship]);
            _set(obj_ini.veh_lid, vehicle, sh_ide[ship]);
            _set(obj_ini.veh_wid, vehicle, 0);
            _set(obj_ini.veh_uid, vehicle, sh_uid[ship]);
            obj_ini.ship_carrying[sh_ide[ship]] += size;

            if (start_planet) {
                load_from_star.p_player[start_planet] -= size;
            } else if (start_ship) {
                obj_ini.ship_carrying[start_ship] -= size;
            }

            set_vehicle_last_ship(vehicle, true);
        }
    };

    for (var q = 0; q < array_length(units); q++) {
        if (man_sel[q] == 1) {
            var _unit_ship_id = -1;
            var _unit = units[q];
            var _is_marine = !is_array(_unit);
            if (!reload) {
                _unit_ship_id = ship;
            } else {
                if (_is_marine) {
                    _unit_ship_id = array_get_index(sh_uid, _unit.last_ship.uid);
                } else {
                    var last_ship_data = fetch_deep_array(obj_ini.last_ship, _unit);
                    _unit_ship_id = array_get_index(sh_uid, last_ship_data.uid);
                }
            }

            if (_is_marine) {
                var _unit_size = man_size;
            } else {
                var _vehic_size = scr_unit_size("", ma_role[q], true);
                var _unit_size = _vehic_size;
            }

            if (_unit_ship_id == -1) {
                if (reload){
                    if (_is_marine){
                        _unit.last_ship = {
                            uid: "",
                            name: ""
                        };
                    } else {
                        set_vehicle_last_ship(_unit, true)
                    }
                }
                continue;                
            }
            if (_unit_ship_id<array_length(sh_cargo_max)){
                if (sh_cargo[_unit_ship_id] + _unit_size <= sh_cargo_max[_unit_ship_id]) {
                    _load_into_ship(system, _unit_ship_id, units, _unit_size, q, reload);
                    man_sel[q] = 0;
                }
            }
        }
    }
    system = "";
    man_size = 0;
    man_current = 0;
    if (reload == false) {
        menu = 1;
    }
    selecting_ship = -1;
    if (managing == -1 && obj_controller.selection_data.purpose != "Ship Management") {
        update_garrison_manage();
    }
}

/// @desc Displays a selectable prompt for special roles to be assigned.
/// @param {struct} search_params - Criteria for the role search
/// @param {struct} role_group_params - Parameters defining the role group
/// @param {string} purpose - Display purpose for the selection
/// @param {string} purpose_code - Code that identifies the selection’s purpose
function command_slot_prompt(search_params, role_group_params, purpose, purpose_code){
    var candidates = collect_role_group(role_group_params.group, role_group_params.location, role_group_params.opposite, search_params);
    group_selection(candidates, {
        purpose: purpose,
        purpose_code: purpose_code,
        number: 1,
        target_company: managing,
        feature: "none",
        planet: 0,
        selections: []
    });
}

/// @desc Displays a selectable prompt for special roles to be assigned.
/// @param {number} xx - X coordinate for the UI element
/// @param {number} yy - Y coordinate for the UI element
/// @param {string} slot_text - The prompt text displayed in the UI
function command_slot_draw(xx, yy, slot_text){
    draw_set_color(c_black);
    draw_rectangle(xx + 25, yy + 64, xx + 974, yy + 85, 0);
    draw_set_color(c_gray);
    draw_rectangle(xx + 25, yy + 64, xx + 974, yy + 85, 1);
    draw_set_halign(fa_center);
    draw_set_color(c_yellow);
    draw_text(xx + 500, yy + 66, $"++{slot_text}++");
    draw_set_halign(fa_left);
    draw_set_color(c_gray);
    if (point_and_click([xx + 25, yy + 64, xx + 974, yy + 85])) {
        return true;
    } else {
        return false;
    }
}


function company_specific_management(){
    add_draw_return_values();
    draw_set_font(fnt_40k_30b);
    draw_set_halign(fa_center);
    draw_set_color(c_gray); // 38144
    var _allow_shorts = false;
    var _comp = "";
    if (managing > 20) {
        _comp = managing - 10;
    } else if ((managing >= 1) && (managing <= 10)) {
        _company_name = int_to_roman(managing) + " Company";
        _comp = managing;
    } else if (managing > 10) {
        switch (managing) {
            case 11:
                _company_name = "Headquarters";
                break;
            case 12:
                _company_name = "Apothecarion";
                break;
            case 13:
                _company_name = "Librarium";
                break;
            case 14:
                _company_name = "Reclusium";
                break;
            case 15:
                _company_name = "Armamentarium";
                break;
        }
    }
    // Draw the company followed by chapters name
    draw_text(800, 74,  $"{_company_name}, {global.chapter_name}");
    if (managing <= 10 ) {
        var _text_input = management_buttons.company_namer;
        
        obj_ini.company_title[managing] = _text_input.draw(obj_ini.company_title[managing]);
        _allow_shorts = !_text_input.allow_input;
    } else {
        _allow_shorts = true;
    }
    if (allow_shortcuts){
        allow_shortcuts = _allow_shorts;
    }
    pop_draw_return_values()
}

function alternative_manage_views(x1, y1) {
    var _squad_button = management_buttons.squad_toggle;
    _squad_button.update({
        x1: x1 + 5,
        y1: y1 + 6,
        label: !obj_controller.view_squad && !obj_controller.company_report ? "Squad View" : "Company View",
        keystroke: keyboard_check_pressed(ord("S")) && allow_shortcuts
    });

    if (company_data.has_squads){
        if (_squad_button.draw(!text_bar)) {
            view_squad = !view_squad;
            if (view_squad) {
                new_company_struct();
            }
        }
    }

    if (!view_squad) {
        var _profile_toggle = management_buttons.profile_toggle;
        _profile_toggle.update({
            label: !unit_profile ? "Show Profile" : "Hide Profile",
            x1: _squad_button.x2,
            y1: _squad_button.y1,
            keystroke: keyboard_check_pressed(ord("P")) && allow_shortcuts
        });
        if (_profile_toggle.draw(!text_bar)) {
            unit_profile = !unit_profile;
        }

        if (unit_profile) {
            var bio_toggle = management_buttons.bio_toggle;
            bio_toggle.update({
                label: !unit_bio ? "Show Bio" : "Hide Bio",
                x1: _profile_toggle.x2,
                y1: _profile_toggle.y1,
                keystroke: keyboard_check_pressed(ord("B")) && allow_shortcuts
            });
            if (bio_toggle.draw(!text_bar)) {
                unit_bio = !unit_bio;
            }
        }
    }
}


function draw_sprite_and_unit_equip_data(){
    draw_set_font(fnt_40k_14);
    draw_set_halign(fa_left);    
    // Swap between squad view and normal view
    company_data.unit_ui_panel.inside_method = function(){
        var _unit_tooltips = [];
        draw_set_color(c_gray);
        var xx = company_data.unit_ui_panel.XX;
        var yy = company_data.unit_ui_panel.YY;
        // draw_line(xx+1005,yy+519,xx+1576,yy+519);
        draw_set_font(fnt_40k_14b);
        if (is_struct(obj_controller.unit_focus)) {
            var selected_unit = obj_controller.unit_focus; //unit struct
            ///tooltip_text stacks hover over type tooltips into an array and draws them last so as not to create drawing order issues
            draw_set_color(c_red);
            var no_other_instances = !instance_exists(obj_temp3) && !instance_exists(obj_popup);
            var stat_tool_tip_text;
            var button_coords;
            var _allow_alternative_views = managing >= 0;
            if (!_allow_alternative_views) {
                _allow_alternative_views = selection_data.purpose_code == "manage";
            }
            if (_allow_alternative_views) {
                alternative_manage_views(xx + 5, yy + 6);
            }

            if (!_allow_alternative_views) {
                unit_profile = true;
            }
            //TODO Implement company report
            /*var x6=x5+string_width(stat_tool_tip_text)+4;
            var y6=y5+string_height(stat_tool_tip_text)+2;        
            draw_unit_buttons([x5,y5,x6,y6], stat_tool_tip_text,[1,1],c_red);
            if (company_data!={}){
                array_push(company_data.tooltip_drawing, ["click or press R to show Company Report", [x5,y5,x6,y6]]);
                if ((keyboard_check_pressed(ord("R"))|| (point_in_rectangle(mouse_x, mouse_y,x5,y5,x6,y6) && mouse_check_button_pressed(mb_left))) && !instance_exists(obj_temp3) && !instance_exists(obj_popup)){
                    view_squad =false;
                    unit_profile=false;
                    company_report = !company_report;
                }
            }else{
                draw_set_alpha(0.5);
                draw_set_color(c_black);
                draw_rectangle(x5,y5,x6,y6,0);
                draw_set_alpha(1);
            }
            */

            // Draw unit image
            draw_set_color(c_white);
            if (is_struct(obj_controller.temp[121])) {
                obj_controller.temp[121].draw(xx + 320, yy + 109);
            }

            //TODO implement tooltip explaining potential loyalty hit of demoting a sgt
            // Sergeant promotion button
            if (view_squad && company_data.has_squads) {
                if (company_data.cur_squad != 0) {
                    var cur_squad = company_data.grab_current_squad();
                    var sgt_possible = cur_squad.type != "command_squad" && !selected_unit.IsSpecialist(SPECIALISTS_SQUAD_LEADERS);
                    if (selected_unit != cur_squad.squad_leader) {
                        if (point_and_click(draw_unit_buttons([xx + 200 + 50, yy + 329], "Make Sgt", [1, 1], #50a076, , , sgt_possible ? 1 : 0.5)) && sgt_possible) {
                            cur_squad.change_sgt(selected_unit);
                        }
                    }
                }
            }

            // Unit window entries start
            var line_color = #50a076;
            draw_set_color(line_color);

            // Draw unit name and role
            var _name_box = {
                x1: xx + 402,
                y1: yy + 36,
                text1: "",
                text2: "",
                text3: selected_unit.name()
            };
            _name_box.y2 = _name_box.y1 + 20;
            _name_box.y3 = _name_box.y2 + 20;
            if (selected_unit.company <= 0) {
                _name_box.text2 = $"{selected_unit.squad_role()}";
            } else if (selected_unit.IsSpecialist()) {
                _name_box.text1 = $"{selected_unit.company_roman()} Company";
                _name_box.text2 = $"{selected_unit.role()}";
            } else {
                _name_box.text1 = $"{selected_unit.company_roman()} Company";
                _name_box.text2 = $"{selected_unit.squad_role()}";
            }
            draw_set_halign(fa_center);
            draw_set_font(fnt_40k_14b);
            draw_text_transformed_outline(_name_box.x1, _name_box.y1, _name_box.text1, 1, 1, 0);
            draw_text_transformed_outline(_name_box.x1, _name_box.y2, _name_box.text2, 1, 1, 0);
            draw_set_font(fnt_40k_30b);
            draw_text_transformed_outline(_name_box.x1, _name_box.y3, _name_box.text3, 0.7, 0.7, 0);

            // Draw unit info
            draw_set_font(fnt_40k_14);
            // Left side of the screen
            draw_set_halign(fa_left);
            var x_left = xx + 22;

            // Equipment
            var armour = selected_unit.armour();
            if (armour != "") {
                text = selected_unit.equipments_qual_string("armour", false);
                tooltip_text = obj_controller.temp[103];
                x1 = x_left;
                y1 = yy + 179;
                x2 = x1 + string_width_ext(text, -1, 187);
                y2 = y1 + string_height_ext(text, -1, 187);
                draw_set_alpha(1);
                draw_text_ext_outline(x1, y1, text, -1, 187, 0, quality_color(selected_unit.armour_quality));
                array_push(_unit_tooltips, [tooltip_text, [x1, y1, x2, y2], "Armour"]);
            }

            var gear = selected_unit.gear();
            if (selected_unit.gear() != "") {
                text = selected_unit.equipments_qual_string("gear", false);
                tooltip_text = obj_controller.temp[105];
                x1 = x_left;
                y1 = yy + 305;
                x2 = x1 + string_width_ext(text, -1, 187);
                y2 = y1 + string_height_ext(text, -1, 187);
                draw_text_ext_outline(x1, y1, text, -1, 187, 0, quality_color(selected_unit.gear_quality));
                array_push(_unit_tooltips, [tooltip_text, [x1, y1, x2, y2], "Gear"]);
            }

            var mobi = selected_unit.mobility_item();
            if (mobi != "") {
                text = selected_unit.equipments_qual_string("mobi", false);
                tooltip_text = obj_controller.temp[107];
                x1 = x_left;
                y1 = yy + 326;
                x2 = x1 + string_width_ext(text, -1, 187);
                y2 = y1 + string_height_ext(text, -1, 187);
                draw_text_ext_outline(x1, y1, text, -1, 187, 0, quality_color(selected_unit.mobility_item_quality));
                array_push(_unit_tooltips, [tooltip_text, [x1, y1, x2, y2], "Back/Mobilitiy"]);
            }

            var wep1 = selected_unit.weapon_one();
            if (wep1 != "") {
                text = selected_unit.equipments_qual_string("wep1", false);
                tooltip_text = obj_controller.temp[109];
                x1 = x_left;
                y1 = yy + 204;
                x2 = x1 + string_width_ext(text, -1, 187);
                y2 = y1 + string_height_ext(text, -1, 187);
                draw_text_ext_outline(x1, y1, text, -1, 187, 0, quality_color(selected_unit.weapon_one_quality));
                array_push(_unit_tooltips, [tooltip_text, [x1, y1, x2, y2], "First Weapon"]);
            }

            var wep2 = selected_unit.weapon_two();
            if (wep2 != "") {
                text = selected_unit.equipments_qual_string("wep2", false);
                tooltip_text = obj_controller.temp[111];
                x1 = x_left;
                y1 = yy + 254;
                x2 = x1 + string_width_ext(text, -1, 187);
                y2 = y1 + string_height_ext(text, -1, 187);
                draw_text_ext_outline(x1, y1, text, -1, 187, 0, quality_color(selected_unit.weapon_two_quality));
                array_push(_unit_tooltips, [tooltip_text, [x1, y1, x2, y2], "Second Weapon"]);
            }

            // Stats
            // Bionics trackers
            if (obj_controller.temp[128] != "") {
                text = obj_controller.temp[128];
                tooltip_text = obj_controller.temp[129];
                x1 = x_left + 110;
                y1 = yy + 67;
                x2 = x1 + string_width(text);
                y2 = y1 + string_height(text);
                x3 = x1 - 26;
                y3 = y1 - 4;

                draw_sprite_stretched(spr_icon_bionics, 0, x3, y3, 24, 24);
                draw_text_outline(x1, y1, text);
                array_push(_unit_tooltips, [tooltip_text, [x3, y1, x2, y2], "Bionics Installed"]);
            }

            // Armour Rating
            if (obj_controller.temp[126] != "") {
                text = obj_controller.temp[126];
                tooltip_text = obj_controller.temp[127];
                x1 = x_left + 20;
                y1 = yy + 91;
                x2 = x1 + string_width(text);
                y2 = y1 + string_height(text);
                x3 = x1 - 26;
                y3 = y1 - 4;
                draw_sprite_stretched(spr_icon_shield2, 0, x3, y3, 24, 24);
                draw_text_outline(x1, y1, text);
                array_push(_unit_tooltips, [tooltip_text, [x3, y1, x2, y2], "Armour Rating"]);
            }

            // Health
            if (obj_controller.temp[124] != "") {
                text = obj_controller.temp[124];
                tooltip_text = obj_controller.temp[125];
                x1 = x_left + 20;
                y1 = yy + 67;
                x2 = x1 + string_width(text);
                y2 = y1 + string_height(text);
                x3 = x1 - 26;
                y3 = y1 - 4;
                draw_sprite_stretched(spr_icon_health, 0, x3, y3, 24, 24);
                draw_text_outline(x1, y1, text);
                array_push(_unit_tooltips, [tooltip_text, [x3, y1, x2, y2], "Health"]);
            }

            // Experience
            if (obj_controller.temp[113] != "") {
                text = obj_controller.temp[113];
                tooltip_text = "A measureme of how battle-hardened the unit is. Provides a lot of various bonuses across the board.";
                x1 = x_left + 20;
                y1 = yy + 43;
                x2 = x1 + string_width(text);
                y2 = y1 + string_height(text);
                x3 = x1 - 26;
                y3 = y1 - 4;
                array_push(_unit_tooltips, [tooltip_text, [x3, y1, x2, y2], "Experience"]);
                draw_sprite_stretched(spr_icon_veteran, 0, x_left - 6, yy + 39, 24, 24);
                draw_text_outline(x1, y1, text);
            }

            if (obj_controller.temp[118] != "") {
                text = obj_controller.temp[118]; // Damage Resistance
                tooltip_text = obj_controller.temp[130];
                x1 = x_left + 110;
                y1 = yy + 91;
                x2 = x1 + string_width(text);
                y2 = y1 + string_height(text);
                x3 = x1 - 26;
                y3 = y1 - 4;
                draw_sprite_stretched(spr_icon_iron_halo, 0, x3, y3, 24, 24);
                draw_text_outline(x1, y1, text);
                array_push(_unit_tooltips, [tooltip_text, [x3, y1, x2, y2], "Damage Resistance"]);
            }

            // Psyker things
            if (obj_controller.temp[119] != "") {
                text = obj_controller.temp[119];
                tooltip_text = obj_controller.temp[123];
                x1 = x_left + 110;
                y1 = yy + 43;
                x2 = x1 + string_width(text);
                y2 = y1 + string_height(text);
                x3 = x1 - 26;
                y3 = y1 - 4;
                draw_sprite_stretched(spr_icon_psyker, 0, x3, y3, 24, 24);
                draw_text_outline(x1, y1, text);
                array_push(_unit_tooltips, [tooltip_text, [x3, y1, x2, y2], "Psychic Stats"]);
            }

            if (is_array(obj_controller.temp[116])) {
                text = $"{round(obj_controller.temp[116][0])}"; // melee attack
                tooltip_text = string(obj_controller.temp[116][1]);
                x1 = x_left + 20;
                y1 = yy + 115;
                x2 = x1 + string_width(text);
                y2 = y1 + string_height(text);
                if (selected_unit.encumbered_melee) {
                    draw_set_color(#bf4040);
                    //tooltip_text+="\nencumbered"
                }
                x3 = x1 - 26;
                y3 = y1 - 4;
                draw_sprite_stretched(spr_icon_weapon_skill, 0, x3, y3, 24, 24);
                draw_text_outline(x1, y1, text);
                draw_set_color(line_color);
                array_push(_unit_tooltips, [tooltip_text, [x3, y1, x2, y2], "Melee Attack"]);
            }

            if (is_array(obj_controller.temp[117])) {
                text = $"{round(obj_controller.temp[117][0])}"; // ranged attack
                tooltip_text = string(obj_controller.temp[117][1]);
                x1 = x_left + 20;
                y1 = yy + 139;
                x2 = x1 + string_width(text);
                y2 = y1 + string_height(text);
                if (selected_unit.encumbered_ranged) {
                    draw_set_color(#bf4040);
                }
                x3 = x1 - 26;
                y3 = y1 - 4;
                draw_sprite_stretched(spr_icon_ballistic_skill, 0, x3, y3, 24, 24);
                draw_text_outline(x1, y1, text);
                array_push(_unit_tooltips, [tooltip_text, [x3, y1, x2, y2], "Ranged Attack"]);
                draw_set_color(line_color);
            }

            if (is_array(obj_controller.temp[116])) {
                var carry_data = obj_controller.temp[116][2];
                var carry_string = $"{carry_data[0]}/{carry_data[1]}"; // Melee Burden
                x1 = x_left + 110;
                y1 = yy + 115;
                x2 = x1 + string_width(carry_string);
                y2 = y1 + string_height(carry_string);
                if (selected_unit.encumbered_melee) {
                    draw_set_color(#bf4040);
                }
                x3 = x1 - 26;
                y3 = y1 - 4;
                draw_sprite_stretched(spr_icon_weight, 0, x3, y3, 24, 24);
                draw_text_outline(x1, y1, carry_string);
                tooltip_text = carry_data[2];
                array_push(_unit_tooltips, [tooltip_text, [x3, y1, x2, y2], "Melee Burden"]);
                draw_set_color(line_color);
            }

            if (is_array(obj_controller.temp[117])) {
                var carry_data = obj_controller.temp[117][2];
                var carry_string = $"{carry_data[0]}/{carry_data[1]}"; // Ranged Burden
                x1 = x_left + 110;
                y1 = yy + 139;
                x2 = x1 + string_width(carry_string);
                y2 = y1 + string_height(carry_string);
                if (selected_unit.encumbered_ranged) {
                    draw_set_color(#bf4040);
                }
                x3 = x1 - 26;
                y3 = y1 - 4;
                draw_sprite_stretched(spr_icon_weight, 0, x3, y3, 24, 24);
                draw_text_outline(x1, y1, carry_string);
                tooltip_text = carry_data[2];
                array_push(_unit_tooltips, [tooltip_text, [x3, y1, x2, y2], "Ranged Burden"]);
                draw_set_color(line_color);
            }

        }
        setup_tooltip_list(_unit_tooltips)
    }
    if (!instance_exists(obj_popup)){
        company_data.unit_ui_panel.draw_with_dimensions();
    }
}
/// @mixin
function scr_ui_manage() {
    if (combat != 0) {
        exit;
    }
    // This is the draw script for showing the main management screen or individual company screens

    if ((zoomed == 0) && (menu == 1) && (managing >= 0)) {
        if (managing > 0) {
            company_manage_actions();
        }
        if (allow_shortcuts) {
            ui_manage_hotkeys();
        }
    }

    if ((menu == 1) && (managing > 0 || managing < 0)) {
        if (!mouse_check_button(mb_left)) {
            drag_square = [];
            rectangle_action = -1;
        }
        if (squad_sel_count > 0) {
            squad_sel_count--;
        }
        if (squad_sel_count == 0) {
            squad_sel = -1;
            squad_sel_action = -1;
        }
        if (man_size < 1) {
            reset_manage_selections();
        }
        var unit, x1, x2, x3, y1, y2, y3, text;
        var tooltip_text = "", bionic_tooltip = "";
		company_data.tooltip_drawing = [];
        var invalid_locations = ["Mechanicus Vessel", "Terra"];

        var xx = __view_get(e__VW.XView, 0) + 0, yy = __view_get(e__VW.YView, 0) + 0, bb = "", img = 0;

        // Draw BG
        draw_set_alpha(1);
        draw_sprite(spr_rock_bg, 0, xx, yy);
        draw_set_font(fnt_40k_30b);
        draw_set_halign(fa_center);
        draw_set_color(c_gray); // 38144

        // Var declarations
        var c = 0, _company_name = "", skin = obj_ini.skin_color;
        static stats_displayed = false;

        if (managing < 0) {
            if (struct_exists(selection_data, "purpose")) {
                draw_text(xx + 800, yy + 74, $"{selection_data.purpose}");
            }
            if (selection_data.select_type == MissionSelectType.Squads){
                view_squad = true;
            }
        }

        draw_set_font(fnt_40k_14);


        if (managing >= 0) {
            // Draw arrows
            draw_sprite_ext(spr_arrow, 0, xx + 25, yy + 70, 2, 2, 0, c_white, 1); // Back
            draw_sprite_ext(spr_arrow, 0, xx + 429, yy + 70, 2, 2, 0, c_white, 1); // Left
            draw_sprite_ext(spr_arrow, 1, xx + 1110, yy + 70, 2, 2, 0, c_white, 1); // Right
        }
        var right_ui_block = {
            x1: xx + 1008,
            y1: yy + 141,
            w: 568,
            h: 681
        };
        right_ui_block.x2 = right_ui_block.x1 + right_ui_block.w;
        right_ui_block.y2 = right_ui_block.y1 + right_ui_block.h;

        var actions_block = {
            x1: right_ui_block.x1,
            y1: yy + 520,
            w: 569,
            h: 302
        };
        actions_block.x2 = actions_block.x1 + actions_block.w;
        actions_block.y2 = actions_block.y1 + actions_block.h;

        draw_sprite_stretched(spr_data_slate_back, 0, actions_block.x1, actions_block.y1, actions_block.w, actions_block.h);
        draw_rectangle_color_simple(actions_block.x1, actions_block.y1, actions_block.x2, actions_block.y2, 1, c_gray);
        draw_rectangle_color_simple(actions_block.x1 + 1, actions_block.y1 + 1, actions_block.x2 - 1, actions_block.y2 - 1, 1, c_black);
        draw_rectangle_color_simple(actions_block.x1 + 2, actions_block.y1 + 2, actions_block.x2 - 2, actions_block.y2 - 2, 1, c_gray);


        draw_set_color(c_white);
        // Back

        draw_set_halign(fa_left);
        var top = man_current, sel = top, temp1 = "", temp2 = "", temp3 = "", temp4 = "", temp5 = "";

        // Var creation
        var ma_ar = "", ma_we1 = "", ma_we2 = "", ma_ge = "", ma_mb = "", ttt = 0;
        var ar_ar = 0, ar_we1 = 0, ar_we2 = 0, ar_ge = 0, ar_mb = 0, eventing = false;

        yy += 77;

        var unit_specialism_option = false, spec_tip = "";
        //TODO store these in global tooltip storage
        potential_tooltip = [];
        health_tooltip = [];
        promotion_tooltip = [];

        //tooltip text to tell you if a unit is eligible for special roles

        get_command_slots_data = function(){
            var _command_slots_data = [
                {
                    search_params: {},
                    role_group_params: {
                        group: "captain_candidates",
                        location: "",
                        opposite: false
                    },
                    purpose: $"{int_to_roman(managing)} Company Captain Candidates",
                    purpose_code: "captain_promote",
                    button_text: "New Captain Required",
                    unit_check: "captain"
                },
                {
                    search_params: {
                        stat: [["weapon_skill", 44, "more"]],
                        companies: managing
                    },
                    role_group_params: {
                        group: [SPECIALISTS_STANDARD, true, true],
                        location: "",
                        opposite: true
                    },
                    purpose: $"{int_to_roman(managing)} Company Champion Candidates",
                    purpose_code: "champion_promote",
                    button_text: "Champion Required",
                    unit_check: "champion"
                },
                {
                    search_params: {
                        companies: managing
                    },
                    role_group_params: {
                        group: [SPECIALISTS_STANDARD, true, true],
                        location: "",
                        opposite: true
                    },
                    purpose: $"{int_to_roman(managing)} Company Ancient Candidates",
                    purpose_code: "ancient_promote",
                    button_text: "Ancient Required",
                    unit_check: "ancient"
                },
                {
                    search_params: {
                        companies: [managing, 0]
                    },
                    role_group_params: {
                        group: [SPECIALISTS_CHAPLAINS, false, false],
                        location: "",
                        opposite: false
                    },
                    purpose: $"{int_to_roman(managing)} Company Chaplain Candidates",
                    purpose_code: "chaplain_promote",
                    button_text: "Chaplain Required",
                    unit_check: "chaplain"
                },
                {
                    search_params: {
                        companies: [managing, 0],
                    },
                    role_group_params: {
                        group: [SPECIALISTS_APOTHECARIES, false, false],
                        location: "",
                        opposite: false
                    },
                    purpose: $"{int_to_roman(managing)} Company Apothecary Candidates",
                    purpose_code: "apothecary_promote",
                    button_text: "Apothecary Required",
                    unit_check: "apothecary"
                },
                {
                    search_params: {
                        companies: [managing, 0],
                    },
                    role_group_params: {
                        group: [SPECIALISTS_TECHS, false, false],
                        location: "",
                        opposite: false
                    },
                    purpose: $"{int_to_roman(managing)} Company Tech Marine Candidates",
                    purpose_code: "tech_marine_promote",
                    button_text: "Tech Marine Required",
                    unit_check: "tech_marine"
                }
            ];

            if(!scr_has_disadv("Psyker Intolerant")){
                array_push(_command_slots_data, {
                    search_params: {
                        companies: [managing, 0]
                    },
                    role_group_params: {
                        group: [SPECIALISTS_LIBRARIANS, false, false],
                        location: "",
                        opposite: false
                    },
                    purpose: $"{int_to_roman(managing)} Company Librarian Candidates",
                    purpose_code: "librarian_promote",
                    button_text: "Librarian Required",
                    unit_check: "lib"
                });
            }
            
            return _command_slots_data;
        }
        
        if (!obj_controller.view_squad) {
            var repetitions = min(man_max, MANAGE_MAN_SEE);
            man_count = 0;

            var _command_slots_data = get_command_slots_data();
            draw_set_font(fnt_40k_14);
            if (managing > 0 && managing <= 10) {
                for (var r = 0; r < array_length(_command_slots_data); r++) {
                    var role = _command_slots_data[r];
                    if (company_data[$ role.unit_check] == "none") {
                        var _clicked = command_slot_draw(xx, yy, role.button_text);
                        if (_clicked) {
                            command_slot_prompt(role.search_params, role.role_group_params, role.purpose, role.purpose_code);
                        }
                        yy += 20;
                        if (managing == -1) {
                            exit;
                        }
                        repetitions--;
                    }
                }
            }

            var _only_display_selected = (instance_exists(obj_popup) && (obj_popup.type == 5 || obj_popup.type == 5.1 || obj_popup.type == 6));
            for (var i = 0; i < max(0, repetitions); i++) {
                draw_set_font(fnt_40k_14);
                if (sel >= array_length(display_unit)) {
                    break;
                }

                while  ((sel <= array_length(display_unit) - 1) && (man[sel] == "hide" || (man_sel[sel] != 1 && _only_display_selected))) {
                    sel += 1;
                }
                if (sel >= array_length(display_unit)) {
                    break;
                }
                if (scr_draw_management_unit(sel, yy, xx, true, _only_display_selected) == "continue") {
                    sel++;
                    i--;
                    continue;
                }
                if (i == 0) {
                    if (point_and_click([xx + 25 + 8, yy + 64, xx + 974, yy + 85])) {
                        man_current = man_current > 0 ? man_current - 1 : 0;
                    }
                } else if (i == repetitions - 1) {
                    if (point_and_click([xx + 25 + 8, yy + 64, xx + 974, yy + 85])) {
                        man_current = man_current < man_max - MANAGE_MAN_SEE ? man_current + 1 : man_current == (man_max - MANAGE_MAN_SEE);
                        man_current++;
                    }
                }
                yy += 20;
                sel += 1;
            }
            if (sel_all != "" || squad_sel_count > 0) {
                for (var i = 0; i < top; i++) {
                    scr_draw_management_unit(i, yy, xx, false);
                }
                for (var i = sel; i < array_length(display_unit); i++) {
                    scr_draw_management_unit(i, yy, xx, false);
                }
            }
            sel_all = "";

            draw_set_color(c_black);
            xx = __view_get(e__VW.XView, 0) + 0;
            yy = __view_get(e__VW.YView, 0) + 0;
            draw_rectangle(xx + 974, yy + 165, xx + 1005, yy + 822, 0);
            draw_set_color(c_gray);
            draw_rectangle(xx + 974, yy + 165, xx + 1005, yy + 822, 1);

            // Squad outline
            draw_rectangle(xx + 25, yy + 142, xx + 14 + 8, yy + 822, 1);
            // draw_rectangle(xx+577,yy+64,xx+600,yy+85,1);
            // draw_rectangle(xx+577,yy+379,xx+600,yy+400,1);

            draw_set_color(0);
            draw_rectangle(xx + 974, yy + 141, xx + 1005, yy + 172, 0);
            draw_rectangle(xx + 974, yy + 790, xx + 1005, yy + 822, 0);
            draw_set_color(c_gray);
            draw_rectangle(xx + 974, yy + 141, xx + 1005, yy + 172, 1);
            draw_rectangle(xx + 974, yy + 790, xx + 1005, yy + 822, 1);

            draw_sprite_stretched(spr_arrow, 2, xx + 974, yy + 141, 31, 30);
            draw_sprite_stretched(spr_arrow, 3, xx + 974, yy + 791, 31, 30);

            /*
		    draw_set_color(c_black);draw_rectangle(xx+25,yy+400,xx+600,yy+417,0);
		    draw_set_color(38144);draw_rectangle(xx+25,yy+400,xx+600,yy+417,1);
		    draw_line(xx+160,yy+400,xx+160,yy+417);
		    draw_line(xx+304,yy+400,xx+304,yy+417);
		    draw_line(xx+448,yy+400,xx+448,yy+417);

		    draw_set_font(fnt_menu);
		    draw_set_halign(fa_center);
		    */

            yy += 8;
            //TODO handle recursively
            if ((!obj_controller.unit_profile) && (!stats_displayed)) {
                var sel_loading = obj_controller.selecting_ship;
                //draws hover over tooltips
                function gen_tooltip(tooltip_array) {
                    for (var i = 0; i < array_length(tooltip_array); i++) {
                        var tooltip = tooltip_array[i];
                        if (scr_hit(tooltip[1][0], tooltip[1][1], tooltip[1][2], tooltip[1][3])) {
                            tooltip_draw(tooltip[0]);
                        }
                    }
                }
                gen_tooltip(potential_tooltip);
                gen_tooltip(promotion_tooltip);
                gen_tooltip(health_tooltip);

                // Draw interaction and selection buttons
                yy -= 8;
                draw_set_font(fnt_40k_14b);
                draw_set_color(#50a076);
                var button = new UnitButtonObject();

                button.h = 15;
                button.x1 = right_ui_block.x1 + 1;
                button.y1 = right_ui_block.y2 - 6 - 30;
                button.x2 = button.x1 + 128;
                button.y2 = button.y1 + button.h;
                // Load/Unload to ship button
                button.label = "Load";
                var load_unload_possible = man_size > 0;

                button.keystroke = keyboard_check(vk_shift) && keyboard_check_pressed(ord("L"));
                button.tooltip = "Press Shift L";
                if (load_unload_possible) {
                    button.alpha = 1;
                    if (sel_loading == -1) {
                        if (button.draw()) {
                            load_selection();
                        }
                    } else if (sel_loading != -1) {
                        button.label = "Unload";
                        if (button.draw()) {
                            unload_selection(); // Unload - ask for planet confirmation
                        }
                    }
                } else {
                    button.alpha = 0.5;
                    button.draw(false);
                }

                button.move("down", true);

                button.label = "Reload";
                //button.keystroke = (keyboard_check(vk_shift) && (keyboard_check_pressed(ord("F"))));
                if (instance_exists(obj_controller) && is_struct(obj_controller.unit_focus)) {
                    var selected_unit = obj_controller.unit_focus;
                    button.tooltip = $"{selected_unit.last_ship.name}"; //Press Shift F";
                }
                reload_possible = man_size > 0 && sel_loading == -1;
                if (reload_possible) {
                    button.alpha = 1;
                    if (button.draw()) {
                        scr_company_load(selecting_location);
                        load_marines_into_ship(selecting_location, sh_ide, display_unit, true);
                    }
                } else {
                    button.alpha = 0.5;
                    button.draw(false);
                }

                button.h = 30;
                button.x1 = right_ui_block.x1 + 26;
                button.y1 = right_ui_block.y2 - 6 - 30;
                button.x2 = button.x1 + button.w;
                button.y2 = button.y1 + button.h;
                button.move("right", true);

                // // Re equip button
                button.label = "Re-equip";
                var equip_possible = !array_contains(invalid_locations, selecting_location) && man_size > 0;

                button.alpha = equip_possible ? 1 : 0.5;
                button.keystroke = keyboard_check(vk_shift) && keyboard_check_pressed(ord("E"));
                button.tooltip = "Press Shift E";

                if (button.draw() && equip_possible) {
                    set_up_equip_popup();
                }

                button.move("right");

                // // Promote button
                button.label = "Promote";

                button.keystroke = keyboard_check(vk_shift) && keyboard_check_pressed(ord("P"));
                button.tooltip = "Press Shift P";

                var promote_possible = sel_promoting > 0 && !array_contains(invalid_locations, selecting_location) && man_size > 0;
                button.alpha = promote_possible ? 1 : 0.5;
                if (button.draw()) {
                    if (promote_possible) {
                        setup_promotion_popup();
                    }
                }
                button.move("right", true);

                // // Put in jail button
                button.label = "Jail";
                button.keystroke = keyboard_check(vk_shift) && keyboard_check_pressed(ord("J"));
                button.tooltip = "Press Shift J";

                var jail_possible = man_size > 0;
                button.alpha = jail_possible ? 1 : 0.5;
                if (button.draw()) {
                    if (jail_possible) {
                        jail_selection();
                    }
                }
                button.x1 += button.w + button.h_gap;
                button.x2 += button.w + button.h_gap;
                // // Add bionics button
                button.label = "Add Bionics";
                button.keystroke = keyboard_check(vk_shift) && keyboard_check_pressed(ord("B"));
                button.tooltip = "Press Shift B";
                var bionics_possible = man_size > 0;
                button.alpha = bionics_possible ? 1 : 0.5;
                if (button.draw()) {
                    if (bionics_possible) {
                        add_bionics_selection();
                    }
                }

                button.move("up", true);

                button.move("left", true, 4);

                // // Designate as boarder unit
                button.label = "Set Boarder";
                button.keystroke = keyboard_check(vk_shift) && keyboard_check_pressed(ord("Q"));
                button.tooltip = "Press Shift Q";
                var boarder_possible = sel_loading != -1 && man_size > 0;
                button.alpha = boarder_possible ? 1 : 0.5;
                if (button.draw() && boarder_possible) {
                    if (boarder_possible) {
                        toggle_selection_borders();
                    }
                }
                button.move("right", true);

                // // Reset changes button
                button.label = "Reset";
                button.keystroke = keyboard_check(vk_shift) && keyboard_check_pressed(ord("R"));
                button.tooltip = "Press Shift R";
                var reset_possible = !array_contains(invalid_locations, selecting_location) && man_size > 0;
                if (reset_possible) {
                    button.alpha = 1;
                    if (button.draw()) {
                        reset_selection_equipment();
                    }
                } else {
                    button.alpha = 0.5;
                    button.draw(false);
                }

                button.move("right", true);

                // // Transfer to another company button
                button.label = "Transfer";
                button.keystroke = keyboard_check(vk_shift) && keyboard_check_pressed(ord("T"));
                button.tooltip = "Press Shift T";
                var transfer_possible = !array_contains(invalid_locations, selecting_location) && man_size > 0;
                if (transfer_possible) {
                    button.alpha = 1;
                    if (button.draw()) {
                        set_up_transfer_popup();
                    }
                } else {
                    button.alpha = 0.5;
                    button.draw(false);
                }

                button.move("right", true);
                button.label = "Move Ship";
                button.keystroke = keyboard_check(vk_shift) && keyboard_check_pressed(ord("M"));
                button.tooltip = "Press Shift M";
                var moveship_possible = !array_contains(invalid_locations, selecting_location) && man_size > 0 && selecting_ship > -1;
                if (moveship_possible) {
                    button.alpha = 1;
                    if (button.draw()) {
                        load_selection();
                    }
                } else {
                    button.alpha = 0.5;
                    button.draw(false);
                }

                button.move("right", true);

                button.label = "Manage Tags";
                button.keystroke = keyboard_check(vk_shift) && keyboard_check_pressed(ord("F"));
                button.tooltip = "Press Shift F" //Press Shift F";
                button.alpha = 0.5;

                button.alpha = 1;
                if (button.draw()) {
                    if (!instance_exists(obj_popup)){
                        set_up_tag_manager();
                    } else if (obj_popup.type == POPUP_TYPE.ADD_TAGS){
                        instance_destroy(obj_popup);
                    }
                }

                if (sel_uni[1] != "") {
                    // How much space the selected unit takes
                    draw_set_font(fnt_40k_30b);
                    draw_text_transformed(actions_block.x1 + 26, actions_block.y1 + 6, $"Selection: {man_size} space", 0.5, 0.5, 0);
                    // List of selected units
                    draw_set_font(fnt_40k_14);
                    draw_text_ext(actions_block.x1 + 26, actions_block.y1 + 30, selecting_dudes, -1, 550);
                    // Options for the selected unit
                    // draw_set_font(fnt_40k_30b);
                    // draw_text_transformed(actions_block.x1 + 4, actions_block.x1 + 64,"Options:",0.5,0.5,0);

                    // Select all units button

                    button.move("up", true, 4.15);

                    button.move("left", true, 4);

                    button.label = "Select All";
                    button.tooltip = "";
                    button.keystroke = false;
                    button.alpha = 1;
                    if (button.draw()) {
                        // scr_load_all(loading); //not sure whether loading was intentional or not
                        sel_all = "all";
                    }

                    button.move("right", true, 1);
                    button.label = "Filter Mode";
                    button.alpha = filter_mode ? 1 : 0.5;
                    if (button.draw()) {
                        filter_mode = !filter_mode;
                    }

                    button.move("left", true, 1);
                    // Select all infantry button
                    button.y1 += button.h + button.v_gap + 4;
                    button.h /= 1.4;
                    button.w = 128;
                    button.x2 = button.x1 + button.w;
                    button.y2 = button.y1 + button.h;
                    var inf_button_pos = [button.x1, button.y1, button.x2, button.y2];
                    button.label = "All Infantry";
                    button.alpha = 1;
                    button.font = fnt_40k_12;
                    draw_set_font(fnt_40k_12);
                    if (button.draw()) {
                        sel_all = "man";
                    }
                    // Select infantry type buttons
                    for (var i = 1; i <= 8; i++) {
                        if (sel_uni[i] != "") {
                            button.move("right", true);
                            if (i == 4) {
                                button.move("left", true, 4);
                                button.move("down", true);
                            }
                            button.label = string_truncate(sel_uni[i], 126);
                            button.alpha = 1;
                            if (button.draw()) {
                                sel_all = sel_uni[i];
                            }
                        }
                    }
                }

                // Select all vehicles button
                if (sel_veh[1] != "") {
                    button.x1 = inf_button_pos[0];
                    button.x2 = inf_button_pos[2];
                    button.y1 = inf_button_pos[1] + (button.h + button.v_gap) * 2 + 4;
                    button.y2 = button.y1 + button.h;
                    button.label = "All Vehicles";
                    button.alpha = 1;
                    if (button.draw()) {
                        sel_all = "vehicle";
                    }
                    // Select vehicle type buttons
                    for (var i = 1; i <= 8; i++) {
                        if (sel_veh[i] != "") {
                            button.move("right", true);
                            if (i == 4) {
                                button.move("left", true, 4);
                                button.move("down", true);
                            }
                            button.label = string_truncate(sel_veh[i], 126);
                            button.alpha = 1;
                            if (button.draw()) {
                                sel_all = sel_veh[i];
                            }
                        }
                    }
                }
            }

            draw_set_color(#3f7e5d);
            scr_scrollbar(974, 172, 1005, 790, 34, man_max, man_current);
        }
        if (instance_exists(obj_controller) && is_struct(obj_controller.unit_focus)) {
            var selected_unit = obj_controller.unit_focus;
            if ((selected_unit.name() != "") && (selected_unit.race() != 0)) {
                draw_set_alpha(1);
                var xx = __view_get(e__VW.XView, 0) + 0, yy = __view_get(e__VW.YView, 0) + 0;
                if ((obj_controller.unit_profile) && !instance_exists(obj_popup)) {
                    stats_displayed = true;
                    selected_unit.stat_display(true);
                    //tooltip_draw(stat_x, stat_y+string_height(stat_display),0,0,100,17);
                } else {
                    stats_displayed = false;
                }

                with (obj_controller) {
                    if (view_squad && !instance_exists(obj_popup)) {
                        if (managing > 10) {
                            view_squad = false;
                            unit_profile = false;
                        } else if (company_data.has_squads) {
                            company_data.draw_squad_view();
                        }
                    }
                }
            }
        }
        setup_tooltip_list(company_data.tooltip_drawing);
    } else if (menu == 30 && (managing > 0 || managing == -1)) {
        // Load to ships

        var xx, yy, bb, img;
        bb = "";
        img = 0;

        xx = __view_get(e__VW.XView, 0) + 0;
        yy = __view_get(e__VW.YView, 0) + 0;

        // BG
        draw_set_alpha(1);
        draw_sprite(spr_rock_bg, 0, xx, yy);
        draw_set_font(fnt_40k_30b);
        draw_set_halign(fa_center);
        draw_set_color(c_gray); // 38144

        // Draw Title
        var c = 0, fx = "";
        if (managing <= 10) {
            c = managing;
        }
        if (managing > 20) {
            c = managing - 10;
        }

        // Draw companies
        if (managing > 0) {
            if (managing >= 1 && managing <= 10) {
                fx = int_to_roman(managing) + " Company";
            } else if (managing > 10) {
                switch (managing) {
                    case 11:
                        fx = "Headquarters";
                        break;
                    case 12:
                        fx = "Apothecarion";
                        break;
                    case 13:
                        fx = "Librarium";
                        break;
                    case 14:
                        fx = "Reclusium";
                        break;
                    case 15:
                        fx = "Armamentarium";
                        break;
                    default:
                        fx = "Unknown";
                        break;
                }
            }
        }

        draw_text(xx + 800, yy + 74, $"{global.chapter_name} {fx}");

        if (managing >= 0 && managing <= 10) {
            if (obj_ini.company_title[managing] != "") {
                draw_set_font(fnt_fancy);
                draw_text(xx + 800, yy + 110, $"''{obj_ini.company_title[managing]}''");
            }
        }

        // Back
        draw_sprite_ext(spr_arrow, 0, xx + 25, yy + 70, 2, 2, 0, c_white, 1);

        if (point_and_click([xx + 25, yy + 70, xx + 70, yy + 140])) {
            man_size = 0;
            man_current = 0;
            menu = 1;
        }

        var top, temp1 = "", temp2 = "", temp3 = "", temp4 = "", temp5 = "";
        top = ship_current;

        draw_set_font(fnt_40k_14);
        draw_set_halign(fa_left);
        yy += 77;
        var main_rect;
        var repetitions = min(ship_max, ship_see);

        for (var sel = top; sel < repetitions && sel < array_length(sh_name); sel++) {
            if (sh_name[sel] != "") {
                temp1 = string(sh_name[sel]) + " (" + string(sh_class[sel]) + ")";
                temp2 = string(sh_loc[sel]);
                temp3 = sh_hp[sel];
                temp4 = string(sh_cargo[sel]) + " / " + string(sh_cargo_max[sel]) + " Space Used";

                main_rect = [xx + 25, yy + 64, xx + 974, yy + 85];

                draw_set_color(c_black);
                draw_rectangle(main_rect[0], main_rect[1], main_rect[2], main_rect[3], 0);
                draw_set_color(c_gray);
                draw_rectangle(xx + 25, yy + 64, xx + 974, yy + 85, 1);
                draw_text_transformed(xx + 27, yy + 66, temp1, 1, 1, 0);
                draw_text_transformed(xx + 27.5, yy + 66.5, temp1, 1, 1, 0);
                draw_text_transformed(xx + 364, yy + 66, string(temp2), 1, 1, 0);
                draw_text_transformed(xx + 580, yy + 66, string(temp3), 1, 1, 0);
                draw_text_transformed(xx + 730, yy + 66, string(temp4), 1, 1, 0);
                if (point_and_click(main_rect)) {
                    load_marines_into_ship(selecting_location, sel, display_unit);
                }
                yy += 20;
            }
        }

        // Load to selected
        draw_set_font(fnt_40k_14b);
        draw_text_transformed(xx + 320, yy + 402, $"Click a Ship to Load Selection (Req. {man_size} Space)", 1, 1, 0);

        xx = __view_get(e__VW.XView, 0) + 0;
        yy = __view_get(e__VW.YView, 0) + 0;

        // draw_text_transformed(xx + 488, yy + 426, "Selection Size: " + string(man_size), 0.4, 0.4, 0);
        scr_scrollbar(974, 172, 1005, 790, 34, ship_max, ship_current);
    }
}
