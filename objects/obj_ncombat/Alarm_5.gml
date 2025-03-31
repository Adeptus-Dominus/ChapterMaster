
// Final Screen
var part1="",part2="",part3="",part4="",part9="";
var part5="",part6="",part7="",part8="",part10="";
battle_over=1;

alarm[8]=999999;
var line_break = "------------------------------------------------------------------------------";
// show_message("Final Deaths: "+string(final_marine_deaths));


if (turn_count >= 50){
    part1 = "Your forces make a fighting retreat \n"
}
// check for wounded marines here to finish off, if defeated defending
var roles = obj_ini.role[100];
var ground_mission = (instance_exists(obj_ground_mission));

with (obj_pnunit) {
    after_battle_part1();
}

if (obj_ncombat.defeat == 0) {
    marines_to_recover = ds_priority_create();
    vehicles_to_recover = ds_priority_create();

    with (obj_pnunit) {
        add_marines_to_recovery();
        add_vehicles_to_recovery();
    }

    while (!ds_priority_empty(marines_to_recover)) {
        var _candidate = ds_priority_delete_max(marines_to_recover);
        var _column_id = _candidate.column_id;
        var _unit_id = _candidate.id;
        var _unit = _candidate.unit;
        var _unit_role = _unit.role();
        var _constitution_test_mod = _unit.hp() * -1;
        var _constitution_test = global.character_tester.standard_test(_unit, "constitution", _constitution_test_mod);

        if (unit_recovery_score > 0) {
            _unit.update_health(_constitution_test[1]);
            _column_id.marine_dead[_unit_id] = false;
            unit_recovery_score--;
            units_saved_count++;

            if (!struct_exists(obj_ncombat.units_saved_counts, _unit_role)) {
                obj_ncombat.units_saved_counts[$ _unit_role] = 1;
            } else {
                obj_ncombat.units_saved_counts[$ _unit_role]++;
            }
            continue;
        }

        if (_unit.base_group == "astartes") {
            if (!_unit.gene_seed_mutations[$ "membrane"]) {
                var survival_mod = _unit.luck * -1;
                survival_mod += _unit.hp() * -1;
    
                var survival_test = global.character_tester.standard_test(_unit, "constitution", survival_mod);
                if (survival_test[0]) {
                    _column_id.marine_dead[_unit_id] = false;
                    injured++;
                }
            }
        }
    }
    ds_priority_destroy(marines_to_recover);

    while (!ds_priority_empty(vehicles_to_recover)) {
        var _candidate = ds_priority_delete_max(vehicles_to_recover);
        var _column_id = _candidate.column_id;
        var _vehicle_id = _candidate.id;
        var _vehicle_type = _column_id.veh_type[_vehicle_id];
    
        if (obj_controller.stc_bonus[3] = 4) {
            var _survival_roll = 70 + _candidate.priority;
            var _dice_roll = roll_dice(1, 100, "high");
            if (_dice_roll >= _survival_roll) && (_column_id.veh_dead[_vehicle_id] != 2) {
                _column_id.veh_hp[_vehicle_id] = roll_dice(1, 10, "high");
                _column_id.veh_dead[_vehicle_id] = false;
                vehicles_saved_count++;

                if (!struct_exists(obj_ncombat.vehicles_saved_counts, _vehicle_type)) {
                    obj_ncombat.vehicles_saved_counts[$ _vehicle_type] = 1;
                } else {
                    obj_ncombat.vehicles_saved_counts[$ _vehicle_type]++;
                }
                continue;
            }
        }
    
        if (vehicle_recovery_score > 0) {
            _column_id.veh_hp[_vehicle_id] = roll_dice(1, 10, "high");
            _column_id.veh_dead[_vehicle_id] = false;
            vehicle_recovery_score -= _candidate.priority;
            vehicles_saved_count++;

            if (!struct_exists(obj_ncombat.vehicles_saved_counts, _vehicle_type)) {
                obj_ncombat.vehicles_saved_counts[$ _vehicle_type] = 1;
            } else {
                obj_ncombat.vehicles_saved_counts[$ _vehicle_type]++;
            }
        }
    }
    ds_priority_destroy(vehicles_to_recover);
}


with (obj_pnunit) {
    after_battle_part2();
}

