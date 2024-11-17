

// if (csm_exp!=0) then show_message(string(csm_exp));


if (control=1) then instance_activate_object(obj_cursor);


if (enemy=2){
    if (en_escort>0){en_column[4]="Sword Class Frigate";en_num[4]=en_escort;en_size[4]=1;}
    
    if (en_frigate>0){en_column[3]="Avenger Class Grand Cruiser";en_num[3]=en_frigate;en_size[3]=2;}
        
    var i;i=0;i=en_capital;
    if (i>0){
        en_column[2]="Apocalypse Class Battleship";en_num[2]=floor(random(i))+1;
        if (en_num[2]<(en_capital*0.6)) then en_num[2]=round(en_capital*0.6);
        i-=en_num[2];en_size[2]=3;
    }
    
    if (i>0){en_column[1]="Nemesis Class Fleet Carrier";en_num[1]=i;i-=en_num[1];en_size[1]=3;}
}



if (enemy=6){
    if (en_escort>0){en_column[4]="Aconite";en_num[4]=max(1,floor(en_escort/2));en_size[4]=1;}
    if (en_escort>1){en_column[3]="Hellebore";en_num[3]=max(1,floor(en_escort/2));en_size[3]=1;}
    if (en_frigate>0){en_column[2]="Shadow Class";en_num[2]=en_frigate;en_size[2]=2;}
    if (en_capital>0){en_column[1]="Void Stalker";en_num[1]=en_capital;en_size[1]=3;}
}




if (enemy=7){
    var i;i=0;i=en_capital;
    
    if (i>0){en_column[1]="Dethdeala";en_num[1]=floor(random(i))+1;i-=en_num[1];en_size[1]=3;}
    
    if (i>0){en_column[2]="Gorbag's Revenge";en_num[2]=floor(random(i))+1;i-=en_num[2];en_size[2]=3;}// en_num[2]+=en_num[1]+1;
    
    if (i>0){en_column[3]="Kroolboy";en_num[3]=i;i-=en_num[3];en_size[3]=3;}// en_num[3]+=en_num[2]+1;
    
    if (en_frigate>0){en_column[4]="Battlekroozer";en_num[4]=en_frigate;en_size[4]=2;}// en_num[4]+=en_num[3]+1;
    
    if (en_escort>0){en_column[5]="Ravager";en_num[5]=en_escort;en_size[5]=1;}// en_num[5]+=en_num[4]+1;
}

if (enemy=8){
    var i;i=0;i=en_frigate;
    
    if (en_capital>0){en_column[1]="Custodian";en_num[1]=en_capital;en_size[1]=3;}
    
    if (i>0){en_column[2]="Emissary";en_num[2]=1;i-=en_num[2];en_size[2]=2;}
    
    if (i>0){en_column[3]="Protector";en_num[3]=i;i-=en_num[3];en_size[3]=2;}// en_num[3]+=en_num[2]+1;
    
    if (en_escort>0){en_column[4]="Castellan";en_num[4]=round((en_escort/3)*2);en_size[4]=1;}
    
    if (en_escort>2){en_column[5]="Warden";en_num[5]=en_escort-en_num[5];en_size[5]=1;}
}

if (enemy=9){
    var i;i=0;i=en_escort;
    
    if (en_capital>0){en_column[1]="Leviathan";en_num[1]=en_capital;en_size[1]=3;}
    
    if (i>0){en_column[2]="Stalker";en_num[2]=floor(i/3)+1;i-=en_num[2];en_size[2]=1;}
    
    if (en_frigate>0){en_column[3]="Razorfiend";en_num[3]=en_frigate;en_size[3]=2;}// en_num[2]+=en_num[1]+1;
    
    if (i>0){en_column[4]="Prowler";en_num[4]=i;en_size[4]=1;}// en_num[5]+=en_num[4]+1;
}

