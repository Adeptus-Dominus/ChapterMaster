/*
    Mission flow: 
    scr_random_event -> rolls rng for inquis mission
    scr_inquisition_mission -> rolls rng and tests suitable planets for which mission
    mission_inquisition_<mission_name> -> logic and mechanics for spawning the mission and triggering the popup
    scr_popup -> displays the panel with mission details and Accept/Refuse buttons
    obj_popup.Step0 -> find `mission_is_go` section and add necessary event logic for when the player accepts
    scr_mission_functions > mission_name_key -> need to update this so that missions display in the mission log


    Helpers: 
    scr_mission_eta -> given the xy of a _star where the mission is, calculate how long you should have to complete the mission
            Todo? maybe add a disposition influence here so that angy inquisitor gives you less spare time and vice versa
    scr_star_has_planet_with_feature -> given the id of a _star and a `P_features` enum value, check if any planet on that _star has the desired  feature
    star_has_planet_with_forces -> given the id of a _star, and a faction, returns whether or not there are forces present there and in sufficient number
*/

/// @param {Enum.eEVENT} event
/// @param {Enum.eINQUISITION_MISSION} forced_mission optional
function scr_inquisition_mission(event, forced_mission = eINQUISITION_MISSION.RANDOM) {
    LOGGER.info($"RE: Inquisition Mission, event {event}, forced_mission {forced_mission}");
    if ((obj_controller.known[eFACTION.INQUISITION] == 0 || obj_controller.faction_status[eFACTION.INQUISITION] == "War") && !global.cheat_debug) {
        LOGGER.info("Player is either hasn't met or is at war with Inquisition, not proceeding with inquisition mission");
        return;
    }
    if (global.cheat_debug) {
        LOGGER.debug("find mission");
    }
    if (event == eEVENT.INQUISITION_PLANET) {
        mission_investigate_planet();
    } else if (event == eEVENT.INQUISITION_MISSION) {
        var inquisition_missions = [
            eINQUISITION_MISSION.PURGE,
            eINQUISITION_MISSION.INQUISITOR,
            eINQUISITION_MISSION.SPYRER,
            eINQUISITION_MISSION.ARTIFACT,
        ];

        var found_sleeping_necrons = false;
        var found_tyranid_org = false;

        var necron_tomb_worlds = [];
        var tyranid_org_worlds = [];
        var demon_worlds = [];

        var all_stars = scr_get_stars();
        for (var s = 0, _len = array_length(all_stars); s < _len; s++) {
            var _star = all_stars[s];

            if (scr_star_has_planet_with_feature(_star, eP_FEATURES.NECRON_TOMB) && !awake_necron_star(_star.id)) {
                array_push(necron_tomb_worlds, _star);
                found_sleeping_necrons = true;
            }

            if (star_has_planet_with_forces(_star, eFACTION.HERETICS, 1)) {
                // array_push(demon_worlds, _star); // turning this off til i have a way to finish the mission
            }

            if (star_has_planet_with_forces(_star, eFACTION.TYRANIDS, 4)) {
                array_push(tyranid_org_worlds, _star);
                found_tyranid_org = true;
            }
        }

        if (found_sleeping_necrons) {
            array_push(inquisition_missions, eINQUISITION_MISSION.TOMB_WORLD);
            LOGGER.info($"Was able to find a _star with dormant necron tomb for inquisition mission");
        } else {
            LOGGER.info($"Couldn't find any planets with a dormant necron tomb for inquisition mission");
        }
        if (found_tyranid_org) {
            LOGGER.info($"Was able to find a _star with lvl 4 tyranids for inquisition mission");
            array_push(inquisition_missions, eINQUISITION_MISSION.TYRANID_ORGANISM);
        } else {
            LOGGER.info($"Couldn't find any planets with lvl 4 tyranids for inquisition mission");
        }
        if (array_length(demon_worlds) > 0) {
            array_push(inquisition_missions, eINQUISITION_MISSION.DEMON_WORLD);
            LOGGER.info($"Was able to find a _star with demons on it for inquisition mission");
        } else {
            LOGGER.info($"Couldn't find any planets with demons for inquisition mission");
        }

        var chosen_mission = forced_mission;
        if (chosen_mission == eINQUISITION_MISSION.RANDOM) {
            chosen_mission = array_random_element(inquisition_missions);
        }
        switch (chosen_mission) {
            case eINQUISITION_MISSION.PURGE:
                mission_inquistion_purge();
                break;
            case eINQUISITION_MISSION.INQUISITOR:
                new SystemProblem("hunt_inquisitor");
                break;
            case eINQUISITION_MISSION.SPYRER:
                mission_inquistion_spyrer();
                break;
            case eINQUISITION_MISSION.ARTIFACT:
                mission_inquisition_artifact();
                break;
            case eINQUISITION_MISSION.TOMB_WORLD:
                mission_inquisition_necron_world(necron_tomb_worlds);
                break;
            case eINQUISITION_MISSION.TYRANID_ORGANISM:
                LOGGER.info("RE: Gaunt Capture");
                var _star = array_random_element(tyranid_org_worlds);
                var planet = -1;
                for (var i = 1; i <= _star.planets; i++) {
                    if (_star.p_tyranids[i] > 4) {
                        planet = i;
                        break;
                    }
                }

                var _eta = scr_mission_eta(_star.x, _star.y, 1);
                _eta = min(max(_eta, 6), 50);

                _star.get_planet_data(planet).new_problem("inquisition_tyranid_org", _eta);
                break;
            case eINQUISITION_MISSION.ETHEREAL:
                mission_inquisition_ethereal();
                break;
            case eINQUISITION_MISSION.DEMON_WORLD:
                var _star = array_random_element(demon_worlds);
                var _planet = -1;
                for (var i = 1; i <= _star.planets; i++) {
                    if (_star.p_demons[i] > 1) {
                        _planet = i;
                        break;
                    }
                }
                var _eta = scr_mission_eta(_star.x, _star.y, 25);
                _star.get_planet_data(_planet).new_problem("inquisition_demon_world", _eta)
                break;
        }
    }
}

