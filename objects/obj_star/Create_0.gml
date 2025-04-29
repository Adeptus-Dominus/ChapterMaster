// Creates all variables, sets up default variables for different planets and if there is a fleet orbiting a system/planet
craftworld=0;// orbit_angle=0;orbit_radius=0;
space_hulk=0;
old_x=0;
old_y=0;

if (((x>=(room_width-150)) and (y<=450)) or (y<100)) and (global.load==-1){// was 300
    instance_destroy();
}

scale = 1;
var run=0;
name="";
star="";
planets=0;
owner = eFACTION.Imperium;
image_speed=0;
image_alpha=0;
x2=0;
y2=0;
warp_lanes=[];
if (global.load==-1) then alarm[0]=1;
storm=0;
storm_image=0;
trader=0;
visited=0;
stored_owner = -1;
star_surface = 0;

// sets up default planet variables
for(run=1; run<=8; run++){
    planet[run]=0;
    dispo[run]=-50;
    p_type[run]="";
    p_operatives[run]=[];
    p_feature[run]=[];
    p_owner[run]=0;
    p_first[run]=0;
    p_population[run]=0;
    p_max_population[run]=0;
    p_large[run]=0;
    p_pop[run]="";
    p_guardsmen[run]=0;
    p_pdf[run]=0;
    p_fortified[run]=0;
    p_station[run]=0;
	//warlord=0; uneeded i think
    // Whether or not player forces are on the planet
    p_player[run]=0;
    p_lasers[run]=0;
    p_silo[run]=0;
    p_defenses[run]=0;
    p_upgrades[run]=[];
    // v how much of a problem they are from 1-6
    p_orks[run]=0;
    p_tau[run]=0;
    p_eldar[run]=0;
    p_tyranids[run]=0;
    p_traitors[run]=0;
    p_chaos[run]=0;
    p_demons[run]=0;
    p_sisters[run]=0;
    p_necrons[run]=0;
    p_halp[run]=0;
    // current planet heresy
    p_heresy[run]=0;
    p_hurssy[run]=0;
    p_hurssy_time[run]=0;
    p_heresy_secret[run]=0;
    p_influence[run] = array_create(15, 0);

    p_raided[run]=0;
    // 
    p_governor[run] = "";
    p_problem[run] = array_create(8,"");
    p_problem_other_data[run] = array_create(8,{});
    p_timer[run] = array_create(8,-1);
}

system_player_ground_forces = 0;
garrison = false;

for(run=8; run<=30; run++){
    present_fleet[run]=0;
}
vision=1;
// present_fleets=0;
// tau_fleets=0;

ai_a=-1;
ai_b=-1;
ai_c=-1;
ai_d=-1;
ai_e=-1;

global.star_name_colors = [
	c_gray,
	c_white, //player
	c_gray, //imperium
	c_red, // toaster fuckers
	38144, //nothing for inquisition
	c_white, //ecclesiarchy
	#FF8000, //Hi, I'm Elfo
	#009500, // waagh
	#FECB01, // the greater good
	#AD5272,// bug boys
	c_dkgray, // chaos
	38144, //nothing for heretics either
	#AD5272, //why 12 is skipped in general, we will never know
	#80FF00 // Sleepy robots
]


#region save/load serialization 

/// Called from save function to take all object variables and convert them to a json savable format and return it 
serialize = function(){
    var object_star = self;

    var planet_data = [];

    for(var p = 1; p <= object_star.planets; p++){
        planet_data[p] = {
            dispo: object_star.dispo[p],
            planet: object_star.planet[p],
        };
        var var_names = variable_struct_get_names(object_star);
        for(var n = 0; n < array_length(var_names); n++){
            var var_name = var_names[n];
            if(string_starts_with(var_name, "p_")){
                var val = object_star[$var_name][p];
                variable_struct_set(planet_data[p], var_name, val);
            }
        }
    }


    var save_data = {
        obj: object_get_name(object_index),
        x,
        y,
        present_fleet: object_star.present_fleet,
        planet_data: planet_data,
    }
    if(struct_exists(object_star, "system_garrison")){
        save_data.system_garrison = object_star.system_garrison;
    }
    if(struct_exists(object_star, "system_sabatours")){
        save_data.system_sabatours = object_star.system_sabatours;
    }

      
    var excluded_from_save = ["temp", "serialize", "deserialize", "arraysum"];
    var excluded_from_save_start = ["p_"];

    copy_serializable_fields(object_star, save_data, excluded_from_save, excluded_from_save_start);

    return save_data;
}

function deserialize(save_data){
    var exclusions = ["id", "present_fleet", "planet_data"]; // skip automatic setting of certain vars, handle explicitly later

    // Automatic var setting
    var all_names = struct_get_names(save_data);
    var _len = array_length(all_names);
    for(var i = 0; i < _len; i++){
        var var_name = all_names[i];
        if(array_contains(exclusions, var_name)){
            continue;
        }
        var loaded_value =  struct_get(save_data, var_name);
        variable_struct_set(self, var_name, loaded_value);	
    }

    // Set explicit vars here
    if(struct_exists(save_data, "present_fleet")){
        variable_struct_set(self, "present_fleet", save_data.present_fleet);
    }

    if(struct_exists(save_data, "planet_data")){
        var planet_arr = save_data.planet_data;
        var _len = array_length(planet_arr);
        for(var p = 1; p < _len; p++){
            var planet = planet_arr[p];
            var var_names = struct_get_names(planet);
            for(var v = 0; v < array_length(var_names); v++){
                var var_name = var_names[v];
                var val = planet[$var_name];
                // var_name = "p_type"
                // planet = {"p_type":"hive"};
                // val = planet[$var_name] = "hive"

                self[$var_name][p] = val;
                // variable_struct_set(self, var_name, planet[$var_name]);
            }
        }
    }

     if(struct_exists(save_data, "system_sabatours")){
        variable_struct_set(self, "system_sabatours", save_data.system_sabatours);
    }
     if(struct_exists(save_data, "system_garrison")){
        variable_struct_set(self, "system_garrison", save_data.system_garrison);
    }

}

#endregion