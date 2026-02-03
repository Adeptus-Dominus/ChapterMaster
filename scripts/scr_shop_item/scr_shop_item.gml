/// @desc Primary controller for the Chapter's armory and production.
/// @returns {Struct.Armamentarium}
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
    count_techmarines = 0;
    count_aspirants = 0;
    count_total = 0;

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

    /// @desc Updates the counts of tech-capable personnel.
    static _refresh_personnel_counts = function() {
        var _role_name = obj_ini.role[100][16];
        count_techmarines = scr_role_count(_role_name, "");
        count_aspirants = scr_role_count($"{_role_name} Aspirant", "");
        count_total = count_techmarines + count_aspirants;
    };

    /// @desc One-time setup to build every ShopItem from global data sources.
    static initialize_master_catalog = function() {
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

            var _display_names = variable_struct_get_names(_data_source);
            for (var i = 0; i < array_length(_display_names); i++) {
                var _name = _display_names[i];
                var _raw = _data_source[$ _name];
                var _item = new ShopItem(_name);

                _item.area = _cat;
                _item.value = _raw[$ "value"] ?? 0;
                _item.no_buying = (_item.value == 0) ? true : (_raw[$ "no_buying"] ?? false);

                var _equip_info = gear_weapon_data("any", _name);
                _item.tooltip = is_struct(_equip_info) ? _equip_info.item_tooltip_desc_gen() : "";

                array_push(master_catalog, _item);
            }
        }

        array_sort(master_catalog, true);
        is_initialized = true;
    };

    /// @desc Calculates active discounts based on fleet and star positions.
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

    /// @desc Refreshes the current shop view, updating prices, discounts, and item availability.
    static refresh_catalog = function() {
        if (!is_initialized) {
            initialize_master_catalog();
        }

        _refresh_personnel_counts();
        _calculate_discounts();

        forge_cost_mod = 1.0;
        discount_stc = 0;
        cost_tooltip = "";

        switch (shop_type) {
            case "weapons":
            case "armour":
                discount_stc = obj_controller.stc_wargear * 5;
                if (discount_stc > 0) {
                    cost_tooltip += $"Wargear STC: -{discount_stc}%\n";
                }
                forge_cost_mod -= discount_stc / 100;
                break;

            case "vehicles":
                discount_stc = obj_controller.stc_vehicles * 3;
                var _discount_hangar = array_length(obj_controller.player_forge_data.vehicle_hanger) * 3;
                if (discount_stc > 0) {
                    cost_tooltip += $"Vehicle STC: -{discount_stc}%\n";
                }
                if (_discount_hangar > 0) {
                    cost_tooltip += $"Forge Hangars: -{_discount_hangar}%\n";
                }
                forge_cost_mod -= (discount_stc + _discount_hangar) / 100;
                break;

            case "warships":
                discount_stc = obj_controller.stc_ships * 5;
                if (discount_stc > 0) {
                    cost_tooltip += $"Ship STC: -{discount_stc}%\n";
                }
                forge_cost_mod -= discount_stc / 100;
                break;
        }

        forge_cost_mod = max(0.1, forge_cost_mod);
        shop_items[$ shop_type] = [];

        // 2. Filter and Update Items
        for (var i = 0; i < array_length(master_catalog); i++) {
            /// @type {Struct.ShopItem}
            var _item = master_catalog[i];

            if (_item.area != shop_type) {
                continue;
            }

            _item.stocked = scr_item_count(_item.name);

            if (is_in_forge) {
                _item.forge_cost = (_item.value * 10) * forge_cost_mod;
                _item.no_forging = _item.value == 0;
            } else {
                _item.buy_cost = round(_item.value * min(_item.buy_cost_mod, discount_rogue_trader));
            }

            var _is_visible = _item.stocked > 0 || (!is_in_forge && !_item.no_buying) || (is_in_forge && !_item.no_forging);
            if (_is_visible) {
                array_push(shop_items[$ shop_type], _item);
            }
        }

        array_sort(shop_items[$ shop_type], true);
    };

    /// @desc Processes forging costs and requirements for an item.
    /// @param {Struct.ShopItem} _item The item to process.
    /// @param {struct} _data The raw data source for requirements.
    static _process_forge_item = function(_item) {
        if (global.cheat_debug) {
            _item.forge_cost = 0;
            _item.no_forging = false;
            return;
        }

        if (_item.value == 0) {
            _item.no_forging = true;
            return;
        }

        var _reqs = _item.requires_to_build;
        for (var j = 0; j < array_length(_reqs); ++j) {
            if (!array_contains(obj_controller.technologies_known, _reqs[j])) {
                _item.no_forging = true;
                break;
            }
        }

        if (!_item.no_forging) {
            var _disc = obj_controller.stc_wargear * 5;
            var _mod = 1.0 - (_disc / 100);
            _item.forge_cost = (_item.value * 10) * _mod;
        }
    };

    /// @desc Calculates purchase cost for an item based on modifiers.
    /// @param {Struct.ShopItem} _item The item to process.
    static _process_buy_item = function(_item) {
        if (global.cheat_debug) {
            _item.buy_cost = 0;
            _item.no_buying = false;
            return;
        }
        _item.buy_cost = round(_item.value * min(_item.buy_cost_mod, discount_rogue_trader));
    };

    /// @desc Sells an item back to the market.
    /// @param {Struct.ShopItem} _item The item to sell.
    /// @param {real} _count Quantity to sell.
    /// @param {real} _modifier Price multiplier for selling.
    /// @returns {bool} Success of the transaction.
    static sell_item = function(_item, _count, _modifier) {
        if (_item.stocked < _count) {
            return false;
        }

        var _sell_price = (_item.buy_cost * _modifier) * _count;
        scr_add_item(_item.name, -_count, "standard");

        _item.stocked -= _count;
        obj_controller.requisition += _sell_price;
        return true;
    };

    /// @desc Internal logic for various purchase types.
    /// @param {Struct.ShopItem} _item The item being purchased.
    /// @param {real} _cost The total cost of the purchase.
    /// @param {real} _count The quantity being purchased.
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

    /// @desc Switches the current shop category.
    /// @param {string} _new_type The category to switch to.
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

    /// @desc Main draw loop for the Armamentarium interface.
    static draw = function() {
        add_draw_return_values();

        _draw_background();
        _draw_header();

        if (is_in_forge) {
            _draw_forge_interface();
        } else {
            _draw_advisor_text();
            _draw_stc_panel();
        }

        _draw_tabs();
        _draw_company_selector();
        _draw_item_list();

        pop_draw_return_values();
    };

    /// @desc Draws the background elements.
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

    /// @desc Draws the interface header and advisor splash.
    static _draw_header = function() {
        var _is_adept = obj_controller.menu_adept == 1;
        var _splash_idx = _is_adept ? 1 : (obj_ini.custom_advisors[$ "forge_master"] ?? 5);

        scr_image("advisor/splash", _splash_idx, 16, 43, 310, 828);

        draw_set_halign(fa_left);
        draw_set_font(fnt_40k_30b);
        draw_set_color(c_gray);
        draw_text(352, 66, is_in_forge ? "Forge" : "Armamentarium");

        draw_set_font(fnt_40k_14b);
        var _sub = _is_adept ? $"Adept {obj_controller.adept_name}" : $"Forge Master {obj_ini.name[0][1]}";
        draw_text(352, 100, _sub);
    };

    /// @desc Draws the STC fragment and identification panel.
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
    /// @param {string} _category The STC category name.
    /// @param {real} _x_off X offset for drawing.
    /// @param {real} _current_level The current level of research.
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

    /// @desc Draws the STC research progress bars.
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
            var _level = variable_instance_get(obj_controller, $"stc_{_cat}");

            if (scr_hit(_rect)) {
                draw_set_color(c_white);
                draw_rectangle_array(_rect, true);
                tooltip_draw($"Click to focus research on {_display_names[i]}");
                if (scr_click_left()) {
                    obj_controller.stc_research.research_focus = _cat;
                }
            }

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

            draw_set_font(fnt_40k_14);
            draw_set_color(_is_focus ? c_white : c_gray);
            draw_text(_x_off + 36, _yy - 18, _display_names[i]);

            _draw_stc_bonus_text(_cat, _x_off, _level);
        }
    };

    /// @desc Draws the scrollable list of shop items.
    static _draw_item_list = function() {
        slate_panel.inside_method = function() {
            var _self = obj_controller.armamentarium;
            var _list = _self.shop_items[$ _self.shop_type];
            var _items_count = array_length(_list);
            var _items_per_page = 27;
            var _start_index = _items_per_page * _self.page_mod;
            var _draw_y_local = 157;

            draw_set_font(fnt_40k_14b);
            draw_set_color(c_white);
            draw_text(962, 159, "Name");
            if (_self.shop_type != "production") {
                draw_text(1280, 159, "Stocked");
            }
            draw_text(1410, 159, "Cost");

            for (var i = _start_index; i < min(_start_index + _items_per_page, _items_count); i++) {
                /// @type {Struct.ShopItem}
                var _item = _list[i];
                _draw_y_local += 20;

                var _is_hovered = scr_hit(962, _draw_y_local + 2, 1580, _draw_y_local + 18);
                var _can_act = _self.is_in_forge ? !_item.no_forging : !_item.no_buying;
                var _shift_pressed = keyboard_check(vk_shift) && !array_contains(["warships", "production"], _self.shop_type);
                var _mult = _shift_pressed ? 5 : 1;

                if (_is_hovered) {
                    draw_set_alpha(0.2);
                    draw_rectangle(960, _draw_y_local + 1, 1582, _draw_y_local + 18, false);
                    draw_set_alpha(1.0);
                    if (_item.tooltip != "") {
                        tooltip_draw(_item.tooltip, 400);
                    }
                }

                var _display_name = _can_act ? c_gray : CM_RED_COLOR;
                draw_text_color_simple(962 + _item.x_mod, _draw_y_local, _shift_pressed ? $"{_item.name} x5" : _item.name, _display_name, 1);

                if (_self.shop_type != "production") {
                    var _stocked = string(_item.stocked) + (_item.mc_stocked > 0 ? $" mc: {_item.mc_stocked}" : "");
                    draw_text_alpha(1300, _draw_y_local, _stocked, (_item.stocked == 0 && _item.mc_stocked == 0) ? 0.5 : 1);
                }

                var _cost = (_self.is_in_forge ? _item.forge_cost : _item.buy_cost) * _mult;
                if (_cost > 0) {
                    var _afford = _self.is_in_forge || (obj_controller.requisition >= _cost);
                    var _currency = _self.is_in_forge ? "FP" : "RP";
                    var _currency_color = _self.is_in_forge ? COL_FORGE_POINTS : COL_REQUISITION;

                    draw_text_color_simple(1395, _draw_y_local, _currency, _currency_color, 1);
                    draw_text_color_simple(1427, _draw_y_local, _cost, _afford ? _currency_color : CM_RED_COLOR, 1);

                    if (scr_hit(1400, _draw_y_local, 1400 + 50, _draw_y_local + 20)) {
                        if (_self.cost_tooltip != "") {
                            tooltip_draw(_self.cost_tooltip);
                        }
                    }

                    if (_can_act) {
                        _self._draw_action_buttons(_item, _draw_y_local, _cost, _mult);
                    }
                }
            }

            _self._draw_pagination(_items_count, _items_per_page);
        };

        slate_panel.draw(920, 95, 0.81, 0.85);
    };

    /// @desc Draws page navigation for the item list.
    /// @param {real} _total Total number of items.
    /// @param {real} _per_page Items per page.
    static _draw_pagination = function(_total, _per_page) {
        var _pages = ceil(_total / _per_page);
        if (_pages <= 1) {
            return;
        }

        draw_set_halign(fa_center);
        var p = 0;
        for (p = 0; p < _pages; ++p) {
            var _bx = 1040 + (25 * p);
            var _by = 740;
            var _rect = draw_unit_buttons([_bx, _by], string(p + 1), [1, 1], CM_GREEN_COLOR,,,(page_mod == p) ? 1 : 0.5);
            if (point_and_click(_rect)) {
                page_mod = p;
            }
        }
        draw_set_halign(fa_left);
    };

    /// @desc Handles the logic for clicking Buy, Sell, or Build icons.
    /// @param {Struct.ShopItem} _item The item to act upon.
    /// @param {real} _y Y position for drawing.
    /// @param {real} _cost Cost of the action.
    /// @param {real} _count Quantity for the action.
    static _draw_action_buttons = function(_item, _y, _cost, _count) {
        if (is_in_forge) {
            draw_sprite(spr_build_tiny, 0, 1530, _y + 2);
            if (point_and_click([1520, _y + 2, 1570, _y + 14])) {
                var _queue = obj_controller.specialist_point_handler.forge_queue;
                if (array_length(_queue) < 20) {
                    array_push(_queue, {name: _item.name, count: _count, forge_points: _cost, ordered: obj_controller.turn, type: _item.forge_type});
                }
            }
            return;
        }

        var _can_afford = obj_controller.requisition >= _cost;
        draw_set_alpha(_can_afford ? 1.0 : 0.25);
        draw_sprite(spr_buy_tiny, 0, 1530, _y + 2);
        if (_can_afford && point_and_click([1520, _y + 2, 1570, _y + 14])) {
            _execute_purchase(_item, _cost, _count);
        }

        if (!array_contains(["warships", "vehicles"], shop_type) && _item.stocked > 0) {
            draw_set_alpha(1.0);
            var _sell_btn = draw_sprite_as_button([1480, _y + 2], spr_sell_tiny);
            if (scr_hit(_sell_btn[0], _sell_btn[1], _sell_btn[2], _sell_btn[3])) {
                tooltip_draw($"Sell for {SHOP_SELL_MOD * 100}% value.");
                if (scr_click_left()) {
                    sell_item(_item, _count, SHOP_SELL_MOD);
                }
            }
        }
        draw_set_alpha(1.0);
    };

    /// @desc Draws the category navigation tabs.
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

        var _label = is_in_forge ? "Manufacturing" : "Ships";
        var _type = is_in_forge ? "production" : "warships";
        if (tab_buttons.ships.draw(1460, 64, _label)) {
            _switch_tab(_type);
        }
    };

    /// @desc Draws the status report from the Forge Master.
    static _draw_advisor_text = function() {
        var _role_tech = obj_ini.role[100][16];
        var _dispo_mech = obj_controller.disposition[3];

        static _recruit_pace = RECRUITMENT_PACE_DESCRIPTIONS;
        static _techmarine_tiers = TECHMARINE_TRAINING_TIERS;

        var _max_techs = round(_dispo_mech / 2) + 5;
        var _diff = _max_techs - count_total;

        var _req_dispo = (abs(_diff) * 2) + ((_dispo_mech % 2 == 0) ? 2 : 1);

        var _text = $"Subject ID confirmed. Rank Identified. Salutations Chapter Master. The status report is ready.";
        _text += $"\n\nPersonnel: {_role_tech}s: {count_techmarines}, Aspirants: {count_aspirants}.";

        _text += "\n\nTraining: ";
        if (obj_controller.faction_status[eFACTION.MECHANICUS] != "War") {
            _text += (_diff > 0) ? $"We can train {_diff} more {_role_tech}(s)." : $"To train more, we need {_req_dispo} more Mechanicus Disposition.";
        } else {
            _text += "Training handled internally due to Mechanicus hostilities.";
        }

        var _pace = obj_controller.training_techmarine;
        _text += $" The training pace is {_recruit_pace[_pace] ?? "unknown"}.";

        if (obj_controller.tech_aspirant > 0 && _pace > 0) {
            var _eta_val = floor((359 - obj_controller.tech_points) / _techmarine_tiers[_pace]) + 1;
            _text += $" An Aspirant will finish training in {_eta_val} month(s).";
        }

        draw_set_font(fnt_40k_12);
        draw_set_color(c_gray);
        draw_text_ext(352, 130, _text, -1, 500);

        var _btn_y = 130 + string_height_ext(_text, -1, 536) + 35;
        if (forge_button.draw_shutter(526, _btn_y, "Enter Forge", 0.5)) {
            is_in_forge = true;
            refresh_catalog();
        }

        _draw_research_eta(_btn_y + 70);
    };

    /// @desc Draws the projected time until the next STC breakthrough.
    /// @param {real} _y Y position for drawing.
    static _draw_research_eta = function(_y) {
        var _focus = obj_controller.stc_research.research_focus;
        var _points_per_turn = obj_controller.specialist_point_handler.research_points;
        if (_points_per_turn <= 0) {
            return;
        }

        var _level = variable_instance_get(obj_controller, $"stc_{_focus}");
        var _remaining = (5000 * (_level + 1)) - obj_controller.stc_research[$ _focus];
        var _months = ceil(_remaining / _points_per_turn);
        var _text = $"Research: Next {_focus} breakthrough in {_months} months.";
        draw_text_ext(352, _y, _text, -1, 536);
    };

    /// @desc Draws the production and queue management UI.
    static _draw_forge_interface = function() {
        var _btn = draw_unit_buttons([659, 82], "BACK", [1, 1], CM_GREEN_COLOR,,,,, c_black);
        if (point_and_click(_btn)) {
            is_in_forge = false;
            refresh_catalog();
        }

        obj_controller.specialist_point_handler.draw_forge_queue(359, 132);

        draw_set_color(COL_FORGE_POINTS);
        draw_set_font(fnt_40k_14b);
        var _role_name = obj_ini.role[100][16];
        var _master_craft = obj_controller.master_craft_chance;
        var _forge_count = obj_controller.player_forge_data.player_forges;

        var _text = $"Forge point production per turn: {obj_controller.forge_points}\n";
        _text += $"Chapter total {_role_name}s: {count_total}\n";
        _text += $"Planetary Forges in operation: {_forge_count}\n";
        _text += $"Master Craft Forge Chance: {_master_craft}%\n";
        _text += "    Assign techmarines to forges to increase Master Craft Chance";
        draw_text_ext(359, 435, _text, -1, 640);
    };

    /// @desc Draws and handles the company selector for vehicle purchases.
    static _draw_company_selector = function() {
        // Guard clause: Only show this if we are in the vehicles tab
        if (shop_type != "vehicles") {
            return;
        }

        static roman_numerals = [
            "I",
            "II",
            "III",
            "IV",
            "V",
            "VI",
            "VII",
            "VIII",
            "IX",
            "X"
        ];

        // Safety check for company bounds
        var _max_coys = obj_ini.companies;
        var _display_num = (target_comp >= 1 && target_comp <= 10) ? roman_numerals[target_comp - 1] : string(target_comp);

        var _draw_x = 1310;
        var _draw_y = 82;

        var _text = $"Target: {_display_num} Company";

        // Interaction area (matching the original coordinates roughly)

        draw_set_font(fnt_40k_14);
        draw_set_halign(fa_left);

        var _hit_box = [
            _draw_x,
            _draw_y,
            _draw_x + string_width(_text),
            _draw_y + string_height(_text)
        ];

        var _is_hover = scr_hit(_hit_box[0], _hit_box[1], _hit_box[2], _hit_box[3]);

        // Visual feedback for hover
        draw_set_alpha(_is_hover ? 1.0 : 0.7);
        draw_set_color(_is_hover ? c_white : c_gray);

        draw_text(_draw_x, _draw_y, _text);

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

    // Initialize on creation
    initialize_master_catalog();
}

