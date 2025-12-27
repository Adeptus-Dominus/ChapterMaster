

///@mixin obj_star
function tau_broadcast_propaganda_to_planet(){
	var tau_influence;	            	
    var tau_influence_chance=roll_dice(1,100,"high");
    var tau_influence_planet=irandom(orbiting.planets)+1;	            	
    if (p_type[tau_influence_planet]!="Dead"){
    
        scr_alert("green","owner",$"Tau ship broadcasts subversive messages to {planet_numeral_name(tau_influence_planet)}.",sta.x,sta.y);
        tau_influence = p_influence[tau_influence_planet][eFACTION.Tau]
    
        if (tau_influence_chance<=70) and (tau_influence<70){
        	adjust_influence[tau_influence_planet](eFACTION.Tau, 10, tau_influence_planet);
            if (p_type[tau_influence_planet]=="Forge"){
            	adjust_influence(eFACTION.Tau, -5, tau_influence_planet);
            }
        }
        
        if (tau_influence_chance<=3) and (tau_influence<70){
            adjust_influence(eFACTION.Tau, 30, tau_influence_planet);
            if (p_type[tau_influence_planet]=="Forge"){
            	adjust_influence(eFACTION.Tau, -25, tau_influence_planet);
            }
        }
    }	
}