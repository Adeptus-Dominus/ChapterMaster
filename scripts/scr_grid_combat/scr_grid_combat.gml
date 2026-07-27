// Grid Combat Prototype: first playable slice of Uxie's Combat Redesign document.
// Launched by the "gridbattle" console cheat as a fully modal GUI overlay with
// generated test forces. Touches no campaign state and restores the map on exit.
// Everything is prefixed grid_/GRIDC_/Grid to stay clear of the live combat system.
// All drawing happens on the GUI layer (fixed 1600x900), so camera zoom is irrelevant.

// Field geometry
#macro GRIDC_COLS 26
#macro GRIDC_ROWS 14
#macro GRIDC_TILE 48
#macro GRIDC_BF_X 288
#macro GRIDC_BF_Y 56
#macro GRIDC_DEPLOY_COLS 3
#macro GRIDC_ENEMY_COLS 2

// Rules tuning
#macro GRIDC_POINTS 24
#macro GRIDC_TICK_FRAMES 18
#macro GRIDC_COVER_POS_MULT 0.70
#macro GRIDC_COVER_NEG_MULT 1.25
#macro GRIDC_ARMOR_CURVE 2
#macro GRIDC_HQ_AURA_RANGE 3
#macro GRIDC_HQ_AURA_MULT 1.10
#macro GRIDC_SGT_HIT_CHANCE 0.12
#macro GRIDC_SGT_DOWN_MULT 0.90
#macro GRIDC_WAVE_TICK 45
#macro GRIDC_WAVES 1

// Phases and orders
#macro GRIDPH_DEPLOY 0
#macro GRIDPH_BATTLE 1
#macro GRIDPH_END 2
#macro GRIDORD_ADVANCE 0
#macro GRIDORD_ATTACK 1
#macro GRIDORD_MOVE 2
#macro GRIDORD_HOLD 3

// Log colours, following the combat log convention: bright blue for the
// continuous feed, aqua for order confirmations, yellow for warnings,
// bright red for heavy enemy hits.
#macro GRIDC_COL_FEED make_color_rgb(90, 165, 255)
#macro GRIDC_COL_ORDER c_aqua
#macro GRIDC_COL_WARN c_yellow
#macro GRIDC_COL_ENEMY make_color_rgb(255, 80, 80)

