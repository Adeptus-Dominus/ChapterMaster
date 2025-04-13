// Sets up the number of enemies based on the threath level, enemy type and specific story events

try{
if (battle_special = "cs_meeting_battle5") then alpha_strike = 1;

instance_activate_object(obj_enunit);

// Checks if Chapter master is a psyker and then casts a pskychic power (kamehameha)
if (chapter_master_psyker = true) and(obj_ini.psy_powers = "default") {
	var yeo = false;
	if (scr_has_adv("Paragon")) then yeo = true;
	if (yeo = true) then kamehameha = true;
}

// show_message("Leader?: "+string(leader));

// if (enemy=1) then show_message("exiting obj_ncombat_Alarm 0_2 due to enemy=1");
if (enemy = 1) {
	instance_activate_object(obj_enunit);
	exit;
}

if (battle_special = "study2a") or(battle_special = "study2b") {
	ally = 3;
	ally_forces = 1;
}
instance_activate_object(obj_pnunit);
if (!instance_exists(obj_pnunit)) then exit;
xxx = instance_nearest(1000, 240, obj_pnunit);
xxx = xxx.x + 80;

if (string_count("spyrer", battle_special) > 0) or(string_count("fallen", battle_special) > 0) or(string_count("mech", battle_special) > 0) or(battle_special = "space_hulk") or(battle_special = "study2a") or(battle_special = "study2b") then fortified = 0;

var i = 0,
	u;
i = xxx / 10;

if (fortified > 1) and(enemy + threat != 17) {
	u = instance_create(0, 0, obj_nfort);
	u.image_speed = 0;
	u.image_alpha = 0.5;

	if (fortified = 2) {
		u.ac[1] = 30;
		u.hp[1] = 400;
	}
	if (fortified = 3) {
		u.ac[1] = 40;
		u.hp[1] = 800;
	}
	if (fortified = 4) {
		u.ac[1] = 40;
		u.hp[1] = 1250;
	}
	if (fortified = 5) {
		u.ac[1] = 40;
		u.hp[1] = 1500;
	}

	if (siege = 1) and(fortified > 0) and(defending = true) {
		global_attack = global_attack * 1.1;
		u.hp[1] = round(u.hp[1] * 1.2);
	}

	u.maxhp[1] = u.hp[1];
}

for (var j = 0; j < 10; j++) {
	i -= 1;
	u = instance_create(i * 10, 240, obj_enunit);
	u.column = i - ((xxx / 10) - 10);
}
// *** Enemy Forces Special Event ***
// * Malcadon Spyrer *
if (string_count("spyrer", battle_special) > 0) {
	fortified = 0;
	with(obj_enunit) {
		instance_destroy();
	}
	u = instance_create(10, 240, obj_enunit);
	enemy_dudes = "1";
	u.dudes[1] = "Malcadon Spyrer";
	u.dudes_num[1] = 1;
	u.dudes_num[1] = 1;
	enemies[1] = 1;
	u.flank = 1;
}
// * Small Fallen Group *
if (battle_special = "fallen1") {
	fortified = 0;
	with(obj_enunit) {
		instance_destroy();
	}
	u = instance_create(80, 240, obj_enunit);
	enemy_dudes = "1";
	u.dudes[1] = "Fallen";
	u.dudes_num[1] = 1;
	enemies[1] = 1;
}
// * Large Fallen Group *
if (battle_special = "fallen2") {
	fortified = 0;
	with(obj_enunit) {
		instance_destroy();
	}
	u = instance_create(80, 240, obj_enunit);
	enemy_dudes = "1";
	u.dudes[1] = "Fallen";
	u.dudes_num[1] = choose(1, 1, 2, 2, 3);
	enemies[1] = u.dudes_num[1];
}
// * Praetorian Servitor Group *
if (string_count("mech", battle_special) > 0) {
	fortified = 0;
	with(obj_enunit) {
		instance_destroy();
	}
	u = instance_create(xxx + 10, 240, obj_enunit);
	enemy_dudes = "";
	u.dudes[1] = "Thallax";
	u.dudes_num[1] = 4;
	enemies[1] = 4;
	u.dudes[2] = "Praetorian Servitor";
	u.dudes_num[2] = 6;
	enemies[2] = 6;
}
// * Greater Daemon *
if (battle_special = "ship_demon") {
	fortified = 0;
	with(obj_enunit) {
		instance_destroy();
	}
	enemy = 10;
	u = instance_create(10, 240, obj_enunit);
	enemy_dudes = "1";
	u.dudes[1] = choose("Greater Daemon of Khorne", "Greater Daemon of Slaanesh", "Greater Daemon of Tzeentch", "Greater Daemon of Nurgle");
	u.dudes_num[1] = 1;
	enemies[1] = 1;
	u.flank = 1;
	u.engaged = 1;
	with(instance_nearest(x + 1000, 240, obj_pnunit)) {
		engaged = 1;
	}
}
// * Necron Wraith Group *
if (battle_special = "wraith_attack") {
	fortified = 0;
	with(obj_enunit) {
		instance_destroy();
	}
	u = instance_create(instance_nearest(x + 1000, 240, obj_pnunit)
		.x + 10, 240, obj_enunit);
	enemy_dudes = "2";
	u.dudes[1] = "Necron Wraith";
	u.dudes_num[1] = 1;
	enemies[1] = 1;
	u.dudes[2] = "Necron Wraith";
	u.dudes_num[2] = 1;
	enemies[2] = 1;
	u.engaged = 1; // u.flank=1;
	with(instance_nearest(x + 1000, 240, obj_pnunit)) {
		engaged = 1;
	}
}
// * Canoptek Spyder Group * 
if (battle_special = "spyder_attack") {
	fortified = 0;
	with(obj_enunit) {
		instance_destroy();
	}
	u = instance_create(instance_nearest(x + 1000, 240, obj_pnunit)
		.x + 10, 240, obj_enunit);
	enemy_dudes = "21";
	u.dudes[1] = "Canoptek Spyder";
	u.dudes_num[1] = 1;
	enemies[1] = u.dudes[1];
	u.dudes[2] = "Canoptek Scarab";
	u.dudes_num[2] = 20;
	enemies[2] = u.dudes[2];
	u.engaged = 1; // u.flank=1;
	with(instance_nearest(x + 1000, 240, obj_pnunit)) {
		engaged = 1;
	}
}
// * Tomb Stalker Group *
if (battle_special = "stalker_attack") {
	fortified = 0;
	with(obj_enunit) {
		instance_destroy();
	}
	u = instance_create(instance_nearest(x + 1000, 240, obj_pnunit)
		.x + 10, 240, obj_enunit);
	enemy_dudes = "1";
	u.dudes[1] = "Tomb Stalker";
	u.dudes_num[1] = 1;
	enemies[1] = 1;
	u.engaged = 1; // u.flank=1;
	with(instance_nearest(x + 1000, 240, obj_pnunit)) {
		engaged = 1;
	}
}
// * Chaos Space Marine Elite Group *
if (battle_special = "cs_meeting_battle5") or(battle_special = "cs_meeting_battle6") {
	fortified = 0;
	with(obj_enunit) {
		instance_destroy();
	}
	u = instance_create(xxx + 20, 240, obj_enunit);
	enemy_dudes = "";
	u.dudes[1] = "Leader";
	u.dudes_num[1] = 1;
	enemies[1] = 1;
	u.dudes[2] = "Greater Daemon of Tzeentch";
	u.dudes_num[2] = 1;
	enemies[2] = 1;
	u.dudes[3] = "Greater Daemon of Slaanesh";
	u.dudes_num[3] = 1;
	enemies[3] = 1;
	u = instance_create(xxx + 10, 240, obj_enunit);
	enemy_dudes = "";
	u.dudes[1] = "Venerable Chaos Terminator";
	u.dudes_num[1] = 20;
	enemies[1] = 20;
}
// * Chaos Space Marine Elite Company *
if (battle_special = "cs_meeting_battle10") {
	fortified = 0;
	with(obj_enunit) {
		instance_destroy();
	}
	u = instance_create(xxx + 20, 240, obj_enunit);
	enemy_dudes = "";
	u.dudes[1] = "Greater Daemon of Tzeentch";
	u.dudes_num[1] = 1;
	enemies[1] = 1;
	u.dudes[2] = "Greater Daemon of Slaanesh";
	u.dudes_num[2] = 1;
	enemies[2] = 1;
	u.dudes[3] = "Venerable Chaos Terminator";
	u.dudes_num[3] = 20;
	enemies[3] = 20;
	u = instance_create(xxx + 10, 240, obj_enunit);
	enemy_dudes = "";
	u.dudes[1] = "Venerable Chaos Chosen";
	u.dudes_num[1] = 40;
	enemies[1] = 40;
	u.dudes[2] = "Helbrute";
	u.dudes_num[2] = 3;
	enemies[2] = 3;
}
// * Tomb world attack enemy setup *
if (battle_special = "wake1_attack") {
	enemy = 13;
	threat = 2;
}
if (battle_special = "wake2_attack") {
	enemy = 13;
	threat = 3;
}
if (battle_special = "wake3_attack") {
	enemy = 13;
	threat = 5;
}
// * Tomb world study attack enemy setup *
if (battle_special = "study2a") {
	enemy = 13;
	threat = 2;
}
if (battle_special = "study2b") {
	enemy = 13;
	threat = 3;
}
// ** Space Hulk Forces **
if (battle_special = "space_hulk") {
	var make, modi;
	// show_message("space hulk battle, player forces: "+string(player_forces));
	with(obj_enunit) {
		instance_destroy();
	}
	// * Ork Space Hulk *
	if (enemy = 7) {
		modi = random_range(0.80, 1.20) + 1;
		make = round(max(3, player_starting_dudes * modi));

		u = instance_create(instance_nearest(x - 1000, 240, obj_pnunit)
			.x - 10, 240, obj_enunit);
		u.dudes[1] = "Meganob";
		u.dudes_num[1] = make;
		enemies[1] = u.dudes[1];
		u.engaged = 1;
		u.flank = 1;
		with(instance_nearest(x - 1000, 240, obj_pnunit)) {
			engaged = 1;
		}

		u = instance_create(instance_nearest(x + 1000, 240, obj_pnunit)
			.x + 20, 240, obj_enunit);
		u.dudes[1] = "Slugga Boy";
		u.dudes_num[1] = make;
		enemies[1] = u.dudes[1];

		u.dudes[2] = "Shoota Boy";
		u.dudes_num[2] = make;
		enemies[2] = u.dudes[2];

		hulk_forces = make * 3;
	}
	// * Genestealer Space Hulk *
	if (enemy = 9) {
		modi = random_range(0.80, 1.20) + 1;
		make = round(max(3, player_starting_dudes * modi)) * 2;

		u = instance_create(instance_nearest(x - 1000, 240, obj_pnunit)
			.x - 10, 240, obj_enunit);
		u.dudes[1] = "Genestealer";
		u.dudes_num[1] = round(make / 3);
		enemies[1] = u.dudes[1];
		u.engaged = 1;
		u.flank = 1;
		with(instance_nearest(x - 1000, 240, obj_pnunit)) {
			engaged = 1;
		}

		u = instance_create(instance_nearest(x + 1000, 240, obj_pnunit)
			.x + 10, 240, obj_enunit);
		u.dudes[1] = "Genestealer";
		u.dudes_num[1] = round(make / 3);
		enemies[1] = u.dudes[1];

		u = instance_create(instance_nearest(x + 1000, 240, obj_pnunit)
			.x + 50, 240, obj_enunit);
		u.dudes[1] = "Genestealer";
		u.dudes_num[1] = make - (round(make / 3) * 2);
		enemies[1] = u.dudes[1];

		hulk_forces = make;
	}
	// * CSM Space Hulk *
	if (enemy = 10) {
		var make, modi;
		modi = random_range(0.80, 1.20) + 1;
		make = round(max(3, player_starting_dudes * modi));

		u = instance_create(instance_nearest(x - 1000, 240, obj_pnunit)
			.x - 10, 240, obj_enunit);
		u.dudes[1] = "Chaos Terminator";
		u.dudes_num[1] = round(make * 0.25);
		enemies[1] = u.dudes[1];
		u.engaged = 1;
		u.flank = 1;
		with(instance_nearest(x - 1000, 240, obj_pnunit)) {
			engaged = 1;
		}

		u = instance_create(instance_nearest(x + 1000, 240, obj_pnunit)
			.x + 10, 240, obj_enunit);
		u.dudes[1] = "Chaos Space Marine";
		u.dudes_num[1] = round(make * 0.25);
		enemies[1] = u.dudes[1];

		u = instance_create(instance_nearest(x + 1000, 240, obj_pnunit)
			.x + 50, 240, obj_enunit);
		u.dudes[1] = "Cultist";
		u.dudes_num[1] = round(make * 0.5);
		enemies[1] = u.dudes[1];

		hulk_forces = make;
	}

	// show_message(string(instance_number(obj_enunit))+"x enemy blocks");
	instance_activate_object(obj_enunit);
	exit;
}
// ** Story Reveal of a Chaos World **
if (battle_special = "WL10_reveal") {
	u = instance_nearest(xxx, 240, obj_enunit);
	enemy_dudes = "3300";

	u.dudes[1] = "Leader";
	u.dudes_num[1] = 1;

	u.dudes[2] = "Greater Daemon of Tzeentch";
	u.dudes_num[2] = 1;

	u.dudes[3] = "Greater Daemon of Slaanesh";
	u.dudes_num[3] = 1;

	u.dudes[4] = "Venerable Chaos Terminator";
	u.dudes_num[4] = 20;

	u.dudes[5] = "Venerable Chaos Chosen";
	u.dudes_num[5] = 50;
	// u.dudes[4]="Chaos Basilisk";u.dudes_num[4]=18;
	instance_deactivate_object(u);

	u = instance_nearest(xxx + 10, 240, obj_enunit);
	// u.dudes[1]="Chaos Leman Russ";u.dudes_num[1]=40;
	u.dudes[1] = "Chaos Sorcerer";
	u.dudes_num[1] = 4;
	u.dudes[2] = "Chaos Space Marine";
	u.dudes_num[2] = 100;
	u.dudes[3] = "Havoc";
	u.dudes_num[3] = 20;
	u.dudes[4] = "Raptor";
	u.dudes_num[4] = 20;
	u.dudes[5] = "Bloodletter";
	u.dudes_num[5] = 30;
	// u.dudes[3]="Vindicator";u.dudes_num[3]=10;
	instance_deactivate_object(u);

	u = instance_nearest(xxx + 20, 240, obj_enunit);
	u.dudes[1] = "Rhino";
	u.dudes_num[1] = 30;
	u.dudes[2] = "Defiler";
	u.dudes_num[2] = 4;
	u.dudes[3] = "Heldrake";
	u.dudes_num[3] = 2;
	instance_deactivate_object(u);

	u = instance_nearest(xxx + 30, 240, obj_enunit);
	u.dudes[1] = "Cultist Elite";
	u.dudes_num[1] = 1500;
	// u.dudes[2]="Cultist Elite";u.dudes_num[2]=1500;
	u.dudes[2] = "Helbrute";
	u.dudes_num[2] = 3;
	// u.dudes[3]="Predator";u.dudes_num[3]=6;
	// u.dudes[4]="Vindicator";u.dudes_num[4]=3;
	// u.dudes[5]="Land Raider";u.dudes_num[5]=2;
	instance_deactivate_object(u);

	u = instance_nearest(xxx + 40, 240, obj_enunit);
	// u.dudes[1]="Mutant";u.dudes_num[1]=8000;
	u.dudes[1] = "Cultist";
	u.dudes_num[1] = 1500;
	u.dudes[2] = "Helbrute";
	u.dudes_num[2] = 3;
	instance_deactivate_object(u);
}
// ** Story late reveal of a Chaos World **
if (battle_special = "WL10_later") {
	u = instance_nearest(xxx, 240, obj_enunit);
	enemy_dudes = "200";

	u.dudes[1] = "Leader";
	u.dudes_num[1] = 1;
	u.dudes[2] = "Greater Daemon of Tzeentch";
	u.dudes_num[2] = 1;
	u.dudes[3] = "Greater Daemon of Slaanesh";
	u.dudes_num[3] = 1;
	u.dudes[4] = "Venerable Chaos Terminator";
	u.dudes_num[4] = 20;
	u.dudes[5] = "Venerable Chaos Chosen";
	u.dudes_num[5] = 50;
	// u.dudes[4]="Chaos Basilisk";u.dudes_num[4]=18;
	instance_deactivate_object(u);

	u = instance_nearest(xxx + 10, 240, obj_enunit);
	// u.dudes[1]="Chaos Leman Russ";u.dudes_num[1]=40;
	u.dudes[1] = "Chaos Sorcerer";
	u.dudes_num[1] = 2;
	u.dudes[1] = "Cultist";
	u.dudes_num[1] = 100;
	u.dudes[2] = "Helbrute";
	u.dudes_num[2] = 1;
	instance_deactivate_object(u);
}
// * Imperial Guard Force *
if (enemy = 2) {
	guard_total = threat;
	guard_score = 6;

	/*if (guard_total>=15000000) then guard_score=6;
	if (guard_total<15000000) and (guard_total>=6000000) then guard_score=5;
	if (guard_total<6000000) and (guard_total>=1000000) then guard_score=4;
	if (guard_total<1000000) and (guard_total>=50000) then guard_score=3;
	if (guard_total<50000) and (guard_total>=500) then guard_score=2;
	if (guard_total<500) then guard_score=1;*/

	// guard_effective=floor(guard_total)/8;

	var f = 0,
		guar = threat / 10;

	// Guardsmen
	u = instance_create(xxx, 240, obj_enunit);
	enemy_dudes = threat;
	u.dudes[1] = "Imperial Guardsman";
	u.dudes_num[1] = round(guar / 5);
	enemies[1] = u.dudes[1];
	instance_deactivate_object(u);

	f = round(threat / 20000);
	// Leman Russ D and Ogryn
	if (f > 0) {
		u = instance_create(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Leman Russ Demolisher";
		u.dudes_num[1] = f;
		enemies[1] = u.dudes[1];
		f = max(10, round(threat / 6650));
		u.dudes[2] = "Ogryn";
		u.dudes_num[2] = f;
		enemies[2] = u.dudes[2];
		instance_deactivate_object(u);
	}

	// Chimera and Leman Russ
	f = max(1, round(threat / 10000));
	u = instance_create(xxx + 20, 240, obj_enunit);
	u.dudes[1] = "Leman Russ Battle Tank";
	u.dudes_num[1] = f;
	enemies[1] = u.dudes[1];
	f = max(1, round(threat / 20000));
	u.dudes[2] = "Chimera";
	u.dudes_num[2] = f;
	enemies[2] = u.dudes[2];
	instance_deactivate_object(u);

	// More Guard
	u = instance_create(xxx + 30, 240, obj_enunit);
	u.dudes[1] = "Imperial Guardsman";
	u.dudes_num[1] = round(guar / 5);
	enemies[1] = u.dudes[1];

	u = instance_create(xxx + 40, 240, obj_enunit);
	u.dudes[1] = "Imperial Guardsman";
	u.dudes_num[1] = round(guar / 5);
	enemies[1] = u.dudes[1];

	u = instance_create(xxx + 50, 240, obj_enunit);
	u.dudes[1] = "Imperial Guardsman";
	u.dudes_num[1] = round(guar / 5);
	enemies[1] = u.dudes[1];

	u = instance_create(xxx + 60, 240, obj_enunit);
	u.dudes[1] = "Imperial Guardsman";
	u.dudes_num[1] = round(guar / 5);
	enemies[1] = u.dudes[1];

	u = instance_create(xxx + 70, 240, obj_enunit);
	f = round(threat / 50000);

	// Basilisk and Heavy Weapons
	if (f > 0) {
		u.dudes[1] = "Basilisk";
		u.dudes_num[1] = f;
		enemies[1] = u.dudes[1];
		u.dudes[2] = "Heavy Weapons Team";
		u.dudes_num[2] = round(threat / 10000);
		enemies[2] = u.dudes[2];
	}
	// Heavy Weapons
	else {
		u.dudes[1] = "Heavy Weapons Team";
		u.dudes_num[1] = round(threat / 10000);
		enemies[1] = u.dudes[1];
	}

	f = round(threat / 40000);
	// Vendetta
	if (f > 0) {
		u = instance_create(0, 240, obj_enunit);
		u.dudes[1] = "Vendetta";
		u.dudes_num[1] = f;
		u.flank = 1;
		u.flyer = 1;
	}

	/*u=instance_nearest(xxx,240,obj_enunit);enemy_dudes=threat;
	u.dudes[1]="Imperial Guardsman";u.dudes_num[1]=floor(guard_effective*0.6);enemies[1]=u.dudes[1];
	u.dudes[2]="Heavy Weapons Team";u.dudes_num[2]=min(1000,floor(guard_effective*0.1));enemies[2]=u.dudes[2];
	if (threat>1){u.dudes[3]="Leman Russ Battle Tank";u.dudes_num[3]=min(1000,floor(guard_effective*0.1));enemies[3]=u.dudes[3];}
	
	u=instance_nearest(xxx,240+10,obj_enunit);enemy_dudes=threat;
	u.dudes[1]="Imperial Guardsman";u.dudes_num[1]=floor(guard_effective*0.6);enemies[1]=u.dudes[1];
	u.dudes[2]="Heavy Weapons Team";u.dudes_num[2]=min(1000,floor(guard_effective*0.1));enemies[2]=u.dudes[2];
	if (threat>1){u.dudes[3]="Leman Russ Battle Tank";u.dudes_num[3]=min(1000,floor(guard_effective*0.1));enemies[3]=u.dudes[3];}*/
}

// ** Aeldar Force **
if (enemy = 6) {
	// Ranger Group
	if (threat = 1) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "20";

		u.dudes[1] = "Pathfinder";
		u.dudes_num[1] = 1;
		enemies[1] = u.dudes[1];
		u.dudes[2] = "Ranger";
		u.dudes_num[2] = 10;
		enemies[2] = u.dudes[2];
		u.dudes[3] = "Striking Scorpian";
		u.dudes_num[3] = 10;
		enemies[3] = u.dudes[3];
	}
	// Harlequin Group
	if (threat = 1) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "9";

		u.dudes[1] = "Athair";
		u.dudes_num[1] = 1;
		enemies[1] = u.dudes[1];
		u.dudes[2] = "Warlock";
		u.dudes_num[2] = 2;
		enemies[2] = u.dudes[2];
		u.dudes[3] = "Trouper";
		u.dudes_num[3] = 6;
		enemies[3] = u.dudes[3];
	}
	// Craftworld Small Group
	if (threat = 1) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "24";

		u.dudes[1] = "Warlock";
		u.dudes_num[1] = 1;
		enemies[1] = u.dudes[1];
		enemies_num[1] = 1;
		u.dudes[2] = choose("Howling Banshee", "Striking Scorpian");
		u.dudes_num[2] = 8;
		enemies[2] = u.dudes[2];
		u.dudes[3] = "Dire Avenger";
		u.dudes_num[3] = 15;
		enemies[3] = u.dudes[3];
		if (leader = 1) {
			u.dudes[4] = "Leader";
			u.dudes_num[4] = 1;
			enemies[4] = 1;
			enemies_num[4] = 1;
			if (obj_controller.faction_gender[6] = 2) then u.dudes[2] = "Howling Banshee";
			if (obj_controller.faction_gender[6] = 2) then u.dudes[2] = "Dark Reapers";
		}
	}
	// Craftworld Medium Group
	if (threat = 2) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "100";

		u.dudes[1] = "Dire Avenger";
		u.dudes_num[1] = 56;
		u.dudes_special[1] = "shimmershield";
		u.dudes[2] = "Dire Avenger Exarch";
		u.dudes_num[2] = 4;
		u.dudes_special[2] = "shimmershield";
		u.dudes[3] = "Autarch";
		u.dudes_num[3] = 1;
		u.dudes[4] = "Farseer";
		u.dudes_num[4] = 1;
		u.dudes_special[4] = "farseer_powers";
		u.dudes[5] = "Night Spinner";
		u.dudes_num[5] = 1;
		// Spawn leader
		if (leader = 1) {
			u.dudes[4] = "Leader";
			u.dudes_num[4] = 1;
			enemies[4] = 1;
			enemies_num[4] = 1;
		}

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Fire Dragon";
		u.dudes_num[1] = 7;
		u.dudes[2] = "Fire Dragon Exarch";
		u.dudes_num[2] = 1;
		u.dudes[3] = "Warp Spider";
		u.dudes_num[3] = 7;
		u.dudes_special[3] = "warp_jump";
		u.dudes[4] = "Warp Spider Exarch";
		u.dudes_num[4] = 1;
		u.dudes_special[4] = "warp_jump";
		u.dudes[5] = "Howling Banshee";
		u.dudes_num[5] = 9;
		u.dudes_special[5] = "banshee_mask";
		u.dudes[6] = "Howling Banshee Exarch";
		u.dudes_num[6] = 1;
		u.dudes_special[6] = "banshee_mask";
		u.dudes[7] = "Striking Scorpian";
		u.dudes_num[7] = 9;
		u.dudes[8] = "Striking Scorpian Exarch";
		u.dudes_num[8] = 1;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 20, 240, obj_enunit);
		u.dudes[1] = "Falcon";
		u.dudes_num[1] = 2;
	}
	// Craftworld Large Group
	if (threat = 3) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "300";

		u.dudes[1] = "Dire Avenger";
		u.dudes_num[1] = 140;
		u.dudes_special[1] = "shimmershield";
		u.dudes[2] = "Dire Avenger Exarch";
		u.dudes_num[2] = 10;
		u.dudes_special[2] = "shimmershield";
		u.dudes[3] = "Autarch";
		u.dudes_num[3] = 1;
		u.dudes[4] = "Farseer";
		u.dudes_num[4] = 1;
		u.dudes_special[4] = "farseer_powers";
		// Spawn Leader
		if (leader = 1) {
			u.dudes[4] = "Leader";
			u.dudes_num[4] = 1;
			enemies[4] = 1;
			enemies_num[4] = 1;
		}
		u.dudes[5] = "Fire Prism";
		u.dudes_num[5] = 3;
		u.dudes[6] = "Avatar";
		u.dudes_num[6] = 1;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Fire Dragon";
		u.dudes_num[1] = 18;
		u.dudes[2] = "Fire Dragon Exarch";
		u.dudes_num[2] = 2;
		u.dudes[3] = "Warp Spider";
		u.dudes_num[3] = 18;
		u.dudes_special[3] = "warp_jump";
		u.dudes[4] = "Warp Spider Exarch";
		u.dudes_num[4] = 2;
		u.dudes_special[4] = "warp_jump";
		u.dudes[5] = "Howling Banshee";
		u.dudes_num[5] = 28;
		u.dudes_special[5] = "banshee_mask";
		u.dudes[6] = "Howling Banshee Exarch";
		u.dudes_num[6] = 2;
		u.dudes_special[6] = "banshee_mask";
		u.dudes[7] = "Striking Scorpian";
		u.dudes_num[7] = 19;
		u.dudes[8] = "Striking Scorpian Exarch";
		u.dudes_num[8] = 1;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 20, 240, obj_enunit);
		u.dudes[1] = "Falcon";
		u.dudes_num[1] = 5;
		u.dudes[2] = "Vyper";
		u.dudes_num[2] = 12;
		u.dudes[3] = "Wraithguard";
		u.dudes_num[3] = 30;
		u.dudes[4] = "Wraithlord";
		u.dudes_num[4] = 2;
	}
	// Craftworld Small Army
	if (threat = 4) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "1100";

		u.dudes[1] = "Dire Avenger";
		u.dudes_num[1] = 280;
		u.dudes_special[1] = "shimmershield";
		u.dudes[2] = "Dire Avenger Exarch";
		u.dudes_num[2] = 20;
		u.dudes_special[2] = "shimmershield";
		u.dudes[3] = "Autarch";
		u.dudes_num[3] = 3;
		u.dudes[4] = "Farseer";
		u.dudes_num[4] = 2;
		u.dudes_special[4] = "farseer_powers";
		// Spawn Leader
		if (leader = 1) {
			u.dudes[4] = "Leader";
			u.dudes_num[4] = 1;
			enemies[4] = 1;
			enemies_num[4] = 1;
		}
		u.dudes[5] = "Fire Prism";
		u.dudes_num[5] = 3;
		u.dudes[6] = "Avatar";
		u.dudes_num[6] = 1;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Warlock";
		u.dudes_num[1] = 40;
		u.dudes[2] = "Guardian";
		u.dudes_num[2] = 400;
		u.dudes[3] = "Grav Platform";
		u.dudes_num[3] = 20;
		u.dudes[4] = "Dark Reaper";
		u.dudes_num[4] = 18;
		u.dudes[5] = "Dark Reaper Exarch";
		u.dudes_num[5] = 2;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 20, 240, obj_enunit);
		u.dudes[1] = "Fire Dragon";
		u.dudes_num[1] = 36;
		u.dudes[2] = "Fire Dragon Exarch";
		u.dudes_num[2] = 4;
		u.dudes[3] = "Warp Spider";
		u.dudes_num[3] = 36;
		u.dudes_special[3] = "warp_jump";
		u.dudes[4] = "Warp Spider Exarch";
		u.dudes_num[4] = 4;
		u.dudes_special[4] = "warp_jump";
		u.dudes[5] = "Howling Banshee";
		u.dudes_num[5] = 36;
		u.dudes_special[5] = "banshee_mask";
		u.dudes[6] = "Howling Banshee Exarch";
		u.dudes_num[6] = 4;
		u.dudes_special[6] = "banshee_mask";
		u.dudes[7] = "Striking Scorpian";
		u.dudes_num[7] = 38;
		u.dudes[8] = "Striking Scorpian Exarch";
		u.dudes_num[8] = 2;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 30, 240, obj_enunit);
		u.dudes[1] = "Falcon";
		u.dudes_num[1] = 12;
		u.dudes[2] = "Vyper";
		u.dudes_num[2] = 20;
		u.dudes[3] = "Wraithguard";
		u.dudes_num[3] = 90;
		u.dudes[4] = "Wraithlord";
		u.dudes_num[4] = 5;
		u.dudes[5] = "Shining Spear";
		u.dudes_num[5] = 40;
	}
	// Craftworld Medium Army
	if (threat = 5) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "2500";

		u.dudes[1] = "Dire Avenger";
		u.dudes_num[1] = 450;
		u.dudes_special[1] = "shimmershield";
		u.dudes[2] = "Dire Avenger Exarch";
		u.dudes_num[2] = 50;
		u.dudes_special[2] = "shimmershield";
		u.dudes[3] = "Autarch";
		u.dudes_num[3] = 5;
		u.dudes[4] = "Farseer";
		u.dudes_num[4] = 3;
		u.dudes_special[4] = "farseer_powers";
		// Spawn Leader
		if (leader = 1) {
			u.dudes[4] = "Leader";
			u.dudes_num[4] = 1;
			enemies[4] = 1;
			enemies_num[4] = 1;
		}
		u.dudes[5] = "Fire Prism";
		u.dudes_num[5] = 6;
		u.dudes[6] = "Mighty Avatar";
		u.dudes_num[6] = 1;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Warlock";
		u.dudes_num[1] = 80;
		u.dudes[2] = "Guardian";
		u.dudes_num[2] = 1200;
		u.dudes[3] = "Grav Platform";
		u.dudes_num[3] = 40;
		u.dudes[4] = "Dark Reaper";
		u.dudes_num[4] = 36;
		u.dudes[5] = "Dark Reaper Exarch";
		u.dudes_num[5] = 4;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 20, 240, obj_enunit);
		u.dudes[1] = "Fire Dragon";
		u.dudes_num[1] = 72;
		u.dudes[2] = "Fire Dragon Exarch";
		u.dudes_num[2] = 8;
		u.dudes[3] = "Warp Spider";
		u.dudes_num[3] = 72;
		u.dudes_special[3] = "warp_jump";
		u.dudes[4] = "Warp Spider Exarch";
		u.dudes_num[4] = 8;
		u.dudes_special[4] = "warp_jump";
		u.dudes[5] = "Howling Banshee";
		u.dudes_num[5] = 72;
		u.dudes_special[5] = "banshee_mask";
		u.dudes[6] = "Howling Banshee Exarch";
		u.dudes_num[6] = 8;
		u.dudes_special[6] = "banshee_mask";
		u.dudes[7] = "Striking Scorpian";
		u.dudes_num[7] = 72;
		u.dudes[8] = "Striking Scorpian Exarch";
		u.dudes_num[8] = 8;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 30, 240, obj_enunit);
		u.dudes[1] = "Falcon";
		u.dudes_num[1] = 24;
		u.dudes[2] = "Vyper";
		u.dudes_num[2] = 40;
		u.dudes[3] = "Wraithguard";
		u.dudes_num[3] = 180;
		u.dudes[4] = "Wraithlord";
		u.dudes_num[4] = 10;
		u.dudes[5] = "Shining Spear";
		u.dudes_num[5] = 80;
	}
	// Craftworld Large Army
	if (threat = 6) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "5000";

		u.dudes[1] = "Dire Avenger";
		u.dudes_num[1] = 540;
		u.dudes_special[1] = "shimmershield";
		u.dudes[2] = "Dire Avenger Exarch";
		u.dudes_num[2] = 60;
		u.dudes_special[2] = "shimmershield";
		u.dudes[3] = "Autarch";
		u.dudes_num[3] = 8;
		u.dudes[4] = "Farseer";
		u.dudes_num[4] = 4;
		u.dudes_special[4] = "farseer_powers";
		// Spawn Leader
		if (leader = 1) {
			u.dudes[4] = "Leader";
			u.dudes_num[4] = 1;
			enemies[4] = 1;
			enemies_num[4] = 1;
		}
		u.dudes[5] = "Fire Prism";
		u.dudes_num[5] = 12;
		u.dudes[6] = "Godly Avatar";
		u.dudes_num[6] = 1;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Warlock";
		u.dudes_num[1] = 100;
		u.dudes[2] = "Guardian";
		u.dudes_num[2] = 3000;
		u.dudes[3] = "Grav Platform";
		u.dudes_num[3] = 80;
		u.dudes[4] = "Dark Reaper";
		u.dudes_num[4] = 72;
		u.dudes[5] = "Dark Reaper Exarch";
		u.dudes_num[5] = 8;
		u.dudes[6] = "Phantom Titan";
		u.dudes_num[6] = 2;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 20, 240, obj_enunit);
		u.dudes[1] = "Fire Dragon";
		u.dudes_num[1] = 144;
		u.dudes[2] = "Fire Dragon Exarch";
		u.dudes_num[2] = 16;
		u.dudes[3] = "Warp Spider";
		u.dudes_num[3] = 144;
		u.dudes_special[3] = "warp_jump";
		u.dudes[4] = "Warp Spider Exarch";
		u.dudes_num[4] = 16;
		u.dudes_special[4] = "warp_jump";
		u.dudes[5] = "Howling Banshee";
		u.dudes_num[5] = 144;
		u.dudes_special[5] = "banshee_mask";
		u.dudes[6] = "Howling Banshee Exarch";
		u.dudes_num[6] = 16;
		u.dudes_special[6] = "banshee_mask";
		u.dudes[7] = "Striking Scorpian";
		u.dudes_num[7] = 144;
		u.dudes[8] = "Striking Scorpian Exarch";
		u.dudes_num[8] = 16;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 30, 240, obj_enunit);
		u.dudes[1] = "Falcon";
		u.dudes_num[1] = 48;
		u.dudes[2] = "Vyper";
		u.dudes_num[2] = 80;
		u.dudes[3] = "Wraithguard";
		u.dudes_num[3] = 360;
		u.dudes[4] = "Wraithlord";
		u.dudes_num[4] = 20;
		u.dudes[5] = "Shining Spear";
		u.dudes_num[5] = 160;
	}
}

