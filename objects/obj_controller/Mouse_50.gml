// This script handles left click interactions throught the main menus of the game
var xx, yy;
xx=__view_get( e__VW.XView, 0 );
yy=__view_get( e__VW.YView, 0 );

if (trading>0) and (force_goodbye!=0) then trading=0;

// ** Reclusium Jail Marines**
if (menu==12) and (cooldown<=0) and (penitorium>0){
    var behav=0,r_eta=0,re=0;
    for(var qp=1; qp<=min(36,penitorium); qp++){
        if (qp<=penitorium) and (mouse_y>=yy+100+((qp-1)*20)) and (mouse_y<yy+100+(qp*20)){
            if (mouse_x>=xx+1433) and (mouse_x<xx+1497){
                cooldown=20;
                var c=penit_co[qp],e=penit_id[qp];

                if (obj_ini.role[c,e]==obj_ini.role[100][eROLE.ChapterMaster]){
                    tek="c";
                    alarm[7]=5;
                    global.defeat=3;
                }
                // TODO Needs to be based on role
                kill_and_recover(c,e);
                diplo_char=c;
                with(obj_ini){
                    scr_company_order(obj_controller.diplo_char);
                }
                re=1;
                diplo_char=0;
            }
            if (mouse_x>=xx+1508) and (mouse_x<xx+1567){
                cooldown=20;
                var c=penit_co[qp],e=penit_id[qp];
                obj_ini.god[c,e]-=10;
                re=1;
            }
        }
    }
    if (re==1){
        for(var g=1; g<=100; g++){
            penit_co[g]=0;
            penit_id[g]=0;
        }
        penitorium=0;
        var p=0;
        for (var c = 0; c < 11; c++){
            for (var e = 0; e < array_length(obj_ini.god[c]); e++){
                if (obj_ini.god[c,e] == 10){
                    p+=1;
                    penit_co[p]=c;
                    penit_id[p]=e;
                    penitorium+=1;
                }
            }
        }
    }
}

// ** Recruitement **
else if (menu==15) and (cooldown<=0){
    if (mouse_x>=xx+748) and (mouse_x<xx+772){
        if (mouse_y>=yy+355) and (mouse_y<yy+373) and (recruiting<1) and (gene_seed>0) and (obj_ini.doomed==0) and (penitent==0){
            cooldown=8000;
            recruiting+=1;
            scr_income();
        }
        if (mouse_y>=yy+395) and (mouse_y<yy+413) and (training_apothecary<6){
            cooldown=8000;
            training_apothecary+=1;
            scr_income();
        }
        if (mouse_y>=yy+415) and (mouse_y<yy+433) and (training_chaplain<6) and (global.chapter_name!="Space Wolves") and (global.chapter_name!="Iron Hands"){
            cooldown=8000;
            training_chaplain+=1;
            scr_income();
        }
        if (mouse_y>=yy+435) and (mouse_y<yy+452) and (training_psyker<6) and (!scr_has_disadv("Psyker Intolerant")){
            cooldown=8000;
            training_psyker+=1;
            scr_income();
        }
        if ((mouse_y >= yy + 455) && (mouse_y < yy + 473) && (training_techmarine < 6)) {
            cooldown = 8000;
            if (obj_controller.faction_status[eFACTION.Mechanicus] != "War") {
                var _chapter_tech_count = scr_role_count("Techmarine", "");
                if (_chapter_tech_count >= ((disposition[3] / 2) + 5)) {
                    training_techmarine = 0;
                }
                if (_chapter_tech_count < ((disposition[3] / 2) + 5)) {
                    training_techmarine += 1;
                    scr_income();
                }
            } else {
                training_techmarine += 1;
                scr_income();
            }
        }
    }
    if (mouse_x>=xx+726) and (mouse_x<xx+745){
        if (mouse_y>=yy+355) and (mouse_y<yy+373) and (recruiting>0){
            cooldown=8000;
            recruiting-=1;
            scr_income();
        }
        if (mouse_y>=yy+395) and (mouse_y<yy+413) and (training_apothecary>0){
            cooldown=8000;
            training_apothecary-=1;
            scr_income();
        }
        if (mouse_y>=yy+415) and (mouse_y<yy+433) and (training_chaplain>0){
            cooldown=8000;
            training_chaplain-=1;
            scr_income();
        }
        if (mouse_y>=yy+435) and (mouse_y<yy+452) and (training_psyker>0){
            cooldown=8000;
            training_psyker-=1;
            scr_income();
        }
        if (mouse_y>=yy+455) and (mouse_y<yy+473) and (training_techmarine>0){
            cooldown=8000;
            training_techmarine-=1;
            scr_income();
        }
    }
    // Change trial type

    if (mouse_y>=yy+518) and (mouse_y<=yy+542){
        var onceh=0;
        if (mouse_x>=xx+713) and (mouse_x<=xx+752){
            cooldown=8000;
            recruit_trial++;
            if (recruit_trial==eTrials.num) then recruit_trial=0;
        }
        if (mouse_x>=xx+492) and (mouse_x<=xx+528){
            cooldown=8000;
            recruit_trial--;
            if (recruit_trial<0) then recruit_trial=eTrials.num-1;
        }
    }
}
// ** Fleet count **
// Moved to scr_fleet_advisor();
/* if (menu==16) and (cooldown<=0){
    var i=ship_current;
    for(var j=0; j<34; j++){
        i+=1;
        if (obj_ini.ship[i]!="") and (mouse_x>=xx+953) and (mouse_x>=yy+84+(i*20)) and (mouse_x<xx+969) and (mouse_y<yy+100+(i*20)){
            temp[40]=obj_ini.ship[i];
            with(obj_p_fleet){
                for(var k=1; k<=40; k++){
                    if (capital[k]==obj_controller.temp[40]) then instance_create(x,y,obj_temp7);
                    if (frigate[k]==obj_controller.temp[40]) then instance_create(x,y,obj_temp7);
                    if (escort[k]==obj_controller.temp[40]) then instance_create(x,y,obj_temp7);
                }
            }
            if (instance_exists(obj_temp7)){
                x=obj_temp7.x;
                y=obj_temp7.y;
                cooldown=8000;
                menu=0;
                with(obj_fleet_show){instance_destroy();}
                instance_create(obj_temp7.x,obj_temp7.y,obj_fleet_show);
                with(obj_temp7){instance_destroy();}
            }
        }
    }
} */


