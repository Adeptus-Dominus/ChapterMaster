// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information



function FeatureSelected(Feature, system, planet) constructor{
	feature = Feature;
	main_slate = new DataSlateMKTwo();
	exit_sequence = false;
	entrance_sequence=true;
	remove=false;
	destroy=false;
	exit_count = 0;
	enter_count=18;
	planet_data = new PlanetData(planet,system);

	if (feature.f_type == P_features.Forge){
		var worker_caps= [2,4,8];
		worker_capacity = worker_caps[feature.size-1];	
		techs = collect_role_group("forge", obj_star_select.target.name);
		feature.techs_working = 0;
		for (var i=0;i<array_length(techs);i++){
			if (techs[i].assignment()=="forge" && techs[i].job.planet == obj_controller.selecting_planet){
				feature.techs_working++;
				if (feature.techs_working==worker_capacity) then break;
			}
		}
	}

	draw_planet_features = function(xx,yy){
		if (!struct_exists(self,"planet_data")){
			planet_data = new PlanetData(obj_controller.selecting_planet,obj_controller.selected.id);
		} else if (!is_struct(planet_data)){
			planet_data = new PlanetData(obj_controller.selecting_planet,obj_controller.selected.id);
		}
	    draw_set_halign(fa_center);
	    draw_set_font(fnt_40k_14);
	    //draw_sprite(spr_planet_screen,0,xx,yy);
	    if (exit_sequence){
	    	xx-=(25*exit_count);
	    	main_slate.draw(xx,yy, 1.38,1.38);
	    	exit_count++;
	    	if (xx-25<=obj_star_select.main_data_slate.XX) then remove=true;
	    } else if (entrance_sequence){
	    	enter_count--;
	    	xx-=(25*enter_count);
	    	if (enter_count==1) then entrance_sequence = false;
	    	main_slate.draw(xx,yy, 1.38,1.38);
	    }else {
	    	main_slate.draw(xx,yy, 1.4,1.4);
	    }
	    var area_width = main_slate.width;
	    var area_height = main_slate.height;
	    var generic = false;
	    var title="", body="";
	    //draw_glow_dot(xx+150, yy+150);
	    //rack_and_pinion(xx+230, yy+170);
	    var rectangle = [];
	    draw_set_color(c_green);
	    if (point_and_click(draw_unit_buttons([xx+12, yy+20], "<---",[1,1],c_red))){
	    	exit_sequence=true;
	    };
	    draw_set_halign(fa_center);
		switch (feature.f_type){
			case P_features.Forge:
				draw_text_transformed(xx+(area_width/2), yy +10, "Chapter Forge", 2, 2, 0);
				draw_set_halign(fa_left);
				draw_set_color(c_gray);

				draw_text(xx+10, yy+50, $"Working Techs : {feature.techs_working}/{worker_capacity}");
				if (point_and_click(draw_unit_buttons([xx+10, yy+70], "Assign To Forge",[1,1],c_red))){
					obj_controller.unit_profile = false;
					obj_controller.view_squad = false;
					group_selection(techs,{
						purpose:"Forge Assignment",
						purpose_code : "forge_assignment",
						number:worker_capacity,
						system:obj_controller.selected.id,
						feature:obj_star_select.feature,
						planet : obj_controller.selecting_planet,
						selections : []
					});
					destroy=true;

				}
				//TODO move over to using the draw button object ot streamline this
				var next_position = [xx+10, yy+95];
				if (feature.size<3){
					var upgrade_cost = 2000 * feature.size;
					var last_button = draw_unit_buttons(next_position, $"Upgrade Forge ({upgrade_cost} req)",[1,1],c_red);
					next_position = [last_button[0], last_button[3]];
					if (point_and_click(last_button) && obj_controller.requisition>=upgrade_cost){
						obj_controller.requisition -=  upgrade_cost;
						feature.size++;
						worker_capacity*=2;
					}
				}
				if (feature.size>1 && !feature.vehicle_hanger){
					var upgrade_cost = 3000;
					var build_coords = draw_unit_buttons(next_position, $"Build Vehicle Hanger({upgrade_cost} req)",[1,1],c_red);
					if (scr_hit(build_coords)){
						tooltip_draw("Required to Build Vehicles in the Forge")
					}
					if (point_and_click(build_coords) && obj_controller.requisition>=upgrade_cost){
						feature.vehicle_hanger=1;
						obj_controller.requisition -=  upgrade_cost;
						array_push(obj_controller.player_forge_data.vehicle_hanger,[obj_controller.selected.name,obj_controller.selecting_planet]);
					}					
				} else if(feature.vehicle_hanger){
					draw_text(next_position[0], next_position[1], "Forge has a vehicle hanger")
					//TODO somthing if the forge has a hanger
				}		
				break;
			case P_features.Necron_Tomb:

				generic=true;
				if (feature.awake==0 && feature.sealed==0){
					title = "Dormant Necron Tomb";
					body = "Scans indicate a Necron Tomb lies hidden under the surface of the planet, all signs indicate the tombis dormant as we must hope it remains";
				} else if (feature.sealed){
					title = "Sealed Necron Tomb";
					body = "Exterminatus and standard imperial armaments are no proof against the Necron Scourge with any luck those sealed within this tomb will remain there";
				} else if (feature.awake){
					title = "Awake Tomb";
					body = "The Cursed ranks of living metal spew forth from the Necron tomb below"
				}
				break;
			case P_features.Artifact:
				generic=true;
				title = "Unknown Artifact";
				body = "Unload Marines onto the planet to search for the artifact";
				break;	
			case P_features.Ancient_Ruins:
				generic=true;
				title = "Ancinet Ruins";
				body = "Unload Marines onto the planet to explore the ruins";
				break;
			case P_features.STC_Fragment:
				generic=true;
				title = "STC Fragment";
				body = $"Unload a {obj_ini.role[100][16]} and whatever entourage you deem necessary to recover the STC Fragment";
				break;
			case P_features.Gene_Stealer_Cult:
				generic=true;
				var cult_control = planet_data.population_influences[eFACTION.Tyranids];
				title = $"Cult of {feature.name}";
				var control_string = "";
				if (cult_control<25){
					control_string = "currently has limited influence on the planet but is fast gaining speed";
				} else if (cult_control<50){
					control_string = "Is rapidly gaining momentum with the planets populace and will soon sieze control of the planet if left unchecked";
				}else if (cult_control<75){
					control_string = "Has managed to galvanise the populace to overcome the former governor of the planet turning much of the local pdf to it's cause, it must be stopped, lest it spread.";
				} else {
					control_string = "The Cults rot and control of the planet is complete even if the cult can be dismantled the rot is great and the population will need significant purging and monitering to remove the taint";
				}
				body = $"The Cult of {feature.name} {control_string}";
				break;				
			case P_features.Victory_Shrine:
				draw_text_transformed(xx+(area_width/2), yy +10, "Victory Shrine", 2, 2, 0);
				draw_set_halign(fa_left);
				draw_set_color(c_gray);				
				/*if (!feature.parade){
					if (point_and_click(draw_unit_buttons([xx+10, yy+70], "Parade (500 req)",[1,1],c_red))){
						obj_controller.requisition-=500;
						feature.forge=1;
						feature.forge_data = new PlayerForge();
					}
				}*/
				break;																	
			case P_features.Monastery:
				draw_text_transformed(xx+(area_width/2), yy +10, feature.name, 2, 2, 0);
				if (feature.forge==0){
					draw_text_transformed(xx+80, yy +50, "Forge", 1, 1, 0);
					if (draw_building_builder(xx+40, yy+70,500,spr_forge_holo)){
						obj_controller.requisition-=500;
						feature.forge=1;
						feature.forge_data = new PlayerForge();
					};
				}
				break;
			case P_features.Mission:
				var mission_description=$"";
				var planet_name = planet_numeral_name(obj_controller.selecting_planet, obj_star_select.target);
				var button_text="none";
				var button_function="none";
				var help = "none";
				switch(feature.problem){
					case "provide_garrison":
						var reason;
						if (feature.reason == "importance"){

						}
						mission_description=$"The governor of {planet_name} has requested a force of marines might stay behind following your departure.\n\n\n assign a squad to garrison to initiate mission, The garrison leeader will need to be capable of conducting himself in a diplomatic manor in order for the garrison duration to be a success";

						break;
					case "join_communion":
						mission_description=$"The governor of {planet_name} has Invited a delegate of your forces to take part in ceremony.";
						break;
					case "hunt_beast":
						mission_description=$"The governor of {planet_name} has bemoaned the raiding of huge beasts on the fringes of the planets largest city, the numbers have swelled recently and are causing huge damage to the planets small economy. You could send a force to intervene, it would provide a fine test of metal for any that partake.";
						button_text = "Send Hunters";
						button_function = function(){
							var dudes = collect_role_group("all", obj_star_select.target.name);
							group_selection(dudes,{
								purpose:"Beast Hunt",
								purpose_code : feature.problem,
								number:3,
								system:obj_controller.selected.id,
								feature:obj_star_select.feature,
								planet : obj_controller.selecting_planet,
								array_slot : feature.array_position,
								selections : []
							});
							destroy=true;
						}
						break;
					case "protect_raiders":
						mission_description=$"The governor of {planet_name} has sent many requests to the sector commander for help with defending against xenos raids on the populace of the planet, the reports seem to suggest the xenos in question are in fact dark elder.";
						help = "Set a squad to ambush ";
						break;
					case "train_forces":
						mission_description=$"The governor of {planet_name} fears the planet will not hold in the case of major incursion, it has not seen war in some time and he fears the ineptitude of the commanders available, he asks for aid in planning a thorough plan for defense and schedule of works for a period of at least 6 months.";
						help = $"A task best suited to the more knowledgable or wise of your Commanders"
						button_text = "Assign Officer";
						button_function = function(){
							var dudes = collect_role_group("captain_candidates", obj_star_select.target.name);
							group_selection(dudes,{
								purpose:"Select Officer",
								purpose_code : feature.problem,
								number:1,
								system:obj_controller.selected.id,
								feature:obj_star_select.feature,
								planet : obj_controller.selecting_planet,
								selections : []
							});
							destroy=true;
						}						
						break;																				
					case "Purge_enemies":
						mission_description=$"The governor of {planet_name} has expressed his distaste of the neighboring governance of {target.name} {feature.target} he has expressed his views that they engage in heretical ways and harbor xenos enemies though in truth it is more likely that he simply wishes his political enemies disposed of, whatever the case his planet has great economic means and he has made bare his plans to compensate the emperors angels for their aid";
						break;	
				}
				draw_text_transformed(xx+(area_width/2), yy +5, mission_name_key(feature.problem), 2, 2, 0);
				draw_set_halign(fa_left);
				draw_set_color(c_gray);
				draw_text_ext(xx+10, yy+40,mission_description,-1,area_width-20);
				var text_body_height = string_height_ext(string_hash_to_newline(mission_description),-1,area_width-20);
				if (help!="none"){
					draw_text_ext(xx+10, yy+40+text_body_height+10,help,-1,area_width-20);
					text_body_height+=string_height_ext(string_hash_to_newline(mission_description),-1,area_width-20)+10;
				}
				
				if (button_text!="none"){
					if (point_and_click(draw_unit_buttons([xx+((area_width/2)-(string_width(button_text)/2)), yy+40+text_body_height+10], button_text))){
						if (is_method(button_function)){
							button_function();
							destroy=true;
						} else {
							tooltip_draw("no implemented function");
						}
					}
				}			
				break;
		}
		if (generic){
			draw_text_ext_transformed(xx+(area_width/2), yy +5, title, -1, area_width-20, 2, 2, 0)

			draw_set_halign(fa_left);
			draw_set_color(c_gray);
			draw_text_ext(xx+10, yy+40,body,-1,area_width-20);
		}
		return "done";
	}
}

