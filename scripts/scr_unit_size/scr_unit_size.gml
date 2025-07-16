// TODO sizes should really be held in the vehicle's struct
function get_vehicle_size_map() {
    var vehicle_size_map = {
        "Rhino": 10,
        "Predator": 10,
        "Land Raider": 20,
        "Land Speeder": 5,
        "Whirlwind": 10,
        "Harlequin Troupe": 5
    };

    return vehicle_size_map;
}

// Modifies the size for each unit depending on their Type
function scr_unit_size(armour, role, other_factors, mobility=false) {
    var _size = 1;
    if (role == "") {
        return 0;
    }

    // TODO is_bulky should be in the armour's struct
    if (string_count("Dread", armour) > 0) {
        _size += 5;
    } else if (array_contains(LIST_TERMINATOR_ARMOUR, armour)) {
        _size++;
    };

    var vehicle_size_map = get_vehicle_size_map();

    if (role == obj_ini.role[100][eROLE.ChapterMaster]) {
        _size++;
    } else if (struct_exists(vehicle_size_map, role)) {
        _size = vehicle_size_map[$ role];
    } else if (armour=="") {
        show_debug_message($"Could not find size for vehicle '{role}'");
    }

    delete(vehicle_size_map);

    return (_size);
}