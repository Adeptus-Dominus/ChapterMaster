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
                mission_inquistion_hunt_inquisitor();
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
                var _star = array_random_element(worlds);
                var planet = -1;
                for (var i = 1; i <= _star.planets; i++) {
                    if (_star.p_tyranids[i] > 4) {
                        planet = i;
                        break;
                    }
                }

                var eta = scr_mission_eta(_star.x, _star.y, 1);
                eta = min(max(eta, 6), 50);

                _star.get_planet_data(planet).new_problem("tyranid_org", eta);
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
    var eta = scr_mission_eta(_star.x, _star.y, 1);
    eta = min(max(eta, 12), 50);
    var text = $"An Inquisitor is trusting you with a special mission.";
    text += $"They require that you capture a Tau Ethereal from the planet {string(_star.name)} {scr_roman(planet)} for research purposes. You have {string(eta)} months to locate and capture one. Can your chapter handle this mission?";
    scr_popup("Inquisition Mission", text, "inquisition", $"ethereal|{string(_star.name)}|{string(planet)}|{string(eta + 1)}|");
}

function mission_inquisition_tyranid_organism(worlds) {
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

    var eta = scr_mission_eta(_star.x, _star.y, 1);
    if (global.cheat_debug) {
        LOGGER.debug("mission popup");
    }
    var _options = [
        {
            str1: "Accept",
            choice_func: init_mission_inquisition_necron_world,
        },
        {
            str1: "Refuse",
            choice_func: popup_default_close,
        },
    ];
    var _pop_data = {
        system: _star.name,
        planet: planet,
        estimate: eta,
        mission: "inquisition_necron",
        options: _options,
    };

    var text = $"The Inquisition is trusting you with a special mission.  They have reason to suspect the Necron Tomb on planet {string(_star.name)} {scr_roman(planet)}";

    text += $" may become active.  You are to send a small group of marines to plant a bomb deep inside, within {string(eta)} months.  Can your chapter handle this mission?";

    scr_popup("Inquisition Mission", text, "inquisition", _pop_data);
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
    _p_data.new_problem("inquisition_necron", estimate, {});
    exit;
}

function mission_inquisition_artifact() {
    var text;
    LOGGER.info("RE: Artifact Hold");
    text = "The Inquisition is trusting you with a special mission.  A local Inquisitor has a powerful artifact.  You are to keep it safe, and NOT use it, until the artifact may be safely retrieved.  Can your chapter handle this mission?";
    scr_popup("Inquisition Mission", text, "inquisition", $"artifact|bop|0|{string(irandom_range(6, 26))}|");
}

function mission_inquistion_hunt_inquisitor(star_id = noone) {
    LOGGER.info("RE: Inquisitor Hunt");

    var stars = scr_get_stars();
    var _star = noone;

    if (star_id == noone) {
        var _valid_stars = stars;

        if (array_length(_valid_stars) == 0) {
            LOGGER.error("RE: Inquisitor Hunt,couldn't find a _star");
            exit;
        }

        _star = array_random_element(_valid_stars);
    } else {
        _star = star_id;
    }

    var _gender = set_gender();
    var _name = global.name_generator.GenerateFromSet($"imperial_{string_gender()}");
    var planet = irandom_range(1, _star.planets);

    var eta = scr_mission_eta(_star.x, _star.y, 1);
    eta = max(eta, 8);
    var text = $"The Inquisition is trusting you with a special mission.  A radical inquisitor named {_name} will be visiting the {_star.name} system in {eta} month's time.  They are highly suspect of heresy, and as such, are to be put down.  Can your chapter handle this mission?";
    if (obj_controller.demanding) {
        text = $"The Inquisition demands that your Chapter demonstrate its loyalty to the Imperium of Mankind and the Emperor.  A radical inquisitor is enroute to {_star.name}, expected within {eta} months.  They are to be silenced and removed.";
    }
    var _options = [
        {
            str1: "Accept",
            choice_func: init_mission_hunt_inquisitor,
        },
        {
            str1: "Refuse",
            choice_func: popup_default_close,
        },
    ];

    var _mission_data = {
        mission_id: scr_uuid_generate(),
        inquisitor_name: _name,
        inquisitor_gender: _gender,
        system: _star.name,
        planet: planet,
    };
    var _pop_data = {
        system: _star.name,
        planet: planet,
        estimate: eta,
        mission: "inquisitor",
        options: _options,
        mission_data: _mission_data,
    };

    scr_popup("Inquisition Mission", text, "inquisition", _pop_data);
}

