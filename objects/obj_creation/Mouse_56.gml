// Checks if scrollbar is engaged
if (action_if_variable(cooldown, 0, 2)) && (action_if_variable(cooldown, 9000, 1)){
    cooldown = 0;
}
var __b__ = action_if_variable(scrollbar_engaged, 0, 2);
if (__b__){
    scrollbar_engaged = 0;
}
