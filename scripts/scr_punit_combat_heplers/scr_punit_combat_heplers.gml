function squeeze_map_forces() {
    try {
        var _player_front_row = get_rightmost();
        var _enemy_front = get_leftmost(obj_enunit, false);
        if (_player_front_row != noone && _enemy_front != noone) {
            if (!collision_point(_player_front_row.x + 10, _player_front_row.y, obj_enunit, 0, 1)) {
                var _move_distance = calculate_block_distances(_player_front_row, _enemy_front) - 2;
                with (obj_pnunit) {
                    move_unit_block("east", _move_distance, true);
                }
            }
        }

        var _player_rear = get_leftmost();
        if (_player_rear != noone) {
            var _enemy_flank = get_rightmost(obj_enunit, true, false);
            if (_enemy_flank != noone) {
                if (_enemy_flank.flank) {
                    var _move_distance = calculate_block_distances(_player_rear, _enemy_flank) - 1;
                    with (obj_enunit) {
                        if (flank && _player_rear.x > x) {
                            move_unit_block("east", _move_distance, true);
                        }
                    }
                }
            }
        }
    } catch (_exception) {
        ERROR_HANDLER.handle_exception(_exception);
    }
}

function target_block_is_valid(target, desired_type) {
    try {
        var _is_valid = false;
        if (target == noone) {
            return _is_valid;
        }
        if (instance_exists(target)) {
            if (target.x > -100 && target.object_index == desired_type) {
                if (target.men + target.veh + target.dreads > 0) {
                    _is_valid = true;
                } else {
                    target.x = -5000;
                    instance_deactivate_object(target);
                }
            }
        }
        return _is_valid;
    } catch (_exception) {
        ERROR_HANDLER.handle_exception(_exception);
    }
}

function get_rightmost(block_type = obj_pnunit, include_flanking = true, include_main_force = true) {
    try {
        var rightmost = noone;
        if (instance_exists(block_type)) {
            with (block_type) {
                if (!include_flanking && flank) {
                    continue;
                }
                if (!include_main_force && !flank) {
                    continue;
                }
                if (x < -100) {
                    continue;
                }
                if (block_type == obj_pnunit) {
                    if (men + veh + dreads <= 0) {
                        x = -5000;
                        instance_deactivate_object(id);
                        continue;
                    }
                }
                if (rightmost == noone && x > -100) {
                    // Was block_type.id, which resolves to obj_pnunit.id (the first
                    // instance in the list) rather than the current instance in this
                    // with-loop, so the first valid block reaching here was recorded as
                    // whatever block was created first. When that first-created block
                    // was not the actual edge, get_rightmost returned the wrong block
                    // and the enemy fired on the wrong column even with the formation
                    // in correct order. Bug exists verbatim in upstream main.
                    // Upstream (94ecc3f60) widened the bound from x > 0 to x > -100 so
                    // nearly-off-field blocks stay targetable and the enemy never
                    // disables itself hunting a valid edge.
                    rightmost = id;
                } else {
                    if (x > rightmost.x) {
                        rightmost = id;
                    }
                }
            }
        }
        return rightmost;
    } catch (_exception) {
        ERROR_HANDLER.handle_exception(_exception);
    }
}

function block_has_armour(target) {
    try {
        return target.veh + target.dreads;
    } catch (_exception) {
        ERROR_HANDLER.handle_exception(_exception);
    }
}

function get_leftmost(block_type = obj_pnunit, include_flanking = true) {
    try {
        var left_most = noone;
        if (instance_exists(block_type)) {
            with (block_type) {
                if (!include_flanking && flank) {
                    continue;
                }
                if (x < -100) {
                    continue;
                }
                if (block_type == obj_pnunit) {
                    if (men + veh + dreads <= 0) {
                        x = -5000;
                        instance_deactivate_object(id);
                        continue;
                    }
                }
                if (left_most == noone && x > -100) {
                    // Same bug as get_rightmost above: block_type.id is the first
                    // instance in the list, not the current one, so the first valid
                    // block was recorded as the first-created block. This is why a
                    // flanking force (which targets get_leftmost, the rear column) hit
                    // the wrong line, striking the bulk block created first rather than
                    // the block actually closest to it. Bug exists verbatim in upstream.
                    // Upstream (94ecc3f60) widened the bound from x > 0 to x > -100 so
                    // nearly-off-field blocks stay targetable and the enemy never
                    // disables itself hunting a valid edge.
                    left_most = id;
                } else {
                    if (x < left_most.x && x > -100) {
                        left_most = id;
                    }
                }
            }
        }
        return left_most;
    } catch (_exception) {
        ERROR_HANDLER.handle_exception(_exception);
    }
}

function get_block_distance(block) {
    try {
        return point_distance(x, y, block.x, block.y) / 10;
    } catch (_exception) {
        ERROR_HANDLER.handle_exception(_exception);
    }
}

