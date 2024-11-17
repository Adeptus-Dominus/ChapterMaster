
/*if (engaged=1) then image_index=1;
if (engaged=0) then image_index=0;
draw_self();*/

var diff=0,pos=880;
if (veh_type[1]="Defenses"){
    siz=0;
    if (instance_exists(obj_nfort)) then siz=400;
}
draw_set_color(c_white);
if (instance_exists(obj_centerline)){
    diff=x-obj_centerline.x;
    draw_set_color(c_red);
    if (veh_type[1]=="Defenses"){
        diff=135;
        draw_set_color(c_gray);
    }
}
siz=min(400,(men*0.5)+(veh*2.5)+(dreads*2));
x_offset = pos+(diff*2);
if (siz>0){
    draw_set_alpha(1);
    if (highlight>0) then draw_set_alpha(0.8);
    if (x_offset>817) and (x_offset<1575){
        draw_rectangle(x_offset,450-(siz/2),x_offset+10,450+(siz/2),0);
    }
    draw_set_alpha(1);
}

if (highlight>0) and (obj_ncombat.fadein<=0){
    draw_set_color(38144);
    draw_line(x_offset+5,450,817,685);
    draw_set_font(fnt_40k_14b);
    draw_text(817,688,"Row Composition:");
    draw_set_font(fnt_40k_14);
    draw_text_ext(817,706,string_hash_to_newline(string(highlight3)),-1,758);    
}

// draw_text(800,(x*18)-400,string(diff));



draw_set_color(c_black);
draw_set_alpha(obj_ncombat.fadein/30);
draw_rectangle(822,239,1574,662,0);
draw_set_alpha(1);



exit;

draw_set_color(255);
draw_text((x*18)-400,300,string_hash_to_newline(string(men)+"|"+string(veh)+"#"+string(dudes_num[1])+"x "+string(dudes[1])+"#"+string(dudes_num[2])+"x "+string(dudes[2])+"#"+string(dudes_num[3])+"x "+string(dudes[3])+"#"+string(dudes_num[4])+"x "+string(dudes[4])+"#"+string(dudes_num[5])+"x "+string(dudes[5])));


draw_text((x*18)-400,420,string_hash_to_newline("1: "+string(veh_type[1])+"#2: "+string(veh_type[2])+"#3: "+string(veh_type[3])+"#4: "+string(veh_type[4])+"#5: "+string(veh_type[5])+"#6: "+string(veh_type[6])));

/* */
/*  */
