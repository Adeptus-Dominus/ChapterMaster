
var xx,yy;
xx=__view_get( e__VW.XView, 0 )+0;
yy=__view_get( e__VW.YView, 0 )+0;

if (total_role_number>0){
    draw_set_color(c_gray);
    draw_set_halign(fa_left);
    draw_set_font(fnt_40k_30b);
    draw_set_alpha(1);
    
    draw_text_ext_transformed(xx+107,yy+160,string_hash_to_newline(string(total_roles)),-1,471*1.66,0.6,0.6,0);
    
    
    draw_text_ext_transformed(xx+107,yy+190+(string_height_ext(string_hash_to_newline(total_roles),-1,471*1.66)*0.6),string_hash_to_newline(string(all_equip)),-1,471*1.66,0.6,0.6,0);
    
    
    draw_set_alpha(1);
    if (good1+good2+good3+good4+good5!=5) then draw_set_alpha(0.5);draw_set_font(fnt_40k_14b);
    draw_set_halign(fa_center);draw_set_color(c_gray);
    draw_rectangle(xx+114,yy+626,xx+560,yy+665,0);
    draw_set_color(0);draw_text(xx+333,yy+636,string_hash_to_newline("Requip All "+string(obj_ini.role[100,role])+" With Default Items"));
    if (scr_hit(xx+114,yy+626,xx+560,yy+665)=true){
        draw_set_color(c_white);draw_set_alpha(0.2);if (good1+good2+good3+good4+good5!=5) then draw_set_alpha(0.1);
        draw_rectangle(xx+114,yy+626,xx+560,yy+665,0);draw_set_alpha(1);
        if (obj_controller.mouse_left=1) and (good1+good2+good3+good4+good5=5){
            obj_controller.cooldown=8000;engage=true;refresh=true;
            effect_create_above(ef_firework,xx+800,yy+400,5,c_yellow);
        }
    }draw_set_alpha(1);
    
    draw_set_font(fnt_40k_30b);draw_set_halign(fa_left);
    
    if (req_wep1!=""){
        draw_set_color(c_gray);if (req_wep1_num>have_wep1_num) then draw_set_color(c_red);
        if (req_wep1_num>have_wep1_num) then draw_text_transformed(xx+154,yy+670,string_hash_to_newline("-Not enough "+string(req_wep1)+" (Have "+string(have_wep1_num)+", Need "+string(req_wep1_num)+")"),0.6,0.6,0);
        if (req_wep1_num<=have_wep1_num) then draw_text_transformed(xx+154,yy+670,string_hash_to_newline("-"+string(req_wep1)+" (Have "+string(have_wep1_num)+", Need "+string(req_wep1_num)+")"),0.6,0.6,0);
    }
    if (req_wep2!=""){
        draw_set_color(c_gray);if (req_wep2_num>have_wep2_num) then draw_set_color(c_red);
        if (req_wep2_num>have_wep2_num) then draw_text_transformed(xx+154,yy+698,string_hash_to_newline("-Not enough "+string(req_wep2)+" (Have "+string(have_wep2_num)+", Need "+string(req_wep2_num)+")"),0.6,0.6,0);
        if (req_wep2_num<=have_wep2_num) then draw_text_transformed(xx+154,yy+698,string_hash_to_newline("-"+string(req_wep2)+" (Have "+string(have_wep2_num)+", Need "+string(req_wep2_num)+")"),0.6,0.6,0);
    }
    if (req_armour!=""){
        draw_set_color(c_gray);if (req_armour_num>have_armour_num) then draw_set_color(c_red);
        if (req_armour_num>have_armour_num) then draw_text_transformed(xx+154,yy+726,string_hash_to_newline("-Not enough "+string(req_armour)+" (Have "+string(have_armour_num)+", Need "+string(req_armour_num)+")"),0.6,0.6,0);
        if (req_armour_num<=have_armour_num) then draw_text_transformed(xx+154,yy+726,string_hash_to_newline("-"+string(req_armour)+" (Have "+string(have_armour_num)+", Need "+string(req_armour_num)+")"),0.6,0.6,0);
    }
    if (req_gear!=""){
        draw_set_color(c_gray);if (req_gear_num>have_gear_num) then draw_set_color(c_red);
        if (req_gear_num>have_gear_num) then draw_text_transformed(xx+154,yy+754,string_hash_to_newline("-Not enough "+string(req_gear)+" (Have "+string(have_gear_num)+", Need "+string(req_gear_num)+")"),0.6,0.6,0);
        if (req_gear_num<=have_gear_num) then draw_text_transformed(xx+154,yy+754,string_hash_to_newline("-"+string(req_gear)+" (Have "+string(have_gear_num)+", Need "+string(req_gear_num)+")"),0.6,0.6,0);
    }
    if (req_mobi!=""){
        draw_set_color(c_gray);if (req_mobi_num>have_mobi_num) then draw_set_color(c_red);
        if (req_mobi_num>have_mobi_num) then draw_text_transformed(xx+154,yy+782,string_hash_to_newline("-Not enough "+string(req_mobi)+" (Have "+string(have_mobi_num)+", Need "+string(req_mobi_num)+")"),0.6,0.6,0);
        if (req_mobi_num<=have_mobi_num) then draw_text_transformed(xx+154,yy+782,string_hash_to_newline("-"+string(req_mobi)+" (Have "+string(have_mobi_num)+", Need "+string(req_mobi_num)+")"),0.6,0.6,0);
    }
}



