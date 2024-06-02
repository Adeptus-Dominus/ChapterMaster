function find_nearest_edge_coords(x, y){
	var edge_coords = [0,0];
	var left_distance = x;
	var right_distance = room_width-x;
	var top_distance = y;
	var bottom_distance = room_height-y;
	var small_dist = min(left_distance,right_distance,top_distance,bottom_distance);
	switch(small_dist){
		case left_distance:
			edge_coords = [0,y];
			break;
		case right_distance:
			edge_coords = [room_width,y];
			break;
		case top_distance:
			edge_coords = [x,0];
			break;
		case bottom_distance:
			edge_coords = [x,room_height];
			break;									
	}

	return edge_coords;
}

function plus_or_minus_rand(figure, variation){
	return figure+(irandom(variation)*choose(-1,1));
}

function plus_or_minus_clamp(figure, variation, bottom,top){
	return clamp(plus_or_minus_rand(figure, variation), bottom,top);
}

function summon_new_hive_fleet(){
	var start_coords = find_nearest_edge_coords(x,y);

	if (start_coords[0] != 0) then start_coords[0] = plus_or_minus_clamp(start_coords[0], 50, 0, room_width);
	if (start_coords[1] != 0) then start_coords[1] = plus_or_minus_clamp(start_coords[1], 50, 0, room_height);

	fleet=instance_create(start_coords[0],start_coords[1],obj_en_fleet);
    fleet.owner = eFACTION.Tyranids;
    fleet.sprite_index=spr_fleet_tyranid;
    fleet.image_index=1;
    fleet.capital_number=5;
    fleet.action_x=x;
    fleet.action_y=y;
    with (fleet){
    	set_fleet_movement();
    }
}