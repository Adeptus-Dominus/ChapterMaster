function draw_unit_buttons(position, text, size_mod=[1.5,1.5],colour=c_gray,_halign=fa_center, font=fnt_40k_14b, alpha_mult=1, bg=false, bg_color=c_black){
	// TODO: fix halign usage
	// Store current state of all global vars
	var cur_alpha = draw_get_alpha();
	var cur_font = draw_get_font();
	var cur_color = draw_get_color();
	var cur_halign = draw_get_halign();
	var cur_valign = draw_get_valign();

	draw_set_font(font);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);

	var x2;
	var y2;
	var _text = string_hash_to_newline(text);
	if (array_length(position)>2){
		var x2 = position[2];
		var y2 = position[3];
	} else {
		var text_width = string_width(_text)*size_mod[0];
		var text_height = string_height(_text)*size_mod[1];
		var x2 = position[0]+text_width+(6*size_mod[0]);
		var y2 = position[1]+text_height+(6*size_mod[1]);
	}
	draw_set_alpha(1*alpha_mult);
	if (bg) {
		draw_set_color(bg_color);
		draw_rectangle(position[0], position[1], x2, y2, 0);
	}
	draw_set_color(colour);
	draw_text_transformed((position[0] + x2)/2, (position[1] + y2)/2, _text, size_mod[0], size_mod[1], 0);
	draw_rectangle(position[0],position[1], x2,y2,1)
	draw_set_alpha(0.5*alpha_mult);
	draw_rectangle(position[0]+1,position[1]+1, x2-1,y2-1,1)
	draw_set_alpha(0.25*alpha_mult);
	var mouse_consts = return_mouse_consts();	
	if (point_in_rectangle(mouse_consts[0],mouse_consts[1], position[0],position[1], x2,y2)){
		draw_rectangle(position[0],position[1], x2,y2,0);
	}

	// Reset all global vars to their previous state
	draw_set_alpha(cur_alpha);
	draw_set_font(cur_font);
	draw_set_color(cur_color);
	draw_set_halign(cur_halign);
	draw_set_valign(cur_valign);

	return [position[0],position[1], x2,y2];
}


//object containing draw_unit_buttons
function UnitButtonObject(data = false) constructor{
	x1 = 0;
	y1 = 0;
	w = 102;
	h = 30;
	h_gap= 4;
	v_gap= 4;
	label= "";
	alpha= 1;
	color = #50a076;
	keystroke = false;
	tooltip = "";
	bind_method = "";
	style = "standard";
	font=fnt_40k_14b


	static update_loc = function(){
		if (label != ""){
			w = string_width(label) + 10;
		};
		x2 = x1 + w;
		y2 = y1 + h;		
	}
	static update = function(data){
		var _updaters = struct_get_names(data);
		var i=0;
		for (i=0;i<array_length(_updaters);i++){
			self[$ _updaters[i]] = data[$ _updaters[i]];
		}
		update_loc();
	}
	if (data != false){
		update(data);
	}

	update_loc();
	static move = function(m_direction, with_gap=false, multiplier=1){
		switch(m_direction){
			case "right":
				x1 +=( w+(with_gap*v_gap))*multiplier;
				x2 += (w+(with_gap*v_gap))*multiplier;
				break;
			case "left":
				x1 -= (w+(with_gap*v_gap))*multiplier;
				x2 -= (w+(with_gap*v_gap))*multiplier;
				break;
			case "down":
				y1 += (h+(with_gap*h_gap))*multiplier;
				y2 += (h+(with_gap*h_gap))*multiplier;
				break;
			case "up":
				y1 -= (h+(with_gap*h_gap))*multiplier;
				y2 -= (h+(with_gap*h_gap))*multiplier;
				break;								
		}
	}
	static draw = function(allow_click = true){
		var cur_alpha = draw_get_alpha();
		var cur_font = draw_get_font();
		var cur_color = draw_get_color();
		var cur_halign = draw_get_halign();
		var cur_valign = draw_get_valign();
		if (style = "standard"){
			var _button_click_area = draw_unit_buttons(w > 0 ? [x1, y1, x2, y2] : [x1, y1] , label, [1,1],color,,font,alpha);
		} else if (style = "pixel"){

			var _widths =  [sprite_get_width(spr_pixel_button_left), sprite_get_width(spr_pixel_button_middle), sprite_get_width(spr_pixel_button_right)]

			var height_scale = h/sprite_get_height(spr_pixel_button_left);
			_widths[0]*=height_scale;
			_widths[2]*=height_scale;
			draw_sprite_ext(spr_pixel_button_left, 0, x1, y1, height_scale, height_scale, 0, c_white, 1);
			var _width_scale = w/_widths[1];
			_widths[1] *= _width_scale;
			draw_sprite_ext(spr_pixel_button_middle, 0, x1 + _widths[0], y1, _width_scale, height_scale, 0, c_white, 1);
			draw_sprite_ext(spr_pixel_button_right, 0, x1 + _widths[0] + _widths[1] ,y1, height_scale, height_scale, 0, c_white, 1);
			var _text_position_x = x1 + ((_widths[0] + 2) * height_scale);
			_text_position_x += (_widths[1]) / 2;
			draw_set_font(font);
			draw_set_halign(fa_center);
			draw_set_valign(fa_middle);
			draw_set_color(color);
			draw_text_transformed(_text_position_x, y1 + ( (h * height_scale)/2),  label, 1, 1, 0);

			x2 = x1 + array_sum(_widths);
			y2 = y1 + h;
			var _button_click_area = [x1, y1, x2, y2];
		}
		draw_set_alpha(cur_alpha);
		draw_set_font(cur_font);
		draw_set_color(cur_color);
		draw_set_halign(cur_halign);
		draw_set_valign(cur_valign);	
			
		if (scr_hit(x1, y1, x2, y2) && tooltip!=""){
			tooltip_draw(tooltip);
		}

		if (allow_click){
			var clicked = point_and_click(_button_click_area) || keystroke;
			if (clicked){
				if (is_callable(bind_method)){
					bind_method();
				}
			}
			return clicked
		} else {
			return false;
		}
	}
}

