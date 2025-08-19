
draw_set_font(fnt_small);
draw_set_halign(fa_left);
draw_set_color(255);


if (obj_controller.force_scroll=1) then exit;


if (combating>0) then exit;
if (obj_controller.audience>0) then exit;

if (show=0) and (obj_controller.zoomed=0) and (current_popup=0) then draw_sprite(spr_loading,image_index,__view_get( e__VW.XView, 0 )+23,__view_get( e__VW.YView, 0 )+73);
if (show=0) and (obj_controller.zoomed=1) and (current_popup=0) then draw_sprite_ext(spr_loading,image_index,40,40,2,2,0,c_white,1);


if (show>0) and (current_battle<=battles){
    var xxx,yyy,i;
    xxx=__view_get( e__VW.XView, 0 )+535;
    yyy=__view_get( e__VW.YView, 0 )+200;
    i=current_battle;
    
    draw_sprite(spr_purge_panel,0,xxx,yyy);
    // if (battle_world[i]=-50) then draw_sprite(spr_attacked,1,xxx+12,yyy+54);
    // if (battle_world[i]>0) then draw_sprite(spr_attacked,0,xxx+12,yyy+54);
    if (battle_world[i]=-50) then scr_image("attacked",1,xxx+12,yyy+54,254,174);
    if (battle_world[i]>0) then scr_image("attacked",0,xxx+12,yyy+54,254,174);
    
    draw_set_font(fnt_40k_14);draw_set_halign(fa_left);draw_set_color(c_gray);
    draw_text(xxx+8,yyy+13,string_hash_to_newline(string(i)+"/"+string(battles)));
    
    draw_set_halign(fa_center);
    draw_set_font(fnt_40k_30b);
    
    if (battle_world[i]>0) then draw_text_transformed(xxx+265,yyy+11,string_hash_to_newline("Forces Attacked! ("+string(battle_location[i])+" "+scr_roman(battle_world[i])+")"),0.7,0.7,0);
    if (battle_world[i]=-50) then draw_text_transformed(xxx+265,yyy+11,string_hash_to_newline("Fleet Attacked! ("+string(battle_location[i])+" System)"),0.7,0.7,0);
    
    scr_image("ui/force",1,xxx+378-32,yyy+86-32,64,64);
    // draw_sprite(spr_force_icon,1,xxx+378,yyy+86);
    
    draw_set_font(fnt_40k_14);draw_set_halign(fa_left);
    
    
    
    if (battle_world[i]<0){
        draw_set_font(fnt_40k_14b);
        draw_set_halign(fa_left);
        
        draw_text(xxx+12,yyy+237,string_hash_to_newline("Enemy Fleets:"));
        draw_text(xxx+332,yyy+237,string_hash_to_newline("Allied Fleets:"));
        
        if (string(strin[1])="1") then draw_text(xxx+310,yyy+118,string_hash_to_newline(string(strin[1])+" Battleship ("+string(strin[4])+"% HP)"));
        if (string(strin[2])="1") then draw_text(xxx+310,yyy+138,string_hash_to_newline(string(strin[2])+" Frigate ("+string(strin[5])+"% HP)"));
        if (string(strin[3])="1") then draw_text(xxx+310,yyy+158,string_hash_to_newline(string(strin[3])+" Escort ("+string(strin[6])+"% HP)"));
        if (string(strin[1])!="1") then draw_text(xxx+310,yyy+118,string_hash_to_newline(string(strin[1])+" Battleships ("+string(strin[4])+"% HP)"));
        if (string(strin[2])!="1") then draw_text(xxx+310,yyy+138,string_hash_to_newline(string(strin[2])+" Frigates ("+string(strin[5])+"% HP)"));
        if (string(strin[3])!="1") then draw_text(xxx+310,yyy+158,string_hash_to_newline(string(strin[3])+" Escorts ("+string(strin[6])+"% HP)"));
    
        
        draw_set_halign(fa_center);
        
        if (enemy_fleet[1]!=0){
            // draw_sprite(spr_force_icon,enemy_fleet[1],xxx+44,yyy+269);
            scr_image("ui/force",enemy_fleet[1],xxx+44-32,yyy+269-32,64,64);
            var shw;shw="";
            if (ecap[1]=1) then shw+=string(ecap[1])+" Battleship#";
            if (ecap[1]!=1) then shw+=string(ecap[1])+" Battleships#";
            if (efri[1]=1) then shw+=string(efri[1])+" Frigate#";
            if (efri[1]!=1) then shw+=string(efri[1])+" Frigates#";
            if (eesc[1]=1) then shw+=string(eesc[1])+" Escort#";
            if (eesc[1]!=1) then shw+=string(eesc[1])+" Escorts#";
            
            draw_text_transformed(xxx+44,yyy+286,string_hash_to_newline(string(shw)),0.7,1,0);
            draw_set_halign(fa_center);draw_set_font(fnt_40k_14b);
        }
        if (enemy_fleet[2]!=0){
            // draw_sprite(spr_force_icon,enemy_fleet[2],xxx+154,yyy+269);
            scr_image("ui/force",enemy_fleet[2],xxx+154-32,yyy+269-32,64,64);
            var shw;shw="";
            if (ecap[2]=1) then shw+=string(ecap[2])+" Battleship#";
            if (ecap[2]!=1) then shw+=string(ecap[2])+" Battleships#";
            if (efri[2]=1) then shw+=string(efri[2])+" Frigate#";
            if (efri[2]!=1) then shw+=string(efri[2])+" Frigates#";
            if (eesc[2]=1) then shw+=string(eesc[2])+" Escort#";
            if (eesc[2]!=1) then shw+=string(eesc[2])+" Escorts#";
            
            draw_text_transformed(xxx+154,yyy+286,string_hash_to_newline(string(shw)),0.7,1,0);
            draw_set_halign(fa_center);draw_set_font(fnt_40k_14b);
        }
        if (enemy_fleet[3]!=0){
            // draw_sprite(spr_force_icon,enemy_fleet[3],xxx+264,yyy+269);
            scr_image("ui/force",enemy_fleet[3],xxx+264-32,yyy+269-32,64,64);
            var shw;shw="";
            if (ecap[3]=1) then shw+=string(ecap[3])+" Battleship#";
            if (ecap[3]!=1) then shw+=string(ecap[3])+" Battleships#";
            if (efri[3]=1) then shw+=string(efri[3])+" Frigate#";
            if (efri[3]!=1) then shw+=string(efri[3])+" Frigates#";
            if (eesc[3]=1) then shw+=string(eesc[3])+" Escort#";
            if (eesc[3]!=1) then shw+=string(eesc[3])+" Escorts#";
            
            draw_text_transformed(xxx+264,yyy+286,string_hash_to_newline(string(shw)),0.7,1,0);
            draw_set_halign(fa_center);draw_set_font(fnt_40k_14b);
        }
        
        if (allied_fleet[1]!=0){
            // draw_sprite(spr_force_icon,allied_fleet[1],xxx+374,yyy+269);
            scr_image("ui/force",allied_fleet[1],xxx+374-32,yyy+269-32,64,64);
            var shw;shw="";
            if (acap[1]=1) then shw+=string(acap[1])+" Battleship#";
            if (acap[1]!=1) then shw+=string(acap[1])+" Battleships#";
            if (afri[1]=1) then shw+=string(afri[1])+" Frigate#";
            if (afri[1]!=1) then shw+=string(afri[1])+" Frigates#";
            if (aesc[1]=1) then shw+=string(aesc[1])+" Escort#";
            if (aesc[1]!=1) then shw+=string(aesc[1])+" Escorts#";
            
            draw_text_transformed(xxx+374,yyy+286,string_hash_to_newline(string(shw)),0.7,1,0);
            draw_set_halign(fa_center);draw_set_font(fnt_40k_14b);
        }
        if (allied_fleet[2]!=0){
            // draw_sprite(spr_force_icon,allied_fleet[1],xxx+484,yyy+269);
            scr_image("ui/force",allied_fleet[1],xxx+484-32,yyy+269-32,64,64);
            var shw;shw="";
            if (acap[2]=1) then shw+=string(acap[2])+" Battleship#";
            if (acap[2]!=1) then shw+=string(acap[2])+" Battleships#";
            if (afri[2]=1) then shw+=string(afri[2])+" Frigate#";
            if (afri[2]!=1) then shw+=string(afri[2])+" Frigates#";
            if (aesc[2]=1) then shw+=string(aesc[2])+" Escort#";
            if (aesc[2]!=1) then shw+=string(aesc[2])+" Escorts#";
            
            draw_text_transformed(xxx+484,yyy+286,string_hash_to_newline(string(shw)),0.7,1,0);
            draw_set_halign(fa_center);draw_set_font(fnt_40k_14b);
        }
        
        
        
        
        
        draw_set_color(c_gray);draw_rectangle(xxx+132,yyy+354,xxx+259,yyy+389,0);
        draw_set_color(0);draw_text_transformed(xxx+195,yyy+362,string_hash_to_newline("Retreat"),1.1,1.1,0);
        if (scr_hit(xxx+132,yyy+354,xxx+259,yyy+389)=true){
            draw_set_alpha(0.2);draw_rectangle(xxx+132,yyy+354,xxx+259,yyy+389,0);draw_set_alpha(1);
        }
        
        draw_set_color(c_gray);draw_rectangle(xxx+272,yyy+354,xxx+399,yyy+389,0);
        draw_set_color(0);draw_text_transformed(xxx+335,yyy+362,string_hash_to_newline("Fight"),1.1,1.1,0);
        if (scr_hit(xxx+272,yyy+354,xxx+399,yyy+389)=true){
            draw_set_alpha(0.2);draw_rectangle(xxx+272,yyy+354,xxx+399,yyy+389,0);draw_set_alpha(1);
        }
        
    }
    
    
    if (battle_world[i]>=1){
        if (battle_opponent[i]<=20){
            draw_text(xxx+310,yyy+118,string_hash_to_newline(string(strin[1])+" Marines"));
            draw_text(xxx+310,yyy+138,string_hash_to_newline(string(strin[2])+" Vehicles"));
            if (strin[3]!="") then draw_text(xxx+310,yyy+158,string_hash_to_newline(string(strin[3])+" Fortified"));// Not / Barely / Lightly / Moderately / Highly / Maximally
        }
        
        draw_set_font(fnt_40k_14b);
        draw_set_halign(fa_left);
        
        draw_text(xxx+12,yyy+237,string_hash_to_newline("Enemy Factions:"));
        draw_text(xxx+332,yyy+237,string_hash_to_newline("Allies:"));
        
        
        
        draw_set_halign(fa_center);
        // draw_sprite(spr_force_icon,battle_opponent[i],xxx+44,yyy+289);
        scr_image("ui/force",battle_opponent[i],xxx+44-32,yyy+289-32,64,64);
        draw_text_transformed(xxx+44,yyy+316,string_hash_to_newline(string(strin[4])),0.75,1,0);
        draw_set_halign(fa_center);draw_set_font(fnt_40k_14b);
        
        
        draw_set_color(c_gray);draw_rectangle(xxx+132,yyy+354,xxx+259,yyy+389,0);
        draw_set_color(0);draw_text_transformed(xxx+195,yyy+362,string_hash_to_newline("Offensive"),1.1,1.1,0);
        if (scr_hit(xxx+132,yyy+354,xxx+259,yyy+389)=true){
            draw_set_alpha(0.2);draw_rectangle(xxx+132,yyy+354,xxx+259,yyy+389,0);draw_set_alpha(1);
        }
        
        draw_set_color(c_gray);draw_rectangle(xxx+272,yyy+354,xxx+399,yyy+389,0);
        draw_set_color(0);draw_text_transformed(xxx+335,yyy+362,string_hash_to_newline("Defensive"),1.1,1.1,0);
        if (scr_hit(xxx+272,yyy+354,xxx+399,yyy+389)=true){
            draw_set_alpha(0.2);draw_rectangle(xxx+272,yyy+354,xxx+399,yyy+389,0);draw_set_alpha(1);
        }
        
        
        
        
        
    }
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
