function scr_turn_first() {
	try{
	// I believe this is ran at the start of the end of the turn.  That would make sense, right?

	var identifiable=0;
	var unload=0;
	var cur_arti;
	for (var i=0;i<array_length(obj_ini.artifact);i++){
		identifiable=0;
		unload=i;
		if (obj_ini.artifact[unload]=="") then continue;
		cur_arti = obj_ini.artifact_struct[unload];
		if (cur_arti.loc()==""){
			var valid_ship = get_valid_player_ship();
			if (valid_ship >-1){
				var _ship = fetch_ship(valid_ship);
				obj_ini.artifact_loc[unload] = _ship.name;
				obj_ini.artifact_sid[unload] = 500+valid_ship;
			}
		}
	    if (cur_arti.identified()>0){
	    	var _identifiable = cur_arti.is_identifiable()
        
	        if (instance_exists(obj_p_fleet)) and (!_identifiable){
	        	var _arti_fleet = find_ships_fleet(cur_arti.ship_id());
	        	if (_arti_fleet!="none"){
	        		if (array_length(_arti_fleet.capital_num)){
	        			_identifiable = true;
	        			cur_arti.set_ship_id(_arti_fleet.capital_num[0]);
	        		}
	        	}
	        }
        
            if (_identifiable) then obj_ini.artifact_identified[unload]-=1;
            if (obj_ini.artifact_identified[unload]=0) then scr_alert("green","artifact","Artifact ("+string(obj_ini.artifact[unload])+") has been identified.",0,0);
	    }
	    _identifiable=false;
	}
	unload=0;


	var host_p,ox,oy,x5,y5,fdir;
	ox=0;oy=0;x5=0;y5=0;fdir=0;

	var peace_check = (turn > 100);
	// peace_check=1;// Testing
	host_p=0;

	if (peace_check>0){
	    var _baddy = 0;
	    var _total = 0;
	    with(obj_star){
	        if (owner>5){
	            _baddy = 0;
	            o = 0;
	            repeat(planets){
	                o+=1;
	                if (p_orks[o]+p_tyranids[o]+p_chaos[o]+p_traitors[o]+p_necrons[o]>=3) then _baddy+=1;
	            }
	            if (_baddy>0) {
	                _total++;
	            }
	        }
	    }
	    if (_total<=3){
	        peace_check=2;
	    }	
	    if (peace_check==2){	
	        if (turn>=150) and (faction_defeated[10]=0) and (known[eFACTION.Chaos]=0) and (faction_gender[10]=2){
	        // if (turn>=100000) and (faction_defeated[10]=0) and (known[eFACTION.Chaos]=0){faction_gender[10]=2;
	            spawn_chaos_warlord();
	    
	        } else {
	        	out_of_system_warboss();
	        }	    	
	    }
	}
	}catch(_exception) {
    	handle_exception(_exception);
	}


}
