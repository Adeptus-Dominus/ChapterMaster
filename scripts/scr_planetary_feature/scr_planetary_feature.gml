enum P_features {
    Sororitas_Cathedral,
    Necron_Tomb,
    Artifact,
    STC_Fragment,
    Ancient_Ruins,
    Cave_Network,
    Recruiting_World,
    Monastery,
    Warlord6,
    OrkWarboss,
    Warlord10,
    Special_Force,
    ChaosWarband,
    Webway,
    Secret_Base,
    Starship,
    Succession_War,
    Mechanicus_Forge,
    Reclamation_pools,
    Capillary_Towers,
    Daemonic_Incursion,
    Victory_Shrine,
    Arsenal,
    Gene_Vault,
    Forge,
    Gene_Stealer_Cult,
    Mission,
    OrkStronghold,
}

enum base_types {
    Lair,
}

function PlayerForge() constructor {
    constructions = [];
    size = 1;
    techs_working = 0;
    f_type = P_features.Forge;
    vehicle_hanger = 0;
}

// Function creates a new struct planet feature of a  specified type
function NewPlanetFeature(feature_type, other_data = {}) constructor {
    f_type = feature_type;

    static reveal_to_player = function() {
        if (player_hidden == 1) {
            player_hidden = 0;
        }
    };

    switch (f_type) {
        case P_features.Gene_Stealer_Cult:
            PDF_control = 0;
            sealed = 0;
            player_hidden = 1;
            planet_display = "Genestealer Cult";
            cult_age = 0;
            hiding = true;
            name = global.name_generator.generate_genestealer_cult_name();
            break;
        case P_features.Necron_Tomb:
            awake = 0;
            sealed = 0;
            player_hidden = 1;
            planet_display = "Dormant Necron Tomb";
            break;

        case P_features.Secret_Base:
            base_type = base_types.Lair;
            inquis_hidden = 1;
            planet_display = "Hidden Secret Base";
            player_hidden = 0;
            style = "UTL";
            if (struct_exists(other_data, "style")) {
                style = other_data[$ "style"];
            }
            built = obj_controller.turn + 3;
            forge = 0;
            hippo = 0;
            beastarium = 0;
            torture = 0;
            narcotics = 0;
            relic = 0;
            cookery = 0;
            vox = 0;
            librarium = 0;
            throne = 0;
            stasis = 0;
            swimming = 0;
            stock = 0;
            break;
        case P_features.Arsenal:
            inquis_hidden = 1;
            planet_display = "Arsenal";
            player_hidden = 0;
            built = obj_controller.turn + 3;
            break;
        case P_features.Gene_Vault:
            inquis_hidden = 1;
            planet_display = "Arsenal";
            player_hidden = 0;
            built = obj_controller.turn + 3;
            break;
        case P_features.Starship:
            f_type = P_features.Starship;
            planet_display = "Ancient Starship";
            funds_spent = 0;
            player_hidden = 0;
            engineer_score = 0;
            break;
        case P_features.Ancient_Ruins:
            static ruins_explored = scr_ruins_explored;
            static explore = scr_explore_ruins;
            static determine_race = scr_ruins_determine_race;
            static recover_from_dead = scr_ruins_recover_from_dead;
            static forces_defeated = scr_ruins_player_forces_defeated;
            static find_starship = scr_ruins_find_starship;
            static suprise_attack = scr_ruins_suprise_attack_player;
            static ruins_combat_end = scr_ruins_combat_end;
            scr_ancient_ruins_setup();
            break;
        case P_features.STC_Fragment:
            player_hidden = 1;
            Fragment_type = 0;
            planet_display = "STC Fragment";
            break;
        case P_features.Cave_Network:
            player_hidden = 1;
            cave_depth = irandom(3); //allow_multiple levels of caves, option to go deeper
            planet_display = "Unexplored Cave Network";
            break;
        case P_features.Sororitas_Cathedral:
            player_hidden = 1;
            planet_display = "Sororitas Cathedral";
            break;
        case P_features.Artifact:
            player_hidden = 1;
            planet_display = "Artifact";
            break;
        case P_features.OrkWarboss:
            player_hidden = 1;
            planet_display = "Ork Warboss";
            Warboss = "alive";
            name = global.name_generator.generate_ork_name();
            turns_static = 0;
            break;
        case P_features.OrkStronghold:
            player_hidden = 1;
            planet_display = "Ork Stronghold";
            tier = 1;
            break;
        case P_features.Monastery:
            planet_display = "Fortress Monastary";
            player_hidden = 0;
            forge = 0;
            name = global.name_generator.generate_imperial_ship_name();
            break;
        case P_features.Recruiting_World:
            planet_display = "Recruitment";
            player_hidden = 0;
            recruit_type = 0;
            recruit_cost = 0;
            break;
        case P_features.ChaosWarband:
            if (!struct_exists(other_data, "patron")) {
                patron = choose("slaanesh", "tzeentch", "khorne", "nurgle", "undivided");
            } else {
                self.patron = other_data.patron;
            }
        default:
            player_hidden = 1;
            planet_display = 0;
    }
    if (global.cheat_debug) {
        player_hidden = 0;
    }

    static load_json_data = function(data) {
        var names = variable_struct_get_names(data);
        for (var i = 0; i < array_length(names); i++) {
            variable_struct_set(self, names[i], variable_struct_get(data, names[i]));
        }
    };
}

