
//TODO almost all of this can be handled in the gui layer
try{
    scr_ui_manage();
} catch(_exception){
    handle_exception(_exception);
    main_map_defaults();
}

try{
    scr_ui_advisors();
} catch(_exception){
    handle_exception(_exception);
    main_map_defaults(); 
}
 if (menu == MENU.Diplomacy){
	try{
	 /*if (audience > 0 && instance_exists(obj_turn_end)){
	     menu = 20;
		 }*/

        scr_ui_diplomacy();
	} catch(_exception){
	 handle_exception(_exception);
	 main_map_defaults(); 
	}
 }
try{
    scr_ui_settings();
	scr_ui_popup();
} catch(_exception){
    handle_exception(_exception);
    main_map_defaults(); 
}
