// Sets which target is in planet and its strenght
ship=[];
ship_all=[];
ship_use=[];
ship_max=[];
ship_ide=[];

var _ships = fleet_full_ship_array(sh_target);
max_ships = array_length(_ships);
bomb_a = calculate_fleet_bombard_score(_ships);
var _total_fleet_loaded = calculate_fleet_content_size(_ships);
bomb_b = _total_fleet_loaded;
bomb_c = _total_fleet_loaded;

for (var i=0;i<array_length(_ships);i++){
    if (ship_bombard_score(_ships[i]) > 0){
        array_push(ship_ide, _ships[i]);
        array_push(ship_max, obj_ini.ship_carrying[_ships[i]]);
        array_push(ship, obj_ini.ship[_ships[i]]);
        array_push(ship_use, 0);
        array_push(ship_all, 0);
    }
}

// Sets the number of forces in the planet
eldar=p_target.p_eldar[obj_controller.selecting_planet];
ork=p_target.p_orks[obj_controller.selecting_planet];
tau=p_target.p_tau[obj_controller.selecting_planet];
chaos=p_target.p_chaos[obj_controller.selecting_planet];
tyranids=p_target.p_tyranids[obj_controller.selecting_planet];
//if (tyranids<5) then tyranids=0;
traitors=p_target.p_traitors[obj_controller.selecting_planet];
necrons=p_target.p_necrons[obj_controller.selecting_planet];

var onceh=0;
if (p_data.guardsmen>0){
    imp=p_data.guard_score_calc();
}
var _pdf_count=p_data.pdf;
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


onceh=0;
pdf=p_target.p_pdf[obj_controller.selecting_planet];
if (onceh = 0) {
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

sisters=p_target.p_sisters[obj_controller.selecting_planet];
mechanicus=0;

targets=0;
if (ork>0) then targets+=1;
if (tau>0) then targets+=1;
if (chaos>0) then targets+=1;
if (tyranids>0) then targets+=1;
if (traitors>0) then targets+=1;
if (necrons>0) then targets+=1;
if (imp>0) then targets+=1;
if (pdf>0) then targets+=1;
if (sisters>0) then targets+=1;

// Defines which target will appear based on the strenght of the forces there 
// TODO in the future we could have multiple forces on a planet after we refactor into each planet using a hex grid system
/* TODO
    could we place all forces in a list(or dictionary) e.g [elder,chaos, traitors, ork, tau, tyranids] or

        {elder:[<elder_diplo_number>, <elder_forces_size>]}

    and use a sort loop to find the largest otherwise and choose target? Optional but makes more sense IMO
*/
target=2;
if (eldar>chaos) and (eldar>traitors) and (eldar>ork) and (eldar>tau) and (eldar>tyranids) and (eldar>necrons) then target=6;
if (ork>chaos) and (ork>traitors) and (ork>eldar) and (ork>tau) and (ork>tyranids) and (ork>necrons) then target=7;
if (tau>chaos) and (tau>traitors) and (tau>eldar) and (tau>ork) and (tau>tyranids) and (tau>necrons) then target=8;
if (tyranids>chaos) and (tyranids>traitors) and (tyranids>ork) and (tyranids>tau) and (tyranids>eldar) and (tyranids>necrons) then target=9;
if (chaos>ork) and (chaos>=traitors) and (chaos>eldar) and (chaos>tau) and (chaos>tyranids) and (chaos>necrons) then target=10;
if (traitors>ork) and (traitors>=chaos) and (traitors>eldar) and (traitors>tau) and (traitors>tyranids) and (traitors>necrons) then target=10;
if (necrons>ork) and (necrons>=chaos) and (necrons>eldar) and (necrons>tau) and (necrons>tyranids) and (necrons>traitors) then target=13;
if (p_target.p_owner[obj_controller.selecting_planet]=8){
    if (pdf>chaos) and (pdf>traitors) and (pdf>eldar) and (pdf>ork) and (pdf>tyranids) and (pdf>tau) and (pdf>necrons) then target=2.5;
}
if (p_target.craftworld=1) then target=6;