/// @function grid_unit_def
/// @description Base stat block for every squad type in the prototype.
function grid_unit_def(_t) {
    switch (_t) {
        case "Tactical":
            return { disp: "Tactical", label: "TAC", letter: "T", ascii: "", cost: 2, men: 10, hp_man: 22, armor: 40, bal: 11, mel: 7, rng: 6, mv: 1, is_vehicle: false, melee_pref: false, teleport: false, psyker: false, aura: false, colr: make_color_rgb(86, 132, 210) };
        case "Assault":
            return { disp: "Assault", label: "ASL", letter: "A", ascii: "", cost: 2, men: 10, hp_man: 22, armor: 40, bal: 3, mel: 14, rng: 1, mv: 2, is_vehicle: false, melee_pref: true, teleport: false, psyker: false, aura: false, colr: make_color_rgb(96, 176, 226) };
        case "Devastator":
            return { disp: "Devastator", label: "DEV", letter: "D", ascii: "", cost: 3, men: 10, hp_man: 22, armor: 40, bal: 17, mel: 5, rng: 9, mv: 1, is_vehicle: false, melee_pref: false, teleport: false, psyker: false, aura: false, colr: make_color_rgb(120, 200, 160) };
        case "Veteran":
            return { disp: "Veteran", label: "VET", letter: "V", ascii: "", cost: 3, men: 10, hp_man: 26, armor: 50, bal: 14, mel: 11, rng: 6, mv: 1, is_vehicle: false, melee_pref: false, teleport: false, psyker: false, aura: false, colr: make_color_rgb(214, 178, 96) };
        case "Terminator":
            return { disp: "Terminator", label: "TRM", letter: "TR", ascii: "", cost: 4, men: 5, hp_man: 45, armor: 70, bal: 15, mel: 13, rng: 5, mv: 1, is_vehicle: false, melee_pref: false, teleport: true, psyker: false, aura: false, colr: make_color_rgb(186, 128, 208) };
        case "AssaultTerminator":
            return { disp: "Asslt Term", label: "ATR", letter: "AT", ascii: "", cost: 4, men: 5, hp_man: 45, armor: 70, bal: 0, mel: 22, rng: 1, mv: 1, is_vehicle: false, melee_pref: true, teleport: true, psyker: false, aura: false, colr: make_color_rgb(226, 146, 122) };
        case "HQ":
            return { disp: "HQ", label: "HQ", letter: "HQ", ascii: "", cost: 3, men: 5, hp_man: 30, armor: 55, bal: 13, mel: 15, rng: 5, mv: 1, is_vehicle: false, melee_pref: false, teleport: false, psyker: false, aura: true, colr: make_color_rgb(146, 146, 226) };
        case "Dreadnought":
            return { disp: "Dreadnought", label: "DRD", letter: "DR", ascii: "", cost: 5, men: 1, hp_man: 300, armor: 75, bal: 19, mel: 24, rng: 7, mv: 1, is_vehicle: true, melee_pref: false, teleport: false, psyker: false, aura: false, colr: make_color_rgb(104, 206, 206) };
        case "Predator":
            return { disp: "Predator", label: "PRD", letter: "PR", ascii: "", cost: 5, men: 1, hp_man: 260, armor: 70, bal: 26, mel: 4, rng: 10, mv: 2, is_vehicle: true, melee_pref: false, teleport: false, psyker: false, aura: false, colr: make_color_rgb(150, 170, 190) };
        case "Guard":
            return { disp: "Guard Inf", label: "GRD", letter: "G", ascii: "", cost: 1, men: 20, hp_man: 8, armor: 15, bal: 4, mel: 2, rng: 5, mv: 1, is_vehicle: false, melee_pref: false, teleport: false, psyker: false, aura: false, colr: make_color_rgb(150, 150, 96) };
        case "OrkShoota":
            return { disp: "Shoota Mob", label: "", letter: "", ascii: "S", cost: 0, men: 25, hp_man: 8, armor: 8, bal: 4, mel: 4, rng: 5, mv: 1, is_vehicle: false, melee_pref: false, teleport: false, psyker: false, aura: false, colr: make_color_rgb(196, 210, 96) };
        case "OrkSlugga":
            return { disp: "Slugga Boyz", label: "", letter: "", ascii: "B", cost: 0, men: 25, hp_man: 8, armor: 8, bal: 1, mel: 6, rng: 1, mv: 2, is_vehicle: false, melee_pref: true, teleport: false, psyker: false, aura: false, colr: make_color_rgb(120, 196, 88) };
        case "Nobz":
            return { disp: "Nobz", label: "", letter: "", ascii: "N", cost: 0, men: 8, hp_man: 25, armor: 25, bal: 3, mel: 15, rng: 1, mv: 2, is_vehicle: false, melee_pref: true, teleport: false, psyker: false, aura: false, colr: make_color_rgb(88, 150, 70) };
        case "Weirdboy":
            return { disp: "Weirdboy", label: "", letter: "", ascii: "WB", cost: 0, men: 1, hp_man: 45, armor: 10, bal: 0, mel: 5, rng: 8, mv: 1, is_vehicle: false, melee_pref: false, teleport: false, psyker: true, aura: false, colr: make_color_rgb(208, 110, 230) };
        case "DeffDread":
            return { disp: "Deff Dread", label: "", letter: "", ascii: "DD", cost: 0, men: 1, hp_man: 220, armor: 55, bal: 10, mel: 18, rng: 4, mv: 1, is_vehicle: true, melee_pref: false, teleport: false, psyker: false, aura: false, colr: make_color_rgb(170, 170, 178) };
    }
    // unknown key falls back to Tactical so a typo cannot crash the overlay
    return grid_unit_def("Tactical");
}

/// @function GridSquad
/// @description One squad on (or headed for) the field. The tile is the squad,
/// the formation is what receives orders (design point 6 and 7).
function GridSquad(_side, _type, _name) constructor {
    side = _side;
    type_key = _type;
    var _d = grid_unit_def(_type);
    disp = _d.disp;
    label = _d.label;
    letter = _d.letter;
    ascii = _d.ascii;
    cost = _d.cost;
    men_max = _d.men;
    men = _d.men;
    hp_man = _d.hp_man;
    hp_max = _d.men * _d.hp_man;
    hp_pool = hp_max;
    armor = _d.armor;
    bal = _d.bal;
    mel = _d.mel;
    rng = _d.rng;
    mv = _d.mv;
    is_vehicle = _d.is_vehicle;
    melee_pref = _d.melee_pref;
    teleport = _d.teleport;
    psyker = _d.psyker;
    aura = _d.aura;
    colr = _d.colr;
    name = _name;
    // sergeant wounds: 2 fine, 1 wounded, 0 down, -1 means no sergeant at all
    sgt_hp = ((_side == 0) && !_d.is_vehicle) ? 2 : -1;
    col = -1;
    row = -1;
    formation = -1;
    alive = true;
    deployed = false;
    picked = false;
    zap_cd = 3;
    kills = 0;
}

/// @function GridFormation
/// @description Player order-receiving group of squads (design point 6, 10, 11).
function GridFormation(_side, _name, _colr) constructor {
    side = _side;
    name = _name;
    colr = _colr;
    members = [];
    order = GRIDORD_ADVANCE;
    order_target = -1;
    dest_col = -1;
    dest_row = -1;
    alive = true;
}

/// @function grid_form_palette
function grid_form_palette(_i) {
    var _p = [
        make_color_rgb(86, 132, 210),
        make_color_rgb(96, 176, 226),
        make_color_rgb(120, 200, 160),
        make_color_rgb(214, 178, 96),
        make_color_rgb(186, 128, 208),
        make_color_rgb(226, 146, 122),
        make_color_rgb(146, 146, 226),
        make_color_rgb(104, 206, 206),
    ];
    return _p[_i mod array_length(_p)];
}

