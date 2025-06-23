function find_loot(loot_data={}, loot_value = 200){
	var _possible_loots = {};
	var _total_lootables = 0;
	var _all_loot_names = [];

	var _loot_tags = struct_exists(loot_data ,"loot_tags") ? loot_data.loot_tags : [];

	var _exclusives = struct_exists(loot_data ,"exclusives") ? loot_data.exclusives : false;

	var _mults = struct_exists(loot_data ,"multipliers") ? loot_data.multipliers : false;

	var _excludes = struct_exists(loot_data ,"excludes") ? loot_data.excludes : false;

	var _weps = global.weapons;
	var _armour = global.gear.armour;
	var _mobi = global.gear.mobility;

	var _all_items_table = array_join(struct_get_names(_weps), struct_get_names(_armour),struct_get_names(_mobi));

	for (var i=0;i<array_length(_all_items_table);i++){
		var _item = gear_weapon_data(,_all_items_table[i]);
		if (_item == false){
			continue;
		}
		if (_exclusives != false){
			var _include = false;
			for (var e = 0; e<array_length(_exclusives); e++){
				if (array_contains(_item.tags, _exclusives[e])){
					_include = true;
					break;
				}
			}
			if (!_include){
				continue;
			}
		}

		if (_excludes != false){
			var _include = true;
			for (var e =0;e<array_length(_excludes);e++){
				if (array_contains(_item.tags, _excludes[e])){
					_include = false;
					break;
				}
			}
			if (!_include){
				continue;
			}
		}

		var _loot_value = _item.loot.base;
		for (var t = 0;t<array_length(_loot_tags);t++){
			if (struct_exists(_item.loot, _loot_tags[t])){
				if (_item.loot[$ _loot_tags[t]] > _loot_value){
					_loot_value = _item.loot[$ _loot_tags[t]];
				}
			}
		}
		var _loot_val = _loot_tags

		if (_mults != false){
			var _mult_names = struct_get_names(_mults);
			for (var e =0;e<array_length(_mult_names);e++){
				if (array_contains(_item.tags, _mult_names[e])){
					var _mult = _mults[$ _mult_names[e]];
					_loot_value *= _mult;
				}
			}
		}

		_possible_loots[$_item.name] = [_total_lootables, _total_lootables+_loot_value];
		_total_lootables+=_loot_value;
	}


	var _all_loot_names = struct_get_names(_possible_loots);

	if (!array_length(_all_loot_names)){
		return {};
	}
	var _final_loot = {};
	var _chosen_loot_val = 0
	while (_chosen_loot_val < loot_value){
		var _new_loot = irandom(_total_lootables-1);
		for (var i=0;i<array_length(_all_loot_names);i++){
			var _lootn = _all_loot_names[i];
			var _specific_loot_data = _possible_loots[$ _lootn];
			if (_new_loot>= _specific_loot_data[0] && _new_loot<_specific_loot_data[1]){
				var _chosen_piece = _lootn;
				var _loot_val = max(100-(_specific_loot_data[1] - _specific_loot_data[0]),1);
				if (!struct_exists(_final_loot, _chosen_piece)){
					_final_loot[$ _chosen_piece] = 1;
				} else {
					_final_loot[$ _chosen_piece]++;
				}
				_chosen_loot_val += _loot_val;

				var _add_more = irandom(2);
				while (_add_more == 0 && _chosen_loot_val<loot_value){
					_final_loot[$ _chosen_piece]++;
					_chosen_loot_val += _loot_val;
					_add_more = irandom(2);
				}

				break;
			}
		}
	}

	return _final_loot;
	
}

