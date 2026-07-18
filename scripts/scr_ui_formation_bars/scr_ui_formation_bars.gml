/// @self Asset.GMObject.obj_controller
function scr_ui_formation_bars() {
    var ui_formations_data = {
        nbar: noone,
        abar: 0,
        te: 4700,
        x9: 49,
        y9: 224,
    };

    var _formatting = formating;

    with (obj_formation_bar) {
        instance_destroy();
    }
    with (obj_temp8) {
        instance_destroy();
    }

    var _bar_configs = [
        {
            unit_id: 1,
            bat_for: bat_comm_for,
            size: 2,
            image_index: 0,
            unit_type: "HQ",
            tooltip: "Headquarters",
            tooltip2: "You and your advisors will be placed within this section.  It is strongly advisable you give them backup in this same column.",
        },
        {
            unit_id: 2,
            bat_for: bat_hono_for,
            size: 1,
            image_index: 1,
            unit_type: "Hono",
            tooltip: "Honour Guard",
            tooltip2: "Any Honour Guard within your Headquarters will be placed here.  The best place for them within the formation depends on loadout.",
        },
        {
            unit_id: 3,
            bat_for: bat_libr_for,
            size: 1,
            image_index: 8,
            unit_type: "Lib",
            tooltip: "Librarians",
            tooltip2: "Epistolary, Lexicanum, and Codiciery make up this section.  They tend to deal decent damage and offer useful buffs for other units.",
        },
        {
            unit_id: 4,
            bat_for: bat_tech_for,
            size: 1,
            image_index: 9,
            unit_type: "Tech",
            tooltip: "Techmarines",
            tooltip2: "Techmarines and their servitors are placed within this block.  It is advisable that they are placed near your vehicles and armour.",
        },
        {
            unit_id: 5,
            bat_for: bat_term_for,
            size: 1,
            image_index: 10,
            unit_type: "Term",
            tooltip: "Terminators",
            tooltip2: "Any Terminators that you may have will be placed here.  They can very easily soak lots of damage and dish it back in return.",
        },
        {
            unit_id: 6,
            bat_for: bat_vete_for,
            size: 2,
            image_index: 6,
            unit_type: "Veteran",
            tooltip: "Veterans",
            tooltip2: "Veterans, the most experienced tacticals of your Chapter, are placed here.  Their best position in the formation depends on loadout.",
        },
        {
            unit_id: 7,
            bat_for: bat_tact_for,
            size: 6,
            image_index: 3,
            unit_type: "Tactical",
            tooltip: "Tacticals",
            tooltip2: "The greater bulk of your Chapter, the tactical marines, go here.  Tactical marines may be situated nearly anywhere.  Note that Apothecaries and Chaplains without jump-packs will also be placed here.",
        },
        {
            unit_id: 8,
            bat_for: bat_deva_for,
            size: 3,
            image_index: 2,
            unit_type: "Devastator",
            tooltip: "Devastators",
            tooltip2: "Devastators offer much long ranged firepower.  As a result they are best placed in the rear of your formation.",
        },
        {
            unit_id: 9,
            bat_for: bat_assa_for,
            size: 3,
            image_index: 5,
            unit_type: "Assault",
            tooltip: "Assaults",
            tooltip2: "Assault marines are damage powerhouses, but tend to be squisher.  You may or may not wish for them to be on the front lines.  Note that Apothecaries and Chaplains with jump-packs will be placed here.",
        },
        {
            unit_id: 10,
            bat_for: bat_scou_for,
            size: 1,
            image_index: 4,
            unit_type: "Sco",
            tooltip: "Scouts",
            tooltip2: "Scouts are not-yet full fledged Astartes.  Striking a balance between exposure to the enemy, for experience, and safety is key.",
        },
        {
            unit_id: 11,
            bat_for: bat_drea_for,
            size: 2,
            image_index: 11,
            unit_type: "Dread",
            tooltip: "Dreadnoughts",
            tooltip2: "Dreadnoughts are the most durable and tough marines within your chapter.  They are best suited for the front lines.",
        },
        {
            unit_id: 12,
            bat_for: bat_hire_for,
            size: 1,
            image_index: 7,
            unit_type: "???",
            tooltip: "Hirelings",
            tooltip2: "Any and all units that you recieve from other factions are placed within this block.",
        },
        {
            unit_id: 16,
            bat_for: bat_landspee_for,
            size: 2,
            image_index: 14,
            unit_type: "Land Speeder",
            tooltip: "Land Speeders",
            tooltip2: "Land Speeders are incredibly agile attack vehicles that offer a light highly mobile heavy weapon platform.",
        },
    ];
    var _attack_only_options = [
        {
            unit_id: 13,
            bat_for: bat_rhin_for,
            size: 4,
            image_index: 12,
            unit_type: "Rhino",
            tooltip: "Rhinos",
            tooltip2: "Rhinos offer protection for units behind them but are not well armoured and lacking in firepower.",
        },
        {
            unit_id: 14,
            bat_for: bat_pred_for,
            size: 2,
            image_index: 13,
            unit_type: "Predator",
            tooltip: "Predators",
            tooltip2: "Predators offer protection for units behind them and have a decent amount of long ranged firepower.",
        },
        {
            unit_id: 15,
            bat_for: bat_landraid_for,
            size: 2,
            image_index: 14,
            unit_type: "Land Raider",
            tooltip: "Land Raiders",
            tooltip2: "Land Raiders are incredibly tanky war machines that protect rear columns and offer tremendous amounts of firepower.  Other super-heavy vehicles will also be placed here.",
        },
        {
            unit_id: 17,
            bat_for: bat_whirl_for,
            size: 2,
            image_index: 14,
            unit_type: "Whirlwind",
            tooltip: "Whirlwinds",
            tooltip2: "Whirlwinds are armoured fire-support capable of supporting assaults from a long range safe from enemy retaliation.",
        },
    ];

    for (var bar = 1; bar <= 10; bar++) {
        ui_formations_data.te++;
        temp[ui_formations_data.te] = 0;
        var cu = instance_create(ui_formations_data.x9, ui_formations_data.y9, obj_temp8);
        cu.col_parent = bar;

        temp[ui_formations_data.te] = 0;
        temp[ui_formations_data.te + 100] = 0;

        for (var unit_id = 0; unit_id <= 17; unit_id++) {
            for (var _i = 0; _i < array_length(_bar_configs); _i++) {
                var _cfg = _bar_configs[_i];
                if ((_cfg.unit_id == unit_id) && (_cfg.bat_for[_formatting] == bar)) {
                    init_combat_bars(bar, ui_formations_data, _cfg);
                    break;
                }
            }
            if (bat_formation_type[_formatting] != 2) {
                for (var _i = 0; _i < array_length(_attack_only_options); _i++) {
                    var _cfg = _attack_only_options[_i];
                    if ((_cfg.unit_id == unit_id) && (_cfg.bat_for[_formatting] == bar)) {
                        init_combat_bars(bar, ui_formations_data, _cfg);
                        break;
                    }
                }
            }

            if (instance_exists(ui_formations_data.nbar)) {
                ui_formations_data.nbar.width = 39;
            }

            if (temp[4800 + bar] > 10) {
                bat_deva_for[bar] = 3;
                bat_assa_for[bar] = 5;
                bat_tact_for[bar] = 4;
                bat_vete_for[bar] = 3;
                bat_hire_for[bar] = 3;
                bat_libr_for[bar] = 2;
                bat_comm_for[bar] = 2;
                bat_tech_for[bar] = 2;
                bat_term_for[bar] = 5;
                bat_hono_for[bar] = 2;
                bat_drea_for[bar] = 6;
                bat_rhin_for[bar] = 6;
                bat_pred_for[bar] = 6;
                bat_landraid_for[bar] = 6;
                bat_landspee_for[bar] = 5;
                bat_whirl_for[bar] = 1;
                bat_scou_for[bar] = 3;
                bar_fix = true;
            }
        }

        ui_formations_data.y9 = 224;
        ui_formations_data.x9 += 50;
    }
}

