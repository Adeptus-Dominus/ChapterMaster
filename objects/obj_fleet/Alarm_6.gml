
/*
enemy[2]=6;enemy_status[2]=1;
en_capital[2]=2;en_frigate[2]=3;en_escort[2]=5;
en_capital_max[2]=2;en_frigate_max[2]=3;en_escort_max[2]=5;
en_ships_max[2]=10;

enemy[3]=2;enemy_status[3]=1;
en_capital[3]=1;en_frigate[3]=2;en_escort[3]=3;
en_capital_max[3]=1;en_frigate_max[3]=2;en_escort_max[3]=3;
en_ships_max[3]=6;
*/

var total_enemies, total_allies, t, tt, y1, y2, fug, spawner;
total_enemies=0;
total_allies=1;
spawner=0;
t=0;y1=0;y2=0;tt=0;fug=0;

repeat(6){t+=1;
    if (enemy[t]!=0){
        if (enemy_status[t]<0) then total_enemies+=1;
        if (enemy_status[t]>0) then total_allies+=1;
        
        // show_message("Computer "+string(t)+":"+string(enemy[t])+", status:"+string(enemy_status[t]));
    }
}



if (total_enemies>0){
    t=1;y2=room_height/total_enemies/2;tt=0;
    repeat(5){fug+=1;
        if (enemy_status[fug]<0){
            tt+=1;y1=(t*y2);
            
            spawner=instance_create(room_width+200,y1,obj_fleet_spawner);
            spawner.owner=enemy[fug];
            spawner.height=(y2);
            spawner.number=fug;
            
            t+=2;
        }
    }
}

if (total_allies>0){
    y1=0;fug=0;
    t=1;
    y2=room_height/total_allies/2;
    tt=0;
    repeat(5){
        fug+=1;
        if (enemy_status[fug]>0){
            tt+=1;
            y1=(t*y2);
            
            spawner=instance_create(200,y1,obj_fleet_spawner);
            
            if (fug=1) then spawner.owner  = eFACTION.Player;
            if (fug>1) then spawner.owner=enemy[fug];// Get the ENEMY after the actual enemies
            
            spawner.height=(y2);
            spawner.number=fug;
            
            t+=2;
        }
    }
}


// show_message("Total Enemies: "+string(total_enemies));
// show_message("Total Allies: "+string(total_allies));


// Buffs here
// if (ambushers=1) or (enemy=8) then 
attack_mode="offensive";
// if (enemy=9) then attack_mode="defensive";

if (ambushers=1) and (ambushers=999) then global_attack=global_attack*1.1;// Need to finish this
if (bolter_drilling=1) then global_bolter=global_bolter*1.1;
// if (enemy_eldar=1) and (enemy=6){global_attack=global_attack*1.1;global_defense=global_defense*1.1;}
// if (enemy_fallen=1) and (enemy=10){global_attack=global_attack*1.1;global_defense=global_defense*1.1;}
// if (enemy_orks=1) and (enemy=7){global_attack=global_attack*1.1;global_defense=global_defense*1.1;}
// if (enemy_tau=1) and (enemy=8){global_attack=global_attack*1.1;global_defense=global_defense*1.1;}
// if (enemy_tyranids=1) and (enemy=10){global_attack=global_attack*1.1;global_defense=global_defense*1.1;}
if (siege=1) and (siege=555) then global_attack=global_attack*1.2;// Need to finish this
if (slow=1){global_attack=global_attack*0.9;global_defense=global_defense*1.2;}
if (melee=1) then global_melee=global_melee*1.15;
// 
if (shitty_luck=1) then global_defense=global_defense*0.9;
// if (lyman=1) and (dropping=1) then ||| handle within each object
if (ossmodula=1){global_attack=global_attack*0.95;global_defense=global_defense*0.95;}
if (betchers=1) then global_melee=global_melee*0.95;
if (catalepsean=1){global_attack=global_attack*0.95;}
// if (occulobe=1){if (time=5) or (time=6) then global_attack=global_attack*0.7;global_defense=global_defense*0.9;}

// More prep for player

var i=0,k=0,onceh=0;

// instance_activate_object(obj_combat_info);

capital_max=capital;
frigate_max=frigate;
escort_max=escort;

obj_fleet_spawner.alarm[0]=1;


// alarm[1]=2;
/* */
/*  */