/// @self Asset.GMObject.obj_popup
function init_mission_hunt_inquisitor() {
    var _mission_star = find_star_by_name(pop_data.system);
    if (_mission_star == noone) {
        popup_default_close();
        exit;
    }
    scr_event_log("", $"Inquisition Mission Accepted: The radical Inquisitor {pop_data.mission_data.inquisitor_name} enroute to {_mission_star.name} must be removed.  Estimated arrival in {pop_data.estimate} months.", _mission_star.name);

    var _radical_inquisitor_fleet = create_enemy_fleet(_mission_star.x - irandom_range(-400, 400), _mission_star.y - irandom_range(-400, 400), eFACTION.INQUISITION);
    with (_radical_inquisitor_fleet) {
        base_inquis_fleet();
    }

    fleet_add_cargo("radical_inquisitor", pop_data.mission_data, true, _radical_inquisitor_fleet);

    _radical_inquisitor_fleet.action_x = _mission_star.x;
    _radical_inquisitor_fleet.action_y = _mission_star.y;

    var _est = pop_data.estimate;
    with (_radical_inquisitor_fleet) {
        set_fleet_movement(false, "move", _est, _est);
    }
    var _p_data = _mission_star.get_planet_data(pop_data.planet);
    _p_data.new_problem(pop_data.mission, pop_data.estimate,pop_data.mission_data)

    title = "Inquisition Mission Accepted";
    text = $"{global.chapter_name} will intercept the radical Inquisitor {pop_data.mission_data.inquisitor_name} at {_mission_star.name}, expected within {pop_data.estimate} months.";
    reset_popup_options();
}

/// @desc Clears only the resolved radical inquisitor mission's log entry.
/// @param {Struct} _mission_data Mission data carrying its ID and target location.
/// @returns {Bool} Whether the matching mission log entry was cleared.
function resolve_radical_inquisitor_mission(_mission_data) {
    if (!is_struct(_mission_data) || !struct_exists(_mission_data, "mission_id") || !struct_exists(_mission_data, "system") || !struct_exists(_mission_data, "planet")) {
        LOGGER.error("Radical inquisitor mission data is missing its ID or target location");
        return false;
    }

    var _mission_star = find_star_by_name(_mission_data.system);
    if (_mission_star == noone) {
        LOGGER.error($"Radical inquisitor mission target system {_mission_data.system} could not be found");
        return false;
    }

    var _planet = _mission_data.planet;
    var _mission_id = _mission_data.mission_id;
    var _mission_removed = false;

    with (_mission_star) {
        var _problem_count = array_length(p_problem[_planet]);
        for (var i = 0; i < _problem_count; i++) {
            if (p_problem[_planet][i] != "inquisitor") {
                continue;
            }

            var _stored_data = p_problem[_planet][i].data;
            if (!is_struct(_stored_data) || !struct_exists(_stored_data, "mission_id")) {
                continue;
            }

            if (_stored_data.mission_id != _mission_id) {
                continue;
            }

            p_problem[_planet][i].delete = true;
            _mission_removed = true;
            break;
        }
    }

    if (!_mission_removed) {
        LOGGER.error($"No radical inquisitor mission entry matches mission ID {_mission_id}");
    }

    return _mission_removed;
}

