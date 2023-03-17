#!/bin/bash

set -euo pipefail

workspace_storage_path_mac="$HOME/Library/Application Support/Code/User/workspaceStorage"

# make sure we have the right args, we need 4
if [ $# -ne 4 ]; then
    echo "Usage: $0 <name of repo list> <query> <language> <workspace>"
    exit 1
fi

# grab code search query and language from command line
name=$1
query=$2
language=$3
workspace_path=$4

# check the name, query, language and workspace_path variables are non-empty
if [ -z "$name" ] || [ -z "$query" ] || [ -z "$language" ] || [ -z "$workspace_path" ]; then
    echo "Usage: $0 <name of repo list> <query> <language> <workspace>"
    echo "All arguments must be non-empty"
    exit 1
fi

# check we have gh and jq installed
if ! command -v gh &> /dev/null; then
    echo "gh could not be found"
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo "jq could not be found"
    exit 1
fi

# check we are auth'd to GitHub in gh
if ! gh auth status -h github.com &> /dev/null; then
    echo "gh is not auth'd to GitHub.com"
    exit 1
fi

# url escape the query and language
query=$(echo "$query" | jq -sRr @uri)
language=$(echo "$language" | jq -sRr @uri)

# do the search on github
repo_json=$(set -euo pipefail; gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" "/search/code?q=${query}+language:${language}" | jq '[.items[].repository.full_name] | unique')

# find the first matching workspace in the vscode-codeql extension settings
workspace_storage_path=$(set -euo pipefail; find "${workspace_storage_path_mac}" -type f -name "workspace.json" -exec grep -l "${workspace_path}" {} \; | head -n 1)

# insert the list of repos into the GitHub.vscode-codeql/databases.json file in the workspace storage
# {
#   "version": 1,
#   "databases": {
#     "variantAnalysis": {
#       "repositoryLists": [
#         {
#           "name": "$name",
#           "repositories": [
#             ...
#           ]
#         }
#       ]
#     }
#   }
# }

if [ -n "$workspace_storage_path" ]; then
    # get the databases.json file path
    databases_json_path=$(dirname "$workspace_storage_path")/GitHub.vscode-codeql/databases.json

    echo $databases_json_path

    # if there is no file there, make it ourselves from scratch
    if [ ! -f "$databases_json_path" ]; then
        echo "Creating databases.json file"
        mkdir -p "$(dirname "$databases_json_path")"

        # use a HERE doc to write the template JSON to the file
        cat << EOF > "$databases_json_path"
{
    "version": 1,
    "databases": {
        "variantAnalysis": {
        "repositoryLists": [],
        "owners": [],
        "repositories": []
        }
    },
    "selected": {
        "kind": "variantAnalysisSystemDefinedList",
        "listName": "top_10"
    }
}
EOF
    fi

    # get the databases.json file contents
    databases_json=$(cat "$databases_json_path")

    # insert the list of repos into the databases.json file
    # if an entry with a matching name already exists in the JSON, add any new ones
    # otherwise, create a new entry
    # write out the whole JSON file with the new entry inserted
    if [ "$(set -euo pipefail; echo "$databases_json" | jq --arg name "$name" '.databases.variantAnalysis.repositoryLists[] | select(.name == $name)')" != "" ]; then
        json_query='(.databases.variantAnalysis.repositoryLists[] | select(.name == $name).repositories) |= (. + $repos | unique)'
    else
        json_query='.databases.variantAnalysis.repositoryLists += [{"name": $name, "repositories": $repos}]'
    fi

    databases_json=$(set -euo pipefail; echo "$databases_json" | jq --arg name "$name" --argjson repos "$repo_json" "$json_query")

    # set our MRVA list as the selected list
    databases_json=$(set -euo pipefail; echo "$databases_json" | jq --arg name "$name" '.selected = {"kind": "variantAnalysisUserDefinedList", "listName": $name}')

    # write the databases.json file
    echo "$databases_json" > "$databases_json_path"
fi
