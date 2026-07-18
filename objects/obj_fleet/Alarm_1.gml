if (control) {
    instance_activate_object(obj_cursor);
}

if (enemy == 2) {
    if (en_escort > 0) {
        en_column[4] = "Sword Class Frigate";
        en_num[4] = en_escort;
        en_size[4] = 1;
    }

    if (en_frigate > 0) {
        en_column[3] = "Avenger Class Grand Cruiser";
        en_num[3] = en_frigate;
        en_size[3] = 2;
    }

    var i = en_capital;
    if (i > 0) {
        en_column[2] = "Apocalypse Class Battleship";
        en_num[2] = floor(random(i)) + 1;
        if (en_num[2] < (en_capital * 0.6)) {
            en_num[2] = round(en_capital * 0.6);
        }
        i -= en_num[2];
        en_size[2] = 3;
    }

    if (i > 0) {
        en_column[1] = "Nemesis Class Fleet Carrier";
        en_num[1] = i;
        i -= en_num[1];
        en_size[1] = 3;
    }
}

if (enemy == 6) {
    if (en_escort > 0) {
        en_column[4] = "Aconite";
        en_num[4] = max(1, floor(en_escort / 2));
        en_size[4] = 1;
    }
    if (en_escort > 1) {
        en_column[3] = "Hellebore";
        en_num[3] = max(1, floor(en_escort / 2));
        en_size[3] = 1;
    }
    if (en_frigate > 0) {
        en_column[2] = "Shadow Class";
        en_num[2] = en_frigate;
        en_size[2] = 2;
    }
    if (en_capital > 0) {
        en_column[1] = "Void Stalker";
        en_num[1] = en_capital;
        en_size[1] = 3;
    }
}

if (enemy == 7) {
    var i = en_capital;

    if (i > 0) {
        en_column[1] = "Dethdeala";
        en_num[1] = irandom_range(1, i);
        i -= en_num[1];
        en_size[1] = 3;
    }

    if (i > 0) {
        en_column[2] = "Gorbag's Revenge";
        en_num[2] = irandom_range(1, i);
        i -= en_num[2];
        en_size[2] = 3;
    }

    if (i > 0) {
        en_column[3] = "Kroolboy";
        en_num[3] = i;
        i -= en_num[3];
        en_size[3] = 3;
    }

    if (en_frigate > 0) {
        en_column[4] = "Battlekroozer";
        en_num[4] = en_frigate;
        en_size[4] = 2;
    }

    if (en_escort > 0) {
        en_column[5] = "Ravager";
        en_num[5] = en_escort;
        en_size[5] = 1;
    }
}

if (enemy == 8) {
    var i = en_frigate;

    if (en_capital > 0) {
        en_column[1] = "Custodian";
        en_num[1] = en_capital;
        en_size[1] = 3;
    }

    if (i > 0) {
        en_column[2] = "Emissary";
        en_num[2] = 1;
        i -= en_num[2];
        en_size[2] = 2;
    }

    if (i > 0) {
        en_column[3] = "Protector";
        en_num[3] = i;
        i -= en_num[3];
        en_size[3] = 2;
    }

    if (en_escort > 0) {
        en_column[4] = "Castellan";
        en_num[4] = round((en_escort / 3) * 2);
        en_size[4] = 1;
    }

    if (en_escort > 2) {
        en_column[5] = "Warden";
        en_num[5] = en_escort - en_num[5];
        en_size[5] = 1;
    }
}

if (enemy == 9) {
    var i = en_escort;

    if (en_capital > 0) {
        en_column[1] = "Leviathan";
        en_num[1] = en_capital;
        en_size[1] = 3;
    }

    if (i > 0) {
        en_column[2] = "Stalker";
        en_num[2] = floor(i / 3) + 1;
        i -= en_num[2];
        en_size[2] = 1;
    }

    if (en_frigate > 0) {
        en_column[3] = "Razorfiend";
        en_num[3] = en_frigate;
        en_size[3] = 2;
    }

    if (i > 0) {
        en_column[4] = "Prowler";
        en_num[4] = i;
        en_size[4] = 1;
    }
}

if (enemy == 10) {
    var i = en_frigate;

    if (en_capital > 0) {
        en_column[1] = "Desecrator";
        en_num[1] = en_capital;
        en_size[1] = 3;
    }

    if (i > 0) {
        en_column[2] = "Avenger";
        en_num[2] = floor(random(i)) + 1;
        i -= en_num[2];
        en_size[2] = 2;
    }

    if (i > 0) {
        en_column[3] = "Carnage";
        en_num[3] = floor(random(i)) + 1;
        i -= en_num[3];
        en_size[3] = 2;
    }

    if (i > 0) {
        en_column[4] = "Daemon";
        en_num[4] = i;
        i -= en_num[4];
        en_size[4] = 2;
    }

    if (en_escort > 0) {
        en_column[5] = "Iconoclast";
        en_num[5] = en_escort;
        en_size[5] = 1;
    }
}