function PurchaseButton(req) : UnitButtonObject() constructor{
	req_value = req;
	static draw = function(allow_click=true){
		
		var _but = draw_unit_buttons([x1, y1, x2, y2], label, [1,1],color,,,alpha);
		var _sh = sprite_get_height(spr_requisition);
		var _scale = (y2 - y1) / _sh;
		draw_sprite_ext(spr_requisition,0,x1,y2,_scale,_scale,0,c_white,1);
		var _allow_click = obj_controller.requisition >= req_value;
		if (scr_hit(x1, y1, x2, y2) && tooltip!=""){
			tooltip_draw(tooltip);
		}
		if (allow_click && _allow_click){
			var clicked = point_and_click(_but) || keystroke;
			if (clicked){
				if (is_callable(bind_method)){
					bind_method();
				}
				obj_controller.requisition -= req_value;
			}
			return clicked
		} else {
			return false;
		}		
	}
}


function slider_bar() constructor{
	x1 = 0;
	y1 = 0;
	w = 102;
	h = 15
	value_limits = [0,0];
	value_increments = 1;
	value = 0;
	dragging = false;
	slider_pos = 0;
	static update = function(data){
	    var _data_presets = struct_get_names(data);
	    for (var i=0;i<array_length(_data_presets);i++){
	    	self[$_data_presets[i]] = data[$_data_presets[i]];
	    }		
	}
	function draw(){
		if (value<value_limits[0]){
			value = value_limits[0];
		}
		if (dragging){
			dragging = mouse_check_button(mb_left);
		}
		var _rect = [x1,y1,x1+w, y1+h];
		draw_rectangle_array(_rect,1);
		width_increments = w/((value_limits[1]-value_limits[0])/value_increments);
		var __rel_cur_pos = increments*(value - value_limits[0]);
		var _mouse_pos = return_mouse_consts();
		var _lit_cur_pos = _rel_cur_pos+x1;
		if (scr_hit(_rect) && !dragging){
			if (point_distance(_lit_cur_pos, 0, _mouse_pos[0], 0)>increments){
				if (mouse_check_button(mb_left)){
					dragging = true
				}
			}
		}
		if (dragging){
			if (_mouse_pos[0]>(_rect[2])){
				value = value_limits[1];
			} else if (_mouse_pos[0]<(_rect[0])){
				value = value_limits[0];
			} else {
				var mouse_rel = _mouse_pos[0] - x1;
				var increment_count = (mouse_rel/width_increments);
				value = value_limits[0] + (increment_count * value_increments);
			}
		}
	}
}
function TextBarArea(XX,YY,Max_width = 400, requires_input = false) constructor{
	allow_input=false;
	self.requires_input = requires_input;
	xx=XX;
	yy=YY
	max_width = Max_width;
	draw_col = c_gray;
	cooloff=0
    // Draw BG
    static draw = function(string_area){
		var old_font = draw_get_font();
		var old_halign = draw_get_halign();

    	if (cooloff>0) then cooloff--;
    	if (allow_input){
    		string_area=keyboard_string;
    	}
	    draw_set_alpha(1);
	    //draw_sprite(spr_rock_bg,0,xx,yy);
	    draw_set_font(fnt_40k_30b);
	    draw_set_halign(fa_center);
	    draw_set_color(draw_col);// 38144	
		var bar_wid=max_width,click_check, string_h;
	    draw_set_alpha(0.25);
	    if (string_area!=""){
	    	bar_wid=max(max_width,string_width(string_hash_to_newline(string_area)));
	    } else {
	    	if (requires_input){
	    		draw_set_color(c_red);
	    	}
	    }
		string_h = string_height("LOL");
		var rect = [xx-(bar_wid/2),yy,xx+(bar_wid/2),yy-8+string_h]
	    draw_rectangle(rect[0],rect[1],rect[2],rect[3],1);
	    click_check = point_and_click(rect);
	    obj_cursor.image_index=0;
	    if (cooloff==0){
		    if (allow_input && mouse_check_button(mb_left) && !click_check){
	    	    allow_input=false;
	    	    cooloff=5;
	    	}else if (!allow_input && click_check){
		        obj_cursor.image_index=2;
		        allow_input=true;
	        	keyboard_string = string_area;
	        	cooloff=5;
		    }
		}

	    draw_set_alpha(1);

    	draw_set_font(fnt_fancy);
        if (!allow_input) then draw_text(xx,yy+2,string_hash_to_newline("''"+string(string_area)+"'' "));
        if (allow_input){
        	obj_cursor.image_index=2;
        	draw_text(xx,yy+2,$"''{string_area}|''")
        };

		draw_set_font(old_font);
		draw_set_halign(old_halign);

		return string_area;
	}
}


