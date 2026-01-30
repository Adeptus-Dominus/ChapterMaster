function clean_tags(argument0) {
    var t1, t2, t3, t4, t5;
    t1 = string_pos("&", argument0);
    if (t1 > 0) {
        t2 = string_reverse(argument0);
        t3 = string_pos("|", t2);
        t2 = string_delete(t2, t3, 1);
        t2 = string_insert("@", t2, t3);
        t2 = string_reverse(t2);

        t3 = string_pos("@", t2) - string_pos("&", t2);
        t4 = string_delete(t2, t1, t3);
        t4 = string_replace(t4, "@", "");

        t5 = "Arti. " + string(t4);

        return t5;
    }
    if (t1 == 0) {
        return argument0;
    }
}
