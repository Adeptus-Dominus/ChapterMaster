fading = 0;
effect = 0;
settings = (room == Main_Menu);
cooldown = 0;

var _vx = camera_get_view_x(view_camera[0]);
var _vy = camera_get_view_y(view_camera[0]);

var _spawn_button = function(_x, _y, _text, _target) {
    var _butt = instance_create(_x, _y, obj_new_button);
    _butt.button_id = 1;
    _butt.button_text = _text;
    _butt.target = _target;
    _butt.scaling = 1.5;
    _butt.depth = -20010;
    return _butt;
};

if (room != Main_Menu) {
    _spawn_button(_vx + 821, _vy + 256, "Save", 11);
    _spawn_button(_vx + 821, _vy + 336, "Load", 12);
    _spawn_button(_vx + 821, _vy + 416, "Options", 13);
    _spawn_button(_vx + 821, _vy + 496, "Exit", 14);
    _spawn_button(_vx + 821, _vy + 666, "Return", 15);
} else {
    with (obj_new_button) instance_destroy();
    _spawn_button(_vx + 653, _vy + 664, "Exit", 25);
}

global.ui_click_lock = true;
