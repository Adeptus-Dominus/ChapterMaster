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
            if (directory_exists(_sepcific_vis_set)){
                var _data_buffer = buffer_load($"{_sepcific_vis_set}\\data.json");
                if (_data_buffer == -1) {
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
}

function load_vis_set_to_global(directory, data){
    for (var i=0;i<array_length(data); i++){
        var _sprite_item = data[i];
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
                _s_data.sprite = _new_sprite;
                array_push(global.modular_drawing_items, _s_data);
            }
        }
    }
}
global.modular_drawing_items = [
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
        role_type : ["forge"],
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
        role_type : ["forge"],
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
        chapter_adv : ["Reverent Guardians"],
        sprite : spr_pack_brazier3,
        body_types :[0],
        position : "backpack",
        assign_by_rank : 4,
    },
    {
        sprite : spr_gear_librarian,
        body_types :[0],
        position : "right_pauldron",
        role_type : ["libs"],
    },
    {
        sprite : spr_gear_librarian_term,
        body_types :[2],
        position : "right_pauldron",
        role_type : ["libs"],
    },
    {
        sprite : spr_roman_centurian_crest,
        body_types :[0],
        cultures : ["Roman", "Greek", "Gladiator"],
        position : "crest",
        role_type : ["captain_candidates"],
        assign_by_rank : 2,
    },
    {
        sprite : spr_purity_seal,
        body_types :[0,2],
        position : "purity_seals",
    },
    {
        sprite : spr_marksmans_honor,
        body_types :[0,2],
        position : "purity_seals",
        stats : [["ballistic_skill", 50, "exmore"]]
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
        sprite : spr_mk7_complex_crux_belt,
        body_types :[0, 2],
        position : "belt",
        armours : ["MK5 Heresy", "MK6 Corvus","MK7 Aquila", "MK8 Errant", "Artificer Armour", "Tartaros"],
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
        role_type : ["chap"],
        armours : ["MK5 Heresy", "MK6 Corvus","MK7 Aquila", "MK8 Errant", "Artificer Armour"],  
    },
    {
        sprite : spr_tech_belt,
        body_types :[0],
        position : "belt",
        role_type : ["forge"],
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
            "right_pauldron" : spr_ultra_right_shoulder_hanging,
        },
        assign_by_rank :1,
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
        armours_exclude : ["MK3 Iron Armour", "MK4 Maximus"],
        exp : {
            min : 100,
        },        
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

    }                                                       

];
try{
    load_visual_sets();
} catch(_exception){
    handle_exception(_exception);
}