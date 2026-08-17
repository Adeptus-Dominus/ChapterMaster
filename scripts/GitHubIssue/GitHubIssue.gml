// Feather disable all

/// @func GitHubIssue(title, [body], [assignee], [milestone], [labels], [assignees], [type], [state], [stateReason])
/// @desc Constructor for creating a GitHub Issue.
/// @arg {String} title The title for the issue (required when creating a new issue).
/// @arg {String} [body] The body for the issue.
/// @arg {String} [assignee] Login for the user this issue should be assigned to.
/// @arg {Real} [milestone] Milestone number associated to this issue.
/// @arg {Array.String} [labels] A list of labels to use.
/// @arg {Array.String} [assignees] A list of users to assign this issue to.
/// @arg {String} [type] The name of the issue type to associate with this issue.
/// @arg {String} [state] The state of the issue, either "open" or "closed" (only use when updating an issue).
/// @arg {String} [stateReason] The state reason of the issue, either "completed", "not_planned", "duplicate", "repopened" or "null" (only use when updating an issue).
/// Documentation: https://docs.github.com/en/rest/issues/issues#create-an-issue
function GitHubIssue(_title = undefined, _body = undefined, _assignee = undefined, _milestone = undefined, _labels = undefined, _assignees = undefined, _type = undefined, _state = undefined, _stateReason = undefined) constructor {
    // Variables
    title = _title; // required
    body = _body;
    assignee = _assignee;
    milestone = _milestone;
    labels = _labels;
    assignees = _assignees;
    type = _type;
    state = _state;
    stateReason = _stateReason;

    // Methods
    /// @func generateJSON()
    /// @desc Generates JSON data to be sent with the POST request.
    /// @return {String} The JSON data.
    static generateJSON = function() {
        // Create Struct
        var _struct = {};

        // Append Values Into Structure
        // Title
        if (title != undefined) {
            _struct[$ "title"] = title;
        }

        // Body
        if (body != undefined) {
            _struct[$ "body"] = body;
        }

        // Assignee
        if (assignee != undefined) {
            _struct[$ "assignee"] = assignee;
        }

        // Milestone
        if (milestone != undefined) {
            _struct[$ "milestone"] = milestone;
        }

        // Labels
        if (labels != undefined) {
            _struct[$ "labels"] = labels;
        }

        // Assignees
        if (assignees != undefined) {
            _struct[$ "assignees"] = assignees;
        }

        // Type
        if (type != undefined) {
            _struct[$ "type"] = type;
        }

        // State
        if (state != undefined) {
            _struct[$ "state"] = state;
        }

        // State reason
        if (stateReason != undefined) {
            _struct[$ "state_reason"] = stateReason;
        }

        // Return JSON
        return json_stringify(_struct);
    };
}
