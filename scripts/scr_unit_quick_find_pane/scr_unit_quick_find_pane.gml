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

    hovered_fleet_data = undefined;

    static detail_slate = new DataSlateMKTwo();

    view_area = "fleets";
    hover_item = noone;
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

    var _xx = main_panel.XX;
    var _yy = main_panel.YY;

    fleet_table = new Table({
        x1: _xx + 10,
        y1: _yy + 50,
        x2: _xx + main_panel.width,
        y2: _yy + main_panel.height,
        headings: ["Capitals", "Frigates", "Escorts", "Location"],
        row_key_draw: ["capitals", "frigates", "escorts", "location"],
        set_column_widths: [70, 70, 70, 100],
        row_h: 20,
        localize_headings: true,
    });
    fleet_table.last_drawn_sequence = -1;

    static has_troops = function(name) {
        return struct_exists(garrison_log, name);
    };

    static player_force_stars = function() {
        var _names = struct_get_names(garrison_log);
        var _stars = [];
        for (var i = 0; i < array_length(_names); i++) {
            var _star = find_star_by_name(_names[i]);
            if (_star != noone) {
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
        if (!unit.controllable()) {
            return;
        }
        var unit_location = unit.marine_location();
        if (unit_location[0] == eLOCATION_TYPES.PLANET && unit_location[2] != "") {
            add_unit_to_garrison_log(unit, unit_location);
            var group = garrison_log[$ unit_location[2]];
            if (unit.IsSpecialist(SPECIALISTS_APOTHECARIES)) {
                group.healers++;
            } else if (unit.IsSpecialist(SPECIALISTS_TECHS)) {
                group.techies++;
            }
        } else if (unit_location[0] == eLOCATION_TYPES.SHIP) {
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
                u,
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
            delete garrison_log;
            garrison_log = {};
            obj_controller.specialist_point_handler.calculate_research_points(false);
            ship_count = array_length(obj_ini.ship_carrying);
            for (var co = 0; co <= obj_ini.companies; co++) {
                for (var u = 0; u < company_length(co); u++) {
                    /// @type {Struct.TTRPG_stats}
                    var _unit = fetch_unit([co, u]);
                    if (!is_struct(_unit)) {
                        continue;
                    }

                    evaluate_unit_for_garrison_log(_unit);
                }
                try {
                    for (var u = 0; u < array_length(obj_ini.veh_race[co]); u++) {
                        evaluate_vehicle_for_garrison_log(co, u);
                    }
                } catch (_exception) {
                    ERROR_HANDLER.handle_exception(_exception);
                }
            }
            update_mission_log();
        } catch (_exception) {
            ERROR_HANDLER.handle_exception(_exception);
        }
    };

    // ── UPDATER  (call in Step or whenever fleet data changes) ────────────────────
    static update_fleet_table = function() {
        var _xx = main_panel.XX;
        var _yy = main_panel.YY;
        var _rows = [];

        for (var i = start_fleet; i < instance_number(obj_p_fleet); i++) {
            var _cur_fleet = instance_find(obj_p_fleet, i);

            // ── Resolve location string ───────────────────────────────────────────
            var _loc = fleet_location_description(_cur_fleet);
            var _point_data = _cur_fleet.point_breakdown;

            var _sys_points = obj_controller.specialist_point_handler.point_breakdown.systems;
            if (_cur_fleet.orbiting != noone){
                if (struct_exists(_sys_points, _cur_fleet.orbiting.name)) {
                    _point_data = _sys_points[$ _cur_fleet.orbiting.name][0];
                }
            }

            // ── Build row struct, capturing per-iteration values via method() ─────
            var _row = {
                capitals: _cur_fleet.capital_number,
                frigates: _cur_fleet.frigate_number,
                escorts: _cur_fleet.escort_number,
                location: _loc.loc,
                parent: self,
                fleet: _cur_fleet,
                point_data: _point_data,
            };

            _row.hover = method(_row, function() {
                obj_controller.location_viewer.hovered_fleet_data = point_data;
                tooltip_draw(localize("left click to view"));
            });

            // Click to pan camera — only when location is meaningful
            if (_loc.zoomable) {
                _row.click_left = method(_row, function() {
                    set_map_pan_to_loc(fleet);
                });
            }

            array_push(_rows, _row);
        }

        fleet_table.update({row_data: _rows});
    };

    static draw_specialist_point_headers = function(_x, _y) {
        draw_set_font(cjk_font(fnt_40k_12i));
        draw_set_halign(fa_center);
        draw_text(_x + 160, _y + 10, localize("forge point\ntotal"));
        draw_text(_x + 240, _y + 10, localize("forge point\nuse"));
        draw_text(_x + 320, _y + 10, localize("apothecary\npoint total"));
        draw_text(_x + 400, _y + 10, localize("apothecary\npoint use"));
        draw_text(_x + 60, _y + 50, localize("Orbiting"));
    };

    static draw_fleet_area = function() {
        var _xx = main_panel.XX;
        var _yy = main_panel.YY;

        if (fleet_table.row_count() != instance_number(obj_p_fleet)) {
            update_fleet_table();
        }

        if (fleet_table.last_drawn_sequence != hide_sequence){
            fleet_table.last_drawn_sequence = hide_sequence;
            fleet_table.update({x1: _xx + 40, y1: _yy + 50, y2: _yy + 50 + main_panel.height, colour: c_white, font: fnt_40k_14});
        }

        fleet_table.draw();

        // ── Hover detail slate (drawn after table so it renders on top) ───────────
        if (hovered_fleet_data != undefined) {
            var _fpd = hovered_fleet_data;
            var _sx = main_panel.XX + main_panel.width - 10;
            var _sy = _yy + 108;
            detail_slate.draw(_sx, _sy, 1.5, 1.5);

            draw_specialist_point_headers(_sx, _sy);

            // Values
            var _vy = _sy + 50;
            draw_text(_sx + 160, _vy, _fpd.forge_points);
            draw_text(_sx + 240, _vy, _fpd.forge_points_use);
            draw_text(_sx + 320, _vy, _fpd.heal_points);
            draw_text(_sx + 400, _vy, _fpd.heal_points_use);

            hovered_fleet_data = undefined; // reset each frame
        }
    };

    update_mission_log = function() {
        mission_log = [];
        var _temp_log = [];
        with (obj_star) {
            _temp_log = array_concat(_temp_log, problems_to_mission_log());
        }
        with (obj_p_fleet) {
            _temp_log = array_concat(_temp_log, problems_to_mission_log());
        }
        with (obj_en_fleet) {
            _temp_log = array_concat(_temp_log, problems_to_mission_log());
        }
        mission_log = _temp_log;
        var _xx = main_panel.XX;
        var _yy = main_panel.YY;
        var _data = {
            x1: _xx + 60,
            y1: _yy + 50,
            y2: _yy + main_panel.height + 50,
            set_column_widths: [
                70,
                150,
            ],
            headings: [
                "Location",
                "Mission",
                "Time\nRemaining",
            ],
            row_data: mission_log,
            row_key_draw: [
                "system",
                "mission",
                "time",
            ],
            localize_headings: true,
        };
        mission_table = new Table(_data);
    };

    static main_panel_content = function(){
        var _xx = main_panel.XX;
        var _yy = main_panel.YY;
        is_entered = scr_hit(_xx, _yy, _xx + main_panel.width, _yy + main_panel.height);
        // ── DRAW ─────────────────────────────────────────────────────────────────────
        if (view_area == "fleets") {
            draw_fleet_area();
        } else if (view_area == "garrisons") {
            var system_data;
            draw_set_color(c_white);
            draw_set_font(cjk_font(fnt_40k_14));
            draw_set_halign(fa_center);
            draw_text(_xx + 80, _yy + 50, localize("System"));
            draw_text(_xx + 160, _yy + 50, localize("Troops"));
            draw_text(_xx + 240, _yy + 50, localize("Healers"));
            draw_text(_xx + 310, _yy + 50, localize("Techies"));
            var i = start_system;
            var registered_hover = false;
            var system_names = struct_get_names(garrison_log);
            var hover_entered = false;
            var any_hover = false;
            if (hover_item != noone) {
                var loc = hover_item.location;
                hover_entered = scr_hit(loc[0], loc[1], loc[2], loc[3]);
            }
            while (i < array_length(system_names) && (_yy + 122 + (20 * i)) < main_panel.YY + _yy + main_panel.height) {
                var _sys_name = system_names[i];
                system_data = garrison_log[$ _sys_name];
                registered_hover = false;
                var _sys_item_y = _yy + 108 + (20 * i);
                if (scr_hit(_xx + 10, _yy + 90 + (20 * i), _xx + main_panel.width, _sys_item_y)) {
                    if (!hover_entered) {
                        draw_set_color(c_gray);
                        draw_rectangle(_xx + 30, _yy + 88 + (20 * i), _xx + main_panel.width - 20, _yy + 108 + (20 * i), 0);
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
                            draw_rectangle(_xx + 30, _yy + 88 + (20 * i), _xx + main_panel.width - 20, _yy + 108 + (20 * i), 0);
                        }
                    }
                    detail_slate.draw(_xx + main_panel.width - 10, _sys_item_y - 20, 1.5, 1.5);
                    var _special_points = obj_controller.specialist_point_handler.point_breakdown.systems;
                    if (struct_exists(_special_points, _sys_name)) {
                        var _system_point_data = _special_points[$ _sys_name];
                        var _xx = _xx + main_panel.width - 10;
                        var _yy = _sys_item_y - 20;
                        draw_specialist_point_headers(_xx, _yy);
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
                draw_text(_xx + 80, _yy + 90 + (20 * i), system_names[i]);
                draw_text(_xx + 160, _yy + 90 + (20 * i), array_length(system_data.units));
                draw_text(_xx + 240, _yy + 90 + (20 * i), system_data.healers);
                draw_text(_xx + 310, _yy + 90 + (20 * i), system_data.techies);

                if (!hover_entered) {
                    if (point_and_click([_xx + 10, _yy + 88 + (20 * i), _xx + main_panel.width, _yy + 108 + (20 * i)])) {
                        var _star = find_star_by_name(system_names[i]);
                        if (_star != noone) {
                            set_map_pan_to_loc(_star);
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
                hover_item = noone;
            } else if (hover_item != noone) {
                if (point_and_click(hover_item.draw(localize("Manage")))) {
                    group_selection(garrison_log[$ system_names[hover_item.root_item]].units, {purpose: localize("{0} Management", [system_names[hover_item.root_item]]), purpose_code: "manage", number: 0, system: find_star_by_name(system_names[hover_item.root_item]).id, feature: "none", planet: 0, selections: []});
                }
            }
        } else if (view_area == "missions") {
            mission_table.update({x1: _xx + 35, y1: _yy + 50});
            mission_table.draw();
        }
    };

    main_panel.inside_method = method(self, main_panel_content);

    static pane_hide_frames = 15;
    static pane_hidden = 15;
    static pane_revealed = 0;
    static sequence_complete = 30;
    static pane_moving = function(){
        return hide_sequence != pane_hidden && hide_sequence != pane_revealed;
    }
    static hide_reveal_sequence = function(){
        var _x_draw = 0;
        var _lower_draw = main_panel.height + 110;
        if (hide_sequence == sequence_complete) {
            hide_sequence = pane_revealed;
        }
        var _increment = 0;
        if (pane_moving()) {
            _increment = (main_panel.width / pane_hide_frames);
            if (hide_sequence > pane_hide_frames) {
                _x_draw = (_increment * (hide_sequence - pane_hide_frames)) - main_panel.width;
            } else {
                _x_draw = -(_increment * hide_sequence);
            }
            hide_sequence++;
        }
        if (hide_sequence != pane_hidden) {
            main_panel.draw(_x_draw, 110, 0.46, 0.75);
            if (tab_buttons.fleets.draw(_x_draw, 79, localize("Fleets"))) {
                view_area = "fleets";
                update_fleet_table();
            }
            if (tab_buttons.garrisons.draw(115 + _x_draw, 79, localize("System Troops"))) {
                view_area = "garrisons";
                update_garrison_log();
            }
            if (tab_buttons.missions.draw(230 + _x_draw, 79, localize("Missions"))) {
                view_area = "missions";
                update_mission_log();
            }
            if (_x_draw < 0) {
                tab_buttons.hider.draw(0, _lower_draw, localize("Show"));
            } else {
                if (tab_buttons.hider.draw(_x_draw + 280, _lower_draw, localize("Hide"))) {
                    hide_sequence++;
                }
            }
        } else {
            if (tab_buttons.hider.draw(_increment * (hide_sequence - 15) , _lower_draw , localize("Show"))) {
                hide_sequence++;
            }
        }
    }

    static travel_camera_to_target = function(){
        if (array_length(travel_target) != 2) {
            exit;
        }
        if (obj_controller.x != travel_target[0] || obj_controller.y != travel_target[1]) {
            obj_controller.x += travel_increments[0];
            obj_controller.y += travel_increments[1];
            travel_time++;
        } else {
            travel_target = [];
            exit;
        }
        if (travel_time == 15) {
            obj_controller.x = travel_target[0];
            obj_controller.y = travel_target[1];
            travel_target = [];
        }
    }

    errored_once = false;
    static draw = function() {
        try {
            add_draw_return_values();
            if (obj_controller.menu != eMENU.DEFAULT || obj_controller.zoomed) {
                exit;
            }
            if (!instances_exist_any([obj_fleet_select, obj_star_select])) {
                hide_reveal_sequence();
            }
            travel_camera_to_target();
            pop_draw_return_values();
        } catch (_exception) {
            if (!errored_once){
                ERROR_HANDLER.handle_exception(_exception);
                errored_once = true;
            }
        } //dangerous to handle will just make game unplayable if crash does occur
    };

    LOGGER.info("UnitQuickFindPanel successfully initialised");
}

function HoverBox() constructor {
    root_item = noone;
    relative_x = 0;
    relative_y = 0;
    location = [
        0,
        0,
        0,
        0,
    ];

    static draw = function(button_text) {
        location = draw_unit_buttons([relative_x, relative_y], button_text, [1, 1], c_green,, fnt_40k_14b, 1);
        return location;
    };
}

/// @self Asset.GMObject.obj_controller
function exit_adhoc_manage() {
    scr_toggle_manage();
    if (struct_exists(selection_data, "system") && instance_exists(selection_data.system)) {
        selection_data.system.alarm[3] = 2;
    }
}

/// @self Asset.GMObject.obj_controller
function update_adhoc_manage() {
    location_viewer.update_garrison_log();
    var _selection = [];
    var _sys_name = "";
    var _ships = -1;
    var _planets = 0;
    if (struct_exists(selection_data, "system") && instance_exists(selection_data.system)) {
        var _sys = selection_data.system;
        if (_sys.object_index == obj_star && struct_exists(location_viewer.garrison_log, _sys.name)) {
            _sys_name = selection_data.system.name;
        }
    }

    if (struct_exists(selection_data, "ships")) {
        _ships = selection_data.ships;
    }

    if (struct_exists(selection_data, "planets")) {
        _planets = selection_data.planets;
    }

    _selection = collect_role_group("all", [_sys_name, _planets, _ships]);

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
            update_adhoc_manage();
        }
    }
}

/// @self Asset.GMObject.obj_controller
function toggle_selection_borders() {
    for (var p = 0; p < array_length(display_unit); p++) {
        if ((man_sel[p] == 1) && (man[p] == "man")) {
            if (is_struct(display_unit[p])) {
                var _unit = display_unit[p];
                if ((_unit.ship_location > -1) && _unit.controllable()) {
                    _unit.is_boarder = !_unit.is_boarder;
                }
            }
        }
    }
}

/// @self Asset.GMObject.obj_controller
function add_bionics_selection() {
    if (scr_item_count("Bionics") <= 0) {
        return;
    }

    for (var i = 0, _len = array_length(display_unit); i < _len; i++) {
        /// @type {Struct.TTRPG_stats}
        var _unit = display_unit[i];

        if (man_sel[i] == 0 || !is_struct(_unit)) {
            continue;
        }

        if (!_unit.controllable()) {
            continue;
        }

        if (string_pos("Dread", ma_armour[i]) > 0) {
            continue;
        }

        _unit.add_bionics();
        ma_health[i] = _unit.hp();
        ma_health_string[i] = $"{round((_unit.hp() / _unit.max_health()) * 100)}% HP";
    }
}

/// @self Asset.GMObject.obj_controller
function jail_selection() {
    for (var f = 0; f < array_length(display_unit); f++) {
        if (man[f] != "man" || !man_sel[f]) {
            continue;
        }
        _unit = display_unit[f];
        if (_unit.controllable()) {
            if (is_struct(display_unit[f]) && !_unit.in_jail()) {
                display_unit[f].god_status += 10;
                ma_god[f] += 10;
                man_sel[f] = 0;
            }
        }
    }
    if (managing > 0) {
        alll = 0;
        update_general_manage_view();
    } else if (managing == -1) {
        update_adhoc_manage();
    }
    sel_loading = -1;
    unload = 0;
    alarm[6] = 7;
}

/// @self Asset.GMObject.obj_controller
function load_selection() {
    if (man_size > 0 && !location_out_of_player_control(selecting_location)) {
        scr_company_load(selecting_location);
        menu = eMENU.GAME_HELP;
        top = 1;
    }
}

/// @self Asset.GMObject.obj_controller
function unload_selection() {
    if (man_size > 0 && obj_controller.selecting_ship >= 0 && !instance_exists(obj_star_select) && !location_out_of_player_control(selecting_location) && selecting_location != "Warp") {
        cooldown = 8000;
        var unload_star = find_star_by_name(selecting_location);
        if (unload_star != noone) {
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
                var boba = instance_create(unload_star.x, unload_star.y, obj_star_select);
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

/// @self Asset.GMObject.obj_controller
function reset_selection_equipment() {
    for (var f = 0; f < array_length(display_unit); f++) {
        // If come across a man, set vih to 1
        if ((man[f] == "man") && (man_sel[f] == 1)) {
            if (is_struct(display_unit[f])) {
                var _unit = display_unit[f];
                _unit.set_default_equipment();
            }
        }
    }
}

/// @self Asset.GMObject.obj_controller
function add_tag_to_selection(new_tag) {
    for (var f = 0; f < array_length(display_unit); f++) {
        // If come across a man, set vih to 1
        if ((man[f] == "man") && (man_sel[f] == 1)) {
            if (is_struct(display_unit[f])) {
                var _unit = display_unit[f];
                _unit[$ new_tag] = !_unit[$ new_tag];
            }
        }
    }
}

/// @self Asset.GMObject.obj_controller
function promote_selection() {
    if ((sel_promoting == 1) && (!instance_exists(obj_popup))) {
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
/// @self Asset.GMObject.obj_controller
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
    main_panel = new DataSlate({
        draggable: true,
        cherub: true,
    });
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
            tooltip_draw(localize("View {0}", [name]));
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

    help_table = new Table({
        row_key_draw: ["name", "system_count", "help_requests"],
        headings: ["System", "Planets", "Planets\nRequesting Help"],
        row_data: _help_requests,
        localize_headings: true,
    });

    var _navy_fleets = [];

    with (obj_en_fleet) {
        if (owner != eFACTION.IMPERIUM || !navy) {
            continue;
        }
        var _guard_percentage = fleet_remaining_guard_ratio() * 100;

        var _data = {
            fleet_id: id,
            location: fleet_location_description(self).loc,
            remaining_guard: $"{_guard_percentage}%",
            action: trade_goods,
        };

        _data.hover = method(_data, function() {
            if (location != "Warp") {
                tooltip_draw(localize("View fleet at {0}", [location]));
            } else {
                tooltip_draw(localize("View fleet"));
            }
        });

        _data.click_left = method(_data, function() {
            set_map_pan_to_loc(fleet_id);
        });

        array_push(_navy_fleets, _data);
    }

    navy_table = new Table({
        row_key_draw: ["location", "remaining_guard"],
        headings: ["Location", "Remaining\nGuard"],
        row_data: _navy_fleets,
        localize_values: true,
        localize_headings: true,
    });

    var _forges = [];

    var _columns = [];
    var _longest_name = 0;
    with (obj_star) {
        var _forge = scr_get_planet_with_type(id, "Forge");
        if (_forge > 0) {
            var _data = {
                system: id,
                planet: _forge,
                name: planet_numeral_name(_forge, id),
                owner_name: obj_controller.faction[p_owner[_forge]],
                owner: p_owner[_forge],
                owner_status: obj_controller.faction_status[p_owner[_forge]],
            };

            _data.click_left = method(_data, function() {
                set_map_pan_to_loc(system);
            });

            _data.hover = method(_data, function() {
                tooltip_draw(localize("click to view {0} system", [system.name]));
            });

            var _name_length = string_width(_data.name);
            if (_name_length > _longest_name) {
                _longest_name = _name_length;
            }

            array_push(_forges, _data);
        }
    }
    array_push(_columns, _longest_name);

    forges_table = new Table({
        row_key_draw: ["name", "owner_name", "owner_status"],
        headings: ["Name", "   Owner   ", "  Owner\nStatus  "],
        row_data: _forges,
        set_column_widths: _columns,
        localize_values: true,
        localize_headings: true,
    });

    places_radio = new RadioSet(
        [
            {
                str1: "Help Requests",
            },
            {
                str1: "Navy Fleets",
            },
            {
                str1: "Forge Worlds",
            },
        ],
    );

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
        main_panel.draw(x1, y1, 0.35, 0.6);
    };
}
