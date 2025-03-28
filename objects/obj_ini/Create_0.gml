// // Global singletons
// global.NameGenerator = new NameGenerator();
show_debug_message("Creating obj_ini");

// // normal stuff
use_custom_icon=0;
icon=0;icon_name="";

specials=0;firsts=0;seconds=0;thirds=0;fourths=0;fifths=0;
sixths=0;sevenths=0;eighths=0;ninths=0;tenths=0;commands=0;

heh1=0;heh2=0;

// strin="";
// strin2="";
tolerant=0;
companies=10;
progenitor=ePROGENITOR.NONE;
aspirant_trial = 0;
obj_ini.custom_advisors  = {};

//default sector name to prevent potential crash
sector_name = "Terra Nova";
//default
load_to_ships=[2,0,0];
if (instance_exists(obj_creation)){load_to_ships=obj_creation.load_to_ships;}

penitent=0;
penitent_max=0;
penitent_current=0;
penitent_end=0;
man_size=0;
home_planet = 2;
artifact_struct = array_create(200);

// Equipment- maybe the bikes should go here or something?          yes they should
i=-1;
repeat(200){i+=1;
    equipment[i]="";
    equipment_type[i]="";
    equipment_number[i]=0;
    equipment_condition[i]=100;
    equipment_quality[i]=[];
    artifact[i]="";
    artifact_equipped[i]=false;
    artifact_tags[i]=[];
    artifact_identified[i]=0;
    artifact_condition[i]=100;
    artifact_quality[i]="artifact";
    artifact_loc[i]="";
    artifact_sid[i]=0;// Over 500 : ship
    // Weapon           Unidentified
    artifact_struct[i] =  new ArtifactStruct(i);    
}

var i=-1;
init_player_fleet_arrays();
ship_id = [];

var v;
var company=-1;
repeat(11){
    company+=1;v=-1;// show_message("v company: "+string(company));
    repeat(205){v+=1;// show_message(string(company)+"."+string(v));
        last_ship[company,v] = {uid : "", name : ""};
        veh_race[company,v]=0;
        veh_loc[company,v]="";
        veh_name[company,v]="";
        veh_role[company,v]="";
        veh_wep1[company,v]="";
        veh_wep2[company,v]="";
        veh_wep3[company,v]="";
        veh_upgrade[company,v]="";
        veh_acc[company,v]="";
        veh_hp[company,v]=100;
        veh_chaos[company,v]=0;
        veh_pilots[company,v]=0;
        veh_lid[company,v]=-1;
        veh_wid[company,v]=2;
        veh_uid[company,v]=0;
    }
}

/*if (obj_creation.fleet_type=3){
    obj_controller.penitent=1;
    obj_controller.penitent_max=(obj_creation.maximum_size*1000)+300;
    if (obj_creation.chapter_name="Lamenters") then obj_controller.penitent_max=100300;
    obj_controller.penitent_current=300;
}*/

check_number=0;
year_fraction=0;
year=0;
millenium=0;
company_spawn_buffs = [];
role_spawn_buffs ={};
previous_forge_masters = [];
recruit_trial = 0;
recruiting_type="Death";

gene_slaves = [];
/* if (global.load=0){
    if (obj_creation.custom>0) then scr_initialize_custom();
    if (obj_creation.custom=0) then scr_initialize_standard();
}*/

adv = [];
dis = [];


if (instance_exists(obj_creation)) then custom=obj_creation.custom;

if (global.load=0) then scr_initialize_custom();




// 135;
// with(obj_creation){instance_destroy();}

/* */
/*  */


#region save/load serialization 

