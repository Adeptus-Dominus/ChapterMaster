function default_bat_formation() {
    if (bat_formation[1] == "" && obj_controller.bat_formation_type[1] == 0) {
        obj_controller.bat_formation[1] = "Attack";
        obj_controller.bat_formation_type[1] = 1;

        obj_controller.bat_formation[2] = "Defend";
        obj_controller.bat_formation_type[2] = 1;

        obj_controller.bat_formation[3] = "Raid";
        obj_controller.bat_formation_type[3] = 2;
    }
}
