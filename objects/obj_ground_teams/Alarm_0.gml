if (feature.f_type == P_features.AncientRuins){
	newline = "Your marines warily stalk through into the entrance of the ruins";
	newline_color = "red";
	scr_newtext();
	if (feature.ruins_race ==0){
		feature.determine_race();
           newline="Your marines descended into the ancient ruins, mapping them out as they go.  They quickly determine the ruins were once ";
            if (feature.ruins_race=1) then newline+="a Space Marine fortification from earlier times.";
            if (feature.ruins_race=2) then newline+="golden-age Imperial ruins, lost to time.";
            if (feature.ruins_race=5) then newline+="a magnificent temple of the Imperial Cult.";
            if (feature.ruins_race=6) then newline+="Eldar colonization structures from an unknown time.";
            if (feature.ruins_race=10) then newline+="golden-age Imperial ruins, since decorated with spikes and bones."; 
			scr_newtext();
	}else{			
		newline = "The ruins seem much unchange from the last exploration records"
		scr_newtext();
	}
	
	var pathway = choose(1,2,3);
	if (pathway >0 ){
		newline = "After exploring for many the exploration team reach a large chamber branching into three halways one of which is sealed by a thick blast door"
		scr_newtext();
	}
	
}