var _total_deaths = final_marine_deaths + final_command_deaths;
var _total_injured = _total_deaths + injured + units_saved_count;
if (_total_injured > 0) {
    newline = $"{string_plural_count("unit", _total_injured)} {smart_verb("was", _total_injured)} critically injured.";
    newline_color = "red";
	scr_newtext();

    if (units_saved_count > 0) {
        var _units_saved_string = "";
        var _unit_roles = struct_get_names(units_saved_counts);

        for (var i = 0; i < array_length(_unit_roles); i++) {
            var _unit_role = _unit_roles[i];
            var _saved_count = units_saved_counts[$ _unit_role];
            _units_saved_string += $"{string_plural_count(_unit_role, _saved_count)}";
            _units_saved_string += smart_delimeter_sign(_unit_roles, i, false);
        }

        newline = $"{units_saved_count}x {smart_verb("was", units_saved_count)} saved by the {string_plural(roles[eROLE.Apothecary], apothecaries_alive)}. ({_units_saved_string})";
        scr_newtext();
    }

    if (injured > 0) {
        newline = $"{injured}x survived thanks to the Sus-an Membrane.";
        newline_color = "red";
        scr_newtext();
    }

    if (_total_deaths > 0) {
        var _units_lost_string = "";
        var _unit_roles = struct_get_names(units_lost_counts);
        for (var i = 0; i < array_length(_unit_roles); i++) {
            var _unit_role = _unit_roles[i];
            var _lost_count = units_lost_counts[$ _unit_role];
            _units_lost_string += $"{string_plural_count(_unit_role, _lost_count)}";
            _units_lost_string += smart_delimeter_sign(_unit_roles, i, false);
        }
        newline += $"{_total_deaths} units succumbed to their wounds! ({_units_lost_string})";
        newline_color="red";
        scr_newtext();

    }

    newline = " ";
    scr_newtext();
}


if (ground_mission){
	if (apothecaries_alive < 0){
		obj_ground_mission.apothecary_present = apothecaries_alive;
	}
};

if (seed_lost > 0) {
    if (obj_ini.doomed) {
        newline = $"Chapter mutation prevents retrieving gene-seed. {seed_lost} gene-seed lost.";
        scr_newtext();
    } else if (!apothecaries_alive) {
        newline = $"No able-bodied {roles[eROLE.Apothecary]}. {seed_lost} gene-seed lost.";
        scr_newtext();
    } else {
        seed_saved = min(seed_harvestable, apothecaries_alive * 40);
        newline = $"{seed_saved} gene-seed was recovered; {seed_lost - seed_harvestable} was lost due damage; {seed_harvestable - seed_saved} was left to rot;";
        scr_newtext();
    }

    if (seed_saved > 0) {
        obj_controller.gene_seed += seed_saved;
    }

    newline = " ";
    scr_newtext();
}

if (red_thirst>2){
    var voodoo="";

    if (red_thirst=3) then voodoo="1 Battle Brother lost to the Red Thirst.";
    if (red_thirst>3) then voodoo=string(red_thirst-2)+" Battle Brothers lost to the Red Thirst.";
    
    newline=voodoo;newline_color="red";
    scr_newtext();
    newline=" ";
    scr_newtext();
}

newline = " ";
scr_newtext();


var _total_damaged_count = vehicle_deaths + vehicles_saved_count;
if (_total_damaged_count > 0) {
	newline = $"{string_plural_count("vehicle", _total_damaged_count)} {smart_verb("was", _total_damaged_count)} critically damaged during battle.";
    newline_color="red";
    scr_newtext();

    if (vehicles_saved_count > 0) {
        var _vehicles_saved_string = "";
        var _vehicle_types = struct_get_names(vehicles_saved_counts);

        for (var i = 0; i < array_length(_vehicle_types); i++) {
            var _vehicle_type = _vehicle_types[i];
            var _saved_count = vehicles_saved_counts[$ _vehicle_type];
            _vehicles_saved_string += $"{string_plural_count(_vehicle_type, _saved_count)}";
            _vehicles_saved_string += smart_delimeter_sign(_vehicle_types, i, false);
        }

        newline = $"{string_plural(roles[eROLE.Techmarine], techmarines_alive)} {smart_verb("was", techmarines_alive)} able to restore {vehicles_saved_count}. ({_vehicles_saved_string})";
        scr_newtext();
    }

    if (vehicle_deaths > 0) {
        var _vehicles_lost_string = "";
        var _vehicle_types = struct_get_names(vehicles_lost_counts);

        for (var i = 0; i < array_length(_vehicle_types); i++) {
            var _vehicle_type = _vehicle_types[i];
            var _lost_count = vehicles_lost_counts[$ _vehicle_type];
            _vehicles_lost_string += $"{string_plural_count(_vehicle_type, _lost_count)}";
            _vehicles_lost_string += smart_delimeter_sign(_vehicle_types, i, false);
        }

        newline += $"{vehicle_deaths} {smart_verb("was", vehicle_deaths)} lost forever. ({_vehicles_lost_string})";
        newline_color="red";
        scr_newtext();
    }

    newline = " ";
    scr_newtext();
}



if (post_equipment_lost[1]!=""){
    part6="Equipment Lost: ";
    
    part7 += arrays_to_string_with_counts(post_equipment_lost, post_equipments_lost, true, false);
	if (ground_mission){
        part7 += " Some may be recoverable."
    }
    newline=part6;
    scr_newtext();
    newline=part7;
    scr_newtext();
    newline=" ";
    scr_newtext();
}



