import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:file/file.dart';
import 'package:pub_version_plus/src/util/modify_build.dart';
import 'package:pub_version_plus/src/util/pub_version.dart';
import 'package:pub_version_plus/src/util/pubspec_handler.dart';
import 'package:pub_version_plus/src/util/version_message.dart';

abstract class VersionCommand extends Command<int> {
  VersionCommand(this.path, {required FileSystem fs})
      : handler = PubspecHandler(path, fs: fs) {
    argParser
      ..addOption(
        'build',
        abbr: 'b',
        allowed: [
          for (final build in ModifyBuild.values) build.name,
        ],
        help: 'How to modify the build number.',
        defaultsTo: ModifyBuild.increment.name,
        allowedHelp: {
          for (final build in ModifyBuild.values) build.name: build.description,
        },
      )
      ..addOption(
        'pre-release',
        abbr: 'p',
        help: 'The pre-release to use.',
        valueHelp: 'alpha',
      );
  }

  final String path;
  final PubspecHandler handler;

  PubVersion get type;

  @override
  final argParser = ArgParser(usageLineLength: 80);

  @override
  String get name;

  @override
  String get description;

  void checkUnsupported() {
    var unsupported =
        argResults?.rest.where((arg) => !arg.startsWith('-')).toList();
    if (unsupported != null && unsupported.isNotEmpty) {
      throw UsageException(
          'Arguments were provided that are not supported: '
          "'${unsupported.join(' ')}'.",
          argParser.usage);
    }
  }

  String? get preRelease {
    return switch (argResults?['pre-release']) {
      final String value when value.trim().isNotEmpty => value.trim(),
      _ => null,
    };
  }

  @override
  Future<int> run() => increaseVersion();

  Future<int> increaseVersion() async {
    checkUnsupported();
    await handler.initialize();

    final modifyBuild =
        ModifyBuild.values.byName(argResults!['build'] as String);

    final message = await handler.nextVersion(
      type,
      modifyBuild: modifyBuild,
      preRelease: preRelease,
    );

    return message.code;
  }
}
