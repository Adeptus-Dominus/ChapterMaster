/// @desc Ensure every parallel per-company marine array (and TTRPG) for this company is
/// long enough to index this slot, appending the blank defaults find_company_open_slot
/// uses. Companies are uncapped, so a marine can occupy a slot beyond the legacy 501-length
/// arrays (for example a save where name[] grew past the flat arrays). Padding each array
/// independently up to the slot keeps them in sync so reads and writes at that slot never
/// go out of range. Each array is padded on its own length, so an array that already
/// reaches the slot is left untouched while a shorter sibling is caught up.
function ensure_marine_slot(_company, _slot) {
    while (array_length(obj_ini.race[_company]) <= _slot) {
        array_push(obj_ini.race[_company], 1);
    }
    while (array_length(obj_ini.name[_company]) <= _slot) {
        array_push(obj_ini.name[_company], "");
    }
    while (array_length(obj_ini.role[_company]) <= _slot) {
        array_push(obj_ini.role[_company], "");
    }
    while (array_length(obj_ini.wep1[_company]) <= _slot) {
        array_push(obj_ini.wep1[_company], "");
    }
    while (array_length(obj_ini.spe[_company]) <= _slot) {
        array_push(obj_ini.spe[_company], "");
    }
    while (array_length(obj_ini.wep2[_company]) <= _slot) {
        array_push(obj_ini.wep2[_company], "");
    }
    while (array_length(obj_ini.armour[_company]) <= _slot) {
        array_push(obj_ini.armour[_company], "");
    }
    while (array_length(obj_ini.gear[_company]) <= _slot) {
        array_push(obj_ini.gear[_company], "");
    }
    while (array_length(obj_ini.mobi[_company]) <= _slot) {
        array_push(obj_ini.mobi[_company], "");
    }
    while (array_length(obj_ini.age[_company]) <= _slot) {
        array_push(obj_ini.age[_company], 0);
    }
    while (array_length(obj_ini.god[_company]) <= _slot) {
        array_push(obj_ini.god[_company], 0);
    }
    while (array_length(obj_ini.TTRPG[_company]) <= _slot) {
        array_push(obj_ini.TTRPG[_company], new TTRPG_stats("chapter", _company, array_length(obj_ini.TTRPG[_company]), "blank"));
    }
}

function scr_move_unit_info(start_company, end_company, start_slot, end_slot, eval_squad = true) {
    //eval_squad : determine whether movement of units between companies should decide to check their squad coherency or not, defaults to true

    // Companies are uncapped, so either slot can sit beyond the legacy 501-length parallel
    // arrays. Pad every array for both companies up to the slots in use so the copies below
    // never read or write out of range (the crash when a company exceeded 500 marines).
    ensure_marine_slot(start_company, start_slot);
    ensure_marine_slot(end_company, end_slot);

    //this makes sure coherency of the unit's squad and the squads logging of the unit location are kept up to date
    var unit = obj_ini.TTRPG[start_company][start_slot];
    if (eval_squad) {
        unit.movement_after_math(end_company, end_slot);
    }
    obj_ini.spe[end_company][end_slot] = obj_ini.spe[start_company][start_slot];
    obj_ini.race[end_company][end_slot] = obj_ini.race[start_company][start_slot];
    obj_ini.name[end_company][end_slot] = obj_ini.name[start_company][start_slot];
    obj_ini.wep1[end_company][end_slot] = obj_ini.wep1[start_company][start_slot];
    obj_ini.role[end_company][end_slot] = obj_ini.role[start_company][start_slot];
    obj_ini.wep2[end_company][end_slot] = obj_ini.wep2[start_company][start_slot];
    obj_ini.gear[end_company][end_slot] = obj_ini.gear[start_company][start_slot];
    obj_ini.armour[end_company][end_slot] = obj_ini.armour[start_company][start_slot];
    obj_ini.god[end_company][end_slot] = obj_ini.god[start_company][start_slot];
    obj_ini.age[end_company][end_slot] = obj_ini.age[start_company][start_slot];
    obj_ini.mobi[end_company][end_slot] = obj_ini.mobi[start_company][start_slot];

    var _temp_struct = obj_ini.TTRPG[end_company][end_slot];

    obj_ini.TTRPG[end_company][end_slot] = obj_ini.TTRPG[start_company][start_slot];

    obj_ini.TTRPG[start_company][start_slot] = _temp_struct;
    _temp_struct.company = start_company;
    _temp_struct.marine_number = start_slot;

    _temp_struct = fetch_unit([end_company, end_slot]);
    if (is_struct(_temp_struct)) {
        _temp_struct.company = end_company;
        _temp_struct.marine_number = end_slot;
    } else {
        obj_ini.TTRPG[end_company][end_slot] = new TTRPG_stats("chapter", end_company, end_slot, "blank");
    }

    scr_wipe_unit(start_company, start_slot);
}
