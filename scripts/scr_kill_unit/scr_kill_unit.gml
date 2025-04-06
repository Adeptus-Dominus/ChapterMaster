// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_kill_unit(company, unit_slot) {
    var _unit;
    if (is_string(company)) {
        _unit = fetch_unit(company);
        company = _unit.company;
        unit_slot = _unit.marine_number;
    } else {
        _unit = fetch_unit([company, unit_slot]);
    }

    if (obj_ini.role[company][unit_slot]=="Forge Master") {
        array_push(obj_ini.previous_forge_masters, obj_ini.name[company][unit_slot]);
    }

    if (obj_ini.role[company][unit_slot] == obj_ini.role[100][eROLE.ChapterMaster]) {
        tek = "c";
        alarm[7] = 5;
        global.defeat = 1;
    }
    if (_unit.weapon_one() == "Company Standard" || _unit.weapon_two() == "Company Standard") {
        scr_loyalty("Lost Standard", "+");
    }
    _unit.remove_from_squad();
    scr_uuid_delete_unit(_unit.UUID);
    scr_wipe_unit(company, unit_slot);
}

function scr_wipe_unit(company, unit_slot) {
    obj_ini.spe[company][unit_slot] = "";
    obj_ini.race[company][unit_slot] = 0;
    obj_ini.loc[company][unit_slot] = "";
    obj_ini.name[company][unit_slot] = "";
    obj_ini.wep1[company][unit_slot] = "";
    obj_ini.role[company][unit_slot] = "";
    obj_ini.wep2[company][unit_slot] = "";
    obj_ini.armour[company][unit_slot] = "";
    obj_ini.gear[company][unit_slot] = "";
    obj_ini.god[company][unit_slot] = 0;
    obj_ini.age[company][unit_slot] = 0;
    obj_ini.mobi[company][unit_slot] = "";
    obj_ini.bio[company][unit_slot] = "";
    obj_ini.TTRPG[company][unit_slot] = new TTRPG_stats("chapter", company, unit_slot, "blank"); // create new empty unit structure
}

function kill_and_recover(company, unit_slot, equipment=true, gene_seed_collect=true){
    var _unit;
    if (is_string(company)) {
        _unit = fetch_unit(company);
        company = _unit.company;
        unit_slot = _unit.marine_number;
    } else {
        _unit = fetch_unit([company, unit_slot]);
    }

    if (equipment) {
        var strip = {
            "wep1" : "",
            "wep2" : "",
            "mobi" : "",
            "armour" : "",
            "gear" : ""
        };

        _unit.alter_equipment(strip, false, true);
    }
    if (gene_seed_collect && _unit.base_group == "astartes") {
        if (_unit.age() > 30 && !obj_ini.zygote && !obj_ini.doomed) { obj_controller.gene_seed += 1; }
        if (_unit.age() > 50 && !obj_ini.doomed) { obj_controller.gene_seed += 1; }
    }
    if (obj_ini.race[company][unit_slot] == 1) {
        if(is_specialist(obj_ini.role[company][unit_slot])) {
            obj_controller.command -= 1;
        } else {
            obj_controller.marines -= 1;
        }
    }
    scr_kill_unit(company, unit_slot);
}
