


//TODO make enum to store menu area codes
function scr_menu_clear_up(specific_area_function){
	var spec_func = specific_area_function;
	with(obj_controller){
		var menu_action_allowed = (action_if_number(obj_saveload, 0, 0) &&
				    action_if_number(obj_drop_select, 0, 0) &&
				    action_if_number(obj_popup_dialogue, 0, 0) &&
				    action_if_number(obj_ncombat, 0, 0));

		if (menu_action_allowed){
		    if (combat!=0) then exit;
		    if (scrollbar_engaged!=0) then exit;
		    if (instance_exists(obj_ingame_menu)) then exit;


		    if (instance_exists(obj_turn_end)) and (obj_controller.complex_event!=true) and (!instance_exists(obj_temp_meeting)){
		        if (obj_turn_end.popups_end==1) and (audience==0) and (cooldown<=0) then with(obj_turn_end){instance_destroy();}
		    }
		    if (instance_exists(obj_turn_end)) and (audience==0) then exit;
		    if (instance_exists(obj_star_select)) then exit;
		    if (instance_exists(obj_bomb_select)) then exit;

		    if (zoomed==0) and (cooldown<=0) and (menu>=500) and (menu<=510){

		        if (mouse_y>=__view_get( e__VW.YView, 0 )+27){
		            cooldown=8000;
		            if (menu>=500) and (temp[menu-434]=""){
		                menu=0;
		                exit;
		            }
		            if (menu<503) and (menu!=0) then menu+=1;
		        }
		    }

		    if (menu>=500) then exit;

		    var zoomeh=0,diyst=999;
		    xx=__view_get( e__VW.XView, 0 );
		    yy=__view_get( e__VW.YView, 0 );
		    zoomeh=zoomed;

		    if (menu==0) then hide_banner=0;// 136 ;

		    if (instance_exists(obj_temp_build)){
		        if (obj_temp_build.isnew==1) then exit;
		    }
			return spec_func(); 
		}
	}
	return false;
}


function scr_change_menu(specific_area_function){
	var continue_sequence = false;
	with (obj_controller){
		set_zoom_to_default();
		continue_sequence = scr_menu_clear_up(function(){
			if (zoomed==0)  && (diplomacy==0){
				return true;
			}  
		});
		if (continue_sequence){
			with(obj_fleet_select){instance_destroy();}
			with(obj_popup){instance_destroy();}
			specific_area_function(); 
		}		
	}
}

function scr_in_game_help(){
	scr_change_menu(function(){
		with (obj_controller){
			if (zoomed == 0) and (!instance_exists(obj_ingame_menu)) and (!instance_exists(obj_popup)){
				set_zoom_to_default();
				if (menu!=17.5){
					menu=17.5;
					cooldown=8000;
					click=1;
					hide_banner=0;
					instance_activate_object(obj_event_log);
					obj_event_log.top=1;
					obj_event_log.help=1;
				} else {
					menu=0;
					click=1;
					hide_banner=0;
				}
				managing=0;
				view_squad=false;
				unit_profile=false;
			}	
	}});
}
function scr_in_game_menu(){
	scr_change_menu(function(){
		if (!instance_exists(obj_ingame_menu)) and (!instance_exists(obj_popup)) and (!obj_controller.zoomed){
			// Main Menu
			with (obj_controller) {
				menu=0;
				hide_banner=0;
				location_viewer.update_garrison_log();
				managing=0;
			}
			set_zoom_to_default();
			instance_create(0,0,obj_ingame_menu);
		}
	});
}
function scr_toggle_manage(){
    scr_change_menu(function(){
    	with (obj_controller){
		    if (menu!=1){
		    	view_squad=false;
		        scr_management(1);
		        menu=1;
		        popup=0;
		        selected=0;
		        hide_banner=1;
		    }
		    else if (menu==1){
		        menu=0;
		        hide_banner=0;
		        location_viewer.update_garrison_log();
		    }
		    managing=0;
		}
	});
}

function scr_toggle_setting(){
	scr_change_menu(function(){
		with (obj_controller){
        if (menu!=21){
            menu=21;
            popup=0;
            selected=0;
            hide_banner=1;
        }
        else if (menu==21){
            if (!settings) {
                menu=0;
                cooldown=8000;
                click=1;
                hide_banner=0;
            }
            else if (settings) {
                menu=21;
                cooldown=8000;
                click=1;
                settings=0;
            }
        }
    }
    });
}
function scr_toggle_apothecarion(){
	scr_change_menu(function(){
		with (obj_controller){
        menu_adept=0;
        hide_banner=1;
        if (scr_role_count("Master of the Apothecarion","0")==0) then menu_adept=1;
        if (menu!=11){
            menu=11;
            
            temp[36]=scr_role_count(obj_ini.role[100][15],"");
        }
        else if (menu==11){
            menu=0;
            
        }
        managing=0;
    }
	});
}

