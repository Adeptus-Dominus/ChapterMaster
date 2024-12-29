

cooldown[1]=0;

cooldown[2]=0;

cooldown[3]=0;

cooldown[4]=0;

cooldown[5]=0;



if (class="Apocalypse Class Battleship"){sprite_index=spr_ship_apoc;
    ship_size=3;

    name="";
    hp=1200;
    maxhp=1200;
    conditions="";
    shields=400;
    maxshields=400;
    leadership=90;
    
    armour_front=6;
    armour_other=5;
    weapons=4;
    turrets=4;
    capacity=150;
    carrying=0;
    
    weapon[1]="Lance Battery";
    weapon_facing[1]="left";
    weapon_dam[1]=14;
    weapon_range[1]=300;
    weapon_cooldown[1]=30;
    
    weapon[2]="Lance Battery";
    weapon_facing[2]="right";
    weapon_dam[2]=14;
    weapon_range[2]=300;
    weapon_cooldown[2]=30;
    
    weapon[3]="Nova Cannon";
    weapon_facing[3]="front";
    weapon_dam[3]=34;
    weapon_range[3]=1500;
    weapon_minrange[3]=300;
    weapon_cooldown[3]=120;
    
    weapon[4]="Weapons Battery";
    weapon_facing[4]="most";
    weapon_dam[4]=14;
    weapon_range[4]=600;
    weapon_cooldown[4]=20;
    
}

if (class="Nemesis Class Fleet Carrier"){sprite_index=spr_ship_nem;
    ship_size=3;

    name="";
    hp=1000;
    maxhp=1000;
    conditions="";
    shields=400;
    maxshields=400;
    leadership=85;
    
    armour_front=5;
    armour_other=5;
    weapons=3;
    turrets=5;
    capacity=100;
    carrying=24;
    
    weapon[1]="Interceptor Launch Bays";
    weapon_facing[1]="special";
    weapon_range[1]=9999;
    weapon_ammo[1]=6;
    weapon_cooldown[1]=120;
    
    weapon[2]="Interceptor Launch Bays";
    weapon_facing[2]="special";
    weapon_range[2]=9999;
    weapon_ammo[2]=6;
    weapon_cooldown[2]=120;
    cooldown[2]=30;
    
    weapon[3]="Lance Battery";
    weapon_facing[3]="front";
    weapon_dam[3]=14;
    weapon_range[3]=300;
    weapon_cooldown[3]=30;
    
}

if (class="Avenger Class Grand Cruiser"){sprite_index=spr_ship_aven;
    ship_size=2;

    name="";
    hp=1000;
    maxhp=1000;
    conditions="";
    shields=300;
    maxshields=300;
    leadership=85;
    
    armour_front=5;
    armour_other=5;
    weapons=2;
    turrets=3;
    capacity=50;
    carrying=0;
    
    weapon[1]="Lance Battery";
    weapon_facing[1]="most";
    weapon_dam[1]=14;
    weapon_range[1]=300;
    weapon_cooldown[1]=25;
    
    // weapon[1]="Lance Battery";
    weapon_facing[1]="left";
    weapon_dam[1]=14;
    weapon_range[1]=300;
    weapon_cooldown[1]=25;
    
    // weapon[2]="Lance Battery";
    weapon_facing[2]="right";
    weapon_dam[2]=14;
    weapon_range[2]=300;
    weapon_cooldown[2]=25;
    
}

if (class="Sword Class Frigate"){sprite_index=spr_ship_sword;
    ship_size=1;

    name="";
    hp=100;
    maxhp=100;
    conditions="";
    shields=100;
    maxshields=100;
    leadership=80;
    
    armour_front=5;
    armour_other=5;
    weapons=1;
    turrets=2;
    capacity=50;
    carrying=0;
    
    weapon[1]="Weapons Battery";
    weapon_facing[1]="most";
    weapon_dam[1]=8;
    weapon_range[1]=300;
    weapon_cooldown[1]=20;
    
}



