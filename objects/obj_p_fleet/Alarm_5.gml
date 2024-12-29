
var i, minhp, maxhp;



if (capital_number>0){
    i=0;minhp=0;maxhp=0;
    for (var i=0;i<array_length(capital); i++){
        if (capital[i]!="") and (capital_num[i]>-1){
            minhp+=obj_ini.ship_hp[i];
            maxhp+=obj_ini.ship_maxhp[i];
        }
    }
    if (maxhp>0) then capital_health=round((minhp/maxhp)*100);
    else capital_health=0;
}

if (frigate_number>0){
    i=0;minhp=0;maxhp=0;
     for (var i=0;i<array_length(frigate);i++){
        if (frigate[i]!="") and (frigate_num[i]>-1){
            minhp+=obj_ini.ship_hp[i];
            maxhp+=obj_ini.ship_maxhp[i];
        }
    }
    if (maxhp>0) then frigate_health=round((minhp/maxhp)*100);
    else frigate_health=0;
}

if (escort_number>0){
    i=0;minhp=0;maxhp=0;
     for (var i=0;i<array_length(escort);i++){
        if (escort[i]!="") and (escort_num[i]>-1){
            minhp+=obj_ini.ship_hp[i];
            maxhp+=obj_ini.ship_maxhp[i];
        }
    }
    if (maxhp>0) then escort_health=round((minhp/maxhp)*100);
    else escort_health=0;
}



