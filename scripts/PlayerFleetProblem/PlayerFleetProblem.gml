//All missions that run on a fleet need their own FleetProblem instance
//missions for the most part can only run from predefined points in the code
// to run from each of these points each mission must have a registered function these functions are then called implicitly
//each function follows the format  `__<p_id>_<entry_flag>`
/* the current entry points for the code are
    "per_turn" - runs every end turn to check for certain conditions often contains reactions to actions player has done last turn
        - runs via basic_turn_end

    "init" - runs immediately after problem is created often used to populate initial popup or stack popup for turn end

    "on_arrival" - runs when the fleet arrives at a star, fleet_event_data holds {star}
    "on_load" - runs when units are loaded onto the fleet, fleet_event_data holds {units}
    "on_unload" - runs when units are unloaded from the fleet, fleet_event_data holds {units}
    "on_split" - runs on the original fleet when it splits, fleet_event_data holds {new_fleet}
    "on_merge" - runs on the receiving fleet when another fleet merges into it, fleet_event_data holds {merged_fleet}
    "on_destruction" - runs when the fleet is destroyed, the mission is deleted after this function has run
        - must be triggered BEFORE the fleet instance is destroyed

    "mission_log_entry" - runs to provide a data row for the mission log

- other than these entry points and any other later defined positions mission specific code should not run outside of the FleetProblem container

- to set an entry point up simply register the function as a static e.g
    if i create static __example_per_turn once an "example" problem is registered on a fleet the per turn check will run
    no other code is required

other info
    - the owning fleet must have a `problems = []` array in its create event
    - entry points that receive extra information read it from fleet_event_data, which only exists for the duration of the call
    - set a mission for deletion by setting delete_mission = true; this will delete the mission after the current function
    has finished executing
    - functions prefixed with `__` are only accessible from within the FleetProblem's internal scope
*/

//ANYTIME an exception is caught on a entry point for a mission the mission is prematurely deleted this ensures the player is not unfairly penalised for errors

