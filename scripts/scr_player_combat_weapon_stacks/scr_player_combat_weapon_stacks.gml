// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function add_second_profiles_to_stack(weapon, head_role = false, unit = "none") {
    if (array_length(weapon.second_profiles) > 0) {
        //for adding in intergrated weaponry
        var _secondary_profile;
        for (var p = 0; p < array_length(weapon.second_profiles); p++) {
            if (is_string(weapon.second_profiles[p])) {
                _secondary_profile = gear_weapon_data("weapon", weapon.second_profiles[p], "all");
            } else {
                _secondary_profile = weapon.second_profiles[p];
            }
            if (!is_struct(_secondary_profile)) {
                continue;
            }
            var wep_index = find_stack_index(_secondary_profile.name, head_role, unit);
            if (wep_index > -1) {
                add_data_to_stack(wep_index, _secondary_profile);
            }
        }
    }
}


function add_data_to_stack (stack_index, weapon, unit_damage=false, head_role=false, unit="none"){
    if (unit_damage){
        att[stack_index]+=unit_damage;
    } else {
        att[stack_index]+=weapon.attack;
    }
    apa[stack_index]=weapon.arp;
    range[stack_index]=weapon.range;
    wep_num[stack_index]++;
    splash[stack_index]=weapon.spli;
    wep[stack_index]=weapon.name;
    if (obj_ncombat.started=0) then ammo[stack_index]=weapon.ammo;

    if (unit!="none"){//this stops a potential infinite loop of secondary profiles
        add_second_profiles_to_stack(weapon, head_role, unit);
    }
}

function find_stack_index (weapon_name, head_role=false, unit="none"){
    final_index = -1;
    var allow = false;
    for (var stack_index=1;stack_index<array_length(wep);stack_index++){
        allow = false
        if (is_struct(unit)){
            allow = (head_role && ( wep_title[stack_index] == unit.role())) && (wep[stack_index]==weapon_name);
        }
        if (!allow){
            allow = ((wep[stack_index]=="" || (wep[stack_index]==weapon_name && !head_role)) && wep_title[stack_index]=="");
        }

        if (allow){
            final_index = stack_index;
            break;
        }
    }
    return final_index;
}

function player_head_role_stack(stack_index, unit) {
    wep_title[stack_index]=unit.role();
    if (!array_contains(wep_solo[stack_index], unit.name())) then array_push(wep_solo[stack_index], unit.name());
}

