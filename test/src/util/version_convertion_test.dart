import 'package:pub_version_plus/src/util/modify_build.dart';
import 'package:pub_version_plus/src/util/pub_version.dart';
import 'package:pub_version_plus/src/util/version_conversion.dart';
import 'package:test/test.dart';

void main() {
  group(VersionConversion, () {
    void verifyBuildModes(String Function(ModifyBuild?) version) {
      final buildModes = [
        ...ModifyBuild.values,
        null,
      ];

      for (final mode in buildModes) {
        switch (mode) {
          case ModifyBuild.increment:
            final parts = version(mode).split('+');
            expect(parts, hasLength(2));
            expect(parts.last, isNotEmpty);
            expect(parts.last, '1');
          case ModifyBuild.reset:
            final parts = version(mode).split('+');
            expect(parts, hasLength(2));
            expect(parts.last, isNotEmpty);
            expect(parts.last, '0');
          case ModifyBuild.none:
          case ModifyBuild.remove:
          default:
            final parts = version(mode).split('+');
            expect(parts, hasLength(1));
        }
      }
    }

    group('#next', () {
      test('should increment build number if not present', () {
        final version = VersionConversion.fromString('1.2.3');
        final next = version.next(
          PubVersion.patch,
          modifyBuild: ModifyBuild.increment,
          modifyBuildIfNotPresent: true,
        );

        expect(next, '1.2.4+1');
      });

      test('should not increment build number if not present and mode is none',
          () {
        final version = VersionConversion.fromString('1.2.3');
        final next = version.next(
          PubVersion.patch,
          modifyBuild: ModifyBuild.none,
          modifyBuildIfNotPresent: true,
        );

        expect(next, '1.2.4');
      });

      test('should not increment build number if not present', () {
        final version = VersionConversion.fromString('1.2.3');
        final next = version.next(
          PubVersion.patch,
          modifyBuild: ModifyBuild.increment,
          modifyBuildIfNotPresent: false,
        );

        expect(next, '1.2.4');
      });

      test('should reset build number if not present', () {
        final version = VersionConversion.fromString('1.2.3');
        final next = version.next(
          PubVersion.patch,
          modifyBuild: ModifyBuild.reset,
          modifyBuildIfNotPresent: true,
        );

        expect(next, '1.2.4+0');
      });
    });

    group('#nextMajor', () {
      test('should update to the correct version', () async {
        const versions = {
          '0.0.0': '1.0.0',
          '0.0.1': '1.0.0',
          '0.1.0': '1.0.0',
          '0.1.1': '1.0.0',
          '1.0.0': '2.0.0',
          '1.0.1': '2.0.0',
          '1.1.0': '2.0.0',
          '1.1.1': '2.0.0',
          '1.2.3': '2.0.0',
          '1.2.3+4': '2.0.0+4',
          '1.2.3-beta': '1.2.3',
          '1.2.3-prerelease+5': '1.2.3+5',
        };

        for (final MapEntry(:key, :value) in versions.entries) {
          final version = VersionConversion.fromString(key);

          expect(version.nextMajor(modifyBuild: ModifyBuild.none), value);
        }
      });

      test('inserts pre-release', () {
        final version = VersionConversion.fromString('1.2.3');

        expect(
          version.nextMajor(
            modifyBuild: ModifyBuild.none,
            preRelease: 'beta',
          ),
          '2.0.0-beta',
        );
      });

      group('modify build number', () {
        test('should increment', () async {
          final version = VersionConversion.fromString('1.2.3+4');

          expect(
            version.nextMajor(modifyBuild: ModifyBuild.increment),
            '2.0.0+5',
          );
        });

        test('should do nothing when build number is not present', () async {
          final version = VersionConversion.fromString('1.2.3');

          verifyBuildModes((mode) => version.nextMajor(modifyBuild: mode));
        });

        test('should remove', () async {
          final version = VersionConversion.fromString('1.2.3+4');

          expect(
            version.nextMajor(modifyBuild: ModifyBuild.remove),
            '2.0.0',
          );
        });

        test('should reset', () {
          final version = VersionConversion.fromString('1.2.3+4');

          expect(
            version.nextMajor(modifyBuild: ModifyBuild.reset),
            '2.0.0+0',
          );
        });
      });
    });

    group('#nextMinor', () {
      test('should update to the correct version', () async {
        const versions = {
          '0.0.0': '0.1.0',
          '0.0.1': '0.1.0',
          '0.1.0': '0.2.0',
          '0.1.1': '0.2.0',
          '1.0.0': '1.1.0',
          '1.0.1': '1.1.0',
          '1.1.0': '1.2.0',
          '1.1.1': '1.2.0',
          '1.2.3': '1.3.0',
          '1.2.3+4': '1.3.0+4',
          '1.2.3-beta': '1.2.3',
          '1.2.3-prerelease+5': '1.2.3+5',
        };

        for (final MapEntry(:key, :value) in versions.entries) {
          final version = VersionConversion.fromString(key);
          expect(version.nextMinor(modifyBuild: ModifyBuild.none), value);
        }
      });

      test('inserts pre-release', () {
        final version = VersionConversion.fromString('1.2.3');

        expect(
          version.nextMinor(modifyBuild: ModifyBuild.none, preRelease: 'beta'),
          '1.3.0-beta',
        );
      });

      group('modify build number', () {
        test('should increment', () async {
          final version = VersionConversion.fromString('1.2.3+4');

          expect(
            version.nextMinor(modifyBuild: ModifyBuild.increment),
            '1.3.0+5',
          );
        });

        test('should do nothing when build number is not present', () async {
          final version = VersionConversion.fromString('1.2.3');

          verifyBuildModes((mode) => version.nextMinor(modifyBuild: mode));
        });

        test('should remove', () async {
          final version = VersionConversion.fromString('1.2.3+4');

          expect(
            version.nextMinor(modifyBuild: ModifyBuild.remove),
            '1.3.0',
          );
        });

        test('should reset', () {
          final version = VersionConversion.fromString('1.2.3+4');

          expect(
            version.nextMinor(modifyBuild: ModifyBuild.reset),
            '1.3.0+0',
          );
        });
      });
    });

    group('#nextPatch', () {
      test('should update to the correct version', () async {
        const versions = {
          '0.0.0': '0.0.1',
          '0.0.1': '0.0.2',
          '0.1.0': '0.1.1',
          '0.1.1': '0.1.2',
          '1.0.0': '1.0.1',
          '1.0.1': '1.0.2',
          '1.1.0': '1.1.1',
          '1.1.1': '1.1.2',
          '1.2.3': '1.2.4',
          '1.2.3+4': '1.2.4+4',
          '1.2.3-beta': '1.2.3',
          '1.2.3-prerelease+5': '1.2.3+5',
        };

        for (final MapEntry(:key, :value) in versions.entries) {
          final version = VersionConversion.fromString(key);
          expect(version.nextPatch(modifyBuild: ModifyBuild.none), value);
        }
      });

      test('inserts pre-release', () {
        final version = VersionConversion.fromString('1.2.3');

        expect(
          version.nextPatch(modifyBuild: ModifyBuild.none, preRelease: 'beta'),
          '1.2.4-beta',
        );
      });

      group('modify build number', () {
        test('should increment', () async {
          final version = VersionConversion.fromString('1.2.3+4');

          expect(
            version.nextPatch(modifyBuild: ModifyBuild.increment),
            '1.2.4+5',
          );
        });

        test('should do nothing when build number is not present', () async {
          final version = VersionConversion.fromString('1.2.3');

          verifyBuildModes((mode) => version.nextPatch(modifyBuild: mode));
        });

        test('should remove', () async {
          final version = VersionConversion.fromString('1.2.3+4');

          expect(
            version.nextPatch(modifyBuild: ModifyBuild.remove),
            '1.2.4',
          );
        });

        test('should reset', () {
          final version = VersionConversion.fromString('1.2.3+4');

          expect(
            version.nextPatch(modifyBuild: ModifyBuild.reset),
            '1.2.4+0',
          );
        });
      });
    });

    group('#nextBuild', () {
      test('should update to the correct version', () async {
        const versions = {
          '0.0.0': '0.0.0+1',
          '0.0.1': '0.0.1+1',
          '0.1.0': '0.1.0+1',
          '0.1.1': '0.1.1+1',
          '1.0.0': '1.0.0+1',
          '1.0.1': '1.0.1+1',
          '1.1.0': '1.1.0+1',
          '1.1.1': '1.1.1+1',
          '1.2.3': '1.2.3+1',
          '1.2.3+4': '1.2.3+5',
          '1.2.3-beta': '1.2.3-beta+1',
          '1.2.3-prerelease+5': '1.2.3-prerelease+6',
        };

        for (final MapEntry(:key, :value) in versions.entries) {
          final version = VersionConversion.fromString(key);
          expect(version.nextBuild, value);
        }
      });
    });
  });
}
