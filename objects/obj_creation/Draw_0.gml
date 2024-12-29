

//read
// 850,860


var xx,yy;
xx=375;yy=10;

tooltip="";tooltip2="";
draw_set_alpha(1);
// draw_sprite(spr_creation_slate,0,xx,yy);
scr_image("creation/slate",1,xx,yy,850,860);
draw_set_alpha(1-(slate1/30));
// draw_sprite(spr_creation_slate,1,xx,yy);
scr_image("creation/slate",2,xx,yy,850,860);

draw_set_color(5998382);
if (slate2>0){
    if (slate2<=10) then draw_set_alpha(slate2/10);
    if (slate2>10) then draw_set_alpha(1-((slate2-10)/10));
    draw_line(xx+30,yy+70+(slate2*36),xx+790,yy+70+(slate2*36));
}
if (slate3>0){
    if (slate3<=10) then draw_set_alpha(slate3/10);
    if (slate3>10) then draw_set_alpha(1-((slate3-10)/10));
    draw_line(xx+30,yy+70+(slate3*36),xx+790,yy+70+(slate3*36));
}

allow_colour_click = (cooldown<=0)   and (mouse_left>=1) and (custom>1) and (!instance_exists(obj_creation_popup));

draw_set_alpha(slate4/30);
if (slate4>0){
    /* Chapter Selection grid */
    if (slide==1){
        draw_set_color(38144);
        draw_set_font(fnt_40k_30b);
        draw_set_halign(fa_center);
        draw_text(800,80,string_hash_to_newline("Select Chapter"));
        
        draw_set_font(fnt_40k_30b);
        draw_set_halign(fa_left);

        draw_text_transformed(440,founding_y,"Founding Chapters",0.75,0.75,0);
        draw_text_transformed(440,successor_y,"Existing Chapters",0.75,0.75,0);
		draw_text_transformed(440,custom_y,string_hash_to_newline("Custom Chapters"),0.75,0.75,0);
        draw_text_transformed(440,other_y,string_hash_to_newline("Other"),0.75,0.75,0);

        /// @localvar grid object to keep track of where to draw icon boxes
        var grid = {
            count: 0,
            x1: icon_grid_left_edge,
            y1: founding_y + icon_gap_y,
            w: icon_width,
            h: icon_height,
            x2:0,
            y2:0,
            left_edge: icon_grid_left_edge,
            right_edge: icon_grid_right_edge(),
            row_gap: icon_row_gap,
            section_gap: icon_gap_y,
            col_gap: icon_gap_x,
            /// Updates coords to draw a new icon, creating new rows where needed
            new_cell: function() {
                if(count > 0){
                    x1 = x1 + col_gap;
                } else {
                    x2 = x1 + w;
                    y2 = y1 + h;
                }
                if(x1 > right_edge){
                    x1 = left_edge;
                    y1 = y1 + row_gap;
                }
                x2 = x1 + w;
                y2 = y1 + h;
                count += 1;
            },
            /// given a new y coord for a section heading resets cell drawing to start a new grid
            new_section: function(new_y){
                count = 0;
                x1 = left_edge;
                y1 = new_y + section_gap;
                x2 = x1 + w;
                y2 = y1 + h;
            },
            hover : function(){
                 return scr_hit(x1,y1,x2,y2);
            },
            clicked : function(){
                 return point_and_click([x1,y1,x2,y2]);
            }
        };



        /** * Founding Chapters */
        var i,new_hover,tool;
        i=1;new_hover=highlight;tool=0;
        for(var c = 0; c < array_length(founding_chapters); c++){
            var chap = founding_chapters[c]
            i = chap.id;

            grid.new_cell();
            
            draw_sprite(spr_creation_icon,0,grid.x1,grid.y1);
            scr_image("creation/chapters/icons", chap.icon, grid.x1,grid.y1,grid.w,grid.h);

            // Hover
            if(grid.hover() && slate4>=30){
                if (old_highlight!=highlight) and (highlight!=i) and (goto_slide!=2){old_highlight=highlight;highlighting=1;}
                if (goto_slide!=2){highlight=i;tool=1;}
                // Highlight white on hover
                draw_rectangle_color_simple(grid.x1, grid.y1, grid.x2, grid.y2,0,c_white,0.1);
                // Click
                if (grid.clicked()){
                    cooldown=8000;
                    chapter_name=chap.name;
                    if (!chap.disabled){
                        if(scr_chapter_new(chapter_name)){
                            global.chapter_icon_sprite = obj_img.image_cache[$"creation/chapters/icons"][chap.icon];
                            global.chapter_icon_frame = 0;
                            global.chapter_icon_path = $"creation/chapters/icons";
                            global.chapter_icon_filename = chap.icon;

                            icon=i;custom=0;change_slide=1;goto_slide=2;chapter_string=chapter_name;
                        } else {
                            // Chapter is borked
                        }

                    }
                }
            }
            // grid.x1 += icon_gap_x;
        }
        
        /** * Successor Chapters */
        grid.new_section(successor_y);

        new_hover=highlight;
        for(var c = 0; c < array_length(successor_chapters); c++){
            var chap = successor_chapters[c]
            i = chap.id;

            grid.new_cell();

            draw_sprite(spr_creation_icon,0,grid.x1,grid.y1);
            scr_image("creation/chapters/icons",chap.icon,grid.x1,grid.y1,grid.w, grid.h);

            // Hover
            if (grid.hover() && slate4>=30){
                if (old_highlight!=highlight) and (highlight!=i) and (goto_slide!=2){old_highlight=highlight;highlighting=1;}
                if (goto_slide!=2){highlight=i;tool=1;}
                // Highlight on hover
                draw_rectangle_color_simple(grid.x1, grid.y1, grid.x2, grid.y2,0,c_white,0.1);
                //Click
                if (grid.clicked()){
                    cooldown=8000;
                    chapter_name=chap.name;
                    if (!chap.disabled){
                        if(scr_chapter_new(chapter_name)){
                            global.chapter_icon_sprite = obj_img.image_cache[$"creation/chapters/icons"][chap.icon];
                            global.chapter_icon_frame = 0;
                            global.chapter_icon_path = $"creation/chapters/icons";
                            global.chapter_icon_filename = chap.icon;

                            icon=chap.icon;custom=0;change_slide=1;goto_slide=2;chapter_string=chapter_name;
                        } else {
                            // borked
                        }
                    }
                }
            }
        }
        
        /** * Saved Custom Chapters */
        grid.new_section(custom_y);
		new_hover=highlight;
        for(var c = 0; c < array_length(custom_chapters); c++){
            var chap = custom_chapters[c];
            i = chap.id;
            
            grid.new_cell();
            
            draw_sprite(spr_creation_icon,0,grid.x1,grid.y1);
            if(chap.loaded == false){
                // should be the icon that says 'custom'
                draw_sprite_stretched(spr_icon_chapters, 31, grid.x1,grid.y1, grid.w, grid.h); 
            } else {
                if(chap.icon > global.normal_icons_count){
                    if(string_starts_with(chap.icon_name, "custom")){   
                        var cuicon = obj_cuicons.spr_custom_icon[chap.icon-normal_and_builtin];
                        draw_sprite_stretched(cuicon, 0, grid.x1,grid.y1, grid.w, grid.h);
                    } else {
                        draw_sprite_stretched(spr_icon_chapters, chap.icon - global.normal_icons_count, grid.x1,grid.y1, grid.w, grid.h);
                    }
                } else {
                    scr_image("creation/chapters/icons", chap.icon, grid.x1,grid.y1, grid.w, grid.h);
                }
            }
            
            // Hover
            if (grid.hover() && slate4>=30){
                if (old_highlight!=highlight) and (highlight!=i) and (goto_slide!=2){old_highlight=highlight;highlighting=1;}
                if (goto_slide!=2){highlight=chap.id;tool=1;}
                // Highlight white on hover
                draw_rectangle_color_simple(grid.x1, grid.y1, grid.x2, grid.y2,0,c_white,0.1);

                //Click
                if (grid.clicked()){
					if(chap.loaded == true && chap.disabled == false){
                        if(chap.icon > global.normal_icons_count){
                            if(string_starts_with(chap.icon_name, "custom")){   
                                var cuicon = obj_cuicons.spr_custom_icon[chap.icon-normal_and_builtin];
                                global.chapter_icon_sprite = sprite_duplicate(cuicon);
                                global.chapter_icon_frame = 0;
                                global.chapter_icon_filename = chap.icon_name;
                            } else {
                                global.chapter_icon_sprite = spr_icon_chapters;
                                global.chapter_icon_frame = chap.icon - global.normal_icons_count;
                            }
                        } else {
                            global.chapter_icon_sprite = obj_img.image_cache[$"creation/chapters/icons"][chap.icon];
                            global.chapter_icon_frame = 0;
                            global.chapter_icon_path = $"creation/chapters/icons";
                            global.chapter_icon_filename = chap.icon;
                        }
                        cooldown=8000;
                        chapter_name = chap.name;
                        global.chapter_id = chap.id;
                        change_slide=1;
                        goto_slide=2;
                        scr_chapter_new(chap.id);
                    } else {
                        global.chapter_id = chap.id;
                        cooldown=8000;
                        change_slide=1;
                        goto_slide=2;
                        custom=2;
                        scr_chapter_random(0);
                    }
                }
            }
        }

        /** * Other Chapters */
        grid.new_section(other_y);

        new_hover=highlight;
        for(var c = 0; c < array_length(other_chapters); c++){
            var chap = other_chapters[c];
            i = chap.id;

            grid.new_cell();        
            draw_sprite(spr_creation_icon,0,grid.x1, grid.y1);
            // draw_sprite_stretched(spr_icon,i,x2,y2,48,48);
            scr_image("creation/chapters/icons",chap.icon,grid.x1, grid.y1, grid.w, grid.h);

            // Hover
            if (grid.hover() && slate4>=30){
                if (old_highlight!=highlight) and (highlight!=i) and (goto_slide!=2){old_highlight=highlight;highlighting=1;}
                if (goto_slide!=2){highlight=i;tool=1;}
                // Highlight white on hover
                draw_rectangle_color_simple(grid.x1, grid.y1, grid.x2, grid.y2,0,c_white,0.1);
                //Click
                if (grid.clicked()){
                    cooldown=8000;
                    chapter_name=chap.name;
                    if (!chap.disabled){
                        if(scr_chapter_new(chapter_name)){
                            global.chapter_icon_sprite = obj_img.image_cache[$"creation/chapters/icons"][chap.icon];
                            global.chapter_icon_frame = 0;
                            global.chapter_icon_path = $"creation/chapters/icons";
                            global.chapter_icon_filename = chap.icon;
                            global.chapter_id = chap.id;

                            icon=i;custom=0;change_slide=1;goto_slide=2;chapter_string=chapter_name;
                        } else {
                            // borked
                        }
                    }
                }
            }
        }
        
        /* Blank Custom + Random*/
        grid.new_cell();

        i=1001;
        repeat(2){
            grid.new_cell();            

            draw_sprite(spr_creation_icon,0,grid.x1, grid.y1);
            draw_sprite_stretched(spr_icon_chapters,i-1001,grid.x1, grid.y1, grid.w, grid.h);

            
            if (grid.hover() && slate4>=30){
                if (old_highlight!=highlight) and (highlight!=i) and (goto_slide!=2){old_highlight=highlight;highlighting=1;}
                if (goto_slide!=2){highlight=i;tool=1;}
                draw_rectangle_color_simple(grid.x1, grid.y1, grid.x2, grid.y2,0,c_white,0.1);
                if (grid.clicked()){
                    cooldown=8000;
                    icon=1;
                    icon_name="da";
                    change_slide=1;
                    goto_slide=2;
                    if (i=1001){custom=2;scr_chapter_random(0);}
                    if (i=1002){custom=1;scr_chapter_random(1);}
                }
            }
            i+=1;
        }
        
        if (tool=1) and (highlighting<30) then highlighting+=1;
        if (tool=0) and (highlighting>0) then highlighting-=1;
        // if (new_hover=0) then highlight=0;
        
        if ((highlight>0) and (highlighting>0)) or ((change_slide>0) and (goto_slide!=1)){
            draw_set_alpha(min(slate4/30,highlighting/30));
            if (change_slide>0) then draw_set_alpha(1);
            
            if (highlight=1001) then scr_image("creation/chapters/splash",97,0,68,374,713);
            if (highlight=1002) then scr_image("creation/chapters/splash",98,0,68,374,713);
            if( highlight <= array_length(all_chapters)){
                var splash_chapter = all_chapters[highlight];
                //show_debug_message($"highlight {highlight} splash chapter {splash_chapter.id} splash icon {splash_chapter.splash}");
                scr_image("creation/chapters/splash", splash_chapter.splash,0,68,374,713);
            }

            draw_set_alpha(slate4/30);
            draw_set_color(38144);
            draw_rectangle(0,68,374,781,1);
        }
        draw_set_alpha(slate4/30);
        
        
        
        
        if (instance_exists(obj_cursor)){obj_cursor.image_index=0;}
        if (tool=1) and (change_slide<=0){
            if (instance_exists(obj_cursor)){obj_cursor.image_index=1;}
            
            draw_set_alpha(1);
            draw_set_color(0);
            draw_set_halign(fa_left);
            
            if (highlight<=array_length(all_chapters)){
                var chap = all_chapters[highlight];
                tooltip=chap.name;
                if(chap.progenitor != 0 && chap.progenitor <10) {tooltip += "  - Progenitor: " + all_chapters[chap.progenitor].name};
                tooltip2=chap.tooltip;
            }
            if (highlight=1001) then tooltip="Custom";
            if (highlight=1002) then tooltip="Randomize";
            if (highlight=1001) then tooltip2="Create your own customized Chapter, deciding the origins, strength, and weaknesses.  Custom Chapters are weaker than Founding Chapters.";
            if (highlight=1002) then tooltip2="Randomly generate a Chapter to play.  The origins, strength, and weaknesses are all random.  Random Chapters are normally weaker than Founding Chapters. ";
        }
    }
}



