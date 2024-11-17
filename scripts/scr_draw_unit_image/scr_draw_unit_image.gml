enum ShaderType {
    Body,
    Helmet,
    LeftPauldron,
    Lens,
    Trim,
    RightPauldron,
    Weapon
}

enum UnitSpecialization {
    None,
    Chaplain,
    Apothecary,
    Techmarine,
    Librarian,
    DeathCompany,
    IronFather,
    WolfPriest,
}

enum UnitSpecialColours {
    None,
    Deathwing,
    Ravenwing,
    Gold,
}


function ColorItem() constructor{
    function scr_unit_draw_data(){
        map_colour = {
            left_leg_lower : 0,
            left_leg_upper : 0,
            left_leg_knee : 0,
            left_right_lower : 0,
            left_right_upper : 0,
            left_right_knee : 0,
            metallic_trim : 0,
            right_trim : 0,
            left_trim : 0,
            left_chest : 0,
            right_chest : 0,
            left_thorax : 0,
            right_thorax : 0, 
            left_pauldron : 0,
            right_pauldron: 0,
            left_head : 0,
            right_head: 0,                       
        }
    }
    static set_legs_solid = function(col){
        var legs = ["left_leg_lower","left_leg_upper","left_leg_knee","left_right_lower","left_right_upper","left_right_knee"];
        for (var i=0 ;i<array_length(legs);i++){
            map_colour[legs[i]] = col;
        }
    }
}

function UnitImage(unit_surface) constructor{
    u_surface = unit_surface;
    static draw = function (xx, yy, _background=false){
        if (_background){
            draw_rectangle_color_simple(xx-1,yy-1,xx+1+166,yy+271+1,0,c_black);
            draw_rectangle_color_simple(xx-1,yy-1,xx+166+1,yy+271+1,1,c_gray);
            draw_rectangle_color_simple(xx-2,yy-2,xx+166+2,yy+2+271,1,c_black);
            draw_rectangle_color_simple(xx-3,yy-3,xx+166+3,yy+3+271,1,c_gray);
        }      
        if (surface_exists(u_surface)){
            draw_surface(u_surface, xx-200,yy-90);
        }
    }

    static draw_part = function (xx, yy,left,top,width,height, _background=false){
        if (_background){
            draw_rectangle_color_simple(xx-1+left,yy-1+top,xx+1+width,yy+height+1,0,c_black);
            draw_rectangle_color_simple(xx-1+left,yy-1+top,xx+width+1,yy+height+1,1,c_gray);
            draw_rectangle_color_simple(xx-2+left,yy-2+top,xx+width+2,yy+2+height,1,c_black);
            draw_rectangle_color_simple(xx-3+left,yy-3+top,xx+width+3,yy+3+height,1,c_gray);
        }     
        if (surface_exists(u_surface)){
            draw_surface_part(u_surface, left+200, top+90, width,height, xx,yy);
        }       
    }

    static destroy_image = function(){
        if (surface_exists(u_surface)){
            surface_free(u_surface);
        }
    }
}

//TODO this is a laxy fix and can be written better
function set_shader_color(shaderType, colorIndex) {
    var findShader, setShader;
    if (instance_exists(obj_controller)){
        with (obj_controller){
            switch (shaderType) {
                case ShaderType.Body:
                    setShader = colour_to_set1;
                    break;
                case ShaderType.Helmet:
                    setShader = colour_to_set2;
                    break;
                case ShaderType.LeftPauldron:
                    setShader = colour_to_set3;
                    break;
                case ShaderType.Lens:
                    setShader = colour_to_set4;
                    break;
                case ShaderType.Trim:
                    setShader = colour_to_set5;
                    break;
                case ShaderType.RightPauldron:
                    setShader = colour_to_set6;
                    break;
                case ShaderType.Weapon:
                    setShader = colour_to_set7;
                    break;
            }
            shader_set_uniform_f(setShader, col_r[colorIndex]/255, col_g[colorIndex]/255, col_b[colorIndex]/255);
        }
    } else if (instance_exists(obj_creation)){
        with (obj_controller){
            switch (shaderType) {
                case ShaderType.Body:
                    setShader = colour_to_set1;
                    break;
                case ShaderType.Helmet:
                    setShader = colour_to_set2;
                    break;
                case ShaderType.LeftPauldron:
                    setShader = colour_to_set3;
                    break;
                case ShaderType.Lens:
                    setShader = colour_to_set4;
                    break;
                case ShaderType.Trim:
                    setShader = colour_to_set5;
                    break;
                case ShaderType.RightPauldron:
                    setShader = colour_to_set6;
                    break;
                case ShaderType.Weapon:
                    setShader = colour_to_set7;
                    break;
            }
            shader_set_uniform_f(setShader, col_r[colorIndex]/255, col_g[colorIndex]/255, col_b[colorIndex]/255);
        }        
    }
}

// Define armour types
enum ArmourType {
    Normal,
    Scout,
    Terminator,
    Dreadnought,
    None
}

// Define backpack types
enum BackType {
    None,
    Dev,
    Jump,
}

function make_colour_from_array(col_array){
    return make_color_rgb(col_array[0] *255, col_array[1] * 255, col_array[2] * 255);
}

function set_shader_to_base_values(){
    with (obj_controller){
            shader_set_uniform_f_array(colour_to_find1, body_colour_find );
            shader_set_uniform_f_array(colour_to_set1, body_colour_replace );
            shader_set_uniform_f_array(colour_to_find2, secondary_colour_find );       
            shader_set_uniform_f_array(colour_to_set2, secondary_colour_replace );
            shader_set_uniform_f_array(colour_to_find3, pauldron_colour_find );       
            shader_set_uniform_f_array(colour_to_set3, pauldron_colour_replace );
            shader_set_uniform_f_array(colour_to_find4, lens_colour_find );       
            shader_set_uniform_f_array(colour_to_set4, lens_colour_replace );
            shader_set_uniform_f_array(colour_to_find5, trim_colour_find );
            shader_set_uniform_f_array(colour_to_set5, trim_colour_replace );
            shader_set_uniform_f_array(colour_to_find6, pauldron2_colour_find );
            shader_set_uniform_f_array(colour_to_set6, pauldron2_colour_replace );
            shader_set_uniform_f_array(colour_to_find7, weapon_colour_find );
            shader_set_uniform_f_array(colour_to_set7, weapon_colour_replace );
        }
        shader_set_uniform_i(shader_get_uniform(sReplaceColor, "u_blend_modes"), 0);   
}

