
// show_message("biiiiiIIIng");
try_and_report_loop("battle alarm 0 loop", function(){
instance_activate_object(obj_star);
combating=0;

var i;


i=50;
repeat(50){
    i-=1;
    
    if (battles<=i) and (i>=2){
        if (battle[i]!=0) and (battle[i-1]!=0) and (battle_world[i]=-50) and (battle_world[i-1]>0){
            var tem1, tem2, tem3, tem4, tem5, tem6, tem7;
            tem1=battle[i-1];
            tem2=battle_location[i-1];
            tem3=battle_world[i-1];
            tem4=battle_opponent[i-1];
            tem5=battle_object[i-1];
            tem6=battle_pobject[i-1];
            tem7=battle_special[i-1];
            
            battle[i-1]=battle[i];
            battle_location[i-1]=battle_location[i];
            battle_world[i-1]=battle_world[i];
            battle_opponent[i-1]=battle_opponent[i];
            // battle_object[i-1]=battle_object[i];
            battle_pobject[i-1]=battle_pobject[i];
            battle_special[i-1]=battle_special[i];
            
            battle[i]=tem1;
            battle_location[i]=tem2;
            battle_world[i]=tem3;
            battle_opponent[i]=tem4;
            battle_object[i]=tem5;
            battle_pobject[i]=tem6;
            battle_special[i]=tem7;
        }
    }
}



// Probably want something right here to organize the battle just in case
// Space battles first
// Ground battles after




collect_next_end_turn_fleet_battle();

instance_activate_object(obj_star);




if (battle[1]=0) or (current_battle>battles){//                         This is temporary for the sake of testing
    if (battle[1]=0){
        obj_controller.x=first_x;
        obj_controller.y=first_y;
    }
    alarm[1]=1;
}

/* */
/*  */
});
