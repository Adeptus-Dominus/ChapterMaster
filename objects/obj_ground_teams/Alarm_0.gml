if (feature.f_type == P_features.Ancient_Ruins){
	var _newline = "Your marines warily stalk through into the entrance of the ruins";
	obj_ncombat.queue_battlelog_message(_newline, COL_YELLOW);
	if (feature.ruins_race ==0){
		feature.determine_race();
           var _newline = "Your marines descended into the ancient ruins, mapping them out as they go.  They quickly determine the ruins were once ";
            if (feature.ruins_race=1) then _newline+="a Space Marine fortification from earlier times.";
            if (feature.ruins_race=2) then _newline+="golden-age Imperial ruins, lost to time.";
            if (feature.ruins_race=5) then _newline+="a magnificent temple of the Imperial Cult.";
            if (feature.ruins_race=6) then _newline+="Eldar colonization structures from an unknown time.";
            if (feature.ruins_race=10) then _newline+="golden-age Imperial ruins, since decorated with spikes and bones."; 
			obj_ncombat.queue_battlelog_message(_newline, COL_YELLOW);
	}else{			
		_newline = "The ruins seem much unchange from the last exploration records"
		obj_ncombat.queue_battlelog_message(_newline, COL_YELLOW);
	}
	
	var pathway = choose(1,2,3);
	if (pathway >0 ){
		_newline = "After exploring for many the exploration team reach a large chamber branching into three halways one of which is sealed by a thick blast door"
		obj_ncombat.queue_battlelog_message(_newline, COL_YELLOW);
	}
	
}






