
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
trickle=0;
txt="";
hide=0;
cooldown=10;
bar=0;
slow=0;
saves=0;
highlighting=0;
spr_screen=0;
first_open=0;
max_ini=0;
mouse_left=0;
reset=0;
splash=choose(0,1,2,3,4);

debug="";

top=1;

if (instance_exists(obj_controller)){
    if (obj_controller.zoomed=1){
        with(obj_controller){scr_zoom();}
    }
}


var i;i=-1;saves=0;
repeat(201){i+=1;
    save[i]=0;save_turn[i]=0;
    save_chapter[i]="";
    save_master[i]="";
    save_marines[i]=0;
    save_date[i]="";
    save_time[i]=0;
    screen_exists[i]=false;
    spr_screen[i]=0;
    save_seed[i]=0;
}
i=0;
repeat(100){i+=1;
    if (file_exists("save"+string(i)+".json")){
        saves+=1;save[saves]=i;
    }
    if (!file_exists("save"+string(i)+".json")) and (i>0) and (max_ini=0) then max_ini=i;
    if (file_exists("save"+string(i+1)+".json")) and (max_ini>0) then max_ini=0;
}
first_open=saves+1;




img1=0;
img2=0;
img3=0;
img4=0;




if (file_exists("saves.ini")){
    ini_open("saves.ini");

    i=-1;
    repeat(200){i+=1;
        if (save[i]>0){
            if (ini_section_exists(string(save[i]))){
                save_turn[save[i]]=ini_read_real(string(save[i]),"turn",0);
                save_chapter[save[i]]=ini_read_string(string(save[i]),"chapter_name","Error");
                save_master[save[i]]=ini_read_string(string(save[i]),"master_name","Error");
                save_marines[save[i]]=ini_read_real(string(save[i]),"marines",0);
                save_date[save[i]]=ini_read_string(string(save[i]),"date","Error");
                save_time[save[i]]=ini_read_real(string(save[i]),"time",0);
                save_seed[save[i]]=ini_read_real(string(save[i]),"seed",0);
                
                /*if (file_exists(working_directory + "\screen"+string(save[i])+".png")){
                    screen_exists[i]=true;
                    spr_screen[save[i]]=sprite_add(working_directory + "\screen"+string(save[save[i]])+".png",1,0,0,0,0);
                }*/
            }
            if (!ini_section_exists(string(i))){
                save_turn[i]=-50;
                save_chapter[i]="Unknown Save Data";
                save_master[i]="Unknown";
                save_marines[i]=-50;
                save_date[i]="";
                save_time[i]=0;
            }
        }
    }
    
    
    if (file_exists(working_directory + "\\screen"+string(save[1])+".png")) then img1=sprite_add(working_directory + "\\screen"+string(save[1])+".png",1,0,0,0,0);
    if (file_exists(working_directory + "\\screen"+string(save[2])+".png")) then img2=sprite_add(working_directory + "\\screen"+string(save[2])+".png",1,0,0,0,0);
    if (file_exists(working_directory + "\\screen"+string(save[3])+".png")) then img3=sprite_add(working_directory + "\\screen"+string(save[3])+".png",1,0,0,0,0);
    if (file_exists(working_directory + "\\screen"+string(save[4])+".png")) then img4=sprite_add(working_directory + "\\screen"+string(save[4])+".png",1,0,0,0,0);
    
    
    ini_close();
}

/* */
/*  */
