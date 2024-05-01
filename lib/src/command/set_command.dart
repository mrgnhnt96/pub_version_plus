import 'package:args/command_runner.dart';

class SetCommand extends Command<int> {
  SetCommand() {
    argParser.addOption(
      'version',
      abbr: 'v',
      help: 'The version to set in the pubspec.yaml file',
    );
  }

  @override
  String get description => 'Sets the current version in the pubspec.yaml file';

  @override
  String get name => 'set';
}
