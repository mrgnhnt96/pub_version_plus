import '/src/command/version_commmand.dart';

import '/src/util/enum.dart';

class MajorCommand extends VersionCommand {
  MajorCommand(String path) : super(path);

  @override
  PubVersion get type => PubVersion.major;

  @override
  String get description => PubVersion.major.description;

  @override
  String get name => PubVersion.major.name;
}
