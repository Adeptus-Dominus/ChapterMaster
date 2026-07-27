// Grid combat prototype: Uxie's redesign, styled to match vanilla Chapter Master.
// Everything is prefixed grid_/GRIDC_/Grid to stay clear of the live combat system.
// Nothing here reads or writes campaign state; forces are generated per battle.

// ---------------------------------------------------------------------------
// Palette: the same greens the rest of the game draws with.
// ---------------------------------------------------------------------------
#macro GRIDC_GREEN CM_GREEN_COLOR
#macro GRIDC_RED CM_RED_COLOR
#macro GRIDC_DIM make_color_rgb(24, 84, 54)
#macro GRIDC_BG make_color_rgb(6, 10, 8)
#macro GRIDC_PANEL make_color_rgb(2, 6, 4)
#macro GRIDC_COL_FEED CM_GREEN_COLOR
#macro GRIDC_COL_ORDER make_color_rgb(120, 230, 170)
#macro GRIDC_COL_WARN c_yellow
#macro GRIDC_COL_ENEMY CM_RED_COLOR

// ---------------------------------------------------------------------------
// Layout. Fixed 1600x900 GUI, matching SettingsManager display_set_gui_size.
// ---------------------------------------------------------------------------
#macro GRIDC_LP_X1 8
#macro GRIDC_LP_X2 272
#macro GRIDC_BF_X1 280
#macro GRIDC_BF_Y1 56
#macro GRIDC_BF_X2 1320
#macro GRIDC_BF_Y2 640
#macro GRIDC_RP_X1 1328
#macro GRIDC_RP_X2 1592
#macro GRIDC_LOG_Y1 648
#macro GRIDC_LOG_Y2 892
#macro GRIDC_PANEL_Y2 892

// ---------------------------------------------------------------------------
// Tuning.
// ---------------------------------------------------------------------------
#macro GRIDC_TILE 40
#macro GRIDC_TILE_MIN 9
#macro GRIDC_TICK_FRAMES 18
#macro GRIDC_SCROLL_SPEED 14
#macro GRIDC_DEPLOY_COLS 4
#macro GRIDC_ENEMY_COLS 4
#macro GRIDC_SGT_HIT_CHANCE 0.12
#macro GRIDC_COVER_GOOD 0.70
#macro GRIDC_COVER_BAD 1.25
#macro GRIDC_HQ_AURA 1.10
#macro GRIDC_HQ_RANGE 3
#macro GRIDC_JUMP_RANGE 8
#macro GRIDC_WAVE_TICK 45
#macro GRIDC_WAVES 1
#macro GRIDC_FLOAT_LIFE 80
#macro GRIDC_FLOAT_RISE 0.4
#macro GRIDC_FLASH_FRAMES 24
#macro GRIDC_DRAG_MIN 8

#macro GRIDPH_DEPLOY 0
#macro GRIDPH_BATTLE 1
#macro GRIDPH_END 2

#macro GRIDORD_ADVANCE 0
#macro GRIDORD_ATTACK 1
#macro GRIDORD_MOVE 2
#macro GRIDORD_HOLD 3

/// @function grid_unit_def
/// @description Stat table. hp_man times men is the squad HP pool, so an Ork mob
/// fields roughly three times the bodies of a marine squad to reach the same pool
/// while carrying far worse armour. Speed is tiles per tick as a float: 0.5 heavy,
/// 1.0 infantry and battle tanks, 2.0 transports, 3.0 bikes and skimmers.
/// The sprite field is a hook: set it to a real sprite index later and the tile
/// art swaps over with no other change.
function grid_unit_def(_key) {
    var _t = {
        tactical:      { disp: "Tacticals",       men: 10, hp_man: 12, armour: 12, mel: 10, bal: 13, rng: 6, spd: 1.0, cost: 2, glyph: "infantry",  ascii: "T",  vehicle: false, melee: false, tele: false, jump: false, sprite: -1 },
        assault:       { disp: "Assaults",        men: 10, hp_man: 12, armour: 11, mel: 15, bal: 7,  rng: 3, spd: 1.0, cost: 2, glyph: "jump",      ascii: "A",  vehicle: false, melee: true,  tele: false, jump: true,  sprite: -1 },
        devastator:    { disp: "Devastators",     men: 10, hp_man: 12, armour: 12, mel: 8,  bal: 18, rng: 9, spd: 0.5, cost: 3, glyph: "heavy",     ascii: "D",  vehicle: false, melee: false, tele: false, jump: false, sprite: -1 },
        veteran:       { disp: "Veterans",        men: 10, hp_man: 14, armour: 13, mel: 14, bal: 15, rng: 6, spd: 1.0, cost: 3, glyph: "infantry",  ascii: "V",  vehicle: false, melee: false, tele: false, jump: false, sprite: -1 },
        terminator:    { disp: "Terminators",     men: 5,  hp_man: 26, armour: 20, mel: 16, bal: 16, rng: 5, spd: 0.5, cost: 4, glyph: "term",      ascii: "TR", vehicle: false, melee: false, tele: true,  jump: false, sprite: -1 },
        assault_term:  { disp: "Asslt Terms",     men: 5,  hp_man: 26, armour: 20, mel: 22, bal: 5,  rng: 2, spd: 0.5, cost: 4, glyph: "term",      ascii: "AT", vehicle: false, melee: true,  tele: true,  jump: false, sprite: -1 },
        scout:         { disp: "Scouts",          men: 10, hp_man: 9,  armour: 7,  mel: 8,  bal: 11, rng: 7, spd: 1.0, cost: 1, glyph: "scout",     ascii: "S",  vehicle: false, melee: false, tele: false, jump: false, sprite: -1 },
        hq:            { disp: "Command",         men: 5,  hp_man: 20, armour: 15, mel: 20, bal: 15, rng: 5, spd: 1.0, cost: 3, glyph: "hq",        ascii: "HQ", vehicle: false, melee: false, tele: false, jump: false, sprite: -1 },
        guardsmen:     { disp: "Guardsmen",       men: 20, hp_man: 5,  armour: 5,  mel: 4,  bal: 7,  rng: 6, spd: 1.0, cost: 1, glyph: "guard",     ascii: "G",  vehicle: false, melee: false, tele: false, jump: false, sprite: -1 },
        heavy_weapons: { disp: "Heavy Weapons",   men: 12, hp_man: 5,  armour: 5,  mel: 3,  bal: 15, rng: 9, spd: 0.5, cost: 2, glyph: "heavy",     ascii: "HW", vehicle: false, melee: false, tele: false, jump: false, sprite: -1 },
        dreadnought:   { disp: "Dreadnoughts",    men: 1,  hp_man: 180, armour: 26, mel: 26, bal: 20, rng: 7, spd: 1.0, cost: 5, glyph: "walker",   ascii: "DN", vehicle: true,  melee: false, tele: false, jump: false, sprite: -1 },
        predator:      { disp: "Predators",       men: 1,  hp_man: 210, armour: 30, mel: 6,  bal: 26, rng: 9, spd: 1.0, cost: 4, glyph: "tank",     ascii: "PR", vehicle: true,  melee: false, tele: false, jump: false, sprite: -1 },
        land_raider:   { disp: "Land Raiders",    men: 1,  hp_man: 320, armour: 38, mel: 8,  bal: 28, rng: 9, spd: 0.5, cost: 6, glyph: "tank",     ascii: "LR", vehicle: true,  melee: false, tele: false, jump: false, sprite: -1 },
        rhino:         { disp: "Rhinos",          men: 1,  hp_man: 140, armour: 22, mel: 4,  bal: 8,  rng: 5, spd: 2.0, cost: 2, glyph: "transport",ascii: "RH", vehicle: true,  melee: false, tele: false, jump: false, sprite: -1 },
        chimera:       { disp: "Chimeras",        men: 1,  hp_man: 120, armour: 18, mel: 4,  bal: 12, rng: 7, spd: 2.0, cost: 2, glyph: "transport",ascii: "CH", vehicle: true,  melee: false, tele: false, jump: false, sprite: -1 },
        land_speeder:  { disp: "Land Speeders",   men: 1,  hp_man: 90,  armour: 16, mel: 6,  bal: 20, rng: 8, spd: 3.0, cost: 3, glyph: "speeder",  ascii: "LS", vehicle: true,  melee: false, tele: false, jump: false, sprite: -1 },
        whirlwind:     { disp: "Whirlwinds",      men: 1,  hp_man: 130, armour: 20, mel: 4,  bal: 30, rng: 12, spd: 1.0, cost: 4, glyph: "tank",    ascii: "WW", vehicle: true,  melee: false, tele: false, jump: false, sprite: -1 },
        ork_shoota:    { disp: "Shoota Boyz",     men: 30, hp_man: 4,  armour: 3,  mel: 8,  bal: 6,  rng: 5, spd: 1.0, cost: 0, glyph: "ork",       ascii: "S",  vehicle: false, melee: false, tele: false, jump: false, sprite: -1 },
        ork_slugga:    { disp: "Slugga Boyz",     men: 30, hp_man: 4,  armour: 3,  mel: 11, bal: 3,  rng: 2, spd: 1.0, cost: 0, glyph: "ork",       ascii: "B",  vehicle: false, melee: true,  tele: false, jump: false, sprite: -1 },
        ork_nob:       { disp: "Nobz",            men: 10, hp_man: 14, armour: 9,  mel: 20, bal: 8,  rng: 4, spd: 1.0, cost: 0, glyph: "orkbig",    ascii: "N",  vehicle: false, melee: true,  tele: false, jump: false, sprite: -1 },
        ork_weirdboy:  { disp: "Weirdboy",        men: 4,  hp_man: 12, armour: 4,  mel: 10, bal: 4,  rng: 3, spd: 1.0, cost: 0, glyph: "psyker",    ascii: "WB", vehicle: false, melee: false, tele: false, jump: false, sprite: -1 },
        ork_dread:     { disp: "Deff Dread",      men: 1,  hp_man: 170, armour: 20, mel: 24, bal: 12, rng: 4, spd: 1.0, cost: 0, glyph: "orkwalker",ascii: "DD", vehicle: true,  melee: true,  tele: false, jump: false, sprite: -1 },
        ork_wagon:     { disp: "Battlewagon",     men: 1,  hp_man: 200, armour: 22, mel: 10, bal: 16, rng: 6, spd: 2.0, cost: 0, glyph: "transport",ascii: "BW", vehicle: true,  melee: false, tele: false, jump: false, sprite: -1 },
    };
    if (variable_struct_exists(_t, _key)) {
        return _t[$ _key];
    }
    return _t.tactical;
}

