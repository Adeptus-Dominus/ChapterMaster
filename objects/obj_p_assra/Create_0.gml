image_xscale = 0.5;
image_yscale = 0.5;

origin = 0;
target = 0;
cooldown = 0;
board_cooldown = 0;
hp = 9999;
boarders = 0;
boarders_dead = 0;
boarding = false;
firstest = 0;
apothecary = 0;
apothecary_had = 0;
experience = 0;

action = "goto";

// Settings
damage = false;
plasma_bomb = false;
steal = false;

if (obj_controller.command_set[20] == 1) {
    damage = true;
}
if (obj_controller.command_set[21] == 1) {
    plasma_bomb = true;
}
if (obj_controller.command_set[22] == 1) {
    steal = true;
}

//

test = false;
