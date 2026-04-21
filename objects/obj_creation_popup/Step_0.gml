role_names_all = "";

var derpaderp, z, idd;
derpaderp = 0;
idd = 0;
if (!is_string(type)) {
    if (type >= 100) {
        z = type - 100;
    }
    if (type < 100) {
        z = type;
    }

    if (type >= 100) {
        repeat (13) {
            derpaderp += 1;
            if (derpaderp == 1) {
                idd = 15;
            }
            if (derpaderp == 2) {
                idd = 14;
            }
            if (derpaderp == 3) {
                idd = 17;
            }
            if (derpaderp == 4) {
                idd = 16;
            }
            if (derpaderp == 5) {
                idd = 5;
            }
            if (derpaderp == 6) {
                idd = 2;
            }
            if (derpaderp == 7) {
                idd = 4;
            }
            if (derpaderp == 8) {
                idd = 3;
            }
            if (derpaderp == 9) {
                idd = 6;
            }
            if (derpaderp == 10) {
                idd = 8;
            }
            if (derpaderp == 11) {
                idd = 9;
            }
            if (derpaderp == 12) {
                idd = 10;
            }
            if (derpaderp == 13) {
                idd = 12;
            }

            role_names_all += string(obj_creation.role[100][idd]) + "|";
        }

        role_names_all += "Chapter Master|";
        role_names_all += "Master of Sanctity|";
        role_names_all += "Master of the Apothecarion|";
        role_names_all += "Forge Master|";
        // role_names_all+="Crusader|";
        // role_names_all+="Ranger|";

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
