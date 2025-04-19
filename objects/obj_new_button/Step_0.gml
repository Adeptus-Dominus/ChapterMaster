var bx, by, wid, hei, stop;
wid = 0;
hei = 0;
bx = 0;
by = 0;
stop = 0;
bx = x;
by = y;
if ((follow_control == true) && instance_exists(obj_controller)) {
    xx += __view_get(e__VW.XView, 0);
    yy += __view_get(e__VW.YView, 0);
}

highlighted = false;

if (button_id == 1) {
    wid = 142 * scaling;
    hei = 43 * scaling;
    if ((mouse_y >= by) && (mouse_y <= by + hei)) {
        if ((mouse_x >= bx) && (mouse_x <= bx + wid)) {
            if (mouse_x >= +bx + (134 * scaling)) {
                var dif1, dif2;
                dif1 = mouse_x - (__view_get(e__VW.XView, 0) + bx + (134 * scaling));
                dif2 = dif1 * 1.25;
                if (mouse_y < __view_get(e__VW.YView, 0) + by + dif2) {
                    stop = 1;
                }
            }
            if (stop == 0) {
                highlighted = true;
            }
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
if (button_id == 2) {
    wid = 142 * scaling;
    hei = 43 * scaling;
    if ((mouse_y >= __view_get(e__VW.YView, 0) + by) && (mouse_y <= __view_get(e__VW.YView, 0) + by + hei)) {
        if ((mouse_x >= __view_get(e__VW.XView, 0) + bx) && (mouse_x <= __view_get(e__VW.XView, 0) + bx + wid)) {
            if (mouse_x >= __view_get(e__VW.XView, 0) + bx + (134 * scaling)) {
                var dif1, dif2;
                dif1 = mouse_x - (__view_get(e__VW.XView, 0) + bx + (134 * scaling));
                dif2 = dif1 * 1.25;
                if (mouse_y < __view_get(e__VW.YView, 0) + by + dif2) {
                    stop = 1;
                }
            }
            if (stop == 0) {
                highlighted = true;
            }
        }
    }
}
if (button_id == 3) {
    wid = 115 * scaling;
    hei = 43 * scaling;
    if ((mouse_y >= __view_get(e__VW.YView, 0) + by) && (mouse_y <= __view_get(e__VW.YView, 0) + by + hei)) {
        if ((mouse_x >= __view_get(e__VW.XView, 0) + bx) && (mouse_x <= __view_get(e__VW.XView, 0) + bx + wid)) {
            if (mouse_x >= __view_get(e__VW.XView, 0) + bx + (108 * scaling)) {
                var dif1, dif2;
                dif1 = mouse_x - (__view_get(e__VW.XView, 0) + bx + (108 * scaling));
                dif2 = dif1 * 2;
                if (mouse_y < __view_get(e__VW.YView, 0) + by + dif2) {
                    stop = 1;
                }
            }
            if (stop == 0) {
                high = "apoth";
            }
        }
    }
}
if (button_id == 4) {
    wid = 108 * scaling;
    hei = 42 * scaling;
    if ((mouse_y >= __view_get(e__VW.YView, 0) + by) && (mouse_y <= __view_get(e__VW.YView, 0) + by + hei)) {
        if ((mouse_x >= __view_get(e__VW.XView, 0) + bx) && (mouse_x <= __view_get(e__VW.XView, 0) + bx + wid)) {
            if (mouse_x >= __view_get(e__VW.XView, 0) + bx + (108 * scaling)) {
                var dif1, dif2;
                dif1 = mouse_x - (__view_get(e__VW.XView, 0) + bx + (108 * scaling));
                dif2 = dif1 * 2;
                if (mouse_y < __view_get(e__VW.YView, 0) + by + hei - dif2) {
                    stop = 1;
                }
            }
            if (stop == 0) {
                highlighted = true;
            }
        }
    }
}

if ((highlighted == true) && instance_exists(obj_ingame_menu)) {
    if ((obj_ingame_menu.fading > 0) && (target >= 10)) {
        highlighted = false;
    }
}
if ((highlighted == true) && (highlight < 0.5)) {
    highlight += 0.02;
}
if ((highlighted == false) && (highlight > 0)) {
    highlight -= 0.04;
}


var freq;
freq = 150;
if (line > 0) {
    line += 1;
}
if ((button_id == 4) && (line > 105)) {
    line = 0;
}
if ((button_id <= 2) && (line > (141 * scaling))) {
    line = 0;
}
if ((button_id == 3) && (line > 113)) {
    line = 0;
}
if ((line == 0) && (floor(random(freq)) == 3)) {
    line = 1;
}

/* */
/*  */

if (highlighted == true && scr_click_left(,true)) { // Tip of the day: no idea why, but if you split this into two lines, the check will never pass;
    if (target > 10) {
        obj_ingame_menu.effect = self.target;
    }
}

