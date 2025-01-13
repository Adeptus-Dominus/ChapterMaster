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
function UnitButtonObject() constructor{
	x1 = 0;
	y1 = 0;
	w = 102;
	h = 30;
	h_gap= 4;
	v_gap= 4;
	label= "";
	alpha= 1;
	color= #50a076;
	keystroke = false;
	tooltip = "";

	static update = function(data){
		var _updaters = struct_get_names(data);
		var i=0
		for (i=0;i<array_length(_updaters);i++){
			self[$ _updaters[i]] = data[$ _updaters[i]];
		}
	}

	static update_loc = function(){
		x2 = x1 + w;
		y2 = y1 + h;		
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
		if (scr_hit(x1, y1, x2, y2) && tooltip!=""){
			tooltip_draw(tooltip);
		}
		if (allow_click){
			return (point_and_click(draw_unit_buttons([x1, y1, x2, y2], label, [1,1],color,,,alpha)) || keystroke);
		} else {
			draw_unit_buttons([x1, y1, x2, y2], label, [1,1],color,,,alpha);
			return false;
		}
	}
}

function TextBarArea(XX,YY,Max_width = 400) constructor{
	allow_input=false;
	xx=XX;
	yy=YY
	max_width = Max_width;
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
	    draw_set_color(c_gray);// 38144	
		var bar_wid=max_width,click_check, string_h;
	    draw_set_alpha(0.25);
	    if (string_area!=""){
	    	bar_wid=max(max_width,string_width(string_hash_to_newline(string_area)));
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
        	draw_text(xx,yy+2,string_hash_to_newline("''"+string(string_area)+"|''"))
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

function ToggleButton() constructor {
    x1 = 0;
    y1 = 0;
	x2 = 0;
	y2 = 0;
    str1 = "";
    width = 0;
	height = 0;
    state_alpha = 1;
    hover_alpha = 1;
    active = true;
    text_halign = fa_left;
    text_color = c_gray;
    button_color = c_gray;

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
			active = !active;
			audio_play_sound(snd_click_small, 10, false, 1);
			return true;
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
        }
        else{
            if (state_alpha < 1) state_alpha += 0.05;
            if (hover()) {
                if (hover_alpha > 0.8) hover_alpha -= 0.02; // Decrease state_alpha when hovered
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

function InteractiveButton() constructor {
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