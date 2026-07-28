/// @desc Ensures a directory exist, creates if not.
function file_ensure_directory(_path) {
    if (!directory_exists(_path)) {
        directory_create(_path);
    }
}
