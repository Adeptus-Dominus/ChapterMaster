if (sprite_exists(img1)) {
	sprite_delete(img1);
}
if (sprite_exists(img2)) {
	sprite_delete(img2);
}
if (sprite_exists(img3)) {
	sprite_delete(img3);
}
if (sprite_exists(img4)) {
	sprite_delete(img4);
}
if (file_exists(string(PATH_save_previews, save[top]))) {
	img1 = sprite_add(string(PATH_save_previews, save[top]), 1, 0, 0, 0, 0);
}
if (file_exists(string(PATH_save_previews, save[top + 1]) + ".png")) {
	img2 = sprite_add(string(PATH_save_previews, save[top + 1]), 1, 0, 0, 0, 0);
}
if (file_exists(string(PATH_save_previews, save[top + 2]) + ".png")) {
	img3 = sprite_add(string(PATH_save_previews, save[top + 2]), 1, 0, 0, 0, 0);
}
if (file_exists(string(PATH_save_previews, save[top + 3]))) {
	img4 = sprite_add(string(PATH_save_previews, save[top + 3]), 1, 0, 0, 0, 0);
}
