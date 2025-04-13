// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function drop_down_sandwich(selection, draw_x, draw_y, options, open_marker,left_text,right_text){
	draw_text_transformed(draw_x, draw_y, left_text,1,1,0);
	draw_x += string_width(left_text)+5;
	var results = drop_down(selection, draw_x, draw_y-2, options,open_marker);
    draw_set_color(c_gray);
	draw_text_transformed(draw_x+9+ string_width(selection), draw_y, right_text,1,1,0);
    return results;
}

function set_up_armentarium(){
        static xx=__view_get( e__VW.XView, 0 );
        static yy=__view_get( e__VW.YView, 0 );    
        menu=14;
        onceh=1;
        cooldown=8000;
        click=1;
        temp[36]=scr_role_count(obj_ini.role[100][16],"");
        temp[37]=temp[36]+scr_role_count(string(obj_ini.role[100][16])+" Aspirant","");
        specialist_point_handler.calculate_research_points();
        in_forge=false
        forge_button = new ShutterButton();
        stc_flashes = new GlowDot();
        /*for (var i =0;i<3;i++){
            for (var f =0;f<7;f++){
                stc_flashes[i][f] = new GlowDot();
               // stc_flashes[i][f].flash_size
            }
        }*/
        speeding_bits = {
            "wargear":new SpeedingDot(0, 0,(210/6)*stc_wargear),
            "vehicles":new SpeedingDot(0, 0,(210/6)*stc_vehicles),
            "ships":new SpeedingDot(0, 0,(210/6)*stc_ships)
		}        
}

function same_locations(first_loc,second_loc){
    var same_loc = false;
    if (is_array(first_loc)&& is_array(second_loc)){
        if (first_loc[2] != "Warp" && first_loc[2] != "Lost"){
            if (first_loc[2] == second_loc[2]) then same_loc=true;
        } else {
            if (first_loc[1] == second_loc[1]) &&
                (first_loc[0] == second_loc[0]){
                    same_loc=true;
            }
        }
    }
    return same_loc;
}



