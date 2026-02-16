#macro SHOP_SELL_MOD 0.8
#macro ROGUE_TRADER_DISCOUNT 0.8
#macro SHOP_FORGE_MOD 6
#macro WAR_PENALTY 0.5
#macro STC_MAX_LEVEL 6
#macro STC_POINTS_PER_LEVEL 5000
#macro FORGE_QUEUE_MAX 20

/// @desc Represents a single item within the Armamentarium catalog.
/// @param {string} _name Name of the item.
/// @returns {Struct.ShopItem}
function ShopItem(_name) constructor {
    name = _name;
    display_name = _name;
    area = "";
    forge_type = "normal";
    item_tooltip = "";

    stocked = 0;
    stocked_mc = 0;
    value = 0;

    buy_cost = 0;
    buyable = true;
    buy_cost_mod = 1;
    best_seller = "unknown";
    sellers = ["mechanicus"];
    request_duration = 0;

    forge_cost = 0;
    forgable = true;
    forge_cost_mod = 1;
    requires_to_forge = [];
    meets_requirements = true;
    missing_technologies = [];

    // -------------------------------------------------------------------------
    // PUBLIC METHODS
    // -------------------------------------------------------------------------

    /// @desc Iterates through potential sellers to find the best price.
    /// @param {array<string>} _sellers Array of faction strings.
    /// @param {struct} _cached_mods Pre-calculated modifiers.
    static update_best_seller = function(_sellers, _cached_mods, _trader_mod) {
        var _best_modifier = 10.0;
        var _best_seller = "unknown";

        for (var i = 0, len = array_length(_sellers); i < len; i++) {
            var _current_modifier = _cached_mods[$ _sellers[i]] ?? 1.0;
            if (_current_modifier < _best_modifier) {
                _best_modifier = _current_modifier;
                _best_seller = _sellers[i];
            }
        }

        if (_trader_mod < 1.0 && _trader_mod < _best_modifier) {
            _best_modifier = _trader_mod;
            _best_seller = "rogue_trader";
        }

        buy_cost_mod = _best_modifier;
        best_seller = _best_seller;
    };

    /// @desc Centralized calculation for current costs.
    /// @param {bool} _is_forge Whether we are in forge mode.
    /// @param {real} _forge_mod The STC/Hangar modifier.
    static calculate_costs = function(_is_forge, _forge_mod, _known_techs) {
        if (global.cheat_debug) {
            buy_cost = 0;
            forge_cost = 0;
            meets_requirements = true;
            return;
        }

        if (_is_forge) {
            var _missing_techs = [];

            for (var j = 0, l = array_length(requires_to_forge); j < l; j++) {
                var _tech = requires_to_forge[j];

                if (!array_contains(_known_techs, _tech)) {
                    array_push(_missing_techs, _get_tech_display_name(_tech));
                }
            }

            meets_requirements = array_length(_missing_techs) == 0;
            missing_technologies = meets_requirements ? [] : _missing_techs;
            forge_cost_mod = _forge_mod;
            forge_cost = round(value * SHOP_FORGE_MOD * forge_cost_mod);
        } else {
            buy_cost = round(value * buy_cost_mod);
        }
    };

    static get_missing_technologies_tooltip = function() {
        if (array_length(missing_technologies) == 0) {
            return "";
        }

        return $"Missing Technologies:\n{string_join_ext("\n", missing_technologies)}";
    };

    static get_buy_cost_tooltip = function() {
        var _text = $"Base Value: {value}\n\n";
        var _seller = (best_seller == "rogue_trader") ? "Rogue Trader" : string_upper_first(best_seller);

        _text += $"Best Seller: {_seller}\n";
        _text += $"Disposition Modifier: x{buy_cost_mod}";

        return _text;
    };

    /// @desc Generates a tooltip explaining the forge cost calculation.
    /// @param {string} _stc_details Detailed breakdown of STC bonuses from the controller.
    /// @returns {string}
    static get_forge_cost_tooltip = function(_stc_details = "") {
        var _base_forge = value * SHOP_FORGE_MOD;
        var _text = $"Base Forging Cost: {_base_forge}\n";

        if (_stc_details != "") {
            _text += $"\n{_stc_details}";
            _text += $"\nTotal Modifier: x{string_format(forge_cost_mod, 1, 2)}";
        }

        return _text;
    };

    // -------------------------------------------------------------------------
    // PRIVATE METHODS
    // -------------------------------------------------------------------------

    /// @desc Retrieves the display name for a technology key, caching results for performance.
    /// @param {string} _tech_key The internal key (e.g., "plasma_foundry").
    /// @returns {string} The display name.
    static _get_tech_display_name = function(_tech_key) {
        static _name_cache = {};

        if (variable_struct_exists(_name_cache, _tech_key)) {
            return _name_cache[$ _tech_key];
        }

        if (!struct_exists(global.technologies, _tech_key)) {
            LOGGER.error($"Technology {_tech_key} not found in the list!");
            return "";
        }

        var _tech_data = global.technologies[$ _tech_key];
        var _display_name = _tech_data[$ "display_name"] ?? string_upper_first(string_replace_all(_tech_key, "_", " "));

        _name_cache[$ _tech_key] = _display_name;

        return _display_name;
    };
}

