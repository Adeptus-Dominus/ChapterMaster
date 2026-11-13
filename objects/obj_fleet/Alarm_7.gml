try {
    var _player_battle_fleet = noone;
    var killer = false;
    var killer_tg = 0;

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

    var _battle_sys = noone
    if ((player_started == 0) && instance_exists(obj_turn_end)) {
        _battle_sys = obj_turn_end.battles[obj_turn_end.current_battle].object
    }
    if (player_started == 1) {
        _battle_sys = obj_fleet.ene_fleet
    }


    for (var op = 1; op <= 5; op++) {
        if ((enemy[op] != 0) && (enemy[op] != 4)) {
            var _combat_enemy = enemy[op];

            // Park every fleet not fighting at the battle star offmap so the instance_nearest() loop below only finds participants.
            // Restore after losses are applied.
            with (obj_en_fleet) {
                if ((owner != _combat_enemy) || (orbiting != _battle_sys)) {
                    x -= FLEET_BATTLE_DISPLACEMENT;
                    y -= FLEET_BATTLE_DISPLACEMENT;
                }
            }

            repeat (50) {
                /// @type {Id.Instance.obj_en_fleet}
                var ofleet = instance_nearest(room_width / 2, room_height / 2, obj_en_fleet);
                if (ofleet != noone) {
                    if (ofleet.trade_goods == "player_hold") {
                        ofleet.trade_goods = "";
                    }
                    if (in_room(ofleet) && (ofleet.owner == enemy[op])) {
                        if (en_capital_lost[op] + en_frigate_lost[op] + en_escort_lost[op] >= ofleet.capital_number + ofleet.frigate_number + ofleet.escort_number) {
                            en_capital_lost[op] -= ofleet.capital_number;
                            en_frigate_lost[op] -= ofleet.frigate_number;
                            en_escort_lost[op] -= ofleet.escort_number;
                            with (ofleet) {
                                instance_destroy();
                            }
                        }
                        if ((en_capital_lost[op] + en_frigate_lost[op] + en_escort_lost[op] > 0) && instance_exists(ofleet)) {
                            if ((en_capital_lost[op] > 0) && (ofleet.capital_number > 0)) {
                                en_capital_lost[op] -= 1;
                                ofleet.capital_number -= 1;
                            }
                            if ((en_frigate_lost[op] > 0) && (ofleet.frigate_number > 0)) {
                                en_frigate_lost[op] -= 1;
                                ofleet.frigate_number -= 1;
                            }
                            if ((en_escort_lost[op] > 0) && (ofleet.escort_number > 0)) {
                                en_escort_lost[op] -= 1;
                                ofleet.escort_number -= 1;
                            }
                            if (ofleet.capital_number + ofleet.frigate_number + ofleet.escort_number <= 0) {
                                with (ofleet) {
                                    instance_destroy();
                                }
                            }
                        }
                    }
                }
            }

            with (obj_en_fleet) {
                if (!in_room()) {
                    x += FLEET_BATTLE_DISPLACEMENT;
                    y += FLEET_BATTLE_DISPLACEMENT;
                }
            }
        }

        if ((enemy[op] == 4) && (enemy_status[op] < 0)) {
            _combat_enemy = enemy[op];
            with (obj_en_fleet) {
                if ((owner != _combat_enemy) || (orbiting != _battle_sys)) {
                    x -= FLEET_BATTLE_DISPLACEMENT;
                    y -= FLEET_BATTLE_DISPLACEMENT;
                }
            }
            var ofleet = instance_nearest(room_width / 2, room_height / 2, obj_en_fleet);
            killer = true;
            _combat_enemy = enemy[op];
            killer_tg = ofleet.inquisitor;
            with (ofleet) {
                instance_destroy();
            }
            with (obj_en_fleet) {
                if (!in_room()) {
                    x += FLEET_BATTLE_DISPLACEMENT;
                    y += FLEET_BATTLE_DISPLACEMENT;
                }
            }
        }
    }

    obj_controller.cooldown = 20;

    if (killer) {
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
        if (killer_tg > 0) {
            inquis_name = $"Inquisitor {obj_controller.inquisitor[killer_tg]}";
            msg += $"{inquis_name} has been killed!";
        }
        if (obj_controller.inquisitor_type[killer_tg] == "Ordo Hereticus") {
            scr_loyalty("Inquisitor Killer", "+");
        }

        array_delete(obj_controller.inquisitor_gender, killer_tg, 1);
        array_delete(obj_controller.inquisitor_type, killer_tg, 1);
        array_delete(obj_controller.inquisitor, killer_tg, 1);

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
