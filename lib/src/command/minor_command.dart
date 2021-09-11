import '/src/command/version_commmand.dart';

import '/src/util/enum.dart';

class MinorCommand extends VersionCommand {
  MinorCommand(String path) : super(path);

  @override
  PubVersion get type => PubVersion.minor;

  @override
  String get description => PubVersion.minor.description;

  @override
  String get name => PubVersion.minor.name;
}
