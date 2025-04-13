

// with(obj_enunit){show_message(string(dudes[1])+"|"+string(dudes_num[1])+"|"+string(men+medi)+"|"+string(dudes_hp[1]));}

var rightest,charge=0,enemy2=0;// psy=false;


if (instance_number(obj_enunit)!=1){
    obj_ncombat.flank_x=self.x;
    with(obj_enunit){
        if (x<(obj_ncombat.flank_x-20)) then instance_deactivate_object(id);
    }
}

rightest=get_rightmost();// Right most pnunit
enemy=instance_nearest(0,y,obj_enunit);// Left most enemy
enemy2=enemy;

if (obj_ncombat.defending=false) or (obj_ncombat.dropping=1){
    move_unit_block();
}

if (!instance_exists(enemy)) then exit;
if (collision_point(x+10,y,obj_enunit,0,1)) or (collision_point(x-10,y,obj_enunit,0,1)) then engaged=1;
if (!collision_point(x+10,y,obj_enunit,0,1)) and (!collision_point(x-10,y,obj_enunit,0,1)) then engaged=0;

var once_only;once_only=0;
var i=0,dist=999;
var range_shoot="";
dist=point_distance(x,y,enemy.x,enemy.y)/10;

for (var i=0;i<array_length(unit_struct);i++){
    if (marine_mshield[i]>0) then marine_mshield[i]-=1;
    if (marine_quick[i]>0) then marine_quick[i]-=1;
    if (marine_might[i]>0) then marine_might[i]-=1;
    if (marine_fiery[i]>0) then marine_fiery[i]-=1;
    if (marine_fshield[i]>0) then marine_fshield[i]-=1;
    if (marine_dome[i]>0) then marine_dome[i]-=1;
    if (marine_spatial[i]>0) then marine_spatial[i]-=1;
}i=0;

