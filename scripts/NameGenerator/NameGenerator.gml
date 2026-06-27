function NameTracker(set_name) constructor {
    names = [];
    used_names = [];

    entity_name = set_name;

    composite_names = [];

    composite_components = {
        prefixes : [],
        suffixes : [],
        special : []
    };

    multisyllable_components = {
        first_syllables : [],
        second_syllables : [],
        third_syllables : []
    };

    generic_counter = 0;

    preffered_method = "simple";

    static LoadSimpleNames = function(file_name, fallback_value, json_names_property_name = "names") {
        var file_loader = new JsonFileListLoader();

        var load_result = file_loader.load_list_from_json_file($"main/names/{file_name}.json", [json_names_property_name]);

        if (load_result.is_success) {
            names = load_result.values[$ json_names_property_name];

            LOGGER.info($"{file_name} names loaded correctly");
        } else {
            names = [fallback_value];
        }
    };

    static LoadCompositeNames = function(
        file_name,
        json_names_property_names = [
            "prefixes",
            "suffixes",
            "special"
        ]
    ) {
        composite_names = json_names_property_names;

        var file_loader = new JsonFileListLoader();

        var load_result = file_loader.load_list_from_json_file($"main/names/{file_name}.json", json_names_property_names);

        var result = {
            prefixes : [],
            suffixes : [],
            special : []
        };

        for (var i = 0; i < array_length(json_names_property_names); i++) {
            var _property_name = json_names_property_names[i];
            if (!is_string(_property_name)) {
                continue;
            }
            if (load_result.is_success && struct_exists(load_result.values, _property_name)) {
                result[$ _property_name] = load_result.values[$ _property_name];
            } else {
                result[$ _property_name] = array_create(1, $"{_property_name} 1");
            }
        }

        composite_components = result;
    };

    static LoadSyllableNames = function(
        file_name,
        json_names_property_names = [
            "first_syllables",
            "second_syllables",
            "third_syllables"
        ]
    ) {
        composite_names = json_names_property_names;

        var file_loader = new JsonFileListLoader();

        var load_result = file_loader.load_list_from_json_file($"main/names/{file_name}.json", json_names_property_names);

        var result = {
            first_syllables : [],
            second_syllables : [],
            third_syllables : []
        };

        for (var i = 0; i < array_length(json_names_property_names); i++) {
            var _property_name = json_names_property_names[i];
            if (!is_string(_property_name)) {
                continue;
            }
            if (load_result.is_success && struct_exists(load_result.values, _property_name)) {
                result[$ _property_name] = load_result.values[$ _property_name];
            } else {
                result[$ _property_name] = array_create(1, $"{_property_name} 1");
            }
        }

        multisyllable_components = result;
    };

    static AddUsedName = function(name) {
        array_push(used_names, name);
    };

    static SimpleNameGeneration = function(reset_on_using_up_all_names = true) {
        try {
            if (array_length(names) == 0) {
                var used_names_length = array_length(used_names);
                if (reset_on_using_up_all_names) {
                    LOGGER.info($"Used up all {entity_name} names, resetting name lists");
                    // TODO the 2 lines below could be simplified by swapping references, instead of copying and deleting
                    names = array_shuffle(variable_clone(used_names));
                    used_names = [];
                } else {
                    LOGGER.error($"Used up all {entity_name} names. Generating a generic name. used_names_length = {used_names_length}; generic_counter = {generic_counter}.");
                    generic_counter++;
                    return $"{entity_name} {used_names_length + generic_counter}";
                }
            }

            var name = array_pop(names);
            array_push(used_names, name);
            return name;
        } catch (_exception) {
            LOGGER.error(_exception);
            return "name_error";
        }
    };

    static CompositeNameGeneration = function(separate_components = true) {
        try {
            if (struct_exists(composite_components, "special") && is_array(composite_components.special) && array_length(composite_components.special) > 0) {
                var use_special_name = irandom(200);
                if (use_special_name == 0) {
                    return composite_components.special[irandom(array_length(composite_components.special) - 1)];
                }
            }

            var composite_one = array_random_element(composite_components.prefixes, true);
            var composite_two = array_random_element(composite_components.suffixes, true);

            var separator = "";

            if (separate_components) {
                separator = " ";
            }

            return $"{composite_one}{separator}{composite_two}";
        } catch (_exception) {
            LOGGER.error(_exception);
            return "name_error";
        }
    };

    static MultiSyllableNameGeneration = function(syllable_amount = 3) {
        var syllables = multisyllable_components;
        try {
            var name = array_random_element(syllables.first_syllables, true);

            if (syllable_amount >= 2) {
                name += array_random_element(syllables.second_syllables, true);
            }

            if (syllable_amount >= 3) {
                name += array_random_element(syllables.third_syllables, true);
            }

            return name;
        } catch (_exception) {
            LOGGER.error(_exception);
            return "name_error";
        }
    };

    static ComplexTitledName = function(
        title_elements = [
            "mains",
            "embelishments",
            "titles"
        ],
        require_all = false
    ) {
        try {
            var _name = "";
            var _name_elem_length = array_length(title_elements);
            for (var i = 0; i < _name_elem_length; i++) {
                if (i > 0 && !require_all) {
                    if (choose(0, 1)) {
                        continue;
                    }
                }
                if (struct_exists(composite_components, title_elements[i])) {
                    var _elem_set = composite_components[$ title_elements[i]];
                    _name += array_random_element(_elem_set, true) + (i < _name_elem_length - 1 ? " " : "");
                }
            }
            return _name;
        } catch (_exception) {
            ERROR_HANDLER.handle_exception(_exception);
            return "name_error";
        }
    };

    static UsePreffered = function() {
        switch (preffered_method) {
            case "composite":
                return CompositeNameGeneration();
            case "complex":
                return ComplexTitledName(composite_names);
            case "syllables":
                return MultiSyllableNameGeneration();
            default:
                return SimpleNameGeneration();
        }
    };
}