function calculate_block_distances(first_block, second_block) {
    try {
        if (first_block.x == second_block.x) {
            return 0;
        } else {
            if (first_block.x < second_block.x) {
                var _temp_holder = second_block;
                second_block = first_block;
                first_block = _temp_holder;
            }
        }
        return floor(floor((first_block.x - second_block.x) / 10));
    } catch (_exception) {
        ERROR_HANDLER.handle_exception(_exception);
    }
}

/// @description Check if the current position of the unit block collides with the other.
/// @param {real} position_x X position of the unit block
/// @param {real} position_y Y position of the unit block
/// @return {bool}
function block_position_collision(position_x, position_y) {
    try {
        return collision_point(position_x, position_y, obj_enunit, 0, 1) || collision_point(position_x, position_y, obj_pnunit, 0, 1);
    } catch (_exception) {
        ERROR_HANDLER.handle_exception(_exception);
    }
}

/// @description Attempts to move an unit block and returns whenever the move succeeded or not.
/// @param {string} direction In what direction to move ("east" or "west")
/// @param {real} blocks How far to move (in unit blocks)
/// @desc Human-readable name for a formation type, for combat-log order confirmations.
function formation_display_name(_ftype) {
    switch (_ftype) {
        case "command": return "Command squad";
        case "honor": return "Honor Guard";
        case "librarian": return "Librarians";
        case "techmarine": return "Techmarines";
        case "terminator": return "Terminators";
        case "veteran": return "Veterans";
        case "tactical": return "Tactical Marines";
        case "devastator": return "Devastators";
        case "assault": return "Assault Marines";
        case "scout": return "Scouts";
        case "dreadnought": return "Dreadnoughts";
        case "hire": return "Hirelings";
        case "rhino": return "Rhinos";
        case "predator": return "Predators";
        case "landraider": return "Land Raiders";
        case "landspeeder": return "Land Speeders";
        case "whirlwind": return "Whirlwinds";
        case "deathco": return "Death Company";
    }
    return "formation";
}

/// @desc Battle block for a formation type ("tactical", "rhino", "deathco", ...). Blocks
/// are one per formation type rather than one per column, so two formations sharing a
/// column remain separate, individually orderable segments of that line instead of
/// merging into one blob. Finds the live block for the type, or creates it at the given
/// column (types with no units pre-created at battle start self-destroy; reinforcements
/// and Death Company arrive here). An empty type falls back to a per-column generic
/// block, mirroring the old one-block-per-column behaviour for anything untyped.
function formation_block(_ftype, _col) {
    if (_ftype == "") {
        _ftype = "col" + string(_col);
    }
    var _found = noone;
    with (obj_pnunit) {
        if (formation_type == _ftype) {
            _found = id;
            break;
        }
    }
    if (_found == noone) {
        _found = instance_create(_col * 10, 240, obj_pnunit);
        _found.formation_type = _ftype;
        // Mirror the battle-start alarm the pre-created blocks get from obj_ncombat's
        // Create, so a block created during the same-frame fill still runs its
        // started==0 accounting (player_forces / player_max) in Alarm_3.
        _found.alarm[3] = 1;
    }
    return _found;
}

/// @desc The enemy block this formation's ranged fire is aimed at. Default (0) is the
/// nearest (frontmost) enemy, matching vanilla. A focus-fire order (1..3, set by
/// right-clicking the formation's bar) aims at the Nth distinct enemy line by column
/// instead, falling back to the last line that exists. Melee always swings at the
/// nearest enemy regardless (a focused far line would fail the melee distance gate).
/// @self Asset.GMObject.obj_pnunit
/// @desc Among the enemy formation segments stacked in one column, the one facing this
/// block: the segment whose drawn span sits nearest this block's own drawn centre. Since
/// the formation split, several enemy segments share a column and therefore share the
/// same instance x and y, so instance_nearest could no longer tell them apart and every
/// shot into that column resolved to the same instance: one segment would absorb a whole
/// line's output while the segments above and below it stood untouched. Falls back to
/// instance_nearest before the first draw, when no segment has a drawn span yet.
/// @param {Real} _col_x
/// @param {Real} _my_cy
/// @returns {Id.Instance}
function enemy_segment_facing(_col_x, _my_cy) {
    var _best = noone;
    var _best_d = 1000000;
    with (obj_enunit) {
        if (x != _col_x) {
            continue;
        }
        var _d = abs(((y1 + y2) / 2) - _my_cy);
        if (_d < _best_d) {
            _best_d = _d;
            _best = id;
        }
    }
    if (_best == noone) {
        _best = instance_nearest(_col_x, 240, obj_enunit);
    }
    return _best;
}