function mission_inquisition_ethereal() {
    LOGGER.info("RE: Ethereal Capture");
    var stars = scr_get_stars();
    var _valid_stars = array_filter_ext(stars, function(_star, index) {
        for (var i = 1; i <= _star.planets; i++) {
            if (_star.p_owner[i] == eFACTION.TAU && _star.p_tau[i] >= 4) {
                return true;
            }
        }
        return false;
    });
    if (array_length(_valid_stars) == 0) {
        exit;
    }
    var _star = array_random_element(_valid_stars);

    var planet = -1;
    for (var i = 1; i <= _star.planets; i++) {
        if (_star.p_owner[i] == eFACTION.TAU && _star.p_tau[i] >= 4) {
            planet = i;
            break;
        }
    }
    var _eta = scr_mission_eta(_star.x, _star.y, 1);
    _eta = min(max(_eta, 12), 50);
    var text = $"An Inquisitor is trusting you with a special mission.";
    text += $"They require that you capture a Tau Ethereal from the planet {string(_star.name)} {scr_roman(planet)} for research purposes. You have {string(_eta)} months to locate and capture one. Can your chapter handle this mission?";
    scr_popup("Inquisition Mission", text, "inquisition", $"ethereal|{string(_star.name)}|{string(planet)}|{string(_eta + 1)}|");
}

function mission_inquisition_necron_world(tomb_worlds) {
    LOGGER.info("RE: Necron Tomb Bombing");
    var _star = noone;
    if (is_array(tomb_worlds)) {
        _star = array_random_element(tomb_worlds);
    } else {
        _star = tomb_worlds;
    }

    var planet = scr_get_planet_with_feature(_star, eP_FEATURES.NECRON_TOMB);

    if (planet == -1) {
        planet = irandom_range(1, _star.planets);
        array_push(_star.p_feature[planet], new NewPlanetFeature(eP_FEATURES.NECRON_TOMB));
    }

    var _eta = scr_mission_eta(_star.x, _star.y, 1);

    var _p_data = _star.get_planet_data(planet);
    _p_data.new_problem("inquisition_tomb", _eta, {});
}

/// @self Asset.GMObject.obj_popup
function init_mission_inquisition_necron_world() {
    var _mission_star = find_star_by_name(pop_data.system);
    var _p_data = _mission_star.get_planet_data(pop_data.planet);
    if (_mission_star == noone) {
        popup_default_close();
        exit;
    }
    scr_event_log("", $"Inquisition Mission Accepted: {global.chapter_name} have been given a Bomb to seal the Necron Tomb on {_p_data.name()}.", _mission_star.name);

    image = "necron_cave";
    title = "New Equipment";
    fancy_title = 0;
    text_center = 0;
    text = $"{global.chapter_name} have been provided with 1x Plasma Bomb in order to complete the mission.";

    if (demand) {
        text = $"The Inquisition demands that your Chapter demonstrate its loyalty.  {global.chapter_name} have been given a Plasma Bomb to seal the Necron Tomb on {_p_data.name()}.  It is expected to be completed within {pop_data.estimate} months.";
    }
    reset_popup_options();
    scr_add_item("Plasma Bomb", 1);
    obj_controller.cooldown = 10;
    if (demand) {
        demand = 0;
    }
    _p_data.new_problem("inquisition_tomb", estimate, {});
    exit;
}

