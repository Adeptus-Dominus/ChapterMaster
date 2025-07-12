function threat_plausibility(){
    var _threat = 20;
    var _good_imperium_position = diplomacy[eFACTION.Imperium] > 50 ? 1 : -1;
    var _relative_strength = floor(obj_controller/20);
    var _nature = "";
}

function clear_inspections(){
	with(obj_en_fleet){
	    if (owner  = eFACTION.Inquisition) and (string_count("Inqis",trade_goods)>0){
	        trade_goods="cancel_inspection";
	        target=0;
	    }
	}
}

function inquis_use_inspection_pass(){
   	if (inspection_passes>0){
        inspection_passes-=1;
        last_world_inspection=turn+25;
        last_fleet_inspection=turn+25;
        //obj_controller.liscensing=5;
        clear_inspections();
        diplo_text = "Very well i shall honour our previous agreements. (24 months leave of inspections)";
    }
}

function inquis_demand_inspection_pass(){
    var resistance=10;
    var _worked = false;
    clear_diplo_choices();
    if (inspection_passes==0){
        rull=floor(random(10))+1;
        if (rull>resistance){
            _worked=true;
            last_world_inspection=turn+24;
            last_fleet_inspection=turn+24;
            //obj_controller.liscensing=5;
            clear_inspections();
            diplo_text = "Very well Chapter Master I Your service to the imperium is well known i have no doubt that you would not ask such of me without good reasoon. I shall forgoe my normal duties just this onece. \n do not becomne complacent Chapter Master i may not always be so generous";
        } else {
        	var _diff = resistance - rull;
        	diplomacy[eFACTION.Inquisition] -= 1;
        	diplo_text = "Consider your request denied. If there is heresy or any wrong doing i shal see that is rooted out and made plain for all to see";;

        }
    }

}

