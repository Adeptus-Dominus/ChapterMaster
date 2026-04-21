exit;

if (other.sprite_index != self.sprite_index) {
    exit;
} // No colonists and fleets bashing together

//if (other.action="") and (action="") and (other.owner=owner) and (string_count("her",trade_goods)=0) and (string_count("her",string(other.trade_goods))=0){
//    if (obj_controller.faction_status[eFACTION.IMPERIUM]="War") and (instance_nearest(x,y,obj_star).owner  = eFACTION.PLAYER) and (owner = eFACTION.IMPERIUM) and (other.owner = eFACTION.IMPERIUM){
//        if (id>other.id){
//            guardsmen+=other.guardsmen;
//            capital_number+=other.capital_number;
//            frigate_number+=other.frigate_number;
//            escort_number+=other.escort_number;
//            with(other){instance_destroy();}
//        }
//    }
//} 
