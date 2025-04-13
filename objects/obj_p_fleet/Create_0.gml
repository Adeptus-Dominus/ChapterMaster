
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
    var object_fleet = self;
    
    var save_data = {
        obj: object_get_name(object_index),
        x,
        y,
        point_breakdown: point_breakdown
    }
    var excluded_from_save = ["temp", "serialize", "deserialize"]

    copy_serializable_fields(object_fleet, save_data, excluded_from_save);

    return save_data;
}
// debugl("obj_p_fleet save data serialized:");
// debugl(json_stringify(serialize(), true));

deserialize = function(save_data){
    var exclusions = ["orbiting"]; // skip automatic setting of certain vars, handle explicitly later

    // Automatic var setting
    var all_names = struct_get_names(save_data);
    var _len = array_length(all_names);
    for(var i = 0; i < _len; i++){
        var var_name = all_names[i];
        if(array_contains(exclusions, var_name)){
            continue;
        }
        var loaded_value = struct_get(save_data, var_name);
        try {
            variable_struct_set(self, var_name, loaded_value);	
        } catch (e){
            show_debug_message(e);
        }
    }
    
    if(save_data.orbiting != 0){
        var nearest_star = instance_nearest(x, y, obj_star);
        set_player_fleet_image();
        orbiting = nearest_star;
    }
    
}

#endregion