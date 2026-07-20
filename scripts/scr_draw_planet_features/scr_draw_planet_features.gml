// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

/// @param {Struct.NewPlanetFeature|Struct.PlayerForge} _feature
function FeatureSelected(_feature, _system, _planet) constructor {
    feature = _feature;
    main_slate = new DataSlateMKTwo();
    exit_sequence = false;
    entrance_sequence = true;
    remove = false;
    destroy = false;
    exit_count = 0;
    enter_count = 18;
    planet_data = _system.get_planet_data(_planet);

    if (feature.f_type == eP_FEATURES.FORGE) {
        var _worker_caps = [
            2,
            4,
            8,
        ];
        worker_capacity = _worker_caps[feature.size - 1];
        techs = collect_role_group(SPECIALISTS_TECHS, obj_star_select.target.name);
        feature.techs_working = 0;
        for (var i = 0; i < array_length(techs); i++) {
            var _cur_tech = techs[i];
            if (_cur_tech.assignment() == "forge") {
                if (_cur_tech.job.planet == planet_data.planet) {
                    feature.techs_working++;
                    if (feature.techs_working == worker_capacity) {
                        break;
                    }
                }
            }
        }
    }

    // Mission status snapshot (computed once per panel open, like the Forge tech
    // count above): who is actually on site for an active governor mission, so the
    // panel can say IN PROGRESS / STOPPED instead of leaving the player guessing.
    mission_units_on_site = -1;
    mission_units_needed = 0;
    mission_garrison_ok = undefined;
    if ((feature.f_type == eP_FEATURES.MISSION)
    && variable_struct_exists(feature, "stage") && (feature.stage == "active")) {
        switch (feature.problem) {
            case "hunt_beast":
                mission_units_needed = 3;
                mission_units_on_site = array_length(collect_role_group("all", [planet_data.system.name, planet_data.planet, 0], false, {"job": "hunt_beast"}));
                break;
            case "train_forces":
                mission_units_needed = 1;
                mission_units_on_site = array_length(collect_role_group("all", [planet_data.system.name, planet_data.planet, 0], false, {"job": "train_forces"}));
                break;
            case "provide_garrison":
                if (is_struct(planet_data.garrisons)) {
                    planet_data.garrisons.update();
                    mission_garrison_ok = planet_data.garrisons.garrison_force ? true : false;
                }
                break;
        }
    }

    draw_planet_features = function(xx, yy) {
        draw_set_halign(fa_center);
        draw_set_font(fnt_40k_14);
        //draw_sprite(spr_planet_screen,0,xx,yy);
        if (exit_sequence) {
            xx -= 25 * exit_count;
            main_slate.draw(xx, yy, 1.38, 1.38);
            exit_count++;
            if (xx - 25 <= obj_star_select.main_data_slate.XX) {
                remove = true;
            }
        } else if (entrance_sequence) {
            enter_count--;
            xx -= 25 * enter_count;
            if (enter_count == 1) {
                entrance_sequence = false;
            }
            main_slate.draw(xx, yy, 1.38, 1.38);
        } else {
            main_slate.draw(xx, yy, 1.4, 1.4);
        }
        var area_width = main_slate.width;
        var area_height = main_slate.height;
        var generic = false;
        var title = "", body = "";
        var _button_tooltip = "";
        //draw_glow_dot(xx+150, yy+150);
        //rack_and_pinion(xx+230, yy+170);
        var rectangle = [];
        draw_set_color(c_green);
        if (point_and_click(draw_unit_buttons([xx + 12, yy + 20], "<---", [1, 1], c_red))) {
            exit_sequence = true;
        }
        draw_set_halign(fa_center);
        switch (feature.f_type) {
            case eP_FEATURES.FORGE:
                draw_text_transformed(xx + (area_width / 2), yy + 10, "Chapter Forge", 2, 2, 0);
                draw_set_halign(fa_left);
                draw_set_color(c_gray);

                draw_text(xx + 10, yy + 50, $"Working Techs : {feature.techs_working}/{worker_capacity}");
                if (point_and_click(draw_unit_buttons([xx + 10, yy + 70], "Assign To Forge", [1, 1], c_red))) {
                    obj_controller.unit_profile = false;
                    obj_controller.view_squad = false;
                    group_selection(techs, {purpose: "Forge Assignment", purpose_code: "forge_assignment", number: worker_capacity, system: planet_data.system, feature: feature, planet: planet_data.planet, selections: []});
                    destroy = true;
                }
                //TODO move over to using the draw button object ot streamline this
                var next_position = [
                    xx + 10,
                    yy + 95,
                ];
                if (feature.size < 3) {
                    var upgrade_cost = 2000 * feature.size;
                    var last_button = draw_unit_buttons(next_position, $"Upgrade Forge ({upgrade_cost} req)", [1, 1], c_red);
                    next_position = [
                        last_button[0],
                        last_button[3],
                    ];
                    if (point_and_click(last_button) && obj_controller.requisition >= upgrade_cost) {
                        obj_controller.requisition -= upgrade_cost;
                        feature.size++;
                        worker_capacity *= 2;
                    }
                }
                if (feature.size > 1 && !feature.vehicle_hanger) {
                    var upgrade_cost = 3000;
                    var build_coords = draw_unit_buttons(next_position, $"Build Vehicle Hanger({upgrade_cost} req)", [1, 1], c_red);
                    if (scr_hit(build_coords)) {
                        tooltip_draw("Required to Build Vehicles in the Forge");
                    }
                    if (point_and_click(build_coords) && obj_controller.requisition >= upgrade_cost) {
                        feature.vehicle_hanger = 1;
                        obj_controller.requisition -= upgrade_cost;
                        array_push(obj_controller.player_forge_data.vehicle_hanger, [obj_controller.selected.name, planet_data.planet]);
                    }
                } else if (feature.vehicle_hanger) {
                    draw_text(next_position[0], next_position[1], "Forge has a vehicle hanger");
                    //TODO somthing if the forge has a hanger
                }
                break;
            case eP_FEATURES.NECRON_TOMB:
                generic = true;
                if (feature.awake == 0 && feature.sealed == 0) {
                    title = "Dormant Necron Tomb";
                    body = "Scans indicate a Necron Tomb lies hidden under the surface of the planet, all signs indicate the tombis dormant as we must hope it remains";
                } else if (feature.sealed) {
                    title = "Sealed Necron Tomb";
                    body = "Exterminatus and standard imperial armaments are no proof against the Necron Scourge with any luck those sealed within this tomb will remain there";
                } else if (feature.awake) {
                    title = "Awake Tomb";
                    body = "The Cursed ranks of living metal spew forth from the Necron tomb below";
                }
                break;
            case eP_FEATURES.ARTIFACT:
                generic = true;
                title = "Unknown Artifact";
                body = "Unload Marines onto the planet to search for the artifact";
                break;
            case eP_FEATURES.ANCIENT_RUINS:
                generic = true;
                title = "Ancinet Ruins";
                body = "Unload Marines onto the planet to explore the ruins";
                break;
            case eP_FEATURES.STC_FRAGMENT:
                generic = true;
                title = "STC Fragment";
                body = $"Unload a {obj_ini.role[100][16]} and whatever entourage you deem necessary to recover the STC Fragment";
                break;
            case eP_FEATURES.GENE_STEALER_CULT:
                generic = true;
                var cult_control = planet_data.population_influences[eFACTION.TYRANIDS];
                title = $"Cult of {feature.name}";
                var control_string = "";
                if (cult_control < 25) {
                    control_string = "currently has limited influence on the planet but is fast gaining speed";
                } else if (cult_control < 50) {
                    control_string = "Is rapidly gaining momentum with the planets populace and will soon sieze control of the planet if left unchecked";
                } else if (cult_control < 75) {
                    control_string = "Has managed to galvanise the populace to overcome the former governor of the planet turning much of the local pdf to it's cause, it must be stopped, lest it spread.";
                } else {
                    control_string = "The cult’s rot and control of the planet is complete; even if the cult can be dismantled, the corruption is great and the population will need significant purging and monitoring to remove the taint";
                }
                body = $"The Cult of {feature.name} {control_string}";
                break;
            case eP_FEATURES.VICTORY_SHRINE:
                draw_text_transformed(xx + (area_width / 2), yy + 10, "Victory Shrine", 2, 2, 0);
                draw_set_halign(fa_left);
                draw_set_color(c_gray);
                /*if (!feature.parade){
					if (point_and_click(draw_unit_buttons([xx+10, yy+70], "Parade (500 req)",[1,1],c_red))){
						obj_controller.requisition-=500;
						feature.forge=1;
						feature.forge_data = new PlayerForge();
					}
				}*/
                break;
            case eP_FEATURES.MONASTERY:
                draw_text_transformed(xx + (area_width / 2), yy + 10, feature.name, 2, 2, 0);
                if (feature.forge == 0) {
                    draw_text_transformed(xx + 80, yy + 50, "Forge", 1, 1, 0);
                    if (draw_building_builder(xx + 40, yy + 70, 500, spr_forge_holo)) {
                        obj_controller.requisition -= 500;
                        feature.forge = 1;
                        feature.forge_data = new PlayerForge();
                    }
                }
                break;
            case eP_FEATURES.ORKSTRONGHOLD:
                title = "Ork Stronghold";
                generic = true;
                if (planet_data.planet_forces[eFACTION.ORK]) {
                    var _clan_line = "";
                    if (planet_race_pop(planet_data.system, planet_data.planet, eFACTION.ORK) > 0) {
                        _clan_line = "This WAAAGH is led by the " + ork_clan_summary(planet_data.system, planet_data.planet) + ". ";
                    }
                    body = _clan_line + $"For as long as this Stronghold stands the orks here will continue to fortify it. The larger it gets the greater the capacity of this planet to produce orkish machines of war and ships and the better protected the ork forces will be from bombardment";
                } else {
                    body = "Without a force of orks to hold it together the fortress is slowly pulled apart from within by the inhabitants, It's capabilities will constantly decrease until soon there will be nothing left";
                }
                break;
            case eP_FEATURES.FUNGAL_BLOOM:
                title = "Fungal Bloom";
                generic = true;
                var _bloom_orks = planet_race_pop(planet_data.system, planet_data.planet, eFACTION.ORK);
                body = "";
                if (_bloom_orks > 0) {
                    body = $"++GREENSKIN HORDE: {_bloom_orks}++\n\n";
                }
                body += "The density of the fungal flora here is enough to sustain a great number of orks. Spores hang thick on every wind, and where they settle squigs, grots and boyz erupt from the loam faster than any bombardment can burn them back. Left unchecked, the bloom swells into a full WAAAGH.";
                body += "\n\nRemoval: a Cleanse by Fire purge torches the spore-bed, destroying the bloom and most of the horde with it. A large bloom leaves a burnt-out remnant that a second Cleanse by Fire or a ground assault finishes. Standard bombardment cannot burn it back faster than it grows.";
                break;
            case eP_FEATURES.ASCENSION_BEACON:
                title = "Ascension Beacon";
                generic = true;
                body = "The Genestealer Cult has fulfilled its purpose. A psychic beacon screams into the warp, and the Hive Fleet answers. Spores rain from a darkening sky and the world's own biomass is devoured and reborn as the Great Devourer's brood — Termagants, Warriors, monstrous beasts. Every living thing here is now food or fuel for the swarm. Destroy the beacon, or the whole world is consumed.";
                break;
            case eP_FEATURES.HERETIC_ACTIVITY:
                title = "Heretic Activity";
                generic = true;
                body = "Whispers of the Dark Gods have taken root here. A heretic cult festers in the under-hive and the shadowed places — its true numbers unknown, its leaders hidden among the loyal populace. It will not tip its hand until it believes it can win. A strong garrison may uncover and purge it before it rises; but let your grip slip and it will erupt into open revolt.";
                break;
            case eP_FEATURES.RECRUITING_WORLD:
                generic = true;
                var _planet = planet_data.planet;
                var _star = obj_star_select.target;
                var p_data = _star.get_planet_data(_planet);
                var _recruit_world = p_data.get_features(eP_FEATURES.RECRUITING_WORLD)[0];
                var _spare_apoth_points = p_data.get_local_apothecary_points();
                title = "Marine Recruitment";
                body = $"There are {_spare_apoth_points} apothecary rescource points available for recruit screening,\n\n";
                var _recruit_find_chance = find_recruit_success_chance(_spare_apoth_points, _star, _planet, 1);

                body += $"There is a {_recruit_find_chance * 100}% of producing a successful recruit this month on the basis of the available apothecary time to screen candidates and the chances of the aspirants passing their trials to an acceptable standard,\n\n";

                if ((obj_controller.faction_status[p_data.current_owner] == "War" || obj_controller.faction_status[p_data.current_owner] == "Antagonism") && (p_data.player_disposition <= 50)) {
                    // TODO LOW RECRUITING_DIALOG // Make this more dynamic.
                    if (_recruit_world.recruit_type == 0) {
                        body += "Since our relations with the populations' faction are... strained, we are having to do our recruiting operation covertly,\n\n";
                    } else {
                        body += "Since our relations with the populations' faction are... strained, we are having to do our recruiting operation covertly,";
                        body += " our brothers are authorized to use more extreme methods of recruitment,\n\n";
                    }
                } else if (obj_controller.faction_status[p_data.current_owner] == "War" || obj_controller.faction_status[p_data.current_owner] == "Antagonism") {
                    if (_recruit_world.recruit_type == 0) {
                        body += "The population has grown accustomed to us and their Governor has given us the clear to openly recruit,\n\n";
                    } else {
                        body += "The population has grown accustomed to us and their Governor has given us the clear to openly recruit,";
                        body += " however our brothers are still authorized to use more extreme methods of recruitment regardless,\n\n";
                    }
                } else if (_recruit_world.recruit_type == 1) {
                    body += "We've authorized our brothers to use more extreme methods of recruitment, should we really allow this Milord?\n\n";
                }

                if (p_data.player_disposition < 100) {
                    body += "To increase recruit success chance more apothecaries will be required on the planet surface, we could also deploy garrisons to make the population more friendly to our chapter.";
                } else {
                    body += "To increase recruit success chance more apothecaries will be required on the planet surface.";
                }
                break;
            case eP_FEATURES.MISSION:
                var mission_description = $"";
                var planet_name = planet_numeral_name(planet_data.planet, obj_star_select.target);
                var button_text = "none";
                var button_function = "none";
                var help = "none";
                switch (feature.problem) {
                    case "provide_garrison":
                        var reason;
                        if (feature.reason == "importance") {}
                        // The requirement here used to be vague ("capable of conducting
                        // himself in a diplomatic manner"). The actual mechanics: the
                        // garrison's leader is the most senior squad leader among the
                        // garrisoned squads (rank does not gate the mission, it only
                        // decides who is tested); the disposition outcome keys off the
                        // leader having the Honorable trait, and a separate wisdom test
                        // (siege specialists excel) can add fortifications.
                        mission_description = $"The governor of {planet_name} has requested a force of marines might stay behind following your departure.\n\nAssign squads to Garrison Duty on this world to initiate the mission. Any squads qualify; the outcome rests on the garrison's leader, the most senior squad leader among those garrisoned. An Honorable leader will secure the diplomatic gains, while a leader lacking the trait risks incidents that sour relations. A wise leader (siege specialists excel) may also leave the world better fortified.\n\nThe agreed term runs 10-16 months; if it ends with no garrison on the world, the governor takes offence (disposition -20).";

                        break;
                    case "join_communion":
                        mission_description = $"The governor of {planet_name} has Invited a delegate of your forces to take part in ceremony.\n\nNo mission is attached to this request yet; it lapses on its own timer.";
                        break;
                    case "hunt_beast":
                        mission_description = $"The governor of {planet_name} has bemoaned the raiding of huge beasts on the fringes of the planets largest city, the numbers have swelled recently and are causing huge damage to the planets small economy. You could send a force to intervene, it would provide a fine test of metal for any that partake.\n\nMission requirements: assign up to 3 marines via Send Hunters; they unload to the surface and must remain on the world until the hunt concludes (2-5 months). Each hunter faces a weapon-skill test against the beasts: success forges a Beast Slayer, failure risks injury or death. A single success is enough to carry the mission.";
                        help = "This is a good opportunity to provide experience and training, having at least one marine with experience in such matters would be advisable";
                        button_text = "Send Hunters";
                        button_function = function() {
                            var dudes = collect_role_group("all", obj_star_select.target.name);
                            group_selection(dudes, {purpose: "Beast Hunt", purpose_code: feature.problem, number: 3, system: planet_data.system, feature: obj_star_select.feature, planet: planet_data.planet, array_slot: feature.array_position, selections: []});
                            destroy = true;
                        };
                        break;
                    case "protect_raiders":
                        mission_description = $"The governor of {planet_name} has sent many requests to the sector commander for help with defending against xenos raids on the populace of the planet, the reports seem to suggest the xenos in question are in fact dark eldar.\n\nMission requirements: one squad, resolved immediately on assignment. The squad's wisdom and dexterity decide the ambush (the Ambushers chapter advantage helps), and the squad leader carries the result.";
                        help = "Set a squad to ambush";
                        button_text = "Send Squad";
                        _button_tooltip = "milage may vary on playability of this mission progress at your own risk";
                        button_function = function() {
                            var dudes = collect_role_group("all", obj_star_select.target.name);
                            group_selection(dudes, {purpose: "Select Squad for Ambush", purpose_code: feature.problem, number: 1, system: planet_data.system, feature: obj_star_select.feature, planet: planet_data.planet, array_slot: feature.array_position, select_type: eMISSION_SELECT_TYPE.SQUADS, selections: []});
                            destroy = true;
                        };
                        break;
                    case "train_forces":
                        mission_description = $"The governor of {planet_name} fears the planet will not hold in the case of major incursion, it has not seen war in some time and he fears the ineptitude of the commanders available, he asks for aid in planning a thorough plan for defense and schedule of works for a period of at least 6 months.\n\nMission requirements: assign one officer (captain candidates are listed); he unloads to the surface for 3-12 months and must remain there. The outcome rests on his wisdom: siege masters and natural leaders excel, brutes struggle, and a Tyrannic War veteran may even root out a hidden genestealer cult while he works. Sending a full Captain pleases the governor immediately (disposition +3).";
                        help = $"A task best suited to the more knowledgable or wise of your Commanders";
                        button_text = "Assign Officer";
                        button_function = function() {
                            var dudes = collect_role_group(SPECIALISTS_CAPTAIN_CANDIDATES, obj_star_select.target.name);
                            group_selection(dudes, {purpose: "Select Officer", purpose_code: feature.problem, number: 1, system: planet_data.system, feature: obj_star_select.feature, planet: planet_data.planet, array_slot: feature.array_position, selections: []});
                            destroy = true;
                        };
                        break;
                    case "Purge_enemies":
                        mission_description = $"The governor of {planet_name} has expressed his distaste of the neighboring governance of {target.name} {feature.target} he has expressed his views that they engage in heretical ways and harbor xenos enemies though in truth it is more likely that he simply wishes his political enemies disposed of, whatever the case his planet has great economic means and he has made bare his plans to compensate the emperors angels for their aid\n\nNo mission is attached to this request yet; it lapses on its own timer.";
                        break;
                }
                draw_text_transformed(xx + (area_width / 2), yy + 5, mission_name_key(feature.problem), 2, 2, 0);
                draw_set_halign(fa_left);
                draw_set_color(c_gray);
                // Initiated missions are clearly marked so the player knows the
                // assignment registered and the clock is running (mission structs flip
                // stage from "preliminary" to "active" in their init functions).
                // STOPPED means the mission is active but the force that carries it is
                // gone (dead, moved, or the garrison withdrawn); the completion checks
                // will find nobody and the mission fails or lapses.
                if (variable_struct_exists(feature, "stage") && (feature.stage == "active")) {
                    var _status = "++MISSION IN PROGRESS++";
                    var _stopped = false;
                    switch (feature.problem) {
                        case "hunt_beast":
                            if (mission_units_on_site <= 0) {
                                _stopped = true;
                                _status = "++MISSION STOPPED: NO HUNTERS ON SITE++";
                            } else {
                                _status += $"\nHunters on site: {mission_units_on_site}/{mission_units_needed}";
                            }
                            break;
                        case "train_forces":
                            if (mission_units_on_site <= 0) {
                                _stopped = true;
                                _status = "++MISSION STOPPED: NO OFFICER ON SITE++";
                            } else {
                                _status += "\nOfficer on site";
                            }
                            break;
                        case "provide_garrison":
                            if (mission_garrison_ok == false) {
                                _stopped = true;
                                _status = "++MISSION STOPPED: NO GARRISON ON THE WORLD++\nIf the agreed term ends without a garrison, the governor takes offence (disposition -20).";
                            } else if (mission_garrison_ok == true) {
                                _status += "\nGarrison in place";
                            }
                            break;
                    }
                    // Months remaining come from the mission timer slot.
                    if (!_stopped && variable_struct_exists(feature, "array_position")) {
                        var _t_star = planet_data.system;
                        var _t_planet = planet_data.planet;
                        var _t_slot = feature.array_position;
                        if ((_t_planet < array_length(_t_star.p_timer))
                        && (_t_slot >= 0) && (_t_slot < array_length(_t_star.p_timer[_t_planet]))) {
                            var _months = _t_star.p_timer[_t_planet][_t_slot];
                            if (_months > 0) {
                                _status += $"\n{_months} months remain";
                            }
                        }
                    }
                    mission_description = _status + "\n\n" + mission_description;
                }
                draw_text_ext(xx + 10, yy + 40, mission_description, -1, area_width - 20);
                var text_body_height = string_height_ext(string_hash_to_newline(mission_description), -1, area_width - 20);
                if (help != "none") {
                    draw_text_ext(xx + 10, yy + 40 + text_body_height + 10, help, -1, area_width - 20);
                    text_body_height += string_height_ext(string_hash_to_newline(mission_description), -1, area_width - 20) + 10;
                }

                if (button_text != "none") {
                    var _button = draw_unit_buttons([xx + ((area_width / 2) - (string_width(button_text) / 2)), yy + 40 + text_body_height + 10], button_text);
                    if (_button_tooltip != "" && scr_hit(_button)) {
                        tooltip_draw(_button_tooltip);
                    }
                    if (point_and_click(_button)) {
                        if (is_callable(button_function)) {
                            button_function();
                            destroy = true;
                        } else {
                            tooltip_draw("no implemented function");
                        }
                    }
                }
                break;
        }
        if (generic) {
            draw_text_ext_transformed(xx + (area_width / 2), yy + 5, title, -1, area_width - 20, 2, 2, 0);

            draw_set_halign(fa_left);
            draw_set_color(c_gray);
            draw_text_ext(xx + 10, yy + 40, body, -1, area_width - 20);
        }
        return "done";
    };
}
