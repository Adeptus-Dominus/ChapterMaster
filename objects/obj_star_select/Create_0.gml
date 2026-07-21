owner = 0;
target = instance_nearest(x, y, obj_star);
// Remember the last system the player opened: the cheat console can't be open at
// the same time as this screen, so planet-targeting cheats act on this instead.
obj_controller.last_selected_star = target;
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

manage_units_button = new UnitButtonObject({
    x1: 115,
    y1: 200,
    style: "pixel",
    label: "Manage Units",
});

debug_button = new UnitButtonObject({
    x1: 36,
    y1: 185,
    style: "pixel",
    label: "Debug",
});

debug_options = new RadioSet([
    {
        str1: "Edit Forces",
    },
    {
        str1: "Add Problem",
    },
    {
        str1: "Add Feature",
    },
], "Debug options", {
    x1: 36,
    y1: 129,
    max_width: 300,
});

debug_slate = new DataSlate({
    style: "plain",
    XX: 36,
    YY: 100,
    set_width: true,
    width: 310,
    height: 900,
});

torpedo = scr_item_count("Cyclonic Torpedo");

/// @type {Struct.FeatureSelected}
feature = "";
garrison = "";
population = false;
// Tracks which planet the right-column view was last set up for, so a freshly-selected
// multi-region planet defaults to its Planetary Regions panel (see Draw_64).
region_view_planet = -1;

// Garrison drill-down menu (Sector Governor): clicking a region's garrison figure opens a
// force-composition panel beside the regions list. region_force_view is the region index whose
// breakdown is shown; both reset when the selected planet changes (see Draw_64).
region_force_open = false;
region_force_view = -1;
// When >= 0, the force panel shows this faction's planet-wide roster (opened from a Planetary
// Presence entry), overriding the region/planet view. -1 = not in faction mode.
region_force_faction = -1;
region_force_player = false; // when true, the drill-down shows the PLAYER's own force in region_force_view

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

// Recruit Guard: levy Imperial Guard from a world's Planetary Defense Force. Player
// worlds only (you can only mobilise your own PDF), drawn in fixed elements of 1000 and
// bounded by the PDF on hand so it cannot be spammed. Costs 50 requisition per 1000.
// Each PDF trooper raised joins the chapter as an individual Guardsman unit mustering at
// the home planet, the same singular Guardsmen the Sector Governor supplies. Guardsmen
// only: no Sergeants, Heavy Weapons Teams or vehicles.
guard_recruit_button = new PurchaseButton(50);
guard_recruit_button.update({tooltip: "Draw 200 Astra Militarum from this world's Guardsmen pool. Each joins your chapter as an individual Guardsman, mustering at your home planet. Drawn in fixed elements of 200. /n Costs 50 requisition. Requires a Guard Barracks on this world (which raises the Guardsmen pool) and at least 200 Guardsmen available.", label: "Recruit Guard", target: target});
guard_recruit_button.bind_method = function() {
    var _p = obj_controller.selecting_planet;
    // Draw from the world's Guardsmen POOL (p_guardsmen), the same pool the Guard
    // Barracks fills, not the PDF. Fixed element of 200 per click for 50 req.
    if (target.p_owner[_p] == eFACTION.PLAYER
    && (region_planet_building_count(target, _p, "guard_barracks") > 0)
    && target.p_guardsmen[_p] >= 200) {
        target.p_guardsmen[_p] -= 200;
        with (obj_controller) {
            repeat (200) {
                scr_add_man("Guardsman", 0, "", "", 0, true, "home_planet", {skip_company_order: true});
            }
        }
    }
};

// Construction License: buys build rights on the FOCUSED outlying region (population
// screen). The bind_method only stamps the flag when the region is licensable, so a
// wasted 500 can never mark nothing. The draw-time allow_click gate below mirrors
// region_can_license so the button greys out on the capital / owned / already-licensed.
build_license_button = new PurchaseButton(REGION_BUILD_LICENSE_COST);
build_license_button.update({tooltip: $"Petition the Sector Governor for permission to build on ONE region of this world before you conquer it. Licenses the currently-selected outlying region (pick it in the regions panel). The full building set unlocks there at the usual price. /n Costs {REGION_BUILD_LICENSE_COST} requisition. Cannot license the capital or a region you already hold.", label: "Buy Build License", target: target});
build_license_button.bind_method = function() {
    var _p = obj_controller.selecting_planet;
    var _focus = region_focus_get(target, _p);
    region_grant_license(target, _p, _focus);
};

recall_forces_button = new PurchaseButton(0);
recall_forces_button.update({tooltip: "Recall your forces holding a foothold on this world back to orbit, re-embarking each onto the same ship it landed from. Any unit whose ship is gone or full is left on the surface and reported.", label: "Recall Forces", target: target});
recall_forces_button.bind_method = function() {
    var _res = recall_forces_at_world(target);
    var _msg = $"Recalled {_res.recalled} unit(s) to orbit.";
    if (_res.stranded > 0) {
        _msg += $" {_res.stranded} unit(s) had no ship with room at this world and remain on the surface.";
    }
    scr_popup("Recall Forces", _msg, "");
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
// Upstream initialises the action-button array here (their buttons[] refactor);
// this line was lost in the sync5 merge, so obj_p_fleet/obj_en_fleet Draw read an
// unset variable on fresh games and crashed instantly. The Draw_64 branches fill
// it; it must always exist.
buttons = [];
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

en_fleet = array_create(15, 0);

if (obj_controller.menu == eMENU.DEFAULT) {
    alarm[1] = 1;
}
