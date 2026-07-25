/// @param {Struct|Id.Instance} _target The struct or instance holding the variable (use `global` for globals)
/// @param {String} _var_name The name of the variable as a string
/// @param {Constant.DsType} _ds_type The ds_type constant
function ds_safe_destroy(_target, _var_name, _ds_type) {
    var _ds_id = variable_instance_get(_target, _var_name);

    if (is_undefined(_ds_id) || !is_real(_ds_id) || _ds_id == -1) {
        return;
    }

    if (ds_exists(_ds_id, _ds_type)) {
        switch (_ds_type) {
            case ds_type_map:
                ds_map_destroy(_ds_id);
                break;
            case ds_type_list:
                ds_list_destroy(_ds_id);
                break;
            case ds_type_stack:
                ds_stack_destroy(_ds_id);
                break;
            case ds_type_queue:
                ds_queue_destroy(_ds_id);
                break;
            case ds_type_grid:
                ds_grid_destroy(_ds_id);
                break;
            case ds_type_priority:
                ds_priority_destroy(_ds_id);
                break;
        }

        variable_instance_set(_target, _var_name, -1);
    }
}