// ** Sisters Force **
if (enemy = 5) {
	// Small Sister Group
	if (threat = 1) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "110";

		u.dudes[1] = "Celestian";
		u.dudes_num[1] = 1;
		enemies[1] = u.dudes[1];
		// Spawn Leader
		if (leader = 1) {
			u.dudes[1] = "Leader";
			u.dudes_num[1] = 1;
			enemies[1] = 1;
			enemies_num[1] = 1;
		}
		u.dudes[2] = "Battle Sister";
		u.dudes_num[2] = 4;
		enemies[2] = u.dudes[2];
		u.dudes[3] = "Priest";
		u.dudes_num[3] = 10;
		enemies[3] = u.dudes[3];
		u.dudes[4] = "Follower";
		u.dudes_num[4] = 100;
		enemies[4] = u.dudes[4];
	}
	// Medium Sister Group
	if (threat = 2) {
		u = instance_nearest(xxx + 10, 240, obj_enunit);
		enemy_dudes = "nearly 400";

		u.dudes[1] = "Celestian";
		u.dudes_num[1] = 1;
		// Spawn Leader
		if (leader = 1) {
			u.dudes[1] = "Leader";
			u.dudes_num[1] = 1;
			enemies[1] = 1;
			enemies_num[1] = 1;
		}
		u.dudes[2] = "Battle Sister";
		u.dudes_num[2] = 50;
		u.dudes[3] = "Follower";
		u.dudes_num[3] = 300;
		instance_deactivate_object(u);

		u = instance_nearest(xxx + 20, 240, obj_enunit);
		u.dudes[1] = "Arco-Flagellent";
		u.dudes_num[1] = 50;
		u.dudes[2] = "Chimera";
		u.dudes_num[2] = 3;
	}
	// Large Sister Group
	if (threat = 3) {
		u = instance_nearest(xxx + 30, 240, obj_enunit);
		enemy_dudes = "1000";

		u.dudes[1] = "Palatine";
		u.dudes_num[1] = 1;
		// Spawn Leader
		if (leader = 1) {
			u.dudes[1] = "Leader";
			u.dudes_num[1] = 1;
			enemies[1] = 1;
			enemies_num[1] = 1;
		}
		u.dudes[2] = "Battle Sister";
		u.dudes_num[2] = 200;
		u.dudes[3] = "Celestian";
		u.dudes_num[3] = 40;
		u.dudes[4] = "Retributor";
		u.dudes_num[4] = 50;
		u.dudes[5] = "Priest";
		u.dudes_num[5] = 60;
		instance_deactivate_object(u);

		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Seraphim";
		u.dudes_num[1] = 50;
		u.dudes[2] = "Dominion";
		u.dudes_num[2] = 50;
		u.dudes[3] = "Immolator";
		u.dudes_num[3] = 4;
		u.dudes[4] = "Exorcist";
		u.dudes_num[4] = 2;
		instance_deactivate_object(u);

		u = instance_nearest(xxx, 240, obj_enunit);
		u.dudes[1] = "Follower";
		u.dudes_num[1] = 450;
		u.dudes[2] = "Sister Repentia";
		u.dudes_num[2] = 50;
		u.dudes[3] = "Arco-Flagellent";
		u.dudes_num[3] = 30;
		u.dudes[4] = "Penitent Engine";
		u.dudes_num[4] = 4;
	}
	// Small Sister Army
	if (threat = 4) {
		u = instance_nearest(xxx + 30, 240, obj_enunit);
		enemy_dudes = "4000";

		u.dudes[1] = "Palatine";
		u.dudes_num[1] = 2;
		// Spawn Leader
		if (leader = 1) {
			u.dudes[1] = "Leader";
			u.dudes_num[1] = 1;
			enemies[1] = 1;
			enemies_num[1] = 1;
		}
		u.dudes[2] = "Battle Sister";
		u.dudes_num[2] = 1000;
		u.dudes[3] = "Celestian";
		u.dudes_num[3] = 150;
		u.dudes[4] = "Retributor";
		u.dudes_num[4] = 150;
		u.dudes[5] = "Priest";
		u.dudes_num[5] = 150;
		instance_deactivate_object(u);

		u = instance_nearest(xxx + 20, 240, obj_enunit);
		u.dudes[1] = "Seraphim";
		u.dudes_num[1] = 200;
		u.dudes[2] = "Dominion";
		u.dudes_num[2] = 200;
		u.dudes[3] = "Immolator";
		u.dudes_num[3] = 15;
		u.dudes[4] = "Exorcist";
		u.dudes_num[4] = 6;
		u.dudes[5] = "Follower";
		u.dudes_num[5] = 600;
		instance_deactivate_object(u);

		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Follower";
		u.dudes_num[1] = 1500;
		u.dudes[2] = "Sister Repentia";
		u.dudes_num[2] = 100;
		u.dudes[3] = "Arco-Flagellent";
		u.dudes_num[3] = 30;
		u.dudes[4] = "Penitent Engine";
		u.dudes_num[4] = 4;
		u.dudes[5] = "Mistress";
		u.dudes_num[5] = 10;
	}
	// Medium Sister Army
	if (threat = 5) {
		u = instance_nearest(xxx + 40, 240, obj_enunit);
		enemy_dudes = "8000";

		u.dudes[1] = "Palatine";
		u.dudes_num[1] = 2;
		// Spawn Leader
		if (leader = 1) {
			u.dudes[1] = "Leader";
			u.dudes_num[1] = 1;
			enemies[1] = 1;
			enemies_num[1] = 1;
		}
		u.dudes[2] = "Battle Sister";
		u.dudes_num[2] = 1000;
		u.dudes[3] = "Celestian";
		u.dudes_num[3] = 150;
		u.dudes[4] = "Retributor";
		u.dudes_num[4] = 200;
		u.dudes[5] = "Priest";
		u.dudes_num[5] = 200;
		instance_deactivate_object(u);

		u = instance_nearest(xxx + 30, 240, obj_enunit);
		u.dudes[1] = "Battle Sister";
		u.dudes_num[1] = 1000;
		u.dudes[2] = "Celestian";
		u.dudes_num[2] = 150;
		u.dudes[3] = "Retributor";
		u.dudes_num[3] = 200;
		u.dudes[4] = "Priest";
		u.dudes_num[4] = 200;
		instance_deactivate_object(u);

		u = instance_nearest(xxx + 20, 240, obj_enunit);
		u.dudes[1] = "Seraphim";
		u.dudes_num[1] = 200;
		u.dudes[2] = "Dominion";
		u.dudes_num[2] = 200;
		u.dudes[3] = "Immolator";
		u.dudes_num[3] = 25;
		u.dudes[4] = "Exorcist";
		u.dudes_num[4] = 10;
		u.dudes[5] = "Follower";
		u.dudes_num[5] = 2000;
		instance_deactivate_object(u);

		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Follower";
		u.dudes_num[1] = 2000;
		u.dudes[2] = "Sister Repentia";
		u.dudes_num[2] = 300;
		u.dudes[3] = "Arco-Flagellent";
		u.dudes_num[3] = 100;
		u.dudes[4] = "Penitent Engine";
		u.dudes_num[4] = 15;
		u.dudes[5] = "Mistress";
		u.dudes_num[5] = 30;
	}
	// Large Sister Army
	if (threat = 6) {
		u = instance_nearest(xxx + 50, 240, obj_enunit);
		enemy_dudes = "12000";

		u.dudes[1] = "Palatine";
		u.dudes_num[1] = 1;
		// Spawn Leader
		if (leader = 1) {
			u.dudes[1] = "Leader";
			u.dudes_num[1] = 1;
			enemies[1] = 1;
			enemies_num[1] = 1;
		}
		u.dudes[2] = "Battle Sister";
		u.dudes_num[2] = 1500;
		u.dudes[3] = "Celestian";
		u.dudes_num[3] = 150;
		u.dudes[4] = "Retributor";
		u.dudes_num[4] = 200;
		u.dudes[5] = "Priest";
		u.dudes_num[5] = 200;
		instance_deactivate_object(u);

		u = instance_nearest(xxx + 40, 240, obj_enunit);
		u.dudes[1] = "Battle Sister";
		u.dudes_num[1] = 1500;
		u.dudes[2] = "Celestian";
		u.dudes_num[2] = 150;
		u.dudes[3] = "Retributor";
		u.dudes_num[3] = 200;
		u.dudes[4] = "Priest";
		u.dudes_num[4] = 200;
		instance_deactivate_object(u);

		u = instance_nearest(xxx + 30, 240, obj_enunit);
		u.dudes[1] = "Seraphim";
		u.dudes_num[1] = 200;
		u.dudes[2] = "Dominion";
		u.dudes_num[2] = 200;
		u.dudes[3] = "Immolator";
		u.dudes_num[3] = 50;
		u.dudes[4] = "Exorcist";
		u.dudes_num[4] = 20;
		u.dudes[5] = "Follower";
		u.dudes_num[5] = 2000;
		instance_deactivate_object(u);

		u = instance_nearest(xxx + 20, 240, obj_enunit);
		u.dudes[1] = "Follower";
		u.dudes_num[1] = 2000;
		u.dudes[2] = "Sister Repentia";
		u.dudes_num[2] = 500;
		u.dudes[3] = "Arco-Flagellent";
		u.dudes_num[3] = 250;
		u.dudes[4] = "Penitent Engine";
		u.dudes_num[4] = 30;
		u.dudes[5] = "Mistress";
		u.dudes_num[5] = 50;
		instance_deactivate_object(u);

		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Follower";
		u.dudes_num[1] = 3000;
	}
}

