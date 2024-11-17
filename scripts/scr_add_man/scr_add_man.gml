function scr_add_man(man_role, target_company, spawn_exp, spawn_name, corruption, other_gear, home_spot, other_data = {}) {

	//all of this will in time be irrelevant as calling new TTRPG_stats() and then calling the correct methods within the new itme will replace this but for
	//now its easy enough to use this as the structs continue to be built.
	// other_gear = gear provided?
	// home_spot = home, shipXY, or default

	// TODO refactor repeats

	// That should be sufficient to add stuff in a highly modifiable fashion

	var non_marine_roles = ["Skitarii", "Techpriest", "Crusader", "Sister of Battle", "Sister Hospitaler", "Ranger", "Ork Sniper", "Flash Git"];
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
		obj_ini.race[target_company][good] = 1;
		obj_ini.role[target_company][good] = man_role;
		obj_ini.wep1[target_company][good] = "";
		obj_ini.wep2[target_company][good] = "";
		obj_ini.armour[target_company][good] = "";
		obj_ini.spe[target_company][good] = "";
		obj_ini.god[target_company][good] = 0;

		if (other_gear = true) {
	// Factions 1-5 are part of Imperial family
		// Faction 1 - Space Marine
		// Faction 2 - Homo Sapiens Imperialis
		// Faction 3 - Adeptus Mechanicus
			switch (man_role) {
			case "Skitarii":
				obj_ini.wep1[target_company][good] = "Hellgun";
				obj_ini.wep2[target_company][good] = ""; // Consider giving the poor fellow a "Combat Knife" or other melee weapon
				obj_ini.armour[target_company][good] = "Skitarii Armour";
				spawn_exp = 10;
				obj_ini.race[target_company][good] = 3;
				unit = new TTRPG_stats("mechanicus", target_company, good, "skitarii");
				break;
			case "Techpriest":
				obj_ini.wep1[target_company][good] = "Power Axe";
				obj_ini.wep2[target_company][good] = "Laspistol";
				obj_ini.armour[target_company][good] = "Dragon Scales";
				obj_ini.gear[target_company][good] = "";
				obj_ini.mobi[target_company][good] = "Servo-arm";
				spawn_exp = 100;
				obj_ini.race[target_company][good] = 3;
				unit = new TTRPG_stats("mechanicus", target_company, good, "tech_priest");
				break
		// Faction 4 - Inquisition
			case "Crusader":
				obj_ini.wep1[target_company][good] = "Power Sword";
				obj_ini.armuor[target_company][good] = "Power Armour"; // Might want to create "Light Power Armour" that is suited for squishy humans
				obj_ini.gear[target_company][good] = "Storm Shield";
				spawn_exp = 10;
				obj_ini.race[target_company][good] = 4;
				unit = new TTRPG_stats("inquisition", target_company, good, "inquisition_crusader");
				break;
		// Faction 5 - Sisters of Battle
			case "Sister of Battle":
				obj_ini.wep1[target_company][good] = "Bolter"; // Might want to create a "Light Bolter" variant for this one
				obj_ini.wep2[target_company][good] = "Sarissa";
				obj_ini.armour[target_company][good] = "Power Armour"; // Same here, Sororitas are glorified guard
				spawn_exp = 60;
				obj_ini.race[target_company][good] = 5;
				unit = new TTRPG_stats("adeptus_sororitas", target_company, good, "sister_of_battle");
				break;
			case "Sister Hospitaler":
				obj_ini.wep1[target_company][good] = "Bolter"; // Same here
				obj_ini.wep2[target_company][good] = "Sarissa";
				obj_ini.armour[target_company][good] = "Power Armour"; // Same here
				spawn_exp = 100;
				obj_ini.gear[target_company][good] = "Sororitas Medkit";
				obj_ini.race[target_company][good] = 5;
				unit = new TTRPG_stats("adeptus_sororitas", target_company, good, "sister_hospitaler");
				break;
	// End of Imperials
		// Faction 6 - Eldar
			case "Ranger":
				obj_ini.wep1[target_company][good] = "Ranger Long Rifle";
				obj_ini.wep2[target_company][good] = "Shuriken Pistol";
				obj_ini.armour[target_company][good] = ""; // I should add "Eldar Armour" to the fellow too
				spawn_exp = 80;
				obj_ini.race[target_company][good] = 6
				unit = new TTRPG_stats("mechanicus", target_company, good, "skitarii_ranger");
				break;
		// Faction 7 - Orks
			case "Ork Sniper":
				obj_ini.wep1[target_company][good] = "Sniper Rifle";
				obj_ini.wep2[target_company][good] = "Choppa";
				obj_ini.armour[target_company][good] = ""; // Consider giving "Ork Armour" to the fellow
				spawn_exp = 20;
				obj_ini.race[target_company][good] = 7;
				unit = new TTRPG_stats("ork", target_company, good, "ork_Sniper");
				break;
			case "Flash Git":
				obj_ini.wep1[target_company][good] = "Snazzgun";
				obj_ini.wep2[target_company][good] = "Choppa";
				obj_ini.armour[target_company][good] = "Ork Armour";
				spawn_exp = 40;
				obj_ini.race[target_company][good] = 7;
				unit = new TTRPG_stats("ork", target_company, good, "flash_git");
				break;
		// Faction 8 - T'au 
		// Faction 9 - Tyranids
		// Faction 10 - Heretics, regular traitors, ex-imperials
		// Faction 11 - Chaos Space Marines
		// Faction 12 - Daemons
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

		// Weapons
		if (man_role = obj_ini.role[100][12]) {
			wep2 = obj_ini.wep2[100, 12];
			wep1 = obj_ini.wep1[100, 12];
			arm = obj_ini.armour[100, 12];
			choice_gear = obj_ini.gear[100, 12];
			mobility_items = obj_ini.mobi[100, 12];
		}

		var good1, good2, good3, good4;
		good1 = 0;
		good2 = 0;
		good3 = 0;
		good4 = 0;

		if (other_gear = false) {
			e = 0;
			if (wep1 != "") then repeat(100) { // First Weapon
				e += 1;
				if (e <= 100) {
					if (obj_ini.equipment[e] = wep1) {
						obj_ini.equipment_number[e] -= 1;
						obj_ini.wep1[target_company][good] = obj_ini.equipment[e];
						if (obj_ini.equipment_number[e] = 0) {
							obj_ini.equipment[e] = "";
							obj_ini.equipment_type[e] = "";
						}
						e = 1000;
					}
				}
			}
			e = 0;
			if (wep2 != "") then repeat(100) { // Second Weapon
				e += 1;
				if (e <= 100) {
					if (obj_ini.equipment[e] = wep2) {
						obj_ini.equipment_number[e] -= 1;
						obj_ini.wep2[target_company][good] = obj_ini.equipment[e];
						if (obj_ini.equipment_number[e] = 0) {
							obj_ini.equipment[e] = "";
							obj_ini.equipment_type[e] = "";
						}
						e = 1000;
					}
				}
			}
			e = 0;

			// show_message(arm);

			if (arm != "") then repeat(100) { // Armour
				e += 1;
				if (e <= 100) {
					if (obj_ini.equipment[e] = arm) {
						obj_ini.equipment_number[e] -= 1;
						obj_ini.armour[target_company][good] = arm;
						if (obj_ini.equipment_number[e] = 0) {
							obj_ini.equipment[e] = "";
							obj_ini.equipment_type[e] = "";
						}
						e = 1000;
					}
				}
			}

			// show_message(obj_ini.armour[target_company][good]);

			e = 0;
			if (choice_gear != "") then repeat(100) { // Gear
				e += 1;
				if (e <= 100) {
					if (obj_ini.equipment[e] = choice_gear) {
						obj_ini.equipment_number[e] -= 1;
						obj_ini.gear[target_company][good] = choice_gear;
						if (obj_ini.equipment_number[e] = 0) {
							obj_ini.equipment[e] = "";
							obj_ini.equipment_type[e] = "";
						}
						e = 1000;
					}
				}
			}
			e = 0;
			if (mobility_items != "") then repeat(100) { // Mobility
				e += 1;
				if (e <= 100) {
					if (obj_ini.equipment[e] = mobility_items) {
						obj_ini.equipment_number[e] -= 1;
						obj_ini.mobi[target_company][good] = mobility_items;
						if (obj_ini.equipment_number[e] = 0) {
							obj_ini.equipment[e] = "";
							obj_ini.equipment_type[e] = "";
						}
						e = 1000;
					}
				}
			}

			if (obj_ini.wep1[target_company][good] != wep1) and(wep1 != "") then missing = 1;
			if (obj_ini.wep2[target_company][good] != wep2) and(wep2 != "") then missing = 1;
			if (obj_ini.armour[target_company][good] != arm) and(arm != "") then missing = 1;
			if (obj_ini.gear[target_company][good] != choice_gear) and(choice_gear != "") then missing = 1;
			if (obj_ini.mobi[target_company][good] != mobility_items) and(mobility_items != "") then missing = 1;

			//if (man_role=obj_ini.role[100][12]) and (corruption>=13) then obj_ini.god[target_company][good]=2;// Khorne!!!1 XDDDDDDD

			if (missing = 1) and(man_role == obj_ini.role[100][12]) {
				if (string_count("has joined the X Company", obj_turn_end.alert_text[obj_turn_end.alerts])) {
					scr_alert("red", $"recruiting", "Not enough {obj_ini.role[100][12]} equipment in the armoury!", 0, 0);
				}
			}
		}

		if (!array_contains(non_marine_roles, man_role)) {
			unit = new TTRPG_stats("chapter", target_company, good, "scout", other_data);
			unit.corruption = corruption
			unit.roll_age(); // Age here
			marines += 1;
		}
		obj_ini.TTRPG[target_company][good] = unit;
		unit.add_exp(spawn_exp);
		unit.allocate_unit_to_fresh_spawn(home_spot);
		with(obj_ini) {
			scr_company_order(target_company);
		}
	}

}