if (instance_exists(obj_enunit)){
    for (var i=0;i<array_length(wep);i++){
        if (wep[i]=="") then continue;
        weapon_data = gear_weapon_data("weapon", wep[i])
        once_only=0;
        enemy=instance_nearest(0,y,obj_enunit);
        enemy2=enemy;
        if (enemy.men+enemy.veh+enemy.medi<=0){
            var x5=enemy.x;
            with(enemy){
                instance_destroy();
            }
            enemy=instance_nearest(0,y,obj_enunit);
            enemy2=enemy;
        }

        
        if (range[i]>=dist) and (ammo[i]!=0 || range[i]==1){
            if (range[i]!=1) and (engaged=0) then range_shoot="ranged";
            if ((range[i]!=floor(range[i]) || floor(range[i])=1) && engaged=1) then range_shoot="melee";
        }
        
        if (range_shoot="ranged") and (range[i]>=dist){// Weapon meets preliminary checks
            var ap=0;
            if (apa[i]>att[i]) then ap=1;// Determines if it is AP or not
            if (wep[i]="Missile Launcher") then ap=1;
            if (string_count("Lascan",wep[i])>0) then ap=1;
            if (instance_number(obj_enunit)=1) and (obj_enunit.men=0) and (obj_enunit.veh>0) then ap=1;
            
            
            if (instance_exists(enemy)){
                if (obj_enunit.veh>0) and (obj_enunit.men=0) and (apa[i]>10) then ap=1;
                
                if (ap=1) and (once_only=0){// Check for vehicles
                    var enemy2,g=0,good=0;
                    
                    if (enemy.veh>0){
                        good=scr_target(enemy,"veh");// First target has vehicles, blow it to hell
                        scr_shoot(i,enemy,good,"arp","ranged");
                    }
                    if (good=0) and (instance_number(obj_enunit)>1){// First target does not have vehicles, cycle through objects to find one that has vehicles
                        var x2=enemy.x;
                        repeat(instance_number(obj_enunit)-1){
                            if (good=0){
                                x2+=10;
                                enemy2=instance_nearest(x2,y,obj_enunit);
                                if (enemy2.veh>0) and (good=0){
                                    good=scr_target(enemy2,"veh");// This target has vehicles, blow it to hell
                                    scr_shoot(i,enemy2,good,"arp","ranged");
                                    once_only=1;
                                }
                            }
                        }
                    }
                    if (good=0) then ap=0;// Fuck it, shoot at infantry
                }
            }
            
            
            
            
            
            
            if (instance_exists(enemy)) and (once_only=0){
                if (enemy.medi>0) and (enemy.veh=0){
                    good=scr_target(enemy,"medi");// First target has vehicles, blow it to hell
                    scr_shoot(i,enemy,good,"medi","ranged");
                
                    if (good=0) and (instance_number(obj_enunit)>1){// First target does not have vehicles, cycle through objects to find one that has vehicles
                        var x2=enemy.x;
                        repeat(instance_number(obj_enunit)-1){
                            if (good=0){
                                x2+=10;enemy2=instance_nearest(x2,y,obj_enunit);
                                if (enemy2.veh>0) and (good=0){
                                    good=scr_target(enemy2,"medi");// This target has vehicles, blow it to hell
                                    scr_shoot(i,enemy2,good,"medi","ranged");once_only=1;
                                }
                            }
                        }
                    }
                    if (good=0) then ap=0;// Next up is infantry
                    // Was previously ap=1;
                }
            }
            
            
            
            
            
            if (instance_exists(enemy)){
                if (ap=0) and (once_only=0){// Check for men
                    var g,good,enemy2;g=0;good=0;
                    
                    if (enemy.men+enemy.medi>0){
                        good=scr_target(enemy,"men");// First target has vehicles, blow it to hell
                        scr_shoot(i,enemy,good,"att","ranged");
                    }
                    if (good=0) and (instance_number(obj_enunit)>1){// First target does not have vehicles, cycle through objects to find one that has vehicles
                        var x2;x2=enemy.x;
                        repeat(instance_number(obj_enunit)-1){
                            if (good=0){
                                x2+=10;enemy2=instance_nearest(x2,y,obj_enunit);
                                if (enemy2.men>0) and (good=0){
                                    good=scr_target(enemy2,"men");// This target has vehicles, blow it to hell
                                    scr_shoot(i,enemy2,good,"att","ranged");once_only=1;
                                }
                            }
                        }
                    }
                }
            }
        }else if  (range_shoot="melee") and ((range[i]==1) or (range[i]!=floor(range[i]))){// Weapon meets preliminary checks 
            var ap=0;
            if (apa[i]==1) then ap=1;// Determines if it is AP or not
            
            if (enemy.men=0) and (apa[i]=0) and (att[i]>=80){
                apa[i]=floor(att[i]/2);ap=1;
            }
            
            if (apa[i]==1) and (once_only=0){// Check for vehicles
                var enemy2,g=0,good=0;
                
                if (enemy.veh>0){
                    good=scr_target(enemy,"veh");// First target has vehicles, blow it to hell
                    if (range[i]=1) then scr_shoot(i,enemy,good,"arp","melee");
                }
                if (good!=0) then once_only=1;
                if (good=0) and (att[i]>0) then ap=0;// Fuck it, shoot at infantry
            }
            
            if (enemy.veh=0) and (enemy.medi>0) and (once_only=0){// Check for vehicles
                var enemy2,g=0,good=0;
                
                if (enemy.medi>0){
                    good=scr_target(enemy,"medi");// First target has vehicles, blow it to hell
                    if (range[i]=1) then scr_shoot(i,enemy,good,"medi","melee");
                }
                if (good!=0) then once_only=1;
                if (good=0) and (att[i]>0) then ap=0;// Fuck it, shoot at infantry
            }
            
            
            
            if (ap=0) and (once_only=0){// Check for men
                var  g=0,good=0,enemy2;
                
                if (enemy.men>0) and (once_only=0){
                    // show_message(string(wep[i])+" attacking");
                    good=scr_target(enemy,"men");
                    if (range[i]=1) then scr_shoot(i,enemy,good,"att","melee");
                }
                if (good!=0) then once_only=1;
            }
        }
        
        
        
    }
}