en_capital = 0;
en_frigate = 0;
en_escort = 0;
en_ships_max = 0;

for (var i = 1; i <= 5; i++) {
    if (en_column[i] == "Avenger Class Grand Cruiser") {
        en_width[i] = 196;
        en_height[i] = 96;
    }
    if (en_column[i] == "Apocalypse Class Battleship") {
        en_width[i] = 272;
        en_height[i] = 128;
    }
    if (en_column[i] == "Nemesis Class Fleet Carrier") {
        en_width[i] = 272;
        en_height[i] = 128;
    }
    if (en_column[i] == "Sword Class Frigate") {
        en_width[i] = 96;
        en_height[i] = 64;
    }

    if (en_column[i] == "Void Stalker") {
        en_width[i] = 260;
        en_height[i] = 192;
    }
    if (en_column[i] == "Shadow Class") {
        en_width[i] = 212;
        en_height[i] = 160;
    }
    if (en_column[i] == "Hellebore") {
        en_width[i] = 160;
        en_height[i] = 64;
    }
    if (en_column[i] == "Aconite") {
        en_width[i] = 128;
        en_height[i] = 64;
    }

    if (en_column[i] == "Deathdeala") {
        en_width[i] = 196;
        en_height[i] = 128;
    }
    if (en_column[i] == "Gorbag's Revenge") {
        en_width[i] = 196;
        en_height[i] = 128;
    }
    if (en_column[i] == "Kroolboy") {
        en_width[i] = 196;
        en_height[i] = 128;
    }
    if (en_column[i] == "Slamblasta") {
        en_width[i] = 196;
        en_height[i] = 128;
    }
    if (en_column[i] == "Battlekroozer") {
        en_width[i] = 160;
        en_height[i] = 96;
    }
    if (en_column[i] == "Ravager") {
        en_width[i] = 128;
        en_height[i] = 64;
    }

    if (en_column[i] == "Desecrator") {
        en_width[i] = 196;
        en_height[i] = 128;
    }
    if (en_column[i] == "Avenger") {
        en_width[i] = 160;
        en_height[i] = 96;
    }
    if (en_column[i] == "Carnage") {
        en_width[i] = 160;
        en_height[i] = 96;
    }
    if (en_column[i] == "Daemon") {
        en_width[i] = 160;
        en_height[i] = 96;
    }
    if (en_column[i] == "Iconoclast") {
        en_width[i] = 128;
        en_height[i] = 64;
    }

    if (en_column[i] == "Custodian") {
        en_width[i] = 128;
        en_height[i] = 256;
    }
    if (en_column[i] == "Emissary") {
        en_width[i] = 160;
        en_height[i] = 96;
    }
    if (en_column[i] == "Protector") {
        en_width[i] = 64;
        en_height[i] = 180;
    }
    if (en_column[i] == "Castellan") {
        en_width[i] = 48;
        en_height[i] = 96;
    }
    if (en_column[i] == "Warden") {
        en_width[i] = 48;
        en_height[i] = 80;
    }

    if (en_column[i] == "Leviathan") {
        en_width[i] = 200;
        en_height[i] = 128;
    }
    if (en_column[i] == "Razorfiend") {
        en_width[i] = 160;
        en_height[i] = 128;
    }
    if (en_column[i] == "Stalker") {
        en_width[i] = 96;
        en_height[i] = 64;
    }
    if (en_column[i] == "Prowler") {
        en_width[i] = 80;
        en_height[i] = 64;
    }
}

attack_mode = "offensive";

if ((ambushers == 1) && (ambushers == 999)) {
    global_attack = global_attack * 1.1;
} // Need to finish this
if (bolter_drilling == 1) {
    global_bolter = global_bolter * 1.1;
}
if ((siege == 1) && (siege == 555)) {
    global_attack = global_attack * 1.2;
} // Need to finish this
if (slow == 1) {
    global_attack = global_attack * 0.9;
    global_defense = global_defense * 1.2;
}
if (melee == 1) {
    global_melee = global_melee * 1.15;
}
if (shitty_luck == 1) {
    global_defense = global_defense * 0.9;
}
if (ossmodula == 1) {
    global_attack = global_attack * 0.95;
    global_defense = global_defense * 0.95;
}
if (betchers == 1) {
    global_melee = global_melee * 0.95;
}
if (catalepsean == 1) {
    global_attack = global_attack * 0.95;
}

alarm[2] = 1;
