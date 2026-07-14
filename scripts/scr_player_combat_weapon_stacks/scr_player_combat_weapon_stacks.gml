/// @self Asset.GMObject.obj_pnunit
function add_second_profiles_to_stack(weapon, head_role = false, unit = "none") {
    if (array_length(weapon.second_profiles) > 0) {
        //for adding in intergrated weaponry
        var _secondary_profile;
        for (var p = 0; p < array_length(weapon.second_profiles); p++) {
            if (is_string(weapon.second_profiles[p])) {
                _secondary_profile = gear_weapon_data("weapon", weapon.second_profiles[p], "all");
            } else {
                _secondary_profile = weapon.second_profiles[p];
            }
            if (!is_struct(_secondary_profile)) {
                continue;
            }
            var wep_index = find_stack_index(_secondary_profile.name, head_role, unit);
            if (wep_index > -1) {
                add_data_to_stack(wep_index, _secondary_profile);
            }
        }
    }
}

/// @self Asset.GMObject.obj_pnunit
function add_data_to_stack(stack_index, weapon, unit_damage = false, head_role = false, unit = "none") {
    if (unit_damage) {
        att[stack_index] += unit_damage;
    } else {
        att[stack_index] += weapon.attack;
    }
    apa[stack_index] = weapon.arp;
    range[stack_index] = weapon.range;
    wep_num[stack_index]++;
    splash[stack_index] = weapon.spli;
    wep[stack_index] = weapon.name;

    if (obj_ncombat.started == 0) {
        ammo[stack_index] = weapon.ammo;

        if (is_struct(unit)) {
            var _armour = unit.get_armour_data();
            if (is_struct(_armour) && _armour.has_tag("dreadnought")) {
                ammo[stack_index] = weapon.ammo * 3;
            }

            var _mobi = unit.get_mobility_data();
            if (is_struct(_mobi) && _mobi.has_tag("bonus_ammo")) {
                ammo[stack_index] = weapon.ammo * 2;
            }
        } else if (unit == "vehicle") {
            ammo[stack_index] = weapon.ammo * 4;
        }
    }

    if (unit != "none") {
        //this stops a potential infinite loop of secondary profiles
        add_second_profiles_to_stack(weapon, head_role, unit);
    }
}

/// @self Asset.GMObject.obj_pnunit
/// Adds a single named weapon to the stacks, firing "count" times. Used for Guard
/// Squads, where one unit struct stands for a whole squad: the default weapon (wep1)
/// fires once per man and the special weapon (wep2) fires once for the squad. Mirrors
/// the enemy horde firepower in scr_en_weapon (attack times the number firing) rather
/// than the normal single-primary-weapon path, which would only fire the higher-attack gun.
function add_squad_weapon(weapon_name, count, head_role = false, unit = "none") {
    if (weapon_name == "") {
        return;
    }
    var _w = gear_weapon_data("weapon", weapon_name, "all", false, "standard");
    if (!is_struct(_w) || _w.name == "") {
        return;
    }
    var _idx = find_stack_index(_w.name, head_role, unit);
    if (_idx < 0) {
        return;
    }
    att[_idx] += _w.attack * count;
    apa[_idx] = _w.arp;
    range[_idx] = _w.range;
    wep_num[_idx] += count;
    splash[_idx] = _w.spli;
    wep[_idx] = _w.name;
    if (obj_ncombat.started == 0) {
        ammo[_idx] = _w.ammo;
    }
    wep_owner[_idx] = "assorted";
}

/// @self Asset.GMObject.obj_pnunit
function find_stack_index(weapon_name, head_role = false, unit = "none") {
    final_index = -1;
    var allow = false;
    for (var stack_index = 1; stack_index < array_length(wep); stack_index++) {
        allow = false;
        if (is_struct(unit)) {
            allow = (head_role && (wep_title[stack_index] == unit.role())) && (wep[stack_index] == weapon_name);
        }
        if (!allow) {
            allow = (wep[stack_index] == "" || (wep[stack_index] == weapon_name && !head_role)) && wep_title[stack_index] == "";
        }

        if (allow) {
            final_index = stack_index;
            break;
        }
    }
    return final_index;
}

