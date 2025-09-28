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
	// var struct = gear_weapon_data("weapon",name);
	if (string_count("elee", name) > 0) {
		var to = string_delete(name, 0, 5);
		atta = 10;
		arp = 0;
		rang = 1;
		spli = 3;
	}

	//if (obj_ncombat.enemy=5) then faith_bonus=faith[man_type];
	switch(name){
		case "Venom Claws":
			atta = 200;
			arp = 0;
			rang = 1;
			spli = 0;
			if (obj_ini.preomnor == 1) { atta = 240; }
			break;
		case "Web Spinner":
			atta = 40;
			arp = 0;
			rang = 2.1;
			spli = 3;
			amm = 1;
			break;
		case "Warpsword":
			atta = 300;
			arp = 1;
			rang = 1;
			spli = 3;
			break;
		case"Iron Claw":
			atta = 400;
			arp = 1;
			rang = 1;
			spli = 0;
			break;
		case "Maulerfiend Claws":
			atta = 300;
			arp = 300;
			rang = 1;
			spli = 3;
			break;
		case "Eldritch Fire":
			atta = 80;
			arp = 1;
			rang = 5.1;
			break;
		case "Bloodletter Melee":
			atta = 70;
			arp = 0;
			rang = 1;
			spli = 3;
			break;
		case "Daemonette Melee":
			atta = 65;
			arp = 0;
			rang = 1;
			spli = 3;
			break;
		case "Plaguebearer Melee":
			atta = 60;
			arp = 0;
			rang = 1;
			spli = 3;
			if (obj_ini.preomnor == 1) { atta = 70; }
			break;
		case "Khorne Demon Melee":
			atta = 350;
			arp = 1;
			rang = 1;
			spli = 3;
			break;
		case "Demon Melee":
			atta = 250;
			arp = 1;
			rang = 1;
			spli = 3;
			break;
		case "Lash Whip":
			atta = 80;
			arp = 0;
			rang = 2;
			break;
		case "Nurgle Vomit":
			atta = 100;
			arp = 0;
			rang = 2;
			spli = 3;
			if (obj_ini.preomnor == 1) { atta = 260; }
			break;
		case "Multi-Melta":
			atta = 200;
			arp = 1;
			rang = 4.1;
			spli = 0;
			amm = 6;
			break;
		default:
	        show_debug_message("Incorrect name: " + string(name) + " line 123 script scr_en_weapon.gml");
	        break;
	}
	switch(obj_ncombat.enemy){
		case 3:
			switch(name){
				case "Phased Plasma-fusil":
					atta = 100;
					arp = 1;
					rang = 7.1;
					spli = 3;
					break;
				case "Lightning Gun":
					atta = choose(80, 80, 80, 150);
					arp = 0;
					rang = 5;
					spli = 0;
					break;
				case "Thallax Melee":
					atta = 80;
					arp = 0;
					rang = 1;
					spli = 3;
					break;
				default:
			        show_debug_message("Incorrect name: " + string(name) + " line 149 script scr_en_weapon.gml");
			        break;
			}
			break;
		case 6:
			switch(name){
				case "Fusion Gun": case "Firepike":
					atta = 200;
					arp = 1;
					rang = 2;
					amm = 4;
					break;
				case"Singing Spear":
					atta = 120;
					arp = 0;
					rang = 1;
					spli = 3;
					break;
				case "Singing Spear Throw":
					atta = 120;
					arp = 1;
					rang = 2;
					spli = 3;
					break;
				case "Witchblade":
					atta = 100;
					arp = 1;
					rang = 1;
					break;
				case "Psyshock":
					atta = 50;
					arp = 0;
					rang = 2;
					break;
				case "Wailing Doom":
					atta = 200;
					arp = 1;
					rang = 1;
					spli = 3;
					break;
				case "Avatar Smite":
					atta = 300;
					arp = 1;
					rang = 2;
					amm = 2;
					break;
				case "Ranger Long Rifle":
					atta = 60;
					arp = 0;
					rang = 25;
					break;
				case "Pathfinder Long Rifle":
					atta = 70;
					arp = 0;
					rang = 25;
					break;
				case "Shuriken Catapult":
					atta = 35;
					arp = 0;
					rang = 2;
					break;
				case "Twin Linked Shuriken Catapult":
					atta = 50;
					arp = 0;
					rang = 2;
					break;
				case "Avenger Shuriken Catapult":
					atta = 40;
					arp = 0;
					rang = 3;
					break;
				case "Power Weapon": case "Power Blades":
					atta = 80;
					arp = 0;
					rang = 1;
					spli = 3;
					break;
				case "Shuriken Pistol":
					atta = 25;
					arp = 0;
					rang = 2.1;
					break;
				case "Executioner":
					atta = 200;
					arp = 1;
					rang = 1;
					break;
				case "Scorpion Chainsword":
					atta = 40;
					arp = 0;
					rang = 1;
					spli = 3;
					break;
				case "Mandiblaster":
					atta = 20;
					arp = 0;
					rang = 1;
					break;
				case "Biting Blade":
					atta = 70;
					arp = 0;
					rang = 1;
					spli = 3;
					break;
				case "Scorpian's Claw": case "Scorpion's Claw":
					atta = 150;
					arp = 1;
					rang = 1;
					spli = 3;
					break;
				case "Meltabomb":
					atta = 0;
					arp = 200;
					rang = 1;
					amm = 1;
					break;
				case "Deathspinner":
					atta = 50;
					arp = 0;
					rang = 2;
					break;
				case "Dual Deathspinner":
					atta = 80;
					arp = 0;
					rang = 2;
					break;
				case "Reaper Launcher":
					atta = 150;
					arp = 80;
					rang = 20;
					amm = 8;
					spli = 3;
					break;
				case "Eldar Missile Launcher":
					atta = 200;
					arp = 1;
					rang = 20;
					amm = 4;
					spli = 3;
					break;
				case "Laser Lance":
					atta = 80;
					arp = 0;
					rang = 2;
					spli = 3;
					break;
				case "Fusion Pistol":
					atta = 100;
					arp = 1;
					rang = 1.1;
					amm = 4;
					break;
				case "Plasma Pistol":
					atta = 60;
					arp = 1;
					rang = 3.1;
					break;
				case "Harlequin's Kiss":
					atta = 350;
					arp = 0;
					rang = 1;
					amm = 1;
					break;
				case "Wraithcannon":
					atta = 80;
					arp = 1;
					rang = 2.1;
					break;
				case "Pulse Laser":
					atta = 80;
					arp = 1;
					rang = 15;
					break;
				case "Bright Lance":
					atta = 100;
					arp = 1;
					rang = 8;
					break;
				case "Shuriken Cannon":
					atta = 65;
					arp = 0;
					rang = 3;
					break;
				case "Prism Cannon":
					atta = 250;
					arp = 1;
					rang = 20;
					break;
				case "Twin Linked Doomweaver":
					atta = 100;
					arp = 0;
					rang = 2;
					break; // Also create difficult terrain?
				case "Starcannon":
					atta = 140;
					arp = 1;
					rang = 3;
					spli = 3;
					break;
				case "Two Power Fists":
					atta = 300;
					arp = 1;
					rang = 1;
					break;
				case "Flamer":
					atta = 100;
					arp = 0;
					rang = 2;
					amm = 4;
					spli = 3;
					break;
				case "Titan Starcannon":
					atta = 220;
					arp = 1;
					rang = 4;
					spli = 3;
					break;
				case "Phantom Pulsar":
					atta = 500;
					arp = 1;
					rang = 20;
					spli = 3;
					break;
				default:
			        show_debug_message("Incorrect name: " + string(name) + " line 372 script scr_en_weapon.gml");
			        break;
			}
			break;
		case 7:
			switch(name){
				case  "Choppa":
					atta = 28;
					arp = 0;
					rang = 1;
					spli = 3;
					break;
				case "Power Klaw":
					atta = 150;
					arp = 1;
					rang = 1;
					spli = 3;
					break;
				case "Slugga":
					atta = 27;
					arp = 0;
					rang = 3.1;
					amm = 4;
					spli = 3;
					break;
				case "Tankbusta Bomb":
					atta = 264;
					arp = 1;
					rang = 1;
					amm = 1;
					spli = 0;
					break;
				case "Big Shoota":
					atta = 100;
					arp = 0;
					rang = 12;
					amm = 30;
					spli = 0;
					break;
				case "Dakkagun":
					atta = 150;
					arp = 0;
					rang = 10;
					amm = 20;
					spli = 0;
					break;
				case "Deffgun":
					atta = 120;
					arp = 0;
					rang = 8;
					amm = 20;
					spli = 0;
					break;
				case "Snazzgun":
					atta = 80;
					arp = 0;
					rang = 10;
					spli = 0;
					break;
				case "Grot Blasta":
					atta = 12;
					arp = 0;
					rang = 2;
					amm = 6;
					break;
				case "Kannon":
					atta = 200;
					arp = 1;
					rang = 10.1;
					amm = 5;
					spli = 3;
					break;
				case "Shoota":
					atta = 30;
					arp = 0;
					rang = 6;
					break;
				case "Burna":
					atta = 140;
					arp = 1;
					rang = 2;
					amm = 4;
					spli = 3;
					break;
				case "Skorcha":
					atta = 160;
					arp = 1;
					rang = 2;
					amm = 6;
					spli = 3;
					break;
				case "Rokkit Launcha":
					atta = 150;
					arp = 1;
					rang = 15;
					spli = 3;
					break;
				case "Krooz Missile":
					atta = 250;
					arp = 1;
					rang = 15;
					spli = 3;
					break;
				default:
			        show_debug_message("Incorrect name: " + string(name) + " line 476 script scr_en_weapon.gml");
			        break;
			}
			break;
		case 8:
			switch(name){
				case "Fusion Blaster":
					atta = 200;
					arp = 1;
					rang = 2;
					amm = 4;
					break;
				case "Plasma Rifle":
					atta = 120;
					arp = 1;
					rang = 10;
					break;
				case "Cyclic Ion Blaster":
					atta = 180;
					arp = 0;
					rang = 6;
					spli = 3;
					break; // x6
				case "Burst Rifle":
					atta = 130;
					arp = 0;
					rang = 16;
					spli = 3;
					break;
				case "Missile Pod":
					atta = 160;
					arp = 1;
					rang = 15;
					amm = 6;
					spli = 3;
					break;
				case "Smart Missile System":
					atta = 150;
					arp = 1;
					rang = 15;
					break;
				case "Small Railgun":
					atta = 150;
					arp = 1;
					rang = 18;
					break;
				case "Pulse Rifle":
					atta = 37;
					arp = 0;
					rang = 12;
					break;
				case "Rail Rifle":
					atta = 65;
					arp = 0;
					rang = 14;
					break;
				case "Kroot Rifle":
					atta = 25;
					arp = 0;
					rang = 6;
					break;
				case "Vespid Crystal":
					atta = 60;
					arp = 0;
					rang = 2.1;
					break;
				case "Railgun":
					atta = 400;
					arp = 1;
					rang = 20;
					break;
				default:
			        show_debug_message("Incorrect name: " + string(name) + " line 548 script scr_en_weapon.gml");
			        break;
			}
			break;
		case 9:
			switch(name){
				case "Bonesword":
					atta = 120;
					arp = 0;
					rang = 1;
					spli = 3;
					break;
				case "Lash Whip":
					atta = 80;
					arp = 0;
					rang = 2;
					break;
				case "Heavy Venom Cannon":
					atta = 150;
					arp = 1;
					rang = 8;
					break;
				case "Crushing Claws":
					atta = 90;
					arp = 1;
					rang = 1;
					spli = 3;
					break;
				case "Rending Claws":
					atta = 80;
					arp = 1;
					rang = 1;
					spli = 3;
					break;
				case "Devourer":
					atta = choose(40, 60, 80, 100);
					arp = 0;
					rang = 5;
					if (obj_ini.preomnor == 1) { atta = choose(48, 72, 96, 120); }
					break;
				case "Zoanthrope Blast":
					atta = 200;
					arp = 1;
					rang = 2;
					break;
				case "Carnifex Claws":
					atta = 300;
					arp = 1;
					rang = 1;
					spli = 3;
					break;
				case "Venom Cannon":
					atta = 150;
					arp = 0;
					rang = 5;
					break;
				case "Deathspitter":
					atta = 100;
					arp = 0;
					rang = 2.1;
					if (obj_ini.preomnor == 1) { atta = 120; }
					break;
				case "Fleshborer":
					atta = 15;
					arp = 0;
					rang = 2.1;
					if (obj_ini.preomnor == 1) { atta = 19; }
					break;
				case "Scything Talons":
					atta = 30;
					arp = 0;
					rang = 1;
					break;
				case "Genestealer Claws":
					atta = choose(105, 105, 130);
					arp = 1;
					rang = 1;
					break;
				case "Witchfire":
					atta = 100;
					arp = 1;
					rang = 2;
					break;
				case "Autogun":
					atta = 20;
					arp = 0;
					rang = 6;
					amm = 12;
					spli = 3;
					break;
				case "Lictor Claws":
					atta = 300;
					arp = 0;
					rang = 1;
					break;
				case "Flesh Hooks":
					atta = 50;
					arp = 0;
					rang = 2;
					amm = 1;
					break;
				default:
			        show_debug_message("Incorrect name: " + string(name) + " line 650 script scr_en_weapon.gml");
			        break;
			}
			break;
		case 10: case 2: case 5: case 1:
			switch(name){
				case "Plasma Pistol":
					atta = 70;
					arp = 1;
					rang = 3.1;
					break;
				case "Power Weapon":
					atta = 120;
					arp = 0;
					rang = 1;
					break;
				case "Power Sword":
					atta = 120;
					arp = 0;
					rang = 1;
					break;
				case "Force Weapon":
					atta = 400;
					arp = 1;
					rang = 1;
					break;
				case "Chainfist":
					atta = 300;
					arp = 1;
					rang = 1;
					spli = 3;
					break;
				case "Meltagun":
					atta = 200;
					arp = 1;
					rang = 2;
					amm = 4;
					break;
				case "Flamer":
					atta = 160;
					arp = 0;
					rang = 2.1;
					amm = 4;
					spli = 3;
					break;
				case "Heavy Flamer":
					atta = 250;
					arp = 0;
					rang = 2.1;
					amm = 6;
					spli = 3;
					break;
				case "Combi-Flamer":
					atta = 160;
					arp = 0;
					rang = 2.1;
					amm = 1;
					spli = 3;
					break;
				case "Bolter":
					atta = 45;
					arp = 0;
					rang = 12;
					amm = 15;
					if (obj_ncombat.enemy == 5) { atta = 35; }
					break; // Bursts
				case "Power Fist":
					atta = 425;
					arp = 1;
					rang = 1;
					break;
				case "Possessed Claws":
					atta = 250;
					arp = 1;
					rang = 1;
					spli = 3;
					break;
				case "Missile Launcher":
					atta = 200;
					arp = 1;
					rang = 20;
					amm = 4;
					spli = 3;
					break;
				case "Chainsword":
					atta = 45;
					arp = 0;
					rang = 1;
					break;
				case "Bolt Pistol":
					atta = 35;
					arp = 0;
					rang = 3.1;
					amm = 18;
					break;
				case "Chainaxe":
					atta = 55;
					arp = 0;
					rang = 1;
					break;
				case "Poisoned Chainsword":
					atta = 90;
					arp = 0;
					rang = 1;
					if (obj_ini.preomnor == 1) { atta = 130; }
					break;
				case "Sonic Blaster":
					atta = 120;
					arp = 0;
					rang = 3;
					spli = 3;
					break;
				case "Rubric Bolter":
					atta = 80;
					arp = 0;
					rang = 12;
					amm = 15;
					break; // Bursts
				case "Witchfire":
					atta = 200;
					arp = 1;
					rang = 5.1;
					break;
				case "Autogun":
					atta = 20;
					arp = 0;
					rang = 6;
					amm = 12;
					break;
				case "Storm Bolter":
					atta = 65;
					arp = 0;
					rang = 8;
					amm = 10;
					spli = 3;
					break;
				case "Lascannon":
					atta = 200;
					arp = 1;
					rang = 20;
					amm = 8;
					break;
				case "Twin Linked Heavy Bolters":
					atta = 240;
					arp = 0;
					rang = 16;
					spli = 3;
					break;
				case "Twin-Linked Heavy Bolters":
					atta = 240;
					arp = 0;
					rang = 16;
					spli = 3;
					break;
				case "Twin Linked Lascannon":
					atta = 300;
					arp = 1;
					rang = 20;
					break;
				case "Twin-Linked Lascannon":
					atta = 300;
					arp = 1;
					rang = 20;
					break;
				case "Battle Cannon":
					atta = 300;
					arp = 1;
					rang = 12;
					break;
				case "Demolisher Cannon":
					atta = 500;
					arp = 1;
					rang = 2;
					if (instance_exists(obj_nfort)) { rang = 5; }
					break;
				case "Earthshaker Cannon":
					atta = 300;
					arp = 0;
					rang = 12;
					spli = 3;
					break;
				case "Havoc Launcher":
					atta = 100;
					arp = 0;
					rang = 12;
					break;
				case "Baleflame":
					atta = 120;
					arp = 0;
					rang = 2;
					break;
				case "Defiler Claws":
					atta = 350;
					arp = 1;
					rang = 1;
					spli = 3;
					break;
				case "Reaper Autocannon":
					atta = 320;
					arp = 0;
					rang = 18;
					amm = 10;
					spli = 3;
					break;
				case "Ripper Gun":
					atta = 40;
					arp = 0;
					rang = 3;
					amm = 5;
					spli = 0;
					break;
				case "Ogryn Melee":
					atta = 90;
					arp = 0;
					rang = 1;
					break;
				case "Multi-Laser":
					atta = choose(60, 75, 90, 105);
					arp = 0;
					rang = 10;
					break;
				case "Blessed Weapon":
					atta = 150;
					arp = 1;
					rang = 1;
					break;
				case "Electro-Flail":
					atta = 125;
					arp = 1;
					rang = 1;
					spli = 3;
					break;
				case "Neural Whip":
					atta = 85;
					arp = 0;
					rang = 1;
					spli = 3
					break;
				case "Sarissa":
					atta = 65;
					arp = 0;
					rang = 2;
					break;
				case "Seraphim Pistols":
					atta = 200;
					arp = 1;
					rang = 4;
					break;
				case "Laser Mace":
					atta = 200;
					arp = 1;
					rang = 5.1;
					amm = 3;
					break;
				case "Heavy Bolter":
					atta = 120;
					arp = 0;
					rang = 16;
					spli = 0;
					break;
				case "Lasgun":
					atta = 20;
					arp = 0;
					rang = 6;
					amm = 30;
					break;
				case "Daemonhost Claws":
					atta = 350;
					arp = 1;
					rang = 1;
					spli = 3;
					break;
				case "Daemonhost_Powers":
					atta = round(random_range(100, 300));
					arp = round(random_range(100, 300));
					rang = round(random_range(1, 6));
					spli = choose(0, 1);
					break;
				default:
			        show_debug_message("Incorrect name: " + string(name) + " line 929 script scr_en_weapon.gml");
			        break;
			}
			break;
		case 13: // Some of these, like the Gauss Particle Cannon and Particle Whip, used to be more than twice as strong.
			switch(name){
				case "Staff of Light":
					atta = 200;
					arp = 1;
					rang = 1;
					spli = 3;
					break;
				case "Staff of Light Shooting":
					atta = 180;
					arp = 0;
					rang = 3;
					spli = 3;
					break;
				case "Warscythe":
					atta = 200;
					arp = 1;
					rang = 1;
					spli = 0;
					break;
				case "Gauss Flayer":
					atta = choose(30, 30, 30, 50, 50, 70);
					rang = 6.1;
					spli = 0;
					break;
				case "Gauss Blaster":
					atta = choose(70, 70, 70, 70, 70, 100);
					arp = choose(0, 0, 0, 0, 0, 1);
					rang = 6.1;
					spli = 0;
					break;
				case "Gauss Cannon":
					atta = 180;
					arp = 1;
					rang = 10;
					spli = 3;
					break;
				case "Gauss Particle Cannon":
					atta = 300;
					arp = 1;
					rang = 10.1;
					spli = 3;
					break;
				case "Overcharged Gauss Cannon":
					atta = 250;
					arp = 1;
					rang = 8.1;
					spli = 3;
					break;
				case "Wraith Claws":
					atta = 80;
					arp = 1;
					rang = 1;
					spli = 0;
					break;
				case "Claws":
					atta = 300;
					arp = 1;
					rang = 1;
					spli = 0;
					break;
				case "Gauss Flux Arc":
					atta = 180;
					arp = 1;
					rang = 8;
					spli = 3;
					break;
				case "Particle Whip":
					atta = 300;
					arp = 1;
					rang = 4.1;
					spli = 3;
					break;
				case "Gauss Flayer Array":
					atta = 180;
					arp = 1;
					rang = 8.1;
					spli = 3;
					break;
				case "Doomsday Cannon":
					atta = 300;
					arp = 1;
					rang = 6.1;
					spli = 3;
					break
				default:
			        show_debug_message("Incorrect name: " + string(name) + " line 1019 script scr_en_weapon.gml");
			        break;
			}
			break;
	}

	switch(faith_bonus){
		case 1:
			atta = atta * 2;
			break;
		case 2:
			atta = atta * 3;
			break;
	}
	
	atta = round(atta * obj_ncombat.global_defense);
	arp = round(arp * obj_ncombat.global_defense);

	if (obj_ncombat.enemy = 1) {
		// more attack crap here
		if (rang <= 1) || (floor(rang) != rang) { atta = round(atta * dudes_attack[group]); }
		if (rang > 1) && (floor(rang) == rang) { atta = round(atta * dudes_ranged[group]); }
	}

	if (!is_man) { amm = -1; }

	var goody = 0;
	var first = -1;
	for(var b = 0; b < 30; b++) {
		if (wep[b] == name) && (goody == 0) {
			att[b] += atta * man_number;
			apa[b] += arp * man_number;
			range[b] = rang;
			wep_num[b] += man_number;
			if (obj_ncombat.started == 0) { ammo[b] = amm; }
			goody = 1;

			if (wep_owner[b] != "") || (man_number > 1) { wep_owner[b] = "assorted"; }
			if (wep_owner[b] == "") && (man_number == 1) { wep_owner[b] = man_type; }
		}
		if (wep[b] == "") && (first == -1) { first = b; }
	}
	if (goody == 0) {
		wep[first] = name;
		splash[first] = spli;
		att[first] += atta * man_number;
		apa[first] += arp * man_number;
		range[first] = rang;
		wep_num[first] += man_number;
		if (obj_ncombat.started == 0) { ammo[first] = amm; }
		goody = 1;

		if (man_number == 1) { wep_owner[first] = man_type; }
		if (man_number > 1) { wep_owner[first] = "assorted"; }
	}

	/*
	wep[i]="";
	range[i]=0;
	att[i]=0;
	apa[i]=0;
	*/
}