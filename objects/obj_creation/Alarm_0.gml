shader_reset();

colour_to_find1 = shader_get_uniform(sReplaceColor, "f_Colour1");
colour_to_set1 = shader_get_uniform(sReplaceColor, "f_Replace1");
body_colour_find = [
    0 / 255,
    0 / 255,
    255 / 255
];
body_colour_replace = [
    col_r[main_color] / 255,
    col_g[main_color] / 255,
    col_b[main_color] / 255
];

colour_to_find2 = shader_get_uniform(sReplaceColor, "f_Colour2");
colour_to_set2 = shader_get_uniform(sReplaceColor, "f_Replace2");
secondary_colour_find = [
    255 / 255,
    0 / 255,
    0 / 255
];
secondary_colour_replace = [
    col_r[secondary_color] / 255,
    col_g[secondary_color] / 255,
    col_b[secondary_color] / 255
];

colour_to_find3 = shader_get_uniform(sReplaceColor, "f_Colour3");
colour_to_set3 = shader_get_uniform(sReplaceColor, "f_Replace3");

pauldron_colour_find = [
    255 / 255,
    255 / 255,
    0 / 255
];
pauldron_colour_replace = [
    col_r[right_pauldron] / 255,
    col_g[right_pauldron] / 255,
    col_b[right_pauldron] / 255
];

colour_to_find4 = shader_get_uniform(sReplaceColor, "f_Colour4");
colour_to_set4 = shader_get_uniform(sReplaceColor, "f_Replace4");
lens_colour_find = [
    0 / 255,
    255 / 255,
    0 / 255
];
lens_colour_replace = [
    col_r[lens_color] / 255,
    col_g[lens_color] / 255,
    col_b[lens_color] / 255
];

colour_to_find5 = shader_get_uniform(sReplaceColor, "f_Colour5");
colour_to_set5 = shader_get_uniform(sReplaceColor, "f_Replace5");
trim_colour_find = [
    255 / 255,
    0 / 255,
    255 / 255
];
trim_colour_replace = [
    col_r[main_trim] / 255,
    col_g[main_trim] / 255,
    col_b[main_trim] / 255
];

colour_to_find6 = shader_get_uniform(sReplaceColor, "f_Colour6");
colour_to_set6 = shader_get_uniform(sReplaceColor, "f_Replace6");
pauldron2_colour_find = [
    250 / 255,
    250 / 255,
    250 / 255
];
pauldron2_colour_replace = [
    col_r[left_pauldron] / 255,
    col_g[left_pauldron] / 255,
    col_b[left_pauldron] / 255
];

colour_to_find7 = shader_get_uniform(sReplaceColor, "f_Colour7");
colour_to_set7 = shader_get_uniform(sReplaceColor, "f_Replace7");

weapon_colour_find = [
    0 / 255,
    255 / 255,
    255 / 255
];
weapon_colour_replace = [
    col_r[weapon_color] / 255,
    col_g[weapon_color] / 255,
    col_b[weapon_color] / 255
];