function scr_toggle_reclu(){
	scr_change_menu(function(){
		with (obj_controller){
        menu_adept=0;
        hide_banner=1;
        if (scr_role_count("Master of Sanctity","0")==0) then menu_adept=1;
        if (menu!=12){
            menu=12;
            
            temp[36]=string(scr_role_count(obj_ini.role[100][14],"field"));
            temp[37]=string(scr_role_count(obj_ini.role[100][14],"home"));
            penitorium=0;

            // Get list of jailed marines
            var p=0;
            for(var c=0; c<11; c++){
                for(var e=0; e<array_length(obj_ini.name[c]); e++){
                    if (obj_ini.god[c][e]>=10){
                        p+=1;
                        penit_co[p]=c;
                        penit_id[p]=e;
                        penitorium+=1;
                    }
                }
            }
        }
        else if (menu==12){
            menu=0;
            
            location_viewer.update_garrison_log();
        }
        managing=0;
    }
	});
}

function scr_toggle_lib(){
	scr_change_menu(function(){
		with (obj_controller){
		menu_adept=0;
        hide_banner=1;
        if (scr_role_count("Chief "+string(obj_ini.role[100][17]),"0")==0) then menu_adept=1;
        if (menu!=13){
            menu=13;
            
            if (artifacts>0) and (menu_artifact==0) then menu_artifact=1;
            temp[36]=scr_role_count(obj_ini.role[100][17],"");
            temp[37]=scr_role_count("Codiciery","");
            temp[38]=scr_role_count("Lexicanum","");
            artifact_equip = new ShutterButton();
            artifact_gift = new ShutterButton();
            artifact_destroy = new ShutterButton();
            artifact_namer = new TextBarArea(xx + 622, yy + 460, 350);
            set_chapter_arti_data();
        }
        else if (menu==13){
            menu=0;
            
            location_viewer.update_garrison_log();
        }
        managing=0;
    }
	});
}

function scr_toggle_armamentarium(){
	scr_change_menu(function(){
		with (obj_controller){
        menu_adept=0;
        hide_banner=1;
        if (scr_role_count("Forge Master","0")==0) then menu_adept=1;
        if (menu!=14) {
            set_up_armentarium();
        }else if (menu==14){
            menu=0;
            
        }
        managing=0;
    }
	});
}

function scr_toggle_recruiting(){
	scr_change_menu(function(){
		with (obj_controller){
        var geh=0,good=0;
        for(geh=1; geh<=50; geh++){
            geh+=1;
            if (good==0){
                if (obj_ini.role[10,geh]==obj_ini.role[100][5]) and (obj_ini.name[10,geh]==obj_ini.recruiter_name) then good=geh;
            }
        }
        menu_adept=0;
        hide_banner=1;

        if (menu!=15) {
            set_up_recruitment_view();
        } else if (menu==15){
            menu=0;
            
            location_viewer.update_garrison_log();
        }

        managing=0;	
        }	
	});
}

function scr_toggle_fleet_area(){
	scr_change_menu(function(){
		with (obj_controller){
		menu_adept=0;
	    hide_banner=1;
	    var geh=0,good=0;
	    for(geh=1; geh<=50; geh++){
	        if (good==0){
	            if (obj_ini.role[4,geh]=obj_ini.role[100][5]) and (obj_ini.name[10,geh]=obj_ini.lord_admiral_name) then good=geh;
	        }
	    }
	    if (menu!=16){
	    	//TODO rewrite all this shit when fleets finally become OOP
	        menu=16;
	        
	        cooldown=8000;
	        click=1;
	        for (var i=37;i<=41;i++){
	        	temp[i] = "";
	        }

	        for(var i=101;i<120;i++){
	             temp[i]="";
	        }

	        var g=0,u=0,m=0,d=0;
	        temp[37] = 0;
	        temp[38] = 0;
	        temp[39] = 0;
	        for(var i=0; i<array_length(obj_ini.ship); i++){
	            if (obj_ini.ship[i]!=""){
	            	if (obj_ini.ship_size[i]==3) then temp[37]++;
	            	if (obj_ini.ship_size[i]==2) then temp[38]++;
	            	if (obj_ini.ship_size[i]==1) then temp[39]++;
	            }
	        }

	        g=0;
	        temp[41]="1";
	        for (var i=0; i<array_length(obj_ini.ship); i++){
	            if (g!=0) and (obj_ini.ship[i]!=""){
	                if ((obj_ini.ship_hp[i]/obj_ini.ship_maxhp[i])<u){
	                    g=i;
	                    u=obj_ini.ship_hp[i]/obj_ini.ship_maxhp[i];
	                }
	            }
	            if (g==0) and (obj_ini.ship[i]!=""){
	                g=i;
	                u=obj_ini.ship_hp[i]/obj_ini.ship_maxhp[i];
	            }
	            if (obj_ini.ship[i]!="") then m=i;
	            if (obj_ini.ship[i]!="") and ((obj_ini.ship_hp[i]/obj_ini.ship_maxhp[i])<0.25) then d+=1;
	        }
	        if (g!=0){
	            temp[40]=string(obj_ini.ship_class[g])+" '"+string(obj_ini.ship[g])+"'";
	            temp[41]=string(u);
	            temp[42]=string(d);
	        }
	        man_max=m;
	        man_current=0;
	    }
	    else if (menu==16){
	        menu=0;
	        
	        cooldown=8000;
	        click=1;
	    }
	    managing=0;	
	    }	
	});
}

