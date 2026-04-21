function scr_newtext() {
    // This is ran in the combat object to detect, prepare, and inject the NEWLINE string into the display

    if (newline != "") {
        var breaks, first_open;
        newline = scr_lines(89 + 20, newline);
        breaks = max(1, string_count("@", newline));
        first_open = liness + 1;

        var b, f;
        b = first_open;
        f = -1;
        explode_script(newline, "@");
        f += 1;
        lines[b + f] = string("-" + explode[f]);
        lines_color[b + f] = newline_color;
        repeat (breaks - 1) {
            f += 1;
            lines[b + f] = string(explode[f]);
            lines_color[b + f] = newline_color;
        }
        liness += string_count("@", newline);

        repeat (100) {
            // if (liness>30){scr_lines_increase(1);liness-=1;}
            if (liness > 45) {
                scr_lines_increase(1);
                liness -= 1;
            }
        }
    }

    newline = "";
    newline_color = "";
}
