function scr_max_marine(max_type) {
    // max_type : "chaos" or "age" or "exp"

    // Returns the marine with the highest value

    var man_c, man_i, c, i, value, unit;
    man_c = 0;
    man_i = 0;
    c = 0;
    i = 0;
    value = 0;

    i = -1;
    c = -1;
    repeat (11) {
        c += 1;
        i = 0;
        repeat (305) {
            i += 1; // man_c[i]=0;man_i[i]=0;

            if (obj_ini.name[c][i] != "") {
                unit = obj_ini.TTRPG[c][i];
                if (max_type == "chaos") {
                    if (unit.corruption > value) {
                        value = unit.corruption;
                        man_c = c;
                        man_i = i;
                    }
                } else if (max_type == "age") {
                    if (obj_ini.age[c][i] < value) {
                        value = obj_ini.age[c][i];
                        man_c = c;
                        man_i = i;
                    }
                } else if (max_type == "exp") {
                    if (unit.experience > value) {
                        value = unit.experience;
                        man_c = c;
                        man_i = i;
                    }
                }
            }
        }
    }

    return string(man_c) + "|" + string(man_i) + "|" + string(obj_ini.name[man_c][man_i]) + "|" + string(value) + "|";
}
