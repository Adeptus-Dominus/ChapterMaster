/// @mixin
/// @desc Waits for a set amount of steps and executes a function/codeblock.
/// @arg {real} timer In steps, will be multiplied by (room speed / 30).
/// @arg {function} func
/// @arg {array} func_args
function wait_and_execute(timer, func, func_args = []) {
    var _timer_obj = instance_create(0, 0, obj_timer);
    with(_timer_obj){
        time_set = timer * (room_speed / 30);
        end_function = func;
        end_function_args = func_args;
    }
}
