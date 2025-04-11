if (gc_timer > 0) {
    gc_timer -= 1;
    // show_debug_message($"obj_garbage_collector: gc_timer = {gc_timer}");
} else {
    gc_timer = 500; // Default is every frame, so de-facto 1;
    gc_collect();

    wait_and_execute(0, function(){
        var _gc_stats = gc_get_stats();
        var _gc_touched = $"Touched: {_gc_stats.objects_touched}";
        var _gc_collected = $"Collected: {_gc_stats.objects_collected}";
        var _gc_traversal_t = $"T1: {round(_gc_stats.traversal_time / 1000)} ms";
        var _gc_collection_t = $"T2: {round(_gc_stats.collection_time / 1000)} ms";
        var _gc_lines = [_gc_touched, _gc_collected, _gc_traversal_t, _gc_collection_t];
        // show_debug_message_time($"(GC{_gc_stats.gc_frame}) Garbage Collected!");

        var _gc_message = $"";
        for (var i = 0; i < array_length(_gc_lines); i++) {
            _gc_message += $"{_gc_lines[i]}. ";
        }
        log_message(_gc_message);
    });
}