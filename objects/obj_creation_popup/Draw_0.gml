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
        if (type=1) then draw_text_transformed(444,550,string_hash_to_newline("Primary Color"),0.6,0.6,0);
        if (type=2) then draw_text_transformed(444,550,string_hash_to_newline("Secondary Color"),0.6,0.6,0);
        if (type=3) then draw_text_transformed(444,550,string_hash_to_newline("Pauldron 1 Color"),0.6,0.6,0);
        if (type=4) then draw_text_transformed(444,550,string_hash_to_newline("Pauldron 2 Color"),0.6,0.6,0);
        if (type=5) then draw_text_transformed(444,550,string_hash_to_newline("Trim Color"),0.6,0.6,0);
        if (type=6) then draw_text_transformed(444,550,string_hash_to_newline("Lens Color"),0.6,0.6,0);
        if (type=7) then draw_text_transformed(444,550,string_hash_to_newline("Weapon Color"),0.6,0.6,0);
        if (type="sgt_helm_primary") then draw_text_transformed(444,550,string_hash_to_newline("Sgt Helm"),0.6,0.6,0);
        if (type="sgt_helm_secondary") then draw_text_transformed(444,550,string_hash_to_newline("Sgt Helm"),0.6,0.6,0);
        rows = 4;
        columns = 10;
        var column;
        var current_color = 0;
        var row = 0;
        repeat(rows) {
            row += 1;
            column = 0;
            repeat(columns) {
                column += 1;
                if (current_color < global.colors_count) {
                    draw_set_color(make_color_rgb(obj_creation.col_r[current_color], obj_creation.col_g[current_color], obj_creation.col_b[current_color]));
                    var x1, x2, y1, y2;
                    x1 = 396 + (column * 40);
                    y1 = 541 + (row * 40);
                    x2 = 436 + (column * 40);
                    y2 = 581 + (row * 40);
                    draw_rectangle(x1, y1, x2, y2, 0);
                    draw_set_color(38144);
                    draw_rectangle(x1, y1, x2, y2, 1);
                    if (scr_hit(x1, y1, x2, y2) = true) {
                        draw_set_color(c_white);
                        draw_set_alpha(0.2);
                        draw_rectangle(x1, y1, x2, y2, 0);
                        draw_set_alpha(1);
                        if (obj_creation.mouse_left = 1) and(obj_creation.cooldown <= 0) {
                            if (type = 1) then obj_creation.main_color = current_color;
                            if (type = 2) then obj_creation.secondary_color = current_color;
                            if (type = 3) then obj_creation.pauldron2_color = current_color;
                            if (type = 4) then obj_creation.pauldron_color = current_color;
                            if (type = 5) then obj_creation.trim_color = current_color;
                            if (type = 6) then obj_creation.lens_color = current_color;
                            if (type = 7) then obj_creation.weapon_color = current_color;
                            if (is_string(type)){
                                obj_creation.complex_livery_data[$ role][$ type] = current_color;
                            }
                            with(obj_creation) {
                                shader_reset();
                            }
                            obj_creation.alarm[0] = 1;
                            obj_creation.cooldown = 8000;
                            instance_destroy();
                        }
                    }
                    current_color += 1;
                }
            }
        }
        

        if (point_and_click(draw_unit_buttons([700,550], "CANCEL",[1,1], 38144,, fnt_40k_14b, 1))){
            obj_creation.cooldown=8000
            instance_destroy();
        }

        if (!scr_hit(430,536,845,748) && mouse_check_button_pressed(mb_left) &&  obj_creation.cooldown == 0) {
            obj_creation.cooldown = 8000;
            instance_destroy();
        }
        draw_set_alpha(1);
    }
    
    
    
    if (equip){
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
            if (obj_creation.mouse_left=1) and (obj_creation.cooldown<=0){
                obj_creation.text_selected=$"unit_name{ide}";
                obj_creation.cooldown=8000;
                keyboard_string=obj_creation.role[co,ide];
            }
        }
        if (obj_creation.text_selected="unit_name"+string(ide)) then obj_creation.role[co,ide]=keyboard_string;
        draw_rectangle(444-1,550-1,822,550+hei,1);
        draw_set_color(38144);
        
        
        draw_set_font(fnt_40k_14b);
        draw_set_halign(fa_right);
        
        /*if (target_gear=1) then draw_text_transformed(594,575,"Primary Weapon",0.5,0.5,0);
        if (target_gear=2) then draw_text_transformed(594,575,"Secondary Weapon",0.5,0.5,0);
        if (target_gear=3) then draw_text_transformed(594,575,"Armour",0.5,0.5,0);
        if (target_gear=4) then draw_text_transformed(594,575,"Mobility Item",0.5,0.5,0);
        if (target_gear=5) then draw_text_transformed(594,575,"Special Gear",0.5,0.5,0);*/
        
        
        
        var gg,x5,y5,title,geh;title="";geh="";spacing=22;gg=0;
        x5=594;y5=597-spacing;
        
        repeat(5){
            gg+=1;y5+=spacing;
            if (gg=1){title="Main Weapon: ";geh=obj_creation.wep1[co,ide];}
            if (gg=2){title="Secondary Weapon: ";geh=obj_creation.wep2[co,ide];}
            if (gg=3){title="Armour: ";geh=obj_creation.armour[co,ide];}
            if (gg=4){title="Mobility Item: ";geh=obj_creation.mobi[co,ide];}
            if (gg=5){title="Special Item: ";geh=obj_creation.gear[co,ide];}
            
            draw_set_halign(fa_right);
            draw_set_color(38144);
            draw_rectangle(x5,y5,x5-string_width(string_hash_to_newline(title)),y5+string_height(string_hash_to_newline(title))-2,1);
            draw_text(x5,y5,string_hash_to_newline(string(title)));
            
            if (scr_hit(x5-string_width(string_hash_to_newline(title)),y5,x5,y5+string_height(string_hash_to_newline(title))-2)=true){
                draw_set_color(c_white);draw_set_alpha(0.2);
                draw_rectangle(x5,y5,x5-string_width(string_hash_to_newline(title)),y5+string_height(string_hash_to_newline(title))-2,0);
                if (obj_creation.mouse_left=1) and (obj_creation.cooldown<=0){
                
                    var bad;bad=0;
                    if (type=106) and ((gg=3) or (gg=4) or (gg=5)) then bad=1;
                    
                    if (bad=0){
                        obj_creation.cooldown=8000;
                        tab=1;
                        
                        if (gg<4) then target_gear=gg;
                        if (gg=4) then target_gear=5;
                        if (gg=5) then target_gear=4;
                        
                        scr_weapons_equip();// Gets item list
                    }
                }
            }
            draw_set_alpha(1);draw_set_color(38144);
            draw_set_halign(fa_left);draw_text(600,y5,string_hash_to_newline(string(geh)));
        }
        
        var confirm_gear_button = {
            alpha: 1,
            rects: [],
        }
        confirm_gear_button.alpha = target_gear > 0 ? 0.5 : 1;
        confirm_gear_button.rects = draw_unit_buttons([614,716], "CONFIRM",[1,1], 38144,, fnt_40k_14b, confirm_gear_button.alpha);
        if (point_and_click(confirm_gear_button.rects) and (target_gear = 0)) {
            obj_creation.cooldown = 8000;
            instance_destroy();
        }
        
        draw_set_halign(fa_left);
        if (scr_hit(434,591,594,709)=true){
            tooltip="Gear";tooltip2="The equipment this Astartes Role defaults to.  Note that if defaults are set to expensive items the Astartes may instead be provided with more usual equipment.";
        }
    }
}




