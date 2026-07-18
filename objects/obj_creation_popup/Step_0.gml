role_names_all = "";

if (!is_string(type)) {
    var z = (type >= 100) ? type - 100 : type;

    if (type >= 100) {
        for (var i = 1; i <= 13; i++) {
            var idd = 0;
            if (i == 1) {
                idd = 15;
            }
            if (i == 2) {
                idd = 14;
            }
            if (i == 3) {
                idd = 17;
            }
            if (i == 4) {
                idd = 16;
            }
            if (i == 5) {
                idd = 5;
            }
            if (i == 6) {
                idd = 2;
            }
            if (i == 7) {
                idd = 4;
            }
            if (i == 8) {
                idd = 3;
            }
            if (i == 9) {
                idd = 6;
            }
            if (i == 10) {
                idd = 8;
            }
            if (i == 11) {
                idd = 9;
            }
            if (i == 12) {
                idd = 10;
            }
            if (i == 13) {
                idd = 12;
            }
            role_names_all += string(obj_creation.role[100][idd]) + "|";
        }

        role_names_all += "Chapter Master|";
        role_names_all += "Master of Sanctity|";
        role_names_all += "Master of the Apothecarion|";
        role_names_all += "Forge Master|";

        if (obj_creation.role[100][z] != "") {
            if (string_count(obj_creation.role[100][z], role_names_all) > 1) {
                badname = 1;
            }
            if (string_count(obj_creation.role[100][z], role_names_all) <= 1) {
                badname = 0;
            }
        }
    }
}
