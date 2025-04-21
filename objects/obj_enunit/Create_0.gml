
owner = -1;
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

weapon_stacks_normal = {};
weapon_stacks_vehicle = {};
weapon_stacks_unique = {};

unit_stacks = {};

column_size = 0;

engaged = function() {
    return collision_point(x - 10, y, obj_pnunit, 0, 1) || collision_point(x + 10, y, obj_pnunit, 0, 1);
};

is_mouse_over = function() {
    return scr_hit(x1, y1, x2, y2) && obj_ncombat.fading_strength == false;
};


copy_block_composition = function(_composition) {
    var _t_start_copy_block_composition = get_timer();
    
    if (struct_exists(_composition, "units")) {
        var _units = _composition.units;

        var _units_len = array_length(_units);
        for (var i = 0; i < _units_len; i++) {
            var _unit = _units[i];
            var _unit_name = _unit.name;
            var _unit_struct = new EnemyUnitStack(_unit_name, _unit.count);
            struct_set(unit_stacks, _unit_name, _unit_struct);
            column_size += _unit_struct.unit_size * _unit.count;
        }
    }

    if (struct_exists(_composition, "squads")) {
        var _squads = _composition.squads;

        var _squads_len = array_length(_squads);
        for (var i = 0; i < _squads_len; i++) {
            var _squad = _squads[i];
        
            var _squad_template = global.squad_profiles[$ _squad.name];
            var _squad_units = _squad_template.members;
            var _squad_count = _squad.count;
            
            var _unit_names = struct_get_names(_squad_units);
            var _unit_len = array_length(_unit_names);
            for (var k = 0; k < _unit_len; k++){
                var _unit_name = _unit_names[k];
                var _profile_name = _unit_name;
                var _unit = _squad_units[$ _unit_name];

                if (struct_exists(unit_stacks, _unit_name)) {
                    unit_stacks[$ _unit_name].unit_count += _unit.count * _squad_count;
                    column_size += unit_stacks[$ _unit_name].unit_size * _unit.count * _squad_count;
                } else {
                    var _unit_struct = new EnemyUnitStack(_profile_name, _unit.count * _squad_count);
                    struct_set(unit_stacks, _unit_name, _unit_struct);
                    column_size += _unit_struct.unit_size * _unit.count * _squad_count;
                }
            }
        }
    }
    
    var _t_end_copy_block_composition = get_timer();
    var _elapsed_ms_copy_block_composition = (_t_end_copy_block_composition - _t_start_copy_block_composition) / 1000;
    show_debug_message($"⏱️ Execution Time copy_block_composition: {_elapsed_ms_copy_block_composition}ms");
};

assign_weapon_stacks = function() {
    var _unit_stack_names = struct_get_names(unit_stacks);
    var _unit_stack_len = array_length(_unit_stack_names);
    for (var k = 0; k < _unit_stack_len; k++){
        var _unit_stack_name = _unit_stack_names[k];
        var _unit_stack = unit_stacks[$ _unit_stack_name];
        for (var w = 0; w < array_length(_unit_stack.weapons)) {
            scr_en_weapon(_unit_stack.weapons[w], _unit_stack.unit_type, _unit_stack.unit_count, _unit_stack_name, self);
        }
    }
}

unit_count = function() {
    var _unit_count = 0;

    var _unit_stack_names = struct_get_names(unit_stacks);
    var _unit_stack_len = array_length(_unit_stack_names);
    for (var k = 0; k < _unit_stack_len; k++){
        var _unit_stack_name = _unit_stack_names[k];
        var _unit_stack = unit_stacks[$ _unit_stack_name];
        _unit_count += _unit_stack.unit_count;
    }

    return _unit_count;
};
