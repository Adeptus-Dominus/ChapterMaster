/// @description Insert description here
// You can write your code in this editor
// Draws the main UI menu. The function is used to highlight if you selected something in the menu
if instance_exists
var l_hei=37,l_why=0;

if (instance_exists(obj_saveload)) then exit;
if (instance_exists(obj_ncombat)) then exit;
if (instance_exists(obj_fleet)) then exit;
if (global.load>=0) then exit;
if (invis==true) then exit;

if (is_test_map==true){
    draw_set_color(c_yellow);
    draw_set_alpha(0.5);
    draw_line_width(room_width/2,room_height/2,(room_width/2)+lengthdir_x(3000,terra_direction),(room_height/2)+lengthdir_y(3000,terra_direction),4);
    draw_set_alpha(1);
}
// if (instance_exists(obj_turn_end)) then exit;

var xx = 0;
var yy = 0;
// Main UI
if (!zoomed && !zui){
    draw_sprite(spr_new_ui,menu==0,0,0);
    draw_set_color(c_white);

    menu_buttons.chapter_manage.draw(34,838+y_slide, "Chapter Management",1,1,145)
    menu_buttons.chapter_settings.draw(179,838+y_slide, "Chapter Settings",1,1,145)
    menu_buttons.apoth.draw(357,838+y_slide, "Apothecarium")
    menu_buttons.reclu.draw(473,838+y_slide, "Reclusium")
    menu_buttons.lib.draw(590,838+y_slide, "Librarium")
    menu_buttons.arm.draw(706,838+y_slide, "Armamentarium")
    menu_buttons.recruit.draw(822,838+y_slide, "Recruitment")
    menu_buttons.fleet.draw(938,838+y_slide, "Fleet")
    menu_buttons.diplo.draw(1130,838+y_slide, "Diplomacy",1,1,145)
    menu_buttons.event.draw(1275,838+y_slide, "Event Log",1,1,145)
    menu_buttons.end_turn.draw(1420,838+y_slide, "End Turn",1,1,145);
    menu_buttons.help.draw(1374,8+y_slide, "Help");
    menu_buttons.menu.draw(1484,8+y_slide, "Menu");
    
    
    if (y_slide>0) then draw_set_alpha((100-(y_slide*2))/100);

    draw_set_alpha(1);
    draw_sprite(spr_new_banner,0,1439+new_banner_x,62);
    draw_sprite(spr_new_ui_cover,0,0,(900-17));
    
    var sprx = 1451+new_banner_x,
        spry = 73,
        sprw = 141,
        sprh = 141;
    
    if (sprite_exists(global.chapter_icon_sprite)){
        draw_sprite_stretched(global.chapter_icon_sprite, global.chapter_icon_frame, sprx, spry, sprw, sprh);
    }
       
    
    draw_set_color(38144);
    draw_set_font(fnt_menu);
    draw_set_halign(fa_center);
    // Draws the sector name
    var _sector_string = $"Sector {obj_ini.sector_name ?? "Terra Nova"}";
    draw_text(775,17,_sector_string);
    draw_text(775.5,17.5,_sector_string);
    
    // Checks if you are penitent
    if (obj_controller.faction_status[eFACTION.Imperium]!="War"){
        if (penitent_max==0){
            draw_text(998,17,string_hash_to_newline("Loyal"));
            draw_text(998,17.5,string_hash_to_newline("Loyal"));
        }
        if (penitent_max>0){
            var endb=0,endb2="";
            endb=min(0,(((penitent_turn+1)*(penitent_turn+1))-120)*-1);
            if (endb<0) then endb2=" "+string(endb);
            draw_set_color(c_red);
            draw_text(998,17,string_hash_to_newline(string(min(100,floor((penitent_current/penitent_max)*100)))+"% Penitent"));
            draw_text(998,17.5,string_hash_to_newline(string(min(100,floor((penitent_current/penitent_max)*100)))+"% Penitent"));
            draw_set_color(38144);
            // TODO Need a tooltip for here to display the actual amounts
        }
    }
    // Sets you to renegade
    if (obj_controller.faction_status[eFACTION.Imperium]=="War"){
        draw_set_color(255);
        draw_text(998,17,string_hash_to_newline("Renegade"));
        draw_text(998,17.5,string_hash_to_newline("Renegade"));
        draw_set_color(38144);
    }
    if (menu==0){
        if (obj_controller.imp_ships == 0 && obj_controller.turn<2){
            sector_imperial_fleet_strength();
        }
        draw_text(850, 60, $"Sector Fleet Strength {imp_ships}/{max_fleet_strength}");
        if (scr_hit([700, 60, 1000, 80])){
            tooltip_draw("The relative strength of the imperial navy and defence fleet forces and their max supported strength. Increase The number of imperial aligned planets and active forge worlds to increase the limit")
        }
    }    // Checks if the chapter name is less than 140 chars, adjusts chapter_master_name_width accordingly
    var chapter_master_name_width=1;
    for(var i=0; i<10; i++){
        if ((string_width(string_hash_to_newline(string(global.chapter_name)))*chapter_master_name_width)>140) then chapter_master_name_width-=0.1;
    }

    draw_text_transformed(1520+new_banner_x,208,string_hash_to_newline(string(global.chapter_name)),chapter_master_name_width,1,0);
    draw_text_transformed(1520.5+new_banner_x,208.5,string_hash_to_newline(string(global.chapter_name)),chapter_master_name_width,1,0);
    // Shows the date to be displayed
    var yf="";
    if (year_fraction<10) then yf="00"+string(year_fraction);
    if (year_fraction>=10) and (year_fraction<100) then yf="0"+string(year_fraction);
    if (year_fraction>=100) then yf=string(year_fraction);
    draw_text(1520+new_banner_x,228,string_hash_to_newline(string(check_number)+" "+string(yf)+" "+string(year)+".M"+string(millenium)));
    // Shows the income on the menu
    var inc="";
    if (income_last>0) then inc="+"+string(round(income_last));
    if (income_last<0) then inc=string(round(income_last));
    draw_set_font(fnt_40k_14);
    draw_set_halign(fa_left);
    // Draws the requisition amount
    draw_sprite(spr_new_resource,0,14,16);
    draw_set_color(16291875);
    draw_text(36,16,string_hash_to_newline(string(floor(requisition))+string(inc)));
    draw_text(36.5,16.5,string_hash_to_newline(string(floor(requisition))+string(inc)));
    // Draws forge points
    draw_sprite_ext(spr_forge_points_icon, 0, 160, 15, 0.3, 0.3, 0, c_white, 1)
    draw_set_color(#af5a00)
    draw_text(180,16, string(forge_points));
    draw_text(180.5,16.5, string(forge_points));
    // Draws apothecary points
    var _apoth_string = ($"apothecary points : {specialist_point_handler.apothecary_points}");
    draw_text(180,32, _apoth_string);
    draw_text(180.5,32.5, _apoth_string);
    // Draws the current loyalty
    draw_sprite(spr_new_resource,1,267,17);
    draw_set_color(1164001);
    draw_text(290,16,string_hash_to_newline(string(loyalty)));
    draw_text(290.5,16.5,string_hash_to_newline(string(loyalty)));
    // Draws the current gene seed
    draw_sprite(spr_new_resource,2,355,17);
    draw_set_color(c_red);
    draw_text(370,16,string_hash_to_newline(string(gene_seed)));
    draw_text(370.5,16.5,string_hash_to_newline(string(gene_seed)));
    // Draws the current marines in your command
    draw_sprite(spr_new_resource,3,475-10,17);
    draw_set_color(16291875);
    draw_text(495-10,16,string_hash_to_newline(string(marines)+"/"+string(command)));
    draw_text(495.5-10,16.5,string_hash_to_newline(string(marines)+"/"+string(command)));

    if (menu==0){
        location_viewer.draw();
    }
}
draw_set_font(fnt_40k_14b);
draw_set_color(c_red);
draw_set_halign(fa_left);
draw_set_alpha(1);
// Sets up debut mode
if (global.cheat_debug == true){
    draw_text(1124, 7, string_hash_to_newline("DEBUG MODE"));
}


function draw_line(x1, y1, y_slide, variable) {
    l_hei = 37;
    l_why = 0;

    if (variable > 0) {
        if (variable > 94) {
            l_hei = 134 - variable;
            l_why = min(variable - 96, 11);
        }

        draw_line(view_xview[0] + variable + x1, view_yview[0] + 10 + 1 + l_why, view_xview[0] + variable + x1, view_yview[0] + 10 + 37 - l_why);
    }
}








