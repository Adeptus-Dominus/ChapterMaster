// This will create a system, with all the planet setup. It also does naming of stars, eldar craft worlds and space hulks
if ((obj_controller.craftworld == 0) && (space_hulk == 0)) {
    var test, oldx, oldy;
    oldx = x;
    oldy = y;
    x -= 5000;
    y -= 5000;
    test = instance_nearest(oldx + choose(random(200), 1 * -random(200)), oldy + choose(random(200), 1 * -random(200)), obj_star);
    x2 = test.x;
    y2 = test.y;
    x = oldx;
    y = oldy;
}
// Generate star name
for (var i = 0; i < 80; i++) {
    if (((name == "random") || (name == "")) && (craftworld == 0) && (space_hulk == 0)) {
        var new_star_name = global.name_generator.generate_star_name();
        name = new_star_name;
        obj_controller.star_names += new_star_name; // TODO make sure it's always unique. Although star_names should just be removed, frankly.
    }
    if ((name == "") && craftworld) {
        global.name_generator.generate_eldar_name(3);
    }
}
// Sets up an eldar craftworld
if (obj_controller.craftworld && (space_hulk == 0)) {
    star = "craftworld";
    sprite_index = spr_craftworld;
    image_index = 0;
    image_speed = 0;
    planets = 1;
    p_type[1] = "Craftworld";
    heresy = -999;
    p_owner[1] = 6;
    p_first[1] = 6;
    owner = eFACTION.ELDAR;
    p_population[1] = floor(random_range(150000, 300000));
    p_fortified[1] = 6;
    p_eldar[1] = 6;
    old_x = x;
    old_y = y;
    exit;
}
// Sets up the space hulk
if (space_hulk == 1) {
    star = "space_hulk";
    sprite_index = spr_star_hulk;
    image_index = 0;
    image_speed = 0;
    planets = 1;
    p_type[1] = "Space Hulk";
    heresy = -999;
    p_owner[1] = 2;
    p_population[1] = 0;
    p_fortified[1] = 5;

    var faction = choose(7, 9, 9, 9, 9, 9, 10);
    if (faction == eFACTION.ORK) {
        p_orks[1] = choose(3, 4, 5);
    }
    if (faction == eFACTION.TYRANIDS) {
        p_tyranids[1] = choose(3, 4, 5);
    }
    if (faction == eFACTION.CHAOS) {
        p_traitors[1] = choose(2, 3, 4);
    }

    p_first[1] = faction;

    old_x = x;
    old_y = y;
    p_owner[1] = faction;
    vision = 1;
    exit;
}
// Sets up the star type
var rui = choose(0, 0, 0, 0, 1, 1, 2, 2, 3, 4, 5);
switch (rui) {
    case 0:
        star = "orange1";
        image_index = 0;
        break;
    case 1:
        star = "orange2";
        image_index = 1;
        break;
    case 2:
        star = "red";
        image_index = 2;
        break;
    case 3:
        star = "white1";
        image_index = 3;
        break;
    case 4:
        star = "white2";
        image_index = 4;
        break;
    case 5:
        star = "blue";
        image_index = 5;
        break;
}
image_speed = 0;
image_alpha = 1;
// Sets up number of planets per star
switch (star) {
    case "orange1":
    case "orange2":
        planets = choose(1, 2, 3, 3, 4);
        break;
    case "red":
        planets = choose(1, 2, 3);
        break;
    case "white1":
    case "white2":
        planets = choose(1, 1, 2);
        break;
    case "blue":
        planets = 1;
        break;
}
// Sets the planet type and owners
switch (star) {
    case "orange1":
    case "orange2":
        for (rui = 1; rui <= 4; rui++) {
            if (planets >= rui) {
                planet[rui] = 1;
                p_type[rui] = choose("Temperate", "Temperate", choose("Temperate", "Shrine"), "Feudal", "Agri", "Death", "Desert", "Ice", "Hive");
                if (p_type[rui] == "Agri" || p_type[rui] == "Hive") {
                    p_owner[rui] = 2;
                    p_first[rui] = 2;
                }
            }
        }
        break;
    case "red":
        for (rui = 1; rui <= 4; rui++) {
            if (planets >= rui) {
                planet[rui] = 1;
                p_type[rui] = choose(choose("Temperate", "Temperate", "Temperate", "Feudal", "Feudal", "Shrine"), "Desert", "Dead", "Hive", "Lava");
            }
        }
        break;
    case "white1":
    case "white2":
        for (rui = 1; rui <= 4; rui++) {
            if (planets >= rui) {
                planet[rui] = 1;
                p_type[rui] = choose(choose("Temperate", "Temperate", "Temperate", "Feudal", "Feudal", "Shrine"), "Death", "Ice", "Hive", "Dead");
            }
        }
        break;
    case "blue":
        for (rui = 1; rui <= 4; rui++) {
            if (planets >= rui) {
                planet[rui] = 1;
                p_type[rui] = choose(choose("Temperate", "Temperate", "Temperate", "Feudal", "Feudal", "Shrine"), "Ice", "Ice", "Dead", "Dead");
            }
        }
        break;
}

