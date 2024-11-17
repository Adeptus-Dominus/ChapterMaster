// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function UIRenderComponent(owner, name) : UIComponent(owner, name) constructor {
	callback = function(c) {}
	is_visible = true;
	alpha = 255;
	col1 = c_white
	col2 = c_white
	col3 = c_white
	col4 = c_white
	angle = 0;
	
	static set_callback = function(cb) {
		if is_callable(cb)
			callback = cb;
		return self
	}
	static set_visible = function(val) {
		is_visible = val;
		return self
	}
	static set_alpha = function(val) {
		alpha = val;
		return self;
	}
	static set_color_solid = function(color) {
		col1 = color;
		col2 = color;
		col3 = color;
		col4 = color;
		return self;
	}
	static set_vertical_gradient = function(colort, colorb) {
		col1 = colort
		col2 = colort
		col3 = colorb
		col4 = colorb
		return self;
	}
	
	static set_horizontal_gradient = function(colorl, colorr) {
		col1 = colorl
		col2 = colorr
		col3 = colorr
		col4 = colorl
		return self;
	}
	static set_color_direct = function(c1, c2, c3, c4) {
		col1 = c1;
		col2 = c2;
		col3 = c3;
		col4 = c4;
		return self;
	}
	
	static set_angle = function(val) {
		angle = val
		return self;
	}
}

function UITextRendererComponent(owner, name) : UIRenderComponent(owner, name) constructor {
	text = "";
	sep = 16;
	font = fnt_menu;
	xscale = 1;
	yscale = 1;
	valign = fa_top
	halign = fa_left
	xoffset = 0;
	yoffset = 0;

	static render = function(gx,gy) {
		
		if !is_visible
			return;
		callback(self);
		if draw_get_font() != font {
			draw_set_font(font)	
		}
		var orig_valign = draw_get_valign()
		var orig_halign = draw_get_halign()
		if orig_halign != halign || orig_valign != valign {
			draw_set_valign(valign)
			draw_set_halign(halign)
		}
		
		draw_text_ext_transformed_color(gx + xoffset,gy + yoffset,text,sep,owner.width,xscale,yscale,angle ,col1, col2, col3, col4, alpha);
		/*
		if orig_halign != halign || orig_valign != valign {
			draw_set_valign(orig_valign)
			draw_set_halign(orig_halign)
		}*/
	}
	static set_text = function(text) {
		self.text = text;
		return self;
	}
	
	static set_string_seperation = function(val) {
		sep = val
		return self;
	}
	static set_xscale = function(val) {
		xscale = val
		return self;
	}
	static set_yscale = function(val) {
		yscale = val;
		return self
	}
	
	static set_font = function(val) {
		font = val
		return self
	}
	
	static set_valign = function(va) {
		valign = va
		if va == fa_top
			yoffset = 0;
		else if va == fa_middle
			yoffset = owner.height/2
		else
			yoffset = owner.height
		return self
	}
	
	static set_halign = function(ha) {
		halign = ha
		if ha == fa_left
			xoffset = 0
		else if ha == fa_center
			xoffset = owner.width/2
		else
			xoffset = owner.width
		return self	
	}
}

function UISpriteRendererComponent(owner, name) : UIRenderComponent(owner, name) constructor {
	sprite = -1;
	img_index = 0;
	img_speed = 1;
	left = 0;
	top = 0;
	width = owner.width;
	height = owner.height;
	
	is_canceled = false;
	
	//@ignore
	__spr_width = 0;
	//@ignore
	__spr_height = 0;
	//@ignore
	__spr_frames = 0;
	
	static render = function(gx,gy) {
		if (!is_visible)
			exit;
		callback(self);
		//test if callback canceled this
		if (is_canceled || sprite == -1 || !sprite_exists(sprite)){
			exit;
		}
		try{
			draw_sprite_general(
				sprite,
				img_index,
				left,
				top,
				__spr_width,
				__spr_height,
				gx,
				gy,
				owner.width/__spr_width,
				owner.height/__spr_height,
				angle,
				col1,
				col2,
				col3,
				col4,
				alpha
			)
		} catch(_exception){
            handle_exception(_exception);
		}
		img_index = (img_index + img_speed) % __spr_frames;
	}
	
	static set_sprite = function(sprite) {
		if !sprite_exists(sprite)
			exit;
		self.sprite = sprite;
		img_index = 0;
		__spr_width = sprite_get_width(sprite)
		__spr_height = sprite_get_height(sprite)
		__spr_frames = sprite_get_number(sprite)
		return self;
	}
	
	static set_image_index = function(val) {
		img_index = val;
		return self;
	}
	
	static set_image_speed = function(val) {
		img_speed = val
		return self;	
	}
	
	static set_top = function(val) {
		top = val
		return self;
	}
	
	static set_left = function(val) {
		left = val;
		return self;
	}
}