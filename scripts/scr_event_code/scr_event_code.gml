function add_event(event_data) {
    var _inserted = false;
    if (!struct_exists(event_data, "duration")) {
        event_data.duration = 1;
    }
    for (var i = 0; i < array_length(obj_controller.event); i++) {
        var _event = obj_controller.event[i];
        if (_event.duration >= event_data.duration) {
            array_insert(obj_controller.event, i, event_data);
            _inserted = true;
            break;
        }
    }
    if (!_inserted) {
        array_push(obj_controller.event, event_data);
    }
}

function find_event(e_id) {
    var _event_found = -1;
    for (var i = 0; i < array_length(obj_controller.event); i++) {
        var _event = obj_controller.event[i];
        if (_event.e_id == e_id) {
            _event_found = i;
            break;
        }
    }
    return _event_found;
}

function event_end_turn_action() {
    var _event_length = array_length(event);
    for (var i = _event_length - 1; i >= 0; i--) {
        var _event = event[i];
        if (_event.e_id == "" || _event.duration < 0) {
            array_delete(event, i, 1);
            continue;
        }

        _event.duration -= 1;

        if (_event.duration == 0) {
            if (_event.e_id == "game_over_man") {
                obj_controller.alarm[8] = 1;
            }
            // Removes planetary governor installed by the chapter
            if (_event.e_id == "remove_surf") {
                var _star_name = _event.system;
                var _event_star = star_by_name(_event.system);
                var _planet = _event.planet;
                if (_event_star != "none") {
                    _event_star.dispo[_planet] = -10; // Resets
                    var twix = $"Inquisition executes Chapter Serf in control of {pllanet_numera_name(planet, _event_star)} and installs a new Planetary Governor.";
                    if (_event_star.p_owner[_planet] == eFACTION.Player) {
                        _event_star.p_owner[_planet] = _event_star.p_first[_planet];
                    }
                    scr_alert("", "", twix, 0, 0);
                    scr_event_log("", twix, _star_name);
                }
            } else if (_event.e_id == "enemy_imperium") {
                // Changes relation to good
                scr_alert("green", "enemy", "You have made amends with your enemy in the Imperium.", 0, 0);
                disposition[eFACTION.Imperium] += 20;
                scr_event_log("", "Amends made with Imperium.");
            } else if (_event.e_id == "enemy_mechanicus") {
                scr_alert("green", "enemy", "You have made amends with your Mechanicus enemy.", 0, 0);
                disposition[eFACTION.Mechanicus] += 20;
                scr_event_log("", "Amends made with Mechanicus enemy.");
            } else if (_event.e_id == "enemy_inquisition") {
                scr_alert("green", "enemy", "You have made amends with your enemy in the Inquisition.", 0, 0);
                disposition[eFACTION.Inquisition] += 20;
                scr_event_log("", "Amends made with Inquisition enemy.");
            } else if (_event.e_id == "enemy_ecclesiarchy") {
                scr_alert("green", "enemy", "You have made amends with your enemy in the Ecclesiarchy.", 0, 0);
                disposition[eFACTION.Ecclesiarchy] += 20;
                scr_event_log("", "Amends made with Ecclesiarchy enemy.");
            } else if (_event.e_id == "imperium_daemon") {
                // Sector commander losses its mind
                var alert_string = $"Sector Commander {faction_leader[eFACTION.Imperium]} has gone insane.";
                scr_alert("red", "lol", alert_string, 0, 0);
                faction_defeated[eFACTION.Imperium] = 1;
                scr_event_log("red", alert_string);
            }
            // Starts chaos invasion
            if (_event.e_id == "chaos_invasion") {
                var xx = 0, yy = 0, flee = 0, dirr = 0;
                var star_id = scr_random_find(1, true, "", "");
                if (star_id != undefined) {
                    scr_event_log("purple", $"Chaos Fleets exit the warp near the {star_id.name} system.", star_id.name);
                    for (var j = 0; j < 4; j++) {
                        dirr += irandom_range(50, 100);
                        xx = star_id.x + lengthdir_x(72, dirr);
                        yy = star_id.y + lengthdir_y(72, dirr);
                        flee = instance_create(xx, yy, obj_en_fleet);
                        flee.owner = eFACTION.Chaos;
                        flee.sprite_index = spr_fleet_chaos;
                        flee.image_index = 4;
                        flee.capital_number = choose(0, 1);
                        flee.frigate_number = choose(2, 3);
                        flee.escort_number = choose(4, 5, 6);
                        flee.cargo_data.csm = true;
                        obj_controller.chaos_fleets += 1;
                        flee.action_x = star_id.x;
                        flee.action_y = star_id.y;
                        with (flee) {
                            set_fleet_movement();
                        }
                    }
                }
            }
            // Ships construction
            if (_event.e_id == "ship_construction") {
                var new_ship_event = _event.ship_class;
                var active_forges = [];
                var chosen_star = false;
                with (obj_star) {
                    if (owner == eFACTION.Mechanicus) {
                        for (f = 1; f <= planets; f++) {
                            if ((p_type[f] == "Forge") && (p_owner[f] == eFACTION.Mechanicus)) {
                                array_push(active_forges, new PlanetData(f, self));
                            }
                        }
                    }
                }
                if (array_length(active_forges) > 0) {
                    var ship_spawn = active_forges[irandom(array_length(active_forges) - 1)];
                    var _new_player_fleet = instance_create(ship_spawn.system.x, ship_spawn.system.y, obj_p_fleet);

                    // Creates the ship
                    var last_ship = new_player_ship(new_ship_event, ship_spawn.system.name);

                    add_ship_to_fleet(last_ship, _new_player_fleet);

                    // show_message(string(obj_ini.ship_class[last_ship])+":"+string(obj_ini.ship[last_ship]));

                    if (obj_ini.ship_size[last_ship] != 1) {
                        scr_popup("Ship Constructed", $"Your new {obj_ini.ship_class[last_ship]} '{obj_ini.ship[last_ship]}' has finished being constructed.  It is orbiting {ship_spawn.system.name} and awaits its maiden voyage.", "shipyard", "");
                    }
                    if (obj_ini.ship_size[last_ship] == 1) {
                        scr_popup("Ship Constructed", $"Your new {obj_ini.ship_class[last_ship]} Escort '{obj_ini.ship[last_ship]}' has finished being constructed.  It is orbiting {ship_spawn.system.name} and awaits its maiden voyage.", "shipyard", "");
                    }
                    var bob = instance_create(ship_spawn.system.x + 16, ship_spawn.system.y - 24, obj_star_event);
                    bob.image_alpha = 1;
                    bob.image_speed = 1;
                }
                if (array_length(active_forges) == 0) {
                    _event.duration = 2;
                    scr_popup("Ship Construction halted", $"A lack of suitable forge worlds in the system has halted construction of your requested ship", "shipyard", "");
                }
            }
            // Spare the inquisitor
            if (_event.e_id == "inquisitor_spared") {
                hunt_inquisition_spared_inquisitor_consequence(_event);
            }

            if (_event.e_id == "strange_building") {
                var marine_name = _event.name;
                var comp = _event.company;
                var marine_num = _event.marine;
                var _unit = fetch_unit([marine_num, comp]);
                var item = _event.crafted;

                var killy = 0, tixt = $"{obj_ini.role[100][16]} {marine_name} has finished his work- ";

                if (item == "Icon") {
                    tixt += $"it is a {global.chapter_name} Icon wrought in metal, finely decorated.  Pride for his chapter seems to have overtaken him.  There are no corrections to be made and the item is placed where many may view it.";
                }
                if (item == "Statue") {
                    tixt += "it is a small, finely crafted statue wrought in metal.  The " + string(obj_ini.role[100][16]) + " is scolded for the waste of material, but none daresay the quality of the piece.";
                }
                if (item == "Bike") {
                    scr_add_item("Bike", 1);
                    tixt += "it is a finely crafted Bike, conforming mostly to STC standards.  The other " + string(obj_ini.role[100][16]) + " are surprised at the rapid pace of his work.";
                }
                if (item == "Rhino") {
                    scr_add_vehicle("Rhino", 0, {}, "Storm Bolter", "Storm Bolter", "", "Artificer Hull", "Dozer Blades");
                    tixt += "it is a finely crafted Rhino, conforming to STC standards.  The other " + string(obj_ini.role[100][16]) + " are surprised at the rapid pace of his work.";
                }
                if (item == "Artifact") {
                    scr_event_log("", string(obj_ini.role[100][16]) + " " + string(marine_name) + " constructs an Artifact.");
                    var _last_artifact = scr_add_artifact("random_nodemon", "", 0);

                    tixt += $"some form of divine inspiration has seemed to have taken hold of him.  An artifact {obj_ini.artifact[_last_artifact]} has been crafted.";
                }
                if (item == "baby") {
                    _unit.edit_corruption(choose(8, 12, 16, 20));
                    tixt += "some form of horrendous statue.  A weird amalgram of limbs and tentacles, the sheer atrocity of it is made worse by the tiny, baby-like form, the once natural shape of a human child twisted nearly beyond recognition.";
                } else if (item == "robot") {
                    _unit.edit_corruption(choose(2, 4, 6, 8, 10));
                    tixt += $"some form of small, box-like robot.  It seems to teeter around haphazardly, nearly falling over with each step. {_unit.name()} maintains that it has no AI, though the other " + string(obj_ini.role[100][16]) + " express skepticism.";
                    _unit.add_trait("tech_heretic");
                } else if (item == "demon") {
                    _unit.edit_corruption(choose(8, 12, 16, 20));
                    tixt += "some form of horrendous statue.  What was meant to be some sort of angel, or primarch, instead has a mishappen face that is hardly human in nature.  Between the fetid, ragged feathers and empty sockets it is truly blasphemous.";
                    _unit.add_trait("tech_heretic");
                } else if (item == "fusion") {
                    //TODO if tech heretic chosen don't kill the dude
                    // _unit.corruption+=choose(70);
                    tixt += $"some kind of ill-mannered ascension.  One of your battle-brothers enters the armamentarium to find {marine_name} fused to a vehicle, his flesh twisted and submerged into the frame.  Mechendrites and weapons fire upon the marine without warning, a windy scream eminating from the abomination.  It takes several battle-brothers to take out what was once a " + string(obj_ini.role[100][16]) + ".";

                    // This is causing the problem

                    scr_kill_unit(comp, marine_num);
                    with (obj_ini) {
                        scr_company_order(0);
                    }
                }
                if (item != "fusion") {
                    var options = [
                        {
                            str1: "Execute the heretic",
                            choice_func: function() {
                                scr_kill_unit(pop_data.company, pop_data.marine_number);
                                var company_to_order = pop_data.company;
                                with (obj_ini) {
                                    scr_company_order(company_to_order);
                                }
                                popup_default_close();
                            },
                        },
                        {
                            str1: "Move him to the Penitorium",
                            choice_func: function() {
                                popup_default_close();
                            },
                        },
                        {
                            str1: "I see no problem",
                            choice_func: popup_default_close,
                        }
                    ];
                    var _pop_data = {
                        options: options,
                        marine_number: marine_num,
                        company: comp,
                        marine_name: marine_name,
                    };
                } else {
                    _pop_data = "";
                }

                scr_popup("He Built It", tixt, "tech_build", _pop_data);
            }
            if (_event.duration <= 0) {
                array_delete(event, i, 1);
                continue;
            }
        }
    }
}

