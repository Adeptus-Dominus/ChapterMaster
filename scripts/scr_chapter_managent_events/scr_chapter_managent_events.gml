

///@mixin obj_popup
function tech_uprising_event_aftermath(){
	var tech, t, i, check_tech, location_techs, location_heretics, delete_positions;
	techs = collect_role_group(SPECIALISTS_TECHS);
	var tech_count = array_length(techs);
	for (i = 0; i < tech_count; i++) {
		var heretic_data = [0, 0, 0]
		var loyal_data = [0, 0, 0];
		delete_positions = [];
		location_techs = [];
		location_heretics = [];
		tech = techs[i];
		if (tech.has_trait("tech_heretic")) {
			array_push(location_heretics, tech);
			heretic_data[0] += tech.weapon_skill;
			heretic_data[1] += tech.wisdom;
			heretic_data[2] += tech.ballistic_skill;
		} else {
			array_push(location_techs, tech);
			loyal_data[0] += tech.weapon_skill;
			loyal_data[1] += tech.wisdom;
			loyal_data[2] += tech.ballistic_skill;
		}
		//loop techs to fins out which techs are in the same  location
		for (t = i + 1; t < tech_count; t++) {
			check_tech = techs[t].marine_location();
			if (same_locations(tech.marine_location(), check_tech)) {
				if (techs[t].has_trait("tech_heretic")) {
					array_push(location_heretics, techs[t]);
					heretic_data[0] += techs[t].weapon_skill;
					heretic_data[1] += techs[t].wisdom;
					heretic_data[2] += techs[t].ballistic_skill;
				} else {
					array_push(location_techs, techs[t]);
					loyal_data[0] += techs[t].weapon_skill;
					loyal_data[1] += techs[t].wisdom;
					loyal_data[2] += techs[t].ballistic_skill;
				}
				array_push(delete_positions, t);
			}
		}
		if (array_length(location_heretics) > 0 && array_length(location_techs) > 0) {
			var purge_target = "none";
			if (press == 0) {
				var tal;
				var heretic_tally = 0;
				var loyal_tally = 0;
				for (tal = 0; tal < 3; tal++) {
					if (heretic_data[tal] > loyal_data[0]) {
						heretic_tally++;
					} else if (heretic_data[tal] < loyal_data[0]) {
						loyal_tally++;
					}
				}
				if (heretic_tally > loyal_tally) {
					purge_target = location_techs;
				} else if (heretic_tally < loyal_tally) {
					purge_target = location_heretics;
				}
				if (purge_target == "none") {
					purge_target = choose(location_heretics, location_techs);
				}
			} else if (press == 1) {
				purge_target = location_techs;
			} else if (press == 2) {
				purge_target = location_heretics;
			}
			if (purge_target != "none") {
				for (tal = 0; tal < array_length(purge_target); tal++) {
					kill_and_recover(purge_target[tal].company, purge_target[tal].marine_number);
				}
			}
		}
	    if (array_length(delete_positions) > 0) {
	        for (t = array_length(delete_positions) - 1; t >= 0; t--) {
	            array_delete(techs, delete_positions[t], 1);
	            tech_count--;
	        }
	    }
	}
	if (press == 0) {
		text = "With neither faction receiving your favor it is not long until the BloodLetting begins. Within a month a brutal civil war engulfs the Tech ranks with losses suffered on both sides";
	} else if (press == 1) {
		text = "With your full support the so called 'heretics' who have seen through the lies of the bureaucracy of Mars eliminate those who will not be swayed to see the truth.";
		obj_controller.tech_status = "heretics";
	} else if (press == 2) {
		text = "The extremists and heretics that have been allowed to grow like a cancer in the Armentarium are rooted out and disposed of.";
	}
	reset_popup_options();
	press = 0;
	pathway = "end_splash";
}

function tech_uprising_event(){
	var _pop_data = {

	}
	var _options=[
		{
			str1 :"Do Nothing",
			choice_func:tech_uprising_event_aftermath
		},
		{
			str1 :"Support the heretics",
			choice_func:tech_uprising_event_aftermath
		},
		{
			str1 :"Support the Cult mechanicus faithfuls",
			choice_func:tech_uprising_event_aftermath
		}
	]

	_pop_data.options = _options;
	scr_popup(
		"Technical Differences!",
		"You Recive an Urgent Transmision A serious breakdown in culture has coccured causing believers in tech heresy to demand that they are given preseidence and assurance to continue their practises",
		"tech_uprising",
		_pop_data
	);
}

