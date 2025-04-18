try {
	//TODO refactor this entire turd of a construct
	if (hide == true) {
		exit;
	}
	if (image == "debug") {
		size = 3;
	}

	var romanNumerals = scr_roman_numerals();
	var xx, yy;
	xx = __view_get(e__VW.XView, 0);
	yy = __view_get(e__VW.YView, 0);

	if (instance_exists(obj_fleet)) {
		exit;
	}

	if (type == 99) {
		draw_set_font(fnt_large);
		draw_set_halign(fa_center);
		draw_set_color(38144);

		if (!obj_controller.zoomed) {
			draw_text_transformed(__view_get(e__VW.XView, 0) + 320, __view_get(e__VW.YView, 0) + 60, "SELECT DESTINATION", 0.5, 0.5, 0);
		} else {
			draw_text_transformed(room_width / 2, 60 * 3, "SELECT DESTINATION", 1.5, 1.5, 0);
		}

		draw_set_halign(fa_left);
	} else if (type == 10) {
		target_comp += 1;
		draw_set_color(0);
		draw_set_alpha(target_comp / 60);
		draw_rectangle(0, 0, room_width, room_height, 0);
		draw_set_alpha(1);
		exit;
	} else if (((type == 9) || (type == 9.1)) && instance_exists(obj_controller)) {
		draw_sprite(spr_planet_screen, 0, xx + 231 + 314, yy + 112);
		draw_set_font(fnt_40k_14);
		draw_set_halign(fa_center);
		draw_set_color(c_gray);

		var ch = "", inq_hide = 0;
		if (type == 9) {
			if (array_contains(obj_ini.artifact_tags[obj_controller.menu_artifact], "inq")) {
				if (array_contains(obj_controller.quest, "artifact_loan")) {
					inq_hide = 1;
				}
				if (array_contains(obj_controller.quest, "artifact_return")) {
					inq_hide = 2;
				}
			}
		}
		var iter = 0, spacer = 0;
		for (var i = 2; i <= 8; i++) {
			draw_set_font(fnt_40k_14);
			draw_set_halign(fa_center);
			draw_set_color(c_gray);
			draw_set_alpha(0.33);
			if (i == 7) {
				continue;
			}
			if (obj_controller.known[i]) {
				draw_set_alpha(1);
			}
			spacer = iter * 40;
			ch = obj_controller.disposition[i] > 0 ? "+" : "";
			if (obj_controller.known[i] > 1) {
				draw_text(xx + 740, yy + 140 + spacer, $"{scr_faction_string_name(i)} ({ch}{obj_controller.disposition[i]})");
				// draw_text(xx+740,yy+140+spacer,$"{obj_controller.faction_title[i]}");
				iter++;
			} else {
				continue;
			}
			draw_line(xx + 239 + 420, yy + 162 + spacer, xx + 398 + 420, yy + 162 + spacer);
			if ((mouse_x >= xx + 240 + 420) && (mouse_x <= xx + 387 + 420)) {
				if ((mouse_y >= yy + 131 + spacer) && (mouse_y <= yy + 159 + spacer) && (obj_controller.known[i] > 1)) {
					if (i == eFACTION.Inquisition) {
						if ((inq_hide != 2) && (inq_hide == 1)) {
							continue;
						}
					}
					draw_set_alpha(0.33);
					draw_set_color(c_gray);
					draw_rectangle(xx + 240 + 420, yy + 135 + spacer, xx + 398 + 420, yy + 160 + spacer, 0);
					if (mouse_check_button_pressed(mb_left)) {
						giveto = i;
					}
				}
			}
		}
		draw_set_alpha(1);
		draw_set_color(38144);
		if (point_and_click(draw_unit_buttons([xx + 700, yy + 370], "Cancel", [1, 1], c_red))) {
			obj_controller.cooldown = 8000;
			instance_destroy();
			exit;
		}
		if ((giveto > 0) && (type == 9)) {
			var arti_index = obj_controller.menu_artifact;

			var artifact_struct = obj_ini.artifact_struct[arti_index];
			var cur_tags = obj_ini.artifact_tags[arti_index];

			// obj_controller.artifacts-=1; // this is done by delete_artifact() that is run later;

			obj_controller.cooldown = 10;
			if (obj_controller.menu_artifact > obj_controller.artifacts) {
				obj_controller.menu_artifact = obj_controller.artifacts;
			}

			obj_controller.menu = 20;
			obj_controller.diplomacy = giveto;
			obj_controller.force_goodbye = -1;
			var the = "";

			if ((giveto != 7) && (giveto != 10)) {
				the = "the ";
			}

			scr_event_log("", $"Artifact gifted to {the} {obj_controller.faction[giveto]}.");
			var is_daemon = artifact_struct.has_tag("daemonic");
			var is_chaos = artifact_struct.has_tag("chaos");
			if (inq_hide != 2) {
				with (obj_controller) {
					if ((!is_daemon) || ((diplomacy != 4) && (diplomacy != 5) && (diplomacy != 2))) {
						scr_dialogue("artifact_thanks");
					}
					if (is_daemon && ((diplomacy == 4) || (diplomacy == 5) || (diplomacy == 2))) {
						scr_dialogue("artifact_daemon");
					}
				}
			}
			if ((inq_hide == 2) && (obj_controller.diplomacy == 4)) {
				with (obj_controller) {
					scr_dialogue("artifact_returned");
				}
			}

            if (artifact_struct.has_tag("MINOR")) {
                obj_controller.disposition[giveto] = clamp(obj_controller.disposition[giveto] + 1, -100, 100);
            } else {
                var daemon_arts = function(faction, is_chaos, is_daemon) {
                    switch (faction) {
                        case eFACTION.Imperium:
                            if (is_daemon) {
                                var v = 0, ev = 0;
                                for (var v = 1; v < array_length(obj_controller.event); v++) {
                                    if (obj_controller.event[v] == "") {
                                        ev = v;
                                        break;
                                    }
                                }
                                obj_controller.event[ev] = "imperium_daemon";
                                obj_controller.event_duration[ev] = 1;
                                with (obj_star) {
                                    for (var i = 1; i <= planets; i++) {
                                        if (p_owner[i] == 2) {
                                            p_heresy[i] += choose(30, 40, 50, 60);
                                        }
                                    }
                                }
                            }
                            if (is_chaos) {
                                with (obj_star) {
                                    for (var i = 1; i <= planets; i++) {
                                        if ((p_owner[i] == 2) && (p_heresy[i] > 0)) {
                                            p_heresy[i] += 10;
                                        }
                                    }
                                }
                            }
                            break;
                        case eFACTION.Tau:
                            if (is_daemon) {
                                with (obj_star) {
                                    for (var i = 1; i <= planets; i++) {
                                        if (p_owner[i] == 8) {
                                            p_heresy[i] += 40;
                                        }
                                    }
                                }
                            }
                            break;
                    }
                }

                var specialmod = 0
                switch (giveto) {
                    case eFACTION.Imperium:
                        break;
                    case eFACTION.Mechanicus:
                        break;
                    case eFACTION.Inquisition:
                        if (inq_hide == 2) {
                            specialmod -= 1;
                        }

                        if (is_chaos) {
                            specialmod += 2;
                        }

                        if (is_daemon) {
                            specialmod += 4;
                        }
                        break;
                    case eFACTION.Ecclesiarchy:
                        if (!is_daemon) {
                            if (scr_has_adv("Reverent Guardians")) {
                                specialmod += 2;
                            }
                        } else {
                            specialmod -= 2;
                        }
                        break;
                    case eFACTION.Eldar:
                        if (scr_has_disadv("Tolerant")) {
                            specialmod += 1;
                        }
                        break;
                    case eFACTION.Tau:
                        if (scr_has_disadv("Tolerant")) {
                            specialmod += 1;
                        }
                        break;
                }

                daemon_arts(giveto, is_chaos, is_daemon)
                var tagmod = artifact_struct.artifact_faction_value(giveto);
                obj_controller.disposition[giveto] = clamp(obj_controller.disposition[giveto] + 2 + specialmod + tagmod, -100, 100);
            }

            // Need to modify ^^^^ based on if it is chaos or daemonic

            delete_artifact(arti_index);
            instance_destroy();
            exit;
        }
    }

	var zoom = 0;
	if (instance_exists(obj_controller)) {
		zoom = obj_controller.zoomed;
	}
	if (((zoom == 0) && (type <= 4)) || (type == 98)) {
		var widd, image_bot, y_scale_mod;
		image_bot = 0;
		y_scale_mod = 1;

		if ((size == 0) || (size == 2)) {
			sprite_index = spr_popup_medium;
			image_alpha = 0;
			widd = sprite_width - 50;
			draw_sprite_ext(spr_popup_medium, type, xx + ((1600 - sprite_width) / 2), yy + ((900 - sprite_height) / 2), 1, y_scale, 0, c_white, 1);
			if (image != "") {
				image_wid = 100;
				image_hei = 100;
			}
		} else if (size == 1) {
			sprite_index = spr_popup_small;
			image_alpha = 0;
			widd = sprite_width - 10;
			draw_sprite_ext(spr_popup_small, type, xx + ((1600 - sprite_width) / 2), yy + ((900 - sprite_height) / 2), 1, y_scale, 0, c_white, 1);
			if (image != "") {
				image_wid = 150;
				image_hei = 150;
			}
		} else if (size == 3) {
			var draw_y_scale = y_scale;
			sprite_index = spr_popup_large;
			image_alpha = 0;
			widd = sprite_width - 50;
			if (image == "debug") {
				y_scale_mod = 1.5;
				draw_y_scale = y_scale * y_scale_mod;
			}
			draw_sprite_ext(spr_popup_large, type, xx + ((1600 - sprite_width) / 2), yy + ((900 - sprite_height * y_scale_mod) / 2), 1, draw_y_scale, 0, c_white, 1);
			if (image != "") {
				image_wid = 200;
				image_hei = 200;
			}
		}

		if (image_wid > 0) {
			widd -= image_wid + 10;
		}

		var x1, y1;
		x1 = xx + ((1600 - sprite_width) / 2);
		y1 = yy + ((900 - sprite_height * y_scale_mod) / 2);

		draw_set_font(fnt_40k_14b);
		draw_set_halign(fa_center);
		draw_set_color(38144);

		if (fancy_title == 1) {
			draw_set_font(fnt_fancy);
			if (type == 1) {
				draw_set_color(255);
			}
		}
		draw_text_transformed(x1 + (sprite_width / 2), y1 + (sprite_height * 0.07), string_hash_to_newline(string(title)), 1.1, 1.1, 0);
		// draw_text(xx+320.5,yy+123.5,string(title));

		draw_set_font(fnt_40k_14);
		draw_set_halign(fa_left);
		draw_set_color(38144);

		if (instance_exists(obj_turn_end)) {
			if (obj_turn_end.popups > 0) {
				draw_text(x1 + 20, y1 + (sprite_height * 0.07), string_hash_to_newline(string(obj_turn_end.current_popup) + "/" + string(obj_turn_end.popups)));
			}
		}
		if (image == "debug") {
			draw_text_ext(x1 + 20, y1 + (sprite_height * 0.18), string_hash_to_newline(string(text)), -1, sprite_width - 40);
		} else if (image == "") {
			if (size == 1) {
				draw_text_ext(x1 + 5, y1 + (sprite_height * 0.18), string_hash_to_newline(string(text)), -1, widd);
			}
			if (size != 1) {
				draw_text_ext(x1 + 25, y1 + (sprite_height * 0.18), string_hash_to_newline(string(text)), -1, widd);
			}
			str_h = string_height_ext(string_hash_to_newline(string(text)), -1, widd) + (sprite_height * 0.18);
		} else if (image != "") {
			if (size == 1) {
				draw_text_ext(x1 + 15 + image_wid, y1 + (sprite_height * 0.18), string_hash_to_newline(string(text)), -1, widd);
			}
			if (size != 1) {
				draw_text_ext(x1 + 35 + image_wid, y1 + (sprite_height * 0.18), string_hash_to_newline(string(text)), -1, widd);
			}
			str_h = string_height_ext(string_hash_to_newline(string(text)), -1, widd) + (sprite_height * 0.18);
		}

		// if (image!="") then draw_text_ext(x1+126+150,y1+152,string(text),-1,384-150);
		// if (text2!="") then draw_text_ext(x1+126,y1+309,string(text2),-1,384);
		// TODO change this into an array in a function (like romanNumerals does in here)
		var img = -1;
		if (image == "") {
			img = -1;
		}
		if (image == "orks") {
			img = 0;
		}
		if (image == "tau") {
			img = 1;
		}
		if (image == "chaos") {
			img = 2;
		}
		if (image == "shadow") {
			img = 3;
		}
		if (image == "distinguished") {
			img = 4;
		}
		if (image == "tech_build") {
			img = 5;
		}
		if (image == "sororitas") {
			img = 6;
		}
		if (image == "angry") {
			img = 7;
		}
		if (image == "gene_bad") {
			img = 8;
		}
		if (image == "lost_warp") {
			img = 10;
		}
		if (image == "Warp") {
			img = 11;
		}
		if (image == "crusade") {
			img = 12;
		}
		if (image == "fuklaw") {
			img = 13;
		}
		if ((image == "artifact") || (image == "artifact2")) {
			img = 14;
		}
		if (image == "artifact_recovered") {
			img = 15;
		}
		if (image == "artifact_given") {
			img = 15;
		}
		if (image == "waaagh") {
			img = 16;
		}
		if (image == "shipyard") {
			img = 17;
		}
		if (image == "inquisition") {
			img = 18;
		}
		if (image == "succession") {
			img = 19;
		}
		if (image == "rogue_trader") {
			img = 20;
		}
		if (image == "necron_tomb") {
			img = 21;
		}
		if (image == "webber") {
			img = 22;
		}
		if (image == "spyrer") {
			img = 23;
		}
		if (image == "fortress") {
			img = 24;
		}
		if (image == "fortress_hive") {
			img = 25;
		}
		if (image == "fortress_death") {
			img = 26;
		}
		if (image == "fortress_ice") {
			img = 27;
		}
		if (image == "fortress_lava") {
			img = 28;
		}
		if (image == "fortress_dorf") {
			img = 29;
		}
		if (image == "exploding_ship") {
			img = 30;
		}
		if (image == "necron_cave") {
			img = 31;
		}
		if (image == "exterminatus_new") {
			img = 32;
		}
		if (image == "necron_tunnels_1") {
			img = 33;
		}
		if (image == "necron_tunnels_2") {
			img = 34;
		}
		if (image == "necron_tunnels_3") {
			img = 35;
		}
		if (image == "necron_army") {
			img = 36;
		}
		if (image == "harlequin") {
			img = 37;
		}
		if (image == "black_rage") {
			img = 39;
		}
		if (image == "exterminatus") {
			img = 40;
		}
		if (image == "stc") {
			img = 41;
		}
		if (image == "thallax") {
			img = 42;
		}
		if (image == "space_hulk_done") {
			img = 44;
		}
		if (image == "ancient_ruins") {
			img = 45;
		}
		if (image == "geneseed_lab") {
			img = 47;
		}
		if (image == "ruins_bunker") {
			img = 48;
		}
		if (image == "ruins_fort") {
			img = 49;
		}
		if (image == "ruins_ship") {
			img = 50;
		}
		if (image == "fallen") {
			img = 51;
		}
		if (image == "debug_banshee") {
			img = 52;
		}
		if (image == "mechanicus") {
			img = 53;
		}
		if (image == "chaos_cultist") {
			img = 54;
		}
		if (image == "chaos_symbol") {
			img = 55;
		}
		if (image == "chaos_messenger") {
			img = 56;
		}
		if (image == "event_feast") {
			img = 57;
		}
		if (image == "event_tournament") {
			img = 58;
		}
		if (image == "event_deathmatch") {
			img = 59;
		}
		if (image == "event_mass") {
			img = 60;
		}
		if (image == "event_ccult") {
			img = 61;
		}
		if (image == "event_crelic") {
			img = 62;
		}
		if (image == "event_march") {
			img = 63;
		}

		if ((img != -1) && (image != "") && (image_wid > 0)) {
			var sh = 999;
			if (size == 1) {
				sh = 24;
				scr_image("popup", img, x1 + 5, y1 + sh + 24, image_wid, image_hei);
			}
			if (size >= 2) {
				sh = 24;
				scr_image("popup", img, x1 + 25, y1 + sh + 24, image_wid, image_hei);
			}

			image_bot = (sprite_height * 0.07) + image_hei + 5;
		}

		if ((option1 != "") && (string_count("Servitors and Skitarii", option1) == 0)) {
			var tox = "1. " + string(option1);
			if (option2 != "") {
				tox += "#2. " + string(option2);
			}
			if (option3 != "") {
				tox += "#3. " + string(option3);
			}

			var top = y1 + 0.5 + (sprite_height * 0.6);
			if (str_h != 0) {
				top = y1 + str_h + 20;
			}
			if (image != "") {
				top = max(top, y1 + image_bot);
			}

			draw_text_ext(x1 + 25.5, top, string_hash_to_newline("  Choices:"), -1, widd);
			draw_text_ext(x1 + 25, top + 0.5, string_hash_to_newline("  Choices:"), -1, widd);

			var sz = 0, sz2 = 0, oy = y1, t8 = 0;
			if (str_h != 0) {
				y1 += str_h + 20;
				y1 -= sprite_height * 0.6;
			}

			y1 = top;

			if (option1 != "") {
				draw_text_ext(x1 + 25.5, y1 + 20, string_hash_to_newline("1. " + string(option1)), -1, widd);
			}

			sz = string_height_ext(string_hash_to_newline("1. " + string(option1)), -1, widd);
			if (option2 != "") {
				draw_text_ext(x1 + 25.5, y1 + 20 + sz, string_hash_to_newline("2. " + string(option2)), -1, widd);
			}

			sz2 = string_height_ext(string_hash_to_newline("1. " + string(option1)), -1, widd);
			sz2 += string_height_ext(string_hash_to_newline("2. " + string(option2)), -1, widd);
			if (option3 != "") {
				draw_text_ext(x1 + 25.5, y1 + 20 + sz2, string_hash_to_newline("3. " + string(option3)), -1, widd);
			}

			if (option1 != "") {
				t8 = (y1 + 20) + 5;
			}
			if (option2 != "") {
				t8 = (y1 + 20 + sz) + 5;
			}
			if (option3 == "") {
				t8 = (y1 + 20 + sz2 + string_height_ext(string_hash_to_newline("3. " + string(option3)), -1, widd)) + 5;
			}

			if ((option1 != "") && (mouse_x >= x1) && (mouse_y >= y1 + 21) && (mouse_x <= x1 + 30 + string_width_ext(string_hash_to_newline("1. " + string(option1)), -1, widd)) && (mouse_y < y1 + 39)) {
				option1enter = true;
				draw_sprite(spr_popup_select, 0, x1 + 8.5, y1 + 21);
				if (mouse_check_button(mb_left)) {
					press = 1;
				}
			} else {
				option1enter = false;
			}
			if ((option2 != "") && (mouse_x >= x1) && (mouse_y >= y1 + 21 + sz) && (mouse_x <= x1 + 30 + string_width_ext(string_hash_to_newline("2. " + string(option2)), -1, widd)) && (mouse_y < y1 + 39 + sz)) {
				option2enter = true;
				draw_sprite(spr_popup_select, 0, x1 + 8.5, y1 + 21 + sz);
				if (mouse_check_button(mb_left)) {
					press = 2;
				}
			} else {
				option2enter = false;
			}
			if ((option3 != "") && (mouse_x >= x1) && (mouse_y >= y1 + 21 + sz2) && (mouse_x <= x1 + 30 + string_width_ext(string_hash_to_newline("3. " + string(option3)), -1, widd)) && (mouse_y < y1 + 39 + sz2)) {
				option3enter = true;
				draw_sprite(spr_popup_select, 0, x1 + 8.5, y1 + 21 + sz2);
				if (mouse_check_button(mb_left)) {
					press = 3;
				}
			} else {
				option3enter = false;
			}
			if (image == "new_forge_master") {
				var new_master_image = false;
				if (pathway == "selection_options") {
					if (option1enter) {
						new_master_image = techs[charisma_pick].draw_unit_image();
						techs[charisma_pick].stat_display();
					} else if (option2enter) {
						new_master_image = techs[talent_pick].draw_unit_image();
						techs[talent_pick].stat_display();
					} else if (option3enter) {
						new_master_image = techs[experience_pick].draw_unit_image();
						techs[experience_pick].stat_display();
					}
					if (is_struct(new_master_image)) {
						new_master_image.draw(xx + 1208, yy + 210, true);
					}
				}
			}
			if (t8 < (oy + sprite_height)) {
				y_scale = t8 / (oy + sprite_height);
			}
			if (t8 > (oy + sprite_height)) {
				y_scale = t8 / (oy + sprite_height);
			}
		}
	}

	// ** Equip Artifact **
	if ((type == 8) && instance_exists(obj_controller)) {
		var x2 = xx + 951;
		var y2 = yy + 48;
		var before = target_comp;
		var temp_alpha = 1;
		arti = obj_ini.artifact_struct[obj_controller.menu_artifact];

		// draw_sprite(spr_popup_large,0,x2,y2);

		draw_set_font(fnt_40k_14b);
		draw_set_halign(fa_center);
		draw_set_color(c_gray);

		draw_text(x2 + 312, y2 + 26, $"Equip Artifact ({obj_ini.artifact[obj_controller.menu_artifact]})");
		// draw_text(x2+320.5,yy+123.5,"Equip Artifact ("+string(obj_ini.artifact[obj_controller.menu_artifact])+")");

		draw_set_font(fnt_40k_12);
		draw_set_halign(fa_left);
		draw_text(x2 + 31, y2 + 35, "Select Company:");

		// Draw HQ button
		temp_alpha = (target_comp == 0) ? 1 : 0.5;
		var hq_text = $"HQ";
		var hq_button = draw_unit_buttons([x2 + 60, y2 + 75, x2 + 60 + 60, y2 + 75 + 20], hq_text, [1, 1], , , fnt_40k_12, temp_alpha); // Position for HQ
		if (point_and_click(hq_button)) {
			target_comp = 0;
		}

		// Draw other company buttons
		for (var i = 1; i < 11; i++) {
			temp_alpha = (target_comp == i) ? 1 : 0.5;
			var item_text = $"{romanNumerals[i - 1]}";
			var x_offset = x2 + 141 + (81 * (i - (i < 6 ? 1 : 6)));
			var y_offset = y2 + (i < 6 ? 60 : 90);
			var company_button = draw_unit_buttons([x_offset, y_offset, x_offset + 60, y_offset + 20], item_text, [1, 1], , , fnt_40k_12, temp_alpha);
			if (point_and_click(company_button)) {
				target_comp = i;
			}
		}

		if (before != target_comp) {
			units = 0;
			with (obj_controller) {
				if (obj_popup.target_comp > 0) {
					scr_company_view(obj_popup.target_comp);
				}
				if (obj_popup.target_comp == 0) {
					scr_special_view(0);
				}
			}
			var i;
			i = -1;
			repeat (array_length(obj_controller.display_unit)) {
				i += 1;
				obj_controller.man_sel[i] = 0;
			}
			i = -1;
		}

		// Weapon slot buttons
		if (arti.determine_base_type() == "weapon") {
			draw_text(x2 + 30, y2 + 128, "Replace:");

			temp_alpha = (target_role == 1) ? 1 : 0.5;
			if (point_and_click(draw_unit_buttons([x2 + 150, y2 + 120, x2 + 150 + 120, y2 + 120 + 20], $"1st Weapon", [1, 1], , , fnt_40k_12, temp_alpha))) {
				target_role = 1;
			}

			temp_alpha = (target_role == 2) ? 1 : 0.5;
			if (point_and_click(draw_unit_buttons([x2 + 300, y2 + 120, x2 + 300 + 120, y2 + 120 + 20], $"2nd Weapon", [1, 1], , , fnt_40k_12, temp_alpha))) {
				target_role = 2;
			}
		} else {
			target_role = 3;
		}

		// Soldier list
		draw_set_font(fnt_40k_12);
		draw_rectangle(x2 + 29, y2 + 160, x2 + 569, y2 + 363 + 356, 1); // Main rectangle?
		scr_scrollbar(1520, 220, 1543, 761, 23, obj_controller.man_max, obj_controller.man_current);
		draw_rectangle(x2 + 569, y2 + 171, x2 + 592, y2 + 357 + 356, 1); // Inside of scroll
		draw_rectangle(x2 + 569, y2 + 150, x2 + 592, y2 + 378 + 356, 1); // Outside of scroll
		draw_sprite_stretched(spr_arrow, 2, x2 + 569, y2 + 150, 23, 22);
		draw_sprite_stretched(spr_arrow, 3, x2 + 569, y2 + 357 + 356, 23, 22);

		if (target_comp != -1) {
			var top, sel, temp1, temp2, temp3, temp4, temp5;
			temp1 = "";
			temp2 = "";
			temp3 = "";
			temp4 = "";
			temp5 = "";
			top = obj_controller.man_current;
			sel = top;
			var unit_x = x2;
			var unit_y = y2;
			var ma_ar, ma_we1, ma_we2, ma_ge, ma_mb, ttt;
			ma_ar = "";
			ma_we1 = "";
			ma_we2 = "";
			ma_ge = "";
			ma_mb = "";
			ttt = 0;

			repeat (min(obj_controller.man_max, 23)) {
				if (sel >= array_length(obj_controller.man)) {
					break;
				}
				if (obj_controller.man[sel] == "man") {
					var unit = obj_controller.display_unit[sel];
					temp1 = unit.name_role();
					temp2 = obj_controller.ma_loc[sel];
					if (obj_controller.ma_wid[sel] != 0) {
						temp2 += scr_roman_numerals()[obj_controller.ma_wid[sel] - 1];
					}
					if (obj_controller.ma_health[sel] >= 100) {
						temp3 = "Unwounded";
					}
					if ((obj_controller.ma_health[sel] >= 70) && (obj_controller.ma_health[sel] < 100)) {
						temp3 = "Lightly Wounded";
					}
					if ((obj_controller.ma_health[sel] >= 40) && (obj_controller.ma_health[sel] < 70)) {
						temp3 = "Wounded";
					}
					if ((obj_controller.ma_health[sel] >= 8) && (obj_controller.ma_health[sel] < 40)) {
						temp3 = "Badly Wounded";
					}
					if (obj_controller.ma_health[sel] < 8) {
						temp3 = "CRITICAL";
					}
					temp4 = string(obj_controller.ma_exp[sel]) + " exp";

					ma_ar = unit.armour();
					ma_we1 = unit.weapon_two();
					ma_we2 = unit.weapon_one();
					ma_ge = unit.gear();
					ma_mb = unit.mobility_item();
					ttt = 0;

					if (obj_controller.ma_gear[sel] != "") {
						temp5 = "((" + string(ma_ar) + " + " + string(ma_mb) + ")) | " + string(ma_we1) + " | " + string(ma_we2) + " + (" + string(ma_ge) + ")";
					}
					if (obj_controller.ma_gear[sel] == "") {
						temp5 = "((" + string(ma_ar) + " + " + string(ma_mb) + ")) | " + string(ma_we1) + " | " + string(ma_we2) + "";
					}
				}
				if (obj_controller.man[sel] == "vehicle") {
					temp1 = string(obj_controller.ma_role[sel]);
					temp2 = string(obj_controller.ma_loc[sel]);
					if (obj_controller.ma_wid[sel] != 0) {
						temp2 += scr_roman_numerals()[obj_controller.ma_wid[sel] - 1];
					}
					temp3 = "Undamaged";
					temp4 = "";
					temp5 = "(" + string(obj_controller.ma_wep1[sel]) + " | " + string(obj_controller.ma_wep2[sel]) + " | " + string(obj_controller.ma_gear[sel]) + ")";
				}

				if (obj_controller.man_sel[sel] == 0) {
					draw_set_color(c_black);
				}
				if (obj_controller.man_sel[sel] != 0) {
					draw_set_color(6052956);
				}
				draw_rectangle(unit_x + 29, unit_y + 150, unit_x + 569, unit_y + 175.4, 0);
				draw_set_color(c_gray);
				draw_rectangle(unit_x + 29, unit_y + 150, unit_x + 569, unit_y + 175.4, 1);

				// if (obj_controller.man[sel]="man") and (obj_controller.ma_promote[sel]>0) then draw_set_color(c_yellow);
				if (ma_ar == "") {
					draw_set_alpha(0.5);
				}
				draw_text_transformed(unit_x + 32, unit_y + 151, string_hash_to_newline(string(temp1)), 1, 1, 0);
				draw_text_transformed(unit_x + 32.5, unit_y + 151.5, string_hash_to_newline(string(temp1)), 1, 1, 0);
				draw_set_color(c_gray);
				draw_set_alpha(1);

				draw_text_transformed(unit_x + 271, unit_y + 151, string_hash_to_newline(string(temp2)), 1, 1, 0);
				if ((obj_controller.man[sel] == "man") && (obj_controller.ma_lid[sel] == -1)) {
					draw_text_transformed(unit_x + 271, unit_y + 151, string_hash_to_newline(string(temp2)), 1, 1, 0);
				}
				if ((obj_controller.man[sel] == "vehicle") && (obj_controller.ma_lid[sel] == -1)) {
					draw_text_transformed(unit_x + 271, unit_y + 151, string_hash_to_newline(string(temp2)), 1, 1, 0);
				}

				if (temp3 == "CRITICAL") {
					draw_set_color(c_red);
				}
				draw_text_transformed(unit_x + 400, unit_y + 151, string_hash_to_newline(string(temp3)), 1, 1, 0);
				draw_set_color(c_gray);

				draw_text_transformed(unit_x + 506, unit_y + 151, string_hash_to_newline(string(temp4)), 1, 1, 0);

				draw_set_color(c_gray);
				if (string_count("Artifact", temp5) > 0) {
					draw_set_color(881503);
				}
				draw_text_transformed(unit_x + 38, unit_y + 164, string_hash_to_newline(string(temp5)), 1, 1, 0);
				draw_set_color(38144);

				if (point_and_click([unit_x + 29, unit_y + 150, unit_x + 569, unit_y + 175.4])) {
					if (obj_controller.man_sel[sel] == 0) {
						units = 1;
						if (prev_selected != 0) {
							obj_controller.man_sel[prev_selected] = 0;
						}
						obj_controller.man_sel[sel] = 1;
						prev_selected = sel;
					} else if (obj_controller.man_sel[sel] == 1) {
						units = 0;
						obj_controller.man_sel[sel] = 0;
					}
				}
				unit_y += 25.4;
				sel += 1;
			}
		}

		if ((target_role > 0) && (target_comp != -1) && (units == 1)) {
			all_good = 1;
		} else {
			all_good = 0;
		}
		if (arti.determine_base_type() == "weapon" && target_role > 2) {
			all_good = 0;
		}

		// Screen bottom buttons and shit
		//
		var screen_bottom_x = x2;
		var screen_bottom_y = y2 + 350;
		draw_set_alpha(1);
		draw_set_font(fnt_small);
		draw_set_color(c_gray);
		draw_rectangle(screen_bottom_x + 121, screen_bottom_y + 393, screen_bottom_x + 231, screen_bottom_y + 414, 1);
		draw_set_alpha(0.5);
		draw_rectangle(screen_bottom_x + 122, screen_bottom_y + 394, screen_bottom_x + 230, screen_bottom_y + 413, 1);

		if (all_good == 1) {
			draw_set_alpha(1);
			draw_rectangle(screen_bottom_x + 408, screen_bottom_y + 393, screen_bottom_x + 518, screen_bottom_y + 414, 1);
			draw_set_alpha(0.5);
			draw_rectangle(screen_bottom_x + 409, screen_bottom_y + 394, screen_bottom_x + 517, screen_bottom_y + 413, 1);
		}
		if (all_good != 1) {
			draw_set_alpha(0.25);
			draw_rectangle(screen_bottom_x + 408, screen_bottom_y + 393, screen_bottom_x + 518, screen_bottom_y + 414, 1);
			draw_rectangle(screen_bottom_x + 409, screen_bottom_y + 394, screen_bottom_x + 517, screen_bottom_y + 413, 1);
		}

		draw_set_alpha(1);

		draw_set_halign(fa_center);
		draw_text(screen_bottom_x + 173, screen_bottom_y + 397, string_hash_to_newline("Cancel"));
		draw_text(screen_bottom_x + 173.5, screen_bottom_y + 397.5, string_hash_to_newline("Cancel"));

		if (all_good == 1) {
			draw_text(screen_bottom_x + 464, screen_bottom_y + 397, string_hash_to_newline("Equip!"));
			draw_text(screen_bottom_x + 464.5, screen_bottom_y + 397.5, string_hash_to_newline("Equip!"));
			if (point_and_click([screen_bottom_x + 430, screen_bottom_y + 393, screen_bottom_x + 518, screen_bottom_y + 414])) {
				obj_controller.cooldown = 8000;

				var i = -1, this = 0, dwarn = false, unit;
				var arti_index = obj_controller.menu_artifact;
				var arti = obj_ini.artifact_struct[arti_index];
				var arti_base = arti.type();
				repeat (min(obj_controller.man_max, 23)) {
					i += 1;
					if ((this == 0) && (obj_controller.man_sel[i] == 1)) {
						this = i;
					}
				}
				i = this;

				if ((obj_controller.man[i] != "") && obj_controller.man_sel[i]) {
					var replace = "";

					if (target_role == 1) {
						replace = "weapon1";
					}
					if (target_role == 2) {
						replace = "weapon2";
					}
					if (target_role > 2) {
						if (gear_weapon_data("armour", arti_base) != false) {
							replace = "armour";
						} else if (gear_weapon_data("gear", arti_base) != false) {
							replace = "gear";
						} else if (gear_weapon_data("mobility", arti_base) != false) {
							replace = "mobility";
						}
					}
					if ((replace == "armour") && (obj_controller.ma_race[i] > 5)) {
						cooldown = 8;
						obj_controller.cooldown = 8;
						exit;
					}

					if (target_comp > 10) {
						target_comp = 0;
					}

					unit = obj_ini.TTRPG[target_comp][obj_controller.ide[i]];
					if (arti.has_tag("daemonic") || arti.has_tag("chaos")) {
						unit.corruption += irandom(10 + 2);
						if (unit.role() == obj_ini.role[100][eROLE.ChapterMaster]) {
							dwarn = true;
						}
					}

					if (replace == "armour") {
						unit.update_armour(arti_index);
					} else if (replace == "gear") {
						unit.update_gear(arti_index);
					}
					if (replace == "mobility") {
						unit.update_mobility_item(arti_index);
					}
					if (replace == "weapon1") {
						unit.update_weapon_one(arti_index);
					}
					if (replace == "weapon2") {
						unit.update_weapon_two(arti_index);
					}
					var g = arti_index;
					obj_controller.cooldown = 10;

					//if (obj_controller.menu_artifact>obj_controller.artifacts) then obj_controller.menu_artifact=obj_controller.artifacts;
					if (dwarn == true) {
						var pip = instance_create(0, 0, obj_popup);
						pip.title = "Daemon Artifacts";
						pip.text = "Some artifacts, like the one you now wield, are a blasphemous union of the Materium's matter and the Immaterium's spirit, containing the essence of a bound daemon.  While they may offer great power, and enhanced perception, they are known to whisper poisonous lies to the wielder.  The path to damnation begins with good intentions, and many times artifacts such as these have been the cause.";
						pip.image = "";
						pip.cooldown = 8;
						obj_controller.cooldown = 8;
					}

					instance_destroy();
					exit;
				}
			}
		}
		if (all_good != 1) {
			draw_set_alpha(0.25);
			draw_text(screen_bottom_x + 464, screen_bottom_y + 397, "Equip!");
			draw_text(screen_bottom_x + 464.5, screen_bottom_y + 397.5, "Equip!");
		}
		draw_set_alpha(1);
	}

	var xx, yy;
	xx = __view_get(e__VW.XView, 0);
	yy = __view_get(e__VW.YView, 0);

	// Changing Equipment
	if ((zoom == 0) && (type == 6) && instance_exists(obj_controller)) {
		draw_set_color(0);
		draw_rectangle(xx + 1006, yy + 143, xx + 1577, yy + 518, 0);

		draw_set_font(fnt_40k_14b);
		draw_set_halign(fa_center);
		draw_set_color(c_gray);

		draw_text(xx + 1292, yy + 145, "Change Equipment");

		draw_set_font(fnt_40k_12);
		var comp = "";
		if (company <= 10 && company > 0) {
			comp = romanNumerals[company - 1];
		} else if (company > 10) {
			comp = "HQ";
		}

		if (vehicle_equipment == 0) {
			draw_text(xx + 1292, yy + 170, $"{comp} Company, {units} Marines");
		}
		if (vehicle_equipment == 1) {
			draw_text(xx + 1292, yy + 170, $"{comp} Company, {units} Vehicles");
		}

		draw_set_halign(fa_left);
		draw_set_color(c_gray);

		draw_rectangle(xx + 1010, yy + 215, xx + 1288, yy + 315, 1);
		draw_rectangle(xx + 1574, yy + 215, xx + 1296, yy + 315, 1);

		var show_name = "";
		// Need to not show the artifact tags here somehow

		draw_text(xx + 1010, yy + 195, "Before");
		draw_text(xx + 1010.5, yy + 195.5, "Before");

		show_name = o_wep1;
		if (a_wep1 != "") {
			show_name = a_wep1;
		}
		if (o_wep1 != "") {
			draw_text(xx + 1014, yy + 215, string_hash_to_newline(show_name));
		} else {
			draw_text(xx + 1014, yy + 215, ITEM_NAME_NONE);
		}

		show_name = o_wep2;
		if (a_wep2 != "") {
			show_name = a_wep2;
		}
		if (o_wep2 != "") {
			draw_text(xx + 1014, yy + 235, string_hash_to_newline(string(show_name)));
		} else {
			draw_text(xx + 1014, yy + 235, ITEM_NAME_NONE);
		}

		show_name = o_armour;
		if (a_armour != "") {
			show_name = a_armour;
		}
		if (o_armour != "") {
			draw_text(xx + 1014, yy + 255, string_hash_to_newline(string(show_name)));
		} else {
			draw_text(xx + 1014, yy + 255, ITEM_NAME_NONE);
		}

		show_name = o_gear;
		if (a_gear != "") {
			show_name = a_gear;
		}
		if (o_gear != "") {
			draw_text(xx + 1014, yy + 275, string_hash_to_newline(string(show_name)));
		} else {
			draw_text(xx + 1014, yy + 275, ITEM_NAME_NONE);
		}

		show_name = o_mobi;
		if (a_mobi != "") {
			show_name = a_mobi;
		}
		if (o_mobi != "") {
			draw_text(xx + 1014, yy + 295, string_hash_to_newline(string(show_name)));
		} else {
			draw_text(xx + 1014, yy + 295, ITEM_NAME_NONE);
		}

		draw_text(xx + 1296, yy + 195, string_hash_to_newline("After"));
		draw_text(xx + 1296.5, yy + 195.5, "After");

		draw_set_color(c_gray);
		if (n_good1 == 0) {
			draw_set_color(255);
		}
		show_name = n_wep1;
		if ((a_wep1 != "") && (n_wep1 == o_wep1)) {
			show_name = a_wep1;
		}
		if (n_wep1 != "") {
			draw_text(xx + 1300, yy + 215, string_hash_to_newline(string(show_name)));
		} else {
			draw_text(xx + 1300, yy + 215, string_hash_to_newline(ITEM_NAME_NONE));
		}

		draw_set_color(c_gray);
		if (n_good2 == 0) {
			draw_set_color(255);
		}
		show_name = n_wep2;
		if ((a_wep2 != "") && (n_wep2 == o_wep2)) {
			show_name = a_wep2;
		}
		if (n_wep2 != "") {
			draw_text(xx + 1300, yy + 235, string_hash_to_newline(string(show_name)));
		} else {
			draw_text(xx + 1300, yy + 235, string_hash_to_newline(ITEM_NAME_NONE));
		}

		draw_set_color(c_gray);
		if (n_good3 == 0) {
			draw_set_color(255);
		}
		show_name = n_armour;
		if ((a_armour != "") && (n_armour == o_armour)) {
			show_name = a_armour;
		}
		if (n_armour != "") {
			draw_text(xx + 1300, yy + 255, string_hash_to_newline(string(show_name)));
		} else {
			draw_text(xx + 1300, yy + 255, string_hash_to_newline(ITEM_NAME_NONE));
		}

		draw_set_color(c_gray);
		if (n_good4 == 0) {
			draw_set_color(255);
		}
		show_name = n_gear;
		if ((a_gear != "") && (n_gear == o_gear)) {
			show_name = a_gear;
		}
		if (n_gear != "") {
			draw_text(xx + 1300, yy + 275, string_hash_to_newline(string(show_name)));
		} else {
			draw_text(xx + 1300, yy + 275, string_hash_to_newline(ITEM_NAME_NONE));
		}

		draw_set_color(c_gray);
		if (n_good5 == 0) {
			draw_set_color(255);
		}
		show_name = n_mobi;
		if ((a_mobi != "") && (n_mobi == o_mobi)) {
			show_name = a_mobi;
		}
		if (n_mobi != "") {
			draw_text(xx + 1300, yy + 295, string_hash_to_newline(string(show_name)));
		} else {
			draw_text(xx + 1300, yy + 295, string_hash_to_newline(ITEM_NAME_NONE));
		}

		draw_set_color(c_gray);

		for (var i = 1; i <= 5; i++) {
			if (target_comp == i) {
				draw_text(xx + 1292, yy + 195 + (20 * i), "->");
				break;
			}
		}

		if ((mouse_x >= xx + 1296) && (mouse_x < xx + 1574)) {
			if ((mouse_y >= yy + 215) && (mouse_y < yy + 235)) {
				draw_set_alpha(0.5);
				draw_line(xx + 1296, yy + 230, xx + 1574, yy + 230);
			}
			if ((mouse_y >= yy + 235) && (mouse_y < yy + 255)) {
				draw_set_alpha(0.5);
				draw_line(xx + 1296, yy + 250, xx + 1574, yy + 250);
			}
			if ((mouse_y >= yy + 255) && (mouse_y < yy + 275)) {
				draw_set_alpha(0.5);
				draw_line(xx + 1296, yy + 270, xx + 1574, yy + 270);
			}
			if ((mouse_y >= yy + 275) && (mouse_y < yy + 295)) {
				draw_set_alpha(0.5);
				draw_line(xx + 1296, yy + 290, xx + 1574, yy + 290);
			}
			if ((mouse_y >= yy + 295) && (mouse_y < yy + 315)) {
				draw_set_alpha(0.5);
				draw_line(xx + 1296, yy + 310, xx + 1574, yy + 310);
			}
		}
		draw_set_alpha(1);

		if (target_comp != -1) {
			var check = " ";
			var mct = master_crafted == 1 ? 0.7 : 1;
			var column = 0;
			var row = 0;
			var item_string;
			var box = [];
			var box_x;
			var box_y;
			var top = -1;

			var selected_item_name = [n_wep1, n_wep2, n_armour, n_gear, n_mobi];
			selected_item_name = selected_item_name[target_comp - 1];

			for (var o = 0; o < array_length(item_name); o++) {
				box_x = xx + 1016 + (row * 154);
				box_y = yy + 355 + (column * 20);
				box = [box_x, box_y, box_x + 144, box_y + 20];
				check = selected_item_name == item_name[o] ? "x" : " ";
				item_string = $"[{check}] {item_name[o]}";
				draw_text_transformed(box_x, box_y, item_string, mct, 1, 0);

				if (point_and_click(box)) {
					top = o;
				}
				column++;
				if (column > 6) {
					column = 0;
					row++;
				}
			}

			if (top != -1) {
				warning = "";
				switch (target_comp) {
					case 1:
						n_wep1 = item_name[top];
						sel1 = top;
						break;
					case 2:
						n_wep2 = item_name[top];
						sel2 = top;
						break;
					case 3:
						n_armour = item_name[top];
						sel3 = top;
						break;
					case 4:
						n_gear = item_name[top];
						sel4 = top;
						break;
					case 5:
						n_mobi = item_name[top];
						sel5 = top;
						break;
				}
			}

			if (target_comp == 1 && (n_wep1 == ITEM_NAME_NONE || n_wep1 == "")) {
				n_good1 = 1;
			}
			if (target_comp == 2 && (n_wep2 == ITEM_NAME_NONE || n_wep2 == "")) {
				n_good2 = 1;
			}
			if (target_comp == 3 && (n_armour == ITEM_NAME_NONE || n_armour == "")) {
				n_good3 = 1;
			}
			if (target_comp == 4 && (n_gear == ITEM_NAME_NONE || n_gear == "")) {
				n_good4 = 1;
			}
			if (target_comp == 5 && (n_mobi == ITEM_NAME_NONE || n_mobi == "")) {
				n_good5 = 1;
			}

			var weapon_one_data = gear_weapon_data("weapon", n_wep1);
			var weapon_two_data = gear_weapon_data("weapon", n_wep2);
			var armour_data = gear_weapon_data("armour", n_armour);

			if ((target_comp == 1) && is_struct(weapon_one_data)) {
				// Check numbers
				req_wep1_num = units;
				have_wep1_num = 0;
				var i = -1;
				repeat (array_length(obj_controller.display_unit)) {
					i += 1;
					if ((vehicle_equipment != -1) && (obj_controller.ma_wep1[i] == n_wep1)) {
						have_wep1_num += 1;
					}
				}
				have_wep1_num += scr_item_count(n_wep1);
				if (have_wep1_num >= req_wep1_num || n_wep1 == ITEM_NAME_NONE) {
					n_good1 = 1;
				}
				if (have_wep1_num < req_wep1_num && (n_wep1 != ITEM_NAME_ANY && n_wep1 != ITEM_NAME_NONE)) {
					n_good1 = 0;
					warning = "Not enough " + string(n_wep1) + "; " + string(req_wep1_num - have_wep1_num) + " more are required.";
				}

				//TODO wrap this up in a function
				if (weapon_one_data.req_exp > 0) {
					var g = -1, exp_check = 0;
					for (var g = 0; g < array_length(obj_controller.display_unit); g++) {
						if (obj_controller.man_sel[g] == 1 && is_struct(obj_controller.display_unit[g])) {
							if (obj_controller.display_unit[g].experience < weapon_one_data.req_exp) {
								exp_check = 1;
								n_good1 = 0;
								warning = $"A unit must have {weapon_one_data.req_exp}+ EXP to use a {weapon_one_data.name}.";
								break;
							}
						}
					}
				}
				if (is_struct(armour_data)) {
					if (((!array_contains(armour_data.tags, "terminator")) && (!array_contains(armour_data.tags, "dreadnought"))) && (n_wep1 == "Assault Cannon")) {
						n_good1 = 0;
						warning = "Cannot use Assault Cannons without Terminator/Dreadnought Armour.";
					}
					if ((!array_contains(armour_data.tags, "dreadnought")) && (n_wep1 == "Close Combat Weapon")) {
						n_good1 = 0;
						warning = "Only " + string(obj_ini.role[100][6]) + " can use Close Combat Weapons.";
					}
				}
			}
			if ((target_comp == 2) && is_struct(weapon_two_data)) {
				// Check numbers
				req_wep2_num = units;
				have_wep2_num = 0;
				var i = -1;
				repeat (array_length(obj_controller.display_unit)) {
					i += 1;
					if ((vehicle_equipment != -1) && (obj_controller.ma_wep2[i] == n_wep2)) {
						have_wep2_num += 1;
					}
				}
				// req_wep2_num+=scr_item_count(n_wep2);
				have_wep2_num += scr_item_count(n_wep2);
				// req_wep2_num=units;

				if (have_wep2_num >= req_wep2_num || n_wep2 == ITEM_NAME_NONE) {
					n_good2 = 1;
				}
				if (have_wep2_num < req_wep2_num && (n_wep2 != ITEM_NAME_ANY && n_wep2 != ITEM_NAME_NONE)) {
					n_good2 = 0;
					warning = $"Not enough {n_wep2}; {req_wep2_num - have_wep2_num} more are required.";
				}
				//TODO standardise exp check
				if (weapon_two_data.req_exp > 0) {
					var g, exp_check;
					g = -1;
					exp_check = 0;
					for (var g = 0; g < array_length(obj_controller.display_unit); g++) {
						if (obj_controller.man_sel[g] == 1 && is_struct(obj_controller.display_unit[g])) {
							if (obj_controller.display_unit[g].experience < weapon_two_data.req_exp) {
								exp_check = 1;
								n_good1 = 0;
								warning = $"A unit must have {weapon_two_data.req_exp}+ EXP to use a {weapon_two_data.name}.";
								break;
							}
						}
					}
				}
				if (is_struct(armour_data)) {
					if (((!array_contains(armour_data.tags, "terminator")) && (!array_contains(armour_data.tags, "dreadnought"))) && (n_wep2 == "Assault Cannon")) {
						n_good2 = 0;
						warning = "Cannot use Assault Cannons without Terminator/Dreadnought Armour.";
					}
					if ((!array_contains(armour_data.tags, "dreadnought")) && (n_wep2 == "Close Combat Weapon")) {
						n_good2 = 0;
						warning = "Only " + string(obj_ini.role[100][6]) + " can use Close Combat Weapons.";
					}
					if (((string_count("Terminator", n_armour) > 0) || (string_count("Tartaros", n_armour) > 0) || (string_count("Dreadnought", n_armour) > 0)) && (n_mobi != "")) {
						n_good2 = 0;
					}
					if (((string_count("Terminator", o_armour) > 0) || (string_count("Tartaros", o_armour) > 0) || (string_count("Dreadnought", o_armour) > 0)) && (n_mobi != "")) {
						n_good2 = 0;
					}
				}
			}
			if ((target_comp == 3) && is_struct(armour_data)) {
				// Check numbers
				req_armour_num = units;
				have_armour_num = 0;
				var i;
				i = -1;
				repeat (array_length(obj_controller.display_unit)) {
					i += 1;
					if ((vehicle_equipment != -1) && (obj_controller.man_sel[i] == 1) && (obj_controller.ma_armour[i] == n_armour)) {
						have_armour_num += 1;
					}
				}
				have_armour_num += scr_item_count(n_armour);

				if (have_armour_num >= req_armour_num || n_armour == ITEM_NAME_NONE) {
					n_good3 = 1;
				}
				if (have_armour_num < req_armour_num && (n_armour != ITEM_NAME_ANY && n_armour != ITEM_NAME_NONE)) {
					n_good3 = 0;
					warning = $"Not enough {n_armour} : {units - have_armour_num} more are required.";
				}

				var g = -1, exp_check = 0;
				if (armour_data.has_tag("terminator")) {
					if (armour_data.req_exp > 0) {
						var g, exp_check;
						g = -1;
						exp_check = 0;
						for (var g = 0; g < array_length(obj_controller.display_unit); g++) {
							if (obj_controller.man_sel[g] == 1 && is_struct(obj_controller.display_unit[g])) {
								if (obj_controller.display_unit[g].experience < armour_data.req_exp) {
									exp_check = 1;
									n_good1 = 0;
									warning = $"A unit must have {armour_data.req_exp}+ EXP to use a {armour_data.name}.";
									break;
								}
							}
						}
					}
				}

				if ((string_count("Dread", o_armour) > 0) && (string_count("Dread", n_armour) == 0)) {
					n_good4 = 0;
					warning = "Marines may not exit Dreadnoughts.";
				}
			}
			if ((target_comp == 4) && (n_gear != "Assortment") && (n_gear != ITEM_NAME_NONE)) {
				// Check numbers
				req_gear_num = units;
				have_gear_num = 0;
				var i;
				i = -1;
				repeat (array_length(obj_controller.display_unit)) {
					i += 1;
					if ((vehicle_equipment != -1) && (obj_controller.man_sel[i] == 1) && (obj_controller.ma_gear[i] == n_gear)) {
						have_gear_num += 1;
					}
				}
				have_gear_num += scr_item_count(n_gear);

				if (have_gear_num >= req_gear_num || n_gear == ITEM_NAME_NONE) {
					n_good4 = 1;
				}
				if (have_gear_num < req_gear_num && (n_gear != ITEM_NAME_ANY && n_gear != ITEM_NAME_NONE)) {
					n_good4 = 0;
					warning = "Not enough " + string(n_gear) + "; " + string(units - req_gear_num) + " more are required.";
				}

				if ((n_gear != ITEM_NAME_NONE) && (n_gear != "") && (string_count("Dreadnought", n_armour) > 0)) {
					n_good4 = 0;
					warning = "Dreadnoughts may not use infantry equipment.";
				}
			}
			if ((target_comp == 5) && (n_mobi != "Assortment") && (n_mobi != ITEM_NAME_NONE)) {
				// Check numbers
				req_mobi_num = units;
				have_mobi_num = 0;
				var i;
				i = -1;
				repeat (array_length(obj_controller.display_unit)) {
					i += 1;
					if ((vehicle_equipment != -1) && (obj_controller.man_sel[i] == 1) && (obj_controller.ma_mobi[i] == n_mobi)) {
						have_mobi_num += 1;
					}
				}
				have_mobi_num += scr_item_count(n_mobi);

				if (have_mobi_num >= req_mobi_num || n_mobi == ITEM_NAME_NONE) {
					n_good5 = 1;
				}
				if (have_mobi_num < req_mobi_num && (n_mobi != ITEM_NAME_ANY && n_mobi != ITEM_NAME_NONE)) {
					n_good5 = 0;
					warning = "Not enough " + string(n_mobi) + "; " + string(units - req_mobi_num) + " more are required.";
				}

				var terminator_mobi = ["", "Servo-arm", "Servo-harness", "Conversion Beamer Pack"];
				if ((!array_contains(terminator_mobi, n_mobi)) && ((n_armour == "Terminator Armour") || (n_armour == "Tartaros"))) {
					n_good5 = 0;
					warning = "Cannot use this gear with Terminator Armour.";
				}

				if ((n_mobi != ITEM_NAME_NONE) && (n_mobi != "") && (n_armour == "Dreadnought")) {
					n_good5 = 0;
					warning = string(obj_ini.role[100][6]) + "s may not use mobility gear.";
				}
			}
		}

		draw_set_halign(fa_center);
		if ((target_comp == 1) || (target_comp == 2)) {
			var msc = " ";
			if (master_crafted == 1) {
				msc = "x";
			}
			if (tab == 1) {
				draw_text(xx + 1292, yy + 318, string_hash_to_newline("Tab 1 [x]    Tab 2 [ ]        Master-Crafted [" + string(msc) + "]"));
			}
			if (tab == 2) {
				draw_text(xx + 1292, yy + 318, string_hash_to_newline("Tab 1 [ ]    Tab 2 [x]        Master-Crafted [" + string(msc) + "]"));
			}
		}

		draw_set_color(255);
		draw_set_halign(fa_center);
		draw_text(xx + 1292, yy + 476, string_hash_to_newline(warning));

		draw_set_color(c_gray);
		draw_set_halign(fa_left);
		draw_rectangle(xx + 1006, yy + 499, xx + 1115, yy + 518, 1);
		draw_set_alpha(0.5);
		draw_rectangle(xx + 1007, yy + 500, xx + 1114, yy + 517, 1);

		if (n_good1 + n_good2 + n_good3 + n_good4 + n_good5 == 5) {
			draw_set_alpha(1);
			draw_rectangle(xx + 1465, yy + 499, xx + 1576, yy + 518, 1);
			draw_set_alpha(0.5);
			draw_rectangle(xx + 1466, yy + 500, xx + 1575, yy + 517, 1);
		}
		if (n_good1 + n_good2 + n_good3 + n_good4 + n_good5 != 5) {
			draw_set_alpha(0.25);
			draw_rectangle(xx + 1465, yy + 499, xx + 1576, yy + 518, 1);
			draw_rectangle(xx + 1466, yy + 500, xx + 1575, yy + 517, 1);
		}

		draw_set_alpha(1);
		draw_set_halign(fa_center);
		draw_text(xx + 1061, yy + 501, string_hash_to_newline("Cancel"));
		draw_text(xx + 1061.5, yy + 501.5, string_hash_to_newline("Cancel"));

		if (n_good1 + n_good2 + n_good3 + n_good4 == 4) {
			draw_text(xx + 1521, yy + 501, string_hash_to_newline("Equip!"));
			draw_text(xx + 1521.5, yy + 501.5, string_hash_to_newline("Equip!"));
		}
		if (n_good1 + n_good2 + n_good3 + n_good4 != 4) {
			draw_set_alpha(0.25);
			draw_text(xx + 1521, yy + 501, string_hash_to_newline("Equip!"));
			draw_text(xx + 1521.5, yy + 501.5, string_hash_to_newline("Equip!"));
		}
		draw_set_alpha(1);
	}

	// ** Promoting **
	if ((zoom == 0) && (type == 5) && instance_exists(obj_controller)) {
		draw_set_color(0);
		draw_rectangle(xx + 1006, yy + 143, xx + 1577, yy + 518, 0);

		draw_set_font(fnt_40k_14b);
		draw_set_halign(fa_center);
		draw_set_color(c_gray);
		draw_text(xx + 1292, yy + 145, string_hash_to_newline("Promoting"));

		draw_set_font(fnt_40k_12);
		var comp = "";
		if (company <= 10 && company > 0) {
			comp = romanNumerals[company - 1];
		} else if (company > 10) {
			comp = "HQ";
		}
		draw_text(xx + 1292, yy + 170, string_hash_to_newline(string(comp) + " Company " + string(unit_role)));

		draw_set_halign(fa_left);
		draw_set_color(c_gray);
		draw_text(xx + 1014, yy + 210, string_hash_to_newline("Target Company:"));

		var check = " ";
		draw_set_alpha(1);

		// HQ Company
		if ((target_comp == 0) || (target_comp > 10)) {
			check = "x";
		}
		draw_text(xx + 1470, yy + 210, string_hash_to_newline("HQ [" + string(check) + "]"));
		check = " ";
		// if (obj_controller.command_set[1]!=0 && !is_specialist(unit_role, SPECIALISTS_LIBRARIANS)){
		for (i = 1; i <= 10; i++) {
			var comp_data = company_promote_data[i - 1];
			if (obj_controller.command_set[2] == 1) {
				//cecks if exp requirements are activated
				if (min_exp < comp_data[2]) {
					draw_set_alpha(0.6);
				}
			}
			check = " ";
			if (target_comp == i) {
				check = "x";
			}
			var select_text = $"{romanNumerals[i - 1]} [{check}]";
			draw_text(xx + comp_data[0], yy + comp_data[1], select_text);
			if (mouse_check_button_pressed(mb_left) && point_in_rectangle(mouse_x, mouse_y, xx + comp_data[0], yy + comp_data[1], xx + comp_data[0] + 90, yy + comp_data[1] + 20)) {
				target_comp = i;
				target_role = 0;
				get_unit_promotion_options();
				cooldown = 8000;
			}
		}
		// }

		draw_text(xx + 1014, yy + 290, string_hash_to_newline("Target Role:")); //choose new role
		var role_x = 0;
		role_y = 0;
		if (target_comp != -1) {
			for (var r = 1; r <= 11; r++) {
				if (role_name[r] != "") {
					draw_set_alpha(1);
					check = " ";
					if (target_role == r) {
						check = "x";
					}
					if (min_exp < role_exp[r]) {
						draw_set_alpha(0.25);
					}
					draw_text(xx + 1030 + role_x, yy + 310 + role_y, string_hash_to_newline(string(role_name[r]) + " [" + string(check) + "]"));
					if (mouse_check_button_pressed(mb_left) && point_in_rectangle(mouse_x, mouse_y, xx + 1030 + role_x, yy + 310 + role_y, xx + 1180 + role_x, yy + 330 + role_y)) {
						if (min_exp >= role_exp[r]) {
							target_role = r;
							calculate_equipment_needs();
							all_good = 1;
							cooldown = 8;
						}
					}
					if (r % 3 == 0) {
						role_y += 20;
						role_x = 0;
					} else {
						role_x += 170;
					}
				}
			}
		}

		draw_set_alpha(1);

		draw_text(xx + 1014, yy + 370, string_hash_to_newline("Required Gear:"));
		var gr = 0, tox = "";

		if (target_role > 0) {
			if (req_armour != "") {
				gr = req_armour_num - have_armour_num;
				tox = "";
				if (gr > 0) {
					draw_set_color(c_red);
				} else {
					draw_set_color(c_gray);
				}
				draw_text(xx + 1030, yy + 390, $"{req_armour_num} {req_armour} (Have {have_armour_num})");
			}
			if (req_gear != "") {
				gr = req_gear_num - have_gear_num;
				tox = "";
				if (gr > 0) {
					draw_set_color(c_red);
				} else {
					draw_set_color(c_gray);
				}
				draw_text(xx + 1030, yy + 410, $"{req_gear_num} {req_gear} (Have {have_gear_num})");
			}
			if (req_mobi != "") {
				gr = req_mobi_num - have_mobi_num;
				tox = "";
				if (gr > 0) {
					draw_set_color(c_red);
				} else {
					draw_set_color(c_gray);
				}
				draw_text(xx + 1030, yy + 430, $"{req_mobi_num} {req_mobi} (Have {have_mobi_num})");
			}
			if (req_wep1 != "") {
				gr = req_wep1_num - have_wep1_num;
				tox = "";
				if (gr > 0) {
					draw_set_color(c_red);
				} else {
					draw_set_color(c_gray);
				}
				draw_text(xx + 1260, yy + 390, $"{req_wep1_num} {req_wep1} (Have {have_wep1_num})");
			}
			if (req_wep2 != "") {
				gr = req_wep2_num - have_wep2_num;
				tox = "";
				if (gr > 0) {
					draw_set_color(c_red);
				} else {
					draw_set_color(c_gray);
				}
				draw_text(xx + 1260, yy + 410, $"{req_wep2_num} {req_wep2} (Have {have_wep2_num})");
			}
		}

		draw_set_alpha(1);

		draw_set_color(c_gray);
		draw_set_halign(fa_left);
		draw_rectangle(xx + 1006, yy + 499, xx + 1115, yy + 518, 1);
		draw_set_alpha(0.5);
		draw_rectangle(xx + 1007, yy + 500, xx + 1114, yy + 517, 1);

		if (all_good == 1) {
			draw_set_alpha(1);
			draw_rectangle(xx + 1465, yy + 499, xx + 1576, yy + 518, 1);
			draw_set_alpha(0.5);
			draw_rectangle(xx + 1466, yy + 500, xx + 1575, yy + 517, 1);
		}
		if (all_good != 1) {
			draw_set_alpha(0.25);
			draw_rectangle(xx + 1465, yy + 499, xx + 1576, yy + 518, 1);
			draw_rectangle(xx + 1466, yy + 500, xx + 1575, yy + 517, 1);
		}

		draw_set_alpha(1);
		draw_set_halign(fa_center);
		draw_text(xx + 1061, yy + 501, string_hash_to_newline("Cancel"));
		draw_text(xx + 1061.5, yy + 501.5, string_hash_to_newline("Cancel"));

		if (all_good == 1) {
			draw_text(xx + 1521, yy + 501, string_hash_to_newline("Promote!"));
			draw_text(xx + 1521.5, yy + 501.5, string_hash_to_newline("Promote!"));
		}
		if (all_good != 1) {
			draw_set_alpha(0.25);
			draw_text(xx + 1521, yy + 501, string_hash_to_newline("Promote!"));
			draw_text(xx + 1521.5, yy + 501.5, string_hash_to_newline("Promote!"));
		}
		draw_set_alpha(1);
	}

	// ** Transfering **
	if ((zoom == 0) && (type == 5.1) && instance_exists(obj_controller)) {
		draw_set_color(0);
		draw_rectangle(xx + 1006, yy + 143, xx + 1577, yy + 518, 0);

		draw_set_font(fnt_40k_14b);
		draw_set_halign(fa_center);
		draw_set_color(c_gray);
		draw_text(xx + 1292, yy + 145, string_hash_to_newline("Transfering"));

		draw_set_font(fnt_40k_12);
		var comp = "";
		if (company <= 10 && company > 0) {
			comp = romanNumerals[company - 1];
		} else if (company > 10) {
			comp = "HQ";
		}
		draw_text(xx + 1292, yy + 170, string_hash_to_newline(string(comp) + " Company " + string(unit_role)));

		draw_set_halign(fa_left);
		draw_set_color(c_gray);
		draw_text(xx + 1014, yy + 210, string_hash_to_newline("Target Company:"));

		var check = " ";
		// HQ Company
		if ((target_comp == 0) || (target_comp > 10)) {
			check = "x";
		}
		draw_text(xx + 1470, yy + 210, string_hash_to_newline("HQ [" + string(check) + "]"));
		check = " ";

		if (((unit_role != obj_ini.role[100, 17]) || (obj_controller.command_set[1] != 0)) && (unit_role != "Lexicanum") && (unit_role != "Codiciery")) {
			// I Company
			if (target_comp == 1) {
				check = "x";
			}
			draw_text(xx + 1030, yy + 230, string_hash_to_newline(romanNumerals[0] + " [" + string(check) + "]"));
			check = " ";
			// II Company
			if (target_comp == 2) {
				check = "x";
			}
			draw_text(xx + 1140, yy + 230, string_hash_to_newline(romanNumerals[1] + " [" + string(check) + "]"));
			check = " ";
			// III Company
			if (target_comp == 3) {
				check = "x";
			}
			draw_text(xx + 1250, yy + 230, string_hash_to_newline(romanNumerals[2] + " [" + string(check) + "]"));
			check = " ";
			// IV Company
			if (target_comp == 4) {
				check = "x";
			}
			draw_text(xx + 1360, yy + 230, string_hash_to_newline(romanNumerals[3] + " [" + string(check) + "]"));
			check = " ";
			// V Company
			if (target_comp == 5) {
				check = "x";
			}
			draw_text(xx + 1470, yy + 230, string_hash_to_newline(romanNumerals[4] + " [" + string(check) + "]"));
			check = " ";
			// VI Company
			if (target_comp == 6) {
				check = "x";
			}
			draw_text(xx + 1030, yy + 250, string_hash_to_newline(romanNumerals[5] + " [" + string(check) + "]"));
			check = " ";
			// VII Company
			if (target_comp == 7) {
				check = "x";
			}
			draw_text(xx + 1140, yy + 250, string_hash_to_newline(romanNumerals[6] + " [" + string(check) + "]"));
			check = " ";
			// VIII Company
			if (target_comp == 8) {
				check = "x";
			}
			draw_text(xx + 1250, yy + 250, string_hash_to_newline(romanNumerals[7] + " [" + string(check) + "]"));
			check = " ";
			// IX Company
			if (target_comp == 9) {
				check = "x";
			}
			draw_text(xx + 1360, yy + 250, string_hash_to_newline(romanNumerals[8] + " [" + string(check) + "]"));
			check = " ";
			// X Company
			if (target_comp == 10) {
				check = "x";
			}
			draw_text(xx + 1470, yy + 250, string_hash_to_newline(romanNumerals[9] + " [" + string(check) + "]"));
			check = " ";
		}

		draw_set_alpha(1);

		draw_set_color(c_gray);
		draw_set_halign(fa_left);
		draw_rectangle(xx + 1006, yy + 499, xx + 1115, yy + 518, 1);
		draw_set_alpha(0.5);
		draw_rectangle(xx + 1007, yy + 500, xx + 1114, yy + 517, 1);

		if ((company != target_comp) && (target_comp >= 0)) {
			draw_set_alpha(1);
			draw_rectangle(xx + 1465, yy + 499, xx + 1576, yy + 518, 1);
			draw_set_alpha(0.5);
			draw_rectangle(xx + 1466, yy + 500, xx + 1575, yy + 517, 1);
		}
		if ((company == target_comp) || (target_comp < 0)) {
			draw_set_alpha(0.25);
			draw_rectangle(xx + 1465, yy + 499, xx + 1576, yy + 518, 1);
			draw_rectangle(xx + 1466, yy + 500, xx + 1575, yy + 517, 1);
		}

		draw_set_alpha(1);
		draw_set_halign(fa_center);
		draw_text(xx + 1061, yy + 501, "Cancel");
		draw_text(xx + 1061.5, yy + 501.5, "Cancel");

		if ((company != target_comp) && (target_comp >= 0)) {
			draw_text(xx + 1521, yy + 501, "Transfer!");
			draw_text(xx + 1521.5, yy + 501.5, "Transfer!");
		}
		if ((company == target_comp) || (target_comp < 0)) {
			draw_set_alpha(0.25);
			draw_text(xx + 1521, yy + 501, "Transfer!");
			draw_text(xx + 1521.5, yy + 501.5, "Transfer!");
		}
		draw_set_alpha(1);
	}

	if (type == "duel") {}
} catch (_exception) {
	handle_exception(_exception);
    instance_destroy();
}
