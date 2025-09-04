function load_visual_sets(){
    var _vis_set_directory = working_directory + "\\main\\visual_sets";
    if (directory_exists(_vis_set_directory)){

        var _file_buffer = buffer_load($"{_vis_set_directory}\\use_sets.json");
        if (_file_buffer == -1) {
            throw ("Could not open file");
        }
        var _json_string = buffer_read(_file_buffer, buffer_string);
        buffer_delete(_file_buffer);
        var _raw_data = json_parse(_json_string);
        if (!is_array(_raw_data)){
            throw ("use_sets.json File Wrong Format");
        }
        for (var i=0;i<array_length(_raw_data);i++){
            var _sepcific_vis_set = $"{_vis_set_directory}\\{_raw_data[i]}";
            show_debug_message(_raw_data[i]);
            if (directory_exists(_sepcific_vis_set)){
                show_debug_message(_raw_data[i]);
                var _data_buffer = buffer_load($"{_sepcific_vis_set}\\data.json");
                if (_data_buffer == -1) {
                    buffer_delete(_data_buffer);
                    continue;
                } else {
                    var _data_string = buffer_read(_data_buffer, buffer_string);
                    buffer_delete(_data_buffer);
                    var _data_set = json_parse(_data_string);
                    load_vis_set_to_global(_sepcific_vis_set, _data_set);
                }
            }
        }

    }

    set_up_visual_overides();

    load_symbol_sets(global.chapter_symbols, "chapter_symbols", ["pauldron", "knees"]);
    load_symbol_sets(global.role_markings, "role_markings", ["pauldron", "knees"]);
}

function load_symbol_sets(global_area, main_key, sub_sets){
    var _cons_directory = working_directory + $"\\main\\{main_key}";
    if (directory_exists(_cons_directory)){
        show_debug_message($"{_cons_directory}")
        var _file_buffer = buffer_load($"{_cons_directory}\\load_sets.json");
        if (_file_buffer == -1) {
            throw (false);
        }
        var _json_string = buffer_read(_file_buffer, buffer_string);
        buffer_delete(_file_buffer);
        var _raw_data = json_parse(_json_string);
        if (!is_array(_raw_data)){
            throw ("use_sets.json File Wrong Format");
        }
        var _sprite_double_surface = surface_create(200,200);
        for (var i=0;i<array_length(_raw_data);i++){
            var _sepcific_vis_set = $"{_cons_directory}\\{_raw_data[i]}";
            if (directory_exists(_sepcific_vis_set)){
                for (var s=0;s<array_length(sub_sets);s++){
                    var _sub = sub_sets[s];
                    var sub_direct = $"{_sepcific_vis_set}\\{_sub}.png";
                    load_new_icon(_sprite_double_surface,sub_direct, global_area[$ _sub], _raw_data[i]);
                }
            }
        }
        surface_clear_and_free(_sprite_double_surface);    
    }    
}


function load_new_icon(new_sprite_surface, path, add_place, key){
    if (file_exists(path)){
        var _new_sprite = sprite_add(path,1,0,0,0,0);
        var _width = sprite_get_width(_new_sprite);
        var _height = sprite_get_height(_new_sprite);
        surface_resize(new_sprite_surface, _width, _height)
        surface_set_target(new_sprite_surface);
        draw_clear_alpha(c_white,0);
        draw_sprite_ext(_new_sprite, 0, _width, 0, -1, 1, 0, c_white, 1);
        surface_reset_target();
        sprite_add_from_surface(_new_sprite, new_sprite_surface, 0, 0, _width, _height, 1, 0);
        add_place[$ key] = _new_sprite;
    }    
}
global.chapter_symbols  = {
    pauldron : {
        mantis_warriors : spr_mantis_warriors_icon,
    },
    knees : {

    }
}

global.role_markings = {
    pauldron : {
    },
    knees : {

    }
}
global.squad_markings = {
    pauldron : {
    },
    knees : {

    }
}
global.company_markings = {
    pauldron : {
    },
    knees : {

    }
}

global.culture_styles = [
    "Greek",
    "Roman",
    "Knightly",
    "Gladiator",
    "Mongol",
    "Feral",
    "Flame Cult",
    "Mechanical Cult",
    "Prussian",
    "Cthonian",
    "Alpha",
    "Ultra",
    "Renaissance",
    "Blood",
    "Angelic",
    "Crusader",
    "Gothic",
    "Wolf Cult",
    "Runic"
];
function load_vis_set_to_global(directory, data){
    for (var i=0;i<array_length(data); i++){
        var _sprite_item = data[i];
        show_debug_message(_sprite_item);
        if (directory_exists(directory + $"\\{_sprite_item.name}")){
            var _sprite_direct = directory + $"\\{_sprite_item.name}";
            if (file_exists($"{_sprite_direct}\\1.png")){
                var _new_sprite = sprite_add(_sprite_direct + "\\1.png",1,0,0,0,0);
                var s = 2;
                _exit = false;
                while (file_exists(_sprite_direct + $"\\{s}.png")){
                    var _merge_sprite = sprite_add(_sprite_direct + $"\\{s}.png",1,0,0,0,0);
                    if (_merge_sprite == -1) {
                        sprite_delete(_new_sprite);
                        continue;
                    }                    
                    s++;
                    sprite_merge(_new_sprite, _merge_sprite);
                    sprite_delete(_merge_sprite);
                }
                var _s_data = _sprite_item.data;
                if (struct_exists(_s_data, "offset")){
                    sprite_set_offset(_new_sprite, _s_data.offset.x, _s_data.offset.y);
                }
                _s_data.name = _sprite_item.name;
                _s_data.sprite = _new_sprite;
                if (_s_data.position == "weapon"){
                    var _weapon_vis = global.weapon_visual_data;
                    struct_remove(_s_data, "position");
                    if (struct_exists(_weapon_vis,_s_data.base_weapon)){
                        array_push(_weapon_vis[$_s_data.base_weapon].variants, _s_data);
                    } else {
                        _weapon_vis[$ _s_data.base_weapon] = {
                            base : _s_data,
                            variants : [{sprite : _s_data.sprite}],
                        };
                        struct_remove(_weapon_vis[$ _s_data.base_weapon].base, "base_weapon");
                    }
                } else {
                    array_push(global.modular_drawing_items, _s_data);
                }
            }
        }
    }
}

