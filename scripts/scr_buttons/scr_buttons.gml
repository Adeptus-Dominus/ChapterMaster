// --------------------
// 🟦 DRAW STATE HELPERS
// --------------------

global.draw_return_stack = [];
#macro UI_CURSOR_BLINK_RATE 500

/// @function add_draw_return_values()
/// @category Draw Helpers
/// @description Saves the current draw state (alpha, font, color, halign, valign) to a global stack.
function add_draw_return_values() {
    var _vals = {
        cur_alpha: draw_get_alpha(),
        cur_font: draw_get_font(),
        cur_color: draw_get_color(),
        cur_halign: draw_get_halign(),
        cur_valign: draw_get_valign(),
    };
    array_push(global.draw_return_stack, _vals);
}

/// @function pop_draw_return_values()
/// @category Draw Helpers
/// @description Restores the most recent draw state from the global stack and removes it.
function pop_draw_return_values() {
    var _array_length = array_length(global.draw_return_stack);
    if (_array_length > 0) {
        var _index = _array_length - 1;
        var _values = global.draw_return_stack[_index];
        draw_set_alpha(_values.cur_alpha);
        draw_set_font(_values.cur_font);
        draw_set_color(_values.cur_color);
        draw_set_halign(_values.cur_halign);
        draw_set_valign(_values.cur_valign);
        array_delete(global.draw_return_stack, _index, 1);
    }
}

/// @mixin
/// @function standard_loc_data()
/// @category Draw Helpers
/// @description Acts as an initializer for UI elements positions and size
function standard_loc_data() {
    self.x1 = 0;
    self.y1 = 0;
    self.y2 = 0;
    self.x2 = 0;
    self.w = 0;
    self.h = 0;
}

/// @function draw_unit_buttons(position, text, size_mod, colour, halign, font, alpha_mult, bg, bg_color)
/// @category Draw Helpers
/// @description Draws a styled button with text, optional background and hover effects.
/// @param {Array<Real>} position Either [x, y] or [x1, y1, x2, y2].
/// @param {String} text Text to display.
/// @param {Array<Real>} size_mod Text scaling.
/// @param {Constant.Color} colour Text color.
/// @param {Constant.HAlign} _halign Text horizontal alignment.
/// @param {Asset.GMFont} font Font resource.
/// @param {Real} alpha_mult Alpha multiplier.
/// @param {Bool} bg Draw background rectangle.
/// @param {Constant.Color} bg_color Background color.
/// @returns {Array<Real>} [x1, y1, x2, y2] bounding box.
function draw_unit_buttons(position, text, size_mod = [1.5, 1.5], colour = c_gray, _halign = fa_center, font = fnt_40k_14b, alpha_mult = 1, bg = false, bg_color = c_black) {
    // TODO: fix halign usage
    add_draw_return_values();

    draw_set_font(font);
    draw_set_halign(_halign);
    draw_set_valign(fa_middle);

    var x2;
    var y2;
    var _text = string_hash_to_newline(text);
    if (array_length(position) > 2) {
        x2 = position[2];
        y2 = position[3];
    } else {
        var text_width = string_width(_text) * size_mod[0];
        var text_height = string_height(_text) * size_mod[1];
        x2 = position[0] + text_width + (6 * size_mod[0]);
        y2 = position[1] + text_height + (6 * size_mod[1]);
    }
    draw_set_alpha(1 * alpha_mult);
    if (bg) {
        draw_set_color(bg_color);
        draw_rectangle(position[0], position[1], x2, y2, 0);
    }
    draw_set_color(colour);
    draw_text_transformed((position[0] + x2) / 2, (position[1] + y2) / 2, _text, size_mod[0], size_mod[1], 0);
    draw_rectangle(position[0], position[1], x2, y2, 1);
    draw_set_alpha(0.5 * alpha_mult);
    draw_rectangle(position[0] + 1, position[1] + 1, x2 - 1, y2 - 1, 1);
    draw_set_alpha(0.25 * alpha_mult);
    var mouse_consts = return_mouse_consts();
    if (point_in_rectangle(mouse_consts[0], mouse_consts[1], position[0], position[1], x2, y2)) {
        draw_rectangle(position[0], position[1], x2, y2, 0);
    }

    pop_draw_return_values();

    return [
        position[0],
        position[1],
        x2,
        y2,
    ];
}

/// @function list_traveler(list, cur_val, move_up_coords, move_down_coords)
/// @category Draw Helpers
/// @description Cycles through values in a list by clicking move-up/down regions.
/// @param {array} list Array of values.
/// @param {any} cur_val Current value.
/// @param {array} move_up_coords Bounding box for up button.
/// @param {array} move_down_coords Bounding box for down button.
/// @returns {any} New value from list.
function list_traveler(list, cur_val, move_up_coords, move_down_coords) {
    var _new_val = cur_val;
    var _found = false;
    for (var i = 0; i < array_length(list); i++) {
        if (cur_val == list[i]) {
            _found = true;
            if (point_and_click(move_up_coords)) {
                if (i == 0) {
                    _new_val = list[array_length(list) - 1];
                } else {
                    _new_val = list[i - 1];
                }
            } else if (point_and_click(move_down_coords)) {
                if (i == array_length(list) - 1) {
                    _new_val = list[0];
                } else {
                    _new_val = list[i + 1];
                }
            }
        }
    }
    // If value not found in list, default to first element
    if (!_found && array_length(list) > 0) {
        _new_val = list[0];
    }
    return _new_val;
}

// --------------------
// 🟩 UI ELEMENTS
// --------------------

/// @function Box(data)
/// @constructor
/// @category UI
/// @description A simple drawable box
function Box(data) constructor {
    standard_loc_data();
    colour = CM_GREEN_COLOR;

    static update = function(data) {
        move_data_to_current_scope(data, true);

        if (w == 0 && x2 > 0) {
            w = x2 - x1;
        }
        if (h == 0 && y2 > 0) {
            h = y2 - y1;
        }

        y2 = y1 + h;
        x2 = x1 + w;
    };

    update(data);

    static hit = function() {
        return scr_hit(x1, y1, x2, y2);
    };

    static draw = function(outline) {
        add_draw_return_values();
        draw_set_color(colour);
        draw_rectangle(x1, y1, x2, y2, outline);
        pop_draw_return_values();
    };
}

