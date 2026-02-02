/// @description Primary controller for the Chapter's armory and production.
function Armamentarium() constructor {
    // --- UI State ---
    shop_type = "weapons";
    is_in_forge = false;
    page_mod = 0;
    construction_started = 0;
    eta = 0;
    target_comp = obj_controller.new_vehicles;

    // --- Calculation State ---
    forge_cost_mod = 1.0;
    discount_stc = 0;
    discount_rogue_trader = 1.0;
    cost_tooltip = "";

    count_techmarines = scr_role_count(obj_ini.role[100][16], "");
    count_aspirants = scr_role_count(string(obj_ini.role[100][16]) + " Aspirant", "");
    count_total = count_techmarines + count_aspirants;

    // --- Components ---
    slate_panel = new DataSlate();
    tab_buttons = {
        weapons: new MainMenuButton(spr_ui_but_3, spr_ui_hov_3),
        armour: new MainMenuButton(spr_ui_but_3, spr_ui_hov_3),
        vehicles: new MainMenuButton(spr_ui_but_3, spr_ui_hov_3),
        ships: new MainMenuButton(spr_ui_but_3, spr_ui_hov_3),
    };

    speeding_bits = {
        wargear: new SpeedingDot(0, 0, (210 / 6) * obj_controller.stc_wargear),
        vehicles: new SpeedingDot(0, 0, (210 / 6) * obj_controller.stc_vehicles),
        ships: new SpeedingDot(0, 0, (210 / 6) * obj_controller.stc_ships),
    };

    forge_button = new ShutterButton();
    forge_button.cover_text = "FORGE";
    stc_flashes = new GlowDot();
    gift_stc_button = new UnitButtonObject({x1: 650, y1: 467, style: "pixel", label: "Gift", set_width: true, w: 90});
    identify_stc_button = new UnitButtonObject({x1: 670, y1: 467, style: "pixel", label: "Identify", set_width: true, w: 90});

    // --- Data Storage ---
    shop_items = {
        weapons: [],
        armour: [],
        gear: [],
        mobility: [],
        vehicles: [],
        warships: [],
        production: [],
    };

    master_catalog = [];
    is_initialized = false;

    // Mapping for data lookups
    static shop_data_lookup = {
        weapons: global.weapons,
        armour: global.gear[$ "armour"],
        gear: global.gear[$ "gear"],
        mobility: global.gear[$ "mobility"],
        vehicles: global.vehicles,
        vehicle_gear: global.vehicle_gear,
    };

    // -------------------------------------------------------------------------
    // LOGIC METHODS
    // -------------------------------------------------------------------------

    /// @description One-time setup to build every ShopItem.
    static initialize_master_catalog = function() {
        var _t_start_1 = get_timer();

        if (is_initialized) {
            return;
        }

        var _categories = [
            "weapons",
            "armour",
            "gear",
            "mobility",
            "vehicles"
        ];
        for (var c = 0; c < array_length(_categories); c++) {
            var _cat = _categories[c];
            var _data_source = shop_data_lookup[$ _cat];
            if (!is_struct(_data_source)) {
                continue;
            }

            var _names = variable_struct_get_names(_data_source);
            for (var i = 0; i < array_length(_names); i++) {
                var _name = _names[i];
                var _raw = _data_source[$ _name];

                var _item = new ShopItem(_name);
                _item.area = _cat;
                _item.value = _raw[$ "value"] ?? 0;
                _item.no_buying = _raw[$ "no_buying"] ?? false;

                var _equip_info = gear_weapon_data("any", _name);
                _item.tooltip = is_struct(_equip_info) ? _equip_info.item_tooltip_desc_gen() : "";

                array_push(master_catalog, _item);
            }
        }

        array_sort(master_catalog, true);

        is_initialized = true;

        var _t_end_1 = get_timer();
        var _elapsed_ms_1 = (_t_end_1 - _t_start_1) / 1000;
        show_debug_message($"⏱️ Execution Time of initialize_master_catalog: {_elapsed_ms_1}ms");
    };

    /// @description Calculates active discounts based on fleet and star positions.
    static _calculate_discounts = function() {
        discount_rogue_trader = 1.0;

        with (obj_star) {
            if (trader <= 0) {
                continue;
            }

            // If we own the star and there's a trader
            if (array_contains(p_owner, 1)) {
                other.discount_rogue_trader = 0.8;
                break;
            }

            /// @type {Asset.GMObject.obj_p_fleet}
            var _fleet = instance_place(x, y, obj_p_fleet);
            if (_fleet != noone) {
                if (_fleet.capital_number > 0 && _fleet.action == "") {
                    other.discount_rogue_trader = 0.8;
                    break;
                }
            }
        }
    };

    /// @description High-speed refresh.
    static refresh_catalog = function() {
        var _t_start_1 = get_timer();

        if (!is_initialized) {
            initialize_master_catalog();
        }

        _calculate_discounts();

        forge_cost_mod = 1.0;
        discount_stc = 0;
        cost_tooltip = "";
        
        switch (shop_type) {
            case "weapons":
            case "armour":
                discount_stc = obj_controller.stc_wargear * 5;
                if (discount_stc > 0) cost_tooltip += $"Wargear STC: -{discount_stc}%\n";
                forge_cost_mod -= (discount_stc / 100);
                break;
                
            case "vehicles":
                discount_stc = obj_controller.stc_vehicles * 3;
                var _hangars = array_length(obj_controller.player_forge_data.vehicle_hanger);
                var _h_disc = _hangars * 3;
                
                if (discount_stc > 0) cost_tooltip += $"Vehicle STC: -{discount_stc}%\n";
                if (_h_disc > 0) cost_tooltip += $"Forge Hangars: -{_h_disc}%\n";
                
                forge_cost_mod -= ((discount_stc + _h_disc) / 100);
                break;
                
            case "warships":
                discount_stc = obj_controller.stc_ships * 5;
                if (discount_stc > 0) cost_tooltip += $"Ship STC: -{discount_stc}%\n";
                forge_cost_mod -= (discount_stc / 100);
                break;
        }
    
        forge_cost_mod = max(0.1, forge_cost_mod);

        shop_items[$ shop_type] = [];
        var _active_list = shop_items[$ shop_type];

        for (var i = 0; i < array_length(master_catalog); i++) {
            var _item = master_catalog[i];

            if (_item.area != shop_type) {
                continue;
            }

            _item.stocked = scr_item_count(_item.name);

            if (is_in_forge) {
                _item.forge_cost = (_item.value * 10) * forge_cost_mod;
            } else {
                _item.buy_cost = round(_item.value * min(_item.buy_cost_mod, discount_rogue_trader));
            }

            if (!_item.no_buying || _item.stocked > 0 || is_in_forge) {
                array_push(_active_list, _item);
            }
        }

        var _t_end_1 = get_timer();
        var _elapsed_ms_1 = (_t_end_1 - _t_start_1) / 1000;
        show_debug_message($"⏱️ Execution Time of refresh_catalog: {_elapsed_ms_1}ms");
    };

    static _process_forge_item = function(_item, _data) {
        if (global.cheat_debug) {
            _item.forge_cost = 0;
            _item.no_forging = false;
            return;
        }

        if (struct_exists(_data, "requires_to_build")) {
            var _reqs = _data.requires_to_build;
            for (var j = 0; j < array_length(_reqs); ++j) {
                if (!array_contains(obj_controller.technologies_known, _reqs[j])) {
                    _item.no_forging = true;
                    break;
                }
            }
        }

        if (!_item.no_forging) {
            var _disc = obj_controller.stc_wargear * 5;
            var _mod = 1.0 - (_disc / 100);
            _item.forge_cost = (_item.value * 10) * _mod;
        }
    };

    static _process_buy_item = function(_item) {
        if (global.cheat_debug) {
            _item.buy_cost = 0;
            _item.no_buying = false;
            return;
        }
        _item.buy_cost = round(_item.value * min(_item.buy_cost_mod, discount_rogue_trader));
    };

    /// @description Sells an item back to the market.
    static sell_item = function(_shop_item, _count, _modifier) {
        if (_shop_item.stocked < _count) {
            return false;
        }

        var _sell_price = (_shop_item.buy_cost * _modifier) * _count;
        scr_add_item(_shop_item.name, -_count, "standard");

        _shop_item.stocked -= _count;
        obj_controller.requisition += _sell_price;
        return true;
    };

    /// @desc Internal logic for various purchase types.
    static _execute_purchase = function(_item, _cost, _count) {
        obj_controller.requisition -= _cost;

        // 1. Warships
        if (shop_type == "warships") {
            var _duration = (_item.name == "Battle Barge") ? 30 : 10;
            eta = _duration;
            construction_started = 120;
            add_event({e_id: "ship_construction", ship_class: _item.name, duration: _duration});
            return;
        }

        // 2. Vehicles
        var _vehicle_list = [
            "Rhino",
            "Predator",
            "Land Raider",
            "Whirlwind",
            "Land Speeder"
        ];
        if (array_contains(_vehicle_list, _item.name)) {
            repeat (_count) {
                scr_add_vehicle(_item.name, target_comp, {});
            }
            with (obj_ini) {
                scr_vehicle_order(other.target_comp);
            }
        } else {
            // 3. Standard Gear
            scr_add_item(_item.name, _count);
        }

        _item.stocked += _count;
        audio_play_sound(snd_click, 10, false);
    };

    /// @desc Handles the consumption of fragments and leveling up STC categories.
    static _perform_identification = function() {
        var _target = "";

        if (obj_controller.stc_wargear_un > 0 && obj_controller.stc_wargear < 6) {
            obj_controller.stc_wargear_un--;
            _target = "wargear";
        } else if (obj_controller.stc_vehicles_un > 0 && obj_controller.stc_vehicles < 6) {
            obj_controller.stc_vehicles_un--;
            _target = "vehicles";
        } else if (obj_controller.stc_ships_un > 0 && obj_controller.stc_ships < 6) {
            obj_controller.stc_ships_un--;
            _target = "ships";
        }

        if (_target == "") {
            return;
        }

        switch (_target) {
            case "wargear":
                obj_controller.stc_wargear++;
                if (obj_controller.stc_wargear == 2) {
                    obj_controller.stc_bonus[1] = irandom_range(1, 5);
                }
                if (obj_controller.stc_wargear == 4) {
                    obj_controller.stc_bonus[2] = irandom_range(1, 3);
                }
                obj_controller.stc_research.wargear = 0;
                break;
            case "vehicles":
                obj_controller.stc_vehicles++;
                if (obj_controller.stc_vehicles == 2) {
                    obj_controller.stc_bonus[3] = irandom_range(1, 5);
                }
                if (obj_controller.stc_vehicles == 4) {
                    obj_controller.stc_bonus[4] = irandom_range(1, 3);
                }
                obj_controller.stc_research.vehicles = 0;
                break;
            case "ships":
                obj_controller.stc_ships++;
                if (obj_controller.stc_ships == 2) {
                    obj_controller.stc_bonus[5] = irandom_range(1, 5);
                }
                if (obj_controller.stc_ships == 4) {
                    obj_controller.stc_bonus[6] = irandom_range(1, 3);
                }
                obj_controller.stc_research.ships = 0;
                break;
        }

        refresh_catalog();
    };

    static _switch_tab = function(_new_type) {
        if (shop_type == _new_type) {
            return;
        }
        shop_type = _new_type;
        page_mod = 0;
        refresh_catalog();
    };

    // -------------------------------------------------------------------------
    // DRAW METHODS
    // -------------------------------------------------------------------------

    /// @desc Main Draw entry point.
    static draw = function() {
        _draw_background();
        _draw_header();

        if (is_in_forge) {
            _draw_forge_interface();
        } else {
            _draw_advisor_text()
            _draw_stc_panel();
        }

        _draw_tabs();
        _draw_company_selector();
        _draw_item_list();
    };

    static _draw_background = function() {
        draw_sprite(spr_rock_bg, 0, 0, 0);

        draw_set_alpha(0.75);
        draw_set_color(c_black);
        draw_rectangle(342, 66, 903, 818, false);

        draw_set_alpha(1.0);
        draw_set_color(c_gray);
        draw_rectangle(342, 66, 903, 818, true);
        draw_line(342, 426, 903, 426);
    };

    static _draw_header = function() {
        var _is_adept = obj_controller.menu_adept == 1;
        var _splash_idx = _is_adept ? 1 : (obj_ini.custom_advisors[$ "forge_master"] ?? 5);

        scr_image("advisor/splash", _splash_idx, 16, 43, 310, 828);

        draw_set_halign(fa_left);
        draw_set_font(fnt_40k_30b);
        draw_set_color(c_gray);

        var _title = is_in_forge ? "Forge" : "Armamentarium";
        draw_text(352, 66, _title);

        draw_set_font(fnt_40k_14b);
        var _sub = _is_adept ? $"Adept {obj_controller.adept_name}" : $"Forge Master {obj_ini.name[0][1]}";
        draw_text(352, 100, _sub);
    };

    static _draw_stc_panel = function() {
        draw_set_font(fnt_40k_14);
        var _total_un = obj_controller.stc_wargear_un + obj_controller.stc_vehicles_un + obj_controller.stc_ships_un;
        draw_text(384, 468, $"{_total_un} Unidentified Fragments");

        _draw_stc_bars();

        if (gift_stc_button.draw(_total_un > 0)) {
            setup_gift_stc_popup();
        }

        identify_stc_button.update({x1: gift_stc_button.x2});
        if (identify_stc_button.draw(_total_un > 0)) {
            audio_play_sound(snd_stc, -500, false);
            _perform_identification();
        }
    };

    /// @desc Draws the text descriptions for STC levels.
    static _draw_stc_bonus_text = function(_category, _x_off, _current_level) {
        static _bonus_data = {
            wargear: [
                "8% discount",
                "Enhanced Bolts",
                "16% discount",
                "Enhanced Fist Weapons",
                "25% discount",
                "Can produce Terminator Armour and Dreadnoughts."
            ],
            vehicles: [
                "8% discount",
                "Enhanced Hull",
                "16% discount",
                "Enhanced Armour",
                "25% discount",
                "Can produce Land Speeders and Land Raiders."
            ],
            ships: [
                "8% discount",
                "Enhanced Hull",
                "16% discount",
                "Enhanced Armour",
                "25% discount",
                "Warp Speed is increased and ships self-repair."
            ],
        };

        var _bonuses = _bonus_data[$ _category];
        draw_set_font(fnt_40k_12);

        for (var s = 0; s < array_length(_bonuses); s++) {
            draw_set_alpha(_current_level > s ? 1.0 : 0.5);
            draw_text_ext(_x_off + 22, 549 + (s * 35), $"{s + 1}) {_bonuses[s]}", -1, 140);
        }
        draw_set_alpha(1.0);
    };

    /// @desc Draws the research progress bars and bonuses.
    static _draw_stc_bars = function() {
        static _categories = [
            "wargear",
            "vehicles",
            "ships"
        ];
        static _display_names = [
            "Wargear",
            "Vehicles",
            "Ships"
        ];

        var _yy = 535;

        for (var i = 0; i < 3; i++) {
            var _cat = _categories[i];
            var _x_off = 350 + (i * 180);
            var _rect = [
                _x_off,
                _yy,
                _x_off + 170,
                _yy + 265
            ];
            var _is_focus = obj_controller.stc_research.research_focus == _cat;
            var _stc_cat = $"stc_{_cat}";
            var _level = variable_instance_get(obj_controller, _stc_cat);

            // Interaction
            if (scr_hit(_rect)) {
                draw_set_color(c_white);
                draw_rectangle_array(_rect, true);
                tooltip_draw($"Click to focus research on {_display_names[i]}");
                if (scr_click_left()) {
                    obj_controller.stc_research.research_focus = _cat;
                }
            }

            // Bar Rendering
            draw_sprite_ext(spr_research_bar, 0, _x_off + 9, _yy + 19, 1, 0.7, 0, c_white, 1);
            if (_level > 0) {
                speeding_bits[$ _cat].draw(_x_off, _yy + 20);
            }

            for (var f = 0; f < 6; f++) {
                if (f >= _level) {
                    draw_sprite_ext(spr_research_bar, 1, _x_off + 9, _yy + 19 + (35 * f), 1, 0.6, 0, c_white, 1);
                }
            }

            if (_is_focus) {
                stc_flashes.draw(_x_off + 9, _yy + 19 + (35 * _level));
            }

            // Text & Bonuses
            draw_set_font(fnt_40k_14);
            draw_set_color(_is_focus ? c_white : c_gray);
            draw_text(_x_off + 36, _yy - 18, _display_names[i]);

            _draw_stc_bonus_text(_cat, _x_off, _level);
        }
    };

    static _draw_item_list = function() {
        slate_panel.inside_method = function() {
            var _self = obj_controller.armamentarium;
            var _list = _self.shop_items[$ _self.shop_type];
            var _items_count = array_length(_list);
            var _items_per_page = 27;
            var _start_index = _items_per_page * _self.page_mod;
            var _draw_y_local = 157;

            draw_set_font(fnt_40k_14b);
            draw_set_halign(fa_left);
            draw_text(962, 159, "Name");
            if (_self.shop_type != "production") {
                draw_text(1280, 159, "Stocked");
            }
            draw_text(1410, 159, "Cost");

            for (var i = _start_index; i < min(_start_index + 27, _items_count); i++) {
                /// @type {Struct.ShopItem}
                var _item = _list[i];
                _draw_y_local += 20;
                var _screen_y = _draw_y_local;

                // 1. Interaction & Hover
                var _is_hovered = scr_hit(962, _screen_y + 2, 1580, _screen_y + 18);
                var _can_act = (_self.is_in_forge) ? !_item.no_forging : !_item.no_buying;
                var _is_shift = keyboard_check(vk_shift) && (_self.shop_type != "warships" && _self.shop_type != "production");
                var _mult = _is_shift ? 5 : 1;

                if (_is_hovered) {
                    draw_set_alpha(0.2);
                    draw_rectangle(960, _draw_y_local + 1, 1582, _draw_y_local + 18, false);
                    draw_set_alpha(1.0);
                    if (_item.tooltip != "") {
                        tooltip_draw(_item.tooltip, 400);
                    }
                }

                // 2. Draw Name & Stock
                var _display_name = _is_shift ? $"{_item.name} x5" : _item.name;
                draw_text_color_simple(962 + _item.x_mod, _draw_y_local, _display_name, _can_act ? c_gray : #881503, 1);

                if (_self.shop_type != "production") {
                    var _stock_text = string(_item.stocked);
                    if (_item.mc_stocked > 0) {
                        _stock_text += $"  mc: {_item.mc_stocked}";
                    }
                    draw_text_alpha(1300, _draw_y_local, _stock_text, (_item.stocked == 0 && _item.mc_stocked == 0) ? 0.5 : 1);
                }

                // 3. Draw Cost
                var _cost = (_self.is_in_forge ? _item.forge_cost : _item.buy_cost) * _mult;
                var _afford = (_self.is_in_forge) ? true : (obj_controller.requisition >= _cost); // Forge uses queue, check happens later

                var _cost_x = 1427
                var _cost_y = _draw_y_local

                draw_text_color_simple(1400, _cost_y, _self.is_in_forge ? "FP" : "RP", _self.is_in_forge ? #af5a00 : #50a8f0, 1);
                draw_text_color_simple(_cost_x, _cost_y, _cost, _afford ? (_self.is_in_forge ? #af5a00 : #50a8f0) : c_red, 1);

                if (scr_hit(_cost_x, _cost_y, _cost_x + 50, _cost_y + 20)) {
                    if (_self.cost_tooltip != "") {
                        tooltip_draw(_self.cost_tooltip);
                    }
                }

                // 4. Action Buttons (Buy/Sell/Build)
                if (_can_act) {
                    _draw_action_buttons(_item, _draw_y_local, _cost, _mult, _is_shift);
                }
            }

            var _pages_required = ceil(_items_count / _items_per_page);
            if (_pages_required <= 1) return;
    
            draw_set_halign(fa_center);
            for (var p = 0; p < _pages_required; p++) {
                var _btn_x = 1040 + (25 * p);
                var _btn_y = 740;
                var _is_current = (_self.page_mod == p);
                
                var _btn_rect = draw_unit_buttons([_btn_x, _btn_y], string(p + 1), [1, 1], _is_current ? c_green : c_red);
                
                if (point_and_click(_btn_rect)) {
                    _self.page_mod = p;
                }
            }
            draw_set_halign(fa_left);
        };

        slate_panel.draw(920, 95, 0.81, 0.85);
    };

    /// @desc Handles the logic for clicking Buy, Sell, or Build icons.
    /// @param {Struct.ShopItem} _item
    /// @param {Real} _y_pos Local Y coordinate within the slate.
    /// @param {Real} _cost Calculated cost (including multipliers).
    /// @param {Real} _count Quantity (1 or 5).
    /// @param {Bool} _is_shift Whether shift is held.
    static _draw_action_buttons = function(_item, _y_pos, _cost, _count, _is_shift) {
        // --- FORGE MODE: ADD TO QUEUE ---
        if (is_in_forge) {
            draw_sprite(spr_build_tiny, 0, 1530, _y_pos + 2);
            if (point_and_click([1520, _y_pos + 2, 1570, _y_pos + 14])) {
                var _queue = obj_controller.specialist_point_handler.forge_queue;
                if (array_length(_queue) < 20) {
                    array_push(_queue, {name: _item.name, count: _count, forge_points: _cost, ordered: obj_controller.turn, type: _item.forge_type});
                }
            }
            return;
        }

        // --- SHOP MODE: BUYING ---
        var _can_afford = obj_controller.requisition >= _cost;
        draw_set_alpha(_can_afford ? 1.0 : 0.25);
        draw_sprite(spr_buy_tiny, 0, 1530, _y_pos + 2);

        if (_can_afford && point_and_click([1520, _y_pos + 2, 1570, _y_pos + 14])) {
            _execute_purchase(_item, _cost, _count);
        }

        // --- SHOP MODE: SELLING ---
        if (shop_type != "warships" && shop_type != "vehicles" && _item.stocked > 0) {
            draw_set_alpha(1.0);
            var _sell_btn = draw_sprite_as_button([1480, _y_pos + 2], spr_sell_tiny);
            if (scr_hit(_sell_btn[0], _sell_btn[1], _sell_btn[2], _sell_btn[3])) {
                tooltip = $"Send items back for {SHOP_SELL_MOD * 100}% of requisition value.";
                if (scr_click_left()) {
                    sell_item(_item, _count, SHOP_SELL_MOD);
                }
            }
        }
        draw_set_alpha(1.0);
    };

    static _draw_tabs = function() {
        if (tab_buttons.weapons.draw(960, 64, "Equipment")) {
            _switch_tab("weapons");
        }
        if (tab_buttons.armour.draw(1075, 64, "Armour")) {
            _switch_tab("armour");
        }
        if (tab_buttons.vehicles.draw(1190, 64, "Vehicles")) {
            _switch_tab("vehicles");
        }

        var _last_tab_label = is_in_forge ? "Manufacturing" : "Ships";
        var _last_tab_type = is_in_forge ? "production" : "warships";
        if (tab_buttons.ships.draw(1460, 64, _last_tab_label)) {
            _switch_tab(_last_tab_type);
        }
    };

    /// @desc Generates and draws the dynamic advisor text regarding Techmarines and STCs.
    static _draw_advisor_text = function() {
        var _role_tech = obj_ini.role[100][16];
        var _dispo_mech = obj_controller.disposition[3];

        static _recruit_pace = RECRUITMENT_PACE_DESCRIPTIONS;
        static _techmarine_tiers = TECHMARINE_TRAINING_TIERS;
        
        // 1. Calculate Mechanicus Training Capacity
        var _max_techs = round(_dispo_mech / 2) + 5;
        var _diff = _max_techs - count_total;
        var _req_dispo = (abs(_diff) * 2) + ((_dispo_mech % 2 == 0) ? 2 : 1);
        
        // 2. Build the Header
        var _blurp = "";
        _blurp = $"Subject ID confirmed. Rank Identified. Salutations Chapter Master. The status report is ready.\n\nPersonnel: {_role_tech}s: {count_techmarines}, Aspirants: {count_aspirants}.\n\nTraining: ";

        // 3. Mechanicus Relation Logic
        if (obj_controller.faction_status[eFACTION.MECHANICUS] != "War") {
            if (_diff > 0) {
                _blurp += $"Our Disposition with Adeptus Mechanicus are sufficient to train {_diff} additional {_role_tech}s.";
            } else {
                _blurp += $"We require {_req_dispo} additional Mechanicus Disposition to train one additional {_role_tech}.";
            }
        } else {
            _blurp += $"Since we are at war with the Mechanicus we'll have to train our own {_role_tech}s.";
        }

        // 4. Training Progress & ETA
        _blurp += $"  The training of new {_role_tech}s";
        
        var _pace_idx = obj_controller.training_techmarine;
        if (_pace_idx >= 0) {
            _blurp += _recruit_pace[_pace_idx];
        }

        if (obj_controller.tech_aspirant > 0 && _pace_idx > 0 && _pace_idx <= 6) {
            var _eta = floor((359 - obj_controller.tech_points) / _techmarine_tiers[_pace_idx]) + 1;
            var _unit = (_eta == 1) ? "month" : "months";
            var _subject = "The current";
            _blurp += $"  {_subject} {_role_tech} Aspirant will finish training in {_eta} {_unit}.";
        }

        // 5. Drawing
        draw_set_font(fnt_40k_12);
        draw_set_halign(fa_left);
        draw_set_color(c_gray);
        draw_text_ext(352, 130, _blurp, -1, 500);
        
        var _btn_y = 130 + string_height_ext(_blurp, -1, 536) + 10 + 25;
        if (forge_button.draw_shutter(526, _btn_y, "Enter Forge", 0.5)) {
            is_in_forge = true;
            refresh_catalog();
        }

        // 6. Research ETA (The second part of the original text)
        _draw_research_eta(_btn_y);
    };

    /// @desc Draws the specific ETA for the current STC research focus.
    static _draw_research_eta = function(_draw_y) {
        var _focus = obj_controller.stc_research.research_focus;
        var _level = variable_instance_get(obj_controller, $"stc_{_focus}");
        var _points_per_turn = obj_controller.specialist_point_handler.research_points;
        
        if (_points_per_turn <= 0) return;

        var _remaining = (5000 * (_level + 1)) - obj_controller.stc_research[$ _focus];
        var _months = ceil(_remaining / _points_per_turn);
        
        var _msg = $"Research: Based on our calculations, it will be {_months} months until the next {_focus} research is complete.";
        
        draw_text_ext(352, _draw_y + 70, _msg, -1, 536);


    };

    /// @desc Draws the forge-specific statistics and the production queue.
    static _draw_forge_interface = function() {
        var _draw_y = 25;

        // Back to Overview Button
        var _back_btn = draw_unit_buttons([359, _draw_y + 77], "<-- Overview", [1, 1], c_red);
        if (point_and_click(_back_btn)) {
            is_in_forge = false;
            refresh_catalog();
        }

        // Forge Queue Rendering
        obj_controller.specialist_point_handler.draw_forge_queue(359, _draw_y + 107);

        // Forge Stats
        draw_set_color(#af5a00);
        draw_set_font(fnt_40k_14b);

        var _role_name = obj_ini.role[100][16];
        var _master_craft = obj_controller.master_craft_chance;
        var _forge_count = obj_controller.player_forge_data.player_forges;

        var _stats_text = $"Forge point production per turn: {obj_controller.forge_points}\n";
        _stats_text += $"Chapter total {_role_name}s: {count_total}\n";
        _stats_text += $"Planetary Forges in operation: {_forge_count}\n";
        _stats_text += $"Master Craft Forge Chance: {_master_craft}%\n";
        _stats_text += "    Assign techmarines to forges to increase Master Craft Chance";

        draw_text_ext(359, _draw_y + 410, _stats_text, -1, 640);
    };

    /// @desc Draws and handles the company selector for vehicle purchases.
    static _draw_company_selector = function() {
        // Guard clause: Only show this if we are in the vehicles tab
        if (shop_type != "vehicles") return;
    
        static _roman = ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X"];
        
        // Safety check for company bounds
        var _max_coys = obj_ini.companies;
        var _display_num = (target_comp >= 1 && target_comp <= 10) ? _roman[target_comp - 1] : string(target_comp);
        
        var _draw_x = 1310;
        var _draw_y = 82;
        
        // Interaction area (matching the original coordinates roughly)
        var _hit_box = [1262, 78, 1417, 103];
        var _is_hover = scr_hit(_hit_box[0], _hit_box[1], _hit_box[2], _hit_box[3]);
    
        draw_set_font(fnt_40k_14);
        draw_set_halign(fa_left);
        
        // Visual feedback for hover
        draw_set_alpha(_is_hover ? 1.0 : 0.7);
        draw_set_color(_is_hover ? c_white : c_gray);
        
        draw_text(_draw_x, _draw_y, string_hash_to_newline($"Target: {_display_num} Company"));
    
        if (_is_hover && scr_click_left()) {
            target_comp++;
            if (target_comp > _max_coys) {
                target_comp = 1;
            }
            
            // Sync back to controller
            obj_controller.new_vehicles = target_comp;
            audio_play_sound(snd_click, 10, false);
        }
    
        draw_set_alpha(1.0);
    };

    initialize_master_catalog();
}

function ShopItem(_name) constructor {
    name = _name;
    x_mod = 0;
    stocked = 0;
    mc_stocked = 0;
    value = 0;
    buy_cost = 0;
    no_buying = true;
    forge_cost = 0;
    no_forging = false;
    sellers = ["mechanicus"];
    tooltip = "";
    cost_tooltip = "";
    forge_type = "normal";
    renegade_buy = false;
    buy_cost_mod = 1;
    best_seller = "unknown";
    area = "";

    static load_shop_data = function(_area) {
        area = _area;
        var _shop_fields = [
            "value",
            "no_buying",
            "sellers",
            "requires_to_build"
        ];
        for (var s = 0; s < array_length(_shop_fields); s++) {
            struct_copy_if_exists(_area, self, _shop_fields[s]);
        }
    };

    static get_forge_master_mods = function() {
        var forge_masters = scr_role_count("Forge Master", "", "units");
        /// @type {Struct.TTRPG_stats};
        var forge_master = undefined;

        if (array_length(forge_masters) > 0) {
            forge_master = forge_masters[0];
        }

        var forge_master_technology_mod = 1.5;
        var forge_master_charisma_mod = 1.5;

        if (forge_master) {
            forge_master_charisma_mod = (forge_master.charisma - 30) / 200;
            forge_master_technology_mod = (forge_master.technology - 50) / 200;

            if (forge_master.has_trait("flesh_is_weak")) {
                forge_master_technology_mod = 0.1;
            }
        }

        var _mods = {
            technology: forge_master_technology_mod,
            charisma: forge_master_charisma_mod,
        };

        return _mods;
    };

    static get_shop_mod = function(_faction) {
        var forge_mods = get_forge_master_mods();

        var modifiers = {
            imperium: ((obj_controller.disposition[eFACTION.IMPERIUM] - 50) / 200) + forge_mods.charisma,
            mechanicus: ((obj_controller.disposition[eFACTION.MECHANICUS] - 50) / 200) + forge_mods.technology,
            inquisition: ((obj_controller.disposition[eFACTION.INQUISITION] - 50) / 200) + forge_mods.charisma,
            ecclesiarchy: ((obj_controller.disposition[eFACTION.ECCLESIARCHY] - 50) / 200) + forge_mods.charisma,
        };

        var renegade = obj_controller.faction_status[eFACTION.IMPERIUM] == "War";
        if (renegade) {
            modifiers.imperium_modifier -= 0.5;
            modifiers.mechanicus_modifier -= 0.5;
            modifiers.inquisition_modifier -= 0.5;
            modifiers.ecclesiarchy_modifier -= 0.5;
        }

        if (obj_controller.tech_status == "heretics") {
            modifiers.mechanicus_modifier -= 0.5;
        }

        var _tooltip = "";

        if (_faction == "mechanicus") {
            _tooltip += $"Forge Master TEC: {forge_mods.technology}\n";
        } else {
            _tooltip += $"Forge Master CHA: {forge_mods.charisma}\n";
        }

        if (struct_exists(modifiers, _faction)) {
            var _mod = clamp(1 - modifiers[$ _faction], 0.1, 10);
            return {modifier: _mod, tooltip: _tooltip};
        }

        return {modifier: 1, tooltip: _tooltip};
    };

    static update_best_seller = function(_sellers) {
        var _current_modifier = 1;
        var _current_seller = "unknown";
        var _best_modifier = _current_modifier;
        var _best_seller = _current_seller;
        var _tooltip = "";

        for (var i = 0; i < array_length(_sellers); i++) {
            var seller = _sellers[i];
            var _seller_data = get_shop_mod(seller);
            _current_modifier = _seller_data.modifier;
            _current_seller = seller;
            if (_current_modifier < _best_modifier) {
                _best_modifier = _current_modifier;
                _best_seller = _current_seller;
                _tooltip = _seller_data.tooltip;
            }
        }

        buy_cost_mod = _best_modifier;
        best_seller = _best_seller;
        cost_tooltip += _tooltip;
    };
}