function move_feature_to_fleet(planet, feature_slot, fleet, cargo_key) {
    var _feat = p_feature[planet][feature_slot];
    array_delete(p_feature[planet], feature_slot, 1);
    fleet.cargo_data[$ cargo_key] = _feat;
}

function move_feature_to_planet(cargo_key, star, planet) {}

// returns an array of all the positions that a certain planet feature occurs on th p_feature array of a planet
// this works for both planet_Features and planet upgrades
function search_planet_features(planet, search_feature) {
    var feature_count = array_length(planet);
    var feature_positions = [];
    if (feature_count > 0) {
        for (var fc = 0; fc < feature_count; fc++) {
            if (planet[fc].f_type == search_feature) {
                array_push(feature_positions, fc);
            }
        }
    }
    return feature_positions;
}

function return_planet_features(planet, search_feature) {
    var feature_count = array_length(planet);
    var feature_positions = [];
    if (feature_count > 0) {
        for (var fc = 0; fc < feature_count; fc++) {
            if (planet[fc].f_type == search_feature) {
                array_push(feature_positions, planet[fc]);
            }
        }
    }
    return feature_positions;
}

// returns 1 if dearch feature is on at least one planet in system returns 0 is search feature is not found in system
function system_feature_bool(system, search_feature) {
    var sys_bool = 0;
    for (var sys = 1; sys < 5; sys++) {
        sys_bool = planet_feature_bool(system[sys], search_feature);
        if (sys_bool == 1) {
            break;
        }
    }
    return sys_bool;
}

//returns 1 if feature found on given planet returns 0 if feature not found on planet
function planet_feature_bool(planet, search_feature) {
    var feature_count = array_length(planet);
    var feature_exists = 0;
    if (feature_count > 0) {
        for (var fc = 0; fc < feature_count; fc++) {
            if (!is_array(search_feature)) {
                if (planet[fc].f_type == search_feature) {
                    feature_exists = 1;
                }
            } else {
                feature_exists = array_contains(search_feature, planet[fc].f_type);
            }
            if (feature_exists == 1) {
                break;
            }
        }
    }
    return feature_exists;
}

//deletes all occurances of del_feature on planet
function delete_features(planet, del_feature) {
    var delete_Array = search_planet_features(planet, del_feature);
    if (array_length(delete_Array) > 0) {
        for (var d = 0; d < array_length(delete_Array); d++) {
            array_delete(planet, delete_Array[d], 1);
        }
    }
}

// returns 1 if an awake necron tomb iin system
function awake_necron_star(star) {
    for (var i = 1; i <= star.planets; i++) {
        if (awake_tomb_world(star.p_feature[i]) == 1) {
            return i;
        }
    }
    return 0;
}

//returns 1 if awake tomb world on planet 0 if tombs on planet but not awake and 2 if no tombs on planet
function awake_tomb_world(planet) {
    var awake_tomb = 0;
    var tombs = search_planet_features(planet, P_features.Necron_Tomb);
    if (array_length(tombs) > 0) {
        for (var tomb = 0; tomb < array_length(tombs); tomb++) {
            if (planet[tombs[tomb]].awake == 1) {
                awake_tomb = 1;
            }
            if (awake_tomb == 1) {
                break;
            }
        }
        return awake_tomb;
    }
    return 2;
}

//selas a tomb world and switche off awake so will no longer spawn necrons or necron fleets
function seal_tomb_world(planet) {
    var awake_tomb = 0;
    var tombs = search_planet_features(planet, P_features.Necron_Tomb);
    if (array_length(tombs) > 0) {
        for (var tomb = 0; tomb < array_length(tombs); tomb++) {
            awake_tomb = 1;
            planet[tombs[tomb]].awake = 0;
            planet[tombs[tomb]].sealed = 1;
            planet[tombs[tomb]].planet_display = "Sealed Necron Tomb";
            if (awake_tomb == 1) {
                break;
            }
        }
    }
}

//awakens a tomb world so necrons and necron fleets will spawn
function awaken_tomb_world(planet) {
    var awake_tomb = 0;
    var tombs = search_planet_features(planet, P_features.Necron_Tomb);
    if (array_length(tombs) > 0) {
        for (var tomb = 0; tomb < array_length(tombs); tomb++) {
            if (planet[tombs[tomb]].awake == 0) {
                awake_tomb = 1;
                planet[tombs[tomb]].awake = 1;
                planet[tombs[tomb]].planet_display = "Active Necron Tomb";
            }
            if (awake_tomb == 1) {
                break;
            }
        }
    }
}

