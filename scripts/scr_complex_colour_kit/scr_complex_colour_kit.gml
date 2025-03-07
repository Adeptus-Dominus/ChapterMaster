function coord_relevative_positions(coords, xx, yy){
	return [coords[0]+xx, coords[1]+yy,coords[2]+xx, coords[3]+yy];
}

enum eMarkings {
    RIGHTPAD,
    LEFTPAD,
    LEFTKNEE,
    RIGHTKNEE
}
function ColourItem(xx,yy) constructor{
    fetch_marine_components_to_memory();
	self.xx=xx;
	self.yy=yy;
    data_slate = new DataSlate();
    static scr_unit_draw_data = function(){
        map_colour = {
            is_changed : false,
            left_leg_lower : 0,
            left_leg_upper : 0,
            left_leg_knee : 0,
            right_leg_lower : 0,
            right_leg_upper : 0,
            right_leg_knee : 0,
            metallic_trim : 0,
            right_trim : 0,
            left_trim : 0,
            left_chest : 0,
            right_chest : 0,
            left_thorax : 0,
            right_thorax : 0, 
            left_pauldron : 0,
            left_arm : 0,
            left_hand : 0,
            right_pauldron: 0,
            right_arm : 0,
            right_hand : 0,
            left_head : 0,
            right_head: 0, 
            left_muzzle: 0,
            right_muzzle: 0,
            eye_lense :0,  
            right_backpack : 0,   
            left_backpack : 0,
            weapon_primary : 0,
            weapon_secondary : 0,
            company_marks : 0,
            company_marks_loc : 0,                         
        }
        return map_colour;
    }

    role_set=0;
    static image_location_maps = {
    		left_leg_lower : [103,165, 148,217],
            left_leg_upper : [83,107, 119,134],
            left_leg_knee : [105,138, 126,159],
            right_leg_lower : [15,165, 57,218],
            right_leg_upper : [43,107, 73,139],
            right_leg_knee : [35,138, 58,160],
            metallic_trim : [70,53, 100,70],

            right_trim :  [-100,31,string_width("R Trim"), string_height("R Trim")],
            left_trim : [-150,31,string_width("R Trim"), string_height("R Trim")],

            left_chest : [84,72, 108,92],
            right_chest : [50,73, 82,103],

            left_thorax : 0,
            right_thorax : 0, 

            weapon_primary : 0,
            weapon_secondary : 0,

            left_pauldron :[114,31, 150,67],
            right_pauldron: [19,31, 43,71],

            left_head : [81,15, 94,30],	
            right_head: [68,15, 81,31],	

            left_muzzle: [82,32, 90,42],	
            right_muzzle: [73,32, 82,42],	

            eye_lense : [40,-20,string_width("Lense"), string_height("Lense")],

            left_arm : [119,67,146,105],
            left_hand : [128,109,146,123],

            right_arm : [19,67,34,106],
            right_hand : [18,109,33,134], 

            right_backpack : [32,17,60,38],
            left_backpack : [97,17,130,38],

            company_marks :[30, 40, string_width("Company Marks"), string_height("Company Marks")],
    }

    static name_maps = {
        left_leg_lower: "Left Leg Lower",
        left_leg_upper: "Left Leg Upper",
        left_leg_knee: "Left Leg Knee",
        right_leg_lower: "Right Leg Lower",
        right_leg_upper: "Right Leg Upper",
        right_leg_knee: "Right Leg Knee",
        metallic_trim: "Metallic Trim",
        right_trim: "Right Trim",
        left_trim: "Left Trim",
        left_chest: "Left Chest",
        right_chest: "Right Chest",
        left_thorax: "Left Thorax",
        right_thorax: "Right Thorax",
        weapon_primary: "Weapon Primary",
        weapon_secondary: "Weapon Secondary",
        left_pauldron: "Left Pauldron",
        right_pauldron: "Right Pauldron",
        left_head: "Left Head",
        right_head: "Right Head",
        left_muzzle: "Left Muzzle",
        right_muzzle: "Right Muzzle",
        eye_lense: "Eye Lense",
        left_arm: "Left Arm",
        left_hand: "Left Hand",
        right_arm: "Right Arm",
        right_hand: "Right Hand",
        right_backpack: "Right Backpack",
        left_backpack: "Left Backpack",
        company_marks: "Company Marks"
    }

    static lower_left = ["left_leg_lower","left_leg_upper","left_leg_knee"];

    static lower_right = ["right_leg_lower","right_leg_upper","right_leg_knee"];

    static upper_left =  ["left_chest","left_arm","left_hand","left_backpack"]; 

    static chest =  ["left_chest", "right_chest"];

    static upper_right = ["right_chest","right_arm","right_hand","right_backpack"];   

    static legs = ["left_leg_lower","left_leg_upper","left_leg_knee","right_leg_lower","right_leg_upper","right_leg_knee"];

    static head_set = ["left_head", "right_head","left_muzzle", "right_muzzle"];

    static backpack = ["right_backpack","left_backpack"]

    static trim_all = ["right_trim","left_trim", "metallic_trim"];

    static full_body = array_join(lower_left,lower_right,upper_left,chest,upper_right,head_set);

    static set_pattern = function(col, pattern){
        for (var i=0 ;i<array_length(pattern);i++){
            map_colour[$ pattern[i]] = col;
        }
    }

    static set_default_armour = function(struct_cols, armour_style=0){
        map_colour.right_pauldron = struct_cols.right_pauldron;   
        map_colour.left_pauldron = struct_cols.left_pauldron;   

        map_colour.eye_lense = struct_cols.lens_color;  

        map_colour.weapon_primary = struct_cols.weapon_color;
        map_colour.weapon_secondary = struct_cols.weapon_color;
        set_pattern(struct_cols.main_trim, trim_all);

        if (armour_style==0){
            set_pattern(struct_cols.main_color,full_body);
        } else if (armour_style==1){//Breastplate
            set_pattern(struct_cols.secondary_color, chest);
            set_pattern(struct_cols.main_color, head_set);
            set_pattern(struct_cols.main_color, legs);
        }else if (armour_style==2){//Vertical
            set_pattern(struct_cols.secondary_color, upper_left);
            set_pattern(struct_cols.main_color, lower_right);
            set_pattern(struct_cols.main_color, upper_right);
            set_pattern(struct_cols.secondary_color, lower_left);
            set_pattern(struct_cols.main_color, head_set);
        }else if (armour_style==3){//Quadrant
            set_pattern(struct_cols.secondary_color, upper_left);
            set_pattern(struct_cols.secondary_color, lower_right);
            set_pattern(struct_cols.main_color, upper_right);
            set_pattern(struct_cols.main_color, lower_left);
            set_pattern(struct_cols.main_color, head_set);
        }
        return DeepCloneStruct(map_colour);
    }

    static set_default_techmarines = function(struct_cols){
        set_pattern(Colors.Red,full_body);
        map_colour.eye_lense = Colors.Green;
        map_colour.right_pauldron = Colors.Red;   
        map_colour.left_pauldron = struct_cols.left_pauldron;
        map_colour.is_changed=true;
        return DeepCloneStruct(map_colour);                       
    }

    static set_default_apothecary = function(struct_cols){
        set_pattern(Colors.White,full_body);
        map_colour.eye_lense = Colors.Red;
        map_colour.right_pauldron = Colors.White;   
        map_colour.left_pauldron = struct_cols.left_pauldron;
        map_colour.is_changed=true;
        return DeepCloneStruct(map_colour);                 
    }

    static set_default_chaplain = function(struct_cols){
        set_pattern(Colors.Black,full_body);
        map_colour.eye_lense = Colors.Red;
        map_colour.right_pauldron = Colors.Black;   
        map_colour.left_pauldron = struct_cols.left_pauldron;
        map_colour.is_changed=true;
        return DeepCloneStruct(map_colour);                 
    }


    static set_default_librarian = function(struct_cols){
        set_pattern(Colors.Dark_Ultramarine,full_body);
        map_colour.eye_lense = Colors.Cyan;
        map_colour.right_pauldron = Colors.Dark_Ultramarine;   
        map_colour.left_pauldron = struct_cols.left_pauldron;
        map_colour.is_changed=true;
        return DeepCloneStruct(map_colour);                 
    }

    colour_pick=false;
    dummy_marine = false;
    dummy_image = false;
    static reset_image = function(){
		if (is_struct(dummy_image)){
			 delete dummy_image;
             dummy_image = false;
		}

    }
    freeze_armour = false;
    static shuffle_dummy = function(){
        dummy_marine.update();
    }
    hover_pos = false;
    colour_return = false;
    static draw_base = function(){
        data_slate.inside_method = function(){
            if (hover_pos != false){
                if (colour_return != false){
                    if (colour_return[0] != hover_pos){
                        map_colour[$ colour_return[0]] = colour_return[1];
                        colour_return = [hover_pos, map_colour[$ hover_pos]];
                        map_colour[$ hover_pos] = 0;
                        reset_image();                       
                    }
                } else {
                    colour_return = [hover_pos, map_colour[$ hover_pos]];
                    map_colour[$ hover_pos] = 0;
                    reset_image();                     
                }
            }
        	if (is_struct(colour_pick)){
        		var action = colour_pick.draw();
        		if (action == "destroy"){
        			colour_pick=false;
        		} else {
        			if (colour_pick.chosen!=-1 && colour_pick.chosen!=map_colour[$ colour_pick.area]){
        				map_colour[$ colour_pick.area] = colour_pick.chosen;
                        map_colour.is_changed = true;
                        obj_creation.full_liveries[role_set] = DeepCloneStruct(map_colour);
                        delete dummy_image;
                        dummy_image = false;
        			}
        		}
        	}
            image_location_maps.right_trim = move_location_relative(
                draw_unit_buttons([xx-90, yy+31], "R Trim"),
                -xx,
                -yy
            );
            image_location_maps.eye_lense = move_location_relative(
                draw_unit_buttons([xx-90, yy+image_location_maps.right_trim[3]], "Lenses"),
                -xx,
                -yy
            );
            image_location_maps.weapon_primary = move_location_relative(
                draw_unit_buttons([xx-90, yy+image_location_maps.eye_lense[3]], "Weapon\nPrimary"),
                -xx,
                -yy
            );
            image_location_maps.weapon_secondary = move_location_relative(
                draw_unit_buttons([xx-90, yy+image_location_maps.weapon_primary[3]], "Weapon\nSecondary"),
                -xx,
                -yy
            );
            image_location_maps.left_trim = move_location_relative(
                draw_unit_buttons([xx+150, yy+31], "L Trim"),
                -xx,
                -yy
            );
            var freeze_image_shuffle = draw_unit_buttons([xx+150, yy+image_location_maps.left_trim[3]], "Freeze",,freeze_armour ? c_green :c_red);

            if (point_and_click(freeze_image_shuffle)){
                freeze_armour = !freeze_armour;
            }
            if (scr_hit(freeze_image_shuffle)){
                tooltip_draw("Freeze and un-freeze marine armour changes");
            }

            var _shuffle_marine_decorations = draw_unit_buttons([xx+150, freeze_image_shuffle[3]], "Shuffle", ,c_green);

            if (point_and_click(_shuffle_marine_decorations)){
                freeze_armour = !freeze_armour;
                shuffle_dummy();
                reset_image();
            }
            if (scr_hit(_shuffle_marine_decorations)){
                tooltip_draw("click to shuffle marine decorations and randomisations");
            }
            image_location_maps.company_marks = move_location_relative(
                draw_unit_buttons([xx-30, yy-40], "Company Marks"),
                -xx,
                -yy
            );
        
    		//draw_sprite(sprite_index, 0, x, y);
            if (dummy_marine == false){
                dummy_marine = new DummyMarine();
            }
            if (!is_struct(dummy_image)){
                dummy_image = dummy_marine.draw_unit_image();
            }
            dummy_image.draw(xx, yy-20);
            hover_pos = false;
        	var map_names = struct_get_names(image_location_maps);
        	for (var i=0;i<array_length(map_names);i++){
        		if (!is_array(image_location_maps[$map_names[i]])) then continue;
        		var rel_position = coord_relevative_positions(image_location_maps[$map_names[i]],xx, yy);
        		if (scr_hit(rel_position)){
                    if (struct_exists(name_maps, map_names[i])){
                        tooltip_draw(name_maps[$ map_names[i]]);
                    } else{
                        tooltip_draw(map_names[i]);
                    }
                    hover_pos = map_names[i];
        		}
        		if (point_and_click(rel_position)){
        			colour_pick = new colour_picker(xx-20, yy);
        			colour_pick.area = map_names[i];
        			colour_pick.title = map_names[i];
        		}
        	}
            if (colour_return != false){
                if (hover_pos != colour_return[0]){
                    map_colour[$ colour_return[0]] = colour_return[1];
                    colour_return = false;
                    reset_image();

                }
            }
        }
        data_slate.draw(0,5,0.45, 1);
    }
}


