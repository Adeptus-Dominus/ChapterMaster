enum eCHAPTER_TRAIT_TYPE{
    DISADV,
    ADV
}

function selected_chapter_trait(trait){
    var _array = array_join(obj_creation.all_advantages,obj_creation.all_disadvantages);
    for (var i=0;i<array_length(_array);i++){
        if (_array[i].name == trait){
            if (_array[i].activated){
                return true;
            }
        }
    }

    return false;
}

function ChapterTrait(trait) constructor {
    effects = "";
    meta = [];
    faction_disp_mods = [];
    suspicion = 0;

    disabled = false;

    activated = false;

    character_spawn_increase = [];
    character_spawn_decrease = [];

    move_data_to_current_scope(trait);

    static evaluate_unit_trait = function(initial_rate, data, trait_name){

        if (data[0] != name){
            return;
        }

        var _edited_rate = data[1][0]/data[1][1];
        if (_edited_rate > initial_rate){
            array_push(character_spawn_increase, trait_name);
        } else{
            array_push(character_spawn_decrease, trait_name);
        }

    }
    var _unit_traits = global.astartes_trait_dist;

    for (var i=0;i<array_length(global.astartes_trait_dist);i++){
        var _trait_data = _unit_traits[i];
        var _trait_id = _trait_data[0];

        if (!struct_exists(global.trait_list, _trait_id)){
            continue;
        }

        var _display_name =  global.trait_list[$ _trait_id].display_name;

        if (array_length(_trait_data) < 3) {
            continue;
        }
        var _trait_spawn_mods = _trait_data[2];
        if (!is_struct(_trait_spawn_mods)) {
            continue;
        }

        var _initial_rate = _trait_data[1][0]/_trait_data[1][1]

        if (struct_exists(_trait_spawn_mods, "disadvantage")) {
            evaluate_unit_trait(_initial_rate, _trait_spawn_mods.disadvantage, _display_name)
        }
        if (struct_exists(_trait_spawn_mods, "advantage")) {
            evaluate_unit_trait(_initial_rate, _trait_spawn_mods.advantage, _display_name)
        }
    }

    static effects_string = function(){

        var _str = "";

        var _fac_names = FACTION_NAMES;

        // --- Faction disposition mods ---
        if (is_array(faction_disp_mods) && array_length(faction_disp_mods) > 0){

            for (var i = 0; i < array_length(faction_disp_mods); i++){
                var _mod = faction_disp_mods[i];

                if (!struct_exists(_mod, "faction")) continue;

                var _line = "";

                if (struct_exists(_mod, "int_mod") && _mod.int_mod != 0){
                    _line += $"  Disposition Gains : {string_plus_minus(_mod.int_mod)}{_mod.int_mod}\n";
                }

                if (struct_exists(_mod, "mult") && _mod.mult != 1){
                    if (_line != "") _line += " ";
                    _line += $"  Disposition Multiplyers x{_mod.mult}\n";
                }

                if (struct_exists(_mod, "start_disp") && _mod.start_disp != 0){
                    if (_line != "") _line += " ";
                    _line += $"  Disposition Start {string_plus_minus(_mod.start_disp)}{_mod.start_disp}\n";
                }

                if (_line != ""){
                    _str += $"Faction {_fac_names[_mod.faction]}:\n{_line}\n";
                }
            }
        }

        // --- Equipment tag mods ---
        if (struct_exists(self, "equip_tag")){

            var _tags = struct_get_names(equip_tag);

            for (var t = 0; t < array_length(_tags); t++){
                var _tag_name = _tags[t];
                var _tag_data = equip_tag[$ _tag_name];

                var _chars = struct_get_names(_tag_data);

                for (var c = 0; c < array_length(_chars); c++){
                    var _char = _chars[c];
                    var _char_data = _tag_data[$ _char];

                    var _line = "";

                    if (struct_exists(_char_data, "mult")){
                        _line += $"   X{_char_data.mult}";
                    }

                    if (struct_exists(_char_data, "int_mod")){
                        if (_line != "") _line += " ";
                        _line += $"  {string_plus_minus(_char_data.int_mod)}{_char_data.int_mod}";
                    }

                    if (_line != ""){
                        _str += $"{_tag_name}:{_char}{_line}\n";
                    }
                }
            }
        }

        for (var i=0 ; i<array_length(effects);i++){
            _str += effects[i] + "\n";
        }

        if (suspicion != 0){
            _str += $"Suspicion: { string_plus_minus(suspicion) }{suspicion}\n";
        }

        if (array_length(character_spawn_increase)){
            _str += $"Increases Character trait spawns : {character_spawn_increase}\n"
        }

        if (array_length(character_spawn_decrease)){
            _str += $"Decrease Character trait spawns : {character_spawn_decrease}\n"
        }
        return _str;
    }

    static main_tool_tip = function(){
        return $"{name} ({points})";
    }
    static data_tool_tip = function(){
        return $"{description} \nCategories: {print_meta()}\n\nEffects:\n{effects_string()}";
    }

    static alter_starting_dispositions = function(){
        for (var i = 0; i < array_length(faction_disp_mods) ; i++){
            var _mod = faction_disp_mods[i];
            if (struct_exists(_mod, "start_disp")){
                obj_creation.disposition[_mod.faction] += _mod.start_disp;
            }
        }
    }


    static add_meta = function() {
        for (var i = 0; i < array_length(meta); i++) {
            array_push(obj_creation.chapter_trait_meta, meta[i]);
        }
    };

    static remove_meta = function() {
        for (var i = 0; i < array_length(meta); i++) {
            var len = array_length(obj_creation.chapter_trait_meta);
            for (var s = 0; s < len; s++) {
                if (obj_creation.chapter_trait_meta[s] == meta[i]) {
                    array_delete(obj_creation.chapter_trait_meta, s, 1);
                    s--;
                    len--;
                }
            }
        }
    };

    static print_meta = function() {
        if (array_length(meta) == 0) {
            return "None";
        } else {
            return string_join_ext(", ", meta);
        }
    };
}

