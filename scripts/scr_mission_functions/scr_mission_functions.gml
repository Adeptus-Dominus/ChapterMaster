
function location_out_of_player_control(unit_loc) {
    static _locs = [
        "Terra",
        "Mechanicus Vessel",
        "Lost",
        "Mars",
    ];
    return array_contains(_locs, unit_loc);
}

global.planet_problem_keys = [
    "meeting_trap",
    "meeting",
    "succession",
    "mech_raider",
    "mech_bionics",
    "mech_mars",
    "mech_tomb",
    "hunt_fallen",
    "great_crusade",
    "harlequins",
    "fund_elder",
    "provide_garrison",
    "hunt_beast",
    "protect_raiders",
    "join_communion",
    "join_parade",
    "recover_artifacts",
    "train_forces",
    "inquisition_spyrer",
    "inquisitor",
    "inquisition_recon",
    "cleanse",
    "purge",
    "inquisition_tyranid_org",
    "artifact_loan",
    "inquisition_tomb",
    "ethereal",
    "demon_world",
    "governor_purge_enemies"
];

function mission_name_key(mission) {
    static mission_key = {
        "meeting_trap": "Chaos Lord Meeting",
        "meeting": "Chaos Lord Meeting",
        "succession": "War of succession",
        "mech_raider": "Provide Land Raider to Mechanicus",
        "mech_bionics": "Provide Bionic Augmented marines to study",
        "mech_mars": "Send Techmarines to mars",
        "mech_tomb": "Explore Mechanicus Tomb",
        "hunt_fallen": "Find Chapter Fallen",
        "great_crusade": "Answer Crusade Muster Call",
        "harlequins": "Harlequin presence Report",
        "fund_elder": "provide assistance to Eldar",
        "provide_garrison": "Provision Garrison",
        "hunt_beast": "Hunt Beasts",
        "protect_raiders": "Protect From Raiders",
        "join_communion": "Join Planetary Religious Celebration",
        "join_parade": "Join Parade on Planet Surface",
        "recover_artifacts": "Recover Artifacts",
        "train_forces": "Train Planet Forces",
        // Inquisition missions
        "inquisition_spyrer": "Kill Spyrer for Inquisitor",
        "inquisitor": "Radical Inquisitor Arriving",
        "inquisition_recon": "Recon Mission for Inquisitor",
        "cleanse": "Cleanse Planet for Inquisitor",
        "purge": "Purge Leadership for Inquisitor",
        "inquisition_tyranid_org": "Capture Tyranid for Inquisitor",
        // "bomb" : "Bombard World for Inquisitor",
        "artifact_loan": "Safeguard Artifact for the Inquisition",
        "inquisition_tomb": "Bomb Necron Tomb for Inquisitor",
        "ethereal": "Capture Ethereal for Inquisitor",
        "demon_world": "Clear Demon World for Inquisitor",
    };
    if (struct_exists(mission_key, mission)) {
        return mission_key[$ mission];
    } else {
        return "";
    }
}

/// @self Asset.GMObject.obj_star
function scr_new_governor_mission(planet, problem = "") {
    if (p_owner[planet] != eFACTION.IMPERIUM) {
        exit;
    }
    var _planet_type = p_type[planet];
    if (problem == "") {
        if (_planet_type == "Death") {
            problem = choose("hunt_beast", "provide_garrison");
        } else if (_planet_type == "Hive") {
            problem = choose("show_of_power", "provide_garrison", "governor_purge_enemies", "raid_black_market");
        } else if (_planet_type == "Temperate") {
            problem = choose("provide_garrison", "train_forces", "join_parade");
        } else if (_planet_type == "Shrine") {
            problem = choose("provide_garrison", "join_communion");
        } else if (_planet_type == "Ice") {
            problem = choose("provide_garrison", "hunt_beast");
        } else if (_planet_type == "Lava") {
            problem = choose("provide_garrison", "protect_raiders");
        } else if (_planet_type == "Agri") {
            problem = choose("provide_garrison", "protect_raiders", "recover_artifacts");
        } else if (_planet_type == "Desert") {
            problem = choose("provide_garrison", "protect_raiders", "recover_artifacts");
        } else if (_planet_type == "Feudal") {
            problem = choose("hunt_beast", "protect_raiders");
        }
    }
    var mission_data = {
        stage: "preliminary",
        applicant: "Governor",
    };
    if (problem != "") {
        var _p_data = get_planet_data(planet);
        _p_data.new_problem(problem, 20 + irandom(20),mission_data);
    }
}

