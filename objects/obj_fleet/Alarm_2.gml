
capital_max=capital;
frigate_max=frigate;
escort_max=escort;



// create blocks of infantry


var i, k, col, temp1, temp2, x2, hei, man, sizz;
i=0;k=0;col=5;temp1=0;temp2=0;x2=224;hei=0;man=0;sizz=0;





repeat(100){// This determines the number of ships in each column
    k+=1;
    
    
    if (fighting[k]=1){
        if ((column[col]="Capital") and (ship_size[k]=3)) then column_num[col]+=1;
        if ((column[col-1]="Capital") and (ship_size[k]=3)) then column_num[col-1]+=1;
        if ((column[col-2]="Capital") and (ship_size[k]=3)) then column_num[col-2]+=1;
        if ((column[col-3]="Capital") and (ship_size[k]=3)) then column_num[col-3]+=1;
        if ((column[col-4]="Capital") and (ship_size[k]=3)) then column_num[col-4]+=1;
    
        if (ship_class[k]=column[col]) then column_num[col]+=1;
        if (ship_class[k]=column[col-1]) then column_num[col-1]+=1;
        if (ship_class[k]=column[col-2]) then column_num[col-2]+=1;
        if (ship_class[k]=column[col-3]) then column_num[col-3]+=1;
        if (ship_class[k]=column[col-4]) then column_num[col-4]+=1;
        
        if ((column[col]="Escort") and (ship_size[k]=1)) then column_num[col]+=1;
        if ((column[col-1]="Escort") and (ship_size[k]=1)) then column_num[col-1]+=1;
        if ((column[col-2]="Escort") and (ship_size[k]=1)) then column_num[col-2]+=1;
        if ((column[col-3]="Escort") and (ship_size[k]=1)) then column_num[col-3]+=1;
        if ((column[col-4]="Escort") and (ship_size[k]=1)) then column_num[col-4]+=1;
    }
    
    
}



col=6;
repeat(5){// Start repeat
    temp1=0;temp2=0;

    col-=1;
    if (col<5) then x2-=column_width[col];


if (column_num[col]>0){// Start ship creation
    if (column[col]="Capital"){hei=160;sizz=3;}
    // if (column[col]="Slaughtersong"){hei=200;sizz=3;}
    if (column[col]="Strike Cruiser"){hei=96;sizz=2;}
    if (column[col]="Gladius"){hei=64;sizz=1;}
    if (column[col]="Hunter"){hei=64;sizz=1;}
    if (column[col]="Escort"){hei=64;sizz=1;}

    temp1=column_num[col]*hei;
    temp2=((room_height/2)-(temp1/2))+64;
    if (column_num[col]=1) then temp2+=20;
    
    // show_message(string(column_num[col])+" "+string(column[col])+" X:"+string(x2));
    
    k=0;
    repeat(100){k+=1;
        if (ship_class[k]=column[col]) or ((column[col]="Escort") and (ship_size[k]=1))or ((column[col]="Capital") and (ship_size[k]=3)){
            if (sizz=3) and (ship_class[k]!="") and (fighting[k]=1){man=instance_create(x2,temp2,obj_p_capital);man.ship_id=k;man.class=column[col];temp2+=hei;}
            if (sizz=2) and (ship_class[k]!="") and (fighting[k]=1){man=instance_create(x2,temp2,obj_p_cruiser);man.ship_id=k;man.class=column[col];temp2+=hei;}
            if (sizz=1) and (ship_class[k]!="") and (fighting[k]=1){man=instance_create(x2,temp2,obj_p_escort);man.ship_id=k;man.class=column[col];temp2+=hei;}
        }
    }
    

}// End ship creation




}// End repeat





if (enemy=2){// This is an orderly Tau ship formation
    var xx,yy,i, temp1, x2, man;
    xx=0;yy=0;i=0;temp1=0;x2=1200;man=0;
    
    if (en_num[4]>0){
        yy=(room_height/2)-((en_height[4]*en_num[4])/2);
        yy+=(en_height[4]/2);
        repeat(en_num[4]){
            man=instance_create(x2,yy,obj_en_cruiser);yy+=en_height[4];man.class=en_column[4];
        }
        x2+=en_width[4];
    }
    if (en_num[3]>0){
        yy=(room_height/2)-((en_height[3]*en_num[3])/2);
        yy+=(en_height[3]/2);
        repeat(en_num[3]){
            man=instance_create(x2,yy,obj_en_cruiser);yy+=en_height[3];man.class=en_column[3];
        }
        x2+=en_width[3];
    }
    if (en_num[2]>0){
        yy=(room_height/2)-((en_height[2]*en_num[2])/2);
        yy+=(en_height[2]/2);
        repeat(en_num[2]){
            man=instance_create(x2,yy,obj_en_capital);yy+=en_height[2];man.class=en_column[2];
        }
        x2+=en_width[2];
    }
    if (en_num[1]>0){
        yy=256;
        repeat(en_num[1]){
            man=instance_create(x2,yy,obj_en_capital);yy+=en_height[1];man.class=en_column[1];
            yy+=(en_height[1]);
        }
    }
}






