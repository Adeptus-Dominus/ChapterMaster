function ColourPicker(xx, yy, max_width = 400) constructor {
    x = xx;
    y = yy;
    chosen = -1;
    count_destroy = false;
    box_size = 30;
    choose_textures = false;
    markings = false;
    disable_textures = false;
    self.max_width = max_width;
    base_colour = 0;
    title = "";

    markings_options = new RadioSet(
        [
            {
                str1: "None",
                font: fnt_40k_14b,
                tooltip: "",
            },
            {
                str1: "Company",
                font: fnt_40k_14b,
                tooltip: "If selected You will be able to pick an icon or icon set after selecting a base colour",
            },
            {
                str1: "Chapter",
                font: fnt_40k_14b,
                tooltip: "If selected You will be able to pick an icon or icon set after selecting a base colour",
            },
            {
                str1: "Squad",
                font: fnt_40k_14b,
                tooltip: "If selected You will be able to pick an icon or icon set after selecting a base colour",
            },
            {
                str1: "Role",
                font: fnt_40k_14b,
                tooltip: "If selected You will be able to pick an icon or icon set after selecting a base colour",
            },
        ],
        "Markings",
    );

    static textures_surface = surface_create(1, 1);

    static texture_coords = [];
    static _texture_offset = [
        0,
        0,
    ];

    static create_texture_surface = function(texture_set, sprite_draw_args) {
        var texture_names = struct_get_names(texture_set);
        var total_width = sprite_draw_args.frame_width * array_length(texture_names);
        if (sprite_draw_args.frame_height <= 0 || total_width <= 0) {
            exit;
        }

        _texture_offset = [
            0,
            0,
        ];
        texture_coords = [];

        surface_resize(textures_surface, total_width, sprite_draw_args.frame_height);
        surface_set_target(textures_surface);

        var draw_x = 0;
        var draw_y = 0;
        var _frame_width = sprite_draw_args.frame_width;
        var _frame_height = sprite_draw_args.frame_height;
        for (var i = 0; i < array_length(texture_names); i++) {
            var _tex = texture_set[$ texture_names[i]];
            draw_sprite_part_ext(_tex, 0, sprite_draw_args.x, sprite_draw_args.y, _frame_width, _frame_height, draw_x, draw_y, 1, 1, c_white, 1);

            array_push(texture_coords, [[draw_x, draw_y, draw_x + _frame_width, draw_y + _frame_height], texture_names[i]]);
            draw_x += sprite_draw_args.frame_width;
        }
        surface_reset_target();
    };

    static draw_textures_surface = function(selection_method) {
        draw_set_alpha(1);
        var _tex_height = surface_get_height(textures_surface);
        draw_surface_part(textures_surface, _texture_offset[0], _texture_offset[1], min(max_width, surface_get_width(textures_surface)), _tex_height, x, y);
        if (scr_hit(x, y, x + max_width, y + _tex_height)) {
            tooltip_draw("scroll with arrow keys");
        }
        for (var i = 0; i < array_length(texture_coords); i++) {
            var _tex_coord = texture_coords[i];

            if (keyboard_check(vk_left)) {
                _texture_offset[0] -= 10;
            } else if (keyboard_check(vk_right)) {
                _texture_offset[0] += 10;
            }
            _texture_offset[0] = clamp(_texture_offset[0], 0, max(surface_get_width(textures_surface) - max_width, 0));
            if (scr_hit_relative(_tex_coord[0], [x - _texture_offset[0], y - _texture_offset[1]])) {
                draw_set_color(c_white);
                draw_set_alpha(0.2);
                var rel_coords = [];
                array_copy(rel_coords, 0, _tex_coord[0], 0, 4);
                draw_rectangle_array(move_location_relative(rel_coords, x - _texture_offset[0], y - _texture_offset[1]), 0);
                draw_set_alpha(1);
                selection_method(_tex_coord);
            }
        }
    };

    static draw = function() {
        if (count_destroy) {
            return "destroy";
        }
        draw_set_font(fnt_40k_30b);
        draw_text_transformed(144, 550, title, 0.6, 0.6, 0);

        var column = -1;
        var current_color = 0;
        var row = 0;
        var default_box_x = x;
        var box_x = default_box_x;
        var box_y = y;

        if (!choose_textures) {
            if (!markings) {
                for (var i = 0; i < array_length(obj_creation.col_r); i++) {
                    column++;
                    if ((column * box_size) + 40 > max_width) {
                        row++;
                        column = 0;
                    }
                    draw_set_color(make_color_rgb(obj_creation.col_r[i], obj_creation.col_g[i], obj_creation.col_b[i]));
                    box_coords = [
                        box_x + (box_size * column),
                        box_y + (box_size * row),
                        box_x + (box_size * column) + box_size,
                        box_y + (box_size * row) + box_size,
                    ];
                    draw_rectangle_array(box_coords, 0);
                    draw_set_color(CM_GREEN_COLOR);
                    draw_rectangle_array(box_coords, 1);
                    if (scr_hit(box_coords)) {
                        draw_set_color(c_white);
                        draw_set_alpha(0.2);
                        draw_rectangle_array(box_coords, 0);
                        draw_set_alpha(1);
                        chosen = i;
                        if (mouse_button_clicked()) {
                            if (markings_options.current_selection == 0) {
                                count_destroy = true;
                            } else {
                                markings = true;
                                base_colour = i;
                                box_size *= 3;
                                var _sprite_args = {
                                    x: 12,
                                    y: 30,
                                    frame_width: box_size,
                                    frame_height: box_size,
                                };
                                var sub_key = "";
                                var sprite_set = "";
                                if (array_contains(["right_pauldron", "left_pauldron"], title)) {
                                    _sprite_args.x = 12;
                                    _sprite_args.y = 30;
                                    sub_key = "pauldron";
                                } else if (array_contains(["right_leg_knee", "left_leg_knee"], title)) {
                                    sub_key = "knees";
                                }
                                sprite_set = get_marine_icon_set(markings_options.current_selection);
                                if (is_struct(sprite_set)) {
                                    if (struct_exists(sprite_set, sub_key)) {
                                        create_texture_surface(sprite_set[$ sub_key], _sprite_args);
                                    }
                                }
                            }
                        }
                    }
                }
            } else if (markings) {
                draw_textures_surface(function(tex_data) {
                    chosen = [
                        "icon",
                        {
                            icon: tex_data[1],
                            colour: base_colour,
                            type: markings_options.current_selection,
                        },
                    ];
                    if (mouse_button_clicked()) {
                        count_destroy = true;
                    }
                });
            }
        } else if (!disable_textures) {
            draw_textures_surface(function(tex_data) {
                chosen = [
                    "texture",
                    tex_data[1],
                ];
                if (mouse_button_clicked()) {
                    count_destroy = true;
                }
            });
        }

        draw_set_halign(fa_center);
        draw_set_font(fnt_40k_14b);
        if (point_and_click(draw_unit_buttons([x + max_width - string_width("close") - 15, y + (box_size * (row + 1))], "close"))) {
            return "destroy";
        }
        var marking_opts = [
            "right_pauldron",
            "left_pauldron",
            "right_leg_knee",
            "left_leg_knee",
        ];

        var _valid_marking_spot = array_contains(marking_opts, title);
        if (_valid_marking_spot) {
            markings_options.x1 = x + 10;
            markings_options.y1 = y + (box_size * (row + 1));
        }

        if (!markings && !disable_textures) {
            var tex_coords = draw_unit_buttons([x + max_width / 2, y + (box_size * (row + 1))], "Texture");
            markings_options.y1 = tex_coords[3];
            if (point_and_click(tex_coords)) {
                choose_textures = !choose_textures;
                if (choose_textures) {
                    box_size *= 3;
                    var _sprite_args = {
                        x: 0,
                        y: 0,
                        frame_width: box_size,
                        frame_height: box_size,
                    };
                    create_texture_surface(global.textures, _sprite_args);
                } else {
                    box_size /= 3;
                }
            }
        }

        if (_valid_marking_spot) {
            markings_options.draw();
        }

        if (!scr_hit(130, 536, 545, 748) && mouse_check_button_pressed(mb_left)) {}
        draw_set_alpha(1);
    };
}
