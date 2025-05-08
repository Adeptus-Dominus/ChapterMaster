function UnitProfile(_name) constructor {
    name = _name;
    display_name = "";
    armour = 0;
    health_points = 0;
    resistance = 1;
    weapons = [];
    unit_type = 0;
    size = 0;
    movement = 0;
    abilities = [];
}

/// @type {Struct<Struct.UnitProfile>}
global.unit_profiles = {};
function load_unit_profiles() {
    var _unit_profiles = json_to_gamemaker(working_directory + "\\data\\unit_profiles.jsonc", json_parse);
    var _profile_names = variable_struct_get_names(_unit_profiles);

    for (var i = 0, l = array_length(_profile_names); i < l; i++) {
        var _profile_name = _profile_names[i];
        var _profile = _unit_profiles[$ _profile_name];
        var _unit_profile = new UnitProfile(_profile_name);

        struct_load(_unit_profile, _profile);

        global.unit_profiles[$ _profile_name] = _unit_profile;
    }
}
