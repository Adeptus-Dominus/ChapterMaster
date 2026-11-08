tab = -1;
role = obj_controller.settings;
refresh = true;
engage = false;

total_roles = "";
all_equip = "";


item_name = [];

cancel_button = new UnitButtonObject({
    x1: 1347,
    y1: 721,
    style: "pixel",
    label: "CANCEL",
    font: fnt_40k_14b,
    color: c_gray,
});

//TODO get rid oof this and use weapon tags instead
/// @param {Struct.TTRPG_stats} unit
/// @param {string} weapon_name
can_assign_weapon = function(unit, weapon_name) {
    switch (weapon_name) {
        case "Assault Cannon":
            var _armour = unit.get_armour_data();
            return is_struct(_armour) && _armour.has_tag("terminator");
        default:
            return true;
    }
};
