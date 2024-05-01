import 'package:pub_version_plus/src/command/minor_command.dart';
import 'package:pub_version_plus/src/util/pub_version.dart';

import '../../util/pubspec.dart';
import '../../util/version_command_test_util.dart';

void main() {
  VersionCommandTestUtil.runTests<MinorCommand>(
    initializer: () => MinorCommand(pubspecWithVersion),
    type: PubVersion.minor,
  );
}
