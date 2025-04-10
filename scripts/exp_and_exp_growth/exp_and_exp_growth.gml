// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
#macro ARR_stat_list ["constitution", "strength", "luck", "dexterity", "wisdom", "piety", "charisma", "technology","intelligence", "weapon_skill", "ballistic_skill"]

global.stat_shorts = {
	"constitution":"CON", 
	"strength":"STR", 
	"luck":"LCK", 
	"dexterity":"DEX", 
	"wisdom":"WIS", 
	"piety":"PTY", 
	"charisma":"CHA", 
	"technology":"TEC",
	"intelligence":"INT", 
	"weapon_skill":"WS", 
	"ballistic_skill":"BS",
}

global.stat_display_strings = {
	"constitution":"Constitution", 
	"strength":"Strength", 
	"luck":"Luck", 
	"dexterity":"Dexterity", 
	"wisdom":"Wisdom", 
	"piety":"Piety", 
	"charisma":"Charisma", 
	"technology":"Technology",
	"intelligence":"Intelligence", 
	"weapon_skill":"Weapon Skill", 
	"ballistic_skill":"Ballistic Skill",
}

global.stat_display_colour = {
	"constitution":#9B403E, 
	"strength":#1A3B3B, 
	"luck":#05451E, 
	"dexterity":#306535, 
	"wisdom":#54540B, 
	"piety":#6A411C, 
	"charisma":#3A0339, 
	"technology":#4F0105,
	"intelligence":#2F3B6B, 
	"weapon_skill":#87753C, 
	"ballistic_skill":#743D57,	
}

global.stat_icons = {
	"constitution":spr_constitution_icon, 
	"strength":spr_strength_icon, 
	"luck":spr_luck_icon, 
	"dexterity":spr_dexterity_icon, 
	"wisdom":spr_wisdom_icon, 
	"piety":spr_faith_icon, 
	"charisma":spr_charisma_icon, 
	"technology":spr_technology_icon,
	"intelligence":spr_intelligence_icon, 
	"weapon_skill":spr_weapon_skill_icon, 
	"ballistic_skill":spr_ballistic_skill_icon,	
}



