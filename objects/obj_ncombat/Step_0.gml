
if (fadein>-30) then fadein-=1;
if (cd>=0) then cd-=1;
if (click_stall_timer>=0) then click_stall_timer-=1;
// if (done>=1) then done+=1;




if (!instance_exists(obj_enunit)){
    enemy_forces=0;
}
if (!instance_exists(obj_pnunit)){
    player_forces=0;
}


if (fack=1) then instance_activate_object(obj_pnunit);
instance_activate_object(obj_centerline);
instance_activate_object(obj_cursor);


if ((fugg>=60) or (fugg2>=60)) and (messages_shown=0) and (messages_to_show=8) and (defeat_message=0){
    fugg=0;
    fugg2=0;
    with (obj_pnunit){
        target_block_is_valid(id,obj_pnunit);
    }
    with (obj_enunit){
        if (x<0){
            instance_destroy();
        } else {
            var nearest = instance_nearest(x,y,obj_pnunit);
            if (instance_exists(nearest)){
                if (point_distance(x, y, nearest.x, nearest.y) > 100){
                    instance_destroy();
                }
            }
        }

    }
    if ((messages_shown=999) or (messages=0)) and (timer_stage=2){
        newline_color="yellow";
        if (obj_ncombat.enemy!=6){
            if (enemy_forces<=0) or (!instance_exists(obj_enunit)) and (defeat_message=0){
                defeat_message=1;
                newline="Enemy Forces Defeated";
                timer_maxspeed=0;
                timer_speed=0;
                started=2;
                instance_activate_object(obj_pnunit);
            }
        }
        newline_color="yellow";
        if (obj_ncombat.enemy=6){
            if ((player_forces<=0) or (!instance_exists(obj_pnunit))) and (defeat_message=0){
                defeat_message=1;
                newline=string(global.chapter_name)+" Defeated";
                timer_maxspeed=0;
                timer_speed=0;
                started=4;
                defeat=1;
                instance_activate_object(obj_pnunit);
            }
        }
        messages_shown=105;
        done=1;
        scr_newtext();
        timer_stage=3;
        exit;
    }
    
    // show_message("Shown: "+string(messages_shown)+"#Messages: "+string(messages)+"#Timer Stage: "+string(timer_stage));
    if ((messages_shown=999) or (messages=0)) and ((timer_stage=4) or (timer_stage=5)) and (four_show=0){
        newline_color="yellow";
        if (obj_ncombat.enemy!=6){
            if ((player_forces<=0) or (!instance_exists(obj_pnunit))) and (defeat_message=0){defeat_message=1;newline=string(global.chapter_name)+" Defeated";timer_maxspeed=0;timer_speed=0;started=4;defeat=1;instance_activate_object(obj_pnunit);}
        }
        newline_color="yellow";
        if (obj_ncombat.enemy=6){
            if ((enemy_forces<=0) or (!instance_exists(obj_enunit))) and (defeat_message=0){defeat_message=1;newline="Enemy Forces Defeated";timer_maxspeed=0;timer_speed=0;started=2;instance_activate_object(obj_pnunit);}
        }
        messages_shown=105;
        done=1;
        scr_newtext();
        timer_stage=5;exit;
    }
    exit;
}








// if (player_forces>0) and (enemy_forces>0) and (battle_over=0){
    if (timer_stage=2) then fugg+=1;
    if (timer_stage=2) and (fugg>60){
        timer_stage=3;// if (!instance_exists(obj_pnunit)) or (!instance_exists(obj_enunit)){alarm[5]=1;started=4;defeat_message=1;}
    }
    
    if (timer_stage!=2) then fugg=0;
    if (timer_stage=4) then fugg2+=1;
    if (timer_stage=4) and (fugg2>60){
        timer_stage=5;// if (!instance_exists(obj_pnunit)) or (!instance_exists(obj_enunit)){alarm[5]=1;started=4;defeat_message=1;}
    }
    
    if (timer_stage!=4) then fugg2=0;
    
    
    

