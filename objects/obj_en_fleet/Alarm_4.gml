
try_and_report_loop("fleet alarm 4", function(){
if (action!=""){
    var sys, sys_dist, mine, connected, fleet, cont;
    sys_dist=9999;connected=0;cont=0;
    
    fleet=instance_id_get( 0 );
    sys=instance_nearest(action_x,action_y,obj_star);
    sys_dist=point_distance(action_x,action_y,sys.x,sys.y);
    act_dist=point_distance(x,y,sys.x,sys.y);
    mine=instance_nearest(x,y,obj_star);
    if (mine.x=sys.x2) and (mine.y=sys.y2) then connected=1;
    
    var eta;eta=0;
    eta=floor(point_distance(x,y,action_x,action_y)/action_spd)+1;
    if (connected=0) then eta=eta*2;
    if (connected=1) then connected=1;
    
    if (owner=eFACTION.Inquisition) and (action_eta<2) then action_eta=2;
    // action_x=sys.x;
    // action_y=sys.y;
    action="move";
    
    if (owner != eFACTION.Eldar) and (mine.storm>0) then action_eta+=10000;
    
    x=x+lengthdir_x(24,point_direction(x,y,sys.x,sys.y));
    y=y+lengthdir_y(24,point_direction(x,y,sys.x,sys.y));
}






if (action==""){
    var sys, sys_dist, mine, connected, fleet, cont, target_dist;
    sys_dist=9999;connected=0;cont=0;target_dist=0;
    
    fleet=id;
    sys=instance_nearest(action_x,action_y,obj_star);
    sys_dist=point_distance(action_x,action_y,sys.x,sys.y);
    if (scr_valid_fleet_target(target)){
        target_dist=point_distance(x,y,target.action_x,target.action_y);
    } else {
        target=0;
    }
    
    act_dist=point_distance(x,y,sys.x,sys.y);
    mine=instance_nearest(x,y,obj_star);
    
    // if (owner = eFACTION.Tau) then mine.tau_fleets-=1;
    // if (owner = eFACTION.Tau) and (image_index!=1) then mine.tau_fleets-=1;
    // mine.present_fleets-=1;

    connected = determine_warp_join(mine, sys);
    cont=1;
    
    
    if (cont=1){
        cont=20;
    }
    
    if (cont=20){// Move the entire fleet, don't worry about the other crap
        turns_static = 0;
        var eta=0;
        
        if (trade_goods!="") and (owner != eFACTION.Tyranids) and (owner != eFACTION.Chaos) and (string_count("Inqis",trade_goods)=0) and (string_count("merge",trade_goods)=0)and (string_count("_her",trade_goods)=0) and (trade_goods!="cancel_inspection") and (trade_goods!="return"){
            if (scr_valid_fleet_target(target)){
                if (target.action!=""){
                    if (target_dist>sys_dist){
                        action_x=target.action_x;
                        action_y=target.action_y;
                        sys=instance_nearest(action_x,action_y,obj_star);
                    }
                }
            } else {
                target = 0;
            }
        }
        
        eta=floor(point_distance(x,y,action_x,action_y)/action_spd)+1;
        if (connected=0) then eta=eta*2;
        if (connected=1) then connected=1;
        
        if (action_eta<=0) or (owner  != eFACTION.Inquisition){
            action_eta=eta;
            if (owner  = eFACTION.Inquisition) and (action_eta<2) and (string_count("_her",trade_goods)=0) then action_eta=2;
        }
        
        if (owner != eFACTION.Eldar) and (mine.storm>0) then action_eta+=10000;
        
        // action_x=sys.x;
        // action_y=sys.y;
        action="move";
        
        if (minimum_eta>action_eta) and (minimum_eta>0) then action_eta=minimum_eta;
        minimum_eta=0;
        if (etah>action_eta) and (etah!=0) then action_eta=etah;
        
        x=x+lengthdir_x(24,point_direction(x,y,sys.x,sys.y));
        y=y+lengthdir_y(24,point_direction(x,y,sys.x,sys.y));
    }
}

etah=0;

});

