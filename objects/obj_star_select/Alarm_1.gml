
player_fleet=target.present_fleet[1];
imperial_fleet=target.present_fleet[2];
mechanicus_fleet=target.present_fleet[3];
inquisitor_fleet=target.present_fleet[4];
eldar_fleet=target.present_fleet[6];
ork_fleet=target.present_fleet[7];
tau_fleet=target.present_fleet[8];
tyranid_fleet=target.present_fleet[9];
heretic_fleet=target.present_fleet[10];

en_fleet = [];

for (var i=2;i<15;i++){
    if (scr_orbiting_fleet(i, target) != "none"){
        array_push(en_fleet, i);
    }
}


