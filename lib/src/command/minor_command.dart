import 'package:pub_version_plus/src/command/version_command.dart';
import 'package:pub_version_plus/src/util/pub_version.dart';

class MinorCommand extends VersionCommand {
  MinorCommand(String path, {required super.fs}) : super(path);

  @override
  PubVersion get type => PubVersion.minor;

  @override
  String get description => PubVersion.minor.description;

  @override
  String get name => PubVersion.minor.name;
}
