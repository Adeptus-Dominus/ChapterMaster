// Feather disable all

/// @func HTTPRequest(requestURL, requestMethod, headerMap, requestBody)
/// @desc Constructor for creating a new HTTP request.
/// @arg {String} requestURL The URL to send the request to.
/// @arg {String} requestMethod The request method to use.
/// @arg {Id.DsMap} headerMap The header map to use.
/// @arg {String} requestBody The body of the request.
function HTTPRequest(_requestURL, _requestMethod, _headerMap, _requestBody) : __HTTPParent() constructor {
    // Variables
    requestURL = _requestURL;
    headerMap = _headerMap;
    requestBody = _requestBody;
    requestMethod = _requestMethod;
    contentLength = 0;
    sizeDownloaded = 0;

    // Request
    requestID = http_request(requestURL, requestMethod, headerMap, requestBody);

    // Push Request To Active Requests
    __GitHubSystem().__activeRequests[$ requestID] = self;
}