if (enemy=10){
    var i;i=0;i=en_frigate;
    
    if (en_capital>0){en_column[1]="Desecrator";en_num[1]=en_capital;en_size[1]=3;}
    
    if (i>0){en_column[2]="Avenger";en_num[2]=floor(random(i))+1;i-=en_num[2];en_size[2]=2;}
    
    if (i>0){en_column[3]="Carnage";en_num[3]=floor(random(i))+1;i-=en_num[3];en_size[3]=2;}// en_num[2]+=en_num[1]+1;
    
    if (i>0){en_column[4]="Daemon";en_num[4]=i;i-=en_num[4];en_size[4]=2;}// en_num[3]+=en_num[2]+1;
    
    if (en_escort>0){en_column[5]="Iconoclast";en_num[5]=en_escort;en_size[5]=1;}// en_num[5]+=en_num[4]+1;
}


// show_message("Dethdeala "+string(en_num[1])+" | Gorbag "+string(en_num[2])+" | Kroolboy "+string(en_num[3])+" | Frigate "+string(en_num[4])+" | Escort "+string(en_num[5]));


en_capital=0;
en_frigate=0;
en_escort=0;
en_ships_max=0;



/*
if (enemy="orks"){
    if (threat=1){
        en_column[1]="Ravager";en_num[1]=floor(random_range(1,3));en_size[1]=1;
    }
    if (threat=2){
        en_column[1]=choose("Deathdeala","Gorbag's Revenge","Battlekroozer");en_num[1]=choose(0,1);en_size[1]=3;
        en_column[2]="Ravager";en_num[2]=floor(random_range(1,5));en_size[2]=1;
    }
    if (threat=3){
        en_column[1]="Dethdeala";en_num[1]=choose(1,1);en_size[1]=3;
        en_column[2]="Gorbag's Revenge";en_num[2]=choose(0,1);en_size[2]=3;
        en_column[3]="Battlekroozer";en_num[3]=floor(random_range(0,1));en_size[3]=3;
        en_column[4]="Ravager";en_num[4]=floor(random_range(3,8));en_size[4]=1;
    }
    if (threat=4){
        en_column[1]="Dethdeala";en_num[1]=choose(1,2);en_size[1]=3;
        en_column[2]="Gorbag's Revenge";en_num[2]=choose(0,1,1);en_size[2]=3;
        en_column[3]="Battlekroozer";en_num[3]=floor(random_range(1,1));en_size[3]=3;
        en_column[4]="Ravager";en_num[4]=floor(random_range(4,10));en_size[4]=1;
    }
    if (threat=5){
        en_column[1]="Dethdeala";en_num[1]=choose(1,2,3);en_size[1]=3;
        en_column[2]="Gorbag's Revenge";en_num[2]=choose(0,1,2);en_size[2]=3;
        en_column[3]="Kroolboy";en_num[3]=choose(0,1,2);en_size[3]=3;
        en_column[4]="Battlekroozer";en_num[4]=floor(random_range(0,5));en_size[4]=3;
        en_column[5]="Ravager";en_num[5]=floor(random_range(6,15));en_size[5]=1;
    }
}

*/


/*if (en_num[2]=0) then en_num[2]=en_num[1]+1;
if (en_num[3]=0) then en_num[3]=en_num[2]+1;
if (en_num[4]=0) then en_num[4]=en_num[3]+1;
if (en_num[5]=0) then en_num[5]=en_num[4]+1;

if (en_num[2]!=0) then en_num[2]+=en_num[1];
if (en_num[3]!=0) then en_num[3]+=en_num[3];
if (en_num[4]!=0) then en_num[4]+=en_num[4];
if (en_num[5]!=0) then en_num[5]+=en_num[5];*/


/*var i;i=0;
repeat(5){i+=1;
    if (en_column[4]="") and (en_column[5]!="") and (en_num[5]>0){en_column[4]=en_column[5];en_num[4]=en_num[5];en_column[5]="";en_num[5]=0;}
    if (en_column[3]="") and (en_column[4]!="") and (en_num[4]>0){en_column[3]=en_column[4];en_num[3]=en_num[4];en_column[4]="";en_num[4]=0;}
    if (en_column[2]="") and (en_column[3]!="") and (en_num[3]>0){en_column[2]=en_column[3];en_num[2]=en_num[3];en_column[3]="";en_num[3]=0;}
    if (en_column[1]="") and (en_column[2]!="") and (en_num[2]>0){en_column[1]=en_column[2];en_num[1]=en_num[2];en_column[2]="";en_num[2]=0;}
}*/