function drop_down(selection, draw_x, draw_y, options,open_marker){
	if (selection!=""){
		var drop_down_area = draw_unit_buttons([draw_x, draw_y],selection,[1,1],c_green);
		draw_set_color(c_red);
		if (array_length(options)>1){
			if (scr_hit(drop_down_area)){
                current_target=true;
				var roll_down_offset=4+string_height(selection);
				for (var col = 0;col<array_length(options);col++){
					if (options[col]==selection) then continue;
					var cur_option = draw_unit_buttons([draw_x , draw_y+roll_down_offset],options[col],[1,1],c_red,,,,true);
					if (point_and_click(cur_option)){
						selection = options[col];
						open_marker = false;
					}
					roll_down_offset += string_height(options[col])+4;

				}
				if (!scr_hit(
						draw_x,
						draw_y,
						draw_x + 5 +string_width(selection),
						draw_y+roll_down_offset,
					)
				){
					open_marker = false;
                    if (current_target) then current_target=false;
				}
			} else {
                current_target=false;
            }
		}
	}
    return [selection,open_marker];
}

function multi_select(options_array, title)constructor{
	self.title = title;
	x_gap = 10;
	y_gap = 5;
	x1 = 0;
	y1 = 0;
	x2 = 0;
	y2 = 0;
	on_change = false;
	active_col = #009500;
	innactive_col = c_gray;	
	max_width = 0;
	max_height = 0;
	toggles = [];
	for (var i=0;i<array_length(options_array);i++){
		var _next_tog = new ToggleButton(options_array[i]);
		_next_tog.active = false;
		array_push(toggles, _next_tog);
	}
	static update = item_data_updater
	static draw = function(){
		var _change_method = is_callable(on_change);
		draw_text(x1, y1, title);

		var _prev_x = x1;
		var _prev_y = y1+string_height(title)+10;
		var items_on_row = 0;
		for (var i=0;i<array_length(toggles);i++){
			var _cur_opt = toggles[i];
			_cur_opt.x1 = _prev_x;
			_cur_opt.y1 = _prev_y;
			_cur_opt.update()
			if (_cur_opt.clicked()){
				if (_change_method){
					on_change();
				}
			}
			_cur_opt.button_color = _cur_opt.active ? active_col: innactive_col;
			_cur_opt.draw();
			items_on_row++

			_prev_x = _cur_opt.x2+x_gap;

			x2 = _prev_x>x2 ? _prev_x:x2;
			y2 = _prev_y + _cur_opt.height;
			if (max_width>0){
				if (_prev_x - x1 > max_width){
					_prev_x = x1;
					_prev_y += _cur_opt.height+y_gap;
					items_on_row = 0;
				}
			}
		}
	}
	static set = function(set_array){
		for (var s=0;s<array_length(set_array);s++){
			var _setter = set_array[s];
			for (var i=0;i<array_length(toggles);i++){
				var _cur_opt = toggles[i];
				_cur_opt.active = _cur_opt.str1 == _setter;
				if (_cur_opt.str1 == _setter){

				}
			}			
		}
	}
	static selections = function(){
		var _selecs = [];
		for (var i=0;i<array_length(toggles);i++){
			var _cur_opt = toggles[i];
			if (_cur_opt.active){
				array_push(_selecs, _cur_opt.str1);
			}
		}
		return _selecs;
	}	
}