function Advantage(trait) : ChapterTrait(trait) constructor {
    static id_start = 1
    LOGGER.info(id_start);
    id = id_start;
    id_start++;
    static add = function() {
        obj_creation.points += points;
        activated = true;
        add_meta();
    };

    static remove = function() {
        obj_creation.points -= points;
        activated = false;
        remove_meta();
    };

    static disable = function() {
        var is_disabled = false;
        for (var i = 0; i < array_length(meta); i++) {
            if (array_contains(obj_creation.chapter_trait_meta, meta[i])) {
                is_disabled = true;
            }
        }
        if (obj_creation.points + points > obj_creation.maxpoints) {
            is_disabled = true;
        }
        return is_disabled;
    };
}

function Disadvantage(trait) : ChapterTrait(trait) constructor {
    static id_start = 1
    LOGGER.info(id_start);
    id = id_start;
    id_start++;
    static add = function() {
        obj_creation.points -= points;
        activated = true;
        add_meta();
    };

    static remove = function() {
        obj_creation.points += points;
        activated = false;
        remove_meta();
    };

    static disable = function() {
        var is_disabled = false;
        for (var i = 0; i < array_length(meta); i++) {
            if (array_contains(obj_creation.chapter_trait_meta, meta[i])) {
                is_disabled = true;
            }
        }
        return is_disabled;
    };
}

// TODO all the chapter start data should be ramed in here as well rather than being hardcoded

function generate_disadvantages(){
    return json_to_gamemaker(working_directory + $"main\\chapter_disadvantages.json", json_parse);
}

function generate_advantages(){
    return json_to_gamemaker(working_directory + $"main\\chapter_advantages.json", json_parse);
}


function setup_chapter_traits(){
    Advantage.id_start = 1;
    Disadvantage.id_start = 1;
    
    obj_creation.all_advantages = [];
    var all_advantages = generate_advantages();

    var new_adv, cur_adv;
    for (var i = 0; i < array_length(all_advantages); i++) {
        cur_adv = all_advantages[i];
        new_adv = new Advantage(cur_adv);
        if (struct_exists(cur_adv, "meta")) {
            new_adv.meta = cur_adv.meta;
        }
        array_push(obj_creation.all_advantages, new_adv);
    }

    //advantage[i]="Battle Cousins";
    //advantage_tooltip[i]="NOT IMPLEMENTED YET.";i+=1;
    //advantage[i]="Comrades in Arms";
    //advantage_tooltip[i]="NOT IMPLEMENTED YET.";i+=1;

    /// @type {Array<Struct.Disadvantage>}
    var all_disadvantages = generate_disadvantages();

    obj_creation.all_disadvantages = [];
    var new_dis, cur_dis;
    for (var i = 0; i < array_length(all_disadvantages); i++) {
        cur_dis = all_disadvantages[i];
        new_dis = new Disadvantage(cur_dis);
        if (struct_exists(cur_dis, "meta")) {
            new_dis.meta = cur_dis.meta;
        }
        array_push(obj_creation.all_disadvantages, new_dis);
    }
}



