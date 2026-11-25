function SectorHandler() constructor {
    millenium = 41;
    year_fraction = 0;
    year = 735;
    check_number = 5;
    warp_lanes = new WarpLaneHandler();
    player_base = noone;
    player_base_planet = 0;
    __last_base_location_turn_check = 0;

    static date = function() {
        var _yf = "";
        if (year_fraction < 10) {
            _yf = "00" + string(year_fraction);
        }
        if ((year_fraction >= 10) && (year_fraction < 100)) {
            _yf = "0" + string(year_fraction);
        }
        if (year_fraction >= 100) {
            _yf = string(year_fraction);
        }
        return $"{check_number} {_yf} {year}.M{millenium}";
    };

    static game_year = function() {
        return (millenium * 1000) + year;
    };

    static increment_date = function() {
        year_fraction += 84;
        if (year_fraction > 999) {
            year += 1;
            year_fraction = 0;
        }
        if (year >= 1000) {
            millenium += 1;
            year -= 1000;
        }
    };

    static get_time_from_current_year = function(age_from_year) {
        return game_year() - age_from_year;
    };

    static get_creation_year = function(age) {
        return game_year() - age;
    };

    static save = function() {
        var _copy = variable_clone(self);
        struct_remove(_copy, "warp_lanes");
        return _copy;
    };

    static player_base_location(use_cache = true){
        if (__last_base_location_turn_check == obj_controller && use_cache){
            return player_base;
        }
        player_base = noone;
        player_base_planet = 0;
        if (obj_ini.fleet_type != ePLAYER_BASE.PENITENT){
            with (obj_star){
                var _mons = get_feature(eP_FEATURES.MONASTERY, false);
                for (var i = 0; i < array_length(_mons); i++){
                    var _mon = _mons[i];
                    if (_mon.player_controlled()){
                        player_base = id;
                        player_base_planet = _mon.planet;
                        obj_ini.fleet_type = ePLAYER_BASE.HOME_WORLD;
                    }
                }
            }
        }
        if (player_base == noone){
            player_base = get_largest_player_fleet();
            obj_ini.fleet_type = ePLAYER_BASE.FLEET_BASED;
        }

        if (player_base == noone){
            var _star_with_player_control = noone;
            with (obj_star) {
                if (array_contains(p_owner, eFACTION.PLAYER)) {
                    _star_with_player_control = id;
                }
            }

            player_base = _star_with_player_control;
        }
        if (player_base == noone){
            var _cm = cm_obj().get_struct();
            var _cm_loc = _cm.marine_location()
            if (_cm_loc[0] == eLOCATION_TYPES.PLANET){
                player_base = find_star_by_name(_cm_loc[2]);
            } else if (_cm_loc[0] == eLOCATION_TYPES.SHIP) {
                player_base = find_ship_fleet(_cm_loc[1]);
            }
        }
        if (player_base == noone){
            LOGGER.error("Can't fins player cm, fortress monastery or any fleets");
        }
        return player_base;
    }
    __last_base_location_turn_check = obj_controller.turn;
    LOGGER.info("SectorHandler successfully initialised");
}
