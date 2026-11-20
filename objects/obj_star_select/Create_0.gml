owner = 0;
/// @type {Id.Instance.obj_star}
target = instance_nearest(x, y, obj_star);
loading = 0;
loading_name = "";
mission = "";
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
], localize("Debug options"), {
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
/// @type {String|Struct.GarrisonForce}
garrison = "";
population = false;

garrison_data_slate = new DataSlate();
garrison_data_slate.title = localize("Garrison Report");
main_data_slate = new DataSlate();

potential_donors = [];

colonist_button = new PurchaseButton(1000);
colonist_button.update({tooltip: "Planets with higher populations can provide more recruits both for your chapter and to keep a planets PDF bolstered, however colonists from other planets bring with them their home planets influences and evils \nREQ : 1000", label: "Request Colonists", target: target});
colonist_button.bind_method = function() {
    var doner = array_random_element(obj_star_select.potential_donors);
    new_colony_fleet(doner[0], doner[1], target.id, obj_controller.selecting_planet, "bolster_population");
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

planet_psionic_rating = new ReactiveString("");

buttons_selected = false;
buttons = [];
shutters = [];
button_manager = new UnitButtonObject();
attack = 0;
raid = 0;
bombard = 0;
purge = 0;

player_fleet = target.has_orbiting_player_fleet();

fleet_engage_buttons = [];
create_fleet_engage_buttons = function() {
    fleet_engage_buttons = [];
    var _fleets = get_all_orbiting_fleets(target);
    for (var i = 0; i < array_length(_fleets); i++) {
        var _fleet = _fleets[i];
        var _sprite = scr_img_sprite("ui/force", _fleet.owner);
        array_push(fleet_engage_buttons, new SpriteButton({
            sprite: _sprite,
            scale_x: 32 / sprite_get_width(_sprite),
            scale_y: 32 / sprite_get_height(_sprite),
            x1: 33 + 64 * i,
            y1: 425,
            tooltip_text: $"Engage {obj_controller.faction[_fleet.owner]} Fleet",
            fleet: _fleet,
        }));
    }
};

if (player_fleet && obj_controller.menu == eMENU.DEFAULT) {
    create_fleet_engage_buttons();
}