function NameGenerator() constructor {
    // TODO after save rework is finished, check if these static can be converted to instance version
    var _name_sets = json_to_gamemaker(working_directory + $"main/name_loader.json", json_parse);

    name_sets = {};

    for (var i = 0; i < array_length(_name_sets); i++) {
        var _name = _name_sets[i];
        var _load_name = _name;
        var _preffered = "simple";
        var _composites = {};
        var _syllables = {};
        if (is_struct(_name)) {
            var _struc = _name;
            _name = _struc.load_as;
            _load_name = _struc.load_set;
            _preffered = "composite";
            if (struct_exists(_struc, "composites")) {
                _composites = _struc.composites;
            }
            if (struct_exists(_struc, "syllables")) {
                _syllables = _struc.syllables;
            }
            if (struct_exists(_struc, "preffered_method")) {
                _preffered = _struc.preffered_method;
            }
        }

        name_sets[$ _name] = new NameTracker(_name);
        var _fallback_name = string_replace_all(_name, "_", " ") + " 1";

        name_sets[$ _name].preffered_method = _preffered;
        if (_preffered == "simple") {
            name_sets[$ _name].LoadSimpleNames(_load_name, _fallback_name);
        } else if (_preffered == "composite") {
            name_sets[$ _name].LoadCompositeNames(_load_name, _composites);
        } else if (_preffered == "syllables") {
            name_sets[$ _name].LoadSyllableNames(_load_name, _syllables);
        }
    }

    static GenerateFromSet = function(set_name, reset_on_using_up_all_names = true) {
        if (!struct_exists(name_sets, set_name) || set_name == "") {
            LOGGER.debug($"Set name {set_name} does not exist");
            return "No Set Name";
        }

        return name_sets[$ set_name].SimpleNameGeneration(reset_on_using_up_all_names);
    };

    static ChapterMemberNameGeneration = function() {
        try {
            var _name = "";
            var _styles = ["space_marine"];
            if (instance_exists(obj_creation)) {
                _styles = array_join(_styles, obj_creation.buttons.culture_styles.selections());
            } else {
                _styles = array_join(obj_ini.culture_styles, _styles);
            }

            _styles = array_shuffle(_styles);

            for (var i = 0; i < array_length(_styles); i++) {
                var _set = get_name_set(_styles[i]);
                if (is_struct(_set)) {
                    _name = _set.UsePreffered();
                }
            }

            if (_name == "") {
                GenerateFromSet("imperial_male");
            }
            return _name;
        } catch (_exception) {
            LOGGER.error(_exception);
            return "name gen error!";
        }
    };

    static GenerateComposite = function(set_name, separate_components = true) {
        try {
            var _set = get_name_set(set_name);
            if (!is_struct(_set)) {
                return _set;
            }

            return _set.CompositeNameGeneration(separate_components);
        } catch (_exception) {
            LOGGER.error(_exception);
            return "name gen error!";
        }
    };

    static GenerateMultiSyllable = function(set_name, syllable_amount) {
        try {
            var _set = get_name_set(set_name);
            if (!is_struct(_set)) {
                return _set;
            }

            return _set.MultiSyllableNameGeneration(syllable_amount);
        } catch (_exception) {
            LOGGER.error(_exception);
            return "name gen error!";
        }
    };

    static GenerateComplexTitledName = function(
        set_name,
        title_elements = [
            "mains",
            "embelishments",
            "titles"
        ]
    ) {
        try {
            var _set = get_name_set(set_name);
            if (!is_struct(_set)) {
                return _set;
            }

            return _set.ComplexTitledName(title_elements);
        } catch (_exception) {
            LOGGER.error(_exception);
            return "name gen error!";
        }
    };

    static get_name_set = function(set_name) {
        if (!struct_exists(name_sets, set_name)) {
            LOGGER.debug($"Set name {set_name} does not exist");
            return "No Set Name";
        }

        return name_sets[$ set_name];
    };
}
