import 'package:pub_version_plus/src/util/modify_build.dart';
import 'package:pub_version_plus/src/util/version_conversion.dart';
import 'package:test/test.dart';

void main() {
  group(VersionConversion, () {
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