function set_up_visual_overides(){
    var _mods = global.modular_drawing_items;
    for (var i=0;i<array_length(_mods);i++){
        var _item = _mods[i];
        if (struct_exists(_item, "overides")){
            var _overide_areas = struct_get_names(_item.overides);
            for (var o = 0; o<array_length(_overide_areas);o++){
                var _overide = _item.overides[$ _overide_areas[o]];
                if (is_string(_overide)){
                    var _found_sprite = false;
                    for (var s=0;s<array_length(_mods);s++){
                        if (struct_exists(_mods[s], "name")){
                            if (_mods[s].name == _overide){
                                _item.overides[$ _overide_areas[o]] = _mods[s].sprite;
                                _found_sprite = true;
                                break;
                            }
                        }
                    }
                    if (!_found_sprite){
                        struct_remove(_item.overides, _overide_areas[o]);
                    }
                }
            }
        }
        /*subs have the format "subcomponents" : [
            [crusader_neckpiece],
        ]*/
        if (struct_exists(_item, "subcomponents")){
            var _subs = _item.subcomponents;
            for (var s = 0;s<array_length(_subs);s++){
                var _sub_group = _subs[s]
                for (var g=array_length(_sub_group)-1;g>=0;g--){
                    var _found_sprite = false;
                    var _subimg = _sub_group[g];
                    if (!is_string(_subimg)){
                        if (!sprite_exists(_subimg)){
                            array_delete(_sub_group,g,1);
                        }
                        continue;
                    }
                    if (_subimg == "blank"){
                        _item.subcomponents[s][g] = spr_blank;
                        _found_sprite = true;
                    } else {
                        for (var m=0;m<array_length(_mods);m++){
                            if (struct_exists(_mods[m], "name")){
                                if (_mods[m].name == _subimg){
                                    _item.subcomponents[s][g] = _mods[m].sprite;
                                    _found_sprite = true;
                                    break;
                                }
                            }
                        }
                    }
                    if (!_found_sprite){
                        array_delete(_item.subcomponents[s], g, 1);
                    }
                }
            }
        }
        if (struct_exists(_item,"cultures")){
            for (var i=0;i<array_length(_item.cultures);i++){
                var _culture = _item.cultures[i];
                if (!array_contains(global.culture_styles,_culture)){
                    array_push(global.culture_styles,_culture);
                }
            }
        }
    }
}
global.modular_drawing_items = [
    {
        sprite : spr_purity_seal,
        body_types :[0,2],
        position : "purity_seals",
    },
    {
        position : "crown",
        body_types: [0],
        max_saturation : 60,
        exp : {
            scale : true,
            exp_scale_max : 200,
        },
        sprite:spr_psy_hood_alpha2,
        equipped : {
            "gear" : "Psychic Hood",
        },
        cultures: ["Alpha"], 
        prevent_others : true,    
    },
    {
        position : "robe",
        body_types: [0],
        sprite:spr_binders_robe,
        role_type: [SPECIALISTS_LIBRARIANS],
        max_saturation:10,
    }, 
    {
        position : "robe",
        body_types: [0],
        sprite:spr_binders_robe,
        role_type: [SPECIALISTS_LIBRARIANS],
        max_saturation:40,
        chapter_adv : ["Favoured By The Warp","Warp Touched"],
        chapter_disadv : ["Warp Tainted"],
        allow_either :["chapter_adv","chapter_disadv"],
    }, 
    {
        position : "belt",
        body_types: [0],
        sprite:spr_binders_belt,
        role_type: [SPECIALISTS_LIBRARIANS],
        chapter_adv : ["Favoured By The Warp","Warp Touched"],
        chapter_disadv : ["Warp Tainted"],
        allow_either :["chapter_adv","chapter_disadv"],
        max_saturation:50,
    }, 
    {
        position : "crown",
        body_types: [0],
        sprite:spr_psy_hood_complex,
        equipped : {
            "gear" : "Psychic Hood",
        },
        prevent_others : true,
    },  
    {
        sprite : spr_da_mk5_helm_crests,
        cultures : ["Knightly"],
        body_types :[0],
        armours : ["MK3 Iron Armour", "MK4 Maximus", "MK5 Heresy"],
        position : "crest",
        assign_by_rank : 2,
        exp : {
            min : 70,
        },         
    },
    {
        sprite : spr_da_mk7_helm_crests,
        cultures : ["Knightly"],
        body_types :[0],
        armours : ["MK7 Aquila", "Power Armour", "MK8 Errant","Artificer Armour"],
        position : "crest",
        assign_by_rank : 2,
    },
    {
        sprite : spr_terminator_laurel,
        armours : ["Terminator Armour", "Tartaros"],
        roles : [eROLE.Captain,eROLE.Champion],
        position : "crown",
        body_types :[2],
    },
    {
        sprite : spr_laurel,
        body_types :[0],
        armours : ["Terminator Armour", "Tartaros"],
        roles : [eROLE.Captain,eROLE.Champion],
        position : "crown",
    },
    {
        sprite : spr_special_helm,
        body_types :[0],
        armours_exclude : ["MK3 Iron Armour"],
        roles : [eROLE.Captain,eROLE.Champion],
        assign_by_rank : 2,
        position : "mouth_variants",
    },
    {
        cultures : ["Mongol"],
        sprite : spr_mongol_topknots,
        body_types :[0],
        position : "crest",
    },

    {
        cultures : ["Cthonian", "Gothic"],
        sprite : spr_chap_trim_left,
        body_types :[0],
        position : "left_trim",
        max_saturation : 80,
        exp : {
            scale : true,
            exp_scale_max : 300,
        }
    },
    {
        cultures : ["Cthonian", "Gothic"],
        sprite : spr_chap_trim_right,
        body_types :[0],
        position : "right_trim",
        max_saturation : 80,
        exp : {
            scale : true,
            exp_scale_max : 300,
        }        
    },
    {
        sprite : spr_chap_trim_left,
        body_types :[0],
        position : "left_trim",
        role_type : [SPECIALISTS_CHAPLAINS],
    },
    {
        sprite : spr_chap_trim_right,
        body_types :[0],
        position : "right_trim",
        role_type : [SPECIALISTS_CHAPLAINS],
    },

    {
        cultures : ["Mongol"],
        sprite : spr_mongol_hat,
        body_types :[0],
        position : "crown",
    },
    {
        cultures : ["Prussian"],
        sprite : spr_prussian_spike,
        body_types :[0],
        position : "crest",
    },
    {
        cultures : ["Mechanical Cult"],
        assign_by_rank : 2,
        sprite : spr_metal_tabbard,
        role_type : [SPECIALISTS_TECHS],
        body_types :[0],
        position : "tabbard",
        allow_either : ["cultures", "role_type"],
    },
    {
        cultures : ["Knightly"],
        sprite : spr_knightly_personal_livery,
        body_types :[0],
        assign_by_rank : 3,
        position : "left_personal_livery",        
    },
    {
        cultures : ["Gladiator"],
        sprite : spr_gladiator_crest,
        body_types :[0],
        assign_by_rank : 2,
        position : "crest",        
    },
    {
        cultures : ["Mechanical Cult"],
        assign_by_rank : 2,
        sprite : spr_terminator_metal_tabbard,
        role_type : [SPECIALISTS_TECHS],
        body_types :[2],
        position : "tabbard",
        allow_either : ["cultures", "role_type"],       
    },
    {
        cultures : ["Flame Cult"],
        sprite : spr_mk3_mouth_flame_cult,
        body_types :[0],
        position : "mouth_variants",
        armours : ["MK3 Iron Armour"],    
    },
    {
        cultures : ["Prussian"],
        sprite : spr_mk3_mouth_prussian,
        body_types :[0],
        position : "mouth_variants",
        armours : ["MK3 Iron Armour"],    
    },
    {
        cultures : ["Prussian"],
        sprite : spr_mk6_mouth_prussian,
        body_types :[0],
        position : "mouth_variants",
        armours : ["MK3 Iron Armour"],    
    },
    {
        cultures : ["Prussian"],
        sprite : spr_mk7_prussia_chest,
        body_types :[0],
        position : "chest_variants",  
    },
    {
        cultures : ["Prussian"],
        sprite : spr_mk7_mouth_prussian,
        body_types :[0],
        position : "chest_variants",
        armours : ["MK8 Errant", "MK7 Aquila"],      
    }, 
    {
        cultures : ["Mongol"],
        sprite : spr_mk7_mongol_chest_variants,
        body_types :[0],
        position : "chest_variants",
        armours : ["MK8 Errant", "MK7 Aquila"],      
    },
    {
        cultures : ["Gladiator"],
        sprite : spr_mk7_gladiator_chest,
        body_types :[0],
        position : "chest_variants",
        armours : ["MK8 Errant", "MK7 Aquila"],      
    },
    {
        cultures : ["Mongol"],
        sprite : spr_mk4_mongol_chest_variants,
        body_types :[0],
        position : "chest_variants",
        armours : ["MK4 Maximus"],      
    },
    {
        cultures : ["Mongol"],
        sprite : spr_mk6_mongol_chest_variants,
        body_types :[0],
        position : "chest_variants",
        armours : ["MK6 Corvus"],      
    },
    {
        cultures : ["Knightly"],
        sprite : spr_knightly_robes,
        body_types :[0],
        position : "robe",
        assign_by_rank : 4,    
    },
    {
        cultures : ["Knightly"],
        sprite : spr_da_backpack,
        body_types :[0],
        position : "backpack",
        assign_by_rank : 3,
        armours : ["MK5 Heresy", "MK6 Corvus","MK7 Aquila", "MK8 Errant", "Artificer Armour"],         
    },
    {
        cultures : ["Alpha"],
        sprite : spr_alpha_backpack,
        body_types :[0],
        position : "backpack",
        assign_by_rank : 3,
        armours : ["MK5 Heresy", "MK6 Corvus","MK7 Aquila", "MK8 Errant", "Artificer Armour"],         
    },
    {
        chapter_adv : ["Reverent Guardians"],
        sprite : spr_pack_brazier3,
        traits : ["zealous_faith"],
        body_types :[0],
        allow_either : ["chapter_adv", "traits","role_type"],
        role_type : [SPECIALISTS_CHAPLAINS],
        position : "backpack_decoration",
        assign_by_rank : 4,
        max_saturation : 40,
    },
    {
        sprite : spr_gear_librarian,
        body_types :[0],
        position : "right_pauldron_icons",
        role_type : [SPECIALISTS_LIBRARIANS],
    },
    {
        sprite : spr_gear_librarian_term,
        body_types :[2],
        position : "right_pauldron_icons",
        role_type : [SPECIALISTS_LIBRARIANS],
    },
    {
        sprite : spr_roman_centurian_crest,
        body_types :[0],
        cultures : ["Roman", "Greek", "Gladiator"],
        position : "crest",
        role_type : [SPECIALISTS_CAPTAIN_CANDIDATES],
        assign_by_rank : 2,
    },
    {
        sprite : spr_marksmans_honor,
        body_types :[0,2],
        position : "purity_seals",
        stats : [
            ["ballistic_skill", 50, "exmore"]
        ]
    },
    {
        sprite : spr_crux_on_chain,
        body_types :[0,2],
        position : "purity_seals",
        exp : {
            min : 100,
        }
    },    
    {
        cultures : ["Knightly"],
        sprite : spr_mk6_knightly_mouth_variants,
        body_types :[0],
        position : "mouth_variants",
        armours : ["MK6 Corvus"],    
    },
    {
        cultures : ["Knightly"],
        sprite : spr_mk6_forehead_knightly,
        body_types :[0],
        position : "forehead",
        armours : ["MK6 Corvus"],    
    }, 
    {
        cultures : ["Cthonian"],
        sprite : spr_mk6_cthonian_heads,
        body_types :[0],
        position : "head",
        armours : ["MK6 Corvus"],    
    },     
    {
        sprite : spr_mk7_complex_crux_belt,
        body_types :[0, 2],
        position : "belt",
        armours : ["MK5 Heresy", "MK6 Corvus","MK7 Aquila", "MK8 Errant", "Artificer Armour", "Tartaros"],
        exp : {
            min : 100,
        },        
    },
    {
        sprite : spr_crux_belt_fancy,
        body_types :[0, 2],
        position : "belt",
        armours : ["MK5 Heresy", "MK6 Corvus","MK7 Aquila", "MK8 Errant", "Artificer Armour", "Tartaros"],
        assign_by_rank : 3,
        exp : {
            min : 100,
        },        
    },
    {
        cultures : ["Knightly", "Crusader"],
        sprite : spr_mk7_rope_belt,
        body_types :[0],
        position : "belt",
        armours : ["MK5 Heresy", "MK6 Corvus","MK7 Aquila", "MK8 Errant", "Artificer Armour","MK4 Maximus"], 
        assign_by_rank : 2,   
    },
    {
        cultures : ["Knightly", "Crusader","Gladiator"],
        sprite : spr_lion_belt,
        body_types :[0],
        position : "belt",
        exp : {
            min : 70,
        },        
        armours : ["MK5 Heresy", "MK6 Corvus","MK7 Aquila", "MK8 Errant", "Artificer Armour"], 
        assign_by_rank : 2,   
    },
    {
        cultures : ["Knightly"],
        sprite : spr_knightly_belt,
        body_types :[0],
        position : "belt",
        exp : {
            min : 50,
        } ,      
        armours : ["MK5 Heresy", "MK6 Corvus","MK7 Aquila", "MK8 Errant", "Artificer Armour"], 
        assign_by_rank : 3,   
    }, 
    {
        sprite : spr_skulls_belt,
        body_types :[0],
        position : "belt",
        role_type : [SPECIALISTS_CHAPLAINS],
        cultures : ["Gothic"],
        armours : ["MK5 Heresy", "MK6 Corvus","MK7 Aquila", "MK8 Errant", "Artificer Armour"],
        allow_either : ["cultures", "role_type"],

    },
    {
        sprite : spr_tech_belt,
        body_types :[0],
        position : "belt",
        role_type : [SPECIALISTS_TECHS],
        armours : ["MK5 Heresy", "MK6 Corvus","MK7 Aquila", "MK8 Errant", "Artificer Armour"],  
    },     
    {
        cultures : ["Feral"],
        sprite : spr_teeth,
        body_types :[0,2],
        position : "purity_seals",
        traits : ["tyrannic_vet", "beast_slayer","feral"],
        allow_either : ["cultures", "traits"],
    },
    {
        cultures : ["Knightly"],
        sprite : spr_mk7_knightly_chest,
        body_types :[0],
        position : "chest_variants",
        armours : ["MK8 Errant", "MK7 Aquila","Artificer Armour"],  
    },
    {
        sprite : spr_ultra_belt,
        cultures : ["Ultra"],
        body_types :[0, 2],
        assign_by_rank : 3,
        position : "belt",
        armours : ["MK5 Heresy", "MK6 Corvus","MK7 Aquila", "MK8 Errant", "Artificer Armour", "Tartaros"],  
    },
    {
        cultures : ["Roman", "Gladiator"],
        sprite : spr_roman_tabbard,
        body_types :[0, 2],
        position : "tabbard",
        max_saturation : 50,
        assign_by_rank : 3,
        exp : {
            min : 50,
        },
        armours : ["MK5 Heresy", "MK6 Corvus","MK7 Aquila", "MK8 Errant", "Artificer Armour", "Tartaros","MK4 Maximus", "MK3 Iron Armour"], 
    },
    {
        cultures : ["Cthonian"],
        sprite : spr_cthonian_tabbard,
        body_types :[0, 2],
        position : "tabbard",
        max_saturation : 50,
        assign_by_rank : 3,
        exp : {
            min : 50,
        },
        armours : ["MK5 Heresy", "MK6 Corvus","MK7 Aquila", "MK8 Errant", "Artificer Armour", "Tartaros","MK4 Maximus", "MK3 Iron Armour"], 
    },
    {
        cultures : ["Cthonian", "Prussian"],
        sprite : spr_chain_mail_tabbard,
        body_types :[0, 2],
        position : "tabbard",
        max_saturation : 50,
        assign_by_rank : 3,
        exp : {
            min : 50,
        },
        armours : ["MK5 Heresy", "MK6 Corvus","MK7 Aquila", "MK8 Errant", "Artificer Armour", "Tartaros","MK4 Maximus", "MK3 Iron Armour"], 
    },
    {
        cultures : ["Ultra"],
        sprite : spr_ultra_tassels,
        body_types :[0,2],
        position : "purity_seals",
        exp : {
            min : 80,
        },
    },
    {
        cultures : ["Ultra", "Roman"],
        sprite : spr_ultra_backpack,
        body_types :[0],
        position : "backpack",
        assign_by_rank : 2,
        exp : {
            min : 80,
        },
    },
    {
        cultures : ["Ultra", "Roman"],
        sprite : spr_roman_cloak,
        body_types :[0],
        position : "cloak",
        max_saturation : 35,
        overides : {
            "right_pauldron_hangings" : spr_ultra_right_shoulder_hanging,
        },
        assign_by_rank :2,
        exp : {
            min : 80,
        },
    }, 
    {
        cultures : ["Ultra"],
        sprite : spr_mk7_chest_ultra,
        body_types :[0],
        position : "chest_variants",
        armours : ["MK7 Aquila", "MK8 Errant", "Artificer Armour"]
    },
    {
        max_saturation : 50,
        cultures : ["Knightly"],
        sprite : spr_indomitus_knightly_robe,
        body_types :[2],
        position : "robe",
        armours : ["Terminator Armour"],
    },
    {
        cultures : ["Feral", "Gothic"],
        sprite : spr_skull_on_chain,
        body_types :[2],
        position : "purity_seals",
    },
    {
        cultures : ["Knightly"],
        sprite : spr_sword_pendant,
        body_types :[0,2],
        position : "purity_seals",
    },
    {
        sprite : spr_mk7_complex_belt,
        body_types :[0],
        position : "belt",
        armours_exclude : ["MK3 Iron Armour"],        
    },
    {
        sprite : spr_dev_pack_complex,
        body_types :[0],
        position : "backpack_augment",
        equipped : {
            "mobi" : "Heavy Weapons Pack"
        },
        overides : {
            "chest_fastening" : spr_backpack_fastening,
        },        
    },
    {
        sprite : spr_jump_pack_complex,
        body_types :[0],
        position : "backpack_augment",
        equipped : {
            "mobi" : "Jump Pack"
        },
        overides : {
            "chest_fastening" : spr_backpack_fastening,
        },        

    },
	 {
        sprite : spr_jump_pack_serpha_complex,
        body_types :[0],
        position : "backpack_augment",
        equipped : {
            "mobi" : "Serpha Jump Pack"
        },
        overides : {
            "chest_fastening" : spr_backpack_fastening,
        },        

    },
    {
        sprite : spr_gear_hood2,
        body_types :[0],
        position : "mouth_variants", 
        role_type : [SPECIALISTS_LIBRARIANS],
        chapter_disadv : ["Warp Tainted"],    
    },
    {
        sprite : spr_mk4_chest_fastenings,
        body_types :[0],
        position : "chest_fastening",
        armours : ["MK4 Maximus"]
    }, 
    {
        sprite : spr_mk7_complex_left_pauldron,
        body_types :[0],
        position : "left_pauldron_base",
    } ,
    {
        sprite : spr_mk7_complex_right_pauldron,
        body_types :[0],
        position : "right_pauldron_base",
    },
    {
        cultures : ["Cthonian"],
        max_saturation : 30,
        sprite : spr_left_pauldron_chainmail,
        body_types :[0],
        position : "left_pauldron_base",
    } ,
    {
        cultures : ["Cthonian"],
        max_saturation : 30,
        sprite : spr_right_pauldron_chainmail,
        body_types :[0],
        position : "right_pauldron_base",
    },
    {
        sprite : spr_bonding_studs_left,
        body_types :[0],
        position : "left_pauldron_embeleshments",
        max_saturation : 15,
        armours_exclude : ["MK5 Heresy", "MK6 Corvus"]
    },
    {
        sprite : spr_bonding_studs_right,
        body_types :[0],
        position : "right_pauldron_embeleshments",
        max_saturation : 15,
        armours_exclude : ["MK5 Heresy", "MK6 Corvus"]
    },
    {
        sprite : spr_bonding_studs_left,
        body_types :[0],
        position : "left_pauldron_embeleshments",
        armours : ["MK5 Heresy", "MK6 Corvus"]
    },
    {
        sprite : spr_bonding_studs_right,
        body_types :[0],
        position : "right_pauldron_embeleshments",
        armours : ["MK5 Heresy", "MK6 Corvus"]
    },
    {
        cultures : ["Cthonian"],
        sprite : spr_pauldron_spikes_left,
        body_types :[0],
        position : "left_pauldron_embeleshments",
        max_saturation : 30,
        traits : ["blunt", "cunning", "brute"],
        allow_either : ["cultures", "traits"],
    },
    {
        cultures : ["Cthonian"],
        sprite : spr_pauldron_spikes_right,
        body_types :[0],
        position : "right_pauldron_embeleshments",
        max_saturation : 30,
        traits : ["blunt", "cunning", "brute"],
        allow_either : ["cultures", "traits"],

    },
    {
        cultures : ["Wolf Cult"],
        sprite : spr_chaplain_wolfterm_helm,
        body_types :[2],
        position : "head",
        prevent_others : true,
        ban : ["mouth_variants"],
        role_type : [SPECIALISTS_CHAPLAINS],
    },
    {
        cultures : ["Wolf Cult"],
        sprite : spr_chaplain_wolf_helm,
        body_types :[0],
        position : "head",
        prevent_others : true,
        ban : ["mouth_variants"],
        role_type : [SPECIALISTS_CHAPLAINS],
    },
    {   
        sprite : spr_chaplain_term_helm,
        body_types :[2],
        position : "head",
        prevent_others : true,
        ban : ["mouth_variants"],
        role_type : [SPECIALISTS_CHAPLAINS],
    },
    {
        sprite : spr_chaplain_helm,
        body_types :[0],
        position : "head",
        prevent_others : true,
        ban : ["mouth_variants"],
        role_type : [SPECIALISTS_CHAPLAINS],
    }, 
    {
        cultures : ["Feral", "Wolf Cult"],
        sprite : spr_wolf_tail,
        body_types :[2, 0],
        position : "purity_seals",
    },
    {
        cultures : ["Feral", "Wolf Cult"],
        sprite : spr_right_pauldron_fur_hanging,
        body_types :[0],
        position : "right_pauldron_hangings",
        max_saturation : 20,
    },
    {
        cultures : ["Feral", "Wolf Cult"],
        sprite : spr_left_pauldron_fur_hanging,
        body_types :[0],
        position : "left_pauldron_hangings",
        max_saturation : 20,
    }, 
    {
        cultures : ["Feral", "Wolf Cult"],
        sprite : spr_term_right_fur_hanging,
        body_types :[2],
        position : "right_pauldron_hangings",
        max_saturation : 20,
    },
    {
        cultures : ["Feral", "Wolf Cult"],
        sprite : spr_term_left_fur_hanging,
        body_types :[2],
        position : "left_pauldron_hangings",
        max_saturation : 20,
    },
    {
        cultures : ["Wolf Cult"],
        sprite : spr_fur_tail_topknot,
        body_types :[0],
        position : "crest",
        max_saturation : 30,
    },
    {
        cultures : ["Runic"],
        sprite : spr_runes_hanging,
        body_types :[0,2],
        position : "purity_seals",
    }, 
    {
        cultures : ["Wolf Cult"],
        sprite : spr_mk7_wolf_cult_chest_variants,
        body_types :[0],
        position : "chest_variants",
        armours : ["MK7 Aquila", "MK8 Errant", "Artificer Armour"],
    },
    {
        cultures : ["Wolf Cult"],
        sprite : spr_mk7_wolf_cult_belt,
        body_types :[0],
        position : "belt",
        armours_exclude : ["MK3 Iron Armour"],      
    }, 
    {
        cultures : ["Runic"],
        sprite : spr_mk7_runic_belt,
        body_types :[0],
        position : "belt",
        armours_exclude : ["MK3 Iron Armour"],      
    }, 
    {
        cultures : ["Wolf Cult"],
        sprite : spr_fur_tabbard,
        body_types :[0, 2],
        position : "tabbard",
        max_saturation : 20,
        armours : ["MK5 Heresy", "MK6 Corvus","MK7 Aquila", "MK8 Errant", "Artificer Armour", "Tartaros","MK4 Maximus", "MK3 Iron Armour"], 
    }, 
    {
        cultures : ["Runic"],
        sprite : spr_mk3_runic_chest,
        body_types :[0],
        position : "chest_variants",
        armours : ["MK3 Iron Armour"],      
    }, 
    {
        sprite : spr_mk3_chest,
        body_types :[0],
        position : "chest_variants",
        armours : ["MK3 Iron Armour"],      
    },
    {
        sprite : spr_death_watch_pauldron,
        chapter : "Deathwatch",
        position : "left_pauldron_base",
        body_types :[0],
        prevent_others : true,
    },
    {
        position: "bare_head",
        sprite: spr_bare_heads_colourable,
    },
    {
        position: "bare_neck",
        sprite: spr_bare_neck_colourable,
    }, 
    {
        position: "bare_eyes",
        sprite: spr_bare_eyes,
    } ,
    {
        position: "left_shin",
        body_types: [ 2],
        sprite: spr_indomitus_left_shin,
        armours : ["Terminator Armour"],
    }, 
    {
        position: "right_shin",
        body_types: [2],
        sprite: spr_indomitus_right_shin,
        armours : ["Terminator Armour"],
    }, 
    {
        cultures : ["Cthonian"],
        traits : ["blunt", "cunning", "brute"],
        allow_either : ["cultures", "traits"],
        position: "left_shin",
        body_types: [0],
        sprite: spr_left_shin_spikes,
        max_saturation : 80,
        exp : {
            scale : true,
            exp_scale_max : 300,
        }
    }, 
    {
        position: "right_shin",
        body_types: [0],
        sprite: spr_right_shin_spikes,
        traits : ["blunt", "cunning", "brute"],
        allow_either : ["cultures", "traits"],   
        cultures : ["Cthonian"],
        max_saturation : 80,
        exp : {
            scale : true,
            exp_scale_max : 300,
        }

    }, 
    {
        position: "left_knee",
        body_types: [ 2],
        sprite: spr_indomitus_left_knee_crux,
        max_saturation : 30,
        armours : ["Terminator Armour"],
    }, 
    {
        position: "right_knee",
        body_types: [ 2],
        sprite: spr_indomitus_right_knee_crux,
        armours : ["Terminator Armour"],
        max_saturation : 30,
    },
    {
        position : "right_eye",
        sprite: spr_indomitus_right_eye_bionic,
        body_types: [ 2],
        body_parts :{
            "right_eye" : "bionic",
        }
    },
    {
        position : "left_eye",
        sprite: spr_indomitus_left_eye_bionic,
        body_types: [ 2],
        body_parts :{
            "left_eye" : "bionic",
        }
    },
    {
        position : "left_leg",
        sprite: spr_indomitus_left_leg_bionic,
        body_types: [ 2],
        body_parts :{
            "left_leg" : "bionic",
        },
        prevent_others : true,
        ban : ["left_knee","knees"],
    }, 
    {
        position : "right_leg",
        sprite: spr_indomitus_right_leg_bionic,
        body_types: [ 2],
        body_parts :{
            "right_leg" : "bionic",
        },
        prevent_others : true,
        ban : ["right_knee","knees"],
    },
    {
        position : "left_leg",
        sprite: spr_bionic_leg_left,
        body_types: [ 0],
        body_parts :{
            "left_leg" : "bionic",
        },
        prevent_others : true,
        ban : ["left_knee","knees"],
    }, 
    {
        position : "right_leg",
        sprite: spr_bionic_leg_right,
        body_types: [ 0],
        body_parts :{
            "right_leg" : "bionic",
        },
        prevent_others : true,
        ban : ["right_knee","knees"],
    }, 
    {
        position : "right_eye",
        sprite: spr_bionic_right_eyes,
        body_types: [0],
        body_parts :{
            "right_eye" : "bionic",
        }
    },
    {
        position : "left_eye",
        sprite: spr_bionic_left_eyes,
        body_types: [0],
        body_parts :{
            "left_eye" : "bionic",
        }
    }, 
    {
        position : "forehead",
        sprite: spr_helm_decorations,
        body_types: [0, 2],
        max_saturation : 50,
        roles : [eROLE.Sergeant,eROLE.Champion,eROLE.VeteranSergeant],
        offsets : {
            "Terminator Armour" : {
                y : -10
            }
        }
    },
    {
        position : "left_arm",
        sprite : spr_cata_left_arm,
        body_types:[2],
        armours : ["Cataphractii"],
        subcomponents : [
            [spr_blank,spr_cata_left_armtrim]
        ]
    },
    {
        position : "right_arm",
        sprite : spr_cata_right_arm,
        body_types:[2],
        armours : ["Cataphractii"],
        subcomponents : [
            [spr_blank,spr_cata_right_armtrim]
        ]
    }, 
    {
        position : "armour",
        sprite : spr_cata_complex,
        body_types:[2],
        armours : ["Cataphractii"],
        subcomponents : [
            [spr_cata_cowl_trim],
        ]
    },
    {
        position : "tabbard",
        sprite : spr_cata_tabbard_leather,
        body_types:[2],
        armours : ["Cataphractii"],
        subcomponents : [
            [spr_blank,spr_cata_tabbard_leather_hangings],
        ]
    },
    {

        position : "tabbard",
        sprite : spr_cata_tabbard_mail,
        body_types:[2],
        armours : ["Cataphractii"],
    },
    {
        position : "right_knee",
        sprite : spr_cata_right_knee,
        body_types:[2],
        armours : ["Cataphractii"],
        max_saturation : 50,
    }, 
    {
        position : "left_knee",
        sprite : spr_cata_left_knee,
        body_types:[2],
        armours : ["Cataphractii"],
        max_saturation : 50,
    },
    {
        position : "right_leg",
        sprite : spr_cata_right_leg,
        body_types:[2],
        armours : ["Cataphractii"],
        subcomponents : [
            [spr_blank,spr_cata_heavy_toe_right],
        ]
    }, 
    {
        position : "left_leg",
        sprite : spr_cata_left_leg,
        body_types:[2],
        armours : ["Cataphractii"],
        subcomponents : [
            [spr_blank,spr_cata_heavy_toe_left],
        ],
    },
    {
        position : "right_pauldron_embeleshments",
        sprite : spr_cata_shoulder_hanging_leather_right,
        body_types:[2],
        armours : ["Cataphractii"],
		subcomponents : [
            [spr_blank, spr_cata_shoulder_hanging_leather_right_tips],
        ],
		overides: {
			"left_pauldron_embeleshments" :
			spr_cata_shoulder_hanging_leather_left, 
			"tabbard": 
			spr_cata_tabbard_leather 
		},
        subcomponents : [
            [spr_blank, spr_cata_shoulder_hanging_leather_right_tips],
        ],
    },
    {
        position : "left_pauldron_embeleshments",
        sprite : spr_cata_shoulder_hanging_leather_left,
        body_types:[2],
        armours : ["Cataphractii"],
        subcomponents : [
            [spr_blank, spr_cata_shoulder_hanging_leather_left_tips],
        ],
    },
    {
		
        position : "right_pauldron_embeleshments",
        sprite : spr_cata_shoulder_hanging_mail_right,
        body_types:[2],
        armours : ["Cataphractii"],
		overides: {
			"left_pauldron_embeleshments" :
			spr_cata_shoulder_hanging_mail_left, 
			"tabbard": 
			spr_cata_tabbard_mail
        },
	},
	
    {
		
        position : "left_pauldron_embeleshments",
        sprite : spr_cata_shoulder_hanging_mail_left,
        body_types:[2],
        armours : ["Cataphractii"],
    },
    {
        sprite : spr_blank,
        body_types :[2],
        position : "left_trim",
        armours : ["Cataphractii"],
        subcomponents : [
            [spr_blank, spr_cata_left_trim],
            [spr_blank, spr_cata_left_trim_2],
            [spr_blank, spr_cata_left_trim_1],
        ],
    }, 
    {
        sprite : spr_blank,
        body_types :[2],
        position : "right_trim",
        armours : ["Cataphractii"],
        subcomponents : [
            [spr_blank, spr_cata_right_trim],
            [spr_blank, spr_cata_right_trim_2],
            [spr_blank, spr_cata_right_trim_1],
        ],
    },
    {
        position : "foreground_item",
        sprite: spr_gear_combat_shield,
        body_types: [0,1, 2],
        offsets : {
            "Terminator Armour" : {
                y : -10,
                x : -15,
            },
            "Tartaros" : {
                x : -8,
            }
        },
        subcomponents :[
           [spr_blank, spr_combat_shield_bottom_part],
        ],
        equipped : {
            "gear" : "Combat Shield",
        },
    },
    {
        position : "right_eye", 
        sprite : spr_gear_apoth_eye,
        role_type : [SPECIALISTS_APOTHECARIES],
        offsets : {
            "Terminator Armour":{
                y :-6,
            },
            "Tartaros":{
                y :-6,
            }
        }

    },
    {
        position : "backpack_decoration", 
        sprite : spr_gear_apoth,
        role_type : [SPECIALISTS_APOTHECARIES],
        offsets : {
            "Terminator Armour":{
                y :- 22,
            },
            "Tartaros":{
                y :- 30,
            }
        }

    },
    {
        position : "backpack_decoration", 
        sprite : spr_angelic_wings,
        body_types : [0,1],
        cultures : ["Angelic"],
        assign_by_rank : 2,
        equipment_has_tag : {
            "gear" : "jump",
        }
    },                                                    
];


