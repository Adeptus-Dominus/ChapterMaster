



if (number=1){
    // create blocks of infantry
    
    
    var i, k, col, temp1, temp2, x2, hei, man, sizz;
    i=0;k=0;col=5;temp1=0;temp2=0;x2=224;hei=0;man=0;sizz=0;
    
    
    
    
    
    repeat(100){// This determines the number of ships in each column
        k+=1;
        
        
        if (obj_fleet.fighting[k]=1){
            if ((obj_fleet.column[col]="Capital") and (obj_fleet.ship_size[k]=3)) then obj_fleet.column_num[col]+=1;
            if ((obj_fleet.column[col-1]="Capital") and (obj_fleet.ship_size[k]=3)) then obj_fleet.column_num[col-1]+=1;
            if ((obj_fleet.column[col-2]="Capital") and (obj_fleet.ship_size[k]=3)) then obj_fleet.column_num[col-2]+=1;
            if ((obj_fleet.column[col-3]="Capital") and (obj_fleet.ship_size[k]=3)) then obj_fleet.column_num[col-3]+=1;
            if ((obj_fleet.column[col-4]="Capital") and (obj_fleet.ship_size[k]=3)) then obj_fleet.column_num[col-4]+=1;
        
            if (obj_fleet.ship_class[k]=obj_fleet.column[col]) then obj_fleet.column_num[col]+=1;
            if (obj_fleet.ship_class[k]=obj_fleet.column[col-1]) then obj_fleet.column_num[col-1]+=1;
            if (obj_fleet.ship_class[k]=obj_fleet.column[col-2]) then obj_fleet.column_num[col-2]+=1;
            if (obj_fleet.ship_class[k]=obj_fleet.column[col-3]) then obj_fleet.column_num[col-3]+=1;
            if (obj_fleet.ship_class[k]=obj_fleet.column[col-4]) then obj_fleet.column_num[col-4]+=1;
            
            if ((obj_fleet.column[col]="Escort") and (obj_fleet.ship_size[k]=1)) then obj_fleet.column_num[col]+=1;
            if ((obj_fleet.column[col-1]="Escort") and (obj_fleet.ship_size[k]=1)) then obj_fleet.column_num[col-1]+=1;
            if ((obj_fleet.column[col-2]="Escort") and (obj_fleet.ship_size[k]=1)) then obj_fleet.column_num[col-2]+=1;
            if ((obj_fleet.column[col-3]="Escort") and (obj_fleet.ship_size[k]=1)) then obj_fleet.column_num[col-3]+=1;
            if ((obj_fleet.column[col-4]="Escort") and (obj_fleet.ship_size[k]=1)) then obj_fleet.column_num[col-4]+=1;
        }
        
        
    }
    
    
    
    col=6;
    repeat(5){// Start repeat
        temp1=0;temp2=0;
    
        col-=1;
        if (col<5) then x2-=obj_fleet.column_width[col];
        
    
        if (obj_fleet.column_num[col]>0){// Start ship creation
            if (obj_fleet.column[col]="Capital"){hei=160;sizz=3;}
            // if (column[col]="Slaughtersong"){hei=200;sizz=3;}
            if (obj_fleet.column[col]="Strike Cruiser"){hei=96;sizz=2;}
            if (obj_fleet.column[col]="Gladius"){hei=64;sizz=1;}
            if (obj_fleet.column[col]="Hunter"){hei=64;sizz=1;}
            if (obj_fleet.column[col]="Escort"){hei=64;sizz=1;}
        
            temp1=obj_fleet.column_num[col]*hei;
            // temp2=((y-(height/2))-(temp1/2))+64;
            temp2=y-(temp1/2)+64;
            if (obj_fleet.column_num[col]=1) then temp2+=20;
            
            // show_message(string(column_num[col])+" "+string(column[col])+" X:"+string(x2));
            
            k=0;
            repeat(100){k+=1;
                if (obj_fleet.ship_class[k]=obj_fleet.column[col]) or ((obj_fleet.column[col]="Escort") and (obj_fleet.ship_size[k]=1)) or ((obj_fleet.column[col]="Capital") and (obj_fleet.ship_size[k]=3)){
                    if (sizz=3) and (obj_fleet.ship_class[k]!="") and (obj_fleet.fighting[k]=1){man=instance_create(x2,temp2,obj_p_capital);man.ship_id=k;man.class=obj_fleet.column[col];temp2+=hei;}
                    if (sizz=2) and (obj_fleet.ship_class[k]!="") and (obj_fleet.fighting[k]=1){man=instance_create(x2,temp2,obj_p_cruiser);man.ship_id=k;man.class=obj_fleet.column[col];temp2+=hei;}
                    if (sizz=1) and (obj_fleet.ship_class[k]!="") and (obj_fleet.fighting[k]=1){man=instance_create(x2,temp2,obj_p_escort);man.ship_id=k;man.class=obj_fleet.column[col];temp2+=hei;}
                }
            }
            
        
        }// End ship creation
    
    
    
    
    }// End repeat













    
}



