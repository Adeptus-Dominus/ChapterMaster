//All missions that run on a planet now need their own PlanetProblem instance
//missions for the most part can only run from predefined points in the code
// to run from each of these points each mission must have a registered function these functions are then called implicitly
//each function follows the format  `__<p_id>_<entry_flag>`
/* the current entry points for the code are 
    "per_turn" - runs every end turn to check for certain conditions often contains reactions to actions player has done last turn
    "resolve" - runs when the mission timer hits 0 often contains the failure conditions for the mission
    - both of the above run via basic_turn_end -> PlanetData.problem_count_down -> scr_enemy_ai_d

    "setup_battle" - runs when the player initiates a battle via drop select window on a planet with a problem on
    "on_enemy_casulties" - runs during combat after player inflicts casualties to log data or inject mission specific combat logs
    "battle_final_message" - runs during combat to tally data and display a final log to the combat log
    "battle_aftermath" - runs post combat during obj_ncombat alarm_7
    "squad_selected" -  runs after selecting a squad inn the squad select window (scr_manage_task_selector)
    "unit_select" - runs after selecting units in the unit selection screen (scr_manage_task_selector)
    "on_purge" - at the top of PlanetData.purge() passes in {action_type, action_score} as purge_data overrides standard purge popups
    "init" - runs immediately after problem is created often used to populate initial popup or stack popup for turn end

    "accept" - is an edge case currently reserved for binding to button clicks in popups
    
    "planet_draw_feature_selected" - runs in a FeatureSelected instance it allows a player to select the mission from the star_Select/planet screen and view data about it
        - each `__<p_id>__feature_selected` function fills the draw_data struct so that __feature_selected_draw can run
        - by attaching a function to draw_data.button_function you can create windows to select specific marines and squads for missions
        - do this by using select_units and select_squads which are binds of group_selection
        - to handle the selected marines create `__<p_id>_unit_select` and __<p_id>_squad_selected` functions
        - selected marines will automatically get added to the members array creating a direct link to marines participating in a mission


- other than these entry points and any other later defined positions mission specific code should not run outside of the PlanetProblem container

- to set an entry point up simply register the function as a static e.g
    if i create static __inquisition_are_dicks_per_turn once a "inquisition_are_dicks" problem is registered on a planet via 
    PlanetData.new_problem("inquisition_are_dicks",200) the per turn check will run no other code is required
other info
    - set a mission for deletion by setting delete_mission = true; this will delete the mission after the current function
    has finished executing and 
*/

//ANYTIME an exception is caught on a entry point for a mission the mission is prematurely deleted this ensures the player is not unfairly penalised for errors

