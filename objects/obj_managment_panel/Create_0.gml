company = 0;
manage = 0;
header = 0;

title = "";
occupants = "";

panel_width = 0;
panel_height = 0;

line = [];
italic[0] = 0;
bold[0] = 0;
var i;
i = 0;
repeat (30) {
    i += 1;
    line[i] = "";
    italic[i] = 0;
    bold[i] = 0;
}

slate_panel = new DataSlate();


draw_lines = function (_x, _y, increment, truncate_line){
    for (var l = 0;l < array_length(line); l++){
        if (line[l] != "") {
            var _line = truncate_line ? string_truncate(line[l], 134) : line[l];
            draw_text(_x, _y + ((l) * increment), _line);
        }
    }    
}