/*
if (en_escort>0){en_column[4]="Aconite";en_num[4]=max(1,floor(en_escort/2));en_size[4]=1;}
if (en_escort>1){en_column[3]="Hellebore";en_num[3]=max(1,floor(en_escort/2));en_size[3]=1;}
if (en_frigate>0){en_column[2]="Shadow Class";en_num[2]=en_frigate;en_size[2]=2;}
if (en_capital>0){en_column[1]="Void Stalker";en_num[1]=en_capital;en_size[1]=3;}
*/



if (enemy=6){// This is an orderly Tau ship formation
    var xx,yy,i, temp1, x2, man;
    xx=0;yy=0;i=0;temp1=0;x2=1200;man=0;
    
    if (en_num[4]>0){
        yy=128;
        repeat(en_num[4]){
            man=instance_create(x2,yy,obj_en_cruiser);yy+=en_height[4];man.class=en_column[4];
        }
    }
    if (en_num[3]>0){
        yy=room_height-128;
        repeat(en_num[3]){
            man=instance_create(x2,yy,obj_en_cruiser);yy-=en_height[3];man.class=en_column[3];
        }
    }
    x2+=max(en_width[3],en_width[4]);
    
    if (en_num[2]>0){
        yy=(room_height/2)-((en_height[2]*en_num[2])/2);
        yy+=(en_height[2]/2);
        repeat(en_num[2]){
            man=instance_create(x2,yy,obj_en_capital);yy+=en_height[2];man.class=en_column[2];
        }
        x2+=en_width[2];
    }
    if (en_num[1]>0){
        yy=256;
        repeat(en_num[1]){
            man=instance_create(x2,yy,obj_en_capital);yy+=en_height[1];man.class=en_column[1];
            yy+=(en_height[1]);
        }
    }
}






if (enemy=7) or (enemy=10){// This is spew out random ships without regard for formations
    var xx,yy,dist,targ,numb,man;
    xx=0;yy=0;dist=0;target=0;numb=0;man=0;
    
    var i;i=0;
    
    repeat(5){
    
        i+=1;
    
        if (en_column[i]!="") then for(s = 0; s < en_num[i]; s += 1){
            if (en_size[i]>1) then man=instance_create(random_range(1200,1400),round(random(860)+50),obj_en_capital);
            if (en_size[i]=1) then man=instance_create(random_range(1200,1400),round(random(860)+50),obj_en_cruiser);
            man.class=en_column[i];
        }
    
    
    }
}







if (enemy=8){// This is an orderly Tau ship formation
    var xx,yy,i, temp1, x2, man;
    xx=0;yy=0;i=0;temp1=0;x2=1200;man=0;
    
    yy=(room_height/2)-((en_height[5]*en_num[5])/2);
    yy+=(en_height[5]/2);
    repeat(en_num[5]){
        man=instance_create(x2,yy,obj_en_cruiser);yy+=en_height[5];man.class="Warden";
    }
    x2+=en_width[5];
    
    yy=(room_height/2)-((en_height[2]*en_num[2])/2)-((en_height[3]*en_num[3])/2);
    yy+=(en_height[2]/2);yy+=(en_height[3]/2);
    repeat(en_num[2]){
        man=instance_create(x2,yy,obj_en_cruiser);yy+=en_height[2];man.class="Emissary";
    }
    repeat(en_num[3]){
        man=instance_create(x2,yy,obj_en_cruiser);yy+=en_height[3];man.class="Protector";
    }
    x2+=max(en_width[2],en_width[3]);
    
    yy=(room_height/2)-((en_height[4]*en_num[4])/2);
    yy+=(en_height[4]/2);
    repeat(en_num[4]){
        man=instance_create(x2,yy,obj_en_cruiser);yy+=en_height[4];man.class="Castellan";
    }
    x2+=en_width[4];
    
    yy=(room_height/2)-((en_height[1]*en_num[1])/2);
    yy+=(en_height[1]/2);
    repeat(en_num[1]){
        man=instance_create(x2,yy,obj_en_capital);yy+=en_height[1];man.class="Custodian";
    }

}




if (enemy=9){// This is an orderly Tyranid ship formation
    var xx,yy,i, temp1, x2, man;
    xx=0;yy=0;i=0;temp1=0;x2=1200;man=0;
    
    yy=(room_height/2)-((en_height[4]*en_num[4])/2);
    yy+=(en_height[4]/2);
    repeat(en_num[4]){
        man=instance_create(x2,yy,obj_en_cruiser);yy+=en_height[4];man.class="Prowler";
    }
    x2+=en_width[4];
    
    yy=(room_height/2)-((en_height[3]*en_num[3])/2);
    yy+=(en_height[3]/2);
    repeat(en_num[3]){
        man=instance_create(x2,yy,obj_en_cruiser);yy+=en_height[3];man.class="Razorfiend";
    }
    x2+=en_width[3];
    
    yy=(room_height/2)-((en_height[2]*en_num[2])/2);
    yy+=(en_height[2]/2);
    repeat(en_num[2]){
        man=instance_create(x2,yy,obj_en_cruiser);yy+=en_height[2];man.class="Stalker";
    }
    x2+=en_width[2];
    
    yy=(room_height/2)-((en_height[1]*en_num[1])/2);
    yy+=(en_height[1]/2);
    repeat(en_num[1]){
        man=instance_create(x2,yy,obj_en_capital);yy+=en_height[1];man.class="Leviathan";
    }

}





/* */
action_set_alarm(2, 3);

