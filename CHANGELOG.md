# CHANGELOG

## 1.0.0 - 2023-03-29

* Added backoff to queries, to allow for rate limiting
* Splitting results into lists of 10, 100 and all of the found repositories
* Added Linux support (for the VSCode workspace storage default path)
* Added ability to override the VSCode workspace storage path

## 0.0.2 - 2023-03-29

Added paging to API query, limited to 2 pages only for now (to avoid triggering secondary rate limiting)

## 0.0.1 - 2023-03-17

First release