function setup_complex_livery_shader(setup_role, game_setup=false, unit = "none"){
    shader_reset();
    shader_set(full_livery_shader);
   if (instance_exists(obj_creation)) {
        var data_set = obj_creation.livery_picker.map_colour
   } else {
        var _full_liveries = obj_ini.full_liveries;
        var _roles = obj_ini.role[100];
        var data_set = obj_ini.full_liveries[0];
        if (is_specialist(setup_role, "libs")){
            data_set = _full_liveries[eROLE.Librarian];
        } else if (is_specialist(setup_role, "heads")){
            if (is_specialist(setup_role, "apoth")){
                data_set = _full_liveries[eROLE.Apothecary];
            } else if (is_specialist(setup_role, "forge")){
                data_set = _full_liveries[eROLE.Techmarine];
            }else if (is_specialist(setup_role, "chap")){
                data_set = _full_liveries[eROLE.Chaplain];
            }
        } else {
            for (var i=0;i<=20;i++){
                if (_roles[i]==setup_role){
                    data_set = _full_liveries[i];
                    break;
                }
            }        
        }        
    }

    var spot_names = struct_get_names(data_set);
    var cloth_col = [201.0/255.0, 178.0/255.0, 147.0/255.0];
    if (unit != "none"){
        var cloth_variation=unit.body.torso.cloth.variation;
        

        if (cloth_variation>10){
            var _distinct_colours = [];
            for (var i=0;i<array_length(spot_names);i++){
                if (spot_names[i] == "eye_lense" || spot_names[i] ==  "is_changed"){
                    continue;
                }
                var _colour = data_set[$ spot_names[i]];
                if (!array_contains(_distinct_colours, _colour)){
                    array_push(_distinct_colours, _colour);
                }
            }
            var _choice = cloth_variation%array_length(_distinct_colours);
            set_complex_shader_area(["robes_colour_replace"], _distinct_colours[_choice]);   
        }else {
            shader_set_uniform_f_array(shader_get_uniform(full_livery_shader, "robes_colour_replace"), cloth_col);
        }
    } else {
        shader_set_uniform_f_array(shader_get_uniform(full_livery_shader, "robes_colour_replace"), cloth_col);
    }
    // show_debug_message(data_set);
    
    for (var i=0;i<array_length(spot_names);i++){
        var colour = data_set[$ spot_names[i]];
        var colours_instance = instance_exists(obj_creation) ? obj_creation : obj_controller;
        var colour_set = [colours_instance.col_r[colour]/255, colours_instance.col_g[colour]/255, colours_instance.col_b[colour]/255];
        shader_set_uniform_f_array(shader_get_uniform(full_livery_shader, spot_names[i]), colour_set);
    }    
}

