draw_set_alpha(1);
scr_image("defeat", global.defeat, 331, 73, 938, 554);

var sprx = 728;
var spry = 83;
var sprw = 135;
var sprh = 135;

if (sprite_exists(global.chapter_icon.sprite)) {
    draw_sprite_stretched(global.chapter_icon.sprite, 0, sprx, spry, sprw, sprh);
} else {
    LOGGER.error($"{global.chapter_icon.name} chapter icon not found in any icon directory. Chapter icon will not render.");
}

draw_set_color(c_black);
draw_set_alpha(fade / faded);
draw_rectangle(0, 0, room_width, room_height, 0);
draw_set_alpha(fadeout / 30);
draw_rectangle(0, 0, room_width, room_height, 0);