/// @function ReactiveString(text_param, x1_param, y1_param, data)
/// @constructor
/// @category UI
/// @description Represents a reactive text element that can update, draw itself, and respond to hits.
/// @param {string} text_param The text to display.
/// @param {real} x1_param The X position.
/// @param {real} y1_param The Y position.
/// @param {struct} data Optional struct of properties to apply.
/// @example
/// var rs = new ReactiveString("Hello", 100, 200);
/// rs.draw();
function ReactiveString(text_param, x1_param = 0, y1_param = 0, data = {}) constructor {
    standard_loc_data();
    x1 = x1_param;
    y1 = y1_param;
    text = text_param;
    font = fnt_40k_14;
    add_draw_return_values();
    draw_set_font(font);
    w = string_width(text);
    h = string_height(text);
    pop_draw_return_values();
    x2 = x1 + w;
    y2 = y1 + h;
    halign = fa_left;
    valign = fa_top;
    colour = CM_GREEN_COLOR;
    tooltip = "";
    max_width = -1;
    scale = 0;
    scale_text = false;
    with_outline = true;
    allow_line_breaks = true;

    static update = function(data = {}) {
        move_data_to_current_scope(data);
        var temp_font = draw_get_font();
        draw_set_font(font);
        if (max_width > -1) {
            if (!scale_text) {
                w = string_width_ext(text, -1, max_width);
                h = string_height_ext(text, -1, max_width);
                x2 = x1 + w;
                y2 = y1 + h;
            } else {
                w = max_width;
                var _scale_edits = calc_text_scale_confines(text, max_width, 0, allow_line_breaks);
                scale = _scale_edits.scale;
                text = _scale_edits.text;
                h = string_height(text) * scale;
                x2 = x1 + w;
                y2 = y1 + h;
            }
        } else {
            w = string_width(text);
            h = string_height(text);
            x2 = x1 + w;
            y2 = y1 + h;
        }
        draw_set_font(temp_font);
    };

    update(data);

    static hit = function() {
        return scr_hit(x1, y1, x2, y2);
    };

    static draw = function() {
        add_draw_return_values();
        draw_set_font(font);
        draw_set_halign(halign);
        draw_set_valign(valign);
        draw_set_color(colour);

        if (max_width > -1) {
            if (!scale_text) {
                draw_text_ext_outline(x1, y1, text, -1, max_width, c_black, colour);
            } else {
                if (with_outline) {
                    draw_text_transformed_outline(x1, y1, text, scale, scale, 0);
                } else {
                    draw_text_transformed(x1, y1, text, scale, scale, 0);
                }
            }
        } else {
            draw_text_outline(x1, y1, text, c_black, colour);
        }
        if (hit()) {
            tooltip_draw(tooltip);
        }
        pop_draw_return_values();
    };
}

function ValueShifter(value_text, data) constructor {
    standard_loc_data();
    string_tag = value_text;
    max_clamp = 1000;
    min_clamp = -1000;
    reactive_string = new ReactiveString(value_text, 0, 0, {
        halign: fa_center,
    });

    current_value = 0;
    shift_value = 1;

    draw_set_font(fnt_40k_14b);
    var _but_width = string_height("-") + 8;

    decrease_button = new UnitButtonObject({
        label: "-",
        color: c_red,
        tooltip: "click to decrease",
        set_width: true,
        w: _but_width,
    });

    increase_button = new UnitButtonObject({
        label: "-",
        color: c_green,
        tooltip: "click to increase",
        set_width: true,
        w: _but_width,
    });

    static update = function(data = {}) {
        move_data_to_current_scope(data, true);
        reactive_string.update({x1, y1, text: $"{string_tag}:{current_value}"});

        var _react_width_diff = (reactive_string.w / 2) + 10;
        decrease_button.update({x1: x1 - _react_width_diff - decrease_button.w, y1: y1});
        increase_button.update({x1: x1 + _react_width_diff, y1: y1});
    };

    update(data);

    static draw = function() {
        update();
        reactive_string.draw();
        var _allow = current_value > min_clamp;
        if (decrease_button.draw(_allow)) {
            current_value -= shift_value;
        }

        _allow = current_value < max_clamp;
        if (increase_button.draw(_allow)) {
            current_value += shift_value;
        }
    };
}

/// @function LabeledIcon(icon, text, x1, y1, data)
/// @constructor
/// @category UI
/// @description UI element combining a sprite and text with optional tooltip.
/// @param {sprite} icon_param The sprite asset.
/// @param {string} text_param The text label.
/// @param {real} x1_param X position.
/// @param {real} y1_param Y position.
/// @param {struct} data Optional struct of properties to apply.
function LabeledIcon(icon_param, text_param, x1_param = 0, y1_param = 0, data = {}) constructor {
    x1 = x1_param;
    y1 = y1_param;

    text = text_param;
    text_max_width = -1;
    font = fnt_40k_14;
    colour = CM_GREEN_COLOR;
    text_position = "right";
    tooltip = "";
    icon = sprite_exists(icon_param) ? icon_param : spr_none;
    icon_width = sprite_get_width(icon);
    icon_height = sprite_get_height(icon);
    w = icon_width;
    h = icon_height;
    x2 = x1 + w;
    y2 = y1 + icon_height;
    temp_font = draw_get_font();
    draw_set_font(font);
    text_width = string_width(text) + 2;
    draw_set_font(temp_font);

    static update = function(data = {}) {
        move_data_to_current_scope(data);
        if (text_position == "right") {
            w = icon_width + text_width;
            h = icon_height;
            x2 = x1 + w;
            y2 = y1 + icon_height;
        } else {
            w = icon_width;
            h = icon_height;
            x2 = x1 + icon_width;
            y2 = y1 + icon_height;
        }
    };

    update(data);

    static hit = function() {
        return scr_hit(x1, y1, x2, y2);
    };

    static draw = function() {
        add_draw_return_values();
        draw_set_font(font);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(colour);
        draw_sprite_stretched(icon, 0, x1, y1, icon_width, icon_height);
        if (text_position == "right") {
            var _string_x = x1 + icon_width + 2;
            draw_text_outline(_string_x, y1 + 4, text);
            if (tooltip != "") {
                if (hit()) {
                    tooltip_draw(tooltip);
                }
            }
        }
        pop_draw_return_values();
    };
}

