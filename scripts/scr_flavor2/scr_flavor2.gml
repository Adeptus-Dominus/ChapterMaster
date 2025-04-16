function scr_flavor2(lost_units_count, target_type, hostile_range, hostile_weapon, hostile_shots) {
	// Generates flavor based on the damage and casualties from scr_shoot, only for the opponent

	if (obj_ncombat.wall_destroyed = 1) then exit;

	var _attack_text, _loss_text, _message;
	_message = $"INVALID! lost_units_count:{lost_units_count} target_type:{target_type} hostile_range:{hostile_range} hostile_weapon:{hostile_weapon} hostile_shots:{hostile_shots}";
	_attack_text = "";
	_loss_text = "";

	var _hostile_weapon, _hostile_shots;
	_hostile_weapon = "";
	_hostile_shots = 0;

	if (target_type != "wall") {
		_hostile_weapon = hostile_weapon;
		_hostile_shots = hostile_shots;
	} else if (target_type = "wall") and(instance_exists(obj_nfort)) {
		var hehh;
		hehh = "the fortification";

		_hostile_weapon = obj_nfort.hostile_weapons;
		_hostile_shots = obj_nfort.hostile_shots;
	}

	if (_hostile_weapon = "Fleshborer") then _hostile_shots = _hostile_shots * 10;

	// show_message(string(hostile_weapon)+"|"+string(_hostile_weapon)+"#"+string(los)+"#"+string(los_num));

	var flavor = 0;

	if (_hostile_weapon = "Daemonette Melee") {
		flavor = 1;
		if (_hostile_shots > 1) then _attack_text = string(_hostile_shots) + " Daemonettes rake and claw at " + string(target_type) + ".  ";
		if (_hostile_shots = 1) then _attack_text = "A Daemonette rakes and claws at " + string(target_type) + ".  ";
	}
	if (_hostile_weapon = "Plaguebearer Melee") {
		flavor = 1;
		if (_hostile_shots > 1) then _attack_text = string(_hostile_shots) + " Plague Swords slash into " + string(target_type) + ".  ";
		if (_hostile_shots = 1) then _attack_text = "A Plaguesword is swung into " + string(target_type) + ".  ";
	}
	if (_hostile_weapon = "Bloodletter Melee") {
		flavor = 1;
		if (_hostile_shots > 1) then _attack_text = string(_hostile_shots) + " Hellblades hiss and slash into " + string(target_type) + ".  ";
		if (_hostile_shots = 1) then _attack_text = "A Bloodletter swings a Hellblade into " + string(target_type) + ".  ";
	}
	if (_hostile_weapon = "Nurgle Vomit") {
		flavor = 1;
		if (_hostile_shots > 1) then _attack_text = string(_hostile_shots) + " putrid, corrosive streams of Daemonic vomit spew into " + string(target_type) + ".  ";
		if (_hostile_shots = 1) then _attack_text = "A putrid, corrosive stream of Daemonic vomit spews into " + string(target_type) + ".  ";
	}
	if (_hostile_weapon = "Maulerfiend Claws") {
		flavor = 1;
		if (_hostile_shots > 1) then _attack_text = string(_hostile_shots) + " Maulerfiends advance, wrenching and smashing their claws into " + string(target_type) + ".  ";
		if (_hostile_shots = 1) then _attack_text = "A Maulerfiend advances, wrenching and smashing its claws into " + string(target_type) + ".  ";
	}

	if (hostile_range == "ranged") {
		if (_hostile_weapon = "Big Shoota") {
			_attack_text = string(_hostile_shots) + " " + string(_hostile_weapon) + "z roar and blast away at " + string(target_type) + ".  ";
			flavor = 1;
		}
		if (_hostile_weapon = "Dakkagun") {
			_attack_text = string(_hostile_shots) + " " + string(_hostile_weapon) + "z scream and rattle, blasting into " + string(target_type) + ".  ";
			flavor = 1;
		}
		if (_hostile_weapon = "Deffgun") {
			_attack_text = string(_hostile_shots) + " " + string(_hostile_weapon) + "z scream and rattle, blasting into " + string(target_type) + ".  ";
			flavor = 1;
		}
		if (_hostile_weapon = "Snazzgun") {
			_attack_text = string(_hostile_shots) + " " + string(_hostile_weapon) + "z scream and rattle, blasting into " + string(target_type) + ".  ";
			flavor = 1;
		}
		if (_hostile_weapon = "Grot Blasta") {
			_attack_text = "The Gretchin fire their shoddy weapons and club at your " + string(target_type) + ".  ";
			flavor = 1;
		}
		if (_hostile_weapon = "Kannon") {
			flavor = 1;
			if (_hostile_shots > 1) then _attack_text = string(_hostile_shots) + " " + string(_hostile_weapon) + "z belch out large caliber shells at " + string(target_type) + ".  ";
			if (_hostile_shots = 1) then _attack_text = "A " + string(_hostile_weapon) + "z belches out a large caliber shell at " + string(target_type) + ".  ";
		}
		if (_hostile_weapon = "Shoota") {
			flavor = 1;
			var ranz;
			ranz = choose(1, 2, 3, 4);
			if (ranz = 1) then _attack_text = string(_hostile_shots) + " " + string(_hostile_weapon) + "z fire away at " + string(target_type) + ".  ";
			if (ranz = 2) then _attack_text = string(_hostile_shots) + " " + string(_hostile_weapon) + "z spit lead at " + string(target_type) + ".  ";
			if (ranz = 3) then _attack_text = string(_hostile_shots) + " " + string(_hostile_weapon) + "z blast at " + string(target_type) + ".  ";
			if (ranz = 4) then _attack_text = string(_hostile_shots) + " " + string(_hostile_weapon) + "z roar and fire at " + string(target_type) + ".  ";
		}
		if (_hostile_weapon = "Burna") {
			_attack_text = string(_hostile_shots) + " " + string(_hostile_weapon) + "z spray napalm into " + string(target_type) + ".  ";
			flavor = 1;
		}
		if (_hostile_weapon = "Skorcha") {
			_attack_text = string(_hostile_shots) + " " + string(_hostile_weapon) + "z spray huge gouts of napalm into " + string(target_type) + ".  ";
			flavor = 1;
		}
		if (_hostile_weapon = "Rokkit Launcha") {
			flavor = 1;
			var ranz;
			ranz = choose(1, 2, 2, 3, 3);
			if (ranz = 1) then _attack_text = string(_hostile_shots) + " rokkitz shoot at " + string(target_type) + ", the explosions disrupting.  ";
			if (ranz = 2) then _attack_text = string(_hostile_shots) + " rokkitz scream upward and then fall upon " + string(target_type) + ".  ";
			if (ranz = 3) then _attack_text = string(_hostile_shots) + " " + string(_hostile_weapon) + "z roar and fire their payloads at " + string(target_type) + ".  ";
		}

		if (_hostile_weapon = "Staff of Light Shooting") and(_hostile_shots = 1) {
			_attack_text = "A Staff of Light crackles with energy and fires upon " + string(target_type) + ".  ";
			flavor = 1;
		}
		if (_hostile_weapon = "Staff of Light Shooting") and(_hostile_shots > 1) {
			_attack_text = string(_hostile_shots) + " Staves of Light crackle with energy and fire upon " + string(target_type) + ".  ";
			flavor = 1;
		}
		if (_hostile_weapon = "Gauss Flayer") or(_hostile_weapon = "Gauss Blaster") or(_hostile_weapon = "Gauss Flayer Array") {
			flavor = 1;
			var ranz;
			ranz = choose(1, 2, 3, 4);
			if (ranz = 1) then _attack_text = string(_hostile_shots) + " " + string(_hostile_weapon) + "s shoot at " + string(target_type) + ".  ";
			if (ranz = 2) then _attack_text = string(_hostile_shots) + " " + string(_hostile_weapon) + "s crackle and fire at " + string(target_type) + ".  ";
			if (ranz = 3) then _attack_text = string(_hostile_shots) + " " + string(_hostile_weapon) + "s discharge upon " + string(target_type) + ".  ";
			if (ranz = 4) then _attack_text = string(_hostile_shots) + " " + string(_hostile_weapon) + "s spew green energy at " + string(target_type) + ".  ";
		}
		if (_hostile_weapon = "Gauss Cannon") or(_hostile_weapon = "Overcharged Gauss Cannon") or(_hostile_weapon = "Gauss Flux Arc") {
			flavor = 1;
			var ranz;
			ranz = choose(1, 2, 3);
			if (ranz = 1) then _attack_text = string(_hostile_shots) + " " + string(_hostile_weapon) + "s charge and then blast at " + string(target_type) + ".  ";
			if (ranz = 2) then _attack_text = string(_hostile_shots) + " " + string(_hostile_weapon) + "s crackle with a sick amount of energy before firing at " + string(target_type) + ".  ";
			if (ranz = 3) then _attack_text = string(_hostile_shots) + " " + string(_hostile_weapon) + "s pulse with energy and then discharge upon " + string(target_type) + ".  ";
		}
		if (_hostile_weapon = "Gauss Particle Cannon") {
			flavor = 1;
			_attack_text = string(_hostile_shots) + " " + string(_hostile_weapon) + "s shine a sick green, pulsing with energy, and then blast solid beams of energy into " + string(target_type) + ".  ";
		}
		if (_hostile_weapon = "Particle Whip") {
			flavor = 1;
			if (_hostile_shots = 1) then _attack_text = "The apex of the Monolith pulses with energy.  An instant layer it fires, the solid beam of energy crashing into " + string(target_type) + ".  ";
			if (_hostile_shots > 1) then _attack_text = "The apex of " + string(_hostile_shots) + " Monoliths pulse with energy.  An instant later they fire, the solid beams of energy crashing into " + string(target_type) + ".  ";
		}
		if (_hostile_weapon = "Doomsday Cannon") {
			flavor = 1;
			if (_hostile_shots = 1) then _attack_text = "A Doomsday Arc crackles with energy and then fires.  The resulting blast is blinding in intensity, the ground shaking before its might.  ";
			if (_hostile_shots > 1) then _attack_text = string(_hostile_shots) + " Doomsday Arcs crackle with energy and then fire.  The resulting blasts are blinding in intensity, the ground shaking.  ";
		}

		if (_hostile_weapon = "Eldritch Fire") {
			flavor = 1;
			if (_hostile_shots = 1) then _attack_text = "A Pink Horror spits out a globlet of bright energy.  The bolt smashes into " + string(target_type) + ".  ";
			if (_hostile_shots > 1) then _attack_text = string(_hostile_shots) + " Pink Horrors spit and throw bolts of warp energy into " + string(target_type) + ".  ";
		}
	}

	if (_hostile_shots > 0) {
		if (_hostile_weapon = "Choppa") {
			_attack_text = string(_hostile_shots) + " " + string(_hostile_weapon) + "z cleave into " + string(target_type) + ".  ";
			flavor = 1;
		}
		if (_hostile_weapon = "Power Klaw") {
			_attack_text = string(_hostile_shots) + " " + string(_hostile_weapon) + "z rip and tear at " + string(target_type) + ".  ";
			flavor = 1;
		}
		if (_hostile_weapon = "Venom Claws") {
			if (_hostile_shots > 1) then _attack_text = string(_hostile_shots) + " " + string(_hostile_weapon) + " rake at " + string(target_type) + ".  ";
			flavor = 1;
			if (_hostile_shots = 1) then _attack_text = "The Spyrer rakes at " + string(target_type) + " with his " + string(_hostile_weapon) + ".  ";
			flavor = 1;
		}
		if (_hostile_weapon = "Slugga") {
			flavor = 1;
			var ranz;
			ranz = choose(1, 2, 3, 4);
			if (ranz = 1) then _attack_text = string(_hostile_shots) + " " + string(_hostile_weapon) + "z fire away at " + string(target_type) + ".  ";
			if (ranz = 2) then _attack_text = string(_hostile_shots) + " " + string(_hostile_weapon) + "z spit lead at " + string(target_type) + ".  ";
			if (ranz = 3) then _attack_text = string(_hostile_shots) + " " + string(_hostile_weapon) + "z blast at " + string(target_type) + ".  ";
			if (ranz = 4) then _attack_text = string(_hostile_shots) + " " + string(_hostile_weapon) + "z roar and fire at " + string(target_type) + ".  ";
		}
		if (_hostile_weapon = "Tankbusta Bomb") {
			flavor = 1;
			var ranz;
			ranz = choose(1, 2, 3);
			if (ranz = 1) then _attack_text = string(_hostile_shots) + " " + string(_hostile_weapon) + "z are attached to " + string(target_type) + ".  ";
			if (ranz = 2) then _attack_text = string(_hostile_shots) + " " + string(_hostile_weapon) + "z are clamped onto " + string(target_type) + ".  ";
			if (ranz = 3) then _attack_text = string(_hostile_shots) + " " + string(_hostile_weapon) + "z are flung into " + string(target_type) + ".  ";
		}
		if (_hostile_weapon = "Melee1") and(enemy = 7) {
			flavor = 1;
			var ranz;
			ranz = choose(1, 2, 3);
			if (ranz = 1) then _attack_text = string(_hostile_shots) + " Orks club and smash at " + string(target_type) + ".  ";
			if (ranz = 2) then _attack_text = string(_hostile_shots) + " Orks shoot their Slugas and smash gunbarrels into " + string(target_type) + ".  ";
			if (ranz = 3) then _attack_text = string(_hostile_shots) + " Orks claw and punch at " + string(target_type) + ".  ";
		}

		if (_hostile_weapon = "Staff of Light") {
			flavor = 1;
			if (_hostile_shots = 1) {
				var ranz;
				ranz = choose(1, 2, 3);
				if (ranz = 1) then _attack_text = "A " + string(_hostile_weapon) + " crackles and is swung into " + string(target_type) + ".  ";
				if (ranz = 2) then _attack_text = "A " + string(_hostile_weapon) + " pulses and smashes through " + string(target_type) + ".  ";
				if (ranz = 3) then _attack_text = "A " + string(_hostile_weapon) + " crackles and smashes into " + string(target_type) + ".  ";
			}
			if (_hostile_shots > 1) {
				var ranz;
				ranz = choose(1, 2, 3);
				if (ranz = 1) then _attack_text = string(_hostile_shots) + " Staves of Light strike at " + string(target_type) + ".  ";
				if (ranz = 2) then _attack_text = string(_hostile_shots) + " Staves of Light smash at " + string(target_type) + ".  ";
				if (ranz = 3) then _attack_text = string(_hostile_shots) + " Staves of Light swing into " + string(target_type) + ".  ";
			}
		}
		if (_hostile_weapon = "Warscythe") {
			flavor = 1;
			var ranz;
			ranz = choose(1, 2, 3);
			if (ranz = 1) then _attack_text = string(_hostile_shots) + " Warscythes strike at " + string(target_type) + ".  ";
			if (ranz = 2) then _attack_text = string(_hostile_shots) + " Warscythes of Light slice into " + string(target_type) + ".  ";
			if (ranz = 3) then _attack_text = string(_hostile_shots) + " Warscythes of Light hew " + string(target_type) + ".  ";
		}
		if (_hostile_weapon = "Claws") {
			flavor = 1;
			if (_hostile_shots = 1) {
				var ranz;
				ranz = choose(1, 2, 3);
				if (ranz = 1) then _attack_text = "A massive claw slices through " + string(target_type) + ".  ";
				if (ranz = 2) then _attack_text = "A razor-sharp claw slashes into " + string(target_type) + ".  ";
				if (ranz = 3) then _attack_text = "A large necron claw strikes at " + string(target_type) + ".  ";
			}
			if (_hostile_shots > 1) {
				var ranz;
				ranz = choose(1, 2, 3);
				if (ranz = 1) then _attack_text = string(_hostile_shots) + " massive claws strike and slice at " + string(target_type) + ".  ";
				if (ranz = 2) then _attack_text = string(_hostile_shots) + " razor-sharp claws assault " + string(target_type) + ".  ";
				if (ranz = 3) then _attack_text = string(_hostile_shots) + " large necron claws strike at and shred " + string(target_type) + ".  ";
			}
		}
	}

	if (flavor == 0) {
		flavor = true;
		if (_hostile_shots == 1) {
			if (lost_units_count == 0) {
				_attack_text += $"{_hostile_weapon} strikes at {target_type}, but fails to inflict any damage.";
			} else {
				_attack_text += $"{_hostile_weapon} strikes at {target_type}. ";
			}
		} else {
			if (lost_units_count == 0) {
				_attack_text += $"{_hostile_shots} {_hostile_weapon}s strike at {target_type}, but fail to inflict any damage.";
			} else {
				_attack_text += $"{_hostile_shots} {_hostile_weapon}s strike at {target_type}. ";
			}
		}
	}

	// show_message(_message);

	// _loss_text="Blah blah blah";

	if (target_type = "wall") {
		var _wall_destroyed = obj_nfort.hp[1] <= 0 ? true : false;

		if (_wall_destroyed) {
			_message = _attack_text + " Destroying the fortifications.";
		} else {
			_message = _attack_text + " Fortifications stand strong.";
		}

		if (string_length(_message) > 3) {
			obj_ncombat.queue_battlelog_message(_message, COL_RED);
		}
		if (obj_nfort.hp[1] <= 0) {
			s = 0;
			him = 0;
			obj_ncombat.queue_battlelog_message("The fortified wall has been breached!", COL_RED);
			obj_ncombat.wall_destroyed = 1;
			with(obj_nfort) {
				instance_destroy();
			}
		}
		exit;
	}

	var unit_role, units_lost;
	var loss_list = " ";

	var _lost_roles = struct_get_names(lost_units);
	for (var i = 0; i < array_length(_lost_roles); i++) {
		unit_role = _lost_roles[i];
		units_lost = lost_units[$ unit_role];

		loss_list += string_plural_count(unit_role, units_lost);
		if (i < array_length(_lost_roles) - 1) {
			loss_list += ", ";
		}
	}

	var _message_color = COL_GREEN;
	if (loss_list != " ") {
		if (hostile_weapon == "Web Spinner") {
			loss_list += (lost_units_count == 1) ? " has been incapacitated." : " have been incapacitated.";
			_message_color = COL_BRIGHT_GREEN;
		} else {
			loss_list += " critically damaged.";
			_message_color = COL_RED;
		}
	}

	_loss_text = loss_list;
	_message = _attack_text + _loss_text;


	// var _message_priority = lost_units_count <= 0 ? hostile_shots / 100 : lost_units_count;
	obj_ncombat.queue_battlelog_message(_message, _message_color);
}