// ** Diplomacy **
if (menu==MENU.Diplomacy) and (diplomacy>0) or ((diplomacy<-5) and (diplomacy>-6)) and (cooldown<=0) and (diplomacy<10){
    if (trading==0) and (valid_diplomacy_options()){
        if (force_goodbye==0) and (cooldown<=0){

        }
        if (force_goodbye!=0) and (cooldown<=0){// Want to check to see if the deal went fine here
            if (trading_artifact!=0){
                click2=1;
                clear_diplo_choices();
                diplomacy=0;
                menu=0;
                force_goodbye=0;
                with(obj_popup){instance_destroy();}
                if (trading_artifact!=2) then obj_ground_mission.alarm[1]=1;
                if (trading_artifact==2) then obj_ground_mission.alarm[2]=1;
                exit;
            }
        }
    }
}
// Diplomacy
if (zoomed==0) and (cooldown<=0) and (menu==MENU.Diplomacy) and (diplomacy==0){
    xx+=55;
    yy-=20;
	var onceh=0
	// Daemon emmissary
    if (point_in_rectangle(mouse_x, mouse_y, xx+688,yy+181,xx+1028,yy+281)){
		diplomacy=10.1;
        diplomacy_pathway="intro";
        scr_dialogue(diplomacy_pathway);
        onceh=1;
        cooldown = 1;
	}
}


        // End Turn
scr_menu_clear_up(function(){  
    if (zoomed==0) and (menu==40) and (cooldown<=0){
        xx=xx+0;
        yy=yy+0;

        if (mouse_x>=xx+73) and (mouse_y>=yy+69) and (mouse_x<xx+305) and (mouse_y<yy+415){
            menu=41;
            cooldown=8000;
        }
        if (mouse_x>=xx+336) and (mouse_y>=yy+69) and (mouse_x<xx+568) and (mouse_y<yy+415){
            menu=42;
            cooldown=8000;
        }
    }

    // This is the back button at LOADING TO SHIPS
    if (zoomed==0) and (menu==30) and (managing>0||managing==-1) and (cooldown<=0){
        xx=xx+0;
        yy=yy+0;

        if (mouse_x>=xx+22) and (mouse_y>=yy+84) and (mouse_x<xx+98) and (mouse_y<yy+126){
            menu=1;
            cooldown=8000;
        }
    }
    // Selecting individual marines
    if (menu=1) and (managing>0) || (managing<0) and (!view_squad || !company_report){
        var unit;                 
        var eventing=false, bb="";
        xx=__view_get( e__VW.XView, 0 )+0;
        yy=__view_get( e__VW.YView, 0 )+0;
        var top=man_current,sel,temp1="",temp2="",temp3="",temp4="",temp5="", squad_sel=0;
        var stop=0;

        if (man_size==0) then alll=0;

        if (cooldown<=0){
            // selecting all
            if (point_in_rectangle(mouse_x,mouse_y,xx+1281,yy+607,xx+1409,yy+636)){
                cooldown=8;
                if (alll==0){
                    scr_load_all(true);
                    selecting_types="%!@";
                } else if (alll==1){
                    scr_load_all(false);
                    selecting_types="";
                }
            } 

        }

    }
    if (menu==50) and (managing>0) and (cooldown<=0){
        if (mouse_x>=xx+217) and (mouse_y>=yy+28) and (mouse_x<xx+250) and (mouse_y<yy+59){
            cooldown=8;
            menu=1;
            click=1;
        }
    }
});
