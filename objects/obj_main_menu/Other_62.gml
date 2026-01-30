var result, evid;
evid = ds_map_find_value(async_load, "id");

switch (evid) {
    case async_ini:
        result = ds_map_find_value(async_load, "result");
        file = file_text_open_write("pass.ini");
        file_text_write_string(file, result);
        file_text_close(file);

        ini_open("pass.ini");
        blog_url = ini_read_string("Data", "blog", "Error");
        word_from_duke = ini_read_string("Data", "message", "blank");
        word_from_duke2 = ini_read_string("Data", "message2", "blank");
        something_version = ini_read_real("Data", "version", 0);
        ini_close();

        break;
}
