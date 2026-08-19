// Feather disable all

/// @func GitHubContent(commitMessage, content, [sha], [branch], [commiterName], [committerEmail], [committerDate], [authorName], [authorEmail], [authorDate])
/// @desc Constructor for creating GitHub Repository content files.
/// @arg {String} commitMessage The commit message.
/// @arg {Any} content The new file content.
/// @arg {String} [sha] Required if you are updating a file. The blob SHA of the file being replaced.
/// @arg {String} [branch] The branch name. Default: the repository's default branch.
/// @arg {String} [commiterName] The name of the author or committer of the commit. You'll receive a 422 status code if name is omitted.
/// @arg {String} [commiterEmail] The email of the author or committer of the commit. You'll receive a 422 status code if email is omitted.
/// @arg {String} [committerDate] the date of the commit.
/// @arg {String} [authorName] The name of the author or committer of the commit. You'll receive a 422 status code if name is omitted.
/// @arg {String} [authorEmail] The email of the author or committer of the commit. You'll receive a 422 status code if email is omitted.
/// @arg {String} [authorDate] The date of the author.
/// Documentation: https://docs.github.com/en/rest/repos/contents#create-or-update-file-contents
function GitHubContent(_commitMessage, _content, _sha = undefined, _branch = undefined, _committerName = undefined, _committerEmail = undefined, _committerDate = undefined, _authorName = undefined, _authorEmail = undefined, _authorDate = undefined) constructor {
    // Variables
    commitMessage = _commitMessage;
    content = _content;
    sha = _sha;
    branch = _branch;
    committerName = _committerName;
    committerEmail = _committerEmail;
    committerDate = _committerDate;
    authorName = _authorName;
    authorEmail = _authorEmail;
    authorDate = _authorDate;

    // Methods
    /// @func generateJSON()
    /// @desc Generates JSON data to be sent with the POST request.
    /// @return {String} The JSON data.
    static generateJSON = function() {
        // Create Struct
        var _struct = {};

        // Name and content
        _struct[$ "message"] = commitMessage;
        if (is_string(content)) {
            _struct[$ "content"] = base64_encode_advanced(content);
        } else {
            // Written bytes, not allocation - the allocation would encode trailing padding
            _struct[$ "content"] = buffer_base64_encode(content, 0, buffer_get_used_size(content));
        }

        // Optional params
        if (sha != undefined) {
            _struct[$ "sha"] = sha;
        }
        if (branch != undefined) {
            _struct[$ "branch"] = branch;
        }
        var _committer = __buildPersonPayload(committerName, committerEmail, committerDate);
        if (_committer != undefined) {
            _struct[$ "committer"] = _committer;
        }
        var _author = __buildPersonPayload(authorName, authorEmail, authorDate);
        if (_author != undefined) {
            _struct[$ "author"] = _author;
        }

        // Return JSON
        return json_stringify(_struct);
    };

    /// @func __buildPersonPayload(name, email, [date])
    /// @desc Builds the committer/author payload, or undefined when the required
    /// name/email pair is missing so the field is omitted from the JSON.
    /// @arg {String} name The person's name.
    /// @arg {String} email The person's email.
    /// @arg {String} [date] The commit date string.
    /// @return {Struct|Undefined}
    /// @ignore
    static __buildPersonPayload = function(_name, _email, _date = undefined) {
        if (_name == undefined || _email == undefined) {
            return undefined;
        }

        var _person = {
            name: _name,
            email: _email,
        };
        if (_date != undefined) {
            _person[$ "date"] = _date;
        }
        return _person;
    };
}
