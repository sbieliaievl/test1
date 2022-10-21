# sre-template

This repository is a template that can be used to kickstart new repositories used by the SRE teams for infrastructure code.

## Setup

When creating a new repository from this template you need to also apply the following changes:

* you need to add the `build-talend-cloud` as an administrator of the repository
* you need to create a GitHub secret named `PUSH_TOKEN` with the value of a token issued by `build-talend-cloud` GitHub user. This is required for release automation.

## Tooling

### Commits

Commits are checked using the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0-beta.2/) convention.

This is meant to:

* increase readability of commit logs & PRs
* allow release management to create structured CHANGELOG & release notes

This check is enforced by the **commit_lint** GitHub action which is configured by `.commitlint.config.js`.

### Release management

SRE repositories are supposed to use Semantic Versioning & leverage GitHub releases to help people understanding the content of what is being deployed.

To achieve this we use [release-it](https://github.com/release-it/release-it): a Javascript tool meant to automate all actions related to release management in Git/GitHub.
The configuration provided in `.release-it.json` will make sure that:

* calling release-it will create a signed tag & a GitHub release from the local branch you have checked out
* the GitHub release will have release notes based on conventional commit parsing of commits since the last release
* CHANGELOG.md will be automatically updated

#### Automatic release

Releases are supposed to be created automatically from Pull Requests by using the **release** GitHub actions.

To do so you have to add a `bump:` label on your Pull Request before merging it.
Multiple labels are available for this purpose:

* `bump: auto` will let release-it decide of the semver increment. it will rely on conventional commit parsing to detect if the release have to be:
  * *major*: at least one breaking change
  * *minor*: at least one feature
  * *patch* only fixes or other commits
* `bump: major`, `bump: minor` and `bump: patch` labels enforce a specific semver increment

These labels are created, among others, by the **labels** GitHub actions.
So before creating a release you must have at least one valid commit pushed to master with the **labels** GitHub action properly executed.

#### Manual release

You can also create a release locally from you workstation as long as you have:

* installed release-it & the conventional commit plugin
* you have the GITHUB_TOKEN environment variable which has write access to the GitHub repository
