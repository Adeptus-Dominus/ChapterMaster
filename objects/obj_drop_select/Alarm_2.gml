
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
    var tump = 0;
    var i = 0;
    for (var q = 0; q < sh_target.capital_number; q++){
        if (sh_target.capital[q]!="") and (obj_ini.ship_carrying[sh_target.capital_num[q]]>0){
            ship[i]=sh_target.capital[i];
            ship_use[i]=0;
            tump=sh_target.capital_num[i];
            ship_max[i]=obj_ini.ship_carrying[tump];
            ship_ide[i]=tump;
            ship_size[i]=3;
            i+=1;
        }
    }
    for (var q = 0; q < sh_target.frigate_number; q++) {
        if (sh_target.frigate[q]!="") and (obj_ini.ship_carrying[sh_target.frigate_num[q]]>0){
            ship[i]=sh_target.frigate[q];            
            ship_use[i]=0;
            tump=sh_target.frigate_num[q];
            ship_max[i]=obj_ini.ship_carrying[tump];
            ship_ide[i]=tump;
            ship_size[i]=2;
            i+=1;
        }
    }
    for (var q = 0; q < sh_target.escort_number; q++) {
        if (sh_target.escort[q]!="") and (obj_ini.ship_carrying[sh_target.escort_num[q]]>0){
            ship[i]=sh_target.escort[q];
            ship_use[i]=0;
            tump=sh_target.escort_num[q];
            ship_max[i]=obj_ini.ship_carrying[tump];
            ship_ide[i]=tump;
            ship_size[i]=1;
            i+=1;
        }
    }
}