function block_fire_target() {
    var _my_cy = (y1 + y2) / 2;
    var _nearest = instance_nearest(0, y, obj_enunit);
    if (instance_exists(_nearest)) {
        // Frontmost enemy COLUMN, then the segment of it facing this block.
        _nearest = enemy_segment_facing(_nearest.x, _my_cy);
    }
    if (fire_target_line <= 0) {
        return _nearest;
    }
    var _cols = [];
    with (obj_enunit) {
        var _known = false;
        for (var _c = 0; _c < array_length(_cols); _c++) {
            if (_cols[_c] == x) {
                _known = true;
                break;
            }
        }
        if (!_known) {
            array_push(_cols, x);
        }
    }
    if (array_length(_cols) == 0) {
        return _nearest;
    }
    array_sort(_cols, true);
    var _idx = min(fire_target_line, array_length(_cols)) - 1;
    return enemy_segment_facing(_cols[_idx], _my_cy);
}

/// @param {bool} allow_collision Are unit blocks allowed to passthrough other unit blocks
/// @param {bool} leapfrog Retained for callers; the move-through behaviours this once
/// enabled (leapfrog teleport, parallel-lane pass) were tried and reverted, so a block
/// blocked by a friendly currently just holds. Movement-through will return with the
/// per-unit-type formation rework.
/// @return {bool}
/// @self Asset.GMObject.obj_pnunit
function move_unit_block(direction, blocks = 1, allow_collision = false, leapfrog = false) {
    try {
        var distance = 10 * blocks;
        var _new_pos = x;
        var _step = 0;

        if (direction == "east") {
            _step = distance;
            _new_pos = x + distance;
        } else if (direction == "west") {
            _step = -distance;
            _new_pos = x - distance;
        }

        if (allow_collision == true || !block_position_collision(_new_pos, y)) {
            x = _new_pos;
            return true;
        }

        // Formation merge (manual orders, player blocks only): a personally ordered
        // formation may enter a column held by friendly blocks. Per-type blocks coexist
        // in the same line as separate, individually orderable segments (drawn stacked),
        // so a formation moves through or joins another line without losing its own
        // order. Never onto a position an enemy holds, so contact still stops movement.
        // The seeded auto-advance keeps vanilla stall behaviour so the body forms a line
        // behind the front instead of piling into the front block's column.
        if (leapfrog && (object_index == obj_pnunit) && (_step != 0)
            && collision_point(_new_pos, y, obj_pnunit, 0, 1) && !collision_point(_new_pos, y, obj_enunit, 0, 1)) {
            x = _new_pos;
            return true;
        }

        return false;
    } catch (_exception) {
        ERROR_HANDLER.handle_exception(_exception);
    }
}

/// @desc True when any of the keywords appears in the unit name.
/// @param {String} _name
/// @param {Array<String>} _keys
/// @returns {Bool}
function enemy_name_has(_name, _keys) {
    for (var i = 0; i < array_length(_keys); i++) {
        if (string_pos(_keys[i], _name) > 0) {
            return true;
        }
    }
    return false;
}

