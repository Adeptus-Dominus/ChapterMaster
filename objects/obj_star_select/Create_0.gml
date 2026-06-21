owner = 0;
target = instance_nearest(x, y, obj_star);
loading = 0;
loading_name = "";
alarm[0] = 1;
debug = 0;
guard = 0;
pdf = 0;
fortification = 0;
corruption = 0;
ork = 0;
tau = 0;
chaos = 0;
p_data = new PlanetData(0, target);
has_player_forces = array_sum(target.p_player) > 0;

manage_units_button = new UnitButtonObject({x1: 115, y1: 200, style: "pixel", label: "Manage Units"});

//if (global.cheat_debug){
debug_button = new UnitButtonObject({x1: 36, y1: 185, style: "pixel", label: "Debug"});

debug_options = new RadioSet([{str1: "Edit Forces"}, {str1: "Add Problem"}, {str1: "Add Feature"}], "Debug options", {x1: 36, y1: 129, max_width: 300});

debug_slate = new DataSlate({style: "plain", XX: 36, YY: 100, set_width: true, width: 310, height: 900});
//}

torpedo = scr_item_count("Cyclonic Torpedo");

/// @type {Struct.FeatureSelected}
feature = "";
garrison = "";
population = false;

garrison_data_slate = new DataSlate();
garrison_data_slate.title = "Garrison Report";
main_data_slate = new DataSlate();

potential_donors = [];

colonist_button = new PurchaseButton(1000);
colonist_button.update({tooltip: "Planets with higher populations can provide more recruits both for your chapter and to keep a planets PDF bolstered, however colonists from other planets bring with them their home planets influences and evils /n REQ : 1000", label: "Request Colonists", target: target});
colonist_button.bind_method = function() {
    var doner = array_random_element(obj_star_select.potential_donors);
    new_colony_fleet(doner[0], doner[1], target.id, obj_controller.selecting_planet, "bolster_population");
};

// Recruit Guard: raise Imperial Guard from this world's Defense Force (PDF) in fixed
// elements of 1000, so it cannot be spammed off civilians and is bounded by the PDF on
// hand. Costs a small 50 requisition per 1000. Recruited Guard go into the deployable
// pool (p_guardsmen) to embark and deploy.
guard_recruit_button = new PurchaseButton(50);
guard_recruit_button.update({tooltip: "Raise 1000 Imperial Guard from this world's Defense Force (PDF). They join the deployable Guard pool, ready to embark and deploy. Drawn in fixed elements of 1000. /n Costs 50 requisition, requires at least 1000 PDF", label: "Recruit Guard", target: target});
guard_recruit_button.bind_method = function() {
    var _p = obj_controller.selecting_planet;
    if (target.p_pdf[_p] >= 1000) {
        target.p_pdf[_p] -= 1000;
        target.p_guardsmen[_p] += 1000;
    }
};

// Levy Guardsmen: raise 100 deployable Guardsmen as actual units (not the abstract PDF
// pool). They muster on this world, stationed off-ship, so the deploy roster's Guardsmen
// filter can bring them into a battle here, or they can be embarked onto ships and taken
// on the offensive. Costs 10 requisition. Uses the batch spawn path (one sort at the end)
// so raising 100 at once stays fast.
guardsmen_levy_button = new PurchaseButton(10);
guardsmen_levy_button.update({tooltip: "Levy 100 Guardsmen from this world as deployable troops. They muster here, ready to be brought into battle or embarked onto your ships. /n Costs 10 requisition", label: "Levy Guardsmen", target: target});
guardsmen_levy_button.bind_method = function() {
    var _star = target.name;
    var _planet = obj_controller.selecting_planet;
    repeat (100) {
        var _u = scr_add_man("Guardsman", 0, "", "", 0, true, "home_planet", {skip_company_order: true});
        if (is_struct(_u)) {
            _u.location_string = _star;
            _u.planet_location = _planet;
            _u.ship_location = -1;
        }
    }
    with (obj_ini) {
        scr_company_order(0);
    }
};

recruiting_button = new PurchaseButton(0);
recruiting_button.update({tooltip: "Enable recruiting", label: "Recruiting", target: target});
recruiting_button.bind_method = function() {
    if (!p_data.has_feature(eP_FEATURES.RECRUITING_WORLD)) {
        p_data.add_feature(eP_FEATURES.RECRUITING_WORLD);
        obj_controller.recruiting_worlds += $"{planet_numeral_name(obj_controller.selecting_planet, target)}|";
    } else {
        delete_features(target.p_feature[obj_controller.selecting_planet], eP_FEATURES.RECRUITING_WORLD);
        obj_controller.recruiting_worlds = string_replace(obj_controller.recruiting_worlds, string(target.name) + " " + scr_roman(obj_controller.selecting_planet) + "|", "");
    }
};

recruitment_type_button = new PurchaseButton(0);
recruitment_type_button.update({tooltip: "Change recruitment type", label: "Recruitment Type", target: target});
recruitment_type_button.bind_method = function() {
    var _recruit_world = p_data.get_features(eP_FEATURES.RECRUITING_WORLD)[0];
    if (_recruit_world.recruit_type < 1) {
        _recruit_world.recruit_type++;
    } else {
        _recruit_world.recruit_type--;
    }
};

recruitment_costdown_button = new PurchaseButton(0);
recruitment_costdown_button.update({tooltip: "Deaccelerate recruitment", label: "RQD", target: target});
recruitment_costdown_button.bind_method = function() {
    var _recruit_world = p_data.get_features(eP_FEATURES.RECRUITING_WORLD)[0];
    _recruit_world.recruit_cost--;
};

recruitment_costup_button = new PurchaseButton(0);
recruitment_costup_button.update({tooltip: "Accelerate recruitment with req", label: "RQU", target: target});
recruitment_costup_button.bind_method = function() {
    var _recruit_world = p_data.get_features(eP_FEATURES.RECRUITING_WORLD)[0];
    _recruit_world.recruit_cost++;
};

buttons_selected = false;
button1 = "";
button2 = "";
button3 = "";
button4 = "";
button5 = "";
button_manager = new UnitButtonObject();
shutter_1 = new ShutterButton();
shutter_2 = new ShutterButton();
shutter_3 = new ShutterButton();
shutter_4 = new ShutterButton();
shutter_5 = new ShutterButton();
attack = 0;
raid = 0;
bombard = 0;
purge = 0;

player_fleet = 0;
imperial_fleet = 0;
mechanicus_fleet = 0;
inquisitor_fleet = 0;
eldar_fleet = 0;
ork_fleet = 0;
tau_fleet = 0;
tyranid_fleet = 0;
heretic_fleet = 0;

en_fleet[0] = 0;
var i;
i = -1;
repeat (15) {
    i += 1;
    en_fleet[i] = 0;
}

if (obj_controller.menu == 0) {
    alarm[1] = 1;
}
