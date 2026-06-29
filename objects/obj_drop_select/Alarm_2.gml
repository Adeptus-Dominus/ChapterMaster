ship = array_create(31, "");
ship_all = array_create(31, 0);
ship_use = array_create(31, 0);
ship_max = array_create(31, 0);
ship_ide = array_create(31, -1);

max_ships = 0;
if (sh_target != noone) {
    max_ships = sh_target.capital_number + sh_target.frigate_number + sh_target.escort_number;
}

if (ship_max[500] != 0) {
    max_ships += 1;
}

ship_all[500] = 0;
ship_use[500] = 0;
if (l_size > 0) {
    l_size = l_size * -1;
}

if (sh_target != noone) {
    var i = 0;
    for (var s = 0; s < sh_target.capital_number; s++) {
        if ((sh_target.capital[s] != "") && (obj_ini.ship_carrying[sh_target.capital_num[s]] > 0)) {
            ship[i] = sh_target.capital[s];
            ship_use[i] = 0;
            var tump = sh_target.capital_num[s];
            ship_max[i] = obj_ini.ship_carrying[tump];
            ship_ide[i] = tump;
            ship_size[i] = 3;
            i += 1;
        }
    }
    for (var s = 0; s < sh_target.frigate_number; s++) {
        if ((sh_target.frigate[s] != "") && (obj_ini.ship_carrying[sh_target.frigate_num[s]] > 0)) {
            ship[i] = sh_target.frigate[s];
            ship_use[i] = 0;
            var tump = sh_target.frigate_num[s];
            ship_max[i] = obj_ini.ship_carrying[tump];
            ship_ide[i] = tump;
            ship_size[i] = 2;
            i += 1;
        }
    }
    for (var s = 0; s < sh_target.escort_number; s++) {
        if ((sh_target.escort[s] != "") && (obj_ini.ship_carrying[sh_target.escort_num[s]] > 0)) {
            ship[i] = sh_target.escort[s];
            ship_use[i] = 0;
            var tump = sh_target.escort_num[s];
            ship_max[i] = obj_ini.ship_carrying[tump];
            ship_ide[i] = tump;
            ship_size[i] = 1;
            i += 1;
        }
    }
}
