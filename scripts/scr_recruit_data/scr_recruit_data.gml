enum eTrials{
	BLOODDUEL,
	HUNTING,
	SURVIVAL,
	EXPOSURE,
	KNOWLEDGE,
	CHALLENGE,
	APPRENTICESHIP,
	num
}
#macro ARR_recruitment_pace [" is currently halted."," is advancing sluggishly."," is advancing slowly."," is advancing moderately fast."," is advancing fast."," is advancing frenetically."," is advancing as fast as possible."]

#macro ARR_recruitement_rate  ["HALTED","SLUGGISH","SLOW","MODERATE","FAST","FRENETIC","MAXIMUM",]

#macro ARR_recruitment_rates  ["halted","sluggish","slow","moderate","fast","frenetic","hereticly fast"]
#macro ARR_apothecary_training_tiers [0,0.8,0.9,1,1.5,2,4 ]
#macro ARR_chaplain_training_tiers  [0,0.8,0.9, 1,1.5,2,4]
#macro ARR_techmarine_training_tiers  [0,1,2,4, 6,10,14]

function find_recruit_success_chance(local_apothecary_points, planet_type){
	var recruit_type = scr_trial_data(obj_controller.recruit_trial);
	var recruit_chance_array = [0, 1000, 900, 800, 700, 600, 500];
    var planet_type_recruit_chance = {
        "Hive" : 30,
        "Temperate" : 20,
        "Feudal" : 20,
        "Forge" : 15,
        "Shrine" : 15,
        "Desert" : 15,
        "Ice" : 15,
        "Agri" : 15,
        "Death" : 15,
        "Lava" : 15,
    }
    recruit_chance = 0;
    if (obj_controller.recruiting>0){
        var recruit_chance = recruit_chance_array[obj_controller.recruiting];
    }    
     var recruit_chance_total = 0;
    if (struct_exists(planet_type_recruit_chance, planet_type)){
        recruit_chance_total = planet_type_recruit_chance[$ planet_type]+local_apothecary_points;
        if (struct_exists(recruit_type, "recruit_count_modifier")){
            var modded=false;
            var count_mod = recruit_type.recruit_count_modifier;
            if (struct_exists(count_mod, "planets")){
                if (struct_exists(count_mod.planets, planet_type)){
                    recruit_chance_total*=(count_mod.planets[$planet_type]);
                    modded=true;
                }
            }
            if (!modded && struct_exists(count_mod, "base")){
                recruit_chance_total*=count_mod.base;
            }
        }
    }
    if (recruit_chance!=0){
		var _success_chance = recruit_chance_total/recruit_chance;   	
    } else{
    	_success_chance = 0;
    }
    return _success_chance;
}
// to be run in teh scope of the PlanetData struct
function planet_training_sequence(local_apothecary_points){

    var thirdpop = max_population / 3;
    var halfpop = max_population / 2;	

	if (planet_feature_bool(features, P_features.Recruiting_World)) and(obj_controller.gene_seed > 0) and(current_owner <= 5) and(obj_controller.faction_status[current_owner] != "War") {
        var _planet_population = population;
        if (large_population) {
            _planet_population *= 1000000000;
        }		
	    if (_planet_population >= 50 && obj_controller.recruiting) {
	        // Commenting this for now, looks like debug code
	        //scr_alert("green","owner", "Recruitment is slowed due to lack of population on our recruitment worlds",0,0);
	        var recruit_type = scr_trial_data(obj_controller.recruit_trial);
	        if (!large_population) then population-= 1;

	        var recruit_chance = 999;
	        var aspirant = 0;
	        var new_recruit_corruption = 10;
	        var months_to_neo = 72;
	        var dista = 0;
	        var onceh = 0;
	        
	        var _recruit_chance = find_recruit_success_chance(local_apothecary_points, planet_type)
	        aspirant = random(1)<_recruit_chance;

	        // if a planet type has less than half it's max pop, you get 20% less spacey marines
	        if (_planet_population <= halfpop) {
	            recruit_chance += 1.2;
	           // scr_alert("red", "owner", "The populations you attain aspirants from are less populant than required, chances of recruiting aspirants is 20% lower", 0, 0);
	        }

	        // This is the area has trial types that don't care about planet type 
	        // xp is given in a latter if loop
	        if (struct_exists(recruit_type, "seed_waste")){
	            if (obj_controller.recruiting > 0) {
	                if (random(1)<recruit_type.seed_waste){
	                    obj_controller.gene_seed--;
	                    //TODO make more informative
	                    scr_alert("red", "owner", "Blood Duels are efficient in time, but costly in risk with gene material. Gene-seed has been lost.", 0, 0);
	                }
	            }
	        }
	        if (struct_exists(recruit_type, "train_time")){
	            var train_time_data =  recruit_type.train_time;
	            var chosen_time = false;
	            if (struct_exists(train_time_data, "planets")){
	                if (struct_exists(train_time_data.planets, planet_type)){
	                    months_to_neo = irandom_range(train_time_data.planets[$planet_type][0], train_time_data.planets[$planet_type][1]);
	                    chosen_time=true;
	                }
	            }
	            if (!chosen_time && struct_exists(train_time_data, "base")){
	                if (train_time_data.base[0]!=0 && train_time_data.base[1]!=0){
	                    months_to_neo = irandom_range(train_time_data.base[0], train_time_data.base[1]);
	                }
	            }
	        }
	        var new_recruit_exp = irandom(5);
	        if (struct_exists(recruit_type, "exp_bonus")){
	            var chosen_exp = false;
	            var exp_bonus_data =  recruit_type.exp_bonus;
	            if (struct_exists(exp_bonus_data, "planets")){
	                if (struct_exists(exp_bonus_data.planets, planet_type)){
	                    new_recruit_exp += irandom_range(exp_bonus_data.planets[$planet_type][0], exp_bonus_data.planets[$planet_type][1]);
	                    chosen_exp = true;
	                }
	            }
	            if (!chosen_exp && struct_exists(exp_bonus_data, "base")){
	                if (exp_bonus_data.base[0]!=0 && exp_bonus_data.base[1]!=0){
	                    if (array_length(exp_bonus_data.base)>2){
	                        if (random(1)<exp_bonus_data.base[2]){
	                             new_recruit_exp += irandom_range(exp_bonus_data.base[0], exp_bonus_data.base[1]);
	                        }
	                    } else {
	                        new_recruit_exp = irandom_range(exp_bonus_data.base[0], exp_bonus_data.base[1]);
	                    }
	                }                            
	            }
	        }
	        //new_recruit_corruption

	        // xp gain for the recruit is here
	        // as well as planet type buffs or nerfs
	        if (aspirant) {

	            var i = 0;
	            var new_recruit = 0;

	            // gets the next empty recruit space on the array
	            if (new_recruit_exp >= 40) then new_recruit_exp = 38;// we don't want immediate battle bros

	            for (var i=0;i<array_length(obj_controller.recruit_training);i++) {
	                if (obj_controller.recruit_training[i]<1 || months_to_neo<obj_controller.recruit_training[i]){
	                    obj_controller.gene_seed -= 1;
	                    array_insert(obj_controller.recruit_corruption, i, new_recruit_corruption);
	                    array_insert(obj_controller.recruit_distance , i, 0);
	                    array_insert(obj_controller.recruit_training, i, months_to_neo);
	                    array_insert(obj_controller.recruit_exp, i, new_recruit_exp); 
	                    array_insert(obj_controller.recruit_name, i, global.name_generator.generate_space_marine_name());    
	                    array_insert(obj_controller.recruit_data, i, {"recruit_data":{
	                        recruit_world :planet_type ,
	                        aspirant_trial :obj_controller.recruit_trial ,
	                    }});                                                                                                   
	                    break;
	                }
	            }
	        }
	        // End aspirant!=0
	    } // End pop>50
	} // End recruiting possible	
}

