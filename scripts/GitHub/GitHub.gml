// Feather disable all

/// @func GitHub([authToken])
/// @desc Constructor for creating a new instance of GitHub.
/// @arg {String} [authToken] The authorization token to be used for requests.
function GitHub(_authToken = undefined) constructor {
    // Create
    if (_authToken == undefined) {
        __GitHubTrace("No authentication token provided to GitHub.gml, you may encounter rate limits and certain API functions returning nothing");
    }
    __authToken = _authToken;

    // Just make sure the worker exists if this function is run right as the game starts
    __GitHubEnsureInstance();

    #region RELEASES

    #region Releases

    /// @func getLatestRelease(owner, repo)
    /// @desc Create a request for the latest release of a specific repository.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// Documentation: https://docs.github.com/en/rest/releases/releases#get-the-latest-release
    static getLatestRelease = function(_owner, _repo) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/releases/latest", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func getReleases(owner, repo, [perPage], [page])
    /// @desc Get a list of releases from a repository.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} [perPage] The number of results per page (max 100).
    /// @arg {Real} [page] The page number of the results to fetch.
    /// Documentation: https://docs.github.com/en/rest/releases/releases#list-releases
    static getReleases = function(_owner, _repo, _perPage = undefined, _page = undefined) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Optional Query Params
        var _queryParams = "?" + __buildPaginationQueryParams(_perPage, _page);

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/releases{_queryParams}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func getReleaseByTag(owner, repo, tagName)
    /// @desc Get a release by its tag name.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {String} tagName The tag name of the release.
    /// Documentation: https://docs.github.com/en/rest/releases/releases#get-a-release-by-tag-name
    static getReleaseByTag = function(_owner, _repo, _tagName) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/releases/tags/{_tagName}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func getRelease(owner, repo, releaseID)
    /// @desc Get a release by its releaseID.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} releaseID The ID of the release.
    /// Documentation: https://docs.github.com/en/rest/releases/releases#get-a-release
    static getRelease = function(_owner, _repo, _releaseID) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/releases/{_releaseID}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func createRelease(owner, repo, release)
    /// @desc Create a new release.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Struct.GitHubRelease} release The release struct.
    /// Documentation: https://docs.github.com/en/rest/releases/releases#create-a-release
    static createRelease = function(_owner, _repo, _release) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/releases", "POST", _header, _release.generateJSON());

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func updateRelease(owner, repo, releaseID, release)
    /// @desc Update an existing release.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} releaseID The ID of the release.
    /// @arg {Struct.GitHubRelease} release The release struct.
    /// Documentation: https://docs.github.com/en/rest/releases/releases#update-a-release
    static updateRelease = function(_owner, _repo, _releaseID, _release) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/releases/{_releaseID}", "PATCH", _header, _release.generateJSON());

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func deleteRelease(owner, repo, releaseID)
    /// @desc Delete an existing release.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} releaseID The ID of the release.
    /// Documentation: https://docs.github.com/en/rest/releases/releases#delete-a-release
    static deleteRelease = function(_owner, _repo, _releaseID) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/releases/{_releaseID}", "DELETE", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    #endregion

    #region Release Assets

    /// @func getReleaseAsset(owner, repo, assetID)
    /// @desc Get asset from a release.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} assetID The asset ID of the repo.
    /// Documentation: https://docs.github.com/en/rest/releases/assets#get-a-release-asset
    static getReleaseAsset = function(_owner, _repo, _assetID) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/releases/assets/{_assetID}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func getReleaseAssets(owner, repo, releaseID, [perPage], [page])
    /// @desc Get asset from a release.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} releaseID The release ID of the repo.
    /// @arg {Real} [perPage] The number of results per page (max 100).
    /// @arg {Real} [page] The page number of the results to fetch.
    /// Documentation: https://docs.github.com/en/rest/releases/assets#list-release-assets
    static getReleaseAssets = function(_owner, _repo, _releaseID, _perPage = undefined, _page = undefined) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Optional Query Params
        var _queryParams = "?" + __buildPaginationQueryParams(_perPage, _page);

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/releases/{_releaseID}/assets{_queryParams}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func uploadReleaseAsset(owner, repo, releaseID, buffer, contentType, targetFilename, [label])
    /// @desc Upload a release asset.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} releaseID The release ID of the repo.
    /// @arg {Id.Buffer} buffer The buffer to upload.
    /// @arg {String} contentType The content type of the release asset.
    /// @arg {String} targetFilename The target filename for the release asset.
    /// @arg {String} [label] The label for the release asset.
    /// Documentation: https://docs.github.com/en/rest/releases/assets#upload-a-release-asset
    static uploadReleaseAsset = function(_owner, _repo, _releaseID, _buffer, _contentType, _targetFilename, _label = "") {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Written bytes, not allocation - buffer_get_size would report unused capacity
        var _contentLength = buffer_get_used_size(_buffer);
        if (_contentLength <= 0) {
            __GitHubError("uploadReleaseAsset: The buffer has no written content to upload (buffer_get_used_size is 0).");
            return undefined;
        }

        ds_map_add(_header, "Content-Length", _contentLength);
        ds_map_add(_header, "Content-Type", _contentType);

        // http_request sends no body when the seek position is at 0 - seek to byte 1
        buffer_seek(_buffer, buffer_seek_start, 1);

        // Create Request
        var _request = new HTTPRequest($"https://uploads.github.com/repos/{_owner}/{_repo}/releases/{_releaseID}/assets?name={_targetFilename}&label={_label}", "POST", _header, _buffer);

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func updateReleaseAsset(owner, repo, assetID, filename, [label])
    /// @desc Update a release asset.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} assetID The asset ID of the release.
    /// @arg {String} filename The updated filename.
    /// @arg {String} [label] The updated label.
    /// Documentation: https://docs.github.com/en/rest/releases/assets#update-a-release-asset
    static updateReleaseAsset = function(_owner, _repo, _assetID, _filename, _label = "") {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/releases/assets/{_assetID}", "PATCH", _header, json_stringify({
            name: _filename,
            label: _label,
        }));

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func deleteReleaseAsset(owner, repo, assetID)
    /// @desc Delete an existing release asset.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} assetID The ID of the asset.
    /// Documentation: https://docs.github.com/en/rest/releases/assets#delete-a-release-asset
    static deleteReleaseAsset = function(_owner, _repo, _assetID) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/releases/assets/{_assetID}", "DELETE", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    #endregion

    #endregion

    #region ISSUES

    #region Assignees

    /// @func getAssignees(owner, repo, [perPage], [page])
    /// @desc Get assignees / contributors in a repository.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} [perPage] The number of results per page (max 100).
    /// @arg {Real} [page] The page number of the results to fetch.
    /// Documentation: https://docs.github.com/en/rest/issues/assignees#list-assignees
    static getAssignees = function(_owner, _repo, _perPage = undefined, _page = undefined) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Optional Query Params
        var _queryParams = "?" + __buildPaginationQueryParams(_perPage, _page);

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/assignees{_queryParams}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func userAssignable(owner, repo, assignee)
    /// @desc Get assignees / contributors in a repository.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {String} assignee The assignee name.
    /// Documentation: https://docs.github.com/en/rest/issues/assignees#check-if-a-user-can-be-assigned
    static userAssignable = function(_owner, _repo, _assignee) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/assignees/{_assignee}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func addAssigneesToIssue(owner, repo, issueID, assignees)
    /// @desc Add assignees / contributors in a repository to an issue.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} issueID	The issue ID / number.
    /// @arg {Array.String} assignees List of assignees.
    /// Documentation: https://docs.github.com/en/rest/issues/assignees#add-assignees-to-an-issue
    static addAssigneesToIssue = function(_owner, _repo, _issueID, _assignees) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Request body
        var _requestBody = "";
        if (!is_undefined(_assignees) && !is_array(_assignees)) {
            _assignees = [_assignees];
        }
        _requestBody = json_stringify({assignees: _assignees});

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/{_issueID}/assignees", "POST", _header, _requestBody);

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func removeAssigneesFromIssue(owner, repo, issueID, assignees)
    /// @desc Remove assignees / contributors in a repository from an issue.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} issueID	The issue ID / number.
    /// @arg {Array.String} assignees List of assignees.
    /// Documentation: https://docs.github.com/en/rest/issues/assignees#remove-assignees-from-an-issue
    static removeAssigneesFromIssue = function(_owner, _repo, _issueID, _assignees) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Request body
        var _requestBody = "";
        if (!is_undefined(_assignees) && !is_array(_assignees)) {
            _assignees = [_assignees];
        }
        _requestBody = json_stringify({assignees: _assignees});

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/{_issueID}/assignees", "DELETE", _header, _requestBody);

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func userAssignableToIssue(owner, repo, issueID, assignee)
    /// @desc Get assignees / contributors in a repository.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} issueID	The issue ID / number.
    /// @arg {String} assignee The assignee name.
    /// Documentation: https://docs.github.com/en/rest/issues/assignees#check-if-a-user-can-be-assigned-to-a-issue
    static userAssignableToIssue = function(_owner, _repo, _issueID, _assignee) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/{_issueID}/assignees/{_assignee}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    #endregion

    #region Issue Comments

    /// @func getRepoIssueComments(owner, repo, [sort], [direction], [since], [perPage], [page])
    /// @desc Get all issue comments in a repository.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {String} [sort] Sort by "created" or "updated".
    /// @arg {String} [direction] Direction to sort by, "asc" or "desc".
    /// @arg {String} [since] Only show results that were updated after the given time. (`YYYY-MM-DDTHH:MM:SSZ`).
    /// @arg {Real} [perPage] The number of results per page (max 100).
    /// @arg {Real} [page] The page number of the results to fetch.
    /// Documentation: https://docs.github.com/en/rest/issues/comments#list-issue-comments-for-a-repository
    static getRepoIssueComments = function(_owner, _repo, _sort = undefined, _direction = undefined, _since = undefined, _perPage = undefined, _page = undefined) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Optional Query Params
        var _queryParams = "?";
        if (_sort != undefined) {
            _queryParams += $"sort={_sort}&";
        }
        if (_direction != undefined) {
            _queryParams += $"direction={_direction}&";
        }
        if (_since != undefined) {
            _queryParams += $"since={_since}&";
        }
        if (_perPage != undefined || _page != undefined) {
            _queryParams += __buildPaginationQueryParams(_perPage, _page);
        }

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/comments{_queryParams}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func getIssueComment(owner, repo, commentID)
    /// @desc Get an issue comment in a repository.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} commentID The comment ID.
    /// Documentation: https://docs.github.com/en/rest/issues/comments#get-an-issue-comment
    static getIssueComment = function(_owner, _repo, _commentID) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/comments/{_commentID}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func updateIssueComment(owner, repo, commentID, body)
    /// @desc Update an issue comment in a repository.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} commentID The comment ID.
    /// @arg {String} body The body of the comment.
    /// Documentation: https://docs.github.com/en/rest/issues/comments#update-an-issue-comment
    static updateIssueComment = function(_owner, _repo, _commentID, _body) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/comments/{_commentID}", "PATCH", _header, json_stringify({body: _body}));

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func deleteIssueComment(owner, repo, commentID)
    /// @desc Delete an issue comment in a repository.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} commentID The comment ID.
    /// Documentation: https://docs.github.com/en/rest/issues/comments#delete-an-issue-comment
    static deleteIssueComment = function(_owner, _repo, _commentID) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/comments/{_commentID}", "DELETE", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func getIssueComments(owner, repo, issueID, [since], [perPage], [page])
    /// @desc Get an issues comments in a repository.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} issueID The repository name.
    /// @arg {String} [since] Only show results that were updated after the given time. (`YYYY-MM-DDTHH:MM:SSZ`).
    /// @arg {Real} [perPage] The number of results per page (max 100).
    /// @arg {Real} [page] The page number of the results to fetch.
    /// Documentation: https://docs.github.com/en/rest/issues/comments#list-issue-comments
    static getIssueComments = function(_owner, _repo, _issueID, _since = undefined, _perPage = undefined, _page = undefined) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Optional Query Params
        var _queryParams = "?";
        if (_since != undefined) {
            _queryParams += $"since={_since}&";
        }
        if (_perPage != undefined || _page != undefined) {
            _queryParams += __buildPaginationQueryParams(_perPage, _page);
        }

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/{_issueID}/comments{_queryParams}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func createIssueComment(owner, repo, issueID, body)
    /// @desc Create an issue comment in a repository.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} issueID The repository name.
    /// @arg {String} body The body of the issue comment.
    /// Documentation: https://docs.github.com/en/rest/issues/comments#create-an-issue-comment
    static createIssueComment = function(_owner, _repo, _issueID, _body) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/{_issueID}/comments", "POST", _header, json_stringify({body: _body}));

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    #endregion

    #region Issues

    /// @func getIssuesAssignedToMe([filter], [state], [labels], [sort], [direction], [since], [collab], [orgs], [owned], [pulls], [perPage], [page])
    /// @desc Get all the issues assigned to the authenticated user.
    /// @arg {String} [filter] Filter by "assigned", "created", "mentioned", "subscribed", "repos" or "all".
    /// @arg {String} [state] Issue state filter by "open", "closed" or "all".
    /// @arg {String} [labels] Issue labels separated by commas ("bug,ui,@high").
    /// @arg {String} [sort] Sort by "created" or "updated".
    /// @arg {String} [direction] Direction to sort by, "asc" or "desc".
    /// @arg {String} [since] Only show results that were updated after the given time. (`YYYY-MM-DDTHH:MM:SSZ`).
    /// @arg {Bool} [collab]
    /// @arg {Bool} [orgs]
    /// @arg {Bool} [owned]
    /// @arg {Bool} [pulls]
    /// @arg {Real} [perPage] The number of results per page (max 100).
    /// @arg {Real} [page] The page number of the results to fetch.
    /// Documentation: https://docs.github.com/en/rest/issues/issues#list-issues-assigned-to-the-authenticated-user
    static getIssuesAssignedToMe = function(_filter = undefined, _state = undefined, _labels = undefined, _sort = undefined, _direction = undefined, _since = undefined, _collab = undefined, _orgs = undefined, _owned = undefined, _pulls = undefined, _perPage = undefined, _page = undefined) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Optional Query Params
        var _queryParams = "?";
        if (_filter != undefined) {
            _queryParams += $"filter={_filter}&";
        }
        if (_state != undefined) {
            _queryParams += $"state={_state}&";
        }
        if (_labels != undefined) {
            _queryParams += $"labels={_labels}&";
        }
        if (_sort != undefined) {
            _queryParams += $"sort={_sort}&";
        }
        if (_direction != undefined) {
            _queryParams += $"direction={_direction}&";
        }
        if (_since != undefined) {
            _queryParams += $"since={_since}&";
        }
        if (_collab != undefined) {
            _queryParams += $"collab={_collab ? "true" : "false"}&";
        }
        if (_orgs != undefined) {
            _queryParams += $"orgs={_orgs ? "true" : "false"}&";
        }
        if (_owned != undefined) {
            _queryParams += $"owned={_owned ? "true" : "false"}&";
        }
        if (_pulls != undefined) {
            _queryParams += $"pulls={_pulls ? "true" : "false"}&";
        }
        if (_perPage != undefined || _page != undefined) {
            _queryParams += __buildPaginationQueryParams(_perPage, _page);
        }

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}issues{_queryParams}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func getOrgIssuesAssignedToMe(org, [filter], [state], [labels], [sort], [direction], [perPage], [page])
    /// @desc Get an organizations issues assigned to the authenticated user.
    /// @arg {String} org The organization.
    /// @arg {String} [filter] Filter by "assgined", "created", "mentioned", "subscribed", "repos" or "all".
    /// @arg {String} [state] Issue state filter by "open", "closed" or "all".
    /// @arg {String} [labels] Issue labels separated by commas ("bug,ui,@high").
    /// @arg {String} [sort] Sort by "created" or "updated".
    /// @arg {String} [direction] Direction to sort by, "asc" or "desc".
    /// @arg {String} [since] Only show results that were updated after the given time. (`YYYY-MM-DDTHH:MM:SSZ`).
    /// @arg {Real} [perPage] The number of results per page (max 100).
    /// @arg {Real} [page] The page number of the results to fetch.
    /// Documentation: https://docs.github.com/en/rest/issues/issues#list-organization-issues-assigned-to-the-authenticated-user
    static getOrgIssuesAssignedToMe = function(_org, _filter = undefined, _state = undefined, _labels = undefined, _sort = undefined, _direction = undefined, _since = undefined, _perPage = undefined, _page = undefined) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Optional Query Params
        var _queryParams = "?";
        if (_filter != undefined) {
            _queryParams += $"filter={_filter}&";
        }
        if (_state != undefined) {
            _queryParams += $"state={_state}&";
        }
        if (_labels != undefined) {
            _queryParams += $"labels={_labels}&";
        }
        if (_sort != undefined) {
            _queryParams += $"sort={_sort}&";
        }
        if (_direction != undefined) {
            _queryParams += $"direction={_direction}&";
        }
        if (_since != undefined) {
            _queryParams += $"since={_since}&";
        }
        if (_perPage != undefined || _page != undefined) {
            _queryParams += __buildPaginationQueryParams(_perPage, _page);
        }

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}orgs/{_org}/issues{_queryParams}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func getIssues(owner, repo, [milestone], [state], [assignee], [type], [creator], [mentioned], [labels], [sort], [direction], [since], [perPage], [page])
    /// @desc Get issues from a repository.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} [milestone] Pass an integer to refer to a specific milestone, pass "*" to refer to all milestones or pass "none" to omit issues without milestones.
    /// @arg {String} [state] Issue state filter by "open", "closed" or "all".
    /// @arg {String} [assignee] Filter by the user assigned.
    /// @arg {String} [type] Filter by the issue type.
    /// @arg {String} [creator] Filter by the user who created the issue.
    /// @arg {String} [mentioned] Filter by a user who was mentioned in the issue.
    /// @arg {String} [labels] Issue labels separated by commas ("bug,ui,@high").
    /// @arg {String} [sort] Sort by "created" or "updated".
    /// @arg {String} [direction] Direction to sort by, "asc" or "desc".
    /// @arg {String} [since] Only show results that were updated after the given time. (`YYYY-MM-DDTHH:MM:SSZ`).
    /// @arg {Real} [perPage] The number of results per page (max 100).
    /// @arg {Real} [page] The page number of the results to fetch.
    /// Documentation: https://docs.github.com/en/rest/issues/issues#list-repository-issues
    static getIssues = function(_owner, _repo, _milestone = undefined, _state = undefined, _assignee = undefined, _type = undefined, _creator = undefined, _mentioned = undefined, _labels = undefined, _sort = undefined, _direction = undefined, _since = undefined, _perPage = undefined, _page = undefined) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Optional Query Params
        var _queryParams = "?";
        if (_milestone != undefined) {
            _queryParams += $"milestone={_milestone}&";
        }
        if (_state != undefined) {
            _queryParams += $"state={_state}&";
        }
        if (_assignee != undefined) {
            _queryParams += $"assignee={_assignee}&";
        }
        if (_type != undefined) {
            _queryParams += $"type={_type}&";
        }
        if (_creator != undefined) {
            _queryParams += $"creator={_creator}&";
        }
        if (_mentioned != undefined) {
            _queryParams += $"mentioned={_mentioned}&";
        }
        if (_labels != undefined) {
            _queryParams += $"labels={_labels}&";
        }
        if (_sort != undefined) {
            _queryParams += $"sort={_sort}&";
        }
        if (_direction != undefined) {
            _queryParams += $"direction={_direction}&";
        }
        if (_since != undefined) {
            _queryParams += $"since={_since}&";
        }
        if (_perPage != undefined || _page != undefined) {
            _queryParams += __buildPaginationQueryParams(_perPage, _page);
        }

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues{_queryParams}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func createIssue(owner, repo, issue)
    /// @desc Create a new issue.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Struct.GitHubIssue} issue The issue struct.
    /// Documentation: https://docs.github.com/en/rest/issues/issues#create-an-issue
    static createIssue = function(_owner, _repo, _issue) {
        // GitHub rejects title-less payloads; the check lives at the create
        // boundary because GitHubIssue allows title omission for PATCH updates
        if (_issue.title == undefined || !is_string(_issue.title) || string_trim(_issue.title) == "") {
            __GitHubError("createIssue: The issue title is required and must not be empty.");
            return undefined;
        }

        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues", "POST", _header, _issue.generateJSON());

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func getIssue(owner, repo, issueID)
    /// @desc Get an issue by its issueID.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} issueID The ID of the issue.
    /// Documentation: https://docs.github.com/en/rest/issues/issues#get-an-issue
    static getIssue = function(_owner, _repo, _issueID) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/{_issueID}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func updateIssue(owner, repo, issueID, issue)
    /// @desc Update an existing issue.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} issueID The ID of the issue.
    /// @arg {Struct.GitHubIssue} issue The issue struct.
    /// Documentation: https://docs.github.com/en/rest/issues/issues#update-an-issue
    static updateIssue = function(_owner, _repo, _issueID, _issue) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/{_issueID}", "PATCH", _header, _issue.generateJSON());

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func lockIssue(owner, repo, issueID, lockReason)
    /// @desc Lock an existing issue.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} issueID The ID of the issue.
    /// @arg {String} lockReason The reason for locking, can be "off-topic", "too heated", "resolved" or "spam"
    /// Documentation: https://docs.github.com/en/rest/issues/issues#lock-an-issue
    static lockIssue = function(_owner, _repo, _issueID, _lockReason) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/{_issueID}/lock", "PUT", _header, json_stringify({lock_reason: _lockReason}));

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func unlockIssue(owner, repo, issueID)
    /// @desc Unlock a locked issue.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} issueID The ID of the issue.
    /// Documentation: https://docs.github.com/en/rest/issues/issues#unlock-an-issue
    static unlockIssue = function(_owner, _repo, _issueID) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/{_issueID}/lock", "DELETE", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    #endregion

    #region Issue Events

    /// @func getRepoIssueEvents(owner, repo, [perPage], [page])
    /// @desc Get a repositories issue events.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} [perPage] The number of results per page (max 100).
    /// @arg {Real} [page] The page number of the results to fetch.
    /// Documentation: https://docs.github.com/en/rest/issues/events#list-issue-events-for-a-repository
    static getRepoIssueEvents = function(_owner, _repo, _perPage = undefined, _page = undefined) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Optional Query Params
        var _queryParams = "?" + __buildPaginationQueryParams(_perPage, _page);

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/events{_queryParams}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func getIssueEvent(owner, repo, eventID)
    /// @desc Get a repository issue event.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} eventID The event ID.
    /// Documentation: https://docs.github.com/en/rest/issues/events#get-an-issue-event
    static getIssueEvent = function(_owner, _repo, _eventID) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/events/{_eventID}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func getIssueEvents(owner, repo, issueID, [perPage], [page])
    /// @desc Get an issues events.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} issueID The issue ID.
    /// @arg {Real} [perPage] The number of results per page (max 100).
    /// @arg {Real} [page] The page number of the results to fetch.
    /// Documentation: https://docs.github.com/en/rest/issues/events#list-issue-events
    static getIssueEvents = function(_owner, _repo, _issueID, _perPage = undefined, _page = undefined) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Optional Query Params
        var _queryParams = "?" + __buildPaginationQueryParams(_perPage, _page);

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/{_issueID}/events{_queryParams}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    #endregion

    #region Issue Labels

    /// @func getIssueLabels(owner, repo, issueID, [perPage], [page])
    /// @desc Get an issue's labels.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} issueID The issue ID.
    /// @arg {Real} [perPage] The number of results per page (max 100).
    /// @arg {Real} [page] The page number of the results to fetch.
    /// Documentation: https://docs.github.com/en/rest/issues/labels#list-labels-for-an-issue
    static getIssueLabels = function(_owner, _repo, _issueID, _perPage = undefined, _page = undefined) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Optional Query Params
        var _queryParams = "?" + __buildPaginationQueryParams(_perPage, _page);

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/{_issueID}/labels{_queryParams}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func addIssueLabels(owner, repo, issueID, labels)
    /// @desc Get an issue's labels.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} issueID The issue ID.
    /// @arg {Array.String} labels Array of labels to add to the issue.
    /// Documentation: https://docs.github.com/en/rest/issues/labels#add-labels-to-an-issue
    static addIssueLabels = function(_owner, _repo, _issueID, _labels) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/{_issueID}/labels", "POST", _header, json_stringify({labels: _labels}));

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func setIssueLabels(owner, repo, issueID, labels)
    /// @desc Set an issue's labels.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} issueID The issue ID.
    /// @arg {Array.String} labels Array of labels to set to the issue.
    /// Documentation: https://docs.github.com/en/rest/issues/labels#set-labels-for-an-issue
    static setIssueLabels = function(_owner, _repo, _issueID, _labels) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/{_issueID}/labels", "PUT", _header, json_stringify({labels: _labels}));

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func removeAllIssueLabels(owner, repo, issueID)
    /// @desc Set an issue's labels.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} issueID The issue ID.
    /// Documentation: https://docs.github.com/en/rest/issues/labels#remove-all-labels-from-an-issue
    static removeAllIssueLabels = function(_owner, _repo, _issueID) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/{_issueID}/labels", "DELETE", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func removeIssueLabel(owner, repo, issueID, labelName)
    /// @desc Set an issue's labels.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} issueID The issue ID.
    /// @arg {String} labelName The label name to remove.
    /// Documentation: https://docs.github.com/en/rest/issues/labels#remove-a-label-from-an-issue
    static removeIssueLabel = function(_owner, _repo, _issueID, _labelName) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/{_issueID}/labels/{_labelName}", "DELETE", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func getLabels(owner, repo, [perPage], [page])
    /// @desc Get a repository's labels.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} [perPage] The number of results per page (max 100).
    /// @arg {Real} [page] The page number of the results to fetch.
    /// Documentation: https://docs.github.com/en/rest/issues/labels#list-labels-for-a-repository
    static getLabels = function(_owner, _repo, _perPage = undefined, _page = undefined) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Optional Query Params
        var _queryParams = "?" + __buildPaginationQueryParams(_perPage, _page);

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/labels{_queryParams}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func createLabel(owner, repo, name, [color], [description])
    /// @desc Create a new label for a repository.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {String} name The name of the new label.
    /// @arg {Constant.Color} [color] The color of the new label.
    /// @arg {String} [description] The description of the new label.
    /// Documentation: https://docs.github.com/en/rest/issues/labels#create-a-label
    static createLabel = function(_owner, _repo, _name, _color = undefined, _description = undefined) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create body struct
        var _bodyStruct = {};
        _bodyStruct[$ "name"] = _name;

        // Color and description
        if (_color != undefined) {
            _bodyStruct[$ "color"] = __GMColorToHexString(_color);
        }
        if (_description != undefined) {
            _bodyStruct[$ "description"] = _description;
        }

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/labels", "POST", _header, json_stringify(_bodyStruct));

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func getLabel(owner, repo, labelName)
    /// @desc Get a repository label by name.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {String} labelName The label name to remove.
    /// Documentation: https://docs.github.com/en/rest/issues/labels#get-a-label
    static getLabel = function(_owner, _repo, _labelName) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/labels/{_labelName}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func updateLabel(owner, repo, name, [newName], [color], [description])
    /// @desc Update an existing label for a repository.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {String} name The name of the label.
    /// @arg {String} [newName] The new name of the label.
    /// @arg {Constant.Color} [color] The new color of the label.
    /// @arg {String} [description] The new description of the label.
    /// Documentation: https://docs.github.com/en/rest/issues/labels#update-a-label
    static updateLabel = function(_owner, _repo, _name, _newName = undefined, _color = undefined, _description = undefined) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create body struct
        var _bodyStruct = {};

        // Color and description
        if (_newName != undefined) {
            _bodyStruct[$ "new_name"] = _newName;
        }
        if (_color != undefined) {
            _bodyStruct[$ "color"] = __GMColorToHexString(_color);
        }
        if (_description != undefined) {
            _bodyStruct[$ "description"] = _description;
        }

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/labels/{_name}", "PATCH", _header, json_stringify(_bodyStruct));

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func deleteLabel(owner, repo, labelName)
    /// @desc Delete a repository label by name.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {String} labelName The label name to remove.
    /// Documentation: https://docs.github.com/en/rest/issues/labels#delete-a-label
    static deleteLabel = function(_owner, _repo, _labelName) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/labels/{_labelName}", "DELETE", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func getIssueMilestoneLabels(owner, repo, milestoneID, [perPage], [page])
    /// @desc Get an issues labels in a milestone.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} milestoneID The milestone number.
    /// @arg {Real} [perPage] The number of results per page (max 100).
    /// @arg {Real} [page] The page number of the results to fetch.
    /// Documentation: https://docs.github.com/en/rest/issues/labels#list-labels-for-issues-in-a-milestone
    static getIssueMilestoneLabels = function(_owner, _repo, _milestoneID, _perPage = undefined, _page = undefined) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Optional Query Params
        var _queryParams = "?" + __buildPaginationQueryParams(_perPage, _page);

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/milestones/{_milestoneID}/labels{_queryParams}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    #endregion

    #region Issue Milestones

    /// @func getMilestones(owner, repo, [state], [sort], [direction], [perPage], [page])
    /// @desc Get a repository's milestones.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {String} [state] Issue state filter by "open", "closed" or "all".
    /// @arg {String} [sort] Sort by "created" or "updated".
    /// @arg {String} [direction] Direction to sort by, "asc" or "desc".
    /// @arg {Real} [perPage] The number of results per page (max 100).
    /// @arg {Real} [page] The page number of the results to fetch.
    /// Documentation: https://docs.github.com/en/rest/issues/milestones#list-milestonese
    static getMilestones = function(_owner, _repo, _state = undefined, _sort = undefined, _direction = undefined, _perPage = undefined, _page = undefined) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Optional Query Params
        var _queryParams = "?";
        if (_state != undefined) {
            _queryParams += $"state={_state}&";
        }
        if (_sort != undefined) {
            _queryParams += $"sort={_sort}&";
        }
        if (_direction != undefined) {
            _queryParams += $"direction={_direction}&";
        }
        if (_perPage != undefined || _page != undefined) {
            _queryParams += __buildPaginationQueryParams(_perPage, _page);
        }

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/milestones{_queryParams}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func createMilestone(owner, repo, title, [state], [description], [dueOn])
    /// @desc Create a new milestone for a repository.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {String} title The title of the new milestone.
    /// @arg {String} [state] State of milestone "open" or "closed".
    /// @arg {String} [description] Description of the milestone.
    /// @arg {String} [dueOn] The due on time. (`YYYY-MM-DDTHH:MM:SSZ`).
    /// Documentation: https://docs.github.com/en/rest/issues/milestones#create-a-milestone
    static createMilestone = function(_owner, _repo, _title, _state = undefined, _description = undefined, _dueOn = undefined) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create body struct
        var _bodyStruct = {};
        _bodyStruct[$ "title"] = _title;

        // Other properties
        if (_state != undefined) {
            _bodyStruct[$ "state"] = _state;
        }
        if (_description != undefined) {
            _bodyStruct[$ "description"] = _description;
        }
        if (_dueOn != undefined) {
            _bodyStruct[$ "due_on"] = _dueOn;
        }

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/milestones", "POST", _header, json_stringify(_bodyStruct));

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func getMilestone(owner, repo, milestoneID)
    /// @desc Get a repository milestone.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} milestoneID The ID of the milestone.
    /// Documentation: https://docs.github.com/en/rest/issues/milestones#get-a-milestone
    static getMilestone = function(_owner, _repo, _milestoneID) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/milestones/{_milestoneID}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func updateMilestone(owner, repo, milestoneID, [title], [state], [description], [dueOn])
    /// @desc Create a new milestone for a repository.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} milestoneID The ID of the milestone.
    /// @arg {String} [title] The new title of the milestone.
    /// @arg {String} [state] State of milestone "open" or "closed".
    /// @arg {String} [description] Description of the milestone.
    /// @arg {String} [dueOn] The due on time. (`YYYY-MM-DDTHH:MM:SSZ`).
    /// Documentation: https://docs.github.com/en/rest/issues/milestones#update-a-milestone
    static updateMilestone = function(_owner, _repo, _milestoneID, _title = undefined, _state = undefined, _description = undefined, _dueOn = undefined) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create body struct
        var _bodyStruct = {};

        // Other properties
        if (_title != undefined) {
            _bodyStruct[$ "title"] = _title;
        }
        if (_state != undefined) {
            _bodyStruct[$ "state"] = _state;
        }
        if (_description != undefined) {
            _bodyStruct[$ "description"] = _description;
        }
        if (_dueOn != undefined) {
            _bodyStruct[$ "due_on"] = _dueOn;
        }

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/milestones/{_milestoneID}", "PATCH", _header, json_stringify(_bodyStruct));

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func deleteMilestone(owner, repo, milestoneID)
    /// @desc Delete a milestone from a repository.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} milestoneID The ID of the milestone.
    /// Documentation: https://docs.github.com/en/rest/issues/milestones#delete-a-milestone
    static deleteMilestone = function(_owner, _repo, _milestoneID) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/milestones/{_milestoneID}", "DELETE", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    #endregion

    #region Issue Sub-issues

    /// @func getIssueParent(owner, repo, issueID)
    /// @desc Get an issue's parent by its issueID.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} issueID The ID of the issue.
    /// Documentation: https://docs.github.com/en/rest/issues/sub-issues#get-parent-issue
    static getIssueParent = function(_owner, _repo, _issueID) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/{_issueID}/parent", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func removeSubIssue(owner, repo, issueID, subIssueID)
    /// @desc Remove a sub-issue from an issue.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} issueID The ID of the issue.
    /// @arg {Real} subIssueID The ID of the sub-issue.
    /// Documentation: https://docs.github.com/en/rest/issues/sub-issues#remove-sub-issue
    static removeSubIssue = function(_owner, _repo, _issueID, _subIssueID) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/{_issueID}/sub_issue", "DELETE", _header, json_stringify({sub_issue_id: _subIssueID}));

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func getSubIssues(owner, repo, issueID, [perPage], [page])
    /// @desc Get an issue's parent by its issueID.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} issueID The ID of the issue.
    /// @arg {Real} [perPage] The number of results per page (max 100).
    /// @arg {Real} [page] The page number of the results to fetch.
    /// Documentation: https://docs.github.com/en/rest/issues/sub-issues#list-sub-issues
    static getSubIssues = function(_owner, _repo, _issueID, _perPage = undefined, _page = undefined) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Optional Query Params
        var _queryParams = "?" + __buildPaginationQueryParams(_perPage, _page);

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/{_issueID}/sub_issues{_queryParams}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func addSubIssue(owner, repo, issueID, subIssueID, [replaceParent])
    /// @desc Remove a sub-issue from an issue.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} issueID The ID of the issue.
    /// @arg {Real} subIssueID The ID of the sub-issue.
    /// @arg {Bool} [replaceParent] Instructs the operation to replace the sub-issues current parent issue.
    /// Documentation: https://docs.github.com/en/rest/issues/sub-issues#add-sub-issue
    static addSubIssue = function(_owner, _repo, _issueID, _subIssueID, _replaceParent = undefined) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Body struct
        var _bodyStruct = {};

        // Params
        _bodyStruct[$ "sub_issue_id"] = _subIssueID;
        if (_replaceParent != undefined) {
            _bodyStruct[$ "replace_parent"] = _replaceParent;
        }

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/{_issueID}/sub_issues", "POST", _header, json_stringify(_bodyStruct));

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func reprioritizeSubIssue(owner, repo, issueID, subIssueID, [afterID], [beforeID])
    /// @desc Reprioritize a sub-issue.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} issueID The ID of the issue.
    /// @arg {Real} subIssueID The ID of the sub-issue.
    /// @arg {Bool} [afterID] The ID of the sub-issue to be prioritized after.
    /// @arg {Bool} [beforeID] The ID of the sub-issue to be prioritized before.
    /// Documentation: https://docs.github.com/en/rest/issues/sub-issues#reprioritize-sub-issue
    static reprioritizeSubIssue = function(_owner, _repo, _issueID, _subIssueID, _afterID = undefined, _beforeID = undefined) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Body struct
        var _bodyStruct = {};

        // Params
        _bodyStruct[$ "sub_issue_id"] = _subIssueID;
        if (_afterID != undefined) {
            _bodyStruct[$ "after_id"] = _afterID;
        }
        if (_beforeID != undefined) {
            _bodyStruct[$ "before_id"] = _beforeID;
        }

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/{_issueID}/sub_issues/priority", "PATCH", _header, json_stringify(_bodyStruct));

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    #endregion

    #region Issue Timeline

    /// @func getIssueTimelineEvents(owner, repo, issueID, [perPage], [page])
    /// @desc Get an issue's timeline events by its ID.
    /// @arg {String} owner The owner of the repo.
    /// @arg {String} repo The repository name.
    /// @arg {Real} issueID The ID of the issue.
    /// @arg {Real} [perPage] The number of results per page (max 100).
    /// @arg {Real} [page] The page number of the results to fetch.
    /// Documentation: https://docs.github.com/en/rest/issues/timeline#list-timeline-events-for-an-issue
    static getIssueTimelineEvents = function(_owner, _repo, _issueID, _perPage = undefined, _page = undefined) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Optional Query Params
        var _queryParams = "?" + __buildPaginationQueryParams(_perPage, _page);

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/{_issueID}/timeline{_queryParams}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    #endregion

    #endregion

    #region GISTS

    #region Gists

    /// @func getGistsCreatedByMe([since], [perPage], [page])
    /// @desc Get all the gists created by the authenticated user, if no authorization is provided it returns all public gists.
    /// @arg {String} [since] Only show results that were updated after the given time. (`YYYY-MM-DDTHH:MM:SSZ`).
    /// @arg {Real} [perPage] The number of results per page (max 100).
    /// @arg {Real} [page] The page number of the results to fetch.
    /// Documentation: https://docs.github.com/en/rest/gists/gists#list-gists-for-the-authenticated-user
    static getGistsCreatedByMe = function(_since = undefined, _perPage = undefined, _page = undefined) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Optional Query Params
        var _queryParams = "?";
        if (_since != undefined) {
            _queryParams += $"since={_since}&";
        }
        if (_perPage != undefined || _page != undefined) {
            _queryParams += __buildPaginationQueryParams(_perPage, _page);
        }

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}gists{_queryParams}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func createGist(gist)
    /// @desc Create a new gist to the currently authorized user.
    /// @arg {Struct.GitHubGist} gist The gist struct.
    /// Documentation: https://docs.github.com/en/rest/gists/gists#create-a-gist
    static createGist = function(_gist) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}gists", "POST", _header, _gist.generateJSON());

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func getPublicGists([since], [perPage], [page])
    /// @desc Get a list of public gists.
    /// @arg {String} [since] Only show results that were updated after the given time. (`YYYY-MM-DDTHH:MM:SSZ`).
    /// @arg {Real} [perPage] The number of results per page (max 100).
    /// @arg {Real} [page] The page number of the results to fetch.
    /// Documentation: https://docs.github.com/en/rest/gists/gists#list-public-gists
    static getPublicGists = function(_since = undefined, _perPage = undefined, _page = undefined) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Optional Query Params
        var _queryParams = "?";
        if (_since != undefined) {
            _queryParams += $"since={_since}&";
        }
        if (_perPage != undefined || _page != undefined) {
            _queryParams += __buildPaginationQueryParams(_perPage, _page);
        }

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}gists/public{_queryParams}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func getStarredGists([since], [perPage], [page])
    /// @desc Get a list of gists starred by the authenticated user.
    /// @arg {String} [since] Only show results that were updated after the given time. (`YYYY-MM-DDTHH:MM:SSZ`).
    /// @arg {Real} [perPage] The number of results per page (max 100).
    /// @arg {Real} [page] The page number of the results to fetch.
    /// Documentation: https://docs.github.com/en/rest/gists/gists#list-starred-gists
    static getStarredGists = function(_since = undefined, _perPage = undefined, _page = undefined) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Optional Query Params
        var _queryParams = "?";
        if (_since != undefined) {
            _queryParams += $"since={_since}&";
        }
        if (_perPage != undefined || _page != undefined) {
            _queryParams += __buildPaginationQueryParams(_perPage, _page);
        }

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}gists/starred{_queryParams}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func getGist(gistID)
    /// @desc Get a gist from a gist ID.
    /// @arg {String} gistID The ID of the gist.
    /// Documentation: https://docs.github.com/en/rest/gists/gists#get-a-gist
    static getGist = function(_gistID) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}gists/{_gistID}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func updateGist(gistID, gist)
    /// @desc Update a gist that's owned by the current authenticated user.
    /// @arg {String} gistID The ID of the gist.
    /// @arg {Struct.GitHubGist} gist The gist struct.
    /// Documentation: https://docs.github.com/en/rest/gists/gists#update-a-gist
    static updateGist = function(_gistID, _gist) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}gists/{_gistID}", "PATCH", _header, _gist.generateJSON(true));

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func deleteGist(gistID)
    /// @desc Delete a gist that's owned by the currently authenticated user.
    /// @arg {String} gistID The ID of the gist.
    /// Documentation: https://docs.github.com/en/rest/gists/gists#delete-a-gist
    static deleteGist = function(_gistID) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}gists/{_gistID}", "DELETE", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func getGistCommits(gistID, [perPage], [page])
    /// @desc Get a gists commits from a gist ID.
    /// @arg {String} gistID The ID of the gist.
    /// @arg {Real} [perPage] The number of results per page (max 100).
    /// @arg {Real} [page] The page number of the results to fetch.
    /// Documentation: https://docs.github.com/en/rest/gists/gists#list-gist-commits
    static getGistCommits = function(_gistID, _perPage = undefined, _page = undefined) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Optional Query Params
        var _queryParams = "?" + __buildPaginationQueryParams(_perPage, _page);

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}gists/{_gistID}/commits{_queryParams}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func getGistForks(gistID, [perPage], [page])
    /// @desc Get a gists forks from a gist ID.
    /// @arg {String} gistID The ID of the gist.
    /// @arg {Real} [perPage] The number of results per page (max 100).
    /// @arg {Real} [page] The page number of the results to fetch.
    /// Documentation: https://docs.github.com/en/rest/gists/gists#list-gist-forks
    static getGistForks = function(_gistID, _perPage = undefined, _page = undefined) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Optional Query Params
        var _queryParams = "?" + __buildPaginationQueryParams(_perPage, _page);

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}gists/{_gistID}/forks{_queryParams}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func forkGist(gistID)
    /// @desc Fork a gist from a gist ID.
    /// @arg {String} gistID The ID of the gist.
    /// Documentation: https://docs.github.com/en/rest/gists/gists#fork-a-gist
    static forkGist = function(_gistID) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}gists/{_gistID}/forks", "POST", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func isGistStarred(gistID)
    /// @desc Check if a gist is starred by the currently authenticated user.
    /// @arg {String} gistID The ID of the gist.
    /// Documentation: https://docs.github.com/en/rest/gists/gists#check-if-a-gist-is-starred
    static isGistStarred = function(_gistID) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}gists/{_gistID}/star", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func starGist(gistID)
    /// @desc Star a gist by the currently authenticated user.
    /// @arg {String} gistID The ID of the gist.
    /// Documentation: https://docs.github.com/en/rest/gists/gists#star-a-gist
    static starGist = function(_gistID) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}gists/{_gistID}/star", "POST", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func unstarGist(gistID)
    /// @desc Unstar a gist by the currently authenticated user.
    /// @arg {String} gistID The ID of the gist.
    /// Documentation: https://docs.github.com/en/rest/gists/gists#unstar-a-gist
    static unstarGist = function(_gistID) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}gists/{_gistID}/star", "DELETE", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func getGistRevision(gistID, sha)
    /// @desc Get a gist revision from the gist ID and sha
    /// @arg {String} gistID The ID of the gist.
    /// @arg {String} sha The sha of the gist.
    /// Documentation: https://docs.github.com/en/rest/gists/gists#get-a-gist-revision
    static getGistRevision = function(_gistID, _sha) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}gists/{_gistID}/{_sha}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func getUserGists(user, [since], [perPage], [page])
    /// @desc Get a list of gists by a given user.
    /// @arg {String} user The username of the user to search.
    /// @arg {String} [since] Only show results that were updated after the given time. (`YYYY-MM-DDTHH:MM:SSZ`).
    /// @arg {Real} [perPage] The number of results per page (max 100).
    /// @arg {Real} [page] The page number of the results to fetch.
    /// Documentation: https://docs.github.com/en/rest/gists/gists#list-gists-for-a-user
    static getUserGists = function(_user, _since = undefined, _perPage = undefined, _page = undefined) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Optional Query Params
        var _queryParams = "?";
        if (_since != undefined) {
            _queryParams += $"since={_since}&";
        }
        if (_perPage != undefined || _page != undefined) {
            _queryParams += __buildPaginationQueryParams(_perPage, _page);
        }

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}users/{_user}/gists{_queryParams}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    #endregion

    #region Gist Comments

    /// @func getGistComments(gistID, [perPage], [page])
    /// @desc Get a list of a gists comments.
    /// @arg {String} gistID The ID of the gist.
    /// @arg {Real} [perPage] The number of results per page (max 100).
    /// @arg {Real} [page] The page number of the results to fetch.
    /// Documentation: https://docs.github.com/en/rest/gists/comments#list-gist-comments
    static getGistComments = function(_gistID, _perPage = undefined, _page = undefined) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Optional Query Params
        var _queryParams = "?" + __buildPaginationQueryParams(_perPage, _page);

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}gists/{_gistID}/comments{_queryParams}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func createGistComment(gistID, body)
    /// @desc Create an issue comment in a repository.
    /// @arg {Real} gistID The ID of the gist.
    /// @arg {String} body The body of the gist comment.
    /// Documentation: https://docs.github.com/en/rest/gists/comments#create-a-gist-comment
    static createGistComment = function(_gistID, _body) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}gists/{_gistID}/comments", "POST", _header, json_stringify({body: _body}));

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func getGistComment(gistID, commentID)
    /// @desc Get a list of a gists comments.
    /// @arg {String} gistID The ID of the gist.
    /// @arg {Real} commentID The ID of the comment.
    /// Documentation: https://docs.github.com/en/rest/gists/comments#get-a-gist-comment
    static getGistComment = function(_gistID, _commentID) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}gists/{_gistID}/comments/{_commentID}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func updateGistComment(gistID, commentID, body)
    /// @desc Create an issue comment in a repository.
    /// @arg {Real} gistID The ID of the gist.
    /// @arg {Real} commentID The ID of the comment.
    /// @arg {String} body The body of the gist comment.
    /// Documentation: https://docs.github.com/en/rest/gists/comments#update-a-gist-comment
    static updateGistComment = function(_gistID, _commentID, _body) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}gists/{_gistID}/comments/{_commentID}", "PATCH", _header, json_stringify({body: _body}));

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func deleteGistComment(gistID, commentID)
    /// @desc Get a list of a gists comments.
    /// @arg {String} gistID The ID of the gist.
    /// @arg {Real} commentID The ID of the comment.
    /// Documentation: https://docs.github.com/en/rest/gists/comments#delete-a-gist-comment
    static deleteGistComment = function(_gistID, _commentID) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}gists/{_gistID}/comments/{_commentID}", "DELETE", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    #endregion

    #endregion

    #region USERS

    #region Attestations

    /// @func getAttestationsBySubjectDigests(username, subjectDigests, [predicateType], [perPage], [before], [after])
    /// @desc Get a list of attestations by bulk subject digests.
    /// @arg {String} username The handle for the GitHub user account.
    /// @arg {Array.String} subjectDigests List of subject digests to fetch attestations for.
    /// @arg {String} [predicateType] Filter for fetching attestations with a given predicate type. This option accepts "provenance", "sbom", "release", or "freeform" text for custom predicate types.
    /// @arg {Real} [perPage] The number of results per page (max 100).
    /// @arg {Real} [before] A cursor, as given in the Link header.
    /// @arg {Real} [after] A cursor, as given in the Link header.
    /// Documentation: https://docs.github.com/en/rest/users/attestations#list-attestations-by-bulk-subject-digests
    static getAttestationsBySubjectDigests = function(_username, _subjectDigests, _predicateType = undefined, _perPage = undefined, _before = undefined, _after = undefined) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Optional Query Params
        var _queryParams = "?" + __buildPaginationQueryParams(_perPage);
        if (_before != undefined) {
            _queryParams += $"before={_before}&";
        }
        if (_after != undefined) {
            _queryParams += $"after={_after}&";
        }

        // Build body
        var _bodyStruct = {};
        _bodyStruct[$ "subject_digests"] = _subjectDigests;
        if (_predicateType != undefined) {
            _bodyStruct[$ "predicate_type"] = _predicateType;
        }

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}users/{_username}/attestations{_queryParams}", "POST", _header, json_stringify(_bodyStruct));

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func deleteAttestationBySubjectDigest(username, subjectDigest)
    /// @desc Delete an artifact attestation by subject digest.
    /// @arg {String} username The handle for the GitHub user account.
    /// @arg {String} subjectDigest Subject digests to delete attestations for.
    /// Documentation: https://docs.github.com/en/rest/users/attestations#delete-attestations-by-subject-digest
    static deleteAttestationBySubjectDigest = function(_username, _subjectDigest) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}users/{_username}/attestations/digest/{_subjectDigest}", "DELETE", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func deleteAttestationByID(username, attestationID)
    /// @desc Delete an artifact attestation by subject digest.
    /// @arg {String} username The handle for the GitHub user account.
    /// @arg {Real} attestationID Attestation ID to delete attestations for.
    /// Documentation: https://docs.github.com/en/rest/users/attestations#delete-attestations-by-id
    static deleteAttestationByID = function(_username, _attestationID) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}users/{_username}/attestations/{_attestationID}", "DELETE", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func getAttestations(username, subjectDigest, [perPage], [before], [after], [predicateType])
    /// @desc List a collection of artifact attestations with a given subject digest that are associated with repositories owned by a user.
    /// @arg {String} username The handle for the GitHub user account.
    /// @arg {String} subjectDigest Subject digests to delete attestations for.
    /// @arg {Real} [perPage] The number of results per page (max 100).
    /// @arg {Real} [before] A cursor, as given in the Link header.
    /// @arg {Real} [after] A cursor, as given in the Link header.
    /// @arg {String} [predicateType] Filter for fetching attestations with a given predicate type. This option accepts "provenance", "sbom", "release", or "freeform" text for custom predicate types.
    /// Documentation: https://docs.github.com/en/rest/users/attestations#list-attestations
    static getAttestations = function(_username, _subjectDigest, _perPage = undefined, _before = undefined, _after = undefined, _predicateType = undefined) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Optional Query Params
        var _queryParams = "?" + __buildPaginationQueryParams(_perPage);
        if (_before != undefined) {
            _queryParams += $"before={_before}&";
        }
        if (_after != undefined) {
            _queryParams += $"after={_after}&";
        }
        if (_predicateType != undefined) {
            _queryParams += $"predicate_type={_predicateType}&";
        }

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}users/{_username}/attestations/{_subjectDigest}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    #endregion

    #region User

    /// @func getAuthenticatedUser()
    /// @desc Get the currently authenticated user.
    /// Documentation: https://docs.github.com/en/rest/users/users#get-the-authenticated-user
    static getAuthenticatedUser = function() {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}user", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func updateAuthenticatedUser([name], [email], [blog], [twitterUsername], [company], [location], [hireable], [bio])
    /// @desc Update the currently authenticated user.
    /// @arg {String} [user] The new name of the user.
    /// @arg {String} [email] The new email of the user.
    /// @arg {String} [blog] The new blog URL of the user.
    /// @arg {String} [twitterUsername] The new twitter (X) username of the user.
    /// @arg {String} [company] The new company of the user.
    /// @arg {String} [location] The new location of the user.
    /// @arg {Bool} [hireable] The new hiring availability of the user.
    /// @arg {String} [bio] The new bio of the user.
    /// Documentation: https://docs.github.com/en/rest/users/users#update-the-authenticated-user
    static updateAuthenticatedUser = function(_name = undefined, _email = undefined, _blog = undefined, _twitter = undefined, _company = undefined, _location = undefined, _hireable = undefined, _bio = undefined) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create body struct
        var _bodyStruct = {};

        // Color and description
        if (_name != undefined) {
            _bodyStruct[$ "name"] = _name;
        }
        if (_email != undefined) {
            _bodyStruct[$ "email"] = _email;
        }
        if (_blog != undefined) {
            _bodyStruct[$ "blog"] = _blog;
        }
        if (_twitter != undefined) {
            _bodyStruct[$ "twitter_username"] = _twitter;
        }
        if (_company != undefined) {
            _bodyStruct[$ "company"] = _company;
        }
        if (_location != undefined) {
            _bodyStruct[$ "location"] = _location;
        }
        if (_hireable != undefined) {
            _bodyStruct[$ "hireable"] = _hireable;
        }
        if (_bio != undefined) {
            _bodyStruct[$ "bio"] = _bio;
        }

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}user", "PATCH", _header, json_stringify(_bodyStruct));

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func getUserByID(accountID)
    /// @desc Get a user by their account ID.
    /// @arg {Real} accountID The users account ID.
    /// Documentation: https://docs.github.com/en/rest/users/users#get-a-user-using-their-id
    static getUserByID = function(_accountID) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}user/{_accountID}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func getUsers([since], [perPage])
    /// @desc Get a list of users.
    /// @arg {Real} [since] A user ID. Only return users with an ID greater than this ID.
    /// @arg {Real} [perPage] The number of results per page (max 100).
    /// Documentation: https://docs.github.com/en/rest/users/users#list-users
    static getUsers = function(_since = undefined, _perPage = undefined) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Optional Query Params
        var _queryParams = "?" + __buildPaginationQueryParams(_perPage);
        if (_since != undefined) {
            _queryParams += $"since={_since}&";
        }

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}users{_queryParams}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func getUser(username)
    /// @desc Get a user by their username.
    /// @arg {String} username The users username.
    /// Documentation: https://docs.github.com/en/rest/users/users#get-a-user
    static getUser = function(_username) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}users/{_username}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func getUserHovercard(username, [subjectType], [subjectID])
    /// @desc Get contextual information about a user.
    /// @arg {String} username The users username.
    /// @arg {String} [subjectType] Identifies which additional information you'd like to receive about the person's hovercard. Can be "organization", "repository", "issue", "pull_request". Required when using subjectID.
    /// @arg {String} [subjectID] Uses the ID for the subjectType you specified. Required when using subjectType.
    /// Documentation: https://docs.github.com/en/rest/users/users#get-contextual-information-for-a-user
    static getUserHovercard = function(_username, _subjectType = undefined, _subjectID = undefined) {
        // Create Default Headers
        var _header = __createDefaultHeaders();
        var _queryParams = "?";
        if (_subjectType != undefined && _subjectID != undefined) {
            _queryParams += $"subject_type={_subjectType}&subject_id={_subjectID}";
        }

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}users/{_username}/hovercard{_queryParams}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    #endregion

    #endregion

    #region Repository Contents

    /// @func getRepositoryContent(owner, repo, path, [ref])
    /// @desc Get a repository content.
    /// @arg {String} owner The account owner of the repository.
    /// @arg {String} repo The name of the repository without the .git extension.
    /// @arg {String} path Path parameter.
    /// @arg {String} [ref] The name of the commit/branch/tag. Default: the repository's default branch.
    /// Documentation: https://docs.github.com/en/rest/repos/contents#get-repository-content
    static getRepositoryContent = function(_owner, _repo, _path, _ref = undefined) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Optional Query Params
        var _queryParams = "?";
        if (_ref != undefined) {
            _queryParams += $"ref={_ref}&";
        }

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/contents/{_path}{_queryParams}", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func createRepositoryContent(owner, repo, path, content)
    /// @desc Create or update repository content.
    /// @arg {String} owner The account owner of the repository.
    /// @arg {String} repo The name of the repository without the .git extension.
    /// @arg {String} path Path parameter.
    /// @arg {Struct.GitHubContent} content The content struct to upload.
    /// Documentation: https://docs.github.com/en/rest/repos/contents#create-or-update-file-contents
    static createRepositoryContent = function(_owner, _repo, _path, _content) {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/contents/{_path}", "PUT", _header, _content.generateJSON());

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    static getRepositoriesOwnedByMe = function() {
        // Create Default Headers
        var _header = __createDefaultHeaders();

        // Create Request
        var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}user/repos", "GET", _header, "");

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    #endregion

    #region Other

    /// @func setAuthenticationToken(authToken)
    /// @desc Set an authentication token.
    /// @arg {String} authToken The authentication token you want to set.
    /// @returns {N/A}
    static setAuthenticationToken = function(_authToken) {
        __authToken = _authToken;
    };

    /// @func getRateLimitLimit()
    /// @desc Get the current rate limit for the authenticated user, returns undefined when no requests have been made.
    /// @returns {Real}
    static getRateLimitLimit = function() {
        return __GitHubSystem().__rateLimit;
    };

    /// @func getRateLimitUsed()
    /// @desc Get the current used rate limit for the authenticated user, returns undefined when no requests have been made.
    /// @returns {Real}
    static getRateLimitUsed = function() {
        return __GitHubSystem().__rateLimitUsed;
    };

    /// @func getRateLimitRemaining()
    /// @desc Get the current remaining rate limit for the authenticated user, returns undefined when no requests have been made.
    /// @returns {Real}
    static getRateLimitRemaining = function() {
        return __GitHubSystem().__rateLimitRemaining;
    };

    /// @func getRateLimitReset()
    /// @desc Get the current rate limit reset for the authenticated user, returns undefined when no requests have been made.
    /// @returns {Datetime}
    static getRateLimitReset = function() {
        return date_create_datetime(1970, 1, 1, 0, 0, __GitHubSystem().__rateLimitReset);
    };

    #endregion

    #region Helper

    /// @func __createDefaultHeaders()
    /// @desc Creates default header.
    /// @return {Struct}
    /// @ignore
    static __createDefaultHeaders = function() {
        // Create Header
        var _header = ds_map_create();

        // Build Header
        ds_map_add(_header, "Accept", "application/vnd.github+json");
        ds_map_add(_header, "X-GitHub-Api-Version", GITHUB_GML_API_VERSION);
        ds_map_add(_header, "User-Agent", GITHUB_GML_USER_AGENT);

        // Always default to the auth token given, otherwise we try to see if a user has authenticated.
        if (__authToken != undefined) {
            ds_map_add(_header, "Authorization", "Bearer " + __authToken);
        } else {
            var _system = __GitHubSystem();
            if (_system.__currentUserAuthToken != undefined) {
                ds_map_add(_header, "Authorization", "Bearer " + _system.__currentUserAuthToken);
            }
        }

        // Return Header
        return _header;
    };

    /// @func __buildPaginationQueryParams(perPage, [page])
    /// @desc Builds the shared per_page/page query string for paginated endpoints,
    /// clamping values so every endpoint enforces the same bounds. Callers prepend
    /// the leading "?" themselves.
    /// @arg {Real} perPage The number of results per page (max 100).
    /// @arg {Real} [page] The page number of the results to fetch.
    /// @return {String}
    /// @ignore
    static __buildPaginationQueryParams = function(_perPage = undefined, _page = undefined) {
        var _paginationParams = "";
        if (_perPage != undefined) {
            // GitHub accepts 1-100; a higher minimum would silently bump smaller requests
            _paginationParams += $"per_page={clamp(round(_perPage), 1, 100)}&";
        }
        if (_page != undefined) {
            _paginationParams += $"page={clamp(round(_page), 1, 100)}&";
        }
        return _paginationParams;
    };

    #endregion
}
