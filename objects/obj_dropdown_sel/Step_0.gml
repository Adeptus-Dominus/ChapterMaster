if ((obj_controller.menu != my_menu) && (my_menu == 12.1)) {
    obj_controller.fest_repeats = 0;
}
if (obj_controller.menu != my_menu) {
    instance_destroy();
}

if (target == "event_type") {
    with (obj_controller) {
        fest_cost = 0;

        if (fest_type == "Great Feast") {
            fest_cost = fest_lav * 20;
            if (fest_lav == 0) {
                fest_cost = 20;
            }
            if (fest_locals > 0) {
                fest_cost += 20 * fest_locals;
            }
            var tt = fest_cost;
            if (fest_feature1 == 0) {
                fest_cost = 0;
            }
            if (fest_feature2 > 0) {
                fest_cost += round(tt / 2);
            }
            if (fest_feature3 > 0) {
                fest_cost += tt;
            }
        }
        if ((fest_type == "Tournament") || (fest_type == "Deathmatch")) {
            fest_cost = fest_lav * 20;
            if (fest_lav == 0) {
                fest_cost = 20;
            }
            if (fest_locals > 0) {
                fest_cost += 20 * fest_locals;
            }
            var tt = fest_cost;

            if (fest_feature2 > 0) {
                fest_cost += 30;
            }
            if ((fest_type == "Tournament") && (fest_feature3 > 0)) {
                fest_cost += 100;
            }
        }
        if (fest_type == "Chapter Relic") {
            if (fest_feature1 == 1) {
                fest_cost = 800;
            }
            if (fest_feature2 == 1) {
                fest_cost = 650;
            }
            if (fest_feature3 == 1) {
                fest_cost = 300;
            }
            fest_cost += fest_lav * 20;
            if (fest_lav == 0) {
                fest_cost += 20;
            }
        }
        if (fest_type == "Imperial Mass") {
            fest_cost = fest_lav * 40;
            if (fest_lav == 0) {
                fest_cost = 40;
            }
            if (fest_locals > 0) {
                fest_cost += 40 * fest_locals;
            }
            var tt = fest_cost;
            if (fest_feature2 > 0) {
                fest_cost += 100;
            }
            if (fest_feature3 > 0) {
                fest_cost += 50;
            }
        }
        if (fest_type == "Chapter Sermon") {
            fest_cost = fest_lav * 20;
            if (fest_lav == 0) {
                fest_cost = 20;
            }
            if (fest_locals > 0) {
                fest_cost += 20 * fest_locals;
            }
            var tt = fest_cost;
            if (fest_feature2 > 0) {
                fest_cost += round(tt / 2);
            }
            if (fest_feature3 > 0) {
                fest_cost += tt;
            }
        }
        if (fest_type == "Triumphal March") {
            fest_cost = fest_lav * 10;
            if (fest_lav == 0) {
                fest_cost = 10;
            }
            if (fest_locals > 0) {
                fest_cost += 10 * fest_locals;
            }
            var tt = fest_cost;
            if (fest_feature1 > 0) {
                fest_cost += tt;
            }
        }

        if ((fest_cost > 0) && (fest_repeats > 1)) {
            fest_cost = fest_cost * fest_repeats;
        }
    }
}
if (target == "event_honor") {
    if (option_selected > 0) {
        obj_controller.fest_honoring = option_id[option_selected];
    }
    if (option_selected == 0) {
        obj_controller.fest_honoring = 0;
    }
}

if ((target == "event_loc") && (determined_planets == 0)) {
    // Fill out the options for planets

    for (var coo = 0; coo <= 10; coo++) {
        for (var ide = 1; ide <= 300; ide++) {
            var _unit = fetch_unit([coo, ide]);
            if ((_unit.role() != obj_ini.role[100][6]) && (_unit.role() != "Venerable " + string(obj_ini.role[100][6])) && (_unit.planet_location > 0)) {
                var stahp = 0;
                var first_open = 0;

                for (var q = 1; q <= 100; q++) {
                    if ((star[q] == "") && (first_open == 0)) {
                        first_open = q;
                    }
                    if (star[q] == _unit.location_string && star_planet[q] == _unit.planet_location) {
                        stahp = 1;
                        star_mahreens[q] += 1;
                        break;
                    }
                }
                if (stahp == 0) {
                    star[first_open] = _unit.location_string;
                    star_planet[first_open] = _unit.planet_location;
                    star_mahreens[first_open] = 1;
                }
            }
        }
    }

    determined_planets = 1;
}