/// @desc The formation category an enemy unit type belongs to, mirroring the player's
/// per-type formations onto the enemy roster. Enemy blocks are spawned as a mixed bag of
/// unit types per column (Boyz + Nobz + a Deff Dread in one blob), which made an enemy
/// line unreadable and impossible to target by role. Classifying by name keyword keeps
/// this race-neutral and additive: an unrecognised unit falls through to "line", so a new
/// unit type never breaks, it just starts in the infantry segment until a keyword is
/// added here. Order matters, most specific first ("Wraithlord" before "Wraith",
/// "Meganob" before "Nob", "World Eater Terminator" before "World Eater").
/// @param {String} _name
/// @returns {String}
function enemy_formation_type(_name) {
    if (_name == "") {
        return "line";
    }
    // Tanks, transports and flyers.
    if (enemy_name_has(_name, ["Battlewagon", "Trukk", "Chimera", "Leman Russ", "Basilisk", "Predator",
        "Rhino", "Land Raider", "Vindicator", "Immolator", "Exorcist", "Devilfish", "Hammerhead",
        "Falcon", "Fire Prism", "Night Spinner", "Wave Serpent", "Monolith", "Doomsday Arc", "Vyper",
        "Goliath", "Ridgerunner", "Technical", "Vendetta", "Heldrake", "Grav Platform"])) {
        return "vehicle";
    }
    // Walkers and monstrous creatures: they never take cover and anchor a line.
    if (enemy_name_has(_name, ["Wraithlord", "Deff Dread", "Killa Kan", "Carnifex", "Helbrute", "Defiler",
        "Maulerfiend", "Soul Grinder", "Penitent Engine", "Dreadnought", "Tomb Stalker", "Canoptek Spyder",
        "Greater Daemon", "Avatar", "Phantom Titan", "Toxicrene", "Trygon"])) {
        return "walker";
    }
    // Super heavy infantry: the terminator tier and its xenos equivalents.
    if (enemy_name_has(_name, ["Terminator", "Obliterator", "Meganob"])) {
        return "terminator";
    }
    // Warlords and characters: the assassination targets an Assault leap goes after.
    if (enemy_name_has(_name, ["Warboss", "Chaos Lord", "Sorcerer", "Farseer", "Autarch", "Warlock",
        "Hive Tyrant", "Overlord", "Commander", "Arch Heretic", "Magus", "Primus", "Palatine", "Canoness",
        "Ethereal", "Leader", "Mistress"])) {
        return "warlord";
    }
    // Fire support: the gunline that holds and shoots.
    if (enemy_name_has(_name, ["Havoc", "Dark Reaper", "Broadside", "Heavy Weapons", "Long Fang",
        "Loota", "Flash Git", "Tank Busta", "Devastator", "Retributor", "Zoanthrope", "Fire Dragon",
        "Destroyer"])) {
        return "heavy";
    }
    // Fast attack and dedicated close combat: these leap the line.
    if (enemy_name_has(_name, ["Raptor", "Stormboy", "Warp Spider", "Swooping Hawk", "Shining Spear",
        "Howling Banshee", "Striking Scorpian", "Striking Scorpion", "Genestealer", "Hormagaunt",
        "Berzerker", "Seraphim", "Repentia", "Arco-Flagellent", "Jackal", "Vespid", "Necron Wraith",
        "Spyrer", "Possessed"])) {
        return "assault";
    }
    // Skirmishers, infiltrators and light screens.
    if (enemy_name_has(_name, ["Gretchin", "Kommando", "Ranger", "Pathfinder", "Stealthsuit", "XV25",
        "Lictor", "Kroot", "Drone", "Scout"])) {
        return "scout";
    }
    // Veterans and heavy infantry.
    if (enemy_name_has(_name, ["Nob", "Ard Boy", "Chosen", "Veteran", "Aberrant", "Tyrant Guard",
        "Tyranid Warrior", "Lychguard", "Immortal", "Wraithguard", "Celestian", "Dominion", "Exarch",
        "Ogryn", "Cultist Elite", "Fallen", "Daemonhost", "Praetorian", "Thallax", "Ogre", "Mek",
        "Priest", "XV8"])) {
        return "elite";
    }
    return "line";
}

/// @desc Human-readable name for an enemy formation category, for the block tooltip and
/// combat-log order lines. Deliberately race-neutral: one label reads correctly whether
/// the segment is Ork Stormboyz or Chaos Raptors.
/// @param {String} _ftype
/// @returns {String}
function enemy_formation_display_name(_ftype) {
    switch (_ftype) {
        case "warlord": return "Warlords";
        case "terminator": return "Elite Heavy Infantry";
        case "elite": return "Elites";
        case "heavy": return "Fire Support";
        case "assault": return "Assault Troops";
        case "scout": return "Skirmishers";
        case "walker": return "Walkers";
        case "vehicle": return "Vehicles";
        case "line": return "Line Infantry";
    }
    return "Enemy formation";
}

/// @desc Split every spawned enemy block into per-category formation segments, the mirror
/// of the player's formation_block routing. Each of the spawn's blocks keeps its COLUMN
/// (the enemy line's width, and what the player's fire-target lines count), but its mixed
/// contents divide into separate blocks in that same column, drawn as stacked segments
/// and individually hoverable and targetable. The largest category keeps the original
/// instance so the line's shape and any spawn-set flags survive; the rest split off.
/// Runs once at the end of the spawn, before any block's Alarm_1: only dudes, dudes_num
/// and dudes_special are set at that point, and each block derives its own weapons,
/// armour, size and force accounting from the entries it ends up holding. Vacated source
/// entries are zeroed and Alarm_1's existing compaction pass closes the gaps; a segment
/// that somehow ends up empty destroys itself there too.
/// @returns {Undefined}
function enemy_formation_split() {
    if (!instance_exists(obj_enunit)) {
        return;
    }
    var _origins = [];
    with (obj_enunit) {
        array_push(_origins, id);
    }
    var _segments = 0;
    for (var _b = 0; _b < array_length(_origins); _b++) {
        var _src = _origins[_b];
        if (!instance_exists(_src)) {
            continue;
        }
        if (_src.formation_type != "") {
            continue; // already split (defensive: the spawn may run more than once)
        }
        // Which categories this block holds, and how many bodies in each.
        var _cats = [];
        var _weights = [];
        with (_src) {
            for (var _j = 1; _j <= 700; _j++) {
                if ((dudes[_j] == "") || (dudes_num[_j] <= 0)) {
                    continue;
                }
                var _cat = enemy_formation_type(dudes[_j]);
                var _at = -1;
                for (var _k = 0; _k < array_length(_cats); _k++) {
                    if (_cats[_k] == _cat) {
                        _at = _k;
                        break;
                    }
                }
                if (_at < 0) {
                    array_push(_cats, _cat);
                    array_push(_weights, dudes_num[_j]);
                } else {
                    _weights[_at] += dudes_num[_j];
                }
            }
        }
        if (array_length(_cats) == 0) {
            continue;
        }
        var _keep = 0;
        for (var _k = 1; _k < array_length(_cats); _k++) {
            if (_weights[_k] > _weights[_keep]) {
                _keep = _k;
            }
        }
        _src.formation_type = _cats[_keep];
        for (var _k = 0; _k < array_length(_cats); _k++) {
            if (_k == _keep) {
                continue;
            }
            var _new = instance_create(_src.x, _src.y, obj_enunit);
            _new.formation_type = _cats[_k];
            _new.owner = _src.owner;
            _new.flank = _src.flank;
            _new.flyer = _src.flyer;
            _new.pos = _src.pos;
            _new.neww = _src.neww;
            if (variable_instance_exists(_src, "column")) {
                _new.column = _src.column;
            }
            var _slot = 1;
            with (_src) {
                for (var _j = 1; _j <= 700; _j++) {
                    if ((dudes[_j] == "") || (dudes_num[_j] <= 0)) {
                        continue;
                    }
                    if (enemy_formation_type(dudes[_j]) != _new.formation_type) {
                        continue;
                    }
                    _new.dudes[_slot] = dudes[_j];
                    _new.dudes_num[_slot] = dudes_num[_j];
                    _new.dudes_special[_slot] = dudes_special[_j];
                    _slot += 1;
                    dudes[_j] = "";
                    dudes_special[_j] = "";
                    dudes_num[_j] = 0;
                }
            }
            _segments += 1;
        }
    }
    LOGGER.info($"ENEMY FORMATIONS: {array_length(_origins)} spawned block(s) split into {array_length(_origins) + _segments} formation segment(s)");
}

