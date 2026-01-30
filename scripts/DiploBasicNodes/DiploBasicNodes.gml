// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function diplo_root_screen() {
    static ui = new UINode(0, 0, display_get_gui_width(), display_get_gui_height());
    return ui;
}

/// @desc  Function Description
/// @param {struct.uinode} node  Description
/// @param {real} guix  Description
/// @param {real} guiy  Description
/// @param {real} [width]=92 Description
/// @param {real} [height]=28 Description
/// @returns {struct.UINode}
function scr_add_diplo_button_node(node, guix, guiy, width = 92, height = 28) {
    static color = #98E800;
    static hover_color = #509000;
    static nbutton = "_ButtonRendererComponent";
    static ntext = "_TextRendererComponent";
    return node.add_child(guix, guiy, width, height)
        .add_component(UISpriteRendererComponent, node.gid + nbutton)
        .set_sprite(spr_rectangle)
        .set_color_solid(color)
        .finalize()
        .add_component(UITextRendererComponent, node.gid + ntext)
        .set_color_solid(c_black)
        .set_xscale(0.7)
        .set_yscale(0.7)
        .finalize()
        .add_component(UIMouseEventComponent)
        .set_event_type(MOUSE_EV_TYPE.ON_HOVER)
        .set_callback(method(NUIComponent(node.gid + nbutton), function(context) {
            set_color_solid(scr_add_diplo_button_node.hover_color);
        }))
        .finalize()
        .add_component(UIMouseEventComponent)
        .set_event_type(MOUSE_EV_TYPE.ON_LEAVE)
        .set_callback(method(NUIComponent(node.gid + nbutton), function(context) {
            set_color_solid(scr_add_diplo_button_node.color);
        }))
        .finalize();
}