/// @self Asset.GMObject.obj_popup
function mission_hunt_inquisitor_hear_out_radical_inquisitor() {
    var _offer = choose(1, 1, 2, 2, 3);

    var _gender = pop_data.inquisitor_gender;
    var _gender_third = string_gender_third_person(_gender);
    var gender_pronoun = string_gender_pronouns(_gender);

    if (_offer == 1) {
        replace_options([{str1: "Destroy their vessel", choice_func: mission_hunt_inquisitor_destroy_inquisitor_ship}, {str1: "Take the artifact and then destroy them", choice_func: mission_hunt_inquisitor_take_artifact_double_cross}, {str1: "Take the artifact and spare them", choice_func: mission_hunt_inquisitor_take_artifact_bribe}]);
        title = "Artifact Offered";
        text = $"The Inquisitor claims that this is a massive misunderstanding, and {_gender_third} wishes to prove {gender_pronoun} innocence.  If {global.chapter_name} allow their ship to leave {_gender_third} will give {global.chapter_name} an artifact.";
        exit;
    } else if (_offer == 2) {
        replace_options(
            [
                {str1: "Destroy their vessel", choice_func: mission_hunt_inquisitor_destroy_inquisitor_ship},
                {
                    str1: "Search their ship", //choice_func : instance_destroy, // TODO: Implement proper ship search logic
                },
                {str1: "Spare them", choice_func: mission_hunt_inquisitor_show_mercy},
            ],
        );
        title = "Mercy Plea";
        text = $"The Inquisitor claims that {_gender_third} has key knowledge that would grant the Imperium vital power over the forces of Chaos.  If {global.chapter_name} allow {gender_pronoun} ship to leave the forces of Chaos within this sector will be weakened.";
        exit;
    } else if (_offer == 3) {
        with (obj_en_fleet) {
            if ((trade_goods == "male_her") || (trade_goods == "female_her")) {
                with (obj_p_fleet) {
                    if (action != "") {
                        instance_deactivate_object(id);
                    }
                }
                with (instance_nearest(x, y, obj_p_fleet)) {
                    scr_add_corruption(true, "1d3");
                }
                instance_activate_object(obj_p_fleet);
                instance_destroy();
            }
        }
        title = "Inquisition Mission Completed";
        image = "exploding_ship";
        text = $"{global.chapter_name} allow communications.  As soon as the vox turns on {global.chapter_name} hear a sickly, hateful voice.  They begin to speak of the inevitable death of your marines, the fall of all that is and ever shall be, and " + string(gender_pronoun) + " Lord of Decay.  Their ship is fired upon and destroyed without hesitation.";
        reset_popup_options();
        scr_event_log("", "Inquisition Mission Completed: The radical Inquisitor has been purged.");
        resolve_radical_inquisitor_mission(pop_data);
        exit;
    }
    exit;
}

/// @self Asset.GMObject.obj_popup
function mission_hunt_inquisitor_take_artifact_bribe() {
    with (pop_data.inquisitor_ship) {
        random_sector_exit_point();
        trade_goods = "|DELETE|";
        action_spd = 256;
        set_fleet_movement(false);
    }
    var last_artifact = scr_add_artifact("random", "", 4);

    reset_popup_options();

    title = "Inquisition Mission Completed";
    text = "Your ship sends over a boarding party, who retrieve the offered artifact- ";
    text += $" some form of {fetch_artifact(last_artifact).get_type_name()}.  As promised {global.chapter_name} allow the Inquisitor to leave, hoping for the best.  What's the worst that could happen?";
    image = "artifact_recovered";
    scr_event_log("", "Artifact Recovered from radical Inquisitor.");
    scr_event_log("", "Inquisition Mission Completed: The radical Inquisitor has been purged.");
    resolve_radical_inquisitor_mission(pop_data);

    add_event({e_id: "inquisitor_spared", duration: irandom_range(6, 18) + 1, variation: 1});
}

/// @self Asset.GMObject.obj_popup
function mission_hunt_inquisitor_take_artifact_double_cross() {
    with (pop_data.inquisitor_ship) {
        instance_destroy();
    }
    var last_artifact = scr_add_artifact("random", "", 4);

    reset_popup_options();

    title = "Inquisition Mission Completed";
    text = "Your ship sends over a boarding party, who retrieve the offered artifact- ";
    text += $" some form of {fetch_artifact(last_artifact).get_type_name()}.  Once it is safely stowed away your ship is then ordered to fire.  The Inquisitor's own seems to hesitate an instant before banking away, but is quickly destroyed.";
    image = "exploding_ship";
    scr_event_log("", "Artifact recovered from radical Inquisitor.");
    scr_event_log("", "Inquisition Mission Completed: The radical Inquisitor has been purged.");
    resolve_radical_inquisitor_mission(pop_data);
}

/// @self Asset.GMObject.obj_popup
function mission_hunt_inquisitor_show_mercy() {
    with (pop_data.inquisitor_ship) {
        random_sector_exit_point();
        trade_goods = "|DELETE|";
        action_spd = 256;
        set_fleet_movement(false, 8);
    }

    title = "Inquisition Mission Completed";
    text = $"{global.chapter_name} allow the Inquisitor to leave, trusting in their words.  If they truly do have key information it is a risk {global.chapter_name} are willing to take.  What's the worst that could happen?";
    image = "artifact_recovered";
    reset_popup_options();

    scr_event_log("", "Inquisition Mission Completed?: The radical Inquisitor has been allowed to flee in order to weaken the forces of Chaos, as they promised.");
    resolve_radical_inquisitor_mission(pop_data);

    add_event({e_id: "inquisitor_spared", duration: irandom_range(6, 18) + 1, variation: 2});
}

