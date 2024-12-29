
draw_set_alpha(1);if (options<=1) then draw_set_alpha(0.5);
draw_set_color(c_gray);
draw_rectangle(x,y,x+width,y+height,0);
draw_set_font(fnt_40k_14);
draw_set_color(c_black);
draw_set_halign(fa_center);
draw_text(x+(width/2),y+2,string_hash_to_newline(string(option[option_selected])));


tooltip="";
tooltip2="";


if (scr_hit(x,y,x+width,y+height)=true) and (obj_controller.dropdown_open=0){
    if (options>1){
        draw_set_alpha(0.2);
        draw_set_color(c_white);
        draw_rectangle(x,y,x+width,y+height,0);
    }
    
    if (obj_controller.mouse_left=1) and (obj_controller.cooldown<=0) and (opened=0) and (options>1){
        obj_controller.cooldown=10;opened=1;obj_controller.dropdown_open=1;
    }
    draw_set_alpha(1);
    
    if (option_selected>0){
        if (option[option_selected]!=""){
            tooltip=option[option_selected];
            if (target="event_display") and (option[option_selected]!="None"){
                tooltip=option[option_selected];
                tooltip2=obj_ini.artifact_struct[option_id[option_selected]].description();
            }
            if (target="event_display") and (option[option_selected]="None"){
                tooltip="Display";
                tooltip2="There is no Artifact set to be displayed at the event.";
            }
        }
    }
}



if (opened=1){
    var ii,y5,yyy,hi;
    ii=0;yyy=24;y5=y;hi=24;
    
    repeat(options){ii+=1;
        if (ii!=option_selected) and (ii<=options){
            y5+=hi;yyy+=hi;
            
            draw_set_alpha(1);
            draw_set_color(c_gray);
            draw_rectangle(x,y5,x+width,y5+hi,0);
            draw_set_font(fnt_40k_14);
            draw_set_color(c_black);
            draw_set_halign(fa_center);
            draw_text(x+(width/2),y5+2,string_hash_to_newline(string(option[ii])));
            draw_rectangle(x,y5,x+width,y5+hi,1);
            
            if (scr_hit(x,y5,x+width,y5+hi)=true){
                draw_set_alpha(0.2);draw_set_color(c_white);
                draw_rectangle(x,y5,x+width,y5+hi,0);
                
                tooltip=option[ii];
                if (target="event_display") and (option[ii]!="None"){tooltip=option[ii];tooltip2=obj_ini.artifact_struct[option_id[ii]].description();}
                if (target="event_display") and (option[ii]="None"){tooltip="Display";tooltip2="There is no Artifact set to be displayed at the event.";}
                
                if (obj_controller.mouse_left=1) and (obj_controller.cooldown<=0){
                    obj_controller.cooldown=10;
                    obj_controller.dropdown_open=0;
                    opened=0;
                    
                    var no;no=false;
                    if (target="event_type") and (option[ii]!="Great Feast") then no=true;
                    if (no=false) then option_selected=ii;
                    
                    if (target="event_type") and (option[ii]="Great Feast"){
                        obj_controller.fest_type=option[ii];
                        with(obj_dropdown_sel){if (target="event_public") then option[1]="";obj_controller.fest_locals=0;}
                        with(obj_dropdown_sel){if (target="event_repeat") then option[1]="";obj_controller.fest_repeats=1;}
                        with(obj_dropdown_sel){if (target="event_honor") then option[1]="";obj_controller.fest_honor=0;}
                        
                        if (obj_controller.fest_type="Triumphal March"){
                            obj_controller.fest_planet=1;obj_controller.fest_sid=0;obj_controller.fest_wid=0;
                            with(obj_dropdown_sel){if (target="event_loc"){option[1]="";option_selected=1;}}
                        }
                        
                        with(obj_controller){
                            fest_cost=0;fest_lav=0;fest_locals=0;
                            fest_feature1=1;fest_feature2=0;fest_feature3=0;
                            fest_display=0;fest_repeats=1;
                        }
                    }
                    if (target="event_display"){
                        obj_controller.fest_display=option_id[option_selected];
                    }
                    if (target="event_public"){
                        obj_controller.fest_locals=ii-1;
                    }
                    if (target="event_loc"){
                        if (obj_controller.fest_planet=0){
                            obj_controller.fest_sid=option_id[ii];
                            obj_controller.fest_wid=0;
                            if (option_id[ii]>0){
                                if (obj_controller.fest_warp=0) and (obj_ini.ship_location[option_id[ii]]="Warp") then obj_controller.fest_warp=1;
                                if (obj_controller.fest_warp=1) and (obj_ini.ship_location[option_id[ii]]!="Warp") then obj_controller.fest_warp=0;
                                obj_controller.fest_attend=scr_event_dudes(0,0,"",option_id[ii]);
                            }
                            if (option[ii]="None Selected"){obj_controller.fest_sid=0;obj_controller.fest_attend="";}
                        }
                        if (obj_controller.fest_planet=1){
                            obj_controller.fest_wid=option_id[ii];obj_controller.fest_sid=0;obj_controller.fest_star=option_star[ii];
                            if (option[ii]!="None Selected") then obj_controller.fest_attend=scr_event_dudes(0,1,option_star[ii],option_id[ii]);
                            if (option[ii]="None Selected"){obj_controller.fest_wid=0;obj_controller.fest_star="";obj_controller.fest_attend="";}
                        }
                    }
                    if (target="event_lavish"){
                        obj_controller.fest_lav=ii;
                    }
                    if (target="event_repeat"){
                        if (ii<=4) then obj_controller.fest_repeats=ii;
                        if (ii=5) then obj_controller.fest_repeats=12;
                    }
                    
                    
                    
                    
                }
                draw_set_alpha(1);
            }
        }
    }
    
    if (obj_controller.mouse_left=1) and (obj_controller.cooldown<=0) and (scr_hit(x,y,x+width,y5+yyy)=false){opened=0;obj_controller.dropdown_open=0;}
}

