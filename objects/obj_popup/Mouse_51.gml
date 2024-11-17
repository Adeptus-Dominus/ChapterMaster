
if (hide=true) then exit;

if (battle_special>0){
    alarm[0]=1;cooldown=10;exit;
}

if (instance_exists(obj_controller)){
    if (obj_controller.force_scroll=1) and (type=99) and (instance_exists(obj_turn_end)){
    
        var p_strength,en_strength,ratio,diceh,mfleet,rdice;
        p_strength=0;en_strength=0;mfleet=obj_turn_end.battle_pobject[obj_turn_end.current_battle];
        p_strength+=mfleet.escort_number;
        p_strength+=mfleet.frigate_number*3;
        p_strength+=mfleet.capital_number*8;
        rdice=floor(random(100))+1;
        
        
        
        with(obj_temp3){instance_destroy();}
        obj_controller.temp[2000]=obj_turn_end.battle_location[obj_turn_end.current_battle];
        with(obj_star){if (name=obj_controller.temp[2000]) then instance_create(x,y,obj_temp3);}
        var that=instance_nearest(obj_temp3.x,obj_temp3.y,obj_star);

        obj_controller.temp[2001]=real(that.id);
        obj_controller.temp[2002]=real(obj_turn_end.battle_opponent[obj_turn_end.current_battle]);

        var cap_total=0,frig_total=0,escort_total=0;
        with(obj_en_fleet){
            if (orbiting=obj_controller.temp[2001]) and (owner=obj_controller.temp[2002]){
                cap_total += capital_number;
                frig_total += frigate_number;
                escort_total += escort_number;
            }
        }
        
        en_strength+=cap_total*4;
        en_strength+=frig_total*2;
        en_strength+=escort_total;

        
        ratio=9999;if (p_strength>0) and (en_strength>0){ratio=(en_strength/p_strength)*100;}
        
        var esc_lost,frig_lost,cap_lost,which,sayd;
        esc_lost=0;frig_lost=0;cap_lost=0;which=0;sayd=0;
        
        ship_lost=0;i=-1;// var ship_lost,i;
        repeat(50){i+=1;ship_lost[i]=0;}i=0;
        if (scr_has_adv("Kings of Space")) then rdice-=10;
        if (rdice<=80) and (p_strength<=2) then rdice=-5;
        
        if (rdice!=-5){
            repeat(50){
                diceh=floor(random(100))+1;
                if (diceh<=ratio){ratio-=100;
                    var onceh;onceh=0;
                    
                    if (mfleet.escort_number>0) and (onceh=0){
                        esc_lost+=1;
                        which=floor(random(mfleet.escort_number))+1;
                        sayd=mfleet.escort_num[which];
                        
                        obj_ini.ship_hp[sayd]=0;ship_lost[sayd]=1;
                        onceh=1;mfleet.escort_number-=1;
                    }
                    if (mfleet.frigate_number>0) and (onceh=0){
                        frig_lost+=1;
                        which=floor(random(mfleet.frigate_number))+1;
                        sayd=mfleet.frigate_num[which];
                        
                        obj_ini.ship_hp[sayd]=0;ship_lost[sayd]=1;
                        onceh=1;mfleet.frigate_number-=1;
                    }
                    if (mfleet.capital_number>0) and (onceh=0){
                        cap_lost+=1;
                        which=floor(random(mfleet.capital_number))+1;
                        sayd=mfleet.capital_num[which];
                        
                        obj_ini.ship_hp[sayd]=0;ship_lost[sayd]=1;
                        onceh=1;mfleet.capital_number-=1;
                    }
                    
                    // show_message("Ship lost");
                }
            
            }
            scr_dead_marines(1);
        }
        
        obj_p_fleet.selected=0;
        obj_p_fleet.alarm[6]=1;
        with(obj_fleet_select){instance_destroy();}
        obj_controller.popup=0;
        if (obj_controller.zoomed=1){with(obj_controller){scr_zoom();}}
        
        type=98;title="Fleet Retreating";
        cooldown=15;obj_controller.menu=0;
        
        // 139;
        with(obj_temp_inq){instance_destroy();}
        instance_create(obj_turn_end.battle_pobject[obj_turn_end.current_battle].x,obj_turn_end.battle_pobject[obj_turn_end.current_battle].y,obj_temp_inq);
        with(obj_en_fleet){
            if (navy=1) and (point_distance(x,y,obj_temp_inq.x,obj_temp_inq.y)<40) and (trade_goods="player_hold") then trade_goods="";
        }
        with(obj_temp_inq){instance_destroy();}
        
        if (esc_lost+frig_lost+cap_lost>0) and (mfleet.escort_number+mfleet.frigate_number+mfleet.capital_number>0){
            text="Your fleet is given the command to fall back.  The vesels turn and prepare to enter the Warp, constantly under a hail of enemy fire.  Some of your ships remain behind to draw off the attack and give the rest of your fleet a chance to escape.  ";
            
            if (cap_lost=1) then text+=string(cap_lost)+" Battle Barge is destroyed.  ";
            if (frig_lost=1) then text+=string(frig_lost)+" Strike Cruiser is destroyed.  ";
            if (esc_lost=1) then text+=string(esc_lost)+" Escort is destroyed.  ";
            
            if (cap_lost>1) then text+=string(cap_lost)+" Battle Barges were destroyed.  ";
            if (frig_lost>1) then text+=string(frig_lost)+" Strike Cruisers were destroyed.  ";
            if (esc_lost>1) then text+=string(esc_lost)+" Escorts were destroyed.  ";
        }
        
        if (esc_lost+frig_lost+cap_lost=0){
            text="Your fleet is given the command to fall back.  The vesels turn and prepare to enter the Warp, constantly under a hail of enemy fire.  The entire fleet manages to escape with minimal damage.";
        }
        
        if (mfleet.escort_number+mfleet.frigate_number+mfleet.capital_number=0){
            text="Your fleet is given the command to fall back.  The vessels turn and prepare to enter the Warp, constantly under a hail of enemy fire.  All of your ships are destroyed attempting to flee.";
        }
        with (mfleet){
            complex_route=[];
        }
        
        with(obj_fleet_select){instance_destroy();}
        if (mfleet.escort_number+mfleet.frigate_number+mfleet.capital_number=0) and (instance_exists(mfleet)){with(mfleet){instance_destroy();}}
        
        /*
        with(obj_ini){scr_dead_marines(1);}
        with(obj_ini){scr_ini_ship_cleanup();}
        */
    
    }
}

/* */
/*  */
