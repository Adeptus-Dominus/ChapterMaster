function scr_count_marines_on_ship(ship_number) {
    var count = 0;
    for (var company = 0; company <= 10; company++) {
        var _company_size = array_length(obj_ini.TTRPG[company]);
        for (var marine = 0; marine < _company_size; marine++) {
            var _unit = fetch_unit([company, marine]);
            if (is_struct(_unit) && _unit.ship_location == ship_number) {
                count++;
            }
        }
    }
    return count;
}