// ** Orks Forces **
if (enemy = 7) {
	// u=instance_create(-10,240,obj_enunit);
	// u.dudes[1]="Stormboy";u.dudes_num[1]=2500;u.flank=1;// enemies[1]=u.dudes[1];

	// Small Ork Group
	if (threat = 1) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "100";

		u.dudes[1] = "Meganob";
		u.dudes_num[1] = 1;
		enemies[1] = u.dudes[1];
		u.dudes[2] = "Slugga Boy";
		u.dudes_num[2] = 50;
		enemies[2] = u.dudes[2];
		u.dudes[3] = "Shoota Boy";
		u.dudes_num[3] = 50;
		enemies[3] = u.dudes[3];
		// Spawn Leader
		if (leader = 1) {
			u.dudes[4] = "Leader";
			u.dudes_num[4] = 1;
			enemies[4] = 1;
			enemies_num[4] = 1;
		}
	}
	// Medium Ork Group
	if (threat = 2) {
		u = instance_nearest(xxx + 10, 240, obj_enunit);
		enemy_dudes = "nearly 350";

		u.dudes[1] = "Slugga Boy";
		u.dudes_num[1] = 50;
		u.dudes[2] = "Shoota Boy";
		u.dudes_num[2] = 50;
		instance_deactivate_object(u);

		u = instance_nearest(xxx + 20, 240, obj_enunit);
		u.dudes[1] = "Minor Warboss";
		u.dudes_num[1] = 1;
		u.dudes[2] = "Meganob";
		u.dudes_num[2] = 5;
		u.dudes[3] = "Slugga Boy";
		u.dudes_num[3] = 70;
		u.dudes[4] = "Ard Boy";
		u.dudes_num[4] = 70;
		u.dudes[5] = "Shoota Boy";
		u.dudes_num[5] = 100;
		// Spawn Leader
		if (leader = 1) {
			u.dudes[1] = "Leader";
			u.dudes_num[1] = 1;
			enemies[1] = 1;
			enemies_num[1] = 1;
		}
	}
	// Large Ork Group
	if (threat = 3) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "over a 1000";

		u.dudes[1] = "Slugga Boy";
		u.dudes_num[1] = 300;
		u.dudes[2] = "Ard Boy";
		u.dudes_num[2] = 150;
		instance_deactivate_object(u);

		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Deff Dread";
		u.dudes_num[1] = 9;
		u.dudes[2] = "Battlewagon";
		u.dudes_num[2] = 6;
		u.dudes[3] = "Mekboy";
		u.dudes_num[3] = 1;
		u.dudes[4] = "Flash Git";
		u.dudes_num[4] = 12;
		instance_deactivate_object(u);

		u = instance_nearest(xxx + 20, 240, obj_enunit);
		u.dudes[1] = "Warboss";
		u.dudes_num[1] = 1;
		// Spawn Leader
		if (leader = 1) {
			u.dudes[1] = "Leader";
			u.dudes_num[1] = 1;
			enemies[1] = 1;
			enemies_num[1] = 1;
		}
		u.dudes[2] = "Meganob";
		u.dudes_num[2] = 10;
		u.dudes[3] = "Slugga Boy";
		u.dudes_num[3] = 100;
		u.dudes[4] = "Ard Boy";
		u.dudes_num[4] = 150;
		u.dudes[5] = "Shoota Boy";
		u.dudes_num[5] = 350;
	}
	// Small Ork Army
	if (threat = 4) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "a green tide of over 3600";

		u.dudes[1] = "Slugga Boy";
		u.dudes_num[1] = 600;
		u.dudes[2] = "Ard Boy";
		u.dudes_num[2] = 300;
		u.dudes[3] = "Gretchin";
		u.dudes_num[3] = 1000;
		instance_deactivate_object(u);

		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Deff Dread";
		u.dudes_num[1] = 21;
		u.dudes[2] = "Battlewagon";
		u.dudes_num[2] = 12;
		u.dudes[3] = "Mekboy";
		u.dudes_num[3] = 3;
		u.dudes[4] = "Flash Git";
		u.dudes_num[4] = 30;
		instance_deactivate_object(u);

		u = instance_nearest(xxx + 20, 240, obj_enunit);
		u.dudes[1] = "Warboss";
		u.dudes_num[1] = 1;
		// Spawn Leader
		if (leader = 1) {
			u.dudes[1] = "Leader";
			u.dudes_num[1] = 1;
			enemies[1] = 1;
			enemies_num[1] = 1;
		}
		u.dudes[2] = "Meganob";
		u.dudes_num[2] = 30;
		u.dudes[3] = "Slugga Boy";
		u.dudes_num[3] = 300;
		u.dudes[4] = "Ard Boy";
		u.dudes_num[4] = 450;
		u.dudes[5] = "Shoota Boy";
		u.dudes_num[5] = 1000;
	}
	// Medium Ork Army
	if (threat = 5) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "a green tide of over 7000";

		u.dudes[1] = "Slugga Boy";
		u.dudes_num[1] = 1200;
		u.dudes[2] = "Ard Boy";
		u.dudes_num[2] = 600;
		u.dudes[3] = "Gretchin";
		u.dudes_num[3] = 2000;
		u.dudes[4] = "Tank Busta";
		u.dudes_num[4] = 100;
		instance_deactivate_object(u);

		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Deff Dread";
		u.dudes_num[1] = 40;
		u.dudes[2] = "Battlewagon";
		u.dudes_num[2] = 18;
		u.dudes[3] = "Mekboy";
		u.dudes_num[3] = 6;
		u.dudes[4] = "Flash Git";
		u.dudes_num[4] = 50;
		u.dudes[5] = "Kommando";
		u.dudes_num[5] = 20;
		instance_deactivate_object(u);

		u = instance_nearest(xxx + 20, 240, obj_enunit);
		u.dudes[1] = "Warboss";
		u.dudes_num[1] = 1;
		// Spawn Leader
		if (leader = 1) {
			u.dudes[1] = "Leader";
			u.dudes_num[1] = 1;
			enemies[1] = 1;
			enemies_num[1] = 1;
		}
		u.dudes[2] = "Meganob";
		u.dudes_num[2] = 80;
		u.dudes[3] = "Slugga Boy";
		u.dudes_num[3] = 600;
		u.dudes[4] = "Ard Boy";
		u.dudes_num[4] = 900;
		u.dudes[5] = "Shoota Boy";
		u.dudes_num[5] = 2000;
	}
	// Large Ork Army
	if (threat = 6) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "a WAAAAGH!! of 11000";

		u.dudes[1] = "Slugga Boy";
		u.dudes_num[1] = 1200;
		u.dudes[2] = "Ard Boy";
		u.dudes_num[2] = 600;
		u.dudes[3] = "Gretchin";
		u.dudes_num[3] = 2000;
		u.dudes[4] = "Tank Busta";
		u.dudes_num[4] = 100;
		instance_deactivate_object(u);

		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Deff Dread";
		u.dudes_num[1] = 40;
		u.dudes[2] = "Battlewagon";
		u.dudes_num[2] = 18;
		u.dudes[3] = "Mekboy";
		u.dudes_num[3] = 6;
		u.dudes[4] = "Flash Git";
		u.dudes_num[4] = 50;
		u.dudes[5] = "Kommando";
		u.dudes_num[5] = 20;
		instance_deactivate_object(u);

		u = instance_nearest(xxx + 20, 240, obj_enunit);
		u.dudes[1] = "Slugga Boy";
		u.dudes_num[1] = 1200;
		u.dudes[2] = "Ard Boy";
		u.dudes_num[2] = 600;
		u.dudes[3] = "Gretchin";
		u.dudes_num[3] = 2000;
		u.dudes[4] = "Tank Busta";
		u.dudes_num[4] = 100;
		instance_deactivate_object(u);

		u = instance_nearest(xxx + 30, 240, obj_enunit);
		u.dudes[1] = "Deff Dread";
		u.dudes_num[1] = 40;
		u.dudes[2] = "Battlewagon";
		u.dudes_num[2] = 18;
		u.dudes[3] = "Mekboy";
		u.dudes_num[3] = 6;
		u.dudes[4] = "Flash Git";
		u.dudes_num[4] = 50;
		u.dudes[5] = "Kommando";
		u.dudes_num[5] = 20;
		instance_deactivate_object(u);

		u = instance_nearest(xxx + 40, 240, obj_enunit);
		u.dudes[1] = "Big Warboss";
		u.dudes_num[1] = 1;
		// Spawn Leader
		if (leader = 1) {
			u.dudes[1] = "Leader";
			u.dudes_num[1] = 1;
			enemies[1] = 1;
			enemies_num[1] = 1;
		}
		u.dudes[2] = "Meganob";
		u.dudes_num[2] = 80;
		u.dudes[3] = "Slugga Boy";
		u.dudes_num[3] = 600;
		u.dudes[4] = "Ard Boy";
		u.dudes_num[4] = 900;
		u.dudes[5] = "Shoota Boy";
		u.dudes_num[5] = 2000;
	}
}

