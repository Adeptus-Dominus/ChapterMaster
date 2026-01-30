/*
if (instance_exists(obj_main_menu)) and ((instance_exists(obj_saveload))) and (!instance_exists(obj_ingame_menu)){
    var yy,i;yy=830;i=6;
    if (glowing[i]=1) and (hover[i]=1){glow[i]+=1;if (glow[i]>=40) then glowing[i]=-1;}
    if (glowing[i]=-1) and (hover[i]=1){glow[i]-=1;if (glow[i]<=0) then glowing[i]=1;}
    draw_set_alpha((glow[i]/80)+0.2);
    draw_sprite(spr_mm_glow,4,687,yy);
    if (hover[i]=0) and (glow[i]>0) then glow[i]-=4;
    draw_set_alpha(1);
    draw_sprite(spr_mm_butts,4,687,yy);
}
if (instance_exists(obj_main_menu)) and (!instance_exists(obj_ingame_menu)){
    if (obj_main_menu.menu=3){
        var yy,i;yy=830;i=6;
        if (glowing[i]=1) and (hover[i]=1){glow[i]+=1;if (glow[i]>=40) then glowing[i]=-1;}
        if (glowing[i]=-1) and (hover[i]=1){glow[i]-=1;if (glow[i]<=0) then glowing[i]=1;}
        draw_set_alpha((glow[i]/80)+0.2);
        draw_sprite(spr_mm_glow,4,687,yy);
        if (hover[i]=0) and (glow[i]>0) then glow[i]-=4;
        draw_set_alpha(1);
        draw_sprite(spr_mm_butts,4,687,yy);
    }
}*/

if (room_get_name(room) == "Creation") {
    shader_set(light_dark_shader);
    var yy = y + 25, i = 1;
    var _spr_height = sprite_get_height(spr_mm_butts_small) * 2;
    var _spr_width = sprite_get_width(spr_mm_butts_small) * 2;
    shader_set_uniform_f(shader_get_uniform(light_dark_shader, "highlight"), 1 + hover[0] / 10);
    draw_sprite_ext(spr_mm_butts_small, 1, x, yy, 2, 2, 0, c_white, 1);
    if (scr_hit(x, yy, x + _spr_width, yy + _spr_height)) {
        if (hover[0] < 20) {
            hover[0]++;
        }
    } else {
        if (hover[0] > 0) {
            hover[0]--;
        }
    }
    shader_reset();
}

if (instance_exists(obj_main_menu) && (!instance_exists(obj_saveload)) && (!instance_exists(obj_credits))) {
    // if (obj_main_menu.tim4>0){
    //     draw_set_alpha((oth/40)/4);
    //     if (point_distance(mouse_x,mouse_y,24,room_height-24)<=24) and (!instance_exists(obj_ingame_menu)) and (oth>=40){
    //         if (instance_exists(obj_cursor)){
    //             if (obj_cursor.image_alpha>=1){
    //                 draw_set_alpha(1);
    //                 if (mouse_left=1) and (cooldown<=0){
    //                     instance_create(0,0,obj_ingame_menu);
    //                 }
    //             }
    //         }
    //     }
    //     draw_sprite_stretched(spr_settings_button,0,0,room_height-48,48,48);
    //     draw_set_alpha(1);
    // }

    shader_set(light_dark_shader);
    //draw_sprite(sprite_index, 0, x, y);

    if ((obj_main_menu.tim4 > 0) && (obj_main_menu.menu != 3)) {
        // location of sprites
        draw_set_alpha(obj_main_menu.tim4 / 50);
        var height = 20 * 2.2;
        var width = 198 * 2.2;
        for (var i = 0; i < 4; i++) {
            var y_start = 500 + ((20 * 2.2) * i);
            shader_set_uniform_f(shader_get_uniform(light_dark_shader, "highlight"), 1 + hover[i] / 10);
            draw_sprite_ext(spr_mm_butts, i, 580, y_start, 2.2, 2.2, 0, c_white, 1);
            if (scr_hit(580, y_start, 580 + width, y_start + height)) {
                if (hover[i] < 20) {
                    hover[i]++;
                }
            } else {
                if (hover[i] > 0) {
                    hover[i]--;
                }
            }
            if (point_and_click([580, y_start, 580 + width, y_start + height]) && !instance_exists(obj_ingame_menu)) {
                switch (i) {
                    case 0:
                        ini_open("saves.ini");
                        // var skip_tutorial_option=0;
                        // skip_tutorial_option = ini_read_real("Data", "tutorial", 0);
                        ini_close();
                        cooldown = 9999;
                        button = 1;

                        obj_main_menu_buttons.fading = 1;
                        obj_main_menu_buttons.crap = 2;
                        obj_main_menu_buttons.cooldown = 9999;

                        // else {
                        //     var pop;
                        //     pop=instance_create(0,0,obj_popup);
                        //     pop.size=1;pop.title="Tutorial";
                        //     pop.text="Would you like to play the tutorial?  It is strongly advisable for those new to Chapter Master.";
                        //     pop.add_option="Play the tutorial.";
                        //     pop.add_option="Skip the tutorial.";pop.option3="Skip and never ask again.";
                        // }
                        break;
                    case 1:
                        instance_create(0, 0, obj_saveload);
                        obj_saveload.menu = 2;
                        fading = 0;
                        fade = 0;
                        button = 0;
                        break;
                    case 2:
                        instance_create(0, 0, obj_ingame_menu);
                        break;
                    case 3:
                        with (obj_cursor) {
                            instance_destroy();
                        }
                        game_end();
                        break;
                }
            }
        }
        shader_reset();
    }

    if ((obj_main_menu.tim4 > 0) && (obj_main_menu.menu != 3)) {
        with (obj_main_menu) {
            draw_set_font(fnt_menu);
            draw_set_halign(fa_center);

            var wfd = ""; // xx=1138;yy=532;wad=430;
            var xx = room_width / 2, yy = 850, wad = 800;

            if ((word_from_duke != "blank") && (word_from_duke != "")) {
                wfd = word_from_duke;
            }
            if ((word_from_duke2 != "blank") && (word_from_duke2 != "")) {
                wfd = word_from_duke2;
            }

            if ((wfd != "blank") && (wfd != "") && (obj_main_menu.tim4 < 400)) {
                draw_set_alpha((tim4 - 20) / 50);

                set_color(c_yellow);
                draw_text_ext_transformed(xx, yy, string_hash_to_newline("Server: " + string(wfd)), -1, wad, 1, 1, 0);
                draw_text_ext_transformed(xx + 0.5, yy + 0.5, string_hash_to_newline("Server: " + string(wfd)), -1, wad, 1, 1, 0);

                var da;
                da = 0;
                if (mess_alpha <= 60) {
                    da = mess_alpha / 60;
                }
                if (mess_alpha > 60) {
                    da = 1 + (((mess_alpha - 60) * -1) / 60);
                }
                draw_set_alpha(min(da, ((obj_main_menu.tim4 - 20) / 50)));

                draw_set_color(c_red);
                draw_text_ext_transformed(xx, yy, string_hash_to_newline("Server: " + string(wfd)), -1, wad, 1, 1, 0);
                draw_text_ext_transformed(xx + 0.5, yy + 0.5, string_hash_to_newline("Server: " + string(wfd)), -1, wad, 1, 1, 0);
                draw_set_alpha(1);
            }
        }
    }
}

if (fade > 0) {
    draw_set_color(0);
    draw_set_alpha(fade / 40);
    draw_rectangle(0, 0, room_width, room_height, 0);
}

draw_set_alpha(1);

/* */
/*  */
