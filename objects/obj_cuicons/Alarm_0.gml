var i;
i = 0;
repeat (300) {
    i += 1;
    if ((spr_custom[i] != 0) && (i != custom_using) && sprite_exists(spr_custom_icon[i])) {
        if (file_exists($"{PATH_custom_icons}{i}.png")) {
            sprite_delete(spr_custom_icon[i]);
            spr_custom_icon[i] = -1;
            spr_custom[i] = 0;
        }
    }
}
