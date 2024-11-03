
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



if (total_role_number>0) and (tab>0){   
    if (tab<=2){told=tab;tab=1;}
    if (tab>2){told=tab;tab=tab;}
    item_name = scr_get_item_names(
        tab,
        tab,
        obj_controller.settings,
        true, // include the company standard
        false, // do not limit to available items
    );
    tab=told;

    draw_set_color(0);
    draw_rectangle(xx+1183,yy+160,xx+1506,yy+747,0);
    
    draw_set_color(c_gray);
    draw_rectangle(xx+1184,yy+161,xx+1505,yy+746,1);
    draw_rectangle(xx+1185,yy+162,xx+1504,yy+745,1);
    draw_rectangle(xx+1186,yy+163,xx+1503,yy+744,1);
    
    draw_set_font(fnt_40k_30b);
    if (tab=1) then draw_text_transformed(xx+1203,yy+174,string_hash_to_newline("Select First Weapon"),0.6,0.6,0);
    if (tab=2) then draw_text_transformed(xx+1203,yy+174,string_hash_to_newline("Select Second Weapon"),0.6,0.6,0);
    if (tab=3) then draw_text_transformed(xx+1203,yy+174,string_hash_to_newline("Select Armour"),0.6,0.6,0);
    if (tab=4) then draw_text_transformed(xx+1203,yy+174,string_hash_to_newline("Select Special Item"),0.6,0.6,0);
    if (tab=5) then draw_text_transformed(xx+1203,yy+174,string_hash_to_newline("Select Mobility Item"),0.6,0.6,0);
    draw_set_font(fnt_40k_14b);
    
    
    var x3,y3,space,h;h=0;x3=xx+1205;y3=yy+205;space=18;
    repeat(23){
        h+=1;draw_set_color(c_gray);
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
                
                if (obj_controller.mouse_left=1) and (obj_controller.cooldown<=0){
                    var buh;buh=item_name[h];obj_controller.cooldown=8000;
                    if (item_name[h]="(None)") then buh="";
                    if (tab=1) then obj_ini.wep1[100][role]=buh;
                    if (tab=2) then obj_ini.wep2[100][role]=buh;
                    if (tab=3){
                        obj_ini.armour[100,role]=buh;
                        if (buh="Terminator Armour") then obj_ini.mobi[100,role]="";
                    }
                    if (tab=4) then obj_ini.gear[100,role]=buh;
                    if (tab=5) then obj_ini.mobi[100,role]=buh;
                    tab=0;refresh=true;
                }
            }
        }
    }
    if (tab=1) or (tab=2){
        if (tab<=2){told=tab;tab=2;}
        if (tab>2){told=tab;tab=tab;}
        item_name = scr_get_item_names(
            tab,
            tab,
            obj_controller.settings,
            true, // include the company standard
            false, // do not limit to available items
        );
        tab=told;
        
        var x3,y3,h,space;h=0;x3=xx+1205+146;y3=yy+205;space=18;
        repeat(23){h+=1;draw_set_color(c_gray);
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
                    
                    if (obj_controller.mouse_left=1) and (obj_controller.cooldown<=0){
                        var buh;buh=item_name[h];obj_controller.cooldown=8000;
                        if (item_name[h]="(None)") then buh="";
                        if (tab=1) then obj_ini.wep1[100,role]=buh;
                        if (tab=2) then obj_ini.wep2[100,role]=buh;
                        if (tab=3){
                            obj_ini.armour[100,role]=buh;
                            if (buh="Terminator Armour") then obj_ini.mobi[100,role]="";
                        }
                        if (tab=4) then obj_ini.gear[100,role]=buh;
                        if (tab=5) then obj_ini.mobi[100,role]=buh;
                        tab=0;refresh=true;
                    }
                }
            }
        }
        
        // tab=told;
    }
    
    
    
    draw_set_halign(fa_center);draw_set_font(fnt_40k_14b);
    draw_set_color(c_gray);draw_rectangle(xx+1347-(string_width(string_hash_to_newline("CANCEL"))/2),yy+720,xx+1347+(string_width(string_hash_to_newline("CANCEL"))/2),yy+741,0);
    draw_set_color(0);draw_text(xx+1347,yy+721,string_hash_to_newline("CANCEL"));
    if (scr_hit(xx+1347-(string_width(string_hash_to_newline("CANCEL"))/2),yy+720,xx+1347+(string_width(string_hash_to_newline("CANCEL"))/2),yy+741)=true){
        draw_set_color(c_white);draw_set_alpha(0.2);
        draw_rectangle(xx+1347-(string_width(string_hash_to_newline("CANCEL"))/2),yy+720,xx+1347+(string_width(string_hash_to_newline("CANCEL"))/2),yy+741,0);draw_set_alpha(1);
        if (obj_controller.mouse_left=1){obj_controller.cooldown=8000;tab=0;}
    }draw_set_alpha(1);
    
    
    
    
}

/* */
/*  */
