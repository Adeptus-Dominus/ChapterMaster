var i, g;
i = 0;
g = 0;
men = 0;
veh = 0;
medi = 0;
repeat(20) {
	i += 1;
	att[i] = 0;
	apa[i] = 0;
	wep_num[i] = 0;
	wep_owner[i] = "";

	// if (wep_owner[i]!="") and (wep_num[i]>1) then wep_owner[i]="";// What if they are using two ranged weapons?  Hmmmmm?
}
i = 0;
// men=0;veh=0;

j = 0;
good = 0;
open = 0;

repeat(700) {
	j += 1;
	if (dudes_num[j] <= 0) {
		dudes[j] = "";
		dudes_special[j] = "";
		dudes_num[j] = 0;
		dudes_ac[j] = 0;
		dudes_hp[j] = 0;
		dudes_vehicle[j] = 0;
		dudes_damage[j] = 0;
		dudes_attack[j] = 1;
		dudes_ranged[j] = 1;
		dudes_defense[j] = 1;
	}
	if (dudes[j] = "") and(dudes[j + 1] != "") {
		dudes[j] = dudes[j + 1] dudes_special[j] = dudes_special[j + 1];
		dudes_num[j] = dudes_num[j + 1];
		dudes_ac[j] = dudes_ac[j + 1];
		dudes_hp[j] = dudes_hp[j + 1];
		dudes_vehicle[j] = dudes_vehicle[j + 1];
		dudes_damage[j] = dudes_damage[j + 1];
		dudes_attack[j] = dudes_attack[j + 1];
		dudes_ranged[j] = dudes_ranged[j + 1];
		dudes_defense[j] = dudes_defense[j + 1];

		dudes[j + 1] = "";
		dudes_special[j + 1] = "";
		dudes_num[j + 1] = 0;
		dudes_ac[j + 1] = 0;
		dudes_hp[j + 1] = 0;
		dudes_vehicle[j + 1] = 0;
		dudes_damage[j + 1] = 0;
		dudes_ranged[j + 1] = 1;
		dudges_defense[j + 1] = 1;
		dudes_attack[j + 1] = 1;
	}
}
j = 0;

/*var no_ap;no_ap=0;

repeat(18){j+=1;
    if (apa[j]=0) then no_ap+=1;
}

if (no_ap=18){
    if (dudes_veh
}*/

repeat(20) {
	j += 1;
	if (obj_ncombat.started = 0) {
		if (dudes[j] = "Malcadon Spyrer") {
			dudes_ac[j] = 35;
			dudes_hp[j] = 200;
		}
	}
	if (dudes[j] = "Malcadon Spyrer") {
		men += dudes_num[j];
		scr_en_weapon("Web Spinner", true, dudes_num[j], dudes[j], j);
		scr_en_weapon("Venom Claws", true, dudes_num[j], dudes[j], j);
	}

	if ((obj_ncombat.started = 0) or(neww = 1)) or(dudes_num[j] > 1) {
		if (dudes[j] = "Greater Daemon of Khorne") {
			dudes_ac[j] = 18;
			dudes_hp[j] = 600;
		}
	}
	if (dudes[j] = "Greater Daemon of Khorne") {
		scr_en_weapon("Khorne Demon Melee", true, dudes_num[j], dudes[j], j);
		dudes_dr[j] = 0.5;
		medi += dudes_num[j];
		if (obj_ncombat.battle_special = "ship_demon") then dudes_dr[j] = 0.65;
	}
	if ((obj_ncombat.started = 0) or(neww = 1)) or(dudes_num[j] > 1) {
		if (dudes[j] = "Greater Daemon of Slaanesh") {
			dudes_ac[j] = 18;
			dudes_hp[j] = 500;
		}
	}
	if (dudes[j] = "Greater Daemon of Slaanesh") {
		scr_en_weapon("Demon Melee", true, dudes_num[j], dudes[j], j);
		scr_en_weapon("Lash Whip", true, dudes_num[j], dudes[j], j);
		dudes_dr[j] = 0.7;
		medi += dudes_num[j];
	}
	if ((obj_ncombat.started = 0) or(neww = 1)) or(dudes_num[j] > 1) {
		if (dudes[j] = "Greater Daemon of Nurgle") {
			dudes_ac[j] = 25;
			dudes_hp[j] = 700;
		}
	}
	if (dudes[j] = "Greater Daemon of Nurgle") {
		scr_en_weapon("Demon Melee", true, dudes_num[j], dudes[j], j);
		scr_en_weapon("Nurgle Vomit", true, dudes_num[j], dudes[j], j);
		dudes_dr[j] = 0.6;
		medi += dudes_num[j];
	}
	if ((obj_ncombat.started = 0) or(neww = 1)) or(dudes_num[j] > 1) {
		if (dudes[j] = "Greater Daemon of Tzeentch") {
			dudes_ac[j] = 18;
			dudes_hp[j] = 500;
		}
	}
	if (dudes[j] = "Greater Daemon of Tzeentch") {
		scr_en_weapon("Demon Melee", true, dudes_num[j], dudes[j], j);
		scr_en_weapon("Witchfire", true, dudes_num[j], dudes[j], j);
		dudes_dr[j] = 0.7;
		medi += dudes_num[j];
	}

	if (dudes[j] = "Bloodletter") {
		scr_en_weapon("Bloodletter Melee", true, dudes_num[j], dudes[j], j);
		dudes_ac[j] = 15;
		dudes_hp[j] = 120;
		men += dudes_num[j];
		dudes_dr[j] = 0.7;
	}
	if (dudes[j] = "Daemonette") {
		scr_en_weapon("Daemonette Melee", true, dudes_num[j], dudes[j], j);
		dudes_ac[j] = 15;
		dudes_hp[j] = 100;
		men += dudes_num[j];
		dudes_dr[j] = 0.7;
	}
	if (dudes[j] = "Pink Horror") {
		scr_en_weapon("Eldritch Fire", true, dudes_num[j], dudes[j], j);
		dudes_ac[j] = 15;
		dudes_hp[j] = 100;
		men += dudes_num[j];
		dudes_dr[j] = 0.8;
	}
	if (dudes[j] = "Plaguebearer") {
		scr_en_weapon("Plaguebearer Melee", true, dudes_num[j], dudes[j], j);
		dudes_ac[j] = 15;
		dudes_hp[j] = 145;
		men += dudes_num[j];
		dudes_dr[j] = 0.6;
	}

	if (dudes[j] = "Helbrute") {
		scr_en_weapon("Power Fist", false, dudes_num[j], dudes[j], j);
		scr_en_weapon("Multi-Melta", false, dudes_num[j], dudes[j], j);
		dudes_ac[j] = 40;
		dudes_hp[j] = 100;
		veh += dudes_num[j];
		dudes_vehicle[j] = 1;
		dudes_dr[j] = 0.75;
	}
	if (dudes[j] = "Soul Grinder") {
		scr_en_weapon("Warpsword", false, dudes_num[j], dudes[j], j);
		scr_en_weapon("Iron Claw", false, dudes_num[j], dudes[j], j);
		scr_en_weapon("Battle Cannon", false, dudes_num[j], dudes[j], j);
		dudes_ac[j] = 30;
		dudes_hp[j] = 350;
		veh += dudes_num[j];
		dudes_vehicle[j] = 1;
		dudes_dr[j] = 1;
	}
	if (dudes[j] = "Maulerfiend") {
		scr_en_weapon("Maulerfiend Claws", false, dudes_num[j], dudes[j], j);
		dudes_ac[j] = 20;
		dudes_hp[j] = 250;
		veh += dudes_num[j];
		dudes_vehicle[j] = 1;
		dudes_dr[j] = 1;
	}

}
j = 0;

neww = 0;

if (men + veh = 1) and(instance_number(obj_enunit) = 1) {
	if (men = 1) and(veh = 0) {
		var i, h;
		i = 0;
		h = 0;
		repeat(20) {
			if (h = 0) {
				i += 1;
				if (dudes_num[i] = 1) {
					h = dudes_hp[i];
					obj_ncombat.display_p2 = h;
					obj_ncombat.display_p2n = string(dudes[i]);
				}
			}
		}
	}
}