/// @self Asset.GMObject.obj_controller
function init_combat_bars(bar, formations_data, unit_data) {
    formations_data.nbar = instance_create(formations_data.x9, formations_data.y9 + temp[formations_data.te], obj_formation_bar);

    with (formations_data.nbar) {
        move_data_to_current_scope(unit_data);
    }

    formations_data.nbar.height = formations_data.nbar.size * 47;
    if (temp[formations_data.te] > 0) {
        above_neighbor = formations_data.abar;
    }
    temp[formations_data.te] += formations_data.nbar.height;
    formations_data.abar = formations_data.nbar;
    temp[formations_data.te + 100] += formations_data.nbar.size;
    formations_data.nbar.image_index = unit_data.image_index;
    formations_data.nbar.col_parent = bar;
}

function scr_draw_formation_settings() {
    add_draw_return_values();
    // Reset vars
    tool1 = "";
    tool2 = "";
    draw_set_halign(fa_center);
    draw_set_color(c_gray);
    draw_set_font(fnt_40k_30b);

    draw_set_alpha(1);
    // Back arrow

    draw_sprite(spr_formation_arrow, 0, 550, 385);

    var _name_input = settings_buttons_ui_components.formation_name_input;

    bat_formation[formating] = _name_input.draw(bat_formation[formating]);

    draw_set_font(fnt_40k_14);
    draw_set_halign(fa_left);

    var _formation_type = bat_formation_type[formating] == 1;

    var _formation_radio = settings_buttons_ui_components.formation_radio;

    if (formating <= 3) {
        _formation_radio.allow_changes = false;
    }
    _formation_radio.draw();

    if (_formation_radio.changed) {
        var _new_val = _formation_radio.selection_val("value");
        if (_new_val == "attack") {
            bat_formation_type[formating] = 1;
            scr_ui_formation_bars();
        } else if (_new_val == "raid") {
            bat_formation_type[formating] = 2;
            scr_ui_formation_bars();
        }
    }

    var _attack_box = settings_buttons_ui_components.attack_box;

    var _raid_box = settings_buttons_ui_components.raid_box;

    draw_set_color(c_gray);
    draw_set_alpha(0.25);

    var _player_deploys_x = 49;
    var _player_deploys_y = 224;

    for (var i = 0; i < 10; i++) {
        draw_rectangle(_player_deploys_x, _player_deploys_y, _player_deploys_x + 38, _player_deploys_y + 464, 0);
        _player_deploys_x += 50;
    }
    draw_set_alpha(1);

    var _enemy_deploy_boxes_x;
    // Attack Box
    if (bat_formation_type[formating] == 1) {
        _attack_box.draw(1);
        _enemy_deploy_boxes_x = 1054;
    } else {
        _raid_box.draw(1);
        _enemy_deploy_boxes_x = 684;
    }

    draw_set_alpha(0.25);
    // Draw Enemy boxes
    draw_set_color(c_red);
    var _enemy_deploy_boxes_y = 224;
    for (var i = 0; i < 3; i++) {
        draw_rectangle(_enemy_deploy_boxes_x, _enemy_deploy_boxes_y, _enemy_deploy_boxes_x + 38, _enemy_deploy_boxes_y + 464, 0);
        _enemy_deploy_boxes_x += 50;
    }

    // Draw Secondary info box
    draw_set_alpha(1);
    draw_set_color(c_gray);
    draw_rectangle(1221, 211, 1561, 703, 1);
    draw_rectangle(1220, 212, 1560, 702, 1);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_font(fnt_40k_30b);

    pop_draw_return_values();
}
