function CoordsStruct({}) constructor{
	static update = item_data_updater;

	static hit = function(){
		return scr_hit(x1,y1,x2,y2);
	}

	static left_click = function(){
		return point_and_click([(x1,y1,x2,y2]);
	}
}