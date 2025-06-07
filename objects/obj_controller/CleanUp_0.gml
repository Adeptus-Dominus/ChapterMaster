global.name_generator = new NameGenerator();

var _star_arrays = [];
ds_map_values_to_array(global.star_sprites,_star_arrays);

for (var i=0;i<array_length(_star_arrays);i++){
	if (sprite_exists(_star_arrays[i])){
		sprite_delete(_star_arrays[i]);
	}
}

ds_map_clear(global.star_sprites);