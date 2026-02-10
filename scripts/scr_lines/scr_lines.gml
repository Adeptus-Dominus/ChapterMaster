/// @desc Inserts "@" line-break markers into a string at the given breakpoint interval.
/// @param {real} _breakpoint Maximum characters per line before a break is inserted.
/// @param {string} _str The source string to process.
function scr_lines(_breakpoint, _str) {
    var _indexed = _breakpoint + 1;
    var _index = _indexed;
    var _loop = 1;
    var _string = _str;

    var i;

    if (_indexed <= 1) {
        return "Error: breakpoint must be larger than 0";
    }

    while (_loop == 1) {
        if (_index > string_length(_string)) {
            _loop = 0;
            break;
        }
        for (i = _index; string_char_at(_string, i) != " "; i -= 1) {
            if (i % _indexed == 1) {
                break;
            }
        }
        if (i % _indexed != 1) {
            _string = string_delete(_string, i, 1);
            _string = string_insert("@", _string, i);
            _index = i;
        } else {
            _string = string_insert("@", _string, _index);
            _index += 1;
        }
        _index += _indexed;
    }
    _string += "@";
    return _string;
}
