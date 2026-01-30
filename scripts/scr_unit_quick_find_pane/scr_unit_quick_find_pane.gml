// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function UnitQuickFindPanel() constructor {
    main_panel = new DataSlate();
    garrison_log = {};
    ship_count = 0;
    tab_buttons = {
        "fleets": new MainMenuButton(spr_ui_but_3, spr_ui_hov_3),
        "garrisons": new MainMenuButton(spr_ui_but_3, spr_ui_hov_3),
        "hider": new MainMenuButton(spr_ui_but_3, spr_ui_hov_3),
        "missions": new MainMenuButton(spr_ui_but_3, spr_ui_hov_3),
    };

    static detail_slate = new DataSlateMKTwo();

    view_area = "fleets";

    static has_troops = function(name) {
        return struct_exists(garrison_log, name);
    };

    static player_force_stars = function() {
        var _names = struct_get_names(garrison_log);
        var _stars = [];
        for (var i = 0; i < array_length(_names); i++) {
            var _star = star_by_name(_names[i]);
            if (_star != "none") {
                array_push(_stars, _star);
            }
        }

        return _stars;
    };

    static add_unit_to_garrison_log = function(_unit, unit_location) {
        if (!struct_exists(garrison_log, unit_location[2])) {
            garrison_log[$ unit_location[2]] = {
                units: [_unit],
                vehicles: 0,
                garrison: false,
                healers: 0,
                techies: 0,
            };
        } else {
            array_push(garrison_log[$ unit_location[2]].units, _unit);
        }
    };

    static evaluate_unit_for_garrison_log = function(unit) {
        var unit_location, group;

        if (unit.name() == "" || !unit.controllable()) {
            return;
        }
        unit_location = unit.marine_location();
        if (unit_location[0] == location_types.planet && unit_location[2] != "") {
            add_unit_to_garrison_log(unit, unit_location);
            group = garrison_log[$ unit_location[2]];
            if (unit.IsSpecialist(SPECIALISTS_APOTHECARIES)) {
                group.healers++;
            } else if (unit.IsSpecialist(SPECIALISTS_TECHS)) {
                group.techies++;
            }
        } else if (unit_location[0] == location_types.ship) {
            if (unit.ship_location < ship_count && unit.ship_location > -1) {
                obj_ini.ship_carrying[unit.ship_location] += unit.get_unit_size();
            }
        }
    };

    static evaluate_vehicle_for_garrison_log = function(company, array_slot) {
        var co = company;
        var u = array_slot;

        if (obj_ini.veh_race[co][u] == 0) {
            return;
        }
        if (obj_ini.veh_wid[co][u] > 0) {
            unit_location = obj_ini.veh_loc[co][u];
            var _unit = [
                co,
                u
            ];
            if (!struct_exists(garrison_log, unit_location)) {
                garrison_log[$ unit_location] = {
                    units: [_unit],
                    vehicles: 1,
                    garrison: false,
                    healers: 0,
                    techies: 0,
                };
            } else {
                array_push(garrison_log[$ unit_location].units, _unit);
                garrison_log[$ unit_location].vehicles++;
            }
        } else if (obj_ini.veh_lid[co][u] > -1) {
            obj_ini.ship_carrying[obj_ini.veh_lid[co][u]] += scr_unit_size("", obj_ini.veh_role[co][u], true);
        }
    };

    static update_garrison_log = function() {
        try {
            for (var i = 0; i < array_length(obj_ini.ship_carrying); i++) {
                obj_ini.ship_carrying[i] = 0;
            }
            var _unit;
            delete garrison_log;
            garrison_log = {};
            obj_controller.specialist_point_handler.calculate_research_points(false);
            ship_count = array_length(obj_ini.ship_carrying);
            for (var co = 0; co <= obj_ini.companies; co++) {
                for (var u = 0; u < array_length(obj_ini.TTRPG[co]); u++) {
                    /// @type {Struct.TTRPG_stats}
                    _unit = fetch_unit([co, u]);
                    evaluate_unit_for_garrison_log(_unit);
                }
                try {
                    for (var u = 0; u < array_length(obj_ini.veh_race[co]); u++) {
                        evaluate_vehicle_for_garrison_log(co, u);
                    }
                } catch (_exception) {
                    handle_exception(_exception);
                }
            }
            update_mission_log();
        } catch (_exception) {
            handle_exception(_exception);
        }
    };

    update_mission_log = function() {
        mission_log = [];
        var temp_log = [];
        var p, i, problems;
        with (obj_star) {
            for (i = 1; i <= planets; i++) {
                problems = p_problem[i];
                for (p = 0; p < array_length(problems); p++) {
                    if (problems[p] != "") {
                        if (problem_has_key_and_value(i, p, "stage", "preliminary")) {
                            continue;
                        }
                        var mission_explain = mission_name_key(problems[p]);
                        if (mission_explain != "none") {
                            array_push(temp_log, {system: name, mission: mission_explain, time: p_timer[i][p], planet: i});
                        }
                    }
                }
            }
        }
        for (i = 0; i < array_length(obj_controller.quest); i++) {
            if (obj_controller.quest[i] != "") {
                var mission_explain = mission_name_key(obj_controller.quest[i]);
                if (mission_explain != "none") {
                    array_push(temp_log, {system: "", mission: mission_explain, time: obj_controller.quest_end[i] - obj_controller.turn, planet: 0});
                }
            }
        }
        mission_log = temp_log;
    };
    hover_item = "none";
    travel_target = [];
    travel_time = 0;
    travel_increments = [];
    is_entered = false;
    start_fleet = 0;
    start_system = 0;
    garrison_log = {};
    mission_log = [];
    hide_sequence = 0;
    current_hover = -1;
    hover_count = 0;
    main_panel.inside_method = function() {
        var xx = main_panel.XX;
        var yy = main_panel.YY;
        is_entered = scr_hit(xx, yy, xx + main_panel.width, yy + main_panel.height);
        if (view_area == "fleets") {
            var cur_fleet;
            draw_set_color(c_white);
            draw_set_halign(fa_center);
            draw_text(xx + 80, yy + 50, "Capitals");
            draw_text(xx + 160, yy + 50, "Frigates");
            draw_text(xx + 240, yy + 50, "Escorts");
            draw_text(xx + 310, yy + 50, "Location");
            var i = start_fleet;
            while (i < instance_number(obj_p_fleet) && (yy + 90 + (20 * i) + 12 + 20) < main_panel.YY + yy + main_panel.height) {
                if (scr_hit(xx + 10, yy + 90 + (20 * i), xx + main_panel.width, yy + 90 + (20 * i) + 18)) {
                    draw_set_color(c_gray);
                    draw_rectangle(xx + 10 + 20, yy + 90 + (20 * i) - 2, xx + main_panel.width - 20, yy + 90 + (20 * i) + 18, 0);
                    draw_set_color(c_white);
                }
                cur_fleet = instance_find(obj_p_fleet, i);
                draw_text(xx + 80, yy + 90 + (20 * i), cur_fleet.capital_number);
                draw_text(xx + 160, yy + 90 + (20 * i), cur_fleet.frigate_number);
                draw_text(xx + 240, yy + 90 + (20 * i), cur_fleet.escort_number);
                var _fleet_point_data = cur_fleet.point_breakdown;
                var _loc_display_string = "";
                var _zoomable_loc = true;
                if (cur_fleet.action == "Lost") {
                    _loc_display_string = "Lost";
                    _zoomable_loc = false;
                } else if (string_count("crusade", cur_fleet.action)) {
                    _loc_display_string = "Crusading";
                    _zoomable_loc = false;
                } else if (cur_fleet.action == "move") {
                    _loc_display_string = "Warp Travel";
                } else {
                    var _near_star = instance_nearest(cur_fleet.x, cur_fleet.y, obj_star);
                    _loc_display_string = _near_star.name;

                    var _special_points = obj_controller.specialist_point_handler.point_breakdown.systems;
                    if (struct_exists(_special_points, _near_star)) {
                        var _fleet_point_data = _special_points[$ _near_star.name][0];
                    }
                }
                draw_text(xx + 310, yy + 90 + (20 * i), _loc_display_string);

                var _fleet_coords = [
                    xx + 10,
                    yy + 90 + (20 * i) - 2,
                    xx + main_panel.width,
                    yy + 90 + (20 * i) + 18
                ];

                if (_zoomable_loc) {
                    if (point_and_click([xx + 10, yy + 90 + (20 * i) - 2, xx + main_panel.width, yy + 90 + (20 * i) + 18])) {
                        travel_target = [
                            cur_fleet.x,
                            cur_fleet.y
                        ];
                        travel_increments = [
                            (travel_target[0] - obj_controller.x) / 15,
                            (travel_target[1] - obj_controller.y) / 15
                        ];
                        travel_time = 0;
                    }
                }

                if (scr_hit(_fleet_coords)) {
                    detail_slate.draw(xx + main_panel.width - 10, _fleet_coords[1] - 20, 1.5, 1.5);
                    var _xx = xx + main_panel.width - 10;
                    var _yy = _fleet_coords[1] - 20;
                    draw_set_font(fnt_40k_12i);
                    draw_text(_xx + 160, _yy + 10, "forge point\ntotal");
                    draw_text(_xx + 240, _yy + 10, "forge point\nuse");
                    draw_text(_xx + 320, _yy + 10, "apothecary\npoint total");
                    draw_text(_xx + 400, _yy + 10, "apothecary\npoint use");
                    draw_text(_xx + 60, _yy + 50, "Orbiting");
                    var _y_line = _yy + 50;
                    draw_text(_xx + 160, _y_line, _fleet_point_data.forge_points);
                    draw_text(_xx + 240, _y_line, _fleet_point_data.forge_points_use);
                    draw_text(_xx + 320, _y_line, _fleet_point_data.heal_points);
                    draw_text(_xx + 400, _y_line, _fleet_point_data.heal_points_use);
                }
                i++;
            }
        } else if (view_area == "garrisons") {
            var system_data;
            draw_set_color(c_white);
            draw_set_halign(fa_center);
            draw_text(xx + 80, yy + 50, "System");
            draw_text(xx + 160, yy + 50, "Troops");
            draw_text(xx + 240, yy + 50, "Healers");
            draw_text(xx + 310, yy + 50, "Techies");
            var i = start_system;
            var registered_hover = false;
            var system_names = struct_get_names(garrison_log);
            var hover_entered = false;
            var any_hover = false;
            if (hover_item != "none") {
                var loc = hover_item.location;
                hover_entered = scr_hit(loc[0], loc[1], loc[2], loc[3]);
            }
            while (i < array_length(system_names) && (yy + 90 + (20 * i) + 12 + 20) < main_panel.YY + yy + main_panel.height) {
                var _sys_name = system_names[i];
                system_data = garrison_log[$ _sys_name];
                registered_hover = false;
                var _sys_item_y = yy + 90 + (20 * i) + 18;
                if (scr_hit(xx + 10, yy + 90 + (20 * i), xx + main_panel.width, _sys_item_y)) {
                    if (!hover_entered) {
                        draw_set_color(c_gray);
                        draw_rectangle(xx + 10 + 20, yy + 90 + (20 * i) - 2, xx + main_panel.width - 20, yy + 90 + (20 * i) + 18, 0);
                        draw_set_color(c_white);
                        if (current_hover > -1 && current_hover != i) {
                            registered_hover = false;
                        } else {
                            current_hover = i;
                            registered_hover = true;
                            hover_count++;
                        }
                    } else {
                        if (hover_item.root_item == i) {
                            draw_rectangle(xx + 10 + 20, yy + 90 + (20 * i) - 2, xx + main_panel.width - 20, yy + 90 + (20 * i) + 18, 0);
                        }
                    }
                    detail_slate.draw(xx + main_panel.width - 10, _sys_item_y - 20, 1.5, 1.5);
                    var _special_points = obj_controller.specialist_point_handler.point_breakdown.systems;
                    if (struct_exists(_special_points, _sys_name)) {
                        var _system_point_data = _special_points[$ _sys_name];
                        var _xx = xx + main_panel.width - 10;
                        var _yy = _sys_item_y - 20;
                        draw_set_font(fnt_40k_12i);
                        draw_text(_xx + 160, _yy + 10, "forge point\ntotal");
                        draw_text(_xx + 240, _yy + 10, "forge point\nuse");
                        draw_text(_xx + 320, _yy + 10, "apothecary\npoint total");
                        draw_text(_xx + 400, _yy + 10, "apothecary\npoint use");
                        draw_text(_xx + 60, _yy + 50, "Orbiting");
                        for (var s = 1; s <= 4; s++) {
                            draw_text(_xx + 60, _yy + 50 + (50 * s), scr_roman(s));
                        }
                        var _y_line = _yy + 50;
                        for (var o = 0; o < 5; o++) {
                            var _area_item = _system_point_data[o];
                            draw_text(_xx + 220, _y_line, _area_item.forge_points);
                            draw_text(_xx + 300, _y_line, _area_item.forge_points_use);
                            draw_text(_xx + 380, _y_line, _area_item.heal_points);
                            draw_text(_xx + 460, _y_line, _area_item.heal_points_use);
                            _y_line += 50;
                        }
                    }
                }
                draw_text(xx + 80, yy + 90 + (20 * i), system_names[i]);
                draw_text(xx + 160, yy + 90 + (20 * i), array_length(system_data.units));
                draw_text(xx + 240, yy + 90 + (20 * i), system_data.healers);
                draw_text(xx + 310, yy + 90 + (20 * i), system_data.techies);

                if (!hover_entered) {
                    if (point_and_click([xx + 10, yy + 90 + (20 * i) - 2, xx + main_panel.width, yy + 90 + (20 * i) + 18])) {
                        var star = star_by_name(system_names[i]);
                        if (star != "none") {
                            travel_target = [
                                star.x,
                                star.y
                            ];
                            travel_increments = [
                                (travel_target[0] - obj_controller.x) / 15,
                                (travel_target[1] - obj_controller.y) / 15
                            ];
                            travel_time = 0;
                        }
                    }
                }
                if (registered_hover) {
                    any_hover = true;
                    if (hover_count == 10) {
                        hover_item = new HoverBox();
                        var mouse_consts = return_mouse_consts();
                        hover_item.relative_x = mouse_consts[0];
                        hover_item.relative_y = mouse_consts[1];
                        hover_item.root_item = i;
                    }
                }
                i++;
            }
            if (!any_hover && !hover_entered) {
                current_hover = -1;
                hover_count = 0;
                hover_item = "none";
            } else if (hover_item != "none") {
                if (point_and_click(hover_item.draw(xx + 10, yy + 90 + (20 * hover_item.root_item), "Manage"))) {
                    group_selection(garrison_log[$ system_names[hover_item.root_item]].units, {purpose: $"{system_names[hover_item.root_item]} Management", purpose_code: "manage", number: 0, system: star_by_name(system_names[hover_item.root_item]).id, feature: "none", planet: 0, selections: []});
                }
            }
        } else if (view_area == "missions") {
            draw_set_color(c_white);
            draw_set_halign(fa_center);
            draw_text(xx + 80, yy + 50, "Location");
            draw_text(xx + 160, yy + 50, "Mission");
            draw_text(xx + 290, yy + 50, "Time Remaining");
            var i = 0;
            while (i < array_length(mission_log) && (90 + (20 * i) + 12 + 20) < main_panel.height) {
                mission = mission_log[i];
                entered = false;
                if (scr_hit(xx + 10, yy + 90 + (20 * i), xx + main_panel.width, yy + 90 + (20 * i) + 18)) {
                    draw_set_color(c_gray);
                    draw_rectangle(xx + 10 + 20, yy + 90 + (20 * i) - 2, xx + main_panel.width - 20, yy + 90 + (20 * i) + 18, 0);
                    draw_set_color(c_white);
                    entered = true;
                }
                if (mission.system != "") {
                    draw_text(xx + 80, yy + 90 + (20 * i), $"{mission.system} {scr_roman_numerals()[mission.planet - 1]}");
                }
                draw_set_halign(fa_left);
                if (entered) {
                    draw_text(xx + 160 - 20, yy + 90 + (20 * i), mission.mission);
                } else {
                    draw_text(xx + 160 - 20, yy + 90 + (20 * i), string_truncate(mission.mission, 150));
                }
                draw_set_halign(fa_center);
                if (!entered) {
                    draw_text(xx + 310, yy + 90 + (20 * i), mission.time);
                }
                if (point_and_click([xx + 10, yy + 90 + (20 * i) - 2, xx + main_panel.width, yy + 90 + (20 * i) + 18])) {
                    var star = star_by_name(mission.system);
                    if (star != "none") {
                        travel_target = [
                            star.x,
                            star.y
                        ];
                    }
                    travel_increments = [
                        (travel_target[0] - obj_controller.x) / 15,
                        (travel_target[1] - obj_controller.y) / 15
                    ];
                    travel_time = 0;
                }
                i++;
            }
        }
    };

    static draw = function() {
        add_draw_return_values();
        if (obj_controller.menu == 0 && obj_controller.zoomed == 0) {
            if (!instances_exist_any([obj_fleet_select, obj_star_select])) {
                var x_draw = 0;
                var lower_draw = main_panel.height + 110;
                if (hide_sequence == 30) {
                    hide_sequence = 0;
                }
                if ((hide_sequence > 0 && hide_sequence < 15) || (hide_sequence > 15 && hide_sequence < 30)) {
                    if (hide_sequence > 15) {
                        x_draw = ((main_panel.width / 15) * (hide_sequence - 15)) - main_panel.width;
                    } else {
                        x_draw = -((main_panel.width / 15) * hide_sequence);
                    }
                    hide_sequence++;
                }
                if (hide_sequence > 15 || hide_sequence < 15) {
                    main_panel.draw(x_draw, 110, 0.46, 0.75);
                    if (tab_buttons.fleets.draw(x_draw, 79, "Fleets")) {
                        view_area = "fleets";
                    }
                    if (tab_buttons.garrisons.draw(115 + x_draw, 79, "System Troops")) {
                        view_area = "garrisons";
                        update_garrison_log();
                    }
                    if (tab_buttons.missions.draw(230 + x_draw, 79, "Missions")) {
                        view_area = "missions";
                        update_garrison_log();
                    }
                    if (x_draw < 0) {
                        tab_buttons.hider.draw(0, lower_draw, "Show");
                    } else {
                        if (tab_buttons.hider.draw(x_draw + 280, lower_draw, "Hide")) {
                            hide_sequence++;
                        }
                    }
                } else if (hide_sequence == 15) {
                    if (tab_buttons.hider.draw(0, lower_draw, "Show")) {
                        hide_sequence++;
                    }
                }
                /*if (tab_buttons.troops.draw(345,79, "Troops")){
				    view_area="troops";
				}*/
            }
            if (array_length(travel_target) == 2) {
                if (obj_controller.x != travel_target[0] || obj_controller.y != travel_target[1]) {
                    obj_controller.x += travel_increments[0];
                    obj_controller.y += travel_increments[1];
                    travel_time++;
                } else {
                    travel_target = [];
                }
                if (travel_time == 15) {
                    obj_controller.x = travel_target[0];
                    obj_controller.y = travel_target[1];
                    travel_target = [];
                }
            }
        }
        pop_draw_return_values();
    };
}

