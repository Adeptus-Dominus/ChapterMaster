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
    static scr_unit_draw_data = function(defualt_val = 0){
        map_colour = {
            is_changed : false,
            left_leg_lower : defualt_val,
            left_leg_upper : defualt_val,
            left_leg_knee : defualt_val,
            right_leg_lower : defualt_val,
            right_leg_upper : defualt_val,
            right_leg_knee : defualt_val,
            metallic_trim : defualt_val,
            right_trim : defualt_val,
            left_trim : defualt_val,
            left_chest : defualt_val,
            right_chest : defualt_val,
            left_thorax : defualt_val,
            right_thorax : defualt_val, 
            left_pauldron : defualt_val,
            left_arm : defualt_val,
            left_hand : defualt_val,
            right_pauldron: defualt_val,
            right_arm : defualt_val,
            right_hand : defualt_val,
            left_head : defualt_val,
            right_head: defualt_val, 
            left_muzzle: defualt_val,
            right_muzzle: defualt_val,
            eye_lense :defualt_val,  
            right_backpack : defualt_val,   
            left_backpack : defualt_val,
            weapon_primary : defualt_val,
            weapon_secondary : defualt_val,
            company_marks : defualt_val,
            company_marks_loc : defualt_val,                         
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
        reset_image();
        return variable_clone(map_colour);
    }

    static set_default_techmarines = function(struct_cols){
        set_pattern(Colors.Red,full_body);
        map_colour.eye_lense = Colors.Green;
        map_colour.right_pauldron = Colors.Red;   
        map_colour.left_pauldron = struct_cols.left_pauldron;
        map_colour.is_changed=true;
        return variable_clone(map_colour);                       
    }

    static set_default_apothecary = function(struct_cols){
        set_pattern(Colors.White,full_body);
        map_colour.eye_lense = Colors.Red;
        map_colour.right_pauldron = Colors.White;   
        map_colour.left_pauldron = struct_cols.left_pauldron;
        map_colour.is_changed=true;
        return variable_clone(map_colour);                 
    }

    static set_default_chaplain = function(struct_cols){
        set_pattern(Colors.Black,full_body);
        map_colour.eye_lense = Colors.Red;
        map_colour.right_pauldron = Colors.Black;   
        map_colour.left_pauldron = struct_cols.left_pauldron;
        map_colour.is_changed=true;
        return variable_clone(map_colour);                 
    }


    static set_default_librarian = function(struct_cols){
        set_pattern(Colors.Dark_Ultramarine,full_body);
        map_colour.eye_lense = Colors.Cyan;
        map_colour.right_pauldron = Colors.Dark_Ultramarine;   
        map_colour.left_pauldron = struct_cols.left_pauldron;
        map_colour.is_changed=true;
        return variable_clone(map_colour);                 
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
                    var _reset = false;
                    if (!is_array(colour_pick.chosen)){
            			if (colour_pick.chosen!=-1 && colour_pick.chosen!=map_colour[$ colour_pick.area]){
            				_reset = true;
            			}
                    } else {
                        if (!is_array(map_colour[$ colour_pick.area])){
                            _reset = true;
                        } else if (!array_equals(map_colour[$ colour_pick.area], colour_pick.chosen)){
                            _reset = true;
                            if (colour_pick.chosen[0] == "icon"){
                                if (is_struct(map_colour[$ colour_pick.area][1])){
                                    var _comp_icon = map_colour[$ colour_pick.area][1].icon;
                                    if (_comp_icon == colour_pick.chosen[1].icon){
                                        _reset = false;
                                    }
                                }
                            } 
                        }
                    }
                    if (_reset){
                        map_colour[$ colour_pick.area] = colour_pick.chosen;
                        map_colour.is_changed = true;
                        if (!obj_creation.buttons.company_options_toggle.company_view){
                            obj_creation.full_liveries[role_set] = variable_clone(map_colour);
                        } else {
                            obj_creation.company_liveries[role_set] = variable_clone(map_colour);
                        }
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
                var _body_loc = map_names[i];
                var _body_loc_coords = image_location_maps[$_body_loc];
        		if (!is_array(_body_loc_coords)){
                    continue;
                }
        		var _rel_position = coord_relevative_positions(_body_loc_coords,xx, yy);
        		if (scr_hit(_rel_position)){
                    if (struct_exists(name_maps, _body_loc)){
                        tooltip_draw(name_maps[$ _body_loc]);
                    } else{
                        tooltip_draw(_body_loc);
                    }
                    hover_pos = _body_loc;
        		}
        		if (point_and_click(_rel_position)){
        			colour_pick = new colour_picker(20, yy+350, 350);
        			colour_pick.area = _body_loc;
        			colour_pick.title = _body_loc;
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

enum eMarineIcons {
    None,
    Company, 
    Chapter,
    Squad, 
    Role
}

function get_marine_icon_set(key){
    sprite_set = false;
    if (key==eMarineIcons.Chapter){
        sprite_set = global.chapter_symbols;
    } else if (key==eMarineIcons.Role){
        sprite_set = global.role_markings;
    }else if (key==eMarineIcons.Squad){
        sprite_set = global.squad_markings;
    }else if (key==eMarineIcons.Company){
        sprite_set = global.company_markings;
    }
    return sprite_set;
}

function setup_complex_livery_shader(setup_role, unit = "none"){
    shader_reset();
    shader_set(full_livery_shader);

    var _in_creation = instance_exists(obj_creation);

    var _is_unit = unit != "none";
   if (_in_creation) {
        var data_set = variable_clone(obj_creation.livery_picker.map_colour);
        if (obj_creation.buttons.company_options_toggle.company_view){
            var _base = obj_creation.full_liveries[0];
            var _component_names = struct_get_names(_base);
            for (var i=0;i<array_length(_component_names);i++){
                var _component = _component_names[i];
                if (!struct_exists(data_set,_component_names[i])){
                    data_set[$ _component] = _base[$ _component];
                }
                if (data_set[$ _component] == -1){
                    data_set[$ _component] = _base[$ _component];
                }
            }
        }
   } else {
        var _full_liveries = obj_ini.full_liveries;
        var _roles = obj_ini.role[100];
        var data_set = obj_ini.full_liveries[0];
        if (is_specialist(setup_role, SPECIALISTS_LIBRARIANS)){
            data_set = _full_liveries[eROLE.Librarian];
        } else if (is_specialist(setup_role, SPECIALISTS_HEADS)){
            if (is_specialist(setup_role, SPECIALISTS_APOTHECARIES)){
                data_set = _full_liveries[eROLE.Apothecary];
            } else if (is_specialist(setup_role, SPECIALISTS_TECHS)){
                data_set = _full_liveries[eROLE.Techmarine];
            }else if (is_specialist(setup_role, SPECIALISTS_CHAPLAINS)){
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
        if (_is_unit){
            data_set = variable_clone(data_set);
            var _company_livery = obj_ini.company_liveries[unit.company];
            var _comp_names = struct_get_names(_company_livery);
            for (var i=0;i<array_length(_comp_names);i++){
                var _name = _comp_names[i];
                if (_name == "is_changed") then continue;
                if (_company_livery[$_name] != -1){
                    data_set[$_name] = _company_livery[$_name];
                }
            } 
        }       
    }
    if (_is_unit){
        var _names = struct_get_names(unit.personal_livery);
        for (var i=0;i<array_length(_names);i++){
            var _area = _names[i];
            data_set[$ _area] = unit.personal_livery[$_area];
        }
    }

    var spot_names = struct_get_names(data_set);
    var cloth_col = [201.0/255.0, 178.0/255.0, 147.0/255.0];
    if (unit != "none"){
        var cloth_variation = unit.body.torso.cloth.variation;
        

        if (cloth_variation>10){
            var _distinct_colours = [];
            for (var i=0;i<array_length(spot_names);i++){
                if (spot_names[i] == "eye_lense" || spot_names[i] ==  "is_changed"){
                    continue;
                }
                var _colour = data_set[$ spot_names[i]];
                if (_colour == -1) then continue;
                if (!array_contains(_distinct_colours, _colour)){
                    array_push(_distinct_colours, _colour);
                }
            }
            if (array_length(_distinct_colours)){
                var _choice = cloth_variation%array_length(_distinct_colours);
            }
            //show_debug_message($"{_choice}")
            set_complex_shader_area(["robes_colour_replace"], _distinct_colours[_choice]);   
        }else {
            shader_set_uniform_f_array(shader_get_uniform(full_livery_shader, "robes_colour_replace"), cloth_col);
        }
    } else {
        shader_set_uniform_f_array(shader_get_uniform(full_livery_shader, "robes_colour_replace"), cloth_col);
    }
    //show_debug_message(data_set);
    var _textures = {

    }

     static complex_colour_swaps = {
        left_head : [0, 0, 128/255],
        right_backpack : [181/255, 0, 255/255],
        left_backpack : [104/255, 0, 168/255],
        right_head : [0, 0, 1],
        left_muzzle : [128/255, 64/255, 1],
        right_muzzle : [64/255, 128/255, 1],
        eye_lense : [0, 1, 0],
        right_chest : [1, 20/255, 147/255],
        left_chest : [128/255, 0, 128/255],
        right_trim : [0, 128/255, 128/255],
        left_trim : [1, 128/255, 0],
        metallic_trim : [135/255, 130/255, 188/255],
        right_pauldron : [1, 1, 1],
        left_pauldron : [1, 1, 0],
        right_leg_upper : [0, 128/255, 0],
        left_leg_upper : [255/255, 112/255, 170/255],
        left_leg_knee : [1, 0, 0],
        left_leg_lower : [128/255, 0, 0],
        right_leg_knee : [214/255, 194/255, 255/255],
        right_leg_lower : [165/255, 84/255, 24/255],
        right_arm : [138/255, 218/255, 140/255],
        right_hand : [46/255, 169/255, 151/255],
        left_arm : [1, 230/255, 140/255],
        left_hand : [1, 160/255, 112/255],
        company_marks : [128/255, 128/255, 0],
        weapon_primary : [0, 1, 1],
        weapon_secondary : [1, 0, 1]
    };       

    var colours_instance = instance_exists(obj_creation) ? obj_creation : obj_controller;
    for (var i=0;i<array_length(spot_names);i++){
        var colour = data_set[$ spot_names[i]];
        
        if (!is_array(colour)){
            set_complex_shader_area(spot_names[i], colour);
        } else {
            if (colour[0] == "texture"){
                if (struct_exists(global.textures, colour[1])){
                    var name = colour[1];
                    if (!struct_exists(_textures, name)){
                        _textures[$name] = {
                            texture : global.textures[$ colour[1]],
                            areas : [complex_colour_swaps[$ spot_names[i]]],
                        }
                    } else {
                        array_push(_textures[$name].areas, complex_colour_swaps[$ spot_names[i]]);
                    }                    
                }
            } else if (colour[0] == "icon"){
                var _data = colour[1]
                var sub_key = "";
                var main_key = "";
                var _tex_set = false;
                if (array_contains(["right_pauldron", "left_pauldron"], spot_names[i])){
                    sub_key = "pauldron";
                }  else if (array_contains(["right_leg_knee", "left_leg_knee"], spot_names[i])){ 
                    sub_key = "knees";
                }

                main_key = get_marine_icon_set(_data.type);
                if (sub_key != "" && is_struct(main_key)){
                    var _tex_set = main_key[$ sub_key];
                }
                if (is_struct(_tex_set)){
                    if (struct_exists(_tex_set, _data.icon)){
                        var name = colour[1];
                        if (!struct_exists(_textures, name)){
                            _textures[$name] = {
                                texture : _tex_set[$ _data.icon],
                                areas : [complex_colour_swaps[$ spot_names[i]]],
                            }
                        } else {
                            array_push(_textures[$name].areas, complex_colour_swaps[$ spot_names[i]]);
                        }                    
                    }
                }
                set_complex_shader_area(spot_names[i],_data.colour);               
            }
        }
    } 

    return _textures;   
}


function get_shader_colour_from_arrays(colour){
    var colours_instance = instance_exists(obj_creation) ? obj_creation : obj_controller;
    try {
        var colour_set = [colours_instance.col_r[colour]/255, colours_instance.col_g[colour]/255, colours_instance.col_b[colour]/255];
    } catch(_exception){
        //handle_exception(_exception);
        var colour_set = [0,0,0];
    }

    return colour_set;
}
function set_complex_shader_area(area, colour){
    if (is_array(area)){
        for (var i=0;i<array_length(area);i++){
            var small_area = area[i];
            colour_set = get_shader_colour_from_arrays(colour)
            shader_set_uniform_f_array(shader_get_uniform(full_livery_shader, small_area), colour_set);
        }  
    } else {
        colour_set = get_shader_colour_from_arrays(colour)
        shader_set_uniform_f_array(shader_get_uniform(full_livery_shader, area), colour_set);        
    }
}

global.textures = {
    "Hazzards" : spr_hazzard_texture,
    "Checks" : spr_checker_texture,
    "flora_camo" : spr_flora_camo_texture,
    "Checks2" : spr_hazzard_texture,
    "Checks3" : spr_checker_texture,
    "Checks4" : spr_hazzard_texture,
    "Checks5" : spr_checker_texture

};

function colour_picker(xx,yy, max_width=400) constructor{
	x=xx;
	y=yy;
	chosen = -1;
	count_destroy=false;
    box_size = 30;
    choose_textures = false;
    markings = false;
    self.max_width = max_width;
    base_colour = 0;
    markings_options  = new radio_set(       
       [ {
                   str1 : "None",
                   font : fnt_40k_14b,
                   tooltip : ""
               },
               {
                   str1 : "Company",
                   font : fnt_40k_14b,
                   tooltip : "If selected You will be able to pick an icon or icon set after selecting a base colour"
               },
               {
                   str1 : "Chapter",
                   font : fnt_40k_14b,
                   tooltip : "If selected You will be able to pick an icon or icon set after selecting a base colour"
               },
               {
                   str1 : "Squad",
                   font : fnt_40k_14b,
                   tooltip : "If selected You will be able to pick an icon or icon set after selecting a base colour"
               },         
               {
                   str1 : "Role",
                   font : fnt_40k_14b,
                   tooltip : "If selected You will be able to pick an icon or icon set after selecting a base colour"
               }
        ],
    ,"Markings");

    static textures_surface = surface_create(1, 1);

    static texture_coords = [];
    static _texture_offset = [0,0];

    static create_texture_surface = function(texture_set, sprite_draw_args){
        var texture_names = struct_get_names(texture_set);
        var total_width = sprite_draw_args.frame_width * array_length(texture_names);
        if (sprite_draw_args.frame_height <= 0 || total_width <= 0){
            exit;
        }

        _texture_offset = [0,0];
        texture_coords = [];

        surface_resize(textures_surface, total_width, sprite_draw_args.frame_height);
        surface_set_target(textures_surface);

        var draw_x = 0;
        var draw_y = 0;
        var _frame_width = sprite_draw_args.frame_width;
        var _frame_height = sprite_draw_args.frame_height;
        for (var i=0;i<array_length(texture_names);i++){
            var _tex = texture_set[$ texture_names[i]];
            draw_sprite_part_ext(_tex, 0, sprite_draw_args.x, sprite_draw_args.y, _frame_width, _frame_height,draw_x, draw_y, 1, 1, c_white, 1);

            array_push(texture_coords, [[draw_x, draw_y , draw_x+_frame_width, draw_y+_frame_height],texture_names[i]]);
            draw_x += sprite_draw_args.frame_width
        }
        // show_debug_message("call create_texture_surface");
        surface_reset_target();
    }

    static draw_textures_surface = function(selection_method){
        draw_set_alpha(1);
        var _tex_height = surface_get_height(textures_surface);
        draw_surface_part(textures_surface, _texture_offset[0], _texture_offset[1], min(max_width,surface_get_width(textures_surface)), _tex_height, x, y);
         if (scr_hit(x, y, x+max_width ,  y + _tex_height)){
            tooltip_draw("scroll with arrow keys");
         }
        for (var i=0;i<array_length(texture_coords);i++){
            var _tex_coord = texture_coords[i];

            if (keyboard_check(vk_left)){
                _texture_offset[0] -= 10;
            } else if (keyboard_check(vk_right)){
                _texture_offset[0] += 10;
            }
            _texture_offset[0] = clamp(_texture_offset[0], 0, max(surface_get_width(textures_surface) - max_width, 0));
            if (scr_hit_relative(_tex_coord[0], [x - _texture_offset[0],y - _texture_offset[1]])){
                draw_set_color(c_white);
                draw_set_alpha(0.2);
                var rel_coords = [];
                array_copy(rel_coords, 0, _tex_coord[0], 0, 4)
                draw_rectangle_array(move_location_relative(rel_coords,x  -_texture_offset[0],y  -_texture_offset[1]), 0);
                draw_set_alpha(1);                
                selection_method(_tex_coord);                   
            }
        }
    }

	static draw = function(){
		if (count_destroy) then return "destroy";
        draw_set_font(fnt_40k_30b);
        draw_text_transformed(144,550,title,0.6,0.6,0);

        var column = -1;
        var current_color = 0;
        var row = 0;
        var defualt_box_x = x;
        var box_x = defualt_box_x
        var box_y = y;


        if (!choose_textures) {
            if (!markings){
                for (var i=0;i<array_length(obj_creation.col_r);i++){
                    column++;
                    if ((column * box_size)+40 > max_width){
                        row++;
                        column = 0;
                    }
                    draw_set_color(make_color_rgb(obj_creation.col_r[i], obj_creation.col_g[i], obj_creation.col_b[i]));
                    box_coords = [box_x+(box_size*column), box_y+(box_size*row), box_x+(box_size*column)+box_size, box_y+(box_size*row)+box_size];
                    draw_rectangle_array(box_coords, 0);
                    draw_set_color(38144);
                    draw_rectangle_array(box_coords, 1);
                    if (scr_hit(box_coords)) {
                        draw_set_color(c_white);
                        draw_set_alpha(0.2);
                        draw_rectangle_array(box_coords, 0);
                        draw_set_alpha(1);
                        chosen = i;
                        if (scr_click_left()) {
                            if (markings_options.current_selection == 0){
                                count_destroy=true;
                            } else {
                                markings = true;
                                base_colour = i;
                                box_size*=3
                                var _sprite_args = {
                                    x : 12,
                                    y : 30,
                                    frame_width : box_size,
                                    frame_height : box_size,
                                }
                                var sub_key = "";
                                var sprite_set = "";
                                if (array_contains(["right_pauldron", "left_pauldron"], title)){
                                    _sprite_args.x = 12;
                                    _sprite_args.y = 30;
                                    sub_key = "pauldron";
                                } else if (array_contains(["right_leg_knee", "left_leg_knee"], title)){ 
                                    sub_key = "knees";
                                }
                                sprite_set = get_marine_icon_set(markings_options.current_selection);
                                if (is_struct(sprite_set)){
                                    if (struct_exists(sprite_set , sub_key)){
                                        create_texture_surface(sprite_set[$ sub_key], _sprite_args);
                                    }
                                }
                            }
                        }                    
                    }
                }
            } else if (markings){
                draw_textures_surface(function(tex_data){
                    chosen = ["icon", {
                        icon: tex_data[1],
                        colour : base_colour,
                        type : markings_options.current_selection
                    }];
                    if (scr_click_left()) {
                       count_destroy=true;
                    }  
                });
                
            }
        } else {
            draw_textures_surface(function(tex_data){
                chosen = ["texture", tex_data[1]];
                if (scr_click_left()){
                   count_destroy=true;
                }  
            });
        }
        
        draw_set_halign(fa_center);
        draw_set_font(fnt_40k_14b);
        if (point_and_click(draw_unit_buttons([x+max_width-(string_width("close"))-15,y+(box_size*(row+1))],"close"))){
            return "destroy";
        }
        var marking_opts = ["right_pauldron", "left_pauldron", "right_leg_knee", "left_leg_knee"];

        var _valid_marking_spot = array_contains(marking_opts, title);
        if (_valid_marking_spot){
            markings_options.x1 = x+10;
            markings_options.y1 = y + (box_size*(row+1));
        }

        if (!markings){
            var tex_coords = draw_unit_buttons([x+max_width/2,y+(box_size*(row+1))],"Texture");
            markings_options.y1 = tex_coords[3];
            if (point_and_click(tex_coords)){
                choose_textures = !choose_textures;
                if (choose_textures){
                    box_size*=3
                    var _sprite_args = {
                        x : 0,
                        y : 0,
                        frame_width : box_size,
                        frame_height : box_size,
                    } 
                    create_texture_surface(global.textures, _sprite_args);
                } else {
                    box_size/=3
                }
            }
        }

        if (_valid_marking_spot){
            markings_options.draw();
        }

        if (!scr_hit(130,536,545,748) && mouse_check_button_pressed(mb_left)) {
        }
        draw_set_alpha(1);		
	}
}
