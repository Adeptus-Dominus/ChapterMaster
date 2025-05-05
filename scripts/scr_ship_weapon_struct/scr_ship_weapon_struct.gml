global.ship_weapon_defualts  = {
	range : 600,
	facing : "front",
	cooldown : 30,
	minrange : 0,
	dam : 0,
	firing_arc : 12.5,
	ship : 0,
	ammo : -1,
	bullet_speed : 20,
	bullet_obj : obj_en_round,
	img : spr_round,
	damage_type : "full",
	draw_scale : 1.5,
	barrel_count : 1,
	melee : false,
	accuracy : 98,
	condition : "fuly_functional",
	bombard_value : 0
}


function ShipWeapon(weapon_name, overide_data={}) constructor{
	if (struct_exists(global.ship_weapons_stats, weapon_name)){
		var _wep_data = global.ship_weapons_stats[$ weapon_name];
		move_data_to_current_scope(_wep_data);
	}
	move_data_to_current_scope(overide_data);
	move_data_to_current_scope(global.ship_weapon_defualts, false);
	name = weapon_name;
	cooldown_timer = 0;

	target = 0;

	static weapon_direction = function (){
		var _tangent_direction = 0;
		var _facing = facing;

		with (ship){
			_tangent_direction  = facing_weapon_angle(_facing);
		}

		return _tangent_direction;
	}
	static create_projectile = function(){
		var _bullet = -1;
		var _tangent_direction = weapon_direction();
		var _bul_x = ship.x+lengthdir_x(32,_tangent_direction);
		var barrel_offset = 32;
		var _bul_y = ship.y+lengthdir_y(32,_tangent_direction);
		if (barrel_count> 1){
			var barrel_offset = -20*(barrel_offset/2);
		}
		var _bul_y = ship.y+lengthdir_y(barrel_offset,_tangent_direction);
		if (bullet_obj==obj_en_round){
			if (ship.ai_type = "player" ){
	            bullet_obj = obj_p_round
			}else if (ship.ai_type = "allies"){
				bullet_obj = obj_al_round		
			} 
		}
		repeat(barrel_count){
			var _bullet_qualities = {
				speed : bullet_speed,
				dam : dam,
				image_xscale : draw_scale,
				image_yscale : draw_scale,
				direction : point_direction(_bul_x,_bul_y, target.x,target.y),
				target : target,
				target_x:target.x,
				target_y:target.y,
				sprite_index : img,
			} 

			_bullet = instance_create_layer(
	        	_bul_x,
	        	_bul_y,
	            layer_get_all()[0],
	            bullet_obj
	        );
	        with (_bullet){
	        	move_data_to_current_scope(_bullet_qualities);
	        }
	        array_push(target.bullets_for, _bullet.id);
	        barrel_offset+=20
	        _bul_y = ship.y+lengthdir_y(barrel_offset,_tangent_direction);
	    }
	}
	static fire = function(){
		if (cooldown_timer > 0){
			cooldown_timer--;
		}
		draw_set_alpha(1);
		draw_set_color(c_red);
		if (cooldown_timer <= 0 && instance_exists(target) && (ammo == -1 || ammo>0)){
			if (ammo>0){
				ammo--;
			}
			cooldown_timer = cooldown;
			if (!melee && facing != "special"){
				create_projectile();
			} else if (facing != "special"){
		        if (target.shields<=0){
		        	target.hp-=dam;
		        }
		        else if (target.shields>0){
		        	target.shields-=dam;
		        }			
			} else if (facing == "special") {
				launch_flyers();
			}
		}
	}

	static launch_flyers = function(){
		var _launch_x = ship.x;
		var _launch_y = ship.y;

		if (ship.ai_type = "player" ){
            var _flyer=instance_create(_launch_x,_launch_y,obj_p_th);
            _flyer.direction=ship.direction;
		}else if (ship.ai_type = "allies"){
			var _flyer = instance_create(_launch_x,_launch_y,obj_al_in);
	        _flyer.direction=ship.direction;
	        _flyer.owner=ship.owner;		
		} else {
			var _flyer = instance_create(_launch_x,_launch_y,obj_en_in);
	        _flyer.direction=ship.direction;
	        _flyer.owner=ship.owner;	
		}
	}

	static find_target = function(){
		show_debug_message("targeting");
		x = ship.x;
		y = ship.y;
		var _shoot_angle = weapon_direction();
		if (_shoot_angle > 360){
			_shoot_angle -= 360;
		} else if (_shoot_angle< 0){
			_shoot_angle = 360 -_shoot_angle;
		}
		if (ship.ai_type == "player" || ship.ai_type == "allies"){
			show_debug_message("player");
			var _enemies = instance_number(obj_en_ship);
			for (var i=0;i<_enemies;i++){
				var _targ = instance_nearest(ship.x, ship.y, obj_en_ship);
				if (_targ.hp<=0){
					instance_deactivate_object(_targ.id);
					continue;
				}
				var _distance = point_distance(_targ.x, _targ.y, x,y);
				if (_distance > range){
					break;
				}
				if (minrange>0 && _distance<minrange){
					instance_deactivate_object(_targ.id);
					continue;
				}
				var _rel_direction = point_direction(x, y,_targ.x, _targ.y);

				if (_rel_direction < (_shoot_angle + firing_arc) && _rel_direction > (_shoot_angle - firing_arc)){
					target = _targ.id;
					break;
				}
			}
			instance_activate_object(obj_en_ship);
		} else if (ship.ai_type = "enemy"){
			show_debug_message("enemy");
			var _enemies = instance_number(obj_p_ship) + instance_number(obj_al_ship);
			for (var i=0;i<_enemies;i++){
				var _targ = instance_nearest(ship.x, ship.y, obj_p_ship);
				var _targ_2 = instance_nearest(ship.x, ship.y, obj_al_ship);
				if (!instance_exists(_targ)){
					if (instance_exists(_targ_2)){
						_targ =  _targ_2;
					} else {
						break;
					}
				} else if (instance_exists(_targ) && instance_exists(_targ_2)){
					if (point_distance(_targ_2.x, _targ_2.y, x,y)<point_distance(_targ.x, _targ.y, x,y)){
						_targ = _targ_2;
					}
				}

				if (_targ.hp<=0){
					instance_deactivate_object(_targ.id);
					continue;
				}
				var _distance = point_distance(_targ.x, _targ.y, x,y);
				if (_distance > range){
					break;
				}
				if (minrange>0 && _distance<minrange){
					instance_deactivate_object(_targ.id);
					continue;
				}
				var _rel_direction = point_direction(x, y,_targ.x, _targ.y);
				if (_rel_direction < (_shoot_angle + firing_arc) && _rel_direction > (_shoot_angle - firing_arc)){
					target = _targ;
					break;
				}					
			}
			instance_activate_object(obj_p_ship);
			instance_activate_object(obj_al_ship);
		}
		show_debug_message($"targeting2 {target}/");
	}
	static draw_weapon_firing_arc = function(){
		var _tangent_direction =  weapon_direction();
		var _facing = facing

	    var _max_distance = range;

	    x = ship.x;
	    
	    y = ship.y;

	    var _left = x - _max_distance;
	    var _top  = y - _max_distance;
	    var _right = x + _max_distance;
	    var _bottom = y + _max_distance;

	    if (facing == "most"){
	    	firing_arc = 110;
	    }
	    draw_set_color(38144);

	    var _start_x = x + lengthdir_x(_max_distance, _tangent_direction - firing_arc);
	    var _start_y = y + lengthdir_y(_max_distance, _tangent_direction - firing_arc);
	    var _end_x   = x + lengthdir_x(_max_distance, _tangent_direction + firing_arc);
	    var _end_y   = y + lengthdir_y(_max_distance, _tangent_direction + firing_arc);

	    draw_arc(_left, _top, _right, _bottom, _start_x, _start_y, _end_x, _end_y);
	    draw_line(x, y, _start_x, _start_y);
	    draw_line(x, y, _end_x, _end_y);

	    if (minrange > 0){
	    	draw_set_color(c_red);
		    var _start_x = x + lengthdir_x(minrange, _tangent_direction - firing_arc);
		    var _start_y = y + lengthdir_y(minrange, _tangent_direction - firing_arc);
		    var _end_x   = x + lengthdir_x(minrange, _tangent_direction + firing_arc);
		    var _end_y   = y + lengthdir_y(minrange, _tangent_direction + firing_arc);

		    draw_arc(_left, _top, _right, _bottom, _start_x, _start_y, _end_x, _end_y);
		    draw_line(x, y, _start_x, _start_y);
		    draw_line(x, y, _end_x, _end_y);	    	
	    }
	}
}

function add_weapon_to_ship(weapon_name, overide_data={}){
	overide_data.ship = id;
	array_push(weapons, new ShipWeapon(weapon_name, overide_data));
}

function add_weapon_to_ini_ship(index,weapon_name, overide_data={}){
	array_push(obj_ini.ship_weapons[index], new ShipWeapon(weapon_name, overide_data));
}