/// @self Asset.GMObject.obj_pnunit
/// Like find_stack_index, but caps how many shooters share a stack so a large body of
/// identically-armed troops (a guard regiment of lasguns) splits into several smaller stacks
/// instead of one regiment-wide one. Each capped stack fires and targets independently in
/// combat, the way the enemy's obj_enunit blocks already do. Fills a partial chunk first,
/// opens a fresh stack when the current one is full, and only as a last resort (all 71 stack
/// slots used) merges over the cap so fire is never silently dropped.
function find_capped_stack_index(weapon_name, cap) {
    // 1. a matching, un-led chunk that still has room
    for (var si = 1; si < array_length(wep); si++) {
        if (wep[si] == weapon_name && wep_title[si] == "" && wep_num[si] < cap) {
            return si;
        }
    }
    // 2. no room left in any existing chunk: start a fresh one
    for (var si = 1; si < array_length(wep); si++) {
        if (wep[si] == "" && wep_title[si] == "") {
            return si;
        }
    }
    // 3. stack slots exhausted: merge over the cap rather than drop the shots
    for (var si = 1; si < array_length(wep); si++) {
        if (wep[si] == weapon_name && wep_title[si] == "") {
            return si;
        }
    }
    return -1;
}

/// @self Asset.GMObject.obj_pnunit
function player_head_role_stack(stack_index, unit) {
    wep_title[stack_index] = unit.role();
    if (!array_contains(wep_solo[stack_index], unit.name())) {
        array_push(wep_solo[stack_index], unit.name());
    }
}

