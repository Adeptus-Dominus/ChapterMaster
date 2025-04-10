// Manages ship and unit selection depending on menus
var __b__ = action_if_number(obj_popup, 0, 0);
if (__b__){
    if (menu==1) and (managing>0 || managing=-1) and (man_max>0){
        if ((man_current+MANAGE_MAN_SEE+1)<man_max) then man_current+=1;
        if ((man_current+MANAGE_MAN_SEE+1)<man_max) then man_current+=1;
    }
    if (menu==30) and (managing>0) and (man_max>=10){
        if ((ship_current+ship_see+1)<ship_max) then ship_current+=1;
        if ((ship_current+ship_see+1)<ship_max) then ship_current+=1;
    }
    if (menu==30) and (managing>0) and (man_max>=50){
        if ((ship_current+ship_see+1)<ship_max) then ship_current+=1;
        if ((ship_current+ship_see+1)<ship_max) then ship_current+=1;
    }
    if (menu==16) and (man_max>MANAGE_MAN_SEE){
        if ((man_current+MANAGE_MAN_SEE+1)<man_max) then man_current+=1;
        if ((man_current+MANAGE_MAN_SEE+1)<man_max) then man_current+=1;
    }
}
