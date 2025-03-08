/// @mixin
function scr_powers_new() {
	// company: Company
	// marine_number: Marine ID

	// This script checks if the marine is capable of using psychic powers, and if so, assigns them based on experience
    // 'This script checks if the marine is capable of using psychic powers', why the fuck is bro lying

    if (!IsSpecialist("libs")) {
        return 0;
    }

	var _powers_limit = 0;
	var _powers_known = [];
	var _powers_known_count = 0;
	var _powers_letter = "";
	var _discipline_powers_max = 0;
	var _powers_learned = 0;
	var _abilities_string = specials();


	var _discipline_letter = get_discipline_data(obj_ini.psy_powers, "letter");
	var _discipline_powers = get_discipline_data(obj_ini.psy_powers, "powers");
	_discipline_powers_max = array_length(_discipline_powers);

	// higher exp means more powers learnt
	_powers_limit = floor(experience / 20) + 1; // +1 for the primary
	_powers_known_count = string_count(string(_discipline_letter), _abilities_string);

	while ((_powers_known_count < _powers_limit) && (_powers_known_count < _discipline_powers_max)) {
		var _power_index = _powers_known_count;
		if (string_count(string(_power_index), _abilities_string) == 0) {
			_powers_known_count++;
			_powers_learned++;
			obj_ini.spe[company, marine_number] += string(_discipline_letter) + string(_power_index) + "|";
		}
	}

	// Update the known powers array;
	_powers_known = self.psy_powers_array();
	self.powers_known = _powers_known;

	return _powers_learned;
}
