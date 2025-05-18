
scr_image("loading",-50,0,0,0,0);
GameSave = {};
GameSave.Stars = [];
GameSave.PlayerFleet = [];
GameSave.EnemyFleet = [];
GameSave.Ini = {};
GameSave.Controller = {};
GameSave.EventLog = [];

menu=0;// 1 : save, 2: load
save_part=0;
load_part=0;
save_number=0;
/// set to true before calling alarm[0] to run autosave behaviour
autosaving=false;
/// number of frames between load sections to draw the progress bar
trickle=0;
txt="";
hide=0;
bar=0;
slow=0;
saves=0;
highlighting=0;
spr_screen=0;
first_open=0;
max_ini=0;
reset=0;
splash=choose(0,1,2,3,4);

debug="";

top=0;

if (instance_exists(obj_controller)) {
    if (obj_controller.zoomed == 1) {
        with (obj_controller) {
            scr_zoom();
        }
    }
}

save = array_create(201, -1);
save_turn = array_create(201, 0);
save_chapter = array_create(201, "");
save_master = array_create(201, "");
save_marines = array_create(201, 0);
save_date = array_create(201, "");
save_time = array_create(201, 0);
screen_exists = array_create(201, false);
spr_screen = array_create(201, 0);
save_seed = array_create(201, 0);
save_icon = array_create(201, -1);

saves = 0;

var i = 0;

repeat (100) {
    if (file_exists(string(PATH_save_files, i))) {
        save[saves] = i;
        saves += 1;
    }
    if ((!file_exists(string(PATH_save_files, i))) && (i > 0) && (max_ini == 0)) {
        max_ini = i;
    }
    if (file_exists(string(PATH_save_files, i + 1)) && (max_ini > 0)) {
        max_ini = 0;
    }
    i += 1;
}


first_open=saves;


if (file_exists("saves.ini")){
    ini_open("saves.ini");

    for(var i = 0; i <= 200; i++){
        if (save[i]>=0){
            if (ini_section_exists(string(save[i]))){
                save_turn[save[i]]=ini_read_real(string(save[i]),"turn",0);
                save_chapter[save[i]]=ini_read_string(string(save[i]),"chapter_name","Error");
                save_master[save[i]]=ini_read_string(string(save[i]),"master_name","Error");
                save_marines[save[i]]=ini_read_real(string(save[i]),"marines",0);
                save_date[save[i]]=ini_read_string(string(save[i]),"date","Error");
                save_time[save[i]]=ini_read_real(string(save[i]),"time",0);
                save_seed[save[i]]=ini_read_real(string(save[i]),"seed",0);
                save_icon[save[i]]=ini_read_string(string(save[i]), "icon_name", "unknown");
            }

            if (!ini_section_exists(string(i))){
                save_turn[i]=-50;
                save_chapter[i]="Unknown Save Data";
                save_master[i]="Unknown";
                save_marines[i]=-50;
                save_date[i]="";
                save_time[i]=0;
                save_icon[i]="unknown";
            }
        }
    }

    ini_close();
}
