/// @description This alarm is responsible for the enemy target column selection

if (!instance_exists(obj_pnunit)) {
    exit;
}

enemy = flank ? get_leftmost() : get_rightmost();
if (enemy == noone) {
    exit;
}

//In melee check
engaged = collision_point(x - 10, y, obj_pnunit, 0, 1) || collision_point(x + 10, y, obj_pnunit, 0, 1);

if (!engaged) {
    // Shooting
    for (var i = 0; i < array_length(wep); i++) {
        if (wep[i] == "" || wep_num[i] == 0) {
            continue;
        }

        if ((range[i] == 1) || (ammo[i] == 0)) {
            continue;
        }

        if (range[i] == 0) {
            LOGGER.error($"{wep[i]} has broken range! This shouldn't happen! Range: {range[i]}; Ammo: {ammo[i]}; Owner: {wep_owner[i]}");
            continue;
        }

        if (!target_block_is_valid(enemy, obj_pnunit)) {
            enemy = flank == 0 ? get_rightmost() : get_leftmost();
            if (!target_block_is_valid(enemy, obj_pnunit)) {
                exit;
            }
        }

        var dist = 0;

        if (instance_exists(obj_nfort) && !flank) {
            enemy = instance_nearest(x, y, obj_nfort);
            dist = 2;
        } else {
            dist = get_block_distance(enemy);
        }

        var target_unit_index = 0;

        if (range[i] >= dist) {
            // The weapon is in range;
            // A weapon's armour pierce doubles as its role. Dedicated anti-tank guns
            // (apa >= GUARD_ENEMY_ANTITANK_AP, the rokkit / lascannon / melta class) hunt
            // vehicles. Everything lighter (general-purpose and pure anti-infantry) goes
            // for the men first. This is preference by weapon role, not per-shot penetration
            // knowledge: the enemy never checks whether a given shot would crack a specific
            // target, it just sends tank-hunters at tanks and lighter guns at infantry.
            // Either type still crosses over as a fallback through the paths below: an
            // anti-tank gun with no vehicle in reach drops to the men path, and a lighter
            // gun with no men in reach drops to the vehicle fallback inside the men path.
            var _target_vehicles = apa[i] >= GUARD_ENEMY_ANTITANK_AP; // role-based target preference

            // Weird alpha strike mechanic, that changes target unit index to CM;
            if (((wep[i] == "Power Fist") || (wep[i] == "Bolter")) && (obj_ncombat.alpha_strike > 0) && (wep_num[i] > 5)) {
                obj_ncombat.alpha_strike -= 0.5;

                var cm_present = false;
                var cm_index = -1;
                var cm_block = false;
                with (obj_pnunit) {
                    for (var u = 0; u < array_length(unit_struct); u++) {
                        if (marine_type[u] == obj_ini.role[100][eROLE.CHAPTERMASTER]) {
                            cm_present = true;
                            cm_index = u;
                            cm_block = id;
                        }
                    }
                }
                if (cm_present) {
                    enemy = cm_block;
                    target_unit_index = cm_index;
                }
            }

            // AP weapons attacking vehicles and forts;
            var _no_vehicles_present = false;
            if (_target_vehicles) {
                var _shot = false;
                if ((!instance_exists(obj_nfort)) || flank) {
                    if (block_has_armour(enemy) || (enemy.veh_type[1] == "Defenses")) {
                        scr_shoot(i, enemy, target_unit_index, "arp", "ranged");
                        continue;
                    } else {
                        // Front block has no armour. If there are other blocks behind,
                        // look for a vehicle to hit. If none is found anywhere (including
                        // a single men-only block, such as a lone Guard rank), fall back
                        // to shooting the men instead of idling. The original code gated
                        // this whole fallback behind a multi-block check, so a lone
                        // men-only block left every AP weapon firing zero shots.
                        if ((instance_number(obj_pnunit) > 1) && (obj_ncombat.enemy != eFACTION.ORK)) {
                            var _column_size_value = enemy.column_size;
                            var x2 = enemy.x;
                            repeat (instance_number(obj_pnunit) - 1) {
                                x2 += flank == 0 ? -10 : 10;
                                var enemy2 = instance_nearest(x2, y, obj_pnunit);
                                if (!target_block_is_valid(enemy2, obj_pnunit)) {
                                    continue;
                                }
                                if (range[i] < get_block_distance(enemy2)) {
                                    break;
                                }
                                if (block_has_armour(enemy2)) {
                                    // Screening: a large front block (such as a wall of
                                    // Guardsmen) shields the vehicles behind it from AP
                                    // fire, the same way the men-targeting path below
                                    // shields the men behind it. Without this every apa>0
                                    // weapon looks straight past the men-only Guard rank
                                    // to the Marines' vehicles, so the Guard screen
                                    // nothing. When the back block is shielded the shot
                                    // is not taken here; _shot stays false and the weapon
                                    // falls back to firing on the front Guard block.
                                    var _back_column_size_value = enemy2.column_size;
                                    if (_back_column_size_value < _column_size_value) {
                                        continue;
                                    } else {
                                        var _pass_chance = ((_back_column_size_value / _column_size_value) - 1) * 100;
                                        if (irandom_range(1, 100) < min(_pass_chance, 80)) {
                                            continue;
                                        }
                                    }
                                    scr_shoot(i, enemy2, target_unit_index, "arp", "ranged");
                                    _shot = true;
                                    break;
                                }
                            }
                        }
                        if (!_shot) {
                            _no_vehicles_present = true;
                            _target_vehicles = false;
                        }
                    }
                } else {
                    enemy = instance_nearest(x, y, obj_nfort);
                    scr_shoot(i, enemy, 1, "arp", "wall");
                    continue;
                }
            }

            // Non-AP weapons attacking normal units;
            if ((!_target_vehicles) && ((!instance_exists(obj_nfort)) || flank)) {
                var _shot = false;
                if (enemy.men > 0) {
                    // There are marines in the first column;
                    scr_shoot(i, enemy, target_unit_index, "att", "ranged");
                    continue;
                } else if (instance_number(obj_pnunit) > 1) {
                    // There were no marines in the first column, looking behind;
                    // Column piercing. This branch only runs when the front block has zero
                    // men, i.e. a tank wall (or similar armour-only block) is screening the
                    // infantry. The old code rolled a per-block "screening" chance that,
                    // behind a small vehicle block, pinned at its 80% cap and skipped the
                    // infantry, so ~4 of 5 anti-infantry volleys fell through to the vehicle
                    // fallback and plinked the armour. One tank became a bullet sponge for a
                    // thousand men behind it. Instead the volley now pierces by depth: the
                    // first men-bearing block behind the wall is hit by ENEMY_PIERCE_RANK2_SHOTS
                    // of the stack's shots, the second by ENEMY_PIERCE_RANK3_SHOTS, deeper
                    // blocks by nothing, and the front armour takes the shots that failed to
                    // pass. Men-behind-men screening is unaffected: a front block with men in
                    // it still absorbs the whole volley above.
                    // Finding the ranks: the old probe walked x2 in 10px steps with
                    // instance_nearest, and inherited vanilla's direction bug: the men
                    // look-behind stepped +10 for the main force (toward the enemy),
                    // opposite to the -10 the vehicle look-behinds correctly use, so it
                    // only ever resolved the front block itself and never reached the
                    // ranks behind. Blocks behind the front are instead collected
                    // directly (main force fronts are the rightmost block, so behind is
                    // lower x; flank fronts are leftmost, behind is higher x), sorted
                    // nearest-behind first, and the first two men-bearing blocks in
                    // weapon range become rank 2 and rank 3.
                    var _front_x = enemy.x;
                    var _behind = [];
                    with (obj_pnunit) {
                        if (id == other.enemy) {
                            continue;
                        }
                        if (x <= 0) {
                            continue;
                        }
                        var _is_behind = other.flank ? (x > _front_x) : (x < _front_x);
                        if (_is_behind) {
                            array_push(_behind, id);
                        }
                    }
                    if (flank) {
                        array_sort(_behind, function(_a, _b) {
                            return _a.x - _b.x;
                        });
                    } else {
                        array_sort(_behind, function(_a, _b) {
                            return _b.x - _a.x;
                        });
                    }
                    var _rank_blocks = [];
                    var _wall_blocks = [];
                    if (block_has_armour(enemy) || (enemy.veh_type[1] == "Defenses")) {
                        array_push(_wall_blocks, enemy);
                    }
                    for (var b = 0; b < array_length(_behind); b++) {
                        var enemy2 = _behind[b];
                        if (!target_block_is_valid(enemy2, obj_pnunit)) {
                            continue;
                        }
                        if (range[i] < get_block_distance(enemy2)) {
                            break;
                        }
                        if (enemy2.men > 0) {
                            array_push(_rank_blocks, enemy2);
                            if (array_length(_rank_blocks) >= 2) {
                                break;
                            }
                        } else if ((array_length(_rank_blocks) == 0) && block_has_armour(enemy2)) {
                            // A men-less armour line between the shooter and the first
                            // infantry rank (Chimeras/Rhinos behind the Leman Russ line)
                            // is part of the wall: it soaks a share of the stopped shots
                            // instead of the front block eating them all.
                            array_push(_wall_blocks, enemy2);
                        }
                    }
                    if (array_length(_rank_blocks) > 0) {
                        var _total_shots = wep_num[i];
                        var _rank2_shots = floor(_total_shots * ENEMY_PIERCE_RANK2_SHOTS);
                        var _rank3_shots = floor(_total_shots * ENEMY_PIERCE_RANK3_SHOTS);
                        var _front_shots = _total_shots - _rank2_shots;
                        var _ammo_spent = false;
                        if (_rank2_shots > 0) {
                            scr_shoot(i, _rank_blocks[0], target_unit_index, "att", "ranged", _rank2_shots, !_ammo_spent);
                            _ammo_spent = true;
                            _shot = true;
                        }
                        if ((array_length(_rank_blocks) > 1) && (_rank3_shots > 0)) {
                            scr_shoot(i, _rank_blocks[1], target_unit_index, "att", "ranged", _rank3_shots, !_ammo_spent);
                            _ammo_spent = true;
                            _shot = true;
                        }
                        // The shots stopped by the wall still land on the wall, split
                        // across every armour line in front of the infantry (Leman Russ
                        // line, then Chimeras/Rhinos), so armour keeps taking chip fire
                        // and no single front block eats the whole remainder.
                        var _wall_count = array_length(_wall_blocks);
                        if ((_front_shots > 0) && (_wall_count > 0)) {
                            var _per_wall = floor(_front_shots / _wall_count);
                            var _extra = _front_shots - (_per_wall * _wall_count);
                            for (var w = 0; w < _wall_count; w++) {
                                var _w_shots = _per_wall + ((w == 0) ? _extra : 0);
                                if (_w_shots <= 0) {
                                    continue;
                                }
                                scr_shoot(i, _wall_blocks[w], target_unit_index, "att", "ranged", _w_shots, !_ammo_spent);
                                _ammo_spent = true;
                                _shot = true;
                            }
                        }
                        if (_shot) {
                            continue;
                        }
                    }
                }

                // We failed to find normal units to attack, attacking vehicles with a non-AP weapon;
                //TODO: All of these code blocks should be functions instead;
                if (!_shot && !_no_vehicles_present) {
                    if ((!instance_exists(obj_nfort)) || flank) {
                        if (block_has_armour(enemy) || (enemy.veh_type[1] == "Defenses")) {
                            scr_shoot(i, enemy, target_unit_index, "att", "ranged");
                            continue;
                        } else if ((instance_number(obj_pnunit) > 1) && (obj_ncombat.enemy != eFACTION.ORK)) {
                            var x2 = enemy.x;
                            repeat (instance_number(obj_pnunit) - 1) {
                                x2 += flank == 0 ? -10 : 10;
                                var enemy2 = instance_nearest(x2, y, obj_pnunit);
                                if (!target_block_is_valid(enemy2, obj_pnunit)) {
                                    continue;
                                }
                                if (range[i] < get_block_distance(enemy2)) {
                                    break;
                                }
                                if (block_has_armour(enemy2)) {
                                    scr_shoot(i, enemy2, target_unit_index, "att", "ranged");
                                    break;
                                }
                            }
                        }
                    } else {
                        enemy = instance_nearest(x, y, obj_nfort);
                        scr_shoot(i, enemy, 1, "att", "wall");
                        continue;
                    }
                }
            }
        } else {
            continue;
        }
        LOGGER.error($"{wep[i]} didn't find a valid target! This shouldn't happen!");
    }
} else if ((engaged || enemy.engaged) && target_block_is_valid(enemy, obj_pnunit)) {
    //TODO: The melee code was not refactored;
    // Melee
    engaged = 1;
    for (var i = 0; i < array_length(wep); i++) {
        if (wep[i] == "" || wep_num[i] == 0) {
            continue;
        }
        var _armour_piercing = false;
        if (!flank) {
            enemy = get_rightmost();
            if (enemy == noone) {
                exit;
            }
        } else if (flank) {
            enemy = get_leftmost();
            if (enemy == noone) {
                exit;
            }
        }

        if ((range[i] <= 2) || (floor(range[i]) != range[i])) {
            // Weapon meets preliminary checks
            if (apa[i] > 0) {
                _armour_piercing = true;
            } // Determines if it is _armour_piercing or not
            if (_armour_piercing && instance_exists(obj_nfort) && (!flank)) {
                // Huff and puff and blow the wall down
                enemy = instance_nearest(x, y, obj_nfort);
                scr_shoot(i, enemy, 1, "arp", "wall");
                continue;
            }
            if (_armour_piercing) {
                // Check for vehicles
                var good = false;

                if (block_has_armour(enemy)) {
                    scr_shoot(i, enemy, 1, "arp", "melee");
                    good = true;
                }
                if (!good) {
                    _armour_piercing = false;
                } // Fuck it, shoot at infantry
            }

            if ((!_armour_piercing) && target_block_is_valid(enemy, obj_pnunit)) {
                // Check for men
                if (enemy.men) {
                    scr_shoot(i, enemy, 1, "att", "melee");
                } else if (block_has_armour(enemy)) {
                    scr_shoot(i, enemy, 1, "arp", "melee"); // Swing anyways, maybe they'll get lucky
                }
            }
        }
    }
}

