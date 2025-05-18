enum P_features {
			Sororitas_Cathedral,
			Necron_Tomb,
			Artifact, 
			STC_Fragment,
			Ancient_Ruins,
			Cave_Network,
			Recruiting_World, 
			Monastery,
			Warlord6,
			OrkWarboss,
			Warlord10,
			Special_Force,
			World_Eaters,
			Webway,
			Secret_Base,
			Starship,
			Succession_War,
			Mechanicus_Forge,
			Reclamation_pools,
			Capillary_Towers,
			Daemonic_Incursion,
			Victory_Shrine,
			Arsenal,
			Gene_Vault,
			Forge,
			Gene_Stealer_Cult,
			Mission,
			OrkStronghold

	};
	
enum base_type{
	Lair,
}

function PlayerForge() constructor{
	constructions = [];
	size = 1;
	techs_working = 0;
	f_type = P_features.Forge;
	vehicle_hanger=0;
}

// Function creates a new struct planet feature of a  specified type
function NewPlanetFeature(feature_type, other_data={}) constructor{
	f_type = feature_type;
	static reveal_to_player = function(){
		if (player_hidden == 1){
			player_hidden = 0;
		}
	}
	switch(f_type){
		case P_features.Gene_Stealer_Cult:
		PDF_control = 0;
		sealed = 0;
		player_hidden = 1;
		planet_display = "Genestealer Cult";
		cult_age = 0;
		hiding=true;
		name = global.name_generator.generate_genestealer_cult_name();		
		break;
		case P_features.Necron_Tomb:
		awake = 0;
		sealed = 0;
		player_hidden = 1
		planet_display = "Dormant Necron Tomb";
		break;

	case P_features.Secret_Base:
		base_type = 0;
		inquis_hidden =1;
		planet_display = "Hidden Secret Base";
		player_hidden = 0;
		style = "UTL";
		if (struct_exists(other_data, "style")){
			style = other_data[$ "style"];
		}
		built = obj_controller.turn +3;
		forge = 0;
		hippo=0;
		beastarium=0;
		torture=0;
		narcotics=0;
		relic=0;
		cookery=0;
		vox=0;
		librarium=0;
		throne=0;
		stasis=0;
		swimming=0;
		stock=0;
		break;
	case P_features.Arsenal:
		inquis_hidden = 1;
		planet_display = "Arsenal";
		player_hidden = 0;
		built = obj_controller.turn+3;
		break;
	case P_features.Gene_Vault:
		inquis_hidden=1;
		planet_display = "Arsenal";
		player_hidden = 0;
		built = obj_controller.turn+3;
		break;
	case P_features.Starship:
		f_type = P_features.Starship;
		planet_display = "Ancient Starship";
		funds_spent = 0;
		player_hidden = 0;
		engineer_score = 0;
	break;	
	case P_features.Ancient_Ruins:
		static ruins_explored = scr_ruins_explored;
		static explore = scr_explore_ruins;
		static determine_race = scr_ruins_determine_race;
		static recover_from_dead = scr_ruins_recover_from_dead;
		static forces_defeated = scr_ruins_player_forces_defeated;
		static find_starship =  scr_ruins_find_starship;
		static suprise_attack = scr_ruins_suprise_attack_player;
		static ruins_combat_end=scr_ruins_combat_end;
		scr_ancient_ruins_setup();
		break;
	case P_features.STC_Fragment:
		player_hidden = 1;
		Fragment_type =0;
		planet_display = "STC Fragment";
		break;
	case P_features.Cave_Network:
		player_hidden = 1;
		cave_depth =irandom(3);//allow_multiple levels of caves, option to go deeper
		planet_display = "Unexplored Cave Network";
		break;
	case P_features.Sororitas_Cathedral:
		player_hidden = 1;
		planet_display = "Sororitas Cathedral";
		break;
	case P_features.Artifact:
		player_hidden = 1;
		planet_display = "Artifact";
		break;
	case P_features.OrkWarboss:
		player_hidden = 1;
		planet_display = "Ork Warboss";
		Warboss = "alive";
		turns_static = 0;
		break;
	case P_features.OrkStronghold:
		player_hidden = 1;
		planet_display= "Ork Stronghold";
		tier = 1;
		break;
	case P_features.Monastery:
		planet_display="Fortress Monastary";
		player_hidden = 0;
		forge=0;
		name=global.name_generator.generate_imperial_ship_name();
		break;
	case P_features.Recruiting_World:
		planet_display="Recruitment";
		player_hidden = 0;
        recruit_type = 0;
        recruit_cost = 0;
		break;
	default:
		player_hidden = 1;
		planet_display = 0;
	}
	if (global.cheat_debug){
		player_hidden = 0;
	}
	static load_json_data = function(data){
		 var names = variable_struct_get_names(data);
		 for (var i = 0; i < array_length(names); i++) {
            variable_struct_set(self, names[i], variable_struct_get(data, names[i]))
        }
	}
}

