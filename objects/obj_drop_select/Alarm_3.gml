var i;i=-1;
repeat(61){
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
    
    
    var tump;tump=0;
    
    var i, q, b;i=0;q=0;b=0;
    repeat(sh_target.capital_number){
        b+=1;
        if (sh_target.capital[b]!=""){
            i+=1;
            ship[i]=sh_target.capital[i];
            
            ship_use[i]=0;
            tump=sh_target.capital_num[i];
            ship_max[i]=obj_ini.ship_carrying[tump];
            ship_ide[i]=tump;
            ship_size[i]=3;
            
            purge_a+=3;
            purge_b+=ship_max[i];purge_c+=ship_max[i];
        }
    }
    q=0;
    repeat(sh_target.frigate_number){
        q+=1;
        if (sh_target.frigate[q]!=""){
            i+=1;
            ship[i]=sh_target.frigate[q];
            
            ship_use[i]=0;
            tump=sh_target.frigate_num[q];
            ship_max[i]=obj_ini.ship_carrying[tump];
            ship_ide[i]=tump;
            ship_size[i]=2;
            
            purge_a+=1;
            purge_b+=ship_max[i];purge_c+=ship_max[i];
        }
    }
    q=0;
    repeat(sh_target.escort_number){
        q+=1;
        if (sh_target.escort[q]!="") and (obj_ini.ship_carrying[sh_target.escort_num[q]]>0){
            i+=1;
            ship[i]=sh_target.escort[q];
            
            ship_use[i]=0;
            tump=sh_target.escort_num[q];
            ship_max[i]=obj_ini.ship_carrying[tump];
            ship_ide[i]=tump;
            ship_size[i]=1;
            
            purge_b+=ship_max[i];purge_c+=ship_max[i];
        }
    }
}

