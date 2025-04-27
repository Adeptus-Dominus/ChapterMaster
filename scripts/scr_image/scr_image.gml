/// @description Draws a png image. Example: 
/// `scr_image("creation/chapters/icons", 1, 450, 250, 32, 32);`
/// For actual sprites with multiple frames, don't use this.
/// @param {String} path the file path after 'images' in the 'datafiles' folder. e.g. "creation/chapters/icons"
/// @param {Real} image_id the name of the image. Convention follows using numbers, e.g. "1.png", so that loops are useful, and it can be stored at it's own array index in the cache.
/// @param {Real} x1 the x coordinates to start drawing
/// @param {Real} y1 the y coordinates to start drawing
/// @param {Real} width the width of the image
/// @param {Real} height the height of the image
function scr_image(path, image_id, x1, y1, width, height) {

	// argument0: keyword
	// argument1: number
	// argument2: x1
	// argument3: y1
	// argument4: width
	// argument5: height

	if (!instance_exists(obj_img)) then exit;

	/// First attempt at the a new method of image loading logic to do away with 500 lines of madness.
	/// Any image loaded from the filesystem to be drawn as a sprite should be saved to some sort of cache so that it
	/// only ever has to load from disk once. We are using the `obj_img` object to store this cache in the format below:
	///		img_cache: {
	///			"creation/chapters": [somesprite1, somesprite2, ...],
	///			"some/path": [-1, -1, somesprite3],
	///		}
	/// The key is the folder path, its value will be an array. 
	/// The image_id passed will be used to index the array where the sprite is stored.
	/// i.e. if `scr_image("some/path", 1, ...);` is used, then the "some/path" key will have an array [-1, sprite1]
	/// where sprite1 is loaded from "/images/some/path/1.png" 
	/// Converting to the new method will require renaming images and redoing folder structure where it makes sense,
	/// and composite images like `chapter_icons.png` need to be broken up into separate pngs. 
	/// One notable thing missing is any sprite_delete handling, that may require it's own separate function.
	if(string_count("/", path) > 0){
		var old_alpha = draw_get_alpha();
		var old_color = draw_get_color();
		var drawing_sprite = scr_image_cache(path, image_id);
		
		// Draws the red box with a X through it
		if(is_undefined(drawing_sprite) || !sprite_exists(drawing_sprite)){
			draw_set_alpha(1);draw_set_color(0);
	        draw_rectangle(x1,y1,x1+width,y1+height,0);
	        draw_set_color(c_red);
	        draw_rectangle(x1,y1,x1+width,y1+height,1);
	        draw_rectangle(x1+1,y1+1,x1+width-1,y1+height-1,1);
	        draw_rectangle(x1+2,y1+2,x1+width-2,y1+height-2,1);
	        draw_line_width(x1+1.5,y1+1.5,x1+width-1.5,y1+height-1.5,3);
	        draw_line_width(x1+width-1.5,y1+1.5,x1+1.5,y1+height-1.5,3);
	        draw_set_color(c_black);
			return;
		}
		// Draws the real image if we found it
		draw_sprite_stretched(drawing_sprite,1,x1,y1,width,height);

		draw_set_alpha(old_alpha);
	    draw_set_color(old_color);
		return;
	}




	if (image_id<=-666) or (image_id=666){with(obj_img){// Clear out these images
	    var i,single_image;i=-1;single_image=false;
    
	    if (path="creation") or (path="all") or (path=""){creation_good=false;single_image=true;}
	    if (path="main_splash") or (path="existing_splash") or (path="other_splash") or (path="all") or (path="") then splash_good=false;
	    if (path="advisor") or (path="all") or (path="") then advisor_good=false;
	    if (path="diplomacy_splash") or (path="all") or (path="") then diplomacy_splash_good=false;
	    if (path="diplomacy_daemon") or (path="all") or (path="") then diplomacy_daemon_good=false;
	    if (path="diplomacy_icon") or (path="all") or (path=""){diplomacy_icon_good=false;single_image=true;}
	    if (path="menu") or (path="all") or (path=""){menu_good=false;single_image=true;}
	    if (path="loading") or (path="all") or (path="") then loading_good=false;
	    if (path="postbattle") or (path="all") or (path="") then postbattle_good=false;
	    if (path="postspace") or (path="all") or (path="") then postspace_good=false;
	    if (path="formation") or (path="all") or (path="") then formation_good=false;
	    if (path="popup") or (path="all") or (path="") then popup_good=false;
	    if (path="commander") or (path="all") or (path="") then commander_good=false;
	    if (path="planet") or (path="all") or (path="") then planet_good=false;
	    if (path="attacked") or (path="all") or (path="") then attacked_good=false;
	    if (path="force") or (path="all") or (path="") then force_good=false;
	    if (path="purge") or (path="all") or (path="") then purge_good=false;
	    if (path="event") or (path="all") or (path="") then event_good=false;
	    if (path="title_splash") or (path="all") or (path="") then title_splash_good=false;
	    if (path="symbol") or (path="all") or (path="") then symbol_good=false;
	    if (path="defeat") or (path="all") or (path="") then defeat_good=false;
	    if (path="slate") or (path="all") or (path="") then slate_good=false;
    
    
	    repeat(80){i+=1;
    
	        if ((path="creation") or (path="all") or (path="")) and (creation_exists[i]>0) and (sprite_exists(creation[i])){
	            sprite_delete(creation[i]);creation_exists[i]=-1;creation[i]=0;
	        }
	        if ((path="main_splash") or (path="all") or (path="")){
	            if (main_exists[i]>0) and (sprite_exists(main[i])){sprite_delete(main[i]);main_exists[i]=-1;main[i]=0;}
	        }
	        if ((path="existing_splash") or (path="all") or (path="")){
	            if (existing_exists[i]>0) and (sprite_exists(existing[i])){sprite_delete(existing[i]);existing_exists[i]=-1;existing[i]=0;}
	        }
	        if ((path="other_splash") or (path="all") or (path="")){
	            if (others_exists[i]>0) and (sprite_exists(others[i])){sprite_delete(others[i]);others_exists[i]=-1;others[i]=0;}
	        }
	        if ((path="advisor") or (path="all") or (path="")) and (advisor_exists[i]>0) and (sprite_exists(advisor[i])){
	            sprite_delete(advisor[i]);advisor_exists[i]=-1;advisor[i]=0;
	        }
	        if ((path="diplomacy_splash") or (path="all") or (path="")) and (diplomacy_splash_exists[i]>0) and (sprite_exists(diplomacy_splash[i])){
	            sprite_delete(diplomacy_splash[i]);diplomacy_splash_exists[i]=-1;diplomacy_splash[i]=0;
	        }
	        if ((path="diplomacy_daemon") or (path="all") or (path="")) and (diplomacy_daemon_exists[i]>0) and (sprite_exists(diplomacy_daemon[i])){
	            sprite_delete(diplomacy_daemon[i]);diplomacy_daemon_exists[i]=-1;diplomacy_daemon[i]=0;
	        }
	        if ((path="diplomacy_icon") or (path="all") or (path="")) and (diplomacy_icon_exists[i]>0) and (sprite_exists(diplomacy_icon[i])){
	            sprite_delete(diplomacy_icon[i]);diplomacy_icon_exists[i]=-1;diplomacy_icon[i]=0;
	        }
	        if ((path="menu") or (path="all") or (path="")) and (menu_exists[i]>0) and (sprite_exists(menu[i])){
	            sprite_delete(menu[i]);menu_exists[i]=-1;menu[i]=0;
	        }
	        if ((path="loading") or (path="all") or (path="")) and (loading_exists[i]>0) and (sprite_exists(loading[i])){
	            sprite_delete(loading[i]);loading_exists[i]=-1;loading[i]=0;
	        }
	        if ((path="postbattle") or (path="all") or (path="")) and (postbattle_exists[i]>0) and (sprite_exists(postbattle[i])){
	            sprite_delete(postbattle[i]);postbattle_exists[i]=-1;postbattle[i]=0;
	        }
	        if ((path="postspace") or (path="all") or (path="")) and (postspace_exists[i]>0) and (sprite_exists(postspace[i])){
	            sprite_delete(postspace[i]);postspace_exists[i]=-1;postspace[i]=0;
	        }
	        if ((path="formation") or (path="all") or (path="")) and (formation_exists[i]>0) and (sprite_exists(formation[i])){
	            sprite_delete(formation[i]);formation_exists[i]=-1;formation[i]=0;
	        }
	        if ((path="popup") or (path="all") or (path="")) and (popup_exists[i]>0) and (sprite_exists(popup[i])){
	            sprite_delete(popup[i]);popup_exists[i]=-1;popup[i]=0;
	        }
	        if ((path="commander") or (path="all") or (path="")) and (commander_exists[i]>0) and (sprite_exists(commander[i])){
	            sprite_delete(commander[i]);commander_exists[i]=-1;commander[i]=0;
	        }
	        if ((path="planet") or (path="all") or (path="")) and (planet_exists[i]>0) and (sprite_exists(planet[i])){
	            sprite_delete(planet[i]);planet_exists[i]=-1;planet[i]=0;
	        }
	        if ((path="attacked") or (path="all") or (path="")) and (attacked_exists[i]>0) and (sprite_exists(attacked[i])){
	            sprite_delete(attacked[i]);attacked_exists[i]=-1;attacked[i]=0;
	        }
	        if ((path="force") or (path="all") or (path="")) and (force_exists[i]>0) and (sprite_exists(force[i])){
	            sprite_delete(force[i]);force_exists[i]=-1;force[i]=0;
	        }
	        if ((path="purge") or (path="all") or (path="")) and (purge_exists[i]>0) and (sprite_exists(purge[i])){
	            sprite_delete(purge[i]);purge_exists[i]=-1;purge[i]=0;
	        }
	        if ((path="event") or (path="all") or (path="")) and (event_exists[i]>0) and (sprite_exists(event[i])){
	            sprite_delete(event[i]);event_exists[i]=-1;event[i]=0;
	        }
	        if ((path="title_splash") or (path="all") or (path="")){
	            if (title_splash_exists[i]>0) and (sprite_exists(title_splash[i])){sprite_delete(title_splash[i]);title_splash_exists[i]=-1;title_splash[i]=0;}
	        }
	        if ((path="symbol") or (path="all") or (path="")){
	            if (symbol_exists[i]>0) and (sprite_exists(symbol[i])){sprite_delete(symbol[i]);symbol_exists[i]=-1;symbol[i]=0;}
	        }
	        if ((path="defeat") or (path="all") or (path="")){
	            if (defeat_exists[i]>0) and (sprite_exists(defeat[i])){sprite_delete(defeat[i]);defeat_exists[i]=-1;defeat[i]=0;}
	        }
	        if ((path="slate") or (path="all") or (path="")){
	            if (slate_exists[i]>0) and (sprite_exists(slate[i])){sprite_delete(slate[i]);slate_exists[i]=-1;slate[i]=0;}
	        }
        
	    }
    
	}}


	if (image_id>-600) and (image_id<0){with(obj_img){// Initialize these images
    
	    var i,single_image;i=-1;single_image=false;
	    repeat(80){i+=1;
    
	        if (path="creation") and (creation_exists[i]>0) and (sprite_exists(creation[i])){
	            sprite_delete(creation[i]);creation_exists[i]=-1;creation[i]=0;
	        }
	        if (path="splash"){
	            if (main_exists[i]>0) and (sprite_exists(main[i])){sprite_delete(main[i]);main_exists[i]=-1;main[i]=0;}
	            if (existing_exists[i]>0) and (sprite_exists(existing[i])){sprite_delete(existing[i]);existing_exists[i]=-1;existing[i]=0;}
	            if (others_exists[i]>0) and (sprite_exists(others[i])){sprite_delete(others[i]);others_exists[i]=-1;others[i]=0;}
	        }
	        if (path="advisor") and (advisor_exists[i]>0) and (sprite_exists(advisor[i])){
	            sprite_delete(advisor[i]);advisor_exists[i]=-1;advisor[i]=0;
	        }
	        if (path="diplomacy_splash") and (diplomacy_splash_exists[i]>0) and (sprite_exists(diplomacy_splash[i])){
	            sprite_delete(diplomacy_splash[i]);diplomacy_splash_exists[i]=-1;diplomacy_splash[i]=0;
	        }
	        if (path="diplomacy_daemon") and (diplomacy_daemon_exists[i]>0) and (sprite_exists(diplomacy_daemon[i])){
	            sprite_delete(diplomacy_daemon[i]);diplomacy_daemon_exists[i]=-1;diplomacy_daemon[i]=0;
	        }
	        if (path="diplomacy_icon") and (diplomacy_icon_exists[i]>0) and (sprite_exists(diplomacy_icon[i])){
	            sprite_delete(diplomacy_icon[i]);diplomacy_icon_exists[i]=-1;diplomacy_icon[i]=0;
	        }
	        if (path="menu") and (menu_exists[i]>0) and (sprite_exists(menu[i])){
	            sprite_delete(menu[i]);menu_exists[i]=-1;menu[i]=0;
	        }
	        if (path="loading") and (loading_exists[i]>0) and (sprite_exists(loading[i])){
	            sprite_delete(loading[i]);loading_exists[i]=-1;loading[i]=0;
	        }
	        if (path="postbattle") and (postbattle_exists[i]>0) and (sprite_exists(postbattle[i])){
	            sprite_delete(postbattle[i]);postbattle_exists[i]=-1;postbattle[i]=0;
	        }
	        if (path="postspace") and (postspace_exists[i]>0) and (sprite_exists(postspace[i])){
	            sprite_delete(postspace[i]);postspace_exists[i]=-1;postspace[i]=0;
	        }
	        if (path="formation") and (formation_exists[i]>0) and (sprite_exists(formation[i])){
	            sprite_delete(formation[i]);formation_exists[i]=-1;formation[i]=0;
	        }
	        if (path="popup") and (popup_exists[i]>0) and (sprite_exists(popup[i])){
	            sprite_delete(popup[i]);popup_exists[i]=-1;popup[i]=0;
	        }
	        if (path="commander") and (commander_exists[i]>0) and (sprite_exists(commander[i])){
	            sprite_delete(commander[i]);commander_exists[i]=-1;commander[i]=0;
	        }
	        if (path="planet") and (planet_exists[i]>0) and (sprite_exists(planet[i])){
	            sprite_delete(planet[i]);planet_exists[i]=-1;planet[i]=0;
	        }
	        if (path="attacked") and (attacked_exists[i]>0) and (sprite_exists(attacked[i])){
	            sprite_delete(attacked[i]);attacked_exists[i]=-1;attacked[i]=0;
	        }
	        if (path="force") and (force_exists[i]>0) and (sprite_exists(force[i])){
	            sprite_delete(force[i]);force_exists[i]=-1;force[i]=0;
	        }
	        if (path="purge") and (purge_exists[i]>0) and (sprite_exists(purge[i])){
	            sprite_delete(purge[i]);purge_exists[i]=-1;purge[i]=0;
	        }
	        if (path="event") and (event_exists[i]>0) and (sprite_exists(event[i])){
	            sprite_delete(event[i]);event_exists[i]=-1;event[i]=0;
	        }
	        if (path="title_splash") and (title_splash_exists[i]>0) and (sprite_exists(title_splash[i])){
	            sprite_delete(title_splash[i]);title_splash_exists[i]=-1;title_splash[i]=0;
	        }
	        if (path="symbol") and (symbol_exists[i]>0) and (sprite_exists(symbol[i])){
	            sprite_delete(symbol[i]);symbol_exists[i]=-1;symbol[i]=0;
	        }
	        if (path="defeat") and (defeat_exists[i]>0) and (sprite_exists(defeat[i])){
	            sprite_delete(defeat[i]);defeat_exists[i]=-1;defeat[i]=0;
	        }
	        if (path="slate") and (slate_exists[i]>0) and (sprite_exists(slate[i])){
	            sprite_delete(slate[i]);slate_exists[i]=-1;slate[i]=0;
	        }
        
	    }
    
    
	    if (path="creation"){creation_good=false;single_image=true;}
	    if (path="main_splash") or (path="existing_splash") or (path="other_splash") then splash_good=false;
	    if (path="advisor") then advisor_good=false;
	    if (path="diplomacy_splash") then diplomacy_splash_good=false;
	    if (path="diplomacy_daemon") then diplomacy_daemon_good=false;
	    if (path="diplomacy_icon"){diplomacy_icon_good=false;single_image=true;}
	    if (path="menu"){menu_good=false;single_image=true;}
	    if (path="loading") then loading_good=false;
	    if (path="postbattle") then postbattle_good=false;
	    if (path="postspace") then postspace_good=false;
	    if (path="formation") then formation_good=false;
	    if (path="popup") then popup_good=false;
	    if (path="commander") then commander_good=false;
	    if (path="planet") then planet_good=false;
	    if (path="attacked") then attacked_good=false;
	    if (path="force") then force_good=false;
	    if (path="purge") then purge_good=false;
	    if (path="event") then event_good=false;
	    if (path="title_splash"){title_splash_good=false;single_image=true;}
	    if (path="symbol") then symbol_good=false;
	    if (path="defeat") then defeat_good=false;
	    if (path="slate") then slate_good=false;
    
    
    
	    if (single_image=true){
	        if (path="creation") and (file_exists(working_directory + "\\images\\creation\\creation_icons.png")){
	            creation[1]=sprite_add(working_directory + "\\images\\creation\\creation_icons.png",24,false,false,0,0);creation_exists[1]=true;creation_good=true;
	        }
	        if (path="diplomacy_icon") and (file_exists(working_directory + "\\images\\diplomacy\\diplomacy_icons.png")){
	            diplomacy_icon[1]=sprite_add(working_directory + "\\images\\diplomacy\\diplomacy_icons.png",28,false,false,0,0);diplomacy_icon_exists[1]=true;diplomacy_icon_good=true;
	        }
	        if (path="menu") and (file_exists(working_directory + "\\images\\ui\\ingame_menu.png")){
	            menu[1]=sprite_add(working_directory + "\\images\\ui\\ingame_menu.png",2,false,false,0,0);menu_exists[1]=true;menu_good=true;
	        }
	        if (path="title_splash") and (file_exists(working_directory + "\\images\\title_splash.png")){
	            title_splash[1]=sprite_add(working_directory + "\\images\\title_splash.png",1,false,false,0,0);title_splash_exists[1]=true;title_splash_good=true;
	        }
	    }
    
	    if (single_image=false){
	        var i,w;i=0;w=0;
        
	        repeat(40){i+=1;
	            if (path="main_splash"){
	                if (file_exists(working_directory + "\\images\\creation\\main"+string(i)+".png")){
	                    main[i-1]=sprite_add(working_directory + "\\images\\creation\\main"+string(i)+".png",1,false,false,0,0);main_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then splash_good=true;
	            }
	            if (path="existing_splash"){
	                if (file_exists(working_directory + "\\images\\creation\\existing"+string(i)+".png")){
	                    existing[i-1]=sprite_add(working_directory + "\\images\\creation\\existing"+string(i)+".png",1,false,false,0,0);existing_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then splash_good=true;
	            }
	            if (path="other_splash"){
	                if (file_exists(working_directory + "\\images\\creation\\other"+string(i)+".png")){
	                    others[i-1]=sprite_add(working_directory + "\\images\\creation\\other"+string(i)+".png",1,false,false,0,0);others_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then splash_good=true;
	            }
            
	            if (path="advisor"){
	                if (file_exists(working_directory + "\\images\\diplomacy\\advisor"+string(i)+".png")){
	                    advisor[i-1]=sprite_add(working_directory + "\\images\\diplomacy\\advisor"+string(i)+".png",1,false,false,0,0);advisor_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then advisor_good=true;
	            }
            
	            if (path="diplomacy_splash"){
	                if (file_exists(working_directory + "\\images\\diplomacy\\diplomacy"+string(i)+".png")){
	                    diplomacy_splash[i-1]=sprite_add(working_directory + "\\images\\diplomacy\\diplomacy"+string(i)+".png",1,false,false,0,0);diplomacy_splash_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then diplomacy_splash_good=true;
	            }
            
	            if (path="diplomacy_daemon"){
	                if (file_exists(working_directory + "\\images\\diplomacy\\daemon"+string(i)+".png")){
	                    diplomacy_daemon[i-1]=sprite_add(working_directory + "\\images\\diplomacy\\daemon"+string(i)+".png",1,false,false,0,0);diplomacy_daemon_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then diplomacy_daemon_good=true;
	            }
						// loading screen error arg
	            if (path="loading"){
	                if (file_exists(working_directory + "\\images\\loading\\loading"+string(i)+".png")){
	                    loading[i-1]=sprite_add(working_directory + "\\images\\loading\\loading"+string(i)+".png",1,false,false,0,0);loading_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then loading_good=true; 
	            }
            
	            if (path="postbattle"){
	                if (file_exists(working_directory + "\\images\\ui\\postbattle"+string(i)+".png")){
	                    postbattle[i-1]=sprite_add(working_directory + "\\images\\ui\\postbattle"+string(i)+".png",1,false,false,0,0);postbattle_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then postbattle_good=true;
	            }
            
	            if (path="postspace"){
	                if (file_exists(working_directory + "\\images\\ui\\postspace"+string(i)+".png")){
	                    postspace[i-1]=sprite_add(working_directory + "\\images\\ui\\postspace"+string(i)+".png",1,false,false,0,0);postspace_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then postspace_good=true;
	            }
            
	            if (path="formation"){
	                if (file_exists(working_directory + "\\images\\ui\\formation"+string(i)+".png")){
	                    formation[i-1]=sprite_add(working_directory + "\\images\\ui\\formation"+string(i)+".png",1,false,false,0,0);formation_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then formation_good=true;
	            }
            
	            if (path="popup"){
	                if (file_exists(working_directory + "\\images\\popup\\popup"+string(i)+".png")){
	                    popup[i-1]=sprite_add(working_directory + "\\images\\popup\\popup"+string(i)+".png",1,false,false,0,0);popup_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then popup_good=true;
	            }
            
	            if (path="commander"){
	                if (file_exists(working_directory + "\\images\\ui\\commander"+string(i)+".png")){
	                    commander[i-1]=sprite_add(working_directory + "\\images\\ui\\commander"+string(i)+".png",1,false,false,0,0);commander_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then commander_good=true;
	            }
            
	            if (path="planet"){
	                if (file_exists(working_directory + "\\images\\ui\\planet"+string(i)+".png")){
	                    planet[i-1]=sprite_add(working_directory + "\\images\\ui\\planet"+string(i)+".png",1,false,false,0,0);planet_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then planet_good=true;
	            }
            
	            if (path="attacked"){
	                if (file_exists(working_directory + "\\images\\ui\\attacked"+string(i)+".png")){
	                    attacked[i-1]=sprite_add(working_directory + "\\images\\ui\\attacked"+string(i)+".png",1,false,false,0,0);attacked_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then attacked_good=true;
	            }
            
	            if (path="force"){
	                if (file_exists(working_directory + "\\images\\ui\\force"+string(i)+".png")){
	                    force[i-1]=sprite_add(working_directory + "\\images\\ui\\force"+string(i)+".png",1,false,false,0,0);
						force_exists[i-1]=1;
						w+=1;
	                }
	                if (w>0) then force_good=true;
	            }
            
	            if (path="purge"){
	                if (file_exists(working_directory + "\\images\\ui\\purge"+string(i)+".png")){
	                    purge[i-1]=sprite_add(working_directory + "\\images\\ui\\purge"+string(i)+".png",1,false,false,0,0);purge_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then purge_good=true;
	            }
            
	            if (path="event"){
	                if (file_exists(working_directory + "\\images\\ui\\event"+string(i)+".png")){
	                    event[i-1]=sprite_add(working_directory + "\\images\\ui\\event"+string(i)+".png",1,false,false,0,0);event_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then event_good=true;
	            }
            
	            if (path="symbol"){
	                if (file_exists(working_directory + "\\images\\diplomacy\\symbol"+string(i)+".png")){
	                    symbol[i-1]=sprite_add(working_directory + "\\images\\diplomacy\\symbol"+string(i)+".png",1,false,false,0,0);symbol_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then symbol_good=true;
	            }
            
	            if (path="defeat"){
	                if (file_exists(working_directory + "\\images\\ui\\defeat"+string(i)+".png")){
	                    defeat[i-1]=sprite_add(working_directory + "\\images\\ui\\defeat"+string(i)+".png",1,false,false,0,0);defeat_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then defeat_good=true;
	            }
            
	            if (path="slate"){
	                if (file_exists(working_directory + "\\images\\creation\\slate"+string(i)+".png")){
	                    slate[i-1]=sprite_add(working_directory + "\\images\\creation\\slate"+string(i)+".png",1,false,false,0,0);slate_exists[i-1]=1;w+=1;
	                }
	                if (w>0) then slate_good=true;
	            }
            
            
            
	        }
        
	    }
    
    
    
    
    
	}}



	if (path!="") and (image_id>=0) and (image_id!=666){with(obj_img){// Draw the image
	    var drawing_sprite,drawing_exists,old_alpha,old_color,x13,y13,x14,y14;
	    drawing_sprite=0;drawing_exists=false;x13=0;y13=0;x14=0;y14=0;
    
	    old_alpha=draw_get_alpha();
	    old_color=draw_get_colour();
    
	    if (path="creation"){
	        if (creation_exists[1]>0) and (sprite_exists(creation[1])){drawing_sprite=creation[1];drawing_exists=true;}
	    }
	    if (path="main_splash"){
	        if (main_exists[image_id]>0) and (sprite_exists(main[image_id])){drawing_sprite=main[image_id];drawing_exists=true;}
	    }
	    if (path="existing_splash"){
	        if (existing_exists[image_id]>0) and (sprite_exists(existing[image_id])){drawing_sprite=existing[image_id];drawing_exists=true;}
	    }
	    if (path="other_splash"){
	        if (others_exists[image_id]>0) and (sprite_exists(others[image_id])){drawing_sprite=others[image_id];drawing_exists=true;}
	    }
	    if (path="advisor"){
	        if (advisor_exists[image_id]>0) and (sprite_exists(advisor[image_id])){drawing_sprite=advisor[image_id];drawing_exists=true;}
	    }
	    if (path="diplomacy_splash"){
	        if (diplomacy_splash_exists[image_id]>0) and (sprite_exists(diplomacy_splash[image_id])){drawing_sprite=diplomacy_splash[image_id];drawing_exists=true;}
	    }
	    if (path="diplomacy_daemon"){
	        if (diplomacy_daemon_exists[image_id]>0) and (sprite_exists(diplomacy_daemon[image_id])){drawing_sprite=diplomacy_daemon[image_id];drawing_exists=true;}
	    }
	    if (path="diplomacy_icon"){
	        if (diplomacy_icon_exists[1]>0) and (sprite_exists(diplomacy_icon[1])){drawing_sprite=diplomacy_icon[1];drawing_exists=true;}
	    }
	    if (path="menu"){
	        if (menu_exists[1]>0) and (sprite_exists(menu[1])){drawing_sprite=menu[1];drawing_exists=true;}
	    }
	    if (path="loading"){
	        if (loading_exists[image_id]>0) and (sprite_exists(loading[image_id])){drawing_sprite=loading[image_id];drawing_exists=true;}
	    }
	    if (path="postbattle"){
	        if (postbattle_exists[image_id]>0) and (sprite_exists(postbattle[image_id])){drawing_sprite=postbattle[image_id];drawing_exists=true;}
	    }
	    if (path="postspace"){
	        if (postspace_exists[image_id]>0) and (sprite_exists(postspace[image_id])){drawing_sprite=postspace[image_id];drawing_exists=true;}
	    }
	    if (path="formation"){
	        if (formation_exists[image_id]>0) and (sprite_exists(formation[image_id])){drawing_sprite=formation[image_id];drawing_exists=true;}
	    }
	    if (path="popup"){
	        if (popup_exists[image_id]>0) and (sprite_exists(popup[image_id])){drawing_sprite=popup[image_id];drawing_exists=true;}
	    }
	    if (path="commander"){
	        if (commander_exists[image_id]>0) and (sprite_exists(commander[image_id])){drawing_sprite=commander[image_id];drawing_exists=true;}
	    }
	    if (path="planet"){
	        if (planet_exists[image_id]>0) and (sprite_exists(planet[image_id])){drawing_sprite=planet[image_id];drawing_exists=true;}
	    }
	    if (path="attacked"){
	        if (attacked_exists[image_id]>0) and (sprite_exists(attacked[image_id])){drawing_sprite=attacked[image_id];drawing_exists=true;}
	    }
	    if (path="force"){
	        if (force_exists[image_id]>0) and (sprite_exists(force[image_id])){drawing_sprite=force[image_id];drawing_exists=true;}
	    }
	    if (path="raid"){
	        if (raid_exists[image_id]>0) and (sprite_exists(raid[image_id])){drawing_sprite=raid[image_id];drawing_exists=true;}
	    }
	    if (path="purge"){
	        if (purge_exists[image_id]>0) and (sprite_exists(purge[image_id])){drawing_sprite=purge[image_id];drawing_exists=true;}
	    }
	    if (path="event"){
	        if (event_exists[image_id]>0) and (sprite_exists(event[image_id])){drawing_sprite=event[image_id];drawing_exists=true;}
	    }
	    if (path="title_splash"){
	        if (title_splash_exists[1]>0) and (sprite_exists(title_splash[1])){drawing_sprite=title_splash[1];drawing_exists=true;}
	    }
	    if (path="symbol"){
	        if (symbol_exists[image_id]>0) and (sprite_exists(symbol[image_id])){drawing_sprite=symbol[image_id];drawing_exists=true;}
	    }
	    if (path="defeat"){
	        if (defeat_exists[image_id]>0) and (sprite_exists(defeat[image_id])){drawing_sprite=defeat[image_id];drawing_exists=true;}
	    }
	    if (path="slate"){
	        if (slate_exists[image_id]>0) and (sprite_exists(slate[image_id])){drawing_sprite=slate[image_id];drawing_exists=true;}
	    }
    
	    if (drawing_exists=true){
	        draw_sprite_stretched(drawing_sprite,image_id,x1,y1,width,height);
	    }
	    if (drawing_exists=false){
	        draw_set_alpha(1);
	        draw_set_color(0);
	        draw_rectangle(x1,y1,x1+width,y1+height,0);
	        draw_set_color(c_red);
	        draw_rectangle(x1,y1,x1+width,y1+height,1);
	        draw_rectangle(x1+1,y1+1,x1+width-1,y1+height-1,1);
	        draw_rectangle(x1+2,y1+2,x1+width-2,y1+height-2,1);
	        draw_line_width(x1+1.5,y1+1.5,x1+width-1.5,y1+height-1.5,3);
	        draw_line_width(x1+width-1.5,y1+1.5,x1+1.5,y1+height-1.5,3);
	        draw_set_color(c_black);
	    }
    
	    draw_set_alpha(old_alpha);
	    draw_set_color(old_color);
    
	}}
}

/// @description Use this to load the image at given path and id into the image cache so it can be 
/// referenced in a different function to scr_image. Obtain the image later with `obj_img.image_cache[$path][image_id]`
/// returns the sprite id if it exists or -1 if it doesnt
/// @param {String} path the filepath after "images" in the 'datafiles' folder, OR, the filepath after "ChapterMaster" in the %LocalAppData% foler if `use_app_data` is true
/// @param {Real} image_id the number of the image file, convention follows that numbers are "1.png" and so on, if using a prefix, include this in the `path` 
/// @param {Bool} use_app_data determines whether reading from `datafiles` or `%LocalAppData%\ChapterMaster` folder 
function scr_image_cache(path, image_id, use_app_data=false) {
    try {
        var drawing_sprite;
        var cache_arr_exists = struct_exists(obj_img.image_cache, path);
        if (!cache_arr_exists) {
            variable_struct_set(obj_img.image_cache, path, array_create(100, -1));
        }
        // Start with 100 slots but allow it to expand if needed
        if (image_id > 100) {
            for (var i = 100; i <= image_id; i++) {
                array_push(obj_img.image_cache[$ path], -1);
            }
        }

        var existing_sprite = -1;
        try {
            existing_sprite = array_get(obj_img.image_cache[$ path], image_id);
        } catch (_ex) {
            log_error($"error trying to fetch image {path}/{image_id}.png from cache: {_ex}");
            existing_sprite = -1;
        }

        if (sprite_exists(existing_sprite)) {
            drawing_sprite = existing_sprite;
        } else if (image_id > -1) {
            var folders = string_replace_all(path, "/", "\\");
			var dir;
			if(use_app_data){
				dir = $"{folders}{string(image_id)}.png";
			} else {
				dir = $"{working_directory}\\images\\{folders}\\{string(image_id)}.png";
			}
            if (file_exists(dir)) {
                drawing_sprite = sprite_add(dir, 1, false, false, 0, 0);
                if (image_id >= array_length(obj_img.image_cache[$ path])) {
                    array_resize(obj_img.image_cache[$ path], image_id + 1);
                }
                array_set(obj_img.image_cache[$ path], image_id, drawing_sprite);
            } else {
                drawing_sprite = -1;
                log_error($"No directory/file found matching {dir}"); // too much noise
            }
        }
        return drawing_sprite;
    } catch (_exception) {
        handle_exception(_exception);
    }
}

/// @description Simplified handling of chapter icon stuff for both Creation and player chapter icon 
/// attempting to keep things consistent and easy through save/load and etc 
/// @param {Bool} update_global_var set to true when wanting to update the player's icon, false if you just want to return the sprite for further use
function scr_load_chapter_icon(_name, update_global_var = false){

	if (!ds_map_exists(global.chapter_icons_map, _name)) {
		_name = "unknown";
	}

	var _icon_sprite = global.chapter_icons_map[? _name];

	if (update_global_var) {
		global.chapter_icon.name = _name;
		global.chapter_icon.sprite = _icon_sprite;
	}
    
    // Return the loaded sprite
    return _icon_sprite;
}
