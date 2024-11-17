
if (other.owner=self.owner){
    if !((action_x=other.action_x) and (action_y=other.action_y)) then exit;


    if ((trade_goods!="") && (other.trade_goods!="") && !fleet_has_cargo("colonize") && !fleet_has_cargo("colonize", other)){


        if (action_x=other.action_x) and (action_y=other.action_y) and (!(fleet_has_cargo("ork_warboss"))) and ( !(fleet_has_cargo("ork_warboss", other))){


            if (string_count("!",trade_goods)>0) and (string_count("!",other.trade_goods)>0){
                if (id>other.id){
                    trade_goods+=other.trade_goods;
                    with(other){
                        instance_destroy();
                    }
                }
            }
        }
    }
}


