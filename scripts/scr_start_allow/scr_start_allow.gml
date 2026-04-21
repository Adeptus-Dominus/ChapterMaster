function scr_start_allow(role_id, equip_area, equipment) {
    var _allow = false;
    var _veteran_level = 0;

    if (role_id == eROLE.DREADNOUGHT) {
        equip_area[101][role_id] = equipment;
        return;
    }

    if (array_contains([eROLE.SERGEANT, eROLE.VETERAN, eROLE.TERMINATOR], role_id)) {
        _veteran_level = 1;
    } else if (array_contains([eROLE.VETERANSERGEANT, eROLE.ANCIENT, eROLE.CAPTAIN, eROLE.HONOURGUARD], role_id)) {
        _veteran_level = 2;
    } else if (array_contains([eROLE.CHAPLAIN, eROLE.APOTHECARY, eROLE.LIBRARIAN, eROLE.TECHMARINE], role_id)) {
        _veteran_level = 5;
    }

    var _normal_equipment = [
        "Combat Knife",
        "Chainsword",
        "Chainaxe",
        "Boarding Shield",
        "Bolt Pistol",
        "Bolter",
        "Flamer",
        "Sniper Rifle"
    ];
    _allow = array_contains(_normal_equipment, equipment);

    if (_veteran_level > 0) {
        var _special_equipment = [
            "Storm Bolter",
            "Meltagun",
            "Power Fist",
            "Power Sword",
            "Power Axe"
        ];
        _allow = array_contains(_special_equipment, equipment);
    }

    if (equip_area == "mobi") {
        if (equipment == "Jump Pack" && (_veteran_level > 0 || role_id == eROLE.ASSAULT)) {
            if (!array_contains([eROLE.TERMINATOR, eROLE.DREADNOUGHT], role_id)) {
                _allow = true;
            }
        } else if (equipment == "Bike" && (_veteran_level > 0 || role_id == eROLE.ASSAULT)) {
            if (!array_contains([eROLE.TERMINATOR, eROLE.DREADNOUGHT], role_id)) {
                _allow = true;
            }
        } else if (equipment == "Heavy Weapons Pack" && role_id == eROLE.DEVASTATOR) {
            _allow = true;
        }
    }

    if (equip_area == "gear") {
        if (_veteran_level == 5) {
            if (role_id == eROLE.CHAPLAIN && equipment == "Rosarius") {
                _allow = true;
            } else if (role_id == eROLE.TECHMARINE) {
                if (array_contains(["Servo-arm", "Servo-harness"], equipment)) {
                    _allow = true;
                }
            } else if (role_id == eROLE.LIBRARIAN && equipment == "Psychic Hood") {
                _allow = true;
            } else if (role_id == eROLE.APOTHECARY && equipment == "Narthecium") {
                _allow = true;
            }
        }
    }

    if (_allow) {
        equip_area[101][role_id] = equipment;
    }
    return;
}
