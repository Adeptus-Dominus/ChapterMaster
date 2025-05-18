function NameGenerator() constructor {
	// TODO after save rework is finished, check if these static can be converted to instance versions
	static LoadSimpleNames = function(file_name, fallback_value, json_names_property_name = "names") {
		if (json_names_property_name == noone) {
			json_names_property_name = "names";
		}

		var file_loader = new JsonFileListLoader();

		var load_result = file_loader.load_list_from_json_file($"main\\names\\{file_name}.json", [json_names_property_name]);

		if (load_result.is_success) {
			return load_result.values[$ json_names_property_name];
		}

		return [fallback_value];
	};

	static LoadCompositeNames = function(file_name, json_names_property_names = ["prefixes", "suffixes", "special"]) {
		if (json_names_property_names == noone) {
			json_names_property_names = ["prefixes", "suffixes", "special"];
		}

		var file_loader = new JsonFileListLoader();

		var load_result = file_loader.load_list_from_json_file($"main\\names\\{file_name}.json", json_names_property_names);

		var result = {};

		for (var i = 0; i < array_length(json_names_property_names); i++) {
			if (load_result.is_success) {
				result[$ json_names_property_names[i]] = load_result.values[$ json_names_property_names[i]];
			} else {
				result[$ json_names_property_names[i]] = array_create(1, $"{json_names_property_names[i]} 1");
			}
		}

		return result;
	};

	// vars // TODO put these into a struct or dict or something
	sector_names = LoadSimpleNames("sector", "Sector 1");
	sector_used_names = [];

	star_names = LoadSimpleNames("star", "Star 1");
	star_used_names = [];
	star_names_generic_counter = 0; // TODO once we migrate Star data to proper structs and jsons, this can probably be removed

	space_marines_names = LoadSimpleNames("space_marine", "Space Marine 1");
	space_marines_used_names = [];

	imperial_names = LoadSimpleNames("imperial", "Imperial 1");
	imperial_used_names = [];

	chaos_names = LoadSimpleNames("chaos", "Chaos 1");
	chaos_used_names = [];

	eldar_syllables = LoadCompositeNames("eldar", ["first_syllables", "second_syllables", "third_syllables"]);

	ork_name_composites = LoadCompositeNames("ork", ["prefixes", "suffixes", "special"]);

	imperial_ship_names = LoadSimpleNames("imperial_ship", "Imperial Ship 1");
	imperial_ship_used_names = [];

	ork_ship_names = LoadSimpleNames("ork_ship", "Ork Ship 1");
	ork_ship_used_names = [];

	hulk_name_composites = LoadCompositeNames("hulk", ["prefixes", "suffixes"]);

	tau_name_composites = LoadCompositeNames("tau", ["prefixes", "suffixes"]);

	genestealer_cult_names = LoadCompositeNames("genestealercult", ["main", "embelishment", "title"]);

	// init

	static SimpleNameGeneration = function(names, used_names, entity_name, reset_on_using_up_all_names = true) {
		try {
			if (array_length(names) == 0) {
				var used_names_length = array_length(used_names);
				if (reset_on_using_up_all_names) {
					log_message($"Used up all {entity_name} names, resetting name lists");
					// TODO the 2 lines below could be simplified by swapping references, instead of copying and deleting
					array_copy(names, 0, used_names, 0, used_names_length);
					array_delete(used_names, 0, used_names_length);
				} else {
					log_error($"Used up all {entity_name} names. Generating a generic name. used_names_length = {used_names_length}; star_names_generic_counter = {star_names_generic_counter}.");
					star_names_generic_counter++;
					return $"{entity_name} {used_names_length + star_names_generic_counter}";
				}
			}

			var name = array_pop(names);
			array_push(used_names, name);
			return name;
		} catch (_exception) {
			handle_exception(_exception);
			return "name_error";
		}
	};

	static MultiSyllableNameGeneration = function(syllables, syllable_amount) {
		try {
			var random_first_syllable_list = syllables.first_syllables[irandom(array_length(syllables.first_syllables) - 1)];
			var name = random_first_syllable_list[irandom(array_length(random_first_syllable_list) - 1)];

			if (syllable_amount >= 2) {
				var random_second_syllable_list = syllables.second_syllables[irandom(array_length(syllables.second_syllables) - 1)];
				name += random_second_syllable_list[irandom(array_length(random_second_syllable_list) - 1)];
			}

			if (syllable_amount >= 3) {
				var random_third_syllable_list = syllables.third_syllables[irandom(array_length(syllables.third_syllables) - 1)];
				name += array_random_element(random_third_syllable_list);
			}

			return name;
		} catch (_exception) {
			handle_exception(_exception);
			return "name_error";
		}
	};

	static ComplexTitledName = function(mains, embelishments, titles) {
		try {
			var require_embelishments = choose(true, false);
			var require_titles = choose(true, false);
			var name = array_random_element(array_random_element(mains));
			if (require_embelishments) {
				name += " " + array_random_element(array_random_element(embelishments));
			}
			if (require_titles) {
				name += " " + array_random_element(array_random_element(titles));
			}
			return name;
		} catch (_exception) {
			handle_exception(_exception);
			return "name_error";
		}
	};

	static CompositeNameGeneration = function(composite_names, separate_components) {
		try {
			if (struct_exists(composite_names, "special") && is_array(composite_names.special) && array_length(composite_names.special) > 0) {
				var use_special_name = irandom(200);
				if (use_special_name == 0) {
					return composite_names.special[irandom(array_length(composite_names.special) - 1)];
				}
			}

			var random_composite_one_list = composite_names.prefixes[irandom(array_length(composite_names.prefixes) - 1)];
			var random_composite_two_list = composite_names.suffixes[irandom(array_length(composite_names.suffixes) - 1)];
			var composite_one = random_composite_one_list[irandom(array_length(random_composite_one_list) - 1)];
			var composite_two = random_composite_two_list[irandom(array_length(random_composite_two_list) - 1)];

			var separator = "";

			if (separate_components) {
				separator = " ";
			}

			return $"{composite_one}{separator}{composite_two}";
		} catch (_exception) {
			handle_exception(_exception);
			return "name_error";
		}
	};

	// Functions
	// TODO rework these functions to be more generic, parameterized, e.g. generate_character_name(eFACTION.Imperial) etc.
	static generate_sector_name = function() {
		return SimpleNameGeneration(sector_names, sector_used_names, "Sector");
	};

	static generate_star_name = function() {
		return SimpleNameGeneration(star_names, star_used_names, "Star", false);
	};

	static generate_space_marine_name = function() {
		return SimpleNameGeneration(space_marines_names, space_marines_used_names, "Space Marine");
	};

	static generate_imperial_name = function(is_male = true) {
		if (is_male) {
			return SimpleNameGeneration(space_marines_names, space_marines_used_names, "Space Marine");
		} else {
			return SimpleNameGeneration(imperial_names, imperial_used_names, "Imperial");
		}
	};

	static generate_genestealer_cult_name = function() {
		return ComplexTitledName(genestealer_cult_names.main, genestealer_cult_names.embelishment, genestealer_cult_names.title);
	};

	static generate_chaos_name = function() {
		return SimpleNameGeneration(chaos_names, chaos_used_names, "Chaos");
	};

	static generate_eldar_name = function(syllable_amount = 2) {
		return MultiSyllableNameGeneration(eldar_syllables, syllable_amount);
	};

	static generate_ork_name = function() {
		return CompositeNameGeneration(ork_name_composites, false);
	};

	static generate_imperial_ship_name = function() {
		return SimpleNameGeneration(imperial_ship_names, imperial_ship_used_names, "Imperial Ship");
	};

	static generate_ork_ship_name = function() {
		var ork_ship_name_count = max(array_length(ork_ship_names), array_length(ork_ship_used_names));

		if (irandom(ork_ship_name_count) == 0) {
			// Rare, special name
			return $"{generate_space_marine_name()}'s Revenge";
		}

		return SimpleNameGeneration(ork_ship_names, ork_ship_used_names, "Ork Ship");
	};

	static generate_hulk_name = function() {
		return CompositeNameGeneration(hulk_name_composites, true);
	};

	static generate_tau_leader_name = function() {
		return CompositeNameGeneration(tau_name_composites, true);
	};
}
