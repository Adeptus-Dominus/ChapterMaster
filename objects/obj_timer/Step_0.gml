if (time_set > 0) {
    if (time_passed < time_set) {
        time_passed++;
        // LOGGER.debug(time_passed);
    } else {
        execute_end_function();
    }
} else {
    execute_end_function();
}
