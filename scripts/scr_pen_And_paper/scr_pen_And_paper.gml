function PenAndPaperSim() constructor{
	static oppposed_test = function(unit1, unit2, stat,unit1_mod=0,unit2_mod=0,  modifiers={}){
		var stat1 = irandom(99)+1;
		var unit1_val = unit1[$ stat]+unit1_mod;
		var unit2_val = unit2[$ stat]+unit2_mod;
		var stat2 = irandom(99)+1;
		var stat1_pass_margin, stat2_pass_margin, winner, pass_margin;
		//unit 1 passes test 
		if (stat1 < unit1_val){
			stat1_pass_margin = unit1_val- stat1;

			//unit 1 and unit 2 pass tests
			if (stat2<unit2_val){
				stat2_pass_margin =  unit2_val - stat2;

				//unit 2 passes by bigger margin and thus wins
				if (stat2_pass_margin > stat1_pass_margin){
					winner = 2;
					pass_margin = stat2_pass_margin-stat1_pass_margin;
				} else {
					winner = 1;
					pass_margin = stat1_pass_margin-stat2_pass_margin;
				}
			} else {//only unit 1 passes test thus is winner
				winner = 1;
				pass_margin = unit1_val- stat1;
			}
		} else if (stat2<unit2_val){//only unit 2 passes test
			winner = 2;
			pass_margin = unit2_val-stat2;
		} else {
			winner = 0;
			pass_margin = unit1_val- stat1;
		}

		return [winner, pass_margin];
	}
	static evaluate_tags = function(unit, tags){
		var total_mod = 0,tag;
		for (var i=0;i<array_length(tags);i++){
			tag=tags[i];
			if (tag=="siege"){
                if (scr_has_adv("Siege Masters")){
                    total_mod+=10
                }
                if (unit.has_trait("siege_master")){
                	total_mod+=10;
                }			
			}
			else if (tag=="tyranids"){
				if (scr_has_adv("Enemy: Tyranids")){
					total_mod+=10
				}
				if (unit.has_trait("tyrannic_vet")){
                	total_mod+=10;
                }
			}
			else if (tag=="beast"){
				if (unit.has_trait("tyrannic_vet")){
                	total_mod+=2;
                }
                if (unit.has_trait("beast_slayer")){
                	total_mod+=10;
                }
                if (unit.has_trait("harsh_born")){
                	total_mod+=3;
                }                			
			}
		}
		return total_mod;
	}

	static standard_test = function(unit, stat, difficulty_mod=0, tags = []){
		var passed =false;
		var margin=0;
		difficulty_mod+=evaluate_tags(unit, tags);
		var random_roll = irandom_range(1,100);
		if (random_roll<unit[$ stat]+difficulty_mod){
			passed = true;
			margin = unit[$ stat]+difficulty_mod - random_roll;
		} else {
			passed = false;
			margin = unit[$ stat]+difficulty_mod - random_roll;
		}

		return [passed, margin];
	}
}

global.character_tester = new PenAndPaperSim();

function compare_stats(stat_one, stat_two){
	var _stat_names = ARR_stat_list;
	var stat_diff = {};
	for (var i=0;i<array_length(_stat_names);i++){
		stat_diff[$_stat_names[i]] = stat_one[$_stat_names[i]] - stat_two[$_stat_names[i]]
	}
	return stat_diff;
}

function print_stat_diffs(diffs){
	var _diff_string = "";
	var _stat_names = ARR_stat_list;
	var _stat_short = global.stat_shorts;
	for (var i=0;i<array_length(_stat_names);i++){
		if (diffs[$_stat_names[i]] != 0 ){
			var _symbol = diffs[$_stat_names[i]] ? "+" : "";
			_diff_string += $"{_stat_short[$_stat_names[i]]} : {_symbol}{diffs[$_stat_names[i]]} ,";
		}
	}
	return _diff_string;
}

function d100_roll(luck_edit=true){
	var _roll = irandom_range(1,100)
	if (scr_has_disadv("Shitty Luck")){
		_roll = min(1,_roll-irandom(10))
	}
	return _roll;
}

