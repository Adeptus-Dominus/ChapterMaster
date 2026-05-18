if (variable_global_exists("error_queue") && ds_exists(global.error_queue, ds_type_queue)) {
    ds_queue_destroy(global.error_queue);
}
if (variable_global_exists("active_error_dialogs") && ds_exists(global.active_error_dialogs, ds_type_map)) {
    ds_map_destroy(global.active_error_dialogs);
}
