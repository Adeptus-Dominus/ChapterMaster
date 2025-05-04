enum eUNIT_TYPE {
    Unknown,
    Infantry,
    Vehicle,
    Monster,
    Fortification,
};

enum eUNIT_SUBTYPE {
    Normal,
    Character,
    Flyer,
    Monster,
    Character,
    Fortification,
};

enum eBATTLE_ALLEGIANCE {
    Unknown,
    Player,
    Ally,
    Enemy,
};

global.unit_profiles = json_to_gamemaker(working_directory + "\\data\\unit_profiles.jsonc", json_parse);
global.squad_profiles = json_to_gamemaker(working_directory + "\\data\\squad_profiles.jsonc", json_parse);

function convert_keywords_to_set() {
    var _squad_names = struct_get_names(global.squad_profiles);
    var _squad_len = array_length(_squad_names);
    for (var k = 0; k < _squad_len; k++){
        var _squad_name = _squad_names[k];
        var _squad = global.squad_profiles[$ _squad_name];
        _squad.keywords = new Set(_squad.keywords);
    }
}

convert_keywords_to_set();

global.army_profiles = json_to_gamemaker(working_directory + "\\data\\army_profiles.jsonc", json_parse);

function BattlefieldGrid(_width, _height) constructor {
    width = _width;
    height = _height;
    /// @type {Array<Struct.BattlefieldGridCell>} 
    cells = array_create(_width * _height);
    size = array_length(cells);
    for (var i = 0; i < size; i++) {
        cells[i] = new BattlefieldGridCell();
    }
    
    static get_cell_index = function(_x, _y) {
        return _x + _y * width;
    };

    static get_cell_coords = function(_index) {
        var x = _index % width;
        var y = floor(_index / width);
        return [x, y];
    };

    static get_occupants_at = function(_x, _y) {
        var _cell = get_cell(_x, _y);
        if (_cell != undefined) {
            return _cell.occupants;
        }
        return [];
    };
    
    static add_squad = function(_x, _y, _squad) {
        if (_x >= 0 && _x < width && _y >= 0 && _y < height) {
            array_push(cells[get_cell_index(_x, _y)].occupants, _squad);
            return true;
        } else {
            return false;
        }
    };

    static remove_squad = function(_x, _y, _squad) {
        if (_x >= 0 && _x < width && _y >= 0 && _y < height) {
            array_delete_value(cells[get_cell_index(_x, _y)], _squad);
            return true;
        } else {
            return false;
        }
    };

    static get_cell = function(_x, _y) {
        if (_x >= 0 && _x < width && _y >= 0 && _y < height) {
            return cells[get_cell_index(_x, _y)];
        }
        return undefined;
    };
    
    static soft_reset = function() {
        var _size = array_length(cells);
        for (var i = 0; i < _size; i++) {
            cells[i].reset();
        }
    };
}

function BattlefieldGridCell() constructor {
    // terrain = -1;
    // capacity = -1;
    occupants = [];

    static reset = function() {
        // terrain = 0;
        // capacity = 1000;
        occupants = [];
    };

    reset();

    static get_occupants = function(_allegiance_type = -1, _squad_type = -1) {
        var _filtered = [];
        for (var i = 0, l = array_length(occupants); i < l; ++i) {
            var _squad = occupants[i];
            var _match_allegiance = (_allegiance_type == -1 || _squad.allegiance == _allegiance_type);
            var _match_type = (_squad_type == -1 || _squad._squad_type == _squad_type);

            if (_match_allegiance && _match_type) {
                array_push(_filtered, _squad);
            }
        }
        return _filtered;
    }
}

