import 'package:file/file.dart';
import 'package:meta/meta.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:pub_version_plus/src/util/exceptions.dart';
import 'package:pub_version_plus/src/util/pub_version.dart';
import 'package:pub_version_plus/src/util/version_message.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

class PubspecHandler {
  PubspecHandler(
    this.path, {
    required FileSystem fs,
  })  : _file = fs.file(path),
        assert(path.contains('.yaml')) {
    initialize();
  }

  Future<void> initialize() async => await Future(
        () async {
          _content = Pubspec.parse(await _file.readAsString());
        },
      );

  final String path;
  final File _file;

  Future<List<String>> _getLines() => _file.readAsLines();

  Pubspec? _content;
  Pubspec get pubspec {
    if (_content == null) throw HasNotInitiatedException();
    return _content!;
  }

  String? get name {
    try {
      return pubspec.name;
    } catch (e) {
      return null;
    }
  }

  Version get version {
    return pubspec.version ?? Version.parse('0.0.0');
  }

  Version? _oldVersion;
  Version? get oldVersion => _oldVersion;

  String nextMajorVersion({required ModifyBuild modifyBuild}) {
    return [
      '${version.nextMajor}',
      version.modifyBuild(modifyBuild),
    ].join();
  }

  String nextMinorVersion({required ModifyBuild modifyBuild}) {
    return [
      '${version.nextMinor}',
      version.modifyBuild(modifyBuild),
    ].join();
  }

  String nextPatchVersion({required ModifyBuild modifyBuild}) {
    return [
      '${version.nextPatch}',
      version.modifyBuild(modifyBuild),
    ].join();
  }

  String get nextBuildVersion {
    return '${version.current}${version.nextBuildString}';
  }

  String _nextVersionString(
    PubVersion v, {
    required ModifyBuild modifyBuild,
  }) {
    switch (v) {
      case PubVersion.major:
        return nextMajorVersion(modifyBuild: modifyBuild);
      case PubVersion.minor:
        return nextMinorVersion(modifyBuild: modifyBuild);
      case PubVersion.patch:
        return nextPatchVersion(modifyBuild: modifyBuild);
      case PubVersion.build:
        return nextBuildVersion;
    }
  }

  /// Replaces the version in the pubspec.yaml file with [nextVersion]
  Future<VersionMessage> nextVersion(
    PubVersion nextVersion, {
    required ModifyBuild modifyBuild,
  }) =>
      _updateVersion(_nextVersionString(nextVersion, modifyBuild: modifyBuild));

  Future<VersionMessage> setVersion(String version) => _updateVersion(version);

  Future<VersionMessage> _updateVersion(String v) async {
    final versionLine = 'version: $v';

    final lines = await _getLines();

    var versionLineIndex = lines.indexWhere((e) => e.startsWith('version:'));

    if (versionLineIndex == -1) {
      versionLineIndex = lines.indexWhere((e) => e.isEmpty);
      lines.insert(versionLineIndex, versionLine);
    } else {
      lines[versionLineIndex] = versionLine;
    }

    try {
      final output = lines.join('\n');

      // Update the file
      await _file.writeAsString(output, mode: FileMode.write);

      // Update old version for reference
      _oldVersion = version;

      // update content to reflect new version
      _content = Pubspec.parse(output);

      print('[${name ?? 'Updated'}] "$oldVersion" => "$version"');

      return VersionMessage.success;
    } catch (e) {
      print(e);
      return VersionMessage.couldNotUpdateVersion;
    }
  }

  @visibleForTesting
  Future<void> reset({bool hasBuild = false}) async {
    final version = hasBuild ? '0.0.0+0' : '0.0.0';
    await _updateVersion(version);
    _oldVersion = null;
  }

  @visibleForTesting
  Future<void> removeVersion() async {
    await reset();

    final lines = await _getLines();

    final versionLineIndex =
        lines.indexWhere((element) => element.startsWith('version:'));

    if (versionLineIndex == -1) return;
    lines.removeAt(versionLineIndex);

    final output = lines.join('\n');

    // Update the file
    await _file.writeAsString(output, mode: FileMode.write);
  }
}

extension on Version {
  int? get buildNumber {
    final nonNumeric = RegExp(r'[^0-9]');

    final build = this.build;

    // ignore: avoid_returning_null
    if (build.isEmpty) return null;

    final buildNumber = build.join('').replaceAll(nonNumeric, '');
    return int.parse(buildNumber);
  }

  String get buildNumberString => buildNumber == null ? '' : '+$buildNumber';

  int get nextBuild => buildNumber == null ? 1 : (buildNumber! + 1);

  String get nextBuildString => '+$nextBuild';

  String get current => '$major.$minor.$patch';

  String modifyBuild(ModifyBuild modify) {
    return switch (modify) {
      ModifyBuild.increment => nextBuildString,
      ModifyBuild.reset => '+0',
      ModifyBuild.remove => '',
      ModifyBuild.none => buildNumberString,
    };
  }
}

enum ModifyBuild {
  increment,
  reset,
  remove,
  none;

  bool get isIncrement => this == ModifyBuild.increment;
  bool get isReset => this == ModifyBuild.reset;
  bool get isRemove => this == ModifyBuild.remove;

  String get description {
    switch (this) {
      case ModifyBuild.increment:
        return 'Increment the build number, if it exists.';
      case ModifyBuild.reset:
        return 'Reset the build number to 0.';
      case ModifyBuild.remove:
        return 'Remove the build number.';
      case ModifyBuild.none:
        return 'Do nothing to the build number, if it exists.';
    }
  }
}
