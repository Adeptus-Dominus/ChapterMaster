
owner = 2;
flank=0;

unit_count_old=0;
composition_string="";

pos = 880;
centerline_offset = 0;
draw_size = 0;
x1 = 0;
y1 = 0;
x2 = 0;
y2 = 0;

if (obj_ncombat.enemy < array_length(global.star_name_colors) && obj_ncombat.enemy >= 0) {
    column_draw_colour = global.star_name_colors[obj_ncombat.enemy];
} else {
    column_draw_colour = c_dkgrey;
}


target_block = noone;

weapon_stacks_normal = [];
weapon_stacks_vehicle = {};
weapon_stacks_unique = {};

composition_map = new CountingMap();

unit_squads = [];
units = [];

column_size = 0;

engaged = function() {
    return collision_point(x - 10, y, obj_pnunit, 0, 1) || collision_point(x + 10, y, obj_pnunit, 0, 1);
};

is_mouse_over = function() {
    return scr_hit(x1, y1, x2, y2) && obj_ncombat.fading_strength == false;
};


copy_block_composition = function(_composition) {
    if (struct_exists(_composition, "units")) {
        var _units = _composition.units;
        for (var i = 0, l = array_length(_units); i < l; i++) {
            var _unit = _units[i];
            var _unit_name = _unit.name;
            var _unit_count = _unit.count;
            repeat (_unit_count) {
                var _unit_struct = new EnemyUnit(_unit_name);
                array_push(units, _unit_struct);
                column_size += _unit_struct.unit_size;
            }
        }
    }

    if (struct_exists(_composition, "squads")) {
        var _squads = _composition.squads;
        for (var i = 0, l = array_length(_squads); i < l; i++) {
            var _squad = _squads[i];
            var _squad_name = _squad.name;
            var _squad_count = _squad.count;
            repeat (_squad_count) {
                var _squad_struct = new EnemySquad(_squad_name);
                array_push(unit_squads, _squad_struct);
                column_size += _squad_struct.squad_size;
            }
        }
    }
};

assign_weapon_stacks = function() {
    for (var i = 0, l = array_length(unit_squads); i < l; i++){
        var _unit_squad = unit_squads[i];
        for (var s = 0, l2 = array_length(_unit_squad.units); s < l2; s++) {
            var _member_stack = _unit_squad.units[s];
            for (var w = 0, l3 = array_length(_member_stack.weapons); w < l3; w++) {
                scr_en_weapon(_member_stack.weapons[w], _member_stack.unit_type, _member_stack.unit_count, _member_stack.display_name);
            }
        }
    }
};

unit_count = function() {
    // if (DEBUG_COMBAT_PERFORMANCE) {
    //     stopwatch("unit_count");
    // }
    
    var _unit_count = 0;

    for (var i = 0, l = array_length(unit_squads); i < l; i++){
        var _unit_squad = unit_squads[i];
        _unit_count += _unit_squad.member_count;
    }
    
    // if (DEBUG_COMBAT_PERFORMANCE) {
    //     stopwatch("unit_count");
    // }

    return _unit_count;
};
