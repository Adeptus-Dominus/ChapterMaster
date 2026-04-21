function scr_display_number(argument0) {
    var length, newstring;
    length = string_length(string(argument0));
    newstring = "";
    for (i = length; i >= 1; i -= 1) {
        newstring = string(string_char_at(string(argument0), i) + string(newstring));
        if ((length - i) % 3 == 2 && i != 1) {
            newstring = string("," + string(newstring));
        }
    }
    return newstring;
}