var yar;yar=0;


if (slide>=2){
    tooltip="";tooltip2="";
    
    if (goto_slide!=1){
        
        if (custom=2) then draw_sprite(spr_creation_other,4,0,68);
        if (custom=1) then draw_sprite(spr_creation_other,5,0,68);
        
        draw_set_color(38144);
        draw_rectangle(0,68,374,781,1);
    }
    
    draw_set_color(0);
    // draw_rectangle(436,74,436+128,74+128,0);
    // if (icon<=20) then draw_sprite_stretched(spr_icon,icon,436,74,128,128);
    
    var sprx = 436,
    spry =74,
    sprw = 128,
    sprh = 128;

    draw_sprite_stretched(global.chapter_icon_sprite, global.chapter_icon_frame, sprx, spry, sprw, sprh);
       
    obj_cursor.image_index=0;
    if (scr_hit(436,74,436+128,74+128)) and (popup=""){obj_cursor.image_index=1;
        tooltip="Chapter Icon";tooltip2="Your Chapter's icon.  Click to edit.";
        
        /*if (cooldown<=0) and (mouse_left=1){
            popup="icons";cooldown=8000;
        }*/
    }
    
    var i;i=0;
    repeat(290){i+=1;
        if (icon_name="custom"+string(i)) and (obj_cuicons.spr_custom[i]>0){
            if (sprite_exists(obj_cuicons.spr_custom_icon[i])){
                draw_sprite_stretched(obj_cuicons.spr_custom_icon[i],0,436,74,128,128);
                
                
                // obj_cuicons.spr_custom_icon[ic-78]
            }
        }
    }
    
    // draw_set_color(c_orange);
    // draw_text(436+64,74-30,string(icon_name));
    
    
    if (slide=2){
        /*if (scr_hit(548,149,584,193)){obj_cursor.image_index=1;
            if (cooldown<=0) and (mouse_left>=1){cooldown=8000;scr_icon("-");}
        }
        if (scr_hit(595,149,634,193)){obj_cursor.image_index=1;
            if (cooldown<=0) and (mouse_left>=1){cooldown=8000;scr_icon("+");}
        }*/
        
        
        if (founding!=0){
            draw_set_font(fnt_40k_30b);
            // draw_text_transformed(
        
            draw_set_alpha(0.33);
            // if (founding<10) then draw_sprite_stretched(spr_icon,founding,1164-128,74,128,128);
            if (founding<10) then scr_image("creation/chapters/icons",founding,1164-128,74,128,128);
            if (founding=10) then draw_sprite_stretched(spr_icon_chapters,0,1164-128,74,128,128);
            draw_set_alpha(1);
            
            if (scr_hit(1164-128,74,1164,74+128)){tooltip="Founding Chapter";tooltip2="The parent Chapter whos Gene-Seed your own originates from.";}
            
            if (custom>1){
                draw_sprite_stretched(spr_creation_arrow,0,1164-194,160,32,32);
                draw_sprite_stretched(spr_creation_arrow,1,1164-144,160,32,32);
                
                if (scr_hit(1164-194,149,1164-162,193)){obj_cursor.image_index=1;
                    if (cooldown<=0) and (mouse_left>=1){cooldown=8000;founding-=1;
                    if (founding=0) then founding=10;}
                }
                if (scr_hit(1164-144,149,1164-112,193)){obj_cursor.image_index=1;
                    if (cooldown<=0) and (mouse_left>=1){cooldown=8000;founding+=1;
                    if (founding=11) then founding=1;}
                }
            }
            
            
        }
        
        
        
    }
    
    
}

