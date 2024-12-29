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
        speeding_bits = [
            new SpeedingDot(0, 0,(210/6)*stc_wargear),
            new SpeedingDot(0, 0,(210/6)*stc_vehicles),
            new SpeedingDot(0, 0,(210/6)*stc_ships)
        ]        
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
        scr_image("advisor", 4, xx + 16, yy + 43, 310, 828);
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
        scr_image("advisor", 0, xx + 16, yy + 43, 310, 828);
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
        if (max_techs > temp[37]) then blurp += "Our Mechanicus Requisitionary powers are sufficient to train " + string(max_techs - temp[37]) + " additional " + string(obj_ini.role[100, 16]) + ".";
        if (max_techs <= temp[37]) then blurp += "We require " + string(yyy) + " additional Mechanicus Disposition to train one additional " + string(obj_ini.role[100, 16]) + ".";
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
            if (max_techs > temp[37]) then blurp += "##Mechanicus Requisitionary powers are sufficient to train " + string(max_techs - temp[37]) + " additional " + string(obj_ini.role[100, 16]) + ".";
            if (max_techs <= temp[37]) then blurp += "You require " + string(yyy) + " additional Mechanicus Disposition to train one additional " + string(obj_ini.role[100, 16]) + ".";

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
        var research_eta_message = $"Based on current progress it will be {research_progress} months until next significant research step is complete";
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
        var drop_down_results = drop_down_sandwich(
            stc_research.research_focus,
            xx + 336 + 16,
            y_offset,
            ["vehicles","wargear", "ships"],
            research_drop_down,
            "Research is currently focussed on", 
            ".");
        research_drop_down = drop_down_results[1];
        stc_research.research_focus = drop_down_results[0]; 
              
        var hi;
        draw_set_color(38144);
        hi = 0;
        var f, y_loc;
        draw_sprite_ext(spr_research_bar, 0, xx+359, yy+554, 1, 0.7, 0, c_white, 1)
        draw_sprite_ext(spr_research_bar, 0, xx+539, yy+554, 1, 0.7, 0, c_white, 1)
       draw_sprite_ext(spr_research_bar, 0, xx+719, yy+554, 1, 0.7, 0, c_white, 1)

        if (stc_wargear > 0) then speeding_bits[0].draw(xx+359, yy+554);
        for (f =0;f<6;f++){
            if (f>=stc_wargear){
                draw_sprite_ext(spr_research_bar, 1, xx+359, yy+554+((210/6)*f), 1, 0.6, 0, c_white, 1)
            }            
               /* y_loc = yy+560+((210/6)*f);
                if ((speeding_bits[0].current_y()-y_loc)<5 && (speeding_bits[0].current_y()-y_loc)>-5){
                    stc_flashes[0][f].one_flash_finished=false;
                }
                stc_flashes[0][f].draw_one_flash(xx+359, y_loc);*/
        } 
        //draw_rectangle(xx + 351, yy + 539, xx + 368, yy + 539 + hi, 0);

        if (stc_vehicles > 0) then speeding_bits[1].draw(xx+539, yy+554);
          for (f =0;f<6;f++){
            if (f>=stc_vehicles){
                draw_sprite_ext(spr_research_bar, 1, xx+539, yy+554+((210/6)*f), 1, 0.6, 0, c_white, 1)
            }
            //stc_flashes[1][f].draw_one_flash(xx+539, yy+560+((210/6)*f));
        }     
        //draw_rectangle(xx + 531, yy + 539, xx + 548, yy + 539 + hi, 0);

        if (stc_ships > 0) then speeding_bits[2].draw(xx+719, yy+554);
       for (f =0;f<6;f++){
            if (f>=stc_ships){
                draw_sprite_ext(spr_research_bar, 1, xx+719, yy+554+((210/6)*f), 1, 0.6, 0, c_white, 1)
            }        
            //stc_flashes[2][f].draw_one_flash(xx+719,yy+ 560+((210/6)*f));
        }  
        switch(stc_research.research_focus){
            case "wargear":
                stc_flashes.draw(xx+359,yy+560+((210/6)*stc_wargear));
                break;
            case "vehicles":
                stc_flashes.draw(xx+539,yy+560+((210/6)*stc_vehicles));
                break;
            case "ships":
                stc_flashes.draw(xx+719,yy+560+((210/6)*stc_ships));
                break;

        }              
       // draw_rectangle(xx + 711, yy + 539, xx + 728, yy + 539 + hi, 0);
        draw_set_alpha(1);
        draw_set_color(c_gray);
        //draw_rectangle(xx + 351, yy + 539, xx + 368, yy + 749, 1);
        //draw_rectangle(xx + 531, yy + 539, xx + 548, yy + 749, 1);
        //draw_rectangle(xx + 711, yy + 539, xx + 728, yy + 749, 1);

        draw_set_font(fnt_40k_14);
        draw_text(xx + 386, yy + 517, string_hash_to_newline("Wargear"));
        draw_text(xx + 566, yy + 517, string_hash_to_newline("Vehicles"));
        draw_text(xx + 746, yy + 517, string_hash_to_newline("Ships"));

        draw_set_font(fnt_40k_12);
        draw_set_alpha(1);
        if (stc_wargear < 1) then draw_set_alpha(0.5);
        draw_text(xx + 372, yy + 549, string_hash_to_newline("1) 8% discount"));

        var stc_bonus_strings = ["Random","Enhanced Bolts","Enhanced Chain Weapons","Enhanced Flame Weapons","Enhanced Missiles","Enhanced Armour"];
        var bonus_string=stc_bonus_strings[stc_bonus[1]];
        draw_set_alpha(1);

        if (stc_wargear < 2) then draw_set_alpha(0.5);
        draw_text_ext(xx + 372, yy + 549 + 35, string_hash_to_newline("2) " + string(bonus_string)),-1,150);
        draw_set_alpha(1);

        if (stc_wargear < 3) then draw_set_alpha(0.5);
        draw_text(xx + 372, yy + 549 + 70, string_hash_to_newline("3) 16% discount"));

        stc_bonus_strings = [ "Random","Enhanced Fist Weapons Bolts","Enhanced Plasma","Enhanced Armour"]
        bonus_string=stc_bonus_strings[stc_bonus[2]];

        draw_set_alpha(1);

        if (stc_wargear < 4) then draw_set_alpha(0.5);
        draw_text_ext(xx + 372, yy + 549 + 105, string_hash_to_newline("4) " + string(bonus_string)), -1,150);
        draw_set_alpha(1);

        if (stc_wargear < 5) then draw_set_alpha(0.5);
        draw_text(xx + 372, yy + 549 + 140, string_hash_to_newline("5) 25% discount"));
        draw_set_alpha(1);

        if (stc_wargear < 6) then draw_set_alpha(0.5);
        draw_text_ext(xx + 372, yy + 549 + 175, string_hash_to_newline("6) Can produce Terminator Armour and Dreadnoughts."), -1, 140);
        draw_set_alpha(1);

        // 21 right of the gray bar
        draw_set_font(fnt_40k_12);
        draw_set_alpha(1);
        if (stc_vehicles < 1) then draw_set_alpha(0.5);
        draw_text(xx + 552, yy + 549, string_hash_to_newline("1) 8% discount"));

        bonus_string = "Random";
        if (stc_bonus[3] = 1) then bonus_string = "Enhanced Hull";
        if (stc_bonus[3] = 2) then bonus_string = "Enhanced Accuracy";
        if (stc_bonus[3] = 3) then bonus_string = "New Weapons";
        if (stc_bonus[3] = 4) then bonus_string = "Survivability";
        if (stc_bonus[3] = 5) then bonus_string = "Enhanced Armour";
        draw_set_alpha(1);

        if (stc_vehicles < 2) then draw_set_alpha(0.5);
        draw_text(xx + 552, yy + 549 + 35, string_hash_to_newline("2) " + string(bonus_string)));
        draw_set_alpha(1);

        if (stc_vehicles < 3) then draw_set_alpha(0.5);
        draw_text(xx + 552, yy + 549 + 70, string_hash_to_newline("3) 16% discount"));

        bonus_string = "Random";
        if (stc_bonus[4] = 1) then bonus_string = "Enhanced Hull";
        if (stc_bonus[4] = 2) then bonus_string = "Enhanced Armour";
        if (stc_bonus[4] = 3) then bonus_string = "New Weapons";
        draw_set_alpha(1);

        if (stc_vehicles < 4) then draw_set_alpha(0.5);
        draw_text(xx + 552, yy + 549 + 105, string_hash_to_newline("4) " + string(bonus_string)));
        draw_set_alpha(1);

        if (stc_vehicles < 5) then draw_set_alpha(0.5);
        draw_text(xx + 552, yy + 549 + 140, string_hash_to_newline("5) 25% discount"));
        draw_set_alpha(1);

        if (stc_vehicles < 6) then draw_set_alpha(0.5);
        draw_text_ext(xx + 552, yy + 549 + 175, string_hash_to_newline("6) Can produce Land Speeders and Land Raiders."), -1, 140);
        draw_set_alpha(1);

        // 21 right of the gray bar
        draw_set_font(fnt_40k_12);
        draw_set_alpha(1);
        if (stc_ships < 1) then draw_set_alpha(0.5);
        draw_text(xx + 732, yy + 549, string_hash_to_newline("1) 8% discount"));
        bonus_string = "Random";
        if (stc_bonus[5] = 1) then bonus_string = "Enhanced Hull";
        if (stc_bonus[5] = 2) then bonus_string = "Enhanced Accuracy";
        if (stc_bonus[5] = 3) then bonus_string = "Enhanced Turning";
        if (stc_bonus[5] = 4) then bonus_string = "Enhanced Boarding";
        if (stc_bonus[5] = 5) then bonus_string = "Enhanced Armour";
        draw_set_alpha(1);

        if (stc_ships < 2) then draw_set_alpha(0.5);
        draw_text(xx + 732, yy + 549 + 35, string_hash_to_newline("2) " + string(bonus_string)));
        draw_set_alpha(1);

        if (stc_ships < 3) then draw_set_alpha(0.5);
        draw_text(xx + 732, yy + 549 + 70, string_hash_to_newline("3) 16% discount"));

        bonus_string = "Random";
        if (stc_bonus[6] = 1) then bonus_string = "Enhanced Hull";
        if (stc_bonus[6] = 2) then bonus_string = "Enhanced Armour";
        if (stc_bonus[6] = 3) then bonus_string = "Enhanced Speed";
        draw_set_alpha(1);

        if (stc_ships < 4) then draw_set_alpha(0.5);
        draw_text(xx + 732, yy + 549 + 105, string_hash_to_newline("4) " + string(bonus_string)));
        draw_set_alpha(1);

        if (stc_ships < 5) then draw_set_alpha(0.5);
        draw_text(xx + 732, yy + 549 + 140, string_hash_to_newline("5) 25% discount"));
        draw_set_alpha(1);

        if (stc_ships < 6) then draw_set_alpha(0.5);
        draw_text_ext(xx + 732, yy + 549 + 175, string_hash_to_newline("6) Warp Speed is increased and ships self-repair."), -1, 140);
        draw_set_alpha(1);
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