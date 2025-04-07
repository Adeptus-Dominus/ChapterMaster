// Mult line macros basically
function scr_uuid_delete_unit(fUUID) {
    gml_pragma("forceinline");
    struct_remove(UUNITROOT, fUUID);
}

function scr_uuid_delete_ship(fUUID) {
    gml_pragma("forceinline");
    struct_remove(USHIPROOT, fUUID);
}
//