/// @self Asset.GMObject.obj_pnunit
function scr_player_combat_weapon_stacks() {
    if (defenses == 1) {
        var i = 0;

        i += 1;
        wep[i] = "Heavy Bolter Emplacement";
        wep_num[i] = round(obj_ncombat.player_defenses / 2);
        range[i] = 99;
        att[i] = 160 * wep_num[i];
        apa[i] = 0;
        ammo[i] = -1;
        splash[i] = 1;

        i += 1;
        wep[i] = "Missile Launcher Emplacement";
        wep_num[i] = round(obj_ncombat.player_defenses / 2);
        range[i] = 99;
        att[i] = 200 * wep_num[i];
        apa[i] = 120 * wep_num[i];
        ammo[i] = -1;
        splash[i] = 1;

        i += 1;
        wep[i] = "Missile Silo";
        wep_num[i] = min(30, obj_ncombat.player_silos);
        range[i] = 99;
        att[i] = 350 * wep_num[i];
        apa[i] = 200 * wep_num[i];
        ammo[i] = -1;
        splash[i] = 1;

        var rightest = instance_nearest(2000, 240, obj_pnunit);
        if (rightest.id == self.id) {
            instance_destroy();
        }
    }
    if (defenses == 1) {
        exit;
    }

    // ===== OBSOLETE: planetary Guard (iteration 1) =====
    // First-iteration "planetary Guard" men-block (PDF / Imperial Navy). The obj_pnunit
    // `guard` flag is never set to 1 anywhere in the project, so this branch is dead and
    // never runs. Left for reference only. The live guardsmen are individual unit_struct
    // units with role "Guardsman" and fire through the normal weapon path below, not here.
    if (guard == 1) {
        var _gi = 0;
        var _pg = men;    // current Guardsmen in this block

        // Massed lasguns: one per man, attack 60, armour pierce 1, range 6, 30 rounds.
        _gi += 1;
        wep[_gi] = "Lasgun";
        wep_num[_gi] = max(1, _pg);
        range[_gi] = 6;
        att[_gi] = 60 * wep_num[_gi];
        apa[_gi] = 1;
        ammo[_gi] = 30;
        splash[_gi] = 0;

        // Bayonets (melee, range 1). Required or the block locks up in melee: once an
        // enemy is adjacent the fire logic disables every ranged weapon, and with no
        // melee weapon the Guard can neither shoot nor swing. Guardsmen are poor in
        // melee, so this is a weak profile.
        _gi += 1;
        wep[_gi] = "Bayonet";
        wep_num[_gi] = max(1, _pg);
        range[_gi] = 1;
        att[_gi] = 12 * wep_num[_gi];
        apa[_gi] = 0;
        ammo[_gi] = -1;
        splash[_gi] = 0;

        // Heavy bolters: attack 120, range 16. Anti-infantry support only. The Guard
        // carry no anti-tank weapon by design, so a pure-infantry force cannot crack
        // armour; they bleed against vehicles unless a Leman Russ tank line is present.
        _gi += 1;
        wep[_gi] = "Heavy Bolter";
        wep_num[_gi] = max(1, round(_pg / 200));
        range[_gi] = 16;
        att[_gi] = 120 * wep_num[_gi];
        apa[_gi] = 0;
        ammo[_gi] = -1;
        splash[_gi] = 0;

        exit;
    }

    if (guard == 2) {
        // Leman Russ tank line, fielded as its own block separate from the infantry,
        // the way the enemy Imperial Guard keep tanks out of their soldier lines.
        // Battle Cannon 300 and Lascannon 200, both armour-piercing, scaled to the
        // tanks still alive. This is the Guard's only anti-armour.
        var _gi = 0;
        var _tk = veh;

        _gi += 1;
        wep[_gi] = "Battle Cannon";
        wep_num[_gi] = max(1, _tk);
        range[_gi] = 12;
        att[_gi] = 300 * wep_num[_gi];
        apa[_gi] = round(att[_gi] * 0.6);
        ammo[_gi] = -1;
        splash[_gi] = 0;

        _gi += 1;
        wep[_gi] = "Lascannon";
        wep_num[_gi] = max(1, _tk);
        range[_gi] = 20;
        att[_gi] = 200 * wep_num[_gi];
        apa[_gi] = round(att[_gi] * 0.8);
        ammo[_gi] = -1;
        splash[_gi] = 0;

        exit;
    }

    var i, g = 0;
    veh = 0;
    men = 0;
    dreads = 0;
    for (i = 0; i < array_length(att); i++) {
        dudes_num[i] = 0;
        att[i] = 0;
        apa[i] = 0;
        wep_num[i] = 0;
        wep_rnum[i] = 0;
        // if (wep_owner[i]!="") and (wep_num[i]>1) then wep_owner[i]="assorted";// What if they are using two ranged weapons?  Hmmmmm?
    }

    var dreaded = false;

    for (g = 0; g < array_length(unit_struct); g++) {
        var unit = unit_struct[g];
        if (is_struct(unit)) {
            if (unit.hp() > 0) {
                marine_dead[g] = 0;
            }
            if (unit.hp() > 0 && marine_dead[g] != true) {
                var head_role = unit.IsSpecialist();
                var armour_data = unit.get_armour_data();
                var is_dreadnought = false;
                if (is_struct(armour_data)) {
                    is_dreadnought = armour_data.has_tag("dreadnought");
                }
                var unit_hp = unit.hp();

                if (unit_hp) {
                    if (is_dreadnought) {
                        dreads += 1;
                        dreaded = true;
                    } else {
                        men += 1;
                    }
                }

                var mobi_item = unit.get_mobility_data();
                var gear_item = unit.get_gear_data();
                var armour_item = unit.get_armour_data();

                if (unit.mobility_item() != "Bike" && unit.mobility_item() != "") {
                    if (is_struct(mobi_item)) {
                        if (mobi_item.has_tag("jump")) {
                            var stack_index = find_stack_index("Hammer of Wrath", head_role, unit);
                            if (stack_index > -1) {
                                add_data_to_stack(stack_index, unit.hammer_of_wrath(), false, head_role, unit);
                                if (head_role) {
                                    player_head_role_stack(stack_index, unit);
                                }
                            }
                        }
                    }
                }
                if (is_struct(mobi_item) && mobi_item.has_tag("bike")) {
                    var _speed_force = unit.speed_force(mobi_item.has_tag("sf_ranged"));
                    var stack_index = find_stack_index(_speed_force.name, head_role, unit);
                    if (stack_index > -1) {
                        add_data_to_stack(stack_index, _speed_force, false, head_role, unit);
                        if (head_role) {
                            player_head_role_stack(stack_index, unit);
                        }
                    }
                }

                if (is_struct(mobi_item)) {
                    add_second_profiles_to_stack(mobi_item);
                }
                if (is_struct(gear_item)) {
                    add_second_profiles_to_stack(gear_item);
                }
                if (is_struct(armour_item)) {
                    add_second_profiles_to_stack(armour_item);
                }

                if (unit.IsSpecialist(SPECIALISTS_LIBRARIANS, true) || (unit.role() == obj_ini.role[100][eROLE.CHAPTERMASTER] && obj_ncombat.chapter_master_psyker == 1)) {
                    if (marine_casting_cooldown[g] == 0) {
                        if (array_length(unit.powers_known) > 0) {
                            if (marine_casting[g] == true) {
                                marine_casting[g] = false;
                            }

                            var cast_target = unit.perils_threshold() * 2;
                            var cast_dice = roll_dice(1, 100);
                            if (unit.has_trait("warp_tainted")) {
                                cast_dice += 40;
                            }

                            if (cast_dice >= cast_target) {
                                marine_casting[g] = true;
                            }
                        }
                    } else {
                        marine_casting_cooldown[g]--;
                    }
                }

                var good = 0, open = 0; // Counts the number and types of marines within this object
                for (var j = 0; j <= 40; j++) {
                    if ((dudes[j] == "") && (open == 0)) {
                        open = j; // Determine if vehicle here
                    }
                    if (marine_type[g] == dudes[j]) {
                        good = 1;
                        dudes_num[j] += 1;
                    }
                    if ((good == 0) && (open != 0)) {
                        dudes[open] = marine_type[g];
                        dudes_num[open] = 1;
                    }
                }
                if (marine_casting[g] == false) {
                    var weapon_stack_index = 0;
                    // ===== RESERVED: Guard Squad (iteration 2) =====
                    // Single pooled-HP squad entity (role "Guard Squad"). Not deployed in
                    // normal play; the live guardsmen are individuals. Kept deliberately for
                    // planned reuse as heavy weapons teams. Do not delete.
                    if (unit.role() == "Guard Squad") {
                        // The squad thins as it takes losses: its surviving strength scales with
                        // remaining health, so a half-health squad fires half its lasguns and a
                        // squad on its last legs fires one. It fires wep1 once per surviving man
                        // and its special weapon (wep2) once while the squad still lives.
                        var _sq_max = unit.max_health();
                        var _sq_men = (_sq_max > 0) ? max(1, ceil(GUARD_SQUAD_SIZE * unit.hp() / _sq_max)) : 1;
                        add_squad_weapon(unit.weapon_one(), _sq_men, head_role, unit);
                        add_squad_weapon(unit.weapon_two(), 1, head_role, unit);
                    } else {
                        var primary_ranged = unit.ranged_damage_data[3]; //collect unit ranged data
                        // Hot-shot power draw is handled upstream: ranged_attack() in
                        // scr_marine_struct swaps a packless Hellgun for Lasgun data
                        // (Skitarii exempt), so by the time it reaches this stack it
                        // already carries honest numbers. Do not hard-block it here.
                        // Rank-and-file guardsmen split into enemy-block-sized volleys (capped
                        // stacks) instead of merging the whole regiment into one lasgun stack, so
                        // each volley fires and picks its target on its own. Everyone else (Marines,
                        // sergeants, specialists) stacks normally.
                        if (unit.role() == "Guardsman") {
                            weapon_stack_index = find_capped_stack_index(primary_ranged.name, GUARD_VOLLEY_SIZE);
                        } else {
                            weapon_stack_index = find_stack_index(primary_ranged.name, head_role, unit);
                        }
                        if (weapon_stack_index > -1) {
                            add_data_to_stack(weapon_stack_index, primary_ranged, unit.ranged_damage_data[0], head_role, unit);
                            if (head_role) {
                                player_head_role_stack(weapon_stack_index, unit);
                            }
                        }
                    }

                    var primary_melee = unit.melee_damage_data[3]; //collect unit melee data
                    weapon_stack_index = find_stack_index(primary_melee.name, head_role, unit);
                    if (weapon_stack_index > -1) {
                        if (range[weapon_stack_index] > 1.9) {
                            continue;
                        } //creates secondary weapon stack for close combat ranged weaponry use
                        primary_melee.range = 1;
                        add_data_to_stack(weapon_stack_index, primary_melee, unit.melee_damage_data[0], head_role, unit);
                        if (head_role) {
                            player_head_role_stack(weapon_stack_index, unit);
                        }
                        if (floor(primary_melee.range) <= 1 && primary_melee.ammo == 0) {
                            ammo[weapon_stack_index] = -1; //no ammo limit
                        }
                    }
                }
            }
        }
    }
    for (g = 0; g < array_length(veh_id); g++) {
        if ((veh_id[g] > 0) && (veh_hp[g] > 0) && (veh_dead[g] != 1)) {
            if ((veh_id[g] > 0) && (veh_hp[g] > 0)) {
                veh_dead[g] = 0;
            }
            if (veh_hp[g] > 0) {
                veh++;
            }

            // Counts the number and types of marines within this object
            if (veh_dead[g] != 1) {
                var good = 0;
                var open = 0; 
                for (var j = 1; j <= 40; j++) {
                    if ((dudes[j] == "") && (open == 0)) {
                        open = j;
                    }
                    if (veh_type[g] == dudes[j]) {
                        good = 1;
                        dudes_num[j] += 1;
                        dudes_vehicle[j] = 1;
                    }
                    if ((good == 0) && (open != 0)) {
                        dudes[open] = veh_type[g];
                        dudes_num[open] = 1;
                        dudes_vehicle[open] = 1;
                    }
                }
            }

            if (veh_dead[g] != 1) {
                var vehicle_weapon_set = [
                    veh_wep1[g],
                    veh_wep2[g],
                    veh_wep3[g]
                ];
                for (var wep_slot = 0; wep_slot < 3; wep_slot++) {
                    var weapon_check = vehicle_weapon_set[wep_slot];
                    if (weapon_check != "") {
                        var weapon = gear_weapon_data("weapon", weapon_check, "all", false, "standard");
                        if (is_struct(weapon)) {
                            for (var j = 0; j <= 40; j++) {
                                if (wep[j] == "" || wep[j] == weapon.name) {
                                    add_data_to_stack(j, weapon,,, "vehicle");
                                    break;
                                }
                            }
                        }
                    }
                }

                var ram_weapon = create_vehicle_ram_weapon(veh_type[g]);
                if (is_struct(ram_weapon)) {
                    for (var j = 0; j <= 40; j++) {
                        if (wep[j] == "" || wep[j] == ram_weapon.name) {
                            add_data_to_stack(j, ram_weapon,,, "vehicle");
                            break;
                        }
                    }
                }
            }
        }
    }

    // Right here should be retreat- if important units are exposed they should try to hop left

    if ((dudes_num[1] == 0) && (obj_ncombat.started == 0)) {
        instance_destroy();
        exit;
    }

    if ((men == 1) && (veh == 0) && (obj_ncombat.player_forces == 1)) {
        var h = 0;
        for (i = 0; i < array_length(unit_struct); i++) {
            if (h == 0) {
                var unit = unit_struct[i];
                if (!is_struct(unit)) {
                    continue;
                }
                if ((unit.hp() > 0) && (marine_dead[i] == 0)) {
                    h = unit.hp();
                    obj_ncombat.display_p1 = h;
                    obj_ncombat.display_p1n = unit.name_role();
                    break;
                }
            }
        }
    }
}

