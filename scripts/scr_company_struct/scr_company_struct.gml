function new_company_struct() {
    with (obj_controller) {
        if (struct_exists(company_data, "company")) {
            company_data.garbage_collect();
            delete company_data;
        }
        company_data = new CompanyStruct(managing);
    }
}

function CompanyStruct(comp) constructor {
    has_squads = true;

    if (comp == 0 || comp == -1) {
        has_squads = false;
    }

    unit_ui_panel = new DataSlate();
    unit_ui_panel.width = 572;
    unit_ui_panel.height = 378;
    unit_ui_panel.XX = 1008;
    unit_ui_panel.YY = 141;
    unit_ui_panel.set_width = true;
    unit_ui_panel.style = "decorated";

    company = comp;
    company_squads = [];
    tooltip_drawing = [];

    static garbage_collect = function() {
        reset_squad_surface();
        delete next_squad_button;
        delete mass_equip_toggle;
        delete previous_squad_button;
        delete reset_loadout_button;
        delete sabotage_button;
        delete garrison_button;
        delete unit_ui_panel;
    };

    squad_location = "";

    static squad_search = function() {
        var _squads = obj_ini.squads;
        //array_copy(_squads, 0, obj_ini.squads, 0, array_length(obj_ini.squads));
        if (company >= 0) {
            company_squads = [];
            var _search_squad;
            var _squad_ids = get_squad_ids();
            for (var i = 0; i < array_length(_squad_ids); i++) {
                _search_squad = fetch_squad(_squad_ids[i]);
                if (_search_squad.base_company != company) {
                    continue;
                }
                _search_squad.update_fulfilment();
                if (bool(array_length(_search_squad.members))) {
                    array_push(company_squads, _search_squad);
                }
            }
        }
        else if (company == -1) {
            var _squad_ids = [];
            var _disp_units = obj_controller.display_unit;
            for (var i = 0; i < array_length(_disp_units); i++) {
                var _unit = _disp_units[i];
                if (is_array(_unit)) {
                    continue;
                }

                if (!struct_exists(_squads, _unit.squad)) {
                    _unit.squad = "none";
                }

                if (_unit.squad == "none") {
                    continue;
                }

                if (array_contains(_squad_ids, _unit.squad)) {
                    continue;
                }

                var _search_squad = _unit.get_squad();
                _search_squad.update_fulfilment();

                if (array_length(_search_squad.members) > 0) {
                    array_push(company_squads, _search_squad);
                    array_push(_squad_ids, _unit.squad);
                }
            }
        }
        if (squad_location != "") {
            var _squads_len = array_length(company_squads);
            for (var i = _squads_len - 1; i >= 0; i--) {
                var _squad = company_squads[i];
                var _squad_loc = _squad.squad_loci();
                if (_squad_loc.system != squad_location) {
                    array_delete(company_squads, i, 1);
                }
            }
        }
        has_squads = array_length(company_squads);
        if (has_squads) {
            obj_controller.unit_focus = company_squads[0].fetch_member(0);
        }
    };

    var xx = __view_get(e__VW.XView, 0) + 0;
    var yy = __view_get(e__VW.YView, 0) + 0;
    center_width = [
        580,
        1005
    ];
    center_height = [
        144,
        957
    ];

    previous_squad_button = new UnitButtonObject({x1: xx + center_width[0], y1: yy + center_height[0] + 6, color: c_red, label: "<--", tooltip: "Press Left arrow to toggle"});

    next_squad_button = new UnitButtonObject({x1: xx + center_width[1] - 44, y1: yy + center_height[0] + 6, color: c_red, label: "-->", tooltip: "Press tab to toggle"});

    garrison_button = new UnitButtonObject({x1: xx + center_width[0] + 5, y1: yy + center_height[0] + 150, color: c_red, label: "Garrison Duty", tooltip: "Having squads assigned to Garrison Duty will increase relations with a planet over time, it will also bolster planet defence forces in case of attack, and reduce corruption growth. Press G to toggle"});

    sabotage_button = new UnitButtonObject({x1: garrison_button.x2 + 5, y1: yy + center_height[0] + 150, color: c_red, label: "Sabotage", tooltip: "Sabotage missions can reduce enemy growth while avoiding direct enemy contact however they are not without risk."});

    reset_loadout_button = new UnitButtonObject({x1: xx + center_width[0] + 5, y1: yy + center_height[0] + 330, color: c_green, label: "Reset Squad Loadout"});

    mass_equip_toggle = new ToggleButton({x1: xx + center_width[0] + 5, y1: yy + center_height[0] + 380, button_color: c_green, text_color: c_green, str1: "Allow mass equip"});

    mass_equip_toggle.update();

    static squad_selection_mode = function() {
        return obj_controller.managing < 0 && obj_controller.selection_data.select_type == eMISSION_SELECT_TYPE.SQUADS;
    };

    select_squad_button = new UnitButtonObject({
        x1: xx + center_width[0] + 5,
        y1: yy + center_height[0] + 150,
        color: c_red,
        label: "Select Squad", //tooltip : obj_controller.selection_data.purpose
    });

    selected_squads = [];

    static send_squad_on_mission = function(mission_type, star) {
        with (star) {
            var unload_squad = instance_create(x, y, obj_star_select);
            unload_squad.target = self;
            unload_squad.loading = 1;
            unload_squad.loading_name = name;
            //unload_squad.loading_name=name;
            unload_squad.depth = -10000;
            unload_squad.mission = mission_type;
            scr_company_load(name);
            break;
        }
    };

    static draw_squad_unit_sprites = function() {
        add_draw_return_values();
        var member_width = 0, member_height = 0;
        var x_mod = 0, y_mod = 0;

        var x_overlap_mod = 0;

        var _start_box = new Box({
            x1 :xx + 25,
            y1 :yy + 144,
            x2 :xx + 925,
            y2 :yy + 981,           
        });

        var _full_box = new Box({
            x1 : xx + 25,
            y1 : yy + 144,
            x2 : xx + 525,
            y2 : yy + 981
        })
        if (unit_rollover) {
            if (_start_box.hit()) {
                x_overlap_mod = 180;
            } else {
                unit_rollover = !unit_rollover;
            }
        } else {
            x_overlap_mod = 90 + (9 * rollover_sequence);
        }
        var sprite_draw_delay = "none";
        var unit_sprite_coords = {};
        var _cur_squad = company_squads[current_squad];
        var _reset_surface = false;
        var _member = _cur_squad.fetch_member(0);
        if (array_length(squad_draw_surfaces) == 0 || (squad_draw_surfaces[0][0] != _member.uid)) {
            reset_squad_surface();
            _reset_surface =  true;
        }   
        for (var i = 0; i < array_length(_cur_squad.members); i++) {
            var _member = _cur_squad.fetch_member(i);

            if (_reset_surface){
                array_push(squad_draw_surfaces, [
                    _member.uid,
                    _member.draw_unit_image()
                ]);
            }


            var _mem_draw_data = squad_draw_surfaces[i];
            var cur_member_surface = _mem_draw_data[1];
            if (_member.name() == "") {
                continue;
            }
            if (member_width == 5) {
                member_width = 0;
                x_mod = 0;
                member_height++;
                y_mod += 231;
            };

            member_width++;

            cur_member_surface.draw_part(_start_box.x1 + x_mod, _start_box.y1 + y_mod, 0, 0, 166, 231, true);

            x_mod += x_overlap_mod;

            var _use_draw_delay = (cur_member_surface.hit() && !exit_period && unit_rollover);

            if(!_use_draw_delay){
                _use_draw_delay = obj_controller.unit_focus.uid == _member.uid;
            }

            if (_use_draw_delay){
                var _outline = cur_member_surface.box();
                _outline.colour = c_red;
                sprite_draw_delay = {
                    unit : _member,
                    draw_coords : _outline,
                    unit_surface : cur_member_surface
                };
                obj_controller.unit_focus = _member;                
            }
        }

        if (is_struct(sprite_draw_delay)) {
            var _member = sprite_draw_delay.unit;
            unit_sprite_coords = sprite_draw_delay.draw_coords;
            var _surface = sprite_draw_delay.unit_surface;
            _surface.draw_part(unit_sprite_coords.x1, unit_sprite_coords.y1, 0, 0, 166, 231, true);
            unit_sprite_coords.draw(true);
            if (mouse_check_button_pressed(mb_left)) {
                unit_rollover = false;
                exit_period = true;
            }
        }
        if (!unit_rollover && !instance_exists(obj_star_select)) {
            if (_full_box.hit() && !exit_period) {
                if (rollover_sequence < 10) {
                    rollover_sequence++;
                } else {
                    unit_rollover = true;
                }
            } else {
                if (rollover_sequence > 0) {
                    rollover_sequence--;
                }
            }
        }
        if (exit_period && !_full_box.hit()) {
            exit_period = false;
        }
        pop_draw_return_values();
    };

    static draw_squad_assignment_options = function() {
        var _squad_sys = squad_loc.system;
        var _cur_squad = company_squads[current_squad];
        if (_cur_squad.assignment == "none") {
            draw_text_transformed(xx + bound_width[0] + 5, yy + bound_height[0] + 125, $"Squad has no current assignments", 1, 1, 0);

            var send_on_mission = false, mission_type;
            if (squad_loc.same_system && (_squad_sys != "Warp" && _squad_sys != "Lost")) {
                if (garrison_button.draw()) {
                    send_on_mission = true;
                    mission_type = "garrison";
                }

                garrison_button.keystroke = press_exclusive(ord("G"));
                if (array_contains(_cur_squad.class, "scout") || array_contains(_cur_squad.class, "bike")) {
                    if (sabotage_button.draw()) {
                        send_on_mission = true;
                        mission_type = "sabotage";
                    }
                }
            }
            if (send_on_mission) {
                send_squad_on_mission(mission_type, find_star_by_name(_squad_sys));
            }
            bound_height[0] += 180;
        } else {
            if (!is_struct(_cur_squad.assignment)) {
                return;
            }
            var cur_assignment = _cur_squad.assignment;
            draw_text_transformed(xx + bound_width[0] + 5, yy + bound_height[0] + 125, $"Assignment : {cur_assignment.type}", 1, 1, 0);
            var tooltip_text = "Cancel Assignment";
            var cancel_but = draw_unit_buttons([xx + bound_width[0] + 5, yy + bound_height[0] + 150], tooltip_text, [1, 1], c_red,,,, true);
            if (point_and_click(cancel_but) || keyboard_check_pressed(ord("C"))) {
                var cancel_system = noone;
                with (obj_star) {
                    if (name == _squad_sys) {
                        cancel_system = self;
                    }
                }
                if (cancel_system != noone) {
                    var planet = _cur_squad.assignment.ident;
                    var operation;
                    for (var i = 0; i < array_length(cancel_system.p_operatives[planet]); i++) {
                        operation = cancel_system.p_operatives[planet][i];
                        if (operation.type == "squad" && operation.reference == _cur_squad.uid) {
                            array_delete(cancel_system.p_operatives[planet], i, 1);
                        }
                    }
                }
                _cur_squad.assignment = "none";
            }
            bound_height[0] += 180;
            if (cur_assignment.type == "garrison") {
                var garrison_but = draw_unit_buttons([cancel_but[2] + 10, cancel_but[1]], "View Garrison", [1, 1], c_red,,,, true);
                if (point_and_click(garrison_but)) {
                    var garrrison_star = find_star_by_name(cur_assignment.location);
                    obj_controller.view_squad = false;
                    if (garrrison_star != "none") {
                        scr_toggle_manage();
                        obj_controller.x = garrrison_star.x;
                        obj_controller.y = garrrison_star.y;
                        obj_controller.selection_data = {
                            system: garrrison_star.id,
                            planet: cur_assignment.ident,
                            feature: "",
                        };
                        garrrison_star.alarm[3] = 4;
                    }
                }
            }

        }
    };

    next_squad = function(up = true) {
        if (up) {
            current_squad = current_squad + 1 >= array_length(company_squads) ? 0 : current_squad + 1;
        } else {
            current_squad = (current_squad - 1 < 0) ? array_length(company_squads) - 1 : current_squad - 1;
        }
        var _member = grab_current_squad().members[0];
        obj_controller.unit_focus = fetch_unit(_member);
    };
    squad_search();

    current_squad = -1;
    exit_period = false;
    unit_rollover = false;
    rollover_sequence = 0;
    selected_unit = obj_controller.unit_focus;
    drop_down_open = false;
    captain = "none";
    champion = "none";
    ancient = "none";
    chaplain = "none";
    apothecary = "none";
    tech_marine = "none";
    lib = "none";

    static reset_squad_surface = function() {
        if (is_array(squad_draw_surfaces)) {
            for (var i = 0; i < array_length(squad_draw_surfaces); i++) {
                var _mem_data = squad_draw_surfaces[i];
                if (!is_array(_mem_data)) {
                    continue;
                }
                if (!is_struct(_mem_data[1])) {
                    continue;
                }

                _mem_data[1].destroy_image();
            }
        }
        squad_draw_surfaces = [];
    };

    squad_draw_surfaces = [];
    reset_squad_surface();

    if (company > 0 && company < 11) {
        var _unit;
        var company_units = obj_controller.display_unit;
        var role_set = obj_ini.role[100];
        for (var i = 0; i < array_length(company_units); i++) {
            if (is_struct(company_units[i])) {
                _unit = company_units[i];
                if (_unit.role() == role_set[eROLE.CAPTAIN]) {
                    captain = _unit;
                } else if (_unit.role() == role_set[eROLE.ANCIENT]) {
                    ancient = _unit;
                } else if (_unit.role() == role_set[eROLE.CHAMPION]) {
                    champion = _unit;
                } else {
                    if (_unit.IsSpecialist(SPECIALISTS_CHAPLAINS)) {
                        chaplain = _unit;
                    }
                    if (_unit.IsSpecialist(SPECIALISTS_APOTHECARIES)) {
                        apothecary = _unit;
                    }
                    if (_unit.IsSpecialist(SPECIALISTS_TECHS)) {
                        tech_marine = _unit;
                    }
                    if (_unit.IsSpecialist(SPECIALISTS_LIBRARIANS)) {
                        lib = _unit;
                    }
                }
            }
        }
    }

    static grab_current_squad = function() {
        return company_squads[current_squad];
    };

    static default_member = function() {
        var _member = company_squads[0].members[0];
        obj_controller.unit_focus = fetch_unit(_member);
        selected_unit = obj_controller.unit_focus;
    };

    static exit_squad_view = function(){
        obj_controller.view_squad = false;
        obj_controller.unit_profile = false;       
    }

    static draw_squad_view = function() {
        center_width = [
            580,
            1005
        ];
        center_height = [
            144,
            957
        ];
        xx = __view_get(e__VW.XView, 0) + 0;
        yy = __view_get(e__VW.YView, 0) + 0;
        var _member;
        selected_unit = obj_controller.unit_focus;
        if (array_length(company_squads) == 0) {
            exit_squad_view();
            return;
        }

        if (current_squad == -1){
            current_squad = 0;
        }

        var _find_squad_member = false;
        if (selected_unit.company == company || company == -1) {
            var _current = grab_current_squad();
            if (_current.uid != selected_unit.squad) {
                var squad_found = false;
                for (var i = 0; i < array_length(company_squads); i++) {
                    if (company_squads[i].uid == selected_unit.squad) {
                        current_squad = i;
                        squad_found = true;
                        break;
                    }
                }
                if (!squad_found) {
                    _find_squad_member = true;
                }
            }
        } else {
            _find_squad_member = true;
        }

        if (selected_unit.squad == "none") {
            _find_squad_member = true;
        }

        if (_find_squad_member){
            default_member();
        }

        if (selected_unit.squad == "none"){
            exit_squad_view();
            return;
        }

        var _cur_squad = selected_unit.get_squad();
        bound_width = center_width;
        bound_height = center_height;
        draw_set_halign(fa_left);

        if (array_length(company_squads) > 0) {
            if (previous_squad_button.draw()) {
                next_squad(false);
            }
            if (next_squad_button.draw()) {
                next_squad();
            }
        }

        draw_set_color(c_gray);
        draw_set_alpha(1);
        draw_set_halign(fa_center);
        var _base_x = xx + bound_width[0] + ((bound_width[1] - bound_width[0]) / 2);
        draw_text_transformed(_base_x - 6, yy + bound_height[0] + 6, $"{_cur_squad.display_name}", 1.5, 1.5, 0);
        if (_cur_squad.nickname != "") {
            draw_text_transformed(_base_x, yy + bound_height[0] + 30, $"{_cur_squad.display_name}", 1.5, 1.5, 0);
        }

        draw_set_halign(fa_left);
        //should be moved elsewhere for efficiency
        squad_leader = _cur_squad.determine_leader();
        if (squad_leader != "none") {
            var leader_text = $"Squad Leader : {fetch_unit(squad_leader).name_role()}";
            draw_text_transformed(xx + bound_width[0] + 5, yy + bound_height[0] + 50, leader_text, 1, 1, 0);
        }
        squad_loc = _cur_squad.squad_loci();
        draw_text_transformed(xx + bound_width[0] + 5, yy + bound_height[0] + 75, $"Squad Members : {_cur_squad.life_members}", 1, 1, 0);
        draw_text_transformed(xx + bound_width[0] + 5, yy + bound_height[0] + 100, $"Squad Location : {squad_loc.text}", 1, 1, 0);

        if (!squad_selection_mode()) {
            draw_squad_assignment_options();
        } else {
            var _select_action = false;
            var _selected_squad = array_contains(selected_squads, _cur_squad.uid);
            var _squad_button_dat = {
                x1: xx + center_width[0] + 5,
                y1: yy + center_height[0] + 150,
                color: _selected_squad ? c_red : c_green,
                label : _selected_squad? "De-select Squad" : "Select Squad",
            }

            if (!_selected_squad) {
                _squad_button_dat.tooltip = obj_controller.selection_data.purpose;
                _select_action = true;
            }

            select_squad_button.update(_squad_button_dat);
            if (select_squad_button.draw()) {
                if (_select_action) {
                    array_push(selected_squads, _cur_squad.uid);
                } else {
                    array_delete(selected_squads, array_find_value(selected_squads, _cur_squad.uid), 1);
                }
            }
        }
        bound_height[0] += 125;
        previous_squad_button.keystroke = press_exclusive(vk_left);
        next_squad_button.keystroke = press_exclusive(vk_tab);
        //TODO compartmentalise drop down option logic
        var deploy_text = "Squad will deploy in the";
        if (_cur_squad.formation_place != "") {
            //draw_set_font(fnt_40k_14b)
            draw_text_transformed(xx + bound_width[0] + 5, yy + bound_height[0], deploy_text, 1, 1, 0);
            button = draw_unit_buttons([xx + bound_width[0] + 5 + string_width(deploy_text), yy + bound_height[0] - 2], _cur_squad.formation_place, [1, 1], c_green,,,, true);
            draw_set_color(c_red);
            draw_text_transformed(xx + bound_width[0] + 5 + string_width(deploy_text) + string_width(_cur_squad.formation_place) + 9, yy + bound_height[0], "column", 1, 1, 0);
            draw_set_color(c_gray);
            if (array_length(_cur_squad.formation_options) > 1) {
                if (scr_hit(button)) {
                    drop_down_open = true;
                }
                if (drop_down_open) {
                    var roll_down_offset = 8 + string_height(_cur_squad.formation_place);
                    for (var col = 0; col < array_length(_cur_squad.formation_options); col++) {
                        if (_cur_squad.formation_options[col] == _cur_squad.formation_place) {
                            continue;
                        }
                        button = draw_unit_buttons([button[0], button[3] + 2], _cur_squad.formation_options[col], [1, 1], c_red,,,, true);
                        if (point_and_click(button)) {
                            _cur_squad.formation_place = _cur_squad.formation_options[col];
                            drop_down_open = false;
                        }
                        roll_down_offset += string_height(_cur_squad.formation_options[col]) + 4;
                    }
                    if (!scr_hit(xx + bound_width[0] + 5 + string_width(deploy_text), yy + bound_height[0], xx + bound_width[0] + 13 + string_width(deploy_text) + string_width(_cur_squad.formation_place), yy + bound_height[0] + roll_down_offset)) {
                        drop_down_open = false;
                    }
                }
            }
            bound_height[0] += button[3] - button[1];
        }

        if (reset_loadout_button.draw()) {
            _cur_squad.sort_squad_loadout();
            reset_squad_surface();
        }

        mass_equip_toggle.active = _cur_squad.allow_bulk_swap;
        mass_equip_toggle.clicked();
        mass_equip_toggle.draw();
        _cur_squad.allow_bulk_swap = mass_equip_toggle.active;

        draw_squad_unit_sprites();
    };
}
