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

    var dec, hex, charactors, byte, hi, lo;
    dec = argument0;
    if (dec) { hex = ""; } else { hex = "0"; }
    charactors = "0123456789ABCDEF";
    while (dec) {
        byte = dec & 255;
        hi = string_char_at(charactors, byte / 16 + 1);
        lo = string_char_at(charactors, byte % 16 + 1);
        hex = iff(hi != "0", hi, "") + lo + hex;
        dec = dec >> 8;
    }
    return hex;
}

// Generate V4 UUID
function scr_uuid_generate() {
    var epoch = function() {
        return round(date_second_span(date_create_datetime(2016,1,1,0,0,1), date_current_datetime()));
    }

    var _date = current_time + epoch() * 10000, uuid = array_create(32), i = 0, _random;

    for (i = 0; i < array_length(uuid); i++) {
        _random = floor((_date + random(1) * 16)) % 16;

        if (i == 16) {
            uuid[i] = dec_to_hex(_random & $3|$8);
        } else {
            uuid[i] = dec_to_hex(_random);
        }
    }

    uuid[12] = "4";

    return uuid_array_implode(uuid);
}
