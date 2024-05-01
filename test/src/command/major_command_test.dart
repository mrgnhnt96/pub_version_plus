import 'package:pub_version_plus/src/command/major_command.dart';
import 'package:pub_version_plus/src/util/pub_version.dart';

import '../../util/pubspec.dart';
import '../../util/version_command_test_util.dart';

void main() {
  VersionCommandTestUtil.runTests<MajorCommand>(
    initializer: () => MajorCommand(pubspecWithVersion),
    type: PubVersion.major,
  );
}
