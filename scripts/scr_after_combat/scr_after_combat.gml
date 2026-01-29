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
                    case obj_ini.role[100][eROLE.ChapterMaster]:
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

function distribute_experience(_units, _total_exp) {
    var _unit_count = array_length(_units);
    var _exp_reward = 0;
    var _exp_reward_max = 5;
    var _unit_exp_ceiling = 200;
    var _exp_mod_min = 0.1;

    if (_unit_count > 0 && _total_exp > 0) {
        _exp_reward = min(_total_exp / _unit_count, _exp_reward_max);
        for (var i = 0; i < _unit_count; i++) {
            var _unit = _units[i];
            var _exp_mod = max(1 - (_unit.experience / _unit_exp_ceiling), _exp_mod_min);
            var _exp_update_data = _unit.add_exp(_exp_reward * _exp_mod);

            var _powers_learned = _exp_update_data[1];
            if (_powers_learned > 0) {
                array_push(obj_ncombat.upgraded_librarians, _unit);
            }

        }
    }

    return _exp_reward;
}

function after_battle_slime_and_equipment_maintenance(unit){
    if (unit.base_group=="astartes"){
        if (unit.gene_seed_mutations.mucranoid==1) {
            var muck=roll_dice_unit(1,100,"high",unit);
            if (muck==1){    //slime  armour damaged due to mucranoid
                if (unit.armour != ""){
                    obj_controller.specialist_point_handler.add_to_armoury_repair(unit.armour());
                    obj_ncombat.mucra[unit.company]=1;
                    obj_ncombat.slime+=unit.get_armour_data("maintenance");
                }
            }
        }
    }
}

function check_for_plasma_bomb_and_tomb(unit){
    if (obj_ncombat.plasma_bomb || obj_ncombat.defeat){
        return;
    }
    var _star = obj_ncombat.battle_object;
    var _planet = obj_ncombat.battle_id;
    var _necron_strength = _star.p_necrons[_planet];
    if (unit.gear() == "Plasma Bomb" && !string_count("mech_tomb2",obj_ncombat.battle_special)){
        if (obj_ncombat.enemy == eFACTION.Necrons && awake_tomb_world(_star.p_feature[_planet])){
            if (((_necron_strength-2)<3 && dropping) || (_necron_strength-1)<3){
                obj_ncombat.plasma_bomb+=1;
                unit.update_gear("",false,false);
            }
        }
    }
}
/// @mixin
function after_battle_part2() {
    var _unit;

    for (var i=0;i<array_length(unit_struct);i++){
        _unit=unit_struct[i];
        if (!marine_dead[i] && marine_type[i]=="Death Company"){
            if (_unit.role()!="Death Company"){
                _unit.update_role("Death Company");
            }
        }

        if (!marine_dead[i] && !ally[i]){
            after_battle_slime_and_equipment_maintenance(_unit);

            check_for_plasma_bomb_and_tomb(_unit)


            if (_unit.gear()="Exterminatus") and (obj_ncombat.dropping!=0) and (obj_ncombat.defeat=0){
                if (obj_ncombat.exterminatus=0){
                    obj_ncombat.exterminatus+=1;
                    _unit.update_gear("", false,false);
                }
                // obj_ncombat.exterminatus+=1;scr_add_item("Exterminatus",1);
                // _unit.gear()="";
            }
        }


        var destroy=0;
        if ((marine_dead[i] || obj_ncombat.defeat!=0) && !ally[i]){
            after_combat_recover_marine_gene_seed(_unit);
            after_combat_dead_marine_equipment_recovered(_unit);
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
					skill_level += random(unit.luck / 2);
					skill_level += unit.gear_special_value("combi_tool");
                    obj_ncombat.vehicle_recovery_score += round(skill_level);
                    obj_ncombat.techmarines_alive++;
                }
            }
        }
        
    }
}

