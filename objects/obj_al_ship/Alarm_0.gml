// Sets up the ships for each race
assign_ship_stats();

// ** Imperial Navy **
// TODO hold all these variables in a dictionary/ Constructor


if (class=="Sword Class Frigate"){
    sprite_index=spr_ship_sword;
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
    add_weapon_to_ship("Weapons Battery", {weapon_range:300});
}
// ** Eldar **
if (class=="Void Stalker"){
    sprite_index=spr_ship_void;
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

    add_weapon_to_ship("Weapons Battery");
    add_weapon_to_ship("Eldar Launch Bay");
    add_weapon_to_ship("Pulsar Lances");
}else 
if (class=="Shadow Class"){
    sprite_index=spr_ship_shadow;
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
    add_weapon_to_ship("Torpedoes");
    add_weapon_to_ship("Light Weapons Battery", {range : 450});
}else 
if (class=="Hellebore"){
    sprite_index=spr_ship_hellebore;
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

    add_weapon_to_ship("Light Weapons Battery", {range : 450, cooldown :20, facing : "front"});

    add_weapon_to_ship("Light Weapons Battery", {range : 450});
    add_weapon_to_ship("Eldar Launch Bay", {ammo : 1});
}else 
if (class=="Aconite"){
    sprite_index=spr_ship_aconite;
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
    add_weapon_to_ship("Light Weapons Battery", {range : 450});
}
// ** Orkz **
if (class=="Dethdeala"){
    sprite_index=spr_ship_deth;
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

    add_weapon_to_ship("Gunz Battery", {facing:"left"});
    add_weapon_to_ship("Gunz Battery", {facing:"right"});
    add_weapon_to_ship("Bombardment Cannon");
    add_weapon_to_ship("Heavy Gunz");
    add_weapon_to_ship("Fighta Bommerz"); 
}else 
if (class=="Gorbag's Revenge"){
    sprite_index=spr_ship_gorbag;
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
    add_weapon_to_ship("Gunz Battery");
    add_weapon_to_ship("Torpedoes", {dam:12, range:300, cooldown:120});
    
    add_weapon_to_ship("Fighta Bommerz": {ammo : 3});
    add_weapon_to_ship("Fighta Bommerz": {ammo : 3});
}else 
if (class=="Kroolboy") or (class=="Slamblasta"){
    ship_size=3;
    sprite_index=spr_ship_krool;
    if (class=="Kroolboy") then sprite_index=spr_ship_krool;
    if (class=="Slamblasta") then sprite_index=spr_ship_slam;
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
}else 
if (class=="Battlekroozer"){
    sprite_index=spr_ship_kroozer;
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
}else 
if (class=="Ravager"){
    sprite_index=spr_ship_ravager;
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
// ** Tau **
if (class=="Custodian"){
    sprite_index=spr_ship_custodian;
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
}else 
if (class=="Protector"){
    sprite_index=spr_ship_protector;
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
    weapon_dam[4]=0;weapon_range[4]=9999;
    weapon_cooldown[4]=90;
    weapon_ammo[4]=2;
}else 
if (class=="Emissary"){
    sprite_index=spr_ship_emissary;
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
}else 
if (class=="Warden"){
    sprite_index=spr_ship_warden;
    ship_size=1;
    name="";hp=100;
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
}else 
if (class=="Castellan"){
    sprite_index=spr_ship_castellan;
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
// ** Chaos **
if (class=="Desecrator"){
    sprite_index=spr_ship_dese;
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
}else 
if (class=="Avenger"){
    sprite_index=spr_ship_veng;
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
    add_weapon_to_ship("Lance Battery", {facing : "left"});
    add_weapon_to_ship("Lance Battery", {facing : "right"});
}else 
if (class=="Carnage") or (class="Daemon"){
    sprite_index=spr_ship_carnage;
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

    add_weapon_to_ship("Lance Battery");
    add_weapon_to_ship("Light Weapons Battery", {dam : 12,facing : "left", cooldown : 45}});
    add_weapon_to_ship("Light Weapons Battery", {dam : 12,facing : "right", cooldown : 45});
    if (class=="Daemon"){
        sprite_index=spr_ship_daemon;
        image_alpha=0.5;
    }
}else 
if (class=="Iconoclast"){
    sprite_index=spr_ship_icono;
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
    add_weapon_to_ship("Light Weapons Battery");
}
// Tyranids
if (class=="Leviathan"){
    sprite_index=spr_ship_leviathan;
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
    add_weapon_to_ship("Feeder Tendrils" : {dam : 12, range :160});
    add_weapon_to_ship("Bio-Plasma Discharge" : {
        dam : 10, 
        range : 260,
        cooldown : 10,
        facing : "most",
    });

    add_weapon_to_ship("Pyro-Acid Battery" : {
        dam : 18, 
        range : 500,
        cooldown : 40,
        facing : "front",
    });

    add_weapon_to_ship("Launch Glands");

}else 
if (class=="Razorfiend"){
    sprite_index=spr_ship_razorfiend;
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

    add_weapon_to_ship("Pyro-Acid Battery" , {dam : 12, facing : "front"});
    add_weapon_to_ship("Feeder Tendrils");
    add_weapon_to_ship("Massive Claws");

}else 
if (class=="Stalker"){
    sprite_index=spr_ship_stalker;
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
    add_weapon_to_ship("Pyro-acid Battery", {cooldown : 60});
    add_weapon_to_ship("Feeder Tendrils", {cooldown : 20});
    add_weapon_to_ship("Bio-Plasma Discharge");

}else 
if (class=="Prowler"){
    sprite_index=spr_ship_prowler;
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
    add_weapon_to_ship("Pyro-acid Battery");
    add_weapon_to_ship("Feeder Tendrils");
}

if (owner == eFACTION.Tyranids){
    for(var i=1; i<=2; i++){
        if (obj_fleet.en_mutation[i]=="Spore Clouds") then shields=shields+100;
        if (obj_fleet.en_mutation[i]=="Health"){
            hp=floor(hp*1.1);
            maxhp=hp;
        }
        if (obj_fleet.en_mutation[i]=="Armour") then armour_front+=1;
        if (obj_fleet.en_mutation[i]=="Speed") then speed_bonus=speed_bonus*1.1;
        if (obj_fleet.en_mutation[i]=="Turn") then turn_bonus=1.2;
        if (obj_fleet.en_mutation[i]=="Turret") then turrets+=1;
    }
}

if (owner != eFACTION.Eldar){
    hp/=2;
    maxhp=hp;
    shields=shields/2;
    maxshields=shields;
}
// if (obj_fleet.enemy=2){hp=hp*0.75;maxhp=hp;shields=shields*0.75;maxshields=shields;}
// hp=1;shields=1;
// if (obj_fleet.enemy="orks") then name=global.name_generator.generate_ork_ship_name();
name="sdagdsagdasg";
// show_message(string(class));
