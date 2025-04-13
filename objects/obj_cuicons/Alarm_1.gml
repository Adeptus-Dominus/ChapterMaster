
global.custom_icons=0;

if (string_count("custom",obj_ini.icon_name)>0){
    var cusl;cusl=string_replace(obj_ini.icon_name,"custom","");cusl=real(cusl);
    if (cusl>0) then custom_using=cusl;
    
    var i;i=-1;
    repeat(300){i+=1;
        if (spr_custom[i]!=0) and (sprite_exists(spr_custom_icon[i])){
            if (file_exists(working_directory + "\\icons\\custom"+string(i)+".png")){
                sprite_delete(spr_custom_icon[i]);spr_custom_icon[i]=-1;spr_custom[i]=0;
            }
        }
    }
    
    global.custom_icons=0;
    
    if (custom_using>0){
        var i;i=0;spr_custom[0]=0;spr_custom_icon[0]=0;
        repeat(300){i+=1;spr_custom[i]=0;spr_custom_icon[i]=-1;
            if (file_exists(working_directory + "\\icons\\custom"+string(i)+".png")) and (i=custom_using){
                global.custom_icons+=1;spr_custom[i]=1;
                spr_custom_icon[i]=sprite_add(working_directory + "\\icons\\custom"+string(i)+".png",1,0,0,0,0);
            }
        }
    }
}
if (string_count("custom",obj_ini.icon_name)=0){
    var i;i=0;
    repeat(300){i+=1;
        if (spr_custom[i]!=0) and (i!=custom_using) and (sprite_exists(spr_custom_icon[i])){
            if (file_exists(working_directory + "\\icons\\custom"+string(i)+".png")){
                sprite_delete(spr_custom_icon[i]);spr_custom_icon[i]=-1;spr_custom[i]=0;
            }
        }
    }
}



