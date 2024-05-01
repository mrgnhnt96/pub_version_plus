import 'package:pub_version_plus/src/command/version_command.dart';
import 'package:pub_version_plus/src/util/pub_version.dart';

class MajorCommand extends VersionCommand {
  MajorCommand(String path) : super(path);

  @override
  PubVersion get type => PubVersion.major;

  @override
  String get description => PubVersion.major.description;

  @override
  String get name => PubVersion.major.name;
}