// Eldar

if (class="Void Stalker"){sprite_index=spr_ship_void;
    ship_size=3;

    name="";
    hp=1000;
    maxhp=1000;
    conditions="";
    shields=300;
    maxshields=300;
    leadership=100;
    
    armour_front=5;
    armour_other=4;
    weapons=3;
    turrets=4;
    capacity=150;
    carrying=0;
    
    weapon[1]="Eldar Launch Bay";
    weapon_facing[1]="special";
    weapon_dam[1]=0;
    weapon_range[1]=9999;
    weapon_cooldown[1]=90;
    weapon_ammo[1]=4;
    
    weapon[2]="Weapons Battery";
    weapon_facing[2]="most";
    weapon_dam[2]=14;
    weapon_range[2]=600;
    weapon_cooldown[2]=30;
    
    weapon[3]="Pulsar Lances";
    weapon_facing[3]="most";
    weapon_dam[3]=10;
    weapon_range[3]=600;
    weapon_cooldown[3]=10;
    
    // weapon[4]="Torpedoes";
    weapon_facing[4]="front";
    weapon_dam[4]=12;
    weapon_range[4]=450;
    weapon_cooldown[4]=90;
    
}

if (class="Shadow Class"){sprite_index=spr_ship_shadow;
    ship_size=3;

    name="";
    hp=600;
    maxhp=600;
    conditions="";
    shields=200;
    maxshields=200;
    leadership=90;
    
    armour_front=5;
    armour_other=4;
    weapons=2;
    turrets=3;
    capacity=100;
    carrying=0;
    
    weapon[1]="Torpedoes";
    weapon_facing[1]="front";
    weapon_dam[1]=12;
    weapon_range[1]=450;
    weapon_cooldown[1]=90;
    
    weapon[2]="Weapons Battery";
    weapon_facing[2]="front";
    weapon_dam[2]=10;
    weapon_range[2]=450;
    weapon_cooldown[2]=30;
    
}

if (class="Hellebore"){sprite_index=spr_ship_hellebore;
    ship_size=1;

    name="";
    hp=200;
    maxhp=200;
    conditions="";
    shields=200;
    maxshields=200;
    leadership=90;
    
    armour_front=5;
    armour_other=4;
    weapons=3;
    turrets=2;
    capacity=50;
    carrying=0;
    
    weapon[1]="Pulsar Lances";
    weapon_facing[1]="front";
    weapon_dam[1]=10;
    weapon_range[1]=450;
    weapon_cooldown[1]=20;
    
    weapon[2]="Weapons Battery";
    weapon_facing[2]="front";
    weapon_dam[2]=8;
    weapon_range[2]=450;
    weapon_cooldown[2]=30;
    
    weapon[3]="Eldar Launch Bay";
    weapon_facing[3]="special";
    weapon_dam[3]=0;
    weapon_range[3]=9999;
    weapon_cooldown[3]=90;
    weapon_ammo[1]=1;
    
}

if (class="Aconite"){sprite_index=spr_ship_aconite;
    ship_size=1;

    name="";
    hp=200;
    maxhp=200;
    conditions="";
    shields=200;
    maxshields=200;
    leadership=90;
    
    armour_front=5;
    armour_other=4;
    weapons=3;
    turrets=2;
    capacity=50;
    carrying=0;
    
    weapon[1]="Weapons Battery";
    weapon_facing[1]="front";
    weapon_dam[1]=8;
    weapon_range[1]=450;
    weapon_cooldown[1]=30;
    
}




// Orks

