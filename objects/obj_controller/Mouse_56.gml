// Resets cooldown
var __b__ = action_if_variable(cooldown, 0, 2);
if (__b__) {
    __b__ = action_if_variable(cooldown, 9000, 1);
    if (__b__) {
        cooldown = 0;
    }
}
