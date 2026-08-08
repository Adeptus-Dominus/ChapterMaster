/// @self Id.Instance.obj_controller
function set_chapter_arti_data() {
    menu_artifact = -1;
    unused_artifacts = 0;
    var _artifacts = build_sorted_artifact_ids();
    for (var _i = 0; _i < array_length(_artifacts); _i++) {
        var _arti = obj_ini.artifact_map[$ _artifacts[_i]];
        if (menu_artifact == -1) {
            menu_artifact = _arti.artifact_id;
        }
        if (!_arti.is_equipped()) {
            unused_artifacts++;
        }
    }
}

/// @self Id.Instance.obj_controller
function scr_librarium_gui() {
    add_draw_return_values();
    if (artifact_count() == 0) {
        draw_text(622, 440, "[No Artifacts]");
        artifact_destroy.draw_shutter(765, 740, "DESTROY", 0.3, false);
        artifact_equip.draw_shutter(385, 740, "EQUIP", 0.3, false);
        artifact_gift.draw_shutter(575, 740, "GIFT", 0.3, false);
        pop_draw_return_values();
        exit;
    }
    /// @type {Struct.ArtifactStruct}
    var cur_arti = fetch_artifact(menu_artifact);
    var artif_descr = $"This artifact is an unidentified {cur_arti.get_type_name()}.##It is stored on {cur_arti.get_ship_id() > -1 ? "the ship" : ""} '{cur_arti.get_location_string()}'.";
    var artif_timer = cur_arti.get_identification_timer();

    draw_set_color(#5F730D);

    if (artif_timer > 0) {
        if (!cur_arti.is_identifiable()) {
            artif_descr += $"#To be identified it must be brought to a fleet with a Battle Barge or your Homeworld.";
        } else {
            artif_descr += $"##It will be identified in {artif_timer} turns. #You may spend 150 Requisition to identify it immediately.";

            //TODO solidify following button into a proper styled struct button
            var ident_button = draw_unit_buttons([532, 765], "IDENTIFY NOW", [1, 1], c_black,, fnt_40k_14b,, 1, c_gray);
            if (point_and_click(ident_button)) {
                if (requisition >= 150) {
                    cur_arti.set_identification_timer(0);
                    requisition -= 150;
                    global.audio_manager.play_sfx(SFX_IDENTIFY);
                }
            }
        }
    } else if (artif_timer < 1) {
        artif_descr = cur_arti.get_description();
        var _bearer_text = cur_arti.get_bearer_text();
        if (_bearer_text != "") {
            artif_descr += $"\n\n{_bearer_text}";
        }

        var _can_equip = cur_arti.is_equippable();
        if (_can_equip) {
            if (!cur_arti.is_equipped()) {
                if (artifact_equip.draw_shutter(385, 770, "EQUIP", 0.3, true)) {
                    if (!instance_exists(obj_popup)) {
                        equip_artifact_popup_setup();
                    }
                }
            } else {
                if (artifact_equip.draw_shutter(385, 770, "UNEQUIP", 0.3, true)) {
                    cur_arti.unequip_from_unit();
                }
            }
        }

        if (artifact_gift.draw_shutter(575, 770, "GIFT", 0.3, true)) {
            setup_gift_artifact_popup();
        }

        if (artifact_destroy.draw_shutter(765, 770, "DESTROY", 0.3, true)) {
            // Below here cleans up the artifacts
            cur_arti.destroy_artifact();

            //TODO centralise into function
            for (var e = 0, elen = array_length(obj_controller.recent_keyword); e < elen; e++) {
                if ((obj_controller.recent_type[e] == "artifact_acquired") && (obj_controller.recent_number[e] == cur_arti.artifact_id)) {
                    with (obj_controller) {
                        array_delete(recent_keyword, e, 1);
                        array_delete(recent_type, e, 1);
                        array_delete(recent_turn, e, 1);
                        array_delete(recent_number, e, 1);
                    }
                    break;
                }
            }
            scr_recent("artifact_destroyed", string(cur_arti.get_tags()), 2);
            scr_recent("", "", 0);
            delete_artifact(menu_artifact);
        }
    } else {
        artifact_destroy.draw_shutter(765, 740, "DESTROY", 0.3, false);
        artifact_equip.draw_shutter(385, 740, "EQUIP", 0.3, false);
        artifact_gift.draw_shutter(575, 740, "GIFT", 0.3, false);
    }

    artifact_slate.body_text = artif_descr;
    artifact_slate.draw_with_dimensions();

    pop_draw_return_values();
}

/// @self Id.Instance.obj_controller
function scr_librarium() {
    add_draw_return_values();
    var blurp = "";
    var xx = camera_get_view_x(view_camera[0]);
    var yy = camera_get_view_y(view_camera[0]);
    draw_sprite(spr_rock_bg, 0, xx, yy);

    draw_set_alpha(0.75);
    draw_set_color(c_black);
    draw_rectangle(xx + 342, yy + 66, xx + 903, yy + 818, 0);
    draw_set_alpha(1);
    draw_set_color(c_gray);
    draw_rectangle(xx + 342, yy + 66, xx + 903, yy + 818, 1); // Center librarium box
    draw_line(xx + 342, yy + 426, xx + 903, yy + 426);
    draw_set_alpha(0.75);
    draw_set_color(c_black);
    draw_rectangle(xx + 945, yy + 66, xx + 1580, yy + 818, 0);
    draw_set_alpha(1);
    draw_set_color(c_gray);
    draw_rectangle(xx + 945, yy + 66, xx + 1580, yy + 818, 1); // Right librarium box

    var _head = get_department_head(eCHAPTER_DEPARTMENTS.LIB);
    var _head_found = is_struct(_head);
    if (_head_found) {
        if (struct_exists(obj_ini.custom_advisors, "librarian")) {
            scr_image("advisor/splash", obj_ini.custom_advisors.librarian, xx + 16, yy + 43, 310, 828);
        } else {
            scr_image("advisor/splash", 4, xx + 16, yy + 43, 310, 828);
        }
        draw_set_halign(fa_left);
        draw_set_color(c_gray);
        draw_set_font(fnt_40k_30b);
        draw_text_transformed(xx + 352, yy + 66, "Librarium", 1, 1, 0);
        draw_text_transformed(xx + 352, yy + 100, _head.name_role(), 0.6, 0.6, 0);
        draw_set_font(fnt_40k_14);
    }
    if (menu_adept == 1) {
        scr_image("advisor/splash", 1, xx + 16, yy + 43, 310, 828);
        draw_set_halign(fa_left);
        draw_set_color(c_gray);
        draw_set_font(fnt_large);
        draw_text_transformed(xx + 352, yy + 66, "Librarium", 1, 1, 0);
        draw_text_transformed(xx + 352, yy + 100, $"Adept {obj_controller.adept_name}", 0.6, 0.6, 0);
        draw_set_font(fnt_40k_14);
    }

    // Set pace of recruitment based on training psyker value
    if (training_psyker >= 0 && training_psyker <= 6) {
        var _recruit_pace = global.recruitment_pace_descriptions;
        blurp += _recruit_pace[training_psyker];
    }

    var artif = "";

    if (unused_artifacts == 0) {
        artif = "no unused artifacts.";
    } else if (unused_artifacts == 1) {
        artif = "one unused artifact.";
    } else if (unused_artifacts > 1) {
        artif = string(unused_artifacts) + " unused artifacts.";
    }

    // Greetings message
    if (_head_found) {
        var _cm = cm_obj().get_struct();
        draw_text_ext(xx + 352, yy + 130, string_hash_to_newline($"{_cm.name_role()}, greetings.#I assume you've come for the report?  The Chapter currently possesses {temp[36]} Epistolaries, {temp[37]} Codiceries, and {temp[38]} Lexicanum.  We are working to identify additional warp-sensitive brothers before they cause harm, and the training is {blurp}.##We could likely speed up the identification and application of appropriate training, but we would need more resources...I don't suppose we can spare some?##Our Chapter has {artif}"), -1, 536);
    } else {
        draw_text_ext(xx + 352, yy + 130, string_hash_to_newline($"Your Chapter contains {temp[36]} {obj_ini.player_role_data[eROLE.LIBRARIAN].role}s, {temp[37]} Codiceries, and {temp[38]} Lexicanum.##Training of more {obj_ini.player_role_data[eROLE.LIBRARIAN].role}s is {blurp}.##Your chapter has {artif}"), -1, 536);
    }

    draw_set_color(#5F730D);
    draw_set_halign(fa_center);

    if (artifact_count() > 0) {
        var usey = 0;
        var _sorted_ids = get_sorted_artifact_ids();
        for (var i = 0, ilen = array_length(_sorted_ids); i < ilen; i++) {
            usey++;
            if (real(_sorted_ids[i]) == menu_artifact) {
                break;
            }
        }
        draw_text(xx + 622, yy + 440, $"[Artifact {usey} of {artifact_count()}]");

        if (scr_hit(xx + 342, yy + 426, xx + 903, yy + 818)) {
            var arrow_hovered = false;
            var scroll_engaged = false;
            var arrow = [
                xx + 400,
                yy + 437,
                xx + 445,
                yy + 461,
            ];
            if (scr_hit(arrow[0], arrow[1], arrow[2], arrow[3])) {
                arrow_hovered = true;
                if (mouse_button_clicked()) {
                    scroll_engaged = true;
                }
            }
            if (mouse_wheel_down()) {
                scroll_engaged = true;
            }

            if (scroll_engaged) {
                artifact_namer.allow_input = false;
                artifact_equip = new ShutterButton();
                artifact_gift = new ShutterButton();
                artifact_destroy = new ShutterButton();
                menu_artifact = get_adjacent_artifact_id(menu_artifact, -1);
            }
            if (arrow_hovered) {
                tooltip_draw("Click here or use mouse wheel to scroll the artifact list.");
            }

            arrow_hovered = false;
            scroll_engaged = false;
            arrow = [
                xx + 790,
                yy + 437,
                xx + 832,
                yy + 461,
            ];
            if (scr_hit(arrow[0], arrow[1], arrow[2], arrow[3])) {
                arrow_hovered = true;
                if (mouse_button_clicked()) {
                    scroll_engaged = true;
                }
            }
            if (mouse_wheel_up()) {
                scroll_engaged = true;
            }

            if (scroll_engaged) {
                artifact_namer.allow_input = false;
                artifact_equip = new ShutterButton();
                artifact_gift = new ShutterButton();
                artifact_destroy = new ShutterButton();
                menu_artifact = get_adjacent_artifact_id(menu_artifact, 1);
            }
            if (arrow_hovered) {
                tooltip_draw("Click on this arrow or use mouse wheel to scroll the artifact list.");
            }
        }

        var _cur_arti_for_name = fetch_artifact(menu_artifact);
        var artifact_name = _cur_arti_for_name.get_display_name();
        _cur_arti_for_name.set_custom_name(artifact_namer.draw(artifact_name));
        draw_sprite(spr_arrow, 0, xx + 403, yy + 433);
        draw_sprite(spr_arrow, 1, xx + 795, yy + 433);
    }

    pop_draw_return_values();
}

/// @desc Rebuilds the cached sorted artifact ID list (obj_controller.sorted_artifact_ids).
/// @returns {Array<String>} Sorted artifact IDs as strings
function build_sorted_artifact_ids() {
    var names = struct_get_names(obj_ini.artifact_map);
    array_sort(names, function(a, b) {
        return real(a) - real(b);
    });
    obj_controller.sorted_artifact_ids = names;
    return names;
}

/// @returns {Array<String>} Sorted artifact IDs as strings
function get_sorted_artifact_ids() {
    if (obj_controller.sorted_artifact_ids == undefined) {
        build_sorted_artifact_ids();
    }
    return obj_controller.sorted_artifact_ids;
}

function get_adjacent_artifact_id(current_id, direction) {
    var ids = get_sorted_artifact_ids();
    var pos = array_get_index(ids, string(current_id));

    if (direction == -1 && pos > 0) {
        return real(ids[pos - 1]);
    } else if (direction == 1 && pos < array_length(ids) - 1) {
        return real(ids[pos + 1]);
    }

    if (direction == -1) {
        return real(ids[array_length(ids) - 1]);
    } else {
        return real(ids[0]);
    }
}

function equip_artifact_popup_setup() {
    instance_destroy(obj_popup);
    /// @type {Asset.GMObject.obj_popup}
    var pop = instance_create(0, 0, obj_popup);
    pop.type = ePOPUP_TYPE.ARTIFACT_EQUIP;
    pop.cooldown = 8;
    with (pop) {
        target_company_radio(10000);
        main_slate = new DataSlate({
            style: "decorated",
            XX: 945,
            YY: 66,
            set_width: true,
            width: 635,
            height: 400,
        });
        companies_select.current_selection = -1;
        companies_select.YY = 110;
        cancel_button = new UnitButtonObject({
            x1: 945,
            y1: main_slate.YY + main_slate.height,
            style: "pixel",
            label: "Cancel",
        });
        var _weapon_slot_options = [
            {
                str1: "Weapon One",
                font: fnt_40k_14b,
                val: 0,
            },
            {
                str1: "Weapon Two",
                font: fnt_40k_14b,
                val: 0,
            },
        ];
        weapon_slot_select = new RadioSet(_weapon_slot_options, "Weapon slot", {
            max_width: 580,
            x1: 1200,
            y1: 130,
        });
        weapon_slot_select.current_selection = 0;
    }
}

/// @self Asset.GMObject.obj_popup
function equip_artifact_popup_draw() {
    var arti = fetch_artifact(obj_controller.menu_artifact);
    main_slate.draw_with_dimensions();
    draw_set_color(CM_GREEN_COLOR);
    draw_set_font(fnt_40k_14b);
    draw_set_halign(fa_center);
    draw_text(951 + 312, 48 + 26, $"Equip Artifact ({arti.get_display_name()})");
    draw_set_font(fnt_40k_12);
    draw_set_halign(fa_left);
    if (arti.get_type() == "weapon") {
        weapon_slot_select.draw();
    }

    companies_select.draw();
    if (companies_select.changed) {
        var _company_marines = collect_role_group("all", "", false, {companies: companies_select.current_selection});
        var _selec_data = {
            purpose_code: "artifact_equip",
            number: 1,
            purpose: $"Equip Artifact ({arti.get_type_name()})",
            artifact: obj_controller.menu_artifact,
            slot: weapon_slot_select.current_selection,
        };
        group_selection(_company_marines, _selec_data);
        instance_destroy();
    }

    if (cancel_button.draw()) {
        instance_destroy();
    }
}
