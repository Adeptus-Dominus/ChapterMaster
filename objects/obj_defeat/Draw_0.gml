draw_set_alpha(1);
// draw_sprite(spr_defeat,global.defeat,331,73);
scr_image("defeat", global.defeat, 331, 73, 938, 554);

var xx, yy, cus;
xx = 331;
yy = 93;
cus = false;

var sprx = 728, spry = 83, sprw = 135, sprh = 135;

if (sprite_exists(global.chapter_icon.sprite)) {
    draw_sprite_stretched(global.chapter_icon.sprite, 0, sprx, spry, sprw, sprh);
} else {
    global.logger.error($"{global.chapter_icon.name} chapter icon not found in any icon directory. Chapter icon will not render.");
}

draw_set_color(c_black);
draw_set_alpha(fade / faded);
draw_rectangle(0, 0, room_width, room_height, 0);
draw_set_alpha(fadeout / 30);
draw_rectangle(0, 0, room_width, room_height, 0);
