find_best_seller = function(_sellers) {
    var modifiers = {
        "Imperium": imperium_modifier,
        "Mechanicus": mechanicus_modifier,
        "Inquisition": inquisition_modifier,
        "Ecclesiarchy": ecclesiarchy_modifier
    };
    var current_modifier = 1;
    var current_seller = "Unknown";

    for (var i = 0; i < array_length(_sellers); i++) {
        var seller = _sellers[i];
        if (struct_exists(modifiers, seller)) {
            current_modifier = modifiers[$ seller];
            current_seller = seller;
            if (current_modifier < best_modifier) {
                best_modifier = current_modifier;
                best_seller = current_seller;
            }
        }
    }

    if (best_seller == "Mechanicus") {
        item_cost_tooltip_info += $"Forge Master TEC: {forge_master_tec_discount}\n";
    } else {
        item_cost_tooltip_info += $"Forge Master CHA: {forge_master_cha_discount}\n";
    }
};


shop = "weapons";
if (instance_number(obj_shop) > 1) {
    var war;
    war = instance_nearest(0, 0, obj_shop);
    shop = war.shop;
    with(war) {
        instance_destroy();
    }
    x = 0;
    y = 0;
}

tab_buttons = {
    "weapons": new MainMenuButton(spr_ui_but_3, spr_ui_hov_3),
    "armour": new MainMenuButton(spr_ui_but_3, spr_ui_hov_3),
    "vehicles": new MainMenuButton(spr_ui_but_3, spr_ui_hov_3),
    "ships": new MainMenuButton(spr_ui_but_3, spr_ui_hov_3)
};

hover = 0;
in_forge = false;
click = 0;
click2 = 0;
construction_started = 0;
eta = 0;
target_comp = obj_controller.new_vehicles;
renegade = obj_controller.faction_status[eFACTION.Imperium] == "War";

slate_panel = new DataSlate();
scroll_point = 0;
tooltip_show = 0;
tooltip = "";
tooltip_stat1 = 0;
tooltip_stat2 = 0;
tooltip_stat3 = 0;
tooltip_stat4 = 0;
tooltip_other = "";
last_item = "";
item_cost_tooltip_info = "";


forge_cost_mod = 1;
discount_stc = 0;
tech_heretic_modifier = 0;
buy_cost_mod = 1;
discount_rogue_trader = 0;


forge_master = scr_role_count("Forge Master", "", "units");
if (array_length(forge_master) > 0) {
    forge_master = forge_master[0];
} else {
    forge_master = "none";
}
if (forge_master != "none") {
    forge_master_cha_discount = ((forge_master.charisma - 30) / 200);
    forge_master_tec_discount = ((forge_master.technology - 50) / 200);
    if (forge_master.has_trait("flesh_is_weak")) {
        forge_master_tec_discount = 0.1;
    }
} else {
    forge_master_tec_discount = -0.5;
    forge_master_cha_discount = -0.5;
}

with(obj_p_fleet) {
    if ((capital_number > 0) && (action == "")) {
        var you = instance_nearest(x, y, obj_star);
        if (you.trader > 0) {
            obj_shop.discount_rogue_trader = 0.2;
        }
    }
}
with(obj_star) {
    if (array_contains(p_owner, 1) && (trader > 0)) {
        obj_shop.discount_rogue_trader = 0.2;
    }
}

if (discount_rogue_trader != 1) {
    item_cost_tooltip_info += $"Near a Rogue Trader: x{discount_rogue_trader}\n";
}


imperium_modifier = ((obj_controller.disposition[eFACTION.Imperium] - 50) / 200) + forge_master_cha_discount;
mechanicus_modifier = ((obj_controller.disposition[eFACTION.Mechanicus] - 50) / 200) + forge_master_tec_discount;
inquisition_modifier = ((obj_controller.disposition[eFACTION.Inquisition] - 50) / 200) + forge_master_cha_discount;
ecclesiarchy_modifier = ((obj_controller.disposition[eFACTION.Ecclesiarchy] - 50) / 200) + forge_master_cha_discount;

if (renegade) {
    imperium_modifier += 1;
    mechanicus_modifier += 1;
    inquisition_modifier += 1;
    ecclesiarchy_modifier += 1;
}

if (obj_controller.tech_status == "heretics") {
    tech_heretic_modifier += 1;
    mechanicus_modifier += tech_heretic_modifier;
    item_cost_tooltip_info += $"Tech-Heretics: {tech_heretic_modifier}\n";
}

best_modifier = 1;
best_seller = "Unknown";

item_name = array_create(160, "");
x_mod = array_create(160, 0);
item_stocked = array_create(160, 0);
mc_stocked = array_create(160, 0);
buy_cost = array_create(160, 0);
no_buying = array_create(160, true);
forge_cost = array_create(160, 0);
no_forging = array_create(160, true);
sellers = array_create(160, ["Mechanicus"]);
tooltip_override = array_create(160, 0);
forge_type = array_create(160, "normal");
renegade_buy = array_create(160, false);

var shop_data_lookup = {
    weapons: {
        data: global.weapons,
        shop_data: global.weapons_shop_data
    },
    armour: {
        data: global.gear[$ "armour"],
        shop_data: global.armour_shop_data
    },
    gear: {
        data: global.gear[$ "gear"],
        shop_data: global.gear_shop_data
    },
    mobility: {
        data: global.gear[$ "mobility"],
        shop_data: global.mobility_shop_data
    },
};


