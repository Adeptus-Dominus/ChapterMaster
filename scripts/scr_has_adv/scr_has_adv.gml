/**
 * @arg {String} advantage advantage name e.g. "Tech-Scavengers"
 * @return {Bool}
 */
function scr_has_adv(advantage) {
    var result = false;
    try {
        if (instance_exists(obj_creation)) {
            result = selected_chapter_trait(advantage);
        } else {
            result = array_contains(obj_ini.adv, advantage);
        }
    } catch (_exception) {
        ERROR_HANDLER.handle_exception(_exception);
    }
    return result;
}

/**
 * @arg {array} array of advantages; advantage name e.g. ["Tech-Scavengers"]
 * @return {Bool}
 */
function scr_has_adv_any(advantages) {
    for (var i = 0; i < array_length(advantages); i++) {
        if (scr_has_adv(advantages[i])) {
            return true;
        }
    }
    return false;
}