if (number>0) and (owner!=1){

    en_escort=obj_fleet.en_escort[number];
    en_frigate=obj_fleet.en_frigate[number];
    en_capital=obj_fleet.en_capital[number];

    
    if (owner = eFACTION.Imperium){
        if (en_escort>0){en_column[4]="Sword Class Frigate";en_num[4]=en_escort;en_size[4]=1;}
        
        if (en_frigate>0){en_column[3]="Avenger Class Grand Cruiser";en_num[3]=en_frigate;en_size[3]=2;}
            
        var i;i=0;i=en_capital;
        if (i>0){
            en_column[2]="Apocalypse Class Battleship";en_num[2]=floor(random(i))+1;
            if (en_num[2]<(en_capital*0.6)) then en_num[2]=round(en_capital*0.6);
            i-=en_num[2];en_size[2]=3;
        }
        
        if (i>0){en_column[1]="Nemesis Class Fleet Carrier";en_num[1]=i;i-=en_num[1];en_size[1]=3;}
    }
    
    
    
    if (owner = eFACTION.Eldar){
        if (en_escort>0){en_column[4]="Aconite";en_num[4]=max(1,floor(en_escort/2));en_size[4]=1;}
        if (en_escort>1){en_column[3]="Hellebore";en_num[3]=max(1,floor(en_escort/2));en_size[3]=1;}
        if (en_frigate>0){en_column[2]="Shadow Class";en_num[2]=en_frigate;en_size[2]=2;}
        if (en_capital>0){en_column[1]="Void Stalker";en_num[1]=en_capital;en_size[1]=3;}
    }
    
    
    
    
    if (owner = eFACTION.Ork){
        var i;i=0;i=en_capital;
        
        if (i>0){en_column[1]="Dethdeala";en_num[1]=floor(random(i))+1;i-=en_num[1];en_size[1]=3;}
        
        if (i>0){en_column[2]="Gorbag's Revenge";en_num[2]=floor(random(i))+1;i-=en_num[2];en_size[2]=3;}// en_num[2]+=en_num[1]+1;
        
        if (i>0){en_column[3]="Kroolboy";en_num[3]=i;i-=en_num[3];en_size[3]=3;}// en_num[3]+=en_num[2]+1;
        
        if (en_frigate>0){en_column[4]="Battlekroozer";en_num[4]=en_frigate;en_size[4]=2;}// en_num[4]+=en_num[3]+1;
        
        if (en_escort>0){en_column[5]="Ravager";en_num[5]=en_escort;en_size[5]=1;}// en_num[5]+=en_num[4]+1;
    }
    
    if (owner = eFACTION.Tau){
        var i;i=0;i=en_frigate;
        
        if (en_capital>0){en_column[1]="Custodian";en_num[1]=en_capital;en_size[1]=3;}
        
        if (i>0){en_column[2]="Emissary";en_num[2]=1;i-=en_num[2];en_size[2]=2;}
        
        if (i>0){en_column[3]="Protector";en_num[3]=i;i-=en_num[3];en_size[3]=2;}// en_num[3]+=en_num[2]+1;
        
        if (en_escort>0){en_column[4]="Castellan";en_num[4]=round((en_escort/3)*2);en_size[4]=1;}
        
        if (en_escort>2){en_column[5]="Warden";en_num[5]=en_escort-en_num[5];en_size[5]=1;}
    }
    
    if (owner = eFACTION.Tyranids){
        var i;i=0;i=en_escort;
        
        if (en_capital>0){en_column[1]="Leviathan";en_num[1]=en_capital;en_size[1]=3;}
        
        if (i>0){en_column[2]="Stalker";en_num[2]=floor(i/3)+1;i-=en_num[2];en_size[2]=1;}
        
        if (en_frigate>0){en_column[3]="Razorfiend";en_num[3]=en_frigate;en_size[3]=2;}// en_num[2]+=en_num[1]+1;
        
        if (i>0){en_column[4]="Prowler";en_num[4]=i;en_size[4]=1;}// en_num[5]+=en_num[4]+1;
    }
    
    if (owner = eFACTION.Chaos){
        var i;i=0;i=en_frigate;
        
        if (en_capital>0){en_column[1]="Desecrator";en_num[1]=en_capital;en_size[1]=3;}
        
        if (i>0){en_column[2]="Avenger";en_num[2]=floor(random(i))+1;i-=en_num[2];en_size[2]=2;}
        
        if (i>0){en_column[3]="Carnage";en_num[3]=floor(random(i))+1;i-=en_num[3];en_size[3]=2;}// en_num[2]+=en_num[1]+1;
        
        if (i>0){en_column[4]="Daemon";en_num[4]=i;i-=en_num[4];en_size[4]=2;}// en_num[3]+=en_num[2]+1;
        
        if (en_escort>0){en_column[5]="Iconoclast";en_num[5]=en_escort;en_size[5]=1;}// en_num[5]+=en_num[4]+1;
    }
    
    if (owner = eFACTION.Necrons){
        var i;i=0;i=en_escort;
        
        if (en_capital>0){en_column[1]="Reaper Class";en_num[1]=en_capital;en_size[1]=3;}
        // Cairn Class Tombship are very rare
        
        if (i>0){en_column[2]="Shroud Class";en_num[2]=en_frigate;en_size[2]=2;}
        
        if (i>0){en_column[3]="Jackal Class";en_num[3]=round(i/2);i-=en_num[3];en_size[3]=1;}
        if (en_escort>0){en_column[4]="Dirge Class";en_num[4]=i;en_size[4]=1;}
    }
    
    
    
    
    var i;i=0;
    repeat(5){i+=1;
        if (en_column[i]="Avenger Class Grand Cruiser"){en_width[i]=196;en_height[i]=96;}
        if (en_column[i]="Apocalypse Class Battleship"){en_width[i]=272;en_height[i]=128;}
        if (en_column[i]="Nemesis Class Fleet Carrier"){en_width[i]=272;en_height[i]=128;}
        if (en_column[i]="Sword Class Frigate"){en_width[i]=96;en_height[i]=64;}
        
        if (en_column[i]="Void Stalker"){en_width[i]=260;en_height[i]=192;}
        if (en_column[i]="Shadow Class"){en_width[i]=212;en_height[i]=160;}
        if (en_column[i]="Hellebore"){en_width[i]=160;en_height[i]=64;}
        if (en_column[i]="Aconite"){en_width[i]=128;en_height[i]=64;}
        
        if (en_column[i]="Deathdeala"){en_width[i]=196;en_height[i]=128;}
        if (en_column[i]="Gorbag's Revenge"){en_width[i]=196;en_height[i]=128;}
        if (en_column[i]="Kroolboy"){en_width[i]=196;en_height[i]=128;}
        if (en_column[i]="Slamblasta"){en_width[i]=196;en_height[i]=128;}
        if (en_column[i]="Battlekroozer"){en_width[i]=160;en_height[i]=96;}
        if (en_column[i]="Ravager"){en_width[i]=128;en_height[i]=64;}
        
        if (en_column[i]="Desecrator"){en_width[i]=196;en_height[i]=128;}
        if (en_column[i]="Avenger"){en_width[i]=160;en_height[i]=96;}
        if (en_column[i]="Carnage"){en_width[i]=160;en_height[i]=96;}
        if (en_column[i]="Daemon"){en_width[i]=160;en_height[i]=96;}
        if (en_column[i]="Iconoclast"){en_width[i]=128;en_height[i]=64;}
        
        if (en_column[i]="Custodian"){en_width[i]=128;en_height[i]=256;}
        if (en_column[i]="Emissary"){en_width[i]=160;en_height[i]=96;}
        if (en_column[i]="Protector"){en_width[i]=64;en_height[i]=180;}
        if (en_column[i]="Castellan"){en_width[i]=48;en_height[i]=96;}
        if (en_column[i]="Warden"){en_width[i]=48;en_height[i]=80;}
        
        if (en_column[i]="Leviathan"){en_width[i]=200;en_height[i]=128;}
        if (en_column[i]="Razorfiend"){en_width[i]=160;en_height[i]=128;}
        if (en_column[i]="Stalker"){en_width[i]=96;en_height[i]=64;}
        if (en_column[i]="Prowler"){en_width[i]=80;en_height[i]=64;}
        
        if (en_column[i]="Cairn Class Tombship"){en_width[i]=256;en_height[i]=224;}
        if (en_column[i]="Reaper Class"){en_width[i]=286;en_height[i]=161;}
        if (en_column[i]="Shroud Class"){en_width[i]=200;en_height[i]=150;}
        if (en_column[i]="Jackal Class"){en_width[i]=99;en_height[i]=123;}
        if (en_column[i]="Dirge Class"){en_width[i]=100;en_height[i]=91;}
    }
}

action_set_alarm(1, 1);

