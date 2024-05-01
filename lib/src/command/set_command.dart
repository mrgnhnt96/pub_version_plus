import 'package:args/command_runner.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:pub_version_plus/src/util/pubspec_handler.dart';
import 'package:pub_version_plus/src/util/version_message.dart';

class SetCommand extends Command<int> {
  SetCommand(this.pubspecHandler) {
    argParser.addFlag(
      'force',
      abbr: 'f',
      help:
          'Forces the version to be set, even if the new version is less than the current version',
      negatable: false,
      defaultsTo: false,
    );
  }

  final PubspecHandler pubspecHandler;

  @override
  String get description => 'Sets the current version in the pubspec.yaml file';

  @override
  String get name => 'set';

  bool checkVersionFormat(String version) {
    try {
      final _ = Version.parse(version);

      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<int> run([List<String>? suppliedArgs]) async {
    final argResults = this.argResults ?? argParser.parse(suppliedArgs ?? []);
    final args = [...argResults.rest];

    if (args.isEmpty) {
      print('No version provided');
      return 1;
    }

    if (args.length > 1) {
      print('Only one version can be provided');
      return 1;
    }

    final version = args.first;

    // make sure that the version is valid
    if (!checkVersionFormat(version)) {
      print('Invalid version format, must be x.y.z or x.y.z+b');
      return 1;
    }

    await pubspecHandler.initialize();

    final newVersion = Version.parse(version);

    final force = argResults['force'] as bool?;

    if (!(force ?? false)) {
      final version = pubspecHandler.version;

      if (newVersion < version) {
        print(
            'The new version must be greater than the current version, ($version)');
        return 1;
      } else if (newVersion == version) {
        print('The new version is the same as the current version, exiting');
        return 0;
      }
    }

    final result = await pubspecHandler.setVersion(version);

    print(result.message);

    return 0;
  }
}
