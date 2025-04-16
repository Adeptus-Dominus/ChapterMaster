



var bx,by,wid,hei,stop;
wid=0;hei=0;bx=0;by=0;stop=0;bx=x;by=y;
if (follow_control=true) and (instance_exists(obj_controller)){
    xx+=__view_get( e__VW.XView, 0 );yy+=__view_get( e__VW.YView, 0 );
}

highlighted=false;

if (button_id=1){
    wid=142*scaling;hei=43*scaling;
    if (mouse_y>=by) and (mouse_y<=by+hei){
        if (mouse_x>=bx) and (mouse_x<=bx+wid){
            if (mouse_x>=+bx+(134*scaling)){
                var dif1,dif2;dif1=mouse_x-(__view_get( e__VW.XView, 0 )+bx+(134*scaling));dif2=dif1*1.25;
                if (mouse_y<__view_get( e__VW.YView, 0 )+by+dif2) then stop=1;
            }
            if (stop=0) then highlighted=true;
        }
    }
}
/*if (button_id=1){
    wid=142*scaling;hei=43*scaling;
    if (mouse_y>=view_yview[0]+by) and (mouse_y<=view_yview[0]+by+hei){
        if (mouse_x>=view_xview[0]+bx) and (mouse_x<=view_xview[0]+bx+wid){
            if (mouse_x>=view_xview[0]+bx+(134*scaling)){
                var dif1,dif2;dif1=mouse_x-(view_xview[0]+bx+(134*scaling));dif2=dif1*1.25;
                if (mouse_y<view_yview[0]+by+dif2) then stop=1;
            }
            if (stop=0) then highlighted=true;
        }
    }
}*/
if (button_id=2){
    wid=142*scaling;hei=43*scaling;
    if (mouse_y>=__view_get( e__VW.YView, 0 )+by) and (mouse_y<=__view_get( e__VW.YView, 0 )+by+hei){
        if (mouse_x>=__view_get( e__VW.XView, 0 )+bx) and (mouse_x<=__view_get( e__VW.XView, 0 )+bx+wid){
            if (mouse_x>=__view_get( e__VW.XView, 0 )+bx+(134*scaling)){
                var dif1,dif2;dif1=mouse_x-(__view_get( e__VW.XView, 0 )+bx+(134*scaling));dif2=dif1*1.25;
                if (mouse_y<__view_get( e__VW.YView, 0 )+by+dif2) then stop=1;
            }
            if (stop=0) then highlighted=true;
        }
    }
}
if (button_id=3){
    wid=115*scaling;hei=43*scaling;
    if (mouse_y>=__view_get( e__VW.YView, 0 )+by) and (mouse_y<=__view_get( e__VW.YView, 0 )+by+hei){
        if (mouse_x>=__view_get( e__VW.XView, 0 )+bx) and (mouse_x<=__view_get( e__VW.XView, 0 )+bx+wid){
            if (mouse_x>=__view_get( e__VW.XView, 0 )+bx+(108*scaling)){
                var dif1,dif2;dif1=mouse_x-(__view_get( e__VW.XView, 0 )+bx+(108*scaling));dif2=dif1*2;
                if (mouse_y<__view_get( e__VW.YView, 0 )+by+dif2) then stop=1;
            }
            if (stop=0) then high="apoth";
        }
    }
}
if (button_id=4){
    wid=108*scaling;hei=42*scaling;
    if (mouse_y>=__view_get( e__VW.YView, 0 )+by) and (mouse_y<=__view_get( e__VW.YView, 0 )+by+hei){
        if (mouse_x>=__view_get( e__VW.XView, 0 )+bx) and (mouse_x<=__view_get( e__VW.XView, 0 )+bx+wid){
            if (mouse_x>=__view_get( e__VW.XView, 0 )+bx+(108*scaling)){
                var dif1,dif2;dif1=mouse_x-(__view_get( e__VW.XView, 0 )+bx+(108*scaling));dif2=dif1*2;
                if (mouse_y<__view_get( e__VW.YView, 0 )+by+hei-dif2) then stop=1;
            }
            if (stop=0) then highlighted=true;
        }
    }
}

if (highlighted=true) and (instance_exists(obj_ingame_menu)){if (obj_ingame_menu.fading>0) and (target>=10) then highlighted=false;}
if (highlighted=true) and (highlight<0.5) then highlight+=0.02;
if (highlighted=false) and (highlight>0) then highlight-=0.04;

var freq;freq=150;if (line>0) then line+=1;
if (button_id=4) and (line>105) then line=0;
if (button_id<=2) and (line>(141*scaling)) then line=0;
if (button_id=3) and (line>113) then line=0;
if (line=0) and (floor(random(freq))=3) then line=1;


/* */
/*  */

if (scr_click_left()) {
    if (highlighted == true) {
        if (target > 10) {
            obj_ingame_menu.effect = self.target;
        }
    }
}
