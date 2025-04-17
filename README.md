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

- iOS: CFBundleShortVersionString (Version number)
- Android: versionName

#### Details

- Can be reused (with different Build Numbers)
- Must always be bigger than the previous version

---

### `"000"`

#### Name

- iOS: CFBundleVersion (Build number)
- Android: versionCode

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

### Use as a Package

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

---

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

> [!TIP]
> Installing `pub_version_plus` as a dev dependency will make it available to any CI/CD tool. (GitHub Actions, CodeMagic, etc.)
>
> Check out [`sip_cli`] to maintain project scripts.

## Pre-Releases

If you want to add a pre-release to your version number, you can do so by using the `--pre-release` flag.

```bash
pubversion major --pre-release beta
```

This will increment the version number `1.2.3` to `2.0.0-beta`

> [!NOTE]
> Changing from a pre-release to a release will **NOT** change the version number, it will only remove the pre-release.

## Build Number

The build number will automatically be incremented (if it exists) by one every time you run the `major`, `minor`, or `patch` commands.

You can also specify how the build number should be modified by using the `--build` flag.

```bash
pubversion major --build remove # Removes the build number
pubversion major --build reset # Resets the build number to 0
pubversion major --build increment # Increments the build number by 1 (default)
pubversion major --build none # Does not modify the build number
```

---

## Examples

### `major`

Increments the major version number - `X.0.0`

```bash
test_package upgraded from 1.2.1 to 2.0.0

test_package upgraded from 1.2.1+2 to 2.0.0+3
```

### `minor`

Increments the minor version number - `0.X.0`

```bash
test_package upgraded from 1.0.1 to 1.1.0

test_package upgraded from 1.0.1+3 to 1.1.0+4
```

### `patch`

Increments the patch version number - `0.0.X`

```bash
test_package upgraded from 1.0.0 to 1.0.1

test_package upgraded from 1.0.0+4 to 1.0.1+5
```

### `build`

Increments the build version number - `0.0.0+X`

```bash
test_package upgraded from 1.0.0+4 to 1.0.0+5
```

[`sip_cli`]: https://pub.dev/packages/sip_cli
