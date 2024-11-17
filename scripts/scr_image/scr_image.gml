function scr_image(argument0, argument1, argument2, argument3, argument4, argument5) {

	// argument0: keyword
	// argument1: number
	// argument2: x1
	// argument3: y1
	// argument4: width
	// argument5: height
	//TODO rewrite this file

	if (!instance_exists(obj_img)) then exit;




	if (argument1<=-666) or (argument1=666){with(obj_img){// Clear out these images
	    var i,single_image;i=-1;single_image=false;
    
	    if (argument0="creation") or (argument0="all") or (argument0=""){creation_good=false;single_image=true;}
	    if (argument0="main_splash") or (argument0="existing_splash") or (argument0="other_splash") or (argument0="all") or (argument0="") then splash_good=false;
	    if (argument0="advisor") or (argument0="all") or (argument0="") then advisor_good=false;
	    if (argument0="diplomacy_splash") or (argument0="all") or (argument0="") then diplomacy_splash_good=false;
	    if (argument0="diplomacy_daemon") or (argument0="all") or (argument0="") then diplomacy_daemon_good=false;
	    if (argument0="diplomacy_icon") or (argument0="all") or (argument0=""){diplomacy_icon_good=false;single_image=true;}
	    if (argument0="menu") or (argument0="all") or (argument0=""){menu_good=false;single_image=true;}
	    if (argument0="loading") or (argument0="all") or (argument0="") then loading_good=false;
	    if (argument0="postbattle") or (argument0="all") or (argument0="") then postbattle_good=false;
	    if (argument0="postspace") or (argument0="all") or (argument0="") then postspace_good=false;
	    if (argument0="formation") or (argument0="all") or (argument0="") then formation_good=false;
	    if (argument0="popup") or (argument0="all") or (argument0="") then popup_good=false;
	    if (argument0="commander") or (argument0="all") or (argument0="") then commander_good=false;
	    if (argument0="planet") or (argument0="all") or (argument0="") then planet_good=false;
	    if (argument0="attacked") or (argument0="all") or (argument0="") then attacked_good=false;
	    if (argument0="force") or (argument0="all") or (argument0="") then force_good=false;
	    if (argument0="purge") or (argument0="all") or (argument0="") then purge_good=false;
	    if (argument0="event") or (argument0="all") or (argument0="") then event_good=false;
	    if (argument0="title_splash") or (argument0="all") or (argument0="") then title_splash_good=false;
	    if (argument0="symbol") or (argument0="all") or (argument0="") then symbol_good=false;
	    if (argument0="defeat") or (argument0="all") or (argument0="") then defeat_good=false;
	    if (argument0="slate") or (argument0="all") or (argument0="") then slate_good=false;
    
    
	    repeat(80){i+=1;
    
	        if ((argument0="creation") or (argument0="all") or (argument0="")) and (creation_exists[i]>0) and (sprite_exists(creation[i])){
	            sprite_delete(creation[i]);creation_exists[i]=-1;creation[i]=0;
	        }
	        if ((argument0="main_splash") or (argument0="all") or (argument0="")){
	            if (main_exists[i]>0) and (sprite_exists(main[i])){sprite_delete(main[i]);main_exists[i]=-1;main[i]=0;}
	        }
	        if ((argument0="existing_splash") or (argument0="all") or (argument0="")){
	            if (existing_exists[i]>0) and (sprite_exists(existing[i])){sprite_delete(existing[i]);existing_exists[i]=-1;existing[i]=0;}
	        }
	        if ((argument0="other_splash") or (argument0="all") or (argument0="")){
	            if (others_exists[i]>0) and (sprite_exists(others[i])){sprite_delete(others[i]);others_exists[i]=-1;others[i]=0;}
	        }
	        if ((argument0="advisor") or (argument0="all") or (argument0="")) and (advisor_exists[i]>0) and (sprite_exists(advisor[i])){
	            sprite_delete(advisor[i]);advisor_exists[i]=-1;advisor[i]=0;
	        }
	        if ((argument0="diplomacy_splash") or (argument0="all") or (argument0="")) and (diplomacy_splash_exists[i]>0) and (sprite_exists(diplomacy_splash[i])){
	            sprite_delete(diplomacy_splash[i]);diplomacy_splash_exists[i]=-1;diplomacy_splash[i]=0;
	        }
	        if ((argument0="diplomacy_daemon") or (argument0="all") or (argument0="")) and (diplomacy_daemon_exists[i]>0) and (sprite_exists(diplomacy_daemon[i])){
	            sprite_delete(diplomacy_daemon[i]);diplomacy_daemon_exists[i]=-1;diplomacy_daemon[i]=0;
	        }
	        if ((argument0="diplomacy_icon") or (argument0="all") or (argument0="")) and (diplomacy_icon_exists[i]>0) and (sprite_exists(diplomacy_icon[i])){
	            sprite_delete(diplomacy_icon[i]);diplomacy_icon_exists[i]=-1;diplomacy_icon[i]=0;
	        }
	        if ((argument0="menu") or (argument0="all") or (argument0="")) and (menu_exists[i]>0) and (sprite_exists(menu[i])){
	            sprite_delete(menu[i]);menu_exists[i]=-1;menu[i]=0;
	        }
	        if ((argument0="loading") or (argument0="all") or (argument0="")) and (loading_exists[i]>0) and (sprite_exists(loading[i])){
	            sprite_delete(loading[i]);loading_exists[i]=-1;loading[i]=0;
	        }
	        if ((argument0="postbattle") or (argument0="all") or (argument0="")) and (postbattle_exists[i]>0) and (sprite_exists(postbattle[i])){
	            sprite_delete(postbattle[i]);postbattle_exists[i]=-1;postbattle[i]=0;
	        }
	        if ((argument0="postspace") or (argument0="all") or (argument0="")) and (postspace_exists[i]>0) and (sprite_exists(postspace[i])){
	            sprite_delete(postspace[i]);postspace_exists[i]=-1;postspace[i]=0;
	        }
	        if ((argument0="formation") or (argument0="all") or (argument0="")) and (formation_exists[i]>0) and (sprite_exists(formation[i])){
	            sprite_delete(formation[i]);formation_exists[i]=-1;formation[i]=0;
	        }
	        if ((argument0="popup") or (argument0="all") or (argument0="")) and (popup_exists[i]>0) and (sprite_exists(popup[i])){
	            sprite_delete(popup[i]);popup_exists[i]=-1;popup[i]=0;
	        }
	        if ((argument0="commander") or (argument0="all") or (argument0="")) and (commander_exists[i]>0) and (sprite_exists(commander[i])){
	            sprite_delete(commander[i]);commander_exists[i]=-1;commander[i]=0;
	        }
	        if ((argument0="planet") or (argument0="all") or (argument0="")) and (planet_exists[i]>0) and (sprite_exists(planet[i])){
	            sprite_delete(planet[i]);planet_exists[i]=-1;planet[i]=0;
	        }
	        if ((argument0="attacked") or (argument0="all") or (argument0="")) and (attacked_exists[i]>0) and (sprite_exists(attacked[i])){
	            sprite_delete(attacked[i]);attacked_exists[i]=-1;attacked[i]=0;
	        }
	        if ((argument0="force") or (argument0="all") or (argument0="")) and (force_exists[i]>0) and (sprite_exists(force[i])){
	            sprite_delete(force[i]);force_exists[i]=-1;force[i]=0;
	        }
	        if ((argument0="purge") or (argument0="all") or (argument0="")) and (purge_exists[i]>0) and (sprite_exists(purge[i])){
	            sprite_delete(purge[i]);purge_exists[i]=-1;purge[i]=0;
	        }
	        if ((argument0="event") or (argument0="all") or (argument0="")) and (event_exists[i]>0) and (sprite_exists(event[i])){
	            sprite_delete(event[i]);event_exists[i]=-1;event[i]=0;
	        }
	        if ((argument0="title_splash") or (argument0="all") or (argument0="")){
	            if (title_splash_exists[i]>0) and (sprite_exists(title_splash[i])){sprite_delete(title_splash[i]);title_splash_exists[i]=-1;title_splash[i]=0;}
	        }
	        if ((argument0="symbol") or (argument0="all") or (argument0="")){
	            if (symbol_exists[i]>0) and (sprite_exists(symbol[i])){sprite_delete(symbol[i]);symbol_exists[i]=-1;symbol[i]=0;}
	        }
	        if ((argument0="defeat") or (argument0="all") or (argument0="")){
	            if (defeat_exists[i]>0) and (sprite_exists(defeat[i])){sprite_delete(defeat[i]);defeat_exists[i]=-1;defeat[i]=0;}
	        }
	        if ((argument0="slate") or (argument0="all") or (argument0="")){
	            if (slate_exists[i]>0) and (sprite_exists(slate[i])){sprite_delete(slate[i]);slate_exists[i]=-1;slate[i]=0;}
	        }
        
	    }
    
	}}


	if (argument1>-600) and (argument1<0){with(obj_img){// Initialize these images
    
	    var i,single_image;i=-1;single_image=false;
	    repeat(80){i+=1;
    
	        if (argument0="creation") and (creation_exists[i]>0) and (sprite_exists(creation[i])){
	            sprite_delete(creation[i]);creation_exists[i]=-1;creation[i]=0;
	        }
	        if (argument0="splash"){
	            if (main_exists[i]>0) and (sprite_exists(main[i])){sprite_delete(main[i]);main_exists[i]=-1;main[i]=0;}
	            if (existing_exists[i]>0) and (sprite_exists(existing[i])){sprite_delete(existing[i]);existing_exists[i]=-1;existing[i]=0;}
	            if (others_exists[i]>0) and (sprite_exists(others[i])){sprite_delete(others[i]);others_exists[i]=-1;others[i]=0;}
	        }
	        if (argument0="advisor") and (advisor_exists[i]>0) and (sprite_exists(advisor[i])){
	            sprite_delete(advisor[i]);advisor_exists[i]=-1;advisor[i]=0;
	        }
	        if (argument0="diplomacy_splash") and (diplomacy_splash_exists[i]>0) and (sprite_exists(diplomacy_splash[i])){
	            sprite_delete(diplomacy_splash[i]);diplomacy_splash_exists[i]=-1;diplomacy_splash[i]=0;
	        }
	        if (argument0="diplomacy_daemon") and (diplomacy_daemon_exists[i]>0) and (sprite_exists(diplomacy_daemon[i])){
	            sprite_delete(diplomacy_daemon[i]);diplomacy_daemon_exists[i]=-1;diplomacy_daemon[i]=0;
	        }
	        if (argument0="diplomacy_icon") and (diplomacy_icon_exists[i]>0) and (sprite_exists(diplomacy_icon[i])){
	            sprite_delete(diplomacy_icon[i]);diplomacy_icon_exists[i]=-1;diplomacy_icon[i]=0;
	        }
	        if (argument0="menu") and (menu_exists[i]>0) and (sprite_exists(menu[i])){
	            sprite_delete(menu[i]);menu_exists[i]=-1;menu[i]=0;
	        }
	        if (argument0="loading") and (loading_exists[i]>0) and (sprite_exists(loading[i])){
	            sprite_delete(loading[i]);loading_exists[i]=-1;loading[i]=0;
	        }
	        if (argument0="postbattle") and (postbattle_exists[i]>0) and (sprite_exists(postbattle[i])){
	            sprite_delete(postbattle[i]);postbattle_exists[i]=-1;postbattle[i]=0;
	        }
	        if (argument0="postspace") and (postspace_exists[i]>0) and (sprite_exists(postspace[i])){
	            sprite_delete(postspace[i]);postspace_exists[i]=-1;postspace[i]=0;
	        }
	        if (argument0="formation") and (formation_exists[i]>0) and (sprite_exists(formation[i])){
	            sprite_delete(formation[i]);formation_exists[i]=-1;formation[i]=0;
	        }
	        if (argument0="popup") and (popup_exists[i]>0) and (sprite_exists(popup[i])){
	            sprite_delete(popup[i]);popup_exists[i]=-1;popup[i]=0;
	        }
	        if (argument0="commander") and (commander_exists[i]>0) and (sprite_exists(commander[i])){
	            sprite_delete(commander[i]);commander_exists[i]=-1;commander[i]=0;
	        }
	        if (argument0="planet") and (planet_exists[i]>0) and (sprite_exists(planet[i])){
	            sprite_delete(planet[i]);planet_exists[i]=-1;planet[i]=0;
	        }
	        if (argument0="attacked") and (attacked_exists[i]>0) and (sprite_exists(attacked[i])){
	            sprite_delete(attacked[i]);attacked_exists[i]=-1;attacked[i]=0;
	        }
	        if (argument0="force") and (force_exists[i]>0) and (sprite_exists(force[i])){
	            sprite_delete(force[i]);force_exists[i]=-1;force[i]=0;
	        }
	        if (argument0="purge") and (purge_exists[i]>0) and (sprite_exists(purge[i])){
	            sprite_delete(purge[i]);purge_exists[i]=-1;purge[i]=0;
	        }
	        if (argument0="event") and (event_exists[i]>0) and (sprite_exists(event[i])){
	            sprite_delete(event[i]);event_exists[i]=-1;event[i]=0;
	        }
	        if (argument0="title_splash") and (title_splash_exists[i]>0) and (sprite_exists(title_splash[i])){
	            sprite_delete(title_splash[i]);title_splash_exists[i]=-1;title_splash[i]=0;
	        }
	        if (argument0="symbol") and (symbol_exists[i]>0) and (sprite_exists(symbol[i])){
	            sprite_delete(symbol[i]);symbol_exists[i]=-1;symbol[i]=0;
	        }
	        if (argument0="defeat") and (defeat_exists[i]>0) and (sprite_exists(defeat[i])){
	            sprite_delete(defeat[i]);defeat_exists[i]=-1;defeat[i]=0;
	        }
	        if (argument0="slate") and (slate_exists[i]>0) and (sprite_exists(slate[i])){
	            sprite_delete(slate[i]);slate_exists[i]=-1;slate[i]=0;
	        }
        
	    }
    
    
	    if (argument0="creation"){creation_good=false;single_image=true;}
	    if (argument0="main_splash") or (argument0="existing_splash") or (argument0="other_splash") then splash_good=false;
	    if (argument0="advisor") then advisor_good=false;
	    if (argument0="diplomacy_splash") then diplomacy_splash_good=false;
	    if (argument0="diplomacy_daemon") then diplomacy_daemon_good=false;
	    if (argument0="diplomacy_icon"){diplomacy_icon_good=false;single_image=true;}
	    if (argument0="menu"){menu_good=false;single_image=true;}
	    if (argument0="loading") then loading_good=false;
	    if (argument0="postbattle") then postbattle_good=false;
	    if (argument0="postspace") then postspace_good=false;
	    if (argument0="formation") then formation_good=false;
	    if (argument0="popup") then popup_good=false;
	    if (argument0="commander") then commander_good=false;
	    if (argument0="planet") then planet_good=false;
	    if (argument0="attacked") then attacked_good=false;
	    if (argument0="force") then force_good=false;
	    if (argument0="purge") then purge_good=false;
	    if (argument0="event") then event_good=false;
	    if (argument0="title_splash"){title_splash_good=false;single_image=true;}
	    if (argument0="symbol") then symbol_good=false;
	    if (argument0="defeat") then defeat_good=false;
	    if (argument0="slate") then slate_good=false;
    
    
    
	    if (single_image=true){
	        if (argument0="creation") and (file_exists(working_directory + "\\images\\creation\\creation_icons.png")){
	            creation[1]=sprite_add(working_directory + "\\images\\creation\\creation_icons.png",23,false,false,0,0);creation_exists[1]=true;creation_good=true;
	        }
	        if (argument0="diplomacy_icon") and (file_exists(working_directory + "\\images\\diplomacy\\diplomacy_icons.png")){
	            diplomacy_icon[1]=sprite_add(working_directory + "\\images\\diplomacy\\diplomacy_icons.png",28,false,false,0,0);diplomacy_icon_exists[1]=true;diplomacy_icon_good=true;
	        }
	        if (argument0="menu") and (file_exists(working_directory + "\\images\\ui\\ingame_menu.png")){
	            menu[1]=sprite_add(working_directory + "\\images\\ui\\ingame_menu.png",2,false,false,0,0);menu_exists[1]=true;menu_good=true;
	        }
	        if (argument0="title_splash") and (file_exists(working_directory + "\\images\\title_splash.png")){
	            title_splash[1]=sprite_add(working_directory + "\\images\\title_splash.png",1,false,false,0,0);title_splash_exists[1]=true;title_splash_good=true;
	        }
	    }
    
	    if (single_image=false){
	        var i,w;i=0;w=0;
        
	        repeat(40){i+=1;
	            if (argument0="main_splash"){
	                if (file_exists(working_directory + "\\images\\creation\\main"+string(i)+".png")){
	                    main[i-1]=sprite_add(working_directory + "\\images\\creation\\main"+string(i)+".png",1,false,false,0,0);main_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then splash_good=true;
	            }
	            if (argument0="existing_splash"){
	                if (file_exists(working_directory + "\\images\\creation\\existing"+string(i)+".png")){
	                    existing[i-1]=sprite_add(working_directory + "\\images\\creation\\existing"+string(i)+".png",1,false,false,0,0);existing_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then splash_good=true;
	            }
	            if (argument0="other_splash"){
	                if (file_exists(working_directory + "\\images\\creation\\other"+string(i)+".png")){
	                    others[i-1]=sprite_add(working_directory + "\\images\\creation\\other"+string(i)+".png",1,false,false,0,0);others_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then splash_good=true;
	            }
            
	            if (argument0="advisor"){
	                if (file_exists(working_directory + "\\images\\diplomacy\\advisor"+string(i)+".png")){
	                    advisor[i-1]=sprite_add(working_directory + "\\images\\diplomacy\\advisor"+string(i)+".png",1,false,false,0,0);advisor_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then advisor_good=true;
	            }
            
	            if (argument0="diplomacy_splash"){
	                if (file_exists(working_directory + "\\images\\diplomacy\\diplomacy"+string(i)+".png")){
	                    diplomacy_splash[i-1]=sprite_add(working_directory + "\\images\\diplomacy\\diplomacy"+string(i)+".png",1,false,false,0,0);diplomacy_splash_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then diplomacy_splash_good=true;
	            }
            
	            if (argument0="diplomacy_daemon"){
	                if (file_exists(working_directory + "\\images\\diplomacy\\daemon"+string(i)+".png")){
	                    diplomacy_daemon[i-1]=sprite_add(working_directory + "\\images\\diplomacy\\daemon"+string(i)+".png",1,false,false,0,0);diplomacy_daemon_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then diplomacy_daemon_good=true;
	            }
						// loading screen error arg
	            if (argument0="loading"){
	                if (file_exists(working_directory + "\\images\\loading\\loading"+string(i)+".png")){
	                    loading[i-1]=sprite_add(working_directory + "\\images\\loading\\loading"+string(i)+".png",1,false,false,0,0);loading_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then loading_good=true; 
	            }
            
	            if (argument0="postbattle"){
	                if (file_exists(working_directory + "\\images\\ui\\postbattle"+string(i)+".png")){
	                    postbattle[i-1]=sprite_add(working_directory + "\\images\\ui\\postbattle"+string(i)+".png",1,false,false,0,0);postbattle_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then postbattle_good=true;
	            }
            
	            if (argument0="postspace"){
	                if (file_exists(working_directory + "\\images\\ui\\postspace"+string(i)+".png")){
	                    postspace[i-1]=sprite_add(working_directory + "\\images\\ui\\postspace"+string(i)+".png",1,false,false,0,0);postspace_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then postspace_good=true;
	            }
            
	            if (argument0="formation"){
	                if (file_exists(working_directory + "\\images\\ui\\formation"+string(i)+".png")){
	                    formation[i-1]=sprite_add(working_directory + "\\images\\ui\\formation"+string(i)+".png",1,false,false,0,0);formation_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then formation_good=true;
	            }
            
	            if (argument0="popup"){
	                if (file_exists(working_directory + "\\images\\popup\\popup"+string(i)+".png")){
	                    popup[i-1]=sprite_add(working_directory + "\\images\\popup\\popup"+string(i)+".png",1,false,false,0,0);popup_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then popup_good=true;
	            }
            
	            if (argument0="commander"){
	                if (file_exists(working_directory + "\\images\\ui\\commander"+string(i)+".png")){
	                    commander[i-1]=sprite_add(working_directory + "\\images\\ui\\commander"+string(i)+".png",1,false,false,0,0);commander_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then commander_good=true;
	            }
            
	            if (argument0="planet"){
	                if (file_exists(working_directory + "\\images\\ui\\planet"+string(i)+".png")){
	                    planet[i-1]=sprite_add(working_directory + "\\images\\ui\\planet"+string(i)+".png",1,false,false,0,0);planet_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then planet_good=true;
	            }
            
	            if (argument0="attacked"){
	                if (file_exists(working_directory + "\\images\\ui\\attacked"+string(i)+".png")){
	                    attacked[i-1]=sprite_add(working_directory + "\\images\\ui\\attacked"+string(i)+".png",1,false,false,0,0);attacked_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then attacked_good=true;
	            }
            
	            if (argument0="force"){
	                if (file_exists(working_directory + "\\images\\ui\\force"+string(i)+".png")){
	                    force[i-1]=sprite_add(working_directory + "\\images\\ui\\force"+string(i)+".png",1,false,false,0,0);
						force_exists[i-1]=1;
						w+=1;
	                }
	                if (w>0) then force_good=true;
	            }
            
	            if (argument0="purge"){
	                if (file_exists(working_directory + "\\images\\ui\\purge"+string(i)+".png")){
	                    purge[i-1]=sprite_add(working_directory + "\\images\\ui\\purge"+string(i)+".png",1,false,false,0,0);purge_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then purge_good=true;
	            }
            
	            if (argument0="event"){
	                if (file_exists(working_directory + "\\images\\ui\\event"+string(i)+".png")){
	                    event[i-1]=sprite_add(working_directory + "\\images\\ui\\event"+string(i)+".png",1,false,false,0,0);event_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then event_good=true;
	            }
            
	            if (argument0="symbol"){
	                if (file_exists(working_directory + "\\images\\diplomacy\\symbol"+string(i)+".png")){
	                    symbol[i-1]=sprite_add(working_directory + "\\images\\diplomacy\\symbol"+string(i)+".png",1,false,false,0,0);symbol_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then symbol_good=true;
	            }
            
	            if (argument0="defeat"){
	                if (file_exists(working_directory + "\\images\\ui\\defeat"+string(i)+".png")){
	                    defeat[i-1]=sprite_add(working_directory + "\\images\\ui\\defeat"+string(i)+".png",1,false,false,0,0);defeat_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then defeat_good=true;
	            }
            
	            if (argument0="slate"){
	                if (file_exists(working_directory + "\\images\\creation\\slate"+string(i)+".png")){
	                    slate[i-1]=sprite_add(working_directory + "\\images\\creation\\slate"+string(i)+".png",1,false,false,0,0);slate_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then slate_good=true;
	            }
            
            
            
	        }
        
	    }
    
    
    
    
    
	}}



	if (argument0!="") and (argument1>=0) and (argument1!=666){with(obj_img){// Draw the image
	    var drawing_sprite,drawing_exists,old_alpha,old_color,x13,y13,x14,y14;
	    drawing_sprite=0;drawing_exists=false;x13=0;y13=0;x14=0;y14=0;
    
	    old_alpha=draw_get_alpha();
	    old_color=draw_get_colour();
    
	    if (argument0="creation"){
	        if (creation_exists[1]>0) and (sprite_exists(creation[1])){drawing_sprite=creation[1];drawing_exists=true;}
	    }
	    if (argument0="main_splash"){
	        if (main_exists[argument1]>0) and (sprite_exists(main[argument1])){drawing_sprite=main[argument1];drawing_exists=true;}
	    }
	    if (argument0="existing_splash"){
	        if (existing_exists[argument1]>0) and (sprite_exists(existing[argument1])){drawing_sprite=existing[argument1];drawing_exists=true;}
	    }
	    if (argument0="other_splash"){
	        if (others_exists[argument1]>0) and (sprite_exists(others[argument1])){drawing_sprite=others[argument1];drawing_exists=true;}
	    }
	    if (argument0="advisor"){
	        if (advisor_exists[argument1]>0) and (sprite_exists(advisor[argument1])){drawing_sprite=advisor[argument1];drawing_exists=true;}
	    }
	    if (argument0="diplomacy_splash"){
	        if (diplomacy_splash_exists[argument1]>0) and (sprite_exists(diplomacy_splash[argument1])){drawing_sprite=diplomacy_splash[argument1];drawing_exists=true;}
	    }
	    if (argument0="diplomacy_daemon"){
	        if (diplomacy_daemon_exists[argument1]>0) and (sprite_exists(diplomacy_daemon[argument1])){drawing_sprite=diplomacy_daemon[argument1];drawing_exists=true;}
	    }
	    if (argument0="diplomacy_icon"){
	        if (diplomacy_icon_exists[1]>0) and (sprite_exists(diplomacy_icon[1])){drawing_sprite=diplomacy_icon[1];drawing_exists=true;}
	    }
	    if (argument0="menu"){
	        if (menu_exists[1]>0) and (sprite_exists(menu[1])){drawing_sprite=menu[1];drawing_exists=true;}
	    }
	    if (argument0="loading"){
	        if (loading_exists[argument1]>0) and (sprite_exists(loading[argument1])){drawing_sprite=loading[argument1];drawing_exists=true;}
	    }
	    if (argument0="postbattle"){
	        if (postbattle_exists[argument1]>0) and (sprite_exists(postbattle[argument1])){drawing_sprite=postbattle[argument1];drawing_exists=true;}
	    }
	    if (argument0="postspace"){
	        if (postspace_exists[argument1]>0) and (sprite_exists(postspace[argument1])){drawing_sprite=postspace[argument1];drawing_exists=true;}
	    }
	    if (argument0="formation"){
	        if (formation_exists[argument1]>0) and (sprite_exists(formation[argument1])){drawing_sprite=formation[argument1];drawing_exists=true;}
	    }
	    if (argument0="popup"){
	        if (popup_exists[argument1]>0) and (sprite_exists(popup[argument1])){drawing_sprite=popup[argument1];drawing_exists=true;}
	    }
	    if (argument0="commander"){
	        if (commander_exists[argument1]>0) and (sprite_exists(commander[argument1])){drawing_sprite=commander[argument1];drawing_exists=true;}
	    }
	    if (argument0="planet"){
	        if (planet_exists[argument1]>0) and (sprite_exists(planet[argument1])){drawing_sprite=planet[argument1];drawing_exists=true;}
	    }
	    if (argument0="attacked"){
	        if (attacked_exists[argument1]>0) and (sprite_exists(attacked[argument1])){drawing_sprite=attacked[argument1];drawing_exists=true;}
	    }
	    if (argument0="force"){
	        if (force_exists[argument1]>0) and (sprite_exists(force[argument1])){drawing_sprite=force[argument1];drawing_exists=true;}
	    }
	    if (argument0="raid"){
	        if (raid_exists[argument1]>0) and (sprite_exists(raid[argument1])){drawing_sprite=raid[argument1];drawing_exists=true;}
	    }
	    if (argument0="purge"){
	        if (purge_exists[argument1]>0) and (sprite_exists(purge[argument1])){drawing_sprite=purge[argument1];drawing_exists=true;}
	    }
	    if (argument0="event"){
	        if (event_exists[argument1]>0) and (sprite_exists(event[argument1])){drawing_sprite=event[argument1];drawing_exists=true;}
	    }
	    if (argument0="title_splash"){
	        if (title_splash_exists[1]>0) and (sprite_exists(title_splash[1])){drawing_sprite=title_splash[1];drawing_exists=true;}
	    }
	    if (argument0="symbol"){
	        if (symbol_exists[argument1]>0) and (sprite_exists(symbol[argument1])){drawing_sprite=symbol[argument1];drawing_exists=true;}
	    }
	    if (argument0="defeat"){
	        if (defeat_exists[argument1]>0) and (sprite_exists(defeat[argument1])){drawing_sprite=defeat[argument1];drawing_exists=true;}
	    }
	    if (argument0="slate"){
	        if (slate_exists[argument1]>0) and (sprite_exists(slate[argument1])){drawing_sprite=slate[argument1];drawing_exists=true;}
	    }
    
	    if (drawing_exists=true){
	        draw_sprite_stretched(drawing_sprite,argument1,argument2,argument3,argument4,argument5);
	    }
	    if (drawing_exists=false){
	        draw_set_alpha(1);draw_set_color(0);
	        draw_rectangle(argument2,argument3,argument2+argument4,argument3+argument5,0);
	        draw_set_color(c_red);
	        draw_rectangle(argument2,argument3,argument2+argument4,argument3+argument5,1);
	        draw_rectangle(argument2+1,argument3+1,argument2+argument4-1,argument3+argument5-1,1);
	        draw_rectangle(argument2+2,argument3+2,argument2+argument4-2,argument3+argument5-2,1);
	        draw_line_width(argument2+1.5,argument3+1.5,argument2+argument4-1.5,argument3+argument5-1.5,3);
	        draw_line_width(argument2+argument4-1.5,argument3+1.5,argument2+1.5,argument3+argument5-1.5,3);
	        draw_set_color(c_black);
	    }
    
	    draw_set_alpha(old_alpha);
	    draw_set_color(old_color);
    
	}}
}
