


function draw_player_fleet_combat_options(){
    var xxx=main_slate.XX;
    var yyy=main_slate.YY;
	draw_set_font(fnt_40k_14b);
    draw_set_halign(fa_left);
    
    draw_text(xxx+12,yyy+237,"Enemy Fleets:");
    draw_text(xxx+332,yyy+237,"Allied Fleets:");
    
	draw_text(xxx+310,yyy+118,$"{strin[1]} {string_plural("Battleship",strin[1])} ({strin[4]}% HP)");
	draw_text(xxx+310,yyy+138,$"{strin[2]} {string_plural("Frigate",strin[2])} ({strin[5]}% HP)");
	draw_text(xxx+310,yyy+158,$"{strin[3]} {string_plural("Escort",strin[3])} ({strin[6]}% HP)");

    
    draw_set_halign(fa_center);
    
    for (var i=1;i<array_length(enemy_fleet);i++){
        // draw_sprite(spr_force_icon,enemy_fleet[1],xxx+44,yyy+269);
    	if (i>1){
        	xxx+=110;
        }
        if (enemy_fleet[i]!=0){
	        scr_image("ui/force",enemy_fleet[i],xxx+44-32,yyy+269-32,64,64);
	        var shw="";
	        shw += $"{ecap[i]} :"+string_plural( "Battleship",ecap[i]) + "\n";
	        shw += $"{efri[i]} :"+string_plural("Frigate",efri[i]) + "\n";
	        shw +=$"{eesc[i]} :"+string_plural( "Escort",eesc[i]) + "\n";
	        
	        draw_text_transformed(xxx+44,yyy+286,shw,0.7,1,0);
	        draw_set_halign(fa_center);
	        draw_set_font(fnt_40k_14b);
    	}
        if (array_length(allied_fleet)<i){
        	var _ali_mod = 330;
	        if (allied_fleet[i]!=0){
	            // draw_sprite(spr_force_icon,allied_fleet[1],xxx+374,yyy+269);
	            scr_image("ui/force",allied_fleet[i],xxx+44+_ali_mod-32,yyy+269-32,64,64);
	            var shw="";
		        shw += $"{acap[i]} : {string_plural( "Battleship",acap[i])} \n";
		        shw += $"{afri[i]} :{string_plural( "Frigate",afri[i])} \n";
		        shw +=$"{aesc[i]} :{string_plural( "Escort",aesc[i])} \n";	            
	            
	            draw_text_transformed(xxx+44+_ali_mod,yyy+286,shw,0.7,1,0);
	            draw_set_halign(fa_center);
	            draw_set_font(fnt_40k_14b);
	        }            	
        }

    }
    var xxx=main_slate.XX;

    var _retreat_button = draw_unit_buttons([xxx+195,yyy+354],"Retreat");
    if (point_and_click(_retreat_button)){
        with(obj_fleet_select){
        	instance_destroy();
        }
        var that=instance_nearest(battle_pobject[current_battle].x,battle_pobject[current_battle].y,obj_p_fleet);
        that.alarm[3]=1;
        var that2=instance_create(0,0,obj_popup);
        that2.type=99;
        obj_controller.force_scroll=1;        	
    }

    var _fight_button = draw_unit_buttons([xxx+272,yyy+354],"Fight");
    if (point_and_click(_fight_button)){
		obj_controller.cooldown=8000;
        instance_activate_all();

        // Start battle here

        combating=1;

        instance_create(0,0,obj_fleet);
        // 
        obj_fleet.enemy[1]=enemy_fleet[1];
        obj_fleet.enemy_status[1]=-1;

        obj_fleet.en_capital[1]=ecap[1];
        obj_fleet.en_frigate[1]=efri[1];
        obj_fleet.en_escort[1]=eesc[1];

        // Plug in all of the enemies first
        // And then plug in the allies after then with their status set to positive


        var g=1;ee=1;
        repeat(5){g+=1;
            if (enemy_fleet[g]!=0){ee+=1;
                obj_fleet.enemy[ee]=enemy_fleet[g];
                obj_fleet.enemy_status[ee]=-1;
    
                obj_fleet.en_capital[ee]=ecap[g];
                obj_fleet.en_frigate[ee]=efri[g];
                obj_fleet.en_escort[ee]=eesc[g];
            }
        }
        var g=0;
        repeat(6){g+=1;
            if (allied_fleet[g]!=0){
                ee+=1;
                obj_fleet.enemy[ee]=allied_fleet[g];
                obj_fleet.enemy_status[ee]=1;
    
                obj_fleet.en_capital[ee]=acap[g];
                obj_fleet.en_frigate[ee]=afri[g];
                obj_fleet.en_escort[ee]=aesc[g];
            }
        }

        if (battle_special[current_battle]="csm"){
        	obj_fleet.csm_exp=1;
        }
        if (battle_special[current_battle]="BLOOD"){
        	obj_fleet.csm_exp=2;
        }

        instance_activate_all();
        var stahr=instance_nearest(battle_pobject[current_battle].x,battle_pobject[current_battle].y,obj_star);
        obj_fleet.star_name=stahr.name;

        for (var p_num = 1; p_num<stahr.planets;p_num++){
            //TODO fix this because this sounds rad
            //if(planet_feature_bool(stahr.p_feature[p_num], P_features.Monastery)==1)thenobj_fleet.player_lasers=stahr.p_lasers[p_num]; 
        }
        var that=instance_nearest(battle_pobject[current_battle].x,battle_pobject[current_battle].y,obj_p_fleet);
        add_fleet_ships_to_combat(that, obj_fleet)

        instance_deactivate_all(true);
        instance_activate_object(obj_controller);
        instance_activate_object(obj_ini);
        instance_activate_object(obj_fleet);
        instance_activate_object(obj_cursor);
        // instance_deactivate_object(battle_pobject[current_battle]);
    }
	
}


