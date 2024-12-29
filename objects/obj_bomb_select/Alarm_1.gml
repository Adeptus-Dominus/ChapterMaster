// Sets which target is in planet and its strenght
for(var i=0; i<31; i++){
    ship[i]="";
    ship_all[i]=0;
    ship_use[i]=0;
    ship_max[i]=0;
    ship_ide[i]=-1;
}

max_ships=sh_target.capital_number+sh_target.frigate_number+sh_target.escort_number;

var tump=0;

var i=-1;
for(var b=0; b<array_length(sh_target.capital); b++){
    if (sh_target.capital[b]!=""){
        i+=1;
        ship[i]=sh_target.capital[i];
        
        ship_use[i]=0;
        tump=sh_target.capital_num[i];
        ship_max[i]=obj_ini.ship_carrying[tump];
        ship_ide[i]=tump;
        
        bomb_a+=3;
        bomb_b+=ship_max[i];bomb_c+=ship_max[i];
    }
}
for(var q=0; q<array_length(sh_target.frigate); q++){
    if (sh_target.frigate[q]!=""){
        i+=1;
        ship[i]=sh_target.frigate[q];
        
        ship_use[i]=0;
        tump=sh_target.frigate_num[q];
        ship_max[i]=obj_ini.ship_carrying[tump];
        ship_ide[i]=tump;
        
        bomb_a+=1;
        bomb_b+=ship_max[i];bomb_c+=ship_max[i];
    }
}

// Sets the number of forces in the planet
eldar=p_target.p_eldar[obj_controller.selecting_planet];
ork=p_target.p_orks[obj_controller.selecting_planet];
tau=p_target.p_tau[obj_controller.selecting_planet];
chaos=p_target.p_chaos[obj_controller.selecting_planet];
tyranids=p_target.p_tyranids[obj_controller.selecting_planet];
if (tyranids<5) then tyranids=0;
traitors=p_target.p_traitors[obj_controller.selecting_planet];
necrons=p_target.p_necrons[obj_controller.selecting_planet];

var onceh=0;
imp=p_target.p_guardsmen[obj_controller.selecting_planet];
if (onceh == 0) {
    if (imp >= 50000000) {
        imp = 6;
    } else if (imp >= 15000000) {
        imp = 5;
    } else if (imp >= 6000000) {
        imp = 4;
    } else if (imp >= 1000000) {
        imp = 3;
    } else if (imp >= 100000) {
        imp = 2;
    } else if (imp >= 2000) {
        imp = 1;
    }
    onceh = 1;
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
