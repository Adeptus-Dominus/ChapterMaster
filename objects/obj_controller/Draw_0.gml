
//TODO almost all of this can be handled in the gui layer
try{
    scr_ui_manage();
} catch(_exception){
    handle_exception(_exception);
    manage = 0;
    menu = 0;

}
try{
    scr_ui_advisors();
} catch(_exception){
    handle_exception(_exception);
    manage = 0;
    menu = 0;   
}
try{
    if (audience > 0 && instance_exists(obj_turn_end)){
        menu = 20;
    }
    if (menu == 20){
        scr_ui_diplomacy();
    }
} catch(_exception){
    handle_exception(_exception);
    manage = 0;
    menu = 0;   
}
try{
    scr_ui_settings();
} catch(_exception){
    handle_exception(_exception);
    manage = 0;
    menu = 0;   
}

scr_ui_popup();