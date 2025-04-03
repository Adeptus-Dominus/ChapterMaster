
owner=0;
capital_number=0;
frigate_number=0;
escort_number=0;
guardsmen=0;
home_x=0;
home_y=0;
selected=0;
ret=0;
hurt=0;
orbiting=0;
rep=3;
minimum_eta=2;
turns_static = 0;
navy=0;
guardsmen_ratio=0;
guardsmen_unloaded=0;
complex_route = [];
warp_able = false;
ii_check=floor(random(5))+1;
etah=0;
safe=0;
last_turn_check = 0;
//TODO set up special save method for faction specific fleet variables
inquisitor=-1;

cargo_data = {};

image_xscale=1.25;
image_yscale=1.25;

var i=-1;
repeat(21){i+=1;
    capital[i]="";capital_num[i]=0;capital_sel[i]=1;capital_imp[i]=0;capital_max_imp[i]=0;
}

var i;i=-1;
repeat(31){i+=1;
    frigate[i]="";frigate_num[i]=0;frigate_sel[i]=1;frigate_imp[i]=0;frigate_max_imp[i]=0;
}

var i;i=-1;
repeat(31){i+=1;
    escort[i]="";escort_num[i]=0;escort_sel[i]=1;escort_imp[i]=0;escort_max_imp[i]=0;
}

image_speed=0;


action="";
action_x=0;
action_y=0;
target=noone;
target_x=0;
target_y=0;
action_spd=64;
if (owner<=6) then action_spd=128;
action_eta=0;
connected=0;
loaded=0;

trade_goods="";


capital_health=100;
frigate_health=100;
escort_health=100;

alarm[8]=1;

#region save/load serialization 

/// Called from save function to take all object variables and convert them to a json savable format and return it 
serialize = function(){
    var object_fleet = self;
    
    var save_data = {
        obj: object_get_name(object_index),
        x,
        y,
    }
    
    var excluded_from_save = ["temp", "serialize", "deserialize", "cargo_data"]

    /// Check all object variable values types and save the simple ones dynamically. 
    /// simple types are numbers, strings, bools. arrays of only simple types are also considered simple. 
    /// non-simple types are structs, functions, methods
    /// functions and methods will be ignored completely, structs to be manually serialized/deserialised.
    var all_names = struct_get_names(object_fleet);
    var _len = array_length(all_names);
    for(var i = 0; i < _len; i++){
        var var_name = all_names[i];
        if(array_contains(excluded_from_save, var_name)){
            continue;
        }
        if(struct_exists(save_data, var_name)){
            continue; //already added above
        }
        if(is_numeric(object_fleet[$var_name]) || is_string(object_fleet[$var_name]) || is_bool(object_fleet[$var_name])){
            variable_struct_set(save_data, var_name, object_fleet[$var_name]);
        }
        if(is_array(object_fleet[$var_name])){
            var _check_arr = object_fleet[$var_name];
            var _ok_array = array_is_simple_2d(_check_arr);
            if(!_ok_array){
                log_warning($"Bad array save: '{var_name}' internal type found was not a simple type and should probably have it's own serialize functino - obj_en_fleet");
            } else {
                variable_struct_set(save_data, var_name, object_fleet[$var_name]);
            }
        }
        if(is_struct(object_fleet[$var_name])){
            if(!struct_exists(save_data, var_name)){
                log_warning($"WARNING: obj_ini.serialze() - obj_en_fleet - object contains struct variable '{var_name}' which has not been serialized. \n\tEnsure that serialization is written into the serialize and deserialization function if it is needed for this value, or that the variable is added to the ignore list to suppress this warning");
            }
        }
    }


    return save_data;
}
deserialize = function(save_data){
    var exclusions = ["id"]; // skip automatic setting of certain vars, handle explicitly later

    // Automatic var setting
    var all_names = struct_get_names(save_data);
    var _len = array_length(all_names);
    for(var i = 0; i < _len; i++){
        var var_name = all_names[i];
        if(array_contains(exclusions, var_name)){
            continue;
        }
        var loaded_value = struct_get(save_data, var_name);
        // show_debug_message($"en_fleet {en_fleet_instance.id}  - var: {var_name}  -  val: {loaded_value}");
        try {
            variable_struct_set(self, var_name, loaded_value);	
        } catch (e){
            show_debug_message(e);
        }
    }

    if(save_data.orbiting != 0){
        var nearest_star = instance_nearest(x, y, obj_star);
        orbiting = nearest_star;
        // show_debug_message($"p_fleet id {id} deserialized: {self}");
    }
}

#endregion