// creates alerts for discovering features on a planet
function scr_planetary_feature(planet_num) {
    var plan_feat_count = array_length(p_feature[planet_num]);
    //need to iterate over features instead of just looking at first
    for (var f = 0; f < plan_feat_count; f++) {
        var feat = p_feature[planet_num][f];
        if (feat.player_hidden == 1) {
            feat.player_hidden = 0;
            var numeral_n = planet_numeral_name(planet_num);
            switch (feat.f_type) {
                case P_features.Sororitas_Cathedral:
                    if (obj_controller.known[eFACTION.Ecclesiarchy] == 0) {
                        obj_controller.known[eFACTION.Ecclesiarchy] = 1;
                    }
                    var lop = $"Sororitas Cathedral discovered on {numeral_n}.";
                    scr_alert("green", "feature", lop, x, y);
                    scr_event_log("", lop);
                    if (p_heresy[planet_num] > 10) {
                        p_heresy[planet_num] -= 10;
                    }
                    p_sisters[planet_num] = choose(2, 2, 3);
                    goo = 1;
                    break;
                case P_features.Necron_Tomb:
                    var lop = $"Necron Tomb discovered on {numeral_n}.";
                    scr_alert("red", "feature", lop, x, y);
                    scr_event_log("red", lop);
                    break;
                case P_features.Artifact:
                    var lop = $"Artifact discovered on {numeral_n}.";
                    scr_alert("green", "feature", lop, x, y);
                    scr_event_log("", lop);
                    break;
                case P_features.STC_Fragment:
                    var lop = $"STC Fragment located on {numeral_n}.";
                    scr_alert("green", "feature", lop, x, y);
                    scr_event_log("", lop);
                    break;
                case P_features.Ancient_Ruins:
                    var lop = $"A {feat.ruins_size} Ancient Ruins discovered on {string(name)} {scr_roman(planet_num)}.";
                    scr_alert("green", "feature", lop, x, y);
                    scr_event_log("", lop);
                    break;
                case P_features.Cave_Network:
                    var lop = $"Extensive Cave Network discovered on {numeral_n}.";
                    scr_alert("green", "feature", lop, x, y);
                    scr_event_log("", lop);
                    break;
                case P_features.OrkWarboss:
                    var lop = $"Ork Warboss discovered on {numeral_n}.";
                    scr_alert("red", "feature", lop, x, y);
                    scr_event_log("red", lop);
                    break;
            }
        }
    }
}

function create_starship_event() {
    var star = scr_random_find(2, true, "", "");
    if (star == undefined) {
        global.logger.error("RE: couldn't find starship target");
        return false;
    } else {
        var planet = irandom(star.planets - 1) + 1;
        array_push(star.p_feature[planet], new NewPlanetFeature(P_features.Starship));
        scr_event_log("", "Ancient Starship discovered on " + string(star.name) + " " + scr_roman(planet) + ".", star.name);
    }
}

function ground_mission_leave_it_function() {
    // Not worth it, mang
    obj_controller.menu = 0;
    obj_controller.managing = 0;
    obj_controller.cooldown = 10;
    with (obj_ground_mission) {
        instance_destroy();
    }
    instance_destroy();
}

/// @mixin PlanetData
function discover_artifact_popup(feature) {
    obj_controller.menu = MENU.Default;
    /*if ((planet_type == "Dead" || current_owner == eFACTION.Player)) {
        alarm[4] = 1;
        exit;
    }*/

    var pop = instance_create(0, 0, obj_popup);
    pop.image = "artifact";
    pop.title = "Artifact Located";
    pop.text = $"The Artifact has been located upon {name()}; its condition and class are unlikely to be determined until returned to the ship. What is thy will?";
    pop.target_comp = current_owner;

    if ((origional_owner == 3) && (current_owner > 5)) {
        if (pdf > 0) {
            current_owner = eFACTION.Mechanicus;
        }
    }

    var _take_arti = {
        str1: "Swiftly take the Artifact",
        choice_func: ground_forces_collect_artifact,
    };
    if ((current_owner >= eFACTION.Tyranids) || ((current_owner == eFACTION.Ork) && (pdf <= 0))) {
        pop.add_option([{str1: "Let it be", choice_func: ground_mission_leave_it_function}, _take_arti]);
    } else {
        var _opt1 = "Request audience with the ";
        switch (current_owner) {
            case eFACTION.Player:
            case eFACTION.Imperium:
                _opt1 += "Planetary Governor";
                pop.add_option({
                    str1: "Gift the Artifact to the Sector Commander.",
                    choice_func: function() {
                        gift_artifact(eFACTION.Imperium, false);
                        instance_destroy();
                    },
                });
                break;
            case eFACTION.Mechanicus:
                _opt1 += "Mechanicus";
                pop.add_option({str1: "Let it be.  The Mechanicus' wrath is not lightly provoked.", choice_func: ground_mission_leave_it_function});
                break;
            case eFACTION.Inquisition:
                _opt1 += "Inquisition";
                pop.add_option({choice_func: ground_mission_leave_it_function, str1: "Let it be.  The Inquisition's wrath is not lightly provoked."});
                break;
            case eFACTION.Ecclesiarchy:
                _opt1 += "Ecclesiarchy";
                pop.add_option({
                    str1: "Gift the Artifact to the Ecclesiarchy.",
                    choice_func: function() {
                        gift_artifact(eFACTION.Ecclesiarchy, false);
                        instance_destroy();
                    },
                });
                break;
            case eFACTION.Eldar:
                _opt1 += "Eldar";
                pop.add_option({
                    str1: "Gift the Artifact to the Eldar.",
                    choice_func: function() {
                        gift_artifact(eFACTION.Eldar, false);
                        instance_destroy();
                    },
                });
                break;
            case eFACTION.Tau:
                _opt1 += "Tau";
                pop.add_option({
                    str1: "Gift the Artifact to the Tau Empire.",
                    choice_func: function() {
                        gift_artifact(eFACTION.Tau, false);
                        instance_destroy();
                    },
                });
                break;
        }
        _opt1 += " regarding the Artifact.";
        pop.add_option([{str1: _opt1, choice_func: governor_negotiate_artifact}, _take_arti]);
    }
}