// with a mult mod both losses and gains are limited or amlplified with a faction
// with  mult_mod changes are modified in both directions
// ergo mult mods are usefull where you might wish to show your chapter is polarising or
// that factions are apathetic to you lleading to reductions in chages all around
// also consider the factin involved with a mult mod for example a positive ult with the mechanicus
// might be appropriate for a tech chapter as their jealousy ay cause themm to have bigger negative
// as well as positive swings for a chapter they deem an ally but alsso competition
// comparativly int changes show a general negative or general positive perception towards you're chapter
// they are therefor comparativly more simple too apply 
// a positive mod will never taake a negative disp gain above zero
// a negative mod will never take a possitive disp gain below 0
// please also take into account 
function ChapterGameData (data = {}) constructor{

    chapter_suspicion = 0;

    faction_disp_mods = array_create(14, {
        "int_mod" : 0,
        "mult" : 1
    });

    equipment_tag_mods = {};

    move_data_to_current_scope(data);

    static merge_mods = function(mod_1, mod_2){
        if (struct_exists(mod_2, "int_mod")){
            if (struct_exists(mod_1, "int_mod")){
                mod_1.int_mod += mod_2.int_mod;
            } else {
                mod_1.int_mod = mod_2.int_mod;
            }
        } 

        if (struct_exists(mod_2, "mult")){
            if (struct_exists(mod_1, "mult")){
                mod_1.mult *= mod_2.mult;
            } else {
                mod_1.mult = mod_2.mult;
            }
        }      
    }

    static add_trait_data = function(trait){

        if (struct_exists(trait, "faction_disp_mods")) {
            for (var i = 0; i < array_length(trait.faction_disp_mods); i++){
                var _mods = trait.faction_disp_mods[i];
                var _faction_mod = faction_disp_mods[_mods.faction];
                merge_mods(_faction_mod, _mods);
            }
        }

        if (struct_exists(trait, "equip_tag")){ 
            var _all_tags = trait.equip_tag;
            var _items = struct_get_names(_all_tags);

            for (var i=0; i < array_length(_items); i++){
                var _item_name = _items[i];

                var _item = _all_tags[$ _item_name];
                

                if (!struct_exists(equipment_tag_mods, _item_name)){
                    equipment_tag_mods[$ _item_name] = {};
                }

                var _tags = struct_get_names(_item);
                var _current_tag_data = equipment_tag_mods[$ _item_name];

                for (var s = 0; s < array_length(_tags); s++){
                    var _char = _tags[s];

                    var _entry = variable_clone(_item[$ _char]);
                    _entry.name = trait.name;

                    if (!struct_exists(_current_tag_data, _char)){
                        _current_tag_data[$ _char] = [];
                    }

                    array_push(_current_tag_data[$ _char], _entry);
                }
            }
        }

        if (struct_exists(trait, "suspicion")){
            chapter_suspicion = clamp(chapter_suspicion + trait.suspicion, -5, 5);
        }

    }

    static calc_final_disp_value = function(faction, alter_value){
        var _mods = faction_disp_mods[faction];

        if (_mods.int_mod != 0){
            if (alter_value > 0){
                alter_value = max(0, alter_value + _mods.int_mod); 
            } else {
                alter_value = min(0, alter_value + _mods.int_mod); 
            }
        }

        if (_mods.mult > 1){
            alter_value = ceil(alter_value * _mods.mult);
        } else if (_mods.mult < 1){
            alter_value = floor(alter_value * _mods.mult);
        }

        return alter_value;
    }

    static calc_equipment_tag_mods = function(tags, characteristic){

        var _final_result = {
            mult : 0,
            int_mod : 0,
            descriptions : ""
        };

        for (var t = 0; t < array_length(tags); t++){

            var _tag = tags[t];

            LOGGER.info($"{_tag} : {equipment_tag_mods}");

            
            if (!struct_exists(equipment_tag_mods, _tag)){
                continue; 
            }


            var _tag_data = equipment_tag_mods[$ _tag];

            if (!struct_exists(_tag_data, characteristic)){
                continue; 
            }

            var _characteristic_data = _tag_data[$ characteristic];

            for (var i = 0; i < array_length(_characteristic_data); i++){
                var _c = _characteristic_data[i];

                if (struct_exists(_c, "mult")){
                    _final_result.mult += (_c.mult - 1);
                    _final_result.descriptions += $"{_c.name}:X{_c.mult}\n"; // fixed
                }

                if (struct_exists(_c, "int_mod")){
                    _final_result.int_mod += _c.int_mod; // fixed
                    _final_result.descriptions += $"{_c.name}:{string_plus_minus(_c.int_mod)}{_c.int_mod}\n"; // fixed
                }
            }
        }

        return _final_result;
    }
}

