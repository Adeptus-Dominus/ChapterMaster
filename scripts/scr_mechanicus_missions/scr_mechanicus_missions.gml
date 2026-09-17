function spawn_mechanicus_mission(chosen_mission = "random") {
    LOGGER.info("RE: Mechanicus Mission");
    var mechanicus_missions = [];
    var _evented;

    var _forge_stars = scr_get_stars(false, [eFACTION.MECHANICUS], ["Forge"]);

    if (array_length(_forge_stars)) {
        array_push(mechanicus_missions, "mech_bionics");
        if (scr_role_count(obj_ini.player_role_data[eROLE.TECHMARINE].role, "") >= 6) {
            array_push(mechanicus_missions, "mech_raider");
        }
    }

    with (obj_star) {
        if (scr_star_has_planet_with_feature(id, eP_FEATURES.NECRON_TOMB) && (awake_necron_star(id) != 0)) {
            var planet = scr_get_planet_with_feature(id, eP_FEATURES.NECRON_TOMB);
            if (scr_is_planet_owned_by_allies(self, planet)) {
                array_push(mechanicus_missions, "mech_tomb");
                break;
            }
        }
    }

    if (obj_controller.disposition[eFACTION.MECHANICUS] >= 70) {
        array_push(mechanicus_missions, "mech_mars");
    }

    var mission_count = array_length(mechanicus_missions);
    if (mission_count == 0 && chosen_mission == "random") {
        LOGGER.error("RE: Mechanicus Mission, couldn't pick mission");
        exit;
    }

    if (chosen_mission == "random") {
        chosen_mission = array_random_element(mechanicus_missions);
    }

    if (chosen_mission == "mech_bionics" || chosen_mission == "mech_raider" || chosen_mission == "mech_mars") {
        if (array_length(_forge_stars) == 0) {
            LOGGER.error("RE: Mechanicus Mission, couldn't find a mechanicus forge world");
            exit;
        }

        var star = array_random_element(_forge_stars);
        var text = "";
        var _mission_data = {
            star: star.id,
        };
        var _name = star.name;
        if (chosen_mission == "mech_raider") {
            text = $"The Adeptus Mechanicus are trusting you with a special mission.  They wish for you to bring a Land Raider and six {obj_ini.player_role_data[eROLE.TECHMARINE].role} to a Forge World in {_name} for testing and training, for a duration of 24 months. You have four years to complete this.  Can your chapter handle this mission?";
            _mission_data.options = [
                {
                    str1: "Accept",
                    choice_func: accept_mechanicus_land_raider_mission,
                },
                {
                    str1: "Refuse",
                    choice_func: popup_default_close,
                },
            ];
            _evented = true;
        } else if (chosen_mission == "mech_bionics") {
            text = $"The Adeptus Mechanicus are trusting you with a special mission.  They desire a squad of Astartes with bionics to stay upon a Forge World in {_name} for testing, for a duration of 24 months.  You have four years to complete this.  Can your chapter handle this mission?";
            _mission_data.options = [
                {
                    str1: "Accept",
                    choice_func: accept_mechanicus_bionics_mission,
                },
                {
                    str1: "Refuse",
                    choice_func: popup_default_close,
                },
            ];
            _evented = true;
        } else {
            text = $"The local Adeptus Mechanicus are preparing to embark on a voyage to Mars, to delve into the catacombs in search of lost technology.  Due to your close relations they have made the offer to take some of your {obj_ini.player_role_data[eROLE.TECHMARINE].role}s with them for both their unique abilities to function as both scientific helpers and as helpers (high Weapon Skill and Technology is reccomended).  Can your chapter handle this mission?";
            _mission_data.options = [
                {
                    str1: "Accept",
                    choice_func: accept_mechanicus_mars_mission,
                },
                {
                    str1: "Refuse",
                    choice_func: popup_default_close,
                },
            ];
            _evented = true;
        }
        if (_evented) {
            scr_popup("Mechanicus Mission", text, "mechanicus", _mission_data);
        }
        //LOGGER.debug(_mission_data);
    } else if (chosen_mission == "mech_tomb") {
        LOGGER.info("RE: Necron Tomb Study");
        stars = scr_get_stars();
        var valid_stars = array_filter_ext(stars, function(star, index) {
            if (scr_star_has_planet_with_feature(star, eP_FEATURES.NECRON_TOMB) && (awake_necron_star(star) != 0)) {
                var planet = scr_get_planet_with_feature(star, eP_FEATURES.NECRON_TOMB);
                if (scr_is_planet_owned_by_allies(star, planet)) {
                    return true;
                }
            }
            return false;
        });

        if (array_length(valid_stars) == 0) {
            LOGGER.error("RE: Necron Tomb Study, coudln't find a tomb world under imperium control");
            exit;
        }
        var star = array_random_element(valid_stars);
        var _mission_data = {
            star: star.id,
            pathway_id: chosen_mission,
        };
        _mission_data.options = [
            {
                str1: "Accept",
                choice_func: accept_mechanicus_tomb_mission,
            },
            {
                str1: "Refuse",
                choice_func: popup_default_close,
            },
        ];
        var text = $"Mechanicus Techpriests have established a research site on a Necron Tomb World in the {star.name} system.  They are requesting some of your forces to provide security for the research team until the tests may be completed.  Further information is on a need-to-know basis.  Can your chapter handle this mission?";
        scr_popup("Mechanicus Mission", text, "mechanicus", _mission_data);
        _evented = true;
    }
    return _evented;
}