function after_combat_recover_marine_gene_seed(unit){
   var comm=false;
    if (unit.IsSpecialist(SPECIALISTS_STANDARD,true)){
        obj_ncombat.final_command_deaths+=1;
        var recent=true;
        if (is_specialist(unit.role, SPECIALISTS_TRAINEES)){
            recent=false
        } else if (array_contains([string("Venerable {0}",obj_ini.role[100][6]), "Codiciery", "Lexicanum"], unit.role())){
            recent=false
        }
        if (recent=true) then scr_recent($"death_{unit.name_role()}");           
    } else {
        obj_ncombat.final_marine_deaths+=1;
    }
    // obj_ncombat.final_marine_deaths+=1;

    // show_message("ded; increase final deaths");

    if (obj_controller.blood_debt=1){
        if (unit.role()==obj_ini.role[100][eROLE.Scout]){
            obj_controller.penitent_current+=2
        } else {obj_controller.penitent_current+=4;}
        obj_controller.penitent_turn=0;
        obj_controller.penitent_turnly=0;
    }

    if (unit.base_group == "astartes") {
        var _birthday = unit.age();
        var _current_year = (obj_controller.millenium * 1000) + obj_controller.year;
        var _seed_harvestable = 0;
        var _seed_lost = 0;

        if (_birthday <= (_current_year - 10) && unit.gene_seed_mutations.zygote == 0) {
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

    var _unit_role = unit.role();
    if (!struct_exists(obj_ncombat.units_lost_counts, _unit_role)) {
        obj_ncombat.units_lost_counts[$ _unit_role] = 1;
    } else {
        obj_ncombat.units_lost_counts[$ _unit_role]++;
    }

    // Determine which companies to crunch
    obj_ncombat.crunch[unit.company]=1;
}

function after_combat_dead_marine_equipment_recovered(unit){
    var _equipment = unit.unit_equipment_data();

    var _equip_slots = struct_get_names(_equipment);

    var basic_recover_chance = 40;

    if (scr_has_adv("Scavangers")){
        basic_recover_chance += 10;
    }
    if (!obj_ncombat.defending){
        basic_recover_chance-=10;
    }
    if (obj_ncombat.dropping=1){
        if (scr_has_adv("Lightning Warriors")){
            basic_recover_chance-=10;
        } else {
            basic_recover_chance-=25;
        }
        
    }

    for (var i=0; i<array_length(_equip_slots);i++){

        var _recover = true;
        var _slot = _equip_slots[i];
        var _item = _equipment[$ _slot];

        if (!is_struct(_item)){
            continue;
        }

        var _specific_item_chance = roll_dice_chapter(1, 100, "low");

        if (obj_ncombat.dropping && obj_ncombat.defeat){
            _specific_item_chance=9999;
        }
        //if (obj_ini.race[marine_co[i], marine_id[i]]!=1) then _specific_item_chance=9999;

        var _specific_type_recovery = basic_recover_chance + _item.recovery_chance;

        if (_item.is_artifact && _specific_type_recovery < 90){
            _specific_type_recovery = 95;
        }

        if (_item.name="Exterminatus"){
            if (obj_ncombat.defeat=0){
                _specific_item_chance=0;
                if (obj_ncombat.dropping!=0){
                    obj_ncombat.exterminatus+=1;
                }
            }
            if (obj_ncombat.defeat){
                _specific_item_chance=9999;
            }
        }

        if (_specific_item_chance > _specific_type_recovery){
            _recover = false;
            if (!_item.is_artifact){
                obj_ncombat.post_equipment_lost.add_item(_item.name, _item.quality, unit.uid);
            }
        } else {
            if (!_item.is_artifact){
                obj_ncombat.post_equipment_recovered.add_item(_item.name, _item.quality, unit.uid);
            }           
        }

        switch(_slot){
            case "armour_data":
                unit.update_armour("", false,_recover);
            case "weapon_one_data":
                unit.weapon_one("", false,_recover);
            case "weapon_two_data":
                unit.update_weapon_two("", false,_recover);
            case "gear_data":
                unit.update_gear("", false,_recover);
            case "mobility_item_data":
                unit.update_mobility_item("", false,_recover);
        }
    }
}
