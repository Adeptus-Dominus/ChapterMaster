if ((global.load >= 0) || instance_exists(obj_saveload)) {
    exit;
}

if ((action != "") && (orbiting != 0)) {
    if (instance_exists(orbiting)) {
        if (variable_instance_exists(orbiting, "present_fleet")) {
            orbiting.present_fleet[owner] -= 1;
            orbiting = 0;
        } else {
            orbiting = instance_nearest(x, y, obj_star);
            var cur_owner_fleet = orbiting.present_fleet[owner];
            orbiting.present_fleet[owner] = cur_owner_fleet > 0 ? cur_owner_fleet - 1 : cur_owner_fleet == 0;
            orbiting = 0;
        }
    }
}

if (capital_number < 0) {
    capital_number = 0;
}
if (frigate_number < 0) {
    frigate_number = 0;
}
if (escort_number < 0) {
    escort_number = 0;
}

if ((owner != eFACTION.INQUISITION) && (capital_number + frigate_number + escort_number <= 0) && !fleet_has_cargo("colonize")) {
    instance_destroy();
}

if ((owner == eFACTION.TAU) && (x < 0) || (y < 0)) {
    instance_destroy();
}

if ((target > 0) && instance_exists(target)) {
    target_x = target.x;
    target_y = target.y;
}

ii_check -= 1;

if (ii_check == 0) {
    ii_check = 10;

    if ((owner != eFACTION.ELDAR) && (owner != eFACTION.INQUISITION)) {
        var ii = 0;
        ii += capital_number;
        ii += round((frigate_number / 2));
        ii += round((escort_number / 4));
        if (ii <= 1) {
            ii = 1;
        }
        image_index = ii;
        image_index = min(image_index, 9);
    }
    if (owner == eFACTION.ELDAR) {
        var ii;
        ii = 0;
        ii += capital_number;
        ii += round((frigate_number / 2));
        ii += round((escort_number / 4));
        if (ii <= 1) {
            ii = 1;
        }
        image_index = ii;
        image_index = min(image_index, 5);
    }
    if (owner == eFACTION.INQUISITION) {
        image_index = 1;
    }
}

if (owner == eFACTION.TYRANIDS) {
    image_alpha = 0;
    if (instance_exists(obj_p_fleet)) {
        var bundy;
        bundy = instance_nearest(x, y, obj_p_fleet);
        if ((bundy.action == "") && (self.action == "") && (point_distance(bundy.x, bundy.y, x, y) < 90) && (bundy.x > x) && (bundy.y < y)) {
            image_alpha = 1;
        }
    }
    if ((instance_nearest(x, y - 32, obj_star).vision == 1) && (action == "")) {
        image_alpha = 1;
    }
}

if ((owner == eFACTION.TAU) && (action_spd != 32)) {
    action_spd = 32;
}
// if (owner = eFACTION.TAU) and (image_index>1)
if (owner == eFACTION.MECHANICUS) {
    if (action != "") {
        direction = point_direction(x, y, action_x, action_y);
    }
    image_angle = direction;
}
if ((owner == eFACTION.ELDAR) && (trade_goods != "") && (action == "move")) {
    action_eta = 1;
}

if ((owner == eFACTION.TAU) && (action == "") && (obj_controller.tau_messenger >= 30) && (frigate_number > 0) && (escort_number + capital_number > 0)) {
    obj_controller.tau_messenger = 0;

    var fleet, good, stir, xx, yy;
    stir = 0;
    xx = 0;
    yy = 0;
    good = 0;

    fleet = instance_nearest(x, y, obj_star);
    fleet.tau_fleets += 1;
    fleet.present_fleets += 1;
    instance_deactivate_object(fleet);

    fleet = instance_create(x, y, obj_en_fleet);
    fleet.owner = eFACTION.TAU;
    fleet.action_spd = 32;
    fleet.frigate_number = 1;
    fleet.sprite_index = spr_fleet_tau;
    fleet.image_index = 1;
    frigate_number -= 1;

    repeat (50) {
        if (good == 0) {
            xx = x + round(choose(random(500), random(500) * -1));
            yy = y + round(choose(random(500), random(500) * -1));

            stir = instance_nearest(xx, yy, obj_star);
            if ((stir.planets != 0) && (stir.owner == eFACTION.IMPERIUM)) {
                good = 1;
            }
            if ((stir.planets == 1) && (stir.p_type[1] == "Dead")) {
                good = 0;
            }
        }

        if (good == 1) {
            fleet.action_x = stir.x;
            fleet.action_y = stir.y;
            with (fleet) {
                set_fleet_movement();
            }
        }
    }

    instance_activate_object(obj_star);
}

if ((owner == eFACTION.TYRANIDS) && (trade_goods == "")) {
    trade_goods = choose("Spore Clouds", "Health", "Armour", "Speed", "Turn", "Turret");
    trade_goods += "|";
    trade_goods += choose("Spore Clouds", "Health", "Armour", "Speed", "Turn", "Turret");
    trade_goods += "|";
}

if (global.load >= 0) {
    if (owner == eFACTION.IMPERIUM) {
        sprite_index = spr_fleet_imperial;
    }
    if (owner == eFACTION.MECHANICUS) {
        sprite_index = spr_fleet_mechanicus;
    }
    if (owner == eFACTION.INQUISITION) {
        sprite_index = spr_fleet_inquisition;
    }
    if (owner == eFACTION.ELDAR) {
        sprite_index = spr_fleet_eldar;
    }
    if (owner == eFACTION.ORK) {
        sprite_index = spr_fleet_ork;
    }
    if (owner == eFACTION.TAU) {
        sprite_index = spr_fleet_tau;
    }
    if (owner == eFACTION.TYRANIDS) {
        sprite_index = spr_fleet_tyranid;
    }
    if (owner == eFACTION.CHAOS) {
        sprite_index = spr_fleet_chaos;
    }
}
if (image_index == 0) {
    image_index = 1;
}
