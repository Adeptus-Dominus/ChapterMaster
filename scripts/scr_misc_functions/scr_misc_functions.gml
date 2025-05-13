/// @param {String} _name 
function stopwatch(_name) {
    if (!ds_map_exists(global.stopwatches, _name)) {
        ds_map_add(global.stopwatches, _name, get_timer());
    } else {
        var _time_elapsed = (get_timer() - global.stopwatches[? _name]) / 1000;
        ds_map_delete(global.stopwatches, _name);
        show_debug_message($"⏱️ Stopwatch {_name}: {_time_elapsed}ms");
        return _time_elapsed;
    }
}
