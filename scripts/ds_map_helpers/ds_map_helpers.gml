function empty_ds_map(ds_map_inst){
	var _temp =[];
	ds_map_values_to_array(ds_map_inst,_temp);

	for (var i=0;i<array_length(_temp);i++){
		if (sprite_exists(_temp[i])){
			sprite_delete(_temp[i]);
		}
	}

	ds_map_clear(ds_map_inst);
}

function ds_map_delete_sprite(ds_map_inst, name){
    var _old_sprite = ds_map_find_value(ds_map_inst, name);
    if (sprite_exists(_old_sprite)){
        sprite_delete(_old_sprite);
    }

    ds_map_delete(ds_map_inst, name);
}