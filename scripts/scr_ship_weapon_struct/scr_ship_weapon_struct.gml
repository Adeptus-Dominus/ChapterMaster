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
	explosion_sprite : spr_explosion,
	bombard_value : 0,
	size : 2,
}

function ShipWeaponExplosion(explosion_sprite, x, y, scale = 1) constructor{
	self.x = x;
	self.y = y;
	self.scale = scale;
	bang_sprite = explosion_sprite;
	animation_frames = sprite_get_number(bang_sprite);
	 current_index = 0;
	 static draw = function(){
	 	draw_sprite_ext(bang_sprite,floor(current_index),x,  y,(scale/2),(scale/2),0,c_white,1);
	 	current_index += 0.2;
	 	if (floor(current_index) > animation_frames){
	 		return -1;
	 	}
	 	return 1;
	 }

	 array_push(obj_fleet.explosions, self);
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
				explosion_sprite : explosion_sprite,
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

	static calc_gun_position = function(){
		if (struct_exists(self, "ship_position")){
			var _ship_sprite = ship.sprite_index;
			var _x_offset = sprite_get_xoffset(_ship_sprite);
			var _y_offset = sprite_get_yoffset(_ship_sprite);
			var _dist = point_distance(_x_offset, _y_offset, ship_position[0], ship_position[1]);
			var _rel_direction = point_direction(_x_offset,_y_offset, ship_position[0], ship_position[1]);
			x = ship.x + lengthdir_x(_dist ,  ship.direction+_rel_direction);
			y = ship.y + lengthdir_y(_dist ,  ship.direction+_rel_direction);
		} else {
			x = ship.x;
			y = ship.y;			
		}
	}
	static find_target = function(){
		calc_gun_position();
		var _shoot_angle = weapon_direction();
		if (_shoot_angle > 360){
			_shoot_angle -= 360;
		} else if (_shoot_angle< 0){
			_shoot_angle = 360 -_shoot_angle;
		}
		if (ship.ai_type == "player" || ship.ai_type == "allies"){

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
		if (instance_exists(target)){
			draw_set_color(c_red);
			draw_line(x, y, target.x, target.y);
		}
	}
	static draw_weapon_firing_arc = function(){
		var _tangent_direction =  weapon_direction();
		var _facing = facing

	    var _max_distance = range;

		calc_gun_position();

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
	if (instance_exists(obj_fleet)){
		overide_data.ship = id;
	}
	var _wep = new ShipWeapon(weapon_name, overide_data);
	array_push(weapons, _wep);
};


function round_collision_with_ship(){


	var _rel_direction = point_direction(other.x, other.y, x, y);
	var arm=other.armour_front;

	var t1=0;
	/*if (obj_fleet.global_defense!=1){
	    t1=1-(obj_fleet.global_defense-1);
	    dam=dam*t1;
	}*/
	if (other.shields.active()){
	    other.shields.shields-=dam;
	} else {
	    var _arm = 0;
	    var _rel_direction = point_direction(other.x, other.y, x, y);
	    if (_rel_direction <= 45 || _rel_direction >= 315){
	        _arm = other.armour_front;
	    } else if (_rel_direction <225 && _rel_direction > 135){
	        _arm = other.rear_armour;
	    } else {
	        _arm = other.side_armour;
	    }
	    if (_arm<dam){
	        other.hp -= (dam - arm);
	    } else {
	        other.hp -= 1;
	    }
	}

	new ShipWeaponExplosion(explosion_sprite, x,y, image_xscale);

	instance_destroy();	
}