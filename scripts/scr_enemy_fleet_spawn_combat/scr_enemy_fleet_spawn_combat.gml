function start_enemy_fleet_spawn(){


    var total_enemies=0;
    var total_allies=1;
    var spawner=0;
    var t=0,y1=0,y2=0,tt=0;

    repeat(6){
        t+=1;
        if (enemy[t]!=0){
            if (enemy_status[t]<0){
                total_enemies+=1;
            }
            else if (enemy_status[t]>0){
                total_allies+=1;
            }
            
            // show_message("Computer "+string(t)+":"+string(enemy[t])+", status:"+string(enemy_status[t]));
        }
    }



    if (total_enemies>0){
        t=1;
        y2=room_height/total_enemies/2;tt=0;
        for (var fug=1;fug<=5;fug++){
            if (enemy_status[fug]<0){
                tt+=1;
                y1=(t*y2);
                
                spawner=instance_create(room_width+200,y1,obj_fleet_spawner);
                spawner.owner=enemy[fug];
                spawner.height=(y2);
                spawner.number=fug;
                
                t+=2;
            }
        }
    }

    if (total_allies>0){
        y1=0;
        t=1;
        y2=room_height/total_allies/2;
        tt=0;
        for (var fug=1;fug<=5;fug++){
            if (enemy_status[fug]>0){
                tt+=1;
                y1=(t*y2);
                
                spawner=instance_create(200,y1,obj_fleet_spawner);
                
                if (fug=1) then spawner.owner  = eFACTION.Player;
                if (fug>1) then spawner.owner=enemy[fug];// Get the ENEMY after the actual enemies
                
                spawner.height=(y2);
                spawner.number=fug;
                
                t+=2;
            }
        }
    }


    // show_message("Total Enemies: "+string(total_enemies));
    // show_message("Total Allies: "+string(total_allies));


    // Buffs here
    // if (ambushers=1) or (enemy=8) then 
    attack_mode="offensive";
    // if (enemy=9) then attack_mode="defensive";

    if (ambushers=1 && ambushers=999) then global_attack=global_attack*1.1;// Need to finish this
    if (bolter_drilling=1) then global_bolter=global_bolter*1.1;
    // if (enemy_eldar=1) and (enemy=6){global_attack=global_attack*1.1;global_defense=global_defense*1.1;}
    // if (enemy_fallen=1) and (enemy=10){global_attack=global_attack*1.1;global_defense=global_defense*1.1;}
    // if (enemy_orks=1) and (enemy=7){global_attack=global_attack*1.1;global_defense=global_defense*1.1;}
    // if (enemy_tau=1) and (enemy=8){global_attack=global_attack*1.1;global_defense=global_defense*1.1;}
    // if (enemy_tyranids=1) and (enemy=10){global_attack=global_attack*1.1;global_defense=global_defense*1.1;}
    if (siege=1) and (siege=555) then global_attack=global_attack*1.2;// Need to finish this
    if (slow=1){global_attack=global_attack*0.9;global_defense=global_defense*1.2;}
    if (melee=1) then global_melee=global_melee*1.15;
    // 
    if (shitty_luck=1){
    	global_defense=global_defense*0.9;
    }
    // if (lyman=1) and (dropping=1) then ||| handle within each object
    if (ossmodula=1){
    	global_attack=global_attack*0.95;
    	global_defense=global_defense*0.95;
    }
    if (betchers=1){
    	global_melee=global_melee*0.95;
    }
    if (catalepsean=1){
    	global_attack=global_attack*0.95;
    }
    // if (occulobe=1){if (time=5) or (time=6) then global_attack=global_attack*0.7;global_defense=global_defense*0.9;}

    // More prep for player

    var i=0,k=0,onceh=0;

    // instance_activate_object(obj_combat_info);

    capital_max=capital;
    frigate_max=frigate;
    escort_max=escort;
    // alarm[1]=2;s
    /* */
    /*  */    
}


