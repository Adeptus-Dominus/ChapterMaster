xx = camera_get_view_x(view_camera[0]) + x;
yy = camera_get_view_y(view_camera[0]) + y;

obj_controller.cooldown = 8000;
question = "";
inputting = "";
blink = 0;
execute = false;
target = "";
target2 = "";
input_type = 0; // 0 for anything, 1 for cheats, 2 for real
maximum = 0;
cancel_button = {
    x1: xx + 26,
    y1: yy + 103,
    x2: xx + 126,
    y2: yy + 123,
};
accept_button = {
    x1: xx + 175,
    y1: yy + 103,
    x2: xx + 275,
    y2: yy + 123,
};

//

// question="How many Terminator Armours?  Max: 5";
// maximum=5;
// value_is_string=false; 
