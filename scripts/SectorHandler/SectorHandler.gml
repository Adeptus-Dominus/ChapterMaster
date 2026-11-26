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

    static save_ignore_fields = [
        "warp_lanes",
        "player_base",
        "player_base_planet",
    ];

    static save = function() {
        var _copy = variable_clone(self);
        for (var i = 0; i < array_length(save_ignore_fields); i++){
            if (struct_exists(_copy , save_ignore_fields[i])){
                struct_remove(_copy, save_ignore_fields[i]);
            }
        }
        return _copy;
    };

    static player_base_location(use_cache = true){
        if (use_cache && instance_exists(obj_controller) &&__last_base_location_turn_check == obj_controller.turn){
            return player_base;
        }
        player_base = noone;
        player_base_planet = 0;
        player_base_feature = noone;
        if (obj_ini.fleet_type != ePLAYER_BASE.PENITENT){
            with (obj_star){
                var _mons = get_feature(eP_FEATURES.MONASTERY, false);
                for (var i = 0; i < array_length(_mons); i++){
                    var _mon = _mons[i];
                    if (_mon.player_controlled()){
                        player_base = id;
                        player_base_planet = _mon.planet;
                        player_base_feature = _mon;
                        obj_ini.fleet_type = ePLAYER_BASE.HOME_WORLD;
                    }
                }
            }
        }
        if (player_base == noone){
            player_base = get_largest_player_fleet();
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

        if (player_base == noone && instance_exists(obj_controller)){
            var _viewer = obj_controller.location_viewer;
            var _player_presence_stars = _viewer.player_force_stars(eARRAYORDER.LARGEST);
            if (array_length(_player_presence_stars) > 0){
                player_base = _player_presence_stars[0];
            }
        }
        if (player_base == noone){
            LOGGER.error("Can't find player cm, fortress monastery or any fleets, or planets with marine forces");
        }
        if (player_base_planet == 0 && obj_ini.fleet_type != ePLAYER_BASE.PENITENT){
            obj_ini.fleet_type = ePLAYER_BASE.FLEET_BASED;
        }
        __last_base_location_turn_check = instance_exists(obj_controller) ? obj_controller.turn : 0 ;
        return player_base;
    }
    LOGGER.info("SectorHandler successfully initialised");
}