function HoverBox() constructor {
    root_item = "none";
    relative_x = 0;
    relative_y = 0;
    location = [
        0,
        0,
        0,
        0
    ];

    static draw = function(xx, yy, button_text) {
        location = draw_unit_buttons([relative_x, relative_y], button_text, [1, 1], c_green,, fnt_40k_14b, 1);
        return location;
    };
}

function exit_adhoc_manage() {
    scr_toggle_manage();
    if (struct_exists(selection_data, "system") && instance_exists(selection_data.system)) {
        selection_data.system.alarm[3] = 2;
    }
}

function update_garrison_manage() {
    location_viewer.update_garrison_log();
    var _selection = [];
    var sys_name = "";
    var _ships = -1;
    var _planets = 0;
    if (struct_exists(selection_data, "system") && instance_exists(selection_data.system)) {
        if (struct_exists(location_viewer.garrison_log, selection_data.system.name)) {
            var sys_name = selection_data.system.name;
        }
    }

    if (struct_exists(selection_data, "ships")) {
        _ships = selection_data.ships;
    }

    if (struct_exists(selection_data, "planets")) {
        _planets = selection_data.planets;
    }

    _selection = collect_role_group("all", [sys_name, _planets, _ships]);

    if (array_length(_selection)) {
        group_selection(_selection, selection_data);
    } else {
        exit_adhoc_manage();
    }
}

