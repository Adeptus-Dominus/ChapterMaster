obj_controller.combat = owner;
owner += 100;
with (obj_crusade) {
    if (owner == obj_controller.combat) {
        instance_destroy();
    }
}
owner -= 100;
obj_controller.combat = 0;