instance_activate_object(obj_pnunit);

//TODO: Everything bellow has to be scrapped and reworked;
//! Commented out stuff bellow, until I understand why it exists;
/*if (image_index == -500) {
    var leftest, charge = 0,
        enemy2 = 0;

    with(obj_pnunit) {
        if (x < -4000) {
            instance_deactivate_object(id);
        }
    }

    if (flank == 0) {
        move_unit_block("west");
        // instance_activate_object(obj_cursor);
    }
    if (flank == 1) {
        enemy = instance_nearest(x, y, obj_pnunit); // Right most enemy
        enemy2 = enemy;
        // if (collision_point(x+10,y,obj_pnunit,0,1)) then engaged=1;
        // if (!collision_point(x+10,y,obj_pnunit,0,1)) then engaged=0;
        move_unit_block();

        if (!position_empty(x + 10, y)) {
            engaged = 1;
        } // Quick smash
        // instance_activate_object(obj_cursor);
    }

if (!collision_point(x+10,y,obj_pnunit,0,1)) and (!collision_point(x-10,y,obj_pnunit,0,1)) then engaged=0;
if (collision_point(x+10,y,obj_pnunit,0,1)) or (collision_point(x-10,y,obj_pnunit,0,1)) then engaged=1;



var range_shooti;

    i=0;
    
    
    repeat(30){i+=1;


    
    dist=floor(point_distance(enemy2.x,enemy2.y,x,y)/10);
    
    
    
    
    
    range_shoot="";
    
    if (wep[i]!="") and (range[i]>=dist) and (ammo[i]!=0){
        if (range[i]!=1) and (engaged=0) then range_shoot="ranged";
        if ((range[i]!=floor(range[i])) or (range[i]=1)) and (engaged=1) then range_shoot="melee";
    }
    
    
    
    
    
    
    
    if (wep[i]!="") and (range_shoot="ranged") and (range[i]>=dist){// Weapon meets preliminary checks
        var _armour_piercing;_armour_piercing=0;if (apa[i]>att[i]) then _armour_piercing=1;// Determines if it is _armour_piercing or not
        
        // if (wep[i]="Missile Launcher") then _armour_piercing=1;
        
        if (string_count("Gauss",wep[i])>0) then _armour_piercing=1;
        
        if (wep[i]="Missile Launcher") or (wep[i]="Rokkit Launcha") or (wep[i]="Kannon") then _armour_piercing=1;
        if (wep[i]="Big Shoota") then _armour_piercing=0;if (wep[i]="Devourer") then _armour_piercing=0;
        if (wep[i]="Gauss Particle Cannon") or (wep[i]="Overcharged Gauss Cannon") or (wep[i]="Particle Whip") then _armour_piercing=1;
        
        
        if (instance_exists(enemy2)){
            if (enemy2.veh+enemy2.dreads>0) and (enemy2.men=0) and (apa[i]>10) then _armour_piercing=1;
            
            if (_armour_piercing=1) and (once_only=0){// Check for vehicles
                var g,good;g=0;good=0;
                
                if (enemy.veh>0){
                    // good=scr_target(enemy,"veh");// First target has vehicles, blow it to hell
                    scr_shoot(i,enemy2,good,"arp","ranged");
                }
                if (good=0) and (instance_number(obj_pnunit)>1){// First target does not have vehicles, cycle through objects to find one that has vehicles
                    var x2;x2=enemy2.x;
                    repeat(instance_number(obj_enunit)-1){
                        if (good=0){
                            x2+=10;enemy2=instance_nearest(x2,y,obj_pnunit);
                            if (enemy2.veh+enemy2.dreads>0) and (good=0){
                                good=scr_target(enemy2,"veh");// This target has vehicles, blow it to hell
                                scr_shoot(i,enemy2,good,"arp","ranged");once_only=1;
                            }
                        }
                    }
                }
                if (good=0) then _armour_piercing=0;// Fuck it, shoot at infantry
            }
        }

    }



}

    instance_activate_object(obj_pnunit);
} */
