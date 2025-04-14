enum eTARGET_TYPE {
    NORMAL,
    ARMOUR,
    LEADER,
    FORTIFICATION,
}

function WeaponStack(_name) constructor {
    weapon_name = _name;
    weapon_count = 0;
    range = 0;
    attack = 0;
    piercing = 0;
    ammo_current = 0;
    ammo_max = 0;
    ammo_reload_current = 0;
    ammo_reload = 0;
    shot_count = 0;
    owners = [];
    target_type = eTARGET_TYPE.NORMAL;

    static total_attack = function() {
        return attack * weapon_count;
    };
}

function UnitStack(_name) constructor {
    unit_name = _name;
    abilities = 0;
    count = 0;
    armour_points = 0;
    health = 0;
    resistance = 0;
    is_vehicle = false;
    attack = 0;
    experience = 0;
    faith = 0;
}