function scr_trial_data(wanted=-1){
	var role_data = instance_exists(obj_ini)? obj_ini.role[100] : obj_creation.role[100];
	var data = [
		{
			name : "Blood Duel",
			train_time : {
				base : [24, 48],
			},
			recruit_count_modifier : {
				base : 0.3,
			},
			seed_waste : 0.1,
			corruption :{
				base : [10,20],
				planets :{

				}
			},		
			long_description :$"THE BLOOD DUEL?  HA DO I EVEN NEED TO EXPLAIN, CHAPTER MASTER?  ASPIRANTS ENTER.  NEOPHYTES LEAVE.  Those worthy of serving the Emperor are rewarded justly and those merely pretending at glory are lost in the BLOOD AND THUNDER of the dome.  Do not be alarmed at the carnage.  The Apothecarium has become quite adept at rebuilding those fit to serve.  The others are given to the {role_data[eROLE.Techmarine]}s.  The mind is a terrible thing to waste and the Emperor does hate waste.  Not every man is useful as an Astartes but every man is useful.",
		},
		{
			name : "Hunting the Hunter",
			train_time : {
				base : [72, 80],
			},
			exp_bonus : {
				base:[0,0],
				planets : {
					Ice : [7,10],
					Desert : [7,10],
					Death : [7,10]
				}
			},
			recruit_count_modifier : {
				base : 1,
				planets : {
					Ice :2,
					Desert : 1.25,
					Death : 3,
					Feudal : 1.5
				}				
			},
			long_description :$"To be an Astartes is to be a hunter of xenos, of traitors, of heretics, and of all those that dare defy the Emperor.  What better way to test the worthiness of Aspirants than to have to them hunt the most dangerous predator to be found on their planet?  Such a task requires a combination of wits and cunning, in addition to raw martial skill.  When they have received the blessed geneseed and become full battle brothers, they will hunt across the stars with bolter and chainsword. For now, let them hunt with nothing more than a spear and their wits.",				
		},
		{
			name : "Survival of the Fittest",
			train_time : {
				base : [72, 80],
			},
			recruit_count_modifier : {
				base : 1.0,
				planets : {
					Ice :3,
					Desert : 3,
					Death : 3,
					Feudal : 3
				}
			},
			exp_bonus : {
				base:[0,0],
			},
			long_description :$"To become one of the Imperium’s finest warriors, the Space Marines, is the greatest glory that any human can aspire to. And is glory not worth fighting, bleeding or even dying for? It must be, for whole worlds of ice, ash and sand have buried generations of sons in pursuit of this glory and never once called the price too dear.  To ensure the necessary bloodshed, lies, paranoia and psychosis-inducing drugs have been introduced to .  This trial will seperate the weak from the strong and the chaff from the wheat.",				
		},
		{
			name : "Exposure",
			train_time : {
				base : [72, 80],
				planets : {
					Desert :[36, 60],
					Ice :[36, 60],
					Forge :[36, 60],
					Lava :[36, 60],
					Death :[36, 60],
				}
			},
			exp_bonus : {
				base:[0,0],
				planets : {
					Ice : [2,4],
					Desert : [2,4],
					Death : [2,4],
				}
			},
			recruit_count_modifier : {
				base : 1.0,
			},
			long_description :$"Few worlds of the Imperium are free from the adversity of pollution or toxic waste.  Still others are bequeathed with flows of lava and choking atmosphere.  The glory of rising to astartes is only granted to those that can tackle and overcome these dangerous environments.  Aspirants are placed upon the most hellish of planet in the sector, and then expected to traverse the continent with only himself to rely upon.  Those who face the impossible without faltering and survive past the point they should have perished are recovered by {role_data[eROLE.Apothecary]}s, judged worthy of becoming a Neophyte.",						
		},
		{
			name : "Knowledge of self",
			train_time : {
				base : [90, 108],
				planets : {
					shrine :[70, 108],
				}
			},
			exp_bonus : {
				base: [15,25],
				planets : {
					Temperate : [20,35],
				}
			},
			recruit_count_modifier : {
				base : 1.0,
			},		
			long_description :$"An Aspirant’s spiritual and mental capability is every bit as important as his physical characteristics.  It is wise to impose Trials not upon their body, but on the mind.  Either through psychic powers, chemical agents, or endurance trials, the Aspirant’s willpower is tested.  Those unworthy do not survive the stress and trauma placed upon their hearts- only those whose minds are proven to be unbreakable are welcomed into our ranks.",							
		},
		{
			name : "Combat Challange",
			train_time : {
				base : [66, 80],
				planets : {
					shrine :[70, 108],
				}
			},
			exp_bonus : {
				base: [10,20,0.2],
			},
			long_description :$"What better gauge of an Aspirant than in a duel with our astartes?  Our brother, unarmed and unarmoured, will face against the armed challenger until one cannot continue.  It is impossible for the Aspirant to actually succeed these trials, but demonstrates how far they can possibly go, and allow us to judge him accordingly.  As with most trials the Aspirant’s life is in their own hands.  He who has failed the duel- yet proven himself worthy- is rescued from the jaws of death by {role_data[eROLE.Apothecary]} and allowed to progress to the rank of Neophyte.",				
		},
		{
			name : "Apprenticeship",
			train_time : {
				base : [120, 140],
				planets : {
					shrine :[70, 108],
				}
			},
			exp_bonus : {
				base: [35, 40],
			},
			recruit_count_modifier : {
				base : 1,
				planets : {
					Lava :2,
				},			
			},
			corruption :{
				base : [0,-10],
				planets :{

				}
			},
			long_description :$"What better way to cultivate astartes than to raise them from youth?  The capable children of our recruitment targets are apprenticed to our battle brothers.  Beneath their steady guidance the Aspirants spend several years learning the art of the smith.  The most able are judged by our Chapter’s {role_data[eROLE.Apothecary]}s and {role_data[eROLE.Chaplain]} to deem if they are compatible with gene-seed implantation.  If so, the Aspirant’s trial culminates in hunting and slaying a massive beast.  Only the brightest and bravest are added to our ranks.",									
		},						
	]
	if (wanted>-1){
		var train_traits = find_favoured_training_traits(wanted);
		data[wanted].favoured_traits = train_traits[1];
		data[wanted].disfavoured_traits = train_traits[0];
		return data[wanted];
	} else {
		for (var i=0;i<array_length(data);i++){
			var train_traits = find_favoured_training_traits(i);
			data[i].favoured_traits = train_traits[1];
			data[i].disfavoured_traits = train_traits[0];
			data[i].stat_diffs = train_traits[2];
		}
		return data;
	}
}

