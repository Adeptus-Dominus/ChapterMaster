function elder_dialogue_useful_information() {
	var _found = 0;
    var _rando = choose(1, 1, 2, 3, 4, 4, 5);
    force_goodbye = -1;

    if ((_rando == 5) && array_contains(obj_controller.useful_info, eUSEFULLINFORMATION.MOST_CORRUPT_MARINE)) {
        _rando -= 1;
    }
    if ((_rando == 4) && (random_event_next != eEVENT.NONE)) {
        _rando -= 1;
    }
    if ((_rando == 3) && ((turn < chaos_turn) || (known[eFACTION.CHAOS] > 3))) {
        _rando -= 1;
    }
    if ((_rando == 2) && ((known[eFACTION.ORK] < 0) || (known[eFACTION.ORK] >= 3) || array_contains(obj_controller.useful_info, eUSEFULLINFORMATION.ORK_WARBOSS_LOCATION))) {
        _rando -= 1;
    }
    if ((_rando == 1) && array_contains(obj_controller.useful_info, eUSEFULLINFORMATION.WEBWAYGATE_SECOND)) {
        _rando = 5;
    }

    // * Most corrupt mahreen *
    if (_rando == 5) {
        array_push(obj_controller.useful_info, eUSEFULLINFORMATION.MOST_CORRUPT_MARINE);

        var _unit = scr_max_marine("chaos");

        if (_unit.company == 0) {
            diplo_text = "I have looked into the strands of fate, with your chapter, and found that the future is not suspect for any of your men.  None of them have their minds poisoned by the taint of chaos.";
        } else if (_unit.company > 0) {
            diplo_text = $"I have looked into the strands of fate, with your chapter.  Your 'battle brother' {_unit.name_role()} has a clouded, dark future- it is advised you watch him carefully.";
        }
    }
    // * Next random event *
    if (_rando == 4) {
        scr_random_event(false);
        if ((random_event_next == eEVENT.STRANGE_BEHAVIOR) && (obj_controller.disposition[eFACTION.ELDAR] < 15)) {
            diplo_text = "One of your Mon'keigh soldiers will no longer act as you expect him to. Be wary, when one Mon'keigh is influenced the rest of the herd will be.";
        } else if ((random_event_next == eEVENT.STRANGE_BEHAVIOR) && (obj_controller.disposition[eFACTION.ELDAR] >= 15)) {
            diplo_text = "One of your soldiers will no longer act as you expect him to. Be wary, when one is influenced the rest of the herd will be.";
        } else if (random_event_next == eEVENT.SPACE_HULK) {
            diplo_text = "It comes from the warp, a relic from the past. It is steeped in the energies of the ethereal tides. Beware.";
        } else if (random_event_next == eEVENT.PROMOTION) {
            diplo_text = "One of your soldiers will cover himself in glory. As his “Chapter Master”, a title I find inherently foolish, you may wish to reward him.";
        } else if (random_event_next == eEVENT.STRANGE_BUILDING) {
            diplo_text = "The Red robed ones, their “Machine God”, calls to them. Soon, one shall lose their tenuos grip on the here and now and follow the pictures in his head.";
        } else if (random_event_next == eEVENT.SORORITAS) {
            diplo_text = "Your priestesses of war, who worship He Who Fell, will gather their forces soon, to stay.";
        } else if (random_event_next == eEVENT.INQUISITION_MISSION) {
            diplo_text = "They will come very soon, the bearers of hellfire and hate. They will scour the sector for so-called ''Heresy''.";
        } else if (random_event_next == eEVENT.INQUISITION_PLANET) {
            diplo_text = "Your questions askers seek to learn more of a planet.  Warp meddlers and free thinkers would be well-served with caution. Beware, Chapter Master.";
        } else if (random_event_next == eEVENT.ROGUE_TRADER) {
            diplo_text = "Free thinkers, traders in the vast expanse. They are coming, perhaps you aught to set out your wares?";
        } else if (random_event_next == eEVENT.FLEET_DELAY) {
            diplo_text = "Mon'keigh, your fleets may be delayed by my kin. Eldar Pirates, your kind would call them.";
        } else if (random_event_next == eEVENT.HARLEQUINS) {
            diplo_text = "Rillietann. They have come. They are on some world, hidden, or soon will be.";
        } else if (random_event_next == eEVENT.SUCCESSION_WAR) {
            diplo_text = "Your underlings fight for power, Mon'keigh.  Someone will die who believes he is important. His children and ''friends'' will vie for the rite to call himself or herself governor. Or king. Or whatever self aggrandising title your people name yourselves.";
        } else if (random_event_next == eEVENT.RANDOM_FUN) {
            diplo_text = "Something will happen soon. The runes do not show me exactly what will happen, only that it concerns you. Watch the horizon, Mon'keigh.";
        } else if (random_event_next == eEVENT.WARP_STORMS) {
            diplo_text = "The tides of the Immaterium are unsettled. Of course, it's hard to calculate where the Immaterium will affect the Materium, but I predict it will come soon.";
        } else if (random_event_next == eEVENT.ENEMY_FORCES) {
            diplo_text = "From beyond your circle of firelight, they are coming. Rest not Mon'keigh, for they will come soon and are bent on destruction.";
        } else if (random_event_next == eEVENT.CRUSADE) {
            diplo_text = "Soon, your masters will call you to heel like a dog to attack the foes of man. One of your ''Crusades'' of hate, ignorance and bigotry will be called.";
        } else if (random_event_next == eEVENT.ENEMY) {
            diplo_text = "You will make an enemy among your fellow man. Soon they shall whisper into their lord's ear, telling that you are a threat, a beetle to be crushed beneath their boot.  You would do well to speak carefully, for some time.";
        } else if (random_event_next == eEVENT.MUTATION) {
            diplo_text = "Your 'battle brothers' are twisting like snakes beneath your feet. Watch yourself, Chapter Master.";
        } else if (random_event_next == eEVENT.SHIP_LOST) {
            diplo_text = "The Immaterium will swallow one of your ships.  Do not look for it to return.";
        } else if (random_event_next == eEVENT.CHAOS_INVASION) {
            diplo_text = "Your twisted brethren, who fell to the lure of the Immaterium, will soon arrive with their wrath and demons. Beware.";
        } else if (random_event_next == eEVENT.NECRON_AWAKEN) {
            diplo_text = "Our old enemies, the men of metal, are close. You call them “Necrons”, and you will need to fight them soon. Or flee, it matters not to me.";
        } else {
            diplo_text = $"[Missing Dialogue: {random_event_next} forcast.]"; // this will print a number rather that a string which is less than ideal, but we can just add new flavour text whem we get the bug reports
        }
    }
    // * Chaos warlord location *
    if (_rando == 3) {
        array_push(obj_controller.useful_info, eUSEFULLINFORMATION.CHAOS_WARLORD_LOCATION);
        if (obj_controller.faction_gender[10] == 1) {
            for (var i = 0; i < 5; i++) {
                if (_found == 0) {
                    instance_activate_object(obj_star);
                    with (obj_temp5) {
                        instance_destroy();
                    }
                    with (obj_star) {
                        for (var j = 1; j <= 4; j++) {
                            if (planet_feature_bool(p_feature[1], eP_FEATURES.WARLORD10) == 1) {
                                instance_create(x, y, obj_temp5);
                            }
                        }
                    }
                    if (instance_exists(obj_temp5)) {
                        var you, nuum, plan = 0;
                        you = instance_nearest(obj_temp5.x, obj_temp5.y, obj_star);
                        nuum = you.name;
                        for (var j = 1; j <= you.planets; j++) {
                            if (planet_feature_bool(you.p_feature[1], eP_FEATURES.WARLORD10) == 1) {
                                plan = j;
                            }
                        }
                        _found = 1;
                        diplo_text = $"The fallen warlord of your kind is located somewhere within the {nuum} system.  More I cannot say.  It would be prudent to deal with this soon- that abomination may not remain there long.";
                    }
                }
            }
        }
        if (obj_controller.faction_gender[10] == 2) {
            diplo_text = "The Lord of Rage turns his foul gaze upon this sector.  With it death and destruction will soon come.  You had best be ready when it does.";
        }
    }
    // * Ork Warboss Location *
    if (_rando == 2) {
        array_push(obj_controller.useful_info, eUSEFULLINFORMATION.ORK_WARBOSS_LOCATION);

        if (_found == 0) {
            instance_activate_object(obj_star);

            var _warboss_found = false;
            var _star = noone;
            with (obj_star) {
            	if (system_feature_bool(p_feature, eP_FEATURES.ORKWARBOSS)){
            		_warboss_found = true;
            		_star = id;
            		break;
            	}
            }
            if (_warboss_found) {
                diplo_text = $"The greenskin horde is led by a massive Ork, one who calls himself {faction_leader[eFACTION.ORK]}.  If this warboss were to perish the rest might be dealt with in a more languorous fashion.  He is located in the {_star.name} system";
                _found = 1;
            }
        }
    }
    // * Webway Gate Location *
    // if ((_rando == 1) && array_contains(obj_controller.useful_info, eUSEFULLINFORMATION.WEBWAYGATE_SECOND)) then _rando += choose(1, 2, 3, 3);
    if (_rando == 1) {
        if (!array_contains(obj_controller.useful_info, eUSEFULLINFORMATION.WEBWAYGATE)) {
            array_push(obj_controller.useful_info, eUSEFULLINFORMATION.WEBWAYGATE);
            for (var i = 0; i < 5; i++) {
                if (_found == 0) {
                    instance_activate_object(obj_star);
                    with (obj_temp6) {
                        instance_destroy();
                    }
                    with (obj_temp5) {
                        instance_destroy();
                    }
                    if (obj_ini.fleet_type == ePLAYER_BASE.HOME_WORLD) {
                        with (obj_star) {
                            if (owner == 1) {
                                instance_create(x, y, obj_temp6);
                            }
                        }
                    }
                    if (obj_ini.fleet_type != ePLAYER_BASE.HOME_WORLD) {
                        with (obj_p_fleet) {
                            if (capital_number > 0) {
                                instance_create(x, y, obj_temp6);
                            }
                        }
                    }

                    with (obj_star) {
                        if (owner != eFACTION.IMPERIUM) {
                            instance_deactivate_object(id);
                        }
                        if ((owner == eFACTION.IMPERIUM) && (point_distance(x, y, obj_temp6.x, obj_temp6.y) > 250)) {
                            instance_deactivate_object(id);
                        }
                        if ((owner == eFACTION.IMPERIUM) && (planets < 1)) {
                            instance_deactivate_object(id);
                        }
                    }
                    var _gate_planet_name = "";
                    var that = instance_nearest(random(room_width), random(room_height), obj_star);
                    for (var index = 0; index < 5; index++) {
                        with (that) {
                            var j = 0, onceh = 0;
                            for (var k = 0; k < 10; k++) {
                                j = floor(random(planets)) + 1;
                                if ((array_length(p_feature[j]) == 0) && (onceh == 0)) {
                                    onceh = j;
                                }
                            }
                            if (onceh != 0) {
                                array_push(p_feature[onceh], new NewPlanetFeature(eP_FEATURES.WEBWAY));
                                _gate_planet_name = planet_numeral_name(onceh, that);
                                break;
                            }
                        }
                    }
                    if (_gate_planet_name != "") {
                        diplo_text = $"A series of labyrinthian corridors and veins connect the galaxy.  The planet you know as {_gate_planet_name} contains a dormant entrance to this realm.";
                        _found = 1;
                    }
                }
            }
        } else if (!array_contains(obj_controller.useful_info, eUSEFULLINFORMATION.WEBWAYGATE_SECOND)) {
            array_push(obj_controller.useful_info, eUSEFULLINFORMATION.WEBWAYGATE_SECOND);
            for (var i = 0; i < 5; i++) {
                if (_found == 0) {
                    instance_activate_object(obj_star);
                    with (obj_temp6) {
                        instance_destroy();
                    }
                    with (obj_temp5) {
                        instance_destroy();
                    }
                    if (obj_ini.fleet_type == ePLAYER_BASE.HOME_WORLD) {
                        with (obj_star) {
                            if (owner == 1) {
                                instance_create(x, y, obj_temp6);
                            }
                        }
                    }
                    if (obj_ini.fleet_type != ePLAYER_BASE.HOME_WORLD) {
                        with (obj_p_fleet) {
                            if (capital_number > 0) {
                                instance_create(x, y, obj_temp6);
                            }
                        }
                    }
                    with (obj_star) {
                        if (owner != eFACTION.IMPERIUM) {
                            instance_deactivate_object(id);
                        }
                        if ((owner == eFACTION.IMPERIUM) && (point_distance(x, y, obj_temp6.x, obj_temp6.y) < 800)) {
                            instance_deactivate_object(id);
                        }
                        if ((owner == eFACTION.IMPERIUM) && (planets < 1)) {
                            instance_deactivate_object(id);
                        }
                    }
                    var _gate_planet_name = "";
                    var that = instance_nearest(random(room_width), random(room_height), obj_star);
                    for (var j = 0; j < 5; j++) {
                        with (that) {
                            var onceh = 0;
                            for (var k = 0; k < 10; k++) {
                                var l = floor(random(planets)) + 1;
                                if ((array_length(p_feature[l]) == 0) && (onceh == 0)) {
                                    onceh = l;
                                }
                            }
                            if (onceh != 0) {
                                array_push(p_feature[onceh], new NewPlanetFeature(eP_FEATURES.WEBWAY));
                                _gate_planet_name = planet_numeral_name(onceh, that);
                                break;
                            }
                        }
                    }
                    if (_gate_planet_name != "") {
                        diplo_text = $"The second dormant webway gate lays upon {_gate_planet_name}.";
                        _found = 1;
                    }
                }
            }
        }
        with (obj_temp6) {
            instance_destroy();
        }
        with (obj_temp5) {
            instance_destroy();
        }
        instance_activate_object(obj_star);
    }
}