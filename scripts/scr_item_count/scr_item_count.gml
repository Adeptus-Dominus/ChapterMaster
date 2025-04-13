/// @description Returns the total quantity of an item, optionally filtered by quality
/// @param {string} _item_name The name of the item to count
/// @param {string} _quality The quality to count ("any", or specific like "standard", "master_crafted", etc.)
/// @return {real} The total count of the item at the specified quality
function scr_item_count(_item_name, _quality = "any") {
    var _count = 0;

    if (!struct_exists(obj_ini.equipment, _item_name)) {
        return 0;
    }

    var _equipment_entry = obj_ini.equipment[$ _item_name];
    var _equipment_counts = _equipment_entry.quantity;

    if (_quality == "any" || _quality == "best" || _quality == "worst") {
        var _qualities = variable_struct_get_names(_equipment_counts);
        for (var i = 0; i < array_length(_qualities); i++) {
            _quality = _qualities[i];
            _count += _equipment_counts[$ _quality];
        }
    } else {
        if (struct_exists(_equipment_counts, _quality)) {
            _count = _equipment_counts[$ _quality];
        }
    }

    return _count;
}
