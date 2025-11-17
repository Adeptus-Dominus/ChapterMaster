
instance_deactivate_object(obj_star_select);
instance_deactivate_object(obj_drop_select);
instance_deactivate_object(obj_bomb_select);

var i;i=-1;
keywords="";
last_open=1;

battles=0;
audiences=0;
popups=0;
alerts=0;
fadeout=0;
popups_end=0;

current_battle=-1;
current_popup=-1;

fast=0;// This is increased, once the alert[i]=1 and >=fast then it begins to fade in and get letters
info_mahreens=0;
info_vehicles=0;

first_x=obj_controller.x;// Return to this position once all the battles are done
first_y=obj_controller.y;
combating=0;
cooldown=10;

main_slate = new DataSlate();
obj_controller.menu=999;// show nothing, click nothing

enemy_fleet = array_create(11, 0);
allied_fleet = array_create(11, 0);
ecap = array_create(11, 0);
efri = array_create(11, 0);
eesc = array_create(11, 0);
acap = array_create(11, 0);
afri = array_create(11, 0);
aesc = array_create(11, 0);


popup =  [];
popup_type = [];
popup_text = [];
popup_image = [];
popup_special = [];

alert =  [];
alert_type = [];
alert_text = [];

alert_char =  [];
alert_alpha =  [];
alert_txt = [];
alert_color = [];

battle = [];// Set to 0 for none, 1 for battle to do, and 2 for resolved
battle_location = [];
battle_world =  [];// Be like -50 for space battle
battle_opponent =  [];// faction ID
battle_object =  [];// faction object for the fleets
battle_pobject =  [];// player object for the fleets
battle_special = [];

battle = [];
    

audiences = 0;
audience = 0;
audience_stack = [];

alert_alpha[1]=0.2;
alert_char[1]=1;
i=-1

handle_discovered_governor_assasinations()


if (audiences>0){// This is a one-off change all messages to declare war
    var i=0;
    var war;
    repeat(15){
        i+=1;
        war =  [];
    }
    for (var i=0;i<array_length(audience_stack);i++){
        var _audience = audience_stack[i];
         if (_audience.topic !="declare_war") and (_audience.topic!="gene_xeno") and (_audience.topic!="") and (war[_audience.faction]=0) and (obj_controller.faction_status[_audience.faction]!="War") and (_audience.faction!=10){
            if (obj_controller.disposition[_audience.faction]<=0) and (_audience.faction<6){
                _audience.topic="declare_war";
                war[_audience.faction]=1;
            }
        }       
    }
}

alerts=0;
fast=0;
show=0;


/* */
/*  */
