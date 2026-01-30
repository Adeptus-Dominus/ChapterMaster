function scr_text_hit(argument0, argument1, argument2, argument3) {
    // argument0: x1
    // argument1: y1
    // argument2: centered?
    // argument3: string

    var x9, y9, wid, hei, result;
    x9 = 0;
    y9 = 0;
    result = false;

    wid = string_width(string_hash_to_newline(argument3));
    hei = string_height(string_hash_to_newline(argument3));

    if (argument2 == false) {
        if ((mouse_x >= argument0) && (mouse_y >= argument1) && (mouse_x < argument0 + wid) && (mouse_y < argument1 + hei)) {
            result = true;
        }
    }
    if (argument2 == true) {
        x9 = argument0 - (wid / 2);

        if ((mouse_x >= x9) && (mouse_y >= argument1) && (mouse_x < x9 + wid) && (mouse_y < argument1 + hei)) {
            result = true;
        }
    }

    return result;
}
