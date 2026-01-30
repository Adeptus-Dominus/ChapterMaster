var i;
i = 0;

if (cooldown >= 0) {
    cooldown -= 1;
}

if ((alerts > 0) && (popups_end == 1) && (fadeout == 0)) {
    repeat (alerts) {
        i += 1;

        if ((fast >= i) && (string_length(alert_txt[i]) < string_length(alert_text[i]))) {
            alert_char[i] += 1;
            alert_txt[i] = string_copy(alert_text[i], 0, alert_char[i]);
        }
        if ((fast >= i) && (alert_alpha[i] < 1)) {
            alert_alpha[i] += 0.03;
        }
    }
}

if (fadeout == 1) {
    i = 0;
    repeat (alerts) {
        i += 1;
        alert_alpha[i] -= 0.05;
        if ((i == 1) && (alert_alpha[1] <= 0)) {
            instance_destroy();
        }
    }
}

if (alarm[2] == 2000) {
    instance_destroy();
}
