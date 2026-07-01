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

        // Mirror the freshly appended rows into the scrollback history (capped) so the log stays
        // scrollable after lines[] rolls them off its 45-row live window. If the player is currently
        // reading scrolled-up history, push their view down by the same amount to hold its position.
        if (variable_instance_exists(id, "log_history")) {
            for (var _h = first_open; _h <= first_open + breaks - 1; _h++) {
                array_push(log_history, { text: lines[_h], color: newline_color });
            }
            while (array_length(log_history) > log_history_max) {
                array_delete(log_history, 0, 1);
            }
            if (log_scroll > 0) {
                log_scroll = min(log_scroll + breaks, max(0, array_length(log_history) - log_view_lines));
            }
        }

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
