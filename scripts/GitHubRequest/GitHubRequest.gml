// Feather disable all

/// @func GitHubRequest(requestID)
/// @desc Constructor for a GitHub specific request, when valid data is returned back, it will be parsed into the structure.
/// @arg {Real} requestID The ID for the request that has been sent.
function GitHubRequest(_requestID) constructor {
    // Variables
    requestID = _requestID;
    status = undefined;
    httpStatus = undefined;
    responseHeaders = undefined;
    contentLength = 0;
    sizeDownloaded = 0;
    result = "null";
    callback = undefined;
    errorback = undefined;

    // Push Request To Active Requests
    __GitHubSystem().__activeGitHubRequests[$ requestID] = self;

    // Methods
    /// @func parseResult(result)
    /// @desc Parses the incoming JSON data into the struct.
    /// @arg {String} result The incoming JSON data.
    static parseResult = function(_result) {
        result = json_parse(_result);
    };

    /// @func setCallback(method)
    /// @desc Sets a callback method that will be executed upon a successful request.
    /// @arg {Function} method The method to be executed, requires two arguments, the body struct and the request object [_resultBody, _requestObject].
    /// @returns {Any}
    static setCallback = function(_method) {
        callback = _method;
        return self;
    };

    /// @func setErrorback(method)
    /// @desc Sets an errorback method that will be executed upon a unsuccessful request.
    /// @arg {Function} method The method to be executed, requires two arguments, the body struct and the request object [_resultBody, _requestObject].
    /// @returns {Any}
    static setErrorback = function(_method) {
        errorback = _method;
        return self;
    };
}