/// @function SpriteButton(_sprite, _hover_sprite)
/// @constructor
/// @category UI
/// @desc A clickable sprite-based button component that manages its own state and hover logic.
/// @param {Struct} data Property overrides (sprite, hover_sprite, scale_x/y, alpha_*, etc.).
/// @returns {Struct.SpriteButton}
function SpriteButton(data) constructor {
    standard_loc_data();
    sprite = spr_none;
    hover_sprite = undefined;

    cycle_index = false;
    draw_index = 0;
    width = 0;
    height = 0;
    x1 = 0;
    x2 = 0;
    y1 = 0;
    y2 = 0;
    scale_x = 1.0;
    scale_y = 1.0;
    alpha_hover = 1.0;
    alpha_idle = 0.8;
    alpha_disabled = 0.5;

    sound_click = snd_click;
    tooltip_text = "";
    tooltip_w = 300;

    is_hovered = false;
    is_clicked = false;

    static update = function(data) {
        move_data_to_current_scope(data, true);
        width = sprite_get_width(sprite);
        height = sprite_get_height(sprite);
        x2 = x1 + (width * scale_x);
        y2 = y1 + (height * scale_y);
    };

    /// @desc Updates interaction state and draws the button.
    /// @param {bool} _enabled If false, interaction is disabled and the button appears faded.
    static draw = function(_enabled = true) {
        add_draw_return_values();

        is_hovered = sr_hit_struct();
        is_clicked = _enabled && is_hovered && mouse_button_clicked();

        if (is_hovered) {
            if (tooltip_text != "") {
                tooltip_draw(tooltip_text, tooltip_w);
            }

            if (is_clicked && sound_click != undefined) {
                audio_play_sound(sound_click, 10, false);
            }
        }

        var _draw_sprite = (_enabled && is_hovered && hover_sprite != undefined) ? hover_sprite : sprite;
        var _draw_alpha = _enabled ? (is_hovered ? alpha_hover : alpha_idle) : alpha_disabled;

        draw_index = cycle_index ? draw_index + 1 : draw_index;
        draw_sprite_ext(_draw_sprite, draw_index, x1, y1, scale_x, scale_y, 0, c_white, _draw_alpha);
        pop_draw_return_values();
    };

    update(data);
}

/// @function UnitButtonObject(data)
/// @constructor
/// @category UI
/// @description Represents an interactive UI button with styles, tooltips, and binding support.
/// @param {struct} data Initial property overrides.
function UnitButtonObject(data = {}) constructor {
    standard_loc_data();
    h_gap = 4;
    v_gap = 4;
    text_scale = 1;
    label = "";
    alpha = 1;
    color = #50a076;
    inactive_col = c_gray;
    keystroke = false;
    active = true;
    tooltip = "";
    bind_method = undefined;
    bind_scope = false;
    set_width = false;
    style = "standard";
    font = fnt_40k_14b;
    set_height_width = false;

    static update_loc = function() {
        if (label != "") {
            var temp_font = draw_get_font();
            draw_set_font(font);
            if (!set_width) {
                w = string_width(label) + 10;
                h = string_height(label) + 4;
            } else {
                var _text_scale = calc_text_scale_confines(label, w, 10);

                text_scale = _text_scale.scale;

                label = _text_scale.text;
            }
            h = string_height(label) + 4;
            draw_set_font(temp_font);
        }
        x2 = x1 + w;
        y2 = y1 + h;
    };

    update_loc();

    static update = function(data = {}) {
        move_data_to_current_scope(data);
        if (struct_exists(data, "label") && !struct_exists(data, "set_width")) {
            set_width = false;
            w = 0;
        }
        if (!set_height_width) {
            update_loc();
        }
    };

    update(data);

    static move = function(m_direction, with_gap = false, multiplier = 1) {
        switch (m_direction) {
            case "right":
                x1 += (w + (with_gap * h_gap)) * multiplier;
                x2 += (w + (with_gap * h_gap)) * multiplier;
                break;
            case "left":
                x1 -= (w + (with_gap * h_gap)) * multiplier;
                x2 -= (w + (with_gap * h_gap)) * multiplier;
                break;
            case "down":
                y1 += (h + (with_gap * v_gap)) * multiplier;
                y2 += (h + (with_gap * v_gap)) * multiplier;
                break;
            case "up":
                y1 -= (h + (with_gap * v_gap)) * multiplier;
                y2 -= (h + (with_gap * v_gap)) * multiplier;
                break;
        }
    };

    disabled = false;

    static draw = function(allow_click = true) {
        add_draw_return_values();
        var _button_click_area;
        if (style == "standard") {
            var _temp_alpha = alpha;
            if (disabled) {
                _temp_alpha = 0.5;
                allow_click = false;
            }
            update_loc();
            _button_click_area = draw_unit_buttons(w > 0 ? [x1, y1, x2, y2] : [x1, y1], label, [text_scale, text_scale], active ? color : inactive_col, fa_center, font, _temp_alpha);
        } else if (style == "pixel") {
            var _widths = [
                sprite_get_width(spr_pixel_button_left),
                sprite_get_width(spr_pixel_button_middle),
                sprite_get_width(spr_pixel_button_right),
            ];

            var height_scale = h / sprite_get_height(spr_pixel_button_left);
            _widths[0] *= height_scale;
            _widths[2] *= height_scale;
            draw_sprite_ext(spr_pixel_button_left, 0, x1, y1, height_scale, height_scale, 0, c_white, 1);
            var _width_scale = (w - _widths[0] - _widths[2]) / _widths[1];
            _widths[1] *= _width_scale;
            draw_sprite_ext(spr_pixel_button_middle, 0, x1 + _widths[0], y1, _width_scale, height_scale, 0, c_white, 1);
            draw_sprite_ext(spr_pixel_button_right, allow_click, x1 + _widths[0] + _widths[1], y1, height_scale, height_scale, 0, c_white, 1);
            var _text_position_x = x1 + _widths[0] + 2;
            _text_position_x += _widths[1] / 2;
            draw_set_font(font);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_color(color);

            draw_text_transformed(_text_position_x, y1 + h / 2, label, text_scale, text_scale, 0);

            x2 = x1 + array_sum(_widths);
            y2 = y1 + h;
            _button_click_area = [
                x1,
                y1,
                x2,
                y2,
            ];
        }

        if (scr_hit(x1, y1, x2, y2) && tooltip != "") {
            tooltip_draw(tooltip);
        }

        if (allow_click && active) {
            var clicked = point_and_click(_button_click_area) || keystroke;
            if (clicked) {
                if (is_callable(bind_method)) {
                    if (bind_scope != false) {
                        var _method = bind_method;
                        with (bind_scope) {
                            _method();
                        }
                    } else {
                        bind_method();
                    }
                }
            }
            pop_draw_return_values();
            return clicked;
        } else {
            pop_draw_return_values();
            return false;
        }
    };
}

