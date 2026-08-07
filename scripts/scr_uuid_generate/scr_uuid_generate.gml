/// @desc Joins 32 hexadecimal digits into the canonical 8-4-4-4-12 UUID layout.
/// @param {Array<String>} _uuid_array Exactly 32 single-character hexadecimal digits.
/// @returns {String}
function uuid_array_implode(_uuid_array) {
    var _string = "";
    var _separator = "-";
    var i = 0;

    repeat (8) {
        _string += _uuid_array[i++];
    }
    _string += _separator;

    repeat (3) {
        repeat (4) {
            _string += _uuid_array[i++];
        }
        _string += _separator;
    }

    repeat (12) {
        _string += _uuid_array[i++];
    }

    return _string;
}

/// @desc Returns the hexadecimal-digit string for the given decimal integer. One digit per nibble, with the high nibble of each byte omitted when it is zero.
/// @param {Real} _dec Non-negative integer.
/// @returns {String}
function dec_to_hex(_dec) {
    var _hex = _dec ? "" : "0";
    var _selection = "0123456789ABCDEF";

    while (_dec) {
        var _byte = _dec & 255;
        var _hi = string_char_at(_selection, (_byte div 16) + 1);
        var _lo = string_char_at(_selection, (_byte % 16) + 1);
        _hex = (_hi != "0" ? _hi : "") + _lo + _hex;
        _dec = _dec >> 8;
    }

    return _hex;
}

/// @desc Generates a V4 UUID string: all bits random except the version digit (13th hex digit is "4") and the variant digit (17th hex digit's high bits are binary 10).
/// @returns {String}
function scr_uuid_generate() {
    // seed randomness with time and since game start, in microseconds
    var _timer = get_timer();
    var _epoch_seconds = round(date_second_span(date_create_datetime(1970, 1, 1, 15, 0, 0), date_current_datetime()));
    var _date = _timer + (_epoch_seconds * 1000000);
    var _uuid = array_create(32);
    var _random = 0;

    for (var i = 0, l = array_length(_uuid); i < l; i++) {
        _random = floor((_date + random(1) * 16)) % 16;

        switch (i) {
            // Version bit
            case 12:
                _uuid[i] = "4";
                break;
            // Variant bit (RFC 4122 variant 1)
            case 16:
                _uuid[i] = dec_to_hex(_random & $3 | $8);
                break;
            // Standard random bits
            default:
                _uuid[i] = dec_to_hex(_random);
                break;
        }
    }

    return uuid_array_implode(_uuid);
}
