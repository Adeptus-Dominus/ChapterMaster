
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




if (battles>0) and (current_battle<=battles){
    var ii, xx, yy, good;
    ii=0;
    good=0;
    
    var battle_star = star_by_name(battle_location[current_battle]);
    
    if (battle_star!="none"){// trying to find the star
        obj_controller.x=battle_star.x;
        obj_controller.y=battle_star.y;
        show=current_battle;
        
        if (battle_world[current_battle]=-50){
            strin[1]=string(round(battle_pobject[current_battle].capital_number));
            strin[2]=string(round(battle_pobject[current_battle].frigate_number));
            strin[3]=string(round(battle_pobject[current_battle].escort_number));
            // pull health values here
            strin[4]=string(round(battle_pobject[current_battle].capital_health));
            strin[5]=string(round(battle_pobject[current_battle].frigate_health));
            strin[6]=string(round(battle_pobject[current_battle].escort_health));
            
            // pull enemy ships here
            
            var e=1;
            repeat(10){
                e+=1;
                if (e=11) then e=13;
                if (battle_star.present_fleet[e]>0){
                    obj_controller.temp[1070]=battle_star.id;
                    obj_controller.temp[1071]=e;
                    obj_controller.temp[1072]=0;
                    obj_controller.temp[1073]=0;
                    obj_controller.temp[1074]=0;
                    
                    with(obj_en_fleet){
                        if (orbiting=obj_controller.temp[1070]) and (owner=obj_controller.temp[1071]){
                            obj_controller.temp[1072]+=round(capital_number);
                            obj_controller.temp[1073]+=round(frigate_number);
                            obj_controller.temp[1074]+=round(escort_number);
                        }
                    }
                    
                    var l1,l2;l1=0;l2=0;
                    if (obj_controller.faction_status[e]!="War"){
                        repeat(10){l1+=1;if (allied_fleet[l1]=0) and (l2=0) then l2=l1;}
                        allied_fleet[l2]=e;
                        acap[l2]=obj_controller.temp[1072];
                        afri[l2]=obj_controller.temp[1073];
                        aesc[l2]=obj_controller.temp[1074];
                    }
                    if (obj_controller.faction_status[e]="War") or (e=9) or (e=13){
                        repeat(10){l1+=1;if (enemy_fleet[l1]=0) and (l2=0) then l2=l1;}
                        enemy_fleet[l2]=e;
                        ecap[l2]=obj_controller.temp[1072];
                        efri[l2]=obj_controller.temp[1073];
                        eesc[l2]=obj_controller.temp[1074];
                    }
                }
            }
            
        }
        
        if (battle_world[current_battle]>=1){
            scr_count_forces(string(battle_location[current_battle]),battle_world[current_battle],true);
            
            strin[1]=info_mahreens;
            strin[2]=info_vehicles;
            
            if (info_mahreens+info_vehicles=0){
                if (battles>current_battle) then alarm[4]=1;
                if (battles=current_battle) then alarm[1]=1;
            }
            
            strin[3]="";
            
            var tempy=0;
            tempy=battle_object[current_battle].p_owner[battle_world[current_battle]];
            
            if (tempy=1) or (tempy=2) or (tempy=3){
                var array_string = ["","Minimally","Lightly","Moderately","Highly","Extremely","Maximally"];
                var battle_fortification = battle_object[current_battle].p_fortified[battle_world[current_battle]];
                strin[3] = array_string[clamp(battle_fortification, 1, 6)];
            }
            
            tempy=0;
            if (battle_opponent[current_battle]=7) then tempy=battle_object[current_battle].p_orks[battle_world[current_battle]];
            if (battle_opponent[current_battle]=8) then tempy=battle_object[current_battle].p_tau[battle_world[current_battle]];
            if (battle_opponent[current_battle]=9) then tempy=battle_object[current_battle].p_tyranids[battle_world[current_battle]];
            if (battle_opponent[current_battle]=10) then tempy=battle_object[current_battle].p_traitors[battle_world[current_battle]];
            if (battle_opponent[current_battle]=13) then tempy=battle_object[current_battle].p_necrons[battle_world[current_battle]];
            
            if (tempy=1) then strin[4]="Minimal Forces";
            if (tempy=2) then strin[4]="Sparse Forces";
            if (tempy=3) then strin[4]="Moderate Forces";
            if (tempy=4) then strin[4]="Numerous Forces";
            if (tempy=5) then strin[4]="Very Numerous";
            if (tempy=6) then strin[4]="Overwhelming";
            
            // if (battle_opponent[current_battle]=2) then obj_controller.alarm[7]=1;
            obj_controller.cooldown=9999;
        }
        
        if (obj_controller.zoomed=1) then with(obj_controller){scr_zoom();}
    }
    instance_activate_object(obj_star);
    
}

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
