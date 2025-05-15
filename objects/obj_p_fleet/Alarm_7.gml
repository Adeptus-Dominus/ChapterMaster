


// right here check for artifacts to be moved

if (capital_number=0) then exit;
var  c=0,good=0;
var capital_id;
var capital_list = fleet_full_ship_array(, ,true,true);
for(var i=0;i<array_length(capital_list);i++){// Find the healthiest capital ship
    capital_id = capital_list[i];
    var _ship = fetch_ship(capital_id);
    if (_ship.hp>good){
        c=capital_id;
        good=_ship.hp;
    }
}

if (good>0){
    var ships_list = fleet_full_ship_array(, true);
    for (var a=0;a<array_length(obj_ini.artifact);a++){
        if (obj_ini.artifact[a]=="") then continue;
        if (array_contains(ships_list, obj_ini.artifact_sid[a]-500)){
            obj_ini.artifact_sid[a]=c+500;
            var _ship = fetch_ship(c);
            obj_ini.artifact_loc[a]=_ship.name;
        }
    }
}

