if (global.cheat_debug == 1) {
    for (var i = 0; i < 30; i++) {
        if (combat_messages[i] != "") {
            show_message(string(combat_messages[i]));
        }
    }
}
