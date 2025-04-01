add_draw_return_values();

var romanNumerals = scr_roman_numerals();
var xx = __view_get(e__VW.XView, 0) + 0;
var yy = __view_get(e__VW.YView, 0) + 0;
var x2 = 962;
var y2 = 117;

tooltip_show = 0;

if (construction_started > 0) {
    construction_started -= 1;
}

if (point_and_click([xx + 1262, yy + 82, xx + 1417, yy + 103])) {
    if (target_comp >= 1) {
        target_comp += 1;
    }

    if (target_comp > obj_ini.companies) {
        target_comp = 1;
    }

    obj_controller.new_vehicles = target_comp;
}

draw_set_color(c_black);

slate_panel.inside_method = function() {
    var xx = __view_get(e__VW.XView, 0);
    var yy = __view_get(e__VW.YView, 0);
    var x2 = 962;
    var y2 = 157;

    draw_set_halign(fa_left);
    draw_set_font(fnt_40k_14b);

    draw_text(xx + 962, yy + 159, "Name");
    draw_text(xx + 962.5, yy + 159.5, "Name");

    if (obj_shop.shop != "production") {
        draw_text(xx + 1280, yy + 159, "Stocked");
        draw_text(xx + 1280.5, yy + 159.5, "Stocked");

        if (obj_shop.shop == "weapons" || obj_shop.shop == "armour") {
            draw_text(xx + 1280 + 10 + string_width("Stocked"), yy + 159.5, "MC");
            draw_text(xx + 1280 + 10.5 + string_width("Stocked"), yy + 159.5, "MC");
        }
    }

    draw_text(xx + 1410, yy + 159, "Cost");
    draw_text(xx + 1410.5, yy + 159.5, "Cost");

    draw_set_color(c_gray);

    if (obj_shop.shop == "warships") {
        if (construction_started > 0) {
            var apa = construction_started / 30;
            draw_set_alpha(apa);
            draw_set_color(c_yellow);
            draw_set_halign(fa_center);
            draw_text_transformed(__view_get(e__VW.XView, 0) + 420, yy + 370, $"CONSTRUCTION STARTED!\nETA: {eta} months", 1.5, 1.5, 0);
            draw_set_halign(fa_left);
            draw_set_color(CM_GREEN_COLOR);
            draw_set_alpha(1);
        }
    }

    var _shop_items = obj_shop.shop_items[$ obj_shop.shop];
    var _items_count = array_length(_shop_items);
    var viable = 0;
    var final = 1;
    var entered;
    var i = 0 + (27 * page_mod);
    /// @type {Struct.ShopItem};
    var _show_item = undefined;

    while (i < _items_count && viable <= 27) {
        _show_item = _shop_items[i];
        entered = false;
        i++;
        if (_show_item.name != "") {
            y2 += 20;
            viable++;
            final = i;
            if ((!obj_shop.in_forge && !_show_item.no_buying) || (obj_shop.in_forge && !_show_item.no_forging)) {
                draw_set_color(c_gray);
                if (scr_hit(xx + 962, yy + y2 + 2, xx + 1580, yy + y2 + 18)) {
                    draw_set_color(c_gray);
                    entered = true;
                    draw_rectangle(xx + 960, yy + y2 + 1, xx + 1582, yy + y2 + 18, 0);
                    draw_set_color(c_white);
                }

                if ((!keyboard_check(vk_shift)) || (obj_shop.shop == "warships")) {
                    draw_text(xx + x2 + _show_item.x_mod, yy + y2, string_hash_to_newline(_show_item.name));
                } // Name
                if (keyboard_check(vk_shift) && (obj_shop.shop != "warships") && (obj_shop.shop != "production")) {
                    draw_text(xx + x2 + _show_item.x_mod, yy + y2, string_hash_to_newline(string(_show_item.name) + " x5"));
                } // Name
                if ((_show_item.stocked == 0) && ((_show_item.mc_stocked == 0) || (obj_shop.shop != "weapons"))) {
                    draw_set_alpha(0.5);
                }
                if ((_show_item.mc_stocked == 0) && (obj_shop.shop != "production")) {
                    draw_text(xx + 1300, yy + y2, string_hash_to_newline(_show_item.stocked));
                } // Stocked
                if (_show_item.mc_stocked > 0) {
                    draw_text(xx + 1300, yy + y2, string_hash_to_newline(string(_show_item.stocked) + "   mc: " + string(_show_item.mc_stocked)));
                }
                draw_set_alpha(1);

                if (obj_shop.in_forge) {
                    draw_sprite_ext(spr_forge_points_icon, 0, xx + 1410, yy + y2 + 3, 0.3, 0.3, 0, c_white, 1);
                } else {
                    draw_sprite_ext(spr_requisition, 0, xx + 1410, yy + y2 + 6, 1, 1, 0, c_white, 1);
                }
                draw_set_color(16291875);
                if (obj_shop.in_forge) {
                    draw_set_color(#af5a00);
                }

                var cost = obj_shop.in_forge ? _show_item.forge_cost : _show_item.buy_cost;
                if (!obj_shop.in_forge) {
                    if ((!keyboard_check(vk_shift)) && (obj_controller.requisition < _show_item.buy_cost)) {
                        draw_set_color(255);
                    }
                    if (keyboard_check(vk_shift) && (obj_controller.requisition < (_show_item.buy_cost * 5))) {
                        draw_set_color(255);
                    }
                }
                if (obj_shop.shop != "production") {
                    if (keyboard_check(vk_shift)) {
                        cost *= 5;
                    }
                }

                draw_text(xx + 1427, yy + y2, cost); // Requisition

                if (!obj_shop.in_forge) {
                    if (obj_controller.requisition < cost) {
                        draw_set_alpha(0.25);
                    }
                    draw_set_alpha(obj_controller.requisition < cost ? 0.25 : 1);
                    draw_sprite(spr_buy_tiny, 0, xx + 1530, yy + y2 + 2);
                    // Restore for subsequent UI regardless of whether sell is drawn
                    draw_set_alpha(1);

                    if (obj_shop.shop != "warships" && obj_shop.shop != "vehicles" && _show_item.stocked > 0) {
                        draw_set_alpha(1);

                        var _button = draw_sprite_as_button([xx + 1480, yy + y2 + 2], spr_sell_tiny);
                        if (scr_hit(_button)) {
                            var _sell_mod = SHOP_SELL_MOD;
                            tooltip = $"Send items back for {_sell_mod * 100}% of the requisition cost.";
                            tooltip_show = 1;
                            if (scr_click_left()) {
                                var sell_mult_count = keyboard_check(vk_shift) ? 5 : 1;
                                obj_shop.sell_item(_show_item, sell_mult_count, _sell_mod);
                            }
                        }
                    }
                }

                var clicked = point_and_click([xx + 1520, yy + y2 + 2, xx + 1570, yy + y2 + 14]);
                if (obj_shop.in_forge) {
                    draw_sprite(spr_build_tiny, 0, xx + 1530, yy + y2 + 2);
                    if (clicked) {
                        if (array_length(obj_controller.specialist_point_handler.forge_queue) < 20) {
                            var new_queue_item = {
                                name: _show_item.name,
                                count: 1,
                                forge_points: _show_item.forge_cost,
                                ordered: obj_controller.turn,
                                type: _show_item.forge_type,
                            };
                            if (obj_shop.shop != "production") {
                                if (keyboard_check(vk_shift)) {
                                    new_queue_item.count = 5;
                                    new_queue_item.forge_points = 5 * _show_item.forge_cost;
                                }
                            }
                            array_push(obj_controller.specialist_point_handler.forge_queue, new_queue_item);
                        }
                    }
                } else if (!_show_item.no_buying && clicked && !obj_shop.in_forge) {
                    cost = _show_item.buy_cost;
                    var _mult_count = keyboard_check(vk_shift) ? 5 : 1;
                    if (obj_shop.shop != "warships") {
                        cost *= _mult_count;
                    }

                    if ((obj_controller.requisition >= cost) && (obj_shop.shop != "warships")) {
                        var _vehics = [
                            "Rhino",
                            "Predator",
                            "Land Raider",
                            "Whirlwind",
                            "Land Speeder"
                        ];

                        if (!array_contains(_vehics, _show_item.name)) {
                            scr_add_item(_show_item.name, _mult_count);
                            _show_item.stocked += _mult_count;
                            click2 = true;
                        } else {
                            repeat (_mult_count) {
                                scr_add_vehicle(_show_item.name, obj_shop.target_comp, {});
                            }
                            _show_item.stocked += _mult_count;
                            click2 = 1;
                            with (obj_ini) {
                                scr_vehicle_order(obj_shop.target_comp);
                            }
                        }
                        obj_controller.requisition -= cost;
                    }

                    if ((obj_controller.requisition >= cost) && (obj_shop.shop == "warships")) {
                        var _duration = 4;
                        if (_show_item.name == "Battle Barge") {
                            _duration = 30;
                        } else if (_show_item.name == "Strike Cruiser") {
                            _duration = 10;
                        }

                        eta = _duration;

                        construction_started = 120;
                        obj_controller.requisition -= cost;
                        add_event({e_id: "ship_construction", ship_class: _show_item.name, duration: _duration});
                    }
                }
            }
            if ((!obj_shop.in_forge && _show_item.no_buying == 1) || (obj_shop.in_forge && _show_item.no_forging == 1)) {
                draw_set_alpha(1);
                draw_set_color(881503);
                draw_text(xx + x2 + _show_item.x_mod, yy + y2, _show_item.name); // Name
                if (_show_item.stocked == 0) {
                    draw_set_alpha(0.5);
                }
                if (obj_shop.shop != "production") {
                    draw_text(xx + 1300, yy + y2, _show_item.stocked); // Stocked
                }
                draw_set_alpha(1);
            }
            if (scr_hit(xx + 962, yy + y2, xx + 1280, yy + y2 + 19) && (obj_shop.shop != "warships")) {
                if (_show_item.tooltip != "") {
                    tooltip_draw(_show_item.tooltip, 400);
                }
            }
        }
    }

    pages_required = ceil(_items_count / 28);

    for (i = 0; i < pages_required; i++) {
        var _button_color = c_red;

        if (page_mod == i) {
            _button_color = c_green;
        }

        var _button_clicked = point_and_click(draw_unit_buttons([xx + 1040 + (25 * i), yy + 740], i + 1, [1, 1], _button_color));

        if (_button_clicked) {
            page_mod = i;
        }
    }
};

slate_panel.draw(xx + 920, yy + 95, 690 / 850, 0.85);

var te = "";
// TODO refactor target_comp and how companies are counted in general
if (shop == "vehicles") {
    if (target_comp <= 10) {
        te = romanNumerals[target_comp - 1];
    }
    if ((mouse_x >= xx + 1262) && (mouse_y >= yy + 78) && (mouse_x <= xx + 1417) && (mouse_y < yy + 103)) {
        draw_set_alpha(0.8);
    }
    draw_text(xx + 1310, yy + 82, string_hash_to_newline("Target: " + string(te) + " Company"));
}

draw_set_alpha(1);

var shop_area = "";

if (tab_buttons.weapons.draw(xx + 960, yy + 64, "Equipment")) {
    shop_area = "weapons";
}
if (tab_buttons.armour.draw(xx + 1075, yy + 64, "Armour")) {
    shop_area = "armour";
}
if (tab_buttons.vehicles.draw(xx + 1190, yy + 64, "Vehicles")) {
    shop_area = "vehicles";
}
if (in_forge) {
    if (tab_buttons.ships.draw(xx + 1460, yy + 64, "Manufactoring")) {
        shop_area = "production";
    }
} else {
    if (tab_buttons.ships.draw(xx + 1460, yy + 64, "Ships")) {
        shop_area = "warships";
    }
}

if (tooltip_show != 0) {
    tooltip_draw(tooltip, 400);
}

if (shop_area != "") {
    shop = shop_area;
}

pop_draw_return_values();
