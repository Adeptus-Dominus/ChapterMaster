/// @function add_battle_log_message
/// @param {string} _message - The message text to add to the battle log
/// @param {real} [_message_size=0] - The size/importance of the message (higher values = higher display priority; affects sorting order)
/// @param {real} [_message_priority=0] - The priority level (affects sorting and text color: 0=normal, 135=blue, 134=purple)
/// @returns {real} The index of the newly added message
function add_battle_log_message(_message, _message_size = 0, _message_priority = 0) {
	if (instance_exists(obj_ncombat)) {
		obj_ncombat.messages++;
		var _message_index = obj_ncombat.messages;
		
		obj_ncombat.message[_message_index] = _message;
		obj_ncombat.message_sz[_message_index] = _message_size + (0.5 - (obj_ncombat.messages / 100));
		obj_ncombat.message_priority[_message_index] = _message_priority;
		
		return _message_index;
	}
	return -1;
}

function display_battle_log_message() {
    // Trigger the message processing alarm
    obj_ncombat.alarm[3] = 5;
}

/// @mixin
function scr_flavor(_weapon_stack, _target_object, _target_i, casulties) {

	// Generates flavor based on the damage and casualties from scr_shoot, only for the player

	var attack_message, kill_message, leader_message;
	leader_message = "";
	attack_message = $"";
	kill_message = "";

	var weapon_name = _weapon_stack.weapon_name;
	var number_of_shots = _weapon_stack.weapon_count
	var target = _target_object;
	var targeh = _target_i;

	// if (id_of_attacking_weapons = -51) then weapon_name = "Heavy Bolter Emplacemelse ent";
	// if (id_of_attacking_weapons = -52) then weapon_name = "Missile Launcher Emplacement";
	// if (id_of_attacking_weapons = -53) then weapon_name = "Missile Silo";

	var weapon_data = gear_weapon_data("weapon", weapon_name, "all");
	if (!is_struct(weapon_data)) {
		weapon_data = new EquipmentStruct({},"");
		weapon_data.name = weapon_name;
	}

	var target_name = target.dudes[targeh];

	if (target_name = "Leader") and (obj_ncombat.enemy <= 10) {
		target_name = obj_controller.faction_leader[obj_ncombat.enemy];
	}

	var character_shot = false;
	var unit_name = "";

		if (array_length(_weapon_stack.owners) == 1) {
			unit_name = $"{_weapon_stack.owners[0]}";
			character_shot = true;
		}

	if (obj_ncombat.battle_special = "WL10_reveal") or (obj_ncombat.battle_special = "WL10_later") {
		if (target_name = "Veteran Chaos Terminator") and (target_name > 0) then obj_ncombat.chaos_angry += casulties * 2;
		if (target_name = "Veteran Chaos Chosen") and (target_name > 0) then obj_ncombat.chaos_angry += casulties;
		if (target_name = "Greater Daemon of Slaanesh") then obj_ncombat.chaos_angry += casulties * 5;
		if (target_name = "Greater Daemon of Tzeentch") then obj_ncombat.chaos_angry += casulties * 5;
	}

	if (target.flank = 1) and (target.flyer = 0) then target_name = "flanking " + target_name;

	var flavoured = false;

	if (weapon_data.has_tag("bolt")) {
		flavoured = true;
		if (!character_shot) {
			if (obj_ncombat.bolter_drilling == 1) {
				attack_message += "With perfect accuracy ";
			}
			if (number_of_shots < 200) {
				if (target.dudes_num[targeh] == 1) {
					if (casulties == 0) {
						attack_message += $"{number_of_shots} {weapon_name}s fire. The {target_name} is hit but survives.";
					} else {
						attack_message += $"{number_of_shots} {weapon_name}s fire. The {target_name} is struck down.";
					}
				} else {
					if (casulties == 0) {
						attack_message += $"{number_of_shots} {weapon_name}s fire hits {target_name} ranks without causing casualties.";
					} else {
						attack_message += $"{number_of_shots} {weapon_name}s strike {target_name} ranks, taking down {casulties}.";
					}
				}
			} else {
				if (target.dudes_num[targeh] == 1) {
					if (casulties == 0) {
						attack_message += $"{number_of_shots} {weapon_name}s fire. Explosions rock the {target_name}'s armour but don't kill it.";
					} else {
						attack_message += $"{number_of_shots} {weapon_name}s fire. Explosions take down the {target_name}.";
					}
				} else {
					if (casulties == 0) {
						attack_message += $"{number_of_shots} {weapon_name}s hit {target_name} ranks, but no casualties are confirmed.";
					} else {
						attack_message += $"{number_of_shots} {weapon_name}s tear through {target_name} ranks, instantly killing {casulties}.";
					}
				}
			}
		} else {
			if (target.dudes_num[targeh] == 1) {
				if (casulties == 0) {
					attack_message += $"{string(unit_name)} fires his {weapon_name} at the {target_name} but fails to kill it.";
				} else {
					attack_message += $"{string(unit_name)} eliminates the {target_name} with his {weapon_name}.";
				}
			} else {
				if (casulties == 0) {
					attack_message += $"{string(unit_name)} fires his {weapon_name} at {target_name} ranks but fails to kill any.";
				} else {
					attack_message += $"{string(unit_name)} takes down {casulties} {target_name} with his {weapon_name}.";
				}
			}
		}

	} else if (weapon_name == "Hammer of Wrath" || weapon_name == "Hammer of Wrath(M)") {
		flavoured = true;
		if (!character_shot) {
			if (number_of_shots < 20) {
				attack_message += $"{number_of_shots} Astartes with Jump Packs soar upwards, flames roaring. They plummet back down upon the enemy- ";
			} else if (number_of_shots >= 20 && number_of_shots < 100) {
				attack_message += $"Squads of {number_of_shots} Astartes ascend with roaring Jump Packs. They descend upon the enemy- ";
			} else {
				attack_message += $"A massive wave of {number_of_shots} Astartes rise, their Jump Packs a furious beast. They crash down, smashing their foe- ";
			}
			if (target.dudes_num[targeh] == 1) {
				if (casulties == 0) {
					attack_message += $"but the {target_name} endures the onslaught.";
				} else {
					attack_message += $"the {target_name} falls to the charge.";
				}
			} else {
				if (casulties == 0) {
					attack_message += $"{target_name} ranks are hit, but no casualties are confirmed.";
				} else {
					attack_message += $"{target_name} ranks are hit, killing {casulties} in an instant.";
				}
			}
		} else {
			if (target.dudes_num[targeh] == 1) {
				attack_message += string(unit_name) + $" engages his Jump Pack, soaring and crashing into the {target_name}- ";
				if (casulties == 0) {
					attack_message += $"but it endures the onslaught.";
				} else {
					attack_message += $"and it falls to the charge.";
				}
			} else {
				attack_message += string(unit_name) + $" activates his Jump Pack, slamming into {target_name} ranks- ";
				if (casulties == 0) {
					attack_message += $"but all survive the impact.";
				} else {
					attack_message += $"killing {casulties} perish in the attack.";
				}
			}
		}

	} else if (weapon_name == "Assault Cannon") {
		flavoured = true;
		if (!character_shot) {
			if (target.dudes_num[targeh] == 1) {
				if (casulties == 0) {
					attack_message += $"{number_of_shots} {weapon_name}s roar, explosions clap across the armour of the {target_name} but it remains standing.";
				} else {
					attack_message += $"{number_of_shots} {weapon_name}s fire at the {target_name} and rip it apart.";
				}
			} else {
				if (casulties == 0) {
					attack_message += $"{number_of_shots} {weapon_name}s thunder, {target_name} are rocked but unharmed.";
				} else {
					attack_message += $"{number_of_shots} {weapon_name}s mow down {casulties} {target_name}.";
				}
			}
		} else {
			if (target.dudes_num[targeh] == 1) {
				if (casulties == 0) {
					attack_message += $"{string(unit_name)} {weapon_name} fires but the {target_name} survives.";
				} else {
					attack_message += $"{string(unit_name)} obliterates the {target_name} with the {weapon_name}.";
				}
			} else {
				if (casulties == 0) {
					attack_message += $"{string(unit_name)} {weapon_name} fails to breach {target_name} ranks.";
				} else {
					attack_message += $"{string(unit_name)} cuts down {casulties} {target_name} with the {weapon_name}.";
				}
			}
		}

	} else if (weapon_name == "Missile Launcher") {
		flavoured = true;
		if (!character_shot) {
			if (target.dudes_num[targeh] == 1) {
				if (casulties == 0) {
					attack_message = $"{number_of_shots} {weapon_name}s fire upon the {target_name} but it remains standing.";
				} else {
					attack_message = $"{number_of_shots} {weapon_name}s blast the {target_name} to oblivion.";
				}
			} else {
				if (casulties == 0) {
					attack_message = $"{number_of_shots} {weapon_name}s hit {target_name} ranks but they hold firm.";
				} else {
					attack_message = $"{number_of_shots} {weapon_name}s pulverize {casulties} {target_name}.";
				}
			}
		} else {
			if (target.dudes_num[targeh] == 1) {
				if (casulties == 0) {
					attack_message = $"{string(unit_name)} {weapon_name} fires upon the {target_name} but it survives.";
				} else {
					attack_message = $"{string(unit_name)} obliterates {target_name} with the {weapon_name}.";
				}
			} else {
				if (casulties == 0) {
					attack_message = $"{string(unit_name)} {weapon_name} fails to inflict damage upon {target_name} ranks.";
				} else {
					attack_message = $"{string(unit_name)} pulverizes {casulties} {target_name} with the {weapon_name}.";
				}
			}
		}

	} else if (weapon_name == "Whirlwind Missiles") {
		flavoured = true;
		if (!character_shot) {
			if (target.dudes_num[targeh] == 1) {
				if (casulties == 0) {
					attack_message = $"{number_of_shots} Whirlwinds fire upon the {target_name} but it remains standing.";
				} else {
					attack_message = $"{number_of_shots} Whirlwinds blast {target_name} to oblivion.";
				}
			} else {
				if (casulties == 0) {
					attack_message = $"{number_of_shots} Whirlwinds hit {target_name} ranks but they hold firm.";
				} else {
					attack_message = $"{number_of_shots} Whirlwinds pulverize {casulties} {target_name}.";
				}
			}
		} else {
			if (target.dudes_num[targeh] == 1) {
				if (casulties == 0) {
					attack_message = $"Whirlwind fires upon the {target_name} but it survives.";
				} else {
					attack_message = $"Whirlwind obliterates the {target_name}.";
				}
			} else {
				if (casulties == 0) {
					attack_message = $"Whirlwind fails to inflict damage upon {target_name} ranks.";
				} else {
					attack_message = $"Whirlwind pulverizes {casulties} {target_name}.";
				}
			}
		}

	} else if (weapon_name == "fists") or (weapon_name == "Melee") or (weapon_name == "melee") {
		flavoured = true;
		var ra = choose(1, 2, 3, 4);
		// This needs to be worked out
		if (casulties = 0) then attack_message = $"{target_name} engaged in hand-to-hand combat, no casualties.";
		if (casulties > 0) {
			attack_message = $"{target_name} ranks ";
			if (ra = 1) then attack_message += "are struck with gun-barrels and fists.";
			if (ra = 2) then attack_message += "are savaged by your marines in hand-to-hand combat.";
			if (ra = 3) then attack_message += "are smashed by your marines.";
			if (ra = 4) then attack_message += "are struck by your marines in melee.";
			attack_message += $" {casulties} killed."
		}

	} else if (weapon_name = "Force Staff") {
		flavoured = true;
		if (number_of_shots = 1) then attack_message = $"{target_name} is blasted by the {weapon_name}.";
		if (number_of_shots > 1) then attack_message = $"{number_of_shots} {weapon_name} crackle and swing into the {target_name} ranks, killing {casulties}.";

	} else if (weapon_data.has_tag("plasma")) {
		flavoured = true;
		if (target.dudes_num[targeh] = 1) and (casulties = 0) then attack_message = $"{number_of_shots} {weapon_name} shoot bolts of energy into a {target_name}, failing to kill it.";
		if (target.dudes_num[targeh] = 1) and (casulties = 1) then attack_message = $"{number_of_shots} {weapon_name} overwhelm a {target_name} with bolts of energy, killing {casulties}.";
		if (target.dudes_num[targeh] > 1) and (casulties = 0) then attack_message = $"{number_of_shots} {weapon_name} shoot bolts of energy into the {target_name} ranks, failing to kill any.";
		if (target.dudes_num[targeh] > 1) and (casulties > 0) then attack_message = $"{number_of_shots} {weapon_name} shoot bolts of energy into the {target_name}, cleansing {casulties}.";

	} else if (weapon_data.has_tag("flame")) {
		flavoured = true;
		if (target.dudes_num[targeh] = 1) and (casulties = 0) then attack_message = $"{number_of_shots} {weapon_name} bathe the {target_name} in holy promethium, failing to kill it.";
		if (target.dudes_num[targeh] = 1) and (casulties = 1) then attack_message = $"{number_of_shots} {weapon_name} flash-fry the {target_name} inside its armour, inflicting {casulties}.";
		if (target.dudes_num[targeh] > 1) and (casulties = 0) then attack_message = $"{number_of_shots} {weapon_name} wash over the {target_name} ranks, failing to kill any.";
		if (target.dudes_num[targeh] > 1) and (casulties > 0) then attack_message = $"{number_of_shots} {weapon_name} bathe the {target_name} ranks in holy promethium, cleansing {casulties}.";

	} else if (weapon_name = "Webber") {
		flavoured = true;
		if ((target_name = "Termagaunt") or (target_name = "Hormagaunt")) and (casulties > 0) then obj_ncombat.captured_gaunt += casulties;
		if (target.dudes_num[targeh] = 1) and (casulties = 0) then attack_message = $"{number_of_shots} {weapon_name} spray ooze on the {target_name} but fail to immobilize it.";
		if (target.dudes_num[targeh] = 1) and (casulties = 1) then attack_message = $"{number_of_shots} {weapon_name} spray ooze on the {target_name} and fully immobilize it.";
		if (target.dudes_num[targeh] > 1) and (casulties = 0) then attack_message = $"{number_of_shots} {weapon_name} spray ooze on the {target_name} ranks, failing to immobilize any.";
		if (target.dudes_num[targeh] > 1) and (casulties > 0) then attack_message = $"{number_of_shots} {weapon_name} spray ooze on the {target_name} ranks and immobilize {casulties} of them.";

	} else if (weapon_name = "Close Combat Weapon") {
		flavoured = true;
		if (number_of_shots = 1) and (casulties = 0) then attack_message = $"{target_name} is struck by " + string(obj_ini.role[100][6]) + " but survives.";
		if (number_of_shots = 1) and (casulties = 1) then attack_message = $"{target_name} is struck down by " + string(obj_ini.role[100][6]) + ".";
		if (number_of_shots > 1) and (casulties = 0) then attack_message = $"{number_of_shots} {string(obj_ini.role[100][6])}s wrench and smash at {target_name} but fail to destroy it.";
		if (number_of_shots > 1) and (casulties > 1) then attack_message = $"{number_of_shots} {string(obj_ini.role[100][6])}s stomp, wrench, and smash {casulties} {target_name} into paste.";

	} else if (weapon_name = "Chainsword") {
		flavoured = true;
		if (number_of_shots = 1) and (casulties = 0) then attack_message = $"{target_name} is struck by a {weapon_name} but survives.";
		if (number_of_shots = 1) and (casulties = 1) then attack_message = $"{target_name} is cut down by a {weapon_name}.";
		if (number_of_shots > 1) and (casulties = 0) then attack_message = $"{number_of_shots} motors rev and hack at the {target_name} ranks, but don't kill any.";
		if (number_of_shots > 1) and (casulties > 0) then attack_message = $"{number_of_shots} motors rev and hack away at the {target_name} ranks. {casulties} are cut down.";

	} else if (weapon_name = "Sarissa") {
		flavoured = true;
		if (number_of_shots = 1) and (casulties = 0) then attack_message = $"A {target_name} is struck by a Battle Sister's {weapon_name} but survives.";
		if (number_of_shots = 1) and (casulties = 1) then attack_message = $"A {target_name} is struck down by a Battle Sister's {weapon_name}.";
		if (number_of_shots > 1) and (casulties = 0) then attack_message = $"Battle Sisters " + choose("howl out", "roar") + $" and hack at {target_name} ranks with their {weapon_name}s, but they survive.";
		if (number_of_shots > 1) and (casulties > 0) then attack_message = $"{number_of_shots} Battle Sisters " + choose("howl out", "roar") + $" as they hack away at the {target_name} ranks, killing {casulties} with their {weapon_name}s.";

	} else if (weapon_name = "Eviscerator") {
		flavoured = true;
		if (number_of_shots = 1) and (casulties = 0) then attack_message = $"A {target_name} is struck by a {weapon_name} but survives.";
		if (number_of_shots = 1) and (casulties = 1) then attack_message = $"A {target_name} is cut down by a {weapon_name}.";
		if (number_of_shots > 1) and (casulties = 0) then attack_message = $"{number_of_shots} {weapon_name} rev and howl, hacking at the {target_name} ranks, failing to kill any.";
		if (number_of_shots > 1) and (casulties > 0) then attack_message = $"{number_of_shots} {weapon_name} rev and howl, hacking at the {target_name} ranks, {casulties} are cut down.";

	} else if (weapon_name = "Dozer Blades") {
		flavoured = true;
		if (number_of_shots = 1) and (casulties = 0) then attack_message = $"A {target_name} is rammed but survives.";
		if (number_of_shots = 1) and (casulties = 1) then attack_message = $"A {target_name} is splattered by {weapon_name}.";
		if (number_of_shots > 1) and (casulties = 0) then attack_message = $"{weapon_name} ploughs {target_name} ranks , inflicting {casulties}.";
		if (number_of_shots > 1) and (casulties > 0) then attack_message = $"{weapon_name} hits {target_name} ranks , inflicting {casulties}.  " + string(casulties) + " are smashed.";

	} else if (weapon_data.has_tag("power")) {
		flavoured = true;
		if (target.dudes_num[targeh] = 1) {
			if (number_of_shots = 1) and (casulties = 0) then attack_message = $"A {target_name} is struck by a {weapon_name} but survives.";
			if (number_of_shots = 1) and (casulties = 1) then attack_message = $"A {target_name} is struck down by a {weapon_name}.";

			if (number_of_shots > 1) and (casulties = 0) then attack_message = $"A {target_name} is struck by {number_of_shots} {weapon_name}s but survives.";
			if (number_of_shots > 1) and (casulties = 1) then attack_message = $"A {target_name} is struck down by {number_of_shots} {weapon_name}s.";
		}
		if (target.dudes_num[targeh] > 1) {
			if (number_of_shots > 1) and (casulties = 0) then attack_message = $"{number_of_shots} {weapon_name}s crackle and spark, striking at the {target_name} ranks, inflicting no damage.";
			if (number_of_shots > 1) and (casulties > 0) then attack_message = $"{number_of_shots} {weapon_name}s crackle and spark, hewing through the {target_name} ranks, {casulties} are cut down.";
		}
	}

	// A fallback flavour
	if (flavoured == false) {
		flavoured = true;
		if (!character_shot) {
			if (target.dudes_num[targeh] == 1) {
				if (number_of_shots == 1 && casulties == 0) {
					attack_message = $"A {target_name} is struck by {weapon_name} but survives.";
				} else if (number_of_shots == 1 && casulties == 1) {
					attack_message = $"A {target_name} is struck down by {weapon_name}.";
				} else if (number_of_shots > 1 && casulties == 0) {
					attack_message = $"A {target_name} is struck by {number_of_shots} {weapon_name}s but survives.";
				} else if (number_of_shots > 1 && casulties == 1) {
					attack_message = $"A {target_name} is struck down by {number_of_shots} {weapon_name}s.";
				}
			} else {
				if (number_of_shots == 1 && casulties == 0) {
					attack_message = $"{weapon_name} strikes at {target_name} but they survive.";
				} else if (number_of_shots == 1 && casulties > 0) {
					attack_message = $"{weapon_name} strikes at {target_name} and kills {casulties}";
				} else if (number_of_shots > 1 && casulties == 0) {
					attack_message = $"{number_of_shots} {weapon_name}s strike at the {target_name} ranks, but fail to inflict damage.";
				} else if (number_of_shots > 1 && casulties > 0) {
					attack_message = $"{number_of_shots} {weapon_name}s strike at the {target_name} ranks, killing {casulties}.";
				}
			}
		} else {
			if (target.dudes_num[targeh] == 1) {
				if (casulties == 0) {
					attack_message = $"{string(unit_name)} {weapon_name} strikes at a {target_name} but fails to kill it.";
				} else {
					attack_message = $"{string(unit_name)} {weapon_name} strikes at a {target_name}, killing it.";
				}
			} else {
				if (casulties == 0) {
					attack_message = $"{string(unit_name)} {weapon_name} strikes at the {target_name} ranks, failing to kill any.";
				} else {
					attack_message = $"{string(unit_name)} {weapon_name} strikes at the {target_name} ranks and kills {casulties}.";
				}
			}
		}
	}

	var message_priority = 0;
	if (obj_ncombat.enemy <= 10) {
		if (target_name = obj_controller.faction_leader[obj_ncombat.enemy]) { // Cleaning up the message for the enemy leader
			leader_message = string_replace(leader_message, "a " + target_name, target_name);
			leader_message = string_replace(leader_message, "the " + target_name, target_name);
			leader_message = string_replace(leader_message, target_name + " ranks , inflicting {casulties}", target_name);
			if (enemy = 5) then leader_message = string_replace(leader_message, "it", "her");
			if (enemy = 6) and (obj_controller.faction_gender[6] = 1) then leader_message = string_replace(leader_message, "it", "him");
			if (enemy = 6) and (obj_controller.faction_gender[6] = 2) then leader_message = string_replace(leader_message, "it", "her");
			if (enemy != 6) and (enemy != 5) then leader_message = string_replace(leader_message, "it", "him");
			message_priority = 5;
		}
	}

	var message_size = 0;
	if (defenses == 1) {
		message_size = 999;
	} else if (casulties == 0) {
		message_size = number_of_shots / 10;
	} else {
		if (target.dudes_vehicle[targeh] == 1) {
			message_size = casulties * 10;
		}
		else {
			message_size = casulties;
		}
	}

	if (attack_message != "") {
		add_battle_log_message(attack_message, message_size, message_priority);
		display_battle_log_message();
	}

	if (leader_message != "") {
		add_battle_log_message(leader_message, message_size, message_priority);
		display_battle_log_message();
	}

}