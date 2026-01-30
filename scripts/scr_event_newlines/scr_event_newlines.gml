function scr_event_newlines(argument0) {
    // argument0: string being added to the event display           -           need to verify string height

    // show_message(string(argument0));

    if (argument0 != "") {
        var nl, nls, lo, q, onceh;
        draw_set_font(fnt_40k_14);
        onceh = 0;
        lo = 0;

        nls = string_height_ext(string_hash_to_newline(argument0), -1, 916) / 21;
        // show_message(string(nls));

        if (lines + nls > 17) {
            // Going to need to move some lines around
            nl = (lines + nls) - 17;

            repeat (nl) {
                var q;
                q = 0;
                repeat (17) {
                    q += 1;
                    line[q] = line[q + 1];
                }
                line[17] = "";
                lines -= 1;
            }
        }

        if (lines + nls <= 17) {
            // Slap in text without worrying about lines
            // get first open
            q = 0;
            lo = 0;
            repeat (17) {
                q += 1;
                if ((line[q] == "") && (lo == 0)) {
                    lo = q;
                }
            }

            // Set the last open line to the block of text
            line[lo] = string(argument0);
            lines += 1;

            // If it is composed of several lines than make those lines beneath it blank as needed
            if (nls > 1) {
                q = nls - 1;
                repeat (q) {
                    lo += 1;
                    line[lo] = "---";
                    lines += 1;
                }
            }
            onceh = 1;
        }
    }
}
