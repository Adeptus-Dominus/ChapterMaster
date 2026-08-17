// Feather ignore all

/// @ignore
function __GMColorToHexString(_color) {
    /// @ignore
    static __DecToHex = function(_value) {
        var _hex = "0123456789ABCDEF";
        return string_copy(_hex, (_value div 16) + 1, 1) + string_copy(_hex, (_value % 16) + 1, 1);
    };

    var _r = color_get_red(_color);
    var _g = color_get_green(_color);
    var _b = color_get_blue(_color);

    return __DecToHex(_r) + __DecToHex(_g) + __DecToHex(_b);
}