function set_shader_array(shader_array){
    for (var i=0;i<array_length(shader_array);i++){
        if (shader_array[i]>-1){
            set_shader_color(i, shader_array[i]);
        }
    }
}
function scr_draw_unit_image(_background=false){
    function draw_unit_hands(x_surface_offset, y_surface_offset, armour_type, specialist_colours, hide_bionics, right_left){
        if (armour_type == ArmourType.Normal || armour_type == ArmourType.Terminator){
            var offset_x = x_surface_offset;
            var offset_y = y_surface_offset;
            switch(armour_type){
                case ArmourType.Terminator:
                    var _hand_spr = spr_terminator_hands;
                    break;
                default:
                case ArmourType.Normal:
                    var _hand_spr = spr_pa_hands;
                    break;
            }
            if (hand_variant[right_left] > 0){
                var _spr_index = (hand_variant[right_left] - 1) * 2;
                var _spr_w = sprite_get_width(_hand_spr) - sprite_get_xoffset(_hand_spr) * 2;
                if (right_left == 2) {
                    _spr_index += (specialist_colours >= 2) ? 1 : 0;
                    draw_sprite_ext(_hand_spr, _spr_index, offset_x + _spr_w, offset_y, -1, 1, 0, c_white, 1);
                } else {
                    draw_sprite(_hand_spr, _spr_index, offset_x, offset_y);
                }
            }
            // Draw bionic hands
            if (hand_variant[right_left] == 1){
                if (armour_type == ArmourType.Normal && !hide_bionics && struct_exists(body[$ (right_left == 1 ? "right_arm" : "left_arm")], "bionic")) {
                    var bionic_hand = body[$ (right_left == 1 ? "right_arm" : "left_arm")][$ "bionic"];
                    var _spr_w = sprite_get_width(spr_bionics_hand) - sprite_get_xoffset(spr_bionics_hand) * 2;
                    var bionic_spr_index = bionic_hand.variant * 2;
                    if (right_left == 2) {
                        bionic_spr_index += (specialist_colours >= 2) ? 1 : 0;
                        draw_sprite_ext(spr_bionics_hand, bionic_spr_index, offset_x + _spr_w, offset_y, -1, 1, 0, c_white, 1);
                    } else {
                        draw_sprite(spr_bionics_hand, bionic_spr_index, offset_x, offset_y);
                    }
                }
            }
        }
    }
    
    function draw_unit_arms(x_surface_offset, y_surface_offset, armour_type, specialist_colours, hide_bionics){
        if (array_contains([ArmourType.Normal,ArmourType.Terminator, ArmourType.Scout], armour_type)){
            var offset_x = x_surface_offset;
            var offset_y = y_surface_offset;
            switch(armour_type){
                case ArmourType.Terminator:
                    var _arm_spr = spr_terminator_arms;
                    break;
                case ArmourType.Scout:
                    var _arm_spr = spr_scout_arms;
                    break;
                case ArmourType.Normal:
                default:
                    var _arm_spr = spr_pa_arms;
                    break;
            }
            if (armour() == "Artificer Armour"){ //todo: refactor this
                _arm_spr = spr_pa_arms_ornate;
            }
            for (var right_left = 1; right_left <= 2; right_left++) {
                // Draw bionic arms
                if (arm_variant[right_left] == 1 && armour_type == ArmourType.Normal && !hide_bionics && struct_exists(body[$ (right_left == 1 ? "right_arm" : "left_arm")], "bionic")){
                    var bionic_arm = body[$ (right_left == 1 ? "right_arm" : "left_arm")][$ "bionic"];
                    var _spr_w = sprite_get_width(spr_bionics_arm) - sprite_get_xoffset(spr_bionics_arm) * 2;
                    var bionic_spr_index = bionic_arm.variant * 2;
                    if (right_left == 2) {
                        bionic_spr_index += (specialist_colours >= 2) ? 1 : 0;
                        draw_sprite_ext(spr_bionics_arm, bionic_spr_index, offset_x + _spr_w, offset_y, -1, 1, 0, c_white, 1);
                    } else {
                        draw_sprite(spr_bionics_arm, bionic_spr_index, offset_x, offset_y);
                    }
                } else if (arm_variant[right_left] > 0){
                    var _spr_index = (arm_variant[right_left] - 1) * 2;
                    var _spr_w = sprite_get_width(_arm_spr) - sprite_get_xoffset(_arm_spr) * 2;
                    if (right_left == 2) {
                        _spr_index += (specialist_colours >= 2) ? 1 : 0;
                        draw_sprite_ext(_arm_spr, _spr_index, offset_x + _spr_w, offset_y, -1, 1, 0, c_white, 1);
                    } else {
                        draw_sprite(_arm_spr, _spr_index, offset_x, offset_y);
                    }
                }
            }
        }
    }

    var x_surface_offset = 200;
    var y_surface_offset = 110;
    var unit_surface = surface_create(600, 600);
    surface_set_target(unit_surface);
    draw_clear_alpha(c_black, 0);//RESET surface
    draw_set_font(fnt_40k_14b);
    draw_set_color(c_gray);
	var xx=__view_get( e__VW.XView, 0 )+0, yy=__view_get( e__VW.YView, 0 )+0, bb="", img=0;
    var blandify = obj_controller.blandify;
    var draw_sequence = [];
    if (name_role()!="") and (base_group=="astartes"){
        ui_weapon[1]=spr_weapon_blank;
        ui_weapon[2]=spr_weapon_blank;
        arm_variant[1]=1;
        arm_variant[2]=1;
        hand_variant[1]=1;
        hand_variant[2]=1;
        hand_on_top[1]=false;
        hand_on_top[2]=false;
        ui_spec[1]=false;
        ui_spec[2]=false;
        ui_twoh[1]=false;
        ui_twoh[2]=false;
        ui_xmod[1]=0;
        ui_xmod[2]=0;
        ui_ymod[1]=0;
        ui_ymod[2]=0;
        ui_back=true;
        ui_force_both=false;
        pauldron_trim=0;
        var armour_bypass = false;
        var hide_bionics = false;
        var robes_bypass = false;
        var robes_hood_bypass = false;
        var halo_bypass = false;
        var arm_bypass = false;
        var armour_draw =[];
		var specialist_colours=obj_ini.col_special; 
        var specific_armour_sprite = "none";
        var unit_chapter = global.chapter_name;
        var unit_is_sniper = false;
        var unit_role = role();
        var unit_wep1=weapon_one();
        var unit_wep2=weapon_two();
        var unit_armour=armour();
        var unit_gear=gear();
        var unit_back=mobility_item()
        var unit_specialization=UnitSpecialization.None;
        var unit_special_colours=0;
        var skin_color=obj_ini.skin_color;
        var armour_type = ArmourType.Normal;
        var armour_sprite = spr_weapon_blank;
        var back_type = BackType.None,
            psy_hood = 0,
            skull_mask = 0,
            servo_arm = 0,
            servo_harness = 0,
            halo = 0,
            reverent_guardians = 0,
            slow_trait = 0,
            tech_brothers_trait = -5,
            body_part;

        // if (unit_role=="Chapter Master"){unit_specialization=111;}
        // // Honour Guard
        // else if (unit_role==obj_ini.role[100,2]){unit_specialization=14;}
        // Chaplain
        if (is_specialist(unit_role,"chap",true)){
            if (unit_chapter== "Iron Hands"){
                unit_specialization=UnitSpecialization.IronFather;
            } else if (unit_chapter == "Space Wolves") {
                unit_specialization=UnitSpecialization.WolfPriest;
            } else {
                unit_specialization=UnitSpecialization.Chaplain;
            }
        }
        // Techmarine
        else if (is_specialist(unit_role,"forge",true)){
            if (unit_chapter== "Iron Hands"){
                unit_specialization=UnitSpecialization.IronFather;
            } else {
                unit_specialization=UnitSpecialization.Techmarine;
            }
        }
        // Apothecary
        else if (is_specialist(unit_role,"apoth",true)){
            if (unit_chapter == "Space Wolves") {
                unit_specialization=UnitSpecialization.WolfPriest;
            } else {
                unit_specialization=UnitSpecialization.Apothecary;
            }
        }
        // Librarian
        else if (is_specialist(unit_role,"libs",true)){unit_specialization=UnitSpecialization.Librarian;}
        // Death Company
        else if (unit_role=="Death Company"){unit_specialization=UnitSpecialization.DeathCompany;}
        // Dark Angels
        if (unit_chapter=="Dark Angels"){
            // Deathwing
            if (company == 1) {
                unit_special_colours=UnitSpecialColours.Deathwing;
            }
            // Ravenwing
            else if (company == 2) {
                unit_special_colours=UnitSpecialColours.Ravenwing;
            }
        }
        // Blood Angels gold
        if ((unit_role==obj_ini.role[100][Role.HONOUR_GUARD] || unit_role=="Chapter Master")) and (unit_chapter=="Blood Angels"){
            unit_special_colours=UnitSpecialColours.Gold;
        }
        // Sets up the description for the equipement of current marine            

        if (array_contains([UnitSpecialization.Chaplain, UnitSpecialization.WolfPriest, UnitSpecialization.Librarian], unit_specialization) || unit_role=="Chapter Master"){
            if (array_contains(obj_ini.adv, "Reverent Guardians")){
                reverent_guardians=1
            }
        }
        if (unit_gear="Psychic Hood"){
            psy_hood=-50;
        }

        if (array_contains([UnitSpecialization.Chaplain, UnitSpecialization.WolfPriest], unit_specialization)) then skull_mask=-50;
    
        // if (_armour_type!=ArType.Norm) then ui_back=false;

        if (unit_back=="Jump Pack"){
			ui_back=false;
			back_type=BackType.Jump;
		}else if (unit_back=="Heavy Weapons Pack"){
            ui_back=false;
			back_type=BackType.Dev;
        } else if (unit_back="Servo-arm"){
            servo_arm=1;
        } else if (unit_back="Servo-harness"){
            servo_harness=1;
        }

        if (unit_gear == "Iron Halo"){
            halo = 1;
        }

        switch(unit_armour){
            case "Scout Armour":
                armour_type = ArmourType.Scout;
                break;
            case "Terminator Armour":
            case "Tartaros":
                armour_type = ArmourType.Terminator;
                break;
            case "Dreadnought":
                armour_type = ArmourType.Dreadnought;
                break;
            case "(None)":
            case "":
            case "None":
                armour_type = ArmourType.None;
                break;
            }
		
        if (armour_type!=ArmourType.Normal) then ui_back=false;
        
        if (armour_type!=ArmourType.Dreadnought && armour_type!=ArmourType.None){
            if (weapon_one()!=""){
                scr_ui_display_weapons(1,unit_armour,weapon_one(), armour_type);
            }
            
            if (weapon_two()!="") and (ui_twoh[1]==false){
                scr_ui_display_weapons(2,unit_armour,weapon_two(), armour_type);
            }
        }

        if(shader_is_compiled(sReplaceColor)){
            shader_set(sReplaceColor);

            set_shader_to_base_values();

            //TODO make some sort of reusable structure to handle this sort of colour logic
            // also not ideal way of creating colour variation but it's a first pass
            var cloth_variation=body.torso.cloth.variation;
            var cloth_col = [201.0/255.0, 178.0/255.0, 147.0/255.0];
            if (unit_chapter != "Dark Angels"){
                with (obj_controller){
                    if (cloth_variation < 2){
                        cloth_col = body_colour_replace;
                    } else if (cloth_variation < 4){
                        cloth_col = secondary_colour_replace;
                    } else if (cloth_variation < 6){
                        cloth_col = pauldron_colour_replace;
                    } else if (cloth_variation < 8){
                        cloth_col = trim_colour_replace;
                    }else if (cloth_variation < 10){
                        cloth_col = pauldron2_colour_replace;
                    }else if (cloth_variation < 12){
                        cloth_col = weapon_colour_replace;
                    }
                }
            }
            with (obj_controller){
                shader_set_uniform_f_array(shader_get_uniform(sReplaceColor, "robes_colour_replace"), cloth_col);
            }
            // Special specialist stuff here
            /*
            unit_specialization=0;
            if (unit_role=obj_ini.role[100,14]) then unit_specialization == UnitSpecialization.Chaplain;// Chaplain
            if (unit_role=obj_ini.role[100,15]) then unit_specialization == UnitSpecialization.Apothecary;// Apothecary
            if (unit_role=obj_ini.role[100,15]) and ((unit_chapter="Blood Angels" || obj_ini.progenitor==5)) then unit_specialization=4;// Sanguinary
            if (unit_role=obj_ini.role[100,16]) then unit_specialization == UnitSpecialization.Techmarine;// Techmarine
            if (unit_role=obj_ini.role[100,17]) then unit_specialization == UnitSpecialization.Librarian;// Librarian
            */
            var shader_array_set = array_create(8, -1);
        
            pauldron_trim=obj_controller.trim;
			specialist_colours=obj_ini.col_special;
			
			// Chaplain
            if (array_contains([UnitSpecialization.Chaplain, UnitSpecialization.WolfPriest], unit_specialization)){
                shader_array_set[ShaderType.Body] = Colors.Black;
                shader_array_set[ShaderType.Helmet] = Colors.Black;
                shader_array_set[ShaderType.Lens] = Colors.Red;
                shader_array_set[ShaderType.Trim] = Colors.Dark_Gold;
                shader_array_set[ShaderType.RightPauldron] = Colors.Black;
                pauldron_trim=1;
                specialist_colours=0;
                if (unit_chapter == "Dark Angels") {
                    shader_array_set[ShaderType.Trim] = Colors.Copper;
                    if (unit_role == "Master of Sanctity") {
                        shader_array_set[ShaderType.Helmet] = Colors.Caliban_Green;
                        pauldron_trim=0;
                    }
                }
            }
			
			// Apothecary
            else if (unit_specialization == UnitSpecialization.Apothecary) and (unit_chapter!="Space Wolves"){
                shader_array_set[ShaderType.Body] = Colors.White;
                shader_array_set[ShaderType.Helmet] = Colors.White;
                shader_array_set[ShaderType.Lens] = Colors.Red;
                shader_array_set[ShaderType.RightPauldron] = Colors.White;
                pauldron_trim=0;
                specialist_colours=0;
            }
			
			// Techmarine
            else if (unit_specialization == UnitSpecialization.Techmarine) and (unit_chapter!="Iron Hands"){
                shader_array_set[ShaderType.Body] = Colors.Red;
                shader_array_set[ShaderType.Helmet] = Colors.Red;
                shader_array_set[ShaderType.Lens] = Colors.Lime;
                shader_array_set[ShaderType.Trim] = Colors.Silver;
                shader_array_set[ShaderType.RightPauldron] = Colors.Red;
                pauldron_trim=1;
                specialist_colours=0;
            }

			// Librarian
            else if (unit_specialization == UnitSpecialization.Librarian){
                shader_array_set[ShaderType.Body] = Colors.Dark_Ultramarine;
                shader_array_set[ShaderType.Helmet] = Colors.Dark_Ultramarine;
                shader_array_set[ShaderType.Lens] = Colors.Cyan;
                shader_array_set[ShaderType.Trim] = Colors.Gold;
                shader_array_set[ShaderType.RightPauldron] = Colors.Dark_Ultramarine;
                pauldron_trim=1;
                specialist_colours=0;
            }
			
			// Honour Guard
            else if (unit_role==obj_ini.role[100][Role.HONOUR_GUARD]){
                pauldron_trim=0;
                specialist_colours=0;
                // Blood Angels
                if (unit_special_colours==UnitSpecialColours.Gold){
                    shader_array_set[ShaderType.Body] = Colors.Gold;
                    shader_array_set[ShaderType.Helmet] = Colors.Gold;
                    shader_array_set[ShaderType.LeftPauldron] = Colors.Gold;
                    shader_array_set[ShaderType.Trim] = Colors.Gold;
                // Ultramarines
                } else if (unit_chapter == "Ultramarines"){
                    shader_array_set[ShaderType.Helmet] = Colors.Sanguine_Red;
                }
            }

			// Blood Angels Death Company Marines
            else if (unit_specialization==UnitSpecialization.DeathCompany){
                shader_array_set[ShaderType.Body] = Colors.Black;
                shader_array_set[ShaderType.Helmet] = Colors.Black;
                shader_array_set[ShaderType.LeftPauldron] = Colors.Black;
                shader_array_set[ShaderType.Lens] = Colors.Red;
                shader_array_set[ShaderType.Trim] = Colors.Black;
                shader_array_set[ShaderType.RightPauldron] = Colors.Black;
                shader_array_set[ShaderType.Weapon] = Colors.Dark_Red;
                pauldron_trim=0;
                specialist_colours=0;
            }
			
			// Dark Angels Deathwing
            if (unit_special_colours == UnitSpecialColours.Deathwing){
                if !array_contains([obj_ini.role[100][Role.CHAPLAIN],obj_ini.role[100][Role.LIBRARIAN], obj_ini.role[100][Role.TECHMARINE]], unit_role){
                    shader_array_set[ShaderType.Body] = Colors.Deathwing;
                    shader_array_set[ShaderType.Trim] = Colors.Light_Caliban_Green;
                    if (unit_role != obj_ini.role[100][Role.APOTHECARY]){
                        shader_array_set[ShaderType.Helmet] = Colors.Deathwing;
                    }
                }
                if !array_contains([obj_ini.role[100][Role.CHAPLAIN],obj_ini.role[100][Role.TECHMARINE]], unit_role){
                    shader_array_set[ShaderType.RightPauldron] = Colors.Deathwing;
                }
                shader_array_set[ShaderType.LeftPauldron] = Colors.Deathwing;
                pauldron_trim=0;
                specialist_colours=0;
            }
            
			// Dark Angels Ravenwing
            if (unit_special_colours == UnitSpecialColours.Ravenwing){
                if !array_contains([obj_ini.role[100][Role.CHAPLAIN],obj_ini.role[100][Role.LIBRARIAN], obj_ini.role[100][Role.TECHMARINE],obj_ini.role[100][Role.APOTHECARY]], unit_role){
                    shader_array_set[ShaderType.Body] = Colors.Black;
                    shader_array_set[ShaderType.Helmet] = Colors.Black;
                }
                if !array_contains([obj_ini.role[100][Role.CHAPLAIN],obj_ini.role[100][Role.TECHMARINE]], unit_role){
                    shader_array_set[ShaderType.RightPauldron] = Colors.Black;
                }
                shader_array_set[ShaderType.LeftPauldron] = Colors.Black;
                pauldron_trim=0;
                specialist_colours=0;
            }

			// Dark Angels Captains
            if (unit_chapter == "Dark Angels" && unit_role == obj_ini.role[100][Role.CAPTAIN] && company != 1){
                shader_array_set[ShaderType.RightPauldron] = Colors.Dark_Red;
                shader_array_set[ShaderType.Helmet] = Colors.Deathwing;
                pauldron_trim=0;
                specialist_colours=0;
            }

            // Dark Angels Honour Guard
            if (unit_chapter == "Dark Angels" && unit_role == obj_ini.role[100][Role.HONOUR_GUARD]){
                shader_array_set[ShaderType.Body] = Colors.Deathwing;
                shader_array_set[ShaderType.RightPauldron] = Colors.Deathwing;
                shader_array_set[ShaderType.LeftPauldron] = Colors.Deathwing;
                shader_array_set[ShaderType.Trim] = Colors.Copper;
                pauldron_trim=0;
                specialist_colours=0;
            }

			// Blood Angels Sergeants
            if (unit_chapter == "Blood Angels" && unit_role == obj_ini.role[100][Role.SERGEANT]){
                shader_array_set[ShaderType.LeftPauldron] = Colors.Black;
                shader_array_set[ShaderType.RightPauldron] = Colors.Black;
                pauldron_trim=0;
                specialist_colours=0;
            }

            //We can return to the custom shader values at any time during draw doing this 
            set_shader_array(shader_array_set);
			// Marine draw sequence
            /*
            main
            secondary
            pauldron
            lens
            trim
            pauldron2
            weapon
            */
        
            //Rejoice!
            // draw_sprite(spr_marine_base,img,x_surface_offset,y_surface_offset);
            var clothing_style=3;
            if (progenitor_map()=="Dark Angels")  {clothing_style=0;}
            else if (progenitor_map()=="White Scars")  {clothing_style=1; }
            else if (progenitor_map()=="Space Wolves")  {clothing_style=2;}
            else if (progenitor_map()=="Imperial Fists")  {clothing_style=0;}
            else if (progenitor_map()=="Iron Hands" ) { clothing_style=0;}
            else if (progenitor_map()=="Salamanders" )  {clothing_style=4;}
            else if (progenitor_map()=="Raven Guard")  {clothing_style=0;}
            else if (progenitor_map()=="Doom Benefactors")  {clothing_style=4;}
        
            // Determine Sprite
            if (skull_mask=-50) then skull_mask=1;
        
            if (unit_armour!=""){
                var yep=0;
                if (array_contains(obj_ini.adv,"Slow and Purposeful")){
                    slow_trait=1
                }
                if (unit_specialization == UnitSpecialization.Techmarine){
                    if (array_contains(obj_ini.adv,"Tech-Brothers")){
                        tech_brothers_trait=0
                    }
				}
            }else{armour_sprite=spr_weapon_blank;}// Define armour
        
			
			
            if (armour_type == ArmourType.Scout){
				if (slow_trait>0) then slow_trait=10;
				armour_sprite=spr_scout_colors2;
                if (squad!="none"){
                    if (obj_ini.squads[squad].type=="scout_sniper_squad" || weapon_one()=="Sniper Rifle" || weapon_two()=="Sniper Rifle"){
                        unit_is_sniper = true;
                    }
                }
				if (psy_hood=-50) then psy_hood=0;
			}else if (unit_armour=="MK3 Iron Armour"){
				if (slow_trait>0) then slow_trait=13;
				if (tech_brothers_trait>-5) then tech_brothers_trait=3;
				armour_sprite=spr_mk3_colors;
				if (psy_hood=-50) then psy_hood=5;
			}else if (unit_armour=="MK4 Maximus"){
				if (slow_trait>0) then slow_trait=13;
				if (tech_brothers_trait>-5) then tech_brothers_trait=3;
				armour_sprite=spr_mk4_colors;
				if (psy_hood=-50) then psy_hood=6;
			}else if (unit_armour=="MK5 Heresy"){
				if (slow_trait>0) then slow_trait=13;
				if (tech_brothers_trait>-5) then tech_brothers_trait=3;
				armour_sprite=spr_mk5_colors;
				if (psy_hood=-50) then psy_hood=6;
			}else if (unit_armour=="MK6 Corvus"){
				if (slow_trait>0) then slow_trait=13;
				if (tech_brothers_trait>-5) then tech_brothers_trait=2;
				armour_sprite=spr_beakie_colors;
				if (psy_hood=-50) then psy_hood=3;
			}else if (unit_armour=="MK7 Aquila" || unit_armour=="Power Armour"){
				if (tech_brothers_trait>-5) then tech_brothers_trait=0;
				if (slow_trait>0) then slow_trait=13;
				armour_sprite=spr_mk7_colors;
				if (psy_hood=-50) then psy_hood=1;
			}else if (unit_armour=="MK8 Errant"){
				if (slow_trait>0) then slow_trait=13;
				if (tech_brothers_trait>-5) then tech_brothers_trait=0;
				armour_sprite=spr_mk8_colors;
				if (psy_hood=-50) then psy_hood=4;
			}else if (unit_armour=="Tartaros"){
				armour_sprite=spr_tartaros2_colors;
				if (tech_brothers_trait>-5) then tech_brothers_trait=4;
				if (psy_hood=-50) then psy_hood=8;
				if (skull_mask==1) then skull_mask=3;
			}
            if (unit_armour=="Terminator Armour"){
				armour_sprite=spr_terminator3_colors;
				if (tech_brothers_trait>-5) then tech_brothers_trait=5;
				if (psy_hood=-50) then psy_hood=9;
				if (skull_mask==1) then skull_mask=2;
			}else if (unit_armour=="Artificer Armour"){
				if (slow_trait>0) then slow_trait=13;
				if (tech_brothers_trait>-5) then tech_brothers_trait=1;
				armour_sprite=spr_artificer_colors;
				if (psy_hood=-50) then psy_hood=2;
			}
        
            if (armour_sprite=spr_weapon_blank) and (unit_armour!=""){
                if (string_count("Power Armour",unit_armour)>0){
					if (slow_trait>0) then slow_trait=13;
					if (tech_brothers_trait>-5) then tech_brothers_trait=0;
					armour_sprite=spr_mk7_colors;
					if (psy_hood=-50) then psy_hood=1;
				}
                if (string_count("Artifi",unit_armour)>0){
					if (slow_trait>0) then slow_trait=13;
					if (tech_brothers_trait>-5) then tech_brothers_trait=1;
					armour_sprite=spr_artificer_colors;
					if (psy_hood=-50) then psy_hood=2;
				}
                if (string_count("Termi",unit_armour)>0){
					if (tech_brothers_trait>-5) then tech_brothers_trait=5;
					armour_sprite=spr_terminator3_colors;
					if (psy_hood=-50) then psy_hood=9;
					if (skull_mask==1) then skull_mask=2;
				}
            }
        
            // Draw the lights
            if (unit_specialization == UnitSpecialization.Apothecary) and (unit_armour!="") and (back_type == BackType.None){
                if (unit_armour=="Terminator Armour") then draw_sprite(spr_gear_apoth,0,x_surface_offset,y_surface_offset-22); // for terminators
                else draw_sprite(spr_gear_apoth,0,x_surface_offset,y_surface_offset-6); // for normal power armour
            }
        
            // Draw Techmarine gear
            if (servo_arm > 0 || servo_harness > 0) && (!arm_bypass) {
                var arm_offset_y = 0;
                if (unit_armour == "Terminator Armour" || unit_armour == "Tartaros") {
                    arm_offset_y -= 18;
                }
            
                draw_sprite(servo_arm > 0? spr_servo_arm : spr_servo_harness, 0, x_surface_offset, y_surface_offset + arm_offset_y);
            }

            if (armour_type==ArmourType.None){            
                if (unit_role=="Chapter Master" && unit_chapter=="Doom Benefactors") then skin_color=6;
            
                draw_sprite(spr_marine_base,skin_color,x_surface_offset,y_surface_offset);
            
                if (skin_color!=6) then draw_sprite(spr_clothing_colors,clothing_style,x_surface_offset,y_surface_offset);
            } else {
                if (reverent_guardians=1) and (blandify=0){
                    if (armour_type==ArmourType.Normal) then draw_sprite(spr_pack_brazier,0,x_surface_offset,y_surface_offset);
                    if (armour_type!=ArmourType.Normal) then draw_sprite(spr_pack_brazier,1,0-2,0);
                }
                 // Draw the backpack
                if (armour_type!=ArmourType.Dreadnought){
                    if (ui_back){
                        var back_sprite [0, 0];
                        if (specialist_colours==0) then back_sprite = [armour_sprite, 10];
                        if (specialist_colours==1) then back_sprite = [armour_sprite, 11];
                        if (specialist_colours>=2) then back_sprite = [armour_sprite, 12];
                        if (body.torso.backpack_variation < 3) {
                            if (progenitor_map()=="Dark Angels"){
                                if array_contains(["MK5 Heresy", "MK6 Corvus","MK7 Aquila", "MK8 Errant", "Artificer Armour"], unit_armour){
                                    back_sprite = [spr_da_backpack, 0];
                                }
                            }
                        }
                        if (unit_chapter == "Dark Angels") {
                            if (unit_role == "Chapter Master") {
                                back_sprite = [spr_da_backpack, 1];
                            } else if (unit_role == "Master of Sanctity") {
                                back_sprite = [spr_da_chaplain, 1];
                            }
                        }
                        draw_sprite(back_sprite[0],back_sprite[1],x_surface_offset,y_surface_offset);
                    }else{
                        if (back_type==BackType.Jump){
                            if (specialist_colours==0) then draw_sprite(spr_pack_jump,0,x_surface_offset,y_surface_offset);
                            if (specialist_colours==1) then draw_sprite(spr_pack_jump,1,x_surface_offset,y_surface_offset);
                            if (specialist_colours>=2) then draw_sprite(spr_pack_jump,2,x_surface_offset,y_surface_offset);
                        }
                        if (back_type==BackType.Dev){
                            if (specialist_colours==0) then draw_sprite(spr_pack_devastator,0,x_surface_offset,y_surface_offset);
                            if (specialist_colours==1) then draw_sprite(spr_pack_devastator,1,x_surface_offset,y_surface_offset);
                            if (specialist_colours>=2) then draw_sprite(spr_pack_devastator,2,x_surface_offset,y_surface_offset);
                        }
                    }  
                }

                var specific_helm = false;
                var helm_draw=[0,0];
                if (armour_type == ArmourType.Scout){
                    if (unit_is_sniper = true){
                        draw_sprite(spr_marine_head,skin_color,x_surface_offset,y_surface_offset);
                        draw_sprite(spr_scout_colors,11,x_surface_offset,y_surface_offset);// Scout Sniper Cloak
                    }
                    draw_sprite(armour_sprite,specialist_colours,x_surface_offset,y_surface_offset);
                    draw_sprite(spr_facial_colors,clothing_style,x_surface_offset,y_surface_offset);
                    specific_armour_sprite=armour_sprite;
                    armour_bypass=true;
                }else if (unit_armour=="MK3 Iron Armour"){
                    specific_armour_sprite = spr_mk3_colors;
                    specific_helm = spr_generic_sgt_mk3;
                    if (progenitor_map()=="Dark Angels"){
                        specific_helm = false;
                        if (unit_role==obj_ini.role[100][Role.CAPTAIN]){
                            // specific_armour_sprite = spr_da_mk3;
                            armour_draw=[spr_da_mk3,0];
                            robes_bypass = true;
                            robes_hood_bypass = true;
                            armour_bypass=true;
                        }
                    }
                } else if (unit_armour=="MK4 Maximus"){
                    specific_helm = spr_generic_sgt_mk4;
                    specific_armour_sprite = spr_mk4_colors;
                    if (array_contains(["Champion",obj_ini.role[100][2],obj_ini.role[100][5]], unit_role)){
                        /*if (unit_chapter=="Ultramarines"){
                            armour_draw=[spr_ultra_honor_guard,body.torso.armour_choice];
                            armour_bypass=true;
                            draw_sprite(spr_ultra_honor_guard,2,x_surface_offset,y_surface_offset);
                        } else {
                            armour_draw=[spr_generic_honor_guard,body.torso.armour_choice];
                            armour_bypass=true;
                        }*/                      
                    }
                    if (progenitor_map()=="Dark Angels"){
                        specific_helm = false;
                        if (unit_role==obj_ini.role[100][Role.CAPTAIN]){
                            // specific_armour_sprite = spr_da_mk4;
                            armour_draw=[spr_da_mk4,0];
                            robes_bypass = true;
                            robes_hood_bypass = true;
                            armour_bypass=true;
                        }
                    }
                } else if (unit_armour=="MK5 Heresy"){
                    specific_armour_sprite = spr_mk5_colors;
                    //TODO sort this mess out streamline system somehow
                    specific_helm = spr_generic_sgt_mk5;
                    if (progenitor_map()=="Dark Angels"){
                        specific_helm = false;
                        if (unit_role==obj_ini.role[100][Role.CAPTAIN]){
                            // specific_armour_sprite = spr_da_mk5;
                            armour_draw=[spr_da_mk5,0];
                            robes_bypass = true;
                            robes_hood_bypass = true;
                            armour_bypass=true;
                        }                        
                    }                   
                } else if (unit_armour=="MK6 Corvus"){
                    specific_armour_sprite = spr_beakie_colors;
                    specific_helm = spr_generic_sgt_mk6;
                    if (progenitor_map()=="Dark Angels"){
                        specific_helm = false;
                        if (unit_role==obj_ini.role[100][Role.CAPTAIN]){
                            // specific_armour_sprite = spr_da_mk6;
                            armour_draw=[spr_da_mk6,0];
                            robes_bypass = true;
                            robes_hood_bypass = true;
                            armour_bypass=true;
                        }                      
                    }

                } else if (unit_armour=="MK7 Aquila" || unit_armour="Power Armour"){
                    specific_armour_sprite = spr_mk7_colors;
                    specific_helm = spr_generic_sgt_mk7;
                    if (progenitor_map()=="Dark Angels"){
                        specific_helm = false;
                        if (unit_role==obj_ini.role[100][Role.CAPTAIN]){
                            // specific_armour_sprite = spr_da_mk7;
                            armour_draw = [spr_da_mk7,0];
                            robes_bypass = true;
                            robes_hood_bypass = true;
                            armour_bypass = true;
                        }                          
                    }
                } else if (unit_armour=="MK8 Errant"){
                    specific_helm = spr_generic_sgt_mk8;
                    specific_armour_sprite = spr_mk8_colors;
                    if (progenitor_map()=="Dark Angels"){
                        specific_helm = false;
                        if (unit_role==obj_ini.role[100][Role.CAPTAIN]){
                            // specific_armour_sprite = spr_da_mk8;
                            armour_draw=[spr_da_mk8,0];
                            robes_bypass = true;
                            robes_hood_bypass = true;
                            armour_bypass=true;
                        }                          
                    }                    
                } else if (unit_armour=="Artificer Armour"){
                    specific_armour_sprite = spr_artificer_colors;
                    if (array_contains(["Champion",obj_ini.role[100][2],obj_ini.role[100][5]], unit_role)){
                        if (unit_chapter=="Ultramarines"){
                            armour_draw=[spr_ultra_honor_guard2,body.torso.armour_choice];
                            armour_bypass=true;
                            draw_sprite(spr_ultra_honor_guard2,2,x_surface_offset,y_surface_offset);
                        } else {
                            armour_draw=[spr_generic_honor_guard,body.torso.armour_choice];
                            armour_bypass=true;
                        }
                    } 
                    if (unit_chapter=="Blood Angels"){
                        if (unit_role=="Chapter Master"){
                            armour_bypass=true;
                            hide_bionics = true;
                            robes_bypass = true;
                            robes_hood_bypass = true;
                            armour_draw=[spr_dante,0];
                            draw_sprite(spr_dante,1,x_surface_offset,y_surface_offset);
                        } else if (unit_role==obj_ini.role[100][2]){
                            armour_bypass=true;
                            hide_bionics = true;
                            robes_bypass = true;
                            robes_hood_bypass = true;
                            armour_draw=[spr_sanguin_guard,0];
                            draw_sprite(spr_sanguin_guard,1,x_surface_offset,y_surface_offset);
                        }
                    } else if(unit_chapter=="Dark Angels"){
                        if (unit_role=="Chapter Master"){
                            armour_bypass=true;
                            hide_bionics = true;
                            robes_bypass = true;
                            robes_hood_bypass = true;
                            armour_draw=[spr_azreal,0];
                        }
                        if (unit_role=="Master of Sanctity"){
                            armour_bypass=true;
                            hide_bionics = true;
                            robes_bypass = true;
                            robes_hood_bypass = true;
                            skull_mask = 0;
                            armour_draw=[spr_da_chaplain,0];
                        }
                    }
                } else if (unit_armour="Tartaros"){
                    specific_armour_sprite = spr_tartaros2_colors;
                } else if (unit_armour="Terminator Armour"){
                    specific_armour_sprite = spr_terminator3_colors;
                    specific_helm = spr_generic_terminator_sgt;
                    if(unit_chapter == "Dark Angels"){
                        specific_helm = false;
                        if (unit_role == obj_ini.role[100][2]){
                            armour_bypass=true;
                            armour_draw=[spr_da_term_honor,0];
                            hide_bionics = true;
                        }
                    }
                }

                if (unit_specialization == UnitSpecialization.Techmarine){
                    if (armour_type==ArmourType.Normal && armour_bypass==false){
                        if (array_contains(traits, "tinkerer")){
                            armour_draw=[spr_techmarine_core,0];
                            armour_bypass = true;
                        }
                    }

                }

                // Draw the Iron Halo
                if (halo==1 && !halo_bypass){
                    var halo_offset_y = 0;
                    var halo_color=0;
                    var halo_type = 2;
                    if (array_contains(["Raven Guard", "Dark Angels"], unit_chapter)) {
                        halo_color = 1;
                    }
                    if (unit_armour=="Artificer Armour" && !armour_bypass){
                        halo_offset_y -= 14;
                    } else if (unit_armour=="Terminator Armour"){
                        halo_type = 2;
                        halo_offset_y -= 20;
                    } else if (unit_armour=="Tartaros"){
                        halo_type = 2;
                        halo_offset_y -= 20;
                    }
                    draw_sprite(spr_gear_halo,halo_type+halo_color,x_surface_offset,y_surface_offset+halo_offset_y);
                }

                // Draw arms
                draw_unit_arms(x_surface_offset, y_surface_offset, armour_type, specialist_colours, hide_bionics);

                // Draw torso
                if (!armour_bypass){
                    draw_sprite(armour_sprite,specialist_colours,x_surface_offset,y_surface_offset);
                    // Draw additional torso decals

                    if (array_contains(["MK3 Iron Armour", "MK6 Corvus", "MK7 Aquila", "MK8 Errant"], unit_armour)){
                        if (back_type == BackType.Jump || back_type == BackType.Dev){
                            draw_sprite(mk7_chest_variants,1,x_surface_offset,y_surface_offset);
                        } else if (unit_armour=="MK7 Aquila"){
                            if (struct_exists(body.torso, "variation")){
                                if (body.torso.variation%2 == 1){
                                    draw_sprite(mk7_chest_variants,0,x_surface_offset,y_surface_offset);
                                }
                            }
                        }
                    }
                    // Draw pauldron trim
                    if (specific_armour_sprite != "none"){
                        if (pauldron_trim==0 && specialist_colours<=1) then draw_sprite(specific_armour_sprite,4,x_surface_offset,y_surface_offset);
                        if (pauldron_trim==0 && specialist_colours>=2) then draw_sprite(specific_armour_sprite,5,x_surface_offset,y_surface_offset);
                    }
                } else if (array_length(armour_draw)){
                    draw_sprite(armour_draw[0], armour_draw[1],x_surface_offset,y_surface_offset);
                }

                // Draw decals, features and other stuff
                if (slow_trait>=10) and (blandify=0) then draw_sprite(armour_sprite,slow_trait,x_surface_offset,y_surface_offset);// Slow and Purposeful battle damage
                // if (tech_brothers_trait>=0) and (blandify=0) then draw_sprite(spr_gear_techb,tech_brothers_trait,x_surface_offset,y_surface_offset);// Tech-Brothers bling
                //sgt helms
                if (specific_helm!=false){
                    var return_helm = false;
                    if (is_array(specific_helm)){
                        //draw_sprite(specific_helm[0],0,helm_draw[0]+x_surface_offset,y_surface_offset+0);
                        return_helm =specific_helm[0];
                        specific_helm=specific_helm[1];

                    }
                    var helm_pat =-1;
                    var prime=0;
                    var sec=0;
                    var lenne2=0;
                    var recolour_helm =false;
                    if (unit_role==obj_ini.role[100][Role.SERGEANT]){
                        with (obj_ini.complex_livery_data.sgt){
                            prime=helm_primary;
                            sec=helm_secondary;
                            lenne2 =helm_lens;
                            helm_pat=helm_pattern;
                            recolour_helm=true;
                        }
                    }else if(unit_role==obj_ini.role[100][Role.VETERAN_SERGEANT]){
                        with (obj_ini.complex_livery_data.vet_sgt){
                            prime=helm_primary;
                            sec=helm_secondary;
                            lenne2 =helm_lens;
                            helm_pat=helm_pattern;
                            recolour_helm=true;
                        }
                    }else if(unit_role==obj_ini.role[100][Role.CAPTAIN]){
                        with (obj_ini.complex_livery_data.captain){
                            prime=helm_primary;
                            sec=helm_secondary;
                            lenne2 =helm_lens;
                            helm_pat=helm_pattern;
                            recolour_helm=true;
                        }
                    }else if(unit_role==obj_ini.role[100][Role.VETERAN] || (unit_role==obj_ini.role[100][Role.TERMINATOR] && company = 1)){
                        with (obj_ini.complex_livery_data.veteran){
                            prime=helm_primary;
                            sec=helm_secondary;
                            lenne2 = helm_lens;
                            helm_pat= helm_pattern;
                            recolour_helm=true;
                        }
                    } else {
                        return_helm = false;
                    }
                    if (recolour_helm){
                        with (obj_controller){
                            shader_set_uniform_f_array(colour_to_find1, [30/255,30/255,30/255]);
                            shader_set_uniform_f_array(colour_to_find2, [200/255,0/255,0/255]);
                        }
                        shader_set_uniform_i(shader_get_uniform(sReplaceColor, "u_blend_modes"), 0);                        
                        set_shader_color(ShaderType.Body,prime);
                        set_shader_color(ShaderType.Helmet,sec);
                        set_shader_color(ShaderType.Lens,lenne2);                        
                        draw_sprite(specific_helm,helm_pat,helm_draw[0]+x_surface_offset,y_surface_offset+0);
                        shader_set_uniform_i(shader_get_uniform(sReplaceColor, "helm_replace"), prime);
                        shader_set_uniform_i(shader_get_uniform(sReplaceColor, "helm_second_replace"), sec);
                        shader_set_uniform_i(shader_get_uniform(sReplaceColor, "helm_lense_replace"), lenne2);                        
                    }
                    set_shader_to_base_values();
                    set_shader_array(shader_array_set);

                    // this allows us to layer rank iconography over custom special helms
                    if (return_helm!=false){
                        surface_reset_target();
                        var special_helm_suface = surface_create(512,512);             
                        surface_set_target(special_helm_suface);
                        draw_sprite(return_helm,0,helm_draw[0]+x_surface_offset,y_surface_offset+0);  
                        surface_reset_target();                 
                        shader_set_uniform_i(shader_get_uniform(sReplaceColor, "u_blend_modes"), 3);
                        texture_set_stage(shader_get_sampler_index(sReplaceColor, "background_texture"), surface_get_texture(unit_surface));                   
                        surface_set_target(unit_surface);                
                        draw_surface(special_helm_suface,0,0);
                        surface_free(special_helm_suface);
                        shader_set(sReplaceColor);
                        shader_set_uniform_i(shader_get_uniform(sReplaceColor, "u_blend_modes"), 0);                         
                    }
                }            
                // Apothecary Details
                if (unit_specialization == UnitSpecialization.Apothecary){
                    if (unit_armour=="Tartaros"){
                        draw_sprite(spr_gear_apoth,1, x_surface_offset,y_surface_offset-6);// was y_draw-4 with old tartar
                    }else if (unit_armour=="Terminator Armour"){
                        draw_sprite(spr_gear_apoth,1,x_surface_offset,y_surface_offset-6);
                    }else{
                        draw_sprite(spr_gear_apoth,1,x_surface_offset,y_surface_offset);
                    }
                    if (gear() == "Narthecium"){
                        if (armour_type==ArmourType.Normal) {
                            draw_sprite(spr_narthecium_2,0,x_surface_offset+66,y_surface_offset+5);
                        } else if (armour_type!=ArmourType.Normal && armour_type!=ArmourType.Dreadnought){
                            draw_sprite(spr_narthecium_2,0,x_surface_offset+92,y_surface_offset+5);
                        }
                    }
                }

                // Techmarine Details
                if (array_contains([UnitSpecialization.Techmarine, UnitSpecialization.IronFather], unit_specialization)){
                    var lens_offset = 0;
                    if (unit_armour == "Terminator Armour" || unit_armour == "Tartaros"){
                        lens_offset = -6;
                    }
                    if (irandom(1) == 0) {
                        draw_sprite_ext(spr_gear_techa, 0, x_surface_offset + sprite_get_width(spr_gear_techa), y_surface_offset + lens_offset, -1, 1, 0, c_white, 1);
                    } else {
                        draw_sprite(spr_gear_techa,0,x_surface_offset,y_surface_offset + lens_offset);
                    }
                    if (irandom(4) == 0 && !array_contains(traits, "tinkerer")) {
                        if (unit_armour == "Terminator Armour"){
                            draw_sprite(spr_gear_techb,1,x_surface_offset,y_surface_offset);
                        } else {
                            draw_sprite(spr_gear_techb,0,x_surface_offset,y_surface_offset);
                        }
                    }
                }
            
                // Hood
                if (psy_hood>0){
                    var yep=0;
                    var psy_hood_offset_x = 0;
                    var psy_hood_offset_y = 0;
                    robes_hood_bypass = true;
                    if (array_contains(obj_ini.adv,"Daemon Binders") && blandify==0 && psy_hood<7){
						robes_bypass = true;
                        if (pauldron_trim=1){
							draw_sprite(spr_gear_hood2,0,x_surface_offset-2,y_surface_offset-11);
							draw_sprite(spr_binders_robes,0,x_surface_offset-2,y_surface_offset-11);
						}
                        if (pauldron_trim==0){
							draw_sprite(spr_gear_hood2,1,x_surface_offset-2,y_surface_offset-11);
							draw_sprite(spr_binders_robes,1,x_surface_offset-2,y_surface_offset-11);
						}
                    } else {
                        if (unit_armour=="Terminator Armour") {
                            psy_hood_offset_y = -8;
                        }
                        //if (obj_ini.main_color=obj_ini.secondary_color) then draw_sprite(spr_gear_hood1,hood,0,y_surface_offset);
                        //if (obj_ini.main_color!=obj_ini.secondary_color) then draw_sprite(spr_gear_hood3,hood,0,y_surface_offset);
                        draw_sprite(spr_psy_hood,2, x_surface_offset+psy_hood_offset_x, y_surface_offset+psy_hood_offset_y);
                    }
                }

                //Chaplain head and Terminator version
                if (skull_mask>0){
                    if (unit_armour!="Terminator"){
                      //if (_armour_type==ArType.Tart || _armour_type==ArType.Term) then draw_sprite(spr_terminator_chap,1,0-2,0-11);
                    }
                    shader_reset();
                    if (armour_type == ArmourType.Normal || unit_armour=="Terminator Armour") then draw_sprite(spr_chaplain_skull_helm,0,x_surface_offset,y_surface_offset);
                    if (unit_armour=="Tartaros") then draw_sprite(spr_chaplain_skull_helm,0,x_surface_offset,y_surface_offset);
                    shader_set(sReplaceColor);
                }
            }
            //purity seals/decorations
            //TODO imprvoe this logic to be more extendable
            if (armour_type==ArmourType.Normal){
                if (struct_exists(body[$ "torso"],"purity_seal")){
                    if (body[$ "torso"][$"purity_seal"][2]==1){
                        draw_sprite(spr_purity_seal,2,x_surface_offset-24,y_surface_offset+14);
                    }
                    if (body[$ "torso"][$"purity_seal"][0]==1){
                        draw_sprite(spr_purity_seal,0,x_surface_offset-44,y_surface_offset+18);
                    }
                    if (body[$ "torso"][$"purity_seal"][1]==1){
                        draw_sprite(spr_purity_seal,0,x_surface_offset-6,y_surface_offset+16);
                    }                                       
                }
                if (struct_exists(body[$ "left_arm"],"purity_seal")){
                    if (body[$ "left_arm"][$"purity_seal"][0]==1){
                        draw_sprite(spr_purity_seal,1,x_surface_offset+70,y_surface_offset);
                    }
                    if (body[$ "left_arm"][$"purity_seal"][1]==1){
                        draw_sprite(spr_purity_seal,0,x_surface_offset+26,y_surface_offset+7);
                    }
                    if (body[$ "left_arm"][$"purity_seal"][2]==1){
                        draw_sprite(spr_purity_seal,0,x_surface_offset+15,y_surface_offset+10);
                    }                                       
                }
                if (struct_exists(body[$ "right_arm"],"purity_seal")){
                    if (body[$ "right_arm"][$"purity_seal"][0]==1){
                        draw_sprite(spr_purity_seal,2,x_surface_offset-54,y_surface_offset-3);
                    }
                    if (body[$ "right_arm"][$"purity_seal"][0]==1){
                        draw_sprite(spr_purity_seal,0,x_surface_offset-72,y_surface_offset+8);
                    }
                    if (body[$ "right_arm"][$"purity_seal"][0]==1){
                        draw_sprite(spr_purity_seal,0,x_surface_offset-57,y_surface_offset+12);
                    }                    
                }            
            }		

			// Bionics
            if (!hide_bionics) {
                var eye_move_x = 0;
                var eye_move_y = 0;
                var eye_spacer = 0;
                if (unit_armour=="Terminator Armour") {
                    // Adjust eye bionics on chaplain terminator armour
                    if (skull_mask > 0) {
                        eye_move_y = 2;
                        eye_spacer = -2;
                    // Adjust eye bionics on terminator armour
                    } else {
                        eye_move_y = -7;
                    }
                }
                // Draw bionics
                surface_reset_target();
                var bionic_surface = surface_create(512,512);             
                surface_set_target(bionic_surface);

                for (var part = 0; part < array_length(global.body_parts); part++) {
                    if (struct_exists(body[$ global.body_parts[part]], "bionic")) {
                        if (armour_type == ArmourType.Normal || unit_armour=="Terminator Armour") {
                            var body_part = global.body_parts[part];
                            var bionic = body[$ body_part][$ "bionic"];
                            switch (body_part) {
                                case "left_eye":
                                    if (bionic.variant == 0) {
                                        draw_sprite(spr_bionics_eye, 1,x_surface_offset+ eye_move_x + eye_spacer, y_surface_offset + eye_move_y);
                                    } else if (bionic.variant == 1) {
                                        draw_sprite(spr_bionic_eye_2, 1,x_surface_offset+eye_move_x + eye_spacer, y_surface_offset + eye_move_y);
                                    } else if (bionic.variant == 2) {
                                        draw_sprite(spr_bionic_eye_2, 2,x_surface_offset+eye_move_x + eye_spacer, y_surface_offset + eye_move_y);
                                    }
                                    break;

                                case "right_eye":
                                    if (bionic.variant == 0) {
                                        draw_sprite(spr_bionics_eye, 0,x_surface_offset+eye_move_x, y_surface_offset + eye_move_y);
                                    } else if (bionic.variant == 1) {
                                        draw_sprite(spr_bionic_eye_2, 0,x_surface_offset+eye_move_x, y_surface_offset + eye_move_y);
                                    } else if (bionic.variant == 2) {
                                        draw_sprite(spr_bionic_eye_2, 4,x_surface_offset+eye_move_x, y_surface_offset + eye_move_y);
                                    }
                                    break;

                                case "left_leg":
                                    if (armour_type == ArmourType.Normal) {
                                        var sprite_num = 2;
                                        if (specialist_colours >= 2) {
                                            sprite_num = 3;
                                        }
                                        if (bionic.variant == 0) {
                                            draw_sprite(spr_bionics_leg_2, sprite_num, x_surface_offset, y_surface_offset)
                                        } else {
                                            draw_sprite(spr_bionics_leg_3, sprite_num, x_surface_offset, y_surface_offset)
                                        }
                                    }
                                    break;

                                case "right_leg":
                                    if (armour_type == ArmourType.Normal) {
                                        if (bionic.variant == 0) {
                                            draw_sprite(spr_bionics_leg_2, 0, x_surface_offset, y_surface_offset)
                                        } else {
                                            draw_sprite(spr_bionics_leg_3, 0, x_surface_offset, y_surface_offset)
                                        }
                                    }
                                    break;
                            }
                        }
                    }
                }
                surface_reset_target();
                shader_set_uniform_i(shader_get_uniform(sReplaceColor, "u_blend_modes"), 1);
                texture_set_stage(shader_get_sampler_index(sReplaceColor, "background_texture"), surface_get_texture(unit_surface));                   
                surface_set_target(unit_surface);                
                draw_surface(bionic_surface, 0,0);
                surface_free(bionic_surface);
                shader_set(sReplaceColor);
                shader_set_uniform_i(shader_get_uniform(sReplaceColor, "u_blend_modes"), 0);                
            }
            // Draw Custom Helmets
            if (armour_type==ArmourType.Normal && !armour_bypass){
                if (unit_role == obj_ini.role[100][Role.CHAMPION]) {
                    if (unit_armour!="MK3 Iron Armour"){
                        draw_sprite(spr_special_helm,0,x_surface_offset,y_surface_offset);
                    }
                    draw_sprite(spr_laurel,0,x_surface_offset,y_surface_offset);
                    draw_sprite(spr_helm_decorations,1,x_surface_offset,y_surface_offset);
                }
                if (unit_role == obj_ini.role[100][Role.CAPTAIN]) {
                    draw_sprite(spr_laurel,0,x_surface_offset,y_surface_offset);
                }
                if (unit_role == obj_ini.role[100][Role.SERGEANT] || unit_role == obj_ini.role[100][Role.VETERAN_SERGEANT]) {
                    draw_sprite(spr_helm_decorations,1,x_surface_offset,y_surface_offset);
                }
            }
            else if (unit_armour=="Terminator Armour" && !armour_bypass){
                if (unit_role == obj_ini.role[100][Role.CHAMPION]) {
                    draw_sprite(spr_laurel,0,x_surface_offset,y_surface_offset-8);
                    draw_sprite(spr_helm_decorations,0,x_surface_offset,y_surface_offset-10);
                }
                if (unit_role == obj_ini.role[100][Role.CAPTAIN]) {
                    draw_sprite(spr_laurel,0,x_surface_offset,y_surface_offset-8);
                }
                if (unit_role == obj_ini.role[100][Role.SERGEANT] || unit_role == obj_ini.role[100][Role.VETERAN_SERGEANT]) {
                    draw_sprite(spr_helm_decorations,0,x_surface_offset,y_surface_offset-10);
                }
            } else if (armour_type == ArmourType.Scout){
                var head_mod = body.head.variation%3;
                if (head_mod == 1){
                    draw_sprite(spr_scout_heads,0,x_surface_offset,y_surface_offset);
                } else if (head_mod==2){
                    draw_sprite(spr_scout_heads,1,x_surface_offset,y_surface_offset);
                }
            }


            if (psy_hood==0) and (armour_type==ArmourType.Normal) and (unit_armour!="") and (unit_role==obj_ini.role[100][2]) && (unit_chapter!="Ultramarines") && (unit_chapter!="Blood Angels"){
                var helm_ii,o,yep;
                helm_ii=0;
				yep=0;
                if (array_contains(obj_ini.adv,"Tech-Brothers")){
                    helm_ii=2;
                }else if (array_contains(obj_ini.adv,"Never Forgive") || obj_ini.progenitor==1){
                    helm_ii=3;
                } else if (array_contains(obj_ini.adv,"Reverent Guardians")) {
                    helm_ii=4;
                }
                draw_sprite(spr_honor_helm,helm_ii,x_surface_offset-2,y_surface_offset-11);     
			}

            // Drawing Robes
            if (unit_chapter == "Dark Angels" or obj_ini.progenitor == 0) && (unit_role != obj_ini.role[100][Role.SERGEANT]) && (unit_role != obj_ini.role[100][Role.VETERAN_SERGEANT]){
                robes_bypass = true;
                robes_hood_bypass = true;
            }
            if (armour_type == ArmourType.Normal && (!robes_bypass || !robes_hood_bypass)) {
                var robe_offset_x = 0;
                var robe_offset_y = 0;
                var hood_offset_x = 0;
                var hood_offset_y = 0;
                if (armour_type == ArmourType.Scout) {
                    robe_offset_x = 1;
                    robe_offset_y = 10;
                    hood_offset_x = 1;
                    hood_offset_y = 10;
                }
                if (struct_exists(body[$ "head"],"hood") && !robes_hood_bypass) {
                    draw_sprite(spr_marine_cloth_hood,0,x_surface_offset+hood_offset_x,y_surface_offset+hood_offset_y);     
                }
                if (struct_exists(body[$ "torso"],"robes") && !robes_bypass) {
                    if (body.torso.robes<2){
                        draw_sprite(spr_marine_robes,body.torso.robes,x_surface_offset+robe_offset_x,y_surface_offset+robe_offset_y);     
                    } else {
                        draw_sprite(spr_cloth_tabbard,body.torso.robes,x_surface_offset+robe_offset_x,y_surface_offset+robe_offset_y);     
                    }
                }              
            }

            if (armour_type == ArmourType.Scout){
                ui_ymod[1]+=7;
                ui_ymod[2]+=7;
            }

            var shield_offset_x = 0;
            var shield_offset_y = 0;
            if (unit_armour=="Terminator Armour"){
                shield_offset_x = -15;
                shield_offset_y = -10;
            } else if (unit_armour=="Tartaros") {
                shield_offset_x = -8;
            }
            if (gear() == "Combat Shield"){
                if (unit_role == obj_ini.role[100][Role.CHAMPION]){
                    draw_sprite (spr_gear_combat_shield, 1, x_surface_offset + shield_offset_x, y_surface_offset + shield_offset_y);
                } else {
                    draw_sprite (spr_gear_combat_shield, 0, x_surface_offset + shield_offset_x, y_surface_offset + shield_offset_y);
                }
            }

            // Draw hands bellow the weapon sprite;
            for (var i = 1; i <= 2; i++) {
                if (!hand_on_top[i]) then draw_unit_hands(x_surface_offset, y_surface_offset, armour_type, specialist_colours, hide_bionics, i);
            }

            // // Draw weapons
            if (ui_weapon[1]!=0) and (sprite_exists(ui_weapon[1])){
                if (ui_twoh[1]==false) and (ui_twoh[2]==false){
                    draw_sprite(ui_weapon[1],0,x_surface_offset+ui_xmod[1],y_surface_offset+ui_ymod[1]);                  
                }
                if (ui_twoh[1]==true){
                    if (specialist_colours<=1) then draw_sprite(ui_weapon[1],0,x_surface_offset+ui_xmod[1],y_surface_offset+ui_ymod[1]);
                    if (specialist_colours>=2) then draw_sprite(ui_weapon[1],3,x_surface_offset+ui_xmod[1],y_surface_offset+ui_ymod[1]);
                    if (ui_force_both==true){
                        if (specialist_colours<=1) then draw_sprite(ui_weapon[1],0,x_surface_offset+ui_xmod[1],y_surface_offset+ui_ymod[1]);
                        if (specialist_colours>=2) then draw_sprite(ui_weapon[1],1,x_surface_offset+ui_xmod[1],y_surface_offset+ui_ymod[1]);
                    }
                }
            }
            if (ui_weapon[2]!=0) and (sprite_exists(ui_weapon[2])) and ((ui_twoh[1]==false || ui_force_both==true)){
                if (ui_spec[2]==false){
                    draw_sprite(ui_weapon[2],1,x_surface_offset+ui_xmod[2],y_surface_offset+ui_ymod[2]);
                }
                if (ui_spec[2]==true){
                    if (specialist_colours<=1) then draw_sprite(ui_weapon[2],2,x_surface_offset+ui_xmod[2],y_surface_offset+ui_ymod[2]);
                    if (specialist_colours>=2) then draw_sprite(ui_weapon[2],3,x_surface_offset+ui_xmod[2],y_surface_offset+ui_ymod[2]);                    
                }
            }

            // Draw hands above the weapon sprite;
            for (var i = 1; i <= 2; i++) {
                if (hand_on_top[i]) then draw_unit_hands(x_surface_offset, y_surface_offset, armour_type, specialist_colours, hide_bionics, i);
            }

            // if (reverent_guardians=1) then draw_sprite(spr_pack_brazier,1,x_surface_offset,y_surface_offset);
            if (armour_type==ArmourType.Dreadnought){
                draw_sprite(spr_dreadnought_chasis_colors,specialist_colours,x_surface_offset,y_surface_offset);
                var left_arm = dreadnought_sprite_components(weapon_two());
                var colour_scheme  =  specialist_colours<=1 ? 0 : 1;
                draw_sprite(left_arm,colour_scheme,x_surface_offset,y_surface_offset);
                colour_scheme  += 2;
                var right_arm = dreadnought_sprite_components(weapon_one());
                draw_sprite(right_arm,colour_scheme,x_surface_offset,y_surface_offset);
            } 			          
        }else{
            draw_set_color(c_gray);
            draw_text(0,0,string_hash_to_newline("Color swap shader#did not compile"));
        }
        // if (race()!="1"){draw_set_color(38144);draw_rectangle(0,x_surface_offset,y_surface_offset+166,0+231,0);}        
    }

    draw_set_alpha(1);

    if (name_role()!=""){
        if (race()=="3"){
            if (string_count("Techpriest",name_role())>0) then draw_sprite(spr_techpriest,0,x_surface_offset,y_surface_offset);
        }else if (race()=="4"){
            if (string_count("Crusader",name_role())>0) then draw_sprite(spr_crusader,0,x_surface_offset,y_surface_offset);
        }else if (race()=="5"){
            if (string_count("Sister of Battle",name_role())>0) then draw_sprite(spr_sororitas,0,x_surface_offset,y_surface_offset);
            if (string_count("Sister Hospitaler",name_role())>0) then draw_sprite(spr_sororitas,1,x_surface_offset,y_surface_offset);
        }else if (race()=="6"){
            if (string_count("Ranger",name_role())>0) then draw_sprite(spr_eldar_hire,0,x_surface_offset,y_surface_offset);
            if (string_count("Howling Banshee",name_role())>0) then draw_sprite(spr_eldar_hire,1,x_surface_offset,y_surface_offset);
        }
    }
    surface_reset_target();
    /*shader_set_uniform_i(shader_get_uniform(sReplaceColor, "u_blend_modes"), 2);                
    texture_set_stage(shader_get_sampler_index(sReplaceColor, "armour_texture"), sprite_get_texture(spr_leopard_sprite, 0)); */
    //draw_surface(unit_surface, xx+_x1-x_surface_offset,yy+_y1-y_surface_offset);
    //surface_free(unit_surface);
    shader_reset();
    return new UnitImage(unit_surface);   
}

function BaseColor(R,G,B) constructor{
    r=R;
    g=G;
    b=B;
}