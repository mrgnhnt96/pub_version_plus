import 'dart:async';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:pub_version_plus/src/util/pub_version.dart';
import 'package:pub_version_plus/src/util/util.dart';
import 'package:pub_version_plus/src/version.dart';

export 'util/util.dart' show appName, appDescription;

Future<int?> run(List<String> args) => _CommandRunner().run(args);

class _CommandRunner extends CommandRunner<int> {
  _CommandRunner() : super(appName, appDescription) {
    argParser.addFlag(
      'version',
      negatable: false,
      help: 'Prints the version of pubversion.',
    );

    final pubspecPath = 'pubspec.yaml';

    for (final e in PubVersion.values) {
      addCommand(e.command(pubspecPath));
    }
  }

  @override
  Future<int> runCommand(ArgResults topLevelResults) async {
    if (topLevelResults['version'] as bool) {
      print('Update version to: $packageVersion');
      return 0;
    }

    // In the case of `help`, `null` is returned. Treat that as success.
    return await super.runCommand(topLevelResults) ?? 0;
  }
}
