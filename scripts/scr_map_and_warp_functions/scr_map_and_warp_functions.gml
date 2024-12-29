// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
// function set_warp_point_data(){
// 	warp_point_hover = true;
// }
// Main menu movement

function in_camera_view(rect){
	var x1 = __view_get( e__VW.XView, 0 );
	var y1 = __view_get( e__VW.YView, 0 );
	var w = x1 + camera_get_view_width(view_camera[0]);
	var h = y1 + camera_get_view_height(view_camera[0]);
	return rectangle_in_rectangle(rect[0],rect[1],rect[2],rect[3], x1, y1, w, h);
}


function main_map_move_keys(){
    var view_w = camera_get_view_width(view_camera[0]);
    var view_h = camera_get_view_height(view_camera[0]);
    var x_limits = 0;
    var y_limits = 0;
	if ((menu==0) and (formating==0)) or (instance_exists(obj_fleet)){
	    var spd=12*obj_controller.scale_mod,keyb=""; // player move speed on campaign map
	    if ((!instance_exists(obj_ingame_menu)) and (!instance_exists(obj_ncombat))) or (instance_exists(obj_fleet)){
	        if keyboard_check(vk_shift){spd*=3;} // shift down, increase speed
	        var view_x = __view_get( e__VW.XView, 0 )+2;
	        var view_y = __view_get( e__VW.YView, 0 )+2;

	        if ((keyboard_check(vk_left)) or (mouse_x<=view_x+(view_w*0.02)) or (keyboard_check(ord("A")))) and (x>x_limits){
	        	var rel_view = view_w>global.default_view_width ?global.default_view_width/2:view_w/2;
	        	x = (x>view_x+rel_view) ? view_x+rel_view : x;
	        	x-=spd;
	        }
	        if ((keyboard_check(vk_right)) or (mouse_x>=view_x+(view_w*0.98)) or (keyboard_check(ord("D")))) and (x<(room_width-(x_limits))){
	        	var rel_view = view_w>global.default_view_width ?global.default_view_width/2:view_w/2;
	        	x = (x<view_x+view_w-rel_view) ? view_x+view_w-rel_view : x;
	        	x+=spd;
	        }
	        if ((keyboard_check(vk_up)) or (mouse_y<=view_y+(view_h*0.02)) or (keyboard_check(ord("W")))) and (y>y_limits){
	        	var rel_view = view_h>global.default_view_height ?global.default_view_height/2:view_h/2;
	        	y = (y>view_y+rel_view) ? view_y+rel_view : y;
	        	y-=spd;
	        }
	        if ((keyboard_check(vk_down)) or (mouse_y>=view_y+(view_h*0.98)) or (keyboard_check(ord("S")))) and (y<room_height-(y_limits)){
	        	var rel_view = view_h>global.default_view_height ?global.default_view_height/2:view_h/2;
	        	y = (y<view_y+view_h-rel_view) ? view_y+view_h-rel_view : y;
	        	y+=spd;
	        }
	    }
	}

	x = clamp(x, x_limits, room_width);
	y = clamp(y, y_limits, room_height);

}

function scr_map_scale(){
	return global.default_view_width/camera_get_view_width(view_camera[0]);
}

