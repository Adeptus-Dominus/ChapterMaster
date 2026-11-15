try {
    var _player_battle_fleet = noone;
    var _killer = false;
    var _killer_tg = 0;

    if (player_started == 1) {
        _player_battle_fleet = pla_fleet;
    }

    if ((player_started == 0) && instance_exists(obj_turn_end)) {
        _player_battle_fleet = obj_turn_end.battles[obj_turn_end.current_battle].pobject;
    }

    if (instance_number(obj_en_ship) > 0) {
        scr_recent("fleet_defeat", star_name, (capital_lost * 6) + (frigate_lost * 2) + escort_lost);
    }
    if (instance_number(obj_en_ship) <= 0) {
        with (obj_p_ship) {
            if (hp <= 0) {
                scr_recent("ship_destroyed", obj_ini.ship[ship_id], ship_id);
            }
        }
    }

    with (_player_battle_fleet) {
        scr_ini_ship_cleanup();

        if (player_fleet_ship_count() == 0) {
            instance_destroy();
        }
    }

    var _battle_sys = noone;
    if ((player_started == 0) && instance_exists(obj_turn_end)) {
        _battle_sys = obj_turn_end.battles[obj_turn_end.current_battle].object;
    }
    if (player_started == 1) {
        _battle_sys = obj_fleet.ene_fleet;
    }

    // EndTurnBattle hands over one entry per fleet in the battle, enemies first then allies.
    // Loss counters follow that same order.
    var _battle_fleets = array_concat(enemy_fleets, allied_fleets);
    var _fleet_count = array_length(_battle_fleets);

    for (var i = 0; i < _fleet_count; i++) {
        var _fleet_entry = _battle_fleets[i];
        /// @type {Id.Instance.obj_en_fleet}
        var _fleet = _fleet_entry.fleet;

        if (!instance_exists(_fleet)) {
            continue;
        }

        if (_fleet.trade_goods == "player_hold") {
            _fleet.trade_goods = "";
        }

        if (_fleet_entry.owner == eFACTION.INQUISITION) {
            if (_fleet_entry.enemy_status == eENEMY_STATUS.ENEMY) {
                _killer = true;
                _killer_tg = _fleet.inquisitor;
                instance_destroy(_fleet);
            }
            continue;
        }

        var _capital_lost = en_capital_lost[i] ?? 0;
        var _frigate_lost = en_frigate_lost[i] ?? 0;
        var _escort_lost = en_escort_lost[i] ?? 0;

        if (_capital_lost + _frigate_lost + _escort_lost >= _fleet.capital_number + _fleet.frigate_number + _fleet.escort_number) {
            en_capital_lost[i] = _capital_lost - _fleet.capital_number;
            en_frigate_lost[i] = _frigate_lost - _fleet.frigate_number;
            en_escort_lost[i] = _escort_lost - _fleet.escort_number;
            instance_destroy(_fleet);
            continue;
        }

        var _capital_applied = min(_capital_lost, _fleet.capital_number);
        var _frigate_applied = min(_frigate_lost, _fleet.frigate_number);
        var _escort_applied = min(_escort_lost, _fleet.escort_number);

        _fleet.capital_number -= _capital_applied;
        _fleet.frigate_number -= _frigate_applied;
        _fleet.escort_number -= _escort_applied;

        en_capital_lost[i] = _capital_lost - _capital_applied;
        en_frigate_lost[i] = _frigate_lost - _frigate_applied;
        en_escort_lost[i] = _escort_lost - _escort_applied;

        if (_fleet.capital_number + _fleet.frigate_number + _fleet.escort_number <= 0) {
            instance_destroy(_fleet);
        }
    }

    obj_controller.cooldown = 20;

    if (_killer) {
        scr_loyalty("Inquisitor Killer", "+");
        if (obj_controller.loyalty >= 85) {
            obj_controller.last_inquisitor_inspection -= 44;
        }
        if ((obj_controller.loyalty >= 70) && (obj_controller.loyalty < 85)) {
            obj_controller.last_inquisitor_inspection -= 32;
        }
        if ((obj_controller.loyalty >= 50) && (obj_controller.loyalty < 70)) {
            obj_controller.last_inquisitor_inspection -= 20;
        }
        if (obj_controller.loyalty < 50) {
            scr_loyalty("Inquisitor Killer", "+");
        }

        var msg = "";
        var inquis_name = "";
        if (_killer_tg > 0) {
            inquis_name = $"Inquisitor {obj_controller.inquisitor[_killer_tg]}";
            msg += $"{inquis_name} has been killed!";
        }
        if (obj_controller.inquisitor_type[_killer_tg] == "Ordo Hereticus") {
            scr_loyalty("Inquisitor Killer", "+");
        }

        array_delete(obj_controller.inquisitor_gender, _killer_tg, 1);
        array_delete(obj_controller.inquisitor_type, _killer_tg, 1);
        array_delete(obj_controller.inquisitor, _killer_tg, 1);

        //TODO add weighting characteristics to set_gender
        var _gender = set_gender();
        array_push(obj_controller.inquisitor_gender, _gender);

        var _name_set = "imperial_" + string_gender(_gender);

        array_push(obj_controller.inquisitor_type, choose("Ordo Malleus", "Ordo Xenos", "Ordo Hereticus", "Ordo Hereticus", "Ordo Hereticus", "Ordo Hereticus", "Ordo Hereticus", "Ordo Hereticus"));
        array_push(obj_controller.inquisitor, global.name_generator.GenerateFromSet(_name_set));

        instance_activate_object(obj_turn_end);

        if (instance_exists(obj_turn_end)) {
            scr_alert("red", "inqis", string(msg), _battle_sys.x + 16, _battle_sys.y - 24);
        }
        if ((!instance_exists(obj_turn_end)) && (obj_controller.faction_status[eFACTION.INQUISITION] != "War")) {
            var pip = instance_create(0, 0, obj_popup);
            pip.title = "Inquisitor Killed";
            pip.text = msg;
            pip.image = "inquisition";
            pip.cooldown = 20;

            if (obj_controller.known[eFACTION.INQUISITION] < 3) {
                pip.title = "EXCOMMUNICATUS TRAITORUS";
                pip.text = $"The Inquisition has noticed your uncalled murder of {inquis_name} and declared your chapter Excommunicatus Traitorus.";
                obj_controller.alarm[8] = 1;
            }
        }
        // excommunicatus traitorus
    }

    instance_activate_all();

    if (instance_exists(obj_p_assra)) {
        obj_p_assra.alarm[0] = 1;
    }
    alarm[4] = 2;
} catch (_exception) {
    ERROR_HANDLER.handle_exception(_exception);
}
