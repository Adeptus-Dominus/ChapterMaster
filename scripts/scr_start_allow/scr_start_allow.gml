function scr_start_allow(role_id, equip_area, equipment) {
	var _allow = false;
	var _veteran_level = 0;

	if (role_id == eROLE.Dreadnought) {
		equip_area[101, role_id] = equipment;
		return;
	}

	if (array_contains([eROLE.Sergeant, eROLE.Veteran, eROLE.Terminator], role_id)) {
		_veteran_level = 1;
	} else if (array_contains([eROLE.VeteranSergeant, eROLE.Ancient, eROLE.Captain, eROLE.HonourGuard], role_id)) {
		_veteran_level = 2;
	} else if (array_contains([eROLE.Chaplain, eROLE.Apothecary, eROLE.Librarian, eROLE.Techmarine], role_id)) {
		_veteran_level = 5;
	}

	var _normal_equipment = ["Combat Knife", "Chainsword", "Chainaxe", "Boarding Shield", "Bolt Pistol", "Bolter", "Flamer", "Sniper Rifle"];
	_allow = array_contains(_normal_equipment, equipment);

	if (_veteran_level > 0) {
		var _special_equipment = ["Storm Bolter", "Meltagun", "Power Fist", "Power Sword", "Power Axe"];
		_allow = array_contains(_special_equipment, equipment);
	}

	if (equip_area == "mobi") {
		if (equipment == "Jump Pack" && (_veteran_level > 0 || role_id == eROLE.Assault)) {
			if (!array_contains([eROLE.Terminator, eROLE.Dreadnought], role_id)) {
				_allow = true;
			}
		} else if (equipment == "Bike" && (_veteran_level > 0 || role_id == eROLE.Assault)) {
			if (!array_contains([eROLE.Terminator, eROLE.Dreadnought], role_id)) {
				_allow = true;
			}
		} else if (equipment == "Heavy Weapons Pack" && role_id == eROLE.Devastator) {
			_allow = true;
		}
	}

	if (equip_area == "gear") {
		if (_veteran_level == 5) {
			if (role_id == eROLE.Chaplain && equipment == "Rosarius") {
				_allow = true;
			} else if (role_id == eROLE.Techmarine) {
				if (array_contains(["Servo-arm", "Servo-harness"], equipment)) {
					_allow = true;
				}
			} else if (role_id == eROLE.Librarian && equipment == "Psychic Hood") {
				_allow = true;
			} else if (role_id == eROLE.Apothecary && equipment == "Narthecium") {
				_allow = true;
			}
		}
	}

	if (_allow) {
		equip_area[101, role_id] = equipment;
	}
	return;
}