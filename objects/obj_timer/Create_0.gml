time_set = 0;
time_passed = 0;
end_function = undefined;
end_function_args = [];

execute_end_function = function() {
    if (is_method(end_function)) {
        // global.logger.debug("Executing Method!");
        method_call(end_function, end_function_args);
    }
    // global.logger.debug("Killing Myself!");
    instance_destroy(self);
}
