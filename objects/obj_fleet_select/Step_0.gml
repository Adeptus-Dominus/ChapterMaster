


if (target!=0) and (!instance_exists(target)) then instance_destroy();


if (obj_controller.popup<1) or (obj_controller.popup>2) then instance_destroy();

if (target!=0) and (instance_exists(target)){
    x=target.x;
    y=target.y;
}