/// @self Asset.GMObject.obj_popup
function accept_mechanicus_tomb_mission() {
    var _planet = false;
    var _star = pop_data.star;
    for (var i = 1; i < _star.planets; i++) {
        if (awake_tomb_world(_star.p_feature[i]) != 0) {
            _planet = i;
            break;
        }
    }
    if (_planet > 0) {
        _planet = _star.get_planet_data(_planet);
        _planet.new_problem("mech_tomb", 17, {stage : "awating_player"});
        var _name = _planet.name();
        text = $"The Adeptus Mechanicus await your forces at {_name}.  They are expecting at least two squads of Astartes and have placed the testing on hold until their arrival.  {global.chapter_name} have 16 months to arrive.";
        scr_event_log("", "Mechanicus Mission Accepted: At least two squads of marines are expected at {_name} within 16 months.", _star.name);
        with (_star) {
            new_star_event_marker("green");
        }
        title = "Mechanicus Mission Accepted";
        reset_popup_options();
        cooldown = 15;
        exit;
    }
}

/// @self Asset.GMObject.obj_popup
function accept_mechanicus_land_raider_mission() {
    var _star = pop_data.star;
    var _forge_planet = scr_get_planet_with_type(_star, "Forge");
    if (_forge_planet > 0) {
        var _planet = _star.get_planet_data(_forge_planet);

        var _mission_loc = _planet.name();
        var _nearest_fleet = instance_nearest(_star.x, _star.y, obj_p_fleet);
        var _mission_time = get_viable_travel_time(5, _nearest_fleet.x, _nearest_fleet.y, _star.x, _star.y, _nearest_fleet, false);

        _planet.new_problem("mech_raider", _mission_time, {completion: 0, required_months: 24});
        text = $"The Adeptus Mechanicus await your forces at {_mission_loc}.  They are expecting six {obj_ini.player_role_data[eROLE.TECHMARINE].role}s and a Land Raider.";
        scr_event_log("", $"Mechanicus Mission Accepted: Six of your {obj_ini.player_role_data[eROLE.TECHMARINE].role}s and a Land Raider are to be stationed at {_mission_loc} for {_mission_time} months.", _star.name);
        with (_star) {
            new_star_event_marker("green");
        }
        title = "Mechanicus Mission Accepted";
    } else {
        text = $"Error valid forge planet not found please open a bug report if seen";
    }
    reset_popup_options();
}

/// @self Asset.GMObject.obj_popup
function accept_mechanicus_bionics_mission() {
    var _star = pop_data.star;
    var _forge_planet = scr_get_planet_with_type(_star, "Forge");
    if (_forge_planet > 0) {
        var _planet = _star.get_planet_data(_forge_planet);

        var _mission_loc = _planet.name();
        var _nearest_fleet = instance_nearest(_star.x, _star.y, obj_p_fleet);
        var _mission_time = get_viable_travel_time(5, _nearest_fleet.x, _nearest_fleet.y, _star.x, _star.y, _nearest_fleet, false);

        _planet.new_problem("mech_bionics", _mission_time, {completion: 0, required_months: 24});
        text = $"The Adeptus Mechanicus await your forces at {_mission_loc}.  They are expecting ten Astartes with bionics. (Beneficial traits: Weakness of Flesh )";
        scr_event_log("", $"Mechanicus Mission Accepted: Ten Astartes with bionics are to be stationed at {_mission_loc} for 24 months for testing purposes.", _star.name);
        with (_star) {
            new_star_event_marker("green");
        }
        title = "Mechanicus Mission Accepted";
    } else {
        text = $"Error valid forge planet not found please open a bug report if seen";
    }
    reset_popup_options();
}

