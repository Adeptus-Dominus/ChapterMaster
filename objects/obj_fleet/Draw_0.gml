draw_set_alpha(1);

for (var i=array_length(explosions)-1; i>= 0;i--){
	if (explosions[i].draw() == -1){
		delete explosions[i];
		array_delete(explosions, i , 1);
	}
}
