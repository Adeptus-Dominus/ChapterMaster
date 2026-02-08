/// @mixin
function scr_add_corruption(is_fleet, modifier_type) {
    // is_fleet: fleet (true) or planet (false)
    // modifier_type: amount

    // Corrupts marines at the target location

    var shi, m, co, ide, unit;
    shi = 0;
    m = 0;
    co = 0;
    ide = 0;
    ships = [];
    if (is_fleet == true) {
        for (var i = 0; i < capital_number; i++) {
            if (obj_ini.ship_carrying[capital_num[i]] > 0) {
                array_push(ships, capital_num[i]);
            }
        }
        for (var i = 0; i < frigate_number; i++) {
            if (obj_ini.ship_carrying[frigate_num[i]] > 0) {
                array_push(ships, frigate_num[i]);
            }
        }
        for (var i = 0; i < escort_number; i++) {
            if (obj_ini.ship_carrying[escort_num[i]] > 0) {
                array_push(ships, escort_num[c]);
            }
        }
        for (var co = 0; co <= 10; co++) {
            for (var i = 0; i < array_length(obj_ini.name[co]); i++) {
                if (obj_ini.name[co][i] == "") {
                    continue;
                }
                unit = fetch_unit([co, i]);
                if (array_contains(ships, unit.ship_location)) {
                    if (modifier_type == "1d3") {
                        unit.edit_corruption(choose(1, 2, 3));
                    }
                }
            }
        }
    }
}