function scr_demand(demand_type) {

	// demand_type: button



	var resistance, rull, worked, rela,no_penalty;
	resistance=0;rull=0;worked=false;rela="neutral";no_penalty=false;

	if (disposition[trading_demand]>=60) then rela="friendly";
	if (disposition[trading_demand]<60) and (disposition[trading_demand]>=20) then rela="neutral";
	if (disposition[trading_demand]<20) then rela="hostile";

	annoyed[trading_demand]+=2;

	if (trading_demand=2){// Imperium
	    with(obj_star){
	    	if (owner = eFACTION.Imperium){
	    		instance_create(x,y,obj_temp2);
	    	}
	    }
	    resistance=min(instance_number(obj_temp2),8);
	    with(obj_temp2){instance_destroy();}
	    if (obj_controller.disposition[2]<30) then resistance+=1;
	    if (obj_controller.disposition[2]<10) then resistance+=2;    
	    if (obj_controller.disposition[2]<=-60) then resistance+=100;
	    if (rela="hostile") or (faction_status[eFACTION.Imperium]="Antagonism") then resistance+=2;
	    if (faction_status[eFACTION.Imperium]="War") then resistance+=3;

	    if (demand_type=1){// Requisition
	        rull=floor(random(10))+1;
	        if (rull>resistance){
	        	requisition+=300;
	        	worked=true;
	        }
	        else if (rull<=resistance){
	        	worked=false;
	        }
	    }
	    if (demand_type=2){// Crusade
	        rull=floor(random(10))+1;
	        if (rull>resistance){
	        	obj_controller.liscensing=2;
	        	worked=true;
	        }
	        if (rull<=resistance){
	        	worked=false;
	        }
	    }
    
	}


	if (trading_demand=3) or (trading_demand=5){// Mechanicus/Ecclesiarchy
	    resistance=8;

	    if (obj_controller.disposition[diplomacy]<30) then resistance+=1;
	    if (obj_controller.disposition[diplomacy]<10) then resistance+=2;    
	    if (obj_controller.disposition[diplomacy]<=-60) then resistance+=100;
	    if (faction_status[diplomacy]="War") then resistance+=3;
	    if (rela="friendly") then resistance-=2;
    
	    if (demand_type=1){// Requisition
	        rull=floor(random(10))+1;
	        if (rull>resistance){requisition+=300;worked=true;}
	        if (rull<=resistance){worked=false;}
	    }
    
	}


	if (trading_demand=4){
	    resistance=10;
    
	    if (demand_type=1){// Requisition
	        rull=floor(random(10))+1;
	        if (rull>resistance){
	        	requisition+=300;
	        	worked=true;
	        }
	        if (rull<=resistance){
	        	worked=false;
	        }
	    }
	}







	if (trading_demand=6){// Elfdar
	    // 135 ; testing resistance=10;
    
	    resistance=2;

	    if (rela="neutral") then resistance-=1;
	    if (rela="friendly") then resistance-=3;
	    if (demand_type=2) then resistance-=2;
    
	    if (obj_controller.faction_status[eFACTION.Eldar]="War") or (obj_controller.faction_status[eFACTION.Eldar]="Antagonism"){
	        with(obj_star){if (owner = eFACTION.Eldar) and (craftworld=1) then instance_create(x,y,obj_temp5);}
	        with(obj_p_fleet){if (point_distance(x,y,obj_temp5.x,obj_temp5.y)<37) and (action="") then instance_create(x,y,obj_ground_mission);}
	        with(obj_en_fleet){if (point_distance(x,y,obj_temp5.x,obj_temp5.y)<37) and (action="") and (owner = eFACTION.Eldar) then instance_create(x,y,obj_temp3);}
        
	        with(obj_temp5){instance_destroy();}
	        if (instance_number(obj_ground_mission)>1) and (instance_number(obj_temp3)=0) then resistance-=5;
	        with(obj_ground_mission){instance_destroy();}
	        with(obj_temp3){instance_destroy();}
	    }
    
	    if (demand_type=1){// Requisition
	        rull=floor(random(10))+1;
	        if (rull>resistance){
	        	requisition+=150;
	        	worked=true;
	        }
	        if (rull<=resistance){worked=false;}
	    }
	    if (demand_type=2){// useful info
	        rull=floor(random(10))+1;
	        if (rull>resistance){worked=true;}
	        if (rull<=resistance){worked=false;}
	    }
	}










	if (trading_demand=7){// Orks orks orks orks
	    resistance=10;

	    if (rela="neutral") then resistance-=2;
	    if (rela="friendly") then resistance-=2;
	    if (demand_type=2) then resistance-=2;
    
	    if (demand_type=1){// Requisition
	        rull=floor(random(10))+1;
	        if (rull>resistance){requisition+=200;worked=true;}
	        if (rull<=resistance){worked=false;}
	    }
	    if (demand_type=2){// Crusade
	        rull=floor(random(10))+1;
	        if (rull>resistance){obj_controller.liscensing=2;worked=true;if (disposition[7]>=40) then no_penalty=true;}
	        if (rull<=resistance){worked=false;}
	    }
	}




	if (trading_demand=8){
	    with(obj_star){if (owner = eFACTION.Tau) then instance_create(x,y,obj_temp2);}
	    resistance=min(instance_number(obj_temp2)*2,8)+4;
	    with(obj_temp2){instance_destroy();}
	    if (rela="friendly") then resistance-=3;
	    if (rela="neutral") then resistance-=1;
	    if (faction_status[eFACTION.Tau]="War") then resistance+=3;
    
	    // If only one planet, and player is at it, should probably get a bonus
    
	    if (demand_type=1){// Requisition
	        rull=floor(random(10))+1;
	        if (rull>resistance){requisition+=300;worked=true;}
	        if (rull<=resistance){worked=false;}
	    }
	    if (demand_type=2){
	        rull=floor(random(10))+1;
        
        
	        with(obj_en_fleet){if (owner != eFACTION.Tau) then instance_deactivate_object(id);}
	        if (instance_exists(obj_p_fleet)) then with (obj_p_fleet){
	            var ns;ns=instance_nearest(x,y,obj_en_fleet);
	            if (point_distance(x,y,ns.x,ns.y)<=50) and (action="") and (image_index>3) then instance_create(x,y,obj_temp1);
	            instance_deactivate_object(id);
	        }
        
	        with(obj_star){
	            if (owner = eFACTION.Tau) and (instance_exists(obj_p_fleet)){
	                var mahr;mahr=instance_nearest(x,y,obj_p_fleet);
	                if (point_distance(x,y,mahr.x,mahr.y)<50) and (mahr.action="") then instance_create(x,y,obj_temp1);
	            }
	        }
	        // show_message("Roll+"+string(instance_number(obj_temp1)*2)+" from player fleet shenanigans");
	        rull+=instance_number(obj_temp1)*2;
	        with(obj_temp1){instance_destroy();}
	        instance_activate_object(obj_en_fleet);
	        instance_activate_object(obj_p_fleet);
	        instance_activate_object(obj_star);
        
        
	        if (rull>resistance){
	            worked=true;
	            with(obj_en_fleet){if (owner = eFACTION.Tau) and (instance_nearest(x,y,obj_star).owner = eFACTION.Tau) and (action="") then instance_deactivate_object(id);}
	            with(obj_star){if (owner != eFACTION.Tau) then instance_deactivate_object(id);}
	            with(obj_en_fleet){
	                if (owner = eFACTION.Tau){
	                    action_x=instance_nearest(x,y,obj_star).x;
	                    action_y=instance_nearest(x,y,obj_star).y;
	                    alarm[4]=1;
	                }
	            }
	            instance_activate_object(obj_star);
	            instance_activate_object(obj_en_fleet);
	        }
	        if (rull<=resistance){worked=false;}
	    }
	}


	// show_message("Roll (Need greater): "+string(rull)+"Resistance: "+string(resistance));




	if (worked=true){
	    clear_diplo_choices();
	    if (!no_penalty){
		    if (rela="friendly") {
		    	disposition[trading_demand]-=8;
		    	turns_ignored[trading_demand]+=3;
		    	if (trading_demand=8){
		    		disposition[trading_demand]+=6;
		    	}
		    }
		    if (rela="neutral") {
		    	disposition[trading_demand]-=10;
		    	turns_ignored[trading_demand]+=6;
		    	if (trading_demand=8){
		    		disposition[trading_demand]+=6;
		    	}
		    }
		    if (rela="hostile") {
		    	disposition[trading_demand]-=15;
		    	turns_ignored[trading_demand]+=9;
		    	if (trading_demand=8){
		    		disposition[trading_demand]+=9;
		    	}
		    }
		    if (disposition[trading_demand]<-100){
		    	disposition[trading_demand]=-100;
		    }
		}
    
	    
    
	    if (trading_demand=6) and (demand_type=2){
	        if (no_penalty=false) then disposition[trading_demand]+=7;
	        force_goodbye=1;trading_demand=0;scr_dialogue("useful_information");
	        exit;
	    }
    
	    trading_demand=0;
	    if (liscensing=0) then scr_dialogue("agree");
	    if (liscensing>0) then scr_dialogue("agree_lisc");
	    force_goodbye=1;
	}
	if (worked=false){
	    var h=0;
	    clear_diplo_choices();
	    if (rela="friendly") and (no_penalty=false){
	    	disposition[trading_demand]-=2;
	    	turns_ignored[trading_demand]+=1;
	    }
	    if (rela="neutral") and (no_penalty=false){
	    	disposition[trading_demand]-=4;
	    	turns_ignored[trading_demand]+=3;
	    }
	    if (rela="hostile") and (no_penalty=false){
	    	disposition[trading_demand]-=8;turns_ignored[trading_demand]+=6;}
	    if (disposition[trading_demand]<-100) then disposition[trading_demand]=-100;
	    trading_demand=0;force_goodbye=1;
    
    
	    var war,woo;war=false;woo=floor(random(100))+1;
	    if (no_penalty=false){
	        if (disposition[diplomacy]<=10) and (faction_status[diplomacy]="Antagonism") and (woo<=35) then war=true;
	        if (diplomacy=8) and (demand_type=2) and (war=true) then war=false;
	    }
    
	    if (war=false) then scr_dialogue("demand_refused");
	    if (war=true){faction_status[diplomacy]="War";scr_dialogue("declare_war");}
	}



	cooldown=10;

	// show_message(resistance);


}
