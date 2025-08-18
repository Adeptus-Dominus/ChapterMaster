function role_setup_objects(){

    specialist_distribution_box =  new ToggleButton({
        str1 : "Equal Specialist Distribution",
        font : fnt_40k_12,
        style : "box",
        x1 :560,
        y1 : 250,
        tooltip : $"Specialist Distribution\nCheck if you wish for your Companies to be uniform and each contain {role[100][10]}s and {role[100][9]}s.",
        active : equal_specialists,
        clicked_check_default : true,
    });

    load_to_ship_radio = new RadioSet([
        {
            str1 : "On Planet",
            font : fnt_40k_12,
            style : "box",
            tooltip : $"On Planet/nCheck to have your Astartes Start on your home planet.",
        },
        {
            str1 : "Load to Ships",
            font : fnt_40k_12,
            style : "box",
            tooltip : $"Load to Ships\nCheck to have your Astartes automatically loaded into ships when the game starts.",
        },
        {
            str1 : "Load (Sans Escorts)",
            font : fnt_40k_12,
            style : "box",
            tooltip : $"Load (Sans Escorts)\nCheck to have your Astartes automatically loaded into ships, except for Escorts, when the game starts.",
        }        
    ], "", {x1: 530, y1 : 310, x_gap:20})
    load_to_ship_radio.current_selection = load_to_ships[0];
    distribute_scouts_box =  new ToggleButton({
        str1 : "Distribute Scouts",
        font : fnt_40k_12,
        style : "box",
        x1 :540,
        y1 : 370,
        tooltip : $"Distribute Scouts\nCheck to have your Scouts split across ships in the fleet.",
        active : load_to_ships[1],
        clicked_check_default : true,
    });
    distribute_vets_box =  new ToggleButton({
        str1 : "Distribute Veterans",
        font : fnt_40k_12,
        style : "box",
        x1 :690,
        y1 : 370,
        tooltip : $"Distribute Veterans\nCheck to have your Veterans split across the fleet.",
        active : load_to_ships[2],
        clicked_check_default : true,
    });
}

