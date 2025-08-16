function role_setup_objects(){

}

function scr_role_setup(){
	var c=100;
	if (!instance_exists(obj_creation_popup)){
		roles_radio.draw();
		if (roles_radio.changed && custom==eCHAPTER_TYPE.CUSTOM){
	        instance_destroy(obj_creation_popup);
	        var pp=instance_create(0,0,obj_creation_popup);
	        pp.type=roles_radio.selection_val("role_id") + 100;
		}
	}
    /*for (var role_slot =1;role_slot<=13;role_slot++){
        var id_array = [
            0,
            eROLE.Apothecary,
            eROLE.Chaplain,
            eROLE.Librarian,
            eROLE.Techmarine,
            eROLE.Captain,
            eROLE.HonourGuard,
            eROLE.Terminator,
            eROLE.Veteran,eROLE.Dreadnought,
            eROLE.Tactical,
            eROLE.Devastator,
            eROLE.Assault,
            eROLE.Scout
        ];
        role_id = id_array[role_slot];
        
        draw_set_alpha(1);
        if (race[c,role_id]!=0){
            if (custom != eCHAPTER_TYPE.CUSTOM) then draw_set_alpha(0.5);
            yyy+=spacing;
            draw_set_color(38144);
            draw_rectangle(xxx,yyy,1150,yyy+20,1);
            draw_set_color(38144);
            draw_text(xxx,yyy,role[100,role_id]);
            if (scr_hit(xxx,yyy,1150,yyy+20)) and ((!instance_exists(obj_creation_popup)) || ((instance_exists(obj_creation_popup) and obj_creation_popup.target_gear=0))) {

                draw_set_alpha(custom == eCHAPTER_TYPE.CUSTOM ? 0.2 : 0.1);
                draw_set_color(c_white);
                draw_rectangle(xxx,yyy,1150,yyy+20,0);
                draw_set_alpha(1);
                tooltip=string(role[c][role_id])+" Settings";
                tooltip2="Click to open the settings for this unit.";
                if (scr_click_left() and custom==eCHAPTER_TYPE.CUSTOM){
                    instance_destroy(obj_creation_popup);
                    var pp=instance_create(0,0,obj_creation_popup);
                    pp.type=role_id+100;
                    if (!comp_toggle.company_view){
                        full_liveries[livery_picker.role_set] = variable_clone(livery_picker.map_colour);
                        livery_picker.role_set = role_id;
                        livery_picker.map_colour = full_liveries[role_id];
                        if (!livery_picker.map_colour.is_changed){
                            livery_picker.map_colour = variable_clone(full_liveries[0]);
                        }
                        livery_picker.shuffle_dummy();
                        livery_picker.reset_image();
                        livery_picker.colour_pick=false;
                    }
                }
            }
        }
    } */ 
    draw_set_color(38144);
    draw_set_alpha(1);
    draw_set_font(fnt_40k_30b);
    
    if (custom != eCHAPTER_TYPE.CUSTOM) then draw_set_alpha(0.5);
    yar=0;
    if (equal_specialists=1) then yar=1;
    draw_sprite(spr_creation_check,yar,860,645);yar=0;
    if (scr_hit(860,650,1150,650+32)) and (!instance_exists(obj_creation_popup)){
    	tooltip="Specialist Distribution";
    	tooltip2=$"Check if you wish for your Companies to be uniform and each contain {role[100][10]}s and {role[100][9]}s.";
    }
    if (point_and_click([860,650,860+32,650+32]) and allow_colour_click){
        
        var onceh=0;
        equal_specialists = !equal_specialists;
    }
    draw_text_transformed(860+30,650+4,"Equal Specialist Distribution",0.4,0.4,0);
    draw_set_alpha(1);
    
    yar=0;
    if (load_to_ships[0]=1) then yar=1;draw_sprite(spr_creation_check,yar,860,645+40);yar=0;
    if (scr_hit(860,645+40,1005,645+32+40) and !instance_exists(obj_creation_popup)){
    	tooltip="Load to Ships";
    	tooltip2="Check to have your Astartes automatically loaded into ships when the game starts.";
    }
    if (point_and_click([860,645+40,860+32,645+32+40]) and (!instance_exists(obj_creation_popup))){
        var onceh=0;
        load_to_ships[0] = !load_to_ships[0];
    }
    draw_text_transformed(860+30,645+4+40,"Load to Ships",0.4,0.4,0);
    
    yar=0;

    draw_sprite(spr_creation_check,load_to_ships[0]==2,1010,645+40);
    if (scr_hit(1010,645+40,1150,645+32+40)) and (!instance_exists(obj_creation_popup)){
    	tooltip="Load (Sans Escorts)";
    	tooltip2="Check to have your Astartes automatically loaded into ships, except for Escorts, when the game starts.";
    }
    if (point_and_click([1010,645+40,1020+32,645+32+40]))  and (!instance_exists(obj_creation_popup)){
        
        load_to_ships[0] =  (load_to_ships[0]!=2) ? 2 : 0; 

    }
    draw_text_transformed(1010+30,645+4+40,"Load (Sans Escorts)",0.4,0.4,0);
	
	yar=0;
	if (load_to_ships[0] > 0){
		if (load_to_ships[1] == 1){
			yar=1;
		}
		draw_sprite(spr_creation_check,yar,860,645+80);yar=0;
    	if (scr_hit(860,645+80,1005,645+32+80)) and (!instance_exists(obj_creation_popup)){tooltip="Distribute Scouts";tooltip2="Check to have your Scouts split across ships in the fleet.";}
    	if (point_and_click([860,645+80,860+32,645+32+80])) and (!instance_exists(obj_creation_popup)){
             load_to_ships[1] = !load_to_ships[1];  		 
    	}
    	draw_text_transformed(860+30,645+4+80,"Distribute Scouts",0.4,0.4,0);	
	
		yar=0;
		if (load_to_ships[2] == 1){
			yar=1;
		}
		draw_sprite(spr_creation_check,yar,1010,645+80);yar=0;
    	if (scr_hit(1010,645+80,1150,645+32+80)) and (!instance_exists(obj_creation_popup)){
            tooltip="Distribute Veterans";tooltip2="Check to have your Veterans split across the fleet.";
        }
    	if (point_and_click([1010,645+80,1020+32,645+32+80])) and (!instance_exists(obj_creation_popup)){
    		var onceh=0;
             load_to_ships[2] = !load_to_ships[2] 		 
    	}
    	draw_text_transformed(1010+30,645+4+80,"Distribute Veterans",0.4,0.4,0);	
	}	
    
    
    
    
    draw_line(433,535,844,535);
    draw_line(433,536,844,536);
    draw_line(433,537,844,537);
	if (!instance_exists(obj_creation_popup)){
    
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
}