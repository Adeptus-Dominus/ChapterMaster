var i;
i = -1;
repeat (300) {
    i += 1;
    if ((spr_custom[i] != 0) && sprite_exists(spr_custom_icon[i])) {
        if (file_exists($"{PATH_custom_icons}{i}.png") && (spr_custom[i] > 0)) {
            sprite_delete(spr_custom_icon[i]);
            spr_custom_icon[i] = -1;
            spr_custom[i] = 0;
        }
    }
}

global.custom_icons = 0;

if ((custom_using > 0) || (room_get_name(room) == "Main_Menu")) {
    var i;
    i = 0;
    spr_custom[0] = 0;
    spr_custom_icon[0] = 0;
    repeat (300) {
        i += 1;
        spr_custom[i] = 0;
        spr_custom_icon[i] = -1;
        if (file_exists($"{PATH_custom_icons}{i}.png")) {
            spr_custom_icon[i] = sprite_add($"{PATH_custom_icons}{i}.png", 1, false, false, 0, 0);
            // if (file_exists(working_directory + "\icons\custom"+string(i)+".png")) then show_message("'working_directory + \icons\custom"+string(i)+".png' exists");

            // var fucking;fucking=spr_custom_icon[i];
            // if (sprite_exists(fucking)) then show_message("the pulled sprite_add 'spr_custom_icon["+string(i)+"]' works");

            global.custom_icons += 1;
            spr_custom[i] = 1;

            // show_message("spr_custom_icon["+string(i)+"] has been loaded from 'working_directory + \icons\custom"+string(i)+".png'");
        }
    }
}
