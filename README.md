[![Pub Package](https://img.shields.io/pub/v/pub_version_plus.svg)](https://pub.dartlang.org/packages/pub_version_plus)
[![Dart Version](https://img.shields.io/badge/dart-%5E2.13.0-green.svg?branch=master)](https://img.shields.io/badge/dart-%5E2.13.0-green.svg)
[![GitHub issues](https://img.shields.io/github/issues-raw/mrgnhnt96/pub_version_plus.svg)](https://github.com/mrgnhnt96/pub_version_plus/issues)

A command-line tool for easily incrementing pubspec.yaml version numbers.

## Installation

```console
$ pub global activate pubversion
# or
$ flutter pub global activate pubversion
```

Learn more about activating and using packages [here][pub global].

## Usage

`pubversion` provides three commands:

* `major`
* `minor`
* `patch`
* `build`

### `pubversion major`

```bash
$ pubversion major
test_package upgraded from 1.2.1 to 2.0.0

// with build number
test_package upgraded from 1.2.1+2 to 2.0.0+0
```

### `pubversion minor`

```bash
$ pubversion minor
test_package upgraded from 1.0.1 to 1.1.0

// with build number
test_package upgraded from 1.2.1+3 to 1.1.0+0
```

### `pubversion patch`

```bash
$ pubversion patch
test_package upgraded from 1.0.0 to 1.0.1

// with build number
test_package upgraded from 1.0.0+4 to 1.0.1+0
```

### `pubversion build`

```bash
$ pubversion build
test_package upgraded from 1.0.0+4 to 1.0.0+5
```

[activating]: https://www.dartlang.org/tools/pub/cmd/pub-global#activating-a-package
[pub global]: https://www.dartlang.org/tools/pub/cmd/pub-global
