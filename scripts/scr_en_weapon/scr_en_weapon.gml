/// @mixin
function scr_en_weapon(_weapon_name, _unit_type, _weapon_count, _unit_name) {

	// check if double ranged/melee
	// then add to that weapon

	//scr_infantry_weapon
	// _weapon_name: _weapon_name
	// _unit_type: man?  //Probably used to differenciate internaly between trooper and vehicle weapons
	// _weapon_count: number
	// _unit_name: owner
	// _unit_block: current dudes block

	// Determines combined damage for enemy battle blocks for a single weapon

	var _range = 0;
	var _attack = 0;
	var _shot_count = 0;
	var _piercing = 0;
	var _ammo = -1;
	var _reload = -1;
	var _target_type = 0;
	// faith_bonus = 0;
	// var struct = gear_weapon_data("weapon",_weapon_name);

	/* if (string_count("elee", _weapon_name) > 0) {
		_weapon_name = string_delete(_weapon_name, 0, 5);
		_attack = 10;
		_piercing = 0;
		_range = 1;
		_shot_count = 3;
	}


	if (_weapon_name = "Venom Claws") {
		_attack = 200;
		_piercing = 1;
		_range = 1;
		_shot_count = 0;
		if (obj_ini.preomnor = 1) {
			_attack = 240;
		}
	}
	if (_weapon_name = "Web Spinner") {
		_attack = 40;
		_piercing = 0;
		_range = 2.1;
		_shot_count = 3;
		_ammo = 1;
	}
	if (_weapon_name = "Warpsword") {
		_attack = 300;
		_piercing = 1;
		_range = 1;
		_shot_count = 3;
	}
	if (_weapon_name = "Iron Claw") {
		_attack = 400;
		_piercing = 1;
		_range = 1;
		_shot_count = 0;
	}
	if (_weapon_name = "Maulerfiend Claws") {
		_attack = 300;
		_piercing = 1;
		_range = 1;
		_shot_count = 3;
	}

	if (_weapon_name = "Eldritch Fire") {
		_attack = 80;
		_piercing = 1;
		_range = 5.1;
	}
	if (_weapon_name = "Bloodletter Melee") {
		_attack = 70;
		_piercing = 0;
		_range = 1;
		_shot_count = 3;
	}
	if (_weapon_name = "Daemonette Melee") {
		_attack = 65;
		_piercing = 0;
		_range = 1;
		_shot_count = 3;
	}
	if (_weapon_name = "Plaguebearer Melee") {
		_attack = 60;
		_piercing = 0;
		_range = 1;
		_shot_count = 3;
		if (obj_ini.preomnor = 1) {
			_attack = 70;
		}
	}
	if (_weapon_name = "Khorne Demon Melee") {
		_attack = 350;
		_piercing = 1;
		_range = 1;
		_shot_count = 3;
	}
	if (_weapon_name = "Demon Melee") {
		_attack = 250;
		_piercing = 1;
		_range = 1;
		_shot_count = 3;
	}
	if (_weapon_name = "Lash Whip") {
		_attack = 80;
		_piercing = 0;
		_range = 2;
	}
	if (_weapon_name = "Nurgle Vomit") {
		_attack = 100;
		_piercing = 0;
		_range = 2;
		_shot_count = 3;
		if (obj_ini.preomnor = 1) {
			_attack = 260;
		}
	}
	if (_weapon_name = "Multi-Melta") {
		_attack = 200;
		_piercing = 1;
		_range = 4.1;
		_shot_count = 0;
		_ammo = 6;
	}

	if (obj_ncombat.enemy = 3) {
		if (_weapon_name = "Phased Plasma-fusil") {
			_attack = 80;
			_piercing = 1;
			_range = 7.1;
			_shot_count = 3;
		}
		if (_weapon_name = "Lightning Gun") {
			_attack = choose(80, 80, 80, 150);
			_piercing = 0;
			_range = 5;
			_shot_count = 0;
		}
		if (_weapon_name = "Thallax Melee") {
			_attack = 80;
			_piercing = 0;
			_range = 1;
			_shot_count = 3;
		}
	}

	if (obj_ncombat.enemy = 6) {

		if (_weapon_name = "Fusion Gun"){
			_attack = 180;
			_piercing = 1;
			_range = 2;
			_ammo = 4;
		}

			if (_weapon_name = "Firepike") {
				_attack = 150;
				_piercing = 1;
				_range = 4;
				_ammo = 4;
			}
		if (_weapon_name = "Singing Spear") {
			_attack = 150;
			_piercing = 0;
			_range = 1;
			_shot_count = 3;
		}
		if (_weapon_name = "Singing Spear Throw") {
			_attack = 120;
			_piercing = 0;
			_range = 2;
			_shot_count = 3;
		}
		if (_weapon_name = "Witchblade") {
			_attack = 130;
			_piercing = 0;
			_range = 1;
		}
		if (_weapon_name = "Psyshock") {
			_attack = 50;
			_piercing = 0;
			_range = 2;
		}
		if (_weapon_name = "Wailing Doom") {
			_attack = 200;
			_piercing = 1;
			_range = 1;
			_shot_count = 3;
		}
		if (_weapon_name = "Avatar Smite") {
			_attack = 300;
			_piercing = 1;
			_range = 2;
			_ammo = 2;
		}
		if (_weapon_name = "Ranger Long Rifle") {
			_attack = 60;
			_piercing = 0;
			_range = 25;
		}
		if (_weapon_name = "Pathfinder Long Rifle") {
			_attack = 70;
			_piercing = 0;
			_range = 25;
		}
		if (_weapon_name = "Shuriken Catapult") {
			_attack = 50;
			_piercing = 0;
			_range = 2;
		}
		if (_weapon_name = "Twin Linked Shuriken Catapult") {
			_attack = 100;
			_piercing = 0;
			_range = 2;
		}
		if (_weapon_name = "Avenger Shuriken Catapult") {
			_attack = 90;
			_piercing = 0;
			_range = 3;
		}
		if (_weapon_name = "Power Weapon") or(_weapon_name = "Power Blades") {
			_attack = 100;
			_piercing = 1;
			_range = 1;
			_shot_count = 3;
		}
		if (_weapon_name = "Shuriken Pistol") {
			_attack = 50;
			_piercing = 0;
			_range = 2.1;
		}
		if (_weapon_name = "Executioner") {
			_attack = 150;
			_piercing = 1;
			_range = 1;
		}
		if (_weapon_name = "Scorpion Chainsword") {
			_attack = 100;
			_piercing = 0;
			_range = 1;
			_shot_count = 3;
		}
		if (_weapon_name = "Mandiblaster") {
			_attack = 60;
			_piercing = 0;
			_range = 1;
		}
		if (_weapon_name = "Biting Blade") {
			_attack = 125;
			_piercing = 0;
			_range = 1;
			_shot_count = 3;
		}
		if (_weapon_name = "Scorpian's Claw") {
			_attack = 150;
			_piercing = 1;
			_range = 1;
			_shot_count = 3;
		}
		if (_weapon_name = "Meltabomb") {
			_attack = 200;
			_piercing = 1;
			_range = 1;
			_ammo = 1;
		}
		if (_weapon_name = "Deathspinner") {
			_attack = 125;
			_piercing = 0;
			_range = 2;
		}
		if (_weapon_name = "Dual Deathspinner") {
			_attack = 250;
			_piercing = 0;
			_range = 2;
		}
		if (_weapon_name = "Reaper Launcher") {
			_attack = 120;
			_piercing = 1;
			_range = 20;
			_ammo = 8;
			_shot_count = 3;
		}
		if (_weapon_name = "Tempest Launcher") {
			_attack = 200;
			_piercing = 0;
			_range = 15;
			_ammo = 8;
			_shot_count = 9;
		}
		if (_weapon_name = "Laser Lance") {
			_attack = 180;
			_piercing = 1;
			_range = 2;
			_shot_count = 3;
		}
		if (_weapon_name = "Fusion Pistol") {
			_attack = 125;
			_piercing = 1;
			_range = 2.1;
			_ammo = 4;
		}
		if (_weapon_name = "Plasma Pistol") {
			_attack = 100;
			_piercing = 1;
			_range = 3.1;
		}
		if (_weapon_name = "Harlequin's Kiss") {
			_attack = 250;
			_piercing = 1;
			_range = 1;
			_ammo = 1;
		}
		if (_weapon_name = "Wraithcannon") {
			_attack = 200;
			_piercing = 1;
			_range = 2.1;
		}
		if (_weapon_name = "Pulse Laser") {
			_attack = 120;
			_piercing = 0;
			_range = 15;
		}
		if (_weapon_name = "Bright Lance") {
			_attack = 200;
			_piercing = 1;
			_range = 8;
		}
		if (_weapon_name = "Shuriken Cannon") {
			_attack = 160;
			_piercing = 0;
			_range = 3;
		}
		if (_weapon_name = "Prism Cannon") {
			_attack = 400;
			_piercing = 1;
			_range = 20;
				_shot_count = 1;
		}
		if (_weapon_name = "Twin Linked Doomweaver") {
			_attack = 250;
			_piercing = 1;
			_range = 2;
				_shot_count = 2;
		} // Also create difficult terrain?
		if (_weapon_name = "Starcannon") {
			_attack = 250;
			_piercing = 1;
			_range = 8;
			_shot_count = 4;
		}
		if (_weapon_name = "Two Power Fists") {
			_attack = 300;
			_piercing = 1;
			_range = 1;
				_shot_count = 2;
		}
		if (_weapon_name = "Flamer") {
			_attack = 200;
			_piercing = 0;
			_range = 2;
			_ammo = 4;
			_shot_count = 3;
		}
		if (_weapon_name = "Titan Starcannon") {
			_attack = 500;
			_piercing = 1;
			_range = 4;
			_shot_count = 8;
		}
		if (_weapon_name = "Phantom Pulsar") {
			_attack = 500;
			_piercing = 1;
			_range = 20;
			_shot_count = 3;
		}
	}

	if (obj_ncombat.enemy = 8) {
		if (_weapon_name = "Fusion Blaster") {
			_attack = 150;
			_piercing = 1;
			_range = 2;
			_ammo = 4;
		}
		if (_weapon_name = "Plasma Rifle") {
			_attack = 120;
			_piercing = 1;
			_range = 10;
		}
		if (_weapon_name = "Cyclic Ion Blaster") {
			_attack = 80;
			_piercing = 0;
			_range = 6;
			_shot_count = 3;
		} // x6
		if (_weapon_name = "Burst Rifle") {
			_attack = 130;
			_piercing = 0;
			_range = 16;
			_shot_count = 3;
		}
		if (_weapon_name = "Missile Pod") {
			_attack = 150;
			_piercing = 0;
			_range = 15;
			_ammo = 6;
			_shot_count = 3;
		}
		if (_weapon_name = "Smart Missile System") {
			_attack = 150;
			_piercing = 0;
			_range = 15;
		}
		if (_weapon_name = "Small Railgun") {
			_attack = 150;
			_piercing = 1;
			_range = 18;
				_shot_count = 1;
		}
		if (_weapon_name = "Pulse Rifle") {
			_attack = 80;
			_piercing = 0;
			_range = 12;
		}
		if (_weapon_name = "Rail Rifle") {
			_attack = 80;
			_piercing = 1;
			_range = 14;
		}
		if (_weapon_name = "Kroot Rifle") {
			_attack = 100;
			_piercing = 0;
			_range = 6;
		}
		if (_weapon_name = "Vespid Crystal") {
			_attack = 100;
			_piercing = 1;
			_range = 2.1;
		}
		if (_weapon_name = "Railgun") {
			_attack = 250;
			_piercing = 1;
			_range = 20;
		}
	}

	if (obj_ncombat.enemy = 9) {

		if (_weapon_name = "Bonesword") {
			_attack = 120;
			_piercing = 1;
			_range = 1;
			_shot_count = 3;
		}
		if (_weapon_name = "Lash Whip") {
			_attack = 100;
			_piercing = 0;
			_range = 2;
		}
		if (_weapon_name = "Heavy Venom Cannon") {
			_attack = 200;
			_piercing = 1;
			_range = 8;
		}
		if (_weapon_name = "Crushing Claws") {
			_attack = 150;
			_piercing = 1;
			_range = 1;
			_shot_count = 3;
		}
		if (_weapon_name = "Rending Claws") {
			_attack = 80;
			_piercing = 1;
			_range = 1;
			_shot_count = 3;
		}
		if (_weapon_name = "Devourer") {
			_attack = 90;
			_piercing = 0;
			_range = 5;
				_shot_count = 3
			if (obj_ini.preomnor = 1) {
				_attack = 180;
			}
		}
		if (_weapon_name = "Zoanthrope Blast") {
			_attack = 250;
			_piercing = 1;
			_range = 6;
				_shot_count = 1;
		}
		if (_weapon_name = "Carnifex Claws") {
			_attack = 200;
			_piercing = 1;
			_range = 1;
			_shot_count = 3;
		}
		if (_weapon_name = "Venom Cannon") {
			_attack = 100;
			_piercing = 1;
			_range = 5;
		}
		if (_weapon_name = "Deathspitter") {
			_attack = 100;
			_piercing = 0;
			_range = 2.1;
			if (obj_ini.preomnor = 1) {
				_attack = 150;
			}
		}
		if (_weapon_name = "Fleshborer") {
			_attack = 70;
			_piercing = 0;
			_range = 2.1;
			if (obj_ini.preomnor = 1) {
				_attack = 19;
			}
		}
		if (_weapon_name = "Scything Talons") {
			_attack = 50;
			_piercing = 0;
			_range = 1;
		}
		if (_weapon_name = "Genestealer Claws") {
			_attack = 70;
			_piercing = 1;
			_range = 1;
		}
		if (_weapon_name = "Witchfire") {
			_attack = 100;
			_piercing = 1;
			_range = 2;
		}
		if (_weapon_name = "Autogun") {
			_attack = 60;
			_piercing = 0;
			_range = 6;
			_ammo = 12;
			_shot_count = 3;
		}
		if (_weapon_name = "Lictor Claws") {
			_attack = 300;
			_piercing = 1;
			_range = 1;
		}
		if (_weapon_name = "Flesh Hooks") {
			_attack = 100;
			_piercing = 0;
			_range = 2;
			_ammo = 1;
		}

	}

	if (obj_ncombat.enemy >= 10) or(obj_ncombat.enemy = 2) or(obj_ncombat.enemy = 5) or(obj_ncombat.enemy = 1) {

		if (_weapon_name = "Plasma Pistol") {
			_attack = 70;
			_piercing = 1;
			_range = 3.1;
		}
		if (_weapon_name = "Power Weapon") {
			_attack = 120;
			_piercing = 1;
			_range = 1;
		}
		if (_weapon_name = "Power Sword") {
			_attack = 120;
			_piercing = 1;
			_range = 1;
		}
		if (_weapon_name = "Force Weapon") {
			_attack = 250;
			_piercing = 1;
			_range = 1;
		}
		if (_weapon_name = "Chainfist") {
			_attack = 300;
			_piercing = 1;
			_range = 1;
			_shot_count = 3;
		}
		if (_weapon_name = "Meltagun") {
			_attack = 200;
			_piercing = 1;
			_range = 2;
			_ammo = 4;
		}
		if (_weapon_name = "Flamer") {
			_attack = 160;
			_piercing = 0;
			_range = 2.1;
			_ammo = 4;
			_shot_count = 3;
		}
		if (_weapon_name = "Heavy Flamer") {
			_attack = 200;
			_piercing = 0;
			_range = 2.1;
			_ammo = 6;
			_shot_count = 3;
		}
		if (_weapon_name = "Combi-Flamer") {
			_attack = 160;
			_piercing = 0;
			_range = 2.1;
			_ammo = 1;
			_shot_count = 3;
		}
		if (_weapon_name = "Bolter") {
			_attack = 120;
			_piercing = 0;
			_range = 12;
			_ammo = 15;
			if (obj_ncombat.enemy = 5) then _attack = 80;
		} // Bursts
		if (_weapon_name = "Power Fist") {
			_attack = 250;
			_piercing = 1;
			_range = 1;
		}
		if (_weapon_name = "Possessed Claws") {
			_attack = 150;
			_piercing = 0;
			_range = 1;
			_shot_count = 3;
		}
		if (_weapon_name = "Missile Launcher") {
			_attack = 200;
			_piercing = 0;
			_range = 20;
			_ammo = 4;
		}
		if (_weapon_name = "Chainsword") {
			_attack = 120;
			_piercing = 0;
			_range = 1;
			_shot_count = 4;
		}
		if (_weapon_name = "Bolt Pistol") {
			_attack = 100;
			_piercing = 0;
			_range = 3.1;
			_ammo = 18;
			_shot_count = 1;
		}
		if (_weapon_name = "Chainaxe") {
			_attack = 140;
			_piercing = 0;
			_range = 1;
			_shot_count = 3;
		}
		if (_weapon_name = "Poisoned Chainsword") {
			_attack = 150;
			_piercing = 0;
			_range = 1;
			_shot_count = 1;
			if (obj_ini.preomnor = 1) {
				_attack = 180;
			}
		}
		if (_weapon_name = "Sonic Blaster") {
			_attack = 150;
			_piercing = 0;
			_range = 3;
			_shot_count = 6;
		}
		if (_weapon_name = "Rubric Bolter") {
			_attack = 150;
			_piercing = 0;
			_range = 12;
			_ammo = 15;
			_shot_count = 5;
		} // Bursts
		if (_weapon_name = "Witchfire") {
			_attack = 200;
			_piercing = 1;
			_range = 5.1;
			_shot_count = 1;
		}
		if (_weapon_name = "Autogun") {
			_attack = 60;
			_piercing = 0;
			_range = 6;
			_ammo = 12;
		}
		if (_weapon_name = "Storm Bolter") {
			_attack = 180;
			_piercing = 0;
			_range = 8;
			_ammo = 10;
			_shot_count = 3;
		}
		if (_weapon_name = "Lascannon") {
			_attack = 300;
			_piercing = 1;
			_range = 20;
			_ammo = 8;
			_shot_count = 1;
		}
		if (_weapon_name = "Twin Linked Heavy Bolters") {
			_attack = 240;
			_piercing = 0;
			_range = 16;
			_shot_count = 3;
		}
		if (_weapon_name = "Twin-Linked Heavy Bolters") {
			_attack = 240;
			_piercing = 0;
			_range = 16;
			_shot_count = 3;
		}
		if (_weapon_name = "Twin Linked Lascannon") {
			_attack = 600;
			_piercing = 1;
			_range = 20;
			_shot_count = 2;
		}
		if (_weapon_name = "Twin-Linked Lascannon") {
			_attack = 600;
			_piercing = 1;
			_range = 20;
			_shot_count = 2;
		}
		if (_weapon_name = "Battle Cannon") {
			_attack = 300;
			_piercing = 0;
			_range = 12;
		}
		if (_weapon_name = "Demolisher Cannon") {
			_attack = 500;
			_piercing = 1;
			_range = 2;
			_shot_count = 8;
			if (instance_exists(obj_nfort)) then _range = 5;
		}
		if (_weapon_name = "Earthshaker Cannon") {
			_attack = 250;
			_piercing = 0;
			_range = 12;
			_shot_count = 8;
		}
		if (_weapon_name = "Havoc Launcher") {
			_attack = 300;
			_piercing = 0;
			_range = 12;
			_shot_count = 12;
		}
		if (_weapon_name = "Baleflame") {
			_attack = 225;
			_piercing = 1;
			_range = 2;
		}
		if (_weapon_name = "Defiler Claws") {
			_attack = 350;
			_piercing = 1;
			_range = 1;
			_shot_count = 3;
		}
		if (_weapon_name = "Reaper Autocannon") {
			_attack = 320;
			_piercing = 0;
			_range = 18;
			_ammo = 10;
			_shot_count = 3;
		}

		if (_weapon_name = "Ripper Gun") {
			_attack = 120;
			_piercing = 0;
			_range = 3;
			_ammo = 5;
			_shot_count = 0;
		}
		if (_weapon_name = "Ogryn Melee") {
			_attack = 90;
			_piercing = 1;
			_range = 1;
		}
		if (_weapon_name = "Multi-Laser") {
			_attack = 150;
			_piercing = 0;
			_range = 10;
		}

		if (_weapon_name = "Blessed Weapon") {
			_attack = 150;
			_piercing = 1;
			_range = 1;
		}
		if (_weapon_name = "Electro-Flail") {
			_attack = 125;
			_piercing = 0;
			_range = 1;
			_shot_count = 3;
		}
		if (_weapon_name = "Neural Whip") {
			_attack = 85;
			_piercing = 0;
			_range = 1;
			_shot_count = 3
		}
		if (_weapon_name = "Sarissa") {
			_attack = 65;
			_piercing = 0;
			_range = 2;
		}
		if (_weapon_name = "Seraphim Pistols") {
			_attack = 120;
			_piercing = 0;
			_range = 4;
		}
		if (_weapon_name = "Laser Mace") {
			_attack = 150;
			_piercing = 0;
			_range = 5.1;
			_ammo = 3;
		}
		if (_weapon_name = "Heavy Bolter") {
			_attack = 120;
			_piercing = 0;
			_range = 16;
			_shot_count = 0;
		}

		if (_weapon_name = "Lasgun") {
			_attack = 80;
			_piercing = 0;
			_range = 6;
			_ammo = 30;
		}
		if (_weapon_name = "Daemonhost Claws") {
			_attack = 350;
			_piercing = 1;
			_range = 1;
			_shot_count = 3;
		}
		if (_weapon_name = "Daemonhost_Powers") {
			_attack = round(random_range(100, 300));
			_piercing = round(random_range(100, 300));
			_range = round(random_range(1, 6));
			_shot_count = choose(0, 1);
		}
	}

	if (obj_ncombat.enemy = 13) { // Some of these, like the Gauss Particle Cannon and Particle Whip, used to be more than twice as strong.
		if (_weapon_name = "Staff of Light") {
			_attack = 200;
			_piercing = 1;
			_range = 1;
			_shot_count = 3;
		}
		if (_weapon_name = "Staff of Light Shooting") {
			_attack = 180;
			_piercing = 1;
			_range = 3;
			_shot_count = 3;
		}
		if (_weapon_name = "Warscythe") {
			_attack = 200;
			_piercing = 1;
			_range = 1;
			_shot_count = 0;
		}
		if (_weapon_name = "Gauss Flayer") {
			_attack = 50;
			_piercing = 0;
			_range = 6.1;
			_shot_count = 1;
		}
		if (_weapon_name = "Gauss Blaster") {
			_attack = 80;
			_piercing = 0;
			_range = 6.1;
			_shot_count = 0;
		}
		if (_weapon_name = "Gauss Cannon") {
			_attack = 120;
			_piercing = 1;
			_range = 10;
			_shot_count = 3;
		}
		if (_weapon_name = "Gauss Particle Cannon") {
			_attack = 250;
			_piercing = 1;
			_range = 10.1;
			_shot_count = 3;
		}
		if (_weapon_name = "Overcharged Gauss Cannon") {
			_attack = 250;
			_piercing = 1;
			_range = 8.1;
			_shot_count = 3;
		}
		if (_weapon_name = "Wraith Claws") {
			_attack = 80;
			_piercing = 0;
			_range = 1;
			_shot_count = 0;
		}
		if (_weapon_name = "Claws") {
			_attack = 300;
			_piercing = 0;
			_range = 1;
			_shot_count = 0;
		}
		if (_weapon_name = "Gauss Flux Arc") {
			_attack = 180;
			_piercing = 0;
			_range = 8;
			_shot_count = 3;
		}
		if (_weapon_name = "Particle Whip") {
			_attack = 300;
			_piercing = 0;
			_range = 4.1;
			_shot_count = 3;
		}
		if (_weapon_name = "Gauss Flayer Array") {
			_attack = 180;
			_piercing = 0;
			_range = 8.1;
			_shot_count = 3;
		}
		if (_weapon_name = "Doomsday Cannon") {
			_attack = 300;
			_piercing = 1;
			_range = 6.1;
			_shot_count = 3;
		}
	} */

	var _weapon_struct = global.weapons[$ _weapon_name];

	_attack = _weapon_struct.attack.standard;
	_piercing = _weapon_struct.arp;
	_range = _weapon_struct.range;
	_shot_count = _weapon_struct.spli;

	if (_shot_count == 0) {
		exit;
	}

	// if (faith_bonus = 1) then _attack = _attack * 2;
	// if (faith_bonus = 2) then _attack = _attack * 3;
	_attack = round(_attack * obj_ncombat.global_defense);
	
	// if (obj_ncombat.enemy == 1) {
	// 	if (_range <= 1 || floor(_range) != _range) {
	// 		_attack = round(_attack * dudes_attack[_unit_block]);
	// 	} else if (_range > 1 && floor(_range) == _range) {
	// 		_attack = round(_attack * dudes_ranged[_unit_block]);
	// 	}
	// }
	
	if (_unit_type == 1 && _ammo > 0) {
		_ammo *= 2;
	}

	var _weapon_stack = new WeaponStack(_weapon_name);
	_weapon_stack.attack = _attack;
	_weapon_stack.piercing = _piercing;
	_weapon_stack.range = _range;
	_weapon_stack.weapon_count += _weapon_count;
	_weapon_stack.shot_count = _shot_count;
	array_push(_weapon_stack.owners, _unit_name);

	if (obj_ncombat.battle_stage == eBATTLE_STAGE.Creation) {
		_weapon_stack.ammo_max = _ammo;
		_weapon_stack.ammo_current = _ammo;
		_weapon_stack.ammo_reload = _reload;
	}

	array_push(weapon_stacks_normal, _weapon_stack);
}