function handle_discovered_governor_assasinations() {
    for (var i = 0; i < array_length(obj_controller.event); i++) {
        var _event = obj_controller.event[i];
        if (_event.duration > 1) {
            break;
        }
        if (_event.e_id != "governor_assassination") {
            continue;
        }
        if (_event.duration == 1 && obj_controller.faction_status[eFACTION.Imperium] != "War") {
            var _disp_hit = _event.variant == 1 ? 2 : 4;
            with (obj_star) {
                for (var o = 1; o <= planets; o++) {
                    if (p_owner == eFACTION.Imperium) {
                        if ((dispo[o] > 0) && (dispo[o] < 90)) {
                            dispo[o] = max(dispo[o] - _disp_hit, 0);
                        }
                    }
                }
            }
            if (_event.variant == 1) {
                alter_dispositions([[eFACTION.Imperium, -7], [eFACTION.Inquisition, -10], [eFACTION.Ecclesiarchy, -5]]);

                if (obj_controller.disposition[4] > 0 && obj_controller.disposition[2] > 0) {
                    _event.e_id = "assassination_angryish";
                }
            } else if (_event.variant == 2) {
                alter_disposition(eFACTION.Inquisition, -3);
                if (obj_controller.disposition[4] > 0 && obj_controller.disposition[2] > 0) {
                    _event.e_id = "assassination_angry";
                }
            }

            if ((obj_controller.disposition[4] <= 0) || (obj_controller.disposition[2] <= 0)) {
                obj_controller.alarm[8] = 1;
            } else {
                scr_audience(4, _event.e_id, 0, "", 0, 0, _event);
            }
        }
    }
}

