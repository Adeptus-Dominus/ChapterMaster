
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
    if (cooldown>0) then cooldown-=1;
    if (fading=0) and (fade>0) then fade-=1;
    if (fading=1) and ((fade<40) or (crap>0) or (button=1)) then fade+=1;
    
    if (fade=60) then room_goto(Main_Menu);
    exit;
}

if (!instance_exists(obj_popup)) and (!instance_exists(obj_credits)) and (!instance_exists(obj_saveload)) and (fading=0){
    xx=126;if (mouse_x>=xx) and (mouse_y>yy) and (mouse_x<xx+265) and (mouse_y<yy+48) then hover[1]=1;
    xx=550;if (mouse_x>=xx) and (mouse_y>yy) and (mouse_x<xx+265) and (mouse_y<yy+48) then hover[2]=1;
    xx=968;if (mouse_x>=xx) and (mouse_y>yy) and (mouse_x<xx+265) and (mouse_y<yy+48) then hover[3]=1;
    xx=1280;if (mouse_x>=xx) and (mouse_y>yy) and (mouse_x<xx+265) and (mouse_y<yy+48) then hover[4]=1;
}
if ((instance_exists(obj_saveload)) or (instance_exists(obj_credits))) and (fading=0){
    xx=687;
    if (scr_hit(xx,yy,xx+265,yy+48)=true) then hover[6]=1;
}



if (cooldown>0) then cooldown-=1;
if (fading=0) and (fade>0) then fade-=1;
if (fading=1) and ((fade<40) or (button=4) or (crap>0)) then fade+=1;

if (crap>0) and (fade=60){
    with(obj_main_menu){
        part_particles_clear(p_system);
        instance_destroy();
    }
}
if (crap=1) and (fade=60) then room_goto(Tutorial);
if (crap>1) and (fade=60){audio_stop_all();room_goto(Creation);}

if (button=4) and (fade=40) then with(obj_cursor){instance_destroy();}
if (button=4) and (fade>=60) then game_end();

if (button=6) and (fade=40){
    with(obj_saveload){instance_destroy();}
    with(obj_credits){instance_destroy();}
    fading=0;button=0;obj_main_menu.menu=0;
}


