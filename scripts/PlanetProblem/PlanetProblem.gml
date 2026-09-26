/// @param {sring} name
/// @param {Real} timer
/// @param {struct} data
/// @param {constructor PlanetData} planet
function PlanetProblem(name, timer, data, planet) constructor{
timer = timer;
uid = scr_uuid_generate();
p_id = name;
data = data;
p_data = planet;
planet = p_data.planet;
system = p_data.system;
f_type = eP_FEATURES.MISSION;
members = [];
delete_mission = false;
static refresh_p_data = function(){
	p_data = system.get_planet_data(planet);
}

stage_id = "";
if (struct_exists(data, "stage")){
	stage_id = data.stage;
}
if (struct_exists(data, "members")){
    members = data.members;
}

extend_timer_for_warp_storm = true;
remove = false;
zero_timer_checks = true;
per_turn_checks = true;

static mark = function(colour){
    refresh_p_data();
    with (p_data.system){
        new_star_event_marker(colour)
    }
}

static description = function(){
    return mission_name_key(p_id);
}

static increment_mission_completion =  function() {
    if (!struct_exists(data, "completion")) {
        data.completion = 0;
    }
    data.completion++;
    if (!struct_exists(data, "required_months") || data.required_months <= 0) {
        LOGGER.error("Invalid required_months in mission_data");
        return 0;
    }
    return (data.completion / data.required_months) * 100;
}

static handle_triggered_mission_func = function(func){
    if (!is_undefined(func)){
        refresh_p_data();
        try {
            func();
        } catch (_exception) {
            ERROR_HANDLER.handle_exception(_exception);
        }
    }
    if (timer == -1 || (delete_mission)){
        var _prob = -1;
        for (var i = 0; i < array_length(p_data.problems); i++){
            if (p_data.problems[i] == self){
                _prob = i;
            }
        }
        if (_prob > -1){
            array_delete(system.p_problem, _prob,1);
            array_delete(p_data.problems, _prob,1);
        }
    }
}
static basic_turn_end = function(){
	refresh_p_data();
	if (p_data.system.storm <= 0){
		timer--;
	}
	if ((timer > -1) && per_turn_checks) {
		var _func = undefined;
		switch(p_id){
			case "mech_raider":
				_func = per_turn_check_raider_failed;
				break;
			case "mech_bionics":
				_func = per_turn_check_mech_bionics;
				break;
			case "mech_tomb":
				switch(stage_id){
					case "exploring":
						_func = per_turn_check_mech_tomb2;
						break;
					case "awaiting_player":
					default:
						_func = per_turn_check_mech_tomb1;
					break;
				}
				break;
            case "spyrer":
                _func = per_turn_check_spyrer;
                break;
            case "inquisition_necron":
                _func =per_turn_check_inqisition_tomb;
                break;
            case "hive_fleet_to_cult":
                _func = per_turn_hive_fleet_to_cult;
                break;
            case "inquisition_recon":
                _func = per_turn_inquisition_recon;
                break;
		}
        handle_triggered_mission_func(_func)
	}
	if ((timer == 0) && zero_timer_checks && !delete_mission) {
		var _func = undefined;
		switch(p_id){
			case "hunt_beast":
				_func = resolve_hunt_beast;
				break;
			case "train_forces":
				_func = complete_train_forces_mission;
				break;
			case "succession":
				_func = resolve_succession;
				break;
			case "inquisition_recon":
				_func = resolve_inquisition_recon;
				break;
			case "inquisition_necron":
				_func = resolve_inquisitor_necron;
				break;
			case "spyrer":
				_func = resolve_spyrer;
				break;
			case "hunt_fallen":
				_func = resolve_fallen;
				break;
			case "mech_raider":
				_func = resolve_mech_raider_failed;
				break;
			case "mech_bionics":
				_func = resolve_mech_bionics;
				break;
			case "mech_tomb":
				_func = resolve_mech_tomb1_failed;
				break;
			case "mech_mars":
				_func = resolve_mech_mars;
                break;
            case "provide_garrison":
                _func =  complete_garrison_mission;
		}
		handle_triggered_mission_func(_func)
	}
}

//triggered within drop select
static before_battle_effects = function(){
    instance_activate_object(obj_star);
    var _func = undefined;
    switch(p_id){
        case "iquisition_tyranid_org":
            _func = inquisition_tyranid_org_setup_battle;
            break;
    }
    handle_triggered_mission_func(_func);   
    instance_deactivate_object(obj_star);   
}


//triggered at the end of scr_shoot
static battle_on_enemy_casulties = function(){
    if (!struct_exists(self, "casualty_packet")){
        exit;
    }
    instance_activate_object(obj_star);
    var _func = undefined;
    switch(p_id){
        case "iquisition_tyranid_org":
            _func = inquisition_tyranid_on_enemy_casulties;
            break;
    }
    handle_triggered_mission_func(_func);

    struct_remove(self, "casualty_packet");

    instance_deactivate_object(obj_star);  
}

//triggers in obj_ncombat alarm 5
static battle_final_message = function(){
      instance_activate_object(obj_star);
    var _func = undefined;
    switch(p_id){
        case "iquisition_tyranid_org":
            _func = inquisition_tyranid_org_battle_final_message;
            break;
    }
    handle_triggered_mission_func(_func);   
    instance_deactivate_object(obj_star);      
}

static after_battle_effects = function(){
    instance_activate_object(obj_star);
    var _func = undefined;
    switch(p_id){
        case "spyrer":
            _func = spyrer_battle_aftermath;
            break;
        case "protect_raiders":
            _func = protect_raiders_battle_aftermath;
            break;
        case "hunt_fallen":
            _func = hunt_fallen_battle_aftermath;
            break;
        case "inquisition_necron":
            _func = inquisition_necron_battle_aftermath;
            break;
        case "tyranid_org":
            _func = inquisition_tyranid_org_battle_aftermath
    }
    handle_triggered_mission_func(_func);   
    instance_deactivate_object(obj_star);
}

static on_squad_selection = function(){
    var _func = undefined;
    switch(p_id){
        case "protect_raiders":
            _func = protect_raider_squad_selected;
            break;
    }
    handle_triggered_mission_func(_func);       
    instance_deactivate_object(obj_star);
}


static on_unit_selection = function(){
    var _func = undefined;
    switch(p_id){
        case "hunt_beast":
            _func = init_beast_hunt_mission;
            break;
        case "train_forces":
            _func = init_train_forces_mission;
    }
    if (!is_undefined(_func)){
        if (struct_exists(obj_controller.selection_data, "selections")){
            members = obj_controller.selection_data.selections;
        }
        handle_triggered_mission_func(_func);   
    }    
    instance_deactivate_object(obj_star);
}

static __init = function(){
	switch(p_id){
		case "inquisition_necron":
	        mark("green");
	        break;
	    case "meeting":
            var rando = choose(1, 2);
            if (rando == 1) {
                obj_controller.diplo_text += $"A proposal that needs further consideration and some negotiation.  Meet me at {p_data.name()} and we shall resolve this.";
            }
            if (rando == 2) {
                obj_controller.diplo_text += $"Interesting. I shall be at {p_data.name()} and, if you are sincere, you will come to me and we can take this proposal to its logical conclusion.";
            }
            scr_event_log("", $"Chaos Lord {obj_controller.faction_leader[eFACTION.CHAOS]} agrees to meet with you on {p_data.name()} to discuss an alliance.");
            mark("purple");
            break;
        case "hunt_fallen":
            hunt_fallen_init();
            break;
        case "harlequins":
            var _text = $"Eldar Harlequins have been seen on planet {p_data.name()}. Their purposes are unknown.";
            scr_popup("Harlequin Troupe", _text, "harlequin", "");
            mark("green");
            break;
        case "inquisition_demon_world":
            inquisition_demon_world_init();
            break;
        case "tyranid_org":
            inquisition_tyranid_org_init();
            break;
        case "hive_fleet_to_cult":
            hive_fleet_to_cult_init();
            break;
        default:
            mark("green");
			break;

	}
}
__init();

// by default mission battles do not reduce the fortification level or enemy power on a planet
static new_end_turn_battle = function(battle_opponent_id, special_id = p_id, enemy_data = undefined){
    var _battle_index = obj_turn_end.battles++;
    obj_turn_end.battle[_battle_index] = 1;
    obj_turn_end.battle_world[_battle_index] = planet;
    obj_turn_end.battle_opponent[_battle_index] = battle_opponent_id;
    obj_turn_end.battle_location[_battle_index] = system.name;
    obj_turn_end.battle_object[_battle_index] = system;
    obj_turn_end.battle_special[_battle_index] = {
        special_id : special_id,
        special_feature : self,
    };
    if (is_undefined(enemy_data)){
        enemy_data = {
        }
    }
    if (!struct_exists(enemy_data, "reduce_power")){
        enemy_data.reduce_power = false;
    }
    if (!struct_exists(enemy_data, "reduce_fortification")){
        enemy_data.reduce_fortification = false;
    }
    obj_turn_end.battle_special[_battle_index].battle_enemy_data = enemy_data;
}

static new_battle = function(battle_opponent_id,special_id = p_id){
    var _battle = instance_create(0, 0, obj_ncombat);
    _battle.enemy = battle_opponent_id;
    _battle.battle_object = system;
    _battle.battle_loc = system.name;
    _battle.battle_id = planet;
    _battle.battle_special = special_id;
    _battle.special_feature = self;
    return _battle;
}

static set_members_job_to_mission = function(){
    for (var i = 0; i < array_length(members); i++){
        var _unit = members[i];
        _unit.job = {
            type: p_id,
            planet: planet,
            location: system.name,
        };
        _unit.unload(planet, system);            
    }    
}



static init_beast_hunt_mission = function() {
    if (stage_id == "preliminary") {
        set_members_job_to_mission();
        var _numeral_name = p_data.name()
        stage_id = "active";
        var _mission_length = irandom_range(2, 5);
        timer = _mission_length;
        var _gar_pop = instance_create(0, 0, obj_popup);
        //TODO some new MissonHelper methods for popups
        _gar_pop.title = $"Marines assigned to hunt beasts around {_numeral_name}";
        _gar_pop.text = $"The govornor of {_numeral_name} Thanks you for the participation of your elite warriors in your execution of such a menial task.";
        _gar_pop.add_option("Happy Hunting");
        _gar_pop.image = "";
        _gar_pop.cooldown = 8;
        obj_controller.cooldown = 20;
        scr_event_log("", $"Beast hunters deployed to {_numeral_name} for {_mission_length} months.", p_data.system.name);
        obj_controller.close_popups = false;
    }
}

static complete_beast_hunt_mission = function() {
    var _man_conditions = {
        "job": "hunt_beast",
        "max": 3,
    };
    var _hunters = collect_role_group("all", [system.name, planet, 0], false, _man_conditions);
    if (stage_id == "active") {
        var _mission_string = "";
        var _success = false;
        var _tester = global.character_tester;
        var _unit_pass;
        var _unit;
        var _unit_report_string = "";
        var _deaths = 0;
        var _successful_hunters = [];

        if (!array_length(_hunters)) {
            return;
        }

        for (var i = 0; i < array_length(_hunters); i++) {
            _unit = _hunters[i];
            _unit_pass = _tester.standard_test(_unit, "weapon_skill", 10, ["beast"]);
            if (_unit_pass[0]) {
                if (!_success) {
                    _success = true;
                }
                _unit_report_string += _unit.add_trait("beast_slayer", true, true);
                array_push(_successful_hunters, _unit);
            } else {
                var _tough_check = _tester.standard_test(_unit, "constitution", _unit.luck);
                if (!_tough_check[0]) {
                    if (_tough_check[1] < -10) {
                        _unit_report_string += $"{_unit.name_role()} Was mauled to death\n";
                        _unit.kill(true, false);
                        _deaths++;
                    } else {
                        if (irandom(100) < _unit.luck) {
                            _unit.add_or_sub_health(-100);
                            _unit_report_string += $"{_unit.name_role()} Was injured (health - 100)\n";
                        } else {
                            _unit.add_or_sub_health(-250);
                            _unit_report_string += $"{_unit.name_role()} Was Badly injured, it is unknown if he will recover (health - 250)\n";
                        }
                    }
                }
            }
            _unit.job = "none";
        }

        if (_success) {
            _mission_string = $"The mission was a success and a great number of beasts rounded up and slain, your marines were able to gain great skills and the prestige of your chapter has increased greatly across the planets populace.";
            if (_deaths) {
                _mission_string += $"Unfortunatly {_deaths} of your marines died.";
            }
            _mission_string += $"\n{_unit_report_string}";
        } else {
            _mission_string = $"The mission was a failiure. The governor is disapointed and the legend of your chapter has undoubtedly been diminished";
            _mission_string += $"\n{_unit_report_string}";
        }

        scr_popup($"Beast Hunt on {p_data.name()}", _mission_string, "", "");
    }
    for (var i = 0; i < array_length(_hunters); i++) {
    	_hunters[i].job = "none";
    }
}


static init_train_forces_mission = function() {
    if (stage_id != "preliminary" || array_length(members) == 0) {
        exit;
    }
    var _trainer = members[0];
    var _numeral_name = p_data.name();
    stage_id = "active";
    var _mission_length = irandom_range(3, 12);
    timer = _mission_length;
    //pop.image="ancient_ruins";
    var _gar_pop = instance_create(0, 0, obj_popup);
    //TODO some new universal methods for popups
    _gar_pop.title = $"Training forces on {_numeral_name} begins";
    _gar_pop.text = $"{_trainer.name_role()} Has taken leave of his current post in order to aid the governor of {_numeral_name} and his pdf commanders with training local forces and bolstering defences.";
    var _is_cap = _trainer.has_role(eROLE.CAPTAIN);

    if (_is_cap) {
        _gar_pop.text += "the governor seems to be impressed that such a high ranking officer has been assigned to his request (disp +3)";
        p_data.add_disposition(3);
    }

    data.assigned_unit = _trainer.uid;

    //pip.image="event_march"
    _gar_pop.add_option($"Good luck {_trainer.name()}");
    _gar_pop.image = "";
    _gar_pop.cooldown = 500;
    obj_controller.cooldown = 500;
    scr_event_log("", $"{_trainer.name_role()} deployed to {_numeral_name} for {_mission_length} months.", p_data.system.name);
    obj_controller.close_popups = false;
}

static complete_train_forces_mission = function() {
    if (stage_id != "active") {
        exit;
    }
    var _mission_string = "";
    var _trainer = fetch_unit_uid(data.assigned_unit);
    if (!is_struct(_trainer)) {
        exit;
    }
    var _unit_report_string = "";
    var _tester = global.character_tester;
    var _wis_test_difficulty = -20;
    var _tyannic_vet = _trainer.has_trait("tyrannic_vet");
    if (_tyannic_vet) {
        _wis_test_difficulty += 10;
        if (p_data.has_feature(eP_FEATURES.GENE_STEALER_CULT)) {
            var _cult = p_data.get_features(eP_FEATURES.GENE_STEALER_CULT)[0];
            if (_cult.hiding) {
                p_data.delete_feature(eP_FEATURES.GENE_STEALER_CULT);
                _mission_string += $"Fortune has smiled on this mission, {_trainer.name_role()}'s abilities as a Veteran of dealing with the Tyranids came in handy and in a short period was able to discern the existencee of a _cult. He was able to organise those  he considered to be still loyal to rally an extermiation of the _cult, reeports suggest he was so successful as to have completely wiped the genestealer presence from the planet";
            }
        }
    }
    var _siege_master = _trainer.has_trait("siege_master");
    if (_siege_master) {
        _wis_test_difficulty += 10;
    }
    var _brute = _trainer.has_trait("brute");
    if (_brute) {
        _wis_test_difficulty -= 10;
    }

    var _leader = _trainer.has_trait("natural_leader");
    if (_leader) {
        _wis_test_difficulty += 10;
    }

    var _unit_pass = _tester.standard_test(_trainer, "wisdom", _wis_test_difficulty);
    if (_unit_pass[0]) {
        var _new_pdf = p_data.recruit_pdf((_unit_pass[1] / 10)); //this will approximate podf improvement for the time being
        _mission_string += $"Training of the Pdf went well and improved the quality of the pdf as well as providing sizeable big recruitment improvement for the planet {_new_pdf} new pdf were recruited";
        if (_leader) {
            var _disp_gain = 10;
            p_data.add_disposition(_disp_gain);
            _mission_string += $"\n{_trainer.name_role()}s reputation a natural and confident leader proved well earned as he also made excellent diplomatic headway with the governor and his generals (disposition +{_disp_gain})";
        }
        if (_siege_master) {
            _mission_string += $"{_trainer.name()}s trained eye as a Siege Master also allowed him to make several improvements to the planets fortifications (fortification +1)";
            p_data.alter_fortification(1);
        } else {
            if (roll_dice(1, 100) > 75 && _trainer.intelligence > 45) {
                _mission_string += $"{_trainer.name()} has proven themselves a great strategist when it comes to defensive structures beyond previousy known ";
                var _start_stats = variable_clone(_trainer.get_stat_line());
                _trainer.add_trait("siege_master");
                var end_stat = _trainer.get_stat_line();
                var _stat_diff = compare_stats(end_stat, _start_stats);
                _unit_report_string += $"{_trainer.name_role()} Has gained the trait {global.trait_list.siege_master.display_name}, {print_stat_diffs(_stat_diff)}\n";
                _mission_string += "The new insights have allowed for minor improvements to planetary fortifications (fortification +1)";
                p_data.alter_fortification(1);
            }
        }
    } else {
        var disp_loss = -5;
        _mission_string += "The orgional training mission was a failiure";
        if (_brute) {
            _mission_string += "in no short part due to his brutish nature";
        }
        _mission_string += ".";

        _mission_string += "He failed to work effectively with the existing chain of command";

        if (_unit_pass[1] < -20) {
            var _hard_loss_traits = [
                "harshborn",
                "feral",
                "zealous_faith",
                "blood_for_blood",
                "blunt",
                "brute",
                "brawler",
            ];
            var _hard_loss = false;
            for (var i = 0; i < array_length(_hard_loss_traits); i++) {
                if (array_contains(_trainer.traits, _hard_loss_traits[i])) {
                    _hard_loss = true;
                }
            }
            if (_hard_loss) {
                _mission_string += $"His particularly grueling regimes and standards imposed upon the senior officers of the pdf caused friction with physical injury being caused to one officer";
                disp_loss = -25;
                _mission_string += "(disposition -25)";
            }
        }
        p_data.add_disposition(disp_loss);
    }
    _mission_string += $"\n{_unit_report_string}";
    scr_popup($"Training Forces on {p_data.name()}", _mission_string, "", "");
    _trainer.job = "none";
}

static resolve_succession = function() {
    var _result, _alert_text;
    var _dice1 = roll_dice(1, 100);
    var _dice2 = roll_dice(1, 100);

    _result = eFACTION.IMPERIUM;
    _alert_text = "";
    if (_dice1 <= (p_data.corruption * 2)) {
        _result = eFACTION.CHAOS;
    }
    if (_dice2 <= (p_data.population_influences[eFACTION.TAU] * 2)) {
        _result = eFACTION.TAU;
    }

    if (p_data.current_owner == eFACTION.IMPERIUM && _result != eFACTION.IMPERIUM) {
        p_data.edit_pdf(p_data.guardsmen);
        p_data.edit_guardsmen(-p_data.guardsmen);
        p_data.set_new_owner(_result);
    }

    _alert_text = $"War of Succession on {p_data.name()} has ended";

    if (_result == eFACTION.CHAOS) {
        _alert_text += " with Chaos in control.";
        p_data.set_player_disposition(0);
        scr_alert("red", "succession", _alert_text, p_data.system.x, p_data.system.y);
        scr_event_log("purple", _alert_text);
    } else if (_result == eFACTION.TAU) {
        _alert_text += " with a Tau sympathizer in control.";
        p_data.set_player_disposition(10 + choose(1, 2, 3, 4, 5, 6));
        p_data.add_forces(eFACTION.TAU, 2);
        scr_alert("red", "succession", _alert_text, p_data.system.x, p_data.system.y);
        scr_event_log("red", _alert_text);
    } else if (_result == eFACTION.IMPERIUM) {
        _alert_text += " The resultant governor is the most staunch pillar of the imperium.";
        _alert_text += ".";
        scr_alert("green", "succession", _alert_text, p_data.system.x, p_data.system.y);
        scr_event_log("", _alert_text);
    } else {
        //At the moment does not fire but a worty flavour option for down the line
        _alert_text += " Word is the new Governor has Heretical leanings and sympathises with xenos.";
    }

    p_data.delete_feature(eP_FEATURES.SUCCESSION_WAR);
}
static per_turn_inquisition_recon = function() {
    if (p_data.player_forces <= 0){
        exit;
    }

    var _pop_data = {
        mission: self,
    };
    scr_popup(
        "Investigation Completed", 
        "Your marines have scouted out {p_data.name()} and satisfied the mission requirements.", 
        "inquisition", 
        _pop_data
    );
    scr_event_log("", $"Inquisition Mission Completed: Your Astartes have succesfully scouted  {p_data.name()}.");

    delete_mission = true;

}
static resolve_inquisition_recon = function() {
    refresh_p_data();
    var _alert_text = "Inquisition Mission Failed: Investigate ";
    alter_disposition(eFACTION.INQUISITION, -5);
    _alert_text += $"{p_data.name()}.";
    scr_alert("red", "mission_failed", _alert_text, 0, 0);
    scr_event_log("red", _alert_text);
}

static resolve_inquisitor_necron = function() {
    alter_disposition(eFACTION.INQUISITION, -8);
    var _alert_text = $"The Necron Tomb of planet {p_data.name()} has not been deactivated in time.  It has awakened, rank upon rank of Necrons pouring out to the planet's surface.  The Inquisition is not pleased with your failure.";
    scr_popup("Inquisition Mission Failed", _alert_text, "necron_army", "");
    scr_event_log("red", $"Inquisition Mission Failed: Bombing run failed; the Necron Tomb on {p_data.name()} has become active.");

    p_data.add_forces(eFACTION.NECRONS, 4);
    if (awake_tomb_world(p_data.features) == 0) {
        awaken_tomb_world(p_data.features);
    }
}

static resolve_spyrer = function() {
    var _planet_name = p_data.name();
    alter_disposition(eFACTION.INQUISITION, -3);
    var _alert_text = $"The Spyrer on {_planet_name} has been left unchecked.  In the ensuing carnage some high-ranking officials have been killed, along with several Nobles.  Panic is running amock in several parts of the hives and the Inquisition is less than pleased.";
    var _text = "Inquisition Mission Failed: The Spyrer on {_planet_name} was not removed.";
    scr_popup("Inquisition Mission Failed", _alert_text, "spyrer", "");
    scr_event_log("red", _text);
}

static per_turn_check_spyrer = function() {
    if (p_data.player_forces > 20) {
        var _tixt = $"The Spyrer on {p_data.name()} seems to have vanished, presumably gone into hiding.";
        scr_popup("Spyrer Rampage", _tixt, "spyrer", "");
    } else if (p_data.player_forces <= 20) {
        new_end_turn_battle(
            30,
            "spyrer",
            {
                threat : 1,
                fortified : false,
                cols : [
                    {
                        distance : 10,
                        flank : true,
                        enemies : [
                            {
                                name : "Malcadon Spyrer",
                                number : 1
                            }
                        ]
                    }
                ]
            }
        );
    }
}

static spyrer_battle_aftermath = function(){
    // title / text / image / speshul
    if (!obj_ncombat.defeat){
        exit;
    }

    delete_mission = true;

    var _tixt = $"The Spyrer on {p_data.name()} has been removed.  The citizens and craftsman may sleep more soundly, the Inquisition likely pleased.";

    scr_popup("Inquisition Mission Completed", _tixt, "spyrer", "");

    var _disp_gain = obj_controller.demanding ? choose(0, 0, 1) : 2;
    var _disp_gain_string = alter_disposition(eFACTION.INQUISITION, _disp_gain);

    scr_event_log("", $"Inquisition Mission Completed: The Spyrer on {system.name} {planet} has been removed. {_disp_gain_string}", system.name);
    scr_gov_disp(system.name, planet, choose(1, 2, 3, 4));
}

static hunt_fallen_init = function(){
    var _text = localize("Sources indicate one of the Fallen may be upon {0}.  We have {1} months to send out a strike team and scour the planet.  Any longer and any Fallen that might be there will have escaped.", [p_data.name(), timer]);
    scr_popup(localize("Hunt the Fallen"), _text, "fallen", "");
    scr_event_log("", localize("Sources indicate one of the Fallen may be upon {0}.  We have {1} months to investigate.", [p_data.name(), timer]));
    mark("purple");
}

static per_turn_check_fallen = function() {
    if (p_data.player_forces > 0){
        if (choose(true, false)) {
            var _group_big = choose(true, false);
            var _battle_enemy_data = {};
            if (_group_big){
                _battle_enemy_data = {
                    threat : 1,
                    fortified : false,
                    cols : [
                        {
                            distance : 80,
                            enemies : [
                                {
                                    name : "Fallen",
                                    number : 1
                                }
                            ]
                        }
                    ]
                };

                // * Large Fallen Group *
                _battle_enemy_data = {
                    threat : 1,
                    fortified : false,
                    cols : [
                        {
                            distance : 80,
                            enemies : [
                                {
                                    name : "Fallen",
                                    number : choose(1, 1, 2, 2, 3)
                                }
                            ]
                        }
                    ]
                };
            }
            new_end_turn_battle(
                10, 
                p_id,
                _battle_enemy_data
            );
        } else {
            delete_mission = true;
            var _tixt = "Your marines have scoured " + planet_numeral_name(run, id) + " in search of the Fallen.  Despite their best efforts, and meticulous searching, none have been found.  It appears as though the information was faulty or out of date.";
            scr_popup("Hunt the Fallen", _tixt, "fallen", "");
            scr_event_log("", $"Mission Successful: No Fallen located upon {planet_numeral_name(run, id)}");
        }
    }
}

static resolve_fallen = function() {
    //TODO marker point for cohesion mechanics
    var _alert_text = "";
    if (irandom(100) > 33) {
        // Give all marines +3d6 corruption and reduce loyalty by 20*/
        for (var _co = 0; _co <= obj_ini.companies; _co++) {
            for (var _me = 0; _me < company_length(_co); _me++) {
                var _unit = fetch_unit([_co, _me]);
                if (_unit.base_group != "astartes") {
                    continue;
                }
                _unit.edit_corruption(irandom_range(3, 6));
                _unit.alter_loyalty(-10);
            }
        }
    }
    _alert_text = $"Any Fallen that may have been on {p_data.name()} ";
    _alert_text += "have been given sufficient time to escape.  Morale within your chapter has plummeted; some of your battle brothers have become restless and speak among eachother in hushed tones.";
    scr_popup("Hunt the Fallen Failed", _alert_text + "\n\n(Chapter wide loyalty: -10)\nChaplains note marked changes in behaviour of some brothers", "fallen", "");
    obj_controller.loyalty -= 10;
    obj_controller.loyalty_hidden -= 10;
    scr_event_log("red", $"Mission Failed: Any Fallen within the {system.name} system have been given time to escape.");
}

function hunt_fallen_battle_aftermath() {
    if (obj_ncombat.defeat) {
        exit;
    }
    delete_mission = true;
    var _tixt = "The Fallen on " + p_data.name();
    scr_event_log("", $"Mission Succesful: {_tixt} have been captured or purged.");
    _tixt += $" have been captured or purged.  They shall be brought to the Chapter {obj_ini.player_role_data[eROLE.CHAPLAIN].role}s posthaste, in order to account for their sins.  ";
    var _tex_options = [
        "Suffering is the beginning to penance.",
        "Their screams shall be the harbringer of their contrition.",
        "The shame they inflicted upon us shall be written in their flesh.",
    ];
    _tixt += _tex_options[choose(0, 0, 1, 2)];
    scr_popup("Hunt the Fallen Completed", _tixt, "fallen", "");
}

static per_turn_check_mech_raider = function() {
    var _techs = collect_role_group(SPECIALISTS_TECHS, [system.name, planet, -1]);
    var _lr_count = scr_vehicle_count("Land Raider", [system.name, planet, -1]);
    if ((array_length(_techs) >= 6) && (_lr_count >= 1)) {
        var _percent_complete = increment_mission_completion();
        scr_alert("", "mission", $"Mechanicus Mission on {p_data.name()} is {floor(_percent_complete)}% complete.", 0, 0);
        if (_percent_complete >= 100) {
            delete_mission = true;
            scr_mission_reward("mech_raider", system, planet);
            timer = -1
            per_turn_checks = false;
            zero_timer_checks = false;
        }
    }
}

static resolve_mech_raider_failed = function() {
    var _alert_text = $"Mechanicus Mission Failed: Land Raider testing at {p_data.name()}.";
    scr_alert("red", "mission_failed", _alert_text, 0, 0);
    scr_event_log("red", _alert_text);
    p_data.alter_disposition(eFACTION.MECHANICUS, -6);
    delete_mission = true;
}

static per_turn_check_mech_bionics = function() {
    var _units = p_data.collect_planet_group();
    var _bionics = _units.tally_attr("bionics");
    if (_bionics >= 10) {
        var _percent_complete = increment_mission_completion();
        scr_alert("", "mission", $"Mechanicus Mission on {p_data.name()} is {floor(_percent_complete)}% complete.", 0, 0);
        if (_percent_complete >= 100) {
            delete_mission = true;
            scr_mission_reward("mech_bionics", id, planet);
            timer = -1
            per_turn_checks = false;
            zero_timer_checks = false;
        }
    }
}

static resolve_mech_bionics_failed = function() {
    var _alert_text = $"Mechanicus Mission Failed: bionics testing at {p_data.name()}.";
    scr_alert("red", "mission_failed", _alert_text, 0, 0);
    scr_event_log("red", _alert_text);
    p_data.alter_disposition(eFACTION.MECHANICUS, -6);
    delete_mission = true;
}

static per_turn_check_mech_tomb2 = function() {
    data.turns++;
    var _battli = 0;
    var _roll1 = roll_dice_chapter(1, 100 + data.turns, "low");

    if (_roll1 > 98) {
        if ((_roll1 >= 90) && (_roll1 < 98)) {
            _battli = 1;
        } // oops
        if (_roll1 >= 98) {
            _battli = 2;
        } // very oops, much necron, wow

        if ((_battli > 0) && (p_data.player_forces > 0)) {
            // Queue the battle
            var _special = _battli == 1 ? "study2a" : "study2b";
            data.battle_key = _special;
            //currently inaccessible 
            if (obj_turn_end.battle_opponent[obj_turn_end.battles] == 11) {
                if (p_data.has_feature(eP_FEATURES.CHAOSWARBAND)) {
                    _special = "ChaosWarband";
                }
            }
            new_end_turn_battle(13, "mars_tomb",{threat : choose(2,3)});
        }
        if ((_battli > 0) && (p_data.player_forces <= 0)) {
            // XDDDDD
            scr_popup("Mechanicus Mission Failed", $"The Mechanicus Research team on planet {p_data.name()} have been killed by Necrons in the absence of your astartes.  The Mechanicus are absolutely livid, doubly so because of the promised security they did not recieve.", "", "");
            obj_controller.turns_ignored[3] += choose(8, 10, 12, 14, 16, 18, 20, 22, 24);
            p_data.alter_disposition(eFACTION.MECHANICUS, -25);
            delete_mission = true;
        }
    } else {
        if (_roll1 > 20) {
            scr_alert("", "mission", $"Adeptus Mechanicus research within the Necron Tomb of {p_data.name()} continues.", 0, 0);
        } else if (_roll1 <= 20) {
            var _text, _reward = choose(1, 1, 2);
            if (scr_has_adv("Tech-Brothers")) {
                _reward = choose(1, 2);
            }

            if (_reward == 1) {
                obj_controller.requisition += 400;
                _text = $"The Mechanicus Research team on planet {p_data.name()} have completed their work without any major setbacks.  Pleased with your astartes' work, they have granted you 400 Requisition to be used as you see fit.";
                scr_event_log("", $"Mechanicus Mission Completed: The Mechanicus research team on {p_data.name()} have completed their work.");
            } else if (_reward == 2) {
                var _last_artifact = scr_add_artifact("random", "", 0);
                _text = $"The Mechanicus Research team on planet {p_data.name()} have completed their work without any major setbacks.  Pleased with your astartes' work, they have granted your Chapter an artifact, to be used as you see fit.";
                scr_event_log("", $"Mechanicus Mission Completed: The Mechanicus research team on {p_data.name()} have completed their work.");
                scr_event_log("", "Artifact gifted from Mechanicus.");
            }
            _text += "\n" + add_disposition(eFACTION.MECHANICUS, 1);
            scr_popup("Mechanicus Mission Completed", _text, "mechanicus", "");
            delete_mission = true;
            timer = -1
            per_turn_checks = false;
            zero_timer_checks = false;
        }
    }
}

static per_turn_check_mech_tomb1 = function() {
    var _marines = collect_role_group("all", [system.name, planet, -1]);
    if (array_length(_marines) >= 20) {
        stage_id = "exploring";
        timer = 999;
        data.turns = 0;
        scr_popup("Mechanicus Research", $"The Mechanicus Research team on planet {p_data.name()} has taken note of your Astartes and are now prepared to begin their research.  Your marines are to stay on the planet until further notice.", "necron_cave", "");
    }
}

static resolve_mech_tomb1_failed = function() {
    var _alert_text = $"Mechanicus Mission Failed: Necron Tomb Study at {p_data.name()}.";
    scr_alert("red", "mission_failed", _alert_text, 0, 0);
    scr_event_log("red", _alert_text, system.name);
    p_data.alter_disposition(eFACTION.MECHANICUS, -15);
    delete_mission = true;
}

static mech_tomb_battle_aftermath = function() {
    if (obj_ncombat.defeat) {
        delete_mission = true;

        var _disp_change = alter_disposition(eFACTION.MECHANICUS, -10);

        if (data.battle_key == "study2a") {
            scr_popup("Mechanicus Mission Failed", $"All of your Astartes and the Mechanicus Research party have been killed down to the last man.  The research is a bust, and the Adeptus Mechanicus is furious with your chapter for not providing enough security.  Relations with them are worse than before. {_disp_change}", "", "");
        }
        if (data.battle_key == "study2b") {
            battle_object.p_necrons[battle_id] = 5;
            awaken_tomb_world(battle_object.p_feature[battle_id]);
            _disp_change = alter_dispositions([[eFACTION.MECHANICUS, -15], [eFACTION.INQUISITION, -5]]);
            scr_popup("Mechanicus Mission Failed", $"All of your Astartes and the Mechanicus Research party have been killed down to the last man.  The research is a bust.  To make matters worse the Necron Tomb has fully awakened- countless numbers of the souless machines are now pouring out of the tomb.  The Adeptus Mechanicus are furious with your chapter. {_disp_change}", "necron_army", "");
            scr_alert("", "inqi", "The Inquisition is displeased with your Chapter for tampering with and awakening a Necron Tomb", 0, 0);
            scr_event_log("", "The Inquisition is displeased with your Chapter for tampering with and awakening a Necron Tomb");
        }

        scr_event_log("", "Mechanicus Mission Failed: Necron Tomb Research Party and present astartes have been killed.");

    }   
}

static resolve_mech_mars = function() {
    var _techs_taken = 0;
    var _techs = collect_role_group([SPECIALISTS_TECHMARINES,false,true],system.name);
    for (i = 0; i < array_length(_techs); i++) {
        var _unit = _techs[i];
        system.p_player[planet] -= _unit.get_unit_size();
        _unit.location_string = "Mechanicus Vessel";
        _unit.planet_location = 0;
        _unit.ship_location = -1;
        _unit.job = {
            type: "mechanicus mission",
        };
        _techs_taken += 1;
    }

    if (_techs_taken == 0) {
        var alert_text = $"Mechanicus Mission Failed: Journey to Mars Catacombs at {p_data.name()}.";
        scr_alert("red", "mission_failed", alert_text, 0, 0);
        scr_event_log("red", alert_text);
        alter_disposition(eFACTION.MECHANICUS,-10)
    } else if (_techs_taken > 0) {
        if (_techs_taken >= 5) {
            alter_disposition(eFACTION.MECHANICUS,max(_techs_taken, 4))
        }
        var _text = $"Mechanicus Ship departs for the Mars catacombs.  Onboard are {_techs_taken} of your {obj_ini.player_role_data[eROLE.TECHMARINE].role}s.";
        scr_alert("", "mission", _text, 0, 0);
        scr_event_log("green", _text);
        var flit = create_enemy_fleet(system.x, system.y, eFACTION.MECHANICUS);

        with (flit) {
            sprite_index = spr_fleet_mechanicus;
            capital_number = 1;
            image_index = 0;
            image_speed = 0;
            trade_goods = "mars_spelunk1";
            home_x = x;
            home_y = y;
            action_x = x + lengthdir_x(3000, obj_controller.terra_direction);
            action_y = y + lengthdir_y(3000, obj_controller.terra_direction);
            set_fleet_movement(false, "move", 48, 48);
        }
    }
}


static init_garrison_mission = function() {
    var mission_data = problems_data[mission_slot];
    if (stage_id != "preliminary") {
        exit;
    }
    var _numeral_name = p_data.name();
    stage_id = "active";
    var _garrison_length = 10 + irandom(6);
    timer = _garrison_length;
    var _gar_pop = instance_create(0, 0, obj_popup);
    //TODO some new universal methods for popups
    _gar_pop.title = $"Requested Garrison Provided to {_numeral_name}";
    _gar_pop.text = $"The governor of {_numeral_name} Thanks you for considering his request for a garrison, you agree that the garrison will remain for at least {_garrison_length} months.";
    _gar_pop.add_option("Commence Garrison");
    _gar_pop.image = "";
    _gar_pop.cooldown = 8;
    obj_controller.cooldown = 8;
    scr_event_log("", $"Garrison committed to {_numeral_name} for {_garrison_length} months.", p_data.system.name);
}

static complete_garrison_mission = function() {
    if (stage_id != "active"){
        exit;
    }

    p_data.garrisons.update();
    if (p_data.current_owner != eFACTION.IMPERIUM || !p_data.garrisons.garrison_force) {
        p_data.add_disposition(-20);
        scr_popup($"Agreed Garrison of {name()}", $"your agreed garrison of  {name()} was cut short by your chapter the planetary governor has expressed his displeasure (disposition -20)", "", "");
        return;
    }

    var _mission_string = $"The garrison on {name()} has finished the period of garrison support agreed with the planetary governor.";
    var _result = p_data.garrisons.garrison_disposition_change();
    if (!p_data.garrisons.garrison_leader) {
        p_data.garrisons.find_leader();
    }

    var _effect = 0;
    if (_result == "none") {
        //TODO make a dedicated plus minus string function if there isn't one already
    } else if (_result < 0) {
        _effect = _result * irandom_range(1, 5);
        _mission_string += $"A number of diplomatic incidents occured over the period which had considerable negative effects on our disposition with the planetary governor (disposition -{_effect})";
    } else {
        _effect = _result * irandom_range(1, 5);
        _mission_string += $"As a diplomatic mission the duration of the stay was a success with our political position with the planet being enhanced greatly (disposition +{_effect})";
    }

    p_data.add_disposition(_effect);
    var _tester = global.character_tester;
    var _widom_test = _tester.standard_test(garrisons.garrison_leader, "wisdom", 0, ["siege"]);

    if (_widom_test[0]) {
        p_data.alter_fortification(1);
        _mission_string += $"while stationed {garrisons.garrison_leader.name_role()} makes several notable observations and is able to instruct the planets defense core leaving the world better defended (fortifications+1).";
    }
    //TODO just generall apply this each turn with a garrison to see if a cult is found
    if (has_feature(eP_FEATURES.GENE_STEALER_CULT)) {
        var _cult = get_features(eP_FEATURES.GENE_STEALER_CULT)[0];
        if (_cult.hiding) {
            _widom_test = _tester.standard_test(garrisons.garrison_leader, "wisdom", 0, ["tyranids"]);
            if (_widom_test[0]) {
                _cult.hiding = false;
                _mission_string += "Most alarmingly signs of a genestealer _cult are noted by the garrison. how far the rot has gone will now need to be investigated and the xenos taint purged.";
            }
        }
    }
    scr_popup($"Agreed Garrison of {name()} complete", _mission_string, "", "");
}

static protect_raiders_battle_aftermath = function() {
    // show_message(obj_turn_end.current_battle);
    // show_message(obj_turn_end.battle_world[obj_turn_end.current_battle]);
    // title / text / image / speshul
    var _planet_string = p_data.name();
    delete_mission = true;
    if (!obj_ncombat.defeat) {
        p_data.add_disposition(15);
        var _tixt = $"The Raiding forces on {_planet_string} have been removed.  The citizens and craftsman may sleep more soundly. ({_planet_string} disp +15)";

        scr_popup("Planet Protected", _tixt, "protect_raiders", "");
        scr_event_log("", $"Governor Request completed: Raiding forces on {_planet_string} have been eliminated.", system.name);
    } else {
        p_data.add_disposition(-15);
        var _tixt = $"The Raiding forces on {_planet_string} dispatched with your forces and will continue with their bloody practices.  The citizens remain unsafe and the governor is unimpressed. (planet disp -15)";
        scr_popup("Planet Protected", _tixt, "protect_raiders", "");
        scr_event_log("", $"Governor Request failed: Raiding forces on {_planet_string} continue to harrass population.", system.name);
    }
}

static protect_raider_squad_selected = function() {
    data.squad = data.squads[0];
    var _squad = data.squad;
    var _squad_units = _squad.members;
    var _squad_wisdom = stat_average(_squad_units, "wisdom");
    var _squad_dex = stat_average(_squad_units, "dexterity");
    var _tester = global.character_tester;

    var _mod = _squad_wisdom + _squad_dex / 20;
    if (scr_has_adv("Ambushers")) {
        _mod += 10;
    }

    var _leader = _squad.determine_leader();
    if (!is_struct(_leader)) {
        return;
    }
    var _wis_test = _tester.standard_test(_leader, "wisdom", _mod, ["ambush"]);

    if (!_wis_test[0]) {
        scr_toggle_manage();
        if (_wis_test[1] < -25) {
            var _gar_pop = instance_create(0, 0, obj_popup);
            _gar_pop.title = $"Strange Disappearance";
            _gar_pop.pdata = p_data;
            _gar_pop.text = $"Your Marines make planet fall and are directed to report to the governor for the duration of the operation after a period of reconnaissance dig in for their ambush. After a two weeks have passed A message from the governor reaches your astropaths that your marines have not been heard of for some time, The raiders also were not noted to have arrived onor left the planet";
            var _dead_marine = array_random_index(_squad_units);
            for (var i = 0; i < array_length(_dead_marine); i++) {
                if (i == _dead_marine) {
                    continue;
                }

                var _marine = _dead_marine[i];

                _marine.location_string = "Lost";
                _marine.ship_location = -1;
                _marine.planet_location = 0;
            }
            _gar_pop.text += $"After eventual investigation it appears the eldar anticipated the would be ambushers and turned the tides. {_squad_units[_dead_marine].name_role()}s body is eventually discovered some way off from the main battle his rent armour and body showing the extent of combat that must have occured";

            _gar_pop.text += "\nThe total loss of a squad in what was meant to be a routine operation is bad for moral and your chapters reputation you must now decide how to proceed";

            _gar_pop.add_option({str1: "Suppress the Information", choice_func: protect_raiders_suppress_information});

            _gar_pop.add_option({str1: "Hold a Memorial", choice_func: protect_raiders_hold_memorial});
        } else {
            var _gar_pop = instance_create(0, 0, obj_popup);
            _gar_pop.title = $"Ineffective Ambush";
            _gar_pop.text = $"Your Marines Are ineffective at setting up an ambush the assailants clearly got wind of the operation or the plan was otherwise so ill thought out that by the time your forces arrived there was little that could be done to intercept them";
            _gar_pop.text += $"";
            _gar_pop.pathway = "protect_raiders_ineffective";
            _gar_pop.pdata = p_data;
            p_data.add_disposition(-10);
            _gar_pop.text += "\nThe governor is unhappy and it has done little to improve your reputation with the planets populace but otherwise very little harm has been done. It is likely the raiders will choose better targets without the possible threat of space marine presence for the foreseeable future\nGovernor Disposition : -10";

            _gar_pop.add_option("continue");
        }
    } else {
        var _battle = new_battle(eFACTION.ELDAR);
		
        _roster = new Roster();
        with (_roster) {
            selected_units = _squad_units;
            setup_battle_formations();
            add_to_battle();
        }
        exit_adhoc_manage();

        _battle.battle_enemy_data = {
            threat : 3,
            fortified : false,
            reduce_fortification : true,
            reduce_power : true,
            cols : [
                {
                    distance : 20,
                    enemies : [
                        {
                            name : "Dire Avenger",
                            number : 40,
                            special : "shimmershield"
                        },
                        {
                            name : "Dire Avenger Exarch",
                            number : 4,
                            special : "shimmershield"
                        },
                        {
                            name : "Autarch",
                            number : 1
                        },
                        {
                            name : "Farseer",
                            number : 1,
                            special : "farseer_powers"
                        },
                        {
                            name : "Night Spinner",
                            number : 1
                        }
                    ]
                }
            ]
        };
    }
}    

static per_turn_check_inqisition_tomb = function() {
    if (p_player[run] <= 0){
        exit;
    }
    LOGGER.info($"player on planet with necron mission {name} planet: {planet}");
    var _have_bomb = 0;
    _have_bomb = scr_check_equip("Plasma Bomb", system.name, planet, 0);
    LOGGER.info($"have bomb? {_have_bomb} ");
    if (_have_bomb == 0) {
        exit;
    }
    var _tixt;
    _tixt = $"Your marines on {planet_numeral_name(planet, id)}";
    _tixt += " are prepared and ready to enter the Necron Tombs.  A Plasma Bomb is in tow.";
    var _number = instance_exists(obj_turn_end) ? 1 : 0;
    var _pop_data = {
        mission: self,
        loc: system.name,
        planet: planet,
        estimate: 999,
        number: _number,
        options: [
            {
                str1: "Begin the Mission",
                choice_func: function(){
                    mission.necron_tomb_mission_start();
                },
            },
            {
                str1: "Not Yet",
                choice_func: popup_default_close,
            },
        ],
    };
    scr_popup("Necron Tomb Excursion", _tixt, $"necron_cave", _pop_data);
}

static necron_tomb_mission_start = function() {
    obj_popup.title = $"Necron Tunnels : {data.mission_stage}";
    obj_popup.replace_options([{str1: "Continue", choice_func: self.necron_tomb_mission_sequence}, {str1: "Return to the surface", choice_func: popup_default_close}]);
    obj_popup.image = "necron_tunnels_1";
    obj_popup.text = "Your marines enter the massive tunnel complex, following the energy readings.  At first the walls are cramped and tiny, closing about them, but the tunnels widen at a rapid pace.";
}

/// @self Asset.GMObject.obj_popup
/// @desc Advances the Necron Tomb mission or starts a combat encounter.
/// @returns {Undefined}
static necron_tomb_mission_sequence = function() {
    var _battle;
    var player_forces = system.player_forces;
    var _penalty = 0;
    var _roll = roll_dice_chapter(1, 100, "low");
    _battle = 0;
    instance_activate_all();

    // SMALL TEAM OF MARINES
    if (player_forces > 6) {
        _penalty = 10;
    }
    if (player_forces > 10) {
        _penalty = 20;
    }
    if (player_forces >= 20) {
        _penalty = 30;
    }
    if (player_forces >= 40) {
        _penalty = 50;
    }
    if (player_forces >= 60) {
        _penalty = 100;
    }
    _roll += _penalty;

    // _roll=30;if (string_count("3",title)>0) then _roll=70;

    // Result
    data.tomb_awakens = false;
    if (_roll <= 60) {
        advance_necron_tomb_mission();
        exit;
    }
    if ((_roll > 60) && (_roll <= 82)) {
        // Necron Wraith attack
        _battle = 1;
    }
    if ((_roll > 82) && (_roll <= 92)) {
        // Tomb Spyder attack
        _battle = 2;
    }
    if ((_roll > 92) && (_roll <= 97)) {
        // Tomb Stalker
        _battle = 3;
    }
    if (_roll > 97) {
        // Tomb World wakes up
        data.tomb_awakens = true;
        if (player_forces <= 30) {
            _battle = 4;
        }
        if (player_forces > 30) {
            _battle = 5;
        }
        if (player_forces > 100) {
            _battle = 6;
        }
    }

    if (_battle > 0) {
        instance_deactivate_all_safe();
        instance_activate_object(obj_star);
        var _col = [];
        var _battle_data = {
            threat :  1,
            formation_set : 1,
            fortified : 0,
            reduce_fortification : true,
            reduce_power : true,
        }
        switch (_battle){
            case 1:
            _battle_data.cols = [
                {
                    distance : 10,
                    engaged : true,
                    enemies : [
                        {
                            name : "Necron Wraith",
                            number : 1
                        },
                        {
                            name : "Necron Wraith",
                            number : 1
                        }
                    ]

                }
            ]
            data.enemy = "wraith";
            case 2:
            break;
            _battle_data.cols = [
                {
                    distance : 10,
                    engaged : true,
                    enemies : [
                        {
                            name : "Canoptek Spyder",
                            number : 1
                        },
                        {
                            name : "Canoptek Scarab",
                            number : 20
                        }
                    ]

                }
            ]
            data.enemy = "spyder"
            case 3:
            break;
            _battle_data.cols = [
                {
                    distance : 10,
                    engaged : true,
                    enemies : [
                        {
                            name : "Tomb Stalker",
                            number : 1
                        }
                    ]

                }
            ]
            data.enemy = "stalker"
            break;
            case 4:
            _battle_data.threat = 2
            break
            case 5:
            case 6:
            _battle_data.threat = 3
            break
        }

        var _battle = new_battle(
            eFACTION.NECRONS,
        )
		_battle.battle_enemy_data = _battle_data;
        _roster = new Roster();
        with (_roster) {
            roster_location = system.name;
            roster_planet = planet;
            determine_full_roster();
            only_locals();
            update_roster();
            if (array_length(selected_units)) {
                setup_battle_formations();
                add_to_battle();
            }
        }

        instance_deactivate_object(obj_star);

        instance_destroy(obj_popup);
    }

    exit;
}

static inquisition_necron_battle_aftermath = function(){
    if (!data.tomb_awakens) {
        if (defeat == 1) {
            obj_controller.combat = 0;
            obj_controller.cooldown = 10;
            obj_turn_end.alarm[1] = 4;
        } else if (defeat == 0) {
            obj_controller.combat = 0;
            var pip = instance_create(0, 0, obj_popup);
            necron_tomb_mission_start();
            var _completed = advance_necron_tomb_mission();
            with (pip) {
                if (_completed) {
                    keyboard_clear(vk_enter);
                } else {
                    text = "The last of the attackers is cut down.  Your marines regroup in the tunnel and ready themselves to press deeper into the complex.\n\n" + text;
                }
                number = instance_exists(obj_turn_end);
            }
        }
    } else {
        var pip = instance_create(0, 0, obj_popup);
        with (pip) {
            title = "Necron Tomb Awakens";
            image = "necron_army";
            if (obj_ncombat.defeat == 0) {
                text = "Your marines make a tactical retreat back to the surface, hounded by Necrons all the way.  The Inquisition mission is a failure- you were to blow up the Necron Tomb World stealthily, not wake it up.  The Inquisition is not pleased with your conduct.";
            } else {
                text = "Your marines are killed down to the last man.  The Inquisition mission is a failure- you were to blow up the Necron Tomb World stealthily, not wake it up.  The Inquisition is not pleased with your conduct.";
            }
        }

        delete_mission = true;

        with (system) {
            var _planet = obj_ncombat.battle_id;
            p_necrons[planet] = 4;
            if (awake_tomb_world(p_feature[_planet]) == 0) {
                awaken_tomb_world(p_feature[_planet]);
            }
        }


        alter_disposition(eFACTION.INQUISITION, -5);
        obj_controller.combat = 0;

        with (pip) {
            number = instance_exists(obj_turn_end);
        }
    }
}

static advance_necron_tomb_mission = function() {
    data.mission_stage++;
    obj_popup.title = $"Necron Tunnels : {data.mission_stage}";

    if (data.mission_stage == 2) {
        obj_popup.image = "necron_tunnels_2";
        obj_popup.text = "The energy readings are much stronger, now that your marines are deep inside the tunnels.  What was once cramped is now luxuriously large, the tunnel ceiling far overhead decorated by stalactites.";
        return false;
    }
    if (data.mission_stage == 3) {
        obj_popup.image = "necron_tunnels_3";
        obj_popup.text = "After several hours of descent the entrance to the Necron Tomb finally looms ahead- dancing, sickly green light shining free.  Your marine confirms that the Plasma Bomb is ready.";
        return false;
    }
    if (data.mission_stage >= 4) {
        obj_popup.image = "";
        obj_popup.title = "Inquisition Mission Completed";
        obj_popup.text = "Your marines finally enter the deepest catacombs of the Necron Tomb.  There they place the Plasma Bomb and arm it.  All around are signs of increasing Necron activity.  With half an hour set, your men escape back to the surface.  There is a brief rumble as the charge goes off, your mission a success.";
        reset_popup_options();
        refresh_p_data();

        alter_disposition(eFACTION.INQUISITION, obj_controller.demanding ? choose(0, 0, 1) : 1);

        delete_mission = true;
        seal_tomb_world(p_data.features);

        scr_event_log("", $"Inquisition Mission Completed: Your Astartes have sealed the Necron Tomb on {p_data.name()}.", system.name);
        p_data.add_disposition(irandom_range(3, 7));
        scr_check_equip("Plasma Bomb", system.name, planet, 1);
        return true;
    }
    return false;
}

static inquisition_mission_options = fuction(mission_accept_function){
    var _options = [
        {
            str1: "Accept",
            choice_func: function(){
                pop_data.mission[$ mission_accept_function]();
                obj_controller.demanding = 0;
            }
        },
    ];
    if (!obj_controller.demanding){
        array_push(_options, {
            str1: "Refuse",
            choice_func: function(){
                pop_data.mission.delete_mission = true;
                popup_default_close();
            }
        })
    }
    return _options
}
static inquisition_demon_world_init = fuction(){
    var _text = $"The Inquisitor is trusting you with a special mission.  The planet {p_data.name()} has been uncovered as a Demon World";
    if (obj_controller.demanding) {
        _text = $"The Inquisition demands that your Chapter demonstrate its loyalty to the Imperium of Mankind and the Emperor.  An out of control Demon World {p_data.name()} must be cleansed within {timer} months.";
    }
    _text += $"The taint of chaos must be eradicated from this system.  Can your chapter handle this mission?";
    var _pop_data = {
        mission: self,
        options: inquisition_mission_options("inquisition_demon_world_accept"),
    };
    scr_popup(
        "Inquisition Mission Demon World", 
        text, 
        "inquisition", 
        _pop_data
    );
}

static inquisition_demon_world_accept = fuction(){
    scr_event_log("", $"Inquisition Mission Accepted: The demon world of {system.name} {scr_roman(planet)} will be purged by your hand.", system.name);
    new_star_event_marker("green");
    with(obj_popup){
        popup_default_close();
    }
}

static inquisition_tyranid_org_init = fuction(){
    var _pop_data = {
        mission: self,
        options: inquisition_mission_options("inquisition_tyranid_org_accept"),
    };
    var _text = $"An Inquisitor is trusting you with a special mission.  The planet {p_data.name()}";
    _text += " is ripe with Tyranid organisms.  They require that you capture one of the Gaunt species for research purposes.  Can your chapter handle this mission?";
    if (obj_controller.demanding) {
        _text = $"The Inquisition demands that your Chapter demonstrate its loyalty to the Imperium of Mankind and the Emperor.  {global.chapter_name} are to capture a Gaunt organism and return it, unharmed- 4x Webbers have been provided for this purpose.";
    }
    scr_popup("Inquisition Mission", _text, "inquisition",_pop_data);
}

static inquisition_tyranid_org_accept = fuction(){
    obj_popup.image = "webber";
    obj_popup.title = "New Equipment";
    obj_popup.fancy_title = 0;
    obj_popup.text_center = 0;
    obj_popup.text = $"{global.chapter_name} have been provided with 4x Astartes Webbers in order to complete the mission.";
    reset_popup_options();
    scr_add_item("Webber", 4);
    obj_controller.cooldown = 10;
    scr_event_log("", $"Inquisition Mission Accepted: The Inquisition wishes for the capture of a particular strain Gaunt noticed on {p_data.name()} is advisable.", system.name);
    obj_controller.useful_info += "Tyr|";
    data.captured_gaunt = 0;
}

static inquisition_tyranid_org_setup_battle = function(){
    if ((obj_ncombat.enemy != eFACTION.TYRANIDS) || (obj_ncombat.battle_object.space_hulk)) {
        exit;
    }
    obj_ncombat.battle_special = p_id;
    obj_ncombat.reduce_fortification = false;
    obj_ncombat.reduce_power = false;
}

static inquisition_tyranid_on_enemy_casulties = function(){
    var _c_data = casualty_packet;
    if (array_contains(["Termagaunt", "Hormagaunt"], _c_data.weapon) && (_c_data.casulties > 0)) {
        data.captured_gaunt += casulties;
    }
}

static inquisition_tyranid_org_battle_final_message = fuction(){
    if (obj_ncombat.defeat || data.captured_gaunt == 0) {
        exit;
    }
    var _gaunts = string_plural_count("Gaunt organism", captured_gaunt);
    _newline = $"{_gaunts} have been captured.";
    obj_ncombat.combat_log.push(_newline, eMSG_COLOR.YELLOW);

}

static inquisition_tyranid_org_battle_aftermath = function(){
    if (obj_ncombat.defeat|| data.captured_gaunt == 0){
        exit;
    }
    if (data.captured_gaunt > 1) {
        var _text =  "You have captured several Gaunt organisms.  The Inquisitor is pleased with your work, though she notes that only one is needed- the rest are to be purged.  It will be stored until it may be retrieved.  The mission is a success.";
    } else {
        var _text = "You have captured a Gaunt organism- the Inquisitor is pleased with your work.  The Tyranid will be stored until it may be retrieved.  The mission is a success.";
    }
    scr_popup("Inquisition Mission Completed",_text, "inquisition", "");
    if (data.captured_gaunt > 0) {
        delete_mission = true;
    }
}

static hive_fleet_to_cult_init = function(){
    var xx = (random_range(room_width * 1.25, room_width * 2) * choose(-1, 1)) + x;
    var yy = (random_range(room_height * 1.25, room_height * 2) * choose(-1, 1)) + y;
    var fleet = create_enemy_fleet(xx, yy, eFACTION.TYRANIDS);
    fleet.sprite_index = spr_fleet_tyranid;
    fleet.image_speed = 0;

    fleet.capital_number = choose(7, 8, 9);
    fleet.frigate_number = round(random_range(6, 12));
    fleet.escort_number = round(random_range(12, 27));

    fleet.image_index = floor(fleet.capital_number + (fleet.frigate_number / 2) + (fleet.escort_number / 4));
    fleet.image_alpha = 0;

    fleet.action_x = x;
    fleet.action_y = y;

    fleet.action_eta = timer;
    fleet.action = "move";
}

static per_turn_hive_fleet_to_cult = function(){
    if (timer != 3 || scr_has_disadv("Psyker Intolerant")){
        exit;
    }
    var _has_head_lib = scr_role_count(obj_ini.player_role_data[eROLE.CHIEFLIBRARIAN].role, "");

    var _head = get_department_head(eCHAPTER_DEPARTMENTS.LIB);

    if ((obj_controller.known[eFACTION.TYRANIDS] == 0) && (_has_head_lib != 0) && is_struct(_head)) {
        scr_popup("Shadow in the Warp", $"Chief {_head.name_role()} reports a disturbance in the warp.  He claims it is like a shadow.", "shadow", "");
        scr_event_log("red", $"Chief {obj_ini.player_role_data[eROLE.LIBRARIAN].role} reports a disturbance in the warp.  He claims it is like a shadow.");
    }
    if ((obj_controller.known[eFACTION.TYRANIDS] == 0) && (_has_head_lib == 0)) {
        for (var q = 0; q < array_length(obj_ini.TTRPG[0]); q++) {
            var _unit = fetch_unit([0, q]);
            if (_unit.role() == obj_ini.player_role_data[eROLE.CHAPTERMASTER].role) {
                if (string_count("0", _unit.specials) > 0) {
                    scr_popup("Shadow in the Warp", "You are distracted and bothered by a nagging sensation in the warp.  It feels as though a shadow descends upon your sector.", "shadow", "");
                    scr_event_log("red", "You sense a disturbance in the warp.  It feels something like a massive shadow.");
                }
                break;
            }
        }
    }

    obj_controller.known[eFACTION.TYRANIDS] = 1;
}

}



