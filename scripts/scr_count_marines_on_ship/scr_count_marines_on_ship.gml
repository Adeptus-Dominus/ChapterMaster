function scr_count_marines_on_ship(ship_number) {
    var count = 0;
    for (var company = 0; company <= 10; company++) {
        var _company_size = array_length(obj_ini.TTRPG[company]);
        for (var marine = 1; marine < _company_size; marine++) {
            if (obj_ini.name[company][marine] != "") {
                if (obj_ini.TTRPG[company][marine].ship_location == ship_number) {
                    count++;
                }
            }
        }
    }
    return count;
}
