/// @mixin
function scr_ui_formation_bars() {
    var ui_formations_data = {
        nbar: 0,
        abar: 0,
        te: 4700,
        x9: __view_get(e__VW.XView, 0) + 49,
        y9: __view_get(e__VW.YView, 0) + 224,
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

        ui_formations_data.y9 = __view_get(e__VW.YView, 0) + 224;
        ui_formations_data.x9 += 50;
    }
}

/// @mixin
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
