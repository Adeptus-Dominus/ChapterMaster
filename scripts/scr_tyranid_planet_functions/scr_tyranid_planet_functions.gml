function tyranids_planet_biomass_extraction(){
		// Tyranids here
	var planet=0;
	for (var planet=1;planet<planets;planet++){
	    if (p_tyranids[planet]>=5) and (planets>=planet) and (p_player[planet]+p_orks[planet]+p_guardsmen[planet]+p_pdf[planet]+p_chaos[planet]=0){
	        var ship=scr_orbiting_fleet(eFACTION.Tyranids);
	        if (ship!="none") and (p_type[planet]!="Dead") and (array_length(p_feature[planet])!=0 && ship.capital_number){
	            if (planet_feature_bool(p_feature[planet], P_features.Reclamation_pools) ==1){
	                p_tyranids[planet]=0;
	                if (p_type[planet]="Death") or (p_type[planet]="Hive") then ship.capital_number+=choose(0,1,1);
	                ship.capital_number+=1;
	                ship.escort_number+=3;
	                ship.image_index=floor((ship.capital_number)+(ship.frigate_number/2)+(ship.escort_number/4));
	                p_type[planet]="Dead";
					delete_features(p_feature[planet], P_features.Reclamation_pools);// show_message("D");
					if (is_dead_star()) then image_alpha=0.33;
                
	                // if image_alpha = 0.33 then send the ship somewhere new
                
	            }
	            if (planet_feature_bool(p_feature[planet], P_features.Capillary_Towers)==1) and (p_type[planet]!="Dead"){
	            	p_population[planet]=floor(p_population[planet]*0.3);
	            }
	            if (planet_feature_bool(p_feature[planet], P_features.Capillary_Towers)==1) and (p_type[planet]!="Dead"){
	                p_feature[planet]=[];
					array_push(p_feature[planet], new NewPlanetFeature(P_features.Capillary_Towers), new NewPlanetFeature(P_features.Reclamation_pools));
	                p_population[planet]=0;// show_message("C");
	            }
	            if (planet_feature_bool(p_feature[planet], P_features.Capillary_Towers)==0) and (planet_feature_bool(p_feature[planet], P_features.Reclamation_pools)==0) and (p_type[planet]!="Dead"){
					array_push(p_feature[planet], new NewPlanetFeature(P_features.Capillary_Towers));// show_message("B");
	            }

	        }
	    }
	}
}



function genestealer_cult_end_turn_growth(planet){
	if (planet_feature_bool(p_feature[planet], P_features.Gene_Stealer_Cult)) {
        var cult = return_planet_features(p_feature[planet], P_features.Gene_Stealer_Cult)[0];
        cult.cult_age++;
        adjust_influence(eFACTION.Tyranids, cult.cult_age / 100, planet);
        var planet_garrison = system_garrison[planet - 1];
        if (cult.hiding) {
            var find_cult_chance = irandom(1000) - planet_garrison.total_garrison;
            var alert_text = $"A hidden Genestealer Cult in {name} Has been discovered!";
            if (planet_garrison.garrison_force) {
                var alert_text = $"A hidden Genestealer Cult in {name} Has been discovered by marine garrison!";
                find_cult_chance -= 25;
            }            
            if (p_influence[planet][eFACTION.Tyranids] > 50) {
                var find_cult_chance = irandom(50);
                var alert_text = $"A hidden Genestealer Cult in {name} Has suddenly burst forth from hiding!";
            }
            if (find_cult_chance < 1) {
                cult.hiding = false;
                scr_popup("System Lost", alert_text, "Genestealer Cult", "");
                owner = eFACTION.Tyranids;
                scr_event_log("red", $"A hidden Genestealer Cult in {name} {planet} has Started a revolt.", name);
                p_tyranids[planet] += 1;
            }
		}
        if ((!cult.hiding) && (p_tyranids[planet] <= 3) && (p_type[planet] != "Space Hulk") && (p_influence[planet][eFACTION.Tyranids] > 10)) {
            var spread = 0;
            rando = irandom(150);
            rando -= p_influence[planet][eFACTION.Tyranids];
            if (rando <= 15) {
                spread = 1;
            }

            if ((p_type[planet] == "Lava") && (p_tyranids[planet] == 2)) {
                spread = 0;
            }
            if (((p_type[planet] == "Ice") || (p_type[planet] == "Desert")) && (p_tyranids[planet] == 3)) {
                spread = 0;
            }
	      
            if (spread == 1) {
                p_tyranids[planet] += 1;
            }
        }
        if (p_influence[planet][eFACTION.Tyranids] > 55) {
            p_owner[planet] = eFACTION.Tyranids;
            if (obj_controller.turn > 150){
            	var _cult_influence = p_influence[planet][eFACTION.Tyranids]
            	var _summon_fleet_chance = roll_dice(1,1000);
            	if (p_large[planet]){
            		_summon_fleet_chance-=5;
            		if (_cult_influence>70){
            			var _growth_extra = (_cult_influence-60)/10;
            			_summon_fleet_chance -= (power(2, _growth_extra));
            		}
            		if (_summon_fleet_chance<=1){
            			summon_new_hive_fleet();
            		}
            	}
            }
        }

    } else if (p_influence[planet][eFACTION.Tyranids] > 5) {
        adjust_influence(eFACTION.Tyranids, -1, planet);
        if ((irandom(200) + (p_influence[planet][eFACTION.Tyranids] / 10)) > 195) {
            array_push(p_feature[planet], new NewPlanetFeature(P_features.Gene_Stealer_Cult));
        }
    }	
}