/// @function grid_type_list
/// @description Player deployable types, in the order the left bar lists them.
function grid_type_list() {
    return [
        "tactical", "assault", "devastator", "veteran", "terminator", "assault_term",
        "scout", "hq", "guardsmen", "heavy_weapons", "dreadnought", "rhino",
        "chimera", "predator", "land_raider", "land_speeder", "whirlwind",
    ];
}

/// @function grid_form_palette
function grid_form_palette() {
    return [
        CM_GREEN_COLOR,
        make_color_rgb(120, 220, 160),
        make_color_rgb(80, 190, 200),
        make_color_rgb(160, 210, 110),
        make_color_rgb(70, 170, 210),
        make_color_rgb(190, 220, 140),
        make_color_rgb(110, 200, 190),
        make_color_rgb(150, 190, 240),
    ];
}

/// @function grid_sgt_names
function grid_sgt_names() {
    return [
        "Aeschus", "Bardan", "Corvane", "Dreux", "Eleon", "Faustus", "Gaius",
        "Helion", "Ithuriel", "Jorel", "Kaeso", "Lucian", "Marcus", "Nikaen",
        "Orbec", "Pellas", "Quintus", "Ravan", "Solon", "Tiberon", "Ulmar", "Varro",
    ];
}

/// @function GridSquad
function GridSquad(_side, _type, _name) constructor {
    var _d = grid_unit_def(_type);
    side = _side;
    type = _type;
    name = _name;
    disp = _d.disp;
    men = _d.men;
    men0 = _d.men;
    hp_man = _d.hp_man;
    hp_pool = _d.men * _d.hp_man;
    hp_max = hp_pool;
    armour = _d.armour;
    mel = _d.mel;
    bal = _d.bal;
    rng = _d.rng;
    spd = _d.spd;
    cost = _d.cost;
    is_vehicle = _d.vehicle;
    melee_pref = _d.melee;
    can_tele = _d.tele;
    can_jump = _d.jump;
    jumped = false;
    glyph = _d.glyph;
    ascii = _d.ascii;
    sprite_hook = _d.sprite;
    col = -1;
    row = -1;
    alive = true;
    deployed = false;
    formation = -1;
    picked = false;
    mv_acc = 0;
    zap_cd = 3;
    kills = 0;
    hit_kills = 0;
    hit_dmg = 0;
    hit_flash = 0;
    if (_d.vehicle || (_side == 1)) {
        sgt_hp = -1;
        sgt_name = "";
    } else {
        sgt_hp = 2;
        var _sn = grid_sgt_names();
        sgt_name = _sn[irandom(array_length(_sn) - 1)];
    }
}

/// @function GridFormation
function GridFormation(_side, _name, _colr) constructor {
    side = _side;
    name = _name;
    colr = _colr;
    members = [];
    order = GRIDORD_ADVANCE;
    order_target = -1;
    dest_col = -1;
    dest_row = -1;
    stance = 0;
    alive = true;
}

/// @function grid_log
function grid_log(ctrl, _txt, _col) {
    array_push(ctrl.feed, { ltxt: _txt, lcol: _col });
    if (array_length(ctrl.feed) > 200) {
        array_delete(ctrl.feed, 0, 1);
    }
}

/// @function grid_floater
/// @description Short lived combat text above a tile, Caves of Qud style. Stored
/// in world tile coordinates so it stays glued to the ground while the view pans.
function grid_floater(ctrl, _c, _r, _txt, _col) {
    array_push(ctrl.floaters, {
        fc: _c,
        fr: _r,
        fjit: irandom_range(-7, 7),
        frise: 0,
        ftxt: _txt,
        fcol: _col,
        flife: GRIDC_FLOAT_LIFE,
    });
    if (array_length(ctrl.floaters) > 120) {
        array_delete(ctrl.floaters, 0, 1);
    }
}

/// @function grid_dist
function grid_dist(_c1, _r1, _c2, _r2) {
    return max(abs(_c1 - _c2), abs(_r1 - _r2));
}

/// @function grid_in_bounds
function grid_in_bounds(ctrl, _c, _r) {
    return ((_c >= 0) && (_c < ctrl.cols) && (_r >= 0) && (_r < ctrl.rows));
}

/// @function grid_squad_at
function grid_squad_at(ctrl, _c, _r) {
    if (!grid_in_bounds(ctrl, _c, _r)) {
        return -1;
    }
    return ctrl.occ[_c][_r];
}

// ---------------------------------------------------------------------------
// Camera. The battlefield can be far larger than its viewport, so every draw
// and every hit test goes through these two helpers.
// ---------------------------------------------------------------------------

/// @function grid_tile_px
/// @description Pixels per tile at the current zoom. Overview shrinks tiles until
/// the whole field fits the viewport; there are only these two steps by design.
function grid_tile_px(ctrl) {
    if (ctrl.zoom_mode == 0) {
        return GRIDC_TILE;
    }
    var _vw = GRIDC_BF_X2 - GRIDC_BF_X1;
    var _vh = GRIDC_BF_Y2 - GRIDC_BF_Y1;
    var _fit = floor(min(_vw / max(1, ctrl.cols), _vh / max(1, ctrl.rows)));
    return clamp(_fit, GRIDC_TILE_MIN, GRIDC_TILE);
}