/* Chapter Naming, Points assignment, advantages/disadvantages */
if (slide=2){
    draw_set_color(38144);
    draw_set_font(fnt_40k_30b);
    draw_set_halign(fa_center);
    
    obj_cursor.image_index=0;
    
    if (name_bad=1) then draw_set_color(c_red);
    if (text_selected!="chapter") or (custom!=2) then draw_text(800,80,string_hash_to_newline(string(chapter_name)));
    if (custom=2){
        if (text_selected="chapter") and (text_bar>30) then draw_text(800,80,string_hash_to_newline(string(chapter_name)));
        if (text_selected="chapter") and (text_bar<=30) then draw_text(805,80,string_hash_to_newline(string(chapter_name)+"|"));
        if (scr_text_hit(800,80,true,chapter_name)){
            obj_cursor.image_index=2;
            if (cooldown<=0) and (mouse_left>=1){text_selected="chapter";cooldown=8000;keyboard_string=chapter_name;}
        }
        if (text_selected="chapter") then chapter_name=keyboard_string;
        draw_set_alpha(0.75);draw_rectangle(580,80,1020,118,1);draw_set_alpha(1);
    }
    
    draw_set_color(38144);
    draw_text_transformed(800,120,string_hash_to_newline("Points: "+string(points)+"/"+string(maxpoints)),0.6,0.6,0);
    
    
    obj_cursor.image_index=0;
    if (custom>0) and (restarted=0){
        if (scr_hit(436,74,436+128,74+128)) and (popup=""){obj_cursor.image_index=1;
            if (cooldown<=0) and (mouse_left=1){
                popup="icons";cooldown=8000;
            }
        }
    }
    
    /*if (custom>0) and (restarted=0){
        draw_sprite_stretched(spr_creation_arrow,0,550,160,32,32);
        draw_sprite_stretched(spr_creation_arrow,1,597,160,32,32);
    }*/
    
    draw_set_color(38144);
    draw_line(445,200,1125,200);
    draw_line(445,201,1125,201);
    draw_line(445,202,1125,202);
    
    if (popup=""){
        if (custom<2) then draw_set_alpha(0.5);
        draw_text_transformed(800,211,string_hash_to_newline("Chapter Type"),0.6,0.6,0);
        draw_set_halign(fa_left);
        
        if (scr_hit(516,242,674,266)){tooltip="Homeworld";tooltip2="Your chapter has a homeworld that they base on.  Contained upon it is a massive Fortress Monastery, which provides high levels of defense and automated weapons.";}
        if (scr_hit(768,242,866,266)){tooltip="Fleet Based";tooltip2="Rather than a homeworld your chapter begins near their recruiting world.  The fleet includes a Battle Barge, which serves as a mobile base, and powerful ship.";}
        if (scr_hit(952,242,1084,266)){tooltip="Penitent";tooltip2="As with Fleet Based, but you must crusade and fight until your penitence meter runs out.  Note that recruiting is disabled until then.";}// Avoiding fights will result in excomunicatus traitorus.
        
        if (custom<2) then draw_set_alpha(0.5);
        yar=0;if (fleet_type=1) then yar=1;draw_sprite(spr_creation_check,yar,519,239);yar=0;
        if (scr_hit(519,239,519+32,239+32)) and (cooldown<=0) and (mouse_left>=1) and (custom=2){cooldown=8000;
            if (points+20<=maxpoints) and (fleet_type=3){points+=20;fleet_type=1;}
            if (fleet_type=2){fleet_type=1;}
        }
        draw_text_transformed(551,239,string_hash_to_newline("Homeworld"),0.6,0.6,0);
        
        yar=0;if (fleet_type=2) then yar=1;draw_sprite(spr_creation_check,yar,771,239);yar=0;
        if (scr_hit(771,239,771+32,239+32)) and (cooldown<=0) and (mouse_left>=1) and (custom=2){cooldown=8000;
            if (points+20<=maxpoints) and (fleet_type=3){points+=20;fleet_type=2;}
            if (fleet_type=1){fleet_type=2;}
        }
        draw_text_transformed(804,239,string_hash_to_newline("Fleet Based"),0.6,0.6,0);
        
        yar=0;if (fleet_type=3) then yar=1;draw_sprite(spr_creation_check,yar,958,239);yar=0;
        if (scr_hit(958,239,958+32,239+32)) and (cooldown<=0) and (mouse_left>=1) and (custom=2){if (fleet_type!=3) then points-=20;fleet_type=3;cooldown=8000;}
        draw_text_transformed(990,239,string_hash_to_newline("Penitent"),0.6,0.6,0);
        draw_set_alpha(1);
        
        draw_line(445,289,1125,289);
        draw_line(445,290,1125,290);
        draw_line(445,291,1125,291);
        
        draw_set_halign(fa_center);
        draw_text_transformed(800,301,string_hash_to_newline("Chapter Stats"),0.6,0.6,0);
        draw_set_halign(fa_right);
        
        draw_text_transformed(617,332,$"Strength ({strength})",0.5,0.5,0);
        draw_text_transformed(617,387,$"Cooperation ({cooperation})",0.5,0.5,0);
        draw_text_transformed(617,442,$"GeneSeed Purity ({purity})",0.5,0.5,0);
        draw_text_transformed(617,497,$"GeneSeed Stability ({stability})",0.5,0.5,0);
        var arrow_buttons_controls = [strength, cooperation, purity, stability]
        for (var i=0;i<4;i++){
            if (custom=2) then draw_sprite_stretched(spr_arrow,0,625,325+(i*55),32,32);
            if (scr_hit(625,325+(i*55),657,357+(i*55))){
                obj_cursor.image_index=1;
                if (cooldown<=0) and (custom=2) and (arrow_buttons_controls[i]>1) and (mouse_left>=1){
                    arrow_buttons_controls[i]-=1;
                    points-=10;
                    cooldown=8000;
                }
            }
            if (custom=2) then draw_sprite_stretched(spr_arrow,1,1135,325+(i*55),32,32);
            if (scr_hit(1135,325+(i*55),1167,357+(i*55))){
                obj_cursor.image_index=1;
                if (cooldown<=0) and (custom=2) and (arrow_buttons_controls[i]<10) and (points+10<=maxpoints) and (mouse_left>=1){
                    arrow_buttons_controls[i]+=1;
                    points+=10;
                    cooldown=8000;
                }
            }
            draw_rectangle(668,330+(i*55),1125,351+(i*55),1);   
            draw_rectangle(668,330+(i*55),668+(arrow_buttons_controls[i]*45.7),351+(i*55),0);     
        }
        strength = arrow_buttons_controls[0];
        cooperation = arrow_buttons_controls[1];
        purity = arrow_buttons_controls[2];
        stability = arrow_buttons_controls[3];
        
        if (scr_hit(532,325,1166,357)){tooltip="Strength";tooltip2="How many companies your chapter begins with.  For every score below five a company will be removed; conversely, each score higher grants 50 additional astartes.";}
        if (scr_hit(486,380,1166,412)){tooltip="Cooperation";tooltip2="How diplomatic your chapter is.  A low score will lower starting dispositions of Imperial factions and make disposition increases less likely to occur.";}
        if (scr_hit(442,435,1166,467)){tooltip="Purity";tooltip2="A measure of how pure and mutation-free your chapter's gene-seed is.  A perfect score means no mutations must be chosen.  The lower the score, the more mutations.";}
        if (scr_hit(423,490,1166,522)){tooltip="Stability";tooltip2="A measure of how easily new mutations and corruption can occur with your chapter-gene seed.  A perfect score makes the gene-seed almost perfectly stable.";}
    }
    
    if (popup!="icons"){
        draw_rectangle(445, 551, 1125, 553, 0);
    }
    
    if (popup!="") or (custom<2) then draw_set_alpha(0.5);
    
    
    if (popup!="icons"){
        var advantage_click = (mouse_left>=1  && cooldown<=0  &&  custom>1);
        draw_set_halign(fa_left);
        draw_set_font(fnt_40k_30b);
        draw_text_transformed(436,564,"Chapter Advantages",0.5,0.5,0);
        draw_set_font(fnt_40k_14);
        var adv_txt = {
            x1: 436,
            y1: 570,
            w: 204,
            h: 20,
        }
        adv_txt.x2 = adv_txt.x1 + adv_txt.w;
        adv_txt.y2 = adv_txt.y1 + adv_txt.h;
        var max_advantage_count = 8;
        for (i=1;i<=max_advantage_count;i++){
            var draw_string = adv_num[i]==0?"[+]":"[-] "+adv[i];
            draw_text(adv_txt.x1,adv_txt.y1+(i*adv_txt.h), draw_string);
            if (scr_hit(adv_txt.x1,adv_txt.y1+(i*adv_txt.h),adv_txt.x2,adv_txt.y2+(i*adv_txt.h))){

                if (points>=maxpoints) and (adv_num[i]=0) and (popup="") and (custom>1){
                    tooltip="Insufficient Points";
                    tooltip2="Add disadvantages or decrease Chapter Stats";
                }
                
                if (adv_num[i]!=0){
                    var cur_adv = obj_creation.all_advantages[adv_num[i]];
                    tooltip=$"{cur_adv.name} ({cur_adv.points} Points)";
                    tooltip2=cur_adv.description;
                }
                if (advantage_click){
                    if (points<maxpoints) and (adv_num[i]=0) and (popup=""){
                        popup="advantages";
                        cooldown=8000;
                        temp=i;
                    }
                    var removable=false;
                    if (i==max_advantage_count && adv_num[i]>0){
                        removable=true;
                    } else if (adv_num[i]>0 && adv_num[i+1]=0){
                        removable=true;
                    }
                    if  (mouse_x<=456) and (removable){

                        var cur_ad = obj_creation.all_advantages[adv_num[i]]
                        cur_ad.remove(i);

                        cooldown=8000;
                    }
                }              
            }
        }
        draw_set_font(fnt_40k_30b);
        draw_text_transformed(810,564,"Chapter Disadvantages",0.5,0.5,0);
        draw_set_font(fnt_40k_14);

        var dis_txt = {
            x1: 810,
            y1: 570,
            w: 204,
            h: 20,
        }
        dis_txt.x2 = dis_txt.x1 + dis_txt.w;
        dis_txt.y2 = dis_txt.y1 + dis_txt.h;
        var max_disadvantage_count = 8;
        for (var slot =1;slot<=max_disadvantage_count;slot++){
            var draw_string = dis_num[slot]==0?"[+]":"[-] "+dis[slot];
            draw_text(dis_txt.x1,dis_txt.y1+(slot*dis_txt.h), draw_string);
            if (scr_hit(dis_txt.x1,dis_txt.y1+(slot*dis_txt.h),dis_txt.x2,dis_txt.y2+(slot*dis_txt.h))){
                if (dis_num[slot]!=0){
                    tooltip=obj_creation.all_disadvantages[dis_num[slot]].name;
                    tooltip2=obj_creation.all_disadvantages[dis_num[slot]].description;
                }
                if (advantage_click){
                    if ((dis_num[slot]=0) and (popup="")){
                        popup="disadvantages";
                        cooldown=8000;
                        temp=slot;
                    }
                    var removable=false;
                    if (slot==max_disadvantage_count && dis_num[slot]>0){
                        removable=true;
                    } else if (dis_num[slot]>0 && dis_num[slot+1]==0){
                        removable=true;

                    }
                    var cur_dis = obj_creation.all_disadvantages[dis_num[slot]];                    
                    if  (mouse_x<=830) and (removable) and (points+cur_dis.points<=maxpoints) {
                        var cur_dis = obj_creation.all_disadvantages[dis_num[slot]];
                        cur_dis.remove(slot);

                        cooldown=8000;
                    }   
                }             
            }
        }
        draw_set_alpha(1);
        if (scr_hit(436,564,631,583)){
            tooltip="Chapter Advantages";
            tooltip2="Advantages cost points, and improve the performance of your chapter in a specific domain. You can only have 1 trait of the same category, shown in brackets.";
        }
        if (scr_hit(810,564,1030,583)){
            tooltip="Chapter Disadvantages";
            tooltip2="Disadvantages grant additional points, and penalize the performance of your chapter. You can only have 1 trait of the same category, shown in brackets.";
        }
    }else if (popup="icons"){
        draw_set_alpha(1);
        draw_set_color(0);
        draw_rectangle(450,206,1144,711,0);
        
        draw_set_color(38144);
        draw_line(445,727,1125,727);
        draw_line(445,728,1125,728);
        draw_line(445,729,1125,729);
        
        draw_set_font(fnt_40k_30b);
        draw_set_halign(fa_center);
        draw_text_transformed(800,211,"Select an Icon",0.6,0.6,0);
        draw_text_transformed(800,687,"Cancel",0.6,0.6,0);
        
        var cw,ch;
        cw=string_width("Cancel")*0.6;
        ch=string_height("Cancel")*0.6;
        
        if (scr_hit(800,687,800+cw,687+ch)){
            draw_set_color(c_white);
            draw_set_alpha(0.25);
            draw_text_transformed(800,687,string_hash_to_newline("Cancel"),0.6,0.6,0);
            draw_set_color(38144);
            draw_set_alpha(1);
            
            if (mouse_left=1) and (cooldown<=0){
                cooldown=8000;
                popup="";
            }
        }
        
        draw_set_font(fnt_40k_14b);draw_set_halign(fa_left);
        
        // repeat here
        
        var i,ic,x3,y3,row;
        i=0;ic=icons_top-1;x3=445-110;y3=245;row=0;
        
        repeat(24){
            i+=1;ic+=1;row+=1;
            
            if (row=7){
                row=1;x3=445-110;y3+=110;
            }
            
            x3+=110;
            if (ic<=(total_icons)){
                //ic starts at 1, normal icons = 22
                if (ic<global.normal_icons_count) {
                    scr_image("creation/chapters/icons",ic,x3,y3,96,96);
                } 
                if (ic>=global.normal_icons_count) and (ic<normal_and_builtin) {
                    draw_sprite_stretched(spr_icon_chapters,ic-global.normal_icons_count,x3,y3,96,96);
                } 
                if (ic>=normal_and_builtin) and (obj_cuicons.spr_custom[ic-normal_and_builtin]>0) and (obj_cuicons.spr_custom_icon[ic-normal_and_builtin]!=-1){
                    draw_sprite_stretched(obj_cuicons.spr_custom_icon[ic-normal_and_builtin],0,x3,y3,96,96);
                }
                
                // highlight on hover
                if (scr_hit(x3,y3,x3+96,y3+96)){
                    draw_set_blend_mode(bm_add);
                    draw_set_alpha(0.25);
                    draw_set_color(16119285);
                    // if (ic<=20) then draw_sprite_stretched(spr_icon,ic,x3,y3,96,96);
                    if (ic<global.normal_icons_count) {
                        scr_image("creation/chapters/icons",ic,x3,y3,96,96);
                    } 
                    if (ic>=global.normal_icons_count) and (ic<normal_and_builtin) {
                        draw_sprite_stretched(spr_icon_chapters,ic-global.normal_icons_count,x3,y3,96,96);
                    } 
                    if (ic>=normal_and_builtin) and (obj_cuicons.spr_custom[ic-normal_and_builtin]>0) and (obj_cuicons.spr_custom_icon[ic-normal_and_builtin]!=-1){
                        draw_sprite_stretched(obj_cuicons.spr_custom_icon[ic-normal_and_builtin],0,x3,y3,96,96);
                    }
                    draw_set_blend_mode(bm_normal);
                    draw_set_alpha(1);
                    draw_set_color(38144);
                    
                    if (mouse_left=1) and (cooldown<=0){
                        cooldown=8000;
                        popup="";
                        icon=ic;
                        icon_name="";
                        scr_icon("");
                        if (ic <= global.normal_icons_count){
                            global.chapter_icon_sprite = obj_img.image_cache[$"creation/chapters/icons"][ic];
                            global.chapter_icon_frame = 0;
                            global.chapter_icon_path = $"creation/chapters/icons";
                            global.chapter_icon_filename = ic;
                        }
                        if (ic>normal_and_builtin) {
                            var cuicon_idx = ic-normal_and_builtin;
                            global.chapter_icon_sprite = sprite_duplicate(obj_cuicons.spr_custom_icon[cuicon_idx]);
                            global.chapter_icon_frame = 0;
                            obj_creation.icon_name = string_concat("custom", cuicon_idx);
                        }
                        if (ic>global.normal_icons_count && ic <=normal_and_builtin) {
                            global.chapter_icon_sprite = spr_icon_chapters;
                            global.chapter_icon_frame = ic-global.normal_icons_count;
                            custom_icon=ic-global.normal_icons_count;
                        }
                        // show_debug_message($"ic {ic} custom_icon {custom_icon} icon {icon}")
                        // show_message(string(icon_name));
                    }
                    
                }
                
                // draw_set_color(c_orange);
                // draw_text(x3+48,y3+64,string(ic));
                draw_set_color(38144);
            }
        }
        
        
        var x1,x2,x3,x4,x6,y1,y2,y3,y4,y6,bs,see_size,total_max,current,top;
        
        x1=1111;y1=245;x2=1131;y2=671;bs=245;
        draw_rectangle(x1,y1,x2,y2,1);
        
        total_max=77+global.custom_icons;
        see_size=(671-245)/total_max;
        
        x3=1111;x4=1131;
        current=icons_top;
        top=current*see_size;
        y3=top;y4=y3+(24*see_size)-see_size;
        
        
        if (scrollbar_engaged=0) then draw_rectangle(x3,y3+bs,x4,y4+bs,0);
        
        if (scrollbar_engaged>0){
            y3=mouse_y-scrollbar_engaged;
            // y3=mouse_y-scrollbar_engaged
            y4=y3+(24*see_size);
            
            if (y3<y1){y3=y1;y4=y3+(24*see_size);}
            if (y4>y2){y4=y2;y3=y2-(24*see_size);}
            
            draw_rectangle(x3,y3,x4,y4,0);
        }
        
        
        if (scr_hit(x3,y3+bs,x4,y4+bs)) and (cooldown<=0) and (scrollbar_engaged<=0) and (mouse_left=1){// Click within the scrollbar grip area
            scrollbar_engaged=mouse_y-(y3+bs);cooldown=8000;
        }
        
        
        
    }
    
    
    
    
    if (popup="advantages"){
        draw_set_font(fnt_40k_30b);
        draw_set_halign(fa_center);
        draw_text_transformed(800,211,"Select an Advantage",0.6,0.6,0);
        draw_set_font(fnt_40k_14b);
        draw_set_halign(fa_left);
        
        for(var slot = 0; slot < array_length(obj_creation.all_advantages); slot++){
            var advantage_local_var = obj_creation.all_advantages[slot];
            var column = {
                x1: 436,
                y1: 250,
                w: 100,
                h: 20,
            }
            column.x2 = column.x1 + column.w;
            column.y2 = column.y1 + column.h;
            var disable = 0;
            if (advantage_local_var.name != ""){
                var adv_name = advantage_local_var.name;
                //columns of 14, shift the left boarder across

                if(slot >= 15 && slot <29) {
                    column.x1 = 670;
                    column.x2 = column.x1 + column.w;
                };
                if(slot >= 29 && slot <42) {
                    column.x1 = 904;
                    column.x2 = column.x1 + column.w;
                };
                draw_set_color(38144);
                draw_set_alpha(1);
                disable = array_contains(adv, adv_name);
                if (!disable){
                    disable = advantage_local_var.disable();
                }
                if (disable) then draw_set_alpha(0.5);
                

                var gap = (((slot-1)%14) * column.h);
                var adv_width = string_width(adv_name);
                draw_text(column.x1,column.y1+gap,adv_name);
                
                // Cancel button
                var coords = [column.x1,column.y1+gap,column.x1+adv_width,column.y1+column.h+gap];
                if (point_and_click(coords)) and (cooldown<=0) and (adv_name="Cancel"){
                    cooldown=8000;
                    popup="";
                }
                // Tooltips
                if (scr_hit(coords)){
                    tooltip=$"{adv_name} ({advantage_local_var.points})";
                    tooltip2=$"{advantage_local_var.description} \nCategories: {advantage_local_var.print_meta()}";
                    draw_set_color(c_white);
                    draw_set_alpha(0.2);
                    draw_text(column.x1,column.y1+gap,adv_name);
                }
                //Click on advantage
                if (point_and_click(coords)) and (cooldown<=0)  and (array_contains(adv, adv_name) == false){
                    if (disable=0){
                        cooldown=8000;
                        advantage_local_var.add(temp);
                        popup="";
                    }
                }
            }
        }
    }
        
    else if (popup="disadvantages"){
        draw_set_font(fnt_40k_30b);
        draw_set_halign(fa_center);
        draw_text_transformed(800,211,"Select a Disadvantage",0.6,0.6,0);
        draw_set_font(fnt_40k_14b);draw_set_halign(fa_left);
        for(var slot = 0; slot < array_length(obj_creation.all_disadvantages); slot++){
            var disadvantage_local_var = obj_creation.all_disadvantages[slot];
            var column = {
                x1: 436,
                y1: 250,
                w: 100,
                h: 20,
            }
            column.x2 = column.x1 + column.w;
            column.y2 = column.y1 + column.h;
            var disable = 0;
            if (disadvantage_local_var.name!=""){
                var dis_name = disadvantage_local_var.name;
                //columns of 14, shift the left boarder across and leave a gap at the top on cols 2 & 3
                if(slot >= 15 && slot <29) {
                    column.x1 = 670;
                    column.x2 = column.x1 + column.w;
                };
                if(slot >= 29 && slot <42) {
                    column.x1 = 904;
                    column.x2 = column.x1 + column.w;
                };
                draw_set_color(38144);

                

                disable = (disadvantage_local_var.disable() || array_contains(dis, dis_name));

                if (!disable){
                    disable = (dis_name=="Blood Debt" && fleet_type==3);
                }

                draw_set_alpha(disable?0.5:1);


                
                var gap = (((slot-1)%14) * column.h);

                draw_text(column.x1,column.y1+gap,dis_name);
                
                var dis_width = string_width(dis_name);
                // Cancel button
                var coords = [column.x1,column.y1+gap,column.x1+dis_width,column.y1+column.h+gap];

                if (point_and_click(coords)) and (cooldown<=0) and (dis_name="Cancel"){
                    cooldown=8000;
                    popup="";
                }
                //Tooltip
                if (scr_hit(coords)){
                    tooltip=$"{dis_name} ({disadvantage_local_var.points})";
                    tooltip2=$"{disadvantage_local_var.description} \nCategories: {disadvantage_local_var.print_meta()}";
                    draw_set_color(c_white);
                    draw_set_alpha(0.2);
                    draw_text(column.x1,column.y1+gap,dis_name);
                }
                //Click on disadvantage
                if (point_and_click(coords)) and (cooldown<=0)  and (array_contains(dis, dis_name) == false){
                    if (disable==false){
                        cooldown=8000;
                        popup="";
                        disadvantage_local_var.add(temp);
                    }
                }
            }
        }
    }
    if (popup!="") and ((mouse_left>=1) or (mouse_right=1)) and (cooldown<=0){
        if ((mouse_x<445) or (mouse_x>1125) or (mouse_y<200) or (mouse_y>552)) and (popup!="icons"){
            cooldown=8000;
            popup="";
        }
        if ((mouse_x<445) or (mouse_x>1125) or (mouse_y<200) or (mouse_y>719)) and (popup="icons"){
            cooldown=8000;
            popup="";
        }
    }
    
}