function draw_chapter_trait_list(type){

    add_draw_return_values();


    if (type){
        var _list = obj_creation.all_advantages;
    } else {
        var _list = obj_creation.all_disadvantages;
    }

    var _title = type ? "Advantages" : "Disadvantage";
	
    draw_set_font(fnt_40k_30b);
    draw_set_halign(fa_center);
    draw_text_transformed(800, 211, $"Select a {_title}", 0.6, 0.6, 0);
    draw_set_font(fnt_40k_14b);
    draw_set_halign(fa_left);
    for (var slot = 0; slot < array_length(_list); slot++) {
        var _trait = _list[slot];
        var column = {
            x1: 436,
            y1: 250,
            w: 100,
            h: 20,
        };
        column.x2 = column.x1 + column.w;
        column.y2 = column.y1 + column.h;
        var disable = 0;
        if (_trait.name == "") {
            continue;
        }
        var _trait_name = _trait.name;
        //columns of 14, shift the left boarder across and leave a gap at the top on cols 2 & 3
        if (slot >= 15 && slot < 29) {
            column.x1 = 670;
            column.x2 = column.x1 + column.w;
        }
        if (slot >= 29 && slot < 42) {
            column.x1 = 904;
            column.x2 = column.x1 + column.w;
        }
        draw_set_color(CM_GREEN_COLOR);

        disable = _trait.disable() || _trait.activated;

        if (!disable) {
            disable = _trait_name == "Blood Debt" && fleet_type == 3;
        }

        draw_set_alpha(disable ? 0.5 : 1);

        var gap = ((slot - 1) % 14) * column.h;

        draw_text(column.x1, column.y1 + gap, _trait_name);

        var dis_width = string_width(_trait_name);

        var coords = [
            column.x1,
            column.y1 + gap,
            column.x1 + dis_width,
            column.y1 + column.h + gap
        ];

        //Tooltip
        if (scr_hit(coords)) {
            tooltip = _trait.main_tool_tip();
            tooltip2 = _trait.data_tool_tip();                 
            draw_set_color(c_white);
            draw_set_alpha(0.2);
            draw_text(column.x1, column.y1 + gap, _trait_name);

            //Click on disadvantage
            if (!disable &&  mouse_button_clicked()) {
                popup = "";
                _trait.add();
            }
        }
    }
    pop_draw_return_values();
}


function draw_selected_chapter_traits(type){

    //advatages positive disssadvatages negative type
    var _title = type ? "Advantages" : "Disadvantages";

    add_draw_return_values();

    if (bool(type)){
        var _title_x = 436;
        var _advarray = obj_creation.all_advantages;
    } else {
        var _title_x = 810;
        var _advarray = obj_creation.all_disadvantages;       
    }

    var _adv_txt = {
        x1: _title_x,
        y1: 590,
        w: 204,
        h: 20,
    }; 

    var _advantage_click_allow = custom == eCHAPTER_TYPE.CUSTOM;
    draw_set_halign(fa_left);
    draw_set_font(fnt_40k_30b);
    draw_text_transformed(_title_x, 564, $"Chapter {_title}", 0.5, 0.5, 0);
    draw_set_font(fnt_40k_14);

    _adv_txt.x2 = _adv_txt.x1 + _adv_txt.w;
    _adv_txt.y2 = _adv_txt.y1 + _adv_txt.h;
    var _max_advantage_count = 8;
    var _advantages = 0
    for (var i = 0;i < array_length(_advarray); i++){
        var _adv = _advarray[i];
        if (_adv.activated){
            if (_advantages < _max_advantage_count){
                var _array = draw_unit_buttons([_adv_txt.x1, _adv_txt.y1+ (_advantages * _adv_txt.h)],$"[-] {_adv.name}" ,[0.75, 0.75], CM_GREEN_COLOR);
                _advantages++;
            } else {
                _adv.remove();
                continue;
            }
        } else {
            continue;
        }
        if (!scr_hit(_array)) {
            continue;
        }

        tooltip = $"{_adv.name} ({_adv.points} Points)";
        tooltip2 = _adv.description;

        if (!_advantage_click_allow || popup != ""){
            continue;
        }
        if (mouse_button_clicked()){
            _adv.remove();
        }

    }

    for (var i=_advantages ; i<_max_advantage_count;i++){
        var _array = draw_unit_buttons([_adv_txt.x1, _adv_txt.y1+ (i * _adv_txt.h)],"[+]" ,[0.75, 0.75], CM_GREEN_COLOR);

        if (!_advantage_click_allow || popup != ""){
            continue;
        }
        if (scr_hit(_array)){
            if (bool(type) && points >= maxpoints) {
                tooltip = "Insufficient Points";
                tooltip2 = "Add disadvantages or decrease Chapter Stats";
            }
        } else {
            continue;
        }

        if (mouse_button_clicked()){
            if (bool(type)){
                if (points < maxpoints) {
                    popup = "advantages";

                    temp = 1;
                }
            } else {
                popup = "disadvantages";
            }
        }
    }

    pop_draw_return_values();
}