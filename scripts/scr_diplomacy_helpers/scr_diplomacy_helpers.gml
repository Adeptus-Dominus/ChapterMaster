// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function relationship_hostility_matrix(faction){
    var _rela="neutral";
    var _disp = disposition[faction];
    with (obj_controller){
        // if (diplomacy!=8){
        if (_disp>=60) then _rela="friendly";
        if (_disp<60) and (_disp>=20) then _rela="neutral";
        if (_disp<20) then _rela="hostile";
        // }
        if (diplomacy==6){
            if (_disp>=60) then _rela="friendly";
            if (_disp<60) and (_disp>=0) then _rela="neutral";
            if (_disp<0) then _rela="hostile";
        }
    
        if (diplomacy==8){
            if (_disp>=40) then _rela="friendly";
            if (_disp<40) and (_disp>=-15) then _rela="neutral";
            if (_disp<-15) then _rela="hostile";
        }        
    }
    return _rela;
}

function alter_disposition(faction, alter_value){
    obj_controller.disposition[faction] = clamp(obj_controller.disposition[faction]+alter_value, -100, 100);
}

function clear_diplo_choices(){
    obj_controller.diplo_option = [];
}

function valid_diplomacy_options(){
    var valid = false;
    if (array_length(obj_controller.diplo_option)){
        for (var i=array_length(obj_controller.diplo_option)-1;i>=0;i--){
            if (obj_controller.diplo_option[i] != ""){
                valid = true;
            } else {
                array_delete(obj_controller.diplo_option, i, 1);
            }
        }
    }else{
        return false;
    }
    return valid;
}

function add_diplomacy_option(option={}){
    if (!struct_exists(option, "goto")){
        option.goto = "";
    }
    if (!struct_exists(option, "key")){
        option.key = option.option_text;
    }
    array_push(obj_controller.diplo_option, option);
}

function basic_diplomacy_screen(){
	var  yy=__view_get( e__VW.YView, 0 );
	var  xx=__view_get( e__VW.XView, 0 );
	 if (trading=0  && valid_diplomacy_options()){
        if (!force_goodbye){
            draw_set_halign(fa_center);
        
            var opts=0,slot=0,dp=0,opt_cord=0;
            var opts = array_length(diplo_option);
            if (opts==4) then yy-=30;
            if (opts==2) then yy+=30;
            if (opts==1) then yy+=60;

        	var left,top,right,base,opt;
        	option_selections = [];
            var diplo_pressed = -1;
            for (var slot=0; slot<opts; slot++){

                var _opt = diplo_option[slot];
				left = xx+354;
				top = yy+694;
				right = xx+887;
				base = yy+717;
                draw_set_color(38144);
                draw_rectangle(left,top,right,base,0);
                draw_set_color(0);
            
                var sw=1;
                for (var i=1;i<5;i++){
                	if (string_width(string_hash_to_newline(_opt.option_text))*sw>530) then sw-=0.05;
                }
                if (string_width(string_hash_to_newline(_opt.option_text))*sw<=530) and (sw=1){
                    draw_text_transformed(xx+620,yy+696,string_hash_to_newline(_opt.option_text),sw,sw,0);
					draw_text_transformed(xx+620,yy+696+2,string_hash_to_newline(_opt.option_text),sw,sw,0);
                }

                if (string_width(string_hash_to_newline(_opt.option_text))*sw>530){
                    draw_text_ext_transformed(xx+620,yy+696-4,string_hash_to_newline(_opt.option_text),16,530/sw,sw,sw,0);
                }
				if scr_hit(left,top,right,base){
                    draw_set_alpha(0.2);
                    draw_rectangle(left,top,right,base,0);
                    draw_set_alpha(1);
                }
				opt = [left,top,right,base];
				array_push(option_selections,opt);
                if (point_and_click(opt)){
                    diplo_pressed = slot;
                }
				opt_cord+=1;
                yy+=30;                    

            }
            if (diplo_pressed>-1){
                evaluate_chosen_diplomacy_option(diplo_pressed);
            }
            yy=__view_get( e__VW.YView, 0 );
        }
		if (menu==MENU.Diplomacy) and (diplomacy==10.1){
			scr_emmisary_diplomacy_routes();
		}
        if (force_goodbye=1){
            draw_rectangle(xx+818,yy+796,xx+897,yy+815,0);
            draw_set_color(0);
            draw_text(xx+857.5,yy+797,"Exit");
            draw_set_alpha(0.2);
            if (mouse_x>=xx+818) and (mouse_y>=yy+796) and (mouse_x<=xx+897) and (mouse_y<=yy+815) then draw_rectangle(xx+818,yy+796,xx+897,yy+815,0);
            draw_set_alpha(1);
        }
    
    }
}