// ** Tau Forces **
if (enemy = 8) {
	// Small Tau Group
	if (threat = 1) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "11";

		u.dudes[1] = "XV8 Crisis";
		u.dudes_num[1] = 1;
		u.dudes[2] = "Fire Warrior";
		u.dudes_num[2] = 20;
		u.dudes[3] = "Kroot";
		u.dudes_num[3] = 20;
		enemies[3] = u.dudes[3];
	}
	// Medium Tau Group
	if (threat = 2) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "100";

		u.dudes[1] = "XV8 Commander";
		u.dudes_num[1] = 1;
		u.dudes[2] = "XV8 Bodyguard";
		u.dudes_num[2] = 6;
		u.dudes[3] = "Shield Drone";
		u.dudes_num[3] = 4;
		u.dudes[4] = "XV88 Broadside";
		u.dudes_num[4] = 3;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Fire Warrior";
		u.dudes_num[1] = 60;
		u.dudes[2] = "Kroot";
		u.dudes_num[2] = 60;
		u.dudes[3] = "Pathfinder";
		u.dudes_num[3] = 20;
		u.dudes[4] = "XV8 Crisis";
		u.dudes_num[4] = 12;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 20, 240, obj_enunit);
		u.dudes[1] = "Hammerhead";
		u.dudes_num[1] = 2;
		u.dudes[2] = "Devilfish";
		u.dudes_num[2] = 4;

		u = instance_create(0, 240, obj_enunit);
		u.dudes[1] = "XV25 Stealthsuit";
		u.dudes_num[1] = 6;
		u.flank = 1;
	}
	// Large Tau Group
	if (threat = 3) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "100";

		u.dudes[1] = "XV8 Commander";
		u.dudes_num[1] = 1;
		u.dudes[2] = "XV8 Bodyguard";
		u.dudes_num[2] = 9;
		u.dudes[3] = "Shield Drone";
		u.dudes_num[3] = 8;
		u.dudes[4] = "XV88 Broadside";
		u.dudes_num[4] = 6;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Fire Warrior";
		u.dudes_num[1] = 200;
		u.dudes[2] = "Kroot";
		u.dudes_num[2] = 150;
		u.dudes[3] = "Pathfinder";
		u.dudes_num[3] = 40;
		u.dudes[4] = "XV8 Crisis";
		u.dudes_num[4] = 24;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 20, 240, obj_enunit);
		u.dudes[1] = "Hammerhead";
		u.dudes_num[1] = 5;
		u.dudes[2] = "Devilfish";
		u.dudes_num[2] = 10;

		u = instance_create(0, 240, obj_enunit);
		u.dudes[1] = "XV25 Stealthsuit";
		u.dudes_num[1] = 12;
		u.flank = 1;
	}
	// Small Tau Army
	if (threat = 4) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "100";

		u.dudes[1] = "XV8 Commander";
		u.dudes_num[1] = 1;
		u.dudes[2] = "XV8 Bodyguard";
		u.dudes_num[2] = 9;
		u.dudes[3] = "Shield Drone";
		u.dudes_num[3] = 8;
		u.dudes[4] = "XV88 Broadside";
		u.dudes_num[4] = 12;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Fire Warrior";
		u.dudes_num[1] = 800;
		u.dudes[2] = "Kroot";
		u.dudes_num[2] = 500;
		u.dudes[3] = "Pathfinder";
		u.dudes_num[3] = 60;
		u.dudes[4] = "XV8 Crisis";
		u.dudes_num[4] = 48;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 20, 240, obj_enunit);
		u.dudes[1] = "Hammerhead";
		u.dudes_num[1] = 40;
		u.dudes[2] = "Devilfish";
		u.dudes_num[2] = 15;
		u.dudes[3] = "XV8 Crisis";
		u.dudes_num[3] = 48;

		u = instance_create(0, 240, obj_enunit);
		u.dudes[1] = "XV25 Stealthsuit";
		u.dudes_num[1] = 12;
		u.flank = 1;
		u.dudes[2] = "XV8 (Brightknife)";
		u.dudes_num[2] = 6;
		u.flank = 1;
	}
	// Medium Tau Army
	if (threat = 5) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "4000";

		u.dudes[1] = "XV8 Commander";
		u.dudes_num[1] = 2;
		u.dudes[2] = "XV8 Bodyguard";
		u.dudes_num[2] = 18;
		u.dudes[3] = "Shield Drone";
		u.dudes_num[3] = 20;
		u.dudes[4] = "XV88 Broadside";
		u.dudes_num[4] = 24;
		u.dudes[5] = "Vespid";
		u.dudes_num[4] = 30;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Fire Warrior";
		u.dudes_num[1] = 1000;
		u.dudes[2] = "Kroot";
		u.dudes_num[2] = 700;
		u.dudes[3] = "Pathfinder";
		u.dudes_num[3] = 100;
		u.dudes[4] = "XV8 Crisis";
		u.dudes_num[4] = 80;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 20, 240, obj_enunit);
		u.dudes[1] = "Fire Warrior";
		u.dudes_num[1] = 1000;
		u.dudes[2] = "Kroot";
		u.dudes_num[2] = 700;
		u.dudes[3] = "Pathfinder";
		u.dudes_num[3] = 100;
		u.dudes[4] = "XV8 Crisis";
		u.dudes_num[4] = 80;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 30, 240, obj_enunit);
		u.dudes[1] = "Hammerhead";
		u.dudes_num[1] = 40;
		u.dudes[2] = "Devilfish";
		u.dudes_num[2] = 40;
		u.dudes[3] = "XV8 Crisis";
		u.dudes_num[3] = 48;

		u = instance_create(0, 240, obj_enunit);
		u.dudes[1] = "XV25 Stealthsuit";
		u.dudes_num[1] = 12;
		u.flank = 1;
		u.dudes[2] = "XV8 (Brightknife)";
		u.dudes_num[2] = 18;
		u.flank = 1;
	}
	// Large Tau Army
	if (threat = 6) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "6000";

		u.dudes[1] = "XV8 Commander";
		u.dudes_num[1] = 2;
		u.dudes[2] = "XV8 Bodyguard";
		u.dudes_num[2] = 18;
		u.dudes[3] = "Shield Drone";
		u.dudes_num[3] = 20;
		u.dudes[4] = "XV88 Broadside";
		u.dudes_num[4] = 36;
		u.dudes[5] = "Vespid";
		u.dudes_num[4] = 60;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Fire Warrior";
		u.dudes_num[1] = 1000;
		u.dudes[2] = "Kroot";
		u.dudes_num[2] = 700;
		u.dudes[3] = "Pathfinder";
		u.dudes_num[3] = 100;
		u.dudes[4] = "XV8 Crisis";
		u.dudes_num[4] = 80;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 20, 240, obj_enunit);
		u.dudes[1] = "Fire Warrior";
		u.dudes_num[1] = 1000;
		u.dudes[2] = "Kroot";
		u.dudes_num[2] = 700;
		u.dudes[3] = "Pathfinder";
		u.dudes_num[3] = 100;
		u.dudes[4] = "XV8 Crisis";
		u.dudes_num[4] = 80;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 30, 240, obj_enunit);
		u.dudes[1] = "Fire Warrior";
		u.dudes_num[1] = 1000;
		u.dudes[2] = "Kroot";
		u.dudes_num[2] = 700;
		u.dudes[3] = "Pathfinder";
		u.dudes_num[3] = 100;
		u.dudes[4] = "XV8 Crisis";
		u.dudes_num[4] = 80;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 40, 240, obj_enunit);
		u.dudes[1] = "Hammerhead";
		u.dudes_num[1] = 40;
		u.dudes[2] = "Devilfish";
		u.dudes_num[2] = 80;
		u.dudes[3] = "XV8 Crisis";
		u.dudes_num[3] = 80;

		u = instance_create(0, 240, obj_enunit);
		u.dudes[1] = "XV25 Stealthsuit";
		u.dudes_num[1] = 12;
		u.flank = 1;
		u.dudes[2] = "XV8 (Brightknife)";
		u.dudes_num[2] = 24;
		u.flank = 1;
	}
}

