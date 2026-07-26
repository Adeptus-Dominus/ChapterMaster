add_draw_return_values();

shader_set(light_dark_shader);
var u_highlight = shader_get_uniform(light_dark_shader, "highlight");

for (var i = 0; i < array_length(buttons); i++) {
    var b = buttons[i];

    var alpha = 1.0;
    if (instance_exists(obj_main_menu)) {
        alpha = obj_main_menu.title_alpha;
    }

    shader_set_uniform_f(u_highlight, 1 + (b.hover / 10));

    var scale = (b.sprite == spr_mm_butts) ? 2.2 : 2.0;
    draw_sprite_ext(b.sprite, b.subimg, b.x, b.y, scale, scale, 0, c_white, alpha);
}
shader_reset();

if (fade_val > 0) {
    draw_set_alpha(fade_val);
    draw_set_color(c_black);
    draw_rectangle(0, 0, room_width, room_height, false);
}
pop_draw_return_values();
