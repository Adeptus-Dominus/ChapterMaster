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

            add_data_to_stack(_secondary_profile, 0, head_role, unit);
        }
    }
}

/// @mixin
function add_data_to_stack (weapon, unit_damage=0, head_role=false, unit="none"){
    var _attack = unit_damage > 0 ? unit_damage : weapon.attack;
	var _stack_type = {};
    var _owner_name = unit == "none" ? "Vehicle" : $"{unit.role()} {unit.name()}";

	if (unit != "none" && head_role) {
		if (!struct_exists(weapon_stacks_unique, unit.name())) {
			struct_set(weapon_stacks_unique, unit.name(), {});
		}
		_stack_type = weapon_stacks_unique[$ unit.name()];
	} else if (unit != "none") {
		_stack_type = weapon_stacks_normal;
	} else {
		_stack_type = weapon_stacks_vehicle;
	}

	if (struct_exists(_stack_type, weapon.name)) {
		var _weapon_stack = _stack_type[$ weapon.name];
		_weapon_stack.weapon_count++;
	
		if (!array_contains(_weapon_stack.owners, _owner_name)) {
			array_push(_weapon_stack.owners, _owner_name);
		}
	} else {
		var _weapon_stack = new WeaponStack(weapon.name);
		_weapon_stack.attack = _attack;
		_weapon_stack.piercing = weapon.arp;
		_weapon_stack.range = weapon.range;
		_weapon_stack.weapon_count++;
		_weapon_stack.shot_count = weapon.spli;
		array_push(_weapon_stack.owners, _owner_name);
	
		if (obj_ncombat.started == 0) {
			_weapon_stack.ammo_max = weapon.ammo;
			_weapon_stack.ammo_current = weapon.ammo;
			_weapon_stack.ammo_reload = weapon.reload;
		}
	
		struct_set(_stack_type, weapon.name, _weapon_stack);
	}


    if (unit!="none"){//this stops a potential infinite loop of secondary profiles
        add_second_profiles_to_stack(weapon, head_role, unit);
    }
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
        ammo_max[i]=-1;
        splash[i]=1;

        i+=1;
        wep[i]="Missile Launcher Emplacement";
        wep_num[i]=round(obj_ncombat.player_defenses/2);
        range[i]=99;
        att[i]=200*wep_num[i];
        apa[i]=120*wep_num[i];
        ammo_max[i]=-1;
        splash[i]=1;

        i+=1;
        wep[i]="Missile Silo";
        wep_num[i]=min(30,obj_ncombat.player_silos);
        range[i]=99;
        att[i]=350*wep_num[i];
        apa[i]=200*wep_num[i];
        ammo_max[i]=-1;
        splash[i]=1;

        var rightest=instance_nearest(2000,240,obj_pnunit);
        if (rightest.id=self.id) then instance_destroy();
    }
    if (defenses=1) then exit;

    weapon_stacks_normal = {};
    weapon_stacks_vehicle = {};
    weapon_stacks_unique = {};

    var i,g=0;
    veh=0;
    men=0;
    dreads=0;

    var dreaded=false, unit;

    var mobi_item;
    var _unit_struct_len = array_length(unit_struct);
    for (g=0;g<_unit_struct_len;g++) {
        unit = unit_struct[g];

        //* Buffs
        if (marine_mshield[g] > 0) {
            marine_mshield[g] -= 1;
        }
        if (marine_quick[g] > 0) {
            marine_quick[g] -= 1;
        }
        if (marine_might[g] > 0) {
            marine_might[g] -= 1;
        }
        if (marine_fiery[g] > 0) {
            marine_fiery[g] -= 1;
        }
        if (marine_fshield[g] > 0) {
            marine_fshield[g] -= 1;
        }
        if (marine_dome[g] > 0) {
            marine_dome[g] -= 1;
        }
        if (marine_spatial[g] > 0) {
            marine_spatial[g] -= 1;
        }

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
                            add_data_to_stack(unit.hammer_of_wrath(), 0, head_role, unit);
                        }
                    }
                }

                if (is_struct(mobi_item)){
                    add_second_profiles_to_stack(mobi_item, head_role, unit);
                }
                if (is_struct(gear_item)){
                    add_second_profiles_to_stack(gear_item, head_role, unit);
                }
                if (is_struct(armour_item)){
                    add_second_profiles_to_stack(armour_item, head_role, unit);
                }

                if (unit.IsSpecialist(SPECIALISTS_LIBRARIANS, true) || (unit.role() == "Chapter Master" && obj_ncombat.chapter_master_psyker == 1)) {
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
                    var primary_ranged = unit.ranged_damage_data[3];//collect unit ranged data
                    if (primary_ranged.name != "") {
                        add_data_to_stack(primary_ranged,unit.ranged_damage_data[0], head_role,unit);
                    }

                    var primary_melee = unit.melee_damage_data[3];//collect unit melee data
                    if (primary_melee.name != "") {
                        add_data_to_stack(primary_melee,unit.melee_damage_data[0], head_role,unit);
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
                            add_data_to_stack(weapon);
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

function set_up_player_blocks_turn(){
    if (instance_exists(obj_pnunit)){
        with (obj_pnunit){
            alarm[3]=2;
            wait_and_execute(3, scr_player_combat_weapon_stacks);
            alarm[0]=4;
        }
    }
    turn_count++;        
}

function reset_combat_message_arrays(){
    messages=0;
    messages_to_show=8;
    largest=0;
    random_messages=0;
    priority=0;
    messages_shown=0;
    for (var i=0;i<array_length(message);i++){
        message[i]="";
        message_sz[i]=0;
        message_priority[i]=0;
    }
    timer_stage=4;
    timer=0;
    done=0;
    messages_shown=0;   
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
