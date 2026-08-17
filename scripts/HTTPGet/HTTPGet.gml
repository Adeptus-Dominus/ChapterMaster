// Feather disable all

/// @func HTTPGet(requestURL)
/// @desc Constructor for creating a new HTTP get request.
/// @arg {String} requestURL The URL to send the request to.
function HTTPGet(_requestURL) : __HTTPParent() constructor {
    // Variables
    requestURL = _requestURL;
    contentLength = 0;
    sizeDownloaded = 0;

    // Send Request
    requestID = http_get(requestURL);

    // Push Request To Active Requests
    __GitHubSystem().__activeRequests[$ requestID] = self;
}
