var xx,yy;yy=784;
if (instance_exists(obj_saveload)) or (instance_exists(obj_credits)) then yy=830;
if (oth<40) then oth+=1;

if (room_get_name(room)="Creation"){
    xx=x;yy=y;
    var _spr_height = sprite_get_height(spr_mm_butts_small) * 2;
    var _spr_width = sprite_get_width(spr_mm_butts_small) * 2;
    if (scr_hit(xx,yy,xx+_spr_width,yy+_spr_height) && fading==0) {
        hover[1]=1; //hovering on exit
    } else {
        hover[1]=0; //not hovering on exit
    }
    if (cooldown > 0) { cooldown -= global.frame_timings.t1; }
    if (fading == 0) && (fade > 0) { fade -= global.frame_timings.t1; }
    if (fading == 1) && ((fade < 40) || (crap > 0) || (button == 1)) { fade += global.frame_timings.t1; }
    
    if (fade >= 60) { room_goto(Main_Menu); }
    exit;
}

if (!instance_exists(obj_popup)) && (!instance_exists(obj_credits)) && (!instance_exists(obj_saveload)) && (fading == 0) {
    xx=126;if (mouse_x>=xx) and (mouse_y>yy) and (mouse_x<xx+265) and (mouse_y<yy+48) then hover[1]=1;
    xx=550;if (mouse_x>=xx) and (mouse_y>yy) and (mouse_x<xx+265) and (mouse_y<yy+48) then hover[2]=1;
    xx=968;if (mouse_x>=xx) and (mouse_y>yy) and (mouse_x<xx+265) and (mouse_y<yy+48) then hover[3]=1;
    xx=1280;if (mouse_x>=xx) and (mouse_y>yy) and (mouse_x<xx+265) and (mouse_y<yy+48) then hover[4]=1;
}
if ((instance_exists(obj_saveload)) || (instance_exists(obj_credits))) && (fading == 0) {
    xx=687;
    if (scr_hit(xx,yy,xx+265,yy+48)=true) then hover[6]=1;
}



if (cooldown > 0) { cooldown -= global.frame_timings.t1; }
if (fading == 0) && (fade > 0) { fade -= global.frame_timings.t1; }
if (fading == 1) && ((fade < 40) || (button == 4) || (crap > 0)) { fade += global.frame_timings.t1; }

if (crap > 0) && (fade >= 60){
    with(obj_main_menu){
        part_particles_clear(p_system);
        instance_destroy();
    }
}
if (crap == 1) && (fade >= 60) { room_goto(Tutorial); }
if (crap > 1) && (fade >= 60) {audio_stop_all(); room_goto(Creation);}

if (button == 4) && (fade >= 40) { with(obj_cursor) { instance_destroy(); } }
if (button == 4) && (fade >= 60) { game_end(); }

if (button == 6) && (fade >= 40) {
    with(obj_saveload) { instance_destroy(); }
    with(obj_credits) { instance_destroy(); }
    fading = 0; button = 0; obj_main_menu.menu = 0;
}