/// Called from save function to take all object variables and convert them to a json savable format and return it 
serialize = function(){
    var object_ini = self;
    
    var marines = array_create(0, "");
    for(var coy = 0; coy <=10; coy++){
        with(object_ini){
            scr_company_order(coy);
        }
        for(var mar = 0; mar <=500; mar++){
            var marine_json;
            if(obj_ini.name[coy][mar] != ""){
                if (!is_struct(object_ini.TTRPG[coy][mar])){
                    object_ini.TTRPG[coy][mar] = new TTRPG_stats("chapter", coy,mar, "blank");
                }
                marine_json = jsonify_marine_struct(coy, mar);
                array_push(marines, base64_encode(marine_json));
            } else if(mar > 0){
                break;
            }
        }
    }
    var squads = [];
    if (array_length(object_ini.squads)> 0){
        for (var i = 0;i < array_length(object_ini.squads);i++){
            array_push(squads, object_ini.squads[i].jsonify());
        }
    }
    

    var save_data = {
        obj: object_get_name(object_index),
        x,
        y,
        custom_advisors,
        full_liveries: base64_encode(json_stringify(full_liveries)),
        complex_livery_data: base64_encode(json_stringify(complex_livery_data)),
        squad_types: base64_encode(json_stringify(squad_types)),
        artifact_struct,
        marine_structs: marines,
        squad_structs: base64_encode(json_stringify(squads)),
        // marines,
        // squads
    }
    
    var excluded_from_save = ["temp", "serialize", "deserialize", "load_default_gear", "role_spawn_buffs", "TTRPG", "squads", "squad_types", "marines" ]

    /// Check all object variable values types and save the simple ones dynamically. 
    /// simple types are numbers, strings, bools. arrays of only simple types are also considered simple. 
    /// non-simple types are structs, functions, methods
    /// functions and methods will be ignored completely, structs to be manually serialized/deserialised.
    var all_names = struct_get_names(object_ini);
    var _len = array_length(all_names);
    for(var i = 0; i < _len; i++){
        var var_name = all_names[i];
        if(array_contains(excluded_from_save, var_name)){
            continue;
        }
        if(struct_exists(save_data, var_name)){
            continue; //already added above
        }
        if(is_numeric(object_ini[$var_name]) || is_string(object_ini[$var_name]) || is_bool(object_ini[$var_name])){
            variable_struct_set(save_data, var_name, object_ini[$var_name]);
        }
        if(is_array(object_ini[$var_name])){
            var _check_arr = object_ini[$var_name];
            var _ok_array = true;
            for(var j = 0; j < array_length(_check_arr); j++){
                if(is_array(_check_arr[j])){
                    // 2d array probably but check anyway
                    for(var k = 0; k < array_length(_check_arr[j]); k++){
                        if((is_numeric(_check_arr[j][k]) || is_string(_check_arr[j][k]) || is_bool(_check_arr[j][k])) == false){
                            var type = typeof(_check_arr[j][k]);
                            debugl($"Bad 2d array save: '{var_name}' internal type found was of type '{type}' - obj_ini");
                            _ok_array = false;
                            break;
                        }
                    }
                } else {
                    if((is_numeric(_check_arr[j]) || is_string(_check_arr[j]) || is_bool(_check_arr[j])) == false){
                        var type = typeof(_check_arr[j]);
                        debugl($"Bad array save: '{var_name}' internal type found was of type '{type}' - obj_ini");
                        _ok_array = false;
                        break;
                    }
                }
            }
            if(_ok_array){
                variable_struct_set(save_data, var_name, object_ini[$var_name]);
            }
        }
        if(is_struct(object_ini[$var_name])){
            if(!struct_exists(save_data, var_name)){
                debugl($"WARNING: obj_ini.serialze() - obj_ini - object contains struct variable '{var_name}' which has not been serialized. \n\tEnsure that serialization is written into the serialize and deserialization function if it is needed for this value, or that the variable is added to the ignore list to suppress this warning");
            }
        }
    }
    return save_data;
}

deserialize = function(save_data){
    var exclusions = ["complex_livery_data", "full_liveries", "squad_types", "id", "marine_structs", "squad_structs"]; // skip automatic setting of certain vars, handle explicitly later

    // Automatic var setting
    var all_names = struct_get_names(save_data);
    var _len = array_length(all_names);
    for(var i = 0; i < _len; i++){
        var var_name = all_names[i];
        if(array_contains(exclusions, var_name)){
            continue;
        }
        
        var loaded_value = struct_get(save_data, var_name);
        show_debug_message($"obj_ini var: {var_name}  -  val: {loaded_value}");
        try {
            variable_struct_set(obj_ini, var_name, loaded_value);	
        } catch (e){
            show_debug_message(e);
        }
    }

    // Set explicit vars here
    var livery_picker = new ColourItem(0,0);
    livery_picker.scr_unit_draw_data();
    if(struct_exists(save_data, "full_liveries")){
        variable_struct_set(obj_ini, "full_liveries", json_parse(base64_decode(save_data.full_liveries)))
    } else {
        variable_struct_set(obj_ini, "full_liveries", array_create(21,DeepCloneStruct(livery_picker.map_colour)));
    }

    if(struct_exists(save_data, "complex_livery_data")){
        variable_struct_set(obj_ini, "complex_livery_data", json_parse(base64_decode(save_data.complex_livery_data)));
    }
    if(struct_exists(save_data, "squad_types")){
        variable_struct_set(obj_ini, "squad_types", json_parse(base64_decode(save_data.squad_types)));
    }

    if(struct_exists(save_data, "marine_structs")){
        var marines_encoded_arr = save_data.marine_structs;
        var _m_ar_len = array_length(marines_encoded_arr);
        for(var m = 0; m < _m_ar_len; m++){
                var marine_json = json_parse(base64_decode(marines_encoded_arr[m]));
                var coy = marine_json.company;
                var mar = marine_json.marine_number;
                load_marine_struct(coy, mar, marine_json); 
        }
        for(var coy = 0; coy < 11; coy++){
            var mar_start = array_length(obj_ini.TTRPG[coy]);
            for(var mar = mar_start; mar < 501; mar++){
                obj_ini.TTRPG[coy][mar] = new TTRPG_stats("chapter",coy, mar, "blank");
            }
        }
    }

    if(struct_exists(save_data, "squad_structs")){
        obj_ini.squads = [];
        var squad_fetch = json_parse(base64_decode(save_data.squad_structs))
        for (i=0;i<array_length(squad_fetch);i++){
            array_push(obj_ini.squads, new UnitSquad());
            obj_ini.squads[i].load_json_data(json_parse(squad_fetch[i]));
        }
    }
}


#endregion
