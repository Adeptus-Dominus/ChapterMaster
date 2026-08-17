// Function disable all

/// @func HTTPGetFile(requestURL, localTarget)
/// @desc Constructor for creating a new HTTP get file request (File Download).
/// @arg {String} requestURL The URL to send the request to.
/// @arg {String} localTarget The local filepath to download the file to.
function HTTPGetFile(_requestURL, _localTarget) : __HTTPParent() constructor {
    // Variables
    requestURL = _requestURL;
    localTarget = _localTarget;
    contentLength = 0;
    sizeDownloaded = 0;

    // Send Request
    requestID = http_get_file(requestURL, localTarget);

    // Push Request To Active Requests
    __GitHubSystem().__activeRequests[$ requestID] = self;
}