if (total_battle_exp_gain>0){
    with (obj_pnunit) {
        assemble_alive_units();
    }
    average_battle_exp_gain = distribute_experience(end_alive_units, total_battle_exp_gain); // Due to cool alarm timer shitshow, I couldn't think of anything but to put it here.
    newline = $"Each marine gained {average_battle_exp_gain} experience, reduced by their total experience.";
    scr_newtext();

    var _upgraded_librarians_count = array_length(upgraded_librarians);
    if (_upgraded_librarians_count > 0) {
        for (var i = 0; i < _upgraded_librarians_count; i++) {
            if (i > 0) {
                newline += ", ";
            }
            newline += $"{upgraded_librarians[i].name_role()}";
        }
        newline += " learned new psychic powers after gaining enough experience."
        scr_newtext();
    }

    newline=" ";
    scr_newtext();
}

if (ground_mission){
	obj_ground_mission.post_equipment_lost = post_equipment_lost
	obj_ground_mission.post_equipments_lost = post_equipments_lost
}

if (slime>0){
    var slime_string=$"Faulty Mucranoid and other afflictions have caused damage to the equipment. {slime} Forge Points will be allocated for repairs.";    
    newline=slime_string;
    newline_color="red";
    scr_newtext();

    newline=" ";
    scr_newtext();
}

instance_activate_object(obj_star);


var reduce_fortification=true;
if (battle_special="tyranid_org") then reduce_fortification=false;
if (string_count("_attack",battle_special)>0) then reduce_fortification=false;
if (battle_special="ship_demon") then reduce_fortification=false;
if (enemy+threat=17) then reduce_fortification=false;
if (battle_special="ruins") then reduce_fortification=false;
if (battle_special="ruins_eldar") then reduce_fortification=false;
if (battle_special="fallen1") then reduce_fortification=false;
if (battle_special="fallen2") then reduce_fortification=false;
if (battle_special="study2a") then reduce_fortification=false;
if (battle_special="study2b") then reduce_fortification=false;

if (fortified>0) and (!instance_exists(obj_nfort)) and (reduce_fortification=true){
    part9="Fortification level of "+string(battle_loc);
    if (battle_id=1) then part9+=" I";
    if (battle_id=2) then part9+=" II";
    if (battle_id=3) then part9+=" III";
    if (battle_id=4) then part9+=" IV";
    if (battle_id=5) then part9+=" V";
    part9+=$" has decreased to {fortified-1} ({fortified}-1)";
    newline=part9;
    scr_newtext();
    battle_object.p_fortified[battle_id]-=1;
}


/*if (enemy=5){
    if (obj_controller.faction_status[eFACTION.Ecclesiarchy]!="War"){
        
    }
}*/





if (defeat=0) and (battle_special="space_hulk"){
    var enemy_power=0,loot=0,dicey=floor(random(100))+1,ex=0;

    if (enemy=7){
        enemy_power=battle_object.p_orks[battle_id];
        battle_object.p_orks[battle_id]-=1;
    }
    else if (enemy=9){
        enemy_power=battle_object.p_tyranids[battle_id];
        battle_object.p_tyranids[battle_id]-=1;
    }
    else if (enemy=10){
        enemy_power=battle_object.p_traitors[battle_id];
        battle_object.p_traitors[battle_id]-=1;
    }

    part10="Space Hulk Exploration at ";
    ex=min(100,100-((enemy_power-1)*20));
    part10+=string(ex)+"%";
    newline=part10;
    if (ex=100) then newline_color="red";
    scr_newtext();

    if (scr_has_disadv("Shitty Luck")) then dicey=dicey*1.5;
    // show_message("Roll Under: "+string(enemy_power*10)+", Roll: "+string(dicey));

    if (dicey<=(enemy_power*10)){
        loot=choose(1,2,3,4);
        if (enemy!=10) then loot=choose(1,1,2,3);
        hulk_treasure=loot;
        if (loot>1) then newline="Valuable items recovered.";
        if (loot=1) then newline="Resources have been recovered.";
        newline_color="yellow";
        scr_newtext();
    }
}


if (string_count("ruins",battle_special)>0){
    if (defeat=0) then newline="Ancient Ruins cleared.";
    if (defeat=1) then newline="Failed to clear Ancient Ruins.";
    newline_color="yellow";
    scr_newtext();
}

