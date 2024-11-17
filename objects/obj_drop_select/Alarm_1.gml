

l_master=0;
l_honor=0;
l_capts=0;
l_mahreens=0;
l_veterans=0;
l_terminators=0;
l_dreads=0;
l_chaplains=0;
l_psykers=0;
l_apothecaries=0;
l_techmarines=0;
l_champions=0;
l_size=0;
// Attack
l_bikes=0;
l_rhinos=0;
l_whirls=0;
l_predators=0;
l_raiders=0;
l_speeders=0;

max_ships=0;


q=500;




// Formation check
var i,is,arright;i=0;formation_current=0;is=0;arright=false;
repeat(12){i+=1;formation_possible[i]=0;
    if (obj_controller.bat_formation[i]!="") and (attack=1) and (obj_controller.bat_formation_type[i]=1){
        is+=1;formation_possible[is]=i;
    }
    if (obj_controller.bat_formation[i]!="") and (attack=0) and (obj_controller.bat_formation_type[i]=2){
        is+=1;formation_possible[is]=i;// show_message("formation possible "+string(is)+" is set to "+string(i));
    }
}


if (attack=0){formation_current=obj_controller.last_raid_form;
    i=0;repeat(12){i+=1;if (formation_possible[i]=formation_current) and (arright=false){arright=true;formation_current=i;}}
}
if (attack=1){formation_current=obj_controller.last_attack_form;
    i=0;repeat(12){i+=1;if (formation_possible[i]=formation_current) and (arright=false){arright=true;formation_current=i;}}
}
if (arright=false) then formation_current=formation_possible[1];



// show_message("Star: "+string(p_target.name)+", Planet: "+string(planet_number));

var unit;
for (var co = 0; co <= 10; co++) {
    for (var i = 0; i <= 300; i++) {
        if (i <= 100) {
            if (obj_ini.veh_loc[co][i] = p_target.name) && (obj_ini.veh_wid[co][i] = planet_number) && (attack = 1) {
                if (obj_ini.veh_role[co][i] = "Land Speeder") then l_speeders += 1;
                if (obj_ini.veh_role[co][i] = "Rhino") then l_rhinos += 1;
                if (obj_ini.veh_role[co][i] = "Whirlwind") then l_whirls += 1;
                if (obj_ini.veh_role[co][i] = "Predator") then l_predators += 1;
                if (obj_ini.veh_role[co][i] = "Land Raider") then l_raiders += 1;
            }
        }
        unit = obj_ini.TTRPG[co][i];
        if (unit.name() == "") then
        continue;
        if (obj_ini.loc[co][i] = p_target.name) && (unit.planet_location == planet_number) {
            if ((attack = 0) && (string_count("Bike", obj_ini.role[co][i]) = 0)) || (attack = 1) {
                if (unit.role() = "Chapter Master") then l_master += 1;
                if (unit.role() = obj_ini.role[100][2]) then l_honor += 1;
                if (unit.role() = obj_ini.role[100][5]) then l_capts += 1;
                if (unit.role() = "Champion") then l_champions += 1;

                if (string_count("Bike", obj_ini.role[co][i]) = 0) || (attack = 0) {
                    if (obj_ini.role[co][i] = obj_ini.role[100][11]) then l_mahreens += 1;
                    if (unit.IsSpecialist("rank_and_file")) then l_mahreens++
                    if (obj_ini.role[co][i] = obj_ini.role[100][3]) then l_veterans += 1;
                }
                if (string_count("Bike", obj_ini.role[co][i]) > 0) && (attack = 1) {
                    if (obj_ini.role[co][i] = obj_ini.role[100][11]) then l_bikes += 1;
                    if (unit.IsSpecialist("rank_and_file")) then l_bikes++
                    if (obj_ini.role[co][i] = obj_ini.role[100][3]) then l_bikes += 1;
                }

                if (unit.role() = obj_ini.role[100][4]) then l_terminators += 1;
                if (unit.role() = obj_ini.role[100][6]) then l_dreads += 1;
                if (unit.IsSpecialist("chap", true)) then l_chaplains += 1;
                if (unit.IsSpecialist("libs", true)) then l_psykers += 1;
                if (unit.IsSpecialist("apoth", true)) then l_apothecaries += 1;
                if (unit.IsSpecialist("forge", true)) then l_techmarines += 1;
            }
        }
    }
}