/// @desc Size the spawned enemy army to the region's FRONT WIDTH. The spawn tables size an
/// army from the world's strength TIER, which says how much the faction has in the abstract,
/// not how much of it can stand in contact on this particular ground. Terrain decides that,
/// and the width is a target rather than only a ceiling: on a narrow front a huge garrison is
/// trimmed to what fits and the rest is reserve, while on a wide front a modest tier roll is
/// scaled UP toward the width, bounded by the garrison that actually exists there. That is
/// what makes the largest battles both bigger and genuinely variable by where they happen.
/// Scaling the whole roster preserves composition, so the result is the same army at a
/// different size rather than a different army. The chapter is never bound by this: its few
/// hundred bodies would need a width small enough to make every enemy trivial. On a LAST
/// STAND the width is lifted entirely and the defender commits its whole regional garrison.
/// @returns {Undefined}
function enemy_front_width_clamp() {
    if (!instance_exists(obj_enunit) || !instance_exists(obj_ncombat)) {
        return;
    }
    var _star = obj_ncombat.battle_object;
    if (!instance_exists(_star)) {
        return;
    }
    var _planet = obj_ncombat.battle_id;
    var _region = obj_ncombat.battle_region;
    if (!is_real(_region) || (_region < 0) || (_region >= planet_region_count(_star, _planet))) {
        return; // single-region world or no region context: nothing to bound it by
    }
    var _total = 0;
    with (obj_enunit) {
        for (var _j = 1; _j <= 700; _j++) {
            if (dudes_num[_j] > 0) {
                _total += dudes_num[_j];
            }
        }
    }
    if (_total <= 0) {
        return;
    }
    var _terrain = region_terrain(_star, _planet, _region);
    var _width = region_front_width(_star, _planet, _region);
    // Never field more than the garrison that is actually stationed here: the width says how
    // much ground there is to fight over, the garrison says how many bodies exist to fill it.
    var _garrison = region_garrison(_star, _planet, _region, obj_ncombat.enemy);
    if (_garrison <= 0) {
        LOGGER.info($"FRONT WIDTH: region {_region} ({_terrain}) width {_width}, no stored garrison for faction {obj_ncombat.enemy}, spawn left at {_total}");
        return;
    }
    var _target = obj_ncombat.last_stand ? _garrison : min(_width, _garrison);
    _target = min(_target, ENEMY_FRONT_ENGAGED_CAP);
    if (_target <= 0) {
        return;
    }
    var _scale = _target / _total;
    if (_scale > ENEMY_FRONT_SCALE_UP_MAX) {
        _scale = ENEMY_FRONT_SCALE_UP_MAX;
    }
    if ((_scale > 0.98) && (_scale < 1.02)) {
        LOGGER.info($"FRONT WIDTH: region {_region} ({_terrain}) width {_width}, garrison {_garrison}, enemy fielded {_total}, already at the line");
        return;
    }
    var _final = 0;
    with (obj_enunit) {
        for (var _j = 1; _j <= 700; _j++) {
            if (dudes_num[_j] > 0) {
                dudes_num[_j] = max(1, round(dudes_num[_j] * _scale));
                _final += dudes_num[_j];
            }
        }
    }
    var _verb = (_scale < 1) ? "trimmed to the line, the rest holds in reserve" : "reinforced up to fill the line";
    LOGGER.info($"FRONT WIDTH: region {_region} ({_terrain}) width {_width}, garrison {_garrison}, last_stand={obj_ncombat.last_stand}: enemy {_total} {_verb} -> {_final}");
}