/// @function PurchaseButton(req)
/// @constructor
/// @category UI
/// @description Specialized UnitButtonObject requiring requisition points to click.
/// @param {real} req Required requisition cost.
/// @returns {bool}
function PurchaseButton(req) : UnitButtonObject() constructor {
    req_value = req;

    static draw = function(allow_click = true) {
        add_draw_return_values();
        var _but = draw_unit_buttons([x1, y1, x2, y2], label, [1, 1], color,,, alpha);
        var _sh = sprite_get_height(spr_requisition);
        var _scale = (y2 - y1) / _sh;
        draw_sprite_ext(spr_requisition, 0, x1, y2, _scale, _scale, 0, c_white, 1);
        var _allow_click = obj_controller.requisition >= req_value;
        if (scr_hit(x1, y1, x2, y2) && tooltip != "") {
            tooltip_draw(tooltip);
        }
        if (active && allow_click && _allow_click) {
            var clicked = point_and_click(_but) || keystroke;
            if (clicked) {
                if (is_callable(bind_method)) {
                    bind_method();
                }
                obj_controller.requisition -= req_value;
            }
            pop_draw_return_values();
            return clicked;
        } else {
            pop_draw_return_values();
            return false;
        }
    };
}

/// @function SliderBar(_x, _y, _w, _h, _limits, _inc)
/// @description A functional slider bar for numerical input.
/// @param {real} _x Starting X position.
/// @param {real} _y Starting Y position.
/// @param {real} _w Width of the bar.
/// @param {real} _h Height of the bar.
/// @param {array<real>} _limits Array [min, max].
/// @param {real} _inc Increment step value.
function SliderBar(_x, _y, _w = 100, _h = 16, _limits = [0, 100], _inc = 1) constructor {
    xx = _x;
    yy = _y;
    width = _w;
    height = _h;
    value_limits = _limits;
    value_increments = _inc;
    value = _limits[0];

    dragging = false;

    static update = function(data) {
        move_data_to_current_scope(data);
    };

    static draw = function() {
        add_draw_return_values();

        var _mouse_vars = return_mouse_consts();
        var _mx = _mouse_vars[0];
        var _my = _mouse_vars[1];
        var _rect = [
            xx,
            yy,
            xx + width,
            yy + height,
        ];

        if (point_and_click([_rect[0], _rect[1], _rect[2], _rect[3]])) {
            dragging = true;
        }

        if (dragging) {
            if (!mouse_button_held(mb_left)) {
                dragging = false;
            } else {
                var _rel_x = clamp(_mx - xx, 0, width);
                var _percentage = _rel_x / width;
                var _total_range = value_limits[1] - value_limits[0];

                var _raw_val = value_limits[0] + (_percentage * _total_range);
                value = round(_raw_val / value_increments) * value_increments;
            }
        }

        value = clamp(value, value_limits[0], value_limits[1]);

        draw_set_alpha(1.0);
        draw_set_color(c_dkgray);
        draw_rectangle_array(_rect, true);

        var _knob_pos = ((value - value_limits[0]) / (value_limits[1] - value_limits[0])) * width;
        draw_set_color(dragging ? c_white : c_gray);
        draw_rectangle(xx, yy, xx + _knob_pos, yy + height, false);

        pop_draw_return_values();
    };
}

/// @function TextBarArea(_x, _y, _max_width, _requires_input)
/// @constructor
/// @category UI
/// @description Input text area with background and cursor handling.
/// @param {real} _x X position.
/// @param {real} _y Y position.
/// @param {real} _max_width Max width of text bar.
/// @param {bool} _requires_input If true, input is required.
function TextBarArea(_x, _y, _max_width = 400, _requires_input = false) constructor {
    xx = _x;
    yy = _y;
    max_width = _max_width;
    requires_input = _requires_input;

    allow_input = false;
    cooloff = 0;
    current_text = "";

    background = new DataSlate();
    background.draw_top_piece = false;

    static render_logic = function() {
        add_draw_return_values();

        draw_set_valign(fa_middle);
        draw_set_halign(fa_center);
        draw_set_alpha(1);
        draw_set_font(fnt_fancy);

        var _display_string = $"{current_text}";
        var _text_w = string_width(_display_string);
        var _center_y = background.YY + (background.height / 2);

        draw_text(xx, _center_y, _display_string);

        if (allow_input) {
            obj_cursor.image_index = 2;

            var _is_blink_on = (current_time div UI_CURSOR_BLINK_RATE) % 2 == 0;
            if (_is_blink_on) {
                var _cursor_x = xx + (_text_w / 2);

                draw_text(_cursor_x, _center_y, "|");
            }
        }

        pop_draw_return_values();
    };

    render_content = method(self, render_logic);

    static draw = function(_string_area) {
        add_draw_return_values();

        draw_set_font(fnt_fancy);

        current_text = _string_area;

        if (cooloff > 0) {
            cooloff--;
        }

        if (allow_input) {
            current_text = keyboard_string;
        }

        var _cursor_padding = string_width("|");
        var _bar_wid = max_width;
        var _string_h = string_height("M");

        if (current_text != "") {
            _bar_wid = max(max_width, string_width($"' {current_text} '") + _cursor_padding + 20);
            draw_set_color(c_gray);
        } else {
            draw_set_color(requires_input ? CM_RED_COLOR : CM_GREEN_COLOR);
        }

        var _x1 = xx - (_bar_wid / 2);
        var _y1 = yy;
        var _x2 = xx + (_bar_wid / 2);
        var _y2 = yy + _string_h;

        var _mouse_hover = scr_hit(_x1, _y1, _x2, _y2);
        var _mouse_click = mouse_button_clicked(, 0, true);
        var _enter_pressed = press_exclusive(vk_enter);

        if (cooloff == 0) {
            // Deactivate on Enter or Clicking Away
            if (allow_input && (_enter_pressed || (_mouse_click && !_mouse_hover))) {
                allow_input = false;
                cooloff = 5;
            } else if (!allow_input && _mouse_click && _mouse_hover) {
                // Activate on Clicking Inside
                allow_input = true;
                keyboard_string = current_text;
                cooloff = 5;
            }
        }

        if (_mouse_hover || allow_input) {
            obj_cursor.image_index = 2;
        } else {
            obj_cursor.image_index = 0;
        }

        background.XX = _x1;
        background.YY = _y1;
        background.width = _x2 - _x1;
        background.height = _y2 - _y1;
        background.inside_method = render_content;

        background.draw_with_dimensions();

        pop_draw_return_values();

        return current_text;
    };
}