function fetch_marine_components_to_memory(){
    array_foreach(global.modular_drawing_items, function(_element, _index){
        if (_element.position != "weapon" && sprite_exists((_element.sprite))){
            sprite_prefetch(_element.sprite);
            if (struct_exists(_element, "overides")){
                var _override_areas = struct_get_names(_element.overides);
                for (var i = 0;i<array_length(_override_areas);i++){
                    sprite_prefetch(_element.overides[$_override_areas[i]]);
                }
            }
        }
    });
}



function DummyMarine()constructor{
    static update = function(){
        delete body;
        body = generate_marine_body();
        add_purity_seal_markers();
    }
    personal_livery = {};
    if (obj_creation.chapter_name == "Deathwatch"){
        personal_livery.right_pauldron = irandom(30);
    }
    update();
    static distribute_traits = scr_marine_trait_spawning;
    base_group="astartes";
    static alter_equipment = alter_unit_equipment;
    static stat_display = scr_draw_unit_stat_data;
    static draw_unit_image = scr_draw_unit_image;
    static display_wepaons = scr_ui_display_weapons;
    static unit_profile_text = scr_unit_detail_text;
    static has_equipped = unit_has_equipped;
    static get_body_data = scr_get_body_data;
    traits = [];
    company = irandom_range(1,10);
    static name_role = function(){
        return "jeff";
    } 
    static role = function(){
        with (obj_creation){
            if (obj_creation.livery_selection_options.current_selection == 2){
                return role[100][livery_picker.role_set > 0  ? livery_picker.role_set :eROLE.Tactical];
            }else {
                return role[100][eROLE.Tactical];
            }
        }
    } 
    static weapon_one = function(){
        with (obj_creation){
            return wep1[100][livery_picker.role_set > 0  ? livery_picker.role_set :eROLE.Tactical];
        }
    } 
    static race = function(){
        return "1";
    }  
    static weapon_two = function(){
        with (obj_creation){
            return wep2[100][livery_picker.role_set > 0  ? livery_picker.role_set :eROLE.Tactical];
        }
    }  
    last_armour = "MK7 Aquila";
    static armour = function(){
        var armours = LIST_BASIC_POWER_ARMOUR;
        var _last_armour = last_armour;
        with (obj_creation){
            if (!livery_picker.freeze_armour){
                var _armour  = armour[100][livery_picker.role_set > 0  ? livery_picker.role_set : eROLE.Tactical];
                if (array_contains(armours, _armour) || _armour == STR_ANY_POWER_ARMOUR){
                     _armour = array_random_element(armours);
                } else if(array_contains(LIST_TERMINATOR_ARMOUR, _armour)||  _armour == STR_ANY_POWER_ARMOUR){
                    _armour = array_random_element(LIST_TERMINATOR_ARMOUR);
                }
                if (_armour == "Power Armour"){
                     _armour = "MK7 Aquila";
                }
            } else {
                _armour = _last_armour;
            }
            if (obj_creation.livery_selection_options.current_selection == 2){
                if (!array_contains(armours, _armour)){
                   _armour =  "MK7 Aquila";
                }
            }
        }
        last_armour = _armour;
        return _armour;
    } 
    static gear = function(){
         with (obj_creation){
            return gear[100][livery_picker.role_set > 0  ? livery_picker.role_set :eROLE.Tactical];
        }
    }
    static mobility_item = function(){
         with (obj_creation){
            return mobi[100][livery_picker.role_set > 0  ? livery_picker.role_set :eROLE.Tactical];
        }
    }
    static IsSpecialist = function(search_type=SPECIALISTS_STANDARD,include_trainee=false, include_heads=true){
        return is_specialist(role(), search_type,include_trainee, include_heads);
    }
    static has_trait = marine_has_trait;
    static is_dreadnought = function(){
        var _arm_data = gear_weapon_data("armour", last_armour);
        if (is_struct(_arm_data)){
            if (_arm_data.has_tag("dreadnought")){
                return true
            }
        }
        return false;
    }
    experience = 120;
    //get equipment data methods by deafult they garb all equipment data and return an equipment struct e.g new EquipmentStruct(item_data, core_type,quality="none")
    static get_armour_data = function(type = "all") {
        return gear_weapon_data("armour", armour(), type, false);
    };

    static get_gear_data = function(type = "all") {
        return gear_weapon_data("gear", gear(), type, false);
    };

    static get_mobility_data = function(type = "all") {
        return gear_weapon_data("mobility", mobility_item(), type, false);
    };

    static get_weapon_one_data = function(type = "all") {
        return gear_weapon_data("weapon", weapon_one(), type, false);
    };

    static get_weapon_two_data = function(type = "all") {
        return gear_weapon_data("weapon", weapon_two(), type, false);
    };

    static equipment_has_tag = function(tag, area){
        var tags = [];
        switch (area){
            case "wep1":
                tags = get_weapon_one_data("tags");
                break;
            case "wep2":
                tags = get_weapon_two_data("tags");
                break;
            case "mobi":
                tags = get_mobility_data("tags");
                break;
            case "armour":
                tags = get_armour_data("tags");
                break;
            case "gear":
                tags = get_gear_data("tags");
            break;
        }
        if (!is_array(tags) || array_length(tags) == 0){
            return false;
        } else {
            return array_contains(tags, tag);
        }
    }
}

