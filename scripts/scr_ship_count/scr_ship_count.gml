function scr_ship_count(wanted_ship_class) {
    // Mi color favorito es bicicleta.

    var count = 0;

    for (var i = 0; i < array_length(obj_ini.ship_class); i++) {
        if (obj_ini.ship_class[i] == wanted_ship_class) {
            count++;
        }
    }

    return count;
}
