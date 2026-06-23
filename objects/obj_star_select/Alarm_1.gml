player_fleet = target.present_fleet[1];
imperial_fleet = target.present_fleet[2];
mechanicus_fleet = target.present_fleet[3];
inquisitor_fleet = target.present_fleet[4];
eldar_fleet = target.present_fleet[6];
ork_fleet = target.present_fleet[7];
tau_fleet = target.present_fleet[8];
tyranid_fleet = target.present_fleet[9];
heretic_fleet = target.present_fleet[10];

en_fleet = array_create(15, 0);

if ((player_fleet > 0) && (imperial_fleet + mechanicus_fleet + inquisitor_fleet + eldar_fleet + ork_fleet + tau_fleet + heretic_fleet > 0)) {
    var open = 1;

    if (imperial_fleet > 0) {
        en_fleet[open] = 2;
        open += 1;
    }
    if (mechanicus_fleet > 0) {
        en_fleet[open] = 3;
        open += 1;
    }
    if (inquisitor_fleet > 0) {
        en_fleet[open] = 4;
        open += 1;
    }
    if (eldar_fleet > 0) {
        en_fleet[open] = 6;
        open += 1;
    }
    if (ork_fleet > 0) {
        en_fleet[open] = 7;
        open += 1;
    }
    if (tau_fleet > 0) {
        en_fleet[open] = 8;
        open += 1;
    }
    if (tyranid_fleet > 0) {
        en_fleet[open] = 9;
        open += 1;
    }
    if (heretic_fleet > 0) {
        en_fleet[open] = 10;
        open += 1;
    }
}