if (target_gear>0){
    var i;i=-1;repeat(50){i+=1;item_name[i]="";}
    tab=1;scr_weapons_equip();
    
    draw_set_color(0);
    draw_rectangle(851,210,1168,749,0);
    
    draw_set_color(38144);
    draw_rectangle(844,200,1166,748,1);
    draw_rectangle(845,201,1165,747,1);
    draw_rectangle(846,202,1164,746,1);
    
    draw_set_font(fnt_40k_30b);
    if (target_gear=1) then draw_text_transformed(862,215,string_hash_to_newline("Select First Weapon"),0.6,0.6,0);
    if (target_gear=2) then draw_text_transformed(862,215,string_hash_to_newline("Select Second Weapon"),0.6,0.6,0);
    if (target_gear=3) then draw_text_transformed(862,215,string_hash_to_newline("Select Armour"),0.6,0.6,0);
    if (target_gear=4) then draw_text_transformed(862,215,string_hash_to_newline("Select Mobility Item"),0.6,0.6,0);
    if (target_gear=5) then draw_text_transformed(862,215,string_hash_to_newline("Select Special Item"),0.6,0.6,0);
    draw_set_font(fnt_40k_14b);
    
    var x3,y3,space,h;h=0;x3=862;y3=245;space=18;
    repeat(23){h+=1;draw_set_color(38144);
        if (item_name[h]!=""){
            if (string_width(string_hash_to_newline(item_name[h]))>=140) then draw_text_transformed(x3,y3,string_hash_to_newline(item_name[h]),0.75,1,0);
            if (string_width(string_hash_to_newline(item_name[h]))<140) then draw_text_transformed(x3,y3,string_hash_to_newline(item_name[h]),1,1,0);y3+=space;
            
            // x2 was 1150
            if (scr_hit(x3,y3-space,x3+143,y3+17-space)=true){
                if (string_width(string_hash_to_newline(item_name[h]))<140){
                    draw_set_color(c_white);draw_set_alpha(0.2);
                    draw_text_transformed(x3,y3-space,string_hash_to_newline(item_name[h]),1,1,0);draw_set_alpha(1);
                }
                if (string_width(string_hash_to_newline(item_name[h]))>=140){
                    draw_set_color(c_white);draw_set_alpha(0.2);
                    draw_text_transformed(x3,y3-space,string_hash_to_newline(item_name[h]),0.75,1,0);draw_set_alpha(1);
                }
                
                if (obj_creation.mouse_left=1) and (obj_creation.cooldown<=0){
                    var buh;buh=item_name[h];obj_creation.cooldown=8000;
                    if (item_name[h]="(None)") then buh="";
                    if (target_gear=1) then obj_creation.wep1[co,ide]=buh;
                    if (target_gear=2) then obj_creation.wep2[co,ide]=buh;
                    if (target_gear=3) then obj_creation.armour[co,ide]=buh;
                    if (target_gear=4) then obj_creation.gear[co,ide]=buh;
                    if (target_gear=5) then obj_creation.mobi[co,ide]=buh;
                    target_gear=0;
                }
            }
        }
    }
    
    if (target_gear=1) or (target_gear=2){
        var i;i=-1;repeat(50){i+=1;item_name[i]="";}
        tab=2;scr_weapons_equip();
        
        var x3,y3,h,space;h=0;x3=862+146;y3=245;space=18;
        repeat(23){h+=1;draw_set_color(38144);
            if (item_name[h]!=""){
                if (string_width(string_hash_to_newline(item_name[h]))>=140) then draw_text_transformed(x3,y3,string_hash_to_newline(item_name[h]),0.75,1,0);
                if (string_width(string_hash_to_newline(item_name[h]))<140) then draw_text_transformed(x3,y3,string_hash_to_newline(item_name[h]),1,1,0);y3+=space;
                
                if (scr_hit(x3,y3-space,x3+143,y3+17-space)=true){
                    
                    if (string_width(string_hash_to_newline(item_name[h]))<140){
                        draw_set_color(c_white);draw_set_alpha(0.2);
                        draw_text_transformed(x3,y3-space,string_hash_to_newline(item_name[h]),1,1,0);draw_set_alpha(1);
                    }
                    if (string_width(string_hash_to_newline(item_name[h]))>=140){
                        draw_set_color(c_white);draw_set_alpha(0.2);
                        draw_text_transformed(x3,y3-space,string_hash_to_newline(item_name[h]),0.75,1,0);draw_set_alpha(1);
                    }
                    
                    if (obj_creation.mouse_left=1) and (obj_creation.cooldown<=0){
                        var buh;buh=item_name[h];obj_creation.cooldown=8000;
                        if (item_name[h]="(None)") then buh="";
                        if (target_gear=1) then obj_creation.wep1[co,ide]=buh;
                        if (target_gear=2) then obj_creation.wep2[co,ide]=buh;
                        if (target_gear=3) then obj_creation.armour[co,ide]=buh;
                        if (target_gear=4) then obj_creation.gear[co,ide]=buh;
                        if (target_gear=5) then obj_creation.mobi[co,ide]=buh;
                        target_gear=0;
                    }
                }
            }
        }
        
        tab=1;
    }
    
    
    if (point_and_click(draw_unit_buttons([980,716], "CANCEL",[1,1], 38144,, fnt_40k_14b, 1))){
        target_gear=0;
        obj_creation.cooldown=8000
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
