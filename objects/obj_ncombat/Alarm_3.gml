
// if (battle_over=1) then exit;
if (defeat_message=1) then exit;

if (wall_destroyed=1) then wall_destroyed=0;

var i,good,changed;i=0;good=0;changed=0;

// if (messages_to_show = 24) and (messages_shown=0) then alarm[6]=75;
// if (messages_shown=105) then exit;




/*i+=1;if (message[i]!="") then show_message(message[i]);
i+=1;if (message[i]!="") then show_message(message[i]);
i+=1;if (message[i]!="") then show_message(message[i]);
i+=1;if (message[i]!="") then show_message(message[i]);
i+=1;if (message[i]!="") then show_message(message[i]);
i+=1;if (message[i]!="") then show_message(message[i]);*/



repeat(100){
    if (good=0){
        changed=0;i=0;
        
        repeat(55){
            i+=1;
            
            // Collide the messages if needed
            if (message[i]="") and (message[i+1]!=""){
                message[i]=message[i+1];
                message_sz[i]=message_sz[i+1];
                message_priority[i]=message_priority[i+1];
                
                message[i+1]="";
                message_sz[i+1]=0;
                message_priority[i+1]=0;
                changed=1;
            }
            
            // Move larger messages up
            if (message[i]!="") and (message[i+1]!="") and (message_sz[i]<message_sz[i+1]) and ((message_priority[i]<message_priority[i+1]) or (message_priority[i]=0)){
                message[100]=message[i];
                message_sz[100]=message_sz[i];
                message_priority[100]=message_priority[i];
                
                message[i]=message[i+1];
                message_sz[i]=message_sz[i+1];
                message_priority[i]=message_priority[i+1];
                
                message[i+1]=message[100];
                message_sz[i+1]=message_sz[100];
                message_priority[i+1]=message_priority[100];
                changed=1;
            }
            
            // Move messages with higher priority up
            if (message[i]!="") and (message[i+1]!="") and (message_priority[i]<message_priority[i+1]){
                message[100]=message[i];
                message_sz[100]=message_sz[i];
                message_priority[100]=message_priority[i];
                
                message[i]=message[i+1];
                message_sz[i]=message_sz[i+1];
                message_priority[i]=message_priority[i+1];
                
                message[i+1]=message[100];
                message_sz[i+1]=message_sz[100];
                message_priority[i+1]=message_priority[100];
                changed=1;
            }
            
            if (changed=0) then good=1;
        }
    }
}




if ((messages>0) and (messages_shown<24)) and (messages_shown<=100){
    var that_sz,that;// show_message("Largest Message");
    that_sz=0;that=0;
    
    i=0;repeat(60){
        i+=1;
        if (message[i]!="") and (message_sz[i]>that_sz){
            that_sz=message_sz[i];that=i;
        }
    }
    if (that!=0) and (that_sz>0){
        newline=message[that];
        if (message_priority[that]>0) then newline_color="bright";
        if (string_count("lost",newline)>0) then newline_color="red";
        if (string_count("^",newline)>0){
            newline=string_replace(newline,"^","");
            newline_color="white";
        }

        if (message_priority[that]=134) then newline_color="purple";        
        if (message_priority[that]=135) then newline_color="blue";
        if (message_priority[that]=137) then newline_color="red";
        
        scr_newtext();
        messages_shown+=1;
        largest+=1;
        message[that]="";message_sz[that]=0;message_priority[that]=0;messages-=1;
    }
    
    alarm[3]=2;
}








if (messages=0) or (messages_shown>=24) then messages_shown=999;

if (messages=0) then messages_shown=999;

/*var noloss;noloss=instance_nearest(50,300,obj_pnunit);
if (!instance_exists(noloss)) then player_forces=0;
if (instance_exists(noloss)){if (point_distance(50,300,noloss.x,noloss.y)>500) then player_forces=0;}*/


if (instance_exists(obj_pnunit)){
    var plnear;plnear=instance_nearest(room_width,240,obj_pnunit);
    if (plnear.x<-40) then player_forces=0;
}
if (!instance_exists(obj_pnunit)) then player_forces=0;


if ((messages_shown=999) or (messages=0)) and (timer_stage=2){
    newline_color="yellow";
    if (obj_ncombat.enemy!=6){
        if (enemy_forces>0) and (obj_ncombat.enemy!=30) then newline="Enemy Forces at "+string(max(1,round((enemy_forces/enemy_max)*100)))+"%";
        if (obj_ncombat.enemy=30) and (instance_exists(obj_enunit)){newline="Enemy has ";var yoo;yoo=instance_nearest(0,0,obj_enunit);newline+=string(round(yoo.dudes_hp[1]))+"HP remaining";}
        if (enemy_forces<=0) or (!instance_exists(obj_enunit)) and (defeat_message=0){defeat_message=1;newline="Enemy Forces Defeated";timer_maxspeed=0;timer_speed=0;started=2;instance_activate_object(obj_pnunit);}
    }
    newline_color="yellow";
    if (obj_ncombat.enemy=6){
        var jims;jims=0;
        repeat(20){jims+=1;
            if (dead_jim[jims]!="") and (dead_jims>0){
                newline=dead_jim[jims];newline_color="red";
                scr_newtext();dead_jim[jims]="";dead_jims-=1;
            }
        }
        if (player_forces>0){newline=string(global.chapter_name)+" at "+string(round((player_forces/player_max)*100))+"%";four_show=0;}
        var plnear;plnear=instance_nearest(room_width,240,obj_pnunit);
        if ((player_forces<=0) or (plnear.x<-40)) and (defeat_message=0){defeat_message=1;newline=string(global.chapter_name)+" Defeated";timer_maxspeed=0;timer_speed=0;started=4;defeat=1;instance_activate_object(obj_pnunit);}
    }
    messages_shown=105;done=1;scr_newtext();timer_stage=3;exit;
}

if ((messages_shown=999) or (messages=0)) and ((timer_stage=4) or (timer_stage=5)) and (four_show=0){
    newline_color="yellow";
    if (obj_ncombat.enemy!=6){
        var jims;jims=0;
        repeat(20){jims+=1;
            if (dead_jim[jims]!="") and (dead_jims>0){
                newline=dead_jim[jims];newline_color="red";
                scr_newtext();dead_jim[jims]="";dead_jims-=1;
            }
        }
        if (player_forces>0){newline=string(global.chapter_name)+" at "+string(round((player_forces/player_max)*100))+"%";four_show=1;}
        var plnear;plnear=instance_nearest(room_width,240,obj_pnunit);
        if ((player_forces<=0) or (plnear.x<-40)) and (defeat_message=0){defeat_message=1;newline=string(global.chapter_name)+" Defeated";timer_maxspeed=0;timer_speed=0;started=4;defeat=1;instance_activate_object(obj_pnunit);}
    }
    newline_color="yellow";
    if (obj_ncombat.enemy=6){
        if (enemy_forces>0) then newline="Enemy Forces at "+string(max(1,round((enemy_forces/enemy_max)*100)))+"%";
        if ((enemy_forces<=0) or (!instance_exists(obj_enunit))) and (defeat_message=0){defeat_message=1;newline="Enemy Forces Defeated";timer_maxspeed=0;timer_speed=0;started=2;instance_activate_object(obj_pnunit);}
    }
    messages_shown=105;done=1;scr_newtext();timer_stage=5;exit;
}

/* */
/*  */
