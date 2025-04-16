enum eBATTLE_TURN {
    PlayerStart,
    PlayerEnd,
    EnemyStart,
    EnemyEnd,
}

enum eBATTLE_STAGE {
    Creation,
    Main,
    PlayerWinStart,
    PlayerWinEnd,
    EnemyWinStart,
    EnemyWinEnd
}

// alarm_0
/// @mixin
function ncombat_enemy_stacks_init() {
    // Sets up the number of enemies based on the threath level, enemy type and specific story events

    try {
        if (battle_special == "cs_meeting_battle5") {
            alpha_strike = 1;
        }

        instance_activate_object(obj_enunit);

        // show_message("Leader?: "+string(leader));

        // if (enemy=1) then show_message("exiting obj_ncombat_Alarm 0_2 due to enemy=1");
        if (enemy == 1) {
            instance_activate_object(obj_enunit);
            exit;
        }

        if ((battle_special == "study2a") || (battle_special == "study2b")) {
            ally = 3;
            ally_forces = 1;
        }
        instance_activate_object(obj_pnunit);
        if (!instance_exists(obj_pnunit)) {
            exit;
        }
        xxx = instance_nearest(1000, 240, obj_pnunit);
        xxx = xxx.x + 80;

        if ((string_count("spyrer", battle_special) > 0) || (string_count("fallen", battle_special) > 0) || (string_count("mech", battle_special) > 0) || (battle_special == "space_hulk") || (battle_special == "study2a") || (battle_special == "study2b")) {
            fortified = 0;
        }

        var i = 0, u;
        i = xxx / 10;

        if ((fortified > 1) && (enemy + threat != 17)) {
            u = instance_create(0, 0, obj_nfort);
            u.image_speed = 0;
            u.image_alpha = 0.5;

            if (fortified == 2) {
                u.ac[1] = 30;
                u.hp[1] = 400;
            }
            if (fortified == 3) {
                u.ac[1] = 40;
                u.hp[1] = 800;
            }
            if (fortified == 4) {
                u.ac[1] = 40;
                u.hp[1] = 1250;
            }
            if (fortified == 5) {
                u.ac[1] = 40;
                u.hp[1] = 1500;
            }

            if ((siege == 1) && (fortified > 0) && (defending == true)) {
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
            with (obj_enunit) {
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
        if (battle_special == "fallen1") {
            fortified = 0;
            with (obj_enunit) {
                instance_destroy();
            }
            u = instance_create(80, 240, obj_enunit);
            enemy_dudes = "1";
            u.dudes[1] = "Fallen";
            u.dudes_num[1] = 1;
            enemies[1] = 1;
        }
        // * Large Fallen Group *
        if (battle_special == "fallen2") {
            fortified = 0;
            with (obj_enunit) {
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
            with (obj_enunit) {
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
        if (battle_special == "ship_demon") {
            fortified = 0;
            with (obj_enunit) {
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
            with (instance_nearest(x + 1000, 240, obj_pnunit)) {
                engaged = 1;
            }
        }
        // * Necron Wraith Group *
        if (battle_special == "wraith_attack") {
            fortified = 0;
            with (obj_enunit) {
                instance_destroy();
            }
            u = instance_create(instance_nearest(x + 1000, 240, obj_pnunit).x + 10, 240, obj_enunit);
            enemy_dudes = "2";
            u.dudes[1] = "Necron Wraith";
            u.dudes_num[1] = 1;
            enemies[1] = 1;
            u.dudes[2] = "Necron Wraith";
            u.dudes_num[2] = 1;
            enemies[2] = 1;
            u.engaged = 1; // u.flank=1;
            with (instance_nearest(x + 1000, 240, obj_pnunit)) {
                engaged = 1;
            }
        }
        // * Canoptek Spyder Group *
        if (battle_special == "spyder_attack") {
            fortified = 0;
            with (obj_enunit) {
                instance_destroy();
            }
            u = instance_create(instance_nearest(x + 1000, 240, obj_pnunit).x + 10, 240, obj_enunit);
            enemy_dudes = "21";
            u.dudes[1] = "Canoptek Spyder";
            u.dudes_num[1] = 1;
            enemies[1] = u.dudes[1];
            u.dudes[2] = "Canoptek Scarab";
            u.dudes_num[2] = 20;
            enemies[2] = u.dudes[2];
            u.engaged = 1; // u.flank=1;
            with (instance_nearest(x + 1000, 240, obj_pnunit)) {
                engaged = 1;
            }
        }
        // * Tomb Stalker Group *
        if (battle_special == "stalker_attack") {
            fortified = 0;
            with (obj_enunit) {
                instance_destroy();
            }
            u = instance_create(instance_nearest(x + 1000, 240, obj_pnunit).x + 10, 240, obj_enunit);
            enemy_dudes = "1";
            u.dudes[1] = "Tomb Stalker";
            u.dudes_num[1] = 1;
            enemies[1] = 1;
            u.engaged = 1; // u.flank=1;
            with (instance_nearest(x + 1000, 240, obj_pnunit)) {
                engaged = 1;
            }
        }
        // * Chaos Space Marine Elite Group *
        if ((battle_special == "cs_meeting_battle5") || (battle_special == "cs_meeting_battle6")) {
            fortified = 0;
            with (obj_enunit) {
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
        if (battle_special == "cs_meeting_battle10") {
            fortified = 0;
            with (obj_enunit) {
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
        if (battle_special == "wake1_attack") {
            enemy = 13;
            threat = 2;
        }
        if (battle_special == "wake2_attack") {
            enemy = 13;
            threat = 3;
        }
        if (battle_special == "wake3_attack") {
            enemy = 13;
            threat = 5;
        }
        // * Tomb world study attack enemy setup *
        if (battle_special == "study2a") {
            enemy = 13;
            threat = 2;
        }
        if (battle_special == "study2b") {
            enemy = 13;
            threat = 3;
        }
        // ** Space Hulk Forces **
        if (battle_special == "space_hulk") {
            var make, modi;
            // show_message("space hulk battle, player forces: "+string(player_forces));
            with (obj_enunit) {
                instance_destroy();
            }
            // * Ork Space Hulk *
            if (enemy == 7) {
                modi = random_range(0.80, 1.20) + 1;
                make = round(max(3, player_starting_dudes * modi));

                u = instance_create(instance_nearest(x - 1000, 240, obj_pnunit).x - 10, 240, obj_enunit);
                u.dudes[1] = "Meganob";
                u.dudes_num[1] = make;
                enemies[1] = u.dudes[1];
                u.engaged = 1;
                u.flank = 1;
                with (instance_nearest(x - 1000, 240, obj_pnunit)) {
                    engaged = 1;
                }

                u = instance_create(instance_nearest(x + 1000, 240, obj_pnunit).x + 20, 240, obj_enunit);
                u.dudes[1] = "Slugga Boy";
                u.dudes_num[1] = make;
                enemies[1] = u.dudes[1];

                u.dudes[2] = "Shoota Boy";
                u.dudes_num[2] = make;
                enemies[2] = u.dudes[2];

                hulk_forces = make * 3;
            }
            // * Genestealer Space Hulk *
            if (enemy == 9) {
                modi = random_range(0.80, 1.20) + 1;
                make = round(max(3, player_starting_dudes * modi)) * 2;

                u = instance_create(instance_nearest(x - 1000, 240, obj_pnunit).x - 10, 240, obj_enunit);
                u.dudes[1] = "Genestealer";
                u.dudes_num[1] = round(make / 3);
                enemies[1] = u.dudes[1];
                u.engaged = 1;
                u.flank = 1;
                with (instance_nearest(x - 1000, 240, obj_pnunit)) {
                    engaged = 1;
                }

                u = instance_create(instance_nearest(x + 1000, 240, obj_pnunit).x + 10, 240, obj_enunit);
                u.dudes[1] = "Genestealer";
                u.dudes_num[1] = round(make / 3);
                enemies[1] = u.dudes[1];

                u = instance_create(instance_nearest(x + 1000, 240, obj_pnunit).x + 50, 240, obj_enunit);
                u.dudes[1] = "Genestealer";
                u.dudes_num[1] = make - (round(make / 3) * 2);
                enemies[1] = u.dudes[1];

                hulk_forces = make;
            }
            // * CSM Space Hulk *
            if (enemy == 10) {
                var make, modi;
                modi = random_range(0.80, 1.20) + 1;
                make = round(max(3, player_starting_dudes * modi));

                u = instance_create(instance_nearest(x - 1000, 240, obj_pnunit).x - 10, 240, obj_enunit);
                u.dudes[1] = "Chaos Terminator";
                u.dudes_num[1] = round(make * 0.25);
                enemies[1] = u.dudes[1];
                u.engaged = 1;
                u.flank = 1;
                with (instance_nearest(x - 1000, 240, obj_pnunit)) {
                    engaged = 1;
                }

                u = instance_create(instance_nearest(x + 1000, 240, obj_pnunit).x + 10, 240, obj_enunit);
                u.dudes[1] = "Chaos Space Marine";
                u.dudes_num[1] = round(make * 0.25);
                enemies[1] = u.dudes[1];

                u = instance_create(instance_nearest(x + 1000, 240, obj_pnunit).x + 50, 240, obj_enunit);
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
        if (battle_special == "WL10_reveal") {
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
        if (battle_special == "WL10_later") {
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
        if (enemy == 2) {
            guard_total = threat;
            guard_score = 6;

            /*if (guard_total>=15000000) then guard_score=6;
        if (guard_total<15000000) and (guard_total>=6000000) then guard_score=5;
        if (guard_total<6000000) and (guard_total>=1000000) then guard_score=4;
        if (guard_total<1000000) and (guard_total>=50000) then guard_score=3;
        if (guard_total<50000) and (guard_total>=500) then guard_score=2;
        if (guard_total<500) then guard_score=1;*/

            // guard_effective=floor(guard_total)/8;

            var f = 0, guar = threat / 10;

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
            } else {
                // Heavy Weapons
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
        if (enemy == 6) {
            // Ranger Group
            if (threat == 1) {
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
            if (threat == 1) {
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
            if (threat == 1) {
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
                if (leader == 1) {
                    u.dudes[4] = "Leader";
                    u.dudes_num[4] = 1;
                    enemies[4] = 1;
                    enemies_num[4] = 1;
                    if (obj_controller.faction_gender[6] == 2) {
                        u.dudes[2] = "Howling Banshee";
                    }
                    if (obj_controller.faction_gender[6] == 2) {
                        u.dudes[2] = "Dark Reapers";
                    }
                }
            }
            // Craftworld Medium Group
            if (threat == 2) {
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
                if (leader == 1) {
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
            if (threat == 3) {
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
                if (leader == 1) {
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
            if (threat == 4) {
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
                if (leader == 1) {
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
            if (threat == 5) {
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
                if (leader == 1) {
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
            if (threat == 6) {
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
                if (leader == 1) {
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
        if (enemy == 5) {
            // Small Sister Group
            if (threat == 1) {
                u = instance_nearest(xxx, 240, obj_enunit);
                enemy_dudes = "110";

                u.dudes[1] = "Celestian";
                u.dudes_num[1] = 1;
                enemies[1] = u.dudes[1];
                // Spawn Leader
                if (leader == 1) {
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
            if (threat == 2) {
                u = instance_nearest(xxx + 10, 240, obj_enunit);
                enemy_dudes = "nearly 400";

                u.dudes[1] = "Celestian";
                u.dudes_num[1] = 1;
                // Spawn Leader
                if (leader == 1) {
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
            if (threat == 3) {
                u = instance_nearest(xxx + 30, 240, obj_enunit);
                enemy_dudes = "1000";

                u.dudes[1] = "Palatine";
                u.dudes_num[1] = 1;
                // Spawn Leader
                if (leader == 1) {
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
            if (threat == 4) {
                u = instance_nearest(xxx + 30, 240, obj_enunit);
                enemy_dudes = "4000";

                u.dudes[1] = "Palatine";
                u.dudes_num[1] = 2;
                // Spawn Leader
                if (leader == 1) {
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
            if (threat == 5) {
                u = instance_nearest(xxx + 40, 240, obj_enunit);
                enemy_dudes = "8000";

                u.dudes[1] = "Palatine";
                u.dudes_num[1] = 2;
                // Spawn Leader
                if (leader == 1) {
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
            if (threat == 6) {
                u = instance_nearest(xxx + 50, 240, obj_enunit);
                enemy_dudes = "12000";

                u.dudes[1] = "Palatine";
                u.dudes_num[1] = 1;
                // Spawn Leader
                if (leader == 1) {
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
        if (enemy == 7) {
            // u=instance_create(-10,240,obj_enunit);
            // u.dudes[1]="Stormboy";u.dudes_num[1]=2500;u.flank=1;// enemies[1]=u.dudes[1];

            // Small Ork Group
            if (threat == 1) {
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
                if (leader == 1) {
                    u.dudes[4] = "Leader";
                    u.dudes_num[4] = 1;
                    enemies[4] = 1;
                    enemies_num[4] = 1;
                }
            }
            // Medium Ork Group
            if (threat == 2) {
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
                if (leader == 1) {
                    u.dudes[1] = "Leader";
                    u.dudes_num[1] = 1;
                    enemies[1] = 1;
                    enemies_num[1] = 1;
                }
            }
            // Large Ork Group
            if (threat == 3) {
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
                if (leader == 1) {
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
            if (threat == 4) {
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
                if (leader == 1) {
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
            if (threat == 5) {
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
                if (leader == 1) {
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
            if (threat == 6) {
                enemy_dudes = "a WAAAAGH!! of 11000";

                u = instance_nearest(xxx, 240, obj_enunit);
                u.dudes[1] = "Mekboy";
                u.dudes_num[1] = 6;
                u.dudes[2] = "Flash Git";
                u.dudes_num[2] = 50;
                u.dudes[3] = "Kommando";
                u.dudes_num[3] = 20;
                instance_deactivate_object(u);

                u = instance_nearest(xxx + 10, 240, obj_enunit);
                u.dudes[1] = "Slugga Boy";
                u.dudes_num[1] = 1200;
                u.dudes[2] = "Ard Boy";
                u.dudes_num[2] = 600;
                u.dudes[3] = "Gretchin";
                u.dudes_num[3] = 2000;
                u.dudes[4] = "Tank Busta";
                u.dudes_num[4] = 100;
                instance_deactivate_object(u);

                u = instance_nearest(xxx + 20, 240, obj_enunit);
                u.dudes[1] = "Mekboy";
                u.dudes_num[1] = 6;
                u.dudes[2] = "Flash Git";
                u.dudes_num[2] = 50;
                u.dudes[3] = "Kommando";
                u.dudes_num[3] = 20;
                instance_deactivate_object(u);

                u = instance_nearest(xxx + 30, 240, obj_enunit);
                u.dudes[1] = "Big Warboss";
                u.dudes_num[1] = 1;
                // Spawn Leader
                if (leader == 1) {
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
                instance_deactivate_object(u);

                u = instance_nearest(xxx + 40, 240, obj_enunit);
                u.dudes[1] = "Deff Dread";
                u.dudes_num[1] = 36;
                u.dudes[2] = "Battlewagon";
                u.dudes_num[2] = 220;
                instance_deactivate_object(u);
            }
        }

        // ** Tau Forces **
        if (enemy == 8) {
            // Small Tau Group
            if (threat == 1) {
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
            if (threat == 2) {
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
            if (threat == 3) {
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
            if (threat == 4) {
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
            if (threat == 5) {
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
            if (threat == 6) {
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
        if ((enemy == 9) && (battle_special == "tyranid_org")) {
            u = instance_nearest(xxx, 240, obj_enunit);
            enemy_dudes = "81";
            u.dudes[1] = "Termagaunt";
            u.dudes_num[1] = 40;
            u.dudes[2] = "Hormagaunt";
            u.dudes_num[2] = 40;
            // u.dudes[3]="Lictor";u.dudes_num[3]=1;
        }
        if ((enemy == 9) && (battle_special != "tyranid_org")) {
            // Small Genestealer Group
            if (threat == 1) {
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
            if (threat == 2) {
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
            if (threat == 3) {
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
            if (threat == 4) {
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
            if (threat == 5) {
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
            if (threat == 6) {
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
        if ((enemy == 10) && (battle_special != "ship_demon") && (battle_special != "fallen1") && (battle_special != "fallen2") && (battle_special != "WL10_reveal") && (battle_special != "WL10_later") && (string_count("cs_meeting_battle", battle_special) == 0)) {
            // u=instance_create(-10,240,obj_enunit);
            // u.dudes[1]="Stormboy";u.dudes_num[1]=2500;u.flank=1;// enemies[1]=u.dudes[1];
            // Small Chaos Cult Group
            if (threat == 1) {
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
            if (threat == 2) {
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
            if (threat == 3) {
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
            if (threat == 4) {
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
            if (threat == 5) {
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
            if (threat == 6) {
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
            if (threat == 7) {
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
        if ((enemy == 11) && (battle_special != "world_eaters") && (string_count("cs_meeting_battle", battle_special) == 0)) {
            // Small CSM Group
            if (threat == 1) {
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
            if (threat == 2) {
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
            if (threat == 3) {
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
            if (threat == 4) {
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
            if (threat == 5) {
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
            if (threat == 6) {
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
        if ((enemy == 11) && (battle_special == "world_eaters")) {
            // Small WE Group
            if (threat == 1) {
                u = instance_nearest(xxx, 240, obj_enunit);
                enemy_dudes = "20";

                u.dudes[1] = "Khorne Berzerker";
                u.dudes_num[1] = 15;
                enemies[1] = u.dudes[1];
                // Spawn Leader
                if (obj_controller.faction_defeated[10] == 0) {
                    u.dudes[2] = "Leader";
                    u.dudes_num[2] = 1;
                }
                u.dudes[3] = "World Eaters Veteran";
                u.dudes_num[3] = 5;
            }
            // Medium WE Group
            if (threat == 2) {
                u = instance_nearest(xxx, 240, obj_enunit);
                enemy_dudes = "135";

                u.dudes[1] = "Chaos Chosen";
                u.dudes_num[1] = 1;
                // Spawn Leader
                if (obj_controller.faction_defeated[10] == 0) {
                    u.dudes[1] = "Leader";
                }
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
            if (threat == 3) {
                u = instance_nearest(xxx, 240, obj_enunit);
                enemy_dudes = "over 200";

                u.dudes[1] = "Chaos Chosen";
                u.dudes_num[1] = 1;
                // Spawn Leader
                if (obj_controller.faction_defeated[10] == 0) {
                    u.dudes[1] = "Leader";
                }
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
            if (threat == 4) {
                u = instance_nearest(xxx, 240, obj_enunit);
                enemy_dudes = "over 300";

                u.dudes[1] = "Chaos Chosen";
                u.dudes_num[1] = 1;
                // Spawn Leader
                if (obj_controller.faction_defeated[10] == 0) {
                    u.dudes[1] = "Leader";
                }
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
            if (threat == 5) {
                u = instance_nearest(xxx, 240, obj_enunit);
                enemy_dudes = "over 900";

                u.dudes[1] = "Chaos Chosen";
                u.dudes_num[1] = 1;
                // Spawn Leader
                if (obj_controller.faction_defeated[10] == 0) {
                    u.dudes[1] = "Leader";
                }
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
                if (obj_controller.faction_defeated[10] == 0) {
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
        if (enemy == 12) {
            // If we want to have multiple story events regarding specific Chaos Gods, we could name slaa into gods and just check the value? TBD
            var slaa = false;
            if (battle_special == "ruins_eldar") {
                slaa = true;
            }
            // Small Daemon Group
            if (threat == 1) {
                u = instance_nearest(xxx, 240, obj_enunit);
                enemy_dudes = "5";

                u.dudes[1] = choose("Bloodletter", "Daemonette", "Plaguebearer", "Pink Horror");
                if (slaa) {
                    u.dudes[1] = "Daemonette";
                }
                u.dudes_num[1] = 5;
                enemies[1] = u.dudes[1];
                u.dudes[2] = "Cultist Elite";
                u.dudes_num[2] = 30;
                enemies[2] = u.dudes[2];
            }
            // Medium Daemon Group
            if (threat == 2) {
                u = instance_nearest(xxx, 240, obj_enunit);
                enemy_dudes = "90";

                u.dudes[1] = choose("Bloodletter", "Daemonette", "Plaguebearer", "Pink Horror");
                if (slaa) {
                    u.dudes[1] = "Daemonette";
                }
                u.dudes_num[1] = 30;

                instance_deactivate_object(u);
                u = instance_nearest(xxx + 10, 240, obj_enunit);
                u.dudes[1] = choose("Bloodletter", "Daemonette", "Plaguebearer", "Pink Horror");
                if (slaa) {
                    u.dudes[1] = "Daemonette";
                }
                u.dudes_num[1] = 30;
                u.dudes[2] = "Defiler";
                u.dudes_num[2] = 1;
            }
            // Large Daemon Group
            if (threat == 3) {
                u = instance_nearest(xxx, 240, obj_enunit);
                enemy_dudes = "240";

                u.dudes[1] = "Greater Daemon of " + choose("Tzeentch", "Slaanesh", "Nurgle", "Khorne");
                if (slaa) {
                    u.dudes[1] = "Greater Daemon of Slaanesh";
                }
                u.dudes_num[1] = 1;
                u.dudes[2] = "Chaos Sorcerer";
                u.dudes_num[2] = 1;
                u.dudes[3] = "Pink Horror";
                if (slaa) {
                    u.dudes[3] = "Daemonette";
                }
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
            if (threat == 4) {
                u = instance_nearest(xxx + 40, 240, obj_enunit);
                enemy_dudes = "400";
                u.neww = 1;

                u.dudes[1] = "Greater Daemon of " + string(choose("Slaanesh", "Tzeentch"));
                if (slaa) {
                    u.dudes[1] = "Greater Daemon of Slaanesh";
                }
                u.dudes_num[1] = 1;
                u.dudes[2] = "Greater Daemon of " + string(choose("Nurgle", "Khorne"));
                if (slaa) {
                    u.dudes[2] = "Greater Daemon of Slaanesh";
                }
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
            if (threat == 5) {
                u = instance_nearest(xxx + 40, 240, obj_enunit);
                enemy_dudes = "1000";
                u.neww = 1;

                u.dudes[1] = "Greater Daemon of " + string(choose("Slaanesh", "Tzeentch", "Khorne", "Nurgle"));
                if (slaa) {
                    u.dudes[1] = "Greater Daemon of Slaanesh";
                }
                u.dudes_num[1] = 1;
                u.dudes[2] = "Greater Daemon of " + string(choose("Slaanesh", "Tzeentch", "Khorne", "Nurgle"));
                if (slaa) {
                    u.dudes[2] = "Greater Daemon of Slaanesh";
                }
                u.dudes_num[2] = 1;
                u.dudes[3] = "Greater Daemon of " + string(choose("Slaanesh", "Tzeentch", "Khorne", "Nurgle"));
                if (slaa) {
                    u.dudes[3] = "Greater Daemon of Slaanesh";
                }
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
            if (threat == 6) {
                u = instance_nearest(xxx + 40, 240, obj_enunit);
                enemy_dudes = "2000";
                u.neww = 1;

                u.dudes[1] = "Greater Daemon of " + string(choose("Slaanesh", "Tzeentch", "Khorne", "Nurgle"));
                if (slaa) {
                    u.dudes[1] = "Greater Daemon of Slaanesh";
                }
                u.dudes_num[1] = 1;
                u.dudes[2] = "Greater Daemon of " + string(choose("Slaanesh", "Tzeentch", "Khorne", "Nurgle"));
                if (slaa) {
                    u.dudes[2] = "Greater Daemon of Slaanesh";
                }
                u.dudes_num[2] = 1;
                u.dudes[3] = "Greater Daemon of " + string(choose("Slaanesh", "Tzeentch", "Khorne", "Nurgle"));
                if (slaa) {
                    u.dudes[3] = "Greater Daemon of Slaanesh";
                }
                u.dudes_num[3] = 1;
                u.dudes[4] = "Soul Grinder";
                u.dudes_num[4] = 1;
                instance_deactivate_object(u);

                u = instance_nearest(xxx + 30, 240, obj_enunit);
                u.neww = 1;
                u.dudes[1] = "Greater Daemon of " + string(choose("Slaanesh", "Tzeentch", "Khorne", "Nurgle"));
                if (slaa) {
                    u.dudes[1] = "Greater Daemon of Slaanesh";
                }
                u.dudes_num[1] = 1;
                u.dudes[2] = "Greater Daemon of " + string(choose("Slaanesh", "Tzeentch", "Khorne", "Nurgle"));
                if (slaa) {
                    u.dudes[2] = "Greater Daemon of Slaanesh";
                }
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
        if ((enemy == 13) && ((string_count("_attack", battle_special) == 0) || (string_count("wake", battle_special) > 0))) {
            // Small Necron Group
            if (threat == 1) {
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
            if (threat == 2) {
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
            if (threat == 3) {
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
            if (threat == 4) {
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
            if (threat == 5) {
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
            if (threat == 6) {
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
            }

            u.veh_wep1[1] = "Heavy Bolter Emplacement";
            u.veh_wep1[2] = "Missile Launcher Emplacement";
            u.veh_wep1[3] = "Missile Silo";
            u.veh = 3;
            u.sprite_index = spr_weapon_blank;
        }

        instance_activate_object(obj_enunit);
    } catch (_exception) {
        handle_exception(_exception);
        instance_destroy(obj_enunit);
        instance_destroy(obj_pnunit);
        instance_destroy(obj_ncombat);
    }
}

// alarm_1
/// @mixin
function ncombat_battle_start() {
    var a1;
    a1 = "";

    if ((ally > 0) && (ally_forces > 0)) {
        if (ally == 3) {
            if (ally_forces >= 1) {
                a1 = "Joining your forces are 10 Techpriests and 20 Skitarii.  Omnissian Power Axes come to life, crackling and popping with disruptive energy, and Conversion Beam Projectors are levelled to fire.  The Tech-Guard are silent as they form a perimeter around their charges, at contrast with their loud litanies and Lingua-technis bursts.";
            }
        }
    }

    // Player crap here
    var p1, p2, p3, p4, p5, p6, p8, temp, temp2, temp3, temp4, temp5, temp6;
    p1 = "";
    p2 = "";
    p3 = "";
    p4 = "";
    p5 = "";
    p6 = "";
    p8 = "";
    temp = 0;
    temp2 = 0;
    temp3 = 0;
    temp4 = 0;
    temp5 = 0;
    temp6 = 0;
    var d1, d2, d3, d4, d5, d6, d7, d8;
    d1 = "";
    d2 = "";
    d3 = "";
    d4 = "";
    d5 = "";
    d6 = "";
    d7 = "";
    d8 = "";

    temp = scouts + tacticals + veterans + devastators + assaults + librarians;
    temp += techmarines + honors + dreadnoughts + terminators + captains;
    temp += standard_bearers + champions + important_dudes + chaplains + apothecaries;
    temp += sgts + vet_sgts;

    var color_descr;
    color_descr = "";

    if (obj_ini.main_color != obj_ini.secondary_color) {
        color_descr = string(obj_controller.col[obj_ini.main_color]) + " and " + string(obj_controller.col[obj_ini.secondary_color]);
    }
    if (obj_ini.main_color == obj_ini.secondary_color) {
        color_descr = string(obj_controller.col[obj_ini.main_color]);
    }

    /*show_message(scouts+tacticals+veterans+devastators+assaults+librarians);
    show_message(techmarines+honors+dreadnoughts+terminators+captains);
    show_message(standard_bearers+important_dudes+chaplains+apothecaries);
    show_message(temp);*/

    // Random variations; dark out, rain pooling down, dawn shining off of the armour, etc.
    var variation;
    variation = "";
    variation = choose("", "dawn", "rain");

    if (battle_special == "ship_demon") {
        p1 = "As the Artifact is smashed and melted down some foul smoke begins to erupt from it, spilling outward and upward.  After a sparse handful of seconds it takes form into a ";
        p1 += string(obj_enunit.dudes[1]);
        p1 += ".  Now free, it seems bent upon slaying your marines.  Onboard you have ";
    }

    if ((battle_special == "ruins") || (battle_special == "ruins_eldar")) {
        p1 = "Your marines place themselves into a proper fighting position, defensible and ready to fight whatever may come.  Enemies may only come from a few directions, though the ancient corridors and alleyways are massive, and provide little cover.";
        p1 += "  You have ";
    }

    if (string_count("mech", battle_special) > 0) {
        p1 = "Large, hulking shapes advance upon your men from every direction.  The metal corridors and blast chambers prevent escape.  Soon 4 Thallax and half a dozen Praetorian Servitors can be seen, with undoubtably more to come.";
        p1 += "  You have ";
    }

    if (battle_special == "space_hulk") {
        if (hulk_forces > 0) {
            p1 = "Your marines manuever through the hull of the Space Hulk, shadows dancing and twisting before their luxcasters.  The hallway integrity is nonexistant- twisted metal juts out in hazardous ways or opens into bottomless pits.  Still, there is loot and knowledge to be gained.  It is not long before your men's sensorium pick up hostile blips.  Your own forces are made up of ";
        }
        if (hulk_forces == 0) {
            p1 = "Your marines manuever through the hull of the Space Hulk, shadows dancing and twisting before their luxcasters.  The hallway integrity is nonexistant- twisted metal juts out in hazardous ways or opens into bottomless pits.  Your forces are made up of ";
        }
    }

    if (battle_special == "") {
        if (dropping == 0) {
            if (temp - dreadnoughts > 0) {
                if (variation == "") {
                    p1 = "Dirt crunches beneath the soles of " + string(temp) + " " + string(global.chapter_name) + " as they form up.  Your ranks are made up of ";
                }
                if (variation == "rain") {
                    p1 = "Rain pelts the ground and fogs the air, partly veiling the " + string(temp) + " " + string(global.chapter_name) + ".  Your ranks are made up of ";
                }
                if (variation == "dawn") {
                    p1 = "The bright light of dawn reflects off the " + string_lower(color_descr) + " ceremite of " + string(temp) + " " + string(global.chapter_name) + ".  Your ranks are made up of ";
                }
            }
        }
        if (dropping == 1) {
            if (temp - dreadnoughts > 0) {
                // lyman
                p1 = "The air rumbles and quakes as " + string(temp) + " " + string(global.chapter_name) + " descend in drop-pods.  ";

                /*if (variation=""){
                    if (lyman=0) then p1="The air rumbles and quakes as "+string(temp)+" "+string(global.chapter_name)+" descend in drop-pods.  Before the enemy can bring their full ranged power to bear the pods smash down.  With practiced speed your marines pour on free.  Their ranks are made up of ";
                    if (lyman=1) then p1="The air rumbles and quakes as "+string(temp)+" "+string(global.chapter_name)+" descend in drop-pods.  Before the enemy can bring their full ranged power to bear the pods smash down.  Your marines exit the vehicles, shaking off their vertigo and nausea with varying degrees of success.  Your ranks are made up of ";
                }
                */
            }
        }
    }
    if (string_count("spyrer", battle_special) > 0) {
        p1 = "Your marines search through the alleyways and corridors likely to contain the Spyrer.  It does not take long before the lunatic attacks, springing off from a wall to fall among your men.  Your ranks are made up of ";
    }
    if (string_count("fallen", battle_special) > 0) {
        p1 = "Your marines search through the alleyways and dens likely to contain the Fallen.  Several days pass before the search is succesful; the prey is located by Auspex and closed in upon.  ";
        if (battle_climate == "Lava") {
            p1 = "Your marines search through the broken craggs and spires of the molten planet.  Among the bubbling lava, and cracking earth, they search for the Fallen.  After several days of searching Auspex detect the prey.  ";
        }
        if (battle_climate == "Dead") {
            p1 = "Your marines search through the cratered surface of the debris field.  Among the cracking earth and dust they search for the Fallen.  After several days of searching Auspex detect the prey.  ";
        }
        if (battle_climate == "Agri") {
            p1 = "Endless fields of wheat and barley are an unlikely harbor for a renegade, but your marines search the agri world all the same.  After several days of searching Auspex detect the prey.  ";
        }
        if (battle_climate == "Death") {
            p1 = "Deadly carniverous plants and endless canopy blot out the surface of the planet.  Among the disheveled hills, and heavy underbrush, your marines search for the Fallen.  After several days of searching Auspex detect the prey.  ";
        }
        if (battle_climate == "Ice") {
            p1 = "Your marines search through the endless glaciers and peaks of the frozen planet.  Among the howling wind, and cracking ice, they search for the Fallen.  After several days of searching Auspex detect the prey.  ";
        }
        if (obj_enunit.dudes_num[1] == 1) {
            p1 += "The coward soon realizes he has been located, and reacts like a cornered animal, brandishing weapons.";
        }
        if (obj_enunit.dudes_num[1] > 1) {
            p1 += "The cowards soon realize they have been located, and react like cornered animals, brandishing weapons.";
        }
        p1 += "  Your ranks are made up of ";
    }

    if (string_count("_attack", battle_special) > 0) {
        var wh;
        wh = choose(1, 2);
        if (wh == 1) {
            p1 = "Cave dirt crunches beneath the soles of your marines as they continue their descent.  There is little warning before ";
        }
        if (wh == 2) {
            p1 = "The shadows stretch and morph as the lights cast by your marines move along.  One large shadow begins to move on its own- ";
        }

        if (string_count("wake", battle_special) > 0) {
            p1 = "Cave dirt crunches beneath the soles of your marines as they continue their descent.  There is little warning when the ground begins to shake.  An old, dusty breeze seems to flow through the tunnel, followed by rumbling sensations and distant mechanical sounds.  ";
            if (string_count("1", battle_special) > 0) {
                p1 += "Within minutes Necrons begin to appear from every direction.  There appears to be nearly fourty, cramped in the dark tunnels.";
            }
            if (string_count("2", battle_special) > 0) {
                p1 += "Within minutes Necrons begin to appear from every direction.  There appears to be nearly a hundred, cramped in the dark tunnels.";
            }
            if (string_count("3", battle_special) > 0) {
                p1 += "Within minutes Necrons begin to appear from every direction.  Their numbers are wihout number.";
            }
        }

        if (string_count("wraith", battle_special) > 0) {
            p1 += "two Necron Wraiths appear out of nowhere and begin to attack.";
        }
        if (string_count("spyder", battle_special) > 0) {
            p1 += "a large Canoptek Spyder launches towards your marines, a small group of scuttling Scarabs quickly following.";
        }
        if (string_count("stalker", battle_special) > 0) {
            p1 += "the tunnel begins to shake and a massive Tomb Stalker scuttles into your midst.";
        }
        newline = p1;
        scr_newtext();
        exit;
    }

    if ((tacticals > 0) && (veterans > 0)) {
        p2 = string(tacticals + veterans) + " " + string(obj_ini.role[100][8]) + "s, ";
    }
    if ((tacticals > 0) && (veterans == 0)) {
        if (tacticals == 1) {
            p2 = string(tacticals) + " " + string(obj_ini.role[100][8]) + ", ";
        }
        if (tacticals > 1) {
            p2 = string(tacticals) + " " + string(obj_ini.role[100][8]) + "s, ";
        }
    }
    if ((tacticals == 0) && (veterans > 0)) {
        if (veterans == 1) {
            p2 = string(veterans) + " " + string(obj_ini.role[100][3]) + ", ";
        }
        if (veterans > 1) {
            p2 = string(veterans) + " " + string(obj_ini.role[100][3]) + "s, ";
        }
    }

    if (assaults > 0) {
        if (assaults == 1) {
            p2 += string(assaults) + " " + string(obj_ini.role[100][10]) + ", ";
        }
        if (assaults > 1) {
            p2 += string(assaults) + " " + string(obj_ini.role[100][10]) + "s, ";
        }
    }
    if (devastators > 0) {
        if (devastators == 1) {
            p2 += string(devastators) + " " + string(obj_ini.role[100][9]) + ", ";
        }
        if (devastators > 1) {
            p2 += string(devastators) + " " + string(obj_ini.role[100][9]) + "s, ";
        }
    }

    if ((temp < 200) && (terminators > 0)) {
        if (terminators == 1) {
            p2 += string(terminators) + " Terminator, ";
        }
        if (terminators > 1) {
            p2 += string(terminators) + " Terminators, ";
        }
    }

    if ((temp < 200) && (chaplains > 0)) {
        if (chaplains == 1) {
            p2 += string(chaplains) + " " + string(obj_ini.role[100][14]) + ", ";
        }
        if (chaplains > 1) {
            p2 += string(chaplains) + " " + string(obj_ini.role[100][14]) + ", ";
        }
    }

    if ((temp < 200) && (apothecaries > 0)) {
        if (apothecaries == 1) {
            p2 += string(apothecaries) + " " + string(obj_ini.role[100][15]) + ", ";
        }
        if (apothecaries > 1) {
            p2 += string(apothecaries) + " " + string(obj_ini.role[100][15]) + ", ";
        }
    }

    if ((temp < 200) && (librarians > 0)) {
        if (librarians == 1) {
            p2 += string(librarians) + " " + string(obj_ini.role[100, 17]) + ", ";
        }
        if (librarians > 1) {
            p2 += string(librarians) + " " + string(obj_ini.role[100, 17]) + ", ";
        }
    }

    if ((temp < 200) && (techmarines > 0)) {
        if (techmarines == 1) {
            p2 += string(techmarines) + " " + string(obj_ini.role[100][16]) + ", ";
        }
        if (techmarines > 1) {
            p2 += string(techmarines) + " " + string(obj_ini.role[100][16]) + ", ";
        }
    }
    if ((temp < 200) && (sgts > 0)) {
        if (techmarines == 1) {
            p2 += string(techmarines) + " " + string(obj_ini.role[100][18]) + ", ";
        }
        if (techmarines > 1) {
            p2 += string(techmarines) + " " + string(obj_ini.role[100][18]) + ", ";
        }
    }
    if ((temp < 200) && (vet_sgts > 0)) {
        if (techmarines == 1) {
            p2 += string(techmarines) + " " + string(obj_ini.role[100][19]) + ", ";
        }
        if (techmarines > 1) {
            p2 += string(techmarines) + " " + string(obj_ini.role[100][19]) + ", ";
        }
    }

    if (scouts > 0) {
        if (scouts == 1) {
            p2 += string(scouts) + " " + string(obj_ini.role[100][12]) + ", ";
        }
        if (scouts > 1) {
            p2 += string(scouts) + " " + string(obj_ini.role[100][12]) + "s, ";
        }
    }

    // temp5=string_length(p2);p2=string_delete(p2,temp5-1,2);// p2+=".";
    temp6 = honors + captains + important_dudes + standard_bearers;
    if (temp >= 200) {
        temp6 += terminators;
    }
    if (temp >= 200) {
        temp6 += chaplains;
    }
    if (temp >= 200) {
        temp6 += apothecaries;
    }
    if (temp >= 200) {
        temp6 += techmarines;
    }
    if (temp >= 200) {
        temp6 += librarians;
    }
    if (temp6 > 0) {
        p2 += string(temp6) + " other various Astartes, ";
    }

    var woo;
    woo = string_length(p2);
    p2 = string_delete(p2, woo - 1, 2);

    if (string_count(", ", p2) > 1) {
        var woo;
        woo = string_rpos(", ", p2);
        p2 = string_insert(" and", p2, woo + 1);
    }
    if (string_count(", ", p2) == 1) {
        var woo;
        woo = string_rpos(", ", p2);
        p2 = string_delete(p2, woo - 1, 2);
        p2 = string_insert(" and", p2, woo + 1);
    }
    p2 += ".";

    if ((standard_bearers > 1) && (dropping == 0)) {
        p5 = "  Chapter Ancients hold your Chapter heraldry high and proud.";
    }

    if (dreadnoughts + predators + land_raiders > 3) {
        p6 = "  Forming up the armoured division is ";
        if (dreadnoughts == 1) {
            p6 += string(dreadnoughts) + " " + string(obj_ini.role[100][6]) + ", ";
        }
        if (dreadnoughts > 1) {
            p6 += string(dreadnoughts) + " " + string(obj_ini.role[100][6]) + "s, ";
        }

        if (rhinos == 1) {
            p6 += string(rhinos) + " Rhino, ";
        }
        if (rhinos > 1) {
            p6 += string(rhinos) + " Rhinos, ";
        }

        if (predators == 1) {
            p6 += string(predators) + " Predator, ";
        }
        if (predators > 1) {
            p6 += string(predators) + " Predators, ";
        }

        if (land_raiders == 1) {
            p6 += string(land_raiders) + " Land Raider, ";
        }
        if (land_raiders > 1) {
            p6 += string(land_raiders) + " Land Raiders, ";
        }

        if (land_speeders == 1) {
            p6 += string(land_speeders) + " Land Speeder, ";
        }
        if (land_speeders > 1) {
            p6 += string(land_speeders) + " Land Speeders, ";
        }

        if (whirlwinds == 1) {
            p6 += string(whirlwinds) + " Whirlwind, ";
        }
        if (whirlwinds > 1) {
            p6 += string(whirlwinds) + " Whirlwinds, ";
        }

        // Other vehicles here?

        var woo;
        woo = string_length(p6);
        p6 = string_delete(p6, woo - 1, 2);

        if (string_count(", ", p6) > 1) {
            var woo;
            woo = string_rpos(", ", p6);
            p6 = string_insert(" and", p6, woo + 1);
        }
        if (string_count(", ", p6) == 1) {
            var woo;
            woo = string_rpos(", ", p6);
            p6 = string_delete(p6, woo - 1, 2);
            p6 = string_insert(" and", p6, woo + 1);
        }
        p6 += ".";
    }
    // If less than three spell out the individual vehicles

    if (battle_special == "space_hulk") {
        newline = p1 + p2;
        scr_newtext();
        if (a1 != "") {
            newline = a1;
            scr_newtext();
        }
        if (hulk_forces > 0) {
            newline = "There are " + string(hulk_forces) + " or so blips.";
            scr_newtext();
        }

        exit;
    }
    if (dropping == 0) {
        newline = p1 + p2 + p3 + p4 + p5 + p6;
        scr_newtext();
        if (a1 != "") {
            newline = a1;
            scr_newtext();
        }
    }

    if ((dropping == 1) && (battle_special != "space_hulk")) {
        d1 = p1;
        d2 = p2;
        d3 = p3;
        d4 = p4;
        d5 = p5;
        d6 = p6;
    }

    if ((battle_special == "ruins") || (battle_special == "ruins_eldar")) {
        newline = "The enemy forces are made up of " + string(enemy_dudes);

        if (enemy == 6) {
            newline += " Craftworld Eldar.";
        }
        if (enemy == 10) {
            newline += " Cultists and Mutants.";
        }
        if (enemy == 11) {
            newline += " Chaos Space Marines.";
        }
        if (enemy == 12) {
            newline += " Daemons.";
        }

        scr_newtext();
        exit;
    }

    // Enemy crap here
    var rand;
    p1 = "";
    p2 = "";
    p3 = "";
    p4 = "";
    p5 = "";
    p6 = "";
    temp2 = 0;
    temp3 = 0;
    temp4 = 0;
    temp5 = 0;

    /*if (terrain=""){rand=choose(1,2,3);// Variations for terrain
        if (rand<4) then 
        // if (rand=2) then p1="Encroaching upon your forces are ";
        // if (rand=3) then p1="Advancing upon your forces are ";
    }

    // p1+=string(enemy_dudes);// The number descriptor*/

    if (enemy == 2) {
        p1 = "Opposing your forces are a total of " + scr_display_number(floor(guard_effective)) + " Guardsmen, including Heavy Weapons and Armour.";
        p2 = "";
        p3 = "";
    }

    if ((enemy == 5) && (dropping == 0)) {
        p1 = "Marching to face your forces ";
        if (threat == 1) {
            p2 = "are a squad of Adepta Sororitas, back up by a dozen priests.  Forming up a protective shield around them are a large group of religious followers, gnashing and screaming out litanies to the Emperor.";
        }
        if (threat == 2) {
            p2 = "are several squads of Adepta Sororitas.  A large pack of religious followers forms up a protective shield in front, backed up by numerous Acro-Flagellents.";
        }
        if (threat == 3) {
            p2 = "are more than four hundred Adepta Sororitas, thick clouds of incense and smoke heralding their advance.  An equally massive pack of religious followers are spread around, screaming and babbling hyms to the Emperor.  Many are already bleeding from self-inflicted wounds or flagellation.  Several Penitent Engines clank and advance in the forefront.";
        }
        if (threat == 4) {
            p2 = "are more than a thousand Adepta Sororitas, a large portion of an order, thick clouds of incense and smoke heralding their advance.  A massive pack of religious followers are spread among the force, screaming and babbling hyms to the Emperor.  Many are already bleeding from self-inflicted wounds or flagellation.  Their voices are drowned out by the rumble of Penitent Engines and the loud vox-casters of Excorcists, blasting out litanies and organ music even more deafening volumes.";
        }
        if (threat >= 5) {
            p2 = "is the entirety of an Adepta Sororitas order, the ground shaking beneath their combined thousands of footsteps.  Forming a shield around them in a massive, massive pack of religious followers, screaming out or babbling hyms to the Emperor.  All of the opposing army is a blurring, shifting mass of robes and ceremite, and sound, Ecclesiarchy Priests and Mistresses whipping the masses into more of a blood frenzy.  Organ music and litanies blast from the many Exorcists, the sound deafening to those too close.  Carried with the wind, and lingering in the air, is the heavy scent of promethium.";
        }
    }

    if ((enemy == 6) && (dropping == 0)) {
        // p1+=" Eldar";// Need a few random descriptors here
        rand = choose(1, 2, 3);
    }
    if ((enemy == 7) && (dropping == 0)) {
        // p1+=" Orks";
        rand = choose(1, 2, 3);
        if (rand < 4) {
            p1 = "Howls and grunts ring from the surrounding terrain as the Orks announce their presence.  ";
            p2 = string(enemy_dudes) + ", the bloodthirsty horde advances toward your Marines, ecstatic in their anticipation of carnage.  ";
            p3 = p2;
            p2 = string_delete(p2, 2, 999);
            p3 = string_delete(p3, 1, 1);
            p2 = string_upper(p2); // Capitalize the ENEMY DUDES first letter
        }
    }
    if ((enemy == 7) && (dropping == 1)) {
        p1 = "The " + string(enemy_dudes) + "-some Orks howl and roar at the oncoming marines.  Many of the beasts fire their weapons, more or less spraying rounds aimlessly into the sky.";
    }

    if ((enemy == 8) && (dropping == 0)) {
        // p1+=" Tau";
        rand = choose(1, 2, 3);
    }
    if ((enemy == 9) && (dropping == 0)) {
        // p1+=" Tyranids";
        rand = choose(1, 2, 3);
    }
    if ((enemy == 9) && (dropping == 1)) {
        p1 = "The " + string(enemy_dudes) + "-some Tyranids hiss and chitter as your marines rain down.  Blasts of acid and spikes fill the sky, but none seem to quite find their mark.";
    }

    if ((enemy == 10) && (dropping == 0)) {
        // p1+=" heretics";
        rand = choose(1, 2, 3);
    }

    if ((enemy == 10) && (threat == 7)) {
        rand = choose(1, 2);
        if (rand == 1) {
            p1 = "Laying before them is a hellish landscape, fitting for nightmares.  Twisted, flesh-like spires reach for the sky, each containing a multitude of fanged maws or eyes.  Lightning crackles through the red sky.  ";
        }
        if (rand == 2) {
            p1 = "Waiting for your marines is a twisted landscape.  Mutated, fleshy spires reach for the sky.  The ground itself is made up of choking purple ash, kicked up with each footstep, blocking vision.  ";
        }
        p1 += "All that can be seen twists and shifts, as though looking through a massive, distorted lens.  ";
        p8 = "The enemy forces are made up of over 3000 lesser Daemons.  Their front and rear ranks are made up of Maulerfiends and Soulgrinders, backed up by nearly a dozen Greater Daemons.  Each of the four Chaos Gods are represented.";
    }

    if ((enemy == 11) && (dropping == 0)) {
        // p1+=" Chaos Space Marines";
        rand = choose(1, 2, 3);
    }

    if ((enemy == 12) && (dropping == 0)) {
        // Daemons
    }

    if ((enemy == 13) && (dropping == 0)) {
        rand = choose(1, 2, 3);
        if (rand < 4) {
            p1 = "Dirt crunches beneath the feet of the Necrons as they make their silent advance.  ";
            p2 = string(enemy_dudes) + ", the souless xeno advance toward your Marines, silent and pulsing with green energy.  ";
            p3 = p2;
            p2 = string_delete(p2, 2, 999);
            p3 = string_delete(p3, 1, 1);
            p2 = string_upper(p2); // Capitalize the ENEMY DUDES first letter
        }
    }

    if (dropping == 0) {
        newline = p1 + p2 + p3 + p4 + p5 + p6;
        scr_newtext();
        if (a1 != "") {
            newline = a1;
            scr_newtext();
        }
        if (p8 != "") {
            newline = p8;
            scr_newtext();
        }
    }

    if (dropping == 1) {
        newline = d1 + p1;
        scr_newtext();
        if (obj_ini.lyman == 0) {
            d7 = "After a brief descent all of the drop-pods smash down, followed quickly by your marines pouring free.  Their ranks are made up of ";
        }
        if (obj_ini.lyman == 1) {
            d7 = "After a brief descent all of the drop-pods smash down.  Your marines exit the vehicles, shaking off their vertigo and nausea with varying degrees of success.  Their ranks are made up of ";
        }
        newline = d7 + d2 + d3 + d4 + d5 + d6;
        scr_newtext();
        if (a1 != "") {
            newline = a1;
            scr_newtext();
        }
        if (p8 != "") {
            newline = p8;
            scr_newtext();
        }
    }

    if ((obj_ini.occulobe) && (battle_special != "space_hulk")) {
        if ((time == 5) || (time == 6)) {
            newline = "The morning light of dawn is blinding your marines!";
            newline_color = COL_RED;
            scr_newtext();
        }
    }

    if ((fortified > 1) && (dropping == 0) && (enemy + threat != 17)) {
        if (fortified == 2) {
            newline = "An Aegis Defense Line protects your forces.";
        }
        if (fortified == 3) {
            newline = "Thick plasteel walls protect your forces.";
        }
        if (fortified == 4) {
            newline = "A series of thick plasteel walls protect your forces.";
        }
        if (fortified >= 5) {
            newline = "A massive plasteel bastion protects your forces.";
        }

        if ((player_defenses > 0) && (player_silos > 0)) {
            newline += "  The front of your Monastery also boasts " + string(player_defenses) + " Weapon Emplacements and " + string(player_silos) + " Missile Silos.";
        }
        if ((player_defenses == 0) && (player_silos > 0)) {
            newline += "  Your Monastery also boasts " + string(player_silos) + " Missile Silos.";
        }
        if ((player_defenses > 0) && (player_silos == 0)) {
            newline += "  The front of your Monastery also boasts " + string(player_defenses) + " Weapon Emplacements.";
        }

        scr_newtext();
    }

    // Check for battlecry here
    // if (temp>=100) and (threat>1) and (big_mofo!=10) and (dropping=0){
    if ((temp >= 100) && (threat > 1) && (big_mofo > 0) && (big_mofo < 10) && (dropping == 0)) {
        p1 = "";
        p2 = "";
        p3 = "";
        p4 = "";
        p5 = "";
        p6 = "";
        temp4 = 0;
        temp5 = 0;

        if (big_mofo == 1) {
            p1 = "You ";
        }
        if (big_mofo == 2) {
            p1 = "The Master of Sanctity ";
        }
        if (big_mofo == 3) {
            p1 = "Chief " + string(obj_ini.role[100, 17]) + " ";
        }
        if (big_mofo == 5) {
            p1 = "A Captain ";
        }
        if (big_mofo == 8) {
            p1 = "A Chaplain ";
        }

        var standard_cry;
        standard_cry = 0;
        if (global.chapter_name == "Salamanders") {
            standard_cry = 1;
            var rand;
            rand = choose(1, 2, 3, 4, 5);
            if ((rand == 1) && (big_mofo != 1)) {
                p2 = "breaks the silence, begining the Chapter Battlecry-";
            }
            if ((rand == 1) && (big_mofo == 1)) {
                p2 = "break the silence, begining the Chapter Battlecry-";
            }
            if ((rand == 2) && (big_mofo != 1)) {
                p2 = "roars the first half of the Chapter Battlecry-";
            }
            if ((rand == 2) && (big_mofo == 1)) {
                p2 = "roar the first half of the Chapter Battlecry-";
            }
            if ((rand == 3) && (big_mofo != 1)) {
                p2 = "shouts the start of the Chapter Battlecry-";
            }
            if ((rand == 3) && (big_mofo == 1)) {
                p2 = "shout the start of the Chapter Battlecry-";
            }
            if ((rand == 4) && (big_mofo != 1)) {
                p2 = "calls out to your marines-";
            }
            if ((rand == 4) && (big_mofo == 1)) {
                p2 = "call out to your marines-";
            }
            if ((rand == 5) && (big_mofo != 1)) {
                p2 = "roars to your marines-";
            }
            if ((rand == 5) && (big_mofo == 1)) {
                p2 = "roar to your marines-";
            }
            p3 = "''Into the fires of battle!''";
            if ((temp >= 100) && (temp < 200)) {
                p4 = "Over a hundred Astartes roar in return, their voice one-";
            }
            if ((temp >= 200) && (temp < 400)) {
                p4 = "Several hundred Astartes roar in return, their voice one-";
            }
            if ((temp >= 500) && (temp < 800)) {
                p4 = "Your battle brothers echoe the cry, a massive sound felt more than heard-";
            }
            if (temp > 800) {
                p4 = "The sound is deafening as the " + string(global.chapter_name) + " shout in unison-";
            }
            p5 = "''UNTO THE ANVIL OF WAR!''";
            newline = p1 + p2;
            scr_newtext();
            newline = p3;
            scr_newtext();
            newline = p4;
            scr_newtext();
            newline = p5;
            scr_newtext();
        }
        if (obj_ini.battle_cry == "...") {
            standard_cry = 1;
            var rand;
            rand = choose(1, 2, 3);
            if ((rand == 1) && (big_mofo != 1)) {
                p2 = "remains silent as the Chapter forms for battle-";
            }
            if ((rand == 1) && (big_mofo == 1)) {
                p2 = "remain silent as the Chapter forms for battle-";
            }
            if ((rand == 2) && (big_mofo != 1)) {
                p2 = "remains silent and issues orders to the Chapter for battle-";
            }
            if ((rand == 2) && (big_mofo == 1)) {
                p2 = "remain silent and issues orders to the Chapter for battle-";
            }
            if ((rand == 3) && (big_mofo != 1)) {
                p2 = "issues orders to the Chapter over Vox-";
            }
            if ((rand == 3) && (big_mofo == 1)) {
                p2 = "whisper to your brothers the plans for initial deployment over vox-";
            }
            p3 = "''Sharp gestures and handsigns from officers direct the Marines''";
            if ((temp >= 100) && (temp < 200)) {
                p4 = "Over a hundred Astartes nod in acknowledgement and move quickly-";
            }
            if ((temp >= 200) && (temp < 400)) {
                p4 = "Several hundred Astartes nod in acknowledgement and move swiftly-";
            }
            if ((temp >= 500) && (temp < 800)) {
                p4 = "Your battle brothers all nod in acknowledgement and move hastily-";
            }
            if (temp > 800) {
                p4 = "The fluidity is astounding as the " + string(global.chapter_name) + " move seamlessly into position ready for battle-";
            }
            p5 = "''They stand ready to engage the enemy''";
            newline = p1 + p2;
            scr_newtext();
            newline = p3;
            scr_newtext();
            newline = p4;
            scr_newtext();
            newline = p5;
            scr_newtext();
        }

        // show_message(string(global.chapter_name)+"|"+string(global.custom)+"|"+string(standard_cry));

        if ((global.chapter_name == "Iron Warriors") && (global.custom == 0)) {
            standard_cry = 1;
            var rand;
            rand = choose(1, 2, 3, 4, 5);
            if ((rand == 1) && (big_mofo != 1)) {
                p2 = "breaks the silence, begining the Chapter Battlecry-";
            }
            if ((rand == 1) && (big_mofo == 1)) {
                p2 = "break the silence, begining the Chapter Battlecry-";
            }
            if ((rand == 2) && (big_mofo != 1)) {
                p2 = "roars the first half of the Chapter Battlecry-";
            }
            if ((rand == 2) && (big_mofo == 1)) {
                p2 = "roar the first half of the Chapter Battlecry-";
            }
            if ((rand == 3) && (big_mofo != 1)) {
                p2 = "shouts the start of the Chapter Battlecry-";
            }
            if ((rand == 3) && (big_mofo == 1)) {
                p2 = "shout the start of the Chapter Battlecry-";
            }
            if ((rand == 4) && (big_mofo != 1)) {
                p2 = "calls out to your marines-";
            }
            if ((rand == 4) && (big_mofo == 1)) {
                p2 = "call out to your marines-";
            }
            if ((rand == 5) && (big_mofo != 1)) {
                p2 = "roars to your marines-";
            }
            if ((rand == 5) && (big_mofo == 1)) {
                p2 = "roar to your marines-";
            }
            p3 = "''Iron within!''";
            if ((temp >= 100) && (temp < 200)) {
                p4 = "Over a hundred Astartes roar in return, their voice one-";
            }
            if ((temp >= 200) && (temp < 400)) {
                p4 = "Several hundred Astartes roar in return, their voice one-";
            }
            if ((temp >= 500) && (temp < 800)) {
                p4 = "Your battle brothers echoe the cry, a massive sound felt more than heard-";
            }
            if (temp > 800) {
                p4 = "The sound is deafening as the " + string(global.chapter_name) + " shout in unison-";
            }
            p5 = "''IRON WITHOUT!''";
            newline = p1 + p2;
            scr_newtext();
            newline = p3;
            scr_newtext();
            newline = p4;
            scr_newtext();
            newline = p5;
            scr_newtext();
        }

        if (standard_cry == 0) {
            standard_cry = 1;
            var rand;
            rand = choose(1, 2, 3, 4);
            if (rand == 1) {
                if (big_mofo != 1) {
                    p2 = "breaks ";
                }
                if (big_mofo == 1) {
                    p2 = "break ";
                }
                p2 += "the silence, calling out the Chapter Battlecry-";
            }
            if (rand == 2) {
                if (big_mofo != 1) {
                    p2 = "roars ";
                }
                if (big_mofo == 1) {
                    p2 = "roar ";
                }
                p2 += "the Chapter Battlecry-";
            }
            if (rand == 3) {
                if (big_mofo != 1) {
                    p2 = "shouts ";
                }
                if (big_mofo == 1) {
                    p2 = "shout ";
                }
                p2 += "the Chapter Battlecry-";
            }
            if (rand == 4) {
                if (big_mofo != 1) {
                    p2 = "roars ";
                }
                if (big_mofo == 1) {
                    p2 = "roar ";
                }
                p2 += "to your marines-";
            }
            p3 = "''" + string(obj_ini.battle_cry) + "!''";
            if ((temp >= 100) && (temp < 200)) {
                p4 = "Over a hundred Astartes echoe the cry or let out shouts of their own.";
            }
            if ((temp >= 200) && (temp < 400)) {
                p4 = "Several hundred Astartes roar in return, echoing the cry.";
            }
            if ((temp >= 500) && (temp < 800)) {
                p4 = "Your battle brothers echoe the cry, a massive sound felt more than heard.";
            }
            if ((temp > 800) && (rand >= 3)) {
                p4 = "The sound is deafening as the " + string(global.chapter_name) + " add their voices.";
            }
            if ((temp > 800) && (rand <= 2)) {
                p4 = "The sound is deafening as the " + string(global.chapter_name) + " return the cry and magnify it a thousand times.";
            }
            newline = p1 + p2;
            scr_newtext();
            newline = p3;
            scr_newtext();
            newline = p4;
            scr_newtext();
        }
    }

    var line_break = "------------------------------------------------------------------------------";
    newline = line_break;
    scr_newtext();
    newline = line_break;
    scr_newtext();

    /* */
    /*  */
}

// alarm_2
/// @mixin
function ncombat_ally_init() {
    player_max = player_forces;
    enemy_max = enemy_forces;

    instance_activate_object(obj_enunit);

    if (dropping) {
        squeeze_map_forces();
    }

    if ((ally > 0) && (ally_forces > 0)) {
        if (ally == 3) {
            if (ally_forces >= 1) {
                var thata, ii, good;
                thata = instance_nearest(0, 240, obj_pnunit);
                ii = 0;
                good = 0;

                //TODO refactor so that unit structs are created for ally forces
            }
        }
    }

    instance_activate_object(obj_enunit);
}

//alarm_5
/// @mixin
function ncombat_battle_end() {
    // Final Screen
    var part1 = "", part2 = "", part3 = "", part4 = "", part9 = "";
    var part5 = "", part6 = "", part7 = "", part8 = "", part10 = "";
    battle_over = 1;

    var line_break = "------------------------------------------------------------------------------";
    // show_message("Final Deaths: "+string(final_marine_deaths));

    if (turn_count >= 50) {
        part1 = "Your forces make a fighting retreat \n";
    }
    // check for wounded marines here to finish off, if defeated defending
    var roles = obj_ini.role[100];
    var ground_mission = instance_exists(obj_ground_mission);

    with (obj_pnunit) {
        after_battle_part1();
    }

    if (obj_ncombat.defeat == 0) {
        marines_to_recover = ds_priority_create();
        vehicles_to_recover = ds_priority_create();

        with (obj_pnunit) {
            add_marines_to_recovery();
            add_vehicles_to_recovery();
        }

        while (!ds_priority_empty(marines_to_recover)) {
            var _candidate = ds_priority_delete_max(marines_to_recover);
            var _column_id = _candidate.column_id;
            var _unit_id = _candidate.id;
            var _unit = _candidate.unit;
            var _unit_role = _unit.role();
            var _constitution_test_mod = _unit.hp() * -1;
            var _constitution_test = global.character_tester.standard_test(_unit, "constitution", _constitution_test_mod);

            if (unit_recovery_score > 0) {
                _unit.update_health(_constitution_test[1]);
                _column_id.marine_dead[_unit_id] = false;
                unit_recovery_score--;
                units_saved_count++;

                if (!struct_exists(obj_ncombat.units_saved_counts, _unit_role)) {
                    obj_ncombat.units_saved_counts[$ _unit_role] = 1;
                } else {
                    obj_ncombat.units_saved_counts[$ _unit_role]++;
                }
                continue;
            }

            if (_unit.base_group == "astartes") {
                if (!_unit.gene_seed_mutations[$ "membrane"]) {
                    var survival_mod = _unit.luck * -1;
                    survival_mod += _unit.hp() * -1;

                    var survival_test = global.character_tester.standard_test(_unit, "constitution", survival_mod);
                    if (survival_test[0]) {
                        _column_id.marine_dead[_unit_id] = false;
                        injured++;
                    }
                }
            }
        }
        ds_priority_destroy(marines_to_recover);

        while (!ds_priority_empty(vehicles_to_recover)) {
            var _candidate = ds_priority_delete_max(vehicles_to_recover);
            var _column_id = _candidate.column_id;
            var _vehicle_id = _candidate.id;
            var _vehicle_type = _column_id.veh_type[_vehicle_id];

            if (obj_controller.stc_bonus[3] == 4) {
                var _survival_roll = 70 + _candidate.priority;
                var _dice_roll = roll_dice(1, 100, "high");
                if ((_dice_roll >= _survival_roll) && (_column_id.veh_dead[_vehicle_id] != 2)) {
                    _column_id.veh_hp[_vehicle_id] = roll_dice(1, 10, "high");
                    _column_id.veh_dead[_vehicle_id] = false;
                    vehicles_saved_count++;

                    if (!struct_exists(obj_ncombat.vehicles_saved_counts, _vehicle_type)) {
                        obj_ncombat.vehicles_saved_counts[$ _vehicle_type] = 1;
                    } else {
                        obj_ncombat.vehicles_saved_counts[$ _vehicle_type]++;
                    }
                    continue;
                }
            }

            if (vehicle_recovery_score > 0) {
                _column_id.veh_hp[_vehicle_id] = roll_dice(1, 10, "high");
                _column_id.veh_dead[_vehicle_id] = false;
                vehicle_recovery_score -= _candidate.priority;
                vehicles_saved_count++;

                if (!struct_exists(obj_ncombat.vehicles_saved_counts, _vehicle_type)) {
                    obj_ncombat.vehicles_saved_counts[$ _vehicle_type] = 1;
                } else {
                    obj_ncombat.vehicles_saved_counts[$ _vehicle_type]++;
                }
            }
        }
        ds_priority_destroy(vehicles_to_recover);
    }

    with (obj_pnunit) {
        after_battle_part2();
    }

    var _total_deaths = final_marine_deaths + final_command_deaths;
    var _total_injured = _total_deaths + injured + units_saved_count;
    if (_total_injured > 0) {
        newline = $"{string_plural_count("unit", _total_injured)} {smart_verb("was", _total_injured)} critically injured.";
        newline_color = COL_RED;
        scr_newtext();

        if (units_saved_count > 0) {
            var _units_saved_string = "";
            var _unit_roles = struct_get_names(units_saved_counts);

            for (var i = 0; i < array_length(_unit_roles); i++) {
                var _unit_role = _unit_roles[i];
                var _saved_count = units_saved_counts[$ _unit_role];
                _units_saved_string += $"{string_plural_count(_unit_role, _saved_count)}";
                _units_saved_string += smart_delimeter_sign(_unit_roles, i, false);
            }

            newline = $"{units_saved_count}x {smart_verb("was", units_saved_count)} saved by the {string_plural(roles[eROLE.Apothecary], apothecaries_alive)}. ({_units_saved_string})";
            scr_newtext();
        }

        if (injured > 0) {
            newline = $"{injured}x survived thanks to the Sus-an Membrane.";
            newline_color = COL_RED;
            scr_newtext();
        }

        if (_total_deaths > 0) {
            var _units_lost_string = "";
            var _unit_roles = struct_get_names(units_lost_counts);
            for (var i = 0; i < array_length(_unit_roles); i++) {
                var _unit_role = _unit_roles[i];
                var _lost_count = units_lost_counts[$ _unit_role];
                _units_lost_string += $"{string_plural_count(_unit_role, _lost_count)}";
                _units_lost_string += smart_delimeter_sign(_unit_roles, i, false);
            }
            newline += $"{_total_deaths} units succumbed to their wounds! ({_units_lost_string})";
            newline_color = COL_RED;
            scr_newtext();
        }

        newline = " ";
        scr_newtext();
    }

    if (ground_mission) {
        if (apothecaries_alive < 0) {
            obj_ground_mission.apothecary_present = apothecaries_alive;
        }
    }

    if (seed_lost > 0) {
        if (obj_ini.doomed) {
            newline = $"Chapter mutation prevents retrieving gene-seed. {seed_lost} gene-seed lost.";
            scr_newtext();
        } else if (!apothecaries_alive) {
            newline = $"No able-bodied {roles[eROLE.Apothecary]}. {seed_lost} gene-seed lost.";
            scr_newtext();
        } else {
            seed_saved = min(seed_harvestable, apothecaries_alive * 40);
            newline = $"{seed_saved} gene-seed was recovered; {seed_lost - seed_harvestable} was lost due damage; {seed_harvestable - seed_saved} was left to rot;";
            scr_newtext();
        }

        if (seed_saved > 0) {
            obj_controller.gene_seed += seed_saved;
        }

        newline = " ";
        scr_newtext();
    }

    if (lost_to_black_rage > 0) {
        var voodoo = "";

        if (lost_to_black_rage == 1) {
            voodoo = "1 Battle Brother lost to the Black Rage.";
        } else {
            voodoo = string(lost_to_black_rage) + " Battle Brothers lost to the Black Rage.";
        }

        newline = voodoo;
        newline_color = COL_RED;
        scr_newtext();
        newline = " ";
        scr_newtext();
    }

    newline = " ";
    scr_newtext();

    var _total_damaged_count = vehicle_deaths + vehicles_saved_count;
    if (_total_damaged_count > 0) {
        newline = $"{string_plural_count("vehicle", _total_damaged_count)} {smart_verb("was", _total_damaged_count)} critically damaged during battle.";
        newline_color = COL_RED;
        scr_newtext();

        if (vehicles_saved_count > 0) {
            var _vehicles_saved_string = "";
            var _vehicle_types = struct_get_names(vehicles_saved_counts);

            for (var i = 0; i < array_length(_vehicle_types); i++) {
                var _vehicle_type = _vehicle_types[i];
                var _saved_count = vehicles_saved_counts[$ _vehicle_type];
                _vehicles_saved_string += $"{string_plural_count(_vehicle_type, _saved_count)}";
                _vehicles_saved_string += smart_delimeter_sign(_vehicle_types, i, false);
            }

            newline = $"{string_plural(roles[eROLE.Techmarine], techmarines_alive)} {smart_verb("was", techmarines_alive)} able to restore {vehicles_saved_count}. ({_vehicles_saved_string})";
            scr_newtext();
        }

        if (vehicle_deaths > 0) {
            var _vehicles_lost_string = "";
            var _vehicle_types = struct_get_names(vehicles_lost_counts);

            for (var i = 0; i < array_length(_vehicle_types); i++) {
                var _vehicle_type = _vehicle_types[i];
                var _lost_count = vehicles_lost_counts[$ _vehicle_type];
                _vehicles_lost_string += $"{string_plural_count(_vehicle_type, _lost_count)}";
                _vehicles_lost_string += smart_delimeter_sign(_vehicle_types, i, false);
            }

            newline += $"{vehicle_deaths} {smart_verb("was", vehicle_deaths)} lost forever. ({_vehicles_lost_string})";
            newline_color = COL_RED;
            scr_newtext();
        }

        newline = " ";
        scr_newtext();
    }

    if (post_equipment_lost[1] != "") {
        part6 = "Equipment Lost: ";

        part7 += arrays_to_string_with_counts(post_equipment_lost, post_equipments_lost, true, false);
        if (ground_mission) {
            part7 += " Some may be recoverable.";
        }
        newline = part6;
        scr_newtext();
        newline = part7;
        scr_newtext();
        newline = " ";
        scr_newtext();
    }

    if (total_battle_exp_gain > 0) {
        with (obj_pnunit) {
            assemble_alive_units();
        }
        average_battle_exp_gain = distribute_experience(end_alive_units, total_battle_exp_gain); // Due to cool alarm timer shitshow, I couldn't think of anything but to put it here.
        newline = $"Each marine gained {average_battle_exp_gain} experience, reduced by their total experience.";
        scr_newtext();

        var _upgraded_librarians_count = array_length(upgraded_librarians);
        if (_upgraded_librarians_count > 0) {
            for (var i = 0; i < _upgraded_librarians_count; i++) {
                if (i > 0) {
                    newline += ", ";
                }
                newline += $"{upgraded_librarians[i].name_role()}";
            }
            newline += " learned new psychic powers after gaining enough experience.";
            scr_newtext();
        }

        newline = " ";
        scr_newtext();
    }

    if (ground_mission) {
        obj_ground_mission.post_equipment_lost = post_equipment_lost;
        obj_ground_mission.post_equipments_lost = post_equipments_lost;
    }

    if (slime > 0) {
        var slime_string = $"Faulty Mucranoid and other afflictions have caused damage to the equipment. {slime} Forge Points will be allocated for repairs.";
        newline = slime_string;
        newline_color = COL_RED;
        scr_newtext();

        newline = " ";
        scr_newtext();
    }

    instance_activate_object(obj_star);

    var reduce_fortification = true;
    if (battle_special == "tyranid_org") {
        reduce_fortification = false;
    }
    if (string_count("_attack", battle_special) > 0) {
        reduce_fortification = false;
    }
    if (battle_special == "ship_demon") {
        reduce_fortification = false;
    }
    if (enemy + threat == 17) {
        reduce_fortification = false;
    }
    if (battle_special == "ruins") {
        reduce_fortification = false;
    }
    if (battle_special == "ruins_eldar") {
        reduce_fortification = false;
    }
    if (battle_special == "fallen1") {
        reduce_fortification = false;
    }
    if (battle_special == "fallen2") {
        reduce_fortification = false;
    }
    if (battle_special == "study2a") {
        reduce_fortification = false;
    }
    if (battle_special == "study2b") {
        reduce_fortification = false;
    }

    if ((fortified > 0) && (!instance_exists(obj_nfort)) && (reduce_fortification == true)) {
        part9 = "Fortification level of " + string(battle_loc);
        if (battle_id == 1) {
            part9 += " I";
        }
        if (battle_id == 2) {
            part9 += " II";
        }
        if (battle_id == 3) {
            part9 += " III";
        }
        if (battle_id == 4) {
            part9 += " IV";
        }
        if (battle_id == 5) {
            part9 += " V";
        }
        part9 += $" has decreased to {fortified - 1} ({fortified}-1)";
        newline = part9;
        scr_newtext();
        battle_object.p_fortified[battle_id] -= 1;
    }


    if ((defeat == 0) && (battle_special == "space_hulk")) {
        var enemy_power = 0, loot = 0, dicey = floor(random(100)) + 1, ex = 0;

        if (enemy == 7) {
            enemy_power = battle_object.p_orks[battle_id];
            battle_object.p_orks[battle_id] -= 1;
        } else if (enemy == 9) {
            enemy_power = battle_object.p_tyranids[battle_id];
            battle_object.p_tyranids[battle_id] -= 1;
        } else if (enemy == 10) {
            enemy_power = battle_object.p_traitors[battle_id];
            battle_object.p_traitors[battle_id] -= 1;
        }

        part10 = "Space Hulk Exploration at ";
        ex = min(100, 100 - ((enemy_power - 1) * 20));
        part10 += string(ex) + "%";
        newline = part10;
        if (ex == 100) {
            newline_color = COL_RED;
        }
        scr_newtext();

        if (scr_has_disadv("Shitty Luck")) {
            dicey = dicey * 1.5;
        }
        // show_message("Roll Under: "+string(enemy_power*10)+", Roll: "+string(dicey));

        if (dicey <= (enemy_power * 10)) {
            loot = choose(1, 2, 3, 4);
            if (enemy != 10) {
                loot = choose(1, 1, 2, 3);
            }
            hulk_treasure = loot;
            if (loot > 1) {
                newline = "Valuable items recovered.";
            }
            if (loot == 1) {
                newline = "Resources have been recovered.";
            }
            newline_color = COL_YELLOW;
            scr_newtext();
        }
    }

    if (string_count("ruins", battle_special) > 0) {
        if (defeat == 0) {
            newline = "Ancient Ruins cleared.";
        }
        if (defeat == 1) {
            newline = "Failed to clear Ancient Ruins.";
        }
        newline_color = COL_YELLOW;
        scr_newtext();
    }

    var reduce_power = true;
    if (battle_special == "tyranid_org") {
        reduce_power = false;
    }
    if (battle_special == "ship_demon") {
        reduce_power = false;
    }
    if (string_count("_attack", battle_special) > 0) {
        reduce_power = false;
    }
    if (string_count("ruins", battle_special) > 0) {
        reduce_power = false;
    }
    if (battle_special == "space_hulk") {
        reduce_power = false;
    }
    if (battle_special == "fallen1") {
        reduce_power = false;
    }
    if (battle_special == "fallen2") {
        reduce_power = false;
    }
    if (battle_special == "study2a") {
        reduce_power = false;
    }
    if (battle_special == "study2b") {
        reduce_power = false;
    }
    if ((defeat == 0) && (reduce_power == true)) {
        var enemy_power, new_power, power_reduction, final_pow, requisition_reward;
        enemy_power = 0;
        new_power = 0;
        power_reduction = 0;
        requisition_reward = 0;

        if (enemy == 2) {
            enemy_power = battle_object.p_guardsmen[battle_id];
            battle_object.p_guardsmen[battle_id] -= threat;
            // if (threat=1) or (threat=2) then battle_object.p_guardsmen[battle_id]=0;
        }

        if (enemy == 5) {
            enemy_power = battle_object.p_sisters[battle_id];
            part10 = "Ecclesiarchy";
        } else if (enemy == 6) {
            enemy_power = battle_object.p_eldar[battle_id];
            part10 = "Eldar";
        } else if (enemy == 7) {
            enemy_power = battle_object.p_orks[battle_id];
            part10 = "Ork";
        } else if (enemy == 8) {
            enemy_power = battle_object.p_tau[battle_id];
            part10 = "Tau";
        } else if (enemy == 9) {
            enemy_power = battle_object.p_tyranids[battle_id];
            part10 = "Tyranid";
        } else if (enemy == 10) {
            enemy_power = battle_object.p_traitors[battle_id];
            part10 = "Heretic";
            if (threat == 7) {
                part10 = "Daemon";
            }
        } else if (enemy == 11) {
            enemy_power = battle_object.p_chaos[battle_id];
            part10 = "Chaos Space Marine";
        } else if (enemy == 13) {
            enemy_power = battle_object.p_necrons[battle_id];
            part10 = "Necrons";
        }

        if (instance_exists(battle_object) && (enemy_power > 2)) {
            if (awake_tomb_world(battle_object.p_feature[battle_id]) != 0) {
                scr_gov_disp(battle_object.name, battle_id, floor(enemy_power / 2));
            }
        }

        if (enemy != 2) {
            if (dropping == true || defending == true) {
                power_reduction = 1;
            } else {
                power_reduction = 2;
            }
            new_power = enemy_power - power_reduction;
            new_power = max(new_power, 0);

            // Give some money for killing enemies?
            var _quad_factor = 6;
            requisition_reward = _quad_factor * sqr(threat);
            obj_controller.requisition += requisition_reward;

            //(¿?) Ramps up threat/enemy presence in case enemy Type == "Daemon" (¿?)
            //Does the inverse check/var assignment 10 lines above
            if (part10 == "Daemon") {
                new_power = 7;
            }
            if ((enemy == 9) && (new_power == 0)) {
                var battle_planet = battle_id;
                with (battle_object) {
                    var who_cleansed = "Tyranids";
                    var who_return = "";
                    var make_alert = true;
                    var planet_string = $"{name} {scr_roman(battle_planet)}";
                    if (planet_feature_bool(p_feature[battle_planet], P_features.Gene_Stealer_Cult) == 1) {
                        who_cleansed = "Gene Stealer Cult";
                        make_alert = true;
                        delete_features(p_feature[battle_planet], P_features.Gene_Stealer_Cult);
                        adjust_influence(eFACTION.Tyranids, -25, battle_planet);
                    }
                    if (make_alert) {
                        if (p_first[battle_planet] == 1) {
                            who_return = "your";
                            p_owner[battle_planet] = eFACTION.Player;
                        } else if (p_first[battle_planet] == 3 || p_type[battle_planet] == "Forge") {
                            who_return = "mechanicus";
                            obj_controller.disposition[3] += 10;
                            p_owner[battle_planet] = eFACTION.Mechanicus;
                        } else if (p_type[battle_planet] != "Dead") {
                            who_return = "the governor";
                            if (who_cleansed == "tau") {
                                who_return = "a more suitable governer";
                            }
                            p_owner[battle_planet] = eFACTION.Imperium;
                        }
                        dispo[battle_planet] += 10;
                        scr_event_log("", $"{who_cleansed} cleansed from {planet_string}", name);
                        scr_alert("green", "owner", $"{who_cleansed} cleansed from {planet_string}. Control returned to {who_return}", x, y);
                        if (dispo[battle_planet] >= 101) {
                            p_owner[battle_planet] = 1;
                        }
                    }
                }
            }
            if ((enemy == 11) && (enemy_power != floor(enemy_power))) {
                enemy_power = floor(enemy_power);
            }
        }

        if ((obj_controller.blood_debt == 1) && (defeat == 0) && enemy_power > 0) {
            final_pow = min(enemy_power, 6) - 1;
            if ((enemy == 6) || (enemy == 9) || (enemy == 11) || (enemy == 13)) {
                obj_controller.penitent_turn = 0;
                obj_controller.penitent_turnly = 0;
                var penitent_crusade_chart = [25, 62, 95, 190, 375, 750];

                final_pow = min(enemy_power, 6) - 1;
                obj_controller.penitent_current += penitent_crusade_chart[final_pow];
            } else if ((enemy == 7) || (enemy == 8) || (enemy == 10)) {
                obj_controller.penitent_turn = 0;
                obj_controller.penitent_turnly = 0;
                final_pow = min(enemy_power, 7) - 1;
                var penitent_crusade_chart = [25, 50, 75, 150, 300, 600, 1500];
                obj_controller.penitent_current += penitent_crusade_chart[final_pow];
            }
        }

        if (enemy == 5) {
            battle_object.p_sisters[battle_id] = new_power;
        } else if (enemy == 6) {
            battle_object.p_eldar[battle_id] = new_power;
        } else if (enemy == 7) {
            battle_object.p_orks[battle_id] = new_power;
        } else if (enemy == 8) {
            battle_object.p_tau[battle_id] = new_power;
        } else if (enemy == 9) {
            battle_object.p_tyranids[battle_id] = new_power;
        } else if (enemy == 10) {
            battle_object.p_traitors[battle_id] = new_power;
        } else if (enemy == 11) {
            battle_object.p_chaos[battle_id] = new_power;
        } else if (enemy == 13) {
            battle_object.p_necrons[battle_id] = new_power;
        }

        if ((enemy != 2) && (string_count("cs_meeting_battle", battle_special) == 0)) {
            part10 += " forces on " + string(battle_loc);
            if (battle_id == 1) {
                part10 += " I";
            }
            if (battle_id == 2) {
                part10 += " II";
            }
            if (battle_id == 3) {
                part10 += " III";
            }
            if (battle_id == 4) {
                part10 += " IV";
            }
            if (battle_id == 5) {
                part10 += " V";
            }
            if (new_power == 0) {
                part10 += $" were completely wiped out. Previous power: {enemy_power}. Reduction: {power_reduction}.";
            } else {
                part10 += $" were reduced to {new_power} after this battle. Previous power: {enemy_power}. Reduction: {power_reduction}.";
            }
            newline = part10;
            scr_newtext();
            part10 = $"Received {requisition_reward} requisition points as a reward for slaying enemies of the Imperium.";
            newline = part10;
            scr_newtext();

            if ((new_power <= 0) && (enemy_power > 0)) {
                battle_object.p_raided[battle_id] = 1;
            }
        }
        if (enemy == 2) {
            part10 += " Imperial Guard Forces on " + string(battle_loc);
            if (battle_id == 1) {
                part10 += " I";
            }
            if (battle_id == 2) {
                part10 += " II";
            }
            if (battle_id == 3) {
                part10 += " III";
            }
            if (battle_id == 4) {
                part10 += " IV";
            }
            if (battle_id == 5) {
                part10 += " V";
            }
            part10 += " were reduced to " + string(battle_object.p_guardsmen[battle_id]) + " (" + string(enemy_power) + "-" + string(threat) + ")";
            newline = part10;
            scr_newtext();
        }

        if ((enemy == 8) && (ethereal > 0) && (defeat == 0)) {
            newline = "Tau Ethereal Captured";
            newline_color = COL_YELLOW;
            scr_newtext();
        }

        if ((enemy == 13) && (battle_object.p_necrons[battle_id] < 3) && (awake_tomb_world(battle_object.p_feature[battle_id]) == 1)) {
            // var bombs;bombs=scr_check_equip("Plasma Bomb",battle_loc,battle_id,0);
            // var bombs;bombs=scr_check_equip("Plasma Bomb","","",0);

            // show_message(string(bombs));

            if (plasma_bomb > 0) {
                // scr_check_equip("Plasma Bomb",battle_loc,battle_id,1);
                // scr_check_equip("Plasma Bomb","","",1);
                newline = "Plasma Bomb used to seal the Necron Tomb.";
                newline_color = COL_YELLOW;
                scr_newtext();
                seal_tomb_world(battle_object.p_feature[battle_id]);
            }

            if (plasma_bomb <= 0) {
                battle_object.p_necrons[battle_id] = 3; // newline_color=COL_YELLOW;
                if (dropping != 0) {
                    newline = "Deep Strike Ineffective; Plasma Bomb required";
                }
                if (dropping == 0) {
                    newline = "Attack Ineffective; Plasma Bomb required";
                }
                scr_newtext();
            }

            // popup here
            /*
        var pip;
        pip=instance_create(0,0,obj_popup);
        pip.title="Necron Tombs";
        pip.text="The Necrons have been defeated on the surface, but remain able to replenish their numbers and recuperate.  Do you wish to advance your army into the tunnels?";
        pip.image="necron_tunnels_1";
        pip.cooldown=15;
        cooldown=15;

        pip.option1="Advance!";
        pip.option2="Cancel the attack";*/
        }

        /*if (enemy=13) and (new_power<=0) and (dropping=0){
        var bombs;bombs=scr_check_equip("Plasma Bomb",battle_loc,battle_id,0);
        if (bombs>0){
            scr_check_equip("Plasma Bomb",battle_loc,battle_id,1);
            newline="Plasma Bomb used to seal the Necron Tomb.";newline_color=COL_YELLOW;scr_newtext();
            if (battle_object.p_feature[battle_id]="Awakened Necron Tomb") then battle_object.p_feature[battle_id]="Necron Tomb";
        }
    }*/
    }

    if ((defeat == 0) && (enemy == 9) && (battle_special == "tyranid_org")) {
        // show_message(string(captured_gaunt));
        if (captured_gaunt == 1) {
            newline = captured_gaunt + " Gaunt organism have been captured.";
        }
        if ((captured_gaunt > 1) || (captured_gaunt == 0)) {
            newline = captured_gaunt + " Gaunt organisms have been captured.";
        }
        scr_newtext();

        if (captured_gaunt > 0) {
            var why, thatta;
            why = 0;
            thatta = 0;
            instance_activate_object(obj_star);
            // with(obj_star){if (name!=obj_ncombat.battle_loc) then instance_deactivate_object(id);}
            // thatta=obj_star;

            with (obj_star) {
                remove_star_problem("tyranid_org");
            }
        }

        scr_event_log("", "Inquisition Mission Completed: A Gaunt organism has been captured for the Inquisition.");

        if (captured_gaunt > 1) {
            if (instance_exists(obj_turn_end)) {
                scr_popup("Inquisition Mission Completed", "You have captured several Gaunt organisms.  The Inquisitor is pleased with your work, though she notes that only one is needed- the rest are to be purged.  It will be stored until it may be retrieved.  The mission is a success.", "inquisition", "");
            }
        }
        if (captured_gaunt == 1) {
            if (instance_exists(obj_turn_end)) {
                scr_popup("Inquisition Mission Completed", "You have captured a Gaunt organism- the Inquisitor is pleased with your work.  The Tyranid will be stored until it may be retrieved.  The mission is a success.", "inquisition", "");
            }
        }
        instance_deactivate_object(obj_star);
    }

    newline = line_break;
    scr_newtext();
    newline = line_break;
    scr_newtext();

    if ((leader || ((battle_special == "world_eaters") && (!obj_controller.faction_defeated[10]))) && (!defeat)) {
        var nep;
        nep = false;
        newline = "The enemy Leader has been killed!";
        newline_color = COL_YELLOW;
        scr_newtext();
        newline = line_break;
        scr_newtext();
        newline = line_break;
        scr_newtext();
        instance_activate_object(obj_event_log);
        if (enemy == 5) {
            scr_event_log("", "Enemy Leader Assassinated: Ecclesiarchy Prioress");
        }
        if (enemy == 6) {
            scr_event_log("", "Enemy Leader Assassinated: Eldar Farseer");
        }
        if (enemy == 7) {
            scr_event_log("", "Enemy Leader Assassinated: Ork Warboss");
            if (Warlord != 0) {
                with (Warlord) {
                    kill_warboss();
                }
            }
        }
        if (enemy == 8) {
            scr_event_log("", "Enemy Leader Assassinated: Tau Diplomat");
        }
        if (enemy == 10) {
            scr_event_log("", "Enemy Leader Assassinated: Chaos Lord");
        }
    }

    var endline, inq_eated;
    endline = 1;
    inq_eated = false;

    if (obj_ini.omophagea) {
        var eatme = floor(random(100)) + 1;
        if ((enemy == 13) || (enemy == 9) || (battle_special == "ship_demon")) {
            eatme += 100;
        }
        if ((enemy == 10) && (battle_object.p_traitors[battle_id] == 7)) {
            eatme += 200;
        }

        eatme -= lost_to_black_rage * 6;

        if (scr_has_disadv("Shitty Luck")) {
            eatme -= 10;
        }

        if (allies > 0) {
            obj_controller.disposition[2] -= choose(1, 0, 0);
            obj_controller.disposition[4] -= choose(0, 0, 1);
            obj_controller.disposition[5] -= choose(0, 0, 1);
        }
        if (present_inquisitor > 0) {
            obj_controller.disposition[4] -= 2;
        }

        if (eatme <= 25) {
            endline = 0;
            if (lost_to_black_rage == 0) {
                var ran;
                ran = choose(1, 2);
                newline = "One of your marines slowly makes his way towards the fallen enemies, as if in a spell.  Once close enough the helmet is removed and he begins shoveling parts of their carcasses into his mouth.";
                newline = "Two marines are sharing a quick discussion, and analysis of the battle, when one of the two suddenly drops down and begins shoveling parts of enemy corpses into his mouth.";
                newline += choose("  Bone snaps and pops.", "  Strange-colored blood squirts from between his teeth.", "  Veins and tendons squish wetly.");
            }
            if (lost_to_black_rage > 0) {
                var ran = choose(1, 2);
                newline = "One of your Death Company marines slowly makes his way towards the fallen enemies, as if in a spell.  Once close enough the helmet is removed and he begins shoveling parts of their carcasses into his mouth.";
                newline = "A marine is observing and communicating with a Death Company marine, to ensure they are responsive, when that Death Company marine drops down and suddenly begins shoveling parts of enemy corpses into his mouth.";
                newline += choose("  Bone snaps and pops.", "  Strange-colored blood squirts from between his teeth.", "  Veins and tendons squish wetly.");
            }
            // if (really_thirsty > 0) {
            //     newline = $"One of your Death Company {roles[6]} blitzes to the fallen enemy lines.  Massive mechanical hands begin to rend and smash at the fallen corpses, trying to squeeze their flesh and blood through the sarcophogi opening.";
            // }

            newline += "  Almost at once most of the present " + string(global.chapter_name) + " follow suite, joining in and starting a massive feeding frenzy.  The sight is gruesome to behold.";
            scr_newtext();

            // check for pdf/guardsmen
            eatme = floor(random(100)) + 1;
            if (scr_has_disadv("Shitty Luck")) {
                eatme -= 10;
            }
            if ((eatme <= 10) && (allies > 0)) {
                obj_controller.disposition[2] -= 2;
                if (allies == 1) {
                    newline = "Local PDF have been eaten!";
                    newline_color = COL_RED;
                    scr_newtext();
                } else if (allies == 2) {
                    newline = "Local Guardsmen have been eaten!";
                    newline_color = COL_RED;
                    scr_newtext();
                }
            }

            // check for inquisitor
            eatme = floor(random(100)) + 1;
            if (scr_has_disadv("Shitty Luck")) {
                eatme -= 5;
            }
            if ((eatme <= 40) && (present_inquisitor == 1)) {
                var thatta = 0, remove = 0, i = 0;
                obj_controller.disposition[4] -= 10;
                inq_eated = true;
                instance_activate_object(obj_en_fleet);

                if (instance_exists(inquisitor_ship)) {
                    repeat (2) {
                        scr_loyalty("Inquisitor Killer", "+");
                    }
                    if (obj_controller.loyalty >= 85) {
                        obj_controller.last_world_inspection -= 44;
                    }
                    if ((obj_controller.loyalty >= 70) && (obj_controller.loyalty < 85)) {
                        obj_controller.last_world_inspection -= 32;
                    }
                    if ((obj_controller.loyalty >= 50) && (obj_controller.loyalty < 70)) {
                        obj_controller.last_world_inspection -= 20;
                    }
                    if (obj_controller.loyalty < 50) {
                        scr_loyalty("Inquisitor Killer", "+");
                    }

                    var msg = "", msg2 = "", i = 0, remove = 0;
                    // if (string_count("Inqis",inquisitor_ship.trade_goods)>0) then show_message("B");
                    if (inquisitor_ship.inquisitor > 0) {
                        var inquis_name = obj_controller.inquisitor[inquisitor_ship.inquisitor];
                        newline = $"Inquisitor {inquis_name} has been eaten!";
                        msg = $"Inquisitor {inquis_name}";
                        remove = obj_controller.inquisitor[inquisitor_ship.inquisitor];
                        scr_event_log("red", $"Your Astartes consume {msg}.");
                    }
                    newline_color = COL_RED;
                    scr_newtext();
                    if (obj_controller.inquisitor_type[remove] == "Ordo Hereticus") {
                        scr_loyalty("Inquisitor Killer", "+");
                    }

                    i = remove;
                    repeat (10 - remove) {
                        if (i < 10) {
                            obj_controller.inquisitor_gender[i] = obj_controller.inquisitor_gender[i + 1];
                            obj_controller.inquisitor_type[i] = obj_controller.inquisitor_type[i + 1];
                            obj_controller.inquisitor[i] = obj_controller.inquisitor[i + 1];
                        }
                        if (i == 10) {
                            obj_controller.inquisitor_gender[i] = choose(0, 0, 0, 1, 1, 1, 1); // 4:3 chance of male Inquisitor
                            obj_controller.inquisitor_type[i] = choose("Ordo Malleus", "Ordo Xenos", "Ordo Hereticus", "Ordo Hereticus", "Ordo Hereticus", "Ordo Hereticus", "Ordo Hereticus", "Ordo Hereticus");
                            obj_controller.inquisitor[i] = global.name_generator.generate_imperial_name(obj_controller.inquisitor_gender[i]); // For 'random inquisitor wishes to inspect your fleet
                        }
                        i += 1;
                    }

                    instance_activate_object(obj_turn_end);
                    if (obj_controller.known[eFACTION.Inquisition] < 3) {
                        scr_event_log("red", "EXCOMMUNICATUS TRAITORUS");
                        obj_controller.alarm[8] = 1;
                        if (!instance_exists(obj_turn_end)) {
                            var pip = instance_create(0, 0, obj_popup);
                            pip.title = "Inquisitor Killed";
                            pip.text = msg;
                            pip.image = "inquisition";
                            pip.cooldown = 30;
                            pip.title = "EXCOMMUNICATUS TRAITORUS";
                            pip.text = $"The Inquisition has noticed your uncalled CONSUMPTION of {msg} and declared your chapter Excommunicatus Traitorus.";
                            instance_deactivate_object(obj_popup);
                        } else {
                            scr_popup("Inquisitor Killed", $"The Inquisition has noticed your uncalled CONSUMPTION of {msg} and declared your chapter Excommunicatus Traitorus.", "inquisition", "");
                        }
                    }
                    instance_deactivate_object(obj_turn_end);

                    with (inquisitor_ship) {
                        instance_destroy();
                    }
                    with (obj_ground_mission) {
                        instance_destroy();
                    }
                }
                instance_deactivate_object(obj_star);
                instance_deactivate_object(obj_en_fleet);
            }
        }
    }

    if ((inq_eated == false) && (obj_ncombat.sorcery_seen >= 2)) {
        scr_loyalty("Use of Sorcery", "+");
        newline = "Inquisitor " + string(obj_controller.inquisitor[1]) + " witnessed your Chapter using sorcery.";
        scr_event_log("green", string(newline));
        scr_newtext();
    }

    if ((exterminatus > 0) && (dropping != 0)) {
        newline = "Exterminatus has been succesfully placed.";
        newline_color = COL_YELLOW;
        endline = 0;
        scr_newtext();
    }

    instance_activate_object(obj_star);
    instance_activate_object(obj_turn_end);

    //If not fleet based and...
    if ((obj_ini.fleet_type != ePlayerBase.home_world) && (defeat == 1) && (dropping == 0)) {
        var monastery_list = search_planet_features(battle_object.p_feature[obj_ncombat.battle_id], P_features.Monastery);
        var monastery_count = array_length(monastery_list);
        if (monastery_count > 0) {
            for (var mon = 0; mon < monastery_count; mon++) {
                battle_object.p_feature[obj_ncombat.battle_id][monastery_list[mon]].status = "destroyed";
            }

            if (obj_controller.und_gene_vaults == 0) {
                newline = "Your Fortress Monastery has been raided.  " + string(obj_controller.gene_seed) + " Gene-Seed has been destroyed or stolen.";
            }
            if (obj_controller.und_gene_vaults > 0) {
                newline = "Your Fortress Monastery has been raided.  " + string(floor(obj_controller.gene_seed / 10)) + " Gene-Seed has been destroyed or stolen.";
            }

            scr_event_log("red", newline, battle_object.name);
            instance_activate_object(obj_event_log);
            newline_color = COL_RED;
            scr_newtext();

            var lasers_lost, defenses_lost, silos_lost;
            lasers_lost = 0;
            defenses_lost = 0;
            silos_lost = 0;

            if (player_defenses > 0) {
                defenses_lost = round(player_defenses * 0.75);
            }
            if (battle_object.p_silo[obj_ncombat.battle_id] > 0) {
                silos_lost = round(battle_object.p_silo[obj_ncombat.battle_id] * 0.75);
            }
            if (battle_object.p_lasers[obj_ncombat.battle_id] > 0) {
                lasers_lost = round(battle_object.p_lasers[obj_ncombat.battle_id] * 0.75);
            }

            if (player_defenses < 30) {
                defenses_lost = player_defenses;
            }
            if (battle_object.p_silo[obj_ncombat.battle_id] < 30) {
                silos_lost = battle_object.p_silo[obj_ncombat.battle_id];
            }
            if (battle_object.p_lasers[obj_ncombat.battle_id] < 8) {
                lasers_lost = battle_object.p_lasers[obj_ncombat.battle_id];
            }

            var percent;
            percent = 0;
            newline = "";
            if (defenses_lost > 0) {
                percent = round((defenses_lost / player_defenses) * 100);
                newline = string(defenses_lost) + " Weapon Emplacements have been lost (" + string(percent) + "%).";
            }
            if (silos_lost > 0) {
                percent = round((silos_lost / battle_object.p_silo[obj_ncombat.battle_id]) * 100);
                if (defenses_lost > 0) {
                    newline += "  ";
                }
                newline += string(silos_lost) + $" Missile Silos have been lost ({percent}%).";
            }
            if (lasers_lost > 0) {
                percent = round((lasers_lost / battle_object.p_lasers[obj_ncombat.battle_id]) * 100);
                if ((silos_lost > 0) || (defenses_lost > 0)) {
                    newline += "  ";
                }
                newline += string(lasers_lost) + " Defense Lasers have been lost (" + string(percent) + "%).";
            }

            battle_object.p_defenses[obj_ncombat.battle_id] -= defenses_lost;
            battle_object.p_silo[obj_ncombat.battle_id] -= silos_lost;
            battle_object.p_lasers[obj_ncombat.battle_id] -= lasers_lost;
            if (defenses_lost + silos_lost + lasers_lost > 0) {
                newline_color = COL_RED;
                scr_newtext();
            }

            endline = 0;

            if (obj_controller.und_gene_vaults == 0) {
                //all Gene Pod Incubators and gene seed are lost
                destroy_all_gene_slaves(false);
            }
            if (obj_controller.und_gene_vaults > 0) {
                obj_controller.gene_seed -= floor(obj_controller.gene_seed / 10);
            }
        }
    }
    instance_deactivate_object(obj_star);
    instance_deactivate_object(obj_turn_end);

    if (endline == 0) {
        newline = line_break;
        scr_newtext();
        newline = line_break;
        scr_newtext();
    }

    if (defeat == 1) {
        player_forces = 0;
        if (ground_mission) {
            obj_ground_mission.recoverable_gene_seed = seed_lost;
        }
    }

    gene_slaves = [];

    instance_deactivate_object(obj_star);
    instance_deactivate_object(obj_ground_mission);

    /* */
    /*  */
}

// alarm_7
/// @mixin
function ncombat_special_end() {
    try {
        // show_debug_message("alarm 7 start");
        audio_stop_sound(snd_battle);
        audio_play_sound(snd_royal, 0, true);
        audio_sound_gain(snd_royal, 0, 0);
        var nope = 0;
        if ((obj_controller.master_volume == 0) || (obj_controller.music_volume == 0)) {
            nope = 1;
        }
        if (nope != 1) {
            audio_sound_gain(snd_royal, 0.25 * obj_controller.master_volume * obj_controller.music_volume, 2000);
        }
    
        // scr_dead_marines(1);
    
        // Execute the cleaning scripts
        // Check for any more battles
    
        obj_controller.cooldown = 10;
    
        log_message($"Ground Combat - {defeat ? "Defeat" : "Victory"}Victory - Enemy:{enemy} ({battle_special})");
    
        // If battling own dudes, then remove the loyalists after the fact
    
        if (enemy == 1) {
            var j = -1;
            var cleann = array_create(11, false);
            with (obj_enunit) {
                var q = 0;
                repeat (700) {
                    q += 1;
                    if (dude_id[q] > 0) {
                        var commandy = false;
                        var nco = dude_co[q];
                        var nid = dude_id[q];
                        cleann[nco] = true;
    
                        // show_message("dude ID:"+string(q)+" ("+string(obj_ini.name[nco,nid])+") is being removed from the array");
    
                        commandy = is_specialist(obj_ini.role[nco, nid]);
                        if (commandy == true) {
                            obj_controller.command -= 1;
                        }
                        if (commandy == false) {
                            obj_controller.marines -= 1;
                        }
    
                        obj_ncombat.world_size += scr_unit_size(obj_ini.armour[nco][nid], obj_ini.role[nco][nid], true, obj_ini.mobi[nco][nid]);
    
                        var recover = !obj_ncombat.defeat;
                        kill_and_recover(nco, nid, recover, recover);
                    }
                }
            }
    
            for (j = 0; j <= 10; j++) {
                if (cleann[j]) {
                    with (obj_ini) {
                        scr_company_order(j);
                    }
                }
            }
        }
        if (string_count("cs_meeting", battle_special) > 0) {
            with (obj_temp_meeting) {
                instance_destroy();
            }
    
            with (obj_star) {
                if (name == obj_ncombat.battle_loc) {
                    instance_create(x, y, obj_temp_meeting);
                    var i = 0, ii = 0, otm, good = 0, master_present = 0;
                    var run = 0, s = 0, chaos_meeting = 0;
    
                    var master_index = array_get_index(obj_ini.role[0], "Chapter Master");
                    chaos_meeting = fetch_unit([0, master_index]).planet_location;
    
                    // show_message("meeting planet:"+string(chaos_meeting));
                    for (var co = 0; co <= 10; co++) {
                        for (var i = 0; i < array_length(obj_ini.TTRPG[co]); i++) {
                            good = 0;
                            unit = fetch_unit([co, i]);
                            if (unit.role() == "" || obj_ini.loc[co][i] != name) {
                                continue;
                            }
                            if (unit.planet_location == floor(chaos_meeting)) {
                                good += 1;
                            }
                            if ((obj_ini.role[co][i] != obj_ini.role[100][6]) && (obj_ini.role[co][i] != "Venerable " + string(obj_ini.role[100][6]))) {
                                good += 1;
                            }
                            if ((string_count("Dread", obj_ini.armour[co][i]) == 0) || (obj_ini.role[co][i] == "Chapter Master")) {
                                good += 1;
                            }
    
                            // if (good>=3) then show_message(string(obj_ini.role[co][i])+": "+string(co)+"."+string(i));
    
                            if (good >= 3) {
                                obj_temp_meeting.dudes += 1;
                                otm = obj_temp_meeting.dudes;
                                obj_temp_meeting.present[otm] = 1;
                                obj_temp_meeting.co[otm] = co;
                                obj_temp_meeting.ide[otm] = i;
                                if (obj_ini.role[co][i] == "Chapter Master") {
                                    master_present = 1;
                                }
                            }
                        }
                    }
                    // show_message("obj_temp_meeting.dudes:"+string(obj_temp_meeting.dudes));
                }
            }
        }
    
        that = array_get_index(post_equipment_lost, "Company Standard");
        if (that != -1) {
            repeat (post_equipments_lost[that]) {
                scr_loyalty("Lost Standard", "+");
            }
        }
    
        if (battle_special == "ruins" || battle_special == "ruins_eldar") {
            obj_ground_mission.defeat = defeat;
            obj_ground_mission.explore_feature.ruins_combat_end();
        } else if ((battle_special == "WL10_reveal") || (battle_special == "WL10_later")) {
            var moar, ox, oy;
            with (obj_temp8) {
                instance_destroy();
            }
    
            if (chaos_angry >= 5) {
                if (string_count("|CPF|", obj_controller.useful_info) == 0) {
                    obj_controller.useful_info += "|CPF|";
                }
            }
    
            if (battle_special == "WL10_reveal") {
                instance_create(battle_object.x, battle_object.y, obj_temp8);
                ox = battle_object.x;
                oy = battle_object.y; // battle_object.owner = eFACTION.Chaos;
                battle_object.p_traitors[battle_id] = 6;
                battle_object.p_chaos[battle_id] = 4;
                battle_object.p_pdf[battle_id] = 0;
                battle_object.p_owner[battle_id] = 10;
    
                var corro;
                corro = 0;
    
                repeat (100) {
                    var ii;
                    ii = 0;
                    if (corro <= 5) {
                        moar = instance_nearest(ox, oy, obj_star);
    
                        if (moar.owner <= 3) {
                            corro += 1;
                            repeat (4) {
                                ii += 1;
                                if (moar.p_owner[ii] <= 3) {
                                    moar.p_heresy[ii] = min(100, moar.p_heresy[ii] + floor(random_range(30, 50)));
                                }
                            }
                        }
                        moar.y -= 20000;
                    }
                }
                with (obj_star) {
                    if (y < -12000) {
                        y += 20000;
                    }
                }
    
                if (battle_object.present_fleet[2] > 0) {
                    with (obj_en_fleet) {
                        if ((navy == 0) && (owner == eFACTION.Imperium) && (point_distance(x, y, obj_temp8.x, obj_temp8.y) < 40)) {
                            owner = eFACTION.Chaos;
                            sprite_index = spr_fleet_chaos;
                            if (image_index <= 2) {
                                escort_number += 3;
                                frigate_number += 1;
                            }
                            if (capital_number == 0) {
                                capital_number += 1;
                            }
                        }
                    }
                    battle_object.present_fleet[2] -= 1;
                    battle_object.present_fleet[10] += 1;
                }
                with (obj_temp8) {
                    instance_destroy();
                }
            }
    
            if ((defeat == 1) && (battle_special == "WL10_reveal")) {
                obj_controller.audience = 10;
                obj_controller.menu = 20;
                obj_controller.diplomacy = 10;
                obj_controller.known[eFACTION.Chaos] = 2;
                with (obj_controller) {
                    scr_dialogue("intro2");
                }
            }
            if (defeat == 0) {
                obj_controller.known[eFACTION.Chaos] = 2;
                obj_controller.faction_defeated[10] = 1;
    
                if (instance_exists(obj_turn_end)) {
                    scr_event_log("", "Enemy Leader Assassinated: Chaos Lord");
                    scr_alert("", "ass", "Chaos Lord " + string(obj_controller.faction_leader[eFACTION.Chaos]) + " has been killed.", 0, 0);
                    scr_popup("Chaos Lord Killed", "Chaos Lord " + string(obj_controller.faction_leader[eFACTION.Chaos]) + " has been slain in combat.  Without his leadership the various forces of Chaos in the sector will crumble apart and disintegrate from infighting.  Sector " + string(obj_ini.sector_name) + " is no longer as threatened by the forces of Chaos.", "", "");
                }
                if (!instance_exists(obj_turn_end)) {
                    scr_event_log("", "Enemy Leader Assassinated: Chaos Lord");
                    var pop = instance_create(0, 0, obj_popup);
                    pop.image = "";
                    pop.title = "Chaos Lord Killed";
                    pop.text = "Chaos Lord " + string(obj_controller.faction_leader[eFACTION.Chaos]) + " has been slain in combat.  Without his leadership the various forces of Chaos in the sector will crumble apart and disintegrate from infighting.  Sector " + string(obj_ini.sector_name) + " is no longer as threatened by the forces of Chaos.";
                }
            }
        }
    
        if ((battle_special == "study2a") || (battle_special == "study2b")) {
            if (defeat == 1) {
                var ii = 0, good = 0;
    
                if (remove_planet_problem(battle_id, "mech_tomb", battle_object)) {
                    obj_controller.disposition[3] -= 10;
    
                    if (battle_special == "study2a") {
                        scr_popup("Mechanicus Mission Failed", "All of your Astartes and the Mechanicus Research party have been killed down to the last man.  The research is a bust, and the Adeptus Mechanicus is furious with your chapter for not providing enough security.  Relations with them are worse than before.", "", "");
                    }
                    if (battle_special == "study2b") {
                        battle_object.p_necrons[battle_id] = 5;
                        awaken_tomb_world(battle_object.p_feature[battle_id]);
                        obj_controller.disposition[3] -= 15;
                        obj_controller.disposition[4] -= 5;
                        scr_popup("Mechanicus Mission Failed", "All of your Astartes and the Mechanicus Research party have been killed down to the last man.  The research is a bust.  To make matters worse the Necron Tomb has fully awakened- countless numbers of the souless machines are now pouring out of the tomb.  The Adeptus Mechanicus are furious with your chapter.", "necron_army", "");
                        scr_alert("", "inqi", "The Inquisition is displeased with your Chapter for tampering with and awakening a Necron Tomb", 0, 0);
                        scr_event_log("", "The Inquisition is displeased with your Chapter for tampering with and awakening a Necron Tomb");
                    }
    
                    scr_event_log("", "Mechanicus Mission Failed: Necron Tomb Research Party and present astartes have been killed.");
                }
            }
        }
    
        if ((enemy == 5) && (obj_controller.faction_status[eFACTION.Ecclesiarchy] != "War")) {
            obj_controller.loyalty -= 50;
            obj_controller.loyalty_hidden -= 50;
            obj_controller.disposition[2] -= 50;
            obj_controller.disposition[3] -= 80;
            obj_controller.disposition[4] -= 40;
            obj_controller.disposition[5] -= 30;
    
            obj_controller.faction_status[eFACTION.Imperium] = "War";
            obj_controller.faction_status[eFACTION.Mechanicus] = "War";
            obj_controller.faction_status[eFACTION.Inquisition] = "War";
            obj_controller.faction_status[eFACTION.Ecclesiarchy] = "War";
    
            if (!instance_exists(obj_turn_end)) {
                obj_controller.audiences += 1;
                obj_controller.audien[obj_controller.audiences] = 5;
                obj_controller.audien_topic[obj_controller.audiences] = "declare_war";
                if (obj_controller.known[eFACTION.Inquisition] > 1) {
                    obj_controller.audiences += 1;
                    obj_controller.audien[obj_controller.audiences] = 4;
                    obj_controller.audien_topic[obj_controller.audiences] = "declare_war";
                }
                obj_controller.audiences += 1;
                obj_controller.audien[obj_controller.audiences] = 2;
                obj_controller.audien_topic[obj_controller.audiences] = "declare_war";
            } else {
                obj_turn_end.audiences += 1;
                obj_turn_end.audien[obj_turn_end.audiences] = 5;
                obj_turn_end.audien_topic[obj_turn_end.audiences] = "declare_war";
                if (obj_turn_end.known[eFACTION.Inquisition] > 1) {
                    obj_turn_end.audiences += 1;
                    obj_turn_end.audien[obj_turn_end.audiences] = 4;
                    obj_turn_end.audien_topic[obj_turn_end.audiences] = "declare_war";
                }
                obj_turn_end.audiences += 1;
                obj_turn_end.audien[obj_turn_end.audiences] = 2;
                obj_turn_end.audien_topic[obj_turn_end.audiences] = "declare_war";
            }
        }
    
        if ((exterminatus > 0) && (dropping != 0) && (string_count("mech", battle_special) == 0)) {
            scr_destroy_planet(1);
        }
    
        if ((string_count("mech", battle_special) > 0) && (defeat == 0)) {
            with (obj_ground_mission) {
                var comp, plan, i;
                i = 0;
                comp = 0;
                plan = 0;
                plan = instance_nearest(x, y, obj_star);
                scr_return_ship(obj_ground_mission.loc, obj_ground_mission, obj_ground_mission.num);
                with (obj_ground_mission) {
                    instance_destroy();
                }
            }
        }
    
        with (obj_ini) {
            for (var i = 0; i <= 10; i++) {
                scr_company_order(i);
                scr_vehicle_order(i);
            }
        }
    
        obj_controller.x = view_x;
        obj_controller.y = view_y;
        obj_controller.combat = 0;
        obj_controller.marines -= final_marine_deaths;
        obj_controller.command -= final_command_deaths;
    
        instance_activate_all();
    
        if (turn_count < 20) {
            if ((defeat == 0) && (threat >= 4)) {
                scr_recent("battle_victory", $"{battle_loc} {scr_roman(battle_id)}", enemy);
            }
    
            if ((defeat == 1) && (final_marine_deaths + final_command_deaths >= 10)) {
                scr_recent("battle_defeat", $"{enemy}, {final_marine_deaths + final_command_deaths}");
            }
        } else {
            scr_recent("battle_defeat", $"{enemy}, {final_marine_deaths + final_command_deaths}");
        }
    
        if (((dropping == 1) || (attacking == 1)) && (string_count("_attack", battle_special) == 0) && (string_count("mech", battle_special) == 0) && (string_count("ruins", battle_special) == 0) && (battle_special != "ship_demon")) {
            obj_controller.combat = 0;
            with (obj_drop_select) {
                instance_destroy();
            }
        }
        if ((dropping + attacking == 0) && (string_count("_attack", battle_special) == 0) && (string_count("mech", battle_special) == 0) && (string_count("ruins", battle_special) == 0) && (battle_special != "ship_demon") && (string_count("cs_meeting", battle_special) == 0)) {
            if (instance_exists(obj_turn_end)) {
                var _battle_index = obj_turn_end.current_battle;
                if (_battle_index < array_length(obj_turn_end.battle_object)) {
                    var _battle_object = obj_turn_end.battle_object[_battle_index];
    
                    var _planet = obj_turn_end.battle_world[_battle_index];
    
                    _battle_object.p_player[_planet] -= world_size;
    
                    if (defeat == 1) {
                        _battle_object.p_player[_planet] = 0;
                    }
                }
                obj_controller.combat = 0;
                with (obj_turn_end) {
                    alarm[4] = 1;
                }
            }
        }
        if ((string_count("ruins", battle_special) > 0) && (defeat == 1)) {
            //TODO this logic is wrong assumes all player units died in ruins
            var _combat_star = star_by_name(obj_ncombat.battle_loc);
            if (_combat_star != "none") {
                _combat_star.p_player[obj_ncombat.battle_id] -= obj_ncombat.world_size;
            }
        }
    
        if ((string_count("_attack", battle_special) > 0) && (string_count("mech", battle_special) == 0) && (string_count("ruins", battle_special) == 0) && (string_count("cs_meeting", battle_special) == 0)) {
            if (string_count("wake", battle_special) > 0) {
                var pip = instance_create(0, 0, obj_popup);
                with (pip) {
                    title = "Necron Tomb Awakens";
                    image = "necron_army";
                    if (obj_ncombat.defeat == 0) {
                        text = "Your marines make a tactical retreat back to the surface, hounded by Necrons all the way.  The Inquisition mission is a failure- you were to blow up the Necron Tomb World stealthily, not wake it up.  The Inquisition is not pleased with your conduct.";
                    }
                    if (obj_ncombat.defeat == 1) {
                        text = "Your marines are killed down to the last man.  The Inquisition mission is a failure- you were to blow up the Necron Tomb World stealthily, not wake it up.  The Inquisition is not pleased with your conduct.";
                    }
                }
    
                instance_activate_object(obj_star);
                with (obj_star) {
                    if (name != obj_ncombat.battle_loc) {
                        instance_deactivate_object(id);
                    }
                }
                with (obj_star) {
                    var planet = obj_ncombat.battle_id;
                    if (remove_planet_problem(planet, "bomb")) {
                        p_necrons[planet] = 4;
                    }
                    if (awake_tomb_world(p_feature[planet]) == 0) {
                        awaken_tomb_world(p_feature[planet]);
                    }
                }
                with (obj_temp7) {
                    instance_destroy();
                }
                instance_activate_object(obj_star);
    
                pip.number = obj_temp8.popup;
                pip.loc = obj_temp8.loc;
                pip.planet = battle_id;
                obj_controller.combat = 0;
                obj_controller.disposition[4] -= 5;
                obj_controller.cooldown = 10;
                with (obj_temp8) {
                    instance_destroy();
                }
                // obj_turn_end.alarm[1]=4;
            }
    
            if ((defeat == 1) && (string_count("wake", battle_special) == 0)) {
                with (obj_temp8) {
                    instance_destroy();
                }
                obj_controller.combat = 0;
                obj_controller.cooldown = 10;
                obj_turn_end.alarm[1] = 4;
            }
    
            if ((defeat == 0) && (string_count("wake", battle_special) == 0)) {
                obj_temp8.stage += 1;
                obj_controller.combat = 0;
                var pip = instance_create(0, 0, obj_popup);
    
                with (pip) {
                    title = "Necron Tunnels : " + string(obj_temp8.stage);
                    if (obj_temp8.stage == 2) {
                        image = "necron_tunnels_2";
                        text = "The energy readings are much stronger, now that your marines are deep inside the tunnels.  What was once cramped is now luxuriously large, the tunnel ceiling far overhead decorated by stalactites.";
                    }
                    if (obj_temp8.stage == 3) {
                        image = "necron_tunnels_3";
                        text = "After several hours of descent the entrance to the Necron Tomb finally looms ahead- dancing, sickly green light shining free.  Your marine confirms that the Plasma Bomb is ready.";
                    }
                    if (obj_temp8.stage == 4) {
                        if (obj_temp8.stage >= 4) {
                            instance_activate_object(obj_star);
                            image = "";
                            title = "Inquisition Mission Completed";
                            text = "Your marines finally enter the deepest catacombs of the Necron Tomb.  There they place the Plasma Bomb and arm it.  All around are signs of increasing Necron activity.  With half an hour set, your men escape back to the surface.  There is a brief rumble as the charge goes off, your mission a success.";
                            option1 = "";
                            option2 = "";
                            option3 = "";
    
                            if (obj_controller.demanding == 0) {
                                obj_controller.disposition[4] += 1;
                            }
                            if (obj_controller.demanding == 1) {
                                obj_controller.disposition[4] += choose(0, 0, 1);
                            }
    
                            // show_message(string(obj_temp8.loc)+"."+string(obj_temp8.wid));
                            // obj_controller.temp[200]=obj_temp8.loc;
                            with (obj_star) {
                                if (name != obj_temp8.loc) {
                                    instance_deactivate_object(id);
                                }
                            }
                            with (obj_star) {
                                if (name == obj_temp8.loc) {
                                    instance_create(x, y, obj_temp5);
                                }
                            }
    
                            you = instance_nearest(obj_temp5.x, obj_temp5.y, obj_star);
                            onceh = 0;
    
                            // show_message(you.name);
    
                            // show_message("TEMP5: "+string(instance_number(obj_temp5))+"#Star: "+string(you));
    
                            var ppp;
                            ppp = 0;
                            remove_planet_problem(obj_temp8.wid, "bomb", you);
    
                            pip.option1 = "";
                            pip.option2 = "";
                            pip.option3 = "";
                            scr_event_log("", "Inquisition Mission Completed: Your Astartes have sealed the Necron Tomb on " + string(you.name) + " " + string(scr_roman(obj_temp8.wid)) + ".");
                            scr_gov_disp(you.name, obj_temp8.wid, choose(1, 2, 3, 4, 5));
    
                            if (!instance_exists(obj_temp8)) {
                                pip.loc = battle_loc;
                                pip.planet = battle_id;
                            }
                            if (instance_exists(obj_temp8)) {
                                pip.number = obj_temp8.popup;
                                pip.loc = obj_temp8.loc;
                                pip.planet = obj_temp8.wid;
                            }
    
                            // show_message("Battle Closing: "+string(pip.loc)+"."+string(pip.planet));
    
                            with (obj_temp5) {
                                instance_destroy();
                            }
                            instance_activate_object(obj_star);
                            var have_bomb;
                            have_bomb = scr_check_equip("Plasma Bomb", obj_temp8.loc, obj_temp8.wid, 1);
                        }
                    }
                }
    
                if (instance_exists(obj_temp8) && (pip.planet == 0)) {
                    pip.number = obj_temp8.popup;
                    pip.loc = obj_temp8.loc;
                    pip.planet = battle_id;
                }
            }
        }
    
        if ((string_count("spyrer", battle_special) > 0) /* and (string_count("demon",battle_special)>0))*/ && (defeat == 0)) {
            instance_activate_object(obj_star);
            // show_message(obj_turn_end.current_battle);
            // show_message(obj_turn_end.battle_world[obj_turn_end.current_battle]);
            // title / text / image / speshul
            var cur_star = obj_turn_end.battle_object[obj_turn_end.current_battle];
            var planet = obj_turn_end.battle_world[obj_turn_end.current_battle];
            var planet_string = scr_roman_numerals()[planet - 1];
    
            remove_planet_problem(planet, "spyrer", cur_star);
    
            var tixt = $"The Spyrer on {cur_star.name} {planet_string} has been removed.  The citizens and craftsman may sleep more soundly, the Inquisition likely pleased.";
    
            scr_popup("Inquisition Mission Completed", tixt, "spyrer", "");
    
            if (obj_controller.demanding == 0) {
                obj_controller.disposition[4] += 2;
            }
            if (obj_controller.demanding == 1) {
                obj_controller.disposition[4] += choose(0, 0, 1);
            }
    
            scr_event_log("", "Inquisition Mission Completed: The Spyrer on {cur_star.name} {planet} has been removed.", cur_star.name);
            scr_gov_disp(cur_star.name, planet, choose(1, 2, 3, 4));
    
            instance_deactivate_object(obj_star);
        }
    
        if ((string_count("fallen", battle_special) > 0) && (defeat == 0)) {
            var fallen = 0;
            with (obj_turn_end) {
                remove_planet_problem(battle_world[current_battle], "fallen", battle_object[current_battle]);
                var tixt = "The Fallen on " + battle_object[current_battle].name;
                tixt += scr_roman(battle_world[current_battle]);
                scr_event_log("", $"Mission Succesful: {tixt} have been captured or purged.");
                tixt += $" have been captured or purged.  They shall be brought to the Chapter {obj_ini.role[100][14]}s posthaste, in order to account for their sins.  ";
                var ran;
                ran = choose(1, 1, 2, 3);
                if (ran == 1) {
                    tixt += "Suffering is the beginning to penance.";
                }
                if (ran == 2) {
                    tixt += "Their screams shall be the harbringer of their contrition.";
                }
                if (ran == 3) {
                    tixt += "The shame they inflicted upon us shall be written in their flesh.";
                }
                scr_popup("Hunt the Fallen Completed", tixt, "fallen", "");
            }
        }
    
        if ((defeat == 0) && (enemy == 9) && (battle_special == "tyranid_org")) {
            if (captured_gaunt > 1) {
                pop = instance_create(0, 0, obj_popup);
                pop.image = "inquisition";
                pop.title = "Inquisition Mission Completed";
                pop.text = "You have captured several Gaunt organisms.  The Inquisitor is pleased with your work, though she notes that only one is needed- the rest are to be purged.  It will be stored until it may be retrieved.  The mission is a success.";
            }
            if (captured_gaunt == 1) {
                pop = instance_create(0, 0, obj_popup);
                pop.image = "inquisition";
                pop.title = "Inquisition Mission Completed";
                pop.text = "You have captured a Gaunt organism- the Inquisitor is pleased with your work.  The Tyranid will be stored until it may be retrieved.  The mission is a success.";
            }
        }
    
        if ((enemy == 1) && (on_ship == true) && (defeat == 0)) {
            var diceh = floor(random(100)) + 1;
    
            if (scr_has_disadv("Shitty Luck")) {
                diceh -= 15;
            }
    
            if (diceh <= 15) {
                var ship, ship_hp, i = -1;
                for (var i = 0; i < array_length(obj_ini.ship); i++) {
                    ship[i] = obj_ini.ship[i];
                    ship_hp[i] = obj_ini.ship_hp[i];
                    if (i == battle_id) {
                        obj_ini.ship_hp[i] = -50;
                        scr_recent("ship_destroyed", obj_ini.ship[i], i);
                    }
                }
                var pop = instance_create(0, 0, obj_popup);
                pop.image = "";
                pop.title = "Ship Destroyed";
                pop.text = "A handful of loyalist " + string(global.chapter_name) + " make a fighting retreat to the engine of the vessel, '" + string(obj_ini.ship[battle_id]) + "', and then overload the main reactor.  Your ship explodes in a brilliant cloud of fire.";
                scr_event_log("red", "A handful of loyalist " + string(global.chapter_name) + " overload the main reactor of your vessel '" + string(obj_ini.ship[battle_id]) + "'.");
                pop.mission = "loyalist_destroy_ship";
    
                scr_ini_ship_cleanup();
            }
        }
    
        if (enemy == 1) {
            if ((battle_special == "cs_meeting_battle1") || (battle_special == "cs_meeting_battle2")) {
                obj_controller.diplomacy = 10;
                obj_controller.menu = 20;
                with (obj_controller) {
                    scr_dialogue("cs_meeting21");
                }
            }
    
            // Chapter Master just murdered absolutely everyone
            if ((battle_special == "cs_meeting_battle7") && (defeat == 0)) {
                if (obj_controller.chaos_rating < 1) {
                    obj_controller.chaos_rating += 1;
                }
                obj_controller.complex_event = false;
                obj_controller.diplomacy = 0;
                obj_controller.menu = 0;
                obj_controller.force_goodbye = 0;
                obj_controller.cooldown = 20;
                obj_controller.current_eventing = "chaos_meeting_end";
                with (obj_temp_meeting) {
                    instance_destroy();
                }
                with (obj_popup) {
                    instance_destroy();
                }
                if (instance_exists(obj_turn_end)) {
                    obj_turn_end.combating = 0; // obj_turn_end.alarm[1]=1;
                }
                var pip;
                pip = instance_create(0, 0, obj_popup);
                pip.title = "Enemies Vanquished";
                pip.text = "Not only have you killed the Chaos Lord, " + string(obj_controller.faction_leader[eFACTION.Chaos]) + ", but also all of your battle brothers that questioned your rule.  As you stand, alone, among the broken corpses of your enemies you begin to question what exactly it is that you accomplished.  No matter the results, you feel as though your actions have been noticed.";
            }
        }
    
        if (enemy == 10) {
            if ((battle_special == "cs_meeting_battle10") && (defeat == 0)) {
                obj_controller.complex_event = false;
                obj_controller.diplomacy = 0;
                obj_controller.menu = 0;
                obj_controller.force_goodbye = 0;
                obj_controller.cooldown = 20;
                obj_controller.current_eventing = "chaos_meeting_end";
                with (obj_temp_meeting) {
                    instance_destroy();
                }
                with (obj_popup) {
                    instance_destroy();
                }
                if (instance_exists(obj_turn_end)) {
                    obj_turn_end.combating = 0; // obj_turn_end.alarm[1]=1;
                }
                var pip = instance_create(0, 0, obj_popup);
                pip.title = "Survived";
                pip.text = "You and the rest of your battle brothers fight your way out of the catacombs, back through the tunnel where you first entered.  By the time you manage it your forces are battered and bloodied and in desperate need of pickup.  The whole meeting was a bust- Chaos Lord " + string(obj_controller.faction_leader[eFACTION.Chaos]) + " clearly intended to kill you and simply be done with it.";
            }
    
            if (((battle_special == "cs_meeting_battle5") || (battle_special == "cs_meeting_battle6")) && (defeat == 0)) {
                var mos;
                mos = false;
    
                with (obj_ground_mission) {
                    instance_destroy();
                }
                with (obj_pnunit) {
                    var j;
                    j = 0;
                    repeat (300) {
                        j += 1;
                        if (marine_type[j] == "Master of Sanctity") {
                            instance_create(0, 0, obj_ground_mission);
                        }
                    }
                }
                // Master of Sanctity present, wishes to take in the player
                if (instance_exists(obj_ground_mission) && (string_count("CRMOS|", obj_controller.useful_info) == 0)) {
                    obj_controller.menu = 20;
                    with (obj_controller) {
                        scr_dialogue("cs_meeting_m5");
                    }
                }
    
                // Master of Sanctity not present, just get told that you have defeated the Chaos Lord
                if ((!instance_exists(obj_ground_mission)) || (string_count("CRMOS|", obj_controller.useful_info) > 0)) {
                    // Some kind of popup based on what you were going after
    
                    obj_controller.complex_event = false;
                    obj_controller.diplomacy = 0;
                    obj_controller.menu = 0;
                    obj_controller.force_goodbye = 0;
                    obj_controller.cooldown = 20;
                    obj_controller.current_eventing = "chaos_meeting_end";
                    with (obj_temp_meeting) {
                        instance_destroy();
                    }
                    with (obj_popup) {
                        instance_destroy();
                    }
                    if (instance_exists(obj_turn_end)) {
                        obj_turn_end.combating = 0; // obj_turn_end.alarm[1]=1;
                    }
                    var pip;
                    pip = instance_create(0, 0, obj_popup);
                    pip.title = "Chaos Lord Killed";
                    pip.text = "(Not completed yet- variable reward based on what chosen)";
                }
                with (obj_ground_mission) {
                    instance_destroy();
                }
            }
        }
    
        if (battle_special == "ship_demon") {
            if (defeat == 1) {
                var ship, ship_hp, i;
                i = -1;
                repeat (51) {
                    i += 1;
                    ship[i] = obj_ini.ship[i];
                    ship_hp[i] = obj_ini.ship_hp[i];
                    if (i == battle_id) {
                        obj_ini.ship_hp[i] = -50;
                        scr_recent("ship_destroyed", obj_ini.ship[i], i);
                    }
                }
                var pop;
                pop = instance_create(0, 0, obj_popup);
                pop.image = "";
                pop.title = "Ship Destroyed";
                pop.text = "The daemon has slayed all of your marines onboard.  It works its way to the engine of the vessel, '" + string(obj_ini.ship[battle_id]) + "', and then tears into the main reactor.  Your ship explodes in a brilliant cloud of fire.";
                scr_event_log("red", "A daemon unbound from an Artifact wreaks havoc upon and destroys your vessel '" + string(obj_ini.ship[battle_id]) + "'.");
    
                scr_ini_ship_cleanup();
            }
        }
    
        if ((battle_special == "space_hulk") && (defeat == 0) && (hulk_treasure > 0)) {
            var shi = 0, loc = "";
    
            var shiyp = instance_nearest(battle_object.x, battle_object.y, obj_p_fleet);
            if (shiyp.x == battle_object.x && shiyp.y == battle_object.y) {
                shi = fleet_full_ship_array(shiyp)[0];
                loc = obj_ini.ship[shi];
            }
    
            if (hulk_treasure == 1) {
                // Requisition
                var reqi = round(random_range(30, 60) + 1) * 10;
                obj_controller.requisition += reqi;
    
                var pop;
                pop = instance_create(0, 0, obj_popup);
                pop.image = "space_hulk_done";
                pop.title = "Space Hulk: Resources";
                pop.text = "Your battle brothers have located several luxury goods and coginators within the Space Hulk.  They are salvaged and returned to the ship, granting " + string(reqi) + " Requisition.";
            } else if (hulk_treasure == 2) {
                // Artifact
                //TODO this will eeroniously put artifacts in the wrong place but will resolve crashes
                var last_artifact = scr_add_artifact("random", "random", 4, loc, shi + 500);
                var i = 0;
    
                var pop = instance_create(0, 0, obj_popup);
                pop.image = "space_hulk_done";
                pop.title = "Space Hulk: Artifact";
                pop.text = $"An Artifact has been retrieved from the Space Hulk and stowed upon {loc}.  It appears to be a {obj_ini.artifact[last_artifact]} but should be brought home and identified posthaste.";
                scr_event_log("", "Artifact recovered from the Space Hulk.");
            } else if (hulk_treasure == 3) {
                // STC
                scr_add_stc_fragment(); // STC here
                var pop;
                pop = instance_create(0, 0, obj_popup);
                pop.image = "space_hulk_done";
                pop.title = "Space Hulk: STC Fragment";
                pop.text = "An STC Fragment has been retrieved from the Space Hulk and safely stowed away.  It is ready to be decrypted or gifted at your convenience.";
                scr_event_log("", "STC Fragment recovered from the Space Hulk.");
            } else if (hulk_treasure == 4) {
                // Termie Armour
                var termi = choose(2, 2, 2, 3);
                scr_add_item("Terminator Armour", termi);
                var pop;
                pop = instance_create(0, 0, obj_popup);
                pop.image = "space_hulk_done";
                pop.title = "Space Hulk: Terminator Armour";
                pop.text = "The fallen heretics wore several suits of Terminator Armour- a handful of them were found to be cleansible and worthy of use.  " + string(termi) + " Terminator Armour has been added to the Armamentarium.";
            }
        }
    
        if (((leader == 1) || (battle_special == "world_eaters")) && (obj_controller.faction_defeated[10] == 0) && (defeat == 0) && (battle_special != "WL10_reveal") && (battle_special != "WL10_later")) {
            if ((battle_special != "WL10_reveal") && (battle_special != "WL10_later")) {
                // prolly schedule a popup congratulating
                obj_controller.faction_defeated[enemy] = 1;
                if (obj_controller.known[enemy] == 0) {
                    obj_controller.known[enemy] = 1;
                }
    
                if (battle_special != "world_eaters") {
                    with (obj_star) {
                        if (string_count("WL" + string(obj_ncombat.enemy), p_feature[obj_ncombat.battle_id]) > 0) {
                            p_feature[obj_ncombat.battle_id] = string_replace(p_feature[obj_ncombat.battle_id], "WL" + string(obj_ncombat.enemy) + "|", "");
                        }
                    }
                }
                if (battle_special == "world_eaters") {
                    obj_controller.faction_defeated[10] = 1; // show_message("WL10 defeated");
                    if (instance_exists(obj_turn_end)) {
                        scr_event_log("", "Enemy Leader Assassinated: Chaos Lord");
                        scr_alert("", "ass", "Chaos Lord " + string(obj_controller.faction_leader[eFACTION.Chaos]) + " has been killed.", 0, 0);
                        scr_popup("Black Crusade Ended", "The Chaos Lord " + string(obj_controller.faction_leader[eFACTION.Chaos]) + " has been slain in combat.  Without his leadership the Black Crusade is destined to crumble apart and disintegrate from infighting.  Sector " + string(obj_ini.sector_name) + " is no longer at threat by the forces of Chaos.", "", "");
                    }
                    if (!instance_exists(obj_turn_end)) {
                        scr_event_log("", "Enemy Leader Assassinated: Chaos Lord");
                        var pop;
                        pop = instance_create(0, 0, obj_popup);
                        pop.image = "";
                        pop.title = "Black Crusade Ended";
                        pop.text = "The Chaos Lord " + string(obj_controller.faction_leader[eFACTION.Chaos]) + " has been slain in combat.  Without his leadership the Black Crusade is destined to crumble apart and disintegrate from infighting.  Sector " + string(obj_ini.sector_name) + " is no longer at threat by the forces of Chaos.";
                    }
                }
            }
        }
    
        instance_activate_all();
        with (obj_pnunit) {
            instance_destroy();
        }
        with (obj_enunit) {
            instance_destroy();
        }
        with (obj_nfort) {
            instance_destroy();
        }
        with (obj_centerline) {
            instance_destroy();
        }
        obj_controller.new_buttons_hide = 0;
    
        if (instance_exists(obj_cursor)) {
            obj_cursor.image_index = 0;
        }
    
        instance_destroy();
    
        /* */
        /*  */
    } catch (_exception) {
        handle_exception(_exception);
    }
}
