import 'dart:async';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:file/file.dart';
import 'package:pub_version_plus/src/command/get_command.dart';
import 'package:pub_version_plus/src/command/set_command.dart';
import 'package:pub_version_plus/src/util/pub_version.dart';
import 'package:pub_version_plus/src/util/pubspec_handler.dart';
import 'package:pub_version_plus/src/util/util.dart';
import 'package:pub_version_plus/src/version.dart';

export 'util/util.dart' show appName, appDescription;

class PubVersionRunner extends CommandRunner<int> {
  PubVersionRunner({required this.fs}) : super(appName, appDescription) {
    argParser.addFlag(
      'version',
      negatable: false,
      help: 'Prints the version of pubversion.',
    );

    final pubspecPath = 'pubspec.yaml';

    for (final e in PubVersion.values) {
      addCommand(e.command(pubspecPath, fs: fs));
    }

    addCommand(SetCommand(PubspecHandler(pubspecPath, fs: fs)));
    addCommand(GetCommand(PubspecHandler(pubspecPath, fs: fs)));
  }

  final FileSystem fs;

  @override
  Future<int> runCommand(ArgResults topLevelResults) async {
    if (topLevelResults['version'] as bool) {
      print('New version available: $version');
      return 0;
    }

    // In the case of `help`, `null` is returned. Treat that as success.
    return await super.runCommand(topLevelResults) ?? 0;
  }
}
