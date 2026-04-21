// if (wounded>0) then d3d_set_fog(true,16645629,0,0);
if (wounded > 0) {
    d3d_set_fog(true, 255, 0, 0);
}
if (wounded <= 0) {
    if (shader_is_compiled(sReplaceColor)) {
        shader_set(sReplaceColor);

        shader_set_uniform_f_array(colour_to_find1, body_colour_find);
        shader_set_uniform_f_array(colour_to_set1, body_colour_replace);
        shader_set_uniform_f_array(colour_to_find2, secondary_colour_find);
        shader_set_uniform_f_array(colour_to_set2, secondary_colour_replace);
        shader_set_uniform_f_array(colour_to_find3, pauldron_colour_find);
        shader_set_uniform_f_array(colour_to_set3, pauldron_colour_replace);
        shader_set_uniform_f_array(colour_to_find4, lens_colour_find);
        shader_set_uniform_f_array(colour_to_set4, lens_colour_replace);
        shader_set_uniform_f_array(colour_to_find5, trim_colour_find);
        shader_set_uniform_f_array(colour_to_set5, trim_colour_replace);
        shader_set_uniform_f_array(colour_to_find6, pauldron2_colour_find);
        shader_set_uniform_f_array(colour_to_set6, pauldron2_colour_replace);
        shader_set_uniform_f_array(colour_to_find7, weapon_colour_find);
        shader_set_uniform_f_array(colour_to_set7, weapon_colour_replace);
    }
}

if ((animation == "") || (animation == "settle")) {
    if (col_special == 0) {
        draw_sprite(spr_mar_walk_legs1, 0, x, y);
        draw_sprite(spr_mar_walk_body1, 0, x, y);
    }
    if (col_special == 1) {
        draw_sprite(spr_mar_walk_legs1, 0, x, y);
        draw_sprite(spr_mar_walk_body2, 0, x, y);
    }
    if (col_special == 2) {
        draw_sprite(spr_mar_walk_legs3, 0, x, y);
        draw_sprite(spr_mar_walk_body3, 0, x, y);
    }
    if (col_special == 3) {
        draw_sprite(spr_mar_walk_legs4, 0, x, y);
        draw_sprite(spr_mar_walk_body3, 0, x, y);
    }
    if (trim == 0) {
        draw_sprite(spr_mar_walk_pauldron1, 0, x, y);
    }
    if (trim == 1) {
        draw_sprite(spr_mar_walk_pauldron2, 0, x, y);
    }
}
if (animation == "walk") {
    if (col_special == 0) {
        draw_sprite(spr_mar_walk_legs1, ii, x, y);
        draw_sprite(spr_mar_walk_body1, ii, x, y);
    }
    if (col_special == 1) {
        draw_sprite(spr_mar_walk_legs1, ii, x, y);
        draw_sprite(spr_mar_walk_body2, ii, x, y);
    }
    if (col_special == 2) {
        draw_sprite(spr_mar_walk_legs3, ii, x, y);
        draw_sprite(spr_mar_walk_body3, ii, x, y);
    }
    if (col_special == 3) {
        draw_sprite(spr_mar_walk_legs4, ii, x, y);
        draw_sprite(spr_mar_walk_body3, ii, x, y);
    }
    if (trim == 0) {
        draw_sprite(spr_mar_walk_pauldron1, ii, x, y);
    }
    if (trim == 1) {
        draw_sprite(spr_mar_walk_pauldron2, ii, x, y);
    }
}
if (animation == "fire") {
    if (col_special == 0) {
        draw_sprite(spr_mar_walk_legs1, 0, x, y);
        draw_sprite(spr_mar_fire_body1, ii, x, y);
    }
    if (col_special == 1) {
        draw_sprite(spr_mar_walk_legs1, 0, x, y);
        draw_sprite(spr_mar_fire_body2, ii, x, y);
    }
    if (col_special == 2) {
        draw_sprite(spr_mar_walk_legs3, 0, x, y);
        draw_sprite(spr_mar_fire_body3, ii, x, y);
    }
    if (col_special == 3) {
        draw_sprite(spr_mar_walk_legs4, 0, x, y);
        draw_sprite(spr_mar_fire_body3, ii, x, y);
    }
    if (trim == 0) {
        draw_sprite(spr_mar_fire_pauldron1, ii, x, y);
    }
    if (trim == 1) {
        draw_sprite(spr_mar_fire_pauldron2, ii, x, y);
    }
}

if (wounded <= 0) {
    shader_reset();
}
// if (wounded>0) then d3d_set_fog(false,16645629,0,0);
if (wounded > 0) {
    d3d_set_fog(false, 255, 0, 0);
}

if (wounded > 0) {
    wounded -= 1;
}

/*
draw_set_color(0);
draw_set_font(fnt_small);
draw_set_halign(fa_left);
draw_text(x-150,y-16,"Ammo:"+string(marine_wep1_clip[8])+"("+string(marine_wep1_ammo[8])+"), Reload:"+string(marine_wep1_reload[8]));
*/

/* */
/*  */
