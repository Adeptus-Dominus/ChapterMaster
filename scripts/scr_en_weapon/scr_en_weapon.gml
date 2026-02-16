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

    var atta, arp, rang, amm, spli, faith_bonus;
    rang = 0;
    atta = 0;
    spli = 0;
    arp = 1;
    amm = -1;
    faith_bonus = 0;
    // var struct = gear_weapon_data("weapon",name);

    //if (obj_ncombat.enemy=5) then faith_bonus=faith[man_type];

    switch (name) {
        case "Venom Claws":
            atta = 200;
            arp = 4;
            rang = 1;
            spli = 0;
            if (obj_ini.preomnor == 1) {
                atta = 240;
            }
            break;
        case "Web Spinner":
            atta = 40;
            arp = 1;
            rang = 2.1;
            spli = 3;
            amm = 1;
            break;
        case "Warpsword":
            atta = 300;
            arp = 4;
            rang = 1;
            spli = 3;
            break;
        case "Iron Claw":
            atta = 400;
            arp = 4;
            rang = 1;
            spli = 0;
            break;
        case "Maulerfiend Claws":
            atta = 300;
            arp = 4;
            rang = 1;
            spli = 3;
            break;
        case "Eldritch Fire":
            atta = 80;
            arp = 4;
            rang = 5.1;
            break;
        case "Bloodletter Melee":
            atta = 70;
            arp = 2;
            rang = 1;
            spli = 3;
            break;
        case "Daemonette Melee":
            atta = 65;
            arp = 1;
            rang = 1;
            spli = 3;
            break;
        case "Plaguebearer Melee":
            atta = 60;
            arp = 1;
            rang = 1;
            spli = 3;
            if (obj_ini.preomnor == 1) {
                atta = 70;
            }
            break;
        case "Khorne Demon Melee":
            atta = 350;
            arp = 4;
            rang = 1;
            spli = 3;
            break;
        case "Demon Melee":
            atta = 250;
            arp = 4;
            rang = 1;
            spli = 3;
            break;
        case "Lash Whip":
            atta = 80;
            arp = 1;
            rang = 2;
            break;
        case "Nurgle Vomit":
            atta = 100;
            arp = 1;
            rang = 2;
            spli = 3;
            if (obj_ini.preomnor == 1) {
                atta = 260;
            }
            break;
        case "Multi-Melta":
            atta = 200;
            arp = 4;
            rang = 4.1;
            spli = 0;
            amm = 6;
            break;
        case "Melee Weapon":
            atta = 60;
            arp = 1;
            rang = 1;
            break;
        default:
            break;
    }

    if (obj_ncombat.enemy == 3) {
        switch (name) {
            case "Phased Plasma-fusil":
                atta = 80;
                arp = 4;
                rang = 7.1;
                spli = 3;
                break;
            case "Lightning Gun":
                atta = choose(80, 80, 80, 150);
                arp = 2;
                rang = 5;
                spli = 0;
                break;
            case "Thallax Melee":
                atta = 80;
                arp = 1;
                rang = 1;
                spli = 3;
                break;
            default:
                LOGGER.debug($"Unknown weapon name: {name}; script: scr_en_weapon.gml");
                break;
        }
    }

    if (obj_ncombat.enemy == 6) {
        switch (name) {
            case "Fusion Gun":
                atta = 180;
                arp = 4;
                rang = 2;
                amm = 4;
                break;
            case "Firepike":
                atta = 150;
                arp = 4;
                rang = 4;
                amm = 4;
                break;
            case "Singing Spear":
                atta = 150;
                arp = 2;
                rang = 1;
                spli = 3;
                break;
            case "Singing Spear Throw":
                atta = 120;
                arp = 2;
                rang = 2;
                spli = 3;
                break;
            case "Witchblade":
                atta = 130;
                arp = 3;
                rang = 1;
                break;
            case "Psyshock":
                atta = 80;
                arp = 3;
                rang = 2;
                break;
            case "Wailing Doom":
                atta = 200;
                arp = 4;
                rang = 1;
                spli = 3;
                break;
            case "Avatar Smite":
                atta = 300;
                arp = 4;
                rang = 2;
                amm = 2;
                break;
            case "Ranger Long Rifle":
                atta = 60;
                arp = 2;
                rang = 25;
                break;
            case "Pathfinder Long Rifle":
                atta = 70;
                arp = 2;
                rang = 25;
                break;
            case "Shuriken Catapult":
                atta = 50;
                arp = 2;
                rang = 2;
                break;
            case "Twin Linked Shuriken Catapult":
                atta = 100;
                arp = 2;
                rang = 2;
                break;
            case "Avenger Shuriken Catapult":
                atta = 90;
                arp = 2;
                rang = 3;
                break;
            case "Power Weapon":
            case "Power Blades":
                atta = 100;
                arp = 4;
                rang = 1;
                spli = 3;
                break;
            case "Shuriken Pistol":
                atta = 50;
                arp = 2;
                rang = 2.1;
                break;
            case "Executioner":
                atta = 150;
                arp = 4;
                rang = 1;
                break;
            case "Scorpion Chainsword":
                atta = 100;
                arp = 2;
                rang = 1;
                spli = 3;
                break;
            case "Mandiblaster":
                atta = 60;
                arp = 1;
                rang = 1;
                break;
            case "Biting Blade":
                atta = 125;
                arp = 2;
                rang = 1;
                spli = 3;
                break;
            case "Scorpian's Claw":
                atta = 150;
                arp = 4;
                rang = 1;
                spli = 3;
                break;
            case "Meltabomb":
                atta = 200;
                arp = 4;
                rang = 1;
                amm = 1;
                break;
            case "Deathspinner":
                atta = 125;
                arp = 2;
                rang = 2;
                break;
            case "Dual Deathspinner":
                atta = 250;
                arp = 2;
                rang = 2;
                break;
            case "Reaper Launcher":
                atta = 120;
                arp = 4;
                rang = 20;
                amm = 8;
                spli = 3;
                break;
            case "Tempest Launcher":
                atta = 200;
                arp = 1;
                rang = 15;
                amm = 8;
                spli = 9;
                break;
            case "Laser Lance":
                atta = 180;
                arp = 4;
                rang = 2;
                spli = 3;
                break;
            case "Fusion Pistol":
                atta = 125;
                arp = 4;
                rang = 2.1;
                amm = 4;
                break;
            case "Plasma Pistol":
                atta = 100;
                arp = 4;
                rang = 3.1;
                break;
            case "Harlequin's Kiss":
                atta = 250;
                arp = 4;
                rang = 1;
                amm = 1;
                break;
            case "Wraithcannon":
                atta = 200;
                arp = 4;
                rang = 2.1;
                break;
            case "Pulse Laser":
                atta = 120;
                arp = 3;
                rang = 15;
                break;
            case "Bright Lance":
                atta = 200;
                arp = 4;
                rang = 8;
                break;
            case "Shuriken Cannon":
                atta = 160;
                arp = 2;
                rang = 3;
                break;
            case "Prism Cannon":
                atta = 400;
                arp = 4;
                rang = 20;
                spli = 1;
                break;
            case "Twin Linked Doomweaver":
                atta = 250;
                arp = 4;
                rang = 2;
                spli = 2;
                break; // Also create difficult terrain?
            case "Starcannon":
                atta = 250;
                arp = 4;
                rang = 8;
                spli = 4;
                break;
            case "Two Power Fists":
                atta = 300;
                arp = 4;
                rang = 1;
                spli = 2;
                break;
            case "Flamer":
                atta = 200;
                arp = 1;
                rang = 2;
                amm = 4;
                spli = 3;
                break;
            case "Titan Starcannon":
                atta = 500;
                arp = 4;
                rang = 4;
                spli = 8;
                break;
            case "Phantom Pulsar":
                atta = 500;
                arp = 4;
                rang = 20;
                spli = 3;
                break;
            default:
                LOGGER.debug($"Unknown weapon name: {name}; script: scr_en_weapon.gml");
                break;
        }
    }

    if (obj_ncombat.enemy == 7) {
        switch (name) {
            case "Choppa":
                atta = 100;
                arp = 1;
                rang = 1;
                spli = 3;
                break;
            case "Power Klaw":
                atta = 160;
                arp = 3;
                rang = 1;
                spli = 3;
                break;
            case "Slugga":
                atta = 70;
                arp = 1;
                rang = 3.1;
                amm = 4;
                spli = 3;
                break;
            case "Tankbusta Bomb":
                atta = 150;
                arp = 4;
                rang = 1;
                amm = 1;
                spli = 1;
                break;
            case "Big Shoota":
                atta = 120;
                arp = 1;
                rang = 6;
                amm = 30;
                spli = 5;
                break;
            case "Dakkagun":
                atta = 140;
                arp = 1;
                rang = 8;
                amm = 20;
                spli = 10;
                break;
            case "Deffgun":
                atta = 150;
                arp = 4;
                rang = 8;
                amm = 20;
                spli = 1;
                break;
            case "Snazzgun":
                atta = 200;
                arp = 2;
                rang = 5;
                spli = 0;
                break;
            case "Grot Blasta":
                atta = 50;
                arp = 1;
                rang = 2;
                amm = 6;
                break;
            case "Kannon":
                atta = 200;
                arp = 4;
                rang = 10.1;
                amm = 5;
                spli = 3;
                break;
            case "Shoota":
                atta = 80;
                arp = 1;
                rang = 5;
                break;
            case "Burna":
                atta = 140;
                arp = 2;
                rang = 2;
                amm = 4;
                spli = 3;
                break;
            case "Skorcha":
                atta = 200;
                arp = 3;
                rang = 2;
                amm = 6;
                spli = 3;
                break;
            case "Rokkit Launcha":
                atta = 150;
                arp = 4;
                rang = 15;
                spli = 3;
                break;
            case "Krooz Missile":
                atta = 300;
                arp = 4;
                rang = 15;
                spli = 3;
                break;
            default:
                LOGGER.debug($"Unknown weapon name: {name}; script: scr_en_weapon.gml");
                break;
        }
    }

    if (obj_ncombat.enemy == 8) {
        switch (name) {
            case "Fusion Blaster":
                atta = 150;
                arp = 4;
                rang = 2;
                amm = 4;
                break;
            case "Plasma Rifle":
                atta = 120;
                arp = 3;
                rang = 10;
                break;
            case "Cyclic Ion Blaster":
                atta = 80;
                arp = 2;
                rang = 6;
                spli = 3;
                break; // x6
            case "Burst Rifle":
                atta = 130;
                arp = 1;
                rang = 16;
                spli = 3;
                break;
            case "Missile Pod":
                atta = 150;
                arp = 2;
                rang = 15;
                amm = 6;
                spli = 3;
                break;
            case "Smart Missile System":
                atta = 150;
                arp = 2;
                rang = 15;
                break;
            case "Small Railgun":
                atta = 150;
                arp = 4;
                rang = 18;
                spli = 1;
                break;
            case "Pulse Rifle":
                atta = 80;
                arp = 2;
                rang = 12;
                break;
            case "Rail Rifle":
                atta = 80;
                arp = 4;
                rang = 14;
                break;
            case "Kroot Rifle":
                atta = 100;
                arp = 1;
                rang = 6;
                break;
            case "Vespid Crystal":
                atta = 100;
                arp = 3;
                rang = 2.1;
                break;
            case "Railgun":
                atta = 250;
                arp = 4;
                rang = 20;
                break;
            default:
                LOGGER.debug($"Unknown weapon name: {name}; script: scr_en_weapon.gml");
                break;
        }
    }

    if (obj_ncombat.enemy == 9) {
        switch (name) {
            case "Bonesword":
                atta = 120;
                arp = 3;
                rang = 1;
                spli = 3;
                break;
            case "Lash Whip":
                atta = 100;
                arp = 1;
                rang = 2;
                break;
            case "Heavy Venom Cannon":
                atta = 200;
                arp = 4;
                rang = 8;
                break;
            case "Crushing Claws":
                atta = 150;
                arp = 4;
                rang = 1;
                spli = 3;
                break;
            case "Rending Claws":
                atta = 80;
                arp = 3;
                rang = 1;
                spli = 3;
                break;
            case "Devourer":
                atta = 90;
                arp = 2;
                rang = 5;
                spli = 3;
                if (obj_ini.preomnor == 1) {
                    atta = 120;
                }
                break;
            case "Zoanthrope Blast":
                atta = 250;
                arp = 4;
                rang = 8;
                spli = 1;
                break;
            case "Carnifex Claws":
                atta = 225;
                arp = 4;
                rang = 1;
                spli = 3;
                break;
            case "Venom Cannon":
                atta = 100;
                arp = 4;
                rang = 5;
                break;
            case "Deathspitter":
                atta = 100;
                arp = 2;
                rang = 2.1;
                if (obj_ini.preomnor == 1) {
                    atta = 150;
                }
                break;
            case "Fleshborer":
                atta = 70;
                arp = 1;
                rang = 2.1;
                if (obj_ini.preomnor == 1) {
                    atta = 90;
                }
                break;
            case "Scything Talons":
                atta = 50;
                arp = 1;
                rang = 1;
                break;
            case "Genestealer Claws":
                atta = 70;
                arp = 3;
                rang = 1;
                break;
            case "Witchfire":
                atta = 100;
                arp = 3;
                rang = 2;
                break;
            case "Autogun":
                atta = 60;
                arp = 1;
                rang = 6;
                amm = 12;
                spli = 3;
                break;
            case "Lictor Claws":
                atta = 300;
                arp = 3;
                rang = 1;
                break;
            case "Flesh Hooks":
                atta = 100;
                arp = 2;
                rang = 2;
                amm = 1;
                break;
            default:
                LOGGER.debug($"Unknown weapon name: {name}; script: scr_en_weapon.gml");
                break;
        }
    }

    if (obj_ncombat.enemy >= 10 || obj_ncombat.enemy == 2 || obj_ncombat.enemy == 5 || obj_ncombat.enemy == 1) {
        switch (name) {
            case "Plasma Pistol":
                atta = 70;
                arp = 4;
                rang = 3.1;
                break;
            case "Power Weapon":
                atta = 120;
                arp = 4;
                rang = 1;
                break;
            case "Power Sword":
                atta = 120;
                arp = 4;
                rang = 1;
                break;
            case "Force Weapon":
                atta = 250;
                arp = 4;
                rang = 1;
                break;
            case "Chainfist":
                atta = 300;
                arp = 4;
                rang = 1;
                spli = 3;
                break;
            case "Meltagun":
                atta = 200;
                arp = 4;
                rang = 2;
                amm = 4;
                break;
            case "Flamer":
                atta = 160;
                arp = 1;
                rang = 2.1;
                amm = 4;
                spli = 3;
                break;
            case "Heavy Flamer":
                atta = 200;
                arp = 2;
                rang = 2.1;
                amm = 6;
                spli = 3;
                break;
            case "Combi-Flamer":
                atta = 160;
                arp = 1;
                rang = 2.1;
                amm = 1;
                spli = 3;
                break;
            case "Bolter":
                atta = 120;
                arp = 1;
                rang = 12;
                amm = 15;
                if (obj_ncombat.enemy == 5) {
                    atta = 80;
                }
                break; // Bursts
            case "Power Fist":
                atta = 250;
                arp = 4;
                rang = 1;
                break;
            case "Possessed Claws":
                atta = 150;
                arp = 1;
                rang = 1;
                spli = 3;
                break;
            case "Missile Launcher":
                atta = 200;
                arp = 2;
                rang = 20;
                amm = 4;
                break;
            case "Chainsword":
                atta = 120;
                arp = 1;
                rang = 1;
                spli = 4;
                break;
            case "Bolt Pistol":
                atta = 100;
                arp = 1;
                rang = 3.1;
                amm = 18;
                spli = 1;
                break;
            case "Chainaxe":
                atta = 140;
                arp = 1;
                rang = 1;
                spli = 3;
                break;
            case "Poisoned Chainsword":
                atta = 150;
                arp = 1;
                rang = 1;
                spli = 1;
                if (obj_ini.preomnor == 1) {
                    atta = 180;
                }
                break;
            case "Sonic Blaster":
                atta = 150;
                arp = 3;
                rang = 3;
                spli = 6;
                break;
            case "Rubric Bolter":
                atta = 150;
                arp = 1;
                rang = 12;
                amm = 15;
                spli = 5;
                break; // Bursts
            case "Witchfire":
                atta = 200;
                arp = 4;
                rang = 5.1;
                spli = 1;
                break;
            case "Autogun":
                atta = 60;
                arp = 1;
                rang = 6;
                amm = 12;
                spli = 3;
                break;
            case "Storm Bolter":
                atta = 180;
                arp = 1;
                rang = 8;
                amm = 10;
                spli = 3;
                break;
            case "Lascannon":
                atta = 400;
                arp = 4;
                rang = 20;
                amm = 8;
                spli = 1;
                break;
            case "Twin Linked Heavy Bolters":
                atta = 240;
                arp = 2;
                rang = 16;
                spli = 3;
                break;
            case "Twin-Linked Heavy Bolters":
                atta = 240;
                arp = 2;
                rang = 16;
                spli = 3;
                break;
            case "Twin Linked Lascannon":
                atta = 800;
                arp = 4;
                rang = 20;
                spli = 2;
                break;
            case "Twin-Linked Lascannon":
                atta = 800;
                arp = 4;
                rang = 20;
                spli = 2;
                break;
            case "Battle Cannon":
                atta = 300;
                arp = 4;
                rang = 12;
                break;
            case "Demolisher Cannon":
                atta = 500;
                arp = 4;
                rang = 2;
                spli = 8;
                if (instance_exists(obj_nfort)) {
                    rang = 5;
                }
                break;
            case "Earthshaker Cannon":
                atta = 250;
                arp = 3;
                rang = 12;
                spli = 8;
                break;
            case "Havoc Launcher":
                atta = 300;
                arp = 2;
                rang = 12;
                spli = 12;
                break;
            case "Baleflame":
                atta = 225;
                arp = 4;
                rang = 2;
                break;
            case "Defiler Claws":
                atta = 350;
                arp = 4;
                rang = 1;
                spli = 3;
                break;
            case "Reaper Autocannon":
                atta = 320;
                arp = 2;
                rang = 18;
                amm = 10;
                spli = 3;
                break;
            case "Ripper Gun":
                atta = 120;
                arp = 1;
                rang = 3;
                amm = 5;
                spli = 0;
                break;
            case "Ogryn Melee":
                atta = 90;
                arp = 4;
                rang = 1;
                break;
            case "Multi-Laser":
                atta = 150;
                arp = 2;
                rang = 10;
                break;
            case "Blessed Weapon":
                atta = 150;
                arp = 4;
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
                arp = 1;
                rang = 1;
                spli = 3;
                break;
            case "Sarissa":
                atta = 65;
                arp = 1;
                rang = 2;
                break;
            case "Seraphim Pistols":
                atta = 120;
                arp = 1;
                rang = 4;
                break;
            case "Laser Mace":
                atta = 150;
                arp = 3;
                rang = 5.1;
                amm = 3;
                break;
            case "Heavy Bolter":
                atta = 120;
                arp = 2;
                rang = 16;
                spli = 0;
                break;
            case "Lasgun":
                atta = 60;
                arp = 1;
                rang = 6;
                amm = 30;
                break;
            case "Daemonhost Claws":
                atta = 350;
                arp = 4;
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
                LOGGER.debug($"Unknown weapon name: {name}; script: scr_en_weapon.gml");
                break;
        }
    }

    if (obj_ncombat.enemy == 13) {
        // Some of these, like the Gauss Particle Cannon and Particle Whip, used to be more than twice as strong.
        switch (name) {
            case "Staff of Light":
                atta = 200;
                arp = 4;
                rang = 1;
                spli = 3;
                break;
            case "Staff of Light Shooting":
                atta = 180;
                arp = 4;
                rang = 3;
                spli = 3;
                break;
            case "Warscythe":
                atta = 200;
                arp = 4;
                rang = 1;
                spli = 0;
                break;
            case "Gauss Flayer":
                atta = 50;
                arp = 2;
                rang = 6.1;
                spli = 1;
                break;
            case "Gauss Blaster":
                atta = 80;
                arp = 2;
                rang = 6.1;
                spli = 0;
                break;
            case "Gauss Cannon":
                atta = 120;
                arp = 4;
                rang = 10;
                spli = 3;
                break;
            case "Gauss Particle Cannon":
                atta = 250;
                arp = 4;
                rang = 10.1;
                spli = 3;
                break;
            case "Overcharged Gauss Cannon":
                atta = 250;
                arp = 4;
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
                arp = 2;
                rang = 8;
                spli = 3;
                break;
            case "Particle Whip":
                atta = 300;
                arp = 4;
                rang = 4.1;
                spli = 3;
                break;
            case "Gauss Flayer Array":
                atta = 180;
                arp = 2;
                rang = 8.1;
                spli = 3;
                break;
            case "Doomsday Cannon":
                atta = 300;
                arp = 4;
                rang = 6.1;
                spli = 3;
                break;
            default:
                LOGGER.debug($"Unknown weapon name: {name}; script: scr_en_weapon.gml");
                break;
        }
    }

    switch (faith_bonus) {
        case 1:
            atta = atta * 2;
            break;
        case 2:
            atta = atta * 3;
            break;
    }

    atta = round(atta * obj_ncombat.global_defense);
    arp = round(arp * obj_ncombat.global_defense);

    if (obj_ncombat.enemy == 1) {
        // more attack crap here
        if ((rang <= 1) || (floor(rang) != rang)) {
            atta = round(atta * dudes_attack[group]);
        }
        if ((rang > 1) && (floor(rang) == rang)) {
            atta = round(atta * dudes_ranged[group]);
        }
    }

    if (!is_man) {
        amm = -1;
    }

    var goody = 0;
    var first = -1;
    for (var b = 0; b < 30; b++) {
        if ((wep[b] == name) && (goody == 0)) {
            att[b] += atta * man_number;
            apa[b] += arp;
            range[b] = rang;
            wep_num[b] += man_number;
            if (obj_ncombat.started == 0) {
                ammo[b] = amm;
            }
            goody = 1;

            if ((wep_owner[b] != "") || (man_number > 1)) {
                wep_owner[b] = "assorted";
            }
            if ((wep_owner[b] == "") && (man_number == 1)) {
                wep_owner[b] = man_type;
            }
        }
        if ((wep[b] == "") && (first == -1)) {
            first = b;
        }
    }
    if (goody == 0) {
        wep[first] = name;
        splash[first] = spli;
        att[first] += atta * man_number;
        apa[first] += arp;
        range[first] = rang;
        wep_num[first] += man_number;
        if (obj_ncombat.started == 0) {
            ammo[first] = amm;
        }
        goody = 1;

        if (man_number == 1) {
            wep_owner[first] = man_type;
        }
        if (man_number > 1) {
            wep_owner[first] = "assorted";
        }
    }

    /*
	wep[i]="";
	range[i]=0;
	att[i]=0;
	apa[i]=0;
	*/
}

