try {
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
        move_unit_block("east");
    }

    if (!instance_exists(enemy)) then exit;
    if (collision_point(x+10,y,obj_enunit,0,1)) or (collision_point(x-10,y,obj_enunit,0,1)) then engaged=1;
    if (!collision_point(x+10,y,obj_enunit,0,1)) and (!collision_point(x-10,y,obj_enunit,0,1)) then engaged=0;

    var once_only;once_only=0;
    var range_shoot="";
    var dist=point_distance(x,y,enemy.x,enemy.y)/10;

    //* Psychic power buffs
    for (var i = 0; i < array_length(unit_struct); i++) {
        if (marine_mshield[i] > 0) {
            marine_mshield[i] -= 1;
        }
        if (marine_quick[i] > 0) {
            marine_quick[i] -= 1;
        }
        if (marine_might[i] > 0) {
            marine_might[i] -= 1;
        }
        if (marine_fiery[i] > 0) {
            marine_fiery[i] -= 1;
        }
        if (marine_fshield[i] > 0) {
            marine_fshield[i] -= 1;
        }
        if (marine_dome[i] > 0) {
            marine_dome[i] -= 1;
        }
        if (marine_spatial[i] > 0) {
            marine_spatial[i] -= 1;
        }
    }

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

    if (instance_exists(obj_enunit)) {
        for (var i = 0; i < array_length(unit_struct); i++) {
            if (marine_dead[i] == 0 && marine_casting[i] == true) {
                var caster_id = i;
                scr_powers(caster_id);
            }
        }
    }
} catch (_exception) {
    // show_debug_message($"known_powers: {known_powers}");
    // show_debug_message($"buff_powers: {buff_powers}");
    // show_debug_message($"buff_cast: {buff_cast}");
    // show_debug_message($"power_index: {power_index}");
    // show_debug_message($"known_attack_powers: {known_attack_powers}");
    // show_debug_message($"known_buff_powers: {known_buff_powers}");
    handle_exception(_exception);
}