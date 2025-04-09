/// @mixin
function scr_shoot(weapon_index_position, target_object, target_index, target_type, melee_or_ranged) {
    try {
        // weapon_index_position: Weapon number
        // target_object: Target object
        // target_index: Target dudes
        // target_type: "att" or "arp" or "highest"
        // melee_or_ranged: melee or ranged

        // This massive clusterfuck of a script uses the newly determined weapon and target data to attack and assign damage

        for (var j = 1; j <= 100; j++) {
            obj_ncombat.dead_ene[j] = "";
            obj_ncombat.dead_ene_n[j] = 0;
        }

        obj_ncombat.dead_enemies = 0;

        if (obj_ncombat.wall_destroyed == 1) {
            exit;
        }

        var _weapon_max_kills = splash[weapon_index_position];
        var _total_damage = att[weapon_index_position];
        var _weapon_ap = apa[weapon_index_position];
        var _weapon_name = wep[weapon_index_position];
        var _weapon_ammo = ammo[weapon_index_position];
        var _shooter = wep_owner[weapon_index_position];
        var _shooter_count = wep_num[weapon_index_position];
        var _shot_count = _shooter_count * _weapon_max_kills;
        var _weapon_damage_type = target_type;
        var _weapon_damage_per_hit = _total_damage / _shooter_count;

        //* Enemy shooting
        if ((weapon_index_position >= 0) && instance_exists(target_object) && (owner == 2)) {
            if (_shooter_count == 0 || _weapon_ammo == 0) {
                exit;
            } else if (_weapon_ammo > 0) {
                ammo[weapon_index_position] -= 1;
            }

            if (_weapon_name == "Web Spinner") {
                _weapon_damage_type = "status";
            } else if (_weapon_damage_type == "medi") {
                _weapon_damage_type = _weapon_ap > 6 ? "arp" : "att";
            }
        
            var _weapon_data = {
                name: _weapon_name,
                damage: _weapon_damage_per_hit,
                armour_pierce: _weapon_ap,
                shot_count: _shot_count,
                shooter_count: _shooter_count,
                attack_type: melee_or_ranged,
                target_type: target_type
            }

            switch (_weapon_damage_type) {
                case "status":
                    target_object.hostile_shooters = (_shooter == "assorted") ? 999 : 1;
                    _weapon_data.damage = 0;
                    scr_clean(target_object, _weapon_data);
                    break;
                case "att":
                case "arp":
                case "dread":
                    if (melee_or_ranged == "wall") {
                        var _wall_weapon_damage = max(1, round(_weapon_damage_per_hit - target_object.ac[1])) * _shooter_count * max(1, _weapon_max_kills / 4);
                        target_object.hp[1] -= _wall_weapon_damage;
                
                        obj_nfort.hostile_weapons = _weapon_name;
                        obj_nfort.hostile_shots = _shooter_count;
                        obj_nfort.hostile_weapon_damage = _wall_weapon_damage;
                
                        scr_flavor2((target_object.hp[1] <= 0), "wall", melee_or_ranged, _weapon_name, _shooter_count);
                    } else {
                        target_object.hostile_shooters = (_shooter == "assorted") ? 999 : 1;

                        scr_clean(target_object, _weapon_data);
                    }
                    break;
            }
        }

        //* Player shooting
        if (instance_exists(target_object) && (owner == eFACTION.Player)) {
            // show_debug_message("{0}, {1}, {2}, {3}, {4}", _shooter_count, _weapon_name, _weapon_max_kills, _weapon_range, att[weapon_index_position])
            var shots_fired = 0;
            var stop = 0;
            var damage_type = "";

            if (weapon_index_position >= 0) {
                shots_fired = _shooter_count;
            }

            if (shots_fired == 0) {
                exit;
            }

            /*if (weapon_index_position<-40){
				if (weapon_index_position=-53){
					if (player_silos>30) then shots_fired=30;
					if (player_silos<30) then shots_fired=player_silos;
				}
				if (weapon_index_position=-51) or (weapon_index_position=-52){
					shots_fired=round(player_silos/2);
				}
			}*/

            while (target_index < array_length(target_object.dudes_hp)) {
                if (target_object.dudes_hp[target_index] == 0) {
                    target_index++;
                    stop = 1;
                } else {
                    stop = 0;
                    break;
                }
            }

            if (weapon_index_position >= 0) {
                if (_weapon_ammo == 0) {
                    stop = 1;
                }
                if (_weapon_ammo > 0) {
                    _weapon_ammo -= 1;
                }
            }
            if (_weapon_name == "Missile Silo") {
                obj_ncombat.player_silos -= min(obj_ncombat.player_silos, 30);
            }

            if (target_type != "highest") {
                damage_type = target_type;
            }
            if ((target_type == "highest") && (weapon_index_position >= 0)) {
                damage_type = "att";
                if ((_total_damage >= 100) && (_weapon_ap > 0)) {
                    damage_type = "arp";
                }
            }
            if (target_type == "highest") {
                if (weapon_index_position == -51 || weapon_index_position == -52 || weapon_index_position == -53) {
                    damage_type = "att";
                }
            }

            if ((weapon_index_position >= 0) || (weapon_index_position < -40)) {
                // Normal shooting
                var overkill = 0,
                    damage_remaining = 0,
                    shots_remaining = 0;

                var that_works = false;

                if (weapon_index_position >= 0) {
                    if ((_total_damage > 0) && (stop == 0)) {
                        that_works = true;
                    }
                }
                if ((weapon_index_position < -40) && (stop == 0)) {
                    that_works = true;
                }

                if (that_works == true) {
                    var damage_per_weapon = 0,
                        c = 0,
                        target_armour_value = 0,
                        ap = 0,
                        wii = "";
                    attack_count_mod = 0;

                    if (weapon_index_position >= 0) {
                        damage_per_weapon = _total_damage / _shooter_count;
                        ap = _weapon_ap;
                    } // Average damage
                    if (weapon_index_position < -40) {
                        wii = "";
                        attack_count_mod = 3;

                        if (weapon_index_position == -51) {
                            wii = "Heavy Bolter Emplacement";
                            at = 160;
                            _weapon_ap = 0;
                        }
                        if (weapon_index_position == -52) {
                            wii = "Missile Launcher Emplacement";
                            at = 200;
                            _weapon_ap = -1;
                        }
                        if (weapon_index_position == -53) {
                            wii = "Missile Silo";
                            at = 250;
                            _weapon_ap = 0;
                        }
                    }

                    target_armour_value = target_object.dudes_ac[target_index];

					// Calculate final armor value based on armor piercing (AP) rating against target type
                    if (target_object.dudes_vehicle[target_index]) {
                        if (_weapon_ap == 4) {
                            target_armour_value = 0;
                        }
                        if (_weapon_ap == 3) {
                            target_armour_value = target_armour_value * 2;
                        }
                        if (_weapon_ap == 2) {
                            target_armour_value = target_armour_value * 4;
                        }
                        if (_weapon_ap == 1) {
                            target_armour_value = target_armour_value * 6;
                        }
                    } else {
                        if (_weapon_ap == 4) {
                            target_armour_value = 0;
                        }
                        if (_weapon_ap == 3) {
                            target_armour_value = target_armour_value * 1.5;
                        }
                        if (_weapon_ap == 2) {
                            target_armour_value = target_armour_value * 2;
                        }
                        if (_weapon_ap == 1) {
                            target_armour_value = target_armour_value * 3;
                        }
                    }

                    attack_count_mod = max(1, _weapon_max_kills);

                    final_hit_weapon_damage_value = damage_per_weapon - (target_armour_value * attack_count_mod); //damage armour reduction

                    final_hit_weapon_damage_value *= target_object.dudes_dr[target_index]; //damage_resistance mod

                    if (final_hit_weapon_damage_value <= 0) {
                        final_hit_weapon_damage_value = 0;
                    } // Average after armour

                    c = shots_fired * final_hit_weapon_damage_value; // New damage

                    var casualties, onceh = 0,
                        ponies = 0;

                    casualties = min(floor(c / target_object.dudes_hp[target_index]), shots_fired * attack_count_mod);

                    ponies = target_object.dudes_num[target_index];
                    if ((target_object.dudes_num[target_index] == 1) && ((target_object.dudes_hp[target_index] - c) <= 0)) {
                        casualties = 1;
                    }

                    if (target_object.dudes_num[target_index] - casualties < 0) {
                        overkill = casualties - target_object.dudes_num[target_index];
                        damage_remaining = c - (overkill * target_object.dudes_hp[target_index]);

                        shots_remaining = round(damage_remaining / damage_per_weapon);
                    }

                    if (target_object.dudes_num[target_index] - casualties < 0) {
                        casualties = ponies;
                    }
                    if (casualties < 0) {
                        casualties = 0;
                    }

                    if (casualties >= 1) {
                        var iii = 0,
                            found = 0,
                            openz = 0;
                        for (iii = 0; iii <= 40; iii++) {
                            iii += 1;
                            if (found == 0) {
                                if ((obj_ncombat.dead_ene[iii] == "") && (openz == 0)) {
                                    openz = iii;
                                }
                                if ((obj_ncombat.dead_ene[iii] == target_object.dudes[target_index]) && (found == 0)) {
                                    found = iii;
                                    obj_ncombat.dead_ene_n[obj_ncombat.dead_enemies] += casualties;
                                }
                            }
                        }
                        if (found == 0) {
                            obj_ncombat.dead_enemies += 1;
                            obj_ncombat.dead_ene[openz] = string(target_object.dudes[target_index]);
                            obj_ncombat.dead_ene_n[openz] = casualties;
                        }
                    }

                    var k = 0;
                    if ((damage_remaining > 0) && (shots_remaining > 0)) {
                        repeat(10) {
                            if ((damage_remaining > 0) && (shots_remaining > 0)) {
                                var godd;
                                godd = 0;
                                k = target_index;

                                // Find similar target in this same group
                                repeat(10) {
                                    k += 1;
                                    if (godd == 0) {
                                        if ((target_object.dudes_num[k] > 0) && (target_object.dudes_vehicle[k] == target_object.dudes_vehicle[target_index])) {
                                            godd = k;
                                        }
                                    }
                                }
                                k = target_index;
                                if (godd == 0) {
                                    repeat(10) {
                                        k -= 1;
                                        if ((godd == 0) && (k >= 1)) {
                                            if ((target_object.dudes_num[k] > 0) && (target_object.dudes_vehicle[k] == target_object.dudes_vehicle[target_index])) {
                                                godd = k;
                                            }
                                        }
                                    }
                                }

                                // Found damage_per_weapon similar target to get the damage
                                if ((godd > 0) && (damage_remaining > 0) && (shots_remaining > 0)) {
                                    var a2, b2, c2, target_armour_value2, ap2;
                                    ap2 = damage_remaining;
                                    a2 = damage_per_weapon; // Average damage

                                    target_armour_value2 = target_object.dudes_ac[godd];
                                    if (target_object.dudes_vehicle[godd] == 0) {
                                        if (ap2 == 1) {
                                            target_armour_value2 = target_armour_value2 * 3;
                                        }
                                        if (ap2 == 2) {
                                            target_armour_value2 = target_armour_value2 * 2;
                                        }
                                        if (ap2 == 3) {
                                            target_armour_value2 = target_armour_value2 * 1.5;
                                        }
                                        if (ap2 == 4) {
                                            target_armour_value2 = 0;
                                        }
                                    }
                                    if (target_object.dudes_vehicle[godd] == 1) {
                                        if (ap2 == 1) {
                                            target_armour_value2 = target_armour_value2 * 6;
                                        }
                                        if (ap2 == 2) {
                                            target_armour_value2 = target_armour_value2 * 4;
                                        }
                                        if (ap2 == 3) {
                                            target_armour_value2 = target_armour_value2 * 2;
                                        }
                                    }
                                    b2 = a2 - target_armour_value2;
                                    if (b2 <= 0) {
                                        b2 = 0;
                                    } // Average after armour

                                    c2 = b2 * shots_remaining; // New damage

                                    var casualties2, ponies2, onceh2;
                                    onceh2 = 0;
                                    ponies2 = 0;
                                    if (attack_count_mod <= 1) {
                                        casualties2 = min(floor(c2 / target_object.dudes_hp[godd]), shots_remaining);
                                    }

                                    if (attack_count_mod > 1) {
                                        casualties2 = floor(c2 / target_object.dudes_hp[godd]);
                                    }
                                    ponies2 = target_object.dudes_num[godd];
                                    if ((target_object.dudes_num[godd] == 1) && ((target_object.dudes_hp[godd] - c2) <= 0)) {
                                        casualties2 = 1;
                                    }
                                    if (target_object.dudes_num[godd] < casualties2) {
                                        casualties2 = target_object.dudes_num[godd];
                                    }
                                    if (casualties2 < 1) {
                                        casualties2 = 0;
                                        damage_remaining = 0;
                                        overkill = 0;
                                        shots_remaining = 0;
                                    }

                                    if ((casualties2 >= 1) && (shots_fired > 0)) {
                                        var iii, found, openz;
                                        iii = 0;
                                        found = 0;
                                        openz = 0;
                                        repeat(40) {
                                            iii += 1;
                                            if (found == 0) {
                                                if ((obj_ncombat.dead_ene[iii] == "") && (openz == 0)) {
                                                    openz = iii;
                                                }
                                                if ((obj_ncombat.dead_ene[iii] == target_object.dudes[godd]) && (found == 0)) {
                                                    found = iii;
                                                    obj_ncombat.dead_ene_n[obj_ncombat.dead_enemies] += casualties;
                                                }
                                            }
                                        }
                                        if (found == 0) {
                                            obj_ncombat.dead_enemies += 1;
                                            obj_ncombat.dead_ene[openz] = string(target_object.dudes[godd]);
                                            obj_ncombat.dead_ene_n[openz] = casualties;
                                        }

                                        /*obj_ncombat.dead_enemies+=1;
									if (casualties2=1) then obj_ncombat.dead_ene[obj_ncombat.dead_enemies]="1 "+string(target_object.dudes[godd]);
									if (casualties2>1) then obj_ncombat.dead_ene[obj_ncombat.dead_enemies]=string(casualties2)+" "+string(target_object.dudes[godd]);
									obj_ncombat.dead_enemies+=1;
									obj_ncombat.dead_ene[obj_ncombat.dead_enemies]=string(target_object.dudes[godd]);
									obj_ncombat.dead_ene_n[obj_ncombat.dead_enemies]=casualties;*/

                                        target_object.dudes_num[godd] -= casualties2;
                                        obj_ncombat.enemy_forces -= casualties2;
                                    }

                                    if (casualties2 >= 1) {
                                        if (target_object.dudes_num[godd] <= 0) {
                                            overkill = casualties2 - target_object.dudes_num[godd];
                                            damage_remaining -= casualties2 * target_object.dudes_hp[godd];

                                            var proportional_shots;
                                            proportional_shots = round(damage_remaining / a2);
                                            shots_remaining = proportional_shots;

                                            // show_message("killed "+string(casualties2)+"x "+string(target_object.dudes[godd]));
                                            // show_message("did "+string(c)+" damage with "+string(proportional_shots)+" shots fired, have "+string(damage_remaining)+" damage remaining");
                                        }
                                    }
                                }
                            }
                        }
                    } // End repeat 10
                    scr_flavor(weapon_index_position, target_object, target_index, shots_fired - wep_rnum[weapon_index_position], casualties);

                    if ((target_object.dudes_num[target_index] == 1) && (c > 0)) {
                        target_object.dudes_hp[target_index] -= c;
                    } // Need special flavor here for just damaging

                    if (casualties >= 1) {
                        target_object.dudes_num[target_index] -= casualties;
                        obj_ncombat.enemy_forces -= casualties;
                    }
                }
            }

            if (stop == 0) {
                compress_enemy_array(target_object);
                destroy_empty_column(target_object);
            }
        }
    } catch (_exception) {
        handle_exception(_exception);
    }
}
