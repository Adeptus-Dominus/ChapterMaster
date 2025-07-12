

draw_set_alpha(1);

for (var i=array_length(explosions)-1; i>= 0;i--){
	if (explosions[i].draw() == -1){
		delete explosions[i];
		array_delete(explosions, i , 1);
	}
}
if (start!=5){
	exit;
}
if(mouse_check_button_pressed(mb_left)){
	var _mb_consts = return_mouse_consts();
	 fleet_select_box = new DragBox(
	 	_mb_consts[0], 
	 	_mb_consts[1],
	 	mb_left,
	 	function(x_start,y_start,x_end,y_end){
	 		obj_fleet.ships_selected = 0;
	 		with (obj_p_ship){
	 			if (point_in_rectangle(x, y,x_start,y_start,x_end,y_end )){
	 				obj_fleet.ships_selected++;
	 				selected = 1;
	 			} else {
	 				if (selected && !keyboard_check(vk_shift)){
	 					selected = 0;
	 				}
	 			}
	 		}
	 	},
	 	function(x_start,y_start,x_end,y_end){
	 		obj_fleet.ships_selected = 0;
	 		with (obj_p_ship){
	 			if (point_in_rectangle(x, y,x_start,y_start,x_end,y_end )){
	 				obj_fleet.ships_selected++;
	 				selected = 1;
	 			} else {
	 				if (selected && !keyboard_check(vk_shift)){
	 					selected = 0;
	 				}
	 			}
	 		}
	 	}	 	
	);
}

if (fleet_select_box!= false){
	if (!fleet_select_box.step()){
		delete fleet_select_box;
		fleet_select_box = false;
	};
}