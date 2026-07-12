function scr_battle_sort() {
    // This is ran in order to sort the battles that have been quened up
    // Space battles are placed in front whenever possible

    for (var i = 49; i >= 0; i--) {
        if ((battles <= i) && (i >= 2) && (battles > 0)) {
            if ((battle[i] != 0) && (battle[i - 1] != 0) && (battle_world[i] == 0) && (battle_world[i - 1] > 0)) {
                var tem1 = battle[i - 1];
                var tem2 = battle_location[i - 1];
                var tem3 = battle_world[i - 1];
                var tem4 = battle_opponent[i - 1];
                var tem5 = battle_object[i - 1];
                var tem6 = battle_pobject[i - 1];
                var tem7 = battle_special[i - 1];

                battle[i - 1] = battle[i];
                battle_location[i - 1] = battle_location[i];
                battle_world[i - 1] = battle_world[i];
                battle_opponent[i - 1] = battle_opponent[i];
                battle_object[i - 1] = battle_object[i];
                battle_pobject[i - 1] = battle_pobject[i];
                battle_special[i - 1] = battle_special[i];

                battle[i] = tem1;
                battle_location[i] = tem2;
                battle_world[i] = tem3;
                battle_opponent[i] = tem4;
                battle_object[i] = tem5;
                battle_pobject[i] = tem6;
                battle_special[i] = tem7;
            }
        }
    }

    alarm[0] = 15;
}