var i;i=0;
repeat(5){i+=1;
    if (en_column[i]="Avenger Class Grand Cruiser"){en_width[i]=196;en_height[i]=96;}
    if (en_column[i]="Apocalypse Class Battleship"){en_width[i]=272;en_height[i]=128;}
    if (en_column[i]="Nemesis Class Fleet Carrier"){en_width[i]=272;en_height[i]=128;}
    if (en_column[i]="Sword Class Frigate"){en_width[i]=96;en_height[i]=64;}

    if (en_column[i]="Void Stalker"){en_width[i]=260;en_height[i]=192;}
    if (en_column[i]="Shadow Class"){en_width[i]=212;en_height[i]=160;}
    if (en_column[i]="Hellebore"){en_width[i]=160;en_height[i]=64;}
    if (en_column[i]="Aconite"){en_width[i]=128;en_height[i]=64;}
    
    if (en_column[i]="Deathdeala"){en_width[i]=196;en_height[i]=128;}
    if (en_column[i]="Gorbag's Revenge"){en_width[i]=196;en_height[i]=128;}
    if (en_column[i]="Kroolboy"){en_width[i]=196;en_height[i]=128;}
    if (en_column[i]="Slamblasta"){en_width[i]=196;en_height[i]=128;}
    if (en_column[i]="Battlekroozer"){en_width[i]=160;en_height[i]=96;}
    if (en_column[i]="Ravager"){en_width[i]=128;en_height[i]=64;}
    
    if (en_column[i]="Desecrator"){en_width[i]=196;en_height[i]=128;}
    if (en_column[i]="Avenger"){en_width[i]=160;en_height[i]=96;}
    if (en_column[i]="Carnage"){en_width[i]=160;en_height[i]=96;}
    if (en_column[i]="Daemon"){en_width[i]=160;en_height[i]=96;}
    if (en_column[i]="Iconoclast"){en_width[i]=128;en_height[i]=64;}
    
    if (en_column[i]="Custodian"){en_width[i]=128;en_height[i]=256;}
    if (en_column[i]="Emissary"){en_width[i]=160;en_height[i]=96;}
    if (en_column[i]="Protector"){en_width[i]=64;en_height[i]=180;}
    if (en_column[i]="Castellan"){en_width[i]=48;en_height[i]=96;}
    if (en_column[i]="Warden"){en_width[i]=48;en_height[i]=80;}
    
    if (en_column[i]="Leviathan"){en_width[i]=200;en_height[i]=128;}
    if (en_column[i]="Razorfiend"){en_width[i]=160;en_height[i]=128;}
    if (en_column[i]="Stalker"){en_width[i]=96;en_height[i]=64;}
    if (en_column[i]="Prowler"){en_width[i]=80;en_height[i]=64;}
}

/* */

attack_mode="offensive";

// if (ambushers=1) or (enemy=8) then attack_mode="offensive";
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

/*if (global.chapter_name="Dark Angels") or (obj_ini.main_color="Dark Green") then color_index=0;
if (global.chapter_name="White Scars") or (obj_ini.main_color="White") then color_index=1;
if (global.chapter_name="Space Wolves") or (obj_ini.main_color="Light Blue") then color_index=2;
if (global.chapter_name="Imperial Fists") or (obj_ini.main_color="Yellow") then color_index=3;
if (global.chapter_name="Blood Angels") or (obj_ini.main_color="Red") or (obj_ini.main_color="Dark Red") then color_index=4;
if (global.chapter_name="Iron Hands") then color_index=5;
if (global.chapter_name="Ultramarines") or (obj_ini.main_color="Blue") then color_index=6;
if (global.chapter_name="Salamanders") or (obj_ini.main_color="Green") then color_index=7;
if (global.chapter_name="Iron Hands") then color_index=7;
if (global.chapter_name="Black Templars") or (obj_ini.main_color="Black") then color_index=8;
if (global.chapter_name="Minotaurs") or (obj_ini.main_color="Brown") then color_index=9;
if (global.chapter_name="Soul Drinkers") or (obj_ini.main_color="Purple") then color_index=10;
if (global.chapter_name="Lamenters") then color_index=11;
if (global.chapter_name="Emperor's Nightmares") then color_index=12;
if (global.chapter_name="Angry Marines") then color_index=13;
if (global.chapter_name="Star Krakens") then color_index=14;
if (obj_ini.main_color="Pink") then color_index=15;*/



