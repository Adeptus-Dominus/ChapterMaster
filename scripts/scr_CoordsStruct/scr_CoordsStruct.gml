function CoordsStruct(data  = {}) constructor{
	x1 = 0;
	y1 = 0;
	x2 = 0;
	y2 = 0;
	static update = item_data_updater;

	update(data);

	static hit = function(){
		return scr_hit(x1,y1,x2,y2);
	}

	static left_click = function(){
		return point_and_click([(x1,y1,x2,y2]);
	}
}