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
}