/// @desc Handles the display and interaction for STC fragment research and bonuses.
/// @param {Id.Instance} _controller_ref Reference to the object holding STC data (usually obj_controller).
/// @param {Function} _on_change_callback Callback after identification.
/// @return {Struct.STCResearchPanel}
function STCResearchPanel(_controller_ref, _on_change_callback) constructor {
    /// @type {Asset.GMObject.obj_controller}
    controller = _controller_ref;
    on_change = _on_change_callback;

    glow_effect = new GlowDot();
    speeding_bits = {
        wargear: new SpeedingDot(0, 0, 0),
        vehicles: new SpeedingDot(0, 0, 0),
        ships: new SpeedingDot(0, 0, 0),
    };

    gift_button = new UnitButtonObject({x1: 0, y1: 0, style: "pixel", label: "Gift", set_width: true, w: 90, color: c_red});
    identify_button = new UnitButtonObject({x1: 0, y1: 0, style: "pixel", label: "Identify", set_width: true, w: 90, color: c_red});

    static LAYOUT = {
        COLUMN_WIDTH: 180,
        COLUMN_HEIGHT: 285,
        BAR_X_OFFSET: 9,
        BAR_Y_OFFSET: 19,
        ETA_X_OFFSET: 34,
        ETA_Y_OFFSET: 25,
        ROW_SPACING: 35,
        TEXT_X_OFFSET: 22,
        TEXT_Y_START: -4,
        HEADER_Y_OFFSET: -18,
        HEADER_HEIGHT: 70,
        LABEL_X_OFFSET: 36,
        BAR_SPRITE_SCALE: 0.7,
        BAR_EMPTY_SCALE: 0.6,
    };

    static CATEGORIES = [
        {
            key: "wargear",
            label: "Wargear",
        },
        {
            key: "vehicles",
            label: "Vehicles",
        },
        {
            key: "ships",
            label: "Ships",
        }
    ];

    advisor_eta_text = "";

    // -------------------------------------------------------------------------
    // PUBLIC METHODS
    // -------------------------------------------------------------------------

    /// @desc Main draw call for the panel.
    /// @param {real} _x Root X position.
    /// @param {real} _y Root Y position.
    static draw = function(_x, _y) {
        _draw_fragment_header(_x, _y);

        draw_set_font(fnt_aldrich_12);
        draw_set_color(c_gray);
        draw_text(_x + LAYOUT.ETA_X_OFFSET, _y + LAYOUT.ETA_Y_OFFSET, advisor_eta_text);

        var _column_y = _y + LAYOUT.HEADER_HEIGHT;
        for (var i = 0; i < array_length(CATEGORIES); i++) {
            var _cat_name = CATEGORIES[i].key;
            var _draw_x = _x + (i * LAYOUT.COLUMN_WIDTH);

            _draw_research_column(_cat_name, CATEGORIES[i].label, _draw_x, _column_y);
        }
    };

    /// @desc Refreshes the ETA string.
    static refresh_eta = function() {
        var _focus = controller.stc_research.research_focus;
        var _points_per_turn = controller.specialist_point_handler.research_points;

        if (_points_per_turn <= 0) {
            advisor_eta_text = "Research: Stalled (No Research Points)";
            return;
        }

        var _level = variable_instance_get(controller, $"stc_{_focus}");
        var _remaining = (STC_POINTS_PER_LEVEL * (_level + 1)) - controller.stc_research[$ _focus];
        var _months = ceil(_remaining / _points_per_turn);

        advisor_eta_text = $"Research: Next {_focus} breakthrough in {_months} months.";
    };

    refresh_eta();

    // -------------------------------------------------------------------------
    // PRIVATE METHODS
    // -------------------------------------------------------------------------

    /// @desc Draws an individual category column including bars and text.
    /// @param {string} _cat Internal key.
    /// @param {string} _label Display name.
    /// @param {real} _cx Column X.
    /// @param {real} _cy Column Y.
    static _draw_research_column = function(_cat, _label, _cx, _cy) {
        var _level = variable_instance_get(controller, $"stc_{_cat}") ?? 0;
        var _is_focus = controller.stc_research.research_focus == _cat;

        var _rect = [
            _cx,
            _cy,
            _cx + (LAYOUT.COLUMN_WIDTH - 10),
            _cy + LAYOUT.COLUMN_HEIGHT
        ];

        if (scr_hit(_rect)) {
            draw_set_color(c_white);
            draw_rectangle_array(_rect, true);
            tooltip_draw($"Click to focus research on {_label}");

            if (mouse_button_clicked()) {
                controller.stc_research.research_focus = _cat;
                audio_play_sound(snd_click, 10, false);
                refresh_eta();
            }
        }

        draw_set_font(fnt_aldrich_12);
        draw_set_color(_is_focus ? c_white : c_gray);
        draw_text(_cx + LAYOUT.LABEL_X_OFFSET, _cy + LAYOUT.HEADER_Y_OFFSET, _label);

        var _bx = _cx + LAYOUT.BAR_X_OFFSET;
        var _by = _cy + LAYOUT.BAR_Y_OFFSET;

        draw_sprite_ext(spr_research_bar, 0, _bx, _by, 1, LAYOUT.BAR_SPRITE_SCALE, 0, c_white, 1);

        for (var f = _level; f < STC_MAX_LEVEL; f++) {
            draw_sprite_ext(spr_research_bar, 1, _bx, _by + (f * LAYOUT.ROW_SPACING), 1, LAYOUT.BAR_EMPTY_SCALE, 0, c_white, 1);
        }

        glow_effect.draw(_bx, _by + (_level * LAYOUT.ROW_SPACING));

        if (_is_focus) {
            speeding_bits[$ _cat].draw(_cx, _by);
        }

        _draw_bonus_list(_cat, _cx + LAYOUT.TEXT_X_OFFSET, _cy + LAYOUT.TEXT_Y_START + LAYOUT.BAR_Y_OFFSET, _level);
    };

    /// @desc Draws the list of bonuses for a category.
    static _draw_bonus_list = function(_cat, _tx, _ty, _current_level) {
        var _bonuses = _get_descriptions(_cat);
        draw_set_font(fnt_aldrich_12);

        for (var s = 0; s < array_length(_bonuses); s++) {
            var _unlocked = _current_level >= s;

            draw_set_alpha(_unlocked ? 1.0 : 0.5);
            draw_set_color(_unlocked ? c_white : c_gray);

            draw_text_ext(_tx, _ty + (s * LAYOUT.ROW_SPACING), $"{s}) {_bonuses[s]}", -1, 140);
        }
        draw_set_alpha(1.0);
    };

    /// @desc Draws the fragment count and the Gift/Identify buttons.
    static _draw_fragment_header = function(_x, _y) {
        var _total_un = controller.stc_wargear_un + controller.stc_vehicles_un + controller.stc_ships_un;

        draw_set_font(fnt_aldrich_12);
        draw_set_color(c_gray);
        draw_text(_x + 34, _y, $"{_total_un} Unidentified Fragments");

        var _has_fragments = _total_un > 0;
        draw_set_alpha(_has_fragments ? 1 : 0.25);

        gift_button.update({x1: _x + 300, y1: _y - 5});
        if (gift_button.draw(_has_fragments)) {
            setup_gift_stc_popup();
        }

        identify_button.update({x1: gift_button.x2 + 10, y1: _y - 5});
        if (identify_button.draw(_has_fragments)) {
            _identify_fragment();
        }

        draw_set_alpha(1);
    };

    /// @desc Returns the bonus descriptions for a specific category.
    /// @param {string} _cat Category key.
    /// @returns {Array<string>}
    static _get_descriptions = function(_cat) {
        static _data = {
            wargear: [
                "None",
                "8% discount",
                "Enhanced Bolts",
                "16% discount",
                "Enhanced Fist Weapons",
                "25% discount",
                "Can produce Terminator Armour and Dreadnoughts."
            ],
            vehicles: [
                "None",
                "8% discount",
                "Enhanced Hull",
                "16% discount",
                "Enhanced Armour",
                "25% discount",
                "Can produce Land Speeders and Land Raiders."
            ],
            ships: [
                "None",
                "8% discount",
                "Enhanced Hull",
                "16% discount",
                "Enhanced Armour",
                "25% discount",
                "Warp Speed is increased and ships self-repair."
            ],
        };
        return _data[$ _cat] ?? [];
    };

    /// @desc Handles the consumption of fragments and leveling up STC categories.
    static _identify_fragment = function() {
        var _available = [];

        if (controller.stc_wargear_un > 0 && controller.stc_wargear < STC_MAX_LEVEL) {
            array_push(_available, "wargear");
        }
        if (controller.stc_vehicles_un > 0 && controller.stc_vehicles < STC_MAX_LEVEL) {
            array_push(_available, "vehicles");
        }
        if (controller.stc_ships_un > 0 && controller.stc_ships < STC_MAX_LEVEL) {
            array_push(_available, "ships");
        }

        if (array_length(_available) == 0) {
            return;
        }

        var _target = array_random_element(_available);

        advance_stc_research(_target);

        audio_play_sound(snd_stc, -500, false);

        if (is_method(on_change)) {
            on_change();
        }
    };
}

