import 'dart:io';

import 'package:meta/meta.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

import '/src/util/enum.dart';
import '/src/util/exceptions.dart';

class PubspecHandler {
  PubspecHandler(this.path)
      : _file = File(path),
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

  Version? _oldVerison;
  Version? get oldVersion => _oldVerison;

  String get _nextMajorVersion => '${version.nextMajor}${version.buildString}';
  String get _nextMinorVersion => '${version.nextMinor}${version.buildString}';
  String get _nextPatchVersion => '${version.nextPatch}${version.buildString}';
  String get _nextBuildVersion =>
      '${version.current}${version.nextBuildString}';

  String _nextVersionString(PubVersion v) {
    switch (v) {
      case PubVersion.major:
        return _nextMajorVersion;
      case PubVersion.minor:
        return _nextMinorVersion;
      case PubVersion.patch:
        return _nextPatchVersion;
      case PubVersion.build:
        return _nextBuildVersion;
    }
  }

  /// Replaces the version in the pubspec.yaml file with [nextVersion]
  Future<VersionMessage> nextVersion(PubVersion nextVersion) =>
      _updateVersion(_nextVersionString(nextVersion));

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
      _oldVerison = version;

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
    _oldVerison = null;
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

  String get buildString {
    if (buildNumber == null) return '';

    return '+$buildNumber';
  }

  int get nextBuild => buildNumber == null ? 1 : (buildNumber! + 1);

  String get nextBuildString => '+$nextBuild';

  String get current => '$major.$minor.$patch';
}