/// @function UIDropdown(_options, _width, _on_change)
/// @constructor
/// @category UI
/// @desc A modular UI dropdown component for selecting options from a list.
/// @param {Array<Struct>} _options Array of {label, value} structs.
/// @param {real} _width Width of the dropdown.
/// @param {Function} _on_change Optional callback invoked with the new value on selection change.
function UIDropdown(_options, _width = 180, _on_change = undefined) constructor {
    options = _options;
    width = _width;
    height = 28;
    is_open = false;
    selected_index = 0;
    on_change = _on_change;

    /// @desc Sets the dropdown to a specific value.
    /// @param {any} _value The value to search for.
    /// @returns {bool}
    static set_value = function(_value) {
        for (var i = 0, l = array_length(options); i < l; i++) {
            if (options[i].value != _value) {
                continue;
            }

            selected_index = i;
            return true;
        }

        return false;
    };

    /// @desc Gets the currently selected value.
    /// @returns {any}
    static get_value = function() {
        return options[selected_index].value;
    };

    /// @desc Draws the dropdown and handles interactions.
    /// @param {real} _x X position.
    /// @param {real} _y Y position.
    /// @returns {any} The value of the selected option if changed, otherwise undefined.
    static draw = function(_x, _y) {
        var _result = undefined;
        var _main_rect = [
            _x,
            _y,
            _x + width,
            _y + height,
        ];
        var _is_hovering_main = scr_hit(_main_rect[0], _main_rect[1], _main_rect[2], _main_rect[3]);

        add_draw_return_values();

        // Draw Main Box
        draw_set_color(c_black);
        draw_rectangle_array(_main_rect, false);
        draw_set_color(_is_hovering_main ? c_white : c_gray);
        draw_rectangle_array(_main_rect, true);

        // Draw Current Selection
        draw_set_font(fnt_40k_14b);
        draw_set_halign(fa_left);
        draw_text(_x + 8, _y + 6, options[selected_index].label);

        // Draw Arrow
        var _arrow_char = is_open ? "▲" : "▼";
        draw_text(_x + width - 20, _y + 6, _arrow_char);

        if (_is_hovering_main && mouse_button_clicked()) {
            is_open = !is_open;
            audio_play_sound(snd_click, 10, false);
        }

        if (!is_open) {
            pop_draw_return_values();
            return _result;
        }

        _result = _draw_options_list(_x, _y);

        // Close if clicking outside
        if (mouse_button_clicked() && !_is_hovering_main) {
            is_open = false;
        }

        pop_draw_return_values();
        return _result;
    };

    /// @desc Internal method to draw the expanded list.
    /// @param {real} _x
    /// @param {real} _y
    /// @returns {any}
    static _draw_options_list = function(_x, _y) {
        var _selection = undefined;
        var _opt_height = 24;
        var _total_h = array_length(options) * _opt_height;
        var _list_rect = [
            _x,
            _y + height,
            _x + width,
            _y + height + _total_h,
        ];

        add_draw_return_values();

        draw_set_alpha(0.95);
        draw_set_color(c_black);
        draw_rectangle_array(_list_rect, false);
        draw_set_alpha(1.0);
        draw_set_color(c_white);
        draw_rectangle_array(_list_rect, true);

        for (var i = 0, l = array_length(options); i < l; i++) {
            var _oy = _y + height + (i * _opt_height);
            var _is_hovering = scr_hit(_x, _oy, _x + width, _oy + _opt_height);

            if (_is_hovering) {
                draw_set_alpha(0.2);
                draw_rectangle(_x + 1, _oy, _x + width - 1, _oy + _opt_height, false);
                draw_set_alpha(1.0);

                if (mouse_button_clicked()) {
                    selected_index = i;
                    is_open = false;
                    _selection = options[i].value;
                    audio_play_sound(snd_click, 10, false);

                    if (is_callable(on_change)) {
                        on_change(_selection);
                    }
                }
            }

            draw_set_color(_is_hovering ? c_white : c_gray);
            draw_set_font(fnt_40k_12);
            draw_text(_x + 10, _oy + 4, options[i].label);
        }

        pop_draw_return_values();
        return _selection;
    };
}

