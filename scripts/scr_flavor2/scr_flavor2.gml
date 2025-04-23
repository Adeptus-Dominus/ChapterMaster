function scr_flavor2(lost_units_count, target_type, hostile_range, hostile_weapon, hostile_shots, hostile_splash) {
	// Generates flavor based on the damage and casualties from scr_shoot, only for the opponent

	if (obj_ncombat.wall_destroyed = 1) then exit;

	var m1, m2, m3, mes;
	m1 = "";
	m2 = "";
	m3 = "";

	var _hostile_range, _hostile_weapon, _hostile_shots;
	_hostile_range = 0;
	_hostile_weapon = "";
	_hostile_shots = 0;

	if (target_type != "wall") {
		_hostile_range = hostile_range;
		_hostile_weapon = hostile_weapon;
		_hostile_shots = hostile_shots;
	} else if (target_type = "wall") and(instance_exists(obj_nfort)) {
		var hehh;
		hehh = "the fortification";

		_hostile_range = 999;
		_hostile_weapon = obj_nfort.hostile_weapons;
		_hostile_shots = obj_nfort.hostile_shots;
	}

	if (_hostile_weapon = "Fleshborer") then _hostile_shots = _hostile_shots * 10;
	if (hostile_splash = 1) then _hostile_shots = max(1, round(_hostile_shots / 3));

	// show_message(string(hostile_weapon)+"|"+string(_hostile_weapon)+"#"+string(los)+"#"+string(los_num));

	var flavor = 0;

	/*
	if (lost_units_count="Venom Claws"){atta=200;arp=0;rang=1;spli=0;if (obj_ini.preomnor=1){atta=240;}}
	if (lost_units_count="Web Spinner"){atta=40;arp=0;rang=2.1;spli=1;amm=1;}
	if (lost_units_count="Warpsword"){atta=300;arp=200;rang=1;spli=1;}
	if (lost_units_count="Iron Claw"){atta=300;arp=400;rang=1;spli=0;}
	if (lost_units_count="Maulerfiend Claws"){atta=300;arp=300;rang=1;spli=1;}

	if (lost_units_count="Eldritch Fire"){atta=80;arp=40;rang=5.1;}
	if (lost_units_count="Khorne Demon Melee"){atta=350;arp=400;rang=1;spli=1;}
	if (lost_units_count="Demon Melee"){atta=250;arp=300;rang=1;spli=1;}
	if (lost_units_count="Lash Whip"){atta=80;arp=0;rang=2;}
	*/

	if (_hostile_weapon = "Daemonette Melee") {
		flavor = 1;
		if (_hostile_shots > 1) then m1 = string(_hostile_shots) + " Daemonettes rake and claw at " + string(target_type) + ".  ";
		if (_hostile_shots = 1) then m1 = "A Daemonette rakes and claws at " + string(target_type) + ".  ";
	}
	if (_hostile_weapon = "Plaguebearer Melee") {
		flavor = 1;
		if (_hostile_shots > 1) then m1 = string(_hostile_shots) + " Plague Swords slash into " + string(target_type) + ".  ";
		if (_hostile_shots = 1) then m1 = "A Plaguesword is swung into " + string(target_type) + ".  ";
	}
	if (_hostile_weapon = "Bloodletter Melee") {
		flavor = 1;
		if (_hostile_shots > 1) then m1 = string(_hostile_shots) + " Hellblades hiss and slash into " + string(target_type) + ".  ";
		if (_hostile_shots = 1) then m1 = "A Bloodletter swings a Hellblade into " + string(target_type) + ".  ";
	}
	if (_hostile_weapon = "Nurgle Vomit") {
		flavor = 1;
		if (_hostile_shots > 1) then m1 = string(_hostile_shots) + " putrid, corrosive streams of Daemonic vomit spew into " + string(target_type) + ".  ";
		if (_hostile_shots = 1) then m1 = "A putrid, corrosive stream of Daemonic vomit spews into " + string(target_type) + ".  ";
	}
	if (_hostile_weapon = "Maulerfiend Claws") {
		flavor = 1;
		if (_hostile_shots > 1) then m1 = string(_hostile_shots) + " Maulerfiends advance, wrenching and smashing their claws into " + string(target_type) + ".  ";
		if (_hostile_shots = 1) then m1 = "A Maulerfiend advances, wrenching and smashing its claws into " + string(target_type) + ".  ";
	}

	if (hostile_range > 1) {
		if (_hostile_weapon = "Big Shoota") {
			m1 = string(_hostile_shots) + " " + string(_hostile_weapon) + "z roar and blast away at " + string(target_type) + ".  ";
			flavor = 1;
		}
		if (_hostile_weapon = "Dakkagun") {
			m1 = string(_hostile_shots) + " " + string(_hostile_weapon) + "z scream and rattle, blasting into " + string(target_type) + ".  ";
			flavor = 1;
		}
		if (_hostile_weapon = "Deffgun") {
			m1 = string(_hostile_shots) + " " + string(_hostile_weapon) + "z scream and rattle, blasting into " + string(target_type) + ".  ";
			flavor = 1;
		}
		if (_hostile_weapon = "Snazzgun") {
			m1 = string(_hostile_shots) + " " + string(_hostile_weapon) + "z scream and rattle, blasting into " + string(target_type) + ".  ";
			flavor = 1;
		}
		if (_hostile_weapon = "Grot Blasta") {
			m1 = "The Gretchin fire their shoddy weapons and club at your " + string(target_type) + ".  ";
			flavor = 1;
		}
		if (_hostile_weapon = "Kannon") {
			flavor = 1;
			if (_hostile_shots > 1) then m1 = string(_hostile_shots) + " " + string(_hostile_weapon) + "z belch out large caliber shells.  ";
			if (_hostile_shots = 1) then m1 = "A " + string(_hostile_weapon) + "z belches out a large caliber shell.  ";
		}
		if (_hostile_weapon = "Shoota") {
			flavor = 1;
			var ranz;
			ranz = choose(1, 2, 3, 4);
			if (ranz = 1) then m1 = string(_hostile_shots) + " " + string(_hostile_weapon) + "z fire away at " + string(target_type) + ".  ";
			if (ranz = 2) then m1 = string(_hostile_shots) + " " + string(_hostile_weapon) + "z spit lead at " + string(target_type) + ".  ";
			if (ranz = 3) then m1 = string(_hostile_shots) + " " + string(_hostile_weapon) + "z blast at " + string(target_type) + ".  ";
			if (ranz = 4) then m1 = string(_hostile_shots) + " " + string(_hostile_weapon) + "z roar and fire at " + string(target_type) + ".  ";
		}
		if (_hostile_weapon = "Burna") {
			m1 = string(_hostile_shots) + " " + string(_hostile_weapon) + "z spray napalm into " + string(target_type) + ".  ";
			flavor = 1;
		}
		if (_hostile_weapon = "Skorcha") {
			m1 = string(_hostile_shots) + " " + string(_hostile_weapon) + "z spray huge gouts of napalm into " + string(target_type) + ".  ";
			flavor = 1;
		}
		if (_hostile_weapon = "Rokkit Launcha") {
			flavor = 1;
			var ranz;
			ranz = choose(1, 2, 2, 3, 3);
			if (ranz = 1) then m1 = string(_hostile_shots) + " rokkitz shoot at " + string(target_type) + ", the explosions disrupting.  ";
			if (ranz = 2) then m1 = string(_hostile_shots) + " rokkitz scream upward and then fall upon " + string(target_type) + ".  ";
			if (ranz = 3) then m1 = string(_hostile_shots) + " " + string(_hostile_weapon) + "z roar and fire their payloads.  ";
		}

		if (_hostile_weapon = "Staff of Light Shooting") and(_hostile_shots = 1) {
			m1 = "A Staff of Light crackles with energy and fires upon " + string(target_type) + ".  ";
			flavor = 1;
		}
		if (_hostile_weapon = "Staff of Light Shooting") and(_hostile_shots > 1) {
			m1 = string(_hostile_shots) + " Staves of Light crackle with energy and fire upon " + string(target_type) + ".  ";
			flavor = 1;
		}
		if (_hostile_weapon = "Gauss Flayer") or(_hostile_weapon = "Gauss Blaster") or(_hostile_weapon = "Gauss Flayer Array") {
			flavor = 1;
			var ranz;
			ranz = choose(1, 2, 3, 4);
			if (ranz = 1) then m1 = string(_hostile_shots) + " " + string(_hostile_weapon) + "s shoot at " + string(target_type) + ".  ";
			if (ranz = 2) then m1 = string(_hostile_shots) + " " + string(_hostile_weapon) + "s crackle and fire at " + string(target_type) + ".  ";
			if (ranz = 3) then m1 = string(_hostile_shots) + " " + string(_hostile_weapon) + "s discharge upon " + string(target_type) + ".  ";
			if (ranz = 4) then m1 = string(_hostile_shots) + " " + string(_hostile_weapon) + "s spew green energy at " + string(target_type) + ".  ";
		}
		if (_hostile_weapon = "Gauss Cannon") or(_hostile_weapon = "Overcharged Gauss Cannon") or(_hostile_weapon = "Gauss Flux Arc") {
			flavor = 1;
			var ranz;
			ranz = choose(1, 2, 3);
			if (ranz = 1) then m1 = string(_hostile_shots) + " " + string(_hostile_weapon) + "s charge and then blast at " + string(target_type) + ".  ";
			if (ranz = 2) then m1 = string(_hostile_shots) + " " + string(_hostile_weapon) + "s crackle with a sick amount of energy before firing at " + string(target_type) + ".  ";
			if (ranz = 3) then m1 = string(_hostile_shots) + " " + string(_hostile_weapon) + "s pulse with energy and then discharge upon " + string(target_type) + ".  ";
		}
		if (_hostile_weapon = "Gauss Particle Cannon") {
			flavor = 1;
			m1 = string(_hostile_shots) + " " + string(_hostile_weapon) + "s shine a sick green, pulsing with energy, and then blast solid beams of energy into " + string(target_type) + ".  ";
		}
		if (_hostile_weapon = "Particle Whip") {
			flavor = 1;
			if (_hostile_shots = 1) then m1 = "The apex of the Monolith pulses with energy.  An instant layer it fires, the solid beam of energy crashing into " + string(target_type) + ".  ";
			if (_hostile_shots > 1) then m1 = "The apex of " + string(_hostile_shots) + " Monoliths pulse with energy.  An instant later they fire, the solid beams of energy crashing into " + string(target_type) + ".  ";
		}
		if (_hostile_weapon = "Doomsday Cannon") {
			flavor = 1;
			if (_hostile_shots = 1) then m1 = "A Doomsday Arc crackles with energy and then fires.  The resulting blast is blinding in intensity, the ground shaking before its might.  ";
			if (_hostile_shots > 1) then m1 = string(_hostile_shots) + " Doomsday Arcs crackle with energy and then fire.  The resulting blasts are blinding in intensity, the ground shaking.  ";
		}

		if (_hostile_weapon = "Eldritch Fire") {
			flavor = 1;
			if (_hostile_shots = 1) then m1 = "A Pink Horror spits out a globlet of bright energy.  The bolt smashes into " + string(target_type) + ".  ";
			if (_hostile_shots > 1) then m1 = string(_hostile_shots) + " Pink Horrors spit and throw bolts of warp energy into " + string(target_type) + ".  ";
		}
	}

	if (_hostile_shots > 0) {
		if (_hostile_weapon = "Choppa") {
			m1 = string(_hostile_shots) + " " + string(_hostile_weapon) + "z cleave into " + string(target_type) + ".  ";
			flavor = 1;
		}
		if (_hostile_weapon = "Power Klaw") {
			m1 = string(_hostile_shots) + " " + string(_hostile_weapon) + "z rip and tear at " + string(target_type) + ".  ";
			flavor = 1;
		}
		if (_hostile_weapon = "Venom Claws") {
			if (_hostile_shots > 1) then m1 = string(_hostile_shots) + " " + string(_hostile_weapon) + " rake at " + string(target_type) + ".  ";
			flavor = 1;
			if (_hostile_shots = 1) then m1 = "The Spyrer rakes at " + string(target_type) + " with his " + string(_hostile_weapon) + ".  ";
			flavor = 1;
		}
		if (_hostile_weapon = "Slugga") {
			flavor = 1;
			var ranz;
			ranz = choose(1, 2, 3, 4);
			if (ranz = 1) then m1 = string(_hostile_shots) + " " + string(_hostile_weapon) + "z fire away at " + string(target_type) + ".  ";
			if (ranz = 2) then m1 = string(_hostile_shots) + " " + string(_hostile_weapon) + "z spit lead at " + string(target_type) + ".  ";
			if (ranz = 3) then m1 = string(_hostile_shots) + " " + string(_hostile_weapon) + "z blast at " + string(target_type) + ".  ";
			if (ranz = 4) then m1 = string(_hostile_shots) + " " + string(_hostile_weapon) + "z roar and fire at " + string(target_type) + ".  ";
		}
		if (_hostile_weapon = "Tankbusta Bomb") {
			flavor = 1;
			var ranz;
			ranz = choose(1, 2, 3);
			if (ranz = 1) then m1 = string(_hostile_shots) + " " + string(_hostile_weapon) + "z are attached to " + string(target_type) + ".  ";
			if (ranz = 2) then m1 = string(_hostile_shots) + " " + string(_hostile_weapon) + "z are clamped onto " + string(target_type) + ".  ";
			if (ranz = 3) then m1 = string(_hostile_shots) + " " + string(_hostile_weapon) + "z are flung into " + string(target_type) + ".  ";
		}
		if (_hostile_weapon = "Melee1") and(enemy = 7) {
			flavor = 1;
			var ranz;
			ranz = choose(1, 2, 3);
			if (ranz = 1) then m1 = string(_hostile_shots) + " Orks club and smash at " + string(target_type) + ".  ";
			if (ranz = 2) then m1 = string(_hostile_shots) + " Orks shoot their Slugas and smash gunbarrels into " + string(target_type) + ".  ";
			if (ranz = 3) then m1 = string(_hostile_shots) + " Orks claw and punch at " + string(target_type) + ".  ";
		}

		if (_hostile_weapon = "Staff of Light") {
			flavor = 1;
			if (_hostile_shots = 1) {
				var ranz;
				ranz = choose(1, 2, 3);
				if (ranz = 1) then m1 = "A " + string(_hostile_weapon) + " crackles and is swung into " + string(target_type) + ".  ";
				if (ranz = 2) then m1 = "A " + string(_hostile_weapon) + " pulses and smashes through " + string(target_type) + ".  ";
				if (ranz = 3) then m1 = "A " + string(_hostile_weapon) + " crackles and smashes into " + string(target_type) + ".  ";
			}
			if (_hostile_shots > 1) {
				var ranz;
				ranz = choose(1, 2, 3);
				if (ranz = 1) then m1 = string(_hostile_shots) + " Staves of Light strike at " + string(target_type) + ".  ";
				if (ranz = 2) then m1 = string(_hostile_shots) + " Staves of Light smash at " + string(target_type) + ".  ";
				if (ranz = 3) then m1 = string(_hostile_shots) + " Staves of Light swing into " + string(target_type) + ".  ";
			}
		}
		if (_hostile_weapon = "Warscythe") {
			flavor = 1;
			var ranz;
			ranz = choose(1, 2, 3);
			if (ranz = 1) then m1 = string(_hostile_shots) + " Warscythes strike at " + string(target_type) + ".  ";
			if (ranz = 2) then m1 = string(_hostile_shots) + " Warscythes of Light slice into " + string(target_type) + ".  ";
			if (ranz = 3) then m1 = string(_hostile_shots) + " Warscythes of Light hew " + string(target_type) + ".  ";
		}
		if (_hostile_weapon = "Claws") {
			flavor = 1;
			if (_hostile_shots = 1) {
				var ranz;
				ranz = choose(1, 2, 3);
				if (ranz = 1) then m1 = "A massive claw slices through " + string(target_type) + ".  ";
				if (ranz = 2) then m1 = "A razor-sharp claw slashes into " + string(target_type) + ".  ";
				if (ranz = 3) then m1 = "A large necron claw strikes at " + string(target_type) + ".  ";
			}
			if (_hostile_shots > 1) {
				var ranz;
				ranz = choose(1, 2, 3);
				if (ranz = 1) then m1 = string(_hostile_shots) + " massive claws strike and slice at " + string(target_type) + ".  ";
				if (ranz = 2) then m1 = string(_hostile_shots) + " razor-sharp claws assault " + string(target_type) + ".  ";
				if (ranz = 3) then m1 = string(_hostile_shots) + " large necron claws strike at and shred " + string(target_type) + ".  ";
			}
		}
	}

	if (flavor == 0) {
		flavor = true;
		if (_hostile_shots == 1) {
			if (lost_units_count == 0) {
				m1 += $"{_hostile_weapon} strikes at {target_type}, but fails to inflict any damage.";
			} else {
				m1 += $"{_hostile_weapon} strikes at {target_type}. ";
			}
		} else {
			if (lost_units_count == 0) {
				m1 += $"{_hostile_shots} {_hostile_weapon}s strike at {target_type}, but fail to inflict any damage.";
			} else {
				m1 += $"{_hostile_shots} {_hostile_weapon}s strike at {target_type}. ";
			}
		}
	}

	// show_message(mes);

	// m2="Blah blah blah";

	if (target_type = "wall") {
		var _wall_destroyed = obj_nfort.hp[1] <= 0 ? true : false;

		if (_wall_destroyed) {
			mes = m1 + " Destroying the fortifications.";
		} else {
			mes = m1 + " Fortifications stand strong.";
		}

		if (string_length(mes) > 3) {
			obj_ncombat.messages += 1;
			obj_ncombat.message[obj_ncombat.messages] = mes;
			obj_ncombat.message_sz[obj_ncombat.messages] = 999;
			obj_ncombat.message_priority[obj_ncombat.messages] = 0;
			obj_ncombat.alarm[3] = 2;
		}
		if (obj_nfort.hp[1] <= 0) {
			s = 0;
			him = 0;
			obj_ncombat.dead_jims += 1;
			obj_ncombat.dead_jim[obj_ncombat.dead_jims] = "The fortified wall has been breached!";
			obj_ncombat.wall_destroyed = 1;
			with(obj_nfort) {
				instance_destroy();
			}
		}
		exit;
	}

	var marine_length = array_length(marine_type);
	var s, him, special, unit, unit_role, units_lost, plural;
    var lost_roles_count = array_length(lost);
    for (var role_index = 0; role_index < lost_roles_count; role_index++) {
        unit_role = lost[role_index];
        units_lost = lost_num[role_index];
        if (unit_role != "" && units_lost > 0) {
            special = (
                is_specialist(unit_role, SPECIALISTS_HEADS) ||
                unit_role == obj_ini.role[100][eROLE.ChapterMaster] ||
                unit_role == "Venerable " + string(obj_ini.role[100][eROLE.Dreadnought]) ||
                unit_role == obj_ini.role[100][eROLE.Captain] ||
                obj_ncombat.player_max <= 6
            );

            if (!special) {
                plural = units_lost > 1 ? "s" : "";
                m2 += $"{units_lost} {unit_role}{plural}, ";
            } else {
                him = -1; // Find which unit this is
                for (var marine = 0; marine < marine_length; marine++) {
                    if (marine_type[marine] == unit_role && marine_hp[marine] <= 0) {
                        him = marine;
                        break; // found the unit
                    }
                }

                if (him != -1) { // found a valid unit
                    obj_ncombat.dead_jims += 1;
                    if (marine_type[him] == obj_ini.role[100][5]) {
                        obj_ncombat.dead_jim[obj_ncombat.dead_jims] = $"A {marine_type[him]} has been critically injured!";
                    } else {
                        obj_ncombat.dead_jim[obj_ncombat.dead_jims] = $"{unit_struct[him].name_role()} has been critically injured!";
                    }
                }
            }
        }
    }


	var unce = 0;

	if (string_count(", ", m2) > 1) {

		// show_message(m2);

		var lis, y1, y2;
		lis = string_rpos(", ", m2);
		m2 = string_delete(m2, lis, 3); // This clears the last ', ' and replaces it with the end statement
		if (lost_units_count > 0) then m2 += " critically damaged.";

		// show_message(m2);

		lis = string_rpos(", ", m2); // Find the new last ', ' and replace it with the and part
		m2 = string_delete(m2, lis, 2);

		// show_message(m2);

		if (string_count(",", m2) > 1) then m2 = string_insert(", and ", m2, lis);
		if (string_count(",", m2) = 0) then m2 = string_insert(" and ", m2, lis);

		// show_message(m2);

		unce = 1;
	}

	if (string_count(", ", m2) = 1) and(unce = 0) and(hostile_weapon != "Web Spinner") {
		var lis, y1, y2;
		lis = string_rpos(", ", m2);
		m2 = string_delete(m2, lis, 3);
		if (lost_units_count > 0) then m2 += " critically damaged.";
	}
	if (string_count(", ", m2) = 1) and(unce = 0) and(hostile_weapon = "Web Spinner") {
		var lis, y1, y2;
		lis = string_rpos(", ", m2);
		m2 = string_delete(m2, lis, 3);
		if (lost_units_count > 1) then m2 += " have been incapacitated.";
		if (lost_units_count = 1) then m2 += " has been incapacitated.";
	}

	mes = m1 + m2 + m3;
	// show_message(mes);

	if (string_length(mes) > 3) {
		obj_ncombat.messages += 1;
		obj_ncombat.message[obj_ncombat.messages] = mes;
		obj_ncombat.message_sz[obj_ncombat.messages] = lost_units_count + (0.5 - (obj_ncombat.messages / 100));
		obj_ncombat.message_priority[obj_ncombat.messages] = 0;
		obj_ncombat.alarm[3] = 2;
	}

}