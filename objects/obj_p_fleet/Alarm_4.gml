var sys_dist, mine, connected, fleet, cont;
sys_dist = 9999;
connected = 0;
cont = 0;

var eta = calculate_fleet_eta(x, y, action_x, action_y, action_spd, false, false, warp_able);
// if (connected=0) then eta=eta*2;
// if (connected=1) then connected=1;
// if (web=1) then eta=1;
action_eta = eta;

// if (action="crusade2") then action="crusade3";
// if (action="crusade1") then action="crusade2";

set_fleet_location("Warp");
