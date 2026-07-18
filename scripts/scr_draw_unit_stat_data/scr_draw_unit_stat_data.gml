function scr_draw_unit_stat_data(manage = false, data_block = {x1: 1008, y1: 520, w: 569, h: 303}, squeezed = false) {
    var _cur_font = draw_get_font();
    draw_set_font(fnt_40k_14);
    var xx = camera_get_view_x(view_camera[0]);
    var yy = camera_get_view_y(view_camera[0]);
    if (event_number == ev_gui) {
        xx = 0;
        yy = 0;
    }
    var _stat_tool_tips = [];
    var _trait_tool_tips = [];
    var _unit_name = self.name();
    if (psionic < 0) {
        var _psy_levels = global.arr_negative_psy_levels;
        var _psionic_assignment = _psy_levels[psionic * -1];
    } else {
        var _psy_levels = global.arr_psy_levels;
        var _psionic_assignment = _psy_levels[psionic];
    }
    data_block.x1 += xx;
    data_block.y1 += yy;
    data_block.x2 = data_block.x1 + data_block.w;
    data_block.y2 = data_block.y1 + data_block.h;
    data_block.x_mid = (data_block.x1 + data_block.x2) / 2;
    data_block.y_mid = (data_block.y1 + data_block.y2) / 2;

    var _attribute_box = {
        x1: data_block.x1 + (squeezed ? 42 : 84),
        y1: data_block.y1 + 8,
        w: 32,
        h: 48,
        enter: function() {
            return scr_hit(x1, y1, x2, y2);
        },
        draw: function(outline) {
            draw_rectangle(x1, y1, x2, y2, outline);
        },
    };
    _attribute_box.x2 = _attribute_box.x1 + _attribute_box.w;
    _attribute_box.y2 = _attribute_box.y1 + _attribute_box.h;
    _attribute_box.x_mid = (_attribute_box.x1 + _attribute_box.x2) / 2;
    _attribute_box.y_mid = (_attribute_box.y1 + _attribute_box.y2) / 2;

    stat_display_list = [
        [
            "Measure of how quick and nimble unit is as well as their base ability to manipulate and do tasks with their hands.##Influences Ranged Attack",
            "dexterity",
        ],
        [
            "How strong a unit. Strong units can wield heavier equipment without penalties and are more deadly in close combat.##Influences Melee Attack#Influences Melee Burden Cap#Influences Ranged Burden Cap",
            "strength",
        ],
        [
            "Unit's general toughness and resistance to damage.##Influences Health#Influences Damage Resistance",
            "constitution",
        ],
        [
            "Measure of learnt knowledge and specialist skill aptitude.##Influences esoteric knowledge and use of force weapons",
            "intelligence",
        ],
        [
            "Unit's perception and street smarts including certain types of battlefield knowledge.##Influences tactical decisions and garrison effects",
            "wisdom",
        ],
        [
            "Unit's faith in their given religion or general aptitude towards faith.##Influences resistance to corruption",
            "piety",
        ],
        [
            "General skill with close combat weaponry.##Influences Melee Attack#Influences Melee Burden Cap",
            "weapon_skill",
        ],
        [
            "General skill with ballistic and ranged weaponry.##Influences Ranged Attack#Influences Ranged Burden Cap",
            "ballistic_skill",
        ],
        [
            "...Luck...",
            "luck",
        ],
        [
            "Skill and understanding of technology and various technical thingies and ability to interact with the machine spirit.##Influences Forge point output",
            "technology",
        ],
        [
            "General likeability and ability to interact with people.##Influences disposition increases and decreases#Influences ability to spread corruption",
            "charisma",
        ],
    ];
    for (var i = 0; i < array_length(stat_display_list); i++) {
        var _stat_data = stat_display_list[i];
        var _stat_key = _stat_data[1];
        var _stat_abbreviation = global.stat_shorts[$ _stat_key];
        var _stat_name = global.stat_display_strings[$ _stat_key];
        var _icon = global.stat_icons[$ _stat_key];
        var _stat_description = _stat_data[0];
        var _stat_col = global.stat_display_colour[$ _stat_key];
        var _icon_colour = c_gray;

        if (_attribute_box.enter()) {
            _icon_colour = c_white;
            draw_set_color(_stat_col);
            _attribute_box.draw(false);
        }
        draw_set_color(c_gray);
        _attribute_box.draw(true);
        draw_sprite_ext(_icon, 0, _attribute_box.x1, _attribute_box.y1, 0.5, 0.5, 0, _icon_colour, 1);
        draw_set_color(#50a076);
        draw_set_halign(fa_center);
        draw_text((_attribute_box.x1 + _attribute_box.x2) / 2, _attribute_box.y1 + 32, $"{self[$ _stat_key]}");
        draw_set_halign(fa_left);
        if (manage) {
            if (point_and_click([_attribute_box.x1, _attribute_box.y1, _attribute_box.x2, _attribute_box.y1 + 45])) {
                filter_and_sort_company("stat", _stat_key);
                obj_controller.unit_bio = false;
            }
        }
        var stat_percentage = 0;

        if (is_struct(obj_controller.temp[122])) {
            if (struct_exists(obj_controller.temp[122], _stat_key)) {
                stat_percentage = obj_controller.temp[122][$ _stat_key];
            }
        }
        var _final_string = $"{_stat_description} #Click to order by highest {_stat_name}#{stat_percentage}% chance of growth";
        array_push(_stat_tool_tips, [_attribute_box.x1, _attribute_box.y1, _attribute_box.x2, _attribute_box.y2, _final_string, $"{_stat_name} ({_stat_abbreviation})"]);
        _attribute_box.x1 += 36;
        _attribute_box.x2 += 36;
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(#50a076);

    if (!obj_controller.view_squad && obj_controller.unit_bio) {
        var _unit_data_string = unit_profile_text();
        tooltip_draw(_unit_data_string, 925, [xx + 23, yy + 141],,,,, true);
    }

    var _data_lines = [];
    var _data_entry = {};
    _data_entry.text = $"Loyalty: {loyalty}\n";
    _data_entry.tooltip = "Loyalty represents the unwavering devotion to one's Chapter, their Primarch, and the Emperor himself. It is a measure of their ability to resist the temptations of Chaos, the influence of xenos artifacts, and the machinations of the Warp.";
    array_push(_data_lines, _data_entry);

    _data_entry = {};
    _data_entry.text = $"Corruption: {corruption}\n";
    _data_entry.tooltip = "Corruption reflects exposure to the malevolent forces of the Warp. High Corruption may indicate that the person is teetering on the brink of damnation, while a low score suggests relative purity.";
    array_push(_data_lines, _data_entry);

    _data_entry = {};
    _data_entry.text = $"Assignment: {_psionic_assignment} ({psionic})\n";
    _data_entry.tooltip = "The Imperium measures and records the psionic activity and power level of psychic individuals through a rating system called The Assignment. Comprised of a twenty-four point scale, The Assignment simplifies the comparison of psykers to aid Imperial authorities in recognizing possible threats.";
    array_push(_data_lines, _data_entry);

    var _forge_gen = forge_point_generation();

    _data_entry = {};
    _data_entry.tooltip = "";
    var _gen_reasons = _forge_gen[1];
    _data_entry.text = $"Forge Production: {_forge_gen[0]}\n";
    if (struct_exists(_gen_reasons, "trained")) {
        _data_entry.tooltip += $"Trained On Mars (TEC/10): {_gen_reasons.trained}\n";
        if (struct_exists(_gen_reasons, "at_forge")) {
            _data_entry.tooltip += $"{_gen_reasons.at_forge}(at Forge)\n";
        }
    }
    if (struct_exists(_gen_reasons, "master")) {
        _data_entry.tooltip += $"Forge Master: +{_gen_reasons.master}\n";
    }
    if (struct_exists(_gen_reasons, "crafter")) {
        _data_entry.tooltip += $"Crafter: +{_gen_reasons.crafter}\n";
    }
    if (struct_exists(_gen_reasons, "maintenance")) {
        _data_entry.tooltip += $"Maintenance: {_gen_reasons.maintenance}";
    }
    array_push(_data_lines, _data_entry);

    for (var i = 0; i < array_length(_data_lines); i++) {
        draw_text(data_block.x1 + 16, _attribute_box.y2 + 16 + (i * 24), _data_lines[i].text); // Adjust the y-coordinate for the new line
        array_push(_stat_tool_tips, [data_block.x1 + 16, _attribute_box.y2 + 16 + (i * 24), data_block.x1 + 16 + string_width(_data_lines[i].text), _attribute_box.y2 + 16 + (i * 24) + string_height(_data_lines[i].text), _data_lines[i].tooltip, ""]);
    }

    var x1 = squeezed ? data_block.x1 + ((data_block.x2 - data_block.x1) / 2) + 32 : data_block.x2 - 16;
    if (array_length(traits) != 0) {
        for (var i = 0; i < array_length(traits); i++) {
            var _trait = global.trait_list[$ traits[i]];
            var _trait_name = _trait.display_name;
            var _trait_description = string(_trait.flavour_text, _unit_name);
            var _trait_effect = "";
            if (struct_exists(_trait, "effect")) {
                _trait_effect = string(_trait.effect + "." + "\n\n");
            }
            var y1 = _attribute_box.y2 + 16 + (i * 24);
            draw_set_halign(fa_right);
            draw_text(x1, y1, _trait_name);
            draw_set_halign(fa_left);
            var x2 = x1 - string_width(_trait_name);
            var y2 = y1 + string_height(_trait_name);

            var _trait_growth_effect = "";
            var _stat_list = global.stat_list;
            for (var j = 0; j < array_length(_stat_list); j++) {
                var _stat = _stat_list[j];
                var _stat_name = global.stat_display_strings[$ _stat];
                if (struct_exists(_trait, _stat)) {
                    var _stat_val = eval_trait_stat_data(_trait[$ _stat]);
                    var _descriptive_string = "";
                    if (_stat_val > 0) {
                        repeat (max(floor(_stat_val / 2), 1)) {
                            _descriptive_string += "+";
                        }
                    } else {
                        repeat (max(floor((_stat_val * -1) / 2), 1)) {
                            _descriptive_string += "-";
                        }
                    }
                    _trait_growth_effect += $"{_stat_name} : {_descriptive_string}\n";
                }
            }
            array_push(_trait_tool_tips, [x1, y1, x2, y2, $"{_trait_description}\n{_trait_effect}\n{_trait_growth_effect}" + _trait_effect]);
        }
    } else {
        draw_set_halign(fa_right);
        draw_text(data_block.x2 - 16, _attribute_box.y2 + 16, "No Traits");
        draw_set_halign(fa_left);
    }

    for (var i = 0; i < array_length(_stat_tool_tips); i++) {
        if (scr_hit(_stat_tool_tips[i])) {
            tooltip_draw(_stat_tool_tips[i][4], 300, [_stat_tool_tips[i][0], _stat_tool_tips[i][3]],,, _stat_tool_tips[i][5]);
        }
    }
    for (var i = 0; i < array_length(_trait_tool_tips); i++) {
        if (point_in_rectangle(mouse_x, mouse_y, _trait_tool_tips[i][2], _trait_tool_tips[i][1], _trait_tool_tips[i][0], _trait_tool_tips[i][3])) {
            tooltip_draw(_trait_tool_tips[i][4], 300);
        }
    }

    draw_set_font(_cur_font);
}