/// @desc Primary controller for the Chapter's armory and technologies.
/// @param {Asset.GMObject.obj_controller} _controller
/// @returns {Struct.Armamentarium}
function Armamentarium(_controller) constructor {
    controller = _controller;

    // --- UI State ---
    shop_type = "weapons";
    is_in_forge = false;
    page_mod = 0;
    target_comp = controller.new_vehicles;

    // --- Calculation State ---
    forge_cost_mod = 1.0;
    discount_stc = 0;
    discount_rogue_trader = 1.0;
    global_cost_tooltip = "";
    count_techmarines = 0;
    count_aspirants = 0;
    count_total = 0;

    faction_modifiers = {
        imperium: 1.0,
        mechanicus: 1.0,
        inquisition: 1.0,
        ecclesiarchy: 1.0,
    };
    advisor_report_text = "";

    // --- Components ---
    slate_panel = new DataSlate();
    slate_panel.inside_method = method(self, _draw_slate_contents);

    stc_panel = new STCResearchPanel(controller, method(self, refresh_catalog));

    enter_forge_button = new ShutterButton();
    enter_forge_button.cover_text = "FORGE";

    forge_button = new SpriteButton(spr_build_tiny);
    buy_button = new SpriteButton(spr_buy_tiny);
    sell_button = new SpriteButton(spr_sell_tiny);

    var _cat_options = [
        {
            label: "Weapons",
            value: "weapons",
        },
        {
            label: "Armour",
            value: "armour",
        },
        {
            label: "Equipment",
            value: "mobility",
        },
        {
            label: "Gear",
            value: "gear",
        },
        {
            label: "Vehicles",
            value: "vehicles",
        },
        {
            label: "Vehicle Gear",
            value: "vehicle_gear",
        },
        {
            label: "Ships",
            value: "ships",
        },
        {
            label: "Technologies",
            value: "technologies",
        }
    ];

    category_dropdown = new UIDropdown(_cat_options, 200);

    _cat_options = [];
    var _roman = [
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

    var _roman_length = array_length(_roman);

    for (var i = 0; i < min(obj_ini.companies, _roman_length); i++) {
        array_push(_cat_options, {label: $"{_roman[i]} Company", value: i + 1});
    }

    company_dropdown = new UIDropdown(_cat_options, 180);

    // --- Data Storage ---
    shop_items = {
        weapons: [],
        armour: [],
        gear: [],
        mobility: [],
        vehicles: [],
        vehicle_gear: [],
        ships: [],
        technologies: [],
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
        ships: global.ships,
        technologies: global.technologies,
    };

    // -------------------------------------------------------------------------
    // PUBLIC METHODS
    // -------------------------------------------------------------------------

    /// @desc One-time setup to build every ShopItem from global data sources.
    /// @returns {undefined}
    static initialize_master_catalog = function() {
        if (is_initialized) {
            return;
        }

        var _categories = [
            "weapons",
            "armour",
            "gear",
            "mobility",
            "vehicles",
            "vehicle_gear",
            "ships",
            "technologies"
        ];

        for (var c = 0, clen = array_length(_categories); c < clen; c++) {
            var _cat = _categories[c];
            var _data_source = shop_data_lookup[$ _cat];

            if (!is_struct(_data_source)) {
                continue;
            }

            var _display_names = variable_struct_get_names(_data_source);
            for (var i = 0, dlen = array_length(_display_names); i < dlen; i++) {
                var _name = _display_names[i];
                var _raw = _data_source[$ _name];
                var _item = new ShopItem(_name);

                var _item_tags = _raw[$ "tags"] ?? [];
                if (array_contains_ext(_item_tags, ["sponson", "turret", "vehicle"])) {
                    _item.area = "vehicle_gear";
                } else {
                    _item.area = _cat;
                }

                _item.display_name = _raw[$ "display_name"] ?? _name;
                _item.value = _raw[$ "value"] ?? _item.value;
                _item.sellers = _raw[$ "sellers"] ?? _item.sellers;
                _item.request_duration = _raw[$ "request_duration"] ?? _item.request_duration;

                _item.buyable = (_item.value == 0 || array_length(_item.sellers) == 0) ? false : (_raw[$ "buyable"] ?? _item.buyable);
                _item.forgable = (_item.value == 0) ? false : (_raw[$ "forgable"] ?? _item.forgable);

                _item.requires_to_forge = _raw[$ "requires_to_forge"] ?? _item.requires_to_forge;

                var _equip_info = gear_weapon_data("any", _name);
                _item.item_tooltip = is_struct(_equip_info) ? _equip_info.item_tooltip_desc_gen() : "";

                if (_cat == "technologies") {
                    _item.forge_type = "research";
                    _item.item_tooltip = _raw[$ "description"] ?? "";
                }

                array_push(master_catalog, _item);
            }
        }

        _initialize_unlock_tooltips();
        array_sort(master_catalog, _sort_alphabetical);
        is_initialized = true;
    };

    /// @desc Refreshes the current shop view, updating prices, discounts, and item availability.
    static refresh_catalog = function() {
        if (!is_initialized) {
            initialize_master_catalog();
        }

        shop_items[$ shop_type] = [];

        forge_cost_mod = 1.0;
        global_cost_tooltip = "";

        _refresh_personnel_counts();
        _calculate_discounts();
        _update_advisor_report();
        stc_panel.refresh_eta();
        _refresh_faction_modifiers();
        _refresh_stc_modifiers();

        forge_cost_mod = max(0.1, 1.0 - (discount_stc / 100));

        for (var i = 0, len = array_length(master_catalog); i < len; i++) {
            /// @type {Struct.ShopItem}
            var _item = master_catalog[i];

            if (_item.area != shop_type) {
                continue;
            }

            _item.stocked = scr_item_count(_item.name);
            _item.stocked_mc = scr_item_count(_item.name, "master_crafted");

            _item.update_best_seller(_item.sellers, faction_modifiers, discount_rogue_trader);
            _item.calculate_costs(is_in_forge, forge_cost_mod, controller.technologies_known);

            var _is_visible = (_item.buyable || _item.stocked > 0) || global.cheat_debug;

            if (is_in_forge) {
                _is_visible = _item.forgable || global.cheat_debug;
            }

            if (shop_type == "technologies" && array_contains(controller.technologies_known, _item.name)) {
                _is_visible = false;
            }

            if (_is_visible) {
                array_push(shop_items[$ shop_type], _item);
            }
        }

        array_sort(shop_items[$ shop_type], _sort_alphabetical);
    };

    /// @desc Main draw loop for the Armamentarium interface.
    static draw = function() {
        add_draw_return_values();

        _draw_background();
        _draw_header();

        if (is_in_forge) {
            _draw_forge_interface();
        } else {
            _draw_advisor_text();
            stc_panel.draw(350, 440);
        }

        _draw_item_list();
        _draw_tabs();

        pop_draw_return_values();
    };

    // -------------------------------------------------------------------------
    // PRIVATE METHODS
    // -------------------------------------------------------------------------

    /// @desc Comparator for alphabetical sorting of shop items.
    static _sort_alphabetical = function(_a, _b) {
        if (_a.display_name < _b.display_name) {
            return -1;
        }
        if (_a.display_name > _b.display_name) {
            return 1;
        }
        return 0;
    };

    /// @desc Updates the counts of tech-capable personnel.
    static _refresh_personnel_counts = function() {
        var _role_name = obj_ini.role[100][16];
        count_techmarines = scr_role_count(_role_name, "");
        count_aspirants = scr_role_count($"{_role_name} Aspirant", "");
        count_total = count_techmarines + count_aspirants;
    };

    /// @desc Calculates active discounts based on fleet and star positions.
    static _calculate_discounts = function() {
        discount_rogue_trader = 1.0;

        with (obj_star) {
            if (trader <= 0) {
                continue;
            }

            if (array_contains(p_owner, 1)) {
                other.discount_rogue_trader = ROGUE_TRADER_DISCOUNT;
                break;
            }

            /// @type {Asset.GMObject.obj_p_fleet}
            var _fleet = instance_place(x, y, obj_p_fleet);
            if (_fleet != noone && _fleet.capital_number > 0 && _fleet.action == "") {
                other.discount_rogue_trader = ROGUE_TRADER_DISCOUNT;
                break;
            }
        }
    };

    static _refresh_faction_modifiers = function() {
        var _tech_bonus = 0;
        var _cha_bonus = 0;
        var _masters = scr_role_count("Forge Master", "", "units");

        if (array_length(_masters) > 0) {
            var _fm = _masters[0];
            _cha_bonus = (_fm.charisma - 30) / 200;
            _tech_bonus = _fm.has_trait("flesh_is_weak") ? 0.1 : (_fm.technology - 50) / 200;
        }

        var _is_at_war = controller.faction_status[eFACTION.IMPERIUM] == "War";
        var _war_tax = _is_at_war ? WAR_PENALTY : 0;

        static _get_mod = function(_faction_id, _staff_bonus, _war_tax) {
            var _dispo = controller.disposition[_faction_id];
            var _dispo_bonus = (_dispo - 50) / 200;

            return clamp(1.0 - _dispo_bonus - _staff_bonus + _war_tax, 0.1, 10.0);
        };

        faction_modifiers.imperium = _get_mod(eFACTION.IMPERIUM, _cha_bonus, _war_tax);
        faction_modifiers.mechanicus = _get_mod(eFACTION.MECHANICUS, _tech_bonus, _war_tax);
        faction_modifiers.inquisition = _get_mod(eFACTION.INQUISITION, _cha_bonus, _war_tax);
        faction_modifiers.ecclesiarchy = _get_mod(eFACTION.ECCLESIARCHY, _cha_bonus, _war_tax);
    };

    static _refresh_stc_modifiers = function() {
        discount_stc = 0;

        switch (shop_type) {
            case "weapons":
            case "armour":
            case "gear":
            case "mobility":
                discount_stc = controller.stc_wargear * 5;
                if (discount_stc > 0) {
                    global_cost_tooltip += $"Wargear STC: -{discount_stc}%\n";
                }
                break;
            case "vehicles":
            case "vehicle_gear":
                discount_stc = (controller.stc_vehicles * 3) + (array_length(controller.player_forge_data.vehicle_hanger) * 3);
                if (discount_stc > 0) {
                    global_cost_tooltip += $"Vehicle STC & Hangars: -{discount_stc}%\n";
                }
                break;
            case "ships":
                discount_stc = controller.stc_ships * 5;
                if (discount_stc > 0) {
                    global_cost_tooltip += $"Ship STC: -{discount_stc}%\n";
                }
                break;
        }
    };

    /// @desc Save CPU time during Draw.
    static _update_advisor_report = function() {
        var _role_tech = obj_ini.role[100][16];
        var _dispo_mech = controller.disposition[3];
        var _max_techs = round(_dispo_mech / 2) + 5;
        var _diff = _max_techs - count_total;
        var _req_dispo = (abs(_diff) * 2) + ((_dispo_mech % 2 == 0) ? 2 : 1);

        var _text = $"Subject ID confirmed. Rank Identified. Salutations Chapter Master. The status report is ready.";
        _text += $"\n\nPersonnel: {_role_tech}s: {count_techmarines}, Aspirants: {count_aspirants}.";
        _text += "\n\nTraining: ";

        if (controller.faction_status[eFACTION.MECHANICUS] != "War") {
            _text += (_diff > 0) ? $"We can train {_diff} more {_role_tech}(s)." : $"To train more, we need {_req_dispo} more Mechanicus Disposition.";
        } else {
            _text += "Training handled internally due to Mechanicus hostilities.";
        }

        var _pace = controller.training_techmarine;
        _text += $" The training pace is {RECRUITMENT_PACE_DESCRIPTIONS[_pace] ?? "unknown"}.";

        if (controller.tech_aspirant > 0 && _pace > 0) {
            var _eta_val = floor((359 - controller.tech_points) / TECHMARINE_TRAINING_TIERS[_pace]) + 1;
            _text += $" An Aspirant will finish training in {_eta_val} month(s).";
        }
        advisor_report_text = _text;
    };

    /// @desc Sells an item back to the market.
    /// @param {Struct.ShopItem} _item The item to sell.
    /// @param {real} _count Quantity to sell.
    /// @param {real} _modifier Price multiplier for selling.
    /// @returns {bool} Success of the transaction.
    static _sell_item = function(_item, _count, _modifier) {
        if (_item.stocked < 1) {
            return false;
        }

        var _sold_count = min(_item.stocked, _count);
        var _sell_price = round((_item.value * _modifier) * _sold_count);

        scr_add_item(_item.name, -_sold_count, "standard");
        _item.stocked -= _sold_count;
        controller.requisition += _sell_price;

        audio_play_sound(snd_click, 10, false);

        return true;
    };

    /// @desc Internal logic for various purchase types.
    /// @param {Struct.ShopItem} _item The item being purchased.
    /// @param {real} _cost The total cost of the purchase.
    /// @param {real} _count The quantity being purchased.
    static _buy_item = function(_item, _cost, _count) {
        controller.requisition -= _cost;

        // 1. Warships
        if (shop_type == "ships") {
            add_event({e_id: "ship_construction", ship_class: _item.name, duration: _item.request_duration});
            return;
        }

        // 2. Vehicles
        if (variable_struct_exists(global.vehicles, _item.name)) {
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

    /// @desc Switches the current shop category.
    /// @param {string} _new_type The category to switch to.
    static _switch_tab = function(_new_type) {
        if (shop_type == _new_type) {
            return;
        }

        if (!is_in_forge) {
            is_in_forge = _new_type == "technologies";
        } else {
            is_in_forge = _new_type != "ships";
        }

        shop_type = _new_type;
        page_mod = 0;

        category_dropdown.set_value(_new_type);

        refresh_catalog();
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
        var _is_adept = controller.menu_adept == 1;
        var _splash_idx = _is_adept ? 1 : (obj_ini.custom_advisors[$ "forge_master"] ?? 5);

        scr_image("advisor/splash", _splash_idx, 16, 43, 310, 828);

        draw_set_halign(fa_left);
        draw_set_font(fnt_40k_30b);
        draw_set_color(c_gray);
        draw_text(352, 66, is_in_forge ? "Forge" : "Armamentarium");

        draw_set_font(fnt_aldrich_12);
        var _sub = _is_adept ? $"Adept {controller.adept_name}" : $"Forge Master {obj_ini.name[0][1]}";
        draw_text(352, 100, _sub);
    };

    /// @desc Draws the scrollable list of shop items.
    static _draw_item_list = function() {
        slate_panel.draw(920, 95, 0.81, 0.85);
    };

    static _draw_slate_contents = function() {
        draw_set_font(fnt_aldrich_12);
        draw_set_color(CM_GREEN_COLOR);

        var _header_y = 159;
        draw_text(962, _header_y, "Name");
        if (shop_type != "technologies") {
            draw_text(1280, _header_y, "Stocked");
        }
        draw_text(1410, _header_y, $"{is_in_forge ? "FP" : "RP"} Cost");

        var _list = shop_items[$ shop_type];
        var _items_per_page = 27;
        var _start_index = _items_per_page * page_mod;
        var _items_count = array_length(_list);
        var _end_index = min(_start_index + _items_per_page, _items_count);

        var _draw_y_local = 157;
        var _shift_pressed = keyboard_check(vk_shift) && !array_contains(["ships", "technologies"], shop_type);
        var _mult = _shift_pressed ? 5 : 1;

        for (var i = _start_index; i < _end_index; i++) {
            /// @type {Struct.ShopItem}
            var _item = _list[i];
            _draw_y_local += 20;

            var _row_h = 18;
            var _is_hovered = scr_hit(962, _draw_y_local, 1582, _draw_y_local + _row_h);

            if (_is_hovered) {
                draw_set_alpha(0.2);
                draw_rectangle(960, _draw_y_local, 1582, _draw_y_local + _row_h, false);
                draw_set_alpha(1.0);

                if (_item.item_tooltip != "") {
                    tooltip_draw(_item.item_tooltip, 400);
                }
            }

            var _can_forge = !is_in_forge || _item.meets_requirements;
            var _cost = (is_in_forge ? _item.forge_cost : _item.buy_cost) * _mult;
            var _afford = is_in_forge || (controller.requisition >= _cost);
            var _active = _can_forge && _afford;

            var _display_color = _active ? CM_GREEN_COLOR : CM_RED_COLOR;
            var _alpha = _active ? 1.0 : 0.5;
            var _display_name = _shift_pressed ? $"{_item.display_name} x5" : _item.display_name;

            draw_text_color_simple(962, _draw_y_local + 2, _display_name, _display_color, _alpha);

            if (shop_type != "technologies") {
                var _has_stock = _item.stocked > 0 || _item.stocked_mc > 0;

                if (scr_hit(1280, _draw_y_local, 1380, _draw_y_local + _row_h)) {
                    tooltip_draw($"Total: {_item.stocked}\nMaster Crafted: {_item.stocked_mc}");
                }
                draw_text_alpha(1300, _draw_y_local, string(_item.stocked), _has_stock ? 1.0 : 0.5);
            }

            var _currency_color = is_in_forge ? COL_FORGE_POINTS : COL_REQUISITION;
            var _final_cost_color = _afford ? _currency_color : CM_RED_COLOR;

            if (scr_hit(1410, _draw_y_local, 1475, _draw_y_local + _row_h)) {
                tooltip_draw(is_in_forge ? _item.get_forge_cost_tooltip(global_cost_tooltip) : _item.get_buy_cost_tooltip());
            }

            draw_text_color_simple(1427, _draw_y_local, string(_cost), _final_cost_color, _alpha);
            _draw_action_buttons(_item, _draw_y_local, _cost, _mult);
        }

        _draw_pagination(_items_count, _items_per_page);
    };

    /// @desc Handles the logic for clicking Buy, Sell, or Build icons.
    /// @param {Struct.ShopItem} _item The item to act upon.
    /// @param {real} _y Y position for drawing.
    /// @param {real} _cost Cost of the action.
    /// @param {real} _count Quantity for the action.
    static _draw_action_buttons = function(_item, _y, _cost, _count) {
        if (is_in_forge) {
            var _can_forge = _item.meets_requirements || global.cheat_debug;

            forge_button.tooltip_text = _can_forge ? "Add to Forge Queue" : _item.get_missing_technologies_tooltip();
            forge_button.draw(1530, _y + 2, _can_forge);

            if (forge_button.is_clicked) {
                var _queue = controller.specialist_point_handler.forge_queue;
                if (array_length(_queue) < FORGE_QUEUE_MAX) {
                    array_push(_queue, {item: _item, count: _count, forge_points: _cost, ordered: controller.turn});
                } else {
                    audio_play_sound(snd_error, 10, false);
                }
            }

            return;
        }

        var _can_afford = (controller.requisition >= _cost) || global.cheat_debug;
        var _can_buy = _item.buyable || global.cheat_debug;

        buy_button.tooltip_text = !_can_buy ? "Unavailable for purchase" : (_can_afford ? "Buy" : "Insufficient Requisition");
        buy_button.draw(1530, _y + 2, _can_buy && _can_afford);

        if (buy_button.is_clicked) {
            _buy_item(_item, _cost, _count);
        }

        var _can_sell = !array_contains(["ships", "vehicles"], shop_type) && _item.stocked > 0;

        sell_button.tooltip_text = $"Sell for {round(_item.value * SHOP_SELL_MOD)} (x{SHOP_SELL_MOD} of value)";
        sell_button.draw(1480, _y + 2, _can_sell);

        if (sell_button.is_clicked) {
            _sell_item(_item, _count, SHOP_SELL_MOD);
        }

        draw_set_alpha(1);
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
            var _rect = draw_unit_buttons([_bx, _by], string(p + 1), [1, 1], CM_GREEN_COLOR,,, (page_mod == p) ? 1 : 0.5);
            if (point_and_click(_rect)) {
                page_mod = p;
            }
        }
        draw_set_halign(fa_left);
    };

    /// @desc Draws the category navigation tabs.
    static _draw_tabs = function() {
        var _draw_x = 960;
        var _draw_y = 64;

        var _selection = category_dropdown.draw(_draw_x, _draw_y);
        if (_selection != undefined) {
            _switch_tab(_selection);
        }

        if (shop_type == "vehicles") {
            var _new_comp = company_dropdown.draw(1310, 82);
            if (_new_comp != undefined) {
                target_comp = _new_comp;
                controller.new_vehicles = _new_comp;
            }
        }
    };

    /// @desc Draws the status report from the Forge Master.
    static _draw_advisor_text = function() {
        draw_set_font(fnt_aldrich_12);
        draw_set_color(c_gray);
        draw_text_ext(352, 130, advisor_report_text, -1, 500);

        var _btn_y = 225 + string_height_ext(advisor_report_text, -1, 536);
        if (enter_forge_button.draw_shutter(526, _btn_y, "Enter Forge", 0.5)) {
            is_in_forge = true;
            refresh_catalog();
        }
    };

    /// @desc Draws the technologies and queue management UI.
    static _draw_forge_interface = function() {
        var _btn = draw_unit_buttons([659, 82], "BACK", [1, 1], CM_GREEN_COLOR,,,,, c_black);
        if (point_and_click(_btn)) {
            is_in_forge = false;

            if (shop_type == "technologies") {
                _switch_tab("weapons");
            }

            refresh_catalog();
        }

        controller.specialist_point_handler.draw_forge_queue(359, 132);

        var _role_name = obj_ini.role[100][16];
        var _master_craft = controller.master_craft_chance;
        var _forge_count = controller.player_forge_data.player_forges;

        var _text = $"Status Report:\n\n";
        _text += $"Forge Point production per turn: {controller.forge_points}\n";
        _text += $"Chapter Total {_role_name}s: {count_total}\n\n";
        _text += $"Planetary Forges in operation: {_forge_count}\n\n";
        _text += $"Master Craft Forge Chance: {_master_craft}%\n";
        _text += "Assign techmarines to forges to increase Master Craft Chance";

        draw_set_color(c_gray);
        draw_set_font(fnt_aldrich_12);

        draw_text_ext(359, 435, _text, -1, 640);
    };

    static _initialize_unlock_tooltips = function() {
        var _unlock_map = {};
        var _catalog_size = array_length(master_catalog);

        for (var i = 0; i < _catalog_size; i++) {
            /// @type {Struct.ShopItem}
            var _item = master_catalog[i];
            var _reqs = _item.requires_to_forge;

            for (var j = 0, _rlen = array_length(_reqs); j < _rlen; j++) {
                var _tech_key = _reqs[j];
                if (!variable_struct_exists(_unlock_map, _tech_key)) {
                    _unlock_map[$ _tech_key] = [];
                }
                array_push(_unlock_map[$ _tech_key], _item.display_name);
            }
        }

        for (var i = 0; i < _catalog_size; i++) {
            var _item = master_catalog[i];

            if (_item.area != "technologies") {
                continue;
            }

            var _unlocks = _unlock_map[$ _item.name] ?? [];

            if (array_length(_unlocks) == 0) {
                continue;
            }

            array_sort(_unlocks, true);

            var _unlock_text = "\n\nRequired for:\n- " + string_join_ext("\n- ", _unlocks);
            _item.item_tooltip += _unlock_text;
        }
    };

    // Initialize on creation
    initialize_master_catalog();
}
