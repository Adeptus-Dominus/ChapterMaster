function ShipStruct() constructor{
	features = [];
	turrets = [];
	weapons = [];
	location = [];
	owner = 0;
	size = 1;

	static ship_self_heal = function(){
        if (hp<0){
        	exit;
        } else if (hp<max_hp){
            hp = min(max_hp,hp+round(max_hp*0.06));
        }	
	}
}