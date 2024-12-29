// Sets the target based on the mouse click, sets the bombardment score for when the player bombards the target
var __b__;
__b__ = action_if_number(obj_saveload, 0, 0);
if (__b__){
    var xx, yy;
    xx=__view_get( e__VW.XView, 0 );
    yy=__view_get( e__VW.YView, 0 );

    with(obj_star_select){instance_deactivate_object(id);}

    var why=0,onceh=0, ship=0;

    bomb_score=0;
    for(var i=0; i<array_length(ship_ide) i++){
        if (ship_all[i]==1){
            if (obj_ini.ship_class[ship_ide[i]]=="Battle Barge") then bomb_score+=3;
            if (obj_ini.ship_class[ship_ide[i]]=="Strike Cruiser") then bomb_score+=1;
        }
    }

    // TODO Need to change max_ships to something more meaningful to make sure that SOMETHING is dropping
    if (obj_controller.cooldown<=0){
        if (ships_selected>0) and point_in_rectangle(mouse_x, mouse_y, bombard_button[0], bombard_button[1], bombard_button[2], bombard_button[3]){
            obj_controller.cooldown=30;
            
            var str=0;
            // TODO a centralised point to be able to fetch display names from factions identifying number
            switch (target) {
                case 2:
                    str = imp;
                    break;
                case 2.5:
                    str = pdf;
                    break;
                case 3:
                    str = mechanicus;
                    break;
                case 5:
                    str = sisters;
                    break;
                case 6:
                    str = eldar;
                    break;
                case 7:
                    str = ork;
                    break;
                case 8:
                    str = tau;
                    break;
                case 9:
                    str = tyranids;
                    break;
                case 10:
                    str = max(traitors, chaos);
                    break;
                default:
                    str = 0;
                    break;
            }           
            // Start bombardment here
            scr_bomb_world(p_target,obj_controller.selecting_planet,target,bomb_score,str);
        }
    }
    instance_activate_object(obj_star_select);
}
