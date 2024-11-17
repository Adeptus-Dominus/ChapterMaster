if (time_set > 0) {
    if (time_passed < time_set) {
        time_passed++;
        show_debug_message(time_passed);
    } else {
        if (is_method(end_function)) {
            show_debug_message("Executing Method!");
            method_call(end_function, end_function_args);
        }
        show_debug_message("Killing Myself!");
        instance_destroy(self);
    }
} else {
    instance_destroy(self);
}
