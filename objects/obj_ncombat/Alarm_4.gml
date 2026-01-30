var jims;
jims = 0;
repeat (20) {
    jims += 1;

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