/* */
var __b__;
__b__ = action_if_variable(obj_ncombat.enemy, 1, 0);
if __b__ {

	var j;
	j = 0;
	men = 0;
	repeat(100) {
		j += 1;
		veh = 0;
		dreads = 0;
		if (dudes[j] != "") and(dudes_vehicle[j] = 0) {
			men += dudes_num[j];
		}
	}

	// show_message("dudes1:"+string(dudes[1])+", men:"+string(men));

	var i, g;
	i = 0;
	g = 0;
	repeat(100) {
		i += 1;
		att[i] = 0;
		apa[i] = 0;
		wep_num[i] = 0;
		wep_rnum[i] = 0;
	}
	i = 0;

	var dreaded;
	dreaded = false;

	repeat(700) {
		g += 1;
		// Why was this here? And why was it later checked, if it always would be false?;
		// marine_casting[g] = false;

		if ((dudes[g] != "") and(dudes_num[g] > 0)) and(dudes_hp[g] > 0) {
			// if (marine_hp[g]>0) then men+=1;

			/*
			scr_en_weapon
			argument0: name
			argument1: man?
			argument2: number
			argument3: owner
			argument4: dudes number
			*/

			if (dudes[g] = obj_ini.role[100][6]) or(dudes[g] = "Venerable " + obj_ini.role[100][6]) and(dudes_hp[g] > 0) {
				dreads += 1;
				dreaded = true;
			}
			if (dudes_mobi[g] = "Bike") then scr_en_weapon("Twin Linked Bolters", false, 1, dudes[g], g);
			if (dudes_mobi[g] != "Bike") and(dudes_mobi[g] != "") {
				if (string_count("Jump Pack", marine_mobi[g]) > 0) then scr_en_weapon("Hammer of Wrath", false, 1, dudes[g], g);
			}

			if (dudes_mobi[g] = "Servo-arm") then scr_en_weapon("Servo-arm(M)", false, 1, dudes[g], g);
			if (dudes_mobi[g] = "Servo-harness") {
				scr_en_weapon("Servo-arm(M)", false, 1, dudes[g], g);
				scr_en_weapon("Flamer", false, 1, dudes[g], g);
				scr_en_weapon("Plasma Cutter", false, 1, dudes[g], g);
			}

			var j, good, open;
			j = 0;
			good = 0;
			open = 0; // Counts the number and types of marines within this object
			repeat(20) {
				j += 1;
				if (dudes[j] = "") and(open = 0) {
					open = j; // Determine if vehicle here

					if (dudes[j] = "Venerable " + string(obj_ini.role[100][6])) then dudes_vehicle[j] = 1;
					if (dudes[j] = obj_ini.role[100][6]) then dudes_vehicle[j] = 1;
				}
				// if (dudes[g]=dudes[j]){good=1;dudes_num[j]+=1;}
				// if (good=0) and (open!=0){dudes[open]=marine_type[g];dudes_num[open]=1;}
			}

			if (dudes_wep1[g] != "") and (marine_casting[g] == false) { // Do not add weapons to the roster while casting     
				if ((dudes[g] != obj_ini.role[100][eROLE.ChapterMaster])) then scr_en_weapon(string(dudes_wep1[g]), false, 1, dudes[g], g);

				if (dudes_wep1[g] = "Close Combat Weapon") then scr_en_weapon("CCW Heavy Flamer", true, 1, dudes[g], g);
				if (string_count("UBOLT", dudes_wep1[g]) > 0) then scr_en_weapon("Underslung Bolter", false, 1, dudes[g], g);
				if (string_count("UFL", dudes_wep1[g]) > 0) then scr_en_weapon("Underslung Flamer", false, 1, dudes[g], g);
			}
			if (dudes_wep2[g] != "") and (marine_casting[g] == false) {
				if ((dudes[g] != obj_ini.role[100][eROLE.ChapterMaster])) then scr_en_weapon(string(dudes_wep2[g]), false, 1, dudes[g], g);

				if (dudes_wep2[g] = "Close Combat Weapon") then scr_en_weapon("CCW Heavy Flamer", true, 1, dudes[g], g);
				if (string_count("UBOLT", dudes_wep2[g]) > 0) then scr_en_weapon("Underslung Bolter", false, 1, dudes[g], g);
				if (string_count("UFL", dudes_wep2[g]) > 0) then scr_en_weapon("Underslung Flamer", false, 1, dudes[g], g);
			}
		}
	}

	// Right here should be retreat- if important units are exposed they should try to hop left

	/*if (dudes_num[1]=0) and (obj_ncombat.started=0){
	    instance_destroy();
	    exit;
	}*/

	if (men > 0) and(alarm[5] > 0) then alarm[5] = -1;
	instance_activate_object(obj_enunit);

	exit;

	/* */
}
__b__ = action_if_variable(obj_ncombat.enemy, 2, 0);
if __b__ {

	repeat(20) {
		j += 1;
		if (dudes[j] = "Imperial Guardsman") {
			dudes_ac[j] = 20;
			dudes_hp[j] = 20;
			men += dudes_num[j];
		}

		if (dudes[j] = "Heavy Weapons Team") {
			scr_en_weapon("Heavy Bolter", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 0;
			dudes_hp[j] = 100;
			men += dudes_num[j];
		}

		if (dudes[j] = "Ogryn") {
			scr_en_weapon("Ripper Gun", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Ogryn Melee", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 20;
			dudes_hp[j] = 120;
			men += dudes_num[j];
		}

		if (dudes[j] = "Chimera") {
			scr_en_weapon("Multi-Laster", false, dudes_num[j], dudes[j], j);
			scr_en_weapon("Heavy Bolter", false, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 20;
			dudes_hp[j] = 150;
			veh += dudes_num[j];
			dudes_vehicle[j] = 1;
		}
		if (dudes[j] = "Basilisk") {
			scr_en_weapon("Earthshaker Cannon", false, dudes_num[j], dudes[j], j);
			scr_en_weapon("Storm Bolter", false, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 15;
			dudes_hp[j] = 150;
			veh += dudes_num[j];
			dudes_vehicle[j] = 1;
		}
		if (dudes[j] = "Leman Russ Battle Tank") {
			scr_en_weapon("Battle Cannon", false, dudes_num[j], dudes[j], j);
			scr_en_weapon("Lascannon", false, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 40;
			dudes_hp[j] = 250;
			veh += dudes_num[j];
			dudes_vehicle[j] = 1;
		}
		if (dudes[j] = "Leman Russ Demolisher") {
			scr_en_weapon("Demolisher Cannon", false, dudes_num[j], dudes[j], j);
			scr_en_weapon("Lascannon", false, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 40;
			dudes_hp[j] = 250;
			veh += dudes_num[j];
			dudes_vehicle[j] = 1;
		}
		if (dudes[j] = "Vendetta") {
			scr_en_weapon("Twin-Linked Lascannon", false, dudes_num[j] * 3, dudes[j], j);
			dudes_ac[j] = 20;
			dudes_hp[j] = 300;
			veh += dudes_num[j];
			dudes_vehicle[j] = 1;
		}

	}

	// Twin-Linked Lascannon
	// Multi-Laser
	// Ripper Gun
	// Earthshaker Cannon

	// 0-10,000,000
	// Leman Russ Battle Tank = min.1, max = /40000
	// Leman Russ Demolisher = min.1, max = /60000
	// Chimera = min.1, max = /60000

	/* */
}
__b__ = action_if_variable(obj_ncombat.enemy, 3, 0);
if __b__ {

	repeat(20) {
		j += 1;
		if (dudes[j] = "Thallax") {
			scr_en_weapon("Lightning Gun", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Thallax Melee", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 30;
			dudes_hp[j] = 80;
			men += dudes_num[j];
		}
		if (dudes[j] = "Praetorian Servitor") {
			scr_en_weapon("Phased Plasma-fusil", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 25;
			dudes_hp[j] = 150;
			medi += dudes_num[j];
		}
	}

	// 
	// 

	/* */
}
__b__ = action_if_variable(obj_ncombat.enemy, 5, 0);
if __b__ {

	repeat(20) {
		j += 1;
		if (dudes[j] = "Leader") {
			scr_en_weapon("Blessed Weapon", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Laser Mace", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Infernus Pistol", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 35;
			if (obj_ncombat.started = 0) or(dudes_num[j] > 1) {
				dudes_hp[j] = 200;
			}
			men += dudes_num[j];
			dudes_dr[j] = 0.33;
		}
		if (dudes[j] = "Palatine") {
			scr_en_weapon("Plasma Pistol", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Power Weapon", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 22;
			dudes_hp[j] = 100;
			men += dudes_num[j];
			dudes_dr[j] = 0.5;
		}
		if (dudes[j] = "Priest") {
			scr_en_weapon("Laspistol", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 0;
			dudes_hp[j] = 30;
			men += dudes_num[j];
			dudes_dr[j] = 0.5;
		}

		if (dudes[j] = "Arco-Flagellent") {
			scr_en_weapon("Electro-Flail", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 0;
			dudes_hp[j] = 150;
			men += dudes_num[j];
			dudes_dr[j] = 0.65;
		}

		if (dudes[j] = "Celestian") {
			scr_en_weapon("Bolter", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Chainsword", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 20;
			dudes_hp[j] = 40;
			men += dudes_num[j];
			dudes_dr[j] = 0.65;
		}
		if (dudes[j] = "Mistress") {
			scr_en_weapon("Neural Whip", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 20;
			dudes_hp[j] = 40;
			men += dudes_num[j];
			dudes_dr[j] = 0.75;
		}
		if (dudes[j] = "Sister Repentia") {
			scr_en_weapon("Eviscerator", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 20;
			dudes_hp[j] = 30;
			men += dudes_num[j];
			dudes_dr[j] = 0.75;
		}

		if (dudes[j] = "Battle Sister") {
			if (dudes_num[j] <= 4) then scr_en_weapon("Bolter", true, dudes_num[j], dudes[j], j);
			if (dudes_num[j] >= 5) {
				var nem;
				nem = round(dudes_num[j] / 4);
				scr_en_weapon("Flamer", true, nem, dudes[j], j);
				scr_en_weapon("Bolter", true, dudes_num[j] - nem, dudes[j], j);
			}
			scr_en_weapon("Sarissa", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 20;
			dudes_hp[j] = 40;
			men += dudes_num[j];
			dudes_dr[j] = 0.8;
		}
		if (dudes[j] = "Seraphim") {
			scr_en_weapon("Seraphim Pistols", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Chainsword", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 20;
			dudes_hp[j] = 40;
			men += dudes_num[j];
			dudes_dr[j] = 0.75;
		}
		if (dudes[j] = "Dominion") {
			scr_en_weapon("Meltagun", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Meltabomb", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 20;
			dudes_hp[j] = 40;
			men += dudes_num[j];
			dudes_dr[j] = 0.75;
		}
		if (dudes[j] = "Retributor") {
			if (dudes_num[j] <= 3) then scr_en_weapon("Heavy Bolter", true, dudes_num[j], dudes[j], j);
			if (dudes_num[j] >= 4) {
				var nem;
				nem = round(dudes_num[j] / 4);
				scr_en_weapon("Missile Launcher", true, nem, dudes[j], j);
				scr_en_weapon("Heavy Bolter", true, dudes_num[j] - nem, dudes[j], j);
			}
			scr_en_weapon("Bolt Pistol", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 20;
			dudes_hp[j] = 40;
			men += dudes_num[j];
			dudes_dr[j] = 0.75;
		}

		if (dudes[j] = "Follower") {
			scr_en_weapon("Laspistol", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("melee0.5", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 0;
			dudes_hp[j] = 20;
			men += dudes_num[j];
		}

		if (dudes[j] = "Rhino") {
			scr_en_weapon("Storm Bolter", false, dudes_num[j] * 2, dudes[j], j);
			dudes_ac[j] = 20;
			dudes_hp[j] = 200;
			veh += dudes_num[j];
			dudes_vehicle[j] = 1;
		}

		if (dudes[j] = "Chimera") {
			scr_en_weapon("Heavy Flamer", false, dudes_num[j] * 2, dudes[j], j);
			dudes_ac[j] = 23;
			dudes_hp[j] = 200;
			veh += dudes_num[j];
			dudes_vehicle[j] = 1;
		}

		if (dudes[j] = "Immolator") {
			scr_en_weapon("Twin Linked Heavy Flamers", false, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 20;
			dudes_hp[j] = 200;
			veh += dudes_num[j];
			dudes_vehicle[j] = 1;
		}
		if (dudes[j] = "Exorcist") {
			scr_en_weapon("Exorcist Missile Launcher", false, dudes_num[j], dudes[j], j);
			scr_en_weapon("Storm Bolter", false, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 30;
			if (obj_ncombat.started = 0) or(dudes_num[j] > 1) {
				dudes_hp[j] = 300;
			}
			veh += dudes_num[j];
			dudes_vehicle[j] = 1;
		}

		if (dudes[j] = "Penitent Engine") {
			scr_en_weapon("Close Combat Weapon", false, dudes_num[j] * 2, dudes[j], j);
			scr_en_weapon("Heavy Flamer", false, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 35;
			dudes_hp[j] = 150;
			veh += dudes_num[j];
			dudes_vehicle[j] = 1;
		}

		// if (obj_ncombat.enemy=11) and (dudes_vehicle[j]=0) and (dudes[j]!="Cultist"){dudes_dr[j]=0.8;}
		// if (obj_ncombat.enemy=11) and (dudes_vehicle[j]=1){dudes_dr[j]=0.75;}

		// if (dudes[j]!="") and (dudes_num[j]=0){dudes[j]="";dudes_num[j]=0;}
		if (dudes[j] != "") and(dudes_hp[j] = 0) {
			dudes[j] = "";
			dudes_num[j] = 0;
		}
		if (dudes_num[j] > 0) and(dudes_onum[j] = -1) then dudes_onum[j] = dudes_num[j];
		if (faith[j] > 0) then dudes_dr[j] = max(0.65, dudes_dr[j] + 0.15);
	}

	/* */
}
__b__ = action_if_variable(obj_ncombat.enemy, 6, 0);
if __b__ {

	repeat(20) {
		j += 1;
		if (dudes[j] = "Leader") {
			scr_en_weapon("Singing Spear", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Singing Spear Throw", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 30;
			dudes_hp[j] = 300;
			men += dudes_num[j];
			dudes_dr[j] = 0.5;
		}

		if (dudes[j] = "Autarch") {
			scr_en_weapon("Power Weapon", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Fusion Gun", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 20;
			dudes_hp[j] = 150;
			men += dudes_num[j];
		}
		if (dudes[j] = "Farseer") {
			scr_en_weapon("Singing Spear", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Singing Spear Throw", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 30;
			dudes_hp[j] = 150;
			men += dudes_num[j];
		}
		if (dudes[j] = "Warlock") {
			scr_en_weapon("Witchblade", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Psyshock", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 20;
			dudes_hp[j] = 100;
			men += dudes_num[j];
		}
		if (dudes[j] = "Avatar") {
			scr_en_weapon("Wailing Doom", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Avatar Smite", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 40;
			dudes_hp[j] = 300;
			veh += dudes_num[j];
		}
		if (dudes[j] = "Mighty Avatar") {
			scr_en_weapon("Wailing Doom", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Avatar Smite", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 55;
			dudes_hp[j] = 450;
			veh += dudes_num[j];
		}
		if (dudes[j] = "Godly Avatar") {
			scr_en_weapon("Wailing Doom", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Avatar Smite", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 70;
			dudes_hp[j] = 600;
			veh += dudes_num[j];
		}

		if (dudes[j] = "Ranger") {
			scr_en_weapon("Ranger Long Rifle", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Shuriken Pistol", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 10;
			dudes_hp[j] = 30;
			men += dudes_num[j];
		}
		if (dudes[j] = "Pathfinder") {
			scr_en_weapon("Pathfinder Long Rifle", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Melee1", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 10;
			dudes_hp[j] = 60;
			men += dudes_num[j];
		}
		if (dudes[j] = "Dire Avenger") {
			scr_en_weapon("Avenger Shuriken Catapult", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Melee1", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 15;
			dudes_hp[j] = 30;
			men += dudes_num[j];
		}
		if (dudes[j] = "Dire Avenger Exarch") {
			scr_en_weapon("Power Weapon", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 30;
			dudes_hp[j] = 50; // Shimmershield 
			men += dudes_num[j];
		}
		if (dudes[j] = "Howling Banshee") {
			scr_en_weapon("Power Weapon", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Shuriken Pistol", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 15;
			dudes_hp[j] = 30;
			men += dudes_num[j];
		}
		if (dudes[j] = "Howling Banshee Exarch") {
			scr_en_weapon("Executioner", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 30;
			dudes_hp[j] = 50;
			men += dudes_num[j];
		}
		if (dudes[j] = "Striking Scorpion") {
			scr_en_weapon("Scorpion Chainsword", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Shuriken Pistol", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Mandiblaster", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 20;
			dudes_hp[j] = 30;
			men += dudes_num[j];
		}
		if (dudes[j] = "Striking Scorpion Exarch") {
			scr_en_weapon("Biting Blade", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Scorpion's Claw", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Mandiblaster", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 30;
			dudes_hp[j] = 50;
			men += dudes_num[j];
		}
		if (dudes[j] = "Fire Dragon") {
			scr_en_weapon("Fusion Gun", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Meltabomb", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Melee1", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 15;
			dudes_hp[j] = 30;
			men += dudes_num[j];
		}
		if (dudes[j] = "Fire Dragon Exarch") {
			scr_en_weapon("Firepike", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Power Weapon", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 20;
			dudes_hp[j] = 50;
			men += dudes_num[j];
		}
		if (dudes[j] = "Warp Spider") {
			scr_en_weapon("Deathspinner", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 15;
			dudes_hp[j] = 30;
			men += dudes_num[j];
		}
		if (dudes[j] = "Warp Spider Exarch") {
			scr_en_weapon("Dual Deathspinners", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Powerblades", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 20;
			dudes_hp[j] = 50;
			men += dudes_num[j];
		}
		if (dudes[j] = "Dark Reaper") {
			scr_en_weapon("Reaper Launcher", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Melee1", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 20;
			dudes_hp[j] = 30;
			men += dudes_num[j];
		}
		if (dudes[j] = "Dark Reaper Exarch") {
			scr_en_weapon("Eldar Missile Launcher", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Melee1", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 30;
			dudes_hp[j] = 50;
			men += dudes_num[j];
		}
		if (dudes[j] = "Shining Spear") {
			scr_en_weapon("Laser Lance", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Twin Linked Shuriken Catapult", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 20;
			dudes_hp[j] = 30;
			men += dudes_num[j];
		}
		if (dudes[j] = "Guardian") {
			scr_en_weapon("Shuriken Catapult", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Melee1", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 15;
			dudes_hp[j] = 30;
			men += dudes_num[j];
		}
		if (dudes[j] = "Grav Platform") {
			scr_en_weapon("Pulse Laser", false, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 15;
			dudes_hp[j] = 70;
			men += dudes_num[j];
		}
		if (dudes[j] = "Trouper") {
			scr_en_weapon("Power Weapon", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Fusion Pistol", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 30;
			dudes_hp[j] = 50;
			men += dudes_num[j];
		}
		if (dudes[j] = "Athair") {
			scr_en_weapon("Plasma Pistol", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Harlequin's Kiss", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 30;
			dudes_hp[j] = 75;
			men += dudes_num[j];
		}
		if (dudes[j] = "Wraithguard") {
			scr_en_weapon("Wraithcannon", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 20;
			dudes_hp[j] = 80;
			men += dudes_num[j];
		}
		if (dudes[j] = "Vyper") {
			scr_en_weapon("Twin Linked Shuriken Catapult", false, dudes_num[j], dudes[j], j);
			scr_en_weapon("Pulse Laser", false, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 40;
			dudes_hp[j] = 100;
			veh += dudes_num[j];
			dudes_vehicle[j] = 1;
		}
		if (dudes[j] = "Falcon") {
			scr_en_weapon("Pulse Laser", false, dudes_num[j], dudes[j], j);
			scr_en_weapon("Shuriken Cannon", false, dudes_num[j], dudes[j], j);
			scr_en_weapon("Bright Lance", false, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 40;
			dudes_hp[j] = 200;
			veh += dudes_num[j];
			dudes_vehicle[j] = 1;
		}
		if (dudes[j] = "Fire Prism") {
			scr_en_weapon("Twin Linked Shuriken Catapult", false, dudes_num[j], dudes[j], j);
			scr_en_weapon("Prism Cannon", false, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 40;
			dudes_hp[j] = 200;
			veh += dudes_num[j];
			dudes_vehicle[j] = 1;
		}
		if (dudes[j] = "Nightspinner") {
			scr_en_weapon("Twin Linked Doomweaver", false, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 40;
			dudes_hp[j] = 170;
			veh += dudes_num[j];
			dudes_vehicle[j] = 1;
		}
		if (dudes[j] = "Wraithlord") {
			scr_en_weapon("Two Power Fists", false, dudes_num[j], dudes[j], j);
			scr_en_weapon("Flamer", false, dudes_num[j] * 2, dudes[j], j);
			scr_en_weapon("Star Cannon", false, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 40;
			dudes_hp[j] = 200;
			veh += dudes_num[j];
			dudes_vehicle[j] = 1;
		}
		if (dudes[j] = "Phantom Titan") {
			scr_en_weapon("Two Power Fists", false, dudes_num[j], dudes[j], j);
			scr_en_weapon("Phantom Pulsar", false, dudes_num[j] * 2, dudes[j], j);
			scr_en_weapon("Titan Starcannon", false, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 50;
			dudes_hp[j] = 800;
			veh += dudes_num[j];
			dudes_vehicle[j] = 1;
		}

	}

	/* */
}
__b__ = action_if_variable(obj_ncombat.enemy, 7, 0);
if __b__ {

	repeat(20) {
		j += 1;
		if (dudes[j] = "Leader") {
			scr_en_weapon("Power Klaw", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Rokkit Launcha", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Big Shoota", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 60;
			if (obj_ncombat.started = 0) or(dudes_num[j] > 1) {
				dudes_hp[j] = 600;
			}
			veh += dudes_num[j];
			dudes_dr[j] = 0.5;
		}

		if (dudes[j] = "Minor Warboss") {
			scr_en_weapon("Choppa", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Big Shoota", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 40;
			if (obj_ncombat.started = 0) or(dudes_num[j] > 1) {
				dudes_hp[j] = 150;
			}
			men += dudes_num[j];
		}
		if (dudes[j] = "Warboss") {
			scr_en_weapon("Power Klaw", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Rokkit Launcha", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 50;
			if (obj_ncombat.started = 0) or(dudes_num[j] > 1) {
				dudes_hp[j] = 200;
			}
			men += dudes_num[j];
		}
		if (dudes[j] = "Big Warboss") {
			scr_en_weapon("Power Klaw", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Rokkit Launcha", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 60;
			if (obj_ncombat.started = 0) or(dudes_num[j] > 1) {
				dudes_hp[j] = 300;
			}
			veh += dudes_num[j];
		}

		if (dudes[j] = "Gretchin") {
			scr_en_weapon("Grot Blasta", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 0;
			dudes_hp[j] = 15;
			men += dudes_num[j];
		}
		if (dudes[j] = "Slugga Boy") {
			scr_en_weapon("Choppa", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Slugga", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 10;
			dudes_hp[j] = 50;
			men += dudes_num[j];
		}
		if (dudes[j] = "Shoota Boy") {
			scr_en_weapon("Shoota", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Choppa", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 10;
			dudes_hp[j] = 50;
			men += dudes_num[j];
		}

		if (dudes[j] = "Mekboy") {
			scr_en_weapon("Power Klaw", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Big Shoota", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 30;
			dudes_hp[j] = 60;
			men += dudes_num[j];
		}
		if (dudes[j] = "Meganob") {
			scr_en_weapon("Power Klaw", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Big Shoota", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 40;
			dudes_hp[j] = 120;
			men += dudes_num[j];
		}
		if (dudes[j] = "Flash Git") {
			scr_en_weapon("Snazzgun", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Choppa", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 15;
			dudes_hp[j] = 65;
			men += dudes_num[j];
		}
		if (dudes[j] = "Cybork") {
			scr_en_weapon("Power Klaw", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Big Shoota", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 30;
			dudes_hp[j] = 80;
			men += dudes_num[j];
		}

		if (dudes[j] = "Ard Boy") {
			scr_en_weapon("Choppa", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Slugga", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 20;
			dudes_hp[j] = 70;
			men += dudes_num[j];
		}
		if (dudes[j] = "Kommando") {
			scr_en_weapon("Choppa", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Rokkit Launcha", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 10;
			dudes_hp[j] = 80;
			men += dudes_num[j];
		}
		if (dudes[j] = "Burna Boy") {
			scr_en_weapon("Choppa", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Burna", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 10;
			dudes_hp[j] = 35;
			men += dudes_num[j];
		}
		if (dudes[j] = "Tankbusta") {
			scr_en_weapon("Rokkit Launcha", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Tankbusta Bomb", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Melee1", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 10;
			dudes_hp[j] = 50;
			men += dudes_num[j];
		}
		if (dudes[j] = "Stormboy") {
			scr_en_weapon("Choppa", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Slugga", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 10;
			dudes_hp[j] = 50;
			dudes_special[j] = "Jetpack";
			men += dudes_num[j];
		}

		if (dudes[j] = "Battlewagon") {
			scr_en_weapon("Kannon", false, dudes_num[j], dudes[j], j);
			scr_en_weapon("Big Shoota", false, dudes_num[j] * 2, dudes[j], j);
			scr_en_weapon("Rokkit Launcha", false, dudes_num[j] * 2, dudes[j], j);
			dudes_ac[j] = 40;
			dudes_hp[j] = 200;
			veh += dudes_num[j];
			dudes_vehicle[j] = 1;
		}
		if (dudes[j] = "Deff Dread") {
			scr_en_weapon("Power Klaw", false, dudes_num[j] * 2, dudes[j], j);
			scr_en_weapon("Big Shoota", false, dudes_num[j], dudes[j], j);
			scr_en_weapon("Rokkit Launcha", false, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 35;
			dudes_hp[j] = 150;
			veh += dudes_num[j];
			dudes_vehicle[j] = 1;
		}
	}

	/* */
}
__b__ = action_if_variable(obj_ncombat.enemy, 8, 0);
if __b__ {

	repeat(20) {
		j += 1;
		if (dudes[j] = "XV8 Commander") {
			scr_en_weapon("Plasma Rifle", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Fusion Blaster", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Cyclic Ion Blaster", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 30;
			dudes_hp[j] = 150;
			medi += dudes_num[j];
			dudes_vehicle[j] = 1;
		}
		if (dudes[j] = "XV8 Bodyguard") {
			scr_en_weapon("Plasma Rifle", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Burst Rifle", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 30;
			dudes_hp[j] = 100;
			medi += dudes_num[j];
			dudes_vehicle[j] = 1;
		}
		if (dudes[j] = "XV8 Crisis") {
			scr_en_weapon("Plasma Rifle", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Missile Pod", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 30;
			dudes_hp[j] = 75;
			medi += dudes_num[j];
			dudes_vehicle[j] = 1;
		}
		if (dudes[j] = "XV8 (Brightknife)") {
			scr_en_weapon("Fusion Blaster", true, dudes_num[j] * 2, dudes[j], j);
			dudes_ac[j] = 30;
			dudes_hp[j] = 75;
			medi += dudes_num[j];
			dudes_vehicle[j] = 1;
		}
		if (dudes[j] = "Shield Drone") {
			dudes_ac[j] = 30;
			dudes_hp[j] = 100;
			medi += dudes_num[j];
			dudes_vehicle[j] = 1;
		}

		if (dudes[j] = "XV88 Broadside") {
			scr_en_weapon("Smart Missile System", true, dudes_num[j] * 2, dudes[j], j);
			scr_en_weapon("Small Railgun", true, dudes_num[j] * 2, dudes[j], j);
			dudes_ac[j] = 30;
			dudes_hp[j] = 150;
			medi += dudes_num[j];
			dudes_vehicle[j] = 1;
		}
		if (dudes[j] = "XV25 Stealthsuit") {
			scr_en_weapon("Burst Rifle", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 20;
			dudes_hp[j] = 50;
			men += dudes_num[j];
			dudes_vehicle[j] = 1;
		}

		if (dudes[j] = "Fire Warrior") {
			scr_en_weapon("Pulse Rifle", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 20;
			dudes_hp[j] = 20;
			men += dudes_num[j];
		}
		if (dudes[j] = "Pathfinder") {
			scr_en_weapon("Rail Rifle", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 20;
			dudes_hp[j] = 20;
			men += dudes_num[j];
		}
		if (dudes[j] = "Kroot") {
			scr_en_weapon("Kroot Rifle", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Melee2", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 5;
			dudes_hp[j] = 30;
			men += dudes_num[j];
		}
		if (dudes[j] = "Vespid") {
			scr_en_weapon("Vespid Crystal", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Melee2", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 10;
			dudes_hp[j] = 50;
			men += dudes_num[j];
		}

		if (dudes[j] = "Devilfish") {
			scr_en_weapon("Smart Missile System", false, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 30;
			dudes_hp[j] = 150;
			veh += dudes_num[j];
			dudes_vehicle[j] = 1;
		}
		if (dudes[j] = "Hammerhead") {
			scr_en_weapon("Railgun", false, dudes_num[j], dudes[j], j);
			scr_en_weapon("Smart Missile System", false, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 40;
			dudes_hp[j] = 250;
			veh += dudes_num[j];
			dudes_vehicle[j] = 1;
		}
	}

	/* */
}
__b__ = action_if_variable(obj_ncombat.enemy, 9, 0);
if __b__ {

	repeat(20) {
		j += 1;
		if (dudes[j] = "Hive Tyrant") {
			scr_en_weapon("Bonesword", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Lashwhip", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Heavy Venom Cannon", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 35;
			dudes_hp[j] = 250;
			men += dudes_num[j];
		}

		if (dudes[j] = "Tyrant Guard") {
			scr_en_weapon("Crushing Claws", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 30;
			dudes_hp[j] = 100;
			men += dudes_num[j];
		}
		if (dudes[j] = "Tyranid Warrior") {
			scr_en_weapon("Rending Claws", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Devourer", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 20;
			dudes_hp[j] = 100;
			men += dudes_num[j];
		}
		if (dudes[j] = "Zoanthrope") {
			scr_en_weapon("Zoanthrope Blast", false, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 40;
			dudes_hp[j] = 200;
			dudes_dr[j] = 0.5;
			medi += dudes_num[j];
			dudes_vehicle[j] = 1.5;
		}
		if (dudes[j] = "Carnifex") {
			scr_en_weapon("Carnifex Claws", false, dudes_num[j], dudes[j], j);
			scr_en_weapon("Venom Cannon", false, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 40;
			dudes_hp[j] = 300;
			dudes_dr[j] = 0.75;
			veh += dudes_num[j];
			dudes_vehicle[j] = 1;
		}
		if (dudes[j] = "Termagaunt") {
			scr_en_weapon("Fleshborer", true, dudes_num[j] / 10, dudes[j], j);
			dudes_ac[j] = 0;
			dudes_hp[j] = 20;
			men += dudes_num[j];
		}
		if (dudes[j] = "Hormagaunt") {
			scr_en_weapon("Scything Talons", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 0;
			dudes_hp[j] = 20;
			men += dudes_num[j];
		}

		if (dudes[j] = "Cultist") {
			scr_en_weapon("Autogun", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("melee0.5", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 0;
			dudes_hp[j] = 20;
			men += dudes_num[j];
		}
		if (dudes[j] = "Genestealer") {
			scr_en_weapon("Genestealer Claws", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 10;
			dudes_hp[j] = 50;
			men += dudes_num[j];
		}
		if (dudes[j] = "Genestealer Patriarch") {
			scr_en_weapon("Genestealer Claws", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Witchfire", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 20;
			dudes_hp[j] = 150;
			dudes_dr[j] = 0.75;
			men += dudes_num[j];
		}
		if (dudes[j] = "Armoured Limousine") {
			scr_en_weapon("Autogun", false, dudes_num[j] * 4, dudes[j], j);
			dudes_ac[j] = 10;
			dudes_hp[j] = 150;
			veh += dudes_num[j];
			dudes_vehicle[j] = 1;
		}
		if (dudes[j] = "Lictor") {
			scr_en_weapon("Lictor Claws", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Flesh Hooks", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 20;
			dudes_hp[j] = 150;
			men += dudes_num[j];
		}

		dudes_dr[j] += 0.25;
	}

	/* */
}
__b__ = action_if_variable(obj_ncombat.enemy, 10, 4);
if __b__ {
	__b__ = action_if_variable(obj_ncombat.enemy, 12, 1);
	if __b__ {

		repeat(20) {
			j += 1;
			if (dudes[j] = "Leader") and(obj_controller.faction_gender[10] = 1) {
				scr_en_weapon("Meltagun", true, dudes_num[j], dudes[j], j);
				scr_en_weapon("Power Fist", true, dudes_num[j], dudes[j], j);
				dudes_ac[j] = 40;
				if (obj_ncombat.started = 0) or(dudes_num[j] > 1) {
					dudes_hp[j] = 300;
				}
				men += dudes_num[j];
				dudes_dr[j] = 0.5;
			}
			if (dudes[j] = "Leader") and(obj_controller.faction_gender[10] = 2) {
				scr_en_weapon("Khorne Demon Melee", true, dudes_num[j] * 2, dudes[j], j);
				dudes_ac[j] = 44;
				if (obj_ncombat.started = 0) or(dudes_num[j] > 1) {
					dudes_hp[j] = 300;
				}
				men += dudes_num[j];
				dudes_dr[j] = 0.4;
			}

			if (dudes[j] = "Fallen") {
				scr_en_weapon("Bolt Pistol", true, dudes_num[j], dudes[j], j);
				scr_en_weapon("Power Weapon", true, dudes_num[j], dudes[j], j);
				dudes_ac[j] = 20;
				dudes_hp[j] = 120;
				men += dudes_num[j];
				dudes_dr[j] = 0.5;
			}

			if (dudes[j] = "Chaos Lord") {
				scr_en_weapon("Plasma Pistol", true, dudes_num[j], dudes[j], j);
				scr_en_weapon("Power Weapon", true, dudes_num[j], dudes[j], j);
				dudes_ac[j] = 30;
				dudes_hp[j] = 150;
				men += dudes_num[j];
			}
			if (dudes[j] = "Chaos Sorcerer") {
				scr_en_weapon("Plasma Pistol", true, dudes_num[j], dudes[j], j);
				scr_en_weapon("Force Staff", true, dudes_num[j], dudes[j], j);
				dudes_ac[j] = 25;
				dudes_hp[j] = 100;
				men += dudes_num[j];
			}
			if (dudes[j] = "Warpsmith") {
				scr_en_weapon("Chainfist", true, dudes_num[j], dudes[j], j);
				scr_en_weapon("Meltagun", true, dudes_num[j], dudes[j], j);
				scr_en_weapon("Flamer", true, dudes_num[j], dudes[j], j);
				dudes_ac[j] = 30;
				dudes_hp[j] = 100;
				men += dudes_num[j];
			}

			if (dudes[j] = "Chaos Terminator") {
				scr_en_weapon("Power Fist", true, dudes_num[j], dudes[j], j);
				scr_en_weapon("Bolter", true, dudes_num[j], dudes[j], j);
				scr_en_weapon("Combi-Flamer", true, dudes_num[j], dudes[j], j);
				dudes_ac[j] = 40;
				dudes_hp[j] = 100;
				men += dudes_num[j];
				dudes_dr[j] = 0.7;
			}
			if (dudes[j] = "Venerable Chaos Terminator") {
				scr_en_weapon("Power Fist", true, dudes_num[j], dudes[j], j);
				scr_en_weapon("Bolter", true, dudes_num[j], dudes[j], j);
				scr_en_weapon("Combi-Flamer", true, dudes_num[j], dudes[j], j);
				dudes_ac[j] = 40;
				dudes_hp[j] = 120;
				men += dudes_num[j];
				dudes_dr[j] = 0.6;
			}
			if (dudes[j] = "World Eaters Terminator") {
				scr_en_weapon("Power Fist", true, dudes_num[j] * 2, dudes[j], j);
				scr_en_weapon("Meltagun", true, dudes_num[j], dudes[j], j);
				dudes_ac[j] = 40;
				dudes_hp[j] = 120;
				men += dudes_num[j];
				dudes_dr[j] = 0.6;
			}
			if (dudes[j] = "Obliterator") {
				scr_en_weapon("Power Fist", true, dudes_num[j], dudes[j], j);
				scr_en_weapon("Obliterator Weapon", true, dudes_num[j], dudes[j], j);
				dudes_ac[j] = 30;
				dudes_hp[j] = 200;
				men += dudes_num[j];
			}
			if (dudes[j] = "Chaos Chosen") {
				scr_en_weapon("Meltagun", true, dudes_num[j], dudes[j], j);
				scr_en_weapon("Chainsword", true, dudes_num[j], dudes[j], j);
				dudes_ac[j] = 17;
				dudes_hp[j] = 125;
				men += dudes_num[j];
			}
			if (dudes[j] = "Venerable Chaos Chosen") {
				scr_en_weapon("Meltagun", true, dudes_num[j], dudes[j], j);
				scr_en_weapon("Chainsword", true, dudes_num[j], dudes[j], j);
				dudes_ac[j] = 20;
				dudes_hp[j] = 125;
				men += dudes_num[j];
				dudes_dr[j] = 0.75;
			}

			if (dudes[j] = "Possessed") {
				scr_en_weapon("Possessed Claws", true, dudes_num[j], dudes[j], j);
				dudes_ac[j] = 17;
				dudes_hp[j] = 150;
				men += dudes_num[j];
			}
			if (dudes[j] = "Chaos Space Marine") {
				scr_en_weapon("Bolter", true, dudes_num[j], dudes[j], j);
				scr_en_weapon("Chainsword", true, dudes_num[j], dudes[j], j);
				dudes_ac[j] = 20;
				dudes_hp[j] = 100;
				men += dudes_num[j];
			}
			if (dudes[j] = "Havoc") {
				scr_en_weapon("Missile Launcher", true, dudes_num[j], dudes[j], j);
				scr_en_weapon("Melee1", true, dudes_num[j], dudes[j], j);
				dudes_ac[j] = 20;
				dudes_hp[j] = 100;
				men += dudes_num[j];
			}
			if (dudes[j] = "Raptor") {
				scr_en_weapon("Chainsword", true, dudes_num[j], dudes[j], j);
				scr_en_weapon("Bolt Pistol", true, dudes_num[j], dudes[j], j);
				dudes_ac[j] = 20;
				dudes_hp[j] = 100;
				dudes_special[j] = "Jump Pack";
				men += dudes_num[j];
			}

			if (dudes[j] = "World Eater") {
				scr_en_weapon("Bolter", true, dudes_num[j], dudes[j], j);
				scr_en_weapon("Chainaxe", true, dudes_num[j], dudes[j], j);
				dudes_ac[j] = 20;
				dudes_hp[j] = 100;
				men += dudes_num[j];
			}
			if (dudes[j] = "World Eaters Veteran") {
				scr_en_weapon("Combi-Flamer", true, dudes_num[j], dudes[j], j);
				scr_en_weapon("Chainaxe", true, dudes_num[j], dudes[j], j);
				dudes_ac[j] = 20;
				dudes_hp[j] = 100;
				men += dudes_num[j];
			}

			if (dudes[j] = "Khorne Berzerker") {
				scr_en_weapon("Chainaxe", true, dudes_num[j], dudes[j], j);
				scr_en_weapon("Bolt Pistol", true, dudes_num[j], dudes[j], j);
				dudes_ac[j] = 20;
				dudes_hp[j] = 100;
				men += dudes_num[j];
			}
			if (dudes[j] = "Plague Marine") {
				scr_en_weapon("Bolter", true, dudes_num[j], dudes[j], j);
				scr_en_weapon("Poison Chainsword", true, dudes_num[j], dudes[j], j);
				dudes_ac[j] = 20;
				dudes_hp[j] = 150;
				men += dudes_num[j];
			}
			if (dudes[j] = "Noise Marine") {
				scr_en_weapon("Sonic Blaster", true, dudes_num[j], dudes[j], j);
				scr_en_weapon("Melee1", true, dudes_num[j], dudes[j], j);
				dudes_ac[j] = 20;
				dudes_hp[j] = 100;
				men += dudes_num[j];
			}
			if (dudes[j] = "Rubric Marine") {
				scr_en_weapon("Rubric Bolter", true, dudes_num[j], dudes[j], j);
				scr_en_weapon("Melee1", true, dudes_num[j], dudes[j], j);
				dudes_ac[j] = 25;
				dudes_hp[j] = 125;
				men += dudes_num[j];
			}
			if (dudes[j] = "Rubric Sorcerer") {
				scr_en_weapon("Witchfire", true, dudes_num[j], dudes[j], j);
				scr_en_weapon("Force Staff", true, dudes_num[j], dudes[j], j);
				dudes_ac[j] = 25;
				dudes_hp[j] = 150;
				men += dudes_num[j];
			}
			if (dudes[j] = "Cultist") {
				scr_en_weapon("Autogun", true, dudes_num[j], dudes[j], j);
				scr_en_weapon("melee0.5", true, dudes_num[j], dudes[j], j);
				dudes_ac[j] = 0;
				dudes_hp[j] = 30;
				men += dudes_num[j];
			}
			if (dudes[j] = "Hellbrute") {
				scr_en_weapon("Power Fist", false, dudes_num[j], dudes[j], j);
				scr_en_weapon("Meltagun", false, dudes_num[j], dudes[j], j);
				dudes_ac[j] = 40;
				dudes_hp[j] = 200;
				dudes_dr[j] = 0.75;
				veh += dudes_num[j];
				dudes_vehicle[j] = 1;
			}
			if (dudes[j] = "Rhino") {
				scr_en_weapon("Storm Bolter", false, dudes_num[j] * 2, dudes[j], j);
				dudes_ac[j] = 20;
				dudes_hp[j] = 200;
				veh += dudes_num[j];
				dudes_vehicle[j] = 1;
			}
			if (dudes[j] = "Predator") {
				scr_en_weapon("Lascannon", false, dudes_num[j] * 2, dudes[j], j);
				scr_en_weapon("Twin Linked Lascannon", false, dudes_num[j], dudes[j], j);
				dudes_ac[j] = 30;
				dudes_hp[j] = 300;
				veh += dudes_num[j];
				dudes_vehicle[j] = 1;
			}
			if (dudes[j] = "Vindicator") {
				scr_en_weapon("Demolisher Cannon", false, dudes_num[j], dudes[j], j);
				scr_en_weapon("Havoc Launcher", false, dudes_num[j], dudes[j], j);
				dudes_ac[j] = 40;
				dudes_hp[j] = 300;
				veh += dudes_num[j];
				dudes_vehicle[j] = 1;
			}
			if (dudes[j] = "Land Raider") {
				scr_en_weapon("Twin Linked Heavy Bolters", false, dudes_num[j], dudes[j], j);
				scr_en_weapon("Twin Linked Lascannon", false, dudes_num[j] * 2, dudes[j], j);
				dudes_ac[j] = 40;
				dudes_hp[j] = 400;
				veh += dudes_num[j];
				dudes_vehicle[j] = 1;
			}
			if (dudes[j] = "Heldrake") {
				scr_en_weapon("Baleflame", false, dudes_num[j] * 5, dudes[j], j);
				dudes_ac[j] = 25;
				dudes_hp[j] = 400;
				veh += dudes_num[j];
				dudes_vehicle[j] = 1;
			}
			if (dudes[j] = "Defiler") {
				scr_en_weapon("Defiler Claws", false, dudes_num[j], dudes[j], j);
				scr_en_weapon("Battle Cannon", false, dudes_num[j], dudes[j], j);
				scr_en_weapon("Reaper Autocannon", false, dudes_num[j], dudes[j], j);
				scr_en_weapon("Flamer", false, dudes_num[j], dudes[j], j);
				dudes_ac[j] = 40;
				dudes_hp[j] = 300;
				veh += dudes_num[j];
				dudes_vehicle[j] = 1;
			}

			if (dudes[j] = "Arch Heretic") {
				scr_en_weapon("Power Weapon", true, dudes_num[j], dudes[j], j);
				scr_en_weapon("Plasma Pistol", true, dudes_num[j], dudes[j], j);
				dudes_ac[j] = 20;
				dudes_hp[j] = 30;
				dudes_dr[j] = 0.7;
				men += dudes_num[j];
			}
			if (dudes[j] = "Cultist Elite") {
				scr_en_weapon("Lasgun", true, dudes_num[j], dudes[j], j);
				scr_en_weapon("Chainaxe", true, dudes_num[j], dudes[j], j);
				dudes_ac[j] = 10;
				dudes_hp[j] = 20;
				men += dudes_num[j];
			}
			if (dudes[j] = "Mutant") {
				scr_en_weapon("Flesh Hooks", true, dudes_num[j], dudes[j], j);
				dudes_ac[j] = 0;
				dudes_hp[j] = 30;
				men += dudes_num[j];
			}
			if (dudes[j] = "Daemonhost") {
				scr_en_weapon("Daemonhost Claws", true, dudes_num[j], dudes[j], j);
				scr_en_weapon("Daemonhost_Powers", true, dudes_num[j], dudes[j], j);
				dudes_ac[j] = 30;
				dudes_hp[j] = 300;
				dudes_dr[j] = 0.5;
				medi += dudes_num[j];
			}
			if (dudes[j] = "Possessed") {
				scr_en_weapon("Possessed Claws", true, dudes_num[j], dudes[j], j);
				dudes_ac[j] = 17;
				dudes_hp[j] = 100;
				men += dudes_num[j];
			}

			/*
			if (dudes[j]="Greater Daemon of Khorne"){scr_en_weapon("Khorne Demon Melee",true,dudes_num[j],dudes[j],j);dudes_ac[j]=10;dudes_hp[j]=300;dudes_dr[j]=0.25;medi+=dudes_num[j];}
			if (dudes[j]="Greater Daemon of Slaanesh"){scr_en_weapon("Demon Melee",true,dudes_num[j],dudes[j],j);scr_en_weapon("Lash Whip",true,dudes_num[j],dudes[j],j);dudes_ac[j]=10;dudes_hp[j]=250;dudes_dr[j]=0.35;medi+=dudes_num[j];}
			if (dudes[j]="Greater Daemon of Nurgle"){scr_en_weapon("Demon Melee",true,dudes_num[j],dudes[j],j);scr_en_weapon("Nurgle Vomit",true,dudes_num[j],dudes[j],j);dudes_ac[j]=15;dudes_hp[j]=400;dudes_dr[j]=0.25;medi+=dudes_num[j];}
			if (dudes[j]="Greater Daemon of Tzeentch"){scr_en_weapon("Demon Melee",true,dudes_num[j],dudes[j],j);scr_en_weapon("Witchfire",true,dudes_num[j],dudes[j],j);dudes_ac[j]=10;dudes_hp[j]=250;dudes_dr[j]=0.35;medi+=dudes_num[j];}
			*/

			if (dudes[j] = "Technical") {
				scr_en_weapon("Autogun", false, dudes_num[j] * 2, dudes[j], j);
				scr_en_weapon("Heavy Bolter", false, dudes_num[j], dudes[j], j);
				dudes_ac[j] = 10;
				dudes_hp[j] = 100;
				veh += dudes_num[j];
				dudes_vehicle[j] = 1;
			}

			if (dudes[j] = "Chaos Leman Russ") {
				scr_en_weapon("Battle Cannon", false, dudes_num[j], dudes[j], j);
				scr_en_weapon("Heavy Bolter", false, dudes_num[j], dudes[j], j);
				dudes_ac[j] = 40;
				dudes_hp[j] = 250;
				veh += dudes_num[j];
				dudes_vehicle[j] = 1;
			}
			if (dudes[j] = "Chaos Basilisk") {
				scr_en_weapon("Earthshaker Cannon", false, dudes_num[j], dudes[j], j);
				scr_en_weapon("Heavy Bolter", false, dudes_num[j], dudes[j], j);
				dudes_ac[j] = 20;
				dudes_hp[j] = 150;
				veh += dudes_num[j];
				dudes_vehicle[j] = 1;
			}

			// if (obj_ncombat.enemy=11) and (dudes_vehicle[j]=0) and (dudes[j]!="Cultist"){dudes_dr[j]=0.8;}
			// if (obj_ncombat.enemy=11) and (dudes_vehicle[j]=1){dudes_dr[j]=0.75;}

			// if (dudes[j]!="") and (dudes_num[j]=0){dudes[j]="";dudes_num[j]=0;}
			if (dudes[j] != "") and(dudes_hp[j] = 0) {
				dudes[j] = "";
				dudes_num[j] = 0;
			}
		}

		/* */
	}
}
__b__ = action_if_variable(obj_ncombat.enemy, 13, 0);
if __b__ {

	repeat(20) {
		j += 1;

		if (dudes[j] = "Necron Overlord") {
			scr_en_weapon("Staff of Light", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Staff of Light Shooting", true, dudes_num[j], dudes[j], j);
			if (obj_ncombat.started = 0) or(dudes_num[j] > 1) {
				dudes_ac[j] = 25;
				dudes_hp[j] = 300;
			}
			men += dudes_num[j];
		}
		if (dudes[j] = "Lychguard") {
			scr_en_weapon("Warscythe", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 35;
			dudes_hp[j] = 100;
			men += dudes_num[j];
		}

		if (dudes[j] = "Flayed One") {
			scr_en_weapon("Melee5", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 25;
			dudes_hp[j] = 100;
			men += dudes_num[j];
		}
		if (dudes[j] = "Necron Warrior") {
			scr_en_weapon("Gauss Flayer", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Melee3", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 25;
			dudes_hp[j] = 100;
			men += dudes_num[j];
		}
		if (dudes[j] = "Necron Immortal") {
			scr_en_weapon("Gauss Blaster", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Melee3", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 25;
			dudes_hp[j] = 100;
			men += dudes_num[j];
		}

		if (dudes[j] = "Necron Wraith") {
			scr_en_weapon("Wraith Claws", true, dudes_num[j], dudes[j], j);
			if (obj_ncombat.started = 0) or(dudes_num[j] > 1) {
				dudes_ac[j] = 25;
				dudes_hp[j] = 200;
			}
			men += dudes_num[j];
			dudes_dr[j] = 0.65;
		}
		if (dudes[j] = "Necron Destroyer") {
			scr_en_weapon("Gauss Cannon", true, dudes_num[j], dudes[j], j);
			scr_en_weapon("Melee3", true, dudes_num[j], dudes[j], j);
			dudes_ac[j] = 25;
			dudes_hp[j] = 175;
			men += dudes_num[j];
		}

		if (dudes[j] = "Tomb Stalker") {
			scr_en_weapon("Gauss Particle Cannon", false, dudes_num[j] * 1, dudes[j], j);
			scr_en_weapon("Overcharged Gauss Cannon", false, dudes_num[j] * 2, dudes[j], j);
			scr_en_weapon("Claws", false, dudes_num[j] * 5, dudes[j], j);
			if (obj_ncombat.started = 0) or(dudes_num[j] > 1) {
				dudes_ac[j] = 30;
				dudes_hp[j] = 600;
			}
			veh += dudes_num[j];
			dudes_vehicle[j] = 1;
		}
		if (dudes[j] = "Canoptek Spyder") {
			scr_en_weapon("Claws", false, dudes_num[j] * 2, dudes[j], j);
			if (obj_ncombat.started = 0) or(dudes_num[j] > 1) {
				dudes_ac[j] = 30;
				dudes_hp[j] = 300;
			}
			veh += dudes_num[j];
			dudes_vehicle[j] = 1;
		}
		if (dudes[j] = "Canoptek Scarab") {
			scr_en_weapon("Melee3", false, dudes_num[j] * 2, dudes[j], j);
			dudes_ac[j] = 10;
			dudes_hp[j] = 30;
			men += dudes_num[j];
			dudes_vehicle[j] = 0;
		}
		if (dudes[j] = "Necron Monolith") {
			scr_en_weapon("Gauss Flux Arc", false, dudes_num[j] * 4, dudes[j], j);
			scr_en_weapon("Particle Whip", false, dudes_num[j] * 1, dudes[j], j);
			dudes_ac[j] = 70;
			dudes_hp[j] = 300;
			veh += dudes_num[j];
			dudes_vehicle[j] = 1;
			// was 50 / 500
		}
		if (dudes[j] = "Doomsday Arc") {
			scr_en_weapon("Gauss Flayer Array", false, dudes_num[j] * 2, dudes[j], j);
			scr_en_weapon("Doomsday Cannon", false, dudes_num[j] * 1, dudes[j], j);
			dudes_ac[j] = 30;
			dudes_hp[j] = 150;
			veh += dudes_num[j];
			dudes_vehicle[j] = 1;
		}

		// if (dudes_dr[j]>0.8) then dudes_dr[j]=0.8;
	}

	/* */
}
/*
if (obj_ncombat.battle_special = "ruins") or(obj_ncombat.battle_special = "ruins_eldar") {
	var i;
	i = 0;
	repeat(20) {
		i += 1;
		if (dudes_vehicle[i] > 0) and(dudes_num[i] > 0) {
			obj_ncombat.enemy_forces -= dudes_num[i];
			obj_ncombat.enemy_max -= dudes_num[i];
			dudes[i] = "";
			dudes_special[i] = "";
			dudes_num[i] = 0;
			dudes_ac[i] = 0;
			dudes_hp[i] = 0;
			dudes_dr[i] = 1;
			dudes_vehicle[i] = 0;
		}
	}
}
*/

if (men + veh + medi <= 0) {
	instance_destroy();
	exit;
}

if (obj_ncombat.started = 0) {
	obj_ncombat.enemy_forces += self.men + self.veh + self.medi;
}

if (!collision_point(x + 10, y, obj_pnunit, 0, 1)) and(!collision_point(x - 10, y, obj_pnunit, 0, 1)) then engaged = 0;
if (collision_point(x + 10, y, obj_pnunit, 0, 1)) or(collision_point(x - 10, y, obj_pnunit, 0, 1)) then engaged = 1;

if (neww = 1) then neww = 0;

/* */
/*  */