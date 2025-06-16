xx = __view_get(e__VW.XView, 0) + x;
yy = __view_get(e__VW.YView, 0) + y;

cancel_button={
    x1: xx + 26,
    y1: yy + 103,
    x2: xx + 126,
    y2: yy + 123,
}

accept_button={
    x1: xx + 175,
    y1: yy + 103,
    x2: xx + 275,
    y2: yy + 123,
}

draw_sprite(spr_popup_dialogue, 0, xx, yy);

draw_set_font(fnt_40k_14b);
draw_set_color(c_gray);
draw_set_halign(fa_center);

draw_text_ext(xx + 150, yy + 7, question, 18, 260);

if (scr_hit(xx + 19, yy + 46, xx + 280, yy + 70)) {
    if (instance_exists(obj_cursor)) obj_cursor.image_index = 2;
} else {
    if (instance_exists(obj_cursor)) obj_cursor.image_index = 0;
}

draw_set_font(fnt_40k_14);
draw_set_color(c_gray);

draw_text(xx + 150 + blink?2:0, yy + 50, $"{inputting}{blink?"|":""}");

// Button 1
draw_set_alpha(0.25);
draw_set_color(c_black);
draw_rectangle(xx + 26, yy + 103, xx + 126, yy + 123, 0);
draw_set_color(c_gray);
draw_set_alpha(0.5);
draw_rectangle(xx + 26, yy + 103, xx + 126, yy + 123, 1);
draw_set_alpha(0.25);
draw_rectangle(xx + 27, yy + 104, xx + 125, yy + 122, 1);
draw_set_alpha(1);
draw_text(xx + 76, yy + 105, "Cancel");
if (scr_hit(cancel_button.x1, cancel_button.y1, cancel_button.x2, cancel_button.y2)) {
    draw_set_alpha(0.1);
    draw_set_color(c_white);
    draw_rectangle(xx + 26, yy + 103, xx + 126, yy + 123, 0);
    if (instance_exists(obj_cursor)){
        obj_cursor.image_index = 1;
    }
    if (mouse_check_button_pressed(mb_left) && obj_controller.cooldown <= 0) {
        instance_destroy();
    }
}

// Button 2
draw_set_alpha(0.25);
draw_set_color(c_black);
draw_rectangle(xx + 175, yy + 103, xx + 275, yy + 123, 0);
draw_set_color(c_gray);
draw_set_alpha(0.5);
draw_rectangle(xx + 175, yy + 103, xx + 275, yy + 123, 1);
draw_set_alpha(0.25);
draw_rectangle(xx + 176, yy + 104, xx + 274, yy + 122, 1);
draw_set_alpha(1);
draw_text(xx + 225, yy + 105, "Accept");
if (scr_hit(accept_button.x1, accept_button.y1, accept_button.x2, accept_button.y2)) {
    draw_set_alpha(0.1);
    draw_set_color(c_white);
    draw_rectangle(xx + 175, yy + 103, xx + 275, yy + 123, 0);
    if (instance_exists(obj_cursor)) obj_cursor.image_index = 1;
    if (mouse_check_button_pressed(mb_left) && obj_controller.cooldown <= 0) {
    if (is_struct(target)){
        if (inputting != 0){
            target.number = inputting;
        }
        instance_destroy();
    }
        execute = true;
    }
}

draw_set_alpha(1);