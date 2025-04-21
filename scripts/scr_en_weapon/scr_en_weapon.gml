/// @mixin
function scr_en_weapon(_weapon_name, _unit_type, _weapon_count, _unit_name, _unit_block) {

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

	if (string_count("elee", _weapon_name) > 0) {
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

		if (argument0 = "Fusion Gun"){
			_attack = 180;
			_piercing = 1;
			_range = 2;
			_ammo = 4;
		}

			if (argument0 = "Firepike") {
				_attack = 150;
				_piercing = 1;
				_range = 4;
				_ammo = 4;
			}
		if (argument0 = "Singing Spear") {
			_attack = 150;
			_piercing = 0;
			_range = 1;
			_shot_count = 3;
		}
		if (argument0 = "Singing Spear Throw") {
			_attack = 120;
			_piercing = 0;
			_range = 2;
			_shot_count = 3;
		}
		if (argument0 = "Witchblade") {
			_attack = 130;
			_piercing = 0;
			_range = 1;
		}
		if (argument0 = "Psyshock") {
			_attack = 50;
			_piercing = 0;
			_range = 2;
		}
		if (argument0 = "Wailing Doom") {
			_attack = 200;
			_piercing = 1;
			_range = 1;
			_shot_count = 3;
		}
		if (argument0 = "Avatar Smite") {
			_attack = 300;
			_piercing = 1;
			_range = 2;
			_ammo = 2;
		}
		if (argument0 = "Ranger Long Rifle") {
			_attack = 60;
			_piercing = 0;
			_range = 25;
		}
		if (argument0 = "Pathfinder Long Rifle") {
			_attack = 70;
			_piercing = 0;
			_range = 25;
		}
		if (argument0 = "Shuriken Catapult") {
			_attack = 50;
			_piercing = 0;
			_range = 2;
		}
		if (argument0 = "Twin Linked Shuriken Catapult") {
			_attack = 100;
			_piercing = 0;
			_range = 2;
		}
		if (argument0 = "Avenger Shuriken Catapult") {
			_attack = 90;
			_piercing = 0;
			_range = 3;
		}
		if (argument0 = "Power Weapon") or(argument0 = "Power Blades") {
			_attack = 100;
			_piercing = 1;
			_range = 1;
			_shot_count = 3;
		}
		if (argument0 = "Shuriken Pistol") {
			_attack = 50;
			_piercing = 0;
			_range = 2.1;
		}
		if (argument0 = "Executioner") {
			_attack = 150;
			_piercing = 1;
			_range = 1;
		}
		if (argument0 = "Scorpion Chainsword") {
			_attack = 100;
			_piercing = 0;
			_range = 1;
			_shot_count = 3;
		}
		if (argument0 = "Mandiblaster") {
			_attack = 60;
			_piercing = 0;
			_range = 1;
		}
		if (argument0 = "Biting Blade") {
			_attack = 125;
			_piercing = 0;
			_range = 1;
			_shot_count = 3;
		}
		if (argument0 = "Scorpian's Claw") {
			_attack = 150;
			_piercing = 1;
			_range = 1;
			_shot_count = 3;
		}
		if (argument0 = "Meltabomb") {
			_attack = 200;
			_piercing = 1;
			_range = 1;
			_ammo = 1;
		}
		if (argument0 = "Deathspinner") {
			_attack = 125;
			_piercing = 0;
			_range = 2;
		}
		if (argument0 = "Dual Deathspinner") {
			_attack = 250;
			_piercing = 0;
			_range = 2;
		}
		if (argument0 = "Reaper Launcher") {
			_attack = 120;
			_piercing = 1;
			_range = 20;
			_ammo = 8;
			_shot_count = 3;
		}
		if (argument0 = "Tempest Launcher") {
			_attack = 200;
			_piercing = 0;
			_range = 15;
			_ammo = 8;
			_shot_count = 9;
		}
		if (argument0 = "Laser Lance") {
			_attack = 180;
			_piercing = 1;
			_range = 2;
			_shot_count = 3;
		}
		if (argument0 = "Fusion Pistol") {
			_attack = 125;
			_piercing = 1;
			_range = 2.1;
			_ammo = 4;
		}
		if (argument0 = "Plasma Pistol") {
			_attack = 100;
			_piercing = 1;
			_range = 3.1;
		}
		if (argument0 = "Harlequin's Kiss") {
			_attack = 250;
			_piercing = 1;
			_range = 1;
			_ammo = 1;
		}
		if (argument0 = "Wraithcannon") {
			_attack = 200;
			_piercing = 1;
			_range = 2.1;
		}
		if (argument0 = "Pulse Laser") {
			_attack = 120;
			_piercing = 0;
			_range = 15;
		}
		if (argument0 = "Bright Lance") {
			_attack = 200;
			_piercing = 1;
			_range = 8;
		}
		if (argument0 = "Shuriken Cannon") {
			_attack = 160;
			_piercing = 0;
			_range = 3;
		}
		if (argument0 = "Prism Cannon") {
			_attack = 400;
			_piercing = 1;
			_range = 20;
				_shot_count = 1;
		}
		if (argument0 = "Twin Linked Doomweaver") {
			_attack = 250;
			_piercing = 1;
			_range = 2;
				_shot_count = 2;
		} // Also create difficult terrain?
		if (argument0 = "Starcannon") {
			_attack = 250;
			_piercing = 1;
			_range = 8;
			_shot_count = 4;
		}
		if (argument0 = "Two Power Fists") {
			_attack = 300;
			_piercing = 1;
			_range = 1;
				_shot_count = 2;
		}
		if (argument0 = "Flamer") {
			_attack = 200;
			_piercing = 0;
			_range = 2;
			_ammo = 4;
			_shot_count = 3;
		}
		if (argument0 = "Titan Starcannon") {
			_attack = 500;
			_piercing = 1;
			_range = 4;
			_shot_count = 8;
		}
		if (argument0 = "Phantom Pulsar") {
			_attack = 500;
			_piercing = 1;
			_range = 20;
			_shot_count = 3;
		}
	}

	if (obj_ncombat.enemy = 7) {

		if (argument0 = "Choppa") {
			_attack = 16;
			_piercing = 4;
			_range = 1;
			_shot_count = 2;
		}
		if (argument0 = "Power Klaw") {
			_attack = 22;
			_piercing = 20;
			_range = 1;
			_shot_count = 2;
		}
		if (argument0 = "Slugga") {
			_attack = 20;
			_piercing = 0;
			_range = 2;
			_ammo = 6;
			_shot_count = 3;
			_reload = 1;
		}
		if (argument0 = "Tankbusta Bomb") {
			_attack = 65;
			_piercing = 16;
			_range = 1;
			_ammo = 1;
			_shot_count = 1;
			_reload = -1;
		}
		if (argument0 = "Big Shoota") {
			_attack = 24;
			_piercing = 4;
			_range = 8;
			_ammo = 6;
			_shot_count = 10;
			_reload = 2;
		}
		if (argument0 = "Dakkagun") {
			_attack = 24;
			_piercing = 4;
			_range = 8;
			_ammo = 14;
			_shot_count = 7;
			_reload = 3;
		}
		if (argument0 = "Deffgun") {
			_attack = 30;
			_piercing = 4;
			_range = 10;
			_ammo = 6;
			_shot_count = 8;
			_reload = 2;
		}
		if (argument0 = "Snazzgun") {
			_attack = 30;
			_piercing = 10;
			_range = 11;
			_ammo = 10;
			_shot_count = 2;
			_reload = 2;
		}
		if (argument0 = "Grot Blasta") {
			_attack = 14;
			_piercing = 0;
			_range = 2;
			_ammo = 4;
			_shot_count = 2;
			_reload = 2;
		}
		if (argument0 = "Kannon") {
			_attack = 45;
			_piercing = 12;
			_range = 20;
			_ammo = 1;
			_shot_count = 5;
			_reload = 1;
		}
		if (argument0 = "Shoota") {
			_attack = 20;
			_piercing = 0;
			_ammo = 10;
			_range = 7;
			_shot_count = 3;
			_reload = 1;
		}
		if (argument0 = "Burna") {
			_attack = 22;
			_piercing = 4;
			_range = 3;
			_ammo = 6;
			_shot_count = 6;
			_reload = 2;
		}
		if (argument0 = "Skorcha") {
			_attack = 25;
			_piercing = 6;
			_range = 4;
			_ammo = 6;
			_shot_count = 8;
			_reload = 2;
		}
		if (argument0 = "Rokkit Launcha") {
			_attack = 45;
			_piercing = 18;
			_range = 16;
			_shot_count = 1;
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

		if (argument0 = "Bonesword") {
			_attack = 120;
			_piercing = 1;
			_range = 1;
			_shot_count = 3;
		}
		if (argument0 = "Lash Whip") {
			_attack = 100;
			_piercing = 0;
			_range = 2;
		}
		if (argument0 = "Heavy Venom Cannon") {
			_attack = 200;
			_piercing = 1;
			_range = 8;
		}
		if (argument0 = "Crushing Claws") {
			_attack = 150;
			_piercing = 1;
			_range = 1;
			_shot_count = 3;
		}
		if (argument0 = "Rending Claws") {
			_attack = 80;
			_piercing = 1;
			_range = 1;
			_shot_count = 3;
		}
		if (argument0 = "Devourer") {
			_attack = 90;
			_piercing = 0;
			_range = 5;
				_shot_count = 3
			if (obj_ini.preomnor = 1) {
				_attack = 180;
			}
		}
		if (argument0 = "Zoanthrope Blast") {
			_attack = 250;
			_piercing = 1;
			_range = 6;
				_shot_count = 1;
		}
		if (argument0 = "Carnifex Claws") {
			_attack = 200;
			_piercing = 1;
			_range = 1;
			_shot_count = 3;
		}
		if (argument0 = "Venom Cannon") {
			_attack = 100;
			_piercing = 1;
			_range = 5;
		}
		if (argument0 = "Deathspitter") {
			_attack = 100;
			_piercing = 0;
			_range = 2.1;
			if (obj_ini.preomnor = 1) {
				_attack = 150;
			}
		}
		if (argument0 = "Fleshborer") {
			_attack = 70;
			_piercing = 0;
			_range = 2.1;
			if (obj_ini.preomnor = 1) {
				_attack = 19;
			}
		}
		if (argument0 = "Scything Talons") {
			_attack = 50;
			_piercing = 0;
			_range = 1;
		}
		if (argument0 = "Genestealer Claws") {
			_attack = 70;
			_piercing = 1;
			_range = 1;
		}
		if (argument0 = "Witchfire") {
			_attack = 100;
			_piercing = 1;
			_range = 2;
		}
		if (argument0 = "Autogun") {
			_attack = 60;
			_piercing = 0;
			_range = 6;
			_ammo = 12;
			_shot_count = 3;
		}
		if (argument0 = "Lictor Claws") {
			_attack = 300;
			_piercing = 1;
			_range = 1;
		}
		if (argument0 = "Flesh Hooks") {
			_attack = 100;
			_piercing = 0;
			_range = 2;
			_ammo = 1;
		}

	}

	if (obj_ncombat.enemy >= 10) or(obj_ncombat.enemy = 2) or(obj_ncombat.enemy = 5) or(obj_ncombat.enemy = 1) {

		if (argument0 = "Plasma Pistol") {
			_attack = 70;
			_piercing = 1;
			_range = 3.1;
		}
		if (argument0 = "Power Weapon") {
			_attack = 120;
			_piercing = 1;
			_range = 1;
		}
		if (argument0 = "Power Sword") {
			_attack = 120;
			_piercing = 1;
			_range = 1;
		}
		if (argument0 = "Force Weapon") {
			_attack = 250;
			_piercing = 1;
			_range = 1;
		}
		if (argument0 = "Chainfist") {
			_attack = 300;
			_piercing = 1;
			_range = 1;
			_shot_count = 3;
		}
		if (argument0 = "Meltagun") {
			_attack = 200;
			_piercing = 1;
			_range = 2;
			_ammo = 4;
		}
		if (argument0 = "Flamer") {
			_attack = 160;
			_piercing = 0;
			_range = 2.1;
			_ammo = 4;
			_shot_count = 3;
		}
		if (argument0 = "Heavy Flamer") {
			_attack = 200;
			_piercing = 0;
			_range = 2.1;
			_ammo = 6;
			_shot_count = 3;
		}
		if (argument0 = "Combi-Flamer") {
			_attack = 160;
			_piercing = 0;
			_range = 2.1;
			_ammo = 1;
			_shot_count = 3;
		}
		if (argument0 = "Bolter") {
			_attack = 120;
			_piercing = 0;
			_range = 12;
			_ammo = 15;
			if (obj_ncombat.enemy = 5) then _attack = 80;
		} // Bursts
		if (argument0 = "Power Fist") {
			_attack = 250;
			_piercing = 1;
			_range = 1;
		}
		if (argument0 = "Possessed Claws") {
			_attack = 150;
			_piercing = 0;
			_range = 1;
			_shot_count = 3;
		}
		if (argument0 = "Missile Launcher") {
			_attack = 200;
			_piercing = 0;
			_range = 20;
			_ammo = 4;
		}
		if (argument0 = "Chainsword") {
			_attack = 120;
			_piercing = 0;
			_range = 1;
			_shot_count = 4;
		}
		if (argument0 = "Bolt Pistol") {
			_attack = 100;
			_piercing = 0;
			_range = 3.1;
			_ammo = 18;
			_shot_count = 1;
		}
		if (argument0 = "Chainaxe") {
			_attack = 140;
			_piercing = 0;
			_range = 1;
			_shot_count = 3;
		}
		if (argument0 = "Poisoned Chainsword") {
			_attack = 150;
			_piercing = 0;
			_range = 1;
			_shot_count = 1;
			if (obj_ini.preomnor = 1) {
				_attack = 180;
			}
		}
		if (argument0 = "Sonic Blaster") {
			_attack = 150;
			_piercing = 0;
			_range = 3;
			_shot_count = 6;
		}
		if (argument0 = "Rubric Bolter") {
			_attack = 150;
			_piercing = 0;
			_range = 12;
			_ammo = 15;
			_shot_count = 5;
		} // Bursts
		if (argument0 = "Witchfire") {
			_attack = 200;
			_piercing = 1;
			_range = 5.1;
			_shot_count = 1;
		}
		if (argument0 = "Autogun") {
			_attack = 60;
			_piercing = 0;
			_range = 6;
			_ammo = 12;
		}
		if (argument0 = "Storm Bolter") {
			_attack = 180;
			_piercing = 0;
			_range = 8;
			_ammo = 10;
			_shot_count = 3;
		}
		if (argument0 = "Lascannon") {
			_attack = 300;
			_piercing = 1;
			_range = 20;
			_ammo = 8;
			_shot_count = 1;
		}
		if (argument0 = "Twin Linked Heavy Bolters") {
			_attack = 240;
			_piercing = 0;
			_range = 16;
			_shot_count = 3;
		}
		if (argument0 = "Twin-Linked Heavy Bolters") {
			_attack = 240;
			_piercing = 0;
			_range = 16;
			_shot_count = 3;
		}
		if (argument0 = "Twin Linked Lascannon") {
			_attack = 600;
			_piercing = 1;
			_range = 20;
			_shot_count = 2;
		}
		if (argument0 = "Twin-Linked Lascannon") {
			_attack = 600;
			_piercing = 1;
			_range = 20;
			_shot_count = 2;
		}
		if (argument0 = "Battle Cannon") {
			_attack = 300;
			_piercing = 0;
			_range = 12;
		}
		if (argument0 = "Demolisher Cannon") {
			_attack = 500;
			_piercing = 1;
			_range = 2;
			_shot_count = 8;
			if (instance_exists(obj_nfort)) then _range = 5;
		}
		if (argument0 = "Earthshaker Cannon") {
			_attack = 250;
			_piercing = 0;
			_range = 12;
			_shot_count = 8;
		}
		if (argument0 = "Havoc Launcher") {
			_attack = 300;
			_piercing = 0;
			_range = 12;
			_shot_count = 12;
		}
		if (argument0 = "Baleflame") {
			_attack = 225;
			_piercing = 1;
			_range = 2;
		}
		if (argument0 = "Defiler Claws") {
			_attack = 350;
			_piercing = 1;
			_range = 1;
			_shot_count = 3;
		}
		if (argument0 = "Reaper Autocannon") {
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

		if (argument0 = "Blessed Weapon") {
			_attack = 150;
			_piercing = 1;
			_range = 1;
		}
		if (argument0 = "Electro-Flail") {
			_attack = 125;
			_piercing = 0;
			_range = 1;
			_shot_count = 3;
		}
		if (argument0 = "Neural Whip") {
			_attack = 85;
			_piercing = 0;
			_range = 1;
			_shot_count = 3
		}
		if (argument0 = "Sarissa") {
			_attack = 65;
			_piercing = 0;
			_range = 2;
		}
		if (argument0 = "Seraphim Pistols") {
			_attack = 120;
			_piercing = 0;
			_range = 4;
		}
		if (argument0 = "Laser Mace") {
			_attack = 150;
			_piercing = 0;
			_range = 5.1;
			_ammo = 3;
		}
		if (argument0 = "Heavy Bolter") {
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
	
	if (!_unit_type && _ammo > 0) {
		_ammo *= 2;
	}

	var _stack_type = {};
	if (_unit_type) {
		_stack_type = weapon_stacks_normal;
	} else {
		_stack_type = weapon_stacks_vehicle;
	}

	if (struct_exists(_stack_type, _weapon_name)) {
		var _weapon_stack = _stack_type[$ _weapon_name];
		_weapon_stack.weapon_count += _weapon_count;
	
		if (!array_contains(_weapon_stack.owners, _unit_name)) {
			array_push(_weapon_stack.owners, _unit_name);
		}
	} else {
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
	
		struct_set(_stack_type, _weapon_name, _weapon_stack);
	}
}
