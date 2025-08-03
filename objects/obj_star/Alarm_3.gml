// Checks if player selects a system/star and then assigns the matching values to obj_controller
if (obj_controller.zoomed==1){
    obj_controller.x=self.x;
    obj_controller.y=self.y;
}
obj_controller.popup=3;// 3: star system
obj_controller.sel_system_x=x;
obj_controller.sel_system_y=y;

selected=1;

var xx=x,yy=y;

obj_controller.selected=self.id;
obj_controller.sel_owner=self.owner;
obj_controller.cooldown=8;
obj_controller.selecting_planet=0;

if (obj_controller.zoomed==1){
    obj_controller.zoomed=0;
    __view_set( e__VW.Visible, 0, true );
    __view_set( e__VW.Visible, 1, false );
    obj_cursor.image_xscale=1;
    obj_cursor.image_yscale=1;
}

// Pass variables to obj_controller.temp[t]=""; here
with(obj_star_select){
    instance_destroy();
}
instance_create(x,y,obj_star_select);
obj_star_select.owner=self.owner;
obj_star_select.target=self.id;

try{
    if (obj_controller.selection_data != false){
        loading = false;
        var _data = obj_controller.selection_data;
        if (!struct_exists(_data, "system")){
            _data.system = id;
        }
        if (_data.system != "none"){
            if (struct_exists(_data, "feature")){
                if (_data.feature != " none"){
                    if (is_struct(_data.feature)){
                        if (struct_exists(_data.feature, "f_type")){
                            if (_data.feature.f_type != "none"){
                                obj_star_select.feature = new FeatureSelected(_data.feature,_data.system, _data.planet);
                            }
                        }
                    }
                }
            }
            if (struct_exists(_data, planet)){
                obj_controller.selecting_planet = _data.planet;
                if (obj_controller.selecting_planet >0 && obj_controller.selecting_planet<5){
                    obj_star_select.garrison = new GarrisonForce(p_operatives[obj_controller.selecting_planet]);       
                }                
            }
            obj_controller.selection_data=false;
        }
    }
    obj_controller.selection_data = false;
} catch(_exception){
    handle_exception(_exception);
    obj_controller.selection_data = false;
}