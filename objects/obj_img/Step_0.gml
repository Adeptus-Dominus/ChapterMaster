//if ((instance_exists(obj_turn_end)) or (instance_exists(obj_fleet)) or (instance_exists(obj_star_select))) and (force_good=false) then scr_image("force",-50,0,0,0,0);
//if (!instance_exists(obj_turn_end)) and (!instance_exists(obj_fleet) and (!instance_exists(obj_star_select))) and (force_good=true) then scr_image("force",-666,0,0,0,0);

if ((!instance_exists(obj_fleet)) && (!instance_exists(obj_ncombat))) {
    if (instance_exists(obj_controller)) {
        if ((obj_controller.diplomacy == 0) && (obj_controller.menu == eMENU.Diplomacy) && (diplomacy_icon_good == false)) {
            scr_image("diplomacy_icon", -50, 0, 0, 0, 0);
            scr_image("symbol", -50, 0, 0, 0, 0);
        }
        if ((obj_controller.menu != 20) && (diplomacy_icon_good == true)) {
            scr_image("diplomacy_icon", -666, 0, 0, 0, 0);
            scr_image("symbol", -666, 0, 0, 0, 0);
        }

        if ((obj_controller.diplomacy > 0) && (diplomacy_splash_good == false)) {
            scr_image("diplomacy_splash", -50, 0, 0, 0, 0);
        }
        if ((obj_controller.diplomacy == 0) && (diplomacy_splash_good == true)) {
            scr_image("diplomacy_splash", -666, 0, 0, 0, 0);
        }

        var adv_goo;
        adv_goo = 0;
        if ((obj_controller.diplomacy < -5) && (obj_controller.diplomacy > -6)) {
            adv_goo += 1;
        }
        if ((obj_controller.menu >= 11) && (obj_controller.menu <= 16)) {
            adv_goo += 1;
        }
        if ((obj_controller.menu >= 500) && (obj_controller.menu <= 510)) {
            adv_goo += 1;
        }
        if ((adv_goo > 0) && (advisor_good == false)) {
            scr_image("advisor", -50, 0, 0, 0, 0);
        }
        if ((adv_goo == 0) && (advisor_good == true)) {
            scr_image("advisor", -666, 0, 0, 0, 0);
        }

        //if (obj_controller.diplomacy>10) and (obj_controller.diplomacy<11) and (diplomacy_daemon_good=false) then scr_image("diplomacy_daemon",-50,0,0,0,0);
        //if (obj_controller.diplomacy<=10) or (obj_controller.diplomacy>=11) and (diplomacy_daemon_good=true) then scr_image("diplomacy_daemon",-666,0,0,0,0);

        if ((obj_controller.menu == 24) && (obj_controller.formating > 0) && (formation_good == false)) {
            scr_image("formation", -50, 0, 0, 0, 0);
        }
        if ((obj_controller.menu != 24) || (obj_controller.formating <= 0) && (formation_good == true)) {
            scr_image("formation", -666, 0, 0, 0, 0);
        }
    }

    var crea_goo;
    crea_goo = 0;
    if (instance_exists(obj_controller)) {
        if ((!instance_exists(obj_fleet)) && (!instance_exists(obj_ncombat))) {
            crea_goo += 1;
        }
    }
    if (instance_exists(obj_creation)) {
        crea_goo += 1;
    }
    if (room_get_name(room) == "Defeat") {
        crea_goo += 1;
    }
    if ((crea_goo > 0) && (creation_good == false)) {
        scr_image("creation", -50, 0, 0, 0, 0);
    }
    if ((crea_goo <= 0) && (creation_good == true)) {
        scr_image("creation", -666, 0, 0, 0, 0);
    }

    if (instance_exists(obj_ingame_menu) && (menu_good == false)) {
        scr_image("menu", -50, 0, 0, 0, 0);
    }
    if ((!instance_exists(obj_ingame_menu)) && (menu_good == true)) {
        scr_image("menu", -666, 0, 0, 0, 0);
    }

    if (instance_exists(obj_fleet) && (postspace_good == false)) {
        scr_image("postspace", -50, 0, 0, 0, 0);
    }
    if ((!instance_exists(obj_fleet)) && (postspace_good == true)) {
        scr_image("postspace", -666, 0, 0, 0, 0);
    }

    if (instance_exists(obj_popup) && (popup_good == false)) {
        scr_image("popup", -50, 0, 0, 0, 0);
    }
    if ((!instance_exists(obj_popup)) && (popup_good == true)) {
        scr_image("popup", -666, 0, 0, 0, 0);
    }

    if (instance_exists(obj_creation) && (commander_good == false)) {
        scr_image("commander", -50, 0, 0, 0, 0);
    }
    if ((!instance_exists(obj_creation)) && (commander_good == true)) {
        scr_image("commander", -666, 0, 0, 0, 0);
    }
    if (instance_exists(obj_creation) && (slate_good == false)) {
        scr_image("slate", -50, 0, 0, 0, 0);
    }
    if ((!instance_exists(obj_creation)) && (slate_good == true)) {
        scr_image("slate", -666, 0, 0, 0, 0);
    }

    if ((instance_exists(obj_creation) || instance_exists(obj_star_select)) && (planet_good == false)) {
        scr_image("planet", -50, 0, 0, 0, 0);
    }
    if ((!instance_exists(obj_creation)) && (!instance_exists(obj_star_select)) && (planet_good == true)) {
        scr_image("planet", -666, 0, 0, 0, 0);
    }

    if (instance_exists(obj_turn_end) && (attacked_good == false)) {
        scr_image("attacked", -50, 0, 0, 0, 0);
    }
    if ((!instance_exists(obj_turn_end)) && (attacked_good == true)) {
        scr_image("attacked", -666, 0, 0, 0, 0);
    }

    if (instance_exists(obj_drop_select) && (purge_good == false)) {
        scr_image("purge", -50, 0, 0, 0, 0);
    }
    if ((!instance_exists(obj_drop_select)) && (purge_good == true)) {
        scr_image("purge", -666, 0, 0, 0, 0);
    }

    if (instance_exists(obj_event) && (event_good == false)) {
        scr_image("event", -50, 0, 0, 0, 0);
    }
    if ((!instance_exists(obj_event)) && (event_good == true)) {
        scr_image("event", -666, 0, 0, 0, 0);
    }

    if ((room_get_name(room) == "Main_Menu") && (title_splash_good == false)) {
        scr_image("title_splash", -50, 0, 0, 0, 0);
    }
    if ((room_get_name(room) != "Main_Menu") && (title_splash_good == true)) {
        scr_image("title_splash", -666, 0, 0, 0, 0);
    }

    if ((room_get_name(room) == "Defeat") && (defeat_good == false)) {
        scr_image("defeat", -50, 0, 0, 0, 0);
    }
    if ((room_get_name(room) != "Defeat") && (defeat_good == true)) {
        scr_image("defeat", -666, 0, 0, 0, 0);
    }
}
