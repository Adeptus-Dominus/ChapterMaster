
var xx,yy,x2,y2;
var romanNumerals=scr_roman_numerals();
xx=__view_get( e__VW.XView, 0 )+0;
yy=__view_get( e__VW.YView, 0 )+0;
tooltip_show=0;
x2=962;y2=117;
slate_panel.inside_method = function(){
    var x2=962;y2=157;
    var xx=__view_get( e__VW.XView, 0 )+0;
    var yy=__view_get( e__VW.YView, 0 )+0;
    draw_set_halign(fa_left);
    draw_set_font(fnt_40k_14b);
    draw_text(xx+962,yy+159,"Name");
    draw_text(xx+962.5,yy+159.5,"Name");
    if (shop!="production"){
        draw_text(xx+1280,yy+159,string_hash_to_newline("Stocked"));
        draw_text(xx+1280.5,yy+159.5,string_hash_to_newline("Stocked"));
        if (shop="equipment" or shop="equipment2"){
        draw_text(xx+1280+10+string_width("Stocked"),yy+159.5,string_hash_to_newline("MC"));
        draw_text(xx+1280+10.5+string_width("Stocked"),yy+159.5,string_hash_to_newline("MC"));
        }
    }
    draw_text(xx+1410,yy+159,string_hash_to_newline("Cost"));
    draw_text(xx+1410.5,yy+159.5,string_hash_to_newline("Cost"));
    draw_set_color(c_gray);


    if (shop="warships"){
        if (construction_started>0){
            var apa=construction_started/30;
            draw_set_alpha(apa);
            draw_set_color(c_yellow);
            draw_set_halign(fa_center);
            draw_text_transformed(__view_get( e__VW.XView, 0 )+420,yy+370,$"CONSTRUCTION STARTED!\nETA: {eta} months",1.5,1.5,0);
            draw_set_halign(fa_left);
            draw_set_color(38144);
            draw_set_alpha(1);
        }
    }
    var i=(scroll_point*28);
    var viable=1;
    var final =1;
    var entered;
    while (i<79 && viable<=28){
        entered=false;
        i++;
        y2+=20;
        if (item[i]!=""){
            viable++;
            final=i;
            if (!obj_controller.in_forge && nobuy[i]=0) ||  (obj_controller.in_forge && forge_cost[i]>0){
                draw_set_color(c_gray);
                if (point_in_rectangle(mouse_x, mouse_y, xx+962, yy+y2+2, xx+1580, yy+y2+18)){
                    draw_set_color(c_gray);
                    entered = true;
                    draw_rectangle(xx+960, yy+y2+1, xx+1582, yy+y2+18, 0);
                    draw_set_color(c_white);
                }

                if (shop!="production"){
                    if (!keyboard_check(vk_shift)) or (shop="warships") then draw_text(xx+x2+x_mod[i],yy+y2,string_hash_to_newline(item[i]));// Name
                    if (keyboard_check(vk_shift)) and (shop!="warships") then draw_text(xx+x2+x_mod[i],yy+y2,string_hash_to_newline(string(item[i])+" x5"));// Name
                } else {
                    draw_text(xx+x2+x_mod[i],yy+y2,string_hash_to_newline(item[i][1]));// Name
                }
                if (item_stocked[i]=0) and ((mc_stocked[i]=0) or (shop!="equipment")) then draw_set_alpha(0.5);
                if (mc_stocked[i]=0) and (shop!="production") then draw_text(xx+1300,yy+y2,string_hash_to_newline(item_stocked[i]));// Stocked
                if (mc_stocked[i]>0) then draw_text(xx+1300,yy+y2,string_hash_to_newline(string(item_stocked[i])+"   mc: "+string(mc_stocked[i])));
                draw_set_alpha(1);

                if (obj_controller.in_forge){
                    draw_sprite_ext(
                                spr_forge_points_icon,0, 
                                xx+1410,
                                yy+y2+3, 
                                0.3, 
                                0.3, 
                                0,
                                c_white,
                                1); 
                } else{
                    draw_sprite_ext(spr_requisition,0,xx+1410,yy+y2+6,1,1,0,c_white,1);
                }            
    			draw_set_color(16291875)
                if (obj_controller.in_forge){
    				draw_set_color(#af5a00)
    			}

                var cost = obj_controller.in_forge ? forge_cost[i] : item_cost[i]
                 if (!obj_controller.in_forge){
                    if (!keyboard_check(vk_shift)) and (obj_controller.requisition<item_cost[i]) then draw_set_color(255);
                    if (keyboard_check(vk_shift)) and (obj_controller.requisition<(item_cost[i]*5)) then draw_set_color(255);
                }
                if (shop!="production"){
                    if (keyboard_check(vk_shift)) then cost*=5;
                }

                draw_text(xx+1427,yy+y2,cost);// Requisition

                if (!obj_controller.in_forge ){
                    draw_sprite(spr_buy_tiny,0,xx+1530,yy+y2+2);
                    if (obj_controller.requisition< cost) then draw_set_alpha(0.25);
                    draw_set_alpha(1);

                    draw_sprite(spr_sell_tiny,0,xx+1480,yy+y2+2);
                    if (scr_hit(xx + 1480, yy + y2 + 2, xx + 1530, yy + y2 + 14) && shop != "warships" && shop != "vehicles") {
                        var _sell_mod = SHOP_SELL_MOD;
                        tooltip = $"Send items back for {_sell_mod * 100}% of the requisition cost.";
                        tooltip_show=1;
                        if (scr_click_left()) {
                            var sell_count = keyboard_check(vk_shift) ? 5 : 1;
                            sell_item(i, sell_count, _sell_mod)
                        }
                    }
                }

                var clicked = (point_and_click([xx+1520, yy+y2+2, xx+1570, yy+y2+14]));
                if (obj_controller.in_forge){
                    draw_sprite(spr_build_tiny,0,xx+1530,yy+y2+2);
                    if (clicked){
                        if (array_length(obj_controller.specialist_point_handler.forge_queue)<20){
                            var new_queue_item = {
                                name:item[i],
                                count:1,
                                forge_points:forge_cost[i],
                                ordered:obj_controller.turn,
                            }
                            if (shop!="production"){
                                if (keyboard_check(vk_shift)){
                                    new_queue_item.count = 5;
                                    new_queue_item.forge_points = 5 * forge_cost[i];
                                }
                            }
                            array_push(obj_controller.specialist_point_handler.forge_queue, new_queue_item);
                        }               
                    }
               } else if (nobuy[i]=0 && clicked && !obj_controller.in_forge){
                    cost=item_cost[i];
                    if (keyboard_check(vk_shift)) and (shop!="warships") then cost=item_cost[i]*5;
                    if (obj_controller.requisition>=cost) and (shop!="warships"){
                        if (item[i]!="Rhino") and (item[i]!="Predator") and (item[i]!="Land Raider") and (item[i]!="Whirlwind") and (item[i]!="Land Speeder"){
                            if (keyboard_check(vk_shift)){scr_add_item(item[i],5);item_stocked[i]+=5;click2=1;}
                            if (!keyboard_check(vk_shift)){scr_add_item(item[i],1);item_stocked[i]+=1;click2=1;}
                        }
                        if (item[i]="Rhino") or (item[i]="Predator") or (item[i]="Land Raider") or (item[i]="Whirlwind") or (item[i]="Land Speeder"){
                            if (keyboard_check(vk_shift)){repeat(5){scr_add_vehicle(item[i],target_comp,"standard","standard","standard","standard","standard");}item_stocked[i]+=5;click2=1;}
                            if (!keyboard_check(vk_shift)){
                                scr_add_vehicle(item[i],target_comp,"standard","standard","standard","standard","standard");
                                item_stocked[i]+=1;
                                click2=1;
                            }
                        }
                        with(obj_ini){scr_vehicle_order(obj_shop.target_comp);}
                        obj_controller.requisition-=cost;
                    }

                    if (obj_controller.requisition>=cost) and (shop=="warships"){

                        var _duration = 4;
                        if (item[i]="Battle Barge"){
                            _duration=30;
                        }
                        else if (item[i]="Strike Cruiser"){
                            _duration=10;
                        }

                        eta = _duration;

                        construction_started=120;
                        obj_controller.requisition -= cost;
                        add_event({
                            e_id : "ship_construction",
                            ship_class : item[i],
                            duration : _duration,
                        });
                    }
                }
            }
            if (!obj_controller.in_forge && nobuy[i]=1) ||  (obj_controller.in_forge && forge_cost[i]=0){
                draw_set_alpha(1);
                draw_set_color(881503);
                draw_text(xx+x2+x_mod[i],yy+y2,item[i]);// Name
                if (item_stocked[i]=0) then draw_set_alpha(0.5);
                draw_text(xx+1300,yy+y2,item_stocked[i]);// Stocked
                draw_set_alpha(1);
            }
            if (mouse_x>=xx+962) and (mouse_y>=yy+y2) and (mouse_x<xx+1280) and (mouse_y<yy+y2+19) and (shop!="warships"){
                if (last_item == item[i]){
                    tooltip_show=1;
                } else {
                    if (!is_string(tooltip_overide[i])){
                        tooltip=gen_item_tooltip(item[i])
                    } else {
                        tooltip = tooltip_overide[i];
                    }
                    tooltip_show=1;
                }
            }            

        }
    }
    //draw_set_color(c_red);
    pages_required = ceil(legitimate_items/28);
    for (i=0;i<pages_required;i++){
        if (scroll_point==i){
            (draw_unit_buttons([xx+1040+(25*i), yy+740], i+1,[1,1],c_green));
        }
        else if (point_and_click(draw_unit_buttons([xx+1040+(25*i), yy+740], i+1,[1,1],c_red))){
            scroll_point=i;
        }
    }
}
draw_set_color(c_white);
slate_panel.draw(xx+920, yy+95, 690/850, 0.85);
draw_set_font(fnt_40k_14b);
draw_set_color(c_gray);
draw_set_halign(fa_left);

var te="";
// TODO refactor target_comp and how companies are counted in general
if (shop=="vehicles"){
    if (target_comp<=10) then te=romanNumerals[target_comp-1];
    if (mouse_x>=xx+1262) and (mouse_y>=yy+78) and (mouse_x<=xx+1417) and (mouse_y<yy+103) then draw_set_alpha(0.8);
    draw_text(xx+1310,yy+82,string_hash_to_newline("Target: "+string(te)+" Company"));
}

draw_set_alpha(1);
draw_set_font(fnt_40k_14b);
draw_set_color(0);
var shop_area="";
if(tab_buttons.equipment.draw(xx+960,yy+64, "Equipment")){
    shop_area="equipment";
}
if (tab_buttons.armour.draw(xx+1075,yy+64, "Armour")){
    shop_area="equipment2";
}
if (tab_buttons.vehicles.draw(xx+1190,yy+64, "Vehicles")){
    shop_area="vehicles";
}
if (obj_controller.in_forge){
    if (tab_buttons.ships.draw(xx+1460,yy+64, "Manufactoring")){
        shop_area="production";
    }
}else{
    if (tab_buttons.ships.draw(xx+1460,yy+64, "Ships")){
        shop_area="warships";
    }
}

if (tooltip_show!=0){
    tooltip_draw(tooltip, 400)
}

if (shop_area!=""){
    obj_controller.cooldown=8000;
    shop=shop_area
    instance_create(50,50,obj_shop);
}