/// @mixin obj_star_select
function planet_selection_action() {
    var xx = __view_get(e__VW.XView, 0) + 0;
    var yy = __view_get(e__VW.YView, 0) + 0;
    if (instance_exists(target)) {
        if (loading) {
            obj_controller.selecting_planet = 0;
        }
        for (var i = 0; i < target.planets; i++) {
            var planet_draw = c_white;
            if (mouse_distance_less(159 + (i * 41), 287, 22)) {
                obj_controller.selecting_planet = i + 1;
                if (p_data.planet != obj_controller.selecting_planet) {
                    delete p_data;
                    p_data = new PlanetData(obj_controller.selecting_planet, target);
                    buttons_selected = false;
                }

                try {
                    p_data.planet_selection_logic();
                } catch (_exception) {
                    handle_exception(_exception);
                    instance_destroy();
                }
            }
            xxx = 159 + (i * 41);
            if (target.craftworld == 0 && target.space_hulk == 0) {
                var sel_plan = i + 1;
                var planet_frame = 0;
                with (target) {
                    planet_frame = scr_planet_image_numbers(p_type[sel_plan]);
                }
                draw_sprite_ext(spr_planets, planet_frame, xxx, 287, 1, 1, 0, planet_draw, 0.9);

                draw_set_color(global.star_name_colors[target.p_owner[sel_plan]]);

                draw_text(xxx, 255, scr_roman(sel_plan));
            }
        }
        if (target.craftworld || target.space_hulk) {
            obj_controller.selecting_planet = 1;
        }
        x = target.x;
        y = target.y;
    }
}

/// @mixin PlanetData
function check_for_stc_grab_mission() {
    // STC Grab
    if (has_feature(P_features.STC_Fragment)) {
        var _techs = 0, _mech_techs = 0;
        var _units = obj_controller.display_unit;
        for (var frag = 0; frag < array_length(_units); frag++) {
            if (obj_controller.man[frag] == "man" && obj_controller.man_sel[frag] == 1) {
                var _unit = _units[frag];
                if (_unit.IsSpecialist(SPECIALISTS_TECHMARINES)) {
                    _techs += 1;
                }
                if (obj_controller.ma_role[frag] == "Techpriest") {
                    _mech_techs += 1;
                }
            }
        }
        var arti = instance_create(system.x, system.y, obj_ground_mission); // Unloading / artifact crap
        arti.num = planet;
        arti.loc = system.name;
        arti.pdata = self;
        arti.managing = obj_controller.managing;
        arti.techs = _techs;
        arti.mech_techs = _mech_techs;
        discover_stc_fragment_popup(_techs, _mech_techs);
        with (arti) {
            setup_planet_mission_group();
        }
    }
}

/// @mixin PlanetData
function discover_stc_fragment_popup(techies, mechanicus_reps) {
    var _owner = current_owner;
    obj_controller.menu = MENU.Default;
    var pop = instance_create(0, 0, obj_popup);
    pop.image = "stc";
    pop.title = "STC Fragment Located";

    var options = [];

    if (_owner == eFACTION.Mechanicus) {
        var _text = $"An STC Fragment upon {name()} appears to be located deep within a Mechanicus Vault";
        if (mechanicus_reps > 0) {
            pop.text = $"{_text}. The present Tech Priests stress they will not condone a mission to steal the STC Fragment.";
        } else if (techies > 0) {
            pop.text = $"{_text}. Taking it may be seen as an act of war. What is thy will?";
            pop.add_option({str1: "Attempt to steal the STC Fragment.", choice_func: remove_stc_from_planet}); // TODO: Fix this option, as it crashes the game when the battle starts);
        } else {
            pop.text = $"{_text}. Taking it may be seen as an act of war. The ground team has no Techmarines, so you have no choice but to leave it be.";
        }
    } else {
        var _text = $"An STC Fragment appears to be located upon {name()}";
        if (techies > 0) {
            array_push(options, {str1: "Swiftly take the STC Fragment.", choice_func: remove_stc_from_planet});
            if (mechanicus_reps == 0) {
                pop.text = $"{_text}; what it might contain is unknown. Your {obj_ini.role[100][16]}s wish to reclaim, identify, and put it to use immediately. What is thy will?";
            } else {
                pop.text = $"{_text}. Your {obj_ini.role[100][16]}s wish to reclaim, identify, and put it to use immediately, and the Tech Priests wish to send it to the closest forge world. What is thy will?";
            }
        } else if (mechanicus_reps > 0) {
            pop.text = $"{_text}; what it might contain is unknown. The present Tech Priests wish to send it to Mars, and refuse to take the device off-world otherwise.";
        } else {
            pop.text = $"{_text}; what it might contain is unknown. The ground team has no {obj_ini.role[100][16]}s or Tech Priests, so you have no choice but to leave it be or notify the Mechanicus about its location.";
        }

        array_push(options, {str1: "Send it to the Adeptus Mechanicuss.", choice_func: send_stc_to_adeptus_mech});
    }
    array_push(options, {str1: "Leave it.", choice_func: ground_mission_leave_it_function});

    pop.add_option(options);
}

