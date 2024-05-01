import 'package:file/file.dart';
import 'package:pub_version_plus/src/command/build_command.dart';
import 'package:pub_version_plus/src/command/major_command.dart';
import 'package:pub_version_plus/src/command/minor_command.dart';
import 'package:pub_version_plus/src/command/patch_command.dart';
import 'package:pub_version_plus/src/command/version_command.dart';

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
        return 'Increments the version to the next major version number: X.0.0';
      case PubVersion.minor:
        return 'Increments the version to the next minor version number: 0.X.0';
      case PubVersion.patch:
        return 'Increments the version to the next patch version number: 0.0.X';
      case PubVersion.build:
        return 'Increments the version to the next build number: 0.0.0+X';
    }
  }

  VersionCommand command(String path, {required FileSystem fs}) {
    switch (this) {
      case PubVersion.major:
        return MajorCommand(path, fs: fs);
      case PubVersion.minor:
        return MinorCommand(path, fs: fs);
      case PubVersion.patch:
        return PatchCommand(path, fs: fs);
      case PubVersion.build:
        return BuildCommand(path, fs: fs);
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
