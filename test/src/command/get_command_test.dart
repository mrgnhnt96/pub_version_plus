import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:pub_version_plus/src/command/get_command.dart';
import 'package:pub_version_plus/src/util/pubspec_handler.dart';
import 'package:test/test.dart';

void main() {
  group('$GetCommand', () {
    late FileSystem fs;
    late GetCommand command;

    setUp(() async {
      fs = MemoryFileSystem();
      final pubspec = fs.file('pubspec.yaml');

      await pubspec.create();
      await pubspec.writeAsString('''
name: test
version: 1.0.0
''');

      command = GetCommand(PubspecHandler(pubspec.path, fs: fs));
    });

    test('gets the version', () async {
      final result = await command.run();

      expect(result, 0);
    });
  });
}