function update_general_manage_view() {
    with (obj_controller) {
        if (managing > 0) {
            if ((managing <= 10) && (managing != 0)) {
                scr_company_view(managing);
            }
            if ((managing > 10) || (managing == 0)) {
                scr_special_view(managing);
            }
            new_company_struct();
            cooldown = 10;
            sel_loading = -1;
            unload = 0;
            alarm[6] = 30;
        } else if (managing == -1) {
            update_garrison_manage();
        }
    }
}

function toggle_selection_borders() {
    for (var p = 0; p < array_length(display_unit); p++) {
        if ((man_sel[p] == 1) && (man[p] == "man")) {
            if (is_struct(display_unit[p])) {
                var _unit = display_unit[p];
                var mar_id = _unit.marine_number;
                if ((_unit.ship_location > -1) && _unit.controllable()) {
                    _unit.is_boarder = !_unit.is_boarder;
                }
            }
        }
    }
}

function add_bionics_selection() {
    var bionics_before = scr_item_count("Bionics");
    if (bionics_before > 0) {
        for (var p = 0; p < array_length(display_unit); p++) {
            if (man_sel[p] != 0 && is_struct(display_unit[p])) {
                var _unit = display_unit[p];
                var comp = _unit.company;
                var mar_id = _unit.marine_number;
                if (_unit.controllable()) {
                    //TODO swap for tag method
                    if (string_count("Dread", ma_armour[p]) == 0) {
                        _unit.add_bionics();
                        if (ma_promote[p] == 10) {
                            ma_promote[p] = 0;
                        }
                    }
                }
            }
        }
    }
}

