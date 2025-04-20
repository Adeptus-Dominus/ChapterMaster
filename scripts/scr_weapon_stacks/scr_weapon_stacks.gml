enum eTARGET_TYPE {
    Normal,
    Armour,
    Heavy,
    Leader,
    Fortification,
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
    target_type = eTARGET_TYPE.Normal;

    static total_attack = function() {
        return attack * weapon_count;
    };
}

global.unit_profiles = json_to_gamemaker(working_directory + "\\data\\unit_profiles.jsonc", json_parse);
global.squad_profiles = json_to_gamemaker(working_directory + "\\data\\squad_profiles.jsonc", json_parse);
global.army_profiles = json_to_gamemaker(working_directory + "\\data\\army_profiles.jsonc", json_parse);
function EnemyUnitStack(_name, _unit_count, _copy_profile = true) constructor {
    unit_name = _name;
    display_name = _name;
    unit_count = _unit_count;
    abilities = [];
    armour = 0;
    health = 0;
    health_current = 0;
    resistance = 0;
    unit_type = eTARGET_TYPE.Normal;
    unit_size = 0;
    weapons = [];
    ranged_mod = 1;
    melee_mod = 1;
    unit_profile = {};

    static copy_unit_profile = function(_name) {
        var _unit_profiles = global.unit_profiles;
        if (struct_exists(_unit_profiles, _name)) {
            var _profile_struct = _unit_profiles[$ _name];
            unit_profile = _profile_struct;
            var _stat_names = struct_get_names(_profile_struct);
            var _stat_len = array_length(_stat_names);
            for (var k = 0; k < _stat_len; k++){
                var _stat_name = _stat_names[k];
                struct_set(self, _stat_name, _profile_struct[$ _stat_name]);
            }
            health_current = health;
        }
    };

    if (_copy_profile) {
        copy_unit_profile(_name);
    }
}
