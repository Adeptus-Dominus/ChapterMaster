function FastestRouteAlgorithm(start_x,start_y, xx,yy,fleet, start_from_star=false) constructor{
	var star_number = instance_number(obj_star);
	target = instance_nearest(xx,yy,obj_star);
	self.fleet=fleet;
	self.ship_speed = fleet.action_spd;
	worst_case = (floor(point_distance(start_x,start_y, xx,yy)/ship_speed+2))*2;
	start_star = instance_nearest(start_x,start_y,obj_star).id;
	unvisited_stars = [
		[start_star,-1, [], false],
		[target,-1, [], false],
	];

	for (var i = 0; i < star_number; i++){
		if (instance_find(obj_star,i).id == start_star.id) then continue;
		if (instance_find(obj_star,i).id == target.id) then continue;
		var i_star = instance_find(obj_star,i);
		for (var s=1;s<array_length(unvisited_stars);s++){
			var s_star = unvisited_stars[s][0];
			if (star_distace_calc(i_star,start_star) < star_distace_calc(s_star,start_star)){
				array_insert(unvisited_stars, s, [i_star,-1, [], false]);
				break;
			}
		}
	};

	function find_star_travel_distances(cur_star_id){
		var current_star = unvisited_stars[cur_star_id][0];
		var cur_travel = unvisited_stars[cur_star_id][1];
		var eta;
		var warp_lane = false;
		for (var s=cur_star_id+1; s<array_length(unvisited_stars);s++){
			var visit_data = unvisited_stars[s];
			if (visit_data[3]) then continue;
			visit_star = unvisited_stars[s][0];
			eta = calculate_fleet_eta(current_star.x,current_star.y,visit_star.x,visit_star.y, ship_speed, true, true, fleet.warp_able);
			if (eta){
				if (eta+cur_travel<visit_data[1]
					|| visit_data[1]==-1 ){
					visit_data[1] = eta+cur_travel;
					visit_data[2] =[];
					for (var c=0;c<array_length(unvisited_stars[cur_star_id][2]);c++){
						array_push(visit_data[2], unvisited_stars[cur_star_id][2][c]);
					}
					if (!array_contains(visit_data[2], current_star.id)){
						array_push(visit_data[2], current_star.id);
					};
				}
			} else {
				visit_data[3] = true;
			}
			/*if (cur_star_id==0){
				if (eta>worst_case){
					visit_data[3] = true;
				}
			}*/
			unvisited_stars[s] = visit_data;
		}
		unvisited_stars[cur_star_id][3] = true;
	}

	for (var i=0;i<array_length(unvisited_stars);i++){
		if (!unvisited_stars[i][3]){
			find_star_travel_distances(i);
		}
	}

	final_route_info = unvisited_stars[array_length(unvisited_stars)-1];
	static draw_route = function(){
	    draw_set_color(c_blue);
        draw_set_alpha(1);            
        var cur_star = start_star;
        for (var i=0;i<array_length(final_route_info[2]);i++){
             draw_line_dashed(cur_star.x,cur_star.y,final_route_info[2][i].x,final_route_info[2][i].y,16,0.5);
             cur_star = final_route_info[2][i];
        }
        draw_line_dashed(cur_star.x,cur_star.y,final_route_info[0].x,final_route_info[0].y,16,0.5);
        var eta = $"ETA {final_route_info[1]+1}";
        var zoom_size = obj_controller.zoomed?5:1;
        draw_text_transformed(cur_star.x+24,cur_star.y+40,eta,zoom_size,zoom_size,0);             
	}

	static final_array_path = function(){
		var final_path = final_route_info[2];
		var path_store = [];
		array_push(final_path, final_route_info[0]);
		for (var i=0;i<array_length(final_path);i++){
			array_push(path_store, final_path[i].name);
		}
		return path_store;
	}
}

function star_distace_calc(star1,star2){
	return point_distance(star1.x, star1.y, star2.x, star2.y);
}



function determine_warp_join(star_a, star_b){
	var lane;
	var lane_strength = 0;
	for (var i=0;i<array_length(star_a.warp_lanes);i++){
		lane = star_a.warp_lanes[i];
		if (lane[0] == star_b.name){
			lane_strength = lane[1];
		}
	}
	if (lane_strength==0){
		for (var i=0;i<array_length(star_b.warp_lanes);i++){
			lane = star_b.warp_lanes[i];
			if (lane[0] == star_a.name){
				lane_strength = lane[1];
			}
		}		
	}
	return lane_strength;
}