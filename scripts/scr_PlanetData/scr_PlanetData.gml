// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function PlanetData(planet, system) constructor{
	self.planet = planet;
	self.system = system;
	player_disposition = system.dispo[planet];
	planet_type = system.p_type[planet];
    operatives = system.p_operatives[planet];
    features =system.p_feature[planet];
    current_owner = system.p_owner[planet];
    origional_owner = system.p_first[planet];
    population = system.p_population[planet];
    max_population = system.p_max_population[planet];
    large_population = system.p_large[planet];
    secondary_population = system.p_pop[planet];
    guardsmen = system.p_guardsmen[planet];
    pdf = system.p_pdf[planet];
    fortification_level  = system.p_fortified[planet];
    star_station = system.p_station[planet];
    pdf_loss_reduction = 0;

    // Whether or not player forces are on the planet
    player_forces = system.p_player[planet];
    defence_lasers = system.p_lasers[planet];
    defence_silos = system.p_silo[planet];
    ground_defences = system.p_defenses[planet];
    upgrades = system.p_upgrades[planet];
    // v how much of a problem they are from 1-5
    planet_forces = array_create(14, 0);

    try{
    	planet_forces[1] = player_forces;

	    planet_forces[2] =	guardsmen;

	    planet_forces[5] =	system.p_sisters[planet];
	    planet_forces[6] =	system.p_eldar[planet];
	    planet_forces[7] =	system.p_orks[planet];
	    planet_forces[8] =	system.p_tau[planet];
	    planet_forces[9] =	system.p_tyranids[planet];
		planet_forces[10] =	system.p_traitors[planet];   	
	    planet_forces[11] =	system.p_chaos[planet]+ system.p_demons[planet];

	    planet_forces[13] =	system.p_necrons[planet];
	}catch(_exception){
		handle_exception(_exception);
	}

    deamons = system.p_demons[planet];
    chaos_forces = system.p_chaos[planet];

    requests_help = system.p_halp[planet];

    // current planet heresy
    corruption = system.p_heresy[planet];

    is_heretic = system.p_hurssy[planet];

    heretic_timer = system.p_hurssy_time[planet];

    secret_corruption = system.p_heresy_secret[planet];

    population_influences = system.p_influence[planet];

    raided_this_turn = system.p_raided[planet];
    // 
    governor = system.p_governor[planet];

    problems = system.p_problem[planet];
    problem_data = system.p_problem_other_data[planet];
    problem_timers = system.p_timer[planet];

    static name = function(){
    	var _name="";
    	with (system){
    		_name =  planet_numeral_name(planet);
    	}
    	return _name;
    }

    static xenos_and_heretics = function(){
    	var xh_force = 0;
    	for (var i=5;i<array_length(planet_forces); i++){
    		xh_force += planet_forces[i];
    	} 
    	return xh_force;
    }
    
    static marine_training = planet_training_sequence;

    static has_feature = function(feature){
    	return planet_feature_bool(features, feature);
    }

    static get_features = function(request_feature){
    	var _array_positions = search_planet_features(features,request_feature);
    	var _select_features = [];
  		for (var i=0;i<array_length(_array_positions);i++){
  			array_push(_select_features, features[_array_positions[i]]);
  		}
  		return _select_features;
    }
    static planet_training = function(local_screening_points){
    	var _training_happend = false;
	    if (has_feature(P_features.Recruiting_World)){
	        if (obj_controller.gene_seed == 0) and (obj_controller.recruiting > 0) {

                obj_controller.recruiting = 0;
                obj_controller.income_recruiting = 0;
                scr_alert("red", "recruiting", "The Chapter has run out of gene-seed!", 0, 0);

	        }else if (obj_controller.recruiting > 0){
	        	if (local_screening_points>0){

	           		marine_training(local_screening_points);

	           		_training_happend = true;
	        	} else {
	        		scr_alert("red", "recruiting", $"Recruitment on {name()} halted due to insufficient apothecary rescources", 0, 0);
	        	}
	        }
		}
		return _training_happend;   	
    }

    static recover_starship = function(techs){
    	try {
			var engineer_count = array_length(techs);
			if (has_feature(P_features.Starship) && engineer_count>0){
				//TODO allow total tech point usage here
		        var _starship = get_features(P_features.Starship)[0];

		        var _engineer_score_start = _starship.engineer_score;
		    	if (_starship.engineer_score<2000){
		        	for (var v=0;v<engineer_count;v++){
		        		_starship.engineer_score += (techs[v].technology/2);
		        	}
		        	scr_alert("green","owner",$"Ancient ship repairs {min((_starship.engineer_score/2000)*100, 100)}% complete",system.x,system.y);
		    	}

		        var _target_spend=10000;

		        var _maxr=floor(obj_controller.requisition/50);
		        var _requisition_spend=min(_maxr*50,array_length(techs)*50,_target_spend-_starship.funds_spent);
		        obj_controller.requisition-=_requisition_spend;
		        _starship.funds_spent+=_requisition_spend;
		    
		        if (_requisition_spend>0 && _starship.funds_spent<_target_spend){
		            scr_alert("green","owner",$"{_requisition_spend} Requision spent on Ancient Ship repairs in materials and outfitting (outfitting {(_starship.funds_spent/_target_spend)*100}%)",system.x,system.y);
		        }
		        if (_starship.funds_spent>=_target_spend && _starship.engineer_score>=2000){// u2=tar;
		        	//TODO refactor into general new ship logic
		            delete_features(features,P_features.Starship);
		        
		            var locy=$"{name()}";
		        
		            var flit=instance_create(system.x,system.y,obj_p_fleet);
		      
		        	var _slaughter = new_player_ship("Gloriana", system.name, "Slaughtersong");
		        	add_ship_to_fleet(_slaughter, flit);
		            flit.oribiting = system.id;
		        
		            scr_popup($"Ancient Ship Restored",$"The ancient ship within the ruins of {locy} has been fully repaired.  It is determined to be a Gloriana Class vessel and is bristling with golden age weaponry and armour.  Your {string(obj_ini.role[100][16])}s are excited; the Slaughtersong is ready for it's maiden voyage, at your command.","","");                
		        }
		    }    	
	    }catch (_exception){
			handle_exception(_exception);
		}
	} 

	static guard_score_calc = function(){
		guard_score = 0;
        if (guardsmen < 500 && guardsmen>0) {
		    guard_score = 0.1;
		} else if (guardsmen >= 100000000) {
		    guard_score = 7;
		} else if (guardsmen >= 50000000) {
		    guard_score = 6;
		} else if (guardsmen >= 15000000) {
		    guard_score = 5;
		} else if (guardsmen >= 6000000) {
		    guard_score = 4;
		} else if (guardsmen >= 1000000) {
		    guard_score = 3;
		} else if (guardsmen >= 100000) {
		    guard_score = 2;
		} else if (guardsmen >= 2000) {
		    guard_score = 1;
		} else {
		    guard_score = 0.5;
		}

		return guard_score;
	}

	static continue_to_planet_battle = function(stop){

	    var _nids_real = planet_forces[eFACTION.Tyranids];
	    var _nids_score = _nids_real < 4 ? 0 : _nids_real;
	    var _nid_diff = _nids_score-_nids_real;

	    if (chaos_forces==6.1) and (_nids_real>0) then tyranids_score=_nids_real;

	    if (current_owner == eFACTION.Tau){
 			stop = (xenos_and_heretics() + _nid_diff + player_forces + planet_forces[eFACTION.Ecclesiarchy]) <= 0;
	    }
	   	
	   	if (stop){
	   		if (planet_forces[eFACTION.Ork]>0) and (planet_forces[eFACTION.Ecclesiarchy]>0) then stop=0;
	   	}

	    var imperium_forces = ((guardsmen>0) or (pdf>0) or (planet_forces[eFACTION.Ecclesiarchy]>0));

	    if (stop){
	    	if (planet_forces[eFACTION.Necrons]>=5 || planet_forces[eFACTION.Tyranids]>=5 && imperium_forces) then stop=0;
	    }


	    //tau fight imperial
	    if (stop){
	    	if (current_owner = eFACTION.Tau){
				if ((guardsmen>0) or (planet_forces[eFACTION.Ecclesiarchy]>0)) and ((pdf>0) or (planet_forces[eFACTION.Tau]>0)) then stop=0;
	    	}
	    	
	    }
    
	    // Attack heretics whenever possible, even player controlled ones
	    if (stop){
	    	if (player_forces+pdf>0) and (guardsmen>0) and (obj_controller.faction_status[2]="War") then stop=0;
	    }
	    if (stop){
	    	if (player_forces+pdf>0) and (planet_forces[eFACTION.Ecclesiarchy]>0) and (obj_controller.faction_status[5]="War") then stop=0;
	    }

	    return stop;
	}

	static pdf_will_support_player = function(){
		if (current_owner== eFACTION.Tau){
			return false;
		}
		if (has_feature(P_features.Gene_Stealer_Cult) && current_owner==eFACTION.Tyranids){
			return false;
		}

		if ((current_owner=1 || obj_controller.faction_status[2]!="War") && pdf){
			return true;
		}
		return false;
	}

	static guard_attack_matrix = function(){
		var guard_attack = "";
	    // if (p_eldar[planet]>0) and (p_owner[planet]!=6) then guard_attack="eldar";
	    //if (planet_forces[eFACTION.Tau] + planet_forces[eFACTION.Ork] + planet_forces[eFACTION.Heretics]+ planet_forces[eFACTION.Chaos])
	    if (planet_forces[eFACTION.Tau]>0) then guard_attack="tau";
	    if (planet_forces[eFACTION.Ork]>0) then guard_attack="ork";
	    if (planet_forces[eFACTION.Heretics]>0){
	    		    // Always goes after traitors first, unless
	    	guard_attack="traitors";
			if (planet_forces[eFACTION.Heretics]<=1 && planet_forces[eFACTION.Tau]>=4) and (current_owner!=8) then guard_attack="tau";	    	
	    }
	    if (planet_forces[eFACTION.Chaos]>0) then guard_attack="csm";
	    if (pdf>0) and (current_owner=eFACTION.Tau) then guard_attack="pdf";

	    if (current_owner = eFACTION.Player){
	    	if (pdf>0 && obj_controller.faction_status[2]=="War") then guard_attack="pdf";
	    }
	    if (planet_forces[eFACTION.Tyranids]<=1) and (planet_forces[eFACTION.Ork]>=4) then guard_attack="ork";
	    // if (p_tyranids[planet]>0) and (guard_attack="") then guard_attack="tyranids";
	    if (planet_forces[eFACTION.Tyranids]>=4){
	    	guard_attack="tyranids";
	    }else if (planet_forces[eFACTION.Tyranids]<4 && planet_forces[eFACTION.Tyranids]>0){
			 if (has_feature(P_features.Gene_Stealer_Cult)){
	 			var _hidden_cult = get_features(P_features.Gene_Stealer_Cult)[0].hiding;
	 			if (!_hidden_cult){
	 				guard_attack="tyranids";
	 			}
	 		}
	    }	

	    return guard_attack;		
	}


	static pdf_attack_matrix = function(){
		var _no_notable_traitors = planet_forces[eFACTION.Heretics]<=1;
		var _pdf_attack = "";
		if (planet_forces[eFACTION.Tyranids]>=4 && !has_feature(P_features.Gene_Stealer_Cult)){
			_pdf_attack = "tyranids";
		}

		if (_no_notable_traitors &&  _pdf_attack=="") {
			if ((planet_forces[eFACTION.Ork]>=4)){
				_pdf_attack="ork";
			} else if (planet_forces[eFACTION.Tau]>=4 && current_owner!=8){
				_pdf_attack="tau";
			}
		} 
		if (guardsmen && _pdf_attack==""){
			if (obj_controller.faction_status[2]=="War"){
				if (pdf_will_support_player()){
					_pdf_attack="guard";
				}
			} else if (current_owner == eFACTION.Tau){
				_pdf_attack="guard";
			}
		}

		if (_pdf_attack==""){
			if (planet_forces[eFACTION.Chaos]>0){
				_pdf_attack="csm";
			} else if (planet_forces[eFACTION.Heretics]>0){
				_pdf_attack="traitors";
			} else if ((planet_forces[eFACTION.Ork]>0)){
				_pdf_attack="ork";
			} else  if (planet_forces[eFACTION.Tau]>0) and (current_owner!=eFACTION.Tau){
				_pdf_attack="tau";
			}
		}
        // Always goes after traitors first, unless
        return _pdf_attack;				
	}

	static pdf_loss_reduction_calc = function(){
		pdf_loss_reduction = fortification_level*0.001;
		if (pdf_will_support_player()){
			pdf_loss_reduction+=garrison.viable_garrison*0.0005;
		}
		return pdf_loss_reduction;
	}

	static pdf_defence_loss_to_orks = function(){
		var active_garrison = pdf_will_support_player() && garrison.viable_garrison>0;
        if (planet_forces[eFACTION.Ork]>=4) and (pdf>=30000){
        	pdf=floor(pdf*(min(0.95, 0.55+pdf_loss_reduction)));
    	}
        else if (planet_forces[eFACTION.Ork]>=4 && pdf<30000 && pdf>=10000){
        	pdf=active_garrison?pdf*0.4:0;
        }
        else if (planet_forces[eFACTION.Ork]>=3) and (pdf<10000){
        	pdf=active_garrison?pdf*0.4:0;
        }
        else if (planet_forces[eFACTION.Ork]<3 && pdf>30000){
        	pdf=floor(pdf*(min(0.95, 0.7+pdf_loss_reduction)));
        }
        if (planet_forces[eFACTION.Ork]>=2) and (pdf<2000){ pdf=0;}
        if (planet_forces[eFACTION.Ork]>=1) and (pdf<200){ pdf=0;}

        system.p_pdf[planet] = pdf;
	}

}