function item_data_updater(data){
    var _data_presets = struct_get_names(data);
    for (var i=0;i<array_length(_data_presets);i++){
    	self[$_data_presets[i]] = data[$_data_presets[i]];
    }		
}
function radio_set(options_array, title)constructor{
	toggles = [];
	current_selection = 0;
	self.title = title;
	active_col = #009500;
	innactive_col = c_gray;
	allow_changes = true;
	x_gap = 10;
	y_gap = 5;
	x1 = 0;
	y1 = 0;
	draw_title = true;
	changed = false;
	max_width = 0;
	max_height = 0;
	for (var i=0;i<array_length(options_array);i++){
		array_push(toggles, new ToggleButton(options_array[i]));
	}
	x2 = 0;
	y2 = 0;

	static update = item_data_updater;
	static draw = function(){
		if (draw_title){
			draw_text(x1, y1, title);
		}

		changed = false;
		var _start_current_selection = current_selection;
		var _prev_x = x1;
		var _prev_y = y1+string_height(title)+10;
		var items_on_row = 0;
		for (var i=0;i<array_length(toggles);i++){
			var _cur_opt = toggles[i];
			_cur_opt.x1 = _prev_x;
			_cur_opt.y1 = _prev_y;
			_cur_opt.update()
			_cur_opt.active = i==current_selection;
			_cur_opt.button_color = _cur_opt.active ? active_col: innactive_col;
			_cur_opt.draw();
			items_on_row++
			
			if (_cur_opt.clicked() && allow_changes){
				current_selection = i;
			}
			_prev_x = _cur_opt.x2+x_gap;

			x2 = _prev_x>x2 ? _prev_x:x2;
			y2 = _prev_y + _cur_opt.height;
			if (max_width>0){
				if (_prev_x - x1 > max_width){
					_prev_x = x1;
					_prev_y += _cur_opt.height+y_gap;
					items_on_row = 0;
				}
			}
		}
		if (_start_current_selection != current_selection){
			changed = true;
		}
	}
}

function ToggleButton(data={}) constructor {
    x1 = 0;
    y1 = 0;
	x2 = 0;
	y2 = 0;
	tooltip = "";
    str1 = "";
    width = 0;
	height = 0;
    state_alpha = 1;
    hover_alpha = 1;
    active = true;
    text_halign = fa_left;
    text_color = c_gray;
    button_color = c_gray;
    font = fnt_40k_12;
    var _data_presets = struct_get_names(data);
    for (var i=0;i<array_length(_data_presets);i++){
    	self[$_data_presets[i]] = data[$_data_presets[i]];
    }
    update = function () {
    	draw_set_font(font);
        if (width == 0) {
            width = string_width(str1) + 4;
        }
        if (height == 0) {
            height = string_height(str1) + 4;
        }
        x2 = x1 + width;
        y2 = y1 + height;
    };

    hover = function() {
        return (scr_hit(x1, y1, x2, y2));
    };

    clicked = function() {
        if (hover() && scr_click_left()) {
			active = !active;
			audio_play_sound(snd_click_small, 10, false, 1);
			return true;
        } else {
            return false;
        }
    };

    draw = function() {
    	draw_set_font(font);
        var str1_h = string_height(str1);
        var text_padding = width * 0.03;
        var text_x = x1 + text_padding;
        var text_y = y1 + text_padding;
        var total_alpha;

        if (text_halign == fa_center) {
            text_x = x1 + (width / 2);
        }

        if (!active){
            if (state_alpha > 0.5) state_alpha -= 0.05;
        }
        else{
            if (state_alpha < 1) state_alpha += 0.05;
            if (hover()) {
                if (hover_alpha > 0.8) hover_alpha -= 0.02; // Decrease state_alpha when hovered
            } else {
                if (hover_alpha < 1) hover_alpha += 0.03; // Increase state_alpha when not hovered
            }
        }
        if (tooltip!=""){
        	if (hover()){
	        	tooltip_draw(tooltip);
	        }
        }

        total_alpha = state_alpha * hover_alpha;
        draw_rectangle_color_simple(x1, y1, x1 + width, y1 + str1_h, 1, button_color, total_alpha);
        draw_set_halign(text_halign);
        draw_set_valign(fa_top);
        draw_text_color_simple(text_x, text_y, str1, text_color, total_alpha);
        draw_set_alpha(1);
        draw_set_halign(fa_left);
    };
}

