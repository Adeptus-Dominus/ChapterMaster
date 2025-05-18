time_set = 0;
time_passed = 0;
end_function = undefined;
end_function_args = [];
execution_scope = -1;

execute_end_function = function() {
    if (is_method(end_function)) {
        // show_debug_message("Executing Method!");
        if (instance_exists(execution_scope)){
            var _func = end_function;
            var _args = end_function_args;
            with (execution_scope){
                method_call(_func, _args);
            } 
        }else {
            method_call(end_function, end_function_args);
        }
    }
    // show_debug_message("Killing Myself!");
    instance_destroy(self);
}
