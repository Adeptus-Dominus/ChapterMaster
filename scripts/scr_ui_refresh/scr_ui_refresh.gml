// Refreshes the UI, reinitializes variables to defaults
function scr_ui_refresh() {

    man_size = 0;
    selecting_location = "";
    selecting_types = "";
    selecting_ship = 0;
    sel_uid = 0;

    reset_manage_arrays();
	
    alll = 0;
    sel_loading = 0;
    unload = 0;
    alarm[6] = 7;
}