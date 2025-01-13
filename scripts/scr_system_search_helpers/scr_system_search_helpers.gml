// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function scr_get_planet_with_feature(star, feature){
	for(var i = 1; i <= star.planets; i++){
		if(planet_feature_bool(star.p_feature[i], feature) == 1)
			{
				return i;
			}
		}
	return -1;
}

//TODO make an adaptive allies system
function NSystemSearchHelpers() constructor{
	static default_allies = [
		eFACTION.Player,
		eFACTION.Imperium,
		eFACTION.Mechanicus,
		eFACTION.Inquisition,
		eFACTION.Ecclesiarchy
	]
}
global.SystemHelps = new NSystemSearchHelpers();

function fetch_faction_group(group="imperium_default") {
	switch(group){
		case "imperium_default":
			var imperium =  [
					eFACTION.Imperium,
					eFACTION.Mechanicus,
					eFACTION.Inquisition,
					eFACTION.Ecclesiarchy
				];
			if( obj_controller.faction_status[eFACTION.Imperium]!="War"){
				array_push (imperium, eFACTION.Player);
			}
			break;
	}
	return [];
}

function scr_star_has_planet_with_feature(star, feature){
	return scr_get_planet_with_feature(star, feature) != -1;
}

function scr_planet_owned_by_group(planet_id, group, star = "none"){
	if (star == "none"){
		return array_contains(group, p_owner[planet_id]);
	} else {
		var is_in_group = false;
		with(star){
			is_in_group = scr_planet_owned_by_group(planet_id, group);
		}
		return is_in_group;
	}
	return false;
}

function scr_is_planet_owned_by_allies(star, planet_id) {
	if( planet_id < 1 ){//1 because weird indexing starting at 1 in this game
		return false;
	}
	return array_contains(global.SystemHelps.default_allies, star.p_owner[planet_id]);
}

function scr_is_star_owned_by_allies(star) {
	return array_contains(global.SystemHelps.default_allies, star.owner);
}

function scr_get_planet_with_type(star, type){
	for(var i = 1; i <= star.planets; i++){
		if(star.p_type[i] == type)
			{
				return i;
			}
		}
	return -1;
}


function planets_without_type(type,star="none"){
	var return_planets = [];
	if (star=="none"){
		for(var i = 1; i <= planets; i++){
			if(p_type[i] != type){
				array_push(return_planets, i);
			}
		}
	} else {
		with (star){
			return_planets = planets_without_type(type);
		}
	}
	return return_planets;
}

function scr_star_has_planet_with_type(star, type){
	return scr_get_planet_with_type(star,type) != -1;
}

function scr_get_planet_with_owner(star, owner){
	for(var i = 1; i <= star.planets; i++){
		if(star.p_owner[i] == owner)
			{
				return i;
			}
		}
	return -1;
}

function scr_star_has_planet_with_owner(star, owner){
	return scr_get_planet_with_owner(star,owner) != -1;
}

function scr_get_stars(shuffled=false, ownership=[]) {
	var stars = [];
	var _owner_sort = array_length(ownership);
	with(obj_star){
		if (!_owner_sort){
			array_push(stars,id);
		} else {
			if (array_contains(ownership,owner)){
				array_push(stars,id);
			}
		}
	}
	if (shuffled){
		stars = array_shuffle(stars);
	}
	return stars;
}

function planet_imperium_ground_total(planet_check){
    return p_guardsmen[planet_check]+p_pdf[planet_check]+p_sisters[planet_check]+p_player[planet_check];
}

function star_by_name(search_name){
	with(obj_star){
		if (name = search_name){
			return self;
		}
	}
	return "none";
}

function distance_removed_star(origional_x,origional_y, star_offset = choose(2,3), disclude_hulk=true, disclude_elder=true, disclude_deads=true, warp_concious=true){
	var from = instance_nearest(origional_x,origional_y,obj_star);
    for(var i=0; i<star_offset; i++){
        from=instance_nearest(origional_x,origional_y,obj_star);
        with(from){
        	instance_deactivate_object(id);
        };
        from=instance_nearest(origional_x,origional_y,obj_star);
        if (instance_exists(from)){
	        if (disclude_elder && from.owner==eFACTION.Eldar){
	        	i--;
	        	instance_deactivate_object(from);
	        	continue;
	        }
	        if (disclude_deads){
	        	if (is_dead_star(from)){
		        	i--;
		        	instance_deactivate_object(from);
		        	continue;        		
	        	}
	        }
	    }        
    }
    //from=instance_nearest(origional_x,origional_y,obj_star);
    instance_activate_object(obj_star);
    //TODO finish this off to make the distance remove more concious of warp lanes
    /*if (warp_concious){
    	var options = [from];
    }*/
    return from;     
}


