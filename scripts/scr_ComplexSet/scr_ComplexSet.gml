function scr_has_style(style){
    var result = false;
    if (!is_array(style)){
        try {
            var result;
            if (instance_exists(obj_creation)) {
                result = array_contains(obj_creation.buttons.culture_styles.selections(), style);
            } else {
                result = array_contains(obj_ini.culture_styles, style);
            }
        } catch (_exception){
            handle_exception(_exception);
            result = false;
        }
    } else {
        for (var i=0;i<array_length(style);i++){
            var _specific = scr_has_style(style[i]);
            if (_specific){
                return _specific;
            }
        }
    }
    return result;

    // var adv_count = array_length(obj_ini.adv);
    // for(var i = 0; i < adv_count; i++){
    //  if(obj_ini.adv[i] == advantage){
    //      return true;
    //  }
    // }
    // return false;
}



function ComplexSet(unit) constructor{
    overides = {

    };
    self.unit = unit;
    static mk7_bits = {
            armour : spr_mk7_complex,
            backpack : spr_mk7_complex_backpack,
            left_arm : spr_mk7_left_arm,
            right_arm : spr_mk7_right_arm,
            left_trim : spr_mk7_left_trim,
            right_trim : spr_mk7_right_trim,
            mouth_variants : spr_mk7_mouth_variants,
            thorax_variants : spr_mk7_thorax_variants,
            chest_variants : spr_mk7_chest_variants,
            leg_variants  : spr_mk7_leg_variants,
            head : spr_mk7_head_variants,    
    };

    _are_exceptions = false;
    exceptions = [];
    static check_exception = function(exception_key){
        if (_are_exceptions){
            var array_position = array_find_value(exceptions,exception_key);
            if (array_position>-1){
                array_delete(exceptions, array_position, 1);
                if (array_length(exceptions)){
                    return true;
                } else {
                    return false;
                }          
            } else {
                return false;
            }
        } else {
            return false;
        }
    }    
    
    static assign_modulars = function(){
        var modulars = global.modular_drawing_items;
        var _mod = {};


        try{
            for (var i=0; i<array_length(modulars);i++){

                _are_exceptions = false;
                _mod = modulars[i];
                exceptions = [];

                if (struct_exists(_mod, "allow_either")){
                    _are_exceptions = true;
                    exceptions = [];
                    for (var m=0;m<array_length(_mod.allow_either);m++){
                        array_push(exceptions, _mod.allow_either[m]);
                    }
                }
                if (struct_exists(_mod, "max_saturation")){
                    if (struct_exists(variation_map, _mod.position)){
                        if (variation_map[$_mod.position]>=_mod.max_saturation){
                            if (!check_exception("max_saturation")){
                                continue;
                            }
                        }
                    }
                }
               if (struct_exists(_mod, "body_types")){
                    if (!array_contains(_mod.body_types, armour_type)){
                        if (!check_exception("body_types")){
                            continue;
                        }                    
                    }
               }                
                if (struct_exists(_mod, "role_type")){
                    var _viable = false;
                    for (var a=0;a<array_length(_mod.role_type);a++){
                        var _r_t = _mod.role_type[a];
                        _viable = unit.IsSpecialist(_r_t);
                        if (_viable){
                            break;
                        }
                    }
                    if (!_viable){
                        if (!check_exception("chapter_adv")){
                            continue;
                        }                         
                    }                    
                }
                if (struct_exists(_mod, "roles")){
                    if (!array_contains(_mod.roles, unit.role())){
                        if (!check_exception("roles")){
                            continue;
                        }
                    }
                }                
               if (struct_exists(_mod, "cultures")){
                    if (!scr_has_style(_mod.cultures)){
                        if (!check_exception("cultures")){
                            continue;
                        }                    
                    }
               }
               if (struct_exists(_mod, "company")){
                    if (!array_contains(_mod.company, unit.company)){
                        if (!check_exception("company")){
                            continue;
                        }                         
                    }
               }
               if (struct_exists(_mod, "armours")){
                    if (!array_contains(_mod.armours, unit.armour())){
                        if (!check_exception("armours")){
                            continue;
                        }                     
                    }
               }
               if (struct_exists(_mod, "armours_exclude")){
                    if (array_contains(_mod.armours_exclude, unit.armour())){
                        if (!check_exception("armours_exclude")){
                            continue;
                        }                     
                    }
               }
               if (struct_exists(_mod, "exp")){
                    if (struct_exists(_mod.exp, "min")){
                        if (unit.experience < _mod.exp.min){
                            if (!check_exception("min_exp")){
                                continue;
                            }
                        }
                    }
               }
               if (struct_exists(_mod, "chapter_adv")){
                    var _viable = false;
                    for (var a=0;a<array_length(_mod.chapter_adv);a++){
                        var _adv = _mod.chapter_adv[a];
                        _viable = scr_has_adv(_adv);
                        if (_viable){
                            break;
                        }
                    }
                    if (!_viable){
                        if (!check_exception("chapter_adv")){
                            continue;
                        }                         
                    }
               }
               if (struct_exists(_mod, "stats")){
                    if (!stat_valuator(_mod.stats,unit)){
                        if (!check_exception("stats")){
                            continue;
                        }                         
                    }
               }
               if (struct_exists(_mod, "equipped")){
                    if (!unit.has_equipped(_mod.equipped)){
                        if (!check_exception("equipped")){
                            continue;
                        }
                    }
               }

                if (struct_exists(_mod, "traits")){
                    var _viable = false;
                    for (var a=0;a<array_length(_mod.traits);a++){
                        var _trait = _mod.traits[a];
                        _viable = unit.has_trait(_trait);
                        if (_viable){
                            break;
                        }
                    }
                    if (!_viable){
                        if (!check_exception("traits")){
                            continue;
                        }
                    }
                } 
                var _overides = "none";
                if (struct_exists(_mod, "overides")){
                    _overides = _mod.overides;
                }                           
               if (!struct_exists(_mod, "assign_by_rank")){
                   add_to_area(_mod.position, _mod.sprite,_overides)
               } else {
                    add_relative_to_status(_mod.position, _mod.sprite, _mod.assign_by_rank,_overides);
               }
            }
        }
    }

    variation_map = {
        backpack : unit.get_body_data("backpack_variation","torso"),
        armour : unit.get_body_data("armour_choice","torso"),
        chest_variants : unit.get_body_data("chest_variation","torso"),
        thorax_variants : unit.get_body_data("thorax_variation","torso"),
        leg_variants : unit.get_body_data("leg_variants","left_leg"),
        left_leg : unit.get_body_data("leg_variants","left_leg"),
        right_leg : unit.get_body_data("leg_variants","right_leg"),
        left_trim : unit.get_body_data("trim_variation","left_arm"),
        right_trim : unit.get_body_data("trim_variation","right_arm"),
        left_arm : unit.get_body_data("variation","left_arm"),
        right_arm : unit.get_body_data("variation","right_arm"),        
        gorget : unit.get_body_data("variant","throat"),
        right_pauldron: unit.get_body_data("pad_variation","right_arm"),
        left_pauldron: unit.get_body_data("pad_variation","left_arm"),
        left_personal_livery : unit.get_body_data("personal_livery","left_arm"),
        left_knee : unit.company,
        tabbard : unit.get_body_data("tabbard_variation","torso"),
        robe : unit.get_body_data("tabbard_variation","torso"),
        crest : unit.get_body_data("crest_variation","head"),
        head : unit.get_body_data("variation","head"),
        mouth_variants:unit.get_body_data("variant","jaw"),
        left_eye : unit.get_body_data("variant","left_eye"),
        right_eye : unit.get_body_data("variant","right_eye"),
        crown : unit.get_body_data("crown_variation","head"),
        forehead : unit.get_body_data("forehead_variation","head"),
        backpack_decoration : unit.get_body_data("backpack_decoration_variation","torso"),
        belt : unit.get_body_data("belt_variation","torso"),
        cloak :unit.get_body_data("variation","cloak"),
        cloak_image : unit.get_body_data("image_0","cloak"),
        cloak_trim : unit.get_body_data("image_1","cloak"),
        backpack_augment : unit.get_body_data("backpack_augment_variation","torso"),
        chest_fastening : unit.get_body_data("chest_fastening","torso"),
    }

    static draw_component = function(component_name){
        if (struct_exists(self, component_name)){
            var _sprite = self[$component_name];
            if (sprite_exists(_sprite)){
                var choice = 0;
                if (struct_exists(variation_map, component_name)){
                    var choice = variation_map[$component_name]%sprite_get_number(_sprite);
                }
                if (struct_exists(overides, component_name)){
                    var _overide_set = overides[$component_name];
                    for (var i=0;i<array_length(_overide_set);i++){
                        var _spec_over = _overide_set[i];
                        if (_spec_over[0]<=choice && _spec_over[1]>choice){
                            var _override_areas = struct_get_names(_spec_over[2]);
                            for (var j = 0;j <array_length(_override_areas);j++){
                                replace_area(_override_areas[j], _spec_over[2][$_override_areas[j]]);
                            }
                        }
                    }
                };
                draw_sprite(_sprite,choice ?? 0,x_surface_offset,y_surface_offset);
            }
        }
    }
    static draw_unit_arms = function() {
        var _bionic_options = [];
        if (array_contains([ArmourType.Normal, ArmourType.Terminator, ArmourType.Scout], armour_type)) {
       
            for (var _right_left = 1; _right_left <= 2; _right_left++) {
                var _variant = unit.arm_variant[_right_left];
                if (_variant == 0) then continue;

                var _arm_string = _right_left == 1 ? "right_arm" : "left_arm";
                var _bionic_arm = unit.get_body_data("bionic", _arm_string);
                _bio = [];
                if (ArmourType.Terminator == armour_type){
                    if (_variant == 2){
                        _bio = ["", spr_terminator_complex_arms_upper_right, spr_terminator_complex_arms_upper_left];
                    } else if (_variant == 3){
                        _bio = ["", spr_terminator_complex_arm_hidden_right, spr_terminator_complex_arm_hidden_left];
                    }
                }                
                if (_bionic_arm && !array_length(_bio)){
                    if (armour_type == ArmourType.Normal){
                        var _bio = ["", spr_bionic_right_arm, spr_bionic_left_arm];
                    } else if (armour_type == ArmourType.Terminator){
                        _bio = ["", spr_indomitus_right_arm_bionic, spr_indomitus_left_arm_bionic];
                    }
                }
                if (array_length(_bio)){
                    replace_area(_arm_string, _bio[_right_left]);
                }                
                draw_component(_arm_string);
            }
        }
        shader_set(full_livery_shader);
    };    
    static draw = function(){
        setup_complex_livery_shader(unit.role(),unit);
        draw_cloaks();
         //draw_unit_arms(x_surface_offset, y_surface_offset, armour_type, specialist_colours, hide_bionics, complex_set);
         draw_unit_arms();
        var _complex_helm = false;
        var unit_role = unit.role();
        var _role = obj_ini.role[100];
        var _comp_helms = obj_ini.complex_livery_data;
        if (unit_role ==_role[eROLE.Sergeant]){
            _complex_helm = _comp_helms.sgt;
        }else if(unit_role==_role[eROLE.VeteranSergeant]){
            _complex_helm = _comp_helms.vet_sgt;
        }else if(unit_role==_role[eROLE.Captain]){
            _complex_helm = _comp_helms.captain;
        }else if(unit_role==_role[eROLE.Veteran] || (unit_role==_role[eROLE.Terminator] && unit.company == 1)){
            _complex_helm = _comp_helms.veteran;
        }
        if (is_struct(_complex_helm) && struct_exists(self, "head")){
            complex_helms(_complex_helm);
        }         
         shader_set(full_livery_shader);

         if (unit.armour() == "MK4 Maximus" || unit.armour() == "MK3 Iron Armour"){
             _draw_order = [
                "backpack",
                "backpack_augment",
                "backpack_decoration",
                 "armour",
                 "thorax_variants",
                 "leg_variants",
                 "left_leg",
                 "right_leg",
                 "tabbard",
                 "robe",                 
                 "belt",                 
                 "chest_variants",
                 "chest_fastening",
                 "head",
                 "left_trim",
                 "right_trim",
                 "gorget",
                 "right_pauldron",
                 "left_pauldron",
                 "left_knee",
                 "left_personal_livery",             
             ];            
         } else {
             _draw_order = [
                "backpack",
                "backpack_augment",
                "backpack_decoration",
                 "armour",
                 "thorax_variants",
                 "chest_variants",
                 "chest_fastening",
                 "leg_variants",
                 "left_leg",
                 "right_leg",
                 "head",
                 "left_trim",
                 "right_trim",
                 "gorget",
                 "right_pauldron",
                 "left_pauldron",
                 "left_knee",
                 "tabbard",
                 "robe",
                 "belt",
                 "left_personal_livery",             
             ];            
         }
         for (var i=0;i<array_length(_draw_order);i++){
            if (_draw_order[i] == "head"){
                draw_head(self);
            } else {
                draw_component(_draw_order[i]);
            }
            
         }
         purity_seals_and_hangings();
                              
    }
static purity_seals_and_hangings = function(){
        //purity seals/decorations
        //TODO imprvoe this logic to be more extendable

        if (armour_type==ArmourType.Normal || armour_type==ArmourType.Terminator){
            var _body = unit.body;
            var _torso_data = _body[$ "torso"];
            var _exp = unit.experience
            var _x_offset = x_surface_offset + (armour_type==ArmourType.Normal ? 0 : -7);
            var _y_offset = y_surface_offset + (armour_type==ArmourType.Normal ? 0 : -38);
            if (struct_exists(_torso_data,"purity_seal")){
                var _torso_purity_seals = _torso_data[$"purity_seal"];
                if (armour_type==ArmourType.Normal){
                    var positions = [[60, 88], [90, 84], [104, 64]];
                } else {
                    var positions = [[117, 115], [51, 139], [131, 136]];
                }
                for (var i=0;i<array_length(_torso_purity_seals);i++){
                    if (i >= array_length(positions)) then continue;
                    if ((_torso_purity_seals[i]+_exp)>100){
                        draw_sprite(purity_seals,_torso_purity_seals[i] ,_x_offset+positions[i][0], _y_offset+positions[i][1]);
                    }
                }                                      
            }
            if (struct_exists(_body[$ "left_arm"],"purity_seal")){
                var _arm_seals = _body[$ "left_arm"][$"purity_seal"];
                if (armour_type==ArmourType.Normal){
                    var positions = [[135, 69], [121, 73]];
                }
                else {
                    var positions = [[163, 92], [148, 94], [126, 84]];
                }                
                for (var i=0;i<array_length(_arm_seals);i++){
                    if (i >= array_length(positions)) then continue;
                    if ((_arm_seals[i]+_exp)>100){
                        draw_sprite(purity_seals,_arm_seals[i] ,_x_offset+positions[i][0], _y_offset+positions[i][1]);
                    }
                }                                                     
            }
            if (struct_exists(_body[$ "right_arm"],"purity_seal")){
                var _arm_seals = _body[$ "right_arm"][$"purity_seal"];
                if (armour_type==ArmourType.Normal){
                    var positions = [[44, 76], [30,71], [16, 69]];
                }                
                else {
                    var positions = [[11, 91], [39, 90], [66, 86]];
                } 
                for (var i=0;i<array_length(_arm_seals);i++){
                    if (i >= array_length(positions)) then continue;
                    if ((_arm_seals[i]+_exp)>100){
                        draw_sprite(purity_seals,_arm_seals[i] ,_x_offset+positions[i][0], _y_offset+positions[i][1]);
                    }
                }                                    
            }            
        }           
    }
    static base_armour = function(){
        armour_type = ArmourType.Normal
        switch (unit.armour()){
            case "MK7 Aquila":
            case "Artificer Armour":
                add_group(mk7_bits);
                armour_type = ArmourType.Normal
                break;                  
            case "MK6 Corvus":
                add_group({
                    armour: spr_mk6_complex,
                    backpack: spr_mk6_complex_backpack,
                    left_arm: spr_mk6_left_arm,
                    right_arm: spr_mk6_right_arm,
                    left_trim :spr_mk7_left_trim,
                    right_trim: spr_mk7_right_trim,
                    mouth_variants : spr_mk6_mouth_variants,
                    head : spr_mk6_head_variants,
                });
                armour_type = ArmourType.Normal
                break;                
            case  "MK5 Heresy":
                add_group({
                    armour: spr_mk5_complex,
                    backpack: spr_mk5_complex_backpack,
                    left_arm: spr_mk5_left_arm,
                    right_arm: spr_mk5_right_arm,
                    left_trim :spr_mk7_left_trim,
                    right_trim: spr_mk7_right_trim,
                    head : spr_mk5_head_variants,
                }); 
                armour_type = ArmourType.Normal
                /*if (scr_has_style("Prussian")){
                    add_to_area("chest_variants", spr_mk7_prussia_chest);
                }*/  
                break;             
            case  "MK4 Maximus":
                add_group({
                    chest_variants: spr_mk4_chest_variants,
                    armour: spr_mk4_complex,
                    backpack: spr_mk4_complex_backpack,
                    left_arm :spr_mk4_left_arm,
                    leg_variants: spr_mk4_leg_variants,
                    right_arm: spr_mk4_right_arm,
                    left_trim: spr_mk4_left_trim,
                    right_trim: spr_mk4_right_trim,
                    mouth_variants: spr_mk4_mouth_variants,
                    head : spr_mk4_head_variants,            
                });
                armour_type = ArmourType.Normal
                break;                                
            case  "MK3 Iron Armour":
                add_group({
                    armour : spr_mk3_complex,
                    backpack : spr_mk3_complex_backpack,
                    left_arm : spr_mk3_left_arm,
                    right_arm : spr_mk3_right_arm ,   
                    head : spr_mk3_head_variants, 
                    left_leg : spr_mk3_left_leg_variants,
                    right_leg : spr_mk3_right_leg_variants,
                    mouth_variants: spr_mk3_mouth,
                    forehead : spr_mk3_forehead_variants,
                    belt : spr_mk3_belt,
                    chest_variants : spr_mk3_chest,
                });
                armour_type = ArmourType.Normal
                break;
            case  "MK8 Errant":
                add_group(mk7_bits);
                add_to_area("gorget",spr_mk8_gorget);
                armour_type = ArmourType.Normal;
                break;
           case  "Terminator Armour":
                add_group({
                    armour : spr_indomitus_complex,
                    left_arm : spr_indomitus_left_arm,
                    right_arm : spr_indomitus_right_arm,
                    backpack : spr_indomitus_backpack_variants,
                    chest_variants : spr_indomitus_chest_variants,
                    leg_variants : spr_indomitus_leg_variants,
                    head : spr_indomitus_head_variants,
                    belt : spr_indomitus_belt        
                });
                 armour_type = ArmourType.Terminator;
                 break;
            case  "Tartaros":                       

                add_group({
                    armour : spr_tartaros_complex,
                    left_arm : spr_tartaros_left_arm,
                    right_arm : spr_tartaros_right_arm, 
                    right_leg : spr_tartaros_right_leg,
                    left_leg : spr_tartaros_left_leg,
                    chest_variants : spr_tartaros_chest,
                    gorget : spr_tartaros_gorget,
                    mouth_variants : spr_tartaros_faceplate,
                    head : spr_tartaros_head_variants,
                    left_trim : spr_tartaros_left_trim,
                    right_trim : spr_tartaros_right_trim,

                });
                    armour_type = ArmourType.Terminator;
                break;
            case  "Dreadnought":
                add_group({
                    armour : spr_dreadnought_complex,
                })
                armour_type = ArmourType.Dreadnought;
                break;
            case "Scout Armour":
                add_group({
                    armour : spr_scout_complex,
                    left_arm: spr_mk6_left_arm,
                    right_arm: spr_mk6_right_arm,                    
                })            
                armour_type = ArmourType.Scout;
    			break
            default:
                add_group(mk7_bits);
                break;

        }
        var type = unit.get_body_data("type","cloak");
        if (type != "none") {
            static _cloaks = {
                "scale":spr_cloak_scale,
                "pelt":spr_cloak_fur,
                "cloth":spr_cloak_cloth,
            }
            if (struct_exists(_cloaks, type)){
                add_to_area("cloak",_cloaks[$ type]);
                add_to_area("cloak_image",spr_cloak_image_1);  
                add_to_area("cloak_trim",spr_cloak_image_0);        
            }
            
        }          
        assign_modulars();
    }

     if (unit.IsSpecialist("forge")){
        if array_contains(["MK5 Heresy", "MK6 Corvus","MK7 Aquila", "MK8 Errant", "Artificer Armour"], unit.armour()){
            if (unit.has_trait("tinkerer")){
                add_group({
                    "armour":spr_techmarine_complex,
                    "right_trim":spr_techmarine_right_trim,
                    "left_trim":spr_techmarine_left_trim,
                    "leg_variants":spr_techmarine_left_leg,
                    "leg_variants":spr_techmarine_right_leg,
                    "head":spr_techmarine_head,
                    "chest_variants":spr_techmarine_chest, 
                    "mouth_variants" : spr_tech_face_plate                    
                })
            }
        }

    }  
    static draw_cloaks = function(){
        var _shader_set_multiply_blend = function(_r, _g, _b) {
            shader_set(shd_multiply_blend);
            shader_set_uniform_f(shader_get_uniform(shd_multiply_blend, "u_Color"), _r, _g, _b);
        };        
        _shader_set_multiply_blend(127, 107, 89);
        draw_component("cloak");

        _shader_set_multiply_blend(obj_controller.trim_colour_replace[0]*255, obj_controller.trim_colour_replace[1]*255, obj_controller.trim_colour_replace[2]*255);
        draw_component("cloak_image");
        draw_component("cloak_trim");

        shader_reset();
        shader_set(full_livery_shader);         
    }

    static add_to_area = function(area, add_sprite, overide_data = "none"){
        if (sprite_exists(add_sprite)){
            var _add_sprite_length = sprite_get_number(add_sprite);
            if (!struct_exists(self, area)){
                self[$ area] = sprite_duplicate(add_sprite);
                var _overide_start = 0;
            } else {
                var _overide_start = sprite_get_number(self[$ area]);
                sprite_merge(self[$ area], add_sprite)
            }
            if (overide_data != "none"){
                add_overide(area, _overide_start, _add_sprite_length,overide_data)
            }            
        }
    }

    static add_overide = function(area,_overide_start, sprite_length, overide_data){
        if (!struct_exists(overides, area)){
            overides[$ area] = []; 
        }
        array_push(overides[$ area], [_overide_start, _overide_start+sprite_length, overide_data]);
    }

    static replace_area = function(area, add_sprite, overide_data = "none"){
        if (struct_exists(self, area)){
            sprite_delete(self[$area]);
            if (struct_exists(overides, area)){
                struct_remove(overides,area);
            }            
        }
        self[$ area] = sprite_duplicate(add_sprite);
        if (overide_data != "none"){
            add_overide(area, 0, sprite_get_number(self[$ area]),overide_data)
        }
    }

    static remove_area = function(area){
        if (struct_exists(self, area)){
            sprite_delete(self[$area]);
            struct_remove(self, area);
            if (struct_exists(overides, area)){
                struct_remove(overides,area);
            }
        }
    }

    static add_group = function(group){
        var _areas = struct_get_names(group);
        for (var i=0;i<array_length(_areas); i++){
            var _area = _areas[i];
            add_to_area(_area, group[$_area]);
        }
    }

    static add_relative_to_status = function(area, add_sprite, status_level, overide_data="none"){
    	var _roles = obj_ini.role[100];
    	var tiers = [
    		["Chapter Master"],
    		["Forge Master", "Master of Sanctity","Master of the Apothecarion",string("Chief {0}",_roles[eROLE.Librarian])],
    		[_roles[eROLE.Captain], _roles[eROLE.HonourGuard]],
    		[_roles[eROLE.Champion]],
    		[_roles[eROLE.Ancient],_roles[eROLE.VeteranSergeant]],
    		[ _roles[eROLE.Terminator]],
    		[_roles[eROLE.Veteran], _roles[eROLE.Sergeant],_roles[eROLE.Chaplain],_roles[eROLE.Apothecary],_roles[eROLE.Techmarine],_roles[eROLE.Librarian]],
    		["Codiciery", "Lexicanum",_roles[eROLE.Tactical],_roles[eROLE.Assault],_roles[eROLE.Devastator]],
    		[_roles[eROLE.Scout],]
    	];

    	var _unit_tier = 8;
    	if (_unit_tier==8){
	    	for (var i=0;i<array_length(tiers);i++){
	    		var tier = tiers[i];
	    		if (array_contains(tier, unit.role())){
	    			_unit_tier = i;
	    		}
	    	}
	    }
    	if (_unit_tier<=status_level){
    		add_to_area(area, add_sprite, overide_data);
    	} else {
    		var variation_tier = (_unit_tier - status_level)+1;
    		if (variation_map[$ area] % variation_tier == 0){
    			add_to_area(area, add_sprite, overide_data);
    		}
    	}
    }

    position_overides = {

    };

    static draw_head = function(unit){
        var choice;
        if (struct_exists(self, "head")){
            draw_component("crest");
            draw_component("head");
            draw_component("forehead");
            draw_component("mouth_variants");
            draw_component("left_eye");
            draw_component("right_eye");
            draw_component("crown");                                                                                
        }
    }

    static complex_helms = function(data){
        set_complex_shader_area(["eye_lense"], data.helm_lens);
        if (data.helm_pattern == 0){
            set_complex_shader_area(["left_head", "right_head","left_muzzle", "right_muzzle"], data.helm_secondary);

        } else if (data.helm_pattern == 2){
            set_complex_shader_area(["left_head", "right_head"], data.helm_primary);
            set_complex_shader_area(["left_muzzle", "right_muzzle"], data.helm_secondary);
        } else if (data.helm_pattern==1 || data.helm_pattern == 3){
            var _surface_width = sprite_get_width(head);
            var _surface_height = sprite_get_height(head);
            var _head_surface = surface_create(_surface_width, 60);
            var _decoration_surface = surface_create(_surface_width, 60);
            shader_reset();
            surface_set_target(_head_surface);
            var _temp = [x_surface_offset, y_surface_offset];
            x_surface_offset = 0;
            y_surface_offset = 0;
            draw_head(unit);
            surface_reset_target();
            x_surface_offset = _temp[0];
            y_surface_offset = _temp[1];
            
            remove_area("mouth_variants");
            remove_area("crest");
            remove_area("forehead");
            remove_area("left_eye");
            remove_area("right_eye");
            remove_area("crown");

            shader_set(helm_shader);
            surface_set_target(_decoration_surface);
            shader_set_uniform_f_array(shader_get_uniform(helm_shader, "replace_colour"), get_shader_array(data.helm_secondary));
            draw_sprite(spr_helm_stripe, data.helm_pattern==1?0:1, 0, 0);
            surface_reset_target();
            shader_reset();

            var _swaps = [
                make_colour_rgb(0, 0, 128),
                make_colour_rgb(0, 0, 255),
                make_colour_rgb(128, 64, 255),
                make_colour_rgb(64, 128, 255),
            ];
            blend_mode_custom(_decoration_surface,_head_surface,_swaps);

            head = sprite_create_from_surface(_head_surface, 0, 0, _surface_width, 60, false, false, 0, 0);
            surface_free(_head_surface);
            surface_free(_decoration_surface);
            shader_set(full_livery_shader);
            set_complex_shader_area(["left_head", "right_head","left_muzzle", "right_muzzle"], data.helm_primary);
        }
    }
    base_armour();

}



