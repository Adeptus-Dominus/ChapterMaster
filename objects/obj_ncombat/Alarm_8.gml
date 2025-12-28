if ((enemy_forces != 0) && (player_forces != 0) && (battle_over == 0)) {
    if ((enemy == 6) && (timer_stage == 2)) {
        timer_stage = 3;

        combat_messages = [];
        combat_messages_to_show = 24;
        largest = 0;
        random_messages = 0;
        priority = 0;
        combat_messages_shown = 0;
    }

    if ((enemy != 6) && (timer_stage == 2)) {
        timer_stage = 3;

        combat_messages = [];
        combat_messages_to_show = 24;
        largest = 0;
        random_messages = 0;
        priority = 0;
        combat_messages_shown = 0;
    }

    if ((enemy == 6) && (timer_stage == 4)) {
        timer_stage = 5;

        combat_messages = [];
        combat_messages_to_show = 24;
        largest = 0;
        random_messages = 0;
        priority = 0;
        combat_messages_shown = 0;
    }

    if ((enemy != 6) && (timer_stage == 4)) {
        timer_stage = 5;

        combat_messages = [];
        combat_messages_to_show = 24;
        largest = 0;
        random_messages = 0;
        priority = 0;
        combat_messages_shown = 0;
    }
}
