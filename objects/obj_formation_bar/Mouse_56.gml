

var mah_target;mah_target=0;
/*if (dragging=true) and (nobar=true) then mah_target=col_target;
if (dragging=true) and (nobar=false) then mah_target=nearest_col;*/


mah_target=col_target;


if (dragging=true) and (instance_exists(mah_target)){
    if (mah_target.col_parent=col_parent){
        obj_controller.click=1;obj_controller.cooldown=20;x=old_x;y=old_y;
        rel_mousex=0;rel_mousey=0;old_x=0;old_y=0;col_target=0;nearest_col=0;nobar=false;
        obj_cursor.dragging=0;obj_cursor.image_index=0;dragging=false;exit;
    }
}

if (dragging=true) and (instance_exists(mah_target)){
    if (x>=mah_target.x-5) and (x<=mah_target.x+42) and (mouse_y>=__view_get( e__VW.YView, 0 )+222) and (mouse_y<=__view_get( e__VW.YView, 0 )+688){
        var himcol,te;himcol=mah_target.col_parent;te=0;
        te=4800+himcol;nexti=false;
        
        if (obj_controller.temp[te]+size<=10){
            obj_controller.temp[4800+col_parent]-=size;
            obj_controller.click=1;obj_controller.cooldown=20;
            if (unit_id=1) then obj_controller.bat_comm_for[obj_controller.formating]=mah_target.col_parent;
            if (unit_id=2) then obj_controller.bat_hono_for[obj_controller.formating]=mah_target.col_parent;
            if (unit_id=3) then obj_controller.bat_libr_for[obj_controller.formating]=mah_target.col_parent;
            if (unit_id=4) then obj_controller.bat_tech_for[obj_controller.formating]=mah_target.col_parent;
            if (unit_id=5) then obj_controller.bat_term_for[obj_controller.formating]=mah_target.col_parent;
            if (unit_id=6) then obj_controller.bat_vete_for[obj_controller.formating]=mah_target.col_parent;
            if (unit_id=7) then obj_controller.bat_tact_for[obj_controller.formating]=mah_target.col_parent;
            if (unit_id=8) then obj_controller.bat_deva_for[obj_controller.formating]=mah_target.col_parent;
            if (unit_id=9) then obj_controller.bat_assa_for[obj_controller.formating]=mah_target.col_parent;
            if (unit_id=10) then obj_controller.bat_scou_for[obj_controller.formating]=mah_target.col_parent;
            if (unit_id=11) then obj_controller.bat_drea_for[obj_controller.formating]=mah_target.col_parent;
            if (unit_id=12) then obj_controller.bat_hire_for[obj_controller.formating]=mah_target.col_parent;
            if (unit_id=13) then obj_controller.bat_rhin_for[obj_controller.formating]=mah_target.col_parent;
            if (unit_id=14) then obj_controller.bat_pred_for[obj_controller.formating]=mah_target.col_parent;
            if (unit_id=15) then obj_controller.bat_land_for[obj_controller.formating]=mah_target.col_parent;
            obj_cursor.dragging=0;obj_cursor.image_index=0;
            
            // show_message("-> slot "+string(mah_target.col_parent)+", now "+string(obj_controller.temp[te]+size)+"/10 full, old slot is "+string(obj_controller.temp[4800+col_parent])+"/10");
            
            with(obj_temp8){instance_destroy();}
            with(obj_controller){scr_ui_formation_bars();}
            exit;
        }
        if (obj_controller.temp[te]+size>10){
            dragging=false;x=old_x;y=old_y;obj_controller.cooldown=20;obj_cursor.dragging=0;obj_cursor.image_index=0;
            if (obj_controller.master_volume>0) and (obj_controller.effect_volume>0){audio_play_sound(snd_error,-80,0);audio_sound_gain(snd_error,1*obj_controller.master_volume*obj_controller.effect_volume,0);}
        }
    }
    if (instance_exists(mah_target)){
        if (x<mah_target.x-5) or (x>mah_target.x+42) or (mouse_y<__view_get( e__VW.YView, 0 )+222) or (mouse_y>__view_get( e__VW.YView, 0 )+688){
            dragging=false;x=old_x;y=old_y;obj_controller.cooldown=20;obj_cursor.dragging=0;obj_cursor.image_index=0;
            if (obj_controller.master_volume>0) and (obj_controller.effect_volume>0){audio_play_sound(snd_error,-80,0);audio_sound_gain(snd_error,1*obj_controller.master_volume*obj_controller.effect_volume,0);}
        }
    }
}


/* */
/*  */
