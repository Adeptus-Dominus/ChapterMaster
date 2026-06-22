ship = array_create(61, "");
ship_all = array_create(61, 0);
ship_use = array_create(61, 0);
ship_max = array_create(61, 0);
ship_ide = array_create(61, -1);

max_ships = 0;

if (sh_target != -50) {
    max_ships = sh_target.capital_number + sh_target.frigate_number + sh_target.escort_number;

    var i = 0;
    for (var s = 1; s <= sh_target.capital_number; s++) {
        if (sh_target.capital[s] != "") {
            i += 1;
            ship[i] = sh_target.capital[s];

            ship_use[i] = 0;
            var tump = sh_target.capital_num[s];
            ship_max[i] = obj_ini.ship_carrying[tump];
            ship_ide[i] = tump;
            ship_size[i] = 3;

            purge_a += 3;
            purge_b += ship_max[i];
            purge_c += ship_max[i];
        }
    }
    for (var s = 1; s <= sh_target.frigate_number; s++) {
        if (sh_target.frigate[s] != "") {
            i += 1;
            ship[i] = sh_target.frigate[s];

            ship_use[i] = 0;
            var tump = sh_target.frigate_num[s];
            ship_max[i] = obj_ini.ship_carrying[tump];
            ship_ide[i] = tump;
            ship_size[i] = 2;

            purge_a += 1;
            purge_b += ship_max[i];
            purge_c += ship_max[i];
        }
    }
    for (var s = 1; s <= sh_target.escort_number; s++) {
        if ((sh_target.escort[s] != "") && (obj_ini.ship_carrying[sh_target.escort_num[s]] > 0)) {
            i += 1;
            ship[i] = sh_target.escort[s];

            ship_use[i] = 0;
            var tump = sh_target.escort_num[s];
            ship_max[i] = obj_ini.ship_carrying[tump];
            ship_ide[i] = tump;
            ship_size[i] = 1;

            purge_b += ship_max[i];
            purge_c += ship_max[i];
        }
    }
}