/// @param {string} _name
/// @param {Real} _timer
/// @param {struct} _data
/// @param {Id.Instance.obj_p_fleet} _fleet
function PlayerFleetProblem(_name, _timer = -1, _data ={}, _fleet = noone) : FleetProblem(_name, _timer, _data, _fleet) constructor{
fleet = _fleet;

per_turn_checks = true;

/// @param {array} units
static on_load = function(units){
    __trigger_with_event("on_load", {units});
}

/// @param {array} units
static on_unload = function(units){
    __trigger_with_event("on_unload", {units});
}

/// @param {Id.Instance.obj_p_fleet} new_fleet
static on_split = function(new_fleet){
    __trigger_with_event("on_split", {new_fleet});
}

/// @param {Id.Instance.obj_p_fleet} merged_fleet
static on_merge = function(merged_fleet){
    __trigger_with_event("on_merge", {merged_fleet});
}

__init();

static __great_crusade_init = function(){
    var _crusade_direction = point_direction(room_width / 2, room_height / 2, fleet.x, fleet.y);
    fleet.action_x = fleet.x + lengthdir_x(room_width / 2, _crusade_direction);
    fleet.action_y = fleet.y + lengthdir_y(room_height / 2, _crusade_direction);
    fleet.move(false, "move", irandom_range(24, 35), 36);
    stage_id = "travel_to_crusade";
    fleet.beyond_engagement = true;
}

static __great_crusade_on_arrival = function(){
	if (stage_id == "travel_to_crusade"){
        var _direction = point_direction(room_width / 2, room_height / 2, fleet.x, fleet.y);
        fleet.action_x = fleet.x + lengthdir_x(600, _direction);
        fleet.action_y = fleet.y + lengthdir_y(600, _direction);
        fleet.move(false, "move");
        stage_id = "crusading"
        fleet.beyond_engagement = true;
	} else if (stage_id == "crusading"){
        with (obj_star) {
            if (owner > 5) {
                instance_deactivate_object(id);
            }
            var enemies = false;
            for (var i = 6; i < 13; i++) {
                if (scr_orbiting_fleet(i) != noone) {
                    enemies = true;
                    break;
                }
            }
            if (enemies) {
                instance_deactivate_object(id);
            }
        }
        var _return_star = instance_nearest(fleet.x, fleet.y, obj_star);
        fleet.action_x = _return_star.x;
        fleet.action_y = _return_star.y;
        fleet.move(false, "move", irandom_range(24, 35), 36);
        instance_activate_object(obj_star);	
        fleet.beyond_engagement = true;	
        stage_id = "returning_home"
	} else if (stage_id == "returning_home"){
        __great_crusade_results();
        fleet.beyond_engagement = false;	
	}
}

static __great_crusade_status_description = function(){

}

static __great_crusade_results = function(){
   	var _apoth = 0, _death_determination = 0, _death_determination_2 = 0, _roll3 = 0, _type = "", _artifacts = 0;
    var _seed = 0;
    var _marines_lost = 0;
    var _heroics_strings = [];
    var _clean = [];

    //index 1: death_determine 1 //index 2: death_determine 2 /index 3: apoth_recovery
    //index 3 exp_gains irandom + static
    var death_sets = {
        normal: [
            80,
            90,
            40,
            [
                5,
                10,
            ],
        ],
        hard: [
            60,
            80,
            30,
            [
                20,
                20,
            ],
        ],
        brutal: [
            20,
            65,
            20,
            [
                40,
                20,
            ],
        ],
    };

    _death_determination = floor(random(100)) + 1;
    _roll3 = irandom(99) + 1;

    if (_death_determination <= 50) {
        _type = "normal";
        _artifacts = choose(0, 0, 0, 0, 0, 1);
    } else if (_death_determination > 50 && _death_determination <= 80) {
        _type = "hard";
        _artifacts = choose(0, 0, 1);
    } else if (_death_determination > 80) {
        _type = "brutal";
        _artifacts = choose(1, 2, 3);
    }

    var death_data = death_sets[$ _type];

    for (var co = 0; co <= obj_ini.companies; co++) {
        _clean[co] = 0;
    }
    var total_ship_id = array_concat(fleet.capital_num, fleet.frigate_num, fleet.escort_num);

    var _units = collect_role_group("all", ["", 0 , total_ship_id],false, {}, true);
    for (var i = 0; i < _units.number(); i++){
    	var _unit = _units.units[i];

        _death_determination = floor(random(100)) + 1;
        //specialist trait greatly reduces death risk
        //TODO figure out how to quantify and present these risks so the player knows to protect dudes with trait
        if (_unit.has_trait("very_hard_to_kill")) {
            _death_determination -= 20;
        }
        _death_determination_2 = _death_determination;
        _death_determination -= _unit.experience / 2;

        //more generalised trait bonus mainly linked to chapter advantage of same name
        if (_unit.has_trait("slow_and_purposeful")) {
            _death_determination -= 10;
        }

        var _dead = false;
        if (_death_determination > death_data[0] || _death_determination_2 > death_data[1]) {
            _dead = true;
            if (_unit.has_role(eROLE.CAPTAIN)) {
                if (irandom(20) < _unit.luck) {
                    _dead = false;
                } else {
                    if (irandom(100) < _unit.weapon_skill) {
                        var _heroic_deed = choose("holding a breach in imperial defences allowing allied forces to regroup,", "slaying the enemy leader in glorious combat, while victorious he ultimately succumbed to his wounds,", "leading an imortant boarding mission,");
                        //TODO figure out a blance in reward for captains or high ranking death on crusade
                        //adds dynamism as it creates reward for the potential loss of men and talent during crusades
                        //var consolations = ["ship", "req",""]
                        //var consolation_prize = irandom(2)
                        var heroic_death = $"{_unit.full_title()} died {_heroic_deed} {_unit.name()} dies a hero of the {global.chapter_name}";
                        array_push(_heroics_strings, heroic_death);
                    }
                }
            } else if (_unit.has_role(eROLE.ANCIENT) || _unit.has_role(eROLE.CHAPTERMASTER)) {
                _dead = false;
            }
        }
        if (_dead) {
            obj_ini.ship_carrying[_unit.ship_location] -= _unit.get_unit_size();
            if (_unit.IsSpecialist(SPECIALISTS_STANDARD, true)) {
                obj_controller.command--;
            } else {
                obj_controller.marines--;
            }

            _clean[co] = 1;
            _marines_lost++;
            _unit.kill(false, true);
        } else {
            if (_unit.IsSpecialist(SPECIALISTS_APOTHECARIES) && (_unit.gear() == "Narthecium")) {
                _apoth++;
            }
            _unit.add_exp(irandom(death_data[3][0]) + death_data[3][1]);

            if (irandom(99) == 1 && irandom(20) < _unit.luck) {
                var _heroic_deed = choose("still_standing", "lone_survivor", "beast_slayer");
                _unit.add_trait(_heroic_deed);
                array_push(_heroics_strings, string(global.trait_list[$ _heroic_deed].flavour_text, _unit.full_title()));
            }
        }
    }

    if (obj_ini.doomed == 0) {
        if (_apoth > 0) {
            _seed = min(_seed, _apoth * death_data[2]);
        }
        if (_apoth == 0) {
            _seed = floor(_seed * 0.2);
        }
        obj_controller.gene_seed += _seed;
    }

    with (obj_ini) {
        for (var _c = 0; _c <= obj_ini.companies; _c++) {
            scr_company_order(_c);
        }
    }

    if (_roll3 <= 10) {
        _artifacts += 1;
    }
    if (_artifacts > 0) {
        repeat (_artifacts) {
            if (obj_ini.fleet_type == ePLAYER_BASE.HOME_WORLD) {
                scr_add_artifact("random", "", 4, obj_ini.home_name, -1);
            }
            if (obj_ini.fleet_type != ePLAYER_BASE.HOME_WORLD) {
                scr_add_artifact("random", "", 4, obj_ini.ship[0], 0);
            }
        }
    }

    var tixt = "Your ships have returned from the Crusade.  ";
    if (_type == "normal") {
        tixt += "The combat was as could be expected- ";
    }
    else if (_type == "hard") {
        tixt += "The combat was fairly gruelling- ";
    }
    else if (_type == "brutal") {
        tixt += "The combat was absolutely brutal- your marines were the first into the fray, and as a result ";
    }

    tixt += $"{_marines_lost} of your battle brothers fell in combat.";

    var _apoth_role = obj_ini.player_role_data[eROLE.APOTHECARY].role;
    if (obj_ini.doomed == 0) {
        if ((_apoth > 0) && (_seed > 0)) {
            tixt += $"  The {_apoth} surviving {_apoth_role} were able to recover {_seed} Gene-Seed.";
        }
        if ((_apoth == 0) && (_seed > 0)) {
            tixt += $"  You had no able-bodied {_apoth_role}, or all of them perished in the Crusade.  Foreign Apothecaries were able to recover {_seed} of your Gene-Seed.";
        }
    }
    if (obj_ini.doomed == 1) {
        tixt += "  Due to fatal mutations in your marines none of the fallen Gene-Seed was recoverable.";
    }

    if (_artifacts > 0) {
        tixt += $"  {_artifacts} Artefacts were granted to your Chapter or looted.";
    }
    if ((_roll3 <= 10) && (_artifacts > 1)) {
        tixt += "  One of them were given as a bonus for exceptional valour.";
    }

    if (array_length(_heroics_strings) == 1) {
        tixt += " A heroic deed was recorded";
    } else if (array_length(_heroics_strings) > 1) {
        tixt += " Several deeds were recorded";
    }
    // title / text / image /
    scr_popup("Crusade Results", tixt, "crusade", "");
    for (var i = 0; i < array_length(_heroics_strings); i++) {
        scr_popup("Heroic Deed", _heroics_strings[i], "crusade", "");
    }

    delete_mission = true;
    fleet.action = "";
}
}







