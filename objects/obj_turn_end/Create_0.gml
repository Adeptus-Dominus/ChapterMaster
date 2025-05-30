
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

current_battle=1;
current_audience=0;
current_popup=0;

fast=0;// This is increased, once the alert[i]=1 and >=fast then it begins to fade in and get letters
info_mahreens=0;
info_vehicles=0;

first_x=obj_controller.x;// Return to this position once all the battles are done
first_y=obj_controller.y;
combating=0;
cooldown=10;

obj_controller.menu=999;// show nothing, click nothing

i=-1;repeat(11){i+=1;enemy_fleet[i]=0;allied_fleet[i]=0;ecap[i]=0;efri[i]=0;eesc[i]=0;acap[i]=0;afri[i]=0;aesc[i]=0;}

i=-1;
repeat(91){
    i+=1;
    
    popup[i]=0;
    popup_type[i]="";
    popup_text[i]="";
    popup_image[i]="";
    popup_special[i]="";
    
    alert[i]=0;
    alert_type[i]="";
    alert_text[i]="";
    
    alert_char[i]=0;
    alert_alpha[i]=0;
    alert_txt[i]="";
    alert_color[i]="";
    
    battle[i]=0;// Set to 0 for none, 1 for battle to do, and 2 for resolved
    battle_location[i]="";
    battle_world[i]=0;// Be like -50 for space battle
    battle_opponent[i]=0;// faction ID
    battle_object[i]=0;// faction object for the fleets
    battle_pobject[i]=0;// player object for the fleets
    battle_special[i]="";
    
    
    if (i<16) then strin[i]="";
    if (i<16){
        audien[i]=0;
        audien_topic[i]="";
    }
    
    
    
    
}

audiences = 0;
audience = 0;
audien[0]=0;audien[1]=0;audien[2]=0;audien[3]=0;audien[4]=0;audien[5]=0;
audien[6]=0;audien[7]=0;audien[8]=0;audien[9]=0;audien[10]=0;audien[11]=0;
audien_topic[0]="";audien_topic[1]="";audien_topic[2]="";audien_topic[3]="";audien_topic[4]="";audien_topic[5]="";
audien_topic[6]="";audien_topic[7]="";audien_topic[8]="";audien_topic[9]="";audien_topic[10]="";audien_topic[11]="";





alert_alpha[1]=0.2;
alert_char[1]=1;

var i;i=0;
repeat(11){i+=1;
    if (obj_controller.audien[i]!=0){audiences+=1;audien[audiences]=obj_controller.audien[i];audien_topic[audiences]=obj_controller.audien_topic[i];}
}i=0;// LOLOLOLOLOL


repeat(99){i+=1;
    if (obj_controller.event[i]!="") and (obj_controller.event_duration[i]=1) and (obj_controller.faction_status[eFACTION.Imperium]!="War"){
        if (obj_controller.event[i]="governor_assassination_1"){
            with(obj_star){var o;o=0;repeat(4){o+=1;if (dispo[o]>0) and (dispo[o]<90) then dispo[o]=max(dispo[o]-2,0);}}
            obj_controller.disposition[2]-=7;obj_controller.disposition[4]-=10;obj_controller.disposition[5]-=4;
            if (obj_controller.disposition[4]<=0) or (obj_controller.disposition[2]<=0) then obj_controller.alarm[8]=1;
            if (obj_controller.disposition[4]>0) and (obj_controller.disposition[2]>0){
                var top;top=string_replace(obj_controller.event[i],"governor_assassination_1","assassination_angryish");
                scr_audience(4,top,0,"",0,0);
            }
        }
        if (string_count("governor_assassination_2",obj_controller.event[i])>0) and (obj_controller.faction_status[eFACTION.Inquisition]!="War"){
            with(obj_star){var o;o=0;repeat(4){o+=1;if (dispo[o]>0) and (dispo[o]<90) then dispo[o]=max(dispo[o]-4,0);}}
            obj_controller.disposition[2]-=15;obj_controller.disposition[4]-=30;obj_controller.disposition[5]-=10;
            if (obj_controller.disposition[4]<=0) or (obj_controller.disposition[2]<=0) then obj_controller.alarm[8]=1;
            if (obj_controller.disposition[4]>0) and (obj_controller.disposition[2]>0){
                var top;top=string_replace(obj_controller.event[i],"governor_assassination_2","assassination_angry");
                scr_audience(4,top,0,"",0,0);
            }
        }
    }
}i=0;






if (audiences>0){// This is a one-off change all messages to declare war
    var i;i=0;
    var war;repeat(11){i+=1;war[i]=0;}
    
    i=0;
    repeat(10){i+=1;
        if (audien_topic[i]!="declare_war") and (audien_topic[i]!="gene_xeno") and (audien_topic[i]!="") and (war[audien[i]]=1) and (audien[i]!=10){
            audien[i]=obj_controller.audien[i+1];
            audien_topic[i]=obj_controller.audien_topic[i+1];
            audien[i+1]=0;
            audien_topic[i+1]="";
            audiences-=1;
        }
        
        // show_message(string(audien_topic[i])+"|"+string(war[audien[i]])+"|"+string(obj_controller.faction_status[self.audien[i]]));
        
        if (audien_topic[i]!="declare_war") and (audien_topic[i]!="gene_xeno") and (audien_topic[i]!="") and (war[audien[i]]=0) and (obj_controller.faction_status[self.audien[i]]!="War") and (audien[i]!=10){
            if (obj_controller.disposition[self.audien[i]]<=0) and (audien[i]<6){
                /*obj_controller.audien[i]=obj_controller.audien[i+1];
                obj_controller.audien_topic[i]=obj_controller.audien_topic[i+1];
                obj_controller.audien[i+1]=0;
                obj_controller.audien_topic[i+1]="";
                audiences-=1;*/
                audien_topic[i]="declare_war";
                war[audien[i]]=1;
            }
        }
        
        /*if (obj_controller.audien_topic[i]!="declare_war") and (obj_controller.disposition[obj_controller.audien[i]]<=0) and (war[i]=0) and (obj_controller.faction_status[obj_controller.audien[i]]!="War"){
            war[i]=1;obj_controller.audien_topic[i]="declare_war";
        }*/
    }
}
var i;i=0;
if (audiences>0){
    repeat(10){i+=1;
        if (audien_topic[i]="") and (audien_topic[i+1]!=""){
            audien_topic[i]=audien_topic[i+1];
        }
    }
}





alerts=0;
fast=0;
show=0;


/* */
/*  */
