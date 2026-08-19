// Feather disable all

/// @func __HTTPParent()
/// @desc Parent constructor for HTTP stuff
/// @ignore
function __HTTPParent() constructor {
    // Variables
    requestID = undefined;
    status = undefined;
    result = "null";
    resultRaw = undefined;
    requestURL = undefined;
    httpStatus = undefined;
    headerMap = undefined;
    requestBody = undefined;
    requestMethod = undefined;
    responseHeaders = undefined;
    localTarget = undefined;
    contentLength = undefined;
    sizeDownloaded = undefined;

    // Callbacks
    callback = undefined;
    errorback = undefined;

    // Methods
    /// @func parseResult(result)
    /// @desc Parses the incoming JSON data into the struct.
    /// @arg {String} result The incoming JSON data.
    /// @returns {Bool} Whether the JSON was parsed successfully.
    static parseResult = function(_result) {
        try {
            result = json_parse(_result);
            resultRaw = undefined;
            return true;
        } catch (_exception) {
            show_debug_message($"__HTTPParent.parseResult: failed to parse JSON response: {_exception}");
            result = undefined;
            resultRaw = _result;
            return false;
        }
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
