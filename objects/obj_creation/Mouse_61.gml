// Sets up the global icons as popups
if (slide==2) and (popup=="icons"){
    if (icons_top<(77+global.custom_icons)-24){
        icons_top+=6;
        if (icons_top>(77+global.custom_icons-24)) then icons_top=77+global.custom_icons-24;
    }
}
