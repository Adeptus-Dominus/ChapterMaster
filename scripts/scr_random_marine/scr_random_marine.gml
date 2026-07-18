/// @param {string|Array<string>} role
/// @param {Real} exp_req
/// @param {Struct} search_params a struct giving extra search information
function scr_random_marine(role, exp_req, search_params = {}) {
    var company_list = [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
    ];
    if (!is_array(role) && role == SPECIALISTS_LIBRARIANS) {
        role = role_groups(SPECIALISTS_LIBRARIANS);
    }
    for (var comp_shuffle = 0; comp_shuffle <= 10; comp_shuffle++) {
        // this ensures that companies are searched randomly
        var new_comp = irandom(array_length(company_list) - 1);
        var company = company_list[new_comp];
        array_delete(company_list, new_comp, 1);
        if (!is_array(role)) {
            if (string_count("Aspirant", role) > 0) {
                comp_shuffle = 15;
                company = 0;
            }
        }
        if (company <= 10) {
            var comp_size = array_length(obj_ini.name[company]);

            //This makes sure that cmopanies are searched randomly by creating an array of array positions to be randomly accessed
            var marine_list = [];
            for (var i = 0; i < comp_size; i++) {
                marine_list[i] = i;
            }
            while (comp_size > 0) {
                var list_place = irandom(comp_size - 1);
                var _dude_index = marine_list[list_place];
                var match = true;
                var unit = obj_ini.TTRPG[company][_dude_index];

                //exit if not real name
                if ((unit.name() == "") || (unit.name() == 0)) {
                    array_delete(marine_list, list_place, 1);
                    comp_size--;
                    continue;
                }

                //check correct search param roles
                var unit_role = unit.role();
                if (unit_role == obj_ini.role[100][eROLE.CHAPTERMASTER]) {
                    array_delete(marine_list, list_place, 1);
                    comp_size--;
                    continue;
                }
                //if list of matchable roles given
                if (is_array(role)) {
                    match = false;
                    for (var r = 0; r < array_length(role); r++) {
                        if (unit_role == role[r]) {
                            match = true;
                            break;
                        }
                    }
                    //if no role matches quit
                    if (!match) {
                        array_delete(marine_list, list_place, 1);
                        comp_size--;
                        continue;
                    }

                    //if single matchable role given
                } else if (role != "") {
                    if (unit_role != role) {
                        array_delete(marine_list, list_place, 1);
                        comp_size--;
                        continue;
                    }
                }

                //check corect experience
                if (unit.experience < exp_req) {
                    array_delete(marine_list, list_place, 1);
                    comp_size--;
                    continue;
                }

                //if extra search parmas struct submitted
                if (is_struct(search_params)) {
                    //if searching for marines with particular traits
                    if (struct_exists(search_params, "trait")) {
                        //list of traits (all required) need an option for if only one is required
                        if (is_array(search_params.trait)) {
                            if (!struct_exists(search_params, "trait_any")) {
                                for (var trait = 0; trait < array_length(search_params[$ "trait"]); trait++) {
                                    if (!array_contains(unit.traits, search_params[$ "trait"][trait])) {
                                        match = false;
                                        break;
                                    }
                                }
                            } else {
                                for (var trait = 0; trait < array_length(search_params[$ "trait"]); trait++) {
                                    if (array_contains(unit.traits, search_params[$ "trait"][trait])) {
                                        match = true;
                                        break;
                                    } else {
                                        match = false;
                                    }
                                }
                            }
                        } else {
                            //search for single trait
                            if (!array_contains(unit.traits, search_params[$ "trait"])) {
                                match = false;
                            }
                        }
                        //move to next unit if unit did not have required traits
                        if (!match) {
                            array_delete(marine_list, list_place, 1);
                            comp_size--;
                            continue;
                        }
                    }
                    if (struct_exists(search_params, "stat")) {
                        match = stat_valuator(search_params[$ "stat"], unit);
                        if (!match) {
                            array_delete(marine_list, list_place, 1);
                            comp_size--;
                            continue;
                        }
                    }
                    if (struct_exists(search_params, "role_tag")) {
                        match = false;
                        switch (search_params.role_tag) {
                            case "Techmarine":
                                if (unit.role_tag[eROLE_TAG.Techmarine]) {
                                    match = true;
                                }
                                break;
                            case "Librarian":
                                if (unit.role_tag[eROLE_TAG.Librarian]) {
                                    match = true;
                                }
                                break;
                            case "Chaplain":
                                if (unit.role_tag[eROLE_TAG.Chaplain]) {
                                    match = true;
                                }
                                break;
                            case "Apothecary":
                                if (unit.role_tag[eROLE_TAG.Apothecary]) {
                                    match = true;
                                }
                                break;
                        }

                        if (!match) {
                            array_delete(marine_list, list_place, 1);
                            comp_size--;
                            continue;
                        }
                    }

                    if (struct_exists(search_params, "job")) {
                        match = false;
                        if (unit.job == search_params[$ "job"]) {
                            match = true;
                        }

                        if (!match) {
                            array_delete(marine_list, list_place, 1);
                            comp_size--;
                            continue;
                        }
                    }
                }
                //if match made exit loop and return unit
                if (match) {
                    return [
                        company,
                        _dude_index,
                    ];
                }
            }
        }
    }
    return "none";
}