function mission_inquisition_artifact() {
    var text;
    LOGGER.info("RE: Artifact Hold");
    text = "The Inquisition is trusting you with a special mission.  A local Inquisitor has a powerful artifact.  You are to keep it safe, and NOT use it, until the artifact may be safely retrieved.  Can your chapter handle this mission?";
    var _pop_data = {
        options : [
            {
                str1: "Accept",
                choice_func: mission_inquisition_artifact_accept,
            },
            {
                str1 : "Refuse",
                choice_func: popup_default_close,
            }
        ],
        estimate : irandom_range(6, 26)
    }

    scr_popup("Inquisition Mission", text, "inquisition", _pop_data);
}


// @self Asset.GMObject.obj_popup
function mission_inquisition_artifact_accept(){
    var _last_artifact;
    scr_quest(0, "artifact_loan", 4, pop_data.estimate);
    if (obj_ini.fleet_type == ePLAYER_BASE.HOME_WORLD) {
        image = "fortress";
        if (obj_ini.home_type == "Hive") {
            image = "fortress_hive";
        }
        if (obj_ini.home_type == "Death") {
            image = "fortress_death";
        }
        if (obj_ini.home_type == "Ice") {
            image = "fortress_ice";
        }
        if (obj_ini.home_type == "Lava") {
            image = "fortress_lava";
        }
        _last_artifact = scr_add_artifact("good", "inquisition", 0, obj_ini.home_name, -1);
    } else if (obj_ini.fleet_type != ePLAYER_BASE.HOME_WORLD) {
        image = "artifact_given";
        _last_artifact = scr_add_artifact("good", "inquisition", 0, obj_ini.ship[0], 0);
    }

    title = "New Artifact";
    fancy_title = 0;
    text_center = 0;
    text = "The Inquisition has left an Artifact in your care, until it may be retrieved.  It has been stored ";
    if (obj_ini.fleet_type == ePLAYER_BASE.HOME_WORLD) {
        text += "within your Fortress Monastery.";
    }
    if (obj_ini.fleet_type != ePLAYER_BASE.HOME_WORLD) {
        text += $"upon your ship '{obj_ini.ship[0]}'.";
    }
    scr_event_log("", "Inquisition Mission Accepted: The Inquisition has left an Artifact in your care.");

    text += $"  It is some form of {fetch_artifact(_last_artifact).get_type_name()}.";
    reset_popup_options();
    obj_controller.cooldown = 10;
    exit;
}


function hunt_inquisition_spared_inquisitor_consequence(event) {
    var _diceh = roll_dice_chapter(1, 100, "high");

    if (_diceh <= 25) {
        alarm[8] = 1;
        scr_loyalty("Crossing the Inquisition", "+");
        scr_popup("Inquisition Crossed", "", "", "");
    }
    if ((_diceh > 25) && (_diceh <= 50)) {
        scr_loyalty("Crossing the Inquisition", "+");
        scr_popup("Inquisition Crossed", "", "", "");
    }
    if ((_diceh > 50) && (_diceh <= 85)) {
        //nothing happens for the minute
    }
    if ((_diceh > 85) && (event.variation == 2)) {
        scr_popup("Anonymous Message", "You recieve an anonymous letter of thanks.  It mentions that motions are underway to destroy any local forces of Chaos.", "", "");
        with (obj_star) {
            for (var o = 1; o <= planets; o++) {
                p_heresy[o] = max(0, p_heresy[o] - 10);
            }
        }
    }
}

function mission_inquistion_spyrer() {
    LOGGER.info("RE: Spyrer");
    var stars = scr_get_stars();
    var _valid_stars = array_filter_ext(stars, function(_star, index) {
        return scr_star_has_planet_with_type(_star, "Hive");
    });

    if (array_length(_valid_stars) == 0) {
        LOGGER.error("RE: Spyrer, couldn't find _star");
        exit;
    }
    var _star = array_random_element(_valid_stars);
    var planet = scr_get_planet_with_type(_star, "Hive");
    var _eta = scr_mission_eta(_star.x, _star.y, 1);
    _eta = min(max(_eta, 6), 50);

    var _p_data = _star.get_planet_data(planet);
    _p_data.new_problem("inquisition_spyrer", _eta, {});
}