// Global Enemy Weapons
// Convention: (freely changeable, but i started with this)
// attack -> armor_penetration -> range -> splash -> ammo -> special
// Array of 2 elements contains range from-to values
// Array of more than 2 elements indicates specific attack values to randomly choose from
// Exception is "special" attribute, which is always array of strings
// Poison means dmg is added when picking weakness to poison and toxins as geneseed mutation
// Siege means a range increase when there is a siege situation (attacking a fortification) (only one weapon uses it so far)

global.en_weapons = {
    // =====================
    // Tyranid Weapons
    // =====================

    "Venom Claws": {
        "attack": 200,
        "armor_penetration": 0,
        "range": 1,
        "splash": 0,
        "special": ["poison"], // poison adds 40 dmg (20% increase)
    },
    "Lash Whip": {
        "attack": 80,
        "armor_penetration": 0,
        "range": 2,
        "splash": 0,
    },
    "Bonesword": {
        "attack": 120,
        "armor_penetration": 0,
        "range": 1,
        "splash": 3,
    },
    "Heavy Venom Cannon": {
        "attack": 150,
        "armor_penetration": 1,
        "range": 8,
        "splash": 0,
    },
    "Crushing Claws": {
        "attack": 90,
        "armor_penetration": 1,
        "range": 1,
        "splash": 3,
    },
    "Rending Claws": {
        "attack": 80,
        "armor_penetration": 1,
        "range": 1,
        "splash": 3,
    },
    "Devourer": {
        "attack": [
            40,
            60,
            80,
            100
        ],
        "armor_penetration": 0,
        "range": 5,
        "splash": 0,
        "special": ["poison"], // poison adds 8, 12, 16, 20 dmg (20% increase)
    },
    "Zoanthrope Blast": {
        "attack": 200,
        "armor_penetration": 1,
        "range": 2,
        "splash": 0,
    },
    "Carnifex Claws": {
        "attack": 300,
        "armor_penetration": 1,
        "range": 1,
        "splash": 3,
    },
    "Venom Cannon": {
        "attack": 150,
        "armor_penetration": 0,
        "range": 5,
        "splash": 0,
    },
    "Deathspitter": {
        "attack": 100,
        "armor_penetration": 0,
        "range": 2.1,
        "splash": 0,
        "special": ["poison"], // poison adds 20 dmg (20% increase)
    },
    "Fleshborer": {
        "attack": 15,
        "armor_penetration": 0,
        "range": 2.1,
        "splash": 0,
        "special": ["poison"], // poison adds 4 dmg (4/15 increase)
    },
    "Scything Talons": {
        "attack": 30,
        "armor_penetration": 0,
        "range": 1,
        "splash": 0,
    },
    "Genestealer Claws": {
        "attack": [
            105,
            105,
            130
        ],
        "armor_penetration": 1,
        "range": 1,
        "splash": 0,
    },
    "Tyranid Witchfire": {
        // Dont know why tyranids would have witchfire, but it's in the original code
        "attack": 100,
        "armor_penetration": 1,
        "range": 2,
        "splash": 0,
    },
    "Tyranid Autogun": {
        "attack": 20,
        "armor_penetration": 0,
        "range": 6,
        "splash": 3,
        "ammo": 12,
    },
    "Lictor Claws": {
        "attack": 300,
        "armor_penetration": 0,
        "range": 1,
        "splash": 0,
    },
    "Flesh Hooks": {
        "attack": 50,
        "armor_penetration": 0,
        "range": 2,
        "splash": 0,
        "ammo": 1,
    },
    // =====================
    // Chaos / Daemonic Weapons
    // =====================

    "Warpsword": {
        "attack": 300,
        "armor_penetration": 1,
        "range": 1,
        "splash": 3,
    },
    "Iron Claw": {
        "attack": 400,
        "armor_penetration": 1,
        "range": 1,
        "splash": 0,
    },
    "Maulerfiend Claws": {
        "attack": 300,
        "armor_penetration": 300,
        "range": 1,
        "splash": 3,
    },
    "Chaos Witchfire": {
        // Dont know why tyranids would have witchfire, but it's in the original code
        "attack": 200,
        "armor_penetration": 1,
        "range": 5.1,
        "splash": 0,
    },
    "Eldritch Fire": {
        "attack": 80,
        "armor_penetration": 1,
        "range": 5.1,
    },
    "Bloodletter Melee": {
        "attack": 70,
        "armor_penetration": 0,
        "range": 1,
        "splash": 3,
    },
    "Daemonette Melee": {
        "attack": 65,
        "armor_penetration": 0,
        "range": 1,
        "splash": 3,
    },
    "Plaguebearer Melee": {
        "attack": 60,
        "armor_penetration": 0,
        "range": 1,
        "splash": 3,
        "special": ["poison"], // poison adds 10 dmg (1/6 increase)
    },
    "Khorne Demon Melee": {
        "attack": 350,
        "armor_penetration": 1,
        "range": 1,
        "splash": 3,
    },
    "Demon Melee": {
        "attack": 250,
        "armor_penetration": 1,
        "range": 1,
        "splash": 3,
    },
    "Nurgle Vomit": {
        "attack": 100,
        "armor_penetration": 0,
        "range": 2,
        "splash": 3,
        "special": ["poison"], // poison adds 160 dmg (160% increase)
    },
    "Possessed Claws": {
        "attack": 250,
        "armor_penetration": 1,
        "range": 1,
        "splash": 3,
    },
    "Baleflame": {
        "attack": 120,
        "armor_penetration": 0,
        "range": 2,
        "splash": 0,
    },
    "Defiler Claws": {
        "attack": 350,
        "armor_penetration": 1,
        "range": 1,
        "splash": 3,
    },
    "Daemonhost Claws": {
        "attack": 350,
        "armor_penetration": 1,
        "range": 1,
        "splash": 3,
    },
    "Daemonhost Powers": {
        "attack": [
            100,
            300
        ],
        "armor_penetration": [
            100,
            300
        ],
        "range": [
            1,
            6
        ],
        "splash": [
            0,
            0,
            1,
            1
        ], // Doubled up to keep convention
    },
    // =====================
    // Necron Weapons
    // =====================

    "Staff of Light": {
        "attack": 200,
        "armor_penetration": 1,
        "range": 1,
        "splash": 3,
    },
    "Staff of Light Shooting": {
        "attack": 180,
        "armor_penetration": 0,
        "range": 3,
        "splash": 3,
    },
    "Warscythe": {
        "attack": 200,
        "armor_penetration": 1,
        "range": 1,
        "splash": 0,
    },
    "Gauss Flayer": {
        "attack": [
            30,
            30,
            30,
            50,
            50,
            70
        ],
        "armor_penetration": 1, // Original code had no armor penetration for this weapon, Flayer Array has arp 1 so will this does as well
        "range": 6.1,
        "splash": 0,
    },
    "Gauss Blaster": {
        "attack": [
            70,
            70,
            70,
            70,
            70,
            100
        ],
        "armor_penetration": [
            0,
            0,
            0,
            0,
            0,
            1
        ],
        "range": 6.1,
        "splash": 0,
    },
    "Gauss Cannon": {
        "attack": 180,
        "armor_penetration": 1,
        "range": 10,
        "splash": 3,
    },
    "Gauss Particle Cannon": {
        "attack": 300,
        "armor_penetration": 1,
        "range": 10.1,
        "splash": 3,
    },
    "Overcharged Gauss Cannon": {
        "attack": 250,
        "armor_penetration": 1,
        "range": 8.1,
        "splash": 3,
    },
    "Wraith Claws": {
        "attack": 80,
        "armor_penetration": 1,
        "range": 1,
        "splash": 0,
    },
    "Necron Claws": {
        // Renamed from just "Claws" to avoid confusion
        "attack": 300,
        "armor_penetration": 1,
        "range": 1,
        "splash": 0,
    },
    "Gauss Flux Arc": {
        "attack": 180,
        "armor_penetration": 1,
        "range": 8,
        "splash": 3,
    },
    "Particle Whip": {
        "attack": 300,
        "armor_penetration": 1,
        "range": 4.1,
        "splash": 3,
    },
    "Gauss Flayer Array": {
        "attack": 180,
        "armor_penetration": 1,
        "range": 8.1,
        "splash": 3,
    },
    "Doomsday Cannon": {
        "attack": 300,
        "armor_penetration": 1,
        "range": 6.1,
        "splash": 3,
    },
    // =====================
    // Aeldari Weapons
    // =====================

    "Web Spinner": {
        "attack": 40,
        "armor_penetration": 0,
        "range": 2.1,
        "splash": 3,
        "ammo": 1,
    },
    "Fusion Gun": {
        "attack": 200,
        "armor_penetration": 1,
        "range": 2,
        "splash": 0,
        "ammo": 4,
    },
    "Firepike": {
        "attack": 200,
        "armor_penetration": 1,
        "range": 2,
        "splash": 0,
        "ammo": 4,
    },
    "Singing Spear": {
        "attack": 120,
        "armor_penetration": 0,
        "range": 1,
        "splash": 3,
    },
    "Singing Spear Throw": {
        "attack": 120,
        "armor_penetration": 1,
        "range": 2,
        "splash": 3,
    },
    "Witchblade": {
        "attack": 100,
        "armor_penetration": 1,
        "range": 1,
        "splash": 0,
    },
    "Psyshock": {
        "attack": 50,
        "armor_penetration": 0,
        "range": 2,
        "splash": 0,
    },
    "Wailing Doom": {
        "attack": 200,
        "armor_penetration": 1,
        "range": 1,
        "splash": 3,
    },
    "Avatar Smite": {
        "attack": 300,
        "armor_penetration": 1,
        "range": 2,
        "splash": 0,
        "ammo": 2,
    },
    "Ranger Long Rifle": {
        "attack": 60,
        "armor_penetration": 0,
        "range": 25,
        "splash": 0,
    },
    "Pathfinder Long Rifle": {
        "attack": 70,
        "armor_penetration": 0,
        "range": 25,
        "splash": 0,
    },
    "Shuriken Catapult": {
        "attack": 35,
        "armor_penetration": 0,
        "range": 2,
        "splash": 0,
    },
    "Twin Linked Shuriken Catapult": {
        "attack": 50,
        "armor_penetration": 0,
        "range": 2,
        "splash": 0,
    },
    "Avenger Shuriken Catapult": {
        "attack": 40,
        "armor_penetration": 0,
        "range": 3,
        "splash": 0,
    },
    "Aeldari Plasma Pistol": {
        "attack": 60,
        "armor_penetration": 1,
        "range": 3.1,
        "splash": 0,
    },
    "Aeldari Power Weapon": {
        "attack": 80,
        "armor_penetration": 0,
        "range": 1,
        "splash": 3,
    },
    "Aeldari Power Blades": {
        "attack": 80,
        "armor_penetration": 0,
        "range": 1,
        "splash": 3,
    },
    "Shuriken Pistol": {
        "attack": 25,
        "armor_penetration": 0,
        "range": 2.1,
        "splash": 0,
    },
    "Executioner": {
        "attack": 200,
        "armor_penetration": 1,
        "range": 1,
        "splash": 0,
    },
    "Scorpion Chainsword": {
        "attack": 40,
        "armor_penetration": 0,
        "range": 1,
        "splash": 3,
    },
    "Mandiblaster": {
        "attack": 20,
        "armor_penetration": 0,
        "range": 1,
        "splash": 0,
    },
    "Biting Blade": {
        "attack": 70,
        "armor_penetration": 0,
        "range": 1,
        "splash": 3,
    },
    "Scorpian's Claw": {
        "attack": 150,
        "armor_penetration": 1,
        "range": 1,
        "splash": 3,
    },
    "Scorpion's Claw": {
        "attack": 150,
        "armor_penetration": 1,
        "range": 1,
        "splash": 3,
    },
    "Meltabomb": {
        "attack": 0,
        "armor_penetration": 200,
        "range": 1,
        "splash": 1,
    },
    "Deathspinner": {
        "attack": 50,
        "armor_penetration": 0,
        "range": 2,
        "splash": 0,
    },
    "Dual Deathspinner": {
        "attack": 80,
        "armor_penetration": 0,
        "range": 2,
        "splash": 0,
    },
    "Reaper Launcher": {
        "attack": 150,
        "armor_penetration": 80,
        "range": 20,
        "splash": 3,
        "ammo": 8,
    },
    "Eldar Missile Launcher": {
        "attack": 200,
        "armor_penetration": 1,
        "range": 20,
        "splash": 3,
        "ammo": 4,
    },
    "Laser Lance": {
        "attack": 80,
        "armor_penetration": 0,
        "range": 2,
        "splash": 3,
    },
    "Fusion Pistol": {
        "attack": 100,
        "armor_penetration": 1,
        "range": 1.1,
        "splash": 0,
        "ammo": 4,
    },
    "Harlequin's Kiss": {
        "attack": 350,
        "armor_penetration": 0,
        "range": 1,
        "splash": 0,
        "ammo": 1,
    },
    "Wraithcannon": {
        "attack": 80,
        "armor_penetration": 1,
        "range": 2.1,
        "splash": 0,
    },
    "Pulse Laser": {
        "attack": 80,
        "armor_penetration": 1,
        "range": 15,
        "splash": 0,
    },
    "Bright Lance": {
        "attack": 100,
        "armor_penetration": 1,
        "range": 8,
        "splash": 0,
    },
    "Shuriken Cannon": {
        "attack": 65,
        "armor_penetration": 0,
        "range": 3,
        "splash": 0,
    },
    "Prism Cannon": {
        "attack": 250,
        "armor_penetration": 1,
        "range": 20,
        "splash": 0,
    },
    "Twin Linked Doomweaver": {
        "attack": 100,
        "armor_penetration": 0,
        "range": 2,
        "splash": 0,
    },
    "Starcannon": {
        "attack": 140,
        "armor_penetration": 1,
        "range": 3,
        "splash": 3,
    },
    "Two Power Fists": {
        "attack": 300,
        "armor_penetration": 1,
        "range": 1,
        "splash": 0,
    },
    "Aeldari Flamer": {
        "attack": 100,
        "armor_penetration": 0,
        "range": 2,
        "splash": 3,
        "ammo": 4,
    },
    "Titan Starcannon": {
        "attack": 220,
        "armor_penetration": 1,
        "range": 4,
        "splash": 3,
    },
    "Phantom Pulsar": {
        "attack": 500,
        "armor_penetration": 1,
        "range": 20,
        "splash": 3,
    },
    // =====================
    // Ork Weapons
    // =====================

    "Choppa": {
        "attack": 28,
        "armor_penetration": 0,
        "range": 1,
        "splash": 3,
    },
    "Power Klaw": {
        "attack": 150,
        "armor_penetration": 1,
        "range": 1,
        "splash": 3,
    },
    "Slugga": {
        "attack": 27,
        "armor_penetration": 0,
        "range": 3.1,
        "splash": 3,
        "ammo": 4,
    },
    "Tankbusta Bomb": {
        "attack": 264,
        "armor_penetration": 1,
        "range": 1,
        "splash": 0,
        "ammo": 1,
    },
    "Big Shoota": {
        "attack": 100,
        "armor_penetration": 0,
        "range": 12,
        "splash": 0,
        "ammo": 30,
    },
    "Dakkagun": {
        "attack": 150,
        "armor_penetration": 0,
        "range": 10,
        "splash": 0,
        "ammo": 20,
    },
    "Deffgun": {
        "attack": 120,
        "armor_penetration": 0,
        "range": 8,
        "splash": 0,
        "ammo": 20,
    },
    "Snazzgun": {
        "attack": 80,
        "armor_penetration": 0,
        "range": 10,
        "splash": 0,
    },
    "Grot Blasta": {
        "attack": 12,
        "armor_penetration": 0,
        "range": 2,
        "splash": 0,
        "ammo": 6,
    },
    "Kannon": {
        "attack": 200,
        "armor_penetration": 1,
        "range": 10.1,
        "splash": 3,
        "ammo": 5,
    },
    "Shoota": {
        "attack": 30,
        "armor_penetration": 0,
        "range": 6,
        "splash": 0,
    },
    "Burna": {
        "attack": 140,
        "armor_penetration": 1,
        "range": 2,
        "splash": 3,
        "ammo": 4,
    },
    "Skorcha": {
        "attack": 160,
        "armor_penetration": 1,
        "range": 2,
        "splash": 3,
        "ammo": 6,
    },
    "Rokkit Launcha": {
        "attack": 150,
        "armor_penetration": 1,
        "range": 15,
        "splash": 3,
    },
    "Krooz Missile": {
        "attack": 250,
        "armor_penetration": 1,
        "range": 15,
        "splash": 3,
    },
    // =====================
    // T'au Empire
    // =====================

    "Fusion Blaster": {
        "attack": 200,
        "armor_penetration": 1,
        "range": 2,
        "splash": 0,
        "ammo": 4,
    },
    "Plasma Rifle": {
        "attack": 120,
        "armor_penetration": 1,
        "range": 10,
        "splash": 0,
    },
    "Cyclic Ion Blaster": {
        "attack": 180,
        "armor_penetration": 0,
        "range": 6,
        "splash": 3,
    },
    "Burst Rifle": {
        "attack": 130,
        "armor_penetration": 0,
        "range": 16,
        "splash": 3,
    },
    "Missile Pod": {
        "attack": 160,
        "armor_penetration": 1,
        "range": 15,
        "splash": 3,
        "ammo": 6,
    },
    "Smart Missile System": {
        "attack": 150,
        "armor_penetration": 1,
        "range": 15,
        "splash": 0,
    },
    "Small Railgun": {
        "attack": 150,
        "armor_penetration": 1,
        "range": 18,
        "splash": 0,
    },
    "Pulse Rifle": {
        "attack": 37,
        "armor_penetration": 0,
        "range": 12,
        "splash": 0,
    },
    "Rail Rifle": {
        "attack": 65,
        "armor_penetration": 0,
        "range": 14,
        "splash": 0,
    },
    "Kroot Rifle": {
        "attack": 25,
        "armor_penetration": 0,
        "range": 6,
        "splash": 0,
    },
    "Vespid Crystal": {
        "attack": 60,
        "armor_penetration": 0,
        "range": 2.1,
        "splash": 0,
    },
    "Railgun": {
        "attack": 400,
        "armor_penetration": 1,
        "range": 20,
        "splash": 0,
    },
    // =====================
    // Imperium / Chaos Space Marines Weapons
    // =====================

    "Multi-Melta": {
        "attack": 200,
        "armor_penetration": 1,
        "range": 4.1,
        "splash": 0,
        "ammo": 6,
    },
    "Imperium Plasma Pistol": {
        "attack": 70,
        "armor_penetration": 1,
        "range": 3.1,
        "splash": 0,
    },
    "Meltagun": {
        "attack": 200,
        "armor_penetration": 1,
        "range": 2,
        "splash": 0,
        "ammo": 4,
    },
    "Imperium Flamer": {
        "attack": 160,
        "armor_penetration": 0,
        "range": 2.1,
        "splash": 3,
        "ammo": 4,
    },
    "Imperium Heavy Flamer": {
        "attack": 250,
        "armor_penetration": 0,
        "range": 2.1,
        "splash": 3,
        "ammo": 6,
    },
    "Combi-Flamer": {
        "attack": 160,
        "armor_penetration": 0,
        "range": 2.1,
        "splash": 3,
        "ammo": 1,
    },
    "Bolter": {
        "attack": 45,
        "armor_penetration": 0,
        "range": 12,
        "splash": 0,
        "ammo": 15,
    },
    "Bolt Pistol": {
        "attack": 35,
        "armor_penetration": 0,
        "range": 3.1,
        "splash": 0,
        "ammo": 18,
    },
    "Sonic Blaster": {
        "attack": 120,
        "armor_penetration": 0,
        "range": 3,
        "splash": 3,
    },
    "Rubric Bolter": {
        "attack": 80,
        "armor_penetration": 0,
        "range": 12,
        "splash": 0,
        "ammo": 15,
    },
    "Storm Bolter": {
        "attack": 65,
        "armor_penetration": 0,
        "range": 8,
        "splash": 3,
        "ammo": 10,
    },
    "Heavy Bolter": {
        "attack": 120,
        "armor_penetration": 0,
        "range": 16,
        "splash": 0,
    },
    "Twin Linked Heavy Bolters": {
        "attack": 240,
        "armor_penetration": 0,
        "range": 16,
        "splash": 3,
    },
    "Lascannon": {
        "attack": 200,
        "armor_penetration": 1,
        "range": 20,
        "splash": 0,
        "ammo": 8,
    },
    "Twin Linked Lascannon": {
        "attack": 300,
        "armor_penetration": 1,
        "range": 20,
        "splash": 0,
    },
    "Missile Launcher": {
        "attack": 200,
        "armor_penetration": 1,
        "range": 20,
        "splash": 3,
        "ammo": 4,
    },
    "Battle Cannon": {
        "attack": 300,
        "armor_penetration": 1,
        "range": 12,
        "splash": 0,
    },
    "Demolisher Cannon": {
        "attack": 500,
        "armor_penetration": 1,
        "range": 2,
        "splash": 0,
        "special": ["Siege"], // Siege means +3 range in siege situations
    },
    "Earthshaker Cannon": {
        "attack": 300,
        "armor_penetration": 0,
        "range": 12,
        "splash": 3,
    },
    "Havoc Launcher": {
        "attack": 100,
        "armor_penetration": 0,
        "range": 12,
        "splash": 0,
    },
    "Reaper Autocannon": {
        "attack": 320,
        "armor_penetration": 0,
        "range": 18,
        "splash": 3,
        "ammo": 10,
    },
    "Lasgun": {
        "attack": 20,
        "armor_penetration": 0,
        "range": 6,
        "splash": 0,
        "ammo": 30,
    },
    "Multi-Laser": {
        "attack": [
            60,
            75,
            90,
            105
        ],
        "armor_penetration": 0,
        "range": 10,
        "splash": 0,
    },
    "Imperium Autogun": {
        "attack": 20,
        "armor_penetration": 0,
        "range": 6,
        "splash": 0,
        "ammo": 12,
    },
    // =====================
    // Imperium Melee / Specialist
    // =====================

    "Chainsword": {
        "attack": 45,
        "armor_penetration": 0,
        "range": 1,
        "splash": 0,
    },
    "Chainaxe": {
        "attack": 55,
        "armor_penetration": 0,
        "range": 1,
        "splash": 0,
    },
    "Poisoned Chainsword": {
        "attack": 90,
        "armor_penetration": 0,
        "range": 1,
        "splash": 0,
        "special": ["poison"], // poison adds 40 dmg (4/9 increase)
    },
    "Imperium Power Weapon": {
        "attack": 120,
        "armor_penetration": 0,
        "range": 1,
        "splash": 0,
    },
    "Power Sword": {
        "attack": 120,
        "armor_penetration": 0,
        "range": 1,
        "splash": 0,
    },
    "Force Weapon": {
        "attack": 400,
        "armor_penetration": 1,
        "range": 1,
        "splash": 0,
    },
    "Chainfist": {
        "attack": 300,
        "armor_penetration": 1,
        "range": 1,
        "splash": 3,
    },
    "Power Fist": {
        "attack": 425,
        "armor_penetration": 1,
        "range": 1,
        "splash": 0,
    },
    "Blessed Weapon": {
        "attack": 150,
        "armor_penetration": 1,
        "range": 1,
        "splash": 0,
    },
    "Electro-Flail": {
        "attack": 125,
        "armor_penetration": 1,
        "range": 1,
        "splash": 3,
    },
    "Neural Whip": {
        "attack": 85,
        "armor_penetration": 0,
        "range": 1,
        "splash": 3,
    },
    "Sarissa": {
        "attack": 65,
        "armor_penetration": 0,
        "range": 2,
        "splash": 0,
    },
    "Ogryn Melee": {
        "attack": 90,
        "armor_penetration": 0,
        "range": 1,
        "splash": 0,
    },
    "Ripper Gun": {
        "attack": 40,
        "armor_penetration": 0,
        "range": 3,
        "splash": 0,
        "ammo": 5,
    },
    "Adepta Sororitas Bolter": {
        "attack": 35,
        "armor_penetration": 0,
        "range": 12,
        "splash": 0,
        "ammo": 15,
    },
    "Seraphim Pistols": {
        "attack": 200,
        "armor_penetration": 1,
        "range": 4,
        "splash": 0,
    },
    "Laser Mace": {
        "attack": 200,
        "armor_penetration": 1,
        "range": 5.1,
        "splash": 3,
    },
    // =====================
    // Mechanicum / Other
    // =====================

    "Phased Plasma-fusil": {
        "attack": 100,
        "armor_penetration": 1,
        "range": 7.1,
        "splash": 3,
    },
    "Lightning Gun": {
        "attack": [
            80,
            80,
            80,
            150
        ],
        "armor_penetration": 0,
        "range": 5,
        "splash": 0,
    },
    "Thallax Melee": {
        "attack": 80,
        "armor_penetration": 0,
        "range": 1,
        "splash": 3,
    },
};
// End of Global Enemy Weapons 
