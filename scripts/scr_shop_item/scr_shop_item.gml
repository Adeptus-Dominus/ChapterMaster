function ShopItem(_name) constructor {
    name = _name;
    x_mod = 0;
    stocked = 0;
    mc_stocked = 0;
    value = 0;
    buy_cost = 0;
    no_buying = true;
    forge_cost = 0;
    no_forging = true;
    sellers = ["mechanicus"];
    tooltip = "";
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
        obj_shop.item_cost_tooltip_info += _tooltip;
    };
}
