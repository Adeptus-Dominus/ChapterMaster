

if (type=99){
    var onceh;onceh=0;
    if (obj_controller.zoomed=0) and (onceh=0){obj_controller.zoomed=1;onceh=1;__view_set( e__VW.Visible, 0, false );__view_set( e__VW.Visible, 1, true );obj_cursor.image_xscale=2;obj_cursor.image_yscale=2;}
    if (obj_controller.zoomed=1) and (onceh=0){obj_controller.zoomed=0;onceh=1;__view_set( e__VW.Visible, 0, true );__view_set( e__VW.Visible, 1, false );obj_cursor.image_xscale=1;obj_cursor.image_yscale=1;}
}


