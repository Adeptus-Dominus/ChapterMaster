
if (!instance_exists(obj_cuicons)){
    global.custom_icons=4;
    instance_create(0,0,obj_cuicons);
}

global.save_version=0;
global.cheat_req=false;
global.cheat_gene=false;
global.cheat_disp=false;
global.cheat_debug=false;
global.language="en";


window_data="fullscreen";
window_old="fullscreen";


global.restart=0;
global.debug=0;
last_legal=0;
legal_text="This game is an unofficial nonprofit parody. It is in no way sponsored or approved by Games Workshop Limited. The content is for the exclusive use of the player and should not be sold, rented, or used for any commercial enterprise in any way, shape or form. We make no claim to any characters, names, logos, situations that are trademarked, copyrighted or otherwise protected by federal, state or other intellectual property law. This work is produced solely for the personal, uncompensated enjoyment of Warhammer 40,000 fans. No money is being made and no copyright or trademark infringement is intended.";
smoke=0;
crap=0;
menu=0;

ini_open("saves.ini");
last_legal = ini_read_real("Data", "legal", 0);
master_volume=ini_read_real("Settings","master_volume",1);
effect_volume=ini_read_real("Settings","effect_volume",1);
music_volume=ini_read_real("Settings","music_volume",1);
large_text=ini_read_real("Settings","large_text",0);
settings_heresy=ini_read_real("Settings","settings_heresy",0);
settings_fullscreen=ini_read_real("Settings","fullscreen",1);
settings_window_data=ini_read_string("Settings","window_data","fullscreen");
ini_close()

/*if (window_get_fullscreen()=1) and (settings_fullscreen=0){
    window_set_fullscreen(false);
    window_old=string(window_get_x())+"|"+string(window_get_y())+"|"+string(window_get_width())+"|"+string(window_get_height())+"|";
    
    if (window_old!=settings_window_data){
        var temp1,temp2,temp3,temp4;temp1=0;temp2=0;temp3=0;temp4=0;
        explode_script(settings_window_data,"|");
        temp1=real(explode[0]);temp2=real(explode[1]);temp3=real(explode[2]);temp4=real(explode[3]);
        
        window_set_position(temp1,temp2);
        window_set_size(temp3,temp4);
        window_set_position(temp1,temp2);
        window_set_position(temp1,temp2);
    }
}*/
if (window_get_fullscreen()=0) and (settings_fullscreen=0){
    window_old=string(window_get_x())+"|"+string(window_get_y())+"|"+string(window_get_width())+"|"+string(window_get_height())+"|";
    
    if (window_old!=settings_window_data){
        var temp1,temp2,temp3,temp4;temp1=0;temp2=0;temp3=1600;temp4=900;
        
        if (string_count("|",settings_window_data)>=4){
            explode_script(settings_window_data,"|");
            temp1=real(explode[0]);temp2=real(explode[1]);temp3=real(explode[2]);temp4=real(explode[3]);
            window_set_position(temp1,temp2);
            window_set_size(temp3,temp4);
            window_set_position(temp1,temp2);
            window_set_position(temp1,temp2);
        }
        if (string_count("|",settings_window_data)<4){
            temp1=0;temp2=0;temp3=1600;temp4=900;
            ini_open("saves.ini");
            window_old=string(temp1)+"|"+string(temp2)+"|"+string(temp3)+"|"+string(temp4)+"|";
            settings_window_data=ini_write_string("Settings","window_data",string(temp1)+"|"+string(temp2)+"|"+string(temp3)+"|"+string(temp4)+"|");
            window_set_position(temp1,temp2);
            window_set_size(temp3,temp4);
            window_set_position(temp1,temp2);
            window_set_position(temp1,temp2);
            ini_close();
        }
    }
}
if (window_get_fullscreen()=0) and (settings_fullscreen=1){
    window_old="fullscreen";
    window_set_fullscreen(true);
}


// Print legal disclaimer every month
var t, mont;
t=date_current_datetime();
mont=date_get_month(t);
ini_open("saves.ini");
ini_write_real("Data", "legal", mont);
ini_close();

if (mont>last_legal) or ((last_legal=12) and (mont=1)) then last_legal=0;


audio_stop_all();
global.sound=audio_play_sound(snd_legal,0,true);
var nope;nope=0;if (master_volume=0) or (music_volume=0) then nope=1;
if (nope!=1){audio_sound_gain(global.sound,0.75*master_volume*music_volume,2000);}
if (nope=1) then audio_sound_gain(global.sound,0,0);

randomize();
fade=80;
away=0;
hi=0;
info=0;
global.load=-1;
cooldown=0;
browser=0;
something_version=0;

thought=scr_thought();
async_ini = http_get( "http://planetofthebrandons.com/other/pass.ini" ); // RIP - lost to the void forever it seems
blog_url="Error";
word_from_duke="blank"; // Duke joined the Silent Sisters confirmed?
word_from_duke2="blank";
mess_alpha=0;
out_of_date=0;

stage=0;
if (last_legal=0) then stage=1;
if (last_legal!=0){alarm[2]=1;stage=2;tim1=-50;tim2=424;}
obj_cursor.image_alpha=0;

// show_message(string(last_legal)+", stage: "+string(stage));

tim1=0;
tim2=0;
tim3=0;
tim4=0;
tim5=0;

// TODO: maybe replace the OG debug_log.ini with something like this.
// if (!directory_exists("SessionLogs")) {
//     directory_create("SessionLogs");
// }
// var _date_time = $"{current_day}-{current_month}-{current_year}_{current_hour}{current_minute}{current_second}";
// global.session_log_file = file_text_open_write("SessionLogs/" + $"session_{_date_time}.log");
// file_text_close(global.session_log_file);


/* */
action_set_alarm(1, 3);
action_set_alarm(30, 4);
/*  */