/// @function MultiSelect(options_array, title_param, data)
/// @constructor
/// @category UI
/// @description Multi-option toggle group allowing multiple selections.
/// @param {array} options_array Array of option labels.
/// @param {string} title_param Title string.
/// @param {struct} data Optional overrides.
function MultiSelect(options_array, title_param, data = {}) constructor {
    title = title_param;
    x_gap = 10;
    y_gap = 5;
    standard_loc_data();
    on_change = undefined;
    active_col = CM_GREEN_COLOR;
    inactive_col = c_gray;
    max_width = 0;
    max_height = 0;
    /// @type {Array<Struct.ToggleButton>}
    toggles = [];
    changed = false;
    is_horizontal = true; // If more than 2 types needed, convert to an enum
    allow_changes = true;

    for (var i = 0; i < array_length(options_array); i++) {
        var _next_tog = new ToggleButton(options_array[i]);
        _next_tog.active = false;
        array_push(toggles, _next_tog);
    }

    update(data);

    static update = function(data = {}) {
        move_data_to_current_scope(data);
    };

    static draw = function(allow_changes_param = true) {
        changed = false;
        allow_changes = allow_changes_param;
        var _has_change_method = is_callable(on_change);

        var _start_y = y1;
        if (title != "") {
            draw_text(x1, y1, title);
            _start_y += string_height(title) + 10;
        }

        var _count = array_length(toggles);

        var _max_main = is_horizontal ? max_width : max_height;
        var _main_gap = is_horizontal ? x_gap : y_gap;
        var _cross_gap = is_horizontal ? y_gap : x_gap;
        var _start_main = is_horizontal ? x1 : _start_y;

        var _lines = [];
        var _current_line = [];
        var _cur_main = _start_main;
        var _line_max_cross = 0;

        // Pass 1: Pack items into lines (rows or columns) based on orientation boundaries
        for (var i = 0; i < _count; i++) {
            var _cur_opt = toggles[i];
            _cur_opt.update();

            var _opt_main = is_horizontal ? _cur_opt.w : _cur_opt.h;
            var _opt_cross = is_horizontal ? _cur_opt.h : _cur_opt.w;

            if (_max_main > 0 && (_cur_main + _opt_main - _start_main) > _max_main && array_length(_current_line) > 0) {
                array_push(_lines, {toggles: _current_line, max_c: _line_max_cross});
                _current_line = [];
                _line_max_cross = 0;
                _cur_main = _start_main;
            }

            array_push(_current_line, _cur_opt);
            if (_opt_cross > _line_max_cross) {
                _line_max_cross = _opt_cross;
            }

            _cur_main += _opt_main + _main_gap;
        }

        if (array_length(_current_line) > 0) {
            array_push(_lines, {toggles: _current_line, max_c: _line_max_cross});
        }

        // Pass 2: Position, calculate boundaries, evaluate input, and draw
        var _cur_cross = is_horizontal ? _start_y : x1;
        var _total_max_main = _start_main;
        var _lines_count = array_length(_lines);

        for (var l = 0; l < _lines_count; l++) {
            var _line = _lines[l];
            _cur_main = _start_main;
            var _line_toggles_count = array_length(_line.toggles);

            for (var t = 0; t < _line_toggles_count; t++) {
                var _cur_opt = _line.toggles[t];
                var _orig_w = _cur_opt.w;

                if (is_horizontal) {
                    _cur_opt.x1 = _cur_main;
                    _cur_opt.y1 = _cur_cross;
                    _cur_opt.x2 = _cur_main + _cur_opt.w;
                    _cur_opt.y2 = _cur_cross + _cur_opt.h;
                    if (_cur_opt.x2 > _total_max_main) {
                        _total_max_main = _cur_opt.x2;
                    }

                    _cur_main += _cur_opt.w + x_gap;
                } else {
                    _cur_opt.x1 = _cur_cross;
                    _cur_opt.y1 = _cur_main;
                    _cur_opt.w = _line.max_c;
                    _cur_opt.x2 = _cur_cross + _cur_opt.w;
                    _cur_opt.y2 = _cur_main + _cur_opt.h;
                    if (_cur_opt.y2 > _total_max_main) {
                        _total_max_main = _cur_opt.y2;
                    }

                    _cur_main += _cur_opt.h + y_gap;
                }

                if (_cur_opt.clicked() && allow_changes) {
                    changed = true;
                }

                _cur_opt.button_color = _cur_opt.active ? active_col : inactive_col;
                _cur_opt.draw();
                _cur_opt.w = _orig_w;
            }

            _cur_cross += _line.max_c + _cross_gap;
        }

        if (is_horizontal) {
            x2 = _total_max_main;
            y2 = _cur_cross - y_gap;
        } else {
            x2 = _cur_cross - x_gap;
            y2 = _total_max_main;
        }

        if (changed && _has_change_method) {
            on_change();
        }
    };

    static set = function(set_array) {
        for (var s = 0; s < array_length(set_array); s++) {
            var _setter = set_array[s];
            for (var i = 0; i < array_length(toggles); i++) {
                var _cur_opt = toggles[i];
                _cur_opt.active = _cur_opt.str1 == _setter;
            }
        }
    };

    static deselect_all = function() {
        for (var i = 0; i < array_length(toggles); i++) {
            toggles[i].active = false;
        }
    };

    static select_all = function() {
        var _all_selected = true;
        var _count = array_length(toggles);

        for (var i = 0; i < _count; i++) {
            if (!toggles[i].active) {
                _all_selected = false;
                break;
            }
        }

        for (var i = 0; i < _count; i++) {
            toggles[i].active = !_all_selected;
        }

        changed = true;
    };

    static selections = function() {
        var _selecs = [];
        for (var i = 0; i < array_length(toggles); i++) {
            var _cur_opt = toggles[i];
            if (_cur_opt.active) {
                array_push(_selecs, _cur_opt.str1);
            }
        }

        return _selecs;
    };
}

