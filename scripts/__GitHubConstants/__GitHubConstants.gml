// Feather disable all

#macro GITHUB_GML_VERSION "0.3.0"
#macro GITHUB_GML_DATE "2026-01-20"

#macro GITHUB_GML_RUNNING_FROM_IDE (GM_build_type == "run")
#macro GITHUB_GML_FOR_DESKTOP (os_type == os_windows or os_type == os_macosx or os_type == os_linux)

// URLs
#macro GITHUB_GML_ROOT_URL "https://api.github.com/"
#macro GITHUB_GML_ROOT_OAUTH_URL "https://github.com/login/"

// OAuth
#macro GITHUB_GML_OAUTH_GRANT_TYPE "urn:ietf:params:oauth:grant-type:device_code"
