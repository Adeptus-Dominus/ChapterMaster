global.ui_click_lock = true;
cancel_button = {
    x1: x + 26,
    y1: y + 103,
    x2: x + 126,
    y2: y + 123,
};

accept_button = {
    x1: x + 175,
    y1: y + 103,
    x2: x + 275,
    y2: y + 123,
};

draw_sprite(spr_popup_dialogue, 0, x, y);

draw_set_font(fnt_40k_14b);
draw_set_color(c_gray);
draw_set_halign(fa_center);

draw_text_ext(x + 150, y + 7, question, 18, 260);

if (scr_hit(x + 19, y + 46, x + 280, y + 70)) {
    if (instance_exists(obj_cursor)) {
        obj_cursor.image_index = 2;
    }
} else {
    if (instance_exists(obj_cursor)) {
        obj_cursor.image_index = 0;
    }
}

draw_set_font(fnt_40k_14);
draw_set_color(c_gray);

draw_text(x + 150 + (blink ? 2 : 0), y + 50, $"{inputting}{blink ? "|" : ""}");

// Button 1s
draw_set_alpha(0.25);
draw_set_color(c_black);
draw_rectangle(x + 26, y + 103, x + 126, y + 123, 0);
draw_set_color(c_gray);
draw_set_alpha(0.5);
draw_rectangle(x + 26, y + 103, x + 126, y + 123, 1);
draw_set_alpha(0.25);
draw_rectangle(x + 27, y + 104, x + 125, y + 122, 1);
draw_set_alpha(1);
draw_text(x + 76, y + 105, "Cancel");
if (scr_hit(cancel_button.x1, cancel_button.y1, cancel_button.x2, cancel_button.y2)) {
    draw_set_alpha(0.1);
    draw_set_color(c_white);
    draw_rectangle(x + 26, y + 103, x + 126, y + 123, 0);
    if (instance_exists(obj_cursor)) {
        obj_cursor.image_index = 1;
    }
    if (mouse_check_button_pressed(mb_left) && obj_controller.cooldown <= 0) {
        global.ui_click_lock = false;
        instance_destroy();
    }
}

// Button 2
draw_set_alpha(0.25);
draw_set_color(c_black);
draw_rectangle(x + 175, y + 103, x + 275, y + 123, 0);
draw_set_color(c_gray);
draw_set_alpha(0.5);
draw_rectangle(x + 175, y + 103, x + 275, y + 123, 1);
draw_set_alpha(0.25);
draw_rectangle(x + 176, y + 104, x + 274, y + 122, 1);
draw_set_alpha(1);
draw_text(x + 225, y + 105, "Accept");
if (scr_hit(accept_button.x1, accept_button.y1, accept_button.x2, accept_button.y2)) {
    draw_set_alpha(0.1);
    draw_set_color(c_white);
    draw_rectangle(x + 175, y + 103, x + 275, y + 123, 0);
    if (instance_exists(obj_cursor)) {
        obj_cursor.image_index = 1;
    }
    if (mouse_check_button_pressed(mb_left) && obj_controller.cooldown <= 0) {
        if (is_struct(target)) {
            if (inputting != 0) {
                target.number = inputting;
            }
            global.ui_click_lock = false;
            instance_destroy();
        }
        execute = true;
    }
}

draw_set_alpha(1);
