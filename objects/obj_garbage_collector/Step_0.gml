if (gc_timer > 0) {
    gc_timer -= delta_time/1000000;
    // show_debug_message($"obj_garbage_collector: gc_timer = {gc_timer}");
} else {
    gc_timer = 60;
    gc_collect();
    // show_debug_message("obj_garbage_collector: garbage collected!");
}