/// @function grid_type_list
/// @description Deployment bar order (design point 4).
function grid_type_list() {
    return ["Tactical", "Assault", "Devastator", "Veteran", "Terminator", "AssaultTerminator", "HQ", "Dreadnought", "Predator", "Guard"];
}

/// @function grid_sgt_names
function grid_sgt_names() {
    return ["Cassius", "Ferox", "Andaros", "Vell", "Tyrus", "Morlo", "Dassan", "Hexal", "Ionne", "Krates", "Baldur", "Sorren", "Vaanes", "Ophid", "Rellik", "Juno", "Mardek", "Thorne", "Corvus", "Attal", "Lucan", "Sarpedon"];
}

/// @function grid_log
function grid_log(ctrl, _txt, _col) {
    array_push(ctrl.feed, { t: _txt, c: _col });
    if (array_length(ctrl.feed) > 60) {
        array_delete(ctrl.feed, 0, 1);
    }
}

/// @function grid_dist
/// @description Chebyshev distance: diagonals count as one tile.
function grid_dist(_c1, _r1, _c2, _r2) {
    return max(abs(_c1 - _c2), abs(_r1 - _r2));
}

/// @function grid_in_bounds
function grid_in_bounds(_c, _r) {
    return ((_c >= 0) && (_c < GRIDC_COLS) && (_r >= 0) && (_r < GRIDC_ROWS));
}

/// @function grid_squad_at
function grid_squad_at(ctrl, _c, _r) {
    if (!grid_in_bounds(_c, _r)) {
        return -1;
    }
    return ctrl.occ[_c][_r];
}

/// @function grid_squad_power
/// @description Display power for the formation finalisation footer (design point 11).
function grid_squad_power(_s) {
    return round(_s.hp_pool / 10 + (_s.bal + _s.mel) * max(1, _s.men) / 4 + _s.armor / 4);
}

/// @function grid_gen_cover
/// @description Random positive and negative cover tiles (green and red squiggles).
function grid_gen_cover(ctrl) {
    for (var _cc = 0; _cc < GRIDC_COLS; _cc++) {
        for (var _cr = 0; _cr < GRIDC_ROWS; _cr++) {
            var _roll = random(1);
            if (_roll < 0.08) {
                ctrl.cov[_cc][_cr] = 1;
            } else if (_roll < 0.12) {
                ctrl.cov[_cc][_cr] = -1;
            } else {
                ctrl.cov[_cc][_cr] = 0;
            }
        }
    }
}

/// @function grid_gen_player_pool
/// @description Generated demi-company standing in for the real roster for now.
function grid_gen_player_pool(ctrl) {
    var _names = grid_sgt_names();
    var _ni = 0;
    var _counts = [
        ["Tactical", 6], ["Assault", 3], ["Devastator", 2], ["Veteran", 2],
        ["Terminator", 1], ["AssaultTerminator", 1], ["HQ", 1],
        ["Dreadnought", 1], ["Predator", 1], ["Guard", 4],
    ];
    for (var _ti = 0; _ti < array_length(_counts); _ti++) {
        var _key = _counts[_ti][0];
        var _num = _counts[_ti][1];
        for (var _k = 0; _k < _num; _k++) {
            var _nm = "";
            if (_key == "Guard") {
                _nm = $"Guard Platoon {_k + 1}";
            } else if (_key == "Dreadnought") {
                _nm = "Dreadnought Invictus";
            } else if (_key == "Predator") {
                _nm = "Predator Wrathbound";
            } else if (_key == "HQ") {
                _nm = "Command Squad";
            } else {
                _nm = $"Squad {_names[_ni mod array_length(_names)]}";
                _ni++;
            }
            array_push(ctrl.squads, new GridSquad(0, _key, _nm));
        }
    }
}

/// @function grid_spawn_enemy_squad
/// @description Place one enemy squad in the eastern deployment band (design point 3).
function grid_spawn_enemy_squad(ctrl, _key, _num) {
    var _d = grid_unit_def(_key);
    var _s = new GridSquad(1, _key, $"{_d.disp} {_num}");
    var _placed = false;
    for (var _band = 0; (_band < 3) && !_placed; _band++) {
        var _c = GRIDC_COLS - 1 - _band;
        var _tries = 0;
        while ((_tries < 40) && !_placed) {
            var _r = irandom(GRIDC_ROWS - 1);
            if (ctrl.occ[_c][_r] == -1) {
                _s.col = _c;
                _s.row = _r;
                _s.deployed = true;
                _placed = true;
            }
            _tries++;
        }
        if (!_placed) {
            for (var _r2 = 0; (_r2 < GRIDC_ROWS) && !_placed; _r2++) {
                if (ctrl.occ[_c][_r2] == -1) {
                    _s.col = _c;
                    _s.row = _r2;
                    _s.deployed = true;
                    _placed = true;
                }
            }
        }
    }
    if (!_placed) {
        return -1;
    }
    array_push(ctrl.squads, _s);
    var _si = array_length(ctrl.squads) - 1;
    ctrl.occ[_s.col][_s.row] = _si;
    return _si;
}

