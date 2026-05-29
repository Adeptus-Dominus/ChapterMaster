// Update check handler
if (variable_global_exists("version_checker") && is_struct(global.version_checker)) {
    global.version_checker.handle(async_load);
    exit;
}
