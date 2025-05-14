
var i;i=-1;
repeat(31){
    i+=1;
    ship[i]="";
    ship_all[i]=0;
    ship_use[i]=0;
    ship_max[i]=0;
    ship_ide[i]=-1;
}

max_ships=0;
if (sh_target!=-50){
    max_ships=sh_target.capital_number+sh_target.frigate_number+sh_target.escort_number;
}


if (ship_max[500]!=0) then max_ships+=1;

ship_all[500]=0;
ship_use[500]=0;
if (l_size>0) then l_size=l_size*-1;



if (sh_target!=-50){
    var i = 0;
    var _ships = fleet_full_ship_array(sh_target);
    for (var q = 0; q < array_length(_ships); q++){
        var _ship_id = _ships[q];
        var _ship = _ships[_ship_id];
        if (obj_ini.ship_carrying[_ship_id]>0){
            ship[i]=_ship.name;
            ship_use[i]=0;
            ship_max[i]=obj_ini.ship_carrying[_ship_id];
            ship_ide[i]=_ship_id;
            i+=1;
        }        
    }
}