var reduce_power=true;
if (battle_special="tyranid_org") then reduce_power=false;
if (battle_special="ship_demon") then reduce_power=false;
if (string_count("_attack",battle_special)>0) then reduce_power=false;
if (string_count("ruins",battle_special)>0) then reduce_power=false;
if (battle_special="space_hulk") then reduce_power=false;
if (battle_special="fallen1") then reduce_power=false;
if (battle_special="fallen2") then reduce_power=false;
if (battle_special="study2a") then reduce_power=false;
if (battle_special="study2b") then reduce_power=false;
if (defeat=0) and (reduce_power=true){
    var enemy_power,new_power, power_reduction, final_pow, requisition_reward;
    enemy_power=0;new_power=0; power_reduction=0; requisition_reward=0;

    if (enemy=2){
        enemy_power=battle_object.p_guardsmen[battle_id];
        battle_object.p_guardsmen[battle_id]-=threat;
        // if (threat=1) or (threat=2) then battle_object.p_guardsmen[battle_id]=0;
    }

    if (enemy=5){
        enemy_power=battle_object.p_sisters[battle_id];
        part10="Ecclesiarchy";
    }
    else if (enemy=6){
        enemy_power=battle_object.p_eldar[battle_id];
        part10="Eldar";
    }
    else if (enemy=7){
        enemy_power=battle_object.p_orks[battle_id];
        part10="Ork";
    }
    else if (enemy=8){
        enemy_power=battle_object.p_tau[battle_id];
        part10="Tau";
    }
    else if (enemy=9){
        enemy_power=battle_object.p_tyranids[battle_id];
        part10="Tyranid";
    }
    else if (enemy=10){
        enemy_power=battle_object.p_traitors[battle_id];
        part10="Heretic";if (threat=7) then part10="Daemon";
    }
    else if (enemy=11){
        enemy_power=battle_object.p_chaos[battle_id];
        part10="Chaos Space Marine";}
    else if (enemy=13){
        enemy_power=battle_object.p_necrons[battle_id];
        part10="Necrons";
    }

    if (instance_exists(battle_object)) and (enemy_power>2){
        if (awake_tomb_world(battle_object.p_feature[battle_id])!=0){
            scr_gov_disp(battle_object.name,battle_id,floor(enemy_power/2));
        }
    }

	
    if (enemy!=2){
        if (dropping == true || defending == true) {
            power_reduction = 1;
        } else {
            power_reduction = 2;
        }
        new_power = enemy_power - power_reduction;
        new_power = max(new_power, 0);

        // Give some money for killing enemies?
        var _quad_factor = 6;
        requisition_reward = _quad_factor * sqr(threat);
        obj_controller.requisition += requisition_reward;

		//(¿?) Ramps up threat/enemy presence in case enemy Type == "Daemon" (¿?)
		//Does the inverse check/var assignment 10 lines above
        if (part10="Daemon") then new_power=7;
        if (enemy=9) and (new_power==0){
            var battle_planet = battle_id;
            with (battle_object){
                var who_cleansed="Tyranids";
                var who_return="";
                var make_alert = true;
                var planet_string = $"{name} {scr_roman(battle_planet)}";
                if (planet_feature_bool(p_feature[battle_planet], P_features.Gene_Stealer_Cult)==1){
                    who_cleansed="Gene Stealer Cult"
                    make_alert=true;
                    delete_features(p_feature[battle_planet], P_features.Gene_Stealer_Cult);
                    adjust_influence(eFACTION.Tyranids, -25, battle_planet);
                } 
                if (make_alert){
                     if (p_first[battle_planet] == 1){
                        who_return = "your";
                        p_owner[battle_planet] = eFACTION.Player;
                     } else if (p_first[battle_planet] == 3 || p_type[battle_planet]=="Forge"){
                        who_return="mechanicus";
                        obj_controller.disposition[3] += 10;
                        p_owner[battle_planet] = eFACTION.Mechanicus
                     }else  if (p_type[battle_planet]!="Dead"){
                        who_return="the governor";
                        if (who_cleansed=="tau"){
                            who_return="a more suitable governer"
                        }
                         p_owner[battle_planet] = eFACTION.Imperium
                     }              
                    dispo[battle_planet] += 10;
                    scr_event_log("", $"{who_cleansed} cleansed from {planet_string}", name);
                    scr_alert("green", "owner", $"{who_cleansed} cleansed from {planet_string}. Control returned to {who_return}", x, y);
                    if (dispo[battle_planet] >= 101) then p_owner[battle_planet] = 1;
                }                               
            }
        }
        if (enemy=11) and (enemy_power!=floor(enemy_power)) then enemy_power=floor(enemy_power);
    }


    if ((obj_controller.blood_debt=1) and (defeat=0) && enemy_power>0){
        final_pow = min(enemy_power, 6)-1;
        if (enemy=6) or (enemy=9) or (enemy=11) or (enemy=13){
            obj_controller.penitent_turn=0;
            obj_controller.penitent_turnly=0;
            var penitent_crusade_chart = [25,62,95,190,375,750];

            final_pow = min(enemy_power, 6)-1;
            obj_controller.penitent_current+=penitent_crusade_chart[final_pow];

        }
        else if (enemy=7) or (enemy=8) or (enemy=10){
            obj_controller.penitent_turn=0;
            obj_controller.penitent_turnly=0;
            final_pow = min(enemy_power, 7)-1;
            var penitent_crusade_chart = [25,50,75,150,300,600, 1500];         
             obj_controller.penitent_current+=penitent_crusade_chart[final_pow];
        }
    }

    if (enemy=5){battle_object.p_sisters[battle_id]=new_power;}
    else if (enemy=6){battle_object.p_eldar[battle_id]=new_power;}
    else if (enemy=7){battle_object.p_orks[battle_id]=new_power;}
    else if (enemy=8){battle_object.p_tau[battle_id]=new_power;}
    else if (enemy=9){battle_object.p_tyranids[battle_id]=new_power;}
    else if (enemy=10){battle_object.p_traitors[battle_id]=new_power;}
    else if (enemy=11){battle_object.p_chaos[battle_id]=new_power;}
    else if (enemy=13){battle_object.p_necrons[battle_id]=new_power;}

    if (enemy!=2) and (string_count("cs_meeting_battle",battle_special)=0){
        part10+=" forces on "+string(battle_loc);
        if (battle_id=1) then part10+=" I";
        if (battle_id=2) then part10+=" II";
        if (battle_id=3) then part10+=" III";
        if (battle_id=4) then part10+=" IV";
        if (battle_id=5) then part10+=" V";
        if (new_power == 0){
            part10+=$" were completely wiped out. Previous power: {
                enemy_power}. Reduction: {power_reduction}.";
        } else {
            part10+=$" were reduced to {new_power} after this battle. Previous power: {
                enemy_power}. Reduction: {power_reduction}.";
        }
        newline=part10;
        scr_newtext();
        part10 = $"Received {requisition_reward} requisition points as a reward for slaying enemies of the Imperium.";
        newline=part10;
        scr_newtext();
    
        if (new_power<=0) and (enemy_power>0) then battle_object.p_raided[battle_id]=1;
    }
    if (enemy=2){
        part10+=" Imperial Guard Forces on "+string(battle_loc);
        if (battle_id=1) then part10+=" I";
        if (battle_id=2) then part10+=" II";
        if (battle_id=3) then part10+=" III";
        if (battle_id=4) then part10+=" IV";
        if (battle_id=5) then part10+=" V";
        part10+=" were reduced to "+string(battle_object.p_guardsmen[battle_id])+" ("+string(enemy_power)+"-"+string(threat)+")";
        newline=part10;scr_newtext();
    }



    if (enemy=8) and (ethereal>0) and (defeat=0){
        newline="Tau Ethereal Captured";
        newline_color="yellow";
        scr_newtext();
    }
    
    if (enemy=13) and (battle_object.p_necrons[battle_id]<3) and (awake_tomb_world(battle_object.p_feature[battle_id])== 1){
    
        // var bombs;bombs=scr_check_equip("Plasma Bomb",battle_loc,battle_id,0);
        // var bombs;bombs=scr_check_equip("Plasma Bomb","","",0);

        // show_message(string(bombs));

        if (plasma_bomb>0){
            // scr_check_equip("Plasma Bomb",battle_loc,battle_id,1);
            // scr_check_equip("Plasma Bomb","","",1);
            newline="Plasma Bomb used to seal the Necron Tomb.";
            newline_color="yellow";
            scr_newtext();
			seal_tomb_world(battle_object.p_feature[battle_id])
        }

        if (plasma_bomb<=0){
            battle_object.p_necrons[battle_id]=3;// newline_color="yellow";
            if (dropping!=0) then newline="Deep Strike Ineffective; Plasma Bomb required";
            if (dropping=0) then newline="Attack Ineffective; Plasma Bomb required";
            scr_newtext();
        }

        // popup here
        /*
        var pip;
        pip=instance_create(0,0,obj_popup);
        pip.title="Necron Tombs";
        pip.text="The Necrons have been defeated on the surface, but remain able to replenish their numbers and recuperate.  Do you wish to advance your army into the tunnels?";
        pip.image="necron_tunnels_1";
        pip.cooldown=15;
        cooldown=15;

        pip.option1="Advance!";
        pip.option2="Cancel the attack";*/




    }





    /*if (enemy=13) and (new_power<=0) and (dropping=0){
        var bombs;bombs=scr_check_equip("Plasma Bomb",battle_loc,battle_id,0);
        if (bombs>0){
            scr_check_equip("Plasma Bomb",battle_loc,battle_id,1);
            newline="Plasma Bomb used to seal the Necron Tomb.";newline_color="yellow";scr_newtext();
            if (battle_object.p_feature[battle_id]="Awakened Necron Tomb") then battle_object.p_feature[battle_id]="Necron Tomb";
        }
    }*/
}

