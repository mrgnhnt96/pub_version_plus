import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:args/command_runner.dart';
import 'package:file/local.dart';
import 'package:io/ansi.dart';
import 'package:io/io.dart';
import 'package:pub_version_plus/pub_version_plus.dart';

Future main(List<String> args) async {
  try {
    const fileSystem = LocalFileSystem();

    exitCode = await PubVersionRunner(
          fs: fileSystem,
        ).run(args) ??
        -1;
  } on UsageException catch (e) {
    print(red.wrap(e.message));
    print(' ');
    print(e.usage);
    exitCode = ExitCode.usage.code;
  } on FileSystemException catch (e) {
    print(red.wrap('pub_version_plus could not run in the current directory.'));
    print(e.message);
    if (e.path != null) {
      print('  ${e.path}');
    }
    exitCode = ExitCode.config.code;
  } on IsolateSpawnException catch (e) {
    print(red.wrap('pub_version_plus failed with an unexpected exception.'));
    print(e.message);
    exitCode = ExitCode.software.code;
  }
}
