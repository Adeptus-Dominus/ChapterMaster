/// @desc A single alert line queued for the turn-end report and played back by obj_turn_end.
/// @param {String|Constant.Color|Real} _colour Valid colours: green, yellow, red, purple, GM colourcodes (c_ prefix), decimal, hexadecimal ($ prefix, 6 or 8 digits) and CSS (# prefix)
/// @param {String} _type Alert category label (informational)
/// @param {String} _text Alert body text
function NotificationAlert(_colour, _type, _text) constructor {
    colour = _colour;

    /// Unused atm
    type = _type;

    text = "-" + string(_text);

    // Runtime playback state, owned by obj_turn_end:
    alpha = 0;
    char = 0;
    txt = "";
}
