global.profiles = {
	"Greater Daemon of Tzeentch" : {

	}

	"Chaos Terminator": {

	}
	 "Cultist":{

	 }
}


function new_enemy_row(flanking=false, spawn_step_distance=100){
	if (flanking){
		var _nearest_enemy = get_leftmost(obj_pnunit, false);

		var start_x = _nearest_enemy.x;
		start_x -= spawn_step_distance*10;
	} else {
		var _nearest_enemy = get_leftmost(obj_pnunit, false);

		var start_x = _nearest_enemy.x;		
		var start_x = get_rightmost(obj_pnunit, false);
		start_x += spawn_step_distance*10;
	}

	var _row = instance_create(start_x, 240, obj_enunit);
	if (spawn_step_distance==1){
		_nearest_enemy.engaged=true;
		_row.engaged = true;
	}

}

function add_enemy_row_item(instance, en_name ,  number){
	with (instance){
		array_push(wep,"")
		array_push(wep_num,0)
		array_push(combi,0)
		array_push(range,0)
		array_push(att,0)
		array_push(apa,0)
		array_push(ammo,-1)
		array_push(splash,0)
		array_push(wep_owner,"")

		array_push(dude_co,0)
		array_push(dude_id,0)

		array_push(dudes,en_name)
		array_push(dudes_special,"")
		array_push(dudes_num,number)
		array_push(dudes_onum,-1)
		array_push(dudes_ac,0)
		array_push(dudes_hp,0)
		array_push(dudes_dr,1)
		array_push(dudes_vehicle,0)
		array_push(dudes_damage,0)
		array_push(dudes_exp,0)
		array_push(dudes_powers,"")
		array_push(faith,0)

		array_push(dudes_attack,1)
		array_push(dudes_ranged,1)
		array_push(dudes_defense,1)

		array_push(dudes_wep1,"")
		array_push(dudes_wep2,"")
		array_push(dudes_gear,"")
		array_push(dudges_mobi,"")
	}
	array_push(enemies, number);
}