function jail_selection() {
    for (var f = 0; f < array_length(display_unit); f++) {
        if (man[f] != "man" || !man_sel[f]) {
            continue;
        }
        _unit = display_unit[f];
        if (_unit.controllable()) {
            if (is_struct(display_unit[f]) && !_unit.in_jail()) {
                obj_ini.god[_unit.company][_unit.marine_number] += 10;
                ma_god[f] += 10;
                man_sel[f] = 0;
            }
        }
    }
    if (managing > 0) {
        alll = 0;
        update_general_manage_view();
    } else if (managing == -1) {
        update_garrison_manage();
    }
    sel_loading = -1;
    unload = 0;
    alarm[6] = 7;
}

function load_selection() {
    if (man_size > 0 && !location_out_of_player_control(selecting_location)) {
        scr_company_load(selecting_location);
        menu = 30;
        top = 1;
    }
}

function unload_selection() {
    if (man_size > 0 && obj_controller.selecting_ship >= 0 && !instance_exists(obj_star_select) && !location_out_of_player_control(selecting_location) && selecting_location != "Warp") {
        cooldown = 8000;
        var boba = 0;
        var unload_star = star_by_name(selecting_location);
        if (unload_star != "none") {
            if (unload_star.space_hulk != 1) {
                for (var t = 0; t < array_length(display_unit); t++) {
                    if (man_sel[t] == 1) {
                        var _unit = display_unit[t];
                        if (is_array(_unit)) {
                            set_vehicle_last_ship(_unit);
                        } else {
                            _unit.set_last_ship();
                        }
                    }
                }
                boba = instance_create(unload_star.x, unload_star.y, obj_star_select);
                boba.loading = 1;
                // selecting location is the ship right now; get it's orbit location
                boba.loading_name = selecting_location;
                boba.depth = self.depth - 50;
                // sel_uid=obj_ini.ship_uid[selecting_ship];
                scr_company_load(obj_ini.ship_location[selecting_ship]);
            }
        }
    }
}