if (defeat=0) and (enemy=9) and (battle_special="tyranid_org"){
    // show_message(string(captured_gaunt));
    if (captured_gaunt=1) then newline=captured_gaunt+" Gaunt organism have been captured.";
    if (captured_gaunt>1) or (captured_gaunt=0) then newline=captured_gaunt+" Gaunt organisms have been captured.";
    scr_newtext();

    if (captured_gaunt>0){
        var why,thatta;why=0;thatta=0;
        instance_activate_object(obj_star);
        // with(obj_star){if (name!=obj_ncombat.battle_loc) then instance_deactivate_object(id);}
        // thatta=obj_star;

        with(obj_star){
            remove_star_problem("tyranid_org");
        }
    }

    scr_event_log("","Inquisition Mission Completed: A Gaunt organism has been captured for the Inquisition.");

    if (captured_gaunt>1){
        if (instance_exists(obj_turn_end)) then scr_popup("Inquisition Mission Completed","You have captured several Gaunt organisms.  The Inquisitor is pleased with your work, though she notes that only one is needed- the rest are to be purged.  It will be stored until it may be retrieved.  The mission is a success.","inquisition","");
    }
    if (captured_gaunt=1){
        if (instance_exists(obj_turn_end)) then scr_popup("Inquisition Mission Completed","You have captured a Gaunt organism- the Inquisitor is pleased with your work.  The Tyranid will be stored until it may be retrieved.  The mission is a success.","inquisition","");
    }
    instance_deactivate_object(obj_star);
}


