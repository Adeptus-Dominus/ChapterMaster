// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

enum eCREATIONSLIDES{
	CHAPTERSELECT=1,
	CHAPTERTRAITS=2,
	CHAPTERHOME = 3,
	CHAPTERLIVERY = 4,
	CHAPTERGENE = 5,
    CHAPTERMASTER = 6
}
function draw_chapter_select(){
	draw_set_color(38144);
	draw_set_font(fnt_40k_30b);
	draw_set_halign(fa_center);
	draw_text(800, 80, string_hash_to_newline("Select Chapter"));

	draw_set_font(fnt_40k_30b);
	draw_set_halign(fa_left);

	draw_text_transformed(440, founding_y, "Founding Chapters", 0.75, 0.75, 0);
	draw_text_transformed(440, successor_y, "Existing Chapters", 0.75, 0.75, 0);
	draw_text_transformed(440, custom_y, string_hash_to_newline("Custom Chapters"), 0.75, 0.75, 0);
	draw_text_transformed(440, other_y, string_hash_to_newline("Other"), 0.75, 0.75, 0);

	/// @localvar grid object to keep track of where to draw icon boxes
	var grid = {
		count: 0,
		x1: icon_grid_left_edge,
		y1: founding_y + icon_gap_y,
		w: icon_width,
		h: icon_height,
		x2: 0,
		y2: 0,
		left_edge: icon_grid_left_edge,
		right_edge: icon_grid_right_edge(),
		row_gap: icon_row_gap,
		section_gap: icon_gap_y,
		col_gap: icon_gap_x,
		/// Updates coords to draw a new icon, creating new rows where needed
		new_cell: function() {
			if (count > 0) {
				x1 = x1 + col_gap;
			} else {
				x2 = x1 + w;
				y2 = y1 + h;
			}
			if (x1 > right_edge) {
				x1 = left_edge;
				y1 = y1 + row_gap;
			}
			x2 = x1 + w;
			y2 = y1 + h;
			count += 1;
		},
		/// given a new y coord for a section heading resets cell drawing to start a new grid
		new_section: function(new_y) {
			count = 0;
			x1 = left_edge;
			y1 = new_y + section_gap;
			x2 = x1 + w;
			y2 = y1 + h;
		},
		hover: function() {
			return scr_hit(x1, y1, x2, y2);
		},
		clicked: function() {
			return point_and_click([x1, y1, x2, y2]);
		},
	};

	/** * Founding Chapters */
	var i, new_hover, tool;
	i = 1;
	new_hover = highlight;
	tool = 0;
	for (var c = 0; c < array_length(founding_chapters); c++) {
		var chap = founding_chapters[c];
		i = chap.id;

		grid.new_cell();

		draw_sprite(spr_creation_icon, 0, grid.x1, grid.y1);
		scr_image("creation/chapters/icons", chap.icon, grid.x1, grid.y1, grid.w, grid.h);

		// Hover
		if (grid.hover() && slate4 >= 30) {
			if ((old_highlight != highlight) && (highlight != i) && (goto_slide != 2)) {
				old_highlight = highlight;
				highlighting = 1;
			}
			if (goto_slide != 2) {
				highlight = i;
				tool = 1;
			}
			// Highlight white on hover
			draw_rectangle_color_simple(grid.x1, grid.y1, grid.x2, grid.y2, 0, c_white, 0.1);
			// Click
			if (grid.clicked()) {
				cooldown = 8000;
				chapter_name = chap.name;
				if (!chap.disabled) {
					if (scr_chapter_new(chapter_name)) {
						global.chapter_icon_sprite = obj_img.image_cache[$ "creation/chapters/icons"][chap.icon];
						global.chapter_icon_frame = 0;
						global.chapter_icon_path = $"creation/chapters/icons";
						global.chapter_icon_filename = chap.icon;

						icon = i;
						custom = 0;
						change_slide = 1;
						goto_slide = 2;
						chapter_string = chapter_name;
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

	new_hover = highlight;
	for (var c = 0; c < array_length(successor_chapters); c++) {
		var chap = successor_chapters[c];
		i = chap.id;

		grid.new_cell();

		draw_sprite(spr_creation_icon, 0, grid.x1, grid.y1);
		scr_image("creation/chapters/icons", chap.icon, grid.x1, grid.y1, grid.w, grid.h);

		// Hover
		if (grid.hover() && slate4 >= 30) {
			if ((old_highlight != highlight) && (highlight != i) && (goto_slide != 2)) {
				old_highlight = highlight;
				highlighting = 1;
			}
			if (goto_slide != 2) {
				highlight = i;
				tool = 1;
			}
			// Highlight on hover
			draw_rectangle_color_simple(grid.x1, grid.y1, grid.x2, grid.y2, 0, c_white, 0.1);
			//Click
			if (grid.clicked()) {
				cooldown = 8000;
				chapter_name = chap.name;
				if (!chap.disabled) {
					if (scr_chapter_new(chapter_name)) {
						global.chapter_icon_sprite = obj_img.image_cache[$ "creation/chapters/icons"][chap.icon];
						global.chapter_icon_frame = 0;
						global.chapter_icon_path = $"creation/chapters/icons";
						global.chapter_icon_filename = chap.icon;

						icon = chap.icon;
						custom = 0;
						change_slide = 1;
						goto_slide = 2;
						chapter_string = chapter_name;
					} else {
						// borked
					}
				}
			}
		}
	}

	/** * Saved Custom Chapters */
	grid.new_section(custom_y);
	new_hover = highlight;
	for (var c = 0; c < array_length(custom_chapters); c++) {
		var chap = custom_chapters[c];
		i = chap.id;

		grid.new_cell();

		draw_sprite(spr_creation_icon, 0, grid.x1, grid.y1);
		if (chap.loaded == false) {
			// should be the icon that says 'custom'
			draw_sprite_stretched(spr_icon_chapters, 31, grid.x1, grid.y1, grid.w, grid.h);
		} else {
			if (chap.icon > global.normal_icons_count) {
				if (string_starts_with(chap.icon_name, "custom")) {
					var cuicon = obj_cuicons.spr_custom_icon[chap.icon - normal_and_builtin];
					draw_sprite_stretched(cuicon, 0, grid.x1, grid.y1, grid.w, grid.h);
				} else {
					draw_sprite_stretched(spr_icon_chapters, chap.icon - global.normal_icons_count, grid.x1, grid.y1, grid.w, grid.h);
				}
			} else {
				scr_image("creation/chapters/icons", chap.icon, grid.x1, grid.y1, grid.w, grid.h);
			}
		}

		// Hover
		if (grid.hover() && slate4 >= 30) {
			if ((old_highlight != highlight) && (highlight != i) && (goto_slide != 2)) {
				old_highlight = highlight;
				highlighting = 1;
			}
			if (goto_slide != 2) {
				highlight = chap.id;
				tool = 1;
			}
			// Highlight white on hover
			draw_rectangle_color_simple(grid.x1, grid.y1, grid.x2, grid.y2, 0, c_white, 0.1);

			//Click
			if (grid.clicked()) {
				if (chap.loaded == true && chap.disabled == false) {
					if (chap.icon > global.normal_icons_count) {
						if (string_starts_with(chap.icon_name, "custom")) {
							var cuicon = obj_cuicons.spr_custom_icon[chap.icon - normal_and_builtin];
							global.chapter_icon_sprite = sprite_duplicate(cuicon);
							global.chapter_icon_frame = 0;
							global.chapter_icon_filename = chap.icon_name;
						} else {
							global.chapter_icon_sprite = spr_icon_chapters;
							global.chapter_icon_frame = chap.icon - global.normal_icons_count;
						}
					} else {
						global.chapter_icon_sprite = obj_img.image_cache[$ "creation/chapters/icons"][chap.icon];
						global.chapter_icon_frame = 0;
						global.chapter_icon_path = $"creation/chapters/icons";
						global.chapter_icon_filename = chap.icon;
					}
					cooldown = 8000;
					chapter_name = chap.name;
					global.chapter_id = chap.id;
					change_slide = 1;
					goto_slide = 2;
					scr_chapter_new(chap.id);
				} else {
					global.chapter_id = chap.id;
					cooldown = 8000;
					change_slide = 1;
					goto_slide = 2;
					custom = 2;
					scr_chapter_random(0);
				}
			}
		}
	}

	/** * Other Chapters */
	grid.new_section(other_y);

	new_hover = highlight;
	for (var c = 0; c < array_length(other_chapters); c++) {
		var chap = other_chapters[c];
		i = chap.id;

		grid.new_cell();
		draw_sprite(spr_creation_icon, 0, grid.x1, grid.y1);
		// draw_sprite_stretched(spr_icon,i,x2,y2,48,48);
		scr_image("creation/chapters/icons", chap.icon, grid.x1, grid.y1, grid.w, grid.h);

		// Hover
		if (grid.hover() && slate4 >= 30) {
			if ((old_highlight != highlight) && (highlight != i) && (goto_slide != 2)) {
				old_highlight = highlight;
				highlighting = 1;
			}
			if (goto_slide != 2) {
				highlight = i;
				tool = 1;
			}
			// Highlight white on hover
			draw_rectangle_color_simple(grid.x1, grid.y1, grid.x2, grid.y2, 0, c_white, 0.1);
			//Click
			if (grid.clicked()) {
				cooldown = 8000;
				chapter_name = chap.name;
				if (!chap.disabled) {
					if (scr_chapter_new(chapter_name)) {
						global.chapter_icon_sprite = obj_img.image_cache[$ "creation/chapters/icons"][chap.icon];
						global.chapter_icon_frame = 0;
						global.chapter_icon_path = $"creation/chapters/icons";
						global.chapter_icon_filename = chap.icon;
						global.chapter_id = chap.id;

						icon = i;
						custom = 0;
						change_slide = 1;
						goto_slide = 2;
						chapter_string = chapter_name;
					} else {
						// borked
					}
				}
			}
		}
	}

	/* Blank Custom + Random*/
	grid.new_cell();

	i = 1001;
	repeat (2) {
		grid.new_cell();

		draw_sprite(spr_creation_icon, 0, grid.x1, grid.y1);
		draw_sprite_stretched(spr_icon_chapters, i - 1001, grid.x1, grid.y1, grid.w, grid.h);

		if (grid.hover() && slate4 >= 30) {
			if ((old_highlight != highlight) && (highlight != i) && (goto_slide != 2)) {
				old_highlight = highlight;
				highlighting = 1;
			}
			if (goto_slide != 2) {
				highlight = i;
				tool = 1;
			}
			draw_rectangle_color_simple(grid.x1, grid.y1, grid.x2, grid.y2, 0, c_white, 0.1);
			if (grid.clicked()) {
				cooldown = 8000;
				icon = 1;
				icon_name = "da";
				change_slide = 1;
				goto_slide = 2;
				if (i == 1001) {
					custom = 2;
					scr_chapter_random(0);
				}
				if (i == 1002) {
					custom = 1;
					scr_chapter_random(1);
				}
			}
		}
		i += 1;
	}

	if ((tool == 1) && (highlighting < 30)) {
		highlighting += 1;
	}
	if ((tool == 0) && (highlighting > 0)) {
		highlighting -= 1;
	}
	// if (new_hover=0) then highlight=0;

	if (((highlight > 0) && (highlighting > 0)) || ((change_slide > 0) && (goto_slide != 1))) {
		draw_set_alpha(min(slate4 / 30, highlighting / 30));
		if (change_slide > 0) {
			draw_set_alpha(1);
		}

		if (highlight == 1001) {
			scr_image("creation/chapters/splash", 97, 0, 68, 374, 713);
		}
		if (highlight == 1002) {
			scr_image("creation/chapters/splash", 98, 0, 68, 374, 713);
		}
		if (highlight <= array_length(all_chapters)) {
			var splash_chapter = all_chapters[highlight];
			//show_debug_message($"highlight {highlight} splash chapter {splash_chapter.id} splash icon {splash_chapter.splash}");
			scr_image("creation/chapters/splash", splash_chapter.splash, 0, 68, 374, 713);
		}

		draw_set_alpha(slate4 / 30);
		draw_set_color(38144);
		draw_rectangle(0, 68, 374, 781, 1);
	}
	draw_set_alpha(slate4 / 30);

	if (instance_exists(obj_cursor)) {
		obj_cursor.image_index = 0;
	}
	if ((tool == 1) && (change_slide <= 0)) {
		if (instance_exists(obj_cursor)) {
			obj_cursor.image_index = 1;
		}

		draw_set_alpha(1);
		draw_set_color(0);
		draw_set_halign(fa_left);

		if (highlight <= array_length(all_chapters)) {
			var chap = all_chapters[highlight];
			tooltip = chap.name;
			if (chap.progenitor != 0 && chap.progenitor < 10) {
				tooltip += "  - Progenitor: " + all_chapters[chap.progenitor].name;
			}
			tooltip2 = chap.tooltip;
		}
		if (highlight == 1001) {
			tooltip = "Custom";
		}
		if (highlight == 1002) {
			tooltip = "Randomize";
		}
		if (highlight == 1001) {
			tooltip2 = "Create your own customized Chapter, deciding the origins, strength, and weaknesses.  Custom Chapters are weaker than Founding Chapters.";
		}
		if (highlight == 1002) {
			tooltip2 = "Randomly generate a Chapter to play.  The origins, strength, and weaknesses are all random.  Random Chapters are normally weaker than Founding Chapters. ";
		}
	}
}


function draw_chapter_trait_select(){
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
        
        if (scr_hit(516,242,674,266)){
        	tooltip="Homeworld";
        	tooltip2="Your chapter has a homeworld that they base on.  Contained upon it is a massive Fortress Monastery, which provides high levels of defense and automated weapons.";
        }
        if (scr_hit(768,242,866,266)){
        	tooltip="Fleet Based";
        	tooltip2="Rather than a homeworld your chapter begins near their recruiting world.  The fleet includes a Battle Barge, which serves as a mobile base, and powerful ship.";
        }
        if (scr_hit(952,242,1084,266)){
        	tooltip="Penitent";
        	tooltip2="As with Fleet Based, but you must crusade and fight until your penitence meter runs out.  Note that recruiting is disabled until then.";
        }// Avoiding fights will result in excomunicatus traitorus.
        
        if (custom<2) then draw_set_alpha(0.5);
        yar=0;
        if (fleet_type=1) then yar=1;
        draw_sprite(spr_creation_check,yar,519,239);yar=0;
        if (scr_hit(519,239,519+32,239+32)) and (cooldown<=0) and (mouse_left>=1) and (custom=2){cooldown=8000;
            if (points+20<=maxpoints) and (fleet_type=3){points+=20;fleet_type=1;}
            if (fleet_type=2){fleet_type=1;}
        }
        draw_text_transformed(551,239,"Homeworld",0.6,0.6,0);
        
        yar=0;
        if (fleet_type=2) then yar=1;
        draw_sprite(spr_creation_check,yar,771,239);yar=0;
        if (scr_hit(771,239,771+32,239+32)) and (cooldown<=0) and (mouse_left>=1) and (custom=2){cooldown=8000;
            if (points+20<=maxpoints) and (fleet_type=3){points+=20;fleet_type=2;}
            if (fleet_type=1){fleet_type=2;}
        }
        draw_text_transformed(804,239,"Fleet Based",0.6,0.6,0);
        
        yar=0;
        if (fleet_type=3) then yar=1;
        draw_sprite(spr_creation_check,yar,958,239);yar=0;
        if (scr_hit(958,239,958+32,239+32)) and (cooldown<=0) and (mouse_left>=1) and (custom=2){if (fleet_type!=3) then points-=20;fleet_type=3;cooldown=8000;}
        draw_text_transformed(990,239,"Penitent",0.6,0.6,0);
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

function draw_chapter_homeworld_select(){
	var yar = 0;
    draw_set_color(38144);
    draw_set_font(fnt_40k_30b);
    draw_set_halign(fa_center);
    
    tooltip="";
    tooltip2="";
    obj_cursor.image_index=0;
    
    draw_text(800,80,chapter_name);
    
    draw_set_color(38144);
    draw_rectangle(445, 200, 1125, 202, 0);

    scr_creation_home_planet_create();
    left_data_slate.inside_method = function(){

        if (!buttons.complex_homeworld.active){
        
            var trial_data = scr_trial_data();
            draw_text_transformed(160,90,"Aspirant Trial",0.6,0.6,0);

            if (custom>1){
                draw_sprite_stretched(spr_creation_arrow,0,40,90,32,32);
                if (point_and_click([40,90,40+32,90+32])){
                    aspirant_trial++;
                    if (aspirant_trial>=array_length(trial_data)){
                        aspirant_trial=0
                    }
                }
                var _right_x = 72 + string_length("Aspirant Trial") + 10;
                draw_sprite_stretched(spr_creation_arrow,1,_right_x,90,32,32);
                if (point_and_click([_right_x,90,_right_x+32,90+32])){
                    aspirant_trial--;
                    if (aspirant_trial<0){
                        aspirant_trial = array_length(trial_data)-1;
                    }
                }
            }

            var current_trial = trial_data[aspirant_trial];

            

            draw_text_transformed(160,110,current_trial.name,0.5,0.5,0);
            
            var asp_info;
            asp_info = scr_compile_trial_bonus_string(current_trial);

            draw_text_ext_transformed(left_data_slate.XX+20,150,asp_info,-1,left_data_slate.width-20,0.4,0.4,0);
             
            if (scr_hit(50,480,950,510)){
                tooltip="Aspirant Trial";
                tooltip2="A special challenge is needed for Aspirants to be judged worthy of becoming Astartes.  After completing the Trial they then become a Neophyte, beginning implantation and training (This can be changed once in game but the chosen trial here will effect the spawn characteristics of your starting marines).";
            }
        } else {
            draw_set_font(fnt_40k_30b);
            var _spawn_radio = buttons.home_spawn_loc_options;
            var _max_width = left_data_slate.width-100;
            _spawn_radio.update({
            	x1 : 70,
            	y1 : 60,
            	max_width : _max_width,
            	allow_changes : custom
            })
            _spawn_radio.draw();

            var _warp_lanes_radio = buttons.home_warp;
            _warp_lanes_radio.update({
            	x1 : 70,
            	y1 : _spawn_radio.y2,
            	max_width : _max_width,
            	allow_changes : custom
            });
            _warp_lanes_radio.draw();

            var _home_planets = buttons.home_planets
            _home_planets.update({
            	x1 : 70,
            	y1 : _warp_lanes_radio.y2,
            	max_width : _max_width,
            	allow_changes : custom
            });  
            _home_planets.draw();          

        }
    }
    left_data_slate.draw(0,5,0.45, 1);
    
    draw_rectangle(445, 640, 1125, 642, 0);

    player_select_powers();
}