/// @function grid_spawn_enemy_force
function grid_spawn_enemy_force(ctrl) {
    var _i;
    for (_i = 1; _i <= 7; _i++) {
        grid_spawn_enemy_squad(ctrl, "OrkShoota", _i);
    }
    for (_i = 1; _i <= 5; _i++) {
        grid_spawn_enemy_squad(ctrl, "OrkSlugga", _i);
    }
    for (_i = 1; _i <= 2; _i++) {
        grid_spawn_enemy_squad(ctrl, "Nobz", _i);
    }
    grid_spawn_enemy_squad(ctrl, "Weirdboy", 1);
    grid_spawn_enemy_squad(ctrl, "DeffDread", 1);
}

/// @function grid_spawn_wave
/// @description Enemy forces streaming in mid-battle (design point 3).
function grid_spawn_wave(ctrl) {
    var _i;
    for (_i = 8; _i <= 10; _i++) {
        grid_spawn_enemy_squad(ctrl, "OrkShoota", _i);
    }
    for (_i = 6; _i <= 7; _i++) {
        grid_spawn_enemy_squad(ctrl, "OrkSlugga", _i);
    }
    grid_log(ctrl, "Enemy reinforcements pour in from the east!", GRIDC_COL_WARN);
}

/// @function grid_pool_count
function grid_pool_count(ctrl, _key) {
    var _n = 0;
    for (var _i = 0; _i < array_length(ctrl.squads); _i++) {
        var _s = ctrl.squads[_i];
        if ((_s.side == 0) && _s.alive && !_s.deployed && (_s.type_key == _key)) {
            _n++;
        }
    }
    return _n;
}

/// @function grid_pool_indices
function grid_pool_indices(ctrl, _key) {
    var _out = [];
    for (var _i = 0; _i < array_length(ctrl.squads); _i++) {
        var _s = ctrl.squads[_i];
        if ((_s.side == 0) && _s.alive && !_s.deployed && (_s.type_key == _key)) {
            array_push(_out, _i);
        }
    }
    return _out;
}

/// @function grid_picked_stats
/// @description Totals for the formation finalisation footer (design point 11).
function grid_picked_stats(ctrl) {
    var _n = 0;
    var _cost = 0;
    var _pow = 0;
    var _mv = 99;
    for (var _i = 0; _i < array_length(ctrl.squads); _i++) {
        var _s = ctrl.squads[_i];
        if ((_s.side == 0) && _s.alive && !_s.deployed && _s.picked) {
            _n += 1;
            _cost += _s.cost;
            _pow += grid_squad_power(_s);
            _mv = min(_mv, _s.mv);
        }
    }
    if (_n == 0) {
        _mv = 0;
    }
    return { n: _n, cost: _cost, pow: _pow, mv: _mv };
}

/// @function grid_picked_indices
function grid_picked_indices(ctrl) {
    var _out = [];
    for (var _i = 0; _i < array_length(ctrl.squads); _i++) {
        var _s = ctrl.squads[_i];
        if ((_s.side == 0) && _s.alive && !_s.deployed && _s.picked) {
            array_push(_out, _i);
        }
    }
    return _out;
}

/// @function grid_clear_picks
function grid_clear_picks(ctrl) {
    for (var _i = 0; _i < array_length(ctrl.squads); _i++) {
        ctrl.squads[_i].picked = false;
    }
}

/// @function grid_any_deployed
function grid_any_deployed(ctrl) {
    for (var _i = 0; _i < array_length(ctrl.squads); _i++) {
        var _s = ctrl.squads[_i];
        if ((_s.side == 0) && _s.alive && _s.deployed) {
            return true;
        }
    }
    return false;
}

/// @function grid_new_formation
function grid_new_formation(ctrl, _letter) {
    if (!variable_struct_exists(ctrl.form_counters, _letter)) {
        ctrl.form_counters[$ _letter] = 0;
    }
    ctrl.form_counters[$ _letter] += 1;
    var _nm = _letter + string(ctrl.form_counters[$ _letter]);
    var _f = new GridFormation(0, _nm, grid_form_palette(ctrl.form_color_idx));
    ctrl.form_color_idx += 1;
    array_push(ctrl.formations, _f);
    return array_length(ctrl.formations) - 1;
}

/// @function grid_footprint
/// @description Rectangle block shape on placement (design point 6).
function grid_footprint(_n) {
    var _fw = max(1, ceil(sqrt(_n)));
    var _fh = max(1, ceil(_n / _fw));
    return [_fw, _fh];
}

/// @function grid_placement_valid
/// @description Deployment zone rule, with the Terminator teleport exception (design point 2).
function grid_placement_valid(ctrl, _ac, _ar) {
    var _n = array_length(ctrl.placing_list);
    if (_n <= 0) {
        return false;
    }
    var _fp = grid_footprint(_n);
    var _all_tp = true;
    for (var _i = 0; _i < _n; _i++) {
        if (!ctrl.squads[ctrl.placing_list[_i]].teleport) {
            _all_tp = false;
        }
    }
    for (var _k = 0; _k < _n; _k++) {
        var _c = _ac + (_k mod _fp[0]);
        var _r = _ar + (_k div _fp[0]);
        if (!grid_in_bounds(_c, _r)) {
            return false;
        }
        if (ctrl.occ[_c][_r] != -1) {
            return false;
        }
        if (!_all_tp && (_c >= GRIDC_DEPLOY_COLS)) {
            return false;
        }
    }
    return true;
}

