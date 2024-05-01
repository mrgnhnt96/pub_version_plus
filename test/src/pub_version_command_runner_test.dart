import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:pub_version_plus/src/command_runner.dart';
import 'package:test/test.dart';

void main() {
  group('$PubVersionRunner', () {
    late MemoryFileSystem fs;
    late PubVersionRunner runner;
    late File pubspec;

    setUp(() async {
      fs = MemoryFileSystem.test();
      runner = PubVersionRunner(fs: fs);

      pubspec = fs.file('pubspec.yaml');

      await pubspec.create();

      await pubspec.writeAsString('''
name: test
version: 0.0.1
''');
    });

    test('major should return with a 0 exit code ', () async {
      final exitCode = await runner.run(['major']);
      expect(exitCode, equals(0));

      final content = await pubspec.readAsString();
      expect(content, contains('version: 1.0.0'));
    });

    test('minor should return with a 0 exit code ', () async {
      final exitCode = await runner.run(['minor']);
      expect(exitCode, equals(0));

      final content = await pubspec.readAsString();
      expect(content, contains('version: 0.1.0'));
    });

    test('patch should return with a 0 exit code ', () async {
      final exitCode = await runner.run(['patch']);
      expect(exitCode, equals(0));

      final content = await pubspec.readAsString();
      expect(content, contains('version: 0.0.2'));
    });

    test('build should return with a 0 exit code ', () async {
      final exitCode = await runner.run(['build']);
      expect(exitCode, equals(0));

      final content = await pubspec.readAsString();
      expect(content, contains('version: 0.0.1+1'));
    });
  });
}
