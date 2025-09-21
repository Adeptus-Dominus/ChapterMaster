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
reset_popup_options();
pathway="";
option1enter=false;
option2enter=false;
option3enter=false;
option4enter=false;
pop_data = {};
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
press=-1;
reset=0;
demand=0;

options = [];
add_option = function(option, if_empty = false){
    if (if_empty){
        if (array_length(options)){
            return;
        }
    }
    if (is_array(option)){
        for (var i=0;i<array_length(option);i++){
            add_option(option[i])
        }
    }
    else if (array_length(options)<10){
        array_push(options, option);
    }
}
entered_option = -1;

subtype = 0;

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
    {exp : 0},
//index 0 = draw x, 1 = draw y, 2 = exp requirement for company
    {exp :100},//1st company
    {exp :65},
    {exp :65},
    {exp :65},
    {exp :65},
    {exp :45},
    {exp :45},
    {exp :35},
    {exp :25},
    {exp :15},//10th company
]

for (var i=0;i<=10;i++){i+=1;role_name[i]="";role_exp[i]=0;}



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
        role_name[1]=obj_ini.role[100,17];
        role_exp[1]=125;
        spec=1;
        role_name[2]="Codiciery";role_exp[2]=80;
    } else if (unit_role == "Codiciery" && target_comp == 0){
        role_name[1]=obj_ini.role[100,17];
        role_exp[1]=125;
        spec=1;
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
                role_exp[i]=company_promote_data[target_comp].exp+10;
            }
            if (scr_role_count(obj_ini.role[100][7],"1")==0){ //company champ
                i+=1;
                role_name[i]=obj_ini.role[100][7];
                role_exp[i]=company_promote_data[target_comp].exp+10;//may as well have this liniked to weapon skill
            }
            i+=1;
            role_name[i]=obj_ini.role[100][6]; //dreadnought
            role_exp[i]=200;
        }
        
        if (obj_controller.command_set[2]==1){
            if (array_contains([2, 3, 4, 5, 6, 7], target_comp)){
                i+=1;
                role_name[i]=obj_ini.role[100][8]; //tacts
                role_exp[i]=company_promote_data[target_comp].exp;
                if (obj_controller.command_set[2]==0){
                    role_exp[i]=0;
                }
            }
            
            if (array_contains([2, 3, 4, 5, 8], target_comp)){
                i+=1;
                role_name[i]=obj_ini.role[100][10]; //assualts
                role_exp[i]=company_promote_data[target_comp].exp;
                if (obj_controller.command_set[2]==0){
                    role_exp[i]=0;
                }
            }
    
            if (array_contains([2, 3, 4, 5, 9], target_comp)){
                i+=1;
                role_name[i]=obj_ini.role[100][9]; //devs
                role_exp[i]=company_promote_data[target_comp].exp;
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
                role_exp[i]=company_promote_data[target_comp].exp;
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