/*
global.chapter_name=5;
obj_ini.main_color=obj_creation.main_color;
obj_ini.secondary_color=obj_creation.secondary_color;
obj_ini.lens_color=obj_creation.lens_color;
obj_ini.weapon_color=obj_creation.weapon_color;
*/



/* */
var i, k, onceh;i=0;k=0;onceh=0;

// instance_activate_object(obj_combat_info);

repeat(100){i+=1;
    if (fighting[i]=1) and (obj_ini.ship_class[i]!="") then ships_max+=1;
}




i=0;
repeat(100){i+=1;
    if (fighting[i]=1) and (obj_ini.ship[i]!="") and (obj_ini.ship_hp[i]>0){onceh=0;
        if (obj_ini.ship_size[i]=3) then capital+=1;
        if (obj_ini.ship_size[i]=2) then frigate+=1;
        if (obj_ini.ship_size[i]=1) then escort+=1;
        
        ship_class[i]=obj_ini.ship_class[i];
        ship[i]=obj_ini.ship[i];ship_id[i]=i;ship_size[i]=obj_ini.ship_size[i];
        ship_leadership[i]=100;ship_hp[i]=obj_ini.ship_hp[i];ship_maxhp[i]=obj_ini.ship_maxhp[i];
        ship_conditions[i]=obj_ini.ship_conditions[i];ship_speed[i]=obj_ini.ship_speed[i];ship_turning[i]=obj_ini.ship_turning[i];
        ship_front_armour[i]=obj_ini.ship_front_armour[i];ship_other_armour[i]=obj_ini.ship_other_armour[i];ship_weapons[i]=obj_ini.ship_weapons[i];
        
        var t;t=0;
        t+=1;ship_wep[i,t]=obj_ini.ship_wep[i,t];ship_wep_facing[i,t]=obj_ini.ship_wep_facing[i,t];ship_wep_condition[i,t]=obj_ini.ship_wep_condition[i,t];
        t+=1;ship_wep[i,t]=obj_ini.ship_wep[i,t];ship_wep_facing[i,t]=obj_ini.ship_wep_facing[i,t];ship_wep_condition[i,t]=obj_ini.ship_wep_condition[i,t];
        t+=1;ship_wep[i,t]=obj_ini.ship_wep[i,t];ship_wep_facing[i,t]=obj_ini.ship_wep_facing[i,t];ship_wep_condition[i,t]=obj_ini.ship_wep_condition[i,t];
        t+=1;ship_wep[i,t]=obj_ini.ship_wep[i,t];ship_wep_facing[i,t]=obj_ini.ship_wep_facing[i,t];ship_wep_condition[i,t]=obj_ini.ship_wep_condition[i,t];
        t+=1;ship_wep[i,t]=obj_ini.ship_wep[i,t];ship_wep_facing[i,t]=obj_ini.ship_wep_facing[i,t];ship_wep_condition[i,t]=obj_ini.ship_wep_condition[i,t];
        
        ship_capacity[i]=obj_ini.ship_capacity[i];ship_carrying[i]=obj_ini.ship_carrying[i];
        ship_contents[i]=obj_ini.ship_contents[i];ship_turrets[i]=obj_ini.ship_turrets[i];
    }
}


alarm[2]=1;


/* */
/*  */
