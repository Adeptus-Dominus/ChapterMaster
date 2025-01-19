// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information


function scr_creation_home_planet_create(){

	var fleet_type_text = fleet_type==ePlayerBase.home_world ? "Homeworld" : "Flagship";
    draw_text_transformed(644,218,fleet_type_text,0.6,0.6,0);

    var _cur_planet_index=0,_cur_planet_index2=0,name_bad=0;
    

    var _cur_planet_index  = scr_planet_image_numbers(homeworld);
    if (fleet_type!=1) then _cur_planet_index=16;

    if (fleet_type == ePlayerBase.home_world){
        scr_image("ui/planet",_cur_planet_index,580,244,128,128);
        // draw_sprite(spr_planet_splash,_cur_planet_index,580,244);
        
        draw_text_transformed(644,378,homeworld,0.5,0.5,0);
        // draw_text_transformed(644,398,string(homeworld_name),0.5,0.5,0);
        if (text_selected!="home_name") or (custom<2) then draw_text_transformed(644,398,homeworld_name,0.5,0.5,0);

        if (custom>1){

            if (text_selected="home_name") {
            	draw_text_transformed(644,398,homeworld_name+(text_bar>30?"":"|"),0.5,0.5,0);
            } 

            if (scr_text_hit(644,398,true,homeworld_name)){
                obj_cursor.image_index=2;
                if (cooldown<=0) and (mouse_left>=1){
                	text_selected="home_name";
                	cooldown=8000;
                	keyboard_string=homeworld_name;
                }
            }
            if (text_selected="home_name") then homeworld_name=keyboard_string;
            draw_set_alpha(0.75);
            draw_rectangle(525,398,760,418,1);
            draw_set_alpha(1);
            var _refresh_hw_name_btn =[770, 398, 790, 418];
            draw_unit_buttons(_refresh_hw_name_btn,"?", [1,1], 38144,,fnt_40k_14b);
            if(point_and_click(_refresh_hw_name_btn)){
                var _new_hw_name = global.name_generator.generate_star_name();
                show_debug_message($"regen name of homeworld from {homeworld_name} to {_new_hw_name}");
                homeworld_name = _new_hw_name;
            }
        }
        
        if (custom>1){
        	draw_sprite_stretched(spr_creation_arrow,0,525,285,32,32);
        	draw_sprite_stretched(spr_creation_arrow,1,725,285,32,32);
        }
        var planet_types = ["Dead","Ice", "Temperate","Feudal","Shrine","Agri","Death","Hive","Forge","Desert","Lava"];
        var planet_change_allow = (mouse_left>=1) and (cooldown<=0) and (custom>1);
        for (var i=0;i<array_length(planet_types);i++){
            if (homeworld==planet_types[i] && planet_change_allow){
                if (point_and_click([525,285,525+32,285+32])){
                    if (i==array_length(planet_types)-1){
                        homeworld=planet_types[0];
                    } else {
                        homeworld=planet_types[i+1];
                    }
                    break;
                } else if (point_and_click([725,285,725+32,285+32])){
                    if (i==0){
                        homeworld=planet_types[array_length(planet_types)-1];
                    } else {
                        homeworld=planet_types[i-1];
                    }
                    break;
                }
            }
        }
        var _system_complex = buttons.complex_homeworld;
        _system_complex.update();
        _system_complex.draw();
        _system_complex.clicked();
        draw_set_font(fnt_40k_30b);
    }
    if (fleet_type != ePlayerBase.home_world){
        // draw_sprite(spr_planet_splash,_cur_planet_index,580,244);
        scr_image("ui/planet",_cur_planet_index,580,244,128,128);
        
        draw_text_transformed(644,378,"Battle Barge",0.5,0.5,0);
        // draw_text_transformed(644,398,string(homeworld_name),0.5,0.5,0);
        if (text_selected!="flagship_name") or (custom=0) then draw_text_transformed(644,398,flagship_name,0.5,0.5,0);

        if (custom>1){
            if (text_selected="flagship_name") and (text_bar>30) then draw_text_transformed(644,398,flagship_name,0.5,0.5,0);
            if (text_selected="flagship_name") and (text_bar<=30) then draw_text_transformed(644,398,flagship_name+"|",0.5,0.5,0);
            if (scr_text_hit(644,398,true,flagship_name)){
                obj_cursor.image_index=2;
                if (cooldown<=0) and (mouse_left>=1){
                    text_selected="flagship_name";
                    cooldown=8000;
                    keyboard_string=flagship_name;
                }
            }
            if (text_selected="flagship_name"){
            	flagship_name=keyboard_string;
            }
            draw_set_alpha(0.75);
            draw_rectangle(525,398,760,418,1);
            draw_set_alpha(1);
            var _refresh_fs_name_btn =[770, 398, 790, 418];
            draw_unit_buttons(_refresh_fs_name_btn,"?", [1,1], 38144,,fnt_40k_14b);
            if(point_and_click(_refresh_fs_name_btn)){
                var _new_fs_name = global.name_generator.generate_imperial_ship_name();
                show_debug_message($"regen name of flagship_name from {flagship_name} to {_new_fs_name}");
                flagship_name = _new_fs_name;
            }
        }
    }
    
    
    
    
    
    if (fleet_type!=ePlayerBase.penitent){
        if (fleet_type!=1) or (custom<2) then draw_set_alpha(0.5);
        yar=0;
        if (recruiting_exists=1) then yar=1;
        draw_sprite(spr_creation_check,yar,858,221);
        yar=0;
        if (scr_hit(858,221,858+32,221+32)) and (cooldown<=0) and (mouse_left>=1) and (custom>1) and (fleet_type=1){
        	cooldown=8000;
        	var onc_cur_planet_index;
        	onc_cur_planet_index=0;
            if (recruiting_exists=1) and (onc_cur_planet_index=0){
            	recruiting_exists=0;
            	onc_cur_planet_index=1;
            }
            if (recruiting_exists=0) and (onc_cur_planet_index=0){
            	recruiting_exists=1;
            	onc_cur_planet_index=1;
            }
        }
        draw_set_alpha(1);
        draw_text_transformed(644+333,218,"Recruiting World",0.6,0.6,0);
        
        if (recruiting_exists=1){
        	var _cur_planet_index2  = scr_planet_image_numbers(recruiting);
            
            if (custom>1){
            	draw_sprite_stretched(spr_creation_arrow,0,865,285,32,32);
            	draw_sprite_stretched(spr_creation_arrow,1,1055,285,32,32);
		        var planet_types = ARR_planet_types;
		        var planet_change_allow = (mouse_left>=1) and (cooldown<=0) and (custom>1);
		        for (var i=0;i<array_length(planet_types);i++){

		            if (recruiting==planet_types[i] && planet_change_allow){
		                if (point_and_click([865,285,865+32,285+32])){
		                    if (i==array_length(planet_types)-1){
		                        recruiting=planet_types[0];
		                    } else {
		                        recruiting=planet_types[i+1];
		                    }
		                }

		                if (point_and_click([1055,285,1055+32,285+32])){
		                    if (i==0){
		                        recruiting=planet_types[array_length(planet_types)-1];
		                    } else {
		                        recruiting=planet_types[i-1];
		                    }
		                }
		            }
		        }             	
            } 
           

            // draw_sprite(spr_planet_splash,_cur_planet_index2,580+333,244);
            scr_image("ui/planet",_cur_planet_index2,580+333,244,128,128);
            
            draw_text_transformed(644+333,378,recruiting,0.5,0.5,0);
            // draw_text_transformed(644+333,398,string(recruiting_name),0.5,0.5,0);
            
            if (fleet_type=1) and (homeworld_name=recruiting_name) then name_bad=1;
            //TODO make a centralised logic for player renaming things in the creation screen
            if (name_bad=1) then draw_set_color(c_red);
            if (text_selected!="recruiting_name") or (custom<2) then draw_text_transformed(644+333,398,recruiting_name,0.5,0.5,0);
            if (custom>1){
                if (text_selected="recruiting_name") and (text_bar>30) then draw_text_transformed(644+333,398,recruiting_name,0.5,0.5,0);
                if (text_selected="recruiting_name") and (text_bar<=30) then draw_text_transformed(644+333,398,$"{recruiting_name}|",0.5,0.5,0);
                if (scr_text_hit(644+333,398,true,recruiting_name)){
                    obj_cursor.image_index=2;
                    if (cooldown<=0) and (mouse_left>=1){
                    	text_selected="recruiting_name";
                    	cooldown=8000;
                    	keyboard_string=recruiting_name;
                    }
                }
                if (text_selected="recruiting_name") then recruiting_name=keyboard_string;
                draw_set_alpha(0.75);
                draw_rectangle(525+333,398,760+333,418,1);
                draw_set_alpha(1);

                var _refresh_rec_name_btn =[1103, 398, 1103+20, 398+20];
                draw_unit_buttons(_refresh_rec_name_btn,"?", [1,1], 38144,,fnt_40k_14b);
                if(point_and_click(_refresh_rec_name_btn)){
                    var _new_rec_name = global.name_generator.generate_star_name();
                    show_debug_message($"regen name of recruiting_name from {recruiting_name} to {_new_rec_name}");
                    recruiting_name = _new_rec_name;
                }
            }
        }
    }
    
    if (recruiting_exists==0 && homeworld_exists==1){
        // draw_sprite(spr_planet_splash,_cur_planet_index,580+333,244);
        scr_image("ui/planet",_cur_planet_index,580+333,244,128,128);
        
        draw_set_alpha(0.5);
        draw_text_transformed(644+333,378,homeworld,0.5,0.5,0);
        draw_text_transformed(644+333,398,homeworld_name,0.5,0.5,0);
        draw_set_alpha(1);
    }
    
    
    if (scr_hit(575,216,710,242)){
        if (fleet_type!=ePlayerBase.home_world){
        	tooltip="Battle Barge";
        	tooltip2="The name of your Flagship Battle Barge.";
        }
        else if (fleet_type==ePlayerBase.home_world){
        	tooltip="Homeworld";
        	tooltip2="The world that your Chapter's Fortress Monastery is located upon.  More civilized worlds are more easily defensible but the citizens may pose a risk or be a nuisance.";
        }
    }
    if (scr_hit(895,216,1075,242)){
        tooltip="Recruiting World";
        tooltip2="The world that your Chapter selects recruits from.  More harsh worlds provide recruits with more grit and warrior mentality.  If you are a homeworld-based Chapter, you may uncheck 'Recruiting World' to recruit from your homeworld instead.";
    }
    
    draw_line(445,455,1125,455);
    draw_line(445,456,1125,456);
    draw_line(445,457,1125,457);
    
    // homeworld_rule=0;
    // aspirant_trial=eTrials.BLOODDUEL;
    
    draw_set_halign(fa_left);
    
    //TODO move to OOP checkboxes
    if (fleet_type == ePlayerBase.home_world){
        if (custom<2) then draw_set_alpha(0.5);
        var _homeworld_types = [
        	{
        		name : "Planetary Governer",
        		tooltip : "Planetary Governer",
        		tooltip2 : "Your Chapter's homeworld is ruled by a single Planetary Governer, who does with the planet mostly as they see fit.  While heavily influenced by your Astartes the planet is sovereign.",
        	},
        	{
        		name : "Passive Supervision",
        		tooltip : "Passive Supervision",
        		tooltip2 : "Instead of a Planetary Governer the planet is broken up into many countries or clans.  The people are less united but happier, and see your illusive Astartes as semi-divine beings.",
        	},
        	{
        		name : "Personal Rule",
        		tooltip : "Personal Rule",
        		tooltip2 : "You personally take the rule of the Planetary Governer, ruling over your homeworld with an iron fist.  Your every word and directive, be they good or bad, are absolute law.",
        	},        	        	
        ]
        draw_text_transformed(445,480,"Homeworld Rule",0.6,0.6,0);

        var _coords = [445,512];
        for (var i=0;i<array_length(_homeworld_types);i++){
        	var _home_rule_type = _homeworld_types[i];
        	var _draw_x = _coords[0];
        	var _draw_y = _coords[1];
        	var _cur_select = homeworld_rule == i+1;
        	draw_text_transformed(_draw_x+40,_draw_y,_home_rule_type.name,0.5,0.5,0);
        	draw_sprite(spr_creation_check,_cur_select,_draw_x,_draw_y);
        	if (scr_hit(_draw_x, _draw_y,_draw_x+32, _draw_y+32)){
        		tooltip = _home_rule_type.tooltip;
        		tooltip2 = _home_rule_type.tooltip2;
        		if (scr_click_left() && custom>1){
        			homeworld_rule = i+1;
        		}
        	}
        	_coords[1] += 45;
        }
    }
}