/// @description Trigger an autosave using obj_saveload
function scr_autosave() {
    try {
        if (!instance_exists(obj_saveload)) {
            instance_create(0, 0, obj_saveload);
        }

        obj_saveload.autosaving = true;
        scr_save(0, 0, true);
    } catch (_e) {
        handle_exception(_e);
    } finally {
        with (obj_saveload) {
            instance_destroy();
        }
    }
}
