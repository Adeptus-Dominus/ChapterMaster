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





