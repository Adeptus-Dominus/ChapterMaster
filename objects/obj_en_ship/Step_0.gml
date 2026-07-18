if (owner != eFACTION.ELDAR) {
    image_angle = direction;

    if (obj_fleet.start != 5) {
        exit;
    }

    if ((class == "Daemon") && (image_alpha < 1)) {
        image_alpha += 0.006;
    }

    if ((shields > 0) && (shields < maxshields)) {
        shields += 0.02;
    }

    // Need to every couple of seconds check this
    // with obj_en_ship if not big then disable, check nearest, and activate once more

    if (instance_exists(obj_p_ship) && (!instance_exists(obj_al_ship))) {
        target = instance_nearest(x, y, obj_p_ship);
    }
    if ((!instance_exists(obj_p_ship)) && instance_exists(obj_al_ship)) {
        target = instance_nearest(x, y, obj_al_ship);
    }
    if (instance_exists(obj_p_ship) && instance_exists(obj_al_ship)) {
        var tp1 = instance_nearest(x, y, obj_p_ship);
        var tp2 = instance_nearest(x, y, obj_al_ship);
        if (point_distance(x, y, tp1.x, tp1.y) <= point_distance(x, y, tp2.x, tp2.y)) {
            target = tp1;
        }
        if (point_distance(x, y, tp1.x, tp1.y) > point_distance(x, y, tp2.x, tp2.y)) {
            target = tp2;
        }
    }
    if (!instance_exists(target)) {
        exit;
    }

    if (hp <= 0) {
        var gud = 0;
        for (var i = 1; i <= 5; i++) {
            if (obj_fleet.enemy[i] == owner) {
                gud = i;
            }
        }

        if (size == 3) {
            obj_fleet.en_capital_lost[gud] += 1;
        }
        if (size == 2) {
            obj_fleet.en_frigate_lost[gud] += 1;
        }
        if (size == 1) {
            obj_fleet.en_escort_lost[gud] += 1;
        }

        image_alpha = 0.5;

        if (owner != eFACTION.TYRANIDS) {
            var husk = instance_create(x, y, obj_en_husk);
            husk.sprite_index = sprite_index;
            husk.direction = direction;
            husk.image_angle = image_angle;
            husk.depth = depth;
            husk.image_speed = 0;
            repeat (choose(4, 5, 6)) {
                var explo = instance_create(x, y, obj_explosion);
                explo.image_xscale = 0.5;
                explo.image_yscale = 0.5;
                explo.x += random_range(sprite_width * 0.25, sprite_width * -0.25);
                explo.y += random_range(sprite_width * 0.25, sprite_width * -0.25);
            }
        }
        if (owner == eFACTION.TYRANIDS) {
            effect_create_depth(depth - 1, ef_firework, x, y, 1, c_purple);
        }
        instance_destroy();
    }

    if ((hp > 0) && instance_exists(obj_p_ship)) {
        var spid = 0;
        var o_dist = 0;
        if (class == "Apocalypse Class Battleship") {
            o_dist = 500;
            action = "attack";
            spid = 20;
        }
        if (class == "Nemesis Class Fleet Carrier") {
            o_dist = 1000;
            action = "attack";
            spid = 20;
        }
        if (class == "Leviathan") {
            o_dist = 160;
            action = "attack";
            spid = 20;
        }
        if ((class == "Battle Barge") || (class == "Custodian")) {
            o_dist = 300;
            action = "attack";
            spid = 20;
        }
        if (class == "Desecrator") {
            o_dist = 300;
            action = "attack";
            spid = 20;
        }
        if (class == "Razorfiend") {
            o_dist = 100;
            action = "attack";
            spid = 25;
        }
        if ((class == "Cairn Class") || (class == "Reaper Class")) {
            o_dist = 199;
            action = "attack";
            spid = 25;
            if (class == "Reaper Class") {
                spid = 30;
            }
        }

        if ((class == "Dethdeala") || (class == "Protector") || (class == "Emissary")) {
            o_dist = 200;
            action = "attack";
            spid = 20;
        }
        if (class == "Gorbag's Revenge") {
            o_dist = 200;
            action = "attack";
            spid = 20;
        }
        if ((class == "Kroolboy") || (class == "Slamblasta")) {
            o_dist = 200;
            action = "attack";
            spid = 25;
        }
        if (class == "Battlekroozer") {
            o_dist = 200;
            action = "attack";
            spid = 30;
        }
        if ((class == "Avenger") || (class == "Carnage") || (class == "Daemon")) {
            o_dist = 200;
            action = "attack";
            spid = 20;
        }

        if ((class == "Ravager") || (class == "Iconoclast") || (class == "Castellan") || (class == "Warden")) {
            o_dist = 300;
            action = "attack";
            spid = 35;
        }
        if (class == "Shroud Class") {
            o_dist = 250;
            action = "attack";
            spid = 35;
        }

        if ((class == "Stalker") || (class == "Sword Class Frigate")) {
            o_dist = 100;
            action = "attack";
            spid = 20;
        }
        if (class == "Prowler") {
            o_dist = 100;
            action = "attack";
            spid = 35;
        }
        if (class == "Avenger Class Grand Cruiser") {
            o_dist = 48;
            action = "broadside";
            spid = 20;
        }
        if (class == "Jackal Class") {
            o_dist = 200;
            action = "attack";
            spid = 40;
        }
        if (class == "Dirge Class") {
            o_dist = 200;
            action = "attack";
            spid = 45;
        }

        spid *= speed_bonus;

        var dist = point_distance(x, y, target.x, target.y) - max(sprite_get_width(sprite_index), sprite_get_height(sprite_index));

        if ((target != 0) && (action == "attack")) {
            direction = turn_towards_point(direction, x, y, target.x, target.y, 0.1);
        }
        if ((target != 0) && (action == "broadside") && (dist > o_dist)) {
            if (y >= target.y) {
                dist = point_distance(x, y, target.x + lengthdir_x(64, target.direction - 180), target.y + lengthdir_y(128, target.direction - 90)) - max(sprite_get_width(sprite_index), sprite_get_height(sprite_index));
            }
            if (y < target.y) {
                dist = point_distance(x, y, target.x + lengthdir_x(64, target.direction - 180), target.y + lengthdir_y(128, target.direction + 90)) - max(sprite_get_width(sprite_index), sprite_get_height(sprite_index));
            }
            if ((y > target.y) && (dist > o_dist)) {
                direction = turn_towards_point(direction, x + lengthdir_x(64, target.direction - 180), y, target.x, target.y + lengthdir_y(128, target.direction - 90), 0.2);
            }
            if ((y < target.y) && (dist > o_dist)) {
                direction = turn_towards_point(direction, x + lengthdir_x(64, target.direction - 180), y, target.x, target.y + lengthdir_y(128, target.direction + 90), 0.2);
            }
            if (turn_bonus > 1) {
                if ((y < target.y) && (dist > o_dist)) {
                    direction = turn_towards_point(direction, x + lengthdir_x(64, target.direction - 180), y, target.x, target.y + lengthdir_y(128, target.direction + 90), 0.2);
                }
            }
        }

        if (action == "attack") {
            if ((dist > o_dist) && (speed < (spid / 10))) {
                speed += 0.005;
            }
            if ((dist < o_dist) && (speed > 0)) {
                speed -= 0.025;
            }
        }
        if (action == "broadside") {
            if ((dist > o_dist) && (speed < (spid / 10))) {
                speed += 0.005;
            }
            if ((dist < o_dist) && (speed > 0)) {
                speed -= 0.025;
            }
        }

        if (speed < 0) {
            speed = speed * 0.9;
        }

        if (cooldown[1] > 0) {
            cooldown[1] -= 1;
        }
        if (cooldown[2] > 0) {
            cooldown[2] -= 1;
        }
        if (cooldown[3] > 0) {
            cooldown[3] -= 1;
        }
        if (cooldown[4] > 0) {
            cooldown[4] -= 1;
        }
        if (cooldown[5] > 0) {
            cooldown[5] -= 1;
        }
        if (turret_cool > 0) {
            turret_cool -= 1;
        }

        if ((turrets > 0) && instance_exists(obj_p_small) && (turret_cool == 0)) {
            var targe = instance_nearest(x, y, obj_p_small);
            if (instance_exists(targe)) {
                dist = point_distance(x, y, targe.x, targe.y);
                if ((dist > 64) && (dist < 300)) {
                    var bull = instance_create(x, y, obj_en_round);
                    bull.direction = point_direction(x, y, targe.x, targe.y);
                    if (owner == eFACTION.TYRANIDS) {
                        bull.sprite_index = spr_glob;
                    }
                    bull.speed = 20;
                    bull.dam = 3;
                    bull.image_xscale = 0.5;
                    bull.image_yscale = 0.5;
                    turret_cool = floor(60 / turrets);
                    if (owner == eFACTION.NECRONS) {
                        bull.sprite_index = spr_green_las;
                        bull.image_yscale = 1;
                    }
                    bull.direction += choose(random(10), 1 * -random(10));
                }
            }
        }

        var front = 0;
        var right = 0;
        var left = 0;
        var rear = 0;

        target_l = instance_nearest(x + lengthdir_x(64, direction + 90), y + lengthdir_y(64, direction + 90), obj_p_ship);
        target_r = instance_nearest(x + lengthdir_x(64, direction + 270), y + lengthdir_y(64, direction + 270), obj_p_ship);

        if (collision_line(x, y, x + lengthdir_x(2000, direction), y + lengthdir_y(2000, direction), obj_p_ship, 0, 1)) {
            front = 1;
        }

        lightning = 0;

        for (var i = 1; i <= weapons; i++) {
            var ok = 0;
            var facing = "";
            var ammo = 0;
            var range = 0;
            var wep = "";
            var bull = noone;

            if ((cooldown[i] <= 0) && (weapon[i] != "") && (weapon_ammo[i] > 0)) {
                ok = 1;
            }
            if (ok == 1) {
                facing = weapon_facing[i];
                ammo = weapon_ammo[i];
                range = weapon_range[i];
            }

            var targe = target;
            if ((facing == "front") && (front == 1)) {
                ok = 2;
            }
            if (facing == "most") {
                ok = 2;
            }

            if (facing == "special") {
                ok = 2;
            }
            if (!instance_exists(targe)) {
                exit;
            }
            dist = point_distance(x, y, targe.x, targe.y);

            if ((facing == "right") && (point_direction(x, y, target_r.x, target_r.y) < 337) && (point_direction(x, y, target_r.x, target_r.y) > 203)) {
                ok = 2;
            }
            if ((facing == "left") && (point_direction(x, y, target_r.x, target_r.y) > 22) && (point_direction(x, y, target_r.x, target_r.y) < 157)) {
                ok = 2;
            }

            if ((ok == 2) && (dist < (range + max(sprite_get_width(sprite_index), sprite_get_height(sprite_index))))) {
                if ((ammo > 0) && (ammo < 900)) {
                    ammo -= 1;
                }
                weapon_ammo[i] = ammo;
                cooldown[i] = weapon_cooldown[i];
                wep = weapon[i];
                var dam = weapon_dam[i];

                ok = 3;
                if (ammo < 0) {
                    ok = 0;
                }

                if ((string_count("orpedo", wep) == 0) && (string_count("Interceptor", wep) == 0) && (string_count("ommerz", wep) == 0) && (string_count("Claws", wep) == 0) && (string_count("endrils", wep) == 0) && (ok == 3) && (owner != eFACTION.NECRONS)) {
                    bull = instance_create(x + lengthdir_x(32, direction), y + lengthdir_y(32, direction), obj_en_round);
                    bull.speed = 20;
                    bull.dam = dam;
                    if (targe == target) {
                        bull.direction = point_direction(x + lengthdir_x(32, direction), y + lengthdir_y(32, direction), target.x, target.y);
                    }
                    if (facing != "front") {
                        bull.direction = point_direction(x + lengthdir_x(32, direction), y + lengthdir_y(32, direction), target.x, target.y);
                    }
                    if (string_count("ova", wep) == 1) {
                        bull.image_xscale = 2;
                        bull.image_yscale = 2;
                    }
                    if (string_count("eavy Gunz", wep) == 1) {
                        bull.image_xscale = 1.5;
                        bull.image_yscale = 1.5;
                    }
                    if (string_count("Lance", wep) == 1) {
                        bull.sprite_index = spr_ground_las;
                        bull.image_xscale = 1.5;
                        bull.image_yscale = 1.5;
                    }
                    if (string_count("Ion", wep) == 1) {
                        bull.sprite_index = spr_pulse;
                        bull.image_xscale = 1.5;
                        bull.image_yscale = 1.5;
                    }
                    if (string_count("Rail", wep) == 1) {
                        bull.sprite_index = spr_railgun;
                        bull.image_xscale = 1.5;
                        bull.image_yscale = 1.5;
                    }
                    if (string_count("Gravitic", wep) == 1) {
                        bull.image_xscale = 2;
                        bull.image_yscale = 2;
                    }
                    if (string_count("Plasma", wep) == 1) {
                        bull.sprite_index = spr_ground_plasma;
                        bull.image_xscale = 2;
                        bull.image_yscale = 2;
                        bull.speed = 15;
                    }
                    if (string_count("Pyro-Acid", wep) == 1) {
                        bull.sprite_index = spr_glob;
                        bull.image_xscale = 2;
                        bull.image_yscale = 2;
                    }

                    if ((string_count("Weapons", wep) == 1) && (owner == eFACTION.ELDAR)) {
                        bull.sprite_index = spr_ground_las;
                        bull.image_xscale = 2;
                        bull.image_yscale = 2;
                    }
                    if ((string_count("Pulse", wep) == 1) && (owner == eFACTION.ELDAR)) {
                        bull.sprite_index = spr_pulse;
                        bull.image_xscale = 1.5;
                        bull.image_yscale = 1.5;
                    }
                }
                if ((string_count("orpedo", wep) == 1) && (ok == 3) && (owner != eFACTION.NECRONS)) {
                    if (class != "Ravager") {
                        bull = instance_create(x, y + lengthdir_y(-30, direction + 90), obj_en_round);
                        bull.speed = 10;
                        bull.direction = direction;
                        bull.sprite_index = spr_torpedo;
                        bull.dam = dam;
                    }
                    bull = instance_create(x, y + lengthdir_y(-10, direction + 90), obj_en_round);
                    bull.speed = 10;
                    bull.direction = direction;
                    bull.sprite_index = spr_torpedo;
                    bull.dam = dam;
                    bull = instance_create(x, y + lengthdir_y(10, direction + 90), obj_en_round);
                    bull.speed = 10;
                    bull.direction = direction;
                    bull.sprite_index = spr_torpedo;
                    bull.dam = dam;

                    if (class != "Ravager") {
                        bull = instance_create(x, y + lengthdir_y(30, direction + 90), obj_en_round);
                        bull.speed = 10;
                        bull.direction = direction;
                        bull.sprite_index = spr_torpedo;
                        bull.dam = dam;
                    }
                }

                if (wep == "Lightning Arc") {
                    lightning = 10;
                    if (target.shields > 0) {
                        if ((class == "Cairn Class") || (class == "Reaper Class")) {
                            target.shields -= 20;
                        } else {
                            target.shields -= 20;
                        }
                    }
                    if (target.shields <= 0) {
                        if ((class == "Cairn Class") || (class == "Reaper Class")) {
                            target.hp -= 10;
                        } else {
                            target.hp -= 10;
                        }
                    }
                }
                if (wep == "Gauss Particle Whip") {
                    whip = 15;
                    if (target.shields > 0) {
                        target.shields -= dam;
                    }
                    if (target.shields <= 0) {
                        target.hp -= dam;
                    }
                }
                if ((wep == "Star Pulse Generator") && (ok == 3) && instance_exists(target)) {
                    bull = instance_create(x + lengthdir_x(32, direction), y + lengthdir_y(32, direction), obj_en_pulse);
                    bull.speed = 20;
                    if (targe == target) {
                        bull.direction = point_direction(x + lengthdir_x(32, direction), y + lengthdir_y(32, direction), target.x, target.y);
                    }
                    if (facing != "front") {
                        bull.direction = point_direction(x + lengthdir_x(32, direction), y + lengthdir_y(32, direction), target.x, target.y);
                    }
                    bull.target_x = target.x;
                    bull.target_y = target.y;
                }

                if (((string_count("Claws", wep) == 1) || (string_count("endrils", wep) == 1)) && (ok == 3)) {
                    if (target.shields <= 0) {
                        target.hp -= weapon_dam[wep];
                    }
                    if (target.shields > 0) {
                        target.shields -= weapon_dam[wep];
                    }
                }
                if (((string_count("Interceptor", wep) == 1) || (string_count("ommerz", wep) == 1) || (string_count("Manta", wep) == 1) || (string_count("Glands", wep) == 1) || (string_count("Eldar Launch", wep) == 1)) && (ok == 3)) {
                    bull = instance_create(x, y + lengthdir_y(-30, direction + 90), obj_en_in);
                    bull.direction = self.direction;
                    bull.owner = self.owner;
                }
            }
        }
    }
}
if (owner == 6) {
    image_angle = direction;

    if (obj_fleet.start != 5) {
        exit;
    }

    if ((shields > 0) && (shields < maxshields)) {
        shields += 0.03;
    }

    // Need to every couple of seconds check this
    // with obj_en_ship if not big then disable, check nearest, and activate once more
    if (instance_exists(obj_p_ship)) {
        target = instance_nearest(x, y, obj_p_ship);
    }

    if (hp <= 0) {
        var gud = 0;
        for (var i = 1; i <= 5; i++) {
            if (obj_fleet.enemy[i] == owner) {
                gud = i;
            }
        }

        if (size == 3) {
            obj_fleet.en_capital_lost[gud] += 1;
        }
        if (size == 2) {
            obj_fleet.en_frigate_lost[gud] += 1;
        }
        if (size == 1) {
            obj_fleet.en_escort_lost[gud] += 1;
        }

        image_alpha = 0.5;

        var husk = instance_create(x, y, obj_en_husk);
        husk.sprite_index = sprite_index;
        husk.direction = direction;
        husk.image_angle = image_angle;
        husk.depth = depth;
        husk.image_speed = 0;
        repeat (choose(4, 5, 6)) {
            var explo = instance_create(x, y, obj_explosion);
            explo.image_xscale = 0.5;
            explo.image_yscale = 0.5;
            explo.x += random_range(sprite_width * 0.25, sprite_width * -0.25);
            explo.y += random_range(sprite_width * 0.25, sprite_width * -0.25);
        }

        instance_destroy();
    }

    if ((hp > 0) && instance_exists(obj_p_ship)) {
        var spid = 0;
        var o_dist = 0;
        if (class == "Void Stalker") {
            o_dist = 300;
            action = "swoop";
            spid = 60;
        }
        if (class == "Shadow Class") {
            o_dist = 200;
            action = "swoop";
            spid = 80;
        }
        if ((class == "Hellebore") || (class == "Aconite")) {
            o_dist = 200;
            action = "swoop";
            spid = 100;
        }

        if (target != 0) {
            if (speed < (spid / 10)) {
                speed += 0.02;
            }

            if (instance_exists(target)) {
                var dist = point_distance(x, y, target.x, target.y);

                if (action == "swoop") {
                    direction = turn_towards_point(direction, x, y, target.x, target.y, 5 - ship_size);
                }
                if ((dist <= o_dist) && collision_line(x, y, x + lengthdir_x(o_dist, direction), y + lengthdir_y(o_dist, direction), obj_p_ship, 0, 1)) {
                    action = "attack";
                }
                if ((dist < 300) && (action == "attack")) {
                    action = "bank";
                }
                if (action == "bank") {
                    direction = turn_towards_point(direction, x, y, room_width, room_height / 2, 5 - ship_size);
                }
                if ((action == "bank") && (dist > 700)) {
                    action = "attack";
                }
            }
        }

        if ((y < -2000) || (y > room_height + 2000) || (x < -2000) || (x > room_width + 2000)) {
            hp = -50;
        }

        if (cooldown[1] > 0) {
            cooldown[1] -= 1;
        }
        if (cooldown[2] > 0) {
            cooldown[2] -= 1;
        }
        if (cooldown[3] > 0) {
            cooldown[3] -= 1;
        }
        if (cooldown[4] > 0) {
            cooldown[4] -= 1;
        }
        if (cooldown[5] > 0) {
            cooldown[5] -= 1;
        }
        if (turret_cool > 0) {
            turret_cool -= 1;
        }

        if ((turrets > 0) && instance_exists(obj_p_small) && (turret_cool == 0)) {
            var targe = instance_nearest(x, y, obj_p_small);
            if (instance_exists(targe)) {
                var dist = point_distance(x, y, targe.x, targe.y);
                if ((dist > 64) && (dist < 300)) {
                    var bull = instance_create(x, y, obj_en_round);
                    bull.direction = point_direction(x, y, targe.x, targe.y);
                    if (owner == eFACTION.TYRANIDS) {
                        bull.sprite_index = spr_glob;
                    }
                    if ((owner == eFACTION.TAU) || (owner == eFACTION.ELDAR)) {
                        bull.sprite_index = spr_pulse;
                    }
                    bull.speed = 20;
                    bull.dam = 3;
                    bull.image_xscale = 0.5;
                    bull.image_yscale = 0.5;
                    turret_cool = floor(60 / turrets);
                    bull.direction += choose(random(10), 1 * -random(10));
                }
            }
        }

        var front = 0;
        var right = 0;
        var left = 0;
        var rear = 0;

        target_l = instance_nearest(x + lengthdir_x(64, direction + 90), y + lengthdir_y(64, direction + 90), obj_p_ship);
        target_r = instance_nearest(x + lengthdir_x(64, direction + 270), y + lengthdir_y(64, direction + 270), obj_p_ship);

        if (collision_line(x, y, x + lengthdir_x(2000, direction), y + lengthdir_y(2000, direction), obj_p_ship, 0, 1)) {
            front = 1;
        }

        for (var i = 1; i <= weapons; i++) {
            var ok = 0;
            var facing = "";
            var ammo = 0;
            var range = 0;
            var wep = "";
            var bull = noone;

            if ((cooldown[i] <= 0) && (weapon[i] != "") && (weapon_ammo[i] > 0)) {
                ok = 1;
            }
            if (ok == 1) {
                facing = weapon_facing[i];
                ammo = weapon_ammo[i];
                range = weapon_range[i];
            }

            var targe = target;
            if ((facing == "front") && (front == 1)) {
                ok = 2;
            }
            if (facing == "most") {
                ok = 2;
            }

            if (facing == "special") {
                ok = 2;
            }
            if (!instance_exists(targe)) {
                exit;
            }
            var dist = point_distance(x, y, targe.x, targe.y);

            if ((facing == "right") && (point_direction(x, y, target_r.x, target_r.y) < 337) && (point_direction(x, y, target_r.x, target_r.y) > 203)) {
                ok = 2;
            }
            if ((facing == "left") && (point_direction(x, y, target_r.x, target_r.y) > 22) && (point_direction(x, y, target_r.x, target_r.y) < 157)) {
                ok = 2;
            }

            if ((ok == 2) && (dist < (range + max(sprite_get_width(sprite_index), sprite_get_height(sprite_index))))) {
                if ((ammo > 0) && (ammo < 900)) {
                    ammo -= 1;
                }
                weapon_ammo[i] = ammo;
                cooldown[i] = weapon_cooldown[i];
                wep = weapon[i];
                var dam = weapon_dam[i];

                ok = 3;
                if (ammo < 0) {
                    ok = 0;
                }

                if ((string_count("orpedo", wep) == 0) && (string_count("Interceptor", wep) == 0) && (string_count("ommerz", wep) == 0) && (string_count("Claws", wep) == 0) && (string_count("endrils", wep) == 0) && (ok == 3)) {
                    bull = instance_create(x + lengthdir_x(32, direction), y + lengthdir_y(32, direction), obj_en_round);
                    bull.speed = 20;
                    bull.dam = dam;
                    if (targe == target) {
                        bull.direction = point_direction(x + lengthdir_x(32, direction), y + lengthdir_y(32, direction), target.x, target.y);
                    }
                    if (facing != "front") {
                        bull.direction = point_direction(x + lengthdir_x(32, direction), y + lengthdir_y(32, direction), target.x, target.y);
                    }
                    if (string_count("ova", wep) == 1) {
                        bull.image_xscale = 2;
                        bull.image_yscale = 2;
                    }
                    if (string_count("eavy Gunz", wep) == 1) {
                        bull.image_xscale = 1.5;
                        bull.image_yscale = 1.5;
                    }
                    if (string_count("Lance", wep) == 1) {
                        bull.sprite_index = spr_ground_las;
                        bull.image_xscale = 1.5;
                        bull.image_yscale = 1.5;
                    }
                    if (string_count("Ion", wep) == 1) {
                        bull.sprite_index = spr_pulse;
                        bull.image_xscale = 1.5;
                        bull.image_yscale = 1.5;
                    }
                    if (string_count("Rail", wep) == 1) {
                        bull.sprite_index = spr_railgun;
                        bull.image_xscale = 1.5;
                        bull.image_yscale = 1.5;
                    }
                    if (string_count("Gravitic", wep) == 1) {
                        bull.image_xscale = 2;
                        bull.image_yscale = 2;
                    }
                    if (string_count("Plasma", wep) == 1) {
                        bull.sprite_index = spr_ground_plasma;
                        bull.image_xscale = 2;
                        bull.image_yscale = 2;
                        bull.speed = 15;
                    }
                    if (string_count("Pyro-Acid", wep) == 1) {
                        bull.sprite_index = spr_glob;
                        bull.image_xscale = 2;
                        bull.image_yscale = 2;
                    }

                    if ((string_count("Weapons", wep) == 1) && (owner == eFACTION.ELDAR)) {
                        bull.sprite_index = spr_ground_las;
                        bull.image_xscale = 2;
                        bull.image_yscale = 2;
                    }
                    if ((string_count("Pulse", wep) == 1) && (owner == eFACTION.ELDAR)) {
                        bull.sprite_index = spr_pulse;
                        bull.image_xscale = 1.5;
                        bull.image_yscale = 1.5;
                    }
                }
                if ((string_count("orpedo", wep) == 1) && (ok == 3)) {
                    if (class != "Ravager") {
                        bull = instance_create(x, y + lengthdir_y(-30, direction + 90), obj_en_round);
                        bull.speed = 10;
                        bull.direction = direction;
                        bull.sprite_index = spr_torpedo;
                        bull.dam = dam;
                    }
                    bull = instance_create(x, y + lengthdir_y(-10, direction + 90), obj_en_round);
                    bull.speed = 10;
                    bull.direction = direction;
                    bull.sprite_index = spr_torpedo;
                    bull.dam = dam;
                    bull = instance_create(x, y + lengthdir_y(10, direction + 90), obj_en_round);
                    bull.speed = 10;
                    bull.direction = direction;
                    bull.sprite_index = spr_torpedo;
                    bull.dam = dam;

                    if (class != "Ravager") {
                        bull = instance_create(x, y + lengthdir_y(30, direction + 90), obj_en_round);
                        bull.speed = 10;
                        bull.direction = direction;
                        bull.sprite_index = spr_torpedo;
                        bull.dam = dam;
                    }
                }
                if (((string_count("Claws", wep) == 1) || (string_count("endrils", wep) == 1)) && (ok == 3)) {
                    if (target.shields <= 0) {
                        target.hp -= weapon_dam[wep];
                    }
                    if (target.shields > 0) {
                        target.shields -= weapon_dam[wep];
                    }
                }
                if (((string_count("Interceptor", wep) == 1) || (string_count("ommerz", wep) == 1) || (string_count("Manta", wep) == 1) || (string_count("Glands", wep) == 1) || (string_count("Eldar Launch", wep) == 1)) && (ok == 3)) {
                    bull = instance_create(x, y + lengthdir_y(-30, direction + 90), obj_en_in);
                    bull.direction = self.direction;
                    bull.owner = self.owner;
                }
            }
        }
    }
}
