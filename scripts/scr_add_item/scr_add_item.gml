/// @description Adds or removes an item from the equipment struct, supporting quality levels and special keywords
/// @param {string} _item_name The name of the item to add or remove
/// @param {real} _quantity The number of items to add (positive) or remove (negative)
/// @param {string} _quality The quality to add/remove: specific level, or "any", "best", or "worst" (default is "any")
/// @return {string} Returns the affected quality string, or "no_item" if the operation failed
function scr_add_item(_item_name, _quantity = 1, _quality = "any") {
    if (_item_name == "" || _quantity == 0) {
        return "no_item";
    }

    // Normalize quality if adding
    if (_quantity > 0 && _quality == "any") {
        _quality = "standard";
    }

    // Create the item if it doesn't exist
    if (!struct_exists(obj_ini.equipment, _item_name)) {
		if (_quantity > 0) {
			obj_ini.equipment[$ _item_name] = {
				name: _item_name,
				quantity: {}
			};
		} else {
			return "no_item";
		}
    }

    var _item_entry = obj_ini.equipment[$ _item_name];
    var _quantities = struct_exists(_item_entry, "quantity") ? _item_entry.quantity : {};

    // Adding items
    if (_quantity > 0) {
        if (!struct_exists(_quantities, _quality)) {
            _quantities[$ _quality] = 0;
        }

        _quantities[$ _quality] += _quantity;

        // Maintenance hook
        if (instance_exists(obj_controller)) {
            obj_controller.specialist_point_handler.add_to_armoury_repair(_item_name, _quantity);
        }
    }

    // Removing items
	else if (_quantity < 0) {
		// Get list of existing qualities
		var _available_qualities = variable_struct_get_names(_quantities);
		if (array_length(_available_qualities) == 0) {
			return "no_item";
		}

		// Handle special quality keywords
		var _priority_list = ["standard", "exemplary", "master_crafted", "artificer", "artifact"];
		switch (_quality) {
			case "any":
				_quality = array_random_element(_available_qualities); // random pick
				break;

			case "worst":
				for (var i = 0; i < array_length(_priority_list); i++) {
					if (array_contains(_available_qualities, _priority_list[i])) {
						_quality = _priority_list[i];
						break;
					}
				}
				if (_quality == "worst") return "no_item"; // fallback, unchanged
				break;
		
			case "best":
				for (var i = array_length(_priority_list) - 1; i >= 0; i--) {
					if (array_contains(_available_qualities, _priority_list[i])) {
						_quality = _priority_list[i];
						break;
					}
				}
				if (_quality == "best") return "no_item"; // fallback, unchanged
				break;
		}

		// Now actually remove
		if (!struct_exists(_quantities, _quality) || _quantities[$ _quality] <= 0) {
			return "no_item";
		}

		_quantities[$ _quality] += _quantity;

		if (_quantities[$ _quality] <= 0) {
			struct_remove(_quantities, _quality);
		}

		// If no more qualities, remove item
		if (array_length(variable_struct_get_names(_quantities)) == 0) {
			struct_remove(obj_ini.equipment, _item_name);
		}

		return _quality;
	}
}