/// @mixin PlanetData
function check_for_artifact_grab_mission() {
    if (has_feature(P_features.Artifact)) {
        var artifact = instance_create(system.x, system.y, obj_ground_mission); // Unloading / artifact crap
        artifact.num = planet;
        artifact.loc = obj_controller.selecting_location;
        artifact.managing = obj_controller.managing;
        artifact.pdata = self;
        with (artifact) {
            setup_planet_mission_group();
        }
        discover_artifact_popup(get_features(P_features.Artifact)[0]);
    }
}

/// @mixin obj_ground_mission
function ground_forces_collect_artifact() {
    with (obj_ground_mission) {
        scr_return_ship(pdata.system.name, self, pdata.planet);

        var man_size, ship_id, comp, i;
        i = 0;
        ship_id = 0;
        man_size = 0;
        comp = 0;
        ship_id = get_valid_player_ship("", loc);

        var last_artifact = scr_add_artifact("random", "random", 4, loc, ship_id + 500);

        var i = 0;

        var mission = "bad";
        var mission_roll = irandom(100) + 1;
        if (scr_has_adv("Ambushers")) {
            mission_roll -= 15;
        }
        if (mission_roll <= 60) {
            mission = "good";
        } // 135
        if (pdata.planet_type == "Dead") {
            mission = "good";
        }
        // mission="bad";

        var pop;
        pop = instance_create(0, 0, obj_popup);
        pop.image = "artifact_recovered";
        pop.title = "Artifact Recovered!";

        if (mission == "good") {
            pop.text = $"Your marines quickly converge upon the Artifact and remove it, before local forces have any idea of what is happening.##";
            pop.text += $"It has been stowed away upon {loc}.  It appears to be a {obj_ini.artifact[last_artifact]} but should be brought home and identified posthaste.";
            scr_event_log("", "Artifact has been forcibly recovered.");

            if (pdata.planet_type != "Dead") {
                if (pdata.current_owner == 2) {
                    obj_controller.disposition[2] -= 1;
                }
                if (pdata.current_owner == eFACTION.Mechanicus) {
                    obj_controller.disposition[3] -= 10;
                } // max(obj_controller.disposition/4,10)
                if (pdata.current_owner == 4) {
                    obj_controller.disposition[4] -= max(obj_controller.disposition[4] / 4, 10);
                }
                if (pdata.current_owner == 5) {
                    obj_controller.disposition[5] -= 3;
                }
                if (pdata.current_owner == 8) {
                    obj_controller.disposition[8] -= 3;
                }
            }
        }
        if (mission == "bad") {
            pop.text = "Your marines converge upon the Artifact; resistance is light and easily dealt with.  After a brief firefight the Artifact is retrieved.##";
            pop.text += $"It has been stowed away upon {loc}.  It appears to be a " + string(obj_ini.artifact[last_artifact]) + " but should be brought home and identified posthaste.";
            scr_event_log("red", "Artifact forcibly recovered.  Collateral damage is caused.");

            if (pdata.current_owner == 2) {
                obj_controller.disposition[2] -= 2;
            }
            if (pdata.current_owner == eFACTION.Mechanicus) {
                obj_controller.disposition[3] -= max(obj_controller.disposition[3] / 3, 20);
            }
            if (pdata.current_owner == 4) {
                obj_controller.disposition[4] -= max(obj_controller.disposition[4] / 3, 20);
            }
            if (pdata.current_owner == 5) {
                obj_controller.disposition[5] -= max(obj_controller.disposition[3] / 4, 15);
            }
            if (pdata.current_owner == 6) {
                obj_controller.disposition[6] -= 15;
            }
            if (pdata.current_owner == 8) {
                obj_controller.disposition[8] -= 8;
            }

            if (pdata.current_owner >= 3 && pdata.current_owner <= 6) {
                scr_audience(pdata.current_owner, "artifact_angry",);
            }
        }

        if (scr_has_adv("Tech-Scavengers")) {
            var ex1 = "", ex1_num = 0, ex2 = "", ex2_num = 0, ex3 = "", ex3_num = 0;

            var stah = instance_nearest(x, y, obj_star);

            if (pdata.origional_owner == 2) {
                ex1 = "Meltagun";
                ex1_num = choose(2, 3, 4);
                ex2 = "Flamer";
                ex2_num = choose(2, 3, 4);
                ex3 = choose("Power Fist", "Chainsword", "Bolt Pistol");
                ex3_num = choose(2, 3, 4, 5);
            }
            if (pdata.origional_owner == 3) {
                ex1 = "Plasma Pistol";
                ex1_num = choose(1, 2);
                ex2 = "Power Armour";
                ex2_num = choose(2, 3, 4);
                ex3 = choose("Servo-arm", "Bionics");
                ex3_num = choose(2, 3, 4);
            }
            if (pdata.origional_owner == 5) {
                ex1 = "Flamer";
                ex1_num = choose(3, 4, 5, 6);
                ex2 = "Heavy Flamer";
                ex2_num = choose(1, 2, 3);
                ex3 = choose("Chainsword", "Bolt Pistol");
                ex3_num = choose(2, 3, 4, 5);
            }

            if (ex1 != "") {
                pop.text += "##While they're at it your Battle Brothers also find ";
                if (ex1_num > 0) {
                    pop.text += string(ex1_num) + " " + string(ex1);
                }
                if (ex2_num > 0) {
                    pop.text += ", " + string(ex2_num) + " " + string(ex2);
                }
                if (ex3_num > 0) {
                    pop.text += ", and " + string(ex3_num) + " " + string(ex3);
                }
                pop.text += ".";
                scr_add_item(ex1, ex1_num);
                scr_add_item(ex2, ex2_num);
                scr_add_item(ex3, ex3_num);
            }
        }

        with (obj_star_select) {
            instance_destroy();
        }
        with (obj_fleet_select) {
            instance_destroy();
        }
        pdata.delete_feature(P_features.Artifact);

        corrupt_artifact_collectors(last_artifact);

        obj_controller.trading_artifact = 0;
        clear_diplo_choices();
        obj_controller.menu = 0;
        instance_destroy();
    }
}

