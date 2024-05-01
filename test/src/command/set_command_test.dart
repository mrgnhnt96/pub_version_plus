import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:pub_version_plus/src/command/set_command.dart';
import 'package:pub_version_plus/src/util/pubspec_handler.dart';
import 'package:test/test.dart';

void main() {
  group('$SetCommand', () {
    late FileSystem fs;
    late SetCommand command;
    late File pubspec;

    setUp(() async {
      fs = MemoryFileSystem();
      pubspec = fs.file('pubspec.yaml');

      await pubspec.create();
      await pubspec.writeAsString('''
name: test
version: 1.0.0
''');

      command = SetCommand(PubspecHandler(pubspec.path, fs: fs));
    });

    test('sets the version when version is larger', () async {
      final result = await command.run(['2.0.0']);

      expect(result, 0);

      final contents = await pubspec.readAsString();

      expect(contents, contains('version: 2.0.0'));
    });

    test('sets the version when version is equal', () async {
      final result = await command.run(['1.0.0']);

      expect(result, 0);

      final contents = await pubspec.readAsString();

      expect(contents, contains('version: 1.0.0'));
    });

    test('sets the version when force is true', () async {
      final result = await command.run(['0.1.0', '--force']);

      expect(result, 0);

      final contents = await pubspec.readAsString();

      expect(contents, contains('version: 0.1.0'));
    });

    test('fails when version is smaller', () async {
      final result = await command.run(['0.1.0']);

      expect(result, 1);

      final contents = await pubspec.readAsString();

      expect(contents, contains('version: 1.0.0'));
    });
  });
}
