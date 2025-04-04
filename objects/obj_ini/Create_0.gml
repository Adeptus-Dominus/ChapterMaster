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

#region save/load serialization 

/// Called from save function to take all object variables and convert them to a json savable format and return it 
serialize = function(){
    var object_ini = self;
    
    var marines = array_create(0);
    for(var coy = 0; coy <=10; coy++){
        for(var mar = 0; mar <=500; mar++){
            var marine_json;
            if(obj_ini.name[coy][mar] != ""){
                marine_json = jsonify_marine_struct(coy, mar, false);
                array_push(marines, marine_json);
            } else if(mar > 0){
                break;
            }
        }
    }
    var squads = [];
    if (array_length(object_ini.squads)> 0){
        for (var i = 0;i < array_length(object_ini.squads);i++){
            array_push(squads, object_ini.squads[i].jsonify(false));
        }
    }

    var artifact_struct_trimmed = [];
    for(var i = 0; i < array_length(artifact_struct); i++){
        if(artifact_struct[i].name != ""){
            array_push(artifact_struct_trimmed, artifact_struct[i]);
        }
    }
    

    var save_data = {
        obj: object_get_name(object_index),
        x,
        y,
        custom_advisors,
        full_liveries: full_liveries,
        complex_livery_data: complex_livery_data,
        squad_types: squad_types,
        artifact_struct: artifact_struct_trimmed,
        marine_structs: marines,
        squad_structs: squads,
        // marines,
        // squads
    }

    if(struct_exists(object_ini, "last_ship")){
        save_data.last_ship = object_ini.last_ship;
    }
    
    var excluded_from_save = ["temp", "serialize", "deserialize", "load_default_gear", "role_spawn_buffs", "TTRPG", "squads", "squad_types", "marines", "last_ship"]

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
        if(is_basic_variable(object_ini[$var_name])){
            variable_struct_set(save_data, var_name, object_ini[$var_name]);
        }
        if(is_array(object_ini[$var_name])){
            var _check_arr = object_ini[$var_name];
            var _ok_array = is_basic_array(_check_arr, 2);
            if(!_ok_array){
                log_warning($"Bad array save: '{var_name}' internal type found was not a simple type and should probably have it's own serialize functino - obj_ini");
            } else {
                variable_struct_set(save_data, var_name, object_ini[$var_name]);
            }
        }
        if(is_struct(object_ini[$var_name])){
            if(!struct_exists(save_data, var_name)){
                log_warning($"WARNING: obj_ini.serialze() - obj_ini - object contains struct variable '{var_name}' which has not been serialized. \n\tEnsure that serialization is written into the serialize and deserialization function if it is needed for this value, or that the variable is added to the ignore list to suppress this warning");
            }
        }
    }
    return save_data;
}

deserialize = function(save_data){
    var exclusions = ["complex_livery_data", "full_liveries", "squad_types", "marine_structs", "squad_structs"]; // skip automatic setting of certain vars, handle explicitly later

    // Automatic var setting
    var all_names = struct_get_names(save_data);
    var _len = array_length(all_names);
    for(var i = 0; i < _len; i++){
        var var_name = all_names[i];
        if(array_contains(exclusions, var_name)){
            continue;
        }
        
        var loaded_value = struct_get(save_data, var_name);
        // show_debug_message($"obj_ini var: {var_name}  -  val: {loaded_value}");
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
        variable_struct_set(obj_ini, "full_liveries", save_data.full_liveries)
    } else {
        variable_struct_set(obj_ini, "full_liveries", array_create(21,DeepCloneStruct(livery_picker.map_colour)));
    }

    if(struct_exists(save_data, "complex_livery_data")){
        variable_struct_set(obj_ini, "complex_livery_data", save_data.complex_livery_data);
    }
    if(struct_exists(save_data, "squad_types")){
        variable_struct_set(obj_ini, "squad_types", save_data.squad_types);
    }

    if(struct_exists(save_data, "marine_structs")){
        var marines_encoded_arr = save_data.marine_structs;
        var _m_ar_len = array_length(marines_encoded_arr);
        for(var m = 0; m < _m_ar_len; m++){
                var marine_json = marines_encoded_arr[m];
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
        var squad_fetch = save_data.squad_structs;
        for (i=0;i<array_length(squad_fetch);i++){
            var sq = new UnitSquad();
            sq.load_json_data(squad_fetch[i]);
            array_push(obj_ini.squads, sq);
        }
    }

    if(struct_exists(save_data, "artifact_struct")){
        obj_ini.artifact_struct = [];
        var artifact_str_arr = save_data.artifact_struct;
        var _len = array_length(artifact_str_arr);
        for(var i = 0; i < 200; i++){ // 200 is the max number of artifacts
            var arti_struct = new ArtifactStruct(i);
            if(i < _len){ // still within the save_data array
                var arti = artifact_str_arr[i];
                if(arti != -1){ // in the serializer we trim out empty slots so there will be nothing to load
                    arti_struct.load_json_data(arti);
                }
                array_push(obj_ini.artifact_struct, arti_struct);
            } else {
                array_push(obj_ini.artifact_struct, arti_struct); //load empty ones into the rest of the slots
            }
        }
    }
}


#endregion
