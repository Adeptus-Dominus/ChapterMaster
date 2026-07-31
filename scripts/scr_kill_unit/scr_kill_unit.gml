/// @self Asset.GMObject.obj_controller
function scr_kill_unit(company, unit_slot) {
    try {
        if (obj_ini.role[company][unit_slot] == "Forge Master") {
            array_push(obj_ini.previous_forge_masters, obj_ini.name[company][unit_slot]);
        }

        if (obj_ini.role[company][unit_slot] == obj_ini.role[100][eROLE.CHAPTERMASTER]) {
            tek = "c";
            alarm[7] = 5;
            global.defeat = 1;
        }

        var _unit = fetch_unit([company, unit_slot]);

        if (is_struct(_unit)) {
            if (_unit.weapon_one() == "Company Standard" || _unit.weapon_two() == "Company Standard") {
                scr_loyalty("Lost Standard", "+");
            }
            _unit.remove_from_squad();

            // Drop equipped artifacts at the unit's location before the slots are wiped.
            var _equipped = _unit.equipped_artifacts();
            for (var _e = 0; _e < array_length(_equipped); _e++) {
                var _art = fetch_artifact(_equipped[_e]);
                if (is_struct(_art)) {
                    _art.clear_bearer();
                }
            }
        }

        scr_wipe_unit(company, unit_slot);
    } catch (ex) {
        LOGGER.error($"company: {company}, unit_slot: {unit_slot}");
        ERROR_HANDLER.handle_exception(ex);
    }
}

function scr_wipe_unit(company, unit_slot) {
    array_set(obj_ini.race[company], unit_slot, 0);
    array_set(obj_ini.name[company], unit_slot, "");
    array_set(obj_ini.wep1[company], unit_slot, "");
    array_set(obj_ini.wep2[company], unit_slot, "");
    array_set(obj_ini.role[company], unit_slot, "");
    array_set(obj_ini.armour[company], unit_slot, "");
    array_set(obj_ini.gear[company], unit_slot, "");
    array_set(obj_ini.mobi[company], unit_slot, "");
    array_set(obj_ini.TTRPG[company], unit_slot, undefined);
}

function kill_and_recover(company, unit_slot, equipment = true, gene_seed_collect = true) {
    var unit = obj_ini.TTRPG[company][unit_slot];
    if (equipment) {
        var strip = {
            "wep1": "",
            "wep2": "",
            "mobi": "",
            "armour": "",
            "gear": "",
        };
        unit.alter_equipment(strip, false, true);
    }
    if (gene_seed_collect && unit.base_group == "astartes") {

        if (unit.marine_ascension > 30 && !obj_ini.zygote && !obj_ini.doomed) {
            obj_controller.gene_seed += 1;
        }
        if (unit.marine_ascension > 100 && !obj_ini.doomed) {
            obj_controller.gene_seed += 1;
        }
    }
    if (obj_ini.race[company][unit_slot] == 1) {
        if (is_specialist(obj_ini.role[company][unit_slot])) {
            obj_controller.command -= 1;
        } else {
            obj_controller.marines -= 1;
        }
    }
    scr_kill_unit(company, unit_slot);
}