newline=line_break;
scr_newtext();
newline=line_break;
scr_newtext();

if (((leader)) or ((battle_special="world_eaters") and (!obj_controller.faction_defeated[10]))) and (!defeat){
    var nep;nep=false;
    newline="The enemy Leader has been killed!";newline_color="yellow";scr_newtext();
    newline=line_break;
    scr_newtext();
    newline=line_break;
    scr_newtext();
    instance_activate_object(obj_event_log);
    if (enemy=5) then scr_event_log("","Enemy Leader Assassinated: Ecclesiarchy Prioress");
    if (enemy=6) then scr_event_log("","Enemy Leader Assassinated: Eldar Farseer");
    if (enemy=7){
		scr_event_log("","Enemy Leader Assassinated: Ork Warboss");
		if (Warlord !=0){
            with (Warlord){
                kill_warboss();
            }
        }
	}
    if (enemy=8) then scr_event_log("","Enemy Leader Assassinated: Tau Diplomat");
    if (enemy=10) then scr_event_log("","Enemy Leader Assassinated: Chaos Lord");
}

var endline,inq_eated;endline=1;
inq_eated=false;


if (obj_ini.omophagea){
    var eatme=floor(random(100))+1;
    if (enemy=13) or (enemy=9) or (battle_special="ship_demon") then eatme+=100;
    if (enemy=10) and (battle_object.p_traitors[battle_id]=7) then eatme+=200;

    if (red_thirst=3) then thirsty=1;if (red_thirst>3) then thirsty=red_thirst-2;
    if (thirsty>0) then eatme-=(thirsty*6);if (really_thirsty>0) then eatme-=(really_thirsty*15);
    if (scr_has_disadv("Shitty Luck")) then eatme-=10;

    if (allies>0){
        obj_controller.disposition[2]-=choose(1,0,0);
        obj_controller.disposition[4]-=choose(0,0,1);
        obj_controller.disposition[5]-=choose(0,0,1);
    }
    if (present_inquisitor>0) then obj_controller.disposition[4]-=2;

    if (eatme<=25){endline=0;
        if (thirsty=0) and (really_thirsty=0){
            var ran;ran=choose(1,2);
            newline="One of your marines slowly makes his way towards the fallen enemies, as if in a spell.  Once close enough the helmet is removed and he begins shoveling parts of their carcasses into his mouth.";
            newline="Two marines are sharing a quick discussion, and analysis of the battle, when one of the two suddenly drops down and begins shoveling parts of enemy corpses into his mouth.";
            newline+=choose("  Bone snaps and pops.","  Strange-colored blood squirts from between his teeth.","  Veins and tendons squish wetly.");
        }
        if (thirsty>0) and (really_thirsty=0){
            var ran=choose(1,2);
            newline="One of your Death Company marines slowly makes his way towards the fallen enemies, as if in a spell.  Once close enough the helmet is removed and he begins shoveling parts of their carcasses into his mouth.";
            newline="A marine is observing and communicating with a Death Company marine, to ensure they are responsive, when that Death Company marine drops down and suddenly begins shoveling parts of enemy corpses into his mouth.";
            newline+=choose("  Bone snaps and pops.","  Strange-colored blood squirts from between his teeth.","  Veins and tendons squish wetly.");
        }
        if (really_thirsty>0){
            newline=$"One of your Death Company {roles[6]} blitzes to the fallen enemy lines.  Massive mechanical hands begin to rend and smash at the fallen corpses, trying to squeeze their flesh and blood through the sarcophogi opening.";
        }

        newline+="  Almost at once most of the present "+string(global.chapter_name)+" follow suite, joining in and starting a massive feeding frenzy.  The sight is gruesome to behold.";
        scr_newtext();


        // check for pdf/guardsmen
        eatme=floor(random(100))+1;
        if (scr_has_disadv("Shitty Luck")) then eatme-=10;
        if (eatme<=10) and (allies>0){
            obj_controller.disposition[2]-=2;
            if (allies=1){
                newline="Local PDF have been eaten!";
                newline_color="red";scr_newtext();
            }
            else if (allies=2){
                newline="Local Guardsmen have been eaten!";
                newline_color="red";
                scr_newtext();
            }
        }

        // check for inquisitor
        eatme=floor(random(100))+1;
        if (scr_has_disadv("Shitty Luck")) then eatme-=5;
        if (eatme<=40) and (present_inquisitor=1){
            var thatta=0,remove=0,i=0;
            obj_controller.disposition[4]-=10;
            inq_eated=true;
            instance_activate_object(obj_en_fleet);

            if (instance_exists(inquisitor_ship)){
                repeat(2){
                    scr_loyalty("Inquisitor Killer","+");
                }
                if (obj_controller.loyalty>=85) then obj_controller.last_world_inspection-=44;
                if (obj_controller.loyalty>=70) and (obj_controller.loyalty<85) then obj_controller.last_world_inspection-=32;
                if (obj_controller.loyalty>=50) and (obj_controller.loyalty<70) then obj_controller.last_world_inspection-=20;
                if (obj_controller.loyalty<50) then scr_loyalty("Inquisitor Killer","+");

                var msg="",msg2="",i=0,remove=0;
                // if (string_count("Inqis",inquisitor_ship.trade_goods)>0) then show_message("B");
                if (inquisitor_ship.inquisitor>0){
                    var inquis_name = obj_controller.inquisitor[inquisitor_ship.inquisitor];
                    newline=$"Inquisitor {inquis_name} has been eaten!";
                    msg=$"Inquisitor {inquis_name}"
                    remove=obj_controller.inquisitor[inquisitor_ship.inquisitor];
                    scr_event_log("red",$"Your Astartes consume {msg}.");
                }
                newline_color="red";
                scr_newtext();
                if (obj_controller.inquisitor_type[remove]="Ordo Hereticus") then scr_loyalty("Inquisitor Killer","+");

                i=remove;
                repeat(10-remove){
                    if (i<10){
                        obj_controller.inquisitor_gender[i]=obj_controller.inquisitor_gender[i+1];
                        obj_controller.inquisitor_type[i]=obj_controller.inquisitor_type[i+1];
                        obj_controller.inquisitor[i]=obj_controller.inquisitor[i+1];
                    }
                    if (i=10){
                        obj_controller.inquisitor_gender[i]=choose(0,0,0,1,1,1,1); // 4:3 chance of male Inquisitor
                        obj_controller.inquisitor_type[i]=choose("Ordo Malleus","Ordo Xenos","Ordo Hereticus","Ordo Hereticus","Ordo Hereticus","Ordo Hereticus","Ordo Hereticus","Ordo Hereticus");
                        obj_controller.inquisitor[i]=global.name_generator.generate_imperial_name(obj_controller.inquisitor_gender[i]);// For 'random inquisitor wishes to inspect your fleet
                    }
                    i+=1;
                }

                instance_activate_object(obj_turn_end);
                if (obj_controller.known[eFACTION.Inquisition]<3){
                    scr_event_log("red","EXCOMMUNICATUS TRAITORUS");  
                    obj_controller.alarm[8]=1;   
                    if ((!instance_exists(obj_turn_end))){
                        var pip=instance_create(0,0,obj_popup);
                        pip.title="Inquisitor Killed";
                        pip.text=msg;
                        pip.image="inquisition";
                        pip.cooldown=30;
                        pip.title="EXCOMMUNICATUS TRAITORUS";
                        pip.text=$"The Inquisition has noticed your uncalled CONSUMPTION of {msg} and declared your chapter Excommunicatus Traitorus.";
                        instance_deactivate_object(obj_popup);
                    } else {
                        scr_popup("Inquisitor Killed",$"The Inquisition has noticed your uncalled CONSUMPTION of {msg} and declared your chapter Excommunicatus Traitorus.","inquisition","");                   
                    }
                }
                instance_deactivate_object(obj_turn_end);

                with(inquisitor_ship){instance_destroy();}
                with(obj_ground_mission){instance_destroy();}
            }
            instance_deactivate_object(obj_star);
            instance_deactivate_object(obj_en_fleet);
        }
    }
}

