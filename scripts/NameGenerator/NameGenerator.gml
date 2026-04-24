function NameTracker() constructor {
    names = [];
    used_names = [];

    composite_names = [];

    composite_components = {};

    generic_counter = 0;

    static LoadSimpleNames = function(file_name, fallback_value, json_names_property_name = "names") {
        if (json_names_property_name == noone) {
            json_names_property_name = "names";
        }

        var file_loader = new JsonFileListLoader();

        var load_result = file_loader.load_list_from_json_file($"main\\names\\{file_name}.json", [json_names_property_name]);

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
        if (json_names_property_names == noone) {
            json_names_property_names = [
                "prefixes",
                "suffixes",
                "special"
            ];
        }

        composite_names = json_names_property_names;

        var file_loader = new JsonFileListLoader();

        var load_result = file_loader.load_list_from_json_file($"main\\names\\{file_name}.json", json_names_property_names);

        var result = {};

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

    static AddUsedName = function (name){
        array_push(used_names, name);
    }

    static SimpleNameGeneration = function(entity_name, reset_on_using_up_all_names = true) {
        try {
            if (array_length(names) == 0) {
                var used_names_length = array_length(used_names);
                if (reset_on_using_up_all_names) {
                    LOGGER.info($"Used up all {entity_name} names, resetting name lists");
                    // TODO the 2 lines below could be simplified by swapping references, instead of copying and deleting
                    names = variable_clone(used_names);
                    used_names = []
                } else {
                    LOGGER.error($"Used up all {entity_name} names. Generating a generic name. used_names_length = {used_names_length}; star_names_generic_counter = {star_names_generic_counter}.");
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

    static MultiSyllableNameGeneration = function(syllable_amount) {
        syllables = composite_components;
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
            require_all = false) 
    {
        try {
            var _name = ""
            var _name_elem_length = array_length(title_elements)
            for (var i=0 ; i<_name_elem_length; i++){
                if (i > 0 && !require_all){
                    if (choose(0,1)){
                        continue;
                    }
                }
                if (struct_exists(composite_components,title_elements[i])){
                    var _elem_set = composite_components[$title_elements[i]];
                    _name += array_random_element(_elem_set, true) + i > 0 && i < _name_elem_length-1 ? " " : "";
                }
            }
            return _name;
        } catch (_exception) {
            handle_exception(_exception);
            return "name_error";
        }
    };

}

function NameGenerator() constructor {
    // TODO after save rework is finished, check if these static can be converted to instance version

    //TODO make this data set moddable t allow for greater name variations

    var _simple_names = json_to_gamemaker(working_directory + $"main\\name_loader.json", json_parse);

    if (_simple_names == ""){
        var _simple_names = [
            "sector",
            "star",
            {
                load_as: "imperial_male",
                load_set: "space_marine"
            },
            {
                load_as: "imperial_female",
                load_set: "imperial"
            },
            "space_marine",
            "chaos",
            "imperial_ship",
            "ork_ship",
            {
                load_as : "eldar",
                load_set: "eldar",
                composites : [
                    "first_syllables", 
                    "second_syllables", 
                    "third_syllables"
                ]
            },
            {
                load_as : "ork",
                load_set: "ork",
                composites : [
                    "prefixes", 
                    "suffixes", 
                    "special"
                ]
            },
            {
                load_as : "hulk",
                load_set: "hulk",
                composites : [
                    "prefixes", 
                    "suffixes", 
                ]
            },
            {
                load_as : "tau",
                load_set: "tau",
                composites : [
                    "prefixes", 
                    "suffixes", 
                ]
            },
            {
                load_as : "genestealercult",
                load_set: "genestealercult",
                composites : [
                    "main", 
                    "embelishment", 
                    "title"
                ]
            }
        ]
    }

    name_sets = {}

    for (var i=0;i<array_length(_simple_names);i++){
        var _name = _simple_names[i];
        var _load_name = _name;
        var _load_as_composite = false;
        if (is_struct(_name)){
            var _struc = _name;
            _name = _struc.load_as;
            _load_name = _struc.load_set;
            if (struct_exists(_struc, "composites")){
                _load_as_composite = true;
                var _composites = _struc.composites
            }
        }

        name_sets[$ _name] = new NameTracker();
        var _fallback_name = string_replace_all(_name, "_", " ") + " 1";

        var _set = name_sets[$ _name];
        if (!_load_as_composite){
            _set.LoadSimpleNames(_load_name, _fallback_name);
        } else {
            _set.LoadCompositeNames(_load_name, _composites);
        }
    }

    static GenerateFromSet = function(set_name){
        if (!struct_exists(name_sets,set_name)){
             LOGGER.info("Set name does not exist");
             return "No Set Name"
        }

        return name_sets[$ set_name].SimpleNameGeneration();
    }

    static GenerateComposite = function(set_name,separate_components = true){
        try {
            var _set = get_name_set(set_name);
            if (!is_struct(_set)){
                return _set
            }

            return _set.CompositeNameGeneration(separate_components);
		} catch(_exception){
            LOGGER.error(_exception);
        }
    }

    static GenerateMultiSyllable = function(set_name,syllable_amount){
        try {
            var _set = get_name_set(set_name);
            if (!is_struct(_set)){
                return _set
            }

            return _set.MultiSyllableNameGeneration(syllable_amount);
		} catch(_exception){
            LOGGER.error(_exception);
        }        
    }

    static GenerateComplexTitledName = function(set_name,
        title_elements = [
            "mains", 
            "embelishments", 
            "titles"
        ], 
    ){
        try {
            var _set = get_name_set(set_name);
            if (!is_struct(_set)){
                return _set
            }

            return _set.ComplexTitledName(title_elements);
		}catch (_exception){
            LOGGER.error(_exception);
        }        
    }

    static get_name_set = function(set_name){
        if (!struct_exists(name_sets,set_name)){
             LOGGER.info("Set name does not exist");
             return "No Set Name"
        }

        return name_sets[$ set_name];
    } 
}
