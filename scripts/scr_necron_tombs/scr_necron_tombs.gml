
function awaken_tomb_event(){
	log_message("RE: Necron Tomb Awakens");
	var stars = scr_get_stars();
	
	var valid_stars = array_filter_ext(stars, 
		function(star, index){
			var tomb_world = scr_get_planet_with_feature(star,P_features.Necron_Tomb);
			
			if (tomb_world == -1) then return false;
			else {
				return awake_tomb_world(star.p_feature[tomb_world]) == 0;
			}
		});

	if(valid_stars == 0){
		log_message("RE: Necron Tomb Awakens, couldn't find a sleeping necron tomb");
		return false;
	}
	
	var star_index = irandom(valid_stars-1);
	var star = stars[star_index];
	var planet = -1;
	for(var i = 1; i <= star.planets; i++) {
		if (awake_tomb_world(star.p_feature[i])==0){
			awaken_tomb_world(star.p_feature[i]);
			planet = i;
			break;
		}
	}
	
	if(planet == -1) {
		log_message("RE: Necron Tomb Awakens, couldn't find a sleeping necron tomb planet");
		return false;
	}
	
    var text=string(star.name) + string(scr_roman(planet));
    scr_event_log("red","The Necron Tomb on "+string(text)+" has surged into activity.");
    scr_popup("Necron Awakening","The Necron Tomb on "+string(text)+" has surged into activity.  Rank upon rank of the abominations are pouring out from their tunnels.","necron_tomb","");
    var star_alert=instance_create(star.x+16,star.y-24,obj_star_event);
	star_alert.image_alpha=1;
	star_alert.image_speed=1;
	star_alert.col="red"; 
    star.p_pdf[planet]=0;
	star.p_necrons[planet]=6;
	
    if (star.p_guardsmen[planet]<2000000) {
		star.p_guardsmen[planet]=0;
	}
	if (star.p_guardsmen[planet]>=2000000) {
		star.p_guardsmen[planet]=round(star.p_guardsmen[planet]/2);
	}
	return true;
}