function setup_fleet_spawn_characteristics(){



	if (number=1){
	    // create blocks of infantry
	    
	    
	    var i=0,k=0,x2=224,hei=0,man=0,sizz=0;
	    

	    sort_ships_into_columns(obj_fleet);

	    with (obj_fleet){
	        player_fleet_ship_spawner();
	    }
	    
	    
	}

	if (number>0) and (owner!=1){

	    en_escort=obj_fleet.en_escort[number];
	    en_frigate=obj_fleet.en_frigate[number];
	    en_capital=obj_fleet.en_capital[number];

	    
	    if (owner = eFACTION.Imperium){
	        if (en_escort>0){
	            en_column[4]="Sword Class Frigate";
	            en_num[4]=en_escort;
	            en_size[4]=1;
	        }
	        
	        if (en_frigate>0){
	        	en_column[3]="Avenger Class Grand Cruiser";
	        	en_num[3]=en_frigate;
	        	en_size[3]=2;
	        }
	            
	        var i=0;
	        i=en_capital;
	        if (i>0){
	            en_column[2]="Apocalypse Class Battleship";
	            en_num[2]=floor(random(i))+1;
	            if (en_num[2]<(en_capital*0.6)){
	            	en_num[2]=round(en_capital*0.6);
	            }
	            i-=en_num[2];
	            en_size[2]=3;
	        }
	        
	        if (i>0){
	        	en_column[1]="Nemesis Class Fleet Carrier";
	        en_num[1]=i;
	        i-=en_num[1];
	        en_size[1]=3;}
	    }
	    
	    
	    
	    if (owner = eFACTION.Eldar){
	        if (en_escort>0){
	        	en_column[4]="Aconite";
	        en_num[4]=max(1,floor(en_escort/2));
	        en_size[4]=1;}
	        if (en_escort>1){
	        	en_column[3]="Hellebore";
	        en_num[3]=max(1,floor(en_escort/2));
	        en_size[3]=1;}
	        if (en_frigate>0){
	        	en_column[2]="Shadow Class";
	        en_num[2]=en_frigate;
	        en_size[2]=2;}
	        if (en_capital>0){
	        	en_column[1]="Void Stalker";
	        en_num[1]=en_capital;
	        en_size[1]=3;}
	    }
	    
	    
	    
	    
	    if (owner = eFACTION.Ork){
	        var i;
	        i=0;
	        i=en_capital;
	        
	        if (i>0){
	        	en_column[1]="Dethdeala";
		        en_num[1]=floor(random(i))+1;
		        i-=en_num[1];
		        en_size[1]=3;
		    }
		        
	        if (i>0){
	        	en_column[2]="Gorbag's Revenge";
		        en_num[2]=floor(random(i))+1;
		        i-=en_num[2];
		        en_size[2]=3;
		    }// en_num[2]+=en_num[1]+1;
	        
	        if (i>0){
	        	en_column[3]="Kroolboy";
		        en_num[3]=i;
		        i-=en_num[3];
		        en_size[3]=3;
		    }// en_num[3]+=en_num[2]+1;
	        
	        if (en_frigate>0){
	        	en_column[4]="Battlekroozer";
		        en_num[4]=en_frigate;
		        en_size[4]=2;
		    }// en_num[4]+=en_num[3]+1;
	        
	        if (en_escort>0){
	        	en_column[5]="Ravager";
		        en_num[5]=en_escort;
		        en_size[5]=1;
		    }// en_num[5]+=en_num[4]+1;
	    }
	    
	    if (owner = eFACTION.Tau){
	        var i;
	        i=0;
	        i=en_frigate;
	        
	        if (en_capital>0){
	        	en_column[1]="Custodian";
	        en_num[1]=en_capital;
	        en_size[1]=3;}
	        
	        if (i>0){
	        	en_column[2]="Emissary";
	        en_num[2]=1;
	        i-=en_num[2];
	        en_size[2]=2;}
	        
	        if (i>0){
	        	en_column[3]="Protector";
	        en_num[3]=i;
	        i-=en_num[3];
	        en_size[3]=2;}// en_num[3]+=en_num[2]+1;
	        
	        if (en_escort>0){
	        	en_column[4]="Castellan";
	        en_num[4]=round((en_escort/3)*2);
	        en_size[4]=1;}
	        
	        if (en_escort>2){
	        	en_column[5]="Warden";
	        en_num[5]=en_escort-en_num[5];
	        en_size[5]=1;}
	    }
	    
	    if (owner = eFACTION.Tyranids){
	        var i;
	        i=0;
	        i=en_escort;
	        
	        if (en_capital>0){
	        	en_column[1]="Leviathan";
	        en_num[1]=en_capital;
	        en_size[1]=3;}
	        
	        if (i>0){
	        	en_column[2]="Stalker";
	        en_num[2]=floor(i/3)+1;
	        i-=en_num[2];
	        en_size[2]=1;}
	        
	        if (en_frigate>0){
	        	en_column[3]="Razorfiend";
	        en_num[3]=en_frigate;
	        en_size[3]=2;}// en_num[2]+=en_num[1]+1;
	        
	        if (i>0){
	        	en_column[4]="Prowler";
	        en_num[4]=i;
	        en_size[4]=1;}// en_num[5]+=en_num[4]+1;
	    }
	    
	    if (owner = eFACTION.Chaos){
	        var i;
	        i=0;
	        i=en_frigate;
	        
	        if (en_capital>0){
	        	en_column[1]="Desecrator";
	        en_num[1]=en_capital;
	        en_size[1]=3;}
	        
	        if (i>0){
	        	en_column[2]="Avenger";
	        en_num[2]=floor(random(i))+1;
	        i-=en_num[2];
	        en_size[2]=2;}
	        
	        if (i>0){
	        	en_column[3]="Carnage";
	        en_num[3]=floor(random(i))+1;
	        i-=en_num[3];
	        en_size[3]=2;}// en_num[2]+=en_num[1]+1;
	        
	        if (i>0){
	        	en_column[4]="Daemon";
	        en_num[4]=i;
	        i-=en_num[4];
	        en_size[4]=2;}// en_num[3]+=en_num[2]+1;
	        
	        if (en_escort>0){
	        	en_column[5]="Iconoclast";
	        en_num[5]=en_escort;
	        en_size[5]=1;}// en_num[5]+=en_num[4]+1;
	    }
	    
	    if (owner = eFACTION.Necrons){
	        var i;
	        i=0;
	        i=en_escort;
	        
	        if (en_capital>0){
	        	en_column[1]="Reaper Class";
	        en_num[1]=en_capital;
	        en_size[1]=3;}
	        // Cairn Class Tombship are very rare
	        
	        if (i>0){
	        	en_column[2]="Shroud Class";
	        en_num[2]=en_frigate;
	        en_size[2]=2;}
	        
	        if (i>0){
	        	en_column[3]="Jackal Class";
	        en_num[3]=round(i/2);
	        i-=en_num[3];
	        en_size[3]=1;}
	        if (en_escort>0){
	        	en_column[4]="Dirge Class";
	        en_num[4]=i;
	        en_size[4]=1;}
	    }
	    
	    
	    
	    
	    var i;
	    i=0;
	    repeat(5){i+=1;
	        if (en_column[i]="Avenger Class Grand Cruiser"){
	        	en_width[i]=196;
	        	en_height[i]=96;}
	        if (en_column[i]="Apocalypse Class Battleship"){
	        	en_width[i]=272;
	        	en_height[i]=128;}
	        if (en_column[i]="Nemesis Class Fleet Carrier"){
	        	en_width[i]=272;
	        	en_height[i]=128;}
	        if (en_column[i]="Sword Class Frigate"){
	        	en_width[i]=96;
	        	en_height[i]=64;}
	        
	        if (en_column[i]="Void Stalker"){
	        	en_width[i]=260;
	        	en_height[i]=192;}
	        if (en_column[i]="Shadow Class"){
	        	en_width[i]=212;
	        	en_height[i]=160;}
	        if (en_column[i]="Hellebore"){
	        	en_width[i]=160;
	        	en_height[i]=64;}
	        if (en_column[i]="Aconite"){
	        	en_width[i]=128;
	        	en_height[i]=64;}
	        
	        if (en_column[i]="Deathdeala"){
	        	en_width[i]=196;
	        	en_height[i]=128;}
	        if (en_column[i]="Gorbag's Revenge"){
	        	en_width[i]=196;
	        	en_height[i]=128;}
	        if (en_column[i]="Kroolboy"){
	        	en_width[i]=196;
	        	en_height[i]=128;}
	        if (en_column[i]="Slamblasta"){
	        	en_width[i]=196;
	        	en_height[i]=128;}
	        if (en_column[i]="Battlekroozer"){
	        	en_width[i]=160;
	        	en_height[i]=96;}
	        if (en_column[i]="Ravager"){
	        	en_width[i]=128;
	        	en_height[i]=64;}
	        
	        if (en_column[i]="Desecrator"){
	        	en_width[i]=196;
	        	en_height[i]=128;}
	        if (en_column[i]="Avenger"){
	        	en_width[i]=160;
	        	en_height[i]=96;}
	        if (en_column[i]="Carnage"){
	        	en_width[i]=160;
	        	en_height[i]=96;}
	        if (en_column[i]="Daemon"){
	        	en_width[i]=160;
	        	en_height[i]=96;}
	        if (en_column[i]="Iconoclast"){
	        	en_width[i]=128;
	        	en_height[i]=64;}
	        
	        if (en_column[i]="Custodian"){
	        	en_width[i]=128;
	        	en_height[i]=256;}
	        if (en_column[i]="Emissary"){
	        	en_width[i]=160;
	        	en_height[i]=96;}
	        if (en_column[i]="Protector"){
	        	en_width[i]=64;
	        	en_height[i]=180;}
	        if (en_column[i]="Castellan"){
	        	en_width[i]=48;
	        	en_height[i]=96;}
	        if (en_column[i]="Warden"){
	        	en_width[i]=48;
	        	en_height[i]=80;}
	        
	        if (en_column[i]="Leviathan"){
	        	en_width[i]=200;
	        	en_height[i]=128;}
	        if (en_column[i]="Razorfiend"){
	        	en_width[i]=160;
	        	en_height[i]=128;}
	        if (en_column[i]="Stalker"){
	        	en_width[i]=96;
	        	en_height[i]=64;}
	        if (en_column[i]="Prowler"){
	        	en_width[i]=80;
	        	en_height[i]=64;}
	        
	        if (en_column[i]="Cairn Class Tombship"){
	        	en_width[i]=256;
	        	en_height[i]=224;}
	        if (en_column[i]="Reaper Class"){
	        	en_width[i]=286;
	        	en_height[i]=161;}
	        if (en_column[i]="Shroud Class"){
	        	en_width[i]=200;
	        	en_height[i]=150;}
	        if (en_column[i]="Jackal Class"){
	        	en_width[i]=99;
	        	en_height[i]=123;}
	        if (en_column[i]="Dirge Class"){
	        	en_width[i]=100;
	        	en_height[i]=91;}
	    }
	}

	wait_and_execute(3, position_ships_and_assign_stats,[] , self);
}