function mission_inquistion_purge() {
    LOGGER.info("RE: Purge");
    var mission_flavour = choose(1, 1, 1, 2, 2, 3);

    var stars = scr_get_stars();
    var _valid_stars = [];

    if (mission_flavour == 3) {
        _valid_stars = array_filter_ext(stars, function(_star, index) {
            var hive_idx = scr_get_planet_with_type(_star, "Hive");
            return scr_is_planet_owned_by_allies(_star, hive_idx);
        });
    } else {
        _valid_stars = array_filter_ext(stars, function(_star, index) {
            var hive_idx = scr_get_planet_with_type(_star, "Hive");
            var desert_idx = scr_get_planet_with_type(_star, "Desert");
            var temperate_idx = scr_get_planet_with_type(_star, "Temperate");
            var allied_hive = scr_is_planet_owned_by_allies(_star, hive_idx);
            var allied_desert = scr_is_planet_owned_by_allies(_star, desert_idx);
            var allied_temperate = scr_is_planet_owned_by_allies(_star, temperate_idx);

            return allied_hive || allied_desert || allied_temperate;
        });
    }

    if (array_length(_valid_stars) == 0) {
        LOGGER.error("RE: Purge, couldn't find _star");
        exit;
    }

    var _star = array_random_element(_valid_stars);

    var planet = -1;
    if (mission_flavour == 3) {
        planet = scr_get_planet_with_type(_star, "Hive");
    } else {
        var hive_planet = scr_get_planet_with_type(_star, "Hive");
        var desert_planet = scr_get_planet_with_type(_star, "Desert");
        var temperate_planet = scr_get_planet_with_type(_star, "Temperate");
        if (scr_is_planet_owned_by_allies(_star, hive_planet)) {
            planet = hive_planet;
        } else if (scr_is_planet_owned_by_allies(_star, temperate_planet)) {
            planet = temperate_planet;
        } else if (scr_is_planet_owned_by_allies(_star, desert_planet)) {
            planet = desert_planet;
        }
    }

    if (planet == -1) {
        LOGGER.error("RE: Purge, couldn't find planet");
        exit;
    }

    var _eta = infinity;
    with (obj_p_fleet) {
        if (capital_number + frigate_number == 0) {
            _eta = min(scr_mission_eta(_star.x, _star.y, 1), _eta); // this is wrong
        }
    }
    _eta += 10;
    _eta = min(max(_eta, 12), 100);

    var text = "The Inquisition is trusting you with a special mission.";
    var _purge_type = eDROP_TYPE.PURGEFIRE;
    if (mission_flavour < 3){
        _purge_type = eDROP_TYPE.PURGESELECTIVE;
    } 

    var _p_data = _star.get_planet_data(planet);
    _p_data.new_problem("inquisition_purge", _eta, {mission_flavour, purge_type:_purge_type});

}

function mission_investigate_planet() {
    var stars = scr_get_stars();
    var _valid_stars = array_filter_ext(stars, function(_star, index) {
        if (scr_star_has_planet_with_feature(_star, eP_FEATURES.ANCIENT_RUINS)) {
            var fleet = instance_nearest(_star.x, _star.y, obj_p_fleet);
            if (fleet == undefined || point_distance(_star.x, _star.y, fleet.x, fleet.y) >= 160) {
                return true;
            }
            return false;
        }
        return false;
    });

    if (array_length(_valid_stars) == 0) {
        LOGGER.error("RE: Investigate Planet, couldn't find a _star");
        exit;
    }

    var _star = array_random_element(_valid_stars);
    var planet = scr_get_planet_with_feature(_star, eP_FEATURES.ANCIENT_RUINS);
    if (planet == -1) {
        LOGGER.error("RE: Investigate Planet, couldn't pick a planet");
        exit;
    }
    var _eta = infinity;
    with (obj_p_fleet) {
        if (action != "") {
            continue;
        }
        _eta = min(_eta, scr_mission_eta(_star.x, _star.y, 1));
    }
    _eta = min(max(3, _eta), 100);
    _star.get_planet_data(planet).new_problem("inquisition_recon", _eta);
}


function set_gender() {
    return choose(eGENDER.FEMALE, eGENDER.MALE);
}