if (class="Dethdeala"){sprite_index=spr_ship_deth;
    ship_size=3;

    name="";
    hp=1200;
    maxhp=1200;
    conditions="";
    shields=200;
    maxshields=200;
    leadership=100;
    
    armour_front=6;
    armour_other=5;
    weapons=5;
    turrets=3;
    capacity=250;
    carrying=0;
    
    weapon[1]="Gunz Battery";
    weapon_facing[1]="left";
    weapon_dam[1]=8;
    weapon_range[1]=300;
    weapon_cooldown[1]=30;
    
    weapon[2]="Gunz Battery";
    weapon_facing[2]="right";
    weapon_dam[2]=8;
    weapon_range[2]=300;
    weapon_cooldown[2]=30;
    
    weapon[3]="Bombardment Cannon";
    weapon_facing[3]="front";
    weapon_dam[3]=12;
    weapon_range[3]=450;
    weapon_cooldown[3]=120;
    
    weapon[4]="Heavy Gunz";
    weapon_facing[4]="most";
    weapon_dam[4]=12;
    weapon_range[4]=200;
    weapon_cooldown[4]=40;
    
    weapon[5]="Fighta Bommerz";
    weapon_facing[5]="special";
    weapon_dam[5]=0;
    weapon_range[5]=9999;
    weapon_cooldown[5]=90;
        
}

if (class="Gorbag's Revenge"){sprite_index=spr_ship_gorbag;
    ship_size=3;

    name="";
    hp=1200;
    maxhp=1200;
    conditions="";
    shields=200;
    maxshields=200;
    leadership=100;
    
    armour_front=6;
    armour_other=5;
    weapons=5;
    turrets=3;
    capacity=250;
    carrying=0;
    
    weapon[1]="Gunz Battery";
    weapon_facing[1]="front";
    weapon_dam[1]=8;
    weapon_range[1]=450;
    weapon_cooldown[1]=30;
    
    weapon[2]="Torpedoes";
    weapon_facing[2]="front";
    weapon_dam[2]=12;
    weapon_range[2]=300;
    weapon_cooldown[2]=120;
    
    weapon[3]="Heavy Gunz";
    weapon_facing[3]="most";
    weapon_dam[3]=12;
    weapon_range[3]=200;
    weapon_cooldown[3]=40;
    
    weapon[4]="Fighta Bommerz";
    weapon_facing[4]="special";
    weapon_dam[4]=0;
    weapon_ammo[4]=3;
    weapon_range[4]=9999;
    weapon_cooldown[4]=90;
    
    weapon[5]="Fighta Bommerz";
    weapon_facing[5]="special";
    weapon_dam[5]=0;
    weapon_ammo[5]=3;
    weapon_range[5]=9999;
    weapon_cooldown[5]=90;
    cooldown[5]=30;
    
}

if (class="Kroolboy") or (class="Slamblasta"){ship_size=3;
    sprite_index=spr_ship_krool;

    if (class="Kroolboy") then sprite_index=spr_ship_krool;
    
    if (class="Slamblasta") then sprite_index=spr_ship_slam;
    
    name="";
    hp=1200;
    maxhp=1200;
    conditions="";
    shields=200;
    maxshields=200;
    leadership=100;
    
    armour_front=6;
    armour_other=5;
    weapons=3;
    turrets=3;
    capacity=250;
    carrying=0;
    
    weapon[1]="Fighta Bommerz";
    weapon_facing[1]="special";
    weapon_dam[1]=0;
    weapon_ammo[1]=3;
    weapon_range[1]=9999;
    weapon_cooldown[1]=120;
    
    weapon[2]="Gunz Battery";
    weapon_facing[2]="most";
    weapon_dam[2]=8;
    weapon_range[2]=300;
    weapon_cooldown[2]=30;
    
    weapon[3]="Heavy Gunz";
    weapon_facing[3]="most";
    weapon_dam[3]=12;
    weapon_range[3]=200;
    weapon_cooldown[3]=40;
    
}

