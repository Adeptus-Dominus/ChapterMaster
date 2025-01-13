set_zoom_to_default();
type=0;size=2;y_scale=1;
if (size=1) then sprite_index=spr_popup_small;
if (size=2) then sprite_index=spr_popup_medium;
if (size=3) then sprite_index=spr_popup_large;
image_wid=0;image_hei=0;image="";

master_crafted=0;hide=false;
if (instance_exists(obj_controller)){if (obj_controller.popup_master_crafted!=0) then master_crafted=obj_controller.popup_master_crafted;}
type=0;
size=2;
image="";
title="";
fancy_title=0;
text_center=0;
text="";
text2="";
option1="";
option2="";
option3="";
option4="";
pathway="";
option1enter=false;
option2enter=false;
option3enter=false;
option4enter=false;

amount=0;
save=0;
loc="";
planet=0;
estimate=0;
mission="";
old_tags="";
giveto=0;
inq_hide=0;
ma_co=0;
ma_id=0;
ma_name="";
manag=0;
fallen=0;
ship_lost=0;
battle_special=0;
owner=0;
tab=1;
woopwoopwoop=0;
press=0;
reset=0;
demand=0;

company=0;
target_comp=-1;
target_role=0;
unit_role="";
units=0;
min_exp=0;
cooldown=20;
all_good=0;
prev_selected = 0;

new_target=0;

if (instance_exists(obj_controller)){obj_controller.cooldown=8000;}
number=0;
company_promote_data = [
//index 0 = draw x, 1 = draw y, 2 = exp requirement for company
    [1030,230,100],//1st company
    [1140,230,65],
    [1250,230,65],
    [1360,230,65],
    [1470,230,65],
    [1030,250,45],
    [1140,250,45],
    [1250,250,35],
    [1360,250,25],
    [1470,250,15],//10th company
]

for (var i=0;i<=10;i++){i+=1;role_name[i]="";role_exp[i]=0;}

reset_options = function(){
     option1="";
    option2="";
    option3="";
    option4="";   
}

// TODO: connect this logic with the other_manage_data() to reduce verboseness;
get_unit_promotion_options = function(){
    var spec=0;
    for (var i=0;i<=11;i++){role_name[i]="";role_exp[i]=0;}  
    i=0;  
       // this area does the required exp for roles per company
    if (unit_role=obj_ini.role[100][16]){ //techmarine
        role_name[1]=obj_ini.role[100][16];
        role_exp[1]=5;
        spec=1;
    }else if (unit_role=obj_ini.role[100][15]){ //apothecary
        role_name[1]=obj_ini.role[100][15];
        role_exp[1]=5;
        spec=1;
    }else if (unit_role=obj_ini.role[100][6]){ //venerable dreadnought
        role_name[1]="Venerable "+string(obj_ini.role[100][6]);
        role_exp[1]=400;
        spec=0;
    } else if (unit_role=obj_ini.role[100][14] && global.chapter_name!="Space Wolves" && global.chapter_name!="Iron Hands"){ //chaplain
        role_name[1]=obj_ini.role[100][14];
        role_exp[1]=5;
        spec=1;
    } else  if (unit_role="Lexicanum"){
        role_name[1]=obj_ini.role[100,17];role_exp[1]=125;spec=1;
        role_name[2]="Codiciery";role_exp[2]=80;
    } else if (unit_role=="Codiciery") and (target_comp=0){
        role_name[1]=obj_ini.role[100,17];role_exp[1]=125;spec=1;
    } 
    if (target_comp>0 && target_comp<=10 && spec==0){
        if (units=1){
            if (scr_role_count(obj_ini.role[100][5],"1")==0){ //captain
                i+=1;
                role_name[i]=obj_ini.role[100][5];
                role_exp[i]=80;//all captains are equalish
            }
            if (scr_role_count(obj_ini.role[100][11],"1")==0){ //company ancient
                i+=1;
                role_name[i]=obj_ini.role[100][11];
                role_exp[i]=company_promote_data[target_comp-1][2]+10;
            }
            if (scr_role_count(obj_ini.role[100][7],"1")==0){ //company champ
                i+=1;
                role_name[i]=obj_ini.role[100][7];
                role_exp[i]=company_promote_data[target_comp-1][2]+10;//may as well have this liniked to weapon skill
            }
            i+=1;
            role_name[i]=obj_ini.role[100][6]; //dreadnought
            role_exp[i]=200;
        }
        
        if (obj_controller.command_set[2]==1){
            if (array_contains([2, 3, 4, 5, 6, 7], target_comp)){
                i+=1;
                role_name[i]=obj_ini.role[100][8]; //tacts
                role_exp[i]=company_promote_data[target_comp-1][2];
                if (obj_controller.command_set[2]==0){
                    role_exp[i]=0;
                }
            }
            
            if (array_contains([2, 3, 4, 5, 8], target_comp)){
                i+=1;
                role_name[i]=obj_ini.role[100][10]; //assualts
                role_exp[i]=company_promote_data[target_comp-1][2];
                if (obj_controller.command_set[2]==0){
                    role_exp[i]=0;
                }
            }
    
            if (array_contains([2, 3, 4, 5, 9], target_comp)){
                i+=1;
                role_name[i]=obj_ini.role[100][9]; //devs
                role_exp[i]=company_promote_data[target_comp-1][2];
                if (obj_controller.command_set[2]==0){
                    role_exp[i]=0;
                }
            }
    
            if (target_comp == 1){
                i+=1;
                role_name[i]=obj_ini.role[100][4]; //terminators
                role_exp[i]=100;
            }  
    
            if (target_comp == 10){
                i+=1;
                role_name[i]=obj_ini.role[100][12]; //scouts
                role_exp[i]=company_promote_data[target_comp-1][2];
                if (obj_controller.command_set[2]==0){
                    role_exp[i]=0;
                }
            }
    
            if (target_comp == 1){
                i+=1;
                role_name[i]=obj_ini.role[100][3]; //veterans
                role_exp[i]=100;
            }
        } else {
            i+=1;
            role_name[i]=obj_ini.role[100][8]; //tacts
            role_exp[i]=0;
        
            i+=1;
            role_name[i]=obj_ini.role[100][10]; //assualts
            role_exp[i]=0;

            i+=1;
            role_name[i]=obj_ini.role[100][9]; //devs
            role_exp[i]=0;

            i+=1;
            role_name[i]=obj_ini.role[100][4]; //terminators
            role_exp[i]=100;

            i+=1;
            role_name[i]=obj_ini.role[100][12]; //scouts
            role_exp[i]=0;

            i+=1;
            role_name[i]=obj_ini.role[100][3]; //veterans
            role_exp[i]=0;
        }
    
    }
    if ((target_comp==0 || target_comp>10)) and (spec==0){
        i+=1;
        role_name[i]=obj_ini.role[100][2];//honor guard
        role_exp[i]=140;
        if (obj_controller.command_set[2]==0) then role_exp[i]=0;
    }     
}

