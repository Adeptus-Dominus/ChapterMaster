// Feather disable all

/// @func GitHubRequest(requestID)
/// @desc Constructor for a GitHub specific request, when valid data is returned back, it will be parsed into the structure.
/// @arg {Real} requestID The ID for the request that has been sent.
function GitHubRequest(_requestID) : __HTTPParent() constructor {
    requestID = _requestID;
    contentLength = 0;
    sizeDownloaded = 0;

    // Push Request To Active Requests
    __GitHubSystem().__activeGitHubRequests[$ requestID] = self;
}