function governor_negotiate_artifact() {
    with (obj_ground_mission) {
        if (pdata.current_owner == 2) {
            scr_return_ship(pdata.system.name, self, pdata.planet);

            var i = 0;
            var ship_id = get_valid_player_ship("", loc);

            i = 0;
            plan = instance_nearest(x, y, obj_star);
            var last_artifact = scr_add_artifact("random", "random", 4, pdata.system.name, ship_id + 500);

            obj_popup.image = "artifact_recovered";
            obj_popup.title = "Artifact Recovered!";
            obj_popup.text = $"The Planetary Governor hands over the Artifact without asking for compensation.##It has been safely stowed away upon {loc}.  It appears to be a {obj_ini.artifact[last_artifact]} but should be brought home and identified posthaste.";
            with (obj_star_select) {
                instance_destroy();
            }
            with (obj_fleet_select) {
                instance_destroy();
            }
            pdata.delete_feature(P_features.Artifact);
            with (obj_popup) {
                reset_popup_options();
            }
            scr_event_log("", "Planetary Governor hands over Artifact.");

            corrupt_artifact_collectors(last_artifact);

            obj_controller.trading_artifact = 0;
            instance_destroy();
        } else {
            scr_toggle_diplomacy();
            obj_controller.cooldown = 10;
            obj_controller.diplomacy = pdata.current_owner;
            obj_controller.trading_artifact = 1;
            with (obj_controller) {
                scr_dialogue("artifact");
            }
            instance_destroy();
            instance_destroy(obj_popup);
        }
    }
}

