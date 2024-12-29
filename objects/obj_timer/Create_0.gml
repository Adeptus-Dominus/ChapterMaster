time_set = 0;
time_passed = 0;
end_function = undefined;
end_function_args = [];

execute_end_function = function() {
    if (is_method(end_function)) {
        // show_debug_message("Executing Method!");
        method_call(end_function, end_function_args);
    }
    // show_debug_message("Killing Myself!");
    instance_destroy(self);
}
