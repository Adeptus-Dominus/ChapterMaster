// Feather disable all

// The GitHub API has numerous versions to work with. GitHub.gml is designed to work with the latest version at the time of writing (2022-11-28).
#macro GITHUB_GML_API_VERSION "2022-11-28"

// The GitHub API requires a user agent to be set when making requests to the API endpoints.
#macro GITHUB_GML_USER_AGENT "GitHub.gml/v0.2.0"

// The maximum amount of times that GitHubOAuth can poll the authentication request before it times out.
#macro GITHUB_GML_OAUTH_MAX_POLLS 20

// The maximum amount of time in seconds that GitHubOAuth can poll the authentication request, the minimum should be whatever the OAuth request sends back.
#macro GITHUB_GML_OAUTH_MAX_POLL_INTERVAL 60

// Port to connect on as part of the `.requestAuthenticationViaWebPage()` flow. This must match the callback URL entered whe creating your GitHub app.
// e.g. Setting `GITHUB_GML_LOCALHOST_PORT` to `52499` means that you should use `http://localhost:52499/` for the callback URL.
#macro GITHUB_GML_LOCALHOST_PORT 52499

// How big a response buffer can be when sending a response back to the browser for webflow authentication. Change this to a higher buffer size if -for example-
// you want an entire web-page sent back in the response.
#macro GITHUB_GML_BROWSER_RESPONSE_BUFFER_SIZE 1024

// The time in seconds it takes to shutdown the web-server for web-flow authentication. This is here to allow enough time for the HTML to be served to the
// browser before the web-server is shut off. Default: 1 second.
#macro GITHUB_GML_SERVER_SHUTDOWN_TIME 1
