/// @self Asset.GMObject.obj_controller
function scr_kill_unit() {
    try {
        if (role() == "Forge Master") {
            array_push(obj_ini.previous_forge_masters, name());
        }

        if (role_compare(self, eROLE.CHAPTERMASTER)) {
            tek = "c";
            alarm[7] = 5;
            global.defeat = 1;
        }

        if (weapon_one() == "Company Standard" || weapon_two() == "Company Standard") {
            scr_loyalty("Lost Standard", "+");
        }
        remove_from_squad();

        // Drop equipped artifacts at the self's location before the slots are wiped.
        var _equipped = equipped_artifacts();
        for (var _e = 0; _e < array_length(_equipped); _e++) {
            var _art = fetch_artifact(_equipped[_e]);
            if (is_struct(_art)) {
                _art.clear_bearer();
            }
        }
        array_delete(obj_ini.TTRPG[company], marine_number, 1);
        var _len = company_length(company);
        for (var i = marine_number; i < _len; i++) {
            obj_ini.TTRPG[company][i].marine_number = i;
        }
        var _is_astartes = base_group == "astartes";
        if (_is_astartes) {
            if (IsSpecialist()) {
                obj_controller.command -= 1;
            } else {
                obj_controller.marines -= 1;
            }
        }
    } catch (ex) {
        LOGGER.error($"company: {company}, unit_slot: {marine_number}");
        ERROR_HANDLER.handle_exception(ex);
    }
}

function scr_wipe_unit(company, unit_slot) {
    array_set(obj_ini.TTRPG[company], unit_slot, undefined);
}

function kill_and_recover(recover_equipment = true, gene_seed_collect = true) {
    if (recover_equipment) {
        var strip = {
            "wep1": "",
            "wep2": "",
            "mobi": "",
            "armour": "",
            "gear": "",
        };
        alter_equipment(strip, false, true);
    }

    var _is_astartes = base_group == "astartes";
    if (gene_seed_collect && _is_astartes) {
        obj_controller.gene_seed += recoverable_geneseed();
    }
    scr_kill_unit();
}
