function create_boarding_craft(target_ship){
    var first=0,o=1;
    
    for (var o=0;o<array_length(board_id);o++){
        if (first=0) and (board_id[o]!=0) and (board_location[o]=0) then first=o;
    }
    
    board_cooldown=45;
    
    var bear=instance_create(x,y,obj_p_assra);
    bear.apothecary=0;
    o=first;
    
     for (var o=0;o<array_length(board_id);o++){
        if (board_id[o]!=0) and (board_location[o]==0){
            board_raft[o]=bear;
            board_location[o]=-1;
            boarders-=1;
            bear.boarders+=1;
            unit = fetch_unit([board_co[o] , board_id[o]]);
            if (unit.IsSpecialist("apoth")){
                if (unit.gear()=="Narthecium") and (unit.hp()>=10) then bear.apothecary+=1;
            }
        }
        if (bear.boarders>=20){
            break;
        }
    }
    
    bear.apothecary_had=bear.apothecary;
    
    bear.target=target_ship;
    bear.direction=direction;
    bear.origin=self.id;
    bear.speed=4;
    bear.firstest=first;
    
    if (boarders<=0) then obj_cursor.board=0;
}