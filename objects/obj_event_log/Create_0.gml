top = 1;
entries = 0;
scroll_cool = 0;
event = [];
depth = -900;
// Get upon load?
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

for (var i = 0; i <= 100; i++) {
    topics[i] = "";
}
if (file_exists("main\\help.ini")) {
    ini_open("main\\help.ini");
    for (var ch = 1; ch <= 100; ch++) {
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