function reset_selection_equipment() {
    var _unit;
    for (var f = 0; f < array_length(display_unit); f++) {
        // If come across a man, set vih to 1
        if ((man[f] == "man") && (man_sel[f] == 1)) {
            if (is_struct(display_unit[f])) {
                _unit = display_unit[f];
                _unit.set_default_equipment();
            }
        }
    }
}

function add_tag_to_selection(new_tag) {
    var _unit;
    for (var f = 0; f < array_length(display_unit); f++) {
        // If come across a man, set vih to 1
        if ((man[f] == "man") && (man_sel[f] == 1)) {
            if (is_struct(display_unit[f])) {
                _unit = display_unit[f];
                _unit[$ new_tag] = !_unit[$ new_tag];
            }
        }
    }
}

function promote_selection() {
    if ((sel_promoting == 1) && (instance_number(obj_popup) == 0)) {
        var pip = instance_create(0, 0, obj_popup);
        pip.type = 5;
        pip.company = managing;

        var god = 0, nuuum = 0;
        for (var f = 1; f < array_length(display_unit); f++) {
            if ((ma_promote[f] >= 1 || is_specialist(ma_role[f], SPECIALISTS_RANK_AND_FILE) || is_specialist(ma_role[f], SPECIALISTS_SQUAD_LEADERS)) && man_sel[f] == 1) {
                nuuum += 1;
                if (pip.min_exp == 0) {
                    pip.min_exp = ma_exp[f];
                }
                pip.min_exp = min(ma_exp[f], pip.min_exp);
            }
            if ((god == 0) && (ma_promote[f] >= 1) && (man_sel[f] == 1)) {
                god = 1;
                pip.unit_role = ma_role[f];
            }
        }
        if (nuuum > 1) {
            pip.unit_role = "Marines";
        }
        pip.units = nuuum;
    }
}