/// @function grid_place_formation
function grid_place_formation(ctrl, _ac, _ar) {
    if (!grid_placement_valid(ctrl, _ac, _ar)) {
        return false;
    }
    var _n = array_length(ctrl.placing_list);
    var _fp = grid_footprint(_n);
    var _s0 = ctrl.squads[ctrl.placing_list[0]];
    var _fi = grid_new_formation(ctrl, grid_unit_def(_s0.type_key).letter);
    var _cost = 0;
    for (var _k = 0; _k < _n; _k++) {
        var _si = ctrl.placing_list[_k];
        var _s = ctrl.squads[_si];
        var _c = _ac + (_k mod _fp[0]);
        var _r = _ar + (_k div _fp[0]);
        _s.col = _c;
        _s.row = _r;
        _s.deployed = true;
        _s.picked = false;
        _s.formation = _fi;
        ctrl.occ[_c][_r] = _si;
        array_push(ctrl.formations[_fi].members, _si);
        _cost += _s.cost;
    }
    ctrl.points -= _cost;
    grid_log(ctrl, $"{ctrl.formations[_fi].name} deployed: {_n} squads, {_cost} points.", GRIDC_COL_ORDER);
    ctrl.placing_list = [];
    return true;
}

/// @function grid_undeploy_formation
/// @description Deploy-phase recall with a full point refund.
function grid_undeploy_formation(ctrl, _fi) {
    if ((_fi < 0) || (_fi >= array_length(ctrl.formations))) {
        return;
    }
    var _f = ctrl.formations[_fi];
    if (!_f.alive) {
        return;
    }
    var _refund = 0;
    for (var _i = 0; _i < array_length(_f.members); _i++) {
        var _si = _f.members[_i];
        var _s = ctrl.squads[_si];
        if (grid_in_bounds(_s.col, _s.row) && (ctrl.occ[_s.col][_s.row] == _si)) {
            ctrl.occ[_s.col][_s.row] = -1;
        }
        _s.col = -1;
        _s.row = -1;
        _s.deployed = false;
        _s.formation = -1;
        _refund += _s.cost;
    }
    ctrl.points += _refund;
    _f.alive = false;
    _f.members = [];
    grid_log(ctrl, $"{_f.name} recalled to reserve: {_refund} points refunded.", GRIDC_COL_ORDER);
    if (ctrl.selected_form == _fi) {
        ctrl.selected_form = -1;
    }
}

/// @function grid_deploy_all
/// @description Simple iterative auto-deployment (design addendum).
function grid_deploy_all(ctrl) {
    var _types = grid_type_list();
    var _fielded = 0;
    for (var _t = 0; _t < array_length(_types); _t++) {
        var _pool = grid_pool_indices(ctrl, _types[_t]);
        var _fi = -1;
        for (var _i = 0; _i < array_length(_pool); _i++) {
            var _si = _pool[_i];
            var _s = ctrl.squads[_si];
            if (_s.cost > ctrl.points) {
                continue;
            }
            var _pc = -1;
            var _pr = -1;
            for (var _c = 0; (_c < GRIDC_DEPLOY_COLS) && (_pc < 0); _c++) {
                for (var _r = 0; (_r < GRIDC_ROWS) && (_pc < 0); _r++) {
                    if (ctrl.occ[_c][_r] == -1) {
                        _pc = _c;
                        _pr = _r;
                    }
                }
            }
            if (_pc < 0) {
                break;
            }
            if (_fi < 0) {
                _fi = grid_new_formation(ctrl, grid_unit_def(_s.type_key).letter);
            }
            _s.col = _pc;
            _s.row = _pr;
            _s.deployed = true;
            _s.formation = _fi;
            ctrl.occ[_pc][_pr] = _si;
            array_push(ctrl.formations[_fi].members, _si);
            ctrl.points -= _s.cost;
            _fielded++;
        }
    }
    if (_fielded > 0) {
        grid_log(ctrl, $"Deploy All: {_fielded} squads fielded.", GRIDC_COL_ORDER);
    } else {
        grid_log(ctrl, "Deploy All: nothing affordable left to field.", GRIDC_COL_WARN);
    }
}

/// @function grid_hq_aura
/// @description Command aura: any friendly HQ within range boosts the attacker.
function grid_hq_aura(ctrl, _ai) {
    var _a = ctrl.squads[_ai];
    for (var _i = 0; _i < array_length(ctrl.squads); _i++) {
        var _s = ctrl.squads[_i];
        if ((_s.side == 0) && _s.alive && _s.deployed && _s.aura) {
            if (grid_dist(_a.col, _a.row, _s.col, _s.row) <= GRIDC_HQ_AURA_RANGE) {
                return true;
            }
        }
    }
    return false;
}

