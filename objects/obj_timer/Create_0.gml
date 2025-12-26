time_set = 0;
time_passed = 0;
end_function = undefined;
end_function_args = [];
execution_scope = undefined;

execute_end_function = function() {
    if (is_callable(end_function)) {
        // show_debug_message("Executing Method!");
        if (instance_exists(execution_scope)){
            var _func = end_function;
            var _args = end_function_args;
            with (execution_scope){
                if (is_method(_func)){
                    method_call(_func, _args);
                } else {
                    script_execute_ext(_func, _args)
                }
            } 
        } else {
            if (is_method(end_function)){
                method_call(end_function, end_function_args);
            } else {
                script_execute_ext(end_function, end_function_args)
            }
        }
    }
    // show_debug_message("Killing Myself!");
    instance_destroy(self);
}

