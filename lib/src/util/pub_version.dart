import '../command/version_command.dart';
import '/src/command/build_command.dart';
import '/src/command/major_command.dart';
import '/src/command/minor_command.dart';
import '/src/command/patch_command.dart';

enum PubVersion {
  major,
  minor,
  patch,
  build,
}

extension PubVersionX on PubVersion {
  String get name {
    switch (this) {
      case PubVersion.major:
        return 'major';
      case PubVersion.minor:
        return 'minor';
      case PubVersion.patch:
        return 'patch';
      case PubVersion.build:
        return 'build';
    }
  }

  String get description {
    switch (this) {
      case PubVersion.major:
        return 'Increment the major version number. X.0.0';
      case PubVersion.minor:
        return 'Increment the minor version number. 0.X.0';
      case PubVersion.patch:
        return 'Increment the patch version number. 0.0.X';
      case PubVersion.build:
        return 'Increment the build number. 0.0.0+X';
    }
  }

  VersionCommand command(String path) {
    switch (this) {
      case PubVersion.major:
        return MajorCommand(path);
      case PubVersion.minor:
        return MinorCommand(path);
      case PubVersion.patch:
        return PatchCommand(path);
      case PubVersion.build:
        return BuildCommand(path);
    }
  }

  String get invocation {
    switch (this) {
      case PubVersion.major:
        return 'pubversion major';
      case PubVersion.minor:
        return 'pubversion minor';
      case PubVersion.patch:
        return 'pubversion patch';
      case PubVersion.build:
        return 'pubversion build';
    }
  }
}
