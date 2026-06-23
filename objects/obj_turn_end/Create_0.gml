instance_deactivate_object(obj_star_select);
instance_deactivate_object(obj_drop_select);
instance_deactivate_object(obj_bomb_select);

var i;
i = -1;
keywords = "";
last_open = 1;

battles = 0;
audiences = 0;
popups = 0;
alerts = 0;
fadeout = 0;
popups_end = 0;

current_battle = 1;
current_popup = 0;

fast = 0; // This is increased, once the alert[i]=1 and >=fast then it begins to fade in and get letters
info_mahreens = 0;
info_vehicles = 0;

first_x = obj_controller.x; // Return to this position once all the battles are done
first_y = obj_controller.y;
combating = 0;
cooldown = 10;

obj_controller.menu = 999; // show nothing, click nothing

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
battle_world = array_create(_popup_size, 0);
battle_opponent = array_create(_popup_size, 0);
/// @type {Asset.GMObject.obj_star}
battle_object = array_create(_popup_size, 0);
battle_pobject = array_create(_popup_size, 0);
battle_special = array_create(_popup_size, "");

var _string_size = 16;
strin = array_create(_string_size, "");

audiences = 0;
audience = 0;
audience_stack = [];

alert_alpha[1] = 0.2;
alert_char[1] = 1;
i = -1;

handle_discovered_governor_assasinations();

if (audiences > 0) {
    // This is a one-off change all messages to declare war
    var i = 0;
    var war;
    repeat (15) {
        i += 1;
        war[i] = 0;
    }
    for (var i = 0; i < array_length(audience_stack); i++) {
        var _audience = audience_stack[i];
        if ((_audience.topic != "declare_war") && (_audience.topic != "gene_xeno") && (_audience.topic != "") && (war[_audience.faction] == 0) && (obj_controller.faction_status[_audience.faction] != "War") && (_audience.faction != 10)) {
            if ((obj_controller.disposition[_audience.faction] <= 0) && (_audience.faction < 6)) {
                _audience.topic = "declare_war";
                war[_audience.faction] = 1;
            }
        }
    }
}

alerts = 0;
fast = 0;
show = 0;

/* */
/*  */