req_armour="";req_armour_num=0;have_armour_num=0;
req_gear="";req_gear_num=0;have_gear_num=0;
req_wep1="";req_wep1_num=0;have_wep1_num=0;
req_wep2="";req_wep2_num=0;have_wep2_num=0;
req_mobi="";req_mobi_num=0;have_mobi_num=0;

o_wep1="";o_wep2="";o_armour="";o_gear="";o_mobi="";
n_wep1="";n_wep2="";n_armour="";n_gear="";n_mobi="";
a_wep1="";a_wep2="";a_armour="";a_gear="";a_mobi="";
n_good1=1;n_good2=1;n_good3=1;n_good4=1;n_good5=1;
sel1=0;sel2=0;sel3=0;sel4=0;sel5=0;
vehicle_equipment=0;warning="";
item_name = [];

move_to_next_stage = function(){
    return (scr_hit(0,0, room_width, room_height) ||
        press_exclusive(vk_enter) ||
        press_exclusive(vk_space) ||
        press_exclusive(vk_enter));
}


calculate_equipment_needs =  function (){
     var i=0,rall="",all_good=0;

        req_armour="";
        req_armour_num=0;
        have_armour_num=0;
        req_gear="";
        req_gear_num=0;
        have_gear_num=0;
        req_mobi="";
        req_mobi_num=0;
        have_mobi_num=0;
        req_wep1="";
        req_wep1_num=0;
        have_wep1_num=0;
        req_wep2="";
        req_wep2_num=0;
        have_wep2_num=0;

        rall=role_name[target_role];

        /*if (rall=obj_ini.role[100][14]) and (global.chapter_name!="Space Wolves") and (global.chapter_name!="Iron Hands"){
            req_armour="";req_armour_num=0;req_wep1="";req_wep1_num=0;req_wep2="";req_wep2_num=0;req_mobi="";req_mobi_num=0;
        }*/
        if (rall="Codiciery"){
            req_armour="";req_armour_num=0;req_wep1="";req_wep1_num=0;req_wep2="";req_wep2_num=0;req_mobi="";req_mobi_num=0;req_gear=obj_ini.gear[100,17];req_gear_num=units;
        } else if (rall="Lexicanum"){
            req_armour="";
            req_armour_num=0;
            req_wep1="";
            req_wep1_num=0;
            req_wep2="";
            req_wep2_num=0;
            req_mobi="";
            req_mobi_num=0;
        } else if (rall=obj_ini.role[100][11]){
            req_armour="Power Armour";
            req_armour_num=units;
            req_wep2="Company Standard";
            req_wep2_num=units;
        } else {
            for (var i=2;i<20;i++){
                if (obj_ini.role[100][i]==rall){
                    req_armour=obj_ini.armour[100][i];
                    req_armour_num=units;req_wep1=obj_ini.wep1[100][i];
                    req_wep1_num=units;
                    req_wep2=obj_ini.wep2[100][i];
                    req_wep2_num=units;
                    req_mobi=obj_ini.mobi[100][i];
                    req_mobi_num=units;
                    req_gear=obj_ini.gear[100][i];
                    req_gear_num=units;
                    break;
                }
            }
        }

        if (rall=obj_ini.role[100][6]){req_armour="Dreadnought";req_armour_num=units;req_wep1=obj_ini.wep1[100,6];req_wep1_num=units;req_wep2=obj_ini.wep2[100,6];req_wep2_num=units;}
        if (rall=$"Venerable {obj_ini.role[100][6]}"){req_armour="";req_armour_num=0;req_wep1="";req_wep1_num=0;req_wep2="";req_wep2_num=0;}


        var unit_armour;
        var unit_wep_one;
        for (var i=0; i<array_length(obj_controller.display_unit);i++){

            unit_armour = gear_weapon_data("armour", obj_controller.ma_armour[i]);
            unit_wep_one = gear_weapon_data("weapon", obj_controller.ma_wep1[i]);
            if (obj_controller.man[i]!="") and (obj_controller.man_sel[i]) and (obj_controller.ma_promote[i]) and (obj_controller.ma_exp[i]>=min_exp){
                if (req_armour="Power Armour" && is_struct(unit_armour)){
                    if(unit_armour.has_tag("power_armour")) then have_armour_num+=1;
                }
                if (req_armour="Terminator Armour"){if (obj_controller.ma_armour[i]="Terminator Armour") or (obj_controller.ma_armour[i]="Tartaros") then have_armour_num+=1;}

                if (obj_controller.ma_wep1[i]=req_wep1) or (obj_controller.ma_wep2[i]=req_wep1) then have_wep1_num+=1;
                if (obj_controller.ma_wep2[i]=req_wep2) or (obj_controller.ma_wep1[i]=req_wep2) then have_wep2_num+=1;


                if (obj_controller.ma_gear[i]=req_gear) then have_gear_num+=1;
                if (obj_controller.ma_mobi[i]=req_mobi) then have_mobi_num+=1;

                if (req_wep1=="Heavy Ranged" && is_struct(unit_wep_one)){
                   if (unit_wep_one.has_tag("heavy_ranged")) then have_wep1_num+=1;
                }
            }

            // if (n_wep1=n_wep2) and ((o_wep1!=n_wep1) or (o_wep2!=n_wep2)){have_wep1_num-=1;have_wep2_num-=1;}

        }// End Repeat

        // This checks to see if there is any more in the armoury
        if (req_armour=="Power Armour"){
            var _power_armour = ARR_power_armour;
            for (i=0;i<array_length(_power_armour);i++){
                have_armour_num+=scr_item_count(_power_armour[i]);
            }
        }else if (req_armour="Terminator Armour"){
            have_armour_num+=scr_item_count("Terminator Armour");
            have_armour_num+=scr_item_count("Tartaros");
        }else if (req_armour="Dreadnought"){
            have_armour_num+=scr_item_count("Dreadnought")
        } else {
            have_armour_num+=scr_item_count(req_armour);
        }

        if (req_wep1!="Heavy Ranged") then have_wep1_num+=scr_item_count(string(req_wep1));
        if (req_wep2!="Heavy Ranged") then have_wep2_num+=scr_item_count(string(req_wep2));
        if (req_wep1="Heavy Ranged"){
            have_wep1_num+=scr_item_count("Lascannon");
            have_wep1_num+=scr_item_count("Heavy Bolter");
            have_wep1_num+=scr_item_count("Missile Launcher");
            have_wep1_num+=scr_item_count("Multi-Melta");
        }
        if (req_wep2="Heavy Ranged"){
            have_wep2_num+=scr_item_count("Heavy Bolter");
            have_wep2_num+=scr_item_count("Lascannon");
            have_wep2_num+=scr_item_count("Missile Launcher");
            have_wep1_num+=scr_item_count("Multi-Melta");
        }
        if (req_gear!="") then have_gear_num+=scr_item_count(string(req_gear));
        if (req_mobi!="") then have_mobi_num+=scr_item_count(string(req_mobi));

        if ((have_armour_num>=req_armour_num) or (req_armour="")) and ((have_wep1_num>=req_wep1_num) or (req_wep1="")) and ((have_wep2_num>=req_wep2_num) or (req_wep2="")) then all_good=0.4;
        if (req_gear="") or (req_gear_num<=have_gear_num) then all_good+=0.3;
        if (req_mobi="") or (req_mobi_num<=have_mobi_num) then all_good+=0.3;
}
