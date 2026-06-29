/**
 * @arg {String} disadvantage disadvantage name e.g. "Shitty Luck"
 * @return {Bool}
 */
function scr_has_disadv(disadvantage) {
    var result = false;
    try {
        if (instance_exists(obj_creation)) {
            result = selected_chapter_trait(disadvantage);
        } else {
            result = array_contains(obj_ini.dis, disadvantage);
        }
    } catch (_exception) {
        ERROR_HANDLER.handle_exception(_exception);
    }
    return result;
}