if (inq_eated=false) and (obj_ncombat.sorcery_seen>=2){
    scr_loyalty("Use of Sorcery","+");
    newline="Inquisitor "+string(obj_controller.inquisitor[1])+" witnessed your Chapter using sorcery.";
    scr_event_log("green",string(newline));
    scr_newtext();
}

if (exterminatus>0) and (dropping!=0){
    newline="Exterminatus has been succesfully placed.";
    newline_color="yellow";
    endline=0;
    scr_newtext();
}

instance_activate_object(obj_star);
instance_activate_object(obj_turn_end);

//If not fleet based and...
if (obj_ini.fleet_type != ePlayerBase.home_world) and (defeat==1) and (dropping==0){
	var monastery_list = search_planet_features(battle_object.p_feature[obj_ncombat.battle_id], P_features.Monastery);
	var monastery_count = array_length(monastery_list);
	if(monastery_count>0){
		for (var mon = 0;mon < monastery_count;mon++){
			battle_object.p_feature[obj_ncombat.battle_id][monastery_list[mon]].status="destroyed";
		}

	    if (obj_controller.und_gene_vaults=0) then newline="Your Fortress Monastery has been raided.  "+string(obj_controller.gene_seed)+" Gene-Seed has been destroyed or stolen.";
	    if (obj_controller.und_gene_vaults>0) then newline="Your Fortress Monastery has been raided.  "+string(floor(obj_controller.gene_seed/10))+" Gene-Seed has been destroyed or stolen.";

	    scr_event_log("red",newline, battle_object.name);
	    instance_activate_object(obj_event_log);
	    newline_color="red";scr_newtext();

	    var lasers_lost,defenses_lost,silos_lost;
	    lasers_lost=0;defenses_lost=0;silos_lost=0;

	    if (player_defenses>0){
            defenses_lost=round(player_defenses*0.75);
        }
	    if (battle_object.p_silo[obj_ncombat.battle_id]>0){
            silos_lost=round(battle_object.p_silo[obj_ncombat.battle_id]*0.75);
        }
	    if (battle_object.p_lasers[obj_ncombat.battle_id]>0){
            lasers_lost=round(battle_object.p_lasers[obj_ncombat.battle_id]*0.75);
        }

	    if (player_defenses<30) then defenses_lost=player_defenses;
	    if (battle_object.p_silo[obj_ncombat.battle_id]<30){
            silos_lost=battle_object.p_silo[obj_ncombat.battle_id];
        }
	    if (battle_object.p_lasers[obj_ncombat.battle_id]<8){
            lasers_lost=battle_object.p_lasers[obj_ncombat.battle_id];
        }

	    var percent;percent=0;newline="";
	    if (defenses_lost>0){
	        percent=round((defenses_lost/player_defenses)*100);
	        newline=string(defenses_lost)+" Weapon Emplacements have been lost ("+string(percent)+"%).";
	    }
	    if (silos_lost>0){
	        percent=round((silos_lost/battle_object.p_silo[obj_ncombat.battle_id])*100);
	        if (defenses_lost>0) then newline+="  ";
	        newline+=string(silos_lost)+$" Missile Silos have been lost ({percent}%).";
	    }
	    if (lasers_lost>0){
	        percent=round((lasers_lost/battle_object.p_lasers[obj_ncombat.battle_id])*100);
	        if (silos_lost>0) or (defenses_lost>0) then newline+="  ";
	        newline+=string(lasers_lost)+" Defense Lasers have been lost ("+string(percent)+"%).";
	    }

	    battle_object.p_defenses[obj_ncombat.battle_id]-=defenses_lost;
	    battle_object.p_silo[obj_ncombat.battle_id]-=silos_lost;
	    battle_object.p_lasers[obj_ncombat.battle_id]-=lasers_lost;
	    if (defenses_lost+silos_lost+lasers_lost>0){newline_color="red";scr_newtext();}

	    endline=0;

	    if (obj_controller.und_gene_vaults=0){
            //all Gene Pod Incubators and gene seed are lost
	        destroy_all_gene_slaves(false);
	    }
	    if (obj_controller.und_gene_vaults>0) then obj_controller.gene_seed-=floor(obj_controller.gene_seed/10);
	}
}
instance_deactivate_object(obj_star);
instance_deactivate_object(obj_turn_end);

if (endline=0){
    newline=line_break;
    scr_newtext();
    newline=line_break;
    scr_newtext();
}


if (defeat=1){
	player_forces=0;
	if (ground_mission){
		obj_ground_mission.recoverable_gene_seed = seed_lost;
	}
	
}

gene_slaves = [];

instance_deactivate_object(obj_star);
instance_deactivate_object(obj_ground_mission);

show_debug_message($"{started}");
/* */
/*  */
