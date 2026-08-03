// Check for industrial facilities
// Used to not have Ice either
/// @self Asset.GMObject.obj_star
function ork_ship_production(planet) {
    if (array_contains(["dead", "lava", "ice"], p_type[planet])) {
        exit;
    }
    // Have the proppa facilities and size
    if (p_orks[planet] >= 4) {
        if (instance_exists(obj_p_fleet)) {
            var nearestPlayerFleet = instance_nearest(x, y, obj_p_fleet);
            if ((point_distance(x, y, nearestPlayerFleet.x, nearestPlayerFleet.y) < 50) && (nearestPlayerFleet.action == "")) {
                exit;
            }
        }
        var _fleet = noone;
        if (instance_exists(obj_en_fleet)) {
            _fleet = scr_orbiting_fleet(eFACTION.ORK);
            if (_fleet != noone) {
                rando = choose(1, 1, 1, 1, 1, 2, 2, 2, 2);
                switch (rando) {
                    case 1:
                        _fleet.capital_number += 1;
                        break;
                    case 2:
                        _fleet.escort_number += 1;
                        break;
                }

                if (_fleet.image_index >= 5) {
                    var locationOk = false;

                    with (obj_star) {
                        if ((planets == 1) && (p_type[1] == "Dead")) {
                            instance_deactivate_object(id);
                        }
                    }
                    var nearestStar = instance_nearest(_fleet.x, _fleet.y, obj_star);
                    instance_deactivate_object(nearestStar);
                    var targetStar = noone;
                    for (var j = 0; j < 10; j++) {
                        if (!locationOk) {
                            targetStar = instance_nearest(_fleet.x + choose(random(400), random(400) * -1), _fleet.y + choose(random(100), random(100) * -1), obj_star);
                            if (targetStar.owner != eFACTION.ORK) {
                                locationOk = true;
                            }
                            // New code testing
                            if ((nearestStar.owner == eFACTION.ORK) && instance_exists(nearestStar)) {
                                if (nearestStar.present_fleet[7] > 0) {
                                    var fli = instance_nearest(nearestStar.x, nearestStar.y, obj_en_fleet);
                                    if ((fli.action == "") && (owner != eFACTION.ORK) && (point_distance(nearestStar.x, nearestStar.y, fli.x, fli.y) < 60)) {
                                        locationOk = true;
                                    }
                                    if ((fli.action == "") && (owner != eFACTION.ORK) && (point_distance(nearestStar.x, nearestStar.y, fli.x, fli.y) < 60)) {
                                        locationOk = true;
                                    }
                                }
                            } // End new code testing

                            if (targetStar.planets == 0) {
                                locationOk = false;
                            }
                            if ((targetStar.planets == 1) && (targetStar.p_type[1] == "Dead")) {
                                locationOk = false;
                            }
                        }
                    }
                    _fleet.action_x = targetStar.x;
                    _fleet.action_y = targetStar.y;
                    _fleet.alarm[4] = 1;
                    instance_activate_object(obj_star);
                }
            }
        }
        if ((_fleet == noone) && irandom_range(1, 100) <= 25) {
            // Create a fleet
            _fleet = create_enemy_fleet(x, y, eFACTION.ORK);
            _fleet.sprite_index = spr_fleet_ork;
            _fleet.image_index = 1;
            _fleet.capital_number = 2;
        }
    }
}

/// @self Struct.NewPlanetFeature
function kill_warboss() {
    f_type = eP_FEATURES.VICTORY_SHRINE;
    planet_display = $"{obj_controller.faction_leader[eFACTION.ORK]} Death Place";
}