if (struct_exists(shop_data_lookup, shop)) {
    var _shop_info = shop_data_lookup[$ shop];
    var _item_names = variable_struct_get_names(_shop_info.data);
    array_sort(_item_names, true);

    for (var i = 0, count = array_length(_item_names); i < count; ++i) {
        var _name = _item_names[i];

        if (!struct_exists(_shop_info.shop_data, _name)) {
            continue;
        }

        var _shop_data = _shop_info.shop_data[$ _name];

        if (shop == "weapons") {
            var _tags = global.weapons[$ _name].tags;
            if (array_contains_ext(_tags, ["turret", "Sponson", "sponson"])) {
                continue;
            }
        }

        if (struct_exists(_shop_data, "no_buying")) {
            no_buying[i] = _shop_data[$ "no_buying"];
        }

        item_name[i] = _name;
        item_stocked[i] = scr_item_count(_name);
        mc_stocked[i] = scr_item_count(_name, "master_crafted");
        if (struct_exists(_shop_data, "value")) {
            buy_cost[i] = _shop_data[$ "value"];
        } else {
            buy_cost[i] = 50;

        }
        find_best_seller(sellers[i]);
        buy_cost[i] *= min(best_modifier, discount_rogue_trader);
        buy_cost[i] = max(round(buy_cost[i]), 1);
    

        if (in_forge) {
            if (struct_exists(_shop_data, "requires_to_build")) {
                var _required_names = _shop_data[$ "requires_to_build"];
                for (var r = 0, req_count = array_length(_required_names); r < req_count; ++r) {
                    if (!array_contains(obj_controller.technologies_known, _required_names[r])) {
                        no_forging[i] = true;
                        break;
                    }
                }
            }

            if (!no_forging[i]) {
                var disc = obj_controller.stc_wargear * 5;
                item_cost_tooltip_info += $"Wargear STC: -{disc}%\n";
                forge_cost_mod -= disc;

                forge_cost[i] = buy_cost[i] * 10;
                forge_cost[i] *= forge_cost_mod;
            }
        }
    }
} else if (shop == "vehicles") {
    var _gear_names = variable_struct_get_names(global.gear[$ "gear"]);
    array_sort(_gear_names, true);
    for (var i = 0; i < array_length(_gear_names); ++i) {
        var _gear_name = _gear_names[i];
        if (!struct_exists(global.gear_shop_data, _gear_name)) {
            continue;
        }

        var _gear_shop_data = global.gear_shop_data[$ _gear_name];
        if (struct_exists(_gear_shop_data, "no_buying")) {
            no_buying[i] = _gear_shop_data[$ "no_buying"];
        }

        item_name[i] = _gear_name;
        tooltip_override[i] = facility_data[$ "description"];
        item_stocked[i] = scr_item_count(_gear_name);
        mc_stocked[i] = scr_item_count(item_name[i], "master_crafted");
        buy_cost[i] = _gear_shop_data[$ "value"];

        if (in_forge) {
            if (struct_exists(_gear_shop_data, "requires_to_build")) {
                var _required_names = _gear_shop_data[$ "requires_to_build"];
                for (var r = 0; r < array_length(_required_names); r++) {
                    var _required_name = _required_names[r];
                    if (!array_contains(obj_controller.technologies_known, _required_name)) {
                        no_forging[i] = true;
                        break;
                    }
                }
            }
            if (!no_forging[i]) {
                forge_cost[i] = buy_cost[i] * 10;
            }
        }
    }

    discount_stc = obj_controller.stc_vehicles * 3;
    var _player_hangers = array_length(obj_controller.player_forge_data.vehicle_hanger);
    var _hangar_discount = _player_hangers * 3;

    item_cost_tooltip_info += $"Vehicle STC: -{discount_stc}%\n";
    item_cost_tooltip_info += $"Hangars: -{_hangar_discount}%\n";
    forge_cost_mod -= discount_stc;
    forge_cost_mod -= _hangar_discount;
} else if (shop == "warships") {
    discount_stc = obj_controller.stc_ships * 5;
    item_cost_tooltip_info += $"Ship STC: -{discount_stc}%\n";
    forge_cost_mod -= discount_stc;
} else if (shop == "production") {
    var technology_names = variable_struct_get_names(global.technology_shop_data);
    array_sort(technology_names, true);
    for (var i = 0, count = array_length(technology_names); i < count; ++i) {
        var facility_name = technology_names[i];
        var facility_data = global.technology_shop_data[$ facility_name];

        if (!struct_exists(facility_data, "cost")) {
            continue;
        }

        item_name[i] = facility_data[$ "name"];
        tooltip_override[i] = facility_data[$ "description"];
        forge_type[i] = "research";
        forge_cost[i] = facility_data[$ "cost"];
        no_forging[i] = false;

        if (struct_exists(facility_data, "requires_to_build")) {
            var _required_names = facility_data[$ "requires_to_build"];
            for (var r = 0, req_count = array_length(_required_names); r < req_count; ++r) {
                if (!array_contains(obj_controller.technologies_known, _required_names[r])) {
                    no_forging[i] = true;
                    break;
                }
            }
        }
    }
}

legitimate_items = i;
