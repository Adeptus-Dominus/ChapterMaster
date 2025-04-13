if (gc_timer > 0) {
    gc_timer -= 1;
    // show_debug_message($"obj_garbage_collector: gc_timer = {gc_timer}");
} else {
    gc_timer = 100; // Default is every frame, so de-facto 1;
    gc_collect();

    wait_and_execute(0, function(){
        var _gc_stats = gc_get_stats();
        var _gc_touched = $"Objects Touched: {_gc_stats.objects_touched}";
        var _gc_collected = $"Objects Collected: {_gc_stats.objects_collected}";
        var _gc_traversal_t = $"Traversal Time: {_gc_stats.traversal_time} μs";
        var _gc_collection_t = $"Collection Time: {_gc_stats.collection_time} μs";
        var _gc_lines = [_gc_touched, _gc_collected, _gc_traversal_t, _gc_collection_t];
        // show_debug_message_time($"(GC{_gc_stats.gc_frame}) Garbage Collected!");

        var _gc_message = $"Garbage Collected {_gc_stats.gc_frame}!";
        for (var i = 0; i < array_length(_gc_lines); i++) {
            _gc_message += $" {_gc_lines[i]}.";
        }
        log_message(_gc_message);
    });
}