/// @function RadioSet(options_array, title_param, data)
/// @constructor
/// @category UI
/// @description Radio button group allowing only one active selection.
/// @param {array} options_array List of option labels.
/// @param {string} title_param Title string.
/// @param {struct} data Optional overrides.
function RadioSet(options_array, title_param = "", data = {}) constructor {
    toggles = [];
    standard_loc_data();
    current_selection = 0;
    title = title_param;
    active_col = CM_GREEN_COLOR;
    inactive_col = c_gray;
    allow_changes = true;
    x_gap = 10;
    y_gap = 5;
    title_font = fnt_40k_14b;
    draw_title = true;
    if (title == "") {
        draw_title = false;
    }
    space_evenly = false;
    changed = false;
    x1 = 0;
    y1 = 0;
    max_width = 0; // container width; if 0, use row's natural width
    max_height = 0;
    center = false; // when true, center each row horizontally in container

    for (var i = 0; i < array_length(options_array); i++) {
        array_push(toggles, new ToggleButton(options_array[i]));
    }

    static update = function(data = {}) {
        move_data_to_current_scope(data);
    };

    update(data);

    static draw_option = function(_x, _y, index) {
        var _cur_opt = toggles[index];
        _cur_opt.x1 = _x;
        _cur_opt.y1 = _y;
        _cur_opt.update();
        _cur_opt.active = index == current_selection;
        _cur_opt.button_color = _cur_opt.active ? active_col : inactive_col;
        return _cur_opt;
    };

    static draw = function() {
        add_draw_return_values();

        draw_set_valign(fa_top);
        draw_set_color(active_col);
        draw_set_font(title_font);
        draw_set_alpha(1);

        var title_h = 0;
        if (draw_title) {
            if (max_width > 0) {
                draw_set_halign(fa_center);
                draw_text(x1 + max_width * 0.5, y1, title);
            } else {
                draw_set_halign(fa_left);
                draw_text(x1, y1, title);
            }
            title_h = string_height(title) + 10;
        }

        changed = false;
        var _start_current_selection = current_selection;

        var _prev_x = x1;
        var _prev_y = y1 + title_h;

        var row_items = []; // holds structs: { btn: <ToggleButton>, idx: <int> }
        var row_width = 0;
        var row_height = 0;

        for (var i = 0; i < array_length(toggles); i++) {
            var _cur_opt = draw_option(_prev_x, _prev_y, i);

            _prev_x = _cur_opt.x2 + x_gap;
            row_width = _prev_x - x1;
            row_height = max(row_height, _cur_opt.h);

            var row_full = (max_width > 0) && (row_width > max_width);
            var last_item = i == array_length(toggles) - 1;

            array_push(row_items, {btn: _cur_opt, idx: i});

            if (row_full || last_item) {
                // Calculate final row width and optional centering offset
                var _first_btn = row_items[0].btn;
                var _last_btn = row_items[array_length(row_items) - 1].btn;

                var _total_row_width = _last_btn.x2 - _first_btn.x1;
                var _container_width = (max_width > 0) ? max_width : _total_row_width;
                var _offset_x = center ? (_container_width - _total_row_width) * 0.5 : 0;

                // Draw row items at their final positions
                for (var j = 0; j < array_length(row_items); j++) {
                    var btn = row_items[j].btn;
                    var idx = row_items[j].idx;
                    btn.x1 += _offset_x; // shift to center
                    btn.update();
                    btn.draw();
                    if (allow_changes && btn.clicked() && idx != current_selection) {
                        current_selection = idx; // <-- no array_index_of needed
                    }
                }

                // Advance to next row
                var row_right_edge = x1 + max(_container_width, _total_row_width);
                x2 = max(x2, row_right_edge);
                _prev_x = x1;
                _prev_y += row_height + y_gap;
                y2 = _prev_y;

                // Reset accumulators
                row_items = [];
                row_width = 0;
                row_height = 0;
            }
        }

        if (_start_current_selection != current_selection) {
            changed = true;
        }
        pop_draw_return_values();
    };

    static selection_val = function(value) {
        if (current_selection == -1) {
            return noone;
        }
        return toggles[current_selection][$ value];
    };
}

/// @function ToggleButton(data)
/// @constructor
/// @category UI
/// @description A toggleable button element with hover and active states.
/// @param {struct} data Initial properties.
function ToggleButton(data = {}) constructor {
    standard_loc_data();
    tooltip = "";
    str1 = "";
    w = 0;
    h = 0;
    text_padding = 0.03;
    state_alpha = 1;
    hover_alpha = 1;
    active = true;
    text_halign = fa_left;
    text_color = c_gray;
    button_color = c_gray;
    font = fnt_40k_12;
    style = "default";
    hover_func = undefined;

    //make true to run clicked() within draw sequence
    clicked_check_default = false;

    static update = function(data = {}) {
        move_data_to_current_scope(data);
        var temp_font = draw_get_font();
        draw_set_font(font);
        if (style == "default") {
            if (w == 0) {
                w = string_width(str1);
                w *= 1 + (text_padding * 2);
            }
            if (h == 0) {
                h = string_height(str1);
                h *= 1 + (text_padding * 2);
            }
        } else if (style == "box") {
            var _text_w = string_width(str1) * (1 + (text_padding * 2));
            w = max(32, _text_w) + 12;
            h = 32 + 4 + (string_height(str1) * (1 + (text_padding * 2)));
        }
        x2 = x1 + w;
        y2 = y1 + h;
        draw_set_font(temp_font);
    };

    update(data);

    static hover = function() {
        return scr_hit(x1, y1, x2, y2);
    };

    static clicked = function() {
        if (hover() && mouse_button_clicked()) {
            active = !active;
            audio_play_sound(snd_click_small, 10, false);
            return true;
        } else {
            return false;
        }
    };

    static draw = function(is_active = undefined) {
        if (is_active != undefined) {
            self.active = is_active;
        }
        add_draw_return_values();
        draw_set_font(font);
        var str1_h = string_height(str1);
        var _text_padding = w * 0.03;
        var text_x = x1 + _text_padding;
        var text_y = y1 + _text_padding;
        var total_alpha;

        if (text_halign == fa_center) {
            text_x = x1 + (w / 2);
        }

        if (!active) {
            if (state_alpha > 0.5) {
                state_alpha -= 0.05;
            }
        } else {
            if (state_alpha < 1) {
                state_alpha += 0.05;
            }
            if (hover()) {
                if (hover_alpha > 0.8) {
                    hover_alpha -= 0.02;
                } // Decrease state_alpha when hovered
            } else {
                if (hover_alpha < 1) {
                    hover_alpha += 0.03;
                } // Increase state_alpha when not hovered
            }
        }

        if (hover()) {
            if (tooltip != "") {
                tooltip_draw(tooltip);
            }
            if (is_callable(hover_func)) {
                hover_func();
            }
        }

        total_alpha = state_alpha * hover_alpha;

        if (style == "default") {
            draw_rectangle_color_simple(x1, y1, x1 + w, y1 + h, 1, button_color, total_alpha);
            draw_set_halign(text_halign);
            draw_set_valign(fa_middle);
            var text_y = y1 + (h / 2);
            draw_text_color_simple(text_x, text_y, str1, text_color, total_alpha);
            draw_set_alpha(1);
            draw_set_halign(fa_left);
        } else if (style == "box") {
            var _center_x = x1 + (w / 2);
            var _sprite_x = _center_x - 16;

            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
            draw_sprite_ext(spr_creation_check, active, _sprite_x, y1, 1, 1, 0, c_white, total_alpha);

            draw_set_alpha(total_alpha);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);

            var _label_y = y1 + 32 + ((h - 32) / 2);
            draw_text_transformed(_center_x, _label_y, str1, 1, 1, 0);
            draw_set_alpha(1);
        }

        pop_draw_return_values();
        if (clicked_check_default) {
            return clicked();
        }
    };
}