function position_ships_and_assign_stats(){


	if (owner = eFACTION.Imperium) or (owner = eFACTION.Eldar){// This is an orderly Imperial ship formation
	    var xx,yy,i, temp1, x2, man;
	    xx=0;yy=0;
	    i=0;temp1=0;x2=0;
	    man=0;
	    var fuck=0;
	    if (obj_fleet.enemy_status[number]<0){
	        x2=room_width-800;
	        fuck=5
	    }else if (obj_fleet.enemy_status[number]>0){
	        x2=50;
	        fuck=0;
	    }
	    
	    repeat(4){
	        if (obj_fleet.enemy_status[number]<0) then fuck-=1;
	        if (obj_fleet.enemy_status[number]>0) then fuck+=1;
	    
	        yy=y-((en_height[fuck]*en_num[fuck])/2);
	        if (en_num[fuck]>0){
	            yy+=(en_height[fuck]/2);
	            repeat(en_num[fuck]){
	                if (en_size[fuck]<3){
	                    if (obj_fleet.enemy_status[number]<0){
	                        man=instance_create(x2,yy,obj_en_cruiser);
	                        yy+=en_height[fuck];
	                        man.class=en_column[fuck];
	                        man.owner=owner;
	                        man.size=en_size[fuck];
	                    }
	                    if (obj_fleet.enemy_status[number]>0){
	                        man=instance_create(x2,yy,obj_al_cruiser);
	                        yy+=en_height[fuck];
	                        man.class=en_column[fuck];
	                        man.owner=owner;
	                        man.size=en_size[fuck];
	                    }
	                }
	                if (en_size[fuck]>=3){
	                    if (obj_fleet.enemy_status[number]<0){
	                        man=instance_create(x2,yy,obj_en_capital);
	                        yy+=en_height[fuck];
	                        man.class=en_column[fuck];
	                        man.owner=owner;
	                        man.size=en_size[fuck];
	                    }
	                    else if (obj_fleet.enemy_status[number]>0){
	                        man=instance_create(x2,yy,obj_al_capital);
	                        yy+=en_height[fuck];
	                        man.class=en_column[fuck];
	                        man.owner=owner;
	                        man.size=en_size[fuck];}
	                }
	            }
	            x2+=en_width[fuck];
	        }
	    }
	    
	    
	    
	    /*
	    if (en_num[4]>0){
	        yy=y-((en_height[4]*en_num[4])/2);
	        yy+=(en_height[4]/2);
	        repeat(en_num[4]){
	            man=instance_create(x2,yy,obj_en_cruiser);
	            yy+=en_height[4];
	            man.class=en_column[4];
	            man.owner=owner;
	        }
	        x2+=en_width[4];
	    }
	    if (en_num[3]>0){
	        yy=y-((en_height[3]*en_num[3])/2);
	        yy+=(en_height[3]/2);
	        repeat(en_num[3]){
	            man=instance_create(x2,yy,obj_en_cruiser);
	            yy+=en_height[3];
	            man.class=en_column[3];
	            man.owner=owner;
	        }
	        x2+=en_width[3];
	    }
	    if (en_num[2]>0){
	        yy=y-((en_height[2]*en_num[2])/2);
	        yy+=(en_height[2]/2);
	        repeat(en_num[2]){
	            man=instance_create(x2,yy,obj_en_capital);
	            yy+=en_height[2];
	            man.class=en_column[2];
	            man.owner=owner;
	        }
	        x2+=en_width[2];
	    }
	    if (en_num[1]>0){
	        yy=256;
	        repeat(en_num[1]){
	            man=instance_create(x2,yy,obj_en_capital);
	            yy+=en_height[1];
	            man.class=en_column[1];
	            man.owner=owner;
	            yy+=(en_height[1]);
	        }
	    }*/
	}






	/*
	if (en_escort>0){
	en_column[4]="Aconite";
	en_num[4]=max(1,floor(en_escort/2));
	en_size[4]=1;}
	if (en_escort>1){
	en_column[3]="Hellebore";
	en_num[3]=max(1,floor(en_escort/2));
	en_size[3]=1;}
	if (en_frigate>0){
	en_column[2]="Shadow Class";
	en_num[2]=en_frigate;
	en_size[2]=2;}
	if (en_capital>0){
	en_column[1]="Void Stalker";
	en_num[1]=en_capital;
	en_size[1]=3;}
	*/


	/*
	if (owner = eFACTION.Eldar){// This is an orderly Eldar ship formation
	    var xx,yy,i, temp1, x2, man;
	    xx=0;yy=0;
	    i=0;temp1=0;x2=1200;
	    man=0;
	    
	    if (en_num[4]>0){
	        yy=128;
	        repeat(en_num[4]){
	            man=instance_create(x2,yy,obj_en_cruiser);
	            yy+=en_height[4];
	            man.class=en_column[4];
	            man.owner=owner;
	        }
	    }
	    if (en_num[3]>0){
	        yy=room_height-128;
	        repeat(en_num[3]){
	            man=instance_create(x2,yy,obj_en_cruiser);
	            yy-=en_height[3];
	            man.class=en_column[3];
	            man.owner=owner;
	        }
	    }
	    x2+=max(en_width[3],en_width[4]);
	    
	    if (en_num[2]>0){
	        yy=y-((en_height[2]*en_num[2])/2);
	        yy+=(en_height[2]/2);
	        repeat(en_num[2]){
	            man=instance_create(x2,yy,obj_en_capital);
	            yy+=en_height[2];
	            man.class=en_column[2];
	            man.owner=owner;
	        }
	        x2+=en_width[2];
	    }
	    if (en_num[1]>0){
	        yy=256;
	        repeat(en_num[1]){
	            man=instance_create(x2,yy,obj_en_capital);
	            yy+=en_height[1];
	            man.class=en_column[1];
	            man.owner=owner;
	            yy+=(en_height[1]);
	        }
	    }
	}*/






	if (owner = eFACTION.Ork) or (owner = eFACTION.Chaos){// This is spew out random ships without regard for formations
	    var xx = 0,yy = 0,target_distance = 0,targ = 0,numb = 0,man = 0;
	   
	    var i;
	    i=0;
	    
	    repeat(5){
	    
	        i+=1;
	    
	        if (en_column[i]!="") then for(s = 0; s < en_num[i]; s += 1){
	            if (en_size[i]>1){
	            	man=instance_create(random_range(1200,1400),round(random_range(y,y+height)+50),obj_en_capital);
	            }
	            else if (en_size[i]==2){
	            	man=instance_create(random_range(1200,1400),round(random_range(y,y+height)+50),obj_en_cruiser);
	            }	            
	            else if (en_size[i]=1){
	            	man=instance_create(random_range(1200,1400),round(random_range(y,y+height)+50),obj_en_cruiser);
	            }
	            man.class=en_column[i];
	            man.owner=owner;
	            man.size=en_size[i];
	        }
	    
	    
	    }
	}







	if (owner = eFACTION.Tau){// This is an orderly Tau ship formation
	    var xx,yy,i, temp1, x2, man;
	    xx=0;yy=0;
	    i=0;temp1=0;x2=1200;
	    man=0;
	    
	    yy=y-((en_height[5]*en_num[5])/2);
	    yy+=(en_height[5]/2);
	    repeat(en_num[5]){
	        man=instance_create(x2,yy,obj_en_cruiser);
	        yy+=en_height[5];
	        man.class="Warden";
	        man.owner=owner;
	        man.size=en_size[5];
	    }
	    x2+=en_width[5];
	    
	    yy=y-((en_height[2]*en_num[2])/2)-((en_height[3]*en_num[3])/2);
	    yy+=(en_height[2]/2);
	    yy+=(en_height[3]/2);
	    repeat(en_num[2]){
	        man=instance_create(x2,yy,obj_en_cruiser);
	        yy+=en_height[2];
	        man.class="Emissary";
	        man.owner=owner;
	        man.size=en_size[2];
	    }
	    repeat(en_num[3]){
	        man=instance_create(x2,yy,obj_en_cruiser);
	        yy+=en_height[3];
	        man.class="Protector";
	        man.owner=owner;
	        man.size=en_size[3];
	    }
	    x2+=max(en_width[2],en_width[3]);
	    
	    yy=y-((en_height[4]*en_num[4])/2);
	    yy+=(en_height[4]/2);
	    repeat(en_num[4]){
	        man=instance_create(x2,yy,obj_en_cruiser);
	        yy+=en_height[4];
	        man.class="Castellan";
	        man.owner=owner;
	        man.size=en_size[4];
	    }
	    x2+=en_width[4];
	    
	    yy=y-((en_height[1]*en_num[1])/2);
	    yy+=(en_height[1]/2);
	    repeat(en_num[1]){
	        man=instance_create(x2,yy,obj_en_capital);
	        yy+=en_height[1];
	        man.class="Custodian";
	        man.owner=owner;
	        man.size=en_size[1];
	    }

	}




	if (owner = eFACTION.Tyranids){// This is an orderly Tyranid ship formation
	    var xx,yy,i, temp1, x2, man;
	    xx=0;yy=0;
	    i=0;temp1=0;x2=1200;
	    man=0;
	    
	    yy=y-((en_height[4]*en_num[4])/2);
	    yy+=(en_height[4]/2);
	    repeat(en_num[4]){
	        man=instance_create(x2,yy,obj_en_cruiser);
	        yy+=en_height[4];
	        man.class="Prowler";
	        man.owner=owner;
	        man.size=en_size[4];
	    }
	    x2+=en_width[4];
	    
	    yy=y-((en_height[3]*en_num[3])/2);
	    yy+=(en_height[3]/2);
	    repeat(en_num[3]){
	        man=instance_create(x2,yy,obj_en_cruiser);
	        yy+=en_height[3];
	        man.class="Razorfiend";
	        man.owner=owner;
	        man.size=en_size[3];
	    }
	    x2+=en_width[3];
	    
	    yy=y-((en_height[2]*en_num[2])/2);
	    yy+=(en_height[2]/2);
	    repeat(en_num[2]){
	        man=instance_create(x2,yy,obj_en_cruiser);
	        yy+=en_height[2];
	        man.class="Stalker";
	        man.owner=owner;
	        man.size=en_size[2];
	    }
	    x2+=en_width[2];
	    
	    yy=y-((en_height[1]*en_num[1])/2);
	    yy+=(en_height[1]/2);
	    repeat(en_num[1]){
	        man=instance_create(x2,yy,obj_en_capital);
	        yy+=en_height[1];
	        man.class="Leviathan";
	        man.owner=owner;
	        man.size=en_size[1];
	    }

	}




	if (owner = eFACTION.Necrons){// This is an orderly Necron ship formation
	    var xx,yy,i, temp1, x2, man;
	    xx=0;yy=0;
	    i=0;temp1=0;x2=1200;
	    man=0;
	    
	    yy=y-((en_height[4]*en_num[4])/2);
	    yy+=(en_height[4]/2);
	    repeat(en_num[4]){
	        man=instance_create(x2,yy,obj_en_cruiser);
	        yy+=en_height[4];
	        man.class="Dirge Class";
	        man.owner=owner;
	        man.size=en_size[4];
	    }
	    x2+=en_width[4];
	    
	    yy=y-((en_height[3]*en_num[3])/2);
	    yy+=(en_height[3]/2);
	    repeat(en_num[3]){
	        man=instance_create(x2,yy,obj_en_cruiser);
	        yy+=en_height[3];
	        man.class="Jackal Class";
	        man.owner=owner;
	        man.size=en_size[3];
	    }
	    x2+=en_width[3];
	    
	    yy=y-((en_height[2]*en_num[2])/2);
	    yy+=(en_height[2]/2);
	    repeat(en_num[2]){
	        man=instance_create(x2,yy,obj_en_cruiser);
	        yy+=en_height[2];
	        man.class="Shroud Class";
	        man.owner=owner;
	        man.size=en_size[2];
	    }
	    x2+=en_width[2];
	    
	    yy=y-((en_height[1]*en_num[1])/2);
	    yy+=(en_height[1]/2);
	    repeat(en_num[1]){
	        man=instance_create(x2,yy,obj_en_capital);
	        yy+=en_height[1];
	        man.class="Reaper Class";
	        man.owner=owner;
	        man.size=en_size[1];
	    }
	}

	with (obj_en_ship){
	    assign_ship_stats();
	}
	with (obj_al_ship){
	    assign_ship_stats();
	}


}

