// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

/// @desc Adds a common rock background renderer component to the UI node
/// @param {struct.UINode} node A Diplomacy UI node, or one of a few others [need to document still]
/// @returns {struct.UISpriteRendererComponent}
function scr_add_rock_bg_component(node) {
    var comp = node.add_component(UISpriteRendererComponent);
    return comp.set_sprite(spr_rock_bg); //incase we need ot do other stuff to the component
}

/// @desc Adds a common faction diplomacy icon renderer component to a UI node.
/// @param {struct.UINode} node A UI node that is owned by the root Diplomacy UI node.
/// @param {enum.eFACTION} faction The faction which to render the diplomacy icon of
function scr_add_faction_diplo_icon_component(node, faction) {
    var comp = node.add_component(UISpriteRendererComponent);
    //eventually have the component just have something else set the defeat/known/unknown values by using the returned handle where those values are first set.
    return comp.add_callback(method({faction, state: {defeated: false, known: false}}, function(context) {
        //we use a state variable to store whether this was defeated or not, so we don't change the sprite values again.
        if (!state.defeated) {
            //yes, this is weird, but it encodes it so each faction maps to the first image index in the diplo icon sprite...doesn't quite
            //work for female images though
            var idx = faction * 2 - 2;

            if (obj_controller.faction_defeated[faction]) {
                context.set_sprite(spr_diplomacy_defeated);
                state.defeated = true;
            }
            if (obj_controller.known[faction] > 0) {
                context.set_image_index(idx); //this value is for known
            } else if (obj_controller.known[faction] < 1) {
                context.set_image_index(idx + 1);
            } //this value is for unknown
        }
    }))
        .set_sprite(obj_controller.diplomacy_icon[1])
        .set_image_speed(0);
}
