if (board == 1) {
    if (sprite_index != spr_assault_ram) {
        sprite_index = spr_assault_ram;
    }
    if (image_alpha > 0.5) {
        image_alpha -= 0.02;
    }
    if (image_alpha <= 0.5) {
        board = 2;
    }
}
if (board == 2) {
    if (sprite_index != spr_assault_ram) {
        sprite_index = spr_assault_ram;
    }
    if (image_alpha < 1) {
        image_alpha += 0.02;
    }
    if (image_alpha >= 1) {
        board = 1;
    }
}
if ((board == 0) && (sprite_index != spr_cursor)) {
    sprite_index = spr_cursor;
    image_alpha = 1;
}

// old_x=mouse_x;
// old_y=mouse_y;

x = mouse_x;
y = mouse_y;

if (instance_exists(obj_controller)) {
    if ((keyboard_check(vk_left) || keyboard_check(ord("A"))) && (obj_controller.x > 320)) {
        x -= 6;
    }
    if ((keyboard_check(vk_right) || keyboard_check(ord("D"))) && (obj_controller.x < 960)) {
        x += 6;
    }
    if ((keyboard_check(vk_up) || keyboard_check(ord("W"))) && (obj_controller.y > 240)) {
        y -= 6;
    }
    if ((keyboard_check(vk_down) || keyboard_check(ord("S"))) && (obj_controller.y < 720)) {
        y += 6;
    }
}

/*
if (obj_controller.x<320) then x+=12;
/*if (y<240) then y=240;
if (x>960) then x=960;
if (y>720) then y=720;*/

/* */
/*  */
