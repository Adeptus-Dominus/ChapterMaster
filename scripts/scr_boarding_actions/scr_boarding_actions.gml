function create_boarding_craft(target_ship) {
    board_cooldown = 45;

    var _boarding_craft = instance_create(x, y, obj_p_assra);
    _boarding_craft.apothecary = 0;

    for (var o = 0; o < array_length(board_marine); o++) {
        boarders--;
        _boarding_craft.boarders++;
        var unit = board_marine[o];
        if (!is_struct(unit)) {
            continue;
        }
        if (unit.IsSpecialist(SPECIALISTS_APOTHECARIES)) {
            if ((unit.gear() == "Narthecium") && (unit.hp() >= 10)) {
                _boarding_craft.apothecary += 1;
            }
        }
        array_push(_boarding_craft.occupants, unit);
        if (_boarding_craft.boarders >= 20) {
            break;
        }
    }

    array_delete(board_marine, 0, _boarding_craft.boarders);
    _boarding_craft.apothecary_had = _boarding_craft.apothecary;

    _boarding_craft.target = target_ship;
    _boarding_craft.direction = direction;
    _boarding_craft.origin = self.id;
    _boarding_craft.speed = 4;

    if (boarders <= 0) {
        obj_cursor.board = 0;
    }
}

function destroy_boarding_craft() {
    for (var o = 0; o < array_length(occupants); o++) {
        var _unit = occupants[o];
        if (!is_struct(_unit)) {
            continue;
        }
        var _recover_gene = obj_fleet.capital + obj_fleet.frigate + obj_fleet.escort > 0;
        if (_unit.hp() <= -15 && _unit.base_group == "astartes") {
            if (apothecary > 0) {
                _unit.add_or_sub_health(irandom_range(9, 14));
                apothecary -= 0.5;
            } else {
                _unit.kill(false, _recover_gene);
            }
        }
    }
}
