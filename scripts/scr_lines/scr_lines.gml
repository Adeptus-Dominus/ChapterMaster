function scr_lines(argument0, argument1) {
    //Arg 0 is the breakpoint
    //Arg 1 is your string
    {
        var str, indexed, index, loop, i;
        indexed = argument0 + 1;
        str = argument1;
        index = indexed;
        loop = 1;

        if (indexed <= 1) {
            loop = 0;
            return "Error: breakpoint must be larger than 0";
        }

        while (loop == 1) {
            if (index > string_length(str)) {
                loop = 0;
                break;
            }
            for (i = index; string_char_at(str, i) != " "; i -= 1) {
                if (i % indexed == 1) {
                    break;
                }
            }
            if (i % indexed != 1) {
                str = string_delete(str, i, 1);
                str = string_insert("@", str, i);
                index = i;
            } else {
                str = string_insert("@", str, index);
            }
            index += indexed;
        }
        str += "@";
        return str;
    }
}