/* Homeworld, Flagship, Psychic discipline, Aspirant Trial */

var yar=0;

if (slide=3){
    draw_set_color(38144);
    draw_set_font(fnt_40k_30b);
    draw_set_halign(fa_center);
    
    tooltip="";
    tooltip2="";
    obj_cursor.image_index=0;
    
    draw_text(800,80,string_hash_to_newline(string(chapter_name)));
    
    draw_set_color(38144);
    draw_line(445,200,1125,200);
    draw_line(445,201,1125,201);
    draw_line(445,202,1125,202);
    
    
    
    
    var fleet_type_text = fleet_type==eFLEET_TYPES.HOMEWORLD ? "Homeworld" : "Flagship";
    draw_text_transformed(644,218,fleet_type_text,0.6,0.6,0);

    var eh,eh2;eh=0;eh2=0;name_bad=0;
    
    if (homeworld="Lava") then eh=2;
    if (homeworld="Desert") then eh=3;
    if (homeworld="Forge") then eh=4;
    if (homeworld="Hive") then eh=5;
    if (homeworld="Death") then eh=6;
    if (homeworld="Agri") then eh=7;
    if (homeworld="Feudal") then eh=8;
    if (homeworld="Temperate") then eh=9;
    if (homeworld="Ice") then eh=10;
    if (homeworld="Dead") then eh=11;
    if (homeworld="Shrine") then eh=17;
    if (fleet_type!=1) then eh=16;
    
    if (fleet_type == eFLEET_TYPES.HOMEWORLD){
        scr_image("ui/planet",eh,580,244,128,128);
        // draw_sprite(spr_planet_splash,eh,580,244);
        
        draw_text_transformed(644,378,string_hash_to_newline(string(homeworld)),0.5,0.5,0);
        // draw_text_transformed(644,398,string(homeworld_name),0.5,0.5,0);
        if (text_selected!="home_name") or (custom<2) then draw_text_transformed(644,398,string_hash_to_newline(string(homeworld_name)),0.5,0.5,0);
        if (custom>1){
            if (text_selected="home_name") and (text_bar>30) then draw_text_transformed(644,398,string_hash_to_newline(string(homeworld_name)),0.5,0.5,0);
            if (text_selected="home_name") and (text_bar<=30) then draw_text_transformed(644,398,string_hash_to_newline(string(homeworld_name)+"|"),0.5,0.5,0);
            if (scr_text_hit(644,398,true,homeworld_name)){
                obj_cursor.image_index=2;
                if (cooldown<=0) and (mouse_left>=1){text_selected="home_name";cooldown=8000;keyboard_string=homeworld_name;}
            }
            if (text_selected="home_name") then homeworld_name=keyboard_string;
            draw_set_alpha(0.75);
            draw_rectangle(525,398,760,418,1);
            draw_set_alpha(1);
            var _refresh_hw_name_btn =[770, 398, 790, 418];
            draw_unit_buttons(_refresh_hw_name_btn,"?", [1,1], 38144,,fnt_40k_14b);
            if(point_and_click(_refresh_hw_name_btn)){
                var _new_hw_name = global.name_generator.generate_star_name();
                show_debug_message($"regen name of homeworld from {homeworld_name} to {_new_hw_name}");
                homeworld_name = _new_hw_name;
            }
        }
        
        if (custom>1) then draw_sprite_stretched(spr_creation_arrow,0,525,285,32,32);// Left Arrow
        if (custom>1) then draw_sprite_stretched(spr_creation_arrow,1,725,285,32,32);// Right Arrow
        var planet_types = ["Dead","Ice", "Temperate","Feudal","Shrine","Agri","Death","Hive","Forge","Desert","Lava"];
        var planet_change_allow = (mouse_left>=1) and (cooldown<=0) and (custom>1);
        for (var i=0;i<array_length(planet_types);i++){
            if (homeworld==planet_types[i] && planet_change_allow){
                if (point_and_click([525,285,525+32,285+32])){
                    if (i==array_length(planet_types)-1){
                        homeworld=planet_types[0];
                    } else {
                        homeworld=planet_types[i+1];
                    }
                    break;
                } else if (point_and_click([725,285,725+32,285+32])){
                    if (i==0){
                        homeworld=planet_types[array_length(planet_types)-1];
                    } else {
                        homeworld=planet_types[i-1];
                    }
                    break;
                }
            }
        }
    }
    if (fleet_type != eFLEET_TYPES.HOMEWORLD){
        // draw_sprite(spr_planet_splash,eh,580,244);
        scr_image("ui/planet",eh,580,244,128,128);
        
        draw_text_transformed(644,378,string_hash_to_newline("Battle Barge"),0.5,0.5,0);
        // draw_text_transformed(644,398,string(homeworld_name),0.5,0.5,0);
        if (text_selected!="flagship_name") or (custom=0) then draw_text_transformed(644,398,string_hash_to_newline(string(flagship_name)),0.5,0.5,0);
        if (custom>1){
            if (text_selected="flagship_name") and (text_bar>30) then draw_text_transformed(644,398,string_hash_to_newline(string(flagship_name)),0.5,0.5,0);
            if (text_selected="flagship_name") and (text_bar<=30) then draw_text_transformed(644,398,string_hash_to_newline(string(flagship_name)+"|"),0.5,0.5,0);
            if (scr_text_hit(644,398,true,flagship_name)){
                obj_cursor.image_index=2;
                if (cooldown<=0) and (mouse_left>=1){
                    text_selected="flagship_name";
                    cooldown=8000;
                    keyboard_string=flagship_name;
                }
            }
            if (text_selected="flagship_name") then flagship_name=keyboard_string;
            draw_set_alpha(0.75);draw_rectangle(525,398,760,418,1);draw_set_alpha(1);
            var _refresh_fs_name_btn =[770, 398, 790, 418];
            draw_unit_buttons(_refresh_fs_name_btn,"?", [1,1], 38144,,fnt_40k_14b);
            if(point_and_click(_refresh_fs_name_btn)){
                var _new_fs_name = global.name_generator.generate_imperial_ship_name();
                show_debug_message($"regen name of flagship_name from {flagship_name} to {_new_fs_name}");
                flagship_name = _new_fs_name;
            }
        }
    }
    
    
    
    
    
    if (fleet_type!=eFLEET_TYPES.PENITENCE){
        if (fleet_type!=1) or (custom<2) then draw_set_alpha(0.5);
        yar=0;if (recruiting_exists=1) then yar=1;draw_sprite(spr_creation_check,yar,858,221);yar=0;
        if (scr_hit(858,221,858+32,221+32)) and (cooldown<=0) and (mouse_left>=1) and (custom>1) and (fleet_type=1){cooldown=8000;var onceh;onceh=0;
            if (recruiting_exists=1) and (onceh=0){recruiting_exists=0;onceh=1;}
            if (recruiting_exists=0) and (onceh=0){recruiting_exists=1;onceh=1;}
        }
        draw_set_alpha(1);draw_text_transformed(644+333,218,string_hash_to_newline("Recruiting World"),0.6,0.6,0);
        
        if (recruiting_exists=1){
            if (recruiting="Lava") then eh2=2;
            if (recruiting="Desert") then eh2=3;
            if (recruiting="Forge") then eh2=4;
            if (recruiting="Hive") then eh2=5;
            if (recruiting="Death") then eh2=6;
            if (recruiting="Agri") then eh2=7;
            if (recruiting="Feudal") then eh2=8;
            if (recruiting="Temperate") then eh2=9;
            if (recruiting="Ice") then eh2=10;
            if (recruiting="Dead") then eh2=11;
            if (recruiting="Shrine") then eh2=17;
            
            if (custom>1) then draw_sprite_stretched(spr_creation_arrow,0,865,285,32,32);// Left Arrow
            if (scr_hit(865,285,865+32,285+32)) and (mouse_left>=1) and (cooldown<=0) and (custom>1){
                var onceh;onceh=0;cooldown=8000;
                if (recruiting="Dead") and (onceh=0){recruiting="Ice";onceh=1;}
                if (recruiting="Ice") and (onceh=0){recruiting="Temperate";onceh=1;}
                if (recruiting="Temperate") and (onceh=0){recruiting="Feudal";onceh=1;}
                if (recruiting="Feudal") and (onceh=0){recruiting="Shrine";onceh=1;}
                if (recruiting="Shrine") and (onceh=0){recruiting="Agri";onceh=1;}
                if (recruiting="Agri") and (onceh=0){recruiting="Death";onceh=1;}
                if (recruiting="Death") and (onceh=0){recruiting="Hive";onceh=1;}
                if (recruiting="Hive") and (onceh=0){recruiting="Forge";onceh=1;}
                if (recruiting="Forge") and (onceh=0){recruiting="Desert";onceh=1;}
                if (recruiting="Desert") and (onceh=0){recruiting="Lava";onceh=1;}
                if (recruiting="Lava") and (onceh=0){recruiting="Dead";onceh=1;}
            }
            if (custom>1) then draw_sprite_stretched(spr_creation_arrow,1,1055,285,32,32);// Right Arrow
            if (scr_hit(1055,285,1055+32,285+32)) and (mouse_left>=1) and (cooldown<=0) and (custom>1){
                var onceh;onceh=0;cooldown=8000;
                if (recruiting="Dead") and (onceh=0){recruiting="Lava";onceh=1;}
                if (recruiting="Lava") and (onceh=0){recruiting="Desert";onceh=1;}
                if (recruiting="Desert") and (onceh=0){recruiting="Forge";onceh=1;}
                if (recruiting="Forge") and (onceh=0){recruiting="Hive";onceh=1;}
                if (recruiting="Hive") and (onceh=0){recruiting="Death";onceh=1;}
                if (recruiting="Death") and (onceh=0){recruiting="Agri";onceh=1;}
                if (recruiting="Agri") and (onceh=0){recruiting="Shrine";onceh=1;}
                if (recruiting="Shrine") and (onceh=0){recruiting="Feudal";onceh=1;}
                if (recruiting="Feudal") and (onceh=0){recruiting="Temperate";onceh=1;}
                if (recruiting="Temperate") and (onceh=0){recruiting="Ice";onceh=1;}
                if (recruiting="Ice") and (onceh=0){recruiting="Dead";onceh=1;}
            }
            
            // draw_sprite(spr_planet_splash,eh2,580+333,244);
            scr_image("ui/planet",eh2,580+333,244,128,128);
            
            draw_text_transformed(644+333,378,string_hash_to_newline(string(recruiting)),0.5,0.5,0);
            // draw_text_transformed(644+333,398,string(recruiting_name),0.5,0.5,0);
            
            if (fleet_type=1) and (homeworld_name=recruiting_name) then name_bad=1;
            
            if (name_bad=1) then draw_set_color(c_red);
            if (text_selected!="recruiting_name") or (custom<2) then draw_text_transformed(644+333,398,string_hash_to_newline(string(recruiting_name)),0.5,0.5,0);
            if (custom>1){
                if (text_selected="recruiting_name") and (text_bar>30) then draw_text_transformed(644+333,398,string_hash_to_newline(string(recruiting_name)),0.5,0.5,0);
                if (text_selected="recruiting_name") and (text_bar<=30) then draw_text_transformed(644+333,398,string_hash_to_newline(string(recruiting_name)+"|"),0.5,0.5,0);
                if (scr_text_hit(644+333,398,true,recruiting_name)){
                    obj_cursor.image_index=2;
                    if (cooldown<=0) and (mouse_left>=1){text_selected="recruiting_name";cooldown=8000;keyboard_string=recruiting_name;}
                }
                if (text_selected="recruiting_name") then recruiting_name=keyboard_string;
                draw_set_alpha(0.75);draw_rectangle(525+333,398,760+333,418,1);draw_set_alpha(1);

                var _refresh_rec_name_btn =[1103, 398, 1103+20, 398+20];
                draw_unit_buttons(_refresh_rec_name_btn,"?", [1,1], 38144,,fnt_40k_14b);
                if(point_and_click(_refresh_rec_name_btn)){
                    var _new_rec_name = global.name_generator.generate_star_name();
                    show_debug_message($"regen name of recruiting_name from {recruiting_name} to {_new_rec_name}");
                    recruiting_name = _new_rec_name;
                }
            }
        }
    }
    
    if (recruiting_exists==0 && homeworld_exists==1){
        // draw_sprite(spr_planet_splash,eh,580+333,244);
        scr_image("ui/planet",eh,580+333,244,128,128);
        
        draw_set_alpha(0.5);
        draw_text_transformed(644+333,378,string_hash_to_newline(string(homeworld)),0.5,0.5,0);
        draw_text_transformed(644+333,398,string_hash_to_newline(string(homeworld_name)),0.5,0.5,0);
        draw_set_alpha(1);
    }
    
    
    if (scr_hit(575,216,710,242)){
        if (fleet_type!=eFLEET_TYPES.HOMEWORLD){tooltip="Battle Barge";tooltip2="The name of your Flagship Battle Barge.";}
        if (fleet_type==eFLEET_TYPES.HOMEWORLD){tooltip="Homeworld";tooltip2="The world that your Chapter's Fortress Monastery is located upon.  More civilized worlds are more easily defensible but the citizens may pose a risk or be a nuisance.";}
    }
    if (scr_hit(895,216,1075,242)){
        tooltip="Recruiting World";tooltip2="The world that your Chapter selects recruits from.  More harsh worlds provide recruits with more grit and warrior mentality.  If you are a homeworld-based Chapter, you may uncheck 'Recruiting World' to recruit from your homeworld instead.";
    }
    
    draw_line(445,455,1125,455);
    draw_line(445,456,1125,456);
    draw_line(445,457,1125,457);
    
    // homeworld_rule=0;
    // aspirant_trial=eTrials.BLOODDUEL;
    
    draw_set_halign(fa_left);
    
    if (fleet_type == eFLEET_TYPES.HOMEWORLD){
        if (custom<2) then draw_set_alpha(0.5);
        draw_text_transformed(445,480,"Homeworld Rule",0.6,0.6,0);
        draw_text_transformed(485,512,"Planetary Governer",0.5,0.5,0);
        draw_text_transformed(485,544,"Passive Supervision",0.5,0.5,0);
        draw_text_transformed(485,576,"Personal Rule",0.5,0.5,0);
        
        yar=homeworld_rule==1;
        draw_sprite(spr_creation_check,yar,445,512);
        if (scr_hit(445,512,445+32,512+32)) and (cooldown<=0) and (mouse_left>=1) and (custom>1) and (homeworld_rule!=1){cooldown=8000;homeworld_rule=1;}
        if (scr_hit(445,512,670,512+32)){
            tooltip="Planetary Governer";
            tooltip2="Your Chapter's homeworld is ruled by a single Planetary Governer, who does with the planet mostly as they see fit.  While heavily influenced by your Astartes the planet is sovereign.";
        }
        
        yar=homeworld_rule==2;
        draw_sprite(spr_creation_check,yar,445,544);
        if (scr_hit(445,544,445+32,544+32)) and (cooldown<=0) and (mouse_left>=1) and (custom>1) and (homeworld_rule!=2){cooldown=8000;homeworld_rule=2;}
        if (scr_hit(445,544,620,544+32)){
            tooltip="Passive Supervision";
            tooltip2="Instead of a Planetary Governer the planet is broken up into many countries or clans.  The people are less united but happier, and see your illusive Astartes as semi-divine beings.";
        }
        
        yar=homeworld_rule==3;
        draw_sprite(spr_creation_check,yar,445,576);
        if (point_and_click([445,576,445+32,576+32])) and (custom>1) and (homeworld_rule!=3){cooldown=8000;homeworld_rule=3;}
        if (scr_hit(445,576,670,576+32)){
            tooltip="Personal Rule";
            tooltip2="You personally take the rule of the Planetary Governer, ruling over your homeworld with an iron fist.  Your every word and directive, be they good or bad, are absolute law.";
        }
    }
    
    var trial_data = scr_trial_data();
    var current_trial = trial_data[aspirant_trial];
    draw_text_transformed(80,180,"Aspirant Trial",0.6,0.6,0);
    draw_text_transformed(110,210,current_trial.name,0.5,0.5,0);
    
    var asp_info;
    asp_info = scr_compile_trial_bonus_string(current_trial);

    draw_text_ext_transformed(100,244,asp_info,64,950,0.5,0.5,0);
     
    if (scr_hit(50,480,950,510)){
        tooltip="Aspirant Trial";
        tooltip2="A special challenge is needed for Aspirants to be judged worthy of becoming Astartes.  After completing the Trial they then become a Neophyte, beginning implantation and training (This can be changed once in game but the chosen trial here will effect the spawn characteristics of your starting marines).";
    }
    
    if (custom>1){
        draw_sprite_stretched(spr_creation_arrow,0,00,200,32,32);
        if (point_and_click([00,200,00+32,200+32]) and (cooldown<=0)){
            var onceh=0;cooldown=8000;
            aspirant_trial++;
            if (aspirant_trial>=array_length(trial_data)){
                aspirant_trial=0
            }
        }
        draw_sprite_stretched(spr_creation_arrow,1,38,200,32,32);

        if (point_and_click([38,200,38+32,200+32]) and (mouse_left>=1) and (cooldown<=0)){
            var onceh=0;cooldown=8000;
            aspirant_trial--;
            if (aspirant_trial<0){
                aspirant_trial = array_length(trial_data)-1;
            }
        }
    }
    
    
    draw_line(445,640,1125,640);
    draw_line(445,641,1125,641);
    draw_line(445,642,1125,642);
    
    if (race[100,17]!=0){
        draw_text_transformed(445,665,string_hash_to_newline("Psychic Discipline"),0.6,0.6,0);
        if (scr_hit(445,665,620,690)){tooltip="Psychic Discipline";tooltip2="The Psychic Discipline that your psykers will use by default.";}
        
        var fug,fug2;fug=string_delete(discipline,2,string_length(discipline));
        fug2=string_delete(discipline,1,1);draw_text_transformed(513,697,string_hash_to_newline(string_upper(fug)+string(fug2)),0.5,0.5,0);
        
        var psy_info;psy_info="";
        if (discipline="default") then psy_info="-Psychic Blasts and Barriers";
        if (discipline="biomancy") then psy_info="-Manipulates Biology to Buff or Heal";
        if (discipline="pyromancy") then psy_info="-Unleashes Blasts and Walls of Flame";
        if (discipline="telekinesis") then psy_info="-Manipulates Gravity to Throw or Shield";
        if (discipline="rune Magick") then psy_info="-Summons Deadly Elements and Feral Spirits";
        draw_text_transformed(533,729,string_hash_to_newline(string(psy_info)),0.5,0.5,0);
        
        if (custom<2) then draw_set_alpha(0.5);
        if (custom=2) then draw_sprite_stretched(spr_creation_arrow,0,437,688,32,32);
        if (custom=2) then draw_sprite_stretched(spr_creation_arrow,1,475,688,32,32);
        draw_set_alpha(1);
        
        if (scr_hit(437,688,437+32,688+32)) and (mouse_left>=1) and (cooldown<=0) and (custom>1){
            var onceh;onceh=0;cooldown=8000;
            if (discipline="default") and (onceh=0){discipline="rune Magick";onceh=1;}
            if (discipline="rune Magick") and (onceh=0){discipline="telekinesis";onceh=1;}
            if (discipline="telekinesis") and (onceh=0){discipline="pyromancy";onceh=1;}
            if (discipline="pyromancy") and (onceh=0){discipline="biomancy";onceh=1;}
            if (discipline="biomancy") and (onceh=0){discipline="default";onceh=1;}
        }
        if (scr_hit(475,688,475+32,688+32)) and (mouse_left>=1) and (cooldown<=0) and (custom>1){
            var onceh;onceh=0;cooldown=8000;
            if (discipline="default") and (onceh=0){discipline="biomancy";onceh=1;}
            if (discipline="biomancy") and (onceh=0){discipline="pyromancy";onceh=1;}
            if (discipline="pyromancy") and (onceh=0){discipline="telekinesis";onceh=1;}
            if (discipline="telekinesis") and (onceh=0){discipline="rune Magick";onceh=1;}
            if (discipline="rune Magick") and (onceh=0){discipline="default";onceh=1;}
        }
         
    }
}




