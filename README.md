# Code Search MRVA

> This is an _unofficial_ tool created by Field Security Services, and is not officially supported by GitHub.

Auto-create [Multi-Repo Variant Analysis (MRVA)](https://github.blog/2023-03-09-multi-repository-variant-analysis-a-powerful-new-way-to-perform-security-research-across-github/) repository lists.

This script can be used with a [Task](https://code.visualstudio.com/docs/editor/tasks) in [VSCode](https://code.visualstudio.com/) to trigger a [GitHub Code Search](https://docs.github.com/en/rest/search?apiVersion=2022-11-28#search-code) and populate a repository list in your open workspace.

It relies on the [GitHub CLI](https://cli.github.com/) command line tool, the [VSCode CodeQL extension](https://marketplace.visualstudio.com/items?itemName=GitHub.vscode-codeql) and [`jq`](https://stedolan.github.io/jq/).

It's currently only tested on MacOS, but should work on Linux, if the path hardcoded in the script is changed.

> This is an _unofficial_ tool created by Field Security Services, and is not officially supported by GitHub.

## Requirements

- Bash
- MacOS (or Linux, with a minor change to the shell script)
- the [GitHub CLI](https://cli.github.com/) command line tool
- a [GitHub account](https://github.com/), authenticated with `gh auth login`
- [`jq`](https://stedolan.github.io/jq/), the JSON CLI tool
- [VSCode](https://code.visualstudio.com/)
- [VSCode CodeQL extension](https://marketplace.visualstudio.com/items?itemName=GitHub.vscode-codeql)

## Usage

1. Clone this repository
2. Merge the `tasks.json` entries into your VSCode User settings (e.g. "Tasks: Open User Tasks" in the command palette)
3. In your VSCode `settings.json` make your shell in the terminal a login shell (to pick up your `.bashrc` or `.zshrc` - for the `PATH`) with one of:
    - `"terminal.integrated.shellArgs.osx": ["-l"]`
    - `"terminal.integrated.shellArgs.linux": ["-l"]`
    If you don't do this, `PATH` won't be set correctly and the script won't be found
4. Add `mrva-repos.sh` to your `PATH`
5. Run the `Make MRVA repo list from a GitHub code search` task from the VSCode build tasks menu
6. Enter the name, query, and language of the search at the prompts
7. The script will edit the `databases.json` in your workspace to add/append to the MRVA repo list for any matching results, and automatically select it
8. Use MRVA with the new list!

## Known issues

- it uses the [old GitHub code search via the API](https://docs.github.com/en/rest/search?apiVersion=2022-11-28#search-code), so queries cannot use regex
- the GitHub API can return different results for the same query at different times. Try re-running the query to fill in more repos
- the GitHub API uses paging. The `gh api` command doesn't support paging, as far as we know, so the script only gets the first 100 results
- may break without warning if the MRVA functionality in the CodeQL extension changes
- depends on the GitHub API and so is subject to the same rate limits as any other use of it
- requires a login shell to pick up the `PATH` from your `.bashrc` or `.zshrc` (see above)
- untested on Linux, but should work with a minor change to the shell script
- untested on Windows (it uses Bash, so will work in the WSL, but not natively)
- the `tasks.json` must be manually edited in your VSCode User settings (see above)

## Notes

See the [LICENSE](LICENSE), [CHANGELOG](CHANGELOG.md), [CONTRIBUTING](CONTRIBUTING.md), [SECURITY](SECURITY.md), [SUPPORT](SUPPORT.md), [CODE OF CONDUCT](CODE_OF_CONDUCT.md) and [PRIVACY](PRIVACY.md) files for more information.