// returns an array of all the positions that a certain planet feature occurs on th p_feature array of a planet
// this works for both planet_Features and planet upgrades
function search_planet_features(planet, search_feature){
	var feature_count = array_length(planet);
	var feature_positions = [];
	if (feature_count > 0){
		for (var fc = 0; fc < feature_count; fc++){
			if (planet[fc].f_type == search_feature){
				array_push(feature_positions, fc);
			}
		}
	}
	return feature_positions;
}

function return_planet_features(planet, search_feature){
	var feature_count = array_length(planet);
	var feature_positions = [];
	if (feature_count > 0){
		for (var fc = 0; fc < feature_count; fc++){
			if (planet[fc].f_type == search_feature){
				array_push(feature_positions, planet[fc]);
			}
		}
	}
	return feature_positions;	
}

// returns 1 if dearch feature is on at least one planet in system returns 0 is search feature is not found in system
function system_feature_bool(system, search_feature){
	var sys_bool = 0;
	for (var sys =1; sys<5; sys++){
		sys_bool = planet_feature_bool(system[sys], search_feature)
		if (sys_bool==1){
		break;}
	}
	return sys_bool;
}


//returns 1 if feature found on given planet returns 0 if feature not found on planet
function planet_feature_bool(planet, search_feature){
	var feature_count = array_length(planet);
	var feature_exists = 0;
	if (feature_count > 0){
	for (var fc = 0; fc < feature_count; fc++){
		if (!is_array(search_feature)){
			if (planet[fc].f_type == search_feature){
				feature_exists = 1;
			}
		} else {
			feature_exists = array_contains(search_feature,planet[fc].f_type);
		}
		if (feature_exists == 1){break;}
	}}
	return feature_exists;	
}


//deletes all occurances of del_feature on planet
function delete_features(planet, del_feature){
	var delete_Array = search_planet_features(planet, del_feature);
	if (array_length(delete_Array) >0){
		for (var d=0;d<array_length(delete_Array);d++){
			array_delete(planet, delete_Array[d],1)
		}
	}
}


// returns 1 if an awake necron tomb iin system
function awake_necron_Star(star){
		for(var i = 1; i <= star.planets; i++){
		if(awake_tomb_world(star.p_feature[i]) == 1)
			{
				return i;
			}
		}
		return 0
}


//returns 1 if awake tomb world on planet 0 if tombs on planet but not awake and 2 if no tombs on planet
function awake_tomb_world(planet){
	var awake_tomb = 0;
	 var tombs = search_planet_features(planet, P_features.Necron_Tomb);
	 if (array_length(tombs)>0){
		 for (var tomb =0;tomb<array_length(tombs);tomb++){
			 if (planet[tombs[tomb]].awake = 1){
				awake_tomb = 1;
			 }
			 if (awake_tomb = 1){break;}
		 }
		 return awake_tomb;
	 }
	 return 2;
}