function set_complex_shader_area(area, colour){
    if (is_array(area)){
        for (var i=0;i<array_length(area);i++){
            var small_area = area[i];
            var colours_instance = instance_exists(obj_creation) ? obj_creation : obj_controller;
            var colour_set = [colours_instance.col_r[colour]/255, colours_instance.col_g[colour]/255, colours_instance.col_b[colour]/255];
            shader_set_uniform_f_array(shader_get_uniform(full_livery_shader, small_area), colour_set);
        }  
    }
}

function colour_picker(xx,yy) constructor{
	x=xx;
	x=yy;
	chosen = -1;
	count_destroy=false;
	static draw = function(){
		if (count_destroy) then return "destroy";
        draw_set_font(fnt_40k_30b);
        draw_text_transformed(144,550,title,0.6,0.6,0);
        rows = 4;
        columns = 10;
        var column;
        var current_color = 0;
        var row = 0;
        repeat(rows) {
            row += 1;
            column = 0;
            repeat(columns) {
                column += 1;
                if (current_color < global.colors_count) {
                    draw_set_color(make_color_rgb(obj_creation.col_r[current_color], obj_creation.col_g[current_color], obj_creation.col_b[current_color]));
                    var x1, x2, y1, y2;
                    x1 = -36 + (column * 40);
                    y1 = 541 + (row * 40);
                    x2 = 6 + (column * 40);
                    y2 = 581 + (row * 40);
                    draw_rectangle(x1, y1, x2, y2, 0);
                    draw_set_color(38144);
                    draw_rectangle(x1, y1, x2, y2, 1);
                    if (scr_hit(x1, y1, x2, y2) = true) {
                        draw_set_color(c_white);
                        draw_set_alpha(0.2);
                        draw_rectangle(x1, y1, x2, y2, 0);
                        draw_set_alpha(1);
                        chosen = current_color;
			            if (mouse_check_button_pressed(mb_left)) {
			               count_destroy=true;
			            }                    
                    }
                    current_color += 1;
                }
            }
        }
        
        draw_set_halign(fa_center);
        draw_set_font(fnt_40k_14b);
        var xx = 294;
        var yy = 742;
        var button_width = string_width("Close")/2;
        draw_set_color(38144);
        draw_rectangle(xx - button_width, yy, xx + button_width, yy+20, 0);
        draw_set_color(0);
        draw_text(xx, 743, "Close");
        if (scr_hit(xx - button_width, yy, xx + button_width, yy+20)) {
            draw_set_color(c_white);
            draw_set_alpha(0.2);
            draw_rectangle(634 - button_width, yy, xx + button_width, yy+20, 0);
            draw_set_alpha(1);
            if (mouse_check_button_pressed(mb_left)) {
               return "destroy";
            }
        }

        if (!scr_hit(130,536,545,748) && mouse_check_button_pressed(mb_left)) {
        }
        draw_set_alpha(1);		
	}
}