function identify_stc(area){
    switch(area){
        case "wargear":
            stc_wargear++;
            if (stc_wargear==2) then stc_bonus[1]=choose(1,2,3,4,5);
            if (stc_wargear==4) then stc_bonus[2]=choose(1,2,3);
            stc_research.wargear=0;
            break;
        case "vehicles":
            stc_vehicles++;
            if (stc_vehicles==2) then stc_bonus[3]=choose(1,2,3,4,5);
            if (stc_vehicles==4) then stc_bonus[4]=choose(1,2,3);
            stc_research.vehicles=0;
            break;
         case "ships":
            stc_ships++;
            if (stc_ships==2) then stc_bonus[5]=choose(1,2,3,4,5);
            if (stc_ships==4) then stc_bonus[6]=choose(1,2,3);
            stc_research.ships=0;
            break;                      
    }
}
function scr_draw_armentarium(){
    var _recruit_pace = ARR_recruitment_pace;
    var _train_tiers  = ARR_techmarine_training_tiers;
    var xx = __view_get(e__VW.XView, 0) + 0;
	var yy = __view_get(e__VW.YView, 0) + 0;
	draw_sprite(spr_rock_bg, 0, xx, yy);

    draw_set_alpha(0.75);
    draw_set_color(0);
    draw_rectangle(xx + 326 + 16, yy + 66, xx + 887 + 16, yy + 818, 0);
    draw_set_alpha(1);
    draw_set_color(c_gray);
    draw_rectangle(xx + 326 + 16, yy + 66, xx + 887 + 16, yy + 818, 1);
    draw_line(xx + 326 + 16, yy + 426, xx + 887 + 16, yy + 426);
    
    if (menu_adept = 0) {
        // draw_sprite(spr_advisors,4,xx+16,yy+43);
        if(struct_exists(obj_ini.custom_advisors, "forge_master")){
            scr_image("advisor/splash", obj_ini.custom_advisors.forge_master, xx + 16, yy + 43, 310, 828);
        } else {
            scr_image("advisor/splash", 5, xx + 16, yy + 43, 310, 828);
        }
        draw_set_halign(fa_left);
        draw_set_color(c_gray);
        draw_set_font(fnt_40k_30b);
        var header =  in_forge ? "Forge" : "Armamentarium";
        draw_text_transformed(xx + 336 + 16, yy + 66, string_hash_to_newline(header), 1, 1, 0);
        if (!in_forge){
            draw_set_font(fnt_40k_30b);
            draw_text_transformed(xx + 336 + 16, yy + 100, string_hash_to_newline("Forge Master " + string(obj_ini.name[0, 1])), 0.6, 0.6, 0);
        }
    }
    if (menu_adept = 1) {
        // draw_sprite(spr_advisors,0,xx+16,yy+43);
        scr_image("advisor/splash", 1, xx + 16, yy + 43, 310, 828);
        draw_set_halign(fa_left);
        draw_set_color(c_gray);
        draw_set_font(fnt_40k_30b);
        draw_text_transformed(xx + 336 + 16, yy + 66, string_hash_to_newline("Armamentarium"), 1, 1, 0);
        draw_set_font(fnt_40k_30b);
        draw_text_transformed(xx + 336 + 16, yy + 100, string_hash_to_newline("Adept " + string(obj_controller.adept_name)), 0.6, 0.6, 0);
    }

    draw_set_font(fnt_40k_30b);
    draw_set_color(c_black);

    draw_set_alpha(0.2);
    if (mouse_y >= yy + 76) and(mouse_y < yy + 104) {
        if (mouse_x >= xx + 957) and(mouse_x < xx + 1062) then draw_rectangle(xx + 957, yy + 76, xx + 1062, yy + 104, 0);
        if (mouse_x >= xx + 1068) and(mouse_x < xx + 1136) then draw_rectangle(xx + 1068, yy + 76, xx + 1136, yy + 104, 0);
        if (mouse_x >= xx + 1167) and(mouse_x < xx + 1255) then draw_rectangle(xx + 1167, yy + 76, xx + 1255, yy + 104, 0);
        if (mouse_x >= xx + 1447) and(mouse_x < xx + 1545) then draw_rectangle(xx + 1487, yy + 76, xx + 1545, yy + 104, 0);
    }
    draw_set_alpha(1);
    draw_set_color(c_gray);


    if (!in_forge){
        draw_set_font(fnt_40k_14);
        draw_set_halign(fa_left);
        draw_text(xx + 384, yy + 468, string_hash_to_newline(string(stc_wargear_un + stc_vehicles_un + stc_ships_un) + " Unidentified Fragments"));

        draw_set_halign(fa_center);

        // Identify STC
        if (stc_wargear_un + stc_vehicles_un + stc_ships_un = 0) then draw_set_alpha(0.5);
        draw_set_color(c_gray);
        draw_rectangle(xx + 621, yy + 466, xx + 720, yy + 486, 0);
        draw_set_color(0);
        draw_text(xx + 670, yy + 467, string_hash_to_newline("Identify"));
        if (mouse_x > xx + 621) and(mouse_y > yy + 466) and(mouse_x < xx + 720) and(mouse_y < yy + 486) {
            draw_set_color(0);
            draw_set_alpha(0.2);
            draw_rectangle(xx + 621, yy + 466, xx + 720, yy + 486, 0);
            if (mouse_check_button_pressed(mb_left)){
                if (stc_wargear_un + stc_vehicles_un + stc_ships_un > 0){
                        
                    cooldown=8000;
                    audio_play_sound(snd_stc,-500,0)
                    audio_sound_gain(snd_stc,master_volume*effect_volume,0);


                    if (stc_wargear_un > 0 && 
                    stc_wargear < MAX_STC_PER_SUBCATEGORY) {
                            
                        stc_wargear_un--;
                       identify_stc("wargear");
                    }
                    else if (stc_vehicles_un > 0 && 
                    stc_vehicles < MAX_STC_PER_SUBCATEGORY) {
                            
                        stc_vehicles_un--;
                       identify_stc("vehicles");
                    }
                    else if(stc_ships_un > 0 && 
                    stc_ships < MAX_STC_PER_SUBCATEGORY) {
                        
                        stc_ships_un--;
                        identify_stc("ships");
                    }
                    
                    // Refresh the shop
                    instance_create(1000,1000,obj_shop);
                    set_up_armentarium();           
                } 
            }
        }
        draw_set_alpha(1);

        if (stc_wargear_un + stc_vehicles_un + stc_ships_un = 0) then draw_set_alpha(0.5);
        draw_set_color(c_gray);
        draw_rectangle(xx + 733, yy + 466, xx + 790, yy + 486, 0);
        draw_set_color(0);
        draw_text(xx + 761, yy + 467, string_hash_to_newline("Gift"));
        if (mouse_x > xx + 733) and(mouse_y > yy + 466) and(mouse_x < xx + 790) and(mouse_y < yy + 486) {
            draw_set_color(0);
            draw_set_alpha(0.2);
            draw_rectangle(xx + 733, yy + 466, xx + 790, yy + 486, 0);
            if (mouse_check_button_pressed(mb_left)){
                if (stc_wargear_un+stc_vehicles_un+stc_ships_un>0){
                    var chick=0;
                    if (known[eFACTION.Imperium]>1) and (faction_defeated[2]==0) then chick=1;
                    if (known[eFACTION.Mechanicus]>1) and (faction_defeated[3]==0) then chick=1;
                    if (known[eFACTION.Inquisition]>1) and (faction_defeated[4]==0) then chick=1;
                    if (known[eFACTION.Ecclesiarchy]>1) and (faction_defeated[5]==0) then chick=1;
                    if (known[eFACTION.Eldar]>1) and (faction_defeated[6]==0) then chick=1;
                    if (known[eFACTION.Tau]>1) and (faction_defeated[8]==0) then chick=1;
                    if (chick!=0){
                        var pop=instance_create(0,0,obj_popup);
                        pop.type=9.1;
                        cooldown=8000;
                    }
                }
            }
        }
        draw_set_alpha(1);

        draw_set_font(fnt_40k_12);
        draw_set_halign(fa_left);
        draw_set_color(c_gray);

        var max_techs;
        blurp = "";
        max_techs = round((disposition[3] / 2)) + 5;

        var yyy1, yyy;
        yyy1 = max_techs - temp[37];
        if (yyy1 < 0) then yyy1 = yyy1 * -1;
        yyy = (yyy1 * 2);
        if (disposition[3] mod 2 == 0) then yyy += 2;
        else {
            yyy += 1;
        }

        blurp = "Subject ID confirmed.  Rank Identified: Chapter Master.  Salutations Chapter Master.  We have assembled the following Data: ##" + string(obj_ini.role[100, 16]) + "s: " + string(temp[36]) + ".##Summation: ";
        if (obj_controller.faction_status[eFACTION.Mechanicus] != "War") {
            if (max_techs > temp[37]) then blurp += $"Our Mechanicus Requisitionary powers are sufficient to train {max_techs - temp[37]} additional {obj_ini.role[100][eROLE.Techmarine]}.";
            if (max_techs <= temp[37]) then blurp += $"We require {yyy} additional Mechanicus Disposition to train one additional {obj_ini.role[100][eROLE.Techmarine]}.";
        } else {
            blurp += $"Since we are at war with the Mechanicus we'll have to train our own {obj_ini.role[100][eROLE.Techmarine]}s."
        }
        blurp += "  The training of new " + string(obj_ini.role[100, 16]) + "s";

        if (menu_adept = 1) {
            blurp = "Your Chapter contains " + string(temp[36]) + " " + string(obj_ini.role[100, 16]) + ".##";
            blurp += "The training of a new " + string(obj_ini.role[100, 16]);
        }
        if (training_techmarine>=0){
            blurp += _recruit_pace[training_techmarine];
        }
        if (training_techmarine >0 && training_techmarine<=6) {
            eta = floor((359 - tech_points) / _train_tiers[training_techmarine])+ 1;
        }

        if (tech_aspirant > 0) and(training_techmarine > 0) and(menu_adept = 1) {
            if (eta = 1) then blurp += "  Your current " + string(obj_ini.role[100, 16]) + " Aspirant will finish training in " + string(eta) + " month.";
            if (eta != 1) then blurp += "  Your current " + string(obj_ini.role[100, 16]) + " Aspirant will finish training in " + string(eta) + " months.";
        }
        if (tech_aspirant > 0) and(training_techmarine > 0) and(menu_adept = 0) {
            if (eta = 1) then blurp += "  The current " + string(obj_ini.role[100, 16]) + " Aspirant will finish training in " + string(eta) + " month.";
            if (eta != 1) then blurp += "  The current " + string(obj_ini.role[100, 16]) + " Aspirant will finish training in " + string(eta) + " months.";
        }
        if (menu_adept = 0) then blurp += "##Data compilation complete.  We currently possess the technology to produce the following:";

        if (menu_adept = 1) {
            if (obj_controller.faction_status[eFACTION.Mechanicus] != "War") {
                if (max_techs > temp[37]) then blurp += $"Our Mechanicus Requisitionary powers are sufficient to train {max_techs - temp[37]} additional {obj_ini.role[100][eROLE.Techmarine]}.";
                if (max_techs <= temp[37]) then blurp += $"We require {yyy} additional Mechanicus Disposition to train one additional {obj_ini.role[100][eROLE.Techmarine]}.";
            } else {
                blurp += $"Since we are at war with the Mechanicus we'll have to train our own {obj_ini.role[100][eROLE.Techmarine]}s."
            }

            blurp += "##Data compilation complete.  You currently possess the technology to produce the following:";
        }

        draw_text_ext(xx + 336 + 16, yy + 130, string_hash_to_newline(string(blurp)), -1, 536);

		var y_offset = yy + 130 + string_height_ext(string_hash_to_newline(string(blurp)), -1, 536)+10;
        var research_area_limit;
        if (stc_research.research_focus=="vehicles"){
            research_area_limit = stc_vehicles;
        } else if (stc_research.research_focus=="wargear"){
            research_area_limit = stc_wargear;
        }else if (stc_research.research_focus=="ships"){
            research_area_limit = stc_ships;
        }
        var research_progress = ceil(((5000*(research_area_limit+1))-stc_research[$ stc_research.research_focus])/specialist_point_handler.research_points);
		static research_drop_down = false;
        var research_eta_message = $"Based on current progress it will be {research_progress} months until next significant research step is complete, Research is currently focussed on {stc_research.research_focus}";
        draw_text_ext(xx + 336 + 16, y_offset+25, string_hash_to_newline(research_eta_message), -1, 536);        



        var forge_buttons= [xx + 450 + 16, y_offset+40+string_height(research_eta_message), 0, 0]
        if (forge_button.draw_shutter(forge_buttons[0]+60, forge_buttons[1], "Enter Forge", 0.5)){
            in_forge=true;
        }
        draw_set_font(fnt_40k_30b);
        draw_set_halign(fa_center);
        draw_text_transformed(xx + 605, yy + 432, string_hash_to_newline("STC Fragments"), 0.75, 0.75, 0);
        draw_set_font(fnt_40k_12);
        draw_set_halign(fa_left);
        draw_set_color(c_gray);       
              
        var hi = 0;
        var f, y_loc;

        draw_set_color(c_gray);
        var _area_coords = {
            "wargear" : [xx+350, yy+535, xx+520, yy+800],
            "vehicles" : [xx+530, yy+535, xx+700, yy+800],
            "ships" : [xx+710, yy+535, xx+880, yy+800],
        }
        var _area_data = {
            "wargear" : stc_wargear,
            "vehicles" : stc_vehicles,
            "ships" : stc_ships,            
        }
        var _display_string = {
            "wargear" : "Wargear",
            "vehicles" : "Vehicles",
            "ships" : "Ships",            
        }
        var _wargear_one = ["Random","Enhanced Bolts","Enhanced Chain Weapons","Enhanced Flame Weapons","Enhanced Missiles","Enhanced Armour"];
        var _wargear_two = [ "Random","Enhanced Fist Weapons Bolts","Enhanced Plasma","Enhanced Armour"];
        var _vehicle_one = ["Random","Enhanced Hull","Enhanced Accuracy","New Weapons","Survivability","Enhanced Armour"];
        var _vehicle_two = ["Random","Enhanced Hull","Enhanced Armour","New Weapons"];
        var _ship_one = ["Random","Enhanced Hull","Enhanced Accuracy","Enhanced Turning","Enhanced Boarding","Enhanced Armour"];
        var _ship_two = ["Random","Enhanced Hull","Enhanced Armour","Enhanced Speed"]; 

        var _bonus_strings = {
            "wargear" : [
                "8% discount",
                _wargear_one[stc_bonus[1]],
                "16% discount",
                _wargear_two[stc_bonus[2]],
                "25% discount",
                "Can produce Terminator Armour and Dreadnoughts."
            ],
            "vehicles" : [
                "8% discount",
                _vehicle_one[stc_bonus[3]],
                "16% discount",
                _vehicle_two[stc_bonus[4]],
                "25% discount",
                "Can produce Land Speeders and Land Raiders."
            ],
            "ships" : [
                "8% discount",
                _ship_one[stc_bonus[5]],
                "16% discount",
                _ship_two[stc_bonus[6]],
                "25% discount",
                "Warp Speed is increased and ships self-repair."            
            ], 
        }   
        var _researches = ["vehicles","wargear", "ships"];
        for (var i=0;i<array_length(_researches);i++){
            draw_set_alpha(1);
            draw_set_color(c_gray);
            var _res = _researches[i];
            var _coords = _area_coords[$ _res];
            if (stc_research.research_focus == _res){
                draw_rectangle_array(_coords, false);
            } else {
                if (scr_hit(_coords)){
                    draw_set_alpha(1);
                    draw_set_color(c_white);
                    draw_rectangle_array(_area_coords[$ _res], false);
                    draw_set_color(c_gray);
                    tooltip_draw($"Click to change STC research to {_display_string[$_res]}");
                    if (scr_click_left()){
                        stc_research.research_focus = _res;
                    }
                }
            }
            draw_set_color(c_gray);
            draw_sprite_ext(spr_research_bar, 0, _coords[0]+9, _coords[1]+19, 1, 0.7, 0, c_white, 1)
            if (_area_data[$_res]>0){
                speeding_bits[$_res].draw(_coords[0], _coords[1]+20);
            }
            for (f =0;f<6;f++){
                if (f>=_area_data[$_res]){
                    draw_sprite_ext(spr_research_bar, 1, _coords[0]+9, _coords[1]+19+((210/6)*f), 1, 0.6, 0, c_white, 1)
                }
            }            
            if (stc_research.research_focus == _res){
                stc_flashes.draw(_coords[0]+9,_coords[1]+19+((210/6)*_area_data[$_res]));
            }
            draw_set_alpha(1);
            draw_set_color(c_gray);
            draw_set_font(fnt_40k_14);
            draw_text(_coords[0] + 36, _coords[1] - 18, _display_string[$_res]);
            var _bonus =  _bonus_strings[$_res];
            draw_set_font(fnt_40k_12);
            if (stc_research.research_focus == _res || scr_hit(_coords)){
                draw_set_color(c_black);
            }
            for (var s=0;s<array_length(_bonus);s++){
                draw_set_alpha(stc_wargear>s?1:0.5);
                draw_text_ext(_coords[0] + 22, yy + 549+(s*35), $"{s+1}) {_bonus[s]}", -1,140);
            }
        }

        draw_set_color(38144);           
       // draw_rectangle(xx + 711, yy + 539, xx + 728, yy + 539 + hi, 0);
        draw_set_alpha(1);
        draw_set_color(c_gray);
        //draw_rectangle(xx + 351, yy + 539, xx + 368, yy + 749, 1);
        //draw_rectangle(xx + 531, yy + 539, xx + 548, yy + 749, 1);
        //draw_rectangle(xx + 711, yy + 539, xx + 728, yy + 749, 1);

    }else {
        yy+=25;
        draw_set_halign(fa_left);
        draw_set_color(0);       
        //draw_rectangle(xx + 359, yy + 66, xx + 886, yy + 818, 0);

        if (point_and_click(draw_unit_buttons([xx + 359, yy + 77],"<-- Overview",[1,1],c_red))){
            in_forge=false;
        }        

        specialist_point_handler.draw_forge_queue(xx+ 359,yy + 107);

        
        // draw_set_color(c_red);
        //draw_line(xx + 326 + 16, yy + 426, xx + 887 + 16, yy + 426);         
        draw_set_color(#af5a00);
        draw_set_font(fnt_40k_14b)
        var forge_text = $"Forge point production per turn: {forge_points}#";
        // draw_sprite_ext(spr_forge_points_icon,0,xx+359+string_width(forge_text), yy+410,0.3,0.3,0,c_white,1);
        forge_text += $"Chapter total {obj_ini.role[100, 16]}s: {temp[36]}#";
        forge_text += $"Planetary Forges in operation: {obj_controller.player_forge_data.player_forges}#";
        forge_text += $"Master Craft Forge Chance: {master_craft_chance}%#    Assign techmarines to forges to increase Master Craft Chance";
        // forge_text += $"A total of {obj_ini.role[100, 16]}s assigned to Forges: {var}#";
        draw_text_ext(xx+359, yy+410, string_hash_to_newline(forge_text),-1,670);
    }
}
