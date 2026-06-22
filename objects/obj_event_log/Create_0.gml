top = 1;
entries = 0;
scroll_cool = 0;
// Get upon load?
event = [];
help = 0;
help_topics = 0;
topic = "";
info = "";
strategy = "";
main_info = "";
topics = array_create(101, "");
related = array_create(4, "");

if (file_exists(PATH_HELP_INI)) {
    ini_open(PATH_HELP_INI);
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
