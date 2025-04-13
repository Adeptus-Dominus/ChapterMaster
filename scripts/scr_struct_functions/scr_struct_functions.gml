function struct_empty(_struct) {
    return array_length(variable_struct_get_names(_struct)) == 0;
}

///! DELETE THIS AT SOME POINT!
/// @desc Deprecated. Use `variable_clone()` instead.
function DeepCloneStruct(clone_struct) {
    return variable_clone(clone_struct);
}
