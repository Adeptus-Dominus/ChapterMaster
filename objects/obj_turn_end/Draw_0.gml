
draw_set_font(fnt_small);
draw_set_halign(fa_left);
draw_set_color(255);


if (obj_controller.force_scroll=1) then exit;


if (combating>0) then exit;
if (obj_controller.audience>0) then exit;

if (show=0) and (obj_controller.zoomed=0) and (current_popup=0) then draw_sprite(spr_loading,image_index,__view_get( e__VW.XView, 0 )+23,__view_get( e__VW.YView, 0 )+73);
if (show=0) and (obj_controller.zoomed=1) and (current_popup=0) then draw_sprite_ext(spr_loading,image_index,40,40,2,2,0,c_white,1);


if (show>0) and (current_battle<=battles){

    

}







/*

if (show>0) and (current_battle<=battles){
    var xxx,yyy,i;
    xxx=view_xview[0];
    yyy=view_yview[0];
    i=current_battle;
    
    if (battle_world[i]>0) then draw_sprite(spr_attacked,0,xxx+90,yyy+101);
    if (battle_world[i]=-50) then draw_sprite(spr_attacked,1,xxx+90,yyy+101);
    
    draw_set_font(fnt_info);draw_set_halign(fa_left);draw_set_color(38144);
    draw_text(xxx+103,yyy+115,string(i)+"/"+string(battles));
    
    draw_set_halign(fa_center);
    draw_set_font(fnt_fancy);
    
    if (battle_world[i]>0) then draw_text_transformed(xxx+313,yyy+111,"Forces Attacked!",1.5,1.5,0);
    if (battle_world[i]=-50) then draw_text_transformed(xxx+313,yyy+111,"Fleet Attacked!",1.5,1.5,0);
    
    if (battle_world[i]>0) then draw_text_transformed(xxx+313,yyy+144,"Planet "+string(battle_location[i])+" "+string(battle_world[i]),1,1,0);
    if (battle_world[i]=-50) then draw_text_transformed(xxx+313,yyy+144,string(battle_location[i])+" System",1,1,0);
    
    draw_sprite(spr_force_icon,1,xxx+340,yyy+191);
    if (battle_world[i]>0) then draw_sprite(spr_force_icon,battle_opponent[i],xxx+340,yyy+285);
    draw_set_font(fnt_40k_14);draw_set_halign(fa_left);
    
    
    
    
    if (battle_world[i]=-50){
        if (strin[1]!="0"){
        if (string(strin[1])="1") then draw_text(xxx+367,yyy+210,string(strin[1])+" Battleship ("+string(strin[4])+"% HP)");
        if (string(strin[1])!="1") then draw_text(xxx+367,yyy+210,string(strin[1])+" Battleships ("+string(strin[4])+"% HP)");}
        
        if (strin[2]!="0"){
        if (string(strin[2])="1") then draw_text(xxx+367,yyy+222,string(strin[2])+" Cruiser ("+string(strin[5])+"% HP)");
        if (string(strin[2])!="1") then draw_text(xxx+367,yyy+222,string(strin[2])+" Cruisers ("+string(strin[5])+"% HP)");}
        
        if (strin[3]!="0"){
        if (string(strin[3])="1") then draw_text(xxx+367,yyy+234,string(strin[3])+" Escort ("+string(strin[6])+"% HP)");
        if (string(strin[3])!="1") then draw_text(xxx+367,yyy+234,string(strin[3])+" Escorts ("+string(strin[6])+"% HP)");}
        
        
        if (strin[7]!="0"){
        if (string(strin[7])="1") draw_text(xxx+367,yyy+302,string(strin[7])+" Battleship ("+string(strin[10])+"% HP)");
        if (string(strin[7])!="1") draw_text(xxx+367,yyy+302,string(strin[7])+" Battleships ("+string(strin[10])+"% HP)");}
        
        if (strin[8]!="0"){
        if (string(strin[8])="1") draw_text(xxx+367,yyy+314,string(strin[8])+" Cruiser ("+string(strin[11])+"% HP)");
        if (string(strin[8])!="1") draw_text(xxx+367,yyy+314,string(strin[8])+" Cruisers ("+string(strin[11])+"% HP)");}
        
        if (strin[9]!="0"){
        if (string(strin[9])="1") draw_text(xxx+367,yyy+326,string(strin[9])+" Escort ("+string(strin[12])+"% HP)");
        if (string(strin[9])!="1") draw_text(xxx+367,yyy+326,string(strin[9])+" Escorts ("+string(strin[12])+"% HP)");}
        
        draw_rectangle(xxx+188,yyy+350,xxx+297,yyy+372,1);draw_rectangle(xxx+328,yyy+350,xxx+437,yyy+372,1);
        draw_set_alpha(0.5);
        draw_rectangle(xxx+189,yyy+351,xxx+296,yyy+371,1);draw_rectangle(xxx+329,yyy+351,xxx+436,yyy+371,1);
        draw_set_alpha(1);
        
        draw_set_halign(fa_center);
        draw_text(xxx+241,yyy+353,"Fight");draw_text(xxx+383,yyy+353,"Retreat");
        draw_set_halign(fa_left);
    }
    
    
    if (battle_world[i]>=1){
        if (battle_opponent[i]<=20){
            draw_text(xxx+367,yyy+210,string(strin[1])+" Marines");
            draw_text(xxx+367,yyy+222,string(strin[2])+" Vehicles");
            if (strin[3]!="") then draw_text(xxx+367,yyy+234,string(strin[3])+" Fortified");// Not / Barely / Lightly / Moderately / Highly / Maximally
        }
        
        draw_set_halign(fa_center);
        draw_text(xxx+440,yyy+302,string(strin[4]));
        
        draw_rectangle(xxx+188,yyy+350,xxx+297,yyy+372,1);draw_rectangle(xxx+328,yyy+350,xxx+437,yyy+372,1);
        draw_set_alpha(0.5);
        draw_rectangle(xxx+189,yyy+351,xxx+296,yyy+371,1);draw_rectangle(xxx+329,yyy+351,xxx+436,yyy+371,1);
        draw_set_alpha(1);
        
        draw_text(xxx+241,yyy+353,"Offensive");draw_text(xxx+383,yyy+353,"Defensive");
        draw_set_halign(fa_left);
    }
    



}*/


/* */

/* */
/*  */
