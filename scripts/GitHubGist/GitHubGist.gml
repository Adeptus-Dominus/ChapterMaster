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
    removedFiles = {};

    // Methods
    /// @func generateJSON([isUpdate])
    /// @desc Generates JSON data to be sent with the POST request.
    /// @arg {Bool} [isUpdate] Whether the payload is for an update (PATCH) request.
    /// @return {String} The JSON data.
    static generateJSON = function(_isUpdate = false) {
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
        if (_isUpdate) {
            // Merge the remaining files with deletion markers for removed files.
            // json_stringify serializes undefined as JSON null, which is the
            // deletion marker for the GitHub update API.
            var _filesPayload = {};
            var _fileNames = variable_struct_get_names(files);
            for (var i = 0; i < array_length(_fileNames); i++) {
                _filesPayload[$ _fileNames[i]] = files[$ _fileNames[i]];
            }
            var _removedNames = variable_struct_get_names(removedFiles);
            for (var i = 0; i < array_length(_removedNames); i++) {
                _filesPayload[$ _removedNames[i]] = undefined;
            }
            if (variable_struct_names_count(_filesPayload) > 0) {
                _struct[$ "files"] = _filesPayload;
            }
        } else {
            if (variable_struct_names_count(files) > 0) {
                _struct[$ "files"] = files;
            } else {
                __GitHubError("GitHubGist requires files to be able to be uploaded.");
            }
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
        // Re-adding a previously removed file restores it for update payloads
        if (variable_struct_exists(removedFiles, _filename)) {
            variable_struct_remove(removedFiles, _filename);
        }

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

        // Keep the file out of create payloads but mark it for deletion in update payloads
        removedFiles[$ _filename] = true;
    };
}
