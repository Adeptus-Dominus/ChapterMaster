enum eSTART_FACTION {
    PROGENITOR = 1,
    IMPERIUM,
    MECHANICUS,
    INQUISITION,
    ECCLESIARCHY,
    ASTARTES,
    RESERVED,
}

/// @self Asset.GMObject.obj_creation
function set_complex_livery_buttons() {
    try {
        var _type = complex_livery_radio.selection_val("value");
        var _name = complex_livery_radio.selection_val("display_name");
        var _data = complex_livery_data[$ _type];
        var _alpha = (custom != eCHAPTER_TYPE.CUSTOM) ? 0.5 : 1;

        // --- Ensure stored colour indices are always valid ---
        _data.helm_primary = clamp(_data.helm_primary, 0, array_length(col) - 1);
        _data.helm_secondary = clamp(_data.helm_secondary, 0, array_length(col) - 1);
        _data.helm_lens = clamp(_data.helm_lens, 0, array_length(col) - 1);

        // --- Build button objects ---
        complex_livery_buttons = [
            new UnitButtonObject({
                x1: 500,
                y1: 252,
                style: "pixel",
                tooltip: localize("Primary Helm Colour\nPrimary helm colour of {0}", [localize(_name)]),
                label: localize("Helm Primary : {0}", [localize(get_colour_name(_data.helm_primary))]),
                area: "helm_primary",
                role_id: _type,
                alpha: _alpha,
            }),
            new UnitButtonObject({
                x1: 500,
                y1: 287,
                style: "pixel",
                tooltip: localize("Secondary Helm Colour\nSecondary helm colour of {0}", [localize(_name)]),
                label: localize("Helm Secondary : {0}", [localize(get_colour_name(_data.helm_secondary))]),
                area: "helm_secondary",
                role_id: _type,
                alpha: _alpha,
            }),
            new UnitButtonObject({
                x1: 500,
                y1: 322,
                style: "pixel",
                tooltip: localize("Helm Lens Colour\nHelm lens colour of {0}", [localize(_name)]),
                label: localize("Lens : {0}", [localize(get_colour_name(_data.helm_lens))]),
                area: "helm_lens",
                role_id: _type,
                alpha: _alpha,
            }),
        ];

        // --- Update current pattern selection ---
        advanced_helmet_livery.current_selection = _data.helm_pattern;
    } catch (_exception) {
        ERROR_HANDLER.handle_exception(_exception);
    }
}

/// @self Asset.GMObject.obj_creation
function update_creation_roles_radio(start_role = 1) {
    var _role_choice_array = [];

    for (var i = start_role; i < array_length(player_role_data); i++) {
        var _role_data = player_role_data[i];
        if (_role_data.available_to_player && _role_data.role != "") {
            array_push(_role_choice_array, {str1: localize(_role_data.role), font: fnt_40k_14b, role_id: i});
        }
    }

    var _radio_data = {
        max_width: 50,
        x1: 862,
        y1: 220,
        y_gap: 1,
    };
    roles_radio = new RadioSet(_role_choice_array, localize("Role Settings"), _radio_data);
    roles_radio.current_selection = -1;
}