/// @desc Melee-doctrine races never form a gunline: an Ork or Tyranid horde brings its
/// heavy weapons forward with everything else. Every other race's fire support holds
/// position and shoots, which is what makes their line worth flanking.
/// @returns {Bool}
function enemy_race_always_charges() {
    if (!instance_exists(obj_ncombat)) {
        return true;
    }
    var _e = obj_ncombat.enemy;
    return (_e == eFACTION.ORK) || (_e == eFACTION.TYRANIDS) || (_e == eFACTION.GENESTEALER);
}

/// @description Attempts to move an enemy unit block, choosing direction based on whenever they are flanking or not, only if `obj_nfort` doesn't exists.
/// @self Asset.GMObject.obj_enunit
function move_enemy_block() {
    if (instance_exists(obj_nfort)) {
        exit;
    }

    // Enemy formation doctrine, the mirror of the player's orders without an order UI:
    // each segment behaves the way its type should, decided per turn rather than driven
    // by an AI planner.
    // Fire support holds the gunline and shoots (melee-doctrine races excepted).
    if ((formation_type == "heavy") && !enemy_race_always_charges() && instance_exists(obj_pnunit)) {
        exit;
    }
    // Assault troops leap the last stretch into the player's front line, once per battle,
    // mirroring the player's Assault jump. Flanking blocks approach from the far side and
    // are left to their existing behaviour.
    if ((formation_type == "assault") && !assault_jumped && !flank && instance_exists(obj_pnunit)) {
        var _front_x = -100000;
        with (obj_pnunit) {
            if ((x > _front_x) && visible) {
                _front_x = x;
            }
        }
        var _gap = x - _front_x;
        if ((_gap > 10) && (_gap <= ASSAULT_JUMP_RANGE)) {
            x = _front_x + 10;
            assault_jumped = true;
            obj_ncombat.combat_log.push($"The enemy {enemy_formation_display_name(formation_type)} hurl themselves at your line!", eMSG_COLOR.BRIGHT_RED);
            exit;
        }
    }

    var _direction = flank ? "east" : "west";
    move_unit_block(_direction);
}

/// @description Creates a priority queue of enemy units based on their x-position and then moves each with `move_enemy_block()`.
function move_enemy_blocks() {
    var _enemy_movement_queue = ds_priority_create();
    with (obj_enunit) {
        ds_priority_add(_enemy_movement_queue, id, x);
    }
    while (!ds_priority_empty(_enemy_movement_queue)) {
        var _enemy_block = ds_priority_delete_min(_enemy_movement_queue);
        with (_enemy_block) {
            move_enemy_block();
        }
    }
    ds_priority_destroy(_enemy_movement_queue);
}