/// @function grid_apply_damage
/// @description Shared damage sink: casualties, sergeant wounds, wipes, tallies.
function grid_apply_damage(ctrl, _di, _dmg, _ai) {
    var _d = ctrl.squads[_di];
    _d.hp_pool = max(0, _d.hp_pool - _dmg);
    var _before = _d.men;
    var _after;
    if (_d.is_vehicle) {
        _after = (_d.hp_pool > 0) ? 1 : 0;
    } else {
        _after = clamp(ceil(_d.hp_pool / _d.hp_man), 0, _before);
    }
    _d.men = _after;
    var _killed = _before - _after;
    if (_killed > 0) {
        if (_ai >= 0) {
            ctrl.squads[_ai].kills += _killed;
        }
        if (_d.side == 1) {
            ctrl.agg_ekills += _killed;
            ctrl.total_ekills += _killed;
        } else {
            ctrl.agg_pkills += _killed;
            ctrl.total_pkills += _killed;
        }
        // sergeant pip logic (design point 7): green, red, then black with red border
        if ((_d.sgt_hp > 0) && (random(1) < min(0.5, GRIDC_SGT_HIT_CHANCE * _killed))) {
            _d.sgt_hp -= 1;
            if (_d.sgt_hp == 0) {
                grid_log(ctrl, $"{_d.name}: Sergeant down!", GRIDC_COL_WARN);
            }
        }
    }
    if ((_d.hp_pool <= 0) && _d.alive) {
        _d.alive = false;
        _d.men = 0;
        if (_d.sgt_hp > 0) {
            _d.sgt_hp = 0;
        }
        if (grid_in_bounds(_d.col, _d.row) && (ctrl.occ[_d.col][_d.row] == _di)) {
            ctrl.occ[_d.col][_d.row] = -1;
        }
        if (_d.side == 1) {
            ctrl.wiped_e += 1;
            grid_log(ctrl, $"{_d.name} destroyed!", GRIDC_COL_FEED);
        } else {
            ctrl.wiped_p += 1;
            grid_log(ctrl, $"{_d.name} wiped out!", GRIDC_COL_ENEMY);
        }
    }
    return _killed;
}

/// @function grid_attack
/// @description One volley or melee round. Cover applies to ranged fire only.
function grid_attack(ctrl, _ai, _di, _melee) {
    var _a = ctrl.squads[_ai];
    var _d = ctrl.squads[_di];
    var _stat = _melee ? _a.mel : _a.bal;
    if (_stat <= 0) {
        return;
    }
    var _eff = _a.men + ((_a.sgt_hp > 0) ? 1 : 0);
    var _mult = random_range(0.8, 1.2);
    if (_a.sgt_hp == 0) {
        _mult *= GRIDC_SGT_DOWN_MULT;
    }
    if ((_a.side == 0) && grid_hq_aura(ctrl, _ai)) {
        _mult *= GRIDC_HQ_AURA_MULT;
    }
    var _dmg = _stat * _eff * _mult;
    _dmg *= 100 / (100 + _d.armor * GRIDC_ARMOR_CURVE);
    if (!_melee) {
        var _cv = ctrl.cov[_d.col][_d.row];
        if (_cv > 0) {
            _dmg *= GRIDC_COVER_POS_MULT;
        }
        if (_cv < 0) {
            _dmg *= GRIDC_COVER_NEG_MULT;
        }
    }
    _dmg = max(1, _dmg);
    grid_apply_damage(ctrl, _di, _dmg, _ai);
}

/// @function grid_nearest_foe
/// @description Nearest living deployed enemy; pass a max range or -1 for any.
function grid_nearest_foe(ctrl, _si, _max_d) {
    var _s = ctrl.squads[_si];
    var _best = -1;
    var _bd = 99999;
    for (var _i = 0; _i < array_length(ctrl.squads); _i++) {
        if (_i == _si) {
            continue;
        }
        var _o = ctrl.squads[_i];
        if ((_o.side == _s.side) || !_o.alive || !_o.deployed) {
            continue;
        }
        var _dd = grid_dist(_s.col, _s.row, _o.col, _o.row);
        if (_dd < _bd) {
            _bd = _dd;
            _best = _i;
        }
    }
    if ((_best >= 0) && (_max_d >= 0) && (_bd > _max_d)) {
        return -1;
    }
    return _best;
}

/// @function grid_step_toward
/// @description Greedy movement: up to mv steps, never increasing distance,
/// sidestepping occupied tiles. Deliberate placeholder for real pathfinding.
function grid_step_toward(ctrl, _si, _gc, _gr) {
    var _s = ctrl.squads[_si];
    repeat (_s.mv) {
        var _cd = grid_dist(_s.col, _s.row, _gc, _gr);
        if (_cd <= 0) {
            break;
        }
        var _dc = sign(_gc - _s.col);
        var _dr = sign(_gr - _s.row);
        var _opts = [
            [_dc, _dr],
            [_dc, 0],
            [0, _dr],
            [_dc, -_dr],
            [-_dc, _dr],
        ];
        var _moved = false;
        for (var _k = 0; (_k < array_length(_opts)) && !_moved; _k++) {
            var _nc = _s.col + _opts[_k][0];
            var _nr = _s.row + _opts[_k][1];
            if ((_opts[_k][0] == 0) && (_opts[_k][1] == 0)) {
                continue;
            }
            if (!grid_in_bounds(_nc, _nr)) {
                continue;
            }
            if (ctrl.occ[_nc][_nr] != -1) {
                continue;
            }
            if (grid_dist(_nc, _nr, _gc, _gr) > _cd) {
                continue;
            }
            ctrl.occ[_s.col][_s.row] = -1;
            _s.col = _nc;
            _s.row = _nr;
            ctrl.occ[_nc][_nr] = _si;
            _moved = true;
        }
        if (!_moved) {
            break;
        }
    }
}

