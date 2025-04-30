function tyranids_planet_biomass_extraction(){
		// Tyranids here
	var i=0;
	for (var i=1;i<planets;i++){
	    if (p_tyranids[i]>=5) and (planets>=i) and (p_player[i]+p_orks[i]+p_guardsmen[i]+p_pdf[i]+p_chaos[i]=0){
	        var ship=scr_orbiting_fleet(eFACTION.Tyranids);
	        if (ship!="none") and (p_type[i]!="Dead") and (array_length(p_feature[i])!=0 && ship.capital_number){
	            if (planet_feature_bool(p_feature[i], P_features.Reclamation_pools) ==1){
	                p_tyranids[i]=0;
	                if (p_type[i]="Death") or (p_type[i]="Hive") then ship.capital_number+=choose(0,1,1);
	                ship.capital_number+=1;
	                ship.escort_number+=3;
	                ship.image_index=floor((ship.capital_number)+(ship.frigate_number/2)+(ship.escort_number/4));
	                p_type[i]="Dead";
					delete_features(p_feature[i], P_features.Reclamation_pools);// show_message("D");
					if (is_dead_star()) then image_alpha=0.33;
                
	                // if image_alpha = 0.33 then send the ship somewhere new
                
	            }
	            if (planet_feature_bool(p_feature[i], P_features.Capillary_Towers)==1) and (p_type[i]!="Dead"){
	            	p_population[i]=floor(p_population[i]*0.3);
	            }
	            if (planet_feature_bool(p_feature[i], P_features.Capillary_Towers)==1) and (p_type[i]!="Dead"){
	                p_feature[i]=[];
					array_push(p_feature[i], new NewPlanetFeature(P_features.Capillary_Towers), new NewPlanetFeature(P_features.Reclamation_pools));
	                p_population[i]=0;// show_message("C");
	            }
	            if (planet_feature_bool(p_feature[i], P_features.Capillary_Towers)==0) and (planet_feature_bool(p_feature[i], P_features.Reclamation_pools)==0) and (p_type[i]!="Dead"){
					array_push(p_feature[i], new NewPlanetFeature(P_features.Capillary_Towers));// show_message("B");
	            }

	        }
	    }
	}
}