/// @param {string} _name
/// @param {Real} _timer
/// @param {struct} _data
/// @param {constructor PlanetData} _planet_data
function PlanetProblem(_name, _timer, _data, _planet_data) : Problem(_name, _timer, _data) constructor{
p_data = _planet_data;
planet = p_data.planet;
system = p_data.system;

static __refresh_data = function(){
    p_data = system.get_planet_data(planet);
    members = clean_unit_array(members);
}

extend_timer_for_warp_storm = true;
remove = false;
zero_timer_checks = true;
per_turn_checks = true;

static mark = function(colour = "green"){
    __refresh_data();
    with (p_data.system){
        new_star_event_marker(colour)
    }
}

static save = function(){
    var _save_copy = variable_clone(self);
    struct_remove(_save_copy, "system");
    struct_remove(_save_copy, "p_data");
    __save_members(_save_copy);
    return _save_copy;
}

static load = function(data){
    move_data_to_current_scope(data);
    __load_members();
    __refresh_data();
}

static view_on_planet_screen = function(){
    return (stage_id == "preliminary") && (has_data("applicant"));
}

static __check_delete = function(){
    if (timer == -1 || (delete_mission)){
        var _prob = -1;
        for (var i = 0; i < array_length(p_data.problems); i++){
            if (p_data.problems[i] == self){
                _prob = i;
            }
        }
        if (_prob > -1){
            array_delete(system.p_problem[planet], _prob,1);
        }
    }   
}

//overrides Problem's base version
static __handle_triggered_mission_func = function(func){
    if (!is_undefined(func)){
        __refresh_data();
        try {
            func();
        } catch (_exception) {
            delete_mission = true;
            ERROR_HANDLER.handle_exception(_exception);
        }
    }
    __check_delete();
    obj_controller.location_viewer.update_mission_log();
}

static basic_turn_end = function(){
    if (p_data.system.storm <= 0){
        timer--;
    }
    if ((timer > -1) && per_turn_checks) {
        var _func = find_func("per_turn");
        __handle_triggered_mission_func(_func);
    }
    if ((timer == 0) && zero_timer_checks && !delete_mission) {
        var _func = find_func("resolve");
        __handle_triggered_mission_func(_func);
    }
}

//TODO in the future this should be calculated once on feature selection and then draw each turn
static planet_draw_feature_selected = function(){
    if (!struct_exists(self, "draw_data")){
        exit;
    }
    draw_data.mission_description = "";
    draw_data.button_text = "";
    draw_data.button_function = noone;
    draw_data.help = "";
    draw_data.button_tooltip = "";
    var _func = find_func("feature_selected");
    __handle_triggered_mission_func(_func);
    __feature_selected_draw();
    struct_remove(self, "draw_data");
}

static __feature_selected_draw = function(){
    draw_text_transformed(draw_data.x1 + (draw_data.w / 2), draw_data.y1 + 5, description(), 2, 2, 0);
    draw_set_halign(fa_left);
    draw_set_color(c_gray);
    draw_text_ext(draw_data.x1 + 10, draw_data.y1 + 40, draw_data.mission_description, -1, draw_data.w - 20);
    var _text_body_height = string_height_ext(draw_data.mission_description, -1, draw_data.w - 20);
    if (draw_data.help != "") {
        draw_text_ext(draw_data.x1 + 10, draw_data.y1 + 40 + _text_body_height + 10, draw_data.help, -1, draw_data.w - 20);
        _text_body_height += string_height_ext(draw_data.mission_description, -1, draw_data.w - 20) + 10;
    }

    if (draw_data.button_text != "") {
        var _button = draw_unit_buttons([draw_data.x1 + ((draw_data.w / 2) - (string_width(draw_data.button_text) / 2)), draw_data.y1 + 40 + _text_body_height + 10], draw_data.button_text);
        if (draw_data.button_tooltip != "" && scr_hit(_button)) {
            tooltip_draw(draw_data.button_tooltip);
        }
        if (point_and_click(_button)) {
            if (is_callable(draw_data.button_function)) {
                draw_data.button_function();
                destroy = true;
            } else {
                tooltip_draw("no implemented function");
            }
        }
    }    
}

static on_purge = function(){
    if (!struct_exists(self, "purge_data")){
        exit;
    }
    var _func = find_func("on_purge");
    __handle_triggered_mission_func(_func);

    struct_remove(self, "purge_data");
}

static __init = function(){
    if (p_id == ""){
        exit;
    }
    var _func = find_func("init");
    if (!is_undefined(_func)){
        __handle_triggered_mission_func(_func);
    } else {
        mark("green");
    }
	/*switch(p_id){
	    case "chaos_lord_meeting":
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
        case "harlequins":
            var _text = $"Eldar Harlequins have been seen on planet {p_data.name()}. Their purposes are unknown.";
            scr_popup("Harlequin Troupe", _text, "harlequin", "");
            mark("green");
            break;
        default:
            mark("green");
			break;

	}*/
}
__init();

//self must be referenced like this or the compiler assumes i want feature to refer to the arg struct i'm passing 
static select_units = function(select_from, purpose_string, number, selections = []){
    var _self = self;
    group_selection(select_from, {purpose: purpose_string, purpose_code: p_id, number: number, system , feature: _self, planet, selections});
}

static select_squads = function(select_from, purpose_string, number, selections = []){
    var _self = self;
    group_selection(select_from, {purpose: purpose_string, purpose_code: p_id, number: number, system , feature: _self, planet, selections, select_type: eMISSION_SELECT_TYPE.SQUADS});
}
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

static __set_members_job_to_mission = function(){
    for (var i = 0; i < array_length(members); i++){
        var _unit = members[i];
        _unit.job = {
            type: p_id,
            planet: planet,
            location: system.name,
        };
        _unit.unload(planet, system);            
    }    
};

static __hunt_beast_init = function(){
    stage_id =  "preliminary";
    data.applicant = "Governor"
}

static __hunt_beast_feature_selected = function(){
    draw_data.mission_description = $"The governor of {p_data.name()} has bemoaned the raiding of huge beasts on the fringes of the planets largest city, the numbers have swelled recently and are causing huge damage to the planets small economy. You could send a force to intervene, it would provide a fine test of metal for any that partake.";
    draw_data.help = "This is a good opportunity to provide experience and training, having at least one marine with experience in such matters would be advisable";
    draw_data.button_text = "Send Hunters";
    draw_data.button_function = method(self, function() {
        var _dudes = collect_role_group("all", system.name);
        select_units(_dudes, "Beast Hunt",  3);
    });    
};


static __hunt_beast_unit_select = function() {
    if (stage_id == "preliminary") {
        __set_members_job_to_mission();
        var _numeral_name = p_data.name()
        stage_id = "active";
        timer = irandom_range(2, 5);
        var _gar_pop = instance_create(0, 0, obj_popup);
        //TODO some new MissonHelper methods for popups
        _gar_pop.title = $"Marines assigned to hunt beasts around {_numeral_name}";
        _gar_pop.text = $"The governor of {_numeral_name} Thanks you for the participation of your elite warriors in your execution of such a menial task.";
        _gar_pop.add_option("Happy Hunting");
        _gar_pop.image = "";
        _gar_pop.cooldown = 8;
        obj_controller.cooldown = 20;
        scr_event_log("", $"Beast hunters deployed to {_numeral_name} for {timer} months.", p_data.system.name);
        obj_controller.close_popups = false;
    }
}

static __hunt_beast_resolve = function() {
    delete_mission = true;
    if (stage_id == "preliminary"){
        exit;
    }
    var _hunters = clean_unit_array(members);
    if (array_length(_hunters) == 0){
        var _man_conditions = {
            "job": "hunt_beast",
            "max": 3,
        };
        _hunters = collect_role_group("all", [system.name, planet, 0], false, _man_conditions);
        if (array_length(_hunters) == 0){
            exit;
        }
    }

    var _mission_string = "";
    var _success = false;
    var _tester = global.character_tester;
    var _unit_report_string = "";
    var _deaths = 0;
    var _successful_hunters = [];

    if (!array_length(_hunters)) {
        return;
    }

    for (var i = 0; i < array_length(_hunters); i++) {
        var _unit = _hunters[i];
        var _unit_pass = _tester.standard_test(_unit, "weapon_skill", 10, ["beast"]);
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
                    if (irandom(30) < _unit.luck) {
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
            _mission_string += $"Unfortunately {_deaths} of your marines died.";
        }
        _mission_string += $"\n{_unit_report_string}";
    } else {
        _mission_string = $"The mission was a failure. The governor is disappointed and the legend of your chapter has undoubtedly been diminished";
        _mission_string += $"\n{_unit_report_string}";
    }

    scr_popup($"Beast Hunt on {p_data.name()}", _mission_string, "", "");
    for (var i = 0; i < array_length(_hunters); i++) {
    	_hunters[i].job = "none";
    }
    delete_mission = true;
}

static __train_forces_feature_selected = function() {
    draw_data.mission_description = $"The governor of {p_data.name()} fears the planet will not hold in the case of major incursion, it has not seen war in some time and he fears the ineptitude of the commanders available, he asks for aid in planning a thorough plan for defense and schedule of works for a period of at least 6 months.";
    draw_data.help = $"A task best suited to the more knowledgable or wise of your Commanders";
    draw_data.button_text = "Assign Officer";
    draw_data.button_function = method(self, function() {
        var _dudes = collect_role_group(SPECIALISTS_CAPTAIN_CANDIDATES, system.name);
        select_units(_dudes,"Select Officer", 1);
    });    
}

static __train_forces_unit_select = function() {
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

static __train_forces_resolve = function() {
    delete_mission = true;
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
        _mission_string += "The original training mission was a failure";
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
                _mission_string += $"His particularly gruelling regimes and standards imposed upon the senior officers of the pdf caused friction with physical injury being caused to one officer";
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

static __succession_resolve = function() {
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
        //At the moment does not fire but a worthy flavour option for down the line
        _alert_text += " Word is the new Governor has Heretical leanings and sympathises with xenos.";
    }

    p_data.delete_feature(eP_FEATURES.SUCCESSION_WAR);
}

static __inquisition_recon_init = function(){

    var _pop_data = {
        options : __inquisition_mission_options()
    };
    _pop_data.mission = self;

    var _text = $"The Inquisition wishes for you to investigate {p_data.name()}";
    _text += $"  Boots are expected to be planted on its surface over the course of your investigation.";
    _text += $" You have {timer} months to complete this task.";
    scr_popup("Inquisition Recon", _text, "inquisition", _pop_data);
}

static __inquisition_recon_accept = function(){
    mark("green");
    scr_event_log("", $"Inquisition Mission Accepted: The Inquisition wish for Astartes to land on and investigate {p_data.name()} within {timer} months.", system.name);
    __popup_delete();
}

static __inquisition_recon_per_turn = function() {
    if (p_data.player_forces <= 0){
        exit;
    }

    var _pop_data = {
    };
    _pop_data.mission = self;
    scr_popup(
        "Investigation Completed", 
        "Your marines have scouted out {p_data.name()} and satisfied the mission requirements.", 
        "inquisition", 
        _pop_data
    );
    scr_event_log("", $"Inquisition Mission Completed: Your Astartes have successfully scouted  {p_data.name()}.");

    delete_mission = true;

}
static __inquisition_recon_resolve = function() {
    delete_mission = true;
    var _alert_text = "Inquisition Mission Failed: Investigate ";
    alter_disposition(eFACTION.INQUISITION, -5);
    _alert_text += $"{p_data.name()}.";
    scr_alert("red", "mission_failed", _alert_text, 0, 0);
    scr_event_log("red", _alert_text);
}

static __inquisition_spyrer_init = function(){
    var _text = $"The Inquisition is trusting you with a special mission.  An experienced Spyrer on hive world {p_data.name()}";
    _text += $" has began to hunt indiscriminately, and proven impossible to take down by conventional means.  If they are not put down within {timer} month's time panic is likely.  Can your chapter handle this mission?";
    var _pop_data = {
        options: __inquisition_mission_options(),
    };
    _pop_data.mission = self;
    scr_popup("Inquisition Mission", _text, "inquisition", _pop_data);
}

static __inquisition_spyrer_accept = function(){
    var _text = $"Inquisition Mission Accepted: An experienced Spyrer on {p_data.name()} must be put down within {timer} months.";
    scr_event_log("", _text, system.name);
}
static __inquisition_spyrer_resolve = function() {
    delete_mission = true;
    var _planet_name = p_data.name();
    alter_disposition(eFACTION.INQUISITION, -3);
    var _alert_text = $"The Spyrer on {_planet_name} has been left unchecked.  In the ensuing carnage some high-ranking officials have been killed, along with several Nobles.  Panic is running amock in several parts of the hives and the Inquisition is less than pleased.";
    var _text = "Inquisition Mission Failed: The Spyrer on {_planet_name} was not removed.";
    scr_popup("Inquisition Mission Failed", _alert_text, p_id, "");
    scr_event_log("red", _text);
}

static __inquisition_spyrer_per_turn = function() {
    if (p_data.player_forces > 20) {
        var _tixt = $"The Spyrer on {p_data.name()} seems to have vanished, presumably gone into hiding.";
        scr_popup("Spyrer Rampage", _tixt, p_id, "");
    } else if (p_data.player_forces <= 20) {
        new_end_turn_battle(
            30,
            p_id,
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

static __inquisition_spyrer_battle_aftermath = function(){
    // title / text / image / special
    if (!obj_ncombat.defeat){
        exit;
    }

    delete_mission = true;

    var _tixt = $"The Spyrer on {p_data.name()} has been removed.  The citizens and craftsman may sleep more soundly, the Inquisition likely pleased.";

    scr_popup("Inquisition Mission Completed", _tixt, p_id, "");

    var _disp_gain = obj_controller.demanding ? choose(0, 0, 1) : 2;
    var _disp_gain_string = alter_disposition(eFACTION.INQUISITION, _disp_gain, true);

    scr_event_log("", $"Inquisition Mission Completed: The Spyrer on {system.name} {planet} has been removed. {_disp_gain_string}", system.name);
    scr_gov_disp(system.name, planet, choose(1, 2, 3, 4));
}

static __hunt_fallen_init = function(){
    var _text = localize("Sources indicate one of the Fallen may be upon {0}.  We have {1} months to send out a strike team and scour the planet.  Any longer and any Fallen that might be there will have escaped.", [p_data.name(), timer]);
    scr_popup(localize("Hunt the Fallen"), _text, "fallen", "");
    scr_event_log("", localize("Sources indicate one of the Fallen may be upon {0}.  We have {1} months to investigate.", [p_data.name(), timer]));
    mark("purple");
}

static __hunt_fallen_per_turn = function() {
    if (p_data.player_forces <= 0){
        exit;
    }
    if (irandom(1) == 1) {
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
                                number : choose(3, 4, 5)
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
        var _tixt = $"Your marines have scoured {p_data.name()} in search of the Fallen.  Despite their best efforts, and meticulous searching, none have been found.  It appears as though the information was faulty or out of date.";
        scr_popup("Hunt the Fallen", _tixt, "fallen", "");
        scr_event_log("", $"Mission Successful: No Fallen located upon {p_data.name()}");
    }
}

static __hunt_fallen_resolve = function() {
    delete_mission = true;
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
    _alert_text += "have been given sufficient time to escape.  Morale within your chapter has plummeted; some of your battle brothers have become restless and speak among each other in hushed tones.";
    scr_popup("Hunt the Fallen Failed", _alert_text + "\n\n(Chapter wide loyalty: -10)\nChaplains note marked changes in behaviour of some brothers", "fallen", "");
    obj_controller.loyalty -= 10;
    obj_controller.loyalty_hidden -= 10;
    scr_event_log("red", $"Mission Failed: Any Fallen within the {system.name} system have been given time to escape.");
}

function __hunt_fallen_battle_aftermath() {
    if (obj_ncombat.defeat) {
        exit;
    }
    delete_mission = true;
    var _tixt = "The Fallen on " + p_data.name();
    scr_event_log("", $"Mission Successful: {_tixt} have been captured or purged.");
    _tixt += $" have been captured or purged.  They shall be brought to the Chapter {obj_ini.player_role_data[eROLE.CHAPLAIN].role}s posthaste, in order to account for their sins.  ";
    var _tex_options = [
        "Suffering is the beginning to penance.",
        "Their screams shall be the harbinger of their contrition.",
        "The shame they inflicted upon us shall be written in their flesh.",
    ];
    _tixt += _tex_options[choose(0, 0, 1, 2)];
    scr_popup("Hunt the Fallen Completed", _tixt, "fallen", "");
}

static __mech_raider_init = function(){
    var _mission_loc = p_data.name();
    var _nearest_fleet = get_nearest_player_fleet(system.x, system.y);
    if (_nearest_fleet == noone){
        delete_mission = true;
        exit;
    }
    timer = get_viable_travel_time(5, _nearest_fleet.x, _nearest_fleet.y, system.x, system.y, _nearest_fleet, false);
    var _vacation_time = 24;
    timer += _vacation_time;
    var _techs = collect_role_group([SPECIALISTS_TECHMARINES, false, true]);

    //tech count is calculated earlier called mission is not added to p_problems array if less than 3
    var _techs_required = min(array_length(_techs) - 2, 6);
    data =  {completion: 0, required_months: _vacation_time,techs_required:_techs_required}
    var _eligible_roles = role_groups(SPECIALISTS_TECHMARINES);
    obj_popup.text = $"The Adeptus Mechanicus await your forces at {_mission_loc}.  They are expecting {_techs_required} {_eligible_roles}s and a Land Raider.";
    scr_event_log("", $"Mechanicus Mission Accepted: {_techs_required} of your {_eligible_roles}s and a Land Raider are to be stationed at {_mission_loc} for {timer} months.", system.name);
    mark("green");
    title = "Mechanicus Mission Accepted";
}

static __mech_raider_per_turn = function() {
    var _techs = collect_role_group(SPECIALISTS_TECHMARINES,[system.name, planet, -1] , false,{},true );
    var _lr_count = scr_vehicle_count("Land Raider", [system.name, planet, -1]);
    var _percent_complete = 0;
    if ((_techs.number() >= data.techs_required) && (_lr_count >= 1)) {
        _percent_complete = __increment_mission_completion();
        scr_alert("", "mission", $"Mechanicus Mission on {p_data.name()} is {floor(_percent_complete)}% complete.", 0, 0);
    }
    if (_percent_complete < 100){
        exit;
    }
    var _cleanup = array_create(obj_ini.companies+1, false);
    delete_mission = true;
    timer = -1
    per_turn_checks = false;
    zero_timer_checks = false;

    var _roll1 = roll_dice_chapter(1, 100, "low");
    var result = "";

    if (_roll1 <= 33) {
        result = "New";
    }
    if ((_roll1 > 33) && (_roll1 <= 66)) {
        result = "Land Raider";
    }
    if (_roll1 > 66) {
        result = "Requisition";
    }
    var _tech_role = obj_ini.player_role_data[eROLE.TECHMARINE].role;

    if (result == "New") {
        scr_popup("Mechanicus Mission Completed", $"Your {obj_ini.player_role_data[eROLE.TECHMARINE].role} have worked with the Adeptus Mechanicus in a satisfactory manor.  The testing and training went well, but your Land Raider was ultimately lost.  300 Requisition has been given to your Chapter and relations are better than before.", "mechanicus", "");
        obj_controller.requisition += 300;
        alter_disposition(eFACTION.MECHANICUS ,2);
        var _found = false;
        for (var com = 0; com <= obj_ini.companies; com++) {
            if (_found) {
                break;
            }
            for (var i = 1; i <= 100; i++) {
                if ((obj_ini.veh_role[com][i] == "Land Raider") && (obj_ini.veh_loc[com][i] == system.name) && (obj_ini.veh_wid[com][i] == planet)) {
                    destroy_vehicle(com, i);
                    _cleanup[com] = true;
                    _found = true;
                    break;
                }
            }
        }
    }
    if (result == "Land Raider") {
        scr_popup("Mechanicus Mission Completed", $"Your {_tech_role} have worked with the Adeptus Mechanicus in a satisfactory manor.  The testing and training went well, but your Land Raider was ultimately lost.  A new Land Raider has been provided in return.", "mechanicus", "");
        var _found = false;
        alter_disposition(eFACTION.MECHANICUS ,1);
        for (var com = 0; com <= obj_ini.companies; com++) {
            if (_found) {
                break;
            }
            for (var i = 1; i <= 100; i++) {
                if ((obj_ini.veh_role[com][i] == "Land Raider") && (obj_ini.veh_loc[com][i] == system.name) && (obj_ini.veh_wid[com][i] == planet)) {
                    _found = true;
                    obj_ini.veh_hp[com][i] = 100;
                }
            }
        }
    }
    if (result == "Requisition") {
        scr_popup("Mechanicus Mission Completed", $"Your {_tech_role} have worked with the Adeptus Mechanicus in a satisfactory manor.  The testing and training went well, but your Land Raider was ultimately lost.  600 Requisition has been given to your Chapter as compensation.", "mechanicus", "");
        obj_controller.requisition += 600;
        alter_disposition(eFACTION.MECHANICUS ,1);
    }

    for (var i = 0; i <= obj_ini.companies; i++) {
        if (_cleanup[i]) {
            with (obj_ini) {
                scr_vehicle_order(i);
            }
        }
    }

}

static __mech_raider_resolve = function() {
    delete_mission = true;
    var _alert_text = $"Mechanicus Mission Failed: Land Raider testing at {p_data.name()}.";
    scr_alert("red", "mission_failed", _alert_text, 0, 0);
    scr_event_log("red", _alert_text);
    alter_disposition(eFACTION.MECHANICUS, -6);
    delete_mission = true;
}

static __mech_bionics_per_turn = function() {
    var _units = p_data.collect_planet_group();
    var _bionics = _units.tally_attr("bionics");
    var _percent_complete = 0;
    if (_bionics >= 10) {
        _percent_complete = __increment_mission_completion();
        scr_alert("", "mission", $"Mechanicus Mission on {p_data.name()} is {floor(_percent_complete)}% complete.", 0, 0);
    }
    if (_percent_complete < 100){
        exit;
    }
    var _cleanup = array_create(obj_ini.companies + 1, 0);
    delete_mission = true;
    timer = -1
    per_turn_checks = false;
    zero_timer_checks = false;
    var _roll1 = roll_dice_chapter(1, 100, "low");
    var result = "";

    if (_roll1 <= 33) {
        result = "Requisition";
    }
    if ((_roll1 > 33) && (_roll1 <= 66)) {
        result = "Bionics";
    }
    if (_roll1 > 66) {
        result = "Marines Lost";
    }
    var _mech_disp_change = 0;
    var _text = "The Adeptus Mechanicus have finished experimenting on your marines";
    var _marines = collect_role_group("all", [system.name, planet, -1], false, {}, true);
    if (result == "Marines Lost") {
        _text += "- unfortunantly none of them have survived.  150 Requisition has provided as weregild for each Astartes lost.";
        _mech_disp_change = 2;
        obj_controller.requisition += 150 * _marines.number();
        _marines.kill_percent(100);
    } else if (result == "Bionics" || result == "Requisition") {
        _mech_disp_change = 1;

        if (result == "Bionics") {
            var _new_bionics = irandom_range(40, 100);
            scr_add_item("Bionics", _new_bionics);
            _text += $" A large amount of additional Bionics have been provided by the Mechanicus as a reward ( X{_new_bionics} Bionics added to stocks)";
        } else if (result == "Requisition") {
            var _req_gain = irandom_range(200, 650);
            _text += $"{_req_gain} Requisition has been provided by the Mechanicus as a reward.";
            obj_controller.requisition += _req_gain;
        }
        var _limit = 0;
        for (var i = 0; i < array_length(_marines.units); i++) {
            var _unit = _marines.units[i];
            if (_unit.bionics > 0) {
                _unit.update_health(irandom_range(2, 80));

                if (!_unit.has_trait("flesh_is_weak")) {
                    _unit.update_loyalty(-20);
                }

                repeat (choose(2, 3, 4)) {
                    _unit.add_bionics("none", "any", false);
                }
                _limit++;
            }
            if (_limit >= 10) {
                break;
            }
        }
    }
    _text += $"\n{alter_disposition(eFACTION.MECHANICUS, _mech_disp_change, true)}";
    scr_popup("Mechanicus Mission Completed", _text, "mechanicus");
    sort_all_companies_to_map(_cleanup);
}

static __mech_bionics_resolve = function() {
    delete_mission = true;
    var _alert_text = $"Mechanicus Mission Failed: bionics testing at {p_data.name()}.";
    scr_alert("red", "mission_failed", _alert_text, 0, 0);
    scr_event_log("red", _alert_text);
    alter_disposition(eFACTION.MECHANICUS, -6);
    delete_mission = true;
}
static __mech_tomb_init = function() {
    var _name = p_data.name();
    if (!instance_exists(obj_popup)){
        scr_popup("Mechanicus Mission Accepted", "","mechanicus");
    }
    obj_popup.text = $"The Adeptus Mechanicus await your forces at {_name}.  They are expecting at least two squads of Astartes and have placed the testing on hold until their arrival.  {global.chapter_name} have 16 months to arrive.";
    scr_event_log("", $"Mechanicus Mission Accepted: At least two squads of marines are expected at {_name} within 16 months.", system.name);
    mark("green");
    obj_popup.title = "Mechanicus Mission Accepted";
    reset_popup_options();
    obj_popup.cooldown = 15;
}
static __mech_tomb_per_turn = function() {
    if (stage_id == "awating_player"){
        var _marines = collect_role_group("all", [system.name, planet, -1]);
        if (array_length(_marines) >= 20) {
            stage_id = "exploring";
            timer = 999;
            data.turns = 0;
            scr_popup("Mechanicus Research", $"The Mechanicus Research team on planet {p_data.name()} has taken note of your Astartes and are now prepared to begin their research.  Your marines are to stay on the planet until further notice.", "necron_cave", "");
        }
    } else {
        __mech_tomb_exploring();
    }
}

static __mech_tomb_exploring = function() {
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
            alter_disposition(eFACTION.MECHANICUS, -25);
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
                scr_event_log("", "Artefact gifted from Mechanicus.");
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

static __mech_tomb_resolve = function() {
    delete_mission = true;
    var _alert_text = $"Mechanicus Mission Failed: Necron Tomb Study at {p_data.name()}.";
    scr_alert("red", "mission_failed", _alert_text, 0, 0);
    scr_event_log("red", _alert_text, system.name);
    alter_disposition(eFACTION.MECHANICUS, -15);
    delete_mission = true;
}

static __mech_tomb_battle_aftermath = function() {
    if (obj_ncombat.defeat) {
        delete_mission = true;

        var _disp_change = alter_disposition(eFACTION.MECHANICUS, -10, true);

        if (data.battle_key == "study2a") {
            scr_popup("Mechanicus Mission Failed", $"All of your Astartes and the Mechanicus Research party have been killed down to the last man.  The research is a bust, and the Adeptus Mechanicus is furious with your chapter for not providing enough security.  Relations with them are worse than before. {_disp_change}", "", "");
        }
        if (data.battle_key == "study2b") {
            battle_object.p_necrons[battle_id] = 5;
            awaken_tomb_world(battle_object.p_feature[battle_id]);
            _disp_change = alter_dispositions([[eFACTION.MECHANICUS, -15], [eFACTION.INQUISITION, -5]], true);
            scr_popup("Mechanicus Mission Failed", $"All of your Astartes and the Mechanicus Research party have been killed down to the last man.  The research is a bust.  To make matters worse the Necron Tomb has fully awakened- countless numbers of the souless machines are now pouring out of the tomb.  The Adeptus Mechanicus are furious with your chapter. {_disp_change}", "necron_army", "");
            scr_alert("", "inquisition", "The Inquisition is displeased with your Chapter for tampering with and awakening a Necron Tomb", 0, 0);
            scr_event_log("", "The Inquisition is displeased with your Chapter for tampering with and awakening a Necron Tomb");
        }

        scr_event_log("", "Mechanicus Mission Failed: Necron Tomb Research Party and present Astartes have been killed.");

    }   
}

static __mech_mars_init = function() {
    reset_popup_options();    
    var _mission_loc = p_data.name();
    var _nearest_fleet = get_nearest_player_fleet(system.x, system.y );
    if (_nearest_fleet == noone){
        delete_mission = true;
        obj_popup.text = $"Error valid player fleet not found please open a bug report if seen";
        exit;
    }
    var _mission_time = get_viable_travel_time(5, _nearest_fleet.x, _nearest_fleet.y, system.x, system.y, _nearest_fleet, false);
    timer = _mission_time;
    obj_popup.text = $"The Adeptus Mechanicus await your {obj_ini.player_role_data[eROLE.TECHMARINE].role}s at {_mission_loc}.  They are willing to hold on the voyage for up to {_mission_time} months.";
    scr_event_log("", $"Mechanicus Mission Accepted: {obj_ini.player_role_data[eROLE.TECHMARINE].role}s are expected at {_mission_loc} within 30 months, for the voyage to Mars.", system.name);
    mark();
    obj_popup.title = "Mechanicus Mission Accepted";
    
}

static __mech_mars_resolve = function() {
    delete_mission = true;
    var _techs = scr_group_count([SPECIALISTS_TECHMARINES,false,true], system.name, "units");
    members = _techs;
    var _techs_taken = array_length(members);

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
        var _flit = create_enemy_fleet(system.x, system.y, eFACTION.MECHANICUS);

        with (_flit) {
            sprite_index = spr_fleet_mechanicus;
            capital_number = 1;
            image_index = 0;
            image_speed = 0;
        }
        _flit.add_problem("mech_mars", -1, {members});
    }
}

static __provide_garrison_init = function(){
    if (system.get_garrison(planet).garrison_force) {
        delete_mission = true;
        exit;
    }
    stage_id =  "preliminary";
    data.applicant = "Governor"
    data.reason = choose("stability", "importance");
}

static __provide_garrison_feature_selected = function() {
    //TODO : complete logic if (data.reason == "importance") {}
    draw_data.mission_description = $"The governor of {p_data.name()} has requested a force of marines might stay behind following your departure.\n\n\n assign a squad to garrison to initiate mission, The garrison leeader will need to be capable of conducting himself in a diplomatic manner in order for the garrison duration to be a success";
}

static provide_garrison_on_garrison = function() {
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

static __provide_garrison_resolve = function() {
    delete_mission = true;
    if (stage_id != "active"){
        exit;
    }

    var _garrison = p_data.garrisons;
    _garrison.update();
    if (p_data.current_owner != eFACTION.IMPERIUM || !_garrison.garrison_force) {
        p_data.add_disposition(-20);
        scr_popup($"Agreed Garrison of {p_data.name()}", $"your agreed garrison of  {p_data.name()} was cut short by your chapter the planetary governor has expressed his displeasure (disposition -20)", "", "");
        return;
    }

    var _mission_string = $"The garrison on {p_data.name()} has finished the period of garrison support agreed with the planetary governor.";
    var _result = _garrison.garrison_disposition_change();
    if (!_garrison.garrison_leader) {
        _garrison.find_leader();
    }
    var _leader = _garrison.garrison_leader;

    var _effect = 0;
    if (_result == "none") {
        //TODO make a dedicated plus minus string function if there isn't one already
    } else if (_result < 0) {
        _effect = _result * irandom_range(1, 5);
        _mission_string += $"A number of diplomatic incidents occurred over the period which had considerable negative effects on our disposition with the planetary governor (disposition -{_effect})";
    } else {
        _effect = _result * irandom_range(1, 5);
        _mission_string += $"As a diplomatic mission the duration of the stay was a success with our political position with the planet being enhanced greatly (disposition +{_effect})";
    }

    p_data.add_disposition(_effect);
    var _tester = global.character_tester;
    var _widom_test = _tester.standard_test(_leader, "wisdom", 0, ["siege"]);

    if (_widom_test[0]) {
        p_data.alter_fortification(1);
        _mission_string += $"while stationed {_leader.name_role()} makes several notable observations and is able to instruct the planets defense core leaving the world better defended (fortifications+1).";
    }
    //TODO just generally apply this each turn with a garrison to see if a cult is found
    if (p_data.has_feature(eP_FEATURES.GENE_STEALER_CULT)) {
        var _cult = p_data.get_features(eP_FEATURES.GENE_STEALER_CULT)[0];
        if (_cult.hiding) {
            _widom_test = _tester.standard_test(_leader, "wisdom", 0, ["tyranids"]);
            if (_widom_test[0]) {
                _cult.hiding = false;
                _mission_string += "Most alarmingly signs of a Genestealer cult are noted by the garrison. how far the rot has gone will now need to be investigated and the xenos taint purged.";
            }
        }
    }
    scr_popup($"Agreed Garrison of {p_data.name()} complete", _mission_string, "", "");
}

static __protect_raiders_init = function(){
    stage_id = "preliminary";
    data.applicant = "Governor";
}

static __protect_raiders_feature_selected =  function() {
    draw_data.mission_description = $"The governor of {p_data.name()} has sent many requests to the sector commander for help with defending against xenos raids on the populace of the planet, the reports seem to suggest the xenos in question are in fact dark eldar.";
    draw_data.help = "Set a squads to ambush";
    draw_data.button_text = "Send Squad";
    draw_data.button_tooltip = "mileage may vary on playability of this mission progress at your own risk";
    draw_data.button_function = method(self, function() {
        var _dudes = collect_role_group("all", system.name);
        select_squads(_dudes, "Select Squad for Ambush", 1)
    }); 
}

static __protect_raiders_battle_aftermath = function() {
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

static __protect_raiders_suppress_information= function() {
    obj_popup.title = "Captains Disgruntled";
    __add_option("continue");
    var _caps = scr_role_count(eROLE.CAPTAIN ,"", "units");
    var _worst = -1;
    var _worst_hit = -1;
    for (var i = 0; i < array_length(_caps); i++) {
        if (irandom(2)) {
            continue;
        }
        var _cap = _caps[i];
        var _loyalty_hit = irandom(6);
        if (_loyalty_hit > _worst_hit) {
            _worst_hit = _loyalty_hit;
            _worst = i;
        }
    }
    if (_worst == -1) {
        obj_popup.text = $"You are able to convince your captains of the strategic need to cover up the incidence, various excuses are made and fake logs that cover up the disaster of the mission";
    } else {
        obj_popup.text = $"Not all of your captains are convinced of the need to use deceit and a none have breached the order but it has soured your relations with a few namely {_caps[_worst].name_role()}";
    }
}

static __protect_raiders_hold_memorial = function() {
    reset_popup_options();
    __add_option("continue");
    p_data.add_disposition(-30);
    obj_popup.text = $"You prepare to have a large public memorial for your fallen marines on the planet surface as a show of defiance. The chapter are pleased by such an act and the population of the planet are mesmerized by the spectacle. The governor is furious not only has his incompetence to deal with the planets xenos issue been made public in such a way that the sector commander has now heard about it but he perceives his failures are being paraded in font of him\n nGovernor Disposition : -30";
}


static __protect_raiders_squad_selected = function() {
    data.squad = data.squads[0];
    var _squad = data.squad;
    var _squad_units = _squad.get_members();
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

            _gar_pop.replace_options([
                __create_popup_option("Suppress the Information", "suppress_information"),
                __create_popup_option("Hold a Memorial", "hold_memorial"),
            ]);
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
                            number : 20,
                            special : "shimmershield"
                        },
                        {
                            name : "Dire Avenger Exarch",
                            number : 2,
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

static __inquisition_tomb_init = function(){
    var _text = $"The Inquisition is trusting you with a special mission.  They have reason to suspect the Necron Tomb on planet {p_data.name()}";
    _text += $" may become active.  You are to send a small group of marines to plant a bomb deep inside, within {timer} months.  Can your chapter handle this mission?";
    var _pop_data = {
        options: __inquisition_mission_options(),
    };
    _pop_data.mission = self;
    scr_popup("Inquisition Mission", _text, "inquisition", _pop_data);
}

static __inquisition_tomb_accept = function(){
    var _text = $"Inquisition Mission Accepted: A bomb must be planted within the Necron Tomb on {p_data.name()} within {timer} months.";
    scr_event_log("", _text, system.name);
}

static __inquisition_tomb_per_turn = function() {
    if (p_data.player_forces <= 0){
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
    _tixt = $"Your marines on {p_data.name()}";
    _tixt += " are prepared and ready to enter the Necron Tombs.  A Plasma Bomb is in tow.";
    var _number = instance_exists(obj_turn_end) ? 1 : 0;
    var _pop_data = {
        loc: system.name,
        planet: planet,
        number: _number,
    };
    _pop_data.mission = self;
    _pop_data.options = [
        __create_popup_option("Begin the Mission", "mission_start"),
        __create_popup_option("Not Yet"),
    ];
    scr_popup("Necron Tomb Excursion", _tixt, $"necron_cave", _pop_data);
}

static __inquisition_tomb_mission_start = function() {
    obj_popup.title = $"Necron Tunnels : {data.mission_stage}";
    obj_popup.replace_options([
        __create_popup_option("Continue", "mission_sequence"),
        __create_popup_option("Return to the surface"),
    ]);
    obj_popup.image = "necron_tunnels_1";
    obj_popup.text = "Your marines enter the massive tunnel complex, following the energy readings.  At first the walls are cramped and tiny, closing about them, but the tunnels widen at a rapid pace.";
}

/// @self Asset.GMObject.obj_popup
/// @desc Advances the Necron Tomb mission or starts a combat encounter.
/// @returns {Undefined}
static inquisition_tomb_mission_sequence = function() {
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
        advance_inquisition_tomb_mission();
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
            break;
            case 2:
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
            data.enemy = "spyder";
            break;            
            case 3:
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
            data.enemy = "stalker";
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

static __inquisition_tomb_battle_aftermath = function(){
    if (!data.tomb_awakens) {
        if (defeat == 1) {
            obj_controller.combat = 0;
            obj_controller.cooldown = 10;
            obj_turn_end.alarm[1] = 4;
        } else if (defeat == 0) {
            obj_controller.combat = 0;
            var pip = instance_create(0, 0, obj_popup);
            inquisition_tomb_mission_start();
            var _completed = advance_inquisition_tomb_mission();
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

static advance_inquisition_tomb_mission = function() {
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
        __refresh_data();

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

static __inquisition_tomb_resolve = function() {
    delete_mission = true;
    alter_disposition(eFACTION.INQUISITION, -8);
    var _alert_text = $"The Necron Tomb of planet {p_data.name()} has not been deactivated in time.  It has awakened, rank upon rank of Necrons pouring out to the planet's surface.  The Inquisition is not pleased with your failure.";
    scr_popup("Inquisition Mission Failed", _alert_text, "necron_army", "");
    scr_event_log("red", $"Inquisition Mission Failed: Bombing run failed; the Necron Tomb on {p_data.name()} has become active.");

    p_data.add_forces(eFACTION.NECRONS, 4);
    if (awake_tomb_world(p_data.features) == 0) {
        awaken_tomb_world(p_data.features);
    }
}

static __inquisition_demon_world_init = function(){
    var _text = $"The Inquisitor is trusting you with a special mission.  The planet {p_data.name()} has been uncovered as a Demon World";
    if (obj_controller.demanding) {
        _text = $"The Inquisition demands that your Chapter demonstrate its loyalty to the Imperium of Mankind and the Emperor.  An out of control Demon World {p_data.name()} must be cleansed within {timer} months.";
    }
    _text += $"The taint of chaos must be eradicated from this system.  Can your chapter handle this mission?";
    var _pop_data = {
        options: __inquisition_mission_options(),
    };
    _pop_data.mission = self;
    scr_popup(
        "Inquisition Mission Demon World", 
        _text, 
        "inquisition", 
        _pop_data
    );
}

static __inquisition_demon_world_accept = function(){
    scr_event_log("", $"Inquisition Mission Accepted: The demon world of {p_data.name()} will be purged by your hand.", system.name);
    new_star_event_marker("green");
    with(obj_popup){
        popup_default_close();
    }
}

static __inquisition_tyranid_org_init = function(){
    var _pop_data = {
        options: __inquisition_mission_options(),
    };
    _pop_data.mission = self;
    var _text = $"An Inquisitor is trusting you with a special mission.  The planet {p_data.name()}";
    _text += " is ripe with Tyranid organisms.  They require that you capture one of the Gaunt species for research purposes.  Can your chapter handle this mission?";
    if (obj_controller.demanding) {
        _text = $"The Inquisition demands that your Chapter demonstrate its loyalty to the Imperium of Mankind and the Emperor.  {global.chapter_name} are to capture a Gaunt organism and return it, unharmed- 4x Webbers have been provided for this purpose.";
    }
    scr_popup("Inquisition Mission", _text, "inquisition",_pop_data);
}

static __inquisition_tyranid_org_accept = function(){
    obj_popup.image = "webber";
    obj_popup.title = "New Equipment";
    obj_popup.text = $"{global.chapter_name} have been provided with 4x Astartes Webbers in order to complete the mission.";
    reset_popup_options();
    scr_add_item("Webber", 4);
    obj_controller.cooldown = 10;
    scr_event_log("", $"Inquisition Mission Accepted: The Inquisition wishes for the capture of a particular strain Gaunt noticed on {p_data.name()} is advisable.", system.name);
    obj_controller.useful_info += "Tyr|";
    data.captured_gaunt = 0;
}

static __inquisition_tyranid_org_setup_battle = function(){
    if ((obj_ncombat.enemy != eFACTION.TYRANIDS) || (obj_ncombat.battle_object.space_hulk)) {
        exit;
    }
    obj_ncombat.battle_special = p_id;
    obj_ncombat.reduce_fortification = false;
    obj_ncombat.reduce_power = false;
}

static __inquisition_tyranid_org_on_enemy_casulties = function(){
    var _c_data = casualty_packet;
    if (array_contains(["Termagaunt", "Hormagaunt"], _c_data.weapon) && (_c_data.casulties > 0)) {
        data.captured_gaunt += _c_data.casulties;
    }
}

static __inquisition_tyranid_org_battle_final_message = function(){
    if (obj_ncombat.defeat || data.captured_gaunt == 0) {
        exit;
    }
    var _gaunts = string_plural_count("Gaunt organism", data.captured_gaunt);
    var _newline = $"{_gaunts} have been captured.";
    obj_ncombat.combat_log.push(_newline, eMSG_COLOR.YELLOW);

}

static __inquisition_tyranid_org_battle_aftermath = function(){
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

static __hive_fleet_to_cult_init = function(){
    var _x1 = (random_range(room_width * 1.25, room_width * 2) * choose(-1, 1)) + system.x;
    var _y1 = (random_range(room_height * 1.25, room_height * 2) * choose(-1, 1)) + system.y;
    var _fleet = create_enemy_fleet(_x1, _y1, eFACTION.TYRANIDS);
    _fleet.sprite_index = spr_fleet_tyranid;
    _fleet.image_speed = 0;

    _fleet.capital_number = choose(7, 8, 9);
    _fleet.frigate_number = round(random_range(6, 12));
    _fleet.escort_number = round(random_range(12, 27));

    _fleet.image_index = standard_fleet_strength_calc(_fleet);
    _fleet.image_alpha = 0;

    _fleet.action_x = system.x;
    _fleet.action_y = system.y;

    _fleet.action_eta = timer;
    _fleet.action = "move";
}

static __hive_fleet_to_cult_per_turn = function(){
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
            if (_unit.has_role(eROLE.CHAPTERMASTER)) {
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

static __inquisition_purge_init = function(){
    var _text = "The Inquisition is trusting you with a special mission.";
    if (data.mission_flavour == 1) {
        _text += $"  A number of high-ranking nobility on the {p_data.name()} are being difficult and harboring heretical thoughts.  They are to be selectively purged within {timer} months.  Can your chapter handle this mission?";
    } else if (data.mission_flavour == 2) {
        _text += $"  A powerful crime-lord on the {p_data.name()} is gaining an unacceptable amount of power and disrupting daily operations.  They are to be selectively purged within {timer} months.  Can your chapter handle this mission?";
    } else if (data.mission_flavour == 3) {
        _text += $"  The mutants of hive world {p_data.name()} are growing in numbers and ferocity, rising sporadically from the underhive.  They are to be cleansed by promethium within {timer} months.  Can your chapter handle this mission?";
    }
    var _pop_data = {
        options: __inquisition_mission_options(),
    };
    _pop_data.mission = self;
    scr_popup("Inquisition Mission", _text, "inquisition", _pop_data);
}

static __inquisition_purge_accept = function(){
    var _text = "Inquisition Mission Accepted:"
    if (data.purge_type == eDROP_TYPE.PURGEFIRE){
        _text += $" The mutants beneath {p_data.name()} must be cleansed by fire within {timer} months.";
    } else {
        _text += $" The nobles of {p_data.name()} must be selectively purged within {timer} months."
    }
    scr_event_log("", _text, system.name);
}

static __inquisition_purge_on_purge = function(){
    switch (purge_data.action_type){
        case eDROP_TYPE.PURGESELECTIVE:
            delete_mission = true;

            alter_disposition(eFACTION.INQUISITION, obj_controller.demanding ? choose(0, 0, 1) : 1);

            var _popup_text = "Your marines drop fast and hard, blowing through guards and mercenaries with minimal resistance.  Before ten minutes have passed all your targets are executed.";
            scr_event_log("", $"Inquisition Mission Completed: The unruly Nobles of {p_data.name()} have been purged.");
            p_data.add_disposition(choose(1, 2, 3));  
            scr_popup("Inquisition Mission Completed", _popup_text, "inquisition");      
            break;
        case eDROP_TYPE.PURGEFIRE:
            delete_mission = true;

            alter_disposition(eFACTION.INQUISITION, obj_controller.demanding ? choose(0, 0, 1) : 1);

            var _popup_text = $"Your marines scour the under-hive of {p_data.name()}, spraying mutants down with promethium as they go.  It takes several days but a sizeable dent is put in their numbers.";
            scr_event_log("", $"Inquisition Mission Completed: The mutants of {p_data.name()} have been cleansed by promethium.");
            p_data.add_disposition(choose(1, 2, 3));
            scr_popup("Inquisition Mission Completed", _popup_text, "inquisition"); 
            break;     
    }
}

static __join_communion_init = function(){
    stage_id =  "preliminary";
    data.applicant = "Governor";
}
static __join_communion_feature_selected = function(){
    draw_data.mission_description = $"The governor of {p_data.name()} has Invited a delegate of your forces to take part in ceremony.";
    draw_data.help  = "This mission is not yet completed"
}

static __governor_purge_enemies_init = function(){
    if (system.planets < 2){
        delete_mission = true;
        exit;
    }
    var _planet = planet;
    var _enemy = 0;
    with (system){
        for (var i = 1; i <= planets; i++) {
            if (i == _planet) {
                continue;
            }
            if (p_owner[i] == eFACTION.IMPERIUM) {
                _enemy = i;
                break;
            }
        }
    }
    if (_enemy == 0){
        delete_mission = true;
        exit;        
    }
    data.target = _enemy;
    stage_id = "preliminary";
    data.applicant = "Governor";
}

static __governor_purge_enemies_feature_selected = function(){
    draw_data.mission_description = $"The governor of {p_data.name()} has expressed his distaste of the neighbouring governance of {system.name} {data.target} he has expressed his views that they engage in heretical ways and harbor xenos enemies though in truth it is more likely that he simply wishes his political enemies disposed of, whatever the case his planet has great economic means and he has made bare his plans to compensate the emperors angels for their aid";
    draw_data.help = "This mission is not yet complete";
}

static __chaos_lord_meeting_per_turn = function(){
    if (p_data.player_forces <= 0){
        exit;
    };

    var _units = p_data.collect_planet_group();

    var _master_present = _units.has_role(eROLE.CHAPTERMASTER);
    var _force_size = _units.number();
    if (_force_size == 0){
        system.p_player[planet] = 0;
        exit;
    }
    members = _units.units;

    var _pop_data = {
        mission : self,
    }
    // title / text / image / speshul
    var _popup_text = "A cloaked, ragged figure approaches your forces and hails you. ";
    if (_master_present && (_force_size <= 21)) {
        _popup_text += "He is to bring you to meet with their master and you have few enough forces to be permitted.  What is thy will?"
        var _options = [
            __create_popup_option("Die, heretic!", "kill_messenger"),
            __create_popup_option("Very well.  Lead the way.", "attend_meeting"),
            "I must take care of an urgent matter first.  (Exit)",
        ]
    }
    if (_master_present && (_force_size > 21)) {
        _popup_text += $"He is to bring you to their master, but before the meeting proceeds, you must bring fewer forces.  Only yourself and up to two squads will be allowed in the presence of {obj_controller.faction_title[10]} {obj_controller.faction_leader[10]}."
    }
    if (!_master_present && (_force_size > 21)) {
        _popup_text += "The meeting was supposed to be with the Chaos Lord, and yourself, but you are not planet-side.  Land on the planet with up to two squads and the meeting will proceed."
    }
    scr_popup("Chaos Meeting", _popup_text, "chaos_messenger", _pop_data);
}

static __chaos_lord_meeting_kill_messenger = function(){
    delete_mission = true;
    alter_disposition(eFACTION.CHAOS, -10);
    obj_popup.text = "The heretic is killed in a most violent fashion.  With a lack of go-between the meeting cannot proceed.";
    reset_popup_options();
    if (obj_controller.blood_debt == 1) {
        obj_controller.penitent_current += 1;
        obj_controller.penitent_turn = 0;
        obj_controller.penitent_turnly = 0;
    }
    exit;    
}

static __chaos_lord_meeting_attend_meeting = function(){
    var _text = $"{global.chapter_name} signal your readiness to the heretic.  Nearly twenty minutes of following the man passes before {global.chapter_name} all enter an ordinary-looking structure.  Down, within the basement, {global.chapter_name} then pass into the entrance of a tunnel.  As the trek downward continues more and more heretics appear- cultists, renegades that appear to be from the local garrison, and occasionally even the fallen of your kind.  Overall the heretics seem well supplied and equip.  This observation is interrupted as your group enters into a larger chamber, revealing a network of tunnels and what appears to be ancient catacombs.  Bones of the ancient dead, the forgotten, litter the walls and floor.  And the chamber seems to open up wider, and wider, until {global.chapter_name} find yourself within a hall.  Within this hall, waiting for {global.chapter_name}"
     if (!data.trap) {
        obj_controller.complex_event = true;
        obj_controller.current_eventing = "chaos_meeting_1";
        obj_popup.text = $" are several dozen Chaos Terminators, a Greater Daemon of Tzeentch and Slaanesh, and Chaos Lord {obj_controller.faction_leader[eFACTION.CHAOS]}.";
        scr_toggle_diplomacy();
        obj_controller.diplomacy = 10;
        obj_controller.cooldown = 5000;
        with (obj_controller) {
            scr_dialogue("cs_meeting1");
        }
        instance_destroy(obj_popup);
        exit;
    } else {
        delete_mission = true;
        obj_controller.complex_event = true;
        obj_controller.current_eventing = "chaos_trap";
        obj_popup.text = $" are several dozen Chaos Terminators, a handful of Helbrute, and many more Chaos Space Marines.  The Chaos Lord is nowhere to be seen.  It is a trap.";
        reset_popup_options();

        var _battle = new_battle(eFACTION.CHAOS , "cs_meeting_battle10");
        _battle.dropping = 0;
        _battle.attacking = 1;
        _battle.local_forces = 0;
        _battle.threat = 3;
        _battle.battle_enemy_data = {
            threat : 3,
            fortified : false,
            cols : [
                {
                    distance : 20,
                    enemies : [
                        {
                            name : "Greater Daemon of Tzeentch",
                            number : 1
                        },
                        {
                            name : "Greater Daemon of Slaanesh",
                            number : 1
                        },
                        {
                            name : "Venerable Chaos Terminator",
                            number : 20
                        }
                    ]
                },
                {
                    distance : 10,
                    enemies : [
                        {
                            name : "Venerable Chaos Chosen",
                            number : 40,
                        },
                        {
                            name : "Helbrute",
                            number : 3
                        },
                    ]
                }
            ]
        };
        _roster = new Roster();
        _roster.selected_units = members;
        _roster.setup_battle_formations();
        _roster.add_to_battle();

        obj_controller.useful_info += "CHTRP|";
        instance_deactivate_object(obj_star);
        instance_destroy(obj_popup);
        exit;
    }   
}

static __chaos_lord_meeting_battle_aftermath = function(){
    if (defeat){
        exit;
    }
    obj_controller.diplomacy = 0;
    obj_controller.menu = 0;
    obj_controller.force_goodbye = 0;
    obj_controller.cooldown = 20;
    obj_controller.current_eventing = "chaos_meeting_end";
    if (instance_exists(obj_turn_end)) {
        obj_turn_end.combating = 0;
    }
    var pip = instance_create(0, 0, obj_popup);
    pip.title = "Survived";
    pip.text = "You and the rest of your battle brothers fight your way out of the catacombs, back through the tunnel where you first entered.  By the time you manage it your forces are battered and bloodied and in desperate need of pickup.  The whole meeting was a bust- Chaos Lord " + string(obj_controller.faction_leader[eFACTION.CHAOS]) + " clearly intended to kill you and simply be done with it.";
}
}