if (class="Battlekroozer"){sprite_index=spr_ship_kroozer;
    ship_size=3;

    name="";
    hp=1000;
    maxhp=1000;
    conditions="";
    shields=200;
    maxshields=200;
    leadership=100;
    
    armour_front=6;
    armour_other=5;
    weapons=5;
    turrets=3;
    capacity=250;
    carrying=0;
    
    weapon[1]="Gunz Battery";
    weapon_facing[1]="most";
    weapon_dam[1]=8;
    weapon_range[1]=450;
    weapon_cooldown[1]=30;
    
    weapon[2]="Heavy Gunz";
    weapon_facing[2]="left";
    weapon_dam[2]=12;
    weapon_range[2]=200;
    weapon_cooldown[2]=40;
    
    weapon[3]="Heavy Gunz";
    weapon_facing[3]="right";
    weapon_dam[3]=12;
    weapon_range[3]=200;
    weapon_cooldown[3]=40;
    
    weapon[4]="Fighta Bommerz";
    weapon_facing[4]="special";
    weapon_dam[4]=0;
    weapon_ammo[4]=3;
    weapon_range[4]=9999;
    weapon_cooldown[4]=90;
    
    weapon[5]="Fighta Bommerz";
    weapon_facing[5]="special";
    weapon_dam[5]=0;
    weapon_ammo[5]=3;
    weapon_range[5]=9999;
    weapon_cooldown[5]=90;
    cooldown[5]=30;
    
}

if (class="Ravager"){sprite_index=spr_ship_ravager;
    ship_size=1;

    name="";
    hp=100;
    maxhp=100;
    conditions="";
    shields=100;
    maxshields=100;
    leadership=80;
    
    armour_front=6;
    armour_other=4;
    weapons=2;
    turrets=2;
    capacity=50;
    carrying=0;
    
    weapon[1]="Gunz Battery";
    weapon_facing[1]="front";
    weapon_dam[1]=8;
    weapon_range[1]=300;
    weapon_cooldown[1]=30;
    
    weapon[2]="Torpedoes";
    weapon_facing[2]="front";
    weapon_dam[2]=12;
    weapon_range[2]=300;
    weapon_cooldown[2]=120;
    
}

// Tau

if (class="Custodian"){sprite_index=spr_ship_custodian;
    ship_size=3;

    name="";
    hp=1000;
    maxhp=1000;
    conditions="";
    shields=200;
    maxshields=200;
    leadership=100;
    
    armour_front=6;
    armour_other=5;
    weapons=4;
    turrets=5;
    capacity=1000;
    carrying=0;
    
    weapon[1]="Gravitic launcher";
    weapon_facing[1]="front";
    weapon_dam[1]=12;
    weapon_range[1]=400;
    weapon_minrange[1]=200;
    weapon_cooldown[1]=30;
    
    weapon[2]="Railgun Battery";
    weapon_facing[2]="most";
    weapon_dam[2]=12;
    weapon_range[2]=450;
    weapon_cooldown[2]=30;
    
    weapon[3]="Ion Cannons";
    weapon_facing[3]="most";
    weapon_dam[3]=8;
    weapon_range[3]=300;
    weapon_cooldown[3]=15;
    
    weapon[4]="Manta Launch Bay";
    weapon_facing[4]="special";
    weapon_dam[4]=0;
    weapon_range[4]=9999;
    weapon_cooldown[4]=90;
    weapon_ammo[4]=4;
    
}

if (class="Protector"){sprite_index=spr_ship_protector;
    ship_size=2;

    name="";
    hp=600;
    maxhp=600;
    conditions="";
    shields=200;
    maxshields=200;
    leadership=90;
    
    armour_front=6;
    armour_other=5;
    weapons=4;
    turrets=3;
    capacity=250;
    carrying=0;
    
    weapon[1]="Gravitic launcher";
    weapon_facing[1]="front";
    weapon_dam[1]=12;
    weapon_range[1]=400;
    weapon_minrange[1]=200;
    weapon_cooldown[1]=30;
    
    weapon[2]="Railgun Battery";
    weapon_facing[2]="most";
    weapon_dam[2]=10;
    weapon_range[2]=450;
    weapon_cooldown[2]=30;
    
    weapon[3]="Ion Cannons";
    weapon_facing[3]="most";
    weapon_dam[3]=8;
    weapon_range[3]=300;
    weapon_cooldown[3]=15;
    
    weapon[4]="Manta Launch Bay";
    weapon_facing[4]="special";
    weapon_dam[4]=0;
    weapon_range[4]=9999;
    weapon_cooldown[4]=90;
    weapon_ammo[4]=2;
    
}

