// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function system_guard_total(){
	var total = 0;
	for (var i=1;i<=planets;i++){
		total+=p_guardsmen[i];
	}
	return total;
}

function planet_imperial_base_enemies(planet, star="none"){
	if (star=="none"){
		return p_orks[planet]+p_tau[planet]+p_chaos[planet]+p_traitors[planet]+p_tyranids[planet]+p_necrons[planet];
	} else {
		with (star){
			return p_orks[planet]+p_tau[planet]+p_chaos[planet]+p_traitors[planet]+p_tyranids[planet]+p_necrons[planet];
		}
	}
}


function has_imperial_enemies(planet, system){
	var _enemies = system.p_orks[planet]+system.p_chaos[planet]+system.p_tyranids[planet]+system.p_necrons[planet]+system.p_tau[planet]+system.p_traitors[planet];

	if (obj_controller.faction_status[eFACTION.Imperium] == "War"){
		_enemies += system.p_player[planet];
	}

	return _enemies;
}

function guard_find_planet_with_most_enemy_forces(system, current_planet = 0){
	var _next_planet=0,_highest=0;
	for (var o=1; o <= system.planets;o++){
		if (current_planet == 0 && system.p_guardsmen[o]>0){
			_current_planet = o;
		}
		var _enemy_count = has_imperial_enemies(o, system);
        if (_enemy_count > _highest && system.p_type[o]!="Daemon"){
            _next_planets=o;
            _highest = _enemy_count;
        }    		
	}

	return [_next_planet,_current_planet];
}

function ensure_no_planet_negatives(planet){
    if (p_eldar[planet]<0) then p_eldar[planet]=0;
    if (p_orks[planet]<0) then p_orks[planet]=0;
    if (p_tau[planet]<0) then p_tau[planet]=0;
    if (p_traitors[planet]<0) then p_traitors[planet]=0;
    if (p_tyranids[planet]<0) then p_tyranids[planet]=0;
    if (p_necrons[planet]<0) then p_necrons[planet]=0;
    if (p_player[planet]<0) then p_player[planet]=0;
    if (p_sisters[planet]<0) then p_sisters[planet]=0;
}

function planet_forces_array(planet){
	var force_array = [
		0,
		p_player[planet],
		p_guardsmen[planet],
		0,
		0,
		p_sisters[planet],
		p_eldar[planet],
		p_orks[planet],
		p_tau[planet],
		p_tyranids[planet],
		p_chaos[planet],
		p_traitors[planet],
		p_tyranids[planet],
		p_necrons[planet],
	];
	return force_array;
}





