function Armamentarium() constructor {
    shop = "weapons";

    tab_buttons = {
        /// @type {Struct.MainMenuButton}
        weapons: new MainMenuButton(spr_ui_but_3, spr_ui_hov_3),
        armour: new MainMenuButton(spr_ui_but_3, spr_ui_hov_3),
        vehicles: new MainMenuButton(spr_ui_but_3, spr_ui_hov_3),
        ships: new MainMenuButton(spr_ui_but_3, spr_ui_hov_3),
    };

    in_forge = false;
    construction_started = 0;
    eta = 0;
    target_comp = obj_controller.new_vehicles;

    slate_panel = new DataSlate();
    page_mod = 0;
    tooltip_stat1 = 0;
    tooltip_stat2 = 0;
    tooltip_stat3 = 0;
    tooltip_stat4 = 0;
    tooltip_other = "";

    forge_cost_mod = 1;
    discount_stc = 0;
    tech_heretic_modifier = 0;
    discount_rogue_trader = 1;

    shop_items = {
        weapons: [],
        armour: [],
        gear: [],
        mobility: [],
    };

    shop_data_lookup = {
        weapons: global.weapons,
        armour: global.gear[$ "armour"],
        gear: global.gear[$ "gear"],
        mobility: global.gear[$ "mobility"],
    };

    /// @description Sells an item and adds resources to the player
    /// @param {Struct.ShopItem} _shop_item The index of the item in the global array
    /// @param {Real} sell_count The quantity to sell
    /// @param {Real} sell_modifier The value modifier
    /// @returns {Bool} Whether the sale was successful
    sell_item = function(_shop_item, sell_count, sell_modifier) {
        if (_shop_item.stocked >= sell_count) {
            var sell_price = (_shop_item.buy_cost * sell_modifier) * sell_count;

            scr_add_item(_shop_item.name, (-sell_count), "standard");
            _shop_item.stocked -= sell_count;
            obj_controller.requisition += sell_price;

            return true;
        }

        return false;
    };

    with (obj_p_fleet) {
        if ((capital_number > 0) && (action == "")) {
            /// @type {Asset.GMObject.obj_star}
            var you = instance_nearest(x, y, obj_star);

            if (you.trader > 0) {
                obj_shop.discount_rogue_trader = 0.8;
            }
        }
    }

    with (obj_star) {
        if (array_contains(p_owner, 1) && (trader > 0)) {
            obj_shop.discount_rogue_trader = 0.8;
        }
    }

    if (discount_rogue_trader != 1) {
        cost_tooltip += $"Near a Rogue Trader: x{discount_rogue_trader}\n";
    }

    if (struct_exists(shop_data_lookup, shop)) {
        var _shop_info = shop_data_lookup[$ shop];
        var _item_names = variable_struct_get_names(_shop_info);
        array_sort(_item_names, true);

        for (var i = 0, count = array_length(_item_names); i < count; ++i) {
            var _name = _item_names[i];

            if (!struct_exists(_shop_info, _name)) {
                continue;
            }

            var _shop_data = _shop_info[$ _name];

            if (shop == "weapons") {
                var _tags = _shop_data.tags;
                if (array_contains_ext(_tags, ["turret", "Sponson", "sponson"])) {
                    continue;
                }
            }

            /// @type {Struct.ShopItem}
            var _shop_item = new ShopItem(_name);
            _shop_item.area = shop;

            var _equip_data = gear_weapon_data("any", _shop_item.name);
            if (is_struct(_equip_data)) {
                tooltip = $"{_equip_data.item_tooltip_desc_gen()}";
            } else {
                tooltip = "";
            }

            _shop_item.stocked = scr_item_count(_name);
            _shop_item.mc_stocked = scr_item_count(_name, "master_crafted");

            if (struct_exists(_shop_data, "value")) {
                _shop_item.value = _shop_data[$ "value"];
                _shop_item.no_buying = false;
            }

            if (struct_exists(_shop_data, "no_buying")) {
                _shop_item.no_buying = _shop_data[$ "no_buying"];
            }

            _shop_item.update_best_seller(_shop_item.sellers);

            if (in_forge) {
                if (global.cheat_debug) {
                    _shop_item.forge_cost = 0;
                    _shop_item.no_forging = false;
                    array_push(shop_items[$ shop], _shop_item);
                } else {
                    if (struct_exists(_shop_data, "requires_to_build")) {
                        var _required_names = _shop_data[$ "requires_to_build"];
                        for (var r = 0, req_count = array_length(_required_names); r < req_count; ++r) {
                            if (!array_contains(obj_controller.technologies_known, _required_names[r])) {
                                _shop_item.no_forging = true;
                                break;
                            }
                        }
                    }

                    if (!_shop_item.no_forging) {
                        var disc = obj_controller.stc_wargear * 5;
                        cost_tooltip += $"Wargear STC: -{disc}%\n";
                        forge_cost_mod -= disc;

                        _shop_item.forge_cost = _shop_item.value * 10;
                        _shop_item.forge_cost *= forge_cost_mod;
                    }

                    array_push(shop_items[$ shop], _shop_item);
                }
            } else {
                if (global.cheat_debug) {
                    _shop_item.buy_cost = 0;
                    _shop_item.no_buying = false;
                    array_push(shop_items[$ shop], _shop_item);
                } else if (!_shop_item.no_buying || _shop_item.stocked > 0) {
                    _shop_item.buy_cost = _shop_item.value * min(_shop_item.buy_cost_mod, discount_rogue_trader);
                    _shop_item.buy_cost = round(_shop_item.buy_cost);
                    array_push(shop_items[$ shop], _shop_item);
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

        cost_tooltip += $"Vehicle STC: -{discount_stc}%\n";
        cost_tooltip += $"Hangars: -{_hangar_discount}%\n";
        forge_cost_mod -= discount_stc;
        forge_cost_mod -= _hangar_discount;
    } else if (shop == "warships") {
        discount_stc = obj_controller.stc_ships * 5;
        cost_tooltip += $"Ship STC: -{discount_stc}%\n";
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

    drop_down_sandwich = function(selection, draw_x, draw_y, options, open_marker, left_text, right_text) {
        draw_text_transformed(draw_x, draw_y, left_text, 1, 1, 0);
        draw_x += string_width(left_text) + 5;
        var results = drop_down(selection, draw_x, draw_y - 2, options, open_marker);
        draw_set_color(c_gray);
        draw_text_transformed(draw_x + 9 + string_width(selection), draw_y, right_text, 1, 1, 0);
        return results;
    };

    set_up_armentarium = function() {
        static xx = __view_get(e__VW.XView, 0);
        static yy = __view_get(e__VW.YView, 0);
        menu = 14;
        onceh = 1;
        cooldown = 8000;
        click = 1;
        temp[36] = scr_role_count(obj_ini.role[100][16], "");
        temp[37] = temp[36] + scr_role_count(string(obj_ini.role[100][16]) + " Aspirant", "");
        specialist_point_handler.calculate_research_points();
        in_forge = false;
        forge_button = new ShutterButton();
        forge_button.cover_text = "FORGE";
        stc_flashes = new GlowDot();
        gift_stc_button = new UnitButtonObject({x1: 650, y1: 467, style: "pixel", label: "Gift", set_width: true, w: 90});
        identify_stc_button = new UnitButtonObject({x1: 670, y1: 467, style: "pixel", label: "Identify", set_width: true, w: 90});
        /*for (var i =0;i<3;i++){
            for (var f =0;f<7;f++){
                stc_flashes[i][f] = new GlowDot();
            // stc_flashes[i][f].flash_size
            }
        }*/
        speeding_bits = {
            "wargear": new SpeedingDot(0, 0, (210 / 6) * stc_wargear),
            "vehicles": new SpeedingDot(0, 0, (210 / 6) * stc_vehicles),
            "ships": new SpeedingDot(0, 0, (210 / 6) * stc_ships),
        };
    };

    same_locations = function(first_loc, second_loc) {
        var same_loc = false;
        if (is_array(first_loc) && is_array(second_loc)) {
            if (first_loc[2] != "Warp" && first_loc[2] != "Lost") {
                if (first_loc[2] == second_loc[2]) {
                    same_loc = true;
                }
            } else {
                if ((first_loc[1] == second_loc[1]) && (first_loc[0] == second_loc[0])) {
                    same_loc = true;
                }
            }
        }
        return same_loc;
    };

    identify_stc = function(area) {
        switch (area) {
            case "wargear":
                stc_wargear++;
                if (stc_wargear == 2) {
                    stc_bonus[1] = choose(1, 2, 3, 4, 5);
                }
                if (stc_wargear == 4) {
                    stc_bonus[2] = choose(1, 2, 3);
                }
                stc_research.wargear = 0;
                break;
            case "vehicles":
                stc_vehicles++;
                if (stc_vehicles == 2) {
                    stc_bonus[3] = choose(1, 2, 3, 4, 5);
                }
                if (stc_vehicles == 4) {
                    stc_bonus[4] = choose(1, 2, 3);
                }
                stc_research.vehicles = 0;
                break;
            case "ships":
                stc_ships++;
                if (stc_ships == 2) {
                    stc_bonus[5] = choose(1, 2, 3, 4, 5);
                }
                if (stc_ships == 4) {
                    stc_bonus[6] = choose(1, 2, 3);
                }
                stc_research.ships = 0;
                break;
        }
    };

    draw_armentarium_gui = function() {
        if (!in_forge) {
            draw_set_alpha(1);
            draw_set_font(fnt_40k_14);
            draw_set_halign(fa_left);
            draw_text(384, 468, string(stc_wargear_un + stc_vehicles_un + stc_ships_un) + " Unidentified Fragments");
            var _has_stc = stc_wargear_un + stc_vehicles_un + stc_ships_un > 0;
            if (!_has_stc) {
                var _tools = "No STCs Available";
                gift_stc_button.tooltip = _tools;
                identify_stc_button.tooltip = _tools;
            }
            if (gift_stc_button.draw(_has_stc)) {
                setup_gift_stc_popup();
            }
            identify_stc_button.update({x1: gift_stc_button.x2});
            if (identify_stc_button.draw(_has_stc)) {
                audio_play_sound(snd_stc, -500, 0);
                audio_sound_gain(snd_stc, master_volume * effect_volume, 0);

                if (stc_wargear_un > 0 && stc_wargear < MAX_STC_PER_SUBCATEGORY) {
                    stc_wargear_un--;
                    identify_stc("wargear");
                } else if (stc_vehicles_un > 0 && stc_vehicles < MAX_STC_PER_SUBCATEGORY) {
                    stc_vehicles_un--;
                    identify_stc("vehicles");
                } else if (stc_ships_un > 0 && stc_ships < MAX_STC_PER_SUBCATEGORY) {
                    stc_ships_un--;
                    identify_stc("ships");
                }

                // Refresh the shop
                instance_create(1000, 1000, obj_shop);
                set_up_armentarium();
            }
        }
    };

    draw_armentarium = function() {
        var _recruit_pace = RECRUITMENT_PACE_DESCRIPTIONS;
        var _train_tiers = TECHMARINE_TRAINING_TIERS;
        var xx = __view_get(e__VW.XView, 0) + 0;
        var yy = __view_get(e__VW.YView, 0) + 0;
        draw_sprite(spr_rock_bg, 0, xx, yy);

        draw_set_alpha(0.75);
        draw_set_color(0);
        draw_rectangle(xx + 326 + 16, yy + 66, xx + 887 + 16, yy + 818, 0);
        draw_set_alpha(1);
        draw_set_color(c_gray);
        draw_rectangle(xx + 326 + 16, yy + 66, xx + 887 + 16, yy + 818, 1);
        draw_line(xx + 326 + 16, yy + 426, xx + 887 + 16, yy + 426);

        if (menu_adept == 0) {
            // draw_sprite(spr_advisors,4,xx+16,yy+43);
            if (struct_exists(obj_ini.custom_advisors, "forge_master")) {
                scr_image("advisor/splash", obj_ini.custom_advisors.forge_master, xx + 16, yy + 43, 310, 828);
            } else {
                scr_image("advisor/splash", 5, xx + 16, yy + 43, 310, 828);
            }
            draw_set_halign(fa_left);
            draw_set_color(c_gray);
            draw_set_font(fnt_40k_30b);
            var header = obj_shop.in_forge ? "Forge" : "Armamentarium";
            draw_text_transformed(xx + 336 + 16, yy + 66, string_hash_to_newline(header), 1, 1, 0);
            if (!obj_shop.in_forge) {
                draw_set_font(fnt_40k_30b);
                draw_text_transformed(xx + 336 + 16, yy + 100, string_hash_to_newline("Forge Master " + string(obj_ini.name[0][1])), 0.6, 0.6, 0);
            }
        }
        if (menu_adept == 1) {
            // draw_sprite(spr_advisors,0,xx+16,yy+43);
            scr_image("advisor/splash", 1, xx + 16, yy + 43, 310, 828);
            draw_set_halign(fa_left);
            draw_set_color(c_gray);
            draw_set_font(fnt_40k_30b);
            draw_text_transformed(xx + 336 + 16, yy + 66, string_hash_to_newline("Armamentarium"), 1, 1, 0);
            draw_set_font(fnt_40k_30b);
            draw_text_transformed(xx + 336 + 16, yy + 100, string_hash_to_newline("Adept " + string(obj_controller.adept_name)), 0.6, 0.6, 0);
        }

        draw_set_font(fnt_40k_30b);
        draw_set_color(c_black);

        draw_set_alpha(0.2);
        if ((mouse_y >= yy + 76) && (mouse_y < yy + 104)) {
            if ((mouse_x >= xx + 957) && (mouse_x < xx + 1062)) {
                draw_rectangle(xx + 957, yy + 76, xx + 1062, yy + 104, 0);
            }
            if ((mouse_x >= xx + 1068) && (mouse_x < xx + 1136)) {
                draw_rectangle(xx + 1068, yy + 76, xx + 1136, yy + 104, 0);
            }
            if ((mouse_x >= xx + 1167) && (mouse_x < xx + 1255)) {
                draw_rectangle(xx + 1167, yy + 76, xx + 1255, yy + 104, 0);
            }
            if ((mouse_x >= xx + 1447) && (mouse_x < xx + 1545)) {
                draw_rectangle(xx + 1487, yy + 76, xx + 1545, yy + 104, 0);
            }
        }
        draw_set_alpha(1);
        draw_set_color(c_gray);

        if (!obj_shop.in_forge) {
            draw_set_alpha(1);

            draw_set_font(fnt_40k_12);
            draw_set_halign(fa_left);
            draw_set_color(c_gray);

            var max_techs;
            blurp = "";
            max_techs = round((disposition[3] / 2)) + 5;

            var yyy1, yyy;
            yyy1 = max_techs - temp[37];
            if (yyy1 < 0) {
                yyy1 = yyy1 * -1;
            }
            yyy = yyy1 * 2;
            if (disposition[3] % 2 == 0) {
                yyy += 2;
            } else {
                yyy += 1;
            }

            blurp = "Subject ID confirmed.  Rank Identified: Chapter Master.  Salutations Chapter Master.  We have assembled the following Data: ##" + string(obj_ini.role[100][16]) + "s: " + string(temp[36]) + ".##Summation: ";
            if (obj_controller.faction_status[eFACTION.MECHANICUS] != "War") {
                if (max_techs > temp[37]) {
                    blurp += $"Our Mechanicus Requisitionary powers are sufficient to train {max_techs - temp[37]} additional {obj_ini.role[100][eROLE.TECHMARINE]}.";
                }
                if (max_techs <= temp[37]) {
                    blurp += $"We require {yyy} additional Mechanicus Disposition to train one additional {obj_ini.role[100][eROLE.TECHMARINE]}.";
                }
            } else {
                blurp += $"Since we are at war with the Mechanicus we'll have to train our own {obj_ini.role[100][eROLE.TECHMARINE]}s.";
            }
            blurp += "  The training of new " + string(obj_ini.role[100][16]) + "s";

            if (menu_adept == 1) {
                blurp = "Your Chapter contains " + string(temp[36]) + " " + string(obj_ini.role[100][16]) + ".##";
                blurp += "The training of a new " + string(obj_ini.role[100][16]);
            }
            if (training_techmarine >= 0) {
                blurp += _recruit_pace[training_techmarine];
            }
            if (training_techmarine > 0 && training_techmarine <= 6) {
                eta = floor((359 - tech_points) / _train_tiers[training_techmarine]) + 1;
            }

            if ((tech_aspirant > 0) && (training_techmarine > 0) && (menu_adept == 1)) {
                if (eta == 1) {
                    blurp += "  Your current " + string(obj_ini.role[100][16]) + " Aspirant will finish training in " + string(eta) + " month.";
                }
                if (eta != 1) {
                    blurp += "  Your current " + string(obj_ini.role[100][16]) + " Aspirant will finish training in " + string(eta) + " months.";
                }
            }
            if ((tech_aspirant > 0) && (training_techmarine > 0) && (menu_adept == 0)) {
                if (eta == 1) {
                    blurp += "  The current " + string(obj_ini.role[100][16]) + " Aspirant will finish training in " + string(eta) + " month.";
                }
                if (eta != 1) {
                    blurp += "  The current " + string(obj_ini.role[100][16]) + " Aspirant will finish training in " + string(eta) + " months.";
                }
            }
            if (menu_adept == 0) {
                blurp += "##Data compilation complete.  We currently possess the technology to produce the following:";
            }

            if (menu_adept == 1) {
                if (obj_controller.faction_status[eFACTION.MECHANICUS] != "War") {
                    if (max_techs > temp[37]) {
                        blurp += $"Our Mechanicus Requisitionary powers are sufficient to train {max_techs - temp[37]} additional {obj_ini.role[100][eROLE.TECHMARINE]}.";
                    }
                    if (max_techs <= temp[37]) {
                        blurp += $"We require {yyy} additional Mechanicus Disposition to train one additional {obj_ini.role[100][eROLE.TECHMARINE]}.";
                    }
                } else {
                    blurp += $"Since we are at war with the Mechanicus we'll have to train our own {obj_ini.role[100][eROLE.TECHMARINE]}s.";
                }

                blurp += "##Data compilation complete.  You currently possess the technology to produce the following:";
            }

            draw_text_ext(xx + 336 + 16, yy + 130, string_hash_to_newline(string(blurp)), -1, 536);

            var y_offset = yy + 130 + string_height_ext(string_hash_to_newline(string(blurp)), -1, 536) + 10;
            var research_area_limit;
            if (stc_research.research_focus == "vehicles") {
                research_area_limit = stc_vehicles;
            } else if (stc_research.research_focus == "wargear") {
                research_area_limit = stc_wargear;
            } else if (stc_research.research_focus == "ships") {
                research_area_limit = stc_ships;
            }
            var research_progress = ceil(((5000 * (research_area_limit + 1)) - stc_research[$ stc_research.research_focus]) / specialist_point_handler.research_points);
            static research_drop_down = false;
            var research_eta_message = $"Based on current progress it will be {research_progress} months until next significant research step is complete, Research is currently focussed on {stc_research.research_focus}";
            draw_text_ext(xx + 336 + 16, y_offset + 25, string_hash_to_newline(research_eta_message), -1, 536);

            var forge_buttons = [
                xx + 450 + 16,
                y_offset + 40 + string_height(research_eta_message),
                0,
                0
            ];
            if (forge_button.draw_shutter(forge_buttons[0] + 60, forge_buttons[1], "Enter Forge", 0.5)) {
                obj_shop.in_forge = true;
            }
            draw_set_font(fnt_40k_30b);
            draw_set_halign(fa_center);
            draw_text_transformed(xx + 605, yy + 432, "STC Fragments", 0.75, 0.75, 0);
            draw_set_font(fnt_40k_12);
            draw_set_halign(fa_left);
            draw_set_color(c_gray);

            var hi = 0;
            var f, y_loc;

            draw_set_color(c_gray);
            var _area_coords = {
                "wargear": [
                    xx + 350,
                    yy + 535,
                    xx + 520,
                    yy + 800
                ],
                "vehicles": [
                    xx + 530,
                    yy + 535,
                    xx + 700,
                    yy + 800
                ],
                "ships": [
                    xx + 710,
                    yy + 535,
                    xx + 880,
                    yy + 800
                ],
            };
            var _area_data = {
                "wargear": stc_wargear,
                "vehicles": stc_vehicles,
                "ships": stc_ships,
            };
            var _display_string = {
                "wargear": "Wargear",
                "vehicles": "Vehicles",
                "ships": "Ships",
            };
            var _wargear_one = [
                "Random",
                "Enhanced Bolts",
                "Enhanced Chain Weapons",
                "Enhanced Flame Weapons",
                "Enhanced Missiles",
                "Enhanced Armour"
            ];
            var _wargear_two = [
                "Random",
                "Enhanced Fist Weapons Bolts",
                "Enhanced Plasma",
                "Enhanced Armour"
            ];
            var _vehicle_one = [
                "Random",
                "Enhanced Hull",
                "Enhanced Accuracy",
                "New Weapons",
                "Survivability",
                "Enhanced Armour"
            ];
            var _vehicle_two = [
                "Random",
                "Enhanced Hull",
                "Enhanced Armour",
                "New Weapons"
            ];
            var _ship_one = [
                "Random",
                "Enhanced Hull",
                "Enhanced Accuracy",
                "Enhanced Turning",
                "Enhanced Boarding",
                "Enhanced Armour"
            ];
            var _ship_two = [
                "Random",
                "Enhanced Hull",
                "Enhanced Armour",
                "Enhanced Speed"
            ];

            var _bonus_strings = {
                "wargear": [
                    "8% discount",
                    _wargear_one[stc_bonus[1]],
                    "16% discount",
                    _wargear_two[stc_bonus[2]],
                    "25% discount",
                    "Can produce Terminator Armour and Dreadnoughts."
                ],
                "vehicles": [
                    "8% discount",
                    _vehicle_one[stc_bonus[3]],
                    "16% discount",
                    _vehicle_two[stc_bonus[4]],
                    "25% discount",
                    "Can produce Land Speeders and Land Raiders."
                ],
                "ships": [
                    "8% discount",
                    _ship_one[stc_bonus[5]],
                    "16% discount",
                    _ship_two[stc_bonus[6]],
                    "25% discount",
                    "Warp Speed is increased and ships self-repair."
                ],
            };
            var _researches = [
                "vehicles",
                "wargear",
                "ships"
            ];
            for (var i = 0; i < array_length(_researches); i++) {
                draw_set_alpha(1);
                draw_set_color(c_gray);
                var _res = _researches[i];
                var _coords = _area_coords[$ _res];
                if (stc_research.research_focus == _res) {
                    draw_rectangle_array(_coords, false);
                } else {
                    if (scr_hit(_coords)) {
                        draw_set_alpha(1);
                        draw_set_color(c_white);
                        draw_rectangle_array(_area_coords[$ _res], false);
                        draw_set_color(c_gray);
                        tooltip_draw($"Click to change STC research to {_display_string[$ _res]}");
                        if (scr_click_left()) {
                            stc_research.research_focus = _res;
                        }
                    }
                }
                draw_set_color(c_gray);
                draw_sprite_ext(spr_research_bar, 0, _coords[0] + 9, _coords[1] + 19, 1, 0.7, 0, c_white, 1);
                if (_area_data[$ _res] > 0) {
                    speeding_bits[$ _res].draw(_coords[0], _coords[1] + 20);
                }
                for (f = 0; f < 6; f++) {
                    if (f >= _area_data[$ _res]) {
                        draw_sprite_ext(spr_research_bar, 1, _coords[0] + 9, _coords[1] + 19 + ((210 / 6) * f), 1, 0.6, 0, c_white, 1);
                    }
                }
                if (stc_research.research_focus == _res) {
                    stc_flashes.draw(_coords[0] + 9, _coords[1] + 19 + ((210 / 6) * _area_data[$ _res]));
                }
                draw_set_alpha(1);
                draw_set_color(c_gray);
                draw_set_font(fnt_40k_14);
                draw_text(_coords[0] + 36, _coords[1] - 18, _display_string[$ _res]);
                var _bonus = _bonus_strings[$ _res];
                draw_set_font(fnt_40k_12);
                if (stc_research.research_focus == _res || scr_hit(_coords)) {
                    draw_set_color(c_black);
                }
                for (var s = 0; s < array_length(_bonus); s++) {
                    draw_set_alpha(stc_wargear > s ? 1 : 0.5);
                    draw_text_ext(_coords[0] + 22, yy + 549 + (s * 35), $"{s + 1}) {_bonus[s]}", -1, 140);
                }
            }

            draw_set_color(CM_GREEN_COLOR);
            // draw_rectangle(xx + 711, yy + 539, xx + 728, yy + 539 + hi, 0);
            draw_set_alpha(1);
            draw_set_color(c_gray);
            //draw_rectangle(xx + 351, yy + 539, xx + 368, yy + 749, 1);
            //draw_rectangle(xx + 531, yy + 539, xx + 548, yy + 749, 1);
            //draw_rectangle(xx + 711, yy + 539, xx + 728, yy + 749, 1);
        } else {
            yy += 25;
            draw_set_halign(fa_left);
            draw_set_color(0);
            //draw_rectangle(xx + 359, yy + 66, xx + 886, yy + 818, 0);

            if (point_and_click(draw_unit_buttons([xx + 359, yy + 77], "<-- Overview", [1, 1], c_red))) {
                obj_shop.in_forge = false;
            }

            specialist_point_handler.draw_forge_queue(xx + 359, yy + 107);

            // draw_set_color(c_red);
            //draw_line(xx + 326 + 16, yy + 426, xx + 887 + 16, yy + 426);
            draw_set_color(#af5a00);
            draw_set_font(fnt_40k_14b);
            var forge_text = $"Forge point production per turn: {forge_points}#";
            // draw_sprite_ext(spr_forge_points_icon,0,xx+359+string_width(forge_text), yy+410,0.3,0.3,0,c_white,1);
            forge_text += $"Chapter total {obj_ini.role[100][16]}s: {temp[36]}#";
            forge_text += $"Planetary Forges in operation: {obj_controller.player_forge_data.player_forges}#";
            forge_text += $"Master Craft Forge Chance: {master_craft_chance}%#    Assign techmarines to forges to increase Master Craft Chance";
            // forge_text += $"A total of {obj_ini.role[100, 16]}s assigned to Forges: {var}#";
            draw_text_ext(xx + 359, yy + 410, string_hash_to_newline(forge_text), -1, 670);
        }
    };

    draw = function() {
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
    };
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
    no_forging = true;
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