/// @self Asset.GMObject.obj_pnunit
/// @desc One player block's advance-to-contact step. Seeds this block's order on its
/// first tick (raids/attacks advance, defense/static hold), advances one column east if
/// ordered to (a personally ordered block leapfrogs; the auto-advancing body stops once
/// the formation has met the enemy line), then latches formation contact so blocks
/// processed later in the same front-first sweep hold instead of surging into gaps.
/// Extracted from obj_pnunit Alarm_0 so movement can run in a single ordered pass.
function move_player_block() {
    if (move_order == "") {
        move_order = (obj_ncombat.dropping || (!obj_ncombat.defending && obj_ncombat.formation_set != 2)) ? "advance" : "hold";
    }
    // Rear-guard delay: while this is the last fighting formation, it accrues hold
    // time; after RETREAT_REARGUARD_HOLD passes it may withdraw too.
    if ((move_order != "retreat") && (veh_type[1] != "Defenses") && instance_exists(obj_enunit)) {
        if (player_fighting_blocks_count() <= 1) {
            rearguard_ticks += 1;
            if (rearguard_ticks == RETREAT_REARGUARD_HOLD) {
                obj_ncombat.combat_log.push($"The {formation_display_name(formation_type)} have bought enough time; they may withdraw!", eMSG_COLOR.WHITE);
            }
        }
    }
    if ((move_order == "retreat") && (veh_type[1] != "Defenses")) {
        // Retreat: withdraw one column west per turn, merging back through friendly
        // lines (never onto an enemy), unable to fire and heavily protected (see
        // RETREAT_DAMAGE_MULT), until the formation leaves the field edge.
        if (x > 10) {
            if (move_unit_block("west", 1, false, true)) {
                moved_this_sweep = true;
            }
        } else if (!retreat_departed) {
            retreat_departed = true;
            obj_ncombat.combat_log.push($"The {formation_display_name(formation_type)} have withdrawn from the field.", eMSG_COLOR.WHITE);
            // Actually leave play: park past the -100 targeting bound, invisible and
            // out of melee reach. The instance stays alive so live-applied casualties
            // and the survivor return keep working; player_all_departed() below ends
            // the battle once no fighting blocks remain.
            x = RETREAT_ESCAPED_X;
            visible = false;
            engaged = 0;
        }
    }
    if ((move_order == "advance") && (veh_type[1] != "Defenses")) {
        // Assault jump: a personally ordered Assault formation within leaping range of
        // the enemy front vaults straight to contact (once per battle) instead of
        // closing a column at a time. Lands just short of the frontmost enemy, never on
        // one; friendly blocks there coexist per the formation-merge rule.
        if ((formation_type == "assault") && (fire_target_line == 1) && !assault_jumped && instance_exists(obj_enunit)) {
            var _front_x = 100000;
            with (obj_enunit) {
                if (x < _front_x) {
                    _front_x = x;
                }
            }
            if (((_front_x - x) > 10) && ((_front_x - x) <= ASSAULT_JUMP_RANGE)) {
                x = _front_x - 10;
                assault_jumped = true;
                moved_this_sweep = true;
                obj_ncombat.combat_log.push($"The {formation_display_name(formation_type)} leap into the fray!", eMSG_COLOR.AQUA);
            }
        }
        if (order_manual) {
            if (move_unit_block("east", 1, false, true)) {
                moved_this_sweep = true;
            }
        } else {
            // Advance-to-contact in two regimes sharing one movement body. BEFORE the
            // line meets the enemy (latch clear), every block advances. AFTER the latch,
            // blocks may still CLOSE UP into empty columns strictly behind the frontmost
            // player block, never while engaged, packing the formation into ranks. The
            // latch used to stop ALL auto-advance the instant the first block touched
            // the line, and since it trips MID-SWEEP, the turn the front block reached
            // the enemy every block processed after it froze on the spot: the squeeze
            // parks the line two columns out, the front block closes to one on the first
            // sweep, trips the latch, and the rest of that sweep and every later one is
            // frozen ("only the Predator advances"). Surging is still impossible under
            // the new rule: nothing may enter or pass the front column, so gaps opened
            // by dying enemies stay unentered.
            var _latched = obj_ncombat.player_front_contact;
            var _front_x = x;
            with (obj_pnunit) {
                if (x > _front_x) {
                    _front_x = x;
                }
            }
            var _dest_x = x + 10;
            var _may_step = (!_latched) || ((_dest_x < _front_x) && (!engaged));
            if (_may_step) {
                if (move_unit_block("east", 1, false, false)) {
                    moved_this_sweep = true;
                } else if (collision_point(_dest_x, y, obj_enunit, 0, 1) == noone) {
                    // Lockstep for stacked segments: merge into the destination column
                    // only when NO enemy holds it and EVERY friendly standing there moved
                    // during this same sweep, so a stack follows its leader in the same
                    // turn while a HOLDING block still dams everything behind it.
                    var _any_friendly = false;
                    var _all_moved = true;
                    with (obj_pnunit) {
                        if (id == other.id) {
                            continue;
                        }
                        if ((_dest_x >= bbox_left) && (_dest_x <= bbox_right) && (other.y >= bbox_top) && (other.y <= bbox_bottom)) {
                            _any_friendly = true;
                            if (!moved_this_sweep) {
                                _all_moved = false;
                                break;
                            }
                        }
                    }
                    if (_any_friendly && _all_moved) {
                        x = _dest_x;
                        moved_this_sweep = true;
                    }
                }
            }
        }
    }
    if (collision_point(x + 14, y, obj_enunit, 0, 1)) {
        obj_ncombat.player_front_contact = true;
    }
}

