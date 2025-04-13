

if (sprite_exists(img1)){sprite_delete(img1);}
if (sprite_exists(img2)){sprite_delete(img2);}
if (sprite_exists(img3)){sprite_delete(img3);}
if (sprite_exists(img4)){sprite_delete(img4);}
if (file_exists(working_directory + "\\screen"+string(save[top])+".png")) then img1=sprite_add(working_directory + "\\screen"+string(save[top])+".png",1,0,0,0,0);
if (file_exists(working_directory + "\\screen"+string(save[top+1])+".png")) then img2=sprite_add(working_directory + "\\screen"+string(save[top+1])+".png",1,0,0,0,0);
if (file_exists(working_directory + "\\screen"+string(save[top+2])+".png")) then img3=sprite_add(working_directory + "\\screen"+string(save[top+2])+".png",1,0,0,0,0);
if (file_exists(working_directory + "\\screen"+string(save[top+3])+".png")) then img4=sprite_add(working_directory + "\\screen"+string(save[top+3])+".png",1,0,0,0,0);


