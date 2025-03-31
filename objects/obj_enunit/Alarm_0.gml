//* This alarm is responsible for the enemy target column selection;

if (!instance_exists(obj_pnunit)) {
    exit;
}

enemy = flank ? get_leftmost() : get_rightmost();
if (enemy == "none") {
    exit;
}

var target_unit_index = 0;
var enemy2 = enemy;

//In melee check
engaged = collision_point(x-10, y, obj_pnunit, 0, 1) || collision_point(x+10, y, obj_pnunit, 0, 1);
// show_debug_message($"enemy is in melee {engaged}")

if (!engaged){ // Shooting
    for (var i=0;i<array_length(wep);i++){
        if (!instance_exists(obj_pnunit)) then exit;

        if (wep[i]=="" || wep_num[i]==0) {
            continue;
        }

        if ((range[i]==1) || (ammo[i]==0)) {
            // show_debug_message($"A melee or no ammo weapon was found! Weapon: {wep[i]}; Column ID: {id}; Enemy Unit: {wep_owner[i]}; Range: {range[i]}; Ammo: {ammo[i]}");
            continue;
        }

        if ((range[i]==0)) {
            log_error($"{wep[i]} has broken range! This shouldn't happen! Range: {range[i]}; Ammo: {ammo[i]}; Owner: {wep_owner[i]}");
            // show_debug_message($"A broken weapon was found! i:{i}; Weapon: {wep[i]}; Column ID: {id}; Enemy Unit: {wep_owner[i]}; Range: {range[i]}; Ammo: {ammo[i]}");
            continue;
        }

        if (!target_block_is_valid(enemy,obj_pnunit)){
            enemy = flank == 0 ? get_rightmost() : get_leftmost();
            if (!target_block_is_valid(enemy,obj_pnunit)){
                exit;
            }
        }

        dist=get_block_distance(enemy);  
        target_unit_index=0;

        if  (range[i] >= dist) { // The weapon is in range;
            var _target_vehicles = apa[i] > 0 ? true : false; // AP weapons target vehicles

            // if (string_count("Gauss",wep[i])>0) then _target_vehicles=true;
            // if (wep[i]="Missile Launcher") or (wep[i]="Rokkit Launcha") or (wep[i]="Kannon") then _target_vehicles=true;
            // if (wep[i]="Big Shoota") then _target_vehicles=false;
            // if (wep[i]="Devourer") then _target_vehicles=false;
            // if (wep[i]="Gauss Particle Cannon") or (wep[i]="Overcharged Gauss Cannon") or (wep[i]="Particle Whip") then _target_vehicles=true;
            
            // Weird alpha strike mechanic, that changes target unit index to CM;
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
                    target_unit_index=cm_index;
                }
            }
            
            
            // AP weapons attacking vehicles and forts;
            var _no_vehicles_present = false;
            if (_target_vehicles) {
                var _shot = false;
                if (!instance_exists(obj_nfort)) or (flank) {
                    if (block_has_armour(enemy)) or (enemy.veh_type[1]=="Defenses"){
                        scr_shoot(i,enemy,target_unit_index,"arp","ranged");
                        // show_debug_message($"I'm shooting at a vehicle! {wep[i]}; Column ID: {id}; Enemy Unit: {wep_owner[i]}");
                        continue;
                    } else if (instance_number(obj_pnunit)>1) and (obj_ncombat.enemy!=7) {
                        var x2=enemy.x;
                        repeat(instance_number(obj_pnunit)-1){
                            x2 += flank == 0 ? -10 : 10;
                            var enemy2=instance_nearest(x2,y,obj_pnunit);
                            if (!target_block_is_valid(enemy2, obj_pnunit)) {
                                continue;
                            }
                            if (range[i] < get_block_distance(enemy2)) {
                                break;
                            }
                            if (block_has_armour(enemy2)) {
                                scr_shoot(i,enemy2,target_unit_index,"arp","ranged");
                                // show_debug_message($"I'm shooting at a vehicle in another row! {wep[i]}; Column ID: {id}; Enemy Unit: {wep_owner[i]}");
                                _shot = true;
                                break;
                            }
                        }
                        if (!_shot) {
                            _no_vehicles_present = true;
                            _target_vehicles = false;
                        }
                    }
                } else {
                    enemy=instance_nearest(x,y,obj_nfort);
                    if (range[i] >= get_block_distance(enemy)) {
                        scr_shoot(i,enemy,1,"arp","wall");
                        // show_debug_message($"I'm shooting at the fort! {wep[i]}; Column ID: {id}; Enemy Unit: {wep_owner[i]}");
                        continue;
                    }
                }
            }

            // Non-AP weapons attacking normal units;
            if ((!_target_vehicles) && ((!instance_exists(obj_nfort)) || flank)) {
                var _shot = false;
                if (enemy.men > 0) {
                    // There are marines in the first column;
                    scr_shoot(i, enemy, target_unit_index, "att", "ranged");
                    // show_debug_message($"I'm shooting at a normal unit! {wep[i]}; Column ID: {id}; Enemy Unit: {wep_owner[i]}");
                    continue;
                } else if (instance_number(obj_pnunit) > 1) {
                    // There were no marines in the first column, looking behind;
                    var _column_size_value = enemy.column_size;
                    var x2 = enemy.x;

                    repeat (instance_number(obj_pnunit) - 1) {
                        x2 += !flank ? 10 : -10;
                        var enemy2 = instance_nearest(x2, y, obj_pnunit);
                        if (!target_block_is_valid(enemy2, obj_pnunit)) {
                            // show_debug_message($"The block is invalid!");
                            continue;
                        }

                        if (range[i] < get_block_distance(enemy2)) {
                            // show_debug_message($"The range is bad!");
                            break;
                        }
            
                        var _back_column_size_value = enemy2.column_size;
                        if (_back_column_size_value < _column_size_value) {
                            // show_debug_message($"Protection value is too big!");
                            continue;
                        } else {
                            // Calculate chance of shots passing through to back row
                            // Higher ratio of back column size to front column size increases pass-through chance
                            // Maximum chance capped at 40% to ensure some protection remains
                            var _pass_chance = ((_back_column_size_value / _column_size_value) - 1) * 100;
                            if (irandom_range(1, 100) < min(_pass_chance, 80)) {
                                // show_debug_message($"I failed the protection check!");
                                continue;
                            }
                        }
                        scr_shoot(i, enemy2, target_unit_index, "att", "ranged");
                        // show_debug_message($"I'm shooting at a normal unit in another row! {wep[i]}; Column ID: {id}; Enemy Unit: {wep_owner[i]}");
                        _shot = true;
                        break;
                    }
                }

                // We failed to find normal units to attack, attacking vehicles with a non-AP weapon;
                //TODO: All of these code blocks should be functions instead;
                if (!_shot && !_no_vehicles_present) {
                    if (!instance_exists(obj_nfort)) or (flank) {
                        if (block_has_armour(enemy)) or (enemy.veh_type[1]=="Defenses"){
                            scr_shoot(i,enemy,target_unit_index,"att","ranged");
                            // show_debug_message($"I'm shooting at a vehicle, because I can't find a normal unit! {wep[i]}; Column ID: {id}; Enemy Unit: {wep_owner[i]}");
                            continue;
                        } else if (instance_number(obj_pnunit)>1) and (obj_ncombat.enemy!=7) {
                            var x2=enemy.x;
                            repeat(instance_number(obj_pnunit)-1){
                                x2 += flank == 0 ? -10 : 10;
                                var enemy2=instance_nearest(x2,y,obj_pnunit);
                                if (!target_block_is_valid(enemy2, obj_pnunit)) {
                                    continue;
                                }
                                if (range[i] < get_block_distance(enemy2)) {
                                    break;
                                }
                                if (block_has_armour(enemy2)) {
                                    scr_shoot(i,enemy2,target_unit_index,"att","ranged");
                                    // show_debug_message($"I'm shooting at a vehicle in another row, because I can't find a normal unit! {wep[i]}; Column ID: {id}; Enemy Unit: {wep_owner[i]}");
                                    break;
                                }
                            }
                        }
                    } else {
                        enemy=instance_nearest(x,y,obj_nfort);
                        if (range[i] >= get_block_distance(enemy)) {
                            scr_shoot(i,enemy,1,"att","wall");
                            // show_debug_message($"I'm shooting at a fort, because I can't find a normal unit! {wep[i]}; Column ID: {id}; Enemy Unit: {wep_owner[i]}");
                            continue;
                        }
                    }
                }
            }
        } else {
            // show_debug_message($"I can't shoot, my range is too small! Weapon: {wep[i]}; Column ID: {id}; Enemy Unit: {wep_owner[i]}; Range: {range[i]}");
            continue;  
        }
        log_error($"{wep[i]} didn't find a valid target! This shouldn't happen!");
        // show_debug_message($"We didn't find a valid target! Weapon: {wep[i]}; Column ID: {id}; Enemy Unit: {wep_owner[i]}");
    }
}
//TODO: The melee code was not refactored;
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
        //show_debug_message($"{range[i]},{att[i]},{apa[i]},{wep[i]},{enemy}")
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

//TODO: Everything bellow has to be scrapped and reworked;
//! Commented out stuff bellow, until I understand why it exists;
/* __b__ = action_if_variable(image_index, -500, 0);
if (__b__) {
    var leftest, charge = 0,
        enemy2 = 0;

    with(obj_pnunit) {
        if (x < -4000) {
            instance_deactivate_object(id);
        }
    }

    if (flank == 0) {
        move_unit_block("west");
        // instance_activate_object(obj_cursor);
    }
    if (flank == 1) {
        enemy = instance_nearest(x, y, obj_pnunit); // Right most enemy
        enemy2 = enemy;
        // if (collision_point(x+10,y,obj_pnunit,0,1)) then engaged=1;
        // if (!collision_point(x+10,y,obj_pnunit,0,1)) then engaged=0;
        move_unit_block();

        if (!position_empty(x + 10, y)) {
            engaged = 1;
        } // Quick smash
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
} */
