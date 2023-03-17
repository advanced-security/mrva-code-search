# Code Search MRVA

Auto-create [MRVA (Multi-Repo Variant Analysis)](https://github.blog/2023-03-09-multi-repository-variant-analysis-a-powerful-new-way-to-perform-security-research-across-github/) repository lists.

This is a Bash shell script that can be used with a `tasks.json` entry in VSCode to trigger a GitHub Code Search and populate the list in your open workspace.

It's currently only tested on MacOS, but should work on Linux, if the path hardcoded in the script is changed.

## Requirements

- Bash
- MacOS (or Linux, with a minor change)
- `gh` command line tool
- a GitHub account, authenticated with `gh auth login`
- VSCode
- VSCode CodeQL extension

## Usage

1. Clone this repository
2. Merge the `tasks.json` file into your VSCode User settings (e.g. "Tasks: Open User Tasks" in the command palette)
3. In your VSCode `settings.json` make your shell in the terminal a login shell (to pick up your `.bashrc` or `.zshrc` - for the `PATH`) with one of:
    - `"terminal.integrated.shellArgs.osx": ["-l"]`
    - `"terminal.integrated.shellArgs.linux": ["-l"]`
4. Add `mrva-repos.sh` to your PATH
5. Run the `Make MRVA repo list from a GitHub code search` task from the VSCode build tasks menu
6. Enter the name, query, and language of the search at the prompts
7. The script will edit the `databases.json` in your workspace to add/append to the MRVA repo list for any matching results, and automatically select it
8. Use MRVA with the new list!

## Notes

See the [LICENSE](LICENSE), [CHANGELOG](CHANGELOG.md), [CONTRIBUTING](CONTRIBUTING.md), [SECURITY](SECURITY.md), [SUPPORT](SUPPORT.md), [CODE OF CONDUCT](CODE_OF_CONDUCT.md) and [PRIVACY](PRIVACY.md) files for more information.