/// @function grid_clamp_view
function grid_clamp_view(ctrl) {
    var _tp = grid_tile_px(ctrl);
    var _mx = max(0, ctrl.cols * _tp - (GRIDC_BF_X2 - GRIDC_BF_X1));
    var _my = max(0, ctrl.rows * _tp - (GRIDC_BF_Y2 - GRIDC_BF_Y1));
    ctrl.view_x = clamp(ctrl.view_x, 0, _mx);
    ctrl.view_y = clamp(ctrl.view_y, 0, _my);
}

/// @function grid_centre_view
/// @description Puts a tile in the middle of the viewport, used when zooming so
/// the ground under the cursor does not jump away.
function grid_centre_view(ctrl, _c, _r) {
    var _tp = grid_tile_px(ctrl);
    ctrl.view_x = _c * _tp - (GRIDC_BF_X2 - GRIDC_BF_X1) / 2;
    ctrl.view_y = _r * _tp - (GRIDC_BF_Y2 - GRIDC_BF_Y1) / 2;
    grid_clamp_view(ctrl);
}

/// @function grid_sx
function grid_sx(ctrl, _c) {
    return GRIDC_BF_X1 + _c * grid_tile_px(ctrl) - ctrl.view_x;
}

/// @function grid_sy
function grid_sy(ctrl, _r) {
    return GRIDC_BF_Y1 + _r * grid_tile_px(ctrl) - ctrl.view_y;
}

/// @function grid_mouse_col
function grid_mouse_col(ctrl, _mx) {
    return floor((_mx - GRIDC_BF_X1 + ctrl.view_x) / grid_tile_px(ctrl));
}

/// @function grid_mouse_row
function grid_mouse_row(ctrl, _my) {
    return floor((_my - GRIDC_BF_Y1 + ctrl.view_y) / grid_tile_px(ctrl));
}

/// @function grid_in_viewport
function grid_in_viewport(_mx, _my) {
    return point_in_rectangle(_mx, _my, GRIDC_BF_X1, GRIDC_BF_Y1, GRIDC_BF_X2, GRIDC_BF_Y2);
}

// ---------------------------------------------------------------------------
// Battle sizing. Combat width is the whole economy: it is the deployment point
// budget, the depth of the deploy band, and the scale of the grid itself.
// ---------------------------------------------------------------------------

/// @function grid_size_width
function grid_size_width(_size) {
    switch (string_lower(_size)) {
        case "small": return 8;
        case "large": return 18;
        case "huge": return 26;
        default: return 12;
    }
}

/// @function grid_setup_field
/// @description Derives grid dimensions and the point budget from combat width.
function grid_setup_field(ctrl, _width) {
    ctrl.combat_width = clamp(_width, 6, 40);
    ctrl.points = ctrl.combat_width;
    ctrl.rows = ctrl.combat_width + 6;
    ctrl.cols = round(ctrl.combat_width * 2.2) + 8;
    ctrl.band_r1 = floor((ctrl.rows - ctrl.combat_width) / 2);
    ctrl.band_r2 = ctrl.band_r1 + ctrl.combat_width - 1;
    ctrl.occ = array_create(ctrl.cols);
    ctrl.cov = array_create(ctrl.cols);
    for (var _c = 0; _c < ctrl.cols; _c++) {
        ctrl.occ[_c] = array_create(ctrl.rows, -1);
        ctrl.cov[_c] = array_create(ctrl.rows, 0);
    }
}

/// @function grid_gen_cover
function grid_gen_cover(ctrl) {
    for (var _c = 0; _c < ctrl.cols; _c++) {
        for (var _r = 0; _r < ctrl.rows; _r++) {
            var _roll = random(1);
            if (_roll < 0.08) {
                ctrl.cov[_c][_r] = 1;
            } else if (_roll < 0.12) {
                ctrl.cov[_c][_r] = -1;
            }
        }
    }
}

/// @function grid_in_deploy_zone
function grid_in_deploy_zone(ctrl, _c, _r) {
    return ((_c >= 0) && (_c < GRIDC_DEPLOY_COLS) && (_r >= ctrl.band_r1) && (_r <= ctrl.band_r2));
}

/// @function grid_gen_player_pool
/// @description Roster scaled to the combat width, in vanilla proportions:
/// mostly Tacticals, a supporting spread of specialists, a little armour.
function grid_gen_player_pool(ctrl) {
    var _w = ctrl.combat_width;
    var _mix = [
        ["tactical", max(3, round(_w * 0.55))],
        ["assault", max(1, round(_w * 0.22))],
        ["devastator", max(1, round(_w * 0.22))],
        ["scout", max(1, round(_w * 0.18))],
        ["veteran", max(1, round(_w * 0.14))],
        ["guardsmen", max(2, round(_w * 0.5))],
        ["heavy_weapons", max(1, round(_w * 0.14))],
        ["terminator", max(1, round(_w * 0.12))],
        ["assault_term", max(1, round(_w * 0.1))],
        ["hq", 1],
        ["dreadnought", max(1, round(_w * 0.1))],
        ["rhino", max(1, round(_w * 0.2))],
        ["chimera", max(1, round(_w * 0.14))],
        ["predator", max(1, round(_w * 0.1))],
        ["land_raider", max(1, round(_w * 0.06))],
        ["land_speeder", max(1, round(_w * 0.12))],
        ["whirlwind", max(1, round(_w * 0.08))],
    ];
    for (var _i = 0; _i < array_length(_mix); _i++) {
        var _key = _mix[_i][0];
        var _n = _mix[_i][1];
        for (var _k = 0; _k < _n; _k++) {
            var _d = grid_unit_def(_key);
            var _sq = new GridSquad(0, _key, $"{_d.disp} {_k + 1}");
            array_push(ctrl.squads, _sq);
        }
    }
}

/// @function grid_spawn_enemy_squad
function grid_spawn_enemy_squad(ctrl, _key, _idx) {
    var _d = grid_unit_def(_key);
    var _sq = new GridSquad(1, _key, $"{_d.disp} {_idx}");
    var _placed = false;
    for (var _try = 0; _try < 200; _try++) {
        var _c = ctrl.cols - 1 - irandom(GRIDC_ENEMY_COLS - 1);
        var _r = irandom(ctrl.rows - 1);
        if (ctrl.occ[_c][_r] == -1) {
            _sq.col = _c;
            _sq.row = _r;
            _placed = true;
            break;
        }
    }
    if (!_placed) {
        for (var _c2 = ctrl.cols - 1; _c2 >= 0; _c2--) {
            for (var _r2 = 0; _r2 < ctrl.rows; _r2++) {
                if (ctrl.occ[_c2][_r2] == -1) {
                    _sq.col = _c2;
                    _sq.row = _r2;
                    _placed = true;
                    break;
                }
            }
            if (_placed) {
                break;
            }
        }
    }
    if (!_placed) {
        return -1;
    }
    _sq.deployed = true;
    array_push(ctrl.squads, _sq);
    var _si = array_length(ctrl.squads) - 1;
    ctrl.occ[_sq.col][_sq.row] = _si;
    return _si;
}

/// @function grid_spawn_enemy_force
/// @description The horde is sized off combat width too, so both sides scale
/// together and the front stays the thing that decides the shape of the fight.
function grid_spawn_enemy_force(ctrl) {
    var _w = ctrl.combat_width;
    var _mix = [
        ["ork_shoota", max(3, round(_w * 0.7))],
        ["ork_slugga", max(2, round(_w * 0.55))],
        ["ork_nob", max(1, round(_w * 0.2))],
        ["ork_dread", max(1, round(_w * 0.12))],
        ["ork_wagon", max(1, round(_w * 0.08))],
        ["ork_weirdboy", 1],
    ];
    var _n = 1;
    for (var _i = 0; _i < array_length(_mix); _i++) {
        for (var _k = 0; _k < _mix[_i][1]; _k++) {
            grid_spawn_enemy_squad(ctrl, _mix[_i][0], _n);
            _n += 1;
        }
    }
}