function draw_player_ground_combat_options(){
    var xxx=main_slate.XX;
    var yyy=main_slate.YY;
    if (battle_opponent[current_battle]<=20){
        draw_text(xxx+310,yyy+118,string(strin[1])+" Marines");
        draw_text(xxx+310,yyy+138,string(strin[2])+" Vehicles");
        if (strin[3]!="") then draw_text(xxx+310,yyy+158,string(strin[3])+" Fortified");// Not / Barely / Lightly / Moderately / Highly / Maximally
    }
    
    draw_set_font(fnt_40k_14b);
    draw_set_halign(fa_left);
    
    draw_text(xxx+12,yyy+237,"Enemy Factions:");
    draw_text(xxx+332,yyy+237,"Allies:");
    
    
    
    draw_set_halign(fa_center);
    // draw_sprite(spr_force_icon,battle_opponent[current_battle],xxx+44,yyy+289);
    scr_image("ui/force",battle_opponent[current_battle],xxx+44-32,yyy+289-32,64,64);
    draw_text_transformed(xxx+44,yyy+316,string_hash_to_newline(string(strin[4])),0.75,1,0);
    draw_set_halign(fa_center);draw_set_font(fnt_40k_14b);
    
    
    draw_set_color(c_gray);
	draw_rectangle(xxx+132,yyy+354,xxx+259,yyy+389,0);
    draw_set_color(0);
	draw_text_transformed(xxx+195,yyy+362,"Offensive",1.1,1.1,0);
    if (scr_hit(xxx+132,yyy+354,xxx+259,yyy+389)){
        draw_set_alpha(0.2);draw_rectangle(xxx+132,yyy+354,xxx+259,yyy+389,0);
		draw_set_alpha(1);
    }
    
    draw_set_color(c_gray);draw_rectangle(xxx+272,yyy+354,xxx+399,yyy+389,0);
    draw_set_color(0);
	draw_text_transformed(xxx+335,yyy+362,"Defensive",1.1,1.1,0);
    if (scr_hit(xxx+272,yyy+354,xxx+399,yyy+389)){
        draw_set_alpha(0.2);
		draw_rectangle(xxx+272,yyy+354,xxx+399,yyy+389,0);draw_set_alpha(1);
    } 
    
}