function InteractiveButton(data={}) constructor {
    x1 = 0;
    y1 = 0;
	x2 = 0;
	y2 = 0;
    str1 = "";
    inactive_tooltip = "";
    tooltip = "";
    width = 0;
	height = 0;
    state_alpha = 1;
    hover_alpha = 1;
    active = true;
    text_halign = fa_left;
    text_color = c_gray;
    button_color = c_gray;
    var _data_presets = struct_get_names(data);
    for (var i=0;i<array_length(_data_presets);i++){
    	self[$_data_presets[i]] = data[$_data_presets[i]];
    }
    update = function () {
        if (width == 0) {
            width = string_width(str1) + 4;
        }
        if (height == 0) {
            height = string_height(str1) + 4;
        }
        x2 = x1 + width;
        y2 = y1 + height;
    };

    hover = function() {
        return (scr_hit(x1, y1, x2, y2));
    };

    clicked = function() {
        if (hover() && scr_click_left()) {
            if (!active){
                audio_play_sound(snd_error, 10, false, 1);
                return false;
            } else {
                audio_play_sound(snd_click_small, 10, false, 1);
                return true;
            }
        } else {
            return false;
        }
    };

    draw = function() {
        var str1_h = string_height(str1);
        var text_padding = width * 0.03;
        var text_x = x1 + text_padding;
        var text_y = y1 + text_padding;
        var total_alpha;

        if (text_halign == fa_center) {
            text_x = x1 + (width / 2);
        }

        if (!active){
            if (state_alpha > 0.5) state_alpha -= 0.05;
            if (inactive_tooltip != "" && hover()) {
                tooltip_draw(inactive_tooltip);
            }
        } else{
            if (state_alpha < 1) state_alpha += 0.05;
            if (hover()) {
                if (hover_alpha > 0.8) hover_alpha -= 0.02; // Decrease state_alpha when hovered
                if (tooltip != "") {
                    tooltip_draw(tooltip);
                }
            } else {
                if (hover_alpha < 1) hover_alpha += 0.03; // Increase state_alpha when not hovered
            }
        }

        total_alpha = state_alpha * hover_alpha;
        draw_rectangle_color_simple(x1, y1, x1 + width, y1 + str1_h, 1, button_color, total_alpha);
        draw_set_halign(text_halign);
        draw_set_valign(fa_top);
        draw_text_color_simple(text_x, text_y, str1, text_color, total_alpha);
        draw_set_alpha(1);
        draw_set_halign(fa_left);
    };
}

function list_traveler(list, cur_val, move_up_coords, move_down_coords){
	var _new_val = cur_val;
    var _found = false;
    for (var i=0;i<array_length(list);i++){
        if (cur_val==list[i]){
            _found = true;
            if (point_and_click(move_up_coords)){
                if (i==array_length(list)-1){
                    _new_val=list[0];
                } else {
                    _new_val=list[i+1];
                }
            }
            else if (point_and_click(move_down_coords)){
                if (i==0){
                    _new_val=list[array_length(list)-1];
                } else {
                    _new_val=list[i-1];
                }
            }
        }
    }
    // If value not found in list, default to first element
    if (!_found && array_length(list) > 0) {
        _new_val = list[0];
    }
    return _new_val;
}