function draw_building_builder(xx, yy, req_require, building_sprite){
	var clicked =false;
	draw_sprite_ext(building_sprite, 0, xx, yy, 0.5, 0.5, 0, c_white, 1);
	var image_bottom = yy+50;
	var image_middle = xx-15;
	if (obj_controller.requisition>=req_require){
		if (scr_hit(image_middle+30, image_bottom+28, image_middle+78, image_bottom+44)){
			draw_sprite_ext(spr_slate_2, 5, image_middle-10, image_bottom, 1, 1, 0, c_white, 1);
			if (scr_click_left()){
				clicked=true;								
			}
		} else {
			draw_sprite_ext(spr_slate_2, 3, image_middle-10, image_bottom, 1, 1, 0, c_white, 1);
		}
	} else {
		draw_sprite_ext(spr_slate_2, 7, image_middle-10, image_bottom, 1, 1, 0, c_white, 1);
	}
	draw_sprite_ext(spr_requisition,0,image_middle+65,image_bottom+30,1,1,0,c_white,1);
	draw_set_halign(fa_left);
	draw_text(image_middle+32, image_bottom+30, req_require);
	return clicked;
}

function DataSlateMKTwo()constructor{
	height=0;
	width=0;
	XX=0;
	YY=0;
	static draw = function(xx,yy,x_scale, y_scale){
		XX=xx;
		YY=yy;
		height = 250*y_scale;
		width=365*x_scale;
		draw_sprite_ext(spr_slate_2, 1, xx, yy, x_scale, y_scale, 0, c_white, 1);
		draw_sprite_ext(spr_slate_2, 0, xx, yy, x_scale, y_scale, 0, c_white, 1);
		draw_sprite_ext(spr_slate_2, 2, xx, yy, x_scale, y_scale, 0, c_white, 1);
		//draw_sprite_ext(spr_slate_2, 0, xx, yy, 1, 1, 0, c_white, 1)
	}
}

