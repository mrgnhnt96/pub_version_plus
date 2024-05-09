import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:pub_version_plus/src/util/pubspec_handler.dart';
import 'package:test/test.dart';

void main() {
  group('$PubspecHandler', () {
    late FileSystem fs;

    setUp(() {
      fs = MemoryFileSystem.test();
    });

    group('#nextMajorVersion', () {
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
          '1.2.3-4': '2.0.0',
          '1.2.3-4+5': '2.0.0+5',
        };

        final pubspec = fs.file('pubspec.yaml');
        pubspec.createSync();
        final handler = PubspecHandler('pubspec.yaml', fs: fs);

        for (final entry in versions.entries) {
          pubspec.writeAsStringSync('''
name: test
version: ${entry.key}
''');

          await handler.initialize();

          expect(
            handler.nextMajorVersion(modifyBuild: ModifyBuild.none),
            entry.value,
          );
        }
      });

      group('modify build number', () {
        test('should increment', () async {
          final pubspec = fs.file('pubspec.yaml');
          pubspec.createSync();
          final handler = PubspecHandler('pubspec.yaml', fs: fs);

          pubspec.writeAsStringSync('''
name: test
version: 1.2.3+4''');

          await handler.initialize();

          expect(
            handler.nextMajorVersion(modifyBuild: ModifyBuild.increment),
            '2.0.0+5',
          );
        });

        test('should remove', () async {
          final pubspec = fs.file('pubspec.yaml');
          pubspec.createSync();
          final handler = PubspecHandler('pubspec.yaml', fs: fs);

          pubspec.writeAsStringSync('''
name: test
version: 1.2.3+4''');

          await handler.initialize();

          expect(
            handler.nextMajorVersion(modifyBuild: ModifyBuild.remove),
            '2.0.0',
          );
        });

        test('should reset', () {
          final pubspec = fs.file('pubspec.yaml');
          pubspec.createSync();
          final handler = PubspecHandler('pubspec.yaml', fs: fs);

          pubspec.writeAsStringSync('''
name: test
version: 1.2.3+4''');

          handler.initialize().then((_) {
            expect(
              handler.nextMajorVersion(modifyBuild: ModifyBuild.reset),
              '2.0.0+0',
            );
          });
        });
      });
    });

    group('#nextMinorVersion', () {
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
          '1.2.3-4': '1.3.0',
          '1.2.3-4+5': '1.3.0+5',
        };

        final pubspec = fs.file('pubspec.yaml');
        pubspec.createSync();
        final handler = PubspecHandler('pubspec.yaml', fs: fs);

        for (final entry in versions.entries) {
          pubspec.writeAsStringSync('''
name: test
version: ${entry.key}''');

          await handler.initialize();

          expect(
            handler.nextMinorVersion(modifyBuild: ModifyBuild.none),
            entry.value,
          );
        }
      });

      group('modify build number', () {
        test('should increment', () async {
          final pubspec = fs.file('pubspec.yaml');
          pubspec.createSync();
          final handler = PubspecHandler('pubspec.yaml', fs: fs);

          pubspec.writeAsStringSync('''
name: test
version: 1.2.3+4''');

          await handler.initialize();

          expect(
            handler.nextMinorVersion(modifyBuild: ModifyBuild.increment),
            '1.3.0+5',
          );
        });

        test('should remove', () async {
          final pubspec = fs.file('pubspec.yaml');
          pubspec.createSync();
          final handler = PubspecHandler('pubspec.yaml', fs: fs);

          pubspec.writeAsStringSync('''
name: test
version: 1.2.3+4''');

          await handler.initialize();

          expect(
            handler.nextMinorVersion(modifyBuild: ModifyBuild.remove),
            '1.3.0',
          );
        });

        test('should reset', () {
          final pubspec = fs.file('pubspec.yaml');
          pubspec.createSync();
          final handler = PubspecHandler('pubspec.yaml', fs: fs);

          pubspec.writeAsStringSync('''
name: test
version: 1.2.3+4''');

          handler.initialize().then((_) {
            expect(
              handler.nextMinorVersion(modifyBuild: ModifyBuild.reset),
              '1.3.0+0',
            );
          });
        });
      });
    });

    group('#nextPatchVersion', () {
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
          // next patch strips the pre-release
          '1.2.3-4': '1.2.3',
          '1.2.3-4+5': '1.2.3+5',
        };

        final pubspec = fs.file('pubspec.yaml');
        pubspec.createSync();
        final handler = PubspecHandler('pubspec.yaml', fs: fs);

        for (final entry in versions.entries) {
          pubspec.writeAsStringSync('''
name: test
version: ${entry.key}''');

          await handler.initialize();

          expect(
            handler.nextPatchVersion(modifyBuild: ModifyBuild.none),
            entry.value,
          );
        }
      });

      group('modify build number', () {
        test('should increment', () async {
          final pubspec = fs.file('pubspec.yaml');
          pubspec.createSync();
          final handler = PubspecHandler('pubspec.yaml', fs: fs);

          pubspec.writeAsStringSync('''
name: test
version: 1.2.3+4''');

          await handler.initialize();

          expect(
            handler.nextPatchVersion(modifyBuild: ModifyBuild.increment),
            '1.2.4+5',
          );
        });

        test('should remove', () async {
          final pubspec = fs.file('pubspec.yaml');
          pubspec.createSync();
          final handler = PubspecHandler('pubspec.yaml', fs: fs);

          pubspec.writeAsStringSync('''
name: test
version: 1.2.3+4''');

          await handler.initialize();

          expect(
            handler.nextPatchVersion(modifyBuild: ModifyBuild.remove),
            '1.2.4',
          );
        });

        test('should reset', () {
          final pubspec = fs.file('pubspec.yaml');
          pubspec.createSync();
          final handler = PubspecHandler('pubspec.yaml', fs: fs);

          pubspec.writeAsStringSync('''
name: test
version: 1.2.3+4''');

          handler.initialize().then((_) {
            expect(
              handler.nextPatchVersion(modifyBuild: ModifyBuild.reset),
              '1.2.4+0',
            );
          });
        });
      });
    });

    group('#nextBuildVersion', () {
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
          '1.2.3-4': '1.2.3+1',
          '1.2.3-4+5': '1.2.3+6',
        };

        final pubspec = fs.file('pubspec.yaml');
        pubspec.createSync();
        final handler = PubspecHandler('pubspec.yaml', fs: fs);

        for (final entry in versions.entries) {
          pubspec.writeAsStringSync('''
name: test
version: ${entry.key}''');

          await handler.initialize();

          expect(handler.nextBuildVersion, entry.value);
        }
      });
    });
  });
}
