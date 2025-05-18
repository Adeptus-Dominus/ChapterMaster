// Checks which systems you can see the planets
if (!instance_exists(obj_saveload) && !instance_exists(obj_drop_select) && !instance_exists(obj_bomb_select) && !global.ui_click_lock) {
        var m_dist=point_distance(x,y,mouse_x,mouse_y);
        var allow_click_distance = 20*scale;

        if (obj_controller.location_viewer.is_entered) then exit;
        // if ((obj_controller.zoomed==0) and (mouse_y <__view_get( e__VW.YView, 0 )+62)) or (obj_controller.menu!=0) then exit;
        // if ((obj_controller.zoomed==0) and (mouse_y>__view_get( e__VW.YView, 0 )+830)) or (obj_controller.menu!=0) then exit;
        if (p_type[1]=="Craftworld") and (obj_controller.known[eFACTION.Eldar]==0) then exit;
        if (vision==0) then exit;
        if (!scr_void_click()) then exit;

        if ((obj_controller.zoomed==0) and (m_dist<allow_click_distance)) or ((obj_controller.zoomed==1) and (m_dist<60)) and (obj_controller.cooldown<=0){
            // This should prevent overlap with fleet object
            if (obj_controller.zoomed==1){
                obj_controller.x=self.x;
                obj_controller.y=self.y;
            }
            alarm[3]=1;
        }
}
