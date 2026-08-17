// Feather disable all

/// @func GitHubRelease(tagName, [targetCommitish], [name], [body], [draft], [prerelease], [discussionCategoryName], [generateReleaseNotes], [makeLatest])
/// @desc Constructor for creating a GitHub Release.
/// @arg {String} tagName The tag name for the release.
/// @arg {String} [targetCommitish] Specifies the commitish value that determines where the Git tag is created from.
/// @arg {String} [name] The name of the release.
/// @arg {String} [body] The body of the release.
/// @arg {Bool} [draft] Whether the release is a draft or not.
/// @arg {Bool} [prerelease] Whether the release is a prerelease or not.
/// @arg {String} [discussionCategoryName] The discussion category name for the release.
/// @arg {Bool} [generateReleaseNotes] Whether to generate release notes based on the commit history for this release.
/// @arg {Bool} [makeLatest] Whether to make this the latest release or not.
/// Documentation: https://docs.github.com/en/rest/releases/releases#create-a-release
function GitHubRelease(_tagName, _targetCommitish = undefined, _name = undefined, _body = undefined, _draft = false, _prerelease = false, _discussionCategoryName = undefined, _generateReleaseNotes = false, _makeLatest = false) constructor {
    // Variables
    tagName = _tagName; // Required
    targetCommitish = _targetCommitish;
    name = _name;
    body = _body;
    draft = _draft;
    prerelease = _prerelease;
    discussionCategoryName = _discussionCategoryName;
    generateReleaseNotes = _generateReleaseNotes;
    makeLatest = _makeLatest;

    // Methods
    /// @func generateJSON()
    /// @desc Generates JSON data to be sent with the POST request.
    /// @return {String} The JSON data.
    static generateJSON = function() {
        // Create Struct
        var _struct = {};

        // Append Values Into Structure
        // Tag Name
        if (tagName != undefined) {
            _struct[$ "tag_name"] = tagName;
        } else {
            __GitHubError("GitHubRelease.tagName is required");
        }

        // Target Commitish
        if (targetCommitish != undefined) {
            _struct[$ "target_commitish"] = targetCommitish;
        }

        // Name
        if (name != undefined) {
            _struct[$ "name"] = name;
        }

        // Body
        if (body != undefined) {
            _struct[$ "body"] = body;
        }

        // Draft
        _struct[$ "draft"] = bool(draft);

        // Pre-Release
        _struct[$ "prerelease"] = bool(prerelease);

        // Discussion Category Name
        if (discussionCategoryName != undefined) {
            _struct[$ "discussion_category_name"] = discussionCategoryName;
        }

        // Generate Release Notes
        _struct[$ "generate_release_notes"] = bool(generateReleaseNotes);

        // Make Latest
        _struct[$ "make_latest"] = makeLatest ? "true" : "false";

        // Return JSON
        return json_stringify(_struct);
    };
}