/* Livery, Roles */


if (slide=4){
   scr_livery_setup();
}

/* Gene Seed Mutations, Disposition */


if (slide=5){
    draw_set_color(38144);
    draw_set_font(fnt_40k_30b);
    draw_set_halign(fa_center);
    draw_set_alpha(1);
    
    tooltip="";tooltip2="";
    obj_cursor.image_index=0;
    
    draw_text(800,80,string_hash_to_newline(string(chapter_name)));


    draw_set_color(38144);draw_set_halign(fa_left);
    draw_text_transformed(580,118,string_hash_to_newline("Successor Chapters: "+string(successors)),0.6,0.6,0);
    draw_set_font(fnt_40k_14b);
    
    draw_rectangle(445, 200, 1125, 202, true);
    
    draw_set_font(fnt_40k_30b);
    draw_text_transformed(503,210,string_hash_to_newline("Gene-Seed Mutations"),0.6,0.6,0);
    if (mutations>mutations_selected) then draw_text_transformed(585,230,$"Select {mutations-mutations_selected} More",0.5,0.5,0);
    
    var x1,y1,spac=34;
    
    if (custom<2) then draw_set_alpha(0.5);
    var mutations_defects = [
        {
            t_tip :"Anemic Preomnor",
            t_tip2: "Your Astartes lack the detoxifying gland called the Preomnor- they are more susceptible to poisons and toxins.",
            data : preomnor,
            mutation_points : 1,
        },
        {
            t_tip :"Disturbing Voice",
            t_tip2: "Your Astartes have a voice like a creaking door or a rumble.  Decreases Imperium and Imperial Guard disposition.",
            data : voice,
            mutation_points : 1,
            disposition:[[eFACTION.Imperium,-8]],
        },
        {
            t_tip :"Doomed",
            t_tip2: "Your Chapter cannot make more Astartes until enough research is generated.  Counts as four mutations.",
            data : doomed,
            mutation_points : 4,
            disposition:[[eFACTION.Imperium,-8],[6,8]],
        },
        {
            t_tip :"Faulty Lyman's Ear",
            t_tip2: "Lacking a working Lyman's ear, all deep-striked Astartes recieve moderate penalties to both attack and defense.",
            data : lyman,
            mutation_points : 1,
        },
        {
            t_tip :"Hyper-Stimulated Omophagea",
            t_tip2: "After every battle the Astartes have a chance to feast upon their fallen enemies, or seldom, their allies.",
            data : omophagea,
            mutation_points : 1,
        },
        {
            t_tip :"Hyperactive Ossmodula",
            t_tip2: "Instead of wound tissue bone is generated; Apothecaries must spend twice the normal time healing your Astartes.",
            data : ossmodula,
            mutation_points : 1,
        }, 
        {
            t_tip :"Lost Zygote",
            t_tip2: "One of the Zygotes is faulty or missing.  The Astartes only have one each and generate half the normal Gene-Seed.",
            data : zygote,
            mutation_points : 2,
        },
        {
            t_tip :"Inactive Sus-an Membrane",
            t_tip2: "Your Astartes do not have a Sus-an Membrane; they cannot enter suspended animation and recieve more casualties as a result.",
            data : membrane,
            mutation_points : 1,
        },
        {
            t_tip :"Missing Betchers Gland",
            t_tip2: "Your Astartes cannot spit acid, and as a result, have slightly less attack in melee combat.",
            data : betchers,
            mutation_points : 1,
        }, 
        {
            t_tip :"Mutated Catalepsean Node",
            t_tip2: "Your Astartes have reduced awareness when tired. Slightly less attack in ranged and melee combat.",
            data : catalepsean,
            mutation_points : 1,
        }, 
        {
            t_tip :"Oolitic Secretions",
            t_tip2: "Either by secretions or radiation, your Astartes have an unusual or strange skin color.  Decreases disposition.",
            data : secretions,
            mutation_points : 1,
            disposition:[[eFACTION.Imperium,-8]],
        },
        {
            t_tip :"Oversensitive Occulobe",
            t_tip2: "Your Astartes are no longer immune to stun grenades, bright lights, and have a massive penalty during morning battles.",
            data : occulobe,
            mutation_points : 1,
            disposition:[[eFACTION.Imperium,-8]],
        },
        {
            t_tip :"Rampant Mucranoid",
            t_tip2: "Your Astartes' Mucranoid cannot be turned off; the slime lowers most dispositions and occasionally damages their armour.",
            data : mucranoid,
            mutation_points : 1,
            disposition:[[1,-4],[eFACTION.Imperium,-8],[3,-4],[4,-4],[5,-4],[6,-4]],
        },                                                                          
    ]
    x1=450;
    y1=260;
    for (var i=0;i<array_length(mutations_defects);i++){
        mutation_data = mutations_defects[i];
        draw_sprite(spr_creation_check,mutation_data.data,x1,y1);
        if (point_and_click([x1,y1,x1+32,y1+32]) && allow_colour_click){
            cooldown=8000;
            var onceh=0;
            if (mutation_data.data){
                mutation_data.data=0;
                mutations_selected-=mutation_data.mutation_points;
                if (struct_exists(mutation_data, "disposition")){
                   for (var s=0;s<array_length(mutation_data.disposition);s++){
                        disposition[mutation_data.disposition[s][0]] -= mutation_data.disposition[s][1];
                   }
                }                
            }
            else if (!mutation_data.data) and (mutations>mutations_selected){
                mutation_data.data=1;
                mutations_selected+=mutation_data.mutation_points;
                if (struct_exists(mutation_data, "disposition")){
                   for (var s=0;s<array_length(mutation_data.disposition);s++){
                        disposition[mutation_data.disposition[s][0]] += mutation_data.disposition[s][1];
                   }
                }
            }
        }
        draw_text_transformed(x1+30,y1+4,mutation_data.t_tip,0.4,0.4,0);
        if (scr_hit(x1,y1,x1+250,y1+20)){
            tooltip=mutation_data.t_tip;
            tooltip2=mutation_data.t_tip2;
        }    
        y1+=spac
        if (i==6){
            x1=750;
            y1=260;
        }
    }
    preomnor=mutations_defects[0].data;
    voice=mutations_defects[1].data;
    doomed=mutations_defects[2].data;
    lyman=mutations_defects[3].data;
    omophagea=mutations_defects[4].data;
    ossmodula=mutations_defects[5].data;
    zygote=mutations_defects[6].data;
    membrane=mutations_defects[7].data;
    betchers=mutations_defects[8].data;
    catalepsean=mutations_defects[9].data;
    secretions = mutations_defects[10].data;
    occulobe=mutations_defects[11].data;
    mucranoid=mutations_defects[12].data;

    draw_set_alpha(1);
    
    draw_line(445,505,1125,505);
    draw_line(445,506,1125,505);
    draw_line(445,507,1125,507);
    
    draw_set_font(fnt_40k_30b);
    draw_text_transformed(444,515,string_hash_to_newline("Starting Disposition"),0.6,0.6,0);
    
    draw_set_font(fnt_40k_14b);
    draw_set_halign(fa_right);
    
    draw_text(650,550,string_hash_to_newline("Imperium ("+string(disposition[2])+")"));
    draw_text(650,575,string_hash_to_newline("Adeptus Mechanicus ("+string(disposition[3])+")"));
    draw_text(650,600,string_hash_to_newline("Ecclesiarchy ("+string(disposition[5])+")"));
    draw_text(650,625,string_hash_to_newline("Inquisition ("+string(disposition[4])+")"));
    if (founding!=0) then draw_text(650,650,string_hash_to_newline("Progenitor ("+string(disposition[1])+")"));
    draw_text(650,675,"Adeptus Astartes ("+string(disposition[6])+")");
    
    draw_rectangle(655,552,1150,567,1);
    draw_rectangle(655,552+25,1150,567+25,1);
    draw_rectangle(655,552+50,1150,567+50,1);
    draw_rectangle(655,552+75,1150,567+75,1);
    if (founding!=0) then draw_rectangle(655,552+100,1150,567+100,1);
    draw_rectangle(655,552+125,1150,567+125,1);
    if (disposition[2]>0) then draw_rectangle(655,552,655+(disposition[2]*4.95),567,0);
    if (disposition[3]>0) then draw_rectangle(655,552+25,655+(disposition[3]*4.95),567+25,0);
    if (disposition[5]>0) then draw_rectangle(655,552+50,655+(disposition[5]*4.95),567+50,0);
    if (disposition[4]>0) then draw_rectangle(655,552+75,655+(disposition[4]*4.95),567+75,0);
    if (disposition[1]>0) and (founding!=0) then draw_rectangle(655,552+100,655+(disposition[1]*4.95),567+100,0);
    if (disposition[6]>0) then draw_rectangle(655,552+125,655+(disposition[6]*4.95),567+125,0);
    
    
}

