/// @mixin
function add_marines_to_recovery() {
    var _roles = active_roles();
    for (var i = 0; i < array_length(unit_struct); i++) {
        var _unit = unit_struct[i];
        if (is_struct(_unit) && ally[i] == false) {
            if (marine_dead[i] == 1 && marine_type[i] != "") {
                var _role_priority_bonus = 0;
                var _chief_librarian = $"Chief {_roles[eROLE.Librarian]}";
                switch (_unit.role()) {
                    case "Chapter Master":
                        _role_priority_bonus = 720;
                        break;
                    case "Forge Master":
                    case "Master of Sanctity":
                    case "Master of the Apothecarion":
                    case _chief_librarian:
                        _role_priority_bonus = 360;
                        break;
                    case _roles[eROLE.Captain]:
                    case _roles[eROLE.HonourGuard]:
                    case _roles[eROLE.Ancient]:
                        _role_priority_bonus = 160;
                        break;
                    case _roles[eROLE.VeteranSergeant]:
                    case _roles[eROLE.Terminator]:
                        _role_priority_bonus = 80;
                        break;
                    case _roles[eROLE.Veteran]:
                    case _roles[eROLE.Sergeant]:
                    case _roles[eROLE.Champion]:
                    case _roles[eROLE.Chaplain]:
                    case _roles[eROLE.Apothecary]:
                    case _roles[eROLE.Techmarine]:
                    case _roles[eROLE.Librarian]:
                    case "Codiciery":
                    case "Lexicanum":
                        _role_priority_bonus = 40;
                        break;
                    case _roles[eROLE.Tactical]:
                    case _roles[eROLE.Assault]:
                    case _roles[eROLE.Devastator]:
                        _role_priority_bonus = 20;
                        break;
                    case _roles[eROLE.Scout]:
                    default:
                        _role_priority_bonus = 0;
                        break;
                }

                var _priority = _unit.experience + _role_priority_bonus;
                var _recovery_candidate = {
                    "id": i,
                    "unit": _unit,
                    "column_id": id,
                    "priority": _priority
                };

                ds_priority_add(obj_ncombat.marines_to_recover, _recovery_candidate, _recovery_candidate.priority);
            }
        }
    }
}

/// @mixin
function add_vehicles_to_recovery() {
    var _vehicles_priority = {
        "Land Raider": 10,
        "Predator": 5,
        "Whirlwind": 4,
        "Rhino": 3,
        "Land Speeder": 3,
        "Bike": 1
    }

    for (var i = 0; i < array_length(veh_dead); i++) {
        if (veh_dead[i] && !veh_ally[i] && veh_type[i] != "") {
            var _priority = 1;
            if (struct_exists(_vehicles_priority, veh_type[i])) {
                _priority = _vehicles_priority[$ veh_type[i]];
            }

            var _recovery_candidate = {
                "id": i,
                "column_id": id,
                "priority": _priority
            };

            ds_priority_add(obj_ncombat.vehicles_to_recover, _recovery_candidate, _recovery_candidate.priority);
        } else {
            continue;
        }
    }
}

/// @mixin
function assemble_alive_units() {
    for (var i = 0; i < array_length(unit_struct); i++) {
        var _unit = unit_struct[i];
        if (is_struct(_unit) && ally[i] == false) {
            if (!marine_dead[i]) {
                array_push(obj_ncombat.end_alive_units, _unit);
            }
        }
    }
}

function distribute_experience(_units, _exp_amount) {
    var _eligible_units_count = array_length(_units);
    var _average_exp = 0;

    if (_eligible_units_count > 0 && _exp_amount > 0) {
        var _individual_exp = _exp_amount / _eligible_units_count;
        _average_exp = _individual_exp;
        for (var i = 0; i < _eligible_units_count; i++) {
            var _unit = _units[i];
            var _exp_mod = max(1 - (_unit.experience / 200), 0.1);
            var _exp_update_data = _unit.add_exp(_individual_exp*_exp_mod);

            var _powers_learned = _exp_update_data[1];
            if (_powers_learned > 0) {
                array_push(obj_ncombat.upgraded_librarians, _unit);
            }

        }
    }

    return _average_exp;
}

