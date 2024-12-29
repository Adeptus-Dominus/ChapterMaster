function scr_en_weapon(name, is_man, man_number, man_type, group) {

	// check if double ranged/melee
	// then add to that weapon

	//scr_infantry_weapon
	// name: name
	// is_man: man?  //Probably used to differenciate internaly between trooper and vehicle weapons
	// man_number: number
	// man_type: owner
	// group: current dudes block

	// Determines combined damage for enemy battle blocks for a single weapon

	var atta, arp, acr, rang, amm, spli, faith_bonus, i;
	i = 0;
	rang = 0;
	atta = 0;
	spli = 0;
	arp = 0;
	acr = 0;
	amm = -1;
	faith_bonus = 0;
	var struct = gear_weapon_data("weapon",name);
	if (!struct){
		if (string_count("elee", name) > 0) {
			var to;
			to = string_delete(name, 0, 5);
			atta = 10;
			arp = 0;
			rang = 1;
			spli = 3;
		}

		//if (obj_ncombat.enemy=5) then faith_bonus=faith[man_type];

		if (name = "Venom Claws") {
			atta = 200;
			arp = 0;
			rang = 1;
			spli = 0;
			if (obj_ini.preomnor = 1) {
				atta = 240;
			}
		}
		if (name = "Web Spinner") {
			atta = 40;
			arp = 0;
			rang = 2.1;
			spli = 3;
			amm = 1;
		}
		if (name = "Warpsword") {
			atta = 300;
			arp = 1;
			rang = 1;
			spli = 3;
		}
		if (name = "Iron Claw") {
			atta = 400;
			arp = 1;
			rang = 1;
			spli = 0;
		}
		if (name = "Maulerfiend Claws") {
			atta = 300;
			arp = 300;
			rang = 1;
			spli = 3;
		}

		if (name = "Eldritch Fire") {
			atta = 80;
			arp = 1;
			rang = 5.1;
		}
		if (name = "Bloodletter Melee") {
			atta = 70;
			arp = 0;
			rang = 1;
			spli = 3;
		}
		if (name = "Daemonette Melee") {
			atta = 65;
			arp = 0;
			rang = 1;
			spli = 3;
		}
		if (name = "Plaguebearer Melee") {
			atta = 60;
			arp = 0;
			rang = 1;
			spli = 3;
			if (obj_ini.preomnor = 1) {
				atta = 70;
			}
		}
		if (name = "Khorne Demon Melee") {
			atta = 350;
			arp = 1;
			rang = 1;
			spli = 3;
		}
		if (name = "Demon Melee") {
			atta = 250;
			arp = 1;
			rang = 1;
			spli = 3;
		}
		if (name = "Lash Whip") {
			atta = 80;
			arp = 0;
			rang = 2;
		}
		if (name = "Nurgle Vomit") {
			atta = 100;
			arp = 0;
			rang = 2;
			spli = 3;
			if (obj_ini.preomnor = 1) {
				atta = 260;
			}
		}
		if (name = "Multi-Melta") {
			atta = 200;
			arp = 1;
			rang = 4.1;
			spli = 0;
			amm = 6;
		}

		if (obj_ncombat.enemy = 3) {
			if (name = "Phased Plasma-fusil") {
				atta = 100;
				arp = 1;
				rang = 7.1;
				spli = 3;
			}
			if (name = "Lightning Gun") {
				atta = choose(80, 80, 80, 150);
				arp = 0;
				rang = 5;
				spli = 0;
			}
			if (name = "Thallax Melee") {
				atta = 80;
				arp = 0;
				rang = 1;
				spli = 3;
			}
		}

		if (obj_ncombat.enemy = 6) {

			if (argument0 = "Fusion Gun") or(argument0 = "Firepike") {
				atta = 200;
				arp = 1;
				rang = 2;
				amm = 4;
			}
			if (argument0 = "Singing Spear") {
				atta = 120;
				arp = 0;
				rang = 1;
				spli = 3;
			}
			if (argument0 = "Singing Spear Throw") {
				atta = 120;
				arp = 1;
				rang = 2;
				spli = 3;
			}
			if (argument0 = "Witchblade") {
				atta = 100;
				arp = 1;
				rang = 1;
			}
			if (argument0 = "Psyshock") {
				atta = 50;
				arp = 0;
				rang = 2;
			}
			if (argument0 = "Wailing Doom") {
				atta = 200;
				arp = 1;
				rang = 1;
				spli = 3;
			}
			if (argument0 = "Avatar Smite") {
				atta = 300;
				arp = 1;
				rang = 2;
				amm = 2;
			}
			if (argument0 = "Ranger Long Rifle") {
				atta = 60;
				arp = 0;
				rang = 25;
			}
			if (argument0 = "Pathfinder Long Rifle") {
				atta = 70;
				arp = 0;
				rang = 25;
			}
			if (argument0 = "Shuriken Catapult") {
				atta = 35;
				arp = 0;
				rang = 2;
			}
			if (argument0 = "Twin Linked Shuriken Catapult") {
				atta = 50;
				arp = 0;
				rang = 2;
			}
			if (argument0 = "Avenger Shuriken Catapult") {
				atta = 40;
				arp = 0;
				rang = 3;
			}
			if (argument0 = "Power Weapon") or(argument0 = "Power Blades") {
				atta = 80;
				arp = 0;
				rang = 1;
				spli = 3;
			}
			if (argument0 = "Shuriken Pistol") {
				atta = 25;
				arp = 0;
				rang = 2.1;
			}
			if (argument0 = "Executioner") {
				atta = 200;
				arp = 1;
				rang = 1;
			}
			if (argument0 = "Scorpion Chainsword") {
				atta = 40;
				arp = 0;
				rang = 1;
				spli = 3;
			}
			if (argument0 = "Mandiblaster") {
				atta = 20;
				arp = 0;
				rang = 1;
			}
			if (argument0 = "Biting Blade") {
				atta = 70;
				arp = 0;
				rang = 1;
				spli = 3;
			}
			if (argument0 = "Scorpian's Claw") {
				atta = 150;
				arp = 1;
				rang = 1;
				spli = 3;
			}
			if (argument0 = "Meltabomb") {
				atta = 0;
				arp = 200;
				rang = 1;
				amm = 1;
			}
			if (argument0 = "Deathspinner") {
				atta = 50;
				arp = 0;
				rang = 2;
			}
			if (argument0 = "Dual Deathspinner") {
				atta = 80;
				arp = 0;
				rang = 2;
			}
			if (argument0 = "Reaper Launcher") {
				atta = 150;
				arp = 80;
				rang = 20;
				amm = 8;
				spli = 3;
			}
			if (argument0 = "Eldar Missile Launcher") {
				atta = 200;
				arp = 1;
				rang = 20;
				amm = 4;
				spli = 3;
			}
			if (argument0 = "Laser Lance") {
				atta = 80;
				arp = 0;
				rang = 2;
				spli = 3;
			}
			if (argument0 = "Fusion Pistol") {
				atta = 100;
				arp = 1;
				rang = 1.1;
				amm = 4;
			}
			if (argument0 = "Plasma Pistol") {
				atta = 60;
				arp = 1;
				rang = 3.1;
			}
			if (argument0 = "Harlequin's Kiss") {
				atta = 350;
				arp = 0;
				rang = 1;
				amm = 1;
			}
			if (argument0 = "Wraithcannon") {
				atta = 80;
				arp = 1;
				rang = 2.1;
			}
			if (argument0 = "Pulse Laser") {
				atta = 80;
				arp = 1;
				rang = 15;
			}
			if (argument0 = "Bright Lance") {
				atta = 100;
				arp = 1;
				rang = 8;
			}
			if (argument0 = "Shuriken Cannon") {
				atta = 65;
				arp = 0;
				rang = 3;
			}
			if (argument0 = "Prism Cannon") {
				atta = 250;
				arp = 1;
				rang = 20;
			}
			if (argument0 = "Twin Linked Doomweaver") {
				atta = 100;
				arp = 0;
				rang = 2;
			} // Also create difficult terrain?
			if (argument0 = "Starcannon") {
				atta = 140;
				arp = 1;
				rang = 3;
				spli = 3;
			}
			if (argument0 = "Two Power Fists") {
				atta = 300;
				arp = 1;
				rang = 1;
			}
			if (argument0 = "Flamer") {
				atta = 100;
				arp = 0;
				rang = 2;
				amm = 4;
				spli = 3;
			}
			if (argument0 = "Titan Starcannon") {
				atta = 220;
				arp = 1;
				rang = 4;
				spli = 3;
			}
			if (argument0 = "Phantom Pulsar") {
				atta = 500;
				arp = 1;
				rang = 20;
				spli = 3;
			}
		}

		if (obj_ncombat.enemy = 7) {

			if (argument0 = "Choppa") {
				atta = 28;
				arp = 0;
				rang = 1;
				spli = 3;
			}
			if (argument0 = "Power Klaw") {
				atta = 150;
				arp = 1;
				rang = 1;
				spli = 3;
			}
			if (argument0 = "Slugga") {
				atta = 27;
				arp = 0;
				rang = 3.1;
				amm = 4;
				spli = 3;
			}
			if (argument0 = "Tankbusta Bomb") {
				atta = 264;
				arp = 1;
				rang = 1;
				amm = 1;
				spli = 0;
			}
			if (argument0 = "Big Shoota") {
				atta = 100;
				arp = 0;
				rang = 12;
				amm = 30;
				spli = 0;
			}
			if (argument0 = "Dakkagun") {
				atta = 150;
				arp = 0;
				rang = 10;
				amm = 20;
				spli = 0;
			}
			if (argument0 = "Deffgun") {
				atta = 120;
				arp = 0;
				rang = 8;
				amm = 20;
				spli = 0;
			}
			if (argument0 = "Snazzgun") {
				atta = 80;
				arp = 0;
				rang = 10;
				spli = 0;
			}
			if (argument0 = "Grot Blasta") {
				atta = 12;
				arp = 0;
				rang = 2;
				amm = 6;
			}
			if (argument0 = "Kannon") {
				atta = 200;
				arp = 1;
				rang = 10.1;
				amm = 5;
				spli = 3;
			}
			if (argument0 = "Shoota") {
				atta = 30;
				arp = 0;
				rang = 6;
			}
			if (argument0 = "Burna") {
				atta = 140;
				arp = 1;
				rang = 2;
				amm = 4;
				spli = 3;
			}
			if (argument0 = "Skorcha") {
				atta = 160;
				arp = 1;
				rang = 2;
				amm = 6;
				spli = 3;
			}
			if (argument0 = "Rokkit Launcha") {
				atta = 150;
				arp = 1;
				rang = 15;
				spli = 3;
			}
			if (argument0 = "Krooz Missile") {
				atta = 250;
				arp = 1;
				rang = 15;
				spli = 3;
			}

		}

		if (obj_ncombat.enemy = 8) {
			if (name = "Fusion Blaster") {
				atta = 200;
				arp = 1;
				rang = 2;
				amm = 4;
			}
			if (name = "Plasma Rifle") {
				atta = 120;
				arp = 1;
				rang = 10;
			}
			if (name = "Cyclic Ion Blaster") {
				atta = 180;
				arp = 0;
				rang = 6;
				spli = 3;
			} // x6
			if (name = "Burst Rifle") {
				atta = 130;
				arp = 0;
				rang = 16;
				spli = 3;
			}
			if (name = "Missile Pod") {
				atta = 160;
				arp = 1;
				rang = 15;
				amm = 6;
				spli = 3;
			}
			if (name = "Smart Missile System") {
				atta = 150;
				arp = 1;
				rang = 15;
			}
			if (name = "Small Railgun") {
				atta = 150;
				arp = 1;
				rang = 18;
			}
			if (name = "Pulse Rifle") {
				atta = 37;
				arp = 0;
				rang = 12;
			}
			if (name = "Rail Rifle") {
				atta = 65;
				arp = 0;
				rang = 14;
			}
			if (name = "Kroot Rifle") {
				atta = 25;
				arp = 0;
				rang = 6;
			}
			if (name = "Vespid Crystal") {
				atta = 60;
				arp = 0;
				rang = 2.1;
			}
			if (name = "Railgun") {
				atta = 400;
				arp = 1;
				rang = 20;
			}
		}

		if (obj_ncombat.enemy = 9) {

			if (argument0 = "Bonesword") {
				atta = 120;
				arp = 0;
				rang = 1;
				spli = 3;
			}
			if (argument0 = "Lash Whip") {
				atta = 80;
				arp = 0;
				rang = 2;
			}
			if (argument0 = "Heavy Venom Cannon") {
				atta = 150;
				arp = 1;
				rang = 8;
			}
			if (argument0 = "Crushing Claws") {
				atta = 90;
				arp = 1;
				rang = 1;
				spli = 3;
			}
			if (argument0 = "Rending Claws") {
				atta = 80;
				arp = 1;
				rang = 1;
				spli = 3;
			}
			if (argument0 = "Devourer") {
				atta = choose(40, 60, 80, 100);
				arp = 0;
				rang = 5;
				if (obj_ini.preomnor = 1) {
					atta = choose(48, 72, 96, 120);
				}
			}
			if (argument0 = "Zoanthrope Blast") {
				atta = 200;
				arp = 1;
				rang = 2;
			}
			if (argument0 = "Carnifex Claws") {
				atta = 300;
				arp = 1;
				rang = 1;
				spli = 3;
			}
			if (argument0 = "Venom Cannon") {
				atta = 150;
				arp = 0;
				rang = 5;
			}
			if (argument0 = "Deathspitter") {
				atta = 100;
				arp = 0;
				rang = 2.1;
				if (obj_ini.preomnor = 1) {
					atta = 120;
				}
			}
			if (argument0 = "Fleshborer") {
				atta = 15;
				arp = 0;
				rang = 2.1;
				if (obj_ini.preomnor = 1) {
					atta = 19;
				}
			}
			if (argument0 = "Scything Talons") {
				atta = 30;
				arp = 0;
				rang = 1;
			}
			if (argument0 = "Genestealer Claws") {
				atta = choose(105, 105, 130);
				arp = 1;
				rang = 1;
			}
			if (argument0 = "Witchfire") {
				atta = 100;
				arp = 1;
				rang = 2;
			}
			if (argument0 = "Autogun") {
				atta = 20;
				arp = 0;
				rang = 6;
				amm = 12;
				spli = 3;
			}
			if (argument0 = "Lictor Claws") {
				atta = 300;
				arp = 0;
				rang = 1;
			}
			if (argument0 = "Flesh Hooks") {
				atta = 50;
				arp = 0;
				rang = 2;
				amm = 1;
			}

		}

		if (obj_ncombat.enemy >= 10) or(obj_ncombat.enemy = 2) or(obj_ncombat.enemy = 5) or(obj_ncombat.enemy = 1) {

			if (argument0 = "Plasma Pistol") {
				atta = 70;
				arp = 1;
				rang = 3.1;
			}
			if (argument0 = "Power Weapon") {
				atta = 120;
				arp = 0;
				rang = 1;
			}
			if (argument0 = "Power Sword") {
				atta = 120;
				arp = 0;
				rang = 1;
			}
			if (argument0 = "Force Weapon") {
				atta = 400;
				arp = 1;
				rang = 1;
			}
			if (argument0 = "Chainfist") {
				atta = 300;
				arp = 1;
				rang = 1;
				spli = 3;
			}
			if (argument0 = "Meltagun") {
				atta = 200;
				arp = 1;
				rang = 2;
				amm = 4;
			}
			if (argument0 = "Flamer") {
				atta = 160;
				arp = 0;
				rang = 2.1;
				amm = 4;
				spli = 3;
			}
			if (argument0 = "Heavy Flamer") {
				atta = 250;
				arp = 0;
				rang = 2.1;
				amm = 6;
				spli = 3;
			}
			if (argument0 = "Combi-Flamer") {
				atta = 160;
				arp = 0;
				rang = 2.1;
				amm = 1;
				spli = 3;
			}
			if (argument0 = "Bolter") {
				atta = 45;
				arp = 0;
				rang = 12;
				amm = 15;
				if (obj_ncombat.enemy = 5) then atta = 35;
			} // Bursts
			if (argument0 = "Power Fist") {
				atta = 425;
				arp = 1;
				rang = 1;
			}
			if (argument0 = "Possessed Claws") {
				atta = 250;
				arp = 1;
				rang = 1;
				spli = 3;
			}
			if (argument0 = "Missile Launcher") {
				atta = 200;
				arp = 1;
				rang = 20;
				amm = 4;
				spli = 3;
			}
			if (argument0 = "Chainsword") {
				atta = 45;
				arp = 0;
				rang = 1;
			}
			if (argument0 = "Bolt Pistol") {
				atta = 35;
				arp = 0;
				rang = 3.1;
				amm = 18;
			}
			if (argument0 = "Chainaxe") {
				atta = 55;
				arp = 0;
				rang = 1;
			}
			if (argument0 = "Poisoned Chainsword") {
				atta = 90;
				arp = 0;
				rang = 1;
				if (obj_ini.preomnor = 1) {
					atta = 130;
				}
			}
			if (argument0 = "Sonic Blaster") {
				atta = 120;
				arp = 0;
				rang = 3;
				spli = 3;
			}
			if (argument0 = "Rubric Bolter") {
				atta = 80;
				arp = 0;
				rang = 12;
				amm = 15;
			} // Bursts
			if (argument0 = "Witchfire") {
				atta = 200;
				arp = 1;
				rang = 5.1;
			}
			if (argument0 = "Autogun") {
				atta = 20;
				arp = 0;
				rang = 6;
				amm = 12;
			}
			if (argument0 = "Storm Bolter") {
				atta = 65;
				arp = 0;
				rang = 8;
				amm = 10;
				spli = 3;
			}
			if (argument0 = "Lascannon") {
				atta = 200;
				arp = 1;
				rang = 20;
				amm = 8;
			}
			if (argument0 = "Twin Linked Heavy Bolters") {
				atta = 240;
				arp = 0;
				rang = 16;
				spli = 3;
			}
			if (argument0 = "Twin-Linked Heavy Bolters") {
				atta = 240;
				arp = 0;
				rang = 16;
				spli = 3;
			}
			if (argument0 = "Twin Linked Lascannon") {
				atta = 300;
				arp = 1;
				rang = 20;
			}
			if (argument0 = "Twin-Linked Lascannon") {
				atta = 300;
				arp = 1;
				rang = 20;
			}
			if (argument0 = "Battle Cannon") {
				atta = 300;
				arp = 1;
				rang = 12;
			}
			if (argument0 = "Demolisher Cannon") {
				atta = 500;
				arp = 1;
				rang = 2;
				if (instance_exists(obj_nfort)) then rang = 5;
			}
			if (argument0 = "Earthshaker Cannon") {
				atta = 300;
				arp = 0;
				rang = 12;
				spli = 3;
			}
			if (argument0 = "Havoc Launcher") {
				atta = 100;
				arp = 0;
				rang = 12;
			}
			if (argument0 = "Baleflame") {
				atta = 120;
				arp = 0;
				rang = 2;
			}
			if (argument0 = "Defiler Claws") {
				atta = 350;
				arp = 1;
				rang = 1;
				spli = 3;
			}
			if (argument0 = "Reaper Autocannon") {
				atta = 320;
				arp = 0;
				rang = 18;
				amm = 10;
				spli = 3;
			}

			if (name = "Ripper Gun") {
				atta = 40;
				arp = 0;
				rang = 3;
				amm = 5;
				spli = 0;
			}
			if (name = "Ogryn Melee") {
				atta = 90;
				arp = 0;
				rang = 1;
			}
			if (name = "Multi-Laser") {
				atta = choose(60, 75, 90, 105);
				arp = 0;
				rang = 10;
			}

			if (argument0 = "Blessed Weapon") {
				atta = 150;
				arp = 1;
				rang = 1;
			}
			if (argument0 = "Electro-Flail") {
				atta = 125;
				arp = 1;
				rang = 1;
				spli = 3;
			}
			if (argument0 = "Neural Whip") {
				atta = 85;
				arp = 0;
				rang = 1;
				spli = 3
			}
			if (argument0 = "Sarissa") {
				atta = 65;
				arp = 0;
				rang = 2;
			}
			if (argument0 = "Seraphim Pistols") {
				atta = 200;
				arp = 1;
				rang = 4;
			}
			if (argument0 = "Laser Mace") {
				atta = 200;
				arp = 1;
				rang = 5.1;
				amm = 3;
			}
			if (argument0 = "Heavy Bolter") {
				atta = 120;
				arp = 0;
				rang = 16;
				spli = 0;
			}

			if (name = "Lasgun") {
				atta = 20;
				arp = 0;
				rang = 6;
				amm = 30;
			}
			if (name = "Daemonhost Claws") {
				atta = 350;
				arp = 1;
				rang = 1;
				spli = 3;
			}
			if (name = "Daemonhost_Powers") {
				atta = round(random_range(100, 300));
				arp = round(random_range(100, 300));
				rang = round(random_range(1, 6));
				spli = choose(0, 1);
			}
		}

		if (obj_ncombat.enemy = 13) { // Some of these, like the Gauss Particle Cannon and Particle Whip, used to be more than twice as strong.
			if (name = "Staff of Light") {
				atta = 200;
				arp = 1;
				rang = 1;
				spli = 3;
			}
			if (name = "Staff of Light Shooting") {
				atta = 180;
				arp = 0;
				rang = 3;
				spli = 3;
			}
			if (name = "Warscythe") {
				atta = 200;
				arp = 1;
				rang = 1;
				spli = 0;
			}
			if (name = "Gauss Flayer") {
				atta = choose(50, 50, 50, 50, 50, 70);
				atta = choose(30, 30, 30, 30, 30, 70);
				rang = 6.1;
				spli = 0;
			}
			if (name = "Gauss Blaster") {
				atta = choose(70, 70, 70, 70, 70, 100);
				arp = choose(0, 0, 0, 0, 0, 1);
				rang = 6.1;
				spli = 0;
			}
			if (name = "Gauss Cannon") {
				atta = 180;
				arp = 1;
				rang = 10;
				spli = 3;
			}
			if (name = "Gauss Particle Cannon") {
				atta = 300;
				arp = 1;
				rang = 10.1;
				spli = 3;
			}
			if (name = "Overcharged Gauss Cannon") {
				atta = 250;
				arp = 1;
				rang = 8.1;
				spli = 3;
			}
			if (name = "Wraith Claws") {
				atta = 80;
				arp = 1;
				rang = 1;
				spli = 0;
			}
			if (name = "Claws") {
				atta = 300;
				arp = 1;
				rang = 1;
				spli = 0;
			}
			if (name = "Gauss Flux Arc") {
				atta = 180;
				arp = 1;
				rang = 8;
				spli = 3;
			}
			if (name = "Particle Whip") {
				atta = 300;
				arp = 1;
				rang = 4.1;
				spli = 3;
			}
			if (name = "Gauss Flayer Array") {
				atta = 180;
				arp = 1;
				rang = 8.1;
				spli = 3;
			}
			if (name = "Doomsday Cannon") {
				atta = 300;
				arp = 1;
				rang = 6.1;
				spli = 3;
			}
		}
	}

	if (faith_bonus = 1) then atta = atta * 2;
	if (faith_bonus = 2) then atta = atta * 3;
	atta = round(atta * obj_ncombat.global_defense);
	arp = round(arp * obj_ncombat.global_defense);

	if (obj_ncombat.enemy = 1) {
		// more attack crap here
		if (rang <= 1) or(floor(rang) != rang) then atta = round(atta * dudes_attack[group]);
		if (rang > 1) and(floor(rang) == rang) then atta = round(atta * dudes_ranged[group]);
	}

	if (is_man = false) then amm = -1;

	var b, goody, first;
	b = 0;
	goody = 0;
	first = 0;
	repeat(30) {
		b += 1;
		if (wep[b] = name) and(goody = 0) {
			att[b] += atta * man_number;
			apa[b] += arp * man_number;
			range[b] = rang;
			wep_num[b] += man_number;
			if (obj_ncombat.started = 0) then ammo[b] = amm;
			goody = 1;

			if (wep_owner[b] != "") or(man_number > 1) then wep_owner[b] = "assorted";
			if (wep_owner[b] = "") and(man_number = 1) then wep_owner[b] = man_type;
		}
		if (wep[b] = "") and(first = 0) then first = b;
	}
	if (goody = 0) {
		wep[first] = name;
		splash[first] = spli;
		att[first] += atta * man_number;
		apa[first] += arp * man_number;
		range[first] = rang;
		wep_num[first] += man_number;
		if (obj_ncombat.started = 0) then ammo[first] = amm;
		goody = 1;

		if (man_number = 1) then wep_owner[first] = man_type;
		if (man_number > 1) then wep_owner[first] = "assorted";
	}

	/*
	wep[i]="";
	combi[i]=0;
	range[i]=0;
	att[i]=0;
	apa[i]=0;
	*/
}