if (class="Emissary"){sprite_index=spr_ship_emissary;
    ship_size=2;

    name="";
    hp=400;
    maxhp=400;
    conditions="";
    shields=100;
    maxshields=100;
    leadership=100;
    
    armour_front=6;
    armour_other=5;
    weapons=4;
    turrets=2;
    capacity=100;
    carrying=0;
    
    weapon[1]="Gravitic launcher";
    weapon_facing[1]="front";
    weapon_dam[1]=12;
    weapon_range[1]=400;
    weapon_minrange[1]=200;
    weapon_cooldown[1]=30;
    
    weapon[2]="Railgun Battery";
    weapon_facing[2]="most";
    weapon_dam[2]=10;
    weapon_range[2]=450;
    weapon_cooldown[2]=30;
    
    weapon[3]="Ion Cannons";
    weapon_facing[3]="most";
    weapon_dam[3]=8;
    weapon_range[3]=300;
    weapon_cooldown[3]=15;
    
    weapon[4]="Manta Launch Bay";
    weapon_facing[4]="special";
    weapon_dam[4]=0;
    weapon_range[4]=9999;
    weapon_cooldown[4]=90;
    weapon_ammo[4]=1;
    
}

if (class="Warden"){sprite_index=spr_ship_warden;
    ship_size=1;

    name="";
    hp=100;
    maxhp=100;
    conditions="";
    shields=100;
    maxshields=100;
    leadership=80;
    
    armour_front=5;
    armour_other=4;
    weapons=2;
    turrets=1;
    capacity=50;
    carrying=0;
    
    weapon[1]="Ion Cannon";
    weapon_facing[1]="most";
    weapon_dam[1]=8;
    weapon_range[1]=300;
    weapon_cooldown[1]=50;
    
    weapon[2]="Railgun Battery";
    weapon_facing[2]="front";
    weapon_dam[2]=10;
    weapon_range[2]=300;
    weapon_cooldown[2]=60;
    
}

if (class="Castellan"){sprite_index=spr_ship_castellan;
    ship_size=1;

    name="";
    hp=100;
    maxhp=100;
    conditions="";
    shields=100;
    maxshields=100;
    leadership=80;
    
    armour_front=5;
    armour_other=4;
    weapons=2;
    turrets=2;
    capacity=50;
    carrying=0;
    
    weapon[1]="Gravitic launcher";
    weapon_facing[1]="front";
    weapon_dam[1]=12;
    weapon_range[1]=400;
    weapon_minrange[1]=200;
    weapon_cooldown[1]=40;
    
    weapon[2]="Railgun Battery";
    weapon_facing[2]="front";
    weapon_dam[2]=10;
    weapon_range[2]=300;
    weapon_cooldown[2]=40;
    
}

// Chaos

if (class="Desecrator"){sprite_index=spr_ship_dese;
    ship_size=3;

    name="";
    hp=1200;
    maxhp=1200;
    conditions="";
    shields=400;
    maxshields=400;
    leadership=90;
    
    armour_front=7;
    armour_other=5;
    weapons=5;
    turrets=4;
    capacity=150;
    carrying=0;
    
    weapon[1]="Lance Battery";
    weapon_facing[1]="left";
    weapon_dam[1]=12;
    weapon_range[1]=300;
    weapon_cooldown[1]=30;
    
    weapon[2]="Lance Battery";
    weapon_facing[2]="right";
    weapon_dam[2]=12;
    weapon_range[2]=300;
    weapon_cooldown[2]=30;
    
    weapon[3]="Weapons Battery";
    weapon_facing[3]="front";
    weapon_dam[3]=18;
    weapon_range[3]=600;
    weapon_cooldown[3]=60;
    
    weapon[4]="Torpedoes";
    weapon_facing[4]="front";
    weapon_dam[4]=18;
    weapon_range[4]=450;
    weapon_cooldown[4]=120;
    
    weapon[5]="Fighta Bommerz";
    weapon_facing[5]="special";
    weapon_dam[5]=0;
    weapon_range[5]=9999;
    weapon_cooldown[5]=90;
        
}