function remove_stc_from_planet() {
    with (obj_ground_mission) {
        var comp, plan, i;
        i = 0;
        comp = 0;
        plan = 0;
        plan = instance_nearest(x, y, obj_star);

        var mission, mission_roll;

        var mission = "bad";
        var mission_roll = floor(random(100)) + 1;

        if (scr_has_adv("Ambushers")) {
            mission_roll -= 15;
        }
        if (pdata.current_owner == eFACTION.Mechanicus) {
            mission_roll += 20;
        }
        if (mission_roll <= 60) {
            mission = "good";
        } // 135
        if (pdata.planet_type == "Dead") {
            mission = "good";
        }
        // mission="bad";

        var pop;
        pop = instance_create(0, 0, obj_popup);
        pop.image = "artifact_recovered";
        pop.title = "STC Recovered!";

        if (pdata.origional_owner != 3 || pdata.planet_type != "Forge") {
            pop.text = "Your forces descend beneath the surface of the planet, delving deep into an ancient tomb.  Automated defenses and locks are breached.##";
            pop.text += "The STC Fragment has been safely stowed away, and is ready to be decrypted or gifted at your convenience.";
            scr_return_ship(pdata.system.name, self, pdata.planet);
        }

        if (mission == "good" && pdata.origional_owner == 3 && pdata.planet_type == "Forge") {
            pop.text = "Your forces descend into the vaults of the Mechanicus Forge, bypassing sentries, automated defenses, and blast doors on the way.##";
            pop.text += "The STC Fragment has been safely recovered and stowed away.  It is ready to be decrypted or gifted at your convenience.";

            /*if (pdata.planet_type!="Dead"){
	        if (pdata.current_owner=2) then obj_controller.disposition[2]-=1;
	        if (pdata.current_owner=eFACTION.Mechanicus) then obj_controller.disposition[3]-=10;// max(obj_controller.disposition/4,10)
	        if (pdata.current_owner=4) then obj_controller.disposition[4]-=max(obj_controller.disposition[4]/4,10);
	        if (pdata.current_owner=5) then obj_controller.disposition[5]-=3;
	        if (pdata.current_owner=8) then obj_controller.disposition[8]-=3;
	    }*/
            scr_return_ship(pdata.system.name, self, pdata.planet);
        }
        if (mission == "bad" && pdata.origional_owner == eFACTION.Mechanicus && pdata.planet_type == "Forge") {
            /*pop.text="Your marines converge upon the STC Fragment; resistance is light and easily dealt with.  After a brief firefight it is retrieved.##";
	    pop.text+="The fragment been safely stowed away, and is ready to be decrypted or gifted at your convenience.";

	    */

            pop.image = "thallax";
            pop.text = "Your forces descend into the vaults of the Mechanicus Forge.  Sentries, automated defenses, and blast doors stand in their way.##";
            pop.text += "Half-way through the mission a small army of Praetorian Servitors and Skitarii bear down upon your men.  The Mechanicus guards seem to be upset.";

            /*if (pdata.current_owner=2) then obj_controller.disposition[2]-=2;*/
            if (pdata.current_owner == eFACTION.Mechanicus) {
                obj_controller.disposition[3] -= 40;
            }
            /*if (pdata.current_owner=4) then obj_controller.disposition[4]-=max(obj_controller.disposition[4]/3,20);
	    if (pdata.current_owner=5) then obj_controller.disposition[5]-=max(obj_controller.disposition[3]/4,15);
	    if (pdata.current_owner=6) then obj_controller.disposition[6]-=15;
	    if (pdata.current_owner=8) then obj_controller.disposition[8]-=8;*/

            if (pdata.current_owner > 3 && pdata.current_owner <= 6) {
                scr_audience(pdata.current_owner, "artifact_angry",);
            }
            if (pdata.current_owner == eFACTION.Mechanicus && obj_controller.faction_status[eFACTION.Mechanicus] != "War") {
                scr_audience(pdata.current_owner, "declare_war", -20);
            }

            // Start battle
            pop.battle_special = 3.1;
            obj_controller.trading_artifact = 0;
            clear_diplo_choices();
            obj_controller.menu = 0;

            pop.loc = pdata.system.name;
            pop.planet = pdata.planet;

            exit;
        }

        if (scr_has_adv("Tech-Scavengers")) {
            var ex1, ex1_num, ex2, ex2_num, ex3, ex3_num;
            ex1 = "";
            ex1_num = 0;
            ex2 = "";
            ex2_num = 0;
            ex3 = "";
            ex3_num = 0;

            var stah;
            stah = instance_nearest(x, y, obj_star);

            if (pdata.origional_owner == 2) {
                ex1 = "Meltagun";
                ex1_num = choose(2, 3, 4);
                ex2 = "Flamer";
                ex2_num = choose(2, 3, 4);
                ex3 = choose("Power Fist", "Chainsword", "Bolt Pistol");
                ex3_num = choose(2, 3, 4, 5);
            }
            if (pdata.origional_owner == eFACTION.Mechanicus) {
                ex1 = "Plasma Pistol";
                ex1_num = choose(1, 2);
                ex2 = "Power Armour";
                ex2_num = choose(2, 3, 4);
                ex3 = choose("Servo-arm", "Bionics");
                ex3_num = choose(2, 3, 4);
            }
            if (pdata.origional_owner == 5) {
                ex1 = "Flamer";
                ex1_num = choose(3, 4, 5, 6);
                ex2 = "Heavy Flamer";
                ex2_num = choose(1, 2, 3);
                ex3 = choose("Chainsword", "Bolt Pistol");
                ex3_num = choose(2, 3, 4, 5);
            }

            if (ex1 != "") {
                pop.text += "##While they're at it your Battle Brothers also find ";
                if (ex1_num > 0) {
                    pop.text += string(ex1_num) + " " + string(ex1);
                }
                if (ex2_num > 0) {
                    pop.text += ", " + string(ex2_num) + " " + string(ex2);
                }
                if (ex3_num > 0) {
                    pop.text += ", and " + string(ex3_num) + " " + string(ex3);
                }
                pop.text += ".";
                scr_add_item(ex1, ex1_num);
                scr_add_item(ex2, ex2_num);
                scr_add_item(ex3, ex3_num);
            }
        }

        with (obj_star_select) {
            instance_destroy();
        }
        with (obj_fleet_select) {
            instance_destroy();
        }
        pdata.delete_feature(P_features.STC_Fragment);
        scr_add_stc_fragment(); // STC here

        obj_controller.trading_artifact = 0;
        clear_diplo_choices();
        obj_controller.menu = 0;
        instance_destroy();

        /* */
        /*  */
    }
    instance_destroy();
}

function recieve_artifact_in_discussion() {
    scr_return_ship(loc, self, num);

    var man_size, comp, plan, i;
    i = 0;
    man_size = 0;
    comp = 0;
    plan = 0;
    var ship_id = get_valid_player_ship("", loc);
    plan = instance_nearest(x, y, obj_star);
    var last_artifact = scr_add_artifact("random", "random", 4, loc, ship_id + 500);

    var pop = instance_create(0, 0, obj_popup);
    pop.image = "artifact_recovered";
    pop.title = "Artifact Recovered!";
    pop.text = $"The Artifact has been safely stowed away upon {loc}.  It appears to be a {obj_ini.artifact[last_artifact]} but should be brought home and identified posthaste.";
    with (obj_star_select) {
        instance_destroy();
    }
    with (obj_fleet_select) {
        instance_destroy();
    }
    delete_features(plan.p_feature[num], P_features.Artifact);
    scr_event_log("", "Artifact recovered.");

    corrupt_artifact_collectors(last_artifact);

    obj_controller.trading_artifact = 0;
    clear_diplo_choices();
    instance_destroy();
}