function eval_trait_stat_data(trait_stat_data){
	trait_stat_value = 0;
	var complex_data = is_array(trait_stat_data);
	if (!complex_data){
		trait_stat_value += trait_stat_data;
	} else {
		if (array_length(trait_stat_data)==2){
			trait_stat_value += trait_stat_data[0];
		} else {
			if (trait_stat_data[2] == "min"){
				trait_stat_value += (trait_stat_data[0] - (trait_stat_data[1]));
			} else if (trait_stat_data[2] == "max"){ 
				trait_stat_value += (trait_stat_data[0] + (trait_stat_data[1]));
			}
		}
	}
	return trait_stat_value;
}
function unit_stat_growth(grow_stat=false){

	var base_group_growth_sets = {
		astartes : ["weapon_skill", "ballistic_skill", "wisdom","weapon_skill", "ballistic_skill",],
		human : ["weapon_skill", "ballistic_skill", "piety", "wisdom"],
		skitarii : ["weapon_skill", "ballistic_skill", "technology", "wisdom"],
		tech_priest : ["weapon_skill", "ballistic_skill", "technology", "intelligence"],
		Default : ["weapon_skill", "ballistic_skill", "wisdom"],
	};

	var group_growths = [
		[SPECIALISTS_TECHS , "technology"],
		[SPECIALISTS_LIBRARIANS , "intelligence"],
		[SPECIALISTS_CHAPLAINS , "charisma"],
		[SPECIALISTS_APOTHECARIES , "intelligence"],
	];

	var role_growth = [
		["Champion", "weapon_skill"],
	];



    var _role = role();
    var _trait_data = global.trait_list;
    var _stat_list = ARR_stat_list;
    var _stat_count = array_length(_stat_list);
    var _trait_stat_growth = {};
    var total_traited = 0;
    var total_stat_points = 0;

	for (var i=0;i<_stat_count;i++){
		_trait_stat_growth[$ _stat_list[i]] = 0;
	}
	gains_set = false;
    if (job!="none") {
        if (job.type == "forge") {
            stat_gains_opts = ["technology"];
            gains_set = true;
            turn_stat_gains = { technology : 100 };
            instace_stat_point_gains = { technology : 100 };
            if (grow_stat) {
                var _levels = int64(stat_point_exp_marker / 15);
                for (var _lvl = 0; _lvl < _levels; _lvl++) {
                    stat_point_exp_marker -= 15;
                    self.technology++;
                    assign_reactionary_traits();
                }
            }
            return instace_stat_point_gains;
        }
    }
	if (!gains_set){

		for (var i=0;i<array_length(traits);i++){
			var _trait = traits[i];
			if (struct_exists(_trait_data, traits[i])){
				cur_trait =  _trait_data[$ traits[i]];
				for (var t=0;t<_stat_count;t++){
					if (struct_exists(cur_trait, _stat_list[t])){
						var _cur_stat = _stat_list[t];
						var trait_stat_data = cur_trait[$_cur_stat];
						_trait_stat_growth[$_cur_stat] += eval_trait_stat_data(trait_stat_data);					
					}
				}
			}
		}




		if (struct_exists(base_group_growth_sets, base_group)){
			stat_gains_opts = base_group_growth_sets[$ base_group];
		} else {
			stat_gains_opts = base_group_growth_sets.Default;
		}
		for (var i=0; i<_stat_count;i++){
			var _stat = _stat_list[i];
			total_traited+=_trait_stat_growth[$ _stat];
			_trait_stat_growth[$ _stat] = _trait_stat_growth[$ _stat]/4;
			growth_share = _trait_stat_growth[$ _stat];
			if (growth_share>0){
				repeat(growth_share){
					array_push(stat_gains_opts, _stat);
				}
				total_stat_points+=growth_share;
			} else {
				_trait_stat_growth[$ _stat] = 0;
			}
		}

		for (var i=0;i<array_length(stat_gains_opts);i++){
			_trait_stat_growth[$ stat_gains_opts[i]]+=2;
			total_stat_points+=2;
		}

		for (var i=0;i<array_length(group_growths);i++){
			if (IsSpecialist(group_growths[i][0])){
				array_push(stat_gains_opts, group_growths[i][1]);
				_trait_stat_growth[$ group_growths[i][1]]++;
				total_stat_points++
			}
		}
		for (var i=0;i<array_length(role_growth);i++){
			if (role == role_growth[i][0]){
				array_push(stat_gains_opts, role_growth[i][1]);
				_trait_stat_growth[$ role_growth[i][1]]++;
				total_stat_points++;
			}
		}
	}
	var stat_gain_chances = {};
	var running_total = 0;
	var chance_list = [0];
	var stat_items = [];
	for (var i=0;i<_stat_count;i++){
		stat_gain_chances[$ _stat_list[i]] = (_trait_stat_growth[$ _stat_list[i]] / total_stat_points)*100;
		var _stat_chance = stat_gain_chances[$ _stat_list[i]];
		if (_stat_chance<=0){
			continue;
		} else {
			array_push(chance_list, running_total+_stat_chance);
			array_push(stat_items, _stat_list[i]);
			running_total += _stat_chance;
		}
	}		
    if (grow_stat){
        stat_gains = undefined;
        var instace_stat_point_gains = {};
        var _levels = int64(stat_point_exp_marker / 15);
        for (var _lvl = 0; _lvl < _levels; _lvl++) {
            //var extra_stats_earned = d100_roll(false);
            stat_gain_choice = random(100);
            for (var i = 0; i < array_length(chance_list) - 1; i++){
                if (stat_gain_choice >= chance_list[i] && stat_gain_choice < chance_list[i + 1]) {
                    stat_gains = stat_items[i]; // bro ignored the bot
                }
            }
            if (stat_gains != undefined) {
                self[$ stat_gains]++;
                stat_point_exp_marker -= 15;
                if (struct_exists(instace_stat_point_gains, stat_gains)){
                    instace_stat_point_gains[$ stat_gains]++;
                } else {
                    instace_stat_point_gains[$ stat_gains] = 1;
                }
                if (struct_exists(turn_stat_gains, stat_gains)){
                    turn_stat_gains[$ stat_gains]++;
                } else {
                    turn_stat_gains[$ stat_gains] = 1;
                }
            }
        }

        if (stat_gains != undefined) {
            assign_reactionary_traits();
            return instace_stat_point_gains;
        } else {
            var _name = name();
            log_error($"{_role} {_name} No stat gains!")
            scr_event_log("yellow", $"{_role} {_name} No stat gains!")
            scr_alert("yellow", "DEBUG", $"{_role} {_name} No stat gains!")
            return undefined;
        }
	} else {
		// show_debug_message($"{total_traited}")
		return stat_gain_chances;

	}
}

function add_unit_exp(add_val){
	var instace_stat_point_gains = {};
	var _powers_learned = 0;
	stat_point_exp_marker += add_val;
	experience += add_val;
	if (stat_point_exp_marker>=15){
		instace_stat_point_gains = handle_stat_growth(true);
	}

	if (IsSpecialist(SPECIALISTS_LIBRARIANS)) {
		_powers_learned = update_powers()
	}
	role_refresh();

	return [instace_stat_point_gains, _powers_learned];
}