/// @mixin
function scr_player_combat_weapon_stacks() {
    if (defenses=1){
        var i=0;

        i+=1;
        wep[i]="Heavy Bolter Emplacement";
        wep_num[i]=round(obj_ncombat.player_defenses/2);
        range[i]=99;
        att[i]=160*wep_num[i];
        apa[i]=0;
        ammo[i]=-1;
        splash[i]=1;

        i+=1;
        wep[i]="Missile Launcher Emplacement";
        wep_num[i]=round(obj_ncombat.player_defenses/2);
        range[i]=99;
        att[i]=200*wep_num[i];
        apa[i]=120*wep_num[i];
        ammo[i]=-1;
        splash[i]=1;

        i+=1;
        wep[i]="Missile Silo";
        wep_num[i]=min(30,obj_ncombat.player_silos);
        range[i]=99;
        att[i]=350*wep_num[i];
        apa[i]=200*wep_num[i];
        ammo[i]=-1;
        splash[i]=1;

        var rightest=instance_nearest(2000,240,obj_pnunit);
        if (rightest.id=self.id) then instance_destroy();
    }
    if (defenses=1) then exit;


    var i,g=0;
    veh=0;
    men=0;
    dreads=0;
    for (i=0;i<array_length(att);i++) {
        // dudes[i]="";
        dudes_num[i]=0;
        // dudes_vehicle[i]=0;
        att[i]=0;
        apa[i]=0;
        wep_num[i]=0;
        wep_rnum[i]=0;
        // if (wep_owner[i]!="") and (wep_num[i]>1) then wep_owner[i]="assorted";// What if they are using two ranged weapons?  Hmmmmm?
    }

    var dreaded=false, unit;

    var mobi_item;
    for (g=0;g<array_length(unit_struct);g++) {
        unit = unit_struct[g];
        if (is_struct(unit)) {
            if (unit.hp()>0) then marine_dead[g]=0;
            if (unit.hp()>0 && marine_dead[g]!=true){
                var head_role = unit.IsSpecialist();
                var armour_data = unit.get_armour_data();
                var is_dreadnought = false;
                if (is_struct(armour_data)){
                     is_dreadnought = armour_data.has_tag("dreadnought");
                }
                var unit_hp =unit.hp();

                if (unit_hp) {
                    if (is_dreadnought) {
                        dreads+=1;
                        dreaded=true;
                    } else {
                        men+=1;
                    }
                }

                var mobi_item = unit.get_mobility_data();
                var gear_item = unit.get_gear_data();
                var armour_item = unit.get_armour_data();

                if (unit.mobility_item() != "Bike" && unit.mobility_item() != "") {
                    if (is_struct(mobi_item)){
                        if (mobi_item.has_tag("jump")) {
                            var stack_index = find_stack_index("Hammer of Wrath", head_role, unit);
                            if (stack_index > -1){
                                add_data_to_stack(stack_index, unit.hammer_of_wrath(), false, head_role, unit);
                                ammo[stack_index] = -1;
                                if (head_role){
                                    player_head_role_stack(stack_index, unit);
                                }
                            }
                        }
                    }
                }

                if (is_struct(mobi_item)){
                    add_second_profiles_to_stack(mobi_item);
                }
                if (is_struct(gear_item)){
                    add_second_profiles_to_stack(gear_item);
                }
                if (is_struct(armour_item)){
                    add_second_profiles_to_stack(armour_item);
                }

                if (unit.IsSpecialist(SPECIALISTS_LIBRARIANS, true) || (unit.role() == obj_ini.role[100][eROLE.ChapterMaster] && obj_ncombat.chapter_master_psyker == 1)) {
                    if (marine_casting_cooldown[g] == 0) {
                        if (array_length(unit.powers_known) > 0) {
                            if (marine_casting[g] == true) {
                                marine_casting[g] = false;
                            }

                            var cast_target = unit.perils_threshold() * 2;
                            var cast_dice = roll_dice(1, 100);
                            if (unit.has_trait("warp_tainted")) {
                                cast_dice += 40;
                            }

                            if (cast_dice >= cast_target) {
                                marine_casting[g] = true;
                            }
                        }
                    } else {
                        marine_casting_cooldown[g]--;
                    }
                }

                var j=0,good=0,open=0;// Counts the number and types of marines within this object
                for (j=0;j<=40;j++){
                    if (dudes[j]=="") and (open==0){
                        open=j;// Determine if vehicle here

                        //if (dudes[j]="Venerable "+string(obj_ini.role[100][6])) then dudes_vehicle[j]=1;
                        //if (dudes[j]=obj_ini.role[100][6]) then dudes_vehicle[j]=1;
                    }
                    if (marine_type[g]==dudes[j]){
                        good=1;
                        dudes_num[j]+=1;
                    }
                    if (good=0) and (open!=0){
                        dudes[open]=marine_type[g];
                        dudes_num[open]=1;
                    }
                }
                if (marine_casting[g] == false){
                    var weapon_stack_index=0;
                    var primary_ranged = unit.ranged_damage_data[3];//collect unit ranged data
                    var weapon_stack_index = find_stack_index(primary_ranged.name, head_role, unit);
                    if (weapon_stack_index>-1){
                        add_data_to_stack(weapon_stack_index,primary_ranged,unit.ranged_damage_data[0], head_role,unit);
                        if (head_role){
                            player_head_role_stack(weapon_stack_index,unit);
                        }
                    }


                    var primary_melee = unit.melee_damage_data[3];//collect unit melee data
                    var weapon_stack_index = find_stack_index(primary_melee.name, head_role, unit);
                    if (weapon_stack_index>-1){
                        if (range[weapon_stack_index]>1.9) then continue//creates secondary weapon stack for close combat ranged weaponry use
                        primary_melee.range=1;
                        add_data_to_stack(weapon_stack_index,primary_melee,unit.melee_damage_data[0], head_role,unit);
                        if (head_role){
                            player_head_role_stack(weapon_stack_index,unit);
                         }
                        if (floor(primary_melee.range)<=1 && primary_melee.ammo == 0){
                            ammo[weapon_stack_index]=-1; //no ammo limit
                        }
                    }
                }
            }
        }
    }
    for (g=0;g<array_length(veh_id);g++) {
        if (veh_id[g]>0) and (veh_hp[g]>0) and (veh_dead[g]!=1){
            if (veh_id[g]>0) and (veh_hp[g]>0) then veh_dead[g]=0;
            if (veh_hp[g]>0) then veh++;

            var j=0,good=0,open=0;// Counts the number and types of marines within this object
            if (veh_dead[g]!=1) then repeat(40){j+=1;
                if (dudes[j]="") and (open=0){
                    open=j;
                }
                if (veh_type[g]=dudes[j]){
                    good=1;
                    dudes_num[j]+=1;
                    dudes_vehicle[j]=1;
                }
                if (good=0) and (open!=0){
                    dudes[open]=veh_type[g];
                    dudes_num[open]=1;
                    dudes_vehicle[open]=1;
                }
            }

            var j=0,good=0,open=0, weapon, vehicle_weapon_set;
            if (veh_dead[g]!=1){
                vehicle_weapon_set = [veh_wep1[g],veh_wep2[g],veh_wep3[g]]
                for (var wep_slot=0;wep_slot<3;wep_slot++){
                    var weapon_check = vehicle_weapon_set[wep_slot];
                    if (weapon_check!=""){
                        weapon=gear_weapon_data("weapon",weapon_check,"all", false, "standard");
                        if (is_struct(weapon)){
                            for (j=0;j<=40;j++){
                                if (wep[j]==""||wep[j]==weapon.name){
                                    add_data_to_stack(j,weapon);
                                    break;
                                }
                            }
                        }
                    }
                }
            }
        }
    }


    // Right here should be retreat- if important units are exposed they should try to hop left




    if (dudes_num[1]=0) and (obj_ncombat.started=0){
        instance_destroy();
        exit;
    }


    if (men==1) and (veh==0)and (obj_ncombat.player_forces=1) {
        var h=0;
        for (var i=0;i<array_length(unit_struct);i++) {
            if (h=0) {
                unit = unit_struct[i];
                if (!is_struct(unit)) then continue;
                if (unit.hp()>0) and (marine_dead[i]=0){
                    h=unit.hp();
                    obj_ncombat.display_p1=h;
                    obj_ncombat.display_p1n=unit.name_role();
                    break;
                }
            }
        }
    }
}