function setup_new_forge_master_popup(techs){
    var last_master = obj_ini.previous_forge_masters[array_length(obj_ini.previous_forge_masters)-1];
    var _pop_data  = {
        techs,
        charisma_pick : techs[0],
        experience_pick : techs[0],
        talent_pick : techs[0],
        marine_stat_display_uid:"",
        marine_stat_display:0,
        marine_display_image :-1,
        marine_display_triggered : false,               
    }

    for (var i=array_length(techs)-1;i >= 0;i--){
    	if (techs[i].role() != obj_ini.role[100][16]){
    		array_delete(techs,i,1);
    	}
    }

    for (i = 1; i < array_length(techs); i++) {
        if (_pop_data.charisma_pick.charisma < techs[i].charisma) {
            _pop_data.charisma_pick = techs[i];
        }
        if (_pop_data.experience_pick.experience < techs[i].experience) {
            _pop_data.experience_pick = techs[i];
        }
        if (_pop_data.talent_pick.technology < techs[i].technology) {
            _pop_data.talent_pick = techs[i];
        }
    }
    var _options = [
        {
            str1: "Popular Pick",
            choice_func:function(){
            	new_forge_master_chosen(pop_data.charisma_pick);
            },
            hover :function(){
            	setup_popup_marine_stat_display(pop_data.charisma_pick)
            }
        },
        {
            str1: "Experience Pick",
            choice_func:function(){
            	new_forge_master_chosen(pop_data.experience_pick);
            },
            hover :function(){
            	setup_popup_marine_stat_display(pop_data.experience_pick)
            }
        },
        {
            str1: "Talent Pick",
            choice_func:function(){
            	new_forge_master_chosen(pop_data.talent_pick);
            },
            hover :function(){
            	setup_popup_marine_stat_display(pop_data.talent_pick)
            }
        },
    ]
    _pop_data.options = _options;
    scr_popup(
        "New Forge Master",
        $"The Demise of Forge Master {last_master} means a replacement must be chosen. Several Options have already been put forward to you but it is ultimatly your decision.",
        "new_forge_master",
        _pop_data
    );	
}

function setup_popup_marine_stat_display(unit){
	if (unit.uid != pop_data.marine_stat_display_uid){
		if (is_struct(pop_data.marine_display_image)){
			pop_data.marine_display_image.destroy_image();
		}
		pop_data.marine_stat_display_uid = unit.uid;
		pop_data.marine_display_image = unit.draw_unit_image();
		pop_data.marine_stat_display = unit;
	}
	pop_data.marine_display_triggered = true;
}


function new_forge_master_chosen(pick){
	var cur_tech;
	var skill_lack = 0;
	var exp_lack = 0;
	var dislike = 0;
	var popularity_lack = 0;
	var charisma_test = 0;
	techs = pop_data.techs;
	for (i = 0; i < array_length(techs); i++) {

		cur_tech = techs[i];
		if (cur_tech.uid == pick.uid){
			continue;
		}
		charisma_test = global.character_tester.oppposed_test(pick, cur_tech, "charisma", 10);
		if (charisma_test[0] != 1) {
			if (pick.technology < cur_tech.technology) {
				skill_lack++;
				cur_tech.loyalty -= cur_tech.technology - pick.technology;
			}
			if (pick.experience < cur_tech.experience) {
				exp_lack++;
				cur_tech.loyalty -= floor((cur_tech.experience - pick.experience) / 200);
			}
			if (charisma_test[0] == 2) {
				dislike++;
				cur_tech.loyalty -= charisma_test[1];
			}
		}
	}

	if (pick != "none") {
		pick.update_role("Forge Master");

		var likability;
		if (dislike <= 5) {
			likability = "He is generally well liked";
		}
		if (dislike > 5) {
			likability = "He is not generally well liked";
		}
		if (dislike > 10) {
			likability = "He mostly disliked";
		}
		if (dislike == 0) {
			likability = "He is like by all of his tech brothers";
		}
		text = $"{pick.name()} is selected as the new {pick.role()} {likability}.";
		if (skill_lack > 0 && skill_lack < 6) {
			text += "There are some questions about his ability.";
		} else if (skill_lack > 6) {
			text += "Many Question his Technical Talents.";
		}
		if (exp_lack > 0 && exp_lack < 6) {
			text += "A few have raised questions over his experience.";
		} else if (exp_lack >= 6) {
			text += "There have been Many concerns over his experience.";
		}
		if (popularity_lack > 1 && popularity_lack < 6) {
			text += "He is not unanimously liked.";
		} else if (popularity_lack >= 6) {
			text += "He is disliked by many.";
		}
		var lacks = skill_lack + exp_lack + popularity_lack;
		if (lacks < ((array_length(techs) - 1) / 10)) {
			text += "Your choice Is almost unanimously respected";
		} else if (lacks < ((array_length(techs) - 1) / 4)) {
			text += "While a few may have preferred another there are no serious concerns";
		} else if (lacks < ((array_length(techs) - 1) / 2)) {
			text += "Your supporters are more than our detractors but many are unhappy";
		} else if (lacks < ((array_length(techs) - 1) * 0.65)) {
			text += "Most are unhappy with the decision but your word is final";
		}
		reset_popup_options();
		if (pick.company > 0) {
			for (var i = 1; i < 500; i++) {
				if (obj_ini.name[0][i] == "") {
					break;
				}
			}
			scr_move_unit_info(pick.company, 0, pick.marine_number, i);
		}
	}
}