// ** Tyranid Forces **
// Tyranid story event
if (enemy = 9) and(battle_special = "tyranid_org") {
	u = instance_nearest(xxx, 240, obj_enunit);
	enemy_dudes = "81";
	u.dudes[1] = "Termagaunt";
	u.dudes_num[1] = 40;
	u.dudes[2] = "Hormagaunt";
	u.dudes_num[2] = 40;
	// u.dudes[3]="Lictor";u.dudes_num[3]=1;
}
if (enemy = 9) and(battle_special != "tyranid_org") {
	// Small Genestealer Group
	if (threat = 1) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "11";

		u.dudes[1] = "Genestealer";
		u.dudes_num[1] = 10;

		u = instance_create(0, 240, obj_enunit);
		u.dudes[1] = "Lictor";
		u.dudes_num[1] = 1;
		u.flank = 1;
	}
	// Medium Genestealer Group
	if (threat = 2) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "100";

		u.dudes[1] = "Genestealer Patriarch";
		u.dudes_num[1] = 1;
		u.dudes[2] = "Genestealer";
		u.dudes_num[2] = 30;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Cultist";
		u.dudes_num[1] = 150;

		u = instance_create(0, 240, obj_enunit);
		u.dudes[1] = "Lictor";
		u.dudes_num[1] = 1;
		u.flank = 1;
	}
	// Large Genestealer Group
	if (threat = 3) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "100";

		u.dudes[1] = "Genestealer Patriarch";
		u.dudes_num[1] = 1;
		u.dudes[2] = "Genestealer";
		u.dudes_num[2] = 120;
		u.dudes[3] = "Armoured Limousine";
		u.dudes_num[3] = 20;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Cultist";
		u.dudes_num[1] = 600;

		u = instance_create(0, 240, obj_enunit);
		u.dudes[1] = "Lictor";
		u.dudes_num[1] = 6;
		u.flank = 1;
	}
	// Small Tyranid Army
	if (threat = 4) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "7000";

		u.dudes[1] = "Hive Tyrant";
		u.dudes_num[1] = 1;
		u.dudes[2] = "Tyrant Guard";
		u.dudes_num[2] = 16;
		u.dudes[3] = "Tyranid Warrior";
		u.dudes_num[3] = 40;
		u.dudes[4] = "Zoanthrope";
		u.dudes_num[4] = 10;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Termagaunt";
		u.dudes_num[1] = 1500;
		u.dudes[2] = "Hormagaunt";
		u.dudes_num[2] = 800;
		u.dudes[3] = "Carnifex";
		u.dudes_num[3] = 5;
		u.dudes[4] = "Tyranid Warrior";
		u.dudes_num[4] = 30;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 20, 240, obj_enunit);
		u.dudes[1] = "Termagaunt";
		u.dudes_num[1] = 1500;
		u.dudes[2] = "Hormagaunt";
		u.dudes_num[2] = 800;
		u.dudes[3] = "Carnifex";
		u.dudes_num[3] = 5;
		u.dudes[4] = "Tyranid Warrior";
		u.dudes_num[4] = 30;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 30, 240, obj_enunit);
		u.dudes[1] = "Termagaunt";
		u.dudes_num[1] = 1500;
		u.dudes[2] = "Hormagaunt";
		u.dudes_num[2] = 800;
		u.dudes[3] = "Carnifex";
		u.dudes_num[3] = 5;
		u.dudes[4] = "Tyranid Warrior";
		u.dudes_num[4] = 30;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 40, 240, obj_enunit);
		u.dudes[1] = "Carnifex";
		u.dudes_num[1] = 6;

		u = instance_create(0, 240, obj_enunit);
		u.dudes[1] = "Lictor";
		u.dudes_num[1] = 15;
		u.flank = 1;
	}
	// Medium Tyranid Army
	if (threat = 5) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "15000";

		u.dudes[1] = "Hive Tyrant";
		u.dudes_num[1] = 2;
		u.dudes[2] = "Tyrant Guard";
		u.dudes_num[2] = 32;
		u.dudes[3] = "Tyranid Warrior";
		u.dudes_num[3] = 80;
		u.dudes[4] = "Zoanthrope";
		u.dudes_num[4] = 20;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Termagaunt";
		u.dudes_num[1] = 3300;
		u.dudes[2] = "Hormagaunt";
		u.dudes_num[2] = 1600;
		u.dudes[3] = "Carnifex";
		u.dudes_num[3] = 10;
		u.dudes[4] = "Tyranid Warrior";
		u.dudes_num[4] = 30;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 20, 240, obj_enunit);
		u.dudes[1] = "Termagaunt";
		u.dudes_num[1] = 3300;
		u.dudes[2] = "Hormagaunt";
		u.dudes_num[2] = 1600;
		u.dudes[3] = "Carnifex";
		u.dudes_num[3] = 10;
		u.dudes[4] = "Tyranid Warrior";
		u.dudes_num[4] = 30;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 30, 240, obj_enunit);
		u.dudes[1] = "Termagaunt";
		u.dudes_num[1] = 3300;
		u.dudes[2] = "Hormagaunt";
		u.dudes_num[2] = 1600;
		u.dudes[3] = "Carnifex";
		u.dudes_num[3] = 10;
		u.dudes[4] = "Tyranid Warrior";
		u.dudes_num[4] = 60;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 40, 240, obj_enunit);
		u.dudes[1] = "Carnifex";
		u.dudes_num[1] = 20;
		u.dudes[2] = "Zoanthrope";
		u.dudes_num[2] = 10;

		u = instance_create(0, 240, obj_enunit);
		u.dudes[1] = "Lictor";
		u.dudes_num[1] = 20;
		u.flank = 1;
	}
	// Large Tyranid Army
	if (threat = 6) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "45000";

		u.dudes[1] = "Hive Tyrant";
		u.dudes_num[1] = 4;
		u.dudes[2] = "Tyrant Guard";
		u.dudes_num[2] = 64;
		u.dudes[3] = "Tyranid Warrior";
		u.dudes_num[3] = 160;
		u.dudes[4] = "Zoanthrope";
		u.dudes_num[4] = 40;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Termagaunt";
		u.dudes_num[1] = 10000;
		u.dudes[2] = "Hormagaunt";
		u.dudes_num[2] = 4000;
		u.dudes[3] = "Carnifex";
		u.dudes_num[3] = 15;
		u.dudes[4] = "Tyranid Warrior";
		u.dudes_num[4] = 90;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 20, 240, obj_enunit);
		u.dudes[1] = "Termagaunt";
		u.dudes_num[1] = 10000;
		u.dudes[2] = "Hormagaunt";
		u.dudes_num[2] = 4000;
		u.dudes[3] = "Carnifex";
		u.dudes_num[3] = 15;
		u.dudes[4] = "Tyranid Warrior";
		u.dudes_num[4] = 90;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 30, 240, obj_enunit);
		u.dudes[1] = "Termagaunt";
		u.dudes_num[1] = 10000;
		u.dudes[2] = "Hormagaunt";
		u.dudes_num[2] = 4000;
		u.dudes[3] = "Carnifex";
		u.dudes_num[3] = 15;
		u.dudes[4] = "Tyranid Warrior";
		u.dudes_num[4] = 90;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 40, 240, obj_enunit);
		u.dudes[1] = "Carnifex";
		u.dudes_num[1] = 40;
		u.dudes[2] = "Zoanthrope";
		u.dudes_num[2] = 20;

		u = instance_create(0, 240, obj_enunit);
		u.dudes[1] = "Lictor";
		u.dudes_num[1] = 40;
		u.flank = 1;
	}
}

