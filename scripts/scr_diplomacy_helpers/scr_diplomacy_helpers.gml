// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information


function basic_diplomacy_screen(){
	var  yy=__view_get( e__VW.YView, 0 );
	var  xx=__view_get( e__VW.XView, 0 );
	 if (trading=0) and ((diplo_option[1]!="") or (diplo_option[2]!="") or (diplo_option[3]!="") or (diplo_option[4]!="")){
        if (force_goodbye=0){
            draw_set_halign(fa_center);
        
            var opts=0,slot=0,dp=0,opt_cord=0;
           for (dp=1;dp<5;dp++){
           		if (diplo_option[dp]!="") then opts+=1;
           	}
            if (opts=4) then yy-=30;
            if (opts=2) then yy+=30;
            if (opts=1) then yy+=60;
        	var left,top,right,base,opt;
        	option_selections = [];
            for (slot=1;slot<5;slot++){
                if (diplo_option[slot]!=""){
					left = xx+354;
					top = yy+694;
					right = xx+887;
					base = yy+717;
                    draw_set_color(38144);
                    draw_rectangle(left,top,right,base,0);
                    draw_set_color(0);
                
                    var sw=1;
                    for (var i=1;i<5;i++){
                    	if (string_width(string_hash_to_newline(diplo_option[slot]))*sw>530) then sw-=0.05;
                    }
                    if (string_width(string_hash_to_newline(diplo_option[slot]))*sw<=530) and (sw=1) then draw_text_transformed(xx+620,yy+696,string_hash_to_newline(string(diplo_option[slot])),sw,sw,0);
                    if (string_width(string_hash_to_newline(diplo_option[slot]))*sw<=530) and (sw<1) then draw_text_transformed(xx+620,yy+696+2,string_hash_to_newline(string(diplo_option[slot])),sw,sw,0);
                    if (string_width(string_hash_to_newline(diplo_option[slot]))*sw>530){
                        draw_text_ext_transformed(xx+620,yy+696-4,string_hash_to_newline(string(diplo_option[slot])),16,530/sw,sw,sw,0);
                    }
					if point_in_rectangle(mouse_x, mouse_y,left,top,right,base){
                        draw_set_alpha(0.2);draw_rectangle(left,top,right,base,0);draw_set_alpha(1);
                    }
					opt = [left,top,right,base];
					array_push(option_selections,opt);
					opt_cord+=1;
	                yy+=30;                    
                }
            }
            yy=__view_get( e__VW.YView, 0 );
        }
		if (menu==20) and (diplomacy==10.1){
			scr_emmisary_diplomacy_routes();
		}
        if (force_goodbye=1){
            draw_rectangle(xx+818,yy+796,xx+897,yy+815,0);
            draw_set_color(0);
            draw_text(xx+857.5,yy+797,string_hash_to_newline("Exit"));
            draw_set_alpha(0.2);
            if (mouse_x>=xx+818) and (mouse_y>=yy+796) and (mouse_x<=xx+897) and (mouse_y<=yy+815) then draw_rectangle(xx+818,yy+796,xx+897,yy+815,0);
            draw_set_alpha(1);
        }
    
    }
}
function scr_diplomacy_hit(selection, new_path, complex_path="none"){
    if (array_length(option_selections)>selection){
        if (point_and_click(option_selections[selection])){
        	if (!is_method(complex_path)){
		        diplomacy_pathway = new_path;
		        scr_dialogue(diplomacy_pathway);
	    	} else {
	    		complex_path();
	    	}
    	}
    } else {
        return false;
    }
}
// ** Diplomacy Chaos talks **
function scr_emmisary_diplomacy_routes(){
	if ((cooldown > 0)) then exit;
	if (diplomacy_pathway == "intro") {
        //TODO replace with methods more in line with rest of code base but this helps find bugs for now
		scr_diplomacy_hit(0,"gift");
		scr_diplomacy_hit(1,"daemon_scorn");
		scr_diplomacy_hit(2,"daemon_scorn");
	}
	else if (diplomacy_pathway == "gift")  {
		scr_diplomacy_hit(0,"Khorne_path");
		scr_diplomacy_hit(1,"Nurgle_path");
		scr_diplomacy_hit(2,"Tzeentch_path");
		scr_diplomacy_hit(3,"Slaanesh_path");
	}
	else if (diplomacy_pathway == "Khorne_path")  {
		scr_diplomacy_hit(0, ,function(){
			//TODO central get cm method
	        var chapter_master = obj_ini.TTRPG[0,0];
			cooldown=8000;
			diplomacy_pathway = "sacrifice_lib";
            //grab a random librarian
            var lib = scr_random_marine(SPECIALISTS_LIBRARIANS,0);
            if (lib!="none"){
                var chapter_master = obj_ini.TTRPG[0][1];
                var dead_lib = obj_ini.TTRPG[lib[0],lib[1]];
                pop_up = instance_create(0,0,obj_popup);
                pop_up.title = "Skull for the Skull Throne";
                pop_up.text = $"You summon {dead_lib.name_role()} to your personal chambers. Darting from the shadows you deftly strike his head from his shoulders. With the flesh removed from his skull you place the skull upon a hastily erected shrine."
                pop_up.type=98;
                pop_up.image = "chaos";
                kill_and_recover(lib[0],lib[1]);
                chapter_master.add_trait("blood_for_blood");
                chapter_master.edit_corruption(20);
            } else {
                diplomacy_pathway = "daemon_scorn";
            }
            scr_dialogue(diplomacy_pathway);  
			force_goodbye = 1;
		});
		scr_diplomacy_hit(1, ,function(){
	        
			cooldown=8000;
			diplomacy_pathway = "sacrifice_champ";
            var champ = scr_random_marine(obj_ini.role[100,7],0);
            if (champ!="none"){
                var chapter_master = obj_ini.TTRPG[0][1];
                 chapter_master.add_trait("blood_for_blood");
                 chapter_master.edit_corruption(20);
                var dead_champ = obj_ini.TTRPG[champ[0]][champ[1]];
                //TODO make this into a real dual with consequences
                pop_up = instance_create(0,0,obj_popup);
                pop_up.title = "Skull for the Skull Throne";
                pop_up.text = $"You summon {dead_champ.name_role()} to your personal chambers. Darting from the shadows towards {dead_champ.name()} who is a cunning warrior and reacts with precision to your attack, however eventually you prevail and strike him down. With the flesh removed from his skull you place it upon a hastily erected shrine."
                pop_up.type=98;
                pop_up.image = "chaos";                
               // obj_duel = instance_create(0,0,obj_duel);
               // obj_duel.title = "Ambush Champion";
               // pop.type="duel";
                kill_and_recover(champ[0],champ[1]);
            } else {
                diplomacy_pathway = "daemon_scorn";
            }              
			scr_dialogue(diplomacy_pathway);
			force_goodbye = 1;

		});
       scr_diplomacy_hit(2, ,function(){
			cooldown=8000;
			diplomacy_pathway = "sacrifice_squad";
            var kill_squad, squad_found=false;
            for(var i=0;i<array_length(obj_ini.squads);i++){
                kill_squad = obj_ini.squads[i];
                if (kill_squad.type == "tactical_squad" && array_length(kill_squad.members)>4){
                    var chapter_master = obj_ini.TTRPG[0][1];
                    chapter_master.add_trait("blood_for_blood");   
                    chapter_master.edit_corruption(20);
                    kill_squad.kill_members();
                    with(obj_ini){
                        scr_company_order(kill_squad.base_company);
                    }
                    squad_found=true
                    break;
                }
            }
            if (!squad_found){
                diplomacy_pathway = "daemon_scorn";
            }
			scr_dialogue(diplomacy_pathway);
			force_goodbye = 1;
		});
       scr_diplomacy_hit(3, "daemon_scorn");
	}
	else if (diplomacy_pathway == "Slaanesh_path")  {
		scr_diplomacy_hit(0, "Slaanesh_arti");
		scr_diplomacy_hit(1, "daemon_scorn");
	}
	else if (diplomacy_pathway == "Nurgle_path")  {
		scr_diplomacy_hit(0, "nurgle_gift");
		scr_diplomacy_hit(1, "daemon_scorn");

	}
	
	else if (diplomacy_pathway = "Tzeentch_path")  {
		scr_diplomacy_hit(0, "Tzeentch_plan");
		scr_diplomacy_hit(1, "daemon_scorn");		
	}
}