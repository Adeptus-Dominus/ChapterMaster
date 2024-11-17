function scr_creation(argument0) {



	if (argument0=2) and (custom>0){
	    if (name_bad=1){cooldown=8000;/*(sound_play(bad);*/}
	    if (name_bad=0){
	        change_slide=1;goto_slide=3;cooldown=8000;race[100,17]=1;
	        if (scr_has_disadv("Psyker Intolerant")) then race[100,17]=0;
	    }
	}

	if (argument0=2) and (custom=0){
	    change_slide=1;goto_slide=3;cooldown=8000;race[100,17]=1;race[100,14]=1;
	    if (scr_has_disadv("Psyker Intolerant")) then race[100,17]=0;
	    if (chapter="Iron Hands") or (chapter="Space Wolves") then race[100,14]=0;
	}


	if (floor(argument0)==3) and (recruiting_name!=homeworld_name){
	    change_slide=1;goto_slide=4;cooldown=8000;alarm[0]=1;
    
	    if (argument0=3.5){
	        if (color_to_main!=""){var q,good;q=0;good=0;repeat(30){q+=1;if (color_to_main=col[q]) and (good=0){good=q;color_to_main="";main_color=q;}}}
	        if (color_to_secondary!=""){var q,good;q=0;good=0;repeat(30){q+=1;if (color_to_secondary=col[q]) and (good=0){good=q;color_to_secondary="";secondary_color=q;}}}
	        if (color_to_trim!=""){var q,good;q=0;good=0;repeat(30){q+=1;if (color_to_trim=col[q]) and (good=0){good=q;color_to_trim="";trim_color=q;}}}
	        if (color_to_pauldron!=""){var q,good;q=0;good=0;repeat(30){q+=1;if (color_to_pauldron=col[q]) and (good=0){good=q;color_to_pauldron="";pauldron_color=q;}}}
	        if (color_to_pauldron2!=""){var q,good;q=0;good=0;repeat(30){q+=1;if (color_to_pauldron2=col[q]) and (good=0){good=q;color_to_pauldron2="";pauldron2_color=q;}}}
	        if (color_to_lens!=""){var q,good;q=0;good=0;repeat(30){q+=1;if (color_to_lens=col[q]) and (good=0){good=q;color_to_lens="";lens_color=q;}}}
	        if (color_to_weapon!=""){var q,good;q=0;good=0;repeat(30){q+=1;if (color_to_weapon=col[q]) and (good=0){good=q;color_to_weapon="";weapon_color=q;}}}
	    }
	}
            
	if (argument0=4){
	    if (hapothecary!="") and (hchaplain!="") and (clibrarian!="") and (fmaster!="") and (recruiter!="") and (admiral!="") and (battle_cry!=""){
	        change_slide=1;goto_slide=5;cooldown=8000;
        
	        if (custom=2){
	            mutations_selected=0;
	            preomnor=0;voice=0;doomed=0;lyman=0;omophagea=0;ossmodula=0;membrane=0;
	            zygote=0;betchers=0;catalepsean=0;secretions=0;occulobe=0;mucranoid=0;
	            if (purity>=1) then mutations=4;
	            if (purity>=2) then mutations=3;
	            if (purity>=4) then mutations=2;
	            if (purity>=7) then mutations=1;
	            if (purity=10) then mutations=0;
	        }
        
	        if (custom>0){
	            disposition[0]=0;
	            disposition[1]=0;// Prog
	            disposition[2]=0;// Imp
	            disposition[3]=0;// Mech
	            disposition[4]=0;// Inq
	            disposition[5]=0;// Ecclesiarchy
	            disposition[6]=0;// Astartes
	            disposition[7]=0;// Reserved
            
	            disposition[1]=60;disposition[6]=50;
	            if (founding=3) then disposition[1]=70;
	            if (founding=4) then disposition[1]=50;
	            if (founding=8) then disposition[1]=70;
            
	            disposition[2]=50;
	            disposition[3]=40;
	            disposition[4]=30;
	            disposition[5]=40;
            
	            if (strength>5) then disposition[4]-=(strength-5)*2;
	            if (purity<6) then disposition[4]-=5;
	            if (founding=10) then disposition[4]-=5;
            
	            if (cooperation<5){
	                disposition[6]-=(6-cooperation)*2;
	                disposition[5]-=(6-cooperation)*2;
	                disposition[4]-=(6-cooperation);
	                disposition[3]-=(6-cooperation);
	                disposition[2]-=(6-cooperation)*2;
	            }
            //TODO encode this logic into advantage/disadvantage structs to be more maintainable and less hardcoded
	            var ahuh,k;ahuh=0;k=0;
	            repeat(8){k+=1;if (adv[k]="Crafters") then ahuh=1;}
	            if (ahuh=1) then disposition[3]+=2;ahuh=0;k=0;
            
	            repeat(8){k+=1;if (adv[k]="Tech-Brothers") then ahuh=1;}
	            if (ahuh=1) then disposition[3]+=10;ahuh=0;k=0;
            
	            repeat(8){k+=1;if (adv[k]="Psyker Intolerant") then ahuh=1;}
	            if (ahuh=1) then disposition[4]+=5;ahuh=0;k=0;
            
	            repeat(8){k+=1;if (adv[k]="Daemon Binders") then ahuh=1;}
	            if (ahuh=1) then disposition[3]-=8;ahuh=0;k=0;
            
	            repeat(8){k+=1;if (adv[k]="Sieged") then ahuh=1;}
	            if (ahuh=1) then disposition[6]+=5;ahuh=0;k=0;
            
	            repeat(8){k+=1;if (adv[k]="Suspicious") then ahuh=1;}
	            if (ahuh=1) then disposition[4]-=15;ahuh=0;k=0;
            
	            repeat(8){k+=1;if (adv[k]="Tech-Heresy") then ahuh=1;}
	            if (ahuh=1) then disposition[3]-=8;ahuh=0;k=0;
            
	            repeat(8){k+=1;if (adv[k]="Psyker Abundance") then ahuh=1;}
	            if (ahuh=1) then disposition[4]-=4;ahuh=0;k=0;
            
	            repeat(8){k+=1;if (dis[k]="Tolerant") then ahuh=1;}
	            if (ahuh=1){
	                disposition[1]-=5;disposition[2]-=5;disposition[4]-=5;
	                disposition[3]-=5;disposition[5]-=5;disposition[6]-=5;
	            }ahuh=0;k=0;
	        }
	    }
	}

	// 5 to 6
	if (argument0=5){
	    if (custom=0) or (mutations<=mutations_selected){change_slide=1;goto_slide=6;cooldown=8000;}
	}

	// 6 to finish
	if (argument0=6){
	    if (chapter_master_name!="") and (chapter_master_melee!=0) and (chapter_master_ranged!=0) and (chapter_master_specialty!=0){
	        global.icon_name=obj_creation.icon_name;
	        cooldown=9999;instance_create(0,0,obj_ini);audio_stop_all();
	        audio_play_sound(snd_royal,0,true);
	        audio_sound_gain(snd_royal,0,0);
	        var nope;nope=0;if (master_volume=0) or (music_volume=0) then nope=1;
	        if (nope!=1){audio_sound_gain(snd_royal,0.25*master_volume*music_volume,2000);}
        
	        if (founding=8) or (chapter="Salamanders") then obj_ini.skin_color=1;
	        if (chapter!="Salamanders") and (founding!=8) and (secretions=1){
	            obj_ini.skin_color=choose(2,3,4);
	        }
        
	        room_goto(Game);
	    }
	}


}
