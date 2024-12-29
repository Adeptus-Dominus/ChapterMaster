function scr_ui_settings() {

	var romanNumerals=scr_roman_numerals();
	// Var declaration
	var xx,yy;
	var tool1="",tool2="";
	var che,cx,cy;
	var x5=0,y5=0,x6=0;
	var too_img=0;
	xx=__view_get( e__VW.XView, 0 )+0;
	yy=__view_get( e__VW.YView, 0 )+0;
	
	if (menu>=21) and (menu<=24) then draw_sprite(spr_settings_bg,0,xx,yy);
	
	if (menu=24) and (formating>0){
	    // Reset vars
		tool1="";
		tool2="";
		
		// Back arrow
	    draw_sprite_ext(spr_arrow,0,xx+25,yy+70,2,2,0,c_white,1);
		
	    if (scr_hit(xx+25,yy+70,xx+25+64,yy+70+64)=true) and (mouse_left=1) and (cooldown<=0){
	        with(obj_formation_bar){instance_destroy();}
	        cooldown=8000;
			menu=21;
			if (bat_formation[formating]="") then bat_formation_type[formating]=0;
			exit;
	    }
    
	    draw_set_halign(fa_center);
		draw_set_color(c_gray);
		draw_set_font(fnt_40k_30b);
    
	    draw_set_alpha(1);
	    draw_sprite(spr_formation_arrow,0,xx+550,yy+385);
    
	    var bar_wid=0;
	    draw_set_alpha(0.25);
	    if (bat_formation[formating]!="") then bar_wid=max(400,string_width(bat_formation[formating]));
	    if (bat_formation[formating]="") then bar_wid=400;
    
	    if (formating>3) then draw_rectangle(xx+800-(bar_wid/2),yy+66,xx+800+(bar_wid/2),yy+66+string_height("LOL"),1);
	    obj_cursor.image_index=0;
    
	    if (formating>3) and (obj_cursor.dragging=0){
	        if (scr_hit(xx+800-(bar_wid/2),yy+66,xx+800+(bar_wid/2),yy+66+string_height("LOL"))=false) and (mouse_left=1) and (cooldown<=0) then text_bar=0;
	        if (scr_hit(xx+800-(bar_wid/2),yy+66,xx+800+(bar_wid/2),yy+66+string_height("LOL"))=true){
	            obj_cursor.image_index=2;
	            if (cooldown<=0) and (mouse_left=1) and (text_bar=0){
	                cooldown=8000;text_bar=1;keyboard_string=bat_formation[formating];
	            }
            
	        }
	    }
	    draw_set_alpha(1);
	    if (bat_formation[formating]!="") or (text_bar>0){
	        if (formating>3){
	            if (text_bar=0) or (text_bar>31) then draw_text(xx+800,yy+66,"''"+string(bat_formation[formating])+"'' ");
	            if (text_bar>0) and (text_bar<=31) then draw_text(xx+800,yy+66,"''"+string(bat_formation[formating])+"|''");
	        }
	        if (formating<=3) then draw_text(xx+800,yy+66,string(bat_formation[formating]));
	    }
    
	    draw_set_font(fnt_40k_14);draw_set_halign(fa_left);
    
	    if (bat_formation_type[formating]!=1) then che=1;
	    if (bat_formation_type[formating]=1) then che=2;
	    cx=xx+757;
		cy=yy+115;
		
		// Defines the attack command
		draw_text(cx,cy,"Attack");
		cx-=35;
		cy-=4;
		
	    if (formating<=3) then draw_set_alpha(0.5);
		draw_sprite(spr_creation_check,che+1,cx,cy);
		draw_set_alpha(1);
		// Attack command tool tips
	    if (scr_hit(cx+31,cy,cx+260,cy+20)=true){
			tool1="Attack";
			tool2="Allows the use of vehicles, and bikes, but prevents this formation from being used during Raids.";
		}
	    if (scr_hit(cx,cy,cx+32,cy+32)=true) and (mouse_left=1) and (cooldown<=0) and (formating>3){
			var onceh=0;
			cooldown=8000;
	        if (onceh=0) and ((bat_formation_type[formating]=0) or (bat_formation_type[formating]=2)){
				onceh=1;bat_formation_type[formating]=1;
				scr_ui_formation_bars();
			}
	    }
	    if (bat_formation_type[formating]!=2) then che=1;
	    if (bat_formation_type[formating]=2) then che=2;
	    
		// Defines the Raid action
		cx=xx+757;
		cy=yy+150;
		draw_text(cx,cy,"Raid");
		
		cx-=35;
		cy-=4;
	    if (formating<=3) then draw_set_alpha(0.5);
		draw_sprite(spr_creation_check,che+1,cx,cy);
		draw_set_alpha(1);
		// Raid action tooltip
	    if (scr_hit(cx+31,cy,cx+260,cy+20)=true){
			tool1="Raid";
			tool2="Prevents the use of vehicles, and bikes, but allows this formation to be used for Raids.";
		}
	    if (scr_hit(cx,cy,cx+32,cy+32)=true) and (mouse_left=1) and (cooldown<=0) and (formating>3){
			var onceh;
			onceh=0;
			cooldown=8000;
	        if (onceh=0) and ((bat_formation_type[formating]=0) or (bat_formation_type[formating]=1)){
				onceh=1;
				bat_formation_type[formating]=2;
				scr_ui_formation_bars();
			}
	    }

	    draw_set_color(c_gray);
		draw_set_alpha(0.25);
	    
	    x5=xx+49;
		y5=yy+224;
	    
		for(var i=0; i<10; i++){
			draw_rectangle(x5,y5,x5+38,y5+464,0);
			x5+=50;
		}
	    draw_set_alpha(1);
    
	    // Attack Box
	    if (bat_formation_type[formating]=1){
			draw_rectangle(xx+35,yy+211,xx+1206,yy+703,1);
			draw_rectangle(xx+36,yy+212,xx+1205,yy+702,1);
			x6=xx+1054;
		}
	    // Raid Box
	    if (bat_formation_type[formating]=2){
			draw_rectangle(xx+35,yy+211,xx+841,yy+703,1);
			draw_rectangle(xx+36,yy+212,xx+840,yy+702,1);
			x6=xx+684;
		}
    
	    draw_set_alpha(0.25);
		// Draw Enemy boxes
		draw_set_color(c_red);
	    y5=yy+224;
		for(var i=0; i<3; i++){
			draw_rectangle(x6,y5,x6+38,y5+464,0);
			x6+=50;
		}
    
		// Draw Secondary info box
	    draw_set_alpha(1);
		draw_set_color(c_gray);
	    draw_rectangle(xx+1221,yy+211,xx+1561,yy+703,1);
	    draw_rectangle(xx+1220,yy+212,xx+1560,yy+702,1);
	    draw_set_alpha(1);
    
	    draw_set_halign(fa_center);
	    draw_set_font(fnt_40k_30b);
    
	    // This is where the cursor is changed- needs to be smart and also pass the instance type
	    tooltip="";
		tooltip_other="";
		
	    if (collision_point(mouse_x,mouse_y,obj_formation_bar,1,1)) and (obj_cursor.image_index=0) then obj_cursor.image_index=3;
	    if (!collision_point(mouse_x,mouse_y,obj_formation_bar,1,1)) and (obj_cursor.image_index=3) then obj_cursor.image_index=0;
    
	    if (obj_cursor.image_index=3){
	        var theh=instance_position(mouse_x,mouse_y,obj_formation_bar);
	        if (instance_exists(theh)){
	            if (theh.unit_id=1){
					tooltip="Headquarters";
					tooltip2="You and your advisors will be placed within this section.  It is strongly advisable you give them backup in this same column.";
				}
	            if (theh.unit_id=2){
					tooltip="Honour Guard";
					tooltip2="Any Honour Guard within your Headquarters will be placed here.  The best place for them within the formation depends on loadout.";
				}
	            if (theh.unit_id=3){
					tooltip="Librarians";
					tooltip2="Epistolary, Lexicanum, and Codiciery make up this section.  They tend to deal decent damage and offer useful buffs for other units.";
				}
	            if (theh.unit_id=4){
					tooltip="Techmarines";
					tooltip2="Techmarines and their servitors are placed within this block.  It is advisable that they are placed near your vehicles and armour.";
				}
	            if (theh.unit_id=5){
					tooltip="Terminators";
					tooltip2="Any Terminators that you may have will be placed here.  They can very easily soak lots of damage and dish it back in return.";
				}
	            if (theh.unit_id=6){
					tooltip="Veterans";
					tooltip2="Veterans, the most experienced tacticals of your Chapter, are placed here.  Their best position in the formation depends on loadout.";
				}
	            if (theh.unit_id=7){
					tooltip="Tacticals";
					tooltip2="The greater bulk of your Chapter, the tactical marines, go here.  Tactical marines may be situated nearly anywhere.  Note that Apothecaries and Chaplains without jump-packs will also be placed here.";
				}
	            if (theh.unit_id=8){
					tooltip="Devastators";
					tooltip2="Devastators offer much long ranged firepower.  As a result they are best placed in the rear of your formation.";
				}
	            if (theh.unit_id=9){
					tooltip="Assaults";
					tooltip2="Assault marines are damage powerhouses, but tend to be squisher.  You may or may not wish for them to be on the front lines.  Note that Apothecaries and Chaplains with jump-packs will be placed here.";
				}
	            if (theh.unit_id=10){
					tooltip="Scouts";
					tooltip2="Scouts are not-yet full fledged Astartes.  Striking a balance between exposure to the enemy, for experience, and safety is key.";
				}
	            if (theh.unit_id=11){
					tooltip="Dreadnoughts";
					tooltip2="Dreadnoughts are the most durable and tough marines within your chapter.  They are best suited for the front lines.";
				}
	            if (theh.unit_id=12){
					tooltip="Hirelings";
					tooltip2="Any and all units that you recieve from other factions are placed within this block.";
				}
	            if (theh.unit_id=13){
					tooltip="Rhinos";
					tooltip2="Rhinos offer protection for units behind them but are not well armoured and lacking in firepower.";
				}
	            if (theh.unit_id=14){
					tooltip="Predators";
					tooltip2="Predators offer protection for units behind them and have a decent amount of long ranged firepower.";
				}
	            if (theh.unit_id=15){
					tooltip="Land Raiders";
					tooltip2="Land Raiders are incredibly tanky war machines that protect rear columns and offer tremendous amounts of firepower.  Other super-heavy vehicles will also be placed here.";
				}
	            too_img=theh.unit_id-1;
	        }
	    }
    
	    if (tooltip!=""){
	        draw_set_font(fnt_40k_30b);
	        draw_text_transformed(xx+1398,yy+213,string(tooltip),0.75,0.75,0);
	        draw_set_font(fnt_40k_14);draw_set_halign(fa_left);
	        draw_text_ext(xx+1227,yy+565,string(tooltip2),-1,323);
        
	        // draw_sprite(spr_formation_splash,too_img,xx+1271,yy+252);
	        scr_image("formation",too_img,xx+1271,yy+252,239,297);
	    }
    
    
	    /*
	    if (tool1!=""){
	        draw_set_alpha(1);
	        draw_set_font(fnt_40k_14);draw_set_halign(fa_left);draw_set_color(0);
	        draw_rectangle(mouse_x+18,mouse_y+20,mouse_x+string_width_ext(tool2,-1,500)+24,mouse_y+44+string_height_ext(tool2,-1,500),0);
	        draw_set_color(c_gray);
	        draw_rectangle(mouse_x+18,mouse_y+20,mouse_x+string_width_ext(tool2,-1,500)+24,mouse_y+44+string_height_ext(tool2,-1,500),1);
	        draw_set_font(fnt_40k_14b);draw_text(mouse_x+22,mouse_y+22,string(tool1));
	        draw_set_font(fnt_40k_14);draw_text_ext(mouse_x+22,mouse_y+42,string(tool2),-1,500);
	    }*/
	}

	if (menu=23){
	    if (settings>0){
	        var co=100;
			var ide;
			ide=settings;
        
	        draw_sprite_ext(spr_arrow,0,xx+25,yy+70,2,2,0,c_white,1);// Back
	        if (scr_hit(xx+25,yy+70,xx+25+64,yy+70+64)=true) and (mouse_left=1) and (cooldown<=0){
	            cooldown=8000;
				with(obj_mass_equip){instance_destroy();}
				menu=21;exit;
	        }
        
	        draw_set_halign(fa_center);
			draw_set_color(c_gray);
			draw_set_font(fnt_40k_30b);
	        draw_text_transformed(xx+800,yy+66,string(obj_ini.role[100,settings])+" Settings",1,1,0);
        
	        // New: 678,160
	        // Old: 444,550
	        // Dif: 234,-390
        
	        draw_set_font(fnt_40k_30b);
			draw_set_color(c_gray);
			draw_set_halign(fa_left);
	        draw_text_transformed(xx+678,yy+160,obj_ini.role[co,ide],0.6,0.6,0);
	        var wid,hei;
			wid=0;
			hei=string_height_ext(string(obj_ini.role[co,ide])+"Q",-1,580)*0.6;
	        draw_rectangle(xx+678-1,yy+160-1,xx+1056,yy+160+hei,1);
	        draw_set_color(c_gray);
			draw_set_font(fnt_40k_14b);
			draw_set_halign(fa_right);
        
            var title = "";
            var geh = "";
			spacing=22;
	        x5=xx+830;
			y5=yy+207-spacing;
        
	        for (var gg=1; gg<=5; gg++){
	            y5+=spacing;
	            if (gg=1){
					title="Main Weapon: ";
					geh=obj_ini.wep1[co,ide];
				}
	            if (gg=2){
					title="Secondary Weapon: ";
					geh=obj_ini.wep2[co,ide];
				}
	            if (gg=3){
					title="Armour: ";
					geh=obj_ini.armour[co,ide];
				}
	            if (gg=4){
					title="Special Item: ";
					geh=obj_ini.gear[co,ide];
				}
	            if (gg=5){
					title="Mobility Item: ";
					geh=obj_ini.mobi[co,ide];
				}
            
	            draw_set_halign(fa_right);
				draw_set_color(c_gray);
	            draw_rectangle(x5,y5,x5-string_width(title),y5+string_height(title)-2,0);
	            draw_set_color(0);draw_text(x5,y5,string(title));
            
	            if (scr_hit(x5-string_width(title),y5,x5,y5+string_height(title)-2)=true){
	                draw_set_color(c_white);
					draw_set_alpha(0.2);
	                draw_rectangle(x5,y5,x5-string_width(title),y5+string_height(title)-2,0);
                
	                var nep=false;
					
	                if ((obj_ini.armour[co,ide]="Terminator Armour") or (obj_ini.armour[co,ide]="Dreadnought")) and (gg=4) then nep=true;
	                if (ide=6) and ((gg=3) or (gg=5)) then nep=true;
                
                    if (obj_controller.mouse_left == 1 && obj_controller.cooldown <= 0 && !nep) {
                        obj_controller.cooldown=8000;
                        if (obj_mass_equip.tab != 0) {
                            obj_mass_equip.refresh = true;
                        } else if (obj_mass_equip.tab == 0) {
                            obj_mass_equip.tab = gg;
                            obj_mass_equip.item_name = [];
                            var is_hand_slot = (gg == 1 || gg == 2);
                            scr_get_item_names(
                                obj_mass_equip.item_name,
                                obj_controller.settings, // eROLE
                                gg, // slot
                                is_hand_slot ? (
                                    obj_mass_equip.tab == 1 ? eENGAGEMENT.Ranged : eENGAGEMENT.Melee
                                ) : eENGAGEMENT.None,
                                true, // include company standard
                                false, // show all regardless of inventory
                            );
                        }
                    }
	            }
	            draw_set_alpha(1);
	            draw_set_color(c_gray);
	            draw_set_halign(fa_left);
	            draw_text(x5+5,y5,string(geh));
	        }
	    }
	}


	if (menu=21){
		// Reset vars
		tool1="";
		tool2="";
	    draw_set_halign(fa_center);
		draw_set_color(c_gray);
		draw_set_font(fnt_40k_30b);
	    draw_text_transformed(xx+800,yy+66,string(global.chapter_name)+" Chapter Settings",1,1,0);
	    draw_text_transformed(xx+800,yy+110,"(Codex Compliant)",0.6,0.6,0);
	    draw_set_font(fnt_40k_14);
		draw_set_halign(fa_left);
    
	    yy-=64;
    

		cx = xx + 31;
		cy = yy + 203;
		che = progenitor_visuals;
		draw_sprite(spr_creation_check, che + 2, cx, cy);

		var _option_name = "Progenitor Livery";
		draw_text(cx + 35, cy, _option_name);

		if (scr_hit(cx, cy, cx + string_width(_option_name) + 35, cy + sprite_get_height(spr_creation_check))) {
			tool1 = _option_name;
			tool2 = "Turned off by default. \nWhen turned on, various unit visuals may change depending on your progenitor chapter.";
			if ((mouse_left=1) and (cooldown<=0)) {
				progenitor_visuals = !progenitor_visuals;
				cooldown=8000;
			}
		}

		
	    draw_text(xx+66,yy+238,"Allow Astartes Transfer");
	    che=command_set[1];
		cx=xx+31;
		cy=yy+234;
		
	    draw_sprite(spr_creation_check,che+2,cx,cy);
	    if (scr_hit(cx+31,cy,cx+260,cy+20)=true){
			tool1="Allow Astartes Transfer";
			tool2="Turned off by default. Allows you to transfer Astartes in the same way as vehicles.";
		}
	    if (scr_hit(cx,cy,cx+32,cy+32)=true) and (mouse_left=1) and (cooldown<=0){
			var onceh;
			onceh=0;cooldown=8000;
			if (onceh=0) and (command_set[1]=0){
				onceh=1;
				command_set[1]=1;
			}
			if (onceh=0) and (command_set[1]=1){
				onceh=1;
				command_set[1]=0;
			}
		}
    
	    draw_text(xx+66,yy+273,"Codex Compliant Organization");
	    che=command_set[2];
		cx=xx+31;
		cy=yy+269;
		
	    draw_sprite(spr_creation_check,che+2,cx,cy);
	    if (scr_hit(cx+31,cy,cx+300,cy+20)=true){
			tool1="Codex Compliant Organization";
			tool2="When enabled, marine promotions are limited based on their current company and EXP, overall following the Codex Astartes promotion sequence." + "\n\n" + "When disabled, you can promote marines to any company, from any company, disregarding any EXP requirements." + "\n" + "Terminators, Dreadnoughts and Company Command roles retain EXP requirements however.";
		}
	    if (scr_hit(cx,cy,cx+32,cy+32)=true) and (mouse_left=1) and (cooldown<=0){
			var onceh=0;
			cooldown=8000;
			if (onceh=0) and (command_set[2]=1){
				onceh=1;
				command_set[2]=0;
			}
			if (onceh=0) and (command_set[2]=0){
				onceh=1;
				command_set[2]=1;
			}
		}
    
	    draw_text(xx+66,yy+308,"Modest Livery");
	    che=modest_livery;
		cx=xx+31;
		cy=yy+304;
		
	    draw_sprite(spr_creation_check,che+2,cx,cy);
	    if (scr_hit(cx+31,cy,cx+300,cy+20)=true){
			tool1="Modest Livery";
			tool2="Turned off by default.  Prevents Advantages and Disadvantages from changing the appearances of your marines, effectively disabling any special ornamentation or possible battle wear.";
		}
	    if (scr_hit(cx,cy,cx+32,cy+32)=true) and (mouse_left=1) and (cooldown<=0){
			var onceh=0;
			cooldown=8000;
			if (onceh=0) and (modest_livery=0){
				onceh=1;
				modest_livery=1;
			}
			if (onceh=0) and (modest_livery=1){
				onceh=1;
				modest_livery=0;
			}
		}
    
	    yy+=35;
    
	    draw_text(xx+28,yy+332,"Company Command Structure");
		
	    if (scr_hit(xx+28,yy+332,xx+316,yy+352)=true){
			tool1="Comany Command Structure";
			tool2="The default members of your Company Command.";
		}
    
	    draw_text(xx+66,yy+359,"Captain");
	    draw_text(xx+66,yy+386,"Standard Bearer");
	    draw_text(xx+66,yy+413,"Champion");
	    draw_text(xx+66,yy+440,"Chaplain");
	    draw_text(xx+66,yy+467,"Apothecary");
	    draw_text(xx+66,yy+494,"Librarian");
	    draw_text(xx+66,yy+521,"Techmarine");
    
	    che=command_set[3];
		cx=xx+31;
		cy=yy+355;
		
		draw_sprite(spr_creation_check,che+2,cx,cy);
	    if (scr_hit(cx,cy,cx+32,cy+32)=true) and (mouse_left=1) and (cooldown<=0){
			var onceh=0;
			cooldown=8000;
			if (onceh=0) and (command_set[3]=0){
			onceh=1;
			command_set[3]=1;
			}
			if (onceh=0) and (command_set[3]=1){
				onceh=1;
				command_set[3]=0;
			}
		}
    
	    che=command_set[4];
		cx=xx+31;
		cy=yy+382;
		draw_sprite(spr_creation_check,che+2,cx,cy);
		
	    if (scr_hit(cx,cy,cx+32,cy+32)=true) and (mouse_left=1) and (cooldown<=0){
			var onceh=0;
			cooldown=8000;
			if (onceh=0) and (command_set[4]=0){
				onceh=1;
				command_set[4]=1;
			}
			if (onceh=0) and (command_set[4]=1){
				onceh=1;
				command_set[4]=0;
			}
		}
    
	    che=command_set[5];
		cx=xx+31;
		cy=yy+409;
		draw_sprite(spr_creation_check,che+2,cx,cy);
		
	    if (scr_hit(cx,cy,cx+32,cy+32)=true) and (mouse_left=1) and (cooldown<=0){
			var onceh=0;
			cooldown=8000;
			if (onceh=0) and (command_set[5]=0){
				onceh=1;
				command_set[5]=1;
			}
			if (onceh=0) and (command_set[5]=1){
				onceh=1;
				command_set[5]=0;
			}
		}
    
	    che=command_set[6];
		cx=xx+31;
		cy=yy+436;
		draw_sprite(spr_creation_check,che+2,cx,cy);
		
	    if (scr_hit(cx,cy,cx+32,cy+32)=true) and (mouse_left=1) and (cooldown<=0){
			var onceh=0;
			cooldown=8000;
			if (onceh=0) and (command_set[6]=0){
				onceh=1;
				command_set[6]=1;
			}
			if (onceh=0) and (command_set[6]=1){
				onceh=1;
				command_set[6]=0;
			}
		}
    
	    che=command_set[7];
		cx=xx+31;
		cy=yy+463;
		draw_sprite(spr_creation_check,che+2,cx,cy);
		
	    if (scr_hit(cx,cy,cx+32,cy+32)=true) and (mouse_left=1) and (cooldown<=0){
			var onceh=0;
			cooldown=8000;
			if (onceh=0) and (command_set[7]=0){
				onceh=1;
				command_set[7]=1;
			}
			if (onceh=0) and (command_set[7]=1){
				onceh=1;
				command_set[7]=0;
			}
		}
    
	    che=command_set[8];
		cx=xx+31;
		cy=yy+490;
		draw_sprite(spr_creation_check,che+2,cx,cy);
		
	    if (scr_hit(cx,cy,cx+32,cy+32)=true) and (mouse_left=1) and (cooldown<=0){
			var onceh=0;
			cooldown=8000;
			if (onceh=0) and (command_set[8]=0){
				onceh=1;
				command_set[8]=1;
			}
			if (onceh=0) and (command_set[8]=1){
				onceh=1;
				command_set[8]=0;
			}
		}
    
	    che=command_set[9];
		cx=xx+31;
		cy=yy+517;
		draw_sprite(spr_creation_check,che+2,cx,cy);
		
	    if (scr_hit(cx,cy,cx+32,cy+32)=true) and (mouse_left=1) and (cooldown<=0){
			var onceh=0;
			cooldown=8000;
			if (onceh=0) and (command_set[9]=0){
				onceh=1;
				command_set[9]=1;
			}
			if (onceh=0) and (command_set[9]=1){
				onceh=1;
				command_set[9]=0;
			}
		}
    
	    yy-=35;
    
	    draw_text(xx+28,yy+611,"Boarding Objective");
	    if (scr_hit(xx+28,yy+611,xx+316,yy+611+20)=true){
			tool1="Boarding Objective";
			tool2="The objective of your Astartes once they board an enemy ship.";
		}
    
	    draw_text(xx+66,yy+611+27,"Damage Systems");
	    draw_text(xx+86,yy+611+54,"Use Plasma Bombs");
	    draw_text(xx+66,yy+611+81,"Commandeer Ship");
    
	    che=command_set[20];
		cx=xx+31;
		cy=yy+611+23;draw_sprite(spr_creation_check,che+2,cx,cy);
		
	    if (scr_hit(cx+31,cy,cx+260,cy+20)=true){
			tool1="Damage Systems";
			tool2="Your Astartes will attempt to disable the ship by attacking the ship bridge and systems.";
		}
	    if (scr_hit(cx,cy,cx+32,cy+32)=true) and (mouse_left=1) and (cooldown<=0){
			var onceh=0;
			cooldown=8000;
			if (onceh=0) and (command_set[20]=0){
				onceh=1;
				command_set[20]=1;
				command_set[22]=0;
			}
		}
    
	    che=command_set[21];
		cx=xx+51;
		cy=yy+611+50;
		draw_sprite(spr_creation_check,che+2,cx,cy);
		
	    if (scr_hit(cx+31,cy,cx+260,cy+20)=true){
			tool1="Use Plasma Bombs";
			tool2="Your Astartes will use equipped Plasma Bombs to massively damage the boarded ship.";
		}
	    if (scr_hit(cx,cy,cx+32,cy+32)=true) and (mouse_left=1) and (cooldown<=0){
			var onceh=0;
			cooldown=8000;
			if (onceh=0) and (command_set[21]=0) and (command_set[22]=0){
				onceh=1;
				command_set[21]=1;
			}
			if (onceh=0) and (command_set[21]=1){
				onceh=1;
				command_set[21]=0;
			}
		}
    
	    draw_set_alpha(0.5);
	    che=command_set[22];
		cx=xx+31;
		cy=yy+611+77;
		draw_sprite(spr_creation_check,che+2,cx,cy);
		
	    if (scr_hit(cx+31,cy,cx+260,cy+20)=true){
			tool1="Commandeer Ship";
			tool2="Your Astartes will attempt to commandeer the vessel, to be permenantely used or salvaged.";
		}
	    if (scr_hit(cx,cy,cx+32,cy+32)=true) and (mouse_left=100) and (cooldown<=0){
			var onceh=0;
			cooldown=8000;
			if (onceh=0) and (command_set[22]=0){
				onceh=1;
				command_set[22]=1;
				command_set[20]=0;
				command_set[21]=0;
			}
		}
	    draw_set_alpha(1);
    
	    // 59 lower
    
	    if (command_set[22]=1) then draw_set_alpha(0.5);
	    draw_text(xx+28,yy+747,"Post-Boarding");
	    if (scr_hit(xx+28,yy+747,xx+316-150,yy+767)=true){
			tool1="Post-Boarding";
			tool2="What your Boarders will do after achieving their objective.  This is disabled if your objective is to Commandeer the enemy ships.";
		}
    
	    draw_text(xx+66,yy+747+27,"Board Next Nearest");
	    draw_text(xx+86,yy+747+54,"Return and Recuperate");
    
	    che=command_set[23];
		if (command_set[22]=1) then che=0;
		cx=xx+31;
		cy=yy+747+23;
		draw_sprite(spr_creation_check,che+2,cx,cy);
	    if (scr_hit(cx+31,cy,cx+260-70,cy+20)=true){
			tool1="Board Next Nearest";
			tool2="After disabling an enemy vessel your Astartes will launch a new boarding mission at the nearest enemy.";
		}
	    if (scr_hit(cx,cy,cx+32,cy+32)=true) and (mouse_left=1) and (cooldown<=0){
			var onceh=0;
			cooldown=8000;
			if (onceh=0) and (command_set[23]=0) and (command_set[22]=0){
				onceh=1;
				command_set[23]=1;
				command_set[24]=0;
			}
		}
    
	    che=command_set[24];
		if (command_set[22]=1) then che=0;
		cx=xx+51;
		cy=yy+747+50;
		draw_sprite(spr_creation_check,che+2,cx,cy);
	    if (scr_hit(cx+31,cy,cx+260-70,cy+20)=true){
			tool1="Return and Recuperate";
			tool2="After disabling an enemy vessel your Astartes will return to their mother vessel and heal.";
		}
	    if (scr_hit(cx,cy,cx+32,cy+32)=true) and (mouse_left=1) and (cooldown<=0){
			var onceh=0;
			cooldown=8000;
			if (onceh=0) and (command_set[24]=0) and (command_set[22]=0){
				onceh=1;
				command_set[24]=1;command_set[23]=0;
			}
		}
	    draw_set_alpha(1);
    
    
	    xx+=260;
	    draw_text(xx+28,yy+747,"Automatic Boarding");
	    if (scr_hit(xx+28,yy+747,xx+316,yy+767)=true){
			tool1="Automatic Boarding";
			tool2="If checked your ships will launch Boarding teams automatically when an eligible target is in range.";
		}
    
	    draw_text(xx+66,yy+747+27,"Battleships");
	    draw_text(xx+86,yy+747+54,"Cruisers");
    
	    che=command_set[25];
		cx=xx+31;
		cy=yy+747+23;
		
		draw_sprite(spr_creation_check,che+2,cx,cy);
	    if (scr_hit(cx,cy,cx+32,cy+32)=true) and (mouse_left=1) and (cooldown<=0){
			var onceh=0;
			cooldown=8000;
			if (onceh=0) and (command_set[25]=0){
				onceh=1;
				command_set[25]=1;
			}
			if (onceh=0) and (command_set[25]=1){
				onceh=1;
				command_set[25]=0;
			}
		}
    
	    che=command_set[26];
		cx=xx+51;
		cy=yy+747+50;
		draw_sprite(spr_creation_check,che+2,cx,cy);
		
	    if (scr_hit(cx,cy,cx+32,cy+32)=true) and (mouse_left=1) and (cooldown<=0){
			var onceh=0;
			cooldown=8000;
			if (onceh=0) and (command_set[26]=0){
				onceh=1;
				command_set[26]=1;
			}
			if (onceh=0) and (command_set[26]=1){
				onceh=1;
				command_set[26]=0;
			}
		}
	    xx-=260;
	    yy+=64;
    
	    draw_text(xx+937-341,yy+207,"Battle Formations");
	    draw_text(xx+937,yy+207,"Company Settings");
	    draw_text(xx+1278,yy+207,"Astartes Role Settings");
    
	    // Role Settings
	    var ide,xxx,yyy;
		ide=0;
		xxx=xx+1277;yyy=yy+250-31;
    
	    for (var derpaderp=1; derpaderp<=14; derpaderp++){
	        if (derpaderp=1) then ide=15;
	        if (derpaderp=2) then ide=14;
	        if (derpaderp=3) then ide=17;
	        if (derpaderp=4) then ide=16;
	        if (derpaderp=5) then ide=5;
	        if (derpaderp=6) then ide=7;
	        if (derpaderp=7) then ide=2;
	        if (derpaderp=8) then ide=4;
	        if (derpaderp=9) then ide=3;
	        if (derpaderp=10) then ide=6;
	        if (derpaderp=11) then ide=8;
	        if (derpaderp=12) then ide=9;
	        if (derpaderp=13) then ide=10;
	        if (derpaderp=14) then ide=12;
        
	        draw_set_alpha(1);
	        if (obj_ini.race[100,ide]!=0){// Creates mass_equip here
	            // if (custom<2) then draw_set_alpha(0.5);
	            yyy+=31;
				draw_set_color(c_gray);
				draw_rectangle(xxx,yyy,xxx+289,yyy+20,0);
	            draw_set_color(0);
				draw_text(xxx,yyy,obj_ini.role[100,ide]);
	            if (scr_hit(xxx,yyy,xxx+289,yyy+20)=true){/*if (custom=2) then draw_set_alpha(0.2);if (custom<2) then */
					draw_set_alpha(0.1);
					draw_set_color(c_white);
					draw_rectangle(xxx,yyy,xxx+289,yyy+20,0);
	                draw_set_alpha(1);
	                tool1=string(obj_ini.role[100,ide])+" Settings";
					tool2="Click to open the settings for this unit.";
	                if (mouse_left>=1) and (cooldown<=0){
						settings=ide;
						menu=23;
						cooldown=8000;
						with(obj_mass_equip){instance_destroy();}
						instance_create(0,0,obj_mass_equip);
					}
	            }
	        }
	    }
	    
		xxx=xx+936;
		yyy=yy+250-31;
		
	    for (var ides=0; ides<=10; ides++){
	        draw_set_alpha(1);
	        // if (custom<2) then draw_set_alpha(0.5);
	        yyy+=31;draw_set_color(c_gray);draw_rectangle(xxx,yyy,xxx+289,yyy+20,0);
	        draw_set_color(0);
        
	        var shw="";
	        if (ides=0) then shw="Headquarters";
	        if (ides>0) then shw=romanNumerals[ides - 1] + " Company";
	        draw_text(xxx,yyy,string(shw));
        
	        if (scr_hit(xxx,yyy,xxx+289,yyy+20)=true){/*if (custom=2) then draw_set_alpha(0.2);if (custom<2) then */
				draw_set_alpha(0.1);
				draw_set_color(c_white);
				draw_rectangle(xxx,yyy,xxx+289,yyy+20,0);
	            draw_set_alpha(1);
	            tool1=string(shw)+" Settings";
				tool2="Click to open the settings for this company.";
	            // if (mouse_left>=1) and (cooldown<=0){settings=ides;menu=22;cooldown=8000;}
	        }
	    }
    
	    xxx=xx+936-341;
		yyy=yy+250-31;

	    for(var i=1; i<=11;i++){
	        draw_set_alpha(1);
	        // if (custom<2) then draw_set_alpha(0.5);
	        yyy+=31;draw_set_color(c_gray);
        
	        if (bat_formation[i]!="") then draw_rectangle(xxx,yyy,xxx+289,yyy+20,0);
	        if (i>2){if (bat_formation[i]="") and (bat_formation[i-1]!="") then draw_rectangle(xxx,yyy,xxx+289,yyy+20,0);}
        
	        draw_set_color(0);
        
	        var shw="",isnew=false;
	        shw=string(bat_formation[i]);
        
	        if (i>3){
				if (bat_formation_type[i]=1) then shw="A] "+string(shw);
				if (bat_formation_type[i]=2) then shw="R] "+string(shw);
			}
	        if (i>2){
				if (shw="") and (bat_formation[i-1]!=""){
					isnew=true;shw="(New Formation)";
				}
			}
        
	        if (shw!="") or (isnew=true){
				draw_text(xxx,yyy,string(shw));
	            if (scr_hit(xxx,yyy,xxx+289,yyy+20)=true){/*if (custom=2) then draw_set_alpha(0.2);if (custom<2) then */
					draw_set_alpha(0.1);
					draw_set_color(c_white);
					draw_rectangle(xxx,yyy,xxx+289,yyy+20,0);
	                draw_set_alpha(1);
                
	                if (i<=3) then tool1=string(shw)+" Settings";tool2="Click to open the settings for this formation.";
	                if (i>3){
	                    if (bat_formation[i]!=""){
							tool1=string(bat_formation[i])+" Settings";
							tool2="Click to open the settings for this formation.";
						}
	                    if (bat_formation[i]=""){
							tool1="New Custom Formation";
							tool2="Click to open and create a new Battle Formation for Ground combat or Raiding.";
						}
	                }
                
	                if (mouse_left>=1) and (cooldown<=0){
	                    formating=i;
						menu=24;
						cooldown=8000;
						scr_ui_formation_bars();
	                    if (bat_formation[formating]=""){
	                        bat_formation[formating]="Custom"+string(formating-3);
	                        bat_formation_type[formating]=1;
	                        bat_deva_for[formating]=1;
	                        bat_assa_for[formating]=4;
	                        bat_tact_for[formating]=2;
	                        bat_vete_for[formating]=2;
	                        bat_hire_for[formating]=3;
	                        bat_libr_for[formating]=3;
	                        bat_comm_for[formating]=3;
	                        bat_tech_for[formating]=3;
	                        bat_term_for[formating]=3;
	                        bat_hono_for[formating]=3;
	                        bat_drea_for[formating]=5;
	                        bat_rhin_for[formating]=6;
	                        bat_pred_for[formating]=7;
	                        bat_land_for[formating]=7;
	                        bat_scou_for[formating]=1;
	                    }
	                }
	            }
	        }
	    }
    
		if (tool1!=""){
			tooltip_draw(tool2,,,,,tool1);
		}
	}
}