/// @function grid_act_player
/// @description Default behaviour is advance and attack nearest (design point 6),
/// overridden by the formation order.
function grid_act_player(ctrl, _si) {
    var _s = ctrl.squads[_si];
    var _f = (_s.formation >= 0) ? ctrl.formations[_s.formation] : undefined;
    var _ord = (_f == undefined) ? GRIDORD_ADVANCE : _f.order;

    if (_ord == GRIDORD_MOVE) {
        grid_step_toward(ctrl, _si, _f.dest_col, _f.dest_row);
        return;
    }

    var _ti = -1;
    if ((_ord == GRIDORD_ATTACK) && (_f != undefined)) {
        _ti = _f.order_target;
    }
    if ((_ti < 0) || !ctrl.squads[_ti].alive) {
        var _lim = (_ord == GRIDORD_HOLD) ? _s.rng : -1;
        _ti = grid_nearest_foe(ctrl, _si, _lim);
    }
    if (_ti < 0) {
        return;
    }

    var _t = ctrl.squads[_ti];
    var _dd = grid_dist(_s.col, _s.row, _t.col, _t.row);
    if (_dd <= 1) {
        grid_attack(ctrl, _si, _ti, true);
    } else if ((_dd <= _s.rng) && (_s.bal > 0) && !_s.melee_pref) {
        grid_attack(ctrl, _si, _ti, false);
    } else if (_ord != GRIDORD_HOLD) {
        grid_step_toward(ctrl, _si, _t.col, _t.row);
    }
}

/// @function grid_act_enemy
/// @description Simple enemy AI: charge or shoot the nearest. The Weirdboy keeps
/// his distance and zaps the strongest squad in reach, armour ignored.
function grid_act_enemy(ctrl, _si) {
    var _s = ctrl.squads[_si];

    if (_s.psyker) {
        if (_s.zap_cd > 0) {
            _s.zap_cd -= 1;
        }
        var _near = grid_nearest_foe(ctrl, _si, -1);
        if (_near < 0) {
            return;
        }
        var _nd = grid_dist(_s.col, _s.row, ctrl.squads[_near].col, ctrl.squads[_near].row);
        if (_nd <= _s.rng) {
            if (_s.zap_cd <= 0) {
                var _best = -1;
                var _bh = -1;
                for (var _i = 0; _i < array_length(ctrl.squads); _i++) {
                    var _q = ctrl.squads[_i];
                    if ((_q.side != 0) || !_q.alive || !_q.deployed) {
                        continue;
                    }
                    if (grid_dist(_s.col, _s.row, _q.col, _q.row) > _s.rng) {
                        continue;
                    }
                    if (_q.hp_pool > _bh) {
                        _bh = _q.hp_pool;
                        _best = _i;
                    }
                }
                if (_best >= 0) {
                    var _zd = 55 + irandom(25);
                    var _kk = grid_apply_damage(ctrl, _best, _zd, _si);
                    grid_log(ctrl, $"Weirdboy zzap scorches {ctrl.squads[_best].name}: {_kk} down!", GRIDC_COL_ENEMY);
                    _s.zap_cd = 6;
                }
            }
        } else {
            grid_step_toward(ctrl, _si, ctrl.squads[_near].col, ctrl.squads[_near].row);
        }
        return;
    }

    var _ti = grid_nearest_foe(ctrl, _si, -1);
    if (_ti < 0) {
        return;
    }
    var _t = ctrl.squads[_ti];
    var _dd = grid_dist(_s.col, _s.row, _t.col, _t.row);
    if (_dd <= 1) {
        grid_attack(ctrl, _si, _ti, true);
    } else if ((_dd <= _s.rng) && (_s.bal > 0) && !_s.melee_pref) {
        grid_attack(ctrl, _si, _ti, false);
    } else {
        grid_step_toward(ctrl, _si, _t.col, _t.row);
    }
}

