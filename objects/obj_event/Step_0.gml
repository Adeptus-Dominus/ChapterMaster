if ((fading == 1) && (fade_alpha < 1)) {
    fade_alpha += 0.025;
}
if ((fading == -1) && (fade_alpha > 0)) {
    fade_alpha -= 0.025;
}
if (time_at < time_min) {
    time_at += 0.25;
}
// if (time_at>=time_max) and (stage!=10) then stage=10;
if ((exit_fade >= 0) && (exit_fade < 30)) {
    exit_fade += 1;
}

if ((closing == true) && (fading == -1) && (fade_alpha <= 0)) {
    if (obj_controller.fest_type == "Great Feast") {
        if (obj_controller.fest_feature1 == 1) {
            obj_controller.fest_feasts += 1;
        }
        if (obj_controller.fest_feature2 == 1) {
            obj_controller.fest_boozes += 1;
        }
        if (obj_controller.fest_feature3 == 1) {
            obj_controller.fest_drugses += 1;
        }
    }

    for (var ide = 1; ide <= 700; ide++) {
        var unit = obj_ini.TTRPG[attend_co[ide]][attend_id[ide]];
        if ((attend_corrupted[ide] == 0) && (attend_id[ide] > 0)) {
            if (array_contains(obj_ini.artifact_tags[obj_controller.fest_display], "chaos")) {
                unit.corruption += choose(1, 2, 3, 4);
            }
            if (array_contains(obj_ini.artifact_tags[obj_controller.fest_display], "daemonic")) {
                unit.corruption += choose(6, 7, 8, 9);
            }
            attend_corrupted[ide] = 1;
        }
    }

    obj_controller.fest_repeats -= 1;
    if (obj_controller.fest_repeats <= 0) {
        obj_controller.fest_scheduled = 0;

        var p1 = obj_controller.fest_type;
        var p2 = obj_controller.fest_planet;
        var p3 = (p2 > 0) ? string(obj_controller.fest_star) + " " + scr_roman(obj_controller.fest_wid) : " the vessel '" + string(obj_ini.ship[obj_controller.fest_sid]) + "'";

        scr_alert("green", "event", string(p1) + " on " + string(p3) + " ends.", 0, 0);
        scr_event_log("green", string(p1) + " on " + string(p3) + " ends.", p3);
    }

    with (obj_popup) {
        if (number != 0) {
            obj_turn_end.alarm[1] = 10;
        }
        instance_destroy();
    }
    obj_controller.cooldown = 30;
    instance_destroy();
}

if ((stage >= 5) && (stage != 10)) {
    ticks += 1;
    if (ticks >= next_display) {
        ticks = 0;
        ticked = 1;
    }
}