// ** Chaos Forces **
if (enemy = 10) and(battle_special != "ship_demon") and(battle_special != "fallen1") and(battle_special != "fallen2") and(battle_special != "WL10_reveal") and(battle_special != "WL10_later") and(string_count("cs_meeting_battle", battle_special) = 0) {
	// u=instance_create(-10,240,obj_enunit);
	// u.dudes[1]="Stormboy";u.dudes_num[1]=2500;u.flank=1;// enemies[1]=u.dudes[1];
	// Small Chaos Cult Group
	if (threat = 1) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "150";

		u.dudes[1] = "Arch Heretic";
		u.dudes_num[1] = 1;
		enemies[1] = u.dudes[1];
		u.dudes[2] = "Cultist Elite";
		u.dudes_num[2] = 30;
		enemies[2] = u.dudes[2];
		u.dudes[3] = "Cultist";
		u.dudes_num[3] = 120;
		enemies[3] = u.dudes[3];
	}
	// Medium Chaos Cult Group
	if (threat = 2) {
		u = instance_nearest(xxx + 10, 240, obj_enunit);
		enemy_dudes = "nearly 400";

		u.dudes[1] = "Arch Heretic";
		u.dudes_num[1] = 1;
		u.dudes[2] = "Cultist Elite";
		u.dudes_num[2] = 50;
		u.dudes[3] = "Cultist";
		u.dudes_num[3] = 300;
		instance_deactivate_object(u);

		u = instance_nearest(xxx + 20, 240, obj_enunit);
		u.dudes[1] = "Cultist";
		u.dudes_num[1] = 50;
		u.dudes[2] = "Technical";
		u.dudes_num[2] = 6;
	}
	// Large Chaos Cult Group
	if (threat = 3) {
		u = instance_nearest(xxx + 20, 240, obj_enunit);
		enemy_dudes = "1000";

		u.dudes[1] = "Arch Heretic";
		u.dudes_num[1] = 1;
		u.dudes[2] = "Cultist Elite";
		u.dudes_num[2] = 100;
		u.dudes[3] = "Mutants";
		u.dudes_num[3] = 200;
		instance_deactivate_object(u);

		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Technical";
		u.dudes_num[1] = 9;
		u.dudes[2] = "Chaos Leman Russ";
		u.dudes_num[2] = 6;
		u.dudes[3] = "Cultist";
		u.dudes_num[3] = 200;
		instance_deactivate_object(u);

		u = instance_nearest(xxx, 240, obj_enunit);
		u.dudes[1] = "Cultist";
		u.dudes_num[1] = 200;
		u.dudes[2] = "Mutant";
		u.dudes_num[2] = 300;
	}
	// Small Chaos Cult Army
	if (threat = 4) {
		u = instance_nearest(xxx + 20, 240, obj_enunit);
		enemy_dudes = "4000";

		u.dudes[1] = "Arch Heretic";
		u.dudes_num[1] = 1;
		u.dudes[2] = "Cultist Elite";
		u.dudes_num[2] = 400;
		u.dudes[3] = "Chaos Basilisk";
		u.dudes_num[3] = 6;
		instance_deactivate_object(u);

		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Mutant";
		u.dudes_num[1] = 1500;
		u.dudes[2] = "Chaos Leman Russ";
		u.dudes_num[2] = 21;
		u.dudes[3] = "Defiler";
		u.dudes_num[3] = 5;
		instance_deactivate_object(u);

		u = instance_nearest(xxx, 240, obj_enunit);
		u.dudes[1] = "Cultist";
		u.dudes_num[1] = 600;
		u.dudes[2] = "Mutant";
		u.dudes_num[2] = 1500;
	}
	// Medium Chaos Cult Army
	if (threat = 5) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "8000";

		u.dudes[1] = "Daemonhost";
		u.dudes_num[1] = 1;
		u.dudes[2] = "Chaos Terminator";
		u.dudes_num[2] = 10;
		u.dudes[3] = "Cultist Elite";
		u.dudes_num[3] = 400;
		u.dudes[4] = "Chaos Basilisk";
		u.dudes_num[4] = 9;

		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Chaos Leman Russ";
		u.dudes_num[1] = 40;
		u.dudes[2] = "Defiler";
		u.dudes_num[2] = 12;
		instance_deactivate_object(u);

		u = instance_nearest(xxx + 20, 240, obj_enunit);
		u.dudes[1] = "Mutant";
		u.dudes_num[1] = 2000;
		instance_deactivate_object(u);

		u = instance_nearest(xxx + 30, 240, obj_enunit);
		u.dudes[1] = "Cultist";
		u.dudes_num[1] = 1000;
		u.dudes[2] = "Mutant";
		u.dudes_num[2] = 2000;
		instance_deactivate_object(u);

		u = instance_nearest(xxx, 40, obj_enunit);
		u.dudes[1] = "Cultist";
		u.dudes_num[1] = 1000;
		u.dudes[2] = "Mutant";
		u.dudes_num[2] = 2000;
		instance_deactivate_object(u);
	}
	// Large Chaos Cult Army
	if (threat = 6) {
		u = instance_nearest(xxx + 40, 240, obj_enunit);
		enemy_dudes = "12000";

		u.dudes[1] = "Greater Daemon of " + string(choose("Slaanesh", "Khorne", "Nurgle", "Tzeentch,", "Tzeentch"));
		u.dudes_num[1] = 2;
		u.dudes[2] = "Chaos Terminator";
		u.dudes_num[2] = 20;
		u.dudes[3] = "Chaos Basilisk";
		u.dudes_num[3] = 18;
		instance_deactivate_object(u);

		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Chaos Leman Russ";
		u.dudes_num[1] = 80;
		u.dudes[2] = "Defiler";
		u.dudes_num[2] = 20;
		u.dudes[3] = "Vindicator";
		u.dudes_num[3] = 10;
		instance_deactivate_object(u);

		u = instance_nearest(xxx, 240, obj_enunit);
		u.dudes[1] = "Mutant";
		u.dudes_num[1] = 8000;
		u.dudes[2] = "Cultist Elite";
		u.dudes_num[2] = 4000;
		u.dudes[3] = "Havoc";
		u.dudes_num[3] = 50;
		u.dudes[4] = "Chaos Space Marine";
		u.dudes_num[4] = 50;
		instance_deactivate_object(u);
	}
	// Chaos Daemons Army
	if (threat = 7) {
		u = instance_nearest(xxx + 40, 240, obj_enunit);
		u.neww = 1;
		enemy_dudes = "";

		u.dudes[1] = "Greater Daemon of Slaanesh";
		u.dudes_num[1] = 1;
		u.dudes[2] = "Greater Daemon of Slaanesh";
		u.dudes_num[2] = 1;
		// u.dudes[3]="Greater Daemon of Slaanesh";u.dudes_num[3]=1;
		u.dudes[4] = "Greater Daemon of Tzeentch";
		u.dudes_num[4] = 1;
		u.dudes[5] = "Greater Daemon of Tzeentch";
		u.dudes_num[5] = 1;
		// u.dudes[6]="Greater Daemon of Tzeentch";u.dudes_num[6]=1;
		u.dudes[7] = "Soul Grinder";
		u.dudes_num[7] = 3;
		instance_deactivate_object(u);

		u = instance_nearest(xxx + 30, 240, obj_enunit);
		u.neww = 1;
		u.dudes[1] = "Greater Daemon of Khorne";
		u.dudes_num[1] = 1;
		u.dudes[2] = "Greater Daemon of Khorne";
		u.dudes_num[2] = 1;
		// u.dudes[3]="Greater Daemon of Khorne";u.dudes_num[3]=1;
		u.dudes[4] = "Greater Daemon of Nurgle";
		u.dudes_num[4] = 1;
		u.dudes[5] = "Greater Daemon of Nurgle";
		u.dudes_num[5] = 1;
		// u.dudes[6]="Greater Daemon of Nurgle";u.dudes_num[6]=1;
		instance_deactivate_object(u);

		u = instance_nearest(xxx + 20, 240, obj_enunit);
		u.dudes[1] = "Bloodletter";
		u.dudes_num[1] = 800;
		u.dudes[2] = "Daemonette";
		u.dudes_num[2] = 800;
		u.dudes[3] = "Plaguebearer";
		u.dudes_num[3] = 800;
		u.dudes[4] = "Pink Horror";
		u.dudes_num[4] = 800;
		u.dudes[5] = "Maulerfiend";
		u.dudes_num[5] = 3;
		instance_deactivate_object(u);

		// u=instance_nearest(xxx+10,240,obj_enunit);
		// u.dudes[1]="Mutant";u.dudes_num[1]=6000;
		// instance_deactivate_object(u);
	}
}

