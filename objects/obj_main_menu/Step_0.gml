
if (cooldown>0) then cooldown-=1;

var teh;teh=510;


if (stage=1){
    if (tim1<1) and (tim2=0) then tim1+=1/60;
    if (tim1>=0.99) and (tim2<teh) then tim2+=1;
}
if (tim2>=teh){stage=2;
    audio_sound_gain(snd_legal,0,60);
}


if (stage=2) then tim1-=1/60;
if (stage=2) and (tim1<=0){tim2-=1;

    if (tim2=(teh-28)) then alarm[2]=1;

    if (tim2<=teh-30){
        stage=3;
        tim3=60;
        
        audio_stop_all();
        
        global.sound=audio_play_sound(snd_prologue,0,true);
        audio_sound_gain(global.sound,0,0);
        // var nope;nope=0;if (master_volume=0) or (music_volume=0) then nope=1;
        // if (nope!=1){
        audio_sound_gain(global.sound,0.5*master_volume*music_volume,0);
        // }
    }
}

if (stage=3){
    if (tim3>-15) then tim3-=1;
    
    // if (round(random(70))=5){
    if (round(random(60))=5){
        part_particles_create(p_system,0,random(room_height),particle1,1);
    }
    
    if (tim3<=-15) then tim4+=0.75;
    if (tim4>=37.5) and (instance_exists(obj_cursor)){obj_cursor.image_alpha=1;}
}

if (fade>0) then fade-=0.5;
if (away>=1) then away+=1;
if (out_of_date>0) then out_of_date-=1;

mess_alpha+=1;
if (mess_alpha>120) then mess_alpha=0;


hi=0;



exit; // ???





if (fade<=20){

    if (mouse_x>=369) and (mouse_x<619){
        if (mouse_y>=183) and (mouse_y<200) then hi=1;
        if (mouse_y>=213) and (mouse_y<230) then hi=2;
        if (mouse_y>=243) and (mouse_y<260) then hi=3;
    }
    
    if (mouse_x>=414) and (mouse_y>=273) and (mouse_x<578) and (mouse_y<290) then hi=4;
    
    if (instance_exists(obj_saveload)){
        // if (scr_hit(sdfgsdgsdg)=true) then hi=6;
    }
}

if (mouse_x<552) or (mouse_y<441) or (mouse_x>608) or (mouse_y>457) and (browser=1) then browser=0;
