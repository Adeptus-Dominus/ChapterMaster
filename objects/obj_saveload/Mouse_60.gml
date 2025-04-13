
if (slow<0) then slow=0;
slow+=1;

if (slow>=3){
    if (top>1){top-=1;        
        if (sprite_exists(img4)){sprite_delete(img4);}
        img4=img3;img3=img2;img2=img1;
        if (file_exists(working_directory + "\\screen"+string(save[top])+".png")) then img1=sprite_add(working_directory + "\\screen"+string(save[top])+".png",1,0,0,0,0);
        if (!sprite_exists(img3)) and (file_exists(working_directory + "\\screen"+string(save[top+2])+".png")) then img3=sprite_add(working_directory + "\\screen"+string(save[top+3])+".png",1,0,0,0,0);
        if (!sprite_exists(img2)) and (file_exists(working_directory + "\\screen"+string(save[top+1])+".png")) then img2=sprite_add(working_directory + "\\screen"+string(save[top+2])+".png",1,0,0,0,0);
        if (!sprite_exists(img1)) and (file_exists(working_directory + "\\screen"+string(save[top])+".png")) then img1=sprite_add(working_directory + "\\screen"+string(save[top])+".png",1,0,0,0,0);
    }
}

