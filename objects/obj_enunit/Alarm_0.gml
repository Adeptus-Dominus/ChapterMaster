var __b__;
__b__ = action_if_number(obj_pnunit, 0, 2);
if __b__
{
{




var leftest,charge=0,enemy2=0,chapter_fuck=1,unit;

// with(obj_pnunit){if (x<-4000) or (defenses=1) then instance_deactivate_object(id);}

var _local_fort = instance_exists(obj_nfort);
if (!flank){
    enemy=get_rightmost();// Right most enemy
    enemy2=enemy;
    if (enemy=="none"){
        exit;
    }
    if (!_local_fort){
        move_unit_block("west");
    }
    
    //if (point_distance(x,0,enemy.x,0)<5) then x+=10;
    // instance_activate_object(obj_cursor);
}
else if (flank=1){
    enemy=get_leftmost();
    enemy2=enemy;
    if (enemy=="none"){
        exit;
    }
    // if (collision_point(x+10,y,obj_pnunit,0,1)) then engaged=1;
    // if (!collision_point(x+10,y,obj_pnunit,0,1)) then engaged=0;
    if (!_local_fort){
        move_unit_block("east");
    }
    
    // instance_activate_object(obj_cursor);
}

//In melee check
engaged = point_distance(x,0,enemy.x,0)<=10 || !position_empty(x+flank?10:-10,y);

show_debug_message($"enemy is in melee {engaged}")

if (!engaged){// Shooting
    var i=0,dist=999,block=0;
    dist=get_block_distance(enemy);
    
    var wall_exists=0;
    if (instance_exists(obj_nfort)){
        wall_exists=1;
        dist=2;
    }
    /*with(obj_pnunit){if (veh_type[1]="Defenses") then instance_create(x,y,obj_temp_inq);}
    if (instance_exists(obj_temp_inq)){
        enemy=instance_nearest(obj_temp_inq.x,obj_temp_inq.y,obj_pnunit);
        with(obj_temp_inq){instance_destroy();}
    }*/
    
    if (!instance_exists(obj_pnunit)) then exit;

    for (var i=0;i<array_length(wep);i++){
        if (wep[i]=="" || wep_num[i]==0) then continue;
        chapter_fuck=1;
        if (!instance_exists(obj_pnunit)) then exit;
        if (!target_block_is_valid(enemy,obj_pnunit)){
            if (flank=0){
                enemy=get_rightmost();
                enemy2=enemy;
                if (enemy=="none"){
                    exit;
                }
                dist=get_block_distance(enemy);
            }
            else if (flank=1){
                enemy=get_leftmost();
                enemy2=enemy;
                if (enemy=="none"){
                    exit;
                }                
                dist=get_block_distance(enemy);
            }     
        }
        
        if (target_block_is_valid(enemy,obj_pnunit)){
            block=0;
        
            if (instance_exists(obj_nfort)) and (obj_nfort.hp[1]>0){// Give the wall the melee D
                enemy=instance_nearest(x,y,obj_nfort);
                var bug1=instance_nearest(40,y,obj_enunit);
                if (range[i]=1) and (bug1.id=self.id) then range[i]=2;
                enemy2=enemy;
                dist=2;
            }
            
            if  (wep_num[i]>0) and (range[i]>=dist) and (range[i]!=1) and (combi[i]<2) and (ammo[i]!=0){// Weapon meets preliminary checks
                
                var _armour_piercing=0;
                if (apa[i]>0) then _armour_piercing=1;// Determines if it is _armour_piercing or not
                // if (string_count("Gauss",wep[i])>0) then _armour_piercing=1;
                
                // show_message(string(wep[i])+" is in range and _armour_piercing:"+string(_armour_piercing));
                
                if (wep[i]="Missile Launcher") or (wep[i]="Rokkit Launcha") or (wep[i]="Kannon") then _armour_piercing=1;
                if (wep[i]="Big Shoota") then _armour_piercing=0;
                if (wep[i]="Devourer") then _armour_piercing=0;
                if (wep[i]="Gauss Particle Cannon") or (wep[i]="Overcharged Gauss Cannon") or (wep[i]="Particle Whip") then _armour_piercing=1;
                
                
                
                if ((wep[i]="Power Fist") or (wep[i]="Bolter")) and (obj_ncombat.alpha_strike>0) and (wep_num[i]>5){
                    obj_ncombat.alpha_strike-=0.5;
                    
                    var cm_present = false;
                    var cm_index = -1;
                    var cm_block = false;
                    with(obj_pnunit){
                        for (var u=0;u<array_length(unit_struct);u++){
                            if (marine_type[u]="Chapter Master"){
                                cm_present=true;
                                cm_index = u;
                                cm_block=id
                            }
                        }
                    }
                    if (cm_present){
                        enemy=cm_block;
                        chapter_fuck=cm_index;
                    }
                }
                
                
                
                if (_armour_piercing) and ((!instance_exists(obj_nfort)) or (flank)){// Check for vehicles
                    var enemy2,g=0,good=0;
                    
                    if (block_has_armour(enemy)) or (enemy.veh_type[1]=="Defenses"){
                        // good=scr_target(enemy,"veh");// First target has vehicles, blow it to hell
                        scr_shoot(i,enemy,chapter_fuck,"arp","ranged");
                    }
                    if (!good) and (instance_number(obj_pnunit)>1) and (obj_ncombat.enemy!=7){// First target does not have vehicles, cycle through objects to find one that has vehicles
                        var x2=enemy.x;
                        repeat(instance_number(obj_pnunit)-1){
                            if (good=0){
                                if (flank=0) then x2-=10;
                                if (flank=1) then x2+=10;
                                enemy2=instance_nearest(x2,y,obj_pnunit);
                                if (enemy2.veh+enemy2.dreads>0) and (good=0){
                                    // good=scr_target(enemy2,"veh");// This target has vehicles, blow it to hell
                                    scr_shoot(i,enemy2,chapter_fuck,"arp","ranged");
                                }
                            }
                        }
                    }
                    if (good=0) then _armour_piercing=false;// Fuck it, shoot at infantry
                }
                if (_armour_piercing) and (instance_exists(obj_nfort)) and (!flank){// Huff and puff and blow the wall down
                    enemy=instance_nearest(x,y,obj_nfort);
                    
                    scr_shoot(i,enemy,1,"arp","wall");
                }
                
                // if (wall_exists=0) or (flank=1) 
                
                
                if (string_count("Gauss",wep[i])) then _armour_piercing=false;
                
                if (!_armour_piercing) and ((!instance_exists(obj_nfort)) or (flank)) and (instance_exists(obj_pnunit)) and (instance_exists(enemy)){// Check for men
                    var g=0,good=0,enemy2;

                    if (target_block_is_valid(enemy,obj_pnunit)){
                        // good=scr_target(enemy,"men");// First target has vehicles, blow it to hell
                        scr_shoot(i,enemy,chapter_fuck,"att","ranged");
                    }
                    
                    // First target does not have vehicles, cycle through objects to find one that has vehicles
                    // Note that unless the player has 10+ vehicles in the front rank they can fire on through
                    
                    if (!good) and (instance_number(obj_pnunit)>1) and (enemy.veh+enemy.dreads<=10){
                        var x2=enemy.x;
                        repeat(instance_number(obj_pnunit)-1){
                            if (!good){
                                if (!flank) then x2-=10;
                                if (flank) then x2+=10;
                                enemy2=instance_nearest(x2,y,obj_pnunit);
                                
                                var j,totes;j=0;totes=0;
                                for (j=0;j<array_length(enemy2.unit_struct);j++){
                                    unit = enemy2.unit_struct[j];
                                    if (!is_struct(unit))then continue;
                                    if (unit.hp()>0){
                                        if (enemy2.marine_type[j]=obj_ini.role[100][6]) then totes+=1;
                                        if (enemy2.marine_type[j]="Venerable "+string(obj_ini.role[100][6])) then totes+=1;
                                    }

                                }
                                for (j=0;j<array_length(enemy2.veh_hp);j++){
                                        if (enemy2.veh_hp[j]>0){
                                        if (enemy2.veh_type[i]="Rhino") then totes++;
                                        if (enemy2.veh_type[i]="Predator") then totes++;
                                        if (enemy2.veh_type[i]="Land Raider") then totes++;
                                    }
                                }
                                // show_message(totes);
                                
                                // if (enemy2.veh+enemy2.dreads>10) then block=1;
                                if (totes>=10) then block=1;
                                
                                // if (enemy2.men-enemy2.dreads>0) and (good=0) and (block=0){
                                if (enemy2.men>0) and (good=0) and (block=0){
                                    // good=scr_target(enemy2,"men");// This target has men, blow it to hell
                                    scr_shoot(i,enemy2,chapter_fuck,"att","ranged");
                                }
                            }
                        }
                    }
                }
                

            }
        }
    }
}

else if ((engaged || enemy.engaged) and target_block_is_valid( enemy,obj_pnunit)){// Melee
    engaged=1;
    var i=0,dist=999,no_ap=1;
    // dist=point_distance(x,y,enemy.x,enemy.y)/10;
    if !(instance_exists(obj_pnunit))then exit;
    for (var i=0;i<array_length(wep);i++){
        if (wep[i]=="" || wep_num[i]==0) then continue;
        var _armour_piercing=0;
        if (!instance_exists(obj_pnunit)) then exit;
        if (!flank){
            enemy=get_rightmost();
            enemy2=enemy;
            if (enemy=="none"){
                exit;
            }
            dist=get_block_distance(enemy);
        }
        else if (flank){
            enemy=get_leftmost();
            enemy2=enemy;
            if (enemy=="none"){
                exit;
            }                
            dist=get_block_distance(enemy);
        } 
        
        
        if (apa[i]=0) or (apa[i]<att[i]) then no_ap+=1;
        show_debug_message($"{range[i]},{att[i]},{apa[i]},{wep[i]},{enemy}")
        if  ((range[i]<=2) or ((floor(range[i])!=range[i]))){// Weapon meets preliminary checks
            if (apa[i]>0) then _armour_piercing=1;// Determines if it is _armour_piercing or not
            if (_armour_piercing) and (instance_exists(obj_nfort)) and (!flank){// Huff and puff and blow the wall down
                enemy=instance_nearest(x,y,obj_nfort);
                scr_shoot(i,enemy,1,"arp","wall");
                continue;
            }            
            if (_armour_piercing){// Check for vehicles
                var g=0,good=0,enemy2;
                
                if (block_has_armour(enemy)){
                    // good=scr_target(enemy,"veh");// First target has vehicles, blow it to hell
                    scr_shoot(i,enemy,1,"arp","melee");
                    good = true;
                }
                if (!good) then _armour_piercing=0;// Fuck it, shoot at infantry
            }
            
            if (!_armour_piercing) and (target_block_is_valid(enemy)){// Check for men
                // show_message(string(wep[i]));
                var enemy2,g=0,good=0;
                if ((enemy.men)){
                    // good=scr_target(enemy,"men");// First target has vehicles, blow it to hell
                    scr_shoot(i,enemy,1,"att","melee");
                }
                else if (block_has_armour(enemy)){
                    scr_shoot(i,enemy,1,"arp","melee");// Swing anyways, maybe they'll get lucky
                }
            }
   
        }
   
    }
    
    
    // if (no_ap=30) and (enemy.men=0) and (flank=0){// Next turn?
        
    // }
    
    
    
}


instance_activate_object(obj_pnunit);

/* */
__b__ = action_if_variable(image_index, -500, 0);
if __b__
{




var leftest,charge=0,enemy2=0;

with(obj_pnunit){
    if (x<-4000) then instance_deactivate_object(id);
}

if (flank=0){
    move_unit_block("west");
    // instance_activate_object(obj_cursor);
}
if (flank=1){
    enemy=instance_nearest(x,y,obj_pnunit);// Right most enemy
    enemy2=enemy;
    // if (collision_point(x+10,y,obj_pnunit,0,1)) then engaged=1;
    // if (!collision_point(x+10,y,obj_pnunit,0,1)) then engaged=0;
    move_unit_block();
    
    if (!position_empty(x+10,y)) then engaged=1;// Quick smash
    // instance_activate_object(obj_cursor);
}

if (!collision_point(x+10,y,obj_pnunit,0,1)) and (!collision_point(x-10,y,obj_pnunit,0,1)) then engaged=0;
if (collision_point(x+10,y,obj_pnunit,0,1)) or (collision_point(x-10,y,obj_pnunit,0,1)) then engaged=1;



var range_shooti;

    i=0;
    
    
    repeat(30){i+=1;


    
    dist=floor(point_distance(enemy2.x,enemy2.y,x,y)/10);
    
    
    
    
    
    range_shoot="";
    
    if (wep[i]!="") and (range[i]>=dist) and (ammo[i]!=0){
        if (range[i]!=1) and (engaged=0) then range_shoot="ranged";
        if ((range[i]!=floor(range[i])) or (range[i]=1)) and (engaged=1) then range_shoot="melee";
    }
    
    
    
    
    
    
    
    if (wep[i]!="") and (range_shoot="ranged") and (range[i]>=dist){// Weapon meets preliminary checks
        var _armour_piercing;_armour_piercing=0;if (apa[i]>att[i]) then _armour_piercing=1;// Determines if it is _armour_piercing or not
        
        // if (wep[i]="Missile Launcher") then _armour_piercing=1;
        
        if (string_count("Gauss",wep[i])>0) then _armour_piercing=1;
        
        if (wep[i]="Missile Launcher") or (wep[i]="Rokkit Launcha") or (wep[i]="Kannon") then _armour_piercing=1;
        if (wep[i]="Big Shoota") then _armour_piercing=0;if (wep[i]="Devourer") then _armour_piercing=0;
        if (wep[i]="Gauss Particle Cannon") or (wep[i]="Overcharged Gauss Cannon") or (wep[i]="Particle Whip") then _armour_piercing=1;
        
        
        if (instance_exists(enemy2)){
            if (enemy2.veh+enemy2.dreads>0) and (enemy2.men=0) and (apa[i]>10) then _armour_piercing=1;
            
            if (_armour_piercing=1) and (once_only=0){// Check for vehicles
                var g,good;g=0;good=0;
                
                if (enemy.veh>0){
                    // good=scr_target(enemy,"veh");// First target has vehicles, blow it to hell
                    scr_shoot(i,enemy2,good,"arp","ranged");
                }
                if (good=0) and (instance_number(obj_pnunit)>1){// First target does not have vehicles, cycle through objects to find one that has vehicles
                    var x2;x2=enemy2.x;
                    repeat(instance_number(obj_enunit)-1){
                        if (good=0){
                            x2+=10;enemy2=instance_nearest(x2,y,obj_pnunit);
                            if (enemy2.veh+enemy2.dreads>0) and (good=0){
                                good=scr_target(enemy2,"veh");// This target has vehicles, blow it to hell
                                scr_shoot(i,enemy2,good,"arp","ranged");once_only=1;
                            }
                        }
                    }
                }
                if (good=0) then _armour_piercing=0;// Fuck it, shoot at infantry
            }
        }

    }



}


instance_activate_object(obj_pnunit);

/* */
}
}
}
/*  */