/// @function grid_battle_tick
/// @description One resolution tick: formation upkeep, every squad acts, the
/// rolling kill feed flushes, then the end conditions are checked.
function grid_battle_tick(ctrl) {
    ctrl.ticks += 1;

    if ((ctrl.waves_left > 0) && (ctrl.ticks >= GRIDC_WAVE_TICK)) {
        ctrl.waves_left -= 1;
        grid_spawn_wave(ctrl);
    }

    for (var _f = 0; _f < array_length(ctrl.formations); _f++) {
        var _fm = ctrl.formations[_f];
        if (!_fm.alive) {
            continue;
        }
        var _living = 0;
        var _arrived = true;
        for (var _m = 0; _m < array_length(_fm.members); _m++) {
            var _ms = ctrl.squads[_fm.members[_m]];
            if (_ms.alive && _ms.deployed) {
                _living += 1;
                if ((_fm.order == GRIDORD_MOVE) && (grid_dist(_ms.col, _ms.row, _fm.dest_col, _fm.dest_row) > 2)) {
                    _arrived = false;
                }
            }
        }
        if (_living == 0) {
            _fm.alive = false;
            continue;
        }
        if (_fm.order == GRIDORD_ATTACK) {
            var _tt = _fm.order_target;
            if ((_tt < 0) || !ctrl.squads[_tt].alive) {
                _fm.order = GRIDORD_ADVANCE;
                _fm.order_target = -1;
                grid_log(ctrl, $"{_fm.name}: target destroyed, advancing.", GRIDC_COL_ORDER);
            }
        }
        if ((_fm.order == GRIDORD_MOVE) && _arrived) {
            _fm.order = GRIDORD_HOLD;
            grid_log(ctrl, $"{_fm.name}: position reached, holding.", GRIDC_COL_ORDER);
        }
    }

    for (var _i = 0; _i < array_length(ctrl.squads); _i++) {
        var _s = ctrl.squads[_i];
        if (!_s.alive || !_s.deployed) {
            continue;
        }
        if (_s.side == 0) {
            grid_act_player(ctrl, _i);
        } else {
            grid_act_enemy(ctrl, _i);
        }
    }

    if ((ctrl.ticks mod 5) == 0) {
        if ((ctrl.agg_ekills > 0) || (ctrl.agg_pkills > 0)) {
            grid_log(ctrl, $"Exchange: {ctrl.agg_ekills} greenskins down, {ctrl.agg_pkills} of ours lost.", GRIDC_COL_FEED);
            ctrl.agg_ekills = 0;
            ctrl.agg_pkills = 0;
        }
    }

    var _pn = 0;
    var _en = 0;
    for (var _k = 0; _k < array_length(ctrl.squads); _k++) {
        var _q = ctrl.squads[_k];
        if (!_q.alive || !_q.deployed) {
            continue;
        }
        if (_q.side == 0) {
            _pn += 1;
        } else {
            _en += 1;
        }
    }
    if ((_en == 0) && (ctrl.waves_left <= 0)) {
        ctrl.phase = GRIDPH_END;
        ctrl.result = 1;
    } else if (_pn == 0) {
        ctrl.phase = GRIDPH_END;
        ctrl.result = 2;
    }
}

/// @function grid_popup_rect
/// @description Formation creation popup geometry (design point 5).
function grid_popup_rect() {
    return [336, 96, 580, 610];
}

/// @function grid_buttons
/// @description Single source of truth for every button rect. The Step event
/// hit-tests this list and the Draw event renders it, so they can never drift.
function grid_buttons(ctrl) {
    var _b = [];
    var _deploy = (ctrl.phase == GRIDPH_DEPLOY);
    var _battle = (ctrl.phase == GRIDPH_BATTLE);

    // deployment bar (design points 1 and 4)
    var _types = grid_type_list();
    var _y = 132;
    for (var _t = 0; _t < array_length(_types); _t++) {
        var _key = _types[_t];
        var _cnt = grid_pool_count(ctrl, _key);
        var _d = grid_unit_def(_key);
        array_push(_b, {
            bx: 16, by: _y, bw: 248, bh: 40,
            bid: "type:" + _key,
            blabel: $"{_d.disp}  ({_cnt})  {_d.cost}pt",
            benabled: _deploy && (_cnt > 0),
        });
        _y += 46;
    }
    array_push(_b, { bx: 16, by: 640, bw: 248, bh: 44, bid: "deployall", blabel: "Deploy All", benabled: _deploy });
    array_push(_b, { bx: 16, by: 696, bw: 248, bh: 56, bid: "start", blabel: "BEGIN BATTLE", benabled: _deploy && grid_any_deployed(ctrl) });

    // battle controls
    array_push(_b, { bx: 1344, by: 740, bw: 248, bh: 44, bid: "pause", blabel: ctrl.paused ? "Resume" : "Pause", benabled: _battle });
    array_push(_b, { bx: 1344, by: 793, bw: 248, bh: 44, bid: "speed", blabel: $"Speed x{ctrl.speed_mult}", benabled: _battle });
    array_push(_b, { bx: 1344, by: 846, bw: 248, bh: 44, bid: "exit", blabel: (ctrl.exit_arm > 0) ? "Confirm Exit" : "Exit Battle", benabled: true });

    // context order buttons in the free space area (design point 9)
    if (_battle && (ctrl.selected_form >= 0)) {
        array_push(_b, { bx: 994, by: 850, bw: 128, bh: 32, bid: "ord_adv", blabel: "Advance", benabled: true });
        array_push(_b, { bx: 1132, by: 850, bw: 128, bh: 32, bid: "ord_hold", blabel: "Hold", benabled: true });
    }
    return _b;
}