/// @self Asset.GMObject.obj_ncombat
function set_up_player_blocks_turn() {
    if (instance_exists(obj_pnunit)) {
        // Advance the line front-first as one ordered pass before any block fires, so a
        // rear block never stalls behind a front block that has not moved yet (see
        // move_player_blocks). Movement used to run per-block inside Alarm_0 in arbitrary
        // instance order, which drifted rear vehicles out of the formation.
        move_player_blocks();
        with (obj_pnunit) {
            alarm[3] = 2;
            wait_and_execute(3, scr_player_combat_weapon_stacks);
            alarm[0] = 4;
        }
    }
    turn_count++;
}

/// @self Asset.GMObject.obj_ncombat
function reset_combat_message_arrays() {
    timer_stage = 4;
    timer = 0;
    done = 0;
}

/// @self Asset.GMObject.obj_pnunit
function scr_add_unit_to_roster(unit, is_local = false, is_ally = false) {
    array_push(unit_struct, unit);
    array_push(marine_co, unit.company);
    array_push(marine_id, unit.marine_number);
    array_push(marine_type, unit.role());
    array_push(marine_wep1, unit.weapon_one());
    array_push(marine_wep2, unit.weapon_two());
    array_push(marine_armour, unit.armour());
    array_push(marine_gear, unit.gear());
    array_push(marine_mobi, unit.mobility_item());
    array_push(marine_hp, unit.hp());
    array_push(marine_mobi, unit.mobility_item());
    array_push(marine_exp, unit.experience);
    array_push(marine_powers, unit.specials());
    array_push(marine_ranged, unit.ranged_attack());
    array_push(marine_powers, unit.specials());
    array_push(marine_ac, unit.armour_calc());
    array_push(marine_attack, unit.melee_attack());
    array_push(marine_local, is_local);
    array_push(marine_casting, false);
    array_push(marine_casting_cooldown, 0);
    array_push(marine_defense, 1);

    array_push(marine_dead, 0);
    array_push(marine_mshield, 0);
    array_push(marine_quick, 0);
    array_push(marine_might, 0);
    array_push(marine_fiery, 0);
    array_push(marine_fshield, 0);
    array_push(marine_iron, 0);
    array_push(marine_dome, 0);
    array_push(marine_spatial, 0);
    array_push(marine_dementia, 0);
    array_push(ally, is_ally);
    if (is_local) {
        local_forces = true;
    }
    if (unit.IsSpecialist(SPECIALISTS_DREADNOUGHTS)) {
        dreads++;
    } else {
        men++;
    }
}