function BattleArmy(_name = "", _copy_profile = true) constructor {
    name = _name;
    profile = {};
    squads = [];
    squad_count = array_length(squads);
    unit_count = 0;
    allegiance = eBATTLE_ALLEGIANCE.Unknown;
    lost_units = [];
    lost_squads = [];

    static copy_profile = function() {
        var _army_profiles = global.army_profiles;
        var _profile = _army_profiles[$ name];
        profile = _profile;
    };

    if (_copy_profile) {
        copy_profile();
    }

    static spawn_forces = function() {
        if (struct_exists(profile, "squads")) {
            var _squads = profile.squads;
            for (var i = 0, l = array_length(_squads); i < l; i++) {
                var _squad = _squads[i];
                var _squad_name = _squad.name;
                var _squad_count = _squad.count;
                repeat (_squad_count) {
                    var _squad_struct = new BattleSquad(_squad_name);
                    _squad_struct.army = self;
                    array_push(squads, _squad_struct);
                    unit_count += _squad_struct.unit_count;
                    var _cell = obj_ncombat.battlefield[0];
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
    };
}

function BattleSquad(_name, _copy_profile = true) constructor {
    name = _name;
    display_name = _name;
    units = [];
    unit_count = array_length(units);
    location = -1;
    movement = -1;
    engaged = false;
    /// @type {Struct.BattleSquad}
    target_squad = {};
    army = {};
    allegiance = eBATTLE_ALLEGIANCE.Unknown;

    static copy_profile = function() {
        var _profile = global.squad_profiles[$ name];
        var _units = _profile.units;
        display_name = _profile.display_name;
        
        var _unit_names = struct_get_names(_units);
        for (var k = 0, l = array_length(_unit_names); k < l; k++){
            var _unit_name = _unit[k];
            var _unit = _units[$ _unit_name];
    
            repeat (_unit.count) {
                var _battle_unit = new BattleUnit(_unit_name);
                _battle_unit.squad = self;
                array_push(units, _battle_unit);
            }

            if (movement == -1 || _battle_unit.profile.movement < movement) {
                movement = _battle_unit.profile.movement;
            }
        }
    };

    if (_copy_profile) {
        copy_profile();
    }

    static get_size = function () {
        var _size = 0;
        for (var i = 0, l = array_length(units); i < l; i++) {
            var _unit = units[i];
            _size += _unit.profile.size;
        }
        return _size;
    };

    static move = function() {
        if (location == -1 || engaged == true) {
            exit;
        }

        location = [location[0]++, location[1]++];
    };

    static attack = function() {
        var _all_weapons = [];
        for (var i = 0; i < array_length(units); i++) {
            array_concat(_all_weapons, units[i].weapons);
        }
        target_squad.resolve_attacks(_all_weapons);
    };

    static resolve_attacks = function(_weapons) {
        for (var i = 0; i < array_length(_weapons); i++) {
            var _weapon = _weapons[i];
            /// @type {Struct.BattleUnit} 
            var _target_unit = array_random_element(target_squad.units);
            _target_unit.apply_damage(_weapon);
        }

        if (unit_count <= 0) {
            array_push(army.lost_squads, self);
            array_delete_value(army.squads, self);
        }
    };
}

function BattleUnit(_name, _copy_profile = true) constructor {
    name = _name;
    display_name = _name;
    abilities = [];
    armour = 0;
    health = 0;
    resistance = 0;
    weapons = [];
    ranged_mod = 1;
    melee_mod = 1;
    profile = {};
    squad = {};

    static copy_profile = function(_name) {
        var _profile_struct = global.unit_profiles[$ _name];
        profile = _profile_struct;
        var _stat_names = struct_get_names(_profile_struct);
        var _stat_len = array_length(_stat_names);
        for (var k = 0; k < _stat_len; k++){
            var _stat_name = _stat_names[k];
            struct_set(self, _stat_name, _profile_struct[$ _stat_name]);
        }
        for (var w = 0, l = array_length(weapons); w < l; w++) {
            weapons[w] = new BattleWeapon(weapons[w], self);
        }
    };

    if (_copy_profile) {
        copy_profile(_name);
    }

    static apply_damage = function(_weapon) {
        var _min_damage = 0.25;
        var _dice_sides = 50;
        var _random_damage_mod = roll_dice_chapter(4, _dice_sides, "low") / 100;
        var _armour_points = max(0, armour - _weapon.arp);
        var _modified_damage = max(_min_damage, ((_weapon.attack.standard * _random_damage_mod) - _armour_points) * resistance);

        health -= _modified_damage;

        if (health <= 0) {
            array_push(squad.army.lost_units, self);
            array_delete_value(squad.units, self);
        }
    };
}

function BattleWeapon(_name, _owner) constructor {
    name = _name;
    owner = _owner;
    profile = global.weapons[? _name];
    ammo = profile.ammo;
    reloading = -1;
}
