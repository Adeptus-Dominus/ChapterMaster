// Feather disable all

/// @func GitHubGist([description], [public])
/// @desc Constructor for creating a GitHub Gist.
/// @arg {String} [description] The description of the gist.
/// @arg {Bool} [public] Whether to create it as public or not.
/// Documentation: https://docs.github.com/en/rest/gists/gists#create-a-gist
function GitHubGist(_description = undefined, _public = undefined) constructor {
    // Variables
    description = _description;
    public = _public;
    files = {};

    // Methods
    /// @func generateJSON()
    /// @desc Generates JSON data to be sent with the POST request.
    /// @return {String} The JSON data.
    static generateJSON = function() {
        // Create Struct
        var _struct = {};

        // Desc
        if (description != undefined) {
            _struct[$ "description"] = description;
        }

        // Public
        if (public != undefined) {
            _struct[$ "public"] = public ? "true" : "false";
        }

        // Files
        if (variable_struct_names_count(files) > 0) {
            _struct[$ "files"] = files;
        } else {
            __GitHubError("GitHubGist requires files to be able to be uploaded.");
        }

        // Return JSON
        return json_stringify(_struct);
    };

    /// @func addFile(filename, content, [newFilename])
    /// @desc Add a file to this gist.
    /// @arg {String} filename The name of the file.
    /// @arg {String} content The content of the file.
    /// @arg {String} [newFilename] The new filename of the file (used only for editing gists).
    /// @return {Any}
    static addFile = function(_filename, _content, _newFilename = undefined) {
        var _contentStruct = {
            content: _content,
        };
        if (_newFilename != undefined) {
            _contentStruct[$ "filename"] = _newFilename;
        }
        files[$ _filename] = _contentStruct;
    };

    /// @func removeFile(filename)
    /// @desc Remove a file to this gist.
    /// @arg {String} filename The name of the file.
    /// @return {Any}
    static removeFile = function(_filename) {
        if (variable_struct_exists(files, _filename)) {
            variable_struct_remove(files, _filename);
        }
    };
}