/// @function grid_spawn_wave
function grid_spawn_wave(ctrl) {
    var _n = max(3, round(ctrl.combat_width * 0.4));
    var _base = array_length(ctrl.squads);
    for (var _i = 0; _i < _n; _i++) {
        grid_spawn_enemy_squad(ctrl, (_i mod 2 == 0) ? "ork_shoota" : "ork_slugga", _base + _i);
    }
    ctrl.waves_left -= 1;
    grid_log(ctrl, "More greenskins pour onto the field!", GRIDC_COL_WARN);
}

// ---------------------------------------------------------------------------
// Pool and picking helpers for the deployment popup.
// ---------------------------------------------------------------------------

/// @function grid_pool_indices
function grid_pool_indices(ctrl, _key) {
    var _out = [];
    for (var _i = 0; _i < array_length(ctrl.squads); _i++) {
        var _s = ctrl.squads[_i];
        if ((_s.side == 0) && (_s.type == _key) && !_s.deployed && _s.alive) {
            array_push(_out, _i);
        }
    }
    return _out;
}

/// @function grid_pool_count
function grid_pool_count(ctrl, _key) {
    return array_length(grid_pool_indices(ctrl, _key));
}

/// @function grid_picked_indices
function grid_picked_indices(ctrl) {
    var _out = [];
    for (var _i = 0; _i < array_length(ctrl.squads); _i++) {
        if (ctrl.squads[_i].picked) {
            array_push(_out, _i);
        }
    }
    return _out;
}

/// @function grid_picked_stats
function grid_picked_stats(ctrl) {
    var _n = 0;
    var _cost = 0;
    var _pow = 0;
    var _mv = 99;
    var _list = grid_picked_indices(ctrl);
    for (var _i = 0; _i < array_length(_list); _i++) {
        var _s = ctrl.squads[_list[_i]];
        _n += 1;
        _cost += _s.cost;
        _pow += grid_squad_power(_s);
        _mv = min(_mv, _s.spd);
    }
    return { n: _n, cost: _cost, pow: round(_pow), mv: (_n > 0) ? _mv : 0 };
}

/// @function grid_clear_picks
function grid_clear_picks(ctrl) {
    for (var _i = 0; _i < array_length(ctrl.squads); _i++) {
        ctrl.squads[_i].picked = false;
    }
}

/// @function grid_squad_power
function grid_squad_power(_s) {
    return (_s.hp_pool / 10) + ((_s.bal + _s.mel) * max(1, _s.men) / 4) + (_s.armour / 4);
}

/// @function grid_any_deployed
function grid_any_deployed(ctrl) {
    for (var _i = 0; _i < array_length(ctrl.squads); _i++) {
        var _s = ctrl.squads[_i];
        if ((_s.side == 0) && _s.deployed && _s.alive) {
            return true;
        }
    }
    return false;
}

// ---------------------------------------------------------------------------
// Formations and placement.
// ---------------------------------------------------------------------------

/// @function grid_new_formation
function grid_new_formation(ctrl, _type) {
    var _d = grid_unit_def(_type);
    var _letters = string_upper(string_copy(_d.disp, 1, 1));
    if (string_length(_d.ascii) > 1) {
        _letters = _d.ascii;
    }
    var _cnt = 1;
    if (variable_struct_exists(ctrl.form_counters, _letters)) {
        _cnt = ctrl.form_counters[$ _letters] + 1;
    }
    ctrl.form_counters[$ _letters] = _cnt;
    var _pal = grid_form_palette();
    var _f = new GridFormation(0, $"{_letters}{_cnt}", _pal[ctrl.form_color_idx mod array_length(_pal)]);
    ctrl.form_color_idx += 1;
    array_push(ctrl.formations, _f);
    return array_length(ctrl.formations) - 1;
}

/// @function grid_footprint
/// @description Rectangle block shape. Width follows ctrl.placing_w, adjusted by
/// the wheel and R while placing; the popup Deploy button resets it to square.
function grid_footprint(ctrl, _n) {
    var _fw = clamp(ctrl.placing_w, 1, max(1, _n));
    var _fh = max(1, ceil(_n / _fw));
    return [_fw, _fh];
}

/// @function grid_placement_valid
function grid_placement_valid(ctrl, _list, _ac, _ar) {
    var _n = array_length(_list);
    if (_n <= 0) {
        return false;
    }
    var _all_tele = true;
    for (var _i = 0; _i < _n; _i++) {
        if (!ctrl.squads[_list[_i]].can_tele) {
            _all_tele = false;
            break;
        }
    }
    var _fp = grid_footprint(ctrl, _n);
    var _k = 0;
    for (var _dy = 0; _dy < _fp[1]; _dy++) {
        for (var _dx = 0; _dx < _fp[0]; _dx++) {
            if (_k >= _n) {
                break;
            }
            var _c = _ac + _dx;
            var _r = _ar + _dy;
            if (!grid_in_bounds(ctrl, _c, _r)) {
                return false;
            }
            if (ctrl.occ[_c][_r] != -1) {
                return false;
            }
            if (!_all_tele && !grid_in_deploy_zone(ctrl, _c, _r)) {
                return false;
            }
            if (_all_tele && (_c >= ctrl.cols - 1)) {
                return false;
            }
            _k += 1;
        }
    }
    return true;
}

/// @function grid_place_formation
function grid_place_formation(ctrl, _ac, _ar) {
    var _list = ctrl.placing_list;
    var _n = array_length(_list);
    if (!grid_placement_valid(ctrl, _list, _ac, _ar)) {
        return false;
    }
    var _cost = 0;
    for (var _i = 0; _i < _n; _i++) {
        _cost += ctrl.squads[_list[_i]].cost;
    }
    if (_cost > ctrl.points) {
        grid_log(ctrl, "Not enough deployment points.", GRIDC_COL_WARN);
        return false;
    }
    var _fi = grid_new_formation(ctrl, ctrl.squads[_list[0]].type);
    var _f = ctrl.formations[_fi];
    var _fp = grid_footprint(ctrl, _n);
    var _k = 0;
    var _tele = false;
    for (var _dy = 0; _dy < _fp[1]; _dy++) {
        for (var _dx = 0; _dx < _fp[0]; _dx++) {
            if (_k >= _n) {
                break;
            }
            var _si = _list[_k];
            var _s = ctrl.squads[_si];
            _s.col = _ac + _dx;
            _s.row = _ar + _dy;
            _s.deployed = true;
            _s.picked = false;
            _s.formation = _fi;
            ctrl.occ[_s.col][_s.row] = _si;
            array_push(_f.members, _si);
            if (_s.can_tele && !grid_in_deploy_zone(ctrl, _s.col, _s.row)) {
                _tele = true;
            }
            _k += 1;
        }
    }
    ctrl.points -= _cost;
    ctrl.placing = false;
    ctrl.placing_list = [];
    if (_tele) {
        grid_log(ctrl, $"{_f.name} teleports onto the field.", GRIDC_COL_ORDER);
        grid_floater(ctrl, _ac, _ar, "TELEPORT", GRIDC_COL_ORDER);
    } else {
        grid_log(ctrl, $"{_f.name} deploys: {_n} squads, {_cost} points.", GRIDC_COL_ORDER);
    }
    return true;
}

/// @function grid_undeploy_formation
function grid_undeploy_formation(ctrl, _fi) {
    if ((_fi < 0) || (_fi >= array_length(ctrl.formations))) {
        return;
    }
    var _f = ctrl.formations[_fi];
    var _refund = 0;
    for (var _i = 0; _i < array_length(_f.members); _i++) {
        var _si = _f.members[_i];
        var _s = ctrl.squads[_si];
        if (grid_in_bounds(ctrl, _s.col, _s.row) && (ctrl.occ[_s.col][_s.row] == _si)) {
            ctrl.occ[_s.col][_s.row] = -1;
        }
        _s.col = -1;
        _s.row = -1;
        _s.deployed = false;
        _s.formation = -1;
        _refund += _s.cost;
    }
    _f.members = [];
    _f.alive = false;
    ctrl.points += _refund;
    grid_log(ctrl, $"{_f.name} recalled: {_refund} points returned.", GRIDC_COL_ORDER);
}

