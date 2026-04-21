// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_count_marines_on_ship(ship_number) {
    var count = 0;

    for (var company = 0; company <= 10; company++) {
        for (var marine = 1; marine <= 400; marine++) {
            if (obj_ini.name[company][marine] != "") {
                if (obj_ini.TTRPG[company][marine].ship_location == ship_number) {
                    count++;
                }
            }
        }
    }
    return count;
}
