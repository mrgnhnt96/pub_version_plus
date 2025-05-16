import 'package:pub_semver/pub_semver.dart';
import 'package:pub_version_plus/src/util/modify_build.dart';
import 'package:pub_version_plus/src/util/pub_version.dart';

class VersionConversion {
  VersionConversion({
    required this.version,
  });

  VersionConversion.fromString(String version)
      : version = Version.parse(version);

  final Version version;

  int? get buildNumber => version.buildNumber;

  String next(
    PubVersion type, {
    required ModifyBuild? modifyBuild,
    required bool modifyBuildIfNotPresent,
    String? preRelease,
  }) {
    if (buildNumber == null &&
        !modifyBuildIfNotPresent &&
        modifyBuild != null) {
      return next(
        type,
        modifyBuild: null,
        modifyBuildIfNotPresent: false,
        preRelease: preRelease,
      );
    }

    return switch (type) {
      PubVersion.major => nextMajor(
          modifyBuild: modifyBuild,
          preRelease: preRelease,
        ),
      PubVersion.minor => nextMinor(
          modifyBuild: modifyBuild,
          preRelease: preRelease,
        ),
      PubVersion.patch => nextPatch(
          modifyBuild: modifyBuild,
          preRelease: preRelease,
        ),
      PubVersion.build => nextBuild(preRelease: preRelease),
    };
  }

  String nextMajor({
    required ModifyBuild? modifyBuild,
    String? preRelease,
  }) {
    return [
      switch (version.isPreRelease) {
        true => version.current,
        false => version.nextMajor,
      },
      if (preRelease != null) '-$preRelease',
      version.modifyBuild(modifyBuild),
    ].join();
  }

  String nextMinor({
    required ModifyBuild? modifyBuild,
    String? preRelease,
  }) {
    return [
      switch (version.isPreRelease) {
        true => version.current,
        false => version.nextMinor,
      },
      if (preRelease != null) '-$preRelease',
      version.modifyBuild(modifyBuild),
    ].join();
  }

  String nextPatch({
    required ModifyBuild? modifyBuild,
    String? preRelease,
  }) {
    return [
      switch (version.isPreRelease) {
        true => version.current,
        false => version.nextPatch,
      },
      if (preRelease != null) '-$preRelease',
      version.modifyBuild(modifyBuild),
    ].join();
  }

  String nextBuild({String? preRelease}) {
    return [
      version.current,
      if (preRelease != null) '-$preRelease' else version.preReleaseString,
      version.nextBuildString,
    ].join();
  }

  String get currentWithBuild {
    return [
      version.current,
      version.preReleaseString,
      switch (version.buildNumberString) {
        '' => '+0',
        final String build => build,
      },
    ].join();
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

  String get buildNumberString => switch (buildNumber) {
        null => '',
        final int build => '+$build',
      };

  int get nextBuild => switch (buildNumber) {
        null => 1,
        final int build => build + 1,
      };

  String get nextBuildString => '+$nextBuild';

  String get current => '$major.$minor.$patch';

  String get preReleaseString {
    if (isPreRelease) return '-${preRelease.join('-')}';
    return '';
  }

  String modifyBuild(ModifyBuild? modify) {
    if (buildNumber == null && modify == null) return '';

    return switch (modify) {
      ModifyBuild.increment => nextBuildString,
      ModifyBuild.reset => '+0',
      ModifyBuild.remove || null => '',
      ModifyBuild.none => buildNumberString,
    };
  }
}
