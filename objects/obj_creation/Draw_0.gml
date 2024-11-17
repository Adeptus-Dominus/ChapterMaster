

//read
// 850,860


var xx,yy;
xx=375;yy=10;

tooltip="";tooltip2="";
draw_set_alpha(1);
// draw_sprite(spr_creation_slate,0,xx,yy);
scr_image("slate",0,xx,yy,850,860);
draw_set_alpha(1-(slate1/30));
// draw_sprite(spr_creation_slate,1,xx,yy);
scr_image("slate",1,xx,yy,850,860);

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

var allow_colour_click = (cooldown<=0)   and (mouse_left>=1) and (custom>1) and (!instance_exists(obj_creation_popup));

draw_set_alpha(slate4/30);
if (slate4>0){
    if (slide=1){
        draw_set_color(38144);
        draw_set_font(fnt_40k_30b);
        draw_set_halign(fa_center);
        draw_text(800,80,string_hash_to_newline("Select Chapter"));
        
        draw_set_font(fnt_40k_30b);
        draw_set_halign(fa_left);
        draw_text_transformed(440,133,"Founding Chapters",0.75,0.75,0);
        draw_text_transformed(440,363,"Existing Chapters",0.75,0.75,0);
        draw_text_transformed(440,593,string_hash_to_newline("Other"),0.75,0.75,0);
		draw_text_transformed(440,463,string_hash_to_newline("Custom Chapters"),0.75,0.75,0);
        
        var x2,y2,i,new_hover,tool;
        x2=441;y2=167;i=1;new_hover=highlight;tool=0;
        
        repeat(9){
            
            draw_sprite(spr_creation_icon,0,x2,167);
            scr_image("creation",i,x2,167,48,48);
            // draw_sprite_stretched(spr_icon,i,x2,167,48,48);
            
            if (mouse_x>=x2) and (mouse_y>=167) and (mouse_x<x2+48) and (mouse_y<167+48) and (slate4>=30){
                if (old_highlight!=highlight) and (highlight!=i) and (goto_slide!=2){old_highlight=highlight;highlighting=1;}
                if (goto_slide!=2){highlight=i;tool=1;}
                draw_set_alpha(0.1);draw_set_color(c_white);
                draw_rectangle(x2,167,x2+48,167+48,0);
                draw_set_alpha(slate4/30);
                if (mouse_left>=1) and (cooldown<=0) and (change_slide<=0) and (premades){
                    cooldown=8000;chapter=chapter_id[i];scr_chapter_new(chapter);
                    if (chapter!="nopw_nopw"){icon=i;custom=0;change_slide=1;goto_slide=2;chapter_string=chapter;}
                }
            }
            i+=1;x2+=53;
        }
        
        x2=441;y2=397;i=10;new_hover=highlight;
        repeat(7){
        
            draw_sprite(spr_creation_icon,0,x2,397);
            // draw_sprite_stretched(spr_icon,i,x2,397,48,48);
            scr_image("creation",i,x2,397,48,48);
            
            if (mouse_x>=x2) and (mouse_y>=397) and (mouse_x<x2+48) and (mouse_y<397+48) and (slate4>=30){
                if (old_highlight!=highlight) and (highlight!=i) and (goto_slide!=2){old_highlight=highlight;highlighting=1;}
                if (goto_slide!=2){highlight=i;tool=1;}
                draw_set_alpha(0.1);draw_set_color(c_white);
                draw_rectangle(x2,397,x2+48,397+48,0);
                draw_set_alpha(slate4/30);
                if (mouse_left>=1) and (cooldown<=0) and (change_slide<=0) and (premades){
                    cooldown=8000;chapter=chapter_id[i];scr_chapter_new(chapter);
                    if (chapter!="nopw_nopw"){icon=i;custom=0;change_slide=1;goto_slide=2;chapter_string=chapter;}
                }
            }
            i+=1;x2+=53;
        }
        
		x2=441;y2=497;i=21;new_hover=highlight;
		
  repeat(1){
            draw_sprite(spr_creation_icon,0,x2,497);
            // draw_sprite_stretched(spr_icon,i,x2,397,48,48);
			if(file_exists("chaptersave#1.ini")){
			ini_open("chaptersave#1.ini")
			icon21=ini_read_real("Save","icon",1);
			ini_close();
			}
			else{ icon21=1
			}
            scr_image("creation",icon21,x2,497,48,48);
            
            if (mouse_x>=x2) and (mouse_y>=497) and (mouse_x<x2+48) and (mouse_y<497+48) and (slate4>=30){
				
                if (old_highlight!=highlight) and (highlight!=i) and (goto_slide!=2){old_highlight=highlight;highlighting=1;}
                if (goto_slide!=2){highlight=i;tool=1;}
                draw_set_alpha(0.1);draw_set_color(c_white);
                draw_rectangle(x2,497,x2+48,497+48,0);
                draw_set_alpha(slate4/30);
                if (mouse_left>=1) and (cooldown<=0) and (change_slide<=0){
					if(chapter_made=1){
					
					cooldown=8000;chapter = chapter_id[21];
					change_slide=1;goto_slide=2;
					scr_chapter_new(chapter21)};
					
					if (chapter_made = 0 ){
						cooldown=8000;
						change_slide=1;goto_slide=2;
						custom=2;scr_chapter_random(0);}
                   
                }
            }
            i+=1;x2+=53;
  }
		
        x2=441;y2=627;i=17;new_hover=highlight;
        repeat(4){
        
            draw_sprite(spr_creation_icon,0,x2,y2);
            // draw_sprite_stretched(spr_icon,i,x2,y2,48,48);
            scr_image("creation",i,x2,y2,48,48);
            
            if (mouse_x>=x2) and (mouse_y>=y2) and (mouse_x<x2+48) and (mouse_y<y2+48) and (slate4>=30){
                if (old_highlight!=highlight) and (highlight!=i) and (goto_slide!=2){old_highlight=highlight;highlighting=1;}
                if (goto_slide!=2){highlight=i;tool=1;}
                draw_set_alpha(0.1);draw_set_color(c_white);
                draw_rectangle(x2,y2,x2+48,y2+48,0);
                draw_set_alpha(slate4/30);
                if (mouse_left>=1) and (cooldown<=0) and (change_slide<=0) and (premades){
                    cooldown=8000;chapter=chapter_id[i];scr_chapter_new(chapter);
                    if (chapter!="nopw_nopw"){icon=i;custom=0;change_slide=1;goto_slide=2;chapter_string=chapter;}
                }
            }
            i+=1;x2+=53;
        }
        
        x2+=53;i=1001;
        repeat(2){
        
            draw_sprite(spr_creation_icon,0,x2,y2);
            draw_sprite_stretched(spr_icon_chapters,i-1001,x2,y2,48,48);
            
            if (mouse_x>=x2) and (mouse_y>=y2) and (mouse_x<x2+48) and (mouse_y<y2+48) and (slate4>=30){
                if (old_highlight!=highlight) and (highlight!=i) and (goto_slide!=2){old_highlight=highlight;highlighting=1;}
                if (goto_slide!=2){highlight=i;tool=1;}
                draw_set_alpha(0.1);draw_set_color(c_white);
                draw_rectangle(x2,y2,x2+48,y2+48,0);
                draw_set_alpha(slate4/30);
                if (mouse_left>=1) and (cooldown<=0) and (change_slide<=0){
                    cooldown=8000;icon=1;icon_name="da";change_slide=1;goto_slide=2;
                    if (i=1001){custom=2;scr_chapter_random(0);}
                    if (i=1002){custom=1;scr_chapter_random(1);}
                }
            }
            i+=1;x2+=53;
        }
        
        if (tool=1) and (highlighting<30) then highlighting+=1;
        if (tool=0) and (highlighting>0) then highlighting-=1;
        // if (new_hover=0) then highlight=0;
        
        if ((highlight>0) and (highlighting>0)) or ((change_slide>0) and (goto_slide!=1)){
            draw_set_alpha(min(slate4/30,highlighting/30));
            if (change_slide>0) then draw_set_alpha(1);
            
            
            if (highlight<=9) then scr_image("main_splash",highlight-1,0,68,374,713);
            if (highlight>9) and (highlight<=16) and (highlight!=15) then scr_image("existing_splash",highlight-10,0,68,374,713);
            if (highlight=15) then scr_image("other_splash",6,0,68,374,713);
            if (highlight=17) then scr_image("other_splash",0,0,68,374,713);
            if (highlight=18) then scr_image("other_splash",6,0,68,374,713);
            if (highlight=19) then scr_image("other_splash",2,0,68,374,713);
            if (highlight=20) then scr_image("other_splash",6,0,68,374,713);
            
            if (highlight=1001) then scr_image("other_splash",4,0,68,374,713);
            if (highlight=1002) then scr_image("other_splash",5,0,68,374,713);
            
            /*if (highlight<=9) then draw_sprite(spr_creation_founding,highlight-1,0,68);
            if (highlight>9) and (highlight<=16) and (highlight!=15) then draw_sprite(spr_creation_existing,highlight-10,0,68);
            if (highlight=15) then draw_sprite(spr_creation_nosplash,0,0,68);
            if (highlight=17) then draw_sprite(spr_creation_other,0,0,68);
            if (highlight=18) then draw_sprite(spr_creation_nosplash,0,0,68);
            if (highlight=19) then draw_sprite(spr_creation_other,2,0,68);
            if (highlight=20) then draw_sprite(spr_creation_nosplash,0,0,68);
            
            if (highlight=1001) then draw_sprite(spr_creation_other,4,0,68);
            if (highlight=1002) then draw_sprite(spr_creation_other,5,0,68);*/
            
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
            
            if (highlight<=25){
                tooltip=chapter_id[highlight];
                tooltip2=chapter_tooltip[highlight];
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
        if (icon<=9) then draw_sprite(spr_creation_founding,icon-1,0,68);
        if (icon>9) and (icon<=16) and (icon!=15) then draw_sprite(spr_creation_existing,icon-10,0,68);
        if (icon=15) then draw_sprite(spr_creation_nosplash,0,0,68);
        if (icon=17) then draw_sprite(spr_creation_other,0,0,68);
        if (icon=18) then draw_sprite(spr_creation_nosplash,0,0,68);
        if (icon=19) then draw_sprite(spr_creation_other,2,0,68);
        if (icon=20) then draw_sprite(spr_creation_nosplash,0,0,68);
        
        if (custom=2) then draw_sprite(spr_creation_other,4,0,68);
        if (custom=1) then draw_sprite(spr_creation_other,5,0,68);
        
        draw_set_color(38144);
        draw_rectangle(0,68,374,781,1);
    }
    
    draw_set_color(0);
    // draw_rectangle(436,74,436+128,74+128,0);
    // if (icon<=20) then draw_sprite_stretched(spr_icon,icon,436,74,128,128);
    if (icon<=20) then scr_image("creation",icon,436,74,128,128);
    if (icon>20) then draw_sprite_stretched(spr_icon_chapters,icon-19,436,74,128,128);
    
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
            if (founding<10) then scr_image("creation",founding,1164-128,74,128,128);
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
    if (text_selected!="chapter") or (custom!=2) then draw_text(800,80,string_hash_to_newline(string(chapter)));
    if (custom=2){
        if (text_selected="chapter") and (text_bar>30) then draw_text(800,80,string_hash_to_newline(string(chapter)));
        if (text_selected="chapter") and (text_bar<=30) then draw_text(805,80,string_hash_to_newline(string(chapter)+"|"));
        if (scr_text_hit(800,80,true,chapter)){
            obj_cursor.image_index=2;
            if (cooldown<=0) and (mouse_left>=1){text_selected="chapter";cooldown=8000;keyboard_string=chapter;}
        }
        if (text_selected="chapter") then chapter=keyboard_string;
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
        
        draw_text_transformed(617,332,string_hash_to_newline("Strength ("+string(strength)+")"),0.5,0.5,0);
        draw_text_transformed(617,387,string_hash_to_newline("Cooperation ("+string(cooperation)+")"),0.5,0.5,0);
        draw_text_transformed(617,442,string_hash_to_newline("GeneSeed Purity ("+string(purity)+")"),0.5,0.5,0);
        draw_text_transformed(617,497,string_hash_to_newline("GeneSeed Stability ("+string(stability)+")"),0.5,0.5,0);
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
        draw_line(445,551,1125,551);
        draw_line(445,552,1125,552);
        draw_line(445,553,1125,553);
    }
    
    if (popup!="") or (custom<2) then draw_set_alpha(0.5);
    
    
    if (popup!="icons"){
        var advantage_click = (mouse_left>=1  && cooldown<=0  &&  custom>1);
        draw_set_halign(fa_left);
        draw_set_font(fnt_40k_30b);
        draw_text_transformed(436,564,"Chapter Advantages",0.5,0.5,0);draw_set_font(fnt_40k_14);
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
                if (points+20>maxpoints) and (adv_num[i]=0) and (popup=""){
                    tooltip="Insufficient Points";
                    tooltip2="Add disadvantages or decrease Chapter Stats";
                }
                
                if (adv_num[i]!=0){
                    tooltip=advantage[adv_num[i]];
                    tooltip2=advantage_tooltip[adv_num[i]];
                }
                if (advantage_click){
                    if (points+20<=maxpoints) and (adv_num[i]=0) and (popup=""){
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
                        points-=20;
                        adv[i]="";
                        adv_num[i]=0;
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
        for (i=1;i<=max_disadvantage_count;i++){
            var draw_string = dis_num[i]==0?"[+]":"[-] "+dis[i];
            draw_text(dis_txt.x1,dis_txt.y1+(i*dis_txt.h), draw_string);
            if (scr_hit(dis_txt.x1,dis_txt.y1+(i*dis_txt.h),dis_txt.x2,dis_txt.y2+(i*dis_txt.h))){
                if (dis_num[i]!=0){
                    tooltip=disadvantage[dis_num[i]];
                    tooltip2=dis_tooltip[dis_num[i]];
                }
                if (advantage_click){
                    if ((dis_num[i]=0) and (popup="")){
                        popup="disadvantages";
                        cooldown=8000;
                        temp=i;
                    }
                    var removable=false;
                    if (i==max_disadvantage_count && dis_num[i]>0){
                        removable=true;
                    } else if (dis_num[i]>0 && dis_num[i+1]==0){
                        removable=true;
                    }                    
                    if  (mouse_x<=830) and (removable) and (points+20<=maxpoints) {
                        points+=20;
                        dis[i]="";
                        dis_num[i]=0;
                        cooldown=8000;
                    }   
                }             
            }
        }
        draw_set_alpha(1);
        if (scr_hit(436,564,631,583)){
            tooltip="Chapter Advantages";
            tooltip2="Advantages cost 20 points, and improve the performance of your chapter in a specific domain.";
        }
        if (scr_hit(810,564,1030,583)){
            tooltip="Chapter Disadvantages";
            tooltip2="Disadvantages Grant 20 additional points, and penalize the performance of your chapter.";
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
        cw=string_width(string_hash_to_newline("Cancel"))*0.6;
        ch=string_height(string_hash_to_newline("Cancel"))*0.6;
        
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
            
            if (ic<=(76+global.custom_icons)){
                // if (ic=21) then ic=23;
                
                // draw_rectangle(x3,y3,x3+96,y3+96,0);
                // if (ic<=20) then draw_sprite_stretched(spr_icon,ic,x3,y3,96,96);
                if (ic<=20) then scr_image("creation",ic,x3,y3,96,96);
                if (ic>20) and (ic<=76) then draw_sprite_stretched(spr_icon_chapters,ic-19,x3,y3,96,96);
                if (ic>76) and (obj_cuicons.spr_custom[ic-76]>0) and (obj_cuicons.spr_custom_icon[ic-76]!=-1){
                    draw_sprite_stretched(obj_cuicons.spr_custom_icon[ic-76],0,x3,y3,96,96);
                }
                
                if (scr_hit(x3,y3,x3+96,y3+96)){
                    draw_set_blend_mode(bm_add);draw_set_alpha(0.25);draw_set_color(16119285);
                    // if (ic<=20) then draw_sprite_stretched(spr_icon,ic,x3,y3,96,96);
                    if (ic<=20) then scr_image("creation",ic,x3,y3,96,96);
                    if (ic>20) and (ic<=76) then draw_sprite_stretched(spr_icon_chapters,ic-19,x3,y3,96,96);
                    if (ic>76) and (obj_cuicons.spr_custom[ic-76]>0) and (obj_cuicons.spr_custom_icon[ic-76]!=-1){
                        draw_sprite_stretched(obj_cuicons.spr_custom_icon[ic-76],0,x3,y3,96,96);
                    }
                    draw_set_blend_mode(bm_normal);
                    draw_set_alpha(1);draw_set_color(38144);
                    
                    if (mouse_left=1) and (cooldown<=0){
                        cooldown=8000;popup="";icon=ic;icon_name="";scr_icon("");
                        if (ic>76) then custom_icon=ic-76;
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
        draw_set_font(fnt_40k_30b);draw_set_halign(fa_center);
        draw_text_transformed(800,211,string_hash_to_newline("Select an Advantage"),0.6,0.6,0);
        draw_set_font(fnt_40k_14b);draw_set_halign(fa_left);
        
        for(var i = 0; i < array_length(advantage); i++){
            var column = {
                x1: 436,
                y1: 250,
                w: 100,
                h: 20,
            }
            column.x2 = column.x1 + column.w;
            column.y2 = column.y1 + column.h;
            var disable = 0;
            if (advantage[i]!=""){
                var adv_name = advantage[i];
                //columns of 14, shift the left boarder across
                if(i >= 15 && i <29) {column.x1 = 670; column.x2 = column.x1 + column.w;};
                if(i >= 29 && i <42) {column.x1 = 904; column.x2 = column.x1 + column.w;};
                draw_set_color(38144);draw_set_alpha(1);
                if (array_contains(adv, adv_name)) then draw_set_alpha(0.5);
                if (adv_name="Psyker Abundance" && array_contains(dis, "Psyker Intolerant")){disable=1;draw_set_alpha(0.5);} 
                if (adv_name="Reverent Guardians"&& array_contains(dis, "Suspicious")){disable=1;draw_set_alpha(0.5);} 
                if (adv_name="Tech-Brothers" && array_contains(dis, "Tech-Heresy")){disable=1;draw_set_alpha(0.5);}
                
                var gap = (((i-1)%14) * column.h);
                draw_text(column.x1,column.y1+gap,string_hash_to_newline(adv_name));
                
                // Cancel button
                if (scr_hit(column.x1,column.y1+gap,column.x1+string_width(string_hash_to_newline(adv_name)),column.y1+column.h+gap)) and (cooldown<=0) and (mouse_left>=1) and (adv_name="Cancel"){
                    cooldown=8000;popup="";
                }
                // Tooltips
                if (scr_hit(column.x1,column.y1+gap,column.x1+string_width(string_hash_to_newline(adv_name)),column.y1+column.h+gap)){
                    tooltip=adv_name;tooltip2=advantage_tooltip[i];draw_set_color(c_white);draw_set_alpha(0.2);
                    draw_text(column.x1,column.y1+gap,string_hash_to_newline(adv_name));
                }
                //Click on advantage
                if (scr_hit(column.x1,column.y1+gap,column.x1+string_width(string_hash_to_newline(adv_name)),column.y1+column.h+gap)) and (cooldown<=0) and (mouse_left>=1) and (array_contains(adv, adv_name) == false){
                    if (disable=0){
                        cooldown=8000;
                        adv[temp]=adv_name;
                        adv_num[temp]=i;
                        popup="";
                        points+=20;
                    }
            }}
        }}
        
    if (popup="disadvantages"){
        draw_set_font(fnt_40k_30b);draw_set_halign(fa_center);
        draw_text_transformed(800,211,string_hash_to_newline("Select a Disadvantage"),0.6,0.6,0);
        draw_set_font(fnt_40k_14b);draw_set_halign(fa_left);
        for(var i = 0; i < array_length(disadvantage); i++){
            var column = {
                x1: 436,
                y1: 250,
                w: 100,
                h: 20,
            }
            column.x2 = column.x1 + column.w;
            column.y2 = column.y1 + column.h;
            var disable = 0;
            if (disadvantage[i]!=""){
                var dis_name = disadvantage[i];
                //columns of 14, shift the left boarder across and leave a gap at the top on cols 2 & 3
                if(i >= 15 && i <29) {column.x1 = 670; column.x2 = column.x1 + column.w;};
                if(i >= 29 && i <42) {column.x1 = 904; column.x2 = column.x1 + column.w;};
                draw_set_color(38144);draw_set_alpha(1);
                if (array_contains(dis, dis_name)) then draw_set_alpha(0.5);
                
                if (dis_name="Psyker Intolerant") and (array_contains(adv, "Psyker Abundance")){disable=1;draw_set_alpha(0.5);}
                if (dis_name="Suspicious") and (array_contains(adv, "Reverent Guardians")){disable=1;draw_set_alpha(0.5);}
                if (dis_name="Tech-Heresy") and (array_contains(adv, "Tech-Brothers")){disable=1;draw_set_alpha(0.5);}
                if (dis_name="Blood Debt") and (fleet_type=3){disable=1;draw_set_alpha(0.5);}
                
                var gap = (((i-1)%14) * column.h);

                draw_text(column.x1,column.y1+gap,string_hash_to_newline(dis_name));
                
                // Cancel button
                if (scr_hit(column.x1,column.y1+gap,column.x1+string_width(string_hash_to_newline(dis_name)),column.y1+column.h+gap)) and (cooldown<=0) and (mouse_left>=1) and (dis_name="Cancel"){
                    cooldown=8000;popup="";
                }
                //Tooltip
                if (scr_hit(column.x1,column.y1+gap,column.x1+string_width(string_hash_to_newline(dis_name)),column.y1+column.h+gap)){tooltip=dis_name;tooltip2=dis_tooltip[i];draw_set_color(c_white);draw_set_alpha(0.2);draw_text(column.x1,column.y1+gap,string_hash_to_newline(dis_name));}
                //Click on disadvantage
                if (scr_hit(column.x1,column.y1+gap,column.x1+string_width(string_hash_to_newline(dis_name)),column.y1+column.h+gap)) and (cooldown<=0) and (mouse_left>=1) and (array_contains(dis, dis_name) == false){
                    if (disable=0){
                        cooldown=8000;
                        dis[temp]=dis_name;
                        dis_num[temp]=i;
                        popup="";
                        points-=20;
                    }
        }}}
    }
    if (popup!="") and ((mouse_left>=1) or (mouse_right=1)) and (cooldown<=0){
        if ((mouse_x<445) or (mouse_x>1125) or (mouse_y<200) or (mouse_y>552)) and (popup!="icons"){
            cooldown=8000;popup="";
        }
        if ((mouse_x<445) or (mouse_x>1125) or (mouse_y<200) or (mouse_y>719)) and (popup="icons"){
            cooldown=8000;popup="";
        }
    }
    
}

/* Homeworld, Flagship, Psychic discipline, Aspirant Trial */

var yar;yar=0;

if (slide=3){
    draw_set_color(38144);
    draw_set_font(fnt_40k_30b);
    draw_set_halign(fa_center);
    
    tooltip="";tooltip2="";
    obj_cursor.image_index=0;
    
    draw_text(800,80,string_hash_to_newline(string(chapter)));
    
    draw_set_color(38144);
    draw_line(445,200,1125,200);
    draw_line(445,201,1125,201);
    draw_line(445,202,1125,202);
    
    
    
    
    var fleet_type_text = fleet_type==1?"Homeworld":"Flagship";
    draw_text_transformed(644,218,fleet_type_text,0.6,0.6,0);

    var eh,eh2;eh=0;eh2=0;name_bad=0;
    
    if (homeworld="Lava") then eh=0;
    if (homeworld="Desert") then eh=2;
    if (homeworld="Forge") then eh=3;
    if (homeworld="Hive") then eh=4;
    if (homeworld="Death") then eh=5;
    if (homeworld="Agri") then eh=6;
    if (homeworld="Feudal") then eh=7;
    if (homeworld="Temperate") then eh=8;
    if (homeworld="Ice") then eh=9;
    if (homeworld="Dead") then eh=10;
    if (homeworld="Shrine") then eh=16;
    if (fleet_type!=1) then eh=15;
    
    if (fleet_type=1){
        scr_image("planet",eh,580,244,128,128);
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
    if (fleet_type!=1){
        // draw_sprite(spr_planet_splash,eh,580,244);
        scr_image("planet",eh,580,244,128,128);
        
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
        }
    }
    
    
    
    
    
    if (fleet_type!=3){
        if (fleet_type!=1) or (custom<2) then draw_set_alpha(0.5);
        yar=0;if (recruiting_exists=1) then yar=1;draw_sprite(spr_creation_check,yar,858,221);yar=0;
        if (scr_hit(858,221,858+32,221+32)) and (cooldown<=0) and (mouse_left>=1) and (custom>1) and (fleet_type=1){cooldown=8000;var onceh;onceh=0;
            if (recruiting_exists=1) and (onceh=0){recruiting_exists=0;onceh=1;}
            if (recruiting_exists=0) and (onceh=0){recruiting_exists=1;onceh=1;}
        }
        draw_set_alpha(1);draw_text_transformed(644+333,218,string_hash_to_newline("Recruiting World"),0.6,0.6,0);
        
        if (recruiting_exists=1){
            if (recruiting="Lava") then eh2=0;
            if (recruiting="Desert") then eh2=2;
            if (recruiting="Forge") then eh2=3;
            if (recruiting="Hive") then eh2=4;
            if (recruiting="Death") then eh2=5;
            if (recruiting="Agri") then eh2=6;
            if (recruiting="Feudal") then eh2=7;
            if (recruiting="Temperate") then eh2=8;
            if (recruiting="Ice") then eh2=9;
            if (recruiting="Dead") then eh2=10;
            if (recruiting="Shrine") then eh2=16;
            
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
            scr_image("planet",eh2,580+333,244,128,128);
            
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
            }
        }
    }
    
    if (recruiting_exists=0) and (homeworld_exists=1){
        // draw_sprite(spr_planet_splash,eh,580+333,244);
        scr_image("planet",eh,580+333,244,128,128);
        
        draw_set_alpha(0.5);
        draw_text_transformed(644+333,378,string_hash_to_newline(string(homeworld)),0.5,0.5,0);
        draw_text_transformed(644+333,398,string_hash_to_newline(string(homeworld_name)),0.5,0.5,0);
        draw_set_alpha(1);
    }
    
    
    if (scr_hit(575,216,710,242)){
        if (fleet_type!=1){tooltip="Battle Barge";tooltip2="The name of your Flagship Battle Barge.";}
        if (fleet_type=1){tooltip="Homeworld";tooltip2="The world that your Chapter's Fortress Monastery is located upon.  More civilized worlds are more easily defensible but the citizens may pose a risk or be a nuisance.";}
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
    
    if (fleet_type=1){
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
            tooltip="Planetary Governer";
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
    draw_set_font(fnt_40k_30b);
    draw_set_halign(fa_center);
    draw_set_alpha(1);
    draw_set_color(38144);

    
    tooltip="";tooltip2="";
    obj_cursor.image_index=0;

    draw_text_color_simple(800,80,string_hash_to_newline(string(chapter)),38144);
    var draw_sprites = [spr_mk7_colors, spr_mk4_colors,spr_mk5_colors,spr_beakie_colors,spr_mk8_colors,spr_mk3_colors, spr_terminator3_colors];
    var draw_hem = [spr_generic_sgt_mk7, spr_generic_sgt_mk4,spr_generic_sgt_mk5,spr_generic_sgt_mk6,spr_generic_sgt_mk8,spr_generic_sgt_mk3, spr_generic_terminator_sgt];
    
    var preview_box = {
        x1: 444,
        y1: 252,
        w: 167,
        h: 232,
    }
    preview_box.x2 = preview_box.x1 + preview_box.w;
    preview_box.y2 = preview_box.y1 + preview_box.h;

	draw_sprite_stretched(spr_creation_arrow,0,preview_box.x1,preview_box.y1,32,32);// Left Arrow
    draw_sprite_stretched(spr_creation_arrow,1,preview_box.x2-32,preview_box.y1,32,32);// Right Arrow 
    if (point_and_click([preview_box.x1,preview_box.y1,preview_box.x1+32,preview_box.y1+32])){
        test_sprite++;
        if (test_sprite==array_length(draw_sprites)) then test_sprite=0;
    }   
    if (point_and_click([preview_box.x2-32,preview_box.y1,preview_box.x2, preview_box.y1+32])){
        test_sprite--;
        if (test_sprite<0) then test_sprite=(array_length(draw_sprites)-1);
    }
    draw_rectangle_color_simple(preview_box.x1,preview_box.y1,preview_box.x2,preview_box.y2,1,38144);
    if( shader_is_compiled(sReplaceColor)){
        shader_set(sReplaceColor);
        
        shader_set_uniform_f_array(colour_to_find1, body_colour_find );       
        shader_set_uniform_f_array(colour_to_set1, body_colour_replace );
        shader_set_uniform_f_array(colour_to_find2, secondary_colour_find );       
        shader_set_uniform_f_array(colour_to_set2, secondary_colour_replace );
        shader_set_uniform_f_array(colour_to_find3, pauldron_colour_find );       
        shader_set_uniform_f_array(colour_to_set3, pauldron_colour_replace );
        shader_set_uniform_f_array(colour_to_find4, lens_colour_find );       
        shader_set_uniform_f_array(colour_to_set4, lens_colour_replace );
        shader_set_uniform_f_array(colour_to_find5, trim_colour_find );
        shader_set_uniform_f_array(colour_to_set5, trim_colour_replace );
        shader_set_uniform_f_array(colour_to_find6, pauldron2_colour_find );
        shader_set_uniform_f_array(colour_to_set6, pauldron2_colour_replace );
        shader_set_uniform_f_array(colour_to_find7, weapon_colour_find );
        shader_set_uniform_f_array(colour_to_set7, weapon_colour_replace );
        
        //Rejoice!
        tester_sprite = draw_sprites[test_sprite];
        tester_helm = draw_hem[test_sprite];
        if (col_special=0) then draw_sprite(tester_sprite,10,preview_box.x1,preview_box.y1 + 8);
        if (col_special=1) then draw_sprite(tester_sprite,11,preview_box.x1,preview_box.y1 + 8);
        if (col_special>=2) then draw_sprite(tester_sprite,12,preview_box.x1,preview_box.y1 + 8);
        
        draw_sprite(tester_sprite,col_special,preview_box.x1,preview_box.y1 + 8);
        if (col_special<=1){
            draw_sprite(tester_sprite,6,preview_box.x1,preview_box.y1 + 8);
            draw_sprite(tester_sprite,8,preview_box.x1,preview_box.y1 + 8);
        }
        if (col_special>=2){
            draw_sprite(tester_sprite,6,preview_box.x1,preview_box.y1 + 8);
            draw_sprite(tester_sprite,9,preview_box.x1,preview_box.y1 + 8);
        }
        if (trim=0) and (col_special<=1) then draw_sprite(tester_sprite,4,preview_box.x1,preview_box.y1 + 8);
        if (trim=0) and (col_special>=2) then draw_sprite(tester_sprite,5,preview_box.x1,preview_box.y1 + 8);
        //TODO this can be imprved but for now it's fit for purpose
        if (complex_selection=="Sergeant Markers" && complex_livery){
            var sgt_col_1 = complex_livery_data.sgt.helm_primary;
            var sgt_col_2 = complex_livery_data.sgt.helm_secondary;
            var lens_col = complex_livery_data.sgt.helm_lens;
            shader_set_uniform_f_array(colour_to_find1, [30/255,30/255,30/255]);
            shader_set_uniform_f(colour_to_set1, col_r[sgt_col_1]/255, col_g[sgt_col_1]/255, col_b[sgt_col_1]/255);
            shader_set_uniform_f_array(colour_to_find2, [200/255,0/255,0/255]);
            shader_set_uniform_f(colour_to_set2, col_r[sgt_col_2]/255, col_g[sgt_col_2]/255, col_b[sgt_col_2]/255);
            shader_set_uniform_f(colour_to_set4, col_r[lens_col]/255, col_g[lens_col]/255, col_b[lens_col]/255);
            draw_sprite(tester_helm, complex_depth_selection, preview_box.x1,preview_box.y1 + 8);
        }
        else if (complex_selection=="Veteran Sergeant Markers" && complex_livery){
            var sgt_col_1 = complex_livery_data.vet_sgt.helm_primary;
            var sgt_col_2 = complex_livery_data.vet_sgt.helm_secondary;
            var lens_col = complex_livery_data.vet_sgt.helm_lens;
            shader_set_uniform_f_array(colour_to_find1, [30/255,30/255,30/255]);
            shader_set_uniform_f(colour_to_set1, col_r[sgt_col_1]/255, col_g[sgt_col_1]/255, col_b[sgt_col_1]/255);
            shader_set_uniform_f_array(colour_to_find2, [200/255,0/255,0/255]);
            shader_set_uniform_f(colour_to_set2, col_r[sgt_col_2]/255, col_g[sgt_col_2]/255, col_b[sgt_col_2]/255);
            shader_set_uniform_f(colour_to_set4, col_r[lens_col]/255, col_g[lens_col]/255, col_b[lens_col]/255);
            draw_sprite(tester_helm, complex_depth_selection, preview_box.x1,preview_box.y1 + 8);
        }
        else if (complex_selection=="Captain Markers" && complex_livery){
            var sgt_col_1 = complex_livery_data.captain.helm_primary;
            var sgt_col_2 = complex_livery_data.captain.helm_secondary;
            var lens_col = complex_livery_data.captain.helm_lens;
            shader_set_uniform_f_array(colour_to_find1, [30/255,30/255,30/255]);
            shader_set_uniform_f(colour_to_set1, col_r[sgt_col_1]/255, col_g[sgt_col_1]/255, col_b[sgt_col_1]/255);
            shader_set_uniform_f_array(colour_to_find2, [200/255,0/255,0/255]);
            shader_set_uniform_f(colour_to_set2, col_r[sgt_col_2]/255, col_g[sgt_col_2]/255, col_b[sgt_col_2]/255);
            shader_set_uniform_f(colour_to_set4, col_r[lens_col]/255, col_g[lens_col]/255, col_b[lens_col]/255);
            draw_sprite(tester_helm, complex_depth_selection, preview_box.x1,preview_box.y1 + 8);
        } else if (complex_selection=="Veteran Markers" && complex_livery){
            var sgt_col_1 = complex_livery_data.veteran.helm_primary;
            var sgt_col_2 = complex_livery_data.veteran.helm_secondary;
            var lens_col = complex_livery_data.veteran.helm_lens;
            shader_set_uniform_f_array(colour_to_find1, [30/255,30/255,30/255]);
            shader_set_uniform_f(colour_to_set1, col_r[sgt_col_1]/255, col_g[sgt_col_1]/255, col_b[sgt_col_1]/255);
            shader_set_uniform_f_array(colour_to_find2, [200/255,0/255,0/255]);
            shader_set_uniform_f(colour_to_set2, col_r[sgt_col_2]/255, col_g[sgt_col_2]/255, col_b[sgt_col_2]/255);
            shader_set_uniform_f(colour_to_set4, col_r[lens_col]/255, col_g[lens_col]/255, col_b[lens_col]/255);
            draw_sprite(tester_helm, complex_depth_selection, preview_box.x1,preview_box.y1 + 8);
        }                 
        shader_set_uniform_f_array(colour_to_find1, body_colour_find );       
        shader_set_uniform_f_array(colour_to_set1, body_colour_replace );
        shader_set_uniform_f_array(colour_to_find2, secondary_colour_find );       
        shader_set_uniform_f_array(colour_to_set2, secondary_colour_replace ); 
        shader_set_uniform_f_array(colour_to_set4, lens_colour_replace );
		if(tester_sprite == spr_terminator3_colors){
			draw_sprite(spr_weapon_colors,0,444 - 12,252 + 5);
		} else {
			draw_sprite(spr_weapon_colors,0,444,252);	
		}
        shader_reset();
        
    }else{
        draw_text(444,252,string_hash_to_newline("Color swap shader#did not compile"));
    }
    
    draw_set_color(38144);draw_set_halign(fa_left);
    draw_text_transformed(580,118,string_hash_to_newline("Battle Cry:"),0.6,0.6,0);draw_set_font(fnt_40k_14b);
    if (text_selected!="battle_cry") or (custom<2) then draw_text_ext(580,144,string_hash_to_newline(string(battle_cry)+"!"),-1,580);
    if (custom>1){
        if (text_selected="battle_cry") and (text_bar>30) then draw_text_ext(580,144,string_hash_to_newline(string(battle_cry)+"!"),-1,580);
        if (text_selected="battle_cry") and (text_bar<=30) then draw_text_ext(580,144,string_hash_to_newline(string(battle_cry)+"|!"),-1,580);
        var str_width=max(580,string_width_ext(string_hash_to_newline(battle_cry),-1,580));
        var hei=string_height_ext(string_hash_to_newline(battle_cry),-1,580);
        if (scr_hit(580-2,144-2,582+str_width,146+hei)){obj_cursor.image_index=2;
            if (mouse_left>=1) and (cooldown<=0) and (!instance_exists(obj_creation_popup)){text_selected="battle_cry";cooldown=8000;keyboard_string=battle_cry;}
        }
        if (text_selected="battle_cry") then battle_cry=keyboard_string;
        draw_rectangle(580-2,144-2,582+580,146+hei,1);
    }
    
    
    
    
    draw_line(445,200,1125,200);
    draw_line(445,201,1125,201);
    draw_line(445,202,1125,202);
    
    draw_set_font(fnt_40k_30b);
    draw_text_transformed(444,215,string_hash_to_newline("Livelry"),0.6,0.6,0);
    var button_alpha = custom < 2 ? 0.5 : 1;
    var livery_swap_button = draw_unit_buttons([544,215], complex_livery? "Simple Livery":"Complex Livery",[1,1], 38144,, fnt_40k_14b, button_alpha);
    if (point_and_click(livery_swap_button) && custom >= 2){
        complex_livery=!complex_livery;
    }
    var str,str_width,hei,x8,y8;x8=0;y8=0;
    //Dont ask why the pauldron colours are switched i guess duke got confused between left and right at some point
    //TODO extract this function somewhere
    /*function draw_checkbox (cords, text, main_alpha, checked){
            draw_set_alpha(main_alpha);
            yar = col_special==(i+1) ?1:0;
            if (custom<2) then draw_set_alpha(0.5);
            draw_sprite(spr_creation_check,yar,cur_button.cords[0],cur_button.cords[1]);
             if (scr_hit(cur_button.cords[0],cur_button.cords[1],cur_button.cords[0]+32,cur_button.cords[1]+32) and allow_colour_click){
                    cooldown=8000;
                    var onceh=0;
                    if (col_special=i+1) and (onceh=0){col_special=0;onceh=1;}
                    if (col_special!=i+1) and (onceh=0){col_special=i+1;onceh=1;}
             }
             draw_text_transformed(cur_button.cords[0]+30,cur_button.cords[1]+4,cur_button.text,0.4,0.4,0);
    }*/
    if (!complex_livery){
        var button_data = [
            {
                text : $"Primary : {col[main_color]}",
                tooltip:"Primary",
                tooltip2:"The main color of your Astartes and their vehicles.",
                cords : [620, 252],
            },
            {
                text : $"Secondary: {col[secondary_color]}",
                tooltip:"Secondary",
                tooltip2:"The secondary color of your Astartes and their vehicles.",
                cords : [620, 287],
            },
            {
                text : $"Pauldron 1: {col[pauldron2_color]}",
                tooltip:"First Pauldron",
                tooltip2:"The color of your Astartes' right Pauldron.  Normally this Pauldron displays their rank and designation.",
                cords : [620, 322],
            },
            {
                text : $"Pauldron 2: {col[pauldron_color]}",
                tooltip:"Second Pauldron",
                tooltip2:"The color of your Astartes' left Pauldron.  Normally this Pauldron contains the Chapter Insignia.",
                cords : [620, 357],
            },
            {
                text : $"Trim: {col[trim_color]}",
                tooltip:"Trim",
                tooltip2:"The trim color that appears on the Pauldrons, armour plating, and any decorations.",
                cords : [620, 392],                
            },
            {
                text : $"Lens: {col[lens_color]}",
                tooltip:"Lens",
                tooltip2:"The color of your Astartes' lenss.  Most of the time this will be the visor color.",
                cords : [620, 427],                
            },
            {
                text : $"Weapon: {col[weapon_color]}",
                tooltip:"Weapon",
                tooltip2:"The primary color of your Astartes' weapons.",
                cords : [620, 462],                
            }             
        ]
        var button_cords, cur_button;
        for (var i=0;i<array_length(button_data);i++){
            cur_button = button_data[i];
            var button_alpha = custom < 2 ? 0.5 : 1;
            button_cords = draw_unit_buttons(cur_button.cords, cur_button.text,[0.5,0.5], 38144,, fnt_40k_30b, button_alpha);
            if (scr_hit(button_cords[0],button_cords[1],button_cords[2],button_cords[3])){
                tooltip=cur_button.tooltip;
                tooltip2=cur_button.tooltip2;
            }
            if (point_and_click(button_cords) && custom >= 2){
                cooldown=8000;
                instance_destroy(obj_creation_popup);
                var pp=instance_create(0,0,obj_creation_popup);
                pp.type=i+1;
            }
        }
        draw_set_color(38144);
        var livery_type_options = [
            {
                cords : [437,500],   
                text : $"Breastplate",             
            },
            {
                cords : [554,500],   
                text : $"Vertical",             
            },
            {
                cords : [662,500],   
                text : $"Quadrant",             
            },
            {
                cords : [770,500],   
                text : $"Trim",             
            }                                    
        ]
        var yar;
        for (var i=0;i<array_length(livery_type_options);i++){
            cur_button = livery_type_options[i];
            draw_set_alpha(1);
            yar = col_special==(i+1) ?1:0;
            if (cur_button.text=="Trim") then yar = trim;
            if (custom<2) then draw_set_alpha(0.5);
            draw_sprite(spr_creation_check,yar,cur_button.cords[0],cur_button.cords[1]);
             if (scr_hit(cur_button.cords[0],cur_button.cords[1],cur_button.cords[0]+32,cur_button.cords[1]+32) and allow_colour_click){
                cooldown=8000;
                var onceh=0;
                if (cur_button.text!="Trim"){
                    if (col_special=i+1) and (onceh=0){col_special=0;onceh=1;}
                    if (col_special!=i+1) and (onceh=0){col_special=i+1;onceh=1;}
                } else {
                    trim=!trim;
                }
             }
             draw_text_transformed(cur_button.cords[0]+30,cur_button.cords[1]+4,cur_button.text,0.4,0.4,0);
        }
    } else {
        var button_data=[];
        if (complex_selection=="Sergeant Markers"){
            button_data = [
                {
                    text : $"Helm Primary : {col[complex_livery_data.sgt.helm_primary]}",
                    tooltip:"Primary Helm Colour",
                    tooltip2:"Primary helm colour of sgt.",
                    cords : [620, 252],
                    type : "helm_primary",
                    role : "sgt",
                },
                {
                    text : $"Helm Secondary: {col[complex_livery_data.sgt.helm_secondary]}",
                    tooltip:"Secondary",
                    tooltip2:"Secondary helm colour of sgt.",
                    cords : [620, 287],
                    type : "helm_secondary",
                    role : "sgt",
                },
                {
                    text : $"Helm lens: {col[complex_livery_data.sgt.helm_lens]}",
                    tooltip:"Secondary",
                    tooltip2:"helm lens colour of sgt.",
                    cords : [620, 322],
                    type : "helm_lens",
                    role : "sgt",
                },                
            ];
            if (turn_selection_change){
                complex_depth_selection=complex_livery_data.sgt.helm_pattern;
            } else {complex_livery_data.sgt.helm_pattern=complex_depth_selection;}

        } else if (complex_selection=="Veteran Sergeant Markers"){
            button_data = [
                {
                    text : $"Helm Primary : {col[complex_livery_data.vet_sgt.helm_primary]}",
                    tooltip:"Primary Helm Colour",
                    tooltip2:"Primary helm colour of sgt.",
                    cords : [620, 252],
                    type : "helm_primary",
                    role : "vet_sgt",
                },
                {
                    text : $"Helm Secondary: {col[complex_livery_data.vet_sgt.helm_secondary]}",
                    tooltip:"Secondary",
                    tooltip2:"Secondary helm colour of sgt.",
                    cords : [620, 287],
                    type : "helm_secondary",
                    role : "vet_sgt",
                },
                {
                    text : $"Helm lens: {col[complex_livery_data.vet_sgt.helm_lens]}",
                    tooltip:"Secondary",
                    tooltip2:"helm lens colour of sgt.",
                    cords : [620, 322],
                    type : "helm_lens",
                    role : "vet_sgt",
                },                
            ];
            if (turn_selection_change){
                complex_depth_selection=complex_livery_data.vet_sgt.helm_pattern;
            } else {complex_livery_data.vet_sgt.helm_pattern=complex_depth_selection;}

        }else if (complex_selection=="Captain Markers"){
            button_data = [
                {
                    text : $"Helm Primary : {col[complex_livery_data.captain.helm_primary]}",
                    tooltip:"Primary Helm Colour",
                    tooltip2:"Primary helm colour of captain.",
                    cords : [620, 252],
                    type : "helm_primary",
                    role : "captain",
                },
                {
                    text : $"Helm Secondary: {col[complex_livery_data.captain.helm_secondary]}",
                    tooltip:"Secondary",
                    tooltip2:"Secondary helm colour of captain.",
                    cords : [620, 287],
                    type : "helm_secondary",
                    role : "captain",
                },
                {
                    text : $"Helm lens: {col[complex_livery_data.captain.helm_lens]}",
                    tooltip:"lens",
                    tooltip2:"helm lens colour of captain.",
                    cords : [620, 322],
                    type : "helm_lens",
                    role : "captain",
                },                
            ];
             if (turn_selection_change){
                complex_depth_selection=complex_livery_data.captain.helm_pattern;
            } else {complex_livery_data.captain.helm_pattern=complex_depth_selection;}
        } else if (complex_selection=="Veteran Markers"){
            button_data = [
                {
                    text : $"Helm Primary : {col[complex_livery_data.veteran.helm_primary]}",
                    tooltip:"Primary Helm Colour",
                    tooltip2:"Primary helm colour of Veterans.",
                    cords : [620, 252],
                    type : "helm_primary",
                    role : "veteran",
                },
                {
                    text : $"Helm Secondary: {col[complex_livery_data.veteran.helm_secondary]}",
                    tooltip:"Secondary",
                    tooltip2:"Secondary helm colour of Veterans.",
                    cords : [620, 287],
                    type : "helm_secondary",
                    role : "veteran",
                },
                {
                    text : $"Helm lens: {col[complex_livery_data.veteran.helm_lens]}",
                    tooltip:"lens",
                    tooltip2:"helm lens colour of Veterans.",
                    cords : [620, 322],
                    type : "helm_lens",
                    role : "veteran",
                },                
            ];
             if (turn_selection_change){
                complex_depth_selection=complex_livery_data.veteran.helm_pattern;
            } else {complex_livery_data.veteran.helm_pattern=complex_depth_selection;}
        }
        turn_selection_change = false;
        var button_cords, cur_button;
        for (var i=0;i<array_length(button_data);i++){
            cur_button = button_data[i];
            button_cords = draw_unit_buttons(cur_button.cords, cur_button.text,[0.5,0.5], 38144,, fnt_40k_30b, 1);
            if (scr_hit(button_cords[0],button_cords[1],button_cords[2],button_cords[3])){
                 tooltip=cur_button.tooltip;
                 tooltip2=cur_button.tooltip2;
            }
            if (point_and_click(button_cords)){
                cooldown=8000;
                instance_destroy(obj_creation_popup);
                var pp=instance_create(0,0,obj_creation_popup);
                pp.type=cur_button.type;
                pp.role = cur_button.role
            }
        }
        draw_set_color(38144);
        var livery_type_options = [
            {
                cords : [437,500],   
                text : $"Single Colour",             
            },
            {
                cords : [554,500],   
                text : $"Stripe",             
            },
            {
                cords : [662,500],   
                text : $"Muzzle",             
            },
            {
                cords : [770,500],   
                text : $"Pattern",
            }                               
        ]  
        var yar;
        for (var i=0;i<array_length(livery_type_options);i++){
            cur_button = livery_type_options[i];
            draw_set_alpha(1);
            yar = complex_depth_selection==(i) ? 1 : 0;
            if (custom<2) then draw_set_alpha(0.5);
            draw_sprite(spr_creation_check,yar,cur_button.cords[0],cur_button.cords[1]);
             if (scr_hit(cur_button.cords[0],cur_button.cords[1],cur_button.cords[0]+32,cur_button.cords[1]+32) and allow_colour_click){
                    cooldown=8000;
                    var onceh=0;
                    if (complex_depth_selection=i) and (onceh=0){complex_depth_selection=0;onceh=1;}
                    else if (complex_depth_selection!=i) and (onceh=0){complex_depth_selection=i;onceh=1;}
             }
             draw_text_transformed(cur_button.cords[0]+30,cur_button.cords[1]+4,cur_button.text,0.4,0.4,0);
        }                                           
    }
    draw_set_alpha(1);
    
    draw_line(844,204,844,740);
    draw_line(845,204,845,740);
    draw_line(846,204,846,740);
    draw_text_transformed(862,215,string_hash_to_newline("Astartes Role Settings"),0.6,0.6,0);
    draw_set_font(fnt_40k_14b);var c,role_id,spacing;c=100;spacing=30;
    draw_set_halign(fa_left);var xxx,yyy;xxx=862;yyy=255-spacing;
    
    
    if (!complex_livery){
        var role_slot;
        role_slot=0;
        
        repeat(13){role_slot+=1;
            if (role_slot=1) then role_id=15;
            if (role_slot=2) then role_id=14;
            if (role_slot=3) then role_id=17;
            if (role_slot=4) then role_id=16;
            if (role_slot=5) then role_id=5;
            if (role_slot=6) then role_id=2;
            if (role_slot=7) then role_id=4;
            if (role_slot=8) then role_id=3;
            if (role_slot=9) then role_id=6;
            if (role_slot=10) then role_id=8;
            if (role_slot=11) then role_id=9;
            if (role_slot=12) then role_id=10;
            if (role_slot=13) then role_id=12;
            
            draw_set_alpha(1);
            if (race[c,role_id]!=0){
                if (custom<2) then draw_set_alpha(0.5);
                yyy+=spacing;draw_set_color(38144);draw_rectangle(xxx,yyy,1150,yyy+20,1);
                draw_set_color(38144);draw_text(xxx,yyy,string_hash_to_newline(role[c,role_id]));
                if (scr_hit(xxx,yyy,1150,yyy+20)) and ((!instance_exists(obj_creation_popup)) || ((instance_exists(obj_creation_popup) and obj_creation_popup.target_gear=0))) {
                    if (custom=2) then draw_set_alpha(0.2);
                    if (custom<2) then draw_set_alpha(0.1);
                    draw_set_color(c_white);
                    draw_rectangle(xxx,yyy,1150,yyy+20,0);
                    draw_set_alpha(1);tooltip=string(role[c,role_id])+" Settings";
                    tooltip2="Click to open the settings for this unit.";
                    if (mouse_left>=1) and (custom>0) and (cooldown<=0) and (custom=2){
                        instance_destroy(obj_creation_popup);
                        var pp=instance_create(0,0,obj_creation_popup);
                        pp.type=role_id+100;
                        cooldown=8000;
                    }
                }
            }
        }
    } else {
        var complex_livery_options = ["Sergeant Markers","Veteran Sergeant Markers", "Captain Markers", "Veteran Markers"];
        for (var i=0;i<array_length(complex_livery_options);i++){
            yyy+=spacing;
            if (point_and_click(draw_unit_buttons([xxx,yyy], complex_livery_options[i],[0.5,0.5], 38144,, fnt_40k_30b, 1))){
                complex_selection=complex_livery_options[i];
                turn_selection_change=true;
            }
        }
    }
    
    
    
    
    draw_set_color(38144);draw_set_alpha(1);draw_set_font(fnt_40k_30b);
    
    if (custom<2) then draw_set_alpha(0.5);
    yar=0;if (equal_specialists=1) then yar=1;draw_sprite(spr_creation_check,yar,860,645);yar=0;
    if (scr_hit(860,650,1150,650+32)) and (!instance_exists(obj_creation_popup)){tooltip="Specialist Distribution";tooltip2="Check if you wish for your Companies to be uniform and each contain "+string(role[100][10])+"s and "+string(role[100][9])+"s.";}
    if (scr_hit(860,650,860+32,650+32) and allow_colour_click){
        cooldown=8000;var onceh;onceh=0;
        if (equal_specialists=1) and (onceh=0){equal_specialists=0;onceh=1;}
        if (equal_specialists!=1) and (onceh=0){equal_specialists=1;onceh=1;}
    }draw_text_transformed(860+30,650+4,string_hash_to_newline("Equal Specialist Distribution"),0.4,0.4,0);
    draw_set_alpha(1);
    
    yar=0;if (load_to_ships[0]=1) then yar=1;draw_sprite(spr_creation_check,yar,860,645+40);yar=0;
    if (scr_hit(860,645+40,1005,645+32+40) and !instance_exists(obj_creation_popup)){tooltip="Load to Ships";tooltip2="Check to have your Astartes automatically loaded into ships when the game starts.";}
    if (scr_hit(860,645+40,860+32,645+32+40) and (cooldown<=0) and (mouse_left>=1) and (!instance_exists(obj_creation_popup))){
        cooldown=8000;var onceh;onceh=0;
        if (load_to_ships[0]=1) and (onceh=0){load_to_ships[0]=0;onceh=1;}
        if (load_to_ships[0]!=1) and (onceh=0){load_to_ships[0]=1;onceh=1;}
    }draw_text_transformed(860+30,645+4+40,string_hash_to_newline("Load to Ships"),0.4,0.4,0);
    
    yar=0;if (load_to_ships[0]=2) then yar=1;draw_sprite(spr_creation_check,yar,1010,645+40);yar=0;
    if (scr_hit(1010,645+40,1150,645+32+40)) and (!instance_exists(obj_creation_popup)){tooltip="Load (Sans Escorts)";tooltip2="Check to have your Astartes automatically loaded into ships, except for Escorts, when the game starts.";}
    if (scr_hit(1010,645+40,1020+32,645+32+40)) and (cooldown<=0) and (mouse_left>=1) and (!instance_exists(obj_creation_popup)){
        cooldown=8000;var onceh;onceh=0;
        if (load_to_ships[0]=2) and (onceh=0){load_to_ships[0]=0;onceh=1;}
        if (load_to_ships[0]!=2) and (onceh=0){load_to_ships[0]=2;onceh=1;}
    }draw_text_transformed(1010+30,645+4+40,string_hash_to_newline("Load (Sans Escorts)"),0.4,0.4,0);
	
	yar=0;
	if (load_to_ships[0] > 0){
		if (load_to_ships[1] == 1){
			yar=1;
		}
		draw_sprite(spr_creation_check,yar,860,645+80);yar=0;
    	if (scr_hit(860,645+80,1005,645+32+80)) and (!instance_exists(obj_creation_popup)){tooltip="Distribute Scouts";tooltip2="Check to have your Scouts split across ships in the fleet.";}
    	if (scr_hit(860,645+80,860+32,645+32+80)) and (cooldown<=0) and (mouse_left>=1) and (!instance_exists(obj_creation_popup)){
    		 cooldown=8000;
             var onceh;onceh=0;
             load_to_ships[1] = !load_to_ships[1];  		 
    	}
    	draw_text_transformed(860+30,645+4+80,string_hash_to_newline("Distribute Scouts"),0.4,0.4,0);	
	
		yar=0;
		if (load_to_ships[2] == 1){
			yar=1;
		}
		draw_sprite(spr_creation_check,yar,1010,645+80);yar=0;
    	if (scr_hit(1010,645+80,1150,645+32+80)) and (!instance_exists(obj_creation_popup)){tooltip="Distribute Veterans";tooltip2="Check to have your Veterans split across the fleet.";}
    	if (scr_hit(1010,645+80,1020+32,645+32+80)) and (cooldown<=0) and (mouse_left>=1) and (!instance_exists(obj_creation_popup)){
    		 cooldown=8000;var onceh;onceh=0;
    		 if (load_to_ships[2]=0) and (onceh=0){load_to_ships[2]=1;onceh=1;}
     		 if (load_to_ships[2]=1) and (onceh=0){load_to_ships[2]=0;onceh=1;}   		 
    	}
    	draw_text_transformed(1010+30,645+4+80,string_hash_to_newline("Distribute Veterans"),0.4,0.4,0);	
	}	
    
    
    
    
    draw_line(433,535,844,535);
    draw_line(433,536,844,536);
    draw_line(433,537,844,537);
    
    if (!instance_exists(obj_creation_popup)){
    
        if (scr_hit(540,547,800,725)){tooltip="Advisor Names";tooltip2="The names of your main Advisors.  They provide useful information and reports on the divisions of your Chapter.";}
    
        draw_text_transformed(444,550,string_hash_to_newline("Advisor Names"),0.6,0.6,0);
        draw_set_font(fnt_40k_14b);
        draw_set_halign(fa_right);
        if (race[100,15]!=0) then draw_text(594,575,string_hash_to_newline("Chief Apothecary: "));
        if (race[100,14]!=0) then draw_text(594,597,string_hash_to_newline("High Chaplain: "));
        if (race[100,17]!=0) then draw_text(594,619,string_hash_to_newline("Chief Librarian: "));
        if (race[100,16]!=0) then draw_text(594,641,string_hash_to_newline("Forge Master: "));
        draw_text(594,663,string_hash_to_newline("Master of Recruits: "));
        draw_text(594,685,string_hash_to_newline("Master of the Fleet: "));
        draw_set_halign(fa_left);
        
        if (race[100,15]!=0){
            draw_set_color(38144);if (hapothecary="") then draw_set_color(c_red);
            if (text_selected!="apoth") or (custom<2) then draw_text_ext(600,575,string_hash_to_newline(string(hapothecary)),-1,580);
            if (custom>1){
                if (text_selected="capoth") and (text_bar>30) then draw_text_ext(600,575,string_hash_to_newline(string(hapothecary)),-1,580);
                if (text_selected="capoth") and (text_bar<=30) then draw_text_ext(600,575,string_hash_to_newline(string(hapothecary)+"|"),-1,580);
                var str_width,hei;str_width=0;hei=string_height_ext(string_hash_to_newline(hapothecary),-2,580);
                if (scr_hit(600,575,785,575+hei)){obj_cursor.image_index=2;
                    if (mouse_left>=1) and (cooldown<=0) and (!instance_exists(obj_creation_popup)){text_selected="capoth";cooldown=8000;keyboard_string=hapothecary;}
                }
                if (text_selected="capoth") then hapothecary=keyboard_string;
                draw_rectangle(600-1,575-1,785,575+hei,1);
            }
        }
        
        if (race[100,14]!=0){
            draw_set_color(38144);if (hchaplain="") then draw_set_color(c_red);
            if (text_selected!="chap") or (custom<2) then draw_text_ext(600,597,string_hash_to_newline(string(hchaplain)),-1,580);
            if (custom>1){
                if (text_selected="chap") and (text_bar>30) then draw_text_ext(600,597,string_hash_to_newline(string(hchaplain)),-1,580);
                if (text_selected="chap") and (text_bar<=30) then draw_text_ext(600,597,string_hash_to_newline(string(hchaplain)+"|"),-1,580);
                var str_width,hei;str_width=0;hei=string_height_ext(string_hash_to_newline(hchaplain),-2,580);
                if (scr_hit(600,597,785,597+hei)){obj_cursor.image_index=2;
                    if (mouse_left>=1) and (cooldown<=0) and (!instance_exists(obj_creation_popup)){text_selected="chap";cooldown=8000;keyboard_string=hchaplain;}
                }
                if (text_selected="chap") then hchaplain=keyboard_string;
                draw_rectangle(600-1,597-1,785,597+hei,1);
            }
        }
        
        if (race[100,17]!=0){
            draw_set_color(38144);if (clibrarian="") then draw_set_color(c_red);
            if (text_selected!="libra") or (custom<2) then draw_text_ext(600,619,string_hash_to_newline(string(clibrarian)),-1,580);
            if (custom>1){
                if (text_selected="libra") and (text_bar>30) then draw_text_ext(600,619,string_hash_to_newline(string(clibrarian)),-1,580);
                if (text_selected="libra") and (text_bar<=30) then draw_text_ext(600,619,string_hash_to_newline(string(clibrarian)+"|"),-1,580);
                var str_width,hei;str_width=0;hei=string_height_ext(string_hash_to_newline(clibrarian),-2,580);
                if (scr_hit(600,619,785,619+hei)){obj_cursor.image_index=2;
                    if (mouse_left>=1) and (cooldown<=0) and (!instance_exists(obj_creation_popup)){text_selected="libra";cooldown=8000;keyboard_string=clibrarian;}
                }
                if (text_selected="libra") then clibrarian=keyboard_string;
                draw_rectangle(600-1,619-1,785,619+hei,1);
            }
        }
        
        if (race[100,16]!=0){
            draw_set_color(38144);if (fmaster="") then draw_set_color(c_red);
            if (text_selected!="forge") or (custom<2) then draw_text_ext(600,641,string_hash_to_newline(string(fmaster)),-1,580);
            if (custom>1){
                if (text_selected="forge") and (text_bar>30) then draw_text_ext(600,641,string_hash_to_newline(string(fmaster)),-1,580);
                if (text_selected="forge") and (text_bar<=30) then draw_text_ext(600,641,string_hash_to_newline(string(fmaster)+"|"),-1,580);
                var str_width,hei;str_width=0;hei=string_height_ext(string_hash_to_newline(fmaster),-2,580);
                if (scr_hit(600,641,785,641+hei)){obj_cursor.image_index=2;
                    if (mouse_left>=1) and (cooldown<=0) and (!instance_exists(obj_creation_popup)){text_selected="forge";cooldown=8000;keyboard_string=fmaster;}
                }
                if (text_selected="forge") then fmaster=keyboard_string;
                draw_rectangle(600-1,641-1,785,641+hei,1);
            }
        }
        
        draw_set_color(38144);if (recruiter="") then draw_set_color(c_red);
        if (text_selected!="recr") or (custom<2) then draw_text_ext(600,663,string_hash_to_newline(string(recruiter)),-1,580);
        if (custom>1){
            if (text_selected="recr") and (text_bar>30) then draw_text_ext(600,663,string_hash_to_newline(string(recruiter)),-1,580);
            if (text_selected="recr") and (text_bar<=30) then draw_text_ext(600,663,string_hash_to_newline(string(recruiter)+"|"),-1,580);
            var str_width,hei;str_width=0;hei=string_height_ext(string_hash_to_newline(recruiter),-2,580);
            if (scr_hit(600,663,785,663+hei)){obj_cursor.image_index=2;
                if (mouse_left>=1) and (cooldown<=0) and (!instance_exists(obj_creation_popup)){text_selected="recr";cooldown=8000;keyboard_string=recruiter;}
            }
            if (text_selected="recr") then recruiter=keyboard_string;
            draw_rectangle(600-1,663-1,785,663+hei,1);
        }
        
        draw_set_color(38144);if (admiral="") then draw_set_color(c_red);
        if (text_selected!="admi") or (custom<2) then draw_text_ext(600,685,string_hash_to_newline(string(admiral)),-1,580);
        if (custom>1){
            if (text_selected="admi") and (text_bar>30) then draw_text_ext(600,685,string_hash_to_newline(string(admiral)),-1,580);
            if (text_selected="admi") and (text_bar<=30) then draw_text_ext(600,685,string_hash_to_newline(string(admiral)+"|"),-1,580);
            var str_width,hei;str_width=0;hei=string_height_ext(string_hash_to_newline(admiral),-2,580);
            if (scr_hit(600,685,785,685+hei)){obj_cursor.image_index=2;
                if (mouse_left>=1) and (cooldown<=0) and (!instance_exists(obj_creation_popup)){text_selected="admi";cooldown=8000;keyboard_string=admiral;}
            }
            if (text_selected="admi") then admiral=keyboard_string;
            draw_rectangle(600-1,685-1,785,685+hei,1);
        }
        
        
    
    }
    
    
}

/* Gene Seed Mutations, Disposition */


if (slide=5){
    draw_set_color(38144);
    draw_set_font(fnt_40k_30b);
    draw_set_halign(fa_center);
    draw_set_alpha(1);
    
    tooltip="";tooltip2="";
    obj_cursor.image_index=0;
    
    draw_text(800,80,string_hash_to_newline(string(chapter)));


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
    
    
    //adds "Save Chapter" button if custom chapter

    if(custom>0){
	
	draw_rectangle(1000,135,1180,170,1)
	draw_text_transformed(1090,140,string("Save Chapter"),0.6,0.6,0);draw_set_font(fnt_40k_14b);
	if (scr_hit(1000,135,1180,170)) {
		tooltip2="Click to save your chapter";
		tooltip= "Do you want to save your chapter?"
	
		if (mouse_left>=1){
			savechapter();
			
			
			tooltip2="Chapter Saved!";
		tooltip= "Do you want to save your chapter?"}
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
    
    
    if (slide>=2) and (slide<6) and (custom!=2){
        draw_set_alpha(0.8);
        if (popup="") and ((change_slide>=70) or (change_slide<=0)) and (scr_hit(927+64+12,761+12,927+128-12,761+64-12)) then draw_set_alpha(1);
        draw_sprite(spr_creation_arrow,4,927+64,761);
        if (popup="") and ((change_slide>=70) or (change_slide<=0)) and (cooldown<=0) and (mouse_left>=1){
            if (scr_hit(927+64+12,761+12,927+128-12,761+64-12)){
                scr_creation(2);scr_creation(3.5);scr_creation(4);
                scr_creation(5);scr_creation(6);
            }
        }
    }
    draw_set_alpha(1);
    
    
    var q,x3,y3;q=1;x3=(room_width/2)-65;y3=790;
    draw_set_color(38144);
    repeat(6){
        draw_circle(x3,y3,10,1);
        draw_circle(x3,y3,9.5,1);
        draw_circle(x3,y3,9,1);
        
        if (slide_show=q) then draw_circle(x3,y3,8.5,0);
        if (slide_show!=q) then draw_circle(x3,y3,8.5,1);
        x3+=25;q+=1;
    }
    
    
    
    if (popup="") and ((change_slide>=70) or (change_slide<=0)) and (cooldown<=0){
        if (mouse_x>925) and (mouse_y>756) and (mouse_x<997) and (mouse_y<824) and (mouse_left>=1) and (!instance_exists(obj_creation_popup)){// Next slide
            if (slide>=2 && slide<=6) then scr_creation(slide);            
        }
        
        
        if (mouse_x>604) and (mouse_y>756) and (mouse_x<675) and (mouse_y<824) and (mouse_left>=1) and (cooldown<=0) and (!instance_exists(obj_creation_popup)){// Previous slide
            cooldown=8000;change_slide=1;goto_slide=slide-1;popup="";
            if (goto_slide=1){
                highlight=0;highlighting=0;old_highlight=0;
            }
        }
    }
    
}




if (tooltip!="") and (tooltip2!="") and (change_slide<=0){
    draw_set_alpha(1);
    draw_set_font(fnt_40k_14);draw_set_halign(fa_left);draw_set_color(0);
    draw_rectangle(mouse_x+18,mouse_y+20,mouse_x+string_width_ext(string_hash_to_newline(tooltip2),-1,500)+24,mouse_y+44+string_height_ext(string_hash_to_newline(tooltip2),-1,500),0);
    draw_set_color(38144);
    draw_rectangle(mouse_x+18,mouse_y+20,mouse_x+string_width_ext(string_hash_to_newline(tooltip2),-1,500)+24,mouse_y+44+string_height_ext(string_hash_to_newline(tooltip2),-1,500),1);
    draw_set_font(fnt_40k_14b);draw_text(mouse_x+22,mouse_y+22,string_hash_to_newline(string(tooltip)));
    draw_set_font(fnt_40k_14);draw_text_ext(mouse_x+22,mouse_y+42,string_hash_to_newline(string(tooltip2)),-1,500);
}


/* */
/*  */
