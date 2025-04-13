// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information


#macro ARR_planet_types ["Dead","Ice", "Temperate","Feudal","Shrine","Agri","Death","Hive","Forge","Desert","Lava"]
enum ePlayerBase {
	none = 0,
	home_world = 1,
	fleet_based = 2,
	penitent = 3,
}

function find_player_spawn_star(){
	instance_activate_object(obj_star);
	var _spawn_star;
	var _allowable = false;
	var _allowables  = ["Temperate","Feudal","Agri","Death","Ice","Desert","Lava"];
	for (var i=0; i<100; i++){
		var y_loc, x_loc;
		if (obj_ini.homeworld_relative_loc == 0){
			if (irandom(1)){
				y_loc = choose(0, room_height);
				x_loc = irandom(room_width);
			} else {
				x_loc = choose(0,room_width);
				y_loc = irandom(room_height);
			}
		} else {
			x_loc = irandom_range(0+(room_width/2), room_width-(room_width/2));
			y_loc = irandom_range(0+(room_height/2), room_height-(room_height/2));
		}
		var _chosen_star = instance_nearest(x_loc,y_loc, obj_star);
		if (instance_exists(_chosen_star)){
			for (var p=0;p<array_length(_chosen_star.p_type);p++){
				if (array_contains(_allowables, _chosen_star.p_type[p])){
					_allowable = true;
				}
			}
		}
		if (_allowable) then break;
		instance_deactivate_object(_chosen_star);
	}
	instance_activate_object(obj_star);
	return _chosen_star.id;	    
}


/*if (obj_ini.recruiting_name!="random"){
    array_push(global.name_generator.star_used_names, obj_ini.recruiting_name);
    if (star_by_name(obj_ini.recruiting_name) != "none" ){
        star_by_name(obj_ini.recruiting_name).name = global.name_generator.generate_star_name();
    }
    name=obj_ini.recruiting_name;
}*/

function player_home_star(home_planet){

        p_type[home_planet]=obj_ini.home_type;
        planet[home_planet]=1;

        if (obj_ini.home_name!="random"){
            array_push(global.name_generator.star_used_names, obj_ini.home_name);
            if (star_by_name(obj_ini.home_name) != "none" ){
                star_by_name(obj_ini.home_name).name = global.name_generator.generate_star_name();
            }
            name=obj_ini.home_name;
        }            
        array_push(p_feature[home_planet], new NewPlanetFeature(P_features.Monastery));
        p_owner[home_planet]=eFACTION.Player;

        p_first[home_planet]=1; //monestary
        if (obj_ini.homeworld_rule!=1) then dispo[home_planet]=-5000;
        
        if (obj_ini.home_type=="Shrine") then known[eFACTION.Ecclesiarchy]=1;
        if (obj_ini.recruiting_type=="Shrine") then known[eFACTION.Ecclesiarchy]=1;
        
        p_lasers[home_planet]=8;
        p_silo[home_planet]=100;
        p_defenses[home_planet]=75;
        if (obj_ini.custom==0){
            p_lasers[home_planet]=32;
            p_silo[home_planet]=300;
            p_defenses[home_planet]=225;
        }
        
        var _planet_types = ARR_planet_types;
        if (p_type[home_planet]=="random") then p_type[home_planet]=choose(_planet_types);
        if (global.chapter_name!="Lamenters") then obj_controller.recruiting_worlds+=string(name)+" I|";
        
        p_player[home_planet]=obj_ini.man_size;
}


function set_player_recruit_planet(recruit_planet){
	p_type[recruit_planet]=obj_ini.recruiting_type;
	if (obj_ini.fleet_type==ePlayerBase.home_world && obj_ini.recruit_relative_loc==2){ // Possibly a temporary fix, Fleet-based Chapters use Homeworld names for the Recruiting stars for some reason
		var recruit_name = obj_ini.recruiting_name;
	    if (recruit_name!="random"){
	        array_push(global.name_generator.star_used_names, recruit_name);
	        if (star_by_name(recruit_name) != "none" ){
	            star_by_name(recruit_name).name = global.name_generator.generate_star_name();
	        }
	        name=recruit_name;
	    }
	} else {
	    if (obj_ini.home_name!="random"){
	        array_push(global.name_generator.star_used_names, obj_ini.home_name);
	        if (star_by_name(obj_ini.home_name) != "none" ){
	            star_by_name(obj_ini.home_name).name = global.name_generator.generate_star_name();
	        }
	        name=obj_ini.home_name;
	    }
	}
	array_push(p_feature[recruit_planet], new NewPlanetFeature(P_features.Recruiting_World));//recruiting world
	if (p_type[recruit_planet]=="random") then p_type[recruit_planet]=choose("Death","Temperate","Desert","Ice","Hive", "Fuedal");
	if (global.chapter_name!="Lamenters") then obj_controller.recruiting_worlds+=string(name)+" II|";
}

function set_player_homeworld_star(chosen_star){
	with (chosen_star){
		if (obj_ini.recruit_relative_loc==1 && obj_ini.home_planet_count ==0){
			obj_ini.home_planet_count++;
		}
		planets = obj_ini.home_planet_count+1;
		var _home_star = irandom_range(1,planets);

		player_home_star(_home_star);
		var _planet_types = ARR_planet_types;

		if (obj_ini.recruit_relative_loc==1){
	       var _possible_planets = [];
	       for (var i=1;i<=planets;i++){
		       	if (i!=_home_star){
		       		array_push(_possible_planets, i);
		       		p_type[i] = array_random_element(_planet_types);
		       	}
	       }
	       	var _recruit_star = array_random_element(_possible_planets)
			set_player_recruit_planet(_recruit_star);
	    } else if (obj_ini.recruit_relative_loc==0){
	    	array_push(p_feature[_home_star], new NewPlanetFeature(P_features.Recruiting_World));//recruiting world
	    	for (var i=1;i<=planets;i++){
		       	if (i!=_home_star){
		       		p_type[i] = array_random_element(_planet_types);
		       	}
	       	}
	    	if (global.chapter_name!="Lamenters") then obj_controller.recruiting_worlds+=string(name)+" II|";
	    } else if (obj_ini.recruit_relative_loc==2){
	    	create_recruit_system(distance_removed_star(chosen_star.x, chosen_star.y));
	    	for (var i=1;i<=planets;i++){
		       	if (i!=_home_star){
		       		p_type[i] = array_random_element(_planet_types);
		       	}
	       	}
	    }
    }	
}

function create_recruit_system(star){
	with (star){
		var _recruit_planet = irandom_range(1,planets);
		set_player_recruit_planet(_recruit_planet);
	}

}