/// @self Asset.GMObject.obj_controller
/// @desc Advance the whole player line front-first, mirroring move_enemy_blocks. Player
/// front is the high-x (east) side, so the queue is drained highest-x first: the frontmost
/// block advances and clears its column before the block behind it tries to move, so a rear
/// block (a Rhino sitting behind the infantry) no longer stalls against a slot the front
/// block has not vacated yet and drift out of the line. Replaces the old arbitrary
/// instance-order per-block advance in obj_pnunit Alarm_0.
function move_player_blocks() {
    // Fresh sweep: nobody has moved yet. The lockstep merge in move_player_block only
    // follows blocks that genuinely stepped during THIS sweep.
    with (obj_pnunit) {
        moved_this_sweep = false;
    }
    var _latch_before = instance_exists(obj_ncombat) ? obj_ncombat.player_front_contact : false;
    var _player_movement_queue = ds_priority_create();
    with (obj_pnunit) {
        ds_priority_add(_player_movement_queue, id, x);
    }
    while (!ds_priority_empty(_player_movement_queue)) {
        var _player_block = ds_priority_delete_max(_player_movement_queue);
        if (instance_exists(_player_block)) {
            with (_player_block) {
                move_player_block();
            }
        }
    }
    ds_priority_destroy(_player_movement_queue);
    // Sweep summary for tester logs: who stepped, whether the front-contact latch
    // changed, and which ADVANCE blocks stood still (hold, retreat and defenses are
    // intended to stand and are not listed).
    var _stepped = 0;
    var _stood = [];
    with (obj_pnunit) {
        if (moved_this_sweep) {
            _stepped += 1;
        } else if ((move_order == "advance") && (veh_type[1] != "Defenses") && (!order_manual)) {
            array_push(_stood, formation_display_name(formation_type));
        }
    }
    var _standing_str = "none";
    for (var _si = 0; _si < array_length(_stood); _si++) {
        _standing_str = (_si == 0) ? _stood[_si] : (_standing_str + ", " + _stood[_si]);
    }
    if (instance_exists(obj_ncombat)) {
        LOGGER.info($"MOVE SWEEP turn {obj_ncombat.turn_count}: {_stepped} block(s) stepped, latch {_latch_before} -> {obj_ncombat.player_front_contact}, standing: {_standing_str}");
    }
}

/// @self Asset.GMObject.obj_enunit|Asset.GMObject.obj_pnunit
function block_composition_string() {
    var _composition_string = $"{unit_count}x Total; ";
    if (men > 0) {
        _composition_string += $"{string_plural_count("Normal Unit", men)}; ";
    }
    if (medi > 0) {
        _composition_string += $"{string_plural_count("Big Unit", medi)}; ";
    }
    if (dreads > 0) {
        _composition_string += $"{string_plural_count("Walker", dreads)}; ";
    }
    if (veh > 0) {
        _composition_string += $"{string_plural_count("Vehicle", veh)}; ";
    }
    _composition_string += $"\n";

    _composition_string += arrays_to_string_with_counts(dudes, dudes_num, true, false);

    return _composition_string;
}

function draw_block_composition(_x1, _composition_string) {
    draw_set_alpha(1);
    draw_set_color(CM_GREEN_COLOR);
    draw_line_width(_x1 + 5, 450, 817, 685, 2);
    draw_set_font(fnt_40k_14b);
    draw_text(817, 688, "Row Composition:");
    draw_set_font(fnt_40k_14);
    draw_text_ext(817, 710, _composition_string, -1, 758);
}

function draw_block_fadein() {
    if (obj_ncombat.fadein > 0) {
        draw_set_color(c_black);
        draw_set_alpha(obj_ncombat.fadein / 30);
        draw_rectangle(822, 239, 1574, 662, 0);
        draw_set_alpha(1);
    }
}

/// @self Asset.GMObject.obj_enunit|Asset.GMObject.obj_pnunit
function update_block_size() {
    column_size = men + (medi * 3) + (dreads * 6) + (veh * 8);
}

/// @self Asset.GMObject.obj_enunit|Asset.GMObject.obj_pnunit
function update_block_unit_count() {
    unit_count = men + medi + dreads + veh;
}

/// Fighting player formations: on the field, not retreating, not the Defenses
/// pseudo-block. The retreat rules key off this count (rear-guard rule).
function player_fighting_blocks_count() {
    var _n = 0;
    with (obj_pnunit) {
        if ((veh_type[1] == "Defenses") || retreat_departed || (move_order == "retreat")) {
            continue;
        }
        _n += 1;
    }
    return _n;
}

/// True when player blocks remain but every one of them has withdrawn off-field:
/// the fighting withdrawal is complete and the battle should resolve as the field
/// being ceded (survivors keep their live-applied casualties and return home).
function player_all_departed() {
    if (!instance_exists(obj_pnunit)) {
        return false;
    }
    var _fighting = false;
    with (obj_pnunit) {
        if (!retreat_departed) {
            _fighting = true;
            break;
        }
    }
    return !_fighting;
}

/// @description Returns a human-readable label for a unit block instance.
/// @param {Id.Instance.obj_pnunit|Id.Instance.obj_enunit} _inst
/// @returns {String}
function resolve_block_label(_inst) {
    if (!instance_exists(_inst)) {
        return string(_inst);
    }

    var _object_index = _inst.object_index;

    if (_object_index == obj_nfort) {
        return "Fort";
    }

    if (_object_index != obj_pnunit && _object_index != obj_enunit) {
        return $"inst({_inst.id})";
    }

    var _desc = arrays_to_string_with_counts(_inst.dudes, _inst.dudes_num, true, false);
    // Name the enemy segment in debug lines so a tester log reads by formation instead of
    // by roster string alone (several segments now share one column).
    if ((_object_index == obj_enunit) && (_inst.formation_type != "")) {
        return $"[{enemy_formation_display_name(_inst.formation_type)}] <{_desc}>";
    }
    return $"<{_desc}>";
};
