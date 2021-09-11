import 'package:pub_version_plus/src/command_runner.dart';
import 'package:test/test.dart';

void main() {
  group('PubVersionCommandRunner', () {
    test('major should return with a 0 exit code ', () async {
      final exitCode = await run(['major']);

      expect(exitCode, equals(0));
    });
    test('minor should return with a 0 exit code ', () async {
      final exitCode = await run(['minor']);

      expect(exitCode, equals(0));
    });
    test('patch should return with a 0 exit code ', () async {
      final exitCode = await run(['patch']);

      expect(exitCode, equals(0));
    });
  });
}
