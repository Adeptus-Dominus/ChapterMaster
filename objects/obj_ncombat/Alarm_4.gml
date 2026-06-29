for (var jims = 1; jims <= 20; jims++) {
    if (dead_jim[jims] != "") {
        newline = dead_jim[jims];
        newline_color = "red";
        scr_newtext();
        dead_jim[jims] = "";
        dead_jims -= 1;

        if (dead_jims > 0) {
            alarm[4] = 1;
        }
    }
}