/// @mixin
function after_battle_part2() {
    var _unit;

    for (var i=0;i<array_length(unit_struct);i++){
        _unit=unit_struct[i];
        if (marine_dead[i]=0) and (marine_type[i]=="Death Company"){
            if( _unit.role()!="Death Company"){
                _unit.update_role("Death Company");
            }
        }
        if (_unit.base_group=="astartes"){
            if (marine_dead[i]=0) and (_unit.gene_seed_mutations.mucranoid==1) and (ally[i]=false){
                var muck=roll_personal_dice(1,100,"high",_unit);
                if (muck==1){    //slime  armour damaged due to mucranoid
                    if (_unit.armour != ""){
                        obj_controller.specialist_point_handler.add_to_armoury_repair(_unit.armour());
                        obj_ncombat.mucra[marine_co[i]]=1;
                        obj_ncombat.slime+=_unit.get_armour_data("maintenance");
                    }
                }
            }
        }

        if (ally[i]=false){
            if (marine_dead[i]=0) and (obj_ini.gear[marine_co[i],marine_id[i]]="Plasma Bomb") and (obj_ncombat.defeat=0) and (string_count("mech",obj_ncombat.battle_special)=0){
                if (obj_ncombat.plasma_bomb=0) and (obj_ncombat.enemy=13) and (awake_tomb_world(obj_ncombat.battle_object.p_feature[obj_ncombat.battle_id])==1){
                    if (((obj_ncombat.battle_object.p_necrons[obj_ncombat.battle_id]-2)<3) and (obj_ncombat.dropping!=0)) or ((obj_ncombat.battle_object.p_necrons[obj_ncombat.battle_id]-1)<3){
                        obj_ncombat.plasma_bomb+=1;
                        obj_ini.gear[marine_co[i],marine_id[i]]="";
                    }
                }
            }
            if (marine_dead[i]=0) and (obj_ini.gear[marine_co[i],marine_id[i]]="Exterminatus") and (obj_ncombat.dropping!=0) and (obj_ncombat.defeat=0){
                if (obj_ncombat.exterminatus=0){
                    obj_ncombat.exterminatus+=1;
                    _unit.update_gear("", false,false);
                }
                // obj_ncombat.exterminatus+=1;scr_add_item("Exterminatus",1);
                // obj_ini.gear[marine_co[i],marine_id[i]]="";
            }
        }

        var destroy;destroy=0;
        if ((marine_dead[i]>0) or (obj_ncombat.defeat!=0)) and (marine_type[i]!="") and (ally[i]=false){
            var comm=false;
            if (_unit.IsSpecialist(SPECIALISTS_STANDARD,true)){
                obj_ncombat.final_command_deaths+=1;
                var recent=true;
                if (is_specialist(_unit.role, SPECIALISTS_TRAINEES)){
                    recent=false
                } else if (array_contains([string("Venerable {0}",obj_ini.role[100][6]), "Codiciery", "Lexicanum"], _unit.role())){
                    recent=false
                }
                if (recent=true) then scr_recent("death_"+string(marine_type[i]),string(obj_ini.name[marine_co[i],marine_id[i]]),marine_co[i]);            
            } else {
                obj_ncombat.final_marine_deaths+=1;
            }
            // obj_ncombat.final_marine_deaths+=1;

            // show_message("ded; increase final deaths");

            if (obj_controller.blood_debt=1){
                if (_unit.role()==obj_ini.role[100][12]){
                    obj_controller.penitent_current+=2
                } else {obj_controller.penitent_current+=4;}
                obj_controller.penitent_turn=0;
                obj_controller.penitent_turnly=0;
            }

            if (obj_ini.race[marine_co[i], marine_id[i]] == 1) {
                var _birthday = obj_ini.age[marine_co[i], marine_id[i]];
                var _current_year = (obj_controller.millenium * 1000) + obj_controller.year;
                var _seed_harvestable = 0;
                var _seed_lost = 0;

                if (_birthday <= (_current_year - 10) && obj_ini.zygote == 0) {
                    _seed_lost++;
                    if (irandom_range(1, 10) > 1) {
                        _seed_harvestable++;
                    }
                }
                if (_birthday <= (_current_year - 5)) {
                    _seed_lost++;
                    if (irandom_range(1, 10) > 1) {
                        _seed_harvestable++;
                    }
                }

                obj_ncombat.seed_harvestable += _seed_harvestable;
                obj_ncombat.seed_lost += _seed_lost;
            }

            var last=0;
    
            var _unit_role = _unit.role();
            if (!struct_exists(obj_ncombat.units_lost_counts, _unit_role)) {
                obj_ncombat.units_lost_counts[$ _unit_role] = 1;
            } else {
                obj_ncombat.units_lost_counts[$ _unit_role]++;
            }

            // Determine which companies to crunch
            obj_ncombat.crunch[marine_co[i]]=1;
            destroy=1;
        }

        if (marine_armour[i]="") and (marine_wep1[i]="") and (marine_wep2[i]="") and (marine_gear[i]="") and (marine_mobi[i]="") and (marine_type[i]!="") then destroy=2;

        if (destroy>0) and (marine_type[i]!="") and (ally[i]=false){// 135
            var wah=0,artif=false;
            repeat(5){
                wah+=1;
                artif=false;
                var eqp_chance, dece;
                eqp_chance=50;
                dece=floor(random(100))+1;
                if (obj_ncombat.defending=false) then eqp_chance-=10;
                if (obj_ncombat.dropping=1) then eqp_chance-=20;
                if (obj_ncombat.dropping=1) and (obj_ncombat.defeat=1) then dece=9999;
                if (marine_dead[i]=2) or (destroy=2) then dece=9999;
                if (obj_ini.race[marine_co[i],marine_id[i]]!=1) then dece=9999;

                // if (wah=1){show_message(obj_ini.armour[marine_co[i],marine_id[i]]);}
                arti=!is_string(_unit.armour(true));
                var arm_data = _unit.get_armour_data();
                if (wah=1) and (is_struct(arm_data)){
                    if (arm_data.has_tag("terminator")) then eqp_chance+=30;
                    if (string_count("&",marine_armour[i])>0){
                        eqp_chance=90;
                        artif=true;
                    }
                    if (dece>eqp_chance){
                        var last=0;o=0;
                        repeat(50){
                            if (last=0){
                                o+=1;artif=false;
                                if (obj_ncombat.post_equipment_lost[o]=marine_armour[i]){
                                    last=1;
                                    obj_ncombat.post_equipments_lost[o]+=1;
                                    artif=true;
                                }
                                if (obj_ncombat.post_equipment_lost[o]="") and (last=0){last=o;
                                    obj_ncombat.post_equipment_lost[o]=marine_armour[i];
                                    obj_ncombat.post_equipments_lost[o]=1;
                                    artif=true;
                                }
                                if (artif=true) then obj_ncombat.post_equipment_lost[o]=clean_tags(obj_ncombat.post_equipment_lost[o]);

                                obj_ini.armour[marine_co[i],marine_id[i]]="";
                                // wep2[0,i]="";armour[0,i]="";gear[0,i]="";mobi[0,i]="";
                            }
                        }
                    }
                    if (dece<=eqp_chance) then scr_add_item(marine_armour[i],1);
                }
                if (wah=2) and (obj_ini.wep1[marine_co[i],marine_id[i]]!=""){
                    if (string_count("&",marine_wep1[i])>0){eqp_chance=90;artif=true;}
                    if (marine_wep1[i]="Company Standard") then eqp_chance=99;
                    if (marine_dead[i]=2) or (destroy=2) then dece=9999;
                    if (obj_ini.race[marine_co[i],marine_id[i]]!=1) then dece=9999;

                    if (dece>eqp_chance){
                        var last,o;last=0;o=0;
                        repeat(50){
                            if (last=0){
                                o+=1;artif=false;

                                // show_message(string(o)+"]"+string(obj_ncombat.post_equipment_lost[o])+"   "+string(i)+"]"+string(marine_wep1[i]));

                                if (string(obj_ncombat.post_equipment_lost[o])=marine_wep1[i]){last=1;obj_ncombat.post_equipments_lost[o]+=1;artif=true;}
                                if (string(obj_ncombat.post_equipment_lost[o])="") and (last=0){last=o;obj_ncombat.post_equipment_lost[o]=marine_wep1[i];obj_ncombat.post_equipments_lost[o]=1;artif=true;}
                                if (artif=true) then obj_ncombat.post_equipment_lost[o]=clean_tags(obj_ncombat.post_equipment_lost[o]);
                                obj_ini.wep1[marine_co[i],marine_id[i]]="";
                                // wep2[0,i]="";armour[0,i]="";gear[0,i]="";mobi[0,i]="";
                            }
                        }
                    }
                    if (dece<=eqp_chance) then scr_add_item(marine_wep1[i],1);
                }
                if (wah=3) and (obj_ini.wep2[marine_co[i],marine_id[i]]!=""){
                    if (string_count("&",marine_wep2[i])>0){eqp_chance=90;artif=true;}
                    if (marine_wep2[i]="Company Standard") then eqp_chance=99;
                    if (marine_dead[i]=2) or (destroy=2) then dece=9999;
                    if (obj_ini.race[marine_co[i],marine_id[i]]!=1) then dece=9999;

                    if (dece>eqp_chance){
                        var last,o;last=0;o=0;
                        repeat(50){
                            if (last=0){
                                o+=1;artif=false;
                                if (string(obj_ncombat.post_equipment_lost[o])=marine_wep2[i]){last=1;obj_ncombat.post_equipments_lost[o]+=1;artif=true;}
                                if (string(obj_ncombat.post_equipment_lost[o])="") and (last=0){last=o;obj_ncombat.post_equipment_lost[o]=marine_wep2[i];obj_ncombat.post_equipments_lost[o]=1;artif=true;}
                                if (artif=true) then obj_ncombat.post_equipment_lost[o]=clean_tags(obj_ncombat.post_equipment_lost[o]);
                                obj_ini.wep2[marine_co[i],marine_id[i]]="";
                                // wep2[0,i]="";armour[0,i]="";gear[0,i]="";mobi[0,i]="";
                            }
                        }
                    }
                    if (dece<=eqp_chance) then scr_add_item(marine_wep2[i],1);
                }
                if (wah=4) and (obj_ini.gear[marine_co[i],marine_id[i]]!=""){
                    if (string_count("&",marine_gear[i])>0){eqp_chance=90;artif=true;}
                    if (marine_dead[i]=2) or (destroy=2) then dece=9999;
                    if (obj_ini.race[marine_co[i],marine_id[i]]!=1) then dece=9999;

                    if (obj_ini.gear[marine_co[i],marine_id[i]]="Exterminatus"){
                        if (obj_ncombat.defeat=0){
                            dece=0;
                            if (obj_ncombat.dropping!=0) then obj_ncombat.exterminatus+=1;
                        }
                        if (obj_ncombat.defeat!=0) then dece=9999;
                    }

                    if (dece>eqp_chance){
                        var last,o;last=0;o=0;
                        repeat(50){
                            if (last=0){
                                o+=1;artif=false;
                                if (obj_ncombat.post_equipment_lost[o]=marine_gear[i]){last=1;obj_ncombat.post_equipments_lost[o]+=1;artif=true;}
                                if (obj_ncombat.post_equipment_lost[o]="") and (last=0){last=o;obj_ncombat.post_equipment_lost[o]=marine_gear[i];obj_ncombat.post_equipments_lost[o]=1;artif=true;}
                                if (artif=true) then obj_ncombat.post_equipment_lost[o]=clean_tags(obj_ncombat.post_equipment_lost[o]);
                                obj_ini.gear[marine_co[i],marine_id[i]]="";
                                // wep2[0,i]="";armour[0,i]="";gear[0,i]="";mobi[0,i]="";
                            }
                        }
                    }
                    if (dece<=eqp_chance) then scr_add_item(marine_gear[i],1);
                }
                if (wah=5) and (obj_ini.mobi[marine_co[i],marine_id[i]]!=""){
                    if (string_count("&",marine_mobi[i])>0){
                        eqp_chance=90;
                        artif=true;
                    }
                    if (marine_dead[i]=2) or (destroy=2) then dece=9999;
                    if (obj_ini.race[marine_co[i],marine_id[i]]!=1) then dece=9999;

                    if (dece>eqp_chance){
                        var last,o;last=0;o=0;
                        repeat(50){
                            if (last=0){
                                o+=1;
                                artif=false;
                                if (obj_ncombat.post_equipment_lost[o]=marine_mobi[i]){
                                    last=1;
                                    obj_ncombat.post_equipments_lost[o]+=1;
                                    artif=true;
                                }
                                if (obj_ncombat.post_equipment_lost[o]="") and (last=0){last=o;obj_ncombat.post_equipment_lost[o]=marine_mobi[i];obj_ncombat.post_equipments_lost[o]=1;artif=true;}
                                if (artif=true) then obj_ncombat.post_equipment_lost[o]=clean_tags(obj_ncombat.post_equipment_lost[o]);
                                obj_ini.mobi[marine_co[i],marine_id[i]]="";
                                // wep2[0,i]="";armour[0,i]="";gear[0,i]="";mobi[0,i]="";
                            }
                        }
                    }
                    if (dece<=eqp_chance) then scr_add_item(marine_mobi[i],1);
                }
            }
            
            

        }
    }

    for (var i=0;i<array_length(veh_dead);i++){
        if ((veh_dead[i]=1) or (obj_ncombat.defeat!=0)) and (veh_type[i]!="") and (veh_ally[i]=false){
            obj_ncombat.vehicle_deaths+=1;

            var _vehicle_type = veh_type[i];
            if (!struct_exists(obj_ncombat.vehicles_lost_counts, _vehicle_type)) {
                obj_ncombat.vehicles_lost_counts[$ _vehicle_type] = 1;
            } else {
                obj_ncombat.vehicles_lost_counts[$ _vehicle_type]++;
            }

            // Determine which companies to crunch
            obj_ncombat.crunch[veh_co[i]]=1;

        }
    }
}

