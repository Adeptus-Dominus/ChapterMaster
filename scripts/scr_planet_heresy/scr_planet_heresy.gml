
function alter_planet_corruption(value, planet, system = -1){
	if (system == -1){
		p_heresy[planet]  = clamp(p_heresy[planet] + value, 0, 100);
	} else if instance_exists(system){
		with (system){
			alter_planet_corruption(value, planet)
		}
	}
}