// ** Chaos Space Marines Forces **
if (enemy = 11) and(battle_special != "world_eaters") and(string_count("cs_meeting_battle", battle_special) = 0) {
	// Small CSM Group
	if (threat = 1) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "5";

		u.dudes[1] = "Chaos Space Marine";
		u.dudes_num[1] = 5;
		enemies[1] = u.dudes[1];
		u.dudes[2] = "Cultist";
		u.dudes_num[2] = 30;
		enemies[2] = u.dudes[2];
	}
	// Medium CSM Group
	if (threat = 2) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "41";

		u.dudes[1] = "Chaos Chosen";
		u.dudes_num[1] = 1;
		u.dudes[2] = "Chaos Space Marine";
		u.dudes_num[2] = 35;
		u.dudes[3] = "Havoc";
		u.dudes_num[3] = 5;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Cultist";
		u.dudes_num[1] = 100;
		u.dudes[2] = "Rhino";
		u.dudes_num[2] = 2;
		u.dudes[3] = "Predator";
		u.dudes_num[3] = 4;
	}
	// Large CSM Group
	if (threat = 3) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "over 100";

		u.dudes[1] = "Chaos Lord";
		u.dudes_num[1] = 1;
		u.dudes[2] = "Chaos Sorcerer";
		u.dudes_num[2] = 1;
		u.dudes[3] = "Chaos Chosen";
		u.dudes_num[3] = 10;
		u.dudes[4] = "Chaos Space Marine";
		u.dudes_num[4] = 100;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Rhino";
		u.dudes_num[1] = 6;
		u.dudes[2] = "Defiler";
		u.dudes_num[2] = 2;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 20, 240, obj_enunit);
		u.dudes[1] = "Cultist";
		u.dudes_num[1] = 300;
		u.dudes[2] = "Helbrute";
		u.dudes_num[2] = 3;
		u.dudes[3] = "Predator";
		u.dudes_num[3] = 6;
		u.dudes[4] = "Land Raider";
		u.dudes_num[4] = 2;
	}
	// Small CSM Army
	if (threat = 4) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "over 700";

		u.dudes[1] = "Chaos Lord";
		u.dudes_num[1] = 1;
		u.dudes[2] = "Chaos Sorcerer";
		u.dudes_num[2] = 2;
		u.dudes[3] = "Chaos Chosen";
		u.dudes_num[3] = 10;
		// u.dudes[4]="Chaos Terminator";u.dudes_num[4]=5;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Chaos Space Marine";
		u.dudes_num[1] = 250;
		u.dudes[2] = "Havoc";
		u.dudes_num[2] = 20;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 20, 240, obj_enunit);
		u.dudes[1] = "Rhino";
		u.dudes_num[1] = 15;
		u.dudes[2] = "Defiler";
		u.dudes_num[2] = 4;
		u.dudes[3] = "Heldrake";
		u.dudes_num[3] = 1;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 30, 240, obj_enunit);
		u.dudes[1] = "Cultist";
		u.dudes_num[1] = 600;
		u.dudes[2] = "Helbrute";
		u.dudes_num[2] = 3;
		u.dudes[3] = "Predator";
		u.dudes_num[3] = 6;
		u.dudes[4] = "Vindicator";
		u.dudes_num[4] = 3;
		u.dudes[5] = "Land Raider";
		u.dudes_num[5] = 2;
	}
	// Medium CSM Army
	if (threat = 5) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "over 1200";

		u.dudes[1] = "Chaos Lord";
		u.dudes_num[1] = 1;
		u.dudes[2] = "Chaos Sorcerer";
		u.dudes_num[2] = 3;
		u.dudes[3] = "Chaos Chosen";
		u.dudes_num[3] = 20;
		u.dudes[4] = "Obliterator";
		u.dudes_num[4] = 6;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Chaos Space Marine";
		u.dudes_num[1] = 600;
		u.dudes[2] = "Havoc";
		u.dudes_num[2] = 40;
		u.dudes[3] = "Raptor";
		u.dudes_num[3] = 40;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 20, 240, obj_enunit);
		u.dudes[1] = "Rhino";
		u.dudes_num[1] = 25;
		u.dudes[2] = "Defiler";
		u.dudes_num[2] = 8;
		u.dudes[3] = "Heldrake";
		u.dudes_num[3] = 3;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 30, 240, obj_enunit);
		u.dudes[1] = "Cultist";
		u.dudes_num[1] = 600;
		u.dudes[2] = "Helbrute";
		u.dudes_num[2] = 5;
		u.dudes[3] = "Predator";
		u.dudes_num[3] = 10;
		u.dudes[4] = "Vindicator";
		u.dudes_num[4] = 6;
		u.dudes[5] = "Land Raider";
		u.dudes_num[5] = 3;
		u.dudes[6] = "Possessed";
		u.dudes_num[6] = 30;

		u = instance_create(0, 240, obj_enunit);
		u.dudes[1] = "Chaos Terminator";
		u.dudes_num[1] = 10;
		u.flank = 1;
	}
	// Large CSM Army
	if (threat = 6) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "2000";

		u.dudes[1] = "Chaos Lord";
		u.dudes_num[1] = 2;
		u.dudes[2] = "Chaos Sorcerer";
		u.dudes_num[2] = 10;
		u.dudes[3] = "Chaos Chosen";
		u.dudes_num[3] = 40;
		u.dudes[4] = "Obliterator";
		u.dudes_num[4] = 12;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Chaos Space Marine";
		u.dudes_num[1] = 800;
		u.dudes[2] = "Havoc";
		u.dudes_num[2] = 50;
		u.dudes[3] = "Raptor";
		u.dudes_num[3] = 50;
		u.dudes[4] = choose("Noise Marine", "Plague Marine", "Khorne Berzerker", "Rubric Marine");
		u.dudes_num[3] = 50;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 20, 240, obj_enunit);
		u.dudes[1] = "Rhino";
		u.dudes_num[1] = 30;
		u.dudes[2] = "Defiler";
		u.dudes_num[2] = 10;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 30, 240, obj_enunit);
		u.dudes[1] = "Cultist";
		u.dudes_num[1] = 1200;
		u.dudes[2] = "Helbrute";
		u.dudes_num[2] = 10;
		u.dudes[3] = "Predator";
		u.dudes_num[3] = 20;
		u.dudes[4] = "Vindicator";
		u.dudes_num[4] = 15;
		u.dudes[5] = "Land Raider";
		u.dudes_num[5] = 6;
		u.dudes[6] = "Possessed";
		u.dudes_num[6] = 60;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 40, 240, obj_enunit);
		u.dudes[1] = "Heldrake";
		u.dudes_num[1] = 6;
		u.flank = 1;
		u.flyer = 1;

		u = instance_create(0, 240, obj_enunit);
		u.dudes[1] = "Chaos Terminator";
		u.dudes_num[1] = 20;
		u.flank = 1;
	}
}

// ** World Eaters Forces **
if (enemy = 11) and(battle_special = "world_eaters") {
	// Small WE Group
	if (threat = 1) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "20";

		u.dudes[1] = "Khorne Berzerker";
		u.dudes_num[1] = 15;
		enemies[1] = u.dudes[1];
		// Spawn Leader
		if (obj_controller.faction_defeated[10] = 0) {
			u.dudes[2] = "Leader";
			u.dudes_num[2] = 1;
		}
		u.dudes[3] = "World Eaters Veteran";
		u.dudes_num[3] = 5;
	}
	// Medium WE Group
	if (threat = 2) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "135";

		u.dudes[1] = "Chaos Chosen";
		u.dudes_num[1] = 1;
		// Spawn Leader
		if (obj_controller.faction_defeated[10] = 0) then u.dudes[1] = "Leader";
		u.dudes[2] = "Khorne Berzerker";
		u.dudes_num[2] = 35;
		u.dudes[3] = "World Eaters Veteran";
		u.dudes_num[3] = 5;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "World Eater";
		u.dudes_num[1] = 100;
		u.dudes[2] = "Rhino";
		u.dudes_num[2] = 2;
		u.dudes[3] = "Vindicator";
		u.dudes_num[3] = 4;
	}
	// Large WE Group
	if (threat = 3) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "over 200";

		u.dudes[1] = "Chaos Chosen";
		u.dudes_num[1] = 1;
		// Spawn Leader
		if (obj_controller.faction_defeated[10] = 0) then u.dudes[1] = "Leader";
		u.dudes[2] = "Greater Daemon of Khorne";
		u.dudes_num[2] = 1;
		u.dudes[3] = "World Eater Terminator";
		u.dudes_num[3] = 10;
		u.dudes[4] = "World Eater";
		u.dudes_num[4] = 100;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Rhino";
		u.dudes_num[1] = 6;
		u.dudes[2] = "Defiler";
		u.dudes_num[2] = 2;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 20, 240, obj_enunit);
		u.dudes[1] = "Khorne Berzerker";
		u.dudes_num[1] = 100;
		u.dudes[2] = "Helbrute";
		u.dudes_num[2] = 5;
		u.dudes[3] = "Vindicator";
		u.dudes_num[3] = 6;
		u.dudes[4] = "Land Raider";
		u.dudes_num[4] = 4;
	}
	// Small WE Army
	if (threat = 4) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "over 300";

		u.dudes[1] = "Chaos Chosen";
		u.dudes_num[1] = 1;
		// Spawn Leader
		if (obj_controller.faction_defeated[10] = 0) then u.dudes[1] = "Leader";
		u.dudes[2] = "Greater Daemon of Khorne";
		u.dudes_num[2] = 2;
		u.dudes[3] = "World Eater Terminator";
		u.dudes_num[3] = 10;
		// u.dudes[4]="Chaos Terminator";u.dudes_num[4]=5;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "World Eaters Veteran";
		u.dudes_num[1] = 250;
		u.dudes[2] = "Possessed";
		u.dudes_num[2] = 20;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 20, 240, obj_enunit);
		u.dudes[1] = "Vindicator";
		u.dudes_num[1] = 15;
		u.dudes[2] = "Defiler";
		u.dudes_num[2] = 4;
		u.dudes[3] = "Heldrake";
		u.dudes_num[3] = 1;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 30, 240, obj_enunit);
		u.dudes[1] = "Khorne Berzerker";
		u.dudes_num[1] = 300;
		u.dudes[2] = "Helbrute";
		u.dudes_num[2] = 3;
		u.dudes[3] = "Predator";
		u.dudes_num[3] = 6;
		u.dudes[4] = "Vindicator";
		u.dudes_num[4] = 3;
		u.dudes[5] = "Land Raider";
		u.dudes_num[5] = 2;
	}
	// Medium WE Army
	if (threat = 5) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "over 900";

		u.dudes[1] = "Chaos Chosen";
		u.dudes_num[1] = 1;
		// Spawn Leader
		if (obj_controller.faction_defeated[10] = 0) then u.dudes[1] = "Leader";
		u.dudes[2] = "Greater Daemon of Khorne";
		u.dudes_num[2] = 3;
		u.dudes[3] = "World Eater Terminator";
		u.dudes_num[3] = 20;
		u.dudes[4] = "Helbrute";
		u.dudes_num[4] = 6;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "World Eaters Veteran";
		u.dudes_num[1] = 600;
		u.dudes[2] = "Possessed";
		u.dudes_num[2] = 40;
		u.dudes[3] = "Possessed";
		u.dudes_num[3] = 40;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 20, 240, obj_enunit);
		u.dudes[1] = "Vindicator";
		u.dudes_num[1] = 15;
		u.dudes[2] = "Defiler";
		u.dudes_num[2] = 8;
		u.dudes[3] = "Heldrake";
		u.dudes_num[3] = 3;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 30, 240, obj_enunit);
		u.dudes[1] = "Khorne Berzerker";
		u.dudes_num[1] = 300;
		u.dudes[2] = "Helbrute";
		u.dudes_num[2] = 5;
		u.dudes[3] = "Predator";
		u.dudes_num[3] = 10;
		u.dudes[4] = "Vindicator";
		u.dudes_num[4] = 6;
		u.dudes[5] = "Land Raider";
		u.dudes_num[5] = 3;
		u.dudes[6] = "Possessed";
		u.dudes_num[6] = 30;

		u = instance_create(0, 240, obj_enunit);
		u.dudes[1] = "Chaos Terminator";
		u.dudes_num[1] = 10;
		u.flank = 1;
	}
	// Large WE Army
	if (threat >= 6) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "1300";

		u.dudes[1] = "Chaos Lord";
		u.dudes_num[1] = 2;
		// Spawn Leader
		if (obj_controller.faction_defeated[10] = 0) {
			u.dudes[1] = "Leader";
			u.dudes_num[1] = 1;
		}
		u.dudes[2] = "Greater Daemon of Khorne";
		u.dudes_num[2] = 5;
		u.dudes[3] = "World Eaters Terminator";
		u.dudes_num[3] = 40;
		u.dudes[4] = "Helbrute";
		u.dudes_num[4] = 10;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "World Eaters Veteran";
		u.dudes_num[1] = 800;
		u.dudes[2] = "Possessed";
		u.dudes_num[2] = 50;
		u.dudes[3] = "Possessed";
		u.dudes_num[3] = 50;
		u.dudes[4] = "Khorne Berzerker";
		u.dudes_num[3] = 50;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 20, 240, obj_enunit);
		u.dudes[1] = "Vindicator";
		u.dudes_num[1] = 20;
		u.dudes[2] = "Defiler";
		u.dudes_num[2] = 10;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 30, 240, obj_enunit);
		u.dudes[1] = "Khorne Berzerker";
		u.dudes_num[1] = 500;
		u.dudes[2] = "Helbrute";
		u.dudes_num[2] = 10;
		u.dudes[3] = "Predator";
		u.dudes_num[3] = 15;
		u.dudes[4] = "Vindicator";
		u.dudes_num[4] = 20;
		u.dudes[5] = "Land Raider";
		u.dudes_num[5] = 6;
		u.dudes[6] = "Possessed";
		u.dudes_num[6] = 60;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 40, 240, obj_enunit);
		u.dudes[1] = "Heldrake";
		u.dudes_num[1] = 6;
		u.flank = 1;
		u.flyer = 1;

		u = instance_create(0, 240, obj_enunit);
		u.dudes[1] = "World Eaters Terminator";
		u.dudes_num[1] = 20;
		u.flank = 1;
	}
}

