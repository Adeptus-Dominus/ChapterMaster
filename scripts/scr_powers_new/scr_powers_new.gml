function scr_powers_new(){

	// company: Company
	// marine_number: Marine ID

	// This script checks if the marine is capable of using psychic powers, and if so, assigns them based on experience

	var random_learn;
	random_learn=false;

	var letmax, powers_should_have, powers_have;
	var power_code="";letmax=0;
	var _powers_learned = 0;

	if (obj_ini.psy_powers="default"){power_code="D";letmax=7;}
	if (obj_ini.psy_powers="biomancy"){power_code="B";letmax=5;}
	if (obj_ini.psy_powers="pyromancy"){power_code="P";letmax=5;}
	if (obj_ini.psy_powers="telekinesis"){power_code="T";letmax=5;}
	if (obj_ini.psy_powers="rune Magick") or (obj_ini.psy_powers="Rune Magick"){power_code="R";letmax=5;}


	// higer psionice means more powers learnt
	powers_should_have=floor((experience-30)/(45-psionic))+1;// +1 for the primary
	powers_have=string_count(string(power_code),specials());




	if (powers_have<powers_should_have) and (powers_have<(letmax)+1) and (random_learn=true){
	    var newpow;newpow=0;
	    if (powers_have<powers_should_have) and (powers_have<(letmax)+1){
		    if (powers_have<powers_should_have) and (powers_have<(letmax)+1){
		        var tha=floor(random(letmax))+1;
		        if (string_count(string(tha),specials())=0){
		            powers_have+=1;
					_powers_learned++;
		            obj_ini.spe[company,marine_number]+=string(power_code)+string(tha)+"|";
		        }
		    }
		}
	}


	if (powers_have<powers_should_have) and (powers_have<(letmax)+1) and (random_learn=false){
	    // Used to work like this.  I removed it because I was too lazy to have powers chance to be cast be based on experience.
	    // Should you wish to have powers be randomly learned simply change random_learn to true and write the rest of the code.
    
	    var newpow=0;
	    var reps = 0;
	    while(powers_have<powers_should_have && reps<(letmax)+1){
	    	reps++;
	        var tha=powers_have;
	        if (string_count(string(tha),specials())==0){
	        	powers_have++;
				_powers_learned++;
	            obj_ini.spe[company,marine_number]+=string(power_code)+string(tha)+"|";
	        }
	    }
	}

	return _powers_learned;
}
