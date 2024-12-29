// Sets the targets for the ships, handles bombardment
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
for(var b=0; b<sh_target.capital_number; b++){
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
for(var q=0; q<sh_target.frigate_number; q++){
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