function send_stc_to_adeptus_mech() {
    with (obj_ground_mission) {
        var _target_planet;
        _target_planet = instance_nearest(x, y, obj_star);
        pdata.delete_feature(P_features.STC_Fragment);

        scr_return_ship(pdata.system.name, self, pdata.planet);

        with (obj_star_select) {
            instance_destroy();
        }
        with (obj_fleet_select) {
            instance_destroy();
        }

        scr_toggle_diplomacy();
        obj_controller.diplomacy = 3;
        obj_controller.force_goodbye = 5;

        if (obj_controller.disposition[3] <= 10) {
            obj_controller.disposition[3] += 5;
        }
        if ((obj_controller.disposition[3] > 10) && (obj_controller.disposition[3] <= 30)) {
            obj_controller.disposition[3] += 7;
        }
        if ((obj_controller.disposition[3] > 30) && (obj_controller.disposition[3] <= 50)) {
            obj_controller.disposition[3] += 9;
        }
        if (obj_controller.disposition[3] > 50) {
            obj_controller.disposition[3] += 11;
        }

        with (obj_controller) {
            scr_dialogue("stc_thanks");
        }

        with (obj_temp2) {
            instance_destroy();
        }
        with (obj_temp7) {
            instance_destroy();
        }

        if (obj_ini.fleet_type == ePlayerBase.home_world) {
            with (obj_star) {
                if ((owner == eFACTION.Player) && ((p_owner[1] == 1) || (p_owner[2] == eFACTION.Player))) {
                    instance_create(x, y, obj_temp2);
                }
            }
        }
        if (obj_ini.fleet_type != ePlayerBase.home_world) {
            with (obj_p_fleet) {
                // Get fleet star system
                if ((capital_number > 0) && (action == "")) {
                    instance_create(instance_nearest(x, y, obj_star).x, instance_nearest(x, y, obj_star).y, obj_temp2);
                }
                if ((frigate_number > 0) && (action == "")) {
                    instance_create(instance_nearest(x, y, obj_star).x, instance_nearest(x, y, obj_star).y, obj_temp7);
                }
            }
        }

        if (obj_ini.fleet_type != ePlayerBase.home_world) {
            with (obj_p_fleet) {
                if (action == "") {
                    instance_deactivate_object(instance_nearest(x, y, obj_star));
                }
            }
        }

        var _enemy_fleet;
        var _target = -1;

        if (instance_exists(obj_temp2)) {
            _target = nearest_star_with_ownership(obj_temp2.x, obj_temp2.y, obj_controller.diplomacy);
        } else if (instance_exists(obj_temp7)) {
            _target = nearest_star_with_ownership(obj_temp7.x, obj_temp7.y, obj_controller.diplomacy);
        } else if ((!instance_exists(obj_temp2)) && (!instance_exists(obj_temp7)) && instance_exists(obj_p_fleet) && (obj_ini.fleet_type == ePlayerBase.home_world)) {
            // If player fleet is flying about then get their target for new target
            with (obj_p_fleet) {
                var pop;
                if ((capital_number > 0) && (action != "")) {
                    pop = instance_create(action_x, action_y, obj_temp2);
                    pop.action_eta = action_eta;
                }
                if ((frigate_number > 0) && (action != "")) {
                    pop = instance_create(action_x, action_y, obj_temp7);
                    pop.action_eta = action_eta;
                }
            }
        }

        if (is_struct(_target)) {
            _enemy_fleet = instance_create(_target.x, _target.y, obj_en_fleet);

            _enemy_fleet.owner = obj_controller.diplomacy;
            _enemy_fleet.home_x = _target.x;
            _enemy_fleet.home_y = _target.y;
            _enemy_fleet.sprite_index = spr_fleet_mechanicus;

            _enemy_fleet.image_index = 0;
            _enemy_fleet.capital_number = 1;
            _enemy_fleet.trade_goods = "Requisition!500!|";

            if (obj_ini.fleet_type != ePlayerBase.home_world) {
                if (instance_exists(obj_temp2)) {
                    _enemy_fleet.action_x = obj_temp2.x;
                    _enemy_fleet.action_y = obj_temp2.y;
                    _enemy_fleet.target = instance_nearest(_enemy_fleet.action_x, _enemy_fleet.action_y, obj_p_fleet);
                }
                if ((!instance_exists(obj_temp2)) && instance_exists(obj_temp7)) {
                    _enemy_fleet.action_x = obj_temp7.x;
                    _enemy_fleet.action_y = obj_temp7.y;
                    _enemy_fleet.target = instance_nearest(_enemy_fleet.action_x, _enemy_fleet.action_y, obj_p_fleet);
                }
            }
            if (obj_ini.fleet_type == ePlayerBase.home_world) {
                _target = instance_nearest(_enemy_fleet.x, _enemy_fleet.y, obj_temp2);
                _enemy_fleet.action_x = _target.x;
                _enemy_fleet.action_y = _target.y;
            }

            with (_enemy_fleet) {
                set_fleet_movement();
            }
        }

        instance_activate_all();
        with (obj_temp2) {
            instance_destroy();
        }
        with (obj_temp7) {
            instance_destroy();
        }
        instance_destroy();
    }
}
