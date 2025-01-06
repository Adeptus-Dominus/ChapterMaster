
if (hp<maxhp) and (ship_id!=0){
    obj_fleet.ships_damaged+=1;
    obj_ini.ship_hp[self.ship_id]=hp;
    
    if (hp<=0) then obj_fleet.ship_lost[ship_id]=1;
    
    if (ship_id=0) and (obj_ini.fleet_type = ePlayerBase.home_world) and (obj_ini.ship_class[0]="Battle Barge"){
    
        if (obj_controller.und_gene_vaults=0){
            gene_seed_count()=0;
            destroy_all_gene_slaves(false);
        }
        if (obj_controller.und_gene_vaults>0){
            remove_gene_seed(floor(gene_seed_count()/10));
        }
    }
    
    // 135
    // maybe check for dead marines here?
}