//to be run in obj_star_select
function setup_planet_mission_group() {
    man_sel = [];
    display_unit = [];
    man = [];
    return_place = [];
    for (var i = 0; i < array_length(obj_controller.display_unit); i++) {
        if (obj_controller.man_sel[i]) {
            array_push(man_sel, obj_controller.man_sel[i]);
            array_push(display_unit, obj_controller.display_unit[i]);
            array_push(man, obj_controller.man[i]);
            array_push(return_place, obj_controller.ma_lid[i]);
        }
    }
}

function HelpfulPlaces() constructor {
    main_panel = new DataSlate({draggable: true, cherub: true});
    var _imperial_help_requests = stars_with_help_requests();

    var _help_requests = [];

    for (var i = 0; i < array_length(_imperial_help_requests); i++) {
        var _star = _imperial_help_requests[i];
        var _data = {
            name: _star.name,
            star_id: _star,
            system_count: _star.planets,
        };

        var _helps = 0;
        for (var h = 1; h <= _star.planets; h++) {
            if (_star.p_halp[h] > 0) {
                _helps++;
            }
        }
        _data.help_requests = _helps;

        _data.hover = method(_data, function() {
            tooltip_draw($"View {name}");
        });

        _data.click_left = method(_data, function() {
            set_map_pan_to_loc(star_id);
        });

        array_push(_help_requests, _data);
    }

    static x1 = 1289;
    static y1 = 318;
    main_panel.XX = x1;
    main_panel.YY = y1;

    static entered = function() {
        return main_panel.entered();
    };

    help_table = new Table({row_key_draw: ["name", "system_count", "help_requests"], headings: ["System", "Planets", "Planets\nRequesting Help"], row_data: _help_requests});

    var _navy_fleets = [];

    with (obj_en_fleet) {
        if (owner != eFACTION.Imperium || !navy) {
            continue;
        }
        var _guard_percentage = fleet_remaining_guard_ratio() * 100;

        var _data = {
            fleet_id: id,
            location: "Warp",
            remaining_guard: $"{_guard_percentage}%",
            action: trade_goods,
        };
        if (is_orbiting()) {
            _data.location = orbiting.name;
        }

        _data.hover = method(_data, function() {
            if (location != "Warp") {
                tooltip_draw($"View fleet at {location}");
            } else {
                tooltip_draw($"View fleet");
            }
        });

        _data.click_left = method(_data, function() {
            set_map_pan_to_loc(fleet_id);
        });

        array_push(_navy_fleets, _data);
    }

    navy_table = new Table({row_key_draw: ["location", "remaining_guard"], headings: ["Location", "Remaining\nGuard"], row_data: _navy_fleets});

    var _forges = [];

    var _columns = [];
    var _longest_name = 0;
    with (obj_star) {
        var _forge = scr_get_planet_with_type(id, "Forge");
        if (_forge > 0) {
            var _data = {
                system: id,
                planet: _forge,
                name: planet_numeral_name(_forge),
                owner_name: obj_controller.faction[p_owner[_forge]],
                owner: p_owner[_forge],
                owner_status: obj_controller.faction_status[p_owner[_forge]],
            };

            _data.click_left = method(_data, function() {
                set_map_pan_to_loc(system);
            });

            _data.hover = method(_data, function() {
                tooltip_draw($"click to view {system.name} system");
            });

            var _name_length = string_width(_data.name);
            if (_name_length > _longest_name) {
                _longest_name = _name_length;
            }

            array_push(_forges, _data);
        }
    }
    array_push(_columns, _longest_name);

    forges_table = new Table({row_key_draw: ["name", "owner_name", "owner_status"], headings: ["Name", "   Owner   ", "  Owner\nStatus  "], row_data: _forges, set_column_widths: _columns});

    places_radio = new RadioSet([{str1: "Help Requests"}, {str1: "Navy Fleets"}, {str1: "Forge Worlds"}]);

    main_panel.inside_method = function() {
        places_radio.update({x1: x1 + 30, y1: y1 + 25});
        places_radio.draw();

        var _new_position = {
            x1: x1 + 40,
            y1: y1 + 50,
            y2: y1 + main_panel.height,
        };
        switch (places_radio.current_selection) {
            case 1:
                navy_table.update(_new_position);
                navy_table.draw();
                break;
            case 0:
                help_table.update(_new_position);
                help_table.draw();
                break;
            case 2:
                forges_table.update(_new_position);
                forges_table.draw();
                break;
        }
    };

    static draw = function() {
        x1 = main_panel.XX;
        y1 = main_panel.YY;
        main_panel.draw(,, 0.35, 0.6);
    };
}
