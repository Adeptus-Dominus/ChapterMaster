top = 1;
entries = 0;
scroll_cool = 0;
var t = -1;
event = [];
// Get upon load?
t = 0;
event = [];
//
help = 0;
help_topics = 0;
topic = "";
info = "";
strategy = "";
main_info = "";
topics[0] = "";
related[0] = "";
related[1] = "";
related[2] = "";
related[3] = "";
var e = -1;
repeat (101) {
    e += 1;
    topics[e] = "";
}
if (file_exists("main\\help.ini")) {
    ini_open("main\\help.ini");
    var ch;
    ch = 0;
    repeat (100) {
        ch += 1;
        if (ini_section_exists(string(ch))) {
            help_topics += 1;
            topics[help_topics] = ini_read_string(string(ch), "topic", "Error");
        }
    }
    ini_close();
}
if ((help_topics == 0) && (help != 0)) {
    instance_destroy();
}
