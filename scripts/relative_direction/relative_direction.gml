function relative_direction(argument0, argument1) {

	{
	return ((((argument0 - argument1) mod 360) + 540) mod 360) - 180;
	}



}

function move_location_relative(coords, relative_move_x, relative_move_y){
	for (var i=0;i<array_length(coords);i++){
		if (i%2 == 0 ){
			coords[i] += relative_move_x;
		} else {
			coords[i] += relative_move_y;
		}
	}
	return coords;
}
