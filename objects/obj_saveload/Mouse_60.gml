
if (slow<0) then slow=0;
slow+=1;

if (slow >= 3) {
	if (top > 1) {
		top -= 1;
		if (sprite_exists(img4)) {
			sprite_delete(img4);
		}
		img4 = img3;
		img3 = img2;
		img2 = img1;
        if (file_exists(string(PATH_save_previews, save[top]))) {
            img1 = sprite_add(string(PATH_save_previews, save[top]), 1, 0, 0, 0, 0);
        }
        
        if ((!sprite_exists(img3)) && file_exists(string(PATH_save_previews, save[top + 2]))) {
            img3 = sprite_add(string(PATH_save_previews, save[top + 3]), 1, 0, 0, 0, 0);
        }
        
        if ((!sprite_exists(img2)) && file_exists(string(PATH_save_previews, save[top + 1]))) {
            img2 = sprite_add(string(PATH_save_previews, save[top + 2]), 1, 0, 0, 0, 0);
        }
        
        if ((!sprite_exists(img1)) && file_exists(string(PATH_save_previews, save[top]))) {
            img1 = sprite_add(string(PATH_save_previews, save[top]), 1, 0, 0, 0, 0);
        }
	}
}