// Premade systems with planet types
switch (name) {
    case "Kim Jong":
        planets = 3;
        p_type[1] = "Dead";
        planet[1] = 1;
        p_type[2] = "Temperate";
        planet[2] = 1;
        p_type[3] = "Dead";
        planet[3] = 1;
        break;
    case "Muric":
        planets = 4;
        p_type[1] = "Hive";
        planet[1] = 1;
        p_type[2] = "Temperate";
        planet[2] = 1;
        p_type[3] = "Agri";
        planet[3] = 1;
        p_type[4] = "Agri";
        planet[4] = 1;
        break;
    case "Morrowynd":
        planets = 3;
        p_type[1] = "Feudal";
        planet[1] = 1;
        array_push(p_feature[1], new NewPlanetFeature(eP_FEATURES.NECRON_TOMB));
        p_type[2] = "Dead";
        planet[2] = 1;
        p_type[3] = "Dead";
        planet[3] = 1;
        break;
}

var a = 99, b = 99, c = 99, d = 99, e = "", f = 0, g = "", h = 0;
// Sets up points value for each planet on the system
// TODO in here the map generation should be called for each planet
for (var i = 0; i < 10; i++) {
    e = p_type[1];
    switch (e) {
        case "Lava":
            a = 1;
            break;
        case "Desert":
            a = 2;
            break;
        case "Hive":
            a = 3;
            break;
        case "Death":
            a = 4;
            break;
        case "Agri":
            a = 5;
            break;
        case "Temperate":
            a = 6;
            break;
        case "Feudal":
            a = choose(5.5, 6.5);
            break;
        case "Shrine":
            a = choose(5.6, 6.6);
            break;
        case "Ice":
            a = 7;
            break;
        case "Dead":
            a = 1;
            break;
    }
    e = p_type[2];
    switch (e) {
        case "Lava":
            b = 1;
            break;
        case "Desert":
            b = 2;
            break;
        case "Hive":
            b = 3;
            break;
        case "Death":
            b = 4;
            break;
        case "Agri":
            b = 5;
            break;
        case "Temperate":
            b = 6;
            break;
        case "Feudal":
            b = choose(5.5, 6.5);
            break;
        case "Shrine":
            b = choose(5.6, 6.6);
            break;
        case "Ice":
            b = 7;
            break;
        case "Dead":
            b = 2.5;
            break;
    }
    e = p_type[3];
    switch (e) {
        case "Lava":
            c = 1;
            break;
        case "Desert":
            c = 2;
            break;
        case "Hive":
            c = 3;
            break;
        case "Death":
            c = 4;
            break;
        case "Agri":
            c = 5;
            break;
        case "Temperate":
            c = 6;
            break;
        case "Feudal":
            c = choose(5.5, 6.5);
            break;
        case "Shrine":
            c = choose(5.6, 6.6);
            break;
        case "Ice":
            c = 7;
            break;
        case "Dead":
            c = 3.5;
            break;
    }
    e = p_type[4];
    switch (e) {
        case "Lava":
            d = 1;
            break;
        case "Desert":
            d = 2;
            break;
        case "Hive":
            d = 3;
            break;
        case "Death":
            d = 4;
            break;
        case "Agri":
            d = 5;
            break;
        case "Temperate":
            d = 6;
            break;
        case "Feudal":
            d = choose(5.5, 6.5);
            break;
        case "Shrine":
            d = choose(5.6, 6.6);
            break;
        case "Ice":
            d = 7;
            break;
        case "Dead":
            d = 4.5;
            break;
    }
    // Arranges planets based on which type got assigned to what order
    if (d < c) {
        f = c;
        e = p_type[3];
        c = d;
        p_type[3] = p_type[4];
        p_type[4] = e;
        d = f;
    }
    if (c < b) {
        f = b;
        e = p_type[2];
        b = c;
        p_type[2] = p_type[3];
        p_type[3] = e;
        c = f;
    }
    if (b < a) {
        f = a;
        e = p_type[1];
        a = b;
        p_type[1] = p_type[2];
        p_type[2] = e;
        b = f;
    }
}

if (p_type[1] != "") {
    p_owner[1] = 2;
    p_first[1] = 2;
}
if (p_type[2] != "") {
    p_owner[2] = 2;
    p_first[2] = 2;
}
if (p_type[3] != "") {
    p_owner[3] = 2;
    p_first[3] = 2;
}
if (p_type[4] != "") {
    p_owner[4] = 2;
    p_first[4] = 2;
}

if (p_type[1] != "Dead") {
    p_heresy[1] = floor(random(10)) + 1;
}
if (p_type[2] != "Dead") {
    p_heresy[2] = floor(random(10)) + 1;
}
if (p_type[3] != "Dead") {
    p_heresy[3] = floor(random(10)) + 1;
}
if (p_type[4] != "Dead") {
    p_heresy[4] = floor(random(10)) + 1;
}
