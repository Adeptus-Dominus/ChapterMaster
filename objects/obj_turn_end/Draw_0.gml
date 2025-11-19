
draw_set_font(fnt_small);
draw_set_halign(fa_left);
draw_set_color(255);


if (obj_controller.force_scroll=1) then exit;


if (combating>0) then exit;
if (obj_controller.audience>0) then exit;

if (show=0) and (obj_controller.zoomed=0) and (current_popup=0) then draw_sprite(spr_loading,image_index,__view_get( e__VW.XView, 0 )+23,__view_get( e__VW.YView, 0 )+73);
if (show=0) and (obj_controller.zoomed=1) and (current_popup=0) then draw_sprite_ext(spr_loading,image_index,40,40,2,2,0,c_white,1);


if (show>0 && current_battle<=battles){
  
}
