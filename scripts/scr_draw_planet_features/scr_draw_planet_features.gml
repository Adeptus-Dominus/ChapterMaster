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

    draw_planet_features = function(xx, yy) {
        draw_set_halign(fa_center);
        draw_set_font(fnt_40k_14);
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
        var generic = false;
        var title = "";
        var body = "";
        var _button_tooltip = "";
        draw_set_color(c_green);
        if (point_and_click(draw_unit_buttons([xx + 12, yy + 20], "<---", [1, 1], c_red))) {
            exit_sequence = true;
        }
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
                body = $"Unload a {obj_ini.player_role_data[eROLE.TECHMARINE].role} and whatever entourage you deem necessary to recover the STC Fragment";
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
                    body = $"For as long as this Stronghold stands the orks here will continue to fortify it. The larger it gets the greater the capacity of this planet to produce orkish machines of war and ships and the better protected the ork forces will be from bombardment";
                } else {
                    body = "Without a force of orks to hold it together the fortress is slowly pulled apart from within by the inhabitants, It's capabilities will constantly decrease until soon there will be nothing left";
                }
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
                feature.draw_data = {
                    x1 :xx,
                    y1 : yy,
                    w : area_width,
                }
                feature.planet_draw_feature_selected();
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
