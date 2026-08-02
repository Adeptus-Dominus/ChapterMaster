if (cooldown >= 0) {
    cooldown -= 1;
}

if ((alerts > 0) && (popups_end == 1) && (fadeout == 0)) {
    for (var i = 0; i < alerts; i++) {
        var _alert = alerts_list[i];
        if ((fast >= (i + 1)) && (string_length(_alert.txt) < string_length(_alert.text))) {
            _alert.char += 1;
            _alert.txt = string_copy(_alert.text, 0, _alert.char);
        }
        if ((fast >= (i + 1)) && (_alert.alpha < 1)) {
            _alert.alpha += 0.03;
        }
    }
}

if (fadeout == 1) {
    for (var i = 0; i < alerts; i++) {
        alerts_list[i].alpha -= 0.05;
        if ((i == 0) && (alerts_list[0].alpha <= 0)) {
            instance_destroy();
        }
    }
}

if (alarm[2] == 2000) {
    instance_destroy();
}
