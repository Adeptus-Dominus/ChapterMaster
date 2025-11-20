/// @description Insert description here
// You can write your code in this editor


add_draw_return_values();
var i=0;


draw_set_font(fnt_40k_14b);
draw_set_halign(fa_left);
draw_set_color(CM_GREEN_COLOR);

	
if (array_length(alert)) and (popups_end=1) {
    for (var i=0;i<array_length(alert);i++){
        var _cur_alert = alert[i];
        _cur_alert.draw();
    }
    if (fadeout && alert[0].alpha <= 0){
        instance_destroy();
    }
}

draw_set_alpha(1);
if (show>-1 && current_battle<battles && current_battle>-1){
    var _cur_battle = battles[current_battle];
    _cur_battle.draw();
}

pop_draw_return_values();
