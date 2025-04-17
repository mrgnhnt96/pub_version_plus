import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:pub_version_plus/src/pub_version_runner.dart';
import 'package:test/test.dart';

void main() {
  group('$PubVersionRunner', () {
    late MemoryFileSystem fs;
    late PubVersionRunner runner;
    late File pubspec;

    setUp(() {
      fs = MemoryFileSystem.test();

      pubspec = fs.file('pubspec.yaml');

      pubspec.createSync(recursive: true);

      pubspec.writeAsStringSync('''
name: test
version: 0.0.1
''');

      runner = PubVersionRunner(fs: fs);
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
