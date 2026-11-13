/// @self Id.Instance.obj_turn_end
function scr_battle_sort() {
    // This is ran in order to sort the battles that have been queued up
    // Space battles are placed in front whenever possible
    var _swap_search_start = 0;
    for (var i = array_length(battles) - 1; i >= 1; i--) {
        var _was_swapped = false;
        if (battles[i].battle_type == eBATTLE_TYPES.FLEET){
            for (var e = _swap_search_start; e < i; e++){
                if (battles[e].battle_type == eBATTLE_TYPES.GROUNDFORCES){
                    var _temp = battles[e];
                    battles[e] = battles[i];
                    battles[i] = _temp;
                    _swap_search_start = e + 1;
                    _was_swapped = true;
                    break;
                }
            }
        }
        if (!_was_swapped){
            break;
        }
    }
    alarm[0] = 15;
}