function scr_toggle_diplomacy(){
	scr_change_menu(function(){
		with (obj_controller){
        if (menu!=20) {
            menu=20;
            
            hide_banner=1;
        }
        else if (menu==20) {
            menu=0;
            
            hide_banner=0;
            location_viewer.update_garrison_log();
        }
        managing=0;
        }		
	});
}

function scr_toggle_event_log(){
	scr_change_menu(function(){
		with (obj_controller){
        if (menu!=17){
            menu=17;
            
            hide_banner=1;
            instance_activate_object(obj_event_log);
            obj_event_log.top=1;
        }
        else if (menu==17){
            menu=0;
            
            hide_banner=0;
        }
        managing=0;
    }
	});
}

function scr_end_turn(){
	scr_change_menu(function(){
		with (obj_controller){
		if (menu==0) and (cooldown<=0){
	        if (location_viewer.hide_sequence==0){
	            location_viewer.hide_sequence++;
	        }
	        cooldown=8;
	        menu=0;

	        if (!instance_exists(obj_turn_end)) then ok=1;
	        if (instance_exists(obj_turn_end)){if (obj_turn_end.popups_end==1) then ok=1;}

	        if (ok==1){
	            obj_controller.end_turn_insights = {};
	            with(obj_turn_end){instance_destroy();}
	            with(obj_star_event){instance_destroy();}
	            cooldown=8;
	            audio_play_sound(snd_end_turn,-50,0);
	            audio_sound_gain(snd_end_turn,master_volume*effect_volume,0);

	            turn+=1;
	            with(obj_star){
	                for (var i=0;i<=21;i++){
	                    present_fleet[i]=0;
	                }
	            }
	            with(obj_p_fleet){
	                if (action=="move") and (obj_controller.faction_status[eFACTION.Imperium]=="War"){
	                    var him=instance_nearest(action_x,action_y,obj_star);
	                    if (point_distance(action_x,action_y,him.x,him.y)<10){
	                        him.present_fleet[20]=1;
	                    }
	                }
	            }
	            with(obj_en_fleet){
	                if (action=="move") and (owner>5){
	                    var him=instance_nearest(action_x,action_y,obj_star);
	                    if (point_distance(action_x,action_y,him.x,him.y)<10){
	                        him.present_fleet[20]=1;
	                    }
	                }
	            }

	            if (instance_exists(obj_p_fleet)){obj_p_fleet.alarm[1]=1;}
	            if (instance_exists(obj_en_fleet)){obj_en_fleet.alarm[1]=1;}
	            if (instance_exists(obj_crusade)){obj_crusade.alarm[0]=2;}

	            player_forge_data.player_forges=0;
	            requisition+=income;
	            scr_income();
	            gene_tithe-=1;

	            // Do that after the combats and all of that crap
	            with(obj_star){
	                ai_a=2;
	                ai_b=3;
	                ai_c=4;
	                ai_d=5;
	                ai_e=5;
	                if (p_type[1]=="Craftworld"){
	                    instance_deactivate_object(id);
	                }
	            }
	            alarm[5]=6;
	            instance_create(0,0,obj_turn_end);
	            scr_turn_first();
	        }
	    }

	    if (menu==1){
	        menu=0;	        
	        cooldown=8000;
	        click=1;
	        hide_banner=0;
	    }
	    managing=0;
	    /*with(obj_ini){
	        for (var i=0;i<11;i++){
	            scr_company_order(i);
	        }
	    }*/
	    location_viewer.update_garrison_log();
	}
	});	
}
