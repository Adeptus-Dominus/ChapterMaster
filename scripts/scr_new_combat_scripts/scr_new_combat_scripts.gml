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

#macro COMBAT_ROLE_BATTLELINE "battleline"
#macro COMBAT_ROLE_FIRE_SUPPORT "fire_support"
#macro COMBAT_ROLE_ASSAULT "assault"
#macro COMBAT_ROLE_COMMAND "command"
#macro COMBAT_ROLE_ARTILLERY "artillery"
#macro COMBAT_ROLE_FORTIFICATION "fortification"
#macro COMBAT_ROLE_ANTI_ARMOUR "anti_armour"
#macro COMBAT_ROLE_TRANSPORT "transport"

global.squad_profiles = json_to_gamemaker(working_directory + "\\data\\squad_profiles.jsonc", json_parse);
global.combat_role_profiles = json_to_gamemaker(working_directory + "\\data\\combat_role_profiles.jsonc", json_parse);

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

    for (var i = 0; i < array_length(cells); i++) {
        cells[i] = new BattlefieldGridCell();
    }
    
    static get_size = function() {
        return array_length(cells);
    }

    static get_cell_index = function(_x, _y) {
        return _x + _y * width;
    };

    static get_cell_coords = function(_index) {
        var _x = _index % width;
        var _y = floor(_index / width);
        return [_x, _y];
    };

    static get_occupants_at = function(_x, _y) {
        var _cell = get_cell(_x, _y);
        if (_cell != undefined) {
            return _cell.occupants;
        }
        return [];
    };
    
    static valid_cell = function(_x, _y) {
        return _x >= 0 && _x < width && _y >= 0 && _y < height;
    }

    static get_cell = function(_x, _y) {
        if (_x >= 0 && _x < width && _y >= 0 && _y < height) {
            return cells[get_cell_index(_x, _y)];
        }
        return undefined;
    };
    
    static soft_reset = function() {
        var _size = get_size();
        for (var i = 0; i < _size; i++) {
            cells[i].reset();
        }
    };

    static move_squad = function(_x, _y, _squad) {
        if (valid_cell(_x, _y)) {
            var _cell = cells[get_cell_index(_x, _y)];
            var _squad_size = _squad.get_size();
            if (_cell.can_fit(_squad_size)) {
                var _old_location = _squad.location;
                remove_squad(_old_location[0], _old_location[1], _squad);
                add_squad(_x, _y, _squad);
                return true;
            } else {
                return false;
            }
        } else {
            return false;
        }
    };

    static add_squad = function(_x, _y, _squad) {
        if (valid_cell(_x, _y)) {
            var _cell = cells[get_cell_index(_x, _y)];
            var _squad_size = _squad.get_size();
            if (_cell.can_fit(_squad_size)) {
                array_push(_cell.occupants, _squad);
                _cell.capacity_used += _squad_size;
                _squad.location = [_x, _y];
                return true;
            } else {
                return false;
            }
        } else {
            return false;
        }
    };

    static remove_squad = function(_x, _y, _squad) {
        if (valid_cell(_x, _y)) {
            var _cell = cells[get_cell_index(_x, _y)];
            array_delete_value(_cell.occupants, _squad);
            _cell.capacity_used -= _squad.get_size();
            _squad.location = [-1, -1];
            return true;
        } else {
            return false;
        }
    };

    static draw = function(_x1, _y1, _x2, _y2) {
        var _cell_width = (_x2 - _x1) / width;
        var _cell_height = (_y2 - _y1) / height;

        for (var _x = 0; _x < width; _x++) {
            for (var _y = 0; _y < height; _y++) {
                var _cell_x1 = _x1 + _x * _cell_width;
                var _cell_y1 = _y1 + _y * _cell_height;
                var _cell_x2 = _cell_x1 + _cell_width;
                var _cell_y2 = _cell_y1 + _cell_height;

                draw_set_alpha(0.15);
                draw_set_color(c_gray);
                draw_rectangle(_cell_x1, _cell_y1, _cell_x2, _cell_y2, true);
                draw_set_alpha(1);

                var _cell = get_cell(_x, _y);
                _cell.draw_contents(_cell_x1, _cell_y1, _cell_x2, _cell_y2);
            }
        }

        draw_set_alpha(1);
        draw_set_color(c_white);
    };
}

