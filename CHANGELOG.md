# Changelog

[![SemVer 2.0.0][📌semver-img]][📌semver] [![Keep-A-Changelog 1.0.0][📗keep-changelog-img]][📗keep-changelog]

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog][📗keep-changelog],
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html),
and [yes][📌major-versions-not-sacred], platform and engine support are part of the [public API][📌semver-breaking].
Please file a bug if you notice a violation of semantic versioning.

[📌semver]: https://semver.org/spec/v2.0.0.html
[📌semver-img]: https://img.shields.io/badge/semver-2.0.0-FFDD67.svg?style=flat
[📌semver-breaking]: https://github.com/semver/semver/issues/716#issuecomment-869336139
[📌major-versions-not-sacred]: https://tom.preston-werner.com/2022/05/23/major-version-numbers-are-not-sacred.html
[📗keep-changelog]: https://keepachangelog.com/en/1.0.0/
[📗keep-changelog-img]: https://img.shields.io/badge/keep--a--changelog-1.0.0-FFDD67.svg?style=flat

## [Unreleased]

### Added

- Added support for JRuby 10.1 and TruffleRuby 34.0.

### Changed

- Retemplated generated project metadata, support documentation, CI workflows,
  binstubs, and development dependency floors with `kettle-jem` v7.0.0.

### Deprecated

### Removed

### Fixed

- Package configured license files in gem release file lists.

### Security

## 2.0.3 - 2024-09-25
- COVERAGE:  97.72% -- 214/219 lines in 4 files
- BRANCH COVERAGE:  86.00% -- 43/50 branches in 4 files
- 39.13% documented
### Added
- Improved Documentation
### Fixed
- Documentation typos
- Documentation in Yard (on RubyDoc.info)

## 2.0.2 - 2024-09-25
- COVERAGE:  97.72% -- 214/219 lines in 4 files
- BRANCH COVERAGE:  86.00% -- 43/50 branches in 4 files
- 39.13% documented
### Added
- Improved integration with direnv for development
- Better test coverage
- More tests
- rots v1.0.0 for tests
### Changed
- Upgraded to ruby-openid2 v3.1.0
- Moved to oauth-xx organization

## 2.0.1 - 2024-09-05
### Added
- CHANGELOG.md
- CODE_OF_CONDUCT.md
- CONTRIBUTING.md
- SECURITY.md
### Fixed
- Typo in gemspec description

## 2.0.0 - 2024-09-04
- COVERAGE:  97.72% -- 214/219 lines in 3 files
- BRANCH COVERAGE:  86.00% -- 43/50 branches in 3 branches
### Changed
- Upgraded to rack v2+
- Switched ruby-openid => ruby-openid2
### Fixed
- Compatibility with Ruby 2.7+
### Removed
- Support for Ruby < 2.7
