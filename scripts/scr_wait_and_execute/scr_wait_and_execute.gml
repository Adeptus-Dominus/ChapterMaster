/// @mixin
/// @desc Waits for a set amount of steps and executes a function/codeblock.
/// @arg {real} timer How many steps to wait. 0 executes it next frame.
/// @arg {function} func
/// @arg {array} func_args
function wait_and_execute(timer, func, func_args = []) {
    var _timer_obj = instance_create(0, 0, obj_timer);
    with(_timer_obj){
        time_set = timer;
        end_function = func;
        end_function_args = func_args;
    }
}
