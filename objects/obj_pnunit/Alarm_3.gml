try {
    
    if (obj_ncombat.started=0){
        if (men+dreads+veh<=0){
            //show_debug_message($"column destroyed {x}")
            instance_destroy();
        }
        // if (veh+dreads>0) then instance_destroy();
        obj_ncombat.player_forces+=self.men+self.veh+self.dreads;
        obj_ncombat.player_max+=self.men+self.veh+self.dreads;
        
        
        //TODO centralise a method for moving units between columns
        /*if (men<=4) and (veh=0) and (dreads=0){// Squish leftt
            var leftt=instance_nearest(x-12,y,obj_pnunit);
            
        
        }*/
        
    }
    
    if (obj_ncombat.red_thirst>=2) and (obj_ncombat.battle_over=0){
        if (men>0){
            var raar=0,miss="",r_lost=0;
            
            for (var raar; raar < (men + dreads); raar++) {
                r_roll=floor(random(1000))+1;
                if (obj_ncombat.player_forces<(obj_ncombat.player_max*0.75)) then r_roll-=8;
                if (obj_ncombat.player_forces<(obj_ncombat.player_max/2)) then r_roll-=10;
                if (obj_ncombat.player_forces<(obj_ncombat.player_max/4)) then r_roll-=24;
                if (obj_ncombat.player_forces<(obj_ncombat.player_max/7)) then r_roll-=104;
                if (obj_ncombat.player_forces<(obj_ncombat.player_max/10)) then r_roll-=350;
                
                
                if (marine_dead[raar]=0) and (marine_type[raar]!="Death Company") and (marine_type[raar]!="Chapter Master") and (r_roll<=4){
                    r_lost+=1;
                    marine_type[raar]="Death Company";
                    //marine_attack[raar]+=1;
                    marine_defense[raar]=0.75;
                    //marine_ranged[raar]=0.75;
                    obj_ncombat.red_thirst+=1;
                    if (r_lost=1) then miss+="Battle Brother "+string(obj_ini.name[marine_co[raar],marine_id[raar]])+", ";
                    if (r_lost>1) then miss+=string(obj_ini.name[marine_co[raar],marine_id[raar]])+", ";
                }
            }
            if (r_lost>1) then string_replace(miss,"Battle Brother","Battle Brothers");
            
            
            var woo=string_length(miss);
            miss=string_delete(miss,woo-1,2);// remove last
            
            if (string_count(", ",miss)=1){
                /*var woo;woo=string_rpos(", ",miss);
                miss=string_insert(" and",miss,woo+1);*/
                
                miss=string_replace(miss,", "," and ");
            }
            if (string_count(", ",miss)>1){
                var woo=string_rpos(", ",miss);
                
                miss=string_delete(miss,woo-1,3);
                if (r_lost>=3) then miss=string_insert(", and ",miss,woo-1);
                if (r_lost=2) then miss=string_insert(" and ",miss,woo-1);
            }
            
            
            if (r_lost=1) then miss+=" has been lost to the Red Thirst!";
            if (r_lost>1) then miss+=" have been lost to the Red Thirst!";
            
            if (r_lost>0){
                obj_ncombat.newline=miss;
                obj_ncombat.newline_color="red";
                obj_ncombat.timer_pause=2;
                with(obj_ncombat){
                    scr_newtext();
                }
            }
        }
    }
    
    
    
    if (obj_ncombat.started>=1){
        
        // Should probably have the option under deployment to say 'Should Assault Marines enter the fray with vehicles?'   [ ]
    }
    
    
    // Right here execute some sort of check- if left is open, and engaged, and enemy is only vehicles, and no weapons to hurt them...
    
    if (instance_exists(obj_enunit)){
        if (collision_point(x+10,y,obj_enunit,0,1)) and (!collision_point(x-10,y,obj_pnunit,0,1)){
            var neares=instance_nearest(x+10,y,obj_enunit);
            
            if (neares.men=0) and (neares.veh>0){
                var norun;
                norun=0;
                
                var i;i=0;
                repeat(20){i+=1;
                    if (apa[i]>=30) then norun=1;
                }
                
                
                if (norun=0){
                    x-=10;
                    engaged=0;
                }
            
            }
        }
    }
    
    /* */
    /*  */
    
} catch(_exception) {
    handle_exception(_exception);
}