function RackAndPinion(Type="forward") constructor{
	reverse =false;
	rack_y=0;
	rotation = 360;
	type=Type
	if (type="forward"){
		draw = function(x, y, freeze=false, Reverse=""){
			x+=19;
			if (!freeze){
				if (Reverse != ""){
					if (Reverse){
						reverse=true;
					} else {
						reverse=false;
					}
				}
				draw_sprite_ext(spr_cog_pinion, 0, x, y, 1, 1, rotation, c_white, 1)
				if (!reverse){
					rotation-=4;
				} else {
					rotation+=4;
				}
				rack_y = (75.3982236862/360)*(360-rotation);
				if (rack_y > 70){
					reverse = true;
				} else if (rack_y < 2){
					reverse = false;
				}
				draw_sprite_ext(spr_rack, 0, x-13, y-rack_y, 1, 1, 0, c_white, 1)
			} else {
				draw_sprite_ext(spr_cog_pinion, 0, x, y, 1, 1, rotation, c_white, 1)
				draw_sprite_ext(spr_rack, 0, x-13, y-rack_y, 1, 1, 0, c_white, 1)
			}		
		}
	} else if (type="backward"){
		draw = function(x, y, freeze=false, Reverse=""){
			x-=19;
			if (!freeze){
				if (Reverse != ""){
					if (Reverse){
						reverse=true;
					} else {
						reverse=false;
					}
				}
				draw_sprite_ext(spr_cog_pinion, 0, x, y, 1, 1, rotation, c_white, 1)
				if (!reverse){
					rotation+=4;
				} else {
					rotation-=4;
				}
				rack_y = (75.3982236862/360)*(360-rotation)
				if (rack_y > 70){
					reverse = true;
				} else if (rack_y < 2){
					reverse = false;
				}
				draw_sprite_ext(spr_rack, 0, x+13, y+rack_y, -1, 1, 0, c_white, 1)
			} else {
				draw_sprite_ext(spr_cog_pinion, 0, x, y, 1, 1, rotation, c_white, 1)
				draw_sprite_ext(spr_rack, 0, x+13, y+rack_y, -1, 1, 0, c_white, 1)
			}		
		}		
	}
}
function SpeedingDot(XX,YY, limit) constructor{
	bottom_limit = limit;
	stack = 0;
	yyy=YY;
	xxx=XX;
	draw = function(xx,yy){
		if (bottom_limit+(48*0.7)<stack){
			stack=0;
		}
		var top_cut = 36-stack>0 ? 36-stack :0;
		var bottom_cut = bottom_limit<stack? 46-stack-bottom_limit:46;
		draw_sprite_part_ext(spr_research_bar, 2, 0, top_cut, 200, bottom_cut, xx-105, yy+stack, 1, 0.7, c_white, 1);
		stack+=3;
	}
	current_y = function(){
		return yy+stack;
	}
}
function GlowDot() constructor{
	flash = 0
	flash_size = 5;
	one_flash_finished = true;
	draw = function(xx, yy){
		draw_set_color(c_green);
		for (var i=0; i<=flash_size;i++){
			draw_set_alpha(1 - ((1/40)*i))
			draw_circle(xx, yy, (i/3), 1);
		}
		if (flash==0){
			if (flash_size<40){
				flash_size++;
			} else {
				flash = 1;
				flash_size--;
			}
		} else {
			if (flash_size > 1){
				flash_size--;
			}else {
				flash_size++;
				flash = 0;
			}
		}		
	}
	draw_one_flash = function(xx, yy){
		if (one_flash_finished) then exit;
		draw_set_color(c_green);
		for (var i=0; i<=flash_size;i++){
			draw_set_alpha(1 - ((1/40)*i))
			draw_circle(xx, yy, (i/3), 1);
		}
		if (flash==0){
			if (flash_size<40){
				flash_size++;
			} else {
				flash = 1;
				flash_size--;
			}
		} else {
			if (flash_size > 1){
				flash_size--;
			}else {
				flash_size++;
				flash = 0;
				one_flash_finished = true;
			}
		}		
	}
}