/* Chapter Master */

if (slide=6){
    draw_set_color(38144);
    draw_set_font(fnt_40k_30b);
    draw_set_halign(fa_center);
    draw_set_alpha(1);var yar;yar=0;
    
    tooltip="";tooltip2="";
    obj_cursor.image_index=0;
	
    
    
    draw_set_color(38144);draw_set_halign(fa_left);
    draw_text_transformed(580,100,string_hash_to_newline("Chapter Master Name: "),0.9,0.9,0);draw_set_font(fnt_40k_14b);
    
	
    if (text_selected!="cm") or (custom=0) then draw_text_ext(580,144,string_hash_to_newline(string(chapter_master_name)),-1,580);
    if (custom>0) and (restarted=0){
        if (text_selected="cm") and (text_bar>30) then draw_text(580,144,string_hash_to_newline(string(chapter_master_name)));
        if (text_selected="cm") and (text_bar<=30) then draw_text(580,144,string_hash_to_newline(string(chapter_master_name)+"|"));
        var str_width,hei;str_width=max(400,string_width(string_hash_to_newline(chapter_master_name)));hei=string_height(string_hash_to_newline(chapter_master_name));
        if (scr_hit(580-2,144-2,582+str_width,146+hei)){obj_cursor.image_index=2;
            if (mouse_left>=1) and (cooldown<=0) and (!instance_exists(obj_creation_popup)){text_selected="cm";cooldown=8000;keyboard_string=chapter_master_name;}
        }
        if (text_selected="cm") then chapter_master_name=keyboard_string;
        draw_rectangle(580-2,144-2,582+400,146+hei,1);

        var _refresh_cm_name_btn =[993, 142, 997+hei, 146+hei];
        draw_unit_buttons(_refresh_cm_name_btn,"?", [1,1], 38144,,fnt_40k_14b);
        if(point_and_click(_refresh_cm_name_btn)){
            var _new_cm_name = global.name_generator.generate_space_marine_name();
            show_debug_message($"regen name of chapter_master_name from {chapter_master_name} to {_new_cm_name}");
            chapter_master_name = _new_cm_name;
        }
    }
    
    draw_line(445,200,1125,200);
    draw_line(445,201,1125,201);
    draw_line(445,202,1125,202);
    
    draw_set_font(fnt_40k_30b);
    draw_text_transformed(444,215,string_hash_to_newline("Select Two Weapons"),0.6,0.6,0);
    draw_text_transformed(444,240,string_hash_to_newline("Melee"),0.6,0.6,0);
    draw_text_transformed(800,240,string_hash_to_newline("Ranged"),0.6,0.6,0);
    
    
    var x6,y6,spac;
    var melee_choice_order = 0;
    var melee_choice_weapon = "";
    x6=444;y6=265;spac=25;
    if (custom=0) or (restarted>0) then draw_set_alpha(0.5);
    
    repeat(8){
        melee_choice_order+=1;
        if (melee_choice_order=1) then melee_choice_weapon="Twin Power Fists";
		if (melee_choice_order=2) then melee_choice_weapon="Twin Lightning Claws";
        if (melee_choice_order=3) then melee_choice_weapon="Relic Blade";
        if (melee_choice_order=4) then melee_choice_weapon="Thunder Hammer";
        if (melee_choice_order=5) then melee_choice_weapon="Power Sword";
        if (melee_choice_order=6) then melee_choice_weapon="Power Axe";
        if (melee_choice_order=7) then melee_choice_weapon="Eviscerator";
        if (melee_choice_order=8) then melee_choice_weapon="Force Staff";
        
        yar=0;if (chapter_master_melee=melee_choice_order) then yar=1;draw_sprite(spr_creation_check,yar,x6,y6);yar=0;
        if (scr_hit(x6,y6,x6+32,y6+32)) and (cooldown<=0) and (mouse_left>=1) and (custom>0) and (restarted=0) and (!instance_exists(obj_creation_popup)){
            cooldown=8000;var onceh;onceh=0;
            if (chapter_master_melee=melee_choice_order) and (onceh=0){chapter_master_melee=0;onceh=1;}
            if (chapter_master_melee!=melee_choice_order) and (onceh=0){chapter_master_melee=melee_choice_order;onceh=1;}
        }
        draw_text_transformed(x6+30,y6+4,string_hash_to_newline(melee_choice_weapon),0.4,0.4,0);
        y6+=spac;
    }
    
    x6=800;y6=265;
    var ranged_choice_order = 0;
    var ranged_choice_weapon = "";
    var ranged_options = ["","Boltstorm Gauntlet","Infernus Pistol","Plasma Pistol","Plasma Gun","Master Crafted Heavy Bolter","Master Crafted Meltagun","Storm Shield",""];
    if (array_contains([1, 2, 7], chapter_master_melee)){
        draw_set_alpha(0.5);
        chapter_master_ranged = 1;
    }
    repeat(7){
        ranged_choice_order += 1;
        yar=0;
        if (chapter_master_ranged=ranged_choice_order) then yar=1;
        draw_sprite(spr_creation_check,yar,x6,y6);
        yar=0;
        if point_and_click([x6,y6,x6+32,y6+32]) and (custom>0) and (restarted=0) and (!instance_exists(obj_creation_popup)) and (!array_contains([1, 2, 7], chapter_master_melee)){
            cooldown=8000;
            var onceh=0;
            if (chapter_master_ranged=ranged_choice_order) {chapter_master_ranged=0;}
            else if (chapter_master_ranged!=ranged_choice_order) {chapter_master_ranged=ranged_choice_order;}
        }
        draw_text_transformed(x6+30,y6+4,ranged_options[ranged_choice_order],0.4,0.4,0);
        y6+=spac;
    }
    
    draw_set_alpha(1);
    
    draw_line(445,490,1125,490);
    draw_line(445,491,1125,491);
    draw_line(445,492,1125,492);
    
    draw_set_font(fnt_40k_30b);
    // draw_text_transformed(444,505,"Select Speciality",0.6,0.6,0);
    draw_set_halign(fa_center);
    
    var psy_intolerance = array_contains(dis, "Psyker Intolerant");
    if (chapter_master_specialty=3) and ((race[100,17]=0) or (psy_intolerance)) then chapter_master_speciality=choose(1,2);
    x6=474;y6=500;h=0;it="";
    var leader_types = [
        ["",""],
        ["Born Leader","You always know the right words to inspire your men or strike doubt in the hearts of the enemy.  Increases Disposition and Grants a +10% Requisition Income Bonus."],
        ["Champion","Even before your rise to Chapter Master you were a renowned warrior, nearly without compare.  Increases Chapter Master Experience, Melee Damage, and Ranged Damage."],
        ["Psyker","The impossible is nothing to you; despite being a Psyker you have slowly risen to lead a Chapter.  Chapter Master gains every Power within the chosen Discipline."],
    ]
    repeat(3){h+=1;
        var cur_leader_type = leader_types[h];
        draw_set_alpha(1);
        var nope = (h=3) and ((race[100,17]=0) or (psy_intolerance));
        if (nope) then draw_set_alpha(0.5);
        if (custom<2) or (restarted>0) then draw_set_alpha(0.5);
        
        // draw_sprite(spr_cm_specialty,h-1,x6,y6);
        scr_image("commander",h-1,x6,y6,162,208);
        
        draw_text_transformed(x6+81,y6+214,cur_leader_type[0],0.5,0.5,0);

        draw_sprite(spr_creation_check,chapter_master_specialty==h,x6,y6+214);
        
        
        if (scr_hit(x6,y6+214,x6+32,y6+32+214)) and (cooldown<=0) and (mouse_left>=1) and (custom>1) and (restarted=0) and (nope=0){
            cooldown=8000;
            var onceh=0;
            if (chapter_master_specialty!=h) and (onceh=0){chapter_master_specialty=h;onceh=1;}
        }
        if (scr_hit(x6,y6+214,x6+162,y6+234)) and (nope=0){
            tooltip = cur_leader_type[0];
            tooltip2= cur_leader_type[1]
        }
        
        x6+=240;draw_set_alpha(1);
		
    }
    
    
    //adds "Save Chapter" button if custom chapter in a save slot

    if(custom>0 && global.chapter_id != eCHAPTERS.UNKNOWN){
        draw_rectangle(1000,135,1180,170,1)
        draw_text_transformed(1090,140,string("Save Chapter"),0.6,0.6,0);draw_set_font(fnt_40k_14b);
	    if (scr_hit(1000,135,1180,170)) {
            tooltip= "Do you want to save your chapter?"
            tooltip2="Click to save your chapter";
	        if (mouse_left>=1){
                scr_save_chapter(global.chapter_id);

                tooltip= "Do you want to save your chapter?"
                tooltip2="Chapter Saved!";
            }
		}
	}
	
    
}

