/// @param {Enum.eFACTION} faction
/// @param {Real} value
/// @param {Real} planet
/// @param {Id.Instance.obj_star} star
function adjust_influence(faction, value, planet, star) {
    with (star) {
        p_influence[planet][faction] += value;
        var total_influence = array_sum(p_influence[planet]);
        var loop = 0;
        if (total_influence > 100) {
            var difference = total_influence - 100;
            while (difference > 0 && loop < 100) {
                loop++;
                for (var i = 0; i < 15; i++) {
                    if (p_influence[planet][i] > 0) {
                        p_influence[planet][i]--;
                        difference--;
                    }
                }
            }
        } else if (total_influence < 0) {
            while (total_influence < 0 && loop < 100) {
                loop++;
                for (var i = 0; i < 15; i++) {
                    if (p_influence[planet][i] < 0) {
                        p_influence[planet][i]++;
                        total_influence++;
                    }
                }
            }
        }
    }
}

/// @self Asset.GMObject.obj_star
/// @param {Array<Real>} doner_influence
/// @param {Real} planet
function merge_influences(doner_influence, planet) {
    for (var i = 0; i < 15; i++) {
        if (i == 2) {
            continue;
        }
        adjust_influence(i, (p_influence[planet][i] + doner_influence[i] / 2), planet, id);
    }
}
