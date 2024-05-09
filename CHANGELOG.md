# 3.0.0

## Breaking Changes

- Instead of resetting the build number to 0 after every release, the build number will now be incremented by 1
  - This is to ensure that the build number is always increasing
  - If you want to reset the build number to 0, you can use the `--build` flag with the `reset` option

# Features

- Support modifying the build number via the `--build` flag
  - Options:
    - `reset` - Reset the build number to 0
    - `increment` - Increment the build number by 1, if it exists
    - `remove` - Remove the build number from the version
    - `none` - Do not modify the build number

# 2.0.0

# Enhancements

- Upgrade dependencies
- Improve testability of package

# Features

- Added `get` command to retrieve the current version within the `pubspec.yaml` file
- Added `set` command to set the version within the `pubspec.yaml` file
  - Use `--force` to bypass the check for an incremented version

# 1.1.0

- Upgraded dependencies to latest versions

## Fixes

- Build numbers are incremented correctly when running patch

# 1.0.2

- Updated ReadMe to
  - Better explain version number
  - Provide how to install as dev dependency

# 1.0.1

- Updated ReadMe

# 1.0.0

- Initial Release
