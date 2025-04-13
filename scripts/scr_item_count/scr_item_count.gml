function scr_item_count(item_type, quality="any") {

	// This script checks the equipment variables for the named item and returns the combined quantity

	var von=0;
	for (var i=0;i<array_length(obj_ini.equipment);i++){
	   if (obj_ini.equipment[i]==item_type){
	   		/*in theory we should be able to break here but there seems
	   		to be the implication that an equipment item can be in the 
	   		equipemnt list more than once so will have to leave till I can
	   		find where stuff is added
	   		*/

	   		if (quality=="any"){
	   			von+=obj_ini.equipment_number[i];
	   		} else {
	   			for (var q=0;q<array_length(obj_ini.equipment_quality[i]);q++){
	   				if (obj_ini.equipment_quality[i][q] == quality) then von++;
	   			}
	   		}
	   }
	}
	return(von);


}
