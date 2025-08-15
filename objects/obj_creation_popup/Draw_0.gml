var equip = false;
tooltip="";tooltip2="";
col_shift =  (is_string(type));
if (!col_shift){
    col_shift=type>0;
    var equip = type>20;
}
if (col_shift){
    draw_set_color(0);
    draw_rectangle(430,536,845,748,0);
    draw_set_color(38144);
    draw_rectangle(430,535,845,748,1);
    draw_rectangle(430,536,845,748,1);
    draw_rectangle(431,537,846,747,1);
    
    
    if (!equip){
        draw_set_font(fnt_40k_30b);
        var _colour_type = "";
        switch(type){
            case 1: _colour_type = "Primary Color";break;
            case 2: _colour_type = "Secondary Color";break;
            case 3: _colour_type = "Pauldron 1 Color";break;
            case 4: _colour_type = "Pauldron 2 Color";break;
            case 5: _colour_type = "Trim Color Color";break;
            case 6: _colour_type = "Lens Color Color";break;
            case 7: _colour_type = "Weapon Color Color";break;
            case "sgt_helm_primary": _colour_type = "Sgt Helm Primary";break;
            case "sgt_helm_secondary": _colour_type = "Sgt Helm Secondary";break;

        }
        draw_text_transformed(444,550,_colour_type,0.6,0.6,0);

        var _action = picker.draw();
        if (_action == "destroy"){
            instance_destroy();
            exit;
        } else {
            var _col = picker.chosen
            if (type = 1) then obj_creation.main_color = _col;
            if (type = 2) then obj_creation.secondary_color = _col;
            if (type = 3) then obj_creation.left_pauldron = _col;
            if (type = 4) then obj_creation.right_pauldron = _col;
            if (type = 5) then obj_creation.main_trim = _col;
            if (type = 6) then obj_creation.lens_color = _col;
            if (type = 7) then obj_creation.weapon_color = _col;
            bulk_selection_buttons_setup();
            if (is_string(type)){
                obj_creation.complex_livery_data[$ role][$ type] = _col;
            }            
        }
    }
    
    
    
    if (equip) {
        var co=100,ide=type-100;

        draw_set_font(fnt_40k_30b);
        if (obj_creation.role[co,ide]="") or (badname=1) then draw_set_color(c_red);
        if (obj_creation.text_selected!="unit_name"+string(ide)) then draw_text_transformed(444,550,string_hash_to_newline(obj_creation.role[co,ide]),0.6,0.6,0);
        if (obj_creation.text_selected="unit_name"+string(ide)) and (obj_creation.text_bar>30) then draw_text_transformed(444,550,string_hash_to_newline(string(obj_creation.role[co,ide])),0.6,0.6,0);
        if (obj_creation.text_selected="unit_name"+string(ide)) and (obj_creation.text_bar<=30) then draw_text_transformed(444,550,string_hash_to_newline(string(obj_creation.role[co,ide])+"|"),0.6,0.6,0);
        var hei=string_height_ext(string_hash_to_newline(string(obj_creation.role[co,ide])+"Q"),-1,580)*0.6;
        if (scr_hit(444,550,820,550+hei)){obj_cursor.image_index=2;
            tooltip="Astartes Role Name";
            tooltip2=$"The name of this Astartes Role.  The plural form will be ''{obj_creation.role[co,ide]}s''.";
            if (scr_click_left()){
                obj_creation.text_selected=$"unit_name{ide}";
                keyboard_string=obj_creation.role[co,ide];
            }
        }
        if (obj_creation.text_selected="unit_name"+string(ide)) then obj_creation.role[co,ide]=keyboard_string;
        draw_rectangle(444-1,550-1,822,550+hei,1);
        draw_set_color(38144);

        draw_set_font(fnt_40k_14b);
        draw_set_halign(fa_right);  

        var spacing=22;
        var x5 = 594;
        var y5 = 597 - spacing;

        for (var gg = 0; gg <= 4; gg++) {
            y5 += spacing;
            var title = $"{get_slot_name(type - 100, gg)}: ";
            var geh;
            switch (gg) {
                // slots
                case EquipmentSlot.WEAPON_ONE: geh = obj_creation.wep1[co, ide]; break;
                case EquipmentSlot.WEAPON_TWO: geh = obj_creation.wep2[co, ide]; break;
                case EquipmentSlot.ARMOUR: geh = obj_creation.armour[co, ide]; break;
                case EquipmentSlot.GEAR: geh = obj_creation.gear[co, ide]; break;
                case EquipmentSlot.MOBILITY: geh = obj_creation.mobi[co, ide]; break;
            }

            draw_set_halign(fa_right);
            draw_set_color(38144);
            draw_rectangle(x5, y5, x5 - string_width(string_hash_to_newline(title)), y5 + string_height(string_hash_to_newline(title)) - 2, 1);
            draw_text(x5, y5, string_hash_to_newline(string(title)));

            if (scr_hit(x5 - string_width(string_hash_to_newline(title)), y5, x5, y5 + string_height(string_hash_to_newline(title)) - 2)) {
                draw_set_color(c_white);
                draw_set_alpha(0.2);
                draw_rectangle(x5, y5, x5 - string_width(string_hash_to_newline(title)), y5 + string_height(string_hash_to_newline(title)) - 2, 0);

                if (scr_click_left()) {                   
                    var unit_type = type - 100;
                    var is_invalid = (
                        unit_type == eROLE.Dreadnought && gg > EquipmentSlot.WEAPON_TWO
                    );

                    if (!is_invalid) {
                        tab=1;
                        target_gear=gg;
                        item_name = [];
                        scr_get_item_names(
                            item_name,
                            unit_type, // eROLE
                            gg, // slot
                            eENGAGEMENT.Ranged,
                            false,  // no company standard
                            false   // don't limit to available items
                        );
                    }
                }
            }            
            draw_set_alpha(1);
            draw_set_color(38144);
            draw_set_halign(fa_left);
            draw_text(600, y5, string_hash_to_newline(string(geh)));
        }

        var confirm_gear_button = {
            alpha: 1,
            rects: [],
        }
        confirm_gear_button.alpha = target_gear > 0 ? 0.5 : 1;
        confirm_gear_button.rects = draw_unit_buttons([614,716], "CONFIRM",[1,1], 38144,, fnt_40k_14b, confirm_gear_button.alpha);
        if (point_and_click(confirm_gear_button.rects) and (target_gear = 0)) {
            var possible_custom_roles = [
                ["chapter_master", eROLE.ChapterMaster],
                ["honour_guard",eROLE.HonourGuard],
                ["veteran",eROLE.Veteran],
                ["terminator",eROLE.Terminator],
                ["captain",eROLE.Captain],
                ["dreadnought",eROLE.Dreadnought],
                ["champion",eROLE.Champion],
                ["tactical",eROLE.Tactical],
                ["devastator",eROLE.Devastator],
                ["assault",eROLE.Assault],
                ["ancient",eROLE.Ancient],
                ["scout",eROLE.Scout],
                ["chaplain",eROLE.Chaplain],
                ["apothecary",eROLE.Apothecary],
                ["techmarine",eROLE.Techmarine],
                ["librarian",eROLE.Librarian],
                ["sergeant",eROLE.Sergeant],
                ["veteran_sergeant",eROLE.VeteranSergeant],
            ];

            var _role_id = ide;
            for(var i = 0; i < array_length(possible_custom_roles); i++){
                if(possible_custom_roles[i][1] == _role_id){
                    var c_role = {
                        name: obj_creation.role[100][_role_id],
                        wep1: obj_creation.wep1[100][_role_id],
                        wep2: obj_creation.wep2[100][_role_id],
                        gear: obj_creation.gear[100][_role_id],
                        mobi: obj_creation.mobi[100][_role_id],
                        armour: obj_creation.armour[100][_role_id]
                    }
                    variable_struct_set(obj_creation.custom_roles, possible_custom_roles[i][0], c_role);
                }
            }

            instance_destroy();
        }

        draw_set_halign(fa_left);
        if (scr_hit(434,591,594,709)=true){
            tooltip="Gear";
            tooltip2="The equipment this Astartes Role defaults to.  Note that if defaults are set to expensive items the Astartes may instead be provided with more usual equipment.";
        }
    }
}




