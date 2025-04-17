import 'package:file/file.dart';
import 'package:meta/meta.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:pub_version_plus/src/util/exceptions.dart';
import 'package:pub_version_plus/src/util/modify_build.dart';
import 'package:pub_version_plus/src/util/pub_version.dart';
import 'package:pub_version_plus/src/util/version_conversion.dart';
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

  Future<void> initialize() async {
    _content = Pubspec.parse(await _file.readAsString());
  }

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

  /// Replaces the version in the pubspec.yaml file with [nextVersion]
  Future<VersionMessage> nextVersion(
    PubVersion nextVersion, {
    required ModifyBuild modifyBuild,
    bool modifyBuildIfNotPresent = false,
    String? preRelease,
  }) {
    return _updateVersion(VersionConversion(version: version).next(
      nextVersion,
      modifyBuild: modifyBuild,
      preRelease: preRelease,
      modifyBuildIfNotPresent: modifyBuildIfNotPresent,
    ));
  }

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
