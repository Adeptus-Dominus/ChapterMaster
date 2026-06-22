function scr_event_newlines(argument0) {
    // argument0: string being added to the event display           -           need to verify string height

    if (argument0 != "") {
        draw_set_font(fnt_40k_14);
        var nls = string_height_ext(string_hash_to_newline(argument0), -1, 916) / 21;

        if (lines + nls > 17) {
            // Going to need to move some lines around
            repeat ((lines + nls) - 17) {
                for (var i = 1; i <= 17; i++) {
                    line[i] = line[i + 1];
                }
                line[17] = "";
                lines -= 1;
            }
        }

        if (lines + nls <= 17) {
            // Slap in text without worrying about lines
            // get first open
            var lo = 0;
            for (var i = 1; i <= 17; i++) {
                if ((line[i] == "") && (lo == 0)) {
                    lo = i;
                }
            }

            // Set the last open line to the block of text
            line[lo] = string(argument0);
            lines += 1;

            // If it is composed of several lines than make those lines beneath it blank as needed
            if (nls > 1) {
                repeat (nls - 1) {
                    lo += 1;
                    line[lo] = "---";
                    lines += 1;
                }
            }
        }
    }
}