function find_favoured_training_traits(training_enum){
	var _traits = global.astartes_trait_dist;
	var _trait_data;
	var disfavoured_traits = [];
	var favoured_traits = [];
	var trait_id ="";
	var stat_diffs = {};
	var _stat_names = ARR_stat_list;
	for (var i=0;i<array_length(_stat_names);i++){
		stat_diffs[$_stat_names[i]] = 0;
	}

	for (var i=0;i<array_length(_traits);i++){
		_trait_data = _traits[i];
		trait_id = _trait_data[0]
		if (array_length(_trait_data) >= 3){
			var _trait_spawn_mods = _trait_data[2];
			if (is_struct(_trait_spawn_mods)){
				if (struct_exists(_trait_spawn_mods,"recruit_trial")){
					var _trial_spawn_mods = _trait_spawn_mods.recruit_trial;
					for (var s=0;s<array_length(_trial_spawn_mods);s++){
						if (_trial_spawn_mods[s][0] == training_enum){
							var _trait_spawn_chance = _trial_spawn_mods[s][1];
							var _spawn_percent = (_trait_spawn_chance/_trait_data[1][0])*-1;
							if (_trial_spawn_mods[s][1]){
								array_push(disfavoured_traits, trait_id);
							} else {
								array_push(favoured_traits, trait_id);
							}
							if (_spawn_percent!=0){
								var _trait_stats = global.trait_list[$ trait_id];
								for (var stat_i = 0;stat_i<array_length(_stat_names);stat_i++){
									var stat = _stat_names[stat_i];
									if (struct_exists(_trait_stats,stat)){
										var _stat_value = _trait_stats[$stat];
										if (is_array(_stat_value)){
											_stat_value = _stat_value[0];
										}
										stat_diffs[$ stat] += _stat_value*_spawn_percent;
									}
								}
							}
							break;
						}
					}
				}
			}
		}
	}
	return [disfavoured_traits, favoured_traits,stat_diffs];
}
function scr_compile_trial_bonus_string(trial_data){
	var bonus_string = "";
	var  train_time_string = function(tarray){
		return $"{tarray[0]/12} - {tarray[1]/12}" ;
	}
	var  exp_bonus_string = function(tarray){
		if (tarray[0] == 0 && tarray[1]==0){
			tarray[1]=5;
		}
		return $"{tarray[0]} - {tarray[1]}" ;
	}	
	if (struct_exists(trial_data,"train_time")){
		var train_time_data = trial_data.train_time;
		bonus_string+=$"years training : {train_time_string(train_time_data.base)}\n";
		if (struct_exists(train_time_data, "planets")){
			var planets = struct_get_names(train_time_data.planets);
			for (var i=0;i<array_length(planets);i++){
				bonus_string += $"   {planets[i]} : {train_time_string(train_time_data.planets[$ planets[i]])}\n";
			}
		}
		bonus_string+= "\n";
	}
	if (struct_exists(trial_data,"recruit_count_modifier")){
		var recruit_count_data = trial_data.recruit_count_modifier;
		bonus_string+=$"Recruit Success Chance : X{recruit_count_data.base}\n";
		if (struct_exists(recruit_count_data, "planets")){
			var planets = struct_get_names(recruit_count_data.planets);
			for (var i=0;i<array_length(planets);i++){
				bonus_string += $"   {planets[i]} : X{recruit_count_data.planets[$ planets[i]]}\n";
			}
		}
		bonus_string+= "\n";
	}
	if (struct_exists(trial_data,"exp_bonus")){
		var exp_bonus = trial_data.exp_bonus;
		bonus_string+=$"Experience Bonus : {exp_bonus_string(exp_bonus.base)}\n";
		if (struct_exists(exp_bonus, "planets")){
			var planets = struct_get_names(exp_bonus.planets);
			for (var i=0;i<array_length(planets);i++){
				bonus_string += $"   {planets[i]} : {exp_bonus_string(exp_bonus.planets[$ planets[i]])}\n";
			}
		}
		bonus_string+= "\n";
	}
	if (struct_exists(trial_data,"seed_waste")){
		bonus_string+=$"{trial_data.seed_waste*100}% of gene-seed wastage per turn\n"
		bonus_string+= "\n";
	}
	if (struct_exists(trial_data,"corruption")){
		var corruption_bonus = trial_data.corruption;
		bonus_string+=$"Corruption Effect : {exp_bonus_string(corruption_bonus.base)}\n";
		if (struct_exists(corruption_bonus, "planets")){
			var planets = struct_get_names(corruption_bonus.planets);
			for (var i=0;i<array_length(planets);i++){
				bonus_string += $"   {planets[i]} : {exp_bonus_string(corruption_bonus.planets[$ planets[i]])}\n";
			}
		}
		bonus_string+= "\n";
	}
	var _traits = global.trait_list;
	if (struct_exists(trial_data,"favoured_traits")){
		bonus_string += "Favoured Traits:"
		for (var i=0;i<array_length(trial_data.favoured_traits);i++){
			var _favoured_trait = trial_data.favoured_traits[i];
			bonus_string += $"{_traits[$ _favoured_trait].display_name}, ";
		}
		bonus_string+="\n\n";
	}
	if (struct_exists(trial_data,"disfavoured_traits")){
		bonus_string += "Dis-Favoured Traits:"
		for (var i=0;i<array_length(trial_data.disfavoured_traits);i++){
			var _disfavoured_trait = trial_data.disfavoured_traits[i];
			bonus_string += $"{_traits[$ _disfavoured_trait].display_name}, ";
		}
		bonus_string+="\n\n";
	}
	if (struct_exists(trial_data,"stat_diffs")){
		bonus_string+=$"{trial_data.stat_diffs}\n";
	}		
	return bonus_string;
}
function StatDistributionUnit(data) constructor{
	data_upper_end = 0;
	data_lower_end =0;
	var _stat_names = ARR_stat_list;
	for (var i=0;i<array_length(_stat_names);i++){
		var _stat = _stat_names[i];
		if (data[$_stat]<data_lower_end){
			data_lower_end=data[$_stat];
		}
		if (data[$data_upper_end]>data_upper_end){
			data_lower_end=data[$_stat];
		}
	}
	//data_upper_end = 
	static draw = function(){

	}
}
function set_up_recruitment_view(){
	with (obj_controller){
	    menu=15;
	    onceh=1;
	    cooldown=8000;
	    click=1;
	    recruit_list_pane = new DataSlate();
	    recruit_list_pane.inside_method = function(){
		    var xx=__view_get( e__VW.XView, 0 )+0;
		    var yy=__view_get( e__VW.YView, 0 )+0+60;
		    draw_set_font(fnt_40k_30b);
		    draw_set_halign(fa_center);
		    draw_text_transformed(xx + 1242, yy + 70, "Neophytes", 0.6, 0.6, 0);

		    if (recruit_name[0] != "") {
		        draw_set_font(fnt_40k_14);
		        draw_set_halign(fa_left);

		        var t_eta = 0;
		        for (var qp = 0, n = 0; qp < array_length(recruit_name) && n < 36; qp++) {
		            if (recruit_name[qp] != "") {
		                n++;
		                draw_rectangle(xx + 947, yy + 100 + ((n - 1) * 20), xx + 1577, yy + 100 + (n * 20), 1);
		                draw_text(xx + 950, yy + 100 + ((n - 1) * 20), $"Neophyte {recruit_name[qp]}");
		                draw_text(xx + 1200, yy + 100 + ((n - 1) * 20), $"Starting EXP: {recruit_exp[qp]}");
		                draw_text(xx + 1500, yy + 100 + ((n - 1) * 20),$"ETA: {recruit_training[qp] + recruit_distance[qp]}");
		            }
		        }
		    }	
	    }	    
	    left_panel = new DataSlate();
	    middle_panel = new DataSlate();
	}
}

