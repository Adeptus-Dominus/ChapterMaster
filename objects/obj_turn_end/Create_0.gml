instance_deactivate_object(obj_star_select);
instance_deactivate_object(obj_drop_select);
instance_deactivate_object(obj_bomb_select);

keywords = "";
last_open = 1;

battles = 0;
fadeout = 0;
popups = 0;
popups_end = 0;

combating = 0;
cooldown = 10;
current_battle = 1;
current_popup = 0;

info_mahreens = 0;
info_vehicles = 0;

first_x = obj_controller.x; // Return to this position once all the battles are done
first_y = obj_controller.y;

obj_controller.menu = eMENU.TURN_END; // show nothing, click nothing

var _fleet_size = 11;
enemy_fleet = array_create(_fleet_size, 0);
allied_fleet = array_create(_fleet_size, 0);
ecap = array_create(_fleet_size, 0);
efri = array_create(_fleet_size, 0);
eesc = array_create(_fleet_size, 0);
acap = array_create(_fleet_size, 0);
afri = array_create(_fleet_size, 0);
aesc = array_create(_fleet_size, 0);

var _popup_size = 91;
popup = array_create(_popup_size, 0);
popup_type = array_create(_popup_size, "");
popup_text = array_create(_popup_size, "");
popup_image = array_create(_popup_size, "");
popup_special = array_create(_popup_size, "");

alert = array_create(_popup_size, 0);
alert_type = array_create(_popup_size, "");
alert_text = array_create(_popup_size, "");

alert_char = array_create(_popup_size, 0);
alert_alpha = array_create(_popup_size, 0);
alert_txt = array_create(_popup_size, "");
alert_color = array_create(_popup_size, "");

battle = array_create(_popup_size, 0);
battle_location = array_create(_popup_size, "");
/// @desc 0 means space combat, 1+ means planet number (I hate this)
battle_world = array_create(_popup_size, undefined);
battle_opponent = array_create(_popup_size, 0);
/// @type {Array<Id.Instance.obj_star>}
battle_object = array_create(_popup_size, noone);
/// @type {Array<Id.Instance.obj_p_fleet>}
battle_pobject = array_create(_popup_size, noone);
battle_special = array_create(_popup_size, "");

var _string_size = 16;
strin = array_create(_string_size, "");

audiences = 0;
audience = 0;
audience_stack = [];

alert_alpha[1] = 0.2;
alert_char[1] = 1;

handle_discovered_governor_assasinations();

alerts = 0;
fast = 0; // This is increased, once the alert[i]=1 and >=fast then it begins to fade in and get letters
show = 0;
