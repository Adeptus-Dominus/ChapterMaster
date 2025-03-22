
owner  = eFACTION.Player;
capital_number=0;
frigate_number=0;
escort_number=0;
selected=0;
orbiting=0;
warp_able=true;
ii_check=choose(8,9,10,11,12);

var wop=instance_nearest(x,y,obj_star);
if (instance_exists(wop)) and (y>0) and (x>0){
    if (point_distance(x,y,wop.x,wop.y)<=40){
        orbiting=wop;
        wop.present_fleet[1]+=1;
    }
}

point_breakdown = single_loc_point_data();
image_xscale=1.25;
image_yscale=1.25;

var i=-1;
capital = [];
capital_num = [];
capital_sel = [];
capital_uid = [];

frigate = [];
frigate_num = [];
frigate_sel = [];
frigate_uid = [];

escort = [];
escort_num = [];
escort_sel = [];
escort_uid = [];


image_speed=0;

fix=2;

capital_health=100;
frigate_health=100;
escort_health=100;

complex_route = [];
just_left=false;


action="";
action_x=0;
action_y=0;
action_spd=128;
action_eta=0;
connected=0;
acted=0;
hurssy=0;
hurssy_time=0;
/// Called from save function to take all object variables and convert them to a json savable format and return it 
serialize = function(){
    var object_ini = self;
    
    var save_data = {
        obj: object_get_name(object_index),
        x,
        y,
        layer,
        id
    }
    
    var excluded_from_save = ["temp", "serialize", "deserialize"]

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
                            debugl($"Bad 2d array save: '{var_name}' internal type found was of type '{type}' - obj_p_fleet");
                            _ok_array = false;
                            break;
                        }
                    }
                } else {
                    if((is_numeric(_check_arr[j]) || is_string(_check_arr[j]) || is_bool(_check_arr[j])) == false){
                        var type = typeof(_check_arr[j]);
                        debugl($"Bad array save: '{var_name}' internal type found was of type '{type}' - obj_p_fleet");
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
                debugl($"WARNING: obj_ini.serialze() - obj_p_fleet - object contains struct variable '{var_name}' which has not been serialized. \n\tEnsure that serialization is written into the serialize and deserialization function if it is needed for this value, or that the variable is added to the ignore list to suppress this warning");
            }
        }
    }


    return save_data;
}
// debugl("obj_p_fleet save data serialized:");
// debugl(json_stringify(serialize(), true));

deserialize = function(save_data){
    var deserialized = save_data;
    instance_create_layer(deserialized.x, deserialized.y, deserialized.layer, obj_p_fleet, deserialized);
}

#endregion