function draw_character_diplomacy(){
    var _diplo_unit = character_diplomacy;
    if (_diplo_unit.allegiance == global.chapter_name){


        /*if (advi="flee") {
            _diplomacy_faction_name="Master of the Fleet "+string(obj_ini.lord_admiral_name);
        }*/
        var _splash = "";
        var _specific_splash = 0;
        _diplomacy_faction_name = _diplo_unit.name_role();
        _diplo_unit.IsSpecialist(SPECIALISTS_HEADS){

            var _customs = obj_ini.custom_advisors;
            if (_diplo_unit.IsSpecialist(SPECIALISTS_APOTHECARIES)) {
                _specific_splash = struct_exists(_customs,"apothecary") ? _customs.apothecary : 2;
            }
            else if (_diplo_unit.IsSpecialist(SPECIALISTS_CHAPLAINS)) {
                _specific_splash = struct_exists(_customs,"chaplain") ? _customs.chaplain : 3;
            }
            else if (_diplo_unit.IsSpecialist(SPECIALISTS_LIBRARIANS)) {
                _specific_splash = struct_exists(_customs,"librarian") ? _customs.librarian : 4;
            }
            else if (_diplo_unit.IsSpecialist(SPECIALISTS_TECHS)) {
                _specific_splash = struct_exists(_customs,"forge_master") ? _customs.forge : 5;
            }
            scr_image("advisor/splash", _specific_splash, 16, 43, 310, 828);
        }
       /* else if (advi="") {
            _diplomacy_faction_name="First Sergeant "+string(recruiter_name); 
        }*/

    }

    var _main_slate = diplo_buttons.main_slate; 
    var _meet = diplo_buttons.meet_slate;
    var _cm_slate = diplo_buttons.cm_slate;
    with (_meet){
        XX = 0;
        YY = 520;
        width = 520;
    }

    _meet.inside_method = function(){
        var _diplo_unit = obj_controller.character_diplomacy;
        if (!struct_exists(obj_controller, "diplo_image")){
            obj_controller.diplo_image = _diplo_unit.draw_unit_image();
        }
        obj_controller.diplo_image.draw(210, 520-271,true, 1,1,0,CM_GREEN_COLOR, 1);
        _diplo_unit.stat_display(false,{
            x1: 10,
            y1: 520,
            w: 569,
            h: 303,
        }, true);  
        draw_sprite(spr_holo_pad, 0, 210, 520);      
    }

    _meet.draw_with_dimensions();

    _main_slate.XX = _meet.XX+_meet.width;
    _main_slate.YY = 175;
    _main_slate.draw_with_dimensions();
    draw_diplomacy_diplo_text();
    draw_set_halign(fa_center);
    draw_text_transformed(622,104,$"{_diplo_unit.name_role()}",0.6,0.6,0);
    draw_set_halign(fa_left);

    with (_cm_slate){
        XX = _main_slate.XX+_main_slate.width;
        YY = 520;
    }
    _cm_slate.inside_method = function(){
        var _master = fetch_unit([0,0]);

        if (!struct_exists(obj_controller, "master_image")){
            obj_controller.master_image = _master.draw_unit_image();
        }
        obj_controller.master_image.draw(1108+200, 520-271,true, 1,1,0,CM_GREEN_COLOR, 1);
        _master.stat_display(false,{
            x1: 1108,
            y1: 520,
            w: 569,
            h: 303,
        } , true);
        draw_sprite(spr_holo_pad, 0, 1108+200, 520);
    }
    _cm_slate.draw_with_dimensions();



    basic_diplomacy_screen();
}

function evaluate_chosen_diplomacy_option(diplo_pressed){
    var _opt = diplo_option[diplo_pressed];

    var _pressed_option = _opt.key;
    if (struct_exists(_opt, "method")){
        if (is_callable(_opt.method)){
            script_execute(_opt.method);
        }
    }
    if (_opt.goto != ""){
        scr_dialogue(_opt.goto);
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