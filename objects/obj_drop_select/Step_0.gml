
// exit;

// if (mahreens<0) then mahreens=0;

if (refresh_raid!=0){
    var i,comp,good,unit,chick,remove;i=0;comp=0;good=1;remove=0;
    refresh_raid=0;chick=1;
    
   for (comp=0;comp<=10;comp++){
        for (i=0;i<array_length(obj_ini.TTRPG[comp]);i++){
            chick=1;
            unit = fetch_unit([comp,i]);
            if (good=1){if (unit.ship_location>0) and (via[unit.ship_location]<=0) then chick=0;}
            
            remove=0;
            
            // just added the ship part
            if (good=1) and ((unit.ship_location>0) or ((attack=1) and (unit.planet_location=obj_controller.selecting_planet) and (obj_ini.loc[comp][i]=p_target.name) and (remove_local!=0))){
                
                if (attack=1) and (unit.planet_location=obj_controller.selecting_planet) and (remove_local=1) then remove=1;
            
                // Fight wounded
                var on_bike = unit.mobility_item()=="Bike";
                if (unit.hp()<=10) and (fighting[comp][i]=0) and (raid_wounded=1) and (via[unit.ship_location]>0){
                    if (!on_bike) or (attack=1) then fighting[comp][i]=1;
                    
                    if (unit.role()=obj_ini.role[100][11]){
                        if (on_bike) and (attack=1) then bikes+=1;
                        if (!on_bike) then mahreens+=1;
                    }
                    if (!on_bike){
                        if (unit.IsSpecialist("rank_and_file")) then mahreens++;
                        if (unit.role()=obj_ini.role[100][3]) then veterans+=1;
                    }else if (on_bike) and (attack=1){
                        if (unit.role()=obj_ini.role[100][3]) then bikes+=1;
                         if (unit.IsSpecialist("rank_and_file")) then bikes++;
                    }
                    
                    if (unit.role()="Champion"){
                        champions+=1;
                    }else if (unit.role()=obj_ini.role[100][2]) { honor+=1;}
                    else if (unit.role()=obj_ini.role[100][4]) { terminators+=1;}
                    else if (unit.role()=obj_ini.role[100][5]) { capts+=1;}
                    
                    else if (unit.IsSpecialist("chap", true)){
                        chaplains++;
                    }else if (unit.IsSpecialist("apoth", true)){
                        apothecaries++;
                    }else if (unit.IsSpecialist("libs", true)){
                        psykers++;
                    }else if (unit.IsSpecialist("forge", true)){
                        techmarines++;
                    }
                    if (unit.role()="Chapter Master") then master=1;
                }
                
                            
                if (obj_ini.race[comp][i]=1) and ((fighting[comp][i]=1) or (remove=1)){// Case 1; check for marines that need to be removed
                    if (unit.role()=obj_ini.role[100][11]) and ((raid_tact+raid_vet+raid_deva+raid_assa=0) or (remove=1)){
                        if (on_bike) then bikes-=1;
                        if (!on_bike) then mahreens-=1;
                        fighting[comp][i]=0;
                    }
                    if (!on_bike){
                        if (unit.role()=obj_ini.role[100][3]) and ((raid_vet=0) or (remove=1)){fighting[comp][i]=0;veterans-=1;}
                        if (unit.role()=obj_ini.role[100][8]) and ((raid_tact=0) or (remove=1)){fighting[comp][i]=0;mahreens-=1;}
                        if (unit.role()=obj_ini.role[100][9]) and ((raid_deva=0) or (remove=1)){fighting[comp][i]=0;mahreens-=1;}
                        if (unit.role()=obj_ini.role[100][10]) and ((raid_assa=0) or (remove=1)){fighting[comp][i]=0;mahreens-=1;}
                        if (unit.role()=obj_ini.role[100][12]) and ((raid_scou=0) or (remove=1)){fighting[comp][i]=0;mahreens-=1;}
                    }
                    if (on_bike){
                        if (unit.role()=obj_ini.role[100][3]) and ((raid_vet=0) or (remove=1)){fighting[comp][i]=0;bikes-=1;}
                        if (unit.role()=obj_ini.role[100][8]) and ((raid_tact=0) or (remove=1)){fighting[comp][i]=0;bikes-=1;}
                        if (unit.role()=obj_ini.role[100][9]) and ((raid_deva=0) or (remove=1)){fighting[comp][i]=0;bikes-=1;}
                        if (unit.role()=obj_ini.role[100][10]) and ((raid_assa=0) or (remove=1)){fighting[comp][i]=0;bikes-=1;}
                        if (unit.role()=obj_ini.role[100][12]) and ((raid_scou=0) or (remove=1)){fighting[comp][i]=0;bikes-=1;}
                    }
                    
                    if (unit.role()=obj_ini.role[100][2]) and ((raid_vet=0) or (remove=1)){fighting[comp][i]=0;honor-=1;}
                    if (unit.role()=obj_ini.role[100][4]) and ((raid_term=0) or (remove=1)){fighting[comp][i]=0;terminators-=1;}
                    if (unit.role()=obj_ini.role[100][5]) and ((raid_vet=0) or (remove=1)){fighting[comp][i]=0;capts-=1;}
                    if (unit.role()="Champion") and ((raid_vet=0) or (remove=1)){fighting[comp][i]=0;champions-=1;}
                    
                    if (unit.role()="Chapter Master") and ((raid_spec=0) or (remove=1)){fighting[comp][i]=0;master=0;}
                    if (unit.IsSpecialist("chap", true)) and ((raid_spec=0) or (remove=1)){fighting[comp][i]=0;chaplains-=1}
                    if (unit.IsSpecialist("apoth", true)) and ((raid_spec=0) or (remove=1)){fighting[comp][i]=0;apothecaries-=1;}
                    if (unit.IsSpecialist("libs", true)) and ((raid_spec=0) or (remove=1)){fighting[comp][i]=0;psykers-=1;}
                    if (unit.IsSpecialist("forge", true)) and ((raid_spec=0) or (remove=1)){fighting[comp][i]=0;techmarines-=1;}
                }
                
                
                if (obj_ini.race[comp][i]=1) and (fighting[comp][i]=0) and (chick>0) and (remove=0){// Case 2; check for marines that need to be added
                    if (unit.role()=obj_ini.role[100][11]) and (raid_tact+raid_vet+raid_deva+raid_assa>0){
                        if (on_bike) and (attack=1) then bikes+=1;
                        if (!on_bike) then mahreens+=1;
                        if (!on_bike) or (attack=1) then fighting[comp][i]=1;
                    }
                    if (!on_bike){
                        if (unit.role()=obj_ini.role[100][3]) and (raid_vet=1){fighting[comp][i]=1;veterans+=1;}
                        if (unit.role()=obj_ini.role[100][8]) and (raid_tact=1){fighting[comp][i]=1;mahreens+=1;}
                        if (unit.role()=obj_ini.role[100][9]) and (raid_deva=1){fighting[comp][i]=1;mahreens+=1;}
                        if (unit.role()=obj_ini.role[100][10]) and (raid_assa=1){fighting[comp][i]=1;mahreens+=1;}
                        if (unit.role()=obj_ini.role[100][12]) and (raid_scou=1){fighting[comp][i]=1;mahreens+=1;}
                    }
                    if (on_bike) and (attack=1){
                        if (unit.role()=obj_ini.role[100][3]) and (raid_vet=1){fighting[comp][i]=1;bikes+=1;}
                        if (unit.role()=obj_ini.role[100][8]) and (raid_tact=1){fighting[comp][i]=1;bikes+=1;}
                        if (unit.role()=obj_ini.role[100][9]) and (raid_deva=1){fighting[comp][i]=1;bikes+=1;}
                        if (unit.role()=obj_ini.role[100][10]) and (raid_assa=1){fighting[comp][i]=1;bikes+=1;}
                        if (unit.role()=obj_ini.role[100][12]) and (raid_scou=1){fighting[comp][i]=1;bikes+=1;}
                    }
                    
                    if (unit.role()=obj_ini.role[100][2]) and (raid_vet=1){fighting[comp][i]=1;honor+=1;}
                    if (unit.role()=obj_ini.role[100][4]) and (raid_term=1){fighting[comp][i]=1;terminators+=1;}
                    if (unit.role()=obj_ini.role[100][5]) and (raid_vet=1){fighting[comp][i]=1;capts+=1;}
                    if (unit.role()="Champion") and (raid_vet=1){fighting[comp][i]=1;champions+=1;}
                    
                    if (unit.role()="Chapter Master") and (raid_spec=1){fighting[comp][i]=1;master=1;}
                    if (unit.IsSpecialist("chap", true)) and (raid_spec=1){fighting[comp][i]=1;chaplains+=1}
                    if (unit.IsSpecialist("apoth", true)) and (raid_spec=1){fighting[comp][i]=1;apothecaries+=1;}
                    if (unit.IsSpecialist("libs", true)) and (raid_spec=1){fighting[comp][i]=1;psykers+=1;}
                    if (unit.IsSpecialist("forge", true)) and (raid_spec=1){fighting[comp][i]=1;techmarines+=1;}
                }
                
                
                // Remove wounded
                
                
                if (unit.hp()<=10) and (fighting[comp][i]=1) and (raid_wounded=0){
                    fighting[comp][i]=0;
                    if (unit.role()=obj_ini.role[100][11]){
                        if (obj_ini.mobi[comp][i]="Bike") then bikes-=1;
                        if (obj_ini.mobi[comp][i]!="Bike") then mahreens-=1;
                    }
                    if (!on_bike){
                        if (unit.role()=obj_ini.role[100][3]) then veterans-=1;
                        if (unit.role()=obj_ini.role[100][8]) then mahreens-=1;
                        if (unit.role()=obj_ini.role[100][9]) then mahreens-=1;
                        if (unit.role()=obj_ini.role[100][10]) then mahreens-=1;
                        if (unit.role()=obj_ini.role[100][12]) then mahreens-=1;
                    }
                    if (on_bike){
                        if (unit.role()=obj_ini.role[100][3]) then bikes-=1;
                        if (unit.role()=obj_ini.role[100][8]) then bikes-=1;
                        if (unit.role()=obj_ini.role[100][9]) then bikes-=1;
                        if (unit.role()=obj_ini.role[100][10]) then bikes-=1;
                        if (unit.role()=obj_ini.role[100][12]) then bikes-=1;
                    }
                    
                    if (unit.role()="Champion") then champions-=1;
                    if (unit.role()=obj_ini.role[100][2]) then honor-=1;
                    if (unit.role()=obj_ini.role[100][4]) then terminators-=1;
                    if (unit.role()=obj_ini.role[100][5]) then capts-=1;
                
                    if (unit.role()="Chapter Master") then master=0;
                    if (unit.IsSpecialist("chap", true)) then chaplains-=1
                    if (unit.IsSpecialist("apoth", true)) then apothecaries-=1;
                    if (unit.IsSpecialist("libs", true)) then psykers-=1;
                    if (unit.IsSpecialist("forge", true)) then techmarines-=1;
                }
            }
        }
    }
}


