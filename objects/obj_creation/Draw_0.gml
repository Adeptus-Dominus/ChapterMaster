try {
	//read
	// 850,860

	var xx, yy;
	xx = 375;
	yy = 10;

	tooltip = "";
	tooltip2 = "";
	draw_set_alpha(1);
	// draw_sprite(spr_creation_slate,0,xx,yy);
	scr_image("creation/slate", 1, xx, yy, 850, 860);
	draw_set_alpha(1 - (slate1 / 30));
	// draw_sprite(spr_creation_slate,1,xx,yy);
	scr_image("creation/slate", 2, xx, yy, 850, 860);

	draw_set_color(5998382);
	if (slate2 > 0) {
		if (slate2 <= 10) {
			draw_set_alpha(slate2 / 10);
		}
		if (slate2 > 10) {
			draw_set_alpha(1 - ((slate2 - 10) / 10));
		}
		draw_line(xx + 30, yy + 70 + (slate2 * 36), xx + 790, yy + 70 + (slate2 * 36));
	}
	if (slate3 > 0) {
		if (slate3 <= 10) {
			draw_set_alpha(slate3 / 10);
		}
		if (slate3 > 10) {
			draw_set_alpha(1 - ((slate3 - 10) / 10));
		}
		draw_line(xx + 30, yy + 70 + (slate3 * 36), xx + 790, yy + 70 + (slate3 * 36));
	}

	allow_colour_click = (custom > 1) && (!instance_exists(obj_creation_popup));

	draw_set_alpha(slate4 / 30);
	if (slate4 > 0) {
		/* Chapter Selection grid */
		if (slide == eCREATIONSLIDES.CHAPTERSELECT) {
			draw_chapter_select()
		};
	}

	var yar;
	yar = 0;

	if (slide >= 2) {
		tooltip = "";
		tooltip2 = "";

		if (goto_slide != 1) {
			if (custom == 2) {
				draw_sprite(spr_creation_other, 4, 0, 68);
			}
			if (custom == 1) {
				draw_sprite(spr_creation_other, 5, 0, 68);
			}

			draw_set_color(38144);
			draw_rectangle(0, 68, 374, 781, 1);
		}

		draw_set_color(0);

		var sprx = 436, spry = 74, sprw = 128, sprh = 128;
		if (global.chapter_icon.sprite != -1){
			draw_sprite_stretched(global.chapter_icon.sprite, 0, sprx, spry, sprw, sprh);
		} else {
			// red (?)
			draw_sprite_stretched(global.chapter_icons_map[? "unknown"], 0, sprx, spry, sprw, sprh);
		}

		obj_cursor.image_index = 0;
		if (scr_hit(436, 74, 436 + 128, 74 + 128) && (popup == "")) {
			obj_cursor.image_index = 1;
			tooltip = "Chapter Icon";
			tooltip2 = "Your Chapter's icon.  Click to edit.";
		}

		if (slide == eCREATIONSLIDES.CHAPTERTRAITS) {
			var _chapter_icon;
			if (founding == ePROGENITOR.NONE) {
				_chapter_icon = global.chapter_icons_map[? "unknown"];
			} else if (founding == ePROGENITOR.RANDOM) {
				_chapter_icon = global.chapter_icons_map[? "random"]
			} else {
				_chapter_icon = global.chapter_icons_map[? founding_chapters[founding - 1].icon_name];
			}

			draw_set_alpha(0.33);
			draw_sprite_stretched(_chapter_icon, 0, 1164 - 128, 74, 128, 128);
			draw_set_alpha(1);

			draw_set_font(fnt_40k_30b);
			if (scr_hit(1164 - 128, 74, 1164, 74 + 128)) {
				tooltip = "Founding Chapter";
				tooltip2 = "The parent Chapter whos Gene-Seed your own originates from.";
			}

			if (custom > 1) {
				draw_sprite_stretched(spr_creation_arrow, 0, 1164 - 194, 160, 32, 32);
				draw_sprite_stretched(spr_creation_arrow, 1, 1164 - 144, 160, 32, 32);

				if (scr_hit(1164 - 194, 149, 1164 - 162, 193)) {
					obj_cursor.image_index = 1;
					if (scr_click_left()) {
						founding--;
						if (founding == -1) {
							founding = ePROGENITOR.RANDOM;
						}
					}
				}
				if (scr_hit(1164 - 144, 149, 1164 - 112, 193)) {
					obj_cursor.image_index = 1;
					if (scr_click_left()) {
						founding++;
						if (founding == 11) {
							founding = ePROGENITOR.NONE;
						}
					}
				}
			}
		}
	}

	/* Chapter Naming, Points assignment, advantages/disadvantages */
	if (slide == eCREATIONSLIDES.CHAPTERTRAITS) {
		draw_chapter_trait_select()
	}

	/* Homeworld, Flagship, Psychic discipline, Aspirant Trial */

	else if (slide == eCREATIONSLIDES.CHAPTERHOME){
		draw_chapter_homeworld_select()
	}

	/* Livery, Roles */

	else if (slide == eCREATIONSLIDES.CHAPTERLIVERY) {
		scr_livery_setup();
	}

	/* Gene Seed Mutations, Disposition */

	else if (slide == eCREATIONSLIDES.CHAPTERGENE) {
		draw_set_color(38144);
		draw_set_font(fnt_40k_30b);
		draw_set_halign(fa_center);
		draw_set_alpha(1);

		tooltip = "";
		tooltip2 = "";
		obj_cursor.image_index = 0;

		draw_text(800, 80, string_hash_to_newline(string(chapter_name)));

		draw_set_color(38144);
		draw_set_halign(fa_left);
		draw_text_transformed(580, 118, string_hash_to_newline("Successor Chapters: " + string(successors)), 0.6, 0.6, 0);
		draw_set_font(fnt_40k_14b);

		draw_rectangle(445, 200, 1125, 202, true);

		draw_set_halign(fa_center);
		draw_set_font(fnt_40k_30b);
		draw_text_transformed(800, 210, string_hash_to_newline("Gene-Seed Mutations"), 0.6, 0.6, 0);
		if (purity == 10) {
			draw_text_transformed(800, 230, $"The gene-seed is perfectly pure", 0.5, 0.5, 0);
		} else {
			if (mutations > mutations_selected) {
				draw_text_transformed(800, 230, $"Select {mutations - mutations_selected} more, according to your purity score", 0.5, 0.5, 0);
			} else {
				draw_text_transformed(800, 230, $"The gene-seed is mutated enough", 0.5, 0.5, 0);
				draw_set_alpha(0.5);
			}
		}
		draw_set_halign(fa_left);

		var x1, y1, spac = 34;

		if (custom < 2 || purity == 10) {
			draw_set_alpha(0.5);
		}
		var mutations_defects = [{
			t_tip: "Anemic Preomnor",
			t_tip2: "Your Astartes lack the detoxifying gland called the Preomnor- they are more susceptible to poisons and toxins.",
			data: preomnor,
			mutation_points: 1
		}, {
			t_tip: "Disturbing Voice",
			t_tip2: "Your Astartes have a voice like a creaking door or a rumble.  Decreases Imperium and Imperial Guard disposition.",
			data: voice,
			mutation_points: 1,
			disposition: [
				[eFACTION.Imperium, -8]
			]
		}, {
			t_tip: "Doomed",
			t_tip2: "Your Chapter cannot make more Astartes until enough research is generated.  Counts as four mutations.",
			data: doomed,
			mutation_points: 4,
			disposition: [
				[eFACTION.Imperium, -8],
				[6, 8]
			]
		}, {
			t_tip: "Faulty Lyman's Ear",
			t_tip2: "Lacking a working Lyman's ear, all deep-striked Astartes receive moderate penalties to both attack and defense.",
			data: lyman,
			mutation_points: 1
		}, {
			t_tip: "Hyper-Stimulated Omophagea",
			t_tip2: "After every battle the Astartes have a chance to feast upon their fallen enemies, or seldom, their allies.",
			data: omophagea,
			mutation_points: 1
		}, {
			t_tip: "Hyperactive Ossmodula",
			t_tip2: "Instead of wound tissue bone is generated; Apothecaries must spend twice the normal time healing your Astartes.",
			data: ossmodula,
			mutation_points: 1
		}, {
			t_tip: "Lost Zygote",
			t_tip2: "One of the Zygotes is faulty or missing.  The Astartes only have one each and generate half the normal Gene-Seed.",
			data: zygote,
			mutation_points: 2
		}, {
			t_tip: "Inactive Sus-an Membrane",
			t_tip2: "Your Astartes do not have a Sus-an Membrane; they cannot enter suspended animation and receive more casualties as a result.",
			data: membrane,
			mutation_points: 1
		}, {
			t_tip: "Missing Betchers Gland",
			t_tip2: "Your Astartes cannot spit acid, and as a result, have slightly less attack in melee combat.",
			data: betchers,
			mutation_points: 1
		}, {
			t_tip: "Mutated Catalepsean Node",
			t_tip2: "Your Astartes have reduced awareness when tired. Slightly less attack in ranged and melee combat.",
			data: catalepsean,
			mutation_points: 1
		}, {
			t_tip: "Oolitic Secretions",
			t_tip2: "Either by secretions or radiation, your Astartes have an unusual or strange skin color.  Decreases disposition.",
			data: secretions,
			mutation_points: 1,
			disposition: [
				[eFACTION.Imperium, -8]
			]
		}, {
			t_tip: "Oversensitive Occulobe",
			t_tip2: "Your Astartes are no longer immune to stun grenades, bright lights, and have a massive penalty during morning battles.",
			data: occulobe,
			mutation_points: 1,
			disposition: [
				[eFACTION.Imperium, -8]
			]
		}, {
			t_tip: "Rampant Mucranoid",
			t_tip2: "Your Astartes' Mucranoid cannot be turned off; the slime lowers most dispositions and occasionally damages their armour.",
			data: mucranoid,
			mutation_points: 1,
			disposition: [
				[1, -4],
				[eFACTION.Imperium, -8],
				[3, -4],
				[4, -4],
				[5, -4],
				[6, -4]
			]
		}];
		x1 = 450;
		y1 = 260;
		for (var i = 0; i < array_length(mutations_defects); i++) {
			mutation_data = mutations_defects[i];
			draw_sprite(spr_creation_check, mutation_data.data, x1, y1);
			if (point_and_click([x1, y1, x1 + 32, y1 + 32]) && allow_colour_click) {
				var onceh = 0;
				if (mutation_data.data) {
					mutation_data.data = 0;
					mutations_selected -= mutation_data.mutation_points;
					if (struct_exists(mutation_data, "disposition")) {
						for (var s = 0; s < array_length(mutation_data.disposition); s++) {
							disposition[mutation_data.disposition[s][0]] -= mutation_data.disposition[s][1];
						}
					}
				} else if ((!mutation_data.data) && (mutations > mutations_selected)) {
					mutation_data.data = 1;
					mutations_selected += mutation_data.mutation_points;
					if (struct_exists(mutation_data, "disposition")) {
						for (var s = 0; s < array_length(mutation_data.disposition); s++) {
							disposition[mutation_data.disposition[s][0]] += mutation_data.disposition[s][1];
						}
					}
				}
			}
			draw_text_transformed(x1 + 30, y1 + 4, mutation_data.t_tip, 0.4, 0.4, 0);
			if (scr_hit(x1, y1, x1 + 250, y1 + 20)) {
				tooltip = mutation_data.t_tip;
				tooltip2 = mutation_data.t_tip2;
			}
			y1 += spac;
			if (i == 6) {
				x1 = 750;
				y1 = 260;
			}
		}
		preomnor = mutations_defects[0].data;
		voice = mutations_defects[1].data;
		doomed = mutations_defects[2].data;
		lyman = mutations_defects[3].data;
		omophagea = mutations_defects[4].data;
		ossmodula = mutations_defects[5].data;
		zygote = mutations_defects[6].data;
		membrane = mutations_defects[7].data;
		betchers = mutations_defects[8].data;
		catalepsean = mutations_defects[9].data;
		secretions = mutations_defects[10].data;
		occulobe = mutations_defects[11].data;
		mucranoid = mutations_defects[12].data;

		draw_set_alpha(1);

		draw_line(445, 505, 1125, 505);
		draw_line(445, 506, 1125, 505);
		draw_line(445, 507, 1125, 507);

		draw_set_font(fnt_40k_30b);
		draw_set_halign(fa_center);
		draw_text_transformed(800, 515, string_hash_to_newline("Starting Disposition"), 0.6, 0.6, 0);

		draw_set_font(fnt_40k_14b);
		draw_set_halign(fa_right);

		draw_text(650, 550, string_hash_to_newline("Imperium (" + string(disposition[2]) + ")"));
		draw_text(650, 575, string_hash_to_newline("Adeptus Mechanicus (" + string(disposition[3]) + ")"));
		draw_text(650, 600, string_hash_to_newline("Ecclesiarchy (" + string(disposition[5]) + ")"));
		draw_text(650, 625, string_hash_to_newline("Inquisition (" + string(disposition[4]) + ")"));
		if (founding != ePROGENITOR.NONE) {
			draw_text(650, 650, string_hash_to_newline("Progenitor (" + string(disposition[1]) + ")"));
		}
		draw_text(650, 675, "Adeptus Astartes (" + string(disposition[6]) + ")");

		draw_rectangle(655, 552, 1150, 567, 1);
		draw_rectangle(655, 552 + 25, 1150, 567 + 25, 1);
		draw_rectangle(655, 552 + 50, 1150, 567 + 50, 1);
		draw_rectangle(655, 552 + 75, 1150, 567 + 75, 1);
		if (founding != ePROGENITOR.NONE) {
			draw_rectangle(655, 552 + 100, 1150, 567 + 100, 1);
		}
		draw_rectangle(655, 552 + 125, 1150, 567 + 125, 1);
		if (disposition[2] > 0) {
			draw_rectangle(655, 552, 655 + (disposition[2] * 4.95), 567, 0);
		}
		if (disposition[3] > 0) {
			draw_rectangle(655, 552 + 25, 655 + (disposition[3] * 4.95), 567 + 25, 0);
		}
		if (disposition[5] > 0) {
			draw_rectangle(655, 552 + 50, 655 + (disposition[5] * 4.95), 567 + 50, 0);
		}
		if (disposition[4] > 0) {
			draw_rectangle(655, 552 + 75, 655 + (disposition[4] * 4.95), 567 + 75, 0);
		}
		if ((disposition[1] > 0) && (founding != ePROGENITOR.NONE)) {
			draw_rectangle(655, 552 + 100, 655 + (disposition[1] * 4.95), 567 + 100, 0);
		}
		if (disposition[6] > 0) {
			draw_rectangle(655, 552 + 125, 655 + (disposition[6] * 4.95), 567 + 125, 0);
		}
	}

	/* Chapter Master */
	if (slide == eCREATIONSLIDES.CHAPTERMASTER) {
		draw_set_color(38144);
		draw_set_font(fnt_40k_30b);
		draw_set_halign(fa_center);
		draw_set_alpha(1);
		var yar;
		yar = 0;

		tooltip = "";
		tooltip2 = "";
		obj_cursor.image_index = 0;

		draw_set_color(38144);
		draw_set_halign(fa_left);
		draw_text_transformed(580, 100, string_hash_to_newline("Chapter Master Name: "), 0.9, 0.9, 0);
		draw_set_font(fnt_40k_14b);

		if ((text_selected != "cm") || (custom == 0)) {
			draw_text_ext(580, 144, string_hash_to_newline(string(chapter_master_name)), -1, 580);
		}
		if ((custom > 0) && (restarted == 0)) {
			if ((text_selected == "cm") && (text_bar > 30)) {
				draw_text(580, 144, string_hash_to_newline(string(chapter_master_name)));
			}
			if ((text_selected == "cm") && (text_bar <= 30)) {
				draw_text(580, 144, string_hash_to_newline(string(chapter_master_name) + "|"));
			}
			var str_width, hei;
			str_width = max(350, string_width(string_hash_to_newline(chapter_master_name)));
			hei = string_height(string_hash_to_newline(chapter_master_name));
			if (scr_hit(580 - 2, 144 - 2, 582 + str_width, 146 + hei)) {
				obj_cursor.image_index = 2;
				if (scr_click_left() && !instance_exists(obj_creation_popup)) {
					text_selected = "cm";
					keyboard_string = chapter_master_name;
				}
			}
			if (text_selected == "cm") {
				chapter_master_name = keyboard_string;
			}
			draw_rectangle(580 - 2, 144 - 2, 582 + 350, 146 + hei, 1);

			var _refresh_cm_name_btn = [943, 142, 947 + hei, 146 + hei];
			draw_unit_buttons(_refresh_cm_name_btn, "?", [1, 1], 38144, , fnt_40k_14b);
			if (point_and_click(_refresh_cm_name_btn)) {
				var _new_cm_name = global.name_generator.generate_space_marine_name();
				show_debug_message($"regen name of chapter_master_name from {chapter_master_name} to {_new_cm_name}");
				chapter_master_name = _new_cm_name;
			}
		}

		draw_line(445, 200, 1125, 200);
		draw_line(445, 201, 1125, 201);
		draw_line(445, 202, 1125, 202);

		draw_set_font(fnt_40k_30b);
		draw_text_transformed(444, 215, string_hash_to_newline("Select Two Weapons"), 0.6, 0.6, 0);
		draw_text_transformed(444, 240, string_hash_to_newline("Melee"), 0.6, 0.6, 0);
		draw_text_transformed(800, 240, string_hash_to_newline("Ranged"), 0.6, 0.6, 0);

		var x6, y6, spac;
		var melee_choice_order = 0;
		var melee_choice_weapon = "";
		x6 = 444;
		y6 = 265;
		spac = 25;
		if ((custom == 0) || (restarted > 0)) {
			draw_set_alpha(0.5);
		}

		repeat (8) {
			melee_choice_order += 1;
			if (melee_choice_order == 1) {
				melee_choice_weapon = "Twin Power Fists";
			}
			if (melee_choice_order == 2) {
				melee_choice_weapon = "Twin Lightning Claws";
			}
			if (melee_choice_order == 3) {
				melee_choice_weapon = "Relic Blade";
			}
			if (melee_choice_order == 4) {
				melee_choice_weapon = "Thunder Hammer";
			}
			if (melee_choice_order == 5) {
				melee_choice_weapon = "Power Sword";
			}
			if (melee_choice_order == 6) {
				melee_choice_weapon = "Power Axe";
			}
			if (melee_choice_order == 7) {
				melee_choice_weapon = "Eviscerator";
			}
			if (melee_choice_order == 8) {
				melee_choice_weapon = "Force Staff";
			}

			yar = 0;
			if (chapter_master_melee == melee_choice_order) {
				yar = 1;
			}
			draw_sprite(spr_creation_check, yar, x6, y6);
			yar = 0;
			if (point_and_click([x6, y6, x6 + 32, y6 + 32]) && (custom > 0) && (restarted == 0) && (!instance_exists(obj_creation_popup))) {
				var onceh;
				onceh = 0;
				if ((chapter_master_melee == melee_choice_order) && (onceh == 0)) {
					chapter_master_melee = 0;
					onceh = 1;
				}
				if ((chapter_master_melee != melee_choice_order) && (onceh == 0)) {
					chapter_master_melee = melee_choice_order;
					onceh = 1;
				}
			}
			draw_text_transformed(x6 + 30, y6 + 4, string_hash_to_newline(melee_choice_weapon), 0.4, 0.4, 0);
			y6 += spac;
		}

		x6 = 800;
		y6 = 265;
		var ranged_choice_order = 0;
		var ranged_choice_weapon = "";
		var ranged_options = ["", "Boltstorm Gauntlet", "Infernus Pistol", "Plasma Pistol", "Plasma Gun", "Master Crafted Heavy Bolter", "Master Crafted Meltagun", "Storm Shield", ""];
		if (array_contains([1, 2, 7], chapter_master_melee)) {
			draw_set_alpha(0.5);
			chapter_master_ranged = 1;
		}
		repeat (7) {
			ranged_choice_order += 1;
			yar = 0;
			if (chapter_master_ranged == ranged_choice_order) {
				yar = 1;
			}
			draw_sprite(spr_creation_check, yar, x6, y6);
			yar = 0;
			if (point_and_click([x6, y6, x6 + 32, y6 + 32]) && (custom > 0) && (restarted == 0) && (!instance_exists(obj_creation_popup)) && (!array_contains([1, 2, 7], chapter_master_melee))) {
				var onceh = 0;
				if (chapter_master_ranged == ranged_choice_order) {
					chapter_master_ranged = 0;
				} else if (chapter_master_ranged != ranged_choice_order) {
					chapter_master_ranged = ranged_choice_order;
				}
			}
			draw_text_transformed(x6 + 30, y6 + 4, ranged_options[ranged_choice_order], 0.4, 0.4, 0);
			y6 += spac;
		}

		draw_set_alpha(1);

		draw_line(445, 490, 1125, 490);
		draw_line(445, 491, 1125, 491);
		draw_line(445, 492, 1125, 492);

		draw_set_font(fnt_40k_30b);
		// draw_text_transformed(444,505,"Select Speciality",0.6,0.6,0);
		draw_set_halign(fa_center);

		var psy_intolerance = array_contains(dis, "Psyker Intolerant");
		if ((chapter_master_specialty == 3) && ((race[100, 17] == 0) || psy_intolerance)) {
			chapter_master_speciality = choose(1, 2);
		}
		x6 = 474;
		y6 = 500;
		h = 0;
		it = "";
		var leader_types = [["", ""], ["Born Leader", "You always know the right words to inspire your men or strike doubt in the hearts of the enemy.  Increases Disposition and Grants a +10% Requisition Income Bonus."], ["Champion", "Even before your rise to Chapter Master you were a renowned warrior, nearly without compare.  Increases Chapter Master Experience, Melee Damage, and Ranged Damage."], ["Psyker", "The impossible is nothing to you; despite being a Psyker you have slowly risen to lead a Chapter.  Chapter Master gains every Power within the chosen Discipline."]];
		repeat (3) {
			h += 1;
			var cur_leader_type = leader_types[h];
			draw_set_alpha(1);
			var nope = (h == 3) && ((race[100, 17] == 0) || psy_intolerance);
			if (nope) {
				draw_set_alpha(0.5);
			}
			if ((custom < 2) || (restarted > 0)) {
				draw_set_alpha(0.5);
			}

			// draw_sprite(spr_cm_specialty,h-1,x6,y6);
			scr_image("commander", h - 1, x6, y6, 162, 208);

			draw_text_transformed(x6 + 81, y6 + 214, cur_leader_type[0], 0.5, 0.5, 0);

			draw_sprite(spr_creation_check, chapter_master_specialty == h, x6, y6 + 214);

			if (point_and_click([x6, y6 + 214, x6 + 32, y6 + 32 + 214]) && (custom > 1) && (restarted == 0) && (nope == 0)) {
				var onceh = 0;
				if ((chapter_master_specialty != h) && (onceh == 0)) {
					chapter_master_specialty = h;
					onceh = 1;
				}
			}
			if (scr_hit(x6, y6 + 214, x6 + 162, y6 + 234) && (nope == 0)) {
				tooltip = cur_leader_type[0];
				tooltip2 = cur_leader_type[1];
			}

			x6 += 240;
			draw_set_alpha(1);
		}

		//adds "Save Chapter" button if custom chapter in a save slot

		if (custom > 0 && global.chapter_id != eCHAPTERS.UNKNOWN) {
			/// save chapter box
			var _sc_box = {
				x1: 980,
				y1: 135,
				w: 180,
				h: 35
			};
			_sc_box.y2 = _sc_box.y1 + _sc_box.h;
			_sc_box.x2 = _sc_box.x1 + _sc_box.w;
			
			draw_set_font(fnt_40k_30b);
			draw_rectangle(_sc_box.x1, _sc_box.y1, _sc_box.x2, _sc_box.y2, true);
			draw_text_transformed(_sc_box.x1 + 90, _sc_box.y1 + 5, string("Save Chapter"), 0.6, 0.6, 0);
			draw_set_font(fnt_40k_14b);
			if (scr_hit(_sc_box.x1, _sc_box.y1, _sc_box.x2, _sc_box.y2)) {
				tooltip = "Do you want to save your chapter?";
				tooltip2 = "Click to save your chapter";
				if (scr_click_left()) {
					scr_save_chapter(global.chapter_id);

					tooltip = "Do you want to save your chapter?";
					tooltip2 = "Chapter Saved!";
				}
			}
		}
	}

	/* */

	// 850,860

	var xx, yy;
	xx = 375;
	yy = 10;

	if (change_slide > 0) {
		draw_set_color(c_black);
		if (change_slide == 3) {
			if (slate5 <= 0) {
				slate5 = 1;
			}
			if ((slate5 >= 5) && (slate6 == 0)) {
				slate6 = 1;
			}
		}
		if (change_slide <= 30) {
			draw_set_alpha(change_slide / 30);
		}
		if (change_slide > 40) {
			draw_set_alpha(2.33 - (change_slide / 30));
		}
		draw_rectangle(430, 66, 702, 750, 0);
		draw_rectangle(703, 80, 1171, 750, 0);
		draw_rectangle(518, 750, 1075, 820, 0);
	}

	draw_set_color(5998382);
	if (slate5 > 0) {
		if (slate5 <= 30) {
			draw_set_alpha(slate5 / 30);
		}
		if (slate5 > 30) {
			draw_set_alpha(1 - ((slate5 - 30) / 30));
		}
		draw_line(xx + 30, yy + 70 + (slate5 * 12), xx + 790, yy + 70 + (slate5 * 12));
	}
	if (slate6 > 0) {
		if (slate6 <= 30) {
			draw_set_alpha(slate6 / 30);
		}
		if (slate6 > 30) {
			draw_set_alpha(1 - ((slate6 - 30) / 30));
		}
		draw_line(xx + 30, yy + 70 + (slate6 * 12), xx + 790, yy + 70 + (slate6 * 12));
	}

	if (fade_in > 0) {
		draw_set_alpha(fade_in / 50);
		draw_set_color(0);
		draw_rectangle(0, 0, room_width, room_height, 0);
	}
	draw_set_alpha(1);
	// draw_set_color(c_red);
	// draw_text(mouse_x+20,mouse_y+20,string(change_slide));

	if (slide == 1) {
		draw_set_alpha(slate4 / 30);
		if (slide == 1) {
			draw_sprite(spr_creation_arrow, 2, 607, 761);
		}
		if (slide != 1) {
			draw_sprite(spr_creation_arrow, 0, 607, 761);
		}
		draw_sprite(spr_creation_arrow, 3, 927, 761);

		var q, x3, y3;
		q = 1;
		x3 = (room_width / 2) - 65;
		y3 = 790;
		draw_set_color(38144);
		repeat (6) {
			draw_circle(x3, y3, 10, 1);
			draw_circle(x3, y3, 9.5, 1);
			draw_circle(x3, y3, 9, 1);

			if (slide == q) {
				draw_circle(x3, y3, 8.5, 0);
			}
			if (slide != q) {
				draw_circle(x3, y3, 8.5, 1);
			}
			x3 += 25;
			q += 1;
		}
	}

	if ((slide >= 2) || (goto_slide >= 2)) {
		draw_set_alpha(1);
		draw_sprite(spr_creation_arrow, 0, 607, 761);
		draw_sprite(spr_creation_arrow, 1, 927, 761);
		if (slide == 1) {
			draw_sprite(spr_creation_arrow, 2, 607, 761);
		}

		// skip to end >> button
		if ((slide >= 2) && (slide < 6) && (custom != 2)) {
			draw_set_alpha(0.8);
			if ((popup == "") && ((change_slide >= 70) || (change_slide <= 0)) && scr_hit(927 + 64 + 12, 761 + 12, 927 + 128 - 12, 761 + 64 - 12)) {
				draw_set_alpha(1);
			}
			draw_sprite(spr_creation_arrow, 4, 927 + 64, 761);
			if ((popup == "") && ((change_slide >= 70) || (change_slide <= 0)) && (point_and_click([927 + 64 + 12, 761 + 12, 927 + 128 - 12, 761 + 64 - 12]))) {
				scr_creation(2);
				scr_creation(3);
				scr_creation(4);
				scr_creation(5);
				scr_creation(6);
			}
		}
		draw_set_alpha(1);

		var q = 1, x3 = (room_width / 2) - 65, y3 = 790;
		draw_set_color(38144);
		repeat (6) {
			draw_circle(x3, y3, 10, 1);
			draw_circle(x3, y3, 9.5, 1);
			draw_circle(x3, y3, 9, 1);

			if (slide_show == q) {
				draw_circle(x3, y3, 8.5, 0);
			}
			if (slide_show != q) {
				draw_circle(x3, y3, 8.5, 1);
			}
			x3 += 25;
			q += 1;
		}

		if ((popup == "") && ((change_slide >= 70) || (change_slide <= 0))) {
			if (point_and_click([925, 756, 997, 824]) && !instance_exists(obj_creation_popup)) {
				// Next slide
				if (slide >= 2 && slide <= 6) {
					scr_creation(slide);
				}
			}

			if (point_and_click([604, 756, 675, 824]) && (!instance_exists(obj_creation_popup))) {
				// Previous slide
				change_slide = 1;
				goto_slide = slide - 1;
				popup = "";
				if (goto_slide == 1) {
					highlight = 0;
					highlighting = 0;
					old_highlight = 0;
				}
			}
		}
	}

	if (tooltip != "" && tooltip2 != "" && change_slide <= 0) {
		draw_set_alpha(1);
		draw_set_color(0);
		draw_set_halign(fa_left);
		draw_set_font(fnt_40k_14b);
		var _width1 = string_width_ext(string_hash_to_newline(tooltip), -1, 500);
		draw_set_font(fnt_40k_14);
		var _width2 = string_width_ext(string_hash_to_newline(tooltip2), -1, 500);
		var _height = string_height_ext(string_hash_to_newline(tooltip2), -1, 500);

		draw_rectangle(mouse_x + 18, mouse_y + 20, mouse_x + max(_width1, _width2) + 24, mouse_y + 44 + _height, 0);
		draw_set_color(38144);
		draw_rectangle(mouse_x + 18, mouse_y + 20, mouse_x + max(_width1, _width2) + 24, mouse_y + 44 + _height, 1);
		draw_set_font(fnt_40k_14b);
		draw_text(mouse_x + 22, mouse_y + 22, string_hash_to_newline(string(tooltip)));
		draw_set_font(fnt_40k_14);
		draw_text_ext(mouse_x + 22, mouse_y + 42, string_hash_to_newline(string(tooltip2)), -1, 500);
	}
} catch (_exception) {
	handle_exception(_exception);
    room_goto(Main_Menu);
}