instance_activate_object(obj_enunit);

i=0;
if (instance_exists(obj_enunit)){
    for (var i=0;i<array_length(unit_struct);i++){
        if (marine_dead[i]==0 && marine_casting[i]=1){
            var let,buvvs,buvvs_num;let="D";
            if (string_count("D0",marine_powers[i])>0) then let="D";
            if (string_count("B0",marine_powers[i])>0) then let="B";
            if (string_count("P0",marine_powers[i])>0) then let="P";
            if (string_count("T0",marine_powers[i])>0) then let="T";
            if (string_count("R0",marine_powers[i])>0) then let="R";
            
            var powerz,buvvs_roll,tha,p;tha=-1;
            powerz=string_count(let,marine_powers[i]);
            p=-1;repeat(20){p+=1;buvvs[p]=-1;}
            if (let="D"){buvvs[1]=2;buvvs[2]=5;buvvs[3]=6;buvvs_num=3;}
            if (let="B"){buvvs[1]=2;buvvs[2]=3;buvvs_num=2;}
            if (let="P"){buvvs[1]=1;buvvs[2]=2;buvvs_num=2;}
            if (let="T"){buvvs[1]=3;buvvs[2]=4;buvvs_num=2;}
            if (let="R"){buvvs[1]=2;buvvs_num=1;}
            
            p=0;repeat(10){p+=1;if (buvvs[p]>powerz-1){buvvs_num-=1;buvvs[p]=-1;}}
            buvvs_roll=floor(random(100))+1;
            
            if (buvvs_roll<=(105-(obj_ncombat.turns*35))) and (obj_ncombat.enemy_forces>=obj_ncombat.player_forces) and (buvvs_num>0){// Cast buffs
            // if (obj_ncombat.turns<2) and (obj_ncombat.enemy_max>=obj_ncombat.player_max) and (buvvs_num>0){
                tha=max(buvvs[floor(random(buvvs_num))+1],buvvs[floor(random(buvvs_num))+1]);
            }
            
            if (buvvs_roll>(105-(obj_ncombat.turns*35))) or (obj_ncombat.enemy_forces<obj_ncombat.player_forces) or (buvvs_num=0){// Slam away
            // if (obj_ncombat.turns>=2) or (obj_ncombat.enemy_max<obj_ncombat.player_max) or (buvvs_num=0){
                repeat(100){
                    if (tha=-1) or (tha=buvvs[1]) or (tha=buvvs[2]) or (tha=buvvs[3]) or (tha=buvvs[4]) or (tha=buvvs[5]){
                        tha=max(floor(random(powerz)),floor(random(powerz)));
                        if (marine_type[i]="Chief "+string(obj_ini.role[100,17])) then tha=powerz-choose(-1,0,0,1,1,2);
                        if (marine_type[i]="Chapter Master") then tha=powerz-choose(-1,0,0,1,1,2);
                    }
                }
            }
            
            enemy=instance_nearest(0,y,obj_enunit);enemy2=enemy;
            if (enemy.men+enemy.veh+enemy.medi<=0){
                var x5=enemy.x;
                with(enemy){
                    instance_destroy();
                }
                enemy=instance_nearest(0,y,obj_enunit);
                enemy2=enemy;
            }
            
            var ham=false;
            if (marine_type[i]="Chapter Master") and (obj_ncombat.kamehameha=true) and ((obj_ncombat.big_boom>0) or (choose(1,2)=2)){
                if (obj_ncombat.enemy_forces>=40) then ham=true;
            }
            if (ham=false) then scr_powers(string_upper(let),tha,enemy2,i);
            if (ham=true) then scr_powers("Z",tha,enemy2,i);
        }
    }
}

