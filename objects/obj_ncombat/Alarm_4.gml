for (var jims = 1; jims <= 20; jims++) {
    if (dead_jim[jims] != "") {
        combat_log.push(dead_jim[jims], eMSG_COLOR.RED);
        dead_jim[jims] = "";
        dead_jims -= 1;

        if (dead_jims > 0) {
            alarm[4] = 1;
        }
    }
}