if (target == "event_public") {
    if ((obj_controller.fest_warp == 1) && (options != 1)) {
        option_selected = 1;
        options = 1;
    }
    if ((obj_controller.fest_warp == 0) && (options == 1)) {
        options = 4;
    }

    if (options > 1) {
        if (obj_controller.fest_type == "Tournament") {
            option[2] = "";
            option[3] = "";
            options = 1;
        }
        if (obj_controller.fest_type == "Deathmatch") {
            option[2] = "";
            option[3] = "";
            options = 1;
        }
        if (obj_controller.fest_type == "Chapter Relic") {
            option[2] = "";
            option[3] = "";
            options = 1;
        }
        if (obj_controller.fest_type == "Triumphal March") {
            option[2] = "";
            option[3] = "";
            options = 1;
        }
    }
}

if (option[1] == "") {
    option = array_create(50, "");
    option_id = array_create(50, 0);

    if (target == "event_type") {
        option[1] = "Great Feast";
        option[2] = "Tournament";
        option[3] = "Deathmatch";
        option[4] = "Imperial Mass";
        option[5] = "Chapter Sermon";
        option[6] = "Chapter Relic";
        option[7] = "Triumphal March";
        options = 7;
        option_selected = 1;
    }
    if (target == "event_loc") {
        var works = 1;
        var thatone = false;
        option[1] = "None Selected";
        option_id[1] = -50;
        options = 1;
        option_selected = 1;

        // Present ship options
        if (obj_controller.fest_planet == 0) {
            for (var i = 1; i <= 70; i++) {
                thatone = false;
                if ((obj_ini.ship[i] != "") && (obj_ini.ship_carrying[i] > 0)) {
                    works += 1;
                    option[works] = obj_ini.ship[i];
                    option_id[works] = i;
                    options += 1;
                    thatone = false;
                }
            }
        }

        // Present planet options
        if (obj_controller.fest_planet == 1) {
            for (var i = 1; i <= 80; i++) {
                if ((star[i] != "") && (star_mahreens[i] > 0)) {
                    options += 1;
                    option_star[options] = string(star[i]);
                    option[options] = string(star[i]) + " " + scr_roman(star_planet[i]);
                    option_id[options] = star_planet[i];
                }
            }
        }
    }
    if (target == "event_lavish") {
        option[1] = "Humble";
        option[2] = "Minor Expenses";
        option[3] = "Opulent";
        option[4] = "Lavish";
        option[5] = "Excessive";
        option_selected = 1;
        options = 5;
    }
    if (target == "event_display") {
        var arti_work = 1;
        var thatone = false;
        option[1] = "None";
        option_id[1] = -50;
        options = 1;
        option_selected = 1;

        for (var i = 1; i <= obj_controller.artifacts; i++) {
            thatone = false;

            if (obj_ini.artifact[i] == "Casket") {
                thatone = true;
            }
            if (obj_ini.artifact[i] == "Chalice") {
                thatone = true;
            }
            if (obj_ini.artifact[i] == "Statue") {
                thatone = true;
            }
            if (obj_ini.artifact[i] == "Tome") {
                thatone = true;
            }
            if (obj_ini.artifact[i] == "Robot") {
                thatone = true;
            }

            if (thatone == true) {
                arti_work += 1;
                option[arti_work] = obj_ini.artifact[i];
                option_id[arti_work] = i;
                options += 1;
                thatone = false;
            }
        }

        // Other big of logic, get eligible artifacts
    }
    if (target == "event_repeat") {
        option[1] = "Do not repeat";
        option[2] = "Repeat once";
        option[3] = "Repeat twice";
        option[4] = "Repeat thrice";
        option[5] = "Year-long event";
        options = 5;
        option_selected = 1;

        if (obj_controller.fest_type == "Chapter Relic") {
            options = 1;
            option_selected = 1;
        }
    }
    if (target == "event_honor") {
        option[1] = "No One";
        option_id[1] = 0;
        option[2] = "Yourself";
        option_id[2] = 1;
        option[3] = "Specific Company";
        option_id[3] = 2;
        option[4] = "Specific Marine";
        option_id[4] = 3;
        option[5] = "Specific Faction";
        option_id[5] = 4;
        options = 5;
        option_selected = 1;

        if (obj_controller.fest_type == "Imperial Mass") {
            option[1] = "The Emperor";
            option_id[1] = 5;
            options = 1;
            option_selected = 1;
        }
        if (obj_controller.fest_type == "Triumphal March") {
            option[1] = global.chapter_name;
            option_id[1] = 6;
            options = 1;
            option_selected = 1;
        }
    }

    if (target == "event_public") {
        option[1] = "No Public";
        option[2] = "Nobility";
        option[3] = "PDF";
        option[4] = "Open Event";
        option_selected = 1;
        options = 4;
    }
}