/// @self Asset.GMObject.obj_popup
function mission_hunt_inquisitor_destroy_inquisitor_ship() {
    LOGGER.debug("mission_hunt_inquisitor_destroy_inquisitor_ship");
    var _final_disp_mod = 0;

    if (obj_controller.demanding == 0) {
        _final_disp_mod += 1;
    } else if (obj_controller.demanding == 1) {
        _final_disp_mod += choose(0, 0, 1);
    }

    if ((title == "Artifact Offered") || (title == "Mercy Plea")) {
        _final_disp_mod -= choose(0, 1);
    }

    alter_disposition(eFACTION.INQUISITION, _final_disp_mod);

    title = "Inquisition Mission Completed";
    image = "exploding_ship";
    text = "The Inquisitor's ship begans to bank and turn, to flee, but is immediately fired upon by your fleet.  The ship explodes, taking the Inquisitor with it.  The mission has been accomplished.";
    reset_popup_options();

    scr_event_log("", "Inquisition Mission Completed: The radical Inquisitor has been purged.");
    resolve_radical_inquisitor_mission(pop_data);
    with (pop_data.inquisitor_ship) {
        instance_destroy();
    }
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
    var eta = scr_mission_eta(_star.x, _star.y, 1);
    eta = min(max(eta, 6), 50);

    var text = $"The Inquisition is trusting you with a special mission.  An experienced Spyrer on hive world {string(_star.name)} {scr_roman(planet)}";
    text += $" has began to hunt indiscriminately, and proven impossible to take down by conventional means.  If they are not put down within {string(eta)} month's time panic is likely.  Can your chapter handle this mission?";
    var mission_params = $"spyrer|{string(_star.name)}|{string(planet)}|{string(eta + 1)}|";
    LOGGER.info($"Starting spyrer mission with params {mission_params}");
    scr_popup("Inquisition Mission", text, "inquisition", mission_params);
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

    var eta = infinity;
    with (obj_p_fleet) {
        if (capital_number + frigate_number == 0) {
            eta = min(scr_mission_eta(_star.x, _star.y, 1), eta); // this is wrong
        }
    }
    eta = min(max(eta, 12), 100);

    var text = "The Inquisition is trusting you with a special mission.";

    if (mission_flavour == 1) {
        text += $"  A number of high-ranking nobility on the planet {scr_roman(planet)} are being difficult and harboring heretical thoughts.  They are to be selectively purged within {string(eta)} months.  Can your chapter handle this mission?";
    } else if (mission_flavour == 2) {
        text += $"  A powerful crimelord on the planet {scr_roman(planet)} is gaining an unacceptable amount of power and disrupting daily operations.  They are to be selectively purged within {string(eta)} months.  Can your chapter handle this mission?";
    } else if (mission_flavour == 3) {
        text += $"  The mutants of hive world {scr_roman(planet)} are growing in numbers and ferocity, rising sporadically from the underhive.  They are to be cleansed by promethium within {string(eta)} months.  Can your chapter handle this mission?";
    }

    if (mission_flavour != 3) {
        scr_popup("Inquisition Mission", text, "inquisition", $"purge|{string(_star.name)}|{string(planet)}|{string(real(eta + 1))}|");
    } else {
        scr_popup("Inquisition Mission", text, "inquisition", $"cleanse|{string(_star.name)}|{string(planet)}|{string(real(eta + 1))}|");
    }
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

    var eta = infinity;
    with (obj_p_fleet) {
        if (action != "") {
            continue;
        }
        eta = min(eta, scr_mission_eta(_star.x, _star.y, 1));
    }
    eta = min(max(3, eta), 100);

    var text = $"The Inquisition wishes for you to investigate {string(_star.name)} {scr_roman(planet)}";
    text += $"  Boots are expected to be planted on its surface over the course of your investigation.";
    text += $" You have {string(eta)} months to complete this task.";
    scr_popup("Inquisition Recon", text, "inquisition", $"recon|{string(_star.name)}|{string(planet)}|{string(eta)}|");
}


function set_gender() {
    return choose(eGENDER.FEMALE, eGENDER.MALE);
}
