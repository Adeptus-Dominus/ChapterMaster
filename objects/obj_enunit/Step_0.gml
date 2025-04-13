
highlight=0;
var diff,siz,pos;
diff=0;pos=880;siz=min(400,(men*0.5)+(medi)+(veh*2.5)+(dreads*2));
if (instance_exists(obj_centerline)){
    diff=x-obj_centerline.x;
}
if (siz>0){
    if ((pos+(diff*2))>817) and ((pos+(diff*2))<1575){
        if (mouse_x>=pos+(diff*2)) and (mouse_y>=450-(siz/2)) 
        and (mouse_x<pos+(diff*2)+10) and (mouse_y<450+(siz/2)) then highlight=men+medi+veh;
    }
}

if (highlight2!=highlight){
    highlight2=highlight;highlight3="";
    
    if (obj_ncombat.enemy!=1){
        var stop;stop=0;
        var dudes_len = array_length(dudes_num);
        for(var i = 0; i < dudes_len; i++) {
            if (stop=0){
                if (dudes_num[i]>0) and (dudes_num[i+1]>0) then highlight3+=string(dudes_num[i])+"x "+string(dudes[i])+", ";
                if (dudes_num[i]>0) and (dudes_num[i+1]<=0){highlight3+=string(dudes_num[i])+"x "+string(dudes[i])+".  ";stop=1;}
            }
        }
    }
    
    if (obj_ncombat.enemy = 1) {
        var variety, variety_num, stop, sofar, compl, vas;
        stop = 0;
        variety = [];
        variety_num = [];
        sofar = 0;
        compl = "";
        vas = "";

        var variety_len = array_length(variety);
        for (var q = 0; q < variety_len; q++) {
            variety[q] = "";
            variety_num[q] = 0;
        }
        var dudes_len = array_length(dudes);
        for (var q = 0; q < dudes_len; q++) {
            if (dudes[q] != "") and(string_count(string(dudes[q]) + "|", compl) = 0) {
                compl += string(dudes[q]) + "|";
                variety[sofar] = dudes[q];
                variety_num[sofar] = 0;
                sofar += 1;
            }
        }
        var dudes_len = array_length(dudes);
        for (var q = 0; q < dudes_len; q++) {
            if (dudes[q] != "") {
                var variety_len = array_length(variety);
                for (var i = 0; i < variety_len; i++) {
                    if (dudes[q] = variety[i]) then variety_num[i] += dudes_num[q];
                }
            }

        }
        stop = 0;
        var variety_num_len = array_length(variety_num);
        for (var i = 0; i < variety_num_len; i++) {
            if (stop = 0) {
                if (variety_num[i] > 0) and(variety_num[i + 1] > 0) then highlight3 += string(variety_num[i]) + "x " + string(variety[i]) + ", ";
                if (variety_num[i] > 0) and(variety_num[i + 1] <= 0) {
                    highlight3 += string(variety_num[i]) + "x " + string(variety[i]) + ".  ";
                    stop = 1;
                }
            }
        }
    } 
}


