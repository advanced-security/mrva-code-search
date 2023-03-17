# Code Search MRVA

Auto-create [MRVA (Multi-Repo Variant Analysis)](https://github.blog/2023-03-09-multi-repository-variant-analysis-a-powerful-new-way-to-perform-security-research-across-github/) repository lists.

This is a shell script that can be used with a `tasks.json` entry in VSCode to trigger a GitHub Code Search and populate the list in your open workspace.

## Usage

1. Clone this repository
2. Merge the `tasks.json` file into your VSCode User settings (e.g. "Tasks: Open User Tasks" in the command palette)
3. In your VSCode `settings.json` make your shell in the terminal a login shell (to pick up your `.bashrc` or `.zshrc` - for the `PATH`) with one of:
    - `"terminal.integrated.shellArgs.osx": ["-l"]`
    - `"terminal.integrated.shellArgs.linux": ["-l"]`
4. Add `mrva-repos.sh` to your path
5. Run the `Make MRVA repo list from a GitHub code search` task from the VSCode build tasks menu
6. Enter the name, query, and language of the search
7. The script will edit the `databases.json` in your workspace to add the new MRVA repo list, and automatically select it
8. Use MRVA with the new list!
