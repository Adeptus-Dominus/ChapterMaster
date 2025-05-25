var _target_planet;
_target_planet = instance_nearest(x, y, obj_star);
delete_features(_target_planet.p_feature[num], P_features.Artifact);

scr_return_ship(loc, self, num);

with (obj_star_select) {
    instance_destroy();
}
with (obj_fleet_select) {
    instance_destroy();
}

obj_controller.menu = 20;
obj_controller.diplomacy = 3;
obj_controller.force_goodbye = 5;

if (obj_controller.disposition[3] <= 10) {
    obj_controller.disposition[3] += 5;
}
if ((obj_controller.disposition[3] > 10) && (obj_controller.disposition[3] <= 30)) {
    obj_controller.disposition[3] += 7;
}
if ((obj_controller.disposition[3] > 30) && (obj_controller.disposition[3] <= 50)) {
    obj_controller.disposition[3] += 9;
}
if (obj_controller.disposition[3] > 50) {
    obj_controller.disposition[3] += 11;
}

with (obj_controller) {
    scr_dialogue("stc_thanks");
}

with (obj_temp2) {
    instance_destroy();
}
with (obj_temp7) {
    instance_destroy();
}

if (obj_ini.fleet_type == ePlayerBase.home_world) {
    with (obj_star) {
        if ((owner == eFACTION.Player) && ((p_owner[1] == 1) || (p_owner[2] == eFACTION.Player))) {
            instance_create(x, y, obj_temp2);
        }
    }
}
if (obj_ini.fleet_type != ePlayerBase.home_world) {
    with (obj_p_fleet) {
        // Get fleet star system
        if ((capital_number > 0) && (action == "")) {
            instance_create(instance_nearest(x, y, obj_star).x, instance_nearest(x, y, obj_star).y, obj_temp2);
        }
        if ((frigate_number > 0) && (action == "")) {
            instance_create(instance_nearest(x, y, obj_star).x, instance_nearest(x, y, obj_star).y, obj_temp7);
        }
    }
}

if (obj_ini.fleet_type != ePlayerBase.home_world) {
    with (obj_p_fleet) {
        if (action == "") {
            instance_deactivate_object(instance_nearest(x, y, obj_star));
        }
    }
}


var _enemy_fleet;
var _target = -1;

if (instance_exists(obj_temp2)) {
    _target = nearest_star_with_ownership(obj_temp2.x, obj_temp2.y, obj_controller.diplomacy);
} else if (instance_exists(obj_temp7)) {
    _target = nearest_star_with_ownership(obj_temp7.x, obj_temp7.y, obj_controller.diplomacy);
} else if ((!instance_exists(obj_temp2)) && (!instance_exists(obj_temp7)) && instance_exists(obj_p_fleet) && (obj_ini.fleet_type == ePlayerBase.home_world)) {
    // If player fleet is flying about then get their target for new target
    with (obj_p_fleet) {
        var pop;
        if ((capital_number > 0) && (action != "")) {
            pop = instance_create(action_x, action_y, obj_temp2);
            pop.action_eta = action_eta;
        }
        if ((frigate_number > 0) && (action != "")) {
            pop = instance_create(action_x, action_y, obj_temp7);
            pop.action_eta = action_eta;
        }
    }
}

if (is_struct(_target)) {
    _enemy_fleet = instance_create(_target.x, _target.y, obj_en_fleet);

    _enemy_fleet.owner = obj_controller.diplomacy;
    _enemy_fleet.home_x = _target.x;
    _enemy_fleet.home_y = _target.y;
    _enemy_fleet.sprite_index = spr_fleet_mechanicus;

    _enemy_fleet.image_index = 0;
    _enemy_fleet.capital_number = 1;
    _enemy_fleet.trade_goods = "Requisition!500!|";

    if (obj_ini.fleet_type != ePlayerBase.home_world) {
        if (instance_exists(obj_temp2)) {
            _enemy_fleet.action_x = obj_temp2.x;
            _enemy_fleet.action_y = obj_temp2.y;
            _enemy_fleet.target = instance_nearest(_enemy_fleet.action_x, _enemy_fleet.action_y, obj_p_fleet);
        }
        if ((!instance_exists(obj_temp2)) && instance_exists(obj_temp7)) {
            _enemy_fleet.action_x = obj_temp7.x;
            _enemy_fleet.action_y = obj_temp7.y;
            _enemy_fleet.target = instance_nearest(_enemy_fleet.action_x, _enemy_fleet.action_y, obj_p_fleet);
        }
    }
    if (obj_ini.fleet_type == ePlayerBase.home_world) {
        _target = instance_nearest(_enemy_fleet.x, _enemy_fleet.y, obj_temp2);
        _enemy_fleet.action_x = _target.x;
        _enemy_fleet.action_y = _target.y;
    }

    _enemy_fleet.alarm[4] = 1;
}

instance_activate_all();
with (obj_temp2) {
    instance_destroy();
}
with (obj_temp7) {
    instance_destroy();
}
instance_destroy();
