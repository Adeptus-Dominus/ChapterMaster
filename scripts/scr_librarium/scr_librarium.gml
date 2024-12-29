// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function set_chapter_arti_data(){
    artifacts=0;
    menu_artifact=-1;
    unused_artifacts = 0;
    for (var i=0;i<array_length(obj_ini.artifact);i++){
        if (obj_ini.artifact[i] != ""){
            if (menu_artifact==-1) then menu_artifact=i;
            artifacts++;
            if (!obj_ini.artifact_equipped[i]){
                unused_artifacts++;
            }
        }
    }                    
}
function scr_librarium(){
	var blurp="";
    var xx = __view_get(e__VW.XView, 0) + 0;
	var yy = __view_get(e__VW.YView, 0) + 0;	
 	draw_sprite(spr_rock_bg, 0, xx, yy);

        draw_set_alpha(0.75);
        draw_set_color(0);
        draw_rectangle(xx + 326 + 16, yy + 66, xx + 887 + 16, yy + 818, 0);
        draw_set_alpha(1);
        draw_set_color(c_gray);
        draw_rectangle(xx + 326 + 16, yy + 66, xx + 887 + 16, yy + 818, 1); // Center librarium box
        draw_line(xx + 326 + 16, yy + 426, xx + 887 + 16, yy + 426);
        draw_set_alpha(0.75);
        draw_set_color(0);
        draw_rectangle(xx + 945, yy + 66, xx + 1580, yy + 818, 0);
        draw_set_alpha(1);
        draw_set_color(c_gray);
        draw_rectangle(xx + 945, yy + 66, xx + 1580, yy + 818, 1); // Right librarium box

        if (menu_adept = 0) {
            // draw_sprite(spr_advisors,3,xx+16,yy+43);
            scr_image("advisor", 3, xx + 16, yy + 43, 310, 828);
            if (global.chapter_name = "Space Wolves") then scr_image("advisor", 10, xx + 16, yy + 43, 310, 828);
            // draw_sprite(spr_advisors,10,xx+16,yy+43);
            draw_set_halign(fa_left);
            draw_set_color(c_gray);
            draw_set_font(fnt_40k_30b);
            draw_text_transformed(xx + 336 + 16, yy + 66, string_hash_to_newline("Librarium"), 1, 1, 0);
            draw_text_transformed(xx + 336 + 16, yy + 100, string_hash_to_newline("Chief " + string(obj_ini.role[100, 17]) + " " + string(obj_ini.name[0, 4])), 0.6, 0.6, 0);
            draw_set_font(fnt_40k_14);
        }
        if (menu_adept = 1) {
            // draw_sprite(spr_advisors,0,xx+16,yy+43);
            scr_image("advisor", 0, xx + 16, yy + 43, 310, 828);
            draw_set_halign(fa_left);
            draw_set_color(c_gray);
            draw_set_font(fnt_large);
            draw_text_transformed(xx + 336 + 16, yy + 66, string_hash_to_newline("Librarium"), 1, 1, 0);
            draw_text_transformed(xx + 336 + 16, yy + 100, string_hash_to_newline("Adept " + string(obj_controller.adept_name)), 0.6, 0.6, 0);
            draw_set_font(fnt_40k_14);
        }

        var tip2 = "";

        // Set pace of recruitment based on training psyker value
        if (training_psyker >= 0 && training_psyker <= 6){
            var _recruit_pace = ARR_recruitment_pace;
            blurp += _recruit_pace[training_psyker];
        }

        var artif = "",
            artif_descr = "",
            tp = 0;

        if (unused_artifacts = 0) { artif = "no unused artifacts.";}
        else if (unused_artifacts = 1) { artif = "one unused artifact.";}
        else if (unused_artifacts > 1) { artif = string(unused_artifacts) + " unused artifacts.";}

        // Greetings message
        if (menu_adept = 0) then draw_text_ext(xx + 336 + 16, yy + 130, string_hash_to_newline("Chapter Master " + string(obj_ini.name[0, 0]) + ", greetings.#I assume you've come for the report?  The Chapter currently possesses " + string(temp[36]) + " Epistolaries, " + string(temp[37]) + " Codiceries, and " + string(temp[38]) + " Lexicanum.  We are working to identify additional warp-sensitive brothers before they cause harm, and the training is " + string(blurp) + ".##We could likely speed up the identification and application of appropriate training, but we would need more resources...I don't suppose we can spare some?##Our Chapter has " + string(artif)), -1, 536);
        if (menu_adept = 1) then draw_text_ext(xx + 336 + 16, yy + 130, string_hash_to_newline("Your Chapter contains " + string(temp[36]) + " " + string(obj_ini.role[100, 17]) + "s, " + string(temp[37]) + " Codiceries, and " + string(temp[38]) + " Lexicanum.##Training of more " + string(obj_ini.role[100, 17]) + "s is " + string(blurp) + ".##Your chapter has " + string(artif)), -1, 536);

        draw_set_color(881503);
        draw_set_halign(fa_center);
        identifiable = 0;
        if (artifacts > 0) {
            var usey =0;
            for (var i = 0, ilen = array_length(obj_ini.artifact); i < ilen; i++) {
                if (obj_ini.artifact[i]!="") {
                    usey++;
                }
                if (i == menu_artifact) {
                    break;
                }
            }
            draw_text(xx + 622, yy + 440, $"[Artifact {usey} of {artifacts}]");

            if scr_hit(xx + 326 + 16, yy + 426, xx + 887 + 16, yy + 818) {
                var arrow_hovered = false;
                var scroll_engaged = false;
                var arrow = [xx+400,yy+437,xx+445,yy+461];
                if (scr_hit(arrow[0],arrow[1],arrow[2],arrow[3])) {
                    arrow_hovered = true;
                    if (scr_click_left()){
                        scroll_engaged = true;
                    }
                }
                if (mouse_wheel_down()){
                    scroll_engaged = true;
                }

                if (scroll_engaged) {
                    artifact_namer.allow_input=false;
                    identifiable=false;
                    artifact_equip = new ShutterButton();
                    artifact_gift = new ShutterButton();
                    artifact_destroy = new ShutterButton();
                    var done = false;
                    while (menu_artifact > 0) {
                        menu_artifact--;
                        if (obj_ini.artifact[menu_artifact] != "") {
                            done = true;
                            break;
                        }
                    }
                    if (!done and menu_artifact <= 0) {
                        // we didn't find a lower artifact to goto, so we find the highest
                        for (var i = array_length(obj_ini.artifact) - 1; i >= 0; i--) {
                            if (obj_ini.artifact[i] != "") {
                                menu_artifact = i;
                                break;
                            }
                        }
                    }
                }
                if (arrow_hovered) {
                    tooltip_draw("Click here or use mouse wheel to scroll the artifact list.");
                }

                arrow_hovered = false;
                scroll_engaged = false;
                arrow = [xx+790,yy+437,xx+832,yy+461];
                if (scr_hit(arrow[0],arrow[1],arrow[2],arrow[3])) {
                    arrow_hovered = true;
                    if (scr_click_left()){
                        scroll_engaged = true;
                    }
                }
                if (mouse_wheel_up()){
                    scroll_engaged = true;
                }

                if (scroll_engaged) {
                    artifact_namer.allow_input=false;
                    identifiable=0;
                    artifact_equip = new ShutterButton();
                    artifact_gift = new ShutterButton();
                    artifact_destroy = new ShutterButton();
                    var max_index = array_length(obj_ini.artifact) - 1;
                    var done = false;
                    while (menu_artifact < max_index) {
                        menu_artifact++;
                        if (obj_ini.artifact[menu_artifact] != "") {
                            done = true;
                            break;
                        }
                    }
                    if (!done and menu_artifact >= max_index) {
                        // we didn't find a higher artifact to goto, so we find the lowest
                        for (var i = 0, ilen = array_length(obj_ini.artifact); i < ilen; i++) {
                            if (obj_ini.artifact[i] != "") {
                                menu_artifact = i;
                                break;
                            }
                        }
                    }
                }
                if (arrow_hovered) {
                    tooltip_draw("Click on this arrow or use mouse wheel to scroll the artifact list.");
                }
            }

            var artifact_name = obj_ini.artifact_struct[menu_artifact].name;
            if (artifact_name == "") then artifact_name = obj_ini.artifact[menu_artifact];
            obj_ini.artifact_struct[menu_artifact].name = artifact_namer.draw(artifact_name); 
            draw_sprite(spr_arrow, 0, xx + 403, yy + 433);
            draw_sprite(spr_arrow, 1, xx + 795, yy + 433);
            // Artifact description box
            var description_box = {
                x: xx + 392,
                y: yy + 500,
                x2: xx + 852,
                y2: yy + 740,
            }
            draw_rectangle_outline(description_box.x, description_box.y, description_box.x2, description_box.y2, c_black, c_gray, 1);
            var cur_arti = obj_ini.artifact_struct[menu_artifact];
            identifiable = cur_arti.is_identifiable();

            if (cur_arti.type() != "") {
                var artif_descr = $"This artifact is an unidentified {cur_arti.type()}.##It is stored on {cur_arti.ship_id()>=0 ? "the ship" :""} '{cur_arti.location_string()}'.";
                if (cur_arti.identified() > 0) and (identifiable = 0) {
                    draw_set_color(881503);
                    artif_descr += $"#To be identified it must be brought to a fleet with a Battle Barge or your Homeworld.";
                }else if (cur_arti.identified() > 0) and(identifiable = 1) {
                    draw_set_color(881503);
                    artif_descr += $"##It will be identified in {cur_arti.identified()} turns. #You may spend 150 Requisition to identify it immediately.";

                    //TODO solidify following button into a proper styled struct button
                    var ident_button = draw_unit_buttons([xx+532,yy+765], "IDENTIFY NOW",[1,1],c_black,,fnt_40k_14b,,1,c_gray); 
                    if (point_and_click(ident_button)){
                        if (requisition>=150){
                            obj_ini.artifact_identified[menu_artifact]=0;
                            requisition-=150;
                            cooldown=8000;
                            identifiable=0;
                            audio_play_sound(snd_identify,-500,0);
                            audio_sound_gain(snd_identify,master_volume*effect_volume,0);
                        }                         
                    }
                }
                else if (obj_ini.artifact_identified[menu_artifact] < 1) {
                    draw_set_color(881503);
                    artif_descr = "";
                    try{
                        artif_descr = obj_ini.artifact_struct[menu_artifact].description();
                    }   catch( _exception){
                        handle_exception(_exception);
                    }
                    tooltip = "";
                    tooltip_other = "";
                    var arti_data = gear_weapon_data("any",obj_ini.artifact[menu_artifact], "all", false, obj_ini.artifact_quality[menu_artifact]);

                    var _can_equip = cur_arti.can_equip();
                    if (_can_equip){
                        if (cur_arti.equipped()) then _can_equip = false;
        
                        if (_can_equip){
                            if (artifact_equip.draw_shutter(xx + 385, yy + 770, "EQUIP", 0.3,true)){
                                if (_can_equip && !instance_exists(obj_popup)){
                                    var pop=instance_create(0,0,obj_popup);
                                    pop.type=8;
                                    cooldown=8;                            
                                }
        
                            }
                        } else if (is_array(cur_arti.bearer)) {
                            if (artifact_equip.draw_shutter(xx + 385, yy + 770, "UNEQUIP", 0.3,true)){
                                cur_arti.unequip_from_unit();
                            }                            
                        }
                    }

                    if (artifact_gift.draw_shutter(xx + 575, yy + 770, "GIFT", 0.3, true)){
                        show_debug_message("Clicked");
                        var chick=false;
                        //list of all giftable factions enum numbers
                        var giftable_factions = [eFACTION.Imperium, eFACTION.Mechanicus,eFACTION.Inquisition,eFACTION.Ecclesiarchy,eFACTION.Eldar,eFACTION.Tau]
                        for (var i = 0; i < array_length(giftable_factions); i++){
                            var gift_faction = giftable_factions[i];
                            if (known[gift_faction] && !faction_defeated[gift_faction]) then chick=true;
                        }

                        if (chick){
                            var pop=instance_create(0,0,obj_popup);
                            pop.type=9;
                            cooldown=8;
                        }                   
                    }
                    if (artifact_destroy.draw_shutter(xx + 765, yy + 770, "DESTROY", 0.3, true)){
                        // Below here cleans up the artifacts

                        if (menu_artifact==fest_display) then fest_display=0;

                        cur_arti.destroy_arti();

                        //TODO centralise into function
                        for (var e = 0, elen = array_length(obj_controller.recent_keyword); e < elen; e++) {
                            if (obj_ini.artifact_tags[menu_artifact] == obj_controller.recent_keyword[e]) {
                                with (obj_controller) {
                                    array_delete(recent_keyword, e, 1);
                                    array_delete(recent_type, e, 1);
                                    array_delete(recent_turn, e, 1);
                                    array_delete(recent_number, e, 1);
                                }
                                scr_recent("artifact_destroyed", obj_controller.recent_keyword,2);
                                scr_recent("", "", 0);
                                break;
                            }
                        }
                        delete_artifact(menu_artifact);
                        set_chapter_arti_data();
                    }
                    var base_type = cur_arti.determine_base_type();
                    if (arti_data && base_type!="device"){
                        if (arti_data.armour_value != 0) {
                            tip2 += $"{arti_data.armour_value} Armour#";
                        }
                        if (arti_data.attack != 0) {
                            tip2 = $"{arti_data.attack} Damage#";
                        }
                        if (arti_data.hp_mod != 0) {
                            tip2 += $"{arti_data.hp_mod}% Health Bonus#";
                        }
                        if (arti_data.melee_mod != 0) {
                            tip2 += $"{arti_data.melee_mod}% Melee Bonus#";
                        }
                        if (arti_data.ranged_mod != 0) {
                            tip2 += $"{arti_data.ranged_mod}% Ranged Bonus#";
                        }
                        if (arti_data.damage_resistance_mod != 0) {
                            tip2 += $"{arti_data.damage_resistance_mod}% Resistance Bonus#";
                        }
                        if (base_type=="gear") { // Gear
                            tip2 = tooltip_other;
                        }
                    }
                } else {
                    artifact_destroy.draw_shutter(xx + 765, yy + 740, "DESTROY", 0.3, false);
                    artifact_equip.draw_shutter(xx + 385, yy + 740, "EQUIP", 0.3, false);
                    artifact_gift.draw_shutter(xx + 575, yy + 740, "GIFT", 0.3, false);
                }
                draw_set_halign(fa_center);
                draw_set_font(fnt_40k_14);
                draw_set_color(c_gray);
                draw_text_ext(xx + 622, yy + 510, string_hash_to_newline(string(artif_descr)), -1, 436);
                draw_set_font(fnt_40k_14b);
                draw_set_color(c_gray);
                var spack = string_height_ext(string_hash_to_newline(string(artif_descr)), -1, 436);
                draw_text_ext(xx + 622, yy + 514 + spack, string_hash_to_newline(tip2), -1, 436);

                // identifiable=0;
            }
        }else if (artifacts == 0){
            draw_text(xx + 622, yy + 440, "[No Artifacts]")
            artifact_destroy.draw_shutter(xx + 765, yy + 740, "DESTROY", 0.3, false);
            artifact_equip.draw_shutter(xx + 385, yy + 740, "EQUIP", 0.3, false);
            artifact_gift.draw_shutter(xx + 575, yy + 740, "GIFT", 0.3, false);           
        }
        draw_set_color(881503);
        draw_set_halign(fa_center);

        if (instance_exists(obj_p_fleet)) {
            with(obj_p_fleet) {
                var good = 0;
                if (obj_controller.artifacts>0){
                    for (var i = 1; i <= 20; i++) {
                        if (i <= 9 && i<array_length(capital_num)) {
                            if (capital_num[i] = obj_ini.artifact_sid[obj_controller.menu_artifact] - 500) then good = 1;
                        }
                        if (i<array_length(frigate_num)){
                            if (frigate_num[i] = obj_ini.artifact_sid[obj_controller.menu_artifact] - 500) then good = 1;
                        }
                        if (i<array_length(escort_num)){
                            if (escort_num[i] = obj_ini.artifact_sid[obj_controller.menu_artifact] - 500) then good = 1;
                        }
                    }
                }
                if (good = 1) and(capital_number > 0) then good = 2;
                if (good = 2) then obj_controller.identifiable = 1;
            }
        }
}