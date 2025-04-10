var __b__;
__b__ = action_if_number(obj_popup, 0, 0);
if __b__
{
__b__ = action_if_variable(cd, 1, 1);
if __b__
{
__b__ = action_if_variable(click_stall_timer, 1, 1);
if __b__
{


// with(ob_ennt){shomesge(string(dudes[1])+"|"+string(dudes_num[1])+"|"+string(men+medi)+"|"+string(dudes_hp[1]));}

// 135;
// instance_activate_object(obj_cursor);

if (enemy_forces<=0) { // Combat for whatever reason sometimes bugs out when there are no enemies, so if enter is pressed 6 times at this state it will set started to 2
    enter_pressed++
}

if (started>=2) then instance_activate_object(obj_pnunit);

if (started=3){

    instance_activate_all();
    instance_activate_object(obj_pnunit);
    instance_activate_object(obj_enunit);
    instance_destroy(obj_popup);
    instance_destroy(obj_star_select);
    if (instance_exists(obj_pnunit)){
        obj_pnunit.alarm[6]=1;
    }
    
    alarm[7]=2;
    click_stall_timer=15;
}

// if (done>=1) then exit;



if (turn_count >= 50 || enter_pressed > 5) {
    started=2;
}
if ((started=2) or (started=4)){
    instance_activate_object(obj_pnunit);
    instance_activate_object(obj_enunit);
    // started=3;alarm[5]=3;obj_pnunit.alarm[4]=1;obj_pnunit.alarm[5]=2;obj_enunit.alarm[1]=3;
    started=3;
    // obj_pnunit.alarm[4]=2;obj_pnunit.alarm[5]=3;obj_enunit.alarm[1]=1;
    var _quad_factor = 10;
    total_battle_exp_gain = _quad_factor * sqr(threat);
    if (instance_exists(obj_enunit)){obj_enunit.alarm[1]=1;}
    instance_activate_object(obj_star);
    instance_activate_object(obj_event_log);
    alarm[5]=6;
    click_stall_timer=15;
    
    fack=1;
    
    newline="------------------------------------------------------------------------------";
    scr_newtext();
    newline="------------------------------------------------------------------------------";
    scr_newtext();
}

if (fadein<0) and (fadein>-100) and (started=0){
    fadein=-500;
    started=1;
    timer_speed=1;
    timer_stage=1;
    timer=100;
    
    if (enemy=30) then timer_stage=3;
    if (battle_special="ship_demon") then timer_stage=3;
}


if (started>0){// This might be causing problems?
    if (instance_exists(obj_pnunit)) then obj_pnunit.alarm[8]=8;
    if (instance_exists(obj_enunit)) then obj_enunit.alarm[8]=8;
}

function reset_combat_message_arrays(){
    for (var i=0;i<array_length(message);i++){
        message[i]="";
        message_sz[i]=0;
        message_priority[i]=0;
    }
}
if (timer_stage=1) or (timer_stage=5){
    if (global_perils>0) then global_perils-=1;
    if (global_perils<0) then global_perils=0;
    turns+=1;
    
    four_show=0;click_stall_timer=15;
    // if (battle_over!=1) then alarm[8]=15;

    if (enemy!=6){
        if (instance_exists(obj_enunit)){
            obj_enunit.alarm[1]=1;
        }
        if (instance_exists(obj_pnunit)){
            obj_pnunit.alarm[3]=2;
            obj_pnunit.alarm[1]=3;
            turn_count++;
            obj_pnunit.alarm[0]=4;
        }
        // alarm[9]=5;
    }

    else if (enemy==6){
        if (instance_exists(obj_enunit)){
            obj_enunit.alarm[1]=2;
            move_enemy_blocks();
            obj_enunit.alarm[0]=3;
        }
        if (instance_exists(obj_pnunit)){
            obj_pnunit.alarm[1]=1;
            turn_count++;
        }
    }
    messages=0;messages_to_show = 24;largest=0;random_messages=0;priority=0;messages_shown=0;
    reset_combat_message_arrays();
    timer_stage=2;timer=0;done=0;messages_shown=0;    
}



else if (timer_stage=3){
    if (battle_over!=1) then alarm[8]=15;
    click_stall_timer=15;

    if (enemy!=6){
        if (instance_exists(obj_pnunit)){
            obj_pnunit.alarm[1]=1;
            turn_count++;
        }
        if (instance_exists(obj_enunit)){
            obj_enunit.alarm[1]=2;
            move_enemy_blocks();
            obj_enunit.alarm[0]=3;
            obj_enunit.alarm[8]=4;
            turns+=1;
        }
        var messages=0;messages_to_show = 24;largest=0;random_messages=0;priority=0;messages_shown=0;
        reset_combat_message_arrays();
        timer_stage=4;timer=0;done=0;messages_shown=0;
    }
    if (enemy=6){
        if (instance_exists(obj_pnunit)){
            obj_pnunit.alarm[3]=2;
            obj_pnunit.alarm[1]=3;
            turn_count++;
            obj_pnunit.alarm[0]=4;
            turns+=1;
        }
        if (instance_exists(obj_enunit)){
            obj_enunit.alarm[1]=1;
        }
        // alarm[9]=5;
        var i;i=0;messages=0;messages_to_show = 24;largest=0;random_messages=0;priority=0;messages_shown=0;
        reset_combat_message_arrays();
        timer_stage=4;timer=0;done=0;messages_shown=0;
    }
}



}
}
}
