/// @description Changes a star's planet disposition, clamping the result to 0-100.
/// @param {String} star_name name of the star system
/// @param {Real} planet_num planet index
/// @param {Real} amount amount to change disposition by
function scr_gov_disp(star_name, planet_num, amount) {
    if (!instance_exists(obj_star)) {
        return;
    }

    with (obj_star) {
        if (name == star_name) {
            dispo[planet_num] = clamp(dispo[planet_num] + amount, -5000, 100);
            break;
        }
    }
}