function scr_add_unit_to_roster(unit, is_local=false,is_ally=false){
    array_push(unit_struct, unit);
    array_push(marine_co, unit.company);
    array_push(marine_id, unit.marine_number);
    array_push(marine_type, unit.role());
    array_push(marine_wep1, unit.weapon_one());
    array_push(marine_wep2, unit.weapon_two());
    array_push(marine_armour, unit.armour());
    array_push(marine_gear, unit.gear());
    array_push(marine_mobi, unit.mobility_item());
    array_push(marine_hp, unit.hp());
    array_push(marine_mobi, unit.mobility_item());
    array_push(marine_exp, unit.experience);
    array_push(marine_powers, unit.specials());
    array_push(marine_ranged, unit.ranged_attack());
    array_push(marine_powers, unit.specials());
    array_push(marine_ac, unit.armour_calc());
    array_push(marine_attack, unit.melee_attack());
    array_push(marine_local, is_local);
    array_push(marine_casting, false);
    array_push(marine_casting_cooldown, 0);
    array_push(marine_defense, 1);

    array_push(marine_dead, 0);
    array_push(marine_mshield, 0);
    array_push(marine_quick, 0);
    array_push(marine_might, 0);
    array_push(marine_fiery, 0);
    array_push(marine_fshield, 0);
    array_push(marine_iron, 0);
    array_push(marine_dome, 0);
    array_push(marine_spatial, 0);
    array_push(marine_dementia, 0);
    array_push(ally, is_ally);
    if (is_local){
        local_forces=true;
    }
    if (unit.IsSpecialist(SPECIALISTS_DREADNOUGHTS)){
        dreads++;
    } else {
        men++;
    }
}

function cancel_combat(){
     with(obj_pnunit) {
        instance_destroy();
    }
    with(obj_enunit) {
        instance_destroy();
    }
    with(obj_nfort) {
        instance_destroy();
    }
    with(obj_ncombat) {
        instance_destroy();
    }   
}