function scr_get_body_data (body_item_key,body_slot="none"){
    if (body_slot!="none"){
        if (struct_exists(body, body_slot)){
            if (struct_exists(body[$ body_slot], body_item_key)){
                return body[$ body_slot][$ body_item_key]
            } else {
                return false;
            }
        }else {
            return "invalid body area";
        }
    } else {
        var item_key_map = {};
        var body_part_area_keys
        var _body_parts = ARR_body_parts;
        for (var i=0;i<array_length(_body_parts);i++){//search all body parts
            body_area = body[$ _body_parts[i]]
            body_part_area_keys=struct_get_names(body_area);
            for (var b=0;b<array_length(body_part_area_keys);b++){
                if (body_part_area_keys[b]==body_item_key){
                    item_key_map[$ _body_parts[i]] = body_area[$ body_item_key]
                }
            }
            
        }
        return item_key_map;
    }
    return false;
}


function generate_marine_body(){
    var _body = {
        "left_leg":{
            leg_variants: irandom(100),
            shin_variant : irandom(100),
            knee_variant: irandom(100),
        }, 
        "right_leg":{
            leg_variants: irandom(100),
            shin_variant : irandom(100),
            knee_variant: irandom(100),
        }, 
        "torso":{
            cloth:{
                variation:irandom(100),
            },
            tabbard_variation:irandom(100),
            armour_choice :  irandom(100),
            variation: irandom(10),
            backpack_variation: irandom(100),
            backpack_decoration_variation : irandom(100),
            backpack_augment_variation : irandom(100),
            thorax_variation : irandom(100),
            chest_variation : irandom(100),
            belt_variation : irandom(100),
            chest_fastening : irandom(100),
        }, 
        "left_arm":{
            trim_variation : irandom(100),
            personal_livery : irandom(100),
            pad_variation : irandom(100),
            variation : irandom(100),
            weapon_variation: irandom(100),
        },
        "right_arm":{
            trim_variation : irandom(100),
            personal_livery : irandom(100),
            pad_variation : irandom(100),
            variation : irandom(100), 
            weapon_variation: irandom(100),          
        }, 
        "left_eye":{
            variant : irandom(100),
        }, 
        "right_eye":{
            variant : irandom(100),
        },
        "throat":{
            variant : irandom(100),
            hanging_variant : irandom(100),
        }, 
        "jaw":{
            variant: irandom(100),
        },
        "head":{
            variation:irandom(100),
            crest_variation : irandom(100),
            forehead_variation : irandom(100),
            crown_variation : irandom(100),
        },
        "cloak":{
            type: "none",
            variant: irandom(100)
        },
    }
    return _body; 
}

