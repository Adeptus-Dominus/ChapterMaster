
if (enemy_forces!=0) and (player_forces!=0) and (battle_over=0){

    if ((enemy=6)) and (timer_stage=2){
        timer_stage=3;
        
        messages=0;messages_to_show = 24;largest=0;random_messages=0;priority=0;messages_shown=0;
    }
    
    if ((enemy!=6)) and (timer_stage=2){
        timer_stage=3;
        
        messages=0;messages_to_show = 24;largest=0;random_messages=0;priority=0;messages_shown=0;
    }
    
    if ((enemy=6)) and (timer_stage=4){
        timer_stage=5;
        
        messages=0;messages_to_show = 24;largest=0;random_messages=0;priority=0;messages_shown=0;
    }
    
    if ((enemy!=6)) and (timer_stage=4){
        timer_stage=5;
        
        messages=0;messages_to_show = 24;largest=0;random_messages=0;priority=0;messages_shown=0;
    }

}