// ** Daemon Forces **
if (enemy = 12) {
	// If we want to have multiple story events regarding specific Chaos Gods, we could name slaa into gods and just check the value? TBD
	var slaa = false;
	if (battle_special = "ruins_eldar") then slaa = true;
	// Small Daemon Group
	if (threat = 1) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "5";

		u.dudes[1] = choose("Bloodletter", "Daemonette", "Plaguebearer", "Pink Horror");
		if (slaa) then u.dudes[1] = "Daemonette";
		u.dudes_num[1] = 5;
		enemies[1] = u.dudes[1];
		u.dudes[2] = "Cultist Elite";
		u.dudes_num[2] = 30;
		enemies[2] = u.dudes[2];
	}
	// Medium Daemon Group
	if (threat = 2) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "90";

		u.dudes[1] = choose("Bloodletter", "Daemonette", "Plaguebearer", "Pink Horror");
		if (slaa) then u.dudes[1] = "Daemonette";
		u.dudes_num[1] = 30;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = choose("Bloodletter", "Daemonette", "Plaguebearer", "Pink Horror");
		if (slaa) then u.dudes[1] = "Daemonette";
		u.dudes_num[1] = 30;
		u.dudes[2] = "Defiler";
		u.dudes_num[2] = 1;
	}
	// Large Daemon Group
	if (threat = 3) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "240";

		u.dudes[1] = "Greater Daemon of " + choose("Tzeentch", "Slaanesh", "Nurgle", "Khorne");
		if (slaa) then u.dudes[1] = "Greater Daemon of Slaanesh";
		u.dudes_num[1] = 1;
		u.dudes[2] = "Chaos Sorcerer";
		u.dudes_num[2] = 1;
		u.dudes[3] = "Pink Horror";
		if (slaa) then u.dudes[3] = "Daemonette";
		u.dudes_num[3] = 60;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Defiler";
		u.dudes_num[1] = 2;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 20, 240, obj_enunit);
		if (slaa) {
			u.dudes[1] = "Daemonette";
			u.dudes_num[1] = 240;
		} else {
			u.dudes[1] = "Bloodletter";
			u.dudes_num[1] = 60;
			u.dudes[2] = "Plaguebearer";
			u.dudes_num[2] = 60;
			u.dudes[3] = "Daemonette";
			u.dudes_num[3] = 60;
			u.dudes[4] = "Maulerfiend";
			u.dudes_num[4] = 2;
		}
	}
	// Small Daemon Army
	if (threat = 4) {
		u = instance_nearest(xxx + 40, 240, obj_enunit);
		enemy_dudes = "400";
		u.neww = 1;

		u.dudes[1] = "Greater Daemon of " + string(choose("Slaanesh", "Tzeentch"));
		if (slaa) then u.dudes[1] = "Greater Daemon of Slaanesh";
		u.dudes_num[1] = 1;
		u.dudes[2] = "Greater Daemon of " + string(choose("Nurgle", "Khorne"));
		if (slaa) then u.dudes[2] = "Greater Daemon of Slaanesh";
		u.dudes_num[2] = 1;
		// u.dudes[6]="Greater Daemon of Tzeentch";u.dudes_num[6]=1;
		u.dudes[3] = "Soul Grinder";
		u.dudes_num[3] = 1;
		instance_deactivate_object(u);

		u = instance_nearest(xxx + 20, 240, obj_enunit);
		if (slaa) {
			u.dudes[1] = "Daemonette";
			u.dudes_num[1] = 400;
			u.dudes[2] = "Maulerfiend";
			u.dudes_num[2] = 2;
		} else {
			u.dudes[1] = "Bloodletter";
			u.dudes_num[1] = 100;
			u.dudes[2] = "Daemonette";
			u.dudes_num[2] = 100;
			u.dudes[3] = "Plaguebearer";
			u.dudes_num[3] = 100;
			u.dudes[4] = "Pink Horror";
			u.dudes_num[4] = 100;
			u.dudes[5] = "Maulerfiend";
			u.dudes_num[5] = 2;
		}
		instance_deactivate_object(u);
	}
	// Medium Daemon Army
	if (threat = 5) {
		u = instance_nearest(xxx + 40, 240, obj_enunit);
		enemy_dudes = "1000";
		u.neww = 1;

		u.dudes[1] = "Greater Daemon of " + string(choose("Slaanesh", "Tzeentch", "Khorne", "Nurgle"));
		if (slaa) then u.dudes[1] = "Greater Daemon of Slaanesh";
		u.dudes_num[1] = 1;
		u.dudes[2] = "Greater Daemon of " + string(choose("Slaanesh", "Tzeentch", "Khorne", "Nurgle"));
		if (slaa) then u.dudes[2] = "Greater Daemon of Slaanesh";
		u.dudes_num[2] = 1;
		u.dudes[3] = "Greater Daemon of " + string(choose("Slaanesh", "Tzeentch", "Khorne", "Nurgle"));
		if (slaa) then u.dudes[3] = "Greater Daemon of Slaanesh";
		u.dudes_num[3] = 1;
		u.dudes[4] = "Soul Grinder";
		u.dudes_num[4] = 2;
		instance_deactivate_object(u);

		u = instance_nearest(xxx + 20, 240, obj_enunit);
		if (slaa) {
			u.dudes[1] = "Daemonette";
			u.dudes_num[1] = 1000;
			u.dudes[2] = "Maulerfiend";
			u.dudes_num[2] = 2;
		} else {
			u.dudes[1] = "Bloodletter";
			u.dudes_num[1] = 250;
			u.dudes[2] = "Daemonette";
			u.dudes_num[2] = 250;
			u.dudes[3] = "Plaguebearer";
			u.dudes_num[3] = 250;
			u.dudes[4] = "Pink Horror";
			u.dudes_num[4] = 250;
			u.dudes[5] = "Maulerfiend";
			u.dudes_num[5] = 2;
		}
		instance_deactivate_object(u);
	}
	// Large Daemon Army
	if (threat = 6) {
		u = instance_nearest(xxx + 40, 240, obj_enunit);
		enemy_dudes = "2000";
		u.neww = 1;

		u.dudes[1] = "Greater Daemon of " + string(choose("Slaanesh", "Tzeentch", "Khorne", "Nurgle"));
		if (slaa) then u.dudes[1] = "Greater Daemon of Slaanesh";
		u.dudes_num[1] = 1;
		u.dudes[2] = "Greater Daemon of " + string(choose("Slaanesh", "Tzeentch", "Khorne", "Nurgle"));
		if (slaa) then u.dudes[2] = "Greater Daemon of Slaanesh";
		u.dudes_num[2] = 1;
		u.dudes[3] = "Greater Daemon of " + string(choose("Slaanesh", "Tzeentch", "Khorne", "Nurgle"));
		if (slaa) then u.dudes[3] = "Greater Daemon of Slaanesh";
		u.dudes_num[3] = 1;
		u.dudes[4] = "Soul Grinder";
		u.dudes_num[4] = 1;
		instance_deactivate_object(u);

		u = instance_nearest(xxx + 30, 240, obj_enunit);
		u.neww = 1;
		u.dudes[1] = "Greater Daemon of " + string(choose("Slaanesh", "Tzeentch", "Khorne", "Nurgle"));
		if (slaa) then u.dudes[1] = "Greater Daemon of Slaanesh";
		u.dudes_num[1] = 1;
		u.dudes[2] = "Greater Daemon of " + string(choose("Slaanesh", "Tzeentch", "Khorne", "Nurgle"));
		if (slaa) then u.dudes[2] = "Greater Daemon of Slaanesh";
		u.dudes_num[2] = 1;
		u.dudes[3] = "Soul Grinder";
		u.dudes_num[3] = 1;
		instance_deactivate_object(u);

		u = instance_nearest(xxx + 20, 240, obj_enunit);
		if (slaa) {
			u.dudes[1] = "Daemonette";
			u.dudes_num[1] = 2000;
			u.dudes[2] = "Maulerfiend";
			u.dudes_num[2] = 3;
		} else {
			u.dudes[1] = "Bloodletter";
			u.dudes_num[1] = 500;
			u.dudes[2] = "Daemonette";
			u.dudes_num[2] = 500;
			u.dudes[3] = "Plaguebearer";
			u.dudes_num[3] = 500;
			u.dudes[4] = "Pink Horror";
			u.dudes_num[4] = 500;
			u.dudes[5] = "Maulerfiend";
			u.dudes_num[5] = 3;
		}
		instance_deactivate_object(u);
	}
}

// ** Necron Forces **
if (enemy = 13) and((string_count("_attack", battle_special) = 0) or(string_count("wake", battle_special) > 0)) {
	// Small Necron Group
	if (threat = 1) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "11";

		u.dudes[1] = "Necron Destroyer";
		u.dudes_num[1] = 1;
		enemies[1] = u.dudes[1];
		u.dudes[2] = "Necron Warrior";
		u.dudes_num[2] = 10;
		enemies[2] = u.dudes[2];
	}
	// Medium Necron Group
	if (threat = 2) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "54";

		u.dudes[1] = "Necron Destroyer";
		u.dudes_num[1] = 1;
		u.dudes[2] = "Necron Warrior";
		u.dudes_num[2] = 20;
		u.dudes[3] = "Necron Immortal";
		u.dudes_num[3] = 10;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Necron Warrior";
		u.dudes_num[1] = 20;
		u.dudes[2] = "Canoptek Spyder";
		u.dudes_num[2] = 3;
	}
	// Large Necron Group
	if (threat = 3) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "110";

		u.dudes[1] = "Necron Overlord";
		u.dudes_num[1] = 1;
		u.dudes[2] = "Necron Destroyer";
		u.dudes_num[2] = 3;
		u.dudes[3] = "Lychguard";
		u.dudes_num[3] = 5;
		u.dudes[4] = "Necron Warrior";
		u.dudes_num[4] = 100;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Canoptek Spyder";
		u.dudes_num[1] = 6;
		u.dudes[2] = "Canoptek Scarab";
		u.dudes_num[2] = 120;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 20, 240, obj_enunit);
		u.dudes[1] = "Doomsday Arc";
		u.dudes_num[1] = 2;
		u.dudes[2] = "Monolith";
		u.dudes_num[2] = 1;
	}
	// Small Necron Army
	if (threat = 4) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "290";

		u.dudes[1] = "Necron Overlord";
		u.dudes_num[1] = 1;
		u.dudes[2] = "Necron Destroyer";
		u.dudes_num[2] = 6;
		u.dudes[3] = "Lychguard";
		u.dudes_num[3] = 10;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Necron Warrior";
		u.dudes_num[1] = 250;
		u.dudes[2] = "Necron Immortal";
		u.dudes_num[2] = 20;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 20, 240, obj_enunit);
		u.dudes[1] = "Canoptek Spyder";
		u.dudes_num[1] = 6;
		u.dudes[2] = "Canoptek Scarab";
		u.dudes_num[2] = 120;
		u.dudes[3] = "Tomb Stalker";
		u.dudes_num[3] = 1;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 30, 240, obj_enunit);
		u.dudes[1] = "Doomsday Arc";
		u.dudes_num[1] = 2;
		u.dudes[2] = "Monolith";
		u.dudes_num[2] = 1;

		u = instance_create(0, 240, obj_enunit);
		u.dudes[1] = "Necron Wraith";
		u.dudes_num[1] = 6;
		u.flank = 1;
	}
	// Medium Necron Army
	if (threat = 5) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "700";

		u.dudes[1] = "Necron Overlord";
		u.dudes_num[1] = 1;
		u.dudes[2] = "Necron Destroyer";
		u.dudes_num[2] = 12;
		u.dudes[3] = "Lychguard";
		u.dudes_num[3] = 20;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Necron Warrior";
		u.dudes_num[1] = 600;
		u.dudes[2] = "Necron Immortal";
		u.dudes_num[2] = 40;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 20, 240, obj_enunit);
		u.dudes[1] = "Canoptek Spyder";
		u.dudes_num[1] = 12;
		u.dudes[2] = "Canoptek Scarab";
		u.dudes_num[2] = 240;
		u.dudes[3] = "Tomb Stalker";
		u.dudes_num[3] = 2;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 30, 240, obj_enunit);
		u.dudes[1] = "Doomsday Arc";
		u.dudes_num[1] = 4;
		u.dudes[2] = "Monolith";
		u.dudes_num[2] = 2;
		u.dudes[3] = "Necron Destroyer";
		u.dudes_num[3] = 12;

		u = instance_create(0, 240, obj_enunit);
		u.dudes[1] = "Necron Wraith";
		u.dudes_num[1] = 12;
		u.flank = 1;
	}
	// Large Necron Army
	if (threat = 6) {
		u = instance_nearest(xxx, 240, obj_enunit);
		enemy_dudes = "1000";

		u.dudes[1] = "Necron Overlord";
		u.dudes_num[1] = 2;
		u.dudes[2] = "Necron Destroyer";
		u.dudes_num[2] = 20;
		u.dudes[3] = "Lychguard";
		u.dudes_num[3] = 40;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 10, 240, obj_enunit);
		u.dudes[1] = "Necron Warrior";
		u.dudes_num[1] = 800;
		u.dudes[2] = "Necron Immortal";
		u.dudes_num[2] = 50;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 20, 240, obj_enunit);
		u.dudes[1] = "Canoptek Spyder";
		u.dudes_num[1] = 16;
		u.dudes[2] = "Canoptek Scarab";
		u.dudes_num[2] = 320;
		u.dudes[3] = "Tomb Stalker";
		u.dudes_num[3] = 3;

		instance_deactivate_object(u);
		u = instance_nearest(xxx + 30, 240, obj_enunit);
		u.dudes[1] = "Doomsday Arc";
		u.dudes_num[1] = 6;
		u.dudes[2] = "Monolith";
		u.dudes_num[2] = 2;
		u.dudes[3] = "Necron Destroyer";
		u.dudes_num[3] = 20;

		u = instance_create(0, 240, obj_enunit);
		u.dudes[1] = "Necron Wraith";
		u.dudes_num[1] = 24;
		u.flank = 1;
	}
}

// ** Set up player defenses **
if (player_defenses + player_silos > 0) {
	u = instance_create(-50, 240, obj_pnunit);
	u.defenses = 1;

	for (var i = 1; i <= 3; i++) {
		u.veh_co[i] = 0;
		u.veh_id[i] = 0;
		u.veh_type[i] = "Defenses";
		u.veh_hp[i] = 1000;
		u.veh_ac[i] = 1000;
		u.veh_dead[i] = 0;
		u.veh_hp_multiplier[i] = 1;
	}

	u.veh_wep1[1] = "Heavy Bolter Emplacement";
	u.veh_wep1[2] = "Missile Launcher Emplacement";
	u.veh_wep1[3] = "Missile Silo";
	u.veh = 3;
	u.sprite_index = spr_weapon_blank;
}

instance_activate_object(obj_enunit);

}catch (_exception) {
	handle_exception(_exception);
	instance_destroy(obj_enunit);
	instance_destroy(obj_pnunit);
	instance_destroy(obj_ncombat);
}