function add_purity_seal_markers (){
    if (irandom(3)==0){
        body[$ "torso"][$ "purity_seal"] = [irandom(100),irandom(100),irandom(100),irandom(100)];
    }
    if (irandom(3)==0){
        body[$ "left_arm"][$ "purity_seal"] = [irandom(100),irandom(100),irandom(100),irandom(100)];
    }
    if (irandom(3)==0){
        body[$ "right_arm"][$ "purity_seal"] = [irandom(100),irandom(100),irandom(100),irandom(100)];
    }   
    if (irandom(3)==0){
        body[$ "left_leg"][$ "purity_seal"] = [irandom(100),irandom(100),irandom(100),irandom(100)];
    }
    if (irandom(3)==0){
        body[$ "right_leg"][$ "purity_seal"] = [irandom(100),irandom(100),irandom(100),irandom(100)];
    }       
}

function format_weapon_visuals(weapon_name){
    if (struct_exists(global.weapon_visual_data, weapon_name)){
        var _weapon_visual_data = global.weapon_visual_data[$ weapon_name];
    } else {
        return [];
    }
    var base_data = variable_clone(_weapon_visual_data.base);
    base_data.weapon_map = weapon_name;
    base_data.position = "weapon";
    var return_options = [];
    for (var i=0;i<array_length(_weapon_visual_data.variants);i++){
        var _variant = _weapon_visual_data.variants[i];
        var new_obj = variable_clone(base_data);
        var variant_keys = struct_get_names(_variant);
        var sprite = _variant.sprite
        for (var k=0;k<array_length(variant_keys);k++){
            var key = variant_keys[k];
            if (key != "weapon_data" && key != "sprite"){
                new_obj[$key] = _variant[$key];
            } else if (key == "weapon_data"){
                if (struct_exists(_variant, "weapon_data")){
                    var data_names = struct_get_names(_variant.weapon_data)
                    for (var n=0;n<array_length(data_names);n++){
                        var _name = data_names[n];
                        new_obj.weapon_data[$ _name] = _variant.weapon_data[$ _name];
                    }
                }
            }
            new_obj.weapon_data.sprite = _variant.sprite;
        }
        array_push(return_options, new_obj);
    }
    return return_options;
}
global.weapon_visual_data = {
	//30k weapons
	//Volkite Pack
"Volkite Charger": {
  base: {
    weapon_data: {
      display_type: "normal_ranged",
      new_weapon_draw: true
    },
  },
  variants: [{
    sprite: spr_weapon_volkite_charger,
  }]
},

"Volkite Serpenta": {
  base: {
    weapon_data: {
      display_type: "normal_ranged",
      new_weapon_draw: true
    },
  },
  variants: [{
    sprite: spr_weapon_volkite_serpenta,
  }]
},
 
"Volkite Caliver": {
  base: {
    weapon_data: {
      display_type: "ranged_twohand",
      new_weapon_draw: true
    },
    body_types: [0,1]
  },
  variants: [{
    sprite: spr_weapon_volkite_caliver,
  }]
},

"Volkite Culverin": {
  base: {
    weapon_data: {
      display_type: "terminator_ranged",
    },
    body_types: [2]
  },
  variants: [
    {
      sprite: spr_weapon_volkite_culverin_term
    },
    {
       weapon_data: {
          display_type: "ranged_twohand",
      },
      sprite: spr_weapon_volkite_culverin,
      body_types: [0, 1]
    }
  ]
},
//Bolter Pack
"Phobos Bolter": {
 base: {
    weapon_data: {
      display_type: "normal_ranged",
      new_weapon_draw: true
    },
  },
  variants: [{
    sprite: spr_weapon_phobos_bolter,
  }]
},
"Phobos Bolt Pistol": {
 base: {
    weapon_data: {
      display_type: "normal_ranged",
      new_weapon_draw: true
    },
  },
  variants: [{
    sprite: spr_weapon_phobos_boltpis,
  }]
},
"Mars Heavy Bolter": {
  base: {
    weapon_data: {
      display_type: "ranged_twohand",
      new_weapon_draw: true
    },
    body_types: [0,1]
  },
  variants: [{
    sprite: spr_weapon_mars_hbolt,
  }]
},
"Tigris Combi Bolter": {
 base: {
    weapon_data: {
      display_type: "normal_ranged",
      new_weapon_draw: true
    },
  },
  variants: [{
    sprite: spr_weapon_tigris_combi,
  }]
},
//Plasma Pack
"Ryza Plasma Gun": {
 base: {
    weapon_data: {
      display_type: "normal_ranged",
      new_weapon_draw: true
    },
  },
  variants: [{
    sprite: spr_weapon_ryza_plasg,
  }]
},
"Ryza Plasma Pistol": {
 base: {
    weapon_data: {
      display_type: "normal_ranged",
      new_weapon_draw: true
    },
  },
  variants: [{
    sprite: spr_weapon_ryza_plasp,
  }]
},
"Mars Plasma Cannon": {
 base: {
    weapon_data: {
      display_type: "ranged_twohand",
      new_weapon_draw: true
    },
    body_types: [0,1]
  },
  variants: [{
    sprite: spr_weapon_mars_plasc,
  }]
},
//Melta Pack
"Proteus Multi-Melta": {
 base: {
    weapon_data: {
      display_type: "ranged_twohand",
      new_weapon_draw: true
    },
    body_types: [0,1]
  },
  variants: [{
    sprite: spr_weapon_prot_mmlt,
  }]
},  
"Primus Melta Gun": {
base: {
    weapon_data: {
      display_type: "normal_ranged",
      new_weapon_draw: true
    },
  },
  variants: [{
    sprite: spr_weapon_prim_mltg,
  }]
},  
//Flamer Pack
"Phaestos Flamer": {
base: {
    weapon_data: {
      display_type: "normal_ranged",
      new_weapon_draw: true
    },
  },
  variants: [{
    sprite: spr_weapon_ph_flmr,
  }]
},
//melee pack  
"Power Scythe": {
base: {
    weapon_data: {
      display_type: "melee_onehand",
      hand_type: 2,
      new_weapon_draw: true
    },
  },
  variants: [
    {
      sprite: spr_weapon_powscythe
    }
  ]
},
//Laser pack
"Ryza Lascannon": {
 base: {
    weapon_data: {
      display_type: "ranged_twohand",
      new_weapon_draw: true
    },
    body_types: [0,1]
  },
  variants: [{
    sprite: spr_weapon_ryza_lasca,
  }]
},
//misc pack
"Cthon Autocannon": {
 base: {
    weapon_data: {
      display_type: "ranged_twohand",
      new_weapon_draw: true
    },
    body_types: [0,1]
  },
  variants: [{
    sprite: spr_weapon_cthon_autocannon,
  }]
},  
	
	//40k weapons
  "Assault Cannon": {
    base : {
        weapon_data:{
            display_type: "terminator_ranged",
            arm_type: 1,
            hand_type: 0,  
        },
        body_types: [2]  
    },
    variants : [{
      sprite: spr_weapon_assca,
    },
    {
      sprite: spr_weapon_assca,
      body_types: [3],
      armours : ["Dreadnought"],
      new_weapon_draw: true
    }],
    },
"Heavy Flamer": {
  base: {
    weapon_data: {
      arm_type: 1,
      hand_type: 0
    },
    body_types: [2]
  },
  variants: [{
    sprite: spr_weapon_hflamer_term
  }, {
    weapon_data: {
      display_type: "ranged_twohand",
    },
    sprite: spr_weapon_hflamer,
    body_types: [0, 1]
  }]
},
"Lascannon":{
    base: {
        body_types: [0, 1],
        weapon_data: {
          display_type: "ranged_twohand",
        },
    },
    variants: [
        {
            sprite: spr_weapon_lasca,
        },
        {
          sprite: spr_dread_lascannon,
          body_types: [3],
          armours : ["Dreadnought"],
          new_weapon_draw: true
        }
    ],
},
"Close Combat Weapon" : {
    base: {
        body_types: [3],
        weapon_data: {
          display_type: "dreadnought",
        },
        armours : ["Dreadnought"],
        new_weapon_draw: true
    },
    variants: [
        {
            sprite: spr_dread_claw,
        },
        {
            sprite: spr_contemptor_CCW,
            armours : ["Contemptor Dreadnought"],
        }
    ]    
},
"Twin Linked Heavy Bolter" : {
    base: {
        body_types: [3],
        weapon_data: {
          display_type: "dreadnought",
        },
    },
    variants: [
        {
            sprite: spr_dread_heavy_bolter,
        }
    ]    
},
"Dreadnought Lightning Claw": {
    base: {
        body_types: [3],
        weapon_data: {
          display_type: "dreadnought",
        },
    },
    variants: [
        {
            sprite: spr_dread_claw,
        }
    ]    
},
"CCW Heavy Flamer": {
    base: {
        body_types: [3],
        weapon_data: {
          display_type: "dreadnought",
        },
    },
    variants: [
        {
            sprite: spr_dread_claw,
        }
    ]    
},
"Dreadnought Power Claw": {
    base: {
        body_types: [3],
        weapon_data: {
          display_type: "dreadnought",
        },
    },
    variants: [
        {
            sprite: spr_dread_claw,
        }
    ]    
},
"Inferno Cannon": {
    base: {
        body_types: [3],
        weapon_data: {
          display_type: "dreadnought",
        },
    },
    variants: [
        {
            sprite: spr_dread_plasma_cannon,
        }
    ]    
},
"Multi-Melta" : {
    base: {
        body_types: [0, 1],
        weapon_data: {
          display_type: "ranged_twohand",
        },
    },
    variants: [
        {
            sprite: spr_weapon_mmelta,
        },
        {
            sprite: spr_dread_plasma_cannon,
            body_types: [3],
            armours : ["Dreadnought"],
            new_weapon_draw: true
        }        
    ],       
},
"Twin Linked Lascannon": {
    base: {
        body_types: [3],
        weapon_data: {
          display_type: "dreadnought",
        },
    },
    variants: [
        {
            sprite: spr_dread_lascannon,
        }
    ]    
},
"Heavy Conversion Beam Projector":{
    base: {
        body_types: [3],
        weapon_data: {
          display_type: "dreadnought",
        },
    },
    variants: [
        {
            sprite: spr_dread_plasma_cannon,
        }
    ]    
},
"Twin-linked Volkite Culverins":{
     base: {
        body_types: [3],
        weapon_data: {
          display_type: "dreadnought",
        },
    },
    variants: [
        {
            sprite: spr_twl_Volkite_Culverins,
        }
    ]    
},
"Bolt Pistol": {
  base: {
    weapon_data: {
      display_type: "normal_ranged",
      new_weapon_draw: true
    },
  },
  variants: [{
    sprite: spr_weapon_boltpis,
  }],
},

"Infernus Pistol": {
  base: {
    weapon_data: {
      display_type: "normal_ranged",
      new_weapon_draw: true
    },
  },
  variants: [{
    sprite: spr_weapon_inferno,
  }]
},

"Bolter": {
  base: {
    weapon_data: {
      display_type: "normal_ranged",
      new_weapon_draw: true
    },
  },
  variants: [{
    sprite: spr_weapon_bolter,
  }]
},

"Storm Bolter": {
  base: {
    weapon_data: {
      display_type: "normal_ranged",
      new_weapon_draw: true
    },
  },
  variants: [{
    sprite: spr_weapon_sbolter,
  }]
},

"Plasma Gun": {
  base: {
    weapon_data: {
      display_type: "normal_ranged",
      new_weapon_draw: true      
    },
  },
  variants: [{
    sprite: spr_weapon_plasg,
  }]
},

"Plasma Pistol": {
  base: {
    weapon_data: {
      display_type: "normal_ranged",
      new_weapon_draw: true      
    },
  },
  variants: [{
    sprite: spr_weapon_plasp,
  }]
},

"Meltagun": {
  base: {
    weapon_data: {
      display_type: "normal_ranged",
      new_weapon_draw: true      
    },
  },
  variants: [{
    sprite: spr_weapon_melta,
  }]
},

"Flamer": {
  base: {
    weapon_data: {
      display_type: "normal_ranged",
      new_weapon_draw: true      
    },
  },
  variants: [{
    sprite: spr_weapon_flamer,
  }]
},

"Stalker Pattern Bolter": {
  base: {
    weapon_data: {
      display_type: "normal_ranged",
      new_weapon_draw: true      
    },
  },
  variants: [{
    sprite: spr_weapon_stalker,
  }]
},

"Combiplasma": {
  base: {
    weapon_data: {
      display_type: "normal_ranged",
      new_weapon_draw: true
    },
  },
  variants: [{
    sprite: spr_weapon_complas,
  }]
},

"Combiflamer": {
  base: {
    weapon_data: {
      display_type: "normal_ranged",
      new_weapon_draw: true
    },
  },
  variants: [{
    sprite: spr_weapon_comflamer,
  }]
},

"Combigrav": {
  base: {
    weapon_data: {
      display_type: "normal_ranged",
      new_weapon_draw: true
    },
  },
  variants: [{
    sprite: spr_weapon_comgrav,
  }]
},

"Combimelta": {
  base: {
    weapon_data: {
      display_type: "normal_ranged",
      new_weapon_draw: true
    },
  },
  variants: [{
    sprite: spr_weapon_commelta,
  }]
},

"Grav-Pistol": {
  base: {
    weapon_data: {
      display_type: "normal_ranged",
      new_weapon_draw: true
    },
  },
  variants: [{
    sprite: spr_weapon_grav_pistol,
  }]
},

"Grav-Gun": {
  base: {
    weapon_data: {
      display_type: "normal_ranged",
      new_weapon_draw: true
    },
  },
  variants: [{
    sprite: spr_weapon_grav_gun,
  }]
},

"Hand Flamer": {
  base: {
    weapon_data: {
      display_type: "normal_ranged",
      new_weapon_draw: true
    },
  },
  variants: [{
    sprite: spr_weapon_hand_flamer,
  }]
},

"Missile Launcher": {
  base: {
    weapon_data: {
      display_type: "normal_ranged",
      new_weapon_draw: true
    },
  },
  variants: [
    {
        sprite: spr_weapon_missile,
    },
    {
        sprite: spr_dread_missile,
        body_types: [3],
        armours : ["Dreadnought"],
        new_weapon_draw: true
    }
  ]
},
"Plasma Cannon": {
  base: {
    weapon_data: {
      display_type: "terminator_ranged",
    },
    body_types: [2]
  },
  variants: [
    {
      sprite: spr_weapon_plasma_cannon_term
    },
    {
       weapon_data: {
          display_type: "ranged_twohand",
      },
      sprite: spr_weapon_plasc,
      body_types: [0, 1]
    },
    {
        sprite: spr_dread_plasma_cannon,
        body_types: [3],
        armours : ["Dreadnought"],
        new_weapon_draw: true
    }
  ]
},

"Grav-Cannon": {
  base: {
    weapon_data: {
      display_type: "terminator_ranged",
    },
    body_types: [2]
  },
  variants: [
    {
      sprite: spr_weapon_plasma_cannon_term
    },
    {
       weapon_data: {
          display_type: "ranged_twohand",
      },
      sprite: spr_weapon_grav_cannon,
      body_types: [0,1]
    }
  ]
},

"Power Fist": {
  base: {
    weapon_data: {
      display_type: "terminator_fist",
    },
    body_types: [2]
  },
  variants: [
    {
      sprite: spr_weapon_powfist4
    },
    {
      sprite: spr_weapon_powfist,
      body_types: [0, 1],
      weapon_data: {
          display_type: "normal_fist",
      }
    }
  ]
},

"Lightning Claw": {
  base: {
    weapon_data: {
      display_type: "terminator_fist",
    },
    body_types: [2]
  },
  variants: [
    {
      sprite: spr_weapon_lightning2
    },

    {
      sprite: spr_weapon_lightning1,
      body_types: [0, 1],
      weapon_data: {
        display_type: "normal_fist",
      }
    }
  ]
},
"Boltstorm Gauntlet": {
  base: {
    weapon_data: {
      display_type: "normal_fist",
      arm_type: 1
    },
    body_types: [0, 1]
  },
  variants: [
    {
      sprite: spr_weapon_boltstorm_gauntlet_small,
    },
    {
        sprite: spr_weapon_boltstorm_gauntlet,
        body_types: [2],
        weapon_data: {
            display_type: "terminator_fist",
        }
    }
  ]
},
 "Xenophase Blade": {
  base: {
    weapon_data: {
      display_type: "melee_onehand",
      hand_type: 2,
      new_weapon_draw: true
    },
  },
  variants: [
    {
      sprite: spr_weapon_xenophase_blade_var1
    }
  ]
},

"Chainfist": {
  base: {
    weapon_data: {
      display_type: "normal_fist",
      arm_type: 1
    },
    body_types: [0, 1]
  },
  variants: [
    {
      sprite: spr_weapon_chainfist_small
    },
    {
      sprite: spr_weapon_chainfist,
        weapon_data: {
          display_type: "terminator_fist",
        },
        body_types: [2]
    }
  ]
},

"Assault Chainfist": {
  base: {
    weapon_data: {
      display_type: "normal_fist",
      arm_type: 1
    },
    body_types: [0, 1]
  },
  variants: [
    {
      sprite: spr_weapon_chainfist_small
    }
  ]
},

"Heavy Thunder Hammer": {
  base: {
    weapon_data: {
      display_type: "melee_twohand",
      hand_type : 0,
      ui_twoh: true
    },
  },
  variants: [
    {
      sprite: spr_weapon_hthhammer
    }
  ]
},

"Sniper Rifle": {
  base: {
    weapon_data: {
      display_type: "melee_twohand",
      new_weapon_draw: true,
    },
  },
  variants: [
    {
      sprite: spr_weapon_sniper
    }
  ]
},

"Autocannon": {
  base: {
    weapon_data: {
      display_type: "melee_twohand",
      new_weapon_draw: true,
    },
  },
  variants: [
    {
      sprite: spr_weapon_autocannon2
    },
    {
        sprite: spr_dread_autocannon,
        body_types: [3],
        armours : ["Dreadnought"],
        new_weapon_draw: true
    }
  ]
},

"Storm Shield": {
  base: {
    weapon_data: {
      display_type: "shield",
    },
  },
  variants: [
    {
      cultures: ["Knightly"],
      sprite: spr_weapon_storm
    },
    {
      sprite: spr_weapon_storm_tall
    },
    {
      sprite: spr_weapon_storm_tall_2
    },
    {
      sprite: spr_weapon_storm2
    }
  ]
},

"Boarding Shield": {
  base: {
    weapon_data: {
      display_type: "shield",
    },
  },
  variants: [
    {
      sprite: spr_weapon_boarding
    }
  ]
},

"Infernus Heavy Bolter": {
  base: {
    weapon_data: {
      display_type: "ranged_twohand",
    },
  },
  variants: [
    {
      sprite: spr_weapon_infernus_hbolt
    }
  ]
},
"Heavy Bolter": {
  base: {
    weapon_data: {
      display_type: "ranged_twohand",
    },
  },
  variants: [
    {
      sprite: spr_weapon_hbolt
    }
  ]
},

"Company Standard": {
  base: {
    weapon_data: {
      hand_on_top: true,
      display_type: "melee_onehand"
    },
  },
  variants: [
    {
      cultures: ["Knightly"],
      sprite: spr_da_standard
    },
    {
      sprite: spr_weapon_standard2
    },
  ]
},

"Chainsword": {
  base: {
    weapon_data: {
      display_type: "melee_onehand",
      hand_type: 2,
      new_weapon_draw: true
    },
  },
  variants: [
    {
      sprite: spr_weapon_chsword
    }
  ]
},

"Combat Knife": {
  base: {
    weapon_data: {
      display_type: "melee_onehand",
      hand_type: 2,
      new_weapon_draw: true
    },
  },
  variants: [
    {
      sprite: spr_weapon_knife
    }
  ]
},

"Power Sword": {
  base: {
    weapon_data: {
      display_type: "melee_onehand",
      hand_type: 2,
      new_weapon_draw: true
    },
  },
  variants: [
    {
      sprite: spr_weapon_powswo
    },
    {
      cultures: ["Mongol"],
      sprite: spr_weapon_sword_turk
    },
    {
      cultures: ["Mongol"],
      sprite: spr_weapon_sword_oriental
    },
    {
      cultures: ["Alpha"],
      sprite: spr_weapoon_powso_flamberge
    }
  ]
},
"Eviscerator" : {
    base: {
    weapon_data: {
      display_type: "melee_onehand",
      hand_type: 0,
      new_weapon_draw: true
    }, 
   },
     variants: [{
        sprite: spr_weapon_evisc
     }]
},

"Eldar Power Sword": {
  base: {
    weapon_data: {
      hand_on_top: true,
      display_type: "melee_onehand"
    },
  },
  variants: [
    {
      sprite: spr_weapon_eldsword
    }
  ]
},

"Power Spear": {
  base: {
    weapon_data: {
      display_type: "melee_onehand",
      hand_type: 2,
      new_weapon_draw: true
    },
  },
  variants: [
    {
      sprite: spr_weapon_powspear
    }
  ]
},

"Thunder Hammer": {
  base: {
    weapon_data: {
      display_type: "melee_onehand",
      hand_type: 2
    },
  },
  variants: [
    {
      sprite: spr_weapon_thhammer
    }
  ]
},

"Power Axe": {
  base: {
    weapon_data: {
      display_type: "melee_onehand",
      hand_type: 3,
      arm_type : 3,
      new_weapon_draw: true
    },
  },
  variants: [
    {
      sprite: spr_weapon_powaxe
    }
  ]
},
"Power Mace": {
  base: {
    weapon_data: {
      display_type: "melee_onehand",
      hand_type: 3,
      arm_type : 3,
      new_weapon_draw: true
    },
  },
  variants: [
    {
      sprite: spr_weapon_powmace
    },
  ]
},
"Mace of Absolution": {
  base: {
    weapon_data: {
      display_type: "melee_onehand",
      hand_type: 3,
      arm_type : 3,
      new_weapon_draw: true
    },
  },
  variants: [
    {
      sprite: spr_weapon_mace_of_absolution
    }
  ]
},

"Crozius Arcanum": {
  base: {
    weapon_data: {
      hand_on_top: true,
      display_type: "melee_onehand",
      hand_type: 3,
      arm_type : 3,      
    },
  },
  variants: [
    {
      sprite: spr_weapon_crozarc
    }
  ]
},

"Chainaxe": {
  base: {
    weapon_data: {
      display_type: "melee_onehand",
      hand_type: 3,
      arm_type : 3,
      new_weapon_draw: true
    },
  },
  variants: [
    {
      sprite: spr_weapon_chaxe
    }
  ]
},

"Force Staff": {
  base: {
    weapon_data: {
      display_type: "melee_onehand",
      hand_type: 2,
      new_weapon_draw: true
    },
  },
  variants: [
    {
      sprite: spr_weapon_frcstaff
    }
  ]
},

"Force Sword": {
  base: {
    weapon_data: {
      display_type: "melee_onehand",
      hand_type: 2,
      new_weapon_draw: true
    },
  },
  variants: [
    {
      sprite: spr_weapon_frcsword
    }
  ]
},

"Force Axe": {
  base: {
    weapon_data: {
      display_type: "melee_onehand",
      hand_type: 3,
      arm_type : 3,
      new_weapon_draw: true
    },
  },
  variants: [
    {
      sprite: spr_weapon_frcaxe,
    }
  ]
},

"Relic Blade": {
  base: {
    weapon_data: {
      hand_on_top: true,
      display_type: "melee_onehand",
      hand_type: 3,
      arm_type : 3,      
    },
  },
  variants: [
    {
      sprite: spr_weapon_relic_blade
    }
  ]
}
}