if (tooltip="Great Feast") then tooltip2="Holds a massive feast and celebration for your astartes.";
if (tooltip!="Great Feast") and (target="event_type") then tooltip2="(NOT COMPLETED YET)";

/*
if (tooltip="Tournament") then tooltip2="Hosts a non-lethal tournament for friendly competition.";
if (tooltip="Deathmatch") then tooltip2="Pits all those present to fight until one remains standing.  HQ are unable to participate.";
if (tooltip="Imperial Mass") then tooltip2="Hosts Imperial Cult Mass for your astartes, in praise of the Emperor.";
if (tooltip="Chapter Sermon") then tooltip2="Hosts a Chapter Cult sermon for your astartes, praising the "+string(global.chapter_name)+".";
if (tooltip="Chapter Relic") then tooltip2="Instructs your "+string(obj_ini.role[100][16])+"s and "+string(obj_ini.role[100][14])+"s to construct a Chapter artifact.";
if (tooltip="Triumphal March") then tooltip2="Present Astartes will participate in a massive march to present a show of arms and power.";
*/

if (tooltip!="") and (tooltip2!=""){
    draw_set_alpha(1);
    draw_set_font(fnt_40k_14);draw_set_halign(fa_left);draw_set_color(0);
    draw_rectangle(mouse_x+18,mouse_y+20,mouse_x+string_width_ext(string_hash_to_newline(tooltip2),-1,500)+24,mouse_y+44+string_height_ext(string_hash_to_newline(tooltip2),-1,500),0);
    draw_set_color(c_gray);
    draw_rectangle(mouse_x+18,mouse_y+20,mouse_x+string_width_ext(string_hash_to_newline(tooltip2),-1,500)+24,mouse_y+44+string_height_ext(string_hash_to_newline(tooltip2),-1,500),1);
    draw_set_font(fnt_40k_14b);draw_text(mouse_x+22,mouse_y+22,string_hash_to_newline(string(tooltip)));
    draw_set_font(fnt_40k_14);draw_text_ext(mouse_x+22,mouse_y+42,string_hash_to_newline(string(tooltip2)),-1,500);
}



/* */
/*  */