function BattlefieldGridCell() constructor {
    // terrain = -1;
    capacity = -1;
    capacity_used = -1;
    occupants = [];
    x1 = 0;
    y1 = 0;
    x2 = 0;
    y2 = 0;
    x3 = 0;
    y3 = 0;

    static default_size = 400;

    static reset = function() {
        // terrain = 0;
        capacity = default_size;
        capacity_used = 0;
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

    static can_fit = function(_size) {
        return capacity_used + _size <= capacity;
    };

    static draw_contents = function(_cell_x1, _cell_y1, _cell_x2, _cell_y2) {
        var _cell_width = _cell_x2 - _cell_x1;
        var _cell_height = _cell_y2 - _cell_y1;

        var _item_count = array_length(occupants);
        if (_item_count > 0) {
            var _content_scale = _cell_height / default_size;

            var _cell_padding_x = _cell_width * 0.1 * _content_scale;

            var _total_squad_size = 0;
            for (var i = 0; i < _item_count; i++) {
                _total_squad_size += occupants[i].get_size();
            }
            _total_squad_size *= _content_scale;

            var _current_y = _cell_y1 + ((_cell_height - _total_squad_size) / 2);

            for (var i = 0; i < _item_count; i++) {
                var _squad = occupants[i];
                var _squad_size = _squad.get_size() * _content_scale;

                if (_squad.allegiance == eBATTLE_ALLEGIANCE.Player) {
                    draw_set_color(c_blue);
                } else if (_squad.allegiance == eBATTLE_ALLEGIANCE.Enemy) {
                    draw_set_color(c_red);
                } else {
                    draw_set_color(c_gray);
                }

                draw_rectangle(_cell_x1 + _cell_padding_x, _current_y, _cell_x2 - _cell_padding_x, _current_y + _squad_size, false);

                _current_y += _squad_size;
            }
        }
    };

    static hovered_over = function() {
        return scr_hit(x1, y1, x2, y2);
    }
}

function BattleArmy(_name = "", _copy_profile = true) constructor {
    name = _name;
    profile = {};

    /// @type {Array<Struct.BattleSquad>}
    squads = [];

    allegiance = eBATTLE_ALLEGIANCE.Unknown;

    /// @type {Array<Struct.BattleSquad>}
    lost_units = [];

    /// @type {Array<Struct.BattleUnit>}
    lost_squads = [];

    static copy_profile = function() {
        var _army_profiles = global.army_profiles;
        var _profile = _army_profiles[$ name];
        profile = _profile;
    };

    if (_copy_profile) {
        copy_profile();
    }

    static get_squad_count = function() {
        return array_length(squads);
    };

    static get_unit_count = function() {
        var _count = 0;
        for (var i = 0, l = array_length(squads); i < l; i++) {
            var _squad = squads[i];
            _count += _squad.get_unit_count();
        }
        return _count;
    };

    static spawn_squads = function() {
        if (!struct_exists(profile, "squads")) {
            return false; // No squads to spawn
        }

        var _battlefield = obj_ncombat.battlefield_grid;
        var _deployment_zone_xstart;

        if (allegiance == eBATTLE_ALLEGIANCE.Player) {
            _deployment_zone_xstart = 0;
        } else if (allegiance == eBATTLE_ALLEGIANCE.Enemy) {
            _deployment_zone_xstart = _battlefield.width - 1;
        } else {
            show_error($"Warning: Cannot spawn forces for army '{name}'! Unknown allegiance!", false);
            return;
        }

        var _profile_squads = profile.squads;
        var _squads_by_role = {
            "back": [],
            "center": [],
            "front": []
        };

        // Group squads by combat role
        for (var i = 0, l = array_length(_profile_squads); i < l; i++) {
            var _squad_data = _profile_squads[i];
            var _squad_profile = global.squad_profiles[$ _squad_data.name];
            var _combat_role_profile = global.combat_role_profiles[$ _squad_profile.combat_role];
            var _spawn_distance = _combat_role_profile.spawn_position;

            if (struct_exists(_squads_by_role, _spawn_distance)) {
                repeat (_squad_data.count) {
                    array_push(_squads_by_role[$ _spawn_distance], _squad_data.name);
                }
            } else {
                show_error($"Warning: Unknown spawn position '{_spawn_distance}' for squad '{_squad_data.name}'. Skipping.", false);
            }
        }

        // Define the order of spawning roles (back to front)
        var _spawn_order = ["back", "center", "front"];
        var _current_spawn_x = _deployment_zone_xstart;
        var _spawn_direction = (allegiance == eBATTLE_ALLEGIANCE.Player) ? 1 : -1; // Determine spawn direction

        // Spawn squads sequentially by role
        for (var r = 0, rl = array_length(_spawn_order); r < rl; r++) {
            var _role = _spawn_order[r];
            var _squad_names_in_role = _squads_by_role[$ _role];

            for (var s = 0, sl = array_length(_squad_names_in_role); s < sl; s++) {
                var _squad_name = _squad_names_in_role[s];
                var _battle_squad = new BattleSquad(_squad_name);
                _battle_squad.army = self;
                _battle_squad.allegiance = self.allegiance;

                // Attempt to place the squad at the current spawn X and Y=0
                var _placed = false;
                // Assuming squad size affects placement validation but not the starting cell for sequential placement
                // The grid's add_squad method should handle multi-cell squads starting from the given coordinate
                if (_battlefield.add_squad(_current_spawn_x, 0, _battle_squad)) {
                    array_push(squads, _battle_squad);
                    _placed = true;
                } else {
                    _current_spawn_x += _spawn_direction;
                    if (_battlefield.add_squad(_current_spawn_x, 0, _battle_squad)) {
                        array_push(squads, _battle_squad);
                    _placed = true;
                    } else {
                        show_error($"Warning: Could not place squad '{_squad_name}' for '{allegiance}' at ({_current_spawn_x}, 0)! Deployment area full?", false);
                    }
                }

                if (!_placed) {
                    show_error($"Warning: Could not place squad '{_squad_name}' for '{allegiance}' at ({_current_spawn_x}, 0)!", false);
                    // The squad instance is not added to the army's list if not placed
                }
            }
        }

        return true;
    };

    static squad_initiative_sort = function(_squad_a, _squad_b) {
        array_sort(squads, function(_squad_a, _squad_b) { 
            return _squad_b.movement - _squad_a.movement;
        });
    }

    static move_forces = function () {
        if (array_length(squads) == 0) {
            exit;
        }

        squad_initiative_sort();

        for (var i = 0, l = array_length(squads); i < l; i++) {
            var _squad = squads[i];
            _squad.move();
        }
    };
}

function BattleSquad(_name, _copy_profile = true) constructor {
    name = _name;
    display_name = _name;

    /// @type {Array<Struct.BattleUnit>}
    units = [];

    location = -1;
    movement = -1;
    engaged = false;

    /// @type {Struct.BattleSquad}
    target_squad = {};

    army = {};
    allegiance = eBATTLE_ALLEGIANCE.Unknown;
    morale = -1;
    combat_role = COMBAT_ROLE_BATTLELINE;

    static copy_profile = function() {
        var _profile = global.squad_profiles[$ name];
        var _units = _profile.units;
        display_name = _profile.display_name;
        combat_role = _profile.combat_role;
        
        var _unit_names = struct_get_names(_units);
        for (var k = 0, l = array_length(_unit_names); k < l; k++){
            var _unit_name = _unit_names[k];
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

    static get_unit_count = function() {
        return array_length(units);
    };

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

        var _movement_direction = (allegiance == eBATTLE_ALLEGIANCE.Player) ? 1 : -1;
        for (var _movement_distance = movement; _movement_distance >= 1; _movement_distance--) {
            var _movement_delta = _movement_direction * _movement_distance;

            var _target_x = location[0] + _movement_delta;
            var _target_y = location[1];

            if (obj_ncombat.battlefield_grid.move_squad(_target_x, _target_y, self)) {
                exit;
            }
        }
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

        if (get_unit_count() <= 0) {
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
    health_points = 0;
    resistance = 0;
    ranged_mod = 1;
    melee_mod = 1;

    /// @type {Struct.UnitProfile}
    profile = {};

    squad = {};

    /// @type {Array<Struct.BattleWeapon>}
    weapons = [];

    static copy_profile = function(_name) {
        var _profile_struct = global.unit_profiles[$ _name];
        profile = _profile_struct;

        struct_overwrite(self, _profile_struct);

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

        health_points -= _modified_damage;

        if (health_points <= 0) {
            array_push(squad.army.lost_units, self);
            array_delete_value(squad.units, self);
        }
    };
}

function BattleWeapon(_name, _owner) constructor {
    name = _name;
    owner = _owner;
    profile = global.weapons[$ _name];
    ammo = 6;
    reloading = -1;
}
