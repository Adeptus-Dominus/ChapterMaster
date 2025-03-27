function uuid_array_implode() {
    var _string = "", i = 0, _uuid_array = argument0, sep = "-";

    repeat 8 { _string += _uuid_array[i++]; }
    _string += sep;

    repeat 3 {
        repeat 4 { _string += _uuid_array[i++]; }
        _string += sep;
    }

    repeat 12 { _string += _uuid_array[i++]; }

    return _string;
}

//  Returns a string of hexadecimal digits (4 bits each)
//  representing the given decimal integer. Hexadecimal
//  strings are padded to byte-sized pairs of digits.
//
//      dec         non-negative integer, real
function dec_to_hex() {
    var iff = function() {
        if (argument0) {
            return argument1;
        } else {
            return argument2;
        }
    }

    var dec, hex, _charactors, _selection, byte, hi, lo;
    dec = argument0;
    if (dec) { hex = ""; } else { hex = "0"; }
    _charactors = {
        numbers : "0123456789",
        uppercase : "ABCDEF"
//        lowercase : "abcdef"
    };
    _selection = $"{_charactors.numbers}{_charactors.uppercase}";
    while (dec) {
        byte = dec & 255;
        hi = string_char_at(_selection, byte / 16 + 1);
        lo = string_char_at(_selection, byte % 16 + 1);
        hex = iff(hi != "0", hi, "") + lo + hex;
        dec = dec >> 8;
    }
    return hex;
}

// Generate V4(almost all bits random) UUID
// - Must have the 13th hex digit set to "4" (version)
// - Must have the 17th hex digit's high bits set to binary 10 or 110 (variant)
// - Must utilize random or pseudo-random values for all other bits
function scr_uuid_generate() {
    var unix_epoch = function() {
        return round(date_second_span(date_create_datetime(1970,1,1,0,0,0), date_current_datetime()));
    }

    // seed randomness with time and since game start, in microseconds
    var _date = get_timer() + (unix_epoch() * 1000000), uuid = array_create(32), _random;

    for (var i = 0; i < array_length(uuid); i++) {
        _random = floor((_date + random(1) * 16)) % 16;

        if (i != 12 && i != 16) {
            uuid[i] = dec_to_hex(_random);
        } else {
            switch i {
            // version bit
            case 12:
                uuid[i] = "4";
                break;
            // variant bit, variant 1
            case 16:
                uuid[i] = dec_to_hex(_random & $3|$8);
                break;
            }
        }
    }

    return uuid_array_implode(uuid);
}
