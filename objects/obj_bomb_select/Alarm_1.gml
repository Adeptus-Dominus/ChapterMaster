// Sets which target is in planet and its strenght
ship = [];
ship_all = [];
ship_use = [];
ship_max = [];
ship_ide = [];

var _ships = fleet_full_ship_array(sh_target);
max_ships = array_length(_ships);
bomb_a = calculate_fleet_bombard_score(_ships);
var _total_fleet_loaded = calculate_fleet_content_size(_ships);
bomb_b = _total_fleet_loaded;
bomb_c = _total_fleet_loaded;

for (var i = 0; i < array_length(_ships); i++) {
    if (ship_bombard_score(_ships[i]) > 0) {
        array_push(ship_ide, _ships[i]);
        array_push(ship_max, obj_ini.ship_carrying[_ships[i]]);
        array_push(ship, obj_ini.ship[_ships[i]]);
        array_push(ship_use, 0);
        array_push(ship_all, 0);
    }
}

// Sets the number of forces in the planet
eldar = p_target.p_eldar[obj_controller.selecting_planet];
ork = p_target.p_orks[obj_controller.selecting_planet];
tau = p_target.p_tau[obj_controller.selecting_planet];
chaos = p_target.p_chaos[obj_controller.selecting_planet];
tyranids = p_target.p_tyranids[obj_controller.selecting_planet];
//if (tyranids<5) then tyranids=0;
traitors = p_target.p_traitors[obj_controller.selecting_planet];
necrons = p_target.p_necrons[obj_controller.selecting_planet];

var onceh = 0;
if (p_data.guardsmen > 0) {
    imp = p_data.guard_score_calc();
}
var _pdf_count = p_data.pdf;
if (_pdf_count >= 50000000) {
    pdf = 6;
} else if (_pdf_count >= 15000000) {
    pdf = 5;
} else if (_pdf_count >= 6000000) {
    pdf = 4;
} else if (_pdf_count >= 1000000) {
    pdf = 3;
} else if (_pdf_count >= 100000) {
    pdf = 2;
} else if (_pdf_count >= 2000) {
    pdf = 1;
}

onceh = 0;
pdf = p_target.p_pdf[obj_controller.selecting_planet];
if (onceh == 0) {
    if (pdf >= 50000000) {
        pdf = 6;
    } else if (pdf >= 15000000) {
        pdf = 5;
    } else if (pdf >= 6000000) {
        pdf = 4;
    } else if (pdf >= 1000000) {
        pdf = 3;
    } else if (pdf >= 100000) {
        pdf = 2;
    } else if (pdf >= 2000) {
        pdf = 1;
    }
    onceh = 1;
}

sisters = p_target.p_sisters[obj_controller.selecting_planet];
mechanicus = 0;

targets = 0;
if (ork > 0) {
    targets += 1;
}
if (tau > 0) {
    targets += 1;
}
if (chaos > 0) {
    targets += 1;
}
if (tyranids > 0) {
    targets += 1;
}
if (traitors > 0) {
    targets += 1;
}
if (necrons > 0) {
    targets += 1;
}
if (imp > 0) {
    targets += 1;
}
if (pdf > 0) {
    targets += 1;
}
if (sisters > 0) {
    targets += 1;
}

// Defines which target will appear based on the strenght of the forces there
// TODO in the future we could have multiple forces on a planet after we refactor into each planet using a hex grid system
/* TODO
    could we place all forces in a list(or dictionary) e.g [elder,chaos, traitors, ork, tau, tyranids] or

        {elder:[<elder_diplo_number>, <elder_forces_size>]}

    and use a sort loop to find the largest otherwise and choose target? Optional but makes more sense IMO
*/
target = 2;
if ((eldar > chaos) && (eldar > traitors) && (eldar > ork) && (eldar > tau) && (eldar > tyranids) && (eldar > necrons)) {
    target = 6;
}
if ((ork > chaos) && (ork > traitors) && (ork > eldar) && (ork > tau) && (ork > tyranids) && (ork > necrons)) {
    target = 7;
}
if ((tau > chaos) && (tau > traitors) && (tau > eldar) && (tau > ork) && (tau > tyranids) && (tau > necrons)) {
    target = 8;
}
if ((tyranids > chaos) && (tyranids > traitors) && (tyranids > ork) && (tyranids > tau) && (tyranids > eldar) && (tyranids > necrons)) {
    target = 9;
}
if ((chaos > ork) && (chaos >= traitors) && (chaos > eldar) && (chaos > tau) && (chaos > tyranids) && (chaos > necrons)) {
    target = 10;
}
if ((traitors > ork) && (traitors >= chaos) && (traitors > eldar) && (traitors > tau) && (traitors > tyranids) && (traitors > necrons)) {
    target = 10;
}
if ((necrons > ork) && (necrons >= chaos) && (necrons > eldar) && (necrons > tau) && (necrons > tyranids) && (necrons > traitors)) {
    target = 13;
}
if (p_target.p_owner[obj_controller.selecting_planet] == 8) {
    if ((pdf > chaos) && (pdf > traitors) && (pdf > eldar) && (pdf > ork) && (pdf > tyranids) && (pdf > tau) && (pdf > necrons)) {
        target = 2.5;
    }
}
if (p_target.craftworld == 1) {
    target = 6;
}