if (ticked == 1) {
    // Select a random marine and have them perform an action
    if ((lines_acted == 18) && (exit_fade <= -1)) {
        exit_fade = 0;
    }

    if ((lines_acted == 18) && (part2 != "")) {
        var textt = "";
        if (part2 == "fish") {
            if (attendants <= 30) {
                textt = "Chapter Serfs ferry out several large, covered dishes, the scent of seafood filling the air.  Once they are set front and center the silver cloches are removed, revealing a banquet of exotic fish.  Raw rolls of meat with rice, pufferfish, and even a massive broadbill are contained within.";
            }
            if (attendants > 30) {
                textt = "Chapter Serfs ferry out several large, covered dishes, the scent of seafood filling the air.  Once they are set front and center the silver cloches are removed, revealing a banquet of exotic fish.  Raw rolls of meat with rice, pufferfish, and several massive broadbill are contained within.";
            }
        }
        if (part2 == "fruit") {
            textt = "Chapter Serfs ferry out several large, covered bowls.  Without further adeiu the lids are removed, revealing a large bounty of exotic fruits from across the galaxy.  Ploin, pineapple, mangos, strawberries, the fruit ranges from commonplace to nearly disappeared treasures.";
        }
        scr_event_newlines(textt);
        lines_acted += 1;
        time_min += 10;
        ticks = -120;
        ticked = 0;
        stage = 6;
        exit;
    }
    if ((lines_acted == 36) && (part3 != "")) {
        var textt = "";
        if (part3 == "lobster") {
            textt = "A small army of Chapter Serfs and servitors enter the room, carrying with them a truly massive silver plate.  Bore much like a palanquin, the massive dish is covered by an equally large and decorated cloche.  As the main course inches across the room it gathers quite the number of looks.  After struggling a bit the dish is set front and center in the room, the lid removed.  Contained within is a giant, boiled Deathcoleri from Zeriah II.  The once spikey carapace is now a healthily cooked red, the crustacean smelling absolutely delicious.";
        }
        scr_event_newlines(textt);
        lines_acted += 1;
        time_min += 10;
        ticks = -210;
        ticked = 0;
        stage = 7;
        exit;
    }

    var ide = floor(random(attendants)) + 1;
    var unit = obj_ini.TTRPG[attend_co[ide]][attend_id[ide]];
    var textt = "";
    var doso = false;
    var activity = "";
    var dire = 0;
    var orig = 0;
    var rando = choose(1, 2);
    var dice1 = floor(random(100)) + 1;
    var dice2 = floor(random(100)) + 1;
    var dice3 = floor(random(100)) + 1;
    var dice4 = floor(random(100)) + 1;
    var good = true;

    // If this marine has already acted then look for a nearby marine that has yet to act
    if (attend_displayed[ide] > 0) {
        dire = (attend_displayed[ide] <= attendants / 2) ? -1 : 1;
        orig = ide;
    }

    // Cycle downward
    if (dire == -1) {
        good = false;
        for (var resp = ide - 1; resp >= 0; resp--) {
            if (attend_displayed[resp] == 0) {
                good = true;
                break;
            }
        }

        dire = (good) ? 0 : 1;
    }

    // Cycle upward
    if (dire == 1) {
        good = false;
        for (var resp = 0; resp < attendants; resp++) {
            if (attend_displayed[resp] == 0) {
                good = true;
                break;
            }
        }
    }

    if ((dire != 0) && (good == false)) {
        ide = orig;
        good = true;
    }

    if (attend_confused[ide] > 0) {
        if (dice1 <= 70) {
            if (obj_controller.fest_type == "Great Feast") {
                doso = false;
                activity = "confused";
            }
        }
        if (dice1 > 70) {
            doso = true;
        }
    }
    if ((attend_confused[ide] <= 0) && (activity == "")) {
        doso = true;
    }
    if (doso == true) {
        dice1 = floor(random(100)) + 1;
        dice2 = floor(random(100)) + 1;
        dice3 = floor(random(100)) + 1;
        dice4 = floor(random(100)) + 1;

        if (obj_controller.fest_type == "Great Feast") {
            // Get chances of random crap when in a Great Feast
            var mod1 = 0;
            var mod2 = unit.corruption / 5;
            var mod3 = unit.corruption / 10;

            var rep1 = 1;
            var rep2 = attend_drunk[ide] + 1;
            var rep3 = attend_high[ide] + 1;

            activity = "talk";

            if ((dice3 <= min(75, (((obj_controller.fest_drugses * 10) - 10) + mod3) / rep3)) && (obj_controller.fest_feature3 > 0)) {
                activity = "drugs";
            }
            if ((dice2 <= min(75, (((obj_controller.fest_boozes * 20) - 10) + mod2) / rep2)) && (obj_controller.fest_feature2 > 0)) {
                activity = "drink";
            }
            if ((dice1 <= min(75, ((obj_controller.fest_feasts * 30) + mod1) / rep1)) && (obj_controller.fest_feature1 > 0)) {
                activity = "eat";
            }
            if (((global.chapter_name == "Space Wolves") || (obj_ini.progenitor == ePROGENITOR.SPACE_WOLVES)) && (obj_controller.fest_feature2 > 0) && activity != "drink") {
                rando = choose(1, 1, 2);
                if (rando == 2) {
                    activity = "drink";
                }
            }
            rando = choose(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
            if (rando >= 8) {
                activity = "talk";
            }

            if ((obj_controller.fest_display > 0) && (dice4 <= 15)) {
                activity = "artifact";
            }
        }
    }

    if (activity == "confused") {
        rando = choose(1, 2, 2, 3);
        if (rando == 1) {
            textt = unit.name_role() + " is unsure of what to do.  He sits at the table silently, doing nothing.";
        }
        if (rando == 2) {
            textt = unit.name_role() + " is confused.  He sits at the table and does nothing, wishing he were " + choose("killing xenos", "praying", "training", "training", "studying") + " instead.";
        }

        // Special CONFUS for the various event types
        if (rando == 3) {
            if ((obj_controller.fest_type == "Great Feast") && (obj_controller.fest_feature1 > 0)) {
                textt = unit.name_role() + " picks up silverwear to begin to feast, but then has second thoughts and puts them back down.";
            }
            if ((obj_controller.fest_type == "Great Feast") && (obj_controller.fest_feature1 <= 0)) {
                textt = unit.name_role() + " is unsure of what to do.  He sits at the table silently, doing nothing.";
            }
        }
    }
    if (activity == "eat") {
        var eater_type = 1;
        if (global.chapter_name == "Space Wolves" || obj_ini.progenitor == ePROGENITOR.SPACE_WOLVES) {
            eater_type = 2;
        }

        if ((stage == 5) && (eater_type == 1)) {
            rando = choose(1, 2, 3);
            if (rando == 1) {
                textt = unit.name_role() + " digs into the food and begins to eat.";
            }
            if (rando == 2) {
                textt = unit.name_role() + " begins to feast, eating the food slowly to enjoy the taste.";
            }
            if (rando == 3) {
                textt = unit.name_role() + " grabs a portion of food for himself and begins to eat.";
            }
        }
        if ((stage == 5) && (eater_type == 2)) {
            rando = choose(1, 2, 3);
            if (rando == 1) {
                textt = unit.name_role() + " digs into the food and begins to eat.";
            }
            if (rando == 2) {
                textt = unit.name_role() + " makes a show out of eating, consuming the food as loudly and dramaticaly as possible.";
            }
            if (rando == 3) {
                textt = unit.name_role() + " begins to stuff their face full of food, hardly bothering to chew.";
            }
        }
        if (stage == 6) {
            if (part2 == "fish") {
                rando = choose(1, 2, 3, 3, 3);
                if (rando == 1) {
                    textt = unit.name_role() + " selects some of the sushi rolls and begins to pop them into his mouth.";
                }
                if (rando == 2) {
                    textt = unit.name_role() + " chooses a bit of each dish, chapter serfs setting up quite the variety of foods on his plate.";
                }
                if (rando == 3) {
                    textt = unit.name_role() + " grabs a portion of the broadbill and begins to eat it slowly, savoring the taste.";
                }
            }
            if (part2 == "fruit") {
                rando = choose(1, 2, 3, 3, 3);
                if (rando == 1) {
                    textt = unit.name_role() + " selects an assortment of fruit and begins to eat.";
                }
                if (rando == 2) {
                    textt = unit.name_role() + " finishes up the rest of his plate, and hails a serf to bring him some " + choose("pineapple", "strawberries", "grapes", "apples", "oranges", "of each fruit") + ".";
                }
                if (rando == 3) {
                    textt = unit.name_role() + " hails a chapter serf, and orders a variety of different fruits.  He then eats them slowly, enjoying the taste.";
                }
            }
        }
        if (stage == 7) {
            if (part3 == "lobster") {
                rando = choose(1, 2, 2, 3, 3);
                if (eater_type == 2) {
                    rando = choose(1, 2, 2, 3, 3, 4);
                }
                if (rando == 1) {
                    textt = unit.name_role() + " helps break open one of the massive legs of the Deathcoleri, then scoops out some of the meat within.";
                }
                if ((rando == 2) && (eater_type == 1)) {
                    textt = unit.name_role() + " tears some of the tendrils free from the crustacean and begins to eat them.";
                }
                if ((rando == 3) && (eater_type == 1)) {
                    textt = unit.name_role() + " rips some of the delectable meat free from the Deathcoleri's leg, and then eats it slowly, enjoying the treat.";
                }
                if ((rando == 2) && (eater_type == 2)) {
                    textt = unit.name_role() + " begins to shovel Deathcoleri meat down his throat, boasting that he will eat more than anyone else.";
                }
                if ((rando == 3) && (eater_type == 2)) {
                    textt = unit.name_role() + " rips tendrils free from the crustaceans face and begins to eat them, loudly.";
                }
                if (rando == 4) {
                    text = unit.name_role() + " wants the good parts.  He shoves his arm through the beast's shell and scoops out the innards, taking some for himself and sharing other bits.";
                }
            }
        }

        attend_feasted[ide] += 1;
    }
    if (activity == "drink") {
        var eater_type = 1;
        if (global.chapter_name == "Space Wolves" || obj_ini.progenitor == ePROGENITOR.SPACE_WOLVES) {
            eater_type = 2;
        }
        if (global.chapter_name == "Blood Angels" || obj_ini.progenitor == ePROGENITOR.BLOOD_ANGELS) {
            eater_type = 3;
        }

        if (eater_type == 1) {
            if (attend_drunk[ide] <= 0) {
                textt = unit.name_role() + " hails a serf and has " + choose("him", "her") + " pour some Amasec.";
            }
            if (attend_drunk[ide] > 0) {
                textt = unit.name_role() + " sips at his Amasec, " + choose("enjoying the taste", "judging the quality", "savoring the treat") + ".";
            }
        }
        if (eater_type == 2) {
            rando = choose(1, 2, 3);
            if (rando == 1) {
                textt = unit.name_role() + " pounds down Mjod, the concoction already beginning to inebriate the astartes.";
            }
            if (rando == 2) {
                textt = unit.name_role() + " boasts that he will outdrink anyone, and then pounds down his tankard.  Nearby battlebrothers laugh and begin to meet his challenge.";
            }
            if (rando == 3) {
                textt = unit.name_role() + " begins to drink down Mjod, a large frothing glass of the substance in each hand.  He alternates between the two.";
            }
        }
        if (eater_type == 3) {
            if (attend_drunk[ide] <= 0) {
                textt = unit.name_role() + " hails a serf and has " + choose("him", "her") + " pour him a glass of " + choose("red wine", "Amasec", "Dammassine") + ".";
            }
            if (attend_drunk[ide] > 0) {
                textt = unit.name_role() + " sips at his drink slowly, " + choose("enjoying the taste", "judging the quality", "analyzing the components") + ".";
            }
        }

        attend_drunk[ide] += 1;
    }
    if (activity == "drugs") {
        attend_high[ide] += 1;
        unit.corruption = min(100, unit.corruption + 10);
        if (attend_high[ide] <= 1) {
            textt = unit.name_role() + " snorts up a line of powder through a straw.  Why not?";
        }
        if (attend_high[ide] > 1) {
            textt = unit.name_role() + " snorts another line of powder.";
        }
    }

    if (activity == "talk") {
        textt = scr_event_gossip(ide);
    }

    if (activity == "artifact") {
        var spesh = "";
        var woa = string(obj_ini.artifact[obj_controller.fest_display]);
        var nerves_spesh = [
            "GOAT",
            "CHE",
            "THI",
            "TENTACLES",
            "JUM",
            "PRE",
        ];
        for (var sp = 0; sp < array_length(nerves_spesh); sp++) {
            if (array_contains(obj_ini.artifact_tags[obj_controller.fest_display], nerves_spesh[sp])) {
                spesh = "nerves";
                break;
            }
        }

        if (array_contains(obj_ini.artifact_tags[obj_controller.fest_display], "DYI")) {
            spesh = "offend";
        }

        if (array_contains(obj_ini.artifact_tags[obj_controller.fest_display], "MNR")) {
            spesh = "minor";
        }
        textt = unit.name_role();

        if (spesh == "") {
            rando = choose(1, 2, 3, 4, 5);
            if (rando == 1) {
                textt += "inspects the " + string(woa) + " on display, admiring the craftsmanship.";
            }
            if (rando == 2) {
                textt += "gazes at the " + string(woa) + " Artifact, wondering of its origins.";
            }
            if (rando == 3) {
                textt += "seems enamored with the " + string(woa) + " on display.";
            }
            if (rando == 4) {
                textt += "asks one of his nearby battle brothers what they know of the " + string(woa) + " on display.";
            }
            if (rando == 5) {
                textt += "stares at the " + string(woa) + ", not quite sure what to make of it.";
            }
        }
        if ((spesh == "nerves") || (spesh == "offend")) {
            rando = choose(1, 2, 3);
            if (rando == 1) {
                textt += "is unsettled by the " + string(woa) + " Artifact.";
            }
            if (rando == 2) {
                textt += "stares at the " + string(woa) + ", not quite sure what to make of it.";
            }
            if (rando == 3) {
                textt += "has no idea why anyone would choose to make the " + string(woa) + " on display.";
            }
        }
        if (spesh == "minor") {
            rando = choose(1, 2, 3);
            if (rando == 1) {
                textt += "is unimpressed by the " + string(woa) + " Artifact.";
            }
            if (rando == 2) {
                textt += "has seen finer " + string(woa) + " than the one on display.";
            }
            if (rando == 3) {
                textt += "inspects the " + string(woa) + " on display.  He has seen more impressive ones before.";
            }
        }

        if (attend_corrupted[ide] == 0) {
            if (array_contains(obj_ini.artifact_tags[obj_controller.fest_display], "chaos")) {
                unit.corruption += choose(1, 2, 3, 4);
            }
            if (array_contains(obj_ini.artifact_tags[obj_controller.fest_display], "daemonic")) {
                unit.corruption += choose(6, 7, 8, 9);
            }
            attend_corrupted[ide] = 1;
        }
    }

    if (textt != "") {
        scr_event_newlines(textt);
        textt = "";
        attend_confused[ide] -= 1;
        attend_displayed[ide] += 1;
        lines_acted += 1;
        time_min += 10;
        liness += 1;

        if (time_min > time_max) {
            time_min = time_max;
        }
    }

    ticked = 0;
}

if (liness > (attendants / 2)) {
    attend_displayed = array_create(1500, 0);
    liness = 0;
}