if (class="Avenger"){sprite_index=spr_ship_veng;
    ship_size=2;

    name="";
    hp=1000;
    maxhp=1000;
    conditions="";
    shields=300;
    maxshields=300;
    leadership=85;
    
    armour_front=5;
    armour_other=5;
    weapons=2;
    turrets=3;
    capacity=50;
    carrying=0;
    
    weapon[1]="Lance Battery";
    weapon_facing[1]="left";
    weapon_dam[1]=12;
    weapon_range[1]=300;
    weapon_cooldown[1]=30;
    
    weapon[2]="Lance Battery";
    weapon_facing[2]="right";
    weapon_dam[2]=12;
    weapon_range[2]=300;
    weapon_cooldown[2]=30;
    
}

if (class="Carnage") or (class="Daemon"){sprite_index=spr_ship_carnage;
    ship_size=2;

    name="";
    hp=1000;
    maxhp=1000;
    conditions="";
    shields=300;
    maxshields=300;
    leadership=85;
    
    armour_front=5;
    armour_other=5;
    weapons=3;
    turrets=3;
    capacity=50;
    carrying=0;
    
    weapon[1]="Lance Battery";
    weapon_facing[1]="most";
    weapon_dam[1]=12;
    weapon_range[1]=450;
    weapon_cooldown[1]=30;
    
    weapon[2]="Weapons Battery";
    weapon_facing[2]="left";
    weapon_dam[2]=12;
    weapon_range[2]=300;
    weapon_cooldown[2]=45;
    
    weapon[3]="Weapons Battery";
    weapon_facing[3]="right";
    weapon_dam[3]=12;
    weapon_range[3]=300;
    weapon_cooldown[3]=45;
    
    if (class="Daemon"){sprite_index=spr_ship_daemon;
        image_alpha=0.1;
}
}

if (class="Iconoclast"){sprite_index=spr_ship_icono;
    ship_size=1;

    name="";
    hp=100;
    maxhp=100;
    conditions="";
    shields=100;
    maxshields=100;
    leadership=80;
    
    armour_front=7;
    armour_other=4;
    weapons=1;
    turrets=2;
    capacity=50;
    carrying=0;
    
    weapon[1]="Weapons Battery";
    weapon_facing[1]="most";
    weapon_dam[1]=8;
    weapon_range[1]=300;
    weapon_cooldown[1]=30;
    
}

// Tyranids

if (class="Leviathan"){sprite_index=spr_ship_leviathan;
    ship_size=3;

    name="";
    hp=1000;
    maxhp=1000;
    conditions="";
    shields=300;
    maxshields=300;
    leadership=100;
    
    armour_front=7;
    armour_other=5;
    weapons=5;
    turrets=3;
    capacity=0;
    carrying=0;
    
    weapon[1]="Feeder Tendrils";
    weapon_facing[1]="most";
    weapon_dam[1]=12;
    weapon_range[1]=160;
    weapon_cooldown[1]=30;
    
    weapon[2]="Bio-Plasma Discharge";
    weapon_facing[2]="most";
    weapon_dam[2]=10;
    weapon_range[2]=260;
    weapon_cooldown[2]=30;
    
    weapon[3]="Pyro-Acid Battery";
    weapon_facing[3]="front";
    weapon_dam[3]=18;
    weapon_range[3]=500;
    weapon_cooldown[3]=40;
    
    weapon[4]="Launch Glands";
    weapon_facing[4]="special";
    weapon_range[4]=9999;
    weapon_ammo[4]=6;
    weapon_cooldown[4]=120;
    
}

