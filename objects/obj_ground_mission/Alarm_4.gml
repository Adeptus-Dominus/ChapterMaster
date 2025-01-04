
scr_return_ship(loc,self,num);

var man_size,ship_id,comp,planet,i;
i=0;ship_id=0;man_size=0;comp=0;planet=0;
ship_id = get_valid_player_ship("", loc);
planet=instance_nearest(x,y,obj_star);
var last_artifact = scr_add_artifact("random","random",4,loc,ship_id+500);

var i=0;





var mission,mission_roll;
mission="bad";mission_roll=floor(random(100))+1;
if (scr_has_adv("Ambushers")) then mission_roll-=15;
if (mission_roll<=60) then mission="good";// 135
if (planet.p_type[num]="Dead") then mission="good";
// mission="bad";

var pop;
pop=instance_create(0,0,obj_popup);
pop.image="artifact_recovered";
pop.title="Artifact Recovered!";

if (mission="good"){
    pop.text="Your marines quickly converge upon the Artifact and remove it, before local forces have any idea of what is happening.##";
    pop.text+="It has been stowed away upon "+string(loc)+".  It appears to be a "+string(obj_ini.artifact[last_artifact])+" but should be brought home and identified posthaste.";
    scr_event_log("","Artifact has been forcibly recovered.");
    
    if (planet.p_type[num]!="Dead"){
        if (planet.p_owner[num]=2) then obj_controller.disposition[2]-=1;
        if (planet.p_owner[num]=3) then obj_controller.disposition[3]-=10;// max(obj_controller.disposition/4,10)
        if (planet.p_owner[num]=4) then obj_controller.disposition[4]-=max(obj_controller.disposition[4]/4,10);
        if (planet.p_owner[num]=5) then obj_controller.disposition[5]-=3;
        if (planet.p_owner[num]=8) then obj_controller.disposition[8]-=3;
    }
}
if (mission="bad"){
    pop.text="Your marines converge upon the Artifact; resistance is light and easily dealt with.  After a brief firefight the Artifact is retrieved.##";
    pop.text+=$"It has been stowed away upon {loc}.  It appears to be a "+string(obj_ini.artifact[last_artifact])+" but should be brought home and identified posthaste.";
    scr_event_log("red","Artifact forcibly recovered.  Collateral damage is caused.");
    
    if (planet.p_owner[num]=2) then obj_controller.disposition[2]-=2;
    if (planet.p_owner[num]=3) then obj_controller.disposition[3]-=max(obj_controller.disposition[3]/3,20);
    if (planet.p_owner[num]=4) then obj_controller.disposition[4]-=max(obj_controller.disposition[4]/3,20);
    if (planet.p_owner[num]=5) then obj_controller.disposition[5]-=max(obj_controller.disposition[3]/4,15);
    if (planet.p_owner[num]=6) then obj_controller.disposition[6]-=15;
    if (planet.p_owner[num]=8) then obj_controller.disposition[8]-=8;
    
    if (planet.p_owner[num]>=3) and (planet.p_owner[num]<=6){
        obj_controller.audiences+=1;
        obj_controller.audien[obj_controller.audiences]=planet.p_owner[num];
        obj_controller.audien_topic[obj_controller.audiences]="artifact_angry";
    }
}


if (scr_has_adv("Tech-Scavengers")){
    var ex1,ex1_num,ex2,ex2_num,ex3,ex3_num;
    ex1="";ex1_num=0;ex2="";ex2_num=0;ex3="";ex3_num=0;
    
    var stah=instance_nearest(x,y,obj_star);

    if (stah.p_first[num]=2){
        ex1="Meltagun";ex1_num=choose(2,3,4);
        ex2="Flamer";
        ex2_num=choose(2,3,4);
        ex3=choose("Power Fist","Chainsword","Bolt Pistol");
        ex3_num=choose(2,3,4,5);
    }
    if (stah.p_first[num]=3){
        ex1="Plasma Pistol";
        ex1_num=choose(1,2);
        ex2="Power Armour";
        ex2_num=choose(2,3,4);
        ex3=choose("Servo-arm","Bionics");
        ex3_num=choose(2,3,4);
    }
    if (stah.p_first[num]=5){
        ex1="Flamer";
        ex1_num=choose(3,4,5,6);
        ex2="Heavy Flamer";
        ex2_num=choose(1,2,3);
        ex3=choose("Chainsword","Bolt Pistol");
        ex3_num=choose(2,3,4,5);
    }
    
    if (ex1!=""){
        pop.text+="##While they're at it your Battle Brothers also find ";
        if (ex1_num>0) then pop.text+=string(ex1_num)+" "+string(ex1);
        if (ex2_num>0) then pop.text+=", "+string(ex2_num)+" "+string(ex2);
        if (ex3_num>0) then pop.text+=", and "+string(ex3_num)+" "+string(ex3);
        pop.text+=".";
        scr_add_item(ex1,ex1_num);
        scr_add_item(ex2,ex2_num);
        scr_add_item(ex3,ex3_num);
    }
}


with(obj_star_select){instance_destroy();}
with(obj_fleet_select){instance_destroy();}
delete_features(planet.p_feature[num], P_features.Artifact);


corrupt_artifact_collectors(last_artifact);

obj_controller.trading_artifact=0;
var h;h=0;repeat(4){h+=1;obj_controller.diplo_option[h]="";obj_controller.diplo_goto[h]="";}
obj_controller.menu=0;
instance_destroy();

