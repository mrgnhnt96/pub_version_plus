import '/src/command/version_commmand.dart';

import '/src/util/enum.dart';

class PatchCommand extends VersionCommand {
  PatchCommand(String path) : super(path);

  @override
  PubVersion get type => PubVersion.patch;

  @override
  String get description => PubVersion.patch.description;

  @override
  String get name => PubVersion.patch.name;
}
