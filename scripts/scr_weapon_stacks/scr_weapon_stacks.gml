enum eTARGET_TYPE {
    Normal,
    Armour,
    Heavy,
    Leader,
    Fortification,
}

function PlayerArmy() constructor {
    units_count = 0;
    vehicle_count = 0;
    strength = 0;

}

function EnemyArmy(_name = "", _copy_profile = true) constructor {
    name = _name;
    squads = [];
    units = [];
    profile = {};
    unit_count = 0;

    static copy_profile = function() {
        var _army_profiles = global.army_profiles;
        if (struct_exists(_army_profiles, name)) {
            var _profile = _army_profiles[$ name];
            profile = _profile;
        }
    };

    if (_copy_profile) {
        copy_profile();
    }

    static spawn_squads = function() {
        if (struct_exists(profile, "units")) {
            var _units = profile.units;
            for (var i = 0, l = array_length(_units); i < l; i++) {
                var _unit = _units[i];
                var _unit_name = _unit.name;
                var _unit_count = _unit.count;
                repeat (_unit_count) {
                    var _unit_struct = new EnemyUnit(_unit_name);
                    array_push(units, _unit_struct);
                    unit_count++;
                    var _cell = ds_grid_get(obj_ncombat.battlefield, 0, 0);
                    array_push(_cell, _unit_struct);
                }
            }
        }

        if (struct_exists(profile, "squads")) {
            var _squads = profile.squads;
            for (var i = 0, l = array_length(_squads); i < l; i++) {
                var _squad = _squads[i];
                var _squad_name = _squad.name;
                var _squad_count = _squad.count;
                repeat (_squad_count) {
                    var _squad_struct = new EnemySquad(_squad_name);
                    array_push(squads, _squad_struct);
                    unit_count += _squad_struct.member_count;
                    var _cell = ds_grid_get(obj_ncombat.battlefield, 0, 0);
                    array_push(_cell, _squad_struct);
                }
            }
        }
    };

    static move_forces = function () {
        for (var i = 0, l = array_length(squads); i < l; i++) {
            var _squad = squads[i];
            _squad.move();
        }

        for (var i = 0, l = array_length(units); i < l; i++) {
            var _unit = units[i];
            _unit.move();
        }
    };
}

function WeaponStack(_name) constructor {
    weapon_name = _name;
    weapon_count = 0;
    weapon_profile = {};
    owners = [];
    target_type = eTARGET_TYPE.Normal;
}

global.unit_profiles = json_to_gamemaker(working_directory + "\\data\\unit_profiles.jsonc", json_parse);
global.squad_profiles = json_to_gamemaker(working_directory + "\\data\\squad_profiles.jsonc", json_parse);
global.army_profiles = json_to_gamemaker(working_directory + "\\data\\army_profiles.jsonc", json_parse);

function EnemySquad(_name, _copy_profile = true) constructor {
    name = _name;
    display_name = _name;
    squad_profile = {};
    units = [];
    member_count = array_length(units);
    location = -1;
    movement = -1;
    can_move = true;
    target = -1;

    static copy_squad_profile = function() {
        var _squad_template = global.squad_profiles[$ name];
        var _squad_members = _squad_template.members;
        display_name = _squad_template.display_name;
        
        var _unit_names = struct_get_names(_squad_members);
        for (var k = 0, l = array_length(_unit_names); k < l; k++){
            var _unit_name = _unit_names[k];
            var _unit = _squad_members[$ _unit_name];
    
            repeat (_unit.count) {
                var _unit_object = new EnemyUnit(_unit_name);
                array_push(units, _unit_object);
                squad_size += _unit_object.unit_size;
            }

            if (movement == -1 || _unit_object.unit_profile.movement < movement) {
                movement = _unit_object.unit_profile.movement;
            }
        }
    };
    if (_copy_profile) {
        copy_squad_profile();
    }

    static get_size = function () {
        var _size = 0;

        for (var i = 0, l = array_length(units); i < l; i++) {
            var _unit = units[i];

            _size += _unit.unit_profile.unit_size;
        }

        return _size;
    }

    static move = function() {
        if (location == -1 || can_move == false) {
            exit;
        }

        location = min(location + movement, obj_ncombat.battlefield.size - 1);
    };

    static attack = function() {
        var _weapons = new CountingMap();

        for (var i = 0, l = array_length(units); i < l; i++) {
            var _unit = units[i];
            var _unit_weapons = _unit.weapons;
            for (var w = 0, l2 = array_length(_unit_weapons); w < l2; w++) {
                var _unit_weapon = _unit_weapons[w];
            }
        }
    };
}

function EnemyUnit(_name, _copy_profile = true) constructor {
    unit_name = _name;
    display_name = _name;
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
    can_move = true;
    location = -1;

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

    static move = function() {
        if (location == -1 || can_move == false) {
            exit;
        }

        location = min(location + unit_profile.movement, obj_ncombat.battlefield.size - 1);
    };
}