/// @function grid_deploy_all
function grid_deploy_all(ctrl) {
    var _types = grid_type_list();
    var _any = false;
    for (var _i = 0; _i < array_length(_types); _i++) {
        var _pool = grid_pool_indices(ctrl, _types[_i]);
        if (array_length(_pool) <= 0) {
            continue;
        }
        var _afford = [];
        var _spend = 0;
        for (var _k = 0; _k < array_length(_pool); _k++) {
            var _c = ctrl.squads[_pool[_k]].cost;
            if (_spend + _c <= ctrl.points) {
                array_push(_afford, _pool[_k]);
                _spend += _c;
            }
        }
        if (array_length(_afford) <= 0) {
            continue;
        }
        ctrl.placing_list = _afford;
        ctrl.placing_w = max(1, ceil(sqrt(array_length(_afford))));
        var _done = false;
        for (var _c2 = 0; (_c2 < GRIDC_DEPLOY_COLS) && !_done; _c2++) {
            for (var _r2 = ctrl.band_r1; (_r2 <= ctrl.band_r2) && !_done; _r2++) {
                if (grid_place_formation(ctrl, _c2, _r2)) {
                    _done = true;
                    _any = true;
                }
            }
        }
        if (!_done) {
            ctrl.placing = false;
            ctrl.placing_list = [];
        }
    }
    if (!_any) {
        grid_log(ctrl, "No room or no points left to deploy.", GRIDC_COL_WARN);
    }
}

// ---------------------------------------------------------------------------
// Combat resolution.
// ---------------------------------------------------------------------------

/// @function grid_hq_aura
function grid_hq_aura(ctrl, _s) {
    for (var _i = 0; _i < array_length(ctrl.squads); _i++) {
        var _h = ctrl.squads[_i];
        if ((_h.side != _s.side) || !_h.alive || (_h.type != "hq")) {
            continue;
        }
        if (grid_dist(_h.col, _h.row, _s.col, _s.row) <= GRIDC_HQ_RANGE) {
            return GRIDC_HQ_AURA;
        }
    }
    return 1;
}

/// @function grid_apply_damage
function grid_apply_damage(ctrl, _di, _dmg, _ai) {
    var _d = ctrl.squads[_di];
    _d.hp_pool = max(0, _d.hp_pool - _dmg);
    _d.hit_dmg += _dmg;
    _d.hit_flash = GRIDC_FLASH_FRAMES;
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
        _d.hit_kills += _killed;
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
        if ((_d.sgt_hp > 0) && (random(1) < min(0.5, GRIDC_SGT_HIT_CHANCE * _killed))) {
            _d.sgt_hp -= 1;
            if (_d.sgt_hp == 0) {
                grid_log(ctrl, $"{_d.name}: Sergeant {_d.sgt_name} is down!", GRIDC_COL_WARN);
                grid_floater(ctrl, _d.col, _d.row, "Sgt down!", GRIDC_COL_WARN);
            }
        }
    }
    if ((_d.hp_pool <= 0) && _d.alive) {
        _d.alive = false;
        _d.men = 0;
        if (_d.sgt_hp > 0) {
            _d.sgt_hp = 0;
        }
        if (grid_in_bounds(ctrl, _d.col, _d.row) && (ctrl.occ[_d.col][_d.row] == _di)) {
            ctrl.occ[_d.col][_d.row] = -1;
        }
        if (_d.side == 1) {
            ctrl.wiped_e += 1;
            grid_log(ctrl, $"{_d.name} destroyed!", GRIDC_COL_FEED);
            grid_floater(ctrl, _d.col, _d.row, "DESTROYED", GRIDC_COL_FEED);
        } else {
            ctrl.wiped_p += 1;
            grid_log(ctrl, $"{_d.name} wiped out!", GRIDC_COL_ENEMY);
            grid_floater(ctrl, _d.col, _d.row, "WIPED", GRIDC_COL_ENEMY);
        }
    }
    return _killed;
}

/// @function grid_attack
function grid_attack(ctrl, _ai, _di, _melee) {
    var _a = ctrl.squads[_ai];
    var _d = ctrl.squads[_di];
    var _stat = _melee ? _a.mel : _a.bal;
    if (_stat <= 0) {
        return 0;
    }
    var _eff = max(1, _a.men);
    var _raw = _stat * _eff * random_range(0.8, 1.2);
    if (_a.sgt_hp == 0) {
        _raw *= 0.9;
    }
    _raw *= grid_hq_aura(ctrl, _a);
    _raw *= 100 / (100 + _d.armour * 2);
    if (!_melee && grid_in_bounds(ctrl, _d.col, _d.row)) {
        var _cv = ctrl.cov[_d.col][_d.row];
        if (_cv == 1) {
            _raw *= GRIDC_COVER_GOOD;
        } else if (_cv == -1) {
            _raw *= GRIDC_COVER_BAD;
        }
    }
    return grid_apply_damage(ctrl, _di, _raw, _ai);
}

/// @function grid_nearest_foe
function grid_nearest_foe(ctrl, _si, _limit) {
    var _s = ctrl.squads[_si];
    var _best = -1;
    var _bd = 99999;
    for (var _i = 0; _i < array_length(ctrl.squads); _i++) {
        var _t = ctrl.squads[_i];
        if (!_t.alive || !_t.deployed || (_t.side == _s.side)) {
            continue;
        }
        var _dd = grid_dist(_s.col, _s.row, _t.col, _t.row);
        if ((_limit >= 0) && (_dd > _limit)) {
            continue;
        }
        if (_dd < _bd) {
            _bd = _dd;
            _best = _i;
        }
    }
    return _best;
}

/// @function grid_free_tile_near
/// @description First empty tile adjacent to a target, used by the assault leap.
function grid_free_tile_near(ctrl, _tc, _tr) {
    for (var _dx = -1; _dx <= 1; _dx++) {
        for (var _dy = -1; _dy <= 1; _dy++) {
            if ((_dx == 0) && (_dy == 0)) {
                continue;
            }
            var _c = _tc + _dx;
            var _r = _tr + _dy;
            if (grid_in_bounds(ctrl, _c, _r) && (ctrl.occ[_c][_r] == -1)) {
                return [_c, _r];
            }
        }
    }
    return [-1, -1];
}

/// @function grid_try_jump
/// @description Assault squads answer a focus fire order by leaping onto the
/// target and starting a melee. Once per battle, like the live mod's jump packs.
function grid_try_jump(ctrl, _si, _ti) {
    var _s = ctrl.squads[_si];
    if (!_s.can_jump || _s.jumped) {
        return false;
    }
    var _t = ctrl.squads[_ti];
    var _dd = grid_dist(_s.col, _s.row, _t.col, _t.row);
    if ((_dd <= 1) || (_dd > GRIDC_JUMP_RANGE)) {
        return false;
    }
    var _spot = grid_free_tile_near(ctrl, _t.col, _t.row);
    if (_spot[0] < 0) {
        return false;
    }
    if (grid_in_bounds(ctrl, _s.col, _s.row) && (ctrl.occ[_s.col][_s.row] == _si)) {
        ctrl.occ[_s.col][_s.row] = -1;
    }
    _s.col = _spot[0];
    _s.row = _spot[1];
    ctrl.occ[_s.col][_s.row] = _si;
    _s.jumped = true;
    grid_floater(ctrl, _s.col, _s.row, "LEAP!", GRIDC_COL_ORDER);
    grid_log(ctrl, $"{_s.name} descends on {_t.name}!", GRIDC_COL_ORDER);
    return true;
}

