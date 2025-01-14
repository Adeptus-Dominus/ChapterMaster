function scr_add_man(man_role, target_company, spawn_exp, spawn_name, corruption, other_gear, home_spot, other_data = {}) {

	//all of this will in time be irrelevant as calling new TTRPG_stats() and then calling the correct methods within the new itme will replace this but for
	//now its easy enough to use this as the structs continue to be built.
	// other_gear = gear provided?
	// home_spot = home, shipXY, or default

	// TODO refactor repeats

	// That should be sufficient to add stuff in a highly modifiable fashion

	var non_marine_roles = ["Skitarii", "Techpriest", "Crusader", "Sister of Battle", "Sister Hospitaler", "Ranger", "Ork Sniper", "Flash Git"]; // if adding new hirelings, don't forget to update this list
	var _gear = {};
	var i = 0,
		e = 0,
		good = 0,
		wep1 = "",
		wep2 = "",
		gear = "",
		mobi = "",
		arm = "",
		missing = 0;

	good = find_company_open_slot(target_company);

	if (good != -1) {
		scr_wipe_unit(target_company,good);
		unit = fetch_unit([target_company,good]);
		if (other_gear = true) {
	// Factions 1-5 are part of Imperial family
		// Faction 1 - Space Marine
			/* TODO - add the right faction stuff, and move the "switch (man_role) {" before uncommenting
			case "Chapter Servitor":
				obj_ini.wep1[target_company][good] = "Combat Knife"; TODO - consider creating a melee mechadendrite instead?
				obj_ini.wep2[target_company][good] = "";
				obj_ini.armour[target_company][good] = "Scout Armour";
				obj_ini.mobi[target_company][good] = "Servo-arm";
				obj_ini.race[target_company][good] = 1;
				unit = new TTRPG_stats("astartes", target_company, good, "scout");
				break;
			*/
			/* TODO - add "neophyte" in scr_marine_struct
			case "Neophyte":
				obj_ini.wep1[target_company][good] = "Bolt Pistol";
				obj_ini.wep2[target_company][good] = "Combat Knife";
				obj_ini.armour[target_company][good] = "Scout Armour";
				obj_ini.race[target_company][good] = 1;
				unit = new TTRPG_stats("astartes", target_company, good, "scout");
				break;
			*/
			/* TODO - add "serf" and the related stuff
			case "Serf":
				obj_ini.wep1[target_company][good] = "Bolt Pistol";
				obj_ini.wep2[target_company][good] = "Combat Knife";
				obj_ini.armour[target_company][good] = "Scout Armour";
				obj_ini.race[target_company][good] = 1;
				unit = new TTRPG_stats("astartes", target_company, good, "scout");
				break;
			*/
		// Bit funny that CSMs are not 1.5...
		// Faction 2 - Homo Sapiens Imperialis
			/* TODO - add regular human stats, in scr_marine_struct
			case "Mercenary":
				obj_ini.wep1[target_company][good] = "Hellgun"; TODO - consider weapon options
				obj_ini.wep2[target_company][good] = "Combat Knife";
				obj_ini.armour[target_company][good] = "Scout Armour"; TODO - add imperial armour
				obj_ini.experience[target_company][good] = 10;
				obj_ini.race[target_company][good] = 2;
				unit = new TTRPG_stats("astartes", target_company, good, "scout"); TODO - add regular human stat lines
				break;
			*/
			// Might want to add Kasrkin and Ogryn hireling types
		// Faction 2.5 - Renegades
			/*
			case "Auxiliary Soldier":
				obj_ini.wep1[target_company][good] = "Hellgun"; TODO - consider weapon options
				obj_ini.wep2[target_company][good] = "Combat Knife";
				obj_ini.armour[target_company][good] = "Scout Armour"; TODO - add imperial armour
				obj_ini.experience[target_company][good] = 10;
				obj_ini.race[target_company][good] = 2.5;
				unit = new TTRPG_stats("renegades", target_company, good, "human"); TODO - add proper stat lines
				break;
			*/
		// Faction 3 - Adeptus Mechanicus
		switch (man_role) {
			case "Skitarii":
				spawn_exp = 10;
				obj_ini.race[target_company][good] = 3;
				unit = new TTRPG_stats("mechanicus", target_company, good, "skitarii");
				break;
			case "Techpriest":

				spawn_exp = 100;
				obj_ini.race[target_company][good] = 3;
				unit = new TTRPG_stats("mechanicus", target_company, good, "tech_priest");
				break
		// Faction 3.5 - Dark mechanicum?
		// Faction 4 - Inquisition
			case "Crusader":
				spawn_exp = 10;
				obj_ini.race[target_company][good] = 4;
				unit = new TTRPG_stats("inquisition", target_company, good, "inquisition_crusader");
				break;
			/* TODO - add capability for hirelings to have psychic powers and related stats
			case "Sanctioned Psyker":
				obj_ini.wep1[target_company][good] = "Force Staff"; TODO - consider adding regular human version
				obj_ini.wep2[target_company][good] = "Laspistol";
				obj_ini.armuor[target_company][good] = "Power Armour"; TODO - consider adding imperial armour
				obj_ini.gear[target_company][good] = "Psychic Hood"; TODO - consider adding regular human version
				obj_ini.experience[target_company][good] = 50;
				obj_ini.race[target_company][good] = 4;
				unit = new TTRPG_stats("inquisition", target_company, good, "sanctioned_psyker"); TODO - add proper stat lines
				break;
			*/
		// Faction 4.5 - Radical inquisitors, perhaps?
		// Faction 5 - Sisters of Battle
			case "Sister of Battle":
				spawn_exp = 20;
				obj_ini.race[target_company][good] = 5;
				unit = new TTRPG_stats("adeptus_sororitas", target_company, good, "sister_of_battle");
				break;
			case "Sister Hospitaler":
				spawn_exp = 50;
				obj_ini.race[target_company][good] = 5;
				unit = new TTRPG_stats("adeptus_sororitas", target_company, good, "sister_hospitaler");
				break;
			/* TODO - if we get to recruiting allied or other leaders, lot of stuff needs to be implemented
			case "Prioress":
				obj_ini.wep1[target_company][good] = "Bolter"; TODO - give a cool weapon
				obj_ini.wep2[target_company][good] = ""; TODO - same
				obj_ini.armour[target_company][good] = "Power Armour"; TODO - Give cool armour
				obj_ini.experience[target_company][good] = 200;
				obj_ini.gear[target_company][good] = "Sororitas Medkit"; TODO - give cool gear
				obj_ini.race[target_company][good] = 5;
				unit = new TTRPG_stats("adeptus_sororitas", target_company, good, "prioress");
				break;
			*/
		// Faction 5.5 - Fallen sisters?
	// End of Imperials
		// Faction 6 - Eldar
			case "Ranger":
				spawn_exp = 180; // They should have much more EXP (like 250 or more) as they have quite the lifespan
				obj_ini.race[target_company][good] = 6
				unit = new TTRPG_stats("Eldari", target_company, good, "eldar_ranger"); // TODO - add aeldari religion in relevant gml files
				break;
		// Faction 6.5 - Dark Eldar?
		// Faction 7 - Orks
			case "Ork Sniper":
				spawn_exp = 20;
				obj_ini.race[target_company][good] = eFACTION.Ork;
				unit = new TTRPG_stats("ork", target_company, good, "ork_Sniper");
				break;
			case "Flash Git":
				spawn_exp = 40;
				obj_ini.race[target_company][good] = eFACTION.Ork;
				unit = new TTRPG_stats("ork", target_company, good, "flash_git");
				break;
			/* TODO - up for consideration of recruiting faction leaders
			case "Warboss":
				break;
			*/
		// Faction 8 - T'au
			/* TODO - add T'au into the scr_marine_struct
			case "Fire Warrior":
				obj_ini.wep1[target_company][good] = "Plasma Rifle"; TODO - create plasma rifle in scr_weapon
				obj_ini.wep2[target_company][good] = "Combat Knife";
				obj_ini.armour[target_company][good] = "Fire Warrior Armour"; TODO - add it to scr_weapon
				obj_ini.race[target_company][good] = 8;
				unit = new TTRPG_stats("tau", target_company, good, "fire_warrior");
				break;
			*/
		// Faction 9 - Tyranids
		// Faction 10 - Heretics, regular traitors, ex-imperials
			/* TODO - add chaos-aligned human stat lines in scr_add_man
			case "Chaos Cultist":
				obj_ini.wep1[target_company][good] = "Autogun"; TODO - add "Autogun" to scr_weapon
				obj_ini.wep2[target_company][good] = "Combat Knife";
				obj_ini.armour[target_company][good] = "Scout Armour"; TODO - add regular human armour to scr_weapon
				obj_ini.race[target_company][good] = 10;
				unit = new TTRPG_stats("heretics", target_company, good, "chaos_cultist"); TODO - check if faction names are correct
				break;
			*/
		// Faction 11 - Chaos Space Marines
			/* TODO - add CSM stat lines in scr_add_man
			case "Chaos Champion":
				obj_ini.wep1[target_company][good] = "Power Sword"; 
				obj_ini.wep2[target_company][good] = "Plasma Pistol";
				obj_ini.armour[target_company][good] = "Power Armour";
				obj_ini.race[target_company][good] = 11;
				unit = new TTRPG_stats("csm", target_company, good, "chaos_champion"); TODO - check if faction names are correct
				break;
			*/
		// Faction 12 - Daemons
			/* TODO - add daemon stat lines to the scr_add_man, randomization galore, I'm sure
			case "Chaos Spawn":
				obj_ini.wep1[target_company][good] = "Possessed Claws"; TODO - add to scr_weapon
				obj_ini.armour[target_company][good] = "Chaos Armour"; TODO - consider about the proper name and add to scr_weapon
				obj_ini.race[target_company][good] = 12;
				unit = new TTRPG_stats("daemons", target_company, good, "chaos_spawn"); TODO - check if faction names are correct
				break;
			*/
		// Faction 13 - Necrons
			}
		}

		obj_ini.age[target_company][good] = ((obj_controller.millenium * 1000) + obj_controller.year); // Age here // Note: age for marines is generated later with roll_age(), this is left here as a fallback

		if (spawn_name = "") or(spawn_name = "imperial") then obj_ini.name[target_company][good] = global.name_generator.generate_space_marine_name();
		if (spawn_name != "") and(spawn_name != "imperial") then obj_ini.name[target_company][good] = spawn_name;
		if (man_role = "Ranger") then obj_ini.name[target_company][good] = global.name_generator.generate_eldar_name(2);
		if (man_role = "Ork Sniper") or(man_role = "Flash Git") then obj_ini.name[target_company][good] = global.name_generator.generate_ork_name();
		if (man_role = "Sister of Battle") or(man_role = "Sister Hospitaler") then obj_ini.name[target_company][good] = global.name_generator.generate_imperial_name(false);

		//TODO bring this inline with the rest of the code base


		if (!array_contains(non_marine_roles, man_role)) {
			// Weapons
			obj_ini.race[target_company][good] = eFACTION.Player;
			if (man_role == obj_ini.role[100][12]) {
				_gear = {
					wep2 : obj_ini.wep2[100][12],
					wep1 : obj_ini.wep1[100][12],
					armour : obj_ini.armour[100][12],
					gear : obj_ini.gear[100][12],
					mobi : obj_ini.mobi[100][12],
				}
			};

			unit = new TTRPG_stats("chapter", target_company, good, "scout", other_data);
			unit.corruption = corruption
			unit.roll_age(); // Age here
			unit.alter_equipment(_gear);
			marines += 1;

			if (!other_gear) {

				if (obj_ini.wep1[target_company][good] != _gear.wep1) and(wep1 != "") then missing = 1;
				if (obj_ini.wep2[target_company][good] != _gear.wep2) and(wep2 != "") then missing = 1;
				if (obj_ini.armour[target_company][good] != _gear.armour) and(arm != "") then missing = 1;
				if (obj_ini.gear[target_company][good] != _gear.gear) and(choice_gear != "") then missing = 1;
				if (obj_ini.mobi[target_company][good] != _gear.mobi) and(mobility_items != "") then missing = 1;

				//if (man_role=obj_ini.role[100][12]) and (corruption>=13) then obj_ini.god[target_company][good]=2;// Khorne!!!1 XDDDDDDD

				if (missing = 1) and(man_role == obj_ini.role[100][12]) {
					if (string_count("has joined the X Company", obj_turn_end.alert_text[obj_turn_end.alerts])) {
						scr_alert("red", $"recruiting", "Not enough {obj_ini.role[100][12]} equipment in the armoury!", 0, 0);
					}
				}
			}			
		}
		obj_ini.TTRPG[target_company][good] = unit;
		unit.add_exp(spawn_exp);
		unit.allocate_unit_to_fresh_spawn(home_spot);
		unit.update_role(man_role);	
		with(obj_ini) {
			scr_company_order(target_company);
		}
	}

}