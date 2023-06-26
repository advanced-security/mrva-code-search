# Code Search MRVA

> 🔔 [MRVA in VSCode now has native Code Search](https://github.blog/changelog/2023-06-23-use-github-code-search-to-support-security-research-with-multi-repostiory-variant-analysis-for-codeql-beta/), as of June 23, 2023 🔔

> ℹ️ This is an _unofficial_ tool created by Field Security Services, and is not officially supported by GitHub.

Auto-create [Multi-Repo Variant Analysis (MRVA)](https://github.blog/2023-03-09-multi-repository-variant-analysis-a-powerful-new-way-to-perform-security-research-across-github/) repository lists.

This `mrva-code-search` script can be used with a [Task](https://code.visualstudio.com/docs/editor/tasks) in [VSCode](https://code.visualstudio.com/) to trigger a [GitHub Code Search](https://docs.github.com/en/rest/search?apiVersion=2022-11-28#search-code) and populate a repository list in your open workspace.

It relies on Bash, curl and jq, as well as (of course) VSCode and the CodeQL extension.

It should work anywhere you can run Bash, but it's only been tested on MacOS.

> ℹ️ This is an _unofficial_ tool created by Field Security Services, and is not officially supported by GitHub.

## Basic usage

Once you've followed the Install section below, then:

1. Run the `Make MRVA repo list from a GitHub code search` task from the VSCode build tasks menu
2. Enter the name, query, and language of the search at the prompts
   - the query should be the same as you would use in the legacy code search GitHub UI, e.g. `org:github fishsticks`
     - leave out the language, that has its own field
     - don't use regex, this doesn't work in the old code search
     - don't worry about quoting the query, it's done for you (with "strong" quoting)
   - the language should be the same as you would use in the GitHub UI, e.g. `javascript`
3. The script will edit the `databases.json` in your workspace to add/append to named MRVA repo lists using any matching results
    - it will create a new list if it doesn't exist, or append to existing lists
    - it creates 10 repo, 100 repo and "all" repo lists from the results
    - it automatically selects the 10 repository version as the active list
4. Use MRVA with the new lists!

At the command line you can do:

```bash
mrva-code-search "My fishsticks search" "org:github fishsticks" markdown /Users/username/my-workspace
```

If you workspace storage is in a non-standard location, you can specify it with a fifth argument.

## Common problems

- the current code search API doesn't support regex:
  - don't use regex in your query
- the code search doesn't return anything at all
  - don't put the `language:` qualifier in your query
  - check the [GitHub status page](https://www.githubstatus.com/) for outages
- the code search API doesn't return what the UI does
  - the ordering of the results is arbitrary, and you can't control it
  - re-run the same search a few times to try to populate more results
- the repositories found can't have CodeQL run against them: `The following repositories can't be analyzed because they don't currently have a CodeQL database available for the selected language.`
  - unfortunately, there isn't a workaround for this, other than patience

## Requirements

- Bash
- MacOS (or Linux, with a minor change to the shell script)
- the [`curl`](https://curl.se/) CLI tool
- a `GITHUB_TOKEN` in your environment
- [`jq`](https://stedolan.github.io/jq/), the JSON CLI tool
- [VSCode](https://code.visualstudio.com/), the IDE
- [VSCode CodeQL extension](https://marketplace.visualstudio.com/items?itemName=GitHub.vscode-codeql)

## Install

1. Clone this repository
2. Merge the `tasks.json` entries into your VSCode User settings (e.g. "Tasks: Open User Tasks" in the command palette)
    - on MacOS: `~/Library/Application Support/Code/User/tasks.json`
3. In your VSCode `settings.json` make your shell in the terminal a login shell (to pick up your `.bashrc` or `.zshrc` - for the `PATH`) with one of:
    - on MacOS: `"terminal.integrated.shellArgs.osx": ["-l"]`
    - on Linux: `"terminal.integrated.shellArgs.linux": ["-l"]`
    If you don't do this, `PATH` won't be set correctly and the script won't be found

    You can instead hardcode the full path of the script into the `tasks.json` file
4. Add the path of the `mrva-code-search` script to your `PATH`
5. Make sure your `GITHUB_TOKEN` is in your environment

## Known issues

- it uses the [old GitHub code search via the API](https://docs.github.com/en/rest/search?apiVersion=2022-11-28#search-code), so queries cannot use regex
- the GitHub API can return different results for the same query at different times. Try re-running the query to fill in more repos
- the GitHub code search API is limited to 1000 results at a time, so we can only get fewer than 1000 repos at a time
- may break without warning if the MRVA functionality in the CodeQL extension changes
- subject to the GitHub API rate limits (there is backoff built into this tool to account for this, so be patient)
- requires a login shell to pick up the `PATH` and `GITHUB_TOKEN` from your `.bashrc` or `.zshrc` (see above)
- untested on Windows (it uses Bash, so will work in the WSL, but not natively)
- the `tasks.json` must be manually edited in your VSCode User settings (see above)

## Notes

See the [LICENSE](LICENSE), [CHANGELOG](CHANGELOG.md), [CONTRIBUTING](CONTRIBUTING.md), [SECURITY](SECURITY.md), [SUPPORT](SUPPORT.md), [CODE OF CONDUCT](CODE_OF_CONDUCT.md) and [PRIVACY](PRIVACY.md) files for more information.
