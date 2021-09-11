[![Pub Package](https://img.shields.io/pub/v/pub_version_plus.svg)](https://pub.dartlang.org/packages/pub_version_plus)
[![Dart Version](https://img.shields.io/badge/dart-%5E2.13.0-green.svg?branch=master)](https://img.shields.io/badge/dart-%5E2.13.0-green.svg)
[![GitHub issues](https://img.shields.io/github/issues-raw/mrgnhnt96/pub_version_plus.svg)](https://github.com/mrgnhnt96/pub_version_plus/issues)

A command-line tool for easily incrementing pubspec.yaml version numbers.

## About the Version Number

Within your pubspec.yaml file, you can increment the version number

```yaml
version: 0.0.0+000
```

### `"0.0.0"`

#### Name

```yaml
iOS: CFBundleShortVersionString (Version number)
Android: versionName
```

#### Details

- Can be reused (with different Build Numbers)
- Must always be bigger than the previous version

---

### `"000"`

#### Name

```yaml
iOS: CFBundleVersion (Build number)
Android: versionCode
```

#### Details

- Cannot be reused (with the same version number)
- Must always be bigger than the previous build number (within the same version number)
- Can be reset to 0 if the version number increments

More details about the version number can be found here: [android](https://developer.android.com/studio/publish/versioning#appversioning) | [apple](https://developer.apple.com/library/archive/technotes/tn2420/_index.html)
## Installation

`pub_version_plus` can be used globally or as a dev dependency to your `pubspec.yaml` file.

### Use globally

```bash
$ pub global activate pub_version_plus
#! or
$ flutter pub global activate pub_version_plus
```

### Use as a Library

```bash
#! dart
$ dart pub add --dev pub_version_plus

#! flutter
$ flutter pub add --dev pub_version_plus
```

Or add it to your `pubspec.yaml` file:

```yaml
dev_dependencies:
  pub_version_plus:
```

<br>

## Usage

`pub_version_plus` supports four commands:

- `major`
- `minor`
- `patch`
- `build`

Depending on how you `pub_version_plus` installed, you have a couple of different ways to use it:

```bash
#! installed globally
$ pubversion <version-type>

#! installed as a dev dependency
#! Flutter
$ flutter pub run pub_version_plus:main <version-type>

#! Dart
$ dart pub run pub_version_plus:main <version-type>
```

Installing `pub_version_plus` as a dev dependency will make it available to any CI/CD tool. (GitHub Actions, CodeMagic, etc.)

<br>

## Examples

### `major`

Increments the major version number - `X.0.0`

```bash
test_package upgraded from 1.2.1 to 2.0.0

#! with build number
test_package upgraded from 1.2.1+2 to 2.0.0+0
```

### `minor`

Increments the minor version number - `0.X.0`

```bash
test_package upgraded from 1.0.1 to 1.1.0

#! with build number
test_package upgraded from 1.0.1+3 to 1.1.0+0
```

### `patch`

Increments the patch version number - `0.0.X`

```bash
test_package upgraded from 1.0.0 to 1.0.1

#! with build number
test_package upgraded from 1.0.0+4 to 1.0.1+0
```

### `build`

Increments the build version number - `0.0.0+X`

```bash
test_package upgraded from 1.0.0+4 to 1.0.0+5
```

[activating]: https://www.dartlang.org/tools/pub/cmd/pub-global#activating-a-package
[pub global]: https://www.dartlang.org/tools/pub/cmd/pub-global
