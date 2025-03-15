
var i;
i=0;

if (cooldown >= 0) { cooldown -= global.frame_timings.t1; }

if (alerts > 0) && (popups_end == 1) && (fadeout == 0) {
    repeat(alerts) {
        i++;

        if (fast >= i) {
            if (cooldown <= 0 && string_length(alert_txt[i]) < string_length(alert_text[i])){
                alert_char[i]++;
                alert_txt[i] = string_copy(alert_text[i], 0, alert_char[i]);
                cooldown = 0.8;
            }

            if (alert_alpha[i] < 1) { alert_alpha[i] += global.frame_timings.t003; }
        }
    }
}


if (fadeout == 1) {
    i = 0;
    repeat(alerts) {
        i++; alert_alpha[i] -= global.frame_timings.t005;
        if (i <= 1) && (alert_alpha[1] <= 0) { instance_destroy(); }
    }
}



if (alarm[2] == int64(global.frame_timings.i2000)) { instance_destroy(); }