function draw_warp_lanes(){
	static routes = [];
	static current_seed = global.game_seed;
	if (array_length(routes)==0 || current_seed!=global.game_seed){
		current_seed=global.game_seed;
		routes = [];
		var star_degrade_list = [];
		var total_stars = instance_number(obj_star);
		var cur_star,this_star,connection,i, check_star;
		for (i = 0; i < total_stars; i++){
			array_push(star_degrade_list, i);
		}
		for (i = 0; i < total_stars; i++){
		    cur_star = instance_find(obj_star,star_degrade_list[i]);
		    var this_star = cur_star.id;
			var in_view = true;

		   	//var in_view = in_camera_view(star_box_shape(this_star));
		   	//if (!in_view) then  in_view = zoomed;
		    if (array_length(cur_star.warp_lanes)>0){
	    	    for (var s = 0; s < total_stars; s++){
	    	    	if (s==i) then continue
	    	    	check_star = instance_find(obj_star,star_degrade_list[s]);
	    	    	//if (!in_view && !in_camera_view(star_box_shape(check_star))) then continue;
	    	    	connection = determine_warp_join(check_star.id, this_star);
	    	    	if (connection){
	    	    		array_push(routes, [[check_star.x,check_star.y,this_star.x,this_star.y],connection]);
	    		    }
	    	    }
	    	}
		    array_delete(star_degrade_list, i,1);
		    total_stars--;
		    i--;
		}
	}
	var route;
	static warp_image=-1;
	warp_image+=0.5;
	if warp_image==58 then warp_image = 0;
	// if (!warp_point_hover) then hover_time=0;
	// warp_point_hover = false;
	for (var i = 0;i<array_length(routes);i++){
		draw_set_color(c_gray);
		route = routes[i];

		var route_coords = route[0];

		if (route[1]<4){
			draw_line(route_coords[0],route_coords[1],route_coords[2],route_coords[3]);
		}
		else if (route[1]==4){
			draw_set_color(c_yellow);
			//TODO abstract code as a ratio distance function
			//static debug_c = 0;
			var direction_x =  route_coords[2] - route_coords[0];
			var direction_y = route_coords[3] - route_coords[1];
			var forward = direction_x>=0 ? 1:-1;
			var downward = direction_y>=0 ? 1:-1;
			//var grade = direction_x/direction_y;
			var total_dist = 80;
			var pythag_dist = sqr(total_dist)
			var sum = (direction_x*forward)+(direction_y*downward)
			var x_ratio = direction_x*forward/(sum);
			var y_ratio = direction_y*downward/(sum);
			/*if (debug_c<100){
				show_debug_message($"{x_ratio},{forward},{y_ratio},{downward}");
			}*/
			var dist_x = (sqrt(pythag_dist*(x_ratio)))*forward;
			var dist_y = (sqrt(pythag_dist*(y_ratio)))*downward;

			var warp_width = sprite_get_width(spr_warp_storm)*0.75;
			var warp_height = sprite_get_height(spr_warp_storm)*0.75;

			for (var s=0;s<route[1];s++){
				draw_line(route_coords[0],route_coords[1],route_coords[0]+dist_x,route_coords[1]+dist_y);
			}

			draw_sprite_centered(spr_warp_storm,warp_image+i,route_coords[0]+dist_x,route_coords[1]+dist_y,0.75,0.75,0,c_white,1);

			var hit_box = [route_coords[0]+dist_x-(warp_width/2),route_coords[1]+dist_y-(warp_height/2), route_coords[0]+dist_x+(warp_width/2) ,route_coords[1]+dist_y+(warp_height/2) ];
			
			var _allow_tooltips = (!instance_exists(obj_star_select))

			if (_allow_tooltips && instance_exists(obj_fleet_select)){

				var mouse_consts = return_mouse_consts();

				_allow_tooltips = !obj_fleet_select.currently_entered || (mouse_consts[0] - __view_get( e__VW.XView, 0 ) > 300);
			}
			var warp_route_tooltip = "Major warp route to {0} (x4 travel speed for warp capable crafts)\n\nHold Shift and click Left Mouse Button to see destination.";
			if (scr_hit(hit_box)){
				//TODO centralise this for efficiency so it's only run once at the beggingin of step sequence
				var star_overlap = false;
				with (obj_star){
					if (point_distance(mouse_x, mouse_y, x, y)< 20){
						star_overlap=true;
						break;
					}
				}
				
				if (!star_overlap){
					var to = instance_nearest(route_coords[2],route_coords[3], obj_star);
					// warp_point_hover = true;

					if (_allow_tooltips){
						tooltip_draw(string(warp_route_tooltip, to.name));
					}

					/* if (array_equals(hover_loc,[route_coords[0] ,route_coords[1]])){
					 	hover_time++;
					 } else {
					 	hover_loc = [route_coords[0] ,route_coords[1]];
					 	hover_time = 0;
					 }*/

					if ((mouse_check_button_pressed(mb_left) && keyboard_check(vk_shift)) /* || (instance_exists(obj_fleet_select) && hover_time>=30) */){
						set_map_pan_to_loc(to);
					}
				}
			}

			for (var s=0;s<route[1];s++){
				draw_line(route_coords[2]+(s),route_coords[3]+(s),((route_coords[2]-dist_x+(s))),((route_coords[3]+(s)-dist_y)));
			}
			draw_sprite_centered(spr_warp_storm,warp_image+i,(route_coords[2]-dist_x),((route_coords[3]-dist_y)),0.75,0.75,0,c_white,1);

			hit_box = [((route_coords[2]-dist_x))-(warp_width/2) ,((route_coords[3]-dist_y))-(warp_height/2), ((route_coords[2]-dist_x))+(warp_width/2) ,((route_coords[3]-dist_y))+(warp_height/2) ];
			if (scr_hit(hit_box)){
				var star_overlap = false;
				with (obj_star){
					if (point_distance(mouse_x, mouse_y, x, y)< 20) {
						star_overlap=true;
						break;
					}
				}
				if (!star_overlap){
					var to = instance_nearest(route_coords[0], route_coords[1], obj_star);
					// warp_point_hover = true;

					if (_allow_tooltips){
						tooltip_draw(string(warp_route_tooltip, to.name));
					}

					// if (array_equals(hover_loc,[route_coords[2] ,route_coords[3]])){
					// 	hover_time++;
					// } else {
					// 	hover_loc = [route_coords[2] ,route_coords[3]];
					// 	hover_time = 0;
					// }

					if ((mouse_check_button_pressed(mb_left) && keyboard_check(vk_shift))/*  || (instance_exists(obj_fleet_select) && hover_time>=30) */){
						set_map_pan_to_loc(to);
					}
				}
			}
			//debug_c++;
		}

	}
}

function set_map_pan_to_loc(target){
	with(obj_controller){
		location_viewer.travel_target = [target.x, target.y];
		location_viewer.travel_increments = [(target.x-x)/15,(target.y-y)/15];
		location_viewer.travel_time = 0;
	}
}
/*function ration_distance(){

}*/
function star_box_shape(star="none"){
	var scale = obj_controller.map_scale;
	if (star=="none"){
		return [x-(60*scale), y+(5*scale), x+60*scale , y-40*scale];
	} else {
		with (star){
			return [x-(60*scale), y+(5*scale), x+60*scale , y-40*scale];
		}
	}
}

function draw_sprite_centered(sprite, subimg, x, y, xscale, yscale, rot, col, alpha){
	draw_set_halign(fa_left);
	var width = ((sprite_get_width(sprite)*xscale)/2);
	var height = ((sprite_get_height(sprite)*yscale)/2);
	draw_sprite_ext(sprite, subimg, x, y, xscale, yscale, rot, col, alpha);
}