/// @desc Represents a single item within the Armamentarium catalog.
/// @param {string} _name Name of the item.
/// @returns {Struct.ShopItem}
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
    requires_to_build = [];
    sellers = ["mechanicus"];
    tooltip = "";
    cost_tooltip = "";
    forge_type = "normal";
    renegade_buy = false;
    buy_cost_mod = 1;
    best_seller = "unknown";
    area = "";

    /// @desc Calculates and returns price modifiers based on faction disposition.
    /// @param {string} _faction The faction key to check.
    /// @returns {real} The calculated price multiplier.
    static get_shop_mod = function(_faction) {
        var _tech_mod = 1.5;
        var _char_mod = 1.5;

        var _masters = scr_role_count("Forge Master", "", "units");
        if (array_length(_masters) > 0) {
            /// @type {Struct.TTRPG_stats}
            var _m = _masters[0];
            _char_mod = (_m.charisma - 30) / 200;
            _tech_mod = _m.has_trait("flesh_is_weak") ? 0.1 : (_m.technology - 50) / 200;
        }

        var _dispo = obj_controller.disposition;
        var _modifiers = {
            imperium: ((_dispo[eFACTION.IMPERIUM] - 50) / 200) + _char_mod,
            mechanicus: ((_dispo[eFACTION.MECHANICUS] - 50) / 200) + _tech_mod,
            inquisition: ((_dispo[eFACTION.INQUISITION] - 50) / 200) + _char_mod,
            ecclesiarchy: ((_dispo[eFACTION.ECCLESIARCHY] - 50) / 200) + _char_mod,
        };

        if (obj_controller.faction_status[eFACTION.IMPERIUM] == "War") {
            _modifiers.imperium -= 0.5;
            _modifiers.mechanicus -= 0.5;
            _modifiers.inquisition -= 0.5;
            _modifiers.ecclesiarchy -= 0.5;
        }

        if (obj_controller.tech_status == "heretics") {
            _modifiers.mechanicus -= 0.5;
        }

        var _val = _modifiers[$ _faction] ?? 0;
        _val = clamp(1 - _val, 0.1, 10);

        return _val;
    };

    /// @desc Iterates through potential sellers to find the best price for the item.
    /// @param {array<string>} _sellers Array of faction strings.
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
    };
}