/* */


// 850,860

var xx,yy;
xx=375;yy=10;


if (change_slide>0){
    draw_set_color(c_black);
    if (change_slide=3){
        if (slate5<=0) then slate5=1;
        if (slate5>=5) and (slate6=0) then slate6=1;
    }
    if (change_slide<=30) then draw_set_alpha(change_slide/30);
    if (change_slide>40) then draw_set_alpha(2.33-(change_slide/30));
    draw_rectangle(430,66,702,750,0);
    draw_rectangle(703,80,1171,750,0);
    draw_rectangle(518,750,1075,820,0);
}


draw_set_color(5998382);
if (slate5>0){
    if (slate5<=30) then draw_set_alpha(slate5/30);
    if (slate5>30) then draw_set_alpha(1-((slate5-30)/30));
    draw_line(xx+30,yy+70+(slate5*12),xx+790,yy+70+(slate5*12));
}
if (slate6>0){
    if (slate6<=30) then draw_set_alpha(slate6/30);
    if (slate6>30) then draw_set_alpha(1-((slate6-30)/30));
    draw_line(xx+30,yy+70+(slate6*12),xx+790,yy+70+(slate6*12));
}

if (fade_in>0){
    draw_set_alpha(fade_in/50);
    draw_set_color(0);
    draw_rectangle(0,0,room_width,room_height,0);
}
draw_set_alpha(1);
// draw_set_color(c_red);
// draw_text(mouse_x+20,mouse_y+20,string(change_slide));




