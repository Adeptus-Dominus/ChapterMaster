global.custom_icons = 0;

var i;
i = -1;
repeat (300) {
    i += 1;
    if (spr_custom[i] != 0) {
        if (file_exists($"{PATH_custom_icons}{i}.png")) {
            sprite_delete(spr_custom_icon[i]);
            spr_custom_icon[i] = 0;
            spr_custom[i] = 0;
        }
    }
}
