
if (hp<maxhp) and (ship_id!=0){
    obj_fleet.ships_damaged+=1;
    obj_ini.ship_hp[self.ship_id]=hp;
    
    if (hp<=0) then obj_fleet.ship_lost[ship_id]=1;
    
    if (ship_id=1) and (obj_ini.fleet_type = ePlayerBase.home_world) and (obj_ini.ship_class[1]="Battle Barge"){
    
        if (obj_controller.und_gene_vaults=0){
            obj_controller.gene_seed=0;var w;w=0;repeat(120){w+=1;if (obj_ini.slave_batch_num[w]>0){obj_ini.slave_batch_num[w]=0;obj_ini.slave_batch_eta[w]=0;}}
        }
        if (obj_controller.und_gene_vaults>0){
            obj_controller.gene_seed-=floor(obj_controller.gene_seed/10);
        }
    }
    
    // 135
    // maybe check for dead marines here?
}