/// @self Asset.GMObject.obj_creation
function bulk_selection_buttons_setup() {
    var _button_data = [
        {
            text: localize("Primary : {0}", [localize(col[main_color])]),
            tooltip: localize("Primary"),
            tooltip2: localize("The main color of your Astartes and their vehicles. And the colour of your chapters Ships"),
            cords: [
                500,
                287,
            ],
        },
        {
            text: localize("Secondary: {0}", [localize(col[secondary_color])]),
            tooltip: localize("Secondary"),
            tooltip2: localize("The secondary color of your Astartes and their vehicles."),
            cords: [
                500,
                322,
            ],
        },
        {
            text: localize("Pauldron 1: {0}", [localize(col[left_pauldron])]),
            tooltip: localize("First Pauldron"),
            tooltip2: localize("The color of your Astartes' left Pauldron.  Normally this Pauldron displays their rank and designation."),
            cords: [
                500,
                357,
            ],
        },
        {
            text: localize("Pauldron 2: {0}", [localize(col[right_pauldron])]),
            tooltip: localize("Second Pauldron"),
            tooltip2: localize("The color of your Astartes' right Pauldron.  Normally this Pauldron contains the Chapter Insignia."),
            cords: [
                500,
                392,
            ],
        },
        {
            text: localize("Trim: {0}", [localize(col[main_trim])]),
            tooltip: localize("Trim"),
            tooltip2: localize("The trim color that appears on the Pauldrons, armour plating, and any decorations."),
            cords: [
                500,
                427,
            ],
        },
        {
            text: localize("Lens: {0}", [localize(col[lens_color])]),
            tooltip: localize("Lens"),
            tooltip2: localize("The color of your Astartes' lenses.  Most of the time this will be the visor color."),
            cords: [
                500,
                462,
            ],
        },
        {
            text: localize("Weapon: {0}", [localize(col[weapon_color])]),
            tooltip: localize("Weapon"),
            tooltip2: localize("The primary color of your Astartes' weapons."),
            cords: [
                500,
                497,
            ],
        },
    ];
    bulk_buttons = [];
    draw_set_font(cjk_font(fnt_40k_14b));
    for (var i = 0; i < array_length(_button_data); i++) {
        var _but = _button_data[i];
        array_push(bulk_buttons, new UnitButtonObject({
            x1: _but.cords[0],
            y1: _but.cords[1],
            style: "pixel",
            tooltip: $"{_but.tooltip}\n{_but.tooltip2}",
            label: _but.text,
            alpha: custom != eCHAPTER_TYPE.CUSTOM ? 0.5 : 1,
        }));
    }
}