if (slide=1){
    draw_set_alpha(slate4/30);
    if (slide=1) then draw_sprite(spr_creation_arrow,2,607,761);
    if (slide!=1) then draw_sprite(spr_creation_arrow,0,607,761);
    draw_sprite(spr_creation_arrow,3,927,761);
    
    var q,x3,y3;q=1;x3=(room_width/2)-65;y3=790;
    draw_set_color(38144);
    repeat(6){
        draw_circle(x3,y3,10,1);
        draw_circle(x3,y3,9.5,1);
        draw_circle(x3,y3,9,1);
        
        if (slide=q) then draw_circle(x3,y3,8.5,0);
        if (slide!=q) then draw_circle(x3,y3,8.5,1);
        x3+=25;q+=1;
    }
}



if (slide>=2) or (goto_slide>=2){
    draw_set_alpha(1);
    draw_sprite(spr_creation_arrow,0,607,761);
    draw_sprite(spr_creation_arrow,1,927,761);
    if (slide=1) then draw_sprite(spr_creation_arrow,2,607,761);
    
    // skip to end >> button
    if (slide>=2) and (slide<6) and (custom!=2){
        draw_set_alpha(0.8);
        if (popup="") and ((change_slide>=70) or (change_slide<=0)) and (scr_hit(927+64+12,761+12,927+128-12,761+64-12)) then draw_set_alpha(1);
        draw_sprite(spr_creation_arrow,4,927+64,761);
        if (popup="") and ((change_slide>=70) or (change_slide<=0)) and (cooldown<=0) and (mouse_left>=1){
            if (scr_hit(927+64+12,761+12,927+128-12,761+64-12)){
                scr_creation(2);
                scr_creation(3.5);
                scr_creation(4);
                scr_creation(5);
                scr_creation(6);
            }
        }
    }
    draw_set_alpha(1);
    
    
    var q=1,x3=(room_width/2)-65,y3=790;
    draw_set_color(38144);
    repeat(6){
        draw_circle(x3,y3,10,1);
        draw_circle(x3,y3,9.5,1);
        draw_circle(x3,y3,9,1);
        
        if (slide_show=q) then draw_circle(x3,y3,8.5,0);
        if (slide_show!=q) then draw_circle(x3,y3,8.5,1);
        x3+=25;
        q+=1;
    }
    
    
    
    if (popup="") and ((change_slide>=70) or (change_slide<=0)) and (cooldown<=0){
        if (mouse_x>925) and (mouse_y>756) and (mouse_x<997) and (mouse_y<824) and (mouse_left>=1) and (!instance_exists(obj_creation_popup)){// Next slide
            if (slide>=2 && slide<=6) then scr_creation(slide);            
        }
        
        
        if (point_and_click([604,756,675,824])) and (cooldown<=0) and (!instance_exists(obj_creation_popup)){// Previous slide
            cooldown=8000;
            change_slide=1;
            goto_slide=slide-1;
            popup="";
            if (goto_slide=1){
                highlight=0;highlighting=0;old_highlight=0;
            }
        }
    }
    
}




if (tooltip!="" && tooltip2!="" && change_slide<=0){
    draw_set_alpha(1);
    draw_set_color(0);
    draw_set_halign(fa_left);
    draw_set_font(fnt_40k_14b);
    var _width1 = string_width_ext(string_hash_to_newline(tooltip),-1,500);
    draw_set_font(fnt_40k_14);
    var _width2 = string_width_ext(string_hash_to_newline(tooltip2),-1,500);
    var _height = string_height_ext(string_hash_to_newline(tooltip2),-1,500);
   
    draw_rectangle(mouse_x+18,mouse_y+20,mouse_x+max(_width1, _width2)+24,mouse_y+44+_height,0);
    draw_set_color(38144);
    draw_rectangle(mouse_x+18,mouse_y+20,mouse_x+max(_width1, _width2)+24,mouse_y+44+_height,1);
    draw_set_font(fnt_40k_14b);
    draw_text(mouse_x+22,mouse_y+22,string_hash_to_newline(string(tooltip)));
    draw_set_font(fnt_40k_14);
    draw_text_ext(mouse_x+22,mouse_y+42,string_hash_to_newline(string(tooltip2)),-1,500);
}


/* */
/*  */
