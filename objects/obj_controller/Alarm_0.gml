
instance_activate_object(obj_star);
if (instance_exists(obj_ini)) and (global.load==0){
	alarm[1]=2;
    instance_activate_object(obj_star);
    instance_activate_all();
}
