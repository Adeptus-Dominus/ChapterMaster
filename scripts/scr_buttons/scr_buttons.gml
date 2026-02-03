// --------------------
// 🟦 DRAW STATE HELPERS
// --------------------

global.draw_return_stack = [];
#macro UI_CURSOR_BLINK_RATE 500

/// @function add_draw_return_values()
/// @description Saves the current draw state (alpha, font, color, halign, valign) to a global stack.
/// @returns {undefined}
/// @category Draw Helpers
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
/// @description Restores the most recent draw state from the global stack and removes it.
/// @returns {undefined}
/// @category Draw Helpers
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

// --------------------
// 🟩 UI ELEMENTS
// --------------------

/// @function ReactiveString(text, x1, y1, data)
/// @constructor
/// @category UI
/// @description Represents a reactive text element that can update, draw itself, and respond to hits.
/// @param {string} text The text to display.
/// @param {real} [x1=0] The X position.
/// @param {real} [y1=0] The Y position.
/// @param {struct|bool} [data=false] Optional struct of properties to apply.
/// @returns {ReactiveString}
///
/// @example
/// var rs = new ReactiveString("Hello", 100, 200);
/// rs.draw();
function ReactiveString(text, x1 = 0, y1 = 0, data = false) constructor {
    self.x1 = x1;
    self.y1 = y1;
    x2 = 0;
    y2 = 0;
    halign = fa_left;
    valign = fa_top;

    self.text = text;
    text_max_width = -1;
    font = fnt_40k_14;
    colour = CM_GREEN_COLOR;
    tooltip = "";
    max_width = -1;
    h = 0;
    w = 0;
    scale_text = false;

    move_data_to_current_scope(data);

    static update = function(data = {}) {
        move_data_to_current_scope(data);
        add_draw_return_values();
        draw_set_font(font);
        draw_set_halign(halign);
        draw_set_valign(valign);

        if (max_width > -1) {
            if (!scale_text) {
                w = string_width_ext(text, -1, max_width);
                h = string_height_ext(text, -1, max_width);
                x2 = x1 + w;
                y2 = y1 + h;
            } else {
                w = max_width;
                scale = calc_text_scale_confines(text, max_width);
                h = string_height(text) * scale;
            }
        } else {
            w = string_width(text);
        }

        pop_draw_return_values();
    };

    update();

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
                draw_text_transformed(x1, y1, text, scale, scale, 0);
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

/// @function LabeledIcon(icon, text, x1, y1, data)
/// @constructor
/// @category UI
/// @description UI element combining a sprite and text with optional tooltip.
/// @param {sprite} icon The sprite asset.
/// @param {string} text The text label.
/// @param {real} [x1=0] X position.
/// @param {real} [y1=0] Y position.
/// @param {struct|bool} [data=false] Optional struct of properties to apply.
/// @returns {LabeledIcon}
function LabeledIcon(icon, text, x1 = 0, y1 = 0, data = false) constructor {
    self.x1 = x1;
    self.y1 = y1;
    x2 = 0;
    y2 = 0;

    self.text = text;
    text_max_width = -1;
    font = fnt_40k_14;
    colour = CM_GREEN_COLOR;
    text_position = "right";
    tooltip = "";
    self.icon = sprite_exists(icon) ? icon : spr_none;
    icon_width = sprite_get_width(self.icon);
    icon_height = sprite_get_height(self.icon);
    w = icon_width;
    h = icon_height;

    move_data_to_current_scope(data);

    static update = function(data = {}) {
        move_data_to_current_scope(data);
        add_draw_return_values();
        draw_set_font(font);
        if (text_position == "right") {
            w = icon_width + 2 + string_width(text);
            x2 = x1 + w;
            h = icon_height;
            y2 = y1 + icon_height;
        }
        pop_draw_return_values();
    };

    update();

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

/// @function draw_sprite_as_button(position, choice_sprite, scale, hover_sprite)
/// @description Draws a sprite as a clickable button, returning its bounding box.
/// @param {array} position [x, y] top-left corner.
/// @param {sprite} choice_sprite Sprite to draw.
/// @param {array} [scale=[1,1]] Scale factors [x,y].
/// @param {sprite} [hover_sprite=-1] Optional hover sprite.
/// @returns {struct} [x1, y1, x2, y2] bounding box.
function draw_sprite_as_button(position, choice_sprite, scale = [1, 1], hover_sprite = -1, alpha = 1, inactive_alpha = 0.9) {
    var _pos = [
        position[0],
        position[1],
        position[0] + (sprite_get_width(choice_sprite) * scale[0]),
        position[1] + (sprite_get_height(choice_sprite) * scale[1])
    ];

    var _hovered = scr_hit(_pos);
    var _clicked = false;

    if (_hovered) {
        _clicked = scr_click_left();
    }

    draw_sprite_ext(choice_sprite, 0, position[0], position[1], scale[0], scale[1], 0, c_white, _hovered ? alpha : min(alpha, inactive_alpha));

    return {position: _pos, hovered: _hovered, clicked: _clicked};
}

/// @function draw_unit_buttons(position, text, size_mod, colour, halign, font, alpha_mult, bg, bg_color)
/// @description Draws a styled button with text, optional background and hover effects.
/// @param {array} position Either [x, y] or [x1, y1, x2, y2].
/// @param {string} text Text to display.
/// @param {array} [size_mod=[1.5,1.5]] Text scaling.
/// @param {color} [colour=c_gray] Text color.
/// @param {real} [_halign=fa_center] Text horizontal alignment.
/// @param {font} [font=fnt_40k_14b] Font resource.
/// @param {real} [alpha_mult=1] Alpha multiplier.
/// @param {bool} [bg=false] Draw background rectangle.
/// @param {color} [bg_color=c_black] Background color.
/// @returns {array} [x1, y1, x2, y2] bounding box.
function draw_unit_buttons(position, text, size_mod = [1.5, 1.5], colour = c_gray, _halign = fa_center, font = fnt_40k_14b, alpha_mult = 1, bg = false, bg_color = c_black) {
    // TODO: fix halign usage
    // Store current state of all global vars
    add_draw_return_values();

    draw_set_font(font);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    var x2;
    var y2;
    var _text = string_hash_to_newline(text);
    if (array_length(position) > 2) {
        var x2 = position[2];
        var y2 = position[3];
    } else {
        var text_width = string_width(_text) * size_mod[0];
        var text_height = string_height(_text) * size_mod[1];
        var x2 = position[0] + text_width + (6 * size_mod[0]);
        var y2 = position[1] + text_height + (6 * size_mod[1]);
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

    // Reset all global vars to their previous state
    pop_draw_return_values();

    return [position[0], position[1], x2, y2];
}

function standard_loc_data() {
    x1 = 0;
    y1 = 0;
    y2 = 0;
    x2 = 0;
    w = 0;
    h = 0;
}

/// @function UnitButtonObject(data)
/// @constructor
/// @category UI
/// @description Represents an interactive UI button with styles, tooltips, and binding support.
/// @param {struct|bool} [data=false] Initial property overrides.
/// @returns {UnitButtonObject}
function UnitButtonObject(data = false) constructor {
    x1 = 0;
    y1 = 0;
    w = 102;
    h = 30;
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
    bind_method = "";
    bind_scope = false;
    set_width = false;
    style = "standard";
    font = fnt_40k_14b;
    set_height_width = false;

    static update_loc = function() {
        add_draw_return_values();
        draw_set_font(font);
        if (label != "") {
            if (!set_width) {
                w = string_width(label) + 10;
                h = string_height(label) + 4;
            } else {
                text_scale = calc_text_scale_confines(label, w, 10);
            }
            h = string_height(label) + 4;
        }
        x2 = x1 + w;
        y2 = y1 + h;
        pop_draw_return_values();
    };

    static update = function(data) {
        var _updaters = struct_get_names(data);
        var i = 0;
        for (i = 0; i < array_length(_updaters); i++) {
            self[$ _updaters[i]] = data[$ _updaters[i]];
        }
        if (!set_height_width) {
            update_loc();
        }
    };

    if (data != false) {
        update(data);
    }

    update_loc();

    static move = function(m_direction, with_gap = false, multiplier = 1) {
        switch (m_direction) {
            case "right":
                x1 += (w + (with_gap * v_gap)) * multiplier;
                x2 += (w + (with_gap * v_gap)) * multiplier;
                break;
            case "left":
                x1 -= (w + (with_gap * v_gap)) * multiplier;
                x2 -= (w + (with_gap * v_gap)) * multiplier;
                break;
            case "down":
                y1 += (h + (with_gap * h_gap)) * multiplier;
                y2 += (h + (with_gap * h_gap)) * multiplier;
                break;
            case "up":
                y1 -= (h + (with_gap * h_gap)) * multiplier;
                y2 -= (h + (with_gap * h_gap)) * multiplier;
                break;
        }
    };

    static disabled = false;

    static draw = function(allow_click = true) {
        add_draw_return_values();
        var _button_click_area;
        if (style == "standard") {
            var _temp_alpha = alpha;
            if (disabled) {
                _temp_alpha = 0.5;
                allow_click = false;
            }
            _button_click_area = draw_unit_buttons(w > 0 ? [x1, y1, x2, y2] : [x1, y1], label, [text_scale, text_scale], active ? color : inactive_col,, font, _temp_alpha);
        } else if (style == "pixel") {
            var _widths = [
                sprite_get_width(spr_pixel_button_left),
                sprite_get_width(spr_pixel_button_middle),
                sprite_get_width(spr_pixel_button_right)
            ];

            var height_scale = h / sprite_get_height(spr_pixel_button_left);
            _widths[0] *= height_scale;
            _widths[2] *= height_scale;
            draw_sprite_ext(spr_pixel_button_left, 0, x1, y1, height_scale, height_scale, 0, c_white, 1);
            var _width_scale = w / _widths[1];
            _widths[1] *= _width_scale;
            draw_sprite_ext(spr_pixel_button_middle, 0, x1 + _widths[0], y1, _width_scale, height_scale, 0, c_white, 1);
            draw_sprite_ext(spr_pixel_button_right, allow_click, x1 + _widths[0] + _widths[1], y1, height_scale, height_scale, 0, c_white, 1);
            var _text_position_x = x1 + ((_widths[0] + 2) * height_scale);
            _text_position_x += _widths[1] / 2;
            draw_set_font(font);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_color(color);

            draw_text_transformed(_text_position_x, y1 + ((h * height_scale) / 2), label, text_scale, text_scale, 0);

            x2 = x1 + array_sum(_widths);
            y2 = y1 + h;
            _button_click_area = [
                x1,
                y1,
                x2,
                y2
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
/// @returns {PurchaseButton}
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
        if (allow_click && _allow_click) {
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
        pop_draw_return_values();
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
function SliderBar(_x = 0, _y = 0, _w = 100, _h = 16, _limits = [0, 100], _inc = 1) constructor {
    xx = _x;
    yy = _y;
    width = _w;
    height = _h;
    value_limits = _limits;
    value_increments = _inc;
    value = _limits[0];

    dragging = false;

    /// @param {struct} _data Struct containing keys to override.
    static update_data = function(_data) {
        var _names = struct_get_names(_data);
        var _count = array_length(_names);
        var _i = 0;
        repeat (_count) {
            var _key = _names[_i];
            self[$ _key] = _data[$ _key];
            _i++;
        }
    };

    /// @description Returns the current value of the slider.
    /// @returns {real}
    static draw = function() {
        add_draw_return_values();

        var _mouse_vars = return_mouse_consts();
        var _mx = _mouse_vars[0];
        var _my = _mouse_vars[1];
        var _rect = [
            xx,
            yy,
            xx + width,
            yy + height
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
        return value;
    };
}

/// @function TextBarArea(_x, _y, _max_width, _requires_input)
/// @constructor
/// @category UI
/// @description Input text area with background and cursor handling.
/// @param {real} _x X position.
/// @param {real} _y Y position.
/// @param {real} [_max_width=400] Max width of text bar.
/// @param {bool} [_requires_input=false] If true, input is required.
/// @returns {TextBarArea}
function TextBarArea(_x, _y, _max_width = 400, _requires_input = false) constructor {
    xx = _x;
    yy = _y;
    max_width = _max_width;
    requires_input = _requires_input;

    allow_input = false;
    draw_col = c_gray;
    cooloff = 0;
    current_text = "";

    background = new DataSlate();
    background.draw_top_piece = false;

    static render_logic = function() {
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
            draw_set_color(draw_col);
        } else {
            draw_set_color(requires_input ? CM_RED_COLOR : CM_GREEN_COLOR);
        }

        var _x1 = xx - (_bar_wid / 2);
        var _y1 = yy;
        var _x2 = xx + (_bar_wid / 2);
        var _y2 = yy + _string_h;

        var _mouse_hover = scr_hit(_x1, _y1, _x2, _y2);
        var _mouse_click = scr_click_left(0, true);
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

/// @function drop_down(selection, draw_x, draw_y, options, open_marker)
/// @description Renders a drop-down selection list and updates choice.
/// @param {string} selection Current selected option.
/// @param {real} draw_x X position.
/// @param {real} draw_y Y position.
/// @param {array} options List of string options.
/// @param {bool} open_marker Whether dropdown is currently open.
/// @returns {array} [new_selection, open_marker]
function drop_down(selection, draw_x, draw_y, options, open_marker) {
    add_draw_return_values();
    if (selection != "") {
        var drop_down_area = draw_unit_buttons([draw_x, draw_y], selection, [1, 1], c_green);
        draw_set_color(c_red);
        if (array_length(options) > 1) {
            if (scr_hit(drop_down_area)) {
                obj_controller.current_target = true;
                var roll_down_offset = 4 + string_height(selection);
                for (var col = 0; col < array_length(options); col++) {
                    if (options[col] == selection) {
                        continue;
                    }
                    var cur_option = draw_unit_buttons([draw_x, draw_y + roll_down_offset], options[col], [1, 1], c_red,,,, true);
                    if (point_and_click(cur_option)) {
                        selection = options[col];
                        open_marker = false;
                    }
                    roll_down_offset += string_height(options[col]) + 4;
                }
                if (!scr_hit(draw_x, draw_y, draw_x + 5 + string_width(selection), draw_y + roll_down_offset)) {
                    open_marker = false;
                    if (obj_controller.current_target) {
                        obj_controller.current_target = false;
                    }
                }
            } else {
                obj_controller.current_target = false;
            }
        }
    }

    pop_draw_return_values();

    return [selection, open_marker];
}

/// @function MultiSelect(options_array, title, data)
/// @constructor
/// @category UI
/// @description Multi-option toggle group allowing multiple selections.
/// @param {array} options_array Array of option labels.
/// @param {string} title Title string.
/// @param {struct} [data={}] Optional overrides.
/// @returns {MultiSelect}
function MultiSelect(options_array, title, data = {}) constructor {
    self.title = title;
    x_gap = 10;
    y_gap = 5;
    x1 = 0;
    y1 = 0;
    x2 = 0;
    y2 = 0;
    on_change = false;
    active_col = CM_GREEN_COLOR;
    inactive_col = c_gray;
    max_width = 0;
    max_height = 0;
    toggles = [];
    for (var i = 0; i < array_length(options_array); i++) {
        var _next_tog = new ToggleButton(options_array[i]);
        _next_tog.active = false;
        array_push(toggles, _next_tog);
    }
    static update = item_data_updater;

    update(data);

    static draw = function(allow_changes = true) {
        add_draw_return_values();
        var _change_method = is_callable(on_change);
        draw_text(x1, y1, title);

        var _prev_x = x1;
        var _prev_y = y1 + string_height(title) + 10;
        var items_on_row = 0;
        for (var i = 0; i < array_length(toggles); i++) {
            var _cur_opt = toggles[i];
            _cur_opt.x1 = _prev_x;
            _cur_opt.y1 = _prev_y;
            _cur_opt.update();
            if (_cur_opt.clicked() && allow_changes) {
                if (_change_method) {
                    on_change();
                }
            }
            _cur_opt.button_color = _cur_opt.active ? active_col : inactive_col;
            _cur_opt.draw();
            items_on_row++;

            _prev_x = _cur_opt.x2 + x_gap;

            x2 = _prev_x > x2 ? _prev_x : x2;
            y2 = _prev_y + _cur_opt.height;
            if (max_width > 0) {
                if (_prev_x - x1 > max_width) {
                    _prev_x = x1;
                    _prev_y += _cur_opt.height + y_gap;
                    items_on_row = 0;
                }
            }
        }
        pop_draw_return_values();
    };

    static set = function(set_array) {
        for (var s = 0; s < array_length(set_array); s++) {
            var _setter = set_array[s];
            for (var i = 0; i < array_length(toggles); i++) {
                var _cur_opt = toggles[i];
                _cur_opt.active = _cur_opt.str1 == _setter;
                if (_cur_opt.str1 == _setter) {}
            }
        }
    };

    static deselect_all = function() {
        for (var i = 0; i < array_length(toggles); i++) {
            var _cur_opt = toggles[i];
            _cur_opt.active = false;
        }
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

/// @function item_data_updater(data)
/// @description Utility to copy struct data into `self`.
/// @param {struct} data Data to apply.
/// @returns {undefined}
function item_data_updater(data) {
    var _data_presets = struct_get_names(data);
    for (var i = 0; i < array_length(_data_presets); i++) {
        self[$ _data_presets[i]] = data[$ _data_presets[i]];
    }
}

/// @function RadioSet(options_array, title, data)
/// @constructor
/// @category UI
/// @description Radio button group allowing only one active selection.
/// @param {array} options_array List of option labels.
/// @param {string} [title=""] Title string.
/// @param {struct} [data={}] Optional overrides.
/// @returns {RadioSet}
function RadioSet(options_array, title = "", data = {}) constructor {
    toggles = [];
    current_selection = 0;
    self.title = title;
    active_col = CM_GREEN_COLOR;
    inactive_col = c_gray;
    allow_changes = true;
    x_gap = 10;
    y_gap = 5;
    x1 = 0;
    y1 = 0;
    title_font = fnt_40k_14b;
    draw_title = true;
    space_evenly = false;
    changed = false;

    if (title == "") {
        draw_title = false;
    }
    max_width = 0; // container width; if 0, use row's natural width
    max_height = 0;
    center = false; // when true, center each row horizontally in container

    for (var i = 0; i < array_length(options_array); i++) {
        array_push(toggles, new ToggleButton(options_array[i]));
    }
    x2 = 0;
    y2 = 0;

    move_data_to_current_scope(data, true);
    static update = item_data_updater;

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
            row_height = max(row_height, _cur_opt.height);

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
                    if (btn.clicked() && allow_changes) {
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
/// @param {struct} [data={}] Initial properties.
/// @returns {ToggleButton}
function ToggleButton(data = {}) constructor {
    x1 = 0;
    y1 = 0;
    x2 = 0;
    y2 = 0;
    tooltip = "";
    str1 = "";
    width = 0;
    height = 0;
    state_alpha = 1;
    hover_alpha = 1;
    active = true;
    text_halign = fa_left;
    text_color = c_gray;
    button_color = c_gray;
    font = fnt_40k_12;
    style = "default";

    //make true to run clicked() within draw sequence
    clicked_check_default = false;

    update = function() {
        add_draw_return_values();
        draw_set_font(font);
        if (style == "default") {
            if (width == 0) {
                width = string_width(str1) + 4;
            }
            if (height == 0) {
                height = string_height(str1) + 4;
            }
        } else if (style == "box") {
            width = max(32, string_width(str1)) + 6;
            height = 32 + 2 + string_height(str1);
        }
        x2 = x1 + width;
        y2 = y1 + height;
        pop_draw_return_values();
    };

    move_data_to_current_scope(data, true);

    update();

    hover = function() {
        return scr_hit(x1, y1, x2, y2);
    };

    clicked = function() {
        if (hover() && scr_click_left()) {
            active = !active;
            audio_play_sound(snd_click_small, 10, false, 1);
            return true;
        } else {
            return false;
        }
    };

    draw = function(is_active = active) {
        self.active = is_active;
        add_draw_return_values();
        draw_set_font(font);
        var str1_h = string_height(str1);
        var text_padding = width * 0.03;
        var text_x = x1 + text_padding;
        var text_y = y1 + text_padding;
        var total_alpha;

        if (text_halign == fa_center) {
            text_x = x1 + (width / 2);
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
        if (tooltip != "") {
            if (hover()) {
                tooltip_draw(tooltip);
            }
        }

        total_alpha = state_alpha * hover_alpha;

        if (style == "default") {
            draw_rectangle_color_simple(x1, y1, x1 + width, y1 + str1_h, 1, button_color, total_alpha);
            draw_set_halign(text_halign);
            draw_set_valign(fa_top);
            draw_text_color_simple(text_x, text_y, str1, text_color, total_alpha);
            draw_set_alpha(1);
            draw_set_halign(fa_left);
        } else if (style == "box") {
            // Icon with alpha
            draw_set_halign(fa_left);
            draw_sprite_ext(spr_creation_check, active, x1 + 2, y1, 1, 1, 0, c_white, total_alpha);
            // Label centred below icon
            draw_set_alpha(total_alpha);
            draw_set_valign(fa_top);
            draw_set_halign(fa_center);
            var _label_y = y1 + 32 + 2;
            draw_text_transformed(x1 + 18, _label_y, str1, 1, 1, 0);
            draw_set_alpha(1);
        }

        if (clicked_check_default) {
            clicked();
        }
        pop_draw_return_values();
    };
}

/// @function InteractiveButton(data)
/// @constructor
/// @category UI
/// @description A button with separate active/inactive tooltips and click sounds.
/// @param {struct} [data={}] Initial properties.
/// @returns {InteractiveButton}
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
    var _data_presets = struct_get_names(data);
    for (var i = 0; i < array_length(_data_presets); i++) {
        self[$ _data_presets[i]] = data[$ _data_presets[i]];
    }
    update = function() {
        if (width == 0) {
            width = string_width(str1) + 4;
        }
        if (height == 0) {
            height = string_height(str1) + 4;
        }
        x2 = x1 + width;
        y2 = y1 + height;
    };

    hover = function() {
        return scr_hit(x1, y1, x2, y2);
    };

    clicked = function() {
        if (hover() && scr_click_left()) {
            if (!active) {
                audio_play_sound(snd_error, 10, false, 1);
                return false;
            } else {
                audio_play_sound(snd_click_small, 10, false, 1);
                return true;
            }
        } else {
            return false;
        }
    };

    draw = function() {
        var str1_h = string_height(str1);
        var text_padding = width * 0.03;
        var text_x = x1 + text_padding;
        var text_y = y1 + text_padding;
        var total_alpha;

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
        draw_rectangle_color_simple(x1, y1, x1 + width, y1 + str1_h, 1, button_color, total_alpha);
        draw_set_halign(text_halign);
        draw_set_valign(fa_top);
        draw_text_color_simple(text_x, text_y, str1, text_color, total_alpha);
        draw_set_alpha(1);
        draw_set_halign(fa_left);
    };
}

/// @function list_traveler(list, cur_val, move_up_coords, move_down_coords)
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
                if (i == array_length(list) - 1) {
                    _new_val = list[0];
                } else {
                    _new_val = list[i + 1];
                }
            } else if (point_and_click(move_down_coords)) {
                if (i == 0) {
                    _new_val = list[array_length(list) - 1];
                } else {
                    _new_val = list[i - 1];
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

/// @function MainMenuButton
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

            draw_set_blend_mode(bm_add);
            draw_set_alpha(hover_alpha);
            draw_sprite_ext(hover_sprite, 0, _x, _y, _x_scale, _y_scale, 0, c_white, hover_alpha);
            draw_set_blend_mode(bm_normal);

            oscillate_down = true;
            is_clicked = scr_click_left(0, true);
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
                draw_set_blend_mode(bm_add);
                draw_set_alpha(hover_alpha);
                draw_sprite_ext(hover_sprite, 0, _x, _y, _x_scale, _y_scale, 0, c_white, hover_alpha);
                draw_set_blend_mode(bm_normal);
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
