function fetch_Ship(id){
	return obj_ini.ship_data[id];
}

function get_ship_by_name(ship_name){
	for (var i=0;i<array_length(obj_ini.ship_data);i++){
		var _ship = fetch_ship(i);
		if (ship_name == ship.name){
			return i;
		}
	}
}

function ShipStruct() constructor{
	features = [];
	turrets = [];
	weapons = [];
	location = [];
	owner = 0;
	size = 1;
	capacity = 0;
	carrying = 0;
	hp = 0;
	max_hp = 0;
	acceleration = 0.008;
	max_speed = 20;
	front_armour = 6;
	side_armour = 3;
	rear_armour = 1;
	name = "";

	static ship_hp_percentage = function(){
		return (hp/max_hp )* 100
	}

	static final_acceleration = function(){

		var _acel = acceleration;
	    if (obj_controller.stc_bonus[6]=3){
	        _acel*=1.2;
	    }	
	    return 	_acel;
	}

	static deceleration = function(){
		var _decel = final_acceleration()/2;
		return deceleration;
	}

	static ship_self_heal = function(){
        if (hp<0){
        	exit;
        } else if (hp<max_hp){
            hp = min(max_hp,hp+round(max_hp*0.06));
        }	
	}

	static free_space = function(){
		return capacity - carrying;
	}

	static has_space = function(required = 1){
		return free_space() >= required;
	}

	static calc_turn_speed = function(){
	    var _final_speed = turning_speed;
        if (obj_controller.stc_bonus[5]=3){
            _final_speed *= 1.05;
        }
        return _final_speed;
	}
}