
if (slow>0) then slow=0;
slow-=1;

if (slow<=-3){
    if (top+3<=saves){top+=1;
    
        img1=img2;img2=img3;img3=img4;
        
        if (sprite_exists(img4)){sprite_delete(img4);}
        
        if (file_exists(string(PATH_save_previews, save[top + 3]))) {
            img4 = sprite_add(string(PATH_save_previews, save[top + 3]), 1, 0, 0, 0, 0);
        }
        if ((!sprite_exists(img3)) && file_exists(string(PATH_save_previews, save[top + 2]))) {
            img3 = sprite_add(string(PATH_save_previews, save[top + 2]), 1, 0, 0, 0, 0);
        }
        if ((!sprite_exists(img2)) && file_exists(string(PATH_save_previews, save[top + 1]))) {
            img2 = sprite_add(string(PATH_save_previews, save[top + 1]), 1, 0, 0, 0, 0);
        }
        if ((!sprite_exists(img1)) && file_exists(string(PATH_save_previews, save[top]))) {
            img1 = sprite_add(string(PATH_save_previews, save[top]), 1, 0, 0, 0, 0);
        }
    

    
        /*
        if (sprite_exists(img1)){sprite_delete(img1);}
        if (sprite_exists(img2)){sprite_delete(img2);}
        if (sprite_exists(img3)){sprite_delete(img3);}
        if (sprite_exists(img4)){sprite_delete(img4);}
        if (file_exists(working_directory + "\screen"+string(save[top])+".png")) then img1=sprite_add(working_directory + "\screen"+string(save[top])+".png",1,0,0,0,0);
        if (file_exists(working_directory + "\screen"+string(save[top+1])+".png")) then img2=sprite_add(working_directory + "\screen"+string(save[top+1])+".png",1,0,0,0,0);
        if (file_exists(working_directory + "\screen"+string(save[top+2])+".png")) then img3=sprite_add(working_directory + "\screen"+string(save[top+2])+".png",1,0,0,0,0);
        if (file_exists(working_directory + "\screen"+string(save[top+3])+".png")) then img4=sprite_add(working_directory + "\screen"+string(save[top+3])+".png",1,0,0,0,0);
        */
    }
}


/* */
/*  */