function init_marine_acting_strange() {
    var marine_and_company = scr_random_marine("", 0);
    if (marine_and_company == "none") {
        LOGGER.error("RE: Strange Behavior, couldn't pick a space marine");
        exit;
    }

    var _unit = fetch_unit(marine_and_company);
    if (!is_struct(_unit)) {
        exit;
    }
    var _text = _unit.name_role();
    var _company_text = scr_convert_company_to_string(_unit.company);
    if (_company_text != "") {
        _company_text = $"({_company_text})";
        _text += _company_text;
    }
    _text += " is behaving strangely.";
    scr_alert("color", "lol", _text, 0, 0);
    scr_event_log("color", _text);
}


// returns a bool for if any planet on a given star has the given problem
/// @self Asset.GMObject.obj_star
function has_problem_star(problem, star = noone) {
    var has_problem = false;
    if (star == noone) {
        for (var i = 1; i <= planets; i++) {
            has_problem = get_planet_data(i).has_problem(problem);
            if (has_problem) {
                has_problem = true;
                break;
            }
        }
    } else {
        with (star) {
            has_problem = has_problem_star(problem);
        }
    }
    return has_problem;
}


///removie all of a given problem from a planet
/// @self Asset.GMObject.obj_star
function remove_planet_problem(planet, problem, star = noone) {
    var _had_problem = false;
    if (star == noone) {
        for (var i = 0; i < array_length(p_problem[planet]); i++) {
            if (p_problem[planet][i].p_id == problem) {
                array_delete(p_problem[planet],i, 1);
                _had_problem = true;
            }
        }
    } else {
        with (star) {
            _had_problem = remove_planet_problem(planet, problem);
        }
    }
    return _had_problem;
}

//remove all of a given problem types from a star
/// @self Asset.GMObject.obj_star
function remove_star_problem(problem, star = noone) {
    if (star == noone) {
        for (var i = 1; i <= planets; i++) {
            remove_planet_problem(i, problem);
        }
    } else {
        with (star) {
            remove_star_problem(problem);
        }
    }
}

/// @self struct.PlanetData | Asset.GMObject.obj_star
function generic_problems_to_mission_log (){
    var _logs = [];
    for (var p = 0; p < array_length(problems); p++) {
        var _problem = problems[p];
        var _data = _problem.mission_log_entry();

        if (!is_undefined(_data)){
            array_push(_logs, _data);
        }
    }
    return _logs;
}

/// @desc Compares two location arrays to determine if they represent the same place.
/// @param {array} _first_loc
/// @param {array} _second_loc
/// @returns {bool}
function locations_are_equal(_first_loc, _second_loc) {
    if (!is_array(_first_loc) || !is_array(_second_loc) || array_length(_first_loc) < 3 || array_length(_second_loc) < 3) {
        LOGGER.error("Attempted to compare non-array or broken location data.");
        return false;
    }

    var _first_type = _first_loc[2];
    var _second_type = _second_loc[2];
    var _not_lost = (_first_type != "Warp" && _first_type != "Lost") && (_second_type != "Warp" && _second_type != "Lost");

    if (_not_lost && (_first_type == _second_type)) {
        return true;
    }

    return (_first_loc[1] == _second_loc[1]) && (_first_loc[0] == _second_loc[0]);
}
