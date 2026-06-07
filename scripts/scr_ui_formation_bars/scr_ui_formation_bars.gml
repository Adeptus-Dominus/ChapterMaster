/// @self Asset.GMObject.obj_controller
function scr_ui_formation_bars() {
    var ui_formations_data = {
        nbar: 0,
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

    for (var bar = 1; bar <= 10; bar++) {
        ui_formations_data.te++;
        temp[ui_formations_data.te] = 0;
        var cu = instance_create(ui_formations_data.x9, ui_formations_data.y9, obj_temp8);
        cu.col_parent = bar;

        temp[ui_formations_data.te] = 0;
        temp[ui_formations_data.te + 100] = 0;

        for (var ii = 1; ii <= 17; ii++) {
            if ((ii == 1) && (bat_comm_for[_formatting] == bar)) {
                init_combat_bars(bar, ii, ui_formations_data, 2, 0, "HQ");
            } else if ((ii == 2) && (bat_hono_for[_formatting] == bar)) {
                init_combat_bars(bar, ii, ui_formations_data, 1, 1, "Hono");
            } else if ((ii == 3) && (bat_libr_for[_formatting] == bar)) {
                init_combat_bars(bar, ii, ui_formations_data, 1, 8, "Lib");
            } else if ((ii == 4) && (bat_tech_for[_formatting] == bar)) {
                init_combat_bars(bar, ii, ui_formations_data, 1, 9, "Tech");
            } else if ((ii == 5) && (bat_term_for[_formatting] == bar)) {
                init_combat_bars(bar, ii, ui_formations_data, 1, 10, "Term");
            } else if ((ii == 6) && (bat_vete_for[_formatting] == bar)) {
                init_combat_bars(bar, ii, ui_formations_data, 2, 6, "Veteran");
            } else if ((ii == 7) && (bat_tact_for[_formatting] == bar)) {
                init_combat_bars(bar, ii, ui_formations_data, 6, 3, "Tactical");
            } else if ((ii == 8) && (bat_deva_for[_formatting] == bar)) {
                init_combat_bars(bar, ii, ui_formations_data, 3, 2, "Devastator");
            } else if ((ii == 9) && (bat_assa_for[_formatting] == bar)) {
                init_combat_bars(bar, ii, ui_formations_data, 3, 5, "Assault");
            } else if ((ii == 10) && (bat_scou_for[_formatting] == bar)) {
                init_combat_bars(bar, ii, ui_formations_data, 1, 4, "Sco");
            } else if ((ii == 11) && (bat_drea_for[_formatting] == bar)) {
                init_combat_bars(bar, ii, ui_formations_data, 2, 11, "Dread");
            } else if ((ii == 12) && (bat_hire_for[_formatting] == bar)) {
                init_combat_bars(bar, ii, ui_formations_data, 1, 7, "???");
            } else if ((ii == 16) && (bat_landspee_for[_formatting] == bar)) {
                init_combat_bars(bar, ii, ui_formations_data, 2, 14, "Land Speeder");
            }

            if (bat_formation_type[_formatting] != 2) {
                if ((ii == 13) && (bat_rhin_for[_formatting] == bar)) {
                    init_combat_bars(bar, ii, ui_formations_data, 4, 12, "Rhino");
                } else if ((ii == 14) && (bat_pred_for[_formatting] == bar)) {
                    init_combat_bars(bar, ii, ui_formations_data, 2, 13, "Predator");
                } else if ((ii == 15) && (bat_landraid_for[_formatting] == bar)) {
                    init_combat_bars(bar, ii, ui_formations_data, 2, 14, "Land Raider");
                } else if ((ii == 17) && (bat_whirl_for[_formatting] == bar)) {
                    init_combat_bars(bar, ii, ui_formations_data, 2, 14, "Whirlwind");
                }
            }

            if (instance_exists(ui_formations_data.nbar)) {
                ui_formations_data.nbar.width = 39;
            }

            if (temp[4800 + bar] > 10) {
                bat_deva_for[bar] = 1;
                bat_assa_for[bar] = 4;
                bat_tact_for[bar] = 2;
                bat_vete_for[bar] = 2;
                bat_hire_for[bar] = 3;
                bat_libr_for[bar] = 3;
                bat_comm_for[bar] = 3;
                bat_tech_for[bar] = 3;
                bat_term_for[bar] = 3;
                bat_hono_for[bar] = 3;
                bat_drea_for[bar] = 5;
                bat_rhin_for[bar] = 6;
                bat_pred_for[bar] = 7;
                bat_landraid_for[bar] = 7;
                bat_landspee_for[bar] = 4;
                bat_whirl_for[bar] = 1;
                bat_scou_for[bar] = 1;
                bar_fix = 1;
            }
        }

        ui_formations_data.y9 = 224;
        ui_formations_data.x9 += 50;
    }
}

/// @self Asset.GMObject.obj_controller
function init_combat_bars(bar, ii, formations_data, size, image_index, unit_type) {
    formations_data.nbar = instance_create(formations_data.x9, formations_data.y9 + temp[formations_data.te], obj_formation_bar);
    formations_data.nbar.size = size;
    formations_data.nbar.height = formations_data.nbar.size * 47;
    if (temp[formations_data.te] > 0) {
        above_neighbor = formations_data.abar;
    }
    temp[formations_data.te] += formations_data.nbar.height;
    formations_data.abar = formations_data.nbar;
    temp[formations_data.te + 100] += formations_data.nbar.size;
    formations_data.nbar.image_index = image_index;
    formations_data.nbar.unit_type = unit_type;
    formations_data.nbar.unit_id = ii;
    formations_data.nbar.col_parent = bar;
}


function scr_draw_formation_settings(){
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

    var _formation_radio = settings_buttons_ui_components.formation_radio

    if (formating <= 3){
        _formation_radio.allow_changes = false;
    }
    _formation_radio.draw();

    if (_formation_radio.changed){
        var _new_val =  _formation_radio.selection_val("value");
        if (_new_val == "attack"){
            bat_formation_type[formating] = 1;
            scr_ui_formation_bars();            
        } else if (_new_val == "raid"){
            bat_formation_type[formating] = 2;
            scr_ui_formation_bars();            
        }
    }


    var _attack_box = settings_buttons_ui_components.attack_box;

    var _raid_box = settings_buttons_ui_components.raid_box;
   
    draw_set_color(c_gray);
    draw_set_alpha(0.25);

    var _player_deploys_x = 49;
    var  _player_deploys_y = 224;

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
    draw_rectangle( 1221,  211,  1561,  703, 1);
    draw_rectangle( 1220,  212,  1560,  702, 1);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_font(fnt_40k_30b);

    // This is where the cursor is changed- needs to be smart and also pass the instance type
    tooltip = "";
    tooltip_other = "";

    if (collision_point(mouse_x, mouse_y, obj_formation_bar, 1, 1) && (obj_cursor.image_index == 0)) {
        obj_cursor.image_index = 3;
    }
    if ((!collision_point(mouse_x, mouse_y, obj_formation_bar, 1, 1)) && (obj_cursor.image_index == 3)) {
        obj_cursor.image_index = 0;
    }

    if (obj_cursor.image_index == 3) {
        var theh = instance_position(mouse_x, mouse_y, obj_formation_bar);
        if (instance_exists(theh)) {
            if (theh.unit_id == 1) {
                tooltip = "Headquarters";
                tooltip2 = "You and your advisors will be placed within this section.  It is strongly advisable you give them backup in this same column.";
            }
            if (theh.unit_id == 2) {
                tooltip = "Honour Guard";
                tooltip2 = "Any Honour Guard within your Headquarters will be placed here.  The best place for them within the formation depends on loadout.";
            }
            if (theh.unit_id == 3) {
                tooltip = "Librarians";
                tooltip2 = "Epistolary, Lexicanum, and Codiciery make up this section.  They tend to deal decent damage and offer useful buffs for other units.";
            }
            if (theh.unit_id == 4) {
                tooltip = "Techmarines";
                tooltip2 = "Techmarines and their servitors are placed within this block.  It is advisable that they are placed near your vehicles and armour.";
            }
            if (theh.unit_id == 5) {
                tooltip = "Terminators";
                tooltip2 = "Any Terminators that you may have will be placed here.  They can very easily soak lots of damage and dish it back in return.";
            }
            if (theh.unit_id == 6) {
                tooltip = "Veterans";
                tooltip2 = "Veterans, the most experienced tacticals of your Chapter, are placed here.  Their best position in the formation depends on loadout.";
            }
            if (theh.unit_id == 7) {
                tooltip = "Tacticals";
                tooltip2 = "The greater bulk of your Chapter, the tactical marines, go here.  Tactical marines may be situated nearly anywhere.  Note that Apothecaries and Chaplains without jump-packs will also be placed here.";
            }
            if (theh.unit_id == 8) {
                tooltip = "Devastators";
                tooltip2 = "Devastators offer much long ranged firepower.  As a result they are best placed in the rear of your formation.";
            }
            if (theh.unit_id == 9) {
                tooltip = "Assaults";
                tooltip2 = "Assault marines are damage powerhouses, but tend to be squisher.  You may or may not wish for them to be on the front lines.  Note that Apothecaries and Chaplains with jump-packs will be placed here.";
            }
            if (theh.unit_id == 10) {
                tooltip = "Scouts";
                tooltip2 = "Scouts are not-yet full fledged Astartes.  Striking a balance between exposure to the enemy, for experience, and safety is key.";
            }
            if (theh.unit_id == 11) {
                tooltip = "Dreadnoughts";
                tooltip2 = "Dreadnoughts are the most durable and tough marines within your chapter.  They are best suited for the front lines.";
            }
            if (theh.unit_id == 12) {
                tooltip = "Hirelings";
                tooltip2 = "Any and all units that you recieve from other factions are placed within this block.";
            }
            if (theh.unit_id == 13) {
                tooltip = "Rhinos";
                tooltip2 = "Rhinos offer protection for units behind them but are not well armoured and lacking in firepower.";
            }
            if (theh.unit_id == 14) {
                tooltip = "Predators";
                tooltip2 = "Predators offer protection for units behind them and have a decent amount of long ranged firepower.";
            }
            if (theh.unit_id == 15) {
                tooltip = "Land Raiders";
                tooltip2 = "Land Raiders are incredibly tanky war machines that protect rear columns and offer tremendous amounts of firepower.  Other super-heavy vehicles will also be placed here.";
            }
            if (theh.unit_id == 16) {
                tooltip = "Land Speeders";
                tooltip2 = "Land Speeders are incredibly agile attack vehicles that offer a light highly mobile heavy weapon platform.";
            }
            if (theh.unit_id == 17) {
                tooltip = "Whirlwinds";
                tooltip2 = "Whirlwinds are armoured fire-support capable of supporting assaults from a long range safe from enemy retaliation.";
            }
            too_img = theh.unit_id - 1;
        }
    }

    if (tooltip != "") {
        draw_set_font(fnt_40k_30b);
        draw_text_transformed(1398, 213, string(tooltip), 0.75, 0.75, 0);
        draw_set_font(fnt_40k_14);
        draw_set_halign(fa_left);
        draw_text_ext(1227, 565, string(tooltip2), -1, 323);

        // draw_sprite(spr_formation_splash,too_img,xx+1271,yy+252);
        scr_image("formation", too_img, 1271, 252, 239, 297);
    }

    if (tool1 != "") {
        tooltip_draw(tooltip2,350, , CM_GREEN_COLOR, fnt_40k_14, tooltip);
    }
    pop_draw_return_values();
}


function formation_bar_draw(){
    if (dragging && instance_exists(mah_target)){
        if (mouse_check_button_released(mb_left)){
            release_bar();
        }
    }
}





