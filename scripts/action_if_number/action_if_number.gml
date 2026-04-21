/// @description (Old DnD) - if number evauation
/// @param index  instance index to check against
/// @param value value to compare against
/// @param type	type of check (1==<, 2==>, anything else is ==)
function action_if_number(argument0, argument1, argument2) {
    var ret = false;
    var n = instance_number(argument0);
    switch (argument2) {
        case 1:
            ret = n < argument1;
            break;
        case 2:
            ret = n > argument1;
            break;
        default:
            ret = n == argument1;
            break;
    }
    return ret;
}
