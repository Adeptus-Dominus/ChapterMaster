/// @mixin obj_star
function scr_star_ownership(argument0) {



	var run=0;
	var ork_owner, tau_owner, player_owner, imperium_owner, eldar_owner, traitors_owner, forge_owner, tyranids_owner, necrons_owner, nun_owner;
	ork_owner=0;tau_owner=0;player_owner=0;eldar_owner=0;traitors_owner=0;forge_owner=0;imperium_owner=0;tyranids_owner=0;necrons_owner=0;nun_owner=0;

	repeat(planets){
		run+=1;
    	if (p_owner[run]=eFACTION.Player){
    		if (dispo[run]<95 && !planet_feature_bool(p_feature[run], P_features.Monastery)){
    			p_owner[run]=eFACTION.Imperium;
    		}
    	}
    	var _set_to_first = false;	
	    if (p_owner[run]==7 && p_orks[run]<=0){
	    	_set_to_first = true;
	    }
	    if (_set_to_first){
	    	var _first = p_first[run];
	    	if (p_first[run] == eFACTION.Ork && p_orks[run] <= 0){
	    		p_owner[run]=2;
	    	} else {
	    		p_owner[run]=p_first[run];
	    	}
	    }
	    if (p_type[run]=="Dead") and (p_owner[run]!=eFACTION.Imperium) and (p_first[run]!=eFACTION.Player) and (p_first[run]!=eFACTION.Ecclesiarchy){
	    	p_owner[run]=eFACTION.Imperium;
	    }
	    if (p_owner[run]=eFACTION.Tau) and (p_tau[run]=0) and (p_pdf[run]=0){
	    	p_owner[run]=eFACTION.Imperium;
	    	p_influence[run][eFACTION.Tau]=round(p_influence[run][eFACTION.Tau]/2);
	    }
	    if (p_owner[run]=10) and (p_chaos[run]=0) and (p_traitors[run]=0) and (p_population[run]<=0){
	    	p_owner[run]=p_first[run];
	    	p_heresy[run]=0;
	    	if (p_owner[run]=10) then p_owner[run]=2;}
	    if (p_type[run]="Daemon") then p_owner[run]=10;

	    var _nid_chosen = false;
    	if (planet_feature_bool(p_feature[run], P_features.Gene_Stealer_Cult)){
    		if (p_influence[run][eFACTION.Tyranids]>50){
    			p_owner[run]=9;
    			tyranids_owner+=1;
    			_nid_chosen = true;
    		}
    	} else if (p_tyranids[run]>=5) and (p_population[run]=0){
	    	p_owner[run]=9;
	    	tyranids_owner+=1;
	    	_nid_chosen = true;
	    }
	    if (p_type[run]!="Dead" && !_nid_chosen){
		    if (p_owner[run]=eFACTION.Player) then player_owner+=1;
		    if (p_owner[run]=eFACTION.Imperium)  then imperium_owner+=1;
		    if (p_owner[run]=eFACTION.Mechanicus)  then forge_owner+=1;
		    if (p_owner[run]=5)  then nun_owner+=1;
		    // if (p_orks[run]>0) and (p_type[run]!="Dead") then ork_owner+=1;
		    if (p_owner[run]=6) and (p_type[run]=="Craftworld") then eldar_owner=999;
		    if (p_owner[run]=7)  then ork_owner+=1;
		    if (p_owner[run]=8)  then tau_owner+=1;
		    if (p_owner[run]=10)  then traitors_owner+=1;
		    if (p_owner[run]=11)  then traitors_owner+=1;
		    if (p_owner[run]=13)  then necrons_owner+=1;
		}
    
    
	    if (argument0!=false){
	        if (array_length(p_feature[run]) != 0){
	            if (planet_feature_bool(p_feature[run], P_features.Daemonic_Incursion)==1){
	            	p_heresy[run]+=2;
	                if (p_large[run]=0) and (p_population[run]>10000) then p_population[run]=floor(p_population[run]*0.5);
	                if (p_large[run]=1) then p_population[run]=p_population[run]*0.7;
	            }
	        }
	        if (p_tyranids[run]>4){
	            if (p_large[run]=0) then p_population[run]=floor(p_population[run]*0.1);
	            if (p_large[run]=0) and (p_population[run]<=400000) then p_population[run]=0;
	            if (p_large[run]=1) then p_population[run]=p_population[run]*0.1;
	        }
	        if (array_length(p_feature[run])!=0){
	            if (p_type[run]!="Dead") and (planet_feature_bool(p_feature[run], P_features.Daemonic_Incursion)==1) and (p_heresy[run]>=100){
	                var randoo=choose(1,2,3,4);
	                if (randoo=4){
	                    p_type[run]="Daemon";
	                    p_fortified[run]=6;
	                    p_traitors[run]=7;
	                    p_owner[run]=10;
	                    delete_features(p_feature[run],P_features.Daemonic_Incursion);
	                }
	            }
	        }
        
	    }
	}


	// if (player_owner>0) and (player_owner>=imperium_owner) and (player_owner>=forge_owner) and (player_owner>=necrons_owner) and (player_owner>=ork_owner) and (player_owner>=tau_owner) and (player_owner>=traitors_owner){owner  = eFACTION.Player;}

	if (necrons_owner>0){
		owner = eFACTION.Necrons;
	} else 	if (player_owner>0) and (player_owner>=necrons_owner) and (player_owner>=ork_owner) and (player_owner>=tau_owner) and (player_owner>=traitors_owner){
		owner  = eFACTION.Player;
	} else 	if (nun_owner>0) and (nun_owner>=forge_owner) and (nun_owner>=tau_owner) and (nun_owner>=necrons_owner) and (nun_owner>=traitors_owner) and (nun_owner>=ork_owner) and (nun_owner>=imperium_owner) and (player_owner=0){
		owner = eFACTION.Ecclesiarchy;
	} else if (tyranids_owner>0){
		owner = eFACTION.Tyranids;
	} else if (eldar_owner>0){
		owner = eFACTION.Eldar;
	} else if (forge_owner>0){
		owner = eFACTION.Mechanicus;
	} else if (traitors_owner=planets){
		owner = eFACTION.Chaos;
	} else if (traitors_owner>imperium_owner) and (traitors_owner>forge_owner) and (traitors_owner>necrons_owner) and (traitors_owner>player_owner) and (traitors_owner>tau_owner) and (traitors_owner>ork_owner){
		owner = eFACTION.Chaos;
	} else if (tau_owner>imperium_owner) and (tau_owner>forge_owner) and (tau_owner>ork_owner) and (tau_owner>necrons_owner) and (tau_owner>player_owner) and (tau_owner>traitors_owner){
		owner = eFACTION.Tau
	} else if (ork_owner>imperium_owner) && (ork_owner>forge_owner) && (ork_owner>player_owner) and (ork_owner>tau_owner) and (ork_owner>traitors_owner) and (ork_owner>necrons_owner){
		owner = eFACTION.Ork;
	} else 	if (imperium_owner>0) and (imperium_owner>=forge_owner) and (imperium_owner>=tau_owner) and (imperium_owner>=necrons_owner) and (imperium_owner>=traitors_owner) and (imperium_owner>=ork_owner) and (player_owner=0){
		owner = eFACTION.Imperium;
	}

}
