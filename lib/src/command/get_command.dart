import 'package:args/command_runner.dart';
import 'package:pub_version_plus/src/util/pubspec_handler.dart';

class GetCommand extends Command<int> {
  GetCommand(this.pubspecHandler);

  final PubspecHandler pubspecHandler;

  @override
  String get description => 'Gets the current version in the pubspec.yaml file';

  @override
  String get name => 'get';

  @override
  Future<int> run() async {
    await pubspecHandler.initialize();

    final version = pubspecHandler.version;

    print(version);

    return 0;
  }
}
