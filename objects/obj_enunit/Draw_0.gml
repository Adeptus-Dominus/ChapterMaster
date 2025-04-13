
if (instance_exists(obj_pnunit)){
    diff=0;pos=880;
    siz=min(400,(men*0.5)+(medi)+(veh*2.5)+(dreads*2));
}


draw_set_color(c_white);
if (instance_exists(obj_centerline)) and (instance_exists(obj_pnunit)){
    diff=x-obj_centerline.x;
}

draw_set_color(c_maroon);
if (obj_ncombat.enemy=2) then draw_set_color(8307806);
if (obj_ncombat.enemy=3) then draw_set_color(16512);
if (obj_ncombat.enemy=5) then draw_set_color(c_silver);
if (obj_ncombat.enemy=6) then draw_set_color(33023);
if (obj_ncombat.enemy=7) then draw_set_color(38144);
if (obj_ncombat.enemy=8) then draw_set_color(117758);
if (obj_ncombat.enemy=9) then draw_set_color(7492269);
if (obj_ncombat.enemy=10) then draw_set_color(c_purple);
if (obj_ncombat.enemy=13) then draw_set_color(65408);

if (siz>0){
    draw_set_alpha(1);
    if (highlight>0) then draw_set_alpha(0.8);
    if ((pos+(diff*2))>817) and ((pos+(diff*2))<1575){
        draw_rectangle(pos+(diff*2),450-(siz/2),pos+(diff*2)+10,450+(siz/2),0);
    }
    draw_set_alpha(1);
}

if (highlight>0) and (obj_ncombat.fadein<=0){
    draw_set_color(38144);
    draw_line(pos+(diff*2)+5,450,817,685);
    draw_set_font(fnt_40k_14b);
    draw_text(817,688,string_hash_to_newline("Row Composition:"));
    draw_set_font(fnt_40k_14);
    draw_text_ext(817,706,string_hash_to_newline(string(highlight3)),-1,758);    
}



