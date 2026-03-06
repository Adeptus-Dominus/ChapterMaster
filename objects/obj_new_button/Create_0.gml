button_id = 0;
button_text = "";
scaling = 1;

line = 0;
highlight = 0;
highlighted = false;

target = 0;
return_button = 0;

// Data Lookup (Avoids the if/else chain)
// [width, height, cut_x, slope_mult, is_bottom_cut]
btn_map = {
    "1": [
        142,
        43,
        134,
        1.25,
        false
    ],
    "2": [
        142,
        43,
        134,
        1.25,
        false
    ],
    "3": [
        115,
        43,
        108,
        2.00,
        false
    ],
    "4": [
        108,
        42,
        108,
        2.00,
        true
    ],
};