function nearest_star_proper(xx,yy) {
	var i=0;
	var cur_star;
	while(i<100){
		i++;
		cur_star = instance_nearest(xx,yy, obj_star);
		if (!cur_star.craftworld && !cur_star.space_hulk){
			instance_activate_object(obj_star);
			return cur_star.id;
		}
		instance_deactivate_object(cur_star.id);
	}
	return "none";
}


function nearest_star_with_ownership(xx,yy, ownership, start_star="none", ignore_dead = true){
	var nearest = "none"
	var total_stars =  instance_number(obj_star);
	var i=0;
	if (!is_array(ownership)){
		ownership = [ownership];
	}
	while (nearest=="none" && i<total_stars){
		i++;
		var cur_star =  instance_nearest(xx,yy, obj_star);
		if (start_star!="none"){
			if (start_star.id == cur_star.id ||( is_dead_star(cur_star) && ignore_dead)){
				instance_deactivate_object(cur_star.id);
				continue;
			}
		}
		if (array_contains(ownership, cur_star.owner)){
			nearest=cur_star.id;
		} else {
			instance_deactivate_object(cur_star.id);
		}
	}
	instance_activate_object(obj_star);
	return nearest;
}

function find_population_doners(doner_to=0){
    var pop_doner_options = [];
	with(obj_star){
		if (obj_star.id == doner_to) then continue;
	   for (var r=1;r<=planets;r++){
	        if ((p_owner[r]=eFACTION.Imperium) and (p_type[r]=="Hive") and (p_population[r]>0) and (p_large[r])){
                array_push(pop_doner_options, [id, r]);
            };
	    }
	}
    return pop_doner_options
}

function planet_numeral_name(planet, star="none"){
	if (star=="none"){
		return $"{name} {scr_roman(planet)}";
	} else {
		with (star){
			return $"{name} {scr_roman(planet)}";
		}		
	}
}

function new_star_event_marker(colour){
    var bob=instance_create(x+16,y-24,obj_star_event);
    bob.image_alpha=1;
    bob.image_speed=1;
    bob.color=colour;
}

function nearest_from_array(xx,yy,list){
	var _nearest = 0;
	var nearest_dist = point_distance(xx, yy ,list[_nearest].x, list[_nearest].y)
	for (var i=1;i<array_length(list);i++){
		if (point_distance(xx, yy, list[i].x,list[i].y) < nearest_dist){
			_nearest = i;
			nearest_dist = point_distance(xx, yy, list[i].x,list[i].y);
		}
	}
	return  _nearest;
}

function is_dead_star(star="none"){
	var dead_star=true;
	if (star=="none"){
		for (var i=1;i<=planets;i++){
			if (p_type[i] !="dead"){
				dead_star=false;
				break;
			}
		}
	} else {
		with (star){
			dead_star = is_dead_star();
		}
	}
	return dead_star;
}

function scr_create_space_hulk(xx,yy){
	var hulk = instance_create(xx,yy,obj_star); 
    hulk.space_hulk=1;
    hulk.p_type[1]="Space Hulk";
    hulk.name=global.name_generator.generate_hulk_name();	
    return hulk;
}

function scr_faction_string_name(faction){
	name = "";
	switch (faction){
		case eFACTION.Imperium:
			name = "Imperium";
			break;
		case eFACTION.Mechanicus:
			name = "Mechanicus";
			break;
		case eFACTION.Inquisition:
			name = "Inquisition";
			break;
		case eFACTION.Ecclesiarchy:
			name = "Ecclesiarchy";
			break;	
		case eFACTION.Eldar:
			name = "Eldar";
			break;	
		case eFACTION.Tau:
			name = "Tau";
			break;																
	}
	return name;
}

function scr_planet_image_numbers(p_type){
	var image =0;
	image_map = ["","Lava","Lava", "Desert","Forge","Hive","Death","Agri","Feudal","Temperate","Ice","Dead","Daemon","Craftworld","","Space Hulk", "", "Shrine"];
	for (var i=0;i<array_length(image_map);i++){
		if (image_map[i] == p_type) then return i;
	}
	return image;
}
//function scr_get_player_fleets() {
//	var player_fleets = [];
//	with(obj_p_fleet){
//		array_push(player_fleets,id);
//	}
//	return player_fleets;


//}