/// @function grid_step_toward
/// @description Greedy one tile step. Placeholder for real pathfinding: it will
/// not route around a long wall of bodies, which is acceptable at this scale.
function grid_step_toward(ctrl, _si, _tc, _tr) {
    var _s = ctrl.squads[_si];
    var _dc = sign(_tc - _s.col);
    var _dr = sign(_tr - _s.row);
    if ((_dc == 0) && (_dr == 0)) {
        return false;
    }
    var _opts = [
        [_dc, _dr],
        [_dc, 0],
        [0, _dr],
        [_dc, -_dr],
        [-_dc, _dr],
    ];
    var _cd = grid_dist(_s.col, _s.row, _tc, _tr);
    for (var _k = 0; _k < array_length(_opts); _k++) {
        var _nc = _s.col + _opts[_k][0];
        var _nr = _s.row + _opts[_k][1];
        if ((_opts[_k][0] == 0) && (_opts[_k][1] == 0)) {
            continue;
        }
        if (!grid_in_bounds(ctrl, _nc, _nr)) {
            continue;
        }
        if (ctrl.occ[_nc][_nr] != -1) {
            continue;
        }
        if (grid_dist(_nc, _nr, _tc, _tr) > _cd) {
            continue;
        }
        ctrl.occ[_s.col][_s.row] = -1;
        _s.col = _nc;
        _s.row = _nr;
        ctrl.occ[_nc][_nr] = _si;
        return true;
    }
    return false;
}

/// @function grid_step_away
function grid_step_away(ctrl, _si, _fc, _fr) {
    var _s = ctrl.squads[_si];
    var _dc = sign(_s.col - _fc);
    var _dr = sign(_s.row - _fr);
    if ((_dc == 0) && (_dr == 0)) {
        _dc = -1;
    }
    var _opts = [[_dc, _dr], [_dc, 0], [0, _dr]];
    var _cd = grid_dist(_s.col, _s.row, _fc, _fr);
    for (var _k = 0; _k < array_length(_opts); _k++) {
        var _nc = _s.col + _opts[_k][0];
        var _nr = _s.row + _opts[_k][1];
        if ((_opts[_k][0] == 0) && (_opts[_k][1] == 0)) {
            continue;
        }
        if (!grid_in_bounds(ctrl, _nc, _nr)) {
            continue;
        }
        if (ctrl.occ[_nc][_nr] != -1) {
            continue;
        }
        if (grid_dist(_nc, _nr, _fc, _fr) <= _cd) {
            continue;
        }
        ctrl.occ[_s.col][_s.row] = -1;
        _s.col = _nc;
        _s.row = _nr;
        ctrl.occ[_nc][_nr] = _si;
        return true;
    }
    return false;
}

/// @function grid_move_budget
/// @description Speed is a float; the accumulator turns fractional speeds into
/// whole tile steps, so heavies genuinely crawl at half infantry pace.
function grid_move_budget(_s) {
    _s.mv_acc += _s.spd;
    var _steps = floor(_s.mv_acc);
    _s.mv_acc -= _steps;
    return _steps;
}