l_size+=l_master;
l_size+=l_honor;
l_size+=l_capts;
l_size+=l_mahreens;
l_size+=l_veterans;
l_size+=l_terminators;
l_size+=l_dreads;
l_size+=l_chaplains;
l_size+=l_psykers;
l_size+=l_apothecaries;
l_size+=l_techmarines;
l_size+=l_champions;

l_size+=l_bikes;
l_size+=(rhinos+predators+whirls)*10;
l_size+=l_speeders*6;
l_size+=l_raiders*20;

ship_use[500]=0;
ship_max[500]=l_size;
purge_d=ship_max[500];



var __b__;
__b__ = action_if_variable(purge, 0, 0);
if __b__
{

if (sh_target!=-50){
    max_ships=sh_target.capital_number+sh_target.frigate_number+sh_target.escort_number;
    
    if (sh_target.acted>1) then instance_destroy();
    
    var tump;tump=0;
    
    var i, q, b;i=0;q=0;b=0;
    repeat(sh_target.capital_number){
        b+=1;
        if (sh_target.capital[b]!="") and (obj_ini.ship_carrying[sh_target.capital_num[b]]>0){
            i+=1;
            ship[i]=sh_target.capital[i];
            
            ship_use[i]=0;
            tump=sh_target.capital_num[i];
            ship_max[i]=obj_ini.ship_carrying[tump];
            ship_ide[i]=tump;
        }
    }
    q=0;
    repeat(sh_target.frigate_number){
        q+=1;
        if (sh_target.frigate[q]!="") and (obj_ini.ship_carrying[sh_target.frigate_num[q]]>0){
            i+=1;
            ship[i]=sh_target.frigate[q];
            
            ship_use[i]=0;
            tump=sh_target.frigate_num[q];
            ship_max[i]=obj_ini.ship_carrying[tump];
            ship_ide[i]=tump;
        }
    }
    q=0;
    repeat(sh_target.escort_number){
        q+=1;
        if (sh_target.escort[q]!="") and (obj_ini.ship_carrying[sh_target.escort_num[q]]>0){
            i+=1;
            ship[i]=sh_target.escort[q];
            
            ship_use[i]=0;
            tump=sh_target.escort_num[q];
            ship_max[i]=obj_ini.ship_carrying[tump];
            ship_ide[i]=tump;
        }
    }

}


sisters=p_target.p_sisters[planet_number];
eldar=p_target.p_eldar[planet_number];
ork=p_target.p_orks[planet_number];
tau=p_target.p_tau[planet_number];
tyranids=p_target.p_tyranids[planet_number];
csm=p_target.p_chaos[planet_number];
traitors=p_target.p_traitors[planet_number];
necrons=p_target.p_necrons[planet_number];
demons=p_target.p_demons[planet_number];

if (p_target.p_player[planet_number]>0) then max_ships+=1;

var bes,bes_score;bes=0;bes_score=0;
if (sisters>0) and (obj_controller.faction_status[eFACTION.Ecclesiarchy]="War"){bes=5;bes_score=sisters;}
if (eldar>bes_score){bes=6;bes_score=eldar;}
if (ork>bes_score){bes=7;bes_score=ork;}
if (tau>bes_score){bes=8;bes_score=tau;}
if (tyranids>bes_score){bes=9;bes_score=tyranids;}
if (traitors>bes_score){bes=10;bes_score=traitors;}
if (csm>bes_score){bes=11;bes_score=csm;}
if (necrons>bes_score){bes=13;bes_score=necrons;}
if (demons>0){bes=12;bes_score=demons;}
if (bes_score>0) then attacking=bes;

var spesh;spesh=false;
if (planet_feature_bool(p_target.p_feature[planet_number],P_features.Warlord10)==1) and (obj_controller.faction_defeated[10]=0) and (obj_controller.faction_gender[10]=1) and (obj_controller.known[eFACTION.Chaos]>0) and (obj_controller.turn>=obj_controller.chaos_turn) then spesh=true;
    

if (has_problem_planet(planet_number, "tyranid_org", p_target)){
    tyranids=2;
    attacking=9;
}

var forces,t_attack;forces=0;t_attack=0;
if (sisters>0){forces+=1;force_present[forces]=5;}
if (eldar>0){forces+=1;force_present[forces]=6;}
if (ork>0){forces+=1;force_present[forces]=7;}
if (tau>0){forces+=1;force_present[forces]=8;}
if (tyranids>0){forces+=1;force_present[forces]=9;}
if (traitors>0) or ((traitors=0) and (spesh=true)){forces+=1;force_present[forces]=10;}
if (csm>0){forces+=1;force_present[forces]=11;}
if (demons>0){forces+=1;force_present[forces]=12;}
if (necrons>0){forces+=1;force_present[forces]=13;}


}
__b__ = action_if_variable(purge, 1, 0);
if __b__
{




if (sh_target!=-50){
    
    max_ships=sh_target.capital_number+sh_target.frigate_number+sh_target.escort_number;
    
    
    if (sh_target.acted>=1) then instance_destroy();
    
    var tump;tump=0;
    
    var i, q, b;i=0;q=0;b=0;
    repeat(sh_target.capital_number){
        b+=1;
        if (sh_target.capital[b]!=""){
            i+=1;
            ship[i]=sh_target.capital[i];
            
            ship_use[i]=0;
            tump=sh_target.capital_num[i];
            ship_max[i]=obj_ini.ship_carrying[tump];
            ship_ide[i]=tump;
            
            ship_size[i]=3;
            
            purge_a+=3;
            purge_b+=ship_max[i];purge_c+=ship_max[i];purge_d+=ship_max[i];
        }
    }
    q=0;
    repeat(sh_target.frigate_number){
        q+=1;
        if (sh_target.frigate[q]!=""){
            i+=1;
            ship[i]=sh_target.frigate[q];
            
            ship_use[i]=0;
            tump=sh_target.frigate_num[q];
            ship_max[i]=obj_ini.ship_carrying[tump];
            ship_ide[i]=tump;
            
            ship_size[i]=2;
            
            purge_a+=1;
            purge_b+=ship_max[i];purge_c+=ship_max[i];purge_d+=ship_max[i];
        }
    }
    q=0;
    repeat(sh_target.escort_number){
        q+=1;
        if (sh_target.escort[q]!="") and (obj_ini.ship_carrying[sh_target.escort_num[q]]>0){
            i+=1;
            ship[i]=sh_target.escort[q];
            
            ship_use[i]=0;
            tump=sh_target.escort_num[q];
            ship_max[i]=obj_ini.ship_carrying[tump];
            ship_ide[i]=tump;
            
            ship_size[i]=1;
            
            purge_b+=ship_max[i];purge_c+=ship_max[i];purge_d+=ship_max[i];
        }
    }

}

if (p_target.p_player[planet_number]>0) then max_ships+=1;
var pp=planet_number;
purge_d = p_target.p_type[pp]!="Dead";

if (has_problem_planet(pp,"succession",p_target)) then purge_d=0

if (p_target.dispo[pp]<-2000) then purge_d=0;

if (planet_feature_bool(p_target.p_feature[pp],P_features.Monastery)==1) and (obj_controller.homeworld_rule!=1) then purge_d=0;

if (p_target.p_type[pp]="Dead") then purge_d=0;


}