//selas a tomb world and switche off awake so will no longer spawn necrons or necron fleets
function seal_tomb_world(planet){
	var awake_tomb = 0;
	 var tombs = search_planet_features(planet, P_features.Necron_Tomb);
	 if (array_length(tombs)>0){
		 for (var tomb =0;tomb<array_length(tombs);tomb++){
			awake_tomb = 1;
			planet[tombs[tomb]].awake = 0;
			planet[tombs[tomb]].sealed = 1;
			planet[tombs[tomb]].planet_display = "Sealed Necron Tomb";
			 if (awake_tomb = 1) then break;
		 }
	 }
}


//awakens a tomb world so necrons and necron fleets will spawn
function awaken_tomb_world(planet){
	var awake_tomb = 0;
	 var tombs = search_planet_features(planet, P_features.Necron_Tomb);
	 if (array_length(tombs)>0){
		 for (var tomb =0;tomb<array_length(tombs);tomb++){
			if (planet[tombs[tomb]].awake == 0){
				awake_tomb = 1;
				planet[tombs[tomb]].awake = 1;
				planet[tombs[tomb]].planet_display = "Active Necron Tomb";
			}
			if (awake_tomb = 1){break;}
		 }
		 
	 }
}


// creates alerts for discovering features on a planet
function scr_planetary_feature(planet_num) {
	var plan_feat_count = array_length(p_feature[planet_num]);
	//need to iterate over features instead of just looking at first
	for (var f= 0; f < plan_feat_count;f++){
		var feat = p_feature[planet_num][f];
		if (feat.player_hidden ==1){
			feat.player_hidden =0;
			var numeral_n = planet_numeral_name(planet_num);
			switch (feat.f_type){
				case P_features.Sororitas_Cathedral:
					if (obj_controller.known[eFACTION.Ecclesiarchy]=0) then obj_controller.known[eFACTION.Ecclesiarchy]=1;
				    var lop=$"Sororitas Cathedral discovered on {numeral_n}.";
				    scr_alert("green","feature",lop,x,y);
				    scr_event_log("",lop);
				    if (p_heresy[planet_num]>10) then p_heresy[planet_num]-=10;
				    p_sisters[planet_num]=choose(2,2,3);goo=1;
					break;
				case P_features.Necron_Tomb:
				    var lop=$"Necron Tomb discovered on {numeral_n}.";
				    scr_alert("red","feature",lop,x,y);
				    scr_event_log("red",lop);
					break;
				case P_features.Artifact:
					var lop=$"Artifact discovered on {numeral_n}.";
					scr_alert("green","feature",lop,x,y);
					scr_event_log("",lop);
					break;
				case P_features.STC_Fragment:
					var lop=$"STC Fragment located on {numeral_n}.";
					 scr_alert("green","feature",lop,x,y);
					 scr_event_log("",lop);
					 break;
				case P_features.Ancient_Ruins:
					var lop=$"A {feat.ruins_size} Ancient Ruins discovered on {string(name)} {scr_roman(planet_num)}.";
					scr_alert("green","feature",lop,x,y);
					scr_event_log("",lop);
					break;
				case P_features.Cave_Network:
					var lop=$"Extensive Cave Network discovered on {numeral_n}.";
			        scr_alert("green","feature",lop,x,y);
			        scr_event_log("",lop);
					break;
				case P_features.OrkWarboss:
				    var lop=$"Ork Warboss discovered on {numeral_n}.";
				    scr_alert("red","feature",lop,x,y);
				    scr_event_log("red",lop);
					break;		
			}
		}
	}
}

function create_starship_event(){
	var star = scr_random_find(2,true,"","");
	if(star == undefined){
		log_error("RE: couldn't find starship target");
		return false;
	}else {
		var planet=irandom(star.planets-1)+1;
		array_push(star.p_feature[planet], new NewPlanetFeature(P_features.Starship))
		scr_event_log("","Ancient Starship discovered on "+string(star.name)+" "+scr_roman(planet)+".", star.name);
	}
}
