function find_nearest_edge_coords(x, y){
	function segment_nearest_point(a, b, point){
		var v = [a[0]-b[0], a[1]-b[1]];
		var u = [a[0] - point[0], a[1] - point[1]];

		var vu = v[0] * u[0] + v[1] * u[1];

		var vv = sqr(v[0]) + sqr(v[1]);

		var t = -vu / vv


	}
}


summon_new_hive_fleet(){
	var _x_edge_distance;
	var x_edge = x-(room_width/2);
	y_edge = y-(room_height/2);

	fleet=instance_create(xx+32,yy,obj_en_fleet);
    fleet.owner = eFACTION.Tyranids;
    fleet.sprite_index=spr_fleet_tyranid;
    fleet.image_index=1;
    fleet.capital_number=5;
    with (fleet){
    	set_fleet_movement();
    }
}