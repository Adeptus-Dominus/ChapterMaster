// Refreshes the UI, reinitializes variables to defaults
function scr_ui_refresh() {

    reset_manage_selections();
    sel_uid = 0;

    reset_manage_arrays();
	
    alll = 0;
    sel_loading = -1;
    unload = 0;
    alarm[6] = 7;
}
function reset_manage_selections(){
    selecting_location = "";
    selecting_types = "";
    selecting_planet = 0;
    selecting_ship = -1;
    man_size = 0;
}