/// @self Asset.GMObject.obj_creation
function scr_creation(slide_num) {
    // 1 = chapter select
    // 2 = Chapter Naming, Points assignment, advantages/disadvantages
    // 3 = Homeworld, Flagship, Psychic discipline, Aspirant Trial
    // 4 = Livery, Roles
    // 5 = Gene Seed Mutations, Disposition
    // 6 = Chapter Master
    if (slide_num == eCREATION_SLIDES.CHAPTERSELECT) {
        setup_chapter_trait_select();
    }

    LOGGER.debug($"calling scr_creation with input {slide_num}");
    if (slide_num == eCREATION_SLIDES.CHAPTERTRAITS && custom != eCHAPTER_TYPE.PREMADE) {
        if (name_bad == 1) {
            /*(sound_play(bad);*/
        }
        if (name_bad == 0) {
            change_slide = true;
            goto_slide = 3;
            player_role_data[eROLE.LIBRARIAN].available_to_player = true;
        }
    }

    if (slide_num == eCREATION_SLIDES.CHAPTERTRAITS && custom == eCHAPTER_TYPE.PREMADE) {
        change_slide = true;
        goto_slide = 3;
        player_role_data[eROLE.LIBRARIAN].available_to_player = true;
        player_role_data[eROLE.CHAPLAIN].available_to_player = chapter_name != "Iron Hands" && chapter_name != "Space Wolves";
    }

    if (slide_num == eCREATION_SLIDES.CHAPTERHOME) {
        change_slide = true;
        goto_slide = eCREATION_SLIDES.CHAPTERLIVERY;
        alarm[0] = 1;
        update_creation_roles_radio();

        if (slide_num == eCREATION_SLIDES.CHAPTERHOME) {
            draw_set_font(cjk_font(fnt_40k_12));
            complex_livery_radio = new RadioSet([
                {
                    str1: localize("Sergeant Markers"),
                    font: fnt_40k_12,
                    value: "sgt",
                    display_name: localize("Sergeant"),
                },
                {
                    str1: localize("Veteran Sergeant Markers"),
                    font: fnt_40k_12,
                    value: "vet_sgt",
                    display_name: localize("Veteran Sergeant"),
                },
                {
                    str1: localize("Captain Markers"),
                    font: fnt_40k_12,
                    value: "captain",
                    display_name: localize("Captain"),
                },
                {
                    str1: localize("Veteran Markers"),
                    font: fnt_40k_12,
                    value: "veteran",
                    display_name: localize("Veteran"),
                },
            ], "", {
                max_width: 50,
                x1: 862,
                y1: 225,
            });

            bulk_armour_pattern = new RadioSet([
                {
                    str1: localize("Single Colour"),
                    font: fnt_40k_12,
                    style: "box",
                },
                {
                    str1: localize("Breastplate"),
                    font: fnt_40k_12,
                    style: "box",
                },
                {
                    str1: localize("Vertical"),
                    font: fnt_40k_12,
                    style: "box",
                },
                {
                    str1: localize("Quadrant"),
                    font: fnt_40k_12,
                    style: "box",
                },
            ], "", {
                x1: 477,
                y1: 515,
                max_width: 400,
            });

            advanced_helmet_livery = new RadioSet([
                {
                    str1: localize("Single Colour"),
                    font: fnt_40k_12,
                    style: "box",
                },
                {
                    str1: localize("Stripe"),
                    font: fnt_40k_12,
                    style: "box",
                },
                {
                    str1: localize("Muzzle"),
                    font: fnt_40k_12,
                    style: "box",
                },
                {
                    str1: localize("Pattern"),
                    font: fnt_40k_12,
                    style: "box",
                },
            ], "", {
                x1: 477,
                y1: 515,
                max_width: 400,
            });

            set_complex_livery_buttons();

            draw_set_font(cjk_font(fnt_40k_14b));
            bulk_selection_buttons_setup();
            livery_selection_options = new RadioSet(
                [
                    {
                        str1: localize("Default"),
                        tooltip: localize("The default livery all marines will be coloured in"),
                        font: fnt_menu,
                    },
                    {
                        str1: localize("Role"),
                        tooltip: localize("Role specific livery that will overide default livery"),
                        font: fnt_menu,
                    },
                    {
                        str1: localize("Company"),
                        tooltip: localize("company specific livery that will overide role livery"),
                        font: fnt_menu,
                    },
                ],
            );
            colour_selection_options = new RadioSet(
                [
                    {
                        str1: localize("Standard"),
                        tooltip: localize("standard options to colour marine"),
                        font: fnt_menu,
                    },
                    {
                        str1: localize("Bulk"),
                        tooltip: localize("bulk colouring for ease and speed"),
                        font: fnt_menu,
                    },
                    {
                        str1: localize("Advanced"),
                        tooltip: localize("Advanced options for colouring"),
                        font: fnt_menu,
                    },
                ],
            );
            if (full_liveries == "") {
                var struct_cols = {
                    main_color: main_color,
                    secondary_color: secondary_color,
                    main_trim: main_trim,
                    right_pauldron: right_pauldron,
                    left_pauldron: left_pauldron,
                    lens_color: lens_color,
                    weapon_color: weapon_color,
                };
                livery_picker.scr_unit_draw_data();
                livery_picker.set_default_armour(struct_cols, col_special);
                full_liveries = array_create(21, variable_clone(livery_picker.map_colour));
                full_liveries[eROLE.LIBRARIAN] = livery_picker.set_default_librarian(struct_cols);

                full_liveries[eROLE.CHAPLAIN] = livery_picker.set_default_chaplain(struct_cols);

                full_liveries[eROLE.APOTHECARY] = livery_picker.set_default_apothecary(struct_cols);

                full_liveries[eROLE.TECHMARINE] = livery_picker.set_default_techmarines(struct_cols);
                livery_picker.scr_unit_draw_data();
                livery_picker.set_default_armour(struct_cols, col_special);
            }
        }
    }

    if (slide_num == eCREATION_SLIDES.CHAPTERLIVERY) {
        if (custom == eCHAPTER_TYPE.PREMADE || (hapothecary != "" && hchaplain != "" && clibrarian != "" && fmaster != "" && recruiter != "" && admiral != "" && battle_cry != "")) {
            change_slide = true;
            goto_slide = eCREATION_SLIDES.CHAPTERROLES;
            update_creation_roles_radio(2);
            role_setup_objects();
        }
    }

    if (slide_num == eCREATION_SLIDES.CHAPTERROLES) {
        if (custom == eCHAPTER_TYPE.PREMADE || (hapothecary != "" && hchaplain != "" && clibrarian != "" && fmaster != "" && recruiter != "" && admiral != "" && battle_cry != "")) {
            change_slide = true;
            goto_slide = eCREATION_SLIDES.CHAPTERGENE;
            if (custom == eCHAPTER_TYPE.CUSTOM) {
                mutations_selected = 0;
                preomnor = 0;
                voice = 0;
                doomed = 0;
                lyman = 0;
                omophagea = 0;
                ossmodula = 0;
                membrane = 0;
                zygote = 0;
                betchers = 0;
                catalepsean = 0;
                secretions = 0;
                occulobe = 0;
                mucranoid = 0;
                mutations = 10 - purity;
            }

            if (custom != eCHAPTER_TYPE.PREMADE) {
                disposition[0] = 0;
                disposition[eSTART_FACTION.PROGENITOR] = 60 + ((cooperation - 5) * 4); // Prog
                disposition[eSTART_FACTION.IMPERIUM] = 50 + ((cooperation - 5) * 4); // Imp
                disposition[eSTART_FACTION.MECHANICUS] = 40 + ((cooperation - 5) * 2); // Mech
                disposition[eSTART_FACTION.INQUISITION] = 30 + ((cooperation - 5) * 2) - (2 * (10 - purity)) - ((99 - stability) / 5); // Inq
                disposition[eSTART_FACTION.ECCLESIARCHY] = 40 + ((cooperation - 5) * 4) - (10 - purity) - ((99 - stability) / 5); // Ecclesiarchy

                switch (founding) {
                    case eCHAPTERS.SPACE_WOLVES:
                    case eCHAPTERS.SALAMANDERS:
                        disposition[eSTART_FACTION.PROGENITOR] = 70;
                        break;
                    case eCHAPTERS.IMPERIAL_FISTS:
                        disposition[eSTART_FACTION.PROGENITOR] = 50;
                        break;
                    case eCHAPTERS.UNKNOWN:
                        disposition[eSTART_FACTION.INQUISITION] -= 5;
                        break;
                    default:
                        break;
                }

                if (strength > 5) {
                    disposition[eSTART_FACTION.INQUISITION] -= (strength - 5) * 2;
                } else if (strength < 5) {
                    disposition[eSTART_FACTION.IMPERIUM] += (5 - strength) * 2;
                }

                for (var i = 0; i < array_length(obj_creation.all_advantages); i++) {
                    var _adv = obj_creation.all_advantages[i];
                    if (_adv.activated) {
                        _adv.alter_starting_dispositions();
                    }
                }

                for (var i = 0; i < array_length(obj_creation.all_disadvantages); i++) {
                    var _dis_adv = obj_creation.all_disadvantages[i];
                    if (_dis_adv.activated) {
                        _dis_adv.alter_starting_dispositions();
                    }
                }
            }
        }
    }

    // 5 to 6
    if (slide_num == eCREATION_SLIDES.CHAPTERGENE) {
        if (custom == eCHAPTER_TYPE.PREMADE || mutations <= mutations_selected) {
            change_slide = true;
            goto_slide = eCREATION_SLIDES.CHAPTERMASTER;
        }
    }

    // 6 to finish
    if (slide_num == eCREATION_SLIDES.CHAPTERMASTER) {
        if (chapter_master_name != "" && chapter_master_melee != 0 && chapter_master_ranged != 0 && chapter_master_specialty != 0) {
            cooldown = 9999;

            if (founding == ePROGENITOR.RANDOM) {
                founding = irandom_range(ePROGENITOR.NONE, ePROGENITOR.RAVEN_GUARD);
            }

            if (custom == eCHAPTER_TYPE.CUSTOM && global.chapter_id != eCHAPTERS.UNKNOWN) {
                scr_save_chapter(global.chapter_id);
            }

            instance_create(0, 0, obj_ini);
            global.audio_manager.play_playlist(CONTEXT_SECTOR, 5000);

            if (founding == eCHAPTERS.SALAMANDERS || global.chapter_id == eCHAPTERS.SALAMANDERS) {
                obj_ini.skin_color = 1;
            }
            if (global.chapter_id != eCHAPTERS.SALAMANDERS && founding != eCHAPTERS.SALAMANDERS && secretions == 1) {
                obj_ini.skin_color = choose(2, 3, 4);
            }

            room_goto(rm_game);
        }
    }
}