if (total_role_number > 0 && tab > 0) {
    item_name = [];
    var infanty_roles = [
        eROLE.ChapterMaster,
        eROLE.HonourGuard,
        eROLE.Veteran,
        eROLE.Terminator,
        eROLE.Captain,
        eROLE.Champion,
        eROLE.Tactical,
        eROLE.Devastator,
        eROLE.Assault,
        eROLE.Ancient,
        eROLE.Scout,
        eROLE.Chaplain,
        eROLE.Apothecary,
        eROLE.Techmarine,
        eROLE.Librarian,
        eROLE.Sergeant,
        eROLE.VeteranSergeant,
    ];
    if (
        // hand slots
        (tab == 1 || tab ==2) &&
        array_get_index(infanty_roles, obj_controller.settings) >= 0
    ) {
        // Get all available hand weapons
        scr_get_item_names(
            item_name,
            obj_controller.settings, // eROLE
            1, // slot
            eENGAGEMENT.Any,
            true,  // include the company standard
            false,  // do not limit to available items
        );
        scr_get_item_names(
            item_name,
            obj_controller.settings, // eROLE
            2, // slot
            eENGAGEMENT.Any, 
            false,  // include the company standard
            false,  // do not limit to available items
            false, // not only mastercrafted
            true // put none in the list only once
        );
        array_resize(item_name, array_unique_ext(item_name));
    } else {
        scr_get_item_names(
            item_name,
            obj_controller.settings, // eROLE
            tab, // slot
            eENGAGEMENT.None, // doesn't matter to non infantry/non hand slots
            true,  // include the company standard
            false,  // do not limit to available items
        );
    }

    draw_set_color(0);
    draw_rectangle(xx + 1183, yy + 160, xx + 1506, yy + 747, 0);
    
    draw_set_color(c_gray);
    draw_rectangle(xx + 1184, yy + 161, xx + 1505, yy + 746, 1);
    draw_rectangle(xx + 1185, yy + 162, xx + 1504, yy + 745, 1);
    draw_rectangle(xx + 1186, yy + 163, xx + 1503, yy + 744, 1);
    
    draw_set_font(fnt_40k_30b);
    var slot_name = get_slot_name(obj_controller.settings, tab);
    draw_text_transformed(xx + 1203, yy + 174, string_hash_to_newline($"Select {slot_name}"), 0.6, 0.6, 0);
    draw_set_font(fnt_40k_14b);

    var x3 = xx + 1205; // Starting x position for the first column
    var y3 = yy + 205; // Starting y position
    var space = 18; // Amount to move down for each item
    var items_per_column = 24;
    var column_width = 146;
    var column_gap = 3;

    for (var h = 0; h < array_length(item_name); h++) {
        if (h > 0 && h % items_per_column == 0) {
            x3 += column_width;
            y3 = yy + 205;
        }

        draw_set_color(c_gray);
        var scale = string_width(string_hash_to_newline(item_name[h])) >= 140 ? 0.75 : 1;
        draw_text_transformed(x3, y3, string_hash_to_newline(item_name[h]), scale, 1, 0);

        // keep track of the item's bottom right corner
        var item_x2 = x3 + (column_width - column_gap);
        var item_y2 = y3 + space - 1;

        if (scr_hit(x3, y3, item_x2, item_y2)) {
            draw_set_color(c_white);
            draw_set_alpha(0.2);
            draw_text_transformed(x3, y3, string_hash_to_newline(item_name[h]), scale, 1, 0);
            draw_set_alpha(1);

            if (obj_controller.mouse_left == 1 && obj_controller.cooldown <= 0) {
                var buh = item_name[h] == ITEM_NAME_NONE ? "" : item_name[h];
                obj_controller.cooldown = 8000;

                switch (tab) {
                    // slots
                    case 1: obj_ini.wep1[100, role] = buh; break;
                    case 2: obj_ini.wep2[100, role] = buh; break;
                    case 3:
                        obj_ini.armour[100, role] = buh;
                        // No bikes or jump packs for Terminators
                        if (buh == "Terminator Armour") {
                            obj_ini.mobi[100, role] = "";
                        }
                        break;
                    case 4: obj_ini.gear[100, role] = buh; break;
                    case 5: obj_ini.mobi[100, role] = buh; break;
                }
                tab = 0;
                refresh = true;
            }
        }
        y3 += space;
    }

    draw_set_halign(fa_center);
    draw_set_font(fnt_40k_14b);
    draw_set_color(c_gray);
    draw_rectangle(xx + 1347 - (string_width(string_hash_to_newline("CANCEL")) / 2), yy + 720, xx + 1347 + (string_width(string_hash_to_newline("CANCEL")) / 2), yy + 741, 0);
    draw_set_color(0);
    draw_text(xx + 1347, yy + 721, string_hash_to_newline("CANCEL"));
    if (scr_hit(xx + 1347 - (string_width(string_hash_to_newline("CANCEL")) / 2), yy + 720, xx + 1347 + (string_width(string_hash_to_newline("CANCEL")) / 2), yy + 741)) {
        draw_set_color(c_white);
        draw_set_alpha(0.2);
        draw_rectangle(xx + 1347 - (string_width(string_hash_to_newline("CANCEL")) / 2), yy + 720, xx + 1347 + (string_width(string_hash_to_newline("CANCEL")) / 2), yy + 741, 0);
        draw_set_alpha(1);
        if (obj_controller.mouse_left == 1) {
            obj_controller.cooldown = 8000;
            tab = 0;
        }
    }
    draw_set_alpha(1);
}


/* */
/*  */