function ShutterButton() constructor{
	time_open = 0;
	click_timer = 0;
	Width = 315;
	Height = 90;
	XX=0;
	YY=0;
	width=0;
	height=0;
	right_rack = new RackAndPinion();
	left_rack = new RackAndPinion("backward");
	draw_shutter = function(xx,yy,text, scale=1, entered = ""){
		XX=xx;
		YY=yy;
        draw_set_alpha(1);

        draw_set_font(fnt_40k_12);
        draw_set_halign(fa_left);
        draw_set_color(c_gray);		
		width = Width *scale;
		height = Height *scale;
		if (text=="") then entered = false;
		if (entered==""){
			entered = scr_hit(xx, yy, xx+width, yy+height);
		} else {
			entered=entered;
		}
		var shutter_backdrop = 5;
		if (entered || click_timer>0){
			if (time_open<20){
				time_open++;
				right_rack.draw(xx+width, yy, false, false);
				left_rack.draw(xx, yy, false, false);
			} else {
				right_rack.draw(xx+width, yy, true);
				left_rack.draw(xx, yy, true);
			}
			if (point_and_click([xx, yy, xx+width, yy+height]) || click_timer>0 ){
				shutter_backdrop = 6;
				click_timer++;
			}
		} else if (time_open>0){
			time_open--;
			right_rack.draw(xx+width, yy, false, true);
			left_rack.draw(xx, yy, false, true);
		} else {
			right_rack.draw(xx+width, yy, true);
			left_rack.draw(xx, yy, true);
		}
		var text_draw = xx+(width/2)-(string_width(text)*(3*scale)/2);
		var main_sprite = 0;
		if (time_open<2){
			draw_sprite_ext(spr_shutter_button, main_sprite, xx, yy, scale, scale, 0, c_white, 1)
		} else if (time_open<8 && time_open>=2){
			main_sprite=1;
		}else if  (time_open<13 && time_open>=8){
			main_sprite=2;
		}else if  (time_open<18 && time_open>=13){
			main_sprite=3;
		} else if (time_open>=18){
			main_sprite=4;
		}
		if (time_open>=2){
			draw_sprite_ext(spr_shutter_button, shutter_backdrop, xx, yy, scale, scale, 0, c_white, 1)
			draw_set_color(c_red);
			if (click_timer>0){
				draw_text_transformed(text_draw, yy+(24*scale), text, 3*scale, 3*scale, 0);
			} else {
				draw_text_transformed(text_draw, yy+(20*scale), text, 3*scale, 3*scale, 0);
			}
			draw_sprite_ext(spr_shutter_button, main_sprite, xx, yy, scale, scale, 0, c_white, 1)			
		}
		draw_set_color(c_grey);
		if (click_timer>7){
			click_timer = 0;
			return true;
		} else {
			return false;
		}
	}
}

