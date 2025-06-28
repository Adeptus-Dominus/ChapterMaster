
obj_controller.combat=owner;
owner+=100;
with(obj_crusade){if (owner=obj_controller.combat) then instance_destroy();} // This one seems relevant for 714
owner-=100;
obj_controller.combat=0;