/// @function InteractiveButton(data)
/// @constructor
/// @category UI
/// @description A button with separate active/inactive tooltips and click sounds.
/// @param {struct} data Initial properties.
function InteractiveButton(data = {}) constructor {
    x1 = 0;
    y1 = 0;
    x2 = 0;
    y2 = 0;
    str1 = "";
    inactive_tooltip = "";
    tooltip = "";
    width = 0;
    height = 0;
    state_alpha = 1;
    hover_alpha = 1;
    active = true;
    text_halign = fa_left;
    text_color = c_gray;
    button_color = c_gray;

    static update = function(data = {}) {
        move_data_to_current_scope(data);
        if (struct_exists(data, "str1") && !struct_exists(data, "width")) {
            width = 0;
        }
        if (width == 0) {
            width = string_width(str1) + 4;
        }
        if (!struct_exists(data, "height")) {
            height = string_height(str1) + 4;
        }
        x2 = x1 + width;
        y2 = y1 + height;
    };

    update(data);

    static hover = function() {
        return scr_hit(x1, y1, x2, y2);
    };

    static clicked = function() {
        if (hover() && mouse_button_clicked()) {
            if (!active) {
                audio_play_sound(snd_error, 10, false);
                return false;
            } else {
                audio_play_sound(snd_click_small, 10, false);
                return true;
            }
        } else {
            return false;
        }
    };

    static draw = function() {
        var str1_h = string_height(str1);
        var text_padding = width * 0.03;
        var text_x = x1 + text_padding;
        var text_y = y1 + text_padding;
        var total_alpha;

        add_draw_return_values();

        if (text_halign == fa_center) {
            text_x = x1 + (width / 2);
        }

        if (!active) {
            if (state_alpha > 0.5) {
                state_alpha -= 0.05;
            }
            if (inactive_tooltip != "" && hover()) {
                tooltip_draw(inactive_tooltip);
            }
        } else {
            if (state_alpha < 1) {
                state_alpha += 0.05;
            }
            if (hover()) {
                if (hover_alpha > 0.8) {
                    hover_alpha -= 0.02;
                } // Decrease state_alpha when hovered
                if (tooltip != "") {
                    tooltip_draw(tooltip);
                }
            } else {
                if (hover_alpha < 1) {
                    hover_alpha += 0.03;
                } // Increase state_alpha when not hovered
            }
        }

        total_alpha = state_alpha * hover_alpha;
        draw_rectangle_color_simple(x1, y1, x1 + width, y1 + height, 1, button_color, total_alpha);
        draw_set_halign(text_halign);
        draw_set_valign(fa_top);
        draw_text_color_simple(text_x, text_y, str1, text_color, total_alpha);

        pop_draw_return_values();
    };
}

/// @function MainMenuButton(_sprite, _sprite_hover, _x, _y, _hot_key, _on_click)
/// @constructor
/// @category UI
/// @description A UI button component featuring hover animations, oscillation effects, and Alt-key shortcut support.
/// @param {Asset.GMSprite} _sprite The base sprite index for the button.
/// @param {Asset.GMSprite} _sprite_hover The additive blend sprite used for hover effects.
/// @param {real} _x The default X coordinate for the button.
/// @param {real} _y The default Y coordinate for the button.
/// @param {Constant.VirtualKey} _hot_key The keyboard constant used for Alt + Key activation.
/// @param {function} _on_click The callback function to execute upon activation.
function MainMenuButton(_sprite = spr_ui_but_1, _sprite_hover = spr_ui_hov_1, _x = 0, _y = 0, _hot_key = -1, _on_click = undefined) constructor {
    base_sprite = _sprite;
    hover_sprite = _sprite_hover;
    xx = _x;
    yy = _y;
    hot_key = _hot_key;
    on_click = _on_click;

    oscillate = 24.0;
    oscillate_down = true;
    hover_alpha = 0.0;
    is_clicked = false;

    static draw = function(_x = xx, _y = yy, _text = "", _x_scale = 1.0, _y_scale = 1.0, _w = 108, _h = 42) {
        add_draw_return_values();

        var _final_w = _w * _x_scale;
        var _final_h = _h * _y_scale;
        var _is_hovering = scr_hit(_x, _y, _x + _final_w, _y + _final_h);

        is_clicked = false;

        if (_is_hovering) {
            oscillate = max(0, oscillate - 1.0);
            hover_alpha = min(1.0, hover_alpha + 0.42);

            gpu_set_blendmode(bm_add);
            draw_set_alpha(hover_alpha);
            draw_sprite_ext(hover_sprite, 0, _x, _y, _x_scale, _y_scale, 0, c_white, hover_alpha);
            gpu_set_blendmode(bm_normal);

            oscillate_down = true;
            is_clicked = mouse_button_clicked(, 0, true);
        } else {
            if (oscillate_down) {
                oscillate += 0.2;
                if (oscillate >= 24) {
                    oscillate_down = false;
                }
            } else {
                oscillate -= 0.2;
                if (oscillate <= 8) {
                    oscillate_down = true;
                }
            }

            if (hover_alpha > 0) {
                hover_alpha -= 0.04;
                gpu_set_blendmode(bm_add);
                draw_set_alpha(hover_alpha);
                draw_sprite_ext(hover_sprite, 0, _x, _y, _x_scale, _y_scale, 0, c_white, hover_alpha);
                gpu_set_blendmode(bm_normal);
            }
        }

        if (hot_key != -1 && !is_clicked) {
            if (press_with_held(hot_key, vk_alt)) {
                is_clicked = true;
            }
        }

        draw_set_alpha(1.0);
        draw_sprite_ext(base_sprite, floor(oscillate), _x, _y, _x_scale, _y_scale, 0, c_white, 1.0);

        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_top);
        draw_set_font(fnt_cul_14);

        var _text_x = _x + (_final_w / 2);
        var _text_y = _y + (4 * _y_scale);
        var _sep = 18 * _y_scale;
        var _line_w = _final_w - (15 * _x_scale);

        draw_text_ext(_text_x, _text_y, _text, _sep, _line_w);

        if (is_clicked && is_callable(on_click)) {
            on_click();
        }

        pop_draw_return_values();
        return is_clicked;
    };
}
