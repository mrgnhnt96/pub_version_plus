import '/src/command/version_commmand.dart';

import '/src/util/enum.dart';

class BuildCommand extends VersionCommand {
  BuildCommand(String path) : super(path);

  @override
  PubVersion get type => PubVersion.build;

  @override
  String get description => PubVersion.build.description;

  @override
  String get name => PubVersion.build.name;
}