if (target_gear > 0) {
    tab = 1;
    item_name = [];
    scr_get_item_names(
        item_name,
        type - 100, // eROLE
        target_gear, // slot
        tab, // eEngagement
        false, // no company standard
        false  // don't limit to available items
    );
    
    draw_set_color(0);
    draw_rectangle(851, 210, 1168, 749, 0);
    
    draw_set_color(38144);
    draw_rectangle(844, 200, 1166, 748, 1);
    draw_rectangle(845, 201, 1165, 747, 1);
    draw_rectangle(846, 202, 1164, 746, 1);
    
    draw_set_font(fnt_40k_30b);
    var slot_name = get_slot_name(type - 100, target_gear);
    draw_text_transformed(862, 215, string_hash_to_newline($"Select {slot_name}"), 0.6, 0.6, 0);
    draw_set_font(fnt_40k_14b);
    
    var x3 = 862;
    var y3 = 245;
    var space = 18;
    
    for (var h = 0; h < array_length(item_name); h++) {
        draw_set_color(38144);
        var scale = string_width(string_hash_to_newline(item_name[h])) >= 140 ? 0.75 : 1;
        draw_text_transformed(x3, y3, string_hash_to_newline(item_name[h]), scale, 1, 0);
        y3 += space;
        
        if (scr_hit(x3, y3 - space, x3 + 143, y3 + 17 - space)) {
            draw_set_color(c_white);
            draw_set_alpha(0.2);
            draw_text_transformed(x3, y3 - space, string_hash_to_newline(item_name[h]), scale, 1, 0);
            draw_set_alpha(1);
            
            if (scr_click_left()) {
                var buh = item_name[h] == ITEM_NAME_NONE ? "" : item_name[h];
                switch (target_gear) {
                    case 1: obj_creation.wep1[co, ide] = buh; break;
                    case 2: obj_creation.wep2[co, ide] = buh; break;
                    case 3: obj_creation.armour[co, ide] = buh; break;
                    case 4: obj_creation.gear[co, ide] = buh; break;
                    case 5: obj_creation.mobi[co, ide] = buh; break;
                }
                target_gear = 0;
            }
        }
    }
    
    if (target_gear == 1 || target_gear == 2) {
        tab = 2;
        item_name = [];
        scr_get_item_names(
            item_name,
            type - 100, // eROLE
            target_gear, // slot
            tab, // eEngagement
            false, // no company standard
            false  // don't limit to available items
        );
        
        x3 = 862 + 146;
        y3 = 245;
        
        for (var h = 0; h < array_length(item_name); h++) {
            draw_set_color(38144);
            var scale = string_width(string_hash_to_newline(item_name[h])) >= 140 ? 0.75 : 1;
            draw_text_transformed(x3, y3, string_hash_to_newline(item_name[h]), scale, 1, 0);
            y3 += space;
            
            if (scr_hit(x3, y3 - space, x3 + 143, y3 + 17 - space)) {
                draw_set_color(c_white);
                draw_set_alpha(0.2);
                draw_text_transformed(x3, y3 - space, string_hash_to_newline(item_name[h]), scale, 1, 0);
                draw_set_alpha(1);

                if (scr_click_left()) {
                    var buh = item_name[h] == ITEM_NAME_NONE ? "" : item_name[h];
                    switch (target_gear) {
                        case 1: obj_creation.wep1[co, ide] = buh; break;
                        case 2: obj_creation.wep2[co, ide] = buh; break;
                        case 3: obj_creation.armour[co, ide] = buh; break;
                        case 4: obj_creation.gear[co, ide] = buh; break;
                        case 5: obj_creation.mobi[co, ide] = buh; break;
                    }
                    target_gear = 0;
                }
            }
        }
        
        tab = 1;
    }


    if (point_and_click(draw_unit_buttons([980,716], "CANCEL",[1,1], 38144,, fnt_40k_14b, 1))){
        target_gear=0;
    }
}







if (tooltip!="") and (obj_creation.change_slide<=0){
    draw_set_alpha(1);
    draw_set_font(fnt_40k_14);draw_set_halign(fa_left);draw_set_color(0);
    draw_rectangle(mouse_x+18,mouse_y+20,mouse_x+string_width_ext(string_hash_to_newline(tooltip2),-1,500)+24,mouse_y+44+string_height_ext(string_hash_to_newline(tooltip2),-1,500),0);
    draw_set_color(38144);
    draw_rectangle(mouse_x+18,mouse_y+20,mouse_x+string_width_ext(string_hash_to_newline(tooltip2),-1,500)+24,mouse_y+44+string_height_ext(string_hash_to_newline(tooltip2),-1,500),1);
    draw_set_font(fnt_40k_14b);draw_text(mouse_x+22,mouse_y+22,string_hash_to_newline(string(tooltip)));
    draw_set_font(fnt_40k_14);draw_text_ext(mouse_x+22,mouse_y+42,string_hash_to_newline(string(tooltip2)),-1,500);
}

/* */
/*  */
