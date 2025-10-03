// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_livery_setup(){
    add_draw_return_values();
   draw_set_font(fnt_40k_30b);
    draw_set_halign(fa_center);
    draw_set_alpha(1);
    draw_set_color(CM_GREEN_COLOR);

    
    tooltip="";
    tooltip2="";
    obj_cursor.image_index=0;

    draw_text_color_simple(800,80,chapter_name,CM_GREEN_COLOR);
    
    var preview_box = {
        x1: 444,
        y1: 252,
        w: 167,
        h: 232,
    }
    preview_box.x2 = preview_box.x1 + preview_box.w;
    preview_box.y2 = preview_box.y1 + preview_box.h;
    colour_selection_options.update({x1 : preview_box.x1+20, y1:200});
    colour_selection_options.draw();

	/*draw_sprite_stretched(spr_creation_arrow,0,preview_box.x1,preview_box.y1,32,32);// Left Arrow
    draw_sprite_stretched(spr_creation_arrow,1,preview_box.x2-32,preview_box.y1,32,32);// Right Arrow 
    if (point_and_click([preview_box.x1,preview_box.y1,preview_box.x1+32,preview_box.y1+32])){
        test_sprite++;
        if (test_sprite==array_length(draw_sprites)) then test_sprite=0;
    }   
    if (point_and_click([preview_box.x2-32,preview_box.y1,preview_box.x2, preview_box.y1+32])){
        test_sprite--;
        if (test_sprite<0) then test_sprite=(array_length(draw_sprites)-1);
    }*/
    livery_picker.draw_base();
    draw_set_alpha(1);

    draw_set_font(fnt_40k_30b);
    draw_set_halign(fa_center);
    draw_set_alpha(1);
    draw_set_color(CM_GREEN_COLOR);
    var company_radio = buttons.company_liveries_choice;
    company_radio.draw_title = false;
    var comp_change = false;

    draw_set_color(CM_GREEN_COLOR);
    draw_set_halign(fa_left);
    draw_text_transformed(580,118,"Battle Cry:",0.6,0.6,0);
    draw_set_font(fnt_40k_14b);
    battle_cry = text_bars.battle_cry.draw((battle_cry));


    
    draw_rectangle(445, 200, 1125, 202, 0)
    
    draw_set_font(fnt_40k_30b);
    var button_alpha = custom != eCHAPTER_TYPE.CUSTOM ? 0.5 : 1;

    var _livery_switch = buttons.livery_switch;

    var str,str_width,hei,x8=0;y8=0;
    //Dont ask why the pauldron colours are switched i guess duke got confused between left and right at some point
    //TODO extract this function somewhere
    /*function draw_checkbox (cords, text, main_alpha, checked){
            draw_set_alpha(main_alpha);
            yar = col_special==(i+1) ?1:0;
            if (custom!=eCHAPTER_TYPE.CUSTOM) then draw_set_alpha(0.5);
            draw_sprite(spr_creation_check,yar,cur_button.cords[0],cur_button.cords[1]);
             if (scr_hit(cur_button.cords[0],cur_button.cords[1],cur_button.cords[0]+32,cur_button.cords[1]+32) and allow_colour_click){
                    
                    var onceh=0;
                    if (col_special=i+1) and (onceh=0){col_special=0;onceh=1;}
                    if (col_special!=i+1) and (onceh=0){col_special=i+1;onceh=1;}
             }
             draw_text_transformed(cur_button.cords[0]+30,cur_button.cords[1]+4,cur_button.text,0.4,0.4,0);
    }*/
    if (colour_selection_options.current_selection == 0){
        var _col_areas = livery_picker.colours_radio;
        _col_areas.current_selection = -1;
        _col_areas.update({x1:colour_selection_options.x1,y1:colour_selection_options.y2, max_width : 200});
        _col_areas.draw();
        if (_col_areas.changed){
            livery_picker.new_colour_pick(_col_areas.selection_val("area_id"));
        }
    }
    else if (colour_selection_options.current_selection == 1){
        var _updater = draw_unit_buttons([500,preview_box.y1-10], "Update Sprite");
        if(scr_hit(_updater)){
            tooltip_draw("Click to Update Marine colour picker with Colour settings, warning this will overide Existing colour selections");
        }

        if (point_and_click(_updater)){
            var struct_cols = {
                main_color :main_color,
                secondary_color:secondary_color,
                main_trim:main_trim,
                right_pauldron:right_pauldron,
                left_pauldron:left_pauldron,
                lens_color:lens_color,
                weapon_color:weapon_color
            }
            livery_picker.set_default_armour(struct_cols, col_special);    
        }

        var _tooltip_add_on = ". You can change this value as much as you want in order to update the marine role, company and default options on the left but remember to set this value back to your desired base value before continuing";

        for (var i=0;i<array_length(bulk_buttons);i++){
            if (bulk_buttons[i].draw(custom == eCHAPTER_TYPE.CUSTOM)){
                instance_destroy(obj_creation_popup);
                var pp=instance_create(0,0,obj_creation_popup);
                pp.type=i+1;
                pp.picker.title = bulk_buttons[i].label;
            }
        }

        bulk_armour_pattern.draw();
        col_special = bulk_armour_pattern.current_selection;

    } else {
        
        for (var i=0;i<array_length(complex_livery_buttons);i++){
            var _button = complex_livery_buttons[i];

            if (_button.draw()){
                instance_destroy(obj_creation_popup);
                var pp=instance_create(0,0,obj_creation_popup);
                pp.type=_button.area;
                pp.role = _button.role_id               
            }


        }
        draw_set_color(CM_GREEN_COLOR);
        advanced_helmet_livery.draw();
        complex_depth_selection = advanced_helmet_livery.current_selection;                                         
    }
    draw_set_alpha(1);
    
    draw_rectangle(844, 204, 846, 740, 0)
    draw_set_font(fnt_40k_14b);
    var c=100,role_id,spacing=30;
    draw_set_halign(fa_left);
    var xxx=862;
    var yyy=255-spacing;
    
    livery_selection_options.update({
        x1 : 862, 
        y1 : 200,
        max_width : 800,
    });

    var _prev_val = variable_clone(livery_selection_options.current_selection);

    if (colour_selection_options.current_selection != 2){
        livery_selection_options.draw();
    }

    var _update_sprite =false;
    if (livery_selection_options.changed){
        var _new_val = livery_selection_options.current_selection;
        _update_sprite = true;
        livery_picker.swap_role_set(_prev_val, _new_val);
    }

    var _livery_type = livery_selection_options.current_selection;

    if (colour_selection_options.current_selection != 2 && !_update_sprite){
        if (_livery_type == 1){
            roles_radio.update({x1:882, y1 :livery_selection_options.y2+20} );
            roles_radio.draw();
            if (roles_radio.changed && custom==eCHAPTER_TYPE.CUSTOM){
                livery_picker.swap_role_set(1,1);
            }
        } else if (_livery_type == 2){

            company_radio.update({
                max_width : 350,
                x1:862, y1 :livery_selection_options.y2+20,
                allow_changes : true
            });
            company_radio.draw();
            if (company_radio.changed){
                livery_picker.swap_role_set(2,2);
            }    

        }       
    } else {
        complex_livery_radio.draw();
        if (complex_livery_radio.changed){
            set_complex_livery_buttons();
        }
    }

    draw_set_font(fnt_40k_30b);
    draw_set_halign(fa_center);
    draw_set_alpha(1);
    draw_set_color(CM_GREEN_COLOR);
    if (_livery_type != 2){
        var liv_string = $"Full Livery \n{livery_picker.role_set == 0? "default" :role[100][livery_picker.role_set]}";
        draw_text(160, 100, liv_string);  
    } else{
        draw_text(160, 100, "Company Livery");  
    }

    draw_set_font(fnt_40k_14b);
    draw_set_halign(fa_left);
    draw_set_alpha(1);
    draw_set_color(CM_GREEN_COLOR);
    right_data_slate.inside_method = function() {
        var _cultures = buttons.culture_styles;
        _cultures.x1 = right_data_slate.XX+30;
        _cultures.y1 = right_data_slate.YY+80
        _cultures.max_width = right_data_slate.width-120;
        _cultures.on_change = function(){
            var _picker = obj_creation.livery_picker;
            _picker.shuffle_dummy();
            _picker.reset_image();
        }
        _cultures.draw();
    }

    right_data_slate.draw(1210, 5,0.45, 1);
    pop_draw_return_values();
}