if (class="Razorfiend"){sprite_index=spr_ship_razorfiend;
    ship_size=2;

    name="";
    hp=600;
    maxhp=600;
    conditions="";
    shields=200;
    maxshields=200;
    leadership=100;
    
    armour_front=5;
    armour_other=4;
    weapons=3;
    turrets=2;
    capacity=0;
    carrying=0;
    
    weapon[1]="Pyro-Acid Battery";
    weapon_facing[1]="front";
    weapon_dam[1]=12;
    weapon_range[1]=300;
    weapon_cooldown[1]=30;
    
    weapon[2]="Feeder Tendrils";
    weapon_facing[2]="most";
    weapon_dam[2]=8;
    weapon_range[2]=100;
    weapon_cooldown[2]=30;
    
    weapon[3]="Massive Claws";
    weapon_facing[3]="most";
    weapon_dam[3]=20;
    weapon_range[3]=64;
    weapon_cooldown[3]=60;
    
}

if (class="Stalker"){sprite_index=spr_ship_stalker;
    ship_size=1;

    name="";
    hp=100;
    maxhp=100;
    conditions="";
    shields=100;
    maxshields=100;
    leadership=100;
    
    armour_front=5;
    armour_other=4;
    weapons=1;
    turrets=0;
    capacity=0;
    carrying=0;
    
    weapon[1]="Pyro-Acid Battery";
    weapon_facing[1]="front";
    weapon_dam[1]=8;
    weapon_range[1]=300;
    weapon_cooldown[1]=60;
    
    weapon[2]="Feeder Tendrils";
    weapon_facing[2]="most";
    weapon_dam[2]=8;
    weapon_range[2]=100;
    weapon_cooldown[2]=30;
    
    weapon[3]="Bio-Plasma Discharge";
    weapon_facing[3]="front";
    weapon_dam[3]=6;
    weapon_range[3]=200;
    weapon_cooldown[3]=60;
    
}

if (class="Prowler"){sprite_index=spr_ship_prowler;
    ship_size=1;

    name="";
    hp=100;
    maxhp=100;
    conditions="";
    shields=100;
    maxshields=100;
    leadership=100;
    
    armour_front=5;
    armour_other=4;
    weapons=1;
    turrets=0;
    capacity=0;
    carrying=0;
    
    weapon[1]="Pyro-acid Battery";
    weapon_facing[1]="most";
    weapon_dam[1]=8;
    weapon_range[1]=300;
    weapon_cooldown[1]=30;
    
    weapon[2]="Feeder Tendrils";
    weapon_facing[2]="most";
    weapon_dam[2]=8;
    weapon_range[2]=100;
    weapon_cooldown[1]=30;
    
}




if (owner = eFACTION.Tyranids){
    var i;
    i=0;
    
    repeat(2){
        i+=1;
        
        if (obj_fleet.en_mutation[i]="Spore Clouds") then shields=shields+100;
        
        if (obj_fleet.en_mutation[i]="Health"){hp=floor(hp*1.1);
            maxhp=hp;
    }
        if (obj_fleet.en_mutation[i]="Armour") then armour_front+=1;
        
        if (obj_fleet.en_mutation[i]="Speed") then speed_bonus=speed_bonus*1.1;
        
        if (obj_fleet.en_mutation[i]="Turn") then turn_bonus=1.2;
        
        if (obj_fleet.en_mutation[i]="Turret") then turrets+=1;
        
    }
}






