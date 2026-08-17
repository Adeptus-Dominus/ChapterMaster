// Feather disable all

/// @func GitHubContent(commitMessage, content, [sha], [branch], [commiterName], [committerEmail], [committerDate], [authorName], [authorEmail], [authorDate])
/// @desc Constructor for creating GitHub Repository content files.
/// @arg {String} commitMessage The commit message.
/// @arg {Any} content The new file content.
/// @arg {String} [sha] Required if you are updating a file. The blob SHA of the file being replaced.
/// @arg {String} [branch] The branch name. Default: the repository’s default branch.
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
        _struct[$ "content"] = is_string(content) ? base64_encode(content) : buffer_base64_encode(content, 0, buffer_get_size(content));

        // Optional params
        if (sha != undefined) {
            _struct[$ "sha"] = sha;
        }
        if (branch != undefined) {
            _struct[$ "branch"] = branch;
        }
        if (committerName != undefined && committerEmail != undefined) {
            _struct[$ "comitter"] = {
                name: committerName,
                email: committerEmail,
            };
            if (committerDate != undefined) {
                _struct[$ "comitter"][$ "date"] = committerDate;
            }
        }
        if (authorName != undefined && authorEmail != undefined) {
            _struct[$ "author"] = {
                name: authorName,
                email: authorEmail,
            };
            if (authorDate != undefined) {
                _struct[$ "author"][$ "date"] = authorDate;
            }
        }

        // Return JSON
        return json_stringify(_struct);
    };
}