function strange_build_event() {
    log_message("RE: Fey Mood");
    var _search_params = {
        trait: [
            "crafter",
            "tinkerer"
        ],
        trait_any: true,
    };
    var marine_and_company = scr_random_marine("", 0, _search_params);
    if (marine_and_company == "none") {
        marine_and_company = scr_random_marine("", 0, "none");
    }
    if (marine_and_company != "none") {
        var marine = marine_and_company[0];
        var company = marine_and_company[1];
        var text = "";
        var _unit = fetch_unit(marine_and_company);
        var role = _unit.role();
        text = _unit.name_role();
        text += " is taken by a strange mood and starts building!";

        var crafted_object;
        var craft_roll = roll_dice_chapter(1, 100, "low");
        var heritical_item = false;

        //this bit should be improved, idk what duke was checking for here
        //TODO make craft chance reflective of crafters skill, rewards players for having skilled tech area
        if (scr_has_disadv("Tech-Heresy")) {
            craft_roll += 20;
        }
        if (_unit.has_trait("tech_heretic")) {
            craft_roll += 60;
        }
        if (scr_has_adv("Crafter")) {
            if (craft_roll > 80) {
                craft_roll -= 10;
            }
            if (craft_roll < 60) {
                craft_roll += 10;
            }
        }

        if (craft_roll <= 50) {
            crafted_object = choose("Icon", "Icon", "Statue");
        } else if ((craft_roll > 50) && (craft_roll <= 60)) {
            crafted_object = choose("Bike", "Rhino");
        } else if ((craft_roll > 60) && (craft_roll <= 80)) {
            crafted_object = "Artifact";
        } else {
            crafted_object = choose("baby", "robot", "demon", "fusion");
            heritical_item = 1;
        }

        add_event({e_id: "strange_building", duration: 1, name: _unit.name(), company: company, marine: marine, crafted: crafted_object});

        scr_popup("Can He Build marine?!?", text, "tech_build", "");

        var marine_is_planetside = _unit.planet_location > 0;
        if (marine_is_planetside && heritical_item) {
            var _system = star_by_name(_unit.location_string);
            var _planet = _unit.planet_location;
            if (_system != "none") {
                with (_system) {
                    p_hurssy[_planet] += 6;
                    p_hurssy_time[_planet] = 2;
                }
            }
        } else if (!marine_is_planetside && heritical_item) {
            var _fleet = find_ships_fleet(_unit.ship_location);
            if (_fleet != "none") {
                //the intended code for here was to add some sort of chaos event on the ship stashed up ready to fire in a few turns
            }
        }
        return true;
    }
    return false;
}