/// @self Asset.GMObject.obj_popup
function accept_mechanicus_mars_mission() {
    var _star = pop_data.star;
    var _forge_planet = scr_get_planet_with_type(_star, "Forge");
    if (_forge_planet > 0) {
        var _planet = _star.get_planet_data(_forge_planet);

        var _mission_loc = _planet.name();
        var _nearest_fleet = instance_nearest(_star.x, _star.y, obj_p_fleet);
        var _mission_time = get_viable_travel_time(5, _nearest_fleet.x, _nearest_fleet.y, _star.x, _star.y, _nearest_fleet, false);

        _planet.new_problem("mech_bionics", _mission_time, {completion: 0, required_months: 24});
        _planet.new_problem("mech_mars", _mission_time);
        text = $"The Adeptus Mechanicus await your {obj_ini.player_role_data[eROLE.TECHMARINE].role}s at {_mission_loc}.  They are willing to hold on the voyage for up to {_mission_time} months.";
        scr_event_log("", $"Mechanicus Mission Accepted: {obj_ini.player_role_data[eROLE.TECHMARINE].role}s are expected at {_mission_loc} within 30 months, for the voyage to Mars.", _star.name);
        with (_star) {
            new_star_event_marker("green");
        }
        title = "Mechanicus Mission Accepted";
        reset_popup_options();
    } else {
        text = $"Error valid forge planet not found please open a bug report if seen";
    }
    reset_popup_options();
}

/// @self Asset.GMObject.obj_star
function mechanicus_mars_mission_target_time_elapsed(planet) {
    var techs_taken, com, ide, ship_planet, _unit;
    techs_taken = 0;
    com = -1;
    ide = 0;
    ship_planet = "";
    for (com = 0; com <= 10; com++) {
        for (ide = 0; ide < array_length(obj_ini.TTRPG[com]); ide++) {
            _unit = fetch_unit([com, ide]);
            if (!is_struct(_unit)) {
                continue;
            }
            if (_unit.role() == obj_ini.player_role_data[eROLE.TECHMARINE].role) {
                // Case 1: on planet
                if ((_unit.location_string == name) && (_unit.planet_location == planet)) {
                    p_player[planet] -= _unit.get_unit_size();
                    _unit.location_string = "Mechanicus Vessel";
                    _unit.planet_location = 0;
                    _unit.ship_location = -1;
                    _unit.job = {
                        type: "mechanicus mission",
                    };
                    techs_taken += 1;
                }
                if (_unit.ship_location > -1) {
                    ship_planet = obj_ini.ship_location[_unit.ship_location];
                    if (ship_planet == name) {
                        obj_ini.ship_carrying[_unit.ship_location] -= _unit.get_unit_size();
                        _unit.location_string = "Mechanicus Vessel";
                        _unit.planet_location = 0;
                        _unit.ship_location = -1;
                        _unit.job = {
                            type: "mechanicus mission",
                        };
                        techs_taken += 1;
                    }
                }
            }
        }
    }
    if (techs_taken == 0) {
        var alert_text = $"Mechanicus Mission Failed: Journey to Mars Catacombs at {planet_numeral_name(planet, id)}.";
        scr_alert("red", "mission_failed", alert_text, 0, 0);
        scr_event_log("red", alert_text);
        obj_controller.disposition[3] -= 10;
        remove_planet_problem(planet, "mech_mars");
    } else if (techs_taken > 0) {
        if (techs_taken >= 5) {
            obj_controller.disposition[3] += max(techs_taken, 4);
        }
        var _text = $"Mechanicus Ship departs for the Mars catacombs.  Onboard are {techs_taken} of your {obj_ini.player_role_data[eROLE.TECHMARINE].role}s.";
        scr_alert("", "mission", _text, 0, 0);
        scr_event_log("green", _text);
        var flit = create_enemy_fleet(x, y, eFACTION.MECHANICUS);

        with (flit) {
            sprite_index = spr_fleet_mechanicus;
            capital_number = 1;
            image_index = 0;
            image_speed = 0;
            trade_goods = "mars_spelunk1";
            home_x = x;
            home_y = y;
            action_x = x + lengthdir_x(3000, obj_controller.terra_direction);
            action_y = y + lengthdir_y(3000, obj_controller.terra_direction);
            set_fleet_movement(false, "move", 48, 48);
        }
    }
}