function create_vehicle_ram_weapon(veh_type) {
    switch (veh_type) {
        case "Rhino":
        case "Whirlwind":
        case "Predator":
            return new EquipmentStruct(
                {
                    attack: 100,
                    name: "RAM",
                    range: 1,
                    ammo: -1,
                    spli: 6,
                    arp: 3,
                },
                "weapon",
            );
        case "Chimera":
            // The Guard levy's APC rams like the Rhino it parallels, not like a
            // skimmer: same chassis role, same RAM class.
            return new EquipmentStruct(
                {
                    attack: 100,
                    name: "RAM",
                    range: 1,
                    ammo: -1,
                    spli: 6,
                    arp: 3,
                },
                "weapon",
            );
        case "Leman Russ":
            // A battle tank rams in the Land Raider's class, not the Land Speeder's.
        case "Land Raider":
            return new EquipmentStruct(
                {
                    attack: 200,
                    name: "Heavy RAM",
                    range: 1,
                    ammo: -1,
                    spli: 10,
                    arp: 4,
                },
                "weapon",
            );
        default:
        case "Land Speeder":
            return new EquipmentStruct(
                {
                    attack: 60,
                    name: "Light RAM",
                    range: 1,
                    ammo: -1,
                    spli: 4,
                    arp: 2,
                },
                "weapon",
            );
    }
}

function cancel_combat() {
    with (obj_pnunit) {
        instance_destroy();
    }
    with (obj_enunit) {
        instance_destroy();
    }
    with (obj_nfort) {
        instance_destroy();
    }
    with (obj_ncombat) {
        instance_destroy();
    }
}