function make_faction_enemy_event() {
    log_message("RE: Enemy");

    var factions = [];
    if (obj_controller.known[eFACTION.Imperium] == 1) {
        array_push(factions, 2);
    }
    if (obj_controller.known[eFACTION.Mechanicus] == 1) {
        array_push(factions, 3);
    }
    if (obj_controller.known[eFACTION.Inquisition] == 1) {
        array_push(factions, 4);
    }
    if (obj_controller.known[eFACTION.Ecclesiarchy] == 1) {
        array_push(factions, 5);
    }

    if (array_length(factions) == 0) {
        log_error("RE: Enemy, no faction could be chosen");
        exit;
    }
    var chosen_faction = array_random_element(factions);

    var text = "You have made an enemy within the ";
    var log = "An enemy has been made within the ";
    var _e_name = "";
    switch (chosen_faction) {
        case 2:
            _e_name = "enemy_imperium";
            text += "Imperium";
            log += "Imperium";
            break;
        case 3:
            _e_name = "enemy_mechanicus";
            text += "Mechanicus";
            log += "Mechanicus";
            break;
        case 4:
            _e_name = "enemy_inquisition";
            text += "Inquisition";
            log += "Inquisition";
            break;
        case 5:
            _e_name = "enemy_ecclesiarchy";
            text += "Ecclesiarchy";
            log += "Ecclesiarchy";
            break;
        default:
            log_error("RE: Enemy, no faction could be chosen");
            exit;
    }
    if (_e_name != "") {
        add_event({duration: irandom_range(12, 96), e_id: _e_name});
        alter_disposition(chosen_faction, -20);
        text += "; relations with them will be soured for the forseable future.";
        scr_popup("Diplomatic Incident", text, "angry", "");
        scr_event_log("red", string(log));
        return true;
    }
    return false;
}

function event_dispose_of_mutated_gene() {
    if (pop_data.percent_remove > 0) {
        obj_controller.gene_seed -= obj_controller.gene_seed * (pop_data.percent_remove / 100);
    }
    popup_default_close();
}
