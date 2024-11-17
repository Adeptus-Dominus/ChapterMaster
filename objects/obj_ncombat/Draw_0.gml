
draw_sprite(spr_rock_bg,0,0,0);

draw_set_color(c_black);draw_set_alpha(1);
draw_rectangle(0,0,800,900,0);
draw_rectangle(818,235,1578,666,0);

draw_set_color(38144);

var l;l=0;
draw_set_alpha(1);draw_rectangle(0+l,0+l,800-l,900-l,1);l+=1;
draw_set_alpha(0.75);draw_rectangle(0+l,0+l,800-l,900-l,1);l+=1;
draw_set_alpha(0.5);draw_rectangle(0+l,0+l,800-l,900-l,1);l+=1;
draw_set_alpha(0.25);draw_rectangle(0+l,0+l,6800-l,900-l,1);

l=0;
draw_set_alpha(1);draw_rectangle(818+l,235+l,1578-l,666-l,1);l+=1;
draw_set_alpha(0.75);draw_rectangle(818+l,235+l,1578-l,666-l,1);l+=1;
draw_set_alpha(0.5);draw_rectangle(818+l,235+l,1578-l,666-l,1);l+=1;
draw_set_alpha(0.25);draw_rectangle(818+l,235+l,1578-l,666-l,1);


l=0;draw_set_alpha(1);
draw_set_font(fnt_40k_14);

if (display_p1>0) and (player_forces>0){
    draw_set_color(c_yellow);draw_set_halign(fa_left);
    draw_text(64,880,string_hash_to_newline(string(display_p1n)+": "+string(display_p1)+"HP"));
}
if (display_p2>0) and (enemy_forces>0){
    draw_set_color(c_yellow);draw_set_halign(fa_right);
    draw_text(800-64,880,string_hash_to_newline(string(display_p2n)+": "+string(display_p2)+"HP"));
}

draw_set_halign(fa_left);



repeat(45){l+=1;
    // draw_text(x+6,y-10+(l*14),"."+string(lines[31-l]));
    draw_set_color(38144);
    if (lines_color[l]="red") then draw_set_color(255);
    if (lines_color[l]="yellow") then draw_set_color(3055825);
    if (lines_color[l]="purple") then draw_set_color(c_purple);
    if (lines_color[l]="bright") then draw_set_color(65280);
    if (lines_color[l]="white") then draw_set_color(c_silver);
    if (lines_color[l]="blue"){
        var yep;yep=false;
        if (scr_has_adv("Daemon Binders")){
            yep=true;
        } 
       // if (yep=false) then draw_set_color(16711680); 
        if (yep=false) then draw_set_color(16646566); // making non daemon binders have the same colour, to see the text easier
        if (yep=true) then draw_set_color(16646566);
    }
    draw_text(x+6,y-10+(l*18),string_hash_to_newline(string(lines[l])));
}

draw_set_color(38144);
if (click_stall_timer<=0){
    if (fadein<0) and (fadein>-100) and (started=0){
        draw_set_alpha((fadein*-1)/30);
        draw_set_halign(fa_center);
        draw_text(400,860,string_hash_to_newline("[Press Enter to Begin]"));
    }
    if (started=2) or ((started=1) and ((timer_stage=3) or (timer_stage=5) or (timer_stage=0))) or (started=4){
        draw_set_halign(fa_center);
        draw_text(400,860,string_hash_to_newline("[Press Enter to Continue]"));
    }
    if (started=3) or (started=5){
        draw_set_halign(fa_center);
        draw_text(400,860,string_hash_to_newline("[Press Enter to Exit]"));
    }
}



draw_set_halign(fa_left);draw_set_alpha(1);

// Timer
// draw_rectangle(16,464,min(16+(timer*2.026),624),472,0);


// draw_text(320,300,"Turn: "+string(turns));


draw_set_color(c_black);
draw_set_alpha(fadein/30);
draw_rectangle(0,0,1600,900,0);
draw_set_alpha(1);

