
// These arrays are the losses on any one frame.
// Instead of resetting in a bunch of places, we reset here.
array_resize(lost, 0)
array_resize(lost_num, 0)

highlight=0;
var diff=0;
var pos=880;

if (instance_exists(obj_centerline)){
    diff=x-obj_centerline.x;
}
if (instance_exists(obj_enunit)) {
    siz=min(400,(men*0.5)+(medi)+(veh*2.5)+(dreads*2));
} else {
    siz = 0;
}
if (siz>0){
    if ((x_offset)>817) and ((x_offset)<1575){
        if (scr_hit([x_offset,450-(siz/2),x_offset+10,450+(siz/2)])){
            highlight=men+medi+dreads+veh;
        }
    }
}

if (highlight2!=highlight){
    highlight2=highlight;
    highlight3="";

    var dudes_len = array_length(dudes_num);
    for (var i = 0; i < dudes_len; i++){

            if (dudes_num[i] > 0 and dudes_num[i+1] > 0) {
                highlight3+=$"{dudes_num[i]}X {dudes[i]}, "
            } else if (dudes_num[i] > 0 and dudes_num[i+1] <= 0) {
                highlight3+=$"{dudes_num[i]}X {dudes[i]}.";
                break;
            }

    }
}


