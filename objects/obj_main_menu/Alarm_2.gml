/*p_system=part_system_create();
particle1=part_type_create();
part_type_shape(particle1,pt_shape_smoke);            //This defines the particles shape
part_type_size(particle1,4,6,-0.05,0);                    //This is for the size
part_type_scale(particle1,2,2);                       //This is for scaling
part_type_color1(particle1,c_black);                  //This sets its colour. There are three different codes for this
part_type_alpha1(particle1,0.5);                        //This is its alpha. There are three different codes for this
// part_type_speed(particle1,1,4,0,0);            //The particles speed
part_type_blend(particle1,0);                         //This is the blend mode, either additive or normal
part_type_life(particle1,60,120);                       //this is its lifespan in steps*/

p_system = part_system_create();
particle1 = part_type_create();
part_type_shape(particle1, pt_shape_smoke); //This defines the particles shape
part_type_size(particle1, 4, 6, 0, 0); //This is for the size
part_type_scale(particle1, 2, 4); //This is for scaling
part_type_color1(particle1, c_black); //This sets its colour. There are three different codes for this
part_type_alpha1(particle1, 0.25); //This is its alpha. There are three different codes for this
part_type_speed(particle1, 1.5, 2, 0, 0); //The particles speed
part_type_blend(particle1, 0); //This is the blend mode, either additive or normal
part_type_life(particle1, 1000, 1200); //this is its lifespan in steps*/

// part_particles_create(p_system,random(room_width/2)+(room_width/4),random(room_height),particle1,8);
part_particles_create(p_system, random(room_width / 2) + (room_width / 4), random(room_height), particle1, 8);

smoke = 0;

/* */
/*  */