/// @function grid_act_player
function grid_act_player(ctrl, _si) {
    var _s = ctrl.squads[_si];
    var _f = (_s.formation >= 0) ? ctrl.formations[_s.formation] : undefined;
    var _ord = (_f == undefined) ? GRIDORD_ADVANCE : _f.order;
    var _stance = (_f == undefined) ? 0 : _f.stance;
    var _steps = grid_move_budget(_s);

    if (_ord == GRIDORD_MOVE) {
        for (var _m = 0; _m < _steps; _m++) {
            if (!grid_step_toward(ctrl, _si, _f.dest_col, _f.dest_row)) {
                break;
            }
        }
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

    if ((_ord == GRIDORD_ATTACK) && grid_try_jump(ctrl, _si, _ti)) {
        grid_attack(ctrl, _si, _ti, true);
        return;
    }

    var _t = ctrl.squads[_ti];
    var _dd = grid_dist(_s.col, _s.row, _t.col, _t.row);
    var _seek = (_stance == 1) || ((_stance == 0) && _s.melee_pref);

    if (_stance == 2) {
        if (_dd <= 1) {
            if (!grid_step_away(ctrl, _si, _t.col, _t.row)) {
                grid_attack(ctrl, _si, _ti, true);
            }
            return;
        }
        if ((_dd <= _s.rng) && (_s.bal > 0)) {
            grid_attack(ctrl, _si, _ti, false);
        } else if ((_ord != GRIDORD_HOLD) && (_dd > _s.rng)) {
            for (var _m2 = 0; _m2 < _steps; _m2++) {
                if (!grid_step_toward(ctrl, _si, _t.col, _t.row)) {
                    break;
                }
            }
        }
        return;
    }

    if (_dd <= 1) {
        grid_attack(ctrl, _si, _ti, true);
    } else if ((_dd <= _s.rng) && (_s.bal > 0) && !_seek) {
        grid_attack(ctrl, _si, _ti, false);
    } else if (_ord != GRIDORD_HOLD) {
        for (var _m3 = 0; _m3 < _steps; _m3++) {
            if (!grid_step_toward(ctrl, _si, _t.col, _t.row)) {
                break;
            }
        }
    }
}

/// @function grid_act_enemy
function grid_act_enemy(ctrl, _si) {
    var _s = ctrl.squads[_si];
    var _steps = grid_move_budget(_s);
    if (_s.type == "ork_weirdboy") {
        _s.zap_cd -= 1;
        if (_s.zap_cd <= 0) {
            var _best = -1;
            var _bp = -1;
            for (var _i = 0; _i < array_length(ctrl.squads); _i++) {
                var _p = ctrl.squads[_i];
                if ((_p.side != 0) || !_p.alive || !_p.deployed) {
                    continue;
                }
                if (grid_dist(_s.col, _s.row, _p.col, _p.row) > 8) {
                    continue;
                }
                var _pw = grid_squad_power(_p);
                if (_pw > _bp) {
                    _bp = _pw;
                    _best = _i;
                }
            }
            if (_best >= 0) {
                var _zd = 55 + irandom(25);
                var _kk = grid_apply_damage(ctrl, _best, _zd, _si);
                grid_log(ctrl, $"Weirdboy zzap scorches {ctrl.squads[_best].name}: {_kk} down!", GRIDC_COL_ENEMY);
                grid_floater(ctrl, ctrl.squads[_best].col, ctrl.squads[_best].row, "ZZAP!", make_color_rgb(208, 110, 230));
                _s.zap_cd = 6;
                return;
            }
        }
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
        for (var _m = 0; _m < _steps; _m++) {
            if (!grid_step_toward(ctrl, _si, _t.col, _t.row)) {
                break;
            }
        }
    }
}

/// @function grid_battle_tick
function grid_battle_tick(ctrl) {
    ctrl.ticks += 1;
    ctrl.agg_ekills = 0;
    ctrl.agg_pkills = 0;

    var _order = [];
    for (var _i = 0; _i < array_length(ctrl.squads); _i++) {
        array_push(_order, _i);
    }
    for (var _sh = array_length(_order) - 1; _sh > 0; _sh--) {
        var _j = irandom(_sh);
        var _tmp = _order[_sh];
        _order[_sh] = _order[_j];
        _order[_j] = _tmp;
    }

    for (var _k = 0; _k < array_length(_order); _k++) {
        var _si = _order[_k];
        var _s = ctrl.squads[_si];
        if (!_s.alive || !_s.deployed) {
            continue;
        }
        if (_s.side == 0) {
            grid_act_player(ctrl, _si);
        } else {
            grid_act_enemy(ctrl, _si);
        }
    }

    for (var _fl = 0; _fl < array_length(ctrl.squads); _fl++) {
        var _fq = ctrl.squads[_fl];
        if ((_fq.hit_kills <= 0) && (_fq.hit_dmg <= 0)) {
            continue;
        }
        if (grid_in_bounds(ctrl, _fq.col, _fq.row)) {
            var _fcol = (_fq.side == 1) ? GRIDC_COL_FEED : GRIDC_COL_ENEMY;
            if (_fq.is_vehicle) {
                grid_floater(ctrl, _fq.col, _fq.row, $"-{round(_fq.hit_dmg)}", _fcol);
            } else if (_fq.hit_kills > 0) {
                grid_floater(ctrl, _fq.col, _fq.row, $"-{_fq.hit_kills}", _fcol);
            }
        }
        _fq.hit_kills = 0;
        _fq.hit_dmg = 0;
    }

    if ((ctrl.ticks mod 5) == 0) {
        grid_log(ctrl, $"Exchange: {ctrl.agg_ekills} greenskins slain, {ctrl.agg_pkills} of ours lost.", GRIDC_COL_FEED);
    }

    if ((ctrl.waves_left > 0) && (ctrl.ticks >= GRIDC_WAVE_TICK)) {
        grid_spawn_wave(ctrl);
    }

    var _pl = 0;
    var _en = 0;
    for (var _c = 0; _c < array_length(ctrl.squads); _c++) {
        var _q = ctrl.squads[_c];
        if (!_q.alive || !_q.deployed) {
            continue;
        }
        if (_q.side == 0) {
            _pl += 1;
        } else {
            _en += 1;
        }
    }
    if (_pl <= 0) {
        ctrl.phase = GRIDPH_END;
        ctrl.result = -1;
    } else if ((_en <= 0) && (ctrl.waves_left <= 0)) {
        ctrl.phase = GRIDPH_END;
        ctrl.result = 1;
    }
}

// ---------------------------------------------------------------------------
// Selection. Standard RTS handling: left selects, right commands.
// ---------------------------------------------------------------------------

/// @function grid_sel_clear
function grid_sel_clear(ctrl) {
    ctrl.selected = [];
}

/// @function grid_sel_has
function grid_sel_has(ctrl, _fi) {
    for (var _i = 0; _i < array_length(ctrl.selected); _i++) {
        if (ctrl.selected[_i] == _fi) {
            return true;
        }
    }
    return false;
}

/// @function grid_sel_add
function grid_sel_add(ctrl, _fi) {
    if ((_fi < 0) || (_fi >= array_length(ctrl.formations))) {
        return;
    }
    if (!ctrl.formations[_fi].alive) {
        return;
    }
    if (!grid_sel_has(ctrl, _fi)) {
        array_push(ctrl.selected, _fi);
    }
}

/// @function grid_sel_prune
/// @description Drops formations that died or were recalled out from under the
/// selection, so orders never fire at a stale index.
function grid_sel_prune(ctrl) {
    var _keep = [];
    for (var _i = 0; _i < array_length(ctrl.selected); _i++) {
        var _fi = ctrl.selected[_i];
        if ((_fi < 0) || (_fi >= array_length(ctrl.formations))) {
            continue;
        }
        var _f = ctrl.formations[_fi];
        if (!_f.alive) {
            continue;
        }
        var _live = false;
        for (var _k = 0; _k < array_length(_f.members); _k++) {
            if (ctrl.squads[_f.members[_k]].alive) {
                _live = true;
                break;
            }
        }
        if (_live) {
            array_push(_keep, _fi);
        }
    }
    ctrl.selected = _keep;
}

/// @function grid_sel_box
/// @description Drag select: any player formation with a living squad inside the
/// dragged rectangle joins the selection.
function grid_sel_box(ctrl, _x1, _y1, _x2, _y2) {
    var _lx = min(_x1, _x2);
    var _rx = max(_x1, _x2);
    var _ty = min(_y1, _y2);
    var _by = max(_y1, _y2);
    var _tp = grid_tile_px(ctrl);
    grid_sel_clear(ctrl);
    for (var _i = 0; _i < array_length(ctrl.squads); _i++) {
        var _s = ctrl.squads[_i];
        if ((_s.side != 0) || !_s.alive || !_s.deployed || (_s.formation < 0)) {
            continue;
        }
        var _px = grid_sx(ctrl, _s.col) + _tp / 2;
        var _py = grid_sy(ctrl, _s.row) + _tp / 2;
        if (point_in_rectangle(_px, _py, _lx, _ty, _rx, _by)) {
            grid_sel_add(ctrl, _s.formation);
        }
    }
    return array_length(ctrl.selected);
}

/// @function grid_order_move
function grid_order_move(ctrl, _c, _r) {
    for (var _i = 0; _i < array_length(ctrl.selected); _i++) {
        var _f = ctrl.formations[ctrl.selected[_i]];
        _f.order = GRIDORD_MOVE;
        _f.dest_col = _c;
        _f.dest_row = _r;
        _f.order_target = -1;
    }
}

/// @function grid_order_attack
function grid_order_attack(ctrl, _ti) {
    for (var _i = 0; _i < array_length(ctrl.selected); _i++) {
        var _f = ctrl.formations[ctrl.selected[_i]];
        _f.order = GRIDORD_ATTACK;
        _f.order_target = _ti;
    }
}

// ---------------------------------------------------------------------------
// Unit art. Line glyphs drawn from primitives in the game's own green, so the
// prototype ships no third party artwork. Set the sprite field in grid_unit_def
// to a real sprite index and grid_draw_unit will use that instead.
// ---------------------------------------------------------------------------

/// @function grid_draw_glyph
function grid_draw_glyph(_kind, _cx, _cy, _s, _col) {
    draw_set_color(_col);
    var _h = _s / 2;
    switch (_kind) {
        case "infantry":
        case "guard":
            draw_circle(_cx, _cy - _h * 0.35, _h * 0.42, true);
            draw_rectangle(_cx - _h * 0.5, _cy + _h * 0.05, _cx + _h * 0.5, _cy + _h * 0.75, true);
            break;
        case "heavy":
            draw_circle(_cx, _cy - _h * 0.35, _h * 0.38, true);
            draw_rectangle(_cx - _h * 0.6, _cy + _h * 0.05, _cx + _h * 0.6, _cy + _h * 0.75, true);
            draw_line(_cx - _h * 0.85, _cy + _h * 0.4, _cx + _h * 0.85, _cy + _h * 0.4);
            break;
        case "term":
            draw_circle(_cx, _cy - _h * 0.3, _h * 0.34, true);
            draw_rectangle(_cx - _h * 0.8, _cy + _h * 0.02, _cx + _h * 0.8, _cy + _h * 0.7, true);
            draw_line(_cx - _h * 0.8, _cy + _h * 0.02, _cx - _h * 0.8, _cy + _h * 0.7);
            break;
        case "jump":
            draw_circle(_cx, _cy - _h * 0.3, _h * 0.36, true);
            draw_rectangle(_cx - _h * 0.42, _cy + _h * 0.08, _cx + _h * 0.42, _cy + _h * 0.7, true);
            draw_line(_cx - _h * 0.45, _cy + _h * 0.1, _cx - _h * 0.9, _cy - _h * 0.35);
            draw_line(_cx + _h * 0.45, _cy + _h * 0.1, _cx + _h * 0.9, _cy - _h * 0.35);
            break;
        case "hq":
            draw_circle(_cx, _cy - _h * 0.3, _h * 0.4, true);
            draw_rectangle(_cx - _h * 0.5, _cy + _h * 0.1, _cx + _h * 0.5, _cy + _h * 0.75, true);
            draw_line(_cx, _cy - _h * 0.95, _cx - _h * 0.3, _cy - _h * 0.55);
            draw_line(_cx, _cy - _h * 0.95, _cx + _h * 0.3, _cy - _h * 0.55);
            break;
        case "scout":
            draw_circle(_cx, _cy - _h * 0.3, _h * 0.32, true);
            draw_rectangle(_cx - _h * 0.38, _cy + _h * 0.05, _cx + _h * 0.38, _cy + _h * 0.68, true);
            draw_line(_cx + _h * 0.3, _cy - _h * 0.6, _cx + _h * 0.6, _cy - _h * 0.95);
            break;
        case "walker":
            draw_rectangle(_cx - _h * 0.55, _cy - _h * 0.7, _cx + _h * 0.55, _cy + _h * 0.1, true);
            draw_line(_cx - _h * 0.35, _cy + _h * 0.1, _cx - _h * 0.7, _cy + _h * 0.85);
            draw_line(_cx + _h * 0.35, _cy + _h * 0.1, _cx + _h * 0.7, _cy + _h * 0.85);
            break;
        case "orkwalker":
            draw_rectangle(_cx - _h * 0.6, _cy - _h * 0.65, _cx + _h * 0.6, _cy + _h * 0.15, true);
            draw_line(_cx - _h * 0.35, _cy + _h * 0.15, _cx - _h * 0.75, _cy + _h * 0.9);
            draw_line(_cx + _h * 0.35, _cy + _h * 0.15, _cx + _h * 0.75, _cy + _h * 0.9);
            draw_line(_cx - _h * 0.6, _cy - _h * 0.65, _cx - _h * 0.95, _cy - _h * 0.95);
            break;
        case "tank":
            draw_rectangle(_cx - _h * 0.85, _cy - _h * 0.1, _cx + _h * 0.85, _cy + _h * 0.55, true);
            draw_rectangle(_cx - _h * 0.35, _cy - _h * 0.55, _cx + _h * 0.35, _cy - _h * 0.1, true);
            draw_line(_cx, _cy - _h * 0.55, _cx, _cy - _h * 0.95);
            break;
        case "transport":
            draw_rectangle(_cx - _h * 0.85, _cy - _h * 0.35, _cx + _h * 0.55, _cy + _h * 0.5, true);
            draw_line(_cx + _h * 0.55, _cy - _h * 0.35, _cx + _h * 0.9, _cy + _h * 0.1);
            draw_line(_cx + _h * 0.9, _cy + _h * 0.1, _cx + _h * 0.55, _cy + _h * 0.5);
            break;
        case "speeder":
            draw_line(_cx - _h * 0.9, _cy + _h * 0.35, _cx + _h * 0.9, _cy - _h * 0.1);
            draw_line(_cx - _h * 0.9, _cy + _h * 0.35, _cx + _h * 0.2, _cy + _h * 0.6);
            draw_line(_cx + _h * 0.2, _cy + _h * 0.6, _cx + _h * 0.9, _cy - _h * 0.1);
            break;
        case "ork":
            draw_circle(_cx, _cy - _h * 0.2, _h * 0.45, true);
            draw_line(_cx - _h * 0.3, _cy + _h * 0.2, _cx - _h * 0.15, _cy + _h * 0.45);
            draw_line(_cx + _h * 0.3, _cy + _h * 0.2, _cx + _h * 0.15, _cy + _h * 0.45);
            break;
        case "orkbig":
            draw_circle(_cx, _cy - _h * 0.25, _h * 0.5, true);
            draw_rectangle(_cx - _h * 0.7, _cy + _h * 0.2, _cx + _h * 0.7, _cy + _h * 0.7, true);
            break;
        case "psyker":
            draw_circle(_cx, _cy - _h * 0.2, _h * 0.4, true);
            draw_line(_cx - _h * 0.5, _cy + _h * 0.75, _cx, _cy + _h * 0.3);
            draw_line(_cx, _cy + _h * 0.3, _cx - _h * 0.25, _cy + _h * 0.7);
            draw_line(_cx - _h * 0.25, _cy + _h * 0.7, _cx + _h * 0.45, _cy + _h * 0.2);
            break;
        default:
            draw_rectangle(_cx - _h * 0.5, _cy - _h * 0.5, _cx + _h * 0.5, _cy + _h * 0.5, true);
            break;
    }
}

/// @function grid_draw_unit
/// @description Tile art. Real sprites take over automatically once a sprite
/// index is set on the type; below a readable size it falls back to the vanilla
/// style letter code so an overview zoom stays legible.
function grid_draw_unit(_s, _cx, _cy, _tp, _col) {
    if ((_s.sprite_hook != -1) && sprite_exists(_s.sprite_hook)) {
        var _sc = (_tp * 0.8) / max(1, sprite_get_width(_s.sprite_hook));
        draw_sprite_ext(_s.sprite_hook, 0, _cx, _cy, _sc, _sc, 0, c_white, 1);
        return;
    }
    if (_tp < 18) {
        draw_set_color(_col);
        draw_set_font(fnt_small);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(_cx, _cy, _s.ascii);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        return;
    }
    grid_draw_glyph(_s.glyph, _cx, _cy, _tp * 0.72, _col);
}

// ---------------------------------------------------------------------------
// Buttons. One source of truth: the Step event hit tests this list and the Draw
// event renders it, so the two can never drift apart.
// ---------------------------------------------------------------------------

/// @function grid_popup_rect
function grid_popup_rect() {
    return [420, 120, 1000, 700];
}

/// @function grid_buttons
function grid_buttons(ctrl) {
    var _b = [];
    var _deploy = (ctrl.phase == GRIDPH_DEPLOY);
    var _battle = (ctrl.phase == GRIDPH_BATTLE);
    var _field = _deploy || _battle;

    var _types = grid_type_list();
    var _y = 96;
    for (var _i = 0; _i < array_length(_types); _i++) {
        var _key = _types[_i];
        var _d = grid_unit_def(_key);
        var _cnt = grid_pool_count(ctrl, _key);
        array_push(_b, {
            bx: GRIDC_LP_X1 + 8, by: _y, bw: 240, bh: 34,
            bid: "type:" + _key,
            blabel: $"{_d.disp} ({_cnt}) {_d.cost}pt",
            benabled: _field && (_cnt > 0),
        });
        _y += 38;
    }
    array_push(_b, { bx: GRIDC_LP_X1 + 8, by: 782, bw: 240, bh: 36, bid: "deployall", blabel: "Deploy All", benabled: _field });

    var _spd = "Normal";
    if (ctrl.speed_mult == 0.5) {
        _spd = "Slow";
    }
    if (ctrl.speed_mult == 2) {
        _spd = "Fast";
    }
    if (ctrl.speed_mult == 4) {
        _spd = "Very Fast";
    }
    var _zl = (ctrl.zoom_mode == 0) ? "Zoom: Battle" : "Zoom: Overview";

    if (_battle && (array_length(ctrl.selected) > 0)) {
        var _stn = ctrl.formations[ctrl.selected[0]].stance;
        var _stl = (_stn == 1) ? "Charge" : ((_stn == 2) ? "Avoid" : "Auto");
        array_push(_b, { bx: 1336, by: 556, bw: 122, bh: 32, bid: "ord_adv", blabel: "Advance", benabled: true });
        array_push(_b, { bx: 1464, by: 556, bw: 120, bh: 32, bid: "ord_hold", blabel: "Hold", benabled: true });
        array_push(_b, { bx: 1336, by: 594, bw: 248, bh: 32, bid: "stance", blabel: $"Melee: {_stl}", benabled: true });
    }
    array_push(_b, { bx: 1336, by: 646, bw: 248, bh: 34, bid: "zoom", blabel: _zl, benabled: true });
    array_push(_b, { bx: 1336, by: 686, bw: 122, bh: 34, bid: "pause", blabel: ctrl.paused ? "Resume" : "Pause", benabled: _battle });
    array_push(_b, { bx: 1464, by: 686, bw: 120, bh: 34, bid: "speed", blabel: _spd, benabled: _battle });
    if (_deploy) {
        array_push(_b, { bx: 1336, by: 726, bw: 248, bh: 40, bid: "start", blabel: "Begin Battle", benabled: grid_any_deployed(ctrl) });
    }
    array_push(_b, { bx: 1336, by: 772, bw: 248, bh: 36, bid: "exit", blabel: (ctrl.exit_arm > 0) ? "Confirm Exit" : "Exit Battle", benabled: true });
    return _b;
}
