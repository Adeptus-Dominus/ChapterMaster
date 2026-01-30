// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function adjust_influence(faction, value, planet, star = "none") {
    if (star == "none") {
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
    } else {
        with (star) {
            adjust_influence(faction, value, planet);
        }
    }
}

function merge_influences(doner_influence, planet) {
    for (var i = 0; i < 15; i++) {
        if (i == 2) {
            continue;
        }
        adjust_influence(i, (p_influence[planet][i] + doner_influence[i] / 2), planet);
    }
}
