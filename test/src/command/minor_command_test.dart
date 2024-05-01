import 'package:file/memory.dart';
import 'package:pub_version_plus/src/command/minor_command.dart';
import 'package:pub_version_plus/src/util/pub_version.dart';
import 'package:test/test.dart';

import '../../util/pubspec.dart';
import '../../util/version_command_test_util.dart';

void main() {
  late MemoryFileSystem fs;
  late Pubspec pubspec;

  setUp(() async {
    fs = MemoryFileSystem();
    pubspec = pubspecWithVersion;

    await pubspec.write(fs);
  });

  VersionCommandTestUtil.runTests(
    initializer: () => MinorCommand(pubspec.path, fs: fs),
    type: PubVersion.minor,
  );
}
