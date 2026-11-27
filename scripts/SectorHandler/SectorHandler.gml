function SectorHandler() constructor {
    millenium = 41;
    year_fraction = 0;
    year = 735;
    check_number = 5;
    warp_lanes = new WarpLaneHandler();
    player_base = noone;
    player_base_planet = 0;
    player_base_feature = noone;
    __last_base_location_turn_check = 0;;

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
        "player_base_feature",
        "helpful_places",
        "helpful_places_button"
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



    helpful_places_button = new UnitButtonObject({
        style: "pixel",
        label: "System Data",
    });
    ] = noone;
    static refresh_helpful_places = function(){
        if (helpful_places != noone) {
            helpful_places = new HelpfulPlaces();
        }        
    }

    static toggle_helpful_places = function(){  
        helpful_places = helpful_places == noone ? new HelpfulPlaces() : noone;
    }
    static ensure_helpful_places = function(){
        helpful_places == noone ? toggle_helpful_places() : refresh_helpful_places();
        return helpful_places;
    }

    static draw_helpful_places = function(){
        helpful_places_button.update({x1: 1451, y1: 62 + sprite_get_height(spr_new_banner)});

        if (helpful_places_button.draw()) {
            obj_ini.sector_handler.refresh_helpful_places();
        }
        if (helpful_places_drawable()) {
            helpful_places.draw();
        }        
    }

    static helpful_places_drawable = function(){helpful_places != noone && !instances_exist_any([obj_turn_end, obj_ncombat, obj_fleet, obj_popup, obj_star_select])}

    LOGGER.info("SectorHandler successfully initialised");
}


function HelpfulPlaces() constructor {
    main_panel = new DataSlate({
        draggable: true,
        cherub: true,
    });
    var _imperial_help_requests = stars_with_help_requests();

    var _help_requests = [];

    for (var i = 0; i < array_length(_imperial_help_requests); i++) {
        var _star = _imperial_help_requests[i];
        var _data = {
            name: _star.name,
            star_id: _star,
            system_count: _star.planets,
        };

        var _helps = 0;
        for (var h = 1; h <= _star.planets; h++) {
            if (_star.p_halp[h] > 0) {
                _helps++;
            }
        }
        _data.help_requests = _helps;

        _data.hover = method(_data, function() {
            tooltip_draw(localize("View {0}", [name]));
        });

        _data.click_left = method(_data, function() {
            set_map_pan_to_loc(star_id);
        });

        array_push(_help_requests, _data);
    }

    static x1 = 1289;
    static y1 = 318;
    main_panel.XX = x1;
    main_panel.YY = y1;

    static entered = function() {
        return main_panel.entered();
    };

    help_table = new Table({
        row_key_draw: ["name", "system_count", "help_requests"],
        headings: ["System", "Planets", "Planets\nRequesting Help"],
        row_data: _help_requests,
        localize_headings: true,
    });

    var _navy_fleets = [];

    with (obj_en_fleet) {
        if (owner != eFACTION.IMPERIUM || !navy) {
            continue;
        }
        var _guard_percentage = fleet_remaining_guard_ratio() * 100;

        var _data = {
            fleet_id: id,
            location: fleet_location_description(self).loc,
            remaining_guard: $"{_guard_percentage}%",
            action: trade_goods,
        };

        _data.hover = method(_data, function() {
            if (location != "Warp") {
                tooltip_draw(localize("View fleet at {0}", [location]));
            } else {
                tooltip_draw(localize("View fleet"));
            }
        });

        _data.click_left = method(_data, function() {
            set_map_pan_to_loc(fleet_id);
        });

        array_push(_navy_fleets, _data);
    }

    navy_table = new Table({
        row_key_draw: ["location", "remaining_guard"],
        headings: ["Location", "Remaining\nGuard"],
        row_data: _navy_fleets,
        localize_values: true,
        localize_headings: true,
    });

    var _forges = [];

    var _columns = [];
    var _longest_name = 0;
    with (obj_star) {
        var _forge = scr_get_planet_with_type(id, "Forge");
        if (_forge > 0) {
            var _data = {
                system: id,
                planet: _forge,
                name: planet_numeral_name(_forge, id),
                owner_name: obj_controller.faction[p_owner[_forge]],
                owner: p_owner[_forge],
                owner_status: obj_controller.faction_status[p_owner[_forge]],
            };

            _data.click_left = method(_data, function() {
                set_map_pan_to_loc(system);
            });

            _data.hover = method(_data, function() {
                tooltip_draw(localize("click to view {0} system", [system.name]));
            });

            var _name_length = string_width(_data.name);
            if (_name_length > _longest_name) {
                _longest_name = _name_length;
            }

            array_push(_forges, _data);
        }
    }
    array_push(_columns, _longest_name);

    forges_table = new Table({
        row_key_draw: ["name", "owner_name", "owner_status"],
        headings: ["Name", "   Owner   ", "  Owner\nStatus  "],
        row_data: _forges,
        set_column_widths: _columns,
        localize_values: true,
        localize_headings: true,
    });

    places_radio = new RadioSet(
        [
            {
                str1: "Help Requests",
            },
            {
                str1: "Navy Fleets",
            },
            {
                str1: "Forge Worlds",
            },
        ],
    );

    main_panel.inside_method = function() {
        places_radio.update({x1: x1 + 30, y1: y1 + 25});
        places_radio.draw();

        var _new_position = {
            x1: x1 + 40,
            y1: y1 + 50,
            y2: y1 + main_panel.height,
        };
        switch (places_radio.current_selection) {
            case 1:
                navy_table.update(_new_position);
                navy_table.draw();
                break;
            case 0:
                help_table.update(_new_position);
                help_table.draw();
                break;
            case 2:
                forges_table.update(_new_position);
                forges_table.draw();
                break;
        }
    };

    static draw = function() {
        x1 = main_panel.XX;
        y1 = main_panel.YY;
        main_panel.draw(x1, y1, 0.35, 0.6);
    };
}