function scr_role_setup(){
    add_draw_return_values();

    draw_set_font(fnt_40k_30b);
    draw_set_halign(fa_center);
    draw_set_alpha(1);
    draw_set_color(38144);


    draw_text_color_simple(800,80,"Roles",38144);
	var c=100;
	if (!instance_exists(obj_creation_popup)){
        roles_radio.update({y1:150});
		roles_radio.draw();
		if (roles_radio.changed && custom==eCHAPTER_TYPE.CUSTOM){
	        instance_destroy(obj_creation_popup);
	        var pp=instance_create(0,0,obj_creation_popup);
	        pp.type=roles_radio.selection_val("role_id") + 100;
		}
	}
    draw_set_color(38144);
    draw_set_alpha(1);
    draw_set_font(fnt_40k_30b);
    
    if (custom != eCHAPTER_TYPE.CUSTOM) then draw_set_alpha(0.5);

    specialist_distribution_box.draw(equal_specialists);
    equal_specialists = specialist_distribution_box.active;


    load_to_ship_radio.draw();

    load_to_ships[0] = load_to_ship_radio.current_selection;




	
	if (load_to_ships[0] > 0){
		distribute_scouts_box.draw(load_to_ships[1]);
        load_to_ships[1] = distribute_scouts_box.active;

        distribute_vets_box.draw(load_to_ships[2]);
        load_to_ships[2] = distribute_vets_box.active;	
	}	
    
    
    
    
    draw_line(433,535,844,535);
    draw_line(433,536,844,536);
    draw_line(433,537,844,537);
	if (!instance_exists(obj_creation_popup)){
        draw_set_halign(fa_left);
        if (scr_hit(540,547,800,725)){
            tooltip="Advisor Names";
            tooltip2="The names of your main Advisors.  They provide useful information and reports on the divisions of your Chapter.";
        }
    
        draw_text_transformed(444,550,string_hash_to_newline("Advisor Names"),0.6,0.6,0);
        draw_set_font(fnt_40k_14b);
        draw_set_halign(fa_right);
        if (race[100,15]!=0) then draw_text(594,575,("Chief Apothecary: "));
        if (race[100,14]!=0) then draw_text(594,597,("High Chaplain: "));
        if (race[100,17]!=0) then draw_text(594,619,("Chief Librarian: "));
        if (race[100,16]!=0) then draw_text(594,641,("Forge Master: "));
        draw_text(594,663,"Master of Recruits: ");
        draw_text(594,685,"Master of the Fleet: ");
        draw_set_halign(fa_left);
        
        if (race[100,15]!=0){
            draw_set_color(38144);
            if (hapothecary="") then draw_set_color(c_red);
            if (text_selected!="apoth") or (custom != eCHAPTER_TYPE.CUSTOM) then draw_text_ext(600,575,string_hash_to_newline(string(hapothecary)),-1,580);
            if (custom == eCHAPTER_TYPE.CUSTOM){
                if (text_selected="capoth") and (text_bar>30) then draw_text_ext(600,575,string_hash_to_newline(string(hapothecary)),-1,580);
                if (text_selected="capoth") and (text_bar<=30) then draw_text_ext(600,575,string_hash_to_newline(string(hapothecary)+"|"),-1,580);
                var str_width,hei;str_width=0;hei=string_height_ext(string_hash_to_newline(hapothecary),-2,580);
                if (scr_hit(600,575,785,575+hei)){
                    obj_cursor.image_index=2;
                    if (scr_click_left()) and (!instance_exists(obj_creation_popup)){
                        text_selected="capoth";
                        keyboard_string=hapothecary;
                    }
                }
                if (text_selected="capoth") then hapothecary=keyboard_string;
                draw_rectangle(600-1,575-1,785,575+hei,1);
                
                var _refresh_capoth_name_btn =[794, 574, 794+20, 574+20];
                draw_unit_buttons(_refresh_capoth_name_btn,"?", [1,1], 38144,,fnt_40k_14b);
                if(point_and_click(_refresh_capoth_name_btn)){
                    var _new_capoth_name = global.name_generator.generate_space_marine_name();
                    show_debug_message($"regen name of hapothecary from {hapothecary} to {_new_capoth_name}");
                    hapothecary = _new_capoth_name;
                }
            }
        }
        
        if (race[100,14]!=0){
            draw_set_color(38144);if (hchaplain="") then draw_set_color(c_red);
            if (text_selected!="chap") or (custom != eCHAPTER_TYPE.CUSTOM) then draw_text_ext(600,597,string_hash_to_newline(string(hchaplain)),-1,580);
            if (custom == eCHAPTER_TYPE.CUSTOM){
                if (text_selected="chap") and (text_bar>30) then draw_text_ext(600,597,string_hash_to_newline(string(hchaplain)),-1,580);
                if (text_selected="chap") and (text_bar<=30) then draw_text_ext(600,597,string_hash_to_newline(string(hchaplain)+"|"),-1,580);
                var str_width,hei;str_width=0;hei=string_height_ext(string_hash_to_newline(hchaplain),-2,580);
                if (scr_hit(600,597,785,597+hei)){obj_cursor.image_index=2;
                    if (scr_click_left()) and (!instance_exists(obj_creation_popup)){text_selected="chap";keyboard_string=hchaplain;}
                }
                if (text_selected="chap") then hchaplain=keyboard_string;
                draw_rectangle(600-1,597-1,785,597+hei,1);

                var _refresh_chap_name_btn =[794, 597, 794+20, 597+20];
                draw_unit_buttons(_refresh_chap_name_btn,"?", [1,1], 38144,,fnt_40k_14b);
                if(point_and_click(_refresh_chap_name_btn)){
                    var _new_chap_name = global.name_generator.generate_space_marine_name();
                    show_debug_message($"regen name of hchaplain from {hchaplain} to {_new_chap_name}");
                    hchaplain = _new_chap_name;
                }
            }
        }
        
        if (race[100,17]!=0){
            draw_set_color(38144);if (clibrarian="") then draw_set_color(c_red);
            if (text_selected!="libra") or (custom != eCHAPTER_TYPE.CUSTOM) then draw_text_ext(600,619,string_hash_to_newline(string(clibrarian)),-1,580);
            if (custom == eCHAPTER_TYPE.CUSTOM){
                if (text_selected="libra") and (text_bar>30) then draw_text_ext(600,619,string_hash_to_newline(string(clibrarian)),-1,580);
                if (text_selected="libra") and (text_bar<=30) then draw_text_ext(600,619,string_hash_to_newline(string(clibrarian)+"|"),-1,580);
                var str_width,hei;str_width=0;hei=string_height_ext(string_hash_to_newline(clibrarian),-2,580);
                if (scr_hit(600,619,785,619+hei)){obj_cursor.image_index=2;
                    if (scr_click_left()) and (!instance_exists(obj_creation_popup)){text_selected="libra";keyboard_string=clibrarian;}
                }
                if (text_selected="libra") then clibrarian=keyboard_string;
                draw_rectangle(600-1,619-1,785,619+hei,1);

                var _refresh_libra_name_btn =[794, 619, 794+20, 619+20];
                draw_unit_buttons(_refresh_libra_name_btn,"?", [1,1], 38144,,fnt_40k_14b);
                if(point_and_click(_refresh_libra_name_btn)){
                    var _new_libra_name = global.name_generator.generate_space_marine_name();
                    show_debug_message($"regen name of clibrarian from {clibrarian} to {_new_libra_name}");
                    clibrarian = _new_libra_name;
                }
            }
        }
        
        if (race[100,16]!=0){
            draw_set_color(38144);if (fmaster="") then draw_set_color(c_red);
            if (text_selected!="forge") or (custom != eCHAPTER_TYPE.CUSTOM) then draw_text_ext(600,641,string_hash_to_newline(string(fmaster)),-1,580);
            if (custom == eCHAPTER_TYPE.CUSTOM){
                if (text_selected="forge") and (text_bar>30) then draw_text_ext(600,641,string_hash_to_newline(string(fmaster)),-1,580);
                if (text_selected="forge") and (text_bar<=30) then draw_text_ext(600,641,string_hash_to_newline(string(fmaster)+"|"),-1,580);
                var str_width,hei;str_width=0;hei=string_height_ext(string_hash_to_newline(fmaster),-2,580);
                if (scr_hit(600,641,785,641+hei)){obj_cursor.image_index=2;
                    if (scr_click_left()) and (!instance_exists(obj_creation_popup)){text_selected="forge";keyboard_string=fmaster;}
                }
                if (text_selected="forge") then fmaster=keyboard_string;
                draw_rectangle(600-1,641-1,785,641+hei,1);

                var _refresh_forge_name_btn =[794, 641, 794+20, 641+20];
                draw_unit_buttons(_refresh_forge_name_btn,"?", [1,1], 38144,,fnt_40k_14b);
                if(point_and_click(_refresh_forge_name_btn)){
                    var _new_forge_name = global.name_generator.generate_space_marine_name();
                    show_debug_message($"regen name of fmaster from {fmaster} to {_new_forge_name}");
                    fmaster = _new_forge_name;
                }
            }
        }
        
        draw_set_color(38144);if (recruiter="") then draw_set_color(c_red);
        if (text_selected!="recr") or (custom != eCHAPTER_TYPE.CUSTOM) then draw_text_ext(600,663,string_hash_to_newline(string(recruiter)),-1,580);
        if (custom == eCHAPTER_TYPE.CUSTOM){
            if (text_selected="recr") and (text_bar>30) then draw_text_ext(600,663,string_hash_to_newline(string(recruiter)),-1,580);
            if (text_selected="recr") and (text_bar<=30) then draw_text_ext(600,663,string_hash_to_newline(string(recruiter)+"|"),-1,580);
            var str_width,hei;str_width=0;hei=string_height_ext(string_hash_to_newline(recruiter),-2,580);
            if (scr_hit(600,663,785,663+hei)){obj_cursor.image_index=2;
                if (scr_click_left()) and (!instance_exists(obj_creation_popup)){text_selected="recr";keyboard_string=recruiter;}
            }
            if (text_selected="recr") then recruiter=keyboard_string;
            draw_rectangle(600-1,663-1,785,663+hei,1);
            
            var _refresh_recr_name_btn =[794, 663, 794+20, 663+20];
            draw_unit_buttons(_refresh_recr_name_btn,"?", [1,1], 38144,,fnt_40k_14b);
            if(point_and_click(_refresh_recr_name_btn)){
                var _new_recr_name = global.name_generator.generate_space_marine_name();
                show_debug_message($"regen name of recruiter from {recruiter} to {_new_recr_name}");
                recruiter = _new_recr_name;
            }
        }
        
        draw_set_color(38144);if (admiral="") then draw_set_color(c_red);
        if (text_selected!="admi") or (custom != eCHAPTER_TYPE.CUSTOM) then draw_text_ext(600,685,string_hash_to_newline(string(admiral)),-1,580);
        if (custom == eCHAPTER_TYPE.CUSTOM){
            if (text_selected="admi") and (text_bar>30) then draw_text_ext(600,685,string_hash_to_newline(string(admiral)),-1,580);
            if (text_selected="admi") and (text_bar<=30) then draw_text_ext(600,685,string_hash_to_newline(string(admiral)+"|"),-1,580);
            var str_width,hei;str_width=0;hei=string_height_ext(string_hash_to_newline(admiral),-2,580);
            if (scr_hit(600,685,785,685+hei)){obj_cursor.image_index=2;
                if (scr_click_left()) and (!instance_exists(obj_creation_popup)){text_selected="admi";keyboard_string=admiral;}
            }
            if (text_selected="admi") then admiral=keyboard_string;
            draw_rectangle(600-1,685-1,785,685+hei,1);

            var _refresh_admi_name_btn =[794, 685, 794+20, 685+20];
            draw_unit_buttons(_refresh_admi_name_btn,"?", [1,1], 38144,,fnt_40k_14b);
            if(point_and_click(_refresh_admi_name_btn)){
                var _new_admi_name = global.name_generator.generate_space_marine_name();
                show_debug_message($"regen name of admiral from {admiral} to {_new_admi_name}");
                admiral = _new_admi_name;
            }
        }  
    }
    pop_draw_return_values();
}