// Assigns the income to the player system based on its neighbours
if (instance_exists(obj_temp1)){
    var tempy=0,tempy_d=9999,biggy=0;

    tempy=instance_nearest(x,y,obj_temp1);
    tempy_d=point_distance(x,y,tempy.x,tempy.y);
    
    // Nearby star system
    if (tempy_d>10) and (tempy_d<=180){
        for(var i=1; i<=planets; i++){
            if (p_type[i]=="Forge") and (p_owner[i]==3) then obj_controller.income_forge+=6;
            if (p_type[i]=="Agri") and (p_owner[i]==2) then obj_controller.income_agri+=3;
        }
    }
    biggy=instance_nearest(obj_temp1.x,obj_temp1.y,obj_star);
    var connected = determine_warp_join(biggy, self.id);
    if (biggy.owner==eFACTION.Player) and (tempy_d>180) and (connected){
        for(var i=1; i<=planets; i++){
            if (p_type[i]=="Forge") and (p_owner[i]==3) then obj_controller.income_forge+=6;
            if (p_type[i]=="Agri") and (p_owner[i]==2) then obj_controller.income_agri+=3;
        }
    }
}