// Necrons
if (class="Cairn Class"){sprite_index=spr_ship_cairn;
    ship_size=3;

    name="";
    hp=1100;
    maxhp=1100;
    conditions="";
    shields=550;
    maxshields=550;
    leadership=100;
    
    armour_front=5;
    armour_other=5;
    weapons=3;
    turrets=5;
    capacity=800;
    carrying=0;
    
    weapon[1]="Lightning Arc";
    weapon_facing[1]="most";
    weapon_dam[1]=0;
    weapon_range[1]=300;
    weapon_cooldown[1]=15;
    
    weapon[2]="Star Pulse Generator";
    weapon_facing[2]="front";
    weapon_dam[2]=0;
    weapon_range[2]=220;
    weapon_cooldown[2]=210;
    
    weapon[3]="Gauss Particle Whip";
    weapon_facing[3]="front";
    weapon_dam[3]=30;
    weapon_range[3]=450;
    weapon_cooldown[3]=90;
     
}

if (class="Reaper Class"){sprite_index=spr_ship_reaper;
    ship_size=3;

    name="";
    hp=900;
    maxhp=900;
    conditions="";
    shields=450;
    maxshields=450;
    leadership=100;
    
    armour_front=5;
    armour_other=5;
    weapons=3;
    turrets=4;
    capacity=500;
    carrying=0;
    
    weapon[1]="Lightning Arc";
    weapon_facing[1]="most";
    weapon_dam[1]=0;
    weapon_range[1]=300;
    weapon_cooldown[1]=15;
    
    weapon[2]="Star Pulse Generator";
    weapon_facing[2]="front";
    weapon_dam[2]=0;
    weapon_range[2]=220;
    weapon_cooldown[2]=210;
    
    weapon[3]="Gauss Particle Whip";
    weapon_facing[3]="front";
    weapon_dam[3]=30;
    weapon_range[3]=450;
    weapon_cooldown[3]=90;
     
}

if (class="Shroud Class"){ship_size=2;
    sprite_index=spr_ship_shroud;

    name="";
    hp=400;
    maxhp=400;
    conditions="";
    shields=200;
    maxshields=200;
    leadership=100;
    
    armour_front=5;
    armour_other=5;
    weapons=1;
    turrets=2;
    capacity=250;
    carrying=0;
    
    weapon[1]="Lightning Arc";
    weapon_facing[1]="most";
    weapon_dam[1]=0;
    weapon_range[1]=300;
    weapon_cooldown[1]=15;
    
}

if (class="Jackal Class"){ship_size=2;
    sprite_index=spr_ship_jackal;

    name="";
    hp=100;
    maxhp=100;
    conditions="";
    shields=100;
    maxshields=100;
    leadership=100;
    
    armour_front=4;
    armour_other=4;
    weapons=1;
    turrets=2;
    capacity=25;
    carrying=0;
    
    weapon[1]="Lightning Arc";
    weapon_facing[1]="most";
    weapon_dam[1]=0;
    weapon_range[1]=250;
    weapon_cooldown[1]=15;
    
}

if (class="Dirge Class"){ship_size=2;
    sprite_index=spr_ship_dirge;

    name="";
    hp=100;
    maxhp=100;
    conditions="";
    shields=100;
    maxshields=100;
    leadership=100;
    
    armour_front=4;
    armour_other=4;
    weapons=1;
    turrets=2;
    capacity=25;
    carrying=0;
    
    weapon[1]="Lightning Arc";
    weapon_facing[1]="most";
    weapon_dam[1]=0;
    weapon_range[1]=250;
    weapon_cooldown[1]=15;
    
}













if (owner != eFACTION.Eldar) and (owner != eFACTION.Necrons){
    hp=hp/2;
    maxhp=hp;
    shields=shields/2;
    maxshields=shields;
    
}

bridge=maxhp;

/* 
if (obj_fleet.enemy == 2) {
	hp = hp * 0.75;
	maxhp = hp;
	shields = shields * 0.75;
	maxshields = shields;
}
 */
// hp=1;
shields=1;



// if (obj_fleet.enemy="orks") then name=global.name_generator.generate_ork_ship_name();

name="sdagdsagdasg";



// show_message(string(class));


/* */
/*  */
