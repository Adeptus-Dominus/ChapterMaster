function scr_powers_new() {
	// company: Company
	// marine_number: Marine ID

	// This script checks if the marine is capable of using psychic powers, and if so, assigns them based on experience
    // 'This script checks if the marine is capable of using psychic powers', why the fuck is bro lying

    if (!IsSpecialist("libs")) {
        return 0;
    }

	var _powers_can_have;
	var _powers_have;
	var _powers_letter = "";
	var _powers_max = 0;
	var _powers_learned = 0;
	var _powers_string = specials();

	var discipline_names = struct_get_names(global.disciplines_data);
	for (var i = 0; i < array_length(discipline_names); i++) {
		var discipline_name = discipline_names[i];
		if (discipline_name == obj_ini.psy_powers) {
			var discipline_struct = global.disciplines_data[$ discipline_name];
			_powers_letter = discipline_struct[$ "letter"];
			_powers_max = array_length(discipline_struct[$ "powers"]);
		}
	}

	// higher psionic and exp means more powers learnt
	_powers_can_have = floor((experience - 30) / (45 - psionic)) + 1; // +1 for the primary
	_powers_have = string_count(string(_powers_letter), _powers_string);

	while ((_powers_have < _powers_can_have) && (_powers_have < _powers_max)) {
		var _power_index = _powers_have;
		if (string_count(string(_power_index), _powers_string) == 0) {
			_powers_have++;
			_powers_learned++;
			obj_ini.spe[company, marine_number] += string(_powers_letter) + string(_power_index) + "|";
		}
	}

	return _powers_learned;
}
