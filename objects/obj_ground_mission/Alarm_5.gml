
var comp,plan,i;i=0;comp=0;plan=0;
plan=instance_nearest(x,y,obj_star);

var mission,mission_roll;
mission="bad";mission_roll=floor(random(100))+1;
if (scr_has_adv("Ambushers")) then mission_roll-=15;
if (plan.p_owner[num]=3) then mission_roll+=20;
if (mission_roll<=60) then mission="good";// 135
if (plan.p_type[num]="Dead") then mission="good";
// mission="bad";

var pop;
pop=instance_create(0,0,obj_popup);
pop.image="artifact_recovered";
pop.title="STC Recovered!";

if (plan.p_first[num]!=3) or (plan.p_type[num]!="Forge"){
    pop.text="Your forces descend beneath the surface of the planet, delving deep into an ancient tomb.  Automated defenses and locks are breached.##";
    pop.text+="The STC Fragment has been safely stowed away, and is ready to be decrypted or gifted at your convenience.";
    scr_return_ship(loc,self,num);
}



if (mission="good") and (plan.p_first[num]=3) and (plan.p_type[num]="Forge"){
    pop.text="Your forces descend into the vaults of the Mechanicus Forge, bypassing sentries, automated defenses, and blast doors on the way.##";
    pop.text+="The STC Fragment has been safely recovered and stowed away.  It is ready to be decrypted or gifted at your convenience.";
    
    /*if (plan.p_type[num]!="Dead"){
        if (plan.p_owner[num]=2) then obj_controller.disposition[2]-=1;
        if (plan.p_owner[num]=3) then obj_controller.disposition[3]-=10;// max(obj_controller.disposition/4,10)
        if (plan.p_owner[num]=4) then obj_controller.disposition[4]-=max(obj_controller.disposition[4]/4,10);
        if (plan.p_owner[num]=5) then obj_controller.disposition[5]-=3;
        if (plan.p_owner[num]=8) then obj_controller.disposition[8]-=3;
    }*/
    scr_return_ship(loc,self,num);
}
if (mission="bad") and (plan.p_first[num]=3) and (plan.p_type[num]="Forge"){
    /*pop.text="Your marines converge upon the STC Fragment; resistance is light and easily dealt with.  After a brief firefight it is retrieved.##";
    pop.text+="The fragment been safely stowed away, and is ready to be decrypted or gifted at your convenience.";

    */
    
    pop.image="thallax";
    pop.text="Your forces descend into the vaults of the Mechanicus Forge.  Sentries, automated defenses, and blast doors stand in their way.##";
    pop.text+="Half-way through the mission a small army of Praetorian Servitors and Skitarii bear down upon your men.  The Mechanicus guards seem to be upset.";
    
    /*if (plan.p_owner[num]=2) then obj_controller.disposition[2]-=2;*/
    if (plan.p_owner[num]=3){obj_controller.disposition[3]-=40;}
    /*if (plan.p_owner[num]=4) then obj_controller.disposition[4]-=max(obj_controller.disposition[4]/3,20);
    if (plan.p_owner[num]=5) then obj_controller.disposition[5]-=max(obj_controller.disposition[3]/4,15);
    if (plan.p_owner[num]=6) then obj_controller.disposition[6]-=15;
    if (plan.p_owner[num]=8) then obj_controller.disposition[8]-=8;*/
    
    if (plan.p_owner[num]>3) and (plan.p_owner[num]<=6){obj_controller.audiences+=1;obj_controller.audien[obj_controller.audiences]=plan.p_owner[num];obj_controller.audien_topic[obj_controller.audiences]="artifact_angry";}
    if (plan.p_owner[num]=3) and (obj_controller.faction_status[eFACTION.Mechanicus]!="War"){obj_controller.audiences+=1;obj_controller.audien[obj_controller.audiences]=plan.p_owner[num];obj_controller.audien_topic[obj_controller.audiences]="declare_war";}
    
    // Start battle
    pop.battle_special=3.1;
    obj_controller.trading_artifact=0;
    var h;h=0;repeat(4){h+=1;obj_controller.diplo_option[h]="";obj_controller.diplo_goto[h]="";}
    obj_controller.menu=0;
    
    pop.loc=plan.name;
    pop.planet=num;
    
    exit;
}


if (scr_has_adv("Tech-Scavengers")){
    var ex1,ex1_num,ex2,ex2_num,ex3,ex3_num;
    ex1="";ex1_num=0;ex2="";ex2_num=0;ex3="";ex3_num=0;
    
    var stah;stah=instance_nearest(x,y,obj_star);

    if (stah.p_first[num]=2){
        ex1="Meltagun";ex1_num=choose(2,3,4);ex2="Flamer";ex2_num=choose(2,3,4);
        ex3=choose("Power Fist","Chainsword","Bolt Pistol");ex3_num=choose(2,3,4,5);
    }
    if (stah.p_first[num]=3){
        ex1="Plasma Pistol";ex1_num=choose(1,2);ex2="Power Armour";ex2_num=choose(2,3,4);
        ex3=choose("Servo-arm","Bionics");ex3_num=choose(2,3,4);
    }
    if (stah.p_first[num]=5){
        ex1="Flamer";ex1_num=choose(3,4,5,6);ex2="Heavy Flamer";ex2_num=choose(1,2,3);
        ex3=choose("Chainsword","Bolt Pistol");ex3_num=choose(2,3,4,5);
    }
    
    if (ex1!=""){
        pop.text+="##While they're at it your Battle Brothers also find ";
        if (ex1_num>0) then pop.text+=string(ex1_num)+" "+string(ex1);
        if (ex2_num>0) then pop.text+=", "+string(ex2_num)+" "+string(ex2);
        if (ex3_num>0) then pop.text+=", and "+string(ex3_num)+" "+string(ex3);
        pop.text+=".";
        scr_add_item(ex1,ex1_num);scr_add_item(ex2,ex2_num);scr_add_item(ex3,ex3_num);
    }
}


with(obj_star_select){instance_destroy();}
with(obj_fleet_select){instance_destroy();}
 delete_features(plan.p_feature[num], P_features.STC_Fragment);

scr_add_stc_fragment();// STC here


obj_controller.trading_artifact=0;obj_controller.diplo_option1="";
obj_controller.diplo_option2="";obj_controller.diplo_option3="";
obj_controller.menu=0;
instance_destroy();

/* */
/*  */
