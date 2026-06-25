function alter_planet_corruption(value, planet, system = noone) {
    if (system == noone) {
        p_heresy[planet] = clamp(p_heresy[planet] + value, 0, 100);
    } else if (instance_exists(system)) {
        with (system) {
            alter_planet_corruption(value, planet);
        }
    }
}
