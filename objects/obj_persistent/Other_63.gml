var _id = ds_map_find_value(async_load, "id");
var _status = ds_map_find_value(async_load, "status");
var _result = ds_map_find_value(async_load, "result");

if (ds_map_exists(global.active_error_dialogs, _id)) {
    var _error = ds_map_find_value(global.active_error_dialogs, _id);
    ds_map_delete(global.active_error_dialogs, _id);

    if (is_instanceof(_error, GameError)) {
        var _reporter = new BugReporter();
        _reporter.pending_error = _error;

        if (!ds_queue_empty(global.error_queue)) {
            global.pending_next_error = ds_queue_dequeue(global.error_queue);
        } else {
            global.pending_next_error = undefined;
        }
        _reporter.start();
    }
    exit;
}

if (global.active_bug_report != undefined && is_struct(global.active_bug_report)) {
    if (_id == global.active_bug_report.async_id) {
        if (_status && _result != "") {
            global.active_bug_report.send(_result);
            show_message_async("Report sent to the Administratum.");
        }
        delete global.active_bug_report;
        global.active_bug_report = undefined;

        if (global.pending_next_error != undefined && is_struct(global.pending_next_error)) {
            var _next = global.pending_next_error;
            global.pending_next_error = undefined;
            var _new_id = show_message_async(_next.player_message);
            ds_map_add(global.active_error_dialogs, _new_id, _next);
        }
    }
}
