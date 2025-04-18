// TODO sizes should really be held in the vehicle's struct
function get_vehicle_size_map() {
    var vehicle_size_map = ds_map_create();
    vehicle_size_map[? "Rhino"] = 10;
    vehicle_size_map[? "Predator"] = 10;
    vehicle_size_map[? "Land Raider"] = 20;
    vehicle_size_map[? "Land Speeder"] = 5;
    vehicle_size_map[? "Whirlwind"] = 10;
    vehicle_size_map[? "Harlequin Troupe"] = 5;
    return vehicle_size_map;
}

// Modifies the size for each unit depending on their Type
function scr_unit_size(armour, role, other_factors, mobility=false) {
    var _size = 1;
    if (role == "") {
        return 0;
    }

    // TODO is_bulky should be in the armour's struct
    var bulky_armour = ["Terminator Armour", "Tartaros"]
    if (string_count("Dread", armour) > 0) {
        _size += 5;
    } else if (array_contains(bulky_armour, armour)) {
        _size++;
    };

    var vehicle_size_map = get_vehicle_size_map();

    if (role == obj_ini.role[100][eROLE.ChapterMaster]) {
        _size++;
    } else if (ds_map_exists(vehicle_size_map, role)) {
        _size = vehicle_size_map[? role];
    } else if (armour=="") {
        show_debug_message($"Could not find size for vehicle '{role}'");
    }

    return (_size);
}