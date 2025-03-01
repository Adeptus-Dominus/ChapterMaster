function scr_powers_new() {
	// company: Company
	// marine_number: Marine ID

	// This script checks if the marine is capable of using psychic powers, and if so, assigns them based on experience
    // 'This script checks if the marine is capable of using psychic powers', why the fuck is bro lying

    if (!IsSpecialist("libs")) {
        return 0;
    }

	var random_learn;
	random_learn = false;

	var letmax, powers_should_have, powers_have;
	var power_code = "";
	letmax = 0;
	var _powers_learned = 0;

	var discipline_names = struct_get_names(global.disciplines_data);
	for (var i = 0; i < array_length(discipline_names); i++) {
		var discipline_name = discipline_names[i];
		if (discipline_name == obj_ini.psy_powers) {
			var discipline_struct = global.disciplines_data[$ discipline_name];
			power_code = discipline_struct[$ "letter"];
			letmax = array_length(discipline_struct[$ "powers"]);
		}
	}

	// higer psionice means more powers learnt
	powers_should_have = floor((experience - 30) / (45 - psionic)) + 1; // +1 for the primary
	powers_have = string_count(string(power_code), specials());

	if ((powers_have < powers_should_have) && (powers_have < letmax) && (random_learn == true)) {
		var newpow;
		newpow = 0;
		if ((powers_have < powers_should_have) && (powers_have < letmax)) {
			if ((powers_have < powers_should_have) && (powers_have < letmax)) {
				var tha = floor(random(letmax));
				if (string_count(string(tha), specials()) == 0) {
					powers_have += 1;
					_powers_learned++;
					obj_ini.spe[company, marine_number] += string(power_code) + string(tha) + "|";
				}
			}
		}
	} else if ((powers_have < powers_should_have) && (powers_have < letmax) && (random_learn == false)) {
		// Used to work like this.  I removed it because I was too lazy to have powers chance to be cast be based on experience.
		// Should you wish to have powers be randomly learned simply change random_learn to true and write the rest of the code.

		var newpow = 0;
		var reps = 0;
		while (powers_have < powers_should_have && reps < letmax) {
			reps++;
			var tha = powers_have;
			if (string_count(string(tha), specials()) == 0) {
				powers_have++;
				_powers_learned++;
				obj_ini.spe[company, marine_number] += string(power_code) + string(tha) + "|";
			}
		}
	}

	return _powers_learned;
}
