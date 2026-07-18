if ((enemy_forces != 0) && (player_forces != 0) && (battle_over == 0)) {
    if (timer_stage == 2) {
        timer_stage = 3;
    } else if (timer_stage == 4) {
        timer_stage = 5;
    }
}
