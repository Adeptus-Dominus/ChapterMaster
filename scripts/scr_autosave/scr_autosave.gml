/// @description Trigger an autosave using obj_saveload
function scr_autosave() {
    try {
        if (!instance_exists(obj_saveload)) {
            instance_create_depth(0, 0, obj_saveload.depth, obj_saveload);
        }

        obj_saveload.autosaving = true;
        scr_save(0, 0, true);
    } catch (_e) {
        ERROR_HANDLER.handle_exception(_e);
    } finally {
        with (obj_saveload) {
            instance_destroy();
        }
    }
}
