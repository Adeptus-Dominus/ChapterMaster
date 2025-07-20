/// @function reset_popup_options()
/// @description Resets all popup option variables to empty strings
function reset_popup_options(){
	with (obj_popup){
		option1="";
		option2="";
		option3="";
		option4="";
	}
}

function calculate_equipment_needs(){
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
        req_armour=STR_ANY_POWER_ARMOUR;
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
            if (is_struct(unit_armour)) {
                if (req_armour == STR_ANY_POWER_ARMOUR) {
                    if (array_contains(LIST_BASIC_POWER_ARMOUR, unit_armour.name)) {
                        have_armour_num += 1;
                    }
                }
                if (req_armour == STR_ANY_TERMINATOR_ARMOUR) {
                    if (array_contains(LIST_TERMINATOR_ARMOUR, unit_armour.name)) {
                        have_armour_num += 1;
                    }
                }
            }
            
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
    if (req_armour==STR_ANY_POWER_ARMOUR){
        var _armour_list = LIST_BASIC_POWER_ARMOUR;
        for (i=0;i<array_length(_armour_list);i++){
            have_armour_num+=scr_item_count(_armour_list[i]);
        }
    }else if (req_armour=STR_ANY_TERMINATOR_ARMOUR){
        var _armour_list = LIST_TERMINATOR_ARMOUR;
        for (i=0;i<array_length(_armour_list);i++){
            have_armour_num+=scr_item_count(_armour_list[i]);
        }
    }else if (req_armour="Dreadnought"){
        have_armour_num+=scr_item_count("Dreadnought")
    } else {
        have_armour_num+=scr_item_count(req_armour);
    }

    if (req_wep1!="Heavy Ranged"){
    	have_wep1_num+=scr_item_count(string(req_wep1));
    }
    if (req_wep2!="Heavy Ranged"){
    	have_wep2_num+=scr_item_count(string(req_wep2));
    }
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
    return floor(all_good);

}