function DataSlate() constructor{
	static_line=1;
	title="";
	sub_title="";
	body_text = "";
	inside_method = "";
	XX=0;
	YY=0;
	width=0;
	height=0;
	percent_cut=0;
	static draw = function(xx,yy, scale_x=1, scale_y=1){
		XX=xx;
		YY=yy;
		width = 860*scale_x;
		height = 850*scale_y;
		draw_sprite_ext(spr_data_slate,1, xx,yy, scale_x, scale_y, 0, c_white, 1);
		if (is_method(inside_method)){
			inside_method();
		}
	    if (static_line<=10) then draw_set_alpha(static_line/10);
	    if (static_line>10) then draw_set_alpha(1-((static_line-10)/10));		
		draw_set_color(5998382);
		var line_move = yy+(70*scale_y)+((36*scale_y)*static_line);
		draw_line(xx+(30*scale_x),line_move,xx+(820*scale_x),line_move);
		draw_set_alpha(1);
		if (irandom(75)=0 && static_line>1){static_line--;}
		else{
			static_line+=0.1;
		}
		if (static_line>20) then static_line=1;
		draw_set_color(c_gray);
		draw_set_halign(fa_center);
		var draw_height = 	5;
		if (title!=""){
			draw_text_transformed(xx+(0.5*width), yy+(50*scale_y), title, 3*scale_x, 3*scale_y, 0);
			draw_height += (string_height(title)*3)*scale_y;
		}
		if (sub_title!=""){
			draw_text_transformed(xx+(0.5*width), yy+(50*scale_y)+draw_height, sub_title, 2*scale_x, 2*scale_y, 0);
			draw_height+=(25*scale_y) +(string_height(sub_title)*2)*scale_y;
		}
		if (body_text!=""){
			draw_text_ext(xx+(0.5*width), yy+(50*scale_y)+draw_height, string_hash_to_newline(body_text), -1, width-60);
		}
	}
	static draw_cut = function(xx,yy, scale_x=1, scale_y=1, middle_percent=percent_cut){
		XX=xx;
		YY=yy;
		draw_sprite_part_ext(spr_data_slate,1, 0, 0, 850, 69, XX, YY, scale_x, scale_y, c_white, 1);
		draw_sprite_part_ext(spr_data_slate,1, 0, 69, 850, 683*(middle_percent/100), XX, YY+(69*scale_y), scale_x, scale_y, c_white, 1);
		draw_sprite_part_ext(spr_data_slate,1, 0, 752, 850, 98, XX, YY+(69+683*((middle_percent/100)))*scale_y, scale_x, scale_y, c_white, 1);
		width = 860*scale_x;
		height = (69+(683*(middle_percent/100))+98 )*scale_y;
		if (is_method(inside_method)){
			inside_method();
		}		
	}

	static percent_mod_draw_cut = function(xx,yy, scale_x=1, scale_y=1, mod_edit=1){
		percent_cut = min(percent_cut+mod_edit, 100);
		if (!percent_cut) then percent_cut=0;
		draw_cut(xx,yy, scale_x, scale_y);
	}
}