/// @mixin
function scr_draw_recruit_advisor(){
   var blurp, eta, va;
    var romanNumerals;
    romanNumerals = scr_roman_numerals();
    var _recruit_rate = ARR_recruitement_rate;
    var xx=__view_get( e__VW.XView, 0 )+0;
    var yy=__view_get( e__VW.YView, 0 )+0;
    blurp = "";
    eta = 0;
    draw_sprite(spr_rock_bg, 0, xx, yy);
    draw_set_alpha(0.75);
    draw_set_color(0);
    draw_rectangle(xx + 326 + 16, yy + 66, xx + 887 + 16, yy + 818, 0);
    draw_set_alpha(1);
    draw_set_color(c_gray);
    draw_rectangle(xx + 326 + 16, yy + 66, xx + 887 + 16, yy + 818, 1);
    draw_line(xx + 326 + 16, yy + 480, xx + 887 + 16, yy + 480);
    var lower_middle_box = [xx+326, yy+480, xx+887, yy+828];
    draw_set_alpha(0.75);
    draw_set_color(0);
    draw_rectangle(xx + 945, yy + 66, xx + 1580, yy + 818, 0);
    draw_set_alpha(1);
    draw_set_color(c_gray);
    draw_rectangle(xx + 945, yy + 66, xx + 1580, yy + 818, 1);

    if (menu_adept = 0) {
        // draw_sprite(spr_advisors,5,xx+16,yy+43);
		if(struct_exists(obj_ini.custom_advisors, "recruiter")){
            scr_image("advisor/splash", obj_ini.custom_advisors.recruiter, xx + 16, yy + 43, 310, 828);
        } else {
            scr_image("advisor/splash", 6, xx + 16, yy + 43, 310, 828);
        }        draw_set_halign(fa_left);
        draw_set_color(c_gray);
        draw_set_font(fnt_40k_30b);
        draw_text_transformed(xx + 336 + 16, yy + 66, string_hash_to_newline("World " + string(obj_ini.recruiting_name)), 1, 1, 0);
        draw_text_transformed(xx + 336 + 16, yy + 100, string_hash_to_newline("First Sergeant " + string(recruiter_name)), 0.6, 0.6, 0);
        draw_set_font(fnt_40k_14);
    }
    if (menu_adept = 1) {
        // draw_sprite(spr_advisors,0,xx+16,yy+43);
        scr_image("advisor/splash", 1, xx + 16, yy + 43, 310, 828);
        draw_set_halign(fa_left);
        draw_set_color(c_gray);
        draw_set_font(fnt_40k_30b);
        draw_text_transformed(xx + 336 + 16, yy + 40, string_hash_to_newline("World " + string(obj_ini.recruiting_name)), 1, 1, 0);
        draw_text_transformed(xx + 336 + 16, yy + 100, string_hash_to_newline("Adept " + string(obj_controller.adept_name)), 0.6, 0.6, 0);
        draw_set_font(fnt_40k_14);
    }

    if (menu_adept = 0) then blurp = $"Hail {obj_ini.name[0, 0]}! You asked for a report?\n\n";

	if (obj_ini.doomed == 0) {
		if (recruits <= 0) {
			if (marines >= 1000) {
				blurp += "Our Chapter currently has no Neophytes - we are at maximum strength and do not require more marines.";
			}
			if ((marines < 1000) && (recruiting == 0)) {
				blurp += "Our Chapter currently has no Neophytes. Without training more our chapter is doomed to a slow death.";
			}
			if ((marines < 1000) && (recruiting > 0)) {
				blurp += "Our Chapter currently has no Neophytes. We are doing our utmost best to find suitable recruits.";
			}
		} else if (recruits == 1) {
			blurp += $"Our Chapter currently has one recruit being trained. The Neophyte's name is {recruit_name[0]} and they are scheduled to become a battle brother in {recruit_training[0] + recruit_distance[0]} months' time.";
		} else if (recruits > 1) {
			blurp += $"Our Chapter currently has {recruits} recruits being trained. {recruit_name[0]} is the next scheduled Neophyte to become a battle brother in {recruit_training[0] + recruit_distance[0]} months' time.";
		}

		if (gene_seed > 0) {
			var _recruit_rates = ARR_recruitment_rates;
			var _cur_recruit_rate = $"The recruitment is {_recruit_rates[recruiting]}";
			if ((recruiting == 0) && (marines >= 1000)) {
				blurp += $"\n{_cur_recruit_rate}. You must only give me the word and I can begin further increasing our numbers... though this would violate the Codex Astartes.";
			} else if ((recruiting == 0) && (marines < 1000)) {
				blurp += $"\n{_cur_recruit_rate}. You must only give me the word and I can begin further increasing our numbers.";
			} else if (recruiting > 0 && recruiting < 3) {
				blurp += $"\n{_cur_recruit_rate}. With an increase of funding I could vastly increase the rate.";
			} else if (recruiting == 3) {
				blurp += $"\n{_cur_recruit_rate}. Everything is progressing as expected.";
			} else if (recruiting >= 4) {
				blurp += $"\n{_cur_recruit_rate}. Give me the word when we have enough Neophytes being trained.";
			}
		}
	}

	if (obj_ini.doomed == 1) {
		blurp += "\nMutation of our gene-seed currently makes us unable to recruit new Neophytes. We are doomed to a slow demise unless the Apothecaries can fix it.";
	}
	
	if (gene_seed == 0) {
		blurp += "\nThere is no more gene-seed in our vaults and we cannot create more neophytes as a result. Something must be done, Chapter Master.";
	}
	
	if (recruiting > 0) {
		if ((string_count("|", obj_controller.recruiting_worlds) == 1)) {
			blurp += $"\nWe're recruiting from one world - {obj_ini.recruiting_name}. Perhaps we should speak with a planetary governor to acquire another.";
		} else if ((string_count("|", obj_controller.recruiting_worlds) == 2)) {
			blurp += "\nWe're recruiting from two worlds. Finding recruits is vastly accelerated but incurring more expenses.";
		} else if ((string_count("|", obj_controller.recruiting_worlds) > 2)) {
			blurp += "\nWe're recruiting from several worlds.";
		}
	}


    if (menu_adept = 1) {
        blurp = string_replace(blurp, "Our", "Your");
        blurp = string_replace(blurp, " our", " your");
        blurp = string_replace(blurp, "We", "You");
    }

    draw_text_ext(xx + 336 + 16, yy + 130, string_hash_to_newline(string(blurp)), -1, 536);

    // draw_line(xx+216,yy+252,xx+597,yy+252);draw_line(xx+216,yy+292,xx+597,yy+292);

    var blur = "",
        amo = 0;
    // ** Normal recruiting **
    draw_set_color(16291875);
    if (recruiting = 1) then amo = -2;
    if (recruiting = 2) then amo = -4;
    if (recruiting = 3) then amo = -6;
    if (recruiting = 4) then amo = -8;
    if (recruiting = 5) then amo = -10;
    if (recruiting = 6) then amo = -20;
    amo = amo * (string_count("|", obj_controller.recruiting_worlds));
    if (amo != 0) then draw_sprite(spr_requisition, 0, xx + 336 + 16, yy + 356);
    if (recruiting != 0) then draw_text(xx + 351 + 16, yy + 354, string_hash_to_newline(string(amo)));
    draw_set_color(c_gray);
    if (recruiting >= 0) and(recruiting <= 6){
    	blur = _recruit_rate[recruiting];
    }
    draw_text(xx + 407, yy + 354, string_hash_to_newline("Space Marine Recruiting: " + string(blur)));
    draw_text(xx + 728, yy + 354, string_hash_to_newline("[-] [+]"));

    amo = 0;
    // ** Apothecary recruitment **
    draw_set_color(16291875);
    if (training_apothecary = 1) then amo = -1;
    if (training_apothecary = 2) then amo = -2;
    if (training_apothecary = 3) then amo = -3;
    if (training_apothecary = 4) then amo = -4;
    if (training_apothecary = 5) then amo = -6;
    if (training_apothecary = 6) then amo = -12;
    if (amo != 0) then draw_sprite(spr_requisition, 0, xx + 336 + 16, yy + 396);
    if (training_apothecary != 0) then draw_text(xx + 351 + 16, yy + 394, string_hash_to_newline(string(amo)));
    draw_set_color(c_gray);
    if (training_apothecary >= 0) and(training_apothecary <= 6) then blur = _recruit_rate[training_apothecary];
    draw_text(xx + 407, yy + 394, string_hash_to_newline("Apothecary Training: " + string(blur)));
    draw_text(xx + 728, yy + 394, string_hash_to_newline("[-] [+]"));

    // TODO implement Spave Wolves and Iron Hands cases
    if (global.chapter_name != "Space Wolves") and(global.chapter_name != "Iron Hands") {
        // ** Chaplain recruitment **
        amo = 0;
        draw_set_color(16291875);
        if (training_chaplain = 1) then amo = -1;
        if (training_chaplain = 2) then amo = -2;
        if (training_chaplain = 3) then amo = -3;
        if (training_chaplain = 4) then amo = -4;
        if (training_chaplain = 5) then amo = -6;
        if (training_chaplain = 6) then amo = -12;
        if (amo != 0) then draw_sprite(spr_requisition, 0, xx + 336 + 16, yy + 416);
        if (training_chaplain != 0) then draw_text(xx + 351 + 16, yy + 414, string_hash_to_newline(string(amo)));
        draw_set_color(c_gray);
        if (training_chaplain >= 0) and(training_chaplain <= 6) then blur = _recruit_rate[training_chaplain];
        draw_text(xx + 407, yy + 414, string_hash_to_newline("Chaplain Training: " + string(blur)));
        draw_text(xx + 728, yy + 414, string_hash_to_newline("[-] [+]"));
    }

    // ** Psyker recruitment **
    amo = 0;
    draw_set_color(16291875);
    if (training_psyker = 1) then amo = -1;
    if (training_psyker = 2) then amo = -2;
    if (training_psyker = 3) then amo = -3;
    if (training_psyker = 4) then amo = -4;
    if (training_psyker = 5) then amo = -6;
    if (training_psyker = 6) then amo = -12;
    if (amo != 0) then draw_sprite(spr_requisition, 0, xx + 336 + 16, yy + 436);
    if (training_psyker != 0) then draw_text(xx + 351 + 16, yy + 434, string_hash_to_newline(string(amo)));
    draw_set_color(c_gray);
    if (training_psyker >= 0) and(training_psyker <= 6) then blur = _recruit_rate[training_psyker];
    draw_text(xx + 407, yy + 434, string_hash_to_newline("Psyker Training: " + string(blur)));
    draw_text(xx + 728, yy + 434, string_hash_to_newline("[-] [+]"));

    // ** Techmarine recruitment **
    amo = 0;
    draw_set_color(16291875);
    if (training_techmarine = 1) then amo = -1;
    if (training_techmarine = 2) then amo = -2;
    if (training_techmarine = 3) then amo = -3;
    if (training_techmarine = 4) then amo = -4;
    if (training_techmarine = 5) then amo = -6;
    if (training_techmarine = 6) then amo = -12;
    if (amo != 0) then draw_sprite(spr_requisition, 0, xx + 336 + 16, yy + 456);
    if (training_techmarine != 0) then draw_text(xx + 351 + 16, yy + 456, string_hash_to_newline(string(amo)));
    draw_set_color(c_gray);
    if (training_techmarine >= 0) and(training_techmarine <= 6) then blur = _recruit_rate[training_techmarine];
    draw_text(xx + 407, yy + 454, $"Techmarine Training: {blur}");
    draw_text(xx + 728, yy + 454, "[-] [+]");

    // ** Neophyte Training types **
    var yyy = 0;
    var trial_data = scr_trial_data();
    var cur_trial = trial_data[recruit_trial];

    draw_set_halign(fa_center);
    draw_set_font(fnt_40k_30b);
    draw_text_transformed(xx + 622, yy + 491, "Aspirant Trial", 0.6, 0.6, 0);
    draw_set_font(fnt_40k_14b);

    draw_text_ext(xx + 622, yy + 522, cur_trial.name, -1, 536);
    draw_set_halign(fa_left);
    draw_set_font(fnt_40k_14);

    yyy = string_height_ext(string_hash_to_newline(cur_trial.long_description), -1, 536) + yy + 545;

    draw_text_ext(xx + 336 + 16, yy + 545, string_hash_to_newline(cur_trial.long_description), -1, 536);

    draw_sprite(spr_arrow, 0, xx + 494, yy + 515);
    draw_sprite(spr_arrow, 1, xx + 717, yy + 515);
    recruit_list_pane.draw(xx + 940, yy + 66, 0.72);
    left_panel.inside_method = function(){
	    var xx=__view_get( e__VW.XView, 0 )+0;
	    var yy=__view_get( e__VW.YView, 0 )+0;
	    draw_set_halign(fa_left);
	    draw_set_font(fnt_40k_14);
    	if (left_panel.percent_cut>90){
	    var trial_data = scr_trial_data();
	    var cur_trial = trial_data[recruit_trial];    		
    		draw_text_ext(xx + 20 + 16, yy + 120 , string_hash_to_newline(scr_compile_trial_bonus_string(cur_trial)), -1, 280);
    	}
    }
    if (scr_hit(lower_middle_box)){
    	left_panel.percent_mod_draw_cut(xx + 10, yy + 38, 0.38, 1, 6);
    } else {
    	left_panel.percent_mod_draw_cut(xx + 10, yy + 38, 0.38, 1, -6);
    }
}