/// blend_mode_custom(source_surface, destination_surface)
function blend_mode_custom(source_surface, destination_surface, allowed_cross_colours) {
    // Set the target for reading the destination surface
    surface_set_target(destination_surface);

    // Get surface size
    var _surface_width = surface_get_width(destination_surface);
    var _surface_height = surface_get_height(destination_surface);

    var allowed_colour_r=[];
    var allowed_colour_g=[];
    var allowed_colour_b=[];
    for (var i = 0; i < array_length(allowed_cross_colours); i++) {
        var allowed_color = allowed_cross_colours[i];
        array_push(allowed_colour_r, color_get_red(allowed_color));
        array_push(allowed_colour_g, color_get_green(allowed_color));
        array_push(allowed_colour_b, color_get_blue(allowed_color));
    }

    // Loop through each pixel
    for (var _y = 0; _y < _surface_height; _y++) {
        var had_colour_this_row = false;
        for (var _x = 75; _x < 90; _x++) {
            
            // Get the destination pixel color

            var col = surface_getpixel_ext(destination_surface, _x, _y)
            var _alpha = (col >> 24) & 255;
            if (_alpha<150){
                
                if (_x>=80){
                    break;
                };
                continue;
            } 
            var dest_color = surface_getpixel(destination_surface, _x, _y);

            var scource_alpha = (surface_getpixel_ext(source_surface, _x, _y) >>24 &255);
            if (scource_alpha<150){
                if (had_colour_this_row){
                    break;
                } else {
                    continue;
                }
            } else {
                had_colour_this_row = true;
            }
            // Extract RGB components
            var dest_r = color_get_red(dest_color);
            var dest_g = color_get_green(dest_color);
            var dest_b = color_get_blue(dest_color);
            
            // Check if destination color matches allowed colors
            var is_allowed = false;
            for (var i = 0; i < array_length(allowed_cross_colours); i++) {
                var allowed_color = allowed_cross_colours[i];
                if (dest_r!=allowed_colour_r[i]) then continue;
                if (dest_g!=allowed_colour_g[i]) then continue;
                if (dest_b!=allowed_colour_b[i]) then continue;
                is_allowed = true;
                break;
            }
            if (!is_allowed) then continue;
            
            // Get the source pixel
            var src_color = surface_getpixel(source_surface, _x, _y);
            var src_r = color_get_red(src_color);
            var src_g = color_get_green(src_color);
            var src_b = color_get_blue(src_color);
            
            // Apply the blending logic

            var final_color = make_color_rgb(src_r, src_g, src_b);
            // Draw the blended pixel
            draw_set_color(final_color);
            draw_point(_x, _y);                 
        }
    }

    // Reset the target
    surface_reset_target();
}

