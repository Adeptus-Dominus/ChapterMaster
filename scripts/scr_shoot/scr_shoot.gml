function scr_shoot(weapon_index_position, target_object, target_type, damage_data, melee_or_ranged) {
	try {
		// weapon_index_position: Weapon number
		// target_object: Target object
		// target_type: Target dudes
		// damage_data: "att" or "arp" or "highest"
		// melee_or_ranged: melee or ranged

		// This massive clusterfuck of a script uses the newly determined weapon and target data to attack and assign damage
		for (var j = 1; j <= 100; j++) {
			obj_ncombat.dead_ene[j] = "";
			obj_ncombat.dead_ene_n[j] = 0;
		}
		obj_ncombat.dead_enemies = 0;

		var hostile_type;
		var hostile_damage;
		var hostile_weapon;
		var hostile_range;
		var hostile_splash;
		var aggregate_damage = att[weapon_index_position];
		var armour_pierce = apa[weapon_index_position];
		if (obj_ncombat.wall_destroyed = 1) then exit;

		if (weapon_index_position >= 0) and (instance_exists(target_object)) and (owner==2) {
			var stop, damage_type, doom;
			var shots_fired = wep_num[weapon_index_position];
			if (shots_fired = 0 || ammo[weapon_index_position] == 0) then exit;
			doom = 0;
			if (shots_fired != 1) and(melee_or_ranged != "melee") {
				switch (obj_ncombat.enemy) {
				case eFACTION.Ecclesiarchy:
					doom = 0.3;
					break;
				case eFACTION.Eldar:
					doom = 0.4;
					break;
				case eFACTION.Ork:
					doom = 0.2;
					break;
				case eFACTION.Tau:
					doom = 0.4;
					break;
				case eFACTION.Tyranids:
					doom = 0.4;
					break;
				}
			}
			if (obj_ncombat.enemy = 11) {
				aggregate_damage = round(aggregate_damage * 1.15);
				armour_pierce = round(armour_pierce * 1.15);
			}
			if (obj_ncombat.enemy = 10) and(obj_ncombat.threat = 7) then doom = 1;

			damage_type = "";
			stop = 0;

			if (ammo[weapon_index_position] > 0) then ammo[weapon_index_position] -= 1;

			if (damage_data == "medi") {
				damage_type = "att";
				if (aggregate_damage < armour_pierce) then damage_type = "arp";
			} else {
				damage_type = damage_data;
			}
			if (wep[weapon_index_position] = "Web Spinner") then damage_type = "status";

			var attack_count_mod = splash[weapon_index_position];

			if (damage_type = "status") and(stop = 0) and(shots_fired > 0) {
				var damage_per_weapon = 0,
					hit_number = shots_fired;
				if (attack_count_mod > 1) and(melee_or_ranged != "wall") {
					shots_fired *= attack_count_mod;
				}
				if (hit_number > 0) and(melee_or_ranged != "wall") and(instance_exists(target_object)) {
					if (wep_owner[weapon_index_position] == "assorted"){ target_object.hostile_shooters = 999;}
					else if (wep_owner[weapon_index_position] != "assorted"){ target_object.hostile_shooters = 1;}
					hostile_damage = 0;
					hostile_weapon = wep[weapon_index_position];
					hostile_type = 1;
					hostile_range = range[weapon_index_position];
					hostile_splash = attack_count_mod;
					
					scr_clean(target_object, hostile_type, hit_number, hostile_damage, hostile_weapon, hostile_range, hostile_splash);
				}
			} else if (damage_type = "att") and(aggregate_damage > 0) and(stop = 0) and(shots_fired > 0) {
				var damage_per_weapon, hit_number;

				damage_per_weapon = aggregate_damage;

				if (melee_or_ranged = "melee") {
					if (shots_fired > (target_object.men - target_object.dreads) * 2) {
						doom = ((target_object.men - target_object.dreads) * 2) / shots_fired;
					}
				}

				hit_number = shots_fired;

				if (doom != 0) and(shots_fired > 1) {
					damage_per_weapon = floor((doom * damage_per_weapon));
					hit_number = floor(hit_number * doom);
				}
				if (attack_count_mod > 1) and(melee_or_ranged != "wall") {
					shots_fired *= attack_count_mod;
				}

				if (hit_number > 0) and(melee_or_ranged != "wall") and(instance_exists(target_object)) {
					if (wep_owner[weapon_index_position] = "assorted") then target_object.hostile_shooters = 999;
					if (wep_owner[weapon_index_position] != "assorted") then target_object.hostile_shooters = 1;
					hostile_damage = damage_per_weapon / hit_number;
					hostile_weapon = wep[weapon_index_position];
					hostile_type = 1;
					hostile_range = range[weapon_index_position];
					hostile_splash = attack_count_mod;
					if (hostile_splash > 1) then hostile_damage += attack_count_mod * 3;

					scr_clean(target_object, hostile_type, hit_number, hostile_damage, hostile_weapon, hostile_range, hostile_splash);
				}
			} else if ((damage_type = "arp") or(damage_type = "dread")) and(armour_pierce > 0) and(stop = 0) and(shots_fired > 0) {
				var damage_per_weapon, hit_number;
				damage_per_weapon = aggregate_damage;
				if (aggregate_damage = 0) then damage_per_weapon = shots_fired;

				if (melee_or_ranged = "melee") {
					if (shots_fired > ((target_object.veh + target_object.dreads) * 5)) {
						doom = ((target_object.veh + target_object.dreads) * 5) / shots_fired;
					}
				}
				hit_number = shots_fired;

				if (doom != 0) and(shots_fired > 1) {
					damage_per_weapon = floor((doom * damage_per_weapon));
					hit_number = floor(hit_number * doom);
				}
				if (attack_count_mod > 1) and(melee_or_ranged != "wall") {
					shots_fired *= attack_count_mod;
				}

				if (damage_per_weapon = 0) then damage_per_weapon = shots_fired * doom;

				if (hit_number > 0 && instance_exists(target_object)) {
					hostile_weapon = wep[weapon_index_position];
					hostile_range = range[weapon_index_position];
					hostile_splash = attack_count_mod;
					hostile_damage = (hostile_splash == 1) ? attack_count_mod * 3 : 0;
					hostile_damage += damage_per_weapon / hit_number;
					if (melee_or_ranged == "wall") {
						var dest = 0;

						hostile_damage -= target_object.ac[1];
						hostile_damage = max(0, hostile_damage);
						hostile_damage = round(hostile_damage) * hit_number;
						target_object.hp[1] -= hostile_damage;
						if (target_object.hp[1] <= 0) dest = 1;
						obj_nfort.hostile_weapons = hostile_weapon;
						obj_nfort.hostile_shots = hit_number;
						obj_nfort.hostile_damage = hostile_damage;

						scr_flavor2(dest, "wall", hostile_range, hostile_weapon, hit_number, hostile_splash);
					} else {
						target_object.hostile_shooters = (wep_owner[weapon_index_position] == "assorted") ? 999 : 1;
						hostile_type = 0;

						scr_clean(target_object, hostile_type, hit_number, hostile_damage, hostile_weapon, hostile_range, hostile_splash);
					}
				}
			}
		}

		if (instance_exists(target_object)) and(owner == eFACTION.Player) {
			// show_debug_message("{0}, {1}, {2}, {3}, {4}", wep_num[weapon_index_position], wep[weapon_index_position], splash[weapon_index_position], range[weapon_index_position], att[weapon_index_position])
			var shots_fired = 0;
			var stop = 0;
			var damage_type = "";

			if (weapon_index_position >= 0) {
				shots_fired = wep_num[weapon_index_position];
			}

			if (shots_fired = 0) then exit;

			/*if (weapon_index_position<-40){
				if (weapon_index_position=-53){
					if (player_silos>30) then shots_fired=30;
					if (player_silos<30) then shots_fired=player_silos;
				}
				if (weapon_index_position=-51) or (weapon_index_position=-52){
					shots_fired=round(player_silos/2);
				}
			}*/


			while (target_type < array_length(target_object.dudes_hp)) {
				if (target_object.dudes_hp[target_type] == 0) {
					target_type++;
					stop = 1;
				} else {
					stop = 0;
					break;
				}
			}

			if (weapon_index_position >= 0) {
				if (ammo[weapon_index_position] = 0) then stop = 1;
				if (ammo[weapon_index_position] > 0) then ammo[weapon_index_position] -= 1;
			}
			if (wep[weapon_index_position] == "Missile Silo") then obj_ncombat.player_silos -= min(obj_ncombat.player_silos, 30);

			if (damage_data != "highest") then damage_type = damage_data;
			if (damage_data = "highest") and(weapon_index_position >= 0) {
				damage_type = "att";
				if (aggregate_damage >= 100) and(armour_pierce > 0) then damage_type = "arp";
			}
			if (damage_data = "highest") {
				if (weapon_index_position = -51 || weapon_index_position = -52 || weapon_index_position = -53) then damage_type = "att";
			}

			if (weapon_index_position >= 0) or(weapon_index_position < -40) { // Normal shooting
				var overkill = 0,
					damage_remaining = 0,
					shots_remaining = 0;

				var that_works = false;

				if (weapon_index_position >= 0) {
					if (aggregate_damage > 0) and(stop = 0) then that_works = true;
				}
				if (weapon_index_position < -40) and(stop = 0) then that_works = true;

				if (that_works = true) {
					var damage_per_weapon = 0,
						c = 0,
						target_armour_value = 0,
						ap = 0,
						wii = "";
					attack_count_mod = 0;

					if (weapon_index_position >= 0) {
						damage_per_weapon = (aggregate_damage / wep_num[weapon_index_position]);
						ap = armour_pierce;
					} // Average damage
					if (weapon_index_position < -40) {
						wii = "";
						attack_count_mod = 3;

						if (weapon_index_position = -51) {
							wii = "Heavy Bolter Emplacement";
							at = 160;
							armour_pierce = 0;
						}
						if (weapon_index_position = -52) {
							wii = "Missile Launcher Emplacement";
							at = 200;
							armour_pierce = 1;
						}
						if (weapon_index_position = -53) {
							wii = "Missile Silo";
							at = 250;
							ar = 0;
						}
					}

					target_armour_value = target_object.dudes_ac[target_type];

					if (target_object.dudes_vehicle[target_type]) {
						if (armour_pierce = 0) then target_armour_value = target_armour_value * 6;
						if (armour_pierce = -1) then target_armour_value = damage_per_weapon;
					} else {
						if (armour_pierce = 1) then target_armour_value = 0;
						if (armour_pierce = -1) then target_armour_value = target_armour_value * 6;
					}

					attack_count_mod = splash[weapon_index_position] < 1 ? 1 : splash[weapon_index_position];

					final_hit_damage_value = damage_per_weapon - (target_armour_value * attack_count_mod); //damage armour reduction

					final_hit_damage_value *= target_object.dudes_dr[target_type]; //damage_resistance mod

					if (final_hit_damage_value <= 0) then final_hit_damage_value = 0; // Average after armour

					c = shots_fired * final_hit_damage_value; // New damage

					var casualties, onceh = 0,
						ponies = 0;

					casualties = min(floor(c / target_object.dudes_hp[target_type]), shots_fired * attack_count_mod);

					ponies = target_object.dudes_num[target_type];
					if (target_object.dudes_num[target_type] = 1) and((target_object.dudes_hp[target_type] - c) <= 0) {
						casualties = 1;
					}

					if (target_object.dudes_num[target_type] - casualties < 0) {
						overkill = casualties - target_object.dudes_num[target_type];
						damage_remaining = c - (overkill * target_object.dudes_hp[target_type]);

						shots_remaining = round(damage_remaining / damage_per_weapon);
					}

					if (target_object.dudes_num[target_type] - casualties < 0) then casualties = ponies;
					if (casualties < 0) then casualties = 0;

					if (casualties >= 1) {

						var iii = 0,
							found = 0,
							openz = 0;
						for (iii = 0; iii <= 40; iii++) {
							iii += 1;
							if (found = 0) {
								if (obj_ncombat.dead_ene[iii] = "") and(openz = 0) then openz = iii;
								if (obj_ncombat.dead_ene[iii] = target_object.dudes[target_type]) and(found = 0) {
									found = iii;
									obj_ncombat.dead_ene_n[obj_ncombat.dead_enemies] += casualties;
								}
							}
						}
						if (found = 0) {
							obj_ncombat.dead_enemies += 1;
							obj_ncombat.dead_ene[openz] = string(target_object.dudes[target_type]);
							obj_ncombat.dead_ene_n[openz] = casualties;
						}
					}

					var k = 0;
					if (damage_remaining > 0) and(shots_remaining > 0) then repeat(10) {
						if (damage_remaining > 0) and(shots_remaining > 0) {
							var godd;
							godd = 0;
							k = target_type;

							// Find similar target in this same group
							repeat(10) {
								k += 1;
								if (godd = 0) {
									if (target_object.dudes_num[k] > 0) and(target_object.dudes_vehicle[k] = target_object.dudes_vehicle[target_type]) {
										godd = k;
									}
								}
							}
							k = target_type;
							if (godd = 0) then repeat(10) {
								k -= 1;
								if (godd = 0) and(k >= 1) {
									if (target_object.dudes_num[k] > 0) and(target_object.dudes_vehicle[k] = target_object.dudes_vehicle[target_type]) {
										godd = k;
									}
								}
							}

							// Found damage_per_weapon similar target to get the damage
							if (godd > 0) and(damage_remaining > 0) and(shots_remaining > 0) {
								var a2, b2, c2, target_armour_value2, ap2;
								ap2 = damage_remaining;
								a2 = damage_per_weapon; // Average damage

								target_armour_value2 = target_object.dudes_ac[godd];
								if (target_object.dudes_vehicle[godd] = 0) {
									if (ap2 = 1) then target_armour_value2 = 0;
									if (ap2 = -1) then target_armour_value2 = target_armour_value2 * 6;
								}
								if (target_object.dudes_vehicle[godd] = 1) {
									if (ap2 = 0) then target_armour_value2 = target_armour_value2 * 6;
									if (ap2 = -1) then target_armour_value2 = damage_per_weapon;
								}
								b2 = a2 - target_armour_value2;
								if (b2 <= 0) then b2 = 0; // Average after armour

								c2 = b2 * shots_remaining; // New damage

								var casualties2, ponies2, onceh2;
								onceh2 = 0;
								ponies2 = 0;
								if (attack_count_mod <= 1) then casualties2 = min(floor(c2 / target_object.dudes_hp[godd]), shots_remaining);

								if (attack_count_mod > 1) then casualties2 = floor(c2 / target_object.dudes_hp[godd]);
								ponies2 = target_object.dudes_num[godd];
								if (target_object.dudes_num[godd] = 1) and((target_object.dudes_hp[godd] - c2) <= 0) {
									casualties2 = 1;
								}
								if (target_object.dudes_num[godd] < casualties2) then casualties2 = target_object.dudes_num[godd];
								if (casualties2 < 1) {
									casualties2 = 0;
									damage_remaining = 0;
									overkill = 0;
									shots_remaining = 0;
								}

								if (casualties2 >= 1) and(shots_fired > 0) {
									var iii, found, openz;
									iii = 0;
									found = 0;
									openz = 0;
									repeat(40) {
										iii += 1;
										if (found = 0) {
											if (obj_ncombat.dead_ene[iii] = "") and(openz = 0) then openz = iii;
											if (obj_ncombat.dead_ene[iii] = target_object.dudes[godd]) and(found = 0) {
												found = iii;
												obj_ncombat.dead_ene_n[obj_ncombat.dead_enemies] += casualties;
											}
										}
									}
									if (found = 0) {
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
					} // End repeat 10
					scr_flavor(weapon_index_position, target_object, target_type, shots_fired - wep_rnum[weapon_index_position], casualties);

					if (target_object.dudes_num[target_type] = 1) and(c > 0) then target_object.dudes_hp[target_type] -= c; // Need special flavor here for just damaging

					if (casualties >= 1) {
						target_object.dudes_num[target_type] -= casualties;
						obj_ncombat.enemy_forces -= casualties;

					}
				}
			}

			if (stop = 0) then with(target_object) {
				var j, good, open;
				j = 0;
				good = 0;
				open = 0;
				repeat(20) {
					j += 1;
					if (dudes_num[j] <= 0) {
						dudes[j] = "";
						dudes_special[j] = "";
						dudes_num[j] = 0;
						dudes_ac[j] = 0;
						dudes_hp[j] = 0;
						dudes_vehicle[j] = 0;
						dudes_damage[j] = 0;
					}
					if (dudes[j] = "") and(dudes[j + 1] != "") {
						dudes[j] = dudes[j + 1];
						dudes_special[j] = dudes_special[j + 1];
						dudes_num[j] = dudes_num[j + 1];
						dudes_ac[j] = dudes_ac[j + 1];
						dudes_hp[j] = dudes_hp[j + 1];
						dudes_vehicle[j] = dudes_vehicle[j + 1];
						dudes_damage[j] = dudes_damage[j + 1];

						dudes[j + 1] = "";
						dudes_special[j + 1] = "";
						dudes_num[j + 1] = 0;
						dudes_ac[j + 1] = 0;
						dudes_hp[j + 1] = 0;
						dudes_vehicle[j + 1] = 0;
						dudes_damage[j + 1] = 0;
					}
				}
				j = 0;
			}
			if (target_object.men + target_object.veh + target_object.medi = 0) and(target_object.owner != 1) {
				with(target_object) {
					instance_destroy();
				}
			}

			if (melee_or_ranged = "melee") {
				// lololol
			}

		}
	} catch(_exception) {
		handle_exception(_exception);
	}
}