/// @mixin
function after_battle_part1() {
    var unit;
    var skill_level;
    for (var i=0;i<array_length(unit_struct);i++){
        unit = unit_struct[i];
        if (!is_struct(unit))then continue;
        if (marine_type[i]!="") and (unit.hp()<-3000) and (obj_ncombat.defeat=0){
            marine_dead[i]=0;
            //unit.add_or_sub_health(5000);
        }// For incapitated
        
        if (ally[i]=false){
            if (obj_ncombat.dropping=1) and (obj_ncombat.defeat=1) and (marine_dead[i]<2) then marine_dead[i]=1;
            if (obj_ncombat.dropping=0) and (obj_ncombat.defeat=1) and (marine_dead[i]<2){
                marine_dead[i]=2;
                marine_hp[i]=-50;
            }
            
        
            if (marine_type[i]!="") and (obj_ncombat.defeat=1) and (marine_dead[i]<2){
                marine_dead[i]=1;
                marine_hp[i]=-50;
            }
            if (veh_type[i]!="") and (obj_ncombat.defeat=1){
                veh_dead[i]=1;
                veh_hp[i]=-200;
            }
            
            if (!marine_dead[i]){
                // Apothecaries for saving marines;
                if (unit.IsSpecialist(SPECIALISTS_APOTHECARIES, true)) {
                    skill_level = unit.intelligence * 0.0125;
                    if (marine_gear[i]=="Narthecium"){
                        skill_level*=2;
                        obj_ncombat.apothecaries_alive++;
                    } 
                    skill_level += random(unit.luck*0.05);
                    obj_ncombat.unit_recovery_score += skill_level;
                }

                // Techmarines for saving vehicles;
                if (unit.IsSpecialist(SPECIALISTS_TECHS, true)) {
                    skill_level = unit.technology / 10;
                    if (marine_mobi[i]=="Servo-arm") {
                        skill_level *= 1.5; 
                    } else if (marine_mobi[i]=="Servo-harness") {
                        skill_level *= 2;
                    }
                    skill_level += random(unit.luck / 2);
                    obj_ncombat.vehicle_recovery_score += skill_level;
                    obj_ncombat.